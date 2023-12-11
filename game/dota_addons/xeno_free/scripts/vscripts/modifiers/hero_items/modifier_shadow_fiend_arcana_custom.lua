modifier_shadow_fiend_arcana_custom = class({})
function modifier_shadow_fiend_arcana_custom:IsHidden() return true end
function modifier_shadow_fiend_arcana_custom:IsPurgable() return false end
function modifier_shadow_fiend_arcana_custom:IsPurgeException() return false end
function modifier_shadow_fiend_arcana_custom:RemoveOnDeath() return false end
function modifier_shadow_fiend_arcana_custom:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
        MODIFIER_PROPERTY_PROJECTILE_NAME,
        MODIFIER_EVENT_ON_DEATH,
    }
end
function modifier_shadow_fiend_arcana_custom:GetActivityTranslationModifiers()
    return "arcana"
end
function modifier_shadow_fiend_arcana_custom:GetModifierProjectileName()
    return "particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_base_attack.vpcf"
end
function modifier_shadow_fiend_arcana_custom:OnDeath(params)
    if not IsServer() then return end
    if params.unit ~= self:GetParent() then return end
    if self:GetParent():IsIllusion() then return end
	local nFXIndex = ParticleManager:CreateParticle("particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_death.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetOrigin(), false )
	ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetOrigin(), false )
	ParticleManager:ReleaseParticleIndex( nFXIndex )
end