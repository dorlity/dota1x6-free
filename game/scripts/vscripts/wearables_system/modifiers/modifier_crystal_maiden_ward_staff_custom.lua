modifier_crystal_maiden_ward_staff_custom = class({})
function modifier_crystal_maiden_ward_staff_custom:IsHidden() return true end
function modifier_crystal_maiden_ward_staff_custom:IsPurgable() return false end
function modifier_crystal_maiden_ward_staff_custom:IsPurgeException() return false end
function modifier_crystal_maiden_ward_staff_custom:RemoveOnDeath() return false end
function modifier_crystal_maiden_ward_staff_custom:DecalreFunctions()
    return
    {
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
    }
end

function modifier_crystal_maiden_ward_staff_custom:GetActivityTranslationModifiers()
    return "wardstaff"
end