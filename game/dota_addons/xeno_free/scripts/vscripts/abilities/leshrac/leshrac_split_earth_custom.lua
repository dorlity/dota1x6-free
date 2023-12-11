LinkLuaModifier( "modifier_leshrac_split_earth_custom", "abilities/leshrac/leshrac_split_earth_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_leshrac_split_earth_custom_magic", "abilities/leshrac/leshrac_split_earth_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_leshrac_split_earth_custom_charge", "abilities/leshrac/leshrac_split_earth_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_leshrac_split_earth_custom_tracker", "abilities/leshrac/leshrac_split_earth_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_leshrac_split_earth_custom_legendary_aoe", "abilities/leshrac/leshrac_split_earth_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_leshrac_split_earth_custom_legendary_cd", "abilities/leshrac/leshrac_split_earth_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_leshrac_split_earth_custom_legendary_stack", "abilities/leshrac/leshrac_split_earth_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_leshrac_split_earth_custom_shard", "abilities/leshrac/leshrac_split_earth_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_leshrac_split_earth_custom_heal", "abilities/leshrac/leshrac_split_earth_custom", LUA_MODIFIER_MOTION_NONE )

leshrac_split_earth_custom = class({})

leshrac_split_earth_custom.range_stun = {0.2, 0.3, 0.4}
leshrac_split_earth_custom.range_radius = {25, 50, 75}

leshrac_split_earth_custom.resist_duration = 5
leshrac_split_earth_custom.resist_magic = {4, 6, 8}

leshrac_split_earth_custom.cast_point = -0.3
leshrac_split_earth_custom.cast_cd = 2

leshrac_split_earth_custom.charge_speed = 1250
leshrac_split_earth_custom.charge_distance = 200






function leshrac_split_earth_custom:Precache(context)

PrecacheResource( "particle", "particles/units/heroes/hero_leshrac/leshrac_split_earth_aoe.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_keeper_of_the_light/keeper_chakra_magic.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_leshrac/leshrac_split_earth.vpcf", context )
PrecacheResource( "particle", "particles/zeus_resist_stack.vpcf", context )
PrecacheResource( "particle", "particles/items_fx/ogre_seal_totem_trail.vpcf", context )
PrecacheResource( "particle", "particles/falcon_blade_charge.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_primal_beast/primal_beast_onslaught_charge_active.vpcf", context )
PrecacheResource( "particle", "particles/leshrac_earth_legendary.vpcf", context )
PrecacheResource( "particle", "particles/leshrac_earth_legendary_stun.vpcf", context )
PrecacheResource( "particle", "particles/leshrac_stack.vpcf", context )

end







function leshrac_split_earth_custom:GetIntrinsicModifierName()
return "modifier_leshrac_split_earth_custom_tracker"
end



function leshrac_split_earth_custom:GetAOERadius()
local bonus = 0
if self:GetCaster():HasModifier("modifier_leshrac_earth_1") then 
  bonus = self.range_radius[self:GetCaster():GetUpgradeStack("modifier_leshrac_earth_1")]
end

  return self:GetSpecialValueFor( "radius" ) + bonus
end



function leshrac_split_earth_custom:GetManaCost(iLevel)

if self:GetCaster():HasModifier("modifier_leshrac_nova_5") then 
  return self:GetCaster():FindAbilityByName("leshrac_pulse_nova_custom").spells_cost
end

return self.BaseClass.GetManaCost(self, iLevel)
end


function leshrac_split_earth_custom:GetBehavior()
if self:GetCaster():HasModifier("modifier_leshrac_earth_5") then 
  return DOTA_ABILITY_BEHAVIOR_AOE + DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AUTOCAST
end

return DOTA_ABILITY_BEHAVIOR_AOE + DOTA_ABILITY_BEHAVIOR_POINT
end


function leshrac_split_earth_custom:GetCastPoint()

local bonus = 0
if self:GetCaster():HasModifier("modifier_leshrac_earth_6") then 
  bonus = self.cast_point
end

return self.BaseClass.GetCastPoint(self) + bonus
end


function leshrac_split_earth_custom:GetCastRange(vLocation, hTarget)

local upgrade = 0
if self:GetCaster():HasModifier("modifier_leshrac_earth_5") then 
  upgrade = self.charge_distance
end
return self.BaseClass.GetCastRange(self , vLocation , hTarget) + upgrade 
end




function leshrac_split_earth_custom:GetStunDamage(target)
if not IsServer() then return end

local damage = self:GetAbilityDamage()

local mod = target:FindModifierByName("modifier_leshrac_split_earth_custom_legendary_stack")

if mod then 
  damage = damage  + self:GetCaster():GetTalentValue("modifier_leshrac_earth_4","damage")*mod:GetStackCount()
end


return damage
end



function leshrac_split_earth_custom:OnSpellStart()

local caster = self:GetCaster()
local point = self:GetCursorPosition()

local delay = self:GetSpecialValueFor("delay")


if self:GetCaster():HasModifier("modifier_leshrac_earth_5") and self:GetAutoCastState() == true then 

  local distance = (point - self:GetCaster():GetAbsOrigin()):Length2D()
  local speed = self.charge_speed
  local height = 0

  caster:EmitSound("Leshrac.Earth_run_start")

  local mod = caster:AddNewModifier(caster, self, "modifier_leshrac_split_earth_custom_charge", {})

  local arc = caster:AddNewModifier(caster, self, "modifier_generic_arc",
    {
      target_x = point.x,
      target_y = point.y,
      distance = distance,
      speed = speed,
      height = height,
      fix_end = false,
      isStun = true,
      activity = ACT_DOTA_RUN,
      end_anim = ACT_DOTA_CAST_ABILITY_4,
    })

  arc:SetEndCallback(function()
    caster:RemoveModifierByName("modifier_leshrac_split_earth_custom_charge")
  end)

  delay = distance/speed

end


CreateModifierThinker( caster, self, "modifier_leshrac_split_earth_custom", {active = 1, duration = delay, shard = 0 }, point, caster:GetTeamNumber(), false)
end




function leshrac_split_earth_custom:LegendaryStun()
if not IsServer() then return end

local aoe = self:GetCaster():GetTalentValue("modifier_leshrac_earth_7", "aoe")

local enemies_creeps = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), nil, aoe, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, 0, 0, false)
local enemies_heroes = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), nil, aoe, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, 0, false)

local enemy = nil
local point
if #enemies_creeps > 0 then 
  enemy = enemies_creeps[1]
end

if #enemies_heroes > 0 then 
  enemy = enemies_heroes[1]
end

if enemy ~= nil then 

  point = GetGroundPosition(enemy:GetAbsOrigin(), nil)

  if enemy:IsMoving() then 
    point = point + enemy:GetForwardVector()*100
  end

else 
  point = self:GetCaster():GetAbsOrigin() + RandomVector(RandomInt(1, aoe))
end

CreateModifierThinker( self:GetCaster(), self, "modifier_leshrac_split_earth_custom_legendary_aoe", {duration = self:GetCaster():GetTalentValue("modifier_leshrac_earth_7", "delay")}, point, self:GetCaster():GetTeamNumber(), false)
end







modifier_leshrac_split_earth_custom = class({})


function modifier_leshrac_split_earth_custom:IsHidden()
  return true
end

function modifier_leshrac_split_earth_custom:IsPurgable()
  return false
end



function modifier_leshrac_split_earth_custom:OnCreated( kv )
if not IsServer() then return end

self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
self.radius = self:GetAbility():GetSpecialValueFor( "radius" )




if kv.radius then 
  self.radius = kv.radius
end

self.active = kv.active
  
if self:GetCaster():HasModifier("modifier_leshrac_earth_1") then 
  self.duration = self.duration + self:GetAbility().range_stun[self:GetCaster():GetUpgradeStack("modifier_leshrac_earth_1")]
  self.radius = self.radius + self:GetAbility().range_radius[self:GetCaster():GetUpgradeStack("modifier_leshrac_earth_1")]
end


if kv.shard == 1 then 
  local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_leshrac/leshrac_split_earth_aoe.vpcf", PATTACH_WORLDORIGIN, nil )
  ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
  ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, 0, 0 ) )
  ParticleManager:ReleaseParticleIndex( effect_cast )
end


self.damageTable = { attacker = self:GetCaster(),  damage_type = self:GetAbility():GetAbilityDamageType(), ability = self:GetAbility(), }
end



function modifier_leshrac_split_earth_custom:OnDestroy()
if not IsServer() then return end

local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)

for _,enemy in pairs(enemies) do

  if self:GetCaster():HasModifier("modifier_leshrac_earth_2") then 
    enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_leshrac_split_earth_custom_magic", {duration = self:GetAbility().resist_duration})
  end


  local duration = self.duration


  if (self:GetCaster():GetQuest() == "Leshrac.Quest_5") and enemy:IsRealHero() then 
    self:GetCaster():UpdateQuest(1)
  end


  enemy:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_stunned", { duration = duration*(1 - enemy:GetStatusResistance()) } )
  self.damageTable.victim = enemy

  self.damageTable.damage = self:GetAbility():GetStunDamage(enemy)

  ApplyDamage( self.damageTable )
end

if self:GetCaster():HasModifier("modifier_leshrac_earth_3") and #enemies > 0 then 

  self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(),  "modifier_leshrac_split_earth_custom_heal", {duration = self:GetCaster():GetTalentValue("modifier_leshrac_earth_3", "duration")})

  self:GetCaster():EmitSound("Puck.Rift_Mana")

  local mana_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_keeper_of_the_light/keeper_chakra_magic.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
  ParticleManager:SetParticleControl(mana_particle, 0, self:GetCaster():GetAbsOrigin())
  ParticleManager:SetParticleControl(mana_particle, 1, self:GetCaster():GetAbsOrigin())
  ParticleManager:ReleaseParticleIndex(mana_particle)

end


if self:GetCaster():HasShard() and self.active == 1 then 
  CreateModifierThinker( self:GetCaster(), self:GetAbility(), "modifier_leshrac_split_earth_custom", {duration = self:GetAbility():GetSpecialValueFor("shard_delay"), radius = self.radius + self:GetAbility():GetSpecialValueFor("shard_radius"), shard = 1, active = 0}, self:GetParent():GetAbsOrigin(), self:GetCaster():GetTeamNumber(), false)
end



if self:GetCaster():HasModifier("modifier_leshrac_earth_6") and self.active == 1 and #enemies == 0 then 
  local cd = self:GetAbility():GetCooldownTimeRemaining()
  self:GetAbility():EndCooldown()
  self:GetAbility():StartCooldown(cd - self:GetAbility().cast_cd)
end 

self:PlayEffects()

UTIL_Remove( self:GetParent() )
end


function modifier_leshrac_split_earth_custom:PlayEffects()

local particle_cast = "particles/units/heroes/hero_leshrac/leshrac_split_earth.vpcf"
local sound_cast = "Hero_Leshrac.Split_Earth"

local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, self.radius, self.radius ) )
ParticleManager:ReleaseParticleIndex( effect_cast )

EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), sound_cast, self:GetCaster() )
end






modifier_leshrac_split_earth_custom_magic = class({})
function modifier_leshrac_split_earth_custom_magic:IsHidden() return false end
function modifier_leshrac_split_earth_custom_magic:IsPurgable() return true end
function modifier_leshrac_split_earth_custom_magic:GetTexture() return "buffs/earth_magic" end
function modifier_leshrac_split_earth_custom_magic:OnCreated(table)
if not IsServer() then return end
  self.particle_peffect = ParticleManager:CreateParticle("particles/zeus_resist_stack.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())   
  ParticleManager:SetParticleControl(self.particle_peffect, 0, self:GetParent():GetAbsOrigin())
  self:AddParticle(self.particle_peffect, false, false, -1, false, true)
end



function modifier_leshrac_split_earth_custom_magic:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
}
end

function modifier_leshrac_split_earth_custom_magic:GetModifierIncomingDamage_Percentage()
return self:GetAbility().resist_magic[self:GetCaster():GetUpgradeStack("modifier_leshrac_earth_2")]
end




modifier_leshrac_split_earth_custom_charge = class({})
function modifier_leshrac_split_earth_custom_charge:IsHidden() return true end
function modifier_leshrac_split_earth_custom_charge:IsPurgable() return false end
function modifier_leshrac_split_earth_custom_charge:GetStatusEffectName() return "particles/status_fx/status_effect_forcestaff.vpcf" end
function modifier_leshrac_split_earth_custom_charge:StatusEffectPriority() return 100 end

function modifier_leshrac_split_earth_custom_charge:OnCreated(table)
if not IsServer() then return end

self.particle_peffect = ParticleManager:CreateParticle("particles/items_fx/ogre_seal_totem_trail.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())   
self:AddParticle(self.particle_peffect, false, false, -1, false, true)

self.particle_peffect1 = ParticleManager:CreateParticle("particles/falcon_blade_charge.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())   
self:AddParticle(self.particle_peffect1, false, false, -1, false, true)

self.count = 0

self:GetParent():EmitSound("Leshrac.Earth_run")
self.targets = {}

self:StartIntervalThink(FrameTime())
end

function modifier_leshrac_split_earth_custom_charge:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
}
end

function modifier_leshrac_split_earth_custom_charge:GetActivityTranslationModifiers()
return "staff_run_haste"
end


function modifier_leshrac_split_earth_custom_charge:GetEffectName()
  return "particles/units/heroes/hero_primal_beast/primal_beast_onslaught_charge_active.vpcf"
end

function modifier_leshrac_split_earth_custom_charge:GetEffectAttachType()
  return PATTACH_ABSORIGIN_FOLLOW
end



function modifier_leshrac_split_earth_custom_charge:OnIntervalThink()
if not IsServer() then return end

self.count = self.count + FrameTime()
if self.count >= 0.35 then 
  ParticleManager:DestroyParticle(self.particle_peffect1, false)
  ParticleManager:ReleaseParticleIndex(self.particle_peffect1)
end


local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetOrigin(), nil, 150, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)

for _,enemy in pairs(enemies) do

  if  not self.targets[enemy] and enemy:GetUnitName() ~= "npc_teleport" 
    and not (enemy:IsCurrentlyHorizontalMotionControlled() or enemy:IsCurrentlyVerticalMotionControlled()) then

    self.targets[enemy] = true
    local direction = enemy:GetOrigin()-self:GetParent():GetOrigin()

    direction.z = 0
    direction = direction:Normalized()

    local knockbackProperties =
    {
        center_x = enemy:GetOrigin().x,
        center_y = enemy:GetOrigin().y,
        center_z = enemy:GetOrigin().z,
        duration = 0.4,
        knockback_duration = 0.4,
        knockback_distance = 50,
        knockback_height = 100
    }
    enemy:AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_knockback", knockbackProperties )
  end


end


end



modifier_leshrac_split_earth_custom_tracker = class({})
function modifier_leshrac_split_earth_custom_tracker:IsHidden() return true end
function modifier_leshrac_split_earth_custom_tracker:IsPurgable() return false end



function modifier_leshrac_split_earth_custom_tracker:DeclareFunctions()
return
{
  MODIFIER_EVENT_ON_TAKEDAMAGE,
  MODIFIER_EVENT_ON_ATTACK_LANDED,
  MODIFIER_EVENT_ON_ABILITY_EXECUTED
}
end

function modifier_leshrac_split_earth_custom_tracker:OnCreated(table)
if not IsServer() then return end

self.pos = self:GetCaster():GetAbsOrigin()
self.distance = 0
self.damage_count = 0

--self:StartIntervalThink(1)
end



function modifier_leshrac_split_earth_custom_tracker:OnAbilityExecuted( params )
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_leshrac_earth_4") then return end
if params.unit~=self:GetParent() then return end
if not params.ability then return end
if params.ability:IsItem() or params.ability:IsToggle() then return end
if UnvalidAbilities[params.ability:GetName()] then return end

local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetOrigin(), nil, self:GetCaster():GetTalentValue("modifier_leshrac_earth_4", "radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)

for _,enemy in pairs(enemies) do 
  enemy:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_leshrac_split_earth_custom_legendary_stack", {duration = self:GetCaster():GetTalentValue("modifier_leshrac_earth_4", "duration")})
end

end

function modifier_leshrac_split_earth_custom_tracker:OnAttackLanded(params)
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_leshrac_earth_4") then return end
if not params.target:IsHero() and not params.target:IsCreep() then return end
if params.target:IsMagicImmune() then return end
if params.attacker ~= self:GetParent() then return end

params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_leshrac_split_earth_custom_legendary_stack", {duration = self:GetCaster():GetTalentValue("modifier_leshrac_earth_4", "duration")})

end

function modifier_leshrac_split_earth_custom_tracker:OnTakeDamage(params)
if not IsServer() then return end
if not params.unit then return end
if self:GetParent() ~= params.attacker then return end
if not self:GetParent():HasModifier("modifier_leshrac_earth_7") then return end
if not params.unit:IsHero() and not params.unit:IsCreep() then return end
if self:GetCaster():HasModifier("modifier_leshrac_split_earth_custom_legendary_cd") then return end

local k = 1
if params.unit:IsCreep() then 
  k = self:GetCaster():GetTalentValue("modifier_leshrac_earth_7", "creeps")/100
end

self.damage_count = self.damage_count + params.damage*k

local max = self:GetCaster():GetTalentValue("modifier_leshrac_earth_7", "count")

if self.damage_count >= max then 
  self.damage_count = 0

  self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_leshrac_split_earth_custom_legendary_cd", {duration = self:GetCaster():GetTalentValue("modifier_leshrac_earth_7", "cd")})
  self:GetAbility():LegendaryStun()
end


end






modifier_leshrac_split_earth_custom_legendary_aoe = class({})
function modifier_leshrac_split_earth_custom_legendary_aoe:IsHidden() return false end
function modifier_leshrac_split_earth_custom_legendary_aoe:IsPurgable() return false end
function modifier_leshrac_split_earth_custom_legendary_aoe:OnCreated(table)

self.damage = self:GetCaster():GetTalentValue("modifier_leshrac_earth_7", "damage")/100
self.stun = self:GetCaster():GetTalentValue("modifier_leshrac_earth_7", "stun")

if not IsServer() then return end
self:GetParent():EmitSound("Leshrac.Earth_legendary_pre")

self.radius = self:GetCaster():GetTalentValue("modifier_leshrac_earth_7", "radius")

local effect_cast = ParticleManager:CreateParticle( "particles/leshrac_earth_legendary.vpcf", PATTACH_WORLDORIGIN, nil )
ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, 0, 0 ) )
ParticleManager:ReleaseParticleIndex( effect_cast )
self:AddParticle(effect_cast, false, false, -1, false, true)

end

function modifier_leshrac_split_earth_custom_legendary_aoe:OnDestroy()
if not IsServer() then return end

local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)

for _,enemy in pairs(enemies) do

    local duration = self.stun

    if (self:GetCaster():GetQuest() == "Leshrac.Quest_5") and enemy:IsRealHero() then 
      self:GetCaster():UpdateQuest(1)
    end

    local knockbackProperties =
    {
        center_x = enemy:GetOrigin().x,
        center_y = enemy:GetOrigin().y,
        center_z = enemy:GetOrigin().z,
        duration = duration*(1 - enemy:GetStatusResistance()),
        knockback_duration = duration,
        knockback_distance = 0,
        knockback_height = 150
    }

    ApplyDamage( { attacker = self:GetCaster(),victim = enemy,  damage = self:GetAbility():GetStunDamage(enemy)*self.damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self:GetAbility(), })

    enemy:AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_knockback", knockbackProperties )
end



local particle_cast = "particles/leshrac_earth_legendary_stun.vpcf"
local sound_cast = "Leshrac.Earth_legendary"

local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, self.radius, self.radius ) )
ParticleManager:ReleaseParticleIndex( effect_cast )

EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), sound_cast, self:GetCaster() )

end


modifier_leshrac_split_earth_custom_legendary_cd = class({})
function modifier_leshrac_split_earth_custom_legendary_cd:IsHidden() return true end
function modifier_leshrac_split_earth_custom_legendary_cd:IsPurgable() return false end



modifier_leshrac_split_earth_custom_legendary_stack = class({})
function modifier_leshrac_split_earth_custom_legendary_stack:IsHidden() return false end
function modifier_leshrac_split_earth_custom_legendary_stack:IsPurgable() return false end
function modifier_leshrac_split_earth_custom_legendary_stack:RemoveOnDeath() return false end
function modifier_leshrac_split_earth_custom_legendary_stack:GetTexture() return "buffs/earth_stack" end
function modifier_leshrac_split_earth_custom_legendary_stack:OnCreated(table)

self.max = self:GetCaster():GetTalentValue("modifier_leshrac_earth_4", "max")
self.damage = self:GetCaster():GetTalentValue("modifier_leshrac_earth_4", "damage")
self.status = self:GetCaster():GetTalentValue("modifier_leshrac_earth_4", "status")

if not IsServer() then return end

local particle_cast = "particles/leshrac_stack.vpcf"

self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_OVERHEAD_FOLLOW, self:GetParent() )

self:AddParticle(self.effect_cast,false, false, -1, false, false)

self:SetStackCount(1)
end


function modifier_leshrac_split_earth_custom_legendary_stack:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end

self:IncrementStackCount()

end




function modifier_leshrac_split_earth_custom_legendary_stack:OnStackCountChanged(iStackCount)
if self:GetStackCount() == 0 then return end

if self.effect_cast then 
   ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, self:GetStackCount(), 0 ) )
end


end







function modifier_leshrac_split_earth_custom_legendary_stack:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_TOOLTIP,
  MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING
}

end




function modifier_leshrac_split_earth_custom_legendary_stack:OnTooltip()
return self.damage*self:GetStackCount()
end


function modifier_leshrac_split_earth_custom_legendary_stack:GetModifierStatusResistanceStacking() 
if self:GetStackCount() < self.max then return end
return self.status
end








modifier_leshrac_split_earth_custom_heal = class({})
function modifier_leshrac_split_earth_custom_heal:IsHidden() return false end
function modifier_leshrac_split_earth_custom_heal:IsPurgable() return true end
function modifier_leshrac_split_earth_custom_heal:GetTexture() return "buffs/nova_damage" end

function modifier_leshrac_split_earth_custom_heal:OnCreated(table)
self.heal = self:GetCaster():GetTalentValue("modifier_leshrac_earth_3", "heal")/self:GetRemainingTime()
if not IsServer() then return end

self:StartIntervalThink(1)
end

function modifier_leshrac_split_earth_custom_heal:OnIntervalThink()
if not IsServer() then return end
local particle = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
ParticleManager:ReleaseParticleIndex( particle )
SendOverheadEventMessage(self:GetParent(), 10, self:GetParent(), self.heal*self:GetParent():GetMaxHealth()/100, nil)
end


function modifier_leshrac_split_earth_custom_heal:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE
}
end
function modifier_leshrac_split_earth_custom_heal:GetModifierHealthRegenPercentage()
return self.heal
end


