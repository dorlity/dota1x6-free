LinkLuaModifier("modifier_press_the_attack_custom_buff", "abilities/legion_commander/custom_legion_commander_press_the_attack", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_press_the_attack_custom_root", "abilities/legion_commander/custom_legion_commander_press_the_attack", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_press_the_attack_custom_legendary_damage", "abilities/legion_commander/custom_legion_commander_press_the_attack", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_press_the_attack_custom_legendary", "abilities/legion_commander/custom_legion_commander_press_the_attack", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_press_the_attack_custom_unslow", "abilities/legion_commander/custom_legion_commander_press_the_attack", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_press_the_attack_custom_burn_effect", "abilities/legion_commander/custom_legion_commander_press_the_attack", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_press_the_attack_custom_burn_aura", "abilities/legion_commander/custom_legion_commander_press_the_attack", LUA_MODIFIER_MOTION_NONE)



custom_legion_commander_press_the_attack = class({})



function custom_legion_commander_press_the_attack:GetAbilityTextureName()
    if self:GetCaster():HasModifier("modifier_legion_commander_wings_fallen_custom") then
        return "legion_commander/legacy_of_the_fallen_legion/legion_commander_press_the_attack"
    end
    if self:GetCaster():HasModifier("modifier_legion_commander_wings_fallen_custom_2") then
        return "legion_commander/legacy_of_the_fallen_legion/legion_commander_press_the_attack"
    end
    return "legion_commander_press_the_attack"
end

function custom_legion_commander_press_the_attack:Precache(context)

PrecacheResource( "particle", "particles/units/heroes/hero_legion_commander/legion_commander_press.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_legion_commander/legion_commander_press_hands.vpcf", context )
PrecacheResource( "particle", "particles/lc_wave.vpcf", context )
PrecacheResource( "particle", "particles/lc_press_legendary.vpcf", context )
PrecacheResource( "particle", "particles/lc_press_burn.vpcf", context )
PrecacheResource( "particle", "particles/lc_root.vpcf", context )
PrecacheResource( "particle", "particles/lc_press_heal.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_marci/marci_unleash_stack.vpcf", context )

end


function custom_legion_commander_press_the_attack:GetBehavior()
local bonus = 0

if self:GetCaster():HasModifier("modifier_legion_press_lowhp") then 
	bonus = DOTA_ABILITY_BEHAVIOR_IMMEDIATE
end

return DOTA_ABILITY_BEHAVIOR_NO_TARGET + bonus
end




function custom_legion_commander_press_the_attack:GetCastRange(vLocation, hTarget)
if self:GetCaster():HasModifier("modifier_legion_press_after") then 
	return self:GetCaster():GetTalentValue("modifier_legion_press_after", "radius")
end 

end 



function custom_legion_commander_press_the_attack:GetCooldown(iLevel)

local upgrade_cooldown = 0

if self:GetCaster():HasModifier("modifier_legion_press_speed") then  
  upgrade_cooldown = self:GetCaster():GetTalentValue("modifier_legion_press_speed", "cd")
end 

 return self.BaseClass.GetCooldown(self, iLevel) + upgrade_cooldown

end






function custom_legion_commander_press_the_attack:OnSpellStart()
if not IsServer() then return end
self.target = self:GetCaster()

local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_legion_commander/legion_commander_press_halo.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
ParticleManager:ReleaseParticleIndex(particle)

local before = #self.target:FindAllModifiers()
self.target:Purge(false , true, false , true, false)
local after = #self.target:FindAllModifiers()

if self:GetCaster():GetQuest() == "Legion.Quest_6" and after < before then 
	self:GetCaster():UpdateQuest(1)
end

if self:GetCaster():HasModifier("modifier_legion_press_regen") then 
	self.target:GenericHeal(self.target:GetMaxHealth()*self:GetCaster():GetTalentValue("modifier_legion_press_regen", "regen")/100, self)
end 


self.duration = self:GetSpecialValueFor("duration") + self:GetCaster():GetTalentValue("modifier_legion_press_speed", "duration")

self:GetCaster():EmitSound("Hero_LegionCommander.PressTheAttack")


if self:GetCaster():HasModifier("modifier_legion_press_legendary") then 
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_press_the_attack_custom_legendary", {duration = self:GetCaster():GetTalentValue("modifier_legion_press_legendary", "duration")})
end 

self.target:AddNewModifier(self:GetCaster(), self, "modifier_press_the_attack_custom_buff", {duration = self.duration})

if self:GetCaster():HasModifier("modifier_legion_press_lowhp") then 
	self.target:AddNewModifier(self:GetCaster(), self, "modifier_press_the_attack_custom_unslow", {duration = self:GetCaster():GetTalentValue("modifier_legion_press_lowhp", "duration")})
end 


if not self:GetCaster():HasModifier("modifier_legion_press_after") then return end


local duration = self:GetCaster():GetTalentValue("modifier_legion_press_after", "root")
local pull_duration =self:GetCaster():GetTalentValue("modifier_legion_press_after", "pull_duration")
local pull_distance =self:GetCaster():GetTalentValue("modifier_legion_press_after", "pull_distance")

local wave_particle = ParticleManager:CreateParticle( "particles/lc_wave.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
ParticleManager:SetParticleControl( wave_particle, 1, self:GetCaster():GetAbsOrigin() )
ParticleManager:ReleaseParticleIndex(wave_particle)

local enemies = self:GetCaster():FindTargets(self:GetCaster():GetTalentValue("modifier_legion_press_after", "radius"))

for _,target in ipairs(enemies) do 

	local dir = target:GetAbsOrigin() - self:GetCaster():GetAbsOrigin()

	local point = self:GetCaster():GetAbsOrigin() + dir:Normalized()*pull_distance
	local distance = (point - target:GetAbsOrigin()):Length2D()


	local arc = target:AddNewModifier( self:GetCaster(),  self,  "modifier_generic_arc",  
	{
	  target_x = point.x,
	  target_y = point.y,
	  distance = distance,
	  duration = pull_duration,
	  height = 0,
	  fix_end = false,
	  isStun = false,
	  activity = ACT_DOTA_FLAIL,
	})

	if arc then 
  	arc:SetEndCallback(function()
  		if target and not target:IsNull() then
				target:AddNewModifier(self:GetCaster(), self, "modifier_press_the_attack_custom_root", {duration = (1 - target:GetStatusResistance())*duration})
				target:EmitSound("Lc.Press_Root")
			end
		end)
	end  
end


end




modifier_press_the_attack_custom_buff = class({})

function modifier_press_the_attack_custom_buff:IsHidden() return false end
function modifier_press_the_attack_custom_buff:IsPurgable() return true end
function modifier_press_the_attack_custom_buff:RemoveOnDeath() return true end

function modifier_press_the_attack_custom_buff:OnCreated(table)

self.parent = self:GetParent()
self.caster = self:GetCaster()

self.speed = self:GetAbility():GetSpecialValueFor("movespeed") + self:GetCaster():GetTalentValue("modifier_legion_press_cd", "move")
self.attack_speed = self.caster:GetTalentValue("modifier_legion_press_cd", "speed")
self.regen = self:GetAbility():GetSpecialValueFor("hp_regen")


self.heal = self:GetCaster():GetTalentValue("modifier_legion_press_regen", "heal")/100
self.creeps = self:GetCaster():GetTalentValue("modifier_legion_press_regen", "heal_creeps")

--self.magic_damage = self:GetCaster():GetTalentValue("modifier_legion_press_cd", "damage")
--self.damage_radius = self:GetCaster():GetTalentValue("modifier_legion_press_cd", "radius")

self.damage_min = self.caster:GetTalentValue("modifier_legion_press_duration", "damage_min")/100
self.damage_max = self.caster:GetTalentValue("modifier_legion_press_duration", "damage_max")/100
self.burn_heal = self.caster:GetTalentValue("modifier_legion_press_duration", "burn_heal")/100
self.burn_interval = self.caster:GetTalentValue("modifier_legion_press_duration", "interval")
self.aura_radius = self:GetCaster():GetTalentValue("modifier_legion_press_duration", "radius")

if not IsServer() then return end

self.RemoveForDuel = true

self:PlayEffect()

if not self:GetParent():HasModifier("modifier_legion_press_duration") then return end

self.aura_mod = self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_press_the_attack_custom_burn_aura", {duration = self:GetRemainingTime()})

self:GetParent():EmitSound("Lc.Press_burn")

self.burn_particle = ParticleManager:CreateParticle( "particles/econ/events/fall_2022/radiance/radiance_owner_fall2022.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
self:AddParticle(self.burn_particle,false, false, -1, false, false)

self:OnIntervalThink()
self:StartIntervalThink(self.burn_interval - FrameTime())
end


function modifier_press_the_attack_custom_buff:OnDestroy()
if not IsServer() then return end 
self:GetParent():StopSound("Lc.Press_burn")

if self.aura_mod and not self.aura_mod:IsNull() then 
	self.aura_mod:Destroy()
end 

end

function modifier_press_the_attack_custom_buff:OnRefresh(table)
if not IsServer() then return end 

self:PlayEffect()
end 

function modifier_press_the_attack_custom_buff:PlayEffect()
    if not IsServer() then return end
    if self.cast then 
        ParticleManager:DestroyParticle(self.cast, true)
        ParticleManager:ReleaseParticleIndex(self.cast)
    end 

    local particle_name = "particles/units/heroes/hero_legion_commander/legion_commander_press.vpcf"
    if self:GetCaster():HasModifier("modifier_legion_commander_wings_fallen_custom") then
        particle_name = "particles/econ/items/legion/legion_fallen/legion_fallen_press_owner.vpcf"
        self:GetCaster():AddActivityModifier("self")
        self:GetCaster():AddActivityModifier("lotfl")
    end
    if self:GetCaster():HasModifier("modifier_legion_commander_wings_fallen_custom_2") then
        particle_name = "particles/econ/items/legion/legion_fallen/legion_fallen_press_owner_alt.vpcf"
        self:GetCaster():AddActivityModifier("self")
    end

    self.cast = ParticleManager:CreateParticle( particle_name, PATTACH_CUSTOMORIGIN, self:GetParent() )
    ParticleManager:SetParticleControlEnt( self.cast, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetAbsOrigin(), true )
    ParticleManager:SetParticleControlEnt( self.cast, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true )
    ParticleManager:SetParticleControlEnt( self.cast, 2, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetParent():GetAbsOrigin(), true )
    self:AddParticle(self.cast,false, false, -1, false, false)

end 




function modifier_press_the_attack_custom_buff:OnIntervalThink()
if not IsServer() then return end
if not self:GetCaster():IsAlive() then return end

local enemies = self.parent:FindTargets(self.aura_radius)

local damage = (self.damage_min + (self.damage_max - self.damage_min)*(1 - self.parent:GetHealth()/self.parent:GetMaxHealth()))*self.parent:GetAverageTrueAttackDamage(nil)
self:SetStackCount(damage)

for _,enemy in pairs(enemies) do 
	local real_damage = ApplyDamage({victim = enemy,  damage = damage*self.burn_interval, damage_type = DAMAGE_TYPE_MAGICAL, attacker = self.caster, ability = self:GetAbility()})
end

end



function modifier_press_the_attack_custom_buff:OnAttackLanded(params)
if not IsServer() then return end 
if not self.parent:HasModifier("modifier_legion_press_cd") then  return end
if self.parent ~= params.attacker then return end 
if not params.target:IsCreep() and not params.target:IsHero() then return end


local targets = self.parent:FindTargets(self.damage_radius, params.target:GetAbsOrigin())

local particle = ParticleManager:CreateParticle("particles/lc_press_burn.vpcf", PATTACH_ABSORIGIN_FOLLOW, params.target)	
ParticleManager:ReleaseParticleIndex(particle)

for _,target in pairs(targets) do 
	ApplyDamage({victim = target,  damage = self.magic_damage, damage_type = DAMAGE_TYPE_MAGICAL, attacker = self.caster, ability = self:GetAbility()})
end 


end 




function modifier_press_the_attack_custom_buff:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
 	MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	--MODIFIER_EVENT_ON_ATTACK_LANDED,
	MODIFIER_EVENT_ON_TAKEDAMAGE
}

end


function modifier_press_the_attack_custom_buff:OnTakeDamage(params)
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_legion_press_regen") then return end
if self:GetParent() ~= params.attacker then return end
if not params.unit:IsCreep() and not params.unit:IsHero() then return end
if bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then return end

local heal = self.heal*params.damage

if params.unit:IsCreep() then 
	heal = heal/self.creeps
end


self:GetParent():GenericHeal(heal, self:GetAbility(), true)

end



function modifier_press_the_attack_custom_buff:GetActivityTranslationModifiers() 
if self:GetCaster() == self:GetParent() then 
	return "press_the_attack" 
end

end


function modifier_press_the_attack_custom_buff:GetModifierMoveSpeedBonus_Percentage()
return self.speed
end


function modifier_press_the_attack_custom_buff:GetModifierConstantHealthRegen()
return self.regen + self:GetStackCount()*self.burn_heal
end

function modifier_press_the_attack_custom_buff:GetModifierAttackSpeedBonus_Constant() 
return self.attack_speed 
end











modifier_press_the_attack_custom_root = class({})
function modifier_press_the_attack_custom_root:IsHidden() return true end
function modifier_press_the_attack_custom_root:IsPurgable() return true end
function modifier_press_the_attack_custom_root:GetTexture() return "buffs/press_root" end
function modifier_press_the_attack_custom_root:CheckState() return {[MODIFIER_STATE_ROOTED] = true} end
function modifier_press_the_attack_custom_root:GetEffectName() return "particles/lc_root.vpcf" end







modifier_press_the_attack_custom_legendary = class({})
function modifier_press_the_attack_custom_legendary:IsHidden() return true end
function modifier_press_the_attack_custom_legendary:IsPurgable() return false end
function modifier_press_the_attack_custom_legendary:GetEffectName() return "particles/legion_commander/press_legendary_buff.vpcf" end
function modifier_press_the_attack_custom_legendary:OnCreated()

self.damage_duration = self:GetCaster():GetTalentValue("modifier_legion_press_legendary", "damage_duration")
self.damage_reduce = self:GetCaster():GetTalentValue("modifier_legion_press_legendary", "damage_reduce")/100

self.time = self:GetRemainingTime()

if not IsServer() then return end
self:OnIntervalThink()
self:StartIntervalThink(0.03)
end 


function modifier_press_the_attack_custom_legendary:OnIntervalThink()
if not IsServer() then return end

CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), 'legion_press_change',  {hide = 0, max_time = self.time, time = self:GetRemainingTime(), damage = self:GetStackCount()})

end 



function modifier_press_the_attack_custom_legendary:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK
}
end



function modifier_press_the_attack_custom_legendary:GetModifierTotal_ConstantBlock(params)
if not IsServer() then return end
if self:GetParent() == params.attacker then return end

self:SetStackCount(self:GetStackCount() + params.damage * self.damage_reduce )

return params.damage * self.damage_reduce
end




function modifier_press_the_attack_custom_legendary:OnDestroy()
if not IsServer() then return end

CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), 'legion_press_change',  {hide = 1, max_time = self.time, time = self:GetRemainingTime(), damage = self:GetStackCount()})


if self:GetStackCount() <= 0 then return end

local damage = self:GetStackCount()
self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_press_the_attack_custom_legendary_damage", {damage = damage, duration = self.damage_duration + 2*FrameTime()})

end 




modifier_press_the_attack_custom_legendary_damage = class({})
function modifier_press_the_attack_custom_legendary_damage:IsHidden() return false end
function modifier_press_the_attack_custom_legendary_damage:IsPurgable() return false end
function modifier_press_the_attack_custom_legendary_damage:IsDebuff() return true end
function modifier_press_the_attack_custom_legendary_damage:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_press_the_attack_custom_legendary_damage:OnCreated(table)
if not IsServer() then return end

self.caster = self:GetCaster()
self.damage_duration = self:GetCaster():GetTalentValue("modifier_legion_press_legendary", "damage_duration")
self.damage_interval = self:GetCaster():GetTalentValue("modifier_legion_press_legendary", "damage_interval")
self.damage_radius = self:GetCaster():GetTalentValue("modifier_legion_press_legendary", "damage_radius")
self.damage_creeps = 1 - self:GetCaster():GetTalentValue("modifier_legion_press_legendary", "damage_creeps")/100


self.RemoveForDuel = true
self.damage = table.damage
self.tick = self.damage/(self.damage_duration + self.damage_interval)

self:OnIntervalThink()
self:StartIntervalThink(self.damage_interval)
end

function modifier_press_the_attack_custom_legendary_damage:OnIntervalThink()
if not IsServer() then return end

if not self:GetParent():IsInvulnerable() then 
	self:GetParent():SetHealth(math.max(1, self:GetParent():GetHealth() - self.tick))
end 
--self:GetParent():EmitSound("Lc.Press_legendary") 

self:GetParent():EmitSound("Lc.Press_Heal")
local effect_target = ParticleManager:CreateParticle( "particles/lc_press_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
ParticleManager:SetParticleControl( effect_target, 1, Vector( 200, 100, 100 ) )
ParticleManager:ReleaseParticleIndex( effect_target )


local enemies = self.caster:FindTargets(self.damage_radius)

for _,target in ipairs(enemies) do 

	local damage = self.tick 
	if target:IsCreep() then 
		damage = damage*self.damage_creeps
	end

	local damageTable = {victim = target,  damage = damage, damage_type = DAMAGE_TYPE_PURE, attacker = self.caster, ability = self:GetAbility()}
	 ApplyDamage(damageTable)
end

end



modifier_press_the_attack_custom_unslow = class({})
function modifier_press_the_attack_custom_unslow:IsHidden() return true end
function modifier_press_the_attack_custom_unslow:IsPurgable() return false end
function modifier_press_the_attack_custom_unslow:CheckState()
return
{
	[MODIFIER_STATE_UNSLOWABLE] = true
}
end
function modifier_press_the_attack_custom_unslow:OnDestroy()
if not IsServer() then return end 

local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_brewmaster/brewmaster_dispel_magic.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())

ParticleManager:ReleaseParticleIndex(particle)

self:GetParent():EmitSound("Lc.Press_Purge")
self:GetCaster():Purge(false, true, false, true, false)
end 



modifier_press_the_attack_custom_burn_effect = class({})

function modifier_press_the_attack_custom_burn_effect:IsHidden() return true end
function modifier_press_the_attack_custom_burn_effect:IsPurgable() return false end



function modifier_press_the_attack_custom_burn_effect:OnCreated()
if not IsServer() then return end
self.particle = ParticleManager:CreateParticle("particles/econ/events/fall_2022/radiance_target_fall2022.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControl(self.particle, 1, self:GetCaster():GetAbsOrigin())
self:AddParticle(self.particle,false, false, -1, false, false)

self:StartIntervalThink(0.5)
end

function modifier_press_the_attack_custom_burn_effect:OnIntervalThink()
if not IsServer() then return end 
if not self.particle then return end


ParticleManager:SetParticleControl(self.particle, 1, self:GetCaster():GetAbsOrigin())
end 





modifier_press_the_attack_custom_burn_aura = class({})
function modifier_press_the_attack_custom_burn_aura:IsPurgable() return true end
function modifier_press_the_attack_custom_burn_aura:IsHidden() return false end
function modifier_press_the_attack_custom_burn_aura:OnCreated()

self.aura_radius = self:GetCaster():GetTalentValue("modifier_legion_press_duration", "radius")
end


function modifier_press_the_attack_custom_burn_aura:IsAura() return true end

function modifier_press_the_attack_custom_burn_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY end

function modifier_press_the_attack_custom_burn_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end

function modifier_press_the_attack_custom_burn_aura:GetModifierAura()
	return "modifier_press_the_attack_custom_burn_effect"
end

function modifier_press_the_attack_custom_burn_aura:GetAuraRadius()
	return self.aura_radius
end


function modifier_press_the_attack_custom_burn_aura:GetAuraDuration()
return 0
end