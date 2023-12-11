LinkLuaModifier("modifier_custom_huskar_inner_fire_knockback", "abilities/huskar/custom_huskar_inner_fire", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_custom_huskar_inner_fire_disarm", "abilities/huskar/custom_huskar_inner_fire", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_huskar_inner_fire_coil", "abilities/huskar/custom_huskar_inner_fire", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_huskar_inner_fire_root", "abilities/huskar/custom_huskar_inner_fire", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_huskar_inner_fire_heal", "abilities/huskar/custom_huskar_inner_fire", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_huskar_inner_fire_heal_aura", "abilities/huskar/custom_huskar_inner_fire", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_huskar_inner_fire_silence", "abilities/huskar/custom_huskar_inner_fire", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_huskar_inner_fire_silence_timer", "abilities/huskar/custom_huskar_inner_fire", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_huskar_inner_fire_tracker", "abilities/huskar/custom_huskar_inner_fire", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_huskar_inner_fire_lowhp_ready", "abilities/huskar/custom_huskar_inner_fire", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_huskar_inner_fire_aura", "abilities/huskar/custom_huskar_inner_fire", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_huskar_inner_fire_aura_damage", "abilities/huskar/custom_huskar_inner_fire", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_huskar_inner_fire_shard", "abilities/huskar/custom_huskar_inner_fire", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_huskar_inner_fire_legendary_knock", "abilities/huskar/custom_huskar_inner_fire", LUA_MODIFIER_MOTION_HORIZONTAL)




custom_huskar_inner_fire                  = class({})
modifier_custom_huskar_inner_fire_knockback       = class({})
modifier_custom_huskar_inner_fire_disarm          = class({})
modifier_custom_huskar_inner_fire_coil            = class({})
modifier_custom_huskar_inner_fire_root            = class({})
modifier_custom_huskar_inner_fire_heal_aura        = class({})
modifier_custom_huskar_inner_fire_heal            = class({})
modifier_custom_huskar_inner_fire_silence               = class({})
modifier_custom_huskar_inner_fire_silence_timer         = class({})
modifier_custom_huskar_inner_fire_tracker               = class({})



function custom_huskar_inner_fire:Precache(context)

PrecacheResource( "particle", "particles/units/heroes/hero_huskar/huskar_inner_fire.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_huskar/huskar_inner_fire_debuff.vpcf", context )
PrecacheResource( "particle", "particles/huskar_disarm_coil.vpcf", context )
PrecacheResource( "particle", "particles/huskar_disarm_tether.vpcf", context )
PrecacheResource( "particle", "particles/huskar_disarm_heal.vpcf", context )
PrecacheResource( "particle", "particles/huskar_timer.vpcf", context )
PrecacheResource( "particle", "particles/huskar_silence.vpcf", context )
PrecacheResource( "particle", "particles/huskar_leap_heal.vpcf", context )
PrecacheResource( "particle", "particles/huskar_burn_aura.vpcf", context )

my_game:PrecacheShopItems("npc_dota_hero_huskar", context)

end



custom_huskar_inner_fire.max_range = 500
custom_huskar_inner_fire.root_range = 450
custom_huskar_inner_fire.legendary_knockback_duration = 0.3
custom_huskar_inner_fire.legendary_distance = 200
custom_huskar_inner_fire.legendary_duration = 3

custom_huskar_inner_fire.duration_radius = {50, 75, 100}
custom_huskar_inner_fire.duration_inc = {0.3, 0.45, 0.6}

custom_huskar_inner_fire.heal_radius = 350
custom_huskar_inner_fire.heal_heal = {10, 15, 20}
custom_huskar_inner_fire.heal_status = {8, 12, 16}
custom_huskar_inner_fire.heal_duration = 6


custom_huskar_inner_fire.silence_timer = 5
custom_huskar_inner_fire.silence_duration = 3


custom_huskar_inner_fire.cd_max = 4
 

custom_huskar_inner_fire.aura_radius = 500
custom_huskar_inner_fire.aura_damage = {0.15, 0.25}
custom_huskar_inner_fire.aura_active = 3
custom_huskar_inner_fire.aura_interval = 1



function custom_huskar_inner_fire:GetIntrinsicModifierName() return
"modifier_custom_huskar_inner_fire_tracker"
end

function custom_huskar_inner_fire:GetBehavior() 
if self:GetCaster():HasModifier("modifier_huskar_disarm_lowhp") then 
  return  DOTA_ABILITY_BEHAVIOR_IGNORE_PSEUDO_QUEUE + DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE 
end

return DOTA_ABILITY_BEHAVIOR_NO_TARGET
   
end 

function custom_huskar_inner_fire:GetCastRange(vLocation, hTarget)

local radius        = self:GetSpecialValueFor("radius")

if self:GetCaster():HasModifier("modifier_huskar_disarm_duration") then 
  radius = radius + self.duration_radius[self:GetCaster():GetUpgradeStack("modifier_huskar_disarm_duration")]
end

return radius
end


function custom_huskar_inner_fire:GetCooldown(iLevel)

local k = 0

if self:GetCaster():HasModifier("modifier_huskar_disarm_lowhp") then 
  k = (1 - self:GetCaster():GetHealthPercent()/100)*self.cd_max
end

return self.BaseClass.GetCooldown(self, iLevel) - k
end



function custom_huskar_inner_fire:OnSpellStart()
if not IsServer() then return end

if self:GetCaster():HasShard() then 
  self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_custom_huskar_inner_fire_shard", {duration = self:GetSpecialValueFor("shard_duration")})
end

local damage        = self:GetSpecialValueFor("damage")
local radius        = self:GetSpecialValueFor("radius")
local disarm_duration   = self:GetSpecialValueFor("disarm_duration") 
local knockback_distance  = self:GetSpecialValueFor("knockback_distance")
local knockback_duration  = self:GetSpecialValueFor("knockback_duration")

if self:GetCaster():HasModifier("modifier_huskar_disarm_duration") then 
  disarm_duration = disarm_duration + self.duration_inc[self:GetCaster():GetUpgradeStack("modifier_huskar_disarm_duration")]
  radius = radius + self.duration_radius[self:GetCaster():GetUpgradeStack("modifier_huskar_disarm_duration")]
end


if self:GetCaster():HasModifier("modifier_huskar_disarm_crit") then 
  damage = damage + self:GetCaster():GetStrength()*(self:GetCaster():GetTalentValue("modifier_huskar_disarm_crit", "damage"))/100
end

self:GetCaster():EmitSound("Hero_Huskar.Inner_Fire.Cast")

local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_huskar/huskar_inner_fire.vpcf", PATTACH_POINT, self:GetCaster())
ParticleManager:SetParticleControl(particle, 1, Vector(radius, 0, 0))
ParticleManager:SetParticleControl(particle, 3, self:GetCaster():GetAbsOrigin())
ParticleManager:ReleaseParticleIndex(particle)


if self:GetCaster():HasModifier("modifier_huskar_disarm_heal") then 
 CreateModifierThinker(self:GetCaster(),self,"modifier_custom_huskar_inner_fire_heal_aura",{ duration = self.heal_duration },self:GetCaster():GetAbsOrigin(),self:GetCaster():GetTeamNumber(),false)
end

if self:GetCaster():HasModifier("modifier_huskar_disarm_silence") then 
 self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_custom_huskar_inner_fire_silence_timer", {duration = self.silence_timer})
end

local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)


for _, enemy in pairs(enemies) do
  local damageTable = {
    victim      = enemy,
    damage      = damage,
    damage_type   = DAMAGE_TYPE_MAGICAL,
    damage_flags  = DOTA_DAMAGE_FLAG_NONE,
    attacker    = self:GetCaster(),
    ability     = self
  }
  
  ApplyDamage(damageTable)
  

  enemy:AddNewModifier(self:GetCaster(), self, "modifier_custom_huskar_inner_fire_knockback", {duration = knockback_duration * (1 - enemy:GetStatusResistance()), x = self:GetCaster():GetAbsOrigin().x, y = self:GetCaster():GetAbsOrigin().y})
  enemy:AddNewModifier(self:GetCaster(), self, "modifier_custom_huskar_inner_fire_disarm", {duration = disarm_duration * (1 - enemy:GetStatusResistance())})
 
  if self:GetCaster():HasModifier("modifier_huskar_disarm_legendary") then 
    enemy:AddNewModifier(self:GetCaster(), self, "modifier_custom_huskar_inner_fire_root", {duration = self.legendary_duration*(1 - enemy:GetStatusResistance()), originX = self:GetCaster():GetAbsOrigin().x, originY = self:GetCaster():GetAbsOrigin().y ,originZ = self:GetCaster():GetAbsOrigin().z, })
  end 
    
end


if self:GetCaster():HasModifier("modifier_huskar_disarm_legendary") then 
  CreateModifierThinker(self:GetCaster(),self,"modifier_custom_huskar_inner_fire_coil",{ duration = self.legendary_duration },self:GetCaster():GetAbsOrigin(),self:GetCaster():GetTeamNumber(),false)
end 
  


end

-----------------------------------
-- INNER FIRE KNOCKBACK MODIFIER --
-----------------------------------

function modifier_custom_huskar_inner_fire_knockback:IsHidden() return true end

function modifier_custom_huskar_inner_fire_knockback:OnCreated(params)
  if not IsServer() then return end
  
  self.ability        = self:GetAbility()
  self.caster         = self:GetCaster()
  self.parent         = self:GetParent()
  self:GetParent():StartGesture(ACT_DOTA_FLAIL)
  
  -- AbilitySpecials
  self.knockback_duration   = self.ability:GetSpecialValueFor("knockback_duration")
  -- Knockbacks a set distance, so change this value based on distance from caster and parent
  self.knockback_distance   = math.max(self.ability:GetSpecialValueFor("knockback_distance") - (self.caster:GetAbsOrigin() - self.parent:GetAbsOrigin()):Length2D(), 50)
  
  -- Calculate speed at which modifier owner will be knocked back
  self.knockback_speed    = self.knockback_distance / self.knockback_duration
  
  -- Get the center of the Blinding Light sphere to know which direction to get knocked back
  self.position = GetGroundPosition(Vector(params.x, params.y, 0), nil)
  
  if self:ApplyHorizontalMotionController() == false then 
    self:Destroy()
    return
  end
end

function modifier_custom_huskar_inner_fire_knockback:UpdateHorizontalMotion( me, dt )
  if not IsServer() then return end

  local distance = (me:GetOrigin() - self.position):Normalized()
  
  me:SetOrigin( me:GetOrigin() + distance * self.knockback_speed * dt )
  
  -- Destroy any trees passed through
  GridNav:DestroyTreesAroundPoint( self.parent:GetOrigin(), self.parent:GetHullRadius(), true )
end

function modifier_custom_huskar_inner_fire_knockback:DeclareFunctions()
  local decFuncs = {
    MODIFIER_PROPERTY_OVERRIDE_ANIMATION
    }

    return decFuncs
end

function modifier_custom_huskar_inner_fire_knockback:GetOverrideAnimation()
   return ACT_DOTA_FLAIL
end


function modifier_custom_huskar_inner_fire_knockback:OnDestroy()
  if not IsServer() then return end
  
  self.parent:RemoveHorizontalMotionController( self )
  self:GetParent():FadeGesture(ACT_DOTA_FLAIL)
end

--------------------------------
-- INNER FIRE DISARM MODIFIER --
--------------------------------

function modifier_custom_huskar_inner_fire_disarm:GetEffectName()
  return "particles/units/heroes/hero_huskar/huskar_inner_fire_debuff.vpcf"
end

function modifier_custom_huskar_inner_fire_disarm:GetEffectAttachType()
  return PATTACH_OVERHEAD_FOLLOW
end

function modifier_custom_huskar_inner_fire_disarm:CheckState()
  return {[MODIFIER_STATE_DISARMED] = true}
end

function modifier_custom_huskar_inner_fire_disarm:DeclareFunctions()
if self:GetCaster():HasShard() then 
return
{
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
else 
  return
end 

end


function modifier_custom_huskar_inner_fire_disarm:GetModifierMoveSpeedBonus_Percentage() return self:GetAbility():GetSpecialValueFor("shard_slow")
end



function modifier_custom_huskar_inner_fire_disarm:OnCreated(table)
if not IsServer() then return end
if not self:GetParent():IsRealHero() then return end

if self:GetCaster():GetQuest() == "Huskar.Quest_5" then 
  self:StartIntervalThink(0.1)
end

end

function modifier_custom_huskar_inner_fire_disarm:OnIntervalThink()
if not IsServer() then return end
if self:GetCaster():QuestCompleted() then return end

self:GetCaster():UpdateQuest(0.1)
end



-----------------------------------------------------------------ЦЕНТР СВЯЗКИ--------------------------------------------
function modifier_custom_huskar_inner_fire_coil:IsHidden() return true end
function modifier_custom_huskar_inner_fire_coil:IsPurgable() return false end
function modifier_custom_huskar_inner_fire_coil:OnCreated(table)
if not IsServer() then return end


self.effect_cast = ParticleManager:CreateParticle( "particles/huskar_disarm_coil.vpcf", PATTACH_WORLDORIGIN, self:GetParent() )
ParticleManager:SetParticleControl( self.effect_cast, 0, self:GetParent():GetOrigin() )
end


function modifier_custom_huskar_inner_fire_coil:OnDestroy()
if not IsServer() then return end
  ParticleManager:DestroyParticle(self.effect_cast, true)
  ParticleManager:ReleaseParticleIndex(self.effect_cast)
end

----------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------СВЯЗКА--------------------------------------------

function modifier_custom_huskar_inner_fire_root:IsHidden() return false end
function modifier_custom_huskar_inner_fire_root:IsPurgable() return false end
function modifier_custom_huskar_inner_fire_root:GetTexture() return "buffs/disarm_root" end
function modifier_custom_huskar_inner_fire_root:OnCreated(table)
if not IsServer() then return end

self.center = Vector(table.originX,table.originY,table.originZ)

local vec = (self:GetParent():GetAbsOrigin() - self.center):Normalized()

self.knock_point = self.center + vec*self:GetAbility().legendary_distance


self:StartIntervalThink(FrameTime())

local effect_cast = ParticleManager:CreateParticle( "particles/huskar_disarm_tether.vpcf", PATTACH_ABSORIGIN, self:GetParent() )
ParticleManager:SetParticleControl( effect_cast, 0, self.center )
ParticleManager:SetParticleControlEnt(effect_cast,1,self:GetParent(),PATTACH_POINT_FOLLOW,"attach_hitloc",self:GetParent():GetOrigin(),true)
self:AddParticle(effect_cast,false,false,-1,false,false)

end



function modifier_custom_huskar_inner_fire_root:OnIntervalThink()
if not IsServer() then return end
if self:GetParent():HasModifier("modifier_custom_huskar_inner_fire_legendary_knock") then return end
if self:GetParent():IsInvulnerable() or self:GetParent():IsOutOfGame() then return end
if self:GetParent():IsDebuffImmune() then return end


if  (self:GetParent():GetAbsOrigin() - self.center):Length2D() <= self:GetAbility().root_range then return end
  
self:GetParent():EmitSound("Huskar.Disarm_Legendary") 

local damage =  self:GetAbility():GetSpecialValueFor("damage")

if self:GetCaster():HasModifier("modifier_huskar_disarm_crit") then 
  damage = damage + self:GetCaster():GetStrength()*(self:GetCaster():GetTalentValue("modifier_huskar_disarm_crit", "damage"))/100
end

ApplyDamage({victim = self:GetParent(), attacker = self:GetCaster(), damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self:GetAbility()})          


self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_phased", {})
self:GetParent():RemoveModifierByName("modifier_custom_huskar_inner_fire_knockback")


self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_huskar_inner_fire_legendary_knock", {duration = self:GetAbility().legendary_knockback_duration, x = self.knock_point.x, y = self.knock_point.y})
        
    
end





modifier_custom_huskar_inner_fire_legendary_knock = class({})

function modifier_custom_huskar_inner_fire_legendary_knock:IsHidden() return true end

function modifier_custom_huskar_inner_fire_legendary_knock:OnCreated(params)
  if not IsServer() then return end
  
    
  self.ability        = self:GetAbility()
  self.caster         = self:GetCaster()
  self.parent         = self:GetParent()
  self:GetParent():StartGesture(ACT_DOTA_FLAIL)
  
  self.knockback_duration   = self.ability.legendary_knockback_duration

  --self.knockback_distance   = math.max(self.ability.knockback_distance - (self.caster:GetAbsOrigin() - self.parent:GetAbsOrigin()):Length2D(), 50)
  
  self.position = GetGroundPosition(Vector(params.x, params.y, 0), nil)

  self.knockback_distance = (self:GetParent():GetAbsOrigin() -self.position):Length2D() 

  self.knockback_speed    = self.knockback_distance / self.knockback_duration
  
  
  if self:ApplyHorizontalMotionController() == false then 
    self:Destroy()
    return
  end
end

function modifier_custom_huskar_inner_fire_legendary_knock:UpdateHorizontalMotion( me, dt )
  if not IsServer() then return end

  local distance = (self.position - me:GetOrigin()):Normalized()
  
  me:SetOrigin( me:GetOrigin() + distance * self.knockback_speed * dt )

  GridNav:DestroyTreesAroundPoint( self.parent:GetOrigin(), self.parent:GetHullRadius(), true )
end

function modifier_custom_huskar_inner_fire_legendary_knock:DeclareFunctions()
  local decFuncs = {
    MODIFIER_PROPERTY_OVERRIDE_ANIMATION
    }

    return decFuncs
end

function modifier_custom_huskar_inner_fire_legendary_knock:GetOverrideAnimation()
   return ACT_DOTA_FLAIL
end


function modifier_custom_huskar_inner_fire_legendary_knock:OnDestroy()
  if not IsServer() then return end
 self.parent:RemoveHorizontalMotionController( self )
  self:GetParent():FadeGesture(ACT_DOTA_FLAIL)
end


----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------АУРА ХИЛА-----------------------------------------------------------------

function  modifier_custom_huskar_inner_fire_heal_aura:IsHidden() return false end

function  modifier_custom_huskar_inner_fire_heal_aura:IsPurgable() return false end

function  modifier_custom_huskar_inner_fire_heal_aura:IsAura() return true end

function  modifier_custom_huskar_inner_fire_heal_aura:GetAuraDuration() return 0.1 end

function  modifier_custom_huskar_inner_fire_heal_aura:GetAuraRadius() return self:GetAbility().heal_radius end

function  modifier_custom_huskar_inner_fire_heal_aura:OnCreated(table)
if not IsServer() then return end

self.particle = ParticleManager:CreateParticle("particles/huskar_disarm_heal.vpcf", PATTACH_POINT, self:GetCaster())
ParticleManager:SetParticleControl(self.particle, 1, Vector(self:GetAbility().heal_radius, 0, 0))
ParticleManager:SetParticleControl(self.particle, 2, Vector(self:GetAbility().heal_duration + 1, 0, 0))
 
end

function  modifier_custom_huskar_inner_fire_heal_aura:OnDestroy()
if not IsServer() then return end
ParticleManager:DestroyParticle(self.particle, false )
ParticleManager:ReleaseParticleIndex(self.particle)

end

function  modifier_custom_huskar_inner_fire_heal_aura:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end

function  modifier_custom_huskar_inner_fire_heal_aura:GetAuraSearchType() return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO end

function  modifier_custom_huskar_inner_fire_heal_aura:GetModifierAura() return "modifier_custom_huskar_inner_fire_heal" end



function modifier_custom_huskar_inner_fire_heal:IsHidden() return false end
function modifier_custom_huskar_inner_fire_heal:IsPurgable() return false end
function modifier_custom_huskar_inner_fire_heal:OnCreated(table)
if not IsServer() then return end
self:GetParent():EmitSound("Huskar.Heal_Loop")
end
function modifier_custom_huskar_inner_fire_heal:OnDestroy()
if not IsServer() then return end
self:GetParent():StopSound("Huskar.Heal_Loop")
self:GetParent():EmitSound("Huskar.Heal_End")
end

function modifier_custom_huskar_inner_fire_heal:GetTexture() return "buffs/inner_heal" end
function modifier_custom_huskar_inner_fire_heal:DeclareFunctions()
return
{

  MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
  MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
  MODIFIER_PROPERTY_TOOLTIP,
  MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
  MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE
}

end


function modifier_custom_huskar_inner_fire_heal:GetModifierLifestealRegenAmplify_Percentage() 
 return self:GetAbility().heal_heal[self:GetCaster():GetUpgradeStack("modifier_huskar_disarm_heal")]
 end

function modifier_custom_huskar_inner_fire_heal:GetModifierHealAmplify_PercentageTarget()
 return self:GetAbility().heal_heal[self:GetCaster():GetUpgradeStack("modifier_huskar_disarm_heal")]
 end

function modifier_custom_huskar_inner_fire_heal:GetModifierHPRegenAmplify_Percentage()  
return self:GetAbility().heal_heal[self:GetCaster():GetUpgradeStack("modifier_huskar_disarm_heal")]
 end

function modifier_custom_huskar_inner_fire_heal:GetModifierStatusResistanceStacking() 
return self:GetAbility().heal_status[self:GetCaster():GetUpgradeStack("modifier_huskar_disarm_heal")]
 end



----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------STR AURA-----------------------------------------------------



----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------SILENCE TIMER-----------------------------------------------------

function modifier_custom_huskar_inner_fire_silence_timer:IsHidden() return false end 
function modifier_custom_huskar_inner_fire_silence_timer:IsPurgable() return false end
function modifier_custom_huskar_inner_fire_silence_timer:GetTexture() return "buffs/inner_timer" end
function modifier_custom_huskar_inner_fire_silence_timer:GetAttributes()  return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_custom_huskar_inner_fire_silence_timer:OnCreated(table)
if not IsServer() then return end
  self.t = -1
  self.timer = self:GetAbility().silence_timer*2 
  self:StartIntervalThink(0.5)
  self:OnIntervalThink()
end
function modifier_custom_huskar_inner_fire_silence_timer:OnIntervalThink()
if not IsServer() then return end
self.t = self.t + 1
local caster = self:GetParent()

local number = (self.timer-self.t)/2 
local int = 0
int = number
if number % 1 ~= 0 then int = number - 0.5  end

local digits = math.floor(math.log10(number)) + 2

local decimal = number % 1

if decimal == 0.5 then
decimal = 8
else 
decimal = 1
end

local particleName = "particles/huskar_timer.vpcf"
local particle = ParticleManager:CreateParticle(particleName, PATTACH_OVERHEAD_FOLLOW, caster)
ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin())
ParticleManager:SetParticleControl(particle, 1, Vector(0, int, decimal))
ParticleManager:SetParticleControl(particle, 2, Vector(digits, 0, 0))
ParticleManager:ReleaseParticleIndex(particle)

end

function modifier_custom_huskar_inner_fire_silence_timer:OnDestroy()
if not IsServer() then return end

  local damage        = self:GetAbility():GetSpecialValueFor("damage")
  local radius        = self:GetAbility():GetSpecialValueFor("radius")
  local disarm_duration   = self:GetAbility():GetSpecialValueFor("disarm_duration")
  local knockback_distance  = self:GetAbility():GetSpecialValueFor("knockback_distance")
  local knockback_duration  = self:GetAbility():GetSpecialValueFor("knockback_duration")

  if self:GetCaster():HasModifier("modifier_huskar_disarm_duration") then 
    disarm_duration = disarm_duration + self:GetAbility().duration_inc[self:GetCaster():GetUpgradeStack("modifier_huskar_disarm_duration")]
    radius = radius + self:GetAbility().duration_radius[self:GetCaster():GetUpgradeStack("modifier_huskar_disarm_duration")]
  end



  if self:GetCaster():HasModifier("modifier_huskar_disarm_crit") then 
    damage = damage + self:GetCaster():GetStrength()*(self:GetCaster():GetTalentValue("modifier_huskar_disarm_crit", "damage"))/100
  end

  self:GetCaster():EmitSound("Hero_Huskar.Inner_Fire.Cast")
  
  local particle = ParticleManager:CreateParticle("particles/huskar_silence.vpcf", PATTACH_POINT, self:GetCaster())
  ParticleManager:SetParticleControl(particle, 1, Vector(radius, 0, 0))
  ParticleManager:SetParticleControl(particle, 3, self:GetCaster():GetAbsOrigin())
  ParticleManager:ReleaseParticleIndex(particle)


  local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

  for _, enemy in pairs(enemies) do
    local damageTable = {
      victim      = enemy,
      damage      = damage,
      damage_type   = DAMAGE_TYPE_MAGICAL,
      damage_flags  = DOTA_DAMAGE_FLAG_NONE,
      attacker    = self:GetCaster(),
      ability     = self:GetAbility()
    }
    
    ApplyDamage(damageTable)
    
    enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_huskar_inner_fire_knockback", {duration = knockback_duration * (1 - enemy:GetStatusResistance()), x = self:GetCaster():GetAbsOrigin().x, y = self:GetCaster():GetAbsOrigin().y})
    enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_huskar_inner_fire_silence", {duration = self:GetAbility().silence_duration * (1 - enemy:GetStatusResistance())})
    

  end
    


end

function modifier_custom_huskar_inner_fire_silence:IsHidden() return false end 
function modifier_custom_huskar_inner_fire_silence:IsPurgable() return true end
function modifier_custom_huskar_inner_fire_silence:CheckState() return {[MODIFIER_STATE_SILENCED] = true} end
function modifier_custom_huskar_inner_fire_silence:GetEffectName() return "particles/generic_gameplay/generic_silenced.vpcf" end
function modifier_custom_huskar_inner_fire_silence:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end

function modifier_custom_huskar_inner_fire_silence:DeclareFunctions()
if self:GetCaster():HasShard() then 
return
{

    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
else 
  return
end 

end



function modifier_custom_huskar_inner_fire_silence:GetModifierMoveSpeedBonus_Percentage() return self:GetAbility():GetSpecialValueFor("shard_slow")
 end



----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------TRACKER-----------------------------------------------------

function modifier_custom_huskar_inner_fire_tracker:IsHidden() return true end
function modifier_custom_huskar_inner_fire_tracker:IsPurgable() return false end
function modifier_custom_huskar_inner_fire_tracker:DeclareFunctions()
return 
{
}
end





function modifier_custom_huskar_inner_fire_tracker:OnCreated(table)
if not IsServer() then return end
--self:StartIntervalThink(0.2)
end
















modifier_custom_huskar_inner_fire_aura = class({})

function modifier_custom_huskar_inner_fire_aura:IsHidden() return false end
function modifier_custom_huskar_inner_fire_aura:IsPurgable() return false end
function modifier_custom_huskar_inner_fire_aura:IsDebuff() return false end
function modifier_custom_huskar_inner_fire_aura:GetTexture() return "buffs/berserker_armor" end
function modifier_custom_huskar_inner_fire_aura:RemoveOnDeath() return false end



function modifier_custom_huskar_inner_fire_aura:GetAuraRadius()
  return self:GetAbility().aura_radius
end

function modifier_custom_huskar_inner_fire_aura:GetAuraSearchTeam()
  return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_custom_huskar_inner_fire_aura:GetAuraSearchType() 
  return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end


function modifier_custom_huskar_inner_fire_aura:GetModifierAura()
  return "modifier_custom_huskar_inner_fire_aura_damage"
end

function modifier_custom_huskar_inner_fire_aura:IsAura()
  return true
end

function modifier_custom_huskar_inner_fire_aura:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_TOOLTIP
}
end


function modifier_custom_huskar_inner_fire_aura:OnTooltip()

return self:GetAbility().aura_damage[self:GetCaster():GetUpgradeStack("modifier_huskar_disarm_str")]*self:GetCaster():GetStrength()
end

modifier_custom_huskar_inner_fire_aura_damage = class({})
function modifier_custom_huskar_inner_fire_aura_damage:IsHidden() return false end
function modifier_custom_huskar_inner_fire_aura_damage:IsPurgable() return false end
function modifier_custom_huskar_inner_fire_aura_damage:GetTexture() return "buffs/berserker_armor" end

function modifier_custom_huskar_inner_fire_aura_damage:OnCreated(table)
if not IsServer() then return end
self:StartIntervalThink(self:GetAbility().aura_interval)

end

function modifier_custom_huskar_inner_fire_aura_damage:OnIntervalThink()
if not IsServer() then return end


local k = 1
if self:GetParent():HasModifier("modifier_custom_huskar_inner_fire_disarm") or self:GetParent():HasModifier("modifier_custom_huskar_inner_fire_silence") then 
  k = self:GetAbility().aura_active
end

self.damage =  (self:GetAbility().aura_interval*self:GetAbility().aura_damage[self:GetCaster():GetUpgradeStack("modifier_huskar_disarm_str")]*self:GetCaster():GetStrength())*k 


ApplyDamage({victim = self:GetParent(), attacker = self:GetCaster(), ability = self:GetAbility(), damage = self.damage, damage_type = DAMAGE_TYPE_MAGICAL})
end




function modifier_custom_huskar_inner_fire_aura_damage:GetEffectName()
  return "particles/huskar_burn_aura.vpcf"
end

function modifier_custom_huskar_inner_fire_aura_damage:GetEffectAttachType()
  return PATTACH_ABSORIGIN_FOLLOW
end
function modifier_custom_huskar_inner_fire_aura_damage:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_TOOLTIP
}
end


function modifier_custom_huskar_inner_fire_aura_damage:OnTooltip()

local k = 1
if self:GetParent():HasModifier("modifier_custom_huskar_inner_fire_disarm") or self:GetParent():HasModifier("modifier_custom_huskar_inner_fire_silence") then 
  k = self:GetAbility().aura_active
end

return (self:GetAbility().aura_interval*self:GetAbility().aura_damage[self:GetCaster():GetUpgradeStack("modifier_huskar_disarm_str")]*self:GetCaster():GetStrength())*k 


end


modifier_custom_huskar_inner_fire_shard = class({})
function modifier_custom_huskar_inner_fire_shard:IsHidden() return false end
function modifier_custom_huskar_inner_fire_shard:IsPurgable() return false end
function modifier_custom_huskar_inner_fire_shard:OnCreated(table)
if not IsServer() then return end

end

function modifier_custom_huskar_inner_fire_shard:DeclareFunctions()
return
{
  MODIFIER_EVENT_ON_TAKEDAMAGE
}
end


function modifier_custom_huskar_inner_fire_shard:OnTakeDamage(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end
if not params.unit:IsCreep() and not params.unit:IsHero() then return end
if self:GetParent() == params.unit then return end
if bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then return end

local heal = self:GetAbility():GetSpecialValueFor("shard_heal")/100
if params.unit:IsCreep() then 
  heal = heal / self:GetAbility():GetSpecialValueFor("shard_heal_creeps")
end

heal = heal*params.damage

self:GetParent():GenericHeal(heal, self:GetAbility(), true)

end