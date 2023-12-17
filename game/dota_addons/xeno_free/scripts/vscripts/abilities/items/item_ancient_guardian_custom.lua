LinkLuaModifier("modifier_item_ancient_guardian_custom", "abilities/items/item_ancient_guardian_custom", LUA_MODIFIER_MOTION_NONE)

item_ancient_guardian_custom = class({})

function item_ancient_guardian_custom:GetIntrinsicModifierName()
	return "modifier_item_ancient_guardian_custom"
end


modifier_item_ancient_guardian_custom = class({})

function modifier_item_ancient_guardian_custom:IsHidden() return true end
function modifier_item_ancient_guardian_custom:IsPurgable() return false end
function modifier_item_ancient_guardian_custom:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_item_ancient_guardian_custom:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE

    }

    return funcs
end


function modifier_item_ancient_guardian_custom:GetModifierPreAttack_BonusDamage()

return self.damage + self.extra*self:GetStackCount()
end

function modifier_item_ancient_guardian_custom:OnCreated(table)

self.damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
self.extra = self:GetAbility():GetSpecialValueFor("extra_bonus_damage")
self.radius = self:GetAbility():GetSpecialValueFor("radius")

self:SetStackCount(0)

if not IsServer() then return end 

self.parent = self:GetParent()
self:StartIntervalThink(0.2)
end 


function modifier_item_ancient_guardian_custom:OnIntervalThink()
if not IsServer() then return end 

local targets = FindUnitsInRadius( self.parent:GetTeamNumber(), self.parent:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST,false)

local count = 0

for _,target in pairs(targets) do 
    if target:GetUnitName() == "npc_towerdire" or target:GetUnitName() == "npc_towerradiant" then 
        count = 1
        break
    end 
end 

self:SetStackCount(count)
end 