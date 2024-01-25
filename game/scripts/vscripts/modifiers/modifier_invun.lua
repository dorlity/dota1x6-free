

modifier_invun = class({})


function modifier_invun:IsHidden() return true end
function modifier_invun:IsPurgable() return false end



function modifier_invun:CheckState()

if self.owner and duel_data[self.owner.duel_data]
    and (duel_data[self.owner.duel_data].rounds > 0)
    and duel_data[self.owner.duel_data].finished == 0 then 
    return
    {
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_STUNNED] = true,
    }
else 
    return 
    {
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
    }
    end

end 


function modifier_invun:RemoveOnDeath() return false end



function modifier_invun:OnCreated(table)
if not IsServer() then return end

self.owner = players[self:GetParent():GetTeamNumber()]

--self:GetParent():SetDayTimeVisionRange(0)
--self:GetParent():SetNightTimeVisionRange(0)
end