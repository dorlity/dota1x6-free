LinkLuaModifier("modifier_muerta_pierce_the_veil_custom", "abilities/muerta/muerta_pierce_the_veil_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_muerta_pierce_the_veil_custom_undisarm", "abilities/muerta/muerta_pierce_the_veil_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_muerta_pierce_the_veil_custom_tracker", "abilities/muerta/muerta_pierce_the_veil_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_muerta_pierce_the_veil_custom_amp_buff", "abilities/muerta/muerta_pierce_the_veil_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_muerta_pierce_the_veil_custom_scepter_buff", "abilities/muerta/muerta_pierce_the_veil_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_muerta_pierce_the_veil_custom_start", "abilities/muerta/muerta_pierce_the_veil_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_muerta_pierce_the_veil_custom_heal", "abilities/muerta/muerta_pierce_the_veil_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_muerta_pierce_the_veil_custom_slow", "abilities/muerta/muerta_pierce_the_veil_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_muerta_pierce_the_veil_custom_damage", "abilities/muerta/muerta_pierce_the_veil_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_muerta_pierce_the_veil_custom_shard", "abilities/muerta/muerta_pierce_the_veil_custom", LUA_MODIFIER_MOTION_NONE)


muerta_pierce_the_veil_custom = class({})

muerta_pierce_the_veil_custom.amp_duration = 6
muerta_pierce_the_veil_custom.amp_change = {1, 1.5, 2}
muerta_pierce_the_veil_custom.amp_max = 8

muerta_pierce_the_veil_custom.cd_inc = {-4, -6, -8}
muerta_pierce_the_veil_custom.duration_inc = {0.2, 0.3, 0.4}

muerta_pierce_the_veil_custom.fly_move = 30

muerta_pierce_the_veil_custom.heal_start = {8, 12, 16}
muerta_pierce_the_veil_custom.heal_after = {8, 12, 16}
muerta_pierce_the_veil_custom.heal_duration = 5

muerta_pierce_the_veil_custom.legendary_cd = 1
muerta_pierce_the_veil_custom.legendary_extend = 0.3

muerta_pierce_the_veil_custom.pull_range = 600
muerta_pierce_the_veil_custom.pull_mana = 0.5
muerta_pierce_the_veil_custom.pull_slow = -50
muerta_pierce_the_veil_custom.pull_slow_duration = 3
muerta_pierce_the_veil_custom.pull_duration = 0.4

muerta_pierce_the_veil_custom.damage_attacks = {3, 5}
muerta_pierce_the_veil_custom.damage_cast = {10, 15}
muerta_pierce_the_veil_custom.damage_duration = 5


function muerta_pierce_the_veil_custom:Precache(context)

    
PrecacheResource( "particle", "particles/sand_king/sand_pull.vpcf", context )
PrecacheResource( "particle", "particles/muerta/muerta_quest_item.vpcf", context )
PrecacheResource( "particle", "particles/muerta/muerta_attack_slow.vpcf", context )

PrecacheResource( "particle", "particles/muerta/muerta_absorb.vpcf", context )
PrecacheResource( "particle", "particles/muerta/muerta_absorb_active.vpcf", context )
end





function muerta_pierce_the_veil_custom:GetCastAnimation()
	return ACT_DOTA_CAST_ABILITY_4
end


function muerta_pierce_the_veil_custom:GetBehavior()

if self:GetCaster():HasModifier("modifier_muerta_veil_6") then 
	return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE
end

return DOTA_ABILITY_BEHAVIOR_NO_TARGET
end


function muerta_pierce_the_veil_custom:GetManaCost(iLevel)

local k = 1
if self:GetCaster():HasModifier("modifier_muerta_veil_6") then 
	k = self.pull_mana
end

return self.BaseClass.GetManaCost(self,iLevel) * k
end


function muerta_pierce_the_veil_custom:GetCooldown(level)
    local bonus = 0
    if self:GetCaster():HasModifier("modifier_muerta_veil_1") then
        bonus = self.cd_inc[self:GetCaster():GetUpgradeStack("modifier_muerta_veil_1")]
    end
    return self.BaseClass.GetCooldown( self, level ) + bonus
end


function muerta_pierce_the_veil_custom:LegendaryProc(reason)
if not IsServer() then return end

local cd = self.legendary_cd
local extend = self.legendary_extend


if self:GetCooldownTimeRemaining() > 0 then 
	local time = self:GetCooldownTimeRemaining()


	self:EndCooldown()
	self:StartCooldown(time - cd)

end

local mod_1 = self:GetCaster():FindModifierByName("modifier_muerta_pierce_the_veil_buff")
local mod_2 = self:GetCaster():FindModifierByName("modifier_muerta_pierce_the_veil_custom")

if mod_1 and mod_2 then 

	mod_1:SetDuration(mod_1:GetRemainingTime() + extend, true)
	mod_2:SetDuration(mod_2:GetRemainingTime() + extend, true)

end

end



function muerta_pierce_the_veil_custom:GetIntrinsicModifierName()
return "modifier_muerta_pierce_the_veil"
end

function muerta_pierce_the_veil_custom:GetCastRange(vLocation, hTarget)
if self:GetCaster():HasModifier("modifier_muerta_veil_6") then 
	return self.pull_range
end

return
end


function muerta_pierce_the_veil_custom:OnSpellStart()
	if not IsServer() then return end

	local duration = self:GetSpecialValueFor( "duration" )
	local transform_duration = self:GetSpecialValueFor( "transform_duration" )

	if self:GetCaster():HasModifier("modifier_muerta_veil_1") then 
		duration = duration + self.duration_inc[self:GetCaster():GetUpgradeStack("modifier_muerta_veil_1")]
	end


	self:GetCaster():Purge(false, true, false, false, false)
	ProjectileManager:ProjectileDodge( self:GetCaster() )

	if self:GetCaster():HasModifier("modifier_muerta_veil_3") then 
		self:GetCaster():GenericHeal(self:GetCaster():GetMaxHealth()*self.heal_start[self:GetCaster():GetUpgradeStack("modifier_muerta_veil_3")]/100, self)

		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_muerta_pierce_the_veil_custom_heal", {duration = self.heal_duration})
	end

	if self:GetCaster():HasModifier("modifier_muerta_veil_6") then 
		transform_duration = 0

		self:GetCaster():StartGesture(ACT_DOTA_CAST_ABILITY_4)
		local particle_cast = "particles/sand_king/sand_pull.vpcf"

		local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
		ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetAbsOrigin() )
		ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.pull_range, self.pull_range, self.pull_range ) )
		ParticleManager:ReleaseParticleIndex( effect_cast )


		local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), nil, self.pull_range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, 0, 0, false )

		for _,unit in pairs(units) do

			local dir = (self:GetCaster():GetAbsOrigin() -  unit:GetAbsOrigin()):Normalized()
			local point = self:GetCaster():GetAbsOrigin() - dir*100

			local distance = (point - unit:GetAbsOrigin()):Length2D()

			distance = math.max(100, distance)
			point = unit:GetAbsOrigin() + dir*distance

			unit:AddNewModifier(self:GetCaster(), self, "modifier_muerta_pierce_the_veil_custom_slow", {duration = (1 - unit:GetStatusResistance())*self.pull_slow_duration})
			unit:AddNewModifier( self:GetCaster(),  self,  "modifier_generic_arc",  
			{
			  target_x = point.x,
			  target_y = point.y,
			  distance = distance,
			  duration = self.pull_duration,
			  height = 0,
			  fix_end = false,
			  isStun = true,
			  activity = ACT_DOTA_FLAIL,
			})


		end


	else 
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_muerta_pierce_the_veil_custom_start", {duration = transform_duration})
	end

	self:GetCaster():RemoveModifierByName("modifier_muerta_pierce_the_veil_custom_damage")

	self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_muerta_pierce_the_veil_buff", {duration = duration + transform_duration} )
	self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_muerta_pierce_the_veil_custom", {duration = duration + transform_duration} )
	self:GetCaster():EmitSound("Hero_Muerta.PierceTheVeil.Cast")
end

modifier_muerta_pierce_the_veil_custom = class({})


function modifier_muerta_pierce_the_veil_custom:IsHidden() return true end

function modifier_muerta_pierce_the_veil_custom:IsPurgable()
	return false
end

function modifier_muerta_pierce_the_veil_custom:OnCreated( kv )
if not IsServer() then return end

 

if self:GetCaster():HasModifier("modifier_muerta_veil_5") then 

	self.blocked = 0

	self.particle = ParticleManager:CreateParticle("particles/muerta/muerta_absorb.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControlEnt(self.particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
	self:AddParticle(self.particle, false, false, -1, false, false)
end




self.max_time = self:GetRemainingTime()

self.interval = 0.1

local transform_duration = self:GetAbility():GetSpecialValueFor( "transform_duration" )

if self:GetCaster():HasModifier("modifier_muerta_veil_6") then 
	transform_duration = 0
end 
self.caster = self:GetParent()


if self:GetParent():HasModifier("modifier_muerta_veil_7") then 

	for i = 0, 8 do
	    local current_item = self.caster:GetItemInSlot(i)

	    if current_item and not NoCdItems[current_item:GetName()] then  
			local cooldown_mod = self.caster:AddNewModifier(self.caster, self:GetAbility(), "modifier_cooldown_speed", {ability = current_item:GetName(), is_item = true, cd_inc = 100})
			local name = self:GetName()

			cooldown_mod:SetEndRule(function()
				return self.caster:HasModifier(name)
			end)
	    end
	end

	for abilitySlot = 0,8 do

		local ability = self:GetCaster():GetAbilityByIndex(abilitySlot)

		if ability ~= nil then
			local cooldown_mod = self.caster:AddNewModifier(self.caster, self:GetAbility(), "modifier_cooldown_speed", {ability = ability:GetName(), cd_inc = 100})
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

if self:GetParent():HasModifier("modifier_muerta_veil_7") then 
	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), 'muerta_ulti_change',  {hide = 0, max_time = self.max_time, time = self:GetRemainingTime(), damage = self:GetRemainingTime()})
end


if self:GetCaster():HasModifier("modifier_muerta_veil_5") then 
	AddFOWViewer(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), self:GetParent():GetDayTimeVisionRange(), 0.1, false)
end

self:StartIntervalThink(self.interval)
end



function modifier_muerta_pierce_the_veil_custom:GetAbsorbSpell(params) 
if not IsServer() then return end
if not self:GetCaster():HasModifier("modifier_muerta_veil_5") then return end 
if params.ability:GetCaster():GetTeamNumber() == self:GetParent():GetTeamNumber() then return end
if self.blocked == 1 then return end 

local particle = ParticleManager:CreateParticle("particles/muerta/muerta_absorb_active.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControlEnt(particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
ParticleManager:ReleaseParticleIndex(particle)

if self.particle then 
	ParticleManager:DestroyParticle(self.particle, false)
	ParticleManager:ReleaseParticleIndex(self.particle)
end 

self.blocked = 1

self:GetParent():EmitSound("DOTA_Item.LinkensSphere.Activate")

return 1 
end






function modifier_muerta_pierce_the_veil_custom:DeclareFunctions()
local funcs = 
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	MODIFIER_PROPERTY_VISUAL_Z_DELTA,
	MODIFIER_EVENT_ON_ATTACK_LANDED,
    MODIFIER_EVENT_ON_ABILITY_EXECUTED,
	MODIFIER_PROPERTY_ABSORB_SPELL,
	MODIFIER_EVENT_ON_TAKEDAMAGE
}
return funcs
end



function modifier_muerta_pierce_the_veil_custom:OnAbilityExecuted( params )
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_muerta_veil_4") then return end
if params.unit~=self:GetParent() then return end
if not params.ability then return end
if params.ability:IsToggle() then return end
if UnvalidAbilities[params.ability:GetName()] then return end
if UnvalidItems[params.ability:GetName()] then return end
if params.ability:IsItem() and params.ability:GetCurrentCharges() > 0 then return end

self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_muerta_pierce_the_veil_custom_damage", {stack = self:GetAbility().damage_cast[self:GetCaster():GetUpgradeStack("modifier_muerta_veil_4")]})

end




function modifier_muerta_pierce_the_veil_custom:OnAttackLanded(params)
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_muerta_veil_4") then return end
if self:GetParent() ~= params.attacker then return end
if not params.target:IsHero() and not params.target:IsCreep() then return end

self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_muerta_pierce_the_veil_custom_damage", {stack = self:GetAbility().damage_attacks[self:GetCaster():GetUpgradeStack("modifier_muerta_veil_4")]})


end




function modifier_muerta_pierce_the_veil_custom:OnDestroy()
if not IsServer() then return end

CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), 'muerta_ulti_change',  {hide = 1, max_time = self.max_time, time = self:GetRemainingTime(), damage = self:GetRemainingTime()})


self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_muerta_pierce_the_veil_custom_shard", {duration = self:GetAbility():GetSpecialValueFor("shard_bonus")})

if not self:GetParent():HasModifier("modifier_muerta_pierce_the_veil_custom_damage") then return end

self:GetParent():FindModifierByName("modifier_muerta_pierce_the_veil_custom_damage"):SetDuration(self:GetAbility().damage_duration, true)
end


function modifier_muerta_pierce_the_veil_custom:OnTakeDamage(params)
if not IsServer() then return end
if not self:GetParent():HasShard() then return end
if params.attacker ~= self:GetParent() then return end
if not params.unit:IsHero() and not params.unit:IsCreep() then return end
if bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then return end
if not params.inflictor then return end

local heal = self:GetAbility():GetSpecialValueFor("shard_lifesteal")*params.damage/100

self:GetParent():GenericHeal(heal, self:GetAbility(), true, "particles/items3_fx/octarine_core_lifesteal.vpcf")

end



function modifier_muerta_pierce_the_veil_custom:GetVisualZDelta()
if not self:GetCaster():HasModifier("modifier_muerta_veil_5") then return end
return 50
end


function modifier_muerta_pierce_the_veil_custom:GetModifierMoveSpeedBonus_Percentage()
if not self:GetCaster():HasModifier("modifier_muerta_veil_5") then return end

return self:GetAbility().fly_move
end

function modifier_muerta_pierce_the_veil_custom:CheckState()
if not self:GetCaster():HasModifier("modifier_muerta_veil_5") then return end
	local state = 
	{
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
	}
	return state
end










modifier_muerta_pierce_the_veil_custom_tracker = class({})
function modifier_muerta_pierce_the_veil_custom_tracker:IsHidden() return true end
function modifier_muerta_pierce_the_veil_custom_tracker:IsPurgable() return false end
function modifier_muerta_pierce_the_veil_custom_tracker:RemoveOnDeath() return false end
function modifier_muerta_pierce_the_veil_custom_tracker:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_DEATH,
  MODIFIER_EVENT_ON_ABILITY_EXECUTED,
	MODIFIER_EVENT_ON_ATTACK_LANDED
}
end


function modifier_muerta_pierce_the_veil_custom_tracker:OnAbilityExecuted( params )
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_muerta_veil_7") then return end
if params.unit~=self:GetParent() then return end
if not params.ability then return end
if params.ability:IsToggle() then return end
if UnvalidAbilities[params.ability:GetName()] then return end
if UnvalidItems[params.ability:GetName()] then return end
if params.ability:IsItem() and params.ability:GetCurrentCharges() > 0 then return end


self:GetAbility():LegendaryProc()

end


function modifier_muerta_pierce_the_veil_custom_tracker:OnDeath(params)
if not IsServer() then return end
if not params.unit:IsHero() then return end

if params.unit:IsValidKill(self:GetParent()) and (self:GetParent():HasModifier("modifier_muerta_pierce_the_veil_custom") or self:GetParent():HasModifier("modifier_muerta_pierce_the_veil_custom_shard"))
	and (self:GetParent() == params.attacker or (params.unit:GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D() <= self:GetAbility():GetSpecialValueFor("scepter_radius")) then 

	self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_muerta_pierce_the_veil_custom_scepter_buff", {})
end


end


function modifier_muerta_pierce_the_veil_custom_tracker:OnAttackLanded(params)
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_muerta_veil_2") then return end
if self:GetParent() ~= params.attacker then return end
if not params.target:IsHero() and not params.target:IsCreep() then return end

params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_muerta_pierce_the_veil_custom_amp_buff", {duration = self:GetAbility().amp_duration})
self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_muerta_pierce_the_veil_custom_amp_buff", {duration = self:GetAbility().amp_duration})

end

function modifier_muerta_pierce_the_veil_custom_tracker:OnCreated()
if not IsServer() then return end 

self:StartIntervalThink(1)
end 

function modifier_muerta_pierce_the_veil_custom_tracker:OnIntervalThink()
if not IsServer() then return end 

self:GetParent():RemoveModifierByName("modifier_muerta_pierce_the_veil_spell_amp_boost")
end 



modifier_muerta_pierce_the_veil_custom_amp_buff = class({})
function modifier_muerta_pierce_the_veil_custom_amp_buff:IsHidden() return false end
function modifier_muerta_pierce_the_veil_custom_amp_buff:IsPurgable() return false end
function modifier_muerta_pierce_the_veil_custom_amp_buff:GetTexture() return 'buffs/veil_amp' end
function modifier_muerta_pierce_the_veil_custom_amp_buff:OnCreated(table)

self.amp = self:GetAbility().amp_change[self:GetCaster():GetUpgradeStack("modifier_muerta_veil_2")]

if self:GetCaster() ~= self:GetParent() then 
	self.amp = self.amp*-1
end

self.max = self:GetAbility().amp_max
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
if not IsServer() then return end

self.heal = ((self:GetAbility().heal_after[self:GetCaster():GetUpgradeStack("modifier_muerta_veil_3")])/self:GetRemainingTime())*self:GetParent():GetMaxHealth()/100

self:StartIntervalThink(1)
end


function modifier_muerta_pierce_the_veil_custom_heal:OnIntervalThink()
if not IsServer() then return end

local particle = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
ParticleManager:ReleaseParticleIndex( particle )

SendOverheadEventMessage(self:GetParent(), 10, self:GetParent(), self.heal, nil)
end


function modifier_muerta_pierce_the_veil_custom_heal:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE
}

end


function modifier_muerta_pierce_the_veil_custom_heal:GetModifierHealthRegenPercentage()
return self:GetAbility().heal_after[self:GetCaster():GetUpgradeStack("modifier_muerta_veil_3")]/self:GetAbility().heal_duration
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

self.move = self:GetAbility().pull_slow
if not IsServer() then return end

local effect_cast = ParticleManager:CreateParticle( "particles/muerta/muerta_attack_slow.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
self:AddParticle(effect_cast, false, false, -1, false, false)

effect_cast = ParticleManager:CreateParticle( "particles/muerta/muerta_attack_slow.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
self:AddParticle(effect_cast, false, false, -1, false, false)


self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_muerta/muerta_parting_shot_tether.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
ParticleManager:SetParticleControlEnt( self.particle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetOrigin(), true )
ParticleManager:SetParticleControlEnt( self.particle, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )


self:StartIntervalThink(self:GetAbility().pull_duration)
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
if not IsServer() then return end

self:SetStackCount(self:GetStackCount() + table.stack)
end

function modifier_muerta_pierce_the_veil_custom_damage:OnRefresh(table)
self:OnCreated(table)
end


function modifier_muerta_pierce_the_veil_custom_damage:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
}
end

function modifier_muerta_pierce_the_veil_custom_damage:GetModifierPreAttack_BonusDamage()
return self:GetStackCount()
end


modifier_muerta_pierce_the_veil_custom_shard = class({})
function modifier_muerta_pierce_the_veil_custom_shard:IsHidden() return true end
function modifier_muerta_pierce_the_veil_custom_shard:IsPurgable() return false end