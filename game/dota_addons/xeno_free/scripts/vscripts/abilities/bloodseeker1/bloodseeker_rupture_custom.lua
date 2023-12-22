LinkLuaModifier("modifier_bloodseeker_rupture_custom", "abilities/bloodseeker/bloodseeker_rupture_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bloodseeker_rupture_custom_reduction", "abilities/bloodseeker/bloodseeker_rupture_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bloodseeker_rupture_custom_legendary", "abilities/bloodseeker/bloodseeker_rupture_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bloodseeker_rupture_custom_legendary_knockback", "abilities/bloodseeker/bloodseeker_rupture_custom", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_bloodseeker_rupture_custom_blood_tracker", "abilities/bloodseeker/bloodseeker_rupture_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bloodseeker_rupture_custom_blood", "abilities/bloodseeker/bloodseeker_rupture_custom", LUA_MODIFIER_MOTION_NONE)

bloodseeker_rupture_custom = class({})

bloodseeker_rupture_custom.bonus_damage = {0.1, 0.15, 0.20}

bloodseeker_rupture_custom.cast_range = 200
bloodseeker_rupture_custom.cast_duration = 1

bloodseeker_rupture_custom.cd = {10, 20, 30}

bloodseeker_rupture_custom.reduction_heal = {-10, -15, -20}
bloodseeker_rupture_custom.reduction_damage = {-6, -9, -12}

bloodseeker_rupture_custom.fear_health = 40
bloodseeker_rupture_custom.fear_duration = 1.5

bloodseeker_rupture_custom.blood_interval = 3
bloodseeker_rupture_custom.blood_duration = 8
bloodseeker_rupture_custom.blood_radius = 200
bloodseeker_rupture_custom.blood_damage = {60, 100}
bloodseeker_rupture_custom.blood_damage_interval = 0.5



function bloodseeker_rupture_custom:Precache(context)

PrecacheResource( "particle", 'particles/units/heroes/hero_bloodseeker/bloodseeker_rupture.vpcf', context )
PrecacheResource( "particle", 'particles/bloodseeker_ground.vpcf', context )
PrecacheResource( "particle", 'particles/status_fx/status_effect_rupture.vpcf', context )
PrecacheResource( "particle", 'particles/brist_proc.vpcf', context )
PrecacheResource( "particle", 'particles/bs_pull_target.vpcf', context )
PrecacheResource( "particle", 'particles/bs_pull.vpcf', context )

end






function bloodseeker_rupture_custom:GetCastRange(vLocation, hTarget)

local upgrade = 0
if self:GetCaster():HasModifier("modifier_bloodseeker_rupture_5") then 
  upgrade = self.cast_range
end
return self.BaseClass.GetCastRange(self , vLocation , hTarget) + upgrade 
end


function bloodseeker_rupture_custom:GetCooldown(iLevel)
local upgrade_cooldown = 0 
if self:GetCaster():HasModifier("modifier_bloodseeker_rupture_3") then 
  upgrade_cooldown = self.cd[self:GetCaster():GetUpgradeStack("modifier_bloodseeker_rupture_3")]
end

return self.BaseClass.GetCooldown(self, iLevel) - upgrade_cooldown
end


function bloodseeker_rupture_custom:OnSpellStart(new_target)
if not IsServer() then return end

local target = self:GetCursorTarget()

if new_target then 
	target = new_target
end




local duration = self:GetSpecialValueFor("duration")*(1 - target:GetStatusResistance())

if self:GetCaster():IsIllusion() then 
	duration = 6*(1 - target:GetStatusResistance())
end

if target:TriggerSpellAbsorb(self) then return end

target:AddNewModifier(self:GetCaster(), self, "modifier_bloodseeker_rupture_custom", {duration = duration})

if self:GetCaster():HasModifier("modifier_bloodseeker_rupture_2") then 
	target:AddNewModifier(self:GetCaster(), self, "modifier_bloodseeker_rupture_custom_reduction", {duration = duration})
end

self:GetCaster():EmitSound("hero_bloodseeker.rupture.cast")
target:EmitSound("hero_bloodseeker.rupture")

end





modifier_bloodseeker_rupture_custom = class({})

function modifier_bloodseeker_rupture_custom:IsPurgable() return false end

function modifier_bloodseeker_rupture_custom:OnCreated()
self.no_damage_distance = self:GetAbility():GetSpecialValueFor("no_damage_distance")

if not IsServer() then return end

self:Init()

self.RemoveForDuel = true
self.origin = self:GetParent():GetAbsOrigin()

local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_bloodseeker/bloodseeker_rupture.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControlEnt(particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
self:AddParticle(particle, false, false, -1, false, false)

self.interval = 0.25
self.count = self:GetAbility().blood_interval - self.interval

self:OnIntervalThink()
self:StartIntervalThink(0.25)
end



function modifier_bloodseeker_rupture_custom:Init()
if not IsServer() then return end

self.movement_damage_pct = self:GetAbility():GetSpecialValueFor("movement_damage_pct") / 100


self:GetParent():EmitSound("hero_bloodseeker.rupture_FP")
self.feared = false

local hp_pct = self:GetAbility():GetSpecialValueFor("hp_pct") / 100
local damage = self:GetParent():GetHealth() * hp_pct
if self:GetCaster():HasModifier("modifier_bloodseeker_rupture_1") then 
	damage = damage*(1 + self:GetAbility().bonus_damage[self:GetCaster():GetUpgradeStack("modifier_bloodseeker_rupture_1")])
end

ApplyDamage({ attacker = self:GetCaster(), victim = self:GetParent(), damage = damage, damage_type = DAMAGE_TYPE_PURE, ability = self:GetAbility() })


end

function modifier_bloodseeker_rupture_custom:OnRefresh()
self:Init()
end






function modifier_bloodseeker_rupture_custom:OnDestroy()
	if not IsServer() then return end
	self:GetParent():StopSound("hero_bloodseeker.rupture_FP")
end

function modifier_bloodseeker_rupture_custom:OnIntervalThink()
if not IsServer() then return end

if self:GetCaster():HasModifier("modifier_bloodseeker_rupture_4") then 

	self.count = self.count + self.interval
	if self.count >= self:GetAbility().blood_interval then 
		self.count = 0

	    CreateModifierThinker(self:GetCaster(), self:GetAbility(), "modifier_bloodseeker_rupture_custom_blood_tracker", {duration = self:GetAbility().blood_duration}, self:GetParent():GetAbsOrigin(), self:GetCaster():GetTeamNumber(), false)
	    self:GetParent():EmitSound("BB.Goo_poison")

	    local particle = ParticleManager:CreateParticle("particles/bloodseeker_ground.vpcf", PATTACH_WORLDORIGIN, nil)
	    ParticleManager:SetParticleControl(particle, 1, self:GetParent():GetAbsOrigin())
	    ParticleManager:SetParticleControl(particle, 3, self:GetParent():GetAbsOrigin())
	    ParticleManager:ReleaseParticleIndex(particle)

	end

end

local current_origin = self:GetParent():GetAbsOrigin()
local distance = (self.origin - current_origin):Length2D()
if distance < self.no_damage_distance then
	local damage = distance * self.movement_damage_pct


	if self:GetCaster():HasModifier("modifier_bloodseeker_rupture_1") then 
		damage = damage*(1 + self:GetAbility().bonus_damage[self:GetCaster():GetUpgradeStack("modifier_bloodseeker_rupture_1")])
	end


	if damage > 0 then
		ApplyDamage({victim = self:GetParent(), attacker = self:GetCaster(), damage = damage, damage_type = DAMAGE_TYPE_PURE, damage_flags = DOTA_DAMAGE_FLAG_NONE, ability = self:GetAbility()})
	end
end
self.origin = self:GetParent():GetAbsOrigin()
end




function modifier_bloodseeker_rupture_custom:GetStatusEffectName()
	return "particles/status_fx/status_effect_rupture.vpcf"
end

function modifier_bloodseeker_rupture_custom:StatusEffectPriority()
	return 500
end


		

function modifier_bloodseeker_rupture_custom:OnAbilityExecuted( params )
if not self:GetCaster():HasModifier("modifier_bloodseeker_rupture_5") then return end
if not IsServer() then return end
if params.unit~=self:GetParent() then return end
if not params.ability then return end
if not params.ability:ProcsMagicStick() then return end
if params.ability:IsItem() or params.ability:IsToggle() then return end
if UnvalidAbilities[params.ability:GetName()] then return end


local particle = ParticleManager:CreateParticle("particles/brist_proc.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:ReleaseParticleIndex(particle)

self:GetParent():EmitSound("BS.Rupture_duration")
self:SetDuration(self:GetRemainingTime() + self:GetAbility().cast_duration, true)
end

function modifier_bloodseeker_rupture_custom:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_TAKEDAMAGE,
    MODIFIER_EVENT_ON_ABILITY_EXECUTED,
}
end


function modifier_bloodseeker_rupture_custom:OnTakeDamage(params)
if not IsServer() then return end
if self:GetParent() ~= params.unit then return end
if not self:GetParent():IsAlive() then return end
if not self:GetCaster():HasModifier("modifier_bloodseeker_rupture_6") then return end
if self:GetParent():GetHealthPercent() > self:GetAbility().fear_health then return end
if self.feared then return end

self:GetParent():EmitSound("BS.Rupture_fear")
self.feared = true
self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_nevermore_requiem_fear", {duration  = self:GetAbility().fear_duration * (1 - self:GetParent():GetStatusResistance())})


end



modifier_bloodseeker_rupture_custom_reduction = class({})
function modifier_bloodseeker_rupture_custom_reduction:IsHidden() return false end
function modifier_bloodseeker_rupture_custom_reduction:IsPurgable() return false end
function modifier_bloodseeker_rupture_custom_reduction:GetTexture() return "buffs/dismember_regen" end

function modifier_bloodseeker_rupture_custom_reduction:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
  MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
  MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE,
  MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
}
end


function modifier_bloodseeker_rupture_custom_reduction:GetModifierLifestealRegenAmplify_Percentage() 
return self:GetAbility().reduction_heal[self:GetCaster():GetUpgradeStack("modifier_bloodseeker_rupture_2")]
end

function modifier_bloodseeker_rupture_custom_reduction:GetModifierHealAmplify_PercentageTarget()
return self:GetAbility().reduction_heal[self:GetCaster():GetUpgradeStack("modifier_bloodseeker_rupture_2")]
end

function modifier_bloodseeker_rupture_custom_reduction:GetModifierHPRegenAmplify_Percentage() 
return self:GetAbility().reduction_heal[self:GetCaster():GetUpgradeStack("modifier_bloodseeker_rupture_2")]
end

function modifier_bloodseeker_rupture_custom_reduction:GetModifierTotalDamageOutgoing_Percentage()
return self:GetAbility().reduction_damage[self:GetCaster():GetUpgradeStack("modifier_bloodseeker_rupture_2")]
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
self.knockback_distance = ((self:GetCaster():GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D() - 100)/self.knockback_count


local iParticleID = ParticleManager:CreateParticle("particles/bs_pull_target.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
self:AddParticle(iParticleID, false, false, -1, false, false)

local particle_cast_2 = "particles/bs_pull.vpcf"
self.effect_cast = ParticleManager:CreateParticle( particle_cast_2, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
ParticleManager:SetParticleControlEnt(self.effect_cast, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true)
ParticleManager:SetParticleControlEnt(self.effect_cast, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true)
self:AddParticle(self.effect_cast, false, false, -1, false, false)

self:OnIntervalThink()
self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("knockback_duration")*2)
end



function modifier_bloodseeker_rupture_custom_legendary:OnIntervalThink()
if not IsServer() then return end

self:GetParent():EmitSound("BS.Rupture_legendary")

self:GetCaster():StartGesture(ACT_DOTA_CAST_ABILITY_6)
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
function modifier_bloodseeker_rupture_custom_blood_tracker:IsAura() return true end
function modifier_bloodseeker_rupture_custom_blood_tracker:GetAuraDuration() return 0.1 end
function modifier_bloodseeker_rupture_custom_blood_tracker:GetAuraRadius() return self:GetAbility().blood_radius
 end

function modifier_bloodseeker_rupture_custom_blood_tracker:OnCreated(table)
if not IsServer() then return end
end


function modifier_bloodseeker_rupture_custom_blood_tracker:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_bloodseeker_rupture_custom_blood_tracker:GetAuraSearchType() return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO end
function modifier_bloodseeker_rupture_custom_blood_tracker:GetModifierAura() return "modifier_bloodseeker_rupture_custom_blood" end


modifier_bloodseeker_rupture_custom_blood = class({})
function modifier_bloodseeker_rupture_custom_blood:IsHidden() return false end
function modifier_bloodseeker_rupture_custom_blood:IsPurgable() return false end
function modifier_bloodseeker_rupture_custom_blood:GetTexture() return "buffs/Rupture_blood" end
function modifier_bloodseeker_rupture_custom_blood:GetAttributes()
return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_bloodseeker_rupture_custom_blood:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_TOOLTIP
}
end

function modifier_bloodseeker_rupture_custom_blood:OnTooltip()
return self.damage
end



function modifier_bloodseeker_rupture_custom_blood:OnCreated(table)

self.damage = self:GetAbility().blood_damage[self:GetCaster():GetUpgradeStack("modifier_bloodseeker_rupture_4")]*self:GetAbility().blood_damage_interval

if not IsServer() then return end
self:StartIntervalThink(self:GetAbility().blood_damage_interval)
self:OnIntervalThink()
end

function modifier_bloodseeker_rupture_custom_blood:OnIntervalThink()
if not IsServer() then return end

local damage =  ApplyDamage({victim = self:GetParent(), attacker = self:GetCaster(), damage = self.damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self:GetAbility()})

SendOverheadEventMessage(self:GetParent(), 4, self:GetParent(), damage, nil)
self:GetCaster():GenericHeal(damage, self:GetAbility(), true)

end



