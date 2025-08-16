LinkLuaModifier("modifier_furion_sprout_custom", "abilities/furion/furion_sprout_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_furion_sprout_custom_aura", "abilities/furion/furion_sprout_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_furion_sprout_custom_shard_aura", "abilities/furion/furion_sprout_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_furion_sprout_custom_legendary", "abilities/furion/furion_sprout_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_furion_sprout_custom_legendary_treant", "abilities/furion/furion_sprout_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_furion_sprout_custom_legendary_leash", "abilities/furion/furion_sprout_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_furion_sprout_custom_legendary_leash_break", "abilities/furion/furion_sprout_custom", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_furion_sprout_custom_legendary_effect", "abilities/furion/furion_sprout_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_furion_sprout_custom_damage_reduce", "abilities/furion/furion_sprout_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_furion_sprout_custom_tracker", "abilities/furion/furion_sprout_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_furion_sprout_custom_slow", "abilities/furion/furion_sprout_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_furion_sprout_custom_silence", "abilities/furion/furion_sprout_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_furion_sprout_custom_speed", "abilities/furion/furion_sprout_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_furion_sprout_custom_move", "abilities/furion/furion_sprout_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_furion_sprout_custom_shard_effect", "abilities/furion/furion_sprout_custom", LUA_MODIFIER_MOTION_NONE)


furion_sprout_custom = class({})
				

function furion_sprout_custom:CreateTalent()

local ability = self:GetCaster():FindAbilityByName("furion_sprout_custom_legendary")
if ability then 
	ability:SetHidden(false)
end 

end


function furion_sprout_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end


PrecacheResource( "particle", "particles/units/heroes/hero_furion/furion_sprout.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_furion/furion_sprout_damage_aoe.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_furion/furion_sprout_damage.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_furion/furion_curse_of_forest_cast.vpcf", context )
PrecacheResource( "particle", "particles/nature_prophet/sprout_aoe.vpcf", context )
PrecacheResource( "particle", "particles/nature_prophet/sprout_aoe_border.vpcf", context )
PrecacheResource( "particle", "particles/econ/items/treant_protector/ti7_shoulder/treant_ti7_livingarmor.vpcf", context )
PrecacheResource( "particle", "particles/nature_prophet/sprout_treant_death.vpcf", context )
PrecacheResource( "particle", "particles/nature_prophet/sprout_leash.vpcf", context )
PrecacheResource( "particle", "particles/nature_prophet/sprout_hit.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_furion/furion_sprout_damage.vpcf" , context )
PrecacheResource( "particle", "particles/status_fx/status_effect_natures_prophet_curse.vpcf", context )
PrecacheResource( "particle", "particles/status_fx/status_effect_enchantress_shard_debuff.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_sniper/sniper_headshot_slow.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_furion/furion_sprout_damage.vpcf", context )
PrecacheResource( "particle", "particles/items2_fx/heavens_halberd_debuff.vpcf", context )
PrecacheResource( "particle", "particles/generic_gameplay/generic_silenced.vpcf", context )
PrecacheResource( "particle", "particles/nature_prophet/sprout_buff.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_hoodwink/hoodwink_scurry_aura.vpcf", context )
PrecacheResource( "particle", "particles/econ/events/fall_major_2016/blink_dagger_start_fm06.vpcf", context )
PrecacheResource( "particle", "particles/econ/events/fall_major_2016/blink_dagger_end_fm06.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_furion/furion_arboreal_might_buff.vpcf", context )
PrecacheResource( "model", "models/items/furion/treant/the_ancient_guardian_the_ancient_treants/the_ancient_guardian_the_ancient_treants.vmdl", context ) 
end






function furion_sprout_custom:GetIntrinsicModifierName()
if not self:GetCaster():IsRealHero() then return end
return "modifier_furion_sprout_custom_tracker"
end

function furion_sprout_custom:GetCooldown(iLevel)

local bonus = 0
if self:GetCaster():HasTalent("modifier_furion_sprout_1") then 
  bonus = self:GetCaster():GetTalentValue("modifier_furion_sprout_1", "cd")
end
return self.BaseClass.GetCooldown(self, iLevel) + bonus
end


function furion_sprout_custom:GetCastPoint()
local bonus = 0

if self:GetCaster():HasTalent("modifier_furion_sprout_5") then 
  bonus = self:GetCaster():GetTalentValue("modifier_furion_sprout_5", "cast")
end

return self:GetSpecialValueFor("AbilityCastPoint") + bonus
end

function furion_sprout_custom:GetAOERadius()
return self:GetSpecialValueFor( "radius" )
end


function furion_sprout_custom:OnSpellStart(new_target)
self.duration = self:GetSpecialValueFor( "duration" )
self.radius = self:GetSpecialValueFor( "radius" )
self.vision_range = self:GetSpecialValueFor( "vision_range" )
self.tree_count = self:GetSpecialValueFor( "tree_count" )

if self:GetCaster():IsIllusion() then 
	self.duration = 2
end 

if self:GetCaster():HasTalent("modifier_furion_sprout_6") then
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_furion_sprout_custom_move", {duration = self:GetCaster():GetTalentValue("modifier_furion_sprout_6", "duration")})
end 

local hTarget = self:GetCursorTarget()

if new_target then 
	hTarget = new_target
end 

if hTarget ~= nil and hTarget:TriggerSpellAbsorb( self )  then return end

local vTargetPosition = nil

if hTarget ~= nil then 
	vTargetPosition = hTarget:GetOrigin()


else
	vTargetPosition = self:GetCursorPosition()
end


local r = self.radius 
local c = math.sqrt( 2 ) * 0.5 * r 
local x_offset = { -r, -c, 0.0, c, r, c, 0.0, -c }
local y_offset = { 0.0, c, r, c, 0.0, -c, -r, -c }
local treepos =
{
	Vector( -r, 0.0, 0.0 ),
	Vector( -c, c, 0.0 ),
	Vector( 0.0, r, 0.0 ),
	Vector( c, c, 0.0 ),
	Vector( r, 0.0, 0.0 ),
	Vector( c, -c, 0.0 ),
	Vector( 0.0, -r, 0.0 ),
	Vector( -c, c, 0.0 ),

}
local per_level_offset = 64.0

local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_furion/furion_sprout.vpcf", PATTACH_CUSTOMORIGIN, nil )
ParticleManager:SetParticleControl( nFXIndex, 0, vTargetPosition )
ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 0.0, r, 0.0 ) )
ParticleManager:ReleaseParticleIndex( nFXIndex )

local tree_table = {duration = self.duration, }

for i = 1,self.tree_count do
	local tree = CreateTempTree( vTargetPosition + Vector( x_offset[i], y_offset[i], 0.0 ), self.duration )
	table.insert(tree_table, tree:entindex())
end

for i = 1,self.tree_count do
	ResolveNPCPositions( vTargetPosition + Vector( x_offset[i], y_offset[i], 0.0 ), per_level_offset ) 
end

AddFOWViewer( self:GetCaster():GetTeamNumber(), vTargetPosition, self.vision_range, self.duration, false )
EmitSoundOnLocationWithCaster( vTargetPosition, "Hero_Furion.Sprout", self:GetCaster() )

self:EndCd()

CreateModifierThinker( self:GetCaster(), self, "modifier_furion_sprout_custom", tree_table , vTargetPosition, self:GetCaster():GetTeamNumber(), false )

if self:GetCaster():HasShard() then 
	CreateModifierThinker( self:GetCaster(), self, "modifier_furion_sprout_custom_shard_aura", { duration = self.duration }, vTargetPosition, self:GetCaster():GetTeamNumber(), false )
end 

end



function furion_sprout_custom:GetDamage()
local damage = self:GetSpecialValueFor("sprout_damage")

if self:GetCaster():HasTalent("modifier_furion_sprout_2") then 
	damage = damage + (self:GetCaster():GetTalentValue("modifier_furion_sprout_2", "damage")*self:GetCaster():GetIntellect(false)/100)
end 

return damage
end





modifier_furion_sprout_custom = class({})
function modifier_furion_sprout_custom:IsHidden() return true end
function modifier_furion_sprout_custom:IsPurgable() return false end

function modifier_furion_sprout_custom:OnCreated(params)
if not IsServer() then return end 

self.caster = self:GetCaster()
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.trees = {}
for i,tree in pairs(params) do 
	if i ~= "duration" and i ~= "creationtime" then 
		local count = #self.trees + 1

		self.trees[count] = {}

		self.trees[count].tree = EntIndexToHScript(tree)
		self.trees[count].abs = EntIndexToHScript(tree):GetAbsOrigin()
	end 	
end 

self.shard_duration = self.ability:GetSpecialValueFor("shard_duration")
self.shard_active = false

self.blink_ability = self.caster:FindAbilityByName("furion_sprout_custom_blink")
self.caster.sprout_thinker = self:GetParent()

if self.blink_ability and self.blink_ability:IsHidden() and self.caster:HasTalent("modifier_furion_sprout_6") then 
	self.caster:SwapAbilities(self.ability:GetName(), self.blink_ability:GetName(), false, true)
	self.blink_ability:StartCooldown(0.3)
end 

self.radius = self.ability:GetSpecialValueFor("sprout_damage_radius")
self.speed_duration = self.caster:GetTalentValue("modifier_furion_sprout_4", "duration")

local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_furion/furion_sprout_damage_aoe.vpcf", PATTACH_WORLDORIGIN, nil )
ParticleManager:SetParticleControl( particle, 0, self.parent:GetOrigin() )
ParticleManager:SetParticleControl( particle, 1, Vector( self.radius, 0, 0 ) )
self:AddParticle( particle, false, false, -1, false, false )


self.count = -1
self.interval = FrameTime()
self:OnIntervalThink()
self:StartIntervalThink(self.interval)
end 


function modifier_furion_sprout_custom:OnIntervalThink()
if not IsServer() then return end

if self.caster:HasShard() and not self.shard_active and self:GetRemainingTime() > 0.1 then 
	for _,data in pairs(self.trees) do 
		if data.tree and data.tree:IsNull() then 

			local ability = self.caster:FindAbilityByName("furion_force_of_nature_custom")
			if ability and ability:GetLevel() > 0 then 
				local treant = ability:SpawnTreant(data.abs, self.shard_duration, true)
				treant:AddNewModifier(self.caster, ability, "modifier_furion_force_of_nature_custom_root_treant", {})
				treant.is_shard_treant = true
				treant:EmitSound("Furion.Shard_activate")
			end 

			self.shard_active = true
			break
		end 
	end 
end

self.count = self.count + 1
if self.count == 1 then 
	local damageTable = ({attacker = self.caster, ability = self.ability, damage_type = DAMAGE_TYPE_MAGICAL, damage = self.ability:GetDamage()})
	for _,unit in pairs(FindUnitsInRadius(self.caster:GetTeamNumber(), self.parent:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, FIND_CLOSEST, false)) do
		
		if not unit:IsCurrentlyHorizontalMotionControlled() and not unit:IsCurrentlyVerticalMotionControlled() then 
			FindClearSpaceForUnit(unit, unit:GetAbsOrigin(), true)
		end

	 	if self.caster:GetTeamNumber() ~= unit:GetTeamNumber() then

			if self.caster:HasTalent("modifier_furion_sprout_5") then 
				unit:AddNewModifier(self.caster, self.ability, "modifier_furion_sprout_custom_silence", {duration = (1 - unit:GetStatusResistance())*self.caster:GetTalentValue("modifier_furion_sprout_5", "silence")})
			end 

			damageTable.victim = unit
			DoDamage(damageTable)
		end
	end 
end

if not self.caster:HasTalent("modifier_furion_sprout_4") then return end 
if #FindUnitsInRadius(self.caster:GetTeamNumber(), self.parent:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_CLOSEST, false) == 0 then return end
self.caster:AddNewModifier(self.caster, self.ability, "modifier_furion_sprout_custom_speed", {count = self.interval, duration = self.speed_duration})
end 



function modifier_furion_sprout_custom:OnDestroy()
if not IsServer() then return end 

self.caster.sprout_thinker = nil

if self.blink_ability and not self.blink_ability:IsHidden() and self.ability:IsHidden() and self.caster:HasTalent("modifier_furion_sprout_6") then 
	self.caster:SwapAbilities(self.ability:GetName(), self.blink_ability:GetName(), true, false)
end 

self.ability:StartCd()
end 


function modifier_furion_sprout_custom:IsAura()
return true
end

function modifier_furion_sprout_custom:GetModifierAura()
return "modifier_furion_sprout_custom_aura"
end

function modifier_furion_sprout_custom:GetAuraRadius()
return self.radius
end

function modifier_furion_sprout_custom:GetAuraDuration()
return 0.1
end

function modifier_furion_sprout_custom:GetAuraSearchTeam()
return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_furion_sprout_custom:GetAuraSearchType()
return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end





modifier_furion_sprout_custom_aura = class({})
function modifier_furion_sprout_custom_aura:IsHidden() return true end
function modifier_furion_sprout_custom_aura:IsPurgable() return false end
function modifier_furion_sprout_custom_aura:GetEffectName() return "particles/units/heroes/hero_furion/furion_sprout_damage.vpcf" end

function modifier_furion_sprout_custom_aura:OnCreated()

self.parent = self:GetParent()
self.caster = self:GetCaster()

self.resist = self.caster:GetTalentValue("modifier_furion_sprout_2", "resist")
self.damage_reduce_duration = self.caster:GetTalentValue("modifier_furion_sprout_3", "duration")
self.slow_duration = self.caster:GetTalentValue("modifier_furion_sprout_5", "duration")

if not IsServer() then return end 
self.count = -1
self.interval = 0.1
self:OnIntervalThink()
self:StartIntervalThink(self.interval)
end 

function modifier_furion_sprout_custom_aura:OnIntervalThink()
if not IsServer() then return end 
self.count = self.count + 1

if self.count ~= 0 and self.parent:IsRealHero() and self.caster:GetQuest() == "Furion.Quest_5" and not self.caster:QuestCompleted() then 
	self.caster:UpdateQuest(self.interval)
end

if self:GetCaster():HasTalent("modifier_furion_sprout_3") then 
	self.parent:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_furion_sprout_custom_damage_reduce", {duration = self.damage_reduce_duration})
end

end 


function modifier_furion_sprout_custom_aura:OnDestroy()
if not IsServer() then return end 
if not self.caster:HasTalent("modifier_furion_sprout_5") then return end
self.parent:AddNewModifier(self.caster, self:GetAbility(), "modifier_furion_sprout_custom_slow", {duration = self.slow_duration})
end 


function modifier_furion_sprout_custom_aura:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
}
end

function modifier_furion_sprout_custom_aura:GetModifierMagicalResistanceBonus()
if not self.caster:HasTalent("modifier_furion_sprout_2") then return end
return self.resist
end





furion_sprout_custom_legendary = class({})


function furion_sprout_custom_legendary:GetAOERadius()
return self:GetSpecialValueFor("radius")
end


function furion_sprout_custom_legendary:OnSpellStart()

local vTargetPosition = self:GetCursorPosition()
self.radius = self:GetSpecialValueFor("radius")

EmitSoundOnLocationWithCaster(vTargetPosition, "Hero_Furion.CurseOfTheForest.Cast", self:GetCaster())
EmitSoundOnLocationWithCaster(vTargetPosition, "Furion.legendary_cast", self:GetCaster())

local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_furion/furion_curse_of_forest_cast.vpcf", PATTACH_CUSTOMORIGIN, nil )
ParticleManager:SetParticleControl( nFXIndex, 0, vTargetPosition )
ParticleManager:SetParticleControl( nFXIndex, 1, Vector(self.radius*1.1, 0, 0 ) )
ParticleManager:ReleaseParticleIndex( nFXIndex )

CreateModifierThinker( self:GetCaster(), self, "modifier_furion_sprout_custom_legendary", {duration = self:GetCaster():GetTalentValue("modifier_furion_sprout_7", "duration") }, vTargetPosition, self:GetCaster():GetTeamNumber(), false )
end 



modifier_furion_sprout_custom_legendary = class({})
function modifier_furion_sprout_custom_legendary:IsHidden() return true end
function modifier_furion_sprout_custom_legendary:IsPurgable() return false end

function modifier_furion_sprout_custom_legendary:OnCreated(table)
if not IsServer() then return end 

self.point = self:GetParent():GetAbsOrigin()
self.caster = self:GetCaster()
self.parent = self:GetParent()

self.parent:EmitSound("Furion.legendary_loop")
self.parent:EmitSound("Furion.legendary_loop2")

self.radius = self:GetAbility():GetSpecialValueFor("radius")
local health = self:GetCaster():GetMaxHealth()*self:GetCaster():GetTalentValue("modifier_furion_sprout_7", "health")/100
self.max = self:GetCaster():GetTalentValue("modifier_furion_sprout_7", "max")

self.treant = CreateUnitByName("npc_dota_furion_treant_custom_legendary", self.point, false, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber())
self.treant:AddNewModifier(self:GetCaster(), self, "modifier_kill", { duration = self:GetRemainingTime() })
self.treant.owner = self:GetCaster()

self.treant:AddNewModifier(self:GetCaster(), self, "modifier_furion_sprout_custom_legendary_treant", {})

self.treant:SetOwner(nil)
self.treant:SetBaseMaxHealth(health)
self.treant:SetMaxHealth(health)
self.treant:SetHealth(health)
self.treant:SetPhysicalArmorBaseValue(self:GetAbility():GetSpecialValueFor("armor"))
local dir = Vector(0, -1, 0)

self.treant:FaceTowards(self.treant:GetAbsOrigin() + dir*5)
self.treant:SetForwardVector(dir)

self.time = self:GetRemainingTime()

AddFOWViewer(self.caster:GetTeamNumber(), self.point, self.radius, self:GetRemainingTime()*1.2, false)

self.particle = ParticleManager:CreateParticle( "particles/nature_prophet/sprout_aoe.vpcf", PATTACH_WORLDORIGIN, nil )
ParticleManager:SetParticleControl( self.particle, 0, self:GetParent():GetOrigin() )
ParticleManager:SetParticleControl( self.particle, 1, Vector( self.radius, 0, 0 ) )
ParticleManager:SetParticleControl( self.particle, 3, Vector( 1, 0, 0 ) )
self:AddParticle( self.particle, false, false, -1, false, false )

self.border = ParticleManager:CreateParticle( "particles/nature_prophet/sprout_aoe_border.vpcf", PATTACH_WORLDORIGIN, nil )
ParticleManager:SetParticleControl( self.border, 0, self:GetParent():GetOrigin() )
ParticleManager:SetParticleControl( self.border, 1, Vector( self.radius, 0, 0 ) )
ParticleManager:SetParticleControl( self.border, 2, Vector( self.time, 0, 0 ) )
self:AddParticle( self.border, false, false, -1, false, false )


self.tartgets = {}

self.interval = 0.05

self:SetStackCount(0)

self:OnIntervalThink()
self:StartIntervalThink(self.interval)
end 




function modifier_furion_sprout_custom_legendary:OnIntervalThink()
if not IsServer() then return end 

self.caster:UpdateUIshort({max_time = self.time, time = self:GetRemainingTime(), stack = self:GetStackCount(), style = "FurionSprout"})

self.enemies = self.caster:FindTargets(self.radius, self.point)

if self.treant and not self.treant:IsNull() and self.treant:IsAlive() then 
	for _,target in pairs(self.enemies) do 
		if not self.tartgets[target] then 
			self.tartgets[target] = true
			target:AddNewModifier(self.caster, self:GetAbility(), "modifier_furion_sprout_custom_legendary_leash", {treant = self.treant:entindex(), duration = self:GetRemainingTime(), x = self.point.x, y = self.point.y})
		end 
	end 
else 
	if self.border then 
		ParticleManager:DestroyParticle(self.border, true)
		ParticleManager:ReleaseParticleIndex(self.border)
		self.border = nil
	end
end 

end 





function modifier_furion_sprout_custom_legendary:OnDestroy()
if not IsServer() then return end 

self.parent:StopSound("Furion.legendary_loop")
self.parent:StopSound("Furion.legendary_loop2")

self.caster:UpdateUIshort({hide = 1, hide_full = 1, style = "FurionSprout"})
end 




function modifier_furion_sprout_custom_legendary:IsAura()
return true
end

function modifier_furion_sprout_custom_legendary:GetModifierAura()
return "modifier_furion_sprout_custom_legendary_effect"
end

function modifier_furion_sprout_custom_legendary:GetAuraRadius()
return self.radius
end

function modifier_furion_sprout_custom_legendary:GetAuraDuration()
return 0
end

function modifier_furion_sprout_custom_legendary:GetAuraSearchTeam()
return DOTA_UNIT_TARGET_TEAM_ENEMY + DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_furion_sprout_custom_legendary:GetAuraSearchType()
return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end









modifier_furion_sprout_custom_legendary_treant = class({})
function modifier_furion_sprout_custom_legendary_treant:IsHidden() return true end
function modifier_furion_sprout_custom_legendary_treant:IsPurgable() return false end
function modifier_furion_sprout_custom_legendary_treant:CheckState()
return
{
	[MODIFIER_STATE_DISARMED] = true,
	[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
	[MODIFIER_STATE_STUNNED] = true,
	[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
  [MODIFIER_STATE_CANNOT_BE_MOTION_CONTROLLED] = true,
}
end





function modifier_furion_sprout_custom_legendary_treant:OnCreated()
if not IsServer() then return end 

self:GetParent():SetModel("models/items/furion/treant/the_ancient_guardian_the_ancient_treants/the_ancient_guardian_the_ancient_treants.vmdl")
self:GetParent():SetOriginalModel("models/items/furion/treant/the_ancient_guardian_the_ancient_treants/the_ancient_guardian_the_ancient_treants.vmdl")

local particle = ParticleManager:CreateParticle( "particles/econ/items/treant_protector/ti7_shoulder/treant_ti7_livingarmor.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
ParticleManager:SetParticleControl( particle, 0, self:GetParent():GetOrigin() )
ParticleManager:SetParticleControl( particle, 1, self:GetParent():GetOrigin() )
self:AddParticle( particle, false, false, -1, false, false )

end 


function modifier_furion_sprout_custom_legendary_treant:OnDestroy()
if not IsServer() then return end 
self:GetParent():EmitSound("Hero_Furion.TreantDeath")
self:GetParent():EmitSound("Furion.legendary_end")

self:GetParent():AddNoDraw()

local particle = ParticleManager:CreateParticle( "particles/nature_prophet/sprout_treant_death.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl( particle, 0, self:GetParent():GetAbsOrigin() + Vector(0,0,40) )
ParticleManager:ReleaseParticleIndex( particle )

end 


modifier_furion_sprout_custom_legendary_leash = class({})
function modifier_furion_sprout_custom_legendary_leash:IsHidden() return true end
function modifier_furion_sprout_custom_legendary_leash:IsPurgable() return false end
function modifier_furion_sprout_custom_legendary_leash:OnCreated(table)

self.parent = self:GetParent()

if not IsServer() then return end

self.RemoveForDuel = true

self.radius = self:GetAbility():GetSpecialValueFor("radius")
self.point = GetGroundPosition(Vector(table.x, table.y, 0), nil)
self.treant = EntIndexToHScript(table.treant)
self.parent:EmitSound("Furion.WrathOfNature_root_start")
self.parent:EmitSound("Furion.WrathOfNature_root_start2")

self.knock_dist = self.radius*0.5
self.knockback_duration = 0.2

local effect_cast = ParticleManager:CreateParticle( "particles/nature_prophet/sprout_leash.vpcf", PATTACH_ABSORIGIN, self:GetParent() )
ParticleManager:SetParticleControl( effect_cast, 0, self.point )
ParticleManager:SetParticleControlEnt(effect_cast,1,self:GetParent(),PATTACH_POINT_FOLLOW,"attach_hitloc",self:GetParent():GetOrigin(),true)
self:AddParticle(effect_cast,false,false,-1,false,false)

self:OnIntervalThink()
self:StartIntervalThink(FrameTime())
end 




function modifier_furion_sprout_custom_legendary_leash:OnIntervalThink()
if not IsServer() then return end


if not self.treant or self.treant:IsNull() or not self.treant:IsAlive() then 
	self:Destroy()
	return
end

if self.parent:HasModifier("modifier_furion_sprout_custom_legendary_leash_break") then return end
if self.parent:IsInvulnerable() or self:GetParent():IsOutOfGame() then return end
if (self.parent:GetAbsOrigin() - self.point):Length2D() <= self.radius then return end
  
self.parent:EmitSound("Furion.Sprout_knock") 

local vec = (self.parent:GetAbsOrigin() - self.point):Normalized()
local knock_point = self.point + vec*self.knock_dist

self.treant:StartGestureWithPlaybackRate(ACT_DOTA_ATTACK, 1.5)

self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_furion_sprout_custom_legendary_leash_break", {duration = self.knockback_duration, x = knock_point.x, y = knock_point.y})
end





modifier_furion_sprout_custom_legendary_leash_break = class({})

function modifier_furion_sprout_custom_legendary_leash_break:IsHidden() return true end

function modifier_furion_sprout_custom_legendary_leash_break:OnCreated(params)
if not IsServer() then return end
  
self.ability        = self:GetAbility()
self.caster         = self:GetCaster()
self.parent         = self:GetParent()
self:GetParent():StartGesture(ACT_DOTA_FLAIL)

self.knockback_duration   = self:GetRemainingTime()
self.position = GetGroundPosition(Vector(params.x, params.y, 0), nil)

self.knockback_distance = (self:GetParent():GetAbsOrigin() -self.position):Length2D() 

self.knockback_speed    = self.knockback_distance / self.knockback_duration

local hit_effect = ParticleManager:CreateParticle("particles/nature_prophet/sprout_hit.vpcf", PATTACH_CUSTOMORIGIN, self.parent)
ParticleManager:SetParticleControlEnt(hit_effect, 0, self.parent, PATTACH_POINT, "attach_hitloc", self.parent:GetAbsOrigin(), false) 
ParticleManager:SetParticleControlEnt(hit_effect, 1, self.parent, PATTACH_POINT, "attach_hitloc", self.parent:GetAbsOrigin(), false) 
ParticleManager:ReleaseParticleIndex(hit_effect)

if self:ApplyHorizontalMotionController() == false then 
  self:Destroy()
  return
end

end

function modifier_furion_sprout_custom_legendary_leash_break:UpdateHorizontalMotion( me, dt )
if not IsServer() then return end

local distance = (self.position - me:GetOrigin()):Normalized()

me:SetOrigin( me:GetOrigin() + distance * self.knockback_speed * dt )

GridNav:DestroyTreesAroundPoint( self.parent:GetOrigin(), self.parent:GetHullRadius(), true )
end

function modifier_furion_sprout_custom_legendary_leash_break:DeclareFunctions()
local decFuncs = {
  MODIFIER_PROPERTY_OVERRIDE_ANIMATION
  }

  return decFuncs
end

function modifier_furion_sprout_custom_legendary_leash_break:GetOverrideAnimation()
   return ACT_DOTA_FLAIL
end


function modifier_furion_sprout_custom_legendary_leash_break:OnDestroy()
if not IsServer() then return end
self.parent:RemoveHorizontalMotionController( self )
self:GetParent():FadeGesture(ACT_DOTA_FLAIL)

FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetAbsOrigin(), true)
end








modifier_furion_sprout_custom_legendary_effect = class({})
function modifier_furion_sprout_custom_legendary_effect:IsHidden() return true end
function modifier_furion_sprout_custom_legendary_effect:IsPurgable() return false end
function modifier_furion_sprout_custom_legendary_effect:GetEffectName() 
if self:GetCaster():GetTeamNumber() == self:GetParent():GetTeamNumber() then return end
return "particles/units/heroes/hero_furion/furion_sprout_damage.vpcf" 
end

function modifier_furion_sprout_custom_legendary_effect:GetStatusEffectName()
if self:GetCaster():GetTeamNumber() == self:GetParent():GetTeamNumber() then return end
return "particles/status_fx/status_effect_natures_prophet_curse.vpcf"
end 

function modifier_furion_sprout_custom_legendary_effect:StatusEffectPriority()
return MODIFIER_PRIORITY_HIGH 
end


function modifier_furion_sprout_custom_legendary_effect:OnCreated()
self.ability = self:GetCaster():FindAbilityByName("furion_sprout_custom")
if not self.ability then 
	self:Destroy()
	return
end 

self.heal = self:GetAbility():GetSpecialValueFor("heal")/100
self.interval = 0.5
self.damage = self.interval*self.ability:GetDamage()*self:GetAbility():GetSpecialValueFor("base")/100
self.parent = self:GetParent()
self.damage_inc = self:GetCaster():GetTalentValue("modifier_furion_sprout_7", "damage")/100

if not IsServer() then return end 

self.damageTable = ({victim = self:GetParent(), attacker = self:GetCaster(), ability = self:GetAbility(),  damage_type = DAMAGE_TYPE_MAGICAL})

self:OnIntervalThink()
self:StartIntervalThink(self.interval)
end 




function modifier_furion_sprout_custom_legendary_effect:OnIntervalThink()
if not IsServer() then return end 

local thinker = self:GetAuraOwner()
if not thinker or thinker:IsNull() then return end 

local mod = thinker:FindModifierByName("modifier_furion_sprout_custom_legendary")
if not mod then return end 

local damage = self.damage*(1 + self.damage_inc*mod:GetStackCount())

self.damageTable.damage = damage

if self:GetCaster():GetTeamNumber() == self:GetParent():GetTeamNumber() then 
	self.parent:GenericHeal(damage*self.heal, self:GetAbility(), self.parent:IsCreep(), nil, "modifier_furion_sprout_7")
else 
	DoDamage(self.damageTable)
end 

end





modifier_furion_sprout_custom_damage_reduce = class({})



function modifier_furion_sprout_custom_damage_reduce:IsHidden() return false end
function modifier_furion_sprout_custom_damage_reduce:IsPurgable() return false end
function modifier_furion_sprout_custom_damage_reduce:GetTexture() return "buffs/sprout_reduction" end

function modifier_furion_sprout_custom_damage_reduce:OnCreated(table)

self.damage_reduce = self:GetCaster():GetTalentValue("modifier_furion_sprout_3", "damage_reduce")
self.heal_reduce = self:GetCaster():GetTalentValue("modifier_furion_sprout_3", "heal_reduce")
end

function modifier_furion_sprout_custom_damage_reduce:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
	MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
	MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
	MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
	MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE
}
end




function modifier_furion_sprout_custom_damage_reduce:GetStatusEffectName()
return "particles/status_fx/status_effect_enchantress_shard_debuff.vpcf"
end

function modifier_furion_sprout_custom_damage_reduce:StatusEffectPriority()
return MODIFIER_PRIORITY_HIGH
end

function modifier_furion_sprout_custom_damage_reduce:GetModifierDamageOutgoing_Percentage()
return self.damage_reduce
end

function modifier_furion_sprout_custom_damage_reduce:GetModifierSpellAmplify_Percentage()
return self.damage_reduce
end

function modifier_furion_sprout_custom_damage_reduce:GetModifierLifestealRegenAmplify_Percentage() 
return self.heal_reduce
end

function modifier_furion_sprout_custom_damage_reduce:GetModifierHealAmplify_PercentageTarget() 
return self.heal_reduce
end

function modifier_furion_sprout_custom_damage_reduce:GetModifierHPRegenAmplify_Percentage() 
return self.heal_reduce
end




modifier_furion_sprout_custom_tracker = class({})
function modifier_furion_sprout_custom_tracker:IsHidden() return true end
function modifier_furion_sprout_custom_tracker:IsPurgable() return false end
function modifier_furion_sprout_custom_tracker:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING,
}
end


function modifier_furion_sprout_custom_tracker:GetModifierCastRangeBonusStacking()
if not self.caster:HasTalent("modifier_furion_sprout_1") then return end 

return self.caster:GetTalentValue("modifier_furion_sprout_1", "range")
end


function modifier_furion_sprout_custom_tracker:OnCreated()
self.caster = self:GetCaster()
self.caster:AddAttackEvent_out(self)
self.max = self:GetCaster():GetTalentValue("modifier_furion_sprout_7", "max", true)
end 



function modifier_furion_sprout_custom_tracker:AttackEvent_out(params)
if not IsServer() then return end 
if self.caster ~= params.attacker then return end 
if not params.target:IsUnit() then return end

local mod = self.caster:FindModifierByName("modifier_furion_sprout_custom_legendary_effect")
if not mod then return end 
if not mod:GetAuraOwner() then return end

local owner_mod = mod:GetAuraOwner():FindModifierByName("modifier_furion_sprout_custom_legendary")
if not owner_mod then return end

if owner_mod:GetStackCount() >= self.max then return end
owner_mod:IncrementStackCount()
end 





modifier_furion_sprout_custom_slow = class({})
function modifier_furion_sprout_custom_slow:IsHidden() return true end
function modifier_furion_sprout_custom_slow:IsPurgable() return true end
function modifier_furion_sprout_custom_slow:OnCreated()

self.slow = self:GetCaster():GetTalentValue("modifier_furion_sprout_5", "slow")
if not IsServer() then return end 
self.particle_peffect = ParticleManager:CreateParticle("particles/units/heroes/hero_sniper/sniper_headshot_slow.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())	
self:AddParticle(self.particle_peffect, false, false, -1, false, true)
self:GetParent():EmitSound("Furion.Sprout_slow")
end 

function modifier_furion_sprout_custom_slow:DeclareFunctions()
return 
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
}
end

function modifier_furion_sprout_custom_slow:GetModifierMoveSpeedBonus_Percentage()
return self.slow
end
function modifier_furion_sprout_custom_slow:GetEffectName() return "particles/units/heroes/hero_furion/furion_sprout_damage.vpcf" end






modifier_furion_sprout_custom_silence = class({})

function modifier_furion_sprout_custom_silence:IsHidden() return true end
function modifier_furion_sprout_custom_silence:IsPurgable() return true end
function modifier_furion_sprout_custom_silence:OnCreated(table)
if not IsServer() then return end

self.particle_peffect = ParticleManager:CreateParticle("particles/items2_fx/heavens_halberd_debuff.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())	
self:AddParticle(self.particle_peffect, false, false, -1, false, true)

self:GetParent():EmitSound("Sf.Raze_Silence")
end

function modifier_furion_sprout_custom_silence:CheckState()
return
{
	[MODIFIER_STATE_SILENCED] = true,
}
end


function modifier_furion_sprout_custom_silence:GetEffectName() return "particles/generic_gameplay/generic_silenced.vpcf" end

function modifier_furion_sprout_custom_silence:ShouldUseOverheadOffset() return true end
function modifier_furion_sprout_custom_silence:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end








modifier_furion_sprout_custom_speed = class({})
function modifier_furion_sprout_custom_speed:IsHidden() return false end
function modifier_furion_sprout_custom_speed:IsPurgable() return false end
function modifier_furion_sprout_custom_speed:GetTexture() return "buffs/sprout_buff" end
function modifier_furion_sprout_custom_speed:OnCreated(table)

self.speed = self:GetCaster():GetTalentValue("modifier_furion_sprout_4", "speed")
self.max = self:GetCaster():GetTalentValue("modifier_furion_sprout_4", "max")
self.amp = self:GetCaster():GetTalentValue("modifier_furion_sprout_4", "damage")

if not IsServer() then return end 
self.count = table.count
end 

function modifier_furion_sprout_custom_speed:OnRefresh(table)
if not IsServer() then return end 
self.count = self.count + table.count

if self.count < 1 then return end 
self.count = 0

if self:GetStackCount() >= self.max then return end 

self:IncrementStackCount()

if self:GetStackCount() >= self.max then 
	self:GetParent():EmitSound("Furion.Sprout_buff")
	self.particle = ParticleManager:CreateParticle( "particles/nature_prophet/sprout_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( self.particle, 0, self:GetParent():GetAbsOrigin() )
	ParticleManager:SetParticleControl( self.particle, 1, self:GetParent():GetAbsOrigin() )
	ParticleManager:SetParticleControl( self.particle, 2, self:GetParent():GetAbsOrigin() )
	self:AddParticle(self.particle, false, false, 0, true, false)
end 

end



function modifier_furion_sprout_custom_speed:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE
}
end

function modifier_furion_sprout_custom_speed:GetModifierAttackSpeedBonus_Constant()
return self.speed*self:GetStackCount()
end

function modifier_furion_sprout_custom_speed:GetModifierSpellAmplify_Percentage()
return self.amp*self:GetStackCount()
end






modifier_furion_sprout_custom_move = class({})
function modifier_furion_sprout_custom_move:IsHidden() return false end
function modifier_furion_sprout_custom_move:IsPurgable() return false end
function modifier_furion_sprout_custom_move:GetTexture() return "buffs/sprout_move" end
function modifier_furion_sprout_custom_move:OnCreated()

self.speed = self:GetCaster():GetTalentValue("modifier_furion_sprout_6", "speed")
if not IsServer() then return end 

self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_hoodwink/hoodwink_scurry_aura.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
self:AddParticle(self.particle, false, false, -1, true, false)
end 

function modifier_furion_sprout_custom_move:CheckState()
local state = {
	[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	[MODIFIER_STATE_ALLOW_PATHING_THROUGH_TREES] = true,
}

return state
end



function modifier_furion_sprout_custom_move:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end

function modifier_furion_sprout_custom_move:GetModifierMoveSpeedBonus_Percentage()
return self.speed
end



furion_sprout_custom_blink = class({})

function furion_sprout_custom_blink:GetCastRange(vLocation, hTarget)
return self:GetCaster():GetTalentValue("modifier_furion_sprout_6", "range")
end



function furion_sprout_custom_blink:OnAbilityPhaseStart()
if not self:GetCaster().sprout_thinker or self:GetCaster().sprout_thinker:IsNull() then return false end


if (self:GetCaster():GetAbsOrigin() - self:GetCaster().sprout_thinker:GetAbsOrigin()):Length2D() > self:GetCaster():GetTalentValue("modifier_furion_sprout_6", "range") then 

	self:GetCaster():SendError("#midteleport_distance")
	return false
end

return true
end 

function furion_sprout_custom_blink:GetBehavior()
return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_ROOT_DISABLES
end

function furion_sprout_custom_blink:OnSpellStart()

local ability = self:GetCaster():FindAbilityByName("furion_sprout_custom")
if not ability then return end 

EmitSoundOnLocationWithCaster(self:GetCaster():GetAbsOrigin(), "Furion.Blink_start", self:GetCaster())

local particle3 = ParticleManager:CreateParticle("particles/econ/events/fall_major_2016/blink_dagger_start_fm06.vpcf", PATTACH_WORLDORIGIN, nil )
ParticleManager:SetParticleControl( particle3, 0, self:GetCaster():GetAbsOrigin()  )
ParticleManager:ReleaseParticleIndex(particle3)


self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_4, 1.3)

FindClearSpaceForUnit(self:GetCaster(), self:GetCaster().sprout_thinker:GetAbsOrigin(), true)

ProjectileManager:ProjectileDodge(self:GetCaster())

EmitSoundOnLocationWithCaster(self:GetCaster():GetAbsOrigin(), "Furion.Blink_end", self:GetCaster())
EmitSoundOnLocationWithCaster(self:GetCaster():GetAbsOrigin(), "Furion.Blink_end2", self:GetCaster())

particle3 = ParticleManager:CreateParticle("particles/econ/events/fall_major_2016/blink_dagger_end_fm06.vpcf", PATTACH_WORLDORIGIN, nil )
ParticleManager:SetParticleControl( particle3, 0, self:GetCaster():GetAbsOrigin()  )
ParticleManager:ReleaseParticleIndex(particle3)


if ability:IsHidden() then 
	self:GetCaster():SwapAbilities(self:GetName(), ability:GetName(), false, true)
end 

end 



modifier_furion_sprout_custom_shard_aura = class({})
function modifier_furion_sprout_custom_shard_aura:IsHidden() return true end
function modifier_furion_sprout_custom_shard_aura:IsPurgable() return false end
function modifier_furion_sprout_custom_shard_aura:OnCreated()
self.radius = self:GetAbility():GetSpecialValueFor("shard_radius")

end 




function modifier_furion_sprout_custom_shard_aura:IsAura()
return true
end

function modifier_furion_sprout_custom_shard_aura:GetModifierAura()
return "modifier_furion_sprout_custom_shard_effect"
end

function modifier_furion_sprout_custom_shard_aura:GetAuraRadius()
return self.radius
end

function modifier_furion_sprout_custom_shard_aura:GetAuraDuration()
return 0
end

function modifier_furion_sprout_custom_shard_aura:GetAuraSearchTeam()
return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_furion_sprout_custom_shard_aura:GetAuraSearchType()
return DOTA_UNIT_TARGET_BASIC
end

function modifier_furion_sprout_custom_shard_aura:GetAuraEntityReject(hEntity)
return not hEntity.is_treant
end



modifier_furion_sprout_custom_shard_effect = class({})
function modifier_furion_sprout_custom_shard_effect:IsHidden() return false end
function modifier_furion_sprout_custom_shard_effect:IsPurgable() return false end
function modifier_furion_sprout_custom_shard_effect:OnCreated()

self.speed = self:GetAbility():GetSpecialValueFor("shard_speed")
self.range = self:GetAbility():GetSpecialValueFor("shard_range")
end

function modifier_furion_sprout_custom_shard_effect:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
end


function modifier_furion_sprout_custom_shard_effect:GetModifierAttackSpeedBonus_Constant()
return self.speed
end

function modifier_furion_sprout_custom_shard_effect:GetModifierAttackRangeBonus()
return self.range
end

function modifier_furion_sprout_custom_shard_effect:GetEffectName()
return "particles/units/heroes/hero_furion/furion_arboreal_might_buff.vpcf"
end
