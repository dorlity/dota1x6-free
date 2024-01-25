LinkLuaModifier("modifier_custom_huskar_berserkers_blood", "abilities/huskar/custom_huskar_berserkers_blood", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_huskar_berserkers_blood_status", "abilities/huskar/custom_huskar_berserkers_blood", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_huskar_berserkers_blood_legendary_attack", "abilities/huskar/custom_huskar_berserkers_blood", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_huskar_berserkers_blood_grave", "abilities/huskar/custom_huskar_berserkers_blood", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_huskar_berserkers_blood_grave_cd", "abilities/huskar/custom_huskar_berserkers_blood", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_huskar_berserkers_blood_str", "abilities/huskar/custom_huskar_berserkers_blood", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_huskar_berserkers_blood_slow", "abilities/huskar/custom_huskar_berserkers_blood", LUA_MODIFIER_MOTION_NONE)

custom_huskar_berserkers_blood              = class({})



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
  return DOTA_ABILITY_BEHAVIOR_TOGGLE + DOTA_ABILITY_BEHAVIOR_IMMEDIATE 
end

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









modifier_custom_huskar_berserkers_blood         = class({})
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

self.speed_k = self:GetCaster():GetTalentValue("modifier_huskar_passive_damage", "bonus", true)
self.speed_health = self:GetCaster():GetTalentValue("modifier_huskar_passive_damage", "health", true)
self.speed_duration = self:GetCaster():GetTalentValue("modifier_huskar_passive_damage", "duration", true)

self.str_health = self:GetCaster():GetTalentValue("modifier_huskar_passive_active", "health", true)

self.status_health = self:GetCaster():GetTalentValue("modifier_huskar_passive_lowhp", "health", true)

self.grave_cd = self:GetCaster():GetTalentValue("modifier_huskar_passive_armor", "cd", true)
self.grave_duration = self:GetCaster():GetTalentValue("modifier_huskar_passive_armor", "duration", true)

if not IsServer() then return end

local particle_name = "particles/units/heroes/hero_huskar/huskar_berserkers_blood.vpcf"
if self:GetCaster():HasModifier("modifier_huskar_shoulder_immortal") then
    particle_name = "particles/econ/items/huskar/huskar_ti8/huskar_ti8_shoulder_berserk_heal.vpcf"
end

self.particle = ParticleManager:CreateParticle(particle_name, PATTACH_ABSORIGIN_FOLLOW, self.parent )
self:AddParticle(self.particle, false, false, -1, false, false)

self.interval = 0.05
self:SetStackCount(0)
self:OnIntervalThink()
self:StartIntervalThink(self.interval)
end

function modifier_custom_huskar_berserkers_blood:OnRefresh()
self.maximum_attack_speed   = self.ability:GetSpecialValueFor("maximum_attack_speed")
self.maximum_health_regen   = self.ability:GetSpecialValueFor("maximum_health_regen") 
self.hp_threshold_max       = self.ability:GetSpecialValueFor("hp_threshold_max")
self.range            = 100 - self.hp_threshold_max
end





function modifier_custom_huskar_berserkers_blood:OnIntervalThink()
if not IsServer() then return end

local thresh = self.hp_threshold_max + self.caster:GetTalentValue("modifier_huskar_passive_lowhp", "bonus")
local pct = math.max((self.parent:GetHealthPercent() - thresh) / (100 - thresh), 0)

self:SetStackCount(100 - pct*100)

if self:GetParent():GetHealthPercent() <= self.str_health and self:GetParent():HasModifier("modifier_huskar_passive_active") 
  and not self:GetParent():HasModifier("modifier_custom_huskar_berserkers_blood_str") and not self.caster:PassivesDisabled() then

  self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_huskar_berserkers_blood_str", {})
end

if self.caster:HasModifier("modifier_huskar_passive_lowhp") and not self.caster:PassivesDisabled() then 
  if self.caster:GetHealthPercent() <= self.status_health then 
    if not self.caster:HasModifier("modifier_custom_huskar_berserkers_blood_status") then 
      self.caster:AddNewModifier(self.caster, self:GetAbility(), "modifier_custom_huskar_berserkers_blood_status", {})
    end
  else 
    self.caster:RemoveModifierByName("modifier_custom_huskar_berserkers_blood_status")
  end 
end 


if self:GetParent():HasModifier("modifier_custom_huskar_berserkers_blood_str") then 
  self.PercentStr  =  self:GetParent():FindModifierByName("modifier_custom_huskar_berserkers_blood_str"):GetStackCount()*self.caster:GetTalentValue("modifier_huskar_passive_active", "str")/100
else 
  self.PercentStr = 0
end 

end






function modifier_custom_huskar_berserkers_blood:DeclareFunctions()
local funcs = {
  MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
  MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
  MODIFIER_PROPERTY_MODEL_SCALE,
  MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
  MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
  MODIFIER_EVENT_ON_TAKEDAMAGE,
  MODIFIER_EVENT_ON_ATTACK_LANDED,
  MODIFIER_PROPERTY_MIN_HEALTH,
}

return funcs
end

function modifier_custom_huskar_berserkers_blood:GetModifierMoveSpeedBonus_Constant()
if not self:GetCaster():HasModifier("modifier_huskar_passive_damage") then return end

local k = 1
if self:GetCaster():GetHealthPercent() <= self.speed_health then 
  k = self.speed_k
end 

return self:GetCaster():GetTalentValue("modifier_huskar_passive_damage", "speed")*k
end 



function modifier_custom_huskar_berserkers_blood:GetMinHealth()
if not self:GetParent():HasModifier("modifier_huskar_passive_armor") then return end
if self:GetParent():IsIllusion() then return end
if not self:GetParent():IsAlive() then return end
if self:GetParent():HasModifier("modifier_death") then return end


if self:GetParent():HasModifier("modifier_custom_huskar_berserkers_blood_grave") then 
  return 1
end

if self:GetParent():PassivesDisabled() then return end
if self:GetParent():HasModifier("modifier_custom_huskar_berserkers_blood_grave_cd") then return end

return 1
end

function modifier_custom_huskar_berserkers_blood:OnTakeDamage(params)
if not IsServer() then return end
if self:GetParent():PassivesDisabled() then return end

if self:GetParent():HasModifier("modifier_huskar_passive_regen") and self:GetParent() == params.attacker and params.inflictor == nil and not params.unit:IsIllusion() and 
  (params.unit:IsHero() or params.unit:IsCreep()) then 

  self:GetParent():GenericHeal(params.damage*self:GetParent():GetTalentValue("modifier_huskar_passive_regen", "lifesteal")/100, self:GetAbility(), true)  
end

if not self:GetParent():IsAlive() then return end
if not self:GetParent():HasModifier("modifier_huskar_passive_armor") then return end
if self:GetParent():GetHealth() > 1 then return end
if self:GetParent():HasModifier("modifier_custom_huskar_berserkers_blood_grave_cd") then return end
if self:GetParent():HasModifier("modifier_custom_huskar_berserkers_blood_grave") then return end

self:GetParent():EmitSound("Huskar.Passive_Legendary")

self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_huskar_berserkers_blood_grave", {duration = self.grave_duration})
self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_huskar_berserkers_blood_grave_cd", {duration = self.grave_cd})

end



function modifier_custom_huskar_berserkers_blood:OnAttackLanded(params)
if not IsServer() then return end 
if not self:GetParent():HasModifier("modifier_huskar_passive_damage") then return end
if self:GetParent():GetHealthPercent() > self.speed_health then return end
if self:GetParent() ~= params.attacker then return end 
if not params.target:IsHero() and not params.target:IsCreep() then return end 

params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_huskar_berserkers_blood_slow", {duration = self.speed_duration*(1 - params.target:GetStatusResistance())})
end 



function modifier_custom_huskar_berserkers_blood:GetModifierAttackSpeedBonus_Constant()
if self.parent:PassivesDisabled() then return end

local k = self.maximum_attack_speed + self:GetCaster():GetTalentValue("modifier_huskar_passive_speed", "speed")
return k * (self:GetStackCount()/100) * (self:GetStackCount()/100)
end


function modifier_custom_huskar_berserkers_blood:GetModifierConstantHealthRegen()
if self.parent:PassivesDisabled() then return end

local thresh = (self.hp_threshold_max + self.caster:GetTalentValue("modifier_huskar_passive_lowhp", "bonus"))
local pct = math.max((self.parent:GetHealthPercent() - thresh) / (100 - thresh), 0)

local k = self.maximum_health_regen + self:GetCaster():GetTalentValue("modifier_huskar_passive_regen", "regen")

return self:GetParent():GetStrength() * k  * 0.01 * (self:GetStackCount()/100) * (self:GetStackCount()/100)
end


function modifier_custom_huskar_berserkers_blood:GetModifierModelScale()
if not IsServer() then return end

local thresh = (self.hp_threshold_max + self.caster:GetTalentValue("modifier_huskar_passive_lowhp", "bonus"))
local pct = math.max((self.parent:GetHealthPercent() - thresh) / (100 - thresh), 0)

ParticleManager:SetParticleControl(self.particle, 1, Vector( (1 - pct) * 100, 0, 0))
self.parent:SetRenderColor(255, 255 * pct, 255 * pct)

return self.max_size * (self:GetStackCount()/100)
end


function modifier_custom_huskar_berserkers_blood:GetActivityTranslationModifiers()
return "berserkers_blood"
end







modifier_custom_huskar_berserkers_blood_status  = class({})
function modifier_custom_huskar_berserkers_blood_status:IsHidden() return true end
function modifier_custom_huskar_berserkers_blood_status:IsPurgable() return false end

function modifier_custom_huskar_berserkers_blood_status:GetEffectName() return "particles/huskar_lowhp.vpcf" end
function modifier_custom_huskar_berserkers_blood_status:OnCreated(table)

self.status = self:GetCaster():GetTalentValue("modifier_huskar_passive_lowhp", "status")

if not IsServer() then return end
self:GetParent():EmitSound("Huskar.Passive_LowHp")
end

function modifier_custom_huskar_berserkers_blood_status:DeclareFunctions()
  return
{
  MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
}

end

function modifier_custom_huskar_berserkers_blood_status:GetModifierStatusResistanceStacking() 
return self.status
end





----------------------------------------------------------------------------------------------------------------------------
modifier_custom_huskar_berserkers_blood_legendary_attack = class({})
function modifier_custom_huskar_berserkers_blood_legendary_attack:IsHidden() return false end
function modifier_custom_huskar_berserkers_blood_legendary_attack:IsPurgable() return false end
function modifier_custom_huskar_berserkers_blood_legendary_attack:GetTexture() return "buffs/berserker_active" end

function modifier_custom_huskar_berserkers_blood_legendary_attack:OnCreated(table)

self.bva = self:GetCaster():GetTalentValue('modifier_huskar_passive_legendary', "bva")
self.damage = self:GetCaster():GetTalentValue('modifier_huskar_passive_legendary', "damage")/100
self.cost = self:GetCaster():GetTalentValue('modifier_huskar_passive_legendary', "cost")/100
self.interval = self:GetCaster():GetTalentValue('modifier_huskar_passive_legendary', "interval")

if not IsServer() then return end

self.parent = self:GetParent()

self:OnIntervalThink()
self:StartIntervalThink(self.interval)

if self.effect_cast then 
  ParticleManager:DestroyParticle(self.effect_cast, false )
  ParticleManager:ReleaseParticleIndex( self.effect_cast ) 
end

self:GetCaster():EmitSound("Huskar.Passive_Active")
self.effect_cast = ParticleManager:CreateParticle( "particles/huskar_active.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
self:AddParticle(self.effect_cast, false, false, -1, false, false)
end



function modifier_custom_huskar_berserkers_blood_legendary_attack:OnIntervalThink()
if not IsServer() then return end
if self.parent:IsInvulnerable() then return end 
local damage = self:GetParent():GetMaxHealth()*self.cost*self.interval

ApplyDamage({attacker = self.parent, victim = self.parent, damage_type = DAMAGE_TYPE_PURE, ability = self:GetAbility(), damage = damage, damage_flags = DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS + DOTA_DAMAGE_FLAG_NON_LETHAL + DOTA_DAMAGE_FLAG_BYPASSES_BLOCK})
end


function modifier_custom_huskar_berserkers_blood_legendary_attack:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
  MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
  MODIFIER_PROPERTY_TOOLTIP,
}
end



function modifier_custom_huskar_berserkers_blood_legendary_attack:GetModifierBaseAttackTimeConstant()
return self.bva
end

function modifier_custom_huskar_berserkers_blood_legendary_attack:GetModifierPreAttack_BonusDamage(params)
return (self:GetParent():GetMaxHealth() - self:GetParent():GetHealth())*self.damage
end





modifier_custom_huskar_berserkers_blood_grave = class({})
function modifier_custom_huskar_berserkers_blood_grave:GetEffectName() return "particles/huskar_grave.vpcf" end
function modifier_custom_huskar_berserkers_blood_grave:IsHidden() return true end
function modifier_custom_huskar_berserkers_blood_grave:IsPurgable() return false end
function modifier_custom_huskar_berserkers_blood_grave:OnDestroy()
if not IsServer() then return end
if not self:GetParent():IsAlive() then return end

local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_oracle/oracle_false_promise_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
ParticleManager:ReleaseParticleIndex( particle )
self:GetParent():EmitSound("Huskar.Grave_end")

self:GetParent():GenericHeal(self:GetParent():GetMaxHealth()*self:GetCaster():GetTalentValue("modifier_huskar_passive_armor", "heal")/100, self:GetAbility())
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










modifier_custom_huskar_berserkers_blood_str = class({})
function modifier_custom_huskar_berserkers_blood_str:IsHidden() return false end
function modifier_custom_huskar_berserkers_blood_str:IsPurgable() return false end
function modifier_custom_huskar_berserkers_blood_str:GetTexture() return
"buffs/berserker_lowhp" end

function modifier_custom_huskar_berserkers_blood_str:OnCreated(table)

self.str = self:GetCaster():GetTalentValue("modifier_huskar_passive_active", "str")
self.armor = self:GetCaster():GetTalentValue("modifier_huskar_passive_active", "armor")
self.max = self:GetCaster():GetTalentValue("modifier_huskar_passive_active", "max")
self.health = self:GetCaster():GetTalentValue("modifier_huskar_passive_active", "health")

if not IsServer() then return end

self.particle = ParticleManager:CreateParticle("particles/huskar_str_stack.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
self:AddParticle(self.particle, false, false, -1, false, false)

self:SetStackCount(1)
self:StartIntervalThink(1)
end

function modifier_custom_huskar_berserkers_blood_str:OnIntervalThink()
if not IsServer() then return end

if self:GetParent():GetHealthPercent() <= self.health then 
  if self:GetStackCount() < self.max then 
    self:IncrementStackCount()
  end
else 
  self:DecrementStackCount()
  if self:GetStackCount() < 1 then 
    self:Destroy()
  end
end

local max = self.max
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
return self:GetStackCount()*self.str
end

function modifier_custom_huskar_berserkers_blood_str:GetModifierModelScale()
return self:GetStackCount()*3
end

function modifier_custom_huskar_berserkers_blood_str:GetModifierPhysicalArmorBonus()
return self:GetStackCount()*self.armor
end








modifier_custom_huskar_berserkers_blood_slow = class({})
function modifier_custom_huskar_berserkers_blood_slow:IsHidden() return true end
function modifier_custom_huskar_berserkers_blood_slow:IsPurgable() return true end
function modifier_custom_huskar_berserkers_blood_slow:OnCreated()

self.slow = self:GetCaster():GetTalentValue("modifier_huskar_passive_damage", "slow")

if not IsServer() then return end 
self:GetParent():EmitSound("DOTA_Item.Maim")
end




function modifier_custom_huskar_berserkers_blood_slow:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end

function modifier_custom_huskar_berserkers_blood_slow:GetModifierMoveSpeedBonus_Percentage()
return self.slow
end


function modifier_custom_huskar_berserkers_blood_slow:GetEffectName()
return "particles/items2_fx/sange_maim.vpcf"
end
