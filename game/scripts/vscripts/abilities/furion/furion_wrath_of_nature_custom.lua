LinkLuaModifier("modifier_furion_wrath_of_nature_custom", "abilities/furion/furion_wrath_of_nature_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_furion_wrath_of_nature_custom_scepter", "abilities/furion/furion_wrath_of_nature_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_furion_wrath_of_nature_custom_legendary", "abilities/furion/furion_wrath_of_nature_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_furion_wrath_of_nature_custom_legendary_slow", "abilities/furion/furion_wrath_of_nature_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_furion_wrath_of_nature_custom_perma", "abilities/furion/furion_wrath_of_nature_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_furion_wrath_of_nature_custom_stack", "abilities/furion/furion_wrath_of_nature_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_furion_wrath_of_nature_custom_tracker", "abilities/furion/furion_wrath_of_nature_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_furion_wrath_of_nature_custom_damage", "abilities/furion/furion_wrath_of_nature_custom", LUA_MODIFIER_MOTION_NONE)

furion_wrath_of_nature_custom = class({})
		

function furion_wrath_of_nature_custom:CreateTalent()

local ability = self:GetCaster():FindAbilityByName("furion_wrath_of_nature_custom_legendary")
if ability then 
	ability:SetHidden(false)
end 


end


function furion_wrath_of_nature_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end

PrecacheResource( "particle", "particles/units/heroes/hero_furion/furion_wrath_of_nature_cast.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_oracle/oracle_false_promise_heal.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_monkey_king/monkey_king_quad_tap_hit.vpcf", context )
PrecacheResource( "particle", "particles/furion/furion_wrath_of_nature_custom.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_brewmaster/brewmaster_dispel_magic.vpcf", context )
PrecacheResource( "particle", "particles/items3_fx/silver_edge.vpcf", context )
PrecacheResource( "particle", "particles/nature_prophet/scepter_effect.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_furion/furion_wrath_of_nature_cast.vpcf", context )
PrecacheResource( "particle", "particles/nature_prophet/wrath_legendary_proj.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_monkey_king/monkey_king_quad_tap_hit.vpcf", context )
PrecacheResource( "particle", "particles/nature_prophet/wrath_legendary_aoe.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_monkey_king/monkey_king_quad_tap_hit.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_monkey_king/monkey_king_quad_tap_hit.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_sniper/sniper_headshot_slow.vpcf", context )
PrecacheResource( "particle", "particles/lc_odd_proc_.vpcf", context )
PrecacheResource( "particle", "particles/nature_prophet/wrath_stack.vpcf", context )
PrecacheResource( "particle", "particles/nature_prophet/wrath_stack_max.vpcf", context )
PrecacheResource( "particle", "particles/hoodwink/bush_damage.vpcf", context )
PrecacheResource( "particle", "particles/general/generic_armor_reduction.vpcf", context )

end





function furion_wrath_of_nature_custom:GetIntrinsicModifierName()
return "modifier_furion_wrath_of_nature_custom_tracker"
end


function furion_wrath_of_nature_custom:GetCastAnimation()
if self:GetCaster():HasTalent("modifier_furion_nature_5") then 
	return 0
end 
	return ACT_DOTA_CAST_ABILITY_6
end



function furion_wrath_of_nature_custom:GetCastPoint()
local bonus = 0

if self:GetCaster():HasTalent("modifier_furion_nature_5") then 
  bonus = self:GetCaster():GetTalentValue("modifier_furion_nature_5", "cast")
end

return self:GetSpecialValueFor("AbilityCastPoint") + bonus
end



function furion_wrath_of_nature_custom:GetAbilityTargetFlags()
if self:GetCaster():HasScepter() then 
	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
else 
	return DOTA_UNIT_TARGET_FLAG_NONE
end

end


function furion_wrath_of_nature_custom:GetCooldown(iLevel)
local bonus = 0

if self:GetCaster():HasTalent("modifier_furion_nature_3") then 
	bonus = self:GetCaster():GetTalentValue("modifier_furion_nature_3", "cd")
end 

return self.BaseClass.GetCooldown(self, iLevel) + bonus
end



function furion_wrath_of_nature_custom:OnAbilityPhaseStart()

if self:GetCaster():HasTalent("modifier_furion_nature_5") then 
	local cast = self:GetSpecialValueFor("AbilityCastPoint")
	self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_6, cast/(cast + self:GetCaster():GetTalentValue("modifier_furion_nature_5", "cast")) )
end 

local cast_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_furion/furion_wrath_of_nature_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
ParticleManager:SetParticleControlEnt(cast_particle, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
ParticleManager:ReleaseParticleIndex(cast_particle)

return true
end

function furion_wrath_of_nature_custom:OnAbilityPhaseInterrupted()
if not self:GetCaster():HasTalent("modifier_furion_nature_5") then return end

self:GetCaster():FadeGesture(ACT_DOTA_CAST_ABILITY_6)
end 






function furion_wrath_of_nature_custom:OnSpellStart()

local point = self:GetCursorPosition()
local caster = self:GetCaster()

self:GetCaster():EmitSound("Hero_Furion.WrathOfNature_Cast.Self")

if caster:HasTalent("modifier_furion_nature_6") then 
	caster:CdItems(caster:GetTalentValue("modifier_furion_nature_6", "cd_items"))
end 

caster:AddNewModifier(caster, self, "modifier_furion_wrath_of_nature_custom", {x = point.x, y = point.y})
end



function furion_wrath_of_nature_custom:GetDamage()
return self:GetSpecialValueFor("damage") + self:GetCaster():GetTalentValue("modifier_furion_nature_1", "damage")
end


function furion_wrath_of_nature_custom:FinalHeal(damage)
if not IsServer() then return end

local caster = self:GetCaster()

if not caster:HasTalent("modifier_furion_nature_2") then return end 
if damage == 0 then return end

caster:EmitSound("Furion.Wrath_heal")

local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_oracle/oracle_false_promise_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
ParticleManager:ReleaseParticleIndex( particle )

caster:GenericHeal(damage*caster:GetTalentValue("modifier_furion_nature_2", "heal")/100, self, nil, nil, "modifier_furion_nature_1")

end 




modifier_furion_wrath_of_nature_custom = class({})

function modifier_furion_wrath_of_nature_custom:IsHidden() return true end
function modifier_furion_wrath_of_nature_custom:IsPurgable() return false end
function modifier_furion_wrath_of_nature_custom:RemoveOnDeath()	return false end
function modifier_furion_wrath_of_nature_custom:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_furion_wrath_of_nature_custom:OnCreated(table)

self.max_targets = self:GetAbility():GetSpecialValueFor("max_targets")
self.max_damage_count = self:GetAbility():GetSpecialValueFor("max_damage_count")
self.damage = self:GetAbility():GetDamage()
self.damage_percent_add	= self:GetAbility():GetSpecialValueFor("damage_percent_add") /100
self.jump_delay = self:GetAbility():GetSpecialValueFor("jump_delay")
self.vision_radius = self:GetAbility():GetSpecialValueFor("vision_radius")
self.vision_duration = self:GetAbility():GetSpecialValueFor("vision_duration")
self.break_duration = self:GetAbility():GetSpecialValueFor("scepter_min")
self.scepter_range = self:GetAbility():GetSpecialValueFor("scepter_range")
local break_duration_max = self:GetAbility():GetSpecialValueFor("scepter_max")
self.max_range = self:GetAbility():GetSpecialValueFor("max_range")
self.damage_reduce = self:GetAbility():GetSpecialValueFor("damage_reduce")/100

self.perma_stack = self:GetCaster():GetTalentValue("modifier_furion_nature_6", "stack", true)

self.root_inc = (break_duration_max - self.break_duration)/(self.max_damage_count - 1)

self.damage_inc = self:GetCaster():GetTalentValue("modifier_furion_nature_4", "damage")/100
self.max_stun = self:GetCaster():GetTalentValue("modifier_furion_nature_4", "stun")
self.max_stack = self:GetCaster():GetTalentValue("modifier_furion_nature_4", "max")

self.damage_duration = self:GetCaster():GetTalentValue("modifier_furion_nature_1", "duration", true)

self.bkb_duration = self:GetCaster():GetTalentValue("modifier_furion_nature_5", "bkb", true)

if not IsServer() then return end
self.caster = self:GetCaster()

self.hit_enemies = {}
self.counter = 0
self.position = GetGroundPosition(Vector(table.x, table.y, 0), nil)
self.target	= self:GetParent()

self.part_dist = 350

self.new_target = nil

self.final_damage = 0
self.last_target = self:GetCaster()

AddFOWViewer(self.caster:GetTeamNumber(), self.position, self.vision_radius, self.vision_duration, false)

self:StartIntervalThink(FrameTime())
end


function modifier_furion_wrath_of_nature_custom:FindNewTarget()

for _, enemy in pairs(FindUnitsInRadius(self.caster:GetTeamNumber(), self.position, nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false)) do

	if not self.hit_enemies[enemy:entindex()] then
		self.new_target = enemy
		break
	end
end 

end




function modifier_furion_wrath_of_nature_custom:OnIntervalThink()

if self.counter == 0 then 
	self:FindNewTarget()
end 

if not self.new_target or self.new_target:IsNull() or self.counter >= self.max_targets then 
	self:StartIntervalThink(-1)
	self:Destroy()
	return
end 

local enemy = self.new_target

if self.counter == 0 and enemy:TriggerSpellAbsorb(self:GetAbility()) then 
	self:StartIntervalThink(-1)
	self:Destroy()
	return 
end


self.hit_enemies[enemy:entindex()] = true
self.counter = self.counter + 1
self.position = enemy:GetAbsOrigin()


if enemy:IsCreep() then
	enemy:EmitSound("Furion.WrathOfNature_Damage.Creep")
else
	enemy:EmitSound("Hero_Furion.WrathOfNature_Damage") 
end

self.final_damage = self.damage
local mod = enemy:FindModifierByName("modifier_furion_wrath_of_nature_custom_stack")
if mod and mod:GetStackCount() >= self.max_stack then 

	local hit_effect = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_quad_tap_hit.vpcf", PATTACH_CUSTOMORIGIN, enemy)
	ParticleManager:SetParticleControlEnt(hit_effect, 0, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), false) 
	ParticleManager:SetParticleControlEnt(hit_effect, 1, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), false) 
	ParticleManager:ReleaseParticleIndex(hit_effect)

	enemy:AddNewModifier(self.caster, self.caster:BkbAbility(self:GetAbility(), self.caster:HasScepter()), "modifier_stunned", {duration = (1 - enemy:GetStatusResistance())*self.max_stun})
end 

if self.counter >= self.perma_stack then
		
	if self.caster:HasTalent("modifier_furion_nature_1") then 
		enemy:AddNewModifier(self.caster, self.caster:BkbAbility(self:GetAbility(), self.caster:HasScepter()), "modifier_furion_wrath_of_nature_custom_damage", {duration = self.damage_duration})
	end 

	if enemy:IsValidKill(self.caster) then 
		self.caster:AddNewModifier(self.caster, self:GetAbility(), "modifier_furion_wrath_of_nature_custom_perma", {})

		if self.caster:GetQuest() == "Furion.Quest_8" then 
			self.caster:UpdateQuest(1)
		end 
	end
	
end

local target_damage = self.final_damage
if enemy:IsHero() and (enemy:GetAbsOrigin() - self.caster:GetAbsOrigin()):Length2D() > self.max_range then
	target_damage = target_damage * (1 + self.damage_reduce)
end

DoDamage({victim = enemy, damage = target_damage, damage_type = DAMAGE_TYPE_MAGICAL, attacker = self.caster, ability = self:GetAbility() })


if self.caster:HasScepter() and enemy:IsHero() and (enemy:GetAbsOrigin() - self.caster:GetAbsOrigin()):Length2D() <= self.scepter_range then 
	enemy:EmitSound("Furion.WrathOfNature_break")
	enemy:AddNewModifier(self.caster, self.caster:BkbAbility(self:GetAbility(), self.caster:HasScepter()), "modifier_furion_wrath_of_nature_custom_scepter", {duration = (1 - enemy:GetStatusResistance())*self.break_duration})
end 

self.new_target = nil
self:FindNewTarget()

local part_target = enemy

if self.new_target then 
	part_target = self.new_target
end


local last_dir = (self.last_target:GetAbsOrigin() - enemy:GetAbsOrigin())
local last_point = enemy:GetAbsOrigin() + last_dir:Normalized()*self.part_dist
last_point.z = last_point.z + 250

local new_dir = (part_target:GetAbsOrigin() - enemy:GetAbsOrigin())
local new_point = enemy:GetAbsOrigin() + new_dir:Normalized()*self.part_dist
new_point.z = new_point.z + 250


self.wrath_particle = ParticleManager:CreateParticle("particles/furion/furion_wrath_of_nature_custom.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, enemy)

ParticleManager:SetParticleControlEnt(self.wrath_particle, 0, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)

if new_dir:Length2D() <= self.part_dist then 
	ParticleManager:SetParticleControlEnt(self.wrath_particle, 1, part_target, PATTACH_POINT_FOLLOW, "attach_hitloc", part_target:GetAbsOrigin(), true)
else 
	ParticleManager:SetParticleControl(self.wrath_particle, 1, new_point)
end 

if last_dir:Length2D() <= self.part_dist then 
	ParticleManager:SetParticleControlEnt(self.wrath_particle, 2, self.last_target, PATTACH_POINT_FOLLOW, "attach_hitloc", self.last_target:GetAbsOrigin(), true)
else 
	ParticleManager:SetParticleControl(self.wrath_particle, 2,  last_point)
end 

ParticleManager:SetParticleControlEnt(self.wrath_particle, 3, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(self.wrath_particle, 4, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
ParticleManager:ReleaseParticleIndex(self.wrath_particle)


self.last_target = enemy

if self.counter < self.max_damage_count then 
	self.damage = self.damage*(1 + self.damage_percent_add)
	self.break_duration = self.break_duration + self.root_inc
end


self:StartIntervalThink(self.jump_delay)
end



function modifier_furion_wrath_of_nature_custom:OnDestroy()
if not IsServer() then return end 
self:GetAbility():FinalHeal(self.final_damage)

if self.caster:HasTalent("modifier_furion_nature_5") then 
	self.caster:Purge(false, true, false, true, false)
	self.caster:EmitSound("Furion.Wrath_bkb")

	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_brewmaster/brewmaster_dispel_magic.vpcf", PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(particle, 0, self.caster:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(particle)

	self.caster:AddNewModifier(self.caster, self:GetAbility(), "modifier_generic_debuff_immune", {effect = 1, duration = self.bkb_duration})
end 

end 





modifier_furion_wrath_of_nature_custom_scepter = class({})
function modifier_furion_wrath_of_nature_custom_scepter:IsHidden() return true end
function modifier_furion_wrath_of_nature_custom_scepter:IsPurgable() return false end
function modifier_furion_wrath_of_nature_custom_scepter:GetEffectName() return "particles/items3_fx/silver_edge.vpcf" end
function modifier_furion_wrath_of_nature_custom_scepter:CheckState()
return
{
	[MODIFIER_STATE_PASSIVES_DISABLED] = true,
}
end

function modifier_furion_wrath_of_nature_custom_scepter:OnCreated()
if not IsServer() then return end 

local particle = ParticleManager:CreateParticle("particles/nature_prophet/scepter_effect.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
self:AddParticle(particle, false, false, -1, false, true)


self.caster = self:GetCaster()
self.parent = self:GetParent()

self:OnIntervalThink()
self:StartIntervalThink(FrameTime())
end 


function modifier_furion_wrath_of_nature_custom_scepter:OnIntervalThink()
if not IsServer() then return end 
self.parent:Purge(true, false, false, false, false)
end 



furion_wrath_of_nature_custom_legendary = class({})


function furion_wrath_of_nature_custom_legendary:GetCooldown(iLevel)
return self:GetCaster():GetTalentValue("modifier_furion_nature_7", "cd")
end


function furion_wrath_of_nature_custom_legendary:OnAbilityPhaseStart()

local cast_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_furion/furion_wrath_of_nature_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
ParticleManager:SetParticleControlEnt(cast_particle, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
ParticleManager:ReleaseParticleIndex(cast_particle)

return true
end

function furion_wrath_of_nature_custom_legendary:GetAbilityTargetFlags()
if self:GetCaster():HasScepter() then 
	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
else 
	return DOTA_UNIT_TARGET_FLAG_NONE
end

end



function furion_wrath_of_nature_custom_legendary:OnSpellStart()


local caster = self:GetCaster()
local distance = self:GetSpecialValueFor("AbilityCastRange")
local speed = self:GetSpecialValueFor("speed")
local width = self:GetSpecialValueFor("width")
local vect = self:GetCursorPosition() - self:GetCaster():GetAbsOrigin()
local dir = vect:Normalized()
dir.z = 0


self.id = ProjectileManager:CreateLinearProjectile({
	EffectName = "particles/nature_prophet/wrath_legendary_proj.vpcf",
	Ability = self,
	vSpawnOrigin = caster:GetAbsOrigin(),
	fStartRadius = width,
	fEndRadius = width,
	vVelocity = dir * speed,
	fDistance = distance + self:GetCaster():GetCastRangeBonus(),
	Source = caster,
	bDeleteOnHit = true,
	iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
	iUnitTargetType = DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
	bProvidesVision = true,
	iVisionTeamNumber = caster:GetTeamNumber(),
	iVisionRadius = width*2,
    iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2,
})


self:GetCaster():EmitSound("Furion.Wrath_legendary_cast")
self:GetCaster():EmitSound("Furion.Wrath_legendary_cast2")

end




function furion_wrath_of_nature_custom_legendary:OnProjectileHit(hTarget, vLocation)
EmitSoundOnLocationWithCaster(vLocation, "Furion.Wrath_legendary_end", self:GetCaster())


if not hTarget then return end

local hit_effect = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_quad_tap_hit.vpcf", PATTACH_CUSTOMORIGIN, hTarget)
ParticleManager:SetParticleControlEnt(hit_effect, 0, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin(), false) 
ParticleManager:SetParticleControlEnt(hit_effect, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin(), false) 
ParticleManager:ReleaseParticleIndex(hit_effect)

hTarget:AddNewModifier( self:GetCaster(), self, "modifier_furion_wrath_of_nature_custom_legendary", {})
hTarget:AddNewModifier( self:GetCaster(), self:GetCaster():BkbAbility(self, self:GetCaster():HasScepter()), "modifier_furion_wrath_of_nature_custom_legendary_slow", {duration = self:GetSpecialValueFor("duration")*(1 - hTarget:GetStatusResistance())})

return true
end








modifier_furion_wrath_of_nature_custom_legendary = class({})
function modifier_furion_wrath_of_nature_custom_legendary:IsHidden() return true end
function modifier_furion_wrath_of_nature_custom_legendary:IsPurgable() return false  end
function modifier_furion_wrath_of_nature_custom_legendary:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_furion_wrath_of_nature_custom_legendary:RemoveOnDeath() return false end

function modifier_furion_wrath_of_nature_custom_legendary:OnCreated(table)

self.caster = self:GetCaster()
self.parent = self:GetParent()
self.ability = self.caster:FindAbilityByName("furion_wrath_of_nature_custom")
if not self.ability then
	self:Destroy()
	return
end

self.legendary_damage = self.caster:GetTalentValue("modifier_furion_nature_7", "damage")/100
self.damage = self.ability:GetDamage()
self.damage_percent_add	= self.ability:GetSpecialValueFor("damage_percent_add")/100
self.jump_delay = self.ability:GetSpecialValueFor("jump_delay")
self.trees_max = self.caster:GetTalentValue("modifier_furion_nature_7", "max")
self.targets_max = self.trees_max
self.radius = self.caster:GetTalentValue("modifier_furion_nature_7", "radius")

self.legendary_k = self:GetCaster():GetTalentValue("modifier_furion_nature_4", "legendary", true)
self.max_stun = self:GetCaster():GetTalentValue("modifier_furion_nature_4", "stun", true)/self.legendary_k
self.max_stack = self:GetCaster():GetTalentValue("modifier_furion_nature_4", "max")

if not IsServer() then return end

self.particle_peffect = ParticleManager:CreateParticle("particles/nature_prophet/wrath_legendary_aoe.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())	
ParticleManager:SetParticleControl(self.particle_peffect, 0, self:GetParent():GetAbsOrigin())
ParticleManager:SetParticleControl(self.particle_peffect, 1, Vector(self.radius, 0, 0))
self:AddParticle(self.particle_peffect, false, false, -1, false, true)

self.hit_enemies = {}
self.targets_count = 0

self.position = self.parent:GetAbsOrigin()
self.part_dist = 350
self.new_target = nil

self.hit_trees = {}
self.new_tree = nil
self.last_target = self.parent
self.trees_count = 0

self.final_damage = 0

self.stage = 1

AddFOWViewer(self.caster:GetTeamNumber(), self.position, self.radius, 5, false)

self:StartIntervalThink(FrameTime())
end


function modifier_furion_wrath_of_nature_custom_legendary:FindNewTarget()

for _, enemy in pairs(FindUnitsInRadius(self.caster:GetTeamNumber(), self.parent:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false)) do

	if not self.hit_enemies[enemy:entindex()] then
		self.new_target = enemy
		break
	end
end 

end


function modifier_furion_wrath_of_nature_custom_legendary:FindNewTree()

local new_tree = nil

for _, tree in pairs(GridNav:GetAllTreesAroundPoint( self.parent:GetAbsOrigin(), self.radius, false )) do

	if not self.hit_trees[tree:entindex()] then
		new_tree = tree
		break
	end
end 

if new_tree == nil then
	for _, treant in pairs(FindUnitsInRadius(self.caster:GetTeamNumber(), self.parent:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, 0, FIND_CLOSEST, false)) do
		if not self.hit_trees[treant:entindex()] and treant.is_treant then
			new_tree = treant
			break
		end
	end 
end 

self.new_tree = new_tree
end


function modifier_furion_wrath_of_nature_custom_legendary:OnIntervalThink()


if self.trees_count == 0 then 
	self:FindNewTree()
end 

local enemy = nil

if self.stage == 1 then 
	if not self.new_tree or self.new_tree:IsNull() or self.trees_count >= self.trees_max then 
		self.stage = 2
		self:FindNewTarget()
		self:StartIntervalThink(FrameTime())
		return
	else 
		enemy = self.new_tree
		
		local hit_effect = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_quad_tap_hit.vpcf", PATTACH_WORLDORIGIN, nil)
		ParticleManager:SetParticleControl(hit_effect, 0, enemy:GetAbsOrigin() + Vector(0,0,100)) 
		ParticleManager:SetParticleControl(hit_effect, 1, enemy:GetAbsOrigin() + Vector(0,0,100)) 
		ParticleManager:ReleaseParticleIndex(hit_effect)


		self.hit_trees[enemy:entindex()] = true
		self.trees_count = self.trees_count + 1
	end 
end

if self.stage == 2 then 
	if not self.new_target or self.new_target:IsNull() or self.targets_count >= self.targets_max then 

		self:StartIntervalThink(-1)
		self:Destroy()
		return
	else 
		enemy = self.new_target
		self.hit_enemies[enemy:entindex()] = true
		self.targets_count = self.targets_count + 1

		local hit_effect = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_quad_tap_hit.vpcf", PATTACH_CUSTOMORIGIN, enemy)
		ParticleManager:SetParticleControlEnt(hit_effect, 0, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), false) 
		ParticleManager:SetParticleControlEnt(hit_effect, 1, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), false) 
		ParticleManager:ReleaseParticleIndex(hit_effect)

		self.final_damage = self.damage

		local mod = enemy:FindModifierByName("modifier_furion_wrath_of_nature_custom_stack")

		if mod and mod:GetStackCount() >= self.max_stack then 
			enemy:AddNewModifier(self.caster, self.caster:BkbAbility(self:GetAbility(), self.caster:HasScepter()), "modifier_stunned", {duration = (1 - enemy:GetStatusResistance())*self.max_stun})
		end 

		DoDamage({victim = enemy, damage = self.final_damage, damage_type = DAMAGE_TYPE_MAGICAL, attacker = self.caster, ability = self:GetAbility() })
	end
end 


self.position = enemy:GetAbsOrigin()
EmitSoundOnLocationWithCaster(enemy:GetAbsOrigin(), "Furion.WrathOfNature_Damage.Creep", self.caster)

self.new_tree = nil
self.new_target = nil

if self.stage == 1 then 
	self:FindNewTree()
	self.damage = self.damage*(1 + self.legendary_damage)
else 
	self:FindNewTarget()
	self.damage = self.damage*(1 + self.damage_percent_add)
end 

local part_target = enemy

if self.new_tree then 
	part_target = self.new_tree
else 
	if self.new_target then 
		part_target = self.new_target
	end
end 

self.wrath_particle = ParticleManager:CreateParticle("particles/furion/furion_wrath_of_nature_custom.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(self.wrath_particle, 0, enemy:GetAbsOrigin() + Vector(0,0,100))
ParticleManager:SetParticleControl(self.wrath_particle, 1, part_target:GetAbsOrigin() + Vector(0,0,100))
ParticleManager:SetParticleControl(self.wrath_particle, 2, self.last_target:GetAbsOrigin() + Vector(0,0,100))
ParticleManager:SetParticleControl(self.wrath_particle, 3, enemy:GetAbsOrigin() + Vector(0,0,100))
ParticleManager:SetParticleControl(self.wrath_particle, 4, enemy:GetAbsOrigin() + Vector(0,0,100))
ParticleManager:ReleaseParticleIndex(self.wrath_particle)

self.last_target = enemy

self:StartIntervalThink(self.jump_delay)
end



function modifier_furion_wrath_of_nature_custom_legendary:OnDestroy()
if not IsServer() then return end 
if not self.ability then return end

self.ability:FinalHeal(self.final_damage)
end 







modifier_furion_wrath_of_nature_custom_legendary_slow = class({})
function modifier_furion_wrath_of_nature_custom_legendary_slow:IsHidden() return true end
function modifier_furion_wrath_of_nature_custom_legendary_slow:IsPurgable() return true end
function modifier_furion_wrath_of_nature_custom_legendary_slow:OnCreated()

self.ability = self:GetCaster():FindAbilityByName("furion_wrath_of_nature_custom_legendary")
if not self.ability then self:Destroy() return end

self.slow = self.ability:GetSpecialValueFor("slow")
self.attack = self.ability:GetSpecialValueFor("attack")
if not IsServer() then return end 

self.particle_peffect = ParticleManager:CreateParticle("particles/units/heroes/hero_sniper/sniper_headshot_slow.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())	
self:AddParticle(self.particle_peffect, false, false, -1, false, true)

end 


function modifier_furion_wrath_of_nature_custom_legendary_slow:DeclareFunctions()
local funcs = {
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}

return funcs
end

function modifier_furion_wrath_of_nature_custom_legendary_slow:GetModifierMoveSpeedBonus_Percentage()
	return self.slow
end



function modifier_furion_wrath_of_nature_custom_legendary_slow:GetModifierAttackSpeedBonus_Constant()
	return self.attack
end







modifier_furion_wrath_of_nature_custom_perma = class({})
function modifier_furion_wrath_of_nature_custom_perma:IsHidden() return not self:GetCaster():HasTalent("modifier_furion_nature_6") end
function modifier_furion_wrath_of_nature_custom_perma:IsPurgable() return false end
function modifier_furion_wrath_of_nature_custom_perma:RemoveOnDeath() return false end
function modifier_furion_wrath_of_nature_custom_perma:GetTexture() return "buffs/wrath_perma" end
function modifier_furion_wrath_of_nature_custom_perma:OnCreated(table)

self.max = self:GetCaster():GetTalentValue("modifier_furion_nature_6", "max", true)
self.cdr = self:GetCaster():GetTalentValue("modifier_furion_nature_6", "cdr", true)

if not IsServer() then return end
self:SetStackCount(1)
self:StartIntervalThink(0.5)
end

function modifier_furion_wrath_of_nature_custom_perma:OnIntervalThink()
if not IsServer() then return end 
if self:GetStackCount() < self.max then return end
if not self:GetCaster():HasTalent("modifier_furion_nature_6") then return end

local particle_peffect = ParticleManager:CreateParticle("particles/lc_odd_proc_.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControl(particle_peffect, 0, self:GetParent():GetAbsOrigin())
ParticleManager:SetParticleControl(particle_peffect, 2, self:GetParent():GetAbsOrigin())
ParticleManager:ReleaseParticleIndex(particle_peffect)

self:GetCaster():EmitSound("BS.Thirst_legendary_active")
self:StartIntervalThink(-1)
end 

function modifier_furion_wrath_of_nature_custom_perma:OnRefresh()
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end
self:IncrementStackCount()

end


function modifier_furion_wrath_of_nature_custom_perma:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
}
end


function modifier_furion_wrath_of_nature_custom_perma:GetModifierPercentageCooldown() 
if not self:GetCaster():HasTalent("modifier_furion_nature_6") then return end
return self:GetStackCount()*self.cdr
end






modifier_furion_wrath_of_nature_custom_tracker = class({})
function modifier_furion_wrath_of_nature_custom_tracker:IsHidden() return true end
function modifier_furion_wrath_of_nature_custom_tracker:IsPurgable() return false end
function modifier_furion_wrath_of_nature_custom_tracker:OnCreated()
self.caster = self:GetCaster()
self.parent = self:GetParent()
self.parent:AddDeathEvent(self)

self.duration = self:GetCaster():GetTalentValue("modifier_furion_nature_4", "duration", true)
end 

function modifier_furion_wrath_of_nature_custom_tracker:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
	MODIFIER_PROPERTY_HEALTH_BONUS,
}
end


function modifier_furion_wrath_of_nature_custom_tracker:DeathEvent(params)
if not IsServer() then return end 
if not self.caster:HasTalent("modifier_furion_nature_3") then return end
if not params.attacker then return end 

local attacker = params.attacker
if attacker.owner then 
	attacker = attacker.owner
end 

if self.caster ~= attacker then return end 
if not params.unit:IsCreep() then return end

local gold = self.caster:GetTalentValue("modifier_furion_nature_3", "gold")
self.caster:GiveGold(gold)

end 





function modifier_furion_wrath_of_nature_custom_tracker:GetModifierHealthBonus()
if not self.caster:HasTalent("modifier_furion_nature_2") then return end

return self.caster:GetTalentValue("modifier_furion_nature_2", "health")*self.caster:GetIntellect(false)
end 


function modifier_furion_wrath_of_nature_custom_tracker:GetModifierProcAttack_Feedback(params)
if not IsServer() then return end 
if not self.caster:HasTalent("modifier_furion_nature_4") then return end 
if self.caster ~= params.attacker then return end
if not params.target:IsUnit() then return end 


params.target:AddNewModifier(self.caster, self.caster:BkbAbility(self:GetAbility(), self.caster:HasScepter()), "modifier_furion_wrath_of_nature_custom_stack", {duration = self.duration})
end 



modifier_furion_wrath_of_nature_custom_stack = class({})
function modifier_furion_wrath_of_nature_custom_stack:IsHidden() return false end
function modifier_furion_wrath_of_nature_custom_stack:IsPurgable() return false end
function modifier_furion_wrath_of_nature_custom_stack:GetTexture() return "buffs/wrath_stack" end
function modifier_furion_wrath_of_nature_custom_stack:OnCreated()
self.max = self:GetCaster():GetTalentValue("modifier_furion_nature_4", "max")
self.damage = self:GetCaster():GetTalentValue("modifier_furion_nature_4", "damage")
self.legendary_k = self:GetCaster():GetTalentValue("modifier_furion_nature_4", "legendary")
self.caster = self:GetCaster()

if not IsServer() then return end 

self.effect_cast = ParticleManager:CreateParticle( "particles/nature_prophet/wrath_stack.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
self:AddParticle(self.effect_cast,false, false, -1, false, false)

self:SetStackCount(1)
end 

function modifier_furion_wrath_of_nature_custom_stack:OnRefresh()
if not IsServer() then return end 
if self:GetStackCount() >= self.max then return end 

self:IncrementStackCount()

if self:GetStackCount() >= self.max then 

	if self.effect_cast then 
		ParticleManager:DestroyParticle(self.effect_cast, false)
		ParticleManager:ReleaseParticleIndex(self.effect_cast)
		self.effect_cast = nil
	end

	self.mark = ParticleManager:CreateParticle( "particles/nature_prophet/wrath_stack_max.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
	self:AddParticle(self.mark,false, false, -1, false, false)

end 

end 


function modifier_furion_wrath_of_nature_custom_stack:OnStackCountChanged(iStackCount)
if self:GetStackCount() == 0 then return end
if not self.effect_cast then return end 

ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, self:GetStackCount(), 0 ) )

end


function modifier_furion_wrath_of_nature_custom_stack:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOOLTIP,
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
}
end

function modifier_furion_wrath_of_nature_custom_stack:OnTooltip()
return self.damage*self:GetStackCount()
end


function modifier_furion_wrath_of_nature_custom_stack:GetModifierIncomingDamage_Percentage(params)
if not IsServer() then return end
if not params.attacker then return end
if params.attacker ~= self.caster then return end
local inflictor = params.inflictor

if not inflictor then return end
if inflictor:GetName() ~= "furion_wrath_of_nature_custom" and inflictor:GetName() ~= "furion_wrath_of_nature_custom_legendary" then return end

if inflictor:GetName() == "furion_wrath_of_nature_custom_legendary" then 
	return self.damage*self:GetStackCount()/self.legendary_k
end 

return self.damage*self:GetStackCount()
end 







modifier_furion_wrath_of_nature_custom_damage = class({})
function modifier_furion_wrath_of_nature_custom_damage:IsHidden() return false end
function modifier_furion_wrath_of_nature_custom_damage:IsPurgable() return false end
function modifier_furion_wrath_of_nature_custom_damage:GetTexture() return "buffs/wrath_damage" end
function modifier_furion_wrath_of_nature_custom_damage:OnCreated()

self.damage = self:GetCaster():GetTalentValue("modifier_furion_nature_1", "damage_inc")

if not IsServer() then return end 

self:GetParent():EmitSound("Phantom_Assassin.Armor") 

self.particle_peffect = ParticleManager:CreateParticle("particles/hoodwink/bush_damage.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())	
ParticleManager:SetParticleControl(self.particle_peffect, 0, self:GetParent():GetAbsOrigin())
self:AddParticle(self.particle_peffect, false, false, -1, false, true)

self.particle = ParticleManager:CreateParticle("particles/general/generic_armor_reduction.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())	
ParticleManager:SetParticleControl(self.particle, 0, self:GetParent():GetAbsOrigin())
self:AddParticle(self.particle, false, false, -1, false, true)

end

function modifier_furion_wrath_of_nature_custom_damage:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
}
end

function modifier_furion_wrath_of_nature_custom_damage:GetModifierIncomingDamage_Percentage()
return self.damage
end


