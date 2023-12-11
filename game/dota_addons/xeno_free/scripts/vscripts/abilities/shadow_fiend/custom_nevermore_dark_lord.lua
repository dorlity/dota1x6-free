LinkLuaModifier("modifier_custom_dark_lord_aura","abilities/shadow_fiend/custom_nevermore_dark_lord", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_dark_lord_debuff", "abilities/shadow_fiend/custom_nevermore_dark_lord", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_dark_lord_legendary", "abilities/shadow_fiend/custom_nevermore_dark_lord", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_dark_lord_silence_aura", "abilities/shadow_fiend/custom_nevermore_dark_lord", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_dark_lord_silence", "abilities/shadow_fiend/custom_nevermore_dark_lord", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_dark_lord_silence_cd", "abilities/shadow_fiend/custom_nevermore_dark_lord", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_dark_lord_silence_timer", "abilities/shadow_fiend/custom_nevermore_dark_lord", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_generic_ring_lua_sf", "abilities/generic/modifier_generic_ring_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_custom_dark_lord_kill", "abilities/shadow_fiend/custom_nevermore_dark_lord", LUA_MODIFIER_MOTION_NONE)





custom_nevermore_dark_lord = class({})


custom_nevermore_dark_lord.armor_bonus = {-3, -4, -5}


custom_nevermore_dark_lord.slow_move = {-20, -30 ,-40}
custom_nevermore_dark_lord.slow_attack = {-20, -30, -40}

custom_nevermore_dark_lord.resist_magic = {-8, -12, -16}
custom_nevermore_dark_lord.resist_status = {-8, -12, -16}

custom_nevermore_dark_lord.near_range = 550
custom_nevermore_dark_lord.near_interval = 1
custom_nevermore_dark_lord.near_inc = {0.1 , 0.15}
custom_nevermore_dark_lord.near_max = 6

custom_nevermore_dark_lord.legendary_cd = 40
custom_nevermore_dark_lord.legendary_duration = 12
custom_nevermore_dark_lord.legendary_radius = 1200
custom_nevermore_dark_lord.legendary_speed = 1200
custom_nevermore_dark_lord.legendary_fear = 1.8

custom_nevermore_dark_lord.healing_health = 40
custom_nevermore_dark_lord.healing_reduce = -15
custom_nevermore_dark_lord.healing_lifesteal = 0.15

custom_nevermore_dark_lord.silence_cd = 10
custom_nevermore_dark_lord.silence_duration = 1.5
custom_nevermore_dark_lord.silence_radius = 250


function custom_nevermore_dark_lord:Precache(context)

PrecacheResource( "particle",  "particles/sf_fear.vpcf", context )
PrecacheResource( "particle",  "particles/sf_timer.vpcf", context )
PrecacheResource( "particle",  "particles/sf_aura.vpcf", context )
PrecacheResource( "particle",  "particles/sf_legendary.vpcf", context )

end






function custom_nevermore_dark_lord:GetCooldown(iLevel)
if self:GetCaster():HasModifier("modifier_nevermore_darklord_legendary") then return self.legendary_cd end  
end




function custom_nevermore_dark_lord:GetBehavior()
  if self:GetCaster():HasModifier("modifier_nevermore_darklord_legendary") then
    return DOTA_ABILITY_BEHAVIOR_NO_TARGET end
 return DOTA_ABILITY_BEHAVIOR_PASSIVE 
end

function custom_nevermore_dark_lord:OnSpellStart()
if not IsServer() then return end
self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_custom_dark_lord_legendary", {duration = self.legendary_duration})


	local caster = self:GetCaster()
	local radius = self.legendary_radius
	local speed = 900

	local particle_cast = "particles/sf_fear.vpcf"

	local sound_cast = "Sf.Aura_Ring"

	
	self.effect_cast = ParticleManager:CreateParticle( particle_cast,  PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( self.effect_cast, 0, self:GetCaster():GetAbsOrigin())
	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector(  900, 1000, 1000 ) )

	caster:EmitSound(sound_cast)
	self.wings_particle = ParticleManager:CreateParticle("particles/sf_wings.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	caster:EmitSound("Sf.Aura_Legendary")




	Timers:CreateTimer(4,function()
		ParticleManager:DestroyParticle(self.wings_particle, false)
		ParticleManager:ReleaseParticleIndex(self.wings_particle)
        
	end)

	local pulse = caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_generic_ring_lua_sf", -- modifier name
		{
			end_radius = radius,
			speed = speed,
			target_team = DOTA_UNIT_TARGET_TEAM_ENEMY,
			target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		} -- kv
	)
	pulse:SetCallback()

  Timers:CreateTimer(radius/speed,function()
     
		ParticleManager:DestroyParticle(self.effect_cast, false)
		ParticleManager:ReleaseParticleIndex(self.effect_cast)
        
        end)

end





function custom_nevermore_dark_lord:GetAbilityTextureName()
   return "nevermore_dark_lord"
end

function custom_nevermore_dark_lord:GetIntrinsicModifierName()
	return "modifier_custom_dark_lord_aura"
end




modifier_custom_dark_lord_aura = class({})

function modifier_custom_dark_lord_aura:OnCreated()
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.aura_radius = self.ability:GetSpecialValueFor("presence_radius")
end






function modifier_custom_dark_lord_aura:IsHidden() return true end
function modifier_custom_dark_lord_aura:IsPurgable() return false end
function modifier_custom_dark_lord_aura:IsDebuff() return false end

function modifier_custom_dark_lord_aura:OnRefresh()
	self:OnCreated()
end

function modifier_custom_dark_lord_aura:AllowIllusionDuplicate()
	return true
end

function modifier_custom_dark_lord_aura:GetAuraEntityReject(target)
	if not target:CanEntityBeSeenByMyTeam(self.caster) or (self:GetCaster():GetTeam() == target:GetTeam() and self:GetCaster() ~= target) then
		return true 
	end

	return false
end


function modifier_custom_dark_lord_aura:GetAuraDuration()
	return 3
end


function modifier_custom_dark_lord_aura:GetAuraRadius()
	return self.aura_radius
end

function modifier_custom_dark_lord_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE
end

function modifier_custom_dark_lord_aura:GetAuraSearchTeam()
if self:GetCaster():HasModifier("modifier_custom_dark_lord_legendary") then 
	return DOTA_UNIT_TARGET_TEAM_ENEMY + DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_custom_dark_lord_aura:GetAuraSearchType()
 
	return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO 


end


function modifier_custom_dark_lord_aura:GetModifierAura()
	return "modifier_custom_dark_lord_debuff"
end

function modifier_custom_dark_lord_aura:IsAura()
	if self.caster:PassivesDisabled() then
		return false
	end

	return true
end



modifier_custom_dark_lord_debuff =  class({})



function modifier_custom_dark_lord_debuff:IsHidden() return false end
function modifier_custom_dark_lord_debuff:IsPurgable() return false end

function modifier_custom_dark_lord_debuff:OnCreated(table)
self.armor = -1*self:GetAbility():GetSpecialValueFor("presence_armor_reduction")
self.k = 0
self.self_k = 1

if self:GetCaster() == self:GetParent() then
	self.self_k = -1
end

self.kill_armor = self:GetAbility():GetSpecialValueFor("kill_armor")

if not self:GetCaster():HasModifier("modifier_nevermore_darklord_health") then return end

self.k = self:GetAbility().near_inc[self:GetCaster():GetUpgradeStack("modifier_nevermore_darklord_health")]

if not IsServer() then return end
self:StartIntervalThink(self:GetAbility().near_interval)
end


function modifier_custom_dark_lord_debuff:OnIntervalThink()
if not IsServer() then return end


if self:GetStackCount() < self:GetAbility().near_max and 
	(self:GetParent():GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Length2D() <= self:GetAbility().near_range then
		self:IncrementStackCount()
end

if self:GetStackCount() > 0 and 
	(self:GetParent():GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Length2D() > self:GetAbility().near_range then
		self:DecrementStackCount()
end

if self:GetParent():IsHero() then 
	self:GetParent():CalculateStatBonus(true)
end

end


function modifier_custom_dark_lord_debuff:OnStackCountChanged(iStackCount)
    if not IsServer() then return end

    if not self.pfx then
        self.pfx = ParticleManager:CreateParticle("particles/sf_timer.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
   	 	self:AddParticle(self.pfx,false, false, -1, false, false)
    end

    ParticleManager:SetParticleControl(self.pfx, 1, Vector(0, self:GetStackCount(), 0))
end


function modifier_custom_dark_lord_debuff:DeclareFunctions()
return 
{
	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	MODIFIER_EVENT_ON_TAKEDAMAGE,
	MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
    MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
	MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE,
	MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
	MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	MODIFIER_EVENT_ON_DEATH
  }
end





function modifier_custom_dark_lord_debuff:OnDeath(params)
if not IsServer() then return end
if params.unit ~= self:GetParent() then return end
if self:GetCaster():IsIllusion() then return end
if not self:GetParent():IsValidKill(self:GetCaster()) then return end

self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_dark_lord_kill", {duration = self:GetAbility():GetSpecialValueFor("kill_duration")})
end


function modifier_custom_dark_lord_debuff:GetModifierLifestealRegenAmplify_Percentage() 
if self:GetParent():IsBuilding() then return end
if self:GetParent():GetHealthPercent() >= self:GetAbility().healing_health then return end
if not self:GetCaster():HasModifier("modifier_nevermore_darklord_self") then return end
if self:GetCaster() == self:GetParent() then return end

return self:GetAbility().healing_reduce
end


function modifier_custom_dark_lord_debuff:GetModifierHealAmplify_PercentageTarget() 
if self:GetParent():IsBuilding() then return end
if self:GetParent():GetHealthPercent() >= self:GetAbility().healing_health then return end
if not self:GetCaster():HasModifier("modifier_nevermore_darklord_self") then return end
if self:GetCaster() == self:GetParent() then return end

return self:GetAbility().healing_reduce
end

function modifier_custom_dark_lord_debuff:GetModifierHPRegenAmplify_Percentage() 
if self:GetParent():IsBuilding() then return end
if self:GetParent():GetHealthPercent() >= self:GetAbility().healing_health then return end
if not self:GetCaster():HasModifier("modifier_nevermore_darklord_self") then return end
if self:GetCaster() == self:GetParent() then return end

return self:GetAbility().healing_reduce
end






function modifier_custom_dark_lord_debuff:OnTakeDamage(params)
if self:GetCaster() == self:GetParent() then return end
if self:GetCaster() ~= params.attacker then return end
if self:GetParent() ~= params.unit  then return end
if self:GetParent():IsBuilding() then return end
if self:GetParent():GetHealthPercent() >= self:GetAbility().healing_health then return end
if not self:GetCaster():HasModifier("modifier_nevermore_darklord_self") then return end

if bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then return end

local heal = self:GetAbility().healing_lifesteal*params.damage
self:GetCaster():Heal(heal, self:GetAbility())

local particle = ParticleManager:CreateParticle( "particles/huskar_leap_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
ParticleManager:ReleaseParticleIndex( particle )

end



function modifier_custom_dark_lord_debuff:GetModifierStatusResistanceStacking()
local bonus = 0

if self:GetCaster():HasModifier("modifier_nevermore_darklord_damage") then 
	bonus = self:GetAbility().resist_status[self:GetCaster():GetUpgradeStack("modifier_nevermore_darklord_damage")]
end

return (bonus)*(1 + self:GetStackCount()*self.k)*self.self_k
end




function modifier_custom_dark_lord_debuff:GetModifierMagicalResistanceBonus()
local bonus = 0

if self:GetCaster():HasModifier("modifier_nevermore_darklord_damage") then 
	bonus = self:GetAbility().resist_magic[self:GetCaster():GetUpgradeStack("modifier_nevermore_darklord_damage")]
end

return (bonus)*(1 + self:GetStackCount()*self.k)*self.self_k
end







function modifier_custom_dark_lord_debuff:GetModifierPhysicalArmorBonus()
local bonus = 0

local kill_bonus = 0

if self:GetCaster():HasModifier("modifier_custom_dark_lord_kill") then 
	kill_bonus = kill_bonus + self:GetCaster():GetUpgradeStack("modifier_custom_dark_lord_kill")*self.kill_armor
end

if self:GetCaster():HasModifier("modifier_nevermore_darklord_armor") then 
	bonus = self:GetAbility().armor_bonus[self:GetCaster():GetUpgradeStack("modifier_nevermore_darklord_armor")]
end

return (self.armor + bonus + kill_bonus)*(1 + self:GetStackCount()*self.k)*self.self_k
end




function modifier_custom_dark_lord_debuff:GetModifierMoveSpeedBonus_Constant()
if self:GetParent():IsBuilding() then return end
local bonus = 0

if self:GetCaster():HasModifier("modifier_nevermore_darklord_slow") then 
	bonus = self:GetAbility().slow_move[self:GetCaster():GetUpgradeStack("modifier_nevermore_darklord_slow")]
end


return bonus*(1 + self:GetStackCount()*self.k)*self.self_k
end

function modifier_custom_dark_lord_debuff:GetModifierAttackSpeedBonus_Constant()
if self:GetParent():IsBuilding() then return end
local bonus = 0

if self:GetCaster():HasModifier("modifier_nevermore_darklord_slow") then 
	bonus = self:GetAbility().slow_attack[self:GetCaster():GetUpgradeStack("modifier_nevermore_darklord_slow")]
end

return bonus*(1 + self:GetStackCount()*self.k)*self.self_k
end














modifier_custom_dark_lord_silence_aura = class({})


function modifier_custom_dark_lord_silence_aura:IsHidden() return true end
function modifier_custom_dark_lord_silence_aura:IsPurgable() return false end
function modifier_custom_dark_lord_silence_aura:IsDebuff() return false end




function modifier_custom_dark_lord_silence_aura:OnCreated(table)
if not IsServer() then return end
self:StartIntervalThink(0.2)
self.particle = nil

end

function modifier_custom_dark_lord_silence_aura:OnIntervalThink()
if not IsServer() then return end

local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self:GetAbility().silence_radius,  DOTA_UNIT_TARGET_TEAM_ENEMY,  DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER,  false)
if self.particle == nil then 
	if #enemies > 0 and not self:GetParent():HasModifier("modifier_custom_dark_lord_silence_cd") then 
		self.particle  = ParticleManager:CreateParticle( "particles/sf_aura.vpcf"	, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	end
end
if self.particle ~= nil then
	if #enemies == 0 or self:GetParent():HasModifier("modifier_custom_dark_lord_silence_cd") then 
		ParticleManager:DestroyParticle(self.particle, false)
		ParticleManager:ReleaseParticleIndex( self.particle)
		self.particle = nil
	end
end

end



function modifier_custom_dark_lord_silence_aura:GetAuraRadius()
	return self:GetAbility().silence_radius
end

function modifier_custom_dark_lord_silence_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_custom_dark_lord_silence_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_custom_dark_lord_silence_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_custom_dark_lord_silence_aura:GetModifierAura()
	return "modifier_custom_dark_lord_silence_timer"
end

function modifier_custom_dark_lord_silence_aura:IsAura()
	if self:GetCaster():PassivesDisabled() or self:GetParent():HasModifier("modifier_custom_dark_lord_silence_cd") then
		return false
	end
	return true
end





modifier_custom_dark_lord_silence_timer = class({})
function modifier_custom_dark_lord_silence_timer:IsHidden() return false end
function modifier_custom_dark_lord_silence_timer:IsPurgable() return true end
function modifier_custom_dark_lord_silence_timer:GetTexture() return "buffs/darklord_silence" end
function modifier_custom_dark_lord_silence_timer:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_ABILITY_FULLY_CAST
}

end




function modifier_custom_dark_lord_silence_timer:OnAbilityFullyCast(keys)
if not keys.ability then return end 
if keys.unit ~= self:GetParent() then return end
if keys.ability:IsItem() or UnvalidAbilities[keys.ability:GetName()] then return end
if self:GetCaster():HasModifier("modifier_custom_dark_lord_silence_cd") then return end

local duration = self:GetAbility().silence_duration

local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self:GetAbility().silence_radius,  DOTA_UNIT_TARGET_TEAM_ENEMY,  DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER,  false)

for _,enemy in pairs(enemies) do 
	enemy:EmitSound("Sf.Aura_Silence")
	enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_dark_lord_silence", {duration = duration * (1 - enemy:GetStatusResistance())})
end

self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_dark_lord_silence_cd", {duration = self:GetAbility().silence_cd})


end

function modifier_custom_dark_lord_silence_timer:OnDestroy()
if not IsServer() then return end
	if self.pfx then
 		ParticleManager:DestroyParticle(self.pfx, false)
 		ParticleManager:ReleaseParticleIndex(self.pfx)  
 	end
end





modifier_custom_dark_lord_silence = class({})
function modifier_custom_dark_lord_silence:IsHidden() return false end
function modifier_custom_dark_lord_silence:IsPurgable() return true end
function modifier_custom_dark_lord_silence:GetTexture() return "buffs/darklord_silence" end
function modifier_custom_dark_lord_silence:CheckState() return {[MODIFIER_STATE_SILENCED] = true} end
function modifier_custom_dark_lord_silence:GetEffectName() return "particles/generic_gameplay/generic_silenced.vpcf" end
function modifier_custom_dark_lord_silence:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end

function modifier_custom_dark_lord_silence:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end

function modifier_custom_dark_lord_silence:GetModifierMoveSpeedBonus_Percentage()
return -100
end

modifier_custom_dark_lord_silence_cd = class({})
function modifier_custom_dark_lord_silence_cd:IsHidden() return false end
function modifier_custom_dark_lord_silence_cd:IsPurgable() return false end
function modifier_custom_dark_lord_silence_cd:IsDebuff() return true end

function modifier_custom_dark_lord_silence_cd:RemoveOnDeath() return false end
function modifier_custom_dark_lord_silence_cd:GetTexture() return "buffs/darklord_silence" end
function modifier_custom_dark_lord_silence_cd:OnCreated()
self.RemoveForDuel = true
end





modifier_custom_dark_lord_nil = class({})
function modifier_custom_dark_lord_nil:IsHidden() return true end
function modifier_custom_dark_lord_nil:IsPurgable() return false end





modifier_custom_dark_lord_legendary = class({})
function modifier_custom_dark_lord_legendary:IsHidden() return true end
function modifier_custom_dark_lord_legendary:IsPurgable() return false end
function modifier_custom_dark_lord_legendary:GetTexture() return "buffs/darklord_legen" end
function modifier_custom_dark_lord_legendary:OnCreated(table)
if not IsServer() then return end
	self.RemoveForDuel = true
self:GetParent():EmitSound("Sf.Aura_Legendary_Buff")
self.particle = ParticleManager:CreateParticle( "particles/sf_legendary.vpcf" 	, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControl( self.particle , 0, self:GetParent():GetAbsOrigin() )
	ParticleManager:SetParticleControl( self.particle , 2, Vector(230,0,0))
end

function modifier_custom_dark_lord_legendary:OnDestroy()
if not IsServer() then return end
ParticleManager:DestroyParticle(self.particle, false)
ParticleManager:ReleaseParticleIndex(self.particle)

if self:GetParent():HasModifier("modifier_custom_dark_lord_debuff") then 
	self:GetParent():RemoveModifierByName("modifier_custom_dark_lord_debuff")
end

end



modifier_custom_dark_lord_kill = class({})
function modifier_custom_dark_lord_kill:IsHidden() return false end
function modifier_custom_dark_lord_kill:IsPurgable() return false end
function modifier_custom_dark_lord_kill:OnCreated(table)
if not IsServer() then return end

self:SetStackCount(1)
end

function modifier_custom_dark_lord_kill:OnRefresh(table)
if not IsServer() then return end

self:IncrementStackCount()
end


function modifier_custom_dark_lord_kill:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOOLTIP
}
end


function modifier_custom_dark_lord_kill:OnTooltip()
return self:GetStackCount()*self:GetAbility():GetSpecialValueFor("kill_armor")
end


