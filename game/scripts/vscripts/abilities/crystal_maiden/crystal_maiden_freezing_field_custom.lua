LinkLuaModifier( "modifier_crystal_maiden_freezing_field_custom", "abilities/crystal_maiden/crystal_maiden_freezing_field_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_crystal_maiden_freezing_field_custom_debuff", "abilities/crystal_maiden/crystal_maiden_freezing_field_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_crystal_maiden_freezing_field_custom_knock", "abilities/crystal_maiden/crystal_maiden_freezing_field_custom", LUA_MODIFIER_MOTION_HORIZONTAL )
LinkLuaModifier( "modifier_crystal_maiden_freezing_field_custom_legendary", "abilities/crystal_maiden/crystal_maiden_freezing_field_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_crystal_maiden_freezing_field_custom_legendary_mini", "abilities/crystal_maiden/crystal_maiden_freezing_field_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_crystal_maiden_freezing_field_custom_tracker", "abilities/crystal_maiden/crystal_maiden_freezing_field_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_crystal_maiden_freezing_field_custom_stack", "abilities/crystal_maiden/crystal_maiden_freezing_field_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_crystal_maiden_freezing_field_custom_invun", "abilities/crystal_maiden/crystal_maiden_freezing_field_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_crystal_maiden_freezing_field_custom_scepter", "abilities/crystal_maiden/crystal_maiden_freezing_field_custom", LUA_MODIFIER_MOTION_NONE )



crystal_maiden_freezing_field_custom = class({})







function crystal_maiden_freezing_field_custom:Precache(context)

PrecacheResource( "particle", "particles/units/heroes/hero_crystalmaiden/maiden_freezing_field_explosion.vpcf", context )
PrecacheResource( "particle", "particles/items_fx/immunity_sphere_buff.vpcf", context )
PrecacheResource( "particle", "particles/items_fx/immunity_sphere.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_crystalmaiden/maiden_freezing_field_snow.vpcf", context )
PrecacheResource( "particle", "particles/generic_gameplay/generic_slowed_cold.vpcf", context )
PrecacheResource( "particle", "particles/status_fx/status_effect_avatar.vpcf", context )
PrecacheResource( "particle", "particles/maiden_freezing_area.vpcf", context )
PrecacheResource( "particle", "particles/maiden_field_legendary.vpcf", context )

end





function crystal_maiden_freezing_field_custom:GetAbilityTextureName()
if self:GetCaster():HasScepter() and self:GetCaster():HasModifier("modifier_crystal_maiden_freezing_field_custom") then 
	return "crystal_maiden_freezing_field_stop"
else 
	return "crystal_maiden_freezing_field"
end 

end


function crystal_maiden_freezing_field_custom:GetIntrinsicModifierName()
return "modifier_crystal_maiden_freezing_field_custom_tracker"
end


function crystal_maiden_freezing_field_custom:GetCooldown(iLevel)

local bonus = 0
if self:GetCaster():HasModifier("modifier_maiden_freezing_1") then 
  bonus = self:GetCaster():GetTalentValue("modifier_maiden_freezing_1", "cd")
end

 return self.BaseClass.GetCooldown(self, iLevel) + bonus
 
end



function crystal_maiden_freezing_field_custom:GetBehavior()
local auto = 0

if self:GetCaster():HasModifier("modifier_maiden_freezing_5") then 
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
if not IsServer() then return end

local ulti_mod = self:GetCaster():FindModifierByName("modifier_crystal_maiden_freezing_field_custom")

if self:GetCaster() and ulti_mod then 

	ulti_mod:Destroy()
	return
end 


local duration = self:GetSpecialValueFor("duration")

local mod = self:GetCaster():FindModifierByName("modifier_crystal_maiden_arcane_aura_custom_spell")
local arcane = self:GetCaster():FindAbilityByName("crystal_maiden_arcane_aura_custom")

if arcane and mod and arcane:GetAutoCastState() == true  then 
  self:GetCaster():EmitSound("Maiden.Frostbite_stun")
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_crystal_maiden_freezing_field_custom_invun", { duration = self:GetCaster():GetTalentValue("modifier_maiden_arcane_6", "bkb")})
	mod:Destroy()
end


self.modifier = self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_crystal_maiden_freezing_field_custom", {duration = duration})

if self:GetCaster():HasScepter() then 
	self:EndCooldown()
	self:StartCooldown(1)
end

end

function crystal_maiden_freezing_field_custom:OnChannelFinish( bInterrupted )

	if self.modifier then
		self.modifier:Destroy()
		self.modifier = nil
	end
end



function crystal_maiden_freezing_field_custom:DealDamage(target, ability)
if not IsServer() then return end

local damage = self:GetSpecialValueFor("damage")
local mod = target:FindModifierByName("modifier_crystal_maiden_freezing_field_custom_stack")

if mod then 
	damage = damage + mod:GetStackCount()*self:GetCaster():GetTalentValue("modifier_maiden_freezing_3", "damage")
	SendOverheadEventMessage(target, 4, target, mod:GetStackCount()*self:GetCaster():GetTalentValue("modifier_maiden_freezing_3", "damage"),nil)
end

local damageTable = { attacker = self:GetCaster(), victim = target, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability}

ApplyDamage(damageTable)

if self:GetCaster():HasModifier("modifier_maiden_freezing_3") then 
	target:AddNewModifier(self:GetCaster(), self, "modifier_crystal_maiden_freezing_field_custom_stack", {duration = self:GetCaster():GetTalentValue("modifier_maiden_freezing_3", "duration")})
end


end



function crystal_maiden_freezing_field_custom:SummonShard(point, ability)
if not IsServer() then return end

local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_crystalmaiden/maiden_freezing_field_explosion.vpcf", PATTACH_WORLDORIGIN, nil )
ParticleManager:SetParticleControl( effect_cast, 0, point )
ParticleManager:ReleaseParticleIndex(effect_cast)

EmitSoundOnLocationWithCaster( point, "hero_Crystal.freezingField.explosion", self:GetCaster() )

CreateModifierThinker(self:GetCaster(), ability, "modifier_crystal_maiden_freezing_field_custom_legendary_mini", {duration = 0.25}, point, self:GetCaster():GetTeamNumber(), false)


end





modifier_crystal_maiden_freezing_field_custom = class({})

function modifier_crystal_maiden_freezing_field_custom:IsHidden() return false end

function modifier_crystal_maiden_freezing_field_custom:IsPurgable()
	return false
end


function modifier_crystal_maiden_freezing_field_custom:OnCreated()	
self.slow_radius = self:GetAbility():GetSpecialValueFor( "radius" )
self.slow_duration = self:GetAbility():GetSpecialValueFor( "slow_duration" ) + self:GetCaster():GetTalentValue("modifier_maiden_freezing_5", "slow")
self.explosion_radius = self:GetAbility():GetSpecialValueFor( "explosion_radius" ) + self:GetCaster():GetTalentValue("modifier_maiden_freezing_1", "radius")
self.explosion_interval = self:GetAbility():GetSpecialValueFor( "explosion_interval" )
self.explosion_min_dist = self:GetAbility():GetSpecialValueFor( "explosion_min_dist" )
self.explosion_max_dist = self:GetAbility():GetSpecialValueFor( "explosion_max_dist" )
self.bonus_armor = self:GetAbility():GetSpecialValueFor("bonus_armor")
self.shard_move = self:GetAbility():GetSpecialValueFor("scepter_move")

self.block_regen = self:GetCaster():GetTalentValue("modifier_maiden_freezing_6", "heal", true )

self.parent = self:GetParent()
self.caster = self:GetCaster()

self.RemoveForDuel = true
self.quartal = -1

if not IsServer() then return end



self.knock_max = self:GetCaster():GetTalentValue("modifier_maiden_freezing_5", "cd", true)
self.knock_silence = self:GetCaster():GetTalentValue("modifier_maiden_freezing_5", "silence", true)
self.knock_duration = self:GetCaster():GetTalentValue("modifier_maiden_freezing_5", "duration", true)
self.knock_count = 0-- self.knock_max


self.scepter_targets = {}

self.sphere = nil

if self:GetParent():HasModifier("modifier_maiden_freezing_6") then 
	self.sphere = ParticleManager:CreateParticle("particles/crystal_maiden/immunity_sphere_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControlEnt(self.sphere, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
	self:AddParticle( self.sphere, false, false, -1, false, false )
end

if not self:GetCaster():HasScepter() then 
	self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_4, 0.8)
else 
	self.explosion_interval = self:GetAbility():GetSpecialValueFor("scepter_interval")
end


self:StartIntervalThink( self.explosion_interval )
self:PlayEffects1()
end



function modifier_crystal_maiden_freezing_field_custom:OnRefresh( kv )
	self:OnCreated()
end




function modifier_crystal_maiden_freezing_field_custom:DeclareFunctions()
local funcs = {

	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
	MODIFIER_PROPERTY_ABSORB_SPELL,
}
	return funcs
end

function modifier_crystal_maiden_freezing_field_custom:GetAbsorbSpell(params) 
if params.ability:GetCaster():GetTeamNumber() == self:GetParent():GetTeamNumber() then return end
if self.sphere == nil then return end
if self:GetParent():IsInvulnerable() then return end

self:GetCaster():EmitSound("DOTA_Item.LinkensSphere.Activate")

if self.sphere then 
	ParticleManager:DestroyParticle(self.sphere, false)
	ParticleManager:ReleaseParticleIndex(self.sphere)
	self.sphere = nil
end

return 1 
end




function modifier_crystal_maiden_freezing_field_custom:GetModifierHealthRegenPercentage()
if not self.caster:HasModifier('modifier_maiden_freezing_6') then return end
return self.block_regen
end


function modifier_crystal_maiden_freezing_field_custom:GetModifierMoveSpeedBonus_Percentage()
if not self.caster:HasScepter() then return end
return self.shard_move
end


function modifier_crystal_maiden_freezing_field_custom:GetModifierPhysicalArmorBonus()
return self.bonus_armor
end




function modifier_crystal_maiden_freezing_field_custom:OnIntervalThink()
if not IsServer() then return end

if self.caster:HasScepter() and (self.caster:IsStunned() or self.caster:IsSilenced() or self.caster:IsHexed() or not self.caster:IsAlive() or self.caster:GetForceAttackTarget() ~= nil) then 
	self:Destroy()
end

local all_enemies = FindUnitsInRadius( self.caster:GetTeamNumber(), self.parent:GetAbsOrigin(), nil, self.slow_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )

local knock = false
if self.caster:HasModifier("modifier_maiden_freezing_5") then 
	self.knock_count = self.knock_count + self.explosion_interval

	if self.knock_count >= self.knock_max then 
		self.knock_count = 0
		knock = true
	end 
end 



for _,enemy in pairs(all_enemies) do 
	enemy:AddNewModifier(self.parent, self:GetAbility(), "modifier_crystal_maiden_freezing_field_custom_debuff", {duration =  self.slow_duration })

	if not self.scepter_targets[enemy] and self.parent:HasScepter() then 
		enemy:AddNewModifier(self.parent, self:GetAbility(), "modifier_crystal_maiden_freezing_field_custom_scepter", {duration = self.explosion_interval + FrameTime()*2, interval = self.explosion_interval})
	end

	if knock == true then 
		enemy:EmitSound("Maiden.Freezing_silence")
		enemy:AddNewModifier(self.parent, self:GetAbility(), "modifier_generic_silence", { duration = (1 - self:GetParent():GetStatusResistance())*self.knock_silence})

		if  self:GetAbility():GetAutoCastState() == true then 
  		enemy:AddNewModifier(self.parent, self:GetAbility(), "modifier_crystal_maiden_freezing_field_custom_knock", {duration = self.knock_duration})
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
	self:GetAbility():DealDamage(enemy, self:GetAbility())
end

local copy = FindUnitsInRadius(self.caster:GetTeamNumber(), point, nil, self.explosion_radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, 0, false )

for _,unit in pairs(copy) do 
  if unit:HasModifier("modifier_crystal_maiden_crystal_clone_statue") then 
		self:GetAbility():DealDamage(unit, self:GetAbility())
  end 
end 




self:PlayEffects2( point )

end





function modifier_crystal_maiden_freezing_field_custom:PlayEffects1()
	if self.effect_cast == nil then
		self.effect_cast = ParticleManager:CreateParticle("particles/units/heroes/hero_crystalmaiden/maiden_freezing_field_snow.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.caster )
		ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( self.slow_radius, self.slow_radius, 1 ) )
		self:AddParticle( self.effect_cast, false, false, -1, false, false )
		self.caster:EmitSound("hero_Crystal.freezingField.wind")
	end
end


function modifier_crystal_maiden_freezing_field_custom:PlayEffects2( point )
	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_crystalmaiden/maiden_freezing_field_explosion.vpcf", PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, point )
	ParticleManager:ReleaseParticleIndex(effect_cast)
	EmitSoundOnLocationWithCaster( point, "hero_Crystal.freezingField.explosion", self.caster )
end


function modifier_crystal_maiden_freezing_field_custom:StopEffects1()
if self.effect_cast then
	ParticleManager:DestroyParticle(self.effect_cast, false)
	ParticleManager:ReleaseParticleIndex(self.effect_cast)
	self.caster:StopSound("hero_Crystal.freezingField.wind")
	self.effect_cast = nil
end

end




function modifier_crystal_maiden_freezing_field_custom:OnDestroy()
if not IsServer() then return end

self.parent:RemoveModifierByName("modifier_crystal_maiden_freezing_field_custom_items_cd")
self.parent:RemoveModifierByName("modifier_crystal_maiden_freezing_field_custom_invun")

if not self.caster:HasScepter() then 
	self.caster:FadeGesture(ACT_DOTA_CAST_ABILITY_4)
else 

	self:GetAbility():UseResources(false, false, false, true)
	self:GetCaster():CdAbility(self:GetAbility(), self:GetElapsedTime())

end

self:StopEffects1()
end














modifier_crystal_maiden_freezing_field_custom_debuff = class({})

function modifier_crystal_maiden_freezing_field_custom_debuff:OnCreated( kv )
self.ms_slow = self:GetAbility():GetSpecialValueFor( "movespeed_slow" )
self.as_slow = self:GetAbility():GetSpecialValueFor( "attack_slow" )
self.radius = self:GetAbility():GetSpecialValueFor("radius")

self.reduction_heal = self:GetCaster():GetTalentValue("modifier_maiden_freezing_2", "heal_reduce", true )
self.reduction_damage = self:GetCaster():GetTalentValue("modifier_maiden_freezing_2", "damage_reduce", true )

end


function modifier_crystal_maiden_freezing_field_custom_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
		MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
	}

	return funcs
end




function modifier_crystal_maiden_freezing_field_custom_debuff:GetModifierLifestealRegenAmplify_Percentage() 
if not self:GetCaster():HasModifier("modifier_maiden_freezing_2") then return end
return self.reduction_heal
end

function modifier_crystal_maiden_freezing_field_custom_debuff:GetModifierHealAmplify_PercentageTarget()
if not self:GetCaster():HasModifier("modifier_maiden_freezing_2") then return end
return self.reduction_heal
end

function modifier_crystal_maiden_freezing_field_custom_debuff:GetModifierHPRegenAmplify_Percentage() 
if not self:GetCaster():HasModifier("modifier_maiden_freezing_2") then return end
return self.reduction_heal
end

function modifier_crystal_maiden_freezing_field_custom_debuff:GetModifierTotalDamageOutgoing_Percentage()
if not self:GetCaster():HasModifier("modifier_maiden_freezing_2") then return end
return self.reduction_damage
end


function modifier_crystal_maiden_freezing_field_custom_debuff:GetStatusEffectName()
return "particles/status_fx/status_effect_frost.vpcf"
end

function modifier_crystal_maiden_freezing_field_custom_debuff:StatusEffectPriority()
return 9999
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
    MODIFIER_EVENT_ON_ABILITY_EXECUTED,
}
end


function modifier_crystal_maiden_freezing_field_custom_tracker:OnCreated()
self.radius = self:GetCaster():GetTalentValue("modifier_maiden_freezing_4", "radius", true)
self.cd_items = self:GetCaster():GetTalentValue("modifier_maiden_freezing_4", "cd_items", true)

self.cd_inc = self:GetCaster():GetTalentValue("modifier_maiden_freezing_7", "cd_inc", true)
end

function modifier_crystal_maiden_freezing_field_custom_tracker:OnAbilityExecuted( params )
if not IsServer() then return end
if params.unit~=self:GetParent() then return end
if not params.ability then return end
if params.ability:IsToggle() then return end
if UnvalidAbilities[params.ability:GetName()] then return end
if UnvalidItems[params.ability:GetName()] then return end
if params.ability:IsItem() and params.ability:GetCurrentCharges() > 0 then return end

if self:GetParent():HasModifier("modifier_maiden_freezing_4") then

	local enemy_heroes = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin() , nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
	local enemy_creeps = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin() , nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )

	local point = nil

	if #enemy_heroes > 0 then
		point = enemy_heroes[1]:GetAbsOrigin()
	else 
		if #enemy_creeps > 0 then 
			point = enemy_creeps[1]:GetAbsOrigin()
		end
	end

	if point ~= nil then

		if RollPseudoRandomPercentage(self:GetCaster():GetTalentValue("modifier_maiden_freezing_4", "chance") ,287,self:GetParent()) then
			self:GetAbility():SummonShard(point, self:GetAbility())
			self:GetCaster():CdItems(self.cd_items)
		end

	end
end


if not self:GetParent():HasModifier("modifier_maiden_freezing_7") then return end
local ability = self:GetParent():FindAbilityByName("crystal_maiden_freezing_field_legendary")
if not ability then return end
if params.ability == ability then return end

self:GetParent():CdAbility(ability, self.cd_inc)


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

self.radius = 250 + self:GetCaster():GetTalentValue("modifier_maiden_freezing_1", "radius")

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
		
	ability:DealDamage(enemy, self:GetAbility())
	enemy:AddNewModifier(self:GetCaster(), ability, "modifier_crystal_maiden_freezing_field_custom_debuff", {duration = duration })
end

local copy = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), point , nil, self.radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, 0, false )


for _,unit in pairs(copy) do 
  if unit:HasModifier("modifier_crystal_maiden_crystal_clone_statue") then 
		ability:DealDamage(unit, self:GetAbility())
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
return 999999
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