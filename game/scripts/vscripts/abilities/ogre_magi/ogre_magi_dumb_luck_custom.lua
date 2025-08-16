LinkLuaModifier( "modifier_ogre_magi_dumb_luck_custom", "abilities/ogre_magi/ogre_magi_dumb_luck_custom", LUA_MODIFIER_MOTION_NONE )

ogre_magi_dumb_luck_custom = class({})

function ogre_magi_dumb_luck_custom:GetIntrinsicModifierName()
return "modifier_ogre_magi_dumb_luck_custom"
end

function ogre_magi_dumb_luck_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end
PrecacheResource( "soundfile", "soundevents/npc_dota_hero_ogre_magi.vsndevts", context )
PrecacheResource( "soundfile", "soundevents/vo_custom/ogre_magi_vo_custom.vsndevts", context ) 
end



function ogre_magi_dumb_luck_custom:OnInventoryContentsChanged()
local mod = self:GetCaster():FindModifierByName("modifier_ogre_magi_dumb_luck_custom")
if mod then 
	mod:OnIntervalThink()
end
end


modifier_ogre_magi_dumb_luck_custom = class({})
function modifier_ogre_magi_dumb_luck_custom:IsHidden() return false end
function modifier_ogre_magi_dumb_luck_custom:IsPurgable() return false end
function modifier_ogre_magi_dumb_luck_custom:RemoveOnDeath() return false end





function modifier_ogre_magi_dumb_luck_custom:OnCreated(table)
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.mana = self.ability:GetSpecialValueFor("mana_per_str")
self.mana_regen = self.ability:GetSpecialValueFor("mana_regen_per_str")
self.str_chance = self.ability:GetSpecialValueFor("str_chance")

self.main_ability = self.parent:FindAbilityByName("ogre_magi_multicast_custom")

self.max = self.parent:GetTalentValue("modifier_ogremagi_multi_5", "max", true)
self.chance_inc = self.parent:GetTalentValue("modifier_ogremagi_multi_5", "chance", true)
self.cdr = self.parent:GetTalentValue("modifier_ogremagi_multi_5", "cdr", true)

self.int = 0
self.str = 0
if not IsServer() then return end

self.init = false
self:StartIntervalThink(1)
end

function modifier_ogre_magi_dumb_luck_custom:OnIntervalThink()
if not IsServer() then return end 

self.int = 0
self.str = 0

if self.parent:HasTalent("modifier_ogremagi_multi_5") and self:GetStackCount() >= self.max and self.init == false then 
	self.init = true

	self:GetParent():EmitSound("BS.Thirst_legendary_active")
	local particle_peffect = ParticleManager:CreateParticle("particles/lc_odd_proc_.vpcf", PATTACH_ABSORIGIN_FOLLOW,self.parent)
	ParticleManager:SetParticleControl(particle_peffect, 0, self.parent:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_peffect, 2, self.parent:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(particle_peffect)
end

if self.parent:HasTalent("modifier_ogremagi_multi_3") then 

	local int_k = 0
	for _,mod in pairs(self.parent:FindAllModifiers()) do 
		if mod.PercentInt ~= nil then 
			int_k = int_k + mod.PercentInt
		end
	end 

	local str_k = self.parent:GetTalentValue("modifier_ogremagi_multi_3",  "str")
	self.str = (self.parent:GetIntellect(false)*(1 + int_k))/str_k
end

self.int = self.parent:GetIntellect(false)*-1

self.parent:CalculateStatBonus(true)
end



function modifier_ogre_magi_dumb_luck_custom:AddStack()
if not IsServer() then return end 
if self:GetStackCount() >= self.max then return end 

self:IncrementStackCount()
end



function modifier_ogre_magi_dumb_luck_custom:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOOLTIP,
	MODIFIER_PROPERTY_TOOLTIP2,
	MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	MODIFIER_PROPERTY_MANA_BONUS,
	MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
	MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
}
end

function modifier_ogre_magi_dumb_luck_custom:GetModifierPercentageCooldown()
if not self.parent:HasTalent("modifier_ogremagi_multi_5") then return end
return self.cdr
end


function modifier_ogre_magi_dumb_luck_custom:GetModifierManaBonus()
local bonus = 0
if self.parent:HasTalent("modifier_ogremagi_multi_3") then 
	bonus = self.parent:GetTalentValue("modifier_ogremagi_multi_3", "mana")
end
return self.parent:GetStrength()*(self.mana + bonus)
end


function modifier_ogre_magi_dumb_luck_custom:GetModifierConstantManaRegen()
return self.parent:GetStrength()*self.mana_regen
end
function modifier_ogre_magi_dumb_luck_custom:GetModifierBonusStats_Intellect()
return self.int
end
function modifier_ogre_magi_dumb_luck_custom:GetModifierBonusStats_Strength()
return self.str
end

function modifier_ogre_magi_dumb_luck_custom:OnTooltip()
if not self.main_ability then return end 
return self.main_ability:GetChance("multicast_2_times")
end

function modifier_ogre_magi_dumb_luck_custom:OnTooltip2()
if not self.main_ability then return end 
return self.main_ability:GetChance("multicast_3_times")
end

function modifier_ogre_magi_dumb_luck_custom:GetModifierTotalDamageOutgoing_Percentage()
if IsServer() then return end
if not self.main_ability then return end 
return self.main_ability:GetChance("multicast_4_times")
end

function modifier_ogre_magi_dumb_luck_custom:GetModifierIncomingDamage_Percentage()
if IsServer() then return end
return self:GetStackCount()
end


