modifier_zuus_arcana_custom = class({})
function modifier_zuus_arcana_custom:IsHidden() return true end
function modifier_zuus_arcana_custom:IsPurgable() return false end
function modifier_zuus_arcana_custom:IsPurgeException() return false end
function modifier_zuus_arcana_custom:RemoveOnDeath() return false end
function modifier_zuus_arcana_custom:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
    }
end
function modifier_zuus_arcana_custom:GetActivityTranslationModifiers()
    return "arcana"
end

function modifier_zuus_arcana_custom:OnCreated(table)
self.parent = self:GetParent()
self.parent:AddDeathEvent(self)
end




function modifier_zuus_arcana_custom:DeathEvent(params)
    if not IsServer() then return end
    if params.attacker == self:GetParent() and params.unit:IsRealHero() and params.unit ~= self:GetParent() then
        local target_effect = ParticleManager:CreateParticle("particles/econ/items/zeus/arcana_chariot/zeus_arcana_kill_remnant.vpcf", PATTACH_ABSORIGIN_FOLLOW, params.unit)
        ParticleManager:SetParticleControl(target_effect, 1, params.unit:GetAbsOrigin())
        ParticleManager:ReleaseParticleIndex(target_effect)
        return
    end
end