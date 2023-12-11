modifier_razor_arcana_custom = class({})
function modifier_razor_arcana_custom:IsHidden() return true end
function modifier_razor_arcana_custom:IsPurgable() return false end
function modifier_razor_arcana_custom:IsPurgeException() return false end
function modifier_razor_arcana_custom:RemoveOnDeath() return false end
function modifier_razor_arcana_custom:DeclareFunctions()
    return
    {
        MODIFIER_EVENT_ON_DEATH,
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_PROPERTY_PROJECTILE_NAME,
        MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND
    }
end
function modifier_razor_arcana_custom:OnDestroy()
    if not IsServer() then return end
    self:GetParent():RemoveModifierByName("modifier_razor_arcana")
end
function modifier_razor_arcana_custom:GetModifierProjectileName()
    return "particles/dev/empty_particle.vpcf"
end
function modifier_razor_arcana_custom:OnAttackLanded(params)
    if not IsServer() then return end
    if params.attacker ~= self:GetParent() then return end
    local particle_attack = ParticleManager:CreateParticle("particles/econ/items/razor/razor_arcana/razor_arcana_base_attack_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, params.target)
    ParticleManager:SetParticleControlEnt(particle_attack, 1, params.target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", params.target:GetAbsOrigin(), true)
    ParticleManager:ReleaseParticleIndex(particle_attack)
    local length = params.target:GetAbsOrigin() - self:GetParent():GetAbsOrigin()
    length.z = 0
    length = length:Length2D()
    if length >= 200 then
        local particle_on_hit = ParticleManager:CreateParticle("particles/econ/items/razor/razor_arcana/razor_arcana_base_attack.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
        ParticleManager:SetParticleControlEnt(particle_on_hit, 3, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
        ParticleManager:SetParticleControlEnt(particle_on_hit, 1, params.target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", params.target:GetAbsOrigin(), true)
        ParticleManager:ReleaseParticleIndex(particle_on_hit)
    end
end
function modifier_razor_arcana_custom:OnDeath(params)
    if not IsServer() then return end
    if params.attacker == self:GetParent() and params.unit:IsRealHero() and params.unit ~= self:GetParent() then
        -- Death kill effect
        local caster_effect = ParticleManager:CreateParticle("particles/econ/items/razor/razor_arcana/razor_arcana_kill_effect_caster.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
        ParticleManager:SetParticleControl(caster_effect, 2, self:GetParent():GetAbsOrigin())
        ParticleManager:SetParticleControl(caster_effect, 3, self:GetParent():GetAbsOrigin())
        ParticleManager:SetParticleControlEnt(caster_effect, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
        ParticleManager:ReleaseParticleIndex(caster_effect)

        local target_effect = ParticleManager:CreateParticle("particles/econ/items/razor/razor_arcana/razor_arcana_kill_effect_target.vpcf", PATTACH_ABSORIGIN_FOLLOW, params.unit)
        ParticleManager:SetParticleControl(target_effect, 1, params.unit:GetAbsOrigin())
        ParticleManager:ReleaseParticleIndex(target_effect)
        return
    end
    if params.unit ~= self:GetParent() then return end
    if self:GetParent():IsIllusion() then return end
	local nFXIndex = ParticleManager:CreateParticle("particles/econ/items/razor/razor_arcana/razor_arcana_death.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetOrigin(), false )
	ParticleManager:ReleaseParticleIndex( nFXIndex )
end
function modifier_razor_arcana_custom:GetAttackSound()
    return "Hero_Razor.Attack.Arcana"
end