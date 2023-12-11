LinkLuaModifier( "modifier_hoodwink_scurry_custom", "abilities/hoodwink/hoodwink_scurry_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hoodwink_scurry_custom_buff", "abilities/hoodwink/hoodwink_scurry_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hoodwink_scurry_custom_legendary", "abilities/hoodwink/hoodwink_scurry_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hoodwink_scurry_custom_legendary_timer", "abilities/hoodwink/hoodwink_scurry_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hoodwink_scurry_custom_knock", "abilities/hoodwink/hoodwink_scurry_custom", LUA_MODIFIER_MOTION_HORIZONTAL )
LinkLuaModifier( "modifier_hoodwink_scurry_custom_shield", "abilities/hoodwink/hoodwink_scurry_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hoodwink_scurry_custom_damaged", "abilities/hoodwink/hoodwink_scurry_custom", LUA_MODIFIER_MOTION_NONE )

hoodwink_scurry_custom = class({})
hoodwink_scurry_custom_1 = class({})
hoodwink_scurry_custom_2 = class({})
hoodwink_scurry_custom_3 = class({})










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

function hoodwink_scurry_custom:CastFilterResult()
	if self:GetCaster():HasModifier( "modifier_hoodwink_scurry_custom_buff" ) then
		return UF_FAIL_CUSTOM
	end

	return UF_SUCCESS
end

function hoodwink_scurry_custom:GetCustomCastError()
	if self:GetCaster():HasModifier( "modifier_hoodwink_scurry_custom_buff" ) then
		return "#dota_hud_error_hoodwink_already_scurrying"
	end

	return ""
end



function hoodwink_scurry_custom:GetBehavior()
local hidden = 0 
local toggle = 0

if self:GetCaster():GetUpgradeStack("modifier_hoodwink_scurry_1") ~= 0 then 
	hidden = DOTA_ABILITY_BEHAVIOR_HIDDEN
end 

if self:GetCaster():HasModifier("modifier_hoodwink_scurry_5") then 
	toggle = DOTA_ABILITY_BEHAVIOR_AUTOCAST
end 

return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + hidden + toggle
end




function hoodwink_scurry_custom:OnSpellStart()

self:Cast(self:GetCaster():HasModifier("modifier_hoodwink_scurry_5") and self:GetAutoCastState() == true)
end





function hoodwink_scurry_custom:Cast(blink)
local duration = self:GetSpecialValueFor( "duration" )

if self:GetCaster():HasModifier("modifier_hoodwink_scurry_5") then 
	duration = duration + self:GetCaster():GetTalentValue("modifier_hoodwink_scurry_5", "duration")

	if (blink == true or blink == 1) and not self:GetCaster():IsRooted() and not self:GetCaster():IsLeashed() then 

		local point = self:GetCaster():GetAbsOrigin()

		FindClearSpaceForUnit(self:GetCaster(), point + self:GetCaster():GetForwardVector()*self:GetCaster():GetTalentValue("modifier_hoodwink_scurry_5", "range"), true)
		
		local effect = ParticleManager:CreateParticle("particles/items3_fx/blink_swift_start.vpcf", PATTACH_WORLDORIGIN, nil)
		ParticleManager:SetParticleControl(effect, 0, point)
		ParticleManager:ReleaseParticleIndex(effect)



		effect = ParticleManager:CreateParticle("particles/items3_fx/blink_swift_end.vpcf", PATTACH_WORLDORIGIN, nil)
		ParticleManager:SetParticleControl(effect, 0, self:GetCaster():GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(effect)

		self:GetCaster():EmitSound("Hoodwink.Scurry_blink")
	end

end




self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_hoodwink_scurry_custom_buff", { duration = duration } )

end








modifier_hoodwink_scurry_custom = class({})

function modifier_hoodwink_scurry_custom:IsHidden()
	return self:GetStackCount()~=0
end

function modifier_hoodwink_scurry_custom:OnCreated( kv )
	self.parent = self:GetParent()
	self.evasion = self:GetAbility():GetSpecialValueFor( "evasion" )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.near_trees = false
	if not IsServer() then return end
	self:StartIntervalThink( FrameTime() )
	self:OnIntervalThink()
end

function modifier_hoodwink_scurry_custom:OnRefresh( kv )
	self.evasion = self:GetAbility():GetSpecialValueFor( "evasion" )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
end

function modifier_hoodwink_scurry_custom:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_EVASION_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_SLOW_RESISTANCE,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}

	return funcs
end

function modifier_hoodwink_scurry_custom:GetModifierMoveSpeedBonus_Constant()
if not self:GetCaster():HasModifier("modifier_hoodwink_scurry_1") then return end 

return self:GetCaster():GetTalentValue("modifier_hoodwink_scurry_1", "move")
end

function modifier_hoodwink_scurry_custom:GetModifierSlowResistance()
if not self:GetCaster():HasModifier("modifier_hoodwink_scurry_6") then return end 

print(self:GetCaster():GetTalentValue("modifier_hoodwink_scurry_6", "slow_resist"))

return self:GetCaster():GetTalentValue("modifier_hoodwink_scurry_6", "slow_resist")
end



function modifier_hoodwink_scurry_custom:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end
if not params.target:IsHero() and not params.target:IsCreep() then return end
if not self:GetParent():HasModifier("modifier_hoodwink_scurry_4") then return end
if self:GetParent():HasModifier("modifier_hoodwink_acorn_shot_custom") then return end
if params.target:GetUnitName() == "npc_teleport" then return end

local chance = self:GetCaster():GetTalentValue("modifier_hoodwink_scurry_4", "chance")

local random = RollPseudoRandomPercentage(chance,62,self:GetParent())
if random then

	local damage = self:GetCaster():GetTalentValue("modifier_hoodwink_scurry_4", "damage")*params.target:GetMaxHealth()/100

	if params.target:IsCreep() then 
		damage = damage/self:GetCaster():GetTalentValue("modifier_hoodwink_scurry_4", "creeps")
	end

	params.target:EmitSound("Hoodwink.Scurry_attack")
	params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_hoodwink_scurry_custom_knock", 
	{
		duration = self:GetCaster():GetTalentValue("modifier_hoodwink_scurry_4", "duration"),
		x = self:GetCaster():GetAbsOrigin().x,
		y = self:GetCaster():GetAbsOrigin().y
	})



	local damageTable = { victim = params.target, attacker = self:GetParent(), damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self:GetAbility(), damage_flags = DOTA_DAMAGE_FLAG_NONE }
	local real_damage = ApplyDamage(damageTable)

	SendOverheadEventMessage( nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, params.target, real_damage, self:GetCaster():GetPlayerOwner() )

end

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
	local bonus = 0


	return self.evasion + bonus
end

function modifier_hoodwink_scurry_custom:OnIntervalThink()


local trees = GridNav:GetAllTreesAroundPoint( self.parent:GetOrigin(), self.radius, false )
local stack = 1

if #trees>0 then
 	stack = 0 
end

if self:GetParent():HasModifier("modifier_hoodwink_scurry_6") and not self:GetParent():HasModifier("modifier_hoodwink_scurry_custom_damaged") then 
	self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_hoodwink_scurry_custom_shield", {})
end


if #trees>0 and self.near_trees == false then 
	self.near_trees = true
end

if #trees > 0  then

end

if #trees == 0 and self.near_trees == true then 
	self.near_trees = false
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
self:GetParent():EmitSound("Hero_Hoodwink.Scurry.Cast")

end

function modifier_hoodwink_scurry_custom_buff:OnRefresh( kv )
self.movespeed = self:GetAbility():GetSpecialValueFor( "movement_speed_pct" )	
self.attack_range = self:GetAbility():GetSpecialValueFor("attack_range")
self.spell_range = self:GetAbility():GetSpecialValueFor("cast_range")
end

function modifier_hoodwink_scurry_custom_buff:OnDestroy()
if not IsServer() then return end
	self:GetParent():EmitSound("Hero_Hoodwink.Scurry.End")



end

function modifier_hoodwink_scurry_custom_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,

		MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
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

function modifier_hoodwink_scurry_custom_buff:GetModifierAttackSpeedBonus_Constant()
if not self:GetParent():HasModifier("modifier_hoodwink_scurry_3") then return end
return self:GetCaster():GetTalentValue("modifier_hoodwink_scurry_3", "speed")
end

function modifier_hoodwink_scurry_custom_buff:GetModifierHealthRegenPercentage()
if not self:GetParent():HasModifier("modifier_hoodwink_scurry_2") then return end
return self:GetCaster():GetTalentValue("modifier_hoodwink_scurry_2", "heal")
end

function modifier_hoodwink_scurry_custom_buff:GetModifierIncomingDamage_Percentage()
if not self:GetParent():HasModifier("modifier_hoodwink_scurry_2") then return end
return self:GetCaster():GetTalentValue("modifier_hoodwink_scurry_2", "damage_reduce")
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

function modifier_hoodwink_scurry_custom_buff:GetEffectName()
	return "particles/units/heroes/hero_hoodwink/hoodwink_scurry_aura.vpcf"
end

function modifier_hoodwink_scurry_custom_buff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
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
self.proj = self:GetCaster():GetRangedProjectileName()

self:GetCaster():SetRangedProjectileName("particles/hood_proj.vpcf")
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
	MODIFIER_PROPERTY_TOOLTIP
}
end



function modifier_hoodwink_scurry_custom_legendary:OnTakeDamage(params)
if not IsServer() then return end
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

function modifier_hoodwink_scurry_custom_legendary:OnDestroy()
if not IsServer() then return end
self:GetCaster():SetRangedProjectileName(self.proj)
end



function modifier_hoodwink_scurry_custom_legendary:GetModifierBaseAttackTimeConstant()
return self.bva
end

function modifier_hoodwink_scurry_custom_legendary:OnTooltip()
return self.heal
end


function modifier_hoodwink_scurry_custom_legendary:CheckState()
return
{
	--[MODIFIER_STATE_FORCED_FLYING_VISION] = true
}
end


modifier_hoodwink_scurry_custom_legendary_timer = class({})
function modifier_hoodwink_scurry_custom_legendary_timer:IsHidden() return true end
function modifier_hoodwink_scurry_custom_legendary_timer:IsPurgable() return false end
function modifier_hoodwink_scurry_custom_legendary_timer:RemoveOnDeath() return false end


function modifier_hoodwink_scurry_custom_legendary_timer:OnCreated(table)
if not IsServer() then return end


self.legendary_duration = self:GetCaster():GetTalentValue("modifier_hoodwink_scurry_legendary", "duration")
self.max = self:GetCaster():GetTalentValue("modifier_hoodwink_scurry_legendary", "max")
self.max_distance = self:GetCaster():GetTalentValue("modifier_hoodwink_scurry_legendary", "distance")
self.stack_distance = self.max_distance/self.max

CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), 'Hoodwink_change',  {max = self.max_distance, current = 0})


self.distance = 0
self.stack = 0
self.old_pos = self:GetParent():GetAbsOrigin()

self.particle = ParticleManager:CreateParticle("particles/hood_charge.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
self:AddParticle(self.particle, false, false, -1, false, false)
self:StartIntervalThink(FrameTime())
end




function modifier_hoodwink_scurry_custom_legendary_timer:OnIntervalThink()
if not IsServer() then return end

local distance = math.min((self:GetParent():GetAbsOrigin() - self.old_pos):Length2D(), self.stack_distance)
self.old_pos = self:GetParent():GetAbsOrigin()

local mod = self:GetParent():FindModifierByName("modifier_hoodwink_scurry_custom_legendary")

local max = self.max_distance
local current = self.distance
local active = 0

if mod then 
	max = self.legendary_duration
	current = mod:GetRemainingTime()
	active = 1
end

CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), 'Hoodwink_change',  {max = max, current = current, active = active})


if mod then return end
if not self:GetParent():IsAlive() then return end

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
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_hoodwink_scurry_custom_legendary", {duration = self.legendary_duration})
	else 

		if self.particle == nil then 
			self.particle = ParticleManager:CreateParticle("particles/hood_charge.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
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

















modifier_hoodwink_scurry_custom_knock = class({})

function modifier_hoodwink_scurry_custom_knock:IsHidden() return true end

function modifier_hoodwink_scurry_custom_knock:OnCreated(params)
  if not IsServer() then return end
  
  self.ability        = self:GetAbility()
  self.caster         = self:GetCaster()
  self.parent         = self:GetParent()
  self:GetParent():StartGesture(ACT_DOTA_FLAIL)
  
  self.knockback_duration   = self:GetCaster():GetTalentValue("modifier_hoodwink_scurry_4", "duration")

  self.knockback_distance   = math.max(self:GetCaster():GetTalentValue("modifier_hoodwink_scurry_4", "distance") - (self.caster:GetAbsOrigin() - self.parent:GetAbsOrigin()):Length2D(), 50)
  
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












function hoodwink_scurry_custom_1:CastFilterResult()
	if self:GetCaster():HasModifier( "modifier_hoodwink_scurry_custom_buff" ) then
		return UF_FAIL_CUSTOM
	end

	return UF_SUCCESS
end

function hoodwink_scurry_custom_1:GetCustomCastError()
	if self:GetCaster():HasModifier( "modifier_hoodwink_scurry_custom_buff" ) then
		return "#dota_hud_error_hoodwink_already_scurrying"
	end

	return ""
end


function hoodwink_scurry_custom_1:GetBehavior()
local hidden = 0 
local toggle = 0

if self:GetCaster():GetUpgradeStack("modifier_hoodwink_scurry_1") ~= 1 then 
	hidden = DOTA_ABILITY_BEHAVIOR_HIDDEN
end 

if self:GetCaster():HasModifier("modifier_hoodwink_scurry_5") then 
	toggle = DOTA_ABILITY_BEHAVIOR_AUTOCAST
end 

return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + hidden + toggle
end


function hoodwink_scurry_custom_1:OnSpellStart()

local ability = self:GetCaster():FindAbilityByName("hoodwink_scurry_custom")
if not ability then return end 

ability:Cast(self:GetCaster():HasModifier("modifier_hoodwink_scurry_5") and self:GetAutoCastState() == true)
end









function hoodwink_scurry_custom_2:CastFilterResult()
	if self:GetCaster():HasModifier( "modifier_hoodwink_scurry_custom_buff" ) then
		return UF_FAIL_CUSTOM
	end

	return UF_SUCCESS
end

function hoodwink_scurry_custom_2:GetCustomCastError()
	if self:GetCaster():HasModifier( "modifier_hoodwink_scurry_custom_buff" ) then
		return "#dota_hud_error_hoodwink_already_scurrying"
	end

	return ""
end


function hoodwink_scurry_custom_2:GetBehavior()
local hidden = 0 
local toggle = 0

if self:GetCaster():GetUpgradeStack("modifier_hoodwink_scurry_1") ~= 2 then 
	hidden = DOTA_ABILITY_BEHAVIOR_HIDDEN
end 

if self:GetCaster():HasModifier("modifier_hoodwink_scurry_5") then 
	toggle = DOTA_ABILITY_BEHAVIOR_AUTOCAST
end 

return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + hidden + toggle
end



function hoodwink_scurry_custom_2:OnSpellStart()

local ability = self:GetCaster():FindAbilityByName("hoodwink_scurry_custom")
if not ability then return end 

ability:Cast(self:GetCaster():HasModifier("modifier_hoodwink_scurry_5") and self:GetAutoCastState() == true)
end








function hoodwink_scurry_custom_3:CastFilterResult()
	if self:GetCaster():HasModifier( "modifier_hoodwink_scurry_custom_buff" ) then
		return UF_FAIL_CUSTOM
	end

	return UF_SUCCESS
end

function hoodwink_scurry_custom_3:GetCustomCastError()
	if self:GetCaster():HasModifier( "modifier_hoodwink_scurry_custom_buff" ) then
		return "#dota_hud_error_hoodwink_already_scurrying"
	end

	return ""
end


function hoodwink_scurry_custom_3:GetBehavior()
local hidden = 0 
local toggle = 0

if self:GetCaster():GetUpgradeStack("modifier_hoodwink_scurry_1") ~= 3 then 
	hidden = DOTA_ABILITY_BEHAVIOR_HIDDEN
end 

if self:GetCaster():HasModifier("modifier_hoodwink_scurry_5") then 
	toggle = DOTA_ABILITY_BEHAVIOR_AUTOCAST
end 

return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + hidden + toggle
end


function hoodwink_scurry_custom_3:OnSpellStart()

local ability = self:GetCaster():FindAbilityByName("hoodwink_scurry_custom")
if not ability then return end 


ability:Cast(self:GetCaster():HasModifier("modifier_hoodwink_scurry_5") and self:GetAutoCastState() == true)
end







modifier_hoodwink_scurry_custom_shield = class({})
function modifier_hoodwink_scurry_custom_shield:IsHidden() 
    return true
end
function modifier_hoodwink_scurry_custom_shield:GetTexture() return "buffs/reincarnation_shield" end
function modifier_hoodwink_scurry_custom_shield:IsPurgable() return false end
function modifier_hoodwink_scurry_custom_shield:OnCreated(table)

self.status = self:GetCaster():GetTalentValue("modifier_hoodwink_scurry_6", "status")
self.shield_max = self:GetCaster():GetTalentValue("modifier_hoodwink_scurry_6", "shield")/100

self.max_shield = self:GetParent():GetMaxHealth()*self.shield_max

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
    MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING
}

end


function modifier_hoodwink_scurry_custom_shield:GetModifierStatusResistanceStacking() 
    return self.status
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

if self:GetStackCount() > params.damage then
    self:SetStackCount(self:GetStackCount() - params.damage)
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