LinkLuaModifier( "modifier_life_stealer_infest_custom_tracker", "abilities/life_stealer/life_stealer_infest_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_life_stealer_infest_custom", "abilities/life_stealer/life_stealer_infest_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_life_stealer_infest_custom_bonus", "abilities/life_stealer/life_stealer_infest_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_life_stealer_infest_custom_legendary_creep", "abilities/life_stealer/life_stealer_infest_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_life_stealer_infest_custom_legendary_creep_status", "abilities/life_stealer/life_stealer_infest_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_life_stealer_infest_custom_legendary_autocast", "abilities/life_stealer/life_stealer_infest_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_life_stealer_infest_custom_legendary_pick", "abilities/life_stealer/life_stealer_infest_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_life_stealer_infest_custom_legendary_pick_cd", "abilities/life_stealer/life_stealer_infest_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_life_stealer_infest_custom_legendary_saved", "abilities/life_stealer/life_stealer_infest_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_life_stealer_infest_custom_legendary_bonus", "abilities/life_stealer/life_stealer_infest_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_life_stealer_infest_custom_break", "abilities/life_stealer/life_stealer_infest_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_life_stealer_infest_custom_attack_damage", "abilities/life_stealer/life_stealer_infest_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_life_stealer_infest_custom_health_bonus", "abilities/life_stealer/life_stealer_infest_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_life_stealer_infest_custom_heal_reduce", "abilities/life_stealer/life_stealer_infest_custom", LUA_MODIFIER_MOTION_NONE )



life_stealer_infest_custom = class({})

function life_stealer_infest_custom:GetAbilityTextureName()
local caster = self:GetCaster()
if caster:HasModifier("modifier_ls_ti10_custom_golden") then
    return "life_stealer/ls_ti10_immortal_ability_icons/life_stealer_infest_ti10_gold"
end
if caster:HasModifier("modifier_ls_ti10_custom") then
    return "life_stealer/ls_ti10_immortal_ability_icons/life_stealer_infest_ti10"
end
if caster:HasModifier("modifier_ls_bloody_ripper_head_1") then
    return "life_stealer/bloody_ripper_abilityicons/life_stealer_infest"
end
if caster:HasModifier("modifier_ls_bloody_ripper_head_2") then
    return "life_stealer/promo_bloody_ripper_abilityicons/life_stealer_infest"
end
return "life_stealer_infest"
end

function life_stealer_infest_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end


PrecacheResource( "particle", "particles/units/heroes/hero_life_stealer/life_stealer_infest_cast.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_life_stealer/life_stealer_infested_unit.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_life_stealer/life_stealer_infest_emerge_bloody.vpcf", context )
end


function life_stealer_infest_custom:GetIntrinsicModifierName()
if not self:GetCaster():IsRealHero() then return end
return "modifier_life_stealer_infest_custom_tracker"
end

function life_stealer_infest_custom:GetCooldown(level)
local bonus = 0
if self:GetCaster():HasTalent("modifier_lifestealer_infest_2") then
	bonus = self:GetCaster():GetTalentValue("modifier_lifestealer_infest_2", "cd")
end
return self.BaseClass.GetCooldown( self, level ) + bonus
end

function life_stealer_infest_custom:OnAbilityPhaseStart()
self:GetCaster():StartGesture(ACT_DOTA_CAST_ABILITY_6)
return true
end

function life_stealer_infest_custom:CastFilterResultTarget(target)
local caster = self:GetCaster()
if not target then return end
if target == caster then
	return UF_FAIL_OTHER 
end
if target:GetTeamNumber() == caster:GetTeamNumber() and not target:IsHero() then
	return UF_FAIL_CREEP 
end
return UnitFilter(target, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, self:GetCaster():GetTeamNumber())
end



function life_stealer_infest_custom:OnSpellStart()
local caster = self:GetCaster()
local target = self:GetCursorTarget()

if target:TriggerSpellAbsorb(self) then return end
if caster:GetUnitName() ~= "npc_dota_hero_life_stealer" then return end

caster:RemoveGesture(ACT_DOTA_CAST_ABILITY_6)

local effect = ParticleManager:CreateParticle("particles/units/heroes/hero_life_stealer/life_stealer_infest_cast.vpcf", PATTACH_POINT, target)
ParticleManager:SetParticleControl(effect, 0, caster:GetAbsOrigin())
ParticleManager:SetParticleControlEnt(effect, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
ParticleManager:ReleaseParticleIndex(effect)

local is_creep = target:IsCreep() and not target:IsConsideredHero() and target:GetTeamNumber() == DOTA_TEAM_NEUTRALS and not target:IsAncient() and not target.is_patrol_creep
local is_ally = target:GetTeamNumber() == caster:GetTeamNumber() and 1 or 0

local duration = nil
if not is_creep  then
	duration = self:GetSpecialValueFor("infest_duration_enemy") + caster:GetTalentValue("modifier_lifestealer_hero_8", "duration_infest")
else
	target:SetOwner(caster)
	target:SetTeam(caster:GetTeamNumber())
	target:SetControllableByPlayer(caster:GetPlayerOwnerID(), true)
	target.owner = caster
	target:AddNewModifier(caster, self, "modifier_life_stealer_infest_creep", {})
	target:AddNewModifier(caster, self, "modifier_life_stealer_infest_custom_bonus", {})
	target:RemoveModifierByName("modifier_neutral_cast")
	target:RemoveModifierByName("modifier_neutral_cast_cd")

	local abilities = 
	{
		["neutral_centaur_stun"] = "neutral_centaur_stun_active",
		["neutral_bird_tornado"] = "neutral_bird_tornado_active",
		["neutral_cone_armor"] = "neutral_cone_armor_active",
		["neutral_harpy_strike"] = "neutral_harpy_strike_active",
		["neutral_ogre_armor"] = "neutral_ogre_armor_active",
		["neutral_satyr_purge"] = "neutral_satyr_purge_active",
		["neutral_satyr_shockwave"] = "neutral_satyr_shockwave_active",
		["neutral_ursa_clap"] = "neutral_ursa_clap_active",
		["neutral_troll_raise"] = "neutral_troll_root_active",
		["neutral_golem_stun"] = "neutral_golem_stun_active",
	}

	for name,new_name in pairs(abilities) do
		local old_ability = target:FindAbilityByName(name)
		if old_ability then
			local new_ability = target:AddAbility(new_name)
			new_ability:SetLevel(1)
			target:SwapAbilities(name, new_name, false, true)
			target:RemoveAbility(name)
		end
	end

	if target:HasAbility("mud_golem_rock_destroy") then
		target:RemoveAbility("mud_golem_rock_destroy")
	end

	for i = 0, 4 do
		local creep_ability = target:GetAbilityByIndex(i)
		if not creep_ability then
			target:AddAbility("generic_hidden")
		end
	end
	local ability = target:AddAbility("life_stealer_consume_custom")
	ability:SetLevel(1)
	ability:SetHidden(false)
end

if is_ally == 1 then
	duration = nil
	target:AddNewModifier(caster, self, "modifier_life_stealer_infest_custom_bonus", {})
end

caster:AddNewModifier(caster, self, "modifier_life_stealer_infest_custom", {target = target:entindex(), is_creep = is_creep, is_ally = is_ally, duration = duration, is_legendary = false})
end


modifier_life_stealer_infest_custom = class(mod_visible)
function modifier_life_stealer_infest_custom:OnCreated(table)
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.radius = self.ability:GetSpecialValueFor("radius")
self.damage = self.ability:GetSpecialValueFor("damage")*(1 + self.parent:GetTalentValue("modifier_lifestealer_infest_1", "damage_infest")/100)
self.regen = self.ability:GetSpecialValueFor("self_regen")
self.duration = self:GetRemainingTime()

if not IsServer() then return end

self.health_loss = self.parent:GetTalentValue("modifier_lifestealer_infest_7", "health")/100

self.shield_duration = self.parent:GetTalentValue("modifier_lifestealer_hero_7", "duration", true)
self.shield_max = self.parent:GetTalentValue("modifier_lifestealer_hero_7", "shield", true)/100

self.health_duration = self.parent:GetTalentValue("modifier_lifestealer_infest_2", "duration", true)

self.infest_break = self.parent:GetTalentValue("modifier_lifestealer_hero_8", "infest_break", true)

self.damage_duration = self.parent:GetTalentValue("modifier_lifestealer_infest_3", "effect_duration", true)

self.cd_items = self.parent:GetTalentValue("modifier_lifestealer_infest_4", "cd_items")

self.parent:RemoveModifierByName("modifier_item_echo_sabre_custom_speed")
self.parent:RemoveModifierByName("modifier_item_harpoon_custom_speed")

self.RemoveForDuel = true
--self.parent:AddNoDraw()
self.parent:NoDraw(self)

self.target = EntIndexToHScript(table.target)
self.target:EmitSound("Hero_LifeStealer.Infest")

self.is_creep = table.is_creep
self.is_legendary = table.is_legendary
self.is_ally = table.is_ally

local pfx_name = "particles/units/heroes/hero_life_stealer/life_stealer_infested_unit.vpcf"
if self.parent:HasModifier("modifier_ls_ti10_custom") then
    pfx_name = "particles/econ/items/lifestealer/ls_ti10_immortal/ls_ti10_immortal_infest_icon_glow.vpcf"
end
if self.parent:HasModifier("modifier_ls_ti10_custom_golden") then
    pfx_name = "particles/econ/items/lifestealer/ls_ti10_immortal/ls_ti10_immortal_infest_icon_gold_glow.vpcf"
end

if self.is_legendary == 1 then
	self.target:GenericParticle("particles/units/heroes/hero_life_stealer/life_stealer_infested_unit.vpcf", self, true)
elseif self.is_creep == 1 or self.is_ally == 1 then
	local effect = ParticleManager:CreateParticleForTeam(pfx_name, PATTACH_OVERHEAD_FOLLOW, self.target, self.parent:GetTeamNumber())
	self:AddParticle( effect, false, false, -1, false, false  )
else
	if self.parent:HasTalent("modifier_lifestealer_hero_8") and not self.parent:HasTalent("modifier_lifestealer_infest_7") then
		self.target:EmitSound("DOTA_Item.SilverEdge.Target")
		self.target:AddNewModifier(self.parent, self.ability, "modifier_life_stealer_infest_custom_break", {duration = self:GetRemainingTime() + 0.1})
	end
	self.target:GenericParticle(pfx_name, self, true)
end

local main_name = self.parent:HasTalent("modifier_lifestealer_infest_7") and "life_stealer_infest_custom_legendary" or "life_stealer_infest_custom"
self.parent:SwapAbilities(main_name, "life_stealer_consume_custom", false, true)
local ability = self.parent:FindAbilityByName("life_stealer_consume_custom")
if ability then
	ability:StartCooldown(0.5)
end

self.interval = FrameTime()
self.attack_timer = 0
self.attack_count = 0
self.attack_interval = 1 - FrameTime()

self:OnIntervalThink()
self:StartIntervalThink(self.interval)
end

function modifier_life_stealer_infest_custom:OnIntervalThink()
if not IsServer() then return end
if not self.target or self.target:IsNull() or not self.target:IsAlive() then
	self:Destroy()
	return
end

self.parent:SetOrigin(self.target:GetAbsOrigin())

if self.is_creep == 1 or self.is_ally == 1 then return end

self.attack_timer = self.attack_timer + self.interval
if self.attack_timer < self.attack_interval then return end

self.attack_timer = 0
self.attack_count = self.attack_count + 1

self.parent:AddNewModifier(self.parent, self.ability, "modifier_life_stealer_infest_custom_attack_damage", {duration = FrameTime()})
self.parent:PerformAttack(self.target, true, true, false, true, false, false, true)
self.parent:RemoveModifierByName("modifier_life_stealer_infest_custom_attack_damage")

if self.parent:HasTalent("modifier_lifestealer_infest_3") then
	self.target:AddNewModifier(self.parent, self.ability, "modifier_life_stealer_infest_custom_heal_reduce", {duration = self.damage_duration})
end

if self.parent:HasTalent("modifier_lifestealer_infest_4") then
	self.parent:CdItems(self.cd_items)
end

end

function modifier_life_stealer_infest_custom:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
	MODIFIER_PROPERTY_MODEL_CHANGE
}
end

function modifier_life_stealer_infest_custom:GetModifierHealthRegenPercentage()
return self.regen 
end
function modifier_life_stealer_infest_custom:GetModifierModelChange()
return "models/development/invisiblebox.vmdl"
end

function modifier_life_stealer_infest_custom:CheckState()
local result = 
{
	[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	[MODIFIER_STATE_INVULNERABLE] = true,
	[MODIFIER_STATE_OUT_OF_GAME] = true,
	[MODIFIER_STATE_UNTARGETABLE] = true,
	[MODIFIER_STATE_UNSELECTABLE] = true,
	[MODIFIER_STATE_ROOTED] = true,
	[MODIFIER_STATE_NO_HEALTH_BAR] = true,
	[MODIFIER_STATE_DISARMED] = true,
}

if self.is_legendary == 0 then
	result[MODIFIER_STATE_SILENCED] = true
	result[MODIFIER_STATE_MUTED] = true
end

return result
end

function modifier_life_stealer_infest_custom:OnDestroy(table)
if not IsServer() then return end
self.parent:RemoveNoDraw()

local main_name = self.parent:HasTalent("modifier_lifestealer_infest_7") and "life_stealer_infest_custom_legendary" or "life_stealer_infest_custom"
self.parent:SwapAbilities(main_name, "life_stealer_consume_custom", true, false)

local ability = self.parent:FindAbilityByName(main_name)
if ability then
	ability:StartCd()
end

self.parent:StartGesture(ACT_DOTA_LIFESTEALER_INFEST_END)

FindClearSpaceForUnit(self.parent, self.parent:GetAbsOrigin(), true)
local sound_name = "Hero_LifeStealer.Consume"
if self.parent:HasModifier("modifier_ls_ti10_custom") or self.parent:HasModifier("modifier_ls_ti10_custom_golden") then
    sound_name = "Hero_LifeStealer.Consume.TI10"
end
EmitSoundOnLocationWithCaster(self.parent:GetAbsOrigin(), sound_name, self.parent)

self.parent:Purge(false, true, false, false, true)

local pfx_name = "particles/units/heroes/hero_life_stealer/life_stealer_infest_emerge_bloody.vpcf"
if self.parent:HasModifier("modifier_ls_ti10_custom") then
    pfx_name = "particles/econ/items/lifestealer/ls_ti10_immortal/ls_ti10_immortal_infest.vpcf"
end
if self.parent:HasModifier("modifier_ls_ti10_custom_golden") then
    pfx_name = "particles/econ/items/lifestealer/ls_ti10_immortal/ls_ti10_immortal_infest_gold.vpcf"
end
self.parent:GenericParticle(pfx_name)

self.damageTable = {attacker = self.parent, ability = self.ability, damage_type = DAMAGE_TYPE_MAGICAL, damage = self.damage}

for _,target in pairs(self.parent:FindTargets(self.radius)) do
	self.damageTable.victim = target
	DoDamage(self.damageTable)
end

if self.parent:HasTalent("modifier_lifestealer_infest_2") and not self.parent:HasTalent("modifier_lifestealer_infest_7") and self.target and not self.target:IsNull() then
	self.parent:RemoveModifierByName("modifier_life_stealer_infest_custom_health_bonus")
	self.parent:AddNewModifier(self.parent, self.ability, "modifier_life_stealer_infest_custom_health_bonus", {duration = self.health_duration, health = self.target:GetMaxHealth()*self.parent:GetTalentValue("modifier_lifestealer_infest_2", "health")/100})
end

if self.parent:HasTalent("modifier_lifestealer_hero_7") then
	self.parent:AddNewModifier(self.parent, self.ability, "modifier_life_stealer_ghoul_frenzy_custom_shield", {duration = self.shield_duration, shield = self.parent:GetMaxHealth()*self.shield_max})
end

self.target:RemoveModifierByName("modifier_life_stealer_infest_custom_break")
if self.target and not self.target:IsNull() and self.is_creep == 0 and self.is_ally == 0 and self.parent:HasTalent("modifier_lifestealer_hero_8") and not self.parent:HasTalent("modifier_lifestealer_infest_7") then
	self.target:AddNewModifier(self.parent, self.ability, "modifier_life_stealer_infest_custom_break", {duration = self.infest_break})
end

if self.is_legendary == 1 and self.target and not self.target:IsNull() and self.target:GetHealth() <= 1 then
	self.parent:SetHealth(math.max(1, self.parent:GetHealth() - self.parent:GetMaxHealth()*self.health_loss))
end

if self.is_creep == 1 then
	self.target:Kill(self.ability, self.parent)
end

self.target:RemoveModifierByName("modifier_life_stealer_infest_custom_bonus")

if self.is_legendary == 1 then
	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self.parent:GetId()), "select_unit_custom", { index = self.parent:entindex() })
end

end




life_stealer_consume_custom = class({})

function life_stealer_consume_custom:GetAbilityTextureName()
    local caster = self:GetCaster()
    if caster:HasModifier("modifier_ls_ti10_custom") then
        return "life_stealer/ls_ti10_immortal_ability_icons/life_stealer_consume_ti10"
    end
    if caster:HasModifier("modifier_ls_ti10_custom_golden") then
        return "life_stealer/ls_ti10_immortal_ability_icons/life_stealer_consume_ti10_gold"
    end
    return "life_stealer_consume"
end

function life_stealer_consume_custom:OnSpellStart()
local caster = self:GetCaster()
if caster.owner then
	caster = caster.owner
end

local mod = caster:FindModifierByName("modifier_life_stealer_infest_custom")
if not mod then return end
mod:Destroy()
end




modifier_life_stealer_infest_custom_bonus = class(mod_hidden)
function modifier_life_stealer_infest_custom_bonus:RemoveOnDeath() return false end
function modifier_life_stealer_infest_custom_bonus:OnCreated()
self.parent = self:GetParent()
self.caster = self:GetCaster()
self.ability = self:GetAbility()

self.move_speed = self.ability:GetSpecialValueFor("bonus_movement_speed")
self.health = self.ability:GetSpecialValueFor("bonus_health")

if not IsServer() then return end

if self.parent:IsCreep() then
	self.parent:SetBaseMaxHealth(self.parent:GetBaseMaxHealth() + self.health)

	local ability = self.parent:FindAbilityByName("life_stealer_consume")
	if ability then
		ability:SetHidden(true)
	end
	self:StartIntervalThink(0.1)
end

end

function modifier_life_stealer_infest_custom_bonus:OnIntervalThink()
if not IsServer() then return end
local ability = self.parent:FindAbilityByName("life_stealer_consume")
if ability then
	ability:SetHidden(true)
end
self:StartIntervalThink(-1)
end

function modifier_life_stealer_infest_custom_bonus:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	MODIFIER_PROPERTY_HEALTH_BONUS
}
end

function modifier_life_stealer_infest_custom_bonus:GetModifierHealthBonus()
if not self.parent:IsHero() then return end
return self.health
end

function modifier_life_stealer_infest_custom_bonus:GetModifierMoveSpeedBonus_Percentage()
return self.move_speed
end



life_stealer_infest_custom_legendary = class({})

function life_stealer_infest_custom_legendary:OnInventoryContentsChanged()
local caster = self:GetCaster()

if not caster:HasShard() then return end

local mod = caster:FindModifierByName("modifier_life_stealer_infest_custom")
if not mod or not mod.target or mod.is_legendary ~= 1 then return end

local ability = mod.target:FindAbilityByName("life_stealer_unfettered_custom")
if ability and ability:IsHidden() then
	ability:SetHidden(false)
end

end


function life_stealer_infest_custom_legendary:CreateTalent()
local caster = self:GetCaster()
local ability = caster:FindAbilityByName("life_stealer_infest_custom")
if not ability then return end

caster:AddNewModifier(caster, self, "modifier_life_stealer_infest_custom_legendary_saved", {name = "npc_lifestealer_infest_ursa"})
caster:SwapAbilities(self:GetName(), "life_stealer_infest_custom", not ability:IsHidden(), false)
end

function life_stealer_infest_custom_legendary:CheckToggle()
local caster = self:GetCaster()
if caster:HasModifier("modifier_life_stealer_infest_custom_legendary_pick_cd") then
    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(caster:GetId()), "CreateIngameErrorMessage", {message = "#midteleport_cd"})
    return false
end
return true
end

function life_stealer_infest_custom_legendary:GetCooldown(level)
local bonus = 0
if self:GetCaster():HasTalent("modifier_lifestealer_infest_2") then
	bonus = self:GetCaster():GetTalentValue("modifier_lifestealer_infest_2", "cd")
end
return self.BaseClass.GetCooldown( self, level ) + bonus
end

function life_stealer_infest_custom_legendary:OnAbilityPhaseStart()
self:GetCaster():StartGesture(ACT_DOTA_LIFESTEALER_EJECT)
return true
end

function life_stealer_infest_custom_legendary:OnSpellStart()
local caster = self:GetCaster()
local ability = caster:FindAbilityByName("life_stealer_infest_custom")

local mod = caster:FindModifierByName("modifier_life_stealer_infest_custom_legendary_saved")
if not mod or not mod.name then return end

local creep = CreateUnitByName(mod.name, caster:GetAbsOrigin(), true, caster, caster, caster:GetTeamNumber())
if not creep then return end

caster:RemoveGesture(ACT_DOTA_LIFESTEALER_EJECT)
creep.owner = caster
creep.lifestealer_creep = true
creep.IsRealHero = function() return true end
creep.IsCreep = function() return false end
creep.IsHero = function() return true end
creep:AddNewModifier(caster, self, "modifier_life_stealer_infest_custom_legendary_creep", {})

local vec = caster:GetForwardVector()
vec.z = 0

creep:SetAngles(0, 0, 0)
creep:SetForwardVector(vec)
creep:FaceTowards(creep:GetAbsOrigin() + vec*10)

creep:SetControllableByPlayer(caster:GetPlayerID(), true)
creep:SetOwner(caster)

local effect = ParticleManager:CreateParticle("particles/units/heroes/hero_life_stealer/life_stealer_infest_cast.vpcf", PATTACH_POINT, creep)
ParticleManager:SetParticleControl(effect, 0, caster:GetAbsOrigin())
ParticleManager:SetParticleControlEnt(effect, 1, creep, PATTACH_POINT_FOLLOW, "attach_hitloc", creep:GetAbsOrigin(), true)
ParticleManager:ReleaseParticleIndex(effect)

local effect2 = ParticleManager:CreateParticle("particles/units/heroes/hero_life_stealer/life_stealer_infest_cast.vpcf", PATTACH_POINT, creep)
ParticleManager:SetParticleControl(effect2, 0, creep:GetAbsOrigin())
ParticleManager:SetParticleControlEnt(effect2, 1, creep, PATTACH_POINT_FOLLOW, "attach_hitloc", creep:GetAbsOrigin(), true)
ParticleManager:ReleaseParticleIndex(effect2)

local consume = creep:FindAbilityByName("life_stealer_consume_custom")
if consume then
	consume:SetLevel(1)
	consume:SetHidden(false)
	consume:StartCooldown(1)
end

local abilities = 
{
	"life_stealer_rage_custom",
	"life_stealer_ghoul_frenzy_custom",
	"life_stealer_innate_custom",
}

for _,name in pairs(abilities) do
	local hero_ability = caster:FindAbilityByName(name)
	if hero_ability then
		local creep_ability = creep:AddAbility(name)
		creep_ability:SetLevel(hero_ability:GetLevel())
		creep_ability:SetHidden(true)
		if hero_ability:GetIntrinsicModifierName() then
			local new_mod = creep:AddNewModifier(caster, creep_ability, hero_ability:GetIntrinsicModifierName(), {})
		end
	end
end

local tp_item = CreateItem("item_tpscroll_custom", caster, caster)
creep:AddItem(tp_item)

for i = 0, 2 do
	local creep_ability = creep:GetAbilityByIndex(i)
	if creep_ability then
		creep_ability:SetLevel(self:GetLevel())
	end
end

local shard_ability = creep:FindAbilityByName("life_stealer_unfettered_custom")
if shard_ability and caster:HasShard() then
	shard_ability:SetHidden(false)
	shard_ability:SetLevel(1)
end

CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(caster:GetId()), "select_unit_custom", { index = creep:entindex() })

caster:AddNewModifier(caster, ability, "modifier_life_stealer_infest_custom", {target = creep:entindex(), is_creep = true, is_legendary = true})
creep:StartGesture(ACT_DOTA_CAST_ABILITY_1)
end




modifier_life_stealer_infest_custom_legendary_creep = class(mod_hidden)
function modifier_life_stealer_infest_custom_legendary_creep:RemoveOnDeath() return false end
function modifier_life_stealer_infest_custom_legendary_creep:OnCreated()
self.parent = self:GetParent()
self.ability = self:GetAbility()
self.caster = self:GetCaster()

self.unit_name = self.parent:GetUnitName()

self.health = 1
self.damage = 1
self.mana = 1
self.speed = 1
self.armor = self.ability:GetSpecialValueFor("armor")/100
self.magic = self.ability:GetSpecialValueFor("magic")
self.move = self.ability:GetSpecialValueFor("move")
self.regen = self.ability:GetSpecialValueFor("regen")
self.bva = 1.7

if self.unit_name == "npc_lifestealer_infest_centaur" then
	self.health = self.health + self.ability:GetSpecialValueFor("centaur_health")/100
	self.bva = self.ability:GetSpecialValueFor("centaur_bva")
end

if self.unit_name == "npc_lifestealer_infest_ursa" then
	self.bva = self.ability:GetSpecialValueFor("ursa_bva")
end

self.cd_abilities =
{
	["life_stealer_centaur_stun"] = true,
	["life_stealer_ursa_clap"] = true,
	["life_stealer_dragon_fireball"] = true,
}

if not IsServer() then return end

local dragon_passive = self.parent:FindAbilityByName("life_stealer_dragon_arcane_power")
if dragon_passive then
	self.damage = self.damage*(1 + dragon_passive:GetSpecialValueFor("dragon_damage")/100)
end

self.health_bonus = self.caster:GetTalentValue("modifier_lifestealer_infest_2", "health")/100
self.damage_bonus = self.caster:GetTalentValue("modifier_lifestealer_infest_1", "damage")
self.cd_inc = self.caster:GetTalentValue("modifier_lifestealer_infest_3", "cd_inc")
self.mana_bonus = self.parent:GetTalentValue("modifier_lifestealer_infest_4", "mana")

self.parent:AddNewModifier(self.parent, self.ability, "modifier_life_stealer_infest_custom_legendary_creep_status", {})

self.spell_damage = self.caster:GetSpellAmplification(false)*100

self.creep_health = math.max(1, (self.health + self.health_bonus)*self.caster:GetMaxHealth())
self.creep_damage = self.damage*self.caster:GetAverageTrueAttackDamage(nil)
self.creep_armor = self.armor*self.caster:GetPhysicalArmorValue(false)
self.creep_speed = self.speed*self.caster:GetDisplayAttackSpeed()
self.creep_mana = self.mana*self.caster:GetMaxMana()

self.parent:SetBaseMaxHealth(self.creep_health)
self.parent:SetMaxHealth(self.creep_health)
self.parent:SetHealth(self.creep_health)

self.parent:SetBaseDamageMin(self.creep_damage)
self.parent:SetBaseDamageMax(self.creep_damage)

self.parent:SetPhysicalArmorBaseValue(self.creep_armor)

self.parent:SetBaseMoveSpeed(self.move)
self.parent:SetBaseMagicalResistanceValue(self.magic)

self.caster:AddAttackEvent_out(self, true)
self.parent:AddAttackCreateEvent(self, true)

self.interval = 1
self:StartIntervalThink(0.1)
self:SetHasCustomTransmitterData(true)
end

function modifier_life_stealer_infest_custom_legendary_creep:OnIntervalThink()
if not IsServer() then return end

if not self.init then
	self.parent:SetMana(self.creep_mana)
	self.init = true
end

local should_refresh = false
local damage_bonus = self.caster:GetTalentValue("modifier_lifestealer_infest_1", "damage")
local cd_inc = self.caster:GetTalentValue("modifier_lifestealer_infest_3", "cd_inc")
local mana_bonus = self.caster:GetTalentValue("modifier_lifestealer_infest_4", "mana")

if self.mana_bonus ~= mana_bonus then
	self.mana_bonus = mana_bonus
	should_refresh = true
end

if self.cd_inc ~= cd_inc then
	self.cd_inc = cd_inc
	should_refresh = true
end

if self.damage_bonus ~= damage_bonus then
	self.damage_bonus = damage_bonus
	should_refresh = true
end

self.health_bonus = self.caster:GetTalentValue("modifier_lifestealer_infest_2", "health")/100
self.spell_damage = self.caster:GetSpellAmplification(false)*100

local caster_health =  math.max(1, self.caster:GetMaxHealth()*(self.health + self.health_bonus))
local caster_mana = self.caster:GetMaxMana()*self.mana
local caster_damage = self.damage*self.caster:GetAverageTrueAttackDamage(nil)
local caster_armor = self.caster:GetPhysicalArmorValue(false)*self.armor
local caster_speed = self.caster:GetDisplayAttackSpeed()*self.speed

if caster_speed ~= self.creep_speed then
	self.creep_speed = caster_speed
	should_refresh = true
end

if caster_mana ~= self.creep_mana then
	self.creep_mana = caster_mana
	should_refresh = true
end

if caster_health ~= self.creep_health then
	self.creep_health = caster_health
	self.parent:SetBaseMaxHealth(self.creep_health)
	self.parent:SetMaxHealth(self.creep_health)
end

if caster_armor ~= self.creep_armor then
	self.creep_armor = caster_armor
	self.parent:SetPhysicalArmorBaseValue(self.creep_armor)
end

if caster_damage ~= self.creep_damage then
	self.creep_damage = caster_damage
	self.parent:SetBaseDamageMin(self.creep_damage)
	self.parent:SetBaseDamageMax(self.creep_damage)
end

if should_refresh then
	self:SendBuffRefreshToClients()
end

self:StartIntervalThink(self.interval)
end

function modifier_life_stealer_infest_custom_legendary_creep:AddCustomTransmitterData() 
return 
{
  creep_speed = self.creep_speed,
  creep_mana = self.creep_mana,
  damage_bonus = self.damage_bonus,
  cd_inc = self.cd_inc,
  mana_bonus = self.mana_bonus
} 
end

function modifier_life_stealer_infest_custom_legendary_creep:HandleCustomTransmitterData(data)
self.creep_speed = data.creep_speed
self.creep_mana = data.creep_mana
self.damage_bonus = data.damage_bonus
self.cd_inc = data.cd_inc
self.mana_bonus = data.mana_bonus
end

function modifier_life_stealer_infest_custom_legendary_creep:AttackCreateEvent(params)
if not IsServer() then return end
if self.parent ~= params.attacker then return end
self.parent:EmitSound("Lifestealer."..self.unit_name.."_attack_start")
end


function modifier_life_stealer_infest_custom_legendary_creep:AttackEvent_out(params)
if not IsServer() then return end
if self.parent ~= params.attacker then return end
params.target:EmitSound("Lifestealer."..self.unit_name.."_attack_end")
end

function modifier_life_stealer_infest_custom_legendary_creep:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
	MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
	MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
  	MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
	MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
	MODIFIER_PROPERTY_MANA_BONUS,
  	MODIFIER_PROPERTY_MANACOST_PERCENTAGE_STACKING
}
end

function modifier_life_stealer_infest_custom_legendary_creep:GetModifierPercentageManacostStacking()
return self.mana_bonus
end

function modifier_life_stealer_infest_custom_legendary_creep:GetModifierDamageOutgoing_Percentage()
return self.damage_bonus
end

function modifier_life_stealer_infest_custom_legendary_creep:GetModifierPercentageCooldown(params) 
if not params.ability or not self.cd_abilities[params.ability:GetName()] then return end
return self.cd_inc
end

function modifier_life_stealer_infest_custom_legendary_creep:GetModifierManaBonus()
return self.creep_mana
end

function modifier_life_stealer_infest_custom_legendary_creep:GetModifierConstantManaRegen()
return self.regen*self.parent:GetMaxMana()/100
end

function modifier_life_stealer_infest_custom_legendary_creep:GetModifierHealthRegenPercentage()
return self.regen
end

function modifier_life_stealer_infest_custom_legendary_creep:GetModifierAttackSpeedBonus_Constant()
return self.creep_speed - 100
end

function modifier_life_stealer_infest_custom_legendary_creep:GetModifierSpellAmplify_Percentage() 
return self.spell_damage + self.damage_bonus
end

function modifier_life_stealer_infest_custom_legendary_creep:GetModifierBaseAttackTimeConstant()
return self.bva
end

function modifier_life_stealer_infest_custom_legendary_creep:GetEffectName()
return "particles/units/heroes/hero_bloodseeker/bloodseeker_vision.vpcf"
end




modifier_life_stealer_infest_custom_legendary_creep_status = class(mod_hidden)
function modifier_life_stealer_infest_custom_legendary_creep_status:RemoveOnDeath() return false end
function modifier_life_stealer_infest_custom_legendary_creep_status:GetStatusEffectName()
return "particles/units/heroes/hero_pudge/pudge_fleshheap_status_effect.vpcf"
end

function modifier_life_stealer_infest_custom_legendary_creep_status:StatusEffectPriority()
return MODIFIER_PRIORITY_ILLUSION
end



modifier_life_stealer_infest_custom_legendary_pick_cd = class(mod_hidden)


modifier_life_stealer_infest_custom_legendary_autocast = class(mod_hidden)
function modifier_life_stealer_infest_custom_legendary_autocast:OnCreated()
if not IsServer() then return end
self.parent = self:GetParent()
self.ability = self:GetAbility()

local mod = self.parent:FindModifierByName("modifier_life_stealer_infest_custom_legendary_pick")
if mod then
	mod:Destroy()
else
	self.parent:AddNewModifier(self.parent, self.ability, "modifier_life_stealer_infest_custom_legendary_pick", {})
end

self.parent:AddNewModifier(self.parent, self.ability, "modifier_life_stealer_infest_custom_legendary_pick_cd", {duration = 0.5})

self.ability:ToggleAutoCast()
self:Destroy()
end





modifier_life_stealer_infest_custom_legendary_pick = class(mod_hidden)
function modifier_life_stealer_infest_custom_legendary_pick:OnCreated()
if not IsServer() then return end 

self.parent = self:GetParent()
self.ability = self:GetAbility()

self.targets = {}
table.insert(self.targets, "npc_lifestealer_infest_ursa")
table.insert(self.targets, "npc_lifestealer_infest_centaur")
table.insert(self.targets, "npc_lifestealer_infest_dragon")

self.targets["lifestealer_legendary"] = 1

EmitAnnouncerSoundForPlayer("Lifestealer.Infest_pick", self.parent:GetPlayerOwnerID())

self:OnIntervalThink()
self:StartIntervalThink(0.5)
end 

function modifier_life_stealer_infest_custom_legendary_pick:OnIntervalThink()
if not IsServer() then return end
CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self.parent:GetPlayerOwnerID()), "tb_reflection_init", self.targets)
end 

function modifier_life_stealer_infest_custom_legendary_pick:EndPick(pick)
if not IsServer() then return end
if not self.parent:IsAlive() then return end

if self.targets[pick] then 
	EmitAnnouncerSoundForPlayer("Lc.Duel_target_end", self.parent:GetPlayerOwnerID())
	self.parent:RemoveModifierByName("modifier_life_stealer_infest_custom_legendary_saved")
	self.parent:AddNewModifier(self.parent, self.ability, "modifier_life_stealer_infest_custom_legendary_saved", {name = self.targets[pick]})
end

self:Destroy()
end 

function modifier_life_stealer_infest_custom_legendary_pick:OnDestroy()
if not IsServer() then return end

CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self.parent:GetPlayerOwnerID()), "tb_reflection_init_end",  {})
end 




modifier_life_stealer_infest_custom_legendary_saved = class(mod_visible)
function modifier_life_stealer_infest_custom_legendary_saved:IsHidden() return self.parent:HasModifier("modifier_life_stealer_infest_custom") end
function modifier_life_stealer_infest_custom_legendary_saved:RemoveOnDeath() return false end
function modifier_life_stealer_infest_custom_legendary_saved:GetTexture() return "buffs/lifestealer/"..self.name end
function modifier_life_stealer_infest_custom_legendary_saved:OnCreated(table)
self.parent = self:GetParent()

if not IsServer() then return end 
self.name = table.name

self.parent:AddNewModifier(self.parent, self.ability, "modifier_life_stealer_infest_custom_legendary_pick_cd", {duration = 0.5})
self:SetHasCustomTransmitterData(true)
end

function modifier_life_stealer_infest_custom_legendary_saved:AddCustomTransmitterData() 
return 
{
	name = self.name,
} 
end

function modifier_life_stealer_infest_custom_legendary_saved:HandleCustomTransmitterData(data)
self.name = data.name
end



modifier_life_stealer_infest_custom_legendary_bonus = class(mod_hidden)
function modifier_life_stealer_infest_custom_legendary_bonus:GetTexture() return "buffs/lifestealer/infest_3" end
function modifier_life_stealer_infest_custom_legendary_bonus:OnCreated()
self.parent = self:GetParent()
self.caster = self:GetCaster()

self.bonus = self.caster:GetTalentValue("modifier_lifestealer_infest_3", "bonus")
self.max = self.caster:GetTalentValue("modifier_lifestealer_infest_3", "max")

if not IsServer() then return end
self.RemoveForDuel = true
self:SetStackCount(1)
end

function modifier_life_stealer_infest_custom_legendary_bonus:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end
self:IncrementStackCount()
end

function modifier_life_stealer_infest_custom_legendary_bonus:OnStackCountChanged(iStackCount)
if not IsServer() then return end
if not self.effect_cast then 
	self.effect_cast = self.parent:GenericParticle("particles/bloodseeker/bloodrage_stack_main.vpcf", self, true)
end

local k1 = 0
local k2 = self:GetStackCount()

if k2 >= 10 then 
	k1 = 1
	k2 = self:GetStackCount() - 10
end
ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( k1, k2, 0 ) )
end



modifier_life_stealer_infest_custom_tracker = class(mod_hidden)
function modifier_life_stealer_infest_custom_tracker:OnCreated()
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.mana_bonus = self.parent:GetTalentValue("modifier_lifestealer_infest_4", "mana")
self.cdr = self.parent:GetTalentValue("modifier_lifestealer_infest_4", "cdr")
self.cd_items_creep = self.parent:GetTalentValue("modifier_lifestealer_infest_4", "cd_items_creep", true)
self.cd_items_ursa = self.parent:GetTalentValue("modifier_lifestealer_infest_4", "cd_items_ursa", true)

self.break_duration = self.parent:GetTalentValue("modifier_lifestealer_hero_8", "break_duration", true)
self.break_duration_ursa = self.parent:GetTalentValue("modifier_lifestealer_hero_8", "break_duration_ursa", true)
self.break_mods =
{
	"modifier_life_stealer_ursa_overpower",
	"modifier_life_stealer_centaur_retaliate",
	"modifier_life_stealer_dragon_flight"
}

if not IsServer() then return end
self:UpdateTalent()
self:SetHasCustomTransmitterData(true)
end

function modifier_life_stealer_infest_custom_tracker:UpdateTalent(name)
if not IsServer() then return end

if name == "modifier_lifestealer_hero_8" or self.parent:HasTalent("modifier_lifestealer_hero_8") then
	self.parent:AddAttackEvent_out(self, true)
end

if name == "modifier_lifestealer_infest_4" or self.parent:HasTalent("modifier_lifestealer_infest_4") then
	self.mana_bonus = self.parent:GetTalentValue("modifier_lifestealer_infest_4", "mana")
	self.cdr = self.parent:GetTalentValue("modifier_lifestealer_infest_4", "cdr")
	self.parent:AddAttackEvent_out(self, true)
end

self:SendBuffRefreshToClients()
end

function modifier_life_stealer_infest_custom_tracker:AttackEvent_out(params)
if not IsServer() then return end
if not params.target:IsUnit() then return end

local attacker = params.attacker

if not attacker or not attacker.owner or attacker.owner ~= self.parent then return end
if not attacker:HasModifier("modifier_life_stealer_infest_custom_legendary_creep") then return end

if self.parent:HasTalent("modifier_lifestealer_infest_4") then
	local cd_items = attacker:GetUnitName() == "npc_lifestealer_infest_ursa" and self.cd_items_ursa or self.cd_items_creep
	self.parent:CdItems(cd_items)
end

if not self.parent:HasTalent("modifier_lifestealer_hero_8") then return end
local mod = nil
for _,name in pairs(self.break_mods) do
	local new_mod = attacker:FindModifierByName(name)
	if new_mod and not new_mod.applied_break then
		mod = new_mod
		break
	end
end

if not mod then return end
mod.applied_break = true

local duration = mod:GetName() == "modifier_life_stealer_ursa_overpower" and self.break_duration_ursa or self.break_duration
params.target:EmitSound("DOTA_Item.SilverEdge.Target")
params.target:AddNewModifier(self.parent, mod:GetAbility(), "modifier_life_stealer_infest_custom_break", {duration = (1 - params.target:GetStatusResistance())*duration})
end


function modifier_life_stealer_infest_custom_tracker:AddCustomTransmitterData() 
return 
{
    mana_bonus = self.mana_bonus,
    cdr = self.cdr
} 
end

function modifier_life_stealer_infest_custom_tracker:HandleCustomTransmitterData(data)
self.mana_bonus = data.mana_bonus
self.cdr = data.cdr
end

function modifier_life_stealer_infest_custom_tracker:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
  MODIFIER_PROPERTY_MANACOST_PERCENTAGE_STACKING
}
end

function modifier_life_stealer_infest_custom_tracker:GetModifierPercentageCooldown() 
return self.cdr
end

function modifier_life_stealer_infest_custom_tracker:GetModifierPercentageManacostStacking()
return self.mana_bonus
end




modifier_life_stealer_infest_custom_break = class(mod_hidden)
function modifier_life_stealer_infest_custom_break:OnCreated(table)
self.parent = self:GetParent()
self.caster = self:GetCaster()

if not IsServer() then return end
self.parent:GenericParticle("particles/items3_fx/silver_edge.vpcf", self)
end

function modifier_life_stealer_infest_custom_break:CheckState()
return
{
	[MODIFIER_STATE_PASSIVES_DISABLED] = true
}
end

function modifier_life_stealer_infest_custom_break:GetEffectName() return "particles/generic_gameplay/generic_break.vpcf" end
function modifier_life_stealer_infest_custom_break:ShouldUseOverheadOffset() return true end
function modifier_life_stealer_infest_custom_break:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end



modifier_life_stealer_infest_custom_attack_damage = class(mod_hidden)
function modifier_life_stealer_infest_custom_attack_damage:OnCreated()
self.attacks_damage = self:GetAbility():GetSpecialValueFor("attacks_damage") + self:GetCaster():GetTalentValue("modifier_lifestealer_infest_1", "damage_infest") - 100
end

function modifier_life_stealer_infest_custom_attack_damage:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
}
end


function modifier_life_stealer_infest_custom_attack_damage:GetModifierDamageOutgoing_Percentage()
return self.attacks_damage
end



modifier_life_stealer_infest_custom_health_bonus = class(mod_visible)
function modifier_life_stealer_infest_custom_health_bonus:GetTexture() return "buffs/lifestealer/infest_2" end
function modifier_life_stealer_infest_custom_health_bonus:OnCreated(table)
if not IsServer() then return end
self.RemoveForDuel = true
self.parent = self:GetParent()
self:SetStackCount(table.health)
end

function modifier_life_stealer_infest_custom_health_bonus:OnDestroy()
if not IsServer() then return end
self.parent:CalculateStatBonus(true)
end

function modifier_life_stealer_infest_custom_health_bonus:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_HEALTH_BONUS
}
end

function modifier_life_stealer_infest_custom_health_bonus:GetModifierHealthBonus()
return self:GetStackCount()
end




modifier_life_stealer_infest_custom_heal_reduce = class(mod_visible)
function modifier_life_stealer_infest_custom_heal_reduce:GetTexture() return "buffs/lifestealer/infest_3" end
function modifier_life_stealer_infest_custom_heal_reduce:OnCreated()
self.parent = self:GetParent()
self.caster = self:GetCaster()
self.damage = self.caster:GetTalentValue("modifier_lifestealer_infest_3", "damage")
self.heal_reduce = self.caster:GetTalentValue("modifier_lifestealer_infest_3", "heal_reduce")
if not IsServer() then return end
self.RemoveForDuel = true
self:SetStackCount(1)
end

function modifier_life_stealer_infest_custom_heal_reduce:OnRefresh()
if not IsServer() then return end
self:IncrementStackCount()
end

function modifier_life_stealer_infest_custom_heal_reduce:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
	MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE,
}
end

function modifier_life_stealer_infest_custom_heal_reduce:GetModifierIncomingDamage_Percentage() 
return self.damage*self:GetStackCount()
end

function modifier_life_stealer_infest_custom_heal_reduce:GetModifierLifestealRegenAmplify_Percentage() 
return self.heal_reduce*self:GetStackCount()
end

function modifier_life_stealer_infest_custom_heal_reduce:GetModifierHealAmplify_PercentageTarget()
return self.heal_reduce*self:GetStackCount()
end

function modifier_life_stealer_infest_custom_heal_reduce:GetModifierHPRegenAmplify_Percentage() 
return self.heal_reduce*self:GetStackCount()
end

function modifier_life_stealer_infest_custom_heal_reduce:OnStackCountChanged(iStackCount)
if not IsServer() then return end
if not self.effect_cast then 
	self.effect_cast = self.parent:GenericParticle("particles/bloodseeker/bloodrage_stack_main.vpcf", self, true)
end

local k1 = 0
local k2 = self:GetStackCount()

if k2 >= 10 then 
	k1 = 1
	k2 = self:GetStackCount() - 10
end
ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( k1, k2, 0 ) )
end

