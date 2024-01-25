LinkLuaModifier( "modifier_arc_warden_magnetic_field_custom_thinker_speed", "abilities/arc_warden/arc_warden_magnetic_field_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_arc_warden_magnetic_field_custom_speed", "abilities/arc_warden/arc_warden_magnetic_field_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_arc_warden_magnetic_field_custom_thinker_evasion", "abilities/arc_warden/arc_warden_magnetic_field_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_arc_warden_magnetic_field_custom_evasion", "abilities/arc_warden/arc_warden_magnetic_field_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_arc_warden_magnetic_field_custom_thinker_damage", "abilities/arc_warden/arc_warden_magnetic_field_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_arc_warden_magnetic_field_custom_damage", "abilities/arc_warden/arc_warden_magnetic_field_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_arc_warden_magnetic_field_custom_tracker", "abilities/arc_warden/arc_warden_magnetic_field_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_arc_warden_magnetic_field_custom_shard_knock", "abilities/arc_warden/arc_warden_magnetic_field_custom", LUA_MODIFIER_MOTION_HORIZONTAL )
LinkLuaModifier( "modifier_arc_warden_magnetic_field_custom_shard_slow", "abilities/arc_warden/arc_warden_magnetic_field_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_arc_warden_magnetic_field_custom_shard_cd", "abilities/arc_warden/arc_warden_magnetic_field_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_arc_warden_magnetic_field_custom_legendary", "abilities/arc_warden/arc_warden_magnetic_field_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_arc_warden_magnetic_field_custom_legendary_illusion", "abilities/arc_warden/arc_warden_magnetic_field_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_arc_warden_magnetic_field_custom_absorb_cd", "abilities/arc_warden/arc_warden_magnetic_field_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_arc_warden_magnetic_field_custom_stun", "abilities/arc_warden/arc_warden_magnetic_field_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_arc_warden_magnetic_field_custom_damage_stack", "abilities/arc_warden/arc_warden_magnetic_field_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_arc_warden_magnetic_field_custom_damage_attack", "abilities/arc_warden/arc_warden_magnetic_field_custom", LUA_MODIFIER_MOTION_NONE )




arc_warden_magnetic_field_custom = class({})



function arc_warden_magnetic_field_custom:Precache(context)

PrecacheResource( "particle", "particles/arc_warden/arc_warden_magnetic.vpcf", context )
PrecacheResource( "particle", "particles/arc_warden/arc_warden_magnetic_tempest.vpcf", context )
PrecacheResource( "particle", "particles/arc_warden/arc_warden_magnetic_shard.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_terrorblade/terrorblade_reflection_slow.vpcf", context )
PrecacheResource( "particle", "particles/arc_warden/field_attack.vpcf", context )
PrecacheResource( "particle", "particles/arc_warden/field_blink_start.vpcf", context )
PrecacheResource( "particle", "particles/arc_warden/field_attack.vpcf", context )
PrecacheResource( "particle", "particles/arc_warden/spark_heall.vpcf", context )
PrecacheResource( "particle", "particles/puck_heal.vpcf", context )
PrecacheResource( "particle", "particles/arc_warden/field_attack_end.vpcf", context )

end

function arc_warden_magnetic_field_custom:GetBehavior()
  if self:GetCaster():HasModifier("modifier_arc_warden_field_7") then
    return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING
  end
 return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AOE + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING
end


function arc_warden_magnetic_field_custom:GetCastPoint(iLevel)
if self:GetCaster():HasModifier('modifier_arc_warden_field_6') then 
	return self.BaseClass.GetCastPoint(self) + self:GetCaster():GetTalentValue("modifier_arc_warden_field_6", "cast")
end

return self.BaseClass.GetCastPoint(self)
end





function arc_warden_magnetic_field_custom:GetCooldown(level)
local bonus = 0

if self:GetCaster():HasModifier("modifier_arc_warden_field_3") then 
	bonus = self:GetCaster():GetTalentValue("modifier_arc_warden_field_3", "cd")
end 

	return self.BaseClass.GetCooldown(self, level)  + bonus
end




function arc_warden_magnetic_field_custom:GetAbilityTextureName()
	if self:GetCaster():HasModifier("modifier_arc_warden_tempest_double") then
		return 'arc_warden_magnetic_field_tempest'
	else
		return "arc_warden_magnetic_field"
	end
end


function arc_warden_magnetic_field_custom:GetIntrinsicModifierName()
return "modifier_arc_warden_magnetic_field_custom_tracker"
end 

function arc_warden_magnetic_field_custom:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function arc_warden_magnetic_field_custom:OnSpellStart()
self:GetCaster():EmitSound("Hero_ArcWarden.MagneticField.Cast")

local cast_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_arc_warden/arc_warden_magnetic_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
ParticleManager:ReleaseParticleIndex(cast_particle)

local duration = self:GetSpecialValueFor("duration")

local radius	= self:GetSpecialValueFor("radius")

if self:GetCaster():HasModifier("modifier_arc_warden_field_3") then 
	duration = duration + self:GetCaster():GetTalentValue("modifier_arc_warden_field_3", "duration")
end 

if self:GetCaster():HasModifier("modifier_arc_warden_field_5") then 

	local point = self:GetCursorPosition()
	if self:GetCaster():HasModifier("modifier_arc_warden_field_7") then 
		point = self:GetCaster():GetAbsOrigin()
	end 

	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_brewmaster/brewmaster_dispel_magic.vpcf", PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(particle, 0, point)
	ParticleManager:ReleaseParticleIndex(particle)

	EmitSoundOnLocationWithCaster(point, "Arc.Field_purge", self:GetCaster())

	local units = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), point, nil, radius, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

	for _,unit in pairs(units) do 
		if unit:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then 
			unit:EmitSound("Arc.Field_stun")
			unit:AddNewModifier(self:GetCaster(), self, "modifier_arc_warden_magnetic_field_custom_stun", {duration = (1 - unit:GetStatusResistance())*self:GetCaster():GetTalentValue("modifier_arc_warden_field_5", "stun")})
			unit:Purge(true, false, false, false, true)
		else 
			unit:Purge(false, true, false, true, false)
		end 
	end 

end 


local name = nil

if self:GetCaster():HasModifier("modifier_arc_warden_field_7") then 

	radius = self:GetCaster():GetTalentValue("modifier_arc_warden_field_7", "radius")

	if self:GetCaster():HasModifier("modifier_arc_warden_tempest_double") and not self:GetCaster():HasShard() then
		name = "modifier_arc_warden_magnetic_field_custom_damage"

		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_arc_warden_magnetic_field_custom_thinker_damage", { duration = duration } )
	else 

		name = "modifier_arc_warden_magnetic_field_custom_speed"
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_arc_warden_magnetic_field_custom_thinker_speed", { duration = duration } )
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_arc_warden_magnetic_field_custom_thinker_evasion", { duration = duration } )
	end 

else 

	if self:GetCaster():HasModifier("modifier_arc_warden_tempest_double") and not self:GetCaster():HasShard() then
		name = "modifier_arc_warden_magnetic_field_custom_damage"
		CreateModifierThinker(self:GetCaster(), self, "modifier_arc_warden_magnetic_field_custom_thinker_damage", { duration = duration }, self:GetCursorPosition(), self:GetCaster():GetTeamNumber(), false)
	else 
		name = "modifier_arc_warden_magnetic_field_custom_speed"
		CreateModifierThinker(self:GetCaster(), self, "modifier_arc_warden_magnetic_field_custom_thinker_speed", { duration = duration }, self:GetCursorPosition(), self:GetCaster():GetTeamNumber(), false)
		CreateModifierThinker(self:GetCaster(), self, "modifier_arc_warden_magnetic_field_custom_thinker_evasion", { duration = duration }, self:GetCursorPosition(), self:GetCaster():GetTeamNumber(), false)
	end 

end 


if self:GetCaster():HasModifier("modifier_arc_warden_field_4") and name ~= nil then 
	self:GetCaster():RemoveModifierByName("modifier_arc_warden_magnetic_field_custom_damage_attack")
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_arc_warden_magnetic_field_custom_damage_stack", { name = name})
end 


end










modifier_arc_warden_magnetic_field_custom_thinker_speed = class({})
function modifier_arc_warden_magnetic_field_custom_thinker_speed:IsPurgable() return false end
function modifier_arc_warden_magnetic_field_custom_thinker_speed:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_arc_warden_magnetic_field_custom_thinker_speed:IsHidden() return not self:GetParent():IsHero()  end

function modifier_arc_warden_magnetic_field_custom_thinker_speed:OnCreated()
if not IsServer() then return end

self.RemoveForDuel = true

if self:GetParent():HasAbility("arc_warden_magnetic_field_custom_legendary") and self:GetParent():FindAbilityByName("arc_warden_magnetic_field_custom_legendary"):IsHidden() then 
	
	self:GetParent():SwapAbilities(self:GetAbility():GetName(), "arc_warden_magnetic_field_custom_legendary", false, true)
end 

self.radius	= self:GetAbility():GetSpecialValueFor("radius")

if self:GetParent():IsHero() then 
	self.radius = self:GetCaster():GetTalentValue("modifier_arc_warden_field_7", "radius")
end 

self:GetParent():EmitSound("Hero_ArcWarden.MagneticField")

local part = "particles/arc_warden/arc_warden_magnetic.vpcf"

if self:GetCaster():HasShard() then 
	part = "particles/arc_warden/arc_warden_magnetic_shard.vpcf"
end 

self.magnetic_particle = ParticleManager:CreateParticle(part, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControl(self.magnetic_particle, 1, Vector(self.radius, 1, 1))
self:AddParticle(self.magnetic_particle, false, false, 1, false, false)

if not self:GetCaster():HasShard() then return end

self:OnIntervalThink()
self:StartIntervalThink(0.1)
end


function modifier_arc_warden_magnetic_field_custom_thinker_speed:OnDestroy()
if not IsServer() then return end

if self:GetParent():HasAbility("arc_warden_magnetic_field_custom_legendary") and not self:GetParent():FindAbilityByName("arc_warden_magnetic_field_custom_legendary"):IsHidden() 
	and not self:GetParent():HasModifier("modifier_arc_warden_magnetic_field_custom_thinker_damage") then 

	self:GetParent():SwapAbilities(self:GetAbility():GetName(), "arc_warden_magnetic_field_custom_legendary", true, false)
end 


self:GetParent():StopSound("Hero_ArcWarden.MagneticField")
end


function modifier_arc_warden_magnetic_field_custom_thinker_speed:IsAura()						return true end
function modifier_arc_warden_magnetic_field_custom_thinker_speed:IsAuraActiveOnDeath() 			return false end

function modifier_arc_warden_magnetic_field_custom_thinker_speed:GetAuraDuration()				return 0.1 end
function modifier_arc_warden_magnetic_field_custom_thinker_speed:GetAuraRadius()				return self.radius end
function modifier_arc_warden_magnetic_field_custom_thinker_speed:GetAuraSearchFlags()			return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_arc_warden_magnetic_field_custom_thinker_speed:GetAuraSearchTeam()			return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_arc_warden_magnetic_field_custom_thinker_speed:GetAuraSearchType()			return DOTA_UNIT_TARGET_HERO end
function modifier_arc_warden_magnetic_field_custom_thinker_speed:GetModifierAura()				return "modifier_arc_warden_magnetic_field_custom_speed" end


function modifier_arc_warden_magnetic_field_custom_thinker_speed:OnIntervalThink()
if not IsServer() then return end 
if self:GetParent():HasModifier("modifier_arc_warden_magnetic_field_custom_legendary") then return end

local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

for _,enemy in pairs(enemies) do 

	if not enemy:HasModifier("modifier_arc_warden_magnetic_field_custom_shard_knock") and not enemy:HasModifier("modifier_arc_warden_magnetic_field_custom_shard_cd")
		and not enemy:IsDebuffImmune() and not enemy:HasModifier("modifier_arc_warden_magnetic_field_custom_stun") then

		local direction = enemy:GetOrigin()-self:GetParent():GetOrigin()
		direction.z = 0
		direction = direction:Normalized()

		if enemy:GetAbsOrigin() == self:GetParent():GetAbsOrigin() then 
			direction = enemy:GetForwardVector()
		end 

		local point = self:GetParent():GetAbsOrigin() + direction*(self.radius + self:GetAbility():GetSpecialValueFor("shard_distance"))

		local speed = self:GetAbility():GetSpecialValueFor("shard_speed")
		local distance = (enemy:GetAbsOrigin() - point):Length2D()

		local knockbackProperties =
	  	{
		  x = point.x, 
		  y = point.y,
	      duration = distance/speed,
	  	}
	  	enemy:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_arc_warden_magnetic_field_custom_shard_knock", knockbackProperties )
	  	enemy:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_arc_warden_magnetic_field_custom_shard_slow", {duration = distance/speed + self:GetAbility():GetSpecialValueFor("shard_duration")})


		local attack_particle = ParticleManager:CreateParticle("particles/duel_stun.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy)
		ParticleManager:SetParticleControlEnt(attack_particle, 1, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(attack_particle, 0, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(attack_particle, 60, Vector(31,82,167))
		ParticleManager:SetParticleControl(attack_particle, 61, Vector(1,0,0))

		enemy:EmitSound("Arc.Field_shard")

	  	enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_arc_warden_magnetic_field_custom_shard_cd", {duration = self:GetAbility():GetSpecialValueFor("shard_cd")})
	end

end 

end 






modifier_arc_warden_magnetic_field_custom_thinker_damage = class({})

function modifier_arc_warden_magnetic_field_custom_thinker_damage:IsPurgable() return false end
function modifier_arc_warden_magnetic_field_custom_thinker_damage:IsHidden() return not self:GetParent():IsHero() end
function modifier_arc_warden_magnetic_field_custom_thinker_damage:OnCreated()
if not IsServer() then return end

self.RemoveForDuel = true

if self:GetParent():HasAbility("arc_warden_magnetic_field_custom_legendary") and self:GetParent():FindAbilityByName("arc_warden_magnetic_field_custom_legendary"):IsHidden() then 

	self:GetParent():SwapAbilities(self:GetAbility():GetName(), "arc_warden_magnetic_field_custom_legendary", false, true)
end 

self.radius	= self:GetAbility():GetSpecialValueFor("radius")

if self:GetParent():IsHero() then 
	self.radius = self:GetCaster():GetTalentValue("modifier_arc_warden_field_7", "radius")
end 

self:GetParent():EmitSound("Hero_ArcWarden.MagneticField")

self.magnetic_particle = ParticleManager:CreateParticle("particles/arc_warden/arc_warden_magnetic_tempest.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControl(self.magnetic_particle, 1, Vector(self.radius, 1, 1))
self:AddParticle(self.magnetic_particle, false, false, 1, false, false)
end

function modifier_arc_warden_magnetic_field_custom_thinker_damage:OnDestroy()
if not IsServer() then return end
	
if self:GetParent():HasAbility("arc_warden_magnetic_field_custom_legendary") and not self:GetParent():FindAbilityByName("arc_warden_magnetic_field_custom_legendary"):IsHidden()
	and not self:GetParent():HasModifier("modifier_arc_warden_magnetic_field_custom_thinker_damage") then 
	self:GetParent():SwapAbilities(self:GetAbility():GetName(), "arc_warden_magnetic_field_custom_legendary", true, false)
end 

self:GetParent():StopSound("Hero_ArcWarden.MagneticField")
end

function modifier_arc_warden_magnetic_field_custom_thinker_damage:IsAura()						return true end
function modifier_arc_warden_magnetic_field_custom_thinker_damage:IsAuraActiveOnDeath() 		return false end

function modifier_arc_warden_magnetic_field_custom_thinker_damage:GetAuraDuration()				return 0.1 end
function modifier_arc_warden_magnetic_field_custom_thinker_damage:GetAuraRadius()				return self.radius end
function modifier_arc_warden_magnetic_field_custom_thinker_damage:GetAuraSearchFlags()			return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_arc_warden_magnetic_field_custom_thinker_damage:GetAuraSearchTeam()			return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_arc_warden_magnetic_field_custom_thinker_damage:GetAuraSearchType()			return DOTA_UNIT_TARGET_HERO end
function modifier_arc_warden_magnetic_field_custom_thinker_damage:GetModifierAura()				return "modifier_arc_warden_magnetic_field_custom_damage" end










modifier_arc_warden_magnetic_field_custom_thinker_evasion = class({})

function modifier_arc_warden_magnetic_field_custom_thinker_evasion:IsPurgable() return false end
function modifier_arc_warden_magnetic_field_custom_thinker_evasion:IsHidden() return true end
function modifier_arc_warden_magnetic_field_custom_thinker_evasion:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_arc_warden_magnetic_field_custom_thinker_evasion:OnCreated()
if not IsServer() then return end

self.RemoveForDuel = true
self.radius	= self:GetAbility():GetSpecialValueFor("radius")

if self:GetParent():IsHero() then 
	self.radius = self:GetCaster():GetTalentValue("modifier_arc_warden_field_7", "radius")
end 


end

function modifier_arc_warden_magnetic_field_custom_thinker_evasion:OnDestroy()
if not IsServer() then return end
	
end

function modifier_arc_warden_magnetic_field_custom_thinker_evasion:IsAura()						return true end
function modifier_arc_warden_magnetic_field_custom_thinker_evasion:IsAuraActiveOnDeath() 		return false end

function modifier_arc_warden_magnetic_field_custom_thinker_evasion:GetAuraDuration()				return 0.1 end
function modifier_arc_warden_magnetic_field_custom_thinker_evasion:GetAuraRadius()				return self.radius end
function modifier_arc_warden_magnetic_field_custom_thinker_evasion:GetAuraSearchFlags()			return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_arc_warden_magnetic_field_custom_thinker_evasion:GetAuraSearchTeam()			return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_arc_warden_magnetic_field_custom_thinker_evasion:GetAuraSearchType()			return DOTA_UNIT_TARGET_HERO end
function modifier_arc_warden_magnetic_field_custom_thinker_evasion:GetModifierAura()				return "modifier_arc_warden_magnetic_field_custom_evasion" end













modifier_arc_warden_magnetic_field_custom_evasion = class({})

function modifier_arc_warden_magnetic_field_custom_evasion:IsPurgable() return false end 
function modifier_arc_warden_magnetic_field_custom_evasion:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_arc_warden_magnetic_field_custom_evasion:IsHidden() return true end

function modifier_arc_warden_magnetic_field_custom_evasion:OnCreated()
if not self:GetAbility() then self:Destroy() end 

self.radius	= self:GetAbility():GetSpecialValueFor("radius")

if self:GetAuraOwner() and self:GetAuraOwner():IsHero() then 
	self.radius = self:GetCaster():GetTalentValue("modifier_arc_warden_field_7", "radius")
end 


self.evasion_chance	= self:GetAbility():GetSpecialValueFor("evasion_chance")

end




function modifier_arc_warden_magnetic_field_custom_evasion:DeclareFunctions()
return 
{
	MODIFIER_PROPERTY_EVASION_CONSTANT,
}
end

function modifier_arc_warden_magnetic_field_custom_evasion:GetModifierEvasion_Constant(params)
if not self:GetAuraOwner() then return end 

if params.attacker and (params.attacker:GetAbsOrigin() - self:GetAuraOwner():GetAbsOrigin()):Length2D() > self.radius then
	
	return self.evasion_chance
end

end















modifier_arc_warden_magnetic_field_custom_speed = class({})

function modifier_arc_warden_magnetic_field_custom_speed:IsPurgable() return false end 

function modifier_arc_warden_magnetic_field_custom_speed:IsHidden() 
if not self:GetAuraOwner() then return true end
	return self:GetAuraOwner():IsHero() 
end

function modifier_arc_warden_magnetic_field_custom_speed:OnCreated()
if not self:GetAbility() then self:Destroy() end 


self.evasion_chance	= self:GetAbility():GetSpecialValueFor("evasion_chance")
self.attack_speed_bonus	= self:GetAbility():GetSpecialValueFor("attack_speed_bonus")

self.attack_range_bonus	= self:GetAbility():GetSpecialValueFor("attack_range_bonus")
self.damage_bonus	= self:GetAbility():GetSpecialValueFor("attack_magic_damage")

if self:GetCaster():HasModifier("modifier_arc_warden_field_1") then 
	self.attack_speed_bonus = self.attack_speed_bonus + self:GetCaster():GetTalentValue("modifier_arc_warden_field_1", "speed")
	self.damage_bonus= self.damage_bonus + self:GetCaster():GetTalentValue("modifier_arc_warden_field_1", "damage")
end 


end



function modifier_arc_warden_magnetic_field_custom_speed:DeclareFunctions()
return 
{
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
    MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
}
end



function modifier_arc_warden_magnetic_field_custom_speed:GetModifierAttackSpeedBonus_Constant()
	return self.attack_speed_bonus
end



function modifier_arc_warden_magnetic_field_custom_speed:GetModifierAttackRangeBonus()
if not self:GetCaster():HasShard() then return end
	return self.attack_range_bonus
end


function modifier_arc_warden_magnetic_field_custom_speed:GetModifierBaseAttack_BonusDamage()
if not self:GetCaster():HasShard() then return end
	return self.damage_bonus
end















modifier_arc_warden_magnetic_field_custom_damage = class({})
function modifier_arc_warden_magnetic_field_custom_damage:IsPurgable() return false end 
function modifier_arc_warden_magnetic_field_custom_damage:IsHidden() 
if not self:GetAuraOwner() then return true end
	return self:GetAuraOwner():IsHero() 
end


function modifier_arc_warden_magnetic_field_custom_damage:OnCreated()
if not self:GetAbility() then self:Destroy() return end

self.radius				= self:GetAbility():GetSpecialValueFor("radius")
self.attack_range_bonus	= self:GetAbility():GetSpecialValueFor("attack_range_bonus")
self.damage_bonus	= self:GetAbility():GetSpecialValueFor("attack_magic_damage")

if self:GetCaster():HasModifier("modifier_arc_warden_field_1") then 
	self.damage_bonus = self.damage_bonus + self:GetCaster():GetTalentValue("modifier_arc_warden_field_1", "damage")
end 


if self:GetAuraOwner() and self:GetAuraOwner():IsHero() then 
	self.radius = self:GetCaster():GetTalentValue("modifier_arc_warden_field_7", "radius")
end 

end



function modifier_arc_warden_magnetic_field_custom_damage:DeclareFunctions()
return 
{
	MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
	MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE
}
end

function modifier_arc_warden_magnetic_field_custom_damage:GetModifierAttackRangeBonus()
	return self.attack_range_bonus
end



function modifier_arc_warden_magnetic_field_custom_damage:GetModifierBaseAttack_BonusDamage()
	return self.damage_bonus
end
















modifier_arc_warden_magnetic_field_custom_tracker = class({})
function modifier_arc_warden_magnetic_field_custom_tracker:IsHidden() return true end
function modifier_arc_warden_magnetic_field_custom_tracker:IsPurgable() return false end
function modifier_arc_warden_magnetic_field_custom_tracker:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_ATTACK_LANDED,
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
	MODIFIER_PROPERTY_ABSORB_SPELL,
}

end 






function modifier_arc_warden_magnetic_field_custom_tracker:GetAbsorbSpell(params) 
if not IsServer() then return end
if not self:GetCaster():HasModifier("modifier_arc_warden_field_6") then return end 
if self:GetParent():HasModifier("modifier_arc_warden_magnetic_field_custom_absorb_cd") then return end
if self:GetParent():IsIllusion() then return end

local caster = params.ability:GetCaster()
if not caster then return end

if caster:GetTeamNumber() == self:GetParent():GetTeamNumber() then return end 

local mod = self:GetParent():FindModifierByName("modifier_arc_warden_magnetic_field_custom_evasion")
local radius = nil

if not mod then 
	mod = self:GetParent():FindModifierByName("modifier_arc_warden_magnetic_field_custom_damage")

	if not mod then 
		return 0 
	else 
		if mod:GetAuraOwner() and mod:GetAuraOwner():HasModifier("modifier_arc_warden_magnetic_field_custom_thinker_damage") then 
			radius = mod:GetAuraOwner():FindModifierByName("modifier_arc_warden_magnetic_field_custom_thinker_damage").radius
		end 
	end 
else 

	if mod:GetAuraOwner() and mod:GetAuraOwner():HasModifier("modifier_arc_warden_magnetic_field_custom_thinker_evasion") then 
		radius = mod:GetAuraOwner():FindModifierByName("modifier_arc_warden_magnetic_field_custom_thinker_evasion").radius
	end 
end 


if radius == nil then return end 

if (caster:GetAbsOrigin() - mod:GetAuraOwner():GetAbsOrigin()):Length2D() <= radius then return end

local particle = ParticleManager:CreateParticle("particles/items_fx/immunity_sphere.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControlEnt(particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
ParticleManager:ReleaseParticleIndex(particle)

self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_arc_warden_magnetic_field_custom_absorb_cd", {duration = self:GetCaster():GetTalentValue("modifier_arc_warden_field_6", "cd")})


self:GetParent():EmitSound("DOTA_Item.LinkensSphere.Activate")

return 1 
end


function modifier_arc_warden_magnetic_field_custom_tracker:GetModifierStatusResistanceStacking() 
if not self:GetParent():HasModifier("modifier_arc_warden_magnetic_field_custom_speed") and not self:GetParent():HasModifier("modifier_arc_warden_magnetic_field_custom_damage") then return end
if not self:GetParent():HasModifier("modifier_arc_warden_field_2") then return end 

return self:GetCaster():GetTalentValue("modifier_arc_warden_field_2", "status_bonus")
end


function modifier_arc_warden_magnetic_field_custom_tracker:GetModifierIncomingDamage_Percentage()
if not self:GetParent():HasModifier("modifier_arc_warden_magnetic_field_custom_speed") and not self:GetParent():HasModifier("modifier_arc_warden_magnetic_field_custom_damage") then return end
if not self:GetParent():HasModifier("modifier_arc_warden_field_2") then return end 

return self:GetCaster():GetTalentValue("modifier_arc_warden_field_2", "damage_reduce")
end





function modifier_arc_warden_magnetic_field_custom_tracker:OnAttackLanded(params)
if not IsServer() then return end 
if self:GetParent():IsIllusion() then return end
if self:GetParent() ~= params.attacker then return end 
if not params.target:IsHero() and not params.target:IsCreep() then return end 
if not self:GetParent():HasModifier("modifier_arc_warden_magnetic_field_custom_speed") and not self:GetParent():HasModifier("modifier_arc_warden_magnetic_field_custom_damage") then return end

local spark = self:GetCaster():FindAbilityByName("arc_warden_spark_wraith_custom")
if spark and spark:GetLevel() > 0 and self:GetCaster():HasScepter() then 

  	local random = RollPseudoRandomPercentage(spark:GetSpecialValueFor("scepter_chance"),725,self:GetParent())

  	if random then 
		spark:CreateSpark(params.target:GetAbsOrigin())
	end
end 


end 









modifier_arc_warden_magnetic_field_custom_shard_knock = class({})

function modifier_arc_warden_magnetic_field_custom_shard_knock:IsHidden() return true end

function modifier_arc_warden_magnetic_field_custom_shard_knock:OnCreated(params)
if not IsServer() then return end

self.ability        = self:GetAbility()
self.caster         = self:GetCaster()
self.parent         = self:GetParent()
self:GetParent():StartGesture(ACT_DOTA_FLAIL)


self.position = GetGroundPosition(Vector(params.x, params.y, 0), nil)

self.knockback_duration  = self:GetRemainingTime()

self.knockback_speed    = self:GetAbility():GetSpecialValueFor("shard_speed")


if self:ApplyHorizontalMotionController() == false then 
	self:Destroy()
	return
end

end

function modifier_arc_warden_magnetic_field_custom_shard_knock:UpdateHorizontalMotion( me, dt )
  if not IsServer() then return end

  local vec = (self.position - me:GetOrigin()):Normalized()
  
  me:SetOrigin( me:GetOrigin() + vec * self.knockback_speed * dt )

  GridNav:DestroyTreesAroundPoint( self.parent:GetOrigin(), self.parent:GetHullRadius(), true )
end

function modifier_arc_warden_magnetic_field_custom_shard_knock:DeclareFunctions()
  local decFuncs = {
    MODIFIER_PROPERTY_OVERRIDE_ANIMATION
    }

    return decFuncs
end

function modifier_arc_warden_magnetic_field_custom_shard_knock:GetOverrideAnimation()
   return ACT_DOTA_FLAIL
end


function modifier_arc_warden_magnetic_field_custom_shard_knock:OnDestroy()
if not IsServer() then return end

self.parent:RemoveHorizontalMotionController( self )
self:GetParent():FadeGesture(ACT_DOTA_FLAIL)
FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetAbsOrigin(), false)

end



modifier_arc_warden_magnetic_field_custom_shard_slow = class({})
function modifier_arc_warden_magnetic_field_custom_shard_slow:IsHidden() return true end
function modifier_arc_warden_magnetic_field_custom_shard_slow:IsPurgable() return true end
function modifier_arc_warden_magnetic_field_custom_shard_slow:GetEffectName() return "particles/units/heroes/hero_terrorblade/terrorblade_reflection_slow.vpcf" end

function modifier_arc_warden_magnetic_field_custom_shard_slow:OnCreated()
self.slow = self:GetAbility():GetSpecialValueFor("shard_slow")
end 


function modifier_arc_warden_magnetic_field_custom_shard_slow:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end 




function modifier_arc_warden_magnetic_field_custom_shard_slow:GetModifierMoveSpeedBonus_Percentage()
return self.slow
end 









arc_warden_magnetic_field_custom_legendary = class({})

function arc_warden_magnetic_field_custom_legendary:GetCastRange(vLocation, hTarget)

if IsClient() then 
	return self:GetSpecialValueFor("range")
else 
	return 999999
end 

end 


function arc_warden_magnetic_field_custom_legendary:GetCooldown()
	return self:GetCaster():GetTalentValue("modifier_arc_warden_field_7", "cd")
end 

function arc_warden_magnetic_field_custom_legendary:OnSpellStart()
if not IsServer() then return end

local point = self:GetCursorPosition()

local dir = (point - self:GetCaster():GetAbsOrigin())
dir.z = 0

if dir:Length2D() > self:GetSpecialValueFor("range") then 
	
	point = self:GetCaster():GetAbsOrigin() + dir:Normalized()*self:GetSpecialValueFor("range")

	point = GetGroundPosition(point, nil)
end 

self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_arc_warden_magnetic_field_custom_legendary", {duration = self:GetSpecialValueFor("delay"), x = point.x, y = point.y, z = point.z})

end 










modifier_arc_warden_magnetic_field_custom_legendary = class({})
function modifier_arc_warden_magnetic_field_custom_legendary:IsHidden() return true end
function modifier_arc_warden_magnetic_field_custom_legendary:IsPurgable() return false end
function modifier_arc_warden_magnetic_field_custom_legendary:OnCreated(table)
if not IsServer() then return end 

self.main_ability = self:GetParent():FindAbilityByName("arc_warden_magnetic_field_custom")
local cd = self.main_ability:GetCooldownTimeRemaining()

if cd > 0 then 
	self.main_ability:EndCooldown()
	self.main_ability:StartCooldown(cd + self:GetRemainingTime())
end 



ProjectileManager:ProjectileDodge(self:GetParent())

self.point = Vector(table.x, table.y, table.z)
self.old_pos = self:GetParent():GetAbsOrigin()

self.old_pos.z = self.old_pos.z + 150

local effect = ParticleManager:CreateParticle("particles/arc_warden/field_blink_start.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(effect, 0, self:GetParent():GetAbsOrigin())
ParticleManager:ReleaseParticleIndex(effect)

self.parent = self:GetParent()

local qangle_rotation_rate = 120
local line_position = self.parent:GetAbsOrigin() + self.parent:GetForwardVector() * self:GetCaster():GetTalentValue("modifier_arc_warden_field_7", "radius")
for i = 1, 3 do

	local qangle = QAngle(0, qangle_rotation_rate, 0)
	line_position = RotatePosition(self.parent:GetAbsOrigin() , qangle, line_position)

	local cast_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_arc_warden/arc_warden_flux_cast.vpcf", PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(cast_particle, 0, self.old_pos )
	ParticleManager:SetParticleControl(cast_particle, 1, line_position)
	ParticleManager:SetParticleControl(cast_particle, 2, self.old_pos )
	ParticleManager:ReleaseParticleIndex(cast_particle)

end

self.mods = {}



for _,mod in pairs(self:GetParent():FindAllModifiers()) do
	if mod:GetName() == "modifier_arc_warden_magnetic_field_custom_thinker_speed" or 
		mod:GetName() == "modifier_arc_warden_magnetic_field_custom_thinker_damage" or 
		mod:GetName() == "modifier_arc_warden_magnetic_field_custom_thinker_evasion" then 

		self.mods[mod:GetName()] = mod:GetRemainingTime()

		mod:Destroy()
	end 
end 



self:GetParent():EmitSound("Arc.Field_blink_start")
self:GetParent():EmitSound("Arc.Field_blink_start2")

self.NoDraw = true
self:GetParent():AddNoDraw()
self:StartIntervalThink(0.2)
end 


function modifier_arc_warden_magnetic_field_custom_legendary:OnIntervalThink()
if not IsServer() then return end 

FindClearSpaceForUnit(self:GetParent(), self.point, false)

self:StartIntervalThink(-1)
end 


function modifier_arc_warden_magnetic_field_custom_legendary:CheckState()
return
{
	[MODIFIER_STATE_STUNNED] = true,
	[MODIFIER_STATE_INVULNERABLE] = true,
	[MODIFIER_STATE_OUT_OF_GAME] = true,
	[MODIFIER_STATE_UNSELECTABLE] = true,
	[MODIFIER_STATE_NO_HEALTH_BAR] = true,
	[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
	[MODIFIER_STATE_DISARMED] = true
}
end 


function modifier_arc_warden_magnetic_field_custom_legendary:OnDestroy()
if not IsServer() then return end 

self:GetParent():RemoveNoDraw()

self.point.z = self.point.z + 150

self:PlayEffect(self:GetParent())


if not self:GetParent():IsAlive() then return end

local qangle = QAngle(0, 75 , 0)
if RandomInt(0, 1) == 1 then 
	qangle = QAngle(0, -75 , 0)
end 

local point = RotatePosition(GetGroundPosition(self.old_pos, nil) , qangle, self.point)

point = GetGroundPosition(point, nil)

local illusions = CreateIllusions( self:GetCaster(), self:GetCaster(), {duration= self:GetCaster():GetTalentValue("modifier_arc_warden_field_7", "duration"), outgoing_damage= -100 + self:GetCaster():GetTalentValue("modifier_arc_warden_field_7", "damage"),incoming_damage= self:GetCaster():GetTalentValue("modifier_arc_warden_field_7", "incoming")}, 1, 0, false, false )  
for k, illusion in pairs(illusions) do


  for _,mod in pairs(self:GetCaster():FindAllModifiers()) do
      if mod.StackOnIllusion ~= nil and mod.StackOnIllusion == true then
          illusion:UpgradeIllusion(mod:GetName(), mod:GetStackCount() )
      end
  end

  illusion:AddNewModifier(illusion, self:GetAbility(), "modifier_arc_warden_magnetic_field_custom_legendary_illusion", {})

  FindClearSpaceForUnit(illusion, point, true)
  self:PlayEffect(illusion)

	illusion.owner = self:GetCaster()	
	illusion:SetOwner(nil)

	local enemies = FindUnitsInRadius(illusion:GetTeamNumber(), illusion:GetAbsOrigin(), nil, 1200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false)
	local creeps = FindUnitsInRadius(illusion:GetTeamNumber(), illusion:GetAbsOrigin(), nil, 1200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false)

	if #enemies > 0 then 
		illusion:SetForceAttackTarget(enemies[1])
	else 
		if #creeps > 0 then 
			illusion:SetForceAttackTarget(creeps[1])
		end 
	end  

	Timers:CreateTimer(0.5, function()
		if illusion and not illusion:IsNull() then 
			illusion:SetForceAttackTarget(nil)
		end 
	end)

end

end 




function modifier_arc_warden_magnetic_field_custom_legendary:PlayEffect(unit)
if not IsServer() then return end

unit:EmitSound("Arc.Field_blink_end")
unit:EmitSound("Arc.Field_blink_end2")


for name,duration in pairs(self.mods) do 
	unit:AddNewModifier(self:GetParent(), self.main_ability, name, {duration = duration})
end 


unit:MoveToPositionAggressive(unit:GetAbsOrigin())

local point = unit:GetAbsOrigin()
point.z = point.z + 150

local qangle_rotation_rate = 120
local line_position = unit:GetAbsOrigin() + unit:GetForwardVector() * self:GetCaster():GetTalentValue("modifier_arc_warden_field_7", "radius")
for i = 1, 3 do

	local qangle = QAngle(0, qangle_rotation_rate, 0)
	line_position = RotatePosition(unit:GetAbsOrigin() , qangle, line_position)

	local cast_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_arc_warden/arc_warden_flux_cast.vpcf", PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(cast_particle, 0, line_position )
	ParticleManager:SetParticleControl(cast_particle, 1, point)
	ParticleManager:SetParticleControl(cast_particle, 2, line_position )
	ParticleManager:ReleaseParticleIndex(cast_particle)
end



local effect = ParticleManager:CreateParticle("particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_blink_end.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(effect, 0, unit:GetAbsOrigin())
ParticleManager:ReleaseParticleIndex(effect)


if unit:IsIllusion() then 

	local illusion = unit

	local cast_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_arc_warden/arc_warden_flux_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, illusion)
	ParticleManager:SetParticleControlEnt(cast_particle, 0, illusion, PATTACH_POINT_FOLLOW, "attach_hitloc", illusion:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(cast_particle, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(cast_particle, 2, illusion, PATTACH_POINT_FOLLOW, "attach_hitloc", illusion:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(cast_particle)


	cast_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_arc_warden/arc_warden_flux_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControlEnt(cast_particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(cast_particle, 1, illusion, PATTACH_POINT_FOLLOW, "attach_hitloc", illusion:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(cast_particle, 2, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(cast_particle)

end 

end 









modifier_arc_warden_magnetic_field_custom_legendary_illusion = class({})
function modifier_arc_warden_magnetic_field_custom_legendary_illusion:IsHidden() return true end
function modifier_arc_warden_magnetic_field_custom_legendary_illusion:IsPurgable() return false end
function modifier_arc_warden_magnetic_field_custom_legendary_illusion:CheckState()
return
{
	[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
	--[MODIFIER_STATE_IGNORING_MOVE_AND_ATTACK_ORDERS] = true,
	[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
}

end 



modifier_arc_warden_magnetic_field_custom_shard_cd = class({})
function modifier_arc_warden_magnetic_field_custom_shard_cd:IsHidden() return true end
function modifier_arc_warden_magnetic_field_custom_shard_cd:IsPurgable() return false end
function modifier_arc_warden_magnetic_field_custom_shard_cd:RemoveOnDeath() return false end
function modifier_arc_warden_magnetic_field_custom_shard_cd:OnCreated()
self.RemoveForDuel = true
end 




modifier_arc_warden_magnetic_field_custom_absorb_cd = class({})
function modifier_arc_warden_magnetic_field_custom_absorb_cd:IsHidden() return false end
function modifier_arc_warden_magnetic_field_custom_absorb_cd:IsPurgable() return false end
function modifier_arc_warden_magnetic_field_custom_absorb_cd:GetTexture() return "buffs/field_absorb" end 
function modifier_arc_warden_magnetic_field_custom_absorb_cd:IsDebuff() return true end
function modifier_arc_warden_magnetic_field_custom_absorb_cd:OnCreated()
self.RemoveForDuel = true
end




modifier_arc_warden_magnetic_field_custom_stun = class({})
function modifier_arc_warden_magnetic_field_custom_stun:IsHidden() return true end
function modifier_arc_warden_magnetic_field_custom_stun:IsPurgable() return false end
function modifier_arc_warden_magnetic_field_custom_stun:IsStunDebuff() return true end
function modifier_arc_warden_magnetic_field_custom_stun:IsPurgeException() return true end
function modifier_arc_warden_magnetic_field_custom_stun:StatusEffectPriority() return 9999 end
function modifier_arc_warden_magnetic_field_custom_stun:GetStatusEffectName() return "particles/status_fx/status_effect_faceless_chronosphere.vpcf" end
function modifier_arc_warden_magnetic_field_custom_stun:CheckState()
return
{
	[MODIFIER_STATE_FROZEN] = true,
	[MODIFIER_STATE_STUNNED] = true
}
end



modifier_arc_warden_magnetic_field_custom_damage_stack = class({})
function modifier_arc_warden_magnetic_field_custom_damage_stack:IsHidden() return false end
function modifier_arc_warden_magnetic_field_custom_damage_stack:IsPurgable() return false end
function modifier_arc_warden_magnetic_field_custom_damage_stack:GetTexture() return "buffs/field_damage" end
function modifier_arc_warden_magnetic_field_custom_damage_stack:OnCreated(table)
if not IsServer() then return end 

self.interval = FrameTime()
self.time = self:GetCaster():GetTalentValue("modifier_arc_warden_field_4", "delay")
self.count = 0



self.index = self:GetParent():entindex()
self.event = "arc_field_change"

if self:GetParent():HasModifier("modifier_arc_warden_tempest_double") then 
	self.event = "arc_field_tempest_change"
end

self.name = table.name

CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), self.event,  {hide = 0, active = 0, index = self.index, max_time = self.time, time = self.count, damage = self:GetStackCount()})

self:StartIntervalThink(self.interval)
end 


function modifier_arc_warden_magnetic_field_custom_damage_stack:OnIntervalThink()
if not IsServer() then return end
if self:GetParent():HasModifier("modifier_arc_warden_magnetic_field_custom_legendary") then return end

self.count = self.count + self.interval
CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), self.event,  {hide = 0, active = 0, index = self.index, max_time = self.time, time = self.count, damage = self:GetStackCount()})

if self.count >= self.time then 
	self:Destroy()
	self:StartIntervalThink(-1)
end

end 


function modifier_arc_warden_magnetic_field_custom_damage_stack:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_TAKEDAMAGE
}
end


function modifier_arc_warden_magnetic_field_custom_damage_stack:OnTakeDamage(params)
if not IsServer() then return end
if not params.unit:IsHero() and not params.unit:IsCreep() then return end 

local attacker = params.attacker

if not attacker:HasModifier(self.name)  then return end

if attacker == self:GetParent() or (attacker.owner and attacker:IsIllusion() and attacker.owner == self:GetParent()) then else 
	return
end 

local damage = params.damage*self:GetCaster():GetTalentValue("modifier_arc_warden_field_4", "damage_stack")/100

if params.unit:IsCreep() then 
	damage = damage*self:GetCaster():GetTalentValue("modifier_arc_warden_field_4", "stack_creeps")
end 

self:SetStackCount(self:GetStackCount() + damage)

end 



function modifier_arc_warden_magnetic_field_custom_damage_stack:OnDestroy()
if not IsServer() then return end 

if self:GetStackCount() < 1 or not self:GetParent():IsAlive() then
	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), self.event,  {hide = 1, active = 0, index = self.index,  max_time = self.time, time = self.count, damage = self:GetStackCount()})
	return 
else 
	self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_arc_warden_magnetic_field_custom_damage_attack", {duration = self:GetCaster():GetTalentValue("modifier_arc_warden_field_4", "duration"), stack = self:GetStackCount()})
end

end 



modifier_arc_warden_magnetic_field_custom_damage_attack = class({})
function modifier_arc_warden_magnetic_field_custom_damage_attack:IsHidden() return false end
function modifier_arc_warden_magnetic_field_custom_damage_attack:IsPurgable() return false end
function modifier_arc_warden_magnetic_field_custom_damage_attack:GetTexture() return "buffs/field_damage" end
function modifier_arc_warden_magnetic_field_custom_damage_attack:GetPriority() return 9999999 end
function modifier_arc_warden_magnetic_field_custom_damage_attack:OnCreated(table)
if not IsServer() then return end
self.record = nil
self.attack = false

self.index = self:GetParent():entindex()
self.event = "arc_field_change"

if self:GetParent():HasModifier("modifier_arc_warden_tempest_double") then 
	self.event = "arc_field_tempest_change"
end


self:SetStackCount(table.stack)
self:OnIntervalThink()
self:StartIntervalThink(0.1)
end 


function modifier_arc_warden_magnetic_field_custom_damage_attack:OnIntervalThink()
if not IsServer() then return end
if self.record ~= nil then return end
CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), self.event,  {hide = 0, active = 1, index = self.index,  max_time = 1, time = 1, damage = self:GetStackCount()})

end 



function modifier_arc_warden_magnetic_field_custom_damage_attack:OnDestroy()
if not IsServer() then return end
CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), self.event,  {hide = 1, active = 0, index = self.index,  max_time = 1, time = 1, damage = self:GetStackCount()})

end 


function modifier_arc_warden_magnetic_field_custom_damage_attack:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_ATTACK,
	MODIFIER_EVENT_ON_ATTACK_START,
	MODIFIER_EVENT_ON_ATTACK_FAIL,
	MODIFIER_EVENT_ON_ATTACK_LANDED,
  	MODIFIER_PROPERTY_PROJECTILE_NAME,
}
end 


function modifier_arc_warden_magnetic_field_custom_damage_attack:GetModifierProjectileName()
if self.record ~= nil then return end

return "particles/arc_warden/field_attack.vpcf"
end

function modifier_arc_warden_magnetic_field_custom_damage_attack:OnAttackStart(params)
if self.attack == true then return end
if self:GetParent() ~= params.attacker then return end
if not params.target:IsCreep() and not params.target:IsHero() then return end

self.attack = true
end 




function modifier_arc_warden_magnetic_field_custom_damage_attack:OnAttack(params)
if self.record ~= nil then return end
if self.attack == false then return end
if self:GetParent() ~= params.attacker then return end
if not params.target:IsCreep() and not params.target:IsHero() then return end

if IsServer() then 
	self:GetParent():EmitSound("Arc.Field_attack_start")
end 
self:SetDuration(9999, true)

CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), self.event,  {hide = 1, active = 0, index = self.index,  max_time = 1, time = 1, damage = self:GetStackCount()})

local particle = ParticleManager:CreateParticle( "particles/arc_warden/spark_heall.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
ParticleManager:ReleaseParticleIndex(particle)


self:GetParent():GenericHeal(self:GetStackCount(), self:GetAbility(), false, "particles/puck_heal.vpcf")

if self.particle then 
	ParticleManager:DestroyParticle(self.particle, true)
	ParticleManager:ReleaseParticleIndex(self.particle)
end 

self.record = params.record
end


function modifier_arc_warden_magnetic_field_custom_damage_attack:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end
if not params.target:IsCreep() and not params.target:IsHero() then return end
if self.record ~= params.record then return end

local point = params.target:GetAbsOrigin()
local damage = self:GetStackCount()

params.target:EmitSound("Arc.Field_attack_end")

local particle = ParticleManager:CreateParticle( "particles/arc_warden/field_attack_end.vpcf", PATTACH_ABSORIGIN_FOLLOW, params.target )
ParticleManager:SetParticleControl(particle, 0,params.target:GetAbsOrigin())
ParticleManager:ReleaseParticleIndex(particle)

local units = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), point, nil, self:GetCaster():GetTalentValue("modifier_arc_warden_field_4", "radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

for _,unit in pairs(units) do

	ApplyDamage({ victim = unit, attacker = self:GetCaster(), damage = damage,  damage_type = DAMAGE_TYPE_PURE, ability = self:GetAbility(), })
	SendOverheadEventMessage(unit, 4, unit, damage, nil)

end

self:Destroy()
end



function modifier_arc_warden_magnetic_field_custom_damage_attack:OnAttackFail(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end
if self.record ~= params.record then return end

self:Destroy()
end