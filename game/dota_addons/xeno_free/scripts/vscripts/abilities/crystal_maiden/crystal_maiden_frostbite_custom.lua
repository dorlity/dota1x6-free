LinkLuaModifier( "modifier_crystal_maiden_frostbite_custom", "abilities/crystal_maiden/crystal_maiden_frostbite_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_crystal_maiden_frostbite_custom_attack_cd", "abilities/crystal_maiden/crystal_maiden_frostbite_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_crystal_maiden_frostbite_custom_tracker", "abilities/crystal_maiden/crystal_maiden_frostbite_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_crystal_maiden_frostbite_custom_legendary_slow", "abilities/crystal_maiden/crystal_maiden_frostbite_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_crystal_maiden_frostbite_custom_max_slow", "abilities/crystal_maiden/crystal_maiden_frostbite_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_crystal_maiden_frostbite_custom_resist", "abilities/crystal_maiden/crystal_maiden_frostbite_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_crystal_maiden_frostbite_custom_lowhp", "abilities/crystal_maiden/crystal_maiden_frostbite_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_crystal_maiden_frostbite_custom_lowhp_cd", "abilities/crystal_maiden/crystal_maiden_frostbite_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_crystal_maiden_frostbite_custom_area", "abilities/crystal_maiden/crystal_maiden_frostbite_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_crystal_maiden_frostbite_custom_slow", "abilities/crystal_maiden/crystal_maiden_frostbite_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_crystal_maiden_frostbite_custom_health", "abilities/crystal_maiden/crystal_maiden_frostbite_custom", LUA_MODIFIER_MOTION_NONE )








crystal_maiden_frostbite_custom = class({})


crystal_maiden_frostbite_custom.damage_heal = {0.1, 0.15, 0.2}

crystal_maiden_frostbite_custom.resist_status = {-8, -12, -16}
crystal_maiden_frostbite_custom.resist_magic = {-8, -12, -16}
crystal_maiden_frostbite_custom.resist_duration = 5

crystal_maiden_frostbite_custom.lowhp_duration = 2.5
crystal_maiden_frostbite_custom.lowhp_heal = 20
crystal_maiden_frostbite_custom.lowhp_cd = 40

crystal_maiden_frostbite_custom.aoe_radius = 400
crystal_maiden_frostbite_custom.aoe_duration = 8
crystal_maiden_frostbite_custom.aoe_interval = 1
crystal_maiden_frostbite_custom.aoe_damage = {40, 60}
crystal_maiden_frostbite_custom.aoe_heal = 1




function crystal_maiden_frostbite_custom:Precache(context)

PrecacheResource( "particle", "particles/units/heroes/hero_crystalmaiden/maiden_frostbite.vpcf", context )
PrecacheResource( "particle", "particles/maiden_ground.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_crystalmaiden/maiden_frostbite_buff.vpcf", context )
PrecacheResource( "particle", "particles/status_fx/status_effect_frost.vpcf", context )
PrecacheResource( "particle", "particles/maiden_radius.vpcf", context )
PrecacheResource( "particle", "particles/maiden_snow.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_drow/drow_hypothermia_counter_stack.vpcf", context )
PrecacheResource( "particle", "particles/maiden_mark.vpcf", context )
PrecacheResource( "particle", "particles/maiden_frostbite_slow.vpcf", context )
PrecacheResource( "particle", "particles/zeus_resist_stack.vpcf", context )
PrecacheResource( "particle", "particles/econ/items/winter_wyvern/winter_wyvern_ti7/wyvern_cold_embrace_ti7buff.vpcf", context )
PrecacheResource( "particle", "particles/maiden_frostbite_area.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_lich/lich_ice_age_debuff.vpcf", context )
PrecacheResource( "particle", "particles/maiden_area_damage.vpcf", context )

end






function crystal_maiden_frostbite_custom:GetIntrinsicModifierName()
  return "modifier_crystal_maiden_frostbite_custom_tracker"
end




function crystal_maiden_frostbite_custom:OnSpellStart(new_target)

  local caster = self:GetCaster()
  local target = self:GetCursorTarget()

  if new_target then 
    target = new_target
  end


  if target:IsMagicImmune() then 
    return
  end

  local dispell = 1
  local arcane = self:GetCaster():FindAbilityByName("crystal_maiden_arcane_aura_custom")
  local mod = self:GetCaster():FindModifierByName("modifier_crystal_maiden_arcane_aura_custom_spell")
  if arcane and mod then 
    dispell = 0
    mod:Destroy()
  end

  if target:TriggerSpellAbsorb(self) then 
    return
  end

  local duration = self:GetSpecialValueFor("duration")*(1 - target:GetStatusResistance())
 
  if target:IsCreep() and not target:HasModifier("modifier_waveupgrade_boss") then
    duration = self:GetSpecialValueFor("creep_duration")
  end



  if self:GetCaster():HasModifier("modifier_maiden_frostbite_1") then 
    target:AddNewModifier(self:GetCaster(), self, "modifier_crystal_maiden_frostbite_custom_resist", {duration = self.resist_duration})
  end


  target:AddNewModifier( caster, self, "modifier_crystal_maiden_frostbite_custom", {dispell = dispell, duration = duration } )


  if self:GetCaster():HasModifier("modifier_maiden_frostbite_4") then 
    CreateModifierThinker(caster, self, "modifier_crystal_maiden_frostbite_custom_area", {duration = self.aoe_duration}, target:GetAbsOrigin(), caster:GetTeamNumber(), false)
  end  

  self:PlayEffects( caster, target )
end




--------------------------------------------------------------------------------
function crystal_maiden_frostbite_custom:PlayEffects( caster, target )

  local projectile_name = "particles/units/heroes/hero_crystalmaiden/maiden_frostbite.vpcf"
  local projectile_speed = 1000
  local info = {
    Target = target,
    Source = caster,
    Ability = self, 
    
    EffectName = projectile_name,
    iMoveSpeed = projectile_speed,
    vSourceLoc= caster:GetAbsOrigin(),                -- Optional (HOW)

    bDodgeable = false,                                -- Optional
  }
  ProjectileManager:CreateTrackingProjectile(info)
end



modifier_crystal_maiden_frostbite_custom = class({})



function modifier_crystal_maiden_frostbite_custom:IsHidden()
  return false
end

function modifier_crystal_maiden_frostbite_custom:IsDebuff()
  return true
end

function modifier_crystal_maiden_frostbite_custom:IsPurgable()
  return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_crystal_maiden_frostbite_custom:OnCreated( kv )


self.interval = self:GetAbility():GetSpecialValueFor("tick_interval")

self.damage = self.interval*self:GetAbility():GetSpecialValueFor("damage_per_second")

self.spell_damage = self:GetCaster():GetTalentValue("modifier_maiden_frostbite_6", "damage")

if not IsServer() then return end

self.damageTable = { victim = self:GetParent(), attacker = self:GetCaster(), damage = self.damage,  damage_type = DAMAGE_TYPE_MAGICAL, ability = self:GetAbility(), }

self.stun = 0


self.dispell = false
if kv.dispell and kv.dispell == 0 then 
  self.dispell = true


  self.silence_particle = ParticleManager:CreateParticle("particles/generic_gameplay/generic_silenced.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
  self:AddParticle(self.silence_particle, false, false, -1, true, false)

  self.ground_particle = ParticleManager:CreateParticle("particles/maiden_ground.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent())
  ParticleManager:SetParticleControlEnt(self.ground_particle, 0, self:GetParent(), PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
  ParticleManager:SetParticleControlEnt(self.ground_particle, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
  ParticleManager:SetParticleControlEnt(self.ground_particle, 5, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
  self:AddParticle(self.ground_particle, false, false, -1, true, false)
  self:GetParent():EmitSound("Maiden.Arcane_frostbite")


end

local mod =  self:GetParent():FindModifierByName("modifier_crystal_maiden_frostbite_custom_legendary_slow")

if mod and mod:GetStackCount() >= self:GetCaster():GetTalentValue("modifier_maiden_frostbite_7", 'max') then 

  self:GetParent():EmitSound("Maiden.Frostbite_stun")
  self:SetStackCount(1)
  self.stun = 1
end



self:GetParent():EmitSound("hero_Crystal.frostbite")
self:StartIntervalThink( self.interval )

end


function modifier_crystal_maiden_frostbite_custom:OnRefresh(table)
  self:OnCreated(table)
end



function modifier_crystal_maiden_frostbite_custom:OnDestroy()
if not IsServer() then return end
self:GetParent():StopSound("hero_Crystal.frostbite")
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_crystal_maiden_frostbite_custom:CheckState()

if self:GetStackCount() == 1 then 
  return 
  {
    [MODIFIER_STATE_STUNNED] = true,
    [MODIFIER_STATE_FROZEN] = true,
    [MODIFIER_STATE_SILENCED] = self.dispell,
  }
else 

  if self.dispell == true then 

    return 
    {
      [MODIFIER_STATE_DISARMED] = true,
      [MODIFIER_STATE_ROOTED] = true,
      [MODIFIER_STATE_SILENCED] = true,
    }
  else

    return 
    {
      [MODIFIER_STATE_DISARMED] = true,
      [MODIFIER_STATE_ROOTED] = true,
    }
  end 
end



end



function modifier_crystal_maiden_frostbite_custom:OnIntervalThink()
if not IsServer() then return end
  ApplyDamage( self.damageTable )
end



function modifier_crystal_maiden_frostbite_custom:GetEffectName()
  return "particles/units/heroes/hero_crystalmaiden/maiden_frostbite_buff.vpcf"
end

function modifier_crystal_maiden_frostbite_custom:GetEffectAttachType()
  return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_crystal_maiden_frostbite_custom:GetStatusEffectName()
if self.stun == 0 then return end
return "particles/status_fx/status_effect_frost.vpcf"
end

function modifier_crystal_maiden_frostbite_custom:StatusEffectPriority()
return 9999
end




function modifier_crystal_maiden_frostbite_custom:DeclareFunctions()
return
{
  MODIFIER_EVENT_ON_TAKEDAMAGE,
  MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
  MODIFIER_PROPERTY_DISABLE_HEALING
}
end

function modifier_crystal_maiden_frostbite_custom:GetModifierSpellAmplify_Percentage() 
if not self:GetCaster():HasModifier("modifier_maiden_frostbite_6") then return end
  return self.spell_damage
end

function modifier_crystal_maiden_frostbite_custom:GetDisableHealing()
if not IsServer() then return end
if self.stun == 0 then return end
  
  return 1
end



function modifier_crystal_maiden_frostbite_custom:OnTakeDamage(params)
if not IsServer() then return end
if not self:GetCaster():HasModifier("modifier_maiden_frostbite_2") then return end
if not params.attacker then return end
if self:GetCaster() ~= params.attacker then return end
if self:GetParent() ~= params.unit then return end
if params.unit:IsIllusion() then return end

local heal = self:GetAbility().damage_heal[self:GetCaster():GetUpgradeStack("modifier_maiden_frostbite_2")]*params.damage

my_game:GenericHeal(self:GetCaster(), heal, self:GetAbility(), true)


end



function modifier_crystal_maiden_frostbite_custom:OnDestroy()
if not IsServer() then return end
if true then return end
if not self:GetCaster():HasModifier("modifier_maiden_frostbite_6") then return end

self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_crystal_maiden_frostbite_custom_slow", {duration = (1 - self:GetParent():GetStatusResistance())*self:GetCaster():GetTalentValue("modifier_maiden_frostbite_6", "duration") })
end









modifier_crystal_maiden_frostbite_custom_tracker = class({})
function modifier_crystal_maiden_frostbite_custom_tracker:IsHidden() return true
end

function modifier_crystal_maiden_frostbite_custom_tracker:GetTexture() return "buffs/veil_amp" end

function modifier_crystal_maiden_frostbite_custom_tracker:IsPurgable() return false end
function modifier_crystal_maiden_frostbite_custom_tracker:OnCreated(table)
if not IsServer() then return end

self:StartIntervalThink(1)

end

function modifier_crystal_maiden_frostbite_custom_tracker:DeclareFunctions()
return
{
  MODIFIER_EVENT_ON_ATTACK_LANDED,
  MODIFIER_EVENT_ON_TAKEDAMAGE,
  MODIFIER_PROPERTY_MIN_HEALTH,
}
end



function modifier_crystal_maiden_frostbite_custom_tracker:OnAttackLanded(params)
if not IsServer() then return end
if not self:GetCaster():HasModifier("modifier_maiden_frostbite_6") then return end
if self:GetParent() ~= params.target then return end
if not params.attacker:IsHero() and not params.attacker:IsCreep() then return end
if params.attacker:HasModifier("modifier_crystal_maiden_frostbite_custom_attack_cd") then return end
if params.attacker:IsMagicImmune() then return end

local target = params.attacker



params.attacker:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_crystal_maiden_frostbite_custom_attack_cd", {duration = self:GetCaster():GetTalentValue("modifier_maiden_frostbite_6", "cd")})
params.attacker:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_crystal_maiden_frostbite_custom", { duration = self:GetCaster():GetTalentValue("modifier_maiden_frostbite_6", "proc_duration")*(1 - params.attacker:GetStatusResistance())})


end
  




function modifier_crystal_maiden_frostbite_custom_tracker:OnTakeDamage(params)
if not IsServer() then return end
if self:GetParent() ~= params.unit then return end
if self:GetParent() == params.attacker then return end


if not self:GetParent():HasModifier("modifier_maiden_frostbite_5") then return end
if self:GetParent():GetHealth() > 1 then return end
if self:GetParent():HasModifier("modifier_death") then return end
if self:GetParent():PassivesDisabled() then return end
if self:GetParent():HasModifier("modifier_crystal_maiden_frostbite_custom_lowhp_cd") then return end


self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_crystal_maiden_frostbite_custom_lowhp", {duration = self:GetAbility().lowhp_duration})
self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_crystal_maiden_frostbite_custom_lowhp_cd", {duration = self:GetAbility().lowhp_cd})

self:GetParent():Purge(false, true, false, true, false)
end


function modifier_crystal_maiden_frostbite_custom_tracker:GetMinHealth()
if not self:GetParent():HasModifier("modifier_maiden_frostbite_5") then return end
if not self:GetParent():IsAlive() then return end
if self:GetParent():HasModifier("modifier_death") then return end
if self:GetParent():PassivesDisabled() then return end
if self:GetParent():HasModifier("modifier_crystal_maiden_frostbite_custom_lowhp_cd")
and not self:GetParent():HasModifier("modifier_crystal_maiden_frostbite_custom_lowhp") then return end

return 1
end




function modifier_crystal_maiden_frostbite_custom_tracker:OnIntervalThink()
if not IsServer() then return end


if not self:GetParent():HasModifier("modifier_maiden_frostbite_7") then return end


self.radius = self:GetCaster():GetTalentValue("modifier_maiden_frostbite_7", "radius")

local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )


if #enemies > 0 and self.ring == nil and self:GetParent():IsAlive() then 

  self.ring = ParticleManager:CreateParticle("particles/maiden_radius.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
  ParticleManager:SetParticleControlEnt(self.ring, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
  ParticleManager:SetParticleControlEnt(self.ring, 1, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
  ParticleManager:SetParticleControl(self.ring, 2, Vector(self.radius, self.radius, self.radius ))
  self:AddParticle(self.ring,false, false, -1, false, false)

  self.effect_cast = ParticleManager:CreateParticle("particles/maiden_snow.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
  ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( self.radius, self.radius, 1 ) )
  self:AddParticle( self.effect_cast, false, false, -1, false, false )


  self:GetParent():EmitSound("Maiden.Frostbite_snow")
end


if (#enemies == 0 or not self:GetParent():IsAlive()) and self.ring ~= nil then 

  ParticleManager:DestroyParticle(self.ring, false)
  ParticleManager:ReleaseParticleIndex(self.ring)

  ParticleManager:DestroyParticle(self.effect_cast, false)
  ParticleManager:ReleaseParticleIndex(self.effect_cast)

  self.ring = nil
  self.effect_cast = nil

  self:GetParent():StopSound("Maiden.Frostbite_snow")
end

if not self:GetParent():IsAlive() then return end

for _,enemy in pairs(enemies) do

  local mod = enemy:FindModifierByName("modifier_crystal_maiden_frostbite_custom")

  if not mod or mod.stun == 0 then 
    enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_crystal_maiden_frostbite_custom_legendary_slow", {})
  end

end


self:StartIntervalThink(0.1)
end



modifier_crystal_maiden_frostbite_custom_attack_cd = class({})
function modifier_crystal_maiden_frostbite_custom_attack_cd:IsHidden() return true end
function modifier_crystal_maiden_frostbite_custom_attack_cd:IsPurgable() return false end
function modifier_crystal_maiden_frostbite_custom_attack_cd:RemoveOnDeath() return false end
function modifier_crystal_maiden_frostbite_custom_attack_cd:OnCreated()
self.RemoveForDuel = true
end








modifier_crystal_maiden_frostbite_custom_legendary_slow = class({})
function modifier_crystal_maiden_frostbite_custom_legendary_slow:IsHidden() return false end
function modifier_crystal_maiden_frostbite_custom_legendary_slow:IsPurgable() return false end
function modifier_crystal_maiden_frostbite_custom_legendary_slow:GetTexture() return "buffs/frostbite_slow" end



function modifier_crystal_maiden_frostbite_custom_legendary_slow:OnCreated(table)


self.slow = self:GetCaster():GetTalentValue("modifier_maiden_frostbite_7", "slow")
self.damage = self:GetCaster():GetTalentValue("modifier_maiden_frostbite_7", "damage")
self.max = self:GetCaster():GetTalentValue("modifier_maiden_frostbite_7", "max")
self.radius = self:GetCaster():GetTalentValue("modifier_maiden_frostbite_7", "radius")
self.interval = self:GetCaster():GetTalentValue("modifier_maiden_frostbite_7", "interval")

if not IsServer() then return end

self.effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_drow/drow_hypothermia_counter_stack.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, self:GetStackCount(), 0 ) )
self:AddParticle(self.effect_cast,false, false, -1, false, false)

self:StartIntervalThink(self.interval)
end


function modifier_crystal_maiden_frostbite_custom_legendary_slow:OnIntervalThink()
if not IsServer() then return end

if (self:GetParent():GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Length2D() > self.radius then 

  self:DecrementStackCount()

  if self.effect_cast == nil then 
    self.effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_drow/drow_hypothermia_counter_stack.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
    ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, self:GetStackCount(), 0 ) )
    self:AddParticle(self.effect_cast,false, false, -1, false, false)

    self:GetParent():RemoveModifierByName("modifier_crystal_maiden_frostbite_custom_max_slow")

    if self.mark then 
      ParticleManager:DestroyParticle(self.mark, false)
      ParticleManager:ReleaseParticleIndex(self.mark)
      self.mark = nil
    end
  end

  if self:GetStackCount() <= 0 then 
    self:Destroy()
  end

else 

  if self:GetStackCount() < self.max then 
    self:IncrementStackCount()

    if self:GetStackCount() >= self.max and self.mark == nil then 

      if self.effect_cast then 
        ParticleManager:DestroyParticle(self.effect_cast, false)
        ParticleManager:ReleaseParticleIndex(self.effect_cast)
        self.effect_cast = nil
      end

      self.mark = ParticleManager:CreateParticle( "particles/maiden_mark.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
      self:AddParticle(self.mark,false, false, -1, false, false)
      self:GetParent():EmitSound("Maiden.Frostbite_max_slow")

      self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_crystal_maiden_frostbite_custom_max_slow", {})
      
    end
  end
end

end


function modifier_crystal_maiden_frostbite_custom_legendary_slow:OnStackCountChanged(iStackCount)
if self:GetStackCount() == 0 then return end
if not self.effect_cast then return end 

ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, self:GetStackCount(), 0 ) )

end



function modifier_crystal_maiden_frostbite_custom_legendary_slow:OnDestroy()
if not IsServer() then return end

self:GetParent():RemoveModifierByName("modifier_crystal_maiden_frostbite_custom_max_slow")
end



function modifier_crystal_maiden_frostbite_custom_legendary_slow:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
  MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
  MODIFIER_PROPERTY_TOOLTIP
}
end


function modifier_crystal_maiden_frostbite_custom_legendary_slow:GetModifierIncomingDamage_Percentage()
local bonus = 0

return self.damage * self:GetStackCount() + bonus
end



function modifier_crystal_maiden_frostbite_custom_legendary_slow:GetModifierMoveSpeedBonus_Percentage()
return self:GetStackCount()*self.slow
end


function modifier_crystal_maiden_frostbite_custom_legendary_slow:OnTooltip()
return self.max
end



modifier_crystal_maiden_frostbite_custom_max_slow = class({})
function modifier_crystal_maiden_frostbite_custom_max_slow:IsHidden() return true end
function modifier_crystal_maiden_frostbite_custom_max_slow:IsPurgable() return false end


function modifier_crystal_maiden_frostbite_custom_max_slow:GetStatusEffectName()
return "particles/status_fx/status_effect_frost.vpcf"
end

function modifier_crystal_maiden_frostbite_custom_max_slow:StatusEffectPriority()
return 9999
end

function modifier_crystal_maiden_frostbite_custom_max_slow:GetEffectName() 
return "particles/maiden_frostbite_slow.vpcf"
end








modifier_crystal_maiden_frostbite_custom_resist = class({})
function modifier_crystal_maiden_frostbite_custom_resist:IsHidden() return false end
function modifier_crystal_maiden_frostbite_custom_resist:IsPurgable() return true end
function modifier_crystal_maiden_frostbite_custom_resist:GetTexture() return "buffs/frostbite_resist" end
function modifier_crystal_maiden_frostbite_custom_resist:OnCreated(table)
if not IsServer() then return end
  self.particle_peffect = ParticleManager:CreateParticle("particles/zeus_resist_stack.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())   
  ParticleManager:SetParticleControl(self.particle_peffect, 0, self:GetParent():GetAbsOrigin())
  self:AddParticle(self.particle_peffect, false, false, -1, false, true)
end



function modifier_crystal_maiden_frostbite_custom_resist:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
  MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING
}
end

function modifier_crystal_maiden_frostbite_custom_resist:GetModifierStatusResistanceStacking()
return self:GetAbility().resist_status[self:GetCaster():GetUpgradeStack("modifier_maiden_frostbite_1")]
end


function modifier_crystal_maiden_frostbite_custom_resist:GetModifierMagicalResistanceBonus()
return self:GetAbility().resist_magic[self:GetCaster():GetUpgradeStack("modifier_maiden_frostbite_1")]
end









modifier_crystal_maiden_frostbite_custom_lowhp = class({})
function modifier_crystal_maiden_frostbite_custom_lowhp:IsHidden() return false end
function modifier_crystal_maiden_frostbite_custom_lowhp:IsPurgable() return false end
function modifier_crystal_maiden_frostbite_custom_lowhp:GetTexture() return "buffs/arcane_lowhp" end


function modifier_crystal_maiden_frostbite_custom_lowhp:OnCreated(table)

self.heal = (self:GetAbility().lowhp_heal/100)*self:GetParent():GetMaxHealth()/self:GetAbility().lowhp_duration

if not IsServer() then return end

self:GetParent():EmitSound("Hero_Winter_Wyvern.ColdEmbrace") 
self.shallow_grave_particle = ParticleManager:CreateParticle("particles/econ/items/winter_wyvern/winter_wyvern_ti7/wyvern_cold_embrace_ti7buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControl( self.shallow_grave_particle, 0, self:GetParent():GetOrigin() ) 
ParticleManager:SetParticleControl( self.shallow_grave_particle, 1, self:GetParent():GetOrigin() ) 
ParticleManager:SetParticleControl( self.shallow_grave_particle, 2, self:GetParent():GetOrigin() ) 
self:AddParticle(self.shallow_grave_particle,false, false, -1, false, false)


self.interval = 0.5

self:StartIntervalThink(self.interval)
end



function modifier_crystal_maiden_frostbite_custom_lowhp:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT
}
end



function modifier_crystal_maiden_frostbite_custom_lowhp:OnIntervalThink()
if not IsServer() then return end

SendOverheadEventMessage(self:GetParent(), 10, self:GetParent(), self.interval*self.heal, nil)
end



function modifier_crystal_maiden_frostbite_custom_lowhp:GetModifierConstantHealthRegen()
  return self.heal
end

function modifier_crystal_maiden_frostbite_custom_lowhp:CheckState() return 
{
  [MODIFIER_STATE_STUNNED] = true,
  [MODIFIER_STATE_FROZEN] = true,
  [MODIFIER_STATE_INVULNERABLE] = true
}
end



modifier_crystal_maiden_frostbite_custom_lowhp_cd = class({})
function modifier_crystal_maiden_frostbite_custom_lowhp_cd:IsHidden() return false end
function modifier_crystal_maiden_frostbite_custom_lowhp_cd:IsPurgable() return false end
function modifier_crystal_maiden_frostbite_custom_lowhp_cd:IsDebuff() return true end
function modifier_crystal_maiden_frostbite_custom_lowhp_cd:RemoveOnDeath() return false end
function modifier_crystal_maiden_frostbite_custom_lowhp_cd:GetTexture() return "buffs/arcane_lowhp" end

function modifier_crystal_maiden_frostbite_custom_lowhp_cd:OnCreated(table)
self.RemoveForDuel = true
end





modifier_crystal_maiden_frostbite_custom_area = class({})
function modifier_crystal_maiden_frostbite_custom_area:IsHidden() return true end
function modifier_crystal_maiden_frostbite_custom_area:IsPurgable() return false end
function modifier_crystal_maiden_frostbite_custom_area:OnCreated(table)
if not IsServer() then return end

self.radius = self:GetAbility().aoe_radius

self.aoe_efx = ParticleManager:CreateParticle("particles/maiden_frostbite_area.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControl(self.aoe_efx, 1, Vector(0, 0, 100))
ParticleManager:SetParticleControl(self.aoe_efx, 5, Vector(self.radius, self.radius, self.radius))
self:AddParticle(self.aoe_efx,false, false, -1, false, false)

self:OnIntervalThink()
self:StartIntervalThink(self:GetAbility().aoe_interval)
end



function modifier_crystal_maiden_frostbite_custom_area:OnIntervalThink()
if not IsServer() then return end


local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )

local damage = self:GetAbility().aoe_damage[self:GetCaster():GetUpgradeStack("modifier_maiden_frostbite_4")]

for _,enemy in pairs(enemies) do 
  local damageTable = { victim = enemy, attacker = self:GetCaster(), damage = damage,  damage_type = DAMAGE_TYPE_MAGICAL, ability = self:GetAbility(), }

  SendOverheadEventMessage(enemy, 4, enemy, damage, nil)
  ApplyDamage(damageTable)

  enemy:EmitSound("Hero_Lich.IceAge.Damage")

  local damage = ParticleManager:CreateParticle("particles/units/heroes/hero_lich/lich_ice_age_debuff.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy)
  ParticleManager:ReleaseParticleIndex(damage)
end

if (self:GetCaster():GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D() <= self.radius then 
  my_game:GenericHeal(self:GetCaster(), damage*self:GetAbility().aoe_heal, self:GetAbility())
  local damage = ParticleManager:CreateParticle("particles/units/heroes/hero_lich/lich_ice_age_debuff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
  ParticleManager:ReleaseParticleIndex(damage)
end

self:GetParent():EmitSound("Maiden.Frostbite_aoe")


local damage_ring = ParticleManager:CreateParticle("particles/maiden_area_damage.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
ParticleManager:SetParticleControlEnt(damage_ring, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(damage_ring, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
ParticleManager:SetParticleControl(damage_ring, 2, Vector(100, 100, 100))
ParticleManager:ReleaseParticleIndex(damage_ring)


end










modifier_crystal_maiden_frostbite_custom_slow = class({})



function modifier_crystal_maiden_frostbite_custom_slow:IsPurgable() return true end
function modifier_crystal_maiden_frostbite_custom_slow:IsHidden() return false end
function modifier_crystal_maiden_frostbite_custom_slow:GetTexture() return "buffs/frostbite_slow_cast" end

function modifier_crystal_maiden_frostbite_custom_slow:DeclareFunctions()
return 
{
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
}
end



function modifier_crystal_maiden_frostbite_custom_slow:GetModifierAttackSpeedBonus_Constant()
  return self.speed
end


function modifier_crystal_maiden_frostbite_custom_slow:GetStatusEffectName()
return "particles/status_fx/status_effect_frost.vpcf"
end

function modifier_crystal_maiden_frostbite_custom_slow:StatusEffectPriority()
return 9999
end

function modifier_crystal_maiden_frostbite_custom_slow:OnCreated()
self.damage = self:GetCaster():GetTalentValue("modifier_maiden_frostbite_6", "speed")
end 





modifier_crystal_maiden_frostbite_custom_health = class({})
function modifier_crystal_maiden_frostbite_custom_health:IsHidden() return false
end

function modifier_crystal_maiden_frostbite_custom_health:GetTexture() return "buffs/veil_amp" end

function modifier_crystal_maiden_frostbite_custom_health:IsPurgable() return false end
function modifier_crystal_maiden_frostbite_custom_health:RemoveOnDeath() return false end
function modifier_crystal_maiden_frostbite_custom_health:OnCreated(table)
if not IsServer() then return end

self:OnIntervalThink()
self:StartIntervalThink(3)
end


function modifier_crystal_maiden_frostbite_custom_health:OnIntervalThink()
if not IsServer() then return end

self:GetCaster():CalculateStatBonus(true)
end 


function modifier_crystal_maiden_frostbite_custom_health:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_HEALTH_BONUS,
  MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
}
end


function modifier_crystal_maiden_frostbite_custom_health:GetModifierHealthBonus()
if not self:GetParent():HasModifier("modifier_maiden_frostbite_3") then return end 

return self:GetParent():GetMaxMana()/self:GetCaster():GetTalentValue("modifier_maiden_frostbite_3", "mana")
end 

function modifier_crystal_maiden_frostbite_custom_health:GetModifierPhysicalArmorBonus()
if not self:GetParent():HasModifier("modifier_maiden_frostbite_3") then return end 

return (self:GetParent():GetMaxMana()/self:GetCaster():GetTalentValue("modifier_maiden_frostbite_3", "mana"))*self:GetCaster():GetTalentValue("modifier_maiden_frostbite_3", "armor")
end
 