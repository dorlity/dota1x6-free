LinkLuaModifier("modifier_custom_huskar_berserkers_blood", "abilities/huskar/custom_huskar_berserkers_blood", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_huskar_berserkers_blood_lowhp", "abilities/huskar/custom_huskar_berserkers_blood", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_huskar_berserkers_blood_lowhp_cd", "abilities/huskar/custom_huskar_berserkers_blood", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_huskar_berserkers_blood_legendary_attack", "abilities/huskar/custom_huskar_berserkers_blood", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_huskar_berserkers_blood_grave", "abilities/huskar/custom_huskar_berserkers_blood", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_huskar_berserkers_blood_grave_cd", "abilities/huskar/custom_huskar_berserkers_blood", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_huskar_berserkers_blood_str", "abilities/huskar/custom_huskar_berserkers_blood", LUA_MODIFIER_MOTION_NONE)


custom_huskar_berserkers_blood              = class({})
modifier_custom_huskar_berserkers_blood         = class({})
modifier_custom_huskar_berserkers_blood_lowhp          = class({})
modifier_custom_huskar_berserkers_blood_armor           = class({})

custom_huskar_berserkers_blood.regen_inc = 5
custom_huskar_berserkers_blood.regen_init = 5
custom_huskar_berserkers_blood.regen_lifesteal = {0.08, 0.12, 0.16}

custom_huskar_berserkers_blood.speed_init = 20
custom_huskar_berserkers_blood.speed_inc = 20

custom_huskar_berserkers_blood.crit_init = 100
custom_huskar_berserkers_blood.crit_inc = 30
custom_huskar_berserkers_blood.crit_chance = 35

custom_huskar_berserkers_blood.damage_heal = 10
custom_huskar_berserkers_blood.damage_duration = 3
custom_huskar_berserkers_blood.damage_resist = 20
custom_huskar_berserkers_blood.damage_cd = 10
custom_huskar_berserkers_blood.damage_max = 6


custom_huskar_berserkers_blood.grave_duration = 1.5
custom_huskar_berserkers_blood.grave_cd = 40


custom_huskar_berserkers_blood.lowhp_health = 35
custom_huskar_berserkers_blood.lowhp_max = 5
custom_huskar_berserkers_blood.lowhp_interval = 1
custom_huskar_berserkers_blood.lowhp_str = {0.03, 0.05}
custom_huskar_berserkers_blood.lowhp_armor = {2, 3}


custom_huskar_berserkers_blood.legendary_attack = 0.05
custom_huskar_berserkers_blood.legendary_interval = 0.5
custom_huskar_berserkers_blood.legendary_cost = 0.05
custom_huskar_berserkers_blood.legendary_move = 25  



function custom_huskar_berserkers_blood:Precache(context)

PrecacheResource( "particle", "particles/units/heroes/hero_huskar/huskar_berserkers_blood.vpcf", context )
PrecacheResource( "particle", "particles/huskar_lowhp.vpcf", context )
PrecacheResource( "particle", "particles/huskar_active.vpcf", context )
PrecacheResource( "particle", "particles/huskar_grave.vpcf", context )
PrecacheResource( "particle", "particles/huskar_str_stack.vpcf", context )

end

function custom_huskar_berserkers_blood:GetAbilityTextureName()
    if self:GetCaster():HasModifier("modifier_huskar_shoulder_immortal") then
        return "huskar/ti8_immortal_shoulder/huskar_inner_vitality_immortal"
    end
    return "huskar_berserkers_blood"
end



function custom_huskar_berserkers_blood:GetIntrinsicModifierName()
  return "modifier_custom_huskar_berserkers_blood"
end

function custom_huskar_berserkers_blood:GetBehavior()
  if self:GetCaster():HasModifier("modifier_huskar_passive_legendary") then
    return DOTA_ABILITY_BEHAVIOR_TOGGLE + DOTA_ABILITY_BEHAVIOR_IMMEDIATE end
 return DOTA_ABILITY_BEHAVIOR_PASSIVE 
end





function custom_huskar_berserkers_blood:GetCooldown(iLevel)

if self:GetCaster():HasModifier("modifier_huskar_passive_legendary") then 
 return self:GetCaster():GetTalentValue('modifier_huskar_passive_legendary', "cd")
end
 
end







function custom_huskar_berserkers_blood:OnToggle()

local caster = self:GetCaster()
local modifier = caster:FindModifierByName( "modifier_custom_huskar_berserkers_blood_legendary_attack" )

if modifier then
   modifier:Destroy()
   self:UseResources(false, false, false, true)
end

if self:GetToggleState() then
  if not modifier then
  CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetCaster():GetPlayerOwnerID()), 'generic_sound',  {sound = "huskar_husk_ability_brskrblood_0"..math.random(3,4)})
   
  self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_custom_huskar_berserkers_blood_legendary_attack", {})
    
 end

end 



end









function modifier_custom_huskar_berserkers_blood:IsHidden() return true end
function modifier_custom_huskar_berserkers_blood:IsPurgable() return false end

  
function modifier_custom_huskar_berserkers_blood:OnCreated()
  self.ability  = self:GetAbility()
  self.caster   = self:GetCaster()
  self.parent   = self:GetParent()
  
  self.maximum_attack_speed   = self.ability:GetSpecialValueFor("maximum_attack_speed")
  self.maximum_health_regen   = self.ability:GetSpecialValueFor("maximum_health_regen")
  self.hp_threshold_max       = self.ability:GetSpecialValueFor("hp_threshold_max")
  self.maximum_resistance     = self.ability:GetSpecialValueFor("maximum_resistance")
  
  self.range          = 100 - self.hp_threshold_max
  self.max_size = 35
  self.str = 0
  if not IsServer() then return end
  

  local particle_name = "particles/units/heroes/hero_huskar/huskar_berserkers_blood.vpcf"
  if self:GetCaster():HasModifier("modifier_huskar_shoulder_immortal") then
      particle_name = "particles/econ/items/huskar/huskar_ti8/huskar_ti8_shoulder_berserk_heal.vpcf"
  end

  self.particle = ParticleManager:CreateParticle(particle_name, PATTACH_ABSORIGIN_FOLLOW, self.parent )


  self:StartIntervalThink(FrameTime())
end

function modifier_custom_huskar_berserkers_blood:OnRefresh()
  self.maximum_attack_speed   = self.ability:GetSpecialValueFor("maximum_attack_speed")
  self.maximum_health_regen   = self.ability:GetSpecialValueFor("maximum_health_regen") 
  self.hp_threshold_max       = self.ability:GetSpecialValueFor("hp_threshold_max")
  self.range            = 100 - self.hp_threshold_max
end

function modifier_custom_huskar_berserkers_blood:OnIntervalThink()
if not IsServer() then return end
  
self:SetStackCount(self.parent:GetStrength())

if self:GetParent():GetHealthPercent() <= self:GetAbility().lowhp_health
    and self:GetParent():HasModifier("modifier_huskar_passive_active") 
    and not self:GetParent():HasModifier("modifier_custom_huskar_berserkers_blood_str") then


    self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_huskar_berserkers_blood_str", {})
end


if self:GetParent():HasModifier("modifier_custom_huskar_berserkers_blood_str") then 
  self.PercentStr  =  self:GetParent():FindModifierByName("modifier_custom_huskar_berserkers_blood_str"):GetStackCount()*self:GetAbility().lowhp_str[self:GetParent():GetUpgradeStack("modifier_huskar_passive_active")]
else 
  self.PercentStr = 0
end 

end



function modifier_custom_huskar_berserkers_blood:OnDestroy()
  if not IsServer() then return end

  ParticleManager:DestroyParticle(self.particle, false)
  ParticleManager:ReleaseParticleIndex(self.particle)

end

function modifier_custom_huskar_berserkers_blood:DeclareFunctions()
  local funcs = {
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
    MODIFIER_PROPERTY_MODEL_SCALE,
    MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
    MODIFIER_EVENT_ON_TAKEDAMAGE,
    MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
    MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
    MODIFIER_PROPERTY_MIN_HEALTH,
  }

  return funcs
end




function modifier_custom_huskar_berserkers_blood:GetMinHealth()
if not self:GetParent():HasModifier("modifier_huskar_passive_armor") then return end
if self:GetParent():IsIllusion() then return end
if not self:GetParent():IsAlive() then return end
if self:GetParent():HasModifier("modifier_death") then return end
if self:GetParent():PassivesDisabled() then return end
if self:GetParent():HasModifier("modifier_custom_huskar_berserkers_blood_grave_cd") then return end

return 1
end

function modifier_custom_huskar_berserkers_blood:OnTakeDamage(params)
if not IsServer() then return end
if self:GetParent():PassivesDisabled() then return end

if self:GetParent():HasModifier("modifier_huskar_passive_regen") and self:GetParent() == params.attacker and params.inflictor == nil  and not params.unit:IsBuilding() and not params.unit:IsIllusion()  then 


  self:GetParent():GenericHeal(params.damage*self:GetAbility().regen_lifesteal[self:GetParent():GetUpgradeStack("modifier_huskar_passive_regen")], self:GetAbility(), true)  
end


if params.unit ~= self:GetParent() then return end
if self:GetParent() == params.attacker then return end

if self:GetParent():HasModifier("modifier_huskar_passive_lowhp")
  and not self:GetParent():HasModifier("modifier_custom_huskar_berserkers_blood_lowhp_cd") then 

    self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_huskar_berserkers_blood_lowhp", {duration = self:GetAbility().damage_duration})
    self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_huskar_berserkers_blood_lowhp_cd", {duration = self:GetAbility().damage_cd - self:GetAbility().damage_max*(1 - self:GetParent():GetHealthPercent()/100)})
end



if not self:GetParent():HasModifier("modifier_huskar_passive_armor") then return end
if self:GetParent():GetHealth() > 1 then return end
if self:GetParent():HasModifier("modifier_custom_huskar_berserkers_blood_grave_cd") then return end
if self:GetParent():HasModifier("modifier_custom_huskar_berserkers_blood_grave") then return end

local duration = self:GetAbility().grave_duration
self:GetParent():EmitSound("Huskar.Passive_Legendary")
self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_huskar_berserkers_blood_grave", {duration = duration})

end


function modifier_custom_huskar_berserkers_blood:GetModifierPreAttack_CriticalStrike( params )
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_huskar_passive_damage") then return end

local damage = self:GetAbility().crit_init + self:GetAbility().crit_inc*self:GetParent():GetUpgradeStack("modifier_huskar_passive_damage")

local chance = (1 - self:GetParent():GetHealthPercent()/100)*self:GetAbility().crit_chance

local random = RollPseudoRandomPercentage(chance,52,self:GetParent())
if not random then return end

self.record = params.record
return damage

end



function modifier_custom_huskar_berserkers_blood:GetModifierProcAttack_Feedback( params )
if not IsServer() then return end
if not self.record or self.record ~= params.record then return end

self.record = nil
params.target:EmitSound("DOTA_Item.Daedelus.Crit")
end






function modifier_custom_huskar_berserkers_blood:GetModifierAttackSpeedBonus_Constant()
  if self.parent:PassivesDisabled() then return end

  local pct = math.max((self.parent:GetHealthPercent() - self.hp_threshold_max) / self.range, 0)
  
  local bonus = 0
  if self:GetParent():HasModifier("modifier_huskar_passive_speed") then 
    bonus = self:GetAbility().speed_init + self:GetAbility().speed_inc*self:GetParent():GetUpgradeStack("modifier_huskar_passive_speed")
  end

  return (self.maximum_attack_speed + bonus) * (1 - pct) * (1 - pct)
end




function modifier_custom_huskar_berserkers_blood:GetModifierConstantHealthRegen()
  if self.parent:PassivesDisabled() then return end

  local pct = math.max((self.parent:GetHealthPercent() - self.hp_threshold_max) / self.range, 0)
  
  return self:GetStackCount() * (self.maximum_health_regen  + (self:GetAbility().regen_init + self:GetAbility().regen_inc*self:GetParent():GetUpgradeStack("modifier_huskar_passive_regen")) )  * 0.01 * (1 - pct) * (1 - pct)
end

function modifier_custom_huskar_berserkers_blood:GetModifierModelScale()
  if not IsServer() then return end
  
  local pct = math.max((self.parent:GetHealthPercent() - self.hp_threshold_max) / self.range, 0)

  ParticleManager:SetParticleControl(self.particle, 1, Vector( (1 - pct) * 100, 0, 0))
  
  self.parent:SetRenderColor(255, 255 * pct, 255 * pct)
  
  return self.max_size * (1 - pct)
end

function modifier_custom_huskar_berserkers_blood:GetActivityTranslationModifiers()
  return "berserkers_blood"
end







--------------------------------------------------------------ТАЛАНТ ЛОУ ХП-----------------------------------------------
function modifier_custom_huskar_berserkers_blood_lowhp:IsHidden() return false end
function modifier_custom_huskar_berserkers_blood_lowhp:IsPurgable() return false end
function modifier_custom_huskar_berserkers_blood_lowhp:GetTexture() return "buffs/warpath_lowhp" end

function modifier_custom_huskar_berserkers_blood_lowhp:GetEffectName() return "particles/huskar_lowhp.vpcf" end
function modifier_custom_huskar_berserkers_blood_lowhp:OnCreated(table)
if not IsServer() then return end
self:GetParent():EmitSound("Huskar.Passive_LowHp")
end

function modifier_custom_huskar_berserkers_blood_lowhp:DeclareFunctions()
  return
{
  MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
  MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE
}

end

function modifier_custom_huskar_berserkers_blood_lowhp:GetModifierHealthRegenPercentage()
 return self:GetAbility().damage_heal/self:GetAbility().damage_duration
 end
function modifier_custom_huskar_berserkers_blood_lowhp:GetModifierStatusResistanceStacking() return self:GetAbility().damage_resist
 end

----------------------------------------------------------------------------------------------------------------------------
modifier_custom_huskar_berserkers_blood_legendary_attack = class({})
function modifier_custom_huskar_berserkers_blood_legendary_attack:IsHidden() return false end
function modifier_custom_huskar_berserkers_blood_legendary_attack:IsPurgable() return false end
function modifier_custom_huskar_berserkers_blood_legendary_attack:GetTexture() return "buffs/berserker_active" end

function modifier_custom_huskar_berserkers_blood_legendary_attack:OnCreated(table)

self.move = self:GetCaster():GetTalentValue('modifier_huskar_passive_legendary', "move")
self.damage = self:GetCaster():GetTalentValue('modifier_huskar_passive_legendary', "damage")/100
self.cost = self:GetCaster():GetTalentValue('modifier_huskar_passive_legendary', "cost")/100
self.interval = self:GetCaster():GetTalentValue('modifier_huskar_passive_legendary', "interval")

if not IsServer() then return end

self:OnIntervalThink()
self:StartIntervalThink(self.interval)

if self.effect_cast then 
  ParticleManager:DestroyParticle(self.effect_cast, false )
  ParticleManager:ReleaseParticleIndex( self.effect_cast ) 
end

self:GetCaster():EmitSound("Huskar.Passive_Active")
self.effect_cast = ParticleManager:CreateParticle( "particles/huskar_active.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
end



function modifier_custom_huskar_berserkers_blood_legendary_attack:OnIntervalThink()
if not IsServer() then return end

local damage = self:GetParent():GetMaxHealth()*self.cost*self.interval

self:GetParent():SetHealth(math.max(1, self:GetParent():GetHealth() - damage))

end



function modifier_custom_huskar_berserkers_blood_legendary_attack:OnDestroy()
if not IsServer() then return end
ParticleManager:DestroyParticle(self.effect_cast, false )
 ParticleManager:ReleaseParticleIndex( self.effect_cast ) 
end

function modifier_custom_huskar_berserkers_blood_legendary_attack:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
  MODIFIER_PROPERTY_TOOLTIP,
}
end



function modifier_custom_huskar_berserkers_blood_legendary_attack:GetModifierMoveSpeedBonus_Percentage()
return self.move
end

function modifier_custom_huskar_berserkers_blood_legendary_attack:GetModifierPreAttack_BonusDamage(params)
  return (self:GetParent():GetMaxHealth() - self:GetParent():GetHealth())*self.damage
end


modifier_custom_huskar_berserkers_blood_grave = class({})

function modifier_custom_huskar_berserkers_blood_grave:GetEffectName() return "particles/huskar_grave.vpcf" end
function modifier_custom_huskar_berserkers_blood_grave:IsHidden() return false end
function modifier_custom_huskar_berserkers_blood_grave:IsPurgable() return false end
function modifier_custom_huskar_berserkers_blood_grave:GetTexture() return "buffs/berserker_grave" end
function modifier_custom_huskar_berserkers_blood_grave:OnDestroy()
if not IsServer() then return end
self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_huskar_berserkers_blood_grave_cd", {duration = self:GetAbility().grave_cd})
end

modifier_custom_huskar_berserkers_blood_grave_cd = class({})
function modifier_custom_huskar_berserkers_blood_grave_cd:IsHidden() return false end
function modifier_custom_huskar_berserkers_blood_grave_cd:IsPurgable() return false end
function modifier_custom_huskar_berserkers_blood_grave_cd:RemoveOnDeath() return false end
function modifier_custom_huskar_berserkers_blood_grave_cd:IsDebuff() return true end
function modifier_custom_huskar_berserkers_blood_grave_cd:GetTexture() return "buffs/berserker_grave" end
function modifier_custom_huskar_berserkers_blood_grave_cd:OnCreated(table)
self.RemoveForDuel = true 
end






modifier_custom_huskar_berserkers_blood_lowhp_cd = class({})
function modifier_custom_huskar_berserkers_blood_lowhp_cd:IsHidden() return false end
function modifier_custom_huskar_berserkers_blood_lowhp_cd:IsPurgable() return false end
function modifier_custom_huskar_berserkers_blood_lowhp_cd:RemoveOnDeath() return false end
function modifier_custom_huskar_berserkers_blood_lowhp_cd:IsDebuff() return true end
function modifier_custom_huskar_berserkers_blood_lowhp_cd:GetTexture() return "buffs/warpath_lowhp" end
function modifier_custom_huskar_berserkers_blood_lowhp_cd:OnCreated(table)
self.RemoveForDuel = true 
end





modifier_custom_huskar_berserkers_blood_str = class({})
function modifier_custom_huskar_berserkers_blood_str:IsHidden() return false end
function modifier_custom_huskar_berserkers_blood_str:IsPurgable() return false end
function modifier_custom_huskar_berserkers_blood_str:GetTexture() return
"buffs/berserker_lowhp" end

function modifier_custom_huskar_berserkers_blood_str:OnCreated(table)
if not IsServer() then return end

self.particle = ParticleManager:CreateParticle("particles/huskar_str_stack.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
self:AddParticle(self.particle, false, false, -1, false, false)


self:SetStackCount(1)
self:StartIntervalThink(self:GetAbility().lowhp_interval)
end

function modifier_custom_huskar_berserkers_blood_str:OnIntervalThink()
if not IsServer() then return end

if self:GetParent():GetHealthPercent() <= self:GetAbility().lowhp_health then 
  if self:GetStackCount() < self:GetAbility().lowhp_max then 
    self:IncrementStackCount()
  end
else 
  self:DecrementStackCount()
  if self:GetStackCount() < 1 then 
    self:Destroy()
  end
end

local max = self:GetAbility().lowhp_max
local tick = 1
local stack = math.floor(self:GetStackCount()/tick)

for i = 1,max do 
  
    if i <= stack then 
      ParticleManager:SetParticleControl(self.particle, i, Vector(1, 0, 0)) 
    else 
      ParticleManager:SetParticleControl(self.particle, i, Vector(0, 0, 0)) 
    end
end



end


function modifier_custom_huskar_berserkers_blood_str:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_TOOLTIP,
  MODIFIER_PROPERTY_MODEL_SCALE,
  MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
}
end

function modifier_custom_huskar_berserkers_blood_str:OnTooltip()
return self:GetStackCount()*self:GetAbility().lowhp_str[self:GetCaster():GetUpgradeStack("modifier_huskar_passive_active")]*100
end


function modifier_custom_huskar_berserkers_blood_str:GetModifierModelScale()
return self:GetStackCount()*3
end


function modifier_custom_huskar_berserkers_blood_str:GetModifierPhysicalArmorBonus()
return self:GetStackCount()*self:GetAbility().lowhp_armor[self:GetCaster():GetUpgradeStack("modifier_huskar_passive_active")]
end