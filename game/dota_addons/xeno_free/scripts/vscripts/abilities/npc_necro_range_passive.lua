LinkLuaModifier("modifier_npc_necro_range_passive", "abilities/npc_necro_range_passive", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_npc_necro_range_slow", "abilities/npc_necro_range_passive", LUA_MODIFIER_MOTION_NONE)

npc_necro_range_passive = class({})

function npc_necro_range_passive:GetIntrinsicModifierName() 
return "modifier_npc_necro_range_passive"
end

modifier_npc_necro_range_passive = class({})

function modifier_npc_necro_range_passive:IsHidden() return true end
function modifier_npc_necro_range_passive:IsPurgable() return false end

function modifier_npc_necro_range_passive:OnCreated(table)

self.mana = self:GetAbility():GetSpecialValueFor("mana")/100
self.slow_duration = self:GetAbility():GetSpecialValueFor("slow_duration")
end



function modifier_npc_necro_range_passive:CheckState()
return
{
    [MODIFIER_STATE_CANNOT_MISS] = true
}
end

function modifier_npc_necro_range_passive:DeclareFunctions()
return
{
    MODIFIER_EVENT_ON_ATTACK_LANDED
}

end

function modifier_npc_necro_range_passive:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end
if params.target:IsBuilding() or params.target:IsMagicImmune() then return end

--params.target:EmitSound("n_creep_SatyrSoulstealer.ManaBurn")

local effect = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_manaburn.vpcf", PATTACH_ABSORIGIN_FOLLOW, params.target)
params.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_npc_necro_range_slow", {duration = self.slow_duration*(1 - params.target:GetStatusResistance())})
params.target:SpendMana(self.mana*params.target:GetMaxMana() , self:GetAbility())


end






modifier_npc_necro_range_slow = class({})

function modifier_npc_necro_range_slow:IsHidden() return false end

function modifier_npc_necro_range_slow:IsPurgable() return true end

function modifier_npc_necro_range_slow:OnCreated(table)
   self.slow = self:GetAbility():GetSpecialValueFor("slow")
    if not IsServer() then return end
end


function modifier_npc_necro_range_slow:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    }
 end



function modifier_npc_necro_range_slow:GetModifierMoveSpeedBonus_Percentage() return self.slow  end
