LinkLuaModifier("modifier_custom_terrorblade_metamorphosis_transform", "abilities/terrorblade/custom_terrorblade_metamorphosis", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_terrorblade_metamorphosis_transform_aura_applier", "abilities/terrorblade/custom_terrorblade_metamorphosis", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_terrorblade_metamorphosis", "abilities/terrorblade/custom_terrorblade_metamorphosis", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_terrorblade_metamorphosis_transform_aura", "abilities/terrorblade/custom_terrorblade_metamorphosis", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_terrorblade_metamorphosis_fear_thinker", "abilities/terrorblade/custom_terrorblade_metamorphosis", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_terrorblade_metamorphosis_ring", "abilities/terrorblade/custom_terrorblade_metamorphosis", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_terrorblade_metamorphosis_fear_cd", "abilities/terrorblade/custom_terrorblade_metamorphosis", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_terrorblade_metamorphosis_lowhp", "abilities/terrorblade/custom_terrorblade_metamorphosis", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_terrorblade_metamorphosis_slow", "abilities/terrorblade/custom_terrorblade_metamorphosis", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_terrorblade_metamorphosis_shield", "abilities/terrorblade/custom_terrorblade_metamorphosis", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_terrorblade_metamorphosis_stats", "abilities/terrorblade/custom_terrorblade_metamorphosis", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_terrorblade_metamorphosis_tracker", "abilities/terrorblade/custom_terrorblade_metamorphosis", LUA_MODIFIER_MOTION_NONE)




custom_terrorblade_metamorphosis = class({})

custom_terrorblade_metamorphosis.bonus_shield = {200, 300, 400}
custom_terrorblade_metamorphosis.bonus_regen = {1, 1.5, 2}

custom_terrorblade_metamorphosis.range_range = 120
custom_terrorblade_metamorphosis.range_slow = -20
custom_terrorblade_metamorphosis.range_duration = 3
custom_terrorblade_metamorphosis.range_aoe = 0.4
custom_terrorblade_metamorphosis.range_radius = 250

custom_terrorblade_metamorphosis.legendary_cd = 3
custom_terrorblade_metamorphosis.legendary_mana = 0.04


custom_terrorblade_metamorphosis.mana_burn = {10, 15, 20}

custom_terrorblade_metamorphosis.fear_duration = 1.5
custom_terrorblade_metamorphosis.fear_range = 800
custom_terrorblade_metamorphosis.fear_cd = 15

custom_terrorblade_metamorphosis.stats_str = {1.5, 2.5}
custom_terrorblade_metamorphosis.stats_agi = {1.5, 2.5}
custom_terrorblade_metamorphosis.stats_attack = {3, 4.5, 6}
custom_terrorblade_metamorphosis.stats_move = {1, 1.5, 2}
custom_terrorblade_metamorphosis.stats_duration = 6
custom_terrorblade_metamorphosis.stats_max = 10


function custom_terrorblade_metamorphosis:Precache(context)

PrecacheResource( "particle", "particles/units/heroes/hero_terrorblade/terrorblade_metamorphosis_transform.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_terrorblade/terrorblade_metamorphosis.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_terrorblade/terrorblade_metamorphosis_base_attack.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_terrorblade/terrorblade_scepter.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_terrorblade/terrorblade_reflection_slow.vpcf", context )
PrecacheResource( "particle", "particles/tb_meta_heal.vpcf", context )
PrecacheResource( "particle", "particles/tb_aoe.vpcf", context )
PrecacheResource( "particle", "particles/items4_fx/bull_whip_buff.vpcf", context )
PrecacheResource( "particle", "particles/econ/events/ti9/phase_boots_ti9.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_vengeful/vengeful_swap_buff_overhead.vpcf", context )
PrecacheResource( "particle", "particles/items2_fx/eternal_shroud.vpcf", context )



end



function custom_terrorblade_metamorphosis:GetIntrinsicModifierName()
if not self:GetCaster():IsRealHero() then return end
return "modifier_custom_terrorblade_metamorphosis_tracker"
end


function custom_terrorblade_metamorphosis:GetManaCost(level)
if self:GetCaster():HasModifier("modifier_custom_terrorblade_metamorphosis") and self:GetCaster():HasModifier("modifier_terror_meta_legendary") then 
	return 0
end


return self.BaseClass.GetManaCost(self,level)
end

function custom_terrorblade_metamorphosis:GetBehavior()
  if self:GetCaster():HasModifier("modifier_terror_meta_legendary") then
    return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_TOGGLE + DOTA_ABILITY_BEHAVIOR_IMMEDIATE end
 return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE 
end


function custom_terrorblade_metamorphosis:GetCooldown(iLevel)
if self:GetCaster():HasModifier("modifier_terror_meta_legendary") then return self.legendary_cd end  
return self.BaseClass.GetCooldown(self, iLevel) 
end

function custom_terrorblade_metamorphosis:ResetToggleOnRespawn()
if self:GetCaster():HasModifier("modifier_terror_meta_legendary") then return true end  
end


function custom_terrorblade_metamorphosis:OnToggle() 
local caster = self:GetCaster()

local mod = self:GetCaster():FindModifierByName("modifier_custom_terrorblade_metamorphosis")
if mod then 
	mod:Destroy()
end

if self:GetToggleState() then
	self:UseMeta(nil,1)
end



self:StartCooldown(self.legendary_cd) 
end





function custom_terrorblade_metamorphosis:OnSpellStart( duration )
if not IsServer() then return end

	self:UseMeta(self:GetSpecialValueFor("duration"), 0)

end


function custom_terrorblade_metamorphosis:UseMeta(duration, hploss)



self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_custom_terrorblade_metamorphosis_transform", {duration = self:GetSpecialValueFor("transformation_time"), meta_duration = duration, hploss = hploss})

for _, unit in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self:GetSpecialValueFor("metamorph_aura_tooltip"), DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO + DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_ANY_ORDER, false)) do
	
	if unit ~= self:GetCaster() and unit:IsIllusion() and unit:GetPlayerOwnerID() == self:GetCaster():GetPlayerOwnerID() and unit:GetName() == self:GetCaster():GetName() then

		unit:AddNewModifier(self:GetCaster(), self, "modifier_custom_terrorblade_metamorphosis_transform", {duration = self:GetSpecialValueFor("transformation_time"), meta_duration = 9999})
			
	end
end


end



modifier_custom_terrorblade_metamorphosis_transform = class({})


function modifier_custom_terrorblade_metamorphosis_transform:IsHidden()	return true end
function modifier_custom_terrorblade_metamorphosis_transform:IsPurgable() return false end

function modifier_custom_terrorblade_metamorphosis_transform:OnCreated(table)
	self.duration	= table.meta_duration
	if not IsServer() then return end
	self.hploss = table.hploss


	self:GetParent():StartGesture(ACT_DOTA_CAST_ABILITY_3)
	self:GetParent():EmitSound("Hero_Terrorblade.Metamorphosis")

	local transform_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_terrorblade/terrorblade_metamorphosis_transform.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:ReleaseParticleIndex(transform_particle)
	
	self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_terrorblade_metamorphosis_transform_aura_applier", {})

end

function modifier_custom_terrorblade_metamorphosis_transform:OnDestroy()
if not IsServer() then return end
if self:GetParent():HasModifier("modifier_final_duel_start") then return end

	if not self:GetParent():IsAlive() then 
		self:GetParent():RemoveModifierByName("modifier_custom_terrorblade_metamorphosis_transform_aura_applier")
	end

	local meta = self:GetParent():FindModifierByName("modifier_custom_terrorblade_metamorphosis")
	if not meta then 
		self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_terrorblade_metamorphosis", {duration = self.duration, hploss = self.hploss})
	else 
		meta:SetDuration(meta:GetRemainingTime() + self.duration, true)
	end
end

function modifier_custom_terrorblade_metamorphosis_transform:CheckState()
	return {[MODIFIER_STATE_STUNNED] = true}
end



modifier_custom_terrorblade_metamorphosis = class({})

function modifier_custom_terrorblade_metamorphosis:IsPurgable() return false end

function modifier_custom_terrorblade_metamorphosis:OnCreated(table)
if not self:GetAbility() then self:Destroy() return end



self.hploss = table.hploss

self.RemoveForDuel = true

self.particle_ally_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_terrorblade/terrorblade_metamorphosis.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
  ParticleManager:SetParticleControl(self.particle_ally_fx, 0, self:GetParent():GetAbsOrigin())
  self:AddParticle(self.particle_ally_fx, false, false, -1, false, false) 

self.bonus_range 	= self:GetAbility():GetSpecialValueFor("bonus_range")

if self:GetParent():HasModifier("modifier_terror_meta_range") then 
	self.bonus_range = self.bonus_range + self:GetAbility().range_range
end


self.bonus_damage	= self:GetAbility():GetSpecialValueFor("bonus_damage")

if not IsServer() then return end

if self:GetParent():HasModifier("modifier_terror_meta_regen") and self:GetParent():IsRealHero() then 
	self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_terrorblade_metamorphosis_shield", {})
end


--self:GetParent():NotifyWearablesOfModelChange(true)

self.previous_attack_cability = self:GetParent():GetAttackCapability()

self:GetParent():SetAttackCapability(DOTA_UNIT_CAP_RANGED_ATTACK)

self:OnIntervalThink()
self:StartIntervalThink(0.5)

end



function modifier_custom_terrorblade_metamorphosis:OnIntervalThink()
if not IsServer() then return end

if self:GetParent():HasModifier("modifier_terror_meta_legendary")  and self.hploss == 1 then 


	if self:GetParent():GetMana() >= self:GetParent():GetMaxMana()*self:GetAbility().legendary_mana*0.5 then 
		self:GetParent():SpendMana(self:GetParent():GetMaxMana()*self:GetAbility().legendary_mana*0.5, self:GetAbility())
	else 
		if self:GetAbility():GetToggleState() then 
  			self:GetAbility():ToggleAbility()
  		end 
	end
end



end

function modifier_custom_terrorblade_metamorphosis:OnDestroy()
if not IsServer() then return end



if ability and self:GetParent():HasModifier("modifier_terror_meta_legendary") then 
		ability:SetActivated(true)
end

self:GetParent():StartGesture(ACT_DOTA_CAST_ABILITY_3_END)

self:GetParent():SetAttackCapability(self.previous_attack_cability)


self:GetParent():RemoveModifierByName("modifier_custom_terrorblade_metamorphosis_transform_aura_applier")
self:GetParent():RemoveModifierByName("modifier_custom_terrorblade_metamorphosis_shield")

end

function modifier_custom_terrorblade_metamorphosis:CheckState()
	if not self:GetAbility() then self:Destroy() return end
end

function modifier_custom_terrorblade_metamorphosis:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MODEL_CHANGE,
	MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND,
	MODIFIER_PROPERTY_PROJECTILE_NAME,

	MODIFIER_EVENT_ON_ATTACK_START,
	MODIFIER_EVENT_ON_ATTACK,

	MODIFIER_PROPERTY_MODEL_SCALE,
	MODIFIER_PROPERTY_ABSORB_SPELL,


	MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
	MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,

	MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE,
	MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,

}
end





function modifier_custom_terrorblade_metamorphosis:GetModifierHealthRegenPercentage()
local regen = 0
if self:GetParent():HasModifier("modifier_terror_meta_regen") then 
	regen = self:GetAbility().bonus_regen[self:GetParent():GetUpgradeStack("modifier_terror_meta_regen")]
end
return regen
end



function modifier_custom_terrorblade_metamorphosis:GetModelScale() return 10 end

function modifier_custom_terrorblade_metamorphosis:GetModifierModelChange()
	return "models/heroes/terrorblade/demon.vmdl"
end

function modifier_custom_terrorblade_metamorphosis:GetAttackSound()
	return "Hero_Terrorblade_Morphed.Attack"
end

function modifier_custom_terrorblade_metamorphosis:GetModifierProjectileName()
	return "particles/units/heroes/hero_terrorblade/terrorblade_metamorphosis_base_attack.vpcf"
end

function modifier_custom_terrorblade_metamorphosis:OnAttackStart(keys)
	if keys.attacker == self:GetParent() then
		self:GetParent():EmitSound("Hero_Terrorblade_Morphed.preAttack")
	end
end

function modifier_custom_terrorblade_metamorphosis:OnAttack(keys)
	if keys.attacker == self:GetParent() then
		self:GetParent():EmitSound("Hero_Terrorblade_Morphed.Attack")
	end
end






function modifier_custom_terrorblade_metamorphosis:GetAbsorbSpell(params)
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_terror_meta_lowhp") then return end
if not params.ability then return end
if not params.ability:GetCaster() then return end
if params.ability:GetCaster() == self:GetParent() then return end
if self:GetParent():HasModifier("modifier_custom_terrorblade_metamorphosis_fear_cd") then return end
if (params.ability:GetCaster():GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D() > self:GetAbility().fear_range then return end
if self:GetParent():PassivesDisabled() then return end

self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_terrorblade_metamorphosis_fear_cd", {duration = self:GetAbility().fear_cd})

local target = params.ability:GetCaster()


local particle = ParticleManager:CreateParticle("particles/items_fx/phylactery_target.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
ParticleManager:SetParticleControlEnt(particle, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
ParticleManager:ReleaseParticleIndex(particle)

local particle_2 = ParticleManager:CreateParticle("particles/items_fx/phylactery.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControlEnt(particle_2, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(particle_2, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
ParticleManager:ReleaseParticleIndex(particle_2)

target:EmitSound("BS.Rupture_fear")
target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_nevermore_requiem_fear", {duration  = self:GetAbility().fear_duration * (1 - target:GetStatusResistance())})



return false
end





function modifier_custom_terrorblade_metamorphosis:GetModifierAttackRangeBonus()
	if self:GetParent():GetName() ~= "npc_dota_hero_rubick" then
		return self.bonus_range
	end
end

function modifier_custom_terrorblade_metamorphosis:GetModifierBaseAttack_BonusDamage()
	return self.bonus_damage
end







modifier_custom_terrorblade_metamorphosis_transform_aura_applier = class({})


function modifier_custom_terrorblade_metamorphosis_transform_aura_applier:OnCreated()
	self.metamorph_aura_tooltip	= self:GetAbility():GetSpecialValueFor("metamorph_aura_tooltip")
end

function modifier_custom_terrorblade_metamorphosis_transform_aura_applier:IsHidden()						return true end

function modifier_custom_terrorblade_metamorphosis_transform_aura_applier:IsAura()						return true end
function modifier_custom_terrorblade_metamorphosis_transform_aura_applier:IsAuraActiveOnDeath() 			return false end

-- "The transformation aura's buff lingers for 1 second."
function modifier_custom_terrorblade_metamorphosis_transform_aura_applier:GetAuraDuration()				return 0.5 end
function modifier_custom_terrorblade_metamorphosis_transform_aura_applier:GetAuraRadius()					return self.metamorph_aura_tooltip end
function modifier_custom_terrorblade_metamorphosis_transform_aura_applier:GetAuraSearchFlags()			return DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD end
function modifier_custom_terrorblade_metamorphosis_transform_aura_applier:GetAuraSearchTeam()				return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_custom_terrorblade_metamorphosis_transform_aura_applier:GetAuraSearchType()				return DOTA_UNIT_TARGET_HERO end
function modifier_custom_terrorblade_metamorphosis_transform_aura_applier:GetModifierAura()				
	return "modifier_custom_terrorblade_metamorphosis_transform_aura" end

function modifier_custom_terrorblade_metamorphosis_transform_aura_applier:GetAuraEntityReject(hTarget)
	return hTarget == self:GetParent() or self:GetParent():IsIllusion() or 
	not hTarget:IsIllusion() or hTarget:GetPlayerOwnerID() ~= self:GetCaster():GetPlayerOwnerID() 
	or (hTarget:HasModifier("modifier_custom_terrorblade_reflection_unit") and hTarget:GetName() ~= self:GetParent():GetName())
end






modifier_custom_terrorblade_metamorphosis_transform_aura = class({})

function modifier_custom_terrorblade_metamorphosis_transform_aura:IsHidden() return true end

function modifier_custom_terrorblade_metamorphosis_transform_aura:OnCreated()
	if not self:GetAbility() then self:Destroy() return end

	if not IsServer() then return end
	
	self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_terrorblade_metamorphosis_transform", {duration = self:GetAbility():GetSpecialValueFor("transformation_time")})
end

function modifier_custom_terrorblade_metamorphosis_transform_aura:OnDestroy()
	if not IsServer() then return end
	
	self:GetParent():RemoveModifierByName("modifier_custom_terrorblade_metamorphosis_transform")
	self:GetParent():RemoveModifierByName("modifier_custom_terrorblade_metamorphosis")
end








custom_terrorblade_terror_wave = class({})


function custom_terrorblade_terror_wave:GetManaCost(level)


if self:GetCaster():HasModifier("modifier_terror_meta_legendary") then 
	return 0
end

return self.BaseClass.GetManaCost(self,level)
end



function custom_terrorblade_terror_wave:GetCastRange(vLocation, hTarget)
if IsClient() then 
	return self:GetSpecialValueFor("range")
else 
	return 99999
end

end




function custom_terrorblade_terror_wave:OnSpellStart(table)
if not IsServer() then return end


local point = self:GetCursorPosition()

local vec = (point - self:GetCaster():GetAbsOrigin())

if vec:Length2D() > self:GetSpecialValueFor("range") + self:GetCaster():GetCastRangeBonus() then 
	point = self:GetCaster():GetAbsOrigin() + vec:Normalized()*(self:GetSpecialValueFor("range") + self:GetCaster():GetCastRangeBonus())
end 

local units =FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO + DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED, FIND_ANY_ORDER, false)

for _,unit in pairs(units) do 

	if (unit == self:GetCaster() or (unit.owner and unit.owner == self:GetCaster() and unit:IsIllusion())) then
		
		unit:AddNewModifier(self:GetCaster(), self, "modifier_custom_terrorblade_metamorphosis_fear_thinker", {x = point.x, y = point.y, duration = self:GetSpecialValueFor("scepter_spawn_delay")})
	end

end 


end









modifier_custom_terrorblade_metamorphosis_fear_thinker = class({})
function modifier_custom_terrorblade_metamorphosis_fear_thinker:IsHidden() return true end
function modifier_custom_terrorblade_metamorphosis_fear_thinker:IsPurgable() return false end



function modifier_custom_terrorblade_metamorphosis_fear_thinker:CheckState()
return
{
	[MODIFIER_STATE_STUNNED] = true,
	[MODIFIER_STATE_OUT_OF_GAME] = true,
	[MODIFIER_STATE_INVULNERABLE] = true,
	[MODIFIER_STATE_NO_HEALTH_BAR] = true,
}
end


function modifier_custom_terrorblade_metamorphosis_fear_thinker:OnCreated(params)
if not IsServer() then return end 

local start_point = self:GetParent():GetAbsOrigin()

ProjectileManager:ProjectileDodge(self:GetParent())

EmitSoundOnLocationWithCaster( start_point, "Hero_Antimage.Blink_out", self:GetParent() )

local effect = ParticleManager:CreateParticle("particles/arc_warden/field_blink_start.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(effect, 0, start_point)

effect = ParticleManager:CreateParticle("particles/items_fx/blink_dagger_start.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(effect, 0, start_point)


self.NoDraw = true

self:GetParent():AddNoDraw()


self.point = Vector(params.x, params.y, 0)

end




function modifier_custom_terrorblade_metamorphosis_fear_thinker:OnDestroy()
if not IsServer() then return end

self:GetParent():RemoveNoDraw()
self:GetParent():Stop()
local final_point = self.point  + RandomVector(self:GetAbility():GetSpecialValueFor("blink_radius"))

local effect = ParticleManager:CreateParticle("particles/items3_fx/blink_arcane_end.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(effect, 0, final_point)

self:GetParent():SetAbsOrigin(final_point)
FindClearSpaceForUnit(self:GetParent(), final_point, true)


if self:GetCaster() == self:GetParent() then 

	self:GetCaster():EmitSound("Hero_Terrorblade.Metamorphosis.Scepter")

	self.radius			= self:GetAbility():GetSpecialValueFor("scepter_radius")
	self.speed			= self:GetAbility():GetSpecialValueFor("scepter_speed")


	self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_terrorblade_metamorphosis_ring", {duration = self.radius/self.speed} )


end



end







modifier_custom_terrorblade_metamorphosis_ring = class({})


function modifier_custom_terrorblade_metamorphosis_ring:IsHidden()
	return true
end

function modifier_custom_terrorblade_metamorphosis_ring:IsDebuff()
	return false
end

function modifier_custom_terrorblade_metamorphosis_ring:IsStunDebuff()
	return false
end

function modifier_custom_terrorblade_metamorphosis_ring:IsPurgable()
	return false
end

function modifier_custom_terrorblade_metamorphosis_ring:RemoveOnDeath()
	return false
end

function modifier_custom_terrorblade_metamorphosis_ring:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end


function modifier_custom_terrorblade_metamorphosis_ring:OnCreated( kv )
if not IsServer() then return end

self.fear_duration	= self:GetAbility():GetSpecialValueFor("fear_duration")
self.radius			= self:GetAbility():GetSpecialValueFor("scepter_radius")
self.speed			= self:GetAbility():GetSpecialValueFor("scepter_speed")

self.effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_terrorblade/terrorblade_scepter.vpcf", PATTACH_WORLDORIGIN, nil )
ParticleManager:SetParticleControl( self.effect_cast, 0, self:GetParent():GetAbsOrigin())
ParticleManager:SetParticleControl( self.effect_cast, 1, Vector(  self.speed, self.speed, self.speed ) )
self:AddParticle(self.effect_cast, false, false, -1, false, false)

self.origin = self:GetParent():GetAbsOrigin()


self.start_radius = 0
self.end_radius = self.radius
self.width = 100
self.outward = self.end_radius>=self.start_radius

if not self.outward then
	self.speed = -self.speed
end

self.IsCircle =  1

self.targets = {}

self:StartIntervalThink( 0.03 )
self:OnIntervalThink()
end



 
function modifier_custom_terrorblade_metamorphosis_ring:OnIntervalThink()

local radius = self.start_radius + self.speed * self:GetElapsedTime()
if not self.outward and radius<self.end_radius then
	self:Destroy()
	return
elseif self.outward and radius>self.end_radius then
	self:Destroy()
	return
end

local targets = FindUnitsInRadius(self:GetParent():GetTeamNumber(),	self.origin, nil, radius,	DOTA_UNIT_TARGET_TEAM_ENEMY,  DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )

local fear_duration = 0
for _,target in pairs(targets) do
	if not self.targets[target] and (target:GetOrigin()-self.origin):Length2D()>(radius-self.width) then

		self.targets[target] = true

		local caster = self:GetParent()
		target:EmitSound("Sf.Aura_Fear")
		
		fear_duration = self.fear_duration*(1 - target:GetStatusResistance())
		target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_terrorblade_fear", {duration = fear_duration})

	end

end


end









modifier_custom_terrorblade_metamorphosis_fear_cd = class({})
function modifier_custom_terrorblade_metamorphosis_fear_cd:IsHidden() return false end
function modifier_custom_terrorblade_metamorphosis_fear_cd:IsPurgable() return false end
function modifier_custom_terrorblade_metamorphosis_fear_cd:RemoveOnDeath() return false end
function modifier_custom_terrorblade_metamorphosis_fear_cd:IsDebuff() return true end
function modifier_custom_terrorblade_metamorphosis_fear_cd:GetTexture() return "buffs/souls_heal_cd" end
function modifier_custom_terrorblade_metamorphosis_fear_cd:OnCreated(table)
self.RemoveForDuel = true
end



modifier_custom_terrorblade_metamorphosis_lowhp = class({})
function modifier_custom_terrorblade_metamorphosis_lowhp:IsHidden() return false end
function modifier_custom_terrorblade_metamorphosis_lowhp:IsPurgable() return true end
function modifier_custom_terrorblade_metamorphosis_lowhp:GetTexture() return "buffs/meta_lowhp" end
function modifier_custom_terrorblade_metamorphosis_lowhp:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
}
end

function modifier_custom_terrorblade_metamorphosis_lowhp:GetModifierIncomingDamage_Percentage()
return self:GetAbility().lowhp_reduce
end

function modifier_custom_terrorblade_metamorphosis_lowhp:OnCreated(table)
if not IsServer() then return end
self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_vengeful/vengeful_swap_buff_overhead.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent())
ParticleManager:SetParticleControlEnt(self.particle, 0, self:GetParent(), PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(self.particle, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(self.particle, 5, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
self:AddParticle(self.particle, false, false, -1, false, false)
end






modifier_custom_terrorblade_metamorphosis_slow = class({})
function modifier_custom_terrorblade_metamorphosis_slow:IsHidden() return false end
function modifier_custom_terrorblade_metamorphosis_slow:IsPurgable() return true end
function modifier_custom_terrorblade_metamorphosis_slow:GetTexture() return "buffs/meta_slow" end
function modifier_custom_terrorblade_metamorphosis_slow:GetEffectName()
	return "particles/units/heroes/hero_terrorblade/terrorblade_reflection_slow.vpcf"
end

function modifier_custom_terrorblade_metamorphosis_slow:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end
function modifier_custom_terrorblade_metamorphosis_slow:GetModifierMoveSpeedBonus_Percentage() return
self:GetAbility().range_slow
end



modifier_custom_terrorblade_metamorphosis_shield = class({})
function modifier_custom_terrorblade_metamorphosis_shield:IsHidden() return true end
function modifier_custom_terrorblade_metamorphosis_shield:IsPurgable() return false end

function modifier_custom_terrorblade_metamorphosis_shield:DeclareFunctions()
return {
    	MODIFIER_PROPERTY_INCOMING_DAMAGE_CONSTANT,

	}
end


function modifier_custom_terrorblade_metamorphosis_shield:OnCreated(table)

self.max_shield = self:GetAbility().bonus_shield[self:GetCaster():GetUpgradeStack("modifier_terror_meta_regen")]

if not IsServer() then return end

self:SetStackCount(self.max_shield)

Timers:CreateTimer(0.3, function() 
	self.effect = ParticleManager:CreateParticle("particles/items2_fx/eternal_shroud.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControlEnt(self.effect, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(self.effect, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(self.effect, 2, Vector(125, 0, 0))
	self:AddParticle(self.effect, false, false, -1, false, false)
end)


end


function modifier_custom_terrorblade_metamorphosis_shield:GetModifierIncomingDamageConstant( params )
if self:GetStackCount() == 0 then return end


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



modifier_custom_terrorblade_metamorphosis_stats = class({})
function modifier_custom_terrorblade_metamorphosis_stats:IsHidden() return false end
function modifier_custom_terrorblade_metamorphosis_stats:IsPurgable() return false end
function modifier_custom_terrorblade_metamorphosis_stats:GetTexture() return "buffs/meta_stats" end
function modifier_custom_terrorblade_metamorphosis_stats:OnCreated()
if not IsServer() then return end
self:SetStackCount(1)

self.agi  = 0
self.str  = 0

self:OnIntervalThink()
self:StartIntervalThink(0.5)
end



function modifier_custom_terrorblade_metamorphosis_stats:OnRefresh(table)
if not IsServer() then return end 
if self:GetStackCount() >= self:GetAbility().stats_max then return end

self:IncrementStackCount()
self:OnIntervalThink()

if self:GetStackCount() >= self:GetAbility().stats_max then 

	self:GetParent():EmitSound("TB.Meta_stack")

	self.particle_ally_fx = ParticleManager:CreateParticle("particles/models/heroes/terrorblade/demon_zeal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
    ParticleManager:SetParticleControl(self.particle_ally_fx, 0, self:GetParent():GetAbsOrigin())
    ParticleManager:SetParticleControl(self.particle_ally_fx, 1, self:GetParent():GetAbsOrigin())
    ParticleManager:SetParticleControl(self.particle_ally_fx, 2, self:GetParent():GetAbsOrigin())
    ParticleManager:SetParticleControl(self.particle_ally_fx, 15, Vector(191, 100, 255))
    ParticleManager:SetParticleControl(self.particle_ally_fx, 16, Vector(1, 0, 0))
    self:AddParticle(self.particle_ally_fx, false, false, -1, false, false) 
end

end




function modifier_custom_terrorblade_metamorphosis_stats:OnIntervalThink()

if self:GetParent():HasModifier("modifier_terror_meta_start")  then

	self.PercentAgi = self:GetAbility().stats_agi[self:GetCaster():GetUpgradeStack("modifier_terror_meta_start")]*self:GetStackCount()/100
	self.PercentStr = self:GetAbility().stats_str[self:GetCaster():GetUpgradeStack("modifier_terror_meta_start")]*self:GetStackCount()/100
end

end




function modifier_custom_terrorblade_metamorphosis_stats:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	MODIFIER_PROPERTY_TOOLTIP,
	MODIFIER_PROPERTY_MODEL_SCALE,
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end


function modifier_custom_terrorblade_metamorphosis_stats:GetModifierModelScale()
if self:GetStackCount() < self:GetAbility().stats_max then return end

return 15
end


function modifier_custom_terrorblade_metamorphosis_stats:OnTooltip()
if not self:GetParent():HasModifier("modifier_terror_meta_start") then return end

return self:GetStackCount()*self:GetAbility().stats_agi[self:GetCaster():GetUpgradeStack("modifier_terror_meta_start")]
end




function modifier_custom_terrorblade_metamorphosis_stats:GetModifierMoveSpeedBonus_Percentage()
if not self:GetParent():HasModifier("modifier_terror_meta_stats") then return end
return  self:GetAbility().stats_move[self:GetParent():GetUpgradeStack("modifier_terror_meta_stats")]*self:GetStackCount()
end

function modifier_custom_terrorblade_metamorphosis_stats:GetModifierAttackSpeedBonus_Constant()
if not self:GetParent():HasModifier("modifier_terror_meta_stats") then return end
return  self:GetAbility().stats_attack[self:GetParent():GetUpgradeStack("modifier_terror_meta_stats")]*self:GetStackCount()
end




modifier_custom_terrorblade_metamorphosis_tracker = class({})
function modifier_custom_terrorblade_metamorphosis_tracker:IsHidden() return true end
function modifier_custom_terrorblade_metamorphosis_tracker:IsPurgable() return false end
function modifier_custom_terrorblade_metamorphosis_tracker:OnCreated()

end 

function modifier_custom_terrorblade_metamorphosis_tracker:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_ATTACK_LANDED,
}
end



function modifier_custom_terrorblade_metamorphosis_tracker:OnAttackLanded(params)
if not IsServer() then return end
if not params.attacker:HasModifier("modifier_custom_terrorblade_metamorphosis") then return end

local attacker = params.attacker
if attacker.owner and attacker:IsIllusion() then 
	attacker = attacker.owner
end 

if attacker ~= self:GetParent() then return end

params.target:EmitSound("Hero_Terrorblade_Morphed.projectileImpact")
if not params.target:IsHero() and not params.target:IsCreep() then return end

if params.attacker:HasModifier("modifier_terror_meta_start") or params.attacker:HasModifier("modifier_terror_meta_stats") then 
	params.attacker:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_terrorblade_metamorphosis_stats", {duration = self:GetAbility().stats_duration})
end

if params.attacker:HasModifier("modifier_terror_meta_range") then

	local damage = self:GetAbility().range_aoe

	local targets = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), params.target:GetAbsOrigin(), nil, self:GetAbility().range_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	if #targets > 1 and params.attacker:IsRealHero() then 

		self.effect_cast = ParticleManager:CreateParticle( "particles/tb_aoe.vpcf", PATTACH_ABSORIGIN_FOLLOW, params.target )
		ParticleManager:SetParticleControl( self.effect_cast, 0, params.target:GetAbsOrigin())
		ParticleManager:SetParticleControl( self.effect_cast, 1, params.target:GetAbsOrigin() )
		ParticleManager:ReleaseParticleIndex(self.effect_cast)


		for _,target in ipairs(targets) do 
			if target ~= params.target then 
				ApplyDamage({victim = target, attacker = params.attacker, ability = self:GetAbility(), damage = params.damage*damage, damage_type = DAMAGE_TYPE_PHYSICAL, damage_flags = DOTA_DAMAGE_FLAG_BYPASSES_BLOCK})
			end
		end	

	end

	params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_terrorblade_metamorphosis_slow", {duration = self:GetAbility().range_duration})
end


if params.attacker:HasModifier("modifier_terror_meta_magic") then 

	local damage = self:GetAbility().mana_burn[self:GetParent():GetUpgradeStack("modifier_terror_meta_magic")]

	params.target:Script_ReduceMana(damage, self:GetAbility()) 

	local particle = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_manaburn.vpcf", PATTACH_ABSORIGIN, params.target )
	ParticleManager:ReleaseParticleIndex( particle )

	self:GetParent():GiveMana(damage)

	ApplyDamage({damage = damage, victim = params.target, attacker = self:GetParent(), ability = self:GetAbility(), damage_type = DAMAGE_TYPE_PURE, })
end 

end



