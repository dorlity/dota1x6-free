modifier_skywrath_mage_arcana_style_1_custom = class({})
function modifier_skywrath_mage_arcana_style_1_custom:IsHidden() return true end
function modifier_skywrath_mage_arcana_style_1_custom:IsPurgable() return false end
function modifier_skywrath_mage_arcana_style_1_custom:IsPurgeException() return false end
function modifier_skywrath_mage_arcana_style_1_custom:RemoveOnDeath() return false end

function modifier_skywrath_mage_arcana_style_1_custom:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_PROJECTILE_NAME,
    }
end

function modifier_skywrath_mage_arcana_style_1_custom:GetModifierProjectileName()
    return "particles/econ/items/skywrath_mage/skywrath_arcana/skywrath_arcana_base_attack.vpcf"
end


function modifier_skywrath_mage_arcana_style_1_custom:OnCreated(table)
self.parent = self:GetParent()
self.parent:AddDeathEvent(self)
end


function modifier_skywrath_mage_arcana_style_1_custom:DeathEvent(params)
    if not IsServer() then return end
    if params.attacker == self:GetParent() and params.unit:IsRealHero() and params.unit ~= self:GetParent() then
        -- Death kill effect
        local caster_effect = ParticleManager:CreateParticle("particles/econ/items/skywrath_mage/skywrath_arcana/skywrath_arcana_kill_caster.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
        ParticleManager:SetParticleControlEnt(caster_effect, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
        ParticleManager:SetParticleControlEnt(caster_effect, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
        ParticleManager:ReleaseParticleIndex(caster_effect)

        local target_effect = ParticleManager:CreateParticle("particles/econ/items/skywrath_mage/skywrath_arcana/skywrath_arcana_kill_target.vpcf", PATTACH_ABSORIGIN_FOLLOW, params.unit)
        ParticleManager:SetParticleControlEnt(target_effect, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
        ParticleManager:SetParticleControl(target_effect, 1, params.unit:GetAbsOrigin())
        ParticleManager:ReleaseParticleIndex(target_effect)
        return
    end
end