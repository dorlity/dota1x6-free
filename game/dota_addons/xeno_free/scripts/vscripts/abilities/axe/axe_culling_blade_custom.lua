LinkLuaModifier( "modifier_axe_culling_blade_custom", "abilities/axe/axe_culling_blade_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_culling_blade_custom_tracker", "abilities/axe/axe_culling_blade_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_culling_blade_custom_attack_kill", "abilities/axe/axe_culling_blade_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_culling_blade_custom_execute", "abilities/axe/axe_culling_blade_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_culling_blade_custom_kills", "abilities/axe/axe_culling_blade_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_culling_blade_custom_aegis", "abilities/axe/axe_culling_blade_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_culling_blade_custom_no_bonus", "abilities/axe/axe_culling_blade_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_culling_blade_custom_slow_lendary", "abilities/axe/axe_culling_blade_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_culling_blade_custom_target_mod", "abilities/axe/axe_culling_blade_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_culling_blade_custom_timer_kill", "abilities/axe/axe_culling_blade_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_culling_blade_custom_legendary", "abilities/axe/axe_culling_blade_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_culling_blade_custom_status", "abilities/axe/axe_culling_blade_custom", LUA_MODIFIER_MOTION_NONE )

axe_culling_blade_custom = class({})





axe_culling_blade_custom_legendary = class({})


axe_culling_blade_custom_legendary.save_mods = 
{
	[""] = true,
}



function axe_culling_blade_custom_legendary:Precache(context)

    
PrecacheResource( "particle", "particles/units/heroes/hero_axe/axe_culling_blade_kill.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_axe/axe_culling_blade.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_axe/axe_cullingblade_sprint.vpcf", context )
PrecacheResource( "particle", "particles/axe_culling_stack.vpcf", context )
PrecacheResource( "particle", "particles/items3_fx/blink_overwhelming_start.vpcf", context )
PrecacheResource( "particle", "particles/items3_fx/blink_overwhelming_end.vpcf", context )
PrecacheResource( "particle", "particles/axe_execute.vpcf", context )
PrecacheResource( "particle", "particles/axe_exe.vpcf", context )
PrecacheResource( "particle", "particles/brist_lowhp_.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_axe/axe_cullingblade_sprint.vpcf", context )
PrecacheResource( "particle", "particles/axe_slow.vpcf", context )

end




function axe_culling_blade_custom:GetCastRange(vLocation, hTarget)

local upgrade = 0
if self:GetCaster():HasModifier("modifier_axe_culling_3") then 
  --upgrade = self:GetCaster():GetTalentValue("modifier_axe_culling_3", "range")
end

return self.BaseClass.GetCastRange(self , vLocation , hTarget) + upgrade 
end


function axe_culling_blade_custom:GetCastPoint()
local bonus = 0


if self:GetCaster():HasModifier("modifier_axe_culling_5") then 
  bonus = self:GetCaster():GetTalentValue("modifier_axe_culling_5", "cast")
end

 return self:GetSpecialValueFor("AbilityCastPoint") + bonus
 
end



function axe_culling_blade_custom:GetCooldown()
local bonus = 0


if self:GetCaster():HasModifier("modifier_axe_culling_5") then 
  bonus = self:GetCaster():GetTalentValue("modifier_axe_culling_5", "cd")
end

 return self:GetSpecialValueFor("AbilityCooldown") + bonus
 
end




function axe_culling_blade_custom:GetManaCost(level)


return self.BaseClass.GetManaCost(self,level) 
end


function axe_culling_blade_custom:GetIntrinsicModifierName()
return "modifier_axe_culling_blade_custom_tracker"
end


function axe_culling_blade_custom:OnAbilityPhaseStart()

local k = 1
if self:GetCaster():HasModifier("modifier_axe_culling_5") then 
	k = 1.5
end 

self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_4, k)

return true
end 


function axe_culling_blade_custom:OnAbilityPhaseInterrupted()

self:GetCaster():FadeGesture(ACT_DOTA_CAST_ABILITY_4)
end 

function axe_culling_blade_custom:OnSpellStart(new_target)
if not IsServer() then return end
local target = self:GetCursorTarget()

--self:GetCaster():FadeGesture(ACT_DOTA_CAST_ABILITY_4)


if new_target then 
	target = new_target
end

local damage_mod = target:FindModifierByName("modifier_axe_culling_blade_custom_attack_kill")

local k = 1
local damage = self:GetSpecialValueFor("damage") + self:GetCaster():GetTalentValue("modifier_axe_culling_3","damage")

if damage_mod then 
	damage = damage + damage_mod:GetStackCount()*self:GetCaster():GetTalentValue("modifier_axe_culling_4", "damage")*target:GetMaxHealth()/100
end 

if not target:HasModifier("modifier_custom_juggernaut_healing_ward_reduction_aura") then 

	kill_mod = target:AddNewModifier(target, nil, "modifier_death", {})
	kill_mod_2 = target:AddNewModifier(target, nil, "modifier_axe_culling_blade_custom_aegis", {})
end

if target:GetHealth() > damage or target:HasModifier("modifier_custom_juggernaut_healing_ward_reduction_aura") then 

	ApplyDamage({ victim = target, attacker = self:GetCaster(), damage = damage, damage_type = DAMAGE_TYPE_PURE, ability = self, })	

	if self:GetCaster():HasModifier("modifier_axe_culling_6") then 
		target:AddNewModifier(self:GetCaster(), self, "modifier_axe_culling_blade_custom_timer_kill", {duration = self:GetCaster():GetTalentValue("modifier_axe_culling_6", "duration")})
	end 

else 
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_axe_culling_blade_custom_no_bonus", {})

	self:CullingBladeKill(target, true, true)
	target:Kill(self, self:GetCaster())
	self:GetCaster():RemoveModifierByName("modifier_axe_culling_blade_custom_no_bonus")
end

if not target:HasModifier("modifier_custom_juggernaut_healing_ward_reduction_aura") then 
	kill_mod:Destroy()
	kill_mod_2:Destroy()
end


end





function axe_culling_blade_custom:CullingBladeKill(target, success, effect)
if not IsServer() then return end


local direction = (target:GetOrigin()-self:GetCaster():GetOrigin()):Normalized()

local particle_cast = ""
local sound_cast = ""

if success then
	particle_cast = "particles/units/heroes/hero_axe/axe_culling_blade_kill.vpcf"
	sound_cast = "Hero_Axe.Culling_Blade_Success"
else
	particle_cast = "particles/units/heroes/hero_axe/axe_culling_blade.vpcf"
	sound_cast = "Hero_Axe.Culling_Blade_Fail"
end

if effect then 

	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControl( effect_cast, 4, target:GetOrigin() )
	ParticleManager:SetParticleControlForward( effect_cast, 3, direction )
	ParticleManager:SetParticleControlForward( effect_cast, 4, direction )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	target:EmitSound(sound_cast)

end

local duration = self:GetSpecialValueFor("speed_duration")


if success then

	self:EndCooldown()

	if target:IsValidKill(self:GetCaster()) then 
		if self:GetCaster():GetQuest() == "Axe.Quest_8" then 
			self:GetCaster():UpdateQuest(1)
		end
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_axe_culling_blade_custom_kills", {})
		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_axe_culling_blade_custom", { duration = duration } )
	end

	
end





end







modifier_axe_culling_blade_custom = class({})

function modifier_axe_culling_blade_custom:IsPurgable()
	return true
end

function modifier_axe_culling_blade_custom:OnCreated( kv )
	self.armor_bonus = self:GetAbility():GetSpecialValueFor( "armor_buff" )
	self.ms_bonus = self:GetAbility():GetSpecialValueFor( "speed_bonus" )
end



function modifier_axe_culling_blade_custom:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}

	return funcs
end

function modifier_axe_culling_blade_custom:GetModifierMoveSpeedBonus_Percentage()
	return self.ms_bonus
end

function modifier_axe_culling_blade_custom:GetModifierPhysicalArmorBonus()
	return self.armor_bonus
end



function modifier_axe_culling_blade_custom:GetEffectName()
	return "particles/units/heroes/hero_axe/axe_cullingblade_sprint.vpcf"
end

function modifier_axe_culling_blade_custom:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end


modifier_axe_culling_blade_custom_tracker = class({})
function modifier_axe_culling_blade_custom_tracker:IsHidden() return true end
function modifier_axe_culling_blade_custom_tracker:IsPurgable() return false end
function modifier_axe_culling_blade_custom_tracker:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_ATTACK_LANDED,
    MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING,
	MODIFIER_EVENT_ON_TAKEDAMAGE
}
end





function modifier_axe_culling_blade_custom_tracker:GetModifierCastRangeBonusStacking()
if not self:GetCaster():HasModifier("modifier_axe_culling_3") then return end 

return self:GetCaster():GetTalentValue("modifier_axe_culling_3", "range")
end



function modifier_axe_culling_blade_custom_tracker:OnCreated(table)

self.attack_duration = self:GetCaster():GetTalentValue("modifier_axe_culling_4",  "duration", true)

self.radius = self:GetCaster():GetTalentValue("modifier_axe_culling_5", "radius", true)
self.health = self:GetCaster():GetTalentValue("modifier_axe_culling_5", "health", true)

if not IsServer() then return end

self.parent = self:GetParent()

self:StartIntervalThink(0.2)
end



function modifier_axe_culling_blade_custom_tracker:OnIntervalThink()
if not IsServer() then return end

if self.parent:HasModifier("modifier_axe_culling_1") then 
	self.PercentStr = self.parent:GetTalentValue("modifier_axe_culling_1", "str_pct")/100
end 

if self.parent:HasModifier("modifier_axe_culling_4") then

	local damage = self:GetAbility():GetSpecialValueFor("damage") + self.parent:GetTalentValue("modifier_axe_culling_3","damage")
	local target_mod = self.parent:FindModifierByName("modifier_axe_culling_blade_custom_target_mod")

	if target_mod and target_mod.target and not target_mod.target:IsNull() then 

		local damage_mod = target_mod.target:FindModifierByName("modifier_axe_culling_blade_custom_attack_kill")

		if damage_mod then 
			damage = damage + damage_mod:GetStackCount()*self.parent:GetTalentValue("modifier_axe_culling_4", "damage")*target_mod.target:GetMaxHealth()/100
		end 
	end 

	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self.parent:GetPlayerOwnerID()), "axe_culling_change",  {damage = math.floor(damage*(1 + self.parent:GetSpellAmplification(false))) })
end 


if not self.parent:HasModifier("modifier_axe_culling_5") then return end 

local units = self.parent:FindTargets(self.radius)

flag = false

for _,unit in pairs(units) do 
	if unit:GetHealthPercent() <= self.health and unit:IsRealHero() then 
		flag = true
		break
	end 
end 

if flag == true then 
	self.parent:AddNewModifier(self.parent, self:GetAbility(), "modifier_axe_culling_blade_custom_status", {})
else 
	self.parent:RemoveModifierByName("modifier_axe_culling_blade_custom_status")
end 

end


function modifier_axe_culling_blade_custom_tracker:OnTakeDamage(params)
if not IsServer() then return end
if self.parent ~= params.attacker then return end

local target = params.unit

local is_ulti = params.inflictor and not self.parent:HasModifier("modifier_axe_culling_blade_custom_no_bonus") and (params.inflictor == self:GetAbility() or params.inflictor == self.parent:FindAbilityByName("axe_culling_blade_custom_legendary"))

if is_ulti or target:HasModifier("modifier_axe_culling_blade_custom_timer_kill") then 


	local success = false
	local effect = false

	if target:GetHealth()<=1 and not target:HasModifier("modifier_custom_juggernaut_healing_ward_reduction_aura") then 
		success = true
		effect = true
	end

	if is_ulti then 
		effect = true
	end 

	self:GetAbility():CullingBladeKill(target, success, effect)

end 

end


function modifier_axe_culling_blade_custom_tracker:OnAttackLanded(params)
if not IsServer() then return end
if self.parent ~= params.attacker then return end
if not params.target:IsHero() and not params.target:IsCreep() then return end



if self.parent:HasModifier("modifier_axe_culling_2") then 
	local damage = params.target:GetHealth()*self.parent:GetTalentValue("modifier_axe_culling_2", "damage")/100

	self.parent:AddNewModifier(self.parent, self, "modifier_axe_culling_blade_custom_no_bonus", {})
	local real_damage = ApplyDamage({ victim = params.target, attacker = self.parent, damage = damage, damage_type = DAMAGE_TYPE_PURE, ability = self:GetAbility(), })	
	self.parent:GenericHeal(real_damage, self:GetAbility(), true)

	self.parent:RemoveModifierByName("modifier_axe_culling_blade_custom_no_bonus")
end 


if not self.parent:HasModifier("modifier_axe_culling_4") then return end

params.target:AddNewModifier(self.parent, self:GetAbility(), "modifier_axe_culling_blade_custom_attack_kill", {duration = self.attack_duration})
self.parent:AddNewModifier(self.parent, self:GetAbility(), "modifier_axe_culling_blade_custom_target_mod", {duration = 3, target = params.target:entindex()})

end











modifier_axe_culling_blade_custom_attack_kill = class({})
function modifier_axe_culling_blade_custom_attack_kill:IsHidden() return false end
function modifier_axe_culling_blade_custom_attack_kill:IsPurgable() return false end
function modifier_axe_culling_blade_custom_attack_kill:GetTexture() return "buffs/culling_attack" end


function modifier_axe_culling_blade_custom_attack_kill:OnCreated(table)

self.max = self:GetCaster():GetTalentValue("modifier_axe_culling_4", "max")
self.heal_reduce = self:GetCaster():GetTalentValue("modifier_axe_culling_4", "heal_reduce")
self.damage = self:GetCaster():GetTalentValue("modifier_axe_culling_4", "damage")/100

if not IsServer() then return end
self.RemoveForDuel = true
self:SetStackCount(1)
end

function modifier_axe_culling_blade_custom_attack_kill:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self.max  then return end

self:IncrementStackCount()
end



function modifier_axe_culling_blade_custom_attack_kill:OnStackCountChanged(iStackCount)
if self:GetStackCount() == 0 then return end
if self.effect_mark then return end
if not self.effect_cast then 

    self.effect_cast = ParticleManager:CreateParticle( "particles/axe_culling_stack.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
    ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, self:GetStackCount(), 0 ) )
    self:AddParticle(self.effect_cast,false, false, -1, false, false)
else 

  if self:GetStackCount() < self.max then 
  	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, self:GetStackCount(), 0 ) )
  else 
  	if self.effect_cast then 
  		ParticleManager:DestroyParticle(self.effect_cast, true)
  		ParticleManager:ReleaseParticleIndex(self.effect_cast)
  	end 

    self.effect_mark = ParticleManager:CreateParticle( "particles/lc_odd_charge_mark.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
    ParticleManager:SetParticleControl( self.effect_mark, 1, Vector( 0, self:GetStackCount(), 0 ) )
    self:AddParticle(self.effect_mark,false, false, -1, false, false)

  end 
end

end


function modifier_axe_culling_blade_custom_attack_kill:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
	MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
	MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE,
	MODIFIER_PROPERTY_TOOLTIP
}
end


function modifier_axe_culling_blade_custom_attack_kill:OnTooltip()

return self:GetStackCount()*self.damage*self:GetParent():GetMaxHealth()
end


function modifier_axe_culling_blade_custom_attack_kill:GetModifierLifestealRegenAmplify_Percentage()
	return self:GetStackCount()*self.heal_reduce
end

function modifier_axe_culling_blade_custom_attack_kill:GetModifierHealAmplify_PercentageTarget()
	return self:GetStackCount()*self.heal_reduce
end

function modifier_axe_culling_blade_custom_attack_kill:GetModifierHPRegenAmplify_Percentage()
	return self:GetStackCount()*self.heal_reduce
end
















function axe_culling_blade_custom_legendary:GetCooldown(iLevel)
return self:GetCaster():GetTalentValue("modifier_axe_culling_legendary", "cd")
end



function axe_culling_blade_custom_legendary:OnSpellStart()
if not IsServer() then return end

if self:GetCursorTarget():TriggerSpellAbsorb(self) then return end


self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_axe_culling_blade_custom_legendary", { duration = self:GetCaster():GetTalentValue("modifier_axe_culling_legendary", "duration") } )


local target =  self:GetCursorTarget()
local direction = (target:GetOrigin()-self:GetCaster():GetOrigin()):Normalized()

local old_pos = self:GetCaster():GetAbsOrigin()
    

local effect = ParticleManager:CreateParticle("particles/items3_fx/blink_overwhelming_start.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(effect, 0, old_pos)

FindClearSpaceForUnit(self:GetCaster(), self:GetCursorTarget():GetAbsOrigin(), true)
ProjectileManager:ProjectileDodge(self:GetCaster())

effect = ParticleManager:CreateParticle("particles/items3_fx/blink_overwhelming_end.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(effect, 0, self:GetCaster():GetAbsOrigin())

local damage = self:GetCursorTarget():GetMaxHealth()*self:GetCaster():GetTalentValue("modifier_axe_culling_legendary", "damage")/100

if target:IsCreep() then 
	damage = damage/3
end

ApplyDamage({ victim = self:GetCursorTarget(), attacker = self:GetCaster(), damage = damage, damage_type = DAMAGE_TYPE_PURE, ability = self, })

if not target:IsMagicImmune() then 
	target:AddNewModifier(self:GetCaster(), self, "modifier_axe_culling_blade_custom_slow_lendary", {duration = 0.5})
end


local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_axe/axe_culling_blade_kill.vpcf", PATTACH_ABSORIGIN_FOLLOW, target )
ParticleManager:SetParticleControl( effect_cast, 4, target:GetOrigin() )
ParticleManager:SetParticleControlForward( effect_cast, 3, direction )
ParticleManager:SetParticleControlForward( effect_cast, 4, direction )
ParticleManager:ReleaseParticleIndex( effect_cast )
target:EmitSound("Axe.Culling_legendary")
target:EmitSound("Axe.Culling_legendary2")

if target:GetHealthPercent() > self:GetCaster():GetTalentValue("modifier_axe_culling_legendary", "health") then 
	self:EndCooldown()
	self:StartCooldown(self:GetCaster():GetTalentValue("modifier_axe_culling_legendary", "cd_low"))
end

end



modifier_axe_culling_blade_custom_execute = class({})
function modifier_axe_culling_blade_custom_execute:IsHidden() return false end
function modifier_axe_culling_blade_custom_execute:IsPurgable() return false end
function modifier_axe_culling_blade_custom_execute:GetTexture() return "buffs/culling_execute" end

function modifier_axe_culling_blade_custom_execute:GetEffectName()  
return "particles/axe_execute.vpcf"
end

function modifier_axe_culling_blade_custom_execute:OnCreated()
if not IsServer() then return end
    self:GetCaster():EmitSound("Axe.Culling_execute")
self.particle_peffect = ParticleManager:CreateParticle("particles/axe_exe.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())	
ParticleManager:SetParticleControl(self.particle_peffect, 0, self:GetParent():GetAbsOrigin())
end

function modifier_axe_culling_blade_custom_execute:OnDestroy()
if not IsServer() then return end
if not self.particle_peffect then return end

ParticleManager:DestroyParticle(self.particle_peffect, false)
   ParticleManager:ReleaseParticleIndex(self.particle_peffect)
end







modifier_axe_culling_blade_custom_kills = class({})
function modifier_axe_culling_blade_custom_kills:IsHidden() return false end
function modifier_axe_culling_blade_custom_kills:IsPurgable() return false end
function modifier_axe_culling_blade_custom_kills:GetTexture() return "buffs/culling_kills" end
function modifier_axe_culling_blade_custom_kills:RemoveOnDeath() return false end
function modifier_axe_culling_blade_custom_kills:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	MODIFIER_PROPERTY_TOOLTIP,
	MODIFIER_EVENT_ON_TAKEDAMAGE,
	MODIFIER_PROPERTY_TOOLTIP2
}
end


function modifier_axe_culling_blade_custom_kills:GetModifierBonusStats_Strength()
if not self:GetCaster():HasModifier("modifier_axe_culling_1") then return end 

return self:GetStackCount()*self:GetCaster():GetTalentValue("modifier_axe_culling_1", "str")
end 


function modifier_axe_culling_blade_custom_kills:OnTooltip2()
if not self:GetCaster():HasModifier("modifier_axe_culling_6") then return end
if self:GetStackCount() < self.kills_max then return end

return self.kills_heal*100
end



function modifier_axe_culling_blade_custom_kills:OnTakeDamage( params )
if not self:GetCaster():HasModifier("modifier_axe_culling_6") then return end
if self:GetStackCount() < self.kills_max then return end
if self:GetParent() == params.unit then return end
if bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then return end

if self:GetParent() ~= params.attacker then return end
if not params.inflictor then return end
if params.unit:IsBuilding() or params.unit:IsIllusion() then return end

local heal = params.damage*self.kills_heal

if params.unit:IsCreep() then 
	heal = heal*self.kills_heal_creeps
end

self:GetParent():GenericHeal(heal, self:GetAbility(), true, "particles/items3_fx/octarine_core_lifesteal.vpcf")

end




function modifier_axe_culling_blade_custom_kills:GetModifierSpellAmplify_Percentage()
if not self:GetCaster():HasModifier("modifier_axe_culling_6") then
	return 0
end

local stack = math.min(self:GetStackCount(), self.kills_max)

return stack*self.kills_damage
end

function modifier_axe_culling_blade_custom_kills:OnCreated(table)

self.kills_damage = self:GetCaster():GetTalentValue("modifier_axe_culling_6", "damage", true)
self.kills_max = self:GetCaster():GetTalentValue("modifier_axe_culling_6", "max", true)
self.kills_heal = self:GetCaster():GetTalentValue("modifier_axe_culling_6", "heal", true)/100
self.kills_heal_creeps = self:GetCaster():GetTalentValue("modifier_axe_culling_6", "heal_creeps", true)

if not IsServer() then return end
self:SetStackCount(1)

self:StartIntervalThink(0.5)
end

function modifier_axe_culling_blade_custom_kills:GetModifierPhysicalArmorBonus()
return self:GetAbility():GetSpecialValueFor("armor_bonus")*self:GetStackCount()
end


function modifier_axe_culling_blade_custom_kills:OnRefresh(table)
if not IsServer() then return end
self:IncrementStackCount()

end


function modifier_axe_culling_blade_custom_kills:OnIntervalThink()
if not IsServer() then return end 
if not self:GetParent():HasModifier("modifier_axe_culling_6") then return end 
if self:GetStackCount() < self.kills_max then return end

local particle_peffect = ParticleManager:CreateParticle("particles/brist_lowhp_.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
ParticleManager:SetParticleControl(particle_peffect, 0, self:GetCaster():GetAbsOrigin())
ParticleManager:SetParticleControl(particle_peffect, 2, self:GetCaster():GetAbsOrigin())
ParticleManager:ReleaseParticleIndex(particle_peffect)
self:GetCaster():EmitSound("BS.Thirst_legendary_active")

self:StartIntervalThink(-1)
end 



function modifier_axe_culling_blade_custom_kills:OnTooltip()
return self:GetStackCount()
end

modifier_axe_culling_blade_custom_aegis = class({})
function modifier_axe_culling_blade_custom_aegis:IsHidden() return true end
function modifier_axe_culling_blade_custom_aegis:IsPurgable() return false end



modifier_axe_culling_blade_custom_no_bonus = class({})
function modifier_axe_culling_blade_custom_no_bonus:IsHidden() return true end
function modifier_axe_culling_blade_custom_no_bonus:IsPurgable() return false end











modifier_axe_culling_blade_custom_slow_lendary = class({})
function modifier_axe_culling_blade_custom_slow_lendary:IsHidden() return true end
function modifier_axe_culling_blade_custom_slow_lendary:IsPurgable() return true end
function modifier_axe_culling_blade_custom_slow_lendary:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end

function modifier_axe_culling_blade_custom_slow_lendary:GetModifierMoveSpeedBonus_Percentage()
return -100
end


modifier_axe_culling_blade_custom_target_mod = class({})
function modifier_axe_culling_blade_custom_target_mod:IsHidden() return true end
function modifier_axe_culling_blade_custom_target_mod:IsPurgable() return false end
function modifier_axe_culling_blade_custom_target_mod:OnCreated(params)
if not IsServer() then return end 

self.target = EntIndexToHScript(params.target)
end 

function modifier_axe_culling_blade_custom_target_mod:OnRefresh(params)
if not IsServer() then return end 

self.target = EntIndexToHScript(params.target)
end 



modifier_axe_culling_blade_custom_timer_kill = class({})
function modifier_axe_culling_blade_custom_timer_kill:IsHidden() return true end
function modifier_axe_culling_blade_custom_timer_kill:IsPurgable() return false end
function modifier_axe_culling_blade_custom_timer_kill:RemoveOnDeath() return false end




modifier_axe_culling_blade_custom_legendary = class({})

function modifier_axe_culling_blade_custom_legendary:IsPurgable()
	return true
end

function modifier_axe_culling_blade_custom_legendary:OnCreated( kv )
	self.speed = self:GetCaster():GetTalentValue("modifier_axe_culling_legendary", "speed")
end



function modifier_axe_culling_blade_custom_legendary:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}

	return funcs
end

function modifier_axe_culling_blade_custom_legendary:GetModifierAttackSpeedBonus_Constant()
return self.speed
end



function modifier_axe_culling_blade_custom_legendary:GetEffectName()
	return "particles/units/heroes/hero_axe/axe_cullingblade_sprint.vpcf"
end

function modifier_axe_culling_blade_custom_legendary:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end


modifier_axe_culling_blade_custom_status = class({})
function modifier_axe_culling_blade_custom_status:IsHidden() return false end
function modifier_axe_culling_blade_custom_status:IsPurgable() return false end
function modifier_axe_culling_blade_custom_status:GetTexture() return "buffs/culling_status" end
function modifier_axe_culling_blade_custom_status:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING
}
end


function modifier_axe_culling_blade_custom_status:GetModifierStatusResistanceStacking()
return self.status
end


function modifier_axe_culling_blade_custom_status:OnCreated()
self.status = self:GetCaster():GetTalentValue("modifier_axe_culling_5", "status")

if not IsServer() then return end
local particle = ParticleManager:CreateParticle( "particles/items4_fx/ascetic_cap.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
self:AddParticle( particle, false, false, -1, false, false  )
end