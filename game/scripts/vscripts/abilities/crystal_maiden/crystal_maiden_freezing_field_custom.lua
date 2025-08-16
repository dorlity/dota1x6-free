LinkLuaModifier( "modifier_crystal_maiden_freezing_field_custom", "abilities/crystal_maiden/crystal_maiden_freezing_field_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_crystal_maiden_freezing_field_custom_debuff", "abilities/crystal_maiden/crystal_maiden_freezing_field_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_crystal_maiden_freezing_field_custom_knock", "abilities/crystal_maiden/crystal_maiden_freezing_field_custom", LUA_MODIFIER_MOTION_HORIZONTAL )
LinkLuaModifier( "modifier_crystal_maiden_freezing_field_custom_legendary", "abilities/crystal_maiden/crystal_maiden_freezing_field_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_crystal_maiden_freezing_field_custom_legendary_mini", "abilities/crystal_maiden/crystal_maiden_freezing_field_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_crystal_maiden_freezing_field_custom_tracker", "abilities/crystal_maiden/crystal_maiden_freezing_field_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_crystal_maiden_freezing_field_custom_stack", "abilities/crystal_maiden/crystal_maiden_freezing_field_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_crystal_maiden_freezing_field_custom_invun", "abilities/crystal_maiden/crystal_maiden_freezing_field_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_crystal_maiden_freezing_field_custom_scepter", "abilities/crystal_maiden/crystal_maiden_freezing_field_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_crystal_maiden_freezing_field_custom_damage_reduce", "abilities/crystal_maiden/crystal_maiden_freezing_field_custom", LUA_MODIFIER_MOTION_NONE )



crystal_maiden_freezing_field_custom = class({})




function crystal_maiden_freezing_field_custom:CreateTalent(name)

if name == "modifier_maiden_freezing_7" then 
	self:GetCaster():FindAbilityByName("crystal_maiden_freezing_field_legendary"):SetHidden(false)
end

if name == "modifier_maiden_freezing_5" then 
	self:ToggleAutoCast()
end

end


function crystal_maiden_freezing_field_custom:GetAbilityTextureName()
local caster = self:GetCaster()

if caster:HasScepter() and caster:HasModifier("modifier_crystal_maiden_freezing_field_custom") and caster:GetUpgradeStack("modifier_crystal_maiden_freezing_field_custom") == 0 then 
  if caster:HasModifier("modifier_crystal_maiden_persona_1") or caster:HasModifier("modifier_crystal_maiden_persona_2") or caster:HasModifier("modifier_crystal_maiden_persona_3") or caster:HasModifier("modifier_crystal_maiden_persona_4") then
      return "crystal_maiden_freezing_field_stop_persona"
  end
  return "crystal_maiden_freezing_field_stop"
else 
  if caster:HasModifier("modifier_crystal_maiden_persona_1") or caster:HasModifier("modifier_crystal_maiden_persona_2") or caster:HasModifier("modifier_crystal_maiden_persona_3") or caster:HasModifier("modifier_crystal_maiden_persona_4") then
      return "crystal_maiden_freezing_field_persona"
  end
  if caster:HasModifier("modifier_crystal_maiden_arcana_custom") then
      return "crystal_maiden_freezing_field_alt1"
  end
  return "crystal_maiden_freezing_field"
end 

end


function crystal_maiden_freezing_field_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end

PrecacheResource( "particle", "particles/units/heroes/hero_crystalmaiden/maiden_freezing_field_explosion.vpcf", context )
PrecacheResource( "particle", "particles/crystal_maiden/immunity_sphere_buff.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_crystalmaiden/maiden_freezing_field_snow.vpcf", context )
PrecacheResource( "particle", "particles/generic_gameplay/generic_slowed_cold.vpcf", context )
PrecacheResource( "particle", "particles/maiden_frostbite_slow.vpcf", context )
PrecacheResource( "particle", "particles/maiden_freezing_area.vpcf", context )
PrecacheResource( "particle", "particles/maiden_field_legendary.vpcf", context )
PrecacheResource( "particle", "particles/econ/items/effigies/status_fx_effigies/status_effect_effigy_frosty_dire.vpcf", context )
end


function crystal_maiden_freezing_field_custom:GetIntrinsicModifierName()
if not self:GetCaster():IsRealHero() then return end
return "modifier_crystal_maiden_freezing_field_custom_tracker"
end


function crystal_maiden_freezing_field_custom:GetManaCost(level)
local caster = self:GetCaster()
if caster:HasScepter() and caster:HasModifier("modifier_crystal_maiden_freezing_field_custom") and caster:GetUpgradeStack("modifier_crystal_maiden_freezing_field_custom") == 0 then
	return 0
end
return self.BaseClass.GetManaCost(self, level)
end

function crystal_maiden_freezing_field_custom:GetCooldown(iLevel)
local bonus = 0
if self:GetCaster():HasTalent("modifier_maiden_freezing_1") then 
  bonus = self:GetCaster():GetTalentValue("modifier_maiden_freezing_1", "cd")
end
return self.BaseClass.GetCooldown(self, iLevel) + bonus
end


function crystal_maiden_freezing_field_custom:GetBehavior()
local auto = 0
if self:GetCaster():HasTalent("modifier_maiden_freezing_5") then 
  auto = DOTA_ABILITY_BEHAVIOR_AUTOCAST
end 
if self:GetCaster():HasScepter() then
  return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + auto
end
return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_CHANNELLED + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK + auto
end


function crystal_maiden_freezing_field_custom:GetChannelTime()
if self:GetCaster():HasScepter() then
	return 0
end

end


function crystal_maiden_freezing_field_custom:OnSpellStart()
local caster = self:GetCaster()

local ulti_mod = caster:FindModifierByName("modifier_crystal_maiden_freezing_field_custom")

if caster and ulti_mod and ulti_mod:GetStackCount() == 0 then 
	ulti_mod:LingerProc()
	return
end 

local duration = self:GetSpecialValueFor("duration")

local mod = caster:FindModifierByName("modifier_crystal_maiden_arcane_aura_custom_spell")
local arcane = caster:FindAbilityByName("crystal_maiden_arcane_aura_custom")

if arcane and mod and arcane:GetAutoCastState() == true  then 
  caster:EmitSound("Maiden.Frostbite_stun")
	caster:AddNewModifier(caster, self, "modifier_crystal_maiden_freezing_field_custom_invun", { duration = caster:GetTalentValue("modifier_maiden_arcane_6", "bkb")})
	mod:Destroy()
end

caster:RemoveModifierByName("modifier_crystal_maiden_freezing_field_custom")
caster:AddNewModifier(caster, self, "modifier_crystal_maiden_freezing_field_custom", {duration = duration})

if caster:HasScepter() then 
	self:EndCooldown()
	self:StartCooldown(1)
end

end

function crystal_maiden_freezing_field_custom:OnChannelFinish( bInterrupted )

local caster = self:GetCaster()
local mod = caster:FindModifierByName("modifier_crystal_maiden_freezing_field_custom")

if mod then
	mod:LingerProc()
end


end



function crystal_maiden_freezing_field_custom:DealDamage(target, ability, damage_ability)
if not IsServer() then return end

local caster = self:GetCaster()
local damage = self:GetSpecialValueFor("damage")
local mod = target:FindModifierByName("modifier_crystal_maiden_freezing_field_custom_stack")

if mod then 
	damage = damage + mod:GetStackCount()*caster:GetTalentValue("modifier_maiden_freezing_3", "damage")
	SendOverheadEventMessage(target, 4, target, mod:GetStackCount()*caster:GetTalentValue("modifier_maiden_freezing_3", "damage"),nil)
end

local damageTable = { attacker = caster, victim = target, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability}

DoDamage(damageTable, damage_ability)

if caster:HasTalent("modifier_maiden_freezing_2") then
	target:AddNewModifier(caster, self, "modifier_crystal_maiden_freezing_field_custom_damage_reduce", {duration = caster:GetTalentValue("modifier_maiden_freezing_2", "duration")})
end

if caster:HasTalent("modifier_maiden_freezing_3") then 
	target:AddNewModifier(caster, self, "modifier_crystal_maiden_freezing_field_custom_stack", {duration = caster:GetTalentValue("modifier_maiden_freezing_3", "duration")})
end


end



function crystal_maiden_freezing_field_custom:SummonShard(point, ability, damage_ability)
if not IsServer() then return end


local effect_name = "particles/units/heroes/hero_crystalmaiden/maiden_freezing_field_explosion.vpcf"
if self:GetCaster():HasModifier("modifier_crystal_maiden_persona_1") or self:GetCaster():HasModifier("modifier_crystal_maiden_persona_2") or self:GetCaster():HasModifier("modifier_crystal_maiden_persona_3") or self:GetCaster():HasModifier("modifier_crystal_maiden_persona_4") then
    effect_name = "particles/units/heroes/hero_crystalmaiden_persona/cm_persona_freezing_field_explosion.vpcf"
elseif self:GetCaster():HasModifier("modifier_crystal_maiden_arcana_custom") then
    effect_name = "particles/econ/items/crystal_maiden/crystal_maiden_maiden_of_icewrack/maiden_freezing_field_explosion_arcana1.vpcf"
end

local effect_cast = ParticleManager:CreateParticle( effect_name, PATTACH_WORLDORIGIN, nil )
ParticleManager:SetParticleControl( effect_cast, 0, point )
ParticleManager:ReleaseParticleIndex(effect_cast)

EmitSoundOnLocationWithCaster( point, "hero_Crystal.freezingField.explosion", self:GetCaster() )

CreateModifierThinker(self:GetCaster(), ability, "modifier_crystal_maiden_freezing_field_custom_legendary_mini", {duration = 0.25, damage_ability = damage_ability}, point, self:GetCaster():GetTeamNumber(), false)
end





modifier_crystal_maiden_freezing_field_custom = class({})
function modifier_crystal_maiden_freezing_field_custom:IsHidden() return false end
function modifier_crystal_maiden_freezing_field_custom:IsPurgable() return false end


function modifier_crystal_maiden_freezing_field_custom:OnCreated()	

self.parent = self:GetParent()
self.ability = self:GetAbility()

self.slow_radius = self.ability:GetSpecialValueFor( "radius" )
self.slow_duration = self.ability:GetSpecialValueFor( "slow_duration" ) + self.parent:GetTalentValue("modifier_maiden_freezing_5", "slow")
self.explosion_radius = self.ability:GetSpecialValueFor( "explosion_radius" ) + self.parent:GetTalentValue("modifier_maiden_freezing_3", "radius")
self.explosion_interval = self.ability:GetSpecialValueFor( "explosion_interval" )
self.explosion_min_dist = self.ability:GetSpecialValueFor( "explosion_min_dist" )
self.explosion_max_dist = self.ability:GetSpecialValueFor( "explosion_max_dist" )
self.shard_move = self.ability:GetSpecialValueFor("scepter_move")

self.linger = self.ability:GetSpecialValueFor("scepter_linger")

self.block_regen = self.parent:GetTalentValue("modifier_maiden_freezing_6", "heal", true )
self.block_armor = self.parent:GetTalentValue("modifier_maiden_freezing_6", "armor", true )

self.caster = self.parent

self.set_end = false

self.RemoveForDuel = true
self.quartal = -1

if not IsServer() then return end

self:SetStackCount(0)

self.knock_max = self.parent:GetTalentValue("modifier_maiden_freezing_5", "cd", true)
self.knock_silence = self.parent:GetTalentValue("modifier_maiden_freezing_5", "silence", true)
self.knock_duration = self.parent:GetTalentValue("modifier_maiden_freezing_5", "duration", true)
self.knock_count = 0

self.scepter_targets = {}

self.sphere = nil

if self.parent:HasTalent("modifier_maiden_freezing_6") then 
	self.sphere = ParticleManager:CreateParticle("particles/crystal_maiden/immunity_sphere_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent )
	ParticleManager:SetParticleControlEnt(self.sphere, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
	self:AddParticle( self.sphere, false, false, -1, false, false )
end

if not self.parent:HasScepter() then 
	self.parent:StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_4, 0.8)
else 
	self.explosion_interval = self.ability:GetSpecialValueFor("scepter_interval")
end

self:StartIntervalThink( self.explosion_interval )
self:PlayEffects1()
end

function modifier_crystal_maiden_freezing_field_custom:LingerProc()
if not IsServer() then return end

if not self.parent:HasScepter() then
	self:Destroy()
	return
end

if self:GetStackCount() ~= 0 then return end

self.ability:UseResources(false, false, false, true)
self.parent:CdAbility(self.ability, self:GetElapsedTime())

self:SetStackCount(1)
self:SetDuration(self.linger, true)

self.parent:FadeGesture(ACT_DOTA_CAST_ABILITY_4)

self.set_end = true
end

function modifier_crystal_maiden_freezing_field_custom:DeclareFunctions()
return 
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	MODIFIER_PROPERTY_ABSORB_SPELL,
}
end

function modifier_crystal_maiden_freezing_field_custom:GetAbsorbSpell(params) 
if params.ability:GetCaster():GetTeamNumber() == self.parent:GetTeamNumber() then return end
if self.sphere == nil then return end
if self.parent:IsInvulnerable() then return end

self.parent:EmitSound("DOTA_Item.LinkensSphere.Activate")

if self.sphere then 
	ParticleManager:DestroyParticle(self.sphere, false)
	ParticleManager:ReleaseParticleIndex(self.sphere)
	self.sphere = nil
end

return 1 
end


function modifier_crystal_maiden_freezing_field_custom:GetModifierHealthRegenPercentage()
if not self.caster:HasTalent("modifier_maiden_freezing_6") then return end
return self.block_regen
end


function modifier_crystal_maiden_freezing_field_custom:GetModifierPhysicalArmorBonus()
if not self.caster:HasTalent("modifier_maiden_freezing_6") then return end
return self.block_armor
end


function modifier_crystal_maiden_freezing_field_custom:GetModifierMoveSpeedBonus_Percentage()
if not self.caster:HasScepter() then return end
if self:GetStackCount() == 1 then return end
return self.shard_move
end


function modifier_crystal_maiden_freezing_field_custom:OnIntervalThink()
if not IsServer() then return end

if self.caster:HasScepter() and (self.caster:IsStunned() or self.caster:IsSilenced() or self.caster:IsHexed() or not self.caster:IsAlive()) and self:GetStackCount() == 0 then 
	self:LingerProc()
end

local all_enemies = FindUnitsInRadius( self.caster:GetTeamNumber(), self.parent:GetAbsOrigin(), nil, self.slow_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )

local knock = false
if self.caster:HasTalent("modifier_maiden_freezing_5") then 
	self.knock_count = self.knock_count + self.explosion_interval

	if self.knock_count >= self.knock_max then 
		self.knock_count = 0
		knock = true
	end 
end 

for _,enemy in pairs(all_enemies) do 
	enemy:AddNewModifier(self.parent, self.ability, "modifier_crystal_maiden_freezing_field_custom_debuff", {duration =  self.slow_duration })

--	if not self.scepter_targets[enemy] and self.parent:HasScepter() then 
	--	enemy:AddNewModifier(self.parent, self.ability, "modifier_crystal_maiden_freezing_field_custom_scepter", {duration = self.explosion_interval + FrameTime()*2, interval = self.explosion_interval})
	--end

	if knock == true then 
		enemy:EmitSound("Maiden.Freezing_silence")
		enemy:AddNewModifier(self.parent, self.ability, "modifier_generic_silence", { duration = (1 - self.parent:GetStatusResistance())*self.knock_silence})

		if  self.ability:GetAutoCastState() == true then 
  		enemy:AddNewModifier(self.parent, self.ability, "modifier_crystal_maiden_freezing_field_custom_knock", {duration = self.knock_duration})
		end
	end
end

self.quartal = self.quartal+1
if self.quartal>3 then self.quartal = 0 end
local a = RandomInt(0,90) + self.quartal*90
local r = RandomInt(self.explosion_min_dist,self.explosion_max_dist)
local point = Vector( math.cos(a), math.sin(a), 0 ):Normalized() * r
point = self.caster:GetOrigin() + point

local enemies = FindUnitsInRadius( self.caster:GetTeamNumber(), point, nil, self.explosion_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
for _,enemy in pairs(enemies) do
	self.ability:DealDamage(enemy, self.ability)
end

local copy = FindUnitsInRadius(self.caster:GetTeamNumber(), point, nil, self.explosion_radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, 0, false )

for _,unit in pairs(copy) do 
  if unit:HasModifier("modifier_crystal_maiden_crystal_clone_statue") then 
		self.ability:DealDamage(unit, self.ability)
  end 
end 

self:PlayEffects2( point )
end


function modifier_crystal_maiden_freezing_field_custom:PlayEffects1()
if self.effect_cast then return end

local effect_name = "particles/units/heroes/hero_crystalmaiden/maiden_freezing_field_snow.vpcf"
if self.parent:HasModifier("modifier_crystal_maiden_persona_1") or self.parent:HasModifier("modifier_crystal_maiden_persona_2") or self.parent:HasModifier("modifier_crystal_maiden_persona_3") or self.parent:HasModifier("modifier_crystal_maiden_persona_4") then
    effect_name = "particles/units/heroes/hero_crystalmaiden_persona/cm_persona_freezing_field_snow.vpcf"
elseif self.parent:HasModifier("modifier_crystal_maiden_arcana_custom") then
    effect_name = "particles/econ/items/crystal_maiden/crystal_maiden_maiden_of_icewrack/maiden_freezing_field_snow_arcana1.vpcf"
end

self.effect_cast = ParticleManager:CreateParticle(effect_name, PATTACH_ABSORIGIN_FOLLOW, self.caster )
ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( self.slow_radius, self.slow_radius, 1 ) )
self:AddParticle( self.effect_cast, false, false, -1, false, false )

local sound = "hero_Crystal.freezingField.wind"
if self.parent:HasModifier("modifier_crystal_maiden_arcana_custom") then
  sound = "Hero_Crystal.FreezingField.Arcana"
end
self.caster:EmitSound(sound)
end


function modifier_crystal_maiden_freezing_field_custom:PlayEffects2( point )

local effect_name = "particles/units/heroes/hero_crystalmaiden/maiden_freezing_field_explosion.vpcf"
if self.parent:HasModifier("modifier_crystal_maiden_persona_1") or self.parent:HasModifier("modifier_crystal_maiden_persona_2") or self.parent:HasModifier("modifier_crystal_maiden_persona_3") or self.parent:HasModifier("modifier_crystal_maiden_persona_4") then
    effect_name = "particles/units/heroes/hero_crystalmaiden_persona/cm_persona_freezing_field_explosion.vpcf"
elseif self.parent:HasModifier("modifier_crystal_maiden_arcana_custom") then
    effect_name = "particles/econ/items/crystal_maiden/crystal_maiden_maiden_of_icewrack/maiden_freezing_field_explosion_arcana1.vpcf"
end
local effect_cast = ParticleManager:CreateParticle( effect_name, PATTACH_WORLDORIGIN, nil )
ParticleManager:SetParticleControl( effect_cast, 0, point )
ParticleManager:ReleaseParticleIndex(effect_cast)
EmitSoundOnLocationWithCaster( point, "hero_Crystal.freezingField.explosion", self.caster )
end


function modifier_crystal_maiden_freezing_field_custom:StopEffects1()
if self.effect_cast then
	ParticleManager:DestroyParticle(self.effect_cast, false)
	ParticleManager:ReleaseParticleIndex(self.effect_cast)
    local sound = "hero_Crystal.freezingField.wind"
    if self.parent:HasModifier("modifier_crystal_maiden_arcana_custom") then
        sound = "Hero_Crystal.FreezingField.Arcana"
    end
	self.caster:StopSound(sound)
	self.effect_cast = nil
end

end




function modifier_crystal_maiden_freezing_field_custom:OnDestroy()	
if not IsServer() then return end
self.parent:RemoveModifierByName("modifier_crystal_maiden_freezing_field_custom_invun")

if not self.caster:HasScepter() then 
	self.caster:FadeGesture(ACT_DOTA_CAST_ABILITY_4)
elseif self.set_end == false then
	self.ability:UseResources(false, false, false, true)
	self.parent:CdAbility(self.ability, self:GetElapsedTime())
end

self:StopEffects1()
end














modifier_crystal_maiden_freezing_field_custom_debuff = class({})

function modifier_crystal_maiden_freezing_field_custom_debuff:OnCreated( kv )
self.ms_slow = self:GetAbility():GetSpecialValueFor( "movespeed_slow" )
self.as_slow = self:GetAbility():GetSpecialValueFor( "attack_slow" )
self.radius = self:GetAbility():GetSpecialValueFor("radius")
end

function modifier_crystal_maiden_freezing_field_custom_debuff:DeclareFunctions()
return 
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
}
end


function modifier_crystal_maiden_freezing_field_custom_debuff:GetStatusEffectName()
return "particles/status_fx/status_effect_frost.vpcf"
end

function modifier_crystal_maiden_freezing_field_custom_debuff:StatusEffectPriority()
return MODIFIER_PRIORITY_NORMAL 
end

function modifier_crystal_maiden_freezing_field_custom_debuff:GetModifierMoveSpeedBonus_Percentage()
return self.ms_slow
end

function modifier_crystal_maiden_freezing_field_custom_debuff:GetModifierAttackSpeedBonus_Constant()
return self.as_slow
end

function modifier_crystal_maiden_freezing_field_custom_debuff:GetEffectName()
return "particles/generic_gameplay/generic_slowed_cold.vpcf"
end

function modifier_crystal_maiden_freezing_field_custom_debuff:GetEffectAttachType()
return PATTACH_ABSORIGIN_FOLLOW
end










modifier_crystal_maiden_freezing_field_custom_damage_reduce = class({})
function modifier_crystal_maiden_freezing_field_custom_damage_reduce:IsHidden() return false end
function modifier_crystal_maiden_freezing_field_custom_damage_reduce:IsPurgable() return false end
function modifier_crystal_maiden_freezing_field_custom_damage_reduce:GetTexture() return "buffs/freezing_healing" end

function modifier_crystal_maiden_freezing_field_custom_damage_reduce:OnCreated( kv )
self.reduction_heal = self:GetCaster():GetTalentValue("modifier_maiden_freezing_2", "heal_reduce", true )
self.reduction_damage = self:GetCaster():GetTalentValue("modifier_maiden_freezing_2", "damage_reduce", true )
end

function modifier_crystal_maiden_freezing_field_custom_damage_reduce:DeclareFunctions()
return 
{
	MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
	MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
	MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE,
	MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
	MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
}
end

function modifier_crystal_maiden_freezing_field_custom_damage_reduce:GetModifierLifestealRegenAmplify_Percentage() 
return self.reduction_heal
end

function modifier_crystal_maiden_freezing_field_custom_damage_reduce:GetModifierHealAmplify_PercentageTarget()
return self.reduction_heal
end

function modifier_crystal_maiden_freezing_field_custom_damage_reduce:GetModifierHPRegenAmplify_Percentage() 
return self.reduction_heal
end

function modifier_crystal_maiden_freezing_field_custom_damage_reduce:GetModifierDamageOutgoing_Percentage()
return self.reduction_damage
end

function modifier_crystal_maiden_freezing_field_custom_damage_reduce:GetModifierSpellAmplify_Percentage() 
return self.reduction_damage
end













modifier_crystal_maiden_freezing_field_custom_knock = class({})

function modifier_crystal_maiden_freezing_field_custom_knock:IsHidden() return true end

function modifier_crystal_maiden_freezing_field_custom_knock:OnCreated(params)
if not IsServer() then return end

self.ability        = self:GetAbility()
self.caster         = self:GetCaster()
self.parent         = self:GetParent()
self:GetParent():StartGesture(ACT_DOTA_FLAIL)

self.knockback_duration   = self:GetRemainingTime()

local distance = (self:GetParent():GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Length2D()

self.distance_min = self:GetCaster():GetTalentValue("modifier_maiden_freezing_5", "distance_min")
self.distance_max = self:GetCaster():GetTalentValue("modifier_maiden_freezing_5", "distance_max")

if distance < self.distance_min then 
	self:Destroy()
	return
end

local dir = (self:GetParent():GetAbsOrigin() - self:GetCaster():GetAbsOrigin())
dir.z = 0
dir = dir:Normalized()

local point = self:GetCaster():GetAbsOrigin() + dir*self.distance_min


self.knockback_distance = math.min(self.distance_max, (point - self:GetParent():GetAbsOrigin()):Length2D())

self.knockback_speed    = self.knockback_distance / self.knockback_duration

self.position = GetGroundPosition(Vector(self:GetCaster():GetAbsOrigin().x, self:GetCaster():GetAbsOrigin().y, 0), nil)

if self:ApplyHorizontalMotionController() == false then 
  self:Destroy()
  return
end
end

function modifier_crystal_maiden_freezing_field_custom_knock:UpdateHorizontalMotion( me, dt )
  if not IsServer() then return end

  local distance = (self.position - me:GetOrigin()):Normalized()
  
  me:SetOrigin( me:GetOrigin() + distance * self.knockback_speed * dt )

  GridNav:DestroyTreesAroundPoint( self.parent:GetOrigin(), self.parent:GetHullRadius(), true )
end

function modifier_crystal_maiden_freezing_field_custom_knock:DeclareFunctions()
  local decFuncs = {
    MODIFIER_PROPERTY_OVERRIDE_ANIMATION
    }

    return decFuncs
end

function modifier_crystal_maiden_freezing_field_custom_knock:GetOverrideAnimation()
   return ACT_DOTA_FLAIL
end


function modifier_crystal_maiden_freezing_field_custom_knock:OnDestroy()
  if not IsServer() then return end
 self.parent:RemoveHorizontalMotionController( self )
  self:GetParent():FadeGesture(ACT_DOTA_FLAIL)
end


function modifier_crystal_maiden_freezing_field_custom_knock:GetEffectName()
return "particles/maiden_frostbite_slow.vpcf"
end








modifier_crystal_maiden_freezing_field_custom_tracker = class({})
function modifier_crystal_maiden_freezing_field_custom_tracker:IsHidden() return true end
function modifier_crystal_maiden_freezing_field_custom_tracker:IsPurgable() return false end

function modifier_crystal_maiden_freezing_field_custom_tracker:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
}
end

function modifier_crystal_maiden_freezing_field_custom_tracker:GetModifierPercentageCooldown() 
if not self.parent:HasTalent("modifier_maiden_freezing_1") then return end
return self.parent:GetTalentValue("modifier_maiden_freezing_1", "cdr")
end



function modifier_crystal_maiden_freezing_field_custom_tracker:OnCreated()

self.parent = self:GetParent()

self.ability = self:GetAbility()

self.radius = self:GetCaster():GetTalentValue("modifier_maiden_freezing_4", "radius", true)
self.cd_items = self:GetCaster():GetTalentValue("modifier_maiden_freezing_4", "cd_items", true)

self.cd_inc = self:GetCaster():GetTalentValue("modifier_maiden_freezing_7", "cd_inc", true)

self.spell_count = 0
self.parent:AddSpellEvent(self)
end

function modifier_crystal_maiden_freezing_field_custom_tracker:SpellEvent( params )
if not IsServer() then return end
if params.unit~=self.parent then return end

if self.parent:HasTalent("modifier_maiden_freezing_4") then
	self.spell_count = self.spell_count + 1
	local max = self.parent:GetTalentValue("modifier_maiden_freezing_4", "max")

	if self.spell_count >= max then
		self.spell_count = 0

		local enemy_heroes = FindUnitsInRadius( self.parent:GetTeamNumber(), self.parent:GetAbsOrigin() , nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
		local enemy_creeps = FindUnitsInRadius( self.parent:GetTeamNumber(), self.parent:GetAbsOrigin() , nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )

		local point = nil

		if #enemy_heroes > 0 then
			point = enemy_heroes[1]:GetAbsOrigin()
		else 
			if #enemy_creeps > 0 then 
				point = enemy_creeps[1]:GetAbsOrigin()
			end
		end

		if point == nil then
			point = self.parent:GetAbsOrigin() + RandomVector(500)
		end

	  self.ability:SummonShard(point, self.ability, "modifier_maiden_freezing_4")
		self.parent:CdItems(self.cd_items)
	end
end


if not self.parent:HasTalent("modifier_maiden_freezing_7") then return end
local ability = self.parent:FindAbilityByName("crystal_maiden_freezing_field_legendary")
if not ability then return end
if params.ability == ability then return end

self.parent:CdAbility(ability, self.cd_inc)
end










crystal_maiden_freezing_field_legendary = class({})


function crystal_maiden_freezing_field_legendary:GetAOERadius()
return self:GetSpecialValueFor("radius")
end

function crystal_maiden_freezing_field_legendary:GetCooldown()
return self:GetCaster():GetTalentValue("modifier_maiden_freezing_7", "cd")
end

function crystal_maiden_freezing_field_legendary:OnSpellStart()
if not IsServer() then return end

local point = self:GetCursorPosition()

CreateModifierThinker(self:GetCaster(), self, "modifier_crystal_maiden_freezing_field_custom_legendary", {}, point, self:GetCaster():GetTeamNumber(), false)

end



modifier_crystal_maiden_freezing_field_custom_legendary = class({})
function modifier_crystal_maiden_freezing_field_custom_legendary:IsHidden() return false end
function modifier_crystal_maiden_freezing_field_custom_legendary:IsPurgable() return false end

function modifier_crystal_maiden_freezing_field_custom_legendary:OnCreated(table)
if not IsServer() then return end

self.start_interval = self:GetAbility():GetSpecialValueFor("delay")
self.damage_interval = self:GetAbility():GetSpecialValueFor("damage_interval")
self.radius = self:GetAbility():GetSpecialValueFor("radius")
self.max = self:GetCaster():GetTalentValue("modifier_maiden_freezing_7", "count")

if self:GetCaster():HasScepter() and self:GetCaster():HasAbility("crystal_maiden_freezing_field_custom") then 
	self.max = self.max + self:GetCaster():FindAbilityByName("crystal_maiden_freezing_field_custom"):GetSpecialValueFor("scepter_legendary")
end 


AddFOWViewer(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), self.radius, self.start_interval, false)

self.effect_cast = ParticleManager:CreateParticle("particles/units/heroes/hero_crystalmaiden/maiden_freezing_field_snow.vpcf", PATTACH_WORLDORIGIN, nil )
ParticleManager:SetParticleControl( self.effect_cast, 0, self:GetParent():GetAbsOrigin() )
ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( self.radius, self.radius, 1 ) )
self:AddParticle( self.effect_cast, false, false, -1, false, false )

EmitSoundOnLocationWithCaster( self:GetParent():GetAbsOrigin(), "Maiden.Frostbite_stun", self:GetCaster() )

self.effect_timer = ParticleManager:CreateParticle("particles/maiden_freezing_area.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControl(self.effect_timer, 1, Vector(0, 0, 100))
ParticleManager:SetParticleControl(self.effect_timer, 5, Vector(self.radius, self.radius, self.radius))
self:AddParticle( self.effect_timer, false, false, -1, false, false )

self:SetStackCount(0)

self:StartIntervalThink(self.start_interval)
end



function modifier_crystal_maiden_freezing_field_custom_legendary:OnIntervalThink()
if not IsServer() then return end


local point = self:GetParent():GetAbsOrigin() + RandomVector(RandomInt(1, self.radius))

self:GetCaster():FindAbilityByName("crystal_maiden_freezing_field_custom"):SummonShard(point, self:GetAbility())

self:IncrementStackCount()

if self:GetStackCount() >= self.max then 
	self:Destroy()
end

AddFOWViewer(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), self.radius, self.damage_interval, false)
self:StartIntervalThink(self.damage_interval)
end







modifier_crystal_maiden_freezing_field_custom_legendary_mini = class({})
function modifier_crystal_maiden_freezing_field_custom_legendary_mini:IsHidden() return false end
function modifier_crystal_maiden_freezing_field_custom_legendary_mini:IsPurgable() return false end

function modifier_crystal_maiden_freezing_field_custom_legendary_mini:OnCreated(table)
if not IsServer() then return end
self.radius = 250 + self:GetCaster():GetTalentValue("modifier_maiden_freezing_3", "radius")
self.damage_ability = table.damage_ability
end


function modifier_crystal_maiden_freezing_field_custom_legendary_mini:OnDestroy()
if not IsServer() then return end

local ability = self:GetCaster():FindAbilityByName("crystal_maiden_freezing_field_custom")

if not ability then return end

local point = self:GetParent():GetAbsOrigin()
local duration = ability:GetSpecialValueFor( "slow_duration" ) + self:GetCaster():GetTalentValue("modifier_maiden_freezing_5", "slow")

local effect_cast2 = ParticleManager:CreateParticle( "particles/maiden_field_legendary.vpcf", PATTACH_WORLDORIGIN, nil )
ParticleManager:SetParticleControl( effect_cast2, 0, point )
ParticleManager:SetParticleControl( effect_cast2, 1, Vector( self.radius, 3, self.radius ) )
ParticleManager:ReleaseParticleIndex( effect_cast2 )

local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), point , nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
for _,enemy in pairs(enemies) do 
		
	ability:DealDamage(enemy, self:GetAbility(), self.damage_ability)
	enemy:AddNewModifier(self:GetCaster(), ability, "modifier_crystal_maiden_freezing_field_custom_debuff", {duration = duration })
end

local copy = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), point , nil, self.radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, 0, false )


for _,unit in pairs(copy) do 
  if unit:HasModifier("modifier_crystal_maiden_crystal_clone_statue") then 
		ability:DealDamage(unit, self:GetAbility(), self.damage_ability)
  end 
end 


EmitSoundOnLocationWithCaster( point, "Maiden.Freezing_damage", self:GetCaster() )
EmitSoundOnLocationWithCaster( point, "Maiden.Freezing_damage2", self:GetCaster() )
end








modifier_crystal_maiden_freezing_field_custom_stack = class({})
function modifier_crystal_maiden_freezing_field_custom_stack:IsHidden() return false end
function modifier_crystal_maiden_freezing_field_custom_stack:IsPurgable() return false end
function modifier_crystal_maiden_freezing_field_custom_stack:GetTexture() return "buffs/freezing_stack" end
function modifier_crystal_maiden_freezing_field_custom_stack:OnCreated(table)
self.max = self:GetCaster():GetTalentValue("modifier_maiden_freezing_3", "max")
self.damage = self:GetCaster():GetTalentValue("modifier_maiden_freezing_3", "damage")

if not IsServer() then return end
self:SetStackCount(1)
end

function modifier_crystal_maiden_freezing_field_custom_stack:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end

self:IncrementStackCount()
end

function modifier_crystal_maiden_freezing_field_custom_stack:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOOLTIP
}
end

function modifier_crystal_maiden_freezing_field_custom_stack:OnTooltip()
return self:GetStackCount()*self.damage
end






modifier_crystal_maiden_freezing_field_custom_invun = class({})
function modifier_crystal_maiden_freezing_field_custom_invun:IsHidden() return true end
function modifier_crystal_maiden_freezing_field_custom_invun:IsPurgable() return false end
function modifier_crystal_maiden_freezing_field_custom_invun:CheckState()
return
{
	[MODIFIER_STATE_INVULNERABLE] = true,
	[MODIFIER_STATE_NO_HEALTH_BAR] = true,
}
end

function modifier_crystal_maiden_freezing_field_custom_invun:GetStatusEffectName()
return "particles/econ/items/effigies/status_fx_effigies/status_effect_effigy_frosty_dire.vpcf"
end

function modifier_crystal_maiden_freezing_field_custom_invun:StatusEffectPriority()
return MODIFIER_PRIORITY_SUPER_ULTRA 
end




modifier_crystal_maiden_freezing_field_custom_scepter = class({})
function modifier_crystal_maiden_freezing_field_custom_scepter:IsHidden() return true end
function modifier_crystal_maiden_freezing_field_custom_scepter:IsPurgable() return false end
function modifier_crystal_maiden_freezing_field_custom_scepter:OnCreated(table)
if not IsServer() then return end 
self.timer = self:GetAbility():GetSpecialValueFor("scepter_timer")
self:SetStackCount(1)
self.interval = table.interval
end 


function modifier_crystal_maiden_freezing_field_custom_scepter:OnRefresh()
if not IsServer() then return end 

self:IncrementStackCount()

if self:GetStackCount()*self.interval >= self.timer then 
	local parent_mod = self:GetCaster():FindModifierByName("modifier_crystal_maiden_freezing_field_custom")


	if parent_mod and parent_mod.scepter_targets and not parent_mod.scepter_targets[self:GetParent()] then 

		parent_mod.scepter_targets[self:GetParent()] = true
		local ability = self:GetCaster():FindAbilityByName("crystal_maiden_frostbite_custom")

		if ability then 
			local duration = (ability:GetSpecialValueFor("duration") + self:GetCaster():GetTalentValue("modifier_maiden_frostbite_6", "duration")) *(1 - self:GetParent():GetStatusResistance())
  		self:GetParent():AddNewModifier(self:GetCaster(), ability, "modifier_crystal_maiden_frostbite_custom", {duration = duration})
		end 

	end 

	self:Destroy()
end 

end 