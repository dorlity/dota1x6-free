modifier_axe_persona_custom = class({})
function modifier_axe_persona_custom:IsHidden() return true end
function modifier_axe_persona_custom:IsPurgable() return false end
function modifier_axe_persona_custom:IsPurgeException() return false end
function modifier_axe_persona_custom:RemoveOnDeath() return false end
function modifier_axe_persona_custom:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
        MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND,
    }
end
function modifier_axe_persona_custom:GetActivityTranslationModifiers()
    return "ti9"
end
function modifier_axe_persona_custom:GetAttackSound()
    return "Hero_Axe.Attack.Jungle"
end
function modifier_axe_persona_custom:OnCreated()
    if not IsServer() then return end
    self.original_size = self:GetParent():GetModelScale()
    self:GetParent():SetModelScale(1.15)
end
function modifier_axe_persona_custom:OnDestroy()
    if not IsServer() then return end
    self:GetParent():SetModelScale(self.original_size)
end