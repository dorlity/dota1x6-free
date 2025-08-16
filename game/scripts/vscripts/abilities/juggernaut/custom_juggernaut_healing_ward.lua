LinkLuaModifier("modifier_custom_juggernaut_healing_ward", "abilities/juggernaut/custom_juggernaut_healing_ward.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_healing_ward_aura", "abilities/juggernaut/custom_juggernaut_healing_ward.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_healing_ward_reduction_aura", "abilities/juggernaut/custom_juggernaut_healing_ward.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_healing_ward_reduction", "abilities/juggernaut/custom_juggernaut_healing_ward.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_healing_ward_buff", "abilities/juggernaut/custom_juggernaut_healing_ward.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_healing_ward_invun", "abilities/juggernaut/custom_juggernaut_healing_ward.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_healing_ward_damage_aura", "abilities/juggernaut/custom_juggernaut_healing_ward.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_healing_ward_tracker", "abilities/juggernaut/custom_juggernaut_healing_ward.lua", LUA_MODIFIER_MOTION_NONE)

 
custom_juggernaut_healing_ward = class({})




function custom_juggernaut_healing_ward:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end

PrecacheResource( "particle", "particles/juggernaut/ward_legendary.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_juggernaut/juggernaut_healing_ward.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_zuus/zuus_arc_lightning.vpcf", context )
PrecacheResource( "particle", "particles/juggernaut/ward_exlosion.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_oracle/oracle_false_promise_heal.vpcf", context )
PrecacheResource( "particle", "particles/items2_fx/refresher.vpcf", context )
PrecacheResource( "particle", "particles/juggernaut/ward_immune.vpcf", context )
PrecacheResource( "particle", "particles/juggernaut/ward_burn.vpcf", context )
PrecacheResource( "particle", "particles/jugger_ward_legend.vpcf", context )
PrecacheResource( "particle", "particles/jugg_ward_buff.vpcf", context )
PrecacheResource( "particle", "particles/status_fx/status_effect_mjollnir_shield.vpcf", context )
PrecacheResource( "particle", "particles/juggernaut/ward_invun.vpcf", context )

end



function custom_juggernaut_healing_ward:GetAbilityTextureName()
if self:GetCaster():HasModifier("modifier_juggernaut_fortunes_toat_golden_ward") then
    return "juggernaut/fortunes_tout_gold/juggernaut_healing_ward"
end
if self:GetCaster():HasModifier("modifier_juggernaut_fall_ward") then
    return "juggernaut_fall20_healingward"
end

if self:GetCaster():HasModifier("modifier_juggernaut_fortunes_toat_ward") then
    return "juggernaut/fortunes_tout/juggernaut_healing_ward"
end
if self:GetCaster():HasModifier("modifier_juggernaut_bladekeeper_weapon") then
    return "juggernaut/bladekeeper/juggernaut_healing_ward"
end
if self:GetCaster():HasModifier("modifier_juggernaut_arcana") or self:GetCaster():HasModifier("modifier_juggernaut_arcana_v2") then
    return "juggernaut_healing_ward_arcana"
end
return "juggernaut_healing_ward"

end

function custom_juggernaut_healing_ward:CreateTalent()
local caster = self:GetCaster()
local mod = caster:FindModifierByName("modifier_custom_juggernaut_healing_ward_tracker")
if mod then
  mod.PercentStr = caster:GetTalentValue("modifier_juggernaut_healingward_2", "str")/100
end


end

function custom_juggernaut_healing_ward:GetIntrinsicModifierName()
return "modifier_custom_juggernaut_healing_ward_tracker"
end


function custom_juggernaut_healing_ward:GetAOERadius()
return self:GetSpecialValueFor("radius")
end


function custom_juggernaut_healing_ward:GetCastPoint()

if self:GetCaster():HasTalent("modifier_juggernaut_healingward_5") then 
  return 0
end
return self:GetSpecialValueFor("AbilityCastPoint")
end


function custom_juggernaut_healing_ward:GetManaCost(iLevel)
if self:GetCaster():HasTalent("modifier_juggernaut_healingward_5") then 
  return 0
end
return self:GetSpecialValueFor("AbilityManaCost")
end




function custom_juggernaut_healing_ward:GetCooldown(iLevel)
local upgrade_cooldown = 0

if self:GetCaster():HasTalent("modifier_juggernaut_healingward_1") then 
  upgrade_cooldown = self:GetCaster():GetTalentValue("modifier_juggernaut_healingward_1", "cd")
end 
return self.BaseClass.GetCooldown(self, iLevel) + upgrade_cooldown 
end





function custom_juggernaut_healing_ward:OnSpellStart()
local caster = self:GetCaster()
self.duration = self:GetSpecialValueFor("duration")

self:SetActivated(false)
self:EndCooldown()

self.ward = CreateUnitByName("juggernaut_healing_ward", self:GetCursorPosition(), true, caster, caster, caster:GetTeamNumber())
self.ward:AddNewModifier(caster, self, "modifier_kill", {duration = self.duration})
self.ward:SetControllableByPlayer(caster:GetPlayerOwnerID(), true)

self.ward.owner = caster

Timers:CreateTimer(0.05, function()self.ward:MoveToNPC(caster) end)

self.ward:AddNewModifier(caster, self, "modifier_custom_juggernaut_healing_ward", {duration = self.duration})

if caster:HasTalent("modifier_juggernaut_healingward_7") then
  self.ward:AddNewModifier(caster, self, "modifier_custom_juggernaut_healing_ward_reduction", {})
end

if caster:HasTalent("modifier_juggernaut_healingward_5") then 
  self.ward:AddNewModifier(caster, self, "modifier_custom_juggernaut_healing_ward_invun", {duration = caster:GetTalentValue("modifier_juggernaut_healingward_5", "duration")})
end 

end




modifier_custom_juggernaut_healing_ward = class({})


function modifier_custom_juggernaut_healing_ward:OnCreated(table)

self.caster = self:GetCaster()
self.parent = self:GetParent()
self.parent:AddDeathEvent(self)

self.ability = self:GetAbility()

self.base_move = self.ability:GetSpecialValueFor("move") + self.caster:GetTalentValue("modifier_juggernaut_healingward_6", "move")

self.legendary_hits = self.caster:GetTalentValue("modifier_juggernaut_healingward_7", "hits", true)
self.legendary_damage = self.caster:GetTalentValue("modifier_juggernaut_healingward_7", "damage", true)/100
self.legendary_creeps = self.caster:GetTalentValue("modifier_juggernaut_healingward_7", "creeps", true)
self.health = self.legendary_hits

self.radius = self.ability:GetSpecialValueFor("radius")
self.aura_duration = self.ability:GetSpecialValueFor("aura_duration") + self.caster:GetTalentValue("modifier_juggernaut_healingward_5", "aura")

self.buff_duration = self.caster:GetTalentValue("modifier_juggernaut_healingward_4", "duration", true)

if not IsServer() then return end

self.caster:AddDamageEvent_out(self)
self.parent:AddAttackEvent_inc(self)

if self.caster:HasTalent("modifier_juggernaut_healingward_7") then 
  local effect_cast = ParticleManager:CreateParticle( "particles/juggernaut/ward_legendary.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
  ParticleManager:SetParticleControl( effect_cast, 0, self.parent:GetAbsOrigin()) 
  ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, 0, 1 ) )
  ParticleManager:SetParticleControl( effect_cast, 2, Vector( self:GetRemainingTime(), 0, 1 ) )
  self:AddParticle( effect_cast, false, false, -1, false, false )

end

self.sound = "Hero_Juggernaut.HealingWard.Loop"
local sound_cast = "Hero_Juggernaut.HealingWard.Cast"
self.sound_stop = "Hero_Juggernaut.HealingWard.Stop"

local particle_fx = "particles/units/heroes/hero_juggernaut/juggernaut_healing_ward.vpcf"
if self.caster:HasModifier("modifier_juggernaut_fortunes_toat_ward") then
  self.parent:SetModel("models/items/juggernaut/ward/fortunes_tout/fortunes_tout.vmdl")
  self.parent:SetOriginalModel("models/items/juggernaut/ward/fortunes_tout/fortunes_tout.vmdl")
  particle_fx = "particles/econ/items/juggernaut/jugg_fortunes_tout/jugg_healling_ward_fortunes_tout_ward.vpcf"
  self.sound = "Hero_Juggernaut.FortunesTout.Loop"
  sound_cast = "Hero_Juggernaut.FortunesTout.Cast"
  self.sound_stop = "Hero_Juggernaut.FortunesTout.Stop"
  self.parent:SetModelScale(0.85)
end

if self.caster:HasModifier("modifier_juggernaut_fortunes_toat_golden_ward") then
  self.parent:SetModel("models/items/juggernaut/ward/fortunes_tout/fortunes_tout.vmdl")
  self.parent:SetOriginalModel("models/items/juggernaut/ward/fortunes_tout/fortunes_tout.vmdl")
  self.parent:SetMaterialGroup("1")
  particle_fx = "particles/econ/items/juggernaut/jugg_fortunes_tout/jugg_healing_ward_fortunes_tout_gold.vpcf"
  self.sound = "Hero_Juggernaut.FortunesTout.Loop"
  sound_cast = "Hero_Juggernaut.FortunesTout.Cast"
  self.sound_stop = "Hero_Juggernaut.FortunesTout.Stop"
  self.parent:SetModelScale(0.85)
end
if self.caster:HasModifier("modifier_juggernaut_fall_ward") then
  self.parent:SetModel("models/items/juggernaut/ward/fall20_juggernaut_katz_ward/fall20_juggernaut_katz_ward.vmdl")
  self.parent:SetOriginalModel("models/items/juggernaut/ward/fall20_juggernaut_katz_ward/fall20_juggernaut_katz_ward.vmdl")
  particle_fx = "particles/econ/items/juggernaut/jugg_fall20_immortal/jugg_fall20_immortal_healing_ward.vpcf"

end
if self.caster:HasModifier("modifier_juggernaut_isle_of_dragons_ward") then
  self.parent:SetModel("models/items/juggernaut/ward/miyamoto_musash_ward/miyamoto_musash_ward.vmdl")
  self.parent:SetOriginalModel("models/items/juggernaut/ward/miyamoto_musash_ward/miyamoto_musash_ward.vmdl")
  self.parent:SetMaterialGroup("1")
end

if self.caster:HasModifier("modifier_juggernaut_isle_of_dragons_ward_2") then
  self.parent:SetModel("models/items/juggernaut/ward/miyamoto_musash_ward/miyamoto_musash_ward.vmdl")
  self.parent:SetOriginalModel("models/items/juggernaut/ward/miyamoto_musash_ward/miyamoto_musash_ward.vmdl")
  self.parent:SetMaterialGroup("2")
end


self.ward_particle = ParticleManager:CreateParticle(particle_fx, PATTACH_ABSORIGIN_FOLLOW, self.parent)
ParticleManager:SetParticleControl(self.ward_particle, 0, self.parent:GetAbsOrigin())
ParticleManager:SetParticleControl(self.ward_particle, 1, Vector(self.ability.radius, 1, 1))
ParticleManager:SetParticleControlEnt(self.ward_particle, 2, self.parent, PATTACH_POINT_FOLLOW, "flame_attachment", self.parent:GetAbsOrigin(), true)
self.parent:EmitSound(self.sound) 
self.parent:EmitSound(sound_cast)

self.interval = 0.05
self.time = self:GetRemainingTime()

self:OnIntervalThink()
self:StartIntervalThink(self.interval)
end



function modifier_custom_juggernaut_healing_ward:OnIntervalThink()
if not IsServer() then return end
if not self.parent:IsAlive() then return end
if not self.caster:HasTalent("modifier_juggernaut_healingward_7") and not self.caster:HasTalent("modifier_juggernaut_healingward_4") then return end

local targets = self.caster:FindTargets(self.radius*2, self.parent:GetAbsOrigin())

if self.caster:HasTalent("modifier_juggernaut_healingward_7") then
  self.caster:UpdateUIshort({max_time = self.time, time = self:GetRemainingTime(), stack = self:GetStackCount(), style = "JuggernautWard"})
end

local buff = false

for _,target in pairs(targets) do 
  if self.caster:HasTalent("modifier_juggernaut_healingward_7") and target:IsRealHero() then 
    AddFOWViewer(target:GetTeamNumber(), self.parent:GetAbsOrigin(), 50, self.interval*2, false)
  end 

  if self.caster:HasTalent("modifier_juggernaut_healingward_4")
    and not buff 
    and (target:GetAbsOrigin() - self.parent:GetAbsOrigin()):Length2D() <= self.radius
    and (self.caster:GetAbsOrigin() - self.parent:GetAbsOrigin()):Length2D() <= self.radius then 

    buff = true
  end 
end 


if not buff then return end 
if not self.caster:IsAlive() then return end

if not self.caster:HasModifier("modifier_custom_juggernaut_healing_ward_buff") then 
  local item_effect = ParticleManager:CreateParticle( "particles/units/heroes/hero_zuus/zuus_arc_lightning.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.caster)
  ParticleManager:SetParticleControlEnt(item_effect, 0, self.caster, PATTACH_POINT_FOLLOW, "attach_hitloc", self.caster:GetOrigin(), true )
  ParticleManager:SetParticleControlEnt(item_effect, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetOrigin(), true )
  ParticleManager:ReleaseParticleIndex(item_effect)
end 

self.caster:AddNewModifier(self.caster, self.ability, "modifier_custom_juggernaut_healing_ward_buff", {duration = self.buff_duration})

end



function modifier_custom_juggernaut_healing_ward:DeathEvent( params )
if not IsServer() then return end
if params.unit ~= self.parent then return end

self.killer = params.attacker
self:Destroy()
end



function modifier_custom_juggernaut_healing_ward:OnDestroy()
if not IsServer() then return end

self.caster:UpdateUIshort({hide = 1, hide_full = 1, style = "JuggernautWard"})

self.parent:EmitSound(self.sound_stop)
self.parent:StopSound(self.sound)

ParticleManager:DestroyParticle(self.ward_particle, true)
ParticleManager:ReleaseParticleIndex(self.ward_particle)

if self.caster:HasModifier("modifier_juggernaut_fall_ward") then
  local death_particle = ParticleManager:CreateParticle("particles/econ/items/juggernaut/jugg_fall20_immortal/jugg_fall20_immortal_healing_ward_death.vpcf", PATTACH_WORLDORIGIN, self.parent)
  ParticleManager:SetParticleControl(death_particle, 0, self.parent:GetAbsOrigin())
  ParticleManager:ReleaseParticleIndex(death_particle)
end

if self.ability then 
  self.ability:UseResources(false, false, false, true)
  self.ability:SetActivated(true)
end



local stun_duration = self.caster:GetTalentValue("modifier_juggernaut_healingward_6", "stun", true)

local targets = self.caster:FindTargets(self.radius, self.parent:GetAbsOrigin())
local damage = 0
local stun = false


if self:GetStackCount() > 0 then 

  local particle = ParticleManager:CreateParticle("particles/juggernaut/ward_exlosion.vpcf", PATTACH_WORLDORIGIN, nil)
  ParticleManager:SetParticleControl(particle, 0, self.parent:GetAbsOrigin())
  ParticleManager:SetParticleControl(particle, 1, Vector(self.radius, 1, 1))
  ParticleManager:ReleaseParticleIndex(particle)

  self.parent:EmitSound("Juggernaut.WardDeath_2")
  damage = self:GetStackCount()
end

if self.caster:HasTalent("modifier_juggernaut_healingward_2") then 

  self.caster:GenericHeal(self.caster:GetTalentValue("modifier_juggernaut_healingward_2", "heal")*self.caster:GetMaxHealth()/100, self.ability, nil, nil, "modifier_juggernaut_healingward_2")

  local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_oracle/oracle_false_promise_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.caster )
  ParticleManager:ReleaseParticleIndex( particle )
end

if self.caster:HasTalent("modifier_juggernaut_healingward_6") then 
  stun = true

  local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_oracle/oracle_false_promise_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.caster )
  ParticleManager:ReleaseParticleIndex( particle )

  self.caster:Purge(false, true, false, true, false)

  if self.killer and not self.killer:IsNull() then 
    table.insert(targets, self.killer)
  else 
  --  local particle = ParticleManager:CreateParticle("particles/items2_fx/refresher.vpcf", PATTACH_CUSTOMORIGIN, self.caster)
  --  ParticleManager:SetParticleControlEnt( particle, 0, self.caster, PATTACH_POINT_FOLLOW, "attach_hitloc", self.caster:GetOrigin(), true )
 --   ParticleManager:ReleaseParticleIndex(particle)

 --   self.caster:CdAbility(self.ability, self.ability:GetCooldownTimeRemaining()*self.caster:GetTalentValue("modifier_juggernaut_healingward_6", "cd")/100)
  end 

end



for _,target in pairs(targets) do 

  if damage > 0 and (target:GetAbsOrigin() - self.parent:GetAbsOrigin()):Length2D() <= self.radius then 
    local dir = (target:GetAbsOrigin() - self.parent:GetAbsOrigin()):Normalized()
    local distance = 150
    local point = target:GetAbsOrigin() + dir*distance

    target:AddNewModifier( self.caster, self.ability,  "modifier_generic_arc",  
    {
      target_x = point.x,
      target_y = point.y,
      distance = distance,
      duration = 0.2,
      height = 75,
      fix_end = false,
      isStun = false,
      activity = ACT_DOTA_FLAIL,
    })

    local real_damage = DoDamage({victim = target, attacker = self.caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self.ability}, "modifier_juggernaut_healingward_7")
    target:SendNumber(6, real_damage)

    local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_oracle/oracle_false_promise_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
    ParticleManager:ReleaseParticleIndex( particle )
  end

  if stun == true then 
    target:AddNewModifier(self.caster, self.ability, "modifier_stunned", {duration = (1 - target:GetStatusResistance())*stun_duration})

    local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_oracle/oracle_false_promise_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
    ParticleManager:ReleaseParticleIndex( particle )
  end 

end 

if self.caster:HasTalent("modifier_juggernaut_healingward_2") or self.caster:HasTalent("modifier_juggernaut_healingward_6") or self:GetStackCount() > 0 then 
  self.parent:EmitSound("Juggernaut.WardDeath")
end 


end


function modifier_custom_juggernaut_healing_ward:IsHidden() return true end
function modifier_custom_juggernaut_healing_ward:IsPurgable() return false end
function modifier_custom_juggernaut_healing_ward:IsAura() return true end
function modifier_custom_juggernaut_healing_ward:GetAuraDuration() return self.aura_duration end
function modifier_custom_juggernaut_healing_ward:GetAuraRadius() return self.radius end
function modifier_custom_juggernaut_healing_ward:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_custom_juggernaut_healing_ward:GetAuraSearchType() return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO end
function modifier_custom_juggernaut_healing_ward:GetModifierAura() return "modifier_custom_juggernaut_healing_ward_aura" end

function modifier_custom_juggernaut_healing_ward:CheckState() 
return 
{
  [MODIFIER_STATE_NO_UNIT_COLLISION] = not self.caster:HasTalent("modifier_juggernaut_healingward_7"),
  [MODIFIER_STATE_LOW_ATTACK_PRIORITY] = true,
  [MODIFIER_STATE_INVULNERABLE] = self.parent:HasModifier("modifier_custom_juggernaut_healing_ward_invun"),
  [MODIFIER_STATE_NO_HEALTH_BAR] = self.parent:HasModifier("modifier_custom_juggernaut_healing_ward_invun")
}
end





function modifier_custom_juggernaut_healing_ward:DeclareFunctions() return
{
  MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
  MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
  MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
  MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
  MODIFIER_PROPERTY_HEALTHBAR_PIPS 
} 
end


function modifier_custom_juggernaut_healing_ward:GetModifierMoveSpeed_Absolute()
return self.base_move
end



function modifier_custom_juggernaut_healing_ward:DamageEvent_out(params)
if not IsServer() then return end 
if not self.caster:HasTalent("modifier_juggernaut_healingward_7") then return end 
if not params.attacker then return end
if params.unit:IsIllusion() then return end

local attacker = params.attacker
if attacker.owner then 
  attacker = attacker.owner
end 

if attacker ~= self.caster then return end 
if (self.caster:GetAbsOrigin() - self.parent:GetAbsOrigin()):Length2D() > self.radius then return end
if not params.unit:IsUnit() then return end 
 
local damage = params.damage*self.legendary_damage
if params.unit:IsCreep() then 
  damage = damage/self.legendary_creeps
end 

self:SetStackCount(self:GetStackCount() + damage)
end 



function modifier_custom_juggernaut_healing_ward:GetModifierHealthBarPips()
if not self.caster:HasTalent("modifier_juggernaut_healingward_7") then return 1 end
return self.legendary_hits
end


function modifier_custom_juggernaut_healing_ward:GetAbsoluteNoDamageMagical() return 1 end
function modifier_custom_juggernaut_healing_ward:GetAbsoluteNoDamagePhysical() return 1 end
function modifier_custom_juggernaut_healing_ward:GetAbsoluteNoDamagePure() return 1 end

function modifier_custom_juggernaut_healing_ward:AttackEvent_inc( params )
if not IsServer() then return end
if self:GetParent() ~= params.target then return end
if params.attacker:IsIllusion() then return end
if params.attacker:IsCreep() and params.attacker.owner and params.attacker:GetTeamNumber() ~= DOTA_TEAM_CUSTOM_5 then return end

if self.caster:HasTalent("modifier_juggernaut_healingward_7") and (params.attacker:GetAbsOrigin() - self.parent:GetAbsOrigin()):Length2D() > self.radius then 

  self.parent:EmitSound("Juggernaut.Ward_immune")
  self.effect_cast = ParticleManager:CreateParticle("particles/juggernaut/ward_immune.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
  ParticleManager:SetParticleControl( self.effect_cast, 0, self.parent:GetOrigin() )
  ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 100, 0, 0) )
  ParticleManager:ReleaseParticleIndex(self.effect_cast)
  return
end 

if self.ability:GetCaster():HasTalent("modifier_juggernaut_healingward_7") then
  self.health = self.health - 1
else 
  self.health = 0
end
        
if self.health <= 0 then
  self.parent:Kill(nil, params.attacker)
else 
  self.parent:SetHealth(self.health)
end

end




modifier_custom_juggernaut_healing_ward_aura = class({})
function modifier_custom_juggernaut_healing_ward_aura:IsPurgable() return false end
function modifier_custom_juggernaut_healing_ward_aura:DeclareFunctions()
return 
{
  MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
  MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end 

function modifier_custom_juggernaut_healing_ward_aura:GetModifierStatusResistanceStacking()
return self.status
end

function modifier_custom_juggernaut_healing_ward_aura:GetModifierMoveSpeedBonus_Percentage()
return self.move
end

function modifier_custom_juggernaut_healing_ward_aura:GetModifierHealthRegenPercentage() 
return self.health_regen 
end

function modifier_custom_juggernaut_healing_ward_aura:OnCreated(table)
self.parent = self:GetParent()
self.caster = self:GetCaster()

if self.caster.owner then
  self.caster = self.caster.owner
end

self.health_regen = self:GetAbility():GetSpecialValueFor("health_regen")

if not IsServer() then return end
self.move = self.caster:GetTalentValue("modifier_juggernaut_healingward_3", "move_status")
self.status = self.caster:GetTalentValue("modifier_juggernaut_healingward_3", "move_status")

self.radius = self.caster:GetTalentValue("modifier_juggernaut_healingward_1", "radius", true)
self:SetHasCustomTransmitterData(true)
self:SendBuffRefreshToClients()
end


function modifier_custom_juggernaut_healing_ward_aura:AddCustomTransmitterData() 
return 
{
  move = self.move,
  status = self.status
} 
end

function modifier_custom_juggernaut_healing_ward_aura:HandleCustomTransmitterData(data)
self.move = data.move
self.status = data.status
end


function modifier_custom_juggernaut_healing_ward_aura:GetAuraRadius()
return self.radius
end

function modifier_custom_juggernaut_healing_ward_aura:GetAuraSearchTeam()
return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_custom_juggernaut_healing_ward_aura:GetAuraSearchType() 
return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end

function modifier_custom_juggernaut_healing_ward_aura:GetModifierAura()
return "modifier_custom_juggernaut_healing_ward_damage_aura"
end

function modifier_custom_juggernaut_healing_ward_aura:IsAura()
return self.parent:HasTalent("modifier_juggernaut_healingward_1")
end







modifier_custom_juggernaut_healing_ward_damage_aura = class({})
function modifier_custom_juggernaut_healing_ward_damage_aura:IsHidden() return true end
function modifier_custom_juggernaut_healing_ward_damage_aura:IsPurgable() return false end
function modifier_custom_juggernaut_healing_ward_damage_aura:OnCreated()

self.damage = self:GetCaster():GetTalentValue("modifier_juggernaut_healingward_1", "damage")
self.interval = self:GetCaster():GetTalentValue("modifier_juggernaut_healingward_1", "interval")
self.damageTable = {victim = self:GetParent(), attacker = self:GetCaster(), damage = self.damage*self.interval, damage_type = DAMAGE_TYPE_MAGICAL, ability = self:GetAbility()}

self:OnIntervalThink()
self:StartIntervalThink(self.interval)
end

function modifier_custom_juggernaut_healing_ward_damage_aura:OnIntervalThink()
if not IsServer() then return end 

DoDamage(self.damageTable, "modifier_juggernaut_healingward_1")
end 


function modifier_custom_juggernaut_healing_ward_damage_aura:GetEffectName()
  return "particles/juggernaut/ward_burn.vpcf"
end







modifier_custom_juggernaut_healing_ward_reduction = class({})

function modifier_custom_juggernaut_healing_ward_reduction:IsHidden() return true end
function modifier_custom_juggernaut_healing_ward_reduction:IsPurgable() return false end
function modifier_custom_juggernaut_healing_ward_reduction:IsAura() return true end
function modifier_custom_juggernaut_healing_ward_reduction:GetAuraDuration() return 0.1 end
function modifier_custom_juggernaut_healing_ward_reduction:GetAuraRadius() return self.radius end
function modifier_custom_juggernaut_healing_ward_reduction:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_custom_juggernaut_healing_ward_reduction:GetAuraSearchType() return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO end
function modifier_custom_juggernaut_healing_ward_reduction:GetModifierAura() return "modifier_custom_juggernaut_healing_ward_reduction_aura" end

function modifier_custom_juggernaut_healing_ward_reduction:GetAuraEntityReject(hEntity)
if hEntity ~= self.caster and (not hEntity.owner or hEntity.owner ~= self.caster) then return true end


local mod = hEntity:FindModifierByName("modifier_backdoor_knock_aura_damage")

if mod and mod:GetCaster():GetTeamNumber() ~= self.parent:GetTeamNumber() and mod.radius then 

  local point = mod:GetCaster():GetAbsOrigin()

  if (self:GetParent():GetAbsOrigin() - point):Length2D() > mod.radius then 
    return true
  end 

end

return false
end


function modifier_custom_juggernaut_healing_ward_reduction:OnCreated()
self.caster = self:GetCaster()
self.parent = self:GetParent()
self.radius = self:GetAbility():GetSpecialValueFor("radius")
end





modifier_custom_juggernaut_healing_ward_reduction_aura = class({})

function modifier_custom_juggernaut_healing_ward_reduction_aura:GetEffectName() return "particles/jugger_ward_legend.vpcf" end
function modifier_custom_juggernaut_healing_ward_reduction_aura:IsPurgable() return false end
function modifier_custom_juggernaut_healing_ward_reduction_aura:IsHidden() return true end
function modifier_custom_juggernaut_healing_ward_reduction_aura:DeclareFunctions() 
  return 
  {
    MODIFIER_PROPERTY_MIN_HEALTH
  }
end

function modifier_custom_juggernaut_healing_ward_reduction_aura:GetMinHealth()
if not self:GetCaster():HasModifier("modifier_death") then 
 return 1 
else 
 return 0
end

end



















modifier_custom_juggernaut_healing_ward_buff = class({})
function modifier_custom_juggernaut_healing_ward_buff:IsHidden() return false end
function modifier_custom_juggernaut_healing_ward_buff:IsPurgable() return false end

function modifier_custom_juggernaut_healing_ward_buff:GetEffectName()
return "particles/jugg_ward_buff.vpcf"
end

function modifier_custom_juggernaut_healing_ward_buff:GetTexture()
return "buffs/Healing_ward_buff"
end

function modifier_custom_juggernaut_healing_ward_buff:OnCreated(table)
self.speed = self:GetCaster():GetTalentValue("modifier_juggernaut_healingward_4", "speed")
self.spell = self:GetCaster():GetTalentValue("modifier_juggernaut_healingward_4", "spell")

if not IsServer() then return end 

self:GetParent():EmitSound("Juggernaut.Ward_buff")
end

function modifier_custom_juggernaut_healing_ward_buff:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
  MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
}
end

function modifier_custom_juggernaut_healing_ward_buff:GetModifierAttackSpeedBonus_Constant()
return self.speed
end

function modifier_custom_juggernaut_healing_ward_buff:GetModifierSpellAmplify_Percentage()
return self.spell 
end


function modifier_custom_juggernaut_healing_ward_buff:GetStatusEffectName()
return "particles/status_fx/status_effect_mjollnir_shield.vpcf"
end


function modifier_custom_juggernaut_healing_ward_buff:StatusEffectPriority()
return MODIFIER_PRIORITY_HIGH
end





modifier_custom_juggernaut_healing_ward_invun = class({})
function modifier_custom_juggernaut_healing_ward_invun:IsHidden() return true end
function modifier_custom_juggernaut_healing_ward_invun:IsPurgable() return false end
function modifier_custom_juggernaut_healing_ward_invun:GetEffectName()
return "particles/juggernaut/ward_invun.vpcf"
end


modifier_custom_juggernaut_healing_ward_tracker = class({})
function modifier_custom_juggernaut_healing_ward_tracker:IsHidden() return true end
function modifier_custom_juggernaut_healing_ward_tracker:IsPurgable() return false end