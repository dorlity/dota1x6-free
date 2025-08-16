LinkLuaModifier( "modifier_leshrac_pulse_nova_custom", "abilities/leshrac/leshrac_pulse_nova_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_leshrac_pulse_nova_custom_reduce", "abilities/leshrac/leshrac_pulse_nova_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_leshrac_pulse_nova_custom_legendary", "abilities/leshrac/leshrac_pulse_nova_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_leshrac_pulse_nova_custom_tracker", "abilities/leshrac/leshrac_pulse_nova_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_leshrac_pulse_nova_custom_status", "abilities/leshrac/leshrac_pulse_nova_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_leshrac_pulse_nova_custom_low_mana", "abilities/leshrac/leshrac_pulse_nova_custom", LUA_MODIFIER_MOTION_NONE )



leshrac_pulse_nova_custom = class({})



function leshrac_pulse_nova_custom:CreateTalent()

local ability = self:GetCaster():FindAbilityByName("leshrac_pulse_nova_custom_legendary")
ability:SetHidden(false)
end



function leshrac_pulse_nova_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end

PrecacheResource( "particle", "particles/units/heroes/hero_leshrac/leshrac_pulse_nova_ambient.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_leshrac/leshrac_pulse_nova.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_terrorblade/ember_slow.vpcf", context )
PrecacheResource( "particle", "particles/heroes/leshrak_chakra.vpcf", context )
PrecacheResource( "particle", "particles/heroes/leshrak_chakra_end.vpcf", context )
PrecacheResource( "particle", "particles/heroes/leshrak_burst.vpcf", context )
PrecacheResource( "particle", "particles/econ/items/outworld_devourer/od_shards_exile/od_shards_exile_prison_end.vpcf", context )
PrecacheResource( "particle", "particles/leshrac_speed.vpcf", context )
PrecacheResource( "particle", "particles/puck_blind.vpcf", context )
PrecacheResource( "particle", "particles/leshrac/nova_mana.vpcf", context )

end

function leshrac_pulse_nova_custom:GetRadius()
return self:GetSpecialValueFor("radius") + self:GetCaster():GetLeshracRadius()
end

function leshrac_pulse_nova_custom:GetCastRange(vLocation, hTarget)
return self:GetRadius()
end 


function leshrac_pulse_nova_custom:GetMana()

local caster = self:GetCaster()
local mana_inc = caster:GetTalentValue("modifier_leshrac_nova_3", "mana")/100
local mana_cost_per_second = self:GetSpecialValueFor( "mana_cost_per_second" )
local mana_cost_max = self:GetSpecialValueFor( "mana_cost_max" )

local mana_cost = mana_cost_per_second + mana_cost_max*caster:GetMaxMana()/100

if caster:HasTalent("modifier_leshrac_nova_3") then 
  mana_cost = mana_cost*(1 + mana_inc)
end

return mana_cost
end



function leshrac_pulse_nova_custom:GetIntrinsicModifierName()
if not self:GetCaster():IsRealHero() then return end
return "modifier_leshrac_pulse_nova_custom_tracker"
end



function leshrac_pulse_nova_custom:OnToggle(  )
local caster = self:GetCaster()
local toggle = self:GetToggleState()

if toggle then
  self.modifier = caster:AddNewModifier( caster, self, "modifier_leshrac_pulse_nova_custom", {} )
  caster:StartGesture(ACT_DOTA_CAST_ABILITY_4)
else
  if self.modifier and not self.modifier:IsNull() then
    self.modifier:Destroy()
  end
  self.modifier = nil
  self:StartCooldown(1)
end

end







modifier_leshrac_pulse_nova_custom = class({})

function modifier_leshrac_pulse_nova_custom:IsHidden() return false end
function modifier_leshrac_pulse_nova_custom:IsPurgable() return false end
function modifier_leshrac_pulse_nova_custom:OnCreated( kv )

self.parent = self:GetParent()
self.ability = self:GetAbility()

self.damage_inc = self.parent:GetTalentValue("modifier_leshrac_nova_1", "damage")/100

self.reduce_duration = self.parent:GetTalentValue("modifier_leshrac_nova_2", "duration", true)

self.interval = self.parent:GetTalentValue("modifier_leshrac_nova_4", "interval")
self.interval_max = self.parent:GetTalentValue("modifier_leshrac_nova_4", "max", true)
self.move_max = self.parent:GetTalentValue("modifier_leshrac_nova_4", "move")
self.interval_inc = self.interval/self.interval_max
self.move_inc = self.move_max/self.interval_max

self.items_cd = self.parent:GetTalentValue("modifier_leshrac_nova_5", "cd", true)
self.items_mana = self.parent:GetTalentValue("modifier_leshrac_nova_5", "mana", true)

self.interval = self:GetAbility():GetSpecialValueFor("interval")
self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
self.radius = self:GetAbility():GetRadius()

self.edict = self:GetParent():FindAbilityByName("leshrac_diabolic_edict_custom")

if not IsServer() then return end

if self.parent:HasTalent("modifier_leshrac_nova_6") then 
  self.parent:AddNewModifier(self.parent, self.ability, "modifier_leshrac_pulse_nova_custom_status", {})
end 

self.damageTable = {attacker = self:GetParent(), damage_type = self:GetAbility():GetAbilityDamageType(), ability = self:GetAbility(), }
self.parent:EmitSound("Hero_Leshrac.Pulse_Nova")

self:Burn()
self:StartIntervalThink(self:GetInterval())
end


function modifier_leshrac_pulse_nova_custom:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_TOOLTIP,
  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
}
end

function modifier_leshrac_pulse_nova_custom:OnTooltip()
return self:GetInterval()
end


function modifier_leshrac_pulse_nova_custom:GetModifierMoveSpeedBonus_Percentage()
if not self.parent:HasTalent("modifier_leshrac_nova_4") then return end
return self:GetStackCount()*self.move_inc
end

function modifier_leshrac_pulse_nova_custom:GetInterval()
local interval = self.interval

if self.parent:HasTalent("modifier_leshrac_nova_4") then 
  interval = interval + self:GetStackCount()*self.interval_inc
end

return interval
end



function modifier_leshrac_pulse_nova_custom:OnDestroy()
if not IsServer() then return end
local sound_loop = "Hero_Leshrac.Pulse_Nova"
self.parent:StopSound(sound_loop)

self:GetParent():RemoveModifierByName("modifier_leshrac_pulse_nova_custom_status")
end



function modifier_leshrac_pulse_nova_custom:OnIntervalThink()
if not IsServer() then return end 

local mana = self.parent:GetMana()
local mana_cost = self.ability:GetMana()


if mana < mana_cost then
  if self.ability:GetToggleState() then
    self.ability:ToggleAbility()
  end
  return
end

self.parent:SetMana(math.max(1, mana - mana_cost))

self:Burn()
self:StartIntervalThink(self:GetInterval())
end



function modifier_leshrac_pulse_nova_custom:Burn()
if not IsServer() then return end

if self.edict and self.parent:HasModifier("modifier_leshrac_edict_4") then 
--  self.edict:ProcExtra(true)
end 

local enemies = self.parent:FindTargets(self.radius)
local damage = self.damage

if self.parent:HasTalent("modifier_leshrac_nova_1") then  
  damage = damage + (self.parent:GetMaxMana() - self.parent:GetMana())*self.damage_inc
end 

if #enemies > 0 then

  if self.parent:HasTalent("modifier_leshrac_nova_5") and self.parent:GetManaPercent() <= self.items_mana then 
    self.parent:CdItems(self.items_cd)
  end 

  if self.parent:HasTalent("modifier_leshrac_nova_4") and self:GetStackCount() < self.interval_max then 
    self:IncrementStackCount()
  end 
end

for _,enemy in pairs(enemies) do
  self.damageTable.victim = enemy
  self.damageTable.damage = damage

  if self.parent:HasTalent("modifier_leshrac_nova_2") then 
    enemy:AddNewModifier(self.parent, self.ability, "modifier_leshrac_pulse_nova_custom_reduce", {duration = self.reduce_duration})
  end

  DoDamage( self.damageTable )
  self:PlayEffects( enemy )
end

end





function modifier_leshrac_pulse_nova_custom:GetEffectName()
return "particles/units/heroes/hero_leshrac/leshrac_pulse_nova_ambient.vpcf"
end


function modifier_leshrac_pulse_nova_custom:PlayEffects( target )
local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_leshrac/leshrac_pulse_nova.vpcf", PATTACH_ABSORIGIN_FOLLOW, target )
ParticleManager:SetParticleControlEnt(effect_cast, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true )
ParticleManager:SetParticleControl( effect_cast, 1, Vector(100,0,0) )
ParticleManager:ReleaseParticleIndex( effect_cast )

target:EmitSound("Hero_Leshrac.Pulse_Nova_Strike")
end














modifier_leshrac_pulse_nova_custom_reduce = class({})
function modifier_leshrac_pulse_nova_custom_reduce:IsHidden() return false end
function modifier_leshrac_pulse_nova_custom_reduce:IsPurgable() return false end
function modifier_leshrac_pulse_nova_custom_reduce:GetTexture() return "buffs/nova_slow" end
function modifier_leshrac_pulse_nova_custom_reduce:OnCreated(table)

self.heal = self:GetCaster():GetTalentValue("modifier_leshrac_nova_2", "heal")
self.slow = self:GetCaster():GetTalentValue("modifier_leshrac_nova_2", "slow")
self.max = self:GetCaster():GetTalentValue("modifier_leshrac_nova_2", "max")

if not IsServer() then return end
self:SetStackCount(1)
end

function modifier_leshrac_pulse_nova_custom_reduce:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self.max  then return end
self:IncrementStackCount()

if self:GetStackCount() >= self.max  then 
  local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_terrorblade/ember_slow.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
  ParticleManager:SetParticleControl(iParticleID, 0, self:GetParent():GetAbsOrigin())
  self:AddParticle(iParticleID, true, false, -1, false, false)
end

end


function modifier_leshrac_pulse_nova_custom_reduce:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
  MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
  MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE,
  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
}
end

function modifier_leshrac_pulse_nova_custom_reduce:GetModifierMoveSpeedBonus_Percentage()
return self.slow*self:GetStackCount()
end

function modifier_leshrac_pulse_nova_custom_reduce:GetModifierLifestealRegenAmplify_Percentage() 
return self.heal*self:GetStackCount()
end

function modifier_leshrac_pulse_nova_custom_reduce:GetModifierHealAmplify_PercentageTarget()
return self.heal*self:GetStackCount()
end

function modifier_leshrac_pulse_nova_custom_reduce:GetModifierHPRegenAmplify_Percentage() 
return self.heal*self:GetStackCount()
end











leshrac_pulse_nova_custom_legendary = class({})

function leshrac_pulse_nova_custom_legendary:GetChannelTime()
return self:GetCaster():GetTalentValue("modifier_leshrac_nova_7", "cast") + FrameTime()*2
end

function leshrac_pulse_nova_custom_legendary:OnAbilityPhaseStart()
if IsServer() then
  self.FxBrightness = 100
end
return true
end

function leshrac_pulse_nova_custom_legendary:GetCooldown(iLevel)
return self:GetCaster():GetTalentValue("modifier_leshrac_nova_7", "cd")
end 

function leshrac_pulse_nova_custom_legendary:GetRadius()
return self:GetSpecialValueFor("radius") + self:GetCaster():GetLeshracRadius()
end 


function leshrac_pulse_nova_custom_legendary:GetCastRange()
return self:GetRadius()
end 

function leshrac_pulse_nova_custom_legendary:GetPlaybackRateOverride()
return 0.5
end


function leshrac_pulse_nova_custom_legendary:OnSpellStart()
if not IsServer() then return end

if self.nChannelFX then
  ParticleManager:DestroyParticle( self.nChannelFX, false )
end

self.nChannelFX = ParticleManager:CreateParticle( "particles/heroes/leshrak_chakra.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
ParticleManager:SetParticleControl( self.nChannelFX, 1, Vector( 0, 0, 0 ) )
ParticleManager:SetParticleControl( self.nChannelFX, 4, Vector( 0, 0, 0 ) )

self:GetCaster():EmitSound("Leshrac.Nova_legendary_cast")
self:GetCaster():EmitSound("Leshrac.Nova_legendary_cast_start")


self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_leshrac_pulse_nova_custom_legendary", {})
self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_VICTORY, 1.5)
end


function leshrac_pulse_nova_custom_legendary:OnChannelThink( flInterval )
  if IsServer() then
    if self.nChannelFX then
      self.FxBrightness = self.FxBrightness + 4
    end
  end
end

function leshrac_pulse_nova_custom_legendary:OnChannelFinish(bInterrupted)
if not IsServer() then return end

if self.nChannelFX then
  ParticleManager:DestroyParticle( self.nChannelFX, false )
end

local radius = self:GetRadius()
self:GetCaster():StopSound("Leshrac.Nova_legendary_cast")
self:GetCaster():EmitSound("Leshrac.Nova_legendary_blast")
self:GetCaster():EmitSound("Leshrac.Nova_legendary_blast2")

local nUnburrowFX = ParticleManager:CreateParticle( "particles/heroes/leshrak_chakra_end.vpcf", PATTACH_CUSTOMORIGIN, nil )
ParticleManager:SetParticleControl( nUnburrowFX, 0, self:GetCaster():GetAbsOrigin() ) 
ParticleManager:SetParticleControl( nUnburrowFX, 1, Vector( radius, 0, 0 ) ) 
ParticleManager:ReleaseParticleIndex( nUnburrowFX )

local abs = self:GetCaster():GetAbsOrigin()

local nFXIndex = ParticleManager:CreateParticle( "particles/heroes/leshrak_burst.vpcf", PATTACH_WORLDORIGIN, nil )

ParticleManager:SetParticleControl( nFXIndex, 0, Vector( radius, 0, 0 ) ) 
ParticleManager:SetParticleControl( nFXIndex, 1, abs ) 
ParticleManager:SetParticleControl( nFXIndex, 3, abs ) 
ParticleManager:ReleaseParticleIndex( nFXIndex )

self:GetCaster():RemoveModifierByName("modifier_leshrac_pulse_nova_custom_legendary")

self:GetCaster():FadeGesture(ACT_DOTA_VICTORY)
end






modifier_leshrac_pulse_nova_custom_legendary = class({})
function modifier_leshrac_pulse_nova_custom_legendary:IsHidden() return false end
function modifier_leshrac_pulse_nova_custom_legendary:IsPurgable() return false end
function modifier_leshrac_pulse_nova_custom_legendary:OnCreated(table)
if not IsServer() then return end

self.parent = self:GetParent()

self.interval = self:GetAbility():GetSpecialValueFor("interval")
self.damage_perc = self:GetAbility():GetSpecialValueFor("damage")/100
self.heal_perc = self:GetAbility():GetSpecialValueFor("heal")/100
self.radius = self:GetAbility():GetRadius()

self.total_mana = self:GetCaster():GetTalentValue("modifier_leshrac_nova_7", "mana")*(self:GetParent():GetMaxMana() - self:GetParent():GetMana())/100
self.total_time = self:GetCaster():GetTalentValue("modifier_leshrac_nova_7", "cast")


self.mana_tick = (self.total_mana)/(self.total_time/self.interval)

self:StartIntervalThink(self.interval)
end

function modifier_leshrac_pulse_nova_custom_legendary:OnIntervalThink()
if not IsServer() then return end

local mana = self.mana_tick

self:GetParent():GiveMana(mana)

self:SetStackCount(self:GetStackCount() + mana)
SendOverheadEventMessage(self:GetParent(), 11, self:GetParent(), mana, nil)
end


function modifier_leshrac_pulse_nova_custom_legendary:OnDestroy()
if not IsServer() then return end
if self:GetStackCount() == 0 then return end

local damage = self:GetStackCount()*self.damage_perc
local heal = self:GetStackCount()*self.heal_perc


local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0,  0, false )

for _,enemy in pairs(enemies) do 
  DoDamage({ victim = enemy, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, damage_flags = DOTA_DAMAGE_FLAG_NONE, attacker = self:GetCaster(), ability = self:GetAbility() })
  SendOverheadEventMessage(enemy, 4, enemy, damage, nil)


  local impact = ParticleManager:CreateParticle("particles/econ/items/outworld_devourer/od_shards_exile/od_shards_exile_prison_end.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy)
  ParticleManager:ReleaseParticleIndex(impact)
end

if #enemies > 0 then
  self.parent:EmitSound("Leshrac.Nova_legendary_impact")
end

self:GetParent():GenericHeal(heal, self:GetAbility())

end




modifier_leshrac_pulse_nova_custom_tracker = class({})
function modifier_leshrac_pulse_nova_custom_tracker:IsHidden() return true end
function modifier_leshrac_pulse_nova_custom_tracker:IsPurgable() return false end
function modifier_leshrac_pulse_nova_custom_tracker:OnCreated()

self.parent = self:GetParent()
self.mana = self.parent:GetTalentValue("modifier_leshrac_nova_5", "mana", true)
self.cdr = self.parent:GetTalentValue("modifier_leshrac_nova_5", "cdr", true)

if not IsServer() then return end 

self:StartIntervalThink(1)
end 

function modifier_leshrac_pulse_nova_custom_tracker:OnIntervalThink()
if not IsServer() then return end 
if not self.parent:HasTalent("modifier_leshrac_nova_5") then return end 

if self.parent:GetManaPercent() <= self.mana and not self.parent:HasModifier("modifier_leshrac_pulse_nova_custom_low_mana") then 
  self.parent:AddNewModifier(self.parent, self:GetAbility(), "modifier_leshrac_pulse_nova_custom_low_mana", {})
end 

if self.parent:GetManaPercent() > self.mana and self.parent:HasModifier("modifier_leshrac_pulse_nova_custom_low_mana") then 
  self.parent:RemoveModifierByName("modifier_leshrac_pulse_nova_custom_low_mana")
end 

self:StartIntervalThink(0.1)
end 


function modifier_leshrac_pulse_nova_custom_tracker:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
  MODIFIER_PROPERTY_HEALTH_BONUS
}
end

function modifier_leshrac_pulse_nova_custom_tracker:GetModifierPercentageCooldown()
if not self.parent:HasTalent("modifier_leshrac_nova_5") then return end
return self.cdr
end



function modifier_leshrac_pulse_nova_custom_tracker:GetModifierHealthBonus()
if not self.parent:HasTalent("modifier_leshrac_nova_1") then return end
return self.parent:GetMaxMana()*self.parent:GetTalentValue("modifier_leshrac_nova_1", "health")/100
end








modifier_leshrac_pulse_nova_custom_status = class({})
function modifier_leshrac_pulse_nova_custom_status:IsHidden() return self:GetStackCount() == 1 end
function modifier_leshrac_pulse_nova_custom_status:IsPurgable() return false end
function modifier_leshrac_pulse_nova_custom_status:GetTexture() return "buffs/nova_evasion" end
function modifier_leshrac_pulse_nova_custom_status:OnCreated(table)

self.interval = self:GetCaster():GetTalentValue("modifier_leshrac_nova_6", "timer")
self.damage_reduce = self:GetCaster():GetTalentValue("modifier_leshrac_nova_6", "damage_reduce")
self.status = self:GetCaster():GetTalentValue("modifier_leshrac_nova_6", "status")

if not IsServer() then return end
self:SetStackCount(1)
self:StartIntervalThink(self.interval)
end

function modifier_leshrac_pulse_nova_custom_status:OnIntervalThink()
if not IsServer() then return end
self:SetStackCount(0)

self:GetParent():EmitSound("Leshrac.Nova_cdr")

local iParticleID = ParticleManager:CreateParticle("particles/leshrac_speed.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
self:AddParticle(iParticleID, true, false, -1, false, false)

local rift_particle = ParticleManager:CreateParticle("particles/puck_blind.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(rift_particle, 0, self:GetCaster():GetAbsOrigin())
ParticleManager:SetParticleControl(rift_particle, 1, self:GetCaster():GetAbsOrigin())
ParticleManager:SetParticleControl(rift_particle, 2, Vector(500, 0, 0))
ParticleManager:ReleaseParticleIndex(rift_particle)
self:StartIntervalThink(-1)
end


function modifier_leshrac_pulse_nova_custom_status:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
  MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
}
end


function modifier_leshrac_pulse_nova_custom_status:GetModifierIncomingDamage_Percentage()
if self:GetStackCount() == 1 then return end

return self.damage_reduce
end


function modifier_leshrac_pulse_nova_custom_status:GetModifierStatusResistanceStacking()
if self:GetStackCount() == 1 then return end

return self.status
end









modifier_leshrac_pulse_nova_custom_low_mana = class({})
function modifier_leshrac_pulse_nova_custom_low_mana:IsHidden() return true end
function modifier_leshrac_pulse_nova_custom_low_mana:IsPurgable() return false end
function modifier_leshrac_pulse_nova_custom_low_mana:GetTexture() return "buffs/veil_amp" end
function modifier_leshrac_pulse_nova_custom_low_mana:OnCreated()

self:SetStackCount(self:GetCaster():GetTalentValue("modifier_leshrac_nova_5", "spells"))

if not IsServer() then return end 
self:StartIntervalThink(0.1)
end

function modifier_leshrac_pulse_nova_custom_low_mana:OnIntervalThink()
if not IsServer() then return end 

local particle_peffect = ParticleManager:CreateParticle("particles/leshrac/nova_mana.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
ParticleManager:SetParticleControl(particle_peffect, 0, self:GetCaster():GetAbsOrigin())
ParticleManager:SetParticleControl(particle_peffect, 2, self:GetCaster():GetAbsOrigin())
ParticleManager:ReleaseParticleIndex(particle_peffect)
self:StartIntervalThink(-1)
end 





