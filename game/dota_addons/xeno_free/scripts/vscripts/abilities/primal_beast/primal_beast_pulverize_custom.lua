LinkLuaModifier( "modifier_primal_beast_pulverize_custom", "abilities/primal_beast/primal_beast_pulverize_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_primal_beast_pulverize_custom_debuff", "abilities/primal_beast/primal_beast_pulverize_custom", LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier( "modifier_primal_beast_pulverize_custom_tracker", "abilities/primal_beast/primal_beast_pulverize_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_primal_beast_pulverize_custom_legendary_count", "abilities/primal_beast/primal_beast_pulverize_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_primal_beast_pulverize_custom_legendary_tracker", "abilities/primal_beast/primal_beast_pulverize_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_primal_beast_pulverize_custom_legendary_attack", "abilities/primal_beast/primal_beast_pulverize_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_primal_beast_pulverize_custom_legendary_rock_cd", "abilities/primal_beast/primal_beast_pulverize_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_primal_beast_pulverize_custom_str", "abilities/primal_beast/primal_beast_pulverize_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_primal_beast_pulverize_custom_str_count", "abilities/primal_beast/primal_beast_pulverize_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_primal_beast_pulverize_scepter_slow", "abilities/primal_beast/primal_beast_pulverize_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_primal_beast_pulverize_kill_str", "abilities/primal_beast/primal_beast_pulverize_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_primal_beast_pulverize_kill_regen", "abilities/primal_beast/primal_beast_pulverize_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_primal_beast_pulverize_kill_bkb", "abilities/primal_beast/primal_beast_pulverize_custom", LUA_MODIFIER_MOTION_NONE )

primal_beast_pulverize_custom = class({})

primal_beast_pulverize_custom.cd = {-4, -7, -10}

primal_beast_pulverize_custom.damage = {0.3, 0.45, 0.6}


primal_beast_pulverize_custom.str_duration = 15
primal_beast_pulverize_custom.str_change = {4, 6}
primal_beast_pulverize_custom.str_scale = 7

primal_beast_pulverize_custom.slow_move = {-40, -60, -80}
primal_beast_pulverize_custom.slow_heal = {-20, -30, -40}
primal_beast_pulverize_custom.slow_duration = 3

primal_beast_pulverize_custom.kill_bkb = 1
primal_beast_pulverize_custom.kill_bkb_magic = 50

primal_beast_pulverize_custom.hit_heal = 0.1
primal_beast_pulverize_custom.hit_cd = 1.5



function primal_beast_pulverize_custom:Precache(context)

PrecacheResource( "particle", 'particles/units/heroes/hero_primal_beast/primal_beast_pulverize_hit.vpcf', context )
PrecacheResource( "particle", 'particles/beast_ult_count.vpcf', context )
PrecacheResource( "particle", 'particles/status_fx/status_effect_mars_spear.vpcf', context )

end



function primal_beast_pulverize_custom:GetIntrinsicModifierName()
return "modifier_primal_beast_pulverize_custom_tracker"
end


function primal_beast_pulverize_custom:AddLegendaryStack()
if not IsServer() then return end

local mod = self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_primal_beast_pulverize_custom_legendary_count", {duration = self:GetCaster():GetTalentValue("modifier_primal_beast_pulverize_7", "duration")})

if not mod then return end
if  mod:GetStackCount() < self:GetCaster():GetTalentValue("modifier_primal_beast_pulverize_7", "max") then 
    mod:IncrementStackCount() 
end

end


function primal_beast_pulverize_custom:GetCooldown(iLevel)

local upgrade_cooldown = 0

if self:GetCaster():HasModifier("modifier_primal_beast_pulverize_3") then 
  upgrade_cooldown = self.cd[self:GetCaster():GetUpgradeStack("modifier_primal_beast_pulverize_3")]
end

 return self.BaseClass.GetCooldown(self, iLevel) + upgrade_cooldown

end


function primal_beast_pulverize_custom:GetChannelAnimation()
	return ACT_DOTA_CHANNEL_ABILITY_5
end

function primal_beast_pulverize_custom:GetChannelTime()
local bonus = self:GetCaster():GetUpgradeStack("modifier_primal_beast_pulverize_custom_legendary_count")*self:GetSpecialValueFor("interval")

return self:GetSpecialValueFor( "channel_time" ) + bonus
end

primal_beast_pulverize_custom.modifiers = {}

function primal_beast_pulverize_custom:OnSpellStart(new_target)
if not IsServer() then return end

local target = self:GetCursorTarget()

if new_target then 
	target = new_target
end

target:InterruptMotionControllers(true)

self:EndCooldown()
self:SetActivated(false)



if not self:GetCaster():HasModifier("modifier_primal_beast_pulverize_6") then 

	if target:TriggerSpellAbsorb( self ) then
		self:GetCaster():Interrupt()
		return
	end

end

local duration = self:GetSpecialValueFor( "channel_time" ) + self:GetCaster():GetUpgradeStack("modifier_primal_beast_pulverize_custom_legendary_count")*self:GetSpecialValueFor("interval")

local legendary_mod = self:GetCaster():FindModifierByName("modifier_primal_beast_pulverize_custom_legendary_count")

if legendary_mod then
	legendary_mod:SetDuration(99999, true)

end


local mod = target:AddNewModifier( self:GetCaster(), self, "modifier_primal_beast_pulverize_custom_debuff", { duration = duration } )
self.modifiers[mod] = true

self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_primal_beast_pulverize_custom", { duration = duration } )

if not target:IsHero() then
	self:GetCaster():EmitSound("Hero_PrimalBeast.Pulverize.Cast.Creep")
else
	self:GetCaster():EmitSound("Hero_PrimalBeast.Pulverize.Cast")
end

end

function primal_beast_pulverize_custom:OnChannelFinish( bInterrupted )
	if not IsServer() then return end

	self:SetActivated(true)
	self:UseResources(false, false, false, true)

	for mod,_ in pairs(self.modifiers) do
		if not mod:IsNull() then
			mod:Destroy()
		end
	end

	self.modifiers = {}

	local self_mod = self:GetCaster():FindModifierByName( "modifier_primal_beast_pulverize_custom" )
	if self_mod then
		self_mod:Destroy()
	end

	if self:GetCaster():HasModifier("modifier_primal_beast_pulverize_custom_legendary_count") then
		self:GetCaster():RemoveModifierByName("modifier_primal_beast_pulverize_custom_legendary_count")
	end
end

function primal_beast_pulverize_custom:RemoveModifier( mod )
	self.modifiers[mod] = nil

	local has_enemies = false

	for _,mod in pairs(self.modifiers) do
		has_enemies = true
	end

	if not has_enemies then
		self:EndChannel( true )
	end
end




modifier_primal_beast_pulverize_custom = class({})

function modifier_primal_beast_pulverize_custom:IsPurgable()
	return false
end
function modifier_primal_beast_pulverize_custom:IsHidden()
	return true
end
function modifier_primal_beast_pulverize_custom:DeclareFunctions()
local funcs = {
	MODIFIER_PROPERTY_DISABLE_TURNING,
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
}

	return funcs
end

function modifier_primal_beast_pulverize_custom:GetModifierDisableTurning()
	return 1
end



function modifier_primal_beast_pulverize_custom:OnCreated(table)
if not IsServer() then return end 

if self:GetCaster():HasModifier("modifier_primal_beast_pulverize_6") then 
	self.bkb = self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_generic_debuff_immune", {effect = 1})

end

end







function modifier_primal_beast_pulverize_custom:OnDestroy()
if not IsServer() then return end
if not self:GetCaster():HasModifier("modifier_primal_beast_pulverize_6") then return end

if self.bkb and not self.bkb:IsNull() then 
	self.bkb:SetDuration(self:GetAbility().kill_bkb, true)
end 

end


modifier_primal_beast_pulverize_custom_debuff = class({})

function modifier_primal_beast_pulverize_custom_debuff:IsPurgable()
	return true
end

function modifier_primal_beast_pulverize_custom_debuff:IsStunDebuff()
	return true
end

function modifier_primal_beast_pulverize_custom_debuff:OnCreated( kv )
	self.interval = self:GetAbility():GetSpecialValueFor( "interval" )
	self.radius = self:GetAbility():GetSpecialValueFor( "splash_radius" )
	self.ministun = self:GetAbility():GetSpecialValueFor( "ministun" )


	self.animrate = self:GetAbility():GetSpecialValueFor( "animation_rate" )
	if not IsServer() then return end

	self.interrupt_pos = self:GetCaster():GetOrigin() + self:GetCaster():GetForwardVector() * 200
	self.cast_pos = self:GetCaster():GetOrigin()
	self.pos_threshold = 100

	local attach_rollback = {
		[1] = "attach_pummel",
		[2] = "attach_attack1",
		[3] = "attach_attack",
		[4] = "attach_hitloc",
	}

	for i,name in ipairs(attach_rollback) do
		self.attach_name = name
		if self:GetCaster():ScriptLookupAttachment( name )~=0 then
			break
		end
	end

	local hitloc_enum = self:GetParent():ScriptLookupAttachment( "attach_hitloc" )
	local hitloc_pos = self:GetParent():GetAttachmentOrigin( hitloc_enum )
	self.deltapos = self:GetParent():GetOrigin() - hitloc_pos

	if not self:ApplyHorizontalMotionController() then
			self:Destroy()
			return
	end

	if not self:ApplyVerticalMotionController() then
			self:Destroy()
			return
	end

	self:SetPriority( DOTA_MOTION_CONTROLLER_PRIORITY_HIGHEST )
	self:StartIntervalThink( self.interval )
end

function modifier_primal_beast_pulverize_custom_debuff:OnDestroy()
	if not IsServer() then return end
	self:GetParent():FadeGesture(ACT_DOTA_FLAIL)
	self:GetParent():RemoveHorizontalMotionController( self )

	--if not (self:GetParent():IsCurrentlyHorizontalMotionControlled() or self:GetParent():IsCurrentlyVerticalMotionControlled()) then

		
		local angle = self:GetParent():GetAnglesAsVector()
		self:GetParent():SetAngles( 0, angle.y+180, 0 )
		FindClearSpaceForUnit( self:GetParent(), GetGroundPosition(self.interrupt_pos, nil), false )
	--end

	self:GetAbility():RemoveModifier( self )
end

function modifier_primal_beast_pulverize_custom_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE,
	}

	return funcs
end




function modifier_primal_beast_pulverize_custom_debuff:GetOverrideAnimation()

	return ACT_DOTA_FLAIL
end

function modifier_primal_beast_pulverize_custom_debuff:GetOverrideAnimationRate()
	return self.animrate
end

function modifier_primal_beast_pulverize_custom_debuff:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_CANNOT_BE_MOTION_CONTROLLED] = true,
	}

	return state
end

function modifier_primal_beast_pulverize_custom_debuff:OnIntervalThink()
	local origin = self.interrupt_pos
	local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), origin, nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
	local damage = self:GetAbility():GetSpecialValueFor( "damage" )
	local stack_damage = math.min(self:GetAbility():GetSpecialValueFor("damage_stack_max"), self:GetAbility():GetSpecialValueFor("damage_stack")*self:GetStackCount())



	damage = damage + stack_damage

	if self:GetCaster():HasModifier("modifier_primal_beast_pulverize_1") then 
		damage = damage + self:GetCaster():GetStrength()*self:GetAbility().damage[self:GetCaster():GetUpgradeStack("modifier_primal_beast_pulverize_1")]
	end

	local damageTable = { attacker = self:GetCaster(), damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self:GetAbility(), damage_flags = DOTA_DAMAGE_FLAG_NONE, }

	if self:GetCaster():HasModifier("modifier_primal_beast_pulverize_4") then 
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_primal_beast_pulverize_custom_str_count", {duration = self:GetAbility().str_duration})
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_primal_beast_pulverize_custom_str", {duration = self:GetAbility().str_duration})
	end


	if self:GetCaster():HasModifier("modifier_primal_beast_pulverize_5") then 
		for abilitySlot = 0,8 do

			local ability = self:GetCaster():GetAbilityByIndex(abilitySlot)

			if ability ~= nil and ability ~= self:GetAbility() and ability:GetName() ~= "primal_beast_uproar_custom" then
				local cd = ability:GetCooldownTimeRemaining()
				ability:EndCooldown()
				if cd > self:GetAbility().hit_cd then 
					ability:StartCooldown(cd - self:GetAbility().hit_cd)
				end
			end
		end

		local heal = self:GetAbility().hit_heal*(self:GetCaster():GetMaxHealth() - self:GetCaster():GetHealth())

		self:GetCaster():Heal(heal, self:GetAbility())

		SendOverheadEventMessage(self:GetCaster(), 10, self:GetCaster(), heal, nil)

		local particle = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:ReleaseParticleIndex( particle )
	end


	for _,enemy in pairs(enemies) do

		if enemy:IsHero() and self:GetCaster():HasModifier("modifier_primal_beast_pulverize_4") then 
			enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_primal_beast_pulverize_custom_str_count", {duration = self:GetAbility().str_duration})
			enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_primal_beast_pulverize_custom_str", {duration = self:GetAbility().str_duration})
		end

		if self:GetCaster():HasModifier("modifier_primal_beast_pulverize_2") then 
			enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_primal_beast_pulverize_scepter_slow", {duration = (1 - enemy:GetStatusResistance())*self:GetAbility().slow_duration})
		end


		damageTable.victim = enemy
		ApplyDamage(damageTable)
		enemy:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_stunned", { duration = self.ministun } )
		self:GetCaster():EmitSound("Hero_PrimalBeast.Pulverize.Stun")
	end

	self:IncrementStackCount()
	

	self:PlayEffects( origin, self.radius )

	if (self:GetCaster():GetOrigin()-self.cast_pos):Length2D() > self.pos_threshold then
		self:Destroy()
		return		
	end
end


function modifier_primal_beast_pulverize_custom_debuff:UpdateHorizontalMotion( me, dt )
	if self:GetParent():IsOutOfGame() or self:GetParent():IsInvulnerable() then
		self:Destroy()
		return
	end

	local attach = self:GetCaster():ScriptLookupAttachment( self.attach_name )
	local pos = self:GetCaster():GetAttachmentOrigin( attach )
	local angles = self:GetCaster():GetAttachmentAngles( attach )

	me:SetLocalAngles( 180-angles.x, 180+angles.y, 0 )

	local deltapos = RotatePosition( Vector(0,0,0), QAngle(180-angles.x, 180+angles.y,0), self.deltapos )
	pos = pos + deltapos

	me:SetOrigin( pos )
end


function modifier_primal_beast_pulverize_custom_debuff:OnHorizontalMotionInterrupted()
	self:Destroy()
end

function modifier_primal_beast_pulverize_custom_debuff:UpdateVerticalMotion( me, dt )
	local attach = self:GetCaster():ScriptLookupAttachment( self.attach_name )
	local pos = self:GetCaster():GetAttachmentOrigin( attach )
	local angles = self:GetCaster():GetAttachmentAngles( attach )

	local deltapos = RotatePosition( Vector(0,0,0), QAngle(180-angles.x, 180+angles.y,0), self.deltapos )
	pos = pos + deltapos

	local mepos = me:GetOrigin()
	mepos.z = pos.z
	me:SetOrigin( mepos )
end

function modifier_primal_beast_pulverize_custom_debuff:OnHorizontalMotionInterrupted()
	self:Destroy()
end

function modifier_primal_beast_pulverize_custom_debuff:GetPriority()
	return DOTA_MOTION_CONTROLLER_PRIORITY_HIGHEST
end

function modifier_primal_beast_pulverize_custom_debuff:GetMotionPriority()
	return DOTA_MOTION_CONTROLLER_PRIORITY_HIGHEST
end

function modifier_primal_beast_pulverize_custom_debuff:PlayEffects( origin, radius )
	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_primal_beast/primal_beast_pulverize_hit.vpcf", PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, origin )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector(radius, radius, radius) )
	ParticleManager:DestroyParticle( effect_cast, false )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), "Hero_PrimalBeast.Pulverize.Impact", self:GetCaster() )
end


modifier_primal_beast_pulverize_custom_tracker = class({})
function modifier_primal_beast_pulverize_custom_tracker:IsHidden() return true end
function modifier_primal_beast_pulverize_custom_tracker:IsPurgable() return false end
function modifier_primal_beast_pulverize_custom_tracker:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_ATTACK_LANDED,
	MODIFIER_EVENT_ON_TAKEDAMAGE,
}
end








function modifier_primal_beast_pulverize_custom_tracker:OnTakeDamage(params)
if not IsServer() then return end
if self:GetCaster() ~= params.attacker then return end
if params.inflictor == nil then return end
if params.inflictor:GetName() ~= "primal_beast_rock_throw" then return end
if not self:GetParent():HasModifier("modifier_primal_beast_pulverize_7") then return end
if self:GetParent():HasModifier("modifier_primal_beast_pulverize_custom_legendary_rock_cd") then return end

self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_primal_beast_pulverize_custom_legendary_rock_cd", {duration = 0.2})
self:GetAbility():AddLegendaryStack()

end



modifier_primal_beast_pulverize_custom_legendary_attack = class({})
function modifier_primal_beast_pulverize_custom_legendary_attack:IsHidden() return true end
function modifier_primal_beast_pulverize_custom_legendary_attack:IsPurgable() return false end

function modifier_primal_beast_pulverize_custom_legendary_attack:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
end

function modifier_primal_beast_pulverize_custom_legendary_attack:OnRefresh(table)
if not IsServer() then return end
self:IncrementStackCount()

if self:GetStackCount() == self:GetAbility().legendary_attack then 
	self:GetAbility():AddLegendaryStack()
	self:Destroy()
end

end




modifier_primal_beast_pulverize_custom_legendary_count = class({})
function modifier_primal_beast_pulverize_custom_legendary_count:IsHidden() return true end
function modifier_primal_beast_pulverize_custom_legendary_count:IsPurgable() return false end

function modifier_primal_beast_pulverize_custom_legendary_count:OnCreated(table)
if not IsServer() then return end

self.max = self:GetCaster():GetTalentValue("modifier_primal_beast_pulverize_7", "max")
self.timer = self:GetCaster():GetTalentValue("modifier_primal_beast_pulverize_7", "duration")

local name = "particles/beast_ult_count.vpcf"
self.particle = ParticleManager:CreateParticle(name, PATTACH_OVERHEAD_FOLLOW, self:GetParent())
self:AddParticle(self.particle, false, false, -1, false, false)

self:SetStackCount(0)
end


function modifier_primal_beast_pulverize_custom_legendary_count:OnStackCountChanged(iStackCount)
if self:GetStackCount() == 0 then return end
if not self.particle then return end

for i = 1,self.max do 
	
	if i <= self:GetStackCount() then 
		ParticleManager:SetParticleControl(self.particle, i, Vector(1, 0, 0))	
	else 
		ParticleManager:SetParticleControl(self.particle, i, Vector(0, 0, 0))	
	end
end

end



function modifier_primal_beast_pulverize_custom_legendary_count:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_TAKEDAMAGE
}
end

function modifier_primal_beast_pulverize_custom_legendary_count:OnTakeDamage(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker and self:GetParent() ~= params.unit then return end
if params.inflictor and params.inflictor:IsItem() and self:GetParent() == params.attacker then return end

self:SetDuration(self.timer, true)
end




modifier_primal_beast_pulverize_custom_legendary_rock_cd = class({})
function modifier_primal_beast_pulverize_custom_legendary_rock_cd:IsHidden() return true end
function modifier_primal_beast_pulverize_custom_legendary_rock_cd:IsPurgable() return false end


modifier_primal_beast_pulverize_custom_str = class({})
function modifier_primal_beast_pulverize_custom_str:IsHidden() return true end
function modifier_primal_beast_pulverize_custom_str:IsPurgable() return false end
function modifier_primal_beast_pulverize_custom_str:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_primal_beast_pulverize_custom_str:OnCreated(table)
if not IsServer() then return end
self.RemoveForDuel = true
end

function modifier_primal_beast_pulverize_custom_str:OnDestroy()
if not IsServer() then return end

local mod = self:GetParent():FindModifierByName("modifier_primal_beast_pulverize_custom_str_count")

if mod then 
	mod:DecrementStackCount()
	if mod:GetStackCount() == 0 then 
		mod:Destroy()
	end
end

end


modifier_primal_beast_pulverize_custom_str_count = class({})
function modifier_primal_beast_pulverize_custom_str_count:IsHidden() return false end
function modifier_primal_beast_pulverize_custom_str_count:IsPurgable() return false end
function modifier_primal_beast_pulverize_custom_str_count:GetTexture() return "buffs/pulverize_str" end


function modifier_primal_beast_pulverize_custom_str_count:OnCreated(table)
if not IsServer() then return end

self:IncrementStackCount()
self.str_percentage = self:GetAbility().str_change[self:GetCaster():GetUpgradeStack("modifier_primal_beast_pulverize_4")]

if self:GetCaster():GetTeamNumber() ~= self:GetParent():GetTeamNumber() then 
	self.str_percentage = self.str_percentage*-1
end

self.PercentStr  = self.str_percentage * 0.01

end

function modifier_primal_beast_pulverize_custom_str_count:OnRefresh(table)
if not IsServer() then return end
self:IncrementStackCount()


self.PercentStr  = self.str_percentage * 0.01 * self:GetStackCount()
end




function modifier_primal_beast_pulverize_custom_str_count:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOOLTIP,
	MODIFIER_PROPERTY_MODEL_SCALE
}

end

function modifier_primal_beast_pulverize_custom_str_count:OnTooltip()
return self:GetAbility().str_change[self:GetCaster():GetUpgradeStack("modifier_primal_beast_pulverize_4")]*self:GetStackCount()
end




function modifier_primal_beast_pulverize_custom_str_count:GetModifierModelScale()
if self:GetCaster():GetTeamNumber() == self:GetParent():GetTeamNumber() then 
return self:GetStackCount()*self:GetAbility().str_scale
end
return
end




modifier_primal_beast_pulverize_scepter_slow = class({})
function modifier_primal_beast_pulverize_scepter_slow:IsHidden() return false end
function modifier_primal_beast_pulverize_scepter_slow:IsPurgable() return false end
function modifier_primal_beast_pulverize_scepter_slow:GetTexture() return "buffs/dismember_damage" end
function modifier_primal_beast_pulverize_scepter_slow:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
	MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
	MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE,
}
end

function modifier_primal_beast_pulverize_scepter_slow:GetEffectName()
return "particles/items2_fx/sange_maim.vpcf"
end


function modifier_primal_beast_pulverize_scepter_slow:GetModifierMoveSpeedBonus_Percentage()
return self:GetAbility().slow_move[self:GetCaster():GetUpgradeStack("modifier_primal_beast_pulverize_2")]
end

function modifier_primal_beast_pulverize_scepter_slow:StatusEffectPriority()
return 111111
end

function modifier_primal_beast_pulverize_scepter_slow:GetStatusEffectName()
return "particles/status_fx/status_effect_mars_spear.vpcf"
end




function modifier_primal_beast_pulverize_scepter_slow:GetModifierLifestealRegenAmplify_Percentage() 
return self:GetAbility().slow_heal[self:GetCaster():GetUpgradeStack("modifier_primal_beast_pulverize_2")]
end

function modifier_primal_beast_pulverize_scepter_slow:GetModifierHealAmplify_PercentageTarget() 
return self:GetAbility().slow_heal[self:GetCaster():GetUpgradeStack("modifier_primal_beast_pulverize_2")]
end

function modifier_primal_beast_pulverize_scepter_slow:GetModifierHPRegenAmplify_Percentage() 
return self:GetAbility().slow_heal[self:GetCaster():GetUpgradeStack("modifier_primal_beast_pulverize_2")]
end





function modifier_primal_beast_pulverize_scepter_slow:OnCreated(table)
if not IsServer() then return end
end



modifier_primal_beast_pulverize_kill_str = class({})
function modifier_primal_beast_pulverize_kill_str:IsHidden() return false end
function modifier_primal_beast_pulverize_kill_str:IsPurgable() return false end
function modifier_primal_beast_pulverize_kill_str:RemoveOnDeath() return false end
function modifier_primal_beast_pulverize_kill_str:GetTexture() return "buffs/pulverize_kill" end
function modifier_primal_beast_pulverize_kill_str:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	MODIFIER_PROPERTY_TOOLTIP
}
end

function modifier_primal_beast_pulverize_kill_str:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
self:GetCaster():CalculateStatBonus(true)
end


function modifier_primal_beast_pulverize_kill_str:OnRefresh(table)
if not IsServer() then return end
self:IncrementStackCount()
self:GetCaster():CalculateStatBonus(true)
end


function modifier_primal_beast_pulverize_kill_str:OnTooltip()
return self:GetStackCount()
end









modifier_primal_beast_pulverize_custom_legendary_tracker = class({})
function modifier_primal_beast_pulverize_custom_legendary_tracker:IsHidden() return true end
function modifier_primal_beast_pulverize_custom_legendary_tracker:IsPurgable() return false end
function modifier_primal_beast_pulverize_custom_legendary_tracker:RemoveOnDeath() return false end
function modifier_primal_beast_pulverize_custom_legendary_tracker:OnCreated(table)

self.max = self:GetCaster():GetTalentValue("modifier_primal_beast_pulverize_7", "max")

if not IsServer() then return end
self:StartIntervalThink(0.1)

end

function modifier_primal_beast_pulverize_custom_legendary_tracker:OnIntervalThink()
if not IsServer() then return end
local stack = 0
if self:GetParent():HasModifier("modifier_primal_beast_pulverize_custom_legendary_count") then 
	stack = self:GetParent():FindModifierByName("modifier_primal_beast_pulverize_custom_legendary_count"):GetStackCount()
end
CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), 'beast_ulti_change',  {max = self.max, rage = stack})
	


end


modifier_primal_beast_pulverize_kill_bkb = class({})
function modifier_primal_beast_pulverize_kill_bkb:IsHidden() return true end
function modifier_primal_beast_pulverize_kill_bkb:IsPurgable() return false end
function modifier_primal_beast_pulverize_kill_bkb:CheckState()
return
{
	--[MODIFIER_STATE_MAGIC_IMMUNE] = true
}
end


function modifier_primal_beast_pulverize_kill_bkb:GetEffectName() 
return "particles/items_fx/black_king_bar_avatar.vpcf" 
end
