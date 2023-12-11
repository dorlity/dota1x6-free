LinkLuaModifier("modifier_patrol_armor", "abilities/patrol_armor", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_patrol_armor_buff", "abilities/patrol_armor", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_patrol_armor_death", "abilities/patrol_armor", LUA_MODIFIER_MOTION_NONE)




patrol_armor = class({})

function patrol_armor:GetIntrinsicModifierName() return "modifier_patrol_armor" end

modifier_patrol_armor = class({})
function modifier_patrol_armor:IsPurgable() return false end
function modifier_patrol_armor:IsHidden() return true end


function modifier_patrol_armor:OnCreated(table)
if not IsServer() then return end
	local ability = self:GetAbility()
	if not IsValidEntity(ability) then return end

	self.armor = ability:GetSpecialValueFor("armor_first")

	if GameRules:GetDOTATime(false, false) < patrol_second_tier then 
		--self.armor = ability:GetSpecialValueFor("armor_first")
	end

	self.radius = ability:GetSpecialValueFor("radius")

	if not IsServer() then return end
	self:StartIntervalThink(0.1)
end


function modifier_patrol_armor:OnIntervalThink()
	if not IsServer() then return end
	local parent = self:GetParent()
	if not IsValidEntity(parent) then return end

	local heroes = FindUnitsInRadius(parent:GetTeamNumber(), parent:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO, 0, false)

	local count = 0
	for _,hero in pairs(heroes) do 
		if not hero:HasModifier("modifier_monkey_king_wukongs_command_custom_soldier") and not hero:IsTempestDouble() then 
			count = count + 1
		end
	end


	if count > 1 and not self:GetParent():HasModifier("modifier_patrol_armor_buff") then 
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_patrol_armor_buff", {})
	end

	if count <= 1 and self:GetParent():HasModifier("modifier_patrol_armor_buff") then
		self:GetParent():RemoveModifierByName("modifier_patrol_armor_buff") 
	end

end


function modifier_patrol_armor:CheckState()
if not IsServer() then return end
if true then return end
if not self:GetParent():HasModifier("modifier_patrol_armor_buff") then return end
if GameRules:GetDOTATime(false, false) > patrol_second_tier then 
return
{
	[MODIFIER_STATE_INVULNERABLE] = true

}
end
return
end


function modifier_patrol_armor:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_EVENT_ON_DEATH
	}
end


function modifier_patrol_armor:OnDeath(params)
if not IsServer() then return end
if not  my_game:IsPatrol(params.unit:GetUnitName()) then return end
if (self:GetParent():GetAbsOrigin() - params.unit:GetAbsOrigin()):Length2D() > self.radius then return end
if not params.attacker then return end

self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_patrol_armor_death", {duration = self:GetAbility():GetSpecialValueFor("death_duration")})


end


function modifier_patrol_armor:GetModifierIncomingDamage_Percentage(params)
if not IsServer() then return end

local hero = players[params.attacker:GetTeamNumber()]

if hero and (hero:GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D() > self.radius then
	return -200
end

if towers[params.attacker:GetTeamNumber()] then 
	my_game:ActivatePushReduce(params.attacker:GetTeamNumber(), nil)
end



if self:GetParent():HasModifier("modifier_patrol_armor_buff") then 
	return self.armor
end

end





modifier_patrol_armor_death = class({})

function modifier_patrol_armor_death:IsHidden() return true end
function modifier_patrol_armor_death:IsPurgable() return false end
function modifier_patrol_armor_death:OnCreated(table)

self.incoming = self:GetAbility():GetSpecialValueFor("death_incoming")
if not IsServer() then return end
self.particle = ParticleManager:CreateParticle("particles/glyph_damage.vpcf" , PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControl(self.particle, 0, self:GetParent():GetAbsOrigin())
ParticleManager:SetParticleControl(self.particle, 1, Vector(120,1,1))
self:AddParticle(self.particle, false, false, -1, false, false)
end

function modifier_patrol_armor_death:DeclareFunctions()
return
{
	--MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
	--MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
	--MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
	MODIFIER_PROPERTY_MIN_HEALTH
}
end


function modifier_patrol_armor_death:GetAbsoluteNoDamagePhysical()
return 1
end

function modifier_patrol_armor_death:GetAbsoluteNoDamageMagical()
return 1
end
function modifier_patrol_armor_death:GetAbsoluteNoDamagePure()
return 1
end



function modifier_patrol_armor_death:GetMinHealth()
if self:GetParent():HasModifier("modifier_death") then return end
return 1
end



modifier_patrol_armor_buff = class({})

function modifier_patrol_armor_buff:IsHidden() return false end
function modifier_patrol_armor_buff:IsPurgable() return false end
function modifier_patrol_armor_buff:GetEffectName()
	return "particles/items2_fx/medallion_of_courage_friend.vpcf"
end
function modifier_patrol_armor_buff:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

