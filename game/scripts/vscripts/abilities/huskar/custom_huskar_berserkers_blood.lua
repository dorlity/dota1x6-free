LinkLuaModifier("modifier_custom_huskar_berserkers_blood", "abilities/huskar/custom_huskar_berserkers_blood", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_huskar_berserkers_blood_status", "abilities/huskar/custom_huskar_berserkers_blood", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_huskar_berserkers_blood_legendary_attack", "abilities/huskar/custom_huskar_berserkers_blood", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_huskar_berserkers_blood_grave", "abilities/huskar/custom_huskar_berserkers_blood", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_huskar_berserkers_blood_grave_cd", "abilities/huskar/custom_huskar_berserkers_blood", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_huskar_berserkers_blood_str", "abilities/huskar/custom_huskar_berserkers_blood", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_huskar_berserkers_blood_slow", "abilities/huskar/custom_huskar_berserkers_blood", LUA_MODIFIER_MOTION_NONE)

custom_huskar_berserkers_blood  = class({})

function custom_huskar_berserkers_blood:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end

PrecacheResource( "particle", "particles/units/heroes/hero_huskar/huskar_berserkers_blood.vpcf", context )
PrecacheResource( "particle", "particles/huskar_lowhp.vpcf", context )
PrecacheResource( "particle", "particles/huskar_active.vpcf", context )
PrecacheResource( "particle", "particles/huskar_grave.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_oracle/oracle_false_promise_heal.vpcf", context )
PrecacheResource( "particle", "particles/huskar_str_stack.vpcf", context )
PrecacheResource( "particle", "particles/items2_fx/sange_maim.vpcf", context )

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
if self:GetCaster():HasTalent("modifier_huskar_passive_7") then
  return DOTA_ABILITY_BEHAVIOR_TOGGLE + DOTA_ABILITY_BEHAVIOR_IMMEDIATE 
end

return DOTA_ABILITY_BEHAVIOR_PASSIVE 
end



function custom_huskar_berserkers_blood:GetCooldown(iLevel)

if self:GetCaster():HasTalent("modifier_huskar_passive_7") then 
 return self:GetCaster():GetTalentValue("modifier_huskar_passive_7", "cd")
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
  CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetCaster():GetPlayerOwnerID()), "generic_sound",  {sound = "huskar_husk_ability_brskrblood_0"..math.random(3,4)})
   
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

if self.parent:IsRealHero() then
  self.parent:AddDamageEvent_inc(self)
  self.parent:AddDamageEvent_out(self)
end

self.maximum_attack_speed   = self.ability:GetSpecialValueFor("maximum_attack_speed")
self.maximum_health_regen   = self.ability:GetSpecialValueFor("maximum_health_regen")
self.hp_threshold_max       = self.ability:GetSpecialValueFor("hp_threshold_max")
self.maximum_resistance     = self.ability:GetSpecialValueFor("maximum_resistance")

self.range          = 100 - self.hp_threshold_max
self.max_size = 35
self.str = 0

self.speed_k = self.parent:GetTalentValue("modifier_huskar_passive_3", "bonus", true)
self.speed_health = self.parent:GetTalentValue("modifier_huskar_passive_3", "health", true)
self.speed_duration = self.parent:GetTalentValue("modifier_huskar_passive_3", "duration", true)

self.str_health = self.parent:GetTalentValue("modifier_huskar_passive_4", "health", true)

self.status_health = self.parent:GetTalentValue("modifier_huskar_passive_5", "health", true)

self.grave_cd = self.parent:GetTalentValue("modifier_huskar_passive_6", "cd", true)
self.grave_duration = self.parent:GetTalentValue("modifier_huskar_passive_6", "duration", true)

if not IsServer() then return end

local particle_name = "particles/units/heroes/hero_huskar/huskar_berserkers_blood.vpcf"
if self.parent:HasModifier("modifier_huskar_shoulder_immortal") then
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


local thresh = self.hp_threshold_max + self.caster:GetTalentValue("modifier_huskar_passive_5", "bonus")
local pct = math.max((self.parent:GetHealthPercent() - thresh) / (100 - thresh), 0)

self:SetStackCount(100 - pct*100)

if self.parent:GetHealthPercent() <= self.str_health and self.parent:HasTalent("modifier_huskar_passive_4") 
  and not self.parent:HasModifier("modifier_custom_huskar_berserkers_blood_str") and not self.caster:PassivesDisabled() then

  self.parent:AddNewModifier(self.parent, self.ability, "modifier_custom_huskar_berserkers_blood_str", {})
end

if self.caster:HasTalent("modifier_huskar_passive_5") and not self.caster:PassivesDisabled() then 
  if self.caster:GetHealthPercent() <= self.status_health then 
    if not self.caster:HasModifier("modifier_custom_huskar_berserkers_blood_status") then 
      self.caster:AddNewModifier(self.caster, self.ability, "modifier_custom_huskar_berserkers_blood_status", {})
    end
  else 
    self.caster:RemoveModifierByName("modifier_custom_huskar_berserkers_blood_status")
  end 
end 


if self.parent:HasModifier("modifier_custom_huskar_berserkers_blood_str") then 
  self.PercentStr  =  self.parent:FindModifierByName("modifier_custom_huskar_berserkers_blood_str"):GetStackCount()*self.caster:GetTalentValue("modifier_huskar_passive_4", "str")/100
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
  MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
  MODIFIER_PROPERTY_MIN_HEALTH,
}

return funcs
end

function modifier_custom_huskar_berserkers_blood:GetModifierMoveSpeedBonus_Constant()
if not self.parent:HasTalent("modifier_huskar_passive_3") then return end

local k = 1
if self.parent:GetHealthPercent() <= self.speed_health then 
  k = self.speed_k
end 

return self.parent:GetTalentValue("modifier_huskar_passive_3", "speed")*k
end 



function modifier_custom_huskar_berserkers_blood:GetMinHealth()
if not self.parent:HasTalent("modifier_huskar_passive_6") then return end
if self.parent:IsIllusion() then return end
if not self.parent:IsAlive() then return end
if self.parent:LethalDisabled() then return end


if self.parent:HasModifier("modifier_custom_huskar_berserkers_blood_grave") then 
  return 1
end

if self.parent:PassivesDisabled() then return end
if self.parent:HasModifier("modifier_custom_huskar_berserkers_blood_grave_cd") then return end

return 1
end

function modifier_custom_huskar_berserkers_blood:DamageEvent_out(params)
if not IsServer() then return end
if self.parent:PassivesDisabled() then return end

if self.parent:HasTalent("modifier_huskar_passive_1") and self.parent == params.attacker and params.inflictor == nil and not params.unit:IsIllusion() and params.unit:IsUnit() then 
  self.parent:GenericHeal(params.damage*self.parent:GetTalentValue("modifier_huskar_passive_1", "lifesteal")/100, self.ability, true, nil, "modifier_huskar_passive_1")  
end

end

function modifier_custom_huskar_berserkers_blood:DamageEvent_inc(params)
if not IsServer() then return end
if self.parent:PassivesDisabled() then return end

if not self.parent:IsAlive() then return end
if self.parent == params.attacker then return end
if self.parent ~= params.unit then return end
if params.damage <= 0 then return end
if not self.parent:HasTalent("modifier_huskar_passive_6") then return end
if self.parent:GetHealth() > 1 then return end
if self.parent:HasModifier("modifier_custom_huskar_berserkers_blood_grave_cd") then return end
if self.parent:HasModifier("modifier_custom_huskar_berserkers_blood_grave") then return end

self.parent:EmitSound("Huskar.Passive_Legendary")

self.parent:AddNewModifier(self.parent, self.ability, "modifier_custom_huskar_berserkers_blood_grave", {duration = self.grave_duration})
self.parent:AddNewModifier(self.parent, self.ability, "modifier_custom_huskar_berserkers_blood_grave_cd", {duration = self.grave_cd})

end



function modifier_custom_huskar_berserkers_blood:GetModifierProcAttack_Feedback(params)
if not IsServer() then return end 
if not self.parent:HasTalent("modifier_huskar_passive_3") then return end
if self.parent:GetHealthPercent() > self.speed_health then return end
if self.parent ~= params.attacker then return end 
if not params.target:IsUnit() then return end 

params.target:AddNewModifier(self.parent, self.ability, "modifier_custom_huskar_berserkers_blood_slow", {duration = self.speed_duration*(1 - params.target:GetStatusResistance())})
end 



function modifier_custom_huskar_berserkers_blood:GetModifierAttackSpeedBonus_Constant()
if self.parent:PassivesDisabled() then return end

local k = self.maximum_attack_speed + self.parent:GetTalentValue("modifier_huskar_passive_2", "speed")
return k * (self:GetStackCount()/100) * (self:GetStackCount()/100)
end


function modifier_custom_huskar_berserkers_blood:GetModifierConstantHealthRegen()
if self.parent:PassivesDisabled() then return end

local thresh = (self.hp_threshold_max + self.caster:GetTalentValue("modifier_huskar_passive_5", "bonus"))
local pct = math.max((self.parent:GetHealthPercent() - thresh) / (100 - thresh), 0)

local k = self.maximum_health_regen + self.parent:GetTalentValue("modifier_huskar_passive_1", "regen")

return self.parent:GetStrength() * k  * 0.01 * (self:GetStackCount()/100) * (self:GetStackCount()/100)
end


function modifier_custom_huskar_berserkers_blood:GetModifierModelScale()
if not IsServer() then return end

local thresh = (self.hp_threshold_max + self.caster:GetTalentValue("modifier_huskar_passive_5", "bonus"))
local pct = math.max((self.parent:GetHealthPercent() - thresh) / (100 - thresh), 0)

ParticleManager:SetParticleControl(self.particle, 1, Vector( (1 - pct) * 100, 0, 0))
self.parent:SetRenderColor(255, 255 * pct, 255 * pct)

return self.max_size * (self:GetStackCount()/100)
end


function modifier_custom_huskar_berserkers_blood:GetActivityTranslationModifiers()
return "berserkers_blood"
end



function modifier_custom_huskar_berserkers_blood:OnDestroy()
if not IsServer() then return end
self.parent:SetRenderColor(255, 255, 255)
end




modifier_custom_huskar_berserkers_blood_status  = class({})
function modifier_custom_huskar_berserkers_blood_status:IsHidden() return true end
function modifier_custom_huskar_berserkers_blood_status:IsPurgable() return false end

function modifier_custom_huskar_berserkers_blood_status:GetEffectName() return "particles/huskar_lowhp.vpcf" end
function modifier_custom_huskar_berserkers_blood_status:OnCreated(table)

self.status = self:GetCaster():GetTalentValue("modifier_huskar_passive_5", "status")

if not IsServer() then return end
self:StartIntervalThink(0.5)
end


function modifier_custom_huskar_berserkers_blood_status:OnIntervalThink()
if not IsServer() then return end
self:GetParent():EmitSound("Huskar.Passive_LowHp")
self:StartIntervalThink(-1)
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

self.bva = self:GetCaster():GetTalentValue("modifier_huskar_passive_7", "bva")
self.damage = self:GetCaster():GetTalentValue("modifier_huskar_passive_7", "damage")/100
self.cost = self:GetCaster():GetTalentValue("modifier_huskar_passive_7", "cost")/100
self.interval = self:GetCaster():GetTalentValue("modifier_huskar_passive_7", "interval")

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

DoDamage({attacker = self.parent, victim = self.parent, damage_type = DAMAGE_TYPE_PURE, ability = self:GetAbility(), damage = damage, damage_flags = DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS + DOTA_DAMAGE_FLAG_NON_LETHAL + DOTA_DAMAGE_FLAG_BYPASSES_PHYSICAL_BLOCK})
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

self:GetParent():GenericHeal(self:GetParent():GetMaxHealth()*self:GetCaster():GetTalentValue("modifier_huskar_passive_6", "heal")/100, self:GetAbility(), nil, nil, "modifier_huskar_passive_6")
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

self.str = self:GetCaster():GetTalentValue("modifier_huskar_passive_4", "str")
self.armor = self:GetCaster():GetTalentValue("modifier_huskar_passive_4", "armor")
self.max = self:GetCaster():GetTalentValue("modifier_huskar_passive_4", "max")
self.health = self:GetCaster():GetTalentValue("modifier_huskar_passive_4", "health")

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

self.slow = self:GetCaster():GetTalentValue("modifier_huskar_passive_3", "slow")

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
