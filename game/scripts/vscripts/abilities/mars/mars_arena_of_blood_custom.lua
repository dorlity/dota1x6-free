LinkLuaModifier( "modifier_mars_spear_custom_debuff_knockback", "abilities/mars/mars_spear_custom", LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier( "modifier_mars_arena_of_blood_custom_thinker", "abilities/mars/mars_arena_of_blood_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_mars_arena_of_blood_custom_projectile_aura", "abilities/mars/mars_arena_of_blood_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_mars_arena_of_blood_custom_tracker", "abilities/mars/mars_arena_of_blood_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_mars_arena_of_blood_custom_legendary", "abilities/mars/mars_arena_of_blood_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_mars_arena_of_blood_custom_legendary_stack", "abilities/mars/mars_arena_of_blood_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_mars_arena_of_blood_custom_legendary_slow", "abilities/mars/mars_arena_of_blood_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_mars_arena_of_blood_custom_damage_stack", "abilities/mars/mars_arena_of_blood_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_mars_arena_of_blood_custom_break", "abilities/mars/mars_arena_of_blood_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_mars_arena_of_blood_custom_no_push", "abilities/mars/mars_arena_of_blood_custom", LUA_MODIFIER_MOTION_NONE )

mars_arena_of_blood_custom = class({})


function mars_arena_of_blood_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end

PrecacheResource( "particle", "particles/items3_fx/blink_overwhelming_start.vpcf", context )
PrecacheResource( "particle", "particles/items3_fx/blink_overwhelming_end.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_mars/mars_arena_of_blood.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_oracle/oracle_purifyingflames.vpcf", context )
PrecacheResource( "particle", "particles/roshan_meteor_burn_.vpcf", context )
PrecacheResource( "particle", "particles/items4_fx/ascetic_cap.vpcf", context )
PrecacheResource( "particle", "particles/mars/arena_linken.vpcf", context )
PrecacheResource( "particle", "particles/mars_victory.vpcf", context )
PrecacheResource( "particle", "particles/lc_odd_proc_.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_terrorblade/ember_slow.vpcf", context )
PrecacheResource( "particle", "particles/generic_gameplay/generic_break.vpcf", context )
PrecacheResource( "particle", "particles/mars_revenge_pre.vpcf", context )
PrecacheResource( "particle", "particles/mars_revenge.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_mars/mars_shield_bash_crit.vpcf", context )
PrecacheResource( "particle", "particles/mars_taunt_timer.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_brewmaster/brewmaster_thunder_clap_debuff.vpcf", context )
PrecacheResource( "particle", "particles/status_fx/status_effect_brewmaster_thunder_clap.vpcf", context )

end


function mars_arena_of_blood_custom:CreateTalent(name)
if not IsServer() then return end 

if name == "modifier_mars_arena_7" then 
  self:GetCaster():FindAbilityByName("mars_revenge_custom"):SetHidden(false)
end 

if name == "modifier_mars_arena_6" then 
	self:ToggleAutoCast()
end 

end 

function mars_arena_of_blood_custom:GetAbilityTargetFlags()
if self:GetCaster():HasModifier("modifier_item_ultimate_scepter_consumed") or self:GetCaster():HasModifier("modifier_item_ultimate_scepter") then 
	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
else 
	return DOTA_UNIT_TARGET_FLAG_NONE
end

end

function mars_arena_of_blood_custom:GetCastPoint(iLevel)

if self:GetCaster():HasModifier("modifier_item_ultimate_scepter_consumed") or self:GetCaster():HasModifier("modifier_item_ultimate_scepter") then 
  return self:GetSpecialValueFor("scepter_cast")
end
return self.BaseClass.GetCastPoint(self)
end



function mars_arena_of_blood_custom:GetCastRange(vLocation, hTarget)
local bonus = 0
if self:GetCaster():HasTalent("modifier_mars_arena_6") then 
  bonus = self:GetCaster():GetTalentValue("modifier_mars_arena_6", "range")
end
return self.BaseClass.GetCastRange(self , vLocation , hTarget)  + bonus
end


function mars_arena_of_blood_custom:GetAOERadius()
return self:GetSpecialValueFor( "radius" )
end


function mars_arena_of_blood_custom:GetCooldown(iLevel)
local upgrade_cooldown = 0
if self:GetCaster():HasTalent("modifier_mars_arena_3") then  
  upgrade_cooldown = self:GetCaster():GetTalentValue("modifier_mars_arena_3", "cd")
end 
return self.BaseClass.GetCooldown(self, iLevel) + upgrade_cooldown
end


function mars_arena_of_blood_custom:GetIntrinsicModifierName()
if not self:GetCaster():IsRealHero() then return end
return "modifier_mars_arena_of_blood_custom_tracker"
end

function mars_arena_of_blood_custom:GetBehavior()
local bonus = 0

if self:GetCaster():HasTalent("modifier_mars_arena_6") then 
	bonus = DOTA_ABILITY_BEHAVIOR_AUTOCAST
end 

return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AOE + bonus
end



function mars_arena_of_blood_custom:OnSpellStart()
if not IsServer() then return end
local point = self:GetCursorPosition()
local caster = self:GetCaster()

if caster:HasTalent("modifier_mars_arena_6") and self:GetAutoCastState() == true then 

	local old_pos = caster:GetAbsOrigin()

	local effect = ParticleManager:CreateParticle("particles/items3_fx/blink_overwhelming_start.vpcf", PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(effect, 0, old_pos)
	ParticleManager:ReleaseParticleIndex(effect)

	FindClearSpaceForUnit(caster, point, true)
	ProjectileManager:ProjectileDodge(caster)

	effect = ParticleManager:CreateParticle("particles/items3_fx/blink_overwhelming_end.vpcf", PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(effect, 0, caster:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(effect)

	caster:EmitSound("Mars.Arena_blink_end")
end

CreateModifierThinker( caster, self, "modifier_mars_arena_of_blood_custom_thinker", {}, point, caster:GetTeamNumber(), false )
end






modifier_mars_arena_of_blood_custom_thinker = class({})

function modifier_mars_arena_of_blood_custom_thinker:IsHidden() return true end

function modifier_mars_arena_of_blood_custom_thinker:OnCreated( kv )

self.ability = self:GetAbility()
self.caster = self:GetCaster()
self.parent = self:GetParent()

self.delay = self.ability:GetSpecialValueFor( "formation_time" )
self.duration = self.ability:GetSpecialValueFor( "duration" )
self.radius = self.ability:GetSpecialValueFor( "radius" )

if not IsServer() then return end

self.ability:EndCd()

self.parent.blocked = false

self.parent.radius = self.radius
self.caster.current_arena = self.parent

if self.caster:HasTalent("modifier_mars_arena_3") then 
	self.duration = self.duration + self.caster:GetTalentValue("modifier_mars_arena_3", "duration")
end

self.thinkers = {}
self.phase_delay = true
self:StartIntervalThink( self.delay )
self:PlayEffects()
end



function modifier_mars_arena_of_blood_custom_thinker:OnDestroy()
if not IsServer() then return end

self.ability:StartCd()
self.caster.current_arena = nil

self.parent:EmitSound("Hero_Mars.ArenaOfBlood.End")
StopSoundOn("Hero_Mars.ArenaOfBlood", self.parent)

local modifiers = {}
for k,v in pairs(self.parent:FindAllModifiers()) do
	modifiers[k] = v
end

for k,v in pairs(modifiers) do
	v:Destroy()
end

UTIL_Remove( self.parent ) 
end



function modifier_mars_arena_of_blood_custom_thinker:OnIntervalThink()
if not IsServer() then return end

if self.phase_delay then
	self.phase_delay = false

	if self.caster:HasTalent("modifier_mars_arena_6") then 
		local enemies = FindUnitsInRadius( self.caster:GetTeamNumber(), self.parent:GetOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, 0, false)
		local break_duration = self.caster:GetTalentValue("modifier_mars_arena_6", "break_duration")

		for _,enemy in pairs(enemies) do 
			enemy:AddNewModifier(self.caster, self.ability, "modifier_mars_arena_of_blood_custom_break", {duration = (1 - enemy:GetStatusResistance())*break_duration})
		end 
	end


	AddFOWViewer( self.caster:GetTeamNumber(), self.parent:GetOrigin(), self.radius, self.duration, false)

	self.parent:AddNewModifier(self.caster, self.ability, "modifier_mars_arena_of_blood", {})

	EmitSoundOn("Hero_Mars.ArenaOfBlood", self.parent)


	self.caster:AddNewModifier(	self.caster, self.ability, "modifier_mars_arena_of_blood_custom_no_push", {duration = self.duration})

	self:StartIntervalThink( self.duration )
	self.phase_duration = true
	return
end

if self.phase_duration then
	self:Destroy()
	return
end

end



function modifier_mars_arena_of_blood_custom_thinker:PlayEffects()
local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_mars/mars_arena_of_blood.vpcf", PATTACH_WORLDORIGIN, nil )
ParticleManager:SetParticleControl( particle, 0, self.parent:GetOrigin() )
ParticleManager:SetParticleControl( particle, 1, Vector( self.radius + 50, 0, 0 ) )
ParticleManager:SetParticleControl( particle, 2, self.parent:GetOrigin() )
ParticleManager:SetParticleControl( particle, 3, self.parent:GetOrigin() )
self:AddParticle( particle, false, false, -1, false, false )
self.parent:EmitSound("Hero_Mars.ArenaOfBlood.Start")
end





function modifier_mars_arena_of_blood_custom_thinker:IsAura()
	return true
end

function modifier_mars_arena_of_blood_custom_thinker:GetModifierAura()
	return "modifier_mars_arena_of_blood_custom_projectile_aura"
end

function modifier_mars_arena_of_blood_custom_thinker:GetAuraRadius()
	return self.radius
end

function modifier_mars_arena_of_blood_custom_thinker:GetAuraDuration()
	return 0.3
end

function modifier_mars_arena_of_blood_custom_thinker:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_BOTH
end

function modifier_mars_arena_of_blood_custom_thinker:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP
end

function modifier_mars_arena_of_blood_custom_thinker:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE
end


function modifier_mars_arena_of_blood_custom_thinker:GetAuraEntityReject(hEntity)
return hEntity == self.parent
end







modifier_mars_arena_of_blood_custom_projectile_aura = class({})

function modifier_mars_arena_of_blood_custom_projectile_aura:IsPurgable()
	return false
end

function modifier_mars_arena_of_blood_custom_projectile_aura:OnCreated( kv )
self.width = self:GetAbility():GetSpecialValueFor( "width" )
self.parent = self:GetParent()
self.parent:AddDeathEvent(self)

self.caster = self:GetCaster()
self.ability = self:GetAbility()

self.heal_interval = self.caster:GetTalentValue("modifier_mars_arena_2", "interval")
self.heal = self.caster:GetTalentValue("modifier_mars_arena_2", "damage")*self.heal_interval

self.damage_reduce = self.caster:GetTalentValue("modifier_mars_arena_1", "damage_reduce")
self.heal_reduce = self.caster:GetTalentValue("modifier_mars_arena_1", "heal_reduce")

if not IsServer() then return end

if self.caster:HasTalent("modifier_mars_arena_2")  then 

	local part = "particles/units/heroes/hero_oracle/oracle_purifyingflames.vpcf"

	if self.caster:GetTeamNumber() ~= self.parent:GetTeamNumber() then 
		part = "particles/roshan_meteor_burn_.vpcf"
	end 

	self.particle_peffect = ParticleManager:CreateParticle(part, PATTACH_ABSORIGIN_FOLLOW, self.parent)	
	self:AddParticle(self.particle_peffect, false, false, -1, false, true)
end 

if self.caster:GetTeamNumber() ~= self.parent:GetTeamNumber() then 
		if self.caster:HasTalent("modifier_mars_arena_2")  then 
			self.damageTable = {victim = self.parent, attacker = self.caster, damage = self.heal, damage_type = DAMAGE_TYPE_PURE, ability = self.ability,}
			self:OnIntervalThink()
			self:StartIntervalThink( self.heal_interval )
		end

		if self.caster:HasModifier("modifier_item_ultimate_scepter_consumed") or self.caster:HasModifier("modifier_item_ultimate_scepter") then 
			self.parent:AddNewModifier(self.caster, self.ability, "modifier_mars_arena_of_blood_custom_legendary", {thinker = self:GetAuraOwner():entindex()})
		end
else 
	if self.caster:HasTalent("modifier_mars_arena_5") then 
		self.particle_status = ParticleManager:CreateParticle("particles/items4_fx/ascetic_cap.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)	
		self:AddParticle(self.particle_status, false, false, -1, false, true)

		if self:GetAuraOwner().blocked == false then 
			self.sphere = ParticleManager:CreateParticle("particles/mars/arena_linken.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent )
			ParticleManager:SetParticleControlEnt(self.sphere, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
			self:AddParticle( self.sphere, true, false, -1, false, false )
		end
	end 
end 

end


function modifier_mars_arena_of_blood_custom_projectile_aura:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
	MODIFIER_PROPERTY_ABSORB_SPELL,
	MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
	MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
  MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
  MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
  MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE
}
end

function modifier_mars_arena_of_blood_custom_projectile_aura:GetModifierLifestealRegenAmplify_Percentage()
if self.caster:GetTeamNumber() == self.parent:GetTeamNumber() then return end 
if not self.caster:HasTalent("modifier_mars_arena_1") then return end
return self.heal_reduce
end

function modifier_mars_arena_of_blood_custom_projectile_aura:GetModifierHealAmplify_PercentageTarget()
if self.caster:GetTeamNumber() == self.parent:GetTeamNumber() then return end 
if not self.caster:HasTalent("modifier_mars_arena_1") then return end
return self.heal_reduce
end

function modifier_mars_arena_of_blood_custom_projectile_aura:GetModifierHPRegenAmplify_Percentage()
if self.caster:GetTeamNumber() == self.parent:GetTeamNumber() then return end 
if not self.caster:HasTalent("modifier_mars_arena_1") then return end
return self.heal_reduce
end

function modifier_mars_arena_of_blood_custom_projectile_aura:GetModifierDamageOutgoing_Percentage()
if self.caster:GetTeamNumber() == self.parent:GetTeamNumber() then return end 
if not self.caster:HasTalent("modifier_mars_arena_1") then return end
return self.damage_reduce
end

function modifier_mars_arena_of_blood_custom_projectile_aura:GetModifierSpellAmplify_Percentage()
if self.caster:GetTeamNumber() == self.parent:GetTeamNumber() then return end 
if not self.caster:HasTalent("modifier_mars_arena_1") then return end
return self.damage_reduce
end


function modifier_mars_arena_of_blood_custom_projectile_aura:GetAbsorbSpell(params) 
if not self.parent:HasTalent("modifier_mars_arena_5") then return end
if self.parent ~= self.caster then return end
if self:GetAuraOwner().blocked == true then return end

if not params.ability or not params.ability:GetCaster() then return end
if params.ability:GetCaster():GetTeamNumber() == self.parent:GetTeamNumber() then return end

self:GetAuraOwner().blocked = true

if self.sphere then 
	ParticleManager:DestroyParticle(self.sphere, false)
	ParticleManager:ReleaseParticleIndex(self.sphere)
	self.sphere = nil
end 



self:GetCaster():EmitSound("DOTA_Item.LinkensSphere.Activate")
return 1 
end





function modifier_mars_arena_of_blood_custom_projectile_aura:GetModifierConstantHealthRegen()
if not self.caster:HasTalent("modifier_mars_arena_2") then return end 
if self.caster:GetTeamNumber() ~= self.parent:GetTeamNumber() then return end

return self.heal
end 


function modifier_mars_arena_of_blood_custom_projectile_aura:OnIntervalThink()
if not IsServer() then return end

DoDamage(self.damageTable, "modifier_mars_arena_2")
end



function modifier_mars_arena_of_blood_custom_projectile_aura:DeathEvent(params)
if not IsServer() then return end
if params.unit ~= self.parent then return end
if not self.parent:IsValidKill(self.caster) then return end

if self.caster:IsAlive() and self.caster:HasTalent("modifier_mars_arena_4") then 
	local particle = ParticleManager:CreateParticle("particles/mars_victory.vpcf", PATTACH_OVERHEAD_FOLLOW, self.caster)
	ParticleManager:ReleaseParticleIndex(particle)
	self.caster:EmitSound("UI.Duel_victory")
end

self.caster:AddNewModifier(self.caster, self.ability, "modifier_mars_arena_of_blood_custom_damage_stack", {})
end








modifier_mars_arena_of_blood_custom_tracker = class({})
function modifier_mars_arena_of_blood_custom_tracker:IsHidden() return true end
function modifier_mars_arena_of_blood_custom_tracker:IsPurgable() return false end



function modifier_mars_arena_of_blood_custom_tracker:OnCreated()
self.parent = self:GetParent()

self.status = self.parent:GetTalentValue("modifier_mars_arena_5", "status", true)
self.bonus = self.parent:GetTalentValue("modifier_mars_arena_5", "bonus", true)
end


function modifier_mars_arena_of_blood_custom_tracker:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
	MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
}
end

function modifier_mars_arena_of_blood_custom_tracker:GetModifierStatusResistanceStacking() 
if not self.parent:HasTalent("modifier_mars_arena_5") then return end 
local bonus = self.status
if self.parent:HasModifier("modifier_mars_arena_of_blood_custom_projectile_aura") then 
	bonus = bonus*self.bonus
end 
return bonus
end

function modifier_mars_arena_of_blood_custom_tracker:GetModifierPercentageCooldown()
if not self.parent:HasTalent("modifier_mars_arena_4") then return end
return self.parent:GetTalentValue("modifier_mars_arena_4", "cdr")
end





modifier_mars_arena_of_blood_custom_legendary = class({})
function modifier_mars_arena_of_blood_custom_legendary:IsHidden() return true end
function modifier_mars_arena_of_blood_custom_legendary:IsPurgable() return false end
function modifier_mars_arena_of_blood_custom_legendary:OnCreated(table)
if not IsServer() then return end

self.parent = self:GetParent()
self.RemoveForDuel = true

self.radius = self:GetAbility():GetSpecialValueFor("radius")
self.thinker = EntIndexToHScript(table.thinker)
self:StartIntervalThink(FrameTime())
end

function modifier_mars_arena_of_blood_custom_legendary:OnIntervalThink()
if not IsServer() then return end
if self.parent:IsOutOfGame() then return end
if self.parent:IsInvulnerable() then return end

if not self.thinker or self.thinker:IsNull() then 
	self:Destroy()
	return
end

local abs = self.thinker:GetAbsOrigin()
local dir = self.parent:GetAbsOrigin() - abs
local length = dir:Length2D()

dir.z = 0
dir = dir:Normalized()

if length >= self.radius then 
	local point = abs + dir*self.radius*0.7
	self.parent:SetOrigin(point)
	FindClearSpaceForUnit(self.parent, point, false)
	self.parent:InterruptMotionControllers(false)
	self.parent:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stunned", {duration = 0.2})
end

end







modifier_mars_arena_of_blood_custom_damage_stack = class({})
function modifier_mars_arena_of_blood_custom_damage_stack:IsHidden() return not self:GetParent():HasTalent("modifier_mars_arena_4") end
function modifier_mars_arena_of_blood_custom_damage_stack:IsPurgable() return false end
function modifier_mars_arena_of_blood_custom_damage_stack:RemoveOnDeath() return false end
function modifier_mars_arena_of_blood_custom_damage_stack:GetTexture() return "buffs/arena_damage" end

function modifier_mars_arena_of_blood_custom_damage_stack:OnCreated(table)
self.parent = self:GetParent()
self.max = self.parent:GetTalentValue("modifier_mars_arena_4", "max", true)

if not IsServer() then return end
self:SetStackCount(1)
self:StartIntervalThink(0.5)
end


function modifier_mars_arena_of_blood_custom_damage_stack:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end

self:IncrementStackCount()
end


function modifier_mars_arena_of_blood_custom_damage_stack:OnIntervalThink()
if not IsServer() then return end
if not self.parent:HasTalent("modifier_mars_arena_4") then return end 

if self:GetStackCount() >= self.max then 

	local particle_peffect = ParticleManager:CreateParticle("particles/lc_odd_proc_.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
	ParticleManager:SetParticleControl(particle_peffect, 0, self.parent:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_peffect, 2, self.parent:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(particle_peffect)
	self.parent:EmitSound("BS.Thirst_legendary_active")
 
  self:StartIntervalThink(-1)
end

end 


function modifier_mars_arena_of_blood_custom_damage_stack:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
}
end

function modifier_mars_arena_of_blood_custom_damage_stack:GetModifierPreAttack_BonusDamage()
if not self.parent:HasTalent("modifier_mars_arena_4") then return end
return self:GetStackCount()*self.parent:GetTalentValue("modifier_mars_arena_4", "damage")/self.max
end








modifier_mars_arena_of_blood_custom_break = class({})
function modifier_mars_arena_of_blood_custom_break:IsHidden() return true end
function modifier_mars_arena_of_blood_custom_break:IsPurgable() return false end
function modifier_mars_arena_of_blood_custom_break:OnCreated(table)

self.slow = self:GetCaster():GetTalentValue("modifier_mars_arena_6", "slow")

if not IsServer() then return end
self.parent = self:GetParent()
self.parent:EmitSound("Mars.Arena_break")

local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_terrorblade/ember_slow.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
ParticleManager:SetParticleControl(iParticleID, 0, self.parent:GetAbsOrigin())
self:AddParticle(iParticleID, true, false, -1, false, false)
end

function modifier_mars_arena_of_blood_custom_break:CheckState()
return
{
	[MODIFIER_STATE_PASSIVES_DISABLED] = true,
}
end


function modifier_mars_arena_of_blood_custom_break:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end 

function modifier_mars_arena_of_blood_custom_break:GetModifierMoveSpeedBonus_Percentage()
return self.slow
end 

function modifier_mars_arena_of_blood_custom_break:GetEffectName() return "particles/generic_gameplay/generic_break.vpcf" end

function modifier_mars_arena_of_blood_custom_break:ShouldUseOverheadOffset() return true end
function modifier_mars_arena_of_blood_custom_break:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end









mars_revenge_custom = class({})


function mars_revenge_custom:GetCooldown()
local k = 1
if self:GetCaster():HasModifier("modifier_mars_arena_of_blood_custom_projectile_aura") then 
	k = self:GetCaster():GetTalentValue("modifier_mars_arena_7", "cd_inc")
end 

return self:GetCaster():GetTalentValue("modifier_mars_arena_7", "cd")/k
end


function mars_revenge_custom:GetCastAnimation()
return 0
end

function mars_revenge_custom:OnAbilityPhaseStart()

self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_4, 0.3)
self:GetCaster():EmitSound("Mars.Revenge_pre")
self:GetCaster():EmitSound("Mars.Revenge_pre2")
local timer = self:GetSpecialValueFor("AbilityCastPoint")
local radius = self:GetSpecialValueFor("radius")

self.effect_cast = ParticleManager:CreateParticle("particles/mars_revenge_pre.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
ParticleManager:SetParticleControl( self.effect_cast, 0, self:GetCaster():GetOrigin() )
ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( radius, 0, -radius/timer ))
ParticleManager:SetParticleControl( self.effect_cast, 2, Vector( timer, 0, 0 ) )


return true
end


function mars_revenge_custom:OnAbilityPhaseInterrupted()

self:GetCaster():FadeGesture(ACT_DOTA_CAST_ABILITY_4)

ParticleManager:DestroyParticle(self.effect_cast, true)
ParticleManager:ReleaseParticleIndex(self.effect_cast)
end


function mars_revenge_custom:OnSpellStart()
local caster = self:GetCaster()

caster:RemoveGesture(ACT_DOTA_CAST_ABILITY_4)
caster:StartGesture(ACT_DOTA_CAST_ABILITY_4)

ParticleManager:DestroyParticle(self.effect_cast, true)
ParticleManager:ReleaseParticleIndex(self.effect_cast)

caster:EmitSound("Mars.Revenge_end")
caster:EmitSound("Mars.Revenge_end2")

local damage_inc = caster:GetTalentValue("modifier_mars_arena_7", "damage_inc")/100
local base_damage = caster:GetAverageTrueAttackDamage(nil)*caster:GetTalentValue("modifier_mars_arena_7", "damage")/100
local stack_duration = self:GetSpecialValueFor("duration")
local slow_duration = self:GetSpecialValueFor("slow_duration")
local knock_duration = self:GetSpecialValueFor("knock_duration")
local knock_distance = self:GetSpecialValueFor("knock_distance")
local radius = self:GetSpecialValueFor("radius")

local effect_cast = ParticleManager:CreateParticle( "particles/mars_revenge.vpcf", PATTACH_WORLDORIGIN, caster )
ParticleManager:SetParticleControl( effect_cast, 0, caster:GetOrigin() )
ParticleManager:SetParticleControl( effect_cast, 1, Vector(radius, radius, radius) )
ParticleManager:ReleaseParticleIndex( effect_cast )


for _,enemy in pairs(caster:FindTargets(radius)) do

  local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_mars/mars_shield_bash_crit.vpcf", PATTACH_WORLDORIGIN, enemy )
  ParticleManager:SetParticleControl( effect_cast, 0, enemy:GetOrigin() )
  ParticleManager:SetParticleControl( effect_cast, 1, enemy:GetOrigin() )
  ParticleManager:SetParticleControlForward( effect_cast, 1, (enemy:GetAbsOrigin() - caster:GetAbsOrigin()):Normalized() )
  ParticleManager:ReleaseParticleIndex( effect_cast )

  local damage = base_damage
  local mod = enemy:FindModifierByName("modifier_mars_arena_of_blood_custom_legendary_stack")
  if mod then 
  	damage = damage + caster:GetAverageTrueAttackDamage(nil)*mod:GetStackCount()*damage_inc
  end 

  enemy:EmitSound("Mars.Revenge_end_target")

  DoDamage({ victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self })
  SendOverheadEventMessage(enemy, 6, enemy, damage, nil)

  if caster:HasModifier("modifier_mars_arena_of_blood_custom_projectile_aura") then 
  	local center = caster:GetAbsOrigin()
  	local dir = (enemy:GetAbsOrigin() - center):Normalized()
  	local point = caster:GetAbsOrigin() + dir*knock_distance

		local knockbackProperties =
		{
		  center_x = center.x,
		  center_y = center.y,
		  center_z = center.z,
		  duration = knock_duration,
		  knockback_duration = knock_duration,
		  knockback_distance = (point - enemy:GetAbsOrigin()):Length2D(),
		  knockback_height = 0,
		  should_stun = 0
		}
		enemy:AddNewModifier( caster, self, "modifier_knockback", knockbackProperties )
	end


  enemy:AddNewModifier(caster, self, "modifier_mars_arena_of_blood_custom_legendary_stack", {duration = stack_duration})
  enemy:AddNewModifier(caster, self, "modifier_mars_arena_of_blood_custom_legendary_slow", {duration = slow_duration})
end



end



modifier_mars_arena_of_blood_custom_legendary_stack = class({})
function modifier_mars_arena_of_blood_custom_legendary_stack:IsHidden() return false end
function modifier_mars_arena_of_blood_custom_legendary_stack:IsPurgable() return false end
function modifier_mars_arena_of_blood_custom_legendary_stack:OnCreated(table)
self.RemoveForDuel = true
self.parent = self:GetParent()
self.max = self:GetAbility():GetSpecialValueFor("stack_max")
self:SetStackCount(1)
end

function modifier_mars_arena_of_blood_custom_legendary_stack:OnRefresh()
if not IsServer() then return end 
if self:GetStackCount() >= self.max then return end

self:IncrementStackCount()
end


function modifier_mars_arena_of_blood_custom_legendary_stack:OnStackCountChanged(iStackCount)
if not IsServer() then return end

if not self.effect_cast then 
	self.effect_cast = ParticleManager:CreateParticle( "particles/mars_taunt_timer.vpcf", PATTACH_OVERHEAD_FOLLOW, self.parent )
	self:AddParticle(self.effect_cast,false, false, -1, false, false)
end

ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, self:GetStackCount(), 0 ) )
end




modifier_mars_arena_of_blood_custom_legendary_slow = class({})
function modifier_mars_arena_of_blood_custom_legendary_slow:IsHidden() return true end
function modifier_mars_arena_of_blood_custom_legendary_slow:IsPurgable() return true end
function modifier_mars_arena_of_blood_custom_legendary_slow:OnCreated(table)
self.slow = self:GetAbility():GetSpecialValueFor("slow")
end

function modifier_mars_arena_of_blood_custom_legendary_slow:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end

function modifier_mars_arena_of_blood_custom_legendary_slow:GetModifierMoveSpeedBonus_Percentage()
return self.slow
end

function modifier_mars_arena_of_blood_custom_legendary_slow:GetEffectName()
  return "particles/units/heroes/hero_brewmaster/brewmaster_thunder_clap_debuff.vpcf"
end
function modifier_mars_arena_of_blood_custom_legendary_slow:GetStatusEffectName()
  return "particles/status_fx/status_effect_brewmaster_thunder_clap.vpcf"
end


function modifier_mars_arena_of_blood_custom_legendary_slow:StatusEffectPriority()
  return MODIFIER_PRIORITY_NORMAL 
end



modifier_mars_arena_of_blood_custom_no_push = class({})
function modifier_mars_arena_of_blood_custom_no_push:IsHidden() return true end
function modifier_mars_arena_of_blood_custom_no_push:IsPurgable() return false end
function modifier_mars_arena_of_blood_custom_no_push:RemoveOnDeath() return false end