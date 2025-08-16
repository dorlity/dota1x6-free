LinkLuaModifier( "modifier_arc_warden_ancients_ally_custom", "abilities/arc_warden/arc_warden_innate_custom", LUA_MODIFIER_MOTION_NONE )


arc_warden_innate_custom = class({})


function arc_warden_innate_custom:GetIntrinsicModifierName()
return "modifier_arc_warden_ancients_ally_custom"
end


function arc_warden_innate_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end
PrecacheResource( "soundfile", "soundevents/npc_dota_hero_arc_warden.vsndevts", context )
dota1x6:PrecacheShopItems("npc_dota_hero_arc_warden", context)
end


modifier_arc_warden_ancients_ally_custom = class(mod_hidden)
function modifier_arc_warden_ancients_ally_custom:OnCreated(table)
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.attack_speed = self.ability:GetSpecialValueFor("attack_speed")
self.spell_damage = self.ability:GetSpecialValueFor("spell_damage")
self.shard_bonus = self.ability:GetSpecialValueFor("shard_bonus")/100

if not IsServer() then return end 

self:SetStackCount(2)
self:StartIntervalThink(0.1)
end

function modifier_arc_warden_ancients_ally_custom:OnIntervalThink()
if not IsServer() then return end 
if self:GetStackCount() ~= 2 then 
	self:StartIntervalThink(-1)
	return
end

local base = dota1x6:GetBase(self.parent:GetTeamNumber())
if IsRadiant(tostring(base)) then 
	self:SetStackCount(0)
end

if IsDire(tostring(base)) then 
	self:SetStackCount(1)
end

end


function modifier_arc_warden_ancients_ally_custom:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
  MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
}
end


function modifier_arc_warden_ancients_ally_custom:GetModifierSpellAmplify_Percentage()
if self:GetStackCount() ~= 0 then return end
return self.spell_damage * (1 + self.shard_bonus*self.parent:GetUpgradeStack("modifier_arc_warden_tempest_double_custom_buff"))
end

function modifier_arc_warden_ancients_ally_custom:GetModifierAttackSpeedBonus_Constant()
if self:GetStackCount() ~= 1 then return end
return self.attack_speed * (1 + self.shard_bonus*self.parent:GetUpgradeStack("modifier_arc_warden_tempest_double_custom_buff"))
end