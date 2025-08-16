modifier_troll_warlord_ti7_immortal_weapon_custom = class({})
function modifier_troll_warlord_ti7_immortal_weapon_custom:IsHidden() return true end
function modifier_troll_warlord_ti7_immortal_weapon_custom:IsPurgable() return false end
function modifier_troll_warlord_ti7_immortal_weapon_custom:IsPurgeException() return false end
function modifier_troll_warlord_ti7_immortal_weapon_custom:RemoveOnDeath() return false end
function modifier_troll_warlord_ti7_immortal_weapon_custom:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
    }
end
function modifier_troll_warlord_ti7_immortal_weapon_custom:GetActivityTranslationModifiers()
    return "ti7"
end
function modifier_troll_warlord_ti7_immortal_weapon_custom:OnCreated()
    if not IsServer() then return end
    self.original = self:GetParent():GetRangedProjectileName()
    self:GetParent():SetRangedProjectileName("particles/units/heroes/hero_troll_warlord/troll_warlord_base_attack_immortal.vpcf")
end
function modifier_troll_warlord_ti7_immortal_weapon_custom:OnDestroy()
    if not IsServer() then return end
    self:GetParent():SetRangedProjectileName(self.original)
end