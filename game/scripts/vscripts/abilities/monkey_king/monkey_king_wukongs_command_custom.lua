LinkLuaModifier("modifier_monkey_king_wukongs_command_custom_soldier_active", "abilities/monkey_king/monkey_king_wukongs_command_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_monkey_king_wukongs_command_custom_thinker", "abilities/monkey_king/monkey_king_wukongs_command_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_monkey_king_wukongs_command_custom_thinker_delay", "abilities/monkey_king/monkey_king_wukongs_command_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_monkey_king_wukongs_command_custom_soldier", "abilities/monkey_king/monkey_king_wukongs_command_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_monkey_king_wukongs_command_custom_buff", "abilities/monkey_king/monkey_king_wukongs_command_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_monkey_king_wukongs_command_custom_effect", "abilities/monkey_king/monkey_king_wukongs_command_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_monkey_king_wukongs_command_custom_scepter", "abilities/monkey_king/monkey_king_wukongs_command_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_monkey_king_wukongs_command_custom_cooldown", "abilities/monkey_king/monkey_king_wukongs_command_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_monkey_king_wukongs_command_custom_slow", "abilities/monkey_king/monkey_king_wukongs_command_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_monkey_king_wukongs_command_custom_rapier", "abilities/monkey_king/monkey_king_wukongs_command_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_monkey_king_wukongs_command_custom_inactive", "abilities/monkey_king/monkey_king_wukongs_command_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_monkey_king_wukongs_command_custom_nodraw", "abilities/monkey_king/monkey_king_wukongs_command_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_monkey_king_wukongs_command_custom_leash", "abilities/monkey_king/monkey_king_wukongs_command_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_monkey_king_wukongs_command_custom_knock", "abilities/monkey_king/monkey_king_wukongs_command_custom", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_monkey_king_wukongs_command_custom_interval", "abilities/monkey_king/monkey_king_wukongs_command_custom", LUA_MODIFIER_MOTION_NONE)




monkey_king_wukongs_command_custom = class({})

function monkey_king_wukongs_command_custom:GetAbilityTextureName()
if self:GetCaster():HasModifier("modifier_monkey_king_demon_tricker_custom") then
    return "monkey_king_wukongs_command_ti9"
end
return "monkey_king_wukongs_command"
end


monkey_king_wukongs_command_custom.soldiers_max = 8


function monkey_king_wukongs_command_custom:GetIntrinsicModifierName()
if not self:GetCaster():IsRealHero() or self:GetCaster():IsTempestDouble() then return end
return "modifier_monkey_king_wukongs_command_custom_scepter"
end


function monkey_king_wukongs_command_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end

PrecacheResource( "particle", "particles/units/heroes/hero_monkey_king/monkey_king_fur_army_cast.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_monkey_king/monkey_king_quad_tap_hit.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_monkey_king/monkey_king_fur_army_positions.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_monkey_king/monkey_king_fur_army_attack.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_monkey_king/monkey_king_fur_army_positions.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_monkey_king/monkey_king_furarmy_ring.vpcf", context )
PrecacheResource( "particle", "particles/huskar_disarm_coil.vpcf", context )
PrecacheResource( "particle", "particles/status_fx/status_effect_monkey_king_fur_army.vpcf", context )
PrecacheResource( "particle", "particles/items/celestial_spear_leash.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_monkey_king/monkey_king_quad_tap_hit.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_sniper/sniper_headshot_slow.vpcf", context )
PrecacheResource( "particle", "particles/monkey_king/command_buff.vpcf", context )

end

function monkey_king_wukongs_command_custom:GetCooldown(iLevel)

local bonus = 0
if self:GetCaster():HasTalent("modifier_monkey_king_command_2") then 
  bonus = self:GetCaster():GetTalentValue("modifier_monkey_king_command_2", "cd")
end
return self.BaseClass.GetCooldown(self, iLevel) + bonus
end


function monkey_king_wukongs_command_custom:GetCastPoint()
local bonus = 0
if self:GetCaster():HasTalent("modifier_monkey_king_command_5") then 
	bonus = self:GetCaster():GetTalentValue("modifier_monkey_king_command_5", "cast")
end
return self:GetSpecialValueFor("AbilityCastPoint") + bonus
end



function monkey_king_wukongs_command_custom:GetCastAnimation()
return ACT_DOTA_MK_FUR_ARMY
end

function monkey_king_wukongs_command_custom:GetCastRange(vLocation, hTarget)
return self:GetSpecialValueFor("cast_range")
end

function monkey_king_wukongs_command_custom:GetAOERadius()
return self:GetSpecialValueFor("second_radius")
end



function monkey_king_wukongs_command_custom:OnAbilityPhaseStart()
self:GetCaster():EmitSound("Hero_MonkeyKing.FurArmy.Channel")
	
local max = self:GetSpecialValueFor("num_first_soldiers") + self:GetSpecialValueFor("num_second_soldiers")

if not self.soldiers or #self.soldiers < max then 
	for i = 1, self.soldiers_max do
		self:CreateSoldier(i)
	end
end

local particle_name = "particles/units/heroes/hero_monkey_king/monkey_king_fur_army_cast.vpcf"
if self:GetCaster():HasModifier("modifier_monkey_king_demon_tricker_custom") then
    particle_name = "particles/econ/items/monkey_king/mk_ti9_immortal/mk_ti9_immortal_army_cast.vpcf"
end
self.cast_particle = ParticleManager:CreateParticle(particle_name, PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(self.cast_particle, 0, self:GetCaster():GetAbsOrigin())
return true
end



function monkey_king_wukongs_command_custom:OnAbilityPhaseInterrupted()
self:GetCaster():StopSound("Hero_MonkeyKing.FurArmy.Channel")

if self.cast_particle ~= nil then
	ParticleManager:DestroyParticle(self.cast_particle, true)
	ParticleManager:ReleaseParticleIndex(self.cast_particle)
	self.cast_particle = nil
end

end

function monkey_king_wukongs_command_custom:OnSpellStart()


if self.cast_particle ~= nil then
    ParticleManager:DestroyParticle(self.cast_particle, false)
	ParticleManager:ReleaseParticleIndex(self.cast_particle)
    self.cast_particle = nil
end

local caster = self:GetCaster()
local position = self:GetCursorPosition()
local cast_range = self:GetSpecialValueFor("cast_range") + caster:GetCastRangeBonus()

caster:RemoveModifierByName("modifier_monkey_king_tree_dance_custom")
FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)

local vDirection = position - caster:GetAbsOrigin()
vDirection.z = 0
position = GetGroundPosition(caster:GetAbsOrigin()+vDirection:Normalized()*math.min(vDirection:Length2D(), cast_range), caster)

local first_radius = self:GetSpecialValueFor("first_radius")
local second_radius = self:GetSpecialValueFor("second_radius")
local scepter_third_radius = self:GetSpecialValueFor("scepter_third_radius")
local num_first_soldiers = self:GetSpecialValueFor("num_first_soldiers")
local num_second_soldiers = self:GetSpecialValueFor("num_second_soldiers")
local duration = self:GetSpecialValueFor("duration") + caster:GetTalentValue("modifier_monkey_king_command_2", "duration")
local max_radius = second_radius

if self.thinker then
    UTIL_Remove(self.thinker)
end

self:EndCooldown()
self:SetActivated(false)

self.thinker = CreateModifierThinker(caster, self, "modifier_monkey_king_wukongs_command_custom_thinker", {duration = duration + 0.3, radius = max_radius}, position, caster:GetTeamNumber(), false)

if caster:HasTalent("modifier_monkey_king_command_5") then 
	caster:EmitSound("MK.Arena_bkb")
	caster:AddNewModifier(caster, self, "modifier_generic_debuff_immune", {duration = caster:GetTalentValue("modifier_monkey_king_command_5", "bkb"), effect = 1})
end 

caster:AddNewModifier(caster, self, "modifier_monkey_king_wukongs_command_custom_buff", {duration = duration})

local interval = 0.2

for i = 1, num_second_soldiers, 1 do
    Timers:CreateTimer((i - 1)*interval, function()
        if caster:HasModifier("modifier_monkey_king_wukongs_command_custom_buff") then
            local soldier = self:GetFreeSoldier()

            local vTargetPosition = GetGroundPosition(position + second_radius*Rotation2D(Vector(0,1,0), math.rad((i-0.25)*360/num_second_soldiers)), soldier)

            soldier:RemoveModifierByName("modifier_monkey_king_wukongs_command_custom_soldier_active")
            soldier:AddNewModifier(caster, self, "modifier_monkey_king_wukongs_command_custom_soldier_active", {position = position, radius = max_radius, target_position = vTargetPosition, ultimate = true})
        end
    end)
end

Timers:CreateTimer(num_first_soldiers*interval, function()

    for i = 1, num_first_soldiers, 1 do
    Timers:CreateTimer((i - 1)*interval, function()
        if caster:HasModifier("modifier_monkey_king_wukongs_command_custom_buff") then
            local soldier = self:GetFreeSoldier()

            local vTargetPosition = GetGroundPosition(position + first_radius*Rotation2D(Vector(0,1,0), math.rad((i-0.5)*360/num_first_soldiers)), soldier)

            soldier:RemoveModifierByName("modifier_monkey_king_wukongs_command_custom_soldier_active")

            soldier:AddNewModifier(caster, self, "modifier_monkey_king_wukongs_command_custom_soldier_active", {position=position, radius = max_radius, target_position=vTargetPosition, ultimate = true})
        end
    end)
end

end)

self.vLastPosition = position
end






function monkey_king_wukongs_command_custom:GetFreeSoldier()
if not IsServer() then return end
if not self.soldiers then return end

local new_monkey = nil
local max_time = 0
local j = 0 

for i,monkey_scepter in pairs(self.soldiers) do

	local mod = monkey_scepter:FindModifierByName("modifier_monkey_king_wukongs_command_custom_soldier_active")

	if monkey_scepter and not monkey_scepter:IsNull() and not mod then
		new_monkey = monkey_scepter
		break
	end

	if mod and mod:GetElapsedTime() > max_time then 
		max_time = mod:GetElapsedTime()
		j = i
	end
end

if new_monkey == nil then 
	new_monkey = self.soldiers[j] 
end

return new_monkey
end







function monkey_king_wukongs_command_custom:CreateSoldier(count)

if self.soldiers == nil 
	then self.soldiers = {} 
end

if #self.soldiers >= self.soldiers_max then return end
local caster = self:GetCaster()
local soldier = CreateUnitByName(caster:GetUnitName(), caster:GetAbsOrigin(), false, caster, caster, caster:GetTeamNumber())

if soldier then

	for i = 0, 24 do
	local current_ability = soldier:GetAbilityByIndex(i)
		if current_ability then
			soldier:RemoveAbility(current_ability:GetName())
		end
	end
	soldier.owner = caster
	soldier:AddNewModifier(caster, self, "modifier_monkey_king_wukongs_command_custom_soldier", nil)
	table.insert(self.soldiers, soldier)
end

end

function monkey_king_wukongs_command_custom:SpawnMonkeyKingPointScepter(point, duration, teleport, no_particle)
if not self:GetCaster():IsRealHero() then return end
if not self.soldiers then return end

local new_monkey = self:GetFreeSoldier()
if not new_monkey then return end

new_monkey:RemoveModifierByName("modifier_monkey_king_wukongs_command_custom_soldier_active")

local origin = nil
if teleport then 
	origin = point
end

new_monkey:AddNewModifier(self:GetCaster(), self, "modifier_monkey_king_wukongs_command_custom_soldier_active", {position=point, radius = max_radius, target_position=point, duration = duration, ultimate = false, origin = origin, no_particle = no_particle})
return new_monkey
end


function monkey_king_wukongs_command_custom:CreateSoldiers()
if self:GetCaster():HasModifier("modifier_monkey_king_wukongs_command_custom_soldier") then return end
local count = 1

if self.soldiers == nil then 
	count = 1
	self.soldiers = {} 
else 
	count = #self.soldiers
end

print("start mk", count, self.soldiers_max)

for i = count, self.soldiers_max do
	Timers:CreateTimer(
        "mk"..i,
        {
            useGameTime = false,
            endTime = 0.5*i,
            callback = function()
            	self:CreateSoldier(i)
            end
        }
    )
end

end


function monkey_king_wukongs_command_custom:IsHiddenWhenStolen()
	return false
end



modifier_monkey_king_wukongs_command_custom_cooldown = class({})
function modifier_monkey_king_wukongs_command_custom_cooldown:IsPurgable() return false end
function modifier_monkey_king_wukongs_command_custom_cooldown:RemoveOnDeath() return false end
function modifier_monkey_king_wukongs_command_custom_cooldown:IsDebuff() return true end



modifier_monkey_king_wukongs_command_custom_scepter = class({})
function modifier_monkey_king_wukongs_command_custom_scepter:IsHidden() return true end
function modifier_monkey_king_wukongs_command_custom_scepter:IsPurgable() return false end
function modifier_monkey_king_wukongs_command_custom_scepter:OnCreated()
if not IsServer() then return end
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.duration = self:GetAbility():GetSpecialValueFor("scepter_spawn_duration")
self.cd = self:GetAbility():GetSpecialValueFor("scepter_spawn_interval")

self.timer = 0
self.slow_duration = self.parent:GetTalentValue("modifier_monkey_king_command_1", "duration", true)
self.damage = self.parent:GetTalentValue("modifier_monkey_king_command_1", "damage", true)

self.interval_max = self.parent:GetTalentValue("modifier_monkey_king_command_4", "max", true)

self.parent:AddAttackEvent_out(self)

self.init_scepter = false 
self:StartIntervalThink(0.2)
end

function modifier_monkey_king_wukongs_command_custom_scepter:OnIntervalThink()
if not IsServer() then return end
if not self.parent:IsRealHero() then return end

if (self.parent:HasScepter() or self.parent:HasTalent("modifier_monkey_king_command_4") or self.parent:HasTalent("modifier_monkey_king_command_7")) and self.init_scepter == false then 

	--self:GetAbility().soldiers_max = self:GetAbility().soldiers_max + self:GetAbility().soldiers_scepter
	--self:GetAbility():CreateSoldiers()
	self.init_scepter = true
end

if not self.parent:HasScepter() then return end
if self.parent:HasModifier("modifier_monkey_king_wukongs_command_custom_soldier") then return end
if not self.parent:IsAlive() then return end
if self.parent:IsInvisible() then return end
if self.parent:HasModifier("modifier_monkey_king_mischief_custom") then return end
if self.parent:HasModifier("modifier_generic_arc") then return end
if self.parent:HasModifier("modifier_monkey_king_tree_dance_custom") then return end
if self.parent:HasModifier("modifier_monkey_king_tree_dance_custom_jump") then return end
if self.parent:HasModifier("modifier_monkey_king_transform") then return end
if self.parent:HasModifier("modifier_final_duel_start") then return end
if self.parent:HasModifier("modifier_monkey_king_wukongs_command_custom_cooldown") then return end

self:GetAbility():SpawnMonkeyKingPointScepter(self.parent:GetAbsOrigin()+RandomVector(RandomInt(100, 300)), self.duration)
self.parent:AddNewModifier(self.parent, self.ability, "modifier_monkey_king_wukongs_command_custom_cooldown", {duration = self.cd})
end




function modifier_monkey_king_wukongs_command_custom_scepter:AttackEvent_out(params)
if not IsServer() then return end 
if not params.target:IsUnit() then return end 
local attacker = params.attacker


if (not attacker:HasModifier("modifier_monkey_king_wukongs_command_custom_soldier") or not attacker.owner or attacker.owner ~= self.parent) and self.parent ~= attacker then return end 

if self.parent:HasTalent("modifier_monkey_king_command_1") and RollPseudoRandomPercentage(self.parent:GetTalentValue("modifier_monkey_king_command_1", "chance"), 5297, self.parent) then 

	params.target:EmitSound("MK.Arena_proc")
	params.target:AddNewModifier(self.parent, self.ability, "modifier_monkey_king_wukongs_command_custom_slow", {duration =  self.slow_duration})

	local hit_effect = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_quad_tap_hit.vpcf", PATTACH_CUSTOMORIGIN, params.target)
	ParticleManager:SetParticleControlEnt(hit_effect, 0, params.target, PATTACH_POINT_FOLLOW, "attach_hitloc", params.target:GetAbsOrigin(), false) 
	ParticleManager:SetParticleControlEnt(hit_effect, 1, params.target, PATTACH_POINT_FOLLOW, "attach_hitloc", params.target:GetAbsOrigin(), false) 
	ParticleManager:ReleaseParticleIndex(hit_effect)

	DoDamage({victim = params.target, attacker = self.parent, damage = self.damage, ability = self.ability, damage_type = DAMAGE_TYPE_MAGICAL}, "modifier_monkey_king_command_1")
	params.target:SendNumber(4, self.damage)
end 

if not attacker:HasModifier("modifier_monkey_king_wukongs_command_custom_soldier") then return end

if self.parent:HasTalent("modifier_monkey_king_command_3") then 
	self.parent:GenericHeal(self.parent:GetTalentValue("modifier_monkey_king_command_3", "heal"), self.ability, true, nil, "modifier_monkey_king_command_3")
end 

if self.parent:HasTalent("modifier_monkey_king_command_4") and not attacker:HasModifier("modifier_monkey_king_wukongs_command_custom_interval") then 
	local mod = attacker:FindModifierByName("modifier_monkey_king_wukongs_command_custom_soldier_active")
	if mod then 
		mod.interval_stack = mod.interval_stack + 1
		if mod.interval_stack >= self.interval_max then 
			attacker:AddNewModifier(self.parent, self.ability, "modifier_monkey_king_wukongs_command_custom_interval", {})
		end 
	end 
end



end









modifier_monkey_king_wukongs_command_custom_soldier_active = class({})
function modifier_monkey_king_wukongs_command_custom_soldier_active:IsHidden() return true end
function modifier_monkey_king_wukongs_command_custom_soldier_active:IsPurgable() return false end
function modifier_monkey_king_wukongs_command_custom_soldier_active:OnCreated(params)

self.parent = self:GetParent()
self.ability = self:GetAbility()
self.caster = self:GetCaster()

self.attack_speed = self.ability:GetSpecialValueFor("attack_speed")
self.attack_range = self.parent:Script_GetAttackRange()
self.move_speed = 550

self.move_bonus = self.caster:GetTalentValue("modifier_monkey_king_command_4", "move")
self.speed_bonus = self.caster:GetTalentValue("modifier_monkey_king_command_4", "speed")

if not IsServer() then return end
self.interval_stack = 0
self.search_radius = self.attack_range + self.parent:GetHullRadius()

self.attack_target = nil

self.parent:RemoveModifierByName("modifier_monkey_king_wukongs_command_custom_inactive")

for i = 0, 5 do
	local item = self.caster:GetItemInSlot(i)
	if (i <= 5) and item then


		local new_item = CreateItem(item:GetName(), nil, nil)
		local soldier_item = self.parent:AddItem(new_item)

		if soldier_item:GetName() == "item_rapier" then 
			self.parent:AddNewModifier(self.parent, nil, "modifier_monkey_king_wukongs_command_custom_rapier", {})
		end
		soldier_item:SetPurchaser(nil)

		if item and item:GetCurrentCharges() > 0 and new_item and not new_item:IsNull() then
			new_item:SetCurrentCharges(item:GetCurrentCharges())
		end
		if new_item and not new_item:IsNull() then 
			self.parent:SwapItems(new_item:GetItemSlot(), i)
		end
	end
end

for level = 1, self.caster:GetLevel() do
	if self.parent:GetLevel() < self.caster:GetLevel() then
		self.parent:HeroLevelUp(false)
	end
end

for _,mod in pairs(self.caster:FindAllModifiers()) do
	if mod.StackOnIllusion or mod:GetName() == "modifier_item_ultimate_scepter_consumed" or mod:GetName() == "modifier_item_aghanims_shard" then
		local old_mod = self.parent:FindModifierByName(mod:GetName())
		if not old_mod then
    		old_mod = self.parent:AddNewModifier(self.parent, nil, mod:GetName(), {})
    	end
		old_mod:SetStackCount(mod:GetStackCount())
    end
end

self.radius = params.radius
self.position = StringToVector(params.position)
self.target_position = StringToVector(params.target_position)
self.target = nil
self.ultimate = params.ultimate

self.origin = self.caster:GetAbsOrigin()

if params.origin ~= nil then 
	self.origin = StringToVector(params.origin)
end
self.parent:SetAbsOrigin(self.origin)

self.parent:MoveToPosition(self.target_position)
self.parent:AddNewModifier(self.caster, self.ability, "modifier_monkey_king_wukongs_command_custom_effect", nil)

if not params.no_particle then 
    local particle_name = "particles/units/heroes/hero_monkey_king/monkey_king_fur_army_positions.vpcf"
    if self.caster:HasModifier("modifier_monkey_king_demon_tricker_custom") then
        particle_name = "particles/econ/items/monkey_king/mk_ti9_immortal/mk_ti9_immortal_army_positions.vpcf"
    end
	self.particleID = ParticleManager:CreateParticle(particle_name, PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(self.particleID, 0, self.target_position)

	self:AddParticle(self.particleID, false, false, -1, false, false)
end

self:StartIntervalThink(0.1)
end



function modifier_monkey_king_wukongs_command_custom_soldier_active:CheckState()
if self:GetStackCount() == 0 then
	return
	{
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true
	}
else

	if not self.parent:HasModifier("modifier_monkey_king_wukongs_command_custom_interval") then 
		return
		{
			[MODIFIER_STATE_ROOTED] = true,
		}
	end
end

end


function modifier_monkey_king_wukongs_command_custom_soldier_active:OnIntervalThink()
if not IsServer() then return end 

if not IsValid(self.caster) then
	self:Destroy()
	return
end

if self:GetStackCount() == 0 and (self.parent:GetAbsOrigin() - self.target_position):Length2D() <= 10 then
	self:SetStackCount(1)
	FindClearSpaceForUnit(self.parent, self.target_position, false)
end

if self:GetStackCount() ~= 1 then return end

if not self:CheckTarget() then 
	self:FindTarget()
else 
	if self.parent:HasModifier("modifier_monkey_king_wukongs_command_custom_effect") then
		self.parent:RemoveModifierByName("modifier_monkey_king_wukongs_command_custom_effect")

		local particleID = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_fur_army_attack.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
		ParticleManager:ReleaseParticleIndex(particleID)
	end
end

end



function modifier_monkey_king_wukongs_command_custom_soldier_active:FindTarget()
if not IsServer() then return end

local targets = FindUnitsInRadius(self.caster:GetTeamNumber(), self.parent:GetAbsOrigin(), nil, self.search_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES+DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE+DOTA_UNIT_TARGET_FLAG_NO_INVIS+DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, FIND_CLOSEST, false)

local target = targets[1]
if target ~= nil and target:GetUnitName() ~= "npc_teleport" then
	self.attack_target = target
	self.parent:SetForceAttackTarget(self.attack_target)
	self.parent:MoveToTargetToAttack(self.attack_target)
end 

end



function modifier_monkey_king_wukongs_command_custom_soldier_active:CheckTarget()
if not IsServer() then return end
if not self.attack_target or self.attack_target:IsNull() or not self.attack_target:IsAlive() 
	or ((self.attack_target:GetAbsOrigin() - self.parent:GetAbsOrigin()):Length2D() > (35 + self.search_radius) and not self.parent:HasModifier("modifier_monkey_king_wukongs_command_custom_interval")) then

	if self.parent:GetForceAttackTarget() then
		self.parent:Stop()
		self.parent:SetForceAttackTarget(nil)
	end
	if not self.parent:HasModifier("modifier_monkey_king_wukongs_command_custom_effect") then
		self.parent:AddNewModifier(self.caster, self.ability, "modifier_monkey_king_wukongs_command_custom_effect", nil)
	end

	return false
end 

self.parent:SetForceAttackTarget(self.attack_target)
self.parent:MoveToTargetToAttack(self.attack_target)
return true
end


function modifier_monkey_king_wukongs_command_custom_soldier_active:DeclareFunctions()
return 
{
	MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
	MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
	MODIFIER_PROPERTY_FIXED_ATTACK_RATE,
}
end


function modifier_monkey_king_wukongs_command_custom_soldier_active:GetModifierFixedAttackRate()
local bonus = 0
if self.parent:HasModifier("modifier_monkey_king_wukongs_command_custom_interval") then 
	bonus = self.speed_bonus
end 
return self.attack_speed + bonus
end

function modifier_monkey_king_wukongs_command_custom_soldier_active:GetModifierMoveSpeed_Absolute()
if self.parent:HasModifier("modifier_monkey_king_wukongs_command_custom_interval") then 
	return self.move_bonus
end 
return self.move_speed
end

function modifier_monkey_king_wukongs_command_custom_soldier_active:GetActivityTranslationModifiers()
return "run_fast"
end

function modifier_monkey_king_wukongs_command_custom_soldier_active:OnDestroy()
if not IsServer() then return end

if self.particleID then 
	ParticleManager:SetParticleControl(self.particleID, 0, self.parent:GetAbsOrigin())
else 
    local particle_name = "particles/units/heroes/hero_monkey_king/monkey_king_fur_army_positions.vpcf"
    if self.caster:HasModifier("modifier_monkey_king_demon_tricker_custom") then
        particle_name = "particles/econ/items/monkey_king/mk_ti9_immortal/mk_ti9_immortal_army_positions.vpcf"
    end

	self.particleID = ParticleManager:CreateParticle(particle_name, PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(self.particleID, 0, self.parent:GetAbsOrigin())
	ParticleManager:DestroyParticle(self.particleID, false)
	ParticleManager:ReleaseParticleIndex(self.particleID)
end 

for _,mod in pairs(self.parent:FindAllModifiersByName("modifier_monkey_king_wukongs_command_custom_rapier")) do 
	mod:Destroy()
end

self.parent:AddNewModifier(self.parent, self.ability, "modifier_monkey_king_wukongs_command_custom_inactive", {})
end







modifier_monkey_king_wukongs_command_custom_inactive = class({})
function modifier_monkey_king_wukongs_command_custom_inactive:IsHidden() return true end
function modifier_monkey_king_wukongs_command_custom_inactive:IsPurgable() return false end
function modifier_monkey_king_wukongs_command_custom_inactive:CheckState()
return
{
	[MODIFIER_STATE_STUNNED] = true,
}
end


function modifier_monkey_king_wukongs_command_custom_inactive:OnCreated()
if not IsServer() then return end 

self.parent = self:GetParent()

for i = 0, 18 do
	local item = self.parent:GetItemInSlot(i)
	if item then
		item:Destroy()
	end
end


ProjectileManager:ProjectileDodge(self.parent)

self.mod = self.parent:AddNewModifier(self.parent, nil, "modifier_monkey_king_wukongs_command_custom_nodraw", {})
self.parent:RemoveModifierByName("modifier_monkey_king_jingu_mastery_custom_buff")
self.parent:RemoveModifierByName("modifier_monkey_king_jingu_mastery_custom_hit")
self.parent:RemoveModifierByName("modifier_monkey_king_wukongs_command_custom_interval")
self.parent:SetDayTimeVisionRange(0)
self.parent:SetNightTimeVisionRange(0)
self.parent:Stop()
self.parent:SetForceAttackTarget(nil)
self.parent:SetOrigin(Vector(-7500.25, 7594.84, 15))
end 



function modifier_monkey_king_wukongs_command_custom_inactive:OnDestroy()
if not IsServer() then return end 

self.parent:SetDayTimeVisionRange(600)
self.parent:SetNightTimeVisionRange(600)

if self.mod and not self.mod:IsNull() then 
	self.mod:SetDuration(0.1, false)
end 

end 




modifier_monkey_king_wukongs_command_custom_nodraw = class({})
function modifier_monkey_king_wukongs_command_custom_nodraw:IsHidden() return false end
function modifier_monkey_king_wukongs_command_custom_nodraw:IsPurgable() return false end
function modifier_monkey_king_wukongs_command_custom_nodraw:OnCreated()
if not IsServer() then return end 
self.parent = self:GetParent()
self.parent:AddNoDraw()
self.parent:NoDraw(self, true)
end 

function modifier_monkey_king_wukongs_command_custom_nodraw:OnDestroy()
if not IsServer() then return end 

self.parent:EndNoDraw(self)
self.parent:RemoveNoDraw()
end 








modifier_monkey_king_wukongs_command_custom_thinker = class({})

function modifier_monkey_king_wukongs_command_custom_thinker:IsHidden() return true end
function modifier_monkey_king_wukongs_command_custom_thinker:IsPurgable() return false end

function modifier_monkey_king_wukongs_command_custom_thinker:OnCreated(params)

self.parent = self:GetParent()
self.caster = self:GetCaster()
self.ability = self:GetAbility()

self.leadership_radius_buffer = self.ability:GetSpecialValueFor("leadership_radius_buffer")
self.scepter_delay = self.ability:GetSpecialValueFor("scepter_delay")

if not IsServer() then return end 

self.radius = params.radius
self.parent:EmitSound("Hero_MonkeyKing.FurArmy")

local particle_name = "particles/units/heroes/hero_monkey_king/monkey_king_furarmy_ring.vpcf"
if self.caster:HasModifier("modifier_monkey_king_demon_tricker_custom") then
    particle_name = "particles/econ/items/monkey_king/mk_ti9_immortal/mk_ti9_immortal_army_ring.vpcf"
end

local particleID = ParticleManager:CreateParticle(particle_name, PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(particleID, 0, self.parent:GetAbsOrigin())
ParticleManager:SetParticleControl(particleID, 1, Vector(self.radius,self.radius,self.radius))
self:AddParticle(particleID, false, false, -1, false, false)

self.leash_targets = {}

if self.caster:HasTalent("modifier_monkey_king_command_6") then 
	self.effect_cast = ParticleManager:CreateParticle( "particles/huskar_disarm_coil.vpcf", PATTACH_WORLDORIGIN, self.parent )
	ParticleManager:SetParticleControl( self.effect_cast, 0, self.parent:GetAbsOrigin() )
	self:AddParticle(self.effect_cast,false,false,-1,false,false)
end 

self:CheckLeash()
self:StartIntervalThink(1)
end


function modifier_monkey_king_wukongs_command_custom_thinker:CheckLeash()
if not IsServer() then return end 
if not self.caster:HasTalent("modifier_monkey_king_command_6") then return end 

local targets = FindUnitsInRadius(self.caster:GetTeamNumber(), self.parent:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_CLOSEST, false)

for _,target in pairs(targets) do 
	if not self.leash_targets[target:entindex()] then
		self.leash_targets[target:entindex()] = true
		target:AddNewModifier(self.caster, self.ability, "modifier_monkey_king_wukongs_command_custom_leash", {thinker = self.parent:entindex(), duration = self:GetRemainingTime()})
	end
end


end


function modifier_monkey_king_wukongs_command_custom_thinker:OnDestroy()
if not IsServer() then return end 

self.ability:SetActivated(true)
self.ability:UseResources(false, false, false, true)

for n, soldier in pairs(self.ability.soldiers) do

	local mod = soldier:FindModifierByName("modifier_monkey_king_wukongs_command_custom_soldier_active")
	if mod and mod.ultimate == 1 then 
		soldier:RemoveModifierByName("modifier_monkey_king_wukongs_command_custom_soldier_active")
	end
end


if not IsValid(self.caster) or not IsValid(self.parent)  then
	return
end

self.caster:RemoveModifierByName("modifier_monkey_king_wukongs_command_custom_buff")

self.parent:StopSound("Hero_MonkeyKing.FurArmy")
EmitSoundOnLocationWithCaster(self.parent:GetAbsOrigin(), "Hero_MonkeyKing.FurArmy.End", self.caster)
self.parent:RemoveSelf()
end


function modifier_monkey_king_wukongs_command_custom_thinker:OnIntervalThink()
if not IsServer() then return end

self:CheckLeash()

if not IsValid(self.caster) or not IsValid(self.parent) then
	self:Destroy()
	return
end

local caster_near = self.caster:IsPositionInRange(self.parent:GetAbsOrigin(), self.radius+self.leadership_radius_buffer)

if caster_near then 
	self.parent:RemoveModifierByName("modifier_monkey_king_wukongs_command_custom_thinker_delay")
end

if self.parent:HasModifier("modifier_monkey_king_wukongs_command_custom_thinker_delay") then return end

if not caster_near and self.caster:HasScepter() then 
	self.parent:AddNewModifier(self.parent, self.ability, "modifier_monkey_king_wukongs_command_custom_thinker_delay", {duration = self.scepter_delay})
end

if not self.caster:HasModifier("modifier_monkey_king_wukongs_command_custom_buff") or (not self.caster:HasScepter() and not caster_near) then
	self:Destroy()
end


self:StartIntervalThink(0.1)
end





function modifier_monkey_king_wukongs_command_custom_thinker:CheckState()
return 
{
	[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	[MODIFIER_STATE_INVULNERABLE] = true,
	[MODIFIER_STATE_OUT_OF_GAME] = true,
	[MODIFIER_STATE_NO_HEALTH_BAR] = true,
	[MODIFIER_STATE_UNSELECTABLE] = true,
	[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
}
end












modifier_monkey_king_wukongs_command_custom_soldier = class({})
function modifier_monkey_king_wukongs_command_custom_soldier:IsHidden() return true end
function modifier_monkey_king_wukongs_command_custom_soldier:IsPurgable() return false end

function modifier_monkey_king_wukongs_command_custom_soldier:OnCreated(params)

self.parent = self:GetParent()
self.caster = self:GetCaster()
self.range_bonus = self.caster:GetTalentValue("modifier_monkey_king_command_6", "range", true)

if not IsServer() then return end 
self.parent:AddNewModifier(self.parent, nil, "modifier_monkey_king_wukongs_command_custom_inactive", {})

self.jingu = self.caster:FindModifierByName("modifier_monkey_king_jingu_mastery_custom_thinker")
self.command = self.caster:FindModifierByName("modifier_monkey_king_wukongs_command_custom_scepter")
self.primal = self.caster:FindModifierByName("modifier_monkey_king_primal_spring_custom_tracker")

self.parent:AddDamageEvent_out(self, true)
self.parent:AddAttackEvent_out(self, true)
end

function modifier_monkey_king_wukongs_command_custom_soldier:DamageEvent_out(params)
if not IsServer() then return end
if self.parent ~= params.attacker then return end

if not self.jingu then
	self.jingu = self.caster:FindModifierByName("modifier_monkey_king_jingu_mastery_custom_thinker")
end

if self.jingu then
	self.jingu:DamageEvent_out(params)
end

end

function modifier_monkey_king_wukongs_command_custom_soldier:AttackEvent_out(params)
if not IsServer() then return end
if self.parent ~= params.attacker then return end

if not self.command then
	self.command = self.caster:FindModifierByName("modifier_monkey_king_wukongs_command_custom_scepter")
end

if not self.primal then
	self.primal = self.caster:FindModifierByName("modifier_monkey_king_primal_spring_custom_tracker")
end

if self.command then
	self.command:AttackEvent_out(params)
end

if self.primal then
	self.primal:AttackEvent_out(params)
end

end




function modifier_monkey_king_wukongs_command_custom_soldier:CheckState()

if self.caster:HasModifier("modifier_monkey_king_mischief_custom") then 

	if self.caster:HasModifier("modifier_monkey_king_mischief_invun") then 
		return
		{
		    [MODIFIER_STATE_NO_HEALTH_BAR] = true,
		    [MODIFIER_STATE_NOT_ON_MINIMAP] = true,
		    [MODIFIER_STATE_MAGIC_IMMUNE] = true,
	  		[MODIFIER_STATE_CANNOT_BE_MOTION_CONTROLLED] = true,
			[MODIFIER_STATE_INVULNERABLE] = true,
			[MODIFIER_STATE_UNSLOWABLE] = true,
			[MODIFIER_STATE_OUT_OF_GAME] = true,
	   	}
	else 
		return
		{
		    [MODIFIER_STATE_NO_HEALTH_BAR] = true,
		    [MODIFIER_STATE_NOT_ON_MINIMAP] = true,
		    [MODIFIER_STATE_MAGIC_IMMUNE] = true,
			[MODIFIER_STATE_UNSLOWABLE] = true,
	  		[MODIFIER_STATE_CANNOT_BE_MOTION_CONTROLLED] = true,
	   	}
	end 
end 

return 
{
	[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
	[MODIFIER_STATE_INVULNERABLE] = true,
	[MODIFIER_STATE_OUT_OF_GAME] = true,
	[MODIFIER_STATE_NO_HEALTH_BAR] = true,
	[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
	[MODIFIER_STATE_MAGIC_IMMUNE] = true,
	[MODIFIER_STATE_UNSLOWABLE] = true,
	[MODIFIER_STATE_CANNOT_BE_MOTION_CONTROLLED] = true,
	[MODIFIER_STATE_UNSELECTABLE] = true,
	[MODIFIER_STATE_UNTARGETABLE] = true,
}
end


function modifier_monkey_king_wukongs_command_custom_soldier:DeclareFunctions()
return 
{
	MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
	MODIFIER_PROPERTY_DISABLE_AUTOATTACK,
	MODIFIER_PROPERTY_TEMPEST_DOUBLE,
	MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
	MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
	MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
	MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
}
end

function modifier_monkey_king_wukongs_command_custom_soldier:GetModifierAttackRangeBonus()
if not self.caster:HasTalent("modifier_monkey_king_command_6") then return end 
return self.range_bonus
end

function modifier_monkey_king_wukongs_command_custom_soldier:GetModifierTempestDouble() 
return 1 
end

function modifier_monkey_king_wukongs_command_custom_soldier:GetAbsoluteNoDamagePhysical()
return 1
end

function modifier_monkey_king_wukongs_command_custom_soldier:GetAbsoluteNoDamagePure()
return 1
end

function modifier_monkey_king_wukongs_command_custom_soldier:GetAbsoluteNoDamageMagical()
return 1
end

function modifier_monkey_king_wukongs_command_custom_soldier:GetActivityTranslationModifiers()
if self.parent:HasModifier("modifier_monkey_king_mischief_anim") then return end
return "fur_army_soldier"
end

function modifier_monkey_king_wukongs_command_custom_soldier:GetDisableAutoAttack()
return 1
end









modifier_monkey_king_wukongs_command_custom_buff = class({})

function modifier_monkey_king_wukongs_command_custom_buff:IsHidden() return false end
function modifier_monkey_king_wukongs_command_custom_buff:IsPurgable() return false end
function modifier_monkey_king_wukongs_command_custom_buff:DeclareFunctions()
return 
{
	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
}
end

function modifier_monkey_king_wukongs_command_custom_buff:OnCreated(table)
self.parent = self:GetParent()
self.armor = self:GetAbility():GetSpecialValueFor("bonus_armor")

self.magic = self.parent:GetTalentValue("modifier_monkey_king_command_3", "magic")

if not IsServer() then return end 
if not self.parent:HasTalent("modifier_monkey_king_command_5") then return end

for i = 0, 8 do
	local current_item = self.parent:GetItemInSlot(i)


	if current_item and not NoCdItems[current_item:GetName()] then  
	  local cooldown_mod = self.parent:AddNewModifier(self.parent, self:GetAbility(), "modifier_cooldown_speed", {ability = current_item:entindex(), is_item = true, cd_inc = self.parent:GetTalentValue("modifier_monkey_king_command_5", "cd_inc")})
	  local name = self:GetName()

	  cooldown_mod:SetEndRule(function()
	    return self.parent:HasModifier(name)
	  end)
	end
end

end

function modifier_monkey_king_wukongs_command_custom_buff:GetModifierPhysicalArmorBonus()
return self.armor
end

function modifier_monkey_king_wukongs_command_custom_buff:GetModifierMagicalResistanceBonus()
return self.magic
end




modifier_monkey_king_wukongs_command_custom_effect = class({})
function modifier_monkey_king_wukongs_command_custom_effect:IsHidden() return true end
function modifier_monkey_king_wukongs_command_custom_effect:IsPurgable() return false end
function modifier_monkey_king_wukongs_command_custom_effect:GetStatusEffectName()
if self:GetCaster():HasModifier("modifier_monkey_king_demon_tricker_custom") then
    return "particles/econ/items/monkey_king/mk_ti9_immortal/status_effect_mk_ti9_immortal_army.vpcf"
end
return "particles/status_fx/status_effect_monkey_king_fur_army.vpcf"
end

function modifier_monkey_king_wukongs_command_custom_effect:StatusEffectPriority()
return MODIFIER_PRIORITY_ILLUSION
end







modifier_monkey_king_wukongs_command_custom_rapier = class({})
function modifier_monkey_king_wukongs_command_custom_rapier:IsHidden() return true end
function modifier_monkey_king_wukongs_command_custom_rapier:IsPurgable() return false end
function modifier_monkey_king_wukongs_command_custom_rapier:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_monkey_king_wukongs_command_custom_rapier:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
}
end
function modifier_monkey_king_wukongs_command_custom_rapier:GetModifierPreAttack_BonusDamage()
return 300
end






function string.split(str, delimiter)
	if str == nil or str == "" or delimiter == nil then
		return nil
	end

	local result = {}
	for match in (str..delimiter):gmatch("(.-)"..delimiter) do
		table.insert(result, match)
	end
	return result
end

function string.gsplit(str)
	local str_tb = {}
	if string.len(str) ~= 0 then
		for i=1,string.len(str) do
			new_str= string.sub(str,i,i)			
			if (string.byte(new_str) >=48 and string.byte(new_str) <=57) or (string.byte(new_str)>=65 and string.byte(new_str)<=90) or (string.byte(new_str)>=97 and string.byte(new_str)<=122) then
				table.insert(str_tb,string.sub(str,i,i))				
			else
				return nil
			end
		end
		return str_tb
	else
		return nil
	end
end


function IsValid(h)
	return h ~= nil and not h:IsNull()
end

function Rotation2D(vVector, radian)
	local fLength2D = vVector:Length2D()
	local vUnitVector2D = vVector / fLength2D
	local fCos = math.cos(radian)
	local fSin = math.sin(radian)
	return Vector(vUnitVector2D.x*fCos-vUnitVector2D.y*fSin, vUnitVector2D.x*fSin+vUnitVector2D.y*fCos, vUnitVector2D.z)*fLength2D
end

function StringToVector(str)
	if str == nil then return end
	local table = string.split(str, " ")
	return Vector(tonumber(table[1]), tonumber(table[2]), tonumber(table[3])) or nil
end




modifier_monkey_king_wukongs_command_custom_leash = class({})
function modifier_monkey_king_wukongs_command_custom_leash:IsHidden() return true end
function modifier_monkey_king_wukongs_command_custom_leash:IsPurgable() return false end
function modifier_monkey_king_wukongs_command_custom_leash:OnCreated(table)
if not IsServer() then return end 

self.parent = self:GetParent()
self.caster = self:GetCaster()
self.ability = self:GetAbility()
self.thinker = EntIndexToHScript(table.thinker)
self.radius = self:GetAbility():GetSpecialValueFor("second_radius") + 60
self.RemoveForDuel = true

self.knock_dist = self.caster:GetTalentValue("modifier_monkey_king_command_6", "knock_range")
self.knockback_duration = self.caster:GetTalentValue("modifier_monkey_king_command_6", "knock_duration")

self.parent:EmitSound("MK.Arena_leash")

local effect_cast_2 = ParticleManager:CreateParticle( "particles/items/celestial_spear_leash.vpcf", PATTACH_ABSORIGIN, self.parent )
ParticleManager:SetParticleControl( effect_cast_2, 0, self.thinker:GetAbsOrigin() )
ParticleManager:SetParticleControlEnt(effect_cast_2, 1, self.parent, PATTACH_POINT_FOLLOW,"attach_hitloc", self.parent:GetOrigin(),true)
self:AddParticle(effect_cast_2,false,false,-1,false,false)


self:OnIntervalThink()
self:StartIntervalThink(0.1)
end 


function modifier_monkey_king_wukongs_command_custom_leash:OnIntervalThink()
if not IsServer() then return end 

if not self.thinker or self.thinker:IsNull() then 
	self:Destroy()
	return
end  

if (self.parent:GetAbsOrigin() - self.thinker:GetAbsOrigin()):Length2D() > self.radius and not self.parent:IsInvulnerable() and not self.parent:IsOutOfGame() then 

	local vec = (self.parent:GetAbsOrigin() - self.thinker:GetAbsOrigin()):Normalized()
	local knock_point = self.thinker:GetAbsOrigin() + vec*self.knock_dist
	self.parent:AddNewModifier(self.caster, self.ability, "modifier_monkey_king_wukongs_command_custom_knock", {duration = self.knockback_duration, x = knock_point.x, y = knock_point.y})
	self:Destroy()
end

end 


function modifier_monkey_king_wukongs_command_custom_leash:CheckState()
return
{
	[MODIFIER_STATE_TETHERED] = true
}
end








modifier_monkey_king_wukongs_command_custom_knock = class({})

function modifier_monkey_king_wukongs_command_custom_knock:IsHidden() return true end

function modifier_monkey_king_wukongs_command_custom_knock:OnCreated(params)
if not IsServer() then return end
  
self.ability        = self:GetAbility()
self.caster         = self:GetCaster()
self.parent         = self:GetParent()
self:GetParent():StartGesture(ACT_DOTA_FLAIL)

self.knockback_duration   = self:GetRemainingTime()
self.position = GetGroundPosition(Vector(params.x, params.y, 0), nil)

self.knockback_distance = (self:GetParent():GetAbsOrigin() -self.position):Length2D() 

self.knockback_speed    = self.knockback_distance / self.knockback_duration

self.parent:EmitSound("Mk.Arena_knock")

local hit_effect = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_quad_tap_hit.vpcf", PATTACH_CUSTOMORIGIN, self.parent)
ParticleManager:SetParticleControlEnt(hit_effect, 0, self.parent, PATTACH_POINT, "attach_hitloc", self.parent:GetAbsOrigin(), false) 
ParticleManager:SetParticleControlEnt(hit_effect, 1, self.parent, PATTACH_POINT, "attach_hitloc", self.parent:GetAbsOrigin(), false) 
ParticleManager:ReleaseParticleIndex(hit_effect)

if self:ApplyHorizontalMotionController() == false then 
  self:Destroy()
  return
end

end

function modifier_monkey_king_wukongs_command_custom_knock:UpdateHorizontalMotion( me, dt )
if not IsServer() then return end

local distance = (self.position - me:GetOrigin()):Normalized()

me:SetOrigin( me:GetOrigin() + distance * self.knockback_speed * dt )

GridNav:DestroyTreesAroundPoint( self.parent:GetOrigin(), self.parent:GetHullRadius(), true )
end

function modifier_monkey_king_wukongs_command_custom_knock:DeclareFunctions()
local decFuncs = {
  MODIFIER_PROPERTY_OVERRIDE_ANIMATION
  }

  return decFuncs
end

function modifier_monkey_king_wukongs_command_custom_knock:GetOverrideAnimation()
   return ACT_DOTA_FLAIL
end


function modifier_monkey_king_wukongs_command_custom_knock:OnDestroy()
if not IsServer() then return end
self.parent:RemoveHorizontalMotionController( self )
self:GetParent():FadeGesture(ACT_DOTA_FLAIL)

FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetAbsOrigin(), true)
end





modifier_monkey_king_wukongs_command_custom_slow = class({})
function modifier_monkey_king_wukongs_command_custom_slow:IsHidden() return true end
function modifier_monkey_king_wukongs_command_custom_slow:IsPurgable() return true end

function modifier_monkey_king_wukongs_command_custom_slow:OnCreated(table)
self.slow = self:GetCaster():GetTalentValue("modifier_monkey_king_command_1", "slow")
end

function modifier_monkey_king_wukongs_command_custom_slow:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
}
end

function modifier_monkey_king_wukongs_command_custom_slow:GetModifierMoveSpeedBonus_Percentage()
return self.slow
end

function modifier_monkey_king_wukongs_command_custom_slow:GetEffectName()
return "particles/units/heroes/hero_sniper/sniper_headshot_slow.vpcf"
end

function modifier_monkey_king_wukongs_command_custom_slow:GetEffectAttachType()
return PATTACH_OVERHEAD_FOLLOW
end








modifier_monkey_king_wukongs_command_custom_interval = class({})
function modifier_monkey_king_wukongs_command_custom_interval:IsHidden() return true end
function modifier_monkey_king_wukongs_command_custom_interval:IsPurgable() return false end
function modifier_monkey_king_wukongs_command_custom_interval:OnCreated()
self.parent = self:GetParent()

if not IsServer() then return end
self.parent:EmitSound("MK.Arena_buff")
self.parent:EmitSound("MK.Arena_buff2")

self.particle = ParticleManager:CreateParticle( "particles/monkey_king/command_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent )
ParticleManager:SetParticleControl( self.particle, 0, self.parent:GetAbsOrigin() )
ParticleManager:SetParticleControl( self.particle, 1, self.parent:GetAbsOrigin() )
ParticleManager:SetParticleControl( self.particle, 2, self.parent:GetAbsOrigin() )  
self:AddParticle(self.particle, false, false, -1, false, false)
end 


function modifier_monkey_king_wukongs_command_custom_interval:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MODEL_SCALE
}
end


function modifier_monkey_king_wukongs_command_custom_interval:GetModifierModelScale()
return 25
end






modifier_monkey_king_wukongs_command_custom_thinker_delay = class({})
function modifier_monkey_king_wukongs_command_custom_thinker_delay:IsHidden() return true end
function modifier_monkey_king_wukongs_command_custom_thinker_delay:IsPurgable() return false end
function modifier_monkey_king_wukongs_command_custom_thinker_delay:OnDestroy()
if not IsServer() then return end 
if self:GetRemainingTime() > 0.1 then return end 
if not self:GetParent() or self:GetParent():IsNull() then return end

self:GetParent():RemoveModifierByName("modifier_monkey_king_wukongs_command_custom_thinker")
end