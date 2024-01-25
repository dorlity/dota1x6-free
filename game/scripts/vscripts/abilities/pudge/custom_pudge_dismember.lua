LinkLuaModifier("modifier_custom_pudge_dismember","abilities/pudge/custom_pudge_dismember", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_pudge_dismember_pull", "abilities/pudge/custom_pudge_dismember", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_custom_pudge_dismember_visual", "abilities/pudge/custom_pudge_dismember", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_pudge_dismember_illusion", "abilities/pudge/custom_pudge_dismember", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_pudge_dismember_outgoing", "abilities/pudge/custom_pudge_dismember", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_pudge_dismember_legendary_ondeath", "abilities/pudge/custom_pudge_dismember", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_pudge_dismember_legendary_ondeath_cd", "abilities/pudge/custom_pudge_dismember", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_pudge_dismember_legendary_aura", "abilities/pudge/custom_pudge_dismember", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_pudge_dismember_devour", "abilities/pudge/custom_pudge_dismember", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_pudge_dismember_devour_caster", "abilities/pudge/custom_pudge_dismember", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_pudge_dismember_blood_str_buff", "abilities/pudge/custom_pudge_dismember", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_pudge_dismember_blood_str_buff_counter", "abilities/pudge/custom_pudge_dismember", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_pudge_dismember_bkb", "abilities/pudge/custom_pudge_dismember", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_pudge_dismember_break", "abilities/pudge/custom_pudge_dismember", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_pudge_dismember_no_tp", "abilities/pudge/custom_pudge_dismember", LUA_MODIFIER_MOTION_NONE)



custom_pudge_dismember = class({})

custom_pudge_dismember.bkb_duration = 1

custom_pudge_dismember.range_duration = {0.2, 0.4, 0.6}
custom_pudge_dismember.range_cast = {40, 60, 80}

custom_pudge_dismember.cd_init = -1
custom_pudge_dismember.cd_inc = -1

custom_pudge_dismember.outgoing_heal = {-20, -30, -40}
custom_pudge_dismember.outgoing_inc = {-10, -15, -20}
custom_pudge_dismember.outgoing_duration = 4

custom_pudge_dismember.legendary_cd = 40
custom_pudge_dismember.legendary_range = 250
custom_pudge_dismember.legendary_save_duration = 1.6
custom_pudge_dismember.legendary_ticks = 5



custom_pudge_dismember.blood_cd = {0.8, 1.2}
custom_pudge_dismember.blood_str = {8, 12}
custom_pudge_dismember.blood_str_duration = 18






function custom_pudge_dismember:Precache(context)

    
PrecacheResource( "particle", "particles/econ/items/pudge/pudge_arcana/pudge_arcana_dismember_default.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_pudge/pudge_dismember.vpcf", context )
PrecacheResource( "particle", "particles/brist_lowhp_.vpcf", context )
PrecacheResource( "particle", "particles/econ/items/dazzle/dazzle_dark_light_weapon/pudge_grave.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_life_stealer/life_stealer_loadout.vpcf", context )
PrecacheResource( "particle", "particles/pudge_swallow.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_pudge/pudge_swallow_release.vpcf", context )


end








function custom_pudge_dismember:GetIntrinsicModifierName()
if not self:GetCaster():HasModifier("modifier_custom_pudge_dismember_visual") then 
	return "modifier_custom_pudge_dismember_visual"
end 
	return 
end




function custom_pudge_dismember:GetChannelTime()

local k = 1

if self:GetCaster():IsIllusion() then 
	k = 0.5
end

if self:GetCaster():HasModifier("modifier_custom_pudge_dismember_visual") then 
	return self:GetCaster():GetModifierStackCount("modifier_custom_pudge_dismember_visual", self:GetCaster()) * 0.01 * k
end

end






function custom_pudge_dismember:GetCastRange(location, target)
local bonus = 0

if self:GetCaster():HasModifier("modifier_pudge_dismember_1") then 
	bonus = self.range_cast[self:GetCaster():GetUpgradeStack("modifier_pudge_dismember_1")]
end

    return self.BaseClass.GetCastRange(self, location, target) + bonus
end


function custom_pudge_dismember:GetChannelAnimation()
	return ACT_DOTA_CHANNEL_ABILITY_4
end

function custom_pudge_dismember:GetCooldown(level)
local bonus = 0
if self:GetCaster():HasModifier("modifier_pudge_dismember_3") then 
	bonus = self.cd_init + self.cd_inc*self:GetCaster():GetUpgradeStack("modifier_pudge_dismember_3")
end

    return self.BaseClass.GetCooldown( self, level ) + bonus
end

function custom_pudge_dismember:OnSpellStart(new_target)
if not IsServer() then return end



local target

if self:GetCaster():IsIllusion() then 
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_custom_pudge_dismember_illusion", {duration = self:GetChannelTime()})
end



if new_target ~= nil then
	target = new_target
else
	 target = self:GetCursorTarget()
end


if self:GetCaster():HasModifier("modifier_pudge_dismember_5") then 
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_generic_debuff_immune", {effect = 1, duration = self.bkb_duration})
end

if target:TriggerSpellAbsorb(self) then self:GetCaster():Interrupt() return end

self.target = target

target:AddNewModifier(self:GetCaster(), self, "modifier_custom_pudge_dismember", {duration = self:GetChannelTime()  })



end

function custom_pudge_dismember:OnChannelFinish(bInterrupted)


	if self.target then
		local target_buff = self.target:FindModifierByName("modifier_custom_pudge_dismember")
		if target_buff then

			target_buff:Destroy()
		end
	end



end


function custom_pudge_dismember:DealDamage(caster, target, tick)
if not IsServer() then return end

	self.dismember_damage	= self:GetSpecialValueFor("dismember_damage")
	self.strength_damage	= (self:GetSpecialValueFor("strength_damage"))

	self.strength_damage =  self.strength_damage * caster:GetStrength()

	self.damage = (self.dismember_damage + self.strength_damage)*tick

	if self:GetCaster():HasModifier("modifier_pudge_dismember_5") then 
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_generic_debuff_immune", {effect = 1,duration = self.bkb_duration})
		target:AddNewModifier(self:GetCaster(), self, "modifier_custom_pudge_dismember_break", {duration = self.bkb_duration})
	end


	local damageTable = { victim = target, attacker = caster, damage = self.damage, damage_type = DAMAGE_TYPE_MAGICAL, damage_flags = DOTA_DAMAGE_FLAG_NONE, ability = self}
	ApplyDamage(damageTable)


	if caster:HasModifier("modifier_pudge_dismember_2") then 
		target:AddNewModifier(caster, self, "modifier_custom_pudge_dismember_outgoing", {duration = self:GetCaster():GetTalentValue("modifier_pudge_dismember_2", "duration")})
	end

	target:EmitSound("Hero_Pudge.Dismember")

	if caster:GetQuest() == "Pudge.Quest_8" and target:IsRealHero() and caster:GetHealthPercent() < 100 then 
	  caster:UpdateQuest( math.floor( math.min( (caster:GetMaxHealth() - caster:GetHealth()), self.damage )))
	end


	caster:Heal(self.damage, self)
 	SendOverheadEventMessage(caster, 10, caster, self.damage, nil)


end










modifier_custom_pudge_dismember = class({})

function modifier_custom_pudge_dismember:IsDebuff() return true end
function modifier_custom_pudge_dismember:IsPurgeException() return true end
function modifier_custom_pudge_dismember:IsPurgable() return false end


function modifier_custom_pudge_dismember:CheckState()
	return {[MODIFIER_STATE_STUNNED] = true,}


end




function modifier_custom_pudge_dismember:DeclareFunctions()
	return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION}
end

function modifier_custom_pudge_dismember:GetOverrideAnimation()
	return ACT_DOTA_FLAIL
end

function modifier_custom_pudge_dismember:OnCreated()
if not IsServer() then return end

	if self:GetCaster():GetModelName() == "models/items/pudge/arcana/pudge_arcana_base.vmdl" then
		self.pfx = ParticleManager:CreateParticle("particles/econ/items/pudge/pudge_arcana/pudge_arcana_dismember_default.vpcf", PATTACH_ABSORIGIN, self:GetParent())
		ParticleManager:SetParticleControl(self.pfx, 1, self:GetParent():GetAbsOrigin())
		ParticleManager:SetParticleControl(self.pfx, 8, Vector(1, 1, 1))
		ParticleManager:SetParticleControl(self.pfx, 15, Vector(64, 9, 9))
	else
		self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_pudge/pudge_dismember.vpcf", PATTACH_ABSORIGIN, self:GetParent())
		ParticleManager:SetParticleControlEnt(self.pfx, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true)
	end

	self:AddParticle(self.pfx, false, false, -1, false, false)



	local tick = self:GetAbility():GetSpecialValueFor("ticks")
	if not self:GetCaster():IsAlive() then 
		self:Destroy()
		return
	end

	self.max = tick
	self.count = 0

	self.standard_tick_interval	= self:GetAbility():GetChannelTime() / tick 
	self:StartIntervalThink(self.standard_tick_interval)

	self:OnIntervalThink()
	self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_pudge_dismember_pull", {duration = self:GetAbility():GetChannelTime()})
end

function modifier_custom_pudge_dismember:OnIntervalThink()
if not IsServer() then return end
if self.count >= self.max then return end

	self.count = self.count + 1

	self:GetAbility():DealDamage(self:GetCaster(), self:GetParent(), self.standard_tick_interval)
end





function modifier_custom_pudge_dismember:OnDestroy()
if not IsServer() then return end

if self:GetCaster():IsChanneling() then
	self:GetAbility():EndChannel(false)
	self:GetCaster():MoveToPositionAggressive(self:GetParent():GetAbsOrigin())
end

if self:GetCaster():HasModifier("modifier_pudge_dismember_5") then 
	self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_pudge_dismember_break", {duration = self:GetAbility().bkb_duration})
end

end






modifier_custom_pudge_dismember_pull = class({})

function modifier_custom_pudge_dismember_pull:IsHidden() return true end

function modifier_custom_pudge_dismember_pull:OnCreated(params)
if not IsServer() then return end
	self.ability = self:GetAbility()
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.pull_units_per_second = self.ability:GetSpecialValueFor("pull_units_per_second")
	self.pull_distance_limit = self.ability:GetSpecialValueFor("pull_distance_limit")
	if self:ApplyHorizontalMotionController() == false then 
		self:Destroy()
		return
	end
end

function modifier_custom_pudge_dismember_pull:UpdateHorizontalMotion( me, dt )
	if not IsServer() then return end
	local distance = self.caster:GetOrigin() - me:GetOrigin()

	if distance:Length2D() > self.pull_distance_limit and 
		(self.parent:HasModifier("modifier_custom_pudge_dismember_legendary_aura") or self.parent:HasModifier("modifier_custom_pudge_dismember") ) then
		me:SetOrigin( me:GetOrigin() + distance:Normalized() * self.pull_units_per_second * dt )
	else
		self:Destroy()
	end
end

function modifier_custom_pudge_dismember_pull:OnDestroy()
	if not IsServer() then return end
	self.parent:RemoveHorizontalMotionController( self )
end
modifier_custom_pudge_dismember_visual = class({})


function modifier_custom_pudge_dismember_visual:IsHidden()	return true end
function modifier_custom_pudge_dismember_visual:IsPurgable()	return false end
function modifier_custom_pudge_dismember_visual:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE
end
function modifier_custom_pudge_dismember_visual:DeclareFunctions()
	local decFuncs = 
	{
		MODIFIER_EVENT_ON_ABILITY_EXECUTED,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_MIN_HEALTH

	}
	
	return decFuncs
end

function modifier_custom_pudge_dismember_visual:OnTakeDamage(params)
if not IsServer() then return end
if self:GetParent() ~= params.unit then return end
if params.attacker == self:GetParent() then return end
if self:GetParent():PassivesDisabled() then return end
if self:GetParent():HasModifier("modifier_death") then return end
if not self:GetParent():HasModifier("modifier_pudge_dismember_6") then return end
if self:GetParent():GetHealth() > 1 then return end
if self:GetParent():HasModifier("modifier_custom_pudge_dismember_legendary_ondeath_cd") then return end
if self:GetParent():HasModifier("modifier_custom_pudge_dismember_legendary_ondeath") then return end
if self:GetParent():HasModifier("modifier_up_res") and not self:GetParent():HasModifier("modifier_up_res_cd") then return end

self:GetParent():Purge(false, true, false, true, true)
self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_pudge_dismember_legendary_ondeath", {duration = self:GetAbility().legendary_save_duration + FrameTime()})

end

function modifier_custom_pudge_dismember_visual:GetMinHealth()
if not self:GetParent():IsAlive() then return end
if self:GetParent():HasModifier("modifier_death") then return end
if self:GetParent():PassivesDisabled() then return end
if not self:GetParent():HasModifier("modifier_pudge_dismember_6") then return end
if self:GetParent():HasModifier("modifier_custom_pudge_dismember_legendary_ondeath_cd") then return end
return 1
end




function modifier_custom_pudge_dismember_visual:OnCreated(table)
if not IsServer() then return end
	self:SetStackCount(300)
end

function modifier_custom_pudge_dismember_visual:OnAbilityExecuted(params)
if not IsServer() then return end
if params.ability == nil or not ( params.ability:GetCaster() == self:GetParent() ) then
   return
end

if self:GetParent():HasModifier("modifier_pudge_dismember_4") and 
  not params.ability:IsItem() and not params.ability:IsToggle() and
  not UnvalidAbilities[params.ability:GetName()] then 

	local particle_peffect = ParticleManager:CreateParticle("particles/brist_lowhp_.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	ParticleManager:SetParticleControl(particle_peffect, 0, self:GetCaster():GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_peffect, 2, self:GetCaster():GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(particle_peffect)

	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetCaster():GetPlayerOwnerID()), 'generic_sound',  {sound = "Pudge.Dismember_cd"})
				
	self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_pudge_dismember_blood_str_buff", {duration = self:GetAbility().blood_str_duration})
	self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_pudge_dismember_blood_str_buff_counter", {duration = self:GetAbility().blood_str_duration})


	local cd_reduce = self:GetAbility().blood_cd[self:GetCaster():GetUpgradeStack("modifier_pudge_dismember_4")]

	for abilitySlot = 0,8 do

		local ability = self:GetCaster():GetAbilityByIndex(abilitySlot)

		if ability ~= nil and ability ~= params.ability then

			local cd = ability:GetCooldownTimeRemaining()
			ability:EndCooldown()

			if cd > cd_reduce then 
				ability:StartCooldown(cd - cd_reduce)
			end

		end
	end

end




if params.ability == self:GetAbility() then
	local duration = self:GetAbility():GetSpecialValueFor("duration")

	if self:GetCaster():HasModifier("modifier_pudge_dismember_1") then 
		duration = duration + self:GetAbility().range_duration[self:GetCaster():GetUpgradeStack("modifier_pudge_dismember_1")]
	end

	print(duration)

	self:GetCaster():SetModifierStackCount("modifier_custom_pudge_dismember_visual", self:GetCaster(), duration * (1 - params.target:GetStatusResistance()) * 100)

end



end


modifier_custom_pudge_dismember_illusion = class({})
function modifier_custom_pudge_dismember_illusion:CheckState()
return
{
	[MODIFIER_STATE_STUNNED] = true
}
end

function modifier_custom_pudge_dismember_illusion:OnCreated(table)
if not IsServer() then return end
	self:GetParent():StartGesture(ACT_DOTA_CHANNEL_ABILITY_4)
end

function modifier_custom_pudge_dismember_illusion:OnDestroy()
if not IsServer() then return end
	self:GetParent():RemoveGesture(ACT_DOTA_CHANNEL_ABILITY_4)
end



modifier_custom_pudge_dismember_outgoing = class({})
function modifier_custom_pudge_dismember_outgoing:IsHidden() return false end
function modifier_custom_pudge_dismember_outgoing:IsPurgable() return true end
function modifier_custom_pudge_dismember_outgoing:GetTexture() return "buffs/dismember_damage" end

function modifier_custom_pudge_dismember_outgoing:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
	MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
	MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
	MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE
}
end


function modifier_custom_pudge_dismember_outgoing:GetModifierTotalDamageOutgoing_Percentage()
return self.damage
end


function modifier_custom_pudge_dismember_outgoing:GetModifierLifestealRegenAmplify_Percentage() 
    return self.heal
end

function modifier_custom_pudge_dismember_outgoing:GetModifierHealAmplify_PercentageTarget() 
return self.heal
end

function modifier_custom_pudge_dismember_outgoing:GetModifierHPRegenAmplify_Percentage() 
return self.heal
end


function modifier_custom_pudge_dismember_outgoing:OnCreated()

self.heal = self:GetCaster():GetTalentValue("modifier_pudge_dismember_2", "heal")
self.damage = self:GetCaster():GetTalentValue("modifier_pudge_dismember_2", "damage")

if not IsServer() then return end 

self.particles = ParticleManager:CreateParticle("particles/items2_fx/sange_maim.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
self:AddParticle(self.particles, false, false, -1, false, false)


self.particles2 = ParticleManager:CreateParticle("particles/items2_fx/sange_maim.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
self:AddParticle(self.particles2, false, false, -1, false, false)
end 






modifier_custom_pudge_dismember_legendary_ondeath_cd = class({})
function modifier_custom_pudge_dismember_legendary_ondeath_cd:IsHidden() return false end
function modifier_custom_pudge_dismember_legendary_ondeath_cd:IsDebuff() return true end
function modifier_custom_pudge_dismember_legendary_ondeath_cd:IsPurgable() return false end
function modifier_custom_pudge_dismember_legendary_ondeath_cd:RemoveOnDeath() return false end
function modifier_custom_pudge_dismember_legendary_ondeath_cd:OnCreated(table)
self.RemoveForDuel = true
end





modifier_custom_pudge_dismember_legendary_ondeath = class({})



function modifier_custom_pudge_dismember_legendary_ondeath:IsDebuff() return false end
function modifier_custom_pudge_dismember_legendary_ondeath:IsHidden() return true end
function modifier_custom_pudge_dismember_legendary_ondeath:IsPurgable() return false end

function modifier_custom_pudge_dismember_legendary_ondeath:OnCreated(table)
if not IsServer() then return end

self:GetParent():EmitSound("Pudge.Dismember_grave")
self.pfx = ParticleManager:CreateParticle("particles/econ/items/dazzle/dazzle_dark_light_weapon/pudge_grave.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
ParticleManager:SetParticleControl(self.pfx, 0,  self:GetCaster():GetAbsOrigin())

self:AddParticle(self.pfx,false, false, -1, false, false)


self:GetParent():Stop()
self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_pudge_dismember_legendary_ondeath_cd", {duration = self:GetAbility().legendary_cd})

self.radius = self:GetAbility().legendary_range

self.target = nil

if self:GetCaster():HasModifier("modifier_pudge_dismember_5") then 
	self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_pudge_dismember_bkb", {duration = self:GetAbility().bkb_duration})
end


self:StartIntervalThink(FrameTime())
end


function modifier_custom_pudge_dismember_legendary_ondeath:OnIntervalThink()
if not IsServer() then return end
if self.target ~= nil then return end

if self:GetParent():IsStunned() or self:GetParent():IsSilenced() or self:GetParent():GetForceAttackTarget() ~= nil or self:GetParent():IsHexed() then
	--self:Destroy()
end

local target_heroes = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
local target_creeps = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)

local targets = target_creeps

if #target_heroes > 0 then 
	targets = target_heroes
end

for _,target in pairs(targets) do 
	if not target:HasModifier("modifier_custom_pudge_dismember_legendary_aura") and target:GetUnitName() ~= "npc_teleport"
	and not target:HasModifier("modifier_monkey_king_wukongs_command_custom_soldier") and self.target == nil then

		self.target = target
		target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_pudge_dismember_legendary_aura", {duration = self:GetRemainingTime() - FrameTime()})
	end
end


end

function modifier_custom_pudge_dismember_legendary_ondeath:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MIN_HEALTH,
	MODIFIER_PROPERTY_OVERRIDE_ANIMATION
}
end

function modifier_custom_pudge_dismember_legendary_ondeath:GetOverrideAnimation()
return ACT_DOTA_CHANNEL_ABILITY_4
end

function modifier_custom_pudge_dismember_legendary_ondeath:GetMinHealth()
if not self:GetParent():IsAlive() then return end
if not self:GetParent():HasModifier("modifier_death") then return 1 end
end



function modifier_custom_pudge_dismember_legendary_ondeath:CheckState()
	return 
		{
			[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
			[MODIFIER_STATE_STUNNED] = true,
		}



end

function modifier_custom_pudge_dismember_legendary_ondeath:OnDestroy()
if not IsServer() then return end

if self.target then 
	self.target:RemoveModifierByName("modifier_custom_pudge_dismember_legendary_aura")
end

if self:GetCaster():HasModifier("modifier_pudge_dismember_5") then 
	self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_pudge_dismember_bkb", {duration = self:GetAbility().bkb_duration})
end
if self.pfx then
	ParticleManager:DestroyParticle(self.pfx, false)
	ParticleManager:ReleaseParticleIndex(self.pfx)
end
end








modifier_custom_pudge_dismember_legendary_aura = class({})

function modifier_custom_pudge_dismember_legendary_aura:IsDebuff() return true end

function modifier_custom_pudge_dismember_legendary_aura:CheckState()
	return {[MODIFIER_STATE_STUNNED] = true,}


end



 
function modifier_custom_pudge_dismember_legendary_aura:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end

function modifier_custom_pudge_dismember_legendary_aura:DeclareFunctions()
	return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION}
end

function modifier_custom_pudge_dismember_legendary_aura:GetOverrideAnimation()
	return ACT_DOTA_FLAIL
end

function modifier_custom_pudge_dismember_legendary_aura:OnCreated()
if not IsServer() then return end
local ability = self:GetCaster():FindAbilityByName("custom_pudge_dismember")
if not ability then return end


	if self:GetCaster():GetModelName() == "models/items/pudge/arcana/pudge_arcana_base.vmdl" then
		self.pfx = ParticleManager:CreateParticle("particles/econ/items/pudge/pudge_arcana/pudge_arcana_dismember_default.vpcf", PATTACH_ABSORIGIN, self:GetParent())
		ParticleManager:SetParticleControl(self.pfx, 1, self:GetParent():GetAbsOrigin())
		ParticleManager:SetParticleControl(self.pfx, 8, Vector(1, 1, 1))
		ParticleManager:SetParticleControl(self.pfx, 15, Vector(64, 9, 9))
	else
		self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_pudge/pudge_dismember.vpcf", PATTACH_ABSORIGIN, self:GetParent())
		ParticleManager:SetParticleControlEnt(self.pfx, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true)
	end

	self:AddParticle(self.pfx, false, false, -1, false, false)

	local mod = self:GetCaster():FindModifierByName("modifier_custom_pudge_dismember_legendary_ondeath")

	
	if not mod then return end

	local tick = self:GetAbility().legendary_ticks 

	self.standard_tick_interval	= self:GetAbility().legendary_save_duration / tick
	self:StartIntervalThink(self.standard_tick_interval)

	self:OnIntervalThink()
	self:GetParent():AddNewModifier(self:GetCaster(), ability, "modifier_custom_pudge_dismember_pull", {duration = self:GetRemainingTime()})
end



function modifier_custom_pudge_dismember_legendary_aura:OnIntervalThink()
if not IsServer() then return end
local ability = self:GetCaster():FindAbilityByName("custom_pudge_dismember")
if not ability then return end


	ability:DealDamage(self:GetCaster(), self:GetParent(), self.standard_tick_interval)
end










custom_pudge_dismember_devour = class({})

custom_pudge_dismember_devour.DisableAbilities = 
 {
 	["primal_beast_pulverize_custom"] = true,
 	["snapfire_mortimer_kisses_custom"] = true,
 }

function custom_pudge_dismember_devour:OnSpellStart()
if not IsServer() then return end
local target = self:GetCursorTarget()

if self:GetCaster():GetUnitName() ~= "npc_dota_hero_pudge" then return end

self:GetCaster():EmitSound("Pudge.Dismember_devour")
self:GetCaster():FadeGesture(ACT_DOTA_CHANNEL_ABILITY_4)


if target:TriggerSpellAbsorb(self) then 
	return
end

if target:IsCreep() then 

	local damage = target:GetMaxHealth()*self:GetSpecialValueFor("creeps_damage")/100

	target:SetHealth(math.max(1, target:GetHealth() - damage  ))

	if target:GetHealth() <= 1 then 
		target:Kill(self, self:GetCaster())
	end

	my_game:GenericHeal(self:GetCaster(), damage, self)

	local cd = self:GetCooldownTimeRemaining()
	self:EndCooldown()
	self:StartCooldown(cd/self:GetSpecialValueFor("creeps_cd"))
else 
	target:AddNewModifier(self:GetCaster(), self, "modifier_custom_pudge_dismember_devour", {duration = self:GetSpecialValueFor("duration")})
end

end


function custom_pudge_dismember_devour:OnAbilityPhaseStart()
if not IsServer() then return end
self:GetCaster():StartGesture(ACT_DOTA_CHANNEL_ABILITY_4)

self.target = self:GetCursorTarget()

self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_life_stealer/life_stealer_loadout.vpcf", PATTACH_POINT_FOLLOW, self.target)
ParticleManager:SetParticleControlEnt(self.particle,0,self.target,PATTACH_POINT_FOLLOW,"attach_hitloc",Vector(0,0,0),false )
ParticleManager:SetParticleControlEnt(self.particle,1,self:GetCaster(),PATTACH_POINT_FOLLOW,"attach_hitloc",Vector(0,0,0),false)
ParticleManager:ReleaseParticleIndex(self.particle)


return true
end
function custom_pudge_dismember_devour:OnAbilityPhaseInterrupted()
if not IsServer() then return end
self:GetCaster():FadeGesture(ACT_DOTA_CHANNEL_ABILITY_4)

if self.particle then 
	ParticleManager:ReleaseParticleIndex(self.particle)
	ParticleManager:DestroyParticle(self.particle, false)
end

end


modifier_custom_pudge_dismember_devour = class({})
function modifier_custom_pudge_dismember_devour:IsHidden() return true end
function modifier_custom_pudge_dismember_devour:IsPurgable() return false end
function modifier_custom_pudge_dismember_devour:OnCreated(table)
if not IsServer() then return end

self.RemoveForDuel = true

self.max_health = math.floor(self:GetAbility():GetSpecialValueFor("max_health")*self:GetCaster():GetMaxHealth()/100)
self.damage = 0

self.pfx = ParticleManager:CreateParticle("particles/pudge_swallow.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetCaster())
ParticleManager:SetParticleControl(self.pfx, 1, self:GetParent():GetAbsOrigin())
self:AddParticle(self.pfx, false, false, -1, true, true)

self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_pudge_dismember_no_tp", {})
self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_pudge_dismember_devour_caster", {target = self:GetParent():entindex()})

for abilitySlot = 0,8 do

	local ability = self:GetParent():GetAbilityByIndex(abilitySlot)

	if ability ~= nil and self:GetAbility().DisableAbilities[ability:GetName()] then
		ability:SetActivated(false)
	end
end

CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetCaster():GetPlayerOwnerID()), 'pudge_devour_change',  {caster = 1, max = self.max_health, damage = self.damage})
CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), 'pudge_devour_change',  {caster = 0, max = self.max_health, damage = self.damage})


self.count = self:GetAbility():GetSpecialValueFor("interval")*0.95
self.damage_target = (self:GetAbility():GetSpecialValueFor("damage")*self:GetAbility():GetSpecialValueFor("duration"))/(self:GetAbility():GetSpecialValueFor("duration") + 1)

self.interval = 0.05

self.NoDraw = true
self:GetParent():AddNoDraw()
self:StartIntervalThink(self.interval)
end




function modifier_custom_pudge_dismember_devour:OnIntervalThink()
if not IsServer() then return end

self.count = self.count + self.interval
if self.count >= self:GetAbility():GetSpecialValueFor("interval")*0.95 then 
	self.count = 0

	local damage = self:GetParent():GetMaxHealth()*self.damage_target/100
	self:GetParent():SetHealth(math.max(1, self:GetParent():GetHealth() - damage))

	my_game:GenericHeal(self:GetCaster(), damage, self:GetAbility())

	self:GetCaster():EmitSound("Pudge.Dismember_devour_tick")
end

if self:GetParent():GetHealth() <= 1 then 
	self:GetParent():Kill(self:GetAbility(), self:GetCaster())
	self:Destroy()
end

if not self:GetCaster() or self:GetCaster():IsNull() or not self:GetCaster():IsAlive() or not self:GetCaster():HasModifier("modifier_custom_pudge_dismember_devour_caster") then 
	self:Destroy()
	return
end

self:GetParent():SetOrigin(self:GetCaster():GetAbsOrigin() + self:GetCaster():GetForwardVector()*10)

end






function modifier_custom_pudge_dismember_devour:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_TAKEDAMAGE,
	MODIFIER_PROPERTY_DISABLE_HEALING
}
end


function modifier_custom_pudge_dismember_devour:GetDisableHealing() return 1 end


function modifier_custom_pudge_dismember_devour:OnTakeDamage(params)
if not IsServer() then return end
if self:GetCaster() ~= params.unit then return end

if self:GetCaster():GetHealth() <= 1 then 
	self:Destroy()
	return
end


if self:GetParent() ~= params.attacker then return end
if not self:GetCaster():IsAlive() then return end

self.damage = self.damage + params.damage 

CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetCaster():GetPlayerOwnerID()), 'pudge_devour_change',  {caster = 1, max = self.max_health, damage = self.damage})
CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), 'pudge_devour_change',  {caster = 0, max = self.max_health, damage = self.damage})

if self.damage >= self.max_health then 
	self:Destroy()
end

end



function modifier_custom_pudge_dismember_devour:CheckState()
return
{
	[MODIFIER_STATE_OUT_OF_GAME] = true,
	[MODIFIER_STATE_MAGIC_IMMUNE] = true,
	[MODIFIER_STATE_UNTARGETABLE] = true,
	[MODIFIER_STATE_UNSELECTABLE] = true,
	[MODIFIER_STATE_ROOTED] = true,
	[MODIFIER_STATE_NO_UNIT_COLLISION] = true,

}
end


function modifier_custom_pudge_dismember_devour:OnDestroy()
if not IsServer() then return end

self:GetCaster():RemoveModifierByName("modifier_custom_pudge_dismember_devour_caster")
self:GetCaster():RemoveModifierByName("modifier_custom_pudge_dismember_no_tp")
self:GetParent():RemoveNoDraw()

if self:GetCaster() then
	self:GetParent():SetOrigin(self:GetCaster():GetAbsOrigin() + self:GetCaster():GetForwardVector()*250)
end
self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_pudge/pudge_swallow_release.vpcf", PATTACH_WORLDORIGIN,  nil)
ParticleManager:SetParticleControl(self.pfx, 0, self:GetParent():GetAbsOrigin())

FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetAbsOrigin(), false)

CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetCaster():GetPlayerOwnerID()), 'pudge_devour_change',  {max = 0})
CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), 'pudge_devour_change',  {max = 0})


for abilitySlot = 0,8 do

	local ability = self:GetParent():GetAbilityByIndex(abilitySlot)

	if ability ~= nil and self:GetAbility().DisableAbilities[ability:GetName()] then
		ability:SetActivated(true)
	end
end

self:GetParent():EmitSound("Pudge.Dismember_devour_end")
end




modifier_custom_pudge_dismember_devour_caster = class({})
function modifier_custom_pudge_dismember_devour_caster:IsHidden() return true end
function modifier_custom_pudge_dismember_devour_caster:IsPurgable() return false end
function modifier_custom_pudge_dismember_devour_caster:OnCreated(table)
if not IsServer() then return end 

self.target = EntIndexToHScript(table.target)

self.RemoveForDuel = true
end 


function modifier_custom_pudge_dismember_devour_caster:OnDestroy()
if not IsServer() then return end 

if self.target and not self.target:IsNull() then 
	self.target:RemoveModifierByName("modifier_custom_pudge_dismember_devour")
end 


end 








modifier_custom_pudge_dismember_blood_str_buff = class({})
function modifier_custom_pudge_dismember_blood_str_buff:IsHidden() return true end
function modifier_custom_pudge_dismember_blood_str_buff:IsPurgable() return false end
function modifier_custom_pudge_dismember_blood_str_buff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_custom_pudge_dismember_blood_str_buff:OnDestroy()
if not IsServer() then return end
local mod = self:GetParent():FindModifierByName("modifier_custom_pudge_dismember_blood_str_buff_counter")
if mod then 
	mod:DecrementStackCount()
	if mod:GetStackCount() == 0 then 
		mod:Destroy()
	end
end

end

function modifier_custom_pudge_dismember_blood_str_buff:OnCreated(table)
self.RemoveForDuel = true 
end


modifier_custom_pudge_dismember_blood_str_buff_counter = class({})

function modifier_custom_pudge_dismember_blood_str_buff_counter:IsHidden() return false end
function modifier_custom_pudge_dismember_blood_str_buff_counter:GetTexture() return "buffs/hunger_str" end
function modifier_custom_pudge_dismember_blood_str_buff_counter:IsPurgable() return false end

function modifier_custom_pudge_dismember_blood_str_buff_counter:DeclareFunctions()
return
 { MODIFIER_PROPERTY_STATS_STRENGTH_BONUS } 
end

function modifier_custom_pudge_dismember_blood_str_buff_counter:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1) 
end


function modifier_custom_pudge_dismember_blood_str_buff_counter:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
end

function modifier_custom_pudge_dismember_blood_str_buff_counter:GetModifierBonusStats_Strength()

return self:GetAbility().blood_str[self:GetCaster():GetUpgradeStack("modifier_pudge_dismember_4")]*self:GetStackCount()
end









modifier_custom_pudge_dismember_bkb = class({})
function modifier_custom_pudge_dismember_bkb:IsHidden() return true end
function modifier_custom_pudge_dismember_bkb:IsPurgable() return false end 
function modifier_custom_pudge_dismember_bkb:GetEffectName() return "particles/items_fx/black_king_bar_avatar.vpcf" end
function modifier_custom_pudge_dismember_bkb:CheckState() return {[MODIFIER_STATE_MAGIC_IMMUNE] = true} end








modifier_custom_pudge_dismember_break = class({})
function modifier_custom_pudge_dismember_break:IsHidden() return true end
function modifier_custom_pudge_dismember_break:IsPurgable() return false end 
function modifier_custom_pudge_dismember_break:CheckState() return {[MODIFIER_STATE_PASSIVES_DISABLED] = true} end

function modifier_custom_pudge_dismember_break:GetEffectName() 
	return "particles/generic_gameplay/generic_break.vpcf" 

end
 
function modifier_custom_pudge_dismember_break:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end






modifier_custom_pudge_dismember_no_tp = class({})
function modifier_custom_pudge_dismember_no_tp:IsHidden() return true end
function modifier_custom_pudge_dismember_no_tp:IsPurgable() return false end