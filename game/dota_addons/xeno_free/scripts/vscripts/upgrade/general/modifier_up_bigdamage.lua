LinkLuaModifier("modifier_up_bigdamage_heal", "upgrade/general/modifier_up_bigdamage.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_up_bigdamage_heal_cd", "upgrade/general/modifier_up_bigdamage.lua", LUA_MODIFIER_MOTION_NONE)

modifier_up_bigdamage = class({})


function modifier_up_bigdamage:IsHidden() return true end
function modifier_up_bigdamage:IsPurgable() return false end




function modifier_up_bigdamage:DeclareFunctions()
    return {

        MODIFIER_EVENT_ON_TAKEDAMAGE

    } end



function modifier_up_bigdamage:OnTakeDamage( params )
if not IsServer() then return end
if (self:GetParent() ~= params.unit)  then return end
if self:GetParent():HasModifier("modifier_death") then return end
if self:GetParent():GetHealthPercent() > 30 then return end
if self:GetParent():HasModifier('modifier_up_bigdamage_heal_cd') then return end
  
self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_up_bigdamage_heal", {duration = 3})
self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_up_bigdamage_heal_cd", {duration = 40})


end
 

function modifier_up_bigdamage:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
end


function modifier_up_bigdamage:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(self:GetStackCount()+1)
end


function modifier_up_bigdamage:RemoveOnDeath() return false end
  

modifier_up_bigdamage_heal = class({})

function modifier_up_bigdamage_heal:GetTexture() return "tinker_defense_matrix" end

function modifier_up_bigdamage_heal:IsPurgable() return false end

function modifier_up_bigdamage_heal:IsHidden() return false end



function modifier_up_bigdamage_heal:OnCreated(table)
self.damage =  (-10*self:GetParent():GetUpgradeStack("modifier_up_bigdamage"))
self.heal = (5 + 5*self:GetParent():GetUpgradeStack("modifier_up_bigdamage"))/self:GetRemainingTime()

if not IsServer() then return end

self:GetParent():EmitSound("Hero_Tinker.DefensiveMatrix.Cast")
self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_tinker/tinker_defense_matrix.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self:GetParent())
local position = self:GetParent():GetAbsOrigin()
ParticleManager:SetParticleControlEnt(self.particle, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", position, true)
self:AddParticle(self.particle, false, false, -1, false, false)

end

function modifier_up_bigdamage_heal:DeclareFunctions()
return
{

  MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
  MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
}
end
 

function modifier_up_bigdamage_heal:GetModifierHealthRegenPercentage() return 
self.heal
end


function modifier_up_bigdamage_heal:GetModifierIncomingDamage_Percentage() return
self.damage
end




modifier_up_bigdamage_heal_cd = class({})

function modifier_up_bigdamage_heal_cd:IsHidden() return false end
function modifier_up_bigdamage_heal_cd:IsDebuff() return true end
function modifier_up_bigdamage_heal_cd:RemoveOnDeath() return false end
function modifier_up_bigdamage_heal_cd:GetTexture() return "tinker_defense_matrix" end
function modifier_up_bigdamage_heal_cd:IsPurgable() return false end
function modifier_up_bigdamage_heal_cd:OnCreated(table)
if not IsServer() then return end
self.RemoveForDuel = true
end
