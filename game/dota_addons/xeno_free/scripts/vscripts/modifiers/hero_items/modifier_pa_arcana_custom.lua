modifier_pa_arcana_custom = class({})
function modifier_pa_arcana_custom:IsHidden() return true end
function modifier_pa_arcana_custom:IsPurgable() return false end
function modifier_pa_arcana_custom:IsPurgeException() return false end
function modifier_pa_arcana_custom:RemoveOnDeath() return false end
function modifier_pa_arcana_custom:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
        MODIFIER_EVENT_ON_DEATH,
    }
end

function modifier_pa_arcana_custom:GetActivityTranslationModifiers()
    return "arcana"
end

function modifier_pa_arcana_custom:OnDeath(params)
    if not IsServer() then return end
    if params.unit ~= self:GetParent() then return end
    local particle = ParticleManager:CreateParticle("particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/pa_arcana_death.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
    ParticleManager:ReleaseParticleIndex(particle)
end