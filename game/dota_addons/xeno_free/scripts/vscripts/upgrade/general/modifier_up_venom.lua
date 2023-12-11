LinkLuaModifier("modifier_up_venom_stack", "upgrade/general/modifier_up_venom", LUA_MODIFIER_MOTION_NONE)


modifier_up_venom = class({})


function modifier_up_venom:IsHidden() return true end
function modifier_up_venom:IsPurgable() return false end
function modifier_up_venom:RemoveOnDeath() return false end

function modifier_up_venom:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_TAKEDAMAGE
  
}

end


function modifier_up_venom:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
end

function modifier_up_venom:OnRefresh(table)
if not IsServer() then return end
self:IncrementStackCount()
end


function modifier_up_venom:OnTakeDamage(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end
if params.unit:IsMagicImmune() then return end
if params.unit:IsBuilding() then return end
if params.unit:GetHealthPercent() > 40 then return end
if params.unit == params.attacker then return end

params.unit:AddNewModifier(self:GetParent(), nil, "modifier_up_venom_stack", {duration = 2})

end

modifier_up_venom_stack = class({})
function modifier_up_venom_stack:IsHidden() return false end
function modifier_up_venom_stack:IsPurgable() return false end
function modifier_up_venom_stack:GetTexture() return "item_orb_of_venom" end
function modifier_up_venom_stack:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
  MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
  MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE
}
end



function modifier_up_venom_stack:GetModifierLifestealRegenAmplify_Percentage() 
return -5 + -10*self:GetCaster():GetUpgradeStack("modifier_up_venom")
end

function modifier_up_venom_stack:GetModifierHealAmplify_PercentageTarget()
return -5 + -10*self:GetCaster():GetUpgradeStack("modifier_up_venom")
end


function modifier_up_venom_stack:GetModifierHPRegenAmplify_Percentage() 
return -5 + -10*self:GetCaster():GetUpgradeStack("modifier_up_venom")
end
