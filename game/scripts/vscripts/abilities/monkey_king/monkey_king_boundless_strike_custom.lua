LinkLuaModifier("modifier_monkey_king_boundless_strike_custom_crit", "abilities/monkey_king/monkey_king_boundless_strike_custom.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_monkey_king_boundless_strike_custom_double_thinker", "abilities/monkey_king/monkey_king_boundless_strike_custom.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_monkey_king_boundless_strike_custom_legendary", "abilities/monkey_king/monkey_king_boundless_strike_custom.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_monkey_king_boundless_strike_custom_legendary_anim", "abilities/monkey_king/monkey_king_boundless_strike_custom.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_monkey_king_boundless_strike_custom_attack", "abilities/monkey_king/monkey_king_boundless_strike_custom.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_monkey_king_boundless_strike_custom_attack_cd", "abilities/monkey_king/monkey_king_boundless_strike_custom.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_monkey_king_boundless_strike_custom_attack_anim", "abilities/monkey_king/monkey_king_boundless_strike_custom.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_monkey_king_boundless_strike_custom_attack_armor", "abilities/monkey_king/monkey_king_boundless_strike_custom.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_monkey_king_boundless_strike_custom_damage_bonus", "abilities/monkey_king/monkey_king_boundless_strike_custom.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_monkey_king_boundless_strike_custom_double_illusion", "abilities/monkey_king/monkey_king_boundless_strike_custom.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_monkey_king_boundless_strike_custom_heal", "abilities/monkey_king/monkey_king_boundless_strike_custom.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_monkey_king_boundless_strike_custom_anim", "abilities/monkey_king/monkey_king_boundless_strike_custom.lua", LUA_MODIFIER_MOTION_NONE)

monkey_king_boundless_strike_custom = class({})

function monkey_king_boundless_strike_custom:GetAbilityTextureName()
    if self:GetCaster():HasModifier("modifier_monkey_king_staff_of_gunyu_custom_anniversary") then
        return "monkey_king_strike_anniversary"
    elseif self:GetCaster():HasModifier("modifier_monkey_king_staff_of_gunyu_custom_golden") then
        return "monkey_king_strike_immortal_gold"
    elseif self:GetCaster():HasModifier("modifier_monkey_king_staff_of_gunyu_custom") then
        return "monkey_king_strike_immortal"
    end
    return "monkey_king_boundless_strike"
end

function monkey_king_boundless_strike_custom:Precache(context)
  
PrecacheResource( "particle", 'particles/units/heroes/hero_monkey_king/monkey_king_attack_05_blur.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_monkey_king/monkey_king_attack_06_blur.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_monkey_king/monkey_king_attack_06_near_blur_cud.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_monkey_king/monkey_king_attack_05_near_blur_cud.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_monkey_king/monkey_king_attack_01_near_blur_cud.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_monkey_king/monkey_king_attack_06_near_blur.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_monkey_king/monkey_king_attack_05_near_blur.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_monkey_king/monkey_king_attack_06_near_blur.vpcf', context )

PrecacheResource( "particle", 'particles/units/heroes/hero_monkey_king/monkey_king_strike_cast.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_monkey_king/monkey_king_strike.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_monkey_king/monkey_king_strike_slow_impact.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_monkey_king/monkey_king_jump_trail.vpcf', context )
PrecacheResource( "particle", 'particles/status_fx/status_effect_monkey_king_fur_army.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_alchemist/alchemist_unstable_concoction_timer.vpcf', context )
PrecacheResource( "particle", 'particles/mk_armor_hit.vpcf', context )
PrecacheResource( "particle", 'particles/boundless_attack.vpcf', context )
PrecacheResource( "particle", 'particles/status_fx/status_effect_huskar_lifebreak.vpcf', context )
PrecacheResource( "particle", 'particles/mk_heal_red_1.vpcf', context )
PrecacheResource( "particle", 'particles/monkey_king/cast_legendary.vpcf', context )


my_game:PrecacheShopItems("npc_dota_hero_monkey_king", context)

end


function monkey_king_boundless_strike_custom:GetCooldown(iLevel)

local bonus = 0
if self:GetCaster():HasModifier("modifier_monkey_king_boundless_1") then 
  bonus = self:GetCaster():GetTalentValue("modifier_monkey_king_boundless_1", "cd")
end

 return self.BaseClass.GetCooldown(self, iLevel) + bonus
 
end

function monkey_king_boundless_strike_custom:GetCastPoint()
if self:GetCaster():HasModifier("modifier_monkey_king_boundless_7") then 
  return 0
else 
  return 0.4
end

end


function monkey_king_boundless_strike_custom:GetCastAnimation()
  if self:GetCaster():HasModifier("modifier_monkey_king_boundless_7") then
    return  
  end
 return ACT_DOTA_MK_STRIKE

end

function monkey_king_boundless_strike_custom:GetBehavior()
local shard = 0
if self:GetCaster():HasShard() then 
  shard = DOTA_ABILITY_BEHAVIOR_AUTOCAST
end

  if self:GetCaster():HasModifier("modifier_monkey_king_boundless_7") then
    return  DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + shard 
  end
 return DOTA_ABILITY_BEHAVIOR_POINT + shard 
end



function monkey_king_boundless_strike_custom:GetCastRange(vLocation, hTarget)
local bonus = 0 

if self:GetCaster():HasModifier("modifier_monkey_king_boundless_3") then 
  bonus = self:GetCaster():GetTalentValue("modifier_monkey_king_boundless_3", "range")
end 


return self:GetSpecialValueFor("strike_cast_range") + bonus
end

function monkey_king_boundless_strike_custom:OnAbilityPhaseStart()
local caster = self:GetCaster()

caster:EmitSound("Hero_MonkeyKing.Strike.Cast")

local particle_name = "particles/units/heroes/hero_monkey_king/monkey_king_strike_cast.vpcf"
if self:GetCaster():HasModifier("modifier_monkey_king_staff_of_gunyu_custom_anniversary") then
    particle_name = "particles/econ/items/monkey_king/ti7_weapon/mk_10th_anniversary_strike_cast.vpcf"
elseif self:GetCaster():HasModifier("modifier_monkey_king_staff_of_gunyu_custom_golden") then
    particle_name = "particles/econ/items/monkey_king/ti7_weapon/mk_ti7_golden_immortal_strike_cast.vpcf"
elseif self:GetCaster():HasModifier("modifier_monkey_king_staff_of_gunyu_custom") then
    particle_name = "particles/econ/items/monkey_king/ti7_weapon/mk_ti7_immortal_strike_cast.vpcf"
end


self.pre_particleID = ParticleManager:CreateParticle(particle_name, PATTACH_POINT_FOLLOW, caster)
ParticleManager:SetParticleControl(self.pre_particleID, 0, caster:GetAbsOrigin())
ParticleManager:SetParticleControlEnt(self.pre_particleID, 1, caster, PATTACH_POINT_FOLLOW, "attach_weapon_bot", caster:GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(self.pre_particleID, 2, caster, PATTACH_POINT_FOLLOW, "attach_weapon_top", caster:GetAbsOrigin(), true)
ParticleManager:ReleaseParticleIndex(self.pre_particleID)

  return true
end


function monkey_king_boundless_strike_custom:OnAbilityPhaseInterrupted()
  local caster = self:GetCaster()

  if self.pre_particleID ~= nil then
    ParticleManager:DestroyParticle(self.pre_particleID, true)
    self.pre_particleID = nil
  end
  return true
end




function monkey_king_boundless_strike_custom:OnSpellStart()
if not IsServer() then return end

local point = self:GetCursorPosition()
if point == self:GetCaster():GetAbsOrigin() then 
  point = point + self:GetCaster():GetForwardVector()*10
end





if not self:GetCaster():HasModifier("modifier_monkey_king_boundless_7") then 

  if self.pre_particleID ~= nil then
    ParticleManager:DestroyParticle(self.pre_particleID, false)
    self.pre_particleID = nil
  end

  self:Strike(self:GetCaster():GetAbsOrigin(), point, self:GetCaster(), 0)

else 

  self:GetCaster():SwapAbilities(self:GetName(), "monkey_king_boundless_strike_end_custom", false, true)

  self:GetCaster():FindAbilityByName("monkey_king_boundless_strike_end_custom"):StartCooldown(0.2)

  local illusion_self = CreateIllusions(self:GetCaster(), self:GetCaster(), {
    outgoing_damage = 0,
    duration    = self:GetCaster():GetTalentValue("modifier_monkey_king_boundless_7", "delay") + 1  
    }, 1, 0, false, false)

    local point = self:GetCaster():GetAbsOrigin() - self:GetCaster():GetForwardVector()*20
    for _,illusion in pairs(illusion_self) do


      illusion.owner = caster
      illusion.mk_strike = true


      illusion:AddNewModifier(self:GetCaster(), self, "modifier_monkey_king_boundless_strike_custom_legendary",  {})
      illusion:SetOrigin(GetGroundPosition(point, nil))
      illusion:StartGesture(ACT_DOTA_VICTORY)
      illusion:AddNewModifier(illusion, nil, "modifier_monkey_king_boundless_strike_custom_anim", {})
    end


end






end




function monkey_king_boundless_strike_custom:Strike(start_point, end_point, caster, more_crit, double)
if not IsServer() then return end


local duration = self:GetSpecialValueFor("duration")
local strike_radius = self:GetSpecialValueFor("strike_radius")
local strike_cast_range = self:GetSpecialValueFor("strike_cast_range")

self.stun = self:GetSpecialValueFor('stun')

if self:GetCaster():HasModifier("modifier_monkey_king_boundless_3") then 
  self.stun = self.stun + self:GetCaster():GetTalentValue("modifier_monkey_king_boundless_3", "stun")

  strike_cast_range = strike_cast_range + self:GetCaster():GetTalentValue("modifier_monkey_king_boundless_3", "range")
end


local vStartPosition = start_point
local vTargetPosition = end_point

local vDirection = vTargetPosition - vStartPosition
vDirection.z = 0
vStartPosition = GetGroundPosition(vStartPosition+vDirection:Normalized()*(strike_radius/2), caster)
vTargetPosition = GetGroundPosition(vStartPosition+vDirection:Normalized()*(strike_cast_range-strike_radius/2), caster)


local sound_cast = "Hero_MonkeyKing.Strike.Impact"
if self:GetCaster():HasModifier("modifier_monkey_king_staff_of_gunyu_custom_anniversary") then
    sound_cast = "Hero_MonkeyKing.Strike.Impact.Immortal"
elseif self:GetCaster():HasModifier("modifier_monkey_king_staff_of_gunyu_custom_golden") then
    sound_cast = "Hero_MonkeyKing.Strike.Impact.Immortal"
elseif self:GetCaster():HasModifier("modifier_monkey_king_staff_of_gunyu_custom") then
    sound_cast = "Hero_MonkeyKing.Strike.Impact.Immortal"
end

EmitSoundOnLocationWithCaster(vStartPosition, sound_cast, caster)
EmitSoundOnLocationWithCaster(vTargetPosition, "Hero_MonkeyKing.Strike.Impact.EndPos", caster)



local particle_name = "particles/units/heroes/hero_monkey_king/monkey_king_strike.vpcf"
if self:GetCaster():HasModifier("modifier_monkey_king_staff_of_gunyu_custom_anniversary") then
    particle_name = "particles/monkey_king_custom/mk_10th_anniversary_strike.vpcf"
elseif self:GetCaster():HasModifier("modifier_monkey_king_staff_of_gunyu_custom_golden") then
    particle_name = "particles/monkey_king_custom/mk_ti7_golden_immortal_strike.vpcf"
elseif self:GetCaster():HasModifier("modifier_monkey_king_staff_of_gunyu_custom") then
    particle_name = "particles/monkey_king_custom/mk_ti7_immortal_strike.vpcf"
end

local particleID = ParticleManager:CreateParticle(particle_name, PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(particleID, 0, vStartPosition)
ParticleManager:SetParticleControlForward(particleID, 0, vDirection:Normalized())
ParticleManager:SetParticleControl(particleID, 1, vTargetPosition)
ParticleManager:ReleaseParticleIndex(particleID)


if not double then
  caster:RemoveModifierByName("modifier_monkey_king_boundless_strike_custom_attack_cd")
end

if not double and caster:HasModifier("modifier_monkey_king_boundless_2") then 
    caster:AddNewModifier(caster, self, "modifier_monkey_king_boundless_strike_custom_damage_bonus", 
    {
      duration = self:GetCaster():GetTalentValue("modifier_monkey_king_boundless_2", "duration")
    })
    
end

local crit = self:GetSpecialValueFor("strike_crit_mult") + more_crit

if double then 
  self.stun = self.stun*self:GetCaster():GetTalentValue("modifier_monkey_king_boundless_5", "damage")/100
  crit = crit*self:GetCaster():GetTalentValue("modifier_monkey_king_boundless_5", "damage")/100
end


local crit_mod = caster:AddNewModifier(caster, self, "modifier_monkey_king_boundless_strike_custom_crit", {crit = crit})
local no_cleave = caster:AddNewModifier(caster, self, "modifier_tidehunter_anchor_smash_caster", {})

local enemies = FindUnitsInLine(self:GetCaster():GetTeamNumber(), vStartPosition , vTargetPosition, nil, strike_radius,  DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE)


for _,enemy in pairs(enemies) do

  if caster:HasModifier("modifier_monkey_king_boundless_6") then 
    enemy:AddNewModifier(caster, self, "modifier_monkey_king_boundless_strike_custom_heal", {duration = self:GetCaster():GetTalentValue("modifier_monkey_king_boundless_6", "duration")})
  end

  local particleID = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_strike_slow_impact.vpcf", PATTACH_CUSTOMORIGIN, nil)
  ParticleManager:SetParticleControlEnt(particleID, 0, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
  ParticleManager:ReleaseParticleIndex(particleID)

  enemy:AddNewModifier(caster, self, "modifier_stunned", {duration = (1 - enemy:GetStatusResistance())*self.stun})
  caster:PerformAttack(enemy, true, true, true, true, true, false, true)

end

if crit_mod then 
  crit_mod:Destroy()
end
if no_cleave then 
  no_cleave:Destroy()
end


local jingu_mod = caster:FindModifierByName("modifier_monkey_king_jingu_mastery_custom_buff")

if jingu_mod then 
  jingu_mod:DecrementStackCount()
  if jingu_mod:GetStackCount() <= 0 then 
    jingu_mod:Destroy()
  end
end

if not double and caster:HasModifier("modifier_monkey_king_boundless_5") then 

  local illusion_self = CreateIllusions(self:GetCaster(), self:GetCaster(), {
      outgoing_damage = 0,
      duration    = self:GetCaster():GetTalentValue("modifier_monkey_king_boundless_5", "delay") + 1 
      }, 1, 0, false, false)
      

  for _,illusion in pairs(illusion_self) do
    illusion.owner = caster
    FindClearSpaceForUnit(illusion, vTargetPosition, false)
    illusion:StartGesture(ACT_DOTA_VICTORY)
    illusion:AddNewModifier(illusion, nil, "modifier_monkey_king_boundless_strike_custom_anim", {})

    illusion:AddNewModifier(self:GetCaster(), self, "modifier_monkey_king_boundless_strike_custom_double_illusion", 
    {
      crit = more_crit
    })
  end

end

local ability = caster:FindAbilityByName("monkey_king_wukongs_command_custom") 
if ability and ability:GetLevel() > 0 and caster:HasModifier("modifier_monkey_king_command_4") then 
  ability:SpawnMonkeyKingPointScepter(vTargetPosition, self:GetCaster():GetTalentValue("modifier_monkey_king_command_4", "duration"), true)
end


if self:GetAutoCastState() == true and not double then 

  caster:EmitSound("MK.Mastery_legendary")
  local point = start_point + vDirection:Normalized()*(strike_cast_range)
  local distance = (point - caster:GetAbsOrigin()):Length2D()
  local dir = (point - caster:GetAbsOrigin()):Normalized()
  distance = math.min(strike_cast_range, distance)



  local arc = self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_generic_arc",
    { 
    dir_x = dir.x,
    dir_y = dir.y,
    distance = distance,
    speed = 3000,
    height = 150,
    fix_end = true,
    isStun = true,
    isForward = true,
    activity =  ACT_DOTA_MK_SPRING_SOAR,
    effect = "particles/units/heroes/hero_monkey_king/monkey_king_jump_trail.vpcf",
  })

  arc:SetEndCallback( function( interrupted )
      caster:StartGesture(ACT_DOTA_MK_STRIKE_END)

      local ability = caster:FindAbilityByName("monkey_king_primal_spring_custom")

      if ability and ability:IsTrained() then 
        ability:DealDamage(caster:GetAbsOrigin(), self:GetSpecialValueFor("shard_damage")/100)
      end 

    end)
end

end















modifier_monkey_king_boundless_strike_custom_crit = class({})

function modifier_monkey_king_boundless_strike_custom_crit:OnCreated(table)
if not IsServer() then return end
  self.crit = table.crit
end

 
function modifier_monkey_king_boundless_strike_custom_crit:DeclareFunctions() 
return 
{
    MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
} 
end

function modifier_monkey_king_boundless_strike_custom_crit:GetModifierPreAttack_CriticalStrike()
  return self.crit
end

function modifier_monkey_king_boundless_strike_custom_crit:GetCritDamage()
  return self.crit
end

function modifier_monkey_king_boundless_strike_custom_crit:IsHidden()
  return true
end










monkey_king_boundless_strike_end_custom = class({})

function monkey_king_boundless_strike_end_custom:OnSpellStart()
if not IsServer() then return end


local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, -1, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, 0, false )
   
for _,unit in pairs(units) do 

  if unit:HasModifier("modifier_monkey_king_boundless_strike_custom_legendary") then 
    unit:FindModifierByName("modifier_monkey_king_boundless_strike_custom_legendary").activated = true
    unit:FindModifierByName("modifier_monkey_king_boundless_strike_custom_legendary"):Activate_Strike()

  end
end

end










modifier_monkey_king_boundless_strike_custom_legendary = class({})
function modifier_monkey_king_boundless_strike_custom_legendary:IsHidden() return false end
function modifier_monkey_king_boundless_strike_custom_legendary:IsPurgable() return false end

function modifier_monkey_king_boundless_strike_custom_legendary:GetStatusEffectName() return "particles/status_fx/status_effect_monkey_king_fur_army.vpcf" end


function modifier_monkey_king_boundless_strike_custom_legendary:StatusEffectPriority()
    return 10010
end
function modifier_monkey_king_boundless_strike_custom_legendary:OnDestroy()

end

function modifier_monkey_king_boundless_strike_custom_legendary:OnCreated(table)
if not IsServer() then return end


self.interval = self:GetCaster():GetTalentValue("modifier_monkey_king_boundless_7", "interval")
self.delay_time = self:GetCaster():GetTalentValue("modifier_monkey_king_boundless_7", "delay")


self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_monkey_king_boundless_strike_custom_legendary_anim", {duration = self:GetCaster():GetTalentValue("modifier_monkey_king_boundless_7", "delay")})

self.activated = false
self:StartIntervalThink(self.delay_time)
self.delay = true 
self.more_crit = 0


end

function modifier_monkey_king_boundless_strike_custom_legendary:OnIntervalThink()
if not IsServer() then return end

if self.delay == true then 
  self:Activate_Strike()
else 
  self:GetParent():FadeGesture(ACT_DOTA_MK_STRIKE)

  if self.pre_particleID ~= nil then
    ParticleManager:DestroyParticle(self.pre_particleID, true)
    self.pre_particleID = nil
  end

  self:GetCaster():FindAbilityByName("monkey_king_boundless_strike_custom"):Strike(self:GetParent():GetAbsOrigin(), self.end_point, self:GetCaster(), self.more_crit)


  self:GetParent():Kill(nil, nil)
  self:StartIntervalThink(-1)
end



end


function modifier_monkey_king_boundless_strike_custom_legendary:Activate_Strike()
if not IsServer() then return end
if self.delay == false then return end
if not self:GetCaster() then return end

local strike_cast_range = self:GetAbility():GetSpecialValueFor("strike_cast_range")


if self:GetCaster():HasModifier("modifier_monkey_king_boundless_3") then 
  strike_cast_range = strike_cast_range + self:GetCaster():GetTalentValue("modifier_monkey_king_boundless_3", "range")
end


local units_creeps = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, strike_cast_range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
local units_heroes = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, strike_cast_range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO,  DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )


local units = units_creeps 

if #units_heroes > 0 then 
  units = units_heroes
end 


local dir 

if #units == 0 then 
  dir = self:GetParent():GetForwardVector()
  self.end_point = self:GetParent():GetAbsOrigin() + dir*strike_cast_range
else 


  self.end_point = units[1]:GetAbsOrigin()

  if units[1]:IsMoving() then 
    self.end_point = self.end_point + units[1]:GetForwardVector()*100
  end 

  dir = (self.end_point - self:GetParent():GetAbsOrigin()):Normalized()
  dir.z = 0

end 



self:GetParent():FaceTowards(self.end_point)
self:GetParent():SetForwardVector(dir)

self:GetCaster():SwapAbilities("monkey_king_boundless_strike_end_custom", "monkey_king_boundless_strike_custom", false, true)

self:GetParent():RemoveModifierByName("modifier_monkey_king_boundless_strike_custom_anim")
self:GetParent():FadeGesture(ACT_DOTA_VICTORY)

local cast = self:GetCaster():GetTalentValue("modifier_monkey_king_boundless_7", "cast")

self:GetParent():StartGestureWithPlaybackRate(ACT_DOTA_MK_STRIKE, 0.4/cast)
self:StartIntervalThink(cast)
self:GetParent():RemoveModifierByName("modifier_monkey_king_boundless_strike_custom_legendary_anim")
local caster = self:GetParent()

caster:EmitSound("Hero_MonkeyKing.Strike.Cast")

local damage = self:GetCaster():GetTalentValue("modifier_monkey_king_boundless_7", "damage")/(self.delay_time/self.interval)
local cd = self:GetCaster():GetTalentValue("modifier_monkey_king_boundless_7", "cd")/(self.delay_time/self.interval)
self.more_cd = cd*(self:GetElapsedTime()/self.interval)


self.more_crit = damage*(self:GetElapsedTime()/self.interval)
self:GetAbility():EndCooldown()
self:GetAbility():UseResources(false, false, false, true)
self:GetCaster():CdAbility(self:GetAbility(), self:GetAbility():GetCooldownTimeRemaining()*self.more_cd/100)

if self.activated == false then 

  local particle = ParticleManager:CreateParticle("particles/pangolier/buckle_refresh.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster())
  ParticleManager:SetParticleControlEnt( particle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetOrigin(), true )
  ParticleManager:ReleaseParticleIndex(particle)

  self:GetCaster():EmitSound("Hero_Rattletrap.Overclock.Cast")
end


self.pre_particleID = ParticleManager:CreateParticle("particles/monkey_king/cast_legendary.vpcf", PATTACH_POINT_FOLLOW, caster)
ParticleManager:SetParticleControl(self.pre_particleID, 0, caster:GetAbsOrigin())
ParticleManager:SetParticleControlEnt(self.pre_particleID, 1, caster, PATTACH_POINT_FOLLOW, "attach_weapon_bot", caster:GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(self.pre_particleID, 2, caster, PATTACH_POINT_FOLLOW, "attach_weapon_top", caster:GetAbsOrigin(), true)
ParticleManager:ReleaseParticleIndex(self.pre_particleID)

self.delay = false
end




function modifier_monkey_king_boundless_strike_custom_legendary:DeclareFunctions()
return
{
  MODIFIER_EVENT_ON_DEATH
}
end


function modifier_monkey_king_boundless_strike_custom_legendary:OnDeath(params)
if not IsServer() then return end
if self:GetCaster() ~= params.unit then return end

if self:GetCaster():FindAbilityByName("monkey_king_boundless_strike_custom"):IsHidden() then 
  self:GetCaster():SwapAbilities("monkey_king_boundless_strike_end_custom", "monkey_king_boundless_strike_custom", false, true)
end

self:GetParent():Kill(nil, nil)
end

function modifier_monkey_king_boundless_strike_custom_legendary:CheckState()
return
{
  [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
  [MODIFIER_STATE_NO_HEALTH_BAR] = true,
  [MODIFIER_STATE_STUNNED] = true,
  [MODIFIER_STATE_INVULNERABLE] = true,
  [MODIFIER_STATE_UNSELECTABLE] = true,
}
end


modifier_monkey_king_boundless_strike_custom_legendary_anim = class({})

function modifier_monkey_king_boundless_strike_custom_legendary_anim:IsHidden() return true end 
function modifier_monkey_king_boundless_strike_custom_legendary_anim:IsPurgable() return false end
function modifier_monkey_king_boundless_strike_custom_legendary_anim:OnCreated(table)
if not IsServer() then return end
  self.t = -1
  self.timer = table.duration*2 
  self:StartIntervalThink(0.5)
  self:OnIntervalThink()
end


function modifier_monkey_king_boundless_strike_custom_legendary_anim:OnIntervalThink()
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

local particleName = "particles/units/heroes/hero_alchemist/alchemist_unstable_concoction_timer.vpcf"
local particle = ParticleManager:CreateParticle(particleName, PATTACH_OVERHEAD_FOLLOW, caster)
ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin())
ParticleManager:SetParticleControl(particle, 1, Vector(0, int, decimal))
ParticleManager:SetParticleControl(particle, 2, Vector(digits, 0, 0))
ParticleManager:ReleaseParticleIndex(particle)

end









modifier_monkey_king_boundless_strike_custom_double_illusion = class({})
function modifier_monkey_king_boundless_strike_custom_double_illusion:IsHidden() return false end
function modifier_monkey_king_boundless_strike_custom_double_illusion:IsPurgable() return false end
function modifier_monkey_king_boundless_strike_custom_double_illusion:GetStatusEffectName() return "particles/status_fx/status_effect_monkey_king_fur_army.vpcf" end
function modifier_monkey_king_boundless_strike_custom_double_illusion:StatusEffectPriority()
    return 10010
end


function modifier_monkey_king_boundless_strike_custom_double_illusion:OnCreated(table)
if not IsServer() then return end

self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_monkey_king_boundless_strike_custom_legendary_anim", {duration = self:GetCaster():GetTalentValue("modifier_monkey_king_boundless_5", "delay")})

self:StartIntervalThink(self:GetCaster():GetTalentValue("modifier_monkey_king_boundless_5", "delay"))
self.delay = true 
self.more_crit = table.crit


end

function modifier_monkey_king_boundless_strike_custom_double_illusion:OnIntervalThink()
if not IsServer() then return end

if self.delay == true then 
  self:GetParent():FaceTowards(self:GetCaster():GetAbsOrigin())
  self:GetParent():SetForwardVector((self:GetCaster():GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Normalized())
  self.point = self:GetCaster():GetAbsOrigin()
  self:Activate_Strike()
else 
  self:GetParent():FadeGesture(ACT_DOTA_MK_STRIKE)

  if self.pre_particleID ~= nil then
    ParticleManager:DestroyParticle(self.pre_particleID, true)
    self.pre_particleID = nil
  end

  if self:GetCaster() and self:GetCaster():IsAlive() then 

    self:GetCaster():FindAbilityByName("monkey_king_boundless_strike_custom"):Strike(self:GetParent():GetAbsOrigin(), self.point, self:GetCaster(), self.more_crit, true)
  end

  self:GetParent():Kill(nil, nil)
  self:StartIntervalThink(-1)
end



end


function modifier_monkey_king_boundless_strike_custom_double_illusion:Activate_Strike()
if not IsServer() then return end
if self.delay == false then return end

self:GetParent():RemoveModifierByName("modifier_monkey_king_boundless_strike_custom_anim")
self:GetParent():FadeGesture(ACT_DOTA_VICTORY)
self:GetParent():StartGesture(ACT_DOTA_MK_STRIKE)
self:StartIntervalThink(0.4)
self:GetParent():RemoveModifierByName("modifier_monkey_king_boundless_strike_custom_legendary_anim")
local caster = self:GetParent()

caster:EmitSound("Hero_MonkeyKing.Strike.Cast")


self.pre_particleID = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_strike_cast.vpcf", PATTACH_POINT_FOLLOW, caster)
ParticleManager:SetParticleControl(self.pre_particleID, 0, caster:GetAbsOrigin())
ParticleManager:SetParticleControlEnt(self.pre_particleID, 1, caster, PATTACH_POINT_FOLLOW, "attach_weapon_bot", caster:GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(self.pre_particleID, 2, caster, PATTACH_POINT_FOLLOW, "attach_weapon_top", caster:GetAbsOrigin(), true)
ParticleManager:ReleaseParticleIndex(self.pre_particleID)

self.delay = false
end


function modifier_monkey_king_boundless_strike_custom_double_illusion:DeclareFunctions()
return
{
  MODIFIER_EVENT_ON_DEATH
}
end


function modifier_monkey_king_boundless_strike_custom_double_illusion:OnDeath(params)
if not IsServer() then return end
if self:GetCaster() ~= params.unit then return end

  self:GetParent():Kill(nil, nil)
end


function modifier_monkey_king_boundless_strike_custom_double_illusion:CheckState()
return
{
  [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
  [MODIFIER_STATE_NO_HEALTH_BAR] = true,
  [MODIFIER_STATE_STUNNED] = true,
  [MODIFIER_STATE_INVULNERABLE] = true,
  [MODIFIER_STATE_UNTARGETABLE] = true,
  [MODIFIER_STATE_UNSELECTABLE] = true,
}
end












modifier_monkey_king_boundless_strike_custom_attack = class({})
function modifier_monkey_king_boundless_strike_custom_attack:IsHidden() 
  return self:GetParent():HasModifier("modifier_monkey_king_boundless_strike_custom_attack_cd")
end
function modifier_monkey_king_boundless_strike_custom_attack:IsPurgable() return false end
function modifier_monkey_king_boundless_strike_custom_attack:RemoveOnDeath() return false end
function modifier_monkey_king_boundless_strike_custom_attack:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
  MODIFIER_EVENT_ON_ATTACK_LANDED,
  MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
}
end


function modifier_monkey_king_boundless_strike_custom_attack:OnCreated(table)

self.attack_range = self:GetCaster():GetTalentValue("modifier_monkey_king_boundless_4", "range")
self.duration = self:GetCaster():GetTalentValue("modifier_monkey_king_boundless_4", "duration")
self.cd = self:GetCaster():GetTalentValue("modifier_monkey_king_boundless_4", "cd")

if not IsServer() then return end
self:StartIntervalThink(0.2)
end

function modifier_monkey_king_boundless_strike_custom_attack:GetModifierAttackRangeBonus()
if self:GetParent():HasModifier("modifier_monkey_king_boundless_strike_custom_attack_cd") then 
  return 0
else 
  return self.attack_range
end

end


function modifier_monkey_king_boundless_strike_custom_attack:OnIntervalThink()
if not IsServer() then return end
local unit = self:GetParent()


if not self:GetParent():HasModifier("modifier_monkey_king_boundless_strike_custom_attack_cd") 
  and not self:GetParent():HasModifier("modifier_monkey_king_boundless_strike_custom_attack_anim") 
  and self:GetParent():IsAlive() then 

    self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_monkey_king_boundless_strike_custom_attack_anim", {})

end

if self:GetParent():HasModifier("modifier_monkey_king_boundless_strike_custom_attack_cd") 
  and self:GetParent():HasModifier("modifier_monkey_king_boundless_strike_custom_attack_anim") then 
  self:GetParent():RemoveModifierByName("modifier_monkey_king_boundless_strike_custom_attack_anim")
end



end





function modifier_monkey_king_boundless_strike_custom_attack:GetActivityTranslationModifiers(params)
if self:GetParent():HasModifier("modifier_monkey_king_boundless_strike_custom_attack_cd") then return end
  return "iron_cudgel_charged_attack"
end

function modifier_monkey_king_boundless_strike_custom_attack:GetTexture() return "buffs/boundless_attack" end
function modifier_monkey_king_boundless_strike_custom_attack:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent():HasModifier("modifier_monkey_king_boundless_strike_custom_attack_cd") then return end
if self:GetParent():HasModifier("modifier_monkey_king_boundless_strike_custom_crit") then return end
if self:GetParent() ~= params.attacker then return end

if not params.target:IsBuilding() then 
  params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_monkey_king_boundless_strike_custom_attack_armor", {duration = self.duration})
  params.target:EmitSound("MK.Strike_hit")
  local hit_effect = ParticleManager:CreateParticle("particles/mk_armor_hit.vpcf", PATTACH_ABSORIGIN_FOLLOW, params.target)
  ParticleManager:SetParticleControl(hit_effect, 1, params.target:GetAbsOrigin())
  ParticleManager:ReleaseParticleIndex(hit_effect)
end

self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_monkey_king_boundless_strike_custom_attack_cd", {duration = self.cd})
end








modifier_monkey_king_boundless_strike_custom_attack_anim = class({})
function modifier_monkey_king_boundless_strike_custom_attack_anim:IsHidden() return true end
function modifier_monkey_king_boundless_strike_custom_attack_anim:IsPurgable() return false end
function modifier_monkey_king_boundless_strike_custom_attack_anim:RemoveOnDeath() return false end
function modifier_monkey_king_boundless_strike_custom_attack_anim:OnCreated(table)
if not IsServer() then return end
local unit = self:GetParent()

self:GetParent():EmitSound("MK.Strike_hit_ready")

self.particle = ParticleManager:CreateParticle("particles/boundless_attack.vpcf", PATTACH_ABSORIGIN, unit)
ParticleManager:SetParticleControlEnt(self.particle, 0, unit, PATTACH_POINT_FOLLOW, "attach_weapon_top", unit:GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(self.particle, 2, unit, PATTACH_POINT_FOLLOW, "attach_weapon_top", unit:GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(self.particle, 3, unit, PATTACH_POINT_FOLLOW, "attach_weapon_bot", unit:GetAbsOrigin(), true)
self:AddParticle(self.particle,true,false,0,false,false)
end



modifier_monkey_king_boundless_strike_custom_attack_cd = class({})
function modifier_monkey_king_boundless_strike_custom_attack_cd:IsHidden() return false end
function modifier_monkey_king_boundless_strike_custom_attack_cd:IsPurgable() return false end
function modifier_monkey_king_boundless_strike_custom_attack_cd:RemoveOnDeath() return false end
function modifier_monkey_king_boundless_strike_custom_attack_cd:IsDebuff() return true end
function modifier_monkey_king_boundless_strike_custom_attack_cd:OnCreated(table)
self.RemoveForDuel = true 
end
function modifier_monkey_king_boundless_strike_custom_attack_cd:GetTexture() return "buffs/boundless_attack" end



modifier_monkey_king_boundless_strike_custom_attack_armor = class({})
function modifier_monkey_king_boundless_strike_custom_attack_armor:IsHidden() return false end
function modifier_monkey_king_boundless_strike_custom_attack_armor:IsPurgable() return false end
function modifier_monkey_king_boundless_strike_custom_attack_armor:GetTexture() return "buffs/boundless_attack" end
function modifier_monkey_king_boundless_strike_custom_attack_armor:GetStatusEffectName()
  return "particles/status_fx/status_effect_huskar_lifebreak.vpcf"
end

function modifier_monkey_king_boundless_strike_custom_attack_armor:OnCreated(table)

self.armor = self:GetParent():GetPhysicalArmorValue(false)*self:GetCaster():GetTalentValue("modifier_monkey_king_boundless_4", "armor")/100
self.move = self:GetCaster():GetTalentValue("modifier_monkey_king_boundless_4", "slow")

if not IsServer() then return end
self.particle_peffect = ParticleManager:CreateParticle("particles/items3_fx/star_emblem.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent()) 
ParticleManager:SetParticleControl(self.particle_peffect, 0, self:GetParent():GetAbsOrigin())
self:AddParticle(self.particle_peffect, false, false, -1, false, true)
end

function modifier_monkey_king_boundless_strike_custom_attack_armor:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
  MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
}
end

function modifier_monkey_king_boundless_strike_custom_attack_armor:GetModifierPhysicalArmorBonus()
return self.armor
end

function modifier_monkey_king_boundless_strike_custom_attack_armor:GetModifierMoveSpeedBonus_Percentage()
return self.move
end


modifier_monkey_king_boundless_strike_custom_damage_bonus = class({})
function modifier_monkey_king_boundless_strike_custom_damage_bonus:IsHidden() return false end
function modifier_monkey_king_boundless_strike_custom_damage_bonus:IsPurgable() return false end
function modifier_monkey_king_boundless_strike_custom_damage_bonus:GetTexture() return "buffs/acorn_armor" end
function modifier_monkey_king_boundless_strike_custom_damage_bonus:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
}
end
function modifier_monkey_king_boundless_strike_custom_damage_bonus:GetModifierPreAttack_BonusDamage()
return self.damage
end


function modifier_monkey_king_boundless_strike_custom_damage_bonus:OnCreated()
  self.damage = self:GetCaster():GetTalentValue("modifier_monkey_king_boundless_2", "damage")
end 

modifier_monkey_king_boundless_strike_custom_heal = class({})
function modifier_monkey_king_boundless_strike_custom_heal:IsHidden() return false end
function modifier_monkey_king_boundless_strike_custom_heal:IsPurgable() return false end
function modifier_monkey_king_boundless_strike_custom_heal:GetTexture() return "buffs/boundless_heal" end
function modifier_monkey_king_boundless_strike_custom_heal:DeclareFunctions()
return
{
  MODIFIER_EVENT_ON_TAKEDAMAGE,
  MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
  MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
  MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE
}
end


function modifier_monkey_king_boundless_strike_custom_heal:OnCreated(table)

self.heal_reduction = self:GetCaster():GetTalentValue("modifier_monkey_king_boundless_6", "heal_reduce")
self.heal = self:GetCaster():GetTalentValue("modifier_monkey_king_boundless_6", "heal")/100
self.heal_creeps = self:GetCaster():GetTalentValue("modifier_monkey_king_boundless_6", "heal_creeps")

if not IsServer() then return end

self.particle = ParticleManager:CreateParticle("particles/mk_heal_red_1.vpcf", PATTACH_POINT_FOLLOW, self:GetParent())
ParticleManager:SetParticleControlEnt(self.particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
self:AddParticle(self.particle, false, false, -1, false, false)
end

function modifier_monkey_king_boundless_strike_custom_heal:GetModifierLifestealRegenAmplify_Percentage() 
  return self.heal_reduction
end

function modifier_monkey_king_boundless_strike_custom_heal:GetModifierHealAmplify_PercentageTarget()
  return self.heal_reduction
end

function modifier_monkey_king_boundless_strike_custom_heal:GetModifierHPRegenAmplify_Percentage() 
  return self.heal_reduction
end

function modifier_monkey_king_boundless_strike_custom_heal:OnTakeDamage(params)
if not IsServer() then return end
if params.unit ~= self:GetParent() then return end
if self:GetCaster() ~= params.attacker then return end
if bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then return end

local heal = self.heal *params.damage
if params.unit:IsCreep() then 
  heal = heal/self.heal_creeps
end

self:GetCaster():GenericHeal(heal, self:GetAbility())
end



modifier_monkey_king_boundless_strike_custom_anim = class({})
function modifier_monkey_king_boundless_strike_custom_anim:IsHidden() return false end
function modifier_monkey_king_boundless_strike_custom_anim:IsPurgable() return false end
function modifier_monkey_king_boundless_strike_custom_anim:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_OVERRIDE_ANIMATION
}
end

function modifier_monkey_king_boundless_strike_custom_anim:GetOverrideAnimation()
return ACT_DOTA_VICTORY
end