LinkLuaModifier("modifier_custom_bristleback_warpath", "abilities/bristleback/bristleback_warpath_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_bristleback_warpath_buff", "abilities/bristleback/bristleback_warpath_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_bristleback_warpath_buff_count", "abilities/bristleback/bristleback_warpath_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_bristleback_warpath_legendary_crit", "abilities/bristleback/bristleback_warpath_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_bristleback_warpath_rampage", "abilities/bristleback/bristleback_warpath_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_bristleback_warpath_lowhp_cd", "abilities/bristleback/bristleback_warpath_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_bristleback_warpath_slow", "abilities/bristleback/bristleback_warpath_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_bristleback_warpath_resist", "abilities/bristleback/bristleback_warpath_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_bristleback_warpath_legendary_cast", "abilities/bristleback/bristleback_warpath_custom", LUA_MODIFIER_MOTION_NONE)


bristleback_warpath_custom              = class({})





function bristleback_warpath_custom:Precache(context)

PrecacheResource( "particle", "particles/units/heroes/hero_dawnbreaker/dawnbreaker_fire_wreath_smash.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_bristleback/bristleback_warpath_dust.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_bristleback/bristleback_warpath.vpcf", context )
PrecacheResource( "particle", "particles/status_fx/status_effect_legion_commander_duel.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_ogre_magi/ogre_magi_bloodlust_buff.vpcf", context )
PrecacheResource( "particle", "particles/brist_lowhp_.vpcf", context )
PrecacheResource( "particle", "particles/back_stack_brist.vpcf", context )
PrecacheResource( "particle", "particles/bristleback/armor_buff.vpcf", context )
end



function bristleback_warpath_custom:GetIntrinsicModifierName() return "modifier_custom_bristleback_warpath" end


function bristleback_warpath_custom:GetCooldown(iLevel)
if self:GetCaster():HasModifier("modifier_bristle_warpath_legendary") then
  return self:GetCaster():GetTalentValue("modifier_bristle_warpath_legendary", "cd")
end

return 0
end


function bristleback_warpath_custom:GetCastPoint(iLevel)
if self:GetCaster():HasModifier("modifier_bristle_warpath_legendary") then 

  local cast = self:GetCaster():GetTalentValue("modifier_bristle_warpath_legendary", "cast")

  if self:GetCaster():HasModifier("modifier_custom_bristleback_warpath_legendary_cast") then 
    cast = cast + self:GetCaster():GetUpgradeStack("modifier_custom_bristleback_warpath_legendary_cast") *self:GetCaster():GetTalentValue("modifier_bristle_warpath_legendary", "cast_inc")
  end 

  return cast
end 


return 0
end



function bristleback_warpath_custom:GetBehavior()
if self:GetCaster():HasModifier("modifier_bristle_warpath_legendary") then
  return DOTA_ABILITY_BEHAVIOR_NO_TARGET 
end
return DOTA_ABILITY_BEHAVIOR_PASSIVE
end



function bristleback_warpath_custom:OnAbilityPhaseStart()
if not IsServer() then return end
self:GetCaster():EmitSound("BB.Warpath_legendary_swing")


local cast = self:GetCaster():GetTalentValue("modifier_bristle_warpath_legendary", "cast")

if self:GetCaster():HasModifier("modifier_custom_bristleback_warpath_legendary_cast") then 
  cast = cast + self:GetCaster():GetUpgradeStack("modifier_custom_bristleback_warpath_legendary_cast") *self:GetCaster():GetTalentValue("modifier_bristle_warpath_legendary", "cast_inc")
end 

local full_duration = 1.8

local anim_k = full_duration / cast

local time_1 = cast * 0.4
local time_2 = cast * 0.8


self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_VICTORY, anim_k)

self.timer_1 =  Timers:CreateTimer(time_1,function() 
  self:GetCaster():EmitSound("BB.Warpath_legendary_swing")
end)

self.timer_2 =  Timers:CreateTimer(time_2,function() 
  self:GetCaster():EmitSound("BB.Warpath_legendary_swing") 
end)


return true 
end




function bristleback_warpath_custom:OnAbilityPhaseInterrupted()
if not IsServer() then return end
self:GetCaster():FadeGesture(ACT_DOTA_VICTORY)

if self.timer_1 ~= nil then
  Timers:RemoveTimer(self.timer_1)
end

if self.timer_2 ~= nil then
  Timers:RemoveTimer(self.timer_2)
end

end


function bristleback_warpath_custom:GetMaxStacks()
return self:GetSpecialValueFor("max_stacks") + self:GetCaster():GetTalentValue("modifier_bristle_warpath_max", "max")
end



function bristleback_warpath_custom:OnSpellStart()
if not IsServer() then return end

self:GetCaster():FadeGesture(ACT_DOTA_VICTORY)

if self.timer_1 ~= nil then
  Timers:RemoveTimer(self.timer_1)
end

if self.timer_2 ~= nil then
  Timers:RemoveTimer(self.timer_2)
end

self:GetCaster():RemoveModifierByName('modifier_custom_bristleback_warpath_legendary_cast')

local origin = self:GetCaster():GetAbsOrigin() + self:GetCaster():GetForwardVector()*150

local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_dawnbreaker/dawnbreaker_fire_wreath_smash.vpcf", PATTACH_WORLDORIGIN, self:GetCaster())
ParticleManager:SetParticleControl(particle, 0, origin)
ParticleManager:ReleaseParticleIndex(particle)

self:GetCaster():EmitSound("BB.Warpath_legendary")

local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), origin, nil, self:GetCaster():GetTalentValue("modifier_bristle_warpath_legendary", "radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,  DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)

local stun = self:GetCaster():GetTalentValue("modifier_bristle_warpath_legendary", "stun")

local crit = self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_custom_bristleback_warpath_legendary_crit", {})
local cleave = self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_tidehunter_anchor_smash_caster", {})

for _,enemy in ipairs(enemies) do 

  self:GetCaster():PerformAttack(enemy, false, true, true, true, false, false, true)

  enemy:AddNewModifier(self:GetCaster(), self, "modifier_stunned", {duration = stun*(1 - enemy:GetStatusResistance())})
end 

if crit then crit:Destroy() end
if cleave then cleave:Destroy() end

end




modifier_custom_bristleback_warpath_legendary_crit = class({})

function modifier_custom_bristleback_warpath_legendary_crit:IsHidden() return true end
function modifier_custom_bristleback_warpath_legendary_crit:IsPurgable() return false end
function modifier_custom_bristleback_warpath_legendary_crit:GetCritDamage() return self.damage end
function modifier_custom_bristleback_warpath_legendary_crit:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE
}
end
function modifier_custom_bristleback_warpath_legendary_crit:GetModifierPreAttack_CriticalStrike() return self.damage end


function modifier_custom_bristleback_warpath_legendary_crit:OnCreated()
self.damage = self:GetCaster():GetTalentValue("modifier_bristle_warpath_legendary", "damage")
end





modifier_custom_bristleback_warpath = class({})

function modifier_custom_bristleback_warpath:IsHidden() return true end
function modifier_custom_bristleback_warpath:IsPurgable() return false end



function modifier_custom_bristleback_warpath:DeclareFunctions()
return 
{
  MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
  MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
  MODIFIER_EVENT_ON_TAKEDAMAGE,
  MODIFIER_EVENT_ON_ATTACK_LANDED
}
end





function modifier_custom_bristleback_warpath:GetModifierAttackRangeBonus()
if not self.parent:HasModifier("modifier_bristle_warpath_pierce") then return end 

return self.parent:GetTalentValue("modifier_bristle_warpath_pierce", "range")
end


function modifier_custom_bristleback_warpath:OnAttackLanded(params)
if not IsServer() then return end
if params.attacker ~= self:GetParent() then return end
if self:GetParent():PassivesDisabled() then return end
if not params.target:IsHero() and not params.target:IsCreep() then return end
if params.no_attack_cooldown then return end

if self:GetParent():HasModifier("modifier_bristle_warpath_resist") then 
  self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_bristleback_warpath_resist", {duration = self.resist_duration})
end

if self.parent:HasModifier("modifier_bristle_warpath_pierce") then 

  if  RollPseudoRandomPercentage(self.parent:GetTalentValue("modifier_bristle_warpath_pierce", "chance"),1437,self.parent) then 
    params.target:EmitSound("BB.Warpath_proc")
    params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_bristleback_warpath_slow", {duration = self.slow_duration*(1 - params.target:GetStatusResistance())})
  end

end

if self.parent:HasModifier("modifier_bristle_warpath_max")  then 
  if RollPseudoRandomPercentage(self.stack_chance,4837,self.parent) then 
    self:IncStacks()
  end
end


if self:GetParent():HasModifier("modifier_bristle_warpath_legendary") then 
  self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_bristleback_warpath_legendary_cast", {duration = self.legendary_duration})
end


end



function modifier_custom_bristleback_warpath:OnCreated()
self.parent = self:GetParent()

self.damage_chance = self:GetCaster():GetTalentValue("modifier_bristle_warpath_bash", "chance", true)
self.damage_duration = self:GetCaster():GetTalentValue("modifier_bristle_warpath_bash", "duration", true)

self.resist_duration = self:GetCaster():GetTalentValue("modifier_bristle_warpath_resist", "duration", true)

self.lowhp_duration = self:GetCaster():GetTalentValue("modifier_bristle_warpath_lowhp", "bkb", true)
self.lowhp_health = self:GetCaster():GetTalentValue("modifier_bristle_warpath_lowhp", "health", true)
self.lowhp_cd = self:GetCaster():GetTalentValue("modifier_bristle_warpath_lowhp", "cd", true)

self.slow_duration = self:GetCaster():GetTalentValue("modifier_bristle_warpath_pierce", "duration", true)

self.stack_chance = self:GetCaster():GetTalentValue("modifier_bristle_warpath_max", "chance", true)

self.legendary_duration = self:GetCaster():GetTalentValue("modifier_bristle_warpath_legendary", "duration", true)
end









function modifier_custom_bristleback_warpath:OnTakeDamage(params)
if not IsServer() then return end
if self:GetParent():PassivesDisabled() then return end
if self:GetParent() ~= params.unit then return end
if not self:GetParent():HasModifier("modifier_bristle_warpath_lowhp") then return end
if not self:GetParent():IsAlive() then return end
if self:GetParent():GetHealthPercent() > self.lowhp_health then return end
if self:GetParent():HasModifier("modifier_custom_bristleback_warpath_lowhp_cd") then return end


self:GetParent():EmitSound("BB.Warpath_lowhp")
local particle_peffect = ParticleManager:CreateParticle("particles/brist_lowhp_.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControl(particle_peffect, 0, self:GetParent():GetAbsOrigin())
ParticleManager:SetParticleControl(particle_peffect, 2, self:GetParent():GetAbsOrigin())
ParticleManager:ReleaseParticleIndex(particle_peffect)

self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_generic_debuff_immune", {effect = 1, duration = self.lowhp_duration})
self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_bristleback_warpath_lowhp_cd", {duration = self.lowhp_cd})

self:GetParent():Purge(false, true, false, true, false)

for i = 1,self:GetAbility():GetMaxStacks() do 
  self:IncStacks()
end

end


function modifier_custom_bristleback_warpath:OnAbilityFullyCast(params)
if not params.ability then return end 
if params.unit ~= self.parent then return end
if self.parent:PassivesDisabled() then return end
if params.ability:GetName() == "bristleback_bristleback_custom" then return end
if params.ability:IsItem() or UnvalidAbilities[params.ability:GetName()] then return end


if self.parent:HasModifier("modifier_bristle_warpath_bash")  then 

  if RollPseudoRandomPercentage(self.damage_chance,1837,self.parent) then 
    self.parent:AddNewModifier(self.parent, self:GetAbility(), "modifier_custom_bristleback_warpath_rampage", {duration = self.damage_duration})
  end

end


local do_stacks = 1
local duration = self:GetAbility():GetSpecialValueFor("stack_duration")

local mod = self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_bristleback_warpath_buff", {duration = duration})

if not mod then return end

for i = 1,do_stacks do
  self:IncStacks()
end


end



function modifier_custom_bristleback_warpath:IncStacks()
 if not IsServer() then return end

self.max_stacks       = self:GetAbility():GetMaxStacks()
local duration = self:GetAbility():GetSpecialValueFor("stack_duration")

local mod = self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_bristleback_warpath_buff", {duration = duration})

if not mod then return end

if  mod:GetStackCount() < self.max_stacks then 
  mod:IncrementStackCount() 
  self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_bristleback_warpath_buff_count", {duration = duration})
else 
  for _,all_counts in ipairs(self:GetParent():FindAllModifiersByName("modifier_custom_bristleback_warpath_buff_count")) do 
    all_counts:Destroy()
    mod:IncrementStackCount() 
    self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_bristleback_warpath_buff_count", {duration = duration})
    break
  end
end

end



modifier_custom_bristleback_warpath_buff = class({})
function modifier_custom_bristleback_warpath_buff:IsHidden() return false end
function modifier_custom_bristleback_warpath_buff:IsPurgable() return false end
function modifier_custom_bristleback_warpath_buff:GetEffectName() return "particles/units/heroes/hero_bristleback/bristleback_warpath_dust.vpcf" end



function modifier_custom_bristleback_warpath_buff:OnCreated()
    

self.ability  = self:GetAbility()
self.caster   = self:GetCaster()
self.parent   = self:GetParent()
self.RemoveForDuel = true

self.damage_per_stack   = self.ability:GetSpecialValueFor("damage_per_stack")
self.move_speed_per_stack = self.ability:GetSpecialValueFor("move_speed_per_stack")

self.cdr = self:GetCaster():GetTalentValue("modifier_bristle_warpath_max", "cdr", true)

self.max_stacks = self:GetCaster():GetTalentValue("modifier_bristle_warpath_max", "max", true)
end


function modifier_custom_bristleback_warpath_buff:DeclareFunctions()
return 
{
  MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
  MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
  MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
  MODIFIER_PROPERTY_MODEL_SCALE
}
end

function modifier_custom_bristleback_warpath_buff:GetModifierPercentageCooldown()
if not self:GetParent():HasModifier("modifier_bristle_warpath_max") then return 0 end 

local max = self.ability:GetSpecialValueFor("max_stacks") + self.max_stacks

if self:GetStackCount() < max then return 0 end

return self.cdr
end
   




function modifier_custom_bristleback_warpath_buff:GetModifierPreAttack_BonusDamage()
if self.parent:IsIllusion() then return end
self.damage_per_stack   = self.ability:GetSpecialValueFor("damage_per_stack")  + self:GetCaster():GetTalentValue("modifier_bristle_warpath_damage", "damage")

return self.damage_per_stack * self:GetStackCount()
end

function modifier_custom_bristleback_warpath_buff:GetModifierAttackSpeedBonus_Constant()
if self.parent:IsIllusion() then return end
if not self.parent:HasModifier("modifier_bristle_warpath_damage") then return end

return self.parent:GetTalentValue("modifier_bristle_warpath_damage", "speed") * self:GetStackCount()
end



function modifier_custom_bristleback_warpath_buff:GetModifierMoveSpeedBonus_Percentage()
  return self:GetAbility():GetSpecialValueFor("move_speed_per_stack") * self:GetStackCount()
end

function modifier_custom_bristleback_warpath_buff:GetModifierModelScale()
  return self:GetStackCount() * 3
end





modifier_custom_bristleback_warpath_buff_count = class({})
function modifier_custom_bristleback_warpath_buff_count:IsHidden() return true end
function modifier_custom_bristleback_warpath_buff_count:IsPurgable() return false end
function modifier_custom_bristleback_warpath_buff_count:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_custom_bristleback_warpath_buff_count:GetEffectName() return "particles/units/heroes/hero_bristleback/bristleback_warpath_dust.vpcf" end



function modifier_custom_bristleback_warpath_buff_count:OnCreated(table)
if not IsServer() then return end
self.RemoveForDuel = true
self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_bristleback/bristleback_warpath.vpcf", PATTACH_POINT_FOLLOW, self:GetParent())
ParticleManager:SetParticleControlEnt(self.particle, 3, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(self.particle, 4, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack2", self:GetCaster():GetAbsOrigin(), true)
self:AddParticle(self.particle, false, false, -1, false, false)

end

function modifier_custom_bristleback_warpath_buff_count:OnDestroy()
if not IsServer() then return end
local mod = self:GetParent():FindModifierByName("modifier_custom_bristleback_warpath_buff")

if mod then 
  mod:DecrementStackCount()
end

end

    


modifier_custom_bristleback_warpath_rampage = class({})

function modifier_custom_bristleback_warpath_rampage:IsHidden() return false end
function modifier_custom_bristleback_warpath_rampage:IsPurgable() return false end
function modifier_custom_bristleback_warpath_rampage:GetTexture() return "buffs/warpath_rampage" end
function modifier_custom_bristleback_warpath_rampage:GetStatusEffectName()
  return "particles/status_fx/status_effect_legion_commander_duel.vpcf"
end
function modifier_custom_bristleback_warpath_rampage:StatusEffectPriority()
    return 12
end


function modifier_custom_bristleback_warpath_rampage:OnCreated(table)

self.damage = self:GetCaster():GetTalentValue("modifier_bristle_warpath_bash", "damage")
self.heal = self:GetCaster():GetTalentValue("modifier_bristle_warpath_bash", "heal")/100
self.heal_creeps = self:GetCaster():GetTalentValue("modifier_bristle_warpath_bash", "heal_creeps")

if not IsServer() then return end
self:GetParent():EmitSound("BB.Warpath_rampage")
self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_ogre_magi/ogre_magi_bloodlust_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControl(self.particle, 0, self:GetParent():GetAbsOrigin())
self:AddParticle(self.particle, false, false, -1, false, false)

end



function modifier_custom_bristleback_warpath_rampage:OnRefresh(table)
if not IsServer() then return end
self:OnCreated(table)
end

function modifier_custom_bristleback_warpath_rampage:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
  MODIFIER_EVENT_ON_TAKEDAMAGE,
  MODIFIER_PROPERTY_MODEL_SCALE,
  MODIFIER_PROPERTY_TOOLTIP
}

end


function modifier_custom_bristleback_warpath_rampage:GetModifierModelScale()
  return 15
end


function modifier_custom_bristleback_warpath_rampage:OnTakeDamage(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end
if params.inflictor ~= nil then return end
if params.unit:IsBuilding() then return end
if params.unit:IsIllusion() then return end

local heal = params.damage*self.heal

if params.unit:IsCreep() then 
  heal = heal / self.heal_creeps
end 

self:GetParent():GenericHeal(heal, self:GetAbility())
end


function modifier_custom_bristleback_warpath_rampage:OnTooltip()
return self.heal*100
end


function modifier_custom_bristleback_warpath_rampage:GetModifierDamageOutgoing_Percentage()
  return self.damage
end








modifier_custom_bristleback_warpath_lowhp_cd = class({})

function modifier_custom_bristleback_warpath_lowhp_cd:IsHidden() return false end
function modifier_custom_bristleback_warpath_lowhp_cd:IsPurgable() return false end
function modifier_custom_bristleback_warpath_lowhp_cd:IsDebuff() return true end
function modifier_custom_bristleback_warpath_lowhp_cd:GetTexture() return "buffs/warpath_lowhp" end
function modifier_custom_bristleback_warpath_lowhp_cd:RemoveOnDeath() return false end
function modifier_custom_bristleback_warpath_lowhp_cd:OnCreated(table)
self.RemoveForDuel = true
end








modifier_custom_bristleback_warpath_slow = class({})
function modifier_custom_bristleback_warpath_slow:IsHidden() return true end
function modifier_custom_bristleback_warpath_slow:IsPurgable() return true end
function modifier_custom_bristleback_warpath_slow:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end

function modifier_custom_bristleback_warpath_slow:GetModifierMoveSpeedBonus_Percentage()
return self.slow
end


function modifier_custom_bristleback_warpath_slow:OnCreated()

self.slow = self:GetCaster():GetTalentValue("modifier_bristle_warpath_pierce", "slow")
end 


function modifier_custom_bristleback_warpath_slow:GetEffectName()
    return "particles/units/heroes/hero_sniper/sniper_headshot_slow.vpcf"
end


function modifier_custom_bristleback_warpath_slow:GetEffectAttachType()
    return PATTACH_OVERHEAD_FOLLOW
end




modifier_custom_bristleback_warpath_resist = class({})
function modifier_custom_bristleback_warpath_resist:IsHidden() return false end
function modifier_custom_bristleback_warpath_resist:IsPurgable() return false end
function modifier_custom_bristleback_warpath_resist:GetTexture() return "buffs/Warpath_resist" end

function modifier_custom_bristleback_warpath_resist:OnCreated(table)

self.status = self:GetCaster():GetTalentValue("modifier_bristle_warpath_resist", "status")
self.armor = self:GetCaster():GetTalentValue("modifier_bristle_warpath_resist", "armor")
self.max = self:GetCaster():GetTalentValue("modifier_bristle_warpath_resist", "max")

self.RemoveForDuel = true
if not IsServer() then return end
self:SetStackCount(1)

end

function modifier_custom_bristleback_warpath_resist:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end
self:IncrementStackCount()


if self:GetStackCount() == self.max then
 -- self:GetParent():EmitSound("BB.Back_shield")
  self.effect = ParticleManager:CreateParticle( "particles/items2_fx/vindicators_axe_armor.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
  self:AddParticle(self.effect,false, false, -1, false, false)
end

end


function modifier_custom_bristleback_warpath_resist:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
  MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
}
end


function modifier_custom_bristleback_warpath_resist:GetModifierStatusResistanceStacking()
  return self.status*self:GetStackCount()
end



function modifier_custom_bristleback_warpath_resist:GetModifierPhysicalArmorBonus()
  return self.armor*self:GetStackCount()
end




modifier_custom_bristleback_warpath_legendary_cast = class({})
function modifier_custom_bristleback_warpath_legendary_cast:IsHidden() return true end
function modifier_custom_bristleback_warpath_legendary_cast:IsPurgable() return false end
function modifier_custom_bristleback_warpath_legendary_cast:GetTexture() return "buffs/warpath_legendary" end
function modifier_custom_bristleback_warpath_legendary_cast:OnCreated()
self.max = self:GetCaster():GetTalentValue("modifier_bristle_warpath_legendary", "max")

if not IsServer() then return end

self.effect_cast = ParticleManager:CreateParticle( "particles/back_stack_brist.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
self:AddParticle(self.effect_cast,false, false, -1, false, false)

self:SetStackCount(1)
end

function modifier_custom_bristleback_warpath_legendary_cast:OnRefresh()
if not IsServer() then return end 
if self:GetStackCount() >= self.max then return end

self:IncrementStackCount()
end

function modifier_custom_bristleback_warpath_legendary_cast:OnStackCountChanged(iStackCount)
if not self.effect_cast then return end

ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, self:GetStackCount(), 0 ) )
end


