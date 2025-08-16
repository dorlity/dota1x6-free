LinkLuaModifier( "modifier_crystal_maiden_blueheart_custom", "abilities/crystal_maiden/crystal_maiden_innate_custom", LUA_MODIFIER_MOTION_NONE )


crystal_maiden_innate_custom = class({})


function crystal_maiden_innate_custom:GetIntrinsicModifierName()
if not self:GetCaster():IsRealHero() then return end 
return "modifier_crystal_maiden_blueheart_custom"
end

function crystal_maiden_innate_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end
PrecacheResource( "soundfile", "soundevents/npc_dota_hero_crystal_maiden.vsndevts", context )
PrecacheResource( "soundfile", "soundevents/vo_custom/crystal_maiden_vo_custom.vsndevts", context ) 
end




modifier_crystal_maiden_blueheart_custom = class({})
function modifier_crystal_maiden_blueheart_custom:IsHidden() return false end
function modifier_crystal_maiden_blueheart_custom:IsPurgable() return false end
function modifier_crystal_maiden_blueheart_custom:RemoveOnDeath() return false end
function modifier_crystal_maiden_blueheart_custom:OnCreated(table)
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.int = self.ability:GetSpecialValueFor("int")
self.damage = self.ability:GetSpecialValueFor("damage")

end


function modifier_crystal_maiden_blueheart_custom:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
	MODIFIER_PROPERTY_HEALTH_BONUS,
	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
}
end


function modifier_crystal_maiden_blueheart_custom:GetModifierSpellAmplify_Percentage()
return self.damage*(self.parent:GetIntellect(false)/self.int)
end


function modifier_crystal_maiden_blueheart_custom:GetModifierHealthBonus()
if not self.parent:HasTalent("modifier_maiden_frostbite_3") then return end 
return self.parent:GetIntellect(false)*self.parent:GetTalentValue("modifier_maiden_frostbite_3", "health")
end 

function modifier_crystal_maiden_blueheart_custom:GetModifierPhysicalArmorBonus()
if not self.parent:HasTalent("modifier_maiden_frostbite_3") then return end 
return self.parent:GetIntellect(false)/self.parent:GetTalentValue("modifier_maiden_frostbite_3", "armor")
end
 
