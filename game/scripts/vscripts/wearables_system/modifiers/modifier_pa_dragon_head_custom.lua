modifier_pa_dragon_head_custom = class({})
function modifier_pa_dragon_head_custom:IsHidden() return true end
function modifier_pa_dragon_head_custom:IsPurgable() return false end
function modifier_pa_dragon_head_custom:IsPurgeException() return false end
function modifier_pa_dragon_head_custom:RemoveOnDeath() return false end

function modifier_pa_dragon_head_custom:OnCreated()
    if not IsServer() then return end
    self.parent = self:GetParent()
    self:HasHeadAltStyle(false)
end

function modifier_pa_dragon_head_custom:OnDestroy()
    if not IsServer() then return end
    self.parent = self:GetParent()
    self:HasHeadAltStyle(true, true)
end

function modifier_pa_dragon_head_custom:HasHeadAltStyle(active, head)
    if not IsServer() then return end
    local modifier_pa_arcana_custom = self.parent:FindModifierByName("modifier_pa_arcana_custom")
    if modifier_pa_arcana_custom then
        modifier_pa_arcana_custom:HasHeadAltStyle(active, head)
    end
    local modifier_pa_dragon_back_custom = self.parent:FindModifierByName("modifier_pa_dragon_back_custom")
    if modifier_pa_dragon_back_custom then
        modifier_pa_dragon_back_custom:HasHeadAltStyle(self.parent:HasModifier("modifier_pa_arcana_custom"))
    end
end