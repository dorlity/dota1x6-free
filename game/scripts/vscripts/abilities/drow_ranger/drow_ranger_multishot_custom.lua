LinkLuaModifier( "modifier_drow_ranger_multishot_custom", "abilities/drow_ranger/drow_ranger_multishot_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_drow_ranger_multishot_custom_tracker", "abilities/drow_ranger/drow_ranger_multishot_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_drow_ranger_multishot_custom_damage_reduce", "abilities/drow_ranger/drow_ranger_multishot_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_drow_ranger_multishot_custom_armor", "abilities/drow_ranger/drow_ranger_multishot_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_drow_ranger_multishot_custom_speed", "abilities/drow_ranger/drow_ranger_multishot_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_drow_ranger_multishot_custom_damage", "abilities/drow_ranger/drow_ranger_multishot_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_drow_ranger_multishot_custom_heal", "abilities/drow_ranger/drow_ranger_multishot_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_drow_ranger_multishot_custom_combat", "abilities/drow_ranger/drow_ranger_multishot_custom", LUA_MODIFIER_MOTION_NONE )

drow_ranger_multishot_custom = class({})

drow_ranger_multishot_custom.targets = {}


function drow_ranger_multishot_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end
PrecacheResource( "particle", "particles/drow_ranger/multi_cloud.vpcf", context )
PrecacheResource( "particle", "particles/drow_ranger/multi_proj_scepter.vpcf", context )
PrecacheResource( "particle", "particles/drow_ranger/multi_scepter_proc_red_low.vpcf", context )
PrecacheResource( "particle", "particles/drow_ranger/multi_scepter_proc_red.vpcf", context )
PrecacheResource( "particle", "particles/drow_ranger/multi_refresh.vpcf", context )
PrecacheResource( "particle", "particles/drow_ranger/multi_legendary_stack.vpcf", context )
PrecacheResource( "particle", "particles/drow_ranger/multi_block_active.vpcf", context )
PrecacheResource( "particle", "particles/drow_ranger/multi_block.vpcf", context )
PrecacheResource( "particle", "particles/drow_ranger/multi_damage_reduce.vpcf", context )
PrecacheResource( "particle", "particles/drow_ranger/multi_armor.vpcf", context )
PrecacheResource( "particle", "particles/zuus_speed.vpcf", context )

end


function drow_ranger_multishot_custom:GetAbilityTextureName()
if self:GetCaster():HasModifier("modifier_drow_ranger_arcana_custom") then
    return "drow_ranger_multishot_arcana"
end
if self:GetCaster():HasModifier("modifier_drow_ranger_arcana_custom_v2") then
    return "drow_ranger_multishot_arcana_alt1"
end
if self:GetCaster():HasModifier("modifier_drow_eldwurm_head_custom") then
    return "drow_ranger/dragons_touch_ability_icons/drow_ranger_trueshot"
end
return "drow_ranger_multishot"
end


function drow_ranger_multishot_custom:GetIntrinsicModifierName()
if not self:GetCaster():IsRealHero() then return end
return "modifier_drow_ranger_multishot_custom_tracker"
end



function drow_ranger_multishot_custom:GetManaCost(iLevel)
local bonus = 0
if self:GetCaster():HasTalent("modifier_drow_multishot_1") then 
	bonus = self:GetCaster():GetTalentValue("modifier_drow_multishot_1", "mana")
end
return self:GetSpecialValueFor("AbilityManaCost") + bonus
end


function drow_ranger_multishot_custom:GetCooldown(level)
local bonus = 0
if self:GetCaster():HasTalent("modifier_drow_multishot_1") then 
	bonus = self:GetCaster():GetTalentValue("modifier_drow_multishot_1", "cd")
end 
return self.BaseClass.GetCooldown( self, level ) + bonus
end


function drow_ranger_multishot_custom:GetBehavior()
if self:GetCaster():HasShard() then 
	return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_DIRECTIONAL
end 
return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_DIRECTIONAL + DOTA_ABILITY_BEHAVIOR_CHANNELLED
end


function drow_ranger_multishot_custom:GetCastAnimation()
if self:GetCaster():HasShard() then 
	return 0
end 
return ACT_DOTA_CHANNEL_ABILITY_3
end

function drow_ranger_multishot_custom:GetChannelTime()
if self:GetCaster():HasShard() then 
	return 
end 
return self:GetSpecialValueFor("duration") + self:GetCaster():GetTalentValue("modifier_drow_multishot_6", "duration")
end


function drow_ranger_multishot_custom:GetCastRange(vLocation, hTarget)
return self:GetCaster():Script_GetAttackRange() * self:GetSpecialValueFor( "arrow_range_multiplier" ) + self:GetSpecialValueFor( "arrow_width" ) - self:GetCaster():GetCastRangeBonus()
end



function drow_ranger_multishot_custom:OnSpellStart()

local caster = self:GetCaster()
local point = self:GetCursorPosition()

if point == caster:GetAbsOrigin() then 
	point = caster:GetAbsOrigin() + caster:GetForwardVector()*10
end

local duration = self:GetSpecialValueFor("duration") + caster:GetTalentValue("modifier_drow_multishot_6", "duration")
local dir = (point - caster:GetAbsOrigin()):Normalized()
dir.z = 0

caster:FaceTowards(point)
caster:SetForwardVector(dir)

local bonus = 0
local fear = 0

if caster:HasTalent("modifier_drow_multishot_7") then 
	local mod = caster:FindModifierByName("modifier_drow_ranger_multishot_custom_tracker")
	if mod then
		bonus = mod:GetStackCount()
		if bonus >= caster:GetTalentValue("modifier_drow_multishot_7", "max") then 
			fear = 1
		end
		mod:SetStackCount(0)
	end
end 

self.targets = {}
self.modifier = caster:AddNewModifier(caster, self, "modifier_drow_ranger_multishot_custom", {duration = duration, bonus = bonus, fear = fear})
end



function drow_ranger_multishot_custom:OnProjectileHit_ExtraData( target, location, data )
if not target then return end
if self.targets[ target ]==data.wave then return false end

local caster = self:GetCaster()

self.targets[ target ] = data.wave

local damage = (self:GetSpecialValueFor( "arrow_damage_pct" ) + caster:GetTalentValue("modifier_drow_multishot_2", "damage"))/100
local bonus = 0

if data.frost==1 then
	local ability = caster:FindAbilityByName( "drow_ranger_frost_arrows_custom" )
	if ability then
		bonus = bonus + ability:GetDamage(target)
		ability:ApplySlow(target)
	end
end

local damage_type = DAMAGE_TYPE_PHYSICAL

if data.fear == 1 then 
	target:EmitSound("BS.Rupture_fear")
	target:AddNewModifier(caster, nil, "modifier_nevermore_requiem_fear", {duration  = caster:GetTalentValue("modifier_drow_multishot_7", "fear") * (1 - target:GetStatusResistance())})

	damage_type = DAMAGE_TYPE_PURE
	target:EmitSound("Drow.Multi_scepter_proc_damage")
end 


if caster:HasTalent("modifier_drow_multishot_4") then 
	for i = 1,caster:GetTalentValue("modifier_drow_multishot_4", "bonus") do 
		target:AddNewModifier(caster, self, "modifier_drow_ranger_multishot_custom_armor", {duration = caster:GetTalentValue("modifier_drow_multishot_4", "duration")})
	end
end 

local damageTable = {victim = target, attacker = caster, damage = (caster:GetAttackDamage() + bonus)*damage, damage_type = damage_type, ability = self, damage_flags = DOTA_DAMAGE_FLAG_BYPASSES_PHYSICAL_BLOCK }
DoDamage(damageTable)

target:EmitSound("Hero_DrowRanger.ProjectileImpact")

return true
end



function drow_ranger_multishot_custom:OnChannelFinish( bInterrupted )

if not self.modifier:IsNull() then 
	self.modifier:Destroy() 
end

end





modifier_drow_ranger_multishot_custom = class({})
function modifier_drow_ranger_multishot_custom:IsHidden() return false end
function modifier_drow_ranger_multishot_custom:IsPurgable() return false end
function modifier_drow_ranger_multishot_custom:OnCreated( kv )

self.caster = self:GetCaster()
self.ability = self:GetAbility()

local range = self.ability:GetSpecialValueFor( "arrow_range_multiplier" )
self.width = self.ability:GetSpecialValueFor( "arrow_width" )
self.speed = self.ability:GetSpecialValueFor( "arrow_speed" )
self.wave = self.ability:GetSpecialValueFor("wave_count")
self.arrows = self.ability:GetSpecialValueFor( "arrow_count_per_wave" ) + self.caster:GetTalentValue("modifier_drow_multishot_6", "count")
self.duration = self.ability:GetSpecialValueFor("duration")  + self.caster:GetTalentValue("modifier_drow_multishot_6", "duration")
self.scepter_count = self.ability:GetSpecialValueFor("scepter_count")
self.shard_slow = self.ability:GetSpecialValueFor("shard_slow")

local delay = 0.1
self.angle = self.arrows*8.33

self.z_delta = 0
if self.caster:HasShard() then 
	self.z_delta = 40
	self.wave = self.wave + self.ability:GetSpecialValueFor("shard_max")
end 

if not IsServer() then return end

self.ability:EndCd()

self.fear = kv.fear
self.fear_targets = {}

if kv.bonus then 
	self.wave = self.wave + kv.bonus
end 

local anim_k = 0.8 + 0.1*(self.wave - self.ability:GetSpecialValueFor("wave_count"))

self.caster:StartGestureWithPlaybackRate(ACT_DOTA_CHANNEL_ABILITY_3, anim_k)
self.wave_delay = (self.duration - delay)/self.wave

self.current_wave = 0
self.frost = false

local ability = self.caster:FindAbilityByName( "drow_ranger_frost_arrows_custom" )
if ability and ability:GetLevel()>0 then
	self.frost = true
end

if self.caster:HasTalent("modifier_drow_multishot_5") then 
	self.mod = self.caster:AddNewModifier(self.caster, self.ability, "modifier_drow_ranger_multishot_custom_damage_reduce", {})
end 

if self.caster:HasTalent("modifier_drow_multishot_2") then 
	self.damage_mod = self.caster:AddNewModifier(self.caster, self.ability, "modifier_drow_ranger_multishot_custom_damage", {})
end 

if self.caster:HasTalent("modifier_drow_multishot_3") then 
	self.heal_mod = self.caster:AddNewModifier(self.caster, self.ability, "modifier_drow_ranger_multishot_custom_heal", {})
end 

if self.caster:HasShard() then 
	local effect_cast = ParticleManager:CreateParticle( "particles/drow_ranger/multi_cloud.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.caster)
	ParticleManager:SetParticleControl( effect_cast, 0, self.caster:GetAbsOrigin()) 
	self:AddParticle( effect_cast, false, false, -1, false, false )
end


self.info = {
	Source = self.caster,
	Ability = self.ability,

    bDeleteOnHit = true,
    
    iUnitTargetTeam = self.ability:GetAbilityTargetTeam(),
    iUnitTargetType = self.ability:GetAbilityTargetType(),
    iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,

    fDistance = self.caster:Script_GetAttackRange() * range,
    fStartRadius = self.width,
    fEndRadius = self.width,

	bProvidesVision = true,
	iVisionRadius = self.width,
	iVisionTeamNumber = self.caster:GetTeamNumber()
}

self:StartIntervalThink( delay )
self.caster:EmitSound("Hero_DrowRanger.Multishot.Channel")
end




function modifier_drow_ranger_multishot_custom:OnDestroy()
if not IsServer() then return end

self.ability:StartCd()

if self.mod and not self.mod:IsNull() then 
	if self:GetRemainingTime() < 0.1 then 
		self.mod:SetDuration(self.caster:GetTalentValue("modifier_drow_multishot_5", "duration"), true)
	else
		self.mod:Destroy()
	end 
end 

if self.damage_mod and not self.damage_mod:IsNull() then 
	self.damage_mod:SetDuration(self.caster:GetTalentValue("modifier_drow_multishot_2", "duration"), true)
end 

if self.heal_mod and not self.heal_mod:IsNull() then 
	self.heal_mod:SetDuration(self.caster:GetTalentValue("modifier_drow_multishot_3", "duration"), true)
end 

if self.caster:HasTalent("modifier_drow_multishot_4") then 
	self.caster:AddNewModifier(self.caster, self.ability, "modifier_drow_ranger_multishot_custom_speed", {duration = self.caster:GetTalentValue("modifier_drow_multishot_4", "bonus_duration")})
end 


if self.caster:HasTalent("modifier_drow_multishot_6") and self:GetRemainingTime() < 0.1 then
	self.caster:CdItems(self.caster:GetTalentValue("modifier_drow_multishot_6", "cd_items"))

	local particle = ParticleManager:CreateParticle("particles/drow_ranger/multi_refresh.vpcf", PATTACH_CUSTOMORIGIN, self.caster)
	ParticleManager:SetParticleControlEnt( particle, 0, self.caster, PATTACH_POINT_FOLLOW, "attach_hitloc", self.caster:GetOrigin(), true )
	ParticleManager:ReleaseParticleIndex(particle)
end


self.caster:FadeGesture(ACT_DOTA_CHANNEL_ABILITY_3)
self.caster:StopSound("Hero_DrowRanger.Multishot.Channel")
end


function modifier_drow_ranger_multishot_custom:GetEffect()
if not IsServer() then return end 

local projectile_name = ""
local default_effect = "particles/units/heroes/hero_drow/drow_base_attack_linear_proj.vpcf"
local default_frost_effect = "particles/units/heroes/hero_drow/drow_multishot_proj_linear_proj.vpcf"

if self.caster:HasModifier("modifier_drow_ranger_arcana_custom") then
    default_effect = "particles/econ/items/drow/drow_arcana/drow_arcana_multishot_linear_proj_base.vpcf"
    default_frost_effect = "particles/econ/items/drow/drow_arcana/drow_arcana_multishot_linear_proj_frost.vpcf"
end
if self.caster:HasModifier("modifier_drow_ranger_arcana_custom_v2") then
    default_effect = "particles/econ/items/drow/drow_arcana/drow_arcana_v2_multishot_linear_proj_base.vpcf"
    default_frost_effect = "particles/econ/items/drow/drow_arcana/drow_arcana_multishot_linear_proj_frost_v2.vpcf"
end
if self.frost then
    projectile_name = default_frost_effect
else
    projectile_name = default_effect
end

if self.caster:HasShard() then 
    projectile_name = "particles/drow_ranger/multi_proj_scepter.vpcf"

	if self.caster:HasModifier("modifier_drow_ranger_arcana_custom") then
		projectile_name = "particles/drow_ranger/multi_proj_scepter_arcana.vpcf"
	end

	if self.caster:HasModifier("modifier_drow_ranger_arcana_custom_v2") then
		projectile_name = "particles/drow_ranger/multi_proj_scepter_arcana_v2.vpcf"
	end
end


if self.fear == 1 then 
	projectile_name = "particles/drow_ranger/multi_scepter_proc_red_low.vpcf"

	if self.caster:HasShard() then 
		projectile_name = "particles/drow_ranger/multi_scepter_proc_red.vpcf"
	end
end

return projectile_name
end



function modifier_drow_ranger_multishot_custom:OnIntervalThink()
if not IsServer() then return end 
if self.current_wave >= self.wave then return end

self.current_wave = self.current_wave+1

if self.current_wave > 1 then 
	self.fear = 0
end

for i = 1,self.arrows do 

	local info = self.info
	local step = self.angle/(self.arrows-1)
	local angle = -self.angle/2 + (i - 1)*step

	local sound = "Hero_DrowRanger.Multishot.Attack"
	if self.fear == 1 then 
		sound = "Drow.Multi_scepter_proc"
	end 

	self.direction = self.caster:GetForwardVector()
	self.direction.z = 0

	local projectile_direction = RotatePosition( Vector(0,0,0), QAngle( 0, angle, 0 ), self.direction )

	info.EffectName = self:GetEffect()
	info.vSpawnOrigin = self.caster:GetAttachmentOrigin( self.caster:ScriptLookupAttachment( "attach_hitloc" ) ) 

	if not self.caster:HasShard() then 
		info.vSpawnOrigin = info.vSpawnOrigin + Vector(0,0,-50)
	end 

	info.vVelocity = projectile_direction * self.speed
	info.ExtraData = 
	{
		wave = self.current_wave,
		frost = self.frost,
		fear = self.fear
	}

	ProjectileManager:CreateLinearProjectile(info)


	self.caster:EmitSound(sound)
end

self:StartIntervalThink( self.wave_delay - FrameTime() )
end


function modifier_drow_ranger_multishot_custom:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_DISABLE_TURNING,
	MODIFIER_PROPERTY_VISUAL_Z_DELTA,
	MODIFIER_PROPERTY_IGNORE_CAST_ANGLE,
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
}
end

function modifier_drow_ranger_multishot_custom:GetModifierIgnoreCastAngle()
return 1
end

function modifier_drow_ranger_multishot_custom:GetModifierDisableTurning()
return 1
end

function modifier_drow_ranger_multishot_custom:GetVisualZDelta()
return self.z_delta
end

function modifier_drow_ranger_multishot_custom:GetModifierMoveSpeedBonus_Percentage()
if not self.caster:HasShard() then return end 
return self.shard_slow
end

function modifier_drow_ranger_multishot_custom:CheckState()
return
{
	[MODIFIER_STATE_DISARMED] = true
}
end








modifier_drow_ranger_multishot_custom_tracker = class({})
function modifier_drow_ranger_multishot_custom_tracker:IsHidden() return true end
function modifier_drow_ranger_multishot_custom_tracker:IsPurgable() return false end
function modifier_drow_ranger_multishot_custom_tracker:OnCreated()

self.parent = self:GetParent()
self.ability = self:GetAbility()

self.legendary_max = self.parent:GetTalentValue("modifier_drow_multishot_7", "max", true)
self.legendary_spell = self.parent:GetTalentValue("modifier_drow_multishot_7", "spell", true)
self.legendary_attack = self.parent:GetTalentValue("modifier_drow_multishot_7", "attacks", true)
self.legendary_waste = self.parent:GetTalentValue("modifier_drow_multishot_7", "duration", true)
self.legendary_range = self.parent:GetTalentValue("modifier_drow_multishot_7", "range", true)

self.armor_duration = self.parent:GetTalentValue("modifier_drow_multishot_4", "duration", true)

if not IsServer() then return end 

if self.parent:IsRealHero() then 
	self.parent:AddSpellEvent(self)
	self.parent:AddDamageEvent_out(self)
	self.parent:AddDamageEvent_inc(self)
	self.parent:AddAttackEvent_out(self)
end

self.player = PlayerResource:GetPlayer(self.parent:GetPlayerOwnerID())
self:StartIntervalThink(1)
end

function modifier_drow_ranger_multishot_custom_tracker:GetPriority()
return 999998
end

function modifier_drow_ranger_multishot_custom_tracker:OnIntervalThink()
if not IsServer() then return end
if not self.parent:HasTalent("modifier_drow_multishot_7") then return end

if not self.particle then 
	self.particle = ParticleManager:CreateParticle("particles/drow_ranger/multi_legendary_stack.vpcf", PATTACH_OVERHEAD_FOLLOW, self.parent)
	self:AddParticle(self.particle, false, false, -1, false, false)
	self:UpdateParticle()
end


local heroes = FindUnitsInRadius( self.parent:GetTeamNumber(), self.parent:GetAbsOrigin(), nil, self.legendary_range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )

if #heroes > 0 then 
	self.parent:AddNewModifier(self.parent, self.ability, "modifier_drow_ranger_multishot_custom_combat", {duration = self.legendary_waste})
end


if not self.parent:HasModifier("modifier_drow_ranger_multishot_custom_combat") then
    if self:GetStackCount() > 0 then 
        self:DecrementStackCount()
    end
end

self:StartIntervalThink(0.1)
end


function modifier_drow_ranger_multishot_custom_tracker:AttackEvent_out(params)
if not IsServer() then return end
if not self.parent:HasTalent("modifier_drow_multishot_4") then return end 
if not params.target:IsUnit() then return end 
if self.parent ~= params.attacker then return end

params.target:AddNewModifier(self.parent, self.ability, "modifier_drow_ranger_multishot_custom_armor", {duration = self.armor_duration})
end


function modifier_drow_ranger_multishot_custom_tracker:DamageEvent_inc( params )
if not IsServer() then return end
if not self.parent:HasTalent("modifier_drow_multishot_7") then return end
if self.parent ~= params.unit then return end
if not params.attacker:IsUnit() then return end
if (self.parent:GetAbsOrigin() - params.unit:GetAbsOrigin()):Length2D() >= self.legendary_range then return end

self.parent:AddNewModifier(self.parent, self.ability, "modifier_drow_ranger_multishot_custom_combat", {duration = self.legendary_waste})
end

function modifier_drow_ranger_multishot_custom_tracker:DamageEvent_out( params )
if not IsServer() then return end
if not self.parent:HasTalent("modifier_drow_multishot_7") then return end
if self.parent ~= params.attacker then return end
if not params.unit:IsUnit() then return end
if (self.parent:GetAbsOrigin() - params.unit:GetAbsOrigin()):Length2D() >= self.legendary_range then return end
if params.inflictor and (params.inflictor:IsItem() or params.inflictor:GetName() == "generic_aoe_damage") then return end

self.parent:AddNewModifier(self.parent, self.ability, "modifier_drow_ranger_multishot_custom_combat", {duration = self.legendary_waste})
end


function modifier_drow_ranger_multishot_custom_tracker:SpellEvent( params )
if not IsServer() then return end
if params.unit~=self.parent then return end
if self.ability == params.ability then return end
if self.parent:HasModifier("modifier_drow_ranger_multishot_custom") then return end

if not self.parent:HasTalent("modifier_drow_multishot_7") then return end

self:GiveStacks(1)
self.parent:AddNewModifier(self.parent, self.ability, "modifier_drow_ranger_multishot_custom_combat", {duration = self.legendary_waste})
end


function modifier_drow_ranger_multishot_custom_tracker:GiveStacks(count)
if not IsServer() then return end
if self:GetStackCount() >= self.legendary_max then return end

self:SetStackCount(self:GetStackCount() + count)
end


function modifier_drow_ranger_multishot_custom_tracker:OnStackCountChanged(iStackCount)
if not IsServer() then return end
if not self.parent:HasTalent("modifier_drow_multishot_7") then return end

self:UpdateParticle()
self.parent:UpdateUIlong({max = self.legendary_max, stack = self:GetStackCount(), style = "DrowMulti"})
end






function modifier_drow_ranger_multishot_custom_tracker:UpdateParticle()
if not IsServer() then return end
if not self.particle then return end

local max = self.legendary_max
local stack = math.min(math.floor(self:GetStackCount()), max)

for i = 1,max do 
	
	if i <= stack then 
		ParticleManager:SetParticleControl(self.particle, i, Vector(1, 0, 0))	
	else 
		ParticleManager:SetParticleControl(self.particle, i, Vector(0, 0, 0))	
	end
end

end



modifier_drow_ranger_multishot_custom_damage_reduce = class({})
function modifier_drow_ranger_multishot_custom_damage_reduce:IsHidden() return true end
function modifier_drow_ranger_multishot_custom_damage_reduce:IsPurgable() return false end
function modifier_drow_ranger_multishot_custom_damage_reduce:OnCreated()
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.damage_reduce = self.parent:GetTalentValue("modifier_drow_multishot_5", "damage_reduce")
self.block = false

if not IsServer() then return end 

self.particle = ParticleManager:CreateParticle("particles/drow_ranger/multi_block.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
ParticleManager:SetParticleControlEnt(self.particle, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
self:AddParticle(self.particle, false, false, -1, false, false)
end

function modifier_drow_ranger_multishot_custom_damage_reduce:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	MODIFIER_PROPERTY_ABSORB_SPELL
}
end


function modifier_drow_ranger_multishot_custom_damage_reduce:GetModifierIncomingDamage_Percentage()
return self.damage_reduce
end


function modifier_drow_ranger_multishot_custom_damage_reduce:GetAbsorbSpell(params) 
if not IsServer() then return end
if params.ability:GetCaster():GetTeamNumber() == self.parent:GetTeamNumber() then return end
if self.block == true then return end 

local particle = ParticleManager:CreateParticle("particles/drow_ranger/multi_block_active.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
ParticleManager:SetParticleControlEnt(particle, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
ParticleManager:ReleaseParticleIndex(particle)

if self.particle then 
	ParticleManager:DestroyParticle(self.particle, false)
	ParticleManager:ReleaseParticleIndex(self.particle)
end 

self.block = true

self.parent:EmitSound("DOTA_Item.LinkensSphere.Activate")
return 1 
end


function modifier_drow_ranger_multishot_custom_damage_reduce:GetEffectName()
return "particles/drow_ranger/multi_damage_reduce.vpcf"
end

function modifier_drow_ranger_multishot_custom_damage_reduce:GetStatusEffectName()
return "particles/econ/items/drow/drow_ti9_immortal/status_effect_drow_ti9_frost_arrow.vpcf"
end

function modifier_drow_ranger_multishot_custom_damage_reduce:StatusEffectPriority()
return MODIFIER_PRIORITY_HIGH 
end





modifier_drow_ranger_multishot_custom_armor = class({})
function modifier_drow_ranger_multishot_custom_armor:IsHidden() return false end
function modifier_drow_ranger_multishot_custom_armor:IsPurgable() return false end
function modifier_drow_ranger_multishot_custom_armor:GetTexture() return "buffs/multi_armor" end
function modifier_drow_ranger_multishot_custom_armor:OnCreated()
self.caster = self:GetCaster()
self.ability = self:GetAbility()
self.parent = self:GetParent()

self.max = self.caster:GetTalentValue("modifier_drow_multishot_4", "max")
self.armor = self.caster:GetTalentValue("modifier_drow_multishot_4", "armor")/self.max
if not IsServer() then return end 
self:SetStackCount(1)
end

function modifier_drow_ranger_multishot_custom_armor:OnRefresh(table)
if not IsServer() then return end 
if self:GetStackCount() >= self.max then return end 

self:IncrementStackCount()

if self:GetStackCount() >= self.max then 
	self.parent:EmitSound("Item.StarEmblem.Enemy")
	self.particle_peffect = ParticleManager:CreateParticle("particles/drow_ranger/multi_armor.vpcf", PATTACH_OVERHEAD_FOLLOW, self.parent)   
	ParticleManager:SetParticleControl(self.particle_peffect, 0, self.parent:GetAbsOrigin())
	self:AddParticle(self.particle_peffect, false, false, -1, false, true)
end 

end


function modifier_drow_ranger_multishot_custom_armor:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
}
end

function modifier_drow_ranger_multishot_custom_armor:GetModifierPhysicalArmorBonus()
return self:GetStackCount()*self.armor
end





modifier_drow_ranger_multishot_custom_speed = class({})
function modifier_drow_ranger_multishot_custom_speed:IsHidden() return false end
function modifier_drow_ranger_multishot_custom_speed:IsPurgable() return false end
function modifier_drow_ranger_multishot_custom_speed:GetTexture() return "buffs/multi_armor" end
function modifier_drow_ranger_multishot_custom_speed:OnCreated()
self.parent = self:GetParent()
self.speed = self.parent:GetTalentValue("modifier_drow_multishot_4",  "speed")
end

function modifier_drow_ranger_multishot_custom_speed:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
end

function modifier_drow_ranger_multishot_custom_speed:GetModifierAttackSpeedBonus_Constant()
return self.speed
end




modifier_drow_ranger_multishot_custom_damage = class({})
function modifier_drow_ranger_multishot_custom_damage:IsHidden() return true end
function modifier_drow_ranger_multishot_custom_damage:IsPurgable() return false end
function modifier_drow_ranger_multishot_custom_damage:OnCreated()
self.parent = self:GetParent()
self.damage = self.parent:GetTalentValue("modifier_drow_multishot_2",  "bonus")
end

function modifier_drow_ranger_multishot_custom_damage:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE
}
end

function modifier_drow_ranger_multishot_custom_damage:GetModifierBaseAttack_BonusDamage()
return self.damage
end



modifier_drow_ranger_multishot_custom_heal = class({})
function modifier_drow_ranger_multishot_custom_heal:IsHidden() return true end
function modifier_drow_ranger_multishot_custom_heal:IsPurgable() return false end
function modifier_drow_ranger_multishot_custom_heal:OnCreated()
self.parent = self:GetParent()
self.heal = self.parent:GetTalentValue("modifier_drow_multishot_3",  "heal")
self.move = self.parent:GetTalentValue("modifier_drow_multishot_3",  "move")
if not IsServer() then return end 

local effect_cast = ParticleManager:CreateParticle( "particles/zuus_speed.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent )
ParticleManager:SetParticleControl( effect_cast, 0, self.parent:GetAbsOrigin() )
self:AddParticle( effect_cast, false, false, -1, false, false)
end

function modifier_drow_ranger_multishot_custom_heal:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
}
end

function modifier_drow_ranger_multishot_custom_heal:GetModifierHealthRegenPercentage()
return self.heal
end

function modifier_drow_ranger_multishot_custom_heal:GetModifierMoveSpeedBonus_Percentage()
return self.move
end



modifier_drow_ranger_multishot_custom_combat = class({})
function modifier_drow_ranger_multishot_custom_combat:IsHidden() return false end
function modifier_drow_ranger_multishot_custom_combat:IsPurgable() return false end
function modifier_drow_ranger_multishot_custom_combat:IsDebuff() return true end