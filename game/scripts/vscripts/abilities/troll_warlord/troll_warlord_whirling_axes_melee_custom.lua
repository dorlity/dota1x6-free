LinkLuaModifier("modifier_troll_warlord_whirling_axes_melee_custom", "abilities/troll_warlord/troll_warlord_whirling_axes_melee_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_troll_warlord_whirling_axes_melee_custom_thinker", "abilities/troll_warlord/troll_warlord_whirling_axes_melee_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_troll_warlord_whirling_axes_attack", "abilities/troll_warlord/troll_warlord_whirling_axes_melee_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_troll_warlord_whirling_axes_tracker", "abilities/troll_warlord/troll_warlord_whirling_axes_melee_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_troll_warlord_whirling_axes_melee_quest", "abilities/troll_warlord/troll_warlord_whirling_axes_melee_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_troll_warlord_whirling_axes_melee_custom_stack", "abilities/troll_warlord/troll_warlord_whirling_axes_melee_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_troll_warlord_whirling_axes_ranged_custom_stack", "abilities/troll_warlord/troll_warlord_whirling_axes_melee_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_troll_warlord_whirling_axes_perma_melee", "abilities/troll_warlord/troll_warlord_whirling_axes_melee_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_troll_warlord_whirling_axes_perma_ranged", "abilities/troll_warlord/troll_warlord_whirling_axes_melee_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_troll_warlord_whirling_axes_buff", "abilities/troll_warlord/troll_warlord_whirling_axes_melee_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_troll_warlord_whirling_axes_charge", "abilities/troll_warlord/troll_warlord_whirling_axes_melee_custom", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_troll_warlord_whirling_axes_melee_cd", "abilities/troll_warlord/troll_warlord_whirling_axes_melee_custom", LUA_MODIFIER_MOTION_HORIZONTAL)





troll_warlord_whirling_axes_melee_custom = class({})









function troll_warlord_whirling_axes_melee_custom:Precache(context)

    
PrecacheResource( "particle", "particles/units/heroes/hero_troll_warlord/troll_warlord_whirling_axe_melee.vpcf", context )
PrecacheResource( "particle", "particles/sf_refresh_a.vpcf", context )
PrecacheResource( "particle", "particles/troll_hit.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_marci/marci_unleash_stack.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_marci/orb_damage_stack.vpcf", context )
PrecacheResource( "particle", "particles/troll_warlord/refresh_ranged.vpcf", context )
end


function troll_warlord_whirling_axes_melee_custom:GetAbilityTargetFlags()
if self:GetCaster():HasScepter() then 
	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
else 
	return DOTA_UNIT_TARGET_FLAG_NONE
end

end

function troll_warlord_whirling_axes_melee_custom:GetIntrinsicModifierName()
return "modifier_troll_warlord_whirling_axes_tracker"
end

function troll_warlord_whirling_axes_melee_custom:OnUpgrade()
	if self:GetCaster():HasModifier("modifier_troll_warlord_berserkers_rage_custom") then
		--self:SetActivated(true)
	else
		if not self:GetCaster():HasModifier("modifier_troll_axes_legendary") then 
		--	self:SetActivated(false)
		end
	end
end


function troll_warlord_whirling_axes_melee_custom:GetBehavior()

local bonus = 0 

if self:GetCaster():HasModifier("modifier_troll_axes_6") then 
	bonus = DOTA_ABILITY_BEHAVIOR_AUTOCAST
end

return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + bonus
end


function troll_warlord_whirling_axes_melee_custom:GetCooldown(level)
local bonus = 0

if self:GetCaster():HasModifier("modifier_troll_axes_1") then
	bonus = self:GetCaster():GetTalentValue("modifier_troll_axes_1", "cd")
end

return self.BaseClass.GetCooldown( self, level ) + bonus
end



function troll_warlord_whirling_axes_melee_custom:GetManaCost(level)
local bonus = 0

if self:GetCaster():HasModifier("modifier_troll_axes_1") then
	bonus = self:GetCaster():GetTalentValue("modifier_troll_axes_1", "mana")
end

return self.BaseClass.GetManaCost(self, level) + bonus

end




function troll_warlord_whirling_axes_melee_custom:OnSpellStart()
local caster = self:GetCaster()
local caster_location = caster:GetAbsOrigin()

caster:EmitSound("Hero_TrollWarlord.WhirlingAxes.Melee")
caster:StartGesture(ACT_DOTA_CAST_ABILITY_3)

if caster:HasScepter() then
	caster:Purge(false, true, false, false, false)
end

if not self:GetCaster():HasModifier("modifier_troll_warlord_berserkers_rage_custom") then 

	local ability = self:GetCaster():FindAbilityByName("troll_warlord_berserkers_rage_custom")

	if ability and ability:IsTrained() then 
		ability:ToggleAbility()
	end 
end 


if self:GetCaster():HasModifier("modifier_troll_axes_3") then 
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_troll_warlord_whirling_axes_attack", {duration = self:GetCaster():GetTalentValue("modifier_troll_axes_3", "duration")})
end



local whirl_duration = self:GetSpecialValueFor("whirl_duration")

local max = 1
local stun = 0

local particle = "particles/units/heroes/hero_troll_warlord/troll_warlord_whirling_axe_melee.vpcf"
local stun_mod = self:GetCaster():FindModifierByName("modifier_troll_warlord_whirling_axes_perma_melee")

if stun_mod and not self:GetCaster():HasModifier("modifier_troll_warlord_whirling_axes_melee_cd") 
	and self:GetCaster():HasModifier("modifier_troll_axes_4") and stun_mod:GetStackCount() >= self:GetCaster():GetTalentValue("modifier_troll_axes_4", "max") then 
	
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_troll_warlord_whirling_axes_melee_cd", {duration = self:GetCaster():GetTalentValue("modifier_troll_axes_4", "cd")})
	particle = "particles/econ/items/troll_warlord/troll_ti10_shoulder/troll_ti10_whirling_axe_melee.vpcf"
	stun = 1
end

if self:GetCaster():HasModifier("modifier_troll_axes_6") and self:GetAutoCastState() == true then 
	ProjectileManager:ProjectileDodge(self:GetCaster())
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_troll_warlord_whirling_axes_charge", {duration = self:GetCaster():GetTalentValue("modifier_troll_axes_6", "duration")})
end 

for i = 1,max do


	if self:GetCaster():HasModifier("modifier_troll_axes_6") or self:GetCaster():HasModifier("modifier_troll_axes_2") then 
		self:GetCaster():AddNewModifier(self:GetCaster(), self ,"modifier_troll_warlord_whirling_axes_buff", {duration = whirl_duration})
	end


	local angle_east = QAngle(0,90,0)
	local angle_west = QAngle(0,-90,0)
	if i == 2 then 
		angle_east = QAngle(0,0,0)
		angle_west = QAngle(0,180,0)
	end

	local start_radius = 100

	local forward_vector = caster:GetForwardVector()
	local front_position = caster_location + forward_vector * start_radius
	local position_east = RotatePosition(caster_location, angle_east, front_position) 
	local position_west = RotatePosition(caster_location, angle_west, front_position)

	position_east = GetGroundPosition( position_east, self:GetCaster() )
	position_west = GetGroundPosition( position_west, self:GetCaster() )
	position_east.z = position_east.z + 75
	position_west.z = position_west.z + 75


	local index = DoUniqueString("index")
	self[index] = {}

	self.whirling_axes_east = CreateUnitByName("npc_dota_troll_warlord_axe", position_east, false, caster, caster, caster:GetTeam() )
	self.whirling_axes_east:SetAbsOrigin(position_east)
	self.whirling_axes_east:AddNewModifier(caster, self, "modifier_troll_warlord_whirling_axes_melee_custom_thinker", {stun = stun, i = i, index = index, count = 1})

	self.whirling_axes_east.particle = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN_FOLLOW, self.whirling_axes_east)
	ParticleManager:SetParticleControl(self.whirling_axes_east.particle, 0, self.whirling_axes_east:GetAbsOrigin())
	ParticleManager:SetParticleControl(self.whirling_axes_east.particle, 1, self.whirling_axes_east:GetAbsOrigin())
	ParticleManager:SetParticleControl(self.whirling_axes_east.particle, 4, Vector(whirl_duration,0,0))
	self.whirling_axes_east.axe_radius = start_radius
	self.whirling_axes_east.start_time = GameRules:GetGameTime()
	self.whirling_axes_east.side = 0

	self.whirling_axes_west = CreateUnitByName("npc_dota_troll_warlord_axe", position_west, false, caster, caster, caster:GetTeam() )
	self.whirling_axes_west:SetAbsOrigin(position_west)
	self.whirling_axes_west:AddNewModifier(caster, self, "modifier_troll_warlord_whirling_axes_melee_custom_thinker", {stun = stun, i = i, index = index, count = 2})
	self.whirling_axes_west.particle = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN_FOLLOW, self.whirling_axes_west)
	ParticleManager:SetParticleControl(self.whirling_axes_west.particle, 0, self.whirling_axes_west:GetAbsOrigin())
	ParticleManager:SetParticleControl(self.whirling_axes_west.particle, 1, self.whirling_axes_west:GetAbsOrigin())
	ParticleManager:SetParticleControl(self.whirling_axes_west.particle, 4, Vector(whirl_duration,0,0))
	self.whirling_axes_west.axe_radius = start_radius
	self.whirling_axes_west.start_time = GameRules:GetGameTime()
	self.whirling_axes_west.side = 1

end



end

modifier_troll_warlord_whirling_axes_melee_custom_thinker = class({})

function modifier_troll_warlord_whirling_axes_melee_custom_thinker:OnCreated(params)
if not IsServer() then return end
self.index = params.index
self.stun = params.stun
self:StartIntervalThink(FrameTime())
self.i = params.i


self.damage = self:GetAbility():GetSpecialValueFor("damage")

local legen_mod = self:GetCaster():FindModifierByName("modifier_troll_warlord_whirling_axes_melee_custom_stack")
local epic_mod = self:GetCaster():FindModifierByName("modifier_troll_warlord_whirling_axes_perma_melee")

if not legen_mod then 
	legen_mod = self:GetCaster():FindModifierByName("modifier_troll_warlord_whirling_axes_ranged_custom_stack")
end 

if epic_mod and self:GetCaster():HasModifier("modifier_troll_axes_4") then 
	self.damage = self.damage + epic_mod:GetStackCount()*self:GetCaster():GetTalentValue("modifier_troll_axes_4", "damage")
end 

if legen_mod then 
	self.damage = self.damage*(1 + legen_mod:GetStackCount()*self:GetCaster():GetTalentValue("modifier_troll_axes_legendary", "damage")/100)
end

end




function modifier_troll_warlord_whirling_axes_melee_custom_thinker:OnIntervalThink()
if not IsServer() then return end
if not self:GetParent().start_time then return end

	local elapsed_time = GameRules:GetGameTime() - self:GetParent().start_time
	if not self:GetCaster():IsAlive() then self:GetParent():RemoveSelf() return end
	local hit_radius = self:GetAbility():GetSpecialValueFor("hit_radius")
	local max_range = self:GetAbility():GetSpecialValueFor("max_range")
	local axe_movement_speed = self:GetAbility():GetSpecialValueFor("axe_movement_speed")
	local blind_duration = self:GetAbility():GetSpecialValueFor("blind_duration")
	local whirl_duration = self:GetAbility():GetSpecialValueFor("whirl_duration")
	local caster_location = self:GetCaster():GetAbsOrigin()
	local currentRadius	= self:GetParent().axe_radius 


	local deltaRadius = axe_movement_speed / whirl_duration/2 * FrameTime()
	if elapsed_time >= whirl_duration * 0.65 then
		currentRadius = currentRadius - deltaRadius
	else
		currentRadius = currentRadius + deltaRadius
	end
	currentRadius = math.min( currentRadius, (max_range - hit_radius))
	self:GetParent().axe_radius = currentRadius

	local rotation_angle

	if self.i == 1 then 

		if self:GetParent().side == 1 then
		rotation_angle = elapsed_time * 360
		else
			rotation_angle = elapsed_time * 360 + 180
		end

	else 

		if self:GetParent().side == 1 then
		rotation_angle = elapsed_time * 360 + 90
		else
			rotation_angle = elapsed_time * 360 - 90
		end

	end

	local relPos = Vector( 0, currentRadius, 0 )
	relPos = RotatePosition( Vector(0,0,0), QAngle( 0, -rotation_angle, 0 ), relPos )
	local absPos = GetGroundPosition( relPos + caster_location, self:GetParent() )
	absPos.z = absPos.z + 75
	self:GetParent():SetAbsOrigin( absPos )

	ParticleManager:SetParticleControl(self:GetParent().particle, 0, self:GetParent():GetAbsOrigin())
	ParticleManager:SetParticleControl(self:GetParent().particle, 1, self:GetParent():GetAbsOrigin())
	ParticleManager:SetParticleControl(self:GetParent().particle, 3, self:GetParent():GetAbsOrigin())
	if elapsed_time >= whirl_duration then
		self:GetParent():RemoveSelf()
	end

	local units = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, hit_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, 0, FIND_CLOSEST, false)
	for _, unit in pairs(units) do
		local was_hit = false
		if self:GetAbility() and self.index and self:GetAbility()[self.index] then
			for _, stored_target in ipairs(self:GetAbility()[self.index]) do
				if unit == stored_target then
					was_hit = true
				end
			end
		end
		if was_hit == false then
			table.insert(self:GetAbility()[self.index],unit)
			unit:AddNewModifier(self:GetCaster(), self:GetCaster():BkbAbility(self:GetAbility(), self:GetCaster():HasScepter()), "modifier_troll_warlord_whirling_axes_melee_custom", {duration = blind_duration})


			if self.stun == 1 then 
				unit:EmitSound("BB.Goo_stun") 
				unit:ApplyStun(self:GetAbility(), self:GetCaster():HasScepter(), self:GetCaster(), (1 - unit:GetStatusResistance())*self:GetCaster():GetTalentValue("modifier_troll_axes_4", "stun"))
			end


			if self:GetCaster():GetQuest() == "Troll.Quest_6" and unit:IsRealHero() then 

				local mod = unit:FindModifierByName("modifier_troll_warlord_whirling_axes_ranged_quest")
				if mod then 
					mod:Destroy()
					self:GetCaster():UpdateQuest(1)
				else 
					unit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_troll_warlord_whirling_axes_melee_quest", {duration = self:GetCaster().quest.number})
				end

			end

			ApplyDamage({victim = unit, attacker = self:GetCaster(), damage = self.damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self:GetAbility()})
			unit:EmitSound("Hero_TrollWarlord.WhirlingAxes.Target")

	
		end
	end
end

function modifier_troll_warlord_whirling_axes_melee_custom_thinker:CheckState()
    local state = {
    [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
    [MODIFIER_STATE_NO_HEALTH_BAR]              = true,
    [MODIFIER_STATE_INVULNERABLE]        = true  }
    return state
end

function modifier_troll_warlord_whirling_axes_melee_custom_thinker:OnDestroy()
	if not IsServer() then return end
	--self:GetAbility()[self.index] = nil
	UTIL_Remove(self:GetParent())
end







modifier_troll_warlord_whirling_axes_melee_custom = class({})

function modifier_troll_warlord_whirling_axes_melee_custom:IsPurgable() return not self:GetCaster():HasScepter() end

function modifier_troll_warlord_whirling_axes_melee_custom:OnCreated(params)

function modifier_troll_warlord_whirling_axes_melee_custom:GetTexture() return "troll_warlord_whirling_axes_melee" end


self.ability = self:GetCaster():FindAbilityByName("troll_warlord_whirling_axes_melee_custom")
if not self.ability then self:Destroy() return end

self.miss_chance = self.ability:GetSpecialValueFor("blind_pct")

if not self:GetParent():IsHero() then 
	self.miss_chance = self.ability:GetSpecialValueFor("blind_creeps")
end

end


function modifier_troll_warlord_whirling_axes_melee_custom:DeclareFunctions()
	local decFuns =
		{
			MODIFIER_PROPERTY_MISS_PERCENTAGE,
		}
		
	return decFuns
end

function modifier_troll_warlord_whirling_axes_melee_custom:GetModifierMiss_Percentage()
	return self.miss_chance
end





modifier_troll_warlord_whirling_axes_attack = class({})
function modifier_troll_warlord_whirling_axes_attack:IsHidden() return false end
function modifier_troll_warlord_whirling_axes_attack:IsPurgable() return true end
function modifier_troll_warlord_whirling_axes_attack:GetTexture() return "buffs/quill_cdr" end
function modifier_troll_warlord_whirling_axes_attack:OnCreated(table)

self.damage = self:GetCaster():GetTalentValue("modifier_troll_axes_3", "damage")
if not IsServer() then return end
self.radius = self:GetCaster():GetTalentValue("modifier_troll_axes_3", "radius")
self:SetStackCount(self:GetCaster():GetTalentValue("modifier_troll_axes_3", "max"))

end

function modifier_troll_warlord_whirling_axes_attack:OnRefresh(table)
self:OnCreated(table)
end


function modifier_troll_warlord_whirling_axes_attack:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_ATTACK_LANDED,
	MODIFIER_PROPERTY_TOOLTIP
}
end

function modifier_troll_warlord_whirling_axes_attack:OnTooltip()
return self.damage
end

function modifier_troll_warlord_whirling_axes_attack:OnAttackLanded(params)
if not IsServer() then return end
if self:GetCaster() ~= params.attacker then return end
if not params.target:IsCreep() and not params.target:IsHero() then return end

local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(),  params.target:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, FIND_ANY_ORDER, false )

local particle = ParticleManager:CreateParticle("particles/troll_hit.vpcf", PATTACH_WORLDORIGIN, nil)	
ParticleManager:SetParticleControl(particle, 0, params.target:GetAbsOrigin())

for _,unit in pairs(units) do 

	local real_damage = ApplyDamage({victim = unit, attacker = self:GetCaster(), damage = self.damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self:GetAbility()})
	SendOverheadEventMessage(unit, 4, unit, real_damage, nil)
end


self:DecrementStackCount()

if self:GetStackCount() == 0 then 
	self:Destroy()
end

end



modifier_troll_warlord_whirling_axes_tracker = class({})
function modifier_troll_warlord_whirling_axes_tracker:IsHidden() return true end
function modifier_troll_warlord_whirling_axes_tracker:IsPurgable() return false end
function modifier_troll_warlord_whirling_axes_tracker:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	MODIFIER_EVENT_ON_ATTACK_LANDED
}
end

function modifier_troll_warlord_whirling_axes_tracker:OnCreated()
if not IsServer() then return end 

self:StartIntervalThink(1)
end

function modifier_troll_warlord_whirling_axes_tracker:OnIntervalThink()
if not IsServer() then return end 
if not self:GetParent():HasModifier("modifier_troll_axes_legendary") then return end 

local ranged = self:GetParent():FindModifierByName("modifier_troll_warlord_whirling_axes_ranged_custom_stack")
local melee = self:GetParent():FindModifierByName("modifier_troll_warlord_whirling_axes_melee_custom_stack")

local max = self:GetCaster():GetTalentValue("modifier_troll_axes_legendary", "max")
local duration = 0 
local stack = 0
local type = 0

if ranged then 
	type = 1
 	duration = ranged:GetRemainingTime()
 	stack = ranged:GetStackCount()
elseif melee then
	type = 2 
	stack = melee:GetStackCount()
	duration = melee:GetRemainingTime()
end


CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), 'troll_axes_change',  {type = type, max = max, damage = stack})
	

self:StartIntervalThink(0.1)
end 




function modifier_troll_warlord_whirling_axes_tracker:OnAbilityFullyCast(params)
if not IsServer() then return end
if params.unit~=self:GetParent() then return end
if not params.ability then return end
if params.ability:GetName() ~= "troll_warlord_whirling_axes_melee_custom" and params.ability:GetName() ~= "troll_warlord_whirling_axes_ranged_custom" then return end
if not self:GetParent():HasModifier("modifier_troll_axes_legendary") then return end

local name = "modifier_"..params.ability:GetName().."_stack"

local mod = self:GetParent():FindModifierByName("modifier_troll_warlord_whirling_axes_melee_custom_stack")

if not mod then 
	mod = self:GetParent():FindModifierByName("modifier_troll_warlord_whirling_axes_ranged_custom_stack")
end 

local stack = 0

if mod then 
	stack = mod:GetStackCount()
end 

if stack < self:GetCaster():GetTalentValue("modifier_troll_axes_legendary", "max") then 
	stack = stack + 1
end

print(stack)

self:GetParent():AddNewModifier(self:GetParent(), params.ability, name, {stack = stack, duration = self:GetCaster():GetTalentValue("modifier_troll_axes_legendary", "duration")})

end


function modifier_troll_warlord_whirling_axes_tracker:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end 
if not params.target:IsHero() and not params.target:IsCreep() then return end



local ability = self:GetAbility()
local mod_name = "modifier_troll_warlord_whirling_axes_perma_melee"

if params.ranged_attack then 
	mod_name = "modifier_troll_warlord_whirling_axes_perma_ranged"
	ability = self:GetCaster():FindAbilityByName("troll_warlord_whirling_axes_ranged_custom")
end

if ability and params.target:IsRealHero() then 
	self:GetCaster():AddNewModifier(self:GetCaster(), ability, mod_name, {})
end 




if not self:GetParent():HasModifier("modifier_troll_axes_legendary") then return end

local name = self:GetAbility():GetName()
local part = "particles/sf_refresh_a.vpcf" 
local ability = self:GetParent():FindAbilityByName(name)

if  ability and ability:GetCooldownTimeRemaining() > 0.1 then 
	if self:GetCaster():CdAbility(ability, self:GetCaster():GetTalentValue("modifier_troll_axes_legendary", "cd")) then 
		self:GetCaster():EmitSound("Troll.Axed_cd")
		local particle = ParticleManager:CreateParticle(part, PATTACH_CUSTOMORIGIN, self:GetCaster())
		ParticleManager:SetParticleControlEnt( particle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetOrigin(), true )
		ParticleManager:ReleaseParticleIndex(particle)
	end
end 

name = "troll_warlord_whirling_axes_ranged_custom"
part = "particles/troll_warlord/refresh_ranged.vpcf"

ability = self:GetParent():FindAbilityByName(name)

if ability and ability:GetCooldownTimeRemaining() > 0.1 then 
	if self:GetCaster():CdAbility(ability, self:GetCaster():GetTalentValue("modifier_troll_axes_legendary", "cd")) then 
		self:GetCaster():EmitSound("Troll.Axed_cd")
		local particle = ParticleManager:CreateParticle(part, PATTACH_CUSTOMORIGIN, self:GetCaster())
		ParticleManager:SetParticleControlEnt( particle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetOrigin(), true )
		ParticleManager:ReleaseParticleIndex(particle)
	end

end

end 











modifier_troll_warlord_whirling_axes_melee_custom_stack = class({})
function modifier_troll_warlord_whirling_axes_melee_custom_stack:IsHidden() return true end
function modifier_troll_warlord_whirling_axes_melee_custom_stack:IsPurgable() return false end


function modifier_troll_warlord_whirling_axes_melee_custom_stack:OnCreated(table)
self.damage = self:GetCaster():GetTalentValue("modifier_troll_axes_legendary", "damage")

if not IsServer() then return end

self:GetParent():RemoveModifierByName("modifier_troll_warlord_whirling_axes_ranged_custom_stack")
self:SetStackCount(table.stack)
self.RemoveForDuel = true



local particle_cast = "particles/units/heroes/hero_marci/marci_unleash_stack.vpcf"

self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, self:GetStackCount(), 0 ) )


end

function modifier_troll_warlord_whirling_axes_melee_custom_stack:OnRefresh(table)
if not IsServer() then return end
self:Destroy()
end


function modifier_troll_warlord_whirling_axes_melee_custom_stack:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOOLTIP
}
end

function modifier_troll_warlord_whirling_axes_melee_custom_stack:OnTooltip()
return self:GetStackCount()*self.damage
end


function modifier_troll_warlord_whirling_axes_melee_custom_stack:OnDestroy()

if self.effect_cast then 
	ParticleManager:DestroyParticle(self.effect_cast, true)
	ParticleManager:ReleaseParticleIndex(self.effect_cast)
end

end 





modifier_troll_warlord_whirling_axes_ranged_custom_stack = class({})
function modifier_troll_warlord_whirling_axes_ranged_custom_stack:IsHidden() return true end
function modifier_troll_warlord_whirling_axes_ranged_custom_stack:IsPurgable() return false end


function modifier_troll_warlord_whirling_axes_ranged_custom_stack:OnCreated(table)

self.damage = self:GetCaster():GetTalentValue("modifier_troll_axes_legendary", "damage")

if not IsServer() then return end

self:GetParent():RemoveModifierByName("modifier_troll_warlord_whirling_axes_melee_custom_stack")

self:SetStackCount(table.stack)

self.RemoveForDuel = true

local particle_cast = "particles/units/heroes/hero_marci/orb_damage_stack.vpcf"

self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, self:GetStackCount(), 0 ) )
self:AddParticle(self.effect_cast,false, false, -1, false, false)

end

function modifier_troll_warlord_whirling_axes_ranged_custom_stack:OnRefresh(table)
if not IsServer() then return end
self:Destroy()
end


function modifier_troll_warlord_whirling_axes_ranged_custom_stack:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOOLTIP
}
end

function modifier_troll_warlord_whirling_axes_ranged_custom_stack:OnTooltip()
return self:GetStackCount()*self.damage
end



function modifier_troll_warlord_whirling_axes_ranged_custom_stack:OnDestroy()

if self.effect_cast then 
	ParticleManager:DestroyParticle(self.effect_cast, true)
	ParticleManager:ReleaseParticleIndex(self.effect_cast)
end

end 
















modifier_troll_warlord_whirling_axes_melee_quest = class({})
function modifier_troll_warlord_whirling_axes_melee_quest:IsHidden() return true end
function modifier_troll_warlord_whirling_axes_melee_quest:IsPurgable() return false end



modifier_troll_warlord_whirling_axes_perma_melee = class({})
function modifier_troll_warlord_whirling_axes_perma_melee:IsHidden() return not self:GetCaster():HasModifier("modifier_troll_axes_4") end
function modifier_troll_warlord_whirling_axes_perma_melee:IsPurgable() return false end
function modifier_troll_warlord_whirling_axes_perma_melee:RemoveOnDeath() return false end
function modifier_troll_warlord_whirling_axes_perma_melee:OnCreated()
if not IsServer() then return end 

self.max = self:GetCaster():GetTalentValue("modifier_troll_axes_4", "max", true)
self.attaks = self:GetCaster():GetTalentValue("modifier_troll_axes_4", "attacks", true)

self.count = 1
self:SetStackCount(0)
self:StartIntervalThink(0.5)
end


function modifier_troll_warlord_whirling_axes_perma_melee:OnIntervalThink()
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_troll_axes_4") then return end 

if self:GetStackCount() >= self.max then 


	self:GetParent():EmitSound("BS.Thirst_legendary_active")
	local particle_peffect = ParticleManager:CreateParticle("particles/brist_lowhp_.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	ParticleManager:SetParticleControl(particle_peffect, 0, self:GetCaster():GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_peffect, 2, self:GetCaster():GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(particle_peffect)
	
	self:StartIntervalThink(-1)
end

end 

function modifier_troll_warlord_whirling_axes_perma_melee:OnRefresh()
if not IsServer() then return end 
if self:GetStackCount() >= self.max then return end 


self.count = self.count + 1

if self.count >= self.attaks then 
	self.count = 0 
	self:IncrementStackCount()
end 

end 


function modifier_troll_warlord_whirling_axes_perma_melee:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOOLTIP
}

end 


function modifier_troll_warlord_whirling_axes_perma_melee:OnTooltip()
return self:GetStackCount()*self:GetCaster():GetTalentValue("modifier_troll_axes_4", "damage")
end



modifier_troll_warlord_whirling_axes_perma_ranged = class({})
function modifier_troll_warlord_whirling_axes_perma_ranged:IsHidden() return not self:GetCaster():HasModifier("modifier_troll_axes_4") end
function modifier_troll_warlord_whirling_axes_perma_ranged:IsPurgable() return false end
function modifier_troll_warlord_whirling_axes_perma_ranged:RemoveOnDeath() return false end
function modifier_troll_warlord_whirling_axes_perma_ranged:OnCreated()
if not IsServer() then return end 

self.max = self:GetCaster():GetTalentValue("modifier_troll_axes_4", "max", true)
self.attaks = self:GetCaster():GetTalentValue("modifier_troll_axes_4", "attacks", true)

self.count = 1
self:SetStackCount(0)

self:StartIntervalThink(0.5)
end


function modifier_troll_warlord_whirling_axes_perma_ranged:OnIntervalThink()
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_troll_axes_4") then return end 

if self:GetStackCount() >= self.max then 


	self:GetParent():EmitSound("BS.Thirst_legendary_active")
	local particle_peffect = ParticleManager:CreateParticle("particles/rare_orb_patrol.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	ParticleManager:SetParticleControl(particle_peffect, 0, self:GetCaster():GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_peffect, 2, self:GetCaster():GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(particle_peffect)

	self:StartIntervalThink(-1)
end

end


function modifier_troll_warlord_whirling_axes_perma_ranged:OnRefresh()
if not IsServer() then return end 
if self:GetStackCount() >= self.max then return end 


self.count = self.count + 1

if self.count >= self.attaks then 
	self.count = 0 
	self:IncrementStackCount()
end 

end 


function modifier_troll_warlord_whirling_axes_perma_ranged:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOOLTIP
}

end 


function modifier_troll_warlord_whirling_axes_perma_ranged:OnTooltip()
return self:GetStackCount()*self:GetCaster():GetTalentValue("modifier_troll_axes_4", "damage")
end















modifier_troll_warlord_whirling_axes_buff = class({})
function modifier_troll_warlord_whirling_axes_buff:IsHidden() return false end
function modifier_troll_warlord_whirling_axes_buff:IsPurgable() return false end
function modifier_troll_warlord_whirling_axes_buff:GetTexture() return "buffs/Crit_blood" end
function modifier_troll_warlord_whirling_axes_buff:OnCreated()

--self.damage = self:GetCaster():GetTalentValue("modifier_troll_axes_6", "damage")
--self.status = self:GetCaster():GetTalentValue("modifier_troll_axes_6", "status")
self.speed = self:GetCaster():GetTalentValue("modifier_troll_axes_6", "speed")

self.heal = self:GetCaster():GetTalentValue("modifier_troll_axes_2", "heal")
self.creeps = self:GetCaster():GetTalentValue("modifier_troll_axes_2", "creeps")
end

function modifier_troll_warlord_whirling_axes_buff:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
--	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
--	MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
  	MODIFIER_EVENT_ON_TAKEDAMAGE,
}
end

function modifier_troll_warlord_whirling_axes_buff:GetModifierMoveSpeedBonus_Percentage()
return self.speed
end

function modifier_troll_warlord_whirling_axes_buff:GetModifierStatusResistanceStacking()
	return self.status
end
function modifier_troll_warlord_whirling_axes_buff:GetModifierIncomingDamage_Percentage()

if IsServer() then 

	self:GetParent():EmitSound("Juggernaut.Parry")
	local particle = ParticleManager:CreateParticle( "particles/jugg_parry.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControlEnt( particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetParent():GetAbsOrigin(), true )
	ParticleManager:SetParticleControl( particle, 1, self:GetParent():GetAbsOrigin() )
end

	return self.damage
end

function modifier_troll_warlord_whirling_axes_buff:GetEffectName()
if self:GetCaster():HasModifier("modifier_troll_axes_6") then 
	--return "particles/items4_fx/ascetic_cap.vpcf"
end

end 






function modifier_troll_warlord_whirling_axes_buff:OnTakeDamage(params)
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_troll_axes_2") then return end
if self:GetParent() ~= params.attacker then return end
if not params.unit:IsCreep() and not params.unit:IsHero() then return end
if self:GetParent() == params.unit then return end
if bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then return end

local heal = self.heal/100
if params.unit:IsCreep() then 
  heal = heal / self.creeps
end

heal = heal*params.damage

self:GetParent():GenericHeal(heal, self:GetAbility(), true)

end










modifier_troll_warlord_whirling_axes_charge = class({})

function modifier_troll_warlord_whirling_axes_charge:IsDebuff() return false end
function modifier_troll_warlord_whirling_axes_charge:IsHidden() return true end
function modifier_troll_warlord_whirling_axes_charge:IsPurgable() return true end

function modifier_troll_warlord_whirling_axes_charge:OnCreated(kv)
if not IsServer() then return end
self.pfx = ParticleManager:CreateParticle("particles/items_fx/force_staff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())

local distance = self:GetCaster():GetTalentValue("modifier_troll_axes_6", "distance")

self.point = self:GetParent():GetAbsOrigin() + self:GetParent():GetForwardVector()*distance


self.angle = self:GetParent():GetForwardVector():Normalized()

self.distance =  distance / ( self:GetDuration() / FrameTime())

self.targets = {}

if self:ApplyHorizontalMotionController() == false then
    self:Destroy()
end

end

function modifier_troll_warlord_whirling_axes_charge:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_DISABLE_TURNING
}
end




function modifier_troll_warlord_whirling_axes_charge:GetModifierDisableTurning() return 1 end

function modifier_troll_warlord_whirling_axes_charge:GetEffectName() return "particles/muerta/muerta_gun_active.vpcf" end
function modifier_troll_warlord_whirling_axes_charge:GetStatusEffectName() return "particles/status_fx/status_effect_forcestaff.vpcf" end
function modifier_troll_warlord_whirling_axes_charge:StatusEffectPriority() return 100 end

function modifier_troll_warlord_whirling_axes_charge:OnDestroy()
    if not IsServer() then return end
    self:GetParent():InterruptMotionControllers( true )
    ParticleManager:DestroyParticle(self.pfx, false)
    ParticleManager:ReleaseParticleIndex(self.pfx)



	local dir = self:GetParent():GetForwardVector()
    dir.z = 0
    self:GetParent():SetForwardVector(dir)
    self:GetParent():FaceTowards(self:GetParent():GetAbsOrigin() + dir*10)

    ResolveNPCPositions(self:GetParent():GetAbsOrigin(), 128)

end


function modifier_troll_warlord_whirling_axes_charge:UpdateHorizontalMotion( me, dt )
    if not IsServer() then return end
    local pos = self:GetParent():GetAbsOrigin()
    GridNav:DestroyTreesAroundPoint(pos, 80, false)
    local pos_p = self.angle * self.distance
    local next_pos = GetGroundPosition(pos + pos_p,self:GetParent())
    self:GetParent():SetAbsOrigin(next_pos)


end

function modifier_troll_warlord_whirling_axes_charge:OnHorizontalMotionInterrupted()
    self:Destroy()
end






modifier_troll_warlord_whirling_axes_melee_cd = class({})
function modifier_troll_warlord_whirling_axes_melee_cd:IsHidden() return true end
function modifier_troll_warlord_whirling_axes_melee_cd:IsPurgable() return false end
function modifier_troll_warlord_whirling_axes_melee_cd:RemoveOnDeath() return false end
function modifier_troll_warlord_whirling_axes_melee_cd:OnCreated()
self.RemoveForDuel = true
end