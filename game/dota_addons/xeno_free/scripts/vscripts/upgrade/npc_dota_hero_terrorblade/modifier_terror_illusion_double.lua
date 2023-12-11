

modifier_terror_illusion_double = class({})


function modifier_terror_illusion_double:IsHidden() return true end
function modifier_terror_illusion_double:IsPurgable() return false end



function modifier_terror_illusion_double:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true 
    
  local ability = self:GetParent():FindAbilityByName("custom_terrorblade_conjure_image")
  if ability then 
  	self:GetParent():AddNewModifier(self:GetParent(), ability, "modifier_conjure_image_legendary_aura", {})
  end
  
end


function modifier_terror_illusion_double:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_terror_illusion_double:RemoveOnDeath() return false end