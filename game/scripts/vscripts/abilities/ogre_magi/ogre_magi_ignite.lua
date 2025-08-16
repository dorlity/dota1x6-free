LinkLuaModifier( "modifier_ogre_magi_ignite_custom", "abilities/ogre_magi/ogre_magi_ignite", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ogre_magi_ignite_custom_count", "abilities/ogre_magi/ogre_magi_ignite", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ogre_magi_ignite_tracker", "abilities/ogre_magi/ogre_magi_ignite", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ogre_magi_ignite_fire", "abilities/ogre_magi/ogre_magi_ignite", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ogre_magi_ignite_fire_legendary_proc", "abilities/ogre_magi/ogre_magi_ignite", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ogre_magi_ignite_fire", "abilities/ogre_magi/ogre_magi_ignite", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ogre_magi_ignite_fire_slow", "abilities/ogre_magi/ogre_magi_ignite", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ogre_magi_ignite_fire_magic", "abilities/ogre_magi/ogre_magi_ignite", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ogre_magi_ignite_fire_status", "abilities/ogre_magi/ogre_magi_ignite", LUA_MODIFIER_MOTION_NONE )

ogre_magi_ignite_custom = class({})



function ogre_magi_ignite_custom:GetAbilityTextureName()
if self:GetCaster() then 
	if self:GetCaster():HasModifier("modifier_ogre_magi_arcana_custom") then
	    return "ogre_magi/arcana/ogre_magi_ignite_arcana"
	end
	if self:GetCaster():HasModifier("modifier_ogre_magi_arcana_custom_2") then
	    return "ogre_magi/arcana/ogre_magi_ignite_arcana_alt1"
	end
end
return "ogre_magi_ignite"
end


function ogre_magi_ignite_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end

PrecacheResource( "particle","particles/units/heroes/hero_ogre_magi/ogre_magi_ignite.vpcf", context )
PrecacheResource( "particle","particles/units/heroes/hero_ogre_magi/ogre_magi_ignite_debuff.vpcf", context )
PrecacheResource( "particle","particles/units/heroes/hero_ogre_magi/ogre_magi_fireblast.vpcf", context )
PrecacheResource( "particle", "particles/status_fx/status_effect_huskar_lifebreak.vpcf", context )  
PrecacheResource( "particle", "particles/ogre_magi/ignite_heal.vpcf", context ) 
end


function ogre_magi_ignite_custom:GetCooldown(iLevel)
local bonus = 0 
if self:GetCaster():HasTalent("modifier_ogremagi_ignite_1") then 
  bonus = self:GetCaster():GetTalentValue("modifier_ogremagi_ignite_1", "cd")
end
return self.BaseClass.GetCooldown(self, iLevel) + bonus
end


function ogre_magi_ignite_custom:GetCastPoint(iLevel)
local bonus = 0
if self:GetCaster():HasTalent("modifier_ogremagi_ignite_6") then 
    bonus = self:GetCaster():GetTalentValue("modifier_ogremagi_ignite_6", "cast")
end
return self.BaseClass.GetCastPoint(self) + bonus
end


function ogre_magi_ignite_custom:GetAOERadius()
return self:GetSpecialValueFor( "aoe_radius" )
end

function ogre_magi_ignite_custom:GetIntrinsicModifierName()
return "modifier_ogre_magi_ignite_tracker"
end

function ogre_magi_ignite_custom:OnSpellStart(new_target)
local caster = self:GetCaster()
local target = self:GetCursorTarget()

if new_target ~= nil then 
	target = new_target
end

if caster:HasTalent("modifier_ogremagi_ignite_3") and not new_target then 
	caster:AddNewModifier(caster, self, "modifier_ogre_magi_ignite_fire_status", {duration = caster:GetTalentValue("modifier_ogremagi_ignite_3", "duration")})
end

if caster:HasTalent("modifier_ogremagi_ignite_6") then 
	local heal = caster:GetMaxHealth()*caster:GetTalentValue("modifier_ogremagi_ignite_6", "cast_heal")/100
	caster:GenericHeal(heal, self, nil, nil, "modifier_ogremagi_ignite_6")
end

local particle_name = "particles/units/heroes/hero_ogre_magi/ogre_magi_ignite.vpcf"
if self:GetCaster():HasModifier("modifier_ogre_magi_arcana_custom") then
    particle_name = "particles/econ/items/ogre_magi/ogre_magi_arcana/ogre_magi_arcana_ignite.vpcf"
elseif self:GetCaster():HasModifier("modifier_ogre_magi_arcana_custom_2") then
    particle_name = "particles/econ/items/ogre_magi/ogre_magi_arcana/ogre_magi_arcana_ignite_secondstyle.vpcf"
end

local info = {
	Target = target,
	Source = caster,
	Ability = self,	
	EffectName = particle_name,
	iMoveSpeed = self:GetSpecialValueFor( "projectile_speed" ),
	bDodgeable = true,
	ExtraData = {}
}

for _,enemy in pairs(caster:FindTargets(self:GetSpecialValueFor("aoe_radius"), target:GetAbsOrigin())) do 
	info.Target = enemy
	ProjectileManager:CreateTrackingProjectile(info)
end

caster:EmitSound("Hero_OgreMagi.Ignite.Cast")
end



function ogre_magi_ignite_custom:OnProjectileHit_ExtraData( target, location, data)
if not target then return end
if target:TriggerSpellAbsorb( self ) then return end

local caster = self:GetCaster()
local duration = self:GetSpecialValueFor("duration")
local duration_inc = self:GetSpecialValueFor("duration_inc")
local duration_max = self:GetSpecialValueFor("duration_max")


if caster:HasTalent("modifier_ogremagi_ignite_4") then 
	target:AddNewModifier(caster, self, "modifier_ogre_magi_ignite_fire_magic", {duration = caster:GetTalentValue("modifier_ogremagi_ignite_4", "duration")})
end
		

if caster:HasTalent("modifier_ogremagi_ignite_5") and not target:IsDebuffImmune() and not target:IsInvulnerable() then
	target:Purge(true, false, false, false, false)
end
 
if caster:HasTalent("modifier_ogremagi_ignite_7") then 
	target:AddNewModifier( caster, self, "modifier_ogre_magi_ignite_custom", { duration = duration } )
	target:AddNewModifier( caster, self, "modifier_ogre_magi_ignite_custom_count", { duration = duration } )
else 
	local mod = target:FindModifierByName("modifier_ogre_magi_ignite_custom")

	if mod then 
		mod:SetDuration(math.min(duration_max, mod:GetRemainingTime() + duration_inc), true)
	else 
		target:AddNewModifier(caster, self, "modifier_ogre_magi_ignite_custom", {duration = duration})
	end
end


target:EmitSound("Hero_OgreMagi.Ignite.Target")
end



function ogre_magi_ignite_custom:EndEffect(target, dispelled)
local caster = self:GetCaster()

if not dispelled then return end 

if caster:HasTalent("modifier_ogremagi_ignite_4") then 
	local damage = caster:GetTalentValue("modifier_ogremagi_ignite_4", "damage")*caster:GetMaxHealth()/100

	local real_damage = DoDamage({victim = target, ability = self, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL}, "modifier_ogremagi_ignite_4")
	target:SendNumber(6, real_damage)

	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_ogre_magi/ogre_magi_fireblast.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControlEnt( particle, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true )
	ParticleManager:SetParticleControl( particle, 1, target:GetOrigin() )
	ParticleManager:ReleaseParticleIndex( particle )
	target:EmitSound("Hero_OgreMagi.Fireblast.Target")
end

if caster:HasTalent("modifier_ogremagi_ignite_5") then 
	target:EmitSound("Sf.Raze_Silence")
	target:AddNewModifier(caster, self, "modifier_ogre_magi_ignite_fire_slow", {duration = (1 - target:GetStatusResistance())*caster:GetTalentValue("modifier_ogremagi_ignite_5", "silence")})
end

end




modifier_ogre_magi_ignite_custom = class({})

function modifier_ogre_magi_ignite_custom:IsPurgable() return true end

function modifier_ogre_magi_ignite_custom:GetAttributes()
if not self.caster or self.caster:IsNull() then return end
if self.caster:HasTalent("modifier_ogremagi_ignite_7") then 
	return MODIFIER_ATTRIBUTE_MULTIPLE
end
	return
end

function modifier_ogre_magi_ignite_custom:IsHidden()
if not self.caster or self.caster:IsNull() then return end
return self.caster:HasTalent("modifier_ogremagi_ignite_7")
end

function modifier_ogre_magi_ignite_custom:OnCreated( kv )
self.caster = self:GetCaster()
self.parent = self:GetParent()
self.ability = self:GetAbility()

if self.caster.owner then 
	self.caster = self.caster.owner
end 

if not self.ability then 
	self:Destroy()
	return
end

self.damage_reduce = self.caster:GetTalentValue("modifier_ogremagi_ignite_2", "damage_reduce")

self.slow = self.ability:GetSpecialValueFor( "slow_movement_speed_pct" ) + self.caster:GetTalentValue("modifier_ogremagi_ignite_2", "slow")
self.damage = self.ability:GetSpecialValueFor( "burn_damage" ) + self.caster:GetTalentValue("modifier_ogremagi_ignite_1", "damage")
self.interval = 1

if not IsServer() then return end

local effect_name = "particles/units/heroes/hero_ogre_magi/ogre_magi_ignite_debuff.vpcf"
if self.caster:HasModifier("modifier_ogre_magi_arcana_custom") then
    effect_name = "particles/econ/items/ogre_magi/ogre_magi_arcana/ogre_magi_arcana_ignite_debuff.vpcf"
elseif self.caster:HasModifier("modifier_ogre_magi_arcana_custom_2") then
    effect_name = "particles/econ/items/ogre_magi/ogre_magi_arcana/ogre_magi_arcana_ignite_secondstyle_debuff.vpcf"
end

local particle = ParticleManager:CreateParticle(effect_name, PATTACH_ABSORIGIN_FOLLOW, self.parent)
self:AddParticle(particle, false, false, -1, false, false)

self.damageTable = {victim = self.parent, attacker = self.caster, damage_type = self.ability:GetAbilityDamageType(), ability = self.ability}
self:StartIntervalThink(self.interval - FrameTime())
end



function modifier_ogre_magi_ignite_custom:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
	MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE
}
end

function modifier_ogre_magi_ignite_custom:GetModifierDamageOutgoing_Percentage()
if self.caster:HasTalent("modifier_ogremagi_ignite_7") then return end
if not self.caster:HasTalent("modifier_ogremagi_ignite_2") then return end 
return self.damage_reduce
end

function modifier_ogre_magi_ignite_custom:GetModifierSpellAmplify_Percentage()
if self.caster:HasTalent("modifier_ogremagi_ignite_7") then return end
if not self.caster:HasTalent("modifier_ogremagi_ignite_2") then return end 
return self.damage_reduce
end


function modifier_ogre_magi_ignite_custom:GetModifierMoveSpeedBonus_Percentage()
if self.caster:HasTalent("modifier_ogremagi_ignite_7") then return end
return self.slow
end


function modifier_ogre_magi_ignite_custom:OnIntervalThink()
if not IsServer() then return end

self.damageTable.damage = self.damage
DoDamage( self.damageTable )

self.parent:EmitSound("Hero_OgreMagi.Ignite.Damage")

if not self.caster or self.caster:IsNull() then 
	return
end



end




function modifier_ogre_magi_ignite_custom:OnDestroy()
if not IsServer() then return end

if not self.caster:HasTalent("modifier_ogremagi_ignite_7") then 
	self.ability:EndEffect(self.parent, self:GetRemainingTime() > 0.1)
end

if self.caster:HasTalent("modifier_ogremagi_ignite_7") then 
	local mod = self.parent:FindModifierByName("modifier_ogre_magi_ignite_custom_count")
	if mod then 
		mod:DecrementStackCount()
		if mod:GetStackCount() == 0 then 
			mod:Destroy()
		end
	end
end

end









modifier_ogre_magi_ignite_custom_count = class({})
function modifier_ogre_magi_ignite_custom_count:IsHidden() return false end
function modifier_ogre_magi_ignite_custom_count:IsPurgable() return true end
function modifier_ogre_magi_ignite_custom_count:OnCreated(table)

self.parent = self:GetParent()
self.caster = self:GetCaster()
self.ability = self:GetAbility()
self.slow = self.ability:GetSpecialValueFor( "slow_movement_speed_pct" ) + self.caster:GetTalentValue("modifier_ogremagi_ignite_2", "slow")

self.damage_reduce = self.caster:GetTalentValue("modifier_ogremagi_ignite_2", "damage_reduce")
if not IsServer() then return end
self:SetStackCount(1)
end

function modifier_ogre_magi_ignite_custom_count:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(self:GetStackCount() + 1)
end

function modifier_ogre_magi_ignite_custom_count:DeclareFunctions()
return 
{
	MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE
}
end

function modifier_ogre_magi_ignite_custom_count:GetModifierDamageOutgoing_Percentage()
if not self.caster:HasTalent("modifier_ogremagi_ignite_2") then return end 
return self.damage_reduce
end

function modifier_ogre_magi_ignite_custom_count:GetModifierSpellAmplify_Percentage()
if not self.caster:HasTalent("modifier_ogremagi_ignite_2") then return end 
return self.damage_reduce
end

function modifier_ogre_magi_ignite_custom_count:GetModifierMoveSpeedBonus_Percentage()
return self.slow
end

function modifier_ogre_magi_ignite_custom_count:OnDestroy()
if not IsServer() then return end
self.ability:EndEffect(self.parent, self:GetRemainingTime() > 0.1)
end







modifier_ogre_magi_ignite_tracker = class({})
function modifier_ogre_magi_ignite_tracker:IsHidden() return true end
function modifier_ogre_magi_ignite_tracker:IsPurgable() return false end

function modifier_ogre_magi_ignite_tracker:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
}
end


function modifier_ogre_magi_ignite_tracker:GetModifierStatusResistanceStacking()
if not self.parent:HasTalent("modifier_ogremagi_ignite_3") then return end 
local status = self.parent:GetTalentValue("modifier_ogremagi_ignite_3", "status")
if self.parent:HasModifier("modifier_ogre_magi_ignite_fire_status") then 
	return status * self.bonus 
end
return status
end


function modifier_ogre_magi_ignite_tracker:GetModifierAttackSpeedBonus_Constant()
if not self.parent:HasTalent("modifier_ogremagi_ignite_3") then return end 
local speed = self.parent:GetTalentValue("modifier_ogremagi_ignite_3", "speed")
if self.parent:HasModifier("modifier_ogre_magi_ignite_fire_status") then 
	return speed * self.bonus 
end
return speed
end


function modifier_ogre_magi_ignite_tracker:OnCreated()
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.bonus = self.parent:GetTalentValue("modifier_ogremagi_ignite_3", "bonus", true)
self.legendary_chance = self.parent:GetTalentValue("modifier_ogremagi_ignite_7", "chance", true)

self.heal = self.parent:GetTalentValue("modifier_ogremagi_ignite_6", "heal", true)/100
self.heal_creeps = self.parent:GetTalentValue("modifier_ogremagi_ignite_6", "creeps", true)

if self.parent:IsRealHero() then 
  	self.parent:AddRecordDestroyEvent(self)
	self.parent:AddAttackRecordEvent_out(self)
	self.parent:AddAttackEvent_out(self)
	self.parent:AddDamageEvent_out(self)
	self.parent:AddAttackStartEvent_out(self)
end
self.records = {}
end


function modifier_ogre_magi_ignite_tracker:DamageEvent_out(params)
if not IsServer() then return end
if not self.parent:HasTalent("modifier_ogremagi_ignite_6") then return end
if not params.unit:IsUnit() then return end
if params.attacker ~= self.parent then return end
if not params.unit:HasModifier("modifier_ogre_magi_ignite_custom") then return end 

local heal = params.damage*self.heal
if params.unit:IsCreep() then 
	heal = heal/self.heal_creeps
end

self.parent:GenericHeal(heal, self.ability, true, "particles/ogre_magi/ignite_heal.vpcf", "modifier_ogremagi_ignite_6")
end


function modifier_ogre_magi_ignite_tracker:AttackEvent_out(params)
if not IsServer() then return end
if not self.parent:HasTalent("modifier_ogremagi_ignite_7") then return end
if not self.records[params.record] then return end 
if params.attacker ~= self.parent then return end
if not params.target:IsUnit() then return end

params.target:EmitSound("Ogre.Ignite_hit")
self.ability:OnSpellStart(params.target)
end

function modifier_ogre_magi_ignite_tracker:AttackRecordEvent_out(params)
if not IsServer() then return end
if not self.parent:HasTalent("modifier_ogremagi_ignite_7") then return end
if not params.target:IsUnit() then return end 
if self.parent ~= params.attacker then return end 

self.parent:RemoveModifierByName("modifier_ogre_magi_ignite_fire_legendary_proc")

local proc = RollPseudoRandomPercentage(self.legendary_chance,3159,self.parent)
if not proc then return end 
self.parent:AddNewModifier(self.parent, self.ability, "modifier_ogre_magi_ignite_fire_legendary_proc", {})
end 

function modifier_ogre_magi_ignite_tracker:AttackStartEvent_out(params)
if not IsServer() then return end 
if not params.target:IsUnit() then return end 
if self.parent ~= params.attacker then return end 
if not self.parent:HasModifier("modifier_ogre_magi_ignite_fire_legendary_proc") then return end

self.records[params.record] = true
self.parent:RemoveModifierByName("modifier_ogre_magi_ignite_fire_legendary_proc")
end

function modifier_ogre_magi_ignite_tracker:RecordDestroyEvent( params )
self.records[params.record] = nil
end

function modifier_ogre_magi_ignite_tracker:CheckState()
if not self.parent:HasModifier("modifier_ogre_magi_ignite_fire_legendary_proc") then return end 
return
{
	[MODIFIER_STATE_CANNOT_MISS] = true
}
end















modifier_ogre_magi_ignite_fire_slow = class({})
function modifier_ogre_magi_ignite_fire_slow:IsHidden() return true end
function modifier_ogre_magi_ignite_fire_slow:IsPurgable() return self:GetElapsedTime() > 0.1 end
function modifier_ogre_magi_ignite_fire_slow:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
end

function modifier_ogre_magi_ignite_fire_slow:OnCreated()
self.attack = self:GetCaster():GetTalentValue("modifier_ogremagi_ignite_5", "attack_slow")
self.slow = self:GetCaster():GetTalentValue("modifier_ogremagi_ignite_5", "slow")
end

function modifier_ogre_magi_ignite_fire_slow:GetModifierMoveSpeedBonus_Percentage()
return self.slow
end

function modifier_ogre_magi_ignite_fire_slow:GetModifierAttackSpeedBonus_Constant()
return self.attack
end

function modifier_ogre_magi_ignite_fire_slow:GetStatusEffectName()
return "particles/status_fx/status_effect_huskar_lifebreak.vpcf"
end

function modifier_ogre_magi_ignite_fire_slow:StatusEffectPriority()
return MODIFIER_PRIORITY_HIGH 
end

function modifier_ogre_magi_ignite_fire_slow:GetEffectName() return "particles/generic_gameplay/generic_silenced.vpcf" end
function modifier_ogre_magi_ignite_fire_slow:ShouldUseOverheadOffset() return true end
function modifier_ogre_magi_ignite_fire_slow:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
function modifier_ogre_magi_ignite_fire_slow:CheckState()
return
{
	[MODIFIER_STATE_SILENCED] = true,
}
end





modifier_ogre_magi_ignite_fire_magic = class({})
function modifier_ogre_magi_ignite_fire_magic:IsHidden() return false end
function modifier_ogre_magi_ignite_fire_magic:IsPurgable() return false end
function modifier_ogre_magi_ignite_fire_magic:GetTexture() return "buffs/ignite_magic" end
function modifier_ogre_magi_ignite_fire_magic:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
}
end


function modifier_ogre_magi_ignite_fire_magic:GetModifierMagicalResistanceBonus()
return self.magic*self:GetStackCount()
end

function modifier_ogre_magi_ignite_fire_magic:OnCreated()
self.caster = self:GetCaster()
self.parent = self:GetParent()

self.magic = self.caster:GetTalentValue("modifier_ogremagi_ignite_4", "magic")
self.max = self.caster:GetTalentValue("modifier_ogremagi_ignite_4", "max")
if not IsServer() then return end 
self.RemoveForDuel = true 
self:SetStackCount(1)
end



function modifier_ogre_magi_ignite_fire_magic:OnRefresh()
if not IsServer() then return end 
if self:GetStackCount() >= self.max then return end 
self:IncrementStackCount()

if self:GetStackCount() >= self.max then 

	local particle = ParticleManager:CreateParticle("particles/econ/items/ogre_magi/ogre_magi_arcana/ogre_magi_arcana_ignite_debuff_explosion.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self.parent)
	ParticleManager:SetParticleControlEnt( particle, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true )
	ParticleManager:SetParticleControlEnt( particle, 3, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true )
	ParticleManager:ReleaseParticleIndex( particle )

	self.parent:EmitSound("Hoodwink.Acorn_armor")

 	self.particle_peffect = ParticleManager:CreateParticle("particles/general/generic_armor_reduction.vpcf", PATTACH_OVERHEAD_FOLLOW, self.parent)	
	ParticleManager:SetParticleControl(self.particle_peffect, 0, self.parent:GetAbsOrigin())
	self:AddParticle(self.particle_peffect, false, false, -1, false, true)

end

end



modifier_ogre_magi_ignite_fire_legendary_proc = class({})
function modifier_ogre_magi_ignite_fire_legendary_proc:IsHidden() return true end
function modifier_ogre_magi_ignite_fire_legendary_proc:IsPurgable() return false end



modifier_ogre_magi_ignite_fire_status = class({})
function modifier_ogre_magi_ignite_fire_status:IsHidden() return false end
function modifier_ogre_magi_ignite_fire_status:IsPurgable() return false end
function modifier_ogre_magi_ignite_fire_status:GetTexture() return "buffs/ignite_tick" end

function modifier_ogre_magi_ignite_fire_status:GetEffectName()
return "particles/items4_fx/ascetic_cap.vpcf" 
end
