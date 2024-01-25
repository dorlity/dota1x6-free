LinkLuaModifier("modifier_custom_void_dissimilate", "abilities/void_spirit/void_spirit_dissimilate_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_void_dissimilate_speed_thinker", "abilities/void_spirit/void_spirit_dissimilate_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_void_dissimilate_slow", "abilities/void_spirit/void_spirit_dissimilate_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_void_dissimilate_resist_tracker", "abilities/void_spirit/void_spirit_dissimilate_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_void_dissimilate_resist", "abilities/void_spirit/void_spirit_dissimilate_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_void_dissimilate_exit", "abilities/void_spirit/void_spirit_dissimilate_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_void_dissimilate_root", "abilities/void_spirit/void_spirit_dissimilate_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_void_dissimilate_heal", "abilities/void_spirit/void_spirit_dissimilate_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_void_dissimilate_speed", "abilities/void_spirit/void_spirit_dissimilate_custom", LUA_MODIFIER_MOTION_NONE)



void_spirit_dissimilate_custom = class({})






function void_spirit_dissimilate_custom:Precache(context)

PrecacheResource( "particle", "particles/units/heroes/hero_void_spirit/dissimilate/void_spirit_dissimilate.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_void_spirit/dissimilate/void_spirit_dissimilate_2.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_void_spirit/dissimilate/void_spirit_dissimilate_dmg.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_void_spirit/dissimilate/void_spirit_dissimilate_exit.vpcf", context )
PrecacheResource( "particle", "particles/void_astral_slow.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_void_spirit/dissimilate/void_spirit_dissimilate_52.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_vengeful/void_astral_resist.vpcf", context )

end



function void_spirit_dissimilate_custom:GetCastPoint(iLevel)
if self:GetCaster():HasModifier('modifier_void_astral_5') then 
    return self:GetCaster():GetTalentValue("modifier_void_astral_5", "cast")
end

return self.BaseClass.GetCastPoint(self)
end



function void_spirit_dissimilate_custom:GetCooldown(iLevel)

local upgrade_cooldown = 0


 return self.BaseClass.GetCooldown(self, iLevel) + upgrade_cooldown

end


function void_spirit_dissimilate_custom:OnSpellStart()

local caster = self:GetCaster()

local duration = self:GetSpecialValueFor( "phase_duration" )

if self:GetCaster():HasModifier("modifier_void_astral_legendary") then 
	duration = self:GetCaster():GetTalentValue("modifier_void_astral_legendary", "duration")
end

caster:AddNewModifier(
	caster, -- player source
	self, -- ability source
	"modifier_custom_void_dissimilate", -- modifier name
	{ duration = duration } -- kv
)



local sound_cast = "Hero_VoidSpirit.Dissimilate.Cast"
self:GetCaster():EmitSound("sound_cast")




if not IsServer() then end

if self:GetCaster():HasModifier("modifier_void_astral_5") then 

	local effect = ParticleManager:CreateParticle("particles/items3_fx/blink_arcane_start.vpcf", PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(effect, 0, self:GetCaster():GetAbsOrigin())
end

self:EndCooldown()
end




modifier_custom_void_dissimilate = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_custom_void_dissimilate:IsHidden()
	return false
end

function modifier_custom_void_dissimilate:IsDebuff()
	return false
end

function modifier_custom_void_dissimilate:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_custom_void_dissimilate:OnCreated( kv )

self.portals = self:GetAbility():GetSpecialValueFor( "portals_per_ring" )
self.angle = self:GetAbility():GetSpecialValueFor( "angle_per_ring_portal" )
self.radius = self:GetAbility():GetSpecialValueFor( "damage_radius" )
self.distance = self:GetAbility():GetSpecialValueFor( "first_ring_distance_offset" )
self.target_radius = self:GetAbility():GetSpecialValueFor( "destination_fx_radius" )

self.RemoveForDuel = true

if not IsServer() then return end

if self:GetCaster():HasModifier("modifier_void_astral_legendary") and not self:GetAbility():IsHidden() then 
	self:GetCaster():SwapAbilities("void_spirit_dissimilate_custom_cancel", "void_spirit_dissimilate_custom", true, false)

	local ability = self:GetCaster():FindAbilityByName("void_spirit_dissimilate_custom_cancel")

	if ability then 
		ability:StartCooldown(0.3)
	end
end

local origin = self:GetParent():GetOrigin()
local direction = self:GetParent():GetForwardVector()
local zero = Vector(0,0,0)

self.selected = 1

self.points = {}
self.effects = {}
self.thinkers = {}

table.insert( self.points, origin )
table.insert( self.effects, self:PlayEffects1( origin, true ) )

if self:GetParent():HasModifier("modifier_void_astral_3") then 
	local thinker = CreateModifierThinker(self:GetCaster(), self:GetAbility(), "modifier_custom_void_dissimilate_speed_thinker", {radius = self.radius}, origin, self:GetCaster():GetTeamNumber(), false)
	table.insert( self.thinkers, thinker )	
end

for i=1,self.portals do
	local new_direction = RotatePosition( zero, QAngle( 0, self.angle*i, 0 ), direction )

	local point = GetGroundPosition( origin + new_direction * self.distance, nil )

	table.insert( self.points, point )
	table.insert( self.effects, self:PlayEffects1( point, false ) )

	if self:GetParent():HasModifier("modifier_void_astral_3") then 
		local thinker = CreateModifierThinker(self:GetCaster(), self:GetAbility(), "modifier_custom_void_dissimilate_speed_thinker", {radius = self.radius}, point, self:GetCaster():GetTeamNumber(), false)
		table.insert( self.thinkers, thinker )	
	end

end

if self:GetParent():HasModifier("modifier_void_astral_legendary") then 
	for i=1,self.portals do
		local new_direction = RotatePosition( zero, QAngle( 0, self.angle*i, 0 ), direction )

		local point = GetGroundPosition( origin + new_direction * self.distance*2, nil )

		table.insert( self.points, point )
		table.insert( self.effects, self:PlayEffects1( point, false ) )
	end
end


self.NoDraw = true

self:GetParent():AddNoDraw()

if self:GetParent():HasModifier("modifier_void_astral_legendary") then 
	self:StartIntervalThink(self:GetRemainingTime()/(10) - FrameTime())
end

end

function modifier_custom_void_dissimilate:OnIntervalThink()
if not IsServer() then return end
self:IncrementStackCount()
end


function modifier_custom_void_dissimilate:OnRefresh( kv )
	
end

function modifier_custom_void_dissimilate:OnRemoved()
end

function modifier_custom_void_dissimilate:OnDestroy()
if not IsServer() then return end

self:GetParent():RemoveNoDraw()

if self:GetCaster():HasModifier("modifier_void_astral_legendary") and self:GetAbility():IsHidden() then 
	self:GetCaster():SwapAbilities("void_spirit_dissimilate_custom_cancel", "void_spirit_dissimilate_custom", false, true)
end

for _,effect in pairs(self.effects) do 
	ParticleManager:DestroyParticle(effect, true)
	ParticleManager:ReleaseParticleIndex(effect)
end

local point = self.points[self.selected]

local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), point, nil, self.radius,DOTA_UNIT_TARGET_TEAM_ENEMY,DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,0,0,false)

local damage = self:GetAbility():GetAbilityDamage()

if self:GetParent():HasModifier("modifier_void_astral_1") then 
	damage = damage + self:GetCaster():GetTalentValue("modifier_void_astral_1", "damage")*self:GetCaster():GetIntellect()/100
end

local old_pos = self:GetCaster():GetAbsOrigin()

FindClearSpaceForUnit( self:GetCaster(), point, true )

if self:GetStackCount() > 0 then 
	damage = damage*(1 + ((self:GetCaster():GetTalentValue("modifier_void_astral_legendary", "damage")/10)*self:GetStackCount())/100)
end

for _,thinker in pairs(self.thinkers) do 
	if thinker and thinker:GetAbsOrigin() == point and self:GetParent():HasModifier("modifier_void_astral_6") then 
		local mod = thinker:FindModifierByName("modifier_custom_void_dissimilate_speed_thinker")
		if mod then 
			mod:SetDuration(self:GetCaster():GetTalentValue("modifier_void_astral_6", "duration"), true)
		end
	else 
		UTIL_Remove( thinker )
	end
end

if self:GetParent():HasModifier("modifier_void_astral_6") then 
	CreateModifierThinker(self:GetCaster(), self:GetAbility(), "modifier_custom_void_dissimilate_resist_tracker", {duration = self:GetCaster():GetTalentValue("modifier_void_astral_6", "duration"), radius = self.radius}, point, self:GetCaster():GetTeamNumber(), false)
end	


local root_duration = self:GetCaster():GetTalentValue("modifier_void_astral_5", "root")

for _,enemy in pairs(enemies) do

	local deal_damage = damage

	local damageTable = { victim = enemy, attacker = self:GetCaster(), damage = deal_damage, damage_type = self:GetAbility():GetAbilityDamageType(), ability = self:GetAbility(), }

	if enemy:IsRealHero() and self:GetCaster():GetQuest() == "Void.Quest_6" and point == old_pos then 
		self:GetCaster():UpdateQuest(1)
	end

	if self:GetCaster():HasModifier("modifier_void_step_4") and not enemy:HasModifier("modifier_void_spirit_astral_step_spells_max") then 
		enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_void_spirit_astral_step_spells", {duration = self:GetCaster():GetTalentValue("modifier_void_step_4", "duration")})
	end


	if self:GetParent():HasModifier("modifier_void_astral_5") then 
		enemy:EmitSound("Lc.Press_Root")
		enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_void_dissimilate_root", {duration = (1 - enemy:GetStatusResistance())*root_duration})
	end		

	ApplyDamage(damageTable)
end

if self:GetParent():HasModifier("modifier_void_astral_4") then 

	CreateModifierThinker(self:GetCaster(), self:GetAbility(), "modifier_custom_void_dissimilate_exit", {duration = self:GetCaster():GetTalentValue("modifier_void_astral_4", "delay"), radius = self.radius}, self:GetCaster():GetAbsOrigin(), self:GetCaster():GetTeamNumber(), false)
end

if #enemies > 0 and self:GetCaster():HasModifier("modifier_void_astral_2") then 
	self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_void_dissimilate_heal", {duration = self:GetCaster():GetTalentValue("modifier_void_astral_2", "duration")})
end

if self:GetCaster():HasModifier("modifier_void_astral_3") then 
	self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_void_dissimilate_speed", {duration = self:GetCaster():GetTalentValue("modifier_void_astral_3", "duration")})
end

self:GetAbility():UseResources(false, false, false, true)


self:PlayEffects2( point, #enemies )
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_custom_void_dissimilate:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ORDER,

		MODIFIER_PROPERTY_MOVESPEED_LIMIT,
	}

	return funcs
end

function modifier_custom_void_dissimilate:OnOrder( params )
	if params.unit~=self:GetParent() then return end


	if 	params.order_type==DOTA_UNIT_ORDER_MOVE_TO_POSITION then
		self:SetValidTarget( params.new_pos )
	elseif 
		params.order_type==DOTA_UNIT_ORDER_MOVE_TO_TARGET or
		params.order_type==DOTA_UNIT_ORDER_ATTACK_TARGET
	then
		self:SetValidTarget( params.target:GetOrigin() )
	end

	if self:GetParent():HasModifier("modifier_void_astral_legendary") then 
		--self:Destroy()
	end
end

function modifier_custom_void_dissimilate:GetModifierMoveSpeed_Limit()
	return 0.1
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_custom_void_dissimilate:CheckState()
local state = {}

 
	state = 
	{
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_SILENCED] = true,
		[MODIFIER_STATE_MUTED] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true
	}

	return state
end

--------------------------------------------------------------------------------
-- Helper
function modifier_custom_void_dissimilate:SetValidTarget( location )
	-- find max
	local max_dist = (location-self.points[1]):Length2D()
	local max_point = 1
	for i,point in ipairs(self.points) do
		local dist = (location-point):Length2D()
		if dist<max_dist then
			max_dist = dist
			max_point = i
		end
	end

	-- select
	local old_select = self.selected
	self.selected = max_point

	-- change effects
	self:ChangeEffects( old_select, self.selected )
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_custom_void_dissimilate:PlayEffects1( point, main )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_void_spirit/dissimilate/void_spirit_dissimilate.vpcf"
	local sound_cast = "Hero_VoidSpirit.Dissimilate.Portals"

	if self:GetParent():HasModifier("modifier_void_astral_legendary") then 
		particle_cast = "particles/units/heroes/hero_void_spirit/dissimilate/void_spirit_dissimilate_2.vpcf"
	end
	-- adjustments
	local radius = self.radius + 25

	-- Create Particle for this team
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetParent())
	ParticleManager:SetParticleControl( effect_cast, 0, point )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, 0, 1 ) )

	if main then
		ParticleManager:SetParticleControl( effect_cast, 2, Vector( 1, 0, 0 ) )
	end

	-- buff particle
	self:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	-- Play Sound
	EmitSoundOnLocationWithCaster( point, sound_cast, self:GetCaster() )

	return effect_cast
end

function modifier_custom_void_dissimilate:ChangeEffects( old, new )
	ParticleManager:SetParticleControl( self.effects[old], 2, Vector( 0, 0, 0 ) )
	ParticleManager:SetParticleControl( self.effects[new], 2, Vector( 1, 0, 0 ) )
end

function modifier_custom_void_dissimilate:PlayEffects2( point, hit )
	


	local particle_cast = "particles/units/heroes/hero_void_spirit/dissimilate/void_spirit_dissimilate_dmg.vpcf"
	local particle_cast2 = "particles/units/heroes/hero_void_spirit/dissimilate/void_spirit_dissimilate_exit.vpcf"
	local sound_cast = "Hero_VoidSpirit.Dissimilate.TeleportIn"
	local sound_hit = "Hero_VoidSpirit.Dissimilate.Stun"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 0, point )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.target_radius, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	local effect_cast = ParticleManager:CreateParticle( particle_cast2, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	self:GetParent():StartGesture(ACT_DOTA_CAST_ABILITY_3_END)
	self:GetParent():EmitSound(sound_cast)
	
	if hit>0 then
		self:GetParent():EmitSound(sound_hit)
	end
end







modifier_custom_void_dissimilate_speed_thinker = class({})

function modifier_custom_void_dissimilate_speed_thinker:IsHidden() return true end

function modifier_custom_void_dissimilate_speed_thinker:IsPurgable() return false end

function modifier_custom_void_dissimilate_speed_thinker:IsAura() return true end

function modifier_custom_void_dissimilate_speed_thinker:GetAuraDuration() return 0.2 end


function modifier_custom_void_dissimilate_speed_thinker:GetAuraRadius() return self.radius
end

function modifier_custom_void_dissimilate_speed_thinker:OnCreated(table)
self.radius = table.radius
end


function modifier_custom_void_dissimilate_speed_thinker:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end

function modifier_custom_void_dissimilate_speed_thinker:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO +  DOTA_UNIT_TARGET_BASIC end

function modifier_custom_void_dissimilate_speed_thinker:GetModifierAura() return "modifier_custom_void_dissimilate_slow" end



modifier_custom_void_dissimilate_slow = class({})

function modifier_custom_void_dissimilate_slow:IsPurgable() return false end

function modifier_custom_void_dissimilate_slow:IsHidden() return false end 
function modifier_custom_void_dissimilate_slow:IsDebuff() return true end
function modifier_custom_void_dissimilate_slow:GetTexture() return "buffs/astral_slow" end


function modifier_custom_void_dissimilate_slow:GetEffectName() return "particles/void_astral_slow.vpcf" end

function modifier_custom_void_dissimilate_slow:DeclareFunctions()
return
{
 MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
}

end


function modifier_custom_void_dissimilate_slow:OnCreated()

self.slow = self:GetCaster():GetTalentValue("modifier_void_astral_3", "slow")
end

function modifier_custom_void_dissimilate_slow:GetModifierMoveSpeedBonus_Percentage() 
return self.slow
end




modifier_custom_void_dissimilate_resist_tracker = class({})

function modifier_custom_void_dissimilate_resist_tracker:IsHidden() return true end

function modifier_custom_void_dissimilate_resist_tracker:IsPurgable() return false end

function modifier_custom_void_dissimilate_resist_tracker:IsAura() return true end

function modifier_custom_void_dissimilate_resist_tracker:GetAuraDuration() return 0.1 end


function modifier_custom_void_dissimilate_resist_tracker:GetAuraRadius() return self.radius
end

function modifier_custom_void_dissimilate_resist_tracker:OnCreated(table)
self.radius = table.radius

if not IsServer() then return end
particle_cast = "particles/units/heroes/hero_void_spirit/dissimilate/void_spirit_dissimilate_52.vpcf"

local radius = self.radius + 25


local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetAbsOrigin() )
ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, 0, 1 ) )


self:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)
end


function modifier_custom_void_dissimilate_resist_tracker:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY
 end

function modifier_custom_void_dissimilate_resist_tracker:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO end

function modifier_custom_void_dissimilate_resist_tracker:GetModifierAura() return "modifier_custom_void_dissimilate_resist" end





modifier_custom_void_dissimilate_resist = class({})

function modifier_custom_void_dissimilate_resist:IsPurgable() return false end

function modifier_custom_void_dissimilate_resist:IsHidden() return false end 
function modifier_custom_void_dissimilate_resist:GetTexture() return "buffs/astral_resist" end
function modifier_custom_void_dissimilate_resist:GetEffectName()
	return "particles/units/heroes/hero_vengeful/void_astral_resist.vpcf"
end

function modifier_custom_void_dissimilate_resist:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_custom_void_dissimilate_resist:OnCreated()
self.damage = self:GetCaster():GetTalentValue("modifier_void_astral_6", "damage_reduce")

self.interval = 0.5

self.cd = self.interval* self:GetCaster():GetTalentValue("modifier_void_astral_6", "cd_items")/100

if not IsServer() then return end 

self:StartIntervalThink(self.interval - FrameTime())
end

function modifier_custom_void_dissimilate_resist:OnIntervalThink()
if not IsServer() then return end 

self:GetCaster():CdItems(self.cd)
end 

function modifier_custom_void_dissimilate_resist:DeclareFunctions()
return
{
 MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
}

end
function modifier_custom_void_dissimilate_resist:GetModifierIncomingDamage_Percentage()
return self.damage
end






void_spirit_dissimilate_custom_cancel = class({})


function void_spirit_dissimilate_custom_cancel:OnSpellStart()
if not IsServer() then return end

local mod = self:GetCaster():FindModifierByName("modifier_custom_void_dissimilate")

if not mod then return end

mod:Destroy()

end




modifier_custom_void_dissimilate_exit = class({})
function modifier_custom_void_dissimilate_exit:IsHidden() return false end
function modifier_custom_void_dissimilate_exit:IsPurgable() return false end
function modifier_custom_void_dissimilate_exit:OnCreated(table)
if not IsServer() then return end
self.radius = self:GetAbility():GetSpecialValueFor( "damage_radius" )
self.visual_radius = self:GetAbility():GetSpecialValueFor( "destination_fx_radius" )

self.damage_creeps = self:GetCaster():GetTalentValue("modifier_void_astral_4", "damage_creeps")
self.stun = self:GetCaster():GetTalentValue("modifier_void_astral_4", "stun")
self.damage = self:GetCaster():GetTalentValue("modifier_void_astral_4", "damage")/100
end


function modifier_custom_void_dissimilate_exit:OnDestroy()
if not IsServer() then return end

local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.radius, 	DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC , 0, 0, false )

for _,enemy in pairs(enemies) do 

	local damage = self.damage*(enemy:GetMaxHealth() - enemy:GetHealth())

	if enemy:IsCreep() then 
		damage = damage*self.damage_creeps
	end

	self.damageTable = {
		victim = enemy,
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility(), --Optional.
	}

	local real_damage = ApplyDamage(self.damageTable)

	enemy:SendNumber(6, real_damage)
	enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stunned", {duration = (1 - enemy:GetStatusResistance())*self.stun})
		
end




local particle_cast = "particles/units/heroes/hero_void_spirit/dissimilate/void_spirit_dissimilate_dmg.vpcf"
local particle_cast2 = "particles/units/heroes/hero_void_spirit/dissimilate/void_spirit_dissimilate_exit.vpcf"
local sound_cast = "Hero_VoidSpirit.Dissimilate.TeleportIn"

local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN,  nil)
ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetAbsOrigin() )
ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.visual_radius, 0, 0 ) )
ParticleManager:ReleaseParticleIndex( effect_cast )

local effect_cast = ParticleManager:CreateParticle( particle_cast2, PATTACH_WORLDORIGIN,nil )
ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetAbsOrigin() )
ParticleManager:ReleaseParticleIndex( effect_cast )

self:GetParent():EmitSound(sound_cast)
	

end





modifier_custom_void_dissimilate_root = class({})
function modifier_custom_void_dissimilate_root:IsHidden() return true end
function modifier_custom_void_dissimilate_root:IsPurgable() return true end
function modifier_custom_void_dissimilate_root:CheckState()
return
{
	[MODIFIER_STATE_ROOTED] = true
}
end
function modifier_custom_void_dissimilate_root:GetEffectName() return "particles/ta_shield_roots.vpcf" end








modifier_custom_void_dissimilate_heal = class({})
function modifier_custom_void_dissimilate_heal:IsHidden() return false end
function modifier_custom_void_dissimilate_heal:IsPurgable() return false end
function modifier_custom_void_dissimilate_heal:GetTexture() return "buffs/arcane_regen" end

function modifier_custom_void_dissimilate_heal:OnCreated(table)

self.heal = self:GetParent():GetMaxMana()*(self:GetCaster():GetTalentValue("modifier_void_astral_2", "mana")/100)/self:GetCaster():GetTalentValue("modifier_void_astral_2", "duration")

end

function modifier_custom_void_dissimilate_heal:OnRefresh(table)
self:OnCreated(table)
end


function modifier_custom_void_dissimilate_heal:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
  MODIFIER_PROPERTY_MANA_REGEN_CONSTANT
}
end


function modifier_custom_void_dissimilate_heal:GetEffectName() return "particles/units/heroes/hero_oracle/oracle_purifyingflames.vpcf" end

function modifier_custom_void_dissimilate_heal:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

function modifier_custom_void_dissimilate_heal:GetModifierConstantManaRegen()
return self.heal
end


function modifier_custom_void_dissimilate_heal:GetModifierConstantHealthRegen()
return self.heal
end




modifier_custom_void_dissimilate_speed = class({})
function modifier_custom_void_dissimilate_speed:IsHidden() return true end
function modifier_custom_void_dissimilate_speed:IsPurgable() return false end
function modifier_custom_void_dissimilate_speed:GetEffectName() return "particles/void_step_speed.vpcf" end
function modifier_custom_void_dissimilate_speed:GetTexture() return "buffs/remnant_speed" end

function modifier_custom_void_dissimilate_speed:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
}
end

function modifier_custom_void_dissimilate_speed:GetModifierMoveSpeedBonus_Percentage()
return self.speed
end


function modifier_custom_void_dissimilate_speed:OnCreated()

self.speed = self:GetCaster():GetTalentValue("modifier_void_astral_3", "speed")
end


