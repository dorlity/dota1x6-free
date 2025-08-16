LinkLuaModifier("modifier_item_abyssal_blade_custom", "abilities/items/item_abyssal_blade_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_abyssal_blade_custom_cd", "abilities/items/item_abyssal_blade_custom", LUA_MODIFIER_MOTION_NONE)

item_abyssal_blade_custom = class({})

function item_abyssal_blade_custom:GetIntrinsicModifierName() 
return "modifier_item_abyssal_blade_custom" 
end


function item_abyssal_blade_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end

PrecacheResource( "particle", "particles/items_fx/abyssal_blade.vpcf", context )
PrecacheResource( "particle", "particles/items_fx/abyssal_blade_crimson_jugger.vpcf", context )
PrecacheResource( "particle", "particles/items_fx/abyssal_blade_jugger.vpcf", context )
PrecacheResource( "particle", "particles/items_fx/abyssal_blade_jugger_golden.vpcf", context )
end



function item_abyssal_blade_custom:OnSpellStart()
local caster = self:GetCaster()
local target = self:GetCursorTarget()

if target:TriggerSpellAbsorb(self) then return end

local stun = self:GetSpecialValueFor("stun_duration")

target:EmitSound("DOTA_Item.AbyssalBlade.Activate")
local effect = "particles/items_fx/abyssal_blade.vpcf"
if caster:HasModifier("modifier_juggernaut_edge_of_the_lost") then
    effect = "particles/items_fx/abyssal_blade_jugger.vpcf"
end
if caster:HasModifier("modifier_juggernaut_edge_of_the_lost_gold") then
    effect = "particles/items_fx/abyssal_blade_jugger_golden.vpcf"
end
if caster:HasModifier("modifier_juggernaut_edge_of_the_lost_crimson") then
    effect = "particles/items_fx/abyssal_blade_crimson_jugger.vpcf"
end

target:GenericParticle(effect)
target:AddNewModifier(caster, self, "modifier_bashed", {duration = (1 - target:GetStatusResistance())*stun})
caster:AddNewModifier(caster, self, "modifier_item_abyssal_blade_custom_cd", {duration = self:GetSpecialValueFor("bash_cooldown")})
end


modifier_item_abyssal_blade_custom = class({})

function modifier_item_abyssal_blade_custom:IsHidden() return true end
function modifier_item_abyssal_blade_custom:IsPurgable() return false end
function modifier_item_abyssal_blade_custom:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE  end

function modifier_item_abyssal_blade_custom:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
    MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
    MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL,
    MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
    MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
    MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE
}
end

function modifier_item_abyssal_blade_custom:GetModifierBonusStats_Strength() 
return self.str
end

function modifier_item_abyssal_blade_custom:GetModifierPreAttack_BonusDamage() 
return self.damage
end

function modifier_item_abyssal_blade_custom:GetModifierLifestealRegenAmplify_Percentage() 
return self.heal_amp
end

function modifier_item_abyssal_blade_custom:GetModifierHealAmplify_PercentageTarget() 
return self.heal_amp
end

function modifier_item_abyssal_blade_custom:GetModifierHPRegenAmplify_Percentage() 
return self.heal_amp
end

function modifier_item_abyssal_blade_custom:OnCreated(table)
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.str = self.ability:GetSpecialValueFor("bonus_str")
self.damage = self.ability:GetSpecialValueFor("bonus_attack_damage")
self.heal_amp = self.ability:GetSpecialValueFor("heal_amp")

self.bash_cd = self.ability:GetSpecialValueFor("bash_cooldown")
self.chance_melee = self.ability:GetSpecialValueFor("bash_chance_melee")
self.chance_range = self.ability:GetSpecialValueFor("bash_chance_ranged")
self.bash_duration = self.ability:GetSpecialValueFor("bash_duration")
self.bash_damage = self.ability:GetSpecialValueFor("bonus_chance_damage")

if not IsServer() then return end
self.mod = self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_sange", {})
end


function modifier_item_abyssal_blade_custom:OnDestroy()
if not IsServer() then return end
if not self.mod or self.mod:IsNull() then return end
self.mod:Destroy()
end

function modifier_item_abyssal_blade_custom:GetModifierProcAttack_BonusDamage_Physical(params)
if not IsServer() then return end
if self.parent:HasModifier("modifier_item_abyssal_blade_custom_cd") then return end
if not self.parent:IsRealHero() or self.parent:IsTempestDouble() then return end
if self.parent:FindAllModifiersByName(self:GetName())[1] ~= self then return end
if self.parent ~= params.attacker then return end
if not params.target:IsUnit() then return end

local chance = self.chance_melee
if params.ranged_attack then
    chance = self.chance_range
end

if not RollPseudoRandomPercentage(chance, 4516, self.parent) then return end

local target = params.target

target:EmitSound("DOTA_Item.SkullBasher")
target:AddNewModifier(self.parent, self.ability, "modifier_bashed", {duration = (1 - target:GetStatusResistance())*self.bash_duration})
self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_abyssal_blade_custom_cd", {duration = self.bash_cd})

target:SendNumber(4, self.bash_damage)

if self.parent:HasModifier("modifier_troll_warlord_ti7_immortal_weapon_custom") then
    local immortal_particle = ParticleManager:CreateParticle("particles/econ/items/troll_warlord/troll_warlord_ti7_axe/troll_ti7_axe_bash_explosion.vpcf", PATTACH_OVERHEAD_FOLLOW, target)
    ParticleManager:SetParticleControl(immortal_particle, 0, target:GetAbsOrigin())
    ParticleManager:SetParticleControl(immortal_particle, 1, self.parent:GetAbsOrigin() )
    ParticleManager:Delete(immortal_particle, 1)
end

return self.bash_damage
end


modifier_item_abyssal_blade_custom_cd = class({})
function modifier_item_abyssal_blade_custom_cd:IsHidden() return true end
function modifier_item_abyssal_blade_custom_cd:IsPurgable() return false end
function modifier_item_abyssal_blade_custom_cd:RemoveOnDeath() return false end