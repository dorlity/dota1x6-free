LinkLuaModifier("modifier_magic_shield", "upgrade/general/modifier_up_magicblock", LUA_MODIFIER_MOTION_NONE)

modifier_up_magicblock = class({})


function modifier_up_magicblock:IsHidden() return true end
function modifier_up_magicblock:IsPurgable() return false end


function modifier_up_magicblock:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
  

self:OnIntervalThink()

self:StartIntervalThink(30)
  
end


function modifier_up_magicblock:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
end


function modifier_up_magicblock:RemoveOnDeath() return false end


function modifier_up_magicblock:OnIntervalThink()
if not IsServer() then return end

if not self:GetParent():IsAlive() then 

  self:StartIntervalThink(0.3)
  return
end

local mod = self:GetParent():FindModifierByName("modifier_magic_shield")
if mod then mod:Destroy() end

self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_magic_shield", {duration = 30.5})


self:StartIntervalThink(30)
end




modifier_magic_shield = class({})
function modifier_magic_shield:IsHidden() return false end
function modifier_magic_shield:IsPurgable() return false end

function modifier_magic_shield:GetTexture() return "item_hood_of_defiance" end



function modifier_magic_shield:OnCreated(table)

self.max_shield = 200*self:GetParent():GetUpgradeStack("modifier_up_magicblock")

if not IsServer() then return end

self:SetStackCount(self.max_shield)

self:GetParent():EmitSound("DOTA_Item.Pipe.Activate")
    
self.particle = ParticleManager:CreateParticle("particles/items2_fx/pipe_of_insight_v2.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
ParticleManager:SetParticleControl(self.particle, 0, self:GetParent():GetAbsOrigin())
ParticleManager:SetParticleControlEnt(self.particle, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_origin", self:GetParent():GetAbsOrigin(), true)
ParticleManager:SetParticleControl(self.particle, 2, Vector(125, 0, 0))

self:AddParticle(self.particle,false, false, -1, false, false)

end



function modifier_magic_shield:DeclareFunctions()
return 
{
  MODIFIER_PROPERTY_INCOMING_SPELL_DAMAGE_CONSTANT,
  MODIFIER_PROPERTY_TOOLTIP,
}
end

function modifier_magic_shield:OnTooltip() return self:GetStackCount() end



function modifier_magic_shield:GetModifierIncomingSpellDamageConstant(params)

if IsClient() then 
  if params.report_max then 
    return self.max_shield 
  else 
    return self:GetStackCount()
  end 
end

if not IsServer() then return end

if self:GetParent() == params.attacker then return end


if self:GetStackCount() > params.damage then
    self:SetStackCount(self:GetStackCount() - params.damage)
    local i = params.damage
    return -i
else
    
    local i = self:GetStackCount()
    self:SetStackCount(0)
    self:Destroy()
    return -i
end

end



