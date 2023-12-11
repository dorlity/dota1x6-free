

modifier_up_aoe_damage = class({})


function modifier_up_aoe_damage:IsHidden() return true end
function modifier_up_aoe_damage:IsPurgable() return false end
function modifier_up_aoe_damage:RemoveOnDeath() return false end

function modifier_up_aoe_damage:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)

self.parent = self:GetParent()

self.ability = self.parent:AddAbility("generic_aoe_damage")
self.ability:SetLevel(1)

self:StartIntervalThink(1)
end

function modifier_up_aoe_damage:OnRefresh(table)
if not IsServer() then return end
self:IncrementStackCount()
end



function modifier_up_aoe_damage:OnIntervalThink()
if not IsServer() then return end
if not self.parent:IsAlive() then return end 

local units = self.parent:FindTargets(500)
 
local k = 1
if self.parent:HasModifier("modifier_item_alchemist_gold_octarine_active") then 
  k = k + 0.4
end

if self.parent:HasModifier("modifier_up_graypoints") then 
  k = k + 0.3
end 

local damage = self:GetStackCount()*10*k

for _,unit in pairs(units) do 
  ApplyDamage({victim = unit, damage = damage, attacker = self.parent, ability = self.ability, damage_type = DAMAGE_TYPE_MAGICAL})
end 

end 

