LinkLuaModifier( "modifier_leshrac_pulse_nova_custom", "abilities/leshrac/leshrac_pulse_nova_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_leshrac_pulse_nova_custom_slow", "abilities/leshrac/leshrac_pulse_nova_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_leshrac_pulse_nova_custom_legendary", "abilities/leshrac/leshrac_pulse_nova_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_leshrac_pulse_nova_custom_tracker", "abilities/leshrac/leshrac_pulse_nova_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_leshrac_pulse_nova_custom_evasion", "abilities/leshrac/leshrac_pulse_nova_custom", LUA_MODIFIER_MOTION_NONE )



leshrac_pulse_nova_custom = class({})

leshrac_pulse_nova_custom.damage_inc = {0.03, 0.045, 0.06}

leshrac_pulse_nova_custom.reduction_heal = {-3, -4, -5}
leshrac_pulse_nova_custom.reduction_move = {-3, -4, -5}
leshrac_pulse_nova_custom.reduction_max = 5
leshrac_pulse_nova_custom.reduction_duration = 2



leshrac_pulse_nova_custom.mana_interval = {0.03, 0.05}
leshrac_pulse_nova_custom.mana_move = {1, 2}
leshrac_pulse_nova_custom.mana_max = 10

leshrac_pulse_nova_custom.spells_cost = 100
leshrac_pulse_nova_custom.spells_mana = 0.08
leshrac_pulse_nova_custom.spells_chance = 30

leshrac_pulse_nova_custom.resist_evasion = 20
leshrac_pulse_nova_custom.resist_magic = 20
leshrac_pulse_nova_custom.resist_timer = 5
leshrac_pulse_nova_custom.resist_k = 2




function leshrac_pulse_nova_custom:Precache(context)

PrecacheResource( "particle", "particles/units/heroes/hero_leshrac/leshrac_pulse_nova_ambient.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_leshrac/leshrac_pulse_nova.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_terrorblade/ember_slow.vpcf", context )
PrecacheResource( "particle", "particles/heroes/leshrak_chakra.vpcf", context )
PrecacheResource( "particle", "particles/heroes/leshrak_chakra_end.vpcf", context )
PrecacheResource( "particle", "particles/heroes/leshrak_burst.vpcf", context )
PrecacheResource( "particle", "particles/econ/items/outworld_devourer/od_shards_exile/od_shards_exile_prison_end.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_keeper_of_the_light/keeper_chakra_magic.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_essence_effect.vpcf", context )
PrecacheResource( "particle", "particles/puck_blind.vpcf", context )

end


function leshrac_pulse_nova_custom:GetCastRange(vLocation, hTarget)

return self:GetSpecialValueFor("radius") + self:GetCaster():GetTalentValue("modifier_leshrac_nova_3", "radius")
end 


function leshrac_pulse_nova_custom:GetIntrinsicModifierName()
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


function modifier_leshrac_pulse_nova_custom:IsHidden()
  return false
end

function modifier_leshrac_pulse_nova_custom:IsDebuff()
  return false
end

function modifier_leshrac_pulse_nova_custom:IsPurgable()
  return false
end

function modifier_leshrac_pulse_nova_custom:GetAttributes()
  return MODIFIER_ATTRIBUTE_PERMANENT 
end


function modifier_leshrac_pulse_nova_custom:OnCreated( kv )
if not IsServer() then return end
 
self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
self.mana_cost_per_second = self:GetAbility():GetSpecialValueFor( "mana_cost_per_second" )
self.mana_cost_max = self:GetAbility():GetSpecialValueFor( "mana_cost_max" )


self.parent = self:GetParent()

self.damageTable = {attacker = self:GetParent(), damage_type = self:GetAbility():GetAbilityDamageType(), ability = self:GetAbility(), }


local mana_cost = self.mana_cost_per_second + self.mana_cost_max*self.parent:GetMaxMana()/100

if self:GetCaster():HasModifier("modifier_leshrac_nova_3") then 

  self.radius = self.radius + self:GetCaster():GetTalentValue("modifier_leshrac_nova_3", "radius")
  mana_cost = mana_cost*(1 + self:GetCaster():GetTalentValue("modifier_leshrac_nova_3", "mana")/100)
end


if self:GetCaster():HasModifier("modifier_leshrac_nova_6") then 
  self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_leshrac_pulse_nova_custom_evasion", {})
end

self:GetParent():SetMana(math.max(1, self:GetParent():GetMana() - mana_cost))

self:Burn()


local interval = self:GetAbility():GetSpecialValueFor("interval")

if self:GetParent():HasModifier("modifier_leshrac_nova_4")  then 
  interval = interval - self:GetAbility().mana_interval[self:GetCaster():GetUpgradeStack("modifier_leshrac_nova_4")]*self:GetStackCount()
end

self:StartIntervalThink(interval)


local sound_loop = "Hero_Leshrac.Pulse_Nova"
self.parent:EmitSound(sound_loop)
end



function modifier_leshrac_pulse_nova_custom:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
  MODIFIER_PROPERTY_TOOLTIP,

}
end




function modifier_leshrac_pulse_nova_custom:OnTooltip()
local interval = self:GetAbility():GetSpecialValueFor("interval")

if self:GetParent():HasModifier("modifier_leshrac_nova_4") and self:GetStackCount() > 0 then 
  interval = interval - self:GetAbility().mana_interval[self:GetCaster():GetUpgradeStack("modifier_leshrac_nova_4")]*self:GetStackCount()
end

return interval
end

function modifier_leshrac_pulse_nova_custom:GetModifierMoveSpeedBonus_Percentage()
if not self:GetParent():HasModifier("modifier_leshrac_nova_4") then return end
return self:GetAbility().mana_move[self:GetCaster():GetUpgradeStack("modifier_leshrac_nova_4")]*self:GetStackCount()
end


function modifier_leshrac_pulse_nova_custom:OnDestroy()
  if not IsServer() then return end
  local sound_loop = "Hero_Leshrac.Pulse_Nova"
  self.parent:StopSound(sound_loop)

  self:GetParent():RemoveModifierByName("modifier_leshrac_pulse_nova_custom_evasion")
end

--------------------------------------------------------------------------------

function modifier_leshrac_pulse_nova_custom:OnIntervalThink()
local mana = self.parent:GetMana()

local mana_cost = self.mana_cost_per_second + self.mana_cost_max*self.parent:GetMaxMana()/100

if self:GetCaster():HasModifier("modifier_leshrac_nova_3") then 
  mana_cost = mana_cost*(1 + self:GetCaster():GetTalentValue("modifier_leshrac_nova_3", "mana")/100)
end

print(mana_cost)

if mana < mana_cost then
  if self:GetAbility():GetToggleState() then
    self:GetAbility():ToggleAbility()
  end
  return
end

self:GetParent():SetMana(math.max(1, self:GetParent():GetMana() - mana_cost))

self:Burn()


local interval = self:GetAbility():GetSpecialValueFor("interval")


if self:GetParent():HasModifier("modifier_leshrac_nova_4")  then 
  interval = interval - self:GetAbility().mana_interval[self:GetCaster():GetUpgradeStack("modifier_leshrac_nova_4")]*self:GetStackCount()
end

self:StartIntervalThink(interval)
end




function modifier_leshrac_pulse_nova_custom:Burn()
if not IsServer() then return end

local enemies = FindUnitsInRadius(self.parent:GetTeamNumber(), self.parent:GetOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0,  0, false )

local damage = self.damage

if self:GetCaster():HasModifier("modifier_leshrac_nova_1") then  
  damage = damage + self:GetAbility().damage_inc[self:GetCaster():GetUpgradeStack("modifier_leshrac_nova_1")]*(self:GetParent():GetMaxMana() - self:GetParent():GetMana())
end 

if #enemies > 0 and self:GetParent():HasModifier("modifier_leshrac_nova_4") and self:GetStackCount() < self:GetAbility().mana_max then 
  self:IncrementStackCount()
end

for _,enemy in pairs(enemies) do
  self.damageTable.victim = enemy
  self.damageTable.damage = damage

  if self:GetCaster():HasModifier("modifier_leshrac_nova_2") then 
    enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_leshrac_pulse_nova_custom_slow", {duration = self:GetAbility().reduction_duration})
  end

  ApplyDamage( self.damageTable )
  self:PlayEffects( enemy )
end

end



function modifier_leshrac_pulse_nova_custom:GetEffectName()
  return "particles/units/heroes/hero_leshrac/leshrac_pulse_nova_ambient.vpcf"
end

function modifier_leshrac_pulse_nova_custom:GetEffectAttachType()
  return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_leshrac_pulse_nova_custom:PlayEffects( target )
local particle_cast = "particles/units/heroes/hero_leshrac/leshrac_pulse_nova.vpcf"
local sound_cast = "Hero_Leshrac.Pulse_Nova_Strike"

local radius = 100

local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
ParticleManager:SetParticleControlEnt(effect_cast, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true )

ParticleManager:SetParticleControl( effect_cast, 1, Vector(radius,0,0) )
ParticleManager:ReleaseParticleIndex( effect_cast )


target:EmitSound(sound_cast)
end




modifier_leshrac_pulse_nova_custom_slow = class({})
function modifier_leshrac_pulse_nova_custom_slow:IsHidden() return false end
function modifier_leshrac_pulse_nova_custom_slow:IsPurgable() return false end
function modifier_leshrac_pulse_nova_custom_slow:GetTexture() return "buffs/nova_slow" end
function modifier_leshrac_pulse_nova_custom_slow:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
end

function modifier_leshrac_pulse_nova_custom_slow:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self:GetAbility().reduction_max then return end
self:IncrementStackCount()

if self:GetStackCount() >= self:GetAbility().reduction_max then 

  local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_terrorblade/ember_slow.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
  ParticleManager:SetParticleControl(iParticleID, 0, self:GetParent():GetAbsOrigin())
  self:AddParticle(iParticleID, true, false, -1, false, false)
end

end


function modifier_leshrac_pulse_nova_custom_slow:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
  MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
  MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE,
  MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
}
end

function modifier_leshrac_pulse_nova_custom_slow:GetModifierLifestealRegenAmplify_Percentage() 
return self:GetAbility().reduction_heal[self:GetCaster():GetUpgradeStack("modifier_leshrac_nova_2")]*self:GetStackCount()
end

function modifier_leshrac_pulse_nova_custom_slow:GetModifierHealAmplify_PercentageTarget()
return self:GetAbility().reduction_heal[self:GetCaster():GetUpgradeStack("modifier_leshrac_nova_2")]*self:GetStackCount()
end

function modifier_leshrac_pulse_nova_custom_slow:GetModifierHPRegenAmplify_Percentage() 
return self:GetAbility().reduction_heal[self:GetCaster():GetUpgradeStack("modifier_leshrac_nova_2")]*self:GetStackCount()
end

function modifier_leshrac_pulse_nova_custom_slow:GetModifierMoveSpeedBonus_Percentage()
return self:GetAbility().reduction_move[self:GetCaster():GetUpgradeStack("modifier_leshrac_nova_2")]*self:GetStackCount()
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
self:GetCaster():StartGesture(ACT_DOTA_VICTORY)
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

self:GetCaster():StopSound("Leshrac.Nova_legendary_cast")
self:GetCaster():EmitSound("Leshrac.Nova_legendary_blast")
self:GetCaster():EmitSound("Leshrac.Nova_legendary_blast2")

local nUnburrowFX = ParticleManager:CreateParticle( "particles/heroes/leshrak_chakra_end.vpcf", PATTACH_CUSTOMORIGIN, nil )
ParticleManager:SetParticleControl( nUnburrowFX, 0, self:GetCaster():GetAbsOrigin() ) 
ParticleManager:SetParticleControl( nUnburrowFX, 1, Vector( 500, 0, 0 ) ) 
ParticleManager:ReleaseParticleIndex( nUnburrowFX )

local abs = self:GetCaster():GetAbsOrigin()

local nFXIndex = ParticleManager:CreateParticle( "particles/heroes/leshrak_burst.vpcf", PATTACH_WORLDORIGIN, nil )

ParticleManager:SetParticleControl( nFXIndex, 0, Vector( 500, 0, 0 ) ) 
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

self.interval = self:GetAbility():GetSpecialValueFor("interval")
self.total_mana = self:GetCaster():GetTalentValue("modifier_leshrac_nova_7", "mana")*self:GetParent():GetMaxMana()/100
self.total_time = self:GetCaster():GetTalentValue("modifier_leshrac_nova_7", "cast")
self.damage_perc = self:GetCaster():GetTalentValue("modifier_leshrac_nova_7", "damage")/100
self.heal_perc = self:GetCaster():GetTalentValue("modifier_leshrac_nova_7", "heal")/100
self.radius = self:GetAbility():GetSpecialValueFor("radius")

self.mana_tick = (self.total_mana)/(self.total_time/self.interval)

--self:OnIntervalThink()
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
  ApplyDamage({ victim = enemy, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, damage_flags = DOTA_DAMAGE_FLAG_NONE, attacker = self:GetCaster(), ability = self:GetAbility() })
  SendOverheadEventMessage(enemy, 4, enemy, damage, nil)

  enemy:EmitSound("Leshrac.Nova_legendary_impact")

  local impact = ParticleManager:CreateParticle("particles/econ/items/outworld_devourer/od_shards_exile/od_shards_exile_prison_end.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy)
  ParticleManager:ReleaseParticleIndex(impact)
end

my_game:GenericHeal(self:GetParent(), heal, self:GetAbility())

end




modifier_leshrac_pulse_nova_custom_tracker = class({})
function modifier_leshrac_pulse_nova_custom_tracker:IsHidden() return true end
function modifier_leshrac_pulse_nova_custom_tracker:IsPurgable() return false end
function modifier_leshrac_pulse_nova_custom_tracker:DeclareFunctions()
return
{
  MODIFIER_EVENT_ON_ABILITY_EXECUTED
}
end

function modifier_leshrac_pulse_nova_custom_tracker:OnAbilityExecuted( params )
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_leshrac_nova_5") then return end
if params.unit~=self:GetParent() then return end
if not params.ability then return end
if params.ability:IsItem() or params.ability:IsToggle() then return end
if UnvalidAbilities[params.ability:GetName()] then return end
--if params.ability:GetName() ~= "leshrac_diabolic_edict_custom" and params.ability:GetName() ~= "leshrac_lightning_storm_custom" and params.ability:GetName() ~= "leshrac_split_earth_custom" then return end
if not RollPseudoRandomPercentage(self:GetAbility().spells_chance ,237,self:GetParent()) then return end

local mana = self:GetParent():GetMaxMana()*self:GetAbility().spells_mana

self:GetParent():GiveMana(mana)
SendOverheadEventMessage(self:GetParent(), 11, self:GetParent(), mana, nil)

my_game:GenericHeal(self:GetParent(), mana, self:GetAbility())


self:GetCaster():EmitSound("Puck.Rift_Mana")

local mana_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_keeper_of_the_light/keeper_chakra_magic.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
ParticleManager:SetParticleControl(mana_particle, 0, self:GetCaster():GetAbsOrigin())
ParticleManager:SetParticleControl(mana_particle, 1, self:GetCaster():GetAbsOrigin())
ParticleManager:ReleaseParticleIndex(mana_particle)


local mana_particle2 = ParticleManager:CreateParticle("particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_essence_effect.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())

ParticleManager:ReleaseParticleIndex(mana_particle2)
end


modifier_leshrac_pulse_nova_custom_evasion = class({})
function modifier_leshrac_pulse_nova_custom_evasion:IsHidden() return 
self:GetStackCount() == 1 end

function modifier_leshrac_pulse_nova_custom_evasion:IsPurgable() return false end
function modifier_leshrac_pulse_nova_custom_evasion:GetTexture() return "buffs/nova_evasion" end
function modifier_leshrac_pulse_nova_custom_evasion:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
self:StartIntervalThink(self:GetAbility().resist_timer)
end

function modifier_leshrac_pulse_nova_custom_evasion:OnIntervalThink()
if not IsServer() then return end
self:SetStackCount(0)


self:GetParent():EmitSound("Item.StarEmblem.Enemy")
self.particle_peffect = ParticleManager:CreateParticle("particles/items3_fx/star_emblem_friend.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent()) 
ParticleManager:SetParticleControl(self.particle_peffect, 0, self:GetParent():GetAbsOrigin())
self:AddParticle(self.particle_peffect, false, false, -1, false, true)


local rift_particle = ParticleManager:CreateParticle("particles/puck_blind.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(rift_particle, 0, self:GetCaster():GetAbsOrigin())
ParticleManager:SetParticleControl(rift_particle, 1, self:GetCaster():GetAbsOrigin())
ParticleManager:SetParticleControl(rift_particle, 2, Vector(500, 0, 0))
ParticleManager:ReleaseParticleIndex(rift_particle)
self:StartIntervalThink(-1)
end


function modifier_leshrac_pulse_nova_custom_evasion:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_EVASION_CONSTANT,
  MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
}
end


function modifier_leshrac_pulse_nova_custom_evasion:GetModifierEvasion_Constant()

if self:GetStackCount() == 1 then 
  return
end

return self:GetAbility().resist_evasion
end


function modifier_leshrac_pulse_nova_custom_evasion:GetModifierMagicalResistanceBonus()

if self:GetStackCount() == 1 then 
  return
end



return self:GetAbility().resist_magic 
end
