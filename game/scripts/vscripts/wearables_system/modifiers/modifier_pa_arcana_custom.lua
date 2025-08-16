modifier_pa_arcana_custom = class({})
function modifier_pa_arcana_custom:IsHidden() return true end
function modifier_pa_arcana_custom:IsPurgable() return false end
function modifier_pa_arcana_custom:IsPurgeException() return false end
function modifier_pa_arcana_custom:RemoveOnDeath() return false end

function modifier_pa_arcana_custom:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
    }
end

function modifier_pa_arcana_custom:GetActivityTranslationModifiers()
    return "arcana"
end

function modifier_pa_arcana_custom:OnCreated()
if not IsServer() then return end
self.parent = self:GetParent()
self.parent:AddDeathEvent(self)
self:HasHeadAltStyle()
end

function modifier_pa_arcana_custom:OnDestroy()
    if not IsServer() then return end
    self:HasHeadAltStyle(true)
end

function modifier_pa_arcana_custom:HasHeadAltStyle(only_group, head)
    if not IsServer() then return end

    local all_items_list = {}

    if self.parent.items_data_custom ~= nil then
        for _, item in pairs(self.parent.items_data_custom) do
            table.insert(all_items_list, item)
        end
    end

    if self.parent.other_model_backup ~= nil then
        for _, item in pairs(self.parent.other_model_backup) do
            table.insert(all_items_list, item)
        end
    end

    local active = false

    for _, item in pairs(all_items_list) do
        if item and not item:IsNull() and item ~= nil then
            if item:GetModelName() == "models/items/phantom_assassin/lunar_dragon_pa/lunar_dragon_pa_head.vmdl" then
                active = true
                break
            end
        end
    end

    if not only_group then
        local weapon_model = nil
        for _, item in pairs(all_items_list) do
            if item and not item:IsNull() and item ~= nil then
                if item:GetModelName() == "models/heroes/phantom_assassin/pa_arcana_weapons.vmdl" then
                    if active then
                        if tostring(item:GetMaterialGroupHash()) == "628863847" then
                            item:SetOriginalModel("models/items/phantom_assassin/lunar_dragon_pa/lunar_dragon_pa_weapon_arcana_1.vmdl")
                            item:SetModel("models/items/phantom_assassin/lunar_dragon_pa/lunar_dragon_pa_weapon_arcana_1.vmdl")
                        else
                            item:SetOriginalModel("models/items/phantom_assassin/lunar_dragon_pa/lunar_dragon_pa_weapon_arcana.vmdl")
                            item:SetModel("models/items/phantom_assassin/lunar_dragon_pa/lunar_dragon_pa_weapon_arcana.vmdl")
                        end
                        weapon_model = item
                    end
                end
                if item:GetModelName() == "models/items/phantom_assassin/lunar_dragon_pa/lunar_dragon_pa_back.vmdl" or item:GetModelName() == "models/items/phantom_assassin/lunar_dragon_pa/lunar_dragon_pa_back_1.vmdl" then
                    if tostring(item:GetMaterialGroupHash()) == "628863847" then
                        item:SetOriginalModel("models/items/phantom_assassin/lunar_dragon_pa/lunar_dragon_pa_back_arcana_refit_1.vmdl")
                        item:SetModel("models/items/phantom_assassin/lunar_dragon_pa/lunar_dragon_pa_back_arcana_refit_1.vmdl")
                    else
                        item:SetOriginalModel("models/items/phantom_assassin/lunar_dragon_pa/lunar_dragon_pa_back_arcana_refit.vmdl")
                        item:SetModel("models/items/phantom_assassin/lunar_dragon_pa/lunar_dragon_pa_back_arcana_refit.vmdl")
                    end
                end
            end
        end
        if active and weapon_model then
            Timers:CreateTimer(3, function()
                if self.parent ~= nil and self.parent.particles_items_data_custom ~= nil and self.parent.particles_items_data_custom["weapon"] ~= nil then
                    for _, particle in pairs(self.parent.particles_items_data_custom["weapon"]) do
                        ParticleManager:DestroyParticle(particle, true)
                    end
                    local new_hero_effect = ParticleManager:CreateParticle("particles/econ/items/phantom_assassin/lunar_dragon_pa/lunar_dragon_pa_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
                    ParticleManager:SetParticleControlEnt( new_hero_effect, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_leg_r", Vector(0,0,0), true )
                    ParticleManager:SetParticleControlEnt( new_hero_effect, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_leg_l", Vector(0,0,0), true )
                    ParticleManager:SetParticleControlEnt( new_hero_effect, 2, self.parent, PATTACH_POINT_FOLLOW, "attach_hand_r", Vector(0,0,0), true )
                    ParticleManager:SetParticleControlEnt( new_hero_effect, 3, self.parent, PATTACH_POINT_FOLLOW, "attach_hand_l", Vector(0,0,0), true )
                    table.insert(self.parent.particles_items_data_custom["weapon"], new_hero_effect)
                    local blade_1 = ParticleManager:CreateParticle("particles/econ/items/phantom_assassin/lunar_dragon_pa/lunar_dragon_arcana_blade_ambient_a.vpcf", PATTACH_ABSORIGIN_FOLLOW, weapon_model)
                    ParticleManager:SetParticleControlEnt( blade_1, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_attack1", Vector(0,0,0), true )
                    table.insert(self.parent.particles_items_data_custom["weapon"], blade_1)
                    local blade_2 = ParticleManager:CreateParticle("particles/econ/items/phantom_assassin/lunar_dragon_pa/lunar_dragon_blade_arcana_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, weapon_model)
                    ParticleManager:SetParticleControlEnt( blade_2, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_attack2", Vector(0,0,0), true )
                    table.insert(self.parent.particles_items_data_custom["weapon"], blade_2)
                    local eye_1 = ParticleManager:CreateParticle("particles/econ/items/phantom_assassin/lunar_dragon_pa/lunar_dragon_arcana_eyes_l.vpcf", PATTACH_ABSORIGIN_FOLLOW, weapon_model)
                    ParticleManager:SetParticleControlEnt( eye_1, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_eye_l", Vector(0,0,0), true )
                    table.insert(self.parent.particles_items_data_custom["weapon"], eye_1)
                    local eye_2 = ParticleManager:CreateParticle("particles/econ/items/phantom_assassin/lunar_dragon_pa/lunar_dragon_arcana_eyes_r.vpcf", PATTACH_ABSORIGIN_FOLLOW, weapon_model)
                    ParticleManager:SetParticleControlEnt( eye_2, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_eye_r", Vector(0,0,0), true )
                    table.insert(self.parent.particles_items_data_custom["weapon"], eye_2)
                end
            end)
        end
    end

    if only_group then
        for _, item in pairs(all_items_list) do
            if item and not item:IsNull() and item ~= nil then
                if item:GetModelName() == "models/items/phantom_assassin/lunar_dragon_pa/lunar_dragon_pa_back_arcana_refit.vmdl" or item:GetModelName() == "models/items/phantom_assassin/lunar_dragon_pa/lunar_dragon_pa_back_arcana_refit_1.vmdl" then
                    item:SetOriginalModel("models/items/phantom_assassin/lunar_dragon_pa/lunar_dragon_pa_back.vmdl")
                    item:SetModel("models/items/phantom_assassin/lunar_dragon_pa/lunar_dragon_pa_back.vmdl")
                end
            end
        end
    end

    if active then
        self.parent:SetMaterialGroup("1")
    else
        self.parent:SetMaterialGroup("default")
    end

    if head then
        local weapon_model = nil
        for _, item in pairs(all_items_list) do
            if item and not item:IsNull() and item ~= nil then
                if item:GetModelName() == "models/items/phantom_assassin/lunar_dragon_pa/lunar_dragon_pa_weapon_arcana.vmdl" or item:GetModelName() == "models/items/phantom_assassin/lunar_dragon_pa/lunar_dragon_pa_weapon_arcana_1.vmdl" then
                    if active then
                        item:SetOriginalModel("models/heroes/phantom_assassin/pa_arcana_weapons.vmdl")
                        item:SetModel("models/heroes/phantom_assassin/pa_arcana_weapons.vmdl")
                        weapon_model = item
                    end
                end
            end
        end
        if active and weapon_model then
            Timers:CreateTimer(3, function()
                if self.parent ~= nil and self.parent.particles_items_data_custom ~= nil and self.parent.particles_items_data_custom["weapon"] ~= nil then
                    for _, particle in pairs(self.parent.particles_items_data_custom["weapon"]) do
                        ParticleManager:DestroyParticle(particle, true)
                    end
                    local new_hero_effect = ParticleManager:CreateParticle("particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/pa_arcana_elder_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
                    ParticleManager:SetParticleControlEnt( new_hero_effect, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_leg_r", Vector(0,0,0), true )
                    ParticleManager:SetParticleControlEnt( new_hero_effect, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_leg_l", Vector(0,0,0), true )
                    ParticleManager:SetParticleControlEnt( new_hero_effect, 2, self.parent, PATTACH_POINT_FOLLOW, "attach_hand_r", Vector(0,0,0), true )
                    ParticleManager:SetParticleControlEnt( new_hero_effect, 3, self.parent, PATTACH_POINT_FOLLOW, "attach_hand_l", Vector(0,0,0), true )
                    table.insert(self.parent.particles_items_data_custom["weapon"], new_hero_effect)
                    local blade_1 = ParticleManager:CreateParticle("particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/pa_arcana_blade_ambient_a.vpcf", PATTACH_ABSORIGIN_FOLLOW, weapon_model)
                    ParticleManager:SetParticleControlEnt( blade_1, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_attack1", Vector(0,0,0), true )
                    table.insert(self.parent.particles_items_data_custom["weapon"], blade_1)
                    local blade_2 = ParticleManager:CreateParticle("particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/pa_arcana_blade_ambient_b.vpcf", PATTACH_ABSORIGIN_FOLLOW, weapon_model)
                    ParticleManager:SetParticleControlEnt( blade_2, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_attack2", Vector(0,0,0), true )
                    table.insert(self.parent.particles_items_data_custom["weapon"], blade_2)
                    local eye_1 = ParticleManager:CreateParticle("particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/pa_arcana_elder_eyes_l.vpcf", PATTACH_ABSORIGIN_FOLLOW, weapon_model)
                    ParticleManager:SetParticleControlEnt( eye_1, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_eye_l", Vector(0,0,0), true )
                    table.insert(self.parent.particles_items_data_custom["weapon"], eye_1)
                    local eye_2 = ParticleManager:CreateParticle("particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/pa_arcana_elder_eyes_r.vpcf", PATTACH_ABSORIGIN_FOLLOW, weapon_model)
                    ParticleManager:SetParticleControlEnt( eye_2, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_eye_r", Vector(0,0,0), true )
                    table.insert(self.parent.particles_items_data_custom["weapon"], eye_2)
                end
            end)
        end
    end
end

function modifier_pa_arcana_custom:DeathEvent(params)
    if not IsServer() then return end
    if params.unit ~= self:GetParent() then return end
    if not self:GetParent():IsRealHero() then return end
    local abs = self:GetParent():GetAbsOrigin()
    local particle = ParticleManager:CreateParticle("particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/pa_arcana_death.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
    ParticleManager:SetParticleControl(particle, 1, abs)
    ParticleManager:ReleaseParticleIndex(particle)
end