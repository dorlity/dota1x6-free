
modifier_test_hero_custom = class({})
function modifier_test_hero_custom:IsHidden() return true end
function modifier_test_hero_custom:IsPurgable() return false end
function modifier_test_hero_custom:RemoveOnDeath() return false end
function modifier_test_hero_custom:OnCreated(table)
if not IsServer() then return end 
self.pos = GetGroundPosition(Vector(table.x, table.y, 0), nil)
self.res_pos = self.pos
FindClearSpaceForUnit(self:GetParent(), self.pos, false)
end


function modifier_test_hero_custom:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_RESPAWN,
	MODIFIER_EVENT_ON_DEATH,
	MODIFIER_PROPERTY_DISABLE_AUTOATTACK
}
end


function modifier_test_hero_custom:GetDisableAutoAttack()
return 1
end

function modifier_test_hero_custom:OnRespawn(params)
if not IsServer() then return end 
if self:GetParent() ~= params.unit then return end 

FindClearSpaceForUnit(self:GetParent(), self.res_pos, true)

Timers:CreateTimer(FrameTime(), function()
    self:GetParent():RemoveModifierByName("modifier_fountain_invulnerability")
end)

end 


function modifier_test_hero_custom:OnDeath(params)
if not IsServer() then return end 
if self:GetParent() ~= params.unit then return end 

self.res_pos = self:GetParent():GetAbsOrigin()
end