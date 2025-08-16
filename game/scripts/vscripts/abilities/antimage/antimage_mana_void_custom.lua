LinkLuaModifier( "modifier_antimage_mana_void_custom_slow", "abilities/antimage/antimage_mana_void_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_antimage_mana_void_custom_tracker", "abilities/antimage/antimage_mana_void_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_antimage_mana_void_custom_int", "abilities/antimage/antimage_mana_void_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_antimage_mana_void_custom_cast_cd", "abilities/antimage/antimage_mana_void_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_antimage_mana_void_custom_burn", "abilities/antimage/antimage_mana_void_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_antimage_mana_void_custom_illusion", "abilities/antimage/antimage_mana_void_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_antimage_mana_void_custom_perma", "abilities/antimage/antimage_mana_void_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_antimage_mana_void_custom_silence", "abilities/antimage/antimage_mana_void_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_antimage_mana_void_custom_aura_effect", "abilities/antimage/antimage_mana_void_custom", LUA_MODIFIER_MOTION_NONE)

antimage_mana_void_custom = class({})

function antimage_mana_void_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end
PrecacheResource( "particle", "particles/units/heroes/hero_antimage/antimage_manavoid.vpcf", context )
PrecacheResource( "particle", "particles/void_astral_slow.vpcf", context )
PrecacheResource( "particle", "particles/am_void_cd.vpcf", context )
PrecacheResource( "particle", "particles/am_mana_stack.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_faceless_void/faceless_void_dialatedebuf_2.vpcf", context )
PrecacheResource( "particle", "particles/am_cast.vpcf", context )
PrecacheResource( "particle", "particles/am_mana_mark.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_silencer/silencer_last_word_status.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_antimage/antimage_manavoid.vpcf", context )
PrecacheResource( "particle", "particles/items4_fx/nullifier_mute_debuff.vpcf", context )
PrecacheResource( "particle", "particles/status_fx/status_effect_nullifier.vpcf", context )
PrecacheResource( "particle", "particles/anti-mage/void_silence.vpcf", context )

PrecacheResource( "particle", "particles/econ/items/antimage/antimage_weapon_basher_ti5/antimage_manavoid_ti_5.vpcf", context )
end


function antimage_mana_void_custom:GetAbilityTextureName()
local caster = self:GetCaster()
if caster:HasModifier("modifier_antimage_basher_1_custom_golden") or caster:HasModifier("modifier_antimage_basher_2_custom_golden") then
    return "antimage/golden_basher_blades/antimage_mana_void"
end
if caster:HasModifier("modifier_antimage_basher_1_custom") or caster:HasModifier("modifier_antimage_basher_2_custom") then
    return "antimage/the_basher_blades/antimage_mana_void"
end
return "antimage_mana_void"
end

function antimage_mana_void_custom:GetIntrinsicModifierName()
return "modifier_antimage_mana_void_custom_tracker"
end

function antimage_mana_void_custom:GetAOERadius()
return self:GetSpecialValueFor( "mana_void_aoe_radius" )
end

function antimage_mana_void_custom:GetCooldown(iLevel)
local bonus = 0
if self:GetCaster():HasTalent("modifier_antimage_void_2") then  
  bonus = self:GetCaster():GetTalentValue("modifier_antimage_void_2", "cd")
end
return self.BaseClass.GetCooldown(self, iLevel) + bonus
end


function antimage_mana_void_custom:OnAbilityPhaseStart( kv )
local caster = self:GetCaster()
self.target = self:GetCursorTarget()
self.sound = "Hero_Antimage.ManaVoidCast"
if caster:HasModifier("modifier_antimage_persona_custom_1") or caster:HasModifier("modifier_antimage_persona_custom_2") or caster:HasModifier("modifier_antimage_persona_custom_3") or caster:HasModifier("modifier_antimage_persona_custom_4") or caster:HasModifier("modifier_antimage_persona_custom_5") or caster:HasModifier("modifier_antimage_persona_custom_6") then
    self.sound = "Hero_Antimage.ManaVoidCast.Persona"
end
self.target:EmitSound(self.sound)
return true
end

function antimage_mana_void_custom:OnAbilityPhaseInterrupted()
self.target:StopSound(self.sound)
end

function antimage_mana_void_custom:OnSpellStart()
local caster = self:GetCaster()
local target = self:GetCursorTarget()

local legenday_mod = caster:FindModifierByName("modifier_antimage_mana_void_custom_illusion")
if legenday_mod then
	legenday_mod.ready = false
end

if target:TriggerSpellAbsorb( self ) then return end

if caster:IsRealHero() and target:IsRealHero() and caster:GetQuest() == "Anti.Quest_8" and target:GetManaPercent() <= caster.quest.number and not caster:QuestCompleted() then 
	caster:UpdateQuest(1)
end

local damage = self:GetSpecialValueFor("mana_void_damage_per_mana")
local radius = self:GetSpecialValueFor( "mana_void_aoe_radius" )

local max_mana = target:GetMaxMana()
local min_mana = target:GetMana()

if max_mana == 0 then 
	max_mana = self:GetSpecialValueFor("nomana_max")
	min_mana = self:GetSpecialValueFor("nomana_min")
end

if target:IsRealHero() and caster:IsRealHero() and min_mana/max_mana <= caster:GetTalentValue("modifier_antimage_hero_5", "mana", true)/100 then
	caster:AddNewModifier(caster, self, "modifier_antimage_mana_void_custom_perma", {})
end

local mana_damage = (max_mana - min_mana) * damage
mana_damage = legenday_mod and legenday_mod.damage*mana_damage or mana_damage

local damage_ability = legenday_mod and "modifier_antimage_void_7" or nil

target:EmitSound("Hero_Antimage.ManaVoid")

local particle_name = "particles/units/heroes/hero_antimage/antimage_manavoid.vpcf"
if caster:HasModifier("modifier_antimage_basher_1_custom") or caster:HasModifier("modifier_antimage_basher_2_custom") then
    particle_name = "particles/econ/items/antimage/antimage_weapon_basher_ti5/antimage_manavoid_ti_5.vpcf"
end
if caster:HasModifier("modifier_antimage_basher_1_custom_golden") or caster:HasModifier("modifier_antimage_basher_2_custom_golden") then
    particle_name = "particles/econ/items/antimage/antimage_weapon_basher_ti5_gold/antimage_manavoid_ti_5_gold.vpcf"
end

local particle = ParticleManager:CreateParticle( particle_name, PATTACH_POINT_FOLLOW, target )
ParticleManager:SetParticleControlEnt( particle, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true )
ParticleManager:SetParticleControl( particle, 1, Vector( radius, 0, 0 ) )
ParticleManager:ReleaseParticleIndex( particle )

local mana_void_ministun = self:GetSpecialValueFor("mana_void_ministun") + caster:GetTalentValue("modifier_antimage_void_4", "stun")
local slow_duration = caster:GetTalentValue("modifier_antimage_void_4", "duration")

if caster:HasTalent("modifier_antimage_void_1") then
	target:AddNewModifier(caster, self, "modifier_antimage_mana_void_custom_burn", {})
end

local attacker = caster.owner and caster.owner or caster

for _,enemy in pairs(caster:FindTargets(radius, target:GetAbsOrigin())) do

	if caster:HasTalent("modifier_antimage_void_4") and not legenday_mod then 
		enemy:AddNewModifier(caster, self, "modifier_antimage_mana_void_custom_slow", {duration = (1 - enemy:GetStatusResistance())*slow_duration})
	end
	enemy:AddNewModifier( caster, self, "modifier_stunned", { duration = mana_void_ministun*(1 - enemy:GetStatusResistance()) } )

	DoDamage({ victim = enemy, attacker = attacker, damage = mana_damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self}, damage_ability)
end


if target:IsCreep() then 
	self:EndCooldown()
	self:StartCooldown(self:GetSpecialValueFor("creep_cd"))
end

end




modifier_antimage_mana_void_custom_slow = class(mod_hidden)
function modifier_antimage_mana_void_custom_slow:GetEffectName() return "particles/items4_fx/nullifier_mute_debuff.vpcf" end
function modifier_antimage_mana_void_custom_slow:GetStatusEffectName() return "particles/status_fx/status_effect_nullifier.vpcf" end 
function modifier_antimage_mana_void_custom_slow:StatusEffectPriority() return MODIFIER_PRIORITY_SUPER_ULTRA  end 
function modifier_antimage_mana_void_custom_slow:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end
function modifier_antimage_mana_void_custom_slow:GetModifierMoveSpeedBonus_Percentage() 
return self.slow
end

function modifier_antimage_mana_void_custom_slow:OnCreated(table)
self.parent = self:GetParent()
self.caster = self:GetCaster()
self.slow = self.caster:GetTalentValue("modifier_antimage_void_4", "slow")
if not IsServer() then return end

self.parent:EmitSound("Antimage.Void_break")
self.parent:GenericParticle("particles/generic_gameplay/generic_break.vpcf", self, true)
end 

function modifier_antimage_mana_void_custom_slow:CheckState()
return
{
	[MODIFIER_STATE_PASSIVES_DISABLED] = true
}
end





modifier_antimage_mana_void_custom_tracker = class({})
function modifier_antimage_mana_void_custom_tracker:IsHidden() return true end
function modifier_antimage_mana_void_custom_tracker:IsPurgable() return false end



function modifier_antimage_mana_void_custom_tracker:OnCreated()
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.aura_radius = self.parent:GetTalentValue("modifier_antimage_void_3", "radius", true)

self.spell_damage = self.parent:GetTalentValue("modifier_antimage_void_3", "spell")

if not self.parent:IsRealHero() then return end

self.cdr = self.parent:GetTalentValue("modifier_antimage_hero_5", "cdr")

self.range_bonus = self.parent:GetTalentValue("modifier_antimage_void_2", "range")

self.nomana_max = self.ability:GetSpecialValueFor("nomana_max")

self.cast_radius = self.parent:GetTalentValue("modifier_antimage_hero_6", "radius", true)
self.cast_cd = self.parent:GetTalentValue("modifier_antimage_hero_6", "talent_cd", true)
self.cast_silence = self.parent:GetTalentValue("modifier_antimage_hero_6", "silence", true)

self.heal_duration = self.parent:GetTalentValue("modifier_antimage_counter_2", "duration", true)
self.slow_duration = self.parent:GetTalentValue("modifier_antimage_counter_2", "slow_duration", true)

if not IsServer() then return end

self:SetHasCustomTransmitterData(true)
self:UpdateTalent()
end

function modifier_antimage_mana_void_custom_tracker:UpdateTalent(name)
if not IsServer() then return end

if name == "modifier_antimage_hero_5" or self.parent:HasTalent("modifier_antimage_hero_5") then
	self.cdr = self.parent:GetTalentValue("modifier_antimage_hero_5", "cdr")
end

if name == "modifier_antimage_void_3" or self.parent:HasTalent("modifier_antimage_void_3") then
	self.spell_damage = self.parent:GetTalentValue("modifier_antimage_void_3", "spell")
end

if name == "modifier_antimage_void_2" or self.parent:HasTalent("modifier_antimage_void_2") then
	self.range_bonus = self.parent:GetTalentValue("modifier_antimage_void_2", "range")
end

if name == "modifier_antimage_hero_6" or self.parent:HasTalent("modifier_antimage_hero_6") then
	self.parent:AddSpellEvent(self, true)
end

if name == "modifier_antimage_counter_2" or self.parent:HasTalent("modifier_antimage_counter_2") then
	self.parent:AddSpellEvent(self, true)
end

self:SendBuffRefreshToClients()
end

function modifier_antimage_mana_void_custom_tracker:DeclareFunctions()
return
{
  	MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING,
  	MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
  	MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE
}
end


function modifier_antimage_mana_void_custom_tracker:GetModifierSpellAmplify_Percentage() 
return self.spell_damage
end

function modifier_antimage_mana_void_custom_tracker:GetModifierCastRangeBonusStacking()
return self.range_bonus
end

function modifier_antimage_mana_void_custom_tracker:GetModifierPercentageCooldown()
return self.cdr 
end

function modifier_antimage_mana_void_custom_tracker:AddCustomTransmitterData() 
return 
{
    range_bonus = self.range_bonus,
    spell_damage = self.spell_damage,
    cdr = self.cdr
} 
end

function modifier_antimage_mana_void_custom_tracker:HandleCustomTransmitterData(data)
self.range_bonus = data.range_bonus
self.cdr = data.cdr
self.spell_damage = data.spell_damage
end


function modifier_antimage_mana_void_custom_tracker:SpellEvent(params)
local unit = params.unit

if params.ability:IsItem() then return end
if unit:GetTeamNumber() == self.parent:GetTeamNumber() then return end
if (unit:GetAbsOrigin() - self.parent:GetAbsOrigin()):Length2D() > self.cast_radius then return end
if not self.parent:IsAlive() then return end

local need_effect = false

if self.parent:HasTalent("modifier_antimage_counter_2") then
	self.parent:AddNewModifier(self.parent, self.ability, "modifier_antimage_counterspell_custom_heal", {duration = self.heal_duration})
	unit:AddNewModifier(self.parent, self.ability, "modifier_antimage_counterspell_custom_slow", {duration = self.slow_duration})
	need_effect = true
end

if self.parent:HasTalent("modifier_antimage_hero_6") and not unit:IsInvulnerable() and not unit:HasModifier("modifier_antimage_mana_void_custom_cast_cd") then
	need_effect = true
	unit:AddNewModifier(self.parent, self.ability, "modifier_antimage_mana_void_custom_silence", {duration = self.cast_silence*(1 - unit:GetStatusResistance())})
	unit:AddNewModifier(self.parent, self.ability, "modifier_antimage_mana_void_custom_cast_cd", {duration = self.cast_cd})
end

if not need_effect then return end
unit:EmitSound("Antimage.Void_silence2")
local zap_pfx = ParticleManager:CreateParticle("particles/am_void_cd.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
ParticleManager:SetParticleControlEnt(zap_pfx, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(zap_pfx, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
ParticleManager:ReleaseParticleIndex(zap_pfx)
end


function modifier_antimage_mana_void_custom_tracker:GetAuraRadius() return self.aura_radius end
function modifier_antimage_mana_void_custom_tracker:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_antimage_mana_void_custom_tracker:GetAuraSearchType() return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO end
function modifier_antimage_mana_void_custom_tracker:GetModifierAura() return "modifier_antimage_mana_void_custom_aura_effect" end
function modifier_antimage_mana_void_custom_tracker:IsAura() 
return self.parent:HasTalent("modifier_antimage_void_3") or self.parent:HasTalent("modifier_antimage_hero_4") 
end



modifier_antimage_mana_void_custom_aura_effect = class(mod_visible)
function modifier_antimage_mana_void_custom_aura_effect:IsHidden() return self.health == 0 end
function modifier_antimage_mana_void_custom_aura_effect:GetTexture() return "buffs/antimage/hero_4" end
function modifier_antimage_mana_void_custom_aura_effect:OnCreated(table)
self.parent = self:GetParent()
self.caster = self:GetCaster()
self.ability = self:GetAbility()

self.mana_reduce = self.caster:GetTalentValue("modifier_antimage_hero_4", "mana_reduce")
self.health = self.caster:GetTalentValue("modifier_antimage_hero_4", "health")

self.aura_duration = self.parent:GetTalentValue("modifier_antimage_void_3", "duration", true)

if not IsServer() then return end
if not self.caster:HasTalent("modifier_antimage_void_3") then return end

self:StartIntervalThink(1) 
end

function modifier_antimage_mana_void_custom_aura_effect:OnIntervalThink()
if not IsServer() then return end
if self.parent:GetMaxMana() <= 0 then return end

self.parent:AddNewModifier(self.caster.owner and self.caster.owner or self.caster, self.ability, "modifier_antimage_mana_void_custom_int", {duration = self.aura_duration})
end

function modifier_antimage_mana_void_custom_aura_effect:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_MANACOST_PERCENTAGE_STACKING,
    MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE
}
end

function modifier_antimage_mana_void_custom_aura_effect:GetModifierPercentageManacostStacking()
return self.mana_reduce
end

function modifier_antimage_mana_void_custom_aura_effect:GetModifierExtraHealthPercentage()
return self.health
end



modifier_antimage_mana_void_custom_int = class(mod_visible)
function modifier_antimage_mana_void_custom_int:GetTexture() return "buffs/antimage/manavoid_3" end
function modifier_antimage_mana_void_custom_int:OnCreated(table)
self.parent = self:GetParent()
self.caster = self:GetCaster()

self.max = self.caster:GetTalentValue("modifier_antimage_void_3", "max")
self.stack = self.caster:GetTalentValue("modifier_antimage_void_3", "mana")/100

if not IsServer() then return end
self.effect_cast = self.parent:GenericParticle("particles/am_mana_stack.vpcf", self, true)

self:SetStackCount(1)
self.RemoveForDuel = true
end

function modifier_antimage_mana_void_custom_int:OnRefresh()
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end

self:IncrementStackCount()

if self.parent:IsRealHero() then
	self.parent:CalculateStatBonus(true)
end

end

function modifier_antimage_mana_void_custom_int:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MANA_BONUS,
}
end

function modifier_antimage_mana_void_custom_int:GetModifierManaBonus()
return self:GetStackCount()*self.caster:GetMaxMana()*self.stack
end 

function modifier_antimage_mana_void_custom_int:OnStackCountChanged(iStackCount)
if not IsServer() then return end
if not self.effect_cast then return end
ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, self:GetStackCount(), 0 ) )
end



modifier_antimage_mana_void_custom_cast_cd = class(mod_hidden)
function modifier_antimage_mana_void_custom_cast_cd:OnCreated(table)
self.RemoveForDuel = true
end



modifier_antimage_mana_void_custom_burn = class(mod_hidden)
function modifier_antimage_mana_void_custom_burn:OnCreated()
self.parent = self:GetParent()
self.caster = self:GetCaster()
self.ability = self:GetAbility()

self.nomana_max = self.ability:GetSpecialValueFor("nomana_max")
self.interval = self.caster:GetTalentValue("modifier_antimage_void_1", "interval")
self.max = self.caster:GetTalentValue("modifier_antimage_void_1", "duration")
self.mana = ((self.caster:GetTalentValue("modifier_antimage_void_1", "mana")*self.interval)/100)/self.max
self.max = self.max/self.interval
self.damage_type = self.caster:GetTalentValue("modifier_antimage_void_1", "damage_type")

self.counter = self.caster:FindAbilityByName("antimage_counterspell_custom")

self.damageTable = {victim = self.parent, attacker = self.caster, ability = self.ability, damage_type = self.damage_type}

if not IsServer() then return end
self.parent:GenericParticle("particles/units/heroes/hero_faceless_void/faceless_void_dialatedebuf_2.vpcf", self)

self.count = 0
self:StartIntervalThink(self.interval)
end

function modifier_antimage_mana_void_custom_burn:OnIntervalThink()
if not IsServer() then return end 

local mana = self.parent:GetMaxMana() <= 0 and self.mana*self.nomana_max or self.mana*self.parent:GetMaxMana()
self.damageTable.damage = mana

local real_mana = self.parent:Script_ReduceMana(mana, self.ability) 

if self.caster:HasShard() and self.counter and self.counter:IsTrained() then
	self.counter:ShardMana(real_mana)
end 

DoDamage(self.damageTable, "modifier_antimage_void_1")

self.count = self.count + 1
if self.count >= self.max then
	self:Destroy()
	return
end

end



modifier_antimage_mana_void_custom_perma = class({})
function modifier_antimage_mana_void_custom_perma:IsHidden() return not self.parent:HasTalent("modifier_antimage_hero_5") or self:GetStackCount() >= self.max end
function modifier_antimage_mana_void_custom_perma:IsPurgable() return false end
function modifier_antimage_mana_void_custom_perma:RemoveOnDeath() return false end
function modifier_antimage_mana_void_custom_perma:GetTexture() return "buffs/antimage/hero_5" end
function modifier_antimage_mana_void_custom_perma:OnCreated()
self.parent = self:GetParent()
self.max = self.parent:GetTalentValue("modifier_antimage_hero_5", "max", true)
self.damage = self.parent:GetTalentValue("modifier_antimage_hero_5", "damage", true)

if not IsServer() then return end
self:SetStackCount(1)
self:StartIntervalThink(1)
end

function modifier_antimage_mana_void_custom_perma:OnRefresh()
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end 
self:IncrementStackCount()
end

function modifier_antimage_mana_void_custom_perma:OnIntervalThink()
if not IsServer() then return end 
if self:GetStackCount() < self.max then return end
if not self.parent:HasTalent("modifier_antimage_hero_5") then return end

self.parent:GenericParticle("particles/enigma/summon_perma.vpcf")

self.parent:EmitSound("BS.Thirst_legendary_active")
self:StartIntervalThink(-1)
end 


function modifier_antimage_mana_void_custom_perma:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
  MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE
}
end

function modifier_antimage_mana_void_custom_perma:GetModifierSpellAmplify_Percentage() 
if not self.parent:HasTalent("modifier_antimage_hero_5") then return end
return self:GetStackCount()*self.damage
end

function modifier_antimage_mana_void_custom_perma:GetModifierDamageOutgoing_Percentage() 
if not self.parent:HasTalent("modifier_antimage_hero_5") then return end
return self:GetStackCount()*self.damage
end







antimage_mana_overload_custom = class({})

function antimage_mana_overload_custom:CreateTalent()
self:SetHidden(false)
self:SetLevel(1)
end

function antimage_mana_overload_custom:GetCooldown()
return self:GetCaster():GetTalentValue("modifier_antimage_void_7", "talent_cd")
end

function antimage_mana_overload_custom:GetAbilityTargetFlags()
if self:GetCaster():HasTalent("modifier_antimage_hero_8") then 
	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
else 
	return DOTA_UNIT_TARGET_FLAG_NONE
end

end

function antimage_mana_overload_custom:OnSpellStart()

local caster = self:GetCaster()
local point = self:GetCursorPosition()

local duration = self:GetSpecialValueFor("duration")
local outgoing_damage = self:GetSpecialValueFor("outgoing_damage")
local incoming_damage = self:GetSpecialValueFor("incoming_damage")	

local illusions = CreateIllusions(caster, caster, {duration = duration, outgoing_damage = outgoing_damage, incoming_damage = incoming_damage}, 1, 0, false, false )  

for _,illusion in pairs(illusions) do

	illusion.owner = caster	
	illusion:AddNewModifier(caster, self, "modifier_antimage_mana_void_custom_illusion", {})
	illusion:SetHealth(illusion:GetMaxHealth())

	local direction = (point - illusion:GetAbsOrigin())
	direction.z = 0
	direction = direction:Normalized()

    for _,mod in pairs(self:GetCaster():FindAllModifiers()) do
       if mod.StackOnIllusion ~= nil and mod.StackOnIllusion == true then
          illusion:UpgradeIllusion(mod:GetName(), mod:GetStackCount() )
       end
    end
      
	local particle_start = ParticleManager:CreateParticle( "particles/units/heroes/hero_antimage/antimage_blink_start.vpcf", PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( particle_start, 0, illusion:GetAbsOrigin() )
	ParticleManager:SetParticleControlForward( particle_start, 0, direction:Normalized() )
	ParticleManager:ReleaseParticleIndex( particle_start )
	EmitSoundOnLocationWithCaster( illusion:GetAbsOrigin(), "Hero_Antimage.Blink_out", illusion )

	FindClearSpaceForUnit(illusion, point, true)

	illusion:StartGesture(ACT_DOTA_CAST_ABILITY_2)

	local particle_end = ParticleManager:CreateParticle( "particles/units/heroes/hero_antimage/antimage_blink_end.vpcf", PATTACH_ABSORIGIN_FOLLOW, illusion )
	ParticleManager:SetParticleControl( particle_end, 0, illusion:GetOrigin() )
	ParticleManager:SetParticleControlForward( particle_end, 0, direction:Normalized() )
	ParticleManager:ReleaseParticleIndex( particle_end )
	EmitSoundOnLocationWithCaster( illusion:GetOrigin(), "Hero_Antimage.Blink_in", illusion )

	Timers:CreateTimer(0.1, function()
		illusion:MoveToPositionAggressive(point)
	end)
end

end






modifier_antimage_mana_void_custom_illusion = class(mod_hidden)
function modifier_antimage_mana_void_custom_illusion:OnCreated(table)
if not IsServer() then return end

self.caster = self:GetCaster()
self.ability = self:GetAbility()
self.parent = self:GetParent()

if not self.caster.antimage_illusions then
	self.caster.antimage_illusions = {}
end

self.caster.antimage_illusions[self.parent] = true

self.mana_burn = self.ability:GetSpecialValueFor("mana_burn")/100
self.mana_burn_creeps = self.ability:GetSpecialValueFor("mana_burn_creeps")

self.nomana_max = self.ability:GetSpecialValueFor("nomana_max")
self.damage = self.ability:GetSpecialValueFor("ulti_damage")/100

self.damageTable = {attacker = self.caster, ability = self.ability, damage_type = DAMAGE_TYPE_MAGICAL}

self.counter = self.caster:FindAbilityByName("antimage_counterspell_custom")
self.ulti = self.parent:FindAbilityByName("antimage_mana_void_custom")

self.ready = false
self.delay = self.caster:GetTalentValue("modifier_antimage_void_7", "delay")
if not self.ulti or not self.ulti:IsTrained() then return end

self:StartIntervalThink(self.delay)
end

function modifier_antimage_mana_void_custom_illusion:OnIntervalThink()
if not IsServer() then return end
self.ready = true

self.caster:AddAttackStartEvent_out(self, true)
self:StartIntervalThink(-1)
end


function modifier_antimage_mana_void_custom_illusion:AttackStartEvent_out(params)
if not IsServer() then return end
if self.ready == false then return end
if self.parent ~= params.attacker then return end
if not IsValid(params.target) then return end
if not params.target:IsUnit() or not params.target:IsAlive() then return end

self.parent:CastAbilityOnTarget(params.target, self.ulti, -1)
end



function modifier_antimage_mana_void_custom_illusion:ManaBurn(target)
if not IsServer() then return end

local mana = target:GetMaxMana() <= 0 and self.mana_burn*self.nomana_max or self.mana_burn*target:GetMaxMana()
mana = target:IsCreep() and self.mana_burn_creeps or mana

self.damageTable.damage = mana
self.damageTable.victim = target

DoDamage(self.damageTable)

local real_mana = target:Script_ReduceMana(mana, self.caster:BkbAbility(self.ability, self.caster:HasTalent("modifier_antimage_hero_8"))) 
if self.caster:HasShard() and self.counter and self.counter:IsTrained() then
	self.counter:ShardMana(real_mana)
end 

end


function modifier_antimage_mana_void_custom_illusion:OnDestroy()
if not IsServer() then return end
if not self.caster.antimage_illusions then return end

self.caster.antimage_illusions[self.parent] = nil
end



modifier_antimage_mana_void_custom_silence = class(mod_hidden)
function modifier_antimage_mana_void_custom_silence:IsPurgable() return true end
function modifier_antimage_mana_void_custom_silence:OnCreated()
self.parent = self:GetParent()
self.caster = self:GetCaster()
self.attack_slow = self.caster:GetTalentValue("modifier_antimage_hero_6", "attack_slow")

if not IsServer() then return end
self.parent:EmitSound("Antimage.Void_silence")
self.parent:GenericParticle("particles/anti-mage/void_silence.vpcf", self, true)
end

function modifier_antimage_mana_void_custom_silence:CheckState()
return
{
	[MODIFIER_STATE_SILENCED] = true
}
end

function modifier_antimage_mana_void_custom_silence:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
end

function modifier_antimage_mana_void_custom_silence:GetModifierAttackSpeedBonus_Constant()
return self.attack_slow
end