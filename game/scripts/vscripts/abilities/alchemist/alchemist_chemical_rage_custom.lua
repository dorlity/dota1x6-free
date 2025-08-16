LinkLuaModifier( "modifier_alchemist_chemical_rage_custom", "abilities/alchemist/alchemist_chemical_rage_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_alchemist_chemical_rage_custom_legendary", "abilities/alchemist/alchemist_chemical_rage_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_alchemist_chemical_rage_tracker", "abilities/alchemist/alchemist_chemical_rage_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_alchemist_chemical_rage_custom_incoming", "abilities/alchemist/alchemist_chemical_rage_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_alchemist_chemical_rage_custom_attack", "abilities/alchemist/alchemist_chemical_rage_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_alchemist_chemical_rage_custom_low_cd", "abilities/alchemist/alchemist_chemical_rage_custom", LUA_MODIFIER_MOTION_NONE )


alchemist_chemical_rage_custom = class({})




function alchemist_chemical_rage_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end
PrecacheResource( "particle", "particles/units/heroes/hero_alchemist/alchemist_chemical_rage.vpcf", context )
PrecacheResource( "particle", "particles/alch_cleave.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_alchemist/alchemist_chemical_rage_hero_effect.vpcf", context )
PrecacheResource( "particle", "particles/alchemist/rage_legendary.vpcf", context )
PrecacheResource( "particle", "particles/econ/items/bounty_hunter/prince_ratsia/prince_ratsia_jinada.vpcf", context )
PrecacheResource( "particle", "particles/items4_fx/nullifier_mute.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_alchemist/alchemist_berserk_buff.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_pangolier/pangolier_tailthump_buff.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_pangolier/pangolier_tailthump_buff_egg.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_pangolier/pangolier_tailthump_buff_streaks.vpcf", context )
end


function alchemist_chemical_rage_custom:GetIntrinsicModifierName()
if not self:GetCaster():IsRealHero() then return end
return "modifier_alchemist_chemical_rage_tracker"
end


function alchemist_chemical_rage_custom:GetCooldown(iLevel)
local cooldown_reduction = 0
if self:GetCaster():HasTalent("modifier_alchemist_hero_4") then
	cooldown_reduction = self:GetCaster():GetTalentValue("modifier_alchemist_hero_4", "cd")
end
return self.BaseClass.GetCooldown(self, iLevel) + cooldown_reduction
end


function alchemist_chemical_rage_custom:OnSpellStart()
local caster = self:GetCaster()
local buff_duration = self:GetSpecialValueFor("duration") + caster:GetTalentValue("modifier_alchemist_hero_4", "duration")

caster:StartGesture(ACT_DOTA_ALCHEMIST_CHEMICAL_RAGE_START)
caster:AddNewModifier(caster, self, "modifier_alchemist_chemical_rage_custom", {duration = buff_duration, passive = 0})

caster:EmitSound("Hero_Alchemist.ChemicalRage.Cast")
ProjectileManager:ProjectileDodge( self:GetCaster() )
end




modifier_alchemist_chemical_rage_custom = class(mod_visible)
function modifier_alchemist_chemical_rage_custom:AllowIllusionDuplicate() return true end
function modifier_alchemist_chemical_rage_custom:OnCreated( table )

self.parent = self:GetParent()
self.ability = self:GetAbility()

self.bat = self.ability:GetSpecialValueFor( "base_attack_time" )
self.bva_bonus = self.parent:GetTalentValue("modifier_alchemist_rage_3", "bva")

self.health_regen = self.ability:GetSpecialValueFor( "bonus_health_regen" )
self.movespeed = self.ability:GetSpecialValueFor( "bonus_movespeed" )

if not IsServer() then return end

self.parent:Purge( false, true, false, false, false )

if self.parent:HasTalent("modifier_alchemist_hero_8") then 
	local duration = self.parent:GetTalentValue("modifier_alchemist_hero_8", "duration", true)
	self.parent:AddNewModifier(self.parent, self.ability, "modifier_generic_debuff_immune", {effect = 1, duration = duration})
	self.parent:AddNewModifier(self.parent, self.ability, "modifier_alchemist_chemical_rage_custom_incoming", {duration = duration})
end 

self.ability:EndCd()

local ability = self.parent:FindAbilityByName("alchemist_enrage_potion")
if ability then
	ability:SetActivated(true)
end

self.RemoveForDuel = true

self.parent:GenericParticle(self.parent:HasModifier("modifier_alchemist_radiance_item_custom") and "particles/econ/items/alchemist/alchemist_aurelian_weapon/alchemist_chemical_rage_aurelian.vpcf" or "particles/units/heroes/hero_alchemist/alchemist_chemical_rage.vpcf", self)
self.parent:EmitSound("Hero_Alchemist.ChemicalRage")
end




function modifier_alchemist_chemical_rage_custom:OnDestroy()
if not IsServer() then return end

self.parent:StartGesture(ACT_DOTA_ALCHEMIST_CHEMICAL_RAGE_END)

self.ability:StartCd()

self.parent:StopSound("Hero_Alchemist.ChemicalRage")

local ability = self.parent:FindAbilityByName("alchemist_enrage_potion")
if ability then
	ability:SetActivated(false)
end

self.parent:RemoveModifierByName("modifier_alchemist_chemical_rage_custom_legendary")
end


function modifier_alchemist_chemical_rage_custom:DeclareFunctions()
return 
{
	MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
	MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
	MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
	MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND,
}
end


function modifier_alchemist_chemical_rage_custom:GetModifierBaseAttackTimeConstant()
local bonus = 0 
if self.parent:HasModifier("modifier_alchemist_chemical_rage_custom_legendary") then 
	bonus = self.bva_bonus
end 
return self.bat + bonus
end

function modifier_alchemist_chemical_rage_custom:GetModifierConstantHealthRegen()
return self.health_regen
end

function modifier_alchemist_chemical_rage_custom:GetModifierMoveSpeedBonus_Constant()
return self.movespeed
end

function modifier_alchemist_chemical_rage_custom:GetHeroEffectName()
return "particles/units/heroes/hero_alchemist/alchemist_chemical_rage_hero_effect.vpcf"
end

function modifier_alchemist_chemical_rage_custom:GetActivityTranslationModifiers()
return "chemical_rage"
end

function modifier_alchemist_chemical_rage_custom:GetAttackSound()
return "Hero_Alchemist.ChemicalRage.Attack"
end







alchemist_enrage_potion = class({})

function alchemist_enrage_potion:CreateTalent(name)
local caster = self:GetCaster()
self:SetHidden(false)
self:SetActivated(caster:HasModifier("modifier_alchemist_chemical_rage_custom"))

if name == "modifier_alchemist_rage_legendary" and dota1x6.current_wave >= upgrade_orange then 
  local max = caster:GetTalentValue("modifier_alchemist_rage_legendary", "orbs_count")
  for i = 1, max do
  	dota1x6:CreateUpgradeOrb(caster, 1)
  end
end

end




function alchemist_enrage_potion:GetCooldown()
return self:GetCaster():GetTalentValue("modifier_alchemist_rage_legendary", "cd", true)
end

function alchemist_enrage_potion:OnSpellStart() 
local caster = self:GetCaster()

caster:EmitSound("Alch.Weapon_legendary_vo")
caster:EmitSound("Alch.Weapon_legendary2")
caster:EmitSound("Alch.Weapon_legendary")
caster:AddNewModifier(caster, self, "modifier_alchemist_chemical_rage_custom_legendary", {duration = caster:GetTalentValue("modifier_alchemist_rage_legendary", "duration", true)})
end





modifier_alchemist_chemical_rage_custom_legendary = class(mod_visible)
function modifier_alchemist_chemical_rage_custom_legendary:OnCreated( kv )
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.bonus_range = self.parent:GetTalentValue("modifier_alchemist_rage_4", "range")

self.cast_bonus = self.parent:HasTalent("modifier_alchemist_rage_4") and 100 or 0
self.rotate = 0
self.ignore_cast = self.parent:HasTalent("modifier_alchemist_rage_4") and 1 or 0

self.bonus_move = self.parent:GetTalentValue("modifier_alchemist_rage_4", "move")

self.heal_creeps = self.parent:GetTalentValue("modifier_alchemist_rage_3", "creeps", true)
self.heal = self.parent:GetTalentValue("modifier_alchemist_rage_3", "heal")/100

if not IsServer() then return end
self.ability:EndCd()

if self.parent:HasTalent("modifier_alchemist_rage_3") then
	self.parent:AddDamageEvent_out(self, true)
end

local mod = self.parent:FindModifierByName("modifier_general_stats")
if mod then
	mod:OnIntervalThink()
end

self.attack_count = 0
self.attack_max = 1/self.parent:GetAttacksPerSecond(true)

self.interval = 0.01

self.parent:GenericParticle("particles/generic_gameplay/rune_arcane_owner.vpcf", self)
self.parent:GenericParticle("particles/alchemist/rage_legendary.vpcf", self)
self.parent:GenericParticle("particles/generic_gameplay/rune_doubledamage_owner.vpcf", self)

for i = 1,2 do 
	self.parent:GenericParticle("particles/units/heroes/hero_alchemist/alchemist_berserk_buff.vpcf", self)
end 

self.parent:CalculateStatBonus(true)

if not self.parent:HasTalent("modifier_alchemist_rage_4") then return end

self:StartIntervalThink(self.interval)
end


function modifier_alchemist_chemical_rage_custom_legendary:OnDestroy()
if not IsServer() then return end
self.ability:StartCd()
if not self.parent:HasModifier("modifier_alchemist_chemical_rage_custom") then
	self.ability:SetActivated(false)
end

local mod = self.parent:FindModifierByName("modifier_general_stats")
if mod then
	mod:OnIntervalThink()
end

self.parent:CalculateStatBonus(true)
end


function modifier_alchemist_chemical_rage_custom_legendary:OnIntervalThink()
if not IsServer() then return end

local enemies = self.parent:FindTargets(self.parent:Script_GetAttackRange() + self.bonus_range)

for id, enemy in pairs(enemies) do
	if enemy:IsAttackImmune() or not enemy:IsUnit() or not self.parent:CanEntityBeSeenByMyTeam(enemy) then
		table.remove(enemies, id)
	end
end

self.attack_count = self.attack_count + self.interval
self.attack_max = 1/self.parent:GetAttacksPerSecond(true)

if #enemies <= 0 then self.rotate = 0 return end

self.rotate = 1
local direction = enemies[1]:GetAbsOrigin() - self.parent:GetAbsOrigin()
direction.z = 0
direction = direction:Normalized()


if self.attack_count >= self.attack_max 
 and not self.parent:IsStunned() and not self.parent:IsHexed() and not dota1x6:CheckDisarm(self.parent) and not self.parent:IsChanneling() then 

	self.attack_count = 0

	self.parent:FadeGesture(ACT_DOTA_ATTACK)
	self.parent:FadeGesture(ACT_DOTA_ATTACK2)
	self.parent:StartGestureWithPlaybackRate(ACT_DOTA_ATTACK, self.parent:GetDisplayAttackSpeed()/100)

	self.parent:PerformAttack(enemies[1], true, true, false, false, true, false, false)

	local mod = self.parent:FindModifierByName("modifier_alchemist_corrosive_weaponry_custom")
	if mod then
		mod:AttackRecordEvent_out({attacker = self.parent, target = enemies[1]})
	end
end 

if not self.parent:IsCurrentlyHorizontalMotionControlled() and not self.parent:IsCurrentlyVerticalMotionControlled() then
	self.parent:SetForwardVector(direction)
	self.parent:FaceTowards(enemies[1]:GetAbsOrigin())
end

end

function modifier_alchemist_chemical_rage_custom_legendary:CheckState()
if not self.parent:HasTalent("modifier_alchemist_rage_4") then return end
return
{
	[MODIFIER_STATE_DISARMED] = true
}
end

function modifier_alchemist_chemical_rage_custom_legendary:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_DISABLE_TURNING,
	MODIFIER_PROPERTY_IGNORE_CAST_ANGLE,
	MODIFIER_PROPERTY_CASTTIME_PERCENTAGE,
	MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	MODIFIER_PROPERTY_MODEL_SCALE
}
end

function modifier_alchemist_chemical_rage_custom_legendary:GetModifierMoveSpeedBonus_Constant()
return self.bonus_move
end

function modifier_alchemist_chemical_rage_custom_legendary:GetModifierDisableTurning()
return self.rotate
end

function modifier_alchemist_chemical_rage_custom_legendary:GetModifierIgnoreCastAngle()
return self.ignore_cast
end

function modifier_alchemist_chemical_rage_custom_legendary:GetModifierPercentageCasttime()
return self.cast_bonus
end

function modifier_alchemist_chemical_rage_custom_legendary:GetModifierModelScale()
return 20
end



function modifier_alchemist_chemical_rage_custom_legendary:DamageEvent_out(params)
if not IsServer() then return end
if not self.parent:HasTalent("modifier_alchemist_rage_3") then return end
if not self.parent:CheckLifesteal(params) then return end

local heal = params.damage*self.heal
heal = params.unit:IsCreep() and heal/self.heal_creeps or heal

self.parent:GenericHeal(heal, self.ability, true, "", "modifier_alchemist_rage_3")
end







modifier_alchemist_chemical_rage_custom_incoming = class(mod_hidden)
function modifier_alchemist_chemical_rage_custom_incoming:OnCreated(table)
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.damage_reduce = self.parent:GetTalentValue("modifier_alchemist_hero_8", "damage_reduce")
if not IsServer() then return end

self.parent:EmitSound("UI.Generic_shield")
self.buff_particles = {}
self.buff_particles[1] = ParticleManager:CreateParticle("particles/units/heroes/hero_pangolier/pangolier_tailthump_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
ParticleManager:SetParticleControlEnt(self.buff_particles[1], 1, self.parent, PATTACH_ABSORIGIN_FOLLOW, nil, Vector(0,0,0), false) 
self:AddParticle(self.buff_particles[1], false, false, -1, true, false)
ParticleManager:SetParticleControl( self.buff_particles[1], 3, Vector( 255, 255, 255 ) )

self.buff_particles[2] = ParticleManager:CreateParticle("particles/units/heroes/hero_pangolier/pangolier_tailthump_buff_egg.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
ParticleManager:SetParticleControlEnt(self.buff_particles[2], 1, self.parent, PATTACH_ABSORIGIN_FOLLOW, nil, Vector(0,0,0), false) 
self:AddParticle(self.buff_particles[2], false, false, -1, true, false)

self.buff_particles[3] = ParticleManager:CreateParticle("particles/units/heroes/hero_pangolier/pangolier_tailthump_buff_streaks.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
ParticleManager:SetParticleControlEnt(self.buff_particles[3], 1, self.parent, PATTACH_ABSORIGIN_FOLLOW, nil, Vector(0,0,0), false) 
self:AddParticle(self.buff_particles[3], false, false, -1, true, false)
end

function modifier_alchemist_chemical_rage_custom_incoming:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
}
end

function modifier_alchemist_chemical_rage_custom_incoming:GetModifierIncomingDamage_Percentage()
return self.damage_reduce
end







modifier_alchemist_chemical_rage_tracker = class({})
function modifier_alchemist_chemical_rage_tracker:IsHidden() return true end
function modifier_alchemist_chemical_rage_tracker:IsPurgable() return false end
function modifier_alchemist_chemical_rage_tracker:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
}
end

function modifier_alchemist_chemical_rage_tracker:GetModifierAttackRangeBonus()
return self.range_bonus
end 


function modifier_alchemist_chemical_rage_tracker:OnCreated()
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.cleave = self.parent:GetTalentValue("modifier_alchemist_rage_2", "cleave")/100
self.range_bonus = self.parent:GetTalentValue("modifier_alchemist_rage_2", "range")

self.attack_duration = self.parent:GetTalentValue("modifier_alchemist_rage_1", "duration", true)

self.low_health = self.parent:GetTalentValue("modifier_alchemist_hero_8", "health", true)
self.low_cd = self.parent:GetTalentValue("modifier_alchemist_hero_8", "cd", true)
self.low_duration = self.parent:GetTalentValue("modifier_alchemist_hero_8", "duration", true)

if not IsServer() then return end
self:SetHasCustomTransmitterData(true)
self:UpdateTalent()
end

function modifier_alchemist_chemical_rage_tracker:UpdateTalent(name)
if not IsServer() then return end

if name == "modifier_alchemist_rage_1" or self.parent:HasTalent("modifier_alchemist_rage_1") then
	self.parent:AddAttackEvent_out(self)
end

if name == "modifier_alchemist_rage_2" or self.parent:HasTalent("modifier_alchemist_rage_2") then
	self.parent:AddAttackEvent_out(self)
	self.cleave = self.parent:GetTalentValue("modifier_alchemist_rage_2", "cleave")/100
	self.range_bonus = self.parent:GetTalentValue("modifier_alchemist_rage_2", "range")
end

if name == "modifier_alchemist_hero_8" or self.parent:HasTalent("modifier_alchemist_hero_8") then
	self.parent:AddDamageEvent_inc(self, true)
end

self:SendBuffRefreshToClients()
end

function modifier_alchemist_chemical_rage_tracker:AddCustomTransmitterData() 
return 
{
  range_bonus = self.range_bonus,
} 
end

function modifier_alchemist_chemical_rage_tracker:HandleCustomTransmitterData(data)
self.range_bonus = data.range_bonus
end

function modifier_alchemist_chemical_rage_tracker:DamageEvent_inc(params)
if not IsServer() then return end
if not self.parent:HasTalent("modifier_alchemist_hero_8") then return end
if self.parent ~= params.unit then return end
if self.parent:PassivesDisabled() then return end
if not self.parent:IsAlive() then return end
if self.parent:GetHealthPercent() > self.low_health then return end
if self.parent:HasModifier("modifier_death") then return end
if self.parent:HasModifier("modifier_alchemist_chemical_rage_custom_low_cd") then return end

self.parent:AddNewModifier(self.parent, self.ability, "modifier_alchemist_chemical_rage_custom_low_cd", {duration = self.low_cd})

self.parent:EmitSound("Alchemist.Lowhp_bkb")
self.parent:AddNewModifier(self.parent, self.ability, "modifier_generic_debuff_immune", {effect = 1, duration = self.low_duration})
self.parent:AddNewModifier(self.parent, self.ability, "modifier_alchemist_chemical_rage_custom_incoming", {duration = self.low_duration})
end



function modifier_alchemist_chemical_rage_tracker:AttackEvent_out(params)
if not IsServer() then return end
if self.parent ~= params.attacker then return end
if not params.target:IsUnit() then return end

if self.parent:HasTalent("modifier_alchemist_rage_2") then
	DoCleaveAttack(self.parent, params.target, nil, params.damage * self.cleave  , 150, 360, 650, "particles/alch_cleave.vpcf")
end

if self.parent:HasTalent("modifier_alchemist_rage_1") then
	self.parent:AddNewModifier(self.parent, self.ability, "modifier_alchemist_chemical_rage_custom_attack", {duration = self.attack_duration, target = params.target:entindex()})
end

end





modifier_alchemist_chemical_rage_custom_attack = class(mod_visible)
function modifier_alchemist_chemical_rage_custom_attack:GetTexture() return "buffs/alchemist/rage_1" end
function modifier_alchemist_chemical_rage_custom_attack:OnCreated()
self.parent = self:GetParent()

self.attacks = self.parent:GetTalentValue("modifier_alchemist_rage_1", "attacks")
self.damage = self.parent:GetTalentValue("modifier_alchemist_rage_1", "damage")
self.gold = self.parent:GetTalentValue("modifier_alchemist_rage_1", "gold")
self.creeps = self.parent:GetTalentValue("modifier_alchemist_rage_1", "creeps")

self:SetStackCount(1)
end

function modifier_alchemist_chemical_rage_custom_attack:OnRefresh(table)
if not IsServer() then return end

self:IncrementStackCount()

if self:GetStackCount() < self.attacks then return end
local target = EntIndexToHScript(table.target)
if target and not target:IsNull() then
	target:EmitSound("Alch.gold_attack")

	local bonus_gold = target:IsRealHero() and self.gold or self.gold/self.creeps

	self.parent:ModifyGold(bonus_gold , true , DOTA_ModifyGold_Unspecified)

	local digit = string.len(tostring(math.floor(bonus_gold))) + 1
	local effect_cast_2 = ParticleManager:CreateParticle( "particles/units/heroes/hero_alchemist/alchemist_lasthit_msg_gold.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
	ParticleManager:SetParticleControl( effect_cast_2, 1, Vector( 0, bonus_gold, 0 ) )
	ParticleManager:SetParticleControl( effect_cast_2, 2, Vector( 1, digit, 0 ) )
	ParticleManager:SetParticleControl( effect_cast_2, 3, Vector( 255, 255, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast_2 )

	local item_effect = ParticleManager:CreateParticle( "particles/econ/items/bounty_hunter/prince_ratsia/prince_ratsia_jinada.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControlEnt(item_effect, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true )
	ParticleManager:SetParticleControlEnt(item_effect, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetOrigin(), true )
	ParticleManager:ReleaseParticleIndex(item_effect)
end


self:Destroy()
end

function modifier_alchemist_chemical_rage_custom_attack:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
}
end

function modifier_alchemist_chemical_rage_custom_attack:GetModifierPreAttack_BonusDamage()
if self:GetStackCount() ~= self.attacks - 1 then return end
return self.damage
end


modifier_alchemist_chemical_rage_custom_low_cd = class(mod_cd)
function modifier_alchemist_chemical_rage_custom_low_cd:GetTexture() return "buffs/alchemist/hero_8" end
