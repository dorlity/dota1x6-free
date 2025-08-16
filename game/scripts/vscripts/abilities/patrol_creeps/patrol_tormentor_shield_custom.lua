LinkLuaModifier("modifier_patrol_tormentor_shield_custom", "abilities/patrol_creeps/patrol_tormentor_shield_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_patrol_tormentor_shield_custom_heal_aura", "abilities/patrol_creeps/patrol_tormentor_shield_custom", LUA_MODIFIER_MOTION_NONE)


patrol_tormentor_shield_custom = class({})


function patrol_tormentor_shield_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end

end

