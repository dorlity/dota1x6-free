modifier_crystal_maiden_arcana_custom = class({})
function modifier_crystal_maiden_arcana_custom:IsHidden() return true end
function modifier_crystal_maiden_arcana_custom:IsPurgable() return false end
function modifier_crystal_maiden_arcana_custom:IsPurgeException() return false end
function modifier_crystal_maiden_arcana_custom:RemoveOnDeath() return false end
function modifier_crystal_maiden_arcana_custom:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS, 
    }
end

function modifier_crystal_maiden_arcana_custom:GetActivityTranslationModifiers()
    return "arcana"
end


function modifier_crystal_maiden_arcana_custom:OnCreated(table)
self:GetParent():AddDeathEvent(self)
end

function modifier_crystal_maiden_arcana_custom:DeathEvent(params)
    if not IsServer() then return end
    if params.unit ~= self:GetParent() then return end
    local particle = ParticleManager:CreateParticle("particles/econ/items/crystal_maiden/crystal_maiden_maiden_of_icewrack/maiden_death_arcana.vpcf", PATTACH_WORLDORIGIN, nil)
    ParticleManager:SetParticleControl(particle, 0, self:GetParent():GetAbsOrigin())
    ParticleManager:ReleaseParticleIndex(particle)
end