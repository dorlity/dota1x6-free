modifier_creeps_trap = class({})

function modifier_creeps_trap:GetTexture()
	return "techies_stasis_trap" 
end

function modifier_creeps_trap:CheckState()
	local state = {[MODIFIER_STATE_STUNNED] = true}
	return state
end

function modifier_creeps_trap:IsHidden() return false end
function modifier_creeps_trap:IsPurgable() return true end

function modifier_creeps_trap:GetStatusEffectName()
	return "particles/status_fx/status_effect_techies_stasis.vpcf"
end
function modifier_creeps_trap:GetEffectName() return "particles/generic_gameplay/generic_sleep.vpcf" end


function modifier_creeps_trap:GetEffectAttachType()
return PATTACH_OVERHEAD_FOLLOW
end

function modifier_creeps_trap:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_TAKEDAMAGE
}
end


function modifier_creeps_trap:OnTakeDamage(params)
if not IsServer() then return end
if not params.attacker then return end
if self:GetParent() ~= params.unit then  return end
if (self:GetParent():GetAbsOrigin() - params.attacker:GetAbsOrigin()):Length2D() >= 2000 then return end

self:Destroy()
end



function modifier_creeps_trap:OnCreated(table)
if not IsServer() then return end
self:StartIntervalThink(FrameTime())
end


function modifier_creeps_trap:OnDestroy()
if not IsServer() then return end

CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetCaster():GetPlayerOwnerID()), 'TrapAlert_hide',  {})
self:GetParent():AddNewModifier(self:GetCaster(), nil, "modifier_creeps_movespeed" , {duration = 5})
end



function modifier_creeps_trap:OnIntervalThink()
if not IsServer() then return end
CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetCaster():GetPlayerOwnerID()), 'TrapAlert_think',  {time = self:GetRemainingTime(), max = Trap_Duration})


end


modifier_creeps_movespeed = class({})
function modifier_creeps_movespeed:IsHidden() return true end
function modifier_creeps_movespeed:IsPurgable() return false end
function modifier_creeps_movespeed:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}

end

function modifier_creeps_movespeed:GetModifierMoveSpeedBonus_Percentage()
return -100
end