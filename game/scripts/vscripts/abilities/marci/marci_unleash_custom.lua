LinkLuaModifier( "modifier_marci_unleash_custom", "abilities/marci/marci_unleash_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_marci_unleash_custom_animation", "abilities/marci/marci_unleash_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_marci_unleash_custom_fury", "abilities/marci/marci_unleash_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_marci_unleash_custom_debuff", "abilities/marci/marci_unleash_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_marci_unleash_custom_recovery", "abilities/marci/marci_unleash_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_marci_unleash_custom_tracker", "abilities/marci/marci_unleash_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_marci_unleash_custom_rage", "abilities/marci/marci_unleash_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_marci_unleash_custom_silence", "abilities/marci/marci_unleash_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_marci_unleash_custom_combo", "abilities/marci/marci_unleash_custom", LUA_MODIFIER_MOTION_NONE )

marci_unleash_custom = class({})

marci_unleash_custom.legendary_max = 16
marci_unleash_custom.legendary_damage_count = 200
marci_unleash_custom.legendary_in_fight = 5
marci_unleash_custom.legendary_attack_rage = 1
marci_unleash_custom.legendary_skill_rage = 4
marci_unleash_custom.legendary_damage_rage = 1
marci_unleash_custom.legendary_duration = 4
marci_unleash_custom.legendary_duration_inc = 2

marci_unleash_custom.speed_move = {10, 15, 20}
marci_unleash_custom.speed_resist = {10, 15, 20}

marci_unleash_custom.hits_recovery = {-0.2, -0.3, -0.4}

marci_unleash_custom.hit_heal = {30, 45, 60}

marci_unleash_custom.heal_reduction = -35
marci_unleash_custom.heal_range = 150
marci_unleash_custom.heal_slow = 10


marci_unleash_custom.hit_cd = 0.8



function marci_unleash_custom:Precache(context)

PrecacheResource( "particle", 'particles/units/heroes/hero_marci/marci_unleash_pulse.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_marci/marci_unleash_cast.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_marci/marci_unleash_pulse_debuff.vpcf', context )
PrecacheResource( "particle", 'particles/status_fx/status_effect_snapfire_slow.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_marci/marci_unleash_buff.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_marci/marci_unleash_stack.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_marci/marci_unleash_attack.vpcf', context )
PrecacheResource( "particle", 'particles/marci_rage_proc.vpcf', context )
PrecacheResource( "particle", 'particles/marci_count.vpcf', context )

end






function marci_unleash_custom:OnSpellStart()
if not IsServer() then return end


	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor( "duration" )

	if self:GetCaster():HasScepter() then 
		caster:Purge( false, true, false, false, false )
	end
	
	caster:AddNewModifier( caster, self, "modifier_marci_unleash_custom", {duration = duration } )
end

function marci_unleash_custom:GetCooldown(iLevel)
local upgrade_cooldown = 0

if self:GetCaster():HasScepter() then  
	upgrade_cooldown = self:GetSpecialValueFor("scepter_cooldown_reduction")
end 

 return self.BaseClass.GetCooldown(self, iLevel) - upgrade_cooldown

end

function marci_unleash_custom:Pulse( center, target )

local radius = self:GetSpecialValueFor( "pulse_radius" )
local damage = self:GetSpecialValueFor( "pulse_damage" )



local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), center, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
local damageTable = { attacker = self:GetCaster(), damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self, }

for _,enemy in pairs(enemies) do

	local final_damage = damage

	if enemy:HasModifier("modifier_marci_unleash_custom_combo") then 
		final_damage = final_damage + enemy:FindModifierByName("modifier_marci_unleash_custom_combo"):GetStackCount()*self:GetCaster():GetTalentValue("modifier_marci_unleash_4", "damage")

	end



	damageTable.victim = enemy
	damageTable.damage = final_damage
	ApplyDamage(damageTable)

end


local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_marci/marci_unleash_pulse.vpcf", PATTACH_WORLDORIGIN, nil )
ParticleManager:SetParticleControl( particle, 0, center )
ParticleManager:SetParticleControl( particle, 1, Vector(radius,radius,radius))
ParticleManager:DestroyParticle(particle, false)
ParticleManager:ReleaseParticleIndex( particle )
EmitSoundOnLocationWithCaster( center, "Hero_Marci.Unleash.Pulse", self:GetCaster() )


end


function marci_unleash_custom:GetIntrinsicModifierName()
return "modifier_marci_unleash_custom_tracker"
end

modifier_marci_unleash_custom = class({})

function modifier_marci_unleash_custom:IsPurgable()
	return false
end

function modifier_marci_unleash_custom:OnCreated( kv )
	self.parent = self:GetParent()
	self.bonus_ms = self:GetAbility():GetSpecialValueFor( "bonus_movespeed" )
	if not IsServer() then return end

	local fury = self.parent:FindModifierByNameAndCaster( "modifier_marci_unleash_custom_fury", self.parent )
	if fury then
		fury:ForceDestroy()
	end

	self.parent:AddNewModifier( self.parent, self:GetAbility(), "modifier_marci_unleash_custom_fury", {mini = 0} )

	self:PlayEffects()

	self.hammer = self:GetCaster():GetTogglableWearable( DOTA_LOADOUT_TYPE_WEAPON )
	if self.hammer then
		self.hammer:AddEffects( EF_NODRAW )
	end
end

function modifier_marci_unleash_custom:OnRefresh( kv )
	self.bonus_ms = self:GetAbility():GetSpecialValueFor( "bonus_movespeed" )	
	if not IsServer() then return end
	self.mini = kv.mini
	self:PlayEffects()
end

function modifier_marci_unleash_custom:OnDestroy()
	if not IsServer() then return end

	local fury = self.parent:FindModifierByNameAndCaster( "modifier_marci_unleash_custom_fury", self.parent )
	if fury then
		fury:ForceDestroy()
	end

	local recovery = self.parent:FindModifierByNameAndCaster( "modifier_marci_unleash_custom_recovery", self.parent )
	if recovery then
		recovery:ForceDestroy()
	end
	if self.hammer then
		self.hammer:RemoveEffects( EF_NODRAW )	
	end
end

function modifier_marci_unleash_custom:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,

		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
	}
	return funcs
end


function modifier_marci_unleash_custom:GetModifierAttackRangeBonus()
if not self:GetParent():HasModifier('modifier_marci_unleash_5') then return end

return self:GetAbility().heal_range
end

function modifier_marci_unleash_custom:GetModifierMoveSpeedBonus_Percentage()

local bonus = 0

if self:GetCaster():HasModifier("modifier_marci_unleash_3") then 
	bonus = self:GetAbility().speed_move[self:GetCaster():GetUpgradeStack("modifier_marci_unleash_3")]
end


	return self.bonus_ms + bonus
end


function modifier_marci_unleash_custom:GetModifierStatusResistanceStacking()

local bonus = 0

if self:GetCaster():HasModifier("modifier_marci_unleash_3") then 
	bonus = self:GetAbility().speed_resist[self:GetCaster():GetUpgradeStack("modifier_marci_unleash_3")]
end

	return bonus
end




function modifier_marci_unleash_custom:GetActivityTranslationModifiers()
	return "no_hammer"
end

function modifier_marci_unleash_custom:PlayEffects()
	local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_marci/marci_unleash_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:DestroyParticle(particle, false )
	ParticleManager:ReleaseParticleIndex( particle )
	self:GetParent():EmitSound("Hero_Marci.Unleash.Cast")
end


modifier_marci_unleash_custom_animation = class({})

function modifier_marci_unleash_custom_animation:IsHidden()
	return true
end

function modifier_marci_unleash_custom_animation:IsPurgable()
	return false
end

function modifier_marci_unleash_custom_animation:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
	}

	return funcs
end

function modifier_marci_unleash_custom_animation:GetActivityTranslationModifiers()
	return "unleash"
end





modifier_marci_unleash_custom_debuff = class({})

function modifier_marci_unleash_custom_debuff:IsHidden()
	return false
end

function modifier_marci_unleash_custom_debuff:IsDebuff()
	return true
end

function modifier_marci_unleash_custom_debuff:IsPurgable()
	return true
end

function modifier_marci_unleash_custom_debuff:OnCreated( kv )
	self.as_slow = -self:GetAbility():GetSpecialValueFor( "pulse_attack_slow_pct" )
	self.ms_slow = -self:GetAbility():GetSpecialValueFor( "pulse_move_slow_pct" )

	if self:GetCaster():HasModifier("modifier_marci_unleash_5") then 
		self.ms_slow = self.ms_slow - self:GetAbility().heal_slow
	end

	if not IsServer() then return end
end

function modifier_marci_unleash_custom_debuff:OnRefresh( kv )
	self:OnCreated( kv )
end

function modifier_marci_unleash_custom_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
		MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE
	}

	return funcs
end










function modifier_marci_unleash_custom_debuff:GetModifierLifestealRegenAmplify_Percentage()
	if self:GetCaster():HasModifier("modifier_marci_unleash_5") then
		return self:GetAbility().heal_reduction
	end
	return 0
end


function modifier_marci_unleash_custom_debuff:GetModifierHealAmplify_PercentageTarget()
	if self:GetCaster():HasModifier("modifier_marci_unleash_5") then
		return self:GetAbility().heal_reduction
	end
	return 0
end

function modifier_marci_unleash_custom_debuff:GetModifierHPRegenAmplify_Percentage()
	if self:GetCaster():HasModifier("modifier_marci_unleash_5") then
		return self:GetAbility().heal_reduction
	end
	return 0
end





function modifier_marci_unleash_custom_debuff:GetModifierAttackSpeedBonus_Constant()
if not self:GetParent():IsCreep() then 
	return self.as_slow
end 

end

function modifier_marci_unleash_custom_debuff:GetModifierMoveSpeedBonus_Percentage()
	return self.ms_slow
end

function modifier_marci_unleash_custom_debuff:GetEffectName()
	return "particles/units/heroes/hero_marci/marci_unleash_pulse_debuff.vpcf"
end

function modifier_marci_unleash_custom_debuff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_marci_unleash_custom_debuff:GetStatusEffectName()
	return "particles/status_fx/status_effect_snapfire_slow.vpcf"
end

function modifier_marci_unleash_custom_debuff:StatusEffectPriority()
	return MODIFIER_PRIORITY_NORMAL
end









modifier_marci_unleash_custom_recovery = class({})

function modifier_marci_unleash_custom_recovery:IsHidden()
	return false
end

function modifier_marci_unleash_custom_recovery:IsDebuff()
	return true
end

function modifier_marci_unleash_custom_recovery:IsPurgable()
	return false
end

function modifier_marci_unleash_custom_recovery:OnCreated( kv )
	self.parent = self:GetParent()
	self.rate = self:GetAbility():GetSpecialValueFor( "recovery_fixed_attack_rate" )
	if not IsServer() then return end
	self.success = kv.success==1
end

function modifier_marci_unleash_custom_recovery:OnRefresh( kv )
	self:OnCreated( kv )
end

function modifier_marci_unleash_custom_recovery:OnDestroy()
if not IsServer() then return end

	local main = self.parent:FindModifierByNameAndCaster( "modifier_marci_unleash_custom", self.parent )

	if not main then return end
	if self.forced then return end

	self.parent:AddNewModifier( self.parent, self:GetAbility(), "modifier_marci_unleash_custom_fury", {mini = 0} )
end

function modifier_marci_unleash_custom_recovery:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_FIXED_ATTACK_RATE,
	}
	return funcs
end

function modifier_marci_unleash_custom_recovery:GetModifierFixedAttackRate( params )
	return self.rate
end

function modifier_marci_unleash_custom_recovery:ForceDestroy()
	self.forced = true
	self:Destroy()
end





modifier_marci_unleash_custom_fury = class({})

function modifier_marci_unleash_custom_fury:IsHidden()
	return false
end

function modifier_marci_unleash_custom_fury:IsDebuff()
	return false
end

function modifier_marci_unleash_custom_fury:IsPurgable()
	return false
end

function modifier_marci_unleash_custom_fury:OnCreated( kv )
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	self.bonus_as = self:GetAbility():GetSpecialValueFor( "flurry_bonus_attack_speed" )
	self.recovery = self:GetAbility():GetSpecialValueFor( "time_between_flurries" )
	self.charges = self:GetAbility():GetSpecialValueFor( "charges_per_flurry" )
	self.timer = self:GetAbility():GetSpecialValueFor( "max_time_window_per_hit" )



	if self:GetCaster():HasModifier("modifier_marci_unleash_1") then 
		self.recovery = self.recovery + self:GetAbility().hits_recovery[self:GetCaster():GetUpgradeStack("modifier_marci_unleash_1")]
	end

	self.damage_reduction = self:GetAbility():GetSpecialValueFor( "damage_reduction" )
	if not IsServer() then return end
	self.mini = kv.mini
	self.counter = self.charges
	self:SetStackCount( self.counter )
	self.success = 0

	self.animation = self.parent:AddNewModifier( self.parent, self.ability, "modifier_marci_unleash_custom_animation", {} )
	self:PlayEffects1()
	self:PlayEffects2( self.parent, self.counter )

end

function modifier_marci_unleash_custom_fury:OnDestroy()
	if not IsServer() then return end

	if not self.animation:IsNull() then
		self.animation:Destroy()
	end

	local main = self.parent:FindModifierByNameAndCaster( "modifier_marci_unleash_custom", self.parent )
	if not main then return end

	if self.forced then return end



	if self.mini == 1 then 
		self:GetParent():RemoveModifierByName("modifier_marci_unleash_custom")
		return
	end

	self.parent:AddNewModifier( self.parent, self.ability, "modifier_marci_unleash_custom_recovery", { duration = self.recovery, success = self.success, } )


end

function modifier_marci_unleash_custom_fury:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_IGNORE_ATTACKSPEED_LIMIT,
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
	}

	return funcs
end


function modifier_marci_unleash_custom_fury:GetModifierAttackRangeBonus()
if not self:GetParent():HasModifier('modifier_marci_unleash_5') then return end
if self:GetParent():HasModifier("modifier_marci_unleash_custom") then return end

return self:GetAbility().heal_range
end


function modifier_marci_unleash_custom_fury:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end
if params.target:IsBuilding() then return end


local duration = self:GetAbility():GetSpecialValueFor( "pulse_debuff_duration" )
if not params.target:IsMagicImmune() then 
	params.target:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_marci_unleash_custom_debuff", { duration = (1 - params.target:GetStatusResistance())*duration } )
end

if not self:GetCaster():HasModifier("modifier_marci_unleash_2") then return end 
if self:GetParent():HasModifier("modifier_marci_companion_run_custom_no_root") then return end

	local heal = self:GetAbility().hit_heal[self:GetCaster():GetUpgradeStack("modifier_marci_unleash_2")]

	self:GetParent():Heal(heal, self:GetAbility())

	 SendOverheadEventMessage(self:GetParent(), 10, self:GetParent(), heal, nil)

	 local particle = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	 ParticleManager:DestroyParticle(particle, false)
	 ParticleManager:ReleaseParticleIndex( particle )
end





function modifier_marci_unleash_custom_fury:GetModifierDamageOutgoing_Percentage()
if self:GetParent():HasModifier("modifier_marci_companion_run_custom_no_root") then return end
return self.damage_reduction
end

function modifier_marci_unleash_custom_fury:GetModifierAttackSpeed_Limit()
	return 1
end

function modifier_marci_unleash_custom_fury:OnAttack(params)
if self:GetParent() ~= params.attacker then return end
if self:GetParent():HasModifier("modifier_marci_companion_run_custom_no_root") then return end

	if self.mini == 0 then 
		self:StartIntervalThink( self.timer )
	end

	self.counter = self.counter - 1
	self:SetStackCount( self.counter )

	self:EditEffects2( self.counter )
	self:PlayEffects3( self.parent, params.target )

	if self.counter<=0 then
		self.success = 1

		if params.target:IsRealHero() and self:GetCaster():GetQuest() == "Marci.Quest_8" and not self:GetCaster():QuestCompleted() then 
			self:GetCaster():UpdateQuest(1)
		end

		self.ability:Pulse( params.target:GetOrigin(), params.target )



		if self:GetCaster():HasModifier("modifier_marci_unleash_4") then 
			params.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_marci_unleash_custom_combo", {duration = self:GetCaster():GetTalentValue("modifier_marci_unleash_4", "duration")})
		
		end


		if self:GetCaster():HasScepter() then 

			params.target:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_marci_unleash_custom_silence", { duration = self:GetAbility():GetSpecialValueFor("scepter_silence")*(1 - params.target:GetStatusResistance()) } )
		end

		if self:GetCaster():HasModifier("modifier_marci_unleash_6") then 

		    for i = 0, 8 do
		        local current_item = self:GetCaster():GetItemInSlot(i)
		  

		        if current_item and not NoCdItems[current_item:GetName()] then  
		          local cd = current_item:GetCooldownTimeRemaining()
		          current_item:EndCooldown()
		          if cd > self:GetAbility().hit_cd then 
		            current_item:StartCooldown(cd - self:GetAbility().hit_cd)
		          end
		 
		        end
		    end

		    for abilitySlot = 0,8 do

				local ability = self:GetCaster():GetAbilityByIndex(abilitySlot)

				if ability ~= nil then
					local cd = ability:GetCooldownTimeRemaining()
					ability:EndCooldown()
					if cd > self:GetAbility().hit_cd then 
						ability:StartCooldown(cd - self:GetAbility().hit_cd)
					end
				end
			end


		end
		self:Destroy()
	end

end

function modifier_marci_unleash_custom_fury:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_as
end

function modifier_marci_unleash_custom_fury:GetActivityTranslationModifiers()
	if self:GetStackCount()==1 then
		return "flurry_pulse_attack"
	end

	if self:GetStackCount()%2==0 then
		return "flurry_attack_b"
	end

	return "flurry_attack_a"
end

function modifier_marci_unleash_custom_fury:OnIntervalThink()
	self:Destroy()
end



function modifier_marci_unleash_custom_fury:ForceDestroy()
	self.forced = true
	self:Destroy()
end

function modifier_marci_unleash_custom_fury:ShouldUseOverheadOffset()
	return true
end

function modifier_marci_unleash_custom_fury:PlayEffects1()
	local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_marci/marci_unleash_buff.vpcf", PATTACH_POINT_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControlEnt( particle, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "eye_l", Vector(0,0,0), true )
	ParticleManager:SetParticleControlEnt( particle, 2, self:GetParent(), PATTACH_POINT_FOLLOW, "eye_r", Vector(0,0,0), true )
	ParticleManager:SetParticleControlEnt( particle, 3, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack1", Vector(0,0,0), true )
	ParticleManager:SetParticleControlEnt( particle, 4, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack2", Vector(0,0,0), true )
	ParticleManager:SetParticleControlEnt( particle, 5, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack1", Vector(0,0,0), true )
	ParticleManager:SetParticleControlEnt( particle, 6, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack2", Vector(0,0,0), true )
	self:AddParticle( particle, false, false, -1, false, false  )

	self:GetParent():EmitSound("Hero_Marci.Unleash.Charged")
	EmitSoundOnClient( "Hero_Marci.Unleash.Charged.2D", self:GetParent():GetPlayerOwner() )
end

function modifier_marci_unleash_custom_fury:PlayEffects2( caster, counter )
	local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_marci/marci_unleash_stack.vpcf", PATTACH_OVERHEAD_FOLLOW, caster )
	ParticleManager:SetParticleControl( particle, 1, Vector( 0, counter, 0 ) )
	self:AddParticle( particle, false, false, 1, false, true )
	self.particle = particle
end

function modifier_marci_unleash_custom_fury:EditEffects2( counter )
	ParticleManager:SetParticleControl( self.particle, 1, Vector( 0, counter, 0 ) )
end

function modifier_marci_unleash_custom_fury:PlayEffects3( caster, target )
	local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_marci/marci_unleash_attack.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
	ParticleManager:SetParticleControlEnt( particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true )
	ParticleManager:DestroyParticle(particle, false)
	ParticleManager:ReleaseParticleIndex( particle )
end


modifier_marci_unleash_custom_tracker = class({})
function modifier_marci_unleash_custom_tracker:IsHidden() return true end
function modifier_marci_unleash_custom_tracker:IsPurgable() return false end







modifier_marci_unleash_custom_rage = class({})
function modifier_marci_unleash_custom_rage:IsHidden() return true end
function modifier_marci_unleash_custom_rage:IsPurgable() return false end
function modifier_marci_unleash_custom_rage:RemoveOnDeath() return false end
function modifier_marci_unleash_custom_rage:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(0)
self.in_fight = false
self:StartIntervalThink(1)


CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), 'marci_rage_change',  {max = self:GetAbility().legendary_max, rage = 0})
	

self.skill_table = {
	["marci_grapple_custom"] = true,
	["marci_companion_run_custom"] = true,
	["marci_guardian_custom"] = true,
	["marci_unleash_custom"] = true,
	["marci_dispose_hits"] = true,
	["marci_dispose_jump"] = true,
	["marci_dispose_knockback"] = true,
	["marci_rebound_bounce_legendary"] = true
}
self.damage_count = 0
end

function modifier_marci_unleash_custom_rage:AddRage(count)
if not IsServer() then return end

if count < 0 then 
	self:SetStackCount(math.max(0, self:GetStackCount() + count))
else 
	self.in_fight = true
	self:SetStackCount(self:GetStackCount() + count)
	self:StartIntervalThink(self:GetAbility().legendary_in_fight)
end

if self:GetStackCount() >= self:GetAbility().legendary_max then 
	self:SetStackCount(0)
	local mod = self:GetParent():FindModifierByName("modifier_marci_unleash_custom")


	self:GetParent():EmitSound("Marci.Unleash_rage")

	if mod then 
		mod:SetDuration(mod:GetRemainingTime() + self:GetAbility().legendary_duration_inc, true)
	else 
	
		self:GetParent():AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_marci_unleash_custom_fury", {duration = self:GetAbility().legendary_duration, mini = 1} )
	end

	local particle_peffect = ParticleManager:CreateParticle("particles/marci_rage_proc.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControl(particle_peffect, 0, self:GetParent():GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_peffect, 2, self:GetParent():GetAbsOrigin())
	ParticleManager:DestroyParticle(particle_peffect, false)
	ParticleManager:ReleaseParticleIndex(particle_peffect)
end

CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), 'marci_rage_change',  {max = self:GetAbility().legendary_max, rage = self:GetStackCount()})
end


function modifier_marci_unleash_custom_rage:OnIntervalThink()
if not IsServer() then return end

self:AddRage(-1)

if self.in_fight == true then 
	self.in_fight = false
	self:StartIntervalThink(1)
end

end



function modifier_marci_unleash_custom_rage:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
	MODIFIER_EVENT_ON_ABILITY_EXECUTED,
	MODIFIER_EVENT_ON_TAKEDAMAGE,

}
end


function modifier_marci_unleash_custom_rage:GetModifierProcAttack_Feedback(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end

self:AddRage(self:GetAbility().legendary_attack_rage)
end



function modifier_marci_unleash_custom_rage:OnAbilityExecuted( params )
if not IsServer() then return end
if params.unit~=self:GetParent() then return end
if not params.ability then return end
if params.ability:IsItem() or params.ability:IsToggle() then return end
if not self.skill_table[params.ability:GetName()] then return end

self:AddRage(self:GetAbility().legendary_skill_rage)
end



function modifier_marci_unleash_custom_rage:OnTakeDamage(params)
if not IsServer() then return end
if self:GetParent() ~= params.unit then return end

local damage = params.damage


while damage > 0 do 
   self.damage_count = damage + self.damage_count

   if self.damage_count < self:GetAbility().legendary_damage_count then 
     damage = 0
   else 
     damage = self.damage_count - self:GetAbility().legendary_damage_count
     self.damage_count = 0
     self:AddRage(self:GetAbility().legendary_damage_rage)
   end

end


end






modifier_marci_unleash_custom_silence = class({})
function modifier_marci_unleash_custom_silence:IsHidden() return true end
function modifier_marci_unleash_custom_silence:IsPurgable() return true end
function modifier_marci_unleash_custom_silence:CheckState()
return
{
	[MODIFIER_STATE_SILENCED] = true
}
end

function modifier_marci_unleash_custom_silence:GetEffectName() return "particles/generic_gameplay/generic_silenced.vpcf" end
 
function modifier_marci_unleash_custom_silence:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end



modifier_marci_unleash_custom_combo = class({})
function modifier_marci_unleash_custom_combo:IsHidden() return false end
function modifier_marci_unleash_custom_combo:IsPurgable() return false end
function modifier_marci_unleash_custom_combo:GetTexture() return "buffs/unleash_combo" end
function modifier_marci_unleash_custom_combo:OnCreated(table)

self.max = self:GetCaster():GetTalentValue("modifier_marci_unleash_4", "max")
self.damage = self:GetCaster():GetTalentValue("modifier_marci_unleash_4", "damage")

if not IsServer() then return end
self:SetStackCount(1)
self.RemoveForDuel = true
end

function modifier_marci_unleash_custom_combo:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end

self:IncrementStackCount()
end


function modifier_marci_unleash_custom_combo:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOOLTIP
}
end


function modifier_marci_unleash_custom_combo:OnTooltip()
return self.damage
end



function modifier_marci_unleash_custom_combo:OnStackCountChanged(iStackCount)
if self:GetStackCount() == 1 then 
	local particle_cast = "particles/marci_count.vpcf"

	self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, self:GetStackCount(), 0 ) )

	self:AddParticle(self.effect_cast,false, false, -1, false, false)
else 

  ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, self:GetStackCount(), 0 ) )

end

end

