LinkLuaModifier("modifier_zuus_arc_lightning_custom", "abilities/zuus/zuus_arc_lightning_custom" , LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_zuus_arc_lightning_tracker", "abilities/zuus/zuus_arc_lightning_custom" , LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_zuus_arc_lightning_speed", "abilities/zuus/zuus_arc_lightning_custom" , LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_zuus_arc_lightning_speed_self", "abilities/zuus/zuus_arc_lightning_custom" , LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_zuus_arc_lightning_attack_stack", "abilities/zuus/zuus_arc_lightning_custom" , LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_zuus_arc_lightning_attack_stack_visual", "abilities/zuus/zuus_arc_lightning_custom" , LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_zuus_arc_lightning_absorb_cd", "abilities/zuus/zuus_arc_lightning_custom" , LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_zuus_arc_lightning_absorb_silence", "abilities/zuus/zuus_arc_lightning_custom" , LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_zuus_arc_lightning_incoming", "abilities/zuus/zuus_arc_lightning_custom" , LUA_MODIFIER_MOTION_NONE)

zuus_arc_lightning_custom = class({})



zuus_arc_lightning_custom.attack_chance = {15, 20, 25}
zuus_arc_lightning_custom.attack_bounces = 1

zuus_arc_lightning_custom.speed_duration = 3
zuus_arc_lightning_custom.speed_max = 4
zuus_arc_lightning_custom.speed_slow = {-4, -6, -8}
zuus_arc_lightning_custom.speed_self = {4, 6, 8}


zuus_arc_lightning_custom.absorb_cd = 20
zuus_arc_lightning_custom.absorb_speed = -100
zuus_arc_lightning_custom.absorb_duration = 1.5

zuus_arc_lightning_custom.cd_reduction = -0.6
zuus_arc_lightning_custom.cd_damage = -20
zuus_arc_lightning_custom.cd_health = 30



function zuus_arc_lightning_custom:Precache(context)
PrecacheResource( "particle", 'particles/units/heroes/hero_zuus/z_w.vpcf', context )


PrecacheResource( "particle", 'particles/units/heroes/hero_zuus/zuus_arc_lightning_head.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_zuus/zuus_arc_lightning.vpcf', context )
PrecacheResource( "particle", 'particles/zuus_linken.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_zuus/zuus_shard.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_zuus/zuus_shard_slow.vpcf', context )
PrecacheResource( "particle", 'particles/zuus_speed.vpcf', context )
PrecacheResource( "particle", 'particles/zeus_magic_attack.vpcf', context )
PrecacheResource( "particle", 'particles/econ/items/zeus/arcana_chariot/zeus_arcana_blink_end.vpcf', context )
PrecacheResource( "particle", 'articles/units/heroes/hero_vengeful/vengeful_swap_buff_overhead.vpcf', context )

end



function zuus_arc_lightning_custom:GetCooldown(iLevel)

local bonus = 0
if self:GetCaster():HasModifier("modifier_zuus_arc_lightning_incoming") then 
  bonus = self.cd_reduction
end

 return self.BaseClass.GetCooldown(self, iLevel) + bonus
 
end





function zuus_arc_lightning_custom:GetIntrinsicModifierName()
if not self:GetCaster():HasModifier("modifier_zuus_arc_lightning_tracker") then 
	return "modifier_zuus_arc_lightning_tracker"
end 
	return 
end



function zuus_arc_lightning_custom:OnSpellStart(new_target)
	if not IsServer() then return end
	local target = self:GetCursorTarget()
	if new_target then 
		target = new_target
	end


	if self:GetCaster():HasModifier("modifier_zuus_arc_4") then 
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_zuus_arc_lightning_attack_stack", {duration = self:GetCaster():GetTalentValue("modifier_zuus_arc_4", "duration")})
	end


	if target:TriggerSpellAbsorb(self) then return end

	if self:GetCaster():GetQuest() == "Zuus.Quest_5" and target:IsRealHero() and not self:GetCaster():QuestCompleted() and (self:GetCaster():GetAbsOrigin() - target:GetAbsOrigin()):Length2D() <= self:GetCaster().quest.number then 
		self:GetCaster():UpdateQuest(1)
	end

	if self:GetCaster():HasModifier("modifier_zuus_jump_4") then 
		local ability = self:GetCaster():FindAbilityByName("zuus_heavenly_jump_custom")

		if ability and ability:GetLevel() > 0 then 
			self:GetCaster():AddNewModifier(self:GetCaster(), ability, "modifier_zuus_heavenly_jump_custom_attack_speed", {duration = ability.speed_duration})
		end
	end


	self:StartArc(target, self:GetSpecialValueFor("jump_count"), false)
end



function zuus_arc_lightning_custom:StartArc(target, bounces, not_cast, shard_cast)
if not IsServer() then return end


self:GetCaster():EmitSound("Hero_Zuus.ArcLightning.Cast")

local head_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning_head.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
ParticleManager:SetParticleControlEnt(head_particle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(head_particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
ParticleManager:ReleaseParticleIndex(head_particle)

self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_zuus_arc_lightning_custom", {shard_cast = shard_cast, not_cast = not_cast, starting_unit_entindex = target:entindex(), bounces = bounces })
end





modifier_zuus_arc_lightning_custom = class({})

function modifier_zuus_arc_lightning_custom:IsHidden()		return true end
function modifier_zuus_arc_lightning_custom:IsPurgable()		return false end
function modifier_zuus_arc_lightning_custom:RemoveOnDeath()	return false end
function modifier_zuus_arc_lightning_custom:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_zuus_arc_lightning_custom:OnCreated(keys)
if not IsServer() or not self:GetAbility() then return end

	self.arc_damage			= self:GetAbility():GetSpecialValueFor("arc_damage")

	self.damage_inc = self:GetCaster():GetTalentValue("modifier_zuus_arc_1", "damage")/100

	self.total_damage = 1

	self.shard_cast = keys.shard_cast

	if self.shard_cast == 1 then 
		local ability = self:GetParent():FindAbilityByName("zuus_lightning_hands_custom")

		self.total_damage = ability:GetSpecialValueFor("damage")/100

		if self:GetParent():IsIllusion() then 
			self.total_damage = ability:GetSpecialValueFor("damage_illusions")/100
		end

	end


	self.legendary_heal = self:GetCaster():GetTalentValue("modifier_zuus_arc_7", "heal")/100
	self.legendary_damage = self:GetCaster():GetTalentValue("modifier_zuus_arc_7", "damage")/100

	self.radius				= self:GetAbility():GetSpecialValueFor("radius")
	self.jump_count			= keys.bounces
	self.jump_delay			= self:GetAbility():GetSpecialValueFor("jump_delay")
	self.starting_unit_entindex	= keys.starting_unit_entindex
	self.units_affected			= {}
	self.max_per_target = 1

	self.not_cast = keys.not_cast

	if self:GetCaster():HasModifier("modifier_zuus_arc_7") and not self.shard_cast then 
		self.max_per_target = self:GetCaster():GetTalentValue("modifier_zuus_arc_7", "max")
	end
	

	if self:GetCaster():HasModifier("modifier_zuus_arc_2") then 
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_zuus_arc_lightning_speed_self", {duration = self:GetAbility().speed_duration})
	end


	if self.starting_unit_entindex and EntIndexToHScript(self.starting_unit_entindex) then
		self.current_unit						= EntIndexToHScript(self.starting_unit_entindex)
		self.units_affected[self.current_unit]	= 1

		self:DoDamage(self.current_unit, self.not_cast, self.total_damage)


	else
		self:Destroy()
		return
	end

	self.unit_counter			= 0
	self:StartIntervalThink(self.jump_delay)
end


function modifier_zuus_arc_lightning_custom:DoDamage(target, not_cast, damage_k)
if not IsServer() then return end



if self:GetCaster():HasModifier("modifier_zuus_arc_2") then 
	target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_zuus_arc_lightning_speed", {duration = self:GetAbility().speed_duration*(1 - target:GetStatusResistance())})
end

local damage = self.arc_damage

local k = self:GetAbility():GetSpecialValueFor("arc_damage_health")

local health_damage = target:GetHealth()*k/100

if target:IsCreep() then 
	health_damage = health_damage/self:GetAbility():GetSpecialValueFor("creeps_damage")
end

damage = damage + health_damage




if self:GetCaster():HasModifier("modifier_zuus_arc_1") then 
	damage = damage*(1 + self.damage_inc)
end 

if damage_k then 
	damage = damage*damage_k
end

ApplyDamage({ victim = target, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, damage_flags = DOTA_DAMAGE_FLAG_NONE, attacker = self:GetCaster(), ability = self:GetAbility() })
target:EmitSound("Hero_Zuus.ArcLightning.Target")
end



function modifier_zuus_arc_lightning_custom:OnIntervalThink()
self.zapped = false

local team = DOTA_UNIT_TARGET_TEAM_ENEMY

if self:GetCaster():HasModifier("modifier_zuus_arc_7") and not self.shard_cast then 
	team = DOTA_UNIT_TARGET_TEAM_BOTH
end

for _, enemy in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self.current_unit:GetAbsOrigin(), nil, self.radius, team, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false)) do
	
	if (not self.units_affected[enemy] or self.units_affected[enemy] < self.max_per_target) 
		and enemy ~= self.current_unit 
		and enemy:GetUnitName() ~= "npc_teleport"
		and (enemy:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() or enemy == self:GetCaster()) then
		
		

		self.lightning_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.current_unit)
		ParticleManager:SetParticleControlEnt(self.lightning_particle, 0, self.current_unit, PATTACH_POINT_FOLLOW, "attach_hitloc", self.current_unit:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(self.lightning_particle, 1, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(self.lightning_particle)
	
		self.unit_counter						= self.unit_counter + 1
		self.previous_unit						= self.current_unit
		self.current_unit						= enemy
		
		local k = self.total_damage
		if self.units_affected[self.current_unit] then
			self.units_affected[self.current_unit]	= self.units_affected[self.current_unit] + 1
			k = self.legendary_damage
		else
			self.units_affected[self.current_unit]	= 1
		end
		
		self.zapped								= true
		

		if enemy:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then 
			self:DoDamage(enemy, self.not_cast, k)
		else 
			local heal = self.legendary_heal*(enemy:GetMaxHealth() - enemy:GetHealth())

			self:GetParent():GenericHeal(heal, self:GetAbility())
		end

		break
	end
end

if (self.unit_counter >= self.jump_count and self.jump_count > 0) or not self.zapped then
	self:StartIntervalThink(-1)
	self:Destroy()
end
end


modifier_zuus_arc_lightning_tracker = class({})
function modifier_zuus_arc_lightning_tracker:IsHidden() return true end
function modifier_zuus_arc_lightning_tracker:IsPurgable() return false end
function modifier_zuus_arc_lightning_tracker:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_ATTACK_LANDED,
	MODIFIER_PROPERTY_ABSORB_SPELL
}
end


function modifier_zuus_arc_lightning_tracker:OnCreated(table)
if not IsServer() then return end

self:StartIntervalThink(0.2)
end


function modifier_zuus_arc_lightning_tracker:OnIntervalThink()
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_zuus_arc_5") then return end
if not self:GetParent():IsAlive() then return end

local mod = self:GetParent():FindModifierByName("modifier_zuus_arc_lightning_incoming")

if not mod and self:GetParent():GetHealthPercent() <= self:GetAbility().cd_health then 
	self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_zuus_arc_lightning_incoming", {})
end

if mod and self:GetParent():GetHealthPercent() > self:GetAbility().cd_health then 
	mod:Destroy()
end


end



function modifier_zuus_arc_lightning_tracker:GetAbsorbSpell(params) 
if not IsServer() then return end
if not params.ability then return end
if not params.ability:GetCaster() then return end

local caster = params.ability:GetCaster()

if caster:GetTeamNumber() == self:GetParent():GetTeamNumber() then return end
if not self:GetCaster():HasModifier("modifier_zuus_arc_6") then return end
if self:GetCaster():HasModifier("modifier_zuus_arc_lightning_absorb_cd") then return end
if caster == self:GetParent() then return end
if not caster:IsHero() and not caster:IsCreep() then return end
if caster:IsMagicImmune() then return end

local particle = ParticleManager:CreateParticle("particles/zuus_linken.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControlEnt(particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
ParticleManager:ReleaseParticleIndex(particle)


local thunder = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_shard.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
ParticleManager:SetParticleControlEnt(thunder, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(thunder, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)

self:GetCaster():EmitSound("Zuus.Arc_absorb")

self:GetAbility():StartArc(caster, self:GetAbility():GetSpecialValueFor("jump_count"), true)

caster:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_zuus_arc_lightning_absorb_silence", {duration = self:GetAbility().absorb_duration*(1 - caster:GetStatusResistance())})

self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_zuus_arc_lightning_absorb_cd", {duration = self:GetAbility().absorb_cd})
return 0	
end





function modifier_zuus_arc_lightning_tracker:OnAttackLanded(params)
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_zuus_arc_3") then return end
if self:GetParent() ~= params.target then return end 

local unit = params.attacker

if self:GetParent():GetTeamNumber() == unit:GetTeamNumber() then return end
if unit:IsMagicImmune() or unit:IsBuilding() then return end

local chance = self:GetAbility().attack_chance[self:GetCaster():GetUpgradeStack("modifier_zuus_arc_3")]
local random = RollPseudoRandomPercentage(chance,75,self:GetCaster())


if not random then return end
self:GetAbility():StartArc(unit, self:GetAbility().attack_bounces, true)
end






modifier_zuus_arc_lightning_speed = class({})

function modifier_zuus_arc_lightning_speed:IsHidden() return false end
function modifier_zuus_arc_lightning_speed:IsPurgable() return true end
function modifier_zuus_arc_lightning_speed:GetTexture() return "buffs/arc_speed" end

function modifier_zuus_arc_lightning_speed:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
end

function modifier_zuus_arc_lightning_speed:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self:GetAbility().speed_max then return end
self:IncrementStackCount()

if self:GetStackCount() == self:GetAbility().speed_max then

	local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_zuus/zuus_shard_slow.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( particle, 0, self:GetParent():GetOrigin() )
	self:AddParticle( particle, false, false, -1, false, false ) 
	
end


end


function modifier_zuus_arc_lightning_speed:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end

function modifier_zuus_arc_lightning_speed:GetModifierMoveSpeedBonus_Percentage()
return self:GetStackCount()*self:GetAbility().speed_slow[self:GetCaster():GetUpgradeStack("modifier_zuus_arc_2")]
end



modifier_zuus_arc_lightning_speed_self = class({})

function modifier_zuus_arc_lightning_speed_self:IsHidden() return false end
function modifier_zuus_arc_lightning_speed_self:IsPurgable() return true end
function modifier_zuus_arc_lightning_speed_self:GetTexture() return "buffs/arc_speed" end

function modifier_zuus_arc_lightning_speed_self:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
end

function modifier_zuus_arc_lightning_speed_self:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self:GetAbility().speed_max then return end
self:IncrementStackCount()

if self:GetStackCount() == self:GetAbility().speed_max then

	local effect_cast = ParticleManager:CreateParticle( "particles/zuus_speed.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetAbsOrigin() )
	self:AddParticle( effect_cast, false, false, -1, false, false)
	
end


end


function modifier_zuus_arc_lightning_speed_self:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end

function modifier_zuus_arc_lightning_speed_self:GetModifierMoveSpeedBonus_Percentage()
return self:GetStackCount()*self:GetAbility().speed_self[self:GetCaster():GetUpgradeStack("modifier_zuus_arc_2")]
end


modifier_zuus_arc_lightning_attack_stack = class({})
function modifier_zuus_arc_lightning_attack_stack:IsHidden() return false end
function modifier_zuus_arc_lightning_attack_stack:IsPurgable() return false end
function modifier_zuus_arc_lightning_attack_stack:GetTexture() return "buffs/arc_stack" end
function modifier_zuus_arc_lightning_attack_stack:OnCreated(table)

self.max = self:GetCaster():GetTalentValue("modifier_zuus_arc_4", "max")
self.damage = self:GetCaster():GetTalentValue("modifier_zuus_arc_4", "damage")/100
self.stun = self:GetCaster():GetTalentValue("modifier_zuus_arc_4", "stun")
self.range = self:GetCaster():GetTalentValue("modifier_zuus_arc_4", "range")
self.creeps_damage = self:GetCaster():GetTalentValue("modifier_zuus_arc_4", "creeps")

if not IsServer() then return end
self:SetStackCount(1)
end

function modifier_zuus_arc_lightning_attack_stack:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end

self:IncrementStackCount()

if self:GetStackCount() >= self.max then 
	self:GetParent():EmitSound("Zuus.Arc_attack_max")
end 

end


function modifier_zuus_arc_lightning_attack_stack:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_ATTACK_LANDED,
	MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
	MODIFIER_PROPERTY_TOOLTIP
}
end


function modifier_zuus_arc_lightning_attack_stack:GetModifierAttackRangeBonus()
if self:GetStackCount() < self.max then return end 

return self.range
end



function modifier_zuus_arc_lightning_attack_stack:OnAttackLanded(params)
if not IsServer() then return end
if self:GetCaster() ~= params.attacker then return end
if not params.target:IsHero() and not params.target:IsCreep() then return end

local target = params.target
local damage = target:GetMaxHealth()*self.damage*self:GetStackCount()

if params.target:IsCreep() then 
	damage = damage/self.creeps_damage
end 

SendOverheadEventMessage(target, 4, target, damage, nil)
ApplyDamage({ victim = target, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, damage_flags = DOTA_DAMAGE_FLAG_NONE, attacker = self:GetCaster(), ability = self:GetAbility() })

local abs = params.target:GetAbsOrigin()
abs.z = abs.z + 100

local hit_effect = ParticleManager:CreateParticle("particles/zeus_magic_attack.vpcf", PATTACH_ABSORIGIN_FOLLOW, params.target)
ParticleManager:SetParticleControl(hit_effect, 0, abs)
ParticleManager:SetParticleControl(hit_effect, 1, abs)
ParticleManager:ReleaseParticleIndex(hit_effect)

if self:GetStackCount() == self.max then 
	target:EmitSound("Zuus.Arc_stun")
	target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stunned", {duration = (1 - target:GetStatusResistance())*self.stun})


	self.effect = ParticleManager:CreateParticle( "particles/econ/items/zeus/arcana_chariot/zeus_arcana_blink_end.vpcf", PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( self.effect,  0,target:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(self.effect)
else 
	target:EmitSound("Zuus.Arc_no_stun")
end

self:Destroy()
end


function modifier_zuus_arc_lightning_attack_stack:OnTooltip()
return 100*(self.damage)*self:GetStackCount()
end





modifier_zuus_arc_lightning_absorb_cd = class({})
function modifier_zuus_arc_lightning_absorb_cd:IsHidden() return false end
function modifier_zuus_arc_lightning_absorb_cd:IsPurgable() return false end
function modifier_zuus_arc_lightning_absorb_cd:IsDebuff() return true end
function modifier_zuus_arc_lightning_absorb_cd:OnCreated(table)
if not IsServer() then return end
self.RemoveForDuel = true 
end

function modifier_zuus_arc_lightning_absorb_cd:RemoveOnDeath() return false end
function modifier_zuus_arc_lightning_absorb_cd:GetTexture() return "buffs/arc_absorb" end


modifier_zuus_arc_lightning_absorb_silence = class({})
function modifier_zuus_arc_lightning_absorb_silence:IsHidden() return false end
function modifier_zuus_arc_lightning_absorb_silence:IsPurgable() return true end
function modifier_zuus_arc_lightning_absorb_silence:GetTexture() return "buffs/arc_absorb" end
function modifier_zuus_arc_lightning_absorb_silence:CheckState()
return
{
	[MODIFIER_STATE_SILENCED] = true
}
end

function modifier_zuus_arc_lightning_absorb_silence:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end
function modifier_zuus_arc_lightning_absorb_silence:GetModifierMoveSpeedBonus_Percentage()
return self:GetAbility().absorb_speed
end


function modifier_zuus_arc_lightning_absorb_silence:OnCreated(table)
if not IsServer() then return end
	local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_zuus/zuus_shard_slow.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( particle, 0, self:GetParent():GetOrigin() )
	self:AddParticle( particle, false, false, -1, false, false ) 
end


function modifier_zuus_arc_lightning_absorb_silence:GetEffectName() return "particles/generic_gameplay/generic_silenced.vpcf" end

function modifier_zuus_arc_lightning_absorb_silence:ShouldUseOverheadOffset() return true end
function modifier_zuus_arc_lightning_absorb_silence:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end






modifier_zuus_arc_lightning_incoming = class({})
function modifier_zuus_arc_lightning_incoming:IsHidden() return false end
function modifier_zuus_arc_lightning_incoming:IsPurgable() return false end
function modifier_zuus_arc_lightning_incoming:GetTexture() return "buffs/arc_damage" end
function modifier_zuus_arc_lightning_incoming:OnCreated(table)
if not IsServer() then return end
self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_vengeful/vengeful_swap_buff_overhead.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent())
ParticleManager:SetParticleControlEnt(self.particle, 0, self:GetParent(), PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(self.particle, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(self.particle, 5, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
self:AddParticle(self.particle, false, false, -1, false, false)
end



function modifier_zuus_arc_lightning_incoming:DeclareFunctions()
return 
{
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
}
end

function modifier_zuus_arc_lightning_incoming:GetModifierIncomingDamage_Percentage()
return self:GetAbility().cd_damage
end







modifier_zuus_arc_lightning_attack_stack_visual = class({})
function modifier_zuus_arc_lightning_attack_stack_visual:IsHidden() return true end
function modifier_zuus_arc_lightning_attack_stack_visual:IsPurgable() return false end
function modifier_zuus_arc_lightning_attack_stack_visual:RemoveOnDeath() return false end
function modifier_zuus_arc_lightning_attack_stack_visual:OnCreated(table)
if not IsServer() then return end
self.max = self:GetCaster():GetTalentValue("modifier_zuus_arc_4", "max", true)

self:StartIntervalThink(0.2)
end




function modifier_zuus_arc_lightning_attack_stack_visual:OnIntervalThink()
if not IsServer() then return end

local stack = 0
local mod = self:GetParent():FindModifierByName("modifier_zuus_arc_lightning_attack_stack")
if mod then 
	stack = mod:GetStackCount()
end

CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), 'zuus_bolt_change',  {max = self.max, damage = stack})
end