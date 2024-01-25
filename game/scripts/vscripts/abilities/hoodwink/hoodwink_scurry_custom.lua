LinkLuaModifier( "modifier_hoodwink_scurry_custom", "abilities/hoodwink/hoodwink_scurry_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hoodwink_scurry_custom_buff", "abilities/hoodwink/hoodwink_scurry_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hoodwink_scurry_custom_legendary", "abilities/hoodwink/hoodwink_scurry_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hoodwink_scurry_custom_knock", "abilities/hoodwink/hoodwink_scurry_custom", LUA_MODIFIER_MOTION_HORIZONTAL )
LinkLuaModifier( "modifier_hoodwink_scurry_custom_shield", "abilities/hoodwink/hoodwink_scurry_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hoodwink_scurry_custom_damaged", "abilities/hoodwink/hoodwink_scurry_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hoodwink_scurry_custom_cd", "abilities/hoodwink/hoodwink_scurry_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hoodwink_scurry_custom_knock_attack", "abilities/hoodwink/hoodwink_scurry_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hoodwink_scurry_custom_unslow", "abilities/hoodwink/hoodwink_scurry_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hoodwink_scurry_custom_slow", "abilities/hoodwink/hoodwink_scurry_custom", LUA_MODIFIER_MOTION_NONE )

hoodwink_scurry_custom = class({})
hoodwink_scurry_custom_1 = class({})



function hoodwink_scurry_custom:Precache(context)

    
PrecacheResource( "particle", "particles/units/heroes/hero_hoodwink/hoodwink_scurry_passive.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_hoodwink/hoodwink_scurry_aura.vpcf", context )
PrecacheResource( "particle", "particles/hood_proj.vpcf", context )
PrecacheResource( "particle", "particles/hoodwink_head.vpcf", context )
PrecacheResource( "particle", "particles/hood_charge.vpcf", context )
PrecacheResource( "particle", "particles/hoodwink_ground.vpcf", context )

end



function hoodwink_scurry_custom:GetIntrinsicModifierName()
	return "modifier_hoodwink_scurry_custom"
end



function hoodwink_scurry_custom:GetBehavior()
local toggle = 0

if self:GetCaster():HasModifier("modifier_hoodwink_scurry_5") then 
	toggle = DOTA_ABILITY_BEHAVIOR_AUTOCAST
end 

return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + toggle
end



function hoodwink_scurry_custom_1:GetBehavior()

local toggle = 0
if self:GetCaster():HasModifier("modifier_hoodwink_scurry_5") then 
	toggle = DOTA_ABILITY_BEHAVIOR_AUTOCAST
end 
return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + toggle
end


function hoodwink_scurry_custom_1:OnSpellStart()

local ability = self:GetCaster():FindAbilityByName("hoodwink_scurry_custom")
if not ability then return end 
self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_hoodwink_scurry_custom_cd", {duration = 1})
ability:Cast(self:GetCaster():HasModifier("modifier_hoodwink_scurry_5") and self:GetAutoCastState() == true)
end





function hoodwink_scurry_custom:OnSpellStart()

self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_hoodwink_scurry_custom_cd", {duration = 1})
self:Cast(self:GetCaster():HasModifier("modifier_hoodwink_scurry_5") and self:GetAutoCastState() == true)
end





function hoodwink_scurry_custom:Cast(blink)
local duration = self:GetSpecialValueFor( "duration" ) + self:GetCaster():GetTalentValue("modifier_hoodwink_scurry_1", "duration")

if self:GetCaster():HasModifier("modifier_hoodwink_scurry_5") and (blink == true or blink == 1) and not self:GetCaster():IsRooted() and not self:GetCaster():IsLeashed() then 

	local point = self:GetCaster():GetAbsOrigin()
	local range = self:GetCaster():GetTalentValue("modifier_hoodwink_scurry_5", "range")

	FindClearSpaceForUnit(self:GetCaster(), point + self:GetCaster():GetForwardVector()*range, true)

	local effect = ParticleManager:CreateParticle("particles/items3_fx/blink_swift_start.vpcf", PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(effect, 0, point)
	ParticleManager:ReleaseParticleIndex(effect)

	effect = ParticleManager:CreateParticle("particles/items3_fx/blink_swift_end.vpcf", PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(effect, 0, self:GetCaster():GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(effect)

	self:GetCaster():EmitSound("Hoodwink.Scurry_blink")
end

if self:GetCaster():HasModifier("modifier_hoodwink_scurry_4") then 
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_hoodwink_scurry_custom_unslow", {duration = self:GetCaster():GetTalentValue("modifier_hoodwink_scurry_4", "duration")})
end 

self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_hoodwink_scurry_custom_buff", { duration = duration } )

end








modifier_hoodwink_scurry_custom = class({})

function modifier_hoodwink_scurry_custom:IsHidden()
	return self:GetStackCount()~=0
end

function modifier_hoodwink_scurry_custom:DeclareFunctions()
local funcs = 
{
	MODIFIER_PROPERTY_EVASION_CONSTANT,
	MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	MODIFIER_PROPERTY_SLOW_RESISTANCE,
	MODIFIER_EVENT_ON_TAKEDAMAGE,
	MODIFIER_EVENT_ON_ATTACK_LANDED,
	MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	MODIFIER_EVENT_ON_ATTACK,
	MODIFIER_EVENT_ON_ATTACK_FAIL,
}

return funcs
end

function modifier_hoodwink_scurry_custom:GetModifierMoveSpeedBonus_Constant()
if not self:GetCaster():HasModifier("modifier_hoodwink_scurry_1") then return end 
return self:GetCaster():GetTalentValue("modifier_hoodwink_scurry_1", "move")
end


function modifier_hoodwink_scurry_custom:GetModifierAttackSpeedBonus_Constant()
if not self:GetParent():HasModifier("modifier_hoodwink_scurry_3") then return end
return self:GetCaster():GetTalentValue("modifier_hoodwink_scurry_3", "speed")
end



function modifier_hoodwink_scurry_custom:OnAttack(params)
if not IsServer() then return end 
if self.parent ~= params.attacker then return end 
if not params.target:IsHero() and not params.target:IsCreep() then return end

local mod = self.parent:FindModifierByName("modifier_hoodwink_scurry_custom_knock_attack")
if not mod then return end 

self.attack_records[params.record] = true

mod:Destroy()

end 


function modifier_hoodwink_scurry_custom:OnAttackFail(params)
if not IsServer() then return end 

self.attack_records[params.record] = nil

end 




function modifier_hoodwink_scurry_custom:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end
if not params.target:IsHero() and not params.target:IsCreep() then return end

if self.parent:HasModifier("modifier_hoodwink_scurry_3") and self.parent:HasModifier("modifier_hoodwink_scurry_custom_buff") then 
	local damage = self.parent:GetTalentValue("modifier_hoodwink_scurry_3", "damage")
	ApplyDamage({ victim = params.target, attacker = self:GetParent(), damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self:GetAbility(), damage_flags = DOTA_DAMAGE_FLAG_NONE })

	params.target:SendNumber(4, damage)
end


if self.attack_records[params.record] == nil then return end 

self.attack_records[params.record] = nil

params.target:EmitSound("Hoodwink.Scurry_attack")
params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_hoodwink_scurry_custom_slow", {duration = self.slow_duration}) 

--[[params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_hoodwink_scurry_custom_knock", 
{
	duration = self.attack_knock_duration,
	x = self:GetCaster():GetAbsOrigin().x,
	y = self:GetCaster():GetAbsOrigin().y
})]]

end



function modifier_hoodwink_scurry_custom:OnTakeDamage(params)
if not IsServer() then return end 
if not self:GetParent():HasModifier("modifier_hoodwink_scurry_6") then return end 
if self:GetParent() ~= params.unit then return end 
if params.unit:GetTeamNumber() == params.attacker:GetTeamNumber() then return end 

self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_hoodwink_scurry_custom_damaged", {duration = self:GetCaster():GetTalentValue("modifier_hoodwink_scurry_6", "cd")})
end



function modifier_hoodwink_scurry_custom:GetModifierEvasion_Constant()
if self:GetStackCount()==1 then return 0 end
return self.evasion
end

function modifier_hoodwink_scurry_custom:GetModifierIncomingDamage_Percentage()
if self:GetStackCount()==1 then return 0 end
if not self:GetParent():HasModifier("modifier_hoodwink_scurry_2") then return end
return self:GetCaster():GetTalentValue("modifier_hoodwink_scurry_2", "damage_reduce")
end


function modifier_hoodwink_scurry_custom:GetModifierStatusResistanceStacking() 
if self:GetStackCount()==1 then return 0 end
if not self:GetParent():HasModifier("modifier_hoodwink_scurry_2") then return end
return self:GetCaster():GetTalentValue("modifier_hoodwink_scurry_2", "status")
end



function modifier_hoodwink_scurry_custom:OnIntervalThink()
if not IsServer() then return end

if self:GetParent():HasModifier("modifier_hoodwink_scurry_6") and not self:GetParent():HasModifier("modifier_hoodwink_scurry_custom_damaged") then 
	self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_hoodwink_scurry_custom_shield", {})
end


local stack = 1

if not self:GetParent():HasModifier("modifier_hoodwink_scurry_6") then 
	local trees = GridNav:GetAllTreesAroundPoint( self.parent:GetOrigin(), self.radius, false )
	if #trees>0 then
	 	stack = 0 
	end
else 
	stack = 0
end 


if self:GetStackCount()~=stack then
	self:SetStackCount( stack )
	if stack==0 then
		self.effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_hoodwink/hoodwink_scurry_passive.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent )
		ParticleManager:SetParticleControl( self.effect_cast, 2, Vector( self.radius, 0, 0 ) )
	else

		if not self.effect_cast then return end
		ParticleManager:DestroyParticle( self.effect_cast, false )
		ParticleManager:ReleaseParticleIndex( self.effect_cast )
	end
end


local distance = math.min((self.parent:GetAbsOrigin() - self.old_pos):Length2D(), self.stack_distance)
self.old_pos = self.parent:GetAbsOrigin()


if self.parent:HasModifier("modifier_hoodwink_scurry_4") and not self.parent:IsInvisible()  then 
	self.attack_distance = self.attack_distance + distance

	if self.attack_distance >= self.parent:GetTalentValue("modifier_hoodwink_scurry_4", "distance") then 
		self.attack_distance = 0

		local units = FindUnitsInRadius( self.parent:GetTeamNumber(), self.parent:GetAbsOrigin(), nil, self.attack_range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
		if #units <= 0 then 
			units =  FindUnitsInRadius( self.parent:GetTeamNumber(), self.parent:GetAbsOrigin(), nil, self.attack_range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
		end 

		if #units > 0 then 
			self.parent:EmitSound("Hoodwink.Knock_attack")
			self.parent:AddNewModifier(self.parent, self:GetAbility(), "modifier_hoodwink_scurry_custom_knock_attack", {duration = 0.3})
			self.parent:PerformAttack(units[1], true, true, true, false, true, false, false)
		end 

	end 
end 

if self.parent:HasModifier("modifier_hoodwink_scurry_legendary") then 
	if self.init == false then 
 		self.init = true

		CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self.parent:GetPlayerOwnerID()), 'Hoodwink_change',  {max = self.max_distance, current = 0})

		self.particle = ParticleManager:CreateParticle("particles/hood_charge.vpcf", PATTACH_OVERHEAD_FOLLOW, self.parent)
		self:AddParticle(self.particle, false, false, -1, false, false)
 	end
else 
	return
end 


local mod = self.parent:FindModifierByName("modifier_hoodwink_scurry_custom_legendary")

local max = self.max_distance
local current = self.distance
local active = 0

if mod then 
	max = self.legendary_duration
	current = mod:GetRemainingTime()
	active = 1
end

CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self.parent:GetPlayerOwnerID()), 'Hoodwink_change',  {max = max, current = current, active = active})

if mod then return end
if not self.parent:IsAlive() then return end

self.distance = self.distance + distance

local stack = math.floor(self.distance/self.stack_distance)

if self.stack ~= stack then 
	self.stack = stack

	if self.stack >= self.max then 
		ParticleManager:DestroyParticle(self.particle, false)
		ParticleManager:ReleaseParticleIndex(self.particle)
		self.particle = nil
		self.stack = 0
		self.distance = 0
		self:GetParent():AddNewModifier(self.parent, self:GetAbility(), "modifier_hoodwink_scurry_custom_legendary", {duration = self.legendary_duration})
	else 

		if self.particle == nil then 
			self.particle = ParticleManager:CreateParticle("particles/hood_charge.vpcf", PATTACH_OVERHEAD_FOLLOW, self.parent)
			self:AddParticle(self.particle, false, false, -1, false, false)
		end

		local max = self.max
		local s = self.stack

		for i = 1,max do 
			if i <= s then 
				ParticleManager:SetParticleControl(self.particle, i, Vector(1, 0, 0))	
			else 
				ParticleManager:SetParticleControl(self.particle, i, Vector(0, 0, 0))	
			end
		end
	end
end

end




function modifier_hoodwink_scurry_custom:OnCreated( kv )
self.parent = self:GetParent()
self.evasion = self:GetAbility():GetSpecialValueFor( "evasion" )
self.radius = self:GetAbility():GetSpecialValueFor( "radius" )


self.parent = self:GetParent()

if not IsServer() then return end
self.slow_duration = self:GetCaster():GetTalentValue("modifier_hoodwink_scurry_4", "slow_duration", true)

self.legendary_duration = self:GetCaster():GetTalentValue("modifier_hoodwink_scurry_legendary", "duration", true)
self.max = self:GetCaster():GetTalentValue("modifier_hoodwink_scurry_legendary", "max", true)
self.max_distance = self:GetCaster():GetTalentValue("modifier_hoodwink_scurry_legendary", "distance", true)
self.stack_distance = self.max_distance/self.max
self.init = false

self.distance = 0
self.stack = 0
self.old_pos = self:GetParent():GetAbsOrigin()

self.attack_distance = 0
self.attack_range = self:GetCaster():GetTalentValue("modifier_hoodwink_scurry_4", "radius", true)
self.attack_knock_duration = self:GetCaster():GetTalentValue("modifier_hoodwink_scurry_4", "knock_duration", true)
self.attack_records = {}

self:StartIntervalThink( FrameTime() )
self:OnIntervalThink()
end

function modifier_hoodwink_scurry_custom:OnRefresh( kv )
self.evasion = self:GetAbility():GetSpecialValueFor( "evasion" )
self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
end









modifier_hoodwink_scurry_custom_buff = class({})

function modifier_hoodwink_scurry_custom_buff:IsPurgable()
	return true
end

function modifier_hoodwink_scurry_custom_buff:OnCreated( kv )
self.movespeed = self:GetAbility():GetSpecialValueFor( "movement_speed_pct" )

self.attack_range = self:GetAbility():GetSpecialValueFor("attack_range")
self.spell_range = self:GetAbility():GetSpecialValueFor("cast_range")

if not IsServer() then return end

if self.particle then 
	ParticleManager:DestroyParticle(self.particle, false)
	ParticleManager:ReleaseParticleIndex(self.particle)
end 

self:GetCaster():EmitSound("Hero_Hoodwink.Scurry.Cast")
self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_hoodwink/hoodwink_scurry_aura.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
self:AddParticle(self.particle, false, false, -1, true, false)
end

function modifier_hoodwink_scurry_custom_buff:OnRefresh( kv )
self:OnCreated(kv)
end


function modifier_hoodwink_scurry_custom_buff:OnDestroy()
if not IsServer() then return end
self:GetParent():EmitSound("Hero_Hoodwink.Scurry.End")
end


function modifier_hoodwink_scurry_custom_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING,
	}

	return funcs
end


function modifier_hoodwink_scurry_custom_buff:GetModifierCastRangeBonusStacking()
return self.spell_range 
end

function modifier_hoodwink_scurry_custom_buff:GetModifierAttackRangeBonus()
return self.attack_range
end

function modifier_hoodwink_scurry_custom_buff:GetActivityTranslationModifiers()
return "scurry"
end

function modifier_hoodwink_scurry_custom_buff:GetModifierMoveSpeedBonus_Percentage()
return self.movespeed
end

function modifier_hoodwink_scurry_custom_buff:CheckState()
	local state = {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_ALLOW_PATHING_THROUGH_TREES] = true,
	}

	return state
end











modifier_hoodwink_scurry_custom_legendary = class({})
function modifier_hoodwink_scurry_custom_legendary:IsHidden() return false end
function modifier_hoodwink_scurry_custom_legendary:IsPurgable() return false end
function modifier_hoodwink_scurry_custom_legendary:GetTexture() return "buffs/scurry_ground" end

function modifier_hoodwink_scurry_custom_legendary:OnCreated(table)

self.bva = self:GetCaster():GetTalentValue("modifier_hoodwink_scurry_legendary", "bva")
self.heal = self:GetCaster():GetTalentValue("modifier_hoodwink_scurry_legendary", "lifesteal")
self.creeps = self:GetCaster():GetTalentValue("modifier_hoodwink_scurry_legendary", "creeps")

if not IsServer() then return end
self.moved = false
self.location = self:GetParent():GetAbsOrigin()

self:GetParent():EmitSound("Hoodwink.Scurry_legendary")
self.ground_particle = ParticleManager:CreateParticle("particles/hoodwink_head.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent())
ParticleManager:SetParticleControlEnt(self.ground_particle, 0, self:GetParent(), PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(self.ground_particle, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(self.ground_particle, 5, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
self:AddParticle(self.ground_particle, false, false, -1, true, false)

end

function modifier_hoodwink_scurry_custom_legendary:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
	MODIFIER_PROPERTY_BONUS_NIGHT_VISION,
	MODIFIER_EVENT_ON_TAKEDAMAGE,
	MODIFIER_PROPERTY_PROJECTILE_NAME,
	MODIFIER_PROPERTY_TOOLTIP
}
end



function modifier_hoodwink_scurry_custom_legendary:GetModifierProjectileName()
return "particles/hoodwink/scurry_proj.vpcf"
end




function modifier_hoodwink_scurry_custom_legendary:OnTakeDamage(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end
if not params.unit:IsCreep() and not params.unit:IsHero() then return end
if self:GetParent() == params.unit then return end
if bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then return end
if params.unit:IsIllusion() then return end

local heal = self.heal/100
if params.unit:IsCreep() then 
  heal = heal / self.creeps
end

heal = heal*params.damage

self:GetParent():GenericHeal(heal, self:GetAbility(), true)

end


function modifier_hoodwink_scurry_custom_legendary:GetModifierBaseAttackTimeConstant()
return self.bva
end

function modifier_hoodwink_scurry_custom_legendary:OnTooltip()
return self.heal
end





















modifier_hoodwink_scurry_custom_knock = class({})

function modifier_hoodwink_scurry_custom_knock:IsHidden() return true end

function modifier_hoodwink_scurry_custom_knock:OnCreated(params)
  if not IsServer() then return end
  
  self.ability        = self:GetAbility()
  self.caster         = self:GetCaster()
  self.parent         = self:GetParent()
  self:GetParent():StartGesture(ACT_DOTA_FLAIL)
  
  self.knockback_duration   = self:GetCaster():GetTalentValue("modifier_hoodwink_scurry_4", "knock_duration")

  self.knockback_distance   = math.max(self:GetCaster():GetTalentValue("modifier_hoodwink_scurry_4", "knock") - (self.caster:GetAbsOrigin() - self.parent:GetAbsOrigin()):Length2D(), 50)
  
  self.knockback_speed    = self.knockback_distance / self.knockback_duration
  
  self.position = GetGroundPosition(Vector(params.x, params.y, 0), nil)
  
  if self:ApplyHorizontalMotionController() == false then 
    self:Destroy()
    return
  end
end

function modifier_hoodwink_scurry_custom_knock:UpdateHorizontalMotion( me, dt )
  if not IsServer() then return end

  local distance = (me:GetOrigin() - self.position):Normalized()
  
  me:SetOrigin( me:GetOrigin() + distance * self.knockback_speed * dt )

  --GridNav:DestroyTreesAroundPoint( self.parent:GetOrigin(), self.parent:GetHullRadius(), true )
end

function modifier_hoodwink_scurry_custom_knock:DeclareFunctions()
  local decFuncs = {
    MODIFIER_PROPERTY_OVERRIDE_ANIMATION
    }

    return decFuncs
end

function modifier_hoodwink_scurry_custom_knock:GetOverrideAnimation()
   return ACT_DOTA_FLAIL
end


function modifier_hoodwink_scurry_custom_knock:OnDestroy()
  if not IsServer() then return end
  self.parent:RemoveHorizontalMotionController( self )
  self:GetParent():FadeGesture(ACT_DOTA_FLAIL)
end






modifier_hoodwink_scurry_custom_knock_attack = class({})
function modifier_hoodwink_scurry_custom_knock_attack:IsHidden() return true end
function modifier_hoodwink_scurry_custom_knock_attack:IsPurgable() return false end
function modifier_hoodwink_scurry_custom_knock_attack:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_PROJECTILE_NAME 
}
end

function modifier_hoodwink_scurry_custom_knock_attack:GetModifierProjectileName()
return "particles/hoodwink/scurry_proj.vpcf"
end


modifier_hoodwink_scurry_custom_unslow = class({})
function modifier_hoodwink_scurry_custom_unslow:IsHidden() return true end
function modifier_hoodwink_scurry_custom_unslow:IsPurgable() return false end
function modifier_hoodwink_scurry_custom_unslow:CheckState()
return
{
	[MODIFIER_STATE_UNSLOWABLE] = true
}
end



modifier_hoodwink_scurry_custom_shield = class({})
function modifier_hoodwink_scurry_custom_shield:IsHidden() 
    return true
end
function modifier_hoodwink_scurry_custom_shield:GetTexture() return "buffs/reincarnation_shield" end
function modifier_hoodwink_scurry_custom_shield:IsPurgable() return false end
function modifier_hoodwink_scurry_custom_shield:OnCreated(table)

self.shield_max = self:GetCaster():GetTalentValue("modifier_hoodwink_scurry_6", "shield")/100

self.max_shield = self:GetParent():GetMaxHealth()*self.shield_max

self.damage_reduce = self:GetCaster():GetTalentValue("modifier_hoodwink_scurry_2", "damage_reduce")/100

if not IsServer() then return end

self.RemoveForDuel = true

self.ground_particle = ParticleManager:CreateParticle("particles/hoodwink_ground.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent())
ParticleManager:SetParticleControlEnt(self.ground_particle, 0, self:GetParent(), PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(self.ground_particle, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(self.ground_particle, 5, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
self:AddParticle(self.ground_particle, false, false, -1, true, false)

self.sound = true

self.interval = 0.1

self.duration = self:GetCaster():GetTalentValue("modifier_hoodwink_scurry_6", "duration")


self:OnIntervalThink()
self:StartIntervalThink(self.interval)
end




function modifier_hoodwink_scurry_custom_shield:OnIntervalThink()
if not IsServer() then return end 
if self:GetParent():HasModifier("modifier_hoodwink_scurry_custom_damaged") then 
	self.sound = true
	return 
end 

if self.sound == true then 
	self.sound = false
	self:GetParent():EmitSound("Hoodwink.Scurry_shield")
end

local shield_interval = (self.max_shield/self.duration)*self.interval
local add = math.min(self.max_shield, self:GetStackCount() + shield_interval)
self:SetStackCount( add)

end 



function modifier_hoodwink_scurry_custom_shield:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_INCOMING_DAMAGE_CONSTANT,
}

end




function modifier_hoodwink_scurry_custom_shield:GetModifierIncomingDamageConstant( params )

if IsClient() then 

	if params.report_max then 
		return self.max_shield
	else 
    return self:GetStackCount()
  end 
end

if not IsServer() then return end

local damage = params.damage
if self:GetCaster():HasModifier("modifier_hoodwink_scurry_2") then 
	damage = damage * (1 + self.damage_reduce)
end 

if self:GetStackCount() > damage then
    self:SetStackCount(self:GetStackCount() - damage)
    local i = params.damage
    return -i
else
    
    local i = self:GetStackCount()
    self:SetStackCount(0)
    self:Destroy()
    return -i
end

end








modifier_hoodwink_scurry_custom_damaged = class({})
function modifier_hoodwink_scurry_custom_damaged:IsHidden() return true end
function modifier_hoodwink_scurry_custom_damaged:IsPurgable() return false end


modifier_hoodwink_scurry_custom_cd = class({})

function modifier_hoodwink_scurry_custom_cd:IsHidden() return true end
function modifier_hoodwink_scurry_custom_cd:IsPurgable() return false end
function modifier_hoodwink_scurry_custom_cd:OnCreated()
if not IsServer() then return end 

self:GetAbility():SetActivated(false)
end

function modifier_hoodwink_scurry_custom_cd:OnDestroy()
if not IsServer() then return end 

self:GetAbility():SetActivated(true)
end




modifier_hoodwink_scurry_custom_slow = class({})

function modifier_hoodwink_scurry_custom_slow:IsHidden()
	return true
end

function modifier_hoodwink_scurry_custom_slow:IsPurgable()
	return true
end

function modifier_hoodwink_scurry_custom_slow:OnCreated( kv )
self.slow = self:GetCaster():GetTalentValue("modifier_hoodwink_scurry_4", "slow")
if not IsServer() then return end 


self.particle_peffect = ParticleManager:CreateParticle("particles/units/heroes/hero_sniper/sniper_headshot_slow.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())	
self:AddParticle(self.particle_peffect, false, false, -1, false, true)

end



function modifier_hoodwink_scurry_custom_slow:DeclareFunctions()
local funcs = {
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
}

return funcs
end

function modifier_hoodwink_scurry_custom_slow:GetModifierMoveSpeedBonus_Percentage()
	return self.slow
end

function modifier_hoodwink_scurry_custom_slow:GetEffectName()
	return "particles/units/heroes/hero_hoodwink/hoodwink_acorn_shot_slow.vpcf"
end

function modifier_hoodwink_scurry_custom_slow:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

