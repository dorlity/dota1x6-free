item_spirit_vessel_custom = class({})

LinkLuaModifier( "modifier_item_spirit_vessel_custom_passive", "abilities/items/item_spirit_vessel_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_spirit_vessel_custom_active_ally", "abilities/items/item_spirit_vessel_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_spirit_vessel_custom_active_enemy", "abilities/items/item_spirit_vessel_custom", LUA_MODIFIER_MOTION_NONE )

function item_spirit_vessel_custom:GetIntrinsicModifierName()
	return "modifier_item_spirit_vessel_custom_passive"
end

function item_spirit_vessel_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end
PrecacheResource( "particle","particles/items4_fx/spirit_vessel_cast.vpcf", context )
PrecacheResource( "particle","particles/items2_fx/urn_of_shadows_heal.vpcf", context )
PrecacheResource( "particle","particles/items4_fx/spirit_vessel_damage.vpcf", context )
end

function item_spirit_vessel_custom:CastFilterResultTarget(target)
if not IsServer() then return end

if self:GetCurrentCharges() < 1 then 
	self:EndCooldown()
	self:StartCooldown(1)
	return
end

local caster = self:GetCaster()
if caster:GetTeam() ~= target:GetTeam() and target:IsMagicImmune() then
	return UF_FAIL_MAGIC_IMMUNE_ENEMY
end

if target:HasModifier("modifier_waveupgrade_boss") or target:GetUnitName() == "npc_roshan_custom" then 
	return UF_FAIL_OTHER
end

return UnitFilter( target, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), self:GetCaster():GetTeamNumber() )
end


function item_spirit_vessel_custom:OnSpellStart()

local duration = self:GetSpecialValueFor("duration")
local caster = self:GetCaster()
local target = self:GetCursorTarget()

target:EmitSound("DOTA_Item.UrnOfShadows.Activate")

local particle_fx = ParticleManager:CreateParticle("particles/items4_fx/spirit_vessel_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
ParticleManager:SetParticleControl(particle_fx, 0, caster:GetAbsOrigin())
ParticleManager:SetParticleControl(particle_fx, 1, target:GetAbsOrigin())
ParticleManager:ReleaseParticleIndex(particle_fx)

if target:GetTeam() == caster:GetTeam() then
	target:AddNewModifier(caster, self, "modifier_item_spirit_vessel_custom_active_ally", {duration = duration })
else
	target:AddNewModifier(caster, self, "modifier_item_spirit_vessel_custom_active_enemy", {duration = duration })
end

self:SetCurrentCharges(self:GetCurrentCharges() - 1)
end



modifier_item_spirit_vessel_custom_passive = class(mod_visible)
function modifier_item_spirit_vessel_custom_passive:RemoveOnDeath()	return false end
function modifier_item_spirit_vessel_custom_passive:DestroyOnExpire() return false end

function modifier_item_spirit_vessel_custom_passive:OnCreated()
self.item = self:GetAbility()
self.parent = self:GetParent()

if self.parent:IsRealHero() then
	self.parent:AddDeathEvent(self, true)
end

self.soul_cooldown = self.item:GetSpecialValueFor("soul_cooldown")
self.bonus_armor = self.item:GetSpecialValueFor("bonus_armor")
self.bonus_mana_regen = self.item:GetSpecialValueFor("mana_regen")
self.bonus_agility = self.item:GetSpecialValueFor("bonus_all_stats")
self.bonus_strength = self.item:GetSpecialValueFor("bonus_all_stats")
self.bonus_intelligence = self.item:GetSpecialValueFor("bonus_all_stats")
self.health_bonus = self.item:GetSpecialValueFor("bonus_health")
self.mana_bonus = self.item:GetSpecialValueFor("bonus_mana")
self.radius = self.item:GetSpecialValueFor("soul_radius")
self.kill_charges = self.item:GetSpecialValueFor("soul_additional_charges")
self.max_health = self.item:GetSpecialValueFor("max_health")
self.max_mana = self.item:GetSpecialValueFor("max_mana")
if not IsSoloMode() then
	self.kill_charges = self.item:GetSpecialValueFor("duo_charge")
end
self.duration = self.soul_cooldown
self.max_stacks = self.item:GetSpecialValueFor("max_stacks")

if not IsServer() then return end

if not self.item.init then
	self.item.init = true
	self.item:SetCurrentCharges(math.max(self.item:GetCurrentCharges(), self.item:GetSpecialValueFor("init_charges")))
end

self:OnIntervalThink()
self:StartIntervalThink(1)
end

function modifier_item_spirit_vessel_custom_passive:OnIntervalThink()
if not IsServer() then return end
if not self.item or self.item:IsNull() then return end

local stack = math.min(self.max_stacks, self.item:GetSecondaryCharges())

if stack == self:GetStackCount() then return end

self:SetStackCount(stack)
self.parent:CalculateStatBonus(true)
end

function modifier_item_spirit_vessel_custom_passive:DeclareFunctions()
return 
{
	MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
	MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	MODIFIER_PROPERTY_HEALTH_BONUS,
	MODIFIER_PROPERTY_MANA_BONUS,
	MODIFIER_PROPERTY_TOOLTIP
}
end

function modifier_item_spirit_vessel_custom_passive:OnTooltip()
return self:GetStackCount()
end

function modifier_item_spirit_vessel_custom_passive:GetModifierConstantManaRegen()
return self.bonus_mana_regen
end

function modifier_item_spirit_vessel_custom_passive:GetModifierPhysicalArmorBonus()
return self.bonus_armor
end

function modifier_item_spirit_vessel_custom_passive:GetModifierBonusStats_Agility()
return self.bonus_agility
end

function modifier_item_spirit_vessel_custom_passive:GetModifierBonusStats_Intellect()
return self.bonus_intelligence
end

function modifier_item_spirit_vessel_custom_passive:GetModifierBonusStats_Strength()
return self.bonus_strength
end

function modifier_item_spirit_vessel_custom_passive:GetModifierHealthBonus()
return self.health_bonus + self:GetStackCount()*self.max_health
end

function modifier_item_spirit_vessel_custom_passive:GetModifierManaBonus()
return self.mana_bonus + self:GetStackCount()*self.max_mana
end

function modifier_item_spirit_vessel_custom_passive:DeathEvent(params)
local target = params.unit
if not self.parent:IsRealHero() then return end
if not target:IsValidKill(self.parent) then return end 
if not self.parent:IsAlive() then return end 

if ((self.parent:GetAbsOrigin() - target:GetAbsOrigin()):Length2D() <= self.radius or (params.attacker and params.attacker == self.parent)) then
	self.item:SetCurrentCharges(self.item:GetCurrentCharges() + self.kill_charges)
	self.item:SetSecondaryCharges(self.item:GetSecondaryCharges() + self.kill_charges)
end

end





modifier_item_spirit_vessel_custom_active_ally = class({})
function modifier_item_spirit_vessel_custom_active_ally:IsHidden() return false end
function modifier_item_spirit_vessel_custom_active_ally:IsPurgable() return true end
function modifier_item_spirit_vessel_custom_active_ally:IsDebuff() return false end
function modifier_item_spirit_vessel_custom_active_ally:OnCreated( params )
self.health_regen = self:GetAbility():GetSpecialValueFor("soul_heal_amount")
end

function modifier_item_spirit_vessel_custom_active_ally:DeclareFunctions()
return 
{
	MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
}
end

function modifier_item_spirit_vessel_custom_active_ally:GetEffectName()
return "particles/items2_fx/urn_of_shadows_heal.vpcf"
end

function modifier_item_spirit_vessel_custom_active_ally:GetEffectAttachType()
return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_item_spirit_vessel_custom_active_ally:GetModifierConstantHealthRegen()
return self.health_regen
end



modifier_item_spirit_vessel_custom_active_enemy = class({})
function modifier_item_spirit_vessel_custom_active_enemy:IsPurgable() return true end
function modifier_item_spirit_vessel_custom_active_enemy:IsHidden() return false end

function modifier_item_spirit_vessel_custom_active_enemy:GetEffectName()
return "particles/items4_fx/spirit_vessel_damage.vpcf"
end

function modifier_item_spirit_vessel_custom_active_enemy:GetEffectAttachType()
return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_item_spirit_vessel_custom_active_enemy:OnCreated( params )
self.damage_per_second = self:GetAbility():GetSpecialValueFor("soul_damage_amount")
self.enemy_hp_drain = self:GetAbility():GetSpecialValueFor("enemy_hp_drain") / 100
self.hp_reduction_heal = -1 * self:GetAbility():GetSpecialValueFor("hp_regen_reduction_enemy")
self:StartIntervalThink(1)
end

function modifier_item_spirit_vessel_custom_active_enemy:OnIntervalThink()
if not IsServer() then return end
local damageTable = {
	victim = self:GetParent(),
	attacker = self:GetCaster(),
	damage = self.damage_per_second + (self:GetParent():GetHealth()*self.enemy_hp_drain),
	damage_type = DAMAGE_TYPE_PURE,
	ability = self:GetAbility()
}
DoDamage(damageTable)
end

function modifier_item_spirit_vessel_custom_active_enemy:DeclareFunctions()
return 
{
    MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
    MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE,
    MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
}
end

function modifier_item_spirit_vessel_custom_active_enemy:GetModifierLifestealRegenAmplify_Percentage()
return self.hp_reduction_heal
end

function modifier_item_spirit_vessel_custom_active_enemy:GetModifierHealAmplify_PercentageTarget()
return self.hp_reduction_heal
end

function modifier_item_spirit_vessel_custom_active_enemy:GetModifierHPRegenAmplify_Percentage()
return self.hp_reduction_heal
end