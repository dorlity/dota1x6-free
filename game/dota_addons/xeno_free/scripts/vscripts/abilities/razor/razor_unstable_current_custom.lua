LinkLuaModifier("modifier_razor_unstable_current_custom", "abilities/razor/razor_unstable_current_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_razor_unstable_current_custom_slow", "abilities/razor/razor_unstable_current_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_razor_unstable_current_custom_cd", "abilities/razor/razor_unstable_current_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_razor_unstable_current_custom_legendary", "abilities/razor/razor_unstable_current_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_razor_unstable_current_custom_legendary_charge", "abilities/razor/razor_unstable_current_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_razor_unstable_current_custom_damage", "abilities/razor/razor_unstable_current_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_razor_unstable_current_custom_heal", "abilities/razor/razor_unstable_current_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_razor_unstable_current_custom_heal_count", "abilities/razor/razor_unstable_current_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_razor_unstable_current_custom_stun_cd", "abilities/razor/razor_unstable_current_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_razor_unstable_current_custom_stats", "abilities/razor/razor_unstable_current_custom", LUA_MODIFIER_MOTION_NONE)

razor_unstable_current_custom = class({})


function razor_unstable_current_custom:Precache(context)

PrecacheResource( "particle", "particles/razor/surge_stacks.vpcf", context )
PrecacheResource( "particle", "particles/razor/surge_range.vpcf", context )
PrecacheResource( "particle", "particles/razor/surge_speed.vpcf", context )
PrecacheResource( "particle", "particles/razor/surge_damage_stack.vpcf", context )

end




function razor_unstable_current_custom:GetAbilityTextureName()
if self:GetCaster():HasModifier("modifier_razor_unstable_current_custom_legendary") then 
	return "unstable_current_stop"
end 

return "razor_unstable_current"
end 


function razor_unstable_current_custom:GetIntrinsicModifierName()
if not self:GetCaster():IsRealHero() then return end
return "modifier_razor_unstable_current_custom"
end

function razor_unstable_current_custom:GetBehavior()

if self:GetCaster():HasModifier("modifier_razor_current_7") then 
	return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_ROOT_DISABLES
else 
	return DOTA_ABILITY_BEHAVIOR_PASSIVE
end 

end 

function razor_unstable_current_custom:GetCastRange(vLocation, hTarget)
if IsClient() then 
	return self:GetSpecialValueFor("strike_search_radius")
end 

end 

function razor_unstable_current_custom:GetCooldown(iLevel)

if self:GetCaster():HasModifier("modifier_razor_current_7") then 
	return self:GetCaster():GetTalentValue("modifier_razor_current_7", "cd")
end

end 

function razor_unstable_current_custom:OnSpellStart()

local mod = self:GetCaster():FindModifierByName("modifier_razor_unstable_current_custom_legendary")

if mod then 
	mod:Destroy()
else 
	local duration = self:GetCaster():GetTalentValue("modifier_razor_current_7", "duration")
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_razor_unstable_current_custom_legendary", {duration = duration})
	self:EndCooldown()
	self:StartCooldown(0.3)
end 


end 


function razor_unstable_current_custom:GetDamage(target, k)
if not IsServer() then return end

local damage = self:GetSpecialValueFor("strike_damage")

if target then 
	local mod = target:FindModifierByName("modifier_razor_unstable_current_custom_damage")

	if mod then 
		damage = damage + self:GetCaster():GetTalentValue("modifier_razor_current_4", "damage")*mod:GetStackCount()
	end 
end 

if k then 
	damage = damage*k
end 

return damage
end 


function razor_unstable_current_custom:ApplySlow(target)
if not IsServer() then return end

local duration = self:GetSpecialValueFor("strike_slow_duration")

target:AddNewModifier(self:GetCaster(), self, "modifier_razor_unstable_current_custom_slow", {duration = (1 - target:GetStatusResistance())*duration})

end 


modifier_razor_unstable_current_custom = class({})
function modifier_razor_unstable_current_custom:IsHidden() return not self:GetParent():HasModifier("modifier_razor_current_4")
and not self:GetParent():HasModifier("modifier_razor_current_5") end
function modifier_razor_unstable_current_custom:IsPurgable() return false end
function modifier_razor_unstable_current_custom:GetTexture() return "razor_unstable_current" end

function modifier_razor_unstable_current_custom:OnCreated(table)

self.caster = self:GetCaster()

self.move = self:GetAbility():GetSpecialValueFor("self_movement_speed_pct")
self.chance = self:GetAbility():GetSpecialValueFor("strike_pct_chance")
self.count  = self:GetAbility():GetSpecialValueFor("strike_target_count")
self.radius = self:GetAbility():GetSpecialValueFor("strike_search_radius")
self.cd = self:GetAbility():GetSpecialValueFor("strike_internal_cd")

self.damage_duration = self:GetCaster():GetTalentValue("modifier_razor_current_4", "duration", true)
self.heal_duration = self:GetCaster():GetTalentValue("modifier_razor_current_2", "duration", true)

self.stun_duration = self:GetCaster():GetTalentValue("modifier_razor_current_6", "stun", true)
self.stun_cd = self:GetCaster():GetTalentValue("modifier_razor_current_6", "cd", true)

self.max_move = self:GetCaster():GetTalentValue("modifier_razor_current_5", "speed_max", true)
self.move_bonus = self:GetCaster():GetTalentValue("modifier_razor_current_5", "speed_bonus", true)

self.distance_move = self.caster:GetTalentValue("modifier_razor_current_4", "distance", true)

self.cd_items = self.caster:GetTalentValue("modifier_razor_current_5", "cd", true)

self.stats_stack = self.caster:GetTalentValue("modifier_razor_current_3", "spell", true)
self.stats_duration = self.caster:GetTalentValue("modifier_razor_current_3", "duration", true)

if not IsServer() then return end 

self:SetStackCount(0)
self.old_pos = self.caster:GetAbsOrigin()
self:StartIntervalThink(1)
end 

function modifier_razor_unstable_current_custom:OnRefresh(table)
self:OnCreated()
end 



function modifier_razor_unstable_current_custom:OnIntervalThink()
if not IsServer() then return end 
if not self.caster:HasModifier("modifier_razor_current_4") and not self.caster:HasModifier("modifier_razor_current_5") then 
	self.old_pos = self.caster:GetAbsOrigin()
	return 
end 

local new_pos = self.caster:GetAbsOrigin()
local dist = (new_pos - self.old_pos):Length2D()

local targets = self.caster:FindTargets(self.radius)

if #targets > 0 then 
	self:SetStackCount(self:GetStackCount() + dist)

	if self:GetStackCount() >= self.distance_move then 
		self:SetStackCount(0)

		if self.caster:HasModifier("modifier_razor_current_4") then 
			self:PassiveProc(nil, true)
		end 

		if self.caster:HasModifier("modifier_razor_current_5") then 
			self.caster:CdItems(self.cd_items)
		end 
	end 
end 

self.old_pos = new_pos


self:StartIntervalThink(0.1)
end 



function modifier_razor_unstable_current_custom:PassiveProc(attacker, no_cd, spell)
if not IsServer() then return end
if self.caster:PassivesDisabled() then return end

local cd = self.cd + self:GetCaster():GetTalentValue("modifier_razor_current_1", "cd")

if self.caster:HasModifier("modifier_razor_current_2") then 

	self.caster:AddNewModifier(self.caster, self:GetAbility(), "modifier_razor_unstable_current_custom_heal", {duration = self.heal_duration})
	--self.caster:AddNewModifier(self.caster, self:GetAbility(), "modifier_razor_unstable_current_custom_heal_count", {duration = self.heal_duration})
end 


self.caster:EmitSound("Hero_Razor.UnstableCurrent.Strike")

if not no_cd then 
	self.caster:AddNewModifier(self.caster, self:GetAbility(), "modifier_razor_unstable_current_custom_cd", {duration = cd})
end 

local heroes = FindUnitsInRadius( self.caster:GetTeamNumber(), self.caster:GetOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
local creeps = FindUnitsInRadius( self.caster:GetTeamNumber(), self.caster:GetOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )

local targets = {}

if attacker then 
	table.insert(targets, attacker)
end 

for _,hero in pairs(heroes) do 
	if #targets < self.count then
		if not attacker or attacker ~= hero then 
 			table.insert(targets, hero)
 		end 
	else 
		break
	end 
end 

for _,creep in pairs(creeps) do 
	if #targets < self.count then
		if not attacker or attacker ~= creep then 
 			table.insert(targets, creep)
 		end 
	else 
		break
	end 
end 

local count = 0

local damage_table = {attacker = self.caster, ability = self:GetAbility(), damage_type = DAMAGE_TYPE_MAGICAL}

for _,target in pairs(targets) do 

	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_razor/razor_unstable_current.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self.caster )
	ParticleManager:SetParticleControlEnt(effect_cast, 0, self.caster, PATTACH_POINT_FOLLOW, "attach_hitloc", self.caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(effect_cast, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex( effect_cast )

	damage_table.damage = self:GetAbility():GetDamage(target)
	damage_table.victim = target

	self:GetAbility():ApplySlow(target)

	if spell and attacker and attacker == target and not target:HasModifier("modifier_razor_unstable_current_custom_stun_cd") and self.caster:HasModifier("modifier_razor_current_6") then 
		attacker:AddNewModifier(self.caster, self:GetAbility(), "modifier_stunned", {duration = (1 - attacker:GetStatusResistance())*self.stun_duration})
		attacker:AddNewModifier(self.caster, self:GetAbility(), "modifier_razor_unstable_current_custom_stun_cd", {duration = self.stun_cd})
		
		ParticleManager:ReleaseParticleIndex( ParticleManager:CreateParticle( "particles/econ/items/zeus/zeus_immortal_2021/zeus_immortal_2021_static_field.vpcf", PATTACH_ABSORIGIN_FOLLOW, attacker) )

		attacker:EmitSound("Razor.Surge_stun")
	end 

	local real_damage = ApplyDamage(damage_table)	

	if self.caster:GetQuest() == "Razor.Quest_7" and target:IsRealHero() then 
		self.caster:UpdateQuest(1)
	end 

	target:EmitSound("Hero_Razor.UnstableCurrent.Target")

	if self.caster:HasModifier("modifier_razor_current_4") and no_cd then 
		target:AddNewModifier(self.caster, self:GetAbility(), "modifier_razor_unstable_current_custom_damage", {duration = self.damage_duration})
	end 

	count = count + 1 
	if count >= self.count then 
		break
	end 
end 

if #targets > 0 and self.caster:HasModifier("modifier_razor_current_7") and not self.caster:HasModifier("modifier_razor_unstable_current_custom_legendary") then 
	self.caster:CdAbility(self:GetAbility(), self.caster:GetTalentValue("modifier_razor_current_7", "cd_inc"))
end 

end 


function modifier_razor_unstable_current_custom:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_ATTACK_LANDED,
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    MODIFIER_PROPERTY_MOVESPEED_LIMIT,
    MODIFIER_PROPERTY_MOVESPEED_MAX,
    MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
	MODIFIER_EVENT_ON_ABILITY_FULLY_CAST
}
end


function modifier_razor_unstable_current_custom:GetModifierMoveSpeedBonus_Percentage()
if self:GetParent():PassivesDisabled() then return end
local bonus = 0 

if self:GetCaster():HasModifier("modifier_razor_current_5") then 
	bonus = self.move_bonus
end 

return self.move + bonus
end



function modifier_razor_unstable_current_custom:GetModifierIgnoreMovespeedLimit( params )
if self:GetCaster():HasModifier("modifier_razor_current_5") then 
  return 1
end
    return 0
end

function modifier_razor_unstable_current_custom:GetModifierMoveSpeed_Max( params )
if self:GetCaster():HasModifier("modifier_razor_current_5") then 
  return self.max_move
end

return 
end

function modifier_razor_unstable_current_custom:GetModifierMoveSpeed_Limit()
if self:GetCaster():HasModifier("modifier_razor_current_5") then 
  return self.max_move
end

return 
end





function modifier_razor_unstable_current_custom:OnAbilityFullyCast(params)
if not IsServer() then return end
if not params.ability then return end
if not params.ability:GetCaster() then return end
if params.ability:GetCaster():GetTeamNumber() == self:GetParent():GetTeamNumber() then return end
if not params.target then return end
if params.target and params.target ~= self:GetParent() then return end

if self.caster:HasModifier("modifier_razor_current_3") then 

	for i = 1,self.stats_stack do 
		self.caster:AddNewModifier(self.caster, self:GetAbility(), "modifier_razor_unstable_current_custom_stats", {duration = self.stats_duration})
	end
end 

if params.ability:IsItem() and not self.caster:HasModifier("modifier_razor_current_6") then return end
if self.caster:HasModifier("modifier_razor_unstable_current_custom_cd") then return end

self:PassiveProc(params.ability:GetCaster(), false, true)
end 

function modifier_razor_unstable_current_custom:OnAttackLanded(params)
if not IsServer() then return end 
if self.caster  ~= params.target then return end 
if not params.attacker:IsHero() and not params.attacker:IsCreep() then return end 

if self.caster:HasModifier("modifier_razor_current_3") then 
	self.caster:AddNewModifier(self.caster, self:GetAbility(), "modifier_razor_unstable_current_custom_stats", {duration = self.stats_duration})
end 


if self.caster:HasModifier("modifier_razor_unstable_current_custom_cd") then return end
local chance = self.chance + self.caster:GetTalentValue("modifier_razor_current_1", "chance")

if RollPseudoRandomPercentage(chance ,3180,self.caster) then 
	self:PassiveProc(params.attacker)
end 

end 



modifier_razor_unstable_current_custom_slow = class({})
function modifier_razor_unstable_current_custom_slow:IsHidden() return false end
function modifier_razor_unstable_current_custom_slow:IsPurgable() return true end
function modifier_razor_unstable_current_custom_slow:OnCreated()


self.slow = self:GetAbility():GetSpecialValueFor("strike_move_slow_pct")*-1
end 

function modifier_razor_unstable_current_custom_slow:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end

function modifier_razor_unstable_current_custom_slow:GetModifierMoveSpeedBonus_Percentage()
return self.slow
end


modifier_razor_unstable_current_custom_cd = class({})
function modifier_razor_unstable_current_custom_cd:IsHidden() return false end
function modifier_razor_unstable_current_custom_cd:IsPurgable() return false end
function modifier_razor_unstable_current_custom_cd:IsDebuff() return true end



modifier_razor_unstable_current_custom_legendary = class({})
function modifier_razor_unstable_current_custom_legendary:IsHidden() return true end
function modifier_razor_unstable_current_custom_legendary:IsPurgable() return false end
function modifier_razor_unstable_current_custom_legendary:OnCreated()

self.slow = self:GetCaster():GetTalentValue("modifier_razor_current_7", "slow")
self.caster = self:GetCaster()

self.full_time = self:GetDuration()


self.max_distance = self:GetCaster():GetTalentValue("modifier_razor_current_7", "max_distance")
self.speed = self:GetCaster():GetTalentValue("modifier_razor_current_7", "charge_speed")

if not IsServer() then return end

self.caster:EmitSound("Razor.Surge_cast")
self.caster:EmitSound("Razor.Surge_cast_loop")

self.particle = ParticleManager:CreateParticle("particles/razor/surge_stacks.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
self:AddParticle(self.particle, false, false, -1, false, false)



self.aim_particle = ParticleManager:CreateParticleForTeam("particles/razor/surge_range.vpcf", PATTACH_OVERHEAD_FOLLOW, self.caster, self.caster:GetTeamNumber())
self:Particle()
self:AddParticle(self.aim_particle, false, false, -1, false, false)


self.visual_count = 6
self:VisualStack()

self.stack = (self.full_time) / self.visual_count
self.count = 0
self.interval = 0.01

self.effect_stack = 0.2
self.effect_count = 0

self:StartIntervalThink(self.interval)
end 

function modifier_razor_unstable_current_custom_legendary:CheckState()
return
{
	[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true
}
end

function modifier_razor_unstable_current_custom_legendary:Particle()
if not IsServer() then return end
if not self.aim_particle then return end

local distance = (self:GetElapsedTime()/self.full_time) * self.max_distance

local point = self.caster:GetAbsOrigin() + self.caster:GetForwardVector()*distance

ParticleManager:SetParticleControl(self.aim_particle, 0, self.caster:GetAbsOrigin())
ParticleManager:SetParticleControl(self.aim_particle, 1, point)
end 




function modifier_razor_unstable_current_custom_legendary:VisualStack()
if not IsServer() then return end 
if not self.particle then return end

for i = 1, self.visual_count do 
	if i <= self:GetStackCount() then 
		ParticleManager:SetParticleControl(self.particle, i, Vector(1, 0, 0))	
	else 
		ParticleManager:SetParticleControl(self.particle, i, Vector(0, 0, 0))	
	end
end

end 


function modifier_razor_unstable_current_custom_legendary:OnIntervalThink()
if not IsServer() then return end 

self:Particle()

self.count = self.count + self.interval

if self.count >= self.stack then 
	self.count = 0
	self:IncrementStackCount()
	self:VisualStack()
end 


self.effect_count = self.effect_count + self.interval 

if self.effect_count < self.effect_stack then return end 
self.effect_count = 0


self:GetParent():EmitSound("Razor.Surge_cast_lightning")

AddFOWViewer(self.caster:GetTeamNumber(), self.caster:GetAbsOrigin(), self.max_distance, self.effect_stack, false)

local point = self.caster:GetAbsOrigin() + RandomVector(150)

local cast_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_arc_warden/arc_warden_flux_cast.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(cast_particle, 0, point)
ParticleManager:SetParticleControl(cast_particle, 1, self.caster:GetAbsOrigin() + Vector(0,0,150))
ParticleManager:SetParticleControl(cast_particle, 2, point)
ParticleManager:ReleaseParticleIndex(cast_particle)

ParticleManager:ReleaseParticleIndex( ParticleManager:CreateParticle( "particles/econ/items/zeus/zeus_immortal_2021/zeus_immortal_2021_static_field.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.caster) )

end 


function modifier_razor_unstable_current_custom_legendary:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
}
end

function modifier_razor_unstable_current_custom_legendary:GetModifierMoveSpeedBonus_Percentage()
return self.slow
end


function modifier_razor_unstable_current_custom_legendary:OnDestroy()
if not IsServer() then return end


self:GetParent():StopSound("Razor.Surge_cast_loop")
self:GetParent():StopSound("Razor.Surge_cast")

self:GetAbility():EndCooldown()
self:GetAbility():UseResources(false, false, false, true)

local distance = (self:GetElapsedTime()/self.full_time) * self.max_distance

local duration = distance/self.speed

self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_razor_unstable_current_custom_legendary_charge", {distance = distance, duration = duration})
end





modifier_razor_unstable_current_custom_legendary_charge = class({})

function modifier_razor_unstable_current_custom_legendary_charge:IsDebuff() return false end
function modifier_razor_unstable_current_custom_legendary_charge:IsHidden() return true end
function modifier_razor_unstable_current_custom_legendary_charge:IsPurgable() return false end

function modifier_razor_unstable_current_custom_legendary_charge:OnCreated(kv)
if not IsServer() then return end

self.caster = self:GetCaster()

self.pfx = ParticleManager:CreateParticle("particles/razor/surge_speed.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.caster)
ParticleManager:SetParticleControl(self.pfx, 0, self.caster:GetAbsOrigin())
ParticleManager:SetParticleControl(self.pfx, 1, self.caster:GetAbsOrigin())
self:AddParticle( self.pfx, false, false, -1, false, false )

self.caster:EmitSound("Razor.Surge_charge_1")
self.caster:EmitSound("Razor.Surge_charge_2")

self.caster:StartGesture(ACT_DOTA_RUN)

self.speed = self:GetCaster():GetTalentValue("modifier_razor_current_7", "charge_speed")
self.stun = self:GetCaster():GetTalentValue("modifier_razor_current_7", "stun")
self.stun_knock = self:GetCaster():GetTalentValue("modifier_razor_current_7", "stun_knock")
self.max_distance = self:GetCaster():GetTalentValue("modifier_razor_current_7", "max_distance")

self.k = math.min(1, kv.distance/self.max_distance) * self:GetCaster():GetTalentValue("modifier_razor_current_7", "max_damage") /100

self.damage_table = {attacker = self.caster, ability = self:GetAbility(), damage_type = DAMAGE_TYPE_MAGICAL}

self.dt = 0.01
self.aoe = 150

self.distance = (kv.distance)/(kv.duration/self.dt)

self.angle = self:GetParent():GetForwardVector():Normalized()
self.origin = self.caster:GetAbsOrigin()

self.targets = {}

self.effect_count = 0 
self.effect_stack = 0.07

self:StartIntervalThink(self.dt)
end


function modifier_razor_unstable_current_custom_legendary_charge:OnIntervalThink()
if not IsServer() then return end

if self.caster:IsCurrentlyVerticalMotionControlled() or self.caster:IsCurrentlyHorizontalMotionControlled() 
	or self.caster:IsHexed() or self.caster:IsStunned() then 
	self:Destroy()
	return
end

self:Motion()
self:CheckTargets()

self.effect_count = self.effect_count + self.dt 

if self.effect_count < self.effect_stack then return end 

self.effect_count = 0

local point = self.caster:GetAbsOrigin() + RandomVector(150)

local cast_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_arc_warden/arc_warden_flux_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.caster)
ParticleManager:SetParticleControlEnt(cast_particle, 0, self.caster, PATTACH_POINT_FOLLOW, "attach_hitloc", self.caster:GetAbsOrigin(), true)
ParticleManager:SetParticleControl(cast_particle, 1, point)
ParticleManager:SetParticleControlEnt(cast_particle, 2, self.caster, PATTACH_POINT_FOLLOW, "attach_hitloc", self.caster:GetAbsOrigin(), true)
ParticleManager:ReleaseParticleIndex(cast_particle)

ParticleManager:ReleaseParticleIndex( ParticleManager:CreateParticle( "particles/econ/items/zeus/zeus_immortal_2021/zeus_immortal_2021_static_field.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.caster) )

end 



function modifier_razor_unstable_current_custom_legendary_charge:Motion()
if not IsServer() then return end

local pos = self.caster:GetAbsOrigin()
GridNav:DestroyTreesAroundPoint(pos, 80, false)

local pos_p = self.angle * self.distance

local next_pos = GetGroundPosition(pos + pos_p,self.caster)
self.caster:SetAbsOrigin(next_pos)

end


function modifier_razor_unstable_current_custom_legendary_charge:CheckTargets()
if not IsServer() then return end 

local targets = self.caster:FindTargets(self.aoe)

for _,target in pairs(targets) do 
	if not self.targets[target] then 
		self.targets[target] = true

		target:EmitSound("Razor.Surge_charge_damage")

		ParticleManager:ReleaseParticleIndex( ParticleManager:CreateParticle( "particles/econ/items/zeus/zeus_immortal_2021/zeus_immortal_2021_static_field.vpcf", PATTACH_ABSORIGIN_FOLLOW, target) )

		self.damage_table.victim = target
		self.damage_table.damage = self:GetAbility():GetDamage(target, self.k)
		self:GetAbility():ApplySlow(target)

		ApplyDamage(self.damage_table)
		if not (target:IsCurrentlyHorizontalMotionControlled() or target:IsCurrentlyVerticalMotionControlled()) then

			local direction = target:GetOrigin()-self.caster:GetAbsOrigin()
			direction.z = 0
			direction = direction:Normalized()

			local knockbackProperties =
			{
			  center_x = self.caster:GetOrigin().x,
			  center_y = self.caster:GetOrigin().y,
			  center_z = self.caster:GetOrigin().z,
			  duration = self.stun,
			  knockback_duration = self.stun,
			  knockback_distance = self.stun_knock,
			  knockback_height = 30,
			  should_stun = 1,
			}
			target:AddNewModifier( self:GetCaster(), self, "modifier_knockback", knockbackProperties )
		end

	end 
end 


end 


function modifier_razor_unstable_current_custom_legendary_charge:CheckState()
return
{
	[MODIFIER_STATE_ROOTED] = true
}
end

function modifier_razor_unstable_current_custom_legendary_charge:DeclareFunctions()
return
{
 	MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
    MODIFIER_PROPERTY_DISABLE_TURNING,
	MODIFIER_EVENT_ON_ORDER,
}
end


function modifier_razor_unstable_current_custom_legendary_charge:OnOrder( params )
if params.unit~=self:GetParent() then return end

if params.order_type==DOTA_UNIT_ORDER_STOP or params.order_type==DOTA_UNIT_ORDER_HOLD_POSITION then
	self:Destroy()
end

end


function modifier_razor_unstable_current_custom_legendary_charge:GetActivityTranslationModifiers()
    return "haste"
end


function modifier_razor_unstable_current_custom_legendary_charge:GetModifierDisableTurning() return 1 end

function modifier_razor_unstable_current_custom_legendary_charge:GetEffectName() return "" end
function modifier_razor_unstable_current_custom_legendary_charge:GetStatusEffectName() return "particles/status_fx/status_effect_forcestaff.vpcf" end
function modifier_razor_unstable_current_custom_legendary_charge:StatusEffectPriority() return 100 end

function modifier_razor_unstable_current_custom_legendary_charge:OnDestroy()
if not IsServer() then return end

self.caster:FadeGesture(ACT_DOTA_RUN)

local dir = self:GetParent():GetForwardVector()
dir.z = 0
self:GetParent():SetForwardVector(dir)
self:GetParent():FaceTowards(self:GetParent():GetAbsOrigin() + dir*10)

ResolveNPCPositions(self:GetParent():GetAbsOrigin(), 128)

end





modifier_razor_unstable_current_custom_damage = class({})
function modifier_razor_unstable_current_custom_damage:IsHidden() return true end
function modifier_razor_unstable_current_custom_damage:IsPurgable() return false end
function modifier_razor_unstable_current_custom_damage:OnCreated()
if not IsServer() then return end 

self:SetStackCount(1)
self.parent = self:GetParent()

self.particle = ParticleManager:CreateParticle("particles/razor/surge_damage_stack.vpcf", PATTACH_OVERHEAD_FOLLOW, self.parent)
ParticleManager:SetParticleControl(self.particle, 1, Vector(0, self:GetStackCount(), 0))
self:AddParticle(self.particle, false, false, -1, false, false)

self.max = self:GetCaster():GetTalentValue("modifier_razor_current_4", "max")
end 

function modifier_razor_unstable_current_custom_damage:OnRefresh()
if not IsServer() then return end 
if self:GetStackCount() >= self.max then return end 

self:IncrementStackCount()

if self.particle then 
	ParticleManager:SetParticleControl(self.particle, 1, Vector(0, self:GetStackCount(), 0))
end 

end 







modifier_razor_unstable_current_custom_heal = class({})
function modifier_razor_unstable_current_custom_heal:IsHidden() return false end
function modifier_razor_unstable_current_custom_heal:IsPurgable() return false end
function modifier_razor_unstable_current_custom_heal:GetTexture() return "buffs/surge_heal" end
--function modifier_razor_unstable_current_custom_heal:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_razor_unstable_current_custom_heal:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE
}
end


function modifier_razor_unstable_current_custom_heal:OnCreated()
self.heal = self:GetCaster():GetTalentValue("modifier_razor_current_2", "heal")/self:GetCaster():GetTalentValue("modifier_razor_current_2", "duration")
end 

function modifier_razor_unstable_current_custom_heal:GetModifierHealthRegenPercentage()
return self.heal
end




modifier_razor_unstable_current_custom_heal_count = class({})
function modifier_razor_unstable_current_custom_heal_count:GetTexture() return "buffs/surge_heal" end
function modifier_razor_unstable_current_custom_heal_count:IsHidden() return false end
function modifier_razor_unstable_current_custom_heal_count:IsPurgable() return false end
function modifier_razor_unstable_current_custom_heal_count:OnCreated(table)

self.heal = self:GetCaster():GetTalentValue("modifier_razor_current_2", "heal")/self:GetCaster():GetTalentValue("modifier_razor_current_2", "duration")
if not IsServer() then return end
self:SetStackCount(1)
end

function modifier_razor_unstable_current_custom_heal_count:OnRefresh(table)
if not IsServer() then return end

self:IncrementStackCount()
end

function modifier_razor_unstable_current_custom_heal_count:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOOLTIP
}
end

function modifier_razor_unstable_current_custom_heal_count:OnTooltip()
return self:GetStackCount()*self.heal
end



modifier_razor_unstable_current_custom_stun_cd = class({})
function modifier_razor_unstable_current_custom_stun_cd:IsHidden() return true end
function modifier_razor_unstable_current_custom_stun_cd:IsPurgable() return false end
function modifier_razor_unstable_current_custom_stun_cd:OnCreated()

self.RemoveForDuel = true 
end

function modifier_razor_unstable_current_custom_stun_cd:RemoveOnDeath() return false end


modifier_razor_unstable_current_custom_stats = class({})
function modifier_razor_unstable_current_custom_stats:IsHidden() return false end
function modifier_razor_unstable_current_custom_stats:IsPurgable() return false end
function modifier_razor_unstable_current_custom_stats:GetTexture() return "buffs/surge_stats" end
function modifier_razor_unstable_current_custom_stats:OnCreated()

self.max = self:GetCaster():GetTalentValue("modifier_razor_current_3", 'max')
self.agi = self:GetCaster():GetTalentValue("modifier_razor_current_3", "agi")
self.str = self:GetCaster():GetTalentValue("modifier_razor_current_3", "str")

if not IsServer() then return end 

self:SetStackCount(1)
self:GetCaster():CalculateStatBonus(true)
end 

function modifier_razor_unstable_current_custom_stats:OnRefresh()
if not IsServer() then return end 
if self:GetStackCount() >= self.max then return end 

self:IncrementStackCount()
self:GetCaster():CalculateStatBonus(true)
end 


function modifier_razor_unstable_current_custom_stats:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	MODIFIER_PROPERTY_STATS_AGILITY_BONUS
}
end

function modifier_razor_unstable_current_custom_stats:GetModifierBonusStats_Agility()
return self:GetStackCount()*self.agi
end

function modifier_razor_unstable_current_custom_stats:GetModifierBonusStats_Strength()
return self:GetStackCount()*self.str
end