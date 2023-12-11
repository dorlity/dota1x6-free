

modifier_generic_repair = class({})
function modifier_generic_repair:IsHidden() return false end
function modifier_generic_repair:IsPurgable() return false end
function modifier_generic_repair:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_generic_repair:GetTexture() return "item_repair_kit" end

function modifier_generic_repair:OnCreated(table)
if not IsServer() then return end
self.heal = 0

if table.tower_heal then 
	self.heal = table.tower_heal
end

if self:GetParent():GetUnitName() ~= "npc_towerradiant" and self:GetParent():GetUnitName() ~= "npc_towerdire" and table.heal_shrine then 
    self.heal = table.shrine_heal
end

self.particle = ParticleManager:CreateParticle("particles/items5_fx/repair_kit.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControl(self.particle, 0, self:GetParent():GetAbsOrigin())
ParticleManager:SetParticleControl(self.particle, 1, self:GetParent():GetAbsOrigin())
self:AddParticle(self.particle, false, false, -1, false, false)


self.heal = (self.heal*self:GetParent():GetMaxHealth()/100)/self:GetRemainingTime()


self:OnIntervalThink()
self:StartIntervalThink(1)
self:SetHasCustomTransmitterData(true)
end


function modifier_generic_repair:AddCustomTransmitterData() return 
{
heal = self.heal,
} 
end

function modifier_generic_repair:HandleCustomTransmitterData(data)

self.heal = data.heal
end


function modifier_generic_repair:OnIntervalThink()
if not IsServer() then return end

local particle = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
ParticleManager:ReleaseParticleIndex( particle )

SendOverheadEventMessage(self:GetParent(), 10, self:GetParent(), self.heal, nil)

end


function modifier_generic_repair:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
}
end



function modifier_generic_repair:GetModifierConstantHealthRegen()
return self.heal
end


function modifier_generic_repair:OnTakeDamage(params)
if not IsServer() then return end
if self:GetParent() ~= params.unit then return end

self:Destroy()
end