LinkLuaModifier( "modifier_sven_storm_bolt_custom_legendary", "abilities/sven/sven_storm_bolt_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sven_storm_bolt_custom_tracker", "abilities/sven/sven_storm_bolt_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sven_storm_bolt_custom_scepter", "abilities/sven/sven_storm_bolt_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sven_storm_bolt_custom_speed", "abilities/sven/sven_storm_bolt_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sven_storm_bolt_custom_stun", "abilities/sven/sven_storm_bolt_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sven_storm_bolt_custom_silence", "abilities/sven/sven_storm_bolt_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sven_storm_bolt_custom_proc", "abilities/sven/sven_storm_bolt_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sven_storm_bolt_custom_legendary_stack", "abilities/sven/sven_storm_bolt_custom", LUA_MODIFIER_MOTION_NONE )


sven_storm_bolt_custom = class({})


sven_storm_bolt_custom.str_damage = {0.4, 0.6, 0.8}

sven_storm_bolt_custom.cd_range = {100, 150, 200}
sven_storm_bolt_custom.cd_stun = {0.3, 0.45, 0.6}




sven_storm_bolt_custom.attack_cd = 0.3

sven_storm_bolt_custom.proc_damage = 0.25
sven_storm_bolt_custom.proc_stun = 0.15
sven_storm_bolt_custom.proc_count = {2, 3}
sven_storm_bolt_custom.proc_duration = 5

sven_storm_bolt_custom.speed_duration = 4
sven_storm_bolt_custom.speed_inc = {30, 45, 60}
sven_storm_bolt_custom.speed_creep = 0.25
sven_storm_bolt_custom.speed_heal = {0.08, 0.12, 0.16}



function sven_storm_bolt_custom:Precache(context)


PrecacheResource( "particle", "particles/units/heroes/hero_sven/sven_attack_blur_3_alt.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_sven/sven_attack_blur_2.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_sven/sven_attack_blur.vpcf", context )
PrecacheResource( "particle", "particles/econ/items/sven/sven_warcry_ti5/sven_warcry_shield_bash_blur.vpcf", context )

PrecacheResource( "particle", "particles/units/heroes/hero_sven/sven_spell_storm_bolt_lightning.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_sven/sven_spell_storm_bolt.vpcf", context )
PrecacheResource( "particle", "particles/sven_bolt_visual.vpcf", context )
PrecacheResource( "particle", "particles/sven_storm_aoe.vpcf", context )
PrecacheResource( "particle", "particles/econ/items/zeus/zeus_immortal_2021/zeus_immortal_2021_static_field_gold.vpcf", context )
PrecacheResource( "particle", "particles/econ/items/sven/sven_warcry_ti5/sven_warcry_cast_arc_lightning.vpcf", context )
PrecacheResource( "particle", "particles/lc_odd_proc_hands.vpcf", context )
PrecacheResource( "particle", "particles/ogre_dd.vpcf", context )
PrecacheResource( "particle", "particles/sven_hammer_stack.vpcf", context )

end



sven_storm_bolt_custom.thinkers = {}



function sven_storm_bolt_custom:GetBehavior()
	local behavior = DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_AOE + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING
	if self:GetCaster():HasScepter() then
		behavior = behavior + DOTA_ABILITY_BEHAVIOR_AUTOCAST
	end
	return behavior
end

function sven_storm_bolt_custom:GetCastRange( target, position )

	if self:GetCaster():HasModifier("modifier_sven_hammer_2") then
		return self.BaseClass.GetCastRange( self, target, position ) + self.cd_range[self:GetCaster():GetUpgradeStack("modifier_sven_hammer_2")]
	else
		return self.BaseClass.GetCastRange( self, target, position )
	end
end



function sven_storm_bolt_custom:GetManaCost(iLevel)
if self:GetCaster():HasModifier("modifier_sven_hammer_5") then 
	return self:GetCaster():GetTalentValue("modifier_sven_hammer_5", "mana")
end

return self.BaseClass.GetManaCost( self, iLevel)
end



function sven_storm_bolt_custom:GetAOERadius()
	return self:GetSpecialValueFor( "bolt_aoe" )
end


function sven_storm_bolt_custom:GetIntrinsicModifierName()
return "modifier_sven_storm_bolt_custom_tracker"
end


function sven_storm_bolt_custom:GetCooldown(iLevel)

local bonus = 0

if self:GetCaster():HasModifier("modifier_sven_hammer_2") then
	--bonus = self.cd_inc[self:GetCaster():GetUpgradeStack("modifier_sven_hammer_2")]
end

return self.BaseClass.GetCooldown(self, iLevel) + bonus
end



--function sven_storm_bolt_custom:CastFilterResultTarget(target)

--if self:GetCaster():HasModifier("modifier_sven_hammer_6") then 
  --return UnitFilter(target, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, self:GetCaster():GetTeamNumber())
--else 
  --return UnitFilter(target, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, self:GetCaster():GetTeamNumber())
--end

--end



function sven_storm_bolt_custom:OnAbilityPhaseStart()
	local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_sven/sven_spell_storm_bolt_lightning.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_sword", self:GetCaster():GetOrigin(), true )

	local vLightningOffset = self:GetCaster():GetOrigin() + Vector( 0, 0, 1600 )
	ParticleManager:SetParticleControl( nFXIndex, 1, vLightningOffset )

	ParticleManager:ReleaseParticleIndex( nFXIndex )

	return true
end




function sven_storm_bolt_custom:GetBoltDamage(target)
if not IsServer() then return end

local damage = self:GetSpecialValueFor( "bolt_damage" )

if self:GetCaster():HasModifier("modifier_sven_hammer_1") then 
	damage = damage + self:GetCaster():GetStrength()*self.str_damage[self:GetCaster():GetUpgradeStack("modifier_sven_hammer_1")]
end

local mod = target:FindModifierByName("modifier_sven_storm_bolt_custom_legendary_stack")
if mod then 
	damage = damage*(1 + mod:GetStackCount()*self:GetCaster():GetTalentValue("modifier_sven_hammer_7", "damage_inc")/100)
end 


return damage
end


function sven_storm_bolt_custom:OnSpellStart(new_target)
	local vision_radius = self:GetSpecialValueFor( "vision_radius" )
	local bolt_speed = self:GetSpecialValueFor( "bolt_speed" )

	local target = self:GetCursorTarget()

	if new_target then 
		target = new_target
	end
		
	local shard_active = 0
	
	if self:GetCaster():HasScepter() and not self:GetAutoCastState() then
	 	shard_active = 1
	end 

	local info = {
			EffectName = "particles/units/heroes/hero_sven/sven_spell_storm_bolt.vpcf",
			Ability = self,
			iMoveSpeed = bolt_speed,
			Source = self:GetCaster(),
			Target = target,
			bDodgeable = not self:GetCaster():HasScepter(),
			bProvidesVision = true,
			iVisionTeamNumber = self:GetCaster():GetTeamNumber(),
			iVisionRadius = vision_radius,
			iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2, 
			ExtraData = {shard_active = shard_active}
		}

	self.projectile = ProjectileManager:CreateTrackingProjectile( info )

	if self:GetCaster():HasScepter() and not self:GetAutoCastState() then
		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_sven_storm_bolt_custom_scepter", {} )
	else 
		if self:GetCaster():HasModifier("modifier_sven_hammer_3") then 
			self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_sven_storm_bolt_custom_speed", {duration = self.speed_duration})
		end
	end

	self:GetCaster():EmitSound( "Hero_Sven.StormBolt" )
end



function sven_storm_bolt_custom:OnProjectileThinkHandle( projID )
	local caster = self:GetCaster()
	if caster:HasModifier("modifier_sven_storm_bolt_custom_scepter") and self.projectile == projID then
		local projLoc = ProjectileManager:GetTrackingProjectileLocation( projID )

		local newPos = GetGroundPosition( projLoc, nil )
		caster:SetAbsOrigin( newPos )
	end
end













function sven_storm_bolt_custom:OnProjectileHit_ExtraData(hTarget, vLocation, table)

if self:GetCaster():HasModifier("modifier_sven_storm_bolt_custom_scepter")  then 

	self:GetCaster():RemoveModifierByName("modifier_sven_storm_bolt_custom_scepter")
	
	if self:GetCaster():HasModifier("modifier_sven_hammer_3") then 
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_sven_storm_bolt_custom_speed", {duration = self.speed_duration})
	end
end

if hTarget == nil then return end
if hTarget:TriggerSpellAbsorb( self ) then return end

if self:GetCaster():HasModifier("modifier_sven_hammer_7") then 

	if self.thinkers[1] then 
		UTIL_Remove(self.thinkers[1])
	end

	local radius = self:GetCaster():GetTalentValue("modifier_sven_hammer_7", "radius")

	self.thinkers[1] = CreateModifierThinker(self:GetCaster(), self, "modifier_sven_storm_bolt_custom_legendary", {}, hTarget:GetAbsOrigin(), self:GetCaster():GetTeamNumber(), false)

	local qangle_rotation_rate = 60

	local line_position = hTarget:GetAbsOrigin() + hTarget:GetForwardVector() * radius
	for i = 1, 6 do

		local qangle = QAngle(0, qangle_rotation_rate, 0)
		line_position = RotatePosition(hTarget:GetAbsOrigin() , qangle, line_position)

		local particle = ParticleManager:CreateParticle("particles/sven_bolt_visual.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget)

		ParticleManager:SetParticleControlEnt(particle, 0, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(particle, 1, line_position)
		ParticleManager:DestroyParticle(particle, false)	
		ParticleManager:ReleaseParticleIndex(particle)
	end
end


if hTarget:IsInvulnerable() then return end

if self:GetCaster():HasScepter() and not hTarget:IsMagicImmune() then 
	hTarget:Purge(true, false, false, false, false)
end

hTarget:EmitSound("Hero_Sven.StormBoltImpact" )

local bolt_aoe = self:GetSpecialValueFor( "bolt_aoe" )
local bolt_stun_duration = self:GetSpecialValueFor( "bolt_stun_duration" )

if self:GetCaster():HasModifier("modifier_sven_hammer_2") then 
	bolt_stun_duration = bolt_stun_duration + self.cd_stun[self:GetCaster():GetUpgradeStack("modifier_sven_hammer_2")]
end

local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), hTarget:GetOrigin(), hTarget, bolt_aoe, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )

local damage_type = DAMAGE_TYPE_MAGICAL

if self:GetCaster():HasModifier("modifier_sven_hammer_6") then 
	damage_type = DAMAGE_TYPE_PURE
end

local bonus = 0
if table.shard_active and table.shard_active == 1 then 
	bonus = self:GetSpecialValueFor("scepter_damage")
end 

for _,enemy in pairs(enemies) do
	if (not enemy:IsMagicImmune()) and not enemy:IsInvulnerable()  then

		ApplyDamage(  { victim = enemy, attacker = self:GetCaster(), damage = self:GetBoltDamage(enemy) + bonus, ability = self, damage_type = damage_type, })
		local stun_mod = enemy:AddNewModifier( self:GetCaster(), self, "modifier_sven_storm_bolt_custom_stun", { duration = bolt_stun_duration*(1 - enemy:GetStatusResistance()) } )

	end
end

return true
end






modifier_sven_storm_bolt_custom_legendary = class({})
function modifier_sven_storm_bolt_custom_legendary:IsHidden() return false end
function modifier_sven_storm_bolt_custom_legendary:IsPurgable() return false end


function modifier_sven_storm_bolt_custom_legendary:OnCreated(table)
if not IsServer() then return end

self:GetParent():EmitSound("Sven.Bolt_legendary")

self.radius = self:GetCaster():GetTalentValue("modifier_sven_hammer_7", "radius")
self.interval = self:GetCaster():GetTalentValue("modifier_sven_hammer_7", "interval")
self.stun = self:GetCaster():GetTalentValue("modifier_sven_hammer_7", "stun")
self.damage_inc = self:GetCaster():GetTalentValue("modifier_sven_hammer_7", "damage_inc")/100
self.damage_init = self:GetCaster():GetTalentValue("modifier_sven_hammer_7", "damage_init")/100
self.duration = self:GetCaster():GetTalentValue("modifier_sven_hammer_7", "duration")

self.zuus_nimbus_particle = ParticleManager:CreateParticle("particles/sven_storm_aoe.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(self.zuus_nimbus_particle, 0, self:GetParent():GetAbsOrigin())
ParticleManager:SetParticleControl(self.zuus_nimbus_particle, 1, Vector(self.radius, 0, 0))
self:AddParticle(self.zuus_nimbus_particle, false, false, -1, false, false)

self:StartIntervalThink(self.interval)
end


function modifier_sven_storm_bolt_custom_legendary:OnDestroy()
if not IsServer() then return end

end


function modifier_sven_storm_bolt_custom_legendary:OnIntervalThink()
if not IsServer() then return end


local enemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), nil,self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, 0, false )

local count = 0

local damage_type = DAMAGE_TYPE_MAGICAL

if self:GetCaster():HasModifier("modifier_sven_hammer_6") then 
	damage_type = DAMAGE_TYPE_PURE
end

local all_count = 0

for _,enemy in pairs(enemies) do 

	if enemy:IsHero() or (enemy:IsCreep() and not enemy:IsOutOfGame()) then 
		all_count = all_count + 1
	end

	if not enemy:IsInvulnerable() and (not enemy:IsMagicImmune() ) then 

		local particle = ParticleManager:CreateParticle( "particles/econ/items/zeus/zeus_immortal_2021/zeus_immortal_2021_static_field_gold.vpcf", PATTACH_POINT_FOLLOW, enemy )
	    ParticleManager:SetParticleControlEnt( particle, 0, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true )
	    ParticleManager:ReleaseParticleIndex( particle )

	    local pfx2 = ParticleManager:CreateParticle( "particles/econ/items/sven/sven_warcry_ti5/sven_warcry_cast_arc_lightning.vpcf", PATTACH_CUSTOMORIGIN, enemy)
		ParticleManager:SetParticleControl( pfx2, 0, enemy:GetAbsOrigin() )
		ParticleManager:ReleaseParticleIndex(pfx2)

		local damage = self.damage_init


		local real_damage = ApplyDamage(  { victim = enemy, attacker = self:GetCaster(), damage = self:GetAbility():GetBoltDamage(enemy)*damage, ability = self:GetAbility(), damage_type = damage_type, })
		
		enemy:SendNumber(4, real_damage)

		if enemy:IsRealHero() and self:GetCaster():GetQuest() == "Sven.Quest_5" then 
			self:GetCaster():UpdateQuest(self.stun)
		end

		if enemy:IsRealHero() or enemy:IsIllusion() then 
			enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stunned", {duration = self.stun})
		end

		enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_sven_storm_bolt_custom_legendary_stack", {duration = self.duration})

		count = count + 1
	end
end

if all_count == 0 then 
	self:Destroy()
else 
	if count > 0 then 
		self:GetParent():EmitSound("Sven.Bolt_legendary_damage")
	end
end

end






modifier_sven_storm_bolt_custom_tracker = class({})
function modifier_sven_storm_bolt_custom_tracker:IsHidden() return true end
function modifier_sven_storm_bolt_custom_tracker:IsPurgable() return false end
function modifier_sven_storm_bolt_custom_tracker:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_ATTACK_LANDED,
    MODIFIER_EVENT_ON_ABILITY_EXECUTED,
}
end

function modifier_sven_storm_bolt_custom_tracker:OnAbilityExecuted( params )
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_sven_hammer_4") then return end
if params.unit~=self:GetParent() then return end
if not params.ability then return end
if params.ability:GetName() == "sven_great_cleave_custom" then return end
if params.ability:IsItem() or params.ability:IsToggle() then return end
if UnvalidAbilities[params.ability:GetName()] then return end

self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_sven_storm_bolt_custom_proc", {duration = self:GetAbility().proc_duration})

end




function modifier_sven_storm_bolt_custom_tracker:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end
if self:GetParent():HasModifier("modifier_sven_great_cleave_custom_legendary") then return end
if self:GetParent():HasModifier("modifier_sven_gods_strength_custom_crit") then return end
if not params.target:IsHero() and not params.target:IsCreep() then return end

local mod = self:GetParent():FindModifierByName("modifier_sven_storm_bolt_custom_proc")

if mod and not params.target:IsMagicImmune() then 

	local damage_type = DAMAGE_TYPE_MAGICAL

	if self:GetCaster():HasModifier("modifier_sven_hammer_6") then 
		damage_type = DAMAGE_TYPE_PURE
	end


	local enemy = params.target

	local particle = ParticleManager:CreateParticle( "particles/econ/items/zeus/zeus_immortal_2021/zeus_immortal_2021_static_field_gold.vpcf", PATTACH_POINT_FOLLOW, enemy )
	ParticleManager:SetParticleControlEnt( particle, 0, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true )
	ParticleManager:ReleaseParticleIndex( particle )

	local pfx2 = ParticleManager:CreateParticle( "particles/econ/items/sven/sven_warcry_ti5/sven_warcry_cast_arc_lightning.vpcf", PATTACH_CUSTOMORIGIN, enemy)
	ParticleManager:SetParticleControl( pfx2, 0, enemy:GetAbsOrigin() )
	ParticleManager:ReleaseParticleIndex(pfx2)


	enemy:EmitSound("Sven.Bolt_legendary_damage")


	local stun = self:GetCaster():GetTalentValue("modifier_sven_hammer_7", "stun", true)

	if enemy:IsRealHero() and self:GetCaster():GetQuest() == "Sven.Quest_5" then 
		self:GetCaster():UpdateQuest(stun)
	end

	local real_damage = ApplyDamage(  { victim = enemy, attacker = self:GetCaster(), damage = self:GetAbility():GetBoltDamage(enemy)*self:GetAbility().proc_damage, ability = self:GetAbility(), damage_type = damage_type, })
	enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stunned", {duration = stun})

	enemy:SendNumber(4, real_damage)

	mod:DecrementStackCount()
	if mod:GetStackCount() == 0 then 
		mod:Destroy()
	end
end



if not self:GetParent():HasModifier("modifier_sven_hammer_6") then return end
if self:GetAbility():GetCooldownTimeRemaining() == 0 then return end

local cd = self:GetAbility():GetCooldownTimeRemaining()
self:GetAbility():EndCooldown()

self:GetAbility():StartCooldown(cd - self:GetAbility().attack_cd)



end






modifier_sven_storm_bolt_custom_scepter = class({})

function modifier_sven_storm_bolt_custom_scepter:OnDestroy()
	if IsServer() then ResolveNPCPositions( self:GetCaster():GetAbsOrigin(), 256 ) end
end

function modifier_sven_storm_bolt_custom_scepter:CheckState()
return {
		[MODIFIER_STATE_IGNORING_MOVE_AND_ATTACK_ORDERS] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
		}
end

function modifier_sven_storm_bolt_custom_scepter:DeclareFunctions()
	return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION}
end

function modifier_sven_storm_bolt_custom_scepter:GetOverrideAnimation()
	return ACT_DOTA_OVERRIDE_ABILITY_1
end

function modifier_sven_storm_bolt_custom_scepter:IsHidden()
	return true
end

function modifier_sven_storm_bolt_custom_scepter:IsPurgable() return false end


function modifier_sven_storm_bolt_custom_scepter:OnCreated(table)
if not IsServer() then return end
self.pfx = ParticleManager:CreateParticle("particles/items_fx/force_staff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
self:AddParticle(self.pfx, false, false, -1, false, false)

end



function modifier_sven_storm_bolt_custom_scepter:GetStatusEffectName() return "particles/status_fx/status_effect_forcestaff.vpcf" end
function modifier_sven_storm_bolt_custom_scepter:StatusEffectPriority() return 100 end




modifier_sven_storm_bolt_custom_speed = class({})
function modifier_sven_storm_bolt_custom_speed:IsHidden() return false end
function modifier_sven_storm_bolt_custom_speed:IsPurgable() return false end
function modifier_sven_storm_bolt_custom_speed:GetTexture() return "buffs/hammer_speed" end

function modifier_sven_storm_bolt_custom_speed:OnCreated(table)

self.speed = self:GetAbility().speed_inc[self:GetCaster():GetUpgradeStack("modifier_sven_hammer_3")]
self.heal = self:GetAbility().speed_heal[self:GetCaster():GetUpgradeStack("modifier_sven_hammer_3")]
end

function modifier_sven_storm_bolt_custom_speed:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	MODIFIER_EVENT_ON_TAKEDAMAGE,
	MODIFIER_PROPERTY_TOOLTIP
}

end
function modifier_sven_storm_bolt_custom_speed:GetModifierAttackSpeedBonus_Constant()
return self.speed
end

function modifier_sven_storm_bolt_custom_speed:OnTooltip()
return self.heal*100
end

function modifier_sven_storm_bolt_custom_speed:OnTakeDamage(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end
if self:GetParent() == params.unit  then return end
if not params.unit:IsHero() and not params.unit:IsCreep() then return end
if bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then return end
if params.unit:IsIllusion() then return end

local heal = self.heal*params.damage 

if params.unit:IsCreep() then 
	heal = heal*self:GetAbility().speed_creep
end

self:GetParent():GenericHeal(heal, self:GetAbility())

end






modifier_sven_storm_bolt_custom_stun = class({})

function modifier_sven_storm_bolt_custom_stun:IsHidden() return false end
function modifier_sven_storm_bolt_custom_stun:IsStunDebuff() return true end
function modifier_sven_storm_bolt_custom_stun:IsPurgeException() return true end
function modifier_sven_storm_bolt_custom_stun:CheckState()
return
{
	[MODIFIER_STATE_STUNNED] = true
}
end

function modifier_sven_storm_bolt_custom_stun:GetEffectName() return "particles/generic_gameplay/generic_stunned.vpcf"
end

function modifier_sven_storm_bolt_custom_stun:GetEffectAttachType()
return PATTACH_OVERHEAD_FOLLOW
end


function modifier_sven_storm_bolt_custom_stun:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_OVERRIDE_ANIMATION
}
end


function modifier_sven_storm_bolt_custom_stun:GetOverrideAnimation()
return ACT_DOTA_DISABLED
end


function modifier_sven_storm_bolt_custom_stun:OnCreated(table)
if not IsServer() then return end

self.silence = self:GetCaster():GetTalentValue("modifier_sven_hammer_5", "silence")

if self:GetCaster():GetQuest() ~= "Sven.Quest_5" or self:GetCaster():QuestCompleted() then return end
if not self:GetParent():IsRealHero() then return end

self:StartIntervalThink(0.1)
end


function modifier_sven_storm_bolt_custom_stun:OnIntervalThink()
if not IsServer() then return end

self:GetCaster():UpdateQuest(0.1)
end



function modifier_sven_storm_bolt_custom_stun:OnDestroy()
if not IsServer() then return end
if not self:GetCaster():HasModifier("modifier_sven_hammer_5") then return end
if self:GetParent():IsInvulnerable() then return end
if self:GetParent():IsMagicImmune() then return end

self:GetParent():EmitSound("Sf.Raze_Silence")
self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_sven_storm_bolt_custom_silence", {duration = (1 - self:GetParent():GetStatusResistance())*self.silence})
end



modifier_sven_storm_bolt_custom_silence = class({})
function modifier_sven_storm_bolt_custom_silence:IsHidden() return false end
function modifier_sven_storm_bolt_custom_silence:IsPurgable() return true end
function modifier_sven_storm_bolt_custom_silence:GetTexture() return "silencer_last_word" end
function modifier_sven_storm_bolt_custom_silence:CheckState()
return
{
	[MODIFIER_STATE_SILENCED] = true
}
end

function modifier_sven_storm_bolt_custom_silence:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end
function modifier_sven_storm_bolt_custom_silence:GetModifierMoveSpeedBonus_Percentage()
return self.slow 
end


function modifier_sven_storm_bolt_custom_silence:OnCreated()
self.slow = self:GetCaster():GetTalentValue("modifier_sven_hammer_5", "slow")
end 

function modifier_sven_storm_bolt_custom_silence:GetEffectName() return "particles/generic_gameplay/generic_silenced.vpcf" end

function modifier_sven_storm_bolt_custom_silence:ShouldUseOverheadOffset() return true end
function modifier_sven_storm_bolt_custom_silence:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end






modifier_sven_storm_bolt_custom_proc = class({})
function modifier_sven_storm_bolt_custom_proc:IsHidden() return false end
function modifier_sven_storm_bolt_custom_proc:IsPurgable() return false end
function modifier_sven_storm_bolt_custom_proc:GetTexture() return "buffs/hammer_proc" end
function modifier_sven_storm_bolt_custom_proc:GetEffectName() return "particles/lc_odd_proc_hands.vpcf" end
function modifier_sven_storm_bolt_custom_proc:OnCreated(table)
if not IsServer() then return end

local effect_cast = ParticleManager:CreateParticle( "particles/ogre_dd.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
self:AddParticle( effect_cast, false, false, -1, false, false )

self:SetStackCount(self:GetAbility().proc_count[self:GetCaster():GetUpgradeStack("modifier_sven_hammer_4")])
end

function modifier_sven_storm_bolt_custom_proc:OnRefresh(table)
if not IsServer() then return end

self:SetStackCount(self:GetAbility().proc_count[self:GetCaster():GetUpgradeStack("modifier_sven_hammer_4")])
end


modifier_sven_storm_bolt_custom_legendary_stack = class({})
function modifier_sven_storm_bolt_custom_legendary_stack:IsHidden() return false end
function modifier_sven_storm_bolt_custom_legendary_stack:IsPurgable() return false end
function modifier_sven_storm_bolt_custom_legendary_stack:OnCreated(table)
if not IsServer() then return end

self:SetStackCount(1)
self.max = self:GetCaster():GetTalentValue("modifier_sven_hammer_7", "max")
end

function modifier_sven_storm_bolt_custom_legendary_stack:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end

self:IncrementStackCount()
end


function modifier_sven_storm_bolt_custom_legendary_stack:OnStackCountChanged(iStackCount)
if not IsServer() then return end
if self:GetStackCount() == 0 then return end
if not self.effect_cast then 

  local particle_cast = "particles/sven_hammer_stack.vpcf"

  self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
  ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, self:GetStackCount(), 0 ) )

  self:AddParticle(self.effect_cast,false, false, -1, false, false)
else 

  ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, self:GetStackCount(), 0 ) )

end

end
