LinkLuaModifier("modifier_bloodseeker_rupture_custom", "abilities/bloodseeker/bloodseeker_rupture_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bloodseeker_rupture_custom_tracker", "abilities/bloodseeker/bloodseeker_rupture_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bloodseeker_rupture_custom_legendary", "abilities/bloodseeker/bloodseeker_rupture_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bloodseeker_rupture_custom_legendary_knockback", "abilities/bloodseeker/bloodseeker_rupture_custom", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_bloodseeker_rupture_custom_blood_tracker", "abilities/bloodseeker/bloodseeker_rupture_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bloodseeker_rupture_custom_damage", "abilities/bloodseeker/bloodseeker_rupture_custom", LUA_MODIFIER_MOTION_NONE)

bloodseeker_rupture_custom = class({})


bloodseeker_rupture_custom.cast_range = 200
bloodseeker_rupture_custom.cast_duration = 1






function bloodseeker_rupture_custom:Precache(context)

PrecacheResource( "particle", 'particles/units/heroes/hero_bloodseeker/bloodseeker_rupture.vpcf', context )
PrecacheResource( "particle", 'particles/bloodseeker_ground.vpcf', context )
PrecacheResource( "particle", 'particles/status_fx/status_effect_rupture.vpcf', context )
PrecacheResource( "particle", 'particles/brist_proc.vpcf', context )
PrecacheResource( "particle", 'particles/bs_pull_target.vpcf', context )
PrecacheResource( "particle", 'particles/bs_pull.vpcf', context )

end

function bloodseeker_rupture_custom:GetCastPoint()

local bonus = 0
if self:GetCaster():HasModifier("modifier_bloodseeker_rupture_6") then 
  bonus = self:GetCaster():GetTalentValue("modifier_bloodseeker_rupture_6", "cast")
end

return self:GetSpecialValueFor("AbilityCastPoint") + bonus
end



function bloodseeker_rupture_custom:GetCastAnimation()
if self:GetCaster():HasModifier("modifier_bloodseeker_rupture_6") then 
	return 0
end 
	return ACT_DOTA_CAST_ABILITY_6
end


function bloodseeker_rupture_custom:GetIntrinsicModifierName()
return "modifier_bloodseeker_rupture_custom_tracker"
end

function bloodseeker_rupture_custom:OnAbilityPhaseStart()

if self:GetCaster():HasModifier("modifier_bloodseeker_rupture_6") then 
  self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_6, 1.4)
end

return true
end

function bloodseeker_rupture_custom:OnAbilityPhaseInterrupted()

if self:GetCaster():HasModifier("modifier_bloodseeker_rupture_6") then 
  self:GetCaster():RemoveGesture(ACT_DOTA_CAST_ABILITY_6)
end

end



function bloodseeker_rupture_custom:GetCastRange(vLocation, hTarget)

local upgrade = 0
if self:GetCaster():HasModifier("modifier_bloodseeker_rupture_3") then 
  upgrade = self:GetCaster():GetTalentValue("modifier_bloodseeker_rupture_3", "range")
end
return self.BaseClass.GetCastRange(self , vLocation , hTarget) + upgrade 
end


function bloodseeker_rupture_custom:GetCooldown(iLevel)
local upgrade_cooldown = 0 
return self.BaseClass.GetCooldown(self, iLevel) - upgrade_cooldown
end


function bloodseeker_rupture_custom:OnSpellStart(new_target)
if not IsServer() then return end

local target = self:GetCursorTarget()

if new_target then 
	target = new_target
end

local duration = (self:GetSpecialValueFor("duration") + self:GetCaster():GetTalentValue("modifier_bloodseeker_rupture_3", "duration")) *(1 - target:GetStatusResistance())

if self:GetCaster():IsIllusion() then 
	duration = 6*(1 - target:GetStatusResistance())
end






if target:TriggerSpellAbsorb(self) then return end

if self:GetCaster():HasModifier("modifier_bloodseeker_rupture_6") then 
	target:EmitSound("BS.Rupture_fear")
	
	local duration = self:GetCaster():GetTalentValue("modifier_bloodseeker_rupture_6", "fear")

	target:AddNewModifier(self:GetCaster(), self, "modifier_nevermore_requiem_fear", {duration  = duration * (1 - target:GetStatusResistance())})
	 
end

target:AddNewModifier(self:GetCaster(), self, "modifier_bloodseeker_rupture_custom", {duration = duration})

self:GetCaster():EmitSound("hero_bloodseeker.rupture.cast")
target:EmitSound("hero_bloodseeker.rupture")

end





modifier_bloodseeker_rupture_custom = class({})

function modifier_bloodseeker_rupture_custom:IsPurgable() return false end

function modifier_bloodseeker_rupture_custom:OnCreated()
self.no_damage_distance = self:GetAbility():GetSpecialValueFor("no_damage_distance")

self.heal_reduce = self:GetCaster():GetTalentValue("modifier_bloodseeker_rupture_4", "heal_reduce")
self.damage_inc = self:GetCaster():GetTalentValue("modifier_bloodseeker_rupture_4", "damage")

self.damage_reduce = self:GetCaster():GetTalentValue("modifier_bloodseeker_rupture_2", "damage_reduce")
self.armor_reduce = self:GetCaster():GetTalentValue("modifier_bloodseeker_rupture_2", "armor")

if not IsServer() then return end

self.parent = self:GetParent()
self:Init()

self:GetParent():EmitSound("hero_bloodseeker.rupture_FP")

self.RemoveForDuel = true
self.origin = self:GetParent():GetAbsOrigin()

local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_bloodseeker/bloodseeker_rupture.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControlEnt(particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
self:AddParticle(particle, false, false, -1, false, false)

self.blood_timer = self:GetCaster():GetTalentValue("modifier_bloodseeker_rupture_1", "timer")

self.fear_health = self:GetCaster():GetTalentValue("modifier_bloodseeker_rupture_6", "health", true)
self.fear_duration = self:GetCaster():GetTalentValue("modifier_bloodseeker_rupture_6", 'fear', true)

self.interval = 0.25
self.count = self.blood_timer - self.interval

self.creeps_damage = self:GetAbility():GetSpecialValueFor("creeps_damage")*self.interval

self:OnIntervalThink()
self:StartIntervalThink(self.interval)
end



function modifier_bloodseeker_rupture_custom:Init()
if not IsServer() then return end

self.movement_damage_pct = self:GetAbility():GetSpecialValueFor("movement_damage_pct") / 100


local hp_pct = self:GetAbility():GetSpecialValueFor("hp_pct") / 100
local damage = self.parent:GetHealth() * hp_pct

ApplyDamage({ attacker = self:GetCaster(), victim = self.parent, damage = damage, damage_type = DAMAGE_TYPE_PURE, ability = self:GetAbility() })

end


function modifier_bloodseeker_rupture_custom:OnRefresh()
self:Init()
end






function modifier_bloodseeker_rupture_custom:OnDestroy()
if not IsServer() then return end
	self.parent:StopSound("hero_bloodseeker.rupture_FP")
end


function modifier_bloodseeker_rupture_custom:OnIntervalThink()
if not IsServer() then return end

if self:GetCaster():HasModifier("modifier_bloodseeker_rupture_1") and self.blood_timer ~= 0 then 
	self.count = self.count + self.interval
	if self.count >= self.blood_timer then 
		self.count = 0
		local duration = math.max(2 , self:GetRemainingTime())
		CreateModifierThinker(self:GetCaster(), self:GetAbility(), "modifier_bloodseeker_rupture_custom_blood_tracker", {duration = duration}, self.parent:GetAbsOrigin(), self:GetCaster():GetTeamNumber(), false)
		self.parent:EmitSound("BB.Goo_poison")

		local particle = ParticleManager:CreateParticle("particles/bloodseeker_ground.vpcf", PATTACH_WORLDORIGIN, nil)
		ParticleManager:SetParticleControl(particle, 1, self.parent:GetAbsOrigin())
		ParticleManager:SetParticleControl(particle, 2, Vector( duration, 0, 0))
		ParticleManager:SetParticleControl(particle, 3, self.parent:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(particle)
	end
end



if self.parent:IsCreep() then 
	ApplyDamage({victim = self.parent, attacker = self:GetCaster(), damage = self.creeps_damage, damage_type = DAMAGE_TYPE_PURE, damage_flags = DOTA_DAMAGE_FLAG_NONE, ability = self:GetAbility()})
	return
end 



local current_origin = self.parent:GetAbsOrigin()
local distance = (self.origin - current_origin):Length2D()
if distance < self.no_damage_distance then
	local damage = distance * self.movement_damage_pct

	if damage > 0 then
		ApplyDamage({victim = self.parent, attacker = self:GetCaster(), damage = damage, damage_type = DAMAGE_TYPE_PURE, damage_flags = DOTA_DAMAGE_FLAG_NONE, ability = self:GetAbility()})
	end
end

self.origin = self.parent:GetAbsOrigin()
end




function modifier_bloodseeker_rupture_custom:GetStatusEffectName()
	return "particles/status_fx/status_effect_rupture.vpcf"
end

function modifier_bloodseeker_rupture_custom:StatusEffectPriority()
	return 500111
end

function modifier_bloodseeker_rupture_custom:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
  MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
  MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE,
  MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
  MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
}
end



function modifier_bloodseeker_rupture_custom:GetModifierLifestealRegenAmplify_Percentage() 
return self.heal_reduce*self:GetStackCount()
end

function modifier_bloodseeker_rupture_custom:GetModifierHealAmplify_PercentageTarget()
return self.heal_reduce*self:GetStackCount()
end

function modifier_bloodseeker_rupture_custom:GetModifierHPRegenAmplify_Percentage() 
return self.heal_reduce*self:GetStackCount()
end


function modifier_bloodseeker_rupture_custom:GetModifierTotalDamageOutgoing_Percentage()
return self.damage_reduce
end

function modifier_bloodseeker_rupture_custom:GetModifierPhysicalArmorBonus()
return self.armor_reduce
end



function modifier_bloodseeker_rupture_custom:GetModifierIncomingDamage_Percentage(params)
if not IsServer() then return end 
if not params.inflictor then return end 
if params.inflictor ~= self:GetAbility() then return end 

return self.damage_inc*self:GetStackCount()
end 



function modifier_bloodseeker_rupture_custom:OnStackCountChanged(iStackCount)
if not IsServer() then return end

if not self.effect_cast then 

	self.effect_cast = ParticleManager:CreateParticle( "particles/bloodseeker/bloodrage_stack_main.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
	self:AddParticle(self.effect_cast,false, false, -1, false, false) 
end

local k1 = 0
local k2 = self:GetStackCount()

if k2 >= 10 then 
    k1 = 1
    k2 = self:GetStackCount() - 10
end

ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( k1, k2, 0 ) )


end















bloodseeker_rupture_custom_legendary = class({})

function bloodseeker_rupture_custom_legendary:GetChannelTime()
return self:GetCaster():GetTalentValue("modifier_bloodseeker_rupture_7", "duration")
end

function bloodseeker_rupture_custom_legendary:GetCooldown()
	return self:GetCaster():GetTalentValue("modifier_bloodseeker_rupture_7", "cd")
end

function bloodseeker_rupture_custom_legendary:OnSpellStart()
if not IsServer() then return end
self.target = self:GetCursorTarget()

if self:GetCaster():GetUnitName() ~= "npc_dota_hero_bloodseeker" then return end

if self.target:TriggerSpellAbsorb(self) then 
	self:GetCaster():Stop()
	return
end


self:GetCaster():EmitSound("BS.Rupture_legendary_cast")
self.target:AddNewModifier(self:GetCaster(), self, "modifier_bloodseeker_rupture_custom_legendary", {duration = self:GetCaster():GetTalentValue("modifier_bloodseeker_rupture_7", "duration")})
end


function bloodseeker_rupture_custom_legendary:OnChannelFinish(bInterrupted)
if not IsServer() then return end
self.target:RemoveModifierByName("modifier_bloodseeker_rupture_custom_legendary")
end



modifier_bloodseeker_rupture_custom_legendary = class({})
 
function modifier_bloodseeker_rupture_custom_legendary:IsHidden() return true end
function modifier_bloodseeker_rupture_custom_legendary:IsPurgable() return false end
function modifier_bloodseeker_rupture_custom_legendary:OnCreated(table)

self.incoming = self:GetCaster():GetTalentValue("modifier_bloodseeker_rupture_7", "damage")
self.heal = self:GetCaster():GetTalentValue("modifier_bloodseeker_rupture_7", "heal")/100

if not IsServer() then return end
self.knockback_count = self:GetAbility():GetSpecialValueFor("knockback_count")
self.knockback_duration = self:GetAbility():GetSpecialValueFor("knockback_duration")
self.knockback_cd = self:GetAbility():GetSpecialValueFor("knockback_cd")
self.knockback_distance = ((self:GetCaster():GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D() - 100)/self.knockback_count


local iParticleID = ParticleManager:CreateParticle("particles/bs_pull_target.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
self:AddParticle(iParticleID, false, false, -1, false, false)

local particle_cast_2 = "particles/bs_pull.vpcf"
self.effect_cast = ParticleManager:CreateParticle( particle_cast_2, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
ParticleManager:SetParticleControlEnt(self.effect_cast, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true)
ParticleManager:SetParticleControlEnt(self.effect_cast, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true)
self:AddParticle(self.effect_cast, false, false, -1, false, false)

self:OnIntervalThink()
self:StartIntervalThink(self.knockback_cd  + self.knockback_duration)
end



function modifier_bloodseeker_rupture_custom_legendary:OnIntervalThink()
if not IsServer() then return end

self:GetParent():EmitSound("BS.Rupture_legendary")

self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_6, 1.2)
self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_bloodseeker_rupture_custom_legendary_knockback", {distance = self.knockback_distance, duration = self.knockback_duration})
end



function modifier_bloodseeker_rupture_custom_legendary:CheckState()
return
{
	[MODIFIER_STATE_ROOTED] = true
}
end

function modifier_bloodseeker_rupture_custom_legendary:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	MODIFIER_EVENT_ON_TAKEDAMAGE
}

end 

function modifier_bloodseeker_rupture_custom_legendary:GetModifierIncomingDamage_Percentage()
return self.incoming
end


function modifier_bloodseeker_rupture_custom_legendary:OnTakeDamage(params)
if not IsServer() then return end 
if self:GetCaster() ~= params.attacker then return end
if params.unit ~= self:GetParent() then return end 

local heal = params.damage*self.heal

self:GetCaster():GenericHeal(heal, self:GetAbility(), true)

end 



modifier_bloodseeker_rupture_custom_legendary_knockback = class({})

function modifier_bloodseeker_rupture_custom_legendary_knockback:IsHidden() return true end
function modifier_bloodseeker_rupture_custom_legendary_knockback:IsPurgable() return false end

function modifier_bloodseeker_rupture_custom_legendary_knockback:OnCreated(params)
 if not IsServer() then return end
  
  self.ability        = self:GetAbility()
  self.caster         = self:GetCaster()
  self.parent         = self:GetParent()
  self:GetParent():StartGesture(ACT_DOTA_FLAIL)
  
  self.knockback_duration   = self.ability:GetSpecialValueFor("knockback_duration")
  self.dir = (self:GetCaster():GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Normalized()

  --self.knockback_distance   = math.max(self.ability.knockback_distance - (self.caster:GetAbsOrigin() - self.parent:GetAbsOrigin()):Length2D(), 50)
  
  self.position = self:GetParent():GetAbsOrigin() + self.dir*params.distance

  self.knockback_distance = params.distance

  self.knockback_speed    = self.knockback_distance / self.knockback_duration
  
  
  if self:ApplyHorizontalMotionController() == false then 
    self:Destroy()
    return
  end
end

function modifier_bloodseeker_rupture_custom_legendary_knockback:UpdateHorizontalMotion( me, dt )
  if not IsServer() then return end

  local distance = (self.position - me:GetOrigin()):Normalized()
  
  me:SetOrigin( me:GetOrigin() + distance * self.knockback_speed * dt )

  GridNav:DestroyTreesAroundPoint( self.parent:GetOrigin(), self.parent:GetHullRadius(), true )
end

function modifier_bloodseeker_rupture_custom_legendary_knockback:DeclareFunctions()
  local decFuncs = {
    MODIFIER_PROPERTY_OVERRIDE_ANIMATION
    }

    return decFuncs
end

function modifier_bloodseeker_rupture_custom_legendary_knockback:GetOverrideAnimation()
   return ACT_DOTA_FLAIL
end


function modifier_bloodseeker_rupture_custom_legendary_knockback:OnDestroy()
  if not IsServer() then return end
 self.parent:RemoveHorizontalMotionController( self )
  self:GetParent():FadeGesture(ACT_DOTA_FLAIL)
end










modifier_bloodseeker_rupture_custom_blood_tracker = class({})
function modifier_bloodseeker_rupture_custom_blood_tracker:IsHidden() return false end
function modifier_bloodseeker_rupture_custom_blood_tracker:IsPurgable() return false end


function modifier_bloodseeker_rupture_custom_blood_tracker:OnCreated(table)
if not IsServer() then return end

self.radius = self:GetCaster():GetTalentValue("modifier_bloodseeker_rupture_1", "radius")
self.interval = self:GetCaster():GetTalentValue("modifier_bloodseeker_rupture_1", "interval")
self.damage = self:GetCaster():GetTalentValue("modifier_bloodseeker_rupture_1", "damage")*self.interval

self.parent = self:GetParent()
self.caster = self:GetCaster()

self:StartIntervalThink(self.interval)
end


function modifier_bloodseeker_rupture_custom_blood_tracker:OnIntervalThink()
if not IsServer() then return end

for _,target in pairs(self.caster:FindTargets(self.radius, self.parent:GetAbsOrigin())) do 
	ApplyDamage({victim = target, attacker = self.caster, damage = self.damage, damage_type = DAMAGE_TYPE_PURE, ability = self:GetAbility()})
end 

end




modifier_bloodseeker_rupture_custom_tracker = class({})
function modifier_bloodseeker_rupture_custom_tracker:IsHidden() return true end
function modifier_bloodseeker_rupture_custom_tracker:IsPurgable() return false end
function modifier_bloodseeker_rupture_custom_tracker:OnCreated()

self.parent = self:GetParent()

self.cd_items = self:GetCaster():GetTalentValue("modifier_bloodseeker_rupture_5", "cd_items", true)
self.cd_ability = self.parent:GetTalentValue("modifier_bloodseeker_rupture_5", "cd", true)
end 

function modifier_bloodseeker_rupture_custom_tracker:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_ATTACK_LANDED,
}
end

function modifier_bloodseeker_rupture_custom_tracker:OnAttackLanded(params)
if not IsServer() then return end
if self.parent ~= params.attacker then return end 
if not params.target:IsHero() and not params.target:IsCreep() then return end 


local mod = params.target:FindModifierByName("modifier_bloodseeker_rupture_custom")

if self.parent:HasModifier("modifier_bloodseeker_rupture_5") then 
	self.parent:CdAbility(self:GetAbility(), self.cd_ability)
	
	if mod then 
		self.parent:CdItems(self.cd_items)
	end 
end 

if not self.parent:HasModifier("modifier_bloodseeker_rupture_4") then return end
if not mod then return end

if mod:GetStackCount() < self:GetCaster():GetTalentValue("modifier_bloodseeker_rupture_4", "max") then 
	mod:IncrementStackCount()
end 


end 










