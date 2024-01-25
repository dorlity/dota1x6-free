LinkLuaModifier("modifier_up_slow_debuff", "upgrade/general/modifier_up_slow", LUA_MODIFIER_MOTION_NONE)

modifier_up_slow = class({})



function modifier_up_slow:IsHidden() return true end
function modifier_up_slow:IsPurgable() return false end


function modifier_up_slow:DeclareFunctions()
    return {

        MODIFIER_EVENT_ON_ATTACK_LANDED

    } end



function modifier_up_slow:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_up_slow:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end



function modifier_up_slow:OnAttackLanded( param )
if self:GetParent() ~= param.attacker then return end
if param.target:IsBuilding() then return end
local random = RollPseudoRandomPercentage(25,100,self:GetParent())
if not random  then return end 

param.target:AddNewModifier(param.attacker, self:GetAbility(), "modifier_up_slow_debuff", { duration = 4*(1-param.target:GetStatusResistance()) })
         

end



function modifier_up_slow:RemoveOnDeath() return false end

modifier_up_slow_debuff = class({})

function modifier_up_slow_debuff:IsPurgable() return true end


function modifier_up_slow_debuff:OnCreated(table)
if not IsServer() then return end
  
self:GetParent():EmitSound("DOTA_Item.Maim")

end


function modifier_up_slow_debuff:GetEffectName()
	return "particles/items2_fx/sange_maim.vpcf"
end


function modifier_up_slow_debuff:GetEffectAttachType()
return PATTACH_ABSORIGIN_FOLLOW
end


function modifier_up_slow_debuff:DeclareFunctions()
return 
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
end
 

function modifier_up_slow_debuff:GetTexture() return "buffs/Penta-Edged_Sword" end

function modifier_up_slow_debuff:GetModifierAttackSpeedBonus_Constant() 
return -15 + -15*self:GetCaster():GetUpgradeStack("modifier_up_slow")
end



function modifier_up_slow_debuff:GetModifierMoveSpeedBonus_Percentage() return 
-10 + -10*self:GetCaster():GetUpgradeStack("modifier_up_slow")
end


