LinkLuaModifier("modifier_muerta_pierce_the_veil_custom", "abilities/muerta/muerta_pierce_the_veil_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_muerta_pierce_the_veil_custom_tracker", "abilities/muerta/muerta_pierce_the_veil_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_muerta_pierce_the_veil_custom_amp_buff", "abilities/muerta/muerta_pierce_the_veil_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_muerta_pierce_the_veil_custom_scepter_buff", "abilities/muerta/muerta_pierce_the_veil_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_muerta_pierce_the_veil_custom_start", "abilities/muerta/muerta_pierce_the_veil_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_muerta_pierce_the_veil_custom_heal", "abilities/muerta/muerta_pierce_the_veil_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_muerta_pierce_the_veil_custom_slow", "abilities/muerta/muerta_pierce_the_veil_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_muerta_pierce_the_veil_custom_damage", "abilities/muerta/muerta_pierce_the_veil_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_muerta_pierce_the_veil_custom_shard", "abilities/muerta/muerta_pierce_the_veil_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_muerta_pierce_the_veil_custom_attack", "abilities/muerta/muerta_pierce_the_veil_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_muerta_pierce_the_veil_custom_attack_count", "abilities/muerta/muerta_pierce_the_veil_custom", LUA_MODIFIER_MOTION_NONE)


muerta_pierce_the_veil_custom = class({})




function muerta_pierce_the_veil_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end

PrecacheResource( "particle", "particles/sand_king/sand_pull.vpcf", context )
PrecacheResource( "particle", "particles/muerta/muerta_absorb.vpcf", context )
PrecacheResource( "particle", "particles/muerta/muerta_absorb_active.vpcf", context )
PrecacheResource( "particle", "particles/items3_fx/octarine_core_lifesteal.vpcf", context )
PrecacheResource( "particle", "particles/generic_gameplay/generic_lifesteal.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_muerta/muerta_pierce_the_veil_spell_amp_bonus.vpcf", context )
PrecacheResource( "particle", "particles/muerta/muerta_quest_item.vpcf", context )
PrecacheResource( "particle", "particles/muerta/muerta_attack_slow.vpcf", context )
PrecacheResource( "particle", "particles/muerta/muerta_attack_slow.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_muerta/muerta_parting_shot_tether.vpcf", context )

    
end





function muerta_pierce_the_veil_custom:GetCastAnimation()
	return ACT_DOTA_CAST_ABILITY_4
end


function muerta_pierce_the_veil_custom:GetBehavior()

if self:GetCaster():HasTalent("modifier_muerta_veil_6") then 
	return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE
end

return DOTA_ABILITY_BEHAVIOR_NO_TARGET
end




function muerta_pierce_the_veil_custom:GetCooldown(level)
local bonus = 0
if self:GetCaster():HasTalent("modifier_muerta_veil_1") then
    bonus = self:GetCaster():GetTalentValue("modifier_muerta_veil_1", "cd")
end
return self.BaseClass.GetCooldown( self, level ) + bonus
end


function muerta_pierce_the_veil_custom:LegendaryProc()
if not IsServer() then return end

local caster = self:GetCaster()

local cd = caster:GetTalentValue("modifier_muerta_veil_7", "cd_ulti")
local extend = caster:GetTalentValue("modifier_muerta_veil_7", "duration_ulti")

caster:CdAbility(self, cd)

local mod_1 = caster:FindModifierByName("modifier_muerta_pierce_the_veil_buff")
local mod_2 = caster:FindModifierByName("modifier_muerta_pierce_the_veil_custom")

if mod_1 and mod_2 then 
	mod_1:SetDuration(mod_1:GetRemainingTime() + extend, true)
	mod_2:SetDuration(mod_2:GetRemainingTime() + extend, true)
end

end



function muerta_pierce_the_veil_custom:GetIntrinsicModifierName()
return "modifier_muerta_pierce_the_veil"
end

function muerta_pierce_the_veil_custom:GetCastRange(vLocation, hTarget)
if self:GetCaster():HasTalent("modifier_muerta_veil_6") then 
	return self:GetCaster():GetTalentValue("modifier_muerta_veil_6", "radius")
end

return
end


function muerta_pierce_the_veil_custom:OnSpellStart()
if not IsServer() then return end

local caster = self:GetCaster()




local duration = self:GetSpecialValueFor( "duration" ) + caster:GetTalentValue("modifier_muerta_veil_1", "duration")
local transform_duration = self:GetSpecialValueFor( "transform_duration" )


caster:Purge(false, true, false, false, false)
ProjectileManager:ProjectileDodge( caster )

if caster:HasTalent("modifier_muerta_veil_3") then 
	caster:GenericHeal(caster:GetMaxHealth()*caster:GetTalentValue("modifier_muerta_veil_3", "heal")/100, self, nil, nil, "modifier_muerta_veil_3")

	caster:AddNewModifier(caster, self, "modifier_muerta_pierce_the_veil_custom_heal", {duration = caster:GetTalentValue("modifier_muerta_veil_3", "duration")})
end

if caster:HasTalent("modifier_muerta_veil_6") then 
	transform_duration = 0

	caster:StartGesture(ACT_DOTA_CAST_ABILITY_4)

	local radius = caster:GetTalentValue("modifier_muerta_veil_6", "radius")
	local slow_duration = caster:GetTalentValue("modifier_muerta_veil_6", "duration")
	local pull_duration = caster:GetTalentValue("modifier_muerta_veil_6", "pull_duration")

	local effect_cast = ParticleManager:CreateParticle( "particles/sand_king/sand_pull.vpcf", PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, caster:GetAbsOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )


	local units = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, 0, 0, false )

	for _,unit in pairs(units) do

		local dir = (caster:GetAbsOrigin() -  unit:GetAbsOrigin()):Normalized()
		local point = caster:GetAbsOrigin() - dir*100

		local distance = (point - unit:GetAbsOrigin()):Length2D()

		distance = math.max(100, distance)
		point = unit:GetAbsOrigin() + dir*distance

		unit:AddNewModifier(caster, self, "modifier_muerta_pierce_the_veil_custom_slow", {duration = (1 - unit:GetStatusResistance())*slow_duration})
		unit:AddNewModifier( caster,  self,  "modifier_generic_arc",  
		{
		  target_x = point.x,
		  target_y = point.y,
		  distance = distance,
		  duration = pull_duration,
		  height = 0,
		  fix_end = false,
		  isStun = true,
		  activity = ACT_DOTA_FLAIL,
		})
	end
else 
	caster:AddNewModifier(caster, self, "modifier_muerta_pierce_the_veil_custom_start", {duration = transform_duration})
end

caster:AddNewModifier( caster, self, "modifier_muerta_pierce_the_veil_buff", {duration = duration + transform_duration} )
caster:AddNewModifier( caster, self, "modifier_muerta_pierce_the_veil_custom", {duration = duration + transform_duration} )
caster:EmitSound("Hero_Muerta.PierceTheVeil.Cast")
end



modifier_muerta_pierce_the_veil_custom = class({})

function modifier_muerta_pierce_the_veil_custom:IsHidden() return true end
function modifier_muerta_pierce_the_veil_custom:IsPurgable() return false end

function modifier_muerta_pierce_the_veil_custom:OnCreated( kv )

self.parent = self:GetParent()
self.ability = self:GetAbility()
self.caster = self:GetCaster()

self.shard_heal = self.ability:GetSpecialValueFor("shard_lifesteal")
self.shard_heal_creeps = self.ability:GetSpecialValueFor("shard_lifesteal_creeps")

self.fly_move = self.caster:GetTalentValue("modifier_muerta_veil_5", "move")

if not IsServer() then return end

self.parent:AddDamageEvent_out(self)

if self.parent:HasTalent("modifier_muerta_veil_5") then 

	self.blocked = 0

	self.particle = ParticleManager:CreateParticle("particles/muerta/muerta_absorb.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
	ParticleManager:SetParticleControlEnt(self.particle, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
	self:AddParticle(self.particle, false, false, -1, false, false)
end

self.max_time = self:GetRemainingTime()

self.interval = 0.1

local transform_duration = self.ability:GetSpecialValueFor( "transform_duration" )

if self.parent:HasTalent("modifier_muerta_veil_6") then 
	transform_duration = 0
end 

if self.parent:HasTalent("modifier_muerta_veil_4") then 

	local cd_inc = self.caster:GetTalentValue("modifier_muerta_veil_4", "cd_inc")

	for i = 0, 8 do
	    local current_item = self.caster:GetItemInSlot(i)

	    if current_item and not NoCdItems[current_item:GetName()] then  
			local cooldown_mod = self.caster:AddNewModifier(self.caster, self.ability, "modifier_cooldown_speed", {ability = current_item:entindex(), is_item = true, cd_inc = cd_inc})
			local name = self:GetName()

			cooldown_mod:SetEndRule(function()
				return self.caster:HasModifier(name)
			end)
	    end
	end

end


self:StartIntervalThink(transform_duration)
end


function modifier_muerta_pierce_the_veil_custom:OnIntervalThink()
if not IsServer() then return end

if self.parent:HasTalent("modifier_muerta_veil_7") then 
	self.parent:UpdateUIshort({max_time = self.max_time, time = self:GetRemainingTime(), stack = self:GetRemainingTime(), use_zero = 1, style = "MuertaVeil"})
end


if self.parent:HasTalent("modifier_muerta_veil_5") then 
	AddFOWViewer(self.parent:GetTeamNumber(), self.parent:GetAbsOrigin(), self.parent:GetDayTimeVisionRange(), self.interval, false)
end

self:StartIntervalThink(self.interval)
end



function modifier_muerta_pierce_the_veil_custom:GetAbsorbSpell(params) 
if not IsServer() then return end
if not self.parent:HasTalent("modifier_muerta_veil_5") then return end 
if params.ability:GetCaster():GetTeamNumber() == self.parent:GetTeamNumber() then return end
if self.blocked == 1 then return end 

local particle = ParticleManager:CreateParticle("particles/muerta/muerta_absorb_active.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
ParticleManager:SetParticleControlEnt(particle, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
ParticleManager:ReleaseParticleIndex(particle)

if self.particle then 
	ParticleManager:DestroyParticle(self.particle, false)
	ParticleManager:ReleaseParticleIndex(self.particle)
end 

self.blocked = 1

self.parent:EmitSound("DOTA_Item.LinkensSphere.Activate")

return 1 
end


function modifier_muerta_pierce_the_veil_custom:DeclareFunctions()
local funcs = 
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	MODIFIER_PROPERTY_VISUAL_Z_DELTA,
	MODIFIER_PROPERTY_ABSORB_SPELL,
}
return funcs
end



function modifier_muerta_pierce_the_veil_custom:OnDestroy()
if not IsServer() then return end

self.parent:UpdateUIshort({hide = 1, hide_full = 1, style = "MuertaVeil"})
self.parent:AddNewModifier(self.parent, self.ability, "modifier_muerta_pierce_the_veil_custom_shard", {duration = self.ability:GetSpecialValueFor("shard_bonus")})
end


function modifier_muerta_pierce_the_veil_custom:DamageEvent_out(params)
if not IsServer() then return end
if not self.parent:HasShard() then return end
if not self.parent:CheckLifesteal(params, 1) then return end

local heal = self.shard_heal*params.damage/100

if params.unit:IsCreep() then 
	heal = heal/self.shard_heal_creeps
end 

self.parent:GenericHeal(heal, self.ability, true, "particles/items3_fx/octarine_core_lifesteal.vpcf")
end



function modifier_muerta_pierce_the_veil_custom:GetVisualZDelta()
if not self.parent:HasTalent("modifier_muerta_veil_5") then return end
return 50
end

function modifier_muerta_pierce_the_veil_custom:GetModifierMoveSpeedBonus_Percentage()
if not self.parent:HasTalent("modifier_muerta_veil_5") then return end
return self.fly_move
end

function modifier_muerta_pierce_the_veil_custom:CheckState()
if not self.parent:HasTalent("modifier_muerta_veil_5") then return end
return
{
	[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
}
end










modifier_muerta_pierce_the_veil_custom_tracker = class({})
function modifier_muerta_pierce_the_veil_custom_tracker:IsHidden() return true end
function modifier_muerta_pierce_the_veil_custom_tracker:IsPurgable() return false end
function modifier_muerta_pierce_the_veil_custom_tracker:RemoveOnDeath() return false end
function modifier_muerta_pierce_the_veil_custom_tracker:DeclareFunctions()
return
{	
	MODIFIER_PROPERTY_MANACOST_PERCENTAGE_STACKING
}
end

function modifier_muerta_pierce_the_veil_custom_tracker:OnCreated()
self.parent = self:GetParent()
self.parent:AddDeathEvent(self)

self.ability = self:GetAbility()

self.records = {}

self.amp_duration = self.parent:GetTalentValue("modifier_muerta_veil_2", "duration", true)

self.damage_duration = self.parent:GetTalentValue("modifier_muerta_veil_7", "duration", true)

self.attack_radius = self.parent:GetTalentValue("modifier_muerta_veil_4", "radius", true)

self.mana = self.parent:GetTalentValue("modifier_muerta_veil_6", "mana", true)
if not IsServer() then return end 
self.parent:AddAttackEvent_out(self)
self.parent:AddSpellEvent(self)
self.parent:AddAttackStartEvent_out(self)
self.parent:AddRecordDestroyEvent(self)

self:StartIntervalThink(1)
end 


function modifier_muerta_pierce_the_veil_custom_tracker:SpellEvent( params )
if not IsServer() then return end
if params.unit~=self.parent then return end

if self.parent:HasTalent("modifier_muerta_veil_7") then
	self.parent:AddNewModifier(self.parent, self.ability, "modifier_muerta_pierce_the_veil_custom_damage", {duration = self.damage_duration})
	self.ability:LegendaryProc()
end


if self.parent:HasTalent("modifier_muerta_veil_4") and not self.parent:IsInvisible() then

	local target = self.parent:RandomTarget(self.attack_radius)

	if target then 
		self.parent:AddNewModifier(self.parent, self.ability, "modifier_muerta_pierce_the_veil_custom_attack", {duration = FrameTime()})
		self.parent:PerformAttack(target, true, true, true, false, true, false, false)
		self.parent:RemoveModifierByName("modifier_muerta_pierce_the_veil_custom_attack")
	end 
end

end

function modifier_muerta_pierce_the_veil_custom_tracker:AttackStartEvent_out(params)
if not IsServer() then return end 
if not self.parent:HasModifier("modifier_muerta_pierce_the_veil_custom_attack") then return end 
if self.parent ~= params.attacker then return end 

self.records[params.record] = true
end 

function modifier_muerta_pierce_the_veil_custom_tracker:RecordDestroyEvent(params)
if not IsServer() then return end 
if self.parent ~= params.attacker then return end 
if not self.records[params.record] then return end

self.records[params.record] = nil
end 

function modifier_muerta_pierce_the_veil_custom_tracker:DeathEvent(params)
if not IsServer() then return end
if not params.unit:IsHero() then return end

if params.unit:IsValidKill(self.parent) and (self.parent:HasModifier("modifier_muerta_pierce_the_veil_custom") or self.parent:HasModifier("modifier_muerta_pierce_the_veil_custom_shard"))
	and (self.parent == params.attacker or (params.unit:GetAbsOrigin() - self.parent:GetAbsOrigin()):Length2D() <= self.ability:GetSpecialValueFor("scepter_radius")) then 

	self.parent:AddNewModifier(self.parent, self.ability, "modifier_muerta_pierce_the_veil_custom_scepter_buff", {})
end

end



function modifier_muerta_pierce_the_veil_custom_tracker:GetModifierPercentageManacostStacking()
local reduce = 0

if self.parent:HasTalent("modifier_muerta_veil_6") then 
	reduce = self.mana
end

return reduce
end




function modifier_muerta_pierce_the_veil_custom_tracker:AttackEvent_out(params)
if not IsServer() then return end
if self.parent ~= params.attacker then return end

if self.records[params.record] then 
	self.parent:AddNewModifier(self.parent, self.ability, "modifier_muerta_pierce_the_veil_custom_attack_count", {duration = FrameTime()})
end 

if not params.target:IsUnit() then return end
if not self.parent:HasTalent("modifier_muerta_veil_2") then return end

params.target:AddNewModifier(self.parent, self.ability, "modifier_muerta_pierce_the_veil_custom_amp_buff", {duration = self.amp_duration})
self.parent:AddNewModifier(self.parent, self.ability, "modifier_muerta_pierce_the_veil_custom_amp_buff", {duration = self.amp_duration})

end


function modifier_muerta_pierce_the_veil_custom_tracker:OnIntervalThink()
if not IsServer() then return end 

self.parent:RemoveModifierByName("modifier_muerta_pierce_the_veil_spell_amp_boost")
end 



modifier_muerta_pierce_the_veil_custom_amp_buff = class({})
function modifier_muerta_pierce_the_veil_custom_amp_buff:IsHidden() return false end
function modifier_muerta_pierce_the_veil_custom_amp_buff:IsPurgable() return false end
function modifier_muerta_pierce_the_veil_custom_amp_buff:GetTexture() return "buffs/veil_amp" end
function modifier_muerta_pierce_the_veil_custom_amp_buff:OnCreated(table)

self.caster = self:GetCaster()
self.parent = self:GetParent()

self.amp = self.caster:GetTalentValue("modifier_muerta_veil_2", "damage")
self.max = self.caster:GetTalentValue("modifier_muerta_veil_2", "max")

if self.parent ~= self.caster then 
	self.amp = self.amp*-1
end

if not IsServer() then return end

self:SetStackCount(1)
end

function modifier_muerta_pierce_the_veil_custom_amp_buff:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end

self:IncrementStackCount()
end

function modifier_muerta_pierce_the_veil_custom_amp_buff:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE
}
end

function modifier_muerta_pierce_the_veil_custom_amp_buff:GetModifierSpellAmplify_Percentage() 
return self:GetStackCount()*self.amp
end





modifier_muerta_pierce_the_veil_custom_start = class({})
function modifier_muerta_pierce_the_veil_custom_start:IsHidden() return true end
function modifier_muerta_pierce_the_veil_custom_start:IsPurgable() return false end
function modifier_muerta_pierce_the_veil_custom_start:CheckState()
return
{
	[MODIFIER_STATE_STUNNED] = true
}
end





modifier_muerta_pierce_the_veil_custom_heal = class({})
function modifier_muerta_pierce_the_veil_custom_heal:IsHidden() return false end
function modifier_muerta_pierce_the_veil_custom_heal:IsPurgable() return false end
function modifier_muerta_pierce_the_veil_custom_heal:GetTexture() return "buffs/veil_heal" end
function modifier_muerta_pierce_the_veil_custom_heal:OnCreated()

self.caster = self:GetCaster()
self.real_heal = self.caster:GetTalentValue("modifier_muerta_veil_3", "heal")/self:GetRemainingTime()

self.heal = self.real_heal*self.caster:GetMaxHealth()/100

if not IsServer() then return end
self:StartIntervalThink(1)
end


function modifier_muerta_pierce_the_veil_custom_heal:OnIntervalThink()
if not IsServer() then return end

local particle = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.caster )
ParticleManager:ReleaseParticleIndex( particle )

SendOverheadEventMessage(self.caster, 10, self.caster, self.heal, nil)
end


function modifier_muerta_pierce_the_veil_custom_heal:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE
}
end


function modifier_muerta_pierce_the_veil_custom_heal:GetModifierHealthRegenPercentage()
return self.real_heal
end






modifier_muerta_pierce_the_veil_custom_scepter_buff = class({})
function modifier_muerta_pierce_the_veil_custom_scepter_buff:IsHidden() return false end
function modifier_muerta_pierce_the_veil_custom_scepter_buff:IsPurgable() return false end
function modifier_muerta_pierce_the_veil_custom_scepter_buff:RemoveOnDeath() return false end
function modifier_muerta_pierce_the_veil_custom_scepter_buff:OnCreated(table)

self.amp = self:GetAbility():GetSpecialValueFor("shard_amp")
self.max = self:GetAbility():GetSpecialValueFor("shard_max")
if not IsServer() then return end


local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_muerta/muerta_pierce_the_veil_spell_amp_bonus.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
ParticleManager:SetParticleControlEnt(effect_cast, 2, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
ParticleManager:ReleaseParticleIndex( effect_cast )

self:SetStackCount(1)

end


function modifier_muerta_pierce_the_veil_custom_scepter_buff:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end

self:IncrementStackCount()

local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_muerta/muerta_pierce_the_veil_spell_amp_bonus.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
ParticleManager:SetParticleControlEnt(effect_cast, 2, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
ParticleManager:ReleaseParticleIndex( effect_cast )

if self:GetStackCount() >= self.max then 

	local particle_peffect = ParticleManager:CreateParticle("particles/muerta/muerta_quest_item.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	ParticleManager:SetParticleControl(particle_peffect, 0, self:GetCaster():GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_peffect, 2, self:GetCaster():GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(particle_peffect)
	self:GetCaster():EmitSound("Muerta.Quest_item")

end

end

function modifier_muerta_pierce_the_veil_custom_scepter_buff:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
	MODIFIER_PROPERTY_TOOLTIP
}
end

function modifier_muerta_pierce_the_veil_custom_scepter_buff:GetModifierSpellAmplify_Percentage() 
if not self:GetParent():HasShard() then return end
return self:GetStackCount()*self.amp
end


function modifier_muerta_pierce_the_veil_custom_scepter_buff:OnTooltip() 
return self:GetStackCount()
end







modifier_muerta_pierce_the_veil_custom_slow = class({})
function modifier_muerta_pierce_the_veil_custom_slow:IsHidden() return true end
function modifier_muerta_pierce_the_veil_custom_slow:IsPurgable() return true end
function modifier_muerta_pierce_the_veil_custom_slow:GetTexture() return "buffs/gun_slow" end

function modifier_muerta_pierce_the_veil_custom_slow:OnCreated(table)

self.caster = self:GetCaster()
self.parent = self:GetParent()

self.move = self.caster:GetTalentValue("modifier_muerta_veil_6", "slow")
self.pull_duration = self.caster:GetTalentValue("modifier_muerta_veil_6", "pull_duration")
if not IsServer() then return end

local effect_cast = ParticleManager:CreateParticle( "particles/muerta/muerta_attack_slow.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent )
self:AddParticle(effect_cast, false, false, -1, false, false)

effect_cast = ParticleManager:CreateParticle( "particles/muerta/muerta_attack_slow.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent )
self:AddParticle(effect_cast, false, false, -1, false, false)


self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_muerta/muerta_parting_shot_tether.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.caster)
ParticleManager:SetParticleControlEnt( self.particle, 0, self.caster, PATTACH_POINT_FOLLOW, "attach_hitloc", self.caster:GetOrigin(), true )
ParticleManager:SetParticleControlEnt( self.particle, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetOrigin(), true )


self:StartIntervalThink(self.pull_duration)
end


function modifier_muerta_pierce_the_veil_custom_slow:OnIntervalThink()
if not IsServer() then return end
ParticleManager:DestroyParticle(self.particle, false)
ParticleManager:ReleaseParticleIndex(self.particle)
end

function modifier_muerta_pierce_the_veil_custom_slow:OnDestroy()
if not IsServer() then return end
ParticleManager:DestroyParticle(self.particle, false)
ParticleManager:ReleaseParticleIndex(self.particle)
end

function modifier_muerta_pierce_the_veil_custom_slow:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end

function modifier_muerta_pierce_the_veil_custom_slow:GetModifierMoveSpeedBonus_Percentage()
return self.move
end






modifier_muerta_pierce_the_veil_custom_damage = class({})

function modifier_muerta_pierce_the_veil_custom_damage:IsHidden() return false end
function modifier_muerta_pierce_the_veil_custom_damage:IsPurgable() return false end
function modifier_muerta_pierce_the_veil_custom_damage:GetTexture() return "buffs/veil_damage" end
function modifier_muerta_pierce_the_veil_custom_damage:OnCreated(table)

self.caster = self:GetCaster()
self.parent = self:GetParent()

self.damage = self.caster:GetTalentValue("modifier_muerta_veil_7", "damage")

if not IsServer() then return end

self.RemoveForDuel = true
self:AddStack(table.duration)
end


function modifier_muerta_pierce_the_veil_custom_damage:AddStack(duration)
if not IsServer() then return end

self.max_timer = self:GetRemainingTime()

Timers:CreateTimer(duration, function() 
  if self and not self:IsNull() then 
    self:DecrementStackCount()
    if self:GetStackCount() <= 0 then 
      self:Destroy()
    end 
  end 
end)

self:IncrementStackCount()
end 


function modifier_muerta_pierce_the_veil_custom_damage:OnRefresh(table)
if not IsServer() then return end
self:AddStack(table.duration)
end


function modifier_muerta_pierce_the_veil_custom_damage:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
}
end

function modifier_muerta_pierce_the_veil_custom_damage:GetModifierPreAttack_BonusDamage()
return self:GetStackCount()*self.damage
end







modifier_muerta_pierce_the_veil_custom_shard = class({})
function modifier_muerta_pierce_the_veil_custom_shard:IsHidden() return true end
function modifier_muerta_pierce_the_veil_custom_shard:IsPurgable() return false end






modifier_muerta_pierce_the_veil_custom_attack = class({})
function modifier_muerta_pierce_the_veil_custom_attack:IsHidden() return true end
function modifier_muerta_pierce_the_veil_custom_attack:IsPurgable() return false end
function modifier_muerta_pierce_the_veil_custom_attack:OnCreated()
self.damage = self:GetCaster():GetTalentValue("modifier_muerta_veil_4", "damage") - 100

end 

function modifier_muerta_pierce_the_veil_custom_attack:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
}
end


function modifier_muerta_pierce_the_veil_custom_attack:GetModifierDamageOutgoing_Percentage()
if not IsServer() then return end 
return self.damage
end


modifier_muerta_pierce_the_veil_custom_attack_count = class({})
function modifier_muerta_pierce_the_veil_custom_attack_count:IsHidden() return true end
function modifier_muerta_pierce_the_veil_custom_attack_count:IsPurgable() return false end