
modifier_generic_movespeed = class({})

function modifier_generic_movespeed:IsHidden() return false end
function modifier_generic_movespeed:IsPurgable() return false end
function modifier_generic_movespeed:GetTexture() return "buffs/reflection_speed" end
function modifier_generic_movespeed:OnCreated(table)
if not IsServer() then return end
self.move_speed = table.movespeed

if table.effect then 
	local effect_cast = ParticleManager:CreateParticle( table.effect, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	self:AddParticle(effect_cast,false,false, -1,false, false)
end


self:SetHasCustomTransmitterData(true)
end

function modifier_generic_movespeed:AddCustomTransmitterData() return 
{
move_speed = self.move_speed,
} 
end

function modifier_generic_movespeed:HandleCustomTransmitterData(data)
self.move_speed = data.move_speed
end


function modifier_generic_movespeed:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end


function modifier_generic_movespeed:GetModifierMoveSpeedBonus_Percentage()
return self.move_speed
end


