LinkLuaModifier( "modifier_up_teamfight_buff", "upgrade/general/modifier_up_teamfight", LUA_MODIFIER_MOTION_NONE )

modifier_up_teamfight = class({})


function modifier_up_teamfight:IsHidden() 
	return true
end

function modifier_up_teamfight:IsPurgable() return false end



function modifier_up_teamfight:RemoveOnDeath() return false end


function modifier_up_teamfight:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)

self:StartIntervalThink(0.1)
end


function modifier_up_teamfight:OnIntervalThink()
if not IsServer() then return end
if not self:GetParent():IsAlive() then return end

local units = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, 800, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS  + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES  + DOTA_UNIT_TARGET_FLAG_INVULNERABLE  + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD , FIND_CLOSEST, false)
 
local count = 0

for _,unit in pairs(units) do 
	if not unit:HasModifier("modifier_monkey_king_wukongs_command_custom_soldier") and not unit:IsTempestDouble() then 
		count = count  + 1
	end
end


if count < 2 and self:GetParent():HasModifier("modifier_up_teamfight_buff") then 
	self:GetParent():RemoveModifierByName("modifier_up_teamfight_buff")
end

if count >= 2 and not self:GetParent():HasModifier("modifier_up_teamfight_buff") then 
	self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_up_teamfight_buff", {})
end


end


function modifier_up_teamfight:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
end



modifier_up_teamfight_buff = class({})
function modifier_up_teamfight_buff:IsHidden() return false end
function modifier_up_teamfight_buff:IsPurgable() return false end
function modifier_up_teamfight_buff:GetTexture() return "buffs/Martyr" end


function modifier_up_teamfight_buff:OnCreated(table)

self.damage = {10, 15, 20}
self.incoming = {-10, -15, -20}

end



function modifier_up_teamfight_buff:GetEffectName()
return "particles/units/heroes/hero_pudge/pudge_fleshheap_block_shield_model.vpcf"
end
function modifier_up_teamfight_buff:GetEffectAttachType()
return PATTACH_ABSORIGIN_FOLLOW
end


function modifier_up_teamfight_buff:GetModifierIncomingDamage_Percentage()
return self.incoming[self:GetParent():GetUpgradeStack("modifier_up_teamfight")]
end

function modifier_up_teamfight_buff:GetModifierTotalDamageOutgoing_Percentage()
return self.damage[self:GetParent():GetUpgradeStack("modifier_up_teamfight")]
end

function modifier_up_teamfight_buff:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
  
}
end