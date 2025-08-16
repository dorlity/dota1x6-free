LinkLuaModifier( "modifier_furion_innate_custom", "abilities/furion/furion_innate_custom", LUA_MODIFIER_MOTION_NONE )


furion_innate_custom = class({})


function furion_innate_custom:GetIntrinsicModifierName()
if not self:GetCaster():IsRealHero() then return end 
return "modifier_furion_innate_custom"
end

function furion_innate_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end
PrecacheResource( "soundfile", "soundevents/npc_dota_hero_furion.vsndevts", context )
PrecacheResource( "soundfile", "soundevents/vo_custom/pudge_vo_custom.vsndevts", context ) 
dota1x6:PrecacheShopItems("npc_dota_hero_furion", context)
end

modifier_furion_innate_custom = class({})
function modifier_furion_innate_custom:IsHidden() return false end
function modifier_furion_innate_custom:IsPurgable() return false end
function modifier_furion_innate_custom:RemoveOnDeath() return false end
function modifier_furion_innate_custom:OnCreated(table)
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.radius = self.ability:GetSpecialValueFor("radius")
self.radius_treant = self.ability:GetSpecialValueFor("radius_treant")
self.damage = self.ability:GetSpecialValueFor("damage_per_tree_pct")
self.max = self.ability:GetSpecialValueFor("max")

self.damage_max = self.parent:GetTalentValue("modifier_furion_teleport_1", "max", true)
self.reduce_max = self.parent:GetTalentValue("modifier_furion_call_3", "max", true)

if not IsServer() then return end 
self:StartIntervalThink(0.1)
end

function modifier_furion_innate_custom:OnRefresh(table)
self.damage = self.ability:GetSpecialValueFor("damage_per_tree_pct")
self.radius = self.ability:GetSpecialValueFor("radius")
end


function modifier_furion_innate_custom:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
}
end

function modifier_furion_innate_custom:GetModifierIncomingDamage_Percentage()
if not self.parent:HasTalent("modifier_furion_call_3") then return end 
return self.parent:GetTalentValue("modifier_furion_call_3", "damage_reduce")*math.min(self:GetStackCount(), self.reduce_max)
end

function modifier_furion_innate_custom:GetModifierAttackSpeedBonus_Constant()
if not self.parent:HasTalent("modifier_furion_teleport_1") then return end 
return self.parent:GetTalentValue("modifier_furion_teleport_1", "speed")*math.min(self:GetStackCount(), self.damage_max)
end


function modifier_furion_innate_custom:GetModifierBaseDamageOutgoing_Percentage()
local bonus = 0
if self.parent:HasTalent("modifier_furion_teleport_1") then 
	bonus = self.parent:GetTalentValue("modifier_furion_teleport_1", "damage")
end

return (bonus + self.damage)*self:GetStackCount()
end



function modifier_furion_innate_custom:OnIntervalThink()
if not IsServer() then return end 
local count = 0
count = count + #GridNav:GetAllTreesAroundPoint( self.parent:GetOrigin(), self.radius, false )

self.treants = FindUnitsInRadius( self.parent:GetTeamNumber(), self.parent:GetAbsOrigin(), nil, self.radius_treant, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false )
for _,treant in pairs(self.treants) do
	if treant.is_treant and treant.owner and treant.owner == self.parent then 
		count = count + 1
	end
end 

if self.parent:PassivesDisabled() then
	count = 0
end

self:SetStackCount(math.min(self.max, count))
end


function modifier_furion_innate_custom:HealTreants()
if not self.treants then return end

local heal = self.parent:GetTalentValue("modifier_furion_call_3", "heal")

for _,treant in pairs(self.treants) do
	if treant and not treant:IsNull() and treant.is_treant and treant.owner and treant.owner == self.parent then 
		treant:GenericHeal(heal, self.ability, true, "")
	end
end

end