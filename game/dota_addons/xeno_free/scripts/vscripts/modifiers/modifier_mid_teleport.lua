LinkLuaModifier("modifier_mid_teleport", "modifiers/modifier_mid_teleport", LUA_MODIFIER_MOTION_NONE)


modifier_mid_teleport = class({})

function modifier_mid_teleport:IsHidden() return false end
function modifier_mid_teleport:IsPurgable() return false end


function modifier_mid_teleport:CheckState()
return 
{
  [MODIFIER_STATE_NO_HEALTH_BAR] = true,
  [MODIFIER_STATE_MAGIC_IMMUNE] = true,
  [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
  [MODIFIER_STATE_CANNOT_BE_MOTION_CONTROLLED] = true,
}
end

function modifier_mid_teleport:DeclareFunctions() 
return {
  MODIFIER_EVENT_ON_ORDER,
  MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
  MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
  MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
  MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
}
end


function modifier_mid_teleport:GetAbsoluteNoDamagePhysical() return 1 end
function modifier_mid_teleport:GetAbsoluteNoDamageMagical() return 1 end
function modifier_mid_teleport:GetAbsoluteNoDamagePure() return 1 end




function modifier_mid_teleport:OnCreated(table)

local number = tonumber(self:GetParent():GetName())



local cp = 1

if number == 3 or number == 9 or number == 8 then 
  cp = 0
end

local effect_cast = ParticleManager:CreateParticle("particles/portal_ring.vpcf" , PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
ParticleManager:SetParticleControl( effect_cast, 12, Vector(cp,0,0) )

self:AddParticle(effect_cast, false, false, -1, false, false)


end








