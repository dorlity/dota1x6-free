LinkLuaModifier("modifier_terrorblade_demon_zeal_custom", "abilities/terrorblade/terrorblade_demon_zeal_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_terrorblade_demon_zeal_custom_buff", "abilities/terrorblade/terrorblade_demon_zeal_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_terrorblade_demon_zeal_custom_tracker", "abilities/terrorblade/terrorblade_demon_zeal_custom", LUA_MODIFIER_MOTION_NONE)



terrorblade_demon_zeal_custom = class({})


function terrorblade_demon_zeal_custom:GetIntrinsicModifierName()
return "modifier_terrorblade_demon_zeal_custom_tracker"
end

function terrorblade_demon_zeal_custom:GetHealthCost(level)
return self:GetSpecialValueFor("health_cost_pct")*self:GetCaster():GetHealth()/100
end


function terrorblade_demon_zeal_custom:OnAbilityPhaseStart()

return not self:GetCaster():HasModifier("modifier_custom_terrorblade_metamorphosis") or self:GetCaster():HasModifier("modifier_terror_meta_legendary")
end


function terrorblade_demon_zeal_custom:OnSpellStart()



self:GetCaster():EmitSound("Hero_Terrorblade.DemonZeal.Cast")

self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_terrorblade_demon_zeal_custom", {duration = self:GetSpecialValueFor("duration")})
end





modifier_terrorblade_demon_zeal_custom = class({})

function modifier_terrorblade_demon_zeal_custom:IsHidden() return false end
function modifier_terrorblade_demon_zeal_custom:IsPurgable() return false end

function modifier_terrorblade_demon_zeal_custom:OnCreated(table)

self.radius = self:GetAbility():GetSpecialValueFor("radius")
end



function modifier_terrorblade_demon_zeal_custom:GetAuraEntityReject(target)
if (self:GetCaster() == target or (target:IsIllusion() and target.owner and target.owner == self:GetCaster()))
and (not target:HasModifier("modifier_custom_terrorblade_metamorphosis") or self:GetCaster():HasModifier("modifier_terror_meta_legendary")) then 
	return false
end

return true
end

function modifier_terrorblade_demon_zeal_custom:GetAuraDuration()
	return 0.1
end


function modifier_terrorblade_demon_zeal_custom:GetAuraRadius()
return self.radius
end

function modifier_terrorblade_demon_zeal_custom:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE
end



function modifier_terrorblade_demon_zeal_custom:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_terrorblade_demon_zeal_custom:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO
end


function modifier_terrorblade_demon_zeal_custom:GetModifierAura()
	return "modifier_terrorblade_demon_zeal_custom_buff"
end

function modifier_terrorblade_demon_zeal_custom:IsAura()
	return true
end


modifier_terrorblade_demon_zeal_custom_buff = class({})
function modifier_terrorblade_demon_zeal_custom_buff:IsHidden() return false end
function modifier_terrorblade_demon_zeal_custom_buff:IsPurgable() return false end
function modifier_terrorblade_demon_zeal_custom_buff:OnCreated()
self.move = self:GetAbility():GetSpecialValueFor("berserk_bonus_attack_speed")
self.speed = self:GetAbility():GetSpecialValueFor("berserk_bonus_movement_speed")

self.reflection_k = self:GetAbility():GetSpecialValueFor("reflection_k")

if not IsServer() then return end
self.pfx = ParticleManager:CreateParticle("particles/models/heroes/terrorblade/demon_zeal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControlEnt(self.pfx, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(self.pfx, 2, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
self:AddParticle(self.pfx, false, false, -1, false, false)


end

function modifier_terrorblade_demon_zeal_custom_buff:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
end


function modifier_terrorblade_demon_zeal_custom_buff:GetModifierMoveSpeedBonus_Constant()

local k = 1 
if self:GetParent():HasModifier("modifier_custom_terrorblade_reflection_unit") then 
	k = self.reflection_k
end


return self.move / k
end


function modifier_terrorblade_demon_zeal_custom_buff:GetModifierAttackSpeedBonus_Constant()

local k = 1 
if self:GetParent():HasModifier("modifier_custom_terrorblade_reflection_unit") then 
	k = self.reflection_k
end

return self.speed / k
end


modifier_terrorblade_demon_zeal_custom_tracker = class({})
function modifier_terrorblade_demon_zeal_custom_tracker:IsHidden() return true end
function modifier_terrorblade_demon_zeal_custom_tracker:IsPurgable() return false end
function modifier_terrorblade_demon_zeal_custom_tracker:OnCreated()
if not IsServer() then return end 
if self:GetParent():IsIllusion() then return end 


self:StartIntervalThink(1)
end

function modifier_terrorblade_demon_zeal_custom_tracker:OnIntervalThink()
if not IsServer() then return end 
if not self:GetParent():HasShard() then return end 


if self:GetCaster():HasModifier("modifier_custom_terrorblade_metamorphosis") and not  self:GetCaster():HasModifier("modifier_terror_meta_legendary") then 
	self:GetParent():RemoveModifierByName("modifier_terrorblade_demon_zeal_custom")

	self:GetAbility():SetActivated(false)
else 
	self:GetAbility():SetActivated(true)
end

self:StartIntervalThink(0.1)
end 