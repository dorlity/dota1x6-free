LinkLuaModifier("modifier_donate_hero_illusion_item", "modifiers/hero_items/modifier_hero_donate_illusion", LUA_MODIFIER_MOTION_NONE)

modifier_huskar_2021_weapon_custom = class({})
function modifier_huskar_2021_weapon_custom:IsHidden() return true end
function modifier_huskar_2021_weapon_custom:IsPurgable() return false end
function modifier_huskar_2021_weapon_custom:IsPurgeException() return false end
function modifier_huskar_2021_weapon_custom:RemoveOnDeath() return false end
function modifier_huskar_2021_weapon_custom:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
    }
end
function modifier_huskar_2021_weapon_custom:GetActivityTranslationModifiers()
    return "2021_huskar"
end
function modifier_huskar_2021_weapon_custom:OnCreated()
    if not IsServer() then return end
    if self:GetParent():IsIllusion() then
        self.hand = CreateUnitByName("npc_dota_donate_item_illusion", Vector(0, 0, 0), false, nil, nil, self:GetParent():GetTeam())
        self.hand:AddNewModifier(self.hand, nil, "modifier_donate_hero_illusion_item", {})
        self.hand:SetModel( "models/items/huskar/husk_2021_immortal/husk_2021_immortal_arm_model.vmdl" )
        self.hand:SetOriginalModel( "models/items/huskar/husk_2021_immortal/husk_2021_immortal_arm_model.vmdl" )
        self.hand:SetTeam( self:GetParent():GetTeamNumber() )
        self.hand:SetOwner( self:GetParent() )
        self.hand:FollowEntity(self:GetParent(), true)
        local particle_item_effect = ParticleManager:CreateParticle("particles/econ/items/huskar/huskar_2021_immortal/huskar_2021_immortal_arm.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.hand)
        self.hand:AddNewModifier(self.hand, nil, "modifier_illusion", {})
        self.hand:AddNewModifier(self:GetParent(), nil, "modifier_donate_hero_illusion_item", {})
    else
        self.hand = CreateUnitByName("npc_dota_donate_item_illusion", Vector(0, 0, 0), false, nil, nil, self:GetParent():GetTeam())
        self.hand:AddNewModifier(self.hand, nil, "modifier_donate_hero_illusion_item", {})
        self.hand:SetModel( "models/items/huskar/husk_2021_immortal/husk_2021_immortal_arm_model.vmdl" )
        self.hand:SetOriginalModel( "models/items/huskar/husk_2021_immortal/husk_2021_immortal_arm_model.vmdl" )
        self.hand:SetTeam( self:GetParent():GetTeamNumber() )
        self.hand:SetOwner( self:GetParent() )
        self.hand:FollowEntity(self:GetParent(), true)
        local particle_item_effect = ParticleManager:CreateParticle("particles/econ/items/huskar/huskar_2021_immortal/huskar_2021_immortal_arm.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.hand)
        self.hand:AddNewModifier(self:GetParent(), nil, "modifier_donate_hero_illusion_item", {})
    end
end
function modifier_huskar_2021_weapon_custom:OnDestroy()
    if not IsServer() then return end
    if self.hand then
        self.hand:AddEffects(EF_NODRAW)
        self.hand:Destroy()
    end
end