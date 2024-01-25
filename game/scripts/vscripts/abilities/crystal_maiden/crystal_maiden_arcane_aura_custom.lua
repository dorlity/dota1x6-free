LinkLuaModifier( "modifier_crystal_maiden_arcane_aura_custom", "abilities/crystal_maiden/crystal_maiden_arcane_aura_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_crystal_maiden_arcane_aura_custom_buff", "abilities/crystal_maiden/crystal_maiden_arcane_aura_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_crystal_maiden_arcane_aura_custom_mana", "abilities/crystal_maiden/crystal_maiden_arcane_aura_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_crystal_maiden_arcane_aura_custom_shield", "abilities/crystal_maiden/crystal_maiden_arcane_aura_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_crystal_maiden_arcane_aura_custom_speed", "abilities/crystal_maiden/crystal_maiden_arcane_aura_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_crystal_maiden_arcane_aura_custom_slow", "abilities/crystal_maiden/crystal_maiden_arcane_aura_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_crystal_maiden_arcane_aura_custom_slow_speed", "abilities/crystal_maiden/crystal_maiden_arcane_aura_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_crystal_maiden_arcane_aura_custom_shield_tracker", "abilities/crystal_maiden/crystal_maiden_arcane_aura_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_crystal_maiden_arcane_aura_custom_spell", "abilities/crystal_maiden/crystal_maiden_arcane_aura_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_crystal_maiden_arcane_aura_custom_spell_count", "abilities/crystal_maiden/crystal_maiden_arcane_aura_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_crystal_maiden_arcane_aura_custom_shard", "abilities/crystal_maiden/crystal_maiden_arcane_aura_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_crystal_maiden_arcane_aura_custom_damage", "abilities/crystal_maiden/crystal_maiden_arcane_aura_custom", LUA_MODIFIER_MOTION_NONE )







crystal_maiden_arcane_aura_custom = class({})







function crystal_maiden_arcane_aura_custom:Precache(context)

PrecacheResource( "particle", "particles/maiden_shield_active.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_ancient_apparition/ancient_apparition_chilling_touch_projectile.vpcf", context )
PrecacheResource( "particle", "particles/econ/items/crystal_maiden/ti9_immortal_staff/cm_ti9_staff_lvlup_globe.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_oracle/oracle_purifyingflames.vpcf", context )
PrecacheResource( "particle", "particles/items5_fx/maiden_shield_start.vpcf", context )
PrecacheResource( "particle", "particles/maiden_shield.vpcf", context )
PrecacheResource( "particle", "particles/status_fx/status_effect_frost.vpcf", context )
PrecacheResource( "particle", "particles/maiden_arcane.vpcf", context )
PrecacheResource( "particle", "particles/maiden_spells.vpcf", context )
PrecacheResource( "particle", "particles/zuus_speed.vpcf", context )

end



function crystal_maiden_arcane_aura_custom:OnInventoryContentsChanged()

local ability = self:GetCaster():FindAbilityByName("crystal_maiden_crystal_clone")

if ability and self:GetCaster():HasShard() then 
  ability:SetHidden(true)
end 

end


function crystal_maiden_arcane_aura_custom:GetBehavior()

local auto = 0

if self:GetCaster():HasModifier("modifier_maiden_arcane_6") then 
  auto = DOTA_ABILITY_BEHAVIOR_AUTOCAST
end 

if self:GetCaster():HasShard() then
  return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_MOVEMENT + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING + DOTA_ABILITY_BEHAVIOR_IGNORE_CHANNEL + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + auto
end
return DOTA_ABILITY_BEHAVIOR_PASSIVE + auto
end



function crystal_maiden_arcane_aura_custom:GetCooldown(iLevel)
if self:GetCaster():HasShard() then
  return self:GetSpecialValueFor("cd")
end

return
end

function crystal_maiden_arcane_aura_custom:GetManaCost(iLevel)
if self:GetCaster():HasShard() then
  return self:GetSpecialValueFor("mana")
end

return

end 



function crystal_maiden_arcane_aura_custom:GetCastAnimation()
return ACT_DOTA_CAST_ABILITY_5
end


function crystal_maiden_arcane_aura_custom:GetIntrinsicModifierName()
  return "modifier_crystal_maiden_arcane_aura_custom"
end



function crystal_maiden_arcane_aura_custom:OnSpellStart()
if not IsServer() then return end

local ability = self:GetCaster():FindAbilityByName("crystal_maiden_crystal_clone")

if not ability then return end  
local caster = self:GetCaster()

ability:OnSpellStart()
caster:StartGesture(ACT_DOTA_CAST_ABILITY_5)

Timers:CreateTimer(0.1, function()

  local copy = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 500, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, 0, false )

  for _,unit in pairs(copy) do 
    if unit:HasModifier("modifier_crystal_maiden_crystal_clone_statue") then 
      unit:AddNewModifier(caster, self, "modifier_crystal_maiden_arcane_aura_custom_shard", {})
      break
    end 
  end 

end)


end




modifier_crystal_maiden_arcane_aura_custom = class({})

function modifier_crystal_maiden_arcane_aura_custom:IsHidden() return true end
function modifier_crystal_maiden_arcane_aura_custom:IsPurgable() return false end 


function modifier_crystal_maiden_arcane_aura_custom:GetAuraRadius()
  return 
end

function modifier_crystal_maiden_arcane_aura_custom:GetAuraSearchFlags()
  return DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD
end

function modifier_crystal_maiden_arcane_aura_custom:GetAuraSearchTeam()

  return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_crystal_maiden_arcane_aura_custom:GetAuraSearchType()

  return DOTA_UNIT_TARGET_HERO 
end


function modifier_crystal_maiden_arcane_aura_custom:GetModifierAura()
  return "modifier_crystal_maiden_arcane_aura_custom_buff"
end

function modifier_crystal_maiden_arcane_aura_custom:IsAura()
  if self:GetParent():PassivesDisabled() then
    return false
  end

  return true
end





function modifier_crystal_maiden_arcane_aura_custom:DeclareFunctions()
return
{
  MODIFIER_EVENT_ON_TAKEDAMAGE,
  MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
  MODIFIER_EVENT_ON_ATTACK_LANDED,
  MODIFIER_PROPERTY_MANACOST_PERCENTAGE,
  MODIFIER_PROPERTY_MANA_REGEN_TOTAL_PERCENTAGE,
  MODIFIER_PROPERTY_PROJECTILE_NAME,
  MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND,
  MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS,
  MODIFIER_EVENT_ON_ATTACK,
  MODIFIER_EVENT_ON_ATTACK_START,
  MODIFIER_EVENT_ON_ATTACK_FAIL,
  MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
  MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,

}
end

function modifier_crystal_maiden_arcane_aura_custom:GetModifierAttackRangeBonus()
if not self:GetParent():HasModifier("modifier_maiden_arcane_4") then return end
return self:GetCaster():GetTalentValue("modifier_maiden_arcane_4", "range")
end


function modifier_crystal_maiden_arcane_aura_custom:GetAttackSound(params)
if not self.proc then return end

return "Maiden.Arcane_legendary_attack"
end



function modifier_crystal_maiden_arcane_aura_custom:GetModifierProjectileSpeedBonus()
if not self.proc then return end

return self.legendary_speed
end



function modifier_crystal_maiden_arcane_aura_custom:OnAttackStart(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end
if params.no_attack_cooldown then return end 

if not self:GetParent():HasModifier("modifier_maiden_arcane_7") then return end

self.proc = nil

if not params.target:IsCreep() and not params.target:IsHero() then return end
if params.target:IsMagicImmune() then return end
if self:GetParent():GetMana() < self:GetParent():GetMaxMana()*self.legendary_mana then return end

self.proc = true


end



function modifier_crystal_maiden_arcane_aura_custom:OnAttack(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end
if params.no_attack_cooldown then return end 

local mod = self:GetCaster():FindModifierByName("modifier_crystal_maiden_arcane_aura_custom_speed")
if mod then 
  mod:DecrementStackCount()
  if mod:GetStackCount() == 0 then 
    mod:Destroy()
  end
end


if not self:GetParent():HasModifier("modifier_maiden_arcane_7") then return end


self:StartIntervalThink(self.legendary_cd)
self.attack = true

if not self.proc then return end

local damage = self:GetParent():GetMaxMana()*self.legendary_mana
self:GetParent():SetMana(math.max(1, self:GetParent():GetMana() - damage))

local projectile =
{
  Target = params.target,
  Source = self:GetParent(),
  Ability = self:GetAbility(),
  EffectName = "particles/units/heroes/hero_ancient_apparition/ancient_apparition_chilling_touch_projectile.vpcf",
  iMoveSpeed = self:GetParent():GetProjectileSpeed(),
  vSourceLoc = self:GetParent():GetAbsOrigin(),
  bDodgeable = true,
  bProvidesVision = false,
}

local hProjectile = ProjectileManager:CreateTrackingProjectile( projectile )

self.record[params.record] = true
end



function modifier_crystal_maiden_arcane_aura_custom:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end
if not params.target:IsCreep() and not params.target:IsHero() then return end


if self:GetParent():HasModifier("modifier_maiden_arcane_3") then 
  params.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_crystal_maiden_arcane_aura_custom_slow", {duration = self.slow_duration})
end


if self:GetParent():HasModifier("modifier_maiden_arcane_6") and not params.no_attack_cooldown then

  if self:GetParent():HasModifier("modifier_crystal_maiden_arcane_aura_custom_spell") then 
    self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_crystal_maiden_arcane_aura_custom_spell", {duration = self.spell_duration})
  else 
    self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(),"modifier_crystal_maiden_arcane_aura_custom_spell_count", {duration = self.spell_duration})
  end
end


if self:GetCaster():HasModifier("modifier_maiden_arcane_2") then 
  self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(),"modifier_crystal_maiden_arcane_aura_custom_damage", {duration = self.damage_duration})
end 

if not self:GetParent():HasModifier("modifier_maiden_arcane_7") then return end

if not self.record[params.record] then return end


local damage = self:GetParent():GetMaxMana()*self.legendary_mana*self.legendary_damage

if not params.target:IsMagicImmune() then 
  local real_damage = ApplyDamage({ victim = params.target, attacker = self:GetCaster(), damage = damage,  damage_type = DAMAGE_TYPE_MAGICAL, ability = self:GetAbility(), })

  SendOverheadEventMessage(params.target, 4, params.target, real_damage, nil)

  params.target:EmitSound("Maiden.Arcane_legendary_attack_end")
end

self.record[params.record] = nil
end





function modifier_crystal_maiden_arcane_aura_custom:OnAttackFail(params)
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_maiden_arcane_7") then return end
if self:GetParent() ~= params.attacker then return end
if not self.record[params.record] then return end

self.record[params.record] = nil
end






function modifier_crystal_maiden_arcane_aura_custom:OnTakeDamage(params)
if not IsServer() then return end
if self:GetParent() ~= params.unit then return end
if self:GetParent() == params.attacker then return end


if self:GetParent():HasModifier("modifier_crystal_maiden_arcane_aura_custom_shield_tracker") then 
  self:GetParent():FindModifierByName("modifier_crystal_maiden_arcane_aura_custom_shield_tracker"):StartIntervalThink(self.shield_cd)
end


end

function modifier_crystal_maiden_arcane_aura_custom:GetModifierPercentageManacost()
if not self:GetParent():HasModifier("modifier_maiden_arcane_7") then return end

return 100
end







function modifier_crystal_maiden_arcane_aura_custom:OnAbilityFullyCast(keys)
if not IsServer() then return end
if not keys.ability then return end 
if keys.unit ~= self:GetParent() then return end
if self:GetParent():PassivesDisabled() then return end
if keys.ability:IsItem() or  UnvalidAbilities[keys.ability:GetName()] then return end

if self:GetParent():HasModifier("modifier_maiden_arcane_4") then 
  self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_crystal_maiden_arcane_aura_custom_speed", {duration = self.speed_duration})
end

if self:GetParent():HasModifier("modifier_maiden_arcane_3") then 
  self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_crystal_maiden_arcane_aura_custom_slow_speed", {duration = self.slow_duration})
end



if not self:GetParent():HasModifier("modifier_maiden_arcane_1") then return end
self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_crystal_maiden_arcane_aura_custom_mana", {duration = self.heal_duration})

end



function modifier_crystal_maiden_arcane_aura_custom:GetModifierTotalPercentageManaRegen()
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_maiden_arcane_7") then return end
if self.attack == true then return end

return self.legendary_regen 
end


function modifier_crystal_maiden_arcane_aura_custom:OnCreated(table)
self.attack = false
self.proc = nil
self.record = {}

self.legendary_mana = self:GetCaster():GetTalentValue("modifier_maiden_arcane_7", "mana", true)/100
self.legendary_damage = self:GetCaster():GetTalentValue("modifier_maiden_arcane_7", "damage", true)/100
self.legendary_cd = self:GetCaster():GetTalentValue("modifier_maiden_arcane_7", "cd", true)
self.legendary_speed = self:GetCaster():GetTalentValue("modifier_maiden_arcane_7", "speed", true)
self.legendary_regen = self:GetCaster():GetTalentValue("modifier_maiden_arcane_7", "regen", true)

self.shield_cd = self:GetCaster():GetTalentValue("modifier_maiden_arcane_5", "cd", true)

self.spell_duration = self:GetCaster():GetTalentValue("modifier_maiden_arcane_6", "duration" ,true)

self.slow_duration = self:GetCaster():GetTalentValue("modifier_maiden_arcane_3", "duration",true)

self.speed_duration = self:GetCaster():GetTalentValue("modifier_maiden_arcane_4", "duration",true)

self.heal_duration = self:GetCaster():GetTalentValue("modifier_maiden_arcane_1", "duration",true)

self.damage_duration = self:GetCaster():GetTalentValue("modifier_maiden_arcane_2", "duration",true)
end





function modifier_crystal_maiden_arcane_aura_custom:OnIntervalThink()
if not IsServer() then return end


local pfx = ParticleManager:CreateParticle("particles/econ/items/crystal_maiden/ti9_immortal_staff/cm_ti9_staff_lvlup_globe.vpcf", PATTACH_POINT_FOLLOW, self:GetCaster())
ParticleManager:SetParticleControlEnt(pfx, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
ParticleManager:SetParticleControl(pfx, 5, Vector(1,1,1))
ParticleManager:ReleaseParticleIndex(pfx)

self:GetParent():EmitSound("Maiden.Arcane_legendary_regen")
self.attack = false
self:StartIntervalThink(-1)
end





modifier_crystal_maiden_arcane_aura_custom_buff = class({})
function modifier_crystal_maiden_arcane_aura_custom_buff:IsHidden() return true end
function modifier_crystal_maiden_arcane_aura_custom_buff:IsPurgable() return false end



function modifier_crystal_maiden_arcane_aura_custom_buff:OnCreated(table)
if not IsServer() then return end

self.int = 0 

if self:GetParent() ~= self:GetCaster() then return end

self:StartIntervalThink(0.5)
end


function modifier_crystal_maiden_arcane_aura_custom_buff:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
}
end

function modifier_crystal_maiden_arcane_aura_custom_buff:GetModifierConstantManaRegen()
return self:GetAbility():GetSpecialValueFor("base_mana_regen")*self:GetParent():GetMaxMana()/100
end




function modifier_crystal_maiden_arcane_aura_custom_buff:OnIntervalThink()
if not IsServer() then return end 
self.PercentInt = self:GetAbility():GetSpecialValueFor("int_bonus")/100
end 






modifier_crystal_maiden_arcane_aura_custom_mana = class({})
function modifier_crystal_maiden_arcane_aura_custom_mana:IsHidden() return false end
function modifier_crystal_maiden_arcane_aura_custom_mana:IsPurgable() return false end
function modifier_crystal_maiden_arcane_aura_custom_mana:GetTexture() return "buffs/arcane_regen" end

function modifier_crystal_maiden_arcane_aura_custom_mana:OnCreated(table)

self.heal = self:GetParent():GetMaxMana()*(self:GetCaster():GetTalentValue("modifier_maiden_arcane_1", "mana")/100)/self:GetCaster():GetTalentValue("modifier_maiden_arcane_1", "duration")

end

function modifier_crystal_maiden_arcane_aura_custom_mana:OnRefresh(table)
self:OnCreated(table)
end


function modifier_crystal_maiden_arcane_aura_custom_mana:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
  MODIFIER_PROPERTY_MANA_REGEN_CONSTANT
}
end


function modifier_crystal_maiden_arcane_aura_custom_mana:GetEffectName() return "particles/units/heroes/hero_oracle/oracle_purifyingflames.vpcf" end

function modifier_crystal_maiden_arcane_aura_custom_mana:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

function modifier_crystal_maiden_arcane_aura_custom_mana:GetModifierConstantManaRegen()
return self.heal
end


function modifier_crystal_maiden_arcane_aura_custom_mana:GetModifierConstantHealthRegen()
return self.heal
end



modifier_crystal_maiden_arcane_aura_custom_shield = class({})
function modifier_crystal_maiden_arcane_aura_custom_shield:IsHidden() return false end
function modifier_crystal_maiden_arcane_aura_custom_shield:IsPurgable() return false end
function modifier_crystal_maiden_arcane_aura_custom_shield:GetTexture() return "buffs/arcane_shield" end

function modifier_crystal_maiden_arcane_aura_custom_shield:OnCreated(table)

self.shield_damage = self:GetCaster():GetTalentValue("modifier_maiden_arcane_5", "damage", true)/100
self.shield_cd = self:GetCaster():GetTalentValue("modifier_maiden_arcane_5", "cd", true)
self.shield_resist = self:GetCaster():GetTalentValue("modifier_maiden_arcane_5", "status", true)

if not IsServer() then return end
self:SetStackCount(table.mana)
self.shield = self:GetStackCount()
self.max_shield = self.shield

self:GetCaster():EmitSound("Maiden.Arcane_shield_loop")

self.particle_peffect = ParticleManager:CreateParticle("particles/items5_fx/maiden_shield_start.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
ParticleManager:SetParticleControl(self.particle_peffect, 0, self:GetCaster():GetAbsOrigin())
self:AddParticle(self.particle_peffect,false, false, -1, false, false)


self.pfx = ParticleManager:CreateParticle("particles/maiden_shield.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControlEnt(self.pfx, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "", self:GetParent():GetAbsOrigin(), false)
ParticleManager:SetParticleControl(self.pfx, 2, Vector(110,110,110))
self:AddParticle(self.pfx,false, false, -1, false, false)

self:SetHasCustomTransmitterData(true)
end


function modifier_crystal_maiden_arcane_aura_custom_shield:OnRefresh(table)
if not IsServer() then return end

self:SetStackCount(table.mana)
self.shield = self:GetStackCount()
self.max_shield = self.shield

self:SendBuffRefreshToClients()
end

function modifier_crystal_maiden_arcane_aura_custom_shield:OnDestroy()
if not IsServer() then return end
self:GetCaster():EmitSound("Maiden.Arcane_shield_end")

if self:GetParent():HasModifier("modifier_crystal_maiden_arcane_aura_custom_shield_tracker") then 
  self:GetParent():FindModifierByName("modifier_crystal_maiden_arcane_aura_custom_shield_tracker"):StartIntervalThink(self.shield_cd)
end

self:GetCaster():StopSound("Maiden.Arcane_shield_loop")
end




function modifier_crystal_maiden_arcane_aura_custom_shield:AddCustomTransmitterData() return 
{
  max_shield = self.max_shield,
} 
end

function modifier_crystal_maiden_arcane_aura_custom_shield:HandleCustomTransmitterData(data)
  self.max_shield  = data.max_shield
end


function modifier_crystal_maiden_arcane_aura_custom_shield:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_INCOMING_DAMAGE_CONSTANT,
    MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
    MODIFIER_PROPERTY_TOOLTIP
}

end
function modifier_crystal_maiden_arcane_aura_custom_shield:GetStatusEffectName()
return "particles/status_fx/status_effect_frost.vpcf"
end

function modifier_crystal_maiden_arcane_aura_custom_shield:StatusEffectPriority()
return 9999
end

function modifier_crystal_maiden_arcane_aura_custom_shield:GetModifierStatusResistanceStacking()
return self.shield_resist
end

function modifier_crystal_maiden_arcane_aura_custom_shield:OnTooltip()
return self.shield_damage*100
end






function modifier_crystal_maiden_arcane_aura_custom_shield:GetModifierIncomingDamageConstant( params )


if IsClient() then 
  if params.report_max then 
    return self.max_shield
  else 
    return self:GetStackCount()
  end 
end

if not IsServer() then return end

local damage = self.shield_damage*params.damage

self:GetParent():EmitSound("Hero_Lich.ProjectileImpact")

if self:GetStackCount() > damage then
    self:SetStackCount(self:GetStackCount() - damage)
    local i = damage
    return -i
else
    
    local i = self:GetStackCount()
    self:SetStackCount(0)
    self:Destroy()
    return -i
end

end








modifier_crystal_maiden_arcane_aura_custom_speed = class({})
function modifier_crystal_maiden_arcane_aura_custom_speed:IsHidden() return false end
function modifier_crystal_maiden_arcane_aura_custom_speed:IsPurgable() return false end
function modifier_crystal_maiden_arcane_aura_custom_speed:GetTexture() return "buffs/arcane_speed" end

function modifier_crystal_maiden_arcane_aura_custom_speed:OnCreated(table)

self.speed = self:GetCaster():GetTalentValue("modifier_maiden_arcane_4", "speed")


if not IsServer() then return end 


self:SetStackCount(self:GetCaster():GetTalentValue("modifier_maiden_arcane_4", "attacks"))
end


function modifier_crystal_maiden_arcane_aura_custom_speed:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
}
end

function modifier_crystal_maiden_arcane_aura_custom_speed:GetModifierAttackSpeedBonus_Constant()
return self.speed
end


function modifier_crystal_maiden_arcane_aura_custom_speed:CheckState()
return
{
  [MODIFIER_STATE_CANNOT_MISS] = true
}
end






modifier_crystal_maiden_arcane_aura_custom_slow = class({})


function modifier_crystal_maiden_arcane_aura_custom_slow:IsHidden()
  return false
end

function modifier_crystal_maiden_arcane_aura_custom_slow:IsPurgable()
  return true
end

function modifier_crystal_maiden_arcane_aura_custom_slow:GetTexture()
  return "buffs/arcane_slow"
end


function modifier_crystal_maiden_arcane_aura_custom_slow:DeclareFunctions()
  local funcs = {
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
  }

  return funcs
end

function modifier_crystal_maiden_arcane_aura_custom_slow:GetModifierMoveSpeedBonus_Percentage()
  return self.slow
end



function modifier_crystal_maiden_arcane_aura_custom_slow:GetStatusEffectName()
return "particles/status_fx/status_effect_frost.vpcf"
end

function modifier_crystal_maiden_arcane_aura_custom_slow:StatusEffectPriority()
return 9999
end



function modifier_crystal_maiden_arcane_aura_custom_slow:OnCreated()

self.slow = self:GetCaster():GetTalentValue("modifier_maiden_arcane_3", "slow")
end 







modifier_crystal_maiden_arcane_aura_custom_slow_speed = class({})


function modifier_crystal_maiden_arcane_aura_custom_slow_speed:IsHidden()
  return true
end

function modifier_crystal_maiden_arcane_aura_custom_slow_speed:IsPurgable()
  return true
end

function modifier_crystal_maiden_arcane_aura_custom_slow_speed:GetTexture()
  return "buffs/arcane_slow"
end


function modifier_crystal_maiden_arcane_aura_custom_slow_speed:DeclareFunctions()
  local funcs = {
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
  }

  return funcs
end

function modifier_crystal_maiden_arcane_aura_custom_slow_speed:GetModifierMoveSpeedBonus_Percentage()
  return self.speed
end



function modifier_crystal_maiden_arcane_aura_custom_slow_speed:GetEffectName()
  return "particles/zuus_speed.vpcf"
end

function modifier_crystal_maiden_arcane_aura_custom_slow_speed:OnCreated()

self.speed = self:GetCaster():GetTalentValue("modifier_maiden_arcane_3", "speed")
end 




modifier_crystal_maiden_arcane_aura_custom_shield_tracker = class({})
function modifier_crystal_maiden_arcane_aura_custom_shield_tracker:IsHidden() return true end
function modifier_crystal_maiden_arcane_aura_custom_shield_tracker:IsPurgable() return false end
function modifier_crystal_maiden_arcane_aura_custom_shield_tracker:RemoveOnDeath() return false end
function modifier_crystal_maiden_arcane_aura_custom_shield_tracker:OnCreated(table)
if not IsServer() then return end

self.shield_cd = self:GetCaster():GetTalentValue("modifier_maiden_arcane_5", "cd", true)
self.shield_mana = self:GetCaster():GetTalentValue("modifier_maiden_arcane_5", "mana", true)/100

self:OnIntervalThink()
self:StartIntervalThink(self.shield_cd)
end


function modifier_crystal_maiden_arcane_aura_custom_shield_tracker:OnIntervalThink()
if not IsServer() then return end
if not self:GetParent():IsAlive() then return end

local mana = math.floor(self:GetCaster():GetMaxMana()*self.shield_mana)


local mod = self:GetParent():FindModifierByName("modifier_crystal_maiden_arcane_aura_custom_shield")


if mod and mod:GetStackCount() >= mana then 
  return 
end

SendOverheadEventMessage(self:GetCaster(), 11, self:GetCaster(), mana, nil)

self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_crystal_maiden_arcane_aura_custom_shield", {mana = mana})

local pfx = ParticleManager:CreateParticle("particles/maiden_arcane.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
ParticleManager:ReleaseParticleIndex(pfx)

self:GetCaster():EmitSound("Maiden.Arcane_shield")
self:GetCaster():EmitSound("Maiden.Arcane_shield_2")

end







modifier_crystal_maiden_arcane_aura_custom_shard = class({})
function modifier_crystal_maiden_arcane_aura_custom_shard:IsHidden() return false end
function modifier_crystal_maiden_arcane_aura_custom_shard:IsPurgable() return false end
function modifier_crystal_maiden_arcane_aura_custom_shard:OnCreated()


end 

function modifier_crystal_maiden_arcane_aura_custom_shard:OnDestroy()
if not IsServer() then return end

local ability = self:GetCaster():FindAbilityByName("crystal_maiden_frostbite_custom")

local shard = self:GetCaster():FindAbilityByName("crystal_maiden_crystal_clone")

if not shard then return end 
if not ability then return end 
if not ability:IsTrained() then return end 

local enemies = self:GetCaster():FindTargets(shard:GetSpecialValueFor("frostbite_radius"), self:GetParent():GetAbsOrigin()) 

for _,unit in pairs(enemies) do
  unit:AddNewModifier(self:GetCaster(), ability, "modifier_crystal_maiden_frostbite_custom", {duration = shard:GetSpecialValueFor("duration")*(1 - unit:GetStatusResistance())})
end

end 









modifier_crystal_maiden_arcane_aura_custom_damage = class({})
function modifier_crystal_maiden_arcane_aura_custom_damage:IsHidden() return false end
function modifier_crystal_maiden_arcane_aura_custom_damage:IsPurgable() return false end
function modifier_crystal_maiden_arcane_aura_custom_damage:GetTexture() return "buffs/arcane_damage" end
function modifier_crystal_maiden_arcane_aura_custom_damage:OnCreated(table)

self.damage = self:GetCaster():GetTalentValue("modifier_maiden_arcane_2", "damage")
self.max = self:GetCaster():GetTalentValue("modifier_maiden_arcane_2", "max")

if not IsServer() then return end

self:SetStackCount(1)
end

function modifier_crystal_maiden_arcane_aura_custom_damage:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end

self:IncrementStackCount()
end

function modifier_crystal_maiden_arcane_aura_custom_damage:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
}
end



function modifier_crystal_maiden_arcane_aura_custom_damage:GetModifierSpellAmplify_Percentage()

  return self.damage*self:GetStackCount()
end










modifier_crystal_maiden_arcane_aura_custom_spell = class({})
function modifier_crystal_maiden_arcane_aura_custom_spell:IsHidden() return true end
function modifier_crystal_maiden_arcane_aura_custom_spell:IsPurgable() return false end
function modifier_crystal_maiden_arcane_aura_custom_spell:GetTexture() return "buffs/arcane_spells" end

function modifier_crystal_maiden_arcane_aura_custom_spell:OnCreated(table)
if not IsServer() then return end

CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), 'crystal_attack_change',  {max = self:GetCaster():GetTalentValue("modifier_maiden_arcane_6", "attacks"), damage = self:GetCaster():GetTalentValue("modifier_maiden_arcane_6", "attacks")})

self.nFXIndex = ParticleManager:CreateParticle("particles/maiden_spells.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControl(self.nFXIndex, 0, self:GetParent():GetOrigin())
self:AddParticle(self.nFXIndex, false, false, 1, true, false)
end 



function modifier_crystal_maiden_arcane_aura_custom_spell:OnDestroy()
if not IsServer() then return end
CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), 'crystal_attack_change',  {max = self:GetCaster():GetTalentValue("modifier_maiden_arcane_6", "attacks"), damage = 0})

end 


modifier_crystal_maiden_arcane_aura_custom_spell_count = class({})
function modifier_crystal_maiden_arcane_aura_custom_spell_count:IsHidden() return true end
function modifier_crystal_maiden_arcane_aura_custom_spell_count:IsPurgable() return false end
function modifier_crystal_maiden_arcane_aura_custom_spell_count:GetTexture() return "buffs/arcane_spells" end
function modifier_crystal_maiden_arcane_aura_custom_spell_count:OnCreated()
self.max = self:GetCaster():GetTalentValue("modifier_maiden_arcane_6", "attacks")

if not IsServer() then return end 
self:SetStackCount(1)

end 

function modifier_crystal_maiden_arcane_aura_custom_spell_count:OnRefresh()
if not IsServer() then return end 

self:IncrementStackCount()

if self:GetStackCount() >= self.max then 

  self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_crystal_maiden_arcane_aura_custom_spell", {duration = self:GetCaster():GetTalentValue("modifier_maiden_arcane_6", "duration")})

  local particle_peffect = ParticleManager:CreateParticle("particles/maiden_shield_active.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
  ParticleManager:SetParticleControl(particle_peffect, 0, self:GetCaster():GetAbsOrigin())
  ParticleManager:SetParticleControl(particle_peffect, 2, self:GetCaster():GetAbsOrigin())
  ParticleManager:ReleaseParticleIndex(particle_peffect)

  self:GetCaster():EmitSound("Lina.Array_triple")

  self:Destroy()
end

end 

function modifier_crystal_maiden_arcane_aura_custom_spell_count:OnStackCountChanged(iStackCount)
if not IsServer() then return end 

CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), 'crystal_attack_change',  {max = self.max, damage = self:GetStackCount()})
end


function modifier_crystal_maiden_arcane_aura_custom_spell_count:OnDestroy()
if not IsServer() then return end

if self:GetStackCount() < self.max then 
  CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), 'crystal_attack_change',  {max = self.max, damage = 0})
end 

end 