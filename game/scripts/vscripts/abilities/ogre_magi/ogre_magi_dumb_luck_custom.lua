LinkLuaModifier( "modifier_ogre_magi_dumb_luck_custom", "abilities/ogre_magi/ogre_magi_dumb_luck_custom", LUA_MODIFIER_MOTION_NONE )

ogre_magi_dumb_luck_custom = class({})

function ogre_magi_dumb_luck_custom:GetIntrinsicModifierName()
return "modifier_ogre_magi_dumb_luck_custom"
end


modifier_ogre_magi_dumb_luck_custom = class({})
function modifier_ogre_magi_dumb_luck_custom:IsHidden() return false end
function modifier_ogre_magi_dumb_luck_custom:IsPurgable() return false end


function modifier_ogre_magi_dumb_luck_custom:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOOLTIP,
	MODIFIER_PROPERTY_TOOLTIP2,
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
end


function modifier_ogre_magi_dumb_luck_custom:OnTooltip()
local multi = self:GetParent():FindAbilityByName("ogre_magi_multicast_custom")

local chance_2 = multi:GetSpecialValueFor( "multicast_2_times" )
local luck = self:GetAbility()

if self:GetParent():HasModifier("modifier_ogremagi_multi_1") and chance_2 > 0 then 
	chance_2 = chance_2 + multi.chance[self:GetParent():GetUpgradeStack("modifier_ogremagi_multi_1")]
end

if luck and chance_2 > 0 then 
	chance_2 = chance_2 + self:GetParent():GetStrength()/luck:GetSpecialValueFor("str_chance")
end


return chance_2
end


function modifier_ogre_magi_dumb_luck_custom:OnTooltip2()
local multi = self:GetParent():FindAbilityByName("ogre_magi_multicast_custom")

local chance_3 = multi:GetSpecialValueFor( "multicast_3_times" )
local luck = self:GetAbility()

if self:GetParent():HasModifier("modifier_ogremagi_multi_1") and chance_3 > 0 then 
	chance_3 = chance_3 + multi.chance[self:GetParent():GetUpgradeStack("modifier_ogremagi_multi_1")]
end

if luck and chance_3 > 0 then 
	chance_3 = chance_3 + self:GetParent():GetStrength()/luck:GetSpecialValueFor("str_chance")
end


return chance_3
end


function modifier_ogre_magi_dumb_luck_custom:GetModifierAttackSpeedBonus_Constant()
if IsServer() then return end
local multi = self:GetParent():FindAbilityByName("ogre_magi_multicast_custom")

local chance_4 = multi:GetSpecialValueFor( "multicast_4_times" )
local luck = self:GetAbility()

if self:GetParent():HasModifier("modifier_ogremagi_multi_1") and chance_4 > 0 then 
	chance_4 = chance_4 + multi.chance[self:GetParent():GetUpgradeStack("modifier_ogremagi_multi_1")]
end

if luck and chance_4 > 0 then 
	chance_4 = chance_4 + self:GetParent():GetStrength()/luck:GetSpecialValueFor("str_chance")
end


return chance_4
end