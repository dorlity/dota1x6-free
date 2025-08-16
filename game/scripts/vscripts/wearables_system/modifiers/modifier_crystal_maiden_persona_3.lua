modifier_crystal_maiden_persona_3 = class({})
function modifier_crystal_maiden_persona_3:IsHidden() return true end
function modifier_crystal_maiden_persona_3:IsPurgable() return false end
function modifier_crystal_maiden_persona_3:IsPurgeException() return false end
function modifier_crystal_maiden_persona_3:RemoveOnDeath() return false end

function modifier_crystal_maiden_persona_3:OnCreated()
    if not IsServer() then return end
    self.original_size = self:GetParent():GetModelScale()
    self:GetParent():SetModelScale(1.23)
    local items = 
    {
        "models/items/crystal_maiden/familiars_regalia/familiars_regalia.vmdl",
        "models/items/crystal_maiden/familiars_tail/familiars_tail.vmdl",
        "models/items/crystal_maiden/familiars_sacred_horns/familiars_sacred_horns.vmdl",
        "models/items/crystal_maiden/frostfire_beads/frostfire_beads.vmdl",
    }
    self.items = {}
    for _, item_model in pairs(items) do
        local item = wearables_system:CreateWearable(self:GetParent(), item_model)
        table.insert(self.items, item)
        if item then
            if item_model == "models/items/crystal_maiden/frostfire_beads/frostfire_beads.vmdl" then
                Timers:CreateTimer(1, function()
                    local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_crystalmaiden_persona/cm_persona_ambient_crystals.vpcf", PATTACH_ABSORIGIN_FOLLOW, item)
                    ParticleManager:SetParticleControlEnt( particle, 11, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_crystal_L_A", self:GetParent():GetAbsOrigin(), true )
                    ParticleManager:SetParticleControlEnt( particle, 12, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_crystal_R_A", self:GetParent():GetAbsOrigin(), true )
                    ParticleManager:SetParticleControlEnt( particle, 13, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_crystal_L_B", self:GetParent():GetAbsOrigin(), true )
                    ParticleManager:SetParticleControlEnt( particle, 14, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_crystal_R_B", self:GetParent():GetAbsOrigin(), true )
                    ParticleManager:SetParticleControlEnt( particle, 15, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_crystal_L_C", self:GetParent():GetAbsOrigin(), true )
                    ParticleManager:SetParticleControlEnt( particle, 16, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_crystal_R_C", self:GetParent():GetAbsOrigin(), true )
                    self:AddParticle(particle, false, false, -1, false, false)
                end)
            end
        end
    end
    local modifier_hero_donate_hex_checking = self:GetParent():FindModifierByName("modifier_hero_donate_hex_checking")
    if modifier_hero_donate_hex_checking then
        modifier_hero_donate_hex_checking:UpdatePlayerItems()
    end
end

function modifier_crystal_maiden_persona_3:OnDestroy()
    if not IsServer() then return end
    self:GetParent():SetModelScale(self.original_size)
    for _, item in pairs(self.items) do
        if item and not item:IsNull() then
            item:AddEffects(EF_NODRAW)
            item:Destroy()
        end
    end
    local modifier_hero_donate_hex_checking = self:GetParent():FindModifierByName("modifier_hero_donate_hex_checking")
    if modifier_hero_donate_hex_checking then
        modifier_hero_donate_hex_checking:UpdatePlayerItems()
    end
end

function modifier_crystal_maiden_persona_3:GetActivityTranslationModifiers()
    return "persona"
end

function modifier_crystal_maiden_persona_3:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_PROJECTILE_NAME,
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
    }
end

function modifier_crystal_maiden_persona_3:GetModifierProjectileName()
    return "particles/units/heroes/hero_crystalmaiden_persona/cm_persona_attack.vpcf"
end