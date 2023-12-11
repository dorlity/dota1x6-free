LinkLuaModifier("modifier_troll_warlord_berserkers_rage_custom", "abilities/troll_warlord/troll_warlord_berserkers_rage_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_troll_warlord_berserkers_rage_custom_ensnare", "abilities/troll_warlord/troll_warlord_berserkers_rage_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_troll_warlord_berserkers_rage_tracker", "abilities/troll_warlord/troll_warlord_berserkers_rage_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_troll_warlord_berserkers_rage_charge_stack", "abilities/troll_warlord/troll_warlord_berserkers_rage_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_troll_warlord_berserkers_rage_charge_cd", "abilities/troll_warlord/troll_warlord_berserkers_rage_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_troll_warlord_berserkers_rage_ranged", "abilities/troll_warlord/troll_warlord_berserkers_rage_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_troll_warlord_berserkers_rage_slow", "abilities/troll_warlord/troll_warlord_berserkers_rage_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_troll_warlord_berserkers_rage_bloodrage", "abilities/troll_warlord/troll_warlord_berserkers_rage_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_troll_warlord_berserkers_rage_cd", "abilities/troll_warlord/troll_warlord_berserkers_rage_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_troll_warlord_rampage_custom", "abilities/troll_warlord/troll_warlord_berserkers_rage_custom", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_troll_warlord_berserkers_rage_silence", "abilities/troll_warlord/troll_warlord_berserkers_rage_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_troll_warlord_berserkers_rage_bloodrag_ranged", "abilities/troll_warlord/troll_warlord_berserkers_rage_custom", LUA_MODIFIER_MOTION_NONE)



troll_warlord_berserkers_rage_custom = class({})









function troll_warlord_berserkers_rage_custom:Precache(context)
PrecacheResource( "particle", "particles/units/heroes/hero_troll_warlord/troll_warlord_melee_blur_6.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_troll_warlord/troll_warlord_melee_blur_1.vpcf", context )

    
PrecacheResource( "particle", "particles/troll_heal_buf.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_troll_warlord/troll_warlord_bersekers_net.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_troll_warlord/troll_warlord_bersekers_net_projectile.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_troll_warlord/troll_warlord_berserk_buff.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_drow/fist_count.vpcf", context )
PrecacheResource( "particle", "particles/econ/items/troll_warlord/troll_warlord_ti7_axe/troll_ti7_axe_bash_explosion.vpcf", context )
PrecacheResource( "particle", "particles/troll_haste.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_sniper/sniper_headshot_slow.vpcf", context )
PrecacheResource( "particle", "particles/status_fx/status_effect_beserkers_call.vpcf", context )
PrecacheResource( "particle", "particles/troll_char.vpcf", context )
PrecacheResource( "particle", "particles/troll_char_active.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_meepo/meepo_ransack.vpcf", context )
PrecacheResource( "particle", "particles/troll_warlord/troll_char_ranged.vpcf", context )
end


function troll_warlord_berserkers_rage_custom:ProcRoot(target, ranged, auto)


local chance = self:GetSpecialValueFor("ensnare_chance")
local cd = self:GetSpecialValueFor("ensnare_cooldown")
local duration = self:GetSpecialValueFor("ensnare_duration")

if self:GetCaster():HasModifier("modifier_troll_rage_1") then 
	chance = chance + self:GetCaster():GetTalentValue("modifier_troll_rage_1", "chance")
end


if not auto then 
	if not RollPseudoRandomPercentage(chance, self:GetCaster():entindex(), self:GetCaster()) then 
		return 
	end
end

if self:GetCaster():GetQuest() == "Troll.Quest_5" and target:IsRealHero() and not self:GetCaster():QuestCompleted() then 
	self:GetCaster():UpdateQuest(1)
end

target:AddNewModifier(self:GetCaster(), self, "modifier_troll_warlord_berserkers_rage_cd", {duration = cd})


if ranged and ranged == true then 
	duration = self:GetCaster():GetTalentValue("modifier_troll_rage_legendary", "root")*duration/100
end 


local net =
{
	Target = target,
	Source = self:GetCaster(),
	Ability = self,
	bDodgeable = false,
	EffectName = "particles/units/heroes/hero_troll_warlord/troll_warlord_bersekers_net_projectile.vpcf",
	iMoveSpeed = 1500,
	flExpireTime = GameRules:GetGameTime() + 10,
	ExtraData = {duration = duration}
}
ProjectileManager:CreateTrackingProjectile(net)



end





function troll_warlord_berserkers_rage_custom:ProcsMagicStick()
	return false
end

function troll_warlord_berserkers_rage_custom:GetIntrinsicModifierName()
return "modifier_troll_warlord_berserkers_rage_tracker"
end

function troll_warlord_berserkers_rage_custom:ResetToggleOnRespawn()
	return false
end

function troll_warlord_berserkers_rage_custom:OnToggle()
	if not IsServer() then return end
	self:GetCaster():CalculateStatBonus(true)
	self:GetCaster():StartGesture(ACT_DOTA_CAST_ABILITY_1)
	if self:GetToggleState() then
		self.modifier = self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_troll_warlord_berserkers_rage_custom", {} )

		if self:GetCaster():HasModifier("modifier_troll_warlord_berserkers_rage_ranged") then 
			self:GetCaster():RemoveModifierByName("modifier_troll_warlord_berserkers_rage_ranged")
		end

		if self:GetCaster():HasModifier("modifier_troll_rage_6") and not self:GetCaster():HasModifier("modifier_troll_warlord_berserkers_rage_bloodrag_ranged") then 
			self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_troll_warlord_berserkers_rage_bloodrage", {})
		end

	else
		if self.modifier then
			self.modifier:Destroy()
			self.modifier = nil

			if self:GetCaster():HasModifier("modifier_troll_rage_legendary") then 
				self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_troll_warlord_berserkers_rage_ranged", {})
			end

			if self:GetCaster():HasModifier("modifier_troll_rage_6") and not self:GetCaster():HasModifier("modifier_troll_warlord_berserkers_rage_bloodrage") then 
				self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_troll_warlord_berserkers_rage_bloodrag_ranged", {})
			end

		end
	end

	self:GetCaster():EmitSound("Hero_TrollWarlord.BerserkersRage.Toggle")
end

function troll_warlord_berserkers_rage_custom:GetAbilityTextureName()
	if self:GetCaster():HasModifier("modifier_troll_warlord_berserkers_rage_custom") then
		return "troll_warlord_berserkers_rage_active"
	else
		return "troll_warlord_berserkers_rage"
	end
end

function troll_warlord_berserkers_rage_custom:OnUpgrade()
	if self.modifier then
		self.modifier:ForceRefresh()
	end
end

function troll_warlord_berserkers_rage_custom:OnProjectileHit_ExtraData(hTarget, vLocation, table)
	if not IsServer() then return end
	if not table.duration then return end

	local ensnare_duration	= table.duration 

	if hTarget then
		hTarget:EmitSound("n_creep_TrollWarlord.Ensnare")
		if hTarget:IsAlive() then
			hTarget:AddNewModifier(self:GetCaster(), self, "modifier_troll_warlord_berserkers_rage_custom_ensnare", {duration = ensnare_duration * (1 - hTarget:GetStatusResistance())})
		end
	end
end

modifier_troll_warlord_berserkers_rage_custom_ensnare = class({})

function modifier_troll_warlord_berserkers_rage_custom_ensnare:GetEffectName()
	return "particles/units/heroes/hero_troll_warlord/troll_warlord_bersekers_net.vpcf"
end

function modifier_troll_warlord_berserkers_rage_custom_ensnare:CheckState()
	return {[MODIFIER_STATE_ROOTED] = true}
end


function modifier_troll_warlord_berserkers_rage_custom_ensnare:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}

end 

function modifier_troll_warlord_berserkers_rage_custom_ensnare:OnCreated()
self.speed = self:GetCaster():GetTalentValue("modifier_troll_rage_1", "speed")
end



function modifier_troll_warlord_berserkers_rage_custom_ensnare:GetModifierAttackSpeedBonus_Constant()
return self.speed
end




modifier_troll_warlord_berserkers_rage_custom = class({})
function modifier_troll_warlord_berserkers_rage_custom:IsHidden() return true end

function modifier_troll_warlord_berserkers_rage_custom:IsPurgable() return false end
function modifier_troll_warlord_berserkers_rage_custom:RemoveOnDeath() return false end
function modifier_troll_warlord_berserkers_rage_custom:IsPurgeException() return false end

function modifier_troll_warlord_berserkers_rage_custom:OnCreated( kv )
	self.base_attack_time = self:GetAbility():GetSpecialValueFor( "base_attack_time" )
	self.bonus_move_speed = self:GetAbility():GetSpecialValueFor( "bonus_move_speed" )
	self.bonus_armor = self:GetAbility():GetSpecialValueFor( "bonus_armor" )
	self.melee_range = 150


	self.delta_attack_range = self.melee_range - self:GetParent():Script_GetAttackRange()

	if not IsServer() then return end
	self.pre_attack_capability = self:GetParent():GetAttackCapability()
	self:GetParent():SetAttackCapability( DOTA_UNIT_CAP_MELEE_ATTACK )
	self:GetParent():FadeGesture(ACT_DOTA_RUN)
	self.attack_melee = false

self.StackOnIllusion = true
end


function modifier_troll_warlord_berserkers_rage_custom:OnDestroy( kv )
	if not IsServer() then return end
	self:GetParent():SetAttackCapability(self.pre_attack_capability )
	self:GetParent():FadeGesture(ACT_DOTA_RUN)
end

function modifier_troll_warlord_berserkers_rage_custom:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
		MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}

	return funcs
end





function modifier_troll_warlord_berserkers_rage_custom:GetModifierBaseAttackTimeConstant()
local ability = self:GetParent():FindAbilityByName("troll_warlord_fervor_custom")
if self:GetParent():HasModifier("modifier_troll_warlord_fervor_custom_max") then return ability.max_bva end
    return self.base_attack_time
end

function modifier_troll_warlord_berserkers_rage_custom:GetModifierAttackRangeBonus()
	return -350  --self.delta_attack_range
end

function modifier_troll_warlord_berserkers_rage_custom:GetModifierMoveSpeedBonus_Constant()
	return self.bonus_move_speed  + self:GetCaster():GetTalentValue("modifier_troll_rage_2", "speed")
end

function modifier_troll_warlord_berserkers_rage_custom:GetModifierPhysicalArmorBonus()

	return self.bonus_armor
end

function modifier_troll_warlord_berserkers_rage_custom:GetAttackSound()
	return "Hero_TrollWarlord.ProjectileImpact"
end

function modifier_troll_warlord_berserkers_rage_custom:OnAttackLanded( params )
	if not IsServer() then return end
	if params.attacker:PassivesDisabled() then return end
	if params.attacker ~= self:GetParent() then return end
	if params.attacker == params.target then return end
	if params.target:IsOther() then return end
	if params.attacker:IsIllusion() then return end
	if params.target:IsBuilding() then return end
	if params.target:HasModifier("modifier_troll_warlord_berserkers_rage_cd") then return end
	if params.ranged_attack then return end

	self:GetAbility():ProcRoot(params.target, false)
end

function modifier_troll_warlord_berserkers_rage_custom:GetActivityTranslationModifiers()
	return "melee"
end

function modifier_troll_warlord_berserkers_rage_custom:GetPriority()
	return 1
end

function modifier_troll_warlord_berserkers_rage_custom:GetEffectName()
	return "particles/units/heroes/hero_troll_warlord/troll_warlord_berserk_buff.vpcf"
end

function modifier_troll_warlord_berserkers_rage_custom:GetEffectAttachType()
	return PATTACH_POINT_FOLLOW
end


modifier_troll_warlord_berserkers_rage_tracker = class({})
function modifier_troll_warlord_berserkers_rage_tracker:IsHidden() return true end
function modifier_troll_warlord_berserkers_rage_tracker:IsPurgable() return false end
function modifier_troll_warlord_berserkers_rage_tracker:OnCreated(table)
self.last_proc = nil


  self.agi_percentage = 0



  self:OnIntervalThink()
  self:StartIntervalThink(0.2)
end

function modifier_troll_warlord_berserkers_rage_tracker:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_ATTACK,
	MODIFIER_EVENT_ON_ATTACK_LANDED,
	MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
	MODIFIER_PROPERTY_HEALTH_BONUS,
}
end

function modifier_troll_warlord_berserkers_rage_tracker:GetModifierAttackRangeBonus()
local bonus = 0
if self:GetCaster():HasModifier("modifier_troll_rage_legendary") and not self:GetCaster():HasModifier("modifier_troll_warlord_berserkers_rage_custom") then 
	bonus = self:GetCaster():GetTalentValue("modifier_troll_rage_legendary", "range")
end
	return bonus
end







function modifier_troll_warlord_berserkers_rage_tracker:OnIntervalThink()
if not IsServer() then return end


end




function modifier_troll_warlord_berserkers_rage_tracker:OnAttack(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end
if not params.target:IsHero() and not params.target:IsCreep() then return end
if params.no_attack_cooldown then return end

local chance = self:GetParent():GetTalentValue("modifier_troll_rage_4", "chance")
if self:GetParent():HasModifier("modifier_troll_warlord_berserkers_rage_custom") then 
	chance = chance / self:GetParent():GetTalentValue("modifier_troll_rage_4", "range")
end

if not RollPseudoRandomPercentage(chance, 921, self:GetParent()) then return end


local targets = FindUnitsInRadius( self:GetParent():GetTeamNumber(), params.target:GetAbsOrigin(), nil, self:GetCaster():GetTalentValue("modifier_troll_rage_4", "radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER,false)
  
if #targets == 0 then return end

local target = targets[RandomInt(1, #targets)]

Timers:CreateTimer(0.3, function()

	if target and not target:IsNull() and target:IsAlive() then 
		self:GetParent():PerformAttack(target, true, true, true, false, true, false, false)
	end 
end)

end





function modifier_troll_warlord_berserkers_rage_tracker:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end
if not params.target:IsHero() and not params.target:IsCreep() then return end


if self:GetCaster():HasModifier("modifier_troll_rage_4") and params.no_attack_cooldown then 

	local enemy = params.target
	enemy:EmitSound("Ogre.Bloodlust_hit")
	local hit_effect = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_quad_tap_hit.vpcf", PATTACH_CUSTOMORIGIN, enemy)
	ParticleManager:SetParticleControlEnt(hit_effect, 0, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), false) 
	ParticleManager:SetParticleControlEnt(hit_effect, 1, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), false) 
	ParticleManager:ReleaseParticleIndex(hit_effect)
end

if self:GetCaster():HasModifier("modifier_troll_rage_3") then 
	local chance = self:GetCaster():GetTalentValue("modifier_troll_rage_3", "chance")

	if RollPseudoRandomPercentage(chance, 901, self:GetParent()) then 

		local damage = self:GetCaster():GetTalentValue("modifier_troll_rage_3", "damage")

		if params.ranged_attack then 
			local real_damage =ApplyDamage({victim = params.target, attacker = self:GetCaster(), damage = damage, damage_type = DAMAGE_TYPE_PURE, ability = self:GetAbility()})
			params.target:SendNumber(4, real_damage)
		else 
			self:GetCaster():GenericHeal(damage, self:GetAbility())
		end 

	end 

end


if self:GetCaster():HasModifier("modifier_troll_rage_2") then 
	params.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_troll_warlord_berserkers_rage_slow", {duration = self:GetCaster():GetTalentValue("modifier_troll_rage_2", "duration")})
end






if not self:GetParent():HasModifier("modifier_troll_rage_5") then return end

if not params.ranged_attack then return end
if params.target:HasModifier("modifier_troll_warlord_berserkers_rage_charge_cd") then return end
if params.target:HasModifier("modifier_troll_warlord_berserkers_rage_charge_ready") then return end

params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_troll_warlord_berserkers_rage_charge_stack", {duration = self:GetCaster():GetTalentValue("modifier_troll_rage_5", "duration")})
end




modifier_troll_warlord_berserkers_rage_charge_stack = class({})
function modifier_troll_warlord_berserkers_rage_charge_stack:IsHidden() return true end
function modifier_troll_warlord_berserkers_rage_charge_stack:IsPurgable() return false end
function modifier_troll_warlord_berserkers_rage_charge_stack:OnCreated(table)
if not IsServer() then return end

self.max = self:GetCaster():GetTalentValue("modifier_troll_rage_5", "max")

self:SetStackCount(1)
end

function modifier_troll_warlord_berserkers_rage_charge_stack:OnRefresh(table)
if not IsServer() then return end
self:IncrementStackCount()

if self:GetStackCount() >= self.max then 
	self:GetParent():EmitSound("SF.Raze_silence")
	self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_troll_warlord_berserkers_rage_charge_cd", {duration = self:GetCaster():GetTalentValue("modifier_troll_rage_5", "cd")})
	self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_troll_warlord_berserkers_rage_silence", {duration = self:GetCaster():GetTalentValue("modifier_troll_rage_5", "silence")*(1 - self:GetParent():GetStatusResistance())})
	self:Destroy()
end

end



function modifier_troll_warlord_berserkers_rage_charge_stack:OnStackCountChanged(iStackCount)
if self:GetStackCount() == 1 then

  local particle_cast = "particles/units/heroes/hero_drow/fist_count.vpcf"
  self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
  ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, self:GetStackCount(), 0 ) )
  self:AddParticle(self.effect_cast,false, false, -1, false, false)
else 

  if self.effect_cast then 
  	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, self:GetStackCount(), 0 ) )
  end

end


end










modifier_troll_warlord_berserkers_rage_ranged = class({})
function modifier_troll_warlord_berserkers_rage_ranged:IsHidden() return true end
function modifier_troll_warlord_berserkers_rage_ranged:IsPurgable() return false end
function modifier_troll_warlord_berserkers_rage_ranged:RemoveOnDeath() return false end
function modifier_troll_warlord_berserkers_rage_ranged:AllowIllusionDuplicate() return true end
function modifier_troll_warlord_berserkers_rage_ranged:IsPurgeException() return false end

function modifier_troll_warlord_berserkers_rage_ranged:OnCreated( kv )
	self.base_attack_time = self:GetAbility():GetSpecialValueFor( "base_attack_time" )
	self.bonus_move_speed = self:GetAbility():GetSpecialValueFor( "bonus_move_speed" )
	self.bonus_armor = self:GetAbility():GetSpecialValueFor( "bonus_armor" )
	self.ensnare_chance = self:GetAbility():GetSpecialValueFor( "ensnare_chance" )
end





function modifier_troll_warlord_berserkers_rage_ranged:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}

	return funcs
end


 
function modifier_troll_warlord_berserkers_rage_ranged:GetModifierBaseAttackTimeConstant()
local ability = self:GetParent():FindAbilityByName("troll_warlord_fervor_custom")
if self:GetParent():HasModifier("modifier_troll_warlord_fervor_custom_max") then return ability.max_bva end
    return self.base_attack_time
end


function modifier_troll_warlord_berserkers_rage_ranged:GetModifierMoveSpeedBonus_Constant()

	return self.bonus_move_speed  + self:GetCaster():GetTalentValue("modifier_troll_rage_2", "speed")
end

function modifier_troll_warlord_berserkers_rage_ranged:GetModifierPhysicalArmorBonus()

	return self.bonus_armor 
end

function modifier_troll_warlord_berserkers_rage_ranged:OnAttackLanded( params )
if not IsServer() then return end

if params.attacker:PassivesDisabled() then return end
if params.attacker ~= self:GetParent() then return end
if params.attacker == params.target then return end
if params.target:IsOther() then return end
if params.attacker:IsIllusion() then return end
if params.target:IsBuilding() then return end
if not params.ranged_attack then return end
if params.target:HasModifier("modifier_troll_warlord_berserkers_rage_cd") then return end

self:GetAbility():ProcRoot(params.target, true)
end




modifier_troll_warlord_berserkers_rage_slow = class({})
function modifier_troll_warlord_berserkers_rage_slow:IsHidden() return false end
function modifier_troll_warlord_berserkers_rage_slow:IsPurgable() return true end

function modifier_troll_warlord_berserkers_rage_slow:GetEffectName()
return "particles/units/heroes/hero_sniper/sniper_headshot_slow.vpcf"
end


function modifier_troll_warlord_berserkers_rage_slow:GetEffectAttachType()
return PATTACH_OVERHEAD_FOLLOW
end

function modifier_troll_warlord_berserkers_rage_slow:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
}
end



function modifier_troll_warlord_berserkers_rage_slow:OnCreated()
self.slow = self:GetCaster():GetTalentValue("modifier_troll_rage_2", "slow")
end

function modifier_troll_warlord_berserkers_rage_slow:GetEffectName()
    return "particles/units/heroes/hero_snapfire/hero_snapfire_shotgun_debuff.vpcf"
end

function modifier_troll_warlord_berserkers_rage_slow:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_troll_warlord_berserkers_rage_slow:GetStatusEffectName()
    return "particles/status_fx/status_effect_snapfire_slow.vpcf"
end

function modifier_troll_warlord_berserkers_rage_slow:StatusEffectPriority()
    return MODIFIER_PRIORITY_NORMAL
end

function modifier_troll_warlord_berserkers_rage_slow:GetModifierMoveSpeedBonus_Percentage()
return self.slow
end




modifier_troll_warlord_berserkers_rage_bloodrage = class({})
function modifier_troll_warlord_berserkers_rage_bloodrage:IsHidden() return false end
function modifier_troll_warlord_berserkers_rage_bloodrage:IsPurgable() return false end
function modifier_troll_warlord_berserkers_rage_bloodrage:GetTexture() return "buffs/rage_bloodrage" end

function modifier_troll_warlord_berserkers_rage_bloodrage:GetStatusEffectName()
  return "particles/status_fx/status_effect_beserkers_call.vpcf"
end
function modifier_troll_warlord_berserkers_rage_bloodrage:StatusEffectPriority()
    return 12
end


function modifier_troll_warlord_berserkers_rage_bloodrage:OnCreated(table)
self.damage = self:GetCaster():GetTalentValue("modifier_troll_rage_6", "damage")
if not IsServer() then return end

local name = "particles/troll_char.vpcf"

self.heal = self:GetCaster():GetTalentValue("modifier_troll_rage_6", "heal")/100


self:GetCaster():EmitSound("Troll.Bloodrage")
local particle_peffect = ParticleManager:CreateParticle("particles/troll_heal_buf.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
ParticleManager:SetParticleControl(particle_peffect, 0, self:GetCaster():GetAbsOrigin())
ParticleManager:SetParticleControl(particle_peffect, 2, self:GetCaster():GetAbsOrigin())
ParticleManager:ReleaseParticleIndex(particle_peffect)

self.particle = ParticleManager:CreateParticle(name, PATTACH_OVERHEAD_FOLLOW, self:GetParent())
self:AddParticle(self.particle, false, false, -1, false, false)

self.max = self:GetCaster():GetTalentValue("modifier_troll_rage_6", "max")

self:SetStackCount(self.max)

end


function modifier_troll_warlord_berserkers_rage_bloodrage:OnStackCountChanged(iStackCount)
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




function modifier_troll_warlord_berserkers_rage_bloodrage:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_ATTACK_LANDED,
	MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
	MODIFIER_EVENT_ON_TAKEDAMAGE
}
end




function modifier_troll_warlord_berserkers_rage_bloodrage:GetModifierDamageOutgoing_Percentage()
if not self:GetParent():HasModifier("modifier_troll_warlord_berserkers_rage_custom") then return end
return self.damage
end

function modifier_troll_warlord_berserkers_rage_bloodrage:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end
if params.ranged_attack then return end
if params.no_attack_cooldown then return end
if not params.target:IsHero() and not params.target:IsCreep() then return end

self.record = params.record

end



function modifier_troll_warlord_berserkers_rage_bloodrage:OnTakeDamage(params)
if not IsServer() then return end
if params.no_attack_cooldown then return end
if self:GetParent() ~= params.attacker then return end
if not params.record then return end
if not self.record then return end
if params.inflictor then return end


self:GetParent():GenericHeal(self.heal*params.damage, self:GetAbility(), true)

self.record = nil

self:DecrementStackCount()
if self:GetStackCount() == 0 then 
	self:Destroy()
end


end














modifier_troll_warlord_berserkers_rage_bloodrag_ranged = class({})
function modifier_troll_warlord_berserkers_rage_bloodrag_ranged:IsHidden() return false end
function modifier_troll_warlord_berserkers_rage_bloodrag_ranged:IsPurgable() return false end
function modifier_troll_warlord_berserkers_rage_bloodrag_ranged:GetTexture() return "buffs/rage_bloodrage" end

function modifier_troll_warlord_berserkers_rage_bloodrag_ranged:GetStatusEffectName()
  return "particles/status_fx/status_effect_beserkers_call.vpcf"
end
function modifier_troll_warlord_berserkers_rage_bloodrag_ranged:StatusEffectPriority()
    return 12
end


function modifier_troll_warlord_berserkers_rage_bloodrag_ranged:OnCreated(table)
self.damage = self:GetCaster():GetTalentValue("modifier_troll_rage_6", "damage")
if not IsServer() then return end

self.heal = self:GetCaster():GetTalentValue("modifier_troll_rage_6", "heal")/100
local name = "particles/troll_warlord/troll_char_ranged.vpcf"



self:GetCaster():EmitSound("Troll.Bloodrage")
local particle_peffect = ParticleManager:CreateParticle("particles/rare_orb_patrol.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
ParticleManager:SetParticleControl(particle_peffect, 0, self:GetCaster():GetAbsOrigin())
ParticleManager:SetParticleControl(particle_peffect, 2, self:GetCaster():GetAbsOrigin())
ParticleManager:ReleaseParticleIndex(particle_peffect)

self.particle = ParticleManager:CreateParticle(name, PATTACH_OVERHEAD_FOLLOW, self:GetParent())
self:AddParticle(self.particle, false, false, -1, false, false)

self.max = self:GetCaster():GetTalentValue("modifier_troll_rage_6", "max")

self:SetStackCount(self.max)

end


function modifier_troll_warlord_berserkers_rage_bloodrag_ranged:OnStackCountChanged(iStackCount)
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




function modifier_troll_warlord_berserkers_rage_bloodrag_ranged:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_ATTACK,
	MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
	MODIFIER_EVENT_ON_TAKEDAMAGE
}
end



function modifier_troll_warlord_berserkers_rage_bloodrag_ranged:GetModifierDamageOutgoing_Percentage()
if self:GetParent():HasModifier("modifier_troll_warlord_berserkers_rage_custom") then return end
return self.damage
end

function modifier_troll_warlord_berserkers_rage_bloodrag_ranged:OnAttack(params)
if not IsServer() then return end
if self:GetParent():HasModifier("modifier_troll_warlord_berserkers_rage_custom") then return end
if self:GetParent() ~= params.attacker then return end
if params.no_attack_cooldown then return end
if not params.target:IsHero() and not params.target:IsCreep() then return end

self.record = params.record

end



function modifier_troll_warlord_berserkers_rage_bloodrag_ranged:OnTakeDamage(params)
if not IsServer() then return end
if self:GetParent():HasModifier("modifier_troll_warlord_berserkers_rage_custom") then return end
if params.no_attack_cooldown then return end
if self:GetParent() ~= params.attacker then return end
if not params.record then return end
if not self.record then return end
if params.inflictor then return end


self:GetParent():GenericHeal(self.heal*params.damage, self:GetAbility(), true)

self.record = nil

self:DecrementStackCount()
if self:GetStackCount() == 0 then 
	self:Destroy()
end


end




















modifier_troll_warlord_berserkers_rage_cd = class({})
function modifier_troll_warlord_berserkers_rage_cd:IsHidden() return true end
function modifier_troll_warlord_berserkers_rage_cd:IsPurgable() return false end
function modifier_troll_warlord_berserkers_rage_cd:IsDebuff() return true end


modifier_troll_warlord_berserkers_rage_charge_cd = class({})
function modifier_troll_warlord_berserkers_rage_charge_cd:IsHidden() return true  end
function modifier_troll_warlord_berserkers_rage_charge_cd:IsPurgable() return false end
function modifier_troll_warlord_berserkers_rage_charge_cd:IsDebuff() return true end
function modifier_troll_warlord_berserkers_rage_charge_cd:RemoveOnDeath() return false end
function modifier_troll_warlord_berserkers_rage_charge_cd:GetTexture() return "buffs/rage_charge" end
function modifier_troll_warlord_berserkers_rage_charge_cd:OnCreated(table)
self.RemoveForDuel = true 

end









troll_warlord_rampage_custom = class({})


function troll_warlord_rampage_custom:GetCastPoint(iLevel)
if self:GetCaster():HasModifier('modifier_troll_warlord_battle_trance_custom') then 
    return 0
end

return self.BaseClass.GetCastPoint(self)
end


function troll_warlord_rampage_custom:GetCastRange(vLocation, hTarget)
return self:GetSpecialValueFor("range")
end




function troll_warlord_rampage_custom:OnSpellStart()

local point = self:GetCaster():GetAbsOrigin() + self:GetCaster():GetForwardVector()*self:GetSpecialValueFor("range")

local duration = self:GetSpecialValueFor("range")/self:GetSpecialValueFor("speed")

self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_troll_warlord_rampage_custom", {x = point.x, y = point.y, duration = duration})
end 









modifier_troll_warlord_rampage_custom = class({})

function modifier_troll_warlord_rampage_custom:IsDebuff() return false end
function modifier_troll_warlord_rampage_custom:IsHidden() return true end
function modifier_troll_warlord_rampage_custom:IsPurgable() return true end

function modifier_troll_warlord_rampage_custom:OnCreated(kv)
if not IsServer() then return end
self:GetParent():StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_4, 0.7)

self.turn_speed = 70
self.target_angle = self:GetParent():GetAnglesAsVector().y
self.current_angle = self.target_angle
self.face_target = true

self.speed = self:GetAbility():GetSpecialValueFor("speed")

self:GetParent():EmitSound("Troll.Rampage")

self.point = GetGroundPosition(Vector(kv.x, kv.y, 0), nil)

self:GetParent():EmitSound("Lc.Odds_Charge")

self.angle = self:GetParent():GetForwardVector():Normalized()--(self.point - self:GetParent():GetAbsOrigin()):Normalized() 

self.distance = (self.point - self:GetCaster():GetAbsOrigin()):Length2D() / ( self:GetDuration() / FrameTime())

self.knock_distance = self:GetAbility():GetSpecialValueFor("knock_distance")
self.knock_height = self:GetAbility():GetSpecialValueFor("knock_distance")
self.knock_duration = self:GetAbility():GetSpecialValueFor("knock_duration")
self.knock_radius = self:GetAbility():GetSpecialValueFor("knock_radius")
self.knock_stun = self:GetAbility():GetSpecialValueFor("stun")

self.main_ability = self:GetParent():FindAbilityByName("troll_warlord_berserkers_rage_custom")

if not self.main_ability then 
	self:Destroy()
	return
end

self.targets = {}

if self:ApplyHorizontalMotionController() == false then
    self:Destroy()
end

end

function modifier_troll_warlord_rampage_custom:GetEffectName() return "particles/troll_haste.vpcf" end

function modifier_troll_warlord_rampage_custom:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_DISABLE_TURNING,
  MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	MODIFIER_EVENT_ON_ORDER,
}
end


function modifier_troll_warlord_rampage_custom:OnOrder( params )
	if params.unit~=self:GetParent() then return end

	if params.order_type==DOTA_UNIT_ORDER_MOVE_TO_POSITION then
		self:SetDirection( params.new_pos )
	elseif
		params.order_type==DOTA_UNIT_ORDER_MOVE_TO_DIRECTION
	then
		self:SetDirection( params.new_pos )
	elseif 
		params.order_type==DOTA_UNIT_ORDER_MOVE_TO_TARGET or
		params.order_type==DOTA_UNIT_ORDER_ATTACK_TARGET
	then
		self:SetDirection( params.target:GetOrigin() )
	elseif
		params.order_type==DOTA_UNIT_ORDER_STOP or 
		params.order_type==DOTA_UNIT_ORDER_CAST_TARGET or
		params.order_type==DOTA_UNIT_ORDER_CAST_POSITION or
		params.order_type==DOTA_UNIT_ORDER_HOLD_POSITION
	then
		self:Destroy()
	end	
end


function modifier_troll_warlord_rampage_custom:SetDirection( location )
	local dir = ((location-self:GetParent():GetOrigin())*Vector(1,1,0)):Normalized()
	self.target_angle = VectorToAngles( dir ).y
	self.face_target = false
end



function modifier_troll_warlord_rampage_custom:TurnLogic( dt )
	if self.face_target then return end
	local angle_diff = AngleDiff( self.current_angle, self.target_angle )
	local turn_speed = self.turn_speed*dt

	local sign = -1
	if angle_diff<0 then sign = 1 end

	if math.abs( angle_diff )<1.1*turn_speed then
		self.current_angle = self.target_angle
		self.face_target = true
	else
		self.current_angle = self.current_angle + sign*turn_speed
	end

	local angles = self:GetParent():GetAnglesAsVector()
	self:GetParent():SetLocalAngles( angles.x, self.current_angle, angles.z )
end




function modifier_troll_warlord_rampage_custom:GetOverrideAnimation()
return ACT_DOTA_RUN
end


function modifier_troll_warlord_rampage_custom:GetModifierDisableTurning() return 1 end

function modifier_troll_warlord_rampage_custom:GetStatusEffectName() return "particles/status_fx/status_effect_forcestaff.vpcf" end

function modifier_troll_warlord_rampage_custom:StatusEffectPriority() return 100 end

function modifier_troll_warlord_rampage_custom:OnDestroy()
if not IsServer() then return end
self:GetParent():InterruptMotionControllers( true )



local dir = self:GetParent():GetForwardVector()
dir.z = 0
self:GetParent():SetForwardVector(dir)
self:GetParent():FaceTowards(self:GetParent():GetAbsOrigin() + dir*10)

ResolveNPCPositions(self:GetParent():GetAbsOrigin(), 128)

end


function modifier_troll_warlord_rampage_custom:UpdateHorizontalMotion( me, dt )
if not IsServer() then return end

if self:GetParent():IsStunned() or self:GetParent():IsHexed() or self:GetParent():IsRooted() then 
	self:Destroy()
	return
end


for _,enemy in pairs(self:GetCaster():FindTargets(self.knock_radius)) do 

	if not self.targets[enemy] then 

		self.targets[enemy] = true

		enemy:EmitSound("Troll.Rampage_hit")


		local hit_effect = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_quad_tap_hit.vpcf", PATTACH_CUSTOMORIGIN, enemy)
		ParticleManager:SetParticleControlEnt(hit_effect, 0, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), false) 
		ParticleManager:SetParticleControlEnt(hit_effect, 1, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), false) 
		ParticleManager:ReleaseParticleIndex(hit_effect)

		local direction = enemy:GetOrigin()-self:GetCaster():GetOrigin()
		direction.z = 0
		direction = direction:Normalized()

		self.main_ability:ProcRoot(enemy, false, true)

		local knockbackProperties =
	  {
	      center_x = self:GetCaster():GetOrigin().x,
	      center_y = self:GetCaster():GetOrigin().y,
	      center_z = self:GetCaster():GetOrigin().z,
	      duration = self.knock_duration,
	      knockback_duration = self.knock_duration,
	      knockback_distance = self.knock_distance,
	      knockback_height = self.knock_height,
	    	should_stun = 0,
	  }
	  enemy:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_knockback", knockbackProperties )

	  self:Destroy()
	  return
	end

end 


self:TurnLogic( dt )
local nextpos = me:GetOrigin() + me:GetForwardVector() * self.speed * dt
me:SetOrigin(nextpos)

end

function modifier_troll_warlord_rampage_custom:OnHorizontalMotionInterrupted()
    self:Destroy()
end




function modifier_troll_warlord_rampage_custom:CheckState()
return
{
	[MODIFIER_STATE_SILENCED] = true,
	[MODIFIER_STATE_DISARMED] = true
}
end





modifier_troll_warlord_berserkers_rage_silence = class({})
function modifier_troll_warlord_berserkers_rage_silence:IsHidden() return true end
function modifier_troll_warlord_berserkers_rage_silence:IsPurgable() return true end
function modifier_troll_warlord_berserkers_rage_silence:CheckState()
return
{
  [MODIFIER_STATE_SILENCED] = true
}
end

function modifier_troll_warlord_berserkers_rage_silence:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end


function modifier_troll_warlord_berserkers_rage_silence:OnCreated()
self.slow = self:GetCaster():GetTalentValue("modifier_troll_rage_5", "speed")

self.particles = ParticleManager:CreateParticle("particles/items2_fx/sange_maim.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
self:AddParticle(self.particles, false, false, -1, false, false)

end

function modifier_troll_warlord_berserkers_rage_silence:GetEffectName() return "particles/generic_gameplay/generic_silenced.vpcf" end

function modifier_troll_warlord_berserkers_rage_silence:ShouldUseOverheadOffset() return true end
function modifier_troll_warlord_berserkers_rage_silence:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end

function modifier_troll_warlord_berserkers_rage_silence:GetModifierMoveSpeedBonus_Percentage()
return self.slow
end