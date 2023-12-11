
modifier_generic_attack_speed = class({})

function modifier_generic_attack_speed:IsHidden() return false end
function modifier_generic_attack_speed:IsPurgable() return false end
function modifier_generic_attack_speed:GetTexture() return "buffs/bladefury_agility" end
function modifier_generic_attack_speed:OnCreated(table)
if not IsServer() then return end
self.attack_speed = table.attack_speed

if table.attacks_count then 
  self.attacks_count = table.attacks_count
  self:SetStackCount(self.attacks_count)
end


self:SetHasCustomTransmitterData(true)
end

function modifier_generic_attack_speed:AddCustomTransmitterData() return 
{
attack_speed = self.attack_speed,
} 
end

function modifier_generic_attack_speed:HandleCustomTransmitterData(data)
self.attack_speed = data.attack_speed
end


function modifier_generic_attack_speed:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
  MODIFIER_EVENT_ON_ATTACK_LANDED
}
end


function modifier_generic_attack_speed:GetModifierAttackSpeedBonus_Constant()
return self.attack_speed
end


function modifier_generic_attack_speed:OnAttackLanded(params)
if not IsServer() then return end
if self.attacks_count == nil then return end
if self:GetParent() ~= params.attacker then return end

self:DecrementStackCount()
if self:GetStackCount() == 0 then 
  self:Destroy()
end

end