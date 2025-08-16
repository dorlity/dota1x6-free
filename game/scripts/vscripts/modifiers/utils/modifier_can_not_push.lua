


modifier_can_not_push = class({})
function modifier_can_not_push:IsHidden() return false end
function modifier_can_not_push:IsDebuff() return true end
function modifier_can_not_push:IsPurgable() return false end
function modifier_can_not_push:GetTexture() return "backdoor_protection" end

