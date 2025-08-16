LinkLuaModifier("modifier_custom_juggernaut_blade_dance", "abilities/juggernaut/custom_juggernaut_blade_dance.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_blade_dance_buff", "abilities/juggernaut/custom_juggernaut_blade_dance.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_blade_dance_legendary", "abilities/juggernaut/custom_juggernaut_blade_dance.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_blade_dance_legendary_run", "abilities/juggernaut/custom_juggernaut_blade_dance.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_blade_dance_agi", "abilities/juggernaut/custom_juggernaut_blade_dance.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_blade_dance_anim", "abilities/juggernaut/custom_juggernaut_blade_dance.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_blade_dance_damage_reduce", "abilities/juggernaut/custom_juggernaut_blade_dance.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_blade_dance_blink_attack", "abilities/juggernaut/custom_juggernaut_blade_dance.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_blade_dance_blink_cd", "abilities/juggernaut/custom_juggernaut_blade_dance.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_blade_dance_blink_slow", "abilities/juggernaut/custom_juggernaut_blade_dance.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_blade_dance_speed", "abilities/juggernaut/custom_juggernaut_blade_dance.lua", LUA_MODIFIER_MOTION_NONE)



custom_juggernaut_blade_dance = class({})


function custom_juggernaut_blade_dance:CreateTalent()

self:ToggleAutoCast()
self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_custom_juggernaut_blade_dance_blink_cd", {})
end

function custom_juggernaut_blade_dance:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end

PrecacheResource( "particle", "particles/units/heroes/hero_mars/mars_shield_bash_crit_strike.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_mars/mars_shield_bash_crit_strike.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_mars/mars_shield_bash.vpcf", context )
PrecacheResource( "particle", "particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_v2_trigger.vpcf", context )
PrecacheResource( "particle", "particles/jugger_legendary.vpcf", context )
PrecacheResource( "particle", "particles/lc_lowhp.vpcf", context )

PrecacheResource( "particle", "particles/bloodseeker/thirst_cleave.vpcf", context )
PrecacheResource( "particle", "particles/status_fx/status_effect_huskar_lifebreak.vpcf", context )
PrecacheResource( "particle", "particles/jugg_omni_proc.vpcf", context )
PrecacheResource( "particle", "particles/jugger_stack.vpcf", context )
PrecacheResource( "particle", "particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_v2_omni_slash_trail.vpcf", context )
PrecacheResource( "particle", "particles/econ/events/ti10/blink_dagger_start_ti10_lvl2_sparkles.vpcf", context )
PrecacheResource( "particle", "particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_v2_omni_dash.vpcf", context )
PrecacheResource( "particle", "particles/items2_fx/sange_maim.vpcf", context )

end




function custom_juggernaut_blade_dance:GetIntrinsicModifierName() 
return "modifier_custom_juggernaut_blade_dance" 
end


function custom_juggernaut_blade_dance:GetAbilityTextureName()
if self:GetCaster():HasModifier("modifier_juggernaut_bladekeeper_weapon") then
    return "juggernaut/bladekeeper/juggernaut_blade_dance"
end
if self:GetCaster():HasModifier("modifier_juggernaut_arcana") or self:GetCaster():HasModifier("modifier_juggernaut_arcana_v2") then
    return "juggernaut_blade_dance_arcana"
end
return "juggernaut_blade_dance"
end


function custom_juggernaut_blade_dance:GetBehavior()
local auto = 0

if self:GetCaster():HasTalent("modifier_juggernaut_bladedance_5") then 
  auto = DOTA_ABILITY_BEHAVIOR_AUTOCAST
end 

if self:GetCaster():HasTalent("modifier_juggernaut_bladedance_7") then
  return DOTA_ABILITY_BEHAVIOR_NO_TARGET + auto
end

return DOTA_ABILITY_BEHAVIOR_PASSIVE + auto
end


function custom_juggernaut_blade_dance:GetCooldown(iLevel)
if self:GetCaster():HasTalent("modifier_juggernaut_bladedance_7") then 
  return self:GetCaster():GetTalentValue("modifier_juggernaut_bladedance_7", "cd")
end 

end

function custom_juggernaut_blade_dance:OnAbilityPhaseStart( )
self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_custom_juggernaut_blade_dance_anim", {})
self:GetCaster():StartGesture(ACT_DOTA_ATTACK_EVENT)
return true 
end

function custom_juggernaut_blade_dance:OnAbilityPhaseInterrupted()

self:GetCaster():FadeGesture(ACT_DOTA_ATTACK_EVENT)
self:GetCaster():RemoveModifierByName("modifier_custom_juggernaut_blade_dance_anim")
end



function custom_juggernaut_blade_dance:OnSpellStart()

self:GetCaster():RemoveModifierByName("modifier_custom_juggernaut_blade_dance_anim")

self:GetCaster():EmitSound("Hero_Juggernaut.ArcanaTrigger")
local sound_cast = "Juggernaut.ShockWave"
self:GetCaster():EmitSound(sound_cast)

local range = self:GetCaster():GetTalentValue("modifier_juggernaut_bladedance_7", "range")
local stun = self:GetCaster():GetTalentValue("modifier_juggernaut_bladedance_7", "stun")

local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(),self:GetCaster():GetOrigin(), nil, range, DOTA_UNIT_TARGET_TEAM_ENEMY,  DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,   0,  false )

local origin = self:GetCaster():GetOrigin()
local cast_direction = (self:GetCaster():GetAbsOrigin() + self:GetCaster():GetForwardVector()*range - origin):Normalized()
local cast_angle = VectorToAngles( cast_direction ).y
local angle = 140 / 2

for _,enemy in pairs(enemies) do
  local enemy_direction = (enemy:GetOrigin() - origin):Normalized()
  local enemy_angle = VectorToAngles( enemy_direction ).y
  local angle_diff = math.abs( AngleDiff( cast_angle, enemy_angle ) )

  if angle_diff <= angle and not enemy:IsMagicImmune() then

    enemy:EmitSound("BB.Warpath_proc")
    enemy:AddNewModifier(self:GetCaster(), self, "modifier_bashed", {duration = stun*(1 - enemy:GetStatusResistance())})

    local effect = ParticleManager:CreateParticle( "particles/units/heroes/hero_mars/mars_shield_bash_crit_strike.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy )
    ParticleManager:SetParticleControl( effect, 0, enemy:GetOrigin() )
    ParticleManager:SetParticleControl( effect, 1, enemy:GetOrigin() )
    ParticleManager:SetParticleControlForward( effect, 1, (enemy:GetOrigin() - self:GetCaster():GetAbsOrigin()):Normalized() )
    ParticleManager:ReleaseParticleIndex( effect )

  end
end

local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_mars/mars_shield_bash.vpcf", PATTACH_WORLDORIGIN, self:GetCaster() )
ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
ParticleManager:SetParticleControl( effect_cast, 1, Vector(range,range,range) )
ParticleManager:SetParticleControlForward( effect_cast, 0, cast_direction )
ParticleManager:ReleaseParticleIndex( effect_cast )

self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_custom_juggernaut_blade_dance_legendary", {duration = self:GetCaster():GetTalentValue("modifier_juggernaut_bladedance_7", "duration")})
end



modifier_custom_juggernaut_blade_dance_anim = class({})
function modifier_custom_juggernaut_blade_dance_anim:IsHidden() return true end
function modifier_custom_juggernaut_blade_dance_anim:IsPurgable() return false end
function modifier_custom_juggernaut_blade_dance_anim:DeclareFunctions() return { MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS } end
function modifier_custom_juggernaut_blade_dance_anim:GetActivityTranslationModifiers() return "ti8" end







modifier_custom_juggernaut_blade_dance_legendary = class({})

function modifier_custom_juggernaut_blade_dance_legendary:IsHidden() return false end
function modifier_custom_juggernaut_blade_dance_legendary:IsPurgable() return false end
function modifier_custom_juggernaut_blade_dance_legendary:GetTexture() return "buffs/Blade_dance_legendary" end
function modifier_custom_juggernaut_blade_dance_legendary:CheckState() return {[MODIFIER_STATE_SILENCED] = true} end
function modifier_custom_juggernaut_blade_dance_legendary:OnCreated(table)
self.anim = "ti8"
self.RemoveForDuel = true

self.status = self:GetCaster():GetTalentValue("modifier_juggernaut_bladedance_7", "status")
if not IsServer() then return end

local trail_pfx = ParticleManager:CreateParticle("particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_v2_trigger.vpcf", PATTACH_ABSORIGIN, self:GetParent())
ParticleManager:ReleaseParticleIndex(trail_pfx)
self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_juggernaut_blade_dance_legendary_run", {duration = self:GetRemainingTime()})
end


function modifier_custom_juggernaut_blade_dance_legendary:DeclareFunctions()
return
{ 
  MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
  MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
  MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING
}
end

function modifier_custom_juggernaut_blade_dance_legendary:GetModifierStatusResistanceStacking() 
return self.status
end

function modifier_custom_juggernaut_blade_dance_legendary:GetModifierProcAttack_Feedback(params)
if not IsServer() then return end 
if self:GetParent() ~= params.attacker then return end 
if not params.target:IsUnit() then return end 

if self.anim == "ti8" then 
  self.anim = "favor"
else 
  self.anim = "ti8"
end

end

function modifier_custom_juggernaut_blade_dance_legendary:GetActivityTranslationModifiers() 
return self.anim
end

function modifier_custom_juggernaut_blade_dance_legendary:GetEffectName() return "particles/jugger_legendary.vpcf" end




modifier_custom_juggernaut_blade_dance_legendary_run = class({})
function modifier_custom_juggernaut_blade_dance_legendary_run:IsHidden() return true end
function modifier_custom_juggernaut_blade_dance_legendary_run:IsPurgable() return false end
function modifier_custom_juggernaut_blade_dance_legendary_run:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
} 
end

function modifier_custom_juggernaut_blade_dance_legendary_run:GetActivityTranslationModifiers() return "chase" end










modifier_custom_juggernaut_blade_dance = class({})


function modifier_custom_juggernaut_blade_dance:IsHidden() return true end
function modifier_custom_juggernaut_blade_dance:IsPurgable() return false end

function modifier_custom_juggernaut_blade_dance:GetCritDamage()
return self:GetAbility():GetSpecialValueFor("damage") + self:GetCaster():GetTalentValue("modifier_juggernaut_bladedance_2","damage")
end
 
function modifier_custom_juggernaut_blade_dance:DeclareFunctions() 
return 
{
  MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
  MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
  MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
} 
end


function modifier_custom_juggernaut_blade_dance:GetModifierAttackRangeBonus()
if not self:GetParent():HasTalent("modifier_juggernaut_bladedance_3") then return end 
return self:GetCaster():GetTalentValue("modifier_juggernaut_bladedance_3", "range")
end 




function modifier_custom_juggernaut_blade_dance:OnCreated(table)
self.chance = self:GetAbility():GetSpecialValueFor("chance")
self.damage = self:GetAbility():GetSpecialValueFor("damage")
self.target = nil
self.record = nil

self.caster = self:GetCaster()
    
self.speed_duration = self:GetCaster():GetTalentValue("modifier_juggernaut_bladedance_2", "duration", true)

self.slow_duration = self:GetCaster():GetTalentValue("modifier_juggernaut_bladedance_1", "duration", true)

self.blink_cd = self:GetCaster():GetTalentValue("modifier_juggernaut_bladedance_5", "cd_inc", true)

self.bonus_chance = self:GetCaster():GetTalentValue("modifier_juggernaut_bladedance_6", "chance", true)
self.heal = self:GetCaster():GetTalentValue("modifier_juggernaut_bladedance_6", "heal", true)/100
self.heal_health = self:GetCaster():GetTalentValue("modifier_juggernaut_bladedance_6", "health", true)
self.heal_bonus = self:GetCaster():GetTalentValue("modifier_juggernaut_bladedance_6", "bonus", true)

self.agi_duration = self:GetCaster():GetTalentValue("modifier_juggernaut_bladedance_4", "duration", true)

if self.caster:IsRealHero() then 
  self.caster:AddDamageEvent_out(self)
end 

self:StartIntervalThink(1)
end


function modifier_custom_juggernaut_blade_dance:OnRefresh()
self.chance = self:GetAbility():GetSpecialValueFor("chance")
self.damage = self:GetAbility():GetSpecialValueFor("damage")
end



function modifier_custom_juggernaut_blade_dance:OnIntervalThink()
if not IsServer() then return end 
if not self.caster:HasTalent("modifier_juggernaut_bladedance_6") then return end 

if not self.particle and self.caster:GetHealthPercent() <= self.heal_health then 

  self.caster:EmitSound("Lc.Moment_Lowhp")
  self.particle = ParticleManager:CreateParticle( "particles/lc_lowhp.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.caster )
  ParticleManager:SetParticleControl( self.particle, 0, self.caster:GetAbsOrigin() )
  ParticleManager:SetParticleControl( self.particle, 1, self.caster:GetAbsOrigin() )
  ParticleManager:SetParticleControl( self.particle, 2, self.caster:GetAbsOrigin() )  
end 

if self.particle and self.caster:GetHealthPercent() > self.heal_health then 

  ParticleManager:DestroyParticle(self.particle, false)
  ParticleManager:ReleaseParticleIndex(self.particle)
  self.particle = nil
end 

self:StartIntervalThink(0.1)
end 



function modifier_custom_juggernaut_blade_dance:GetModifierPreAttack_CriticalStrike( params )
if not IsServer() then return end
if self.caster:PassivesDisabled() then return end
if params.target:GetTeamNumber()==self.caster:GetTeamNumber() then return end

self.record = nil
local chance = self.chance

if self.caster:HasTalent("modifier_juggernaut_bladedance_6") then 
  local bonus = self.bonus_chance

  if self.caster:GetHealthPercent() <= self.heal_health then 
    bonus = bonus*self.heal_bonus
  end 

  chance = chance + bonus
end 
  
if self.caster:HasModifier("modifier_custom_juggernaut_blade_dance_legendary") or RollPseudoRandomPercentage(chance,1392,self.caster) then
  self.record = params.record
  return self.damage + self:GetCaster():GetTalentValue("modifier_juggernaut_bladedance_2","damage")
end

end


function modifier_custom_juggernaut_blade_dance:GetModifierProcAttack_Feedback( params )
if not IsServer() then return end
if not params.target:IsUnit() then return end
if not params.target or params.target:IsNull() then return end  


if self.caster:HasTalent("modifier_juggernaut_bladedance_4") then 
  self.caster:AddNewModifier(self.caster, self:GetAbility(), "modifier_custom_juggernaut_blade_dance_agi", { duration = self.agi_duration})
end

if not self.record or self.record ~= params.record then return end

params.target:EmitSound("Hero_Juggernaut.BladeDance")

if self:GetCaster():HasModifier("modifier_juggernaut_bladeform") then
  local crit_start = ParticleManager:CreateParticle("particles/econ/items/juggernaut/armor_of_the_favorite/juggernaut_armor_of_the_favorite_crit.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
  ParticleManager:ReleaseParticleIndex(crit_start)
end

if self.caster:HasModifier("modifier_juggernaut_arcana") then
  local particle_crit = ParticleManager:CreateParticle("particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_crit_tgt.vpcf", PATTACH_ABSORIGIN_FOLLOW, params.target)
  ParticleManager:SetParticleControlEnt(particle_crit, 1, params.target, PATTACH_ABSORIGIN_FOLLOW, nil, params.target:GetAbsOrigin(), true)
  ParticleManager:ReleaseParticleIndex(particle_crit)
  params.target:EmitSound("Hero_Juggernaut.BladeDance.Arcana")
elseif self.caster:HasModifier("modifier_juggernaut_arcana_v2") then
  local particle_crit = ParticleManager:CreateParticle("particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_v2_crit_tgt.vpcf", PATTACH_ABSORIGIN_FOLLOW, params.target)
  ParticleManager:SetParticleControlEnt(particle_crit, 1, params.target, PATTACH_ABSORIGIN_FOLLOW, nil, params.target:GetAbsOrigin(), true)
  ParticleManager:ReleaseParticleIndex(particle_crit)
  params.target:EmitSound("Hero_Juggernaut.BladeDance.Arcana")
end

if self.caster:HasTalent("modifier_juggernaut_bladedance_4") then 
  self.caster:AddNewModifier(self.caster, self:GetAbility(), "modifier_custom_juggernaut_blade_dance_agi", { duration = self.agi_duration})
end


if self.caster:HasTalent("modifier_juggernaut_bladedance_3") then 
  DoCleaveAttack(self.caster, params.target, nil, params.damage * self.caster:GetTalentValue("modifier_juggernaut_bladedance_3", "cleave")/100 , 150, 360, 650, "particles/bloodseeker/thirst_cleave.vpcf" )
end

local mod = self.caster:FindModifierByName("modifier_custom_juggernaut_blade_dance_blink_cd")

if mod and mod:GetStackCount() > 0 then 
  mod:SetStackCount(math.max(0, mod:GetStackCount() + self.blink_cd) )
end 

if (self.caster:GetQuest() == "Jugg.Quest_6") and params.target:IsRealHero() then 
  self.caster:UpdateQuest(1)
end

if self.caster:HasTalent("modifier_juggernaut_bladedance_2") then 
  self.caster:AddNewModifier(self.caster, self:GetAbility(), "modifier_custom_juggernaut_blade_dance_speed", { duration = self.speed_duration})
end

if self.caster:HasTalent("modifier_juggernaut_bladedance_1") then 
  params.target:AddNewModifier(self.caster, self:GetAbility(), "modifier_custom_juggernaut_blade_dance_damage_reduce", { duration = self.slow_duration})
end
       
      
end

function modifier_custom_juggernaut_blade_dance:DamageEvent_out(params)
if not IsServer() then return end 
if not self.caster:HasTalent("modifier_juggernaut_bladedance_6") then return end 
if self.caster ~= params.attacker then return end 
if not params.unit:IsUnit() then return end
if not params.record then return end 
if params.record ~= self.record then return end
if params.inflictor then return end

local heal = params.damage*self.heal
if self.caster:GetHealthPercent() <= self.heal_health then 
  heal = heal*self.heal_bonus
end 

self.caster:GenericHeal(heal, self:GetAbility(), nil, nil, "modifier_juggernaut_bladedance_6")
end 







modifier_custom_juggernaut_blade_dance_agi = class({})

function modifier_custom_juggernaut_blade_dance_agi:IsHidden() return false end
function modifier_custom_juggernaut_blade_dance_agi:IsPurgable() return false end
function modifier_custom_juggernaut_blade_dance_agi:GetTexture() return  "buffs/Omnislash_cd" end
function modifier_custom_juggernaut_blade_dance_agi:OnCreated(table)

self.agi =  self:GetCaster():GetTalentValue("modifier_juggernaut_bladedance_4", "agi")
self.max =  self:GetCaster():GetTalentValue("modifier_juggernaut_bladedance_4", "max")

if not IsServer() then return end
self:SetStackCount(1)
end 

function modifier_custom_juggernaut_blade_dance_agi:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end 
self:IncrementStackCount()

end 

function modifier_custom_juggernaut_blade_dance_agi:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_STATS_AGILITY_BONUS
}
end


function modifier_custom_juggernaut_blade_dance_agi:GetModifierBonusStats_Agility()
return self:GetStackCount()*self.agi
end
















modifier_custom_juggernaut_blade_dance_blink_slow = class({})
function modifier_custom_juggernaut_blade_dance_blink_slow:IsHidden() return true end
function modifier_custom_juggernaut_blade_dance_blink_slow:IsPurgable() return true end

function modifier_custom_juggernaut_blade_dance_blink_slow:GetStatusEffectName()
return "particles/status_fx/status_effect_huskar_lifebreak.vpcf"
end

function modifier_custom_juggernaut_blade_dance_blink_slow:OnCreated()
self.slow = self:GetCaster():GetTalentValue("modifier_juggernaut_bladedance_5", "slow")
end


function modifier_custom_juggernaut_blade_dance_blink_slow:DeclareFunctions()
return 
{
  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
}
end


function modifier_custom_juggernaut_blade_dance_blink_slow:GetModifierMoveSpeedBonus_Percentage()
return self.slow
end









modifier_custom_juggernaut_blade_dance_blink_attack = class({})
function modifier_custom_juggernaut_blade_dance_blink_attack:IsHidden() return true end
function modifier_custom_juggernaut_blade_dance_blink_attack:IsPurgable() return false end
function modifier_custom_juggernaut_blade_dance_blink_attack:GetTexture() return "buffs/back_taunt" end

function modifier_custom_juggernaut_blade_dance_blink_attack:OnCreated(table)

self.duration = self:GetCaster():GetTalentValue("modifier_juggernaut_bladedance_5", "duration", true)
self.range = self:GetCaster():GetTalentValue("modifier_juggernaut_bladedance_5", "range", true)
self.cd = self:GetCaster():GetTalentValue("modifier_juggernaut_bladedance_5", "cd", true)

if not IsServer() then return end

local effect_cast = ParticleManager:CreateParticle( "particles/jugg_omni_proc.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetAbsOrigin() )
ParticleManager:ReleaseParticleIndex( effect_cast )

self:GetParent():EmitSound("Juggernaut.Omni_cd")

self.parent = self:GetParent()
self.parent:AddAttackRecordEvent_out(self)
self.parent:AddAttackFailEvent_out(self)
end

function modifier_custom_juggernaut_blade_dance_blink_attack:GetModifierAttackRangeBonus()
if self:GetParent():HasModifier("modifier_custom_juggernaut_blade_fury") then return end
if not IsServer() then 
  return self.range
end

if self:GetAbility():GetAutoCastState() == false then return end
return self.range
end


function modifier_custom_juggernaut_blade_dance_blink_attack:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
  MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
}
end

function modifier_custom_juggernaut_blade_dance_blink_attack:AttackRecordEvent_out(params)
if not self:GetParent():IsRealHero() then return end
if self:GetParent():HasModifier("modifier_custom_juggernaut_blade_fury") then return end
if self:GetAbility():GetAutoCastState() == false then return end
if self:GetParent() ~= params.attacker then return end

self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_ATTACK_EVENT, self:GetParent():GetDisplayAttackSpeed() / 100)
end 


function modifier_custom_juggernaut_blade_dance_blink_attack:GetModifierProcAttack_Feedback(params)
if not IsServer() then return end
if self:GetParent():HasModifier("modifier_custom_juggernaut_blade_fury") then return end
if self:GetAbility():GetAutoCastState() == false then return end
if self.parent ~= params.attacker then return end
if params.no_attack_cooldown then return end

self:Blink(params.target)
end

function modifier_custom_juggernaut_blade_dance_blink_attack:AttackFailEvent_out(params)
if not IsServer() then return end
if self:GetParent():HasModifier("modifier_custom_juggernaut_blade_fury") then return end
if self:GetAbility():GetAutoCastState() == false then return end
if self.parent ~= params.attacker then return end
if params.no_attack_cooldown then return end

self:Blink(params.target)
end


function modifier_custom_juggernaut_blade_dance_blink_attack:Blink(target)
if not IsServer() then return end
if self.blinked then return end

self.blinked = true

target:AddNewModifier(self.parent, self:GetAbility(), "modifier_custom_juggernaut_blade_dance_blink_slow", {duration = (1 - target:GetStatusResistance())*self.duration})

local particle = ParticleManager:CreateParticle("particles/jugger_stack.vpcf", PATTACH_ABSORIGIN_FOLLOW, target )
ParticleManager:SetParticleControl( particle, 2, target:GetAbsOrigin() + Vector(0,0,-100)  )
ParticleManager:SetParticleControl( particle, 3, target:GetAbsOrigin() )
ParticleManager:ReleaseParticleIndex(particle)

local position1 = self:GetParent():GetAbsOrigin()
local position2 = target:GetAbsOrigin()
local dir = (position2 - position1):Normalized()

if target:IsBuilding() then 
  dir = dir*-1
end 

position2 = position2 + dir*130

local particle2 = ParticleManager:CreateParticle("particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_v2_omni_slash_trail.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(particle2, 0, position1)
ParticleManager:SetParticleControl(particle2, 1, position2)
ParticleManager:ReleaseParticleIndex(particle2)

local particle3 = ParticleManager:CreateParticle("particles/econ/events/ti10/blink_dagger_start_ti10_lvl2_sparkles.vpcf", PATTACH_WORLDORIGIN, nil )
ParticleManager:SetParticleControl( particle3, 0, self:GetParent():GetAbsOrigin()  )
ParticleManager:ReleaseParticleIndex(particle3)

local hParent = self:GetCaster()

local vDirection = position2 - hParent:GetAbsOrigin()
vDirection.z = 0

local iParticleID = ParticleManager:CreateParticle("particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_v2_omni_dash.vpcf", PATTACH_CUSTOMORIGIN, hParent)
ParticleManager:SetParticleControl(iParticleID, 0, hParent:GetAbsOrigin())
ParticleManager:SetParticleControlForward(iParticleID, 0, -vDirection:Normalized())
ParticleManager:SetParticleControl(iParticleID, 1, position2)
ParticleManager:SetParticleControl(iParticleID, 2, position2)
ParticleManager:ReleaseParticleIndex(iParticleID)

self:GetParent():EmitSound("Juggernaut.Stack")
self:GetParent():EmitSound("Hero_Juggernaut.OmniSlash")
self:GetParent():SetAbsOrigin(position2)
FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetAbsOrigin(), false)

local new_dir = (target:GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Normalized()
new_dir.z = 0
self:GetParent():SetForwardVector(new_dir)
self:GetParent():FaceTowards(self:GetParent():GetAbsOrigin() + new_dir*10)

local mod = self:GetParent():FindModifierByName("modifier_custom_juggernaut_blade_dance_blink_cd")
if mod then 
  mod:SetStackCount(self.cd)
end 

self:Destroy()
end 



modifier_custom_juggernaut_blade_dance_blink_cd = class({})
function modifier_custom_juggernaut_blade_dance_blink_cd:IsHidden() return true end
function modifier_custom_juggernaut_blade_dance_blink_cd:IsPurgable() return false end
function modifier_custom_juggernaut_blade_dance_blink_cd:IsDebuff() return true end
function modifier_custom_juggernaut_blade_dance_blink_cd:RemoveOnDeath() return false end
function modifier_custom_juggernaut_blade_dance_blink_cd:GetTexture() return "buffs/back_taunt" end
function modifier_custom_juggernaut_blade_dance_blink_cd:OnCreated(table)
self.parent = self:GetParent()
self.max = self.parent:GetTalentValue("modifier_juggernaut_bladedance_5", "cd")
if not IsServer() then return end

self:SetStackCount(0)

self:StartIntervalThink(FrameTime())
end


function modifier_custom_juggernaut_blade_dance_blink_cd:OnIntervalThink()
if not IsServer() then return end 

if self:GetStackCount() <= 0 then 
  if not self.parent:HasModifier("modifier_custom_juggernaut_blade_dance_blink_attack") then 
    self.parent:AddNewModifier(self.parent, self:GetAbility(), "modifier_custom_juggernaut_blade_dance_blink_attack", {})
  end 
else 
  self:DecrementStackCount()
end 

end 




function modifier_custom_juggernaut_blade_dance_blink_cd:OnStackCountChanged(iStackCount)
if not IsServer() then return end 

local stack = self.max - self:GetStackCount()
self.parent:UpdateUIlong({max = self.max, stack = stack, style = "JuggernautDance", override_stack = self:GetStackCount(), hide_number = stack >= self.max, no_min = true})

if self:GetStackCount() <= 0 then 
  self:StartIntervalThink(FrameTime())
else 
  self:StartIntervalThink(1)
end 

end





modifier_custom_juggernaut_blade_dance_damage_reduce = class({})
function modifier_custom_juggernaut_blade_dance_damage_reduce:IsHidden() return true end
function modifier_custom_juggernaut_blade_dance_damage_reduce:IsPurgable() return true end
function modifier_custom_juggernaut_blade_dance_damage_reduce:OnCreated()
self.slow = self:GetCaster():GetTalentValue("modifier_juggernaut_bladedance_1", "slow")
self.damage = self:GetCaster():GetTalentValue("modifier_juggernaut_bladedance_1", "damage")

if not IsServer() then return end 
self:GetParent():EmitSound("DOTA_Item.Maim")
end 

function modifier_custom_juggernaut_blade_dance_damage_reduce:GetEffectName()
return "particles/items2_fx/sange_maim.vpcf"
end


function modifier_custom_juggernaut_blade_dance_damage_reduce:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
  MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}

end

function modifier_custom_juggernaut_blade_dance_damage_reduce:GetModifierDamageOutgoing_Percentage()
return self.damage
end

function modifier_custom_juggernaut_blade_dance_damage_reduce:GetModifierSpellAmplify_Percentage()
return self.damage
end

function modifier_custom_juggernaut_blade_dance_damage_reduce:GetModifierMoveSpeedBonus_Percentage()
return self.slow
end



modifier_custom_juggernaut_blade_dance_speed = class({})
function modifier_custom_juggernaut_blade_dance_speed:IsHidden() return false end
function modifier_custom_juggernaut_blade_dance_speed:IsPurgable() return false end
function modifier_custom_juggernaut_blade_dance_speed:GetTexture() return "buffs/Blade_dance_speed" end
function modifier_custom_juggernaut_blade_dance_speed:OnCreated()
self.damage =  self:GetCaster():GetTalentValue("modifier_juggernaut_bladedance_2", "bonus_damage")
self.max =  self:GetCaster():GetTalentValue("modifier_juggernaut_bladedance_2", "max")

if not IsServer() then return end
self:SetStackCount(1)
end 

function modifier_custom_juggernaut_blade_dance_speed:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end 
self:IncrementStackCount()

end 

function modifier_custom_juggernaut_blade_dance_speed:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
}
end


function modifier_custom_juggernaut_blade_dance_speed:GetModifierPreAttack_BonusDamage() 
return self:GetStackCount()*self.damage
end



