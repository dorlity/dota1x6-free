LinkLuaModifier("modifier_monkey_king_jingu_mastery_custom_hit", "abilities/monkey_king/monkey_king_jingu_mastery_custom.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_monkey_king_jingu_mastery_custom_thinker", "abilities/monkey_king/monkey_king_jingu_mastery_custom.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_monkey_king_jingu_mastery_custom_buff", "abilities/monkey_king/monkey_king_jingu_mastery_custom.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_monkey_king_jingu_mastery_custom_resist", "abilities/monkey_king/monkey_king_jingu_mastery_custom.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_monkey_king_jingu_mastery_custom_arc", "abilities/monkey_king/monkey_king_jingu_mastery_custom.lua", LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier("modifier_monkey_king_jingu_mastery_custom_slow", "abilities/monkey_king/monkey_king_jingu_mastery_custom.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_monkey_king_jingu_mastery_custom_agility", "abilities/monkey_king/monkey_king_jingu_mastery_custom.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_monkey_king_jingu_mastery_custom_shield", "abilities/monkey_king/monkey_king_jingu_mastery_custom.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_monkey_king_jingu_mastery_custom_shield_cd", "abilities/monkey_king/monkey_king_jingu_mastery_custom.lua", LUA_MODIFIER_MOTION_NONE)




monkey_king_jingu_mastery_custom = class({})



function monkey_king_jingu_mastery_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end

PrecacheResource( "particle", "particles/units/heroes/hero_monkey_king/monkey_king_quad_tap_hit.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_monkey_king/monkey_king_quad_tap_stack.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_monkey_king/monkey_king_quad_tap_overhead.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_monkey_king/monkey_king_quad_tap_start.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_monkey_king/monkey_king_tap_buff.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_marci/marci_rebound_allymovespeed.vpcf", context )
PrecacheResource( "particle", "particles/mk_shield.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_monkey_king/monkey_king_jump_trail.vpcf", context )
PrecacheResource( "particle", "particles/mk_mastery_legendary.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_monkey_king/monkey_king_strike_slow_impact.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_sniper/sniper_headshot_slow.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_marci/marci_rebound_bounce_impact_debuff.vpcf", context )
PrecacheResource( "particle", "particles/status_fx/status_effect_snapfire_slow.vpcf", context )
end



function monkey_king_jingu_mastery_custom:CreateTalent(name)

if name == "modifier_monkey_king_mastery_2" then 

  local mod = self:GetCaster():FindModifierByName("modifier_monkey_king_jingu_mastery_custom_thinker")
  if mod then 
    mod.PercentAgi = self:GetCaster():GetTalentValue("modifier_monkey_king_mastery_2", "agility")/100
  end
end

end 



function monkey_king_jingu_mastery_custom:GetIntrinsicModifierName()
if self:GetCaster():IsRealHero() and not self:GetCaster():IsTempestDouble() then 
  return "modifier_monkey_king_jingu_mastery_custom_thinker"
end

end


function monkey_king_jingu_mastery_custom:GetBehavior()
  if self:GetCaster():HasTalent("modifier_monkey_king_mastery_7") then
    return  DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_ROOT_DISABLES
  end
 return DOTA_ABILITY_BEHAVIOR_PASSIVE
end

function monkey_king_jingu_mastery_custom:GetCastRange(vLocation, hTarget)

if self:GetCaster():HasTalent("modifier_monkey_king_mastery_7") then
  return self:GetCaster():GetTalentValue("modifier_monkey_king_mastery_7", "range")
end

end


function monkey_king_jingu_mastery_custom:GetCooldown(iLevel)
if not self:GetCaster():HasTalent("modifier_monkey_king_mastery_7") then return end
return self:GetCaster():GetTalentValue("modifier_monkey_king_mastery_7", "cd")
end


function monkey_king_jingu_mastery_custom:OnSpellStart()
if not IsServer() then return end

local caster = self:GetCaster()
local target = self:GetCursorTarget()
local target_loc = target:GetAbsOrigin()

caster:RemoveModifierByName("modifier_monkey_king_tree_dance_custom")
FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)

local direction = (target_loc - caster:GetAbsOrigin()):Normalized()
local point = target_loc + direction*caster:GetTalentValue("modifier_monkey_king_mastery_7", "back")

local distance = (point - caster:GetAbsOrigin()):Length2D()

caster:EmitSound("MK.Mastery_legendary")

local arc = caster:AddNewModifier( caster, self, "modifier_monkey_king_jingu_mastery_custom_arc",
  { 
  dir_x = direction.x,
  dir_y = direction.y,
  distance = distance,
  height = 110,
  speed = caster:GetTalentValue("modifier_monkey_king_mastery_7", "speed"),
  fix_end = false,
  isStun = true,
  isForward = true,
  target = target:entindex(),
  max_distance = 1300,
  activity = ACT_DOTA_MK_SPRING_SOAR,
})

arc:SetEndCallback( function( interrupted )

  Timers:CreateTimer(0.07, function()
    if caster and not caster:IsNull() then 

    end
  end)

  FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
  caster:StartGestureWithPlaybackRate(ACT_DOTA_MK_SPRING_END,1)
  local dir = (target_loc - caster:GetAbsOrigin()):Normalized()
  dir.z = 0
  caster:SetForwardVector(dir)
  caster:FaceTowards(target_loc)
end)



end




modifier_monkey_king_jingu_mastery_custom_thinker = class({})
function modifier_monkey_king_jingu_mastery_custom_thinker:IsHidden() return true end
function modifier_monkey_king_jingu_mastery_custom_thinker:IsPurgable() return false end



function modifier_monkey_king_jingu_mastery_custom_thinker:OnCreated()
self.ability = self:GetAbility()
self.parent = self:GetParent()

self.duration_debuff = self.ability:GetSpecialValueFor("counter_duration")
self.double_chance = self.parent:GetTalentValue("modifier_monkey_king_mastery_5", "chance", true)

self.low_health = self.parent:GetTalentValue("modifier_monkey_king_mastery_6", "health", true)
self.low_duration = self.parent:GetTalentValue("modifier_monkey_king_mastery_6", "duration", true)
self.low_cd = self.parent:GetTalentValue("modifier_monkey_king_mastery_6", "cd", true)
self.low_bonus = self.parent:GetTalentValue("modifier_monkey_king_mastery_6", "bonus", true)

self.legendary_cd_inc = self.parent:GetTalentValue("modifier_monkey_king_mastery_7", "cd_inc", true)

self.speed_duration = self.parent:GetTalentValue("modifier_monkey_king_mastery_3", "duration", true)

if not IsServer() then return end
self.parent:AddDamageEvent_out(self)

if self.parent:IsRealHero() and not self.parent:IsTempestDouble() then
  self.parent:AddDamageEvent_inc(self)
end

end




function modifier_monkey_king_jingu_mastery_custom_thinker:DamageEvent_out(params)
if not IsServer() then return end

if self.parent:GetTeamNumber() == params.attacker:GetTeamNumber() and not params.inflictor and params.damage_category == DOTA_DAMAGE_CATEGORY_ATTACK then 

  if not params.attacker:HasModifier("modifier_monkey_king_jingu_mastery_custom_buff") then 

    local attacker = params.attacker
    local target = params.unit

    if attacker.owner then 
      attacker = attacker.owner
    end

    if self.parent ~= attacker then return end
    if not target:IsUnit() then return end
    if params.attacker:PassivesDisabled() then return end

    local is_clone = params.attacker:HasModifier("modifier_monkey_king_wukongs_command_custom_soldier")
    if not is_clone and self.parent ~= params.attacker then return end

    if is_clone then
      if not self.parent:HasScepter() then return end 
      target = params.attacker
    end 

    target:AddNewModifier(params.attacker, self.ability, "modifier_monkey_king_jingu_mastery_custom_hit", {duration = self.duration_debuff})
    return
  end

  local mod = params.attacker:FindModifierByName("modifier_monkey_king_jingu_mastery_custom_buff")


  if mod and mod:GetElapsedTime() > 0.1 then 

    if params.attacker == self.parent then 
      
      local heal = mod.lifesteal*params.damage

      if params.unit:IsCreep() then 
        heal = heal*mod.lifesteal_creeps
      end

      if self.parent:HasModifier("modifier_monkey_king_jingu_mastery_custom_shield") then 
        heal = self.low_bonus*heal
      end

      if not params.unit:IsBuilding() and not params.unit:IsIllusion() then 

        if self.parent:GetQuest() == "Monkey.Quest_7" and params.unit:IsRealHero() and not self.parent:QuestCompleted() then 
          self.parent:UpdateQuest(math.floor(math.min(heal, self.parent:GetMaxHealth() - self.parent:GetHealth())))
        end

        self.parent:GenericHeal(heal, self.ability)
      end

      if self.parent:HasTalent("modifier_monkey_king_mastery_3") then 
        self.parent:AddNewModifier(self.parent, self.ability, "modifier_monkey_king_jingu_mastery_custom_resist", {duration = self.speed_duration})
      end 

      if self.ability:GetCooldownTimeRemaining() > 0 then 
        self.parent:CdAbility(self.ability, self.legendary_cd_inc)
      end

      local hit_effect = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_quad_tap_hit.vpcf", PATTACH_CUSTOMORIGIN, params.unit)
      ParticleManager:SetParticleControlEnt(hit_effect, 0, params.unit, PATTACH_POINT_FOLLOW, "attach_hitloc", params.unit:GetAbsOrigin(), false) 
      ParticleManager:SetParticleControlEnt(hit_effect, 1, params.unit, PATTACH_POINT_FOLLOW, "attach_hitloc", params.unit:GetAbsOrigin(), false) 
      ParticleManager:ReleaseParticleIndex(hit_effect)

      if self.parent:HasTalent("modifier_monkey_king_mastery_4") then 
        self.parent:AddNewModifier(self.parent, self.ability, "modifier_monkey_king_jingu_mastery_custom_agility", {duration = self.parent:GetTalentValue("modifier_monkey_king_mastery_4", "duration")})
      end
      
    end

    if not self.parent:HasModifier("modifier_monkey_king_boundless_strike_custom_crit") then 
      mod:DecrementStackCount()
      if mod:GetStackCount() <= 0  then
        mod:Destroy()
      end
    end
  end
end

end



function modifier_monkey_king_jingu_mastery_custom_thinker:DamageEvent_inc(params)
if not IsServer() then return end
if not self.parent:HasTalent("modifier_monkey_king_mastery_6") then return end
if self.parent ~= params.unit then return end
if self.parent:HasModifier("modifier_death") then return end
if self.parent:GetHealthPercent() > self.low_health then return end
if self.parent:HasModifier("modifier_monkey_king_jingu_mastery_custom_shield_cd") then return end
if self.parent:PassivesDisabled() then return end  

self.parent:EmitSound("MK.Mastery_shield")
self.parent:AddNewModifier(self.parent, self:GetAbility(), "modifier_monkey_king_jingu_mastery_custom_shield_cd", {duration = self.low_cd})
self.parent:AddNewModifier(self.parent, self:GetAbility(), "modifier_monkey_king_jingu_mastery_custom_shield", {duration = self.low_duration})
end








modifier_monkey_king_jingu_mastery_custom_hit = class({})
function modifier_monkey_king_jingu_mastery_custom_hit:IsPurgable() return false end
function modifier_monkey_king_jingu_mastery_custom_hit:OnCreated(table)


self.parent = self:GetParent()
self.caster = self:GetCaster()
self.ability = self:GetAbility()

self.hero = self.caster
if self.hero.owner then 
  self.hero = self.hero.owner
end 

self.max_stack = self.ability:GetSpecialValueFor("required_hits") + self.hero:GetTalentValue("modifier_monkey_king_mastery_5", "attack")
self.duration_buff = self.ability:GetSpecialValueFor("max_duration")

if self.parent:IsCreep() then 
  self.duration_buff = self.ability:GetSpecialValueFor("max_duration_creeps")
end

if not IsServer() then return end
self.RemoveForDuel = true

self:SetStackCount(1)
self.effect = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_quad_tap_stack.vpcf", PATTACH_OVERHEAD_FOLLOW, self.parent)
ParticleManager:SetParticleControl(self.effect, 0, self.parent:GetAbsOrigin())
ParticleManager:SetParticleControl(self.effect, 1, Vector(1, self:GetStackCount(), 1))
self:AddParticle(self.effect,true,false,0,false,false)
end


function modifier_monkey_king_jingu_mastery_custom_hit:OnRefresh(table)
if not IsServer() then return end
self:IncrementStackCount()

ParticleManager:SetParticleControl(self.effect, 1, Vector(1, self:GetStackCount(), 1))

if self:GetStackCount() >= self.max_stack then 

  if self.caster:HasTalent("modifier_monkey_king_mastery_1") then 
    self.caster:GenericHeal((self.caster:GetMaxHealth() - self.caster:GetHealth())*self.caster:GetTalentValue("modifier_monkey_king_mastery_1", "heal")/100, self.ability, nil, nil, "modifier_monkey_king_mastery_1")  
  end

  self.caster:AddNewModifier(self.caster, self.ability, "modifier_monkey_king_jingu_mastery_custom_buff", {duration = self.duration_buff})
  self:Destroy()
end

end





modifier_monkey_king_jingu_mastery_custom_buff = class({})

function modifier_monkey_king_jingu_mastery_custom_buff:IsPurgable() return not self.caster:HasTalent("modifier_monkey_king_mastery_5") end
function modifier_monkey_king_jingu_mastery_custom_buff:IsHidden() return false end

function modifier_monkey_king_jingu_mastery_custom_buff:GetEffectName()
return "particles/units/heroes/hero_monkey_king/monkey_king_quad_tap_overhead.vpcf"
end

function modifier_monkey_king_jingu_mastery_custom_buff:GetEffectAttachType()
return PATTACH_OVERHEAD_FOLLOW
end


function modifier_monkey_king_jingu_mastery_custom_buff:OnCreated(table)

self.caster = self:GetCaster()
self.ability = self:GetAbility()

if self.caster.owner then 
  self.caster = self.caster.owner
end

self.parent = self:GetParent()

self.ability = self:GetAbility()
self.damage = self.ability:GetSpecialValueFor("bonus_damage") + self.caster:GetTalentValue("modifier_monkey_king_mastery_2", "damage")*self.caster:GetAgility()/100
self.lifesteal_creeps = self.ability:GetSpecialValueFor("lifesteal_creeps")/100

self.lifesteal = (self.ability:GetSpecialValueFor("lifesteal") + self.parent:GetTalentValue("modifier_monkey_king_mastery_1", "lifesteal"))/100 
self.max_hits = self.ability:GetSpecialValueFor("charges") + self.parent:GetTalentValue("modifier_monkey_king_mastery_5", "count")

if not IsServer() then return end

local startPfx = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_quad_tap_start.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
ParticleManager:SetParticleControl(startPfx, 0, self.parent:GetAbsOrigin())
ParticleManager:ReleaseParticleIndex(startPfx)

local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_tap_buff.vpcf", PATTACH_ABSORIGIN, self.parent)
ParticleManager:SetParticleControlEnt(particle, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_weapon_top", self.parent:GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(particle, 2, self.parent, PATTACH_POINT_FOLLOW, "attach_weapon_top", self.parent:GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(particle, 3, self.parent, PATTACH_POINT_FOLLOW, "attach_weapon_bot", self.parent:GetAbsOrigin(), true)
self:AddParticle(particle,true,false,0,false,false)

self.parent:EmitSound("Hero_MonkeyKing.IronCudgel")

self.RemoveForDuel = true
self:SetStackCount(self.max_hits)

self:StartIntervalThink(0.2)
end

function modifier_monkey_king_jingu_mastery_custom_buff:OnIntervalThink()
if not IsServer() then return end
if not self.ability or not self.ability:GetIntrinsicModifierName() or not self.caster:HasModifier(self.ability:GetIntrinsicModifierName()) then
  self:Destroy()
end

end

function modifier_monkey_king_jingu_mastery_custom_buff:DeclareFunctions()
return 
{
  MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
  MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
}
end


function modifier_monkey_king_jingu_mastery_custom_buff:GetModifierPreAttack_BonusDamage()
if self:GetElapsedTime() <= 0.1 then return end
return self.damage
end



function modifier_monkey_king_jingu_mastery_custom_buff:GetActivityTranslationModifiers(params)
if self:GetElapsedTime() <= 0.1 then return end
return "iron_cudgel_charged_attack"
end



modifier_monkey_king_jingu_mastery_custom_resist = class({})
function modifier_monkey_king_jingu_mastery_custom_resist:IsHidden() return true end
function modifier_monkey_king_jingu_mastery_custom_resist:IsPurgable() return false end
function modifier_monkey_king_jingu_mastery_custom_resist:GetTexture() return "buffs/mastery_resist" end
function modifier_monkey_king_jingu_mastery_custom_resist:DeclareFunctions()
return 
{
  MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end

function modifier_monkey_king_jingu_mastery_custom_resist:OnCreated()
self.parent = self:GetParent()
self.speed = self.parent:GetTalentValue("modifier_monkey_king_mastery_3", "move")
self.status = self.parent:GetTalentValue("modifier_monkey_king_mastery_3", "status")

if not IsServer() then return end 
self:UpdateEffect()
end 

function modifier_monkey_king_jingu_mastery_custom_resist:OnRefresh() 
if not IsServer() then return end 
self:UpdateEffect() 
end

function modifier_monkey_king_jingu_mastery_custom_resist:GetModifierMoveSpeedBonus_Percentage()
return self.speed
end

function modifier_monkey_king_jingu_mastery_custom_resist:GetModifierStatusResistanceStacking() 
return self.status
end

function modifier_monkey_king_jingu_mastery_custom_resist:UpdateEffect()
if not IsServer() then return end

if self.effect then 
  ParticleManager:DestroyParticle(self.effect, true)
  ParticleManager:ReleaseParticleIndex(self.effect)
  self.effect = nil
end 

self.effect = ParticleManager:CreateParticle("particles/units/heroes/hero_marci/marci_rebound_allymovespeed.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
self:AddParticle(self.effect,true,false,0,false,false)
end 




modifier_monkey_king_jingu_mastery_custom_shield = class({})
function modifier_monkey_king_jingu_mastery_custom_shield:IsHidden() return false end
function modifier_monkey_king_jingu_mastery_custom_shield:IsPurgable() return false end
function modifier_monkey_king_jingu_mastery_custom_shield:GetTexture() return "buffs/mastery_shield" end
function modifier_monkey_king_jingu_mastery_custom_shield:OnCreated()
self.damage_reduce = self:GetParent():GetTalentValue("modifier_monkey_king_mastery_6", "damage_reduce")
end

function modifier_monkey_king_jingu_mastery_custom_shield:DeclareFunctions()
return 
{
  MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
}
end

function modifier_monkey_king_jingu_mastery_custom_shield:GetEffectName() return "particles/mk_shield.vpcf" end
function modifier_monkey_king_jingu_mastery_custom_shield:GetModifierIncomingDamage_Percentage()
return self.damage_reduce
end






modifier_monkey_king_jingu_mastery_custom_shield_cd = class({})
function modifier_monkey_king_jingu_mastery_custom_shield_cd:IsHidden() return false end
function modifier_monkey_king_jingu_mastery_custom_shield_cd:IsPurgable() return false end
function modifier_monkey_king_jingu_mastery_custom_shield_cd:RemoveOnDeath() return false end
function modifier_monkey_king_jingu_mastery_custom_shield_cd:IsDebuff() return true end
function modifier_monkey_king_jingu_mastery_custom_shield_cd:GetTexture() return "buffs/mastery_shield" end
function modifier_monkey_king_jingu_mastery_custom_shield_cd:OnCreated(table)
self.RemoveForDuel = true 
end








modifier_monkey_king_jingu_mastery_custom_arc = class({})

function modifier_monkey_king_jingu_mastery_custom_arc:IsHidden() return true end
function modifier_monkey_king_jingu_mastery_custom_arc:IsPurgable() return false end

function modifier_monkey_king_jingu_mastery_custom_arc:OnCreated( kv )
if not IsServer() then return end
self.parent = self:GetParent()

self.target = EntIndexToHScript(kv.target)
self.max_distance = kv.max_distance

self.attacked = false

self.slow_duration = self.parent:GetTalentValue("modifier_monkey_king_mastery_7", "duration")
self.legendary_back = self.parent:GetTalentValue("modifier_monkey_king_mastery_7", "back")

self.init_dir = (self.target:GetAbsOrigin() - self.parent:GetAbsOrigin()):Normalized()
self.end_pos_init = self.target:GetAbsOrigin() + self.init_dir*self.legendary_back
self.start_poc = self.parent:GetAbsOrigin()

self.interrupted = false
self:SetJumpParameters( kv )
self:Jump()

local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_monkey_king/monkey_king_jump_trail.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent )
self:AddParticle(effect_cast,false,false, -1,false, false)
end

function modifier_monkey_king_jingu_mastery_custom_arc:OnRefresh( kv )
  self:OnCreated( kv )
end

function modifier_monkey_king_jingu_mastery_custom_arc:OnDestroy()
  if not IsServer() then return end
  local pos = self.parent:GetOrigin()
  self.parent:RemoveHorizontalMotionController( self )
  self.parent:RemoveVerticalMotionController( self )
  if self.end_offset~=0 then
    self.parent:SetOrigin( pos )
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
  or (self.start_poc - self.parent:GetAbsOrigin()):Length2D() > self.max_distance then 
  self:Destroy()
  return
end

local end_pos = self.target:GetAbsOrigin() + self.init_dir*self.legendary_back
local direction = (end_pos - self.parent:GetAbsOrigin()):Normalized()
local pos = me:GetOrigin() + direction * self.speed * dt 

me:SetOrigin( pos )

if (self.target:GetAbsOrigin() - self.parent:GetAbsOrigin()):Length2D() <= 50 and self.attacked == false
  and self.target:IsAlive() then 
  self.attacked = true

  self.parent:PerformAttack(self.target, true, true, true, false, false, false, false) 

  local startPfx = ParticleManager:CreateParticle("particles/mk_mastery_legendary.vpcf", PATTACH_ABSORIGIN, self.target)
  ParticleManager:SetParticleControl(startPfx, 0, self.target:GetAbsOrigin())
  ParticleManager:ReleaseParticleIndex(startPfx)

  self.target:AddNewModifier(self.parent, self:GetAbility(), "modifier_monkey_king_jingu_mastery_custom_slow", {duration = (1 - self.target:GetStatusResistance())*self.slow_duration})

  local particleID = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_strike_slow_impact.vpcf", PATTACH_CUSTOMORIGIN, nil)
  ParticleManager:SetParticleControlEnt(particleID, 0, self.target, PATTACH_POINT_FOLLOW, "attach_hitloc", self.target:GetAbsOrigin(), true)
  ParticleManager:ReleaseParticleIndex(particleID)

  local hit_effect = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_quad_tap_hit.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.target)
  ParticleManager:SetParticleControl(hit_effect, 1, self.target:GetAbsOrigin())
  ParticleManager:ReleaseParticleIndex(hit_effect)

end

if (end_pos - self.parent:GetAbsOrigin()):Length2D() < self.speed*dt then 
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

self.distance = (self.end_pos_init - self.parent:GetAbsOrigin()):Length2D()
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

function modifier_monkey_king_jingu_mastery_custom_slow:IsHidden() return true end
function modifier_monkey_king_jingu_mastery_custom_slow:IsPurgable() return true end

function modifier_monkey_king_jingu_mastery_custom_slow:OnCreated( kv )
self.ms_slow = self:GetCaster():GetTalentValue("modifier_monkey_king_mastery_7", "move_slow")
self.turn_slow = self:GetCaster():GetTalentValue("modifier_monkey_king_mastery_7", "turn_slow")

if not IsServer() then return end
self.effect = ParticleManager:CreateParticle("particles/units/heroes/hero_sniper/sniper_headshot_slow.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
self:AddParticle(self.effect,true,false,0,false,false)
end


function modifier_monkey_king_jingu_mastery_custom_slow:DeclareFunctions()
return 
{
  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
  MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE
}
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









modifier_monkey_king_jingu_mastery_custom_agility = class({})
function modifier_monkey_king_jingu_mastery_custom_agility:IsHidden() return false end
function modifier_monkey_king_jingu_mastery_custom_agility:IsPurgable() return false end
function modifier_monkey_king_jingu_mastery_custom_agility:GetTexture() return "buffs/mastery_agility" end

function modifier_monkey_king_jingu_mastery_custom_agility:OnCreated(table)
self.caster = self:GetCaster()
self.parent = self:GetParent()

self.agi = self.caster:GetTalentValue("modifier_monkey_king_mastery_4", "agility")
self.str = self.caster:GetTalentValue("modifier_monkey_king_mastery_4", "strength")

if not IsServer() then return end

self.RemoveForDuel = true
self:AddStack(table.duration)
end


function modifier_monkey_king_jingu_mastery_custom_agility:AddStack(duration)
if not IsServer() then return end

self.max_timer = self:GetRemainingTime()

Timers:CreateTimer(duration, function() 
  if self and not self:IsNull() then 
    self:DecrementStackCount()
    if self:GetStackCount() <= 0 then 
      self:Destroy()
    end 
  end 
end)

self:IncrementStackCount()
self.parent:CalculateStatBonus(true)
end 


function modifier_monkey_king_jingu_mastery_custom_agility:OnRefresh(table)
if not IsServer() then return end
self:AddStack(table.duration)
end


function modifier_monkey_king_jingu_mastery_custom_agility:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
  MODIFIER_PROPERTY_STATS_STRENGTH_BONUS
}
end

function modifier_monkey_king_jingu_mastery_custom_agility:GetModifierBonusStats_Agility()
return self.agi*self:GetStackCount()
end

function modifier_monkey_king_jingu_mastery_custom_agility:GetModifierBonusStats_Strength()
return self.str*self:GetStackCount()
end
