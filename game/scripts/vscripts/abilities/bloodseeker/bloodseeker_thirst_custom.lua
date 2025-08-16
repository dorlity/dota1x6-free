LinkLuaModifier("modifier_bloodseeker_thirst_custom", "abilities/bloodseeker/bloodseeker_thirst_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bloodseeker_thirst_custom_debuff", "abilities/bloodseeker/bloodseeker_thirst_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bloodseeker_thirst_custom_visual", "abilities/bloodseeker/bloodseeker_thirst_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bloodseeker_thirst_custom_kill", "abilities/bloodseeker/bloodseeker_thirst_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bloodseeker_thirst_custom_resist", "abilities/bloodseeker/bloodseeker_thirst_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bloodseeker_thirst_custom_vision", "abilities/bloodseeker/bloodseeker_thirst_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bloodseeker_thirst_custom_stats", "abilities/bloodseeker/bloodseeker_thirst_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bloodseeker_thirst_custom_attack_cd", "abilities/bloodseeker/bloodseeker_thirst_custom", LUA_MODIFIER_MOTION_NONE)

bloodseeker_thirst_custom = class({})


function bloodseeker_thirst_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end

PrecacheResource( "particle", "particles/bloodseeker/thirst_cleave.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_centaur/centaur_double_edge.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_bloodseeker/bloodseeker_bloodbath.vpcf", context )
PrecacheResource( "particle", "particles/status_fx/status_effect_thirst_vision.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_bloodseeker/bloodseeker_thirst_owner.vpcf", context )
PrecacheResource( "particle", "particles/items4_fx/ascetic_cap.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_bloodseeker/bloodseeker_thirst_owner.vpcf", context )
PrecacheResource( "particle", "particles/status_fx/status_effect_gods_strength.vpcf", context )
PrecacheResource( "particle", "particles/bloodseeker_vision.vpcf", context )
PrecacheResource( "particle", "particles/bloodseeker/thirst_legendary.vpcf", context )
PrecacheResource( "particle", "particles/brist_lowhp_.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_bloodseeker/bloodseeker_vision.vpcf", context )
PrecacheResource( "particle", "particles/centaur/double_edge.vpcf", context )

end



function bloodseeker_thirst_custom:GetIntrinsicModifierName()
if not self:GetCaster():IsRealHero() then return end
return "modifier_bloodseeker_thirst_custom"
end

function bloodseeker_thirst_custom:GetCooldown(iLevel)
if self:GetCaster():HasTalent("modifier_bloodseeker_thirst_7") then 
	return self:GetCaster():GetTalentValue("modifier_bloodseeker_thirst_7", "cd")
end

end

function bloodseeker_thirst_custom:GetBehavior()
if self:GetCaster():HasTalent("modifier_bloodseeker_thirst_7") then
    return DOTA_ABILITY_BEHAVIOR_NO_TARGET
end
return DOTA_ABILITY_BEHAVIOR_PASSIVE
end

function bloodseeker_thirst_custom:OnSpellStart()
if not IsServer() then return end
local caster = self:GetCaster()

caster:AddNewModifier(caster, self, "modifier_bloodseeker_thirst_custom_vision", {duration = caster:GetTalentValue("modifier_bloodseeker_thirst_7", "duration")})
end


function bloodseeker_thirst_custom:GetBonusK(stack)
local caster = self:GetCaster()	
if caster:PassivesDisabled() then return 0 end

local max_bonus_pct =  self:GetSpecialValueFor("max_bonus_pct") + caster:GetTalentValue("modifier_bloodseeker_thirst_6", "health")
local min_bonus_pct = self:GetSpecialValueFor("min_bonus_pct")

local k = 1 

if caster:HasModifier("modifier_bloodseeker_thirst_custom_vision") then 
	k  =  (1 + caster:GetTalentValue("modifier_bloodseeker_thirst_7", "bonus")/100)
end 

return (stack / (min_bonus_pct - max_bonus_pct)) * k
end 



modifier_bloodseeker_thirst_custom = class({})

function modifier_bloodseeker_thirst_custom:IsHidden() return true end
function modifier_bloodseeker_thirst_custom:IsPurgable() return false end

function modifier_bloodseeker_thirst_custom:OnCreated()
self.caster = self:GetCaster()
self.ability = self:GetAbility()
self.parent = self:GetParent()
self.parent:AddDeathEvent(self)


self.min_bonus_pct = self.ability:GetSpecialValueFor("min_bonus_pct")
self.max_bonus_pct = self.ability:GetSpecialValueFor("max_bonus_pct")
self.bonus_movement_speed = self.ability:GetSpecialValueFor("bonus_movement_speed")
self.linger_duration = self.ability:GetSpecialValueFor("linger_duration")


self.thresh_health = self.parent:GetTalentValue("modifier_bloodseeker_thirst_6", "health", true)
self.thresh_radius = self.parent:GetTalentValue("modifier_bloodseeker_thirst_6", "radius", true)
self.resist_duration = self.parent:GetTalentValue("modifier_bloodseeker_thirst_6", "duration", true)

self.legendary_cd_creeps = self.parent:GetTalentValue("modifier_bloodseeker_thirst_7", "cd_creeps", true)
self.legendary_cd_heroes = self.parent:GetTalentValue("modifier_bloodseeker_thirst_7", "cd_heroes", true)
self.legendary_bonus = self.parent:GetTalentValue("modifier_bloodseeker_thirst_7", "bonus", true)/100

self.bash_heal = self.parent:GetTalentValue("modifier_bloodseeker_thirst_5", "heal", true)/100
self.bash_duration = self.parent:GetTalentValue("modifier_bloodseeker_thirst_5", "stun", true)
self.bash_health_min = self.parent:GetTalentValue("modifier_bloodseeker_thirst_5", "min_health", true)
self.bash_health_max = self.parent:GetTalentValue("modifier_bloodseeker_thirst_5", "max_health", true)
self.bash_cd = self.parent:GetTalentValue("modifier_bloodseeker_thirst_5", "cd", true)

self.heal_creeps = self.parent:GetTalentValue("modifier_bloodseeker_thirst_2", "creeps", true)

self.kill_radius = self.parent:GetTalentValue("modifier_bloodseeker_thirst_4", "radius", true)

self.parent:AddDamageEvent_out(self)
self.parent:AddAttackEvent_out(self)

if not IsServer() then return end
self:StartIntervalThink(0.1)
end


function modifier_bloodseeker_thirst_custom:OnRefresh(table)
self:OnCreated(table)
end


function modifier_bloodseeker_thirst_custom:OnIntervalThink()
if not IsServer() then return end
local low_health = self.max_bonus_pct 

if self.parent:HasTalent("modifier_bloodseeker_thirst_6") then 
	low_health = low_health + self.thresh_health
end 

local enemies = FindUnitsInRadius(self.parent:GetTeamNumber(), self.parent:GetAbsOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)

for i = #enemies, 1, -1 do
    if enemies[i] ~= nil and not enemies[i]:IsAlive() then
        table.remove(enemies, i)
    end
end

if #enemies <= 0 then 
	self:SetStackCount(0) 
end

local min_health = 100

local has_bonus = false
local has_near_bonus = false


for _, enemy in pairs(enemies) do
	local health = enemy:GetHealthPercent()

	if health < min_health then 
		min_health = health
	end  

	if health <= low_health then 

		has_bonus = true
		if self.parent:IsAlive() and not self.ability:IsStolen() then 
			enemy:AddNewModifier(self.parent, self.ability, "modifier_bloodseeker_thirst_custom_debuff", {})
		end

		if self.parent:HasTalent("modifier_bloodseeker_thirst_6") and (enemy:GetAbsOrigin() - self.parent:GetAbsOrigin()):Length2D() <= self.thresh_radius then 
			has_near_bonus = true
		end  	

	elseif enemy:HasModifier("modifier_bloodseeker_thirst_custom_debuff") then
		enemy:RemoveModifierByName("modifier_bloodseeker_thirst_custom_debuff")
	end
end

if has_bonus then 
 	if not self.parent:HasModifier("modifier_bloodseeker_thirst_custom_visual") then 
 		if self.parent:IsAlive() then 
 			CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self.parent:GetPlayerOwnerID()), "generic_sound",  {sound = "bloodseeker_blod_ability_thirst_0"..math.random(1,3)})
 		end
		self.parent:AddNewModifier(self.parent, self.ability, "modifier_bloodseeker_thirst_custom_visual", {})
	end
else 
	self.parent:RemoveModifierByName("modifier_bloodseeker_thirst_custom_visual")
end

if has_near_bonus then 
	if not self.parent:HasModifier("modifier_bloodseeker_thirst_custom_resist") then
		self.parent:AddNewModifier(self.parent, self.ability, "modifier_bloodseeker_thirst_custom_resist", {})
	end
else
	self.parent:RemoveModifierByName("modifier_bloodseeker_thirst_custom_resist")
end

local bonus = 0
if min_health < self.min_bonus_pct then 
	bonus = self.min_bonus_pct - min_health
	if bonus > (self.min_bonus_pct - low_health) then 
		bonus = (self.min_bonus_pct - low_health)
	end 
end 

if self.parent:HasModifier("modifier_bloodseeker_thirst_custom_kill") or self.parent:HasModifier("modifier_bloodseeker_thirst_custom_vision") then 
	bonus = (self.min_bonus_pct - low_health)
end

if self.parent:HasTalent("modifier_bloodseeker_thirst_4") and self:GetStackCount() > 0 then
	self.parent:CalculateStatBonus(true)
end

self:SetStackCount(bonus)
end

function modifier_bloodseeker_thirst_custom:GetModifierMoveSpeedBonus_Percentage(params)
return self.ability:GetBonusK(self:GetStackCount()) * self.bonus_movement_speed 
end

function modifier_bloodseeker_thirst_custom:GetModifierMagicalResistanceBonus()
if not self.parent:HasTalent("modifier_bloodseeker_thirst_1") then return end
return self.ability:GetBonusK(self:GetStackCount()) * self.parent:GetTalentValue("modifier_bloodseeker_thirst_1", "magic")
end

function modifier_bloodseeker_thirst_custom:GetModifierStatusResistanceStacking()
if not self.parent:HasTalent("modifier_bloodseeker_thirst_1") then return end
return self.ability:GetBonusK(self:GetStackCount()) * self.parent:GetTalentValue("modifier_bloodseeker_thirst_1", "status")
end

function modifier_bloodseeker_thirst_custom:GetModifierPreAttack_BonusDamage()
if not self.parent:HasTalent("modifier_bloodseeker_thirst_3") then return end
return self.ability:GetBonusK(self:GetStackCount()) * self.parent:GetTalentValue("modifier_bloodseeker_thirst_3", "damage")
end

function modifier_bloodseeker_thirst_custom:GetModifierMoveSpeedBonus_Constant()
if not self.parent:HasTalent("modifier_bloodseeker_thirst_3") then return end
return self.parent:GetTalentValue("modifier_bloodseeker_thirst_3", "move")
end

function modifier_bloodseeker_thirst_custom:GetModifierBonusStats_Strength()
if not self.parent:HasTalent("modifier_bloodseeker_thirst_4") then return end
return self.ability:GetBonusK(self:GetStackCount()) * self.parent:GetTalentValue("modifier_bloodseeker_thirst_4", "max_stats")
end

function modifier_bloodseeker_thirst_custom:GetModifierBonusStats_Agility()
if not self.parent:HasTalent("modifier_bloodseeker_thirst_4") then return end
return self.ability:GetBonusK(self:GetStackCount()) * self.parent:GetTalentValue("modifier_bloodseeker_thirst_4", "max_stats")
end

function modifier_bloodseeker_thirst_custom:DeclareFunctions()
return 
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
	MODIFIER_PROPERTY_MOVESPEED_MAX,
    MODIFIER_PROPERTY_MOVESPEED_LIMIT,
    MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
	MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	MODIFIER_PROPERTY_STATS_AGILITY_BONUS
}
end


function modifier_bloodseeker_thirst_custom:DamageEvent_out(params)
if not IsServer() then return end 
if not self.parent:HasTalent("modifier_bloodseeker_thirst_2") then return end
if not self.parent:CheckLifesteal(params) then return end

local unit = params.unit
local heal = self.parent:GetTalentValue("modifier_bloodseeker_thirst_2", "heal")*((unit:GetMaxHealth() - unit:GetHealth())/unit:GetMaxHealth())/100

if unit:IsCreep() then 
	heal = heal/self.heal_creeps
end 

self.parent:GenericHeal(heal*params.damage, self.ability, true, nil, "modifier_bloodseeker_thirst_2")
end 



function modifier_bloodseeker_thirst_custom:AttackEvent_out(params)
if not IsServer() then return end 
if params.attacker ~= self.parent then return end 
if not params.target:IsUnit() then return end 

local target = params.target

if self.parent:HasTalent("modifier_bloodseeker_thirst_5") and not self.parent:HasModifier("modifier_bloodseeker_thirst_custom_attack_cd")
	and (target:GetHealthPercent() >= self.bash_health_max or target:GetHealthPercent() <= self.bash_health_min) then 

	target:EmitSound("BS.Thirst_attack")
	self.parent:EmitSound("BS.Thirst_legendary_stack")

	local vec = (target:GetAbsOrigin() - self.parent:GetAbsOrigin()):Normalized()
	vec.z = 0

	local particle_edge_fx = ParticleManager:CreateParticle("particles/centaur/double_edge.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControlEnt(particle_edge_fx, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true )
	ParticleManager:SetParticleControlEnt(particle_edge_fx, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true )
	ParticleManager:SetParticleControlForward(particle_edge_fx, 2, vec)
	ParticleManager:SetParticleControl(particle_edge_fx, 5, self.parent:GetAttachmentOrigin(self.parent:ScriptLookupAttachment("attach_hitloc")))
	ParticleManager:SetParticleControlForward(particle_edge_fx, 5, vec)
	ParticleManager:ReleaseParticleIndex(particle_edge_fx)

	self.parent:GenericHeal(self.parent:GetMaxHealth()*self.bash_heal, self.ability, false, "particles/units/heroes/hero_bloodseeker/bloodseeker_bloodbath.vpcf", "modifier_bloodseeker_thirst_5")

	target:AddNewModifier(self.parent, self.ability, "modifier_stunned", {duration = (1 - target:GetStatusResistance())*self.bash_duration})
	self.parent:AddNewModifier(self.parent, self.ability, "modifier_bloodseeker_thirst_custom_attack_cd", {duration = self.bash_cd})
end 

end 

function modifier_bloodseeker_thirst_custom:GetModifierMoveSpeed_Max( params )
return 30000
end

function modifier_bloodseeker_thirst_custom:GetModifierMoveSpeed_Limit( params )
return 30000
end

function modifier_bloodseeker_thirst_custom:GetModifierIgnoreMovespeedLimit( params )
return 1
end

function modifier_bloodseeker_thirst_custom:DeathEvent( params )
if params.unit:GetTeamNumber() == self.parent:GetTeamNumber() then return end
if params.unit == self.parent then return end

local target = params.unit

if params.unit:IsRealHero() and not params.unit:IsReincarnating() then 
	self.parent:AddNewModifier(self.parent, self.ability, "modifier_bloodseeker_thirst_custom_kill", {duration = self.ability:GetSpecialValueFor("linger_duration")})
end

if target:IsValidKill(self.parent) and (self.parent == params.attacker or (self.parent:GetAbsOrigin() - target:GetAbsOrigin()):Length2D() <= self.kill_radius) then
	self.parent:AddNewModifier(self.parent, self.ability, "modifier_bloodseeker_thirst_custom_stats", {})
end	

if self.parent:HasTalent("modifier_bloodseeker_thirst_7") and ((target:IsRealHero() and not target:IsReincarnating()) or target:IsCreep()) and self.parent == params.attacker then 
	local cd = self.legendary_cd_creeps

	if target:IsRealHero() then 
		cd = self.legendary_cd_heroes
	end 

	self.parent:CdAbility(self.ability, cd)
end 

end


function modifier_bloodseeker_thirst_custom:OnDestroy()
if not IsServer() then return end
self.parent:RemoveModifierByName("modifier_bloodseeker_thirst_custom_visual")
end




modifier_bloodseeker_thirst_custom_debuff = class({})
function modifier_bloodseeker_thirst_custom_debuff:IsPurgable() return false end

function modifier_bloodseeker_thirst_custom_debuff:OnCreated()
if not IsServer() then return end
self.parent = self:GetParent()
self.caster = self:GetCaster()
self.ability = self:GetAbility()
self:StartIntervalThink(FrameTime())
end

function modifier_bloodseeker_thirst_custom_debuff:OnIntervalThink()
if not IsServer() then return end
AddFOWViewer(self.caster:GetTeamNumber(), self.parent:GetAbsOrigin(), 75, FrameTime(), false)
self.parent:AddNewModifier(self.caster, self.ability, "modifier_truesight", {duration = 0.1})
end

function modifier_bloodseeker_thirst_custom_debuff:GetStatusEffectName()
return "particles/units/heroes/hero_bloodseeker/bloodseeker_vision.vpcf"
end




modifier_bloodseeker_thirst_custom_visual = class({})
function modifier_bloodseeker_thirst_custom_visual:IsPurgable() return false end

function modifier_bloodseeker_thirst_custom_visual:GetEffectName()
return "particles/units/heroes/hero_bloodseeker/bloodseeker_thirst_owner.vpcf"
end

function modifier_bloodseeker_thirst_custom_visual:GetStatusEffectName()
return "particles/status_fx/status_effect_thirst_vision.vpcf"
end

function modifier_bloodseeker_thirst_custom_visual:StatusEffectPriority()
return MODIFIER_PRIORITY_NORMAL 
end

function modifier_bloodseeker_thirst_custom_visual:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
}
end

function modifier_bloodseeker_thirst_custom_visual:GetActivityTranslationModifiers()
return "thirst"
end



modifier_bloodseeker_thirst_custom_kill = class({})
function modifier_bloodseeker_thirst_custom_kill:IsHidden() return true end
function modifier_bloodseeker_thirst_custom_kill:IsPurgable() return false end




modifier_bloodseeker_thirst_custom_resist = class({})
function modifier_bloodseeker_thirst_custom_resist:IsHidden() return false end
function modifier_bloodseeker_thirst_custom_resist:IsPurgable() return false end
function modifier_bloodseeker_thirst_custom_resist:GetTexture() return "buffs/Thirst_status" end
function modifier_bloodseeker_thirst_custom_resist:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT
}
end

function modifier_bloodseeker_thirst_custom_resist:GetModifierBaseAttackTimeConstant() 
return self.bva
end

function modifier_bloodseeker_thirst_custom_resist:CheckState()
return
{
	[MODIFIER_STATE_UNSLOWABLE] = true
}
end

function modifier_bloodseeker_thirst_custom_resist:OnCreated(table)
self.parent = self:GetParent()
self.bva = self.parent:GetTalentValue("modifier_bloodseeker_thirst_6", "bva")
if not IsServer() then return end
self.parent:EmitSound("Thirst.Resist")
self.parent:GenericParticle("particles/items4_fx/ascetic_cap.vpcf", self)
end









modifier_bloodseeker_thirst_custom_vision = class({})
function modifier_bloodseeker_thirst_custom_vision:IsHidden() return false end
function modifier_bloodseeker_thirst_custom_vision:IsPurgable() return false end
function modifier_bloodseeker_thirst_custom_vision:GetTexture() return "buffs/Thirst_vision" end
function modifier_bloodseeker_thirst_custom_vision:RemoveOnDeath() return false end

function modifier_bloodseeker_thirst_custom_vision:GetEffectName()
return "particles/units/heroes/hero_bloodseeker/bloodseeker_thirst_owner.vpcf"
end

function modifier_bloodseeker_thirst_custom_vision:DeclareFunctions()
return 
{
	MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
	MODIFIER_PROPERTY_MODEL_SCALE,
}
end

function modifier_bloodseeker_thirst_custom_vision:GetModifierModelScale() 
return 20
end

function modifier_bloodseeker_thirst_custom_vision:GetActivityTranslationModifiers()
return "thirst"
end

function modifier_bloodseeker_thirst_custom_vision:GetStatusEffectName()
return "particles/status_fx/status_effect_gods_strength.vpcf"
end

function modifier_bloodseeker_thirst_custom_vision:StatusEffectPriority()
return MODIFIER_PRIORITY_HIGH 
end

function modifier_bloodseeker_thirst_custom_vision:OnCreated(table)
if not IsServer() then return end

self.parent = self:GetParent()

self.RemoveForDuel = true

if self.parent:IsAlive() then
	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self.parent:GetPlayerOwnerID()), "generic_sound",  {sound = "bloodseeker_blod_ability_thirst_0"..math.random(1,3)})
	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self.parent:GetPlayerOwnerID()), "generic_sound",  {sound = "BS.Thirst_vision"})
end

self.effect_cast = ParticleManager:CreateParticle( "particles/bloodseeker/thirst_legendary.vpcf", PATTACH_CUSTOMORIGIN, self.parent )
ParticleManager:SetParticleControlEnt( self.effect_cast, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true )
ParticleManager:SetParticleControlEnt( self.effect_cast, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_attack1", self.parent:GetAbsOrigin(), true )
ParticleManager:SetParticleControlEnt( self.effect_cast, 2, self.parent, PATTACH_POINT_FOLLOW, "attach_attack2", self.parent:GetAbsOrigin(), true )
self:AddParticle(self.effect_cast,false, false, -1, false, false)

self:StartIntervalThink(0.2)
end

function modifier_bloodseeker_thirst_custom_vision:OnIntervalThink()
if not IsServer() then return end

local heroes = FindUnitsInRadius(self.parent:GetTeamNumber(), self.parent:GetAbsOrigin(), nil, self.parent:GetTalentValue("modifier_bloodseeker_thirst_7", "vision_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)

for _,hero in pairs(heroes) do 
    AddFOWViewer(self.parent:GetTeamNumber(), hero:GetAbsOrigin(), 10, 0.2, false)
end

end




modifier_bloodseeker_thirst_custom_stats = class({})
function modifier_bloodseeker_thirst_custom_stats:IsHidden() return not self:GetParent():HasTalent("modifier_bloodseeker_thirst_4") end
function modifier_bloodseeker_thirst_custom_stats:IsPurgable() return false end
function modifier_bloodseeker_thirst_custom_stats:RemoveOnDeath() return false end
function modifier_bloodseeker_thirst_custom_stats:GetTexture() return "buffs/Thirst_stats" end
function modifier_bloodseeker_thirst_custom_stats:OnCreated()

self.parent = self:GetParent()

self.max = self.parent:GetTalentValue("modifier_bloodseeker_thirst_4", "max", true)

if not IsServer() then return end 
self:StartIntervalThink(0.5)
self:SetStackCount(1)
end 

function modifier_bloodseeker_thirst_custom_stats:OnRefresh()
if not IsServer() then return end 
if self:GetStackCount() >= self.max then return end 
self:IncrementStackCount()
end 

function modifier_bloodseeker_thirst_custom_stats:OnIntervalThink()
if not IsServer() then return end
if not self.parent:HasTalent("modifier_bloodseeker_thirst_4") then return end 
if self:GetStackCount() < self.max then return end 

self.parent:GenericParticle("particles/brist_lowhp_.vpcf")
self.parent:EmitSound("BS.Thirst_legendary_active")
self:StartIntervalThink(-1)
end 


function modifier_bloodseeker_thirst_custom_stats:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	MODIFIER_PROPERTY_STATS_AGILITY_BONUS
}
end

function modifier_bloodseeker_thirst_custom_stats:GetModifierBonusStats_Strength()
if not self.parent:HasTalent("modifier_bloodseeker_thirst_4") then return end
return self:GetStackCount()*self.parent:GetTalentValue("modifier_bloodseeker_thirst_4", "str")/self.max
end

function modifier_bloodseeker_thirst_custom_stats:GetModifierBonusStats_Agility()
if not self.parent:HasTalent("modifier_bloodseeker_thirst_4") then return end
return self:GetStackCount()*self.parent:GetTalentValue("modifier_bloodseeker_thirst_4", "agi")/self.max
end




modifier_bloodseeker_thirst_custom_attack_cd = class({})
function modifier_bloodseeker_thirst_custom_attack_cd:IsHidden() return false end
function modifier_bloodseeker_thirst_custom_attack_cd:IsPurgable() return false end
function modifier_bloodseeker_thirst_custom_attack_cd:RemoveOnDeath() return false end
function modifier_bloodseeker_thirst_custom_attack_cd:IsDebuff() return true end
function modifier_bloodseeker_thirst_custom_attack_cd:GetTexture() return "buffs/Thirst_attack" end

