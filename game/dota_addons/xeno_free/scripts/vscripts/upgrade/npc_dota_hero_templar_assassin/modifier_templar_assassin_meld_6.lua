

modifier_templar_assassin_meld_6 = class({})


function modifier_templar_assassin_meld_6:IsHidden() return true end
function modifier_templar_assassin_meld_6:IsPurgable() return false end



function modifier_templar_assassin_meld_6:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)

local ability = self:GetParent():FindAbilityByName("templar_assassin_meld_custom")
local mod = self:GetParent():FindModifierByName("modifier_templar_assassin_meld_custom_kills")

if not ability then return end
if not mod then return end

if mod:GetStackCount() >= ability.kills_max then 

    local particle_peffect = ParticleManager:CreateParticle("particles/lc_odd_proc_.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
    ParticleManager:SetParticleControl(particle_peffect, 0, self:GetParent():GetAbsOrigin())
    ParticleManager:SetParticleControl(particle_peffect, 2, self:GetParent():GetAbsOrigin())
    ParticleManager:ReleaseParticleIndex(particle_peffect)
    self:GetCaster():EmitSound("BS.Thirst_legendary_active")

    ability:ToggleAutoCast()
end


end


function modifier_templar_assassin_meld_6:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_templar_assassin_meld_6:RemoveOnDeath() return false end