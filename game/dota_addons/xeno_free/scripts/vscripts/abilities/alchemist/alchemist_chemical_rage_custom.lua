LinkLuaModifier( "modifier_alchemist_chemical_rage_custom", "abilities/alchemist/alchemist_chemical_rage_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_alchemist_chemical_rage_custom_legendary", "abilities/alchemist/alchemist_chemical_rage_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_alchemist_chemical_rage_transformation", "abilities/alchemist/alchemist_chemical_rage_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_alchemist_chemical_rage_slow", "abilities/alchemist/alchemist_chemical_rage_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_alchemist_chemical_rage_tracker", "abilities/alchemist/alchemist_chemical_rage_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_alchemist_chemical_rage_custom_incoming", "abilities/alchemist/alchemist_chemical_rage_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_alchemist_chemical_rage_speed", "abilities/alchemist/alchemist_chemical_rage_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_alchemist_chemical_rage_custom_unslow", "abilities/alchemist/alchemist_chemical_rage_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_alchemist_chemical_rage_armor", "abilities/alchemist/alchemist_chemical_rage_custom", LUA_MODIFIER_MOTION_NONE )


alchemist_chemical_rage_custom = class({})






alchemist_chemical_rage_custom.cleave_attack = 0.40


alchemist_enrage_potion = class({})


function alchemist_chemical_rage_custom:GetManaCost(level)


if self:GetCaster():HasModifier("modifier_alchemist_rage_6") then
	return self:GetCaster():GetTalentValue("modifier_alchemist_rage_6", "mana")
end

return self.BaseClass.GetManaCost(self,level)
end


function alchemist_chemical_rage_custom:GetBehavior()
if self:GetCaster():HasModifier("modifier_alchemist_rage_6") then
	return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IGNORE_PSEUDO_QUEUE + DOTA_ABILITY_BEHAVIOR_IMMEDIATE
end
return DOTA_ABILITY_BEHAVIOR_NO_TARGET
end



function alchemist_chemical_rage_custom:Precache(context)

PrecacheResource( "particle", 'particles/units/heroes/hero_alchemist/alchemist_attack_blur.vpcf', context )
    
PrecacheResource( "particle", "particles/alch_rage_stack.vpcf", context )
PrecacheResource( "particle", "particles/alchemist/rage_legendary.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_alchemist/alchemist_chemical_rage.vpcf", context )
PrecacheResource( "particle", "particles/alch_cleave.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_alchemist/alchemist_chemical_rage_hero_effect.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_alchemist/alchemist_berserk_buff.vpcf", context )

end

function alchemist_chemical_rage_custom:GetIntrinsicModifierName()
return "modifier_alchemist_chemical_rage_tracker"
end


function alchemist_chemical_rage_custom:GetCooldown(iLevel)
local cooldown_reduction = 0
if self:GetCaster():HasModifier("modifier_alchemist_rage_1") then
	cooldown_reduction = self:GetCaster():GetTalentValue("modifier_alchemist_rage_1", "cd")
end
return self.BaseClass.GetCooldown(self, iLevel) + cooldown_reduction

end





function alchemist_chemical_rage_custom:OnSpellStart()
	if not IsServer() then return end


	local duration = self:GetSpecialValueFor( "transformation_time" )
	self:GetCaster():AddNewModifier( self:GetCaster(),  self, "modifier_alchemist_chemical_rage_transformation", { duration = duration } )
	self:GetCaster():EmitSound("Hero_Alchemist.ChemicalRage.Cast")
	ProjectileManager:ProjectileDodge( self:GetCaster() )
	self:GetCaster():Purge( false, true, false, false, false )
end

modifier_alchemist_chemical_rage_transformation = class({})

function modifier_alchemist_chemical_rage_transformation:IsHidden() return true end
function modifier_alchemist_chemical_rage_transformation:IsPurgable() return false end

function modifier_alchemist_chemical_rage_transformation:OnCreated()
	if not IsServer() then return end
	self:GetCaster():StartGesture(ACT_DOTA_ALCHEMIST_CHEMICAL_RAGE_START)
end

function modifier_alchemist_chemical_rage_transformation:OnDestroy()
	if not IsServer() then return end
	local buff_duration = self:GetAbility():GetSpecialValueFor("duration")
	self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_alchemist_chemical_rage_custom", {duration = buff_duration})
end

modifier_alchemist_chemical_rage_custom = class({})

function modifier_alchemist_chemical_rage_custom:IsPurgable()
	return false
end

function modifier_alchemist_chemical_rage_custom:AllowIllusionDuplicate()
	return true
end






function modifier_alchemist_chemical_rage_custom:OnCreated( kv )
self.bat = self:GetAbility():GetSpecialValueFor( "base_attack_time" )

self.speed_max = self:GetCaster():GetTalentValue("modifier_alchemist_rage_4", "max", true)
self.speed_duration = self:GetCaster():GetTalentValue("modifier_alchemist_rage_4", "duration", true)

self.legendary_bva = self:GetCaster():GetTalentValue("modifier_alchemist_rage_legendary", "bva")

self.armor_duration = self:GetCaster():GetTalentValue("modifier_alchemist_rage_3", "duration", true)
self.armor_chance = self:GetCaster():GetTalentValue("modifier_alchemist_rage_3", "chance", true)

self.slow_duration = self:GetCaster():GetTalentValue("modifier_alchemist_rage_5", "slow_duration", true)

self.health_regen = self:GetAbility():GetSpecialValueFor( "bonus_health_regen" )
self.movespeed = self:GetAbility():GetSpecialValueFor( "bonus_movespeed" ) + self:GetCaster():GetTalentValue("modifier_alchemist_rage_5", "speed")

if not IsServer() then return end

if self:GetCaster():HasModifier("modifier_alchemist_rage_5") then 
	self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_alchemist_chemical_rage_custom_unslow", {duration = self:GetCaster():GetTalentValue("modifier_alchemist_rage_5", "duration")})
end 


if self:GetCaster():HasModifier("modifier_alchemist_rage_6") then 
	self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_alchemist_chemical_rage_custom_incoming", {duration = self:GetCaster():GetTalentValue("modifier_alchemist_rage_6", "duration")})
end 


if self:GetParent():HasModifier("modifier_alchemist_rage_legendary") then 
	self:GetParent():SwapAbilities("alchemist_chemical_rage_custom", "alchemist_enrage_potion", false, true)
end



self.RemoveForDuel = true


local effect_cast = ParticleManager:CreateParticle("particles/units/heroes/hero_alchemist/alchemist_chemical_rage.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
self:AddParticle( effect_cast, false, false, -1, false, false  )
self:GetParent():EmitSound("Hero_Alchemist.ChemicalRage")


end






function modifier_alchemist_chemical_rage_custom:OnRefresh( kv )
if not IsServer() then return end
self:OnCreated(table)
end

function modifier_alchemist_chemical_rage_custom:OnDestroy()
if not IsServer() then return end
self:GetParent():RemoveModifierByName("modifier_alchemist_chemical_rage_speed")

local ability = self:GetParent():FindAbilityByName("alchemist_enrage_potion")
self:GetParent():RemoveModifierByName("modifier_alchemist_chemical_rage_custom_legendary")

self:GetParent():StopSound("Hero_Alchemist.ChemicalRage")

if not ability then return end 

if ability:GetToggleState() then 
	ability:ToggleAbility()
end 

if self:GetParent():HasModifier("modifier_alchemist_rage_legendary") and not ability:IsHidden() then 
	self:GetParent():SwapAbilities("alchemist_chemical_rage_custom", "alchemist_enrage_potion", true, false)
end

end

function modifier_alchemist_chemical_rage_custom:DeclareFunctions()
	local funcs = {
	MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
	MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
	MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
	MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND,
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	MODIFIER_EVENT_ON_ATTACK_LANDED,
	}

	return funcs
end



function modifier_alchemist_chemical_rage_custom:OnStackCountChanged(iStackCount)
if true then return end
if self:GetStackCount() == 0 then 
	if self.effect_cast then
		ParticleManager:DestroyParticle(self.effect_cast, true)
		ParticleManager:ReleaseParticleIndex(self.effect_cast)
		self.effect_cast = nil
	end 
	return
end

if not self.effect_cast then 

  local particle_cast = "particles/alch_rage_stack.vpcf"
  self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
  ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, self:GetStackCount(), 0 ) )

  self:AddParticle(self.effect_cast,false, false, -1, false, false)
else 

  ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, self:GetStackCount(), 0 ) )

end

end




function modifier_alchemist_chemical_rage_custom:OnAttackLanded(params)
if not IsServer() then return end 
if params.attacker ~= self:GetParent() then return end
if params.attacker:IsIllusion() then return end
if not params.target:IsHero() and not params.target:IsCreep() then return end

if self:GetParent():HasModifier("modifier_alchemist_rage_5") then 
	params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_alchemist_chemical_rage_slow", {duration = self.slow_duration})
end 

if self:GetParent():HasModifier("modifier_alchemist_rage_3") then 

	if RollPseudoRandomPercentage(self.armor_chance,2317,self:GetParent()) then 
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_alchemist_chemical_rage_armor", {duration = self.armor_duration})
		params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_alchemist_chemical_rage_armor", {duration = self.armor_duration})
	end 
end 

if self:GetParent():HasModifier("modifier_alchemist_rage_4") then 
	self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_alchemist_chemical_rage_speed", {duration = self.speed_duration})

	if self:GetStackCount() < self.speed_max then 
		self:IncrementStackCount()
	end 
end 

if self:GetParent():HasModifier("modifier_alchemist_rage_2") then 
	local k = self:GetCaster():GetTalentValue("modifier_alchemist_rage_2", "cleave")/100
	DoCleaveAttack(self:GetParent(), params.target, nil, params.damage * k  , 150, 360, 650, "particles/alch_cleave.vpcf")
end

end







function modifier_alchemist_chemical_rage_custom:GetModifierBaseAttackTimeConstant()
local bonus = 0 
if self:GetParent():HasModifier("modifier_alchemist_chemical_rage_custom_legendary") then 
	bonus = self.legendary_bva
end 
	return self.bat + bonus
end

function modifier_alchemist_chemical_rage_custom:GetModifierAttackSpeedBonus_Constant()
local bonus = 0
if self:GetStackCount() > 0 then 
	bonus = self:GetStackCount()*self:GetCaster():GetTalentValue("modifier_alchemist_rage_4", "speed")
end 

	return bonus
end


function modifier_alchemist_chemical_rage_custom:GetModifierConstantHealthRegen()
local bonus = 0
if self:GetStackCount() > 0 then 
	bonus = self:GetStackCount()*self:GetCaster():GetTalentValue("modifier_alchemist_rage_4", "heal")
end 

	return self.health_regen + bonus
end

function modifier_alchemist_chemical_rage_custom:GetModifierMoveSpeedBonus_Constant()
	return self.movespeed
end




function modifier_alchemist_chemical_rage_custom:GetHeroEffectName()
	return "particles/units/heroes/hero_alchemist/alchemist_chemical_rage_hero_effect.vpcf"
end

function modifier_alchemist_chemical_rage_custom:GetActivityTranslationModifiers()
    return "chemical_rage"
end

function modifier_alchemist_chemical_rage_custom:GetAttackSound()
    return "Hero_Alchemist.ChemicalRage.Attack"
end















modifier_alchemist_chemical_rage_custom_legendary = class({})

function modifier_alchemist_chemical_rage_custom_legendary:IsPurgable()
	return false
end

function modifier_alchemist_chemical_rage_custom_legendary:IsHidden()
	return true
end


function modifier_alchemist_chemical_rage_custom_legendary:CheckState()
	return {
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_SILENCED] = true,
		[MODIFIER_STATE_MUTED] = true,
	}
end


function modifier_alchemist_chemical_rage_custom_legendary:OnCreated( kv )

self.status = self:GetCaster():GetTalentValue("modifier_alchemist_rage_legendary", "status")
self.bonus_range = self:GetCaster():GetTalentValue("modifier_alchemist_rage_legendary", "bonus_range")

if not IsServer() then return end

self.caster = self:GetCaster()

self.attack_count = 0
self.attack_max = 1/self.caster:GetAttacksPerSecond()

self.interval = 0.01

function modifier_alchemist_chemical_rage_custom_legendary:GetEffectName() return "particles/alchemist/rage_legendary.vpcf" end


local effect = ParticleManager:CreateParticle("particles/alchemist/rage_legendary.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
ParticleManager:SetParticleControlEnt(effect, 2, self:GetCaster(), PATTACH_OVERHEAD_FOLLOW, nil, self:GetCaster():GetAbsOrigin(), false) 
self:AddParticle( effect, false, false, -1, false, false  )

for i = 1,3 do 

	local effect_cast = ParticleManager:CreateParticle("particles/units/heroes/hero_alchemist/alchemist_berserk_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	self:AddParticle( effect_cast, false, false, -1, false, false  )
end 

self.rotate = 0
self:StartIntervalThink(self.interval)
end


function modifier_alchemist_chemical_rage_custom_legendary:OnIntervalThink()
if not IsServer() then return end
local enemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self:GetParent():Script_GetAttackRange() + self.bonus_range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )

for id, enemy in pairs(enemies) do
	if enemy:IsAttackImmune() or enemy:GetUnitName() == "npc_teleport" then
		table.remove(enemies, id)
	end
end

if #enemies <= 0 then self.rotate = 0 return end

self.rotate = 1
local direction = enemies[1]:GetAbsOrigin() - self:GetParent():GetAbsOrigin()
direction.z = 0
direction = direction:Normalized()


self.attack_count = self.attack_count + self.interval
self.attack_max = 1/self.caster:GetAttacksPerSecond()

if self.attack_count >= self.attack_max 
 and not self.caster:IsStunned() and not self.caster:IsHexed() and not my_game:CheckDisarm(self.caster) and not self.caster:IsChanneling() then 

	self.attack_count = 0

	self:GetParent():FadeGesture(ACT_DOTA_ATTACK)
	self:GetParent():FadeGesture(ACT_DOTA_ATTACK2)
	self:GetParent():StartGestureWithPlaybackRate(ACT_DOTA_ATTACK, self:GetParent():GetDisplayAttackSpeed() / 100)

	self.caster:PerformAttack(enemies[1], true, true, true, false, true, false, false)
end 



if not self:GetParent():IsCurrentlyHorizontalMotionControlled() and not self:GetParent():IsCurrentlyVerticalMotionControlled() then
	self:GetParent():SetForwardVector(direction)
	self:GetParent():FaceTowards(enemies[1]:GetAbsOrigin())
end

end


function modifier_alchemist_chemical_rage_custom_legendary:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_DISABLE_TURNING,
	MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
	MODIFIER_PROPERTY_IGNORE_CAST_ANGLE,
	MODIFIER_PROPERTY_CASTTIME_PERCENTAGE,
}
end

function modifier_alchemist_chemical_rage_custom_legendary:GetModifierDisableTurning()
	return self.rotate
end


function modifier_alchemist_chemical_rage_custom_legendary:GetModifierStatusResistanceStacking()
return self.status
end


function modifier_alchemist_chemical_rage_custom_legendary:GetModifierIgnoreCastAngle()
		return 1
end

function modifier_alchemist_chemical_rage_custom_legendary:GetModifierPercentageCasttime()
		return 100
end






modifier_alchemist_chemical_rage_slow = class({})
function modifier_alchemist_chemical_rage_slow:IsHidden() return true end
function modifier_alchemist_chemical_rage_slow:IsPurgable() return true end


function modifier_alchemist_chemical_rage_slow:OnCreated(table)

self.slow = self:GetCaster():GetTalentValue("modifier_alchemist_rage_5", "slow")
end



function modifier_alchemist_chemical_rage_slow:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end

function modifier_alchemist_chemical_rage_slow:GetModifierMoveSpeedBonus_Percentage()
return self.slow
end








function alchemist_enrage_potion:GetCooldown()
return self:GetCaster():GetTalentValue("modifier_alchemist_rage_legendary", "cd")
end

function alchemist_enrage_potion:OnToggle() 
local caster = self:GetCaster()

if self:GetToggleState() then
		self:GetCaster():EmitSound("Alch.Rage_voice")
		self:GetCaster():EmitSound("Hero_Alchemist.BerserkPotion.Cast")
		self:GetCaster():EmitSound("Hero_Alchemist.BerserkPotion.Target")
    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_alchemist_chemical_rage_custom_legendary", {})
else
    self:GetCaster():RemoveModifierByName("modifier_alchemist_chemical_rage_custom_legendary")
end


self:EndCooldown()
self:StartCooldown(self:GetCaster():GetTalentValue("modifier_alchemist_rage_legendary", "cd"))
end






modifier_alchemist_chemical_rage_custom_incoming = class({})
function modifier_alchemist_chemical_rage_custom_incoming:IsHidden() return true end
function modifier_alchemist_chemical_rage_custom_incoming:IsPurgable() return false end

function modifier_alchemist_chemical_rage_custom_incoming:OnCreated(table)
self.damage_reduce = self:GetCaster():GetTalentValue("modifier_alchemist_rage_6", "damage")
if not IsServer() then return end


self.particle_1 = "particles/units/heroes/hero_pangolier/pangolier_tailthump_buff.vpcf"
self.particle_2 = "particles/units/heroes/hero_pangolier/pangolier_tailthump_buff_egg.vpcf"
self.particle_3 = "particles/units/heroes/hero_pangolier/pangolier_tailthump_buff_streaks.vpcf"
self.sound = "Hero_Pangolier.TailThump.Shield"
self.buff_particles = {}

self:GetCaster():EmitSound( self.sound)


self.buff_particles[1] = ParticleManager:CreateParticle(self.particle_1, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
ParticleManager:SetParticleControlEnt(self.buff_particles[1], 1, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, Vector(0,0,0), false) 
self:AddParticle(self.buff_particles[1], false, false, -1, true, false)
ParticleManager:SetParticleControl( self.buff_particles[1], 3, Vector( 255, 255, 255 ) )

self.buff_particles[2] = ParticleManager:CreateParticle(self.particle_2, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
ParticleManager:SetParticleControlEnt(self.buff_particles[2], 1, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, Vector(0,0,0), false) 
self:AddParticle(self.buff_particles[2], false, false, -1, true, false)

self.buff_particles[3] = ParticleManager:CreateParticle(self.particle_3, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
ParticleManager:SetParticleControlEnt(self.buff_particles[3], 1, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, Vector(0,0,0), false) 
self:AddParticle(self.buff_particles[3], false, false, -1, true, false)

end



function modifier_alchemist_chemical_rage_custom_incoming:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
}
end

function modifier_alchemist_chemical_rage_custom_incoming:GetModifierIncomingDamage_Percentage()
return self.damage_reduce
end





modifier_alchemist_chemical_rage_custom_unslow = class({})
function modifier_alchemist_chemical_rage_custom_unslow:IsHidden() return true end
function modifier_alchemist_chemical_rage_custom_unslow:IsPurgable() return false end
function modifier_alchemist_chemical_rage_custom_unslow:CheckState()
return
{
	[MODIFIER_STATE_UNSLOWABLE] = true
}
end




modifier_alchemist_chemical_rage_tracker = class({})
function modifier_alchemist_chemical_rage_tracker:IsHidden() return true end
function modifier_alchemist_chemical_rage_tracker:IsPurgable() return false end
function modifier_alchemist_chemical_rage_tracker:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
}
end

function modifier_alchemist_chemical_rage_tracker:GetModifierAttackRangeBonus()
if not self:GetCaster():HasModifier("modifier_alchemist_rage_2") then return end 

return self:GetCaster():GetTalentValue("modifier_alchemist_rage_2", "range")
end 


modifier_alchemist_chemical_rage_speed = class({})
function modifier_alchemist_chemical_rage_speed:IsHidden() return true end
function modifier_alchemist_chemical_rage_speed:IsPurgable() return false end
function modifier_alchemist_chemical_rage_speed:OnDestroy()
if not IsServer() then return end 

local mod = self:GetCaster():FindModifierByName("modifier_alchemist_chemical_rage_custom")
if mod then 
	mod:SetStackCount(0)
end 

end


modifier_alchemist_chemical_rage_armor = class({})
function modifier_alchemist_chemical_rage_armor:IsHidden() return true end
function modifier_alchemist_chemical_rage_armor:IsPurgable() return false end
function modifier_alchemist_chemical_rage_armor:OnCreated()
self.armor = self:GetCaster():GetTalentValue("modifier_alchemist_rage_3", "armor")

if self:GetCaster():GetTeamNumber() ~= self:GetParent():GetTeamNumber() then 
	self.armor = self.armor*-1

	if IsServer() then 
		self:GetParent():EmitSound("DOTA_Item.Maim")
	end 

end 

end 

function modifier_alchemist_chemical_rage_armor:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
}
end

function modifier_alchemist_chemical_rage_armor:GetModifierPhysicalArmorBonus()
return self.armor
end