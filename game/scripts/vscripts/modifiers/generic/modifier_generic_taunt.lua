


modifier_generic_taunt = class({})

function modifier_generic_taunt:IsPurgable()
  return false
end
function modifier_generic_taunt:IsHidden()
  return true
end

function modifier_generic_taunt:OnCreated( kv )
if not IsServer() then return end

if not self:GetParent():IsCreep() then 
	self:GetParent():SetForceAttackTarget( self:GetCaster() )
	self:GetParent():MoveToTargetToAttack( self:GetCaster() )
end

self:GetParent():EmitSound("Hero_Axe.Berserkers_Call")
self:StartIntervalThink(FrameTime())
end

function modifier_generic_taunt:OnIntervalThink()
  if not IsServer() then return end
  if not self:GetCaster():IsAlive() then
    self:Destroy()
  end
end

function modifier_generic_taunt:OnDestroy()
if not IsServer() then return end

if not self:GetParent():IsCreep() then 
	self:GetParent():SetForceAttackTarget( nil )
end

end

function modifier_generic_taunt:CheckState()
  local state = {
    [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
    [MODIFIER_STATE_TAUNTED] = true,
  }

  return state
end

function modifier_generic_taunt:GetStatusEffectName()
  return "particles/status_fx/status_effect_beserkers_call.vpcf"
end

