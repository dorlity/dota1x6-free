LinkLuaModifier("modifier_custom_huskar_burning_spear_counter", "abilities/huskar/custom_huskar_burning_spear", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_huskar_burning_spear_debuff", "abilities/huskar/custom_huskar_burning_spear", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_generic_orb_effect_lua", "abilities/generic/modifier_generic_orb_effect_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_custom_huskar_burning_spear_legendary", "abilities/huskar/custom_huskar_burning_spear", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_huskar_burning_spear_legendary_buff", "abilities/huskar/custom_huskar_burning_spear", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_huskar_burning_spear_target_mod", "abilities/huskar/custom_huskar_burning_spear", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_huskar_burning_spear_speed", "abilities/huskar/custom_huskar_burning_spear", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_huskar_burning_spear_reduction", "abilities/huskar/custom_huskar_burning_spear", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_huskar_burning_spear_fear_speed", "abilities/huskar/custom_huskar_burning_spear", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_huskar_burning_spear_fear_cd", "abilities/huskar/custom_huskar_burning_spear", LUA_MODIFIER_MOTION_NONE)

custom_huskar_burning_spear  = class({})




function custom_huskar_burning_spear:Precache(context)

PrecacheResource( "particle", "particles/units/heroes/hero_huskar/huskar_burning_spear.vpcf", context )
PrecacheResource( "particle", "particles/huskar_fast.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_ogre_magi/ogre_magi_fireblast.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_huskar/huskar_burning_spear_debuff.vpcf", context )
PrecacheResource( "particle", "particles/orange_heal.vpcf", context )
PrecacheResource( "particle", "particles/huskar_spears_legen.vpcf", context )
PrecacheResource( "particle", "particles/huskar_hands.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_phoenix/phoenix_icarus_dive_burn_debuff.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_terrorblade/ember_slow.vpcf", context )

end


function custom_huskar_burning_spear:GetAbilityTextureName()
if self:GetCaster():HasModifier("modifier_huskar_2021_weapon_golden_custom") then
    return "huskar/husk_2021_immortal_weapon_ability_icon/husk_2021_immortal_burning_spear_gold"
end
if self:GetCaster():HasModifier("modifier_huskar_2021_weapon_custom") then
    return "huskar/husk_2021_immortal_weapon_ability_icon/husk_2021_immortal_burning_spear"
end
return "huskar_burning_spear"
end

function custom_huskar_burning_spear:GetCastRange(vLocation, hTarget)
if self:GetCaster():HasModifier("modifier_huskar_spears_legendary") then return 0 end
return self:GetCaster():Script_GetAttackRange() + self:GetSpecialValueFor("bonus_range")
end


function custom_huskar_burning_spear:GetIntrinsicModifierName()
if not self:GetCaster():IsRealHero() then return end 
return "modifier_custom_huskar_burning_spear_legendary"
end



function custom_huskar_burning_spear:GetAbilityTargetFlags()
if self:GetCaster():HasModifier("modifier_huskar_spears_pure") then 
  return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
else 
  return DOTA_UNIT_TARGET_FLAG_NONE
end

end



function custom_huskar_burning_spear:GetBehavior()
if self:GetCaster():HasModifier("modifier_huskar_spears_legendary") then
  return DOTA_ABILITY_BEHAVIOR_NO_TARGET
end

return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_AUTOCAST + DOTA_ABILITY_BEHAVIOR_ATTACK 
end




function custom_huskar_burning_spear:GetProjectileName()
if not self:GetCaster():HasModifier("modifier_huskar_spears_legendary") then 
  return "particles/units/heroes/hero_huskar/huskar_burning_spear.vpcf"
end

end



function custom_huskar_burning_spear:GetHealthCost()
if IsServer() then return end
return self:GetSpecialValueFor("health_cost")*self:GetCaster():GetHealth()/100
end 





function custom_huskar_burning_spear:GetCooldown(iLevel)
if self:GetCaster():HasModifier("modifier_huskar_spears_legendary") then 
  return self:GetCaster():GetTalentValue("modifier_huskar_spears_legendary", "cd")
end  

end



function custom_huskar_burning_spear:OnAbilityPhaseStart()
if not IsServer() then return end
self:GetCaster():StartGesture(ACT_DOTA_CAST_ABILITY_1)
return true
end

function custom_huskar_burning_spear:OnAbilityPhaseInterrupted()
if not IsServer() then return end
self:GetCaster():FadeGesture(ACT_DOTA_CAST_ABILITY_1)
end


function custom_huskar_burning_spear:GetDamage()

return self:GetSpecialValueFor("burn_damage") + self:GetCaster():GetTalentValue("modifier_huskar_spears_damage", "damage")
end








function custom_huskar_burning_spear:OnSpellStart()
if not IsServer() then return end
if not self:GetCaster():HasModifier("modifier_huskar_spears_legendary") then return end

local effect = ParticleManager:CreateParticle("particles/huskar_fast.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
ParticleManager:SetParticleControlEnt(effect, 0, self:GetCaster(), PATTACH_ABSORIGIN, nil, self:GetCaster():GetOrigin(), true)
ParticleManager:SetParticleControlEnt(effect, 1, self:GetCaster(), PATTACH_ABSORIGIN, nil, self:GetCaster():GetOrigin(), true)
ParticleManager:ReleaseParticleIndex(effect)

self:GetCaster():EmitSound("Huskar.Spear_Cast")
 
local stun = self:GetCaster():GetTalentValue("modifier_huskar_spears_legendary", "stun")
local heal = self:GetCaster():GetTalentValue("modifier_huskar_spears_legendary", "heal")/100
local damage = self:GetCaster():GetTalentValue("modifier_huskar_spears_legendary", "damage")/100

local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self:GetCaster():GetTalentValue("modifier_huskar_spears_legendary", "radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)

for _,enemy in pairs(enemies) do 

  if enemy:HasModifier("modifier_custom_huskar_burning_spear_debuff") then 

      local total = 0
      for _,mod in pairs(enemy:FindAllModifiers()) do 
          if mod:GetName() == "modifier_custom_huskar_burning_spear_debuff" then
            total = total + self:GetDamage()*mod:GetRemainingTime()
            mod:Destroy()
          end
      end

      enemy:AddNewModifier(self:GetCaster(), self:GetCaster():BkbAbility(self, self:GetCaster():HasModifier("modifier_huskar_spears_pure")), "modifier_stunned", {duration = stun})

      local real_damage = ApplyDamage({victim = enemy,attacker = self:GetCaster(),ability = self,damage = total*damage, damage_type = DAMAGE_TYPE_MAGICAL,ability = self })

      self:AoeDamage(enemy, total*damage)

      enemy:SendNumber(6, real_damage)
      self:GetCaster():GenericHeal(real_damage*heal, self)

      local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_ogre_magi/ogre_magi_fireblast.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy)
      ParticleManager:SetParticleControlEnt( particle, 0, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true )
      ParticleManager:SetParticleControl( particle, 1, enemy:GetOrigin() )
      ParticleManager:ReleaseParticleIndex( particle )
      enemy:EmitSound("Hero_OgreMagi.Fireblast.Target")
  end
end  


end



function custom_huskar_burning_spear:AddStack(target, double)
if not IsServer() then return end
if target:IsBuilding() or target:IsCourier()  then return end

local duration = self:GetSpecialValueFor("duration") + self:GetCaster():GetTalentValue("modifier_huskar_spears_aoe", "duration")

target:EmitSound("Hero_Huskar.Burning_Spear")
target:AddNewModifier(self:GetCaster(), self, "modifier_custom_huskar_burning_spear_debuff", { duration = duration })
target:AddNewModifier(self:GetCaster(), self, "modifier_custom_huskar_burning_spear_counter", { duration = duration })

if self:GetCaster():HasModifier("modifier_huskar_spears_legendary") then 
  self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_custom_huskar_burning_spear_target_mod", {duration = duration, target = target:entindex()})
end 

if self:GetCaster():HasModifier("modifier_huskar_spears_armor") then 
  target:AddNewModifier(self:GetCaster(), self, "modifier_custom_huskar_burning_spear_reduction", {duration = self:GetCaster():GetTalentValue("modifier_huskar_spears_armor", "duration")})
end 

if self:GetCaster():HasModifier("modifier_huskar_spears_tick") then 

  if not double then 
    if RollPseudoRandomPercentage(self:GetCaster():GetTalentValue("modifier_huskar_spears_tick", "chance") ,2937,self:GetCaster()) then 
      target:EmitSound("Huskar.Spear_double")

      local hit_effect = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_quad_tap_hit.vpcf", PATTACH_CUSTOMORIGIN, target)
      ParticleManager:SetParticleControlEnt(hit_effect, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), false) 
      ParticleManager:SetParticleControlEnt(hit_effect, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), false) 
      ParticleManager:ReleaseParticleIndex(hit_effect)

      self:AddStack(target, true)
    end
  end

  self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_custom_huskar_burning_spear_speed", {duration = self:GetCaster():GetTalentValue("modifier_huskar_spears_tick", "duration")})
end 

end


function custom_huskar_burning_spear:AoeDamage(target, init_damage)
if not self:GetCaster():HasModifier("modifier_huskar_spears_damage") then return end 

local damage = init_damage*self:GetCaster():GetTalentValue("modifier_huskar_spears_damage", "aoe")/100
for _,unit in pairs(self:GetCaster():FindTargets(self:GetCaster():GetTalentValue("modifier_huskar_spears_damage", "radius"), target:GetAbsOrigin())) do 
  if unit ~= target then 
    ApplyDamage({victim = unit, attacker = self:GetCaster(), damage = damage, ability = self, damage_type = DAMAGE_TYPE_MAGICAL})
  end 
end 

end 


function custom_huskar_burning_spear:MakeSpear(caster)
if not IsServer() then return end

caster:EmitSound("Hero_Huskar.Burning_Spear.Cast")

if self:GetCaster():HasModifier("modifier_huskar_spears_blast") then 
  if RollPseudoRandomPercentage(self:GetCaster():GetTalentValue("modifier_huskar_spears_blast", "chance"),4937,self:GetCaster()) then 
    self:GetCaster():EmitSound("Huskar.Spear_Heal")

    local heal = (self:GetCaster():GetMaxHealth() - self:GetCaster():GetHealth())*self:GetCaster():GetTalentValue("modifier_huskar_spears_blast", "heal")/100
    self:GetCaster():GenericHeal(heal, self, false, "particles/orange_heal.vpcf")
    return
  end 
end 


local health_cost = (caster:GetHealth() * self:GetSpecialValueFor("health_cost") * 0.01)
caster:SetHealth(math.max(caster:GetHealth() - health_cost, 1))
end


function custom_huskar_burning_spear:OnOrbFire()
if self:GetCaster():IsSilenced() then return end
self:MakeSpear(self:GetCaster())
end



function custom_huskar_burning_spear:OnOrbImpact( keys )
self:AddStack(keys.target)
end




modifier_custom_huskar_burning_spear_counter = class({})

function modifier_custom_huskar_burning_spear_counter:IsPurgable()    return false end


function modifier_custom_huskar_burning_spear_counter:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
}
end


function modifier_custom_huskar_burning_spear_counter:GetModifierMoveSpeedBonus_Percentage()
if not self:GetCaster():HasModifier("modifier_huskar_spears_aoe") then return end
return self:GetStackCount()*self.slow
end


function modifier_custom_huskar_burning_spear_counter:OnCreated()

self.slow = self:GetCaster():GetTalentValue("modifier_huskar_spears_aoe", "slow")

if not IsServer() then return end
self.RemoveForDuel = true

local particle_name = "particles/units/heroes/hero_huskar/huskar_burning_spear_debuff.vpcf"
if self:GetCaster():HasModifier("modifier_huskar_2021_weapon_golden_custom") then
    particle_name = "particles/econ/items/huskar/huskar_2021_immortal/huskar_2021_immortal_burning_spear_debuff_gold.vpcf"
elseif self:GetCaster():HasModifier("modifier_huskar_2021_weapon_custom") then
    particle_name = "particles/econ/items/huskar/huskar_2021_immortal/huskar_2021_immortal_burning_spear_debuff.vpcf"
end

local particle_debuff = ParticleManager:CreateParticle(particle_name, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
self:AddParticle(particle_debuff, false, false, -1, false, false)

self.damage = self:GetAbility():GetDamage()
self.damageTable = {victim = self:GetParent(), attacker = self:GetCaster(), ability = self:GetAbility(), damage_type = DAMAGE_TYPE_MAGICAL}

self:IncrementStackCount()
self:StartIntervalThink(1)
end



function modifier_custom_huskar_burning_spear_counter:OnRefresh()
if not IsServer() then return end
self:IncrementStackCount()

end

function modifier_custom_huskar_burning_spear_counter:OnIntervalThink()
if not IsServer() then return end 

self.damageTable.damage = self.damage*self:GetStackCount()
ApplyDamage(self.damageTable)

self:GetAbility():AoeDamage(self:GetParent(), self.damage*self:GetStackCount())
end



function modifier_custom_huskar_burning_spear_counter:OnDestroy()
if not IsServer() then return end

self:GetParent():StopSound("Hero_Huskar.Burning_Spear")
end



modifier_custom_huskar_burning_spear_debuff  = class({})

function modifier_custom_huskar_burning_spear_debuff:IgnoreTenacity() return true end
function modifier_custom_huskar_burning_spear_debuff:IsHidden()     return true end
function modifier_custom_huskar_burning_spear_debuff:IsPurgable()   return false end
function modifier_custom_huskar_burning_spear_debuff:GetAttributes()  return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_custom_huskar_burning_spear_debuff:OnCreated(table)
self.RemoveForDuel = true

end



function modifier_custom_huskar_burning_spear_debuff:OnDestroy()
if not IsServer() then return end

local burning_spear_counter = self:GetParent():FindModifierByNameAndCaster("modifier_custom_huskar_burning_spear_counter", self:GetCaster())

if burning_spear_counter then
  burning_spear_counter:DecrementStackCount()

  if burning_spear_counter:GetStackCount() == 0 then 
     burning_spear_counter:Destroy()
  end
end

end









modifier_custom_huskar_burning_spear_legendary    = class({})
function modifier_custom_huskar_burning_spear_legendary:IsHidden() return true end
function modifier_custom_huskar_burning_spear_legendary:IsPurgable() return false end
function modifier_custom_huskar_burning_spear_legendary:RemoveOnDeath() return false
end


function modifier_custom_huskar_burning_spear_legendary:DeclareFunctions()
return
{
  MODIFIER_EVENT_ON_ATTACK_LANDED,
  MODIFIER_EVENT_ON_ATTACK_START,
  MODIFIER_EVENT_ON_ATTACK,
  MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
}

end


function modifier_custom_huskar_burning_spear_legendary:OnCreated()
self.caster = self:GetCaster()

self.range = self:GetCaster():GetTalentValue("modifier_huskar_spears_legendary", "attack_range", true)
self.damage = self:GetCaster():GetTalentValue("modifier_huskar_spears_legendary", "damage", true)/100

self.slow_range = self:GetCaster():GetTalentValue("modifier_huskar_spears_aoe", "range", true)

self.fear_cd = self:GetCaster():GetTalentValue("modifier_huskar_spears_pure", "cd", true)
self.fear_duration = self:GetCaster():GetTalentValue("modifier_huskar_spears_pure", "fear", true)
self.fear_max = self:GetCaster():GetTalentValue("modifier_huskar_spears_pure", "max", true)

if not IsServer() then return end 

self:StartIntervalThink(0.2)
end


function modifier_custom_huskar_burning_spear_legendary:OnIntervalThink()
if not IsServer() then return end 

if self.caster:HasModifier("modifier_huskar_spears_legendary") and self.caster:HasModifier("modifier_generic_orb_effect_lua") then 
  self.caster:RemoveModifierByName("modifier_generic_orb_effect_lua")
end 

if not self.caster:HasModifier("modifier_huskar_spears_legendary") and not self.caster:HasModifier("modifier_generic_orb_effect_lua") then 
  self.caster:AddNewModifier(self.caster, self:GetAbility(), "modifier_generic_orb_effect_lua", {})
end 

if self.caster:HasModifier("modifier_huskar_spears_legendary") then

  local target_mod = self.caster:FindModifierByName("modifier_custom_huskar_burning_spear_target_mod")
  local total = 0

  if target_mod and target_mod.target and not target_mod.target:IsNull() and target_mod.target:HasModifier("modifier_custom_huskar_burning_spear_debuff") then 

      for _,mod in pairs(target_mod.target:FindAllModifiers()) do 
          if mod:GetName() == "modifier_custom_huskar_burning_spear_debuff" then
            total = total + self:GetAbility():GetDamage()*mod:GetRemainingTime()
          end
      end
      total = (total*(1 + self.caster:GetSpellAmplification(false))*self.damage)*(1 - target_mod.target:Script_GetMagicalArmorValue(false, nil))
  end 

  CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self.caster:GetPlayerOwnerID()), "huskar_spears_change",  {damage = math.floor(total) })
end 


end 



function modifier_custom_huskar_burning_spear_legendary:GetModifierAttackRangeBonus()
local bonus = 0
if self.caster:HasModifier("modifier_huskar_spears_legendary") then 
  bonus = self.range
end 

if self.caster:HasModifier("modifier_huskar_spears_aoe") then 
  bonus = bonus + self.slow_range
end
return bonus
end

function modifier_custom_huskar_burning_spear_legendary:OnAttackStart(params)
if not IsServer() then return end
if not self.caster:HasModifier("modifier_huskar_spears_legendary") then return end
if self:GetParent() ~= params.attacker then return end

if not params.target:IsHero() and not params.target:IsCreep() then 
  self:GetParent():SetRangedProjectileName("particles/units/heroes/hero_huskar/huskar_base_attack.vpcf")
  return 
end 

self:GetParent():SetRangedProjectileName("particles/units/heroes/hero_huskar/huskar_burning_spear.vpcf")
end




function modifier_custom_huskar_burning_spear_legendary:OnAttack(params)
if not IsServer() then return end
if not self.caster:HasModifier("modifier_huskar_spears_legendary") then return end
if self:GetParent() ~= params.attacker then return end
if not params.target:IsHero() and not params.target:IsCreep() then return end

self:GetAbility():MakeSpear(self:GetParent())
end


function modifier_custom_huskar_burning_spear_legendary:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end
if not params.target:IsHero() and not params.target:IsCreep() then return end

if self.caster:HasModifier("modifier_huskar_spears_legendary") then 
  self:GetAbility():AddStack(params.target )
end

if not self:GetCaster():HasModifier("modifier_huskar_spears_pure") then return end

local mod = params.target:FindModifierByName("modifier_custom_huskar_burning_spear_counter")

if mod and mod:GetStackCount() >= self.fear_max and not params.target:HasModifier("modifier_custom_huskar_burning_spear_fear_cd") then 

  params.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_huskar_burning_spear_fear_cd", {duration = self.fear_cd})
  params.target:EmitSound("BS.Rupture_fear")
  params.target:AddNewModifier(self:GetCaster(), self:GetCaster():BkbAbility(self:GetAbility(), true), "modifier_nevermore_requiem_fear", {duration  = self.fear_duration * (1 - params.target:GetStatusResistance())})
  params.target:AddNewModifier(self:GetCaster(), self:GetCaster():BkbAbility(self:GetAbility(), true), "modifier_custom_huskar_burning_spear_fear_speed", {duration  = self.fear_duration * (1 - params.target:GetStatusResistance())})

end

end




modifier_custom_huskar_burning_spear_legendary_buff = class({})
function modifier_custom_huskar_burning_spear_legendary_buff:IsHidden() return false end
function modifier_custom_huskar_burning_spear_legendary_buff:IsPurgable() return false end
function modifier_custom_huskar_burning_spear_legendary_buff:GetEffectName() return "particles/huskar_spears_legen.vpcf" end

function modifier_custom_huskar_burning_spear_legendary_buff:OnCreated(table)
if not IsServer() then return end
  self.RemoveForDuel = true
  self.hands = ParticleManager:CreateParticle("particles/huskar_hands.vpcf",PATTACH_ABSORIGIN_FOLLOW,self:GetParent())
  ParticleManager:SetParticleControlEnt(self.hands,0,self:GetParent(),PATTACH_ABSORIGIN_FOLLOW,"follow_origin",self:GetParent():GetOrigin(),false)
  self:AddParticle(self.hands,true,false,0,false,false)
end












modifier_custom_huskar_burning_spear_target_mod = class({})
function modifier_custom_huskar_burning_spear_target_mod:IsHidden() return true end
function modifier_custom_huskar_burning_spear_target_mod:IsPurgable() return false end
function modifier_custom_huskar_burning_spear_target_mod:OnCreated(params)
if not IsServer() then return end 

self.target = EntIndexToHScript(params.target)
end 

function modifier_custom_huskar_burning_spear_target_mod:OnRefresh(params)
if not IsServer() then return end 

self.target = EntIndexToHScript(params.target)
end 





modifier_custom_huskar_burning_spear_speed = class({})
function modifier_custom_huskar_burning_spear_speed:IsHidden() return false end
function modifier_custom_huskar_burning_spear_speed:IsPurgable() return false end
function modifier_custom_huskar_burning_spear_speed:GetTexture() return "buffs/spears_tick" end
function modifier_custom_huskar_burning_spear_speed:OnCreated()

self.speed = self:GetCaster():GetTalentValue("modifier_huskar_spears_tick", "speed")
self.max = self:GetCaster():GetTalentValue("modifier_huskar_spears_tick", "max")
self:SetStackCount(1)
end 

function modifier_custom_huskar_burning_spear_speed:OnRefresh()
if not IsServer() then return end 
if self:GetStackCount() >= self.max then return end 

self:IncrementStackCount()
end

function modifier_custom_huskar_burning_spear_speed:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
end

function modifier_custom_huskar_burning_spear_speed:GetModifierAttackSpeedBonus_Constant()
return self.speed*self:GetStackCount()
end



modifier_custom_huskar_burning_spear_reduction = class({})

function modifier_custom_huskar_burning_spear_reduction:IsPurgable() return false end
function modifier_custom_huskar_burning_spear_reduction:IsHidden() return false end
function modifier_custom_huskar_burning_spear_reduction:GetTexture() return "buffs/dragon_burn" end


function modifier_custom_huskar_burning_spear_reduction:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
  MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
  MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
  MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
  MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE
}

end

function modifier_custom_huskar_burning_spear_reduction:GetModifierDamageOutgoing_Percentage()
return self:GetStackCount()*self.damage_reduce
end

function modifier_custom_huskar_burning_spear_reduction:GetModifierSpellAmplify_Percentage()
return self:GetStackCount()*self.damage_reduce
end

function modifier_custom_huskar_burning_spear_reduction:GetModifierLifestealRegenAmplify_Percentage()
return self:GetStackCount()*self.heal_reduce
end

function modifier_custom_huskar_burning_spear_reduction:GetModifierHealAmplify_PercentageTarget() 
return self:GetStackCount()*self.heal_reduce
end

function modifier_custom_huskar_burning_spear_reduction:GetModifierHPRegenAmplify_Percentage() 
return self:GetStackCount()*self.heal_reduce
end

function modifier_custom_huskar_burning_spear_reduction:OnCreated()

self.damage_reduce = self:GetCaster():GetTalentValue("modifier_huskar_spears_armor", "damage_reduce")
self.heal_reduce = self:GetCaster():GetTalentValue("modifier_huskar_spears_armor", "heal_reduce")
self.max = self:GetCaster():GetTalentValue("modifier_huskar_spears_armor", "max")
self:SetStackCount(1)
end


function modifier_custom_huskar_burning_spear_reduction:OnRefresh()
if not IsServer() then return end 
if self:GetStackCount() >= self.max then return end 

self:IncrementStackCount()
end





modifier_custom_huskar_burning_spear_fear_speed = class({})
function modifier_custom_huskar_burning_spear_fear_speed:IsHidden() return true end
function modifier_custom_huskar_burning_spear_fear_speed:IsPurgable() return false end
function modifier_custom_huskar_burning_spear_fear_speed:OnCreated()
self.speed = self:GetCaster():GetTalentValue("modifier_huskar_spears_pure", "speed")
end

function modifier_custom_huskar_burning_spear_fear_speed:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MAX,
}
end

function modifier_custom_huskar_burning_spear_fear_speed:GetModifierMoveSpeed_AbsoluteMax()
return self.speed
end

modifier_custom_huskar_burning_spear_fear_cd = class({})
function modifier_custom_huskar_burning_spear_fear_cd:IsHidden() return true end
function modifier_custom_huskar_burning_spear_fear_cd:IsPurgable() return false end
function modifier_custom_huskar_burning_spear_fear_cd:RemoveOnDeath() return false end
function modifier_custom_huskar_burning_spear_fear_cd:OnCreated()

self.RemoveForDuel = true
end