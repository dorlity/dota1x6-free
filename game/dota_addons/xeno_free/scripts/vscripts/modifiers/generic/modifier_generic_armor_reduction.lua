
modifier_generic_armor_reduction = class({})

function modifier_generic_armor_reduction:IsHidden() return false end
function modifier_generic_armor_reduction:IsPurgable() return false end
function modifier_generic_armor_reduction:GetTexture() return "buffs/moment_armor" end
function modifier_generic_armor_reduction:OnCreated(table)
if not IsServer() then return end
self.armor_reduction = table.armor_reduction
self.particle_peffect = ParticleManager:CreateParticle("particles/items3_fx/star_emblem.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())	
ParticleManager:SetParticleControl(self.particle_peffect, 0, self:GetParent():GetAbsOrigin())
self:AddParticle(self.particle_peffect, false, false, -1, false, true)

self:SetHasCustomTransmitterData(true)
end

function modifier_generic_armor_reduction:AddCustomTransmitterData() return 
{
armor_reduction = self.armor_reduction,
} 
end

function modifier_generic_armor_reduction:HandleCustomTransmitterData(data)
self.armor_reduction = data.armor_reduction
end


function modifier_generic_armor_reduction:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
}
end


function modifier_generic_armor_reduction:GetModifierPhysicalArmorBonus()
return self.armor_reduction
end

