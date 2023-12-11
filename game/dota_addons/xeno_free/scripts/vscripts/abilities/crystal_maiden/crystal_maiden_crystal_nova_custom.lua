LinkLuaModifier( "modifier_crystal_maiden_crystal_nova_custom", "abilities/crystal_maiden/crystal_maiden_crystal_nova_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_crystal_maiden_crystal_nova_armor", "abilities/crystal_maiden/crystal_maiden_crystal_nova_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_crystal_maiden_crystal_nova_legendary", "abilities/crystal_maiden/crystal_maiden_crystal_nova_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_crystal_maiden_crystal_nova_legendary_aura", "abilities/crystal_maiden/crystal_maiden_crystal_nova_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_crystal_maiden_crystal_nova_legendary_slide", "abilities/crystal_maiden/crystal_maiden_crystal_nova_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_crystal_maiden_crystal_nova_shards", "abilities/crystal_maiden/crystal_maiden_crystal_nova_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_crystal_maiden_crystal_nova_speed", "abilities/crystal_maiden/crystal_maiden_crystal_nova_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_crystal_maiden_crystal_nova_tracker", "abilities/crystal_maiden/crystal_maiden_crystal_nova_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_crystal_maiden_crystal_nova_damage", "abilities/crystal_maiden/crystal_maiden_crystal_nova_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_crystal_maiden_crystal_nova_stun", "abilities/crystal_maiden/crystal_maiden_crystal_nova_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_crystal_maiden_crystal_nova_stun_cd", "abilities/crystal_maiden/crystal_maiden_crystal_nova_custom", LUA_MODIFIER_MOTION_NONE )








crystal_maiden_crystal_nova_custom = class({})



crystal_maiden_crystal_nova_custom.cd_inc = {-1, -1.5, -2}







function crystal_maiden_crystal_nova_custom:Precache(context)

PrecacheResource( "particle", "particles/zuus_speed.vpcf", context )
PrecacheResource( "particle", "particles/econ/events/winter_major_2016/blink_dagger_start_wm.vpcf", context )
PrecacheResource( "particle", "particles/econ/events/winter_major_2016/blink_dagger_wm_end.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_crystalmaiden/maiden_crystal_nova.vpcf", context )
PrecacheResource( "particle", "particles/status_fx/status_effect_frost.vpcf", context )
PrecacheResource( "particle", "particles/zuus_heal.vpcf", context )
PrecacheResource( "particle", "particles/neutral_fx/ogre_magi_frost_armor.vpcf", context )
PrecacheResource( "particle", "particles/maiden_ice_rink.vpcf", context )
PrecacheResource( "particle", "particles/maiden_rink_glow.vpcf", context )
PrecacheResource( "particle", "particles/econ/items/drow/drow_arcana/drow_arcana_rare_run_slide.vpcf", context )

end



function crystal_maiden_crystal_nova_custom:GetIntrinsicModifierName()
return "modifier_crystal_maiden_crystal_nova_tracker"
end


function crystal_maiden_crystal_nova_custom:GetCooldown(iLevel)

local bonus = 0
if self:GetCaster():HasModifier("modifier_maiden_crystal_1") then 
  bonus = self.cd_inc[self:GetCaster():GetUpgradeStack("modifier_maiden_crystal_1")]
end

 return self.BaseClass.GetCooldown(self, iLevel) + bonus
 
end




function crystal_maiden_crystal_nova_custom:GetBehavior()

local auto = 0

if self:GetCaster():HasModifier("modifier_maiden_arcane_6") then 
  auto = DOTA_ABILITY_BEHAVIOR_AUTOCAST
end 

return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AOE + auto
end

function crystal_maiden_crystal_nova_custom:GetCastPoint()
local bonus = 0


if self:GetCaster():HasModifier("modifier_maiden_crystal_5") then 
  bonus = self:GetCaster():GetTalentValue("modifier_maiden_crystal_5", "cast")
end

 return self:GetSpecialValueFor("AbilityCastPoint") + bonus
 
end




function crystal_maiden_crystal_nova_custom:GetCastRange(vLocation, hTarget)

local upgrade = 0
if self:GetCaster():HasModifier("modifier_maiden_crystal_3") then 
  upgrade = self:GetCaster():GetTalentValue("modifier_maiden_crystal_3", "range")
end

return self.BaseClass.GetCastRange(self , vLocation , hTarget) + upgrade 
end



  

function crystal_maiden_crystal_nova_custom:GetAOERadius()
  return self:GetSpecialValueFor( "radius" ) + self:GetCaster():GetTalentValue("modifier_maiden_crystal_6", "radius")
end




function crystal_maiden_crystal_nova_custom:OnSpellStart()

  local caster = self:GetCaster()
  local point = self:GetCursorPosition()


  local castrange = self:GetSpecialValueFor("AbilityCastRange")

  if self:GetCaster():HasModifier("modifier_maiden_crystal_3") then 
    castrange = castrange + self:GetCaster():GetTalentValue("modifier_maiden_crystal_3", "range")
  end

  local dir = (point - caster:GetAbsOrigin()):Normalized()

  if (point - caster:GetAbsOrigin()):Length2D() > castrange then 
    --point = point + self:GetCaster():GetAbsOrigin() + dir*castrange
  end


  local damage = self:GetSpecialValueFor("nova_damage")
  local radius = self:GetSpecialValueFor("radius") + self:GetCaster():GetTalentValue("modifier_maiden_crystal_6", "radius")
  local debuffDuration = self:GetSpecialValueFor("duration")

  local vision_radius = 900
  local vision_duration = 6


  if self:GetCaster():HasModifier("modifier_maiden_crystal_2") then 
    damage = damage + self:GetCaster():GetTalentValue("modifier_maiden_crystal_2", "damage")*self:GetCaster():GetIntellect()/100
  end

  local mod = self:GetCaster():FindModifierByName("modifier_crystal_maiden_crystal_nova_damage")

  if mod then 
    damage = damage*(1 + mod:GetStackCount()*self:GetCaster():GetTalentValue("modifier_maiden_crystal_4", "damage")/100)
    mod:Destroy()
  end 

  if self:GetCaster():HasModifier("modifier_maiden_crystal_3") then 
    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_crystal_maiden_crystal_nova_speed", { duration = self:GetCaster():GetTalentValue("modifier_maiden_crystal_3", "duration"), })
  end

  local stun_duration = self:GetCaster():GetTalentValue("modifier_maiden_crystal_5", "stun")
  local stun_cd = self:GetCaster():GetTalentValue("modifier_maiden_crystal_5", "cd")

  local arcane = self:GetCaster():FindAbilityByName("crystal_maiden_arcane_aura_custom")
  local mod = self:GetCaster():FindModifierByName("modifier_crystal_maiden_arcane_aura_custom_spell")
  if arcane and mod and self:GetAutoCastState() == true then 

    mod:Destroy()

    EmitSoundOnLocationWithCaster(self:GetCaster():GetAbsOrigin(), "DOTA_Item.Arcane_Blink.Activate", self:GetCaster())

    local effect_end = ParticleManager:CreateParticle( "particles/econ/events/winter_major_2016/blink_dagger_start_wm.vpcf", PATTACH_WORLDORIGIN, nil )
    ParticleManager:SetParticleControl( effect_end, 0, self:GetCaster():GetAbsOrigin() )
    ParticleManager:ReleaseParticleIndex( effect_end )

    FindClearSpaceForUnit(self:GetCaster(), point, true)

    local effect_end = ParticleManager:CreateParticle( "particles/econ/events/winter_major_2016/blink_dagger_wm_end.vpcf", PATTACH_WORLDORIGIN, nil )
    ParticleManager:SetParticleControl( effect_end, 0, self:GetCaster():GetAbsOrigin() )
    ParticleManager:ReleaseParticleIndex( effect_end )

    self:GetCaster():EmitSound("Puck.Rift_Legendary")

   
  end


  local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), point, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )

  local stunned = false

  local damageTable = { attacker = caster, damage_type = DAMAGE_TYPE_MAGICAL, ability = self, }

  for _,enemy in pairs(enemies) do

    damageTable.victim = enemy

    local deal_damage = damage

    if enemy:IsCreep() then 
      deal_damage = deal_damage * (1 + self:GetSpecialValueFor("creeps_damage")/100)
    end

    damageTable.damage = deal_damage

    if self:GetCaster():HasModifier("modifier_maiden_crystal_5") and not enemy:HasModifier("modifier_crystal_maiden_crystal_nova_stun_cd") then 

      stunned = true
      enemy:AddNewModifier(self:GetCaster(), self, "modifier_crystal_maiden_crystal_nova_stun", {duration = (1 - enemy:GetStatusResistance())*stun_duration})
      enemy:AddNewModifier(self:GetCaster(), self, "modifier_crystal_maiden_crystal_nova_stun_cd", {duration = stun_cd})
    end


    ApplyDamage(damageTable)

    enemy:AddNewModifier( caster, self, "modifier_crystal_maiden_crystal_nova_custom", { duration = debuffDuration } )
  end

  AddFOWViewer( self:GetCaster():GetTeamNumber(), point, vision_radius, vision_duration, true )

  
  if self:GetCaster():HasModifier("modifier_maiden_crystal_6") and #enemies > 0 then 
    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_crystal_maiden_crystal_nova_armor", {duration = self:GetCaster():GetTalentValue("modifier_maiden_crystal_6", "duration")})
    self:GetCaster():EmitSound("Maiden.Crystal_armor")
  end

  if stunned == true then 
    EmitSoundOnLocationWithCaster(point, "Maiden.Frostbite_stun", self:GetCaster())
  end 


  self:PlayEffects( point, radius, debuffDuration )
end




--------------------------------------------------------------------------------
function crystal_maiden_crystal_nova_custom:PlayEffects( point, radius, duration )

  local particle_cast = "particles/units/heroes/hero_crystalmaiden/maiden_crystal_nova.vpcf"
  local sound_cast = "Hero_Crystal.CrystalNova"


  local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
  ParticleManager:SetParticleControl( effect_cast, 0, point )
  ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, duration, radius ) )
  ParticleManager:ReleaseParticleIndex( effect_cast )


  EmitSoundOnLocationWithCaster( point, sound_cast, self:GetCaster() )
end








modifier_crystal_maiden_crystal_nova_custom = class({})


function modifier_crystal_maiden_crystal_nova_custom:IsHidden()
  return false
end

function modifier_crystal_maiden_crystal_nova_custom:IsDebuff()
  return true
end

function modifier_crystal_maiden_crystal_nova_custom:IsPurgable()
  return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_crystal_maiden_crystal_nova_custom:OnCreated( kv )
  -- references
  self.as_slow = self:GetAbility():GetSpecialValueFor( "attackspeed_slow" )  
  self.ms_slow = self:GetAbility():GetSpecialValueFor( "movespeed_slow" )  

  if not IsServer() then return end

  if self:GetCaster():GetQuest() == "Maiden.Quest_5" and self:GetParent():IsRealHero() and not self:GetCaster():QuestCompleted() then 
    self:StartIntervalThink(0.1)
  end

end

function modifier_crystal_maiden_crystal_nova_custom:OnIntervalThink()
if not IsServer() then return end

self:GetCaster():UpdateQuest(0.1)
end


function modifier_crystal_maiden_crystal_nova_custom:OnRefresh( kv )
  -- references
  self.as_slow = self:GetAbility():GetSpecialValueFor( "attackspeed_slow" )  
  self.ms_slow = self:GetAbility():GetSpecialValueFor( "movespeed_slow" )   
end

function modifier_crystal_maiden_crystal_nova_custom:OnDestroy( kv )

end


function modifier_crystal_maiden_crystal_nova_custom:DeclareFunctions()
  local funcs = {
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
  }

  return funcs
end

function modifier_crystal_maiden_crystal_nova_custom:GetModifierMoveSpeedBonus_Percentage()
  return self.ms_slow
end

function modifier_crystal_maiden_crystal_nova_custom:GetModifierAttackSpeedBonus_Constant()
  return self.as_slow
end




function modifier_crystal_maiden_crystal_nova_custom:GetStatusEffectName()
return "particles/status_fx/status_effect_frost.vpcf"
end

function modifier_crystal_maiden_crystal_nova_custom:StatusEffectPriority()
return 9999
end










modifier_crystal_maiden_crystal_nova_armor = class({})
function modifier_crystal_maiden_crystal_nova_armor:IsHidden() return false end
function modifier_crystal_maiden_crystal_nova_armor:IsPurgable() return true end
function modifier_crystal_maiden_crystal_nova_armor:GetTexture() return "lich_frost_armor" end
function modifier_crystal_maiden_crystal_nova_armor:GetEffectName() return "particles/zuus_heal.vpcf" end




function modifier_crystal_maiden_crystal_nova_armor:OnCreated(table)
self.heal = (self:GetCaster():GetTalentValue("modifier_maiden_crystal_6", "heal")*self:GetCaster():GetIntellect()/100) /self:GetRemainingTime()
self.damage = self:GetCaster():GetTalentValue("modifier_maiden_crystal_6", "damage")

if not IsServer() then return end

local effect_cast = ParticleManager:CreateParticle( "particles/neutral_fx/ogre_magi_frost_armor.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
self:AddParticle( effect_cast, false, false, -1, false, false )

self:StartIntervalThink(1)
end

function modifier_crystal_maiden_crystal_nova_armor:OnIntervalThink()
if not IsServer() then return end

local particle = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
ParticleManager:ReleaseParticleIndex( particle )
SendOverheadEventMessage(self:GetParent(), 10, self:GetParent(), self.heal, nil)
end





function modifier_crystal_maiden_crystal_nova_armor:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
   MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT
}

end


function modifier_crystal_maiden_crystal_nova_armor:GetModifierIncomingDamage_Percentage()
return self.damage
end

function modifier_crystal_maiden_crystal_nova_armor:GetModifierConstantHealthRegen()
return self.heal
end











modifier_crystal_maiden_crystal_nova_legendary = class({})

function modifier_crystal_maiden_crystal_nova_legendary:IsAura()
return true
end

function modifier_crystal_maiden_crystal_nova_legendary:OnCreated(table)
if not IsServer() then return end

self.radius =  self:GetCaster():GetTalentValue("modifier_maiden_crystal_7", "radius")

self.duration =  self:GetCaster():GetTalentValue("modifier_maiden_crystal_7", "duration")

self.effect_cast = ParticleManager:CreateParticle("particles/maiden_ice_rink.vpcf", PATTACH_WORLDORIGIN, nil )
ParticleManager:SetParticleControl( self.effect_cast, 0, self:GetParent():GetAbsOrigin() )
ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( self.radius*1.05, self.radius*1.05, self.radius*1.05 ) )
ParticleManager:SetParticleControl( self.effect_cast, 2, Vector(self.duration, 0, 0) )
self:AddParticle( self.effect_cast, false, false, -1, false, false )

self:GetParent():EmitSound("Maiden.Crystal_rink_loop")

AddFOWViewer(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), self.radius, self:GetRemainingTime(), false)

self.particle = ParticleManager:CreateParticle("particles/maiden_rink_glow.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(self.particle, 0, self:GetParent():GetAbsOrigin())
ParticleManager:SetParticleControl(self.particle, 1, Vector(self:GetRemainingTime()+0.5, self.radius, 0))

end



function modifier_crystal_maiden_crystal_nova_legendary:OnDestroy()
if not IsServer() then return end

self:GetParent():StopSound("Maiden.Crystal_rink_loop")
self:GetParent():EmitSound("Lich.Spire_destroy")
end


function modifier_crystal_maiden_crystal_nova_legendary:GetAuraDuration()
  return 0
end


function modifier_crystal_maiden_crystal_nova_legendary:GetAuraRadius()
  return self.radius
end

function modifier_crystal_maiden_crystal_nova_legendary:GetAuraSearchFlags()
  return 
end

function modifier_crystal_maiden_crystal_nova_legendary:GetAuraSearchTeam()
  return DOTA_UNIT_TARGET_TEAM_BOTH
end

function modifier_crystal_maiden_crystal_nova_legendary:GetAuraSearchType()
  return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end




function modifier_crystal_maiden_crystal_nova_legendary:GetModifierAura()
  return "modifier_crystal_maiden_crystal_nova_legendary_aura"
end


function modifier_crystal_maiden_crystal_nova_legendary:GetAuraEntityReject(hEntity)
if hEntity:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() and hEntity:IsRooted() then 
  --return true
end

if hEntity:GetUnitName() == "npc_teleport" or hEntity:HasModifier("modifier_crystal_maiden_crystal_nova_stun") then 
  return true
end

return false
end



modifier_crystal_maiden_crystal_nova_legendary_aura = class({})
function modifier_crystal_maiden_crystal_nova_legendary_aura:IsHidden() return true end
function modifier_crystal_maiden_crystal_nova_legendary_aura:IsPurgable() return false end

function modifier_crystal_maiden_crystal_nova_legendary_aura:OnCreated(table)
if not IsServer() then return end

self.radius =  self:GetCaster():GetTalentValue("modifier_maiden_crystal_7", "radius")
self.interval = self:GetCaster():GetTalentValue("modifier_maiden_crystal_7", "attack")
self.range = self:GetCaster():GetTalentValue("modifier_maiden_crystal_7", "range")

self:GetParent():MoveToPosition(self:GetParent():GetAbsOrigin() + self:GetParent():GetForwardVector())

self.count = 2

local effect_end = ParticleManager:CreateParticle( "particles/econ/items/drow/drow_arcana/drow_arcana_rare_run_slide.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
ParticleManager:SetParticleControl( effect_end, 0, self:GetParent():GetAbsOrigin() )
ParticleManager:ReleaseParticleIndex( effect_end )

self:GetParent():EmitSound("Maiden.Crystal_rink_slide")

self:StartIntervalThink(self.interval )
end



function modifier_crystal_maiden_crystal_nova_legendary_aura:OnIntervalThink()
if not IsServer() then return end

self.count = self.count + self.interval

if self.count >= 2 then 
  local effect_end = ParticleManager:CreateParticle( "particles/econ/items/drow/drow_arcana/drow_arcana_rare_run_slide.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
  ParticleManager:SetParticleControl( effect_end, 0, self:GetParent():GetAbsOrigin() )
  ParticleManager:ReleaseParticleIndex( effect_end )
  
  self:GetParent():EmitSound("Maiden.Crystal_rink_slide")
  self.count = 0
end

if self:GetCaster() ~= self:GetParent() then return end
if not self:GetAuraOwner() then return end 

local targets = self:GetCaster():FindTargets(self.range, self:GetCaster():GetAbsOrigin())


for _,target in pairs(targets) do 
  self:GetCaster():PerformAttack(target, true, true, true, false, true, false, false)
end 

end

function modifier_crystal_maiden_crystal_nova_legendary_aura:CheckState()
if self:GetCaster():GetTeamNumber() == self:GetParent():GetTeamNumber() then return end
return
{
  [MODIFIER_STATE_TETHERED] = true
}
end




modifier_crystal_maiden_crystal_nova_legendary_slide = class({})

function modifier_crystal_maiden_crystal_nova_legendary_slide:IsAura()
return true
end

function modifier_crystal_maiden_crystal_nova_legendary_slide:OnCreated(table)
if not IsServer() then return end

self.radius = self:GetCaster():GetTalentValue("modifier_maiden_crystal_7", "radius")

end



function modifier_crystal_maiden_crystal_nova_legendary_slide:GetAuraDuration()
  return 0
end


function modifier_crystal_maiden_crystal_nova_legendary_slide:GetAuraRadius()
  return self.radius
end

function modifier_crystal_maiden_crystal_nova_legendary_slide:GetAuraSearchFlags()
  return 
end

function modifier_crystal_maiden_crystal_nova_legendary_slide:GetAuraSearchTeam()
  return DOTA_UNIT_TARGET_TEAM_BOTH
end

function modifier_crystal_maiden_crystal_nova_legendary_slide:GetAuraSearchType()
  return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end




function modifier_crystal_maiden_crystal_nova_legendary_slide:GetModifierAura()
  return "modifier_ice_slide"
end


function modifier_crystal_maiden_crystal_nova_legendary_slide:GetAuraEntityReject(hEntity)
if hEntity:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() and hEntity:IsRooted() then 
  return true
end

if hEntity == self:GetCaster() and not self:GetCaster():HasShard() and self:GetCaster():HasModifier("modifier_crystal_maiden_freezing_field_custom") then 
  return true
end

if hEntity:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() and hEntity:IsDebuffImmune() then 
  return true
end

if hEntity:GetUnitName() == "npc_teleport" or hEntity:HasModifier("modifier_crystal_maiden_crystal_nova_stun") then 
  return true
end

return false
end





crystal_maiden_crystal_nova_custom_legendary = class({})

function crystal_maiden_crystal_nova_custom_legendary:GetAOERadius()
return self:GetCaster():GetTalentValue("modifier_maiden_crystal_7", "radius")
end

function crystal_maiden_crystal_nova_custom_legendary:GetCooldown(iLevel)
return self:GetCaster():GetTalentValue("modifier_maiden_crystal_7", "cd")
end


function crystal_maiden_crystal_nova_custom_legendary:OnSpellStart()
if not IsServer() then return end

local point = self:GetCursorPosition()

CreateModifierThinker(self:GetCaster(), self, "modifier_crystal_maiden_crystal_nova_legendary", {duration = self:GetCaster():GetTalentValue("modifier_maiden_crystal_7", "duration")}, point, self:GetCaster():GetTeamNumber(), false)
CreateModifierThinker(self:GetCaster(), self, "modifier_crystal_maiden_crystal_nova_legendary_slide", {duration = self:GetCaster():GetTalentValue("modifier_maiden_crystal_7", "duration")}, point, self:GetCaster():GetTeamNumber(), false)

self:GetCaster():EmitSound("Maiden.Crystal_rink_cast")

end



modifier_crystal_maiden_crystal_nova_shards = class({})

function modifier_crystal_maiden_crystal_nova_shards:IsPurgable() return false end
function modifier_crystal_maiden_crystal_nova_shards:CheckState()
return
{
  [MODIFIER_STATE_MAGIC_IMMUNE] = true,
  [MODIFIER_STATE_ATTACK_IMMUNE] = true,
  [MODIFIER_STATE_INVULNERABLE] = true,
  [MODIFIER_STATE_UNSELECTABLE] = true,
  [MODIFIER_STATE_ROOTED] = true,
  [MODIFIER_STATE_NO_HEALTH_BAR] = true,
}
end

function modifier_crystal_maiden_crystal_nova_shards:OnDestroy()
UTIL_Remove(self:GetParent())
end



modifier_crystal_maiden_crystal_nova_speed = class({})
function modifier_crystal_maiden_crystal_nova_speed:IsHidden() return false end
function modifier_crystal_maiden_crystal_nova_speed:IsPurgable() return true end
function modifier_crystal_maiden_crystal_nova_speed:GetTexture() return "buffs/nova_speed" end
function modifier_crystal_maiden_crystal_nova_speed:OnCreated()

self.speed = self:GetCaster():GetTalentValue("modifier_maiden_crystal_3", "speed")
end 

function modifier_crystal_maiden_crystal_nova_speed:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
end

function modifier_crystal_maiden_crystal_nova_speed:GetModifierAttackSpeedBonus_Constant()
return self.speed
end



modifier_crystal_maiden_crystal_nova_tracker = class({})
function modifier_crystal_maiden_crystal_nova_tracker:IsHidden() return true end
function modifier_crystal_maiden_crystal_nova_tracker:IsPurgable() return false end
function modifier_crystal_maiden_crystal_nova_tracker:OnCreated()


end 

function modifier_crystal_maiden_crystal_nova_tracker:DeclareFunctions()
return
{
  MODIFIER_EVENT_ON_ATTACK_LANDED
}
end


function modifier_crystal_maiden_crystal_nova_tracker:OnAttackLanded(params)
if not IsServer() then return end 
if self:GetParent() ~= params.attacker then return end
if not self:GetParent():HasModifier("modifier_maiden_crystal_4") then return end 
if not params.target:IsCreep() and not params.target:IsHero() then return end 

self:GetParent():CdAbility(self:GetAbility(), self:GetCaster():GetTalentValue("modifier_maiden_crystal_4", "cd"))

self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_crystal_maiden_crystal_nova_damage", {duration = self:GetCaster():GetTalentValue("modifier_maiden_crystal_4", "duration")})

end 


modifier_crystal_maiden_crystal_nova_damage = class({})

function modifier_crystal_maiden_crystal_nova_damage:IsHidden() return false end
function modifier_crystal_maiden_crystal_nova_damage:IsPurgable() return false end
function modifier_crystal_maiden_crystal_nova_damage:GetTexture() return "buffs/nova_damage" end
function modifier_crystal_maiden_crystal_nova_damage:OnCreated()


self.damage = self:GetCaster():GetTalentValue("modifier_maiden_crystal_4", "damage")
if not IsServer() then return end 
self:SetStackCount(1)

self.max = self:GetCaster():GetTalentValue("modifier_maiden_crystal_4", "max")
end 

function modifier_crystal_maiden_crystal_nova_damage:OnRefresh()
if not IsServer() then return end 
if self:GetStackCount() >= self.max then return end 

self:IncrementStackCount()
end 


function modifier_crystal_maiden_crystal_nova_damage:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_TOOLTIP
}
end


function modifier_crystal_maiden_crystal_nova_damage:OnTooltip()
return self.damage*self:GetStackCount()
end





modifier_crystal_maiden_crystal_nova_stun = class({})
function modifier_crystal_maiden_crystal_nova_stun:IsHidden() return true end
function modifier_crystal_maiden_crystal_nova_stun:IsPurgable() return false end
function modifier_crystal_maiden_crystal_nova_stun:IsStunDebuff() return true end
function modifier_crystal_maiden_crystal_nova_stun:IsPurgeException() return true end


function modifier_crystal_maiden_crystal_nova_stun:GetStatusEffectName()
return "particles/status_fx/status_effect_frost.vpcf"
end

function modifier_crystal_maiden_crystal_nova_stun:StatusEffectPriority()
return 9999
end


function modifier_crystal_maiden_crystal_nova_stun:CheckState()
return
{
    [MODIFIER_STATE_FROZEN] = true,
    [MODIFIER_STATE_STUNNED] = true
}
end

modifier_crystal_maiden_crystal_nova_stun_cd = class({})
function modifier_crystal_maiden_crystal_nova_stun_cd:IsHidden() return true end
function modifier_crystal_maiden_crystal_nova_stun_cd:IsPurgable() return false end
function modifier_crystal_maiden_crystal_nova_stun_cd:RemoveOnDeath() return false end
function modifier_crystal_maiden_crystal_nova_stun_cd:OnCreated()
self.RemoveForDuel = true
end