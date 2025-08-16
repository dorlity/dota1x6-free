LinkLuaModifier("modifier_patrol_tormentor_reflect_custom", "abilities/patrol_creeps/patrol_tormentor_reflect_custom", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_tormentor_custom", "modifiers/creeps/modifier_tormentor_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_tormentor_custom_mark", "modifiers/creeps/modifier_tormentor_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_tormentor_custom_health", "modifiers/creeps/modifier_tormentor_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_tormentor_custom_stun_cd", "modifiers/creeps/modifier_tormentor_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_tormentor_custom_stun_wave", "modifiers/creeps/modifier_tormentor_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_tormentor_custom_stun", "modifiers/creeps/modifier_tormentor_custom", LUA_MODIFIER_MOTION_NONE )



patrol_tormentor_reflect_custom = class({})


function patrol_tormentor_reflect_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end

PrecacheResource( "particle","particles/neutral_fx/miniboss_shield.vpcf", context )
PrecacheResource( "particle","particles/neutral_fx/miniboss_damage_reflect.vpcf", context )
PrecacheResource( "particle","particles/neutral_fx/miniboss_damage_impact.vpcf", context )

PrecacheResource( "particle","particles/neutral_fx/miniboss_shield_dire.vpcf", context )
PrecacheResource( "particle","particles/neutral_fx/miniboss_damage_reflect_dire.vpcf", context )
PrecacheResource( "particle","particles/neutral_fx/miniboss_dire_damage_impact.vpcf", context )
PrecacheResource( "particle","particles/tormentor/tormentor_mark.vpcf", context )
PrecacheResource( "particle","particles/tormentor/tormentor_mark_dire.vpcf", context )

PrecacheResource( "particle","particles/tormentor/stun_wave_dire.vpcf", context )
PrecacheResource( "particle","particles/tormentor/stun_wave.vpcf", context )
PrecacheResource( "particle","particles/tormentor/stun_wave_electro.vpcf", context )
PrecacheResource( "particle","particles/tormentor/stun_wave_electro_dire.vpcf", context )
PrecacheResource( "particle","particles/tormentor/stun_target.vpcf", context )
PrecacheResource( "particle","particles/tormentor/stun_target_dire.vpcf", context )
end

