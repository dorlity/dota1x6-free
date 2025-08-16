LinkLuaModifier("modifier_patrol_reward_2_portal_speed", "modifiers/patrol_rewards/modifier_patrol_reward_2_portal", LUA_MODIFIER_MOTION_NONE)


modifier_patrol_reward_2_portal = class({})
function modifier_patrol_reward_2_portal:IsHidden() return false end
function modifier_patrol_reward_2_portal:GetTexture() return "buffs/warp_amulet" end
function modifier_patrol_reward_2_portal:RemoveOnDeath() return false end
function modifier_patrol_reward_2_portal:IsPurgable() return false end

function modifier_patrol_reward_2_portal:OnCreated(table)
self.parent = self:GetParent()

if not IsServer() then return end
self.parent:EmitSound("Patrol.Portal_start")

local item = self.parent:FindItemInInventory("item_tpscroll_custom")
if item then
    item:EndCooldown()
end

end

function modifier_patrol_reward_2_portal:OnRefresh(table)
self:OnCreated()
end

modifier_patrol_reward_2_portal_speed = class({})
function modifier_patrol_reward_2_portal_speed:IsHidden() return true end
function modifier_patrol_reward_2_portal_speed:IsPurgable() return false end
function modifier_patrol_reward_2_portal_speed:OnCreated()
self.speed = self:GetParent():GetTalentValue("modifier_patrol_reward_portal", "speed")
end

function modifier_patrol_reward_2_portal_speed:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end

function modifier_patrol_reward_2_portal_speed:GetModifierMoveSpeedBonus_Percentage()
return self.speed
end

function modifier_patrol_reward_2_portal_speed:GetEffectName()
return "particles/units/heroes/hero_marci/marci_rebound_allymovespeed.vpcf"
end
