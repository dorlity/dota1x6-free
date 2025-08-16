LinkLuaModifier( "modifier_life_stealer_rage_custom_tracker", "abilities/life_stealer/life_stealer_rage_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_life_stealer_rage_custom", "abilities/life_stealer/life_stealer_rage_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_life_stealer_rage_custom_charge", "abilities/life_stealer/life_stealer_rage_custom", LUA_MODIFIER_MOTION_HORIZONTAL )
LinkLuaModifier( "modifier_life_stealer_rage_custom_armor", "abilities/life_stealer/life_stealer_rage_custom", LUA_MODIFIER_MOTION_NONE )


life_stealer_rage_custom = class({})
life_stealer_rage_custom.active_mod = nil

function life_stealer_rage_custom:GetAbilityTextureName()
local caster = self:GetCaster()
if caster:HasModifier("modifier_lifestealer_immortal_back_custom_golden") then
    return "life_stealer_rage_immortal_gold"
end
if caster:HasModifier("modifier_lifestealer_immortal_back_custom") then
    return "life_stealer_rage_immortal"
end
if caster:HasModifier("modifier_ls_bloody_ripper_head_1") then
    return "life_stealer/bloody_ripper_abilityicons/life_stealer_rage"
end
if caster:HasModifier("modifier_ls_bloody_ripper_head_2") then
    return "life_stealer/promo_bloody_ripper_abilityicons/life_stealer_rage"
end
return "life_stealer_rage"
end

function life_stealer_rage_custom:CreateTalent()
self:ToggleAutoCast()
end


function life_stealer_rage_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end

PrecacheResource( "particle", "particles/units/heroes/hero_life_stealer/life_stealer_rage.vpcf", context )
PrecacheResource( "particle", "particles/econ/items/bloodseeker/bloodseeker_ti7/bloodseeker_ti7_thirst_owner.vpcf", context )
end


function life_stealer_rage_custom:GetIntrinsicModifierName()
if not self:GetCaster():IsRealHero() or self:GetCaster():IsCreepHero() then return end
return "modifier_life_stealer_rage_custom_tracker"
end


function life_stealer_rage_custom:GetBehavior()
local caster = self:GetCaster()
local bonus = caster:HasTalent("modifier_lifestealer_rage_4") and DOTA_ABILITY_BEHAVIOR_AUTOCAST or 0
local stun_use = caster:HasTalent("modifier_lifestealer_hero_5") and DOTA_ABILITY_BEHAVIOR_IGNORE_PSEUDO_QUEUE or 0
return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + bonus + stun_use
end



function life_stealer_rage_custom:GetManaCost(level)
if self:GetCaster():HasTalent("modifier_lifestealer_rage_7") then
	return 0
end
return self.BaseClass.GetManaCost(self,level)
end


function life_stealer_rage_custom:GetHealthCost(level)
local caster = self:GetCaster()
if not caster:HasTalent("modifier_lifestealer_rage_7") then return end
return caster:GetHealth()*caster:GetTalentValue("modifier_lifestealer_rage_7", "health")/100
end

function life_stealer_rage_custom:GetCooldown(level)
local caster = self:GetCaster()
local bonus = 0
local k = 1
if caster:HasTalent("modifier_lifestealer_rage_7") then
	k = (caster:GetTalentValue("modifier_lifestealer_rage_7", "cd")/100)*-1
end
if caster:HasTalent("modifier_lifestealer_rage_2") then
	bonus = caster:GetTalentValue("modifier_lifestealer_rage_2", "cd")
end
return (self.BaseClass.GetCooldown( self, level ) + bonus)*k
end



function life_stealer_rage_custom:OnSpellStart()
local caster = self:GetCaster()
local target = caster

if test then
--	caster:PrintModifiers()
end

local mod = caster:FindModifierByName("modifier_life_stealer_infest_custom")
if mod and mod.is_legendary == 1 and mod.target then
	target = mod.target
	if caster:HasTalent("modifier_lifestealer_rage_7") then
		target:SetHealth(math.max(1, target:GetHealth()*(1 - caster:GetTalentValue("modifier_lifestealer_rage_7", "health")/100)))
	end
	target:RemoveModifierByName("modifier_life_stealer_infest_custom_legendary_creep_status")
end

local duration = self:GetSpecialValueFor("duration") + caster:GetTalentValue("modifier_lifestealer_rage_2", "duration")

if caster:HasTalent("modifier_lifestealer_rage_7") then
	duration = duration*(1 + caster:GetTalentValue("modifier_lifestealer_rage_7", "cd")/100)
end

if caster:HasTalent("modifier_lifestealer_rage_4") and self:GetAutoCastState() then
	target:AddNewModifier(caster, self, "modifier_life_stealer_rage_custom_charge", {duration = caster:GetTalentValue("modifier_lifestealer_rage_4", "duration")})
end

target:EmitSound("Hero_LifeStealer.Rage")
target:Purge(false, true, false, caster:HasTalent("modifier_lifestealer_hero_5"), false)
caster:StartGesture(ACT_DOTA_LIFESTEALER_RAGE)

target:AddNewModifier(caster, self, "modifier_life_stealer_rage_custom", {duration = duration})
end





modifier_life_stealer_rage_custom = class(mod_visible)
function modifier_life_stealer_rage_custom:OnCreated()
self.parent = self:GetParent()
self.caster = self:GetCaster()
self.ability = self:GetAbility()

self.speed = self.caster:GetTalentValue("modifier_lifestealer_rage_3", "speed")*(1 - self.parent:GetHealthPercent()/100)

self.movespeed = self.caster:GetTalentValue("modifier_lifestealer_rage_4", "move")

self.status = self.caster:GetTalentValue("modifier_lifestealer_hero_5", "status")
self.damage_reduce = self.caster:GetTalentValue("modifier_lifestealer_hero_5", "damage_reduce")

self.magic_resist = self.ability:GetSpecialValueFor("magic_resist")
if not IsServer() then return end
self.RemoveForDuel = true
self.ability.active_mod = self
self.ability:EndCd()

if self.caster:HasTalent("modifier_lifestealer_rage_3") then
	self:SetStackCount(self.speed)
end

self.armor_duration = self.caster:GetTalentValue("modifier_lifestealer_rage_1", "duration")
if self.caster:HasTalent("modifier_lifestealer_rage_1") then
	self.caster:AddAttackEvent_out(self, true)
end

local pfx_name = "particles/units/heroes/hero_life_stealer/life_stealer_rage.vpcf"
if self.caster:HasModifier("modifier_lifestealer_immortal_back_custom") then
    pfx_name = "particles/econ/items/lifestealer/lifestealer_immortal_backbone/lifestealer_immortal_backbone_rage.vpcf"
    if self.caster ~= nil and self.caster.particles_items_data_custom ~= nil and self.caster.particles_items_data_custom["back"] ~= nil then
        for _, particle in pairs(self.caster.particles_items_data_custom["back"]) do
            ParticleManager:DestroyParticle(particle, true)
        end
    end
    if self.caster.items_data_custom ~= nil then
        if self.caster.items_data_custom["back"] ~= nil then
            self.caster.items_data_custom["back"]:SetModel("models/items/lifestealer/immortal_back/lifestealer_immortal_back_rage.vmdl")
            self.caster.items_data_custom["back"]:SetOriginalModel("models/items/lifestealer/immortal_back/lifestealer_immortal_back_rage.vmdl")
            local new_fx = ParticleManager:CreateParticle("particles/econ/items/lifestealer/lifestealer_immortal_backbone/lifestealer_immortal_backbone_rage_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.caster.items_data_custom["back"])
            table.insert(self.caster.particles_items_data_custom["back"], new_fx)
        end
    end
end
if self.caster:HasModifier("modifier_lifestealer_immortal_back_custom_golden") then
    pfx_name = "particles/econ/items/lifestealer/lifestealer_immortal_backbone_gold/lifestealer_immortal_backbone_gold_rage.vpcf"
    if self.caster ~= nil and self.caster.particles_items_data_custom ~= nil and self.caster.particles_items_data_custom["back"] ~= nil then
        for _, particle in pairs(self.caster.particles_items_data_custom["back"]) do
            ParticleManager:DestroyParticle(particle, true)
        end
    end
    if self.caster.items_data_custom ~= nil then
        if self.caster.items_data_custom["back"] ~= nil then
            self.caster.items_data_custom["back"]:SetModel("models/items/lifestealer/immortal_back/lifestealer_immortal_back_rage_golden.vmdl")
            self.caster.items_data_custom["back"]:SetOriginalModel("models/items/lifestealer/immortal_back/lifestealer_immortal_back_rage_golden.vmdl")
            local new_fx = ParticleManager:CreateParticle("particles/econ/items/lifestealer/lifestealer_immortal_backbone_gold/lifestealer_immortal_backbone_rage_ambient_gold.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.caster.items_data_custom["back"])
            table.insert(self.caster.particles_items_data_custom["back"], new_fx)
        end
    end
end

local rage_particle = self.parent:GenericParticle(pfx_name, self)
ParticleManager:SetParticleControlEnt(rage_particle, 2, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)

self.bkb = self.parent:AddNewModifier(self.caster, self.ability, "modifier_generic_debuff_immune", {magic_damage = self.magic_resist})
end

function modifier_life_stealer_rage_custom:OnDestroy()
if not IsServer() then return end
self.ability.active_mod = nil
self.ability:StartCd()

if self.bkb and not self.bkb:IsNull() then
	self.bkb:Destroy()
end

if self.parent ~= self.caster then
	self.parent:AddNewModifier(self.parent, nil, "modifier_life_stealer_infest_custom_legendary_creep_status", {})
end

if self.caster:HasModifier("modifier_lifestealer_immortal_back_custom") then
    if self.caster ~= nil and self.caster.particles_items_data_custom ~= nil and self.caster.particles_items_data_custom["back"] ~= nil then
        for _, particle in pairs(self.caster.particles_items_data_custom["back"]) do
            ParticleManager:DestroyParticle(particle, true)
        end
    end
    if self.caster.items_data_custom ~= nil then
        if self.caster.items_data_custom["back"] ~= nil then
            self.caster.items_data_custom["back"]:SetModel("models/items/lifestealer/immortal_back/lifestealer_immortal_back.vmdl")
            self.caster.items_data_custom["back"]:SetOriginalModel("models/items/lifestealer/immortal_back/lifestealer_immortal_back.vmdl")
            local new_fx = ParticleManager:CreateParticle("particles/econ/items/lifestealer/lifestealer_immortal_backbone/lifestealer_immortal_backbone_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.caster.items_data_custom["back"])
            ParticleManager:SetParticleControlEnt(new_fx, 1, self.caster.items_data_custom["back"], PATTACH_POINT_FOLLOW, "attach_heart", self.caster.items_data_custom["back"]:GetOrigin(), true)
            table.insert(self.caster.particles_items_data_custom["back"], new_fx)
        end
    end
end
if self.caster:HasModifier("modifier_lifestealer_immortal_back_custom_golden") then
    if self.caster ~= nil and self.caster.particles_items_data_custom ~= nil and self.caster.particles_items_data_custom["back"] ~= nil then
        for _, particle in pairs(self.caster.particles_items_data_custom["back"]) do
            ParticleManager:DestroyParticle(particle, true)
        end
    end
    if self.caster.items_data_custom ~= nil then
        if self.caster.items_data_custom["back"] ~= nil then
            self.caster.items_data_custom["back"]:SetModel("models/items/lifestealer/immortal_back/lifestealer_immortal_back_golden.vmdl")
            self.caster.items_data_custom["back"]:SetOriginalModel("models/items/lifestealer/immortal_back/lifestealer_immortal_back_golden.vmdl")
            local new_fx = ParticleManager:CreateParticle("particles/econ/items/lifestealer/lifestealer_immortal_backbone_gold/lifestealer_immortal_backbone_gold_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.caster.items_data_custom["back"])
            ParticleManager:SetParticleControlEnt(new_fx, 1, self.caster.items_data_custom["back"], PATTACH_POINT_FOLLOW, "attach_heart", self.caster.items_data_custom["back"]:GetOrigin(), true)
            table.insert(self.caster.particles_items_data_custom["back"], new_fx)
        end
    end
end
end


function modifier_life_stealer_rage_custom:AttackEvent_out(params)
if not IsServer() then return end
if not self.caster:HasTalent("modifier_lifestealer_rage_1") then return end
if self.parent ~= params.attacker then return end
if not params.target:IsUnit() then return end

params.target:AddNewModifier(self.caster, self.parent:BkbAbility(self.ability, true), "modifier_life_stealer_rage_custom_armor", {duration = self.armor_duration})
end


function modifier_life_stealer_rage_custom:GetStatusEffectName()
if self.parent:HasModifier("modifier_lifestealer_immortal_back_custom") then
    return "particles/econ/items/lifestealer/lifestealer_immortal_backbone/status_effect_life_stealer_immortal_rage.vpcf"
end
if self.parent:HasModifier("modifier_lifestealer_immortal_back_custom_golden") then
    return "particles/econ/items/lifestealer/lifestealer_immortal_backbone_gold/status_effect_life_stealer_immortal_rage_gold.vpcf"
end
return "particles/status_fx/status_effect_life_stealer_rage.vpcf"
end

function modifier_life_stealer_rage_custom:StatusEffectPriority()
return MODIFIER_PRIORITY_SUPER_ULTRA
end

function modifier_life_stealer_rage_custom:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
  MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
  MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end

function modifier_life_stealer_rage_custom:GetModifierAttackSpeedBonus_Constant()
return self.speed
end

function modifier_life_stealer_rage_custom:GetModifierStatusResistanceStacking()
return self.status
end

function modifier_life_stealer_rage_custom:GetModifierIncomingDamage_Percentage()
return self.damage_reduce*(1 - self.parent:GetHealthPercent()/100)
end

function modifier_life_stealer_rage_custom:GetModifierMoveSpeedBonus_Percentage()
return self.movespeed
end





modifier_life_stealer_rage_custom_tracker = class(mod_hidden)
function modifier_life_stealer_rage_custom_tracker:OnCreated()
self.parent = self:GetParent()
self.caster = self:GetCaster()
self.ability = self:GetAbility()

self.armor = self.caster:GetTalentValue("modifier_lifestealer_rage_1", "armor")

self.heal_inc = self.caster:GetTalentValue("modifier_lifestealer_hero_1", "heal")
self.heal_bonus = self.caster:GetTalentValue("modifier_lifestealer_hero_1", "bonus", true)

self.PercentStr = self.caster:GetTalentValue("modifier_lifestealer_rage_3", "str")/100

if not IsServer() then return end

self:SetHasCustomTransmitterData(true)
self:StartIntervalThink(2)
self:UpdateTalent()
end

function modifier_life_stealer_rage_custom_tracker:OnIntervalThink()
if not IsServer() then return end

if (not self.ability.active_mod or self.ability.active_mod:IsNull()) and not self.ability:IsActivated() then
	self.ability:StartCd()
end

end

function modifier_life_stealer_rage_custom_tracker:UpdateTalent(name)
if not IsServer() then return end

if name == "modifier_lifestealer_rage_3" or self.caster:HasTalent("modifier_lifestealer_rage_3") then
	self.PercentStr = self.caster:GetTalentValue("modifier_lifestealer_rage_3", "str")/100
end

if name == "modifier_lifestealer_rage_1" or self.caster:HasTalent("modifier_lifestealer_rage_1") then
	self.armor = self.caster:GetTalentValue("modifier_lifestealer_rage_1", "armor")
end

if name == "modifier_lifestealer_hero_1" or self.caster:HasTalent("modifier_lifestealer_hero_1") then
	self.heal_inc = self.caster:GetTalentValue("modifier_lifestealer_hero_1", "heal")
end

local mod = self.parent:FindModifierByName("modifier_life_stealer_infest_custom")
if mod and mod.target and mod.is_legendary == 1 and mod.target:HasModifier(self:GetName()) then
	mod.target:FindModifierByName(self:GetName()):UpdateTalent(name)
end

self:SendBuffRefreshToClients()
end

function modifier_life_stealer_rage_custom_tracker:AddCustomTransmitterData() 
return 
{
  armor = self.armor,
  heal_inc = self.heal_inc,
} 
end

function modifier_life_stealer_rage_custom_tracker:HandleCustomTransmitterData(data)
self.armor = data.armor
self.heal_inc = data.heal_inc
end


function modifier_life_stealer_rage_custom_tracker:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
  MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
  MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
  MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE,
}
end

function modifier_life_stealer_rage_custom_tracker:GetModifierPhysicalArmorBonus()
return self.armor
end

function modifier_life_stealer_rage_custom_tracker:GetModifierLifestealRegenAmplify_Percentage() 
return self.parent:HasModifier("modifier_life_stealer_rage_custom") and self.heal_inc*self.heal_bonus or self.heal_inc
end

function modifier_life_stealer_rage_custom_tracker:GetModifierHealAmplify_PercentageTarget()
return self.parent:HasModifier("modifier_life_stealer_rage_custom") and self.heal_inc*self.heal_bonus or self.heal_inc
end

function modifier_life_stealer_rage_custom_tracker:GetModifierHPRegenAmplify_Percentage() 
return self.parent:HasModifier("modifier_life_stealer_rage_custom") and self.heal_inc*self.heal_bonus or self.heal_inc
end







modifier_life_stealer_rage_custom_charge = class(mod_hidden)
function modifier_life_stealer_rage_custom_charge:OnCreated(kv)
if not IsServer() then return end
self.parent = self:GetParent()
self.caster = self:GetCaster()

self.parent:EmitSound("Alch.Unstable_charge")
self.angle = self.parent:GetForwardVector():Normalized()
self.speed = self.caster:GetTalentValue("modifier_lifestealer_rage_4", "range") / self:GetDuration()
self.parent:GenericParticle("particles/econ/items/bloodseeker/bloodseeker_ti7/bloodseeker_ti7_thirst_owner.vpcf", self)

if self:ApplyHorizontalMotionController() == false then
  self:Destroy()
end

end

function modifier_life_stealer_rage_custom_charge:CheckState()
return
{
    [MODIFIER_STATE_INVULNERABLE] = true,
    [MODIFIER_STATE_NO_HEALTH_BAR] = true
}
end

function modifier_life_stealer_rage_custom_charge:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_DISABLE_TURNING
}
end

function modifier_life_stealer_rage_custom_charge:GetModifierDisableTurning() return 1 end

function modifier_life_stealer_rage_custom_charge:OnDestroy()
if not IsServer() then return end
self.parent:InterruptMotionControllers( true )

local dir = self.parent:GetForwardVector()
dir.z = 0
self.parent:SetForwardVector(dir)
self.parent:FaceTowards(self.parent:GetAbsOrigin() + dir*10)
ResolveNPCPositions(self.parent:GetAbsOrigin(), 128)
end


function modifier_life_stealer_rage_custom_charge:UpdateHorizontalMotion( me, dt )
if not IsServer() then return end
local pos = self.parent:GetAbsOrigin()
GridNav:DestroyTreesAroundPoint(pos, 80, false)

local pos_p = self.angle * self.speed * dt
local next_pos = GetGroundPosition(pos + pos_p, self.parent)
self.parent:SetAbsOrigin(next_pos)
end

function modifier_life_stealer_rage_custom_charge:OnHorizontalMotionInterrupted()
self:Destroy()
end



modifier_life_stealer_rage_custom_armor = class(mod_hidden)
function modifier_life_stealer_rage_custom_armor:OnCreated()
self.armor = self:GetCaster():GetTalentValue("modifier_lifestealer_rage_1", "armor")*-1
end

function modifier_life_stealer_rage_custom_armor:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
}
end

function modifier_life_stealer_rage_custom_armor:GetModifierPhysicalArmorBonus()
return self.armor
end