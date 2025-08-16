modifier_drow_ranger_arcana_custom_v2 = class({})
function modifier_drow_ranger_arcana_custom_v2:IsHidden() return true end
function modifier_drow_ranger_arcana_custom_v2:IsPurgable() return false end
function modifier_drow_ranger_arcana_custom_v2:IsPurgeException() return false end
function modifier_drow_ranger_arcana_custom_v2:RemoveOnDeath() return false end
function modifier_drow_ranger_arcana_custom_v2:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_PROJECTILE_NAME,
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
        MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND,
    }
end

function modifier_drow_ranger_arcana_custom_v2:GetAttackSound()
    return "Hero_DrowRanger.Attack.Arcana"
end

function modifier_drow_ranger_arcana_custom_v2:GetModifierProjectileName()
if not self:GetParent():HasModifier("modifier_drow_ranger_wave_of_silence_custom_legendary_illusion") then 
    return "particles/econ/items/drow/drow_arcana/drow_arcana_base_attack_v2.vpcf"
end

end


function modifier_drow_ranger_arcana_custom_v2:OnCreated(table)
self.parent = self:GetParent()
self.parent:AddDeathEvent(self)
end


function modifier_drow_ranger_arcana_custom_v2:GetActivityTranslationModifiers()
    return "red"
end

function modifier_drow_ranger_arcana_custom_v2:DeathEvent(params)
    if not IsServer() then return end
    if params.attacker == self:GetParent() and params.unit:IsRealHero() and params.unit ~= self:GetParent() then
        -- Death kill effect
        local caster_effect = ParticleManager:CreateParticle("particles/econ/items/drow/drow_arcana/drow_v2_arcana_revenge_kill_effect_caster.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
        ParticleManager:SetParticleControlEnt(caster_effect, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
        ParticleManager:SetParticleControlEnt(caster_effect, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
        ParticleManager:ReleaseParticleIndex(caster_effect)

        local target_effect = ParticleManager:CreateParticle("particles/econ/items/drow/drow_arcana/drow_v2_arcana_revenge_kill_effect_target.vpcf", PATTACH_ABSORIGIN_FOLLOW, params.unit)
        ParticleManager:SetParticleControlEnt(target_effect, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
        ParticleManager:SetParticleControl(target_effect, 1, params.unit:GetAbsOrigin())
        ParticleManager:ReleaseParticleIndex(target_effect)
        return
    end
end