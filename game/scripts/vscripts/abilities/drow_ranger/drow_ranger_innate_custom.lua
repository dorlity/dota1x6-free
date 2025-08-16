LinkLuaModifier( "modifier_drow_ranger_innate_custom", "abilities/drow_ranger/drow_ranger_innate_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_drow_ranger_innate_custom_active", "abilities/drow_ranger/drow_ranger_innate_custom", LUA_MODIFIER_MOTION_NONE )


drow_ranger_innate_custom = class({})

function drow_ranger_innate_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end

PrecacheResource( "soundfile", "soundevents/vo_custom/drow_ranger_vo_custom.vsndevts", context ) 
PrecacheResource( "soundfile", "soundevents/npc_dota_hero_drow_ranger.vsndevts", context )
dota1x6:PrecacheShopItems("npc_dota_hero_drow_ranger", context)
end


function drow_ranger_innate_custom:GetIntrinsicModifierName()
return "modifier_drow_ranger_innate_custom"
end



modifier_drow_ranger_innate_custom = class({})
function modifier_drow_ranger_innate_custom:IsHidden() return true end
function modifier_drow_ranger_innate_custom:IsPurgable() return false end
function modifier_drow_ranger_innate_custom:RemoveOnDeath() return false end
function modifier_drow_ranger_innate_custom:OnCreated(table)
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.radius = self.ability:GetSpecialValueFor("radius")
self.agility = self.ability:GetSpecialValueFor("agility")/100
self.reduce = self.ability:GetSpecialValueFor("reduce")


if not IsServer() then return end

self.effect_mark = ""
self:UpdateParticle()

self:StartIntervalThink(0.1)
end

function modifier_drow_ranger_innate_custom:OnRefresh(table)
if not IsServer() then return end
self.agility = self.ability:GetSpecialValueFor("agility")/100
end


function modifier_drow_ranger_innate_custom:OnIntervalThink()
if not IsServer() then return end

if self.ability:GetLevel() ~= self.level then 
	self.level = self.ability:GetLevel()
	self.parent:RemoveModifierByName("modifier_drow_ranger_innate_custom_active")
end 

local targets = FindUnitsInRadius( self.parent:GetTeamNumber(), self.parent:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST ,false)
local mod = self.parent:FindModifierByName("modifier_drow_ranger_innate_custom_active")
local allow = #targets <= 0 or self.parent:HasModifier("modifier_drow_ranger_marksmanship_custom_shard")
local agi = self.agility

if (self.parent:PassivesDisabled() and not self.parent:HasScepter()) or not self.parent:IsAlive() then
	if mod then
		mod:Destroy()
	end
	agi = 0
else
	if mod and not allow then
		mod:ProcEnd()
	end

	if allow then 
		if mod then
			if mod.ending == true then
				mod.ending = false
				mod:SetDuration(-1, true)
			end
		else
			mod = self.parent:AddNewModifier(self.parent, self.ability, "modifier_drow_ranger_innate_custom_active", {})
		end
	end 

	if not mod then 
		agi = self.agility/self.reduce
	end 
end

self.PercentAgi = agi
end


function modifier_drow_ranger_innate_custom:OnDestroy()
if not IsServer() then return end
self.parent:RemoveModifierByName("modifier_drow_ranger_innate_custom_active")
end

function modifier_drow_ranger_innate_custom:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_HEALTH_BONUS,
}
end

function modifier_drow_ranger_innate_custom:GetModifierHealthBonus()
if not self.parent:HasTalent("modifier_drow_marksman_2") then return end 
return self.parent:GetAgility()*self.parent:GetTalentValue("modifier_drow_marksman_2", "health")
end


function modifier_drow_ranger_innate_custom:UpdateParticle()
if not IsServer() then return end

local particle_mark_start = "particles/units/heroes/hero_drow/drow_marksmanship_start.vpcf"
if self.parent:HasModifier("modifier_drow_ranger_arcana_custom") then
    particle_mark_start = "particles/econ/items/drow/drow_arcana/drow_arcana_marksmanship_crossbow_start.vpcf"
end
if self.parent:HasModifier("modifier_drow_ranger_arcana_custom_v2") then
    particle_mark_start = "particles/econ/items/drow/drow_arcana/drow_arcana_marksmanship_v2_crossbow_start.vpcf"
end

local effect_mark = "particles/units/heroes/hero_drow/drow_marksmanship.vpcf"
if self.parent:HasModifier("modifier_drow_ranger_arcana_custom") then
    effect_mark = "particles/econ/items/drow/drow_arcana/drow_arcana_marksmanship_buff.vpcf"
end
if self.parent:HasModifier("modifier_drow_ranger_arcana_custom_v2") then
    effect_mark = "particles/econ/items/drow/drow_arcana/drow_arcana_marksmanship_buff_v2.vpcf"
end

if (self.effect_mark ~= effect_mark) then 
	self.effect_mark = effect_mark

	if self.particle then
		ParticleManager:DestroyParticle(self.particle, true)
		ParticleManager:ReleaseParticleIndex(self.particle)
		self.particle = nil
	end

	self.particle = ParticleManager:CreateParticle(self.effect_mark, PATTACH_ABSORIGIN_FOLLOW, self.parent)
	self:AddParticle( self.particle, false, false, -1, false, false )
end

if self.parent:HasModifier("modifier_drow_ranger_innate_custom_active") then
	local particle = ParticleManager:CreateParticle(particle_mark_start, PATTACH_ABSORIGIN_FOLLOW, self.parent)
	ParticleManager:ReleaseParticleIndex(particle)
	ParticleManager:SetParticleControl( self.particle, 2, Vector(2,0,0))
else
	ParticleManager:SetParticleControl( self.particle, 2, Vector(1,0,0))
end

end







modifier_drow_ranger_innate_custom_active = class({})
function modifier_drow_ranger_innate_custom_active:IsHidden() return false end
function modifier_drow_ranger_innate_custom_active:IsPurgable() return false end
function modifier_drow_ranger_innate_custom_active:OnCreated()
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.linger_duration = self.parent:GetTalentValue("modifier_drow_marksman_6", "linger", true)

if not IsServer() then return end

self.ending = false
self.mod = self.parent:FindModifierByName("modifier_drow_ranger_innate_custom")

if self.mod and not self.mod:IsNull() then
	self.mod:UpdateParticle()
end

end


function modifier_drow_ranger_innate_custom_active:OnRefresh()
if not IsServer() then return end
self.ending = false
end

function modifier_drow_ranger_innate_custom_active:OnIntervalThink()
if not IsServer() then return end 
self:SetStackCount(0)
self:StartIntervalThink(-1)
end

function modifier_drow_ranger_innate_custom_active:ProcEnd()
if not IsServer() then return end
if self.ending == true then return end

if self.parent:HasTalent("modifier_drow_marksman_6") then
	self.ending = true
	self:SetDuration(self.linger_duration, true)
else
	self:Destroy()
end

end


function modifier_drow_ranger_innate_custom_active:OnDestroy()
if not IsServer() then return end

if self.mod and not self.mod:IsNull() then
	self.mod:UpdateParticle()
end

end



function modifier_drow_ranger_innate_custom_active:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
    MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,

}
end

function modifier_drow_ranger_innate_custom_active:GetModifierStatusResistanceStacking()
if not self.parent:HasTalent("modifier_drow_marksman_3") then return end
return self.parent:GetTalentValue("modifier_drow_marksman_3", "status")
end

function modifier_drow_ranger_innate_custom_active:GetModifierMagicalResistanceBonus()
if not self.parent:HasTalent("modifier_drow_marksman_3") then return end
return self.parent:GetTalentValue("modifier_drow_marksman_3", "magic")
end

