LinkLuaModifier( "modifier_primal_beast_trample_custom", "abilities/primal_beast/primal_beast_trample_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_primal_beast_trample_tracker", "abilities/primal_beast/primal_beast_trample_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_primal_beast_trample_speed", "abilities/primal_beast/primal_beast_trample_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_primal_beast_trample_stack", "abilities/primal_beast/primal_beast_trample_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_primal_beast_trample_charge", "abilities/primal_beast/primal_beast_trample_custom", LUA_MODIFIER_MOTION_HORIZONTAL )
LinkLuaModifier( "modifier_primal_beast_trample_silence", "abilities/primal_beast/primal_beast_trample_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_primal_beast_trample_silence_stack", "abilities/primal_beast/primal_beast_trample_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_primal_beast_trample_quest", "abilities/primal_beast/primal_beast_trample_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_primal_beast_trample_scepter_attack", "abilities/primal_beast/primal_beast_trample_custom", LUA_MODIFIER_MOTION_NONE )

primal_beast_trample_custom = class({})

primal_beast_trample_custom.damage = {0.1, 0.15, 0.2}

primal_beast_trample_custom.heal = {0.2, 0.3, 0.4}
primal_beast_trample_custom.heal_creeps = 0.33


primal_beast_trample_custom.start_resist = 50
primal_beast_trample_custom.start_damage = -30
primal_beast_trample_custom.start_max = 10

primal_beast_trample_custom.stack_duration = 5
primal_beast_trample_custom.stack_slow = {-5, -8}
primal_beast_trample_custom.stack_damage = {3, 5}
primal_beast_trample_custom.stack_max = 8

primal_beast_trample_custom.silence_max = 6
primal_beast_trample_custom.silence_cd = -3
primal_beast_trample_custom.silence_duration = 2
primal_beast_trample_custom.silence_stack_duration = 4


function primal_beast_trample_custom:Precache(context)

PrecacheResource( "particle", 'particles/units/heroes/hero_primal_beast/primal_beast_disarm.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_primal_beast/primal_beast_trample.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_primal_beast/primal_beast_onslaught_charge_active.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_primal_beast/primal_beast_onslaught_impact.vpcf', context )
PrecacheResource( "particle", 'particles/beast_silence.vpcf', context )

end



function primal_beast_trample_custom:GetCooldown(iLevel)

local upgrade_cooldown = 0

if self:GetCaster():HasModifier("modifier_primal_beast_trample_6") then 
  upgrade_cooldown = self.silence_cd
end

 return self.BaseClass.GetCooldown(self, iLevel) + upgrade_cooldown

end


function primal_beast_trample_custom:OnSpellStart()
if not IsServer() then return end
local duration = self:GetSpecialValueFor( "duration" )

if self:GetCaster():HasModifier("modifier_primal_beast_trample_7") then 
	local ability = self:GetCaster():FindAbilityByName("primal_beast_charge_custom")
	if ability then 
		ability:StartCooldown(0.2)
	end

	self:GetCaster():SwapAbilities( "primal_beast_trample_custom", "primal_beast_charge_custom", false, true )
end


if self:GetCaster():HasModifier("modifier_primal_beast_trample_3") then 
	duration = duration + self:GetCaster():GetTalentValue("modifier_primal_beast_trample_3", "duration")
end

if self:GetCaster():HasModifier("modifier_primal_beast_trample_5") then 

	self:GetCaster():Purge(false, true, false, false, false)
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_primal_beast_trample_speed", {duration = duration})
end

self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_primal_beast_trample_custom", { duration = duration } )
end




function primal_beast_trample_custom:GetIntrinsicModifierName()
	return "modifier_primal_beast_trample_tracker"
end






modifier_primal_beast_trample_custom = class({})

function modifier_primal_beast_trample_custom:IsPurgable()
	return false
end

function modifier_primal_beast_trample_custom:OnCreated( kv )
	self.radius = self:GetAbility():GetSpecialValueFor( "effect_radius" )
	self.step_distance = self:GetAbility():GetSpecialValueFor( "step_distance" )
	self.base_damage = self:GetAbility():GetSpecialValueFor( "base_damage" )
	self.attack_damage = self:GetAbility():GetSpecialValueFor( "attack_damage" ) / 100

	if self:GetCaster():HasModifier("modifier_primal_beast_trample_1") then 
		self.attack_damage = self.attack_damage + self:GetAbility().damage[self:GetCaster():GetUpgradeStack("modifier_primal_beast_trample_1")]
	end

	if not IsServer() then return end

	self.RemoveForDuel = true


	self.ult_count = 0
	self.distance = 0
	self.treshold = 500
	self.currentpos = self:GetParent():GetOrigin()
	self:StartIntervalThink( 0.1 )
	self:Trample()
end

function modifier_primal_beast_trample_custom:OnRefresh( kv )
	self.radius = self:GetAbility():GetSpecialValueFor( "effect_radius" )
	self.distance = self:GetAbility():GetSpecialValueFor( "step_distance" )
	self.base_damage = self:GetAbility():GetSpecialValueFor( "base_damage" )
	self.attack_damage = self:GetAbility():GetSpecialValueFor( "attack_damage" ) / 100
end

function modifier_primal_beast_trample_custom:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
	}

	return funcs
end

function modifier_primal_beast_trample_custom:GetActivityTranslationModifiers()
	return "heavy_steps"
end

function modifier_primal_beast_trample_custom:CheckState()
if not self:GetCaster():HasScepter() then 

	local state = {
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_ALLOW_PATHING_THROUGH_TREES] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}

	return state
else 

	local state = {
		[MODIFIER_STATE_ALLOW_PATHING_THROUGH_TREES] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}

	return state

end

end

function modifier_primal_beast_trample_custom:OnIntervalThink()
	local pos = self:GetParent():GetOrigin()
	local dist = (pos-self.currentpos):Length2D()
	self.currentpos = pos
	GridNav:DestroyTreesAroundPoint( pos, self.radius, false )
	if dist>self.treshold then return end
	self.distance = self.distance + dist
	if self.distance > self.step_distance then
		self:Trample()
		self.distance = 0
	end
end

function modifier_primal_beast_trample_custom:Trample()
if not IsServer() then return end



	local pos = self:GetParent():GetOrigin()
	local enemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), pos, nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
	local damage = self.base_damage + self:GetParent():GetAverageTrueAttackDamage(self:GetParent()) * self.attack_damage
	local damageTable = { attacker = self:GetParent(), damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self:GetAbility() }

	local ult = self:GetCaster():FindAbilityByName("primal_beast_pulverize_custom")
	if ult and #enemies > 0 and self:GetCaster():HasModifier("modifier_primal_beast_pulverize_7") then 
		self.ult_count = self.ult_count + 1
		if self.ult_count >= self:GetCaster():GetTalentValue("modifier_primal_beast_pulverize_7", "trample") then 
			self.ult_count = 0
			ult:AddLegendaryStack()
		end
	end 



	for _,enemy in pairs(enemies) do
		damageTable.victim = enemy

		local current_damage = damage


	
		damageTable.damage = current_damage

		ApplyDamage(damageTable)

		SendOverheadEventMessage( nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, enemy, current_damage, nil )

		if self:GetCaster():HasModifier("modifier_primal_beast_trample_4") then 
			enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_primal_beast_trample_stack", {duration = self:GetAbility().stack_duration})
		end

		if self:GetCaster():GetQuest() == "Beast.Quest_6" and enemy:IsRealHero() and not self:GetCaster():QuestCompleted() then 
			enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_primal_beast_trample_quest", {duration = 1})
		end

		if self:GetCaster():HasModifier("modifier_primal_beast_trample_6") and not enemy:HasModifier("modifier_primal_beast_trample_silence") then 
			enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_primal_beast_trample_silence_stack", {duration = self:GetAbility().silence_stack_duration})
		end
	end

	self:PlayEffects()
end

function modifier_primal_beast_trample_custom:GetEffectName()
if self:GetParent():HasScepter() then return end
	return "particles/units/heroes/hero_primal_beast/primal_beast_disarm.vpcf"
end

function modifier_primal_beast_trample_custom:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_primal_beast_trample_custom:PlayEffects()
	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_primal_beast/primal_beast_trample.vpcf", PATTACH_ABSORIGIN, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	self:GetParent():EmitSound("Hero_PrimalBeast.Trample")
end

function modifier_primal_beast_trample_custom:OnDestroy()
if not IsServer() then return end

if self:GetCaster():HasModifier("modifier_primal_beast_trample_7") and self:GetAbility():IsHidden() then 
	
	self:GetCaster():SwapAbilities( "primal_beast_trample_custom", "primal_beast_charge_custom", true, false )
end

end













modifier_primal_beast_trample_tracker = class({})
function modifier_primal_beast_trample_tracker:IsHidden() return true end
function modifier_primal_beast_trample_tracker:IsPurgable() return false end
function modifier_primal_beast_trample_tracker:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_TAKEDAMAGE,
    MODIFIER_EVENT_ON_ABILITY_EXECUTED,
}
end







function modifier_primal_beast_trample_tracker:OnAbilityExecuted( params )
if not IsServer() then return end
if not self:GetParent():HasScepter() then return end
if params.unit~=self:GetParent() then return end
if not params.ability then return end
if params.ability:IsItem() or params.ability:IsToggle() then return end
if UnvalidAbilities[params.ability:GetName()] then return end
if params.ability:GetName() == "primal_beast_charge_custom" then return end

self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_primal_beast_trample_scepter_attack", {})

end








function modifier_primal_beast_trample_tracker:OnTakeDamage(params)
if not IsServer() then return end
if self:GetCaster() ~= params.attacker then return end
if self:GetAbility() ~= params.inflictor then return end
if not self:GetParent():HasModifier("modifier_primal_beast_trample_2") then return end

local heal = params.damage*self:GetAbility().heal[self:GetCaster():GetUpgradeStack("modifier_primal_beast_trample_2")]
if params.unit:IsCreep() then 
	heal = heal*self:GetAbility().heal_creeps
end

self:GetCaster():Heal(heal, self:GetAbility())

SendOverheadEventMessage(self:GetCaster(), 10, self:GetCaster(), heal, nil)

local particle = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
ParticleManager:ReleaseParticleIndex( particle )

end






modifier_primal_beast_trample_scepter_attack = class({})
function modifier_primal_beast_trample_scepter_attack:IsHidden() return true end
function modifier_primal_beast_trample_scepter_attack:IsPurgable() return false end
function modifier_primal_beast_trample_scepter_attack:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_ATTACK_LANDED
}
end

function modifier_primal_beast_trample_scepter_attack:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end

local target = params.target
local radius = self:GetAbility():GetSpecialValueFor("scepter_radius")
local damage = self:GetParent():GetAverageTrueAttackDamage(nil)*self:GetAbility():GetSpecialValueFor("scepter_damage")/100
local stun = self:GetAbility():GetSpecialValueFor("scepter_stun")

local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_primal_beast/primal_beast_pulverize_hit.vpcf", PATTACH_WORLDORIGIN, nil )
ParticleManager:SetParticleControl( effect_cast, 0, target:GetAbsOrigin() )
ParticleManager:SetParticleControl( effect_cast, 1, Vector(radius, radius, radius) )
ParticleManager:DestroyParticle( effect_cast, false )
ParticleManager:ReleaseParticleIndex( effect_cast )
EmitSoundOnLocationWithCaster( target:GetOrigin(), "Hero_PrimalBeast.Pulverize.Impact", self:GetCaster() )

local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
local damageTable = { attacker = self:GetCaster(), damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self:GetAbility(), damage_flags = DOTA_DAMAGE_FLAG_NONE, }

for _,enemy in pairs(enemies) do 
	damageTable.victim = enemy
	ApplyDamage(damageTable)
	SendOverheadEventMessage( nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, enemy, damage, nil )

	enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_bashed", {duration = (1 - enemy:GetStatusResistance())*stun})
end


self:Destroy()
end







modifier_primal_beast_trample_speed = class({})
function modifier_primal_beast_trample_speed:IsHidden() return false end
function modifier_primal_beast_trample_speed:IsPurgable() return false end
function modifier_primal_beast_trample_speed:GetTexture() return "buffs/bloodlust_resist" end
function modifier_primal_beast_trample_speed:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
}
end

function modifier_primal_beast_trample_speed:GetModifierIncomingDamage_Percentage()

	return self:GetAbility().start_damage*(self:GetStackCount()/self.max)
end


function modifier_primal_beast_trample_speed:GetModifierStatusResistanceStacking() 

	return self:GetAbility().start_resist*(self:GetStackCount()/self.max)
end


function modifier_primal_beast_trample_speed:OnCreated(table)
self.max = self:GetAbility().start_max

if not IsServer() then return end

self:SetStackCount(self.max)


self.particle = ParticleManager:CreateParticle("particles/items4_fx/ascetic_cap.vpcf" , PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControl(self.particle, 0, self:GetParent():GetAbsOrigin())
self:AddParticle(self.particle, false, false, -1, false, false)

self:StartIntervalThink(self:GetRemainingTime()/self.max)
end


function modifier_primal_beast_trample_speed:OnIntervalThink()
if not IsServer() then return end
self:DecrementStackCount()
end

modifier_primal_beast_trample_stack = class({})
function modifier_primal_beast_trample_stack:IsHidden() return false end
function modifier_primal_beast_trample_stack:IsPurgable() return false end
function modifier_primal_beast_trample_stack:GetTexture() return "buffs/trample_stack" end

function modifier_primal_beast_trample_stack:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
end


function modifier_primal_beast_trample_stack:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self:GetAbility().stack_max then return end
self:IncrementStackCount()
end


function modifier_primal_beast_trample_stack:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
}
end


function modifier_primal_beast_trample_stack:GetModifierMoveSpeedBonus_Percentage()
return self:GetStackCount()*self:GetAbility().stack_slow[self:GetCaster():GetUpgradeStack("modifier_primal_beast_trample_4")]
end


function modifier_primal_beast_trample_stack:GetModifierIncomingDamage_Percentage()
return self:GetStackCount()*self:GetAbility().stack_damage[self:GetCaster():GetUpgradeStack("modifier_primal_beast_trample_4")]
end










modifier_primal_beast_trample_charge = class({})

function modifier_primal_beast_trample_charge:IsPurgable()
	return false
end


function modifier_primal_beast_trample_charge:IsHidden()
	return true
end

function modifier_primal_beast_trample_charge:CheckState()
	local state = {
		[MODIFIER_STATE_DISARMED] = true,
	}

	return state
end


function modifier_primal_beast_trample_charge:OnCreated( kv )
	self.speed = self:GetAbility():GetSpecialValueFor("speed")
	self.turn_speed = 70


	if not IsServer() then return end


	self.target_angle = self:GetParent():GetAnglesAsVector().y
	self.current_angle = self.target_angle
	self.face_target = true

	if not self:ApplyHorizontalMotionController() then
		self:Destroy()
		return
	end

end

function modifier_primal_beast_trample_charge:OnDestroy()
	if not IsServer() then return end
	self:GetParent():RemoveHorizontalMotionController(self)
	FindClearSpaceForUnit( self:GetParent(), self:GetParent():GetOrigin(), false )
end


function modifier_primal_beast_trample_charge:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ORDER,
		MODIFIER_PROPERTY_DISABLE_TURNING,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,

	}

	return funcs
end

function modifier_primal_beast_trample_charge:OnOrder( params )
	if params.unit~=self:GetParent() then return end

	if params.order_type==DOTA_UNIT_ORDER_MOVE_TO_POSITION then
		self:SetDirection( params.new_pos )
	elseif
		params.order_type==DOTA_UNIT_ORDER_MOVE_TO_DIRECTION
	then
		self:SetDirection( params.new_pos )
	elseif 
		params.order_type==DOTA_UNIT_ORDER_MOVE_TO_TARGET or
		params.order_type==DOTA_UNIT_ORDER_ATTACK_TARGET
	then
		self:SetDirection( params.target:GetOrigin() )
	elseif
		params.order_type==DOTA_UNIT_ORDER_STOP or 
		params.order_type==DOTA_UNIT_ORDER_HOLD_POSITION
	then
		self:Destroy()
	end	
end

function modifier_primal_beast_trample_charge:GetModifierDisableTurning()
	return 1
end

function modifier_primal_beast_trample_charge:SetDirection( location )
	local dir = ((location-self:GetParent():GetOrigin())*Vector(1,1,0)):Normalized()
	self.target_angle = VectorToAngles( dir ).y
	self.face_target = false
end

function modifier_primal_beast_trample_charge:GetOverrideAnimation()
	return ACT_DOTA_RUN
end

function modifier_primal_beast_trample_charge:GetActivityTranslationModifiers()
	return "onslaught_movement"
end


function modifier_primal_beast_trample_charge:TurnLogic( dt )
	if self.face_target then return end
	local angle_diff = AngleDiff( self.current_angle, self.target_angle )
	local turn_speed = self.turn_speed*dt

	local sign = -1
	if angle_diff<0 then sign = 1 end

	if math.abs( angle_diff )<1.1*turn_speed then
		self.current_angle = self.target_angle
		self.face_target = true
	else
		self.current_angle = self.current_angle + sign*turn_speed
	end

	local angles = self:GetParent():GetAnglesAsVector()
	self:GetParent():SetLocalAngles( angles.x, self.current_angle, angles.z )
end



function modifier_primal_beast_trample_charge:UpdateHorizontalMotion( me, dt )
	if self:GetParent():IsRooted() then
	--	self:Destroy()
		--return
	end

	self:TurnLogic( dt )
	local nextpos = me:GetOrigin() + me:GetForwardVector() * self.speed * dt
	me:SetOrigin(nextpos)

end

function modifier_primal_beast_trample_charge:OnHorizontalMotionInterrupted()
	self:Destroy()
end

function modifier_primal_beast_trample_charge:GetEffectName()
	return "particles/units/heroes/hero_primal_beast/primal_beast_onslaught_charge_active.vpcf"
end

function modifier_primal_beast_trample_charge:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_primal_beast_trample_charge:PlayEffects( target, radius )
	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_primal_beast/primal_beast_onslaught_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	target:EmitSound("Hero_PrimalBeast.Onslaught.Hit")
end




primal_beast_charge_custom = class({})

function primal_beast_charge_custom:GetCooldown()
return self:GetCaster():GetTalentValue("modifier_primal_beast_trample_7", "cd")
end

function primal_beast_charge_custom:OnSpellStart()
if not IsServer() then return end

local duration = self:GetCaster():GetTalentValue("modifier_primal_beast_trample_7", "distance")/self:GetSpecialValueFor("speed")

--self:GetCaster():SetHealth(math.max(1, self:GetCaster():GetHealth() - self:GetCaster():GetMaxHealth()*self:GetSpecialValueFor("health_cost")/100))
self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_primal_beast_trample_charge", {duration = duration})
end


modifier_primal_beast_trample_silence_stack = class({})
function modifier_primal_beast_trample_silence_stack:IsHidden() return false end
function modifier_primal_beast_trample_silence_stack:IsPurgable() return false end
function modifier_primal_beast_trample_silence_stack:GetTexture() return "buffs/trample_silence" end
function modifier_primal_beast_trample_silence_stack:OnCreated(table)
if not IsServer() then return end
self.RemoveForDuel = true
self:SetStackCount(1)
end

function modifier_primal_beast_trample_silence_stack:OnRefresh(table)
if not IsServer() then return end 
self:IncrementStackCount()
if self:GetStackCount() == self:GetAbility().silence_max then

	self:GetParent():EmitSound("PBeast.Trample_silence")
	self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_primal_beast_trample_silence", {duration = (1 - self:GetParent():GetStatusResistance())*self:GetAbility().silence_duration})
	self:Destroy()
end

end


function modifier_primal_beast_trample_silence_stack:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOOLTIP
}
end

function modifier_primal_beast_trample_silence_stack:OnTooltip()
return self:GetAbility().silence_max
end


function modifier_primal_beast_trample_silence_stack:OnStackCountChanged(iStackCount)
if self:GetStackCount() == 0 then return end
if not self.effect_cast then 

	local particle_cast = "particles/beast_silence.vpcf"

	self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, self:GetStackCount(), 0 ) )

	self:AddParticle(self.effect_cast,false, false, -1, false, false)
else 

  ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, self:GetStackCount(), 0 ) )

end

end






modifier_primal_beast_trample_silence = class({})

function modifier_primal_beast_trample_silence:IsHidden() return false end

function modifier_primal_beast_trample_silence:IsPurgable() return true end
function modifier_primal_beast_trample_silence:GetTexture() return "buffs/trample_silence" end

function modifier_primal_beast_trample_silence:CheckState() return {[MODIFIER_STATE_SILENCED] = true} end


function modifier_primal_beast_trample_silence:GetEffectName() return "particles/generic_gameplay/generic_silenced.vpcf" end
 
function modifier_primal_beast_trample_silence:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end



modifier_primal_beast_trample_quest = class({})
function modifier_primal_beast_trample_quest:IsHidden() return true end
function modifier_primal_beast_trample_quest:IsPurgable() return false end
function modifier_primal_beast_trample_quest:OnCreated(table)
if not IsServer() then return end

self:SetStackCount(1)
end

function modifier_primal_beast_trample_quest:OnRefresh(table)
if not IsServer() then return end
if not self:GetCaster():GetQuest() or self:GetCaster():QuestCompleted() then return end

self:IncrementStackCount()

if self:GetStackCount() >= self:GetCaster().quest.number then
	self:GetCaster():UpdateQuest(1)
	self:Destroy()
end


end