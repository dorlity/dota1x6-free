LinkLuaModifier( "modifier_axe_battle_hunger_custom_buff", "abilities/axe/axe_battle_hunger_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_battle_hunger_custom_debuff", "abilities/axe/axe_battle_hunger_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_battle_hunger_custom_armor_buff", "abilities/axe/axe_battle_hunger_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_battle_hunger_custom_tracker", "abilities/axe/axe_battle_hunger_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_battle_hunger_custom_unslow", "abilities/axe/axe_battle_hunger_custom", LUA_MODIFIER_MOTION_NONE )

axe_battle_hunger_custom = class({})

axe_battle_hunger_custom.active_mod = nil

function axe_battle_hunger_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end
PrecacheResource( "particle", "particles/units/heroes/hero_doom_bringer/doom_infernal_blade_impact.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_axe/axe_battle_hunger.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_bloodseeker/bloodseeker_thirst_owner.vpcf", context )
PrecacheResource( "particle", "particles/axe/hunger_legendary_radius.vpcf", context )
end

function axe_battle_hunger_custom:GetIntrinsicModifierName()
if not self:GetCaster():IsRealHero() then return end
return "modifier_axe_battle_hunger_custom_tracker"
end

function axe_battle_hunger_custom:GetAbilityTextureName()
if self:GetCaster():HasModifier("modifier_axe_mantle_baron_custom") then
    return "axe/mantle_of_the_cinder_baron/axe_battle_hunger"
end
return "axe_battle_hunger"
end

function axe_battle_hunger_custom:GetAOERadius()
return self:GetSpecialValueFor("aoe_radius")
end

function axe_battle_hunger_custom:OnSpellStart()
local target = self:GetCursorTarget()
local caster = self:GetCaster()

if target:TriggerSpellAbsorb( self ) then return end

local duration = caster:HasTalent("modifier_axe_hunger_legendary") and caster:GetTalentValue("modifier_axe_hunger_legendary", "duration") or (self:GetSpecialValueFor("duration") + 0.1)

self.active_mod = target:AddNewModifier( caster, self, "modifier_axe_battle_hunger_custom_debuff", { duration = duration })
target:EmitSound("Hero_Axe.Battle_Hunger")
end


modifier_axe_battle_hunger_custom_debuff = class({})
function modifier_axe_battle_hunger_custom_debuff:IsPurgable() return not self.has_legendary end
function modifier_axe_battle_hunger_custom_debuff:OnCreated( kv )

self.parent = self:GetParent()
self.parent:AddDeathEvent(self, true)

self.caster = self:GetCaster()
self.ability = self:GetAbility()

self.slow = self.ability:GetSpecialValueFor( "slow" ) + self.caster:GetTalentValue("modifier_axe_hero_2", "slow")
self.damage = self.ability:GetSpecialValueFor( "damage_per_second" )
self.aoe_radius = self.ability:GetSpecialValueFor("aoe_radius")
self.armor_k = self.ability:GetSpecialValueFor("armor_multiplier") + self.caster:GetTalentValue("modifier_axe_hunger_1", "damage")

self.has_legendary = self.caster:HasTalent("modifier_axe_hunger_legendary")
if self.has_legendary then
	self.legendary_multi = self.caster:GetTalentValue("modifier_axe_hunger_legendary", "multi")
	self.legendary_timer = self.caster:GetTalentValue("modifier_axe_hunger_legendary", "timer")
	self.legendary_max = self.caster:GetTalentValue("modifier_axe_hunger_legendary", "max")
	self.legendary_duration = self.caster:GetTalentValue("modifier_axe_hunger_legendary", "duration")
	self.legendary_radius = self.caster:GetTalentValue("modifier_axe_hunger_legendary", "radius")
end

self.stone_angle = 85

self.has_unslow = self.caster:HasTalent("modifier_axe_hunger_4")
self.unslow_radius = self.caster:GetTalentValue("modifier_axe_hunger_4", "radius")

self.has_armor = self.caster:HasTalent("modifier_axe_hunger_3")
self.armor_duration = self.caster:GetTalentValue("modifier_axe_hunger_3", "duration")

self.has_silence = self.caster:HasTalent("modifier_axe_hero_6")
self.spell_reduce = self.caster:GetTalentValue("modifier_axe_hero_6", "spell_reduce")
self.silence_duration = self.caster:GetTalentValue("modifier_axe_hero_6", "silence")
self.silence_timer = self.caster:GetTalentValue("modifier_axe_hero_6", "timer")
self.silence_count = self.silence_timer

if not IsServer() then return end
self.RemoveForDuel = true
self.caster:AddNewModifier(self.caster, self.ability, "modifier_axe_battle_hunger_custom_buff", {})

self.ability:EndCd()
self.damageTable = {attacker = self.caster, damage_type = DAMAGE_TYPE_PHYSICAL, ability = self.ability, damage_flags = DOTA_DAMAGE_FLAG_BYPASSES_PHYSICAL_BLOCK, }

self.legendary_count = -1
self.legendary_damage = 0
self.legendary_stack = 0

local particle = self.caster:HasModifier("modifier_axe_mantle_baron_custom") and "particles/econ/items/axe/axe_cinder/axe_cinder_battle_hunger.vpcf" or "particles/units/heroes/hero_axe/axe_battle_hunger.vpcf"
self.parent:GenericParticle(particle, self, true)

self.interval = 0.2
self.interval_count = 1

self:StartIntervalThink( self.interval )
self:OnIntervalThink()
end

function modifier_axe_battle_hunger_custom_debuff:OnDestroy()
if not IsServer() then return end 

if self.has_legendary then
	self.caster:UpdateUIshort({hide = 1, hide_full = 1, style = "AxeHunger"})
end

self.caster:RemoveModifierByName("modifier_axe_battle_hunger_custom_buff")
self.ability:StartCd()
self.ability.active_mod = nil
end

function modifier_axe_battle_hunger_custom_debuff:DeclareFunctions()
return 
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE
}
end

function modifier_axe_battle_hunger_custom_debuff:GetModifierSpellAmplify_Percentage() 
return self.spell_reduce
end

function modifier_axe_battle_hunger_custom_debuff:DeathEvent( params )
if not IsServer() then return end
if self.has_legendary then return end
if params.attacker ~= self.parent then return end
self:Destroy()
end

function modifier_axe_battle_hunger_custom_debuff:GetModifierMoveSpeedBonus_Percentage()
if self:GetStackCount() == 0 then return end
return self.slow
end

function modifier_axe_battle_hunger_custom_debuff:OnIntervalThink()
if not IsServer() then return end

if self.caster:GetQuest() == "Axe.Quest_6" and self.parent:IsRealHero() and not self.caster:QuestCompleted() then 
	self.caster:UpdateQuest(self.interval)
end

if self.caster:IsAlive() then
	local dist = (self.caster:GetAbsOrigin() - self.parent:GetAbsOrigin()):Length2D()
	if self.has_legendary and dist <= self.legendary_radius then
		self:SetDuration(self.legendary_duration, true)
	end

	if self.has_unslow and dist <= self.unslow_radius then
		self.caster:AddNewModifier(self.caster, self.ability, "modifier_axe_battle_hunger_custom_unslow", {duration = self.interval + 0.1})
	end
end

if self.has_legendary then
	self.caster:UpdateUIshort({max_time = self.legendary_duration, time = self:GetRemainingTime(), stack = self.legendary_stack, style = "AxeHunger"})
end

local vector = (self.caster:GetAbsOrigin()-self.parent:GetAbsOrigin()):Normalized()
local center_angle = VectorToAngles( vector ).y
local facing_angle = VectorToAngles( self.parent:GetForwardVector() ).y

local facing = ( math.abs( AngleDiff(center_angle,facing_angle) ) > self.stone_angle ) and 1 or 0
self:SetStackCount(facing)

self.interval_count = self.interval_count + self.interval
if self.interval_count <= 1 - FrameTime() then return end

self.interval_count = 0

if self.has_silence then
	self.silence_count = self.silence_count + 1
	if self.silence_count >= self.silence_timer then 
		self.silence_count = 0
		self.parent:EmitSound("Sf.Raze_Silence")
		self.parent:AddNewModifier(self.caster, self.ability, "modifier_generic_silence", {duration = (1 - self.parent:GetStatusResistance())*self.silence_duration})
	end
end

if self.has_legendary then 
	self.legendary_count = self.legendary_count + 1

	if self.legendary_count >= self.legendary_timer and self.legendary_stack < self.legendary_max then

		self.parent:GenericParticle("particles/units/heroes/hero_doom_bringer/doom_infernal_blade_impact.vpcf")
		self.parent:EmitSound("Axe.Hunger_damage")

		self.legendary_count = 0
		self.legendary_stack = self.legendary_stack + 1
		self.parent:SendNumber(6, self.legendary_stack)
	end
end

if self.has_armor then 
	self.caster:AddNewModifier(self.caster, self.ability, "modifier_axe_battle_hunger_custom_armor_buff", {duration = self.armor_duration})
	self.parent:AddNewModifier(self.caster, self.ability, "modifier_axe_battle_hunger_custom_armor_buff", {duration = self.armor_duration})
end

self.damageTable.damage = self.damage + (self.armor_k + self.legendary_stack)*self.caster:GetPhysicalArmorValue(false)
for _,target in pairs(self.caster:FindTargets(self.aoe_radius, self.parent:GetAbsOrigin())) do
	self.damageTable.victim = target
	DoDamage( self.damageTable )
end

end





modifier_axe_battle_hunger_custom_buff = class(mod_hidden)
function modifier_axe_battle_hunger_custom_buff:RemoveOnDeath() return false end
function modifier_axe_battle_hunger_custom_buff:OnCreated()
self.parent = self:GetParent()
self.legendary_radius = self.parent:GetTalentValue("modifier_axe_hunger_legendary", "radius")

if not IsServer() then return end

if self.parent:HasTalent("modifier_axe_hero_2") then
	self.parent:GenericParticle("particles/units/heroes/hero_bloodseeker/bloodseeker_thirst_owner.vpcf", self)
end

if self.parent:HasTalent("modifier_axe_hunger_legendary") then
	self.radius_visual = ParticleManager:CreateParticleForPlayer("particles/axe/hunger_legendary_radius.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent, self.parent:GetPlayerOwner())
	ParticleManager:SetParticleControl(self.radius_visual, 0, self.parent:GetAbsOrigin())
	ParticleManager:SetParticleControl(self.radius_visual, 1, Vector(self.legendary_radius, 0, 0))
	self:AddParticle(self.radius_visual, false, false, -1, false, false)
end

end 



modifier_axe_battle_hunger_custom_armor_buff = class(mod_visible)
function modifier_axe_battle_hunger_custom_armor_buff:GetTexture() return "buffs/axe/hunger_3" end
function modifier_axe_battle_hunger_custom_armor_buff:DeclareFunctions()
return
{ 
	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS 
}
end

function modifier_axe_battle_hunger_custom_armor_buff:OnCreated(table)
self.parent = self:GetParent()
self.caster = self:GetCaster()
self.max = self.caster:GetTalentValue("modifier_axe_hunger_3", "max")
self.armor = self.caster:GetTalentValue("modifier_axe_hunger_3", "armor")/self.max

self.armor = self.caster:GetTeamNumber() == self.parent:GetTeamNumber() and self.armor*-1 or self.armor
if not IsServer() then return end
self:SetStackCount(1) 
self.RemoveForDuel = true 
end

function modifier_axe_battle_hunger_custom_armor_buff:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end
self:IncrementStackCount()

if self:GetStackCount() >= self.max and self.parent:GetTeamNumber() ~= self.caster:GetTeamNumber() then
	self.parent:GenericParticle("particles/general/generic_armor_reduction.vpcf", self, true)
	self.parent:EmitSound("Hoodwink.Acorn_armor")
end

end

function modifier_axe_battle_hunger_custom_armor_buff:GetModifierPhysicalArmorBonus()
return self.armor *self:GetStackCount()
end




modifier_axe_battle_hunger_custom_tracker = class(mod_hidden)
function modifier_axe_battle_hunger_custom_tracker:OnCreated(table)
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.move_speed = self.parent:GetTalentValue("modifier_axe_hero_2", "move")
self.move_bonus = self.parent:GetTalentValue("modifier_axe_hero_2", "bonus", true)

self.has_heal = self.parent:HasTalent("modifier_axe_hunger_2")
self.heal = self.parent:GetTalentValue("modifier_axe_hunger_2", "heal")/100
self.heal_creeps = self.parent:GetTalentValue("modifier_axe_hunger_2", "creeps", true)

self.cast_range = self.parent:GetTalentValue("modifier_axe_hunger_4", "range")

if not IsServer() then return end
self:StartIntervalThink(3)
self:SetHasCustomTransmitterData(true)
self:UpdateTalent()
end 

function modifier_axe_battle_hunger_custom_tracker:OnIntervalThink()
if not IsServer() then return end

if not IsValid(self.ability.active_mod) then
	if not self.ability:IsActivated() then 
		self.ability:StartCd()
	end
	self.parent:RemoveModifierByName("modifier_axe_battle_hunger_custom_buff")
end

end

function modifier_axe_battle_hunger_custom_tracker:UpdateTalent(name)
if not IsServer() then return end

if name == "modifier_axe_hero_2" or self.parent:HasTalent("modifier_axe_hero_2") then
	self.move_speed = self.parent:GetTalentValue("modifier_axe_hero_2", "move")
end

if name == "modifier_axe_hunger_4" or self.parent:HasTalent("modifier_axe_hunger_4") then
	self.cast_range = self.parent:GetTalentValue("modifier_axe_hunger_4", "range")
end

if name == "modifier_axe_hunger_2" or self.parent:HasTalent("modifier_axe_hunger_2") then
	self.has_heal = true
	self.heal = self.parent:GetTalentValue("modifier_axe_hunger_2", "heal")/100
	self.parent:AddDamageEvent_out(self, true)
end

self:SendBuffRefreshToClients()
end

function modifier_axe_battle_hunger_custom_tracker:DamageEvent_out(params)
if not IsServer() then return end
if not self.has_heal then return end
if not params.unit:HasModifier("modifier_axe_battle_hunger_custom_debuff") then return end
if not self.parent:CheckLifesteal(params) then return end

local heal = params.damage*self.heal
heal = params.unit:IsCreep() and heal/self.heal_creeps or heal

self.parent:GenericHeal(heal, self.ability, true, "particles/items3_fx/octarine_core_lifesteal.vpcf", "modifier_axe_hunger_2")
end

function modifier_axe_battle_hunger_custom_tracker:AddCustomTransmitterData() 
return 
{
  move_speed = self.move_speed,
  cast_range = self.cast_range,
} 
end

function modifier_axe_battle_hunger_custom_tracker:HandleCustomTransmitterData(data)
self.move_speed = data.move_speed
self.cast_range = data.cast_range
end

function modifier_axe_battle_hunger_custom_tracker:DeclareFunctions()
return 
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
  	MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING,
}
end

function modifier_axe_battle_hunger_custom_tracker:GetModifierCastRangeBonusStacking()
return self.cast_range
end

function modifier_axe_battle_hunger_custom_tracker:GetModifierMoveSpeedBonus_Constant()
return self.parent:HasModifier("modifier_axe_battle_hunger_custom_buff") and self.move_speed*self.move_bonus or self.move_speed
end




modifier_axe_battle_hunger_custom_unslow = class(mod_hidden)
function modifier_axe_battle_hunger_custom_unslow:OnCreated()
self.parent = self:GetParent()
self.cd_items = self.parent:GetTalentValue("modifier_axe_hunger_4", "cd_items")/100
self.interval = 1

if not IsServer() then return end

if not self.parent:HasTalent("modifier_axe_hero_2") then
	self.parent:GenericParticle("particles/units/heroes/hero_bloodseeker/bloodseeker_thirst_owner.vpcf", self)
end

self:StartIntervalThink(self.interval)
end

function modifier_axe_battle_hunger_custom_unslow:OnIntervalThink()
if not IsServer() then return end
self.parent:CdItems(self.cd_items*self.interval)
end

function modifier_axe_battle_hunger_custom_unslow:CheckState()
return
{
	[MODIFIER_STATE_UNSLOWABLE] = true
}
end