

modifier_up_lifesteal = class({})



function modifier_up_lifesteal:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
self.StackOnIllusion = true 

self.attack_ability =
{
  ["muerta_gunslinger_custom"] = true,
}

end


function modifier_up_lifesteal:IsHidden() return true end
function modifier_up_lifesteal:IsPurgable() return false end


function modifier_up_lifesteal:DeclareFunctions()
return 
{
  MODIFIER_EVENT_ON_ATTACK_LANDED,
  MODIFIER_EVENT_ON_TAKEDAMAGE
} 
end



function modifier_up_lifesteal:OnTakeDamage( param )


if self:GetParent() == param.attacker and (param.inflictor == nil or self.attack_ability[param.inflictor:GetName()] == true) 
  and not param.unit:IsBuilding() and not param.unit:IsIllusion() then 

  local k = 0
  if self:GetParent():HasModifier("modifier_item_alchemist_gold_octarine_active") then 
    k = 1.4
  end

  self:GetParent():Heal(param.damage * (6*self:GetStackCount()*(1 + k +0.3*self:GetParent():GetUpgradeStack("modifier_up_graypoints")) / 100), self:GetParent())
  local particle = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
  ParticleManager:ReleaseParticleIndex( particle )
  
end


end




function modifier_up_lifesteal:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end


function modifier_up_lifesteal:RemoveOnDeath() return false end
  