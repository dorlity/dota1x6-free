LinkLuaModifier("modifier_custom_huskar_burning_spear_counter", "abilities/huskar/custom_huskar_burning_spear", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_huskar_burning_spear_debuff", "abilities/huskar/custom_huskar_burning_spear", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_huskar_burning_spear_legendary", "abilities/huskar/custom_huskar_burning_spear", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_huskar_burning_spear_legendary_buff", "abilities/huskar/custom_huskar_burning_spear", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_huskar_burning_spear_target_mod", "abilities/huskar/custom_huskar_burning_spear", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_huskar_burning_spear_speed", "abilities/huskar/custom_huskar_burning_spear", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_huskar_burning_spear_reduction", "abilities/huskar/custom_huskar_burning_spear", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_huskar_burning_spear_fear_speed", "abilities/huskar/custom_huskar_burning_spear", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_huskar_burning_spear_fear_cd", "abilities/huskar/custom_huskar_burning_spear", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_huskar_burning_spear_attack", "abilities/huskar/custom_huskar_burning_spear", LUA_MODIFIER_MOTION_NONE)

custom_huskar_burning_spear  = class({})


function custom_huskar_burning_spear:CreateTalent()
if self:GetAutoCastState() then 
  self:ToggleAutoCast()
end 
self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_custom_huskar_burning_spear_legendary", {}) 
end


function custom_huskar_burning_spear:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end
PrecacheResource( "particle", "particles/units/heroes/hero_huskar/huskar_burning_spear.vpcf", context )
PrecacheResource( "particle", "particles/huskar_fast.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_ogre_magi/ogre_magi_fireblast.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_monkey_king/monkey_king_quad_tap_hit.vpcf", context )
PrecacheResource( "particle", "particles/orange_heal.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_huskar/huskar_burning_spear_debuff.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_huskar/huskar_base_attack.vpcf", context )
PrecacheResource( "particle", "particles/huskar_spears_legen.vpcf", context )
PrecacheResource( "particle", "particles/huskar_hands.vpcf", context )
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
if self:GetCaster():HasTalent("modifier_huskar_spears_7") then return 0 end
return self:GetCaster():Script_GetAttackRange() + self:GetSpecialValueFor("bonus_range")
end


function custom_huskar_burning_spear:GetIntrinsicModifierName()
if not self:GetCaster():IsRealHero() then return end 
return "modifier_custom_huskar_burning_spear_legendary"
end


function custom_huskar_burning_spear:GetAbilityTargetFlags()
if self:GetCaster():HasTalent("modifier_huskar_spears_6") then 
  return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
else 
  return DOTA_UNIT_TARGET_FLAG_NONE
end

end


function custom_huskar_burning_spear:GetBehavior()
if self:GetCaster():HasTalent("modifier_huskar_spears_7") then
  return DOTA_ABILITY_BEHAVIOR_NO_TARGET
end
return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_AUTOCAST + DOTA_ABILITY_BEHAVIOR_ATTACK 
end


function custom_huskar_burning_spear:GetHealthCost()
if IsServer() then return end
return self:GetSpecialValueFor("health_cost")*self:GetCaster():GetHealth()/100
end 


function custom_huskar_burning_spear:GetCooldown(iLevel)
if self:GetCaster():HasTalent("modifier_huskar_spears_7") then 
  return self:GetCaster():GetTalentValue("modifier_huskar_spears_7", "cd")
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
return self:GetSpecialValueFor("burn_damage") + self:GetCaster():GetTalentValue("modifier_huskar_spears_1", "damage")
end





function custom_huskar_burning_spear:OnSpellStart()
if not IsServer() then return end
if not self:GetCaster():HasTalent("modifier_huskar_spears_7") then return end

local effect = ParticleManager:CreateParticle("particles/huskar_fast.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
ParticleManager:SetParticleControlEnt(effect, 0, self:GetCaster(), PATTACH_ABSORIGIN, nil, self:GetCaster():GetOrigin(), true)
ParticleManager:SetParticleControlEnt(effect, 1, self:GetCaster(), PATTACH_ABSORIGIN, nil, self:GetCaster():GetOrigin(), true)
ParticleManager:ReleaseParticleIndex(effect)

self:GetCaster():EmitSound("Huskar.Spear_Cast")
 
local stun = self:GetCaster():GetTalentValue("modifier_huskar_spears_7", "stun")
local heal = self:GetCaster():GetTalentValue("modifier_huskar_spears_7", "heal")/100
local damage = self:GetCaster():GetTalentValue("modifier_huskar_spears_7", "damage")/100

local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self:GetCaster():GetTalentValue("modifier_huskar_spears_7", "radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)

for _,enemy in pairs(enemies) do 

  if enemy:HasModifier("modifier_custom_huskar_burning_spear_debuff") then 

      local total = 0
      for _,mod in pairs(enemy:FindAllModifiers()) do 
          if mod:GetName() == "modifier_custom_huskar_burning_spear_debuff" then
            total = total + self:GetDamage()*mod:GetRemainingTime()
            mod:Destroy()
          end
      end

      enemy:AddNewModifier(self:GetCaster(), self:GetCaster():BkbAbility(self, self:GetCaster():HasTalent("modifier_huskar_spears_6")), "modifier_stunned", {duration = stun})

      local real_damage = DoDamage({victim = enemy,attacker = self:GetCaster(),ability = self,damage = total*damage, damage_type = DAMAGE_TYPE_MAGICAL,ability = self }, "modifier_huskar_spears_7")

      self:AoeDamage(enemy, total*damage)

      enemy:SendNumber(6, real_damage)
      self:GetCaster():GenericHeal(real_damage*heal, self, nil, nil, "modifier_huskar_spears_7")

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

local duration = self:GetSpecialValueFor("duration") + self:GetCaster():GetTalentValue("modifier_huskar_spears_5", "duration")

target:EmitSound("Hero_Huskar.Burning_Spear")
target:AddNewModifier(self:GetCaster(), self, "modifier_custom_huskar_burning_spear_debuff", { duration = duration })
target:AddNewModifier(self:GetCaster(), self, "modifier_custom_huskar_burning_spear_counter", { duration = duration })

if self:GetCaster():HasTalent("modifier_huskar_spears_7") then 
  self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_custom_huskar_burning_spear_target_mod", {duration = duration, target = target:entindex()})
end 

if self:GetCaster():HasTalent("modifier_huskar_spears_3") then 
  target:AddNewModifier(self:GetCaster(), self, "modifier_custom_huskar_burning_spear_reduction", {duration = self:GetCaster():GetTalentValue("modifier_huskar_spears_3", "duration")})
end 

if self:GetCaster():HasTalent("modifier_huskar_spears_4") then 

  if not double then 
    if RollPseudoRandomPercentage(self:GetCaster():GetTalentValue("modifier_huskar_spears_4", "chance") ,2937,self:GetCaster()) then 
      target:EmitSound("Huskar.Spear_double")

      local hit_effect = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_quad_tap_hit.vpcf", PATTACH_CUSTOMORIGIN, target)
      ParticleManager:SetParticleControlEnt(hit_effect, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), false) 
      ParticleManager:SetParticleControlEnt(hit_effect, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), false) 
      ParticleManager:ReleaseParticleIndex(hit_effect)

      self:AddStack(target, true)
    end
  end

  self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_custom_huskar_burning_spear_speed", {duration = self:GetCaster():GetTalentValue("modifier_huskar_spears_4", "duration")})
end 

end


function custom_huskar_burning_spear:AoeDamage(target, init_damage)
if not self:GetCaster():HasTalent("modifier_huskar_spears_1") then return end 

local damage = init_damage*self:GetCaster():GetTalentValue("modifier_huskar_spears_1", "aoe")/100
for _,unit in pairs(self:GetCaster():FindTargets(self:GetCaster():GetTalentValue("modifier_huskar_spears_1", "radius"), target:GetAbsOrigin())) do 
  if unit ~= target then 
    DoDamage({victim = unit, attacker = self:GetCaster(), damage = damage, ability = self, damage_type = DAMAGE_TYPE_MAGICAL})
  end 
end 

end 


function custom_huskar_burning_spear:MakeSpear()
if not IsServer() then return end
local caster = self:GetCaster()
caster:EmitSound("Hero_Huskar.Burning_Spear.Cast")

if caster:HasTalent("modifier_huskar_spears_2") then 
  if RollPseudoRandomPercentage(caster:GetTalentValue("modifier_huskar_spears_2", "chance"),4937,caster) then 
    caster:EmitSound("Huskar.Spear_Heal")

    local heal = (caster:GetMaxHealth() - caster:GetHealth())*caster:GetTalentValue("modifier_huskar_spears_2", "heal")/100
    caster:GenericHeal(heal, self, false, "particles/orange_heal.vpcf", "modifier_huskar_spears_2")
    return
  end 
end 

local health_cost = (caster:GetHealth() * self:GetSpecialValueFor("health_cost") * 0.01)
caster:SetHealth(math.max(caster:GetHealth() - health_cost, 1))
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
if not self:GetCaster():HasTalent("modifier_huskar_spears_5") then return end
return self:GetStackCount()*self.slow
end


function modifier_custom_huskar_burning_spear_counter:OnCreated()

self.slow = self:GetCaster():GetTalentValue("modifier_huskar_spears_5", "slow")

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
DoDamage(self.damageTable)

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
  MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
  MODIFIER_PROPERTY_PROJECTILE_NAME,
}
end



function modifier_custom_huskar_burning_spear_legendary:OnCreated()
self.caster = self:GetCaster()
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.parent:AddRecordDestroyEvent(self)
self.parent:AddAttackRecordEvent_out(self)
self.parent:AddAttackEvent_out(self)
self.parent:AddOrderEvent(self)
self.parent:AddAttackStartEvent_out(self)

self.range = self.parent:GetTalentValue("modifier_huskar_spears_7", "attack_range", true)
self.damage = self.parent:GetTalentValue("modifier_huskar_spears_7", "damage", true)/100

self.slow_range = self.parent:GetTalentValue("modifier_huskar_spears_5", "range", true)

self.fear_cd = self.parent:GetTalentValue("modifier_huskar_spears_6", "cd", true)
self.fear_duration = self.parent:GetTalentValue("modifier_huskar_spears_6", "fear", true)
self.fear_max = self.parent:GetTalentValue("modifier_huskar_spears_6", "max", true)

if not IsServer() then return end 

self.cast = false
self.records = {}
self:StartIntervalThink(0.2)
end

function modifier_custom_huskar_burning_spear_legendary:OnIntervalThink()
if not IsServer() then return end 
if self.caster:HasTalent("modifier_huskar_spears_7") then
  local target_mod = self.caster:FindModifierByName("modifier_custom_huskar_burning_spear_target_mod")
  local total = 0
  if target_mod and target_mod.target and not target_mod.target:IsNull() and target_mod.target:HasModifier("modifier_custom_huskar_burning_spear_debuff") then 
    for _,mod in pairs(target_mod.target:FindAllModifiers()) do 
        if mod:GetName() == "modifier_custom_huskar_burning_spear_debuff" then
          total = total + self.ability:GetDamage()*mod:GetRemainingTime()
        end
    end
    total = (total*(1 + self.caster:GetSpellAmplification(false))*self.damage)*(1 - target_mod.target:Script_GetMagicalArmorValue(false, nil))
  end 
  self.caster:UpdateUIlong({override_stack = math.floor(total), no_min = 1, style = "HuskarSpears"})
end 

end 


function modifier_custom_huskar_burning_spear_legendary:GetModifierAttackRangeBonus()
local bonus = 0
if self.caster:HasTalent("modifier_huskar_spears_7") then 
  bonus = self.range
end 

if self.caster:HasTalent("modifier_huskar_spears_5") then 
  bonus = bonus + self.slow_range
end
return bonus
end


function modifier_custom_huskar_burning_spear_legendary:AttackRecordEvent_out(params)
if not IsServer() then return end
if self.parent ~= params.attacker then return end 

self.parent:RemoveModifierByName("modifier_custom_huskar_burning_spear_attack")

if not self:ShouldLaunch( params.target ) then return end
self.parent:AddNewModifier(self.parent, self.ability, "modifier_custom_huskar_burning_spear_attack", {})
end



function modifier_custom_huskar_burning_spear_legendary:AttackStartEvent_out( params )
if params.attacker~=self.parent then return end

if self.parent:HasModifier("modifier_custom_huskar_burning_spear_attack") then
  self.parent:RemoveModifierByName("modifier_custom_huskar_burning_spear_attack")

  self.cast = false
  self.records[params.record] = true
  self.ability:MakeSpear()
end

end



function modifier_custom_huskar_burning_spear_legendary:AttackEvent_out(params)
if not IsServer() then return end
if self.parent ~= params.attacker then return end
if not params.target:IsUnit() then return end
if not self.records[params.record] then return end

self.ability:AddStack(params.target )

if not self.parent:HasTalent("modifier_huskar_spears_6") then return end

local mod = params.target:FindModifierByName("modifier_custom_huskar_burning_spear_counter")

if mod and mod:GetStackCount() >= self.fear_max and not params.target:HasModifier("modifier_custom_huskar_burning_spear_fear_cd") then 
  params.target:AddNewModifier(self.parent, self.ability, "modifier_custom_huskar_burning_spear_fear_cd", {duration = self.fear_cd})
  params.target:EmitSound("BS.Rupture_fear")
  params.target:AddNewModifier(self.parent, self.parent:BkbAbility(self.ability, true), "modifier_nevermore_requiem_fear", {duration  = self.fear_duration * (1 - params.target:GetStatusResistance())})
  params.target:AddNewModifier(self.parent, self.parent:BkbAbility(self.ability, true), "modifier_custom_huskar_burning_spear_fear_speed", {duration  = self.fear_duration * (1 - params.target:GetStatusResistance())})
end

end

function modifier_custom_huskar_burning_spear_legendary:GetModifierProjectileName()
if self.parent:HasModifier("modifier_custom_huskar_burning_spear_attack") then
  return "particles/units/heroes/hero_huskar/huskar_burning_spear.vpcf"
end
return "particles/units/heroes/hero_huskar/huskar_base_attack.vpcf"
end


function modifier_custom_huskar_burning_spear_legendary:RecordDestroyEvent( params )
self.records[params.record] = nil
end


function modifier_custom_huskar_burning_spear_legendary:OrderEvent( params )
if self.parent:HasTalent("modifier_huskar_spears_7") then return end

if params.ability and params.ability==self.ability then
  self.cast = true
else
  self.cast = false
end

end


function modifier_custom_huskar_burning_spear_legendary:ShouldLaunch( target )
if self.parent:IsSilenced() then return false end
if not self.ability:GetAutoCastState() and self.cast == false and not self.parent:HasTalent("modifier_huskar_spears_7") then return false end
if not target:IsUnit() or target:GetTeamNumber() == self.parent:GetTeamNumber() then return false end

return true
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

self.speed = self:GetCaster():GetTalentValue("modifier_huskar_spears_4", "speed")
self.max = self:GetCaster():GetTalentValue("modifier_huskar_spears_4", "max")
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

self.damage_reduce = self:GetCaster():GetTalentValue("modifier_huskar_spears_3", "damage_reduce")
self.heal_reduce = self:GetCaster():GetTalentValue("modifier_huskar_spears_3", "heal_reduce")
self.max = self:GetCaster():GetTalentValue("modifier_huskar_spears_3", "max")
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
self.speed = self:GetCaster():GetTalentValue("modifier_huskar_spears_6", "speed")
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



modifier_custom_huskar_burning_spear_attack = class(mod_hidden)
