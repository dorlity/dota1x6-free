LinkLuaModifier("modifier_monkey_king_jingu_mastery_custom_hit", "abilities/monkey_king/monkey_king_jingu_mastery_custom.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_monkey_king_jingu_mastery_custom_thinker", "abilities/monkey_king/monkey_king_jingu_mastery_custom.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_monkey_king_jingu_mastery_custom_buff", "abilities/monkey_king/monkey_king_jingu_mastery_custom.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_monkey_king_jingu_mastery_custom_resist", "abilities/monkey_king/monkey_king_jingu_mastery_custom.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_monkey_king_jingu_mastery_custom_arc", "abilities/monkey_king/monkey_king_jingu_mastery_custom.lua", LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier("modifier_monkey_king_jingu_mastery_custom_slow", "abilities/monkey_king/monkey_king_jingu_mastery_custom.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_monkey_king_jingu_mastery_custom_legendary_damage", "abilities/monkey_king/monkey_king_jingu_mastery_custom.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_monkey_king_jingu_mastery_custom_agility_stack", "abilities/monkey_king/monkey_king_jingu_mastery_custom.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_monkey_king_jingu_mastery_custom_agility", "abilities/monkey_king/monkey_king_jingu_mastery_custom.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_monkey_king_jingu_mastery_custom_shield", "abilities/monkey_king/monkey_king_jingu_mastery_custom.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_monkey_king_jingu_mastery_custom_shield_cd", "abilities/monkey_king/monkey_king_jingu_mastery_custom.lua", LUA_MODIFIER_MOTION_NONE)




monkey_king_jingu_mastery_custom = class({})

monkey_king_jingu_mastery_custom.bonus_heal = {0.04, 0.06, 0.08}
monkey_king_jingu_mastery_custom.bonus_lifesteal = {0.10, 0.15, 0.20}


monkey_king_jingu_mastery_custom.move_speed = {10, 15, 20}
monkey_king_jingu_mastery_custom.move_resist = {10, 15, 20}
monkey_king_jingu_mastery_custom.move_duration = 3

monkey_king_jingu_mastery_custom.legendary_slow_move = -50
monkey_king_jingu_mastery_custom.legendary_slow_turn = -70
monkey_king_jingu_mastery_custom.legendary_slow_duration = 1.2
monkey_king_jingu_mastery_custom.legendary_speed = 1800
monkey_king_jingu_mastery_custom.legendary_range = 500
monkey_king_jingu_mastery_custom.legendary_damage = 30
monkey_king_jingu_mastery_custom.legendary_cd = 10
monkey_king_jingu_mastery_custom.legendary_cd_attack = 4
monkey_king_jingu_mastery_custom.legendary_back = 250



monkey_king_jingu_mastery_custom.max_hits = 1
monkey_king_jingu_mastery_custom.max_silence = 1.5
monkey_king_jingu_mastery_custom.max_chance = 20

monkey_king_jingu_mastery_custom.shield_damage = -20
monkey_king_jingu_mastery_custom.shield_health = 30
monkey_king_jingu_mastery_custom.shield_heal = 2 
monkey_king_jingu_mastery_custom.shield_duration = 4
monkey_king_jingu_mastery_custom.shield_cd = 40




function monkey_king_jingu_mastery_custom:Precache(context)

PrecacheResource( "particle", 'particles/mk_mastery_legendary.vpcf', context )
PrecacheResource( "particle", 'particles/mk_armor_hit.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_monkey_king/monkey_king_quad_tap_stack.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_monkey_king/monkey_king_quad_tap_overhead.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_monkey_king/monkey_king_quad_tap_start.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_monkey_king/monkey_king_tap_buff.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_monkey_king/monkey_king_quad_tap_hit.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_marci/marci_rebound_allymovespeed.vpcf', context )
PrecacheResource( "particle", 'particles/mk_shield.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_monkey_king/monkey_king_jump_trail.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_monkey_king/monkey_king_strike_slow_impact.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_sniper/sniper_headshot_slow.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_marci/marci_rebound_bounce_impact_debuff.vpcf', context )
PrecacheResource( "particle", 'particles/status_fx/status_effect_snapfire_slow.vpcf', context )

end





function monkey_king_jingu_mastery_custom:GetIntrinsicModifierName()
    return "modifier_monkey_king_jingu_mastery_custom_thinker"
end

function monkey_king_jingu_mastery_custom:GetBehavior()
  if self:GetCaster():HasModifier("modifier_monkey_king_mastery_7") then
    return  DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_ROOT_DISABLES
  end
 return DOTA_ABILITY_BEHAVIOR_PASSIVE
end

function monkey_king_jingu_mastery_custom:GetCastRange(vLocation, hTarget)

  if self:GetCaster():HasModifier("modifier_monkey_king_mastery_7") then
    return  self.legendary_range
  end

end


function monkey_king_jingu_mastery_custom:GetCooldown(iLevel)
if not self:GetCaster():HasModifier("modifier_monkey_king_mastery_7") then return end

return self.legendary_cd
end

function monkey_king_jingu_mastery_custom:OnSpellStart()
if not IsServer() then return end

local target = self:GetCursorTarget()
local target_loc = target:GetAbsOrigin()

self:GetCaster():RemoveModifierByName("modifier_monkey_king_tree_dance_custom")
FindClearSpaceForUnit(self:GetCaster(), self:GetCaster():GetAbsOrigin(), false)

local direction = (target_loc - self:GetCaster():GetAbsOrigin()):Normalized()
local point = target_loc + direction*self.legendary_back

local distance = (point - self:GetCaster():GetAbsOrigin()):Length2D()

self:GetCaster():EmitSound("MK.Mastery_legendary")

local arc = self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_monkey_king_jingu_mastery_custom_arc",
  { 
  dir_x = direction.x,
  dir_y = direction.y,
  distance = distance,
  height = 110,
  speed = self.legendary_speed,
  fix_end = false,
  isStun = true,
  isForward = true,
  target = target:entindex(),
  max_distance = 1000,
  activity = ACT_DOTA_MK_SPRING_SOAR,
})

arc:SetEndCallback( function( interrupted )

  Timers:CreateTimer(0.07, function()
    if self:GetCaster() and not self:GetCaster():IsNull() then 
      local startPfx = ParticleManager:CreateParticle("particles/mk_mastery_legendary.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
      ParticleManager:SetParticleControl(startPfx, 0, self:GetCaster():GetAbsOrigin())
      ParticleManager:ReleaseParticleIndex(startPfx)
    end
  end)

  FindClearSpaceForUnit(self:GetCaster(), self:GetCaster():GetAbsOrigin(), false)
  self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_MK_SPRING_END,1)
  local dir = (target_loc - self:GetCaster():GetAbsOrigin()):Normalized()
  dir.z = 0
  self:GetCaster():SetForwardVector(dir)
  self:GetCaster():FaceTowards(target_loc)
end)



end




modifier_monkey_king_jingu_mastery_custom_thinker = class({})


function modifier_monkey_king_jingu_mastery_custom_thinker:IsHidden()
    return true
end

function modifier_monkey_king_jingu_mastery_custom_thinker:DeclareFunctions()
return 
{
  MODIFIER_EVENT_ON_ATTACK_LANDED,
  MODIFIER_EVENT_ON_TAKEDAMAGE
}
end


function modifier_monkey_king_jingu_mastery_custom_thinker:OnTakeDamage(params)
if not IsServer() then return end
if (self:GetParent() ~= params.unit)  then return end
if not self:GetParent():HasModifier("modifier_monkey_king_mastery_6") then return end
if self:GetParent():HasModifier("modifier_death") then return end
if self:GetParent():GetHealthPercent() > self:GetAbility().shield_health then return end
if self:GetParent():HasModifier('modifier_monkey_king_jingu_mastery_custom_shield_cd') then return end
if self:GetParent():PassivesDisabled() then return end  

self:GetParent():EmitSound("MK.Mastery_shield")
self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_monkey_king_jingu_mastery_custom_shield_cd", {duration = self:GetAbility().shield_cd})
self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_monkey_king_jingu_mastery_custom_shield", {duration = self:GetAbility().shield_duration})

end



function modifier_monkey_king_jingu_mastery_custom_thinker:OnCreated()
self.ability = self:GetAbility()
if not self.ability then return end
self.duration_debuff = self:GetAbility():GetSpecialValueFor("counter_duration")

end




function modifier_monkey_king_jingu_mastery_custom_thinker:OnRefresh(table)
self:OnCreated(table)
end


function modifier_monkey_king_jingu_mastery_custom_thinker:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end
if params.target:IsBuilding() then return end
if self:GetParent():PassivesDisabled() then return end
if self:GetParent():IsIllusion() then return end
if self:GetParent():HasModifier("modifier_monkey_king_wukongs_command_custom_soldier") and not self:GetParent():HasScepter() then return end
if self:GetParent():GetTeamNumber() == params.target:GetTeamNumber() then return end

local target = params.target
if self:GetParent():HasModifier("modifier_monkey_king_wukongs_command_custom_soldier") or self:GetParent():HasModifier("modifier_monkey_king_mischief_custom") then 
  target = self:GetParent()
end

if self:GetParent():HasModifier("modifier_monkey_king_jingu_mastery_custom_buff") then return end
target:AddNewModifier(self:GetParent(), self.ability, "modifier_monkey_king_jingu_mastery_custom_hit", {duration = self.duration_debuff})


if target:HasModifier("modifier_monkey_king_jingu_mastery_custom_hit") and self:GetParent():HasModifier("modifier_monkey_king_mastery_5")  then 
    if RollPseudoRandomPercentage(self:GetAbility().max_chance ,527,self:GetCaster()) then 

      params.target:EmitSound("Ogre.Bloodlust_hit")

      local hit_effect = ParticleManager:CreateParticle("particles/mk_armor_hit.vpcf", PATTACH_ABSORIGIN_FOLLOW, params.target)
      ParticleManager:SetParticleControl(hit_effect, 1, params.target:GetAbsOrigin())
      ParticleManager:ReleaseParticleIndex(hit_effect)

      target:AddNewModifier(self:GetParent(), self.ability, "modifier_monkey_king_jingu_mastery_custom_hit", {duration = self.duration_debuff})
    end
end
     
end




modifier_monkey_king_jingu_mastery_custom_hit = class({})

function modifier_monkey_king_jingu_mastery_custom_hit:IsPurgable() return false end

function modifier_monkey_king_jingu_mastery_custom_hit:OnCreated(table)
self.ability = self:GetAbility()
self.max_stack = self:GetAbility():GetSpecialValueFor("required_hits")
self.duration_buff = self:GetAbility():GetSpecialValueFor("max_duration")

if self:GetParent():IsCreep() then 
  self.duration_buff = self:GetAbility():GetSpecialValueFor("max_duration_creeps")
end

if not IsServer() then return end
local parent = self:GetParent()
self.RemoveForDuel = true

self:SetStackCount(1)
self.effect = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_quad_tap_stack.vpcf", PATTACH_OVERHEAD_FOLLOW, parent)
ParticleManager:SetParticleControl(self.effect, 0, parent:GetAbsOrigin())
ParticleManager:SetParticleControl(self.effect, 1, Vector(1, self:GetStackCount(), 1))
self:AddParticle(self.effect,true,false,0,false,false)

end


function modifier_monkey_king_jingu_mastery_custom_hit:OnRefresh(table)
if not IsServer() then return end
self:IncrementStackCount()

ParticleManager:SetParticleControl(self.effect, 1, Vector(1, self:GetStackCount(), 1))

if self:GetStackCount() >= self.max_stack then 

  if self:GetCaster():HasModifier("modifier_monkey_king_mastery_1") then 
    local heal = (self:GetCaster():GetMaxHealth() - self:GetCaster():GetHealth())*self:GetAbility().bonus_heal[self:GetCaster():GetUpgradeStack("modifier_monkey_king_mastery_1")]
    my_game:GenericHeal(self:GetCaster(), heal, self:GetAbility())  
  end

  self:GetCaster():AddNewModifier(self:GetCaster(), self.ability, "modifier_monkey_king_jingu_mastery_custom_buff", {duration = self.duration_buff})
  self:Destroy()
end

end






modifier_monkey_king_jingu_mastery_custom_buff = class({})




function modifier_monkey_king_jingu_mastery_custom_buff:IsPurgable() return not self:GetCaster():HasModifier("modifier_monkey_king_mastery_5") 
end
function modifier_monkey_king_jingu_mastery_custom_buff:IsHidden() return false end

function modifier_monkey_king_jingu_mastery_custom_buff:GetEffectName()
  return "particles/units/heroes/hero_monkey_king/monkey_king_quad_tap_overhead.vpcf"
end

function modifier_monkey_king_jingu_mastery_custom_buff:GetEffectAttachType()
  return PATTACH_OVERHEAD_FOLLOW
end


function modifier_monkey_king_jingu_mastery_custom_buff:OnCreated(table)

self.ability = self:GetAbility()
self.damage = self.ability:GetSpecialValueFor("bonus_damage")
self.lifesteal = self.ability:GetSpecialValueFor("lifesteal")/100
self.max_hits = self.ability:GetSpecialValueFor("charges")

if self:GetParent():HasModifier("modifier_monkey_king_mastery_5") then 
  self.max_hits = self.max_hits + self:GetAbility().max_hits
end

self.first_hit = true 

if self:GetParent():HasModifier("modifier_monkey_king_mastery_1") then 

  self.lifesteal = self.lifesteal + self:GetAbility().bonus_lifesteal[self:GetParent():GetUpgradeStack("modifier_monkey_king_mastery_1")]
end

if self:GetParent():HasModifier("modifier_monkey_king_mastery_3") then 
  self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_monkey_king_jingu_mastery_custom_resist", {duration = self:GetAbility().move_duration})
end

if not IsServer() then return end

local ability = self:GetCaster():FindAbilityByName("monkey_king_wukongs_command_custom") 
if ability and ability:GetLevel() > 0 and self:GetCaster():HasModifier("modifier_monkey_king_command_4") 
  and self:GetCaster():FindModifierByName("modifier_monkey_king_command_4"):GetStackCount() == 2 then 
  local point = self:GetParent():GetAbsOrigin()+RandomVector(100)
  ability:SpawnMonkeyKingPointScepter(point, self:GetCaster():GetTalentValue("modifier_monkey_king_command_4", "duration"), true)
end




local unit = self:GetParent()

local startPfx = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_quad_tap_start.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControl(startPfx, 0, self:GetParent():GetAbsOrigin())
ParticleManager:ReleaseParticleIndex(startPfx)


local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_tap_buff.vpcf", PATTACH_ABSORIGIN, unit)
ParticleManager:SetParticleControlEnt(particle, 0, unit, PATTACH_POINT_FOLLOW, "attach_weapon_top", unit:GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(particle, 2, unit, PATTACH_POINT_FOLLOW, "attach_weapon_top", unit:GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(particle, 3, unit, PATTACH_POINT_FOLLOW, "attach_weapon_bot", unit:GetAbsOrigin(), true)

self:AddParticle(particle,true,false,0,false,false)


self:GetParent():EmitSound("Hero_MonkeyKing.IronCudgel")

self.RemoveForDuel = true
self:SetStackCount(self.max_hits)

self.agi_percentage = 0

if self:GetCaster():HasModifier("modifier_monkey_king_mastery_2") then 
  self.agi_percentage = self:GetCaster():GetTalentValue("modifier_monkey_king_mastery_2", "agility")/100
  self:OnIntervalThink()
  self:StartIntervalThink(0.1)
end

end

function modifier_monkey_king_jingu_mastery_custom_buff:DeclareFunctions()
  return {
    MODIFIER_EVENT_ON_TAKEDAMAGE,
    MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
    MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
    MODIFIER_PROPERTY_STATS_AGILITY_BONUS
  }
end

function modifier_monkey_king_jingu_mastery_custom_buff:GetModifierBonusStats_Agility()
return self.agi
end


function modifier_monkey_king_jingu_mastery_custom_buff:GetActivityTranslationModifiers(params)
  return "iron_cudgel_charged_attack"
end


function modifier_monkey_king_jingu_mastery_custom_buff:GetModifierPreAttack_BonusDamage()
if self:GetParent():PassivesDisabled() then return end
    return self.damage
end


function modifier_monkey_king_jingu_mastery_custom_buff:OnIntervalThink()
if not IsServer() then return end

self.agi  = 0
self.agi  = self:GetParent():GetAgility() * self.agi_percentage

self:GetParent():CalculateStatBonus(true)

end

function modifier_monkey_king_jingu_mastery_custom_buff:OnTakeDamage(params)
if not IsServer() then return end
if params.inflictor then return end
if params.attacker ~= self:GetParent() then return end
if self:GetParent():PassivesDisabled() then return end

if self.first_hit == true then 
  self.first_hit = false 
  return
end

local heal = self.lifesteal*params.damage

if params.unit:IsCreep() then 
  heal = heal*self:GetAbility():GetSpecialValueFor("lifesteal_creeps")/100
end

if self:GetParent():HasModifier("modifier_monkey_king_jingu_mastery_custom_shield") then 
  heal = self:GetAbility().shield_heal*heal
end

if not params.unit:IsBuilding() and not params.unit:IsIllusion() then 

  if self:GetCaster():GetQuest() == "Monkey.Quest_7" and params.unit:IsRealHero() and not self:GetCaster():QuestCompleted() then 
    self:GetCaster():UpdateQuest(math.floor(math.min(heal, self:GetParent():GetMaxHealth() - self:GetParent():GetHealth() )))
  end

  my_game:GenericHeal(self:GetParent(), heal, self:GetAbility())
end

if self:GetAbility():GetCooldownTimeRemaining() > 0 then 
  local cd = self:GetAbility():GetCooldownTimeRemaining()
  self:GetAbility():EndCooldown()
 
  if cd > self:GetAbility().legendary_cd_attack then 
    self:GetAbility():StartCooldown(cd - self:GetAbility().legendary_cd_attack)
  end
end


local hit_effect = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_quad_tap_hit.vpcf", PATTACH_CUSTOMORIGIN, params.unit)
ParticleManager:SetParticleControlEnt(hit_effect, 0, params.unit, PATTACH_POINT_FOLLOW, "attach_hitloc", params.unit:GetAbsOrigin(), false) 
ParticleManager:SetParticleControlEnt(hit_effect, 1, params.unit, PATTACH_POINT_FOLLOW, "attach_hitloc", params.unit:GetAbsOrigin(), false) 
ParticleManager:ReleaseParticleIndex(hit_effect)

if self:GetCaster():HasModifier("modifier_monkey_king_mastery_4") then 
  local duration = self:GetCaster():GetTalentValue("modifier_monkey_king_mastery_4", "duration")
  self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_monkey_king_jingu_mastery_custom_agility", {duration = duration})
  self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_monkey_king_jingu_mastery_custom_agility_stack", {duration = duration})

end

if not self:GetParent():HasModifier("modifier_monkey_king_boundless_strike_custom_crit") then 

  self:DecrementStackCount()
  if self:GetStackCount() <= 0  then


    self:Destroy()
  end
end

end






modifier_monkey_king_jingu_mastery_custom_resist = class({})
function modifier_monkey_king_jingu_mastery_custom_resist:IsHidden() return false end
function modifier_monkey_king_jingu_mastery_custom_resist:IsPurgable() return false end
function modifier_monkey_king_jingu_mastery_custom_resist:GetTexture() return "buffs/mastery_resist" end


function modifier_monkey_king_jingu_mastery_custom_resist:DeclareFunctions()
return {
  MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}

end

function modifier_monkey_king_jingu_mastery_custom_resist:GetEffectName() return 
"particles/units/heroes/hero_marci/marci_rebound_allymovespeed.vpcf"
end




function modifier_monkey_king_jingu_mastery_custom_resist:GetModifierMoveSpeedBonus_Percentage()
  return self:GetAbility().move_speed[self:GetCaster():GetUpgradeStack("modifier_monkey_king_mastery_3")]
end




function modifier_monkey_king_jingu_mastery_custom_resist:GetModifierStatusResistanceStacking() 

  return self:GetAbility().move_resist[self:GetCaster():GetUpgradeStack("modifier_monkey_king_mastery_3")]
end




modifier_monkey_king_jingu_mastery_custom_shield = class({})
function modifier_monkey_king_jingu_mastery_custom_shield:IsHidden() return false end
function modifier_monkey_king_jingu_mastery_custom_shield:IsPurgable() return false end
function modifier_monkey_king_jingu_mastery_custom_shield:GetTexture() return "buffs/mastery_shield" end


function modifier_monkey_king_jingu_mastery_custom_shield:DeclareFunctions()
return {
  MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
}

end

function modifier_monkey_king_jingu_mastery_custom_shield:GetEffectName() return 
"particles/mk_shield.vpcf"
end




function modifier_monkey_king_jingu_mastery_custom_shield:GetModifierIncomingDamage_Percentage()
  return self:GetAbility().shield_damage
end




modifier_monkey_king_jingu_mastery_custom_shield_cd = class({})
function modifier_monkey_king_jingu_mastery_custom_shield_cd:IsHidden() return false end
function modifier_monkey_king_jingu_mastery_custom_shield_cd:IsPurgable() return false end
function modifier_monkey_king_jingu_mastery_custom_shield_cd:RemoveOnDeath() return false end
function modifier_monkey_king_jingu_mastery_custom_shield_cd:IsDebuff() return true end
function modifier_monkey_king_jingu_mastery_custom_shield_cd:OnCreated(table)
self.RemoveForDuel = true 
end
function modifier_monkey_king_jingu_mastery_custom_shield_cd:GetTexture() return "buffs/mastery_shield" end








modifier_monkey_king_jingu_mastery_custom_arc = class({})

function modifier_monkey_king_jingu_mastery_custom_arc:IsHidden() return true end




function modifier_monkey_king_jingu_mastery_custom_arc:IsPurgable() return false end

function modifier_monkey_king_jingu_mastery_custom_arc:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_monkey_king_jingu_mastery_custom_arc:OnCreated( kv )
if not IsServer() then return end
self.target = EntIndexToHScript(kv.target)
self.max_distance = kv.max_distance

self.attacked = false



self.init_dir = (self.target:GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Normalized()
self.end_pos_init = self.target:GetAbsOrigin() + self.init_dir*self:GetAbility().legendary_back
self.start_poc = self:GetParent():GetAbsOrigin()

self.interrupted = false
self:SetJumpParameters( kv )
self:Jump()

local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_monkey_king/monkey_king_jump_trail.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
self:AddParticle(effect_cast,false,false, -1,false, false)
end

function modifier_monkey_king_jingu_mastery_custom_arc:OnRefresh( kv )
  self:OnCreated( kv )
end

function modifier_monkey_king_jingu_mastery_custom_arc:OnDestroy()
  if not IsServer() then return end
  local pos = self:GetParent():GetOrigin()
  self:GetParent():RemoveHorizontalMotionController( self )
  self:GetParent():RemoveVerticalMotionController( self )
  if self.end_offset~=0 then
    self:GetParent():SetOrigin( pos )
  end
  if self.endCallback then
    self.endCallback( self.interrupted )
  end
end

function modifier_monkey_king_jingu_mastery_custom_arc:DeclareFunctions()
  local funcs = {
    MODIFIER_PROPERTY_DISABLE_TURNING,
  }
  if self:GetStackCount()>0 then
    table.insert( funcs, MODIFIER_PROPERTY_OVERRIDE_ANIMATION )
  end
  return funcs
end

function modifier_monkey_king_jingu_mastery_custom_arc:GetModifierDisableTurning()
  if not self.isForward then return end
  return 1
end

function modifier_monkey_king_jingu_mastery_custom_arc:GetOverrideAnimation()
  return self:GetStackCount()
end

function modifier_monkey_king_jingu_mastery_custom_arc:CheckState()
  local state = {
    [MODIFIER_STATE_STUNNED] = self.isStun or false,
    [MODIFIER_STATE_COMMAND_RESTRICTED] = self.isRestricted or false,
    [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
  }

  return state
end

function modifier_monkey_king_jingu_mastery_custom_arc:UpdateHorizontalMotion( me, dt )

if (not self.target or self.target:IsNull())
  or (self.start_poc - self:GetParent():GetAbsOrigin()):Length2D() > self.max_distance then 
  self:Destroy()
  return
end

local end_pos = self.target:GetAbsOrigin() + self.init_dir*self:GetAbility().legendary_back


local direction = (end_pos - self:GetParent():GetAbsOrigin()):Normalized()

local pos = me:GetOrigin() + direction * self.speed * dt 

me:SetOrigin( pos )

if (self.target:GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D() <= 50 and self.attacked == false
  and self.target:IsAlive() then 
  self.attacked = true

  --self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_monkey_king_jingu_mastery_custom_legendary_damage", {})

  self:GetParent():PerformAttack(self.target, true, true, true, false, false, false, false) 

  --self:GetParent():RemoveModifierByName("modifier_monkey_king_jingu_mastery_custom_legendary_damage")

  self.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_monkey_king_jingu_mastery_custom_slow", {duration = (1 - self.target:GetStatusResistance())*self:GetAbility().legendary_slow_duration})

  local particleID = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_strike_slow_impact.vpcf", PATTACH_CUSTOMORIGIN, nil)
  ParticleManager:SetParticleControlEnt(particleID, 0, self.target, PATTACH_POINT_FOLLOW, "attach_hitloc", self.target:GetAbsOrigin(), true)
  ParticleManager:ReleaseParticleIndex(particleID)

  local hit_effect = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_quad_tap_hit.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.target)
  ParticleManager:SetParticleControl(hit_effect, 1, self.target:GetAbsOrigin())
  ParticleManager:ReleaseParticleIndex(hit_effect)

end


if (end_pos - self:GetParent():GetAbsOrigin()):Length2D() < self.speed*dt then 
  self:Destroy()
end

end

function modifier_monkey_king_jingu_mastery_custom_arc:UpdateVerticalMotion( me, dt )

  local pos = me:GetOrigin()
  local time = self:GetElapsedTime()
  if time > self.duration then 
    return
  end

  local height = pos.z
  local speed = self:GetVerticalSpeed( time )
  pos.z = height + speed * dt
  me:SetOrigin( pos )
  if not self.fix_duration then
    local ground = GetGroundHeight( pos, me ) + self.end_offset
    if pos.z <= ground then
      pos.z = ground
      me:SetOrigin( pos )
      self:Destroy()
    end
  end
end

function modifier_monkey_king_jingu_mastery_custom_arc:OnHorizontalMotionInterrupted()
  self.interrupted = true
  self:Destroy()
end

function modifier_monkey_king_jingu_mastery_custom_arc:OnVerticalMotionInterrupted()
  self.interrupted = true
  self:Destroy()
end

function modifier_monkey_king_jingu_mastery_custom_arc:SetJumpParameters( kv )
  self.parent = self:GetParent()
  self.fix_end = true
  self.fix_duration = true
  self.fix_height = true

  if kv.fix_end then
    self.fix_end = kv.fix_end==1
  end

  if kv.fix_duration then
    self.fix_duration = kv.fix_duration==1
  end

  if kv.fix_height then
    self.fix_height = kv.fix_height==1
  end
  self.isStun = kv.isStun==1
  self.isRestricted = kv.isRestricted==1
  self.isForward = kv.isForward==1
  self.activity = kv.activity or 0

  self:SetStackCount( self.activity )


  if kv.target_x and kv.target_y then
    local origin = self.parent:GetOrigin()
    local dir = Vector( kv.target_x, kv.target_y, 0 ) - origin
    dir.z = 0
    dir = dir:Normalized()
    self.direction = dir
  end
  if kv.dir_x and kv.dir_y then
    self.direction = Vector( kv.dir_x, kv.dir_y, 0 ):Normalized()
  end
  if not self.direction then
    self.direction = self.parent:GetForwardVector()
  end

  self.speed = kv.speed

  self.distance = (self.end_pos_init - self:GetParent():GetAbsOrigin()):Length2D()
  self.duration = self.distance/self.speed


  self.height = kv.height or 0
  self.start_offset = kv.start_offset or 0
  self.end_offset = kv.end_offset or 0


  local pos_start = self.parent:GetOrigin()
  local pos_end = pos_start + self.direction * self.distance
  local height_start = GetGroundHeight( pos_start, self.parent ) + self.start_offset
  local height_end = GetGroundHeight( pos_end, self.parent ) + self.end_offset
  local height_max
  if not self.fix_height then
    self.height = math.min( self.height, self.distance/4 )
  end

  if self.fix_end then
    height_end = height_start
    height_max = height_start + self.height
  else
    local tempmin, tempmax = height_start, height_end
    if tempmin>tempmax then
      tempmin,tempmax = tempmax, tempmin
    end
    local delta = (tempmax-tempmin)*2/3

    height_max = tempmin + delta + self.height
  end



  self:InitVerticalArc( height_start, height_max, height_end, self.duration )
end

function modifier_monkey_king_jingu_mastery_custom_arc:Jump()
  if self.distance>0 then
    if not self:ApplyHorizontalMotionController() then
      self.interrupted = true
      self:Destroy()
    end
  end

  if self.height>0 then
    if not self:ApplyVerticalMotionController() then
      self.interrupted = true
      self:Destroy()
    end
  end
end

function modifier_monkey_king_jingu_mastery_custom_arc:InitVerticalArc( height_start, height_max, height_end,duration )
  local height_end = height_end - height_start
  local height_max = height_max - height_start

  if height_max<height_end then
    height_max = height_end+0.01
  end


  if height_max<=0 then
    height_max = 0.01
  end

  local duration_end = ( 1 + math.sqrt( 1 - height_end/height_max ) )/2
  self.const1 = 4*height_max*duration_end/duration
  self.const2 = 4*height_max*duration_end*duration_end/(duration*duration)
end

function modifier_monkey_king_jingu_mastery_custom_arc:GetVerticalPos( time )
  return self.const1*time - self.const2*time*time
end

function modifier_monkey_king_jingu_mastery_custom_arc:GetVerticalSpeed( time )
  return self.const1 - 2*self.const2*time
end

function modifier_monkey_king_jingu_mastery_custom_arc:SetEndCallback( func )
  self.endCallback = func
end








modifier_monkey_king_jingu_mastery_custom_slow = class({})

function modifier_monkey_king_jingu_mastery_custom_slow:IsHidden()
  return true
end

function modifier_monkey_king_jingu_mastery_custom_slow:IsPurgable()
  return true
end

function modifier_monkey_king_jingu_mastery_custom_slow:OnCreated( kv )
  self.ms_slow = self:GetAbility().legendary_slow_move
  self.turn_slow = self:GetAbility().legendary_slow_turn


if not IsServer() then return end
self.effect = ParticleManager:CreateParticle("particles/units/heroes/hero_sniper/sniper_headshot_slow.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
self:AddParticle(self.effect,true,false,0,false,false)


end

function modifier_monkey_king_jingu_mastery_custom_slow:OnRefresh( kv )
  self:OnCreated( kv )
end

function modifier_monkey_king_jingu_mastery_custom_slow:DeclareFunctions()
  local funcs = {
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE
  }

  return funcs
end

function modifier_monkey_king_jingu_mastery_custom_slow:GetModifierTurnRate_Percentage()
  return self.turn_slow
end



function modifier_monkey_king_jingu_mastery_custom_slow:GetModifierMoveSpeedBonus_Percentage()
  return self.ms_slow
end

function modifier_monkey_king_jingu_mastery_custom_slow:GetEffectName()
  return "particles/units/heroes/hero_marci/marci_rebound_bounce_impact_debuff.vpcf"
end

function modifier_monkey_king_jingu_mastery_custom_slow:GetEffectAttachType()
  return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_monkey_king_jingu_mastery_custom_slow:GetStatusEffectName()
  return "particles/status_fx/status_effect_snapfire_slow.vpcf"
end

function modifier_monkey_king_jingu_mastery_custom_slow:StatusEffectPriority()
  return MODIFIER_PRIORITY_NORMAL
end


modifier_monkey_king_jingu_mastery_custom_legendary_damage = class({})
function modifier_monkey_king_jingu_mastery_custom_legendary_damage:IsHidden() return true end
function modifier_monkey_king_jingu_mastery_custom_legendary_damage:IsPurgable() return false end 
function modifier_monkey_king_jingu_mastery_custom_legendary_damage:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE
}
end

function modifier_monkey_king_jingu_mastery_custom_legendary_damage:GetModifierDamageOutgoing_Percentage()
if IsServer() then 
  return self:GetAbility().legendary_damage
end
end







modifier_monkey_king_jingu_mastery_custom_agility_stack = class({})
function modifier_monkey_king_jingu_mastery_custom_agility_stack:IsHidden() return true end
function modifier_monkey_king_jingu_mastery_custom_agility_stack:IsPurgable() return false end
function modifier_monkey_king_jingu_mastery_custom_agility_stack:GetAttributes()
  return MODIFIER_ATTRIBUTE_MULTIPLE
end


function modifier_monkey_king_jingu_mastery_custom_agility_stack:OnDestroy()
if not IsServer() then return end

local mod = self:GetParent():FindModifierByName("modifier_monkey_king_jingu_mastery_custom_agility")
if mod then 
  mod:DecrementStackCount()
  if mod:GetStackCount() == 0 then 
    mod:Destroy()
  end
end

end


modifier_monkey_king_jingu_mastery_custom_agility = class({})
function modifier_monkey_king_jingu_mastery_custom_agility:IsHidden() return false end
function modifier_monkey_king_jingu_mastery_custom_agility:IsPurgable() return false end
function modifier_monkey_king_jingu_mastery_custom_agility:GetTexture() return "buffs/mastery_agility" end

function modifier_monkey_king_jingu_mastery_custom_agility:OnCreated(table)
self.agi = self:GetCaster():GetTalentValue("modifier_monkey_king_mastery_4", "agility")

if not IsServer() then return end

self.StackOnIllusion = true


self:IncrementStackCount()
end


function modifier_monkey_king_jingu_mastery_custom_agility:OnRefresh(table)
if not IsServer() then return end
self:OnCreated(table)
end


function modifier_monkey_king_jingu_mastery_custom_agility:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_STATS_AGILITY_BONUS
}
end

function modifier_monkey_king_jingu_mastery_custom_agility:GetModifierBonusStats_Agility()
local parent = self:GetParent()


return self.agi*self:GetStackCount()
end
