LinkLuaModifier("modifier_void_spirit_astral_step", "abilities/void_spirit/void_spirit_astral_step_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_void_spirit_astral_step_speed", "abilities/void_spirit/void_spirit_astral_step_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_void_spirit_astral_step_attack", "abilities/void_spirit/void_spirit_astral_step_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_void_spirit_astral_step_tracker", "abilities/void_spirit/void_spirit_astral_step_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_void_spirit_astral_step_count", "abilities/void_spirit/void_spirit_astral_step_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_void_spirit_astral_step_damage", "abilities/void_spirit/void_spirit_astral_step_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_void_spirit_astral_step_stack", "abilities/void_spirit/void_spirit_astral_step_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_void_spirit_astral_step_stack_attack", "abilities/void_spirit/void_spirit_astral_step_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_void_spirit_astral_step_spells", "abilities/void_spirit/void_spirit_astral_step_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_void_spirit_astral_step_spells_max", "abilities/void_spirit/void_spirit_astral_step_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_void_spirit_astral_step_heal", "abilities/void_spirit/void_spirit_astral_step_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_void_spirit_astral_step_status", "abilities/void_spirit/void_spirit_astral_step_custom", LUA_MODIFIER_MOTION_NONE)



void_spirit_astral_step_custom = class({})
void_spirit_astral_step_custom_1 = class({})
void_spirit_astral_step_custom_2 = class({})
void_spirit_astral_step_custom_3 = class({})





function void_spirit_astral_step_custom:Precache(context)

PrecacheResource( "particle", "particles/units/heroes/hero_void_spirit/astral_step/void_spirit_astral_step.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_void_spirit/astral_step/void_spirit_astral_step_impact.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_void_spirit/astral_step/void_spirit_astral_step_debuff.vpcf", context )
PrecacheResource( "particle", "particles/status_fx/status_effect_void_spirit_astral_step_debuff.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_void_spirit/astral_step/void_spirit_astral_step_dmg.vpcf", context )
PrecacheResource( "particle", "particles/void_step_texture.vpcf", context )
PrecacheResource( "particle", "particles/void_step_speed.vpcf", context )
PrecacheResource( "particle", "particles/am_blink_refresh.vpcf", context )
PrecacheResource( "particle", "particles/am_blink_count.vpcf", context )
PrecacheResource( "particle", "particles/bristle_cdr.vpcf", context )
PrecacheResource( "particle", "particles/void_spirit/void_mark_hit.vpcf", context )
PrecacheResource( "particle", "particles/void_spirit/step_spells_mark.vpcf", context )

end

function void_spirit_astral_step_custom:GetIntrinsicModifierName()
return "modifier_void_spirit_astral_step_tracker"
end



function void_spirit_astral_step_custom:AddMark(enemy, damage_k)

local delay = self:GetSpecialValueFor( "pop_damage_delay" )

local damage = 100 
if damage_k then 
	damage = damage_k
end

enemy:AddNewModifier( self:GetCaster(), self, "modifier_void_spirit_astral_step",  { duration = delay, damage = damage } )

local particle_cast = "particles/units/heroes/hero_void_spirit/astral_step/void_spirit_astral_step_impact.vpcf"

local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, enemy )
ParticleManager:ReleaseParticleIndex( effect_cast )
end


function void_spirit_astral_step_custom:OnSpellStart()

if self:GetCaster():IsTempestDouble() then 
	self:SetActivated(false)
end 

self:CastSpell(self:GetCaster(), self:GetCursorPosition())
end




function void_spirit_astral_step_custom:GiveCharge()

local particle = ParticleManager:CreateParticle("particles/am_blink_refresh.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster())
ParticleManager:SetParticleControlEnt( particle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetOrigin(), true )
ParticleManager:ReleaseParticleIndex(particle)

local ability = self

if self:GetCaster():HasModifier("modifier_void_step_2") then 
	local n = self:GetCaster():FindModifierByName("modifier_void_step_2"):GetStackCount()
	ability = self:GetCaster():FindAbilityByName("void_spirit_astral_step_custom_"..n)
end
	
if ability:GetCurrentAbilityCharges() ~= 2 then 

	if ability:GetCurrentAbilityCharges() == 0 then 
		ability:SetCurrentAbilityCharges(ability:GetCurrentAbilityCharges() + 1)
	else 
		if ability:GetCurrentAbilityCharges() == 1 then 
			ability:RefreshCharges()
		end
	end

end


self:GetCaster():EmitSound("Antimage.Blink_refresh")
end



function void_spirit_astral_step_custom:CastSpell(caster, point)

local origin = caster:GetOrigin()

local mod = caster:FindModifierByName("modifier_void_spirit_astral_replicant")
if mod then 
	mod:SetPoint(caster:GetAbsOrigin())
end

local max_dist = self:GetSpecialValueFor( "max_travel_distance" )
local min_dist = self:GetSpecialValueFor( "min_travel_distance" )


if point == origin then 
	point = self:GetCaster():GetAbsOrigin() + self:GetCaster():GetForwardVector()*10
end

local vec = (point - caster:GetAbsOrigin())

if vec:Length2D() > max_dist + caster:GetCastRangeBonus() then 
	point = caster:GetAbsOrigin() + vec:Normalized()*(max_dist + caster:GetCastRangeBonus())
else 
	if vec:Length2D() < min_dist then 
		point = caster:GetAbsOrigin() + vec:Normalized()*min_dist
	end
end

local damage = 100
if self:GetCaster():HasModifier("modifier_void_spirit_astral_replicant") then 
	damage = (100 - self:GetCaster():GetTalentValue("modifier_void_step_legendary", "damage"))
end 


self:Strike(point, damage)

end


function void_spirit_astral_step_custom:Strike(point, damage_k)

local caster = self:GetCaster()
local origin = self:GetCaster():GetAbsOrigin()
local radius = self:GetSpecialValueFor( "radius" )

if self:GetCaster():HasModifier("modifier_void_step_6") then 
	ProjectileManager:ProjectileDodge(self:GetCaster())
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_void_spirit_astral_step_status", {duration = self:GetCaster():GetTalentValue("modifier_void_step_6", "duration")})
end

local target = GetGroundPosition( point, nil )

local sound_start = "Hero_VoidSpirit.AstralStep.Start"
local sound_end = "Hero_VoidSpirit.AstralStep.End"

self:GetCaster():EmitSound(sound_start)

FindClearSpaceForUnit( caster, target, true )

self:GetCaster():EmitSound(sound_end)

if self:GetCaster():HasModifier("modifier_void_step_3") then 
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_void_spirit_astral_step_heal", {duration = self:GetCaster():GetTalentValue("modifier_void_step_3", "duration")})
end



local damage = 100

if damage_k then 
	damage = damage_k
end


local enemies = FindUnitsInLine( caster:GetTeamNumber(), origin, target, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES )

local attack_mod = caster:AddNewModifier(caster, self, "modifier_void_spirit_astral_step_attack", {damage = damage})
local no_cleave = caster:AddNewModifier(caster, self, "modifier_tidehunter_anchor_smash_caster", {})

for _,enemy in pairs(enemies) do
	if enemy:GetUnitName() ~= "npc_teleport" and not enemy:HasModifier("modifier_monkey_king_wukongs_command_custom_soldier") then 

		self:AddMark(enemy, damage)
		caster:PerformAttack( enemy, true, true, true, false, true, false, true )

		if self:GetCaster():HasModifier("modifier_void_step_4") and not enemy:HasModifier("modifier_void_spirit_astral_step_spells_max") then 
			enemy:AddNewModifier(self:GetCaster(), self, "modifier_void_spirit_astral_step_spells", {duration = self:GetCaster():GetTalentValue("modifier_void_step_4", "duration")})
		end

	end
end



if attack_mod then 
	attack_mod:Destroy()
end

if no_cleave then 
	no_cleave:Destroy()
end


self:GetCaster():StartGesture(ACT_DOTA_CAST_ABILITY_2_END)
self:PlayEffects1( origin, target )

end

--------------------------------------------------------------------------------
function void_spirit_astral_step_custom:PlayEffects1( origin, target )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_void_spirit/astral_step/void_spirit_astral_step.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, origin )
	ParticleManager:SetParticleControl( effect_cast, 1, target )
	ParticleManager:ReleaseParticleIndex( effect_cast )

end



modifier_void_spirit_astral_step = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_void_spirit_astral_step:IsHidden()
	return false
end

function modifier_void_spirit_astral_step:IsDebuff()
	return true
end

function modifier_void_spirit_astral_step:IsStunDebuff()
	return false
end

function modifier_void_spirit_astral_step:IsPurgable()
	return true
end

function modifier_void_spirit_astral_step:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_void_spirit_astral_step:OnCreated( kv )

self.slow = -self:GetAbility():GetSpecialValueFor( "movement_slow_pct" )
if not IsServer() then return end

self.k = kv.damage/100
end

function modifier_void_spirit_astral_step:OnDestroy()
if not IsServer() then return end
if not self:GetParent() then return end
if self:GetParent():IsNull() then return end
if not self:GetParent():IsAlive() then return end


self.damage = self:GetAbility():GetSpecialValueFor( "pop_damage" )

if self:GetCaster():HasModifier("modifier_void_step_1") then 
	self.damage = self.damage + self:GetCaster():GetAverageTrueAttackDamage(nil)*self:GetCaster():GetTalentValue("modifier_void_step_1", "damage")/100
end

self.damage = self.damage*self.k

local damageTable = {
	victim = self:GetParent(),
	attacker = self:GetCaster(),
	damage = self.damage,
	damage_type = DAMAGE_TYPE_MAGICAL,
	ability = self:GetAbility(), 
}	
ApplyDamage(damageTable)

self:PlayEffects()

end






--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_void_spirit_astral_step:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end

function modifier_void_spirit_astral_step:GetModifierMoveSpeedBonus_Percentage()
	return self.slow
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_void_spirit_astral_step:GetEffectName()
	return "particles/units/heroes/hero_void_spirit/astral_step/void_spirit_astral_step_debuff.vpcf"
end

function modifier_void_spirit_astral_step:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_void_spirit_astral_step:GetStatusEffectName()
	return "particles/status_fx/status_effect_void_spirit_astral_step_debuff.vpcf"
end

function modifier_void_spirit_astral_step:StatusEffectPriority()
	return MODIFIER_PRIORITY_NORMAL
end

function modifier_void_spirit_astral_step:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_void_spirit/astral_step/void_spirit_astral_step_dmg.vpcf"
	local sound_target = "Hero_VoidSpirit.AstralStep.MarkExplosion"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	self:GetParent():EmitSound(sound_target)
end



modifier_void_spirit_astral_step_attack = class({})
function modifier_void_spirit_astral_step_attack:IsHidden() return true end
function modifier_void_spirit_astral_step_attack:IsPurgable() return false end
function modifier_void_spirit_astral_step_attack:OnCreated(table)
if not IsServer() then return end
self.damage = table.damage - 100
end

function modifier_void_spirit_astral_step_attack:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE
}
end


function modifier_void_spirit_astral_step_attack:GetModifierDamageOutgoing_Percentage()
if not IsServer() then return end
return self.damage
end













modifier_void_spirit_astral_step_tracker = class({})

function modifier_void_spirit_astral_step_tracker:IsHidden() return true end
function modifier_void_spirit_astral_step_tracker:IsPurgable() return false end
function modifier_void_spirit_astral_step_tracker:DeclareFunctions()
return
{
    MODIFIER_EVENT_ON_ABILITY_EXECUTED,
    MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
    MODIFIER_EVENT_ON_TAKEDAMAGE
}
end


function modifier_void_spirit_astral_step_tracker:GetModifierDamageOutgoing_Percentage()
if not self:GetParent():HasModifier("modifier_void_step_1") then return end 

return self:GetParent():GetTalentValue("modifier_void_step_1", "attack")
end


function modifier_void_spirit_astral_step_tracker:OnAbilityExecuted( params )
if not IsServer() then return end
if params.unit~=self:GetParent() then return end
if not params.ability then return end
if params.ability:IsItem() or params.ability:IsToggle() then return end
if UnvalidAbilities[params.ability:GetName()] then return end
if not self:GetParent():HasModifier("modifier_void_step_5") then return end

local mod = self:GetParent():FindModifierByName("modifier_void_spirit_astral_step_stack")

local max = self:GetCaster():GetTalentValue("modifier_void_step_5", "cd")
local cd_proc = self:GetCaster():GetTalentValue("modifier_void_step_5", "cd_inc")

if mod and mod:GetStackCount() < max then 
	mod:SetStackCount(math.min(max, mod:GetStackCount() + cd_proc) )
end 

end 

function modifier_void_spirit_astral_step_tracker:OnTakeDamage(params)
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_void_step_3") then return end
if not self:GetParent():HasModifier("modifier_void_spirit_astral_step_heal") then return end
if self:GetParent() ~= params.attacker then return end
if not params.unit:IsCreep() and not params.unit:IsHero() then return end
if self:GetParent() == params.unit then return end
if bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then return end

local heal = self:GetCaster():GetTalentValue("modifier_void_step_3", "heal") /100
if params.unit:IsCreep() then 
  heal = heal / self:GetCaster():GetTalentValue("modifier_void_step_3", "creeps")
end

heal = heal*params.damage

self:GetParent():GenericHeal(heal, self:GetAbility(), true)

end











modifier_void_spirit_astral_step_stack = class({})
function modifier_void_spirit_astral_step_stack:IsHidden() return true end
function modifier_void_spirit_astral_step_stack:IsPurgable() return false end
function modifier_void_spirit_astral_step_stack:RemoveOnDeath() return false end
function modifier_void_spirit_astral_step_stack:OnCreated(table)


self.max = self:GetCaster():GetTalentValue("modifier_void_step_5", "cd")
if not IsServer() then return end

self:SetStackCount(self.max)

self:StartIntervalThink(FrameTime())
end



function modifier_void_spirit_astral_step_stack:OnIntervalThink()
if not IsServer() then return end 


self.max = self:GetCaster():GetTalentValue("modifier_void_step_5", "cd")

if self:GetStackCount() >= self.max then 

	if not self:GetParent():HasModifier("modifier_void_spirit_astral_step_stack_attack") then 
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_void_spirit_astral_step_stack_attack", {})
	end 

else 
	self:IncrementStackCount()
end 

end 




function modifier_void_spirit_astral_step_stack:OnStackCountChanged(iStackCount)
if not IsServer() then return end 

CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), 'void_mark_change',  {max = self.max, damage = self:GetStackCount()})


if self:GetStackCount() >= self.max then 
	self:StartIntervalThink(FrameTime())
else 
	self:StartIntervalThink(1)
end 

end








modifier_void_spirit_astral_step_stack_attack = class({})
function modifier_void_spirit_astral_step_stack_attack:IsHidden() return false end
function modifier_void_spirit_astral_step_stack_attack:IsPurgable() return false end
function modifier_void_spirit_astral_step_stack_attack:GetTexture() return "buffs/Step_mark" end

function modifier_void_spirit_astral_step_stack_attack:OnCreated(table)

self.range = self:GetCaster():GetTalentValue("modifier_void_step_5", "range")

if not IsServer() then return end
self:GetParent():EmitSound("VoidSpirit.Void_mark")
local unit = self:GetParent()
self.particle = ParticleManager:CreateParticle("particles/boundless_attack.vpcf", PATTACH_ABSORIGIN, unit)
ParticleManager:SetParticleControlEnt(self.particle, 0, unit, PATTACH_POINT_FOLLOW, "attach_weapon_top", unit:GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(self.particle, 2, unit, PATTACH_POINT_FOLLOW, "attach_weapon_top", unit:GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(self.particle, 3, unit, PATTACH_POINT_FOLLOW, "attach_weapon_bot", unit:GetAbsOrigin(), true)
self:AddParticle(self.particle,true,false,0,false,false)

end

function modifier_void_spirit_astral_step_stack_attack:OnDestroy()
if not IsServer() then return end
if not self.particle_peffect then return end

ParticleManager:DestroyParticle(self.particle_peffect, false)
   ParticleManager:ReleaseParticleIndex(self.particle_peffect)
end


function modifier_void_spirit_astral_step_stack_attack:CheckState()
return
{
	[MODIFIER_STATE_CANNOT_MISS] = true
}
end



function modifier_void_spirit_astral_step_stack_attack:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_ATTACK_LANDED,
	MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
}
end


function modifier_void_spirit_astral_step_stack_attack:GetModifierAttackRangeBonus()
return self.range
end



function modifier_void_spirit_astral_step_stack_attack:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end
if params.no_attack_cooldown then return end



for i = 1,3 do
	local particle = ParticleManager:CreateParticle( "particles/void_spirit/void_mark_hit.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControlEnt( particle, 1, params.target, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true )
	ParticleManager:DestroyParticle(particle, false)
	ParticleManager:ReleaseParticleIndex( particle )
end 

if params.target:IsHero() or params.target:IsCreep() then 

	self:GetAbility():AddMark(params.target)

	params.target:EmitSound("VoidSpirit.Void_mark_hit")   
	params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_stunned", {duration = (1 - params.target:GetStatusResistance())*self:GetCaster():GetTalentValue("modifier_void_step_5", "stun")})
end

local mod = self:GetParent():FindModifierByName('modifier_void_spirit_astral_step_stack')
if mod then 
	mod:SetStackCount(0)
end 

self:Destroy()

end






modifier_void_spirit_astral_step_spells = class({})
function modifier_void_spirit_astral_step_spells:IsHidden() return false end
function modifier_void_spirit_astral_step_spells:IsPurgable() return false end
function modifier_void_spirit_astral_step_spells:GetTexture() return "buffs/step_spells" end

function modifier_void_spirit_astral_step_spells:OnCreated()

self.max = self:GetCaster():GetTalentValue("modifier_void_step_4", "max")

if not IsServer() then return end 

self:SetStackCount(1)
end

function modifier_void_spirit_astral_step_spells:OnRefresh()
if not IsServer() then return end 
if self:GetStackCount() >= self.max then return end 

self:IncrementStackCount()

if self:GetStackCount() >= self.max then 
	self:GetParent():EmitSound("VoidSpirit.Step_spells")
	self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_void_spirit_astral_step_spells_max", {duration = self:GetCaster():GetTalentValue("modifier_void_step_4", "duration")})
	self:Destroy()
end

end 


function modifier_void_spirit_astral_step_spells:OnStackCountChanged(iStackCount)
if self:GetStackCount() == 0 then return end
if self.effect then return end
if self:GetStackCount() == 1 then 

	local particle_cast = "particles/am_blink_count.vpcf"

	self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, self:GetStackCount(), 0 ) )

	self:AddParticle(self.effect_cast,false, false, -1, false, false)
else 
  if self.effect_cast then 
  	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, self:GetStackCount(), 0 ) )
  end
end

end










modifier_void_spirit_astral_step_spells_max = class({})
function modifier_void_spirit_astral_step_spells_max:IsHidden() return false end
function modifier_void_spirit_astral_step_spells_max:IsPurgable() return false end
function modifier_void_spirit_astral_step_spells_max:GetTexture() return "buffs/step_spells" end
function modifier_void_spirit_astral_step_spells_max:GetEffectName()
	return "particles/void_spirit/step_spells_mark.vpcf"
end

function modifier_void_spirit_astral_step_spells_max:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_void_spirit_astral_step_spells_max:OnCreated()

self.damage = self:GetCaster():GetTalentValue("modifier_void_step_4", "damage")
self.heal = self:GetCaster():GetTalentValue("modifier_void_step_4", "heal")

end


function modifier_void_spirit_astral_step_spells_max:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
	MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
	MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE,
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
}

end
function modifier_void_spirit_astral_step_spells_max:GetModifierIncomingDamage_Percentage()
return self.damage
end


function modifier_void_spirit_astral_step_spells_max:GetModifierLifestealRegenAmplify_Percentage() 
return self.heal
end

function modifier_void_spirit_astral_step_spells_max:GetModifierHealAmplify_PercentageTarget() 
return self.heal
end


function modifier_void_spirit_astral_step_spells_max:GetModifierHPRegenAmplify_Percentage()
return self.heal
end








modifier_void_spirit_astral_step_heal = class({})
function modifier_void_spirit_astral_step_heal:IsHidden() return false end
function modifier_void_spirit_astral_step_heal:IsPurgable() return false end
function modifier_void_spirit_astral_step_heal:GetTexture() return "buffs/step_heal" end




modifier_void_spirit_astral_step_status = class({})

function modifier_void_spirit_astral_step_status:IsHidden() return true end
function modifier_void_spirit_astral_step_status:IsPurgable() return false end
function modifier_void_spirit_astral_step_status:GetEffectName() return "particles/void_spirit/step_status.vpcf" end
function modifier_void_spirit_astral_step_status:OnCreated()
self.status = self:GetCaster():GetTalentValue("modifier_void_step_6", "status")
end


function modifier_void_spirit_astral_step_status:DeclareFunctions()
return
{

  MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING
}
end


function modifier_void_spirit_astral_step_status:GetModifierStatusResistanceStacking() 
return self.status
end








function void_spirit_astral_step_custom:GetCastPoint()

local bonus = 0
if self:GetCaster():HasModifier("modifier_void_step_6") then 
	bonus = self:GetCaster():GetTalentValue("modifier_void_step_6", "cast")
end

return self.BaseClass.GetCastPoint(self) + bonus
end



function void_spirit_astral_step_custom_1:GetCastPoint()

local bonus = 0
if self:GetCaster():HasModifier("modifier_void_step_6") then 
	bonus = self:GetCaster():GetTalentValue("modifier_void_step_6", "cast")
end

return self.BaseClass.GetCastPoint(self) + bonus
end


function void_spirit_astral_step_custom_2:GetCastPoint()

local bonus = 0
if self:GetCaster():HasModifier("modifier_void_step_6") then 
	bonus = self:GetCaster():GetTalentValue("modifier_void_step_6", "cast")
end

return self.BaseClass.GetCastPoint(self) + bonus
end


function void_spirit_astral_step_custom_3:GetCastPoint()

local bonus = 0
if self:GetCaster():HasModifier("modifier_void_step_6") then 
	bonus = self:GetCaster():GetTalentValue("modifier_void_step_6", "cast")
end

return self.BaseClass.GetCastPoint(self) + bonus
end



function void_spirit_astral_step_custom:GetCastRange(vLocation, hTarget)
if IsServer() then 
	return 9999999
else 
	return self:GetSpecialValueFor("max_travel_distance")
end

end
function void_spirit_astral_step_custom_1:GetCastRange(vLocation, hTarget)
if IsServer() then 
	return 9999999
else 
	return self:GetSpecialValueFor("max_travel_distance")
end

end
function void_spirit_astral_step_custom_2:GetCastRange(vLocation, hTarget)
if IsServer() then 
	return 9999999
else 
	return self:GetSpecialValueFor("max_travel_distance")
end

end
function void_spirit_astral_step_custom_3:GetCastRange(vLocation, hTarget)
if IsServer() then 
	return 9999999
else 
	return self:GetSpecialValueFor("max_travel_distance")
end

end



function void_spirit_astral_step_custom_1:OnSpellStart()
	local ability = self:GetCaster():FindAbilityByName("void_spirit_astral_step_custom")

	ability:CastSpell(self:GetCaster(), self:GetCursorPosition())
end



function void_spirit_astral_step_custom_2:OnSpellStart()
	local ability = self:GetCaster():FindAbilityByName("void_spirit_astral_step_custom")
	ability:CastSpell(self:GetCaster(), self:GetCursorPosition())
end


function void_spirit_astral_step_custom_3:OnSpellStart()
	local ability = self:GetCaster():FindAbilityByName("void_spirit_astral_step_custom")
	ability:CastSpell(self:GetCaster(), self:GetCursorPosition())
end
