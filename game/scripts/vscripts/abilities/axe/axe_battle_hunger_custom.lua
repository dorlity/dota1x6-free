LinkLuaModifier( "modifier_axe_battle_hunger_custom_buff", "abilities/axe/axe_battle_hunger_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_battle_hunger_custom_creep", "abilities/axe/axe_battle_hunger_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_battle_hunger_custom_hero", "abilities/axe/axe_battle_hunger_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_battle_hunger_custom_debuff", "abilities/axe/axe_battle_hunger_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_battle_hunger_custom_str_buff", "abilities/axe/axe_battle_hunger_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_battle_hunger_custom_str_buff_counter", "abilities/axe/axe_battle_hunger_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_battle_hunger_custom_str_silence", "abilities/axe/axe_battle_hunger_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_battle_hunger_custom_tracker", "abilities/axe/axe_battle_hunger_custom", LUA_MODIFIER_MOTION_NONE )

axe_battle_hunger_custom = class({})

axe_battle_hunger_custom.scepter_armor = 7








function axe_battle_hunger_custom:Precache(context)

    
PrecacheResource( "particle", "particles/units/heroes/hero_doom_bringer/doom_infernal_blade_impact.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_axe/axe_battle_hunger.vpcf", context )

end




function axe_battle_hunger_custom:GetCooldown(level)
	if self:GetCaster():HasModifier("modifier_axe_hunger_6") then
		return self.BaseClass.GetCooldown( self, level ) + self:GetCaster():GetTalentValue("modifier_axe_hunger_6", "cd")
	end
    return self.BaseClass.GetCooldown( self, level )
end


function axe_battle_hunger_custom:CastFilterResultTarget(target)
	if target:GetTeamNumber() == self:GetCaster():GetTeamNumber() and self:GetCaster() ~= target and self:GetCaster():HasModifier("modifier_axe_hunger_5") then
		return UF_FAIL_FRIENDLY 
	end

	if target ~= nil and target:IsMagicImmune() then
		return UF_FAIL_MAGIC_IMMUNE_ENEMY
	end

	if not self:GetCaster():HasModifier("modifier_axe_hunger_5") then 
		return UnitFilter(target, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, self:GetCaster():GetTeamNumber())
	else 	
		return UnitFilter(target, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, self:GetCaster():GetTeamNumber())
	end
end




function axe_battle_hunger_custom:GetIntrinsicModifierName()
return "modifier_axe_battle_hunger_custom_tracker"
end



function axe_battle_hunger_custom:OnSpellStart(new_target)
if not IsServer() then return end
	local target = self:GetCursorTarget()

	if new_target ~= nil then 
		target = new_target
	end

	if target == self:GetCaster() then 
		self:GetCaster():Purge(false, true, false, false, false)
	end

	local duration = self:GetSpecialValueFor("duration")
	if target:TriggerSpellAbsorb( self ) then return end
	

	if target ~= self:GetCaster() and self:GetCaster():HasModifier("modifier_axe_hunger_legendary") then 
		duration = self:GetCaster():GetTalentValue("modifier_axe_hunger_legendary", "duration")
	end

	target:AddNewModifier( self:GetCaster(), self, "modifier_axe_battle_hunger_custom_debuff", { duration = duration } )
	
	local mod = self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_axe_battle_hunger_custom_buff", {target = target:entindex(),  duration = duration } )


	target:EmitSound("Hero_Axe.Battle_Hunger")
end





modifier_axe_battle_hunger_custom_buff = class({})

function modifier_axe_battle_hunger_custom_buff:IsPurgable()
	return false
end

function modifier_axe_battle_hunger_custom_buff:IsHidden()
return true 
end


function modifier_axe_battle_hunger_custom_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}

	return funcs
end

function modifier_axe_battle_hunger_custom_buff:GetModifierMoveSpeedBonus_Percentage()
	return self.speed
end


function modifier_axe_battle_hunger_custom_buff:GetModifierPhysicalArmorBonus()
if self:GetCaster():HasScepter() then 
	return (self:GetAbility().scepter_armor/2)*self:GetCaster():GetUpgradeStack("modifier_axe_battle_hunger_custom_creep") + self:GetAbility().scepter_armor*self:GetCaster():GetUpgradeStack("modifier_axe_battle_hunger_custom_hero")
end

return
end


function modifier_axe_battle_hunger_custom_buff:OnCreated()

self.speed = self:GetCaster():GetTalentValue("modifier_axe_hunger_3", "speed")
end 




modifier_axe_battle_hunger_custom_debuff = class({})

function modifier_axe_battle_hunger_custom_debuff:IsPurgable()
if not self:GetCaster() or self:GetCaster():IsNull() then return end
	return not self:GetCaster():HasModifier("modifier_axe_hunger_legendary")
end


function modifier_axe_battle_hunger_custom_debuff:OnCreated( kv )
self.slow = self:GetAbility():GetSpecialValueFor( "slow" ) + self:GetCaster():GetTalentValue("modifier_axe_hunger_3", "slow")
self.damage = self:GetAbility():GetSpecialValueFor( "damage_per_second" )

self.self_heal = self:GetCaster():GetTalentValue("modifier_axe_hunger_5", "heal")/100

self.silence_duration = self:GetCaster():GetTalentValue("modifier_axe_hunger_6", "silence")
self.silence_timer = self:GetCaster():GetTalentValue("modifier_axe_hunger_6", "timer")

self.legendary_multi = self:GetCaster():GetTalentValue("modifier_axe_hunger_legendary", "multi")
self.legendary_timer = self:GetCaster():GetTalentValue("modifier_axe_hunger_legendary", "timer")
self.legendary_max = self:GetCaster():GetTalentValue("modifier_axe_hunger_legendary", "max")

local caster = self:GetCaster()

self.stone_angle = 85
self.facing = false


self:SetStackCount( 0 )

self.reduce_attack = self:GetCaster():GetTalentValue("modifier_axe_hunger_2", "reduce_attack")
self.reduce_magic = self:GetCaster():GetTalentValue("modifier_axe_hunger_2", "reduce_magic")


local caster = self:GetCaster()
if self:GetCaster().owner ~= nil then 
	caster = self:GetCaster().owner
end


self.armor = -1*self:GetAbility().scepter_armor
if not IsServer() then return end

local name = "modifier_axe_battle_hunger_custom_creep"
if self:GetParent():IsHero() then 
	name = "modifier_axe_battle_hunger_custom_hero"
end


self.count = -1
self.legendary_count = -1
self.legendary_damage = 0

self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), name, {})

self:StartIntervalThink( 1 )
self:OnIntervalThink()
end



function modifier_axe_battle_hunger_custom_debuff:OnRefresh()
if not IsServer() then return end

end

function modifier_axe_battle_hunger_custom_debuff:OnDestroy( kv )
if not IsServer() then return end
if not self:GetCaster() or self:GetCaster():IsNull() then return end

local name = "modifier_axe_battle_hunger_custom_creep"
if self:GetParent():IsHero() then 
	name = "modifier_axe_battle_hunger_custom_hero"
end

local mod = self:GetCaster():FindModifierByName(name)
if mod then 
	mod:DecrementStackCount()
	if mod:GetStackCount() == 0 then
		mod:Destroy()
	end
end


if not self:GetCaster():HasModifier("modifier_axe_battle_hunger_custom_hero") and not self:GetCaster():HasModifier("modifier_axe_battle_hunger_custom_creep") then 
	if self:GetCaster():HasModifier("modifier_axe_battle_hunger_custom_buff") then 
		self:GetCaster():RemoveModifierByName("modifier_axe_battle_hunger_custom_buff")
	end
end

end

function modifier_axe_battle_hunger_custom_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_TOOLTIP,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
    MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE
	}

	return funcs
end




function modifier_axe_battle_hunger_custom_debuff:GetModifierDamageOutgoing_Percentage()

if not self:GetCaster() or self:GetCaster():IsNull() then return end
if self:GetCaster() == self:GetParent() then return end

local bonus = 0
if self:GetCaster():HasModifier("modifier_axe_hunger_2") then 
	bonus = self.reduce_attack
end

return bonus
end

function modifier_axe_battle_hunger_custom_debuff:GetModifierSpellAmplify_Percentage() 

if not self:GetCaster() or self:GetCaster():IsNull() then return end
if self:GetCaster() == self:GetParent() then return end

local bonus = 0
if self:GetCaster():HasModifier("modifier_axe_hunger_2") then 
	bonus = self.reduce_magic
end

return bonus
end


function modifier_axe_battle_hunger_custom_debuff:GetModifierPhysicalArmorBonus()

if not self:GetCaster() or self:GetCaster():IsNull() then return end
if self:GetCaster() == self:GetParent() then return end
if self:GetCaster():HasScepter() then 
	return self.armor
end

return
end

function modifier_axe_battle_hunger_custom_debuff:OnDeath( params )
if not IsServer() then return end

if not self:GetCaster() or self:GetCaster():IsNull() then return end
if self:GetCaster():HasModifier("modifier_axe_hunger_legendary") then return end
if params.attacker~=self:GetParent() then return end
if self:GetCaster() == self:GetParent() then return end
	self:Destroy()
end

function modifier_axe_battle_hunger_custom_debuff:GetModifierMoveSpeedBonus_Percentage()
if not IsServer() then return end

if not self:GetCaster() or self:GetCaster():IsNull() then return end
if self:GetCaster() == self:GetParent() then return end
	local vector = (self:GetCaster():GetAbsOrigin()-self:GetParent():GetAbsOrigin()):Normalized()

	local center_angle = VectorToAngles( vector ).y
	local facing_angle = VectorToAngles( self:GetParent():GetForwardVector() ).y


	local facing = ( math.abs( AngleDiff(center_angle,facing_angle) ) > self.stone_angle ) 

	if facing then
		return self.slow
	end
end



function modifier_axe_battle_hunger_custom_debuff:OnIntervalThink()
if not IsServer() then return end
if not self:GetCaster() or self:GetCaster():IsNull() then 
	self:Destroy()
	return
end

if self:GetCaster():GetQuest() == "Axe.Quest_6" and self:GetParent():IsRealHero() and self:GetParent() ~= self:GetCaster() and not self:GetCaster():QuestCompleted() then 
	self:GetCaster():UpdateQuest(1)
end

if self:GetCaster():HasModifier("modifier_axe_hunger_6") and self:GetCaster() ~= self:GetParent() then 
	self.count = self.count + 1
end

if self.count >= self.silence_timer then 
	self.count = 0
	self:GetParent():EmitSound("Sf.Raze_Silence")
	self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_axe_battle_hunger_custom_str_silence", {duration = (1 - self:GetParent():GetStatusResistance())*self.silence_duration})
end

if self:GetCaster():HasModifier("modifier_axe_hunger_legendary") and self:GetCaster() ~= self:GetParent() then 
	self.legendary_count = self.legendary_count + 1
end

if self.legendary_count >= self.legendary_timer and self:GetStackCount() < self.legendary_max then 
	local effect_target = ParticleManager:CreateParticle( "particles/units/heroes/hero_doom_bringer/doom_infernal_blade_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( effect_target, 0, self:GetParent():GetAbsOrigin() )
	ParticleManager:ReleaseParticleIndex( effect_target )
	self:GetParent():EmitSound("Axe.Hunger_damage")

	self.legendary_count = 0
	
	self:SetStackCount(self:GetStackCount() + self.legendary_multi)
	SendOverheadEventMessage(self:GetParent(), 2, self:GetParent(), self:GetStackCount(), nil)
end


if self:GetCaster():HasModifier("modifier_axe_hunger_4") and self:GetParent() ~= self:GetCaster() then 

	local duration = self:GetCaster():GetTalentValue("modifier_axe_hunger_4", "duration")

	if self:GetParent():IsCreep() then 
		--duration = duration/2
	end

	self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_axe_battle_hunger_custom_str_buff", {duration = duration})
	self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_axe_battle_hunger_custom_str_buff_counter", {duration = duration})

	self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_axe_battle_hunger_custom_str_buff", {duration = duration})
	self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_axe_battle_hunger_custom_str_buff_counter", {duration = duration})
	

end

local damage = self.damage	
local armor_k = self:GetAbility():GetSpecialValueFor("armor_multiplier") + self:GetStackCount()

if self:GetCaster():HasModifier("modifier_axe_hunger_1") then 
		armor_k = armor_k + self:GetCaster():GetTalentValue("modifier_axe_hunger_1", "damage")
end

damage = damage + armor_k*self:GetCaster():GetPhysicalArmorValue(false)

if self:GetCaster() == self:GetParent() then 

	local heal = damage*self.self_heal

	self:GetCaster():GenericHeal(heal, self:GetAbility())
else 

	local damageTable = { victim = self:GetParent(), attacker = self:GetCaster(), damage = damage, damage_type = DAMAGE_TYPE_PHYSICAL, ability = self:GetAbility(), damage_flags = DOTA_DAMAGE_FLAG_BYPASSES_BLOCK, }

	ApplyDamage( damageTable )
end

	
end

function modifier_axe_battle_hunger_custom_debuff:GetEffectName()
	return "particles/units/heroes/hero_axe/axe_battle_hunger.vpcf"
end

function modifier_axe_battle_hunger_custom_debuff:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end



modifier_axe_battle_hunger_custom_creep = class({})
function modifier_axe_battle_hunger_custom_creep:IsHidden() return true end
function modifier_axe_battle_hunger_custom_creep:IsPurgable() return false end

function modifier_axe_battle_hunger_custom_creep:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
end


function modifier_axe_battle_hunger_custom_creep:OnRefresh(table)
if not IsServer() then return end
self:IncrementStackCount()
end

modifier_axe_battle_hunger_custom_hero = class({})
function modifier_axe_battle_hunger_custom_hero:IsHidden() return true end
function modifier_axe_battle_hunger_custom_hero:IsPurgable() return false end
function modifier_axe_battle_hunger_custom_hero:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
end


function modifier_axe_battle_hunger_custom_hero:OnRefresh(table)
if not IsServer() then return end
self:IncrementStackCount()
end



modifier_axe_battle_hunger_custom_str_buff = class({})
function modifier_axe_battle_hunger_custom_str_buff:IsHidden() return true end
function modifier_axe_battle_hunger_custom_str_buff:IsPurgable() return false end
function modifier_axe_battle_hunger_custom_str_buff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_axe_battle_hunger_custom_str_buff:OnDestroy()
if not IsServer() then return end
local mod = self:GetParent():FindModifierByName("modifier_axe_battle_hunger_custom_str_buff_counter")
if mod then 
	mod:DecrementStackCount()
	if mod:GetStackCount() == 0 then 
		mod:Destroy()
	end
end

end

function modifier_axe_battle_hunger_custom_str_buff:OnCreated(table)
self.RemoveForDuel = true 
end


modifier_axe_battle_hunger_custom_str_buff_counter = class({})

function modifier_axe_battle_hunger_custom_str_buff_counter:IsHidden() return false end
function modifier_axe_battle_hunger_custom_str_buff_counter:GetTexture() return "buffs/hunger_str" end
function modifier_axe_battle_hunger_custom_str_buff_counter:IsPurgable() return false end

function modifier_axe_battle_hunger_custom_str_buff_counter:DeclareFunctions()
return
 { MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS } 
end

function modifier_axe_battle_hunger_custom_str_buff_counter:OnCreated(table)

self.armor = self:GetCaster():GetTalentValue("modifier_axe_hunger_4", "armor")

if not IsServer() then return end
self:SetStackCount(1) 
self.RemoveForDuel = true 
end


function modifier_axe_battle_hunger_custom_str_buff_counter:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
end

function modifier_axe_battle_hunger_custom_str_buff_counter:GetModifierPhysicalArmorBonus()
local bonus = self.armor 

if self:GetCaster() ~= self:GetParent() then 
	bonus = -1*bonus
end

return bonus*self:GetStackCount()
end


modifier_axe_battle_hunger_custom_str_silence = class({})

function modifier_axe_battle_hunger_custom_str_silence:IsHidden() return false end

function modifier_axe_battle_hunger_custom_str_silence:IsPurgable() return true end

function modifier_axe_battle_hunger_custom_str_silence:CheckState() return {[MODIFIER_STATE_SILENCED] = true} end


function modifier_axe_battle_hunger_custom_str_silence:GetEffectName() return "particles/generic_gameplay/generic_silenced.vpcf" end
 
function modifier_axe_battle_hunger_custom_str_silence:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end



modifier_axe_battle_hunger_custom_tracker = class({})
function modifier_axe_battle_hunger_custom_tracker:IsHidden() return true end
function modifier_axe_battle_hunger_custom_tracker:IsPurgable() return false end
function modifier_axe_battle_hunger_custom_tracker:OnCreated(table)
if not IsServer() then return end

self.legendary_radius = self:GetCaster():GetTalentValue("modifier_axe_hunger_legendary", "radius", true)
self.legendary_duration = self:GetCaster():GetTalentValue("modifier_axe_hunger_legendary", "duration", true)

self:StartIntervalThink(0.2)
end

function modifier_axe_battle_hunger_custom_tracker:OnIntervalThink()
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_axe_hunger_legendary") then return end
if not self:GetParent():IsAlive() then return end

local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self.legendary_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, 0, false )


for _,unit in pairs(units) do
	if unit:HasModifier("modifier_axe_battle_hunger_custom_debuff") then 
		unit:FindModifierByName("modifier_axe_battle_hunger_custom_debuff"):SetDuration(self.legendary_duration, true)
	
		if self:GetParent():HasModifier("modifier_axe_battle_hunger_custom_buff") then 
			self:GetParent():FindModifierByName("modifier_axe_battle_hunger_custom_buff"):SetDuration(self.legendary_duration, true)
		end
	end
end



end
