LinkLuaModifier("modifier_donate_hero_illusion_item", "wearables_system/modifiers/modifier_hero_donate_illusion", LUA_MODIFIER_MOTION_NONE)

modifier_huskar_2021_weapon_custom = class({})
function modifier_huskar_2021_weapon_custom:IsHidden() return true end
function modifier_huskar_2021_weapon_custom:IsPurgable() return false end
function modifier_huskar_2021_weapon_custom:IsPurgeException() return false end
function modifier_huskar_2021_weapon_custom:RemoveOnDeath() return false end
function modifier_huskar_2021_weapon_custom:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
    }
end
function modifier_huskar_2021_weapon_custom:GetActivityTranslationModifiers()
    return "2021_huskar"
end
function modifier_huskar_2021_weapon_custom:OnCreated()
    if not IsServer() then return end
    self.hand = wearables_system:CreateWearable(self:GetParent(), "models/items/huskar/husk_2021_immortal/husk_2021_immortal_arm_model.vmdl")
    ParticleManager:CreateParticle("particles/econ/items/huskar/huskar_2021_immortal/huskar_2021_immortal_arm.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.hand)
end
function modifier_huskar_2021_weapon_custom:OnDestroy()
    if not IsServer() then return end
    if self.hand then
        self.hand:AddEffects(EF_NODRAW)
        self.hand:Destroy()
    end
end