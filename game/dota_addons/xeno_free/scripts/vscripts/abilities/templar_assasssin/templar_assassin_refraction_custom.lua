LinkLuaModifier( "modifier_templar_assassin_refraction_custom_damage", "abilities/templar_assasssin/templar_assassin_refraction_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_templar_assassin_refraction_custom_absorb", "abilities/templar_assasssin/templar_assassin_refraction_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_templar_assassin_refraction_custom_reflect_cd", "abilities/templar_assasssin/templar_assassin_refraction_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_templar_assassin_refraction_custom_knockback", "abilities/templar_assasssin/templar_assassin_refraction_custom", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier( "modifier_templar_assassin_refraction_custom_rooted", "abilities/templar_assasssin/templar_assassin_refraction_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_templar_assassin_refraction_custom_legendary_cd", "abilities/templar_assasssin/templar_assassin_refraction_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_templar_assassin_refraction_custom_legendary_stack", "abilities/templar_assasssin/templar_assassin_refraction_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_templar_assassin_refraction_custom_legendary_attack", "abilities/templar_assasssin/templar_assassin_refraction_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_templar_assassin_refraction_custom_shield_speed", "abilities/templar_assasssin/templar_assassin_refraction_custom", LUA_MODIFIER_MOTION_NONE )




templar_assassin_refraction_custom = class({})

templar_assassin_refraction_custom.shield_heal = {0.01, 0.015, 0.02}

templar_assassin_refraction_custom.resist_status = {10, 15, 20}
templar_assassin_refraction_custom.resist_move = {8, 12, 16}

templar_assassin_refraction_custom.cd = {2, 3 , 4}

templar_assassin_refraction_custom.reflect_cd = 15

templar_assassin_refraction_custom.knockback_duration = 0.3
templar_assassin_refraction_custom.knockback_distance = 100
templar_assassin_refraction_custom.knockback_range = 350
templar_assassin_refraction_custom.knockback_root_duration = 1.2

templar_assassin_refraction_custom.legendary_cd = 0.3
templar_assassin_refraction_custom.legendary_damage = 0.12
templar_assassin_refraction_custom.legendary_duration = 6

templar_assassin_refraction_custom.shield_charges = {1,2}
templar_assassin_refraction_custom.shield_speed = {10,15}
templar_assassin_refraction_custom.shield_speed_duration = 3




function templar_assassin_refraction_custom:Precache(context)

PrecacheResource( "particle", 'particles/units/heroes/hero_templar_assassin/templar_assassin_refraction_dmg.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_templar_assassin/templar_assassin_refraction.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_antimage/antimage_spellshield_reflect.vpcf', context )
PrecacheResource( "particle", 'particles/ta_wave.vpcf', context )
PrecacheResource( "particle", 'particles/ta_shield_exp.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_templar_assassin/templar_assassin_refract_hit.vpcf', context )
PrecacheResource( "particle", 'particles/ta_shield_roots.vpcf', context )
PrecacheResource( "particle", 'particles/ta_shield_magic_2.vpcf', context )
PrecacheResource( "particle", 'particles/ta_shield_magic.vpcf', context )
PrecacheResource( "particle", 'particles/templar_assassin_magic_attack.vpcf', context )
PrecacheResource( "particle", 'particles/status_fx/status_effect_omnislash.vpcf', context )

end







function templar_assassin_refraction_custom:GetCooldown(level)
local bonus = 0
if self:GetCaster():HasModifier("modifier_templar_assassin_refraction_3") then 
    bonus = self.cd[self:GetCaster():GetUpgradeStack("modifier_templar_assassin_refraction_3")]
end

    return self.BaseClass.GetCooldown( self, level ) - bonus
end





function templar_assassin_refraction_custom:OnSpellStart()
	if not IsServer() then return end
	local duration = self:GetSpecialValueFor("duration")
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_templar_assassin_refraction_custom_damage", {duration = duration})
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_templar_assassin_refraction_custom_absorb", {duration = duration})
	self:GetCaster():EmitSound("Hero_TemplarAssassin.Refraction")
	self:GetCaster():StartGesture(ACT_DOTA_CAST_REFRACTION)

	self:EndCooldown()
	self:SetActivated(false)
end


-- Урон

modifier_templar_assassin_refraction_custom_damage = class({})

function modifier_templar_assassin_refraction_custom_damage:GetPriority()
	return MODIFIER_PRIORITY_ULTRA
end

function modifier_templar_assassin_refraction_custom_damage:IsPurgable() return false end

function modifier_templar_assassin_refraction_custom_damage:OnCreated()
	self.instances = self:GetAbility():GetSpecialValueFor("instances")
	self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
	if not IsServer() then return end
	self:SetStackCount(self.instances)

	self.RemoveForDuel = true

	self.shield_procs = 0

	if self.particle then
		ParticleManager:DestroyParticle(self.particle, false)
		ParticleManager:ReleaseParticleIndex(self.particle)
	end
	self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_templar_assassin/templar_assassin_refraction_dmg.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControlEnt(self.particle, 2, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetParent():GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(self.particle, 3, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack2", self:GetParent():GetAbsOrigin(), true)
	self:AddParticle(self.particle, false, false, -1, true, false)
end

function modifier_templar_assassin_refraction_custom_damage:OnStackCountChanged()
	if not IsServer() then return end
	if self:GetStackCount() <= 0 then
		self:Destroy()

	

	end
end

function modifier_templar_assassin_refraction_custom_damage:OnRefresh()
	self.instances = self:GetAbility():GetSpecialValueFor("instances")
	self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
	if not IsServer() then return end
	self:SetStackCount(self.instances)
end

function modifier_templar_assassin_refraction_custom_damage:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}

	return funcs
end

function modifier_templar_assassin_refraction_custom_damage:GetModifierPreAttack_BonusDamage()
local bonus = 0 

	return self.bonus_damage + bonus
end

function modifier_templar_assassin_refraction_custom_damage:OnAttackLanded(params)
	if not IsServer() then return end
	if params.attacker ~= self:GetParent() then return end
	params.target:EmitSound("Hero_TemplarAssassin.Refraction.Damage")
	self:DecrementStackCount()




	if self:GetParent():HasModifier("modifier_templar_assassin_refraction_2") then 
		local heal = self:GetAbility().shield_heal[self:GetParent():GetUpgradeStack("modifier_templar_assassin_refraction_2")]*self:GetParent():GetMaxHealth()

		my_game:GenericHeal(self:GetParent(), heal, self:GetAbility())
	end
end

function modifier_templar_assassin_refraction_custom_damage:GetTexture()
	return "templar_assassin_refraction_damage"
end

-- Впитывание

















modifier_templar_assassin_refraction_custom_absorb = class({})

function modifier_templar_assassin_refraction_custom_absorb:GetPriority()
	return MODIFIER_PRIORITY_ULTRA
end

function modifier_templar_assassin_refraction_custom_absorb:IsPurgable() return false end

function modifier_templar_assassin_refraction_custom_absorb:OnCreated()
self.instances = self:GetAbility():GetSpecialValueFor("instances")

if self:GetCaster():HasModifier("modifier_templar_assassin_refraction_4") then 
	self.instances = self.instances + self:GetAbility().shield_charges[self:GetCaster():GetUpgradeStack("modifier_templar_assassin_refraction_4")]
end

self.damage_threshold = self:GetAbility():GetSpecialValueFor("damage_threshold")
if not IsServer() then return end
self:SetStackCount(self.instances)

self.RemoveForDuel = true

if self.particle then
	ParticleManager:DestroyParticle(self.particle, false)
	ParticleManager:ReleaseParticleIndex(self.particle)
end

self.damage_count = 0

self.particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_templar_assassin/templar_assassin_refraction.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
ParticleManager:SetParticleControl( self.particle, 0, self:GetCaster():GetOrigin())
ParticleManager:SetParticleControlEnt( self.particle, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_origin", self:GetCaster():GetOrigin(), true );
ParticleManager:SetParticleControl( self.particle, 5, self:GetCaster():GetOrigin())
self:AddParticle(self.particle, false, false, -1, true, false)
end

function modifier_templar_assassin_refraction_custom_absorb:OnRefresh()
	self.instances = self:GetAbility():GetSpecialValueFor("instances")
	


	if self:GetCaster():HasModifier("modifier_templar_assassin_refraction_4") then 
		self.instances = self.instances + self:GetAbility().shield_charges[self:GetCaster():GetUpgradeStack("modifier_templar_assassin_refraction_4")]
	end
	
	if self:GetCaster():HasModifier("modifier_templar_assassin_refraction_3") then 
		self.instances = self.instances + self:GetAbility().charge_shield[self:GetCaster():GetUpgradeStack("modifier_templar_assassin_refraction_3")]
	end


	self.damage_threshold = self:GetAbility():GetSpecialValueFor("damage_threshold")
	if not IsServer() then return end
	self:SetStackCount(self.instances)
end

function modifier_templar_assassin_refraction_custom_absorb:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK,
		MODIFIER_PROPERTY_REFLECT_SPELL,
		MODIFIER_PROPERTY_ABSORB_SPELL,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING
    }
    return funcs
end


function modifier_templar_assassin_refraction_custom_absorb:GetModifierMoveSpeedBonus_Percentage()
local bonus = 0
if self:GetCaster():HasModifier("modifier_templar_assassin_refraction_1") then 
	bonus = self:GetAbility().resist_move[self:GetCaster():GetUpgradeStack("modifier_templar_assassin_refraction_1")]
end

return bonus
end


function modifier_templar_assassin_refraction_custom_absorb:GetModifierStatusResistanceStacking()
local bonus = 0
if self:GetCaster():HasModifier("modifier_templar_assassin_refraction_1") then 
	bonus = self:GetAbility().resist_status[self:GetCaster():GetUpgradeStack("modifier_templar_assassin_refraction_1")]
end

return bonus
end



function modifier_templar_assassin_refraction_custom_absorb:GetAbsorbSpell( params )
if not IsServer() then return end
if params.ability and params.ability:GetCaster() == self:GetParent() then return end
if not self:GetParent():HasModifier("modifier_templar_assassin_refraction_6") then return end
if self:GetParent():HasModifier("modifier_templar_assassin_refraction_custom_reflect_cd") then return end

self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_templar_assassin_refraction_custom_reflect_cd", {duration = self:GetAbility().reflect_cd})

local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_antimage/antimage_spellshield_reflect.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
ParticleManager:SetParticleControlEnt( particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )
ParticleManager:ReleaseParticleIndex( particle )
self:GetParent():EmitSound("TA.Spell_block")

	return 1
end








function modifier_templar_assassin_refraction_custom_absorb:OnStackCountChanged()
if not IsServer() then return end


if self:GetStackCount() <= 0 then
	self:Destroy()

	if self:GetParent():HasModifier("modifier_templar_assassin_refraction_5") then 
		local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self:GetAbility().knockback_range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )

		self:GetParent():EmitSound("TA.Shield_break")
		

		local wave_particle = ParticleManager:CreateParticle( "particles/ta_wave.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControl( wave_particle, 1, self:GetCaster():GetAbsOrigin() )
		ParticleManager:ReleaseParticleIndex(wave_particle)

		local particle = ParticleManager:CreateParticle("particles/ta_shield_exp.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(particle, 0, self:GetParent():GetAbsOrigin())


		for _,enemy in pairs(enemies) do 
			enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_templar_assassin_refraction_custom_knockback", {duration = self:GetAbility().knockback_duration, x = self:GetCaster():GetAbsOrigin().x, y = self:GetCaster():GetAbsOrigin().y})
		end
	end
end
end

function modifier_templar_assassin_refraction_custom_absorb:GetModifierTotal_ConstantBlock(params)
    if not IsServer() then return end
    if params.damage < self.damage_threshold then return end
    if bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) == DOTA_DAMAGE_FLAG_HPLOSS then return end

	self:GetParent():EmitSound("Hero_TemplarAssassin.Refraction.Absorb")

	local forward = self:GetParent():GetAbsOrigin() - params.attacker:GetAbsOrigin()
	forward.z = 0
	forward = forward:Normalized()

	local particle_2 = ParticleManager:CreateParticle("particles/units/heroes/hero_templar_assassin/templar_assassin_refract_hit.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent())
	ParticleManager:SetParticleControlEnt(particle_2, 0, self:GetParent(), PATTACH_POINT, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(particle_2, 1, self:GetParent():GetAbsOrigin())
	ParticleManager:SetParticleControlForward(particle_2, 1, forward)
	ParticleManager:SetParticleControlEnt(particle_2, 2, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetAbsOrigin(), false)
	ParticleManager:ReleaseParticleIndex(particle_2)

	local update_ui = false
	local mod = self:GetCaster():FindModifierByName("modifier_templar_assassin_refraction_custom_legendary_stack")

	if self:GetCaster():HasModifier("modifier_templar_assassin_refraction_7") then 

		if mod then 
			mod:SetStackCount(mod:GetStackCount() + params.original_damage*self:GetAbility().legendary_damage)
			update_ui = true	

			if not self:GetParent():HasModifier("modifier_templar_assassin_refraction_custom_legendary_attack") then 
				CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), 'Templar_Refraction_shield',  {max = self.instances, charges = self:GetStackCount() - 1, damage = mod:GetStackCount()})
			end
		end

		if not self:GetCaster():HasModifier("modifier_templar_assassin_refraction_custom_legendary_cd")  then 
			self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_templar_assassin_refraction_custom_legendary_cd", {duration = self:GetAbility().legendary_cd})
			self:DecrementStackCount()
			if self:GetCaster():HasModifier("modifier_templar_assassin_refraction_4") then 
				self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_templar_assassin_refraction_custom_shield_speed", {duration = self:GetAbility().shield_speed_duration})
			end
		end
	else 
    	self:DecrementStackCount()
		if self:GetCaster():HasModifier("modifier_templar_assassin_refraction_4") then 
			self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_templar_assassin_refraction_custom_shield_speed", {duration = self:GetAbility().shield_speed_duration})
		end
    end

	if self:GetParent():HasModifier("modifier_templar_assassin_refraction_2") then 
		local heal = self:GetAbility().shield_heal[self:GetParent():GetUpgradeStack("modifier_templar_assassin_refraction_2")]*self:GetParent():GetMaxHealth()

		my_game:GenericHeal(self:GetParent(), heal, self:GetAbility())
	end
	if update_ui then 

		local stack = self:GetStackCount()
		if self:GetStackCount() == 0 then 
			stack = self.instances
		end
	end


	if self:GetCaster():GetQuest() == "Templar.Quest_5" and params.attacker:IsRealHero() and not self:GetCaster():QuestCompleted() then 
		self:GetCaster():UpdateQuest(math.floor(params.original_damage))
	end

    return params.damage
end



function modifier_templar_assassin_refraction_custom_absorb:OnDestroy()
if not IsServer() then return end
self:GetAbility():SetActivated(true)
self:GetAbility():UseResources(false, false, false, true)

local mod = self:GetCaster():FindModifierByName("modifier_templar_assassin_refraction_custom_legendary_stack")

if not mod then return end 

local stack = mod:GetStackCount()
mod:SetStackCount(0)
	
if stack == 0 then return end

self:GetCaster():RemoveModifierByName("modifier_templar_assassin_refraction_custom_legendary_attack")

local attack_mod = self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_templar_assassin_refraction_custom_legendary_attack", {duration = self:GetAbility().legendary_duration})
attack_mod:SetStackCount(stack)

end










modifier_templar_assassin_refraction_custom_reflect_cd = class({})
function modifier_templar_assassin_refraction_custom_reflect_cd:IsHidden() return false end
function modifier_templar_assassin_refraction_custom_reflect_cd:IsDebuff() return true end
function modifier_templar_assassin_refraction_custom_reflect_cd:IsPurgable() return false end
function modifier_templar_assassin_refraction_custom_reflect_cd:OnCreated(table)
self.RemoveForDuel = true
end

function modifier_templar_assassin_refraction_custom_reflect_cd:GetTexture() return "buffs/refraction_reflect" end








modifier_templar_assassin_refraction_custom_knockback = class({})

function modifier_templar_assassin_refraction_custom_knockback:IsHidden() return true end

function modifier_templar_assassin_refraction_custom_knockback:OnCreated(params)
  if not IsServer() then return end
  
  self.ability        = self:GetAbility()
  self.caster         = self:GetCaster()
  self.parent         = self:GetParent()
  self:GetParent():StartGesture(ACT_DOTA_FLAIL)
  
  self.knockback_duration   = self.ability.knockback_duration

  self.knockback_distance   = math.max((self.ability.knockback_distance + self.ability.knockback_range)  - (self.caster:GetAbsOrigin() - self.parent:GetAbsOrigin()):Length2D(),  self:GetAbility().knockback_distance)
  
  self.knockback_speed    = self.knockback_distance / self.knockback_duration
  
  self.position = GetGroundPosition(Vector(params.x, params.y, 0), nil)
  
  if self:ApplyHorizontalMotionController() == false then 
    self:Destroy()
    return
  end
end

function modifier_templar_assassin_refraction_custom_knockback:UpdateHorizontalMotion( me, dt )
  if not IsServer() then return end

  local distance = (me:GetOrigin() - self.position):Normalized()
  
  me:SetOrigin( me:GetOrigin() + distance * self.knockback_speed * dt )

  GridNav:DestroyTreesAroundPoint( self.parent:GetOrigin(), self.parent:GetHullRadius(), true )
end

function modifier_templar_assassin_refraction_custom_knockback:DeclareFunctions()
  local decFuncs = {
    MODIFIER_PROPERTY_OVERRIDE_ANIMATION
    }

    return decFuncs
end

function modifier_templar_assassin_refraction_custom_knockback:GetOverrideAnimation()
   return ACT_DOTA_FLAIL
end


function modifier_templar_assassin_refraction_custom_knockback:OnDestroy()
  if not IsServer() then return end
 self.parent:RemoveHorizontalMotionController( self )
  self:GetParent():FadeGesture(ACT_DOTA_FLAIL)
  self:GetParent():EmitSound("TA.Shield_root")
  self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_templar_assassin_refraction_custom_rooted", {duration = (1 - self:GetParent():GetStatusResistance())*self:GetAbility().knockback_root_duration})
end








modifier_templar_assassin_refraction_custom_rooted = class({})
function modifier_templar_assassin_refraction_custom_rooted:IsHidden() return true end
function modifier_templar_assassin_refraction_custom_rooted:IsPurgable() return true end
function modifier_templar_assassin_refraction_custom_rooted:CheckState()
return
{
	[MODIFIER_STATE_ROOTED] = true
}
end
function modifier_templar_assassin_refraction_custom_rooted:GetEffectName() return "particles/ta_shield_roots.vpcf" end


modifier_templar_assassin_refraction_custom_legendary_cd = class({})
function modifier_templar_assassin_refraction_custom_legendary_cd:IsHidden() return true end
function modifier_templar_assassin_refraction_custom_legendary_cd:IsPurgable() return false end



modifier_templar_assassin_refraction_custom_legendary_stack = class({})
function modifier_templar_assassin_refraction_custom_legendary_stack:IsHidden() return true end
function modifier_templar_assassin_refraction_custom_legendary_stack:IsPurgable() return false end
function modifier_templar_assassin_refraction_custom_legendary_stack:RemoveOnDeath() return false end
function modifier_templar_assassin_refraction_custom_legendary_stack:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(0)
CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), 'Templar_Refraction_shield',  {max = 6, charges = 0, damage = 0})
end




modifier_templar_assassin_refraction_custom_legendary_attack = class({})
function modifier_templar_assassin_refraction_custom_legendary_attack:IsHidden() return true end
function modifier_templar_assassin_refraction_custom_legendary_attack:IsPurgable() return false end

function modifier_templar_assassin_refraction_custom_legendary_attack:GetEffectName()
return "particles/ta_shield_magic_2.vpcf"
end


function modifier_templar_assassin_refraction_custom_legendary_attack:OnCreated(table)
if not IsServer() then return end


self:GetParent():EmitSound("TA.Shield_legendary")
local particle_peffect = ParticleManager:CreateParticle("particles/ta_shield_magic.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
ParticleManager:SetParticleControl(particle_peffect, 0, self:GetCaster():GetAbsOrigin())
ParticleManager:SetParticleControl(particle_peffect, 2, self:GetCaster():GetAbsOrigin())
ParticleManager:ReleaseParticleIndex(particle_peffect)

CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), 'Templar_Refraction_change',  {})
self:StartIntervalThink(0.2)
end

function modifier_templar_assassin_refraction_custom_legendary_attack:OnDestroy()
if not IsServer() then return end
CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), 'Templar_Refraction_change',  {})
CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), 'Templar_Refraction_shield',  {max = 6, charges = 0, damage = 0})

end


function modifier_templar_assassin_refraction_custom_legendary_attack:OnIntervalThink()
if not IsServer() then return end
if self:GetStackCount() == 0 then return end
CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), 'Templar_Refraction_shield',  {max = self:GetAbility().legendary_duration, charges = self:GetAbility().legendary_duration - self:GetRemainingTime(), damage = self:GetStackCount()})
end




function modifier_templar_assassin_refraction_custom_legendary_attack:DeclareFunctions()
    local funcs = {
		MODIFIER_PROPERTY_PROJECTILE_NAME,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_ATTACK
    }
    return funcs
end

function modifier_templar_assassin_refraction_custom_legendary_attack:OnAttack(params)
if self:GetParent() ~= params.attacker then return end

        local projectile =
        {
            Target = params.target,
            Source = self:GetParent(),
            Ability = self:GetAbility(),
            EffectName = "particles/templar_assassin_magic_attack.vpcf",
            iMoveSpeed = self:GetParent():GetProjectileSpeed(),
            vSourceLoc = self:GetParent():GetAbsOrigin(),
            bDodgeable = false,
            bProvidesVision = false,
        }

        local hProjectile = ProjectileManager:CreateTrackingProjectile( projectile )

end




function modifier_templar_assassin_refraction_custom_legendary_attack:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end
if params.target:IsBuilding() then return end
if params.target:IsMagicImmune() then return end

params.target:EmitSound("TA.Shield_legendary_attack")
ApplyDamage({victim = params.target, attacker = self:GetCaster(), damage = self:GetStackCount(), damage_type = DAMAGE_TYPE_MAGICAL, ability = self:GetAbility()})
   
SendOverheadEventMessage(params.target, 4, params.target, self:GetStackCount(), nil)         
end




function modifier_templar_assassin_refraction_custom_legendary_attack:GetStatusEffectName()
return "particles/status_fx/status_effect_omnislash.vpcf"
end
function modifier_templar_assassin_refraction_custom_legendary_attack:StatusEffectPriority() return
11111
end









modifier_templar_assassin_refraction_custom_shield_speed = class({})
function modifier_templar_assassin_refraction_custom_shield_speed:IsHidden() return false end
function modifier_templar_assassin_refraction_custom_shield_speed:IsPurgable() return false end
function modifier_templar_assassin_refraction_custom_shield_speed:GetTexture() return "buffs/refraction_speed" end
function modifier_templar_assassin_refraction_custom_shield_speed:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1) 
end


function modifier_templar_assassin_refraction_custom_shield_speed:OnRefresh(table)
if not IsServer() then return end
self:IncrementStackCount() 
end

function modifier_templar_assassin_refraction_custom_shield_speed:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
end


function modifier_templar_assassin_refraction_custom_shield_speed:GetModifierAttackSpeedBonus_Constant()
return self:GetStackCount()*self:GetAbility().shield_speed[self:GetCaster():GetUpgradeStack("modifier_templar_assassin_refraction_4")]
end