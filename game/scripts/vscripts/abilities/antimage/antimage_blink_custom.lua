LinkLuaModifier("modifier_antimage_blink_custom_active", "abilities/antimage/antimage_blink_custom", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_antimage_blink_custom_illusion", "abilities/antimage/antimage_blink_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_antimage_blink_custom_turn", "abilities/antimage/antimage_blink_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_antimage_blink_custom_quest", "abilities/antimage/antimage_blink_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_antimage_blink_custom_legendary_agility", "abilities/antimage/antimage_blink_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_antimage_blink_custom_tracker", "abilities/antimage/antimage_blink_custom", LUA_MODIFIER_MOTION_NONE)


antimage_blink_custom = class({})

antimage_blink_custom.legendary_count = 0

function antimage_blink_custom:CreateTalent()
local caster = self:GetCaster()
caster:UpdateUIlong({max = 1, stack = 0, active = 0, style = "AntimageBlink"})
end

function antimage_blink_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end

PrecacheResource( "particle", "particles/units/heroes/hero_antimage/antimage_blink_start.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_antimage/antimage_blink_end.vpcf", context )
PrecacheResource( "particle", "particles/items_fx/force_staff.vpcf", context )
PrecacheResource( "particle", "particles/antimage_charge.vpcf", context )
PrecacheResource( "particle", "particles/status_fx/status_effect_forcestaff.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_antimage/antimage_manabreak_slow.vpcf", context )
PrecacheResource( "particle", "particles/antimage/blink_speed.vpcf", context )
PrecacheResource( "particle", "particles/status_fx/status_effect_dark_seer_normal_punch_replica.vpcf", context )
PrecacheResource( "particle", "particles/am_heal.vpcf", context )
PrecacheResource( "particle", "particles/am_blink_refresh.vpcf", context )
PrecacheResource( "particle", "particles/antimage/blink_field.vpcf", context )
PrecacheResource( "particle", "particles/anti-mage/blink_damage.vpcf", context )

end


function antimage_blink_custom:GetIntrinsicModifierName()
return "modifier_antimage_blink_custom_tracker"
end

function antimage_blink_custom:GetAbilityTextureName()
if self:GetCaster():HasModifier("modifier_antimage_ti7_armor_custom_golden") then
    return "antimage/immortal/antimage_blink_gold"
end
if self:GetCaster():HasModifier("modifier_antimage_ti7_armor_custom") then
    return "antimage/immortal/antimage_blink"
end
return "antimage_blink"
end


function antimage_blink_custom:GetCastPoint(iLevel)
local bonus = 0
if self:GetCaster():HasTalent("modifier_antimage_blink_4") then 
	bonus = self:GetCaster():GetTalentValue("modifier_antimage_blink_4", "cast")
end
return self.BaseClass.GetCastPoint(self) + bonus
end


function antimage_blink_custom:GetBehavior()
if self:GetCaster():HasTalent("modifier_antimage_blink_7") then
	return  DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_ROOT_DISABLES + DOTA_ABILITY_BEHAVIOR_IMMEDIATE
end
return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_ROOT_DISABLES
end


function antimage_blink_custom:GetCastRange(vLocation, hTarget)
local max_dist = self:GetSpecialValueFor( "blink_range" )
if self:GetCaster():HasTalent("modifier_antimage_blink_7") then 
	max_dist = self:GetCaster():GetTalentValue("modifier_antimage_blink_7", "distance")
end
if IsClient() then 
	return max_dist 
end
return 99999
end


function antimage_blink_custom:GetCooldown(iLevel)
local bonus = 0
local caster = self:GetCaster()
if caster:HasTalent("modifier_antimage_blink_4") then 
	bonus = caster:GetTalentValue("modifier_antimage_blink_4", "cd")
end
local k = 1
if caster:HasTalent("modifier_antimage_blink_7") then  
  k = 1 - caster:GetTalentValue("modifier_antimage_blink_7", "cd")/100
end
return (self.BaseClass.GetCooldown(self, iLevel) + bonus)*k 
end

function antimage_blink_custom:GetManaCost(level)
if self:GetCaster():HasTalent("modifier_antimage_blink_7") then  
  return self:GetCaster():GetTalentValue("modifier_antimage_blink_7", "mana")
end
return self.BaseClass.GetManaCost(self,level) 
end


function antimage_blink_custom:ProceedProc(origin)
if not IsServer() then return end
local caster = self:GetCaster()
local width = 150
local point = caster:GetAbsOrigin()
local direction = point - origin
direction.z = 0

local hit_type = 0

local damage_type = caster:GetTalentValue("modifier_antimage_blink_1", "damage_type")
local damage_k = caster:HasTalent("modifier_antimage_blink_7") and caster:GetTalentValue("modifier_antimage_blink_1", "damage_legendary") or caster:GetTalentValue("modifier_antimage_blink_1", "damage")
local damageTable = {attacker = caster, ability = self, damage = damage_k*caster:GetAgility()/100, damage_type = damage_type}
local enemies = FindUnitsInLine( caster:GetTeamNumber(), origin, point, nil, width, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, 0)
for _,enemy in pairs(enemies) do
	if caster:HasTalent("modifier_antimage_blink_1") then
		damageTable.victim = enemy
		local real_damage = DoDamage(damageTable, "modifier_antimage_blink_1")
		enemy:SendNumber(4, real_damage)

		local particle = ParticleManager:CreateParticle( "particles/anti-mage/blink_damage.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy )
		ParticleManager:SetParticleControlEnt( particle, 0, enemy, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true )
		ParticleManager:SetParticleControlEnt( particle, 1, enemy, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true )
		ParticleManager:ReleaseParticleIndex(particle)
		enemy:EmitSound("Hero_Antimage.Attack")
	end
	if caster:HasTalent("modifier_antimage_blink_7") then
		hit_type = math.max(1 , hit_type)
		if enemy:IsRealHero() then
			hit_type = 2
		end
	end
end

if hit_type ~= 0 then
	local duration = hit_type == 2 and caster:GetTalentValue("modifier_antimage_blink_7", "duration_hero") or caster:GetTalentValue("modifier_antimage_blink_7", "duration_creeps")
	caster:AddNewModifier(caster, self, "modifier_antimage_blink_custom_legendary_agility", {duration = duration})
end

local particle_end_name = "particles/units/heroes/hero_antimage/antimage_blink_end.vpcf"
if caster:HasModifier("modifier_antimage_ti7_armor_custom") then
    particle_end_name = "particles/econ/items/antimage/antimage_ti7/antimage_blink_ti7_end.vpcf"
end
if caster:HasModifier("modifier_antimage_ti7_armor_custom_golden") then
    particle_end_name = "particles/econ/items/antimage/antimage_ti7_golden/antimage_blink_ti7_golden_end.vpcf"
end

local particle_end = ParticleManager:CreateParticle( particle_end_name, PATTACH_ABSORIGIN, caster )
ParticleManager:SetParticleControl( particle_end, 0, caster:GetOrigin() )
ParticleManager:SetParticleControlForward( particle_end, 0, direction:Normalized() )
ParticleManager:ReleaseParticleIndex( particle_end )


if caster:HasTalent("modifier_antimage_blink_4") and RollPseudoRandomPercentage(caster:GetTalentValue("modifier_antimage_blink_4", "chance"), 1606, caster) then
	local particle = ParticleManager:CreateParticle("particles/am_blink_refresh.vpcf", PATTACH_CUSTOMORIGIN, caster)
   	ParticleManager:SetParticleControlEnt( particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetOrigin(), true )
   	ParticleManager:ReleaseParticleIndex(particle)

	self:EndCooldown()
	self:StartCooldown(0.3)
	caster:EmitSound("Antimage.Blink_refresh")
end

if caster:HasTalent("modifier_antimage_blink_3") then 

	local legendary_count = caster:GetTalentValue("modifier_antimage_blink_3", "legendary_count")
	if caster:HasTalent("modifier_antimage_blink_7") then
		self.legendary_count = self.legendary_count + 1
		if self.legendary_count < legendary_count then return end
		self.legendary_count = 0
	end


	local duration = caster:GetTalentValue("modifier_antimage_blink_3", "duration")
	local damage = caster:GetTalentValue("modifier_antimage_blink_3", "damage") - 100

	local illusions = CreateIllusions( caster, caster, {duration=duration, outgoing_damage=damage,incoming_damage=0}, 1, 0, false, true)  

	for k, illusion in pairs(illusions) do
		for _,mod in pairs(caster:FindAllModifiers()) do
		    if mod.StackOnIllusion ~= nil and mod.StackOnIllusion == true then
		        illusion:UpgradeIllusion(mod:GetName(), mod:GetStackCount() )
		    end
		end

		illusion.owner = caster
		illusion:AddNewModifier(caster, self, "modifier_antimage_blink_custom_illusion", {})
		Timers:CreateTimer(0.1, function()
		   	illusion:MoveToPositionAggressive(illusion:GetAbsOrigin())
		end)
	end
end

end


function antimage_blink_custom:OnSpellStart()
 
if test then
	local mod = dota1x6.event_thinker:FindModifierByName("modifier_event_thinker")
	if mod then
		mod:PrintStats()
	end
end

local caster = self:GetCaster()
local origin = caster:GetOrigin()
local blink_range = self:GetSpecialValueFor("blink_range") + caster:GetCastRangeBonus()
local point = caster:HasTalent("modifier_antimage_blink_7") and origin + caster:GetForwardVector()*blink_range or self:GetCursorPosition()

local direction = (point - origin)
direction.z = 0
if direction:Length2D() > blink_range then
	direction = direction:Normalized() * blink_range
end

ProjectileManager:ProjectileDodge(caster)

local particle_start_name = "particles/units/heroes/hero_antimage/antimage_blink_start.vpcf"
if caster:HasModifier("modifier_antimage_ti7_armor_custom") then
    particle_start_name = "particles/econ/items/antimage/antimage_ti7/antimage_blink_start_ti7.vpcf"
end
if caster:HasModifier("modifier_antimage_ti7_armor_custom_golden") then
    particle_start_name = "particles/econ/items/antimage/antimage_ti7_golden/antimage_blink_start_ti7_golden.vpcf"
end

local particle_start = ParticleManager:CreateParticle( particle_start_name, PATTACH_WORLDORIGIN, nil )
ParticleManager:SetParticleControl( particle_start, 0, origin )
ParticleManager:SetParticleControlForward( particle_start, 0, direction:Normalized() )
ParticleManager:ReleaseParticleIndex( particle_start )

if caster:GetQuest() == "Anti.Quest_6" and not caster:QuestCompleted() then 
	caster:AddNewModifier(caster, self, "modifier_antimage_blink_custom_quest", {duration = caster.quest.number})
end

if caster:HasTalent("modifier_antimage_blink_7") then 
	caster:EmitSound("Antimage.Blink_legen")
	caster:AddNewModifier(caster, self, "modifier_antimage_blink_custom_active", {duration = 1})
else 
	EmitSoundOnLocationWithCaster( origin, "Hero_Antimage.Blink_out", caster )
	FindClearSpaceForUnit( caster, origin + direction, true )

	self:ProceedProc(origin)

    local sound_in = "Hero_Antimage.Blink_in"
    if caster:HasModifier("modifier_antimage_persona_custom_1") or caster:HasModifier("modifier_antimage_persona_custom_2") or caster:HasModifier("modifier_antimage_persona_custom_3") or caster:HasModifier("modifier_antimage_persona_custom_4") or caster:HasModifier("modifier_antimage_persona_custom_5") or caster:HasModifier("modifier_antimage_persona_custom_6") then
        sound_in = "Hero_Antimage.Blink_in.Persona"
    end

	EmitSoundOnLocationWithCaster( caster:GetOrigin(), sound_in, caster )
end

end




modifier_antimage_blink_custom_active = class(mod_hidden)
function modifier_antimage_blink_custom_active:OnCreated()
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.anim = ACT_DOTA_RUN
self.activity = "haste"

if self.parent:HasModifier("modifier_antimage_persona_custom_1") or self.parent:HasModifier("modifier_antimage_persona_custom_2") or self.parent:HasModifier("modifier_antimage_persona_custom_3") or self.parent:HasModifier("modifier_antimage_persona_custom_4") or self.parent:HasModifier("modifier_antimage_persona_custom_5") or self.parent:HasModifier("modifier_antimage_persona_custom_6") then
    self.anim = ACT_DOTA_RUN
    self.activity = "chase"
end

if not IsServer() then return end

self.parent:GenericParticle("particles/items_fx/force_staff.vpcf", self)

self.angle = self.parent:GetForwardVector():Normalized()
self.distance = self.parent:GetTalentValue("modifier_antimage_blink_7", "distance") 
self.speed = self.distance/self.parent:GetTalentValue("modifier_antimage_blink_7", "duration")

if self.parent:HasTalent("modifier_antimage_blink_4") then
	self.speed = self.speed*(1 + self.parent:GetTalentValue("modifier_antimage_blink_4", "speed")/100)
end

self.origin = self.parent:GetAbsOrigin()

if self:ApplyHorizontalMotionController() == false then
    self:Destroy()
end

end

function modifier_antimage_blink_custom_active:DeclareFunctions()
return
{
 	MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
 	MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
    MODIFIER_PROPERTY_DISABLE_TURNING
}
end

function modifier_antimage_blink_custom_active:GetOverrideAnimation() return self.anim end
function modifier_antimage_blink_custom_active:GetActivityTranslationModifiers() return self.activity end
function modifier_antimage_blink_custom_active:GetModifierDisableTurning() return 1 end
function modifier_antimage_blink_custom_active:GetEffectName() return "particles/antimage_charge.vpcf" end
function modifier_antimage_blink_custom_active:OnDestroy()
if not IsServer() then return end
self.parent:AddNewModifier(self.parent, self.ability, "modifier_antimage_blink_custom_turn", {duration = 1})
self.parent:InterruptMotionControllers( true )

local dir = self.parent:GetForwardVector()
dir.z = 0
self.parent:SetForwardVector(dir)
self.parent:FaceTowards(self.parent:GetAbsOrigin() + dir*10)

ResolveNPCPositions(self.parent:GetAbsOrigin(), 128)

self.ability:ProceedProc(self.origin)
end


function modifier_antimage_blink_custom_active:UpdateHorizontalMotion( me, dt )
if not IsServer() then return end
local pos = self.parent:GetAbsOrigin()
GridNav:DestroyTreesAroundPoint(pos, 80, false)

local pos_p = self.angle * self.speed * dt
local next_pos = GetGroundPosition(pos + pos_p,self.parent)

self.parent:SetAbsOrigin(next_pos)

if (next_pos - self.origin):Length2D() >= self.distance then
	self:Destroy()
	return
end

end

function modifier_antimage_blink_custom_active:OnHorizontalMotionInterrupted()
self:Destroy()
end



modifier_antimage_blink_custom_illusion = class(mod_hidden)
function modifier_antimage_blink_custom_illusion:GetStatusEffectName() return "particles/status_fx/status_effect_dark_seer_normal_punch_replica.vpcf" end
function modifier_antimage_blink_custom_illusion:StatusEffectPriority()return MODIFIER_PRIORITY_ILLUSION end
function modifier_antimage_blink_custom_illusion:CheckState()
return
{
	[MODIFIER_STATE_NO_HEALTH_BAR] = true,
	[MODIFIER_STATE_INVULNERABLE] = true,
	[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	[MODIFIER_STATE_UNTARGETABLE] = true,
	[MODIFIER_STATE_UNSELECTABLE] = true,
	[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
}
end

function modifier_antimage_blink_custom_illusion:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
}
end

function modifier_antimage_blink_custom_illusion:OnCreated(table)
if not IsServer() then return end
self.parent = self:GetParent()
self.caster = self:GetCaster()
self.heal = self.caster:GetTalentValue("modifier_antimage_blink_3", "heal")/100
end

function modifier_antimage_blink_custom_illusion:GetModifierProcAttack_Feedback(params)
if not IsServer() then return end
if self.parent ~= params.attacker then return end

if self.caster and not self.caster:IsNull() and self.caster:IsAlive() then 
	local heal = self.caster:GetMaxHealth()*self.heal
	self.caster:GenericHeal(heal, self:GetAbility(), true, "particles/am_heal.vpcf", "modifier_antimage_blink_3")
end

end



modifier_antimage_blink_custom_turn = class(mod_hidden)
function modifier_antimage_blink_custom_turn:DeclareFunctions()
return 
{
	MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE
}
end
function modifier_antimage_blink_custom_turn:GetModifierTurnRate_Percentage()
return 100
end




modifier_antimage_blink_custom_quest = class({})
function modifier_antimage_blink_custom_quest:IsHidden() return true end
function modifier_antimage_blink_custom_quest:IsPurgable() return false end



modifier_antimage_blink_custom_legendary_agility = class(mod_hidden)
function modifier_antimage_blink_custom_legendary_agility:OnCreated(table)
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.agi = self.parent:GetTalentValue("modifier_antimage_blink_7", "agi")/100
self.max = self.parent:GetTalentValue("modifier_antimage_blink_7", "max")
if not IsServer() then return end

self.StackOnIllusion = true

self.max_time = self:GetRemainingTime()
self:SetStackCount(1)

if not self.parent:IsRealHero() then return end
self:OnIntervalThink()
self:StartIntervalThink(0.1)
end

function modifier_antimage_blink_custom_legendary_agility:OnRefresh(table)
if not IsServer() then return end
self.max_time = self:GetRemainingTime()

if self:GetStackCount() >= self.max then return end
self:IncrementStackCount()
end

function modifier_antimage_blink_custom_legendary_agility:OnStackCountChanged()
if not IsServer() then return end
self.PercentAgi = self.agi*self:GetStackCount()
end

function modifier_antimage_blink_custom_legendary_agility:OnDestroy()
if not IsServer() then return end
if not self.parent:IsRealHero() then return end
self.parent:PercentRefresh()
self.parent:UpdateUIlong({max = self.max_time, stack = 0, active = 0, style = "AntimageBlink"})
end


function modifier_antimage_blink_custom_legendary_agility:OnIntervalThink()
if not IsServer() then return end

self.parent:UpdateUIlong({max = self.max_time, stack = self:GetRemainingTime(), override_stack = self:GetStackCount(), active = self:GetStackCount() >= self.max and 1 or 0, style = "AntimageBlink"})
end




modifier_antimage_blink_custom_tracker = class(mod_hidden)
function modifier_antimage_blink_custom_tracker:OnCreated()
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.move = self.parent:GetTalentValue("modifier_antimage_blink_2", "move", true)
self.evasion = self.parent:GetTalentValue("modifier_antimage_blink_2", "evasion", true)
self.agi = self.parent:GetTalentValue("modifier_antimage_blink_2", "agi")


if not IsServer() then return end
self:SetHasCustomTransmitterData(true)
self:UpdateTalent()
end

function modifier_antimage_blink_custom_tracker:UpdateTalent(name)
if not IsServer() then return end

if name == "modifier_antimage_blink_2" or self.parent:HasTalent("modifier_antimage_blink_2") then
	self.agi = self.parent:GetTalentValue("modifier_antimage_blink_2", "agi")
end

self:SendBuffRefreshToClients()
end

function modifier_antimage_blink_custom_tracker:AddCustomTransmitterData() 
return 
{
  agi = self.agi,
} 
end

function modifier_antimage_blink_custom_tracker:HandleCustomTransmitterData(data)
self.agi = data.agi
end

function modifier_antimage_blink_custom_tracker:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	MODIFIER_PROPERTY_EVASION_CONSTANT
}
end

function modifier_antimage_blink_custom_tracker:GetModifierMoveSpeedBonus_Percentage()
if self.agi <= 0 then return end
return (self.parent:GetAgility()/self.agi)*self.move
end

function modifier_antimage_blink_custom_tracker:GetModifierEvasion_Constant()
if self.agi <= 0 then return end
return (self.parent:GetAgility()/self.agi)*self.evasion
end