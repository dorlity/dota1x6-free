LinkLuaModifier("modifier_donate_hero_illusion_item", "modifiers/hero_items/modifier_hero_donate_illusion", LUA_MODIFIER_MOTION_NONE)

modifier_phantom_assassin_persona_custom = class({})
function modifier_phantom_assassin_persona_custom:IsHidden() return true end
function modifier_phantom_assassin_persona_custom:IsPurgable() return false end
function modifier_phantom_assassin_persona_custom:IsPurgeException() return false end
function modifier_phantom_assassin_persona_custom:RemoveOnDeath() return false end

function modifier_phantom_assassin_persona_custom:OnCreated()
    if not IsServer() then return end
    local items = 
    {
        "models/heroes/phantom_assassin_persona/phantom_assassin_persona_weapon.vmdl",
        "models/heroes/phantom_assassin_persona/phantom_assassin_persona_head.vmdl",
        "models/heroes/phantom_assassin_persona/phantom_assassin_persona_legs.vmdl",
        "models/heroes/phantom_assassin_persona/phantom_assassin_persona_armor.vmdl",
    }
    self.items = {}
    for _, item_model in pairs(items) do
        if self:GetParent():IsIllusion() then
            local item = CreateUnitByName("npc_dota_donate_item_illusion", Vector(0, 0, 0), false, nil, nil, self:GetParent():GetTeam())
            item:AddNewModifier(item, nil, "modifier_donate_hero_illusion_item", {})
            item:SetModel( item_model )
            item:SetOriginalModel( item_model )
            item:SetTeam( self:GetParent():GetTeamNumber() )
            item:SetOwner( self:GetParent() )
            item:FollowEntity(self:GetParent(), true)
            item:AddNewModifier(item, nil, "modifier_illusion", {})
            item:AddNewModifier(self:GetParent(), nil, "modifier_donate_hero_illusion_item", {})
            table.insert(self.items, item)
        else
            local item = CreateUnitByName("npc_dota_donate_item_illusion", Vector(0, 0, 0), false, nil, nil, self:GetParent():GetTeam())
            item:AddNewModifier(item, nil, "modifier_donate_hero_illusion_item", {})
            item:SetModel( item_model )
            item:SetOriginalModel( item_model )
            item:SetTeam( self:GetParent():GetTeamNumber() )
            item:SetOwner( self:GetParent() )
            item:FollowEntity(self:GetParent(), true)
            item:AddNewModifier(self:GetParent(), nil, "modifier_donate_hero_illusion_item", {})
            table.insert(self.items, item)
        end
    end
end
function modifier_phantom_assassin_persona_custom:OnDestroy()
    if not IsServer() then return end
    for _, item in pairs(self.items) do
        if item and not item:IsNull() then
            item:AddEffects(EF_NODRAW)
            item:Destroy()
        end
    end
end

function modifier_phantom_assassin_persona_custom:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND
    }
end

function modifier_phantom_assassin_persona_custom:GetAttackSound()
    return "Hero_PhantomAssassin.Attack.Persona"
end