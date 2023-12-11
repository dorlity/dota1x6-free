LinkLuaModifier("modifier_up_damagestack_stack", "upgrade/general/modifier_up_damagestack", LUA_MODIFIER_MOTION_NONE)


modifier_up_damagestack = class({})


function modifier_up_damagestack:IsHidden() return true end
function modifier_up_damagestack:IsPurgable() return false end
function modifier_up_damagestack:RemoveOnDeath() return false end

function modifier_up_damagestack:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_TAKEDAMAGE
  
}

end

function modifier_up_damagestack:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
end


function modifier_up_damagestack:OnTakeDamage(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker and self:GetParent() ~= params.unit then return end
if params.attacker:IsBuilding() or params.unit:IsBuilding() then return end
if not self:GetParent():IsAlive() then return end
if params.unit == params.attacker then return end
if params.inflictor and params.inflictor:IsItem() then return end
if (self:GetParent():GetAbsOrigin() - params.unit:GetAbsOrigin()):Length2D() > 1500 then return end

self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_up_damagestack_stack", {duration = 3})

end

modifier_up_damagestack_stack = class({})
function modifier_up_damagestack_stack:IsHidden() return false end
function modifier_up_damagestack_stack:IsPurgable() return false end
function modifier_up_damagestack_stack:GetTexture() return "item_timeless_relic" end
function modifier_up_damagestack_stack:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_MODEL_SCALE,
}
end

function modifier_up_damagestack_stack:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
self:StartIntervalThink(1)

end


function modifier_up_damagestack_stack:GetModifierModelScale()
if self:GetStackCount() < 20 then return end
	return 25
end




function modifier_up_damagestack_stack:OnIntervalThink()
if not IsServer() then return end
if self:GetStackCount() >= 20 then return end
self:IncrementStackCount()

if self:GetStackCount() == 20 then 
	self:GetParent():EmitSound("Hero_OgreMagi.Bloodlust.Target")

 	local name = "particles/jugg_damage.vpcf"
    self.particle = ParticleManager:CreateParticle( "particles/jugg_damage.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
    ParticleManager:SetParticleControl( self.particle, 0, self:GetParent():GetAbsOrigin() )
    ParticleManager:SetParticleControl( self.particle, 1, self:GetParent():GetAbsOrigin() )
    ParticleManager:SetParticleControl( self.particle, 2, self:GetParent():GetAbsOrigin() ) 
    self:AddParticle(self.particle, false, false, -1, false, false) 

end

end


function modifier_up_damagestack_stack:GetModifierTotalDamageOutgoing_Percentage()
return self:GetStackCount()*1
end