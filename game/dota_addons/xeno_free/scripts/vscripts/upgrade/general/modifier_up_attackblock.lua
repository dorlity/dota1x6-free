LinkLuaModifier("modifier_attack_shield", "upgrade/general/modifier_up_attackblock", LUA_MODIFIER_MOTION_NONE)



modifier_up_attackblock = class({})


function modifier_up_attackblock:IsHidden() return true end
function modifier_up_attackblock:IsPurgable() return false end


function modifier_up_attackblock:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
  

self:OnIntervalThink()

self:StartIntervalThink(30)
  
end


function modifier_up_attackblock:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
end


function modifier_up_attackblock:RemoveOnDeath() return false end


function modifier_up_attackblock:OnIntervalThink()
if not IsServer() then return end

if not self:GetParent():IsAlive() then 

  self:StartIntervalThink(0.3)
  return
end

local mod = self:GetParent():FindModifierByName("modifier_attack_shield")
if mod then mod:Destroy() end

self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_attack_shield", {duration = 30.5})


self:StartIntervalThink(30)
end




modifier_attack_shield = class({})
function modifier_attack_shield:IsHidden() return false end
function modifier_attack_shield:IsPurgable() return false end

function modifier_attack_shield:GetTexture() return "item_crimson_guard" end



function modifier_attack_shield:OnCreated(table)

self.max_shield = 200*self:GetParent():GetUpgradeStack("modifier_up_attackblock")

if not IsServer() then return end

self:SetStackCount(self.max_shield)
self:GetParent():EmitSound("Item.CrimsonGuard.Cast")
    
local shield_size = 85
self.crimson_guard_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_abaddon/abaddon_aphotic_shield_2.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
local common_vector = Vector(shield_size,0,shield_size)
ParticleManager:SetParticleControl(self.crimson_guard_pfx, 1, common_vector)
ParticleManager:SetParticleControl(self.crimson_guard_pfx, 2, common_vector)
ParticleManager:SetParticleControl(self.crimson_guard_pfx, 4, common_vector)
ParticleManager:SetParticleControl(self.crimson_guard_pfx, 5, Vector(shield_size,0,0))
ParticleManager:SetParticleControlEnt(self.crimson_guard_pfx, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)

self:AddParticle(self.crimson_guard_pfx,false, false, -1, false, false)

end



function modifier_attack_shield:DeclareFunctions()
return 
{
  MODIFIER_PROPERTY_INCOMING_PHYSICAL_DAMAGE_CONSTANT,
  MODIFIER_PROPERTY_TOOLTIP,
}
end

function modifier_attack_shield:OnTooltip() return self:GetStackCount() end



function modifier_attack_shield:GetModifierIncomingPhysicalDamageConstant(params)

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



