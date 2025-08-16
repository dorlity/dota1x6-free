LinkLuaModifier( "modifier_marci_guardian_custom", "abilities/marci/marci_guardian_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_marci_guardian_custom_speed", "abilities/marci/marci_guardian_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_marci_guardian_custom_damage", "abilities/marci/marci_guardian_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_marci_guardian_custom_break_attack", "abilities/marci/marci_guardian_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_marci_guardian_custom_leash", "abilities/marci/marci_guardian_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_marci_guardian_custom_tracker", "abilities/marci/marci_guardian_custom", LUA_MODIFIER_MOTION_NONE )

marci_guardian_custom = class({})



function marci_guardian_custom:CreateTalent()
local ability = self:GetCaster():FindAbilityByName("marci_summon_mirana")

if ability then 
	ability:SetHidden(false)
end

end

function marci_guardian_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end


PrecacheResource( "particle","particles/units/heroes/hero_sven/sven_spell_great_cleave.vpcf", context )
PrecacheResource( "particle","particles/status_fx/status_effect_marci_sidekick.vpcf", context )
PrecacheResource( "particle","particles/units/heroes/hero_marci/marci_sidekick_self_buff.vpcf", context )
PrecacheResource( "particle","particles/units/heroes/hero_marci/marci_sidekick_buff.vpcf", context )
PrecacheResource( "particle","particles/units/heroes/hero_marci/marci_rebound_allymovespeed.vpcf", context )
PrecacheResource( "particle","particles/marci_wave.vpcf", context )
PrecacheResource( "particle","particles/marci_heal.vpcf", context )
PrecacheResource( "particle","particles/units/heroes/hero_marci/marci_unleash_attack.vpcf", context )
PrecacheResource( "particle","particles/units/heroes/hero_marci/marci_dispose_debuff.vpcf", context )
PrecacheResource( "particle","particles/units/heroes/hero_marci/marci_rebound_allymovespeed.vpcf", context )
PrecacheResource( "particle","particles/units/heroes/hero_troll_warlord/troll_warlord_bersekers_net.vpcf", context )
PrecacheResource( "particle","particles/sand_king/linken_active.vpcf", context )
PrecacheResource( "particle","particles/sand_king/linken_activea.vpcf", context )
end


function marci_guardian_custom:GetIntrinsicModifierName()
if not self:GetCaster():IsRealHero() then return end
return "modifier_marci_guardian_custom_tracker"
end



function marci_guardian_custom:GetManaCost(level)
if self:GetCaster():HasTalent("modifier_marci_sidekick_6") then  
  return 0
end
return self.BaseClass.GetManaCost(self,level)
end


function marci_guardian_custom:GetCooldown(iLevel)
local upgrade_cooldown = 0
if self:GetCaster():HasTalent("modifier_marci_sidekick_1") then  
	upgrade_cooldown = self:GetCaster():GetTalentValue("modifier_marci_sidekick_1", "cd")
end 
return self.BaseClass.GetCooldown(self, iLevel) + upgrade_cooldown
end



function marci_guardian_custom:OnSpellStart()
local caster = self:GetCaster()
local duration = self:GetSpecialValueFor( "buff_duration" ) + caster:GetTalentValue("modifier_marci_sidekick_1", "duration")

local ally = nil

self:EndCooldown()
self:SetActivated(false)
 

local friends = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_MAGIC_IMMUNE_ALLIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, 0, false)

for _,friend in pairs(friends) do 
	if friend.MacriSummon then 
		friend:AddNewModifier( caster, self, "modifier_marci_guardian_custom", { duration = duration } )
		ally = friend:entindex()
	end
end	

if caster:HasTalent("modifier_marci_sidekick_4") then 
	caster:AddNewModifier(caster, self, "modifier_marci_guardian_custom_damage", {ally = ally, duration = caster:GetTalentValue("modifier_marci_sidekick_4", "duration")})
end 

caster:AddNewModifier( caster, self, "modifier_marci_guardian_custom", { ally = ally, duration = duration } )

end



modifier_marci_guardian_custom = class({})

function modifier_marci_guardian_custom:IsPurgable() return true end
function modifier_marci_guardian_custom:OnCreated( kv )
self.caster = self:GetCaster()
self.parent = self:GetParent()
self.ability = self:GetAbility()
self.lifesteal = self:GetAbility():GetSpecialValueFor( "lifesteal_pct" )/100

self.caster:AddDamageEvent_out(self)

self.speed = self.caster:GetTalentValue("modifier_marci_sidekick_3", "speed")

self.base_damage = self.ability:GetSpecialValueFor( "bonus_damage" ) + self.caster:GetTalentValue("modifier_marci_sidekick_3", "damage")

if not IsServer() then return end

if self.caster:HasTalent("modifier_marci_sidekick_5") then 
	self.parent:AddNewModifier(self.caster, self.ability, "modifier_marci_guardian_custom_break_attack", {duration = self:GetRemainingTime()})
end 

self.ally = nil 

if self.parent ~= self.caster then 
	self.ally = self.caster
else 
	if kv.ally then 
		self.ally = EntIndexToHScript(kv.ally)
	end 
end 

if self.caster:HasTalent("modifier_marci_sidekick_2") then 
	self.lifesteal = self.lifesteal + self.caster:GetTalentValue("modifier_marci_sidekick_2", "heal")/100
	self.parent:GenericHeal(self.parent:GetMaxHealth()*self.caster:GetTalentValue("modifier_marci_sidekick_2", "cast_heal")/100, self.ability, nil, nil, "modifier_marci_sidekick_2")
end

if self.caster:HasTalent("modifier_marci_sidekick_6")then 
	self.parent:AddNewModifier(self.caster, self.ability, "modifier_marci_guardian_custom_speed", {duration = self.caster:GetTalentValue("modifier_marci_sidekick_6", "duration")})
end

self:PlayEffects1()
end


function modifier_marci_guardian_custom:OnDestroy()
if not IsServer() then return end 

if self.parent == self.caster then 
	self.ability:SetActivated(true)
	self.ability:UseResources(false, false, false, true)
end 

end


function modifier_marci_guardian_custom:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	MODIFIER_PROPERTY_TOOLTIP
}
end

function modifier_marci_guardian_custom:GetModifierBaseDamageOutgoing_Percentage()
return self.base_damage
end

function modifier_marci_guardian_custom:GetModifierAttackSpeedBonus_Constant()
if not self.caster:HasTalent("modifier_marci_sidekick_3") then return end 
return self.speed
end



function modifier_marci_guardian_custom:DamageEvent_out( params )
if not IsServer() then return end
if not params.unit:IsCreep() and not params.unit:IsHero() then return end 
if params.unit:IsIllusion() then return end

local attacker = params.attacker
if not attacker then return end

if attacker.owner then 
	attacker = attacker.owner
end 

local mod = self.parent:FindModifierByName("modifier_marci_guardian_custom_damage")
if mod and mod.damage_count and attacker == self.parent then 
	local add = params.damage*mod.damage_count
	if params.unit:IsCreep() then 
		add = add/mod.creeps
	end 

	mod:SetStackCount(mod:GetStackCount() + add)
end 

if self.parent ~= params.attacker then return end
if params.inflictor then return end

local heal = params.damage * self.lifesteal

if self.caster:GetQuest() == "Marci.Quest_7" and params.unit:IsRealHero() and not self.caster:QuestCompleted() then 
	self.caster:UpdateQuest(math.min(heal, self.parent:GetMaxHealth() - self.parent:GetHealth() ) )
end

local target = self.parent

if self.ally and not self.ally:IsNull() and self.ally:IsAlive() then 
	target = self.ally
end 

target:GenericHeal(heal, self.ability, true)
end



function modifier_marci_guardian_custom:ShouldUseOverheadOffset()
	return true
end

function modifier_marci_guardian_custom:GetStatusEffectName()
	return "particles/status_fx/status_effect_marci_sidekick.vpcf"
end

function modifier_marci_guardian_custom:StatusEffectPriority()
	return MODIFIER_PRIORITY_NORMAL
end


function modifier_marci_guardian_custom:PlayEffects1()
local particle_cast = "particles/units/heroes/hero_marci/marci_sidekick_self_buff.vpcf"
if self.parent~=self.caster then
	particle_cast = "particles/units/heroes/hero_marci/marci_sidekick_buff.vpcf"
end

local particle = ParticleManager:CreateParticle( particle_cast, PATTACH_OVERHEAD_FOLLOW, self.parent )
ParticleManager:SetParticleControl( particle, 1, self.parent:GetOrigin() )
ParticleManager:SetParticleControl( particle, 2, self.parent:GetOrigin() )
self:AddParticle( particle, false, false, 1, false, true )

self.parent:EmitSound("Hero_Marci.Guardian.Applied")
end








modifier_marci_guardian_custom_speed = class({})

function modifier_marci_guardian_custom_speed:IsHidden() return true end
function modifier_marci_guardian_custom_speed:IsPurgable() return false end

function modifier_marci_guardian_custom_speed:OnCreated( kv )
self.parent = self:GetParent()
self.speed = self.parent:GetTalentValue("modifier_marci_sidekick_6", "speed")

if not IsServer() then return end
self.parent:EmitSound("Hero_Marci.Rebound.Ally")
self.blocked = false

self.particle = ParticleManager:CreateParticle("particles/sand_king/linken_active.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
ParticleManager:SetParticleControlEnt(self.particle, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
self:AddParticle(self.particle, false, false, -1, false, false)
end

function modifier_marci_guardian_custom_speed:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
	MODIFIER_PROPERTY_ABSORB_SPELL,
	MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
}
end

function modifier_marci_guardian_custom_speed:GetModifierMoveSpeed_Absolute()
return self.speed
end

function modifier_marci_guardian_custom_speed:GetActivityTranslationModifiers()
return "haste"
end

function modifier_marci_guardian_custom_speed:GetEffectName()
return "particles/units/heroes/hero_marci/marci_rebound_allymovespeed.vpcf"
end

function modifier_marci_guardian_custom_speed:GetEffectAttachType()
return PATTACH_ABSORIGIN_FOLLOW
end


function modifier_marci_guardian_custom_speed:GetAbsorbSpell(params) 
if params.ability:GetCaster():GetTeamNumber() == self.parent:GetTeamNumber() then return end
if self.blocked == true then return end 

self.blocked = true

local particle = ParticleManager:CreateParticle("particles/sand_king/linken_activea.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
ParticleManager:SetParticleControlEnt(particle, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
ParticleManager:ReleaseParticleIndex(particle)

if self.particle then 
	ParticleManager:DestroyParticle(self.particle, true)
	ParticleManager:ReleaseParticleIndex(self.particle)
end 

self.parent:EmitSound("DOTA_Item.LinkensSphere.Activate")
return 1 
end









modifier_marci_guardian_custom_damage = class({})
function modifier_marci_guardian_custom_damage:IsHidden() return true end
function modifier_marci_guardian_custom_damage:IsPurgable() return false end
function modifier_marci_guardian_custom_damage:OnCreated(table)
self.caster = self:GetCaster()
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.damage_radius = self.caster:GetTalentValue("modifier_marci_sidekick_4", "radius")
self.damage_heal = self.caster:GetTalentValue("modifier_marci_sidekick_4", "heal")/100
self.damage_count = self.caster:GetTalentValue("modifier_marci_sidekick_4", "damage")/100
self.creeps = self.caster:GetTalentValue("modifier_marci_sidekick_4", "creeps")

if not IsServer() then return end 
self.max_time = self:GetRemainingTime()

if table.ally then 
	self.ally = EntIndexToHScript(table.ally)
end 

self:OnIntervalThink()
self:StartIntervalThink(FrameTime())
end 

function modifier_marci_guardian_custom_damage:OnIntervalThink()
if not IsServer() then return end

self.parent:UpdateUIshort({max_time = self.max_time, time = self:GetRemainingTime(), stack = self:GetStackCount(), style = "MarciSidekick"})
end



function modifier_marci_guardian_custom_damage:OnDestroy()
if not IsServer() then return end

self.parent:UpdateUIshort({hide = 1, hide_full = 1, style = "MarciSidekick"})

if not self.parent:IsAlive() then return end
if self:GetStackCount() == 0 then return end 

self.parent:EmitSound("Marci.Dispose_damage")
local wave_particle = ParticleManager:CreateParticle( "particles/marci_wave.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent )
ParticleManager:SetParticleControl( wave_particle, 1, self.parent:GetAbsOrigin() )
ParticleManager:DestroyParticle(wave_particle, false)
ParticleManager:ReleaseParticleIndex(wave_particle)

self:ProcHeal(self.parent)
if self.ally and not self.ally:IsNull() and self.ability:IsAlive() then 
	self:ProcHeal(self.ally)
end 

local damageTable = {attacker = self.parent, damage = self:GetStackCount(), damage_type = DAMAGE_TYPE_PURE, ability = self.ability }
for _,target in pairs(self.parent:FindTargets(self.damage_radius)) do 
	damageTable.victim = target
	local real_damage = DoDamage(damageTable, "modifier_marci_sidekick_4")
	target:SendNumber(6, real_damage)
end

end 



function modifier_marci_guardian_custom_damage:ProcHeal(target)
if not IsServer() then return end
local heal = self:GetStackCount()*self.damage_heal

target:EmitSound("Marci.Dispose_heal")

target:GenericHeal(heal, self.ability, nil, nil, "modifier_marci_sidekick_4")
local particle = ParticleManager:CreateParticle( "particles/marci_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, target )
ParticleManager:SetParticleControl( particle, 0, target:GetAbsOrigin() )
ParticleManager:SetParticleControl( particle, 1, target:GetAbsOrigin() )
ParticleManager:DestroyParticle(particle, false)
ParticleManager:ReleaseParticleIndex( particle )
end 



modifier_marci_guardian_custom_break_attack = class({})
function modifier_marci_guardian_custom_break_attack:IsHidden() return true end
function modifier_marci_guardian_custom_break_attack:IsPurgable() return false end
function modifier_marci_guardian_custom_break_attack:OnCreated()

self.caster = self:GetCaster()
self.parent = self:GetParent()
self.ability = self:GetAbility()


self.max_dist = self.caster:GetTalentValue("modifier_marci_sidekick_5", "max_dist")
self.duration = self.caster:GetTalentValue("modifier_marci_sidekick_5", "duration")
self.range = self.caster:GetTalentValue("modifier_marci_sidekick_5", "range")
end 


function modifier_marci_guardian_custom_break_attack:CheckState()
return
{
	[MODIFIER_STATE_CANNOT_MISS] = true
}
end

function modifier_marci_guardian_custom_break_attack:DeclareFunctions()
return 
{
	MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
}
end

function modifier_marci_guardian_custom_break_attack:GetModifierAttackRangeBonus()
return self.range
end


function modifier_marci_guardian_custom_break_attack:AttackEvent(params)
if not IsServer() then return end 
if self.parent ~= params.attacker then return end
if not params.target:IsUnit() then return end 

local target = params.target
local caster = self.parent

for i = 1,2 do 
	local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_marci/marci_unleash_attack.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
	ParticleManager:SetParticleControlEnt( particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true )
	ParticleManager:DestroyParticle(particle, false)
	ParticleManager:ReleaseParticleIndex( particle )
end

local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_marci/marci_dispose_debuff.vpcf", PATTACH_POINT_FOLLOW, caster )
ParticleManager:SetParticleControlEnt( particle, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true )
ParticleManager:SetParticleControlEnt( particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true )
ParticleManager:SetParticleControl( particle, 5, Vector( 2, 0, 0 ) )
ParticleManager:DestroyParticle(particle, false)
ParticleManager:ReleaseParticleIndex( particle )
target:EmitSound("SandKing.Attack_pull")

local dir = (caster:GetAbsOrigin() - target:GetAbsOrigin()):Normalized()
local point = caster:GetAbsOrigin() - dir*100
local distance = (point - target:GetAbsOrigin()):Length2D()

distance = math.min(self.max_dist, math.max(40, distance))
point = target:GetAbsOrigin() + dir*distance

local mod = target:AddNewModifier( self.caster, self.ability,  "modifier_generic_arc",  
{
  target_x = point.x,
  target_y = point.y,
  distance = distance,
  duration = 0.2,
  height = 0,
  fix_end = false,
  isStun = false,
  activity = ACT_DOTA_FLAIL,
})

target:GenericParticle("particles/units/heroes/hero_marci/marci_rebound_allymovespeed.vpcf", mod)

target:AddNewModifier(self.caster, self.ability, "modifier_marci_guardian_custom_leash", {duration = self.duration*(1 - target:GetStatusResistance())})

self:Destroy()
end 



modifier_marci_guardian_custom_leash = class({})
function modifier_marci_guardian_custom_leash:IsHidden() return true end
function modifier_marci_guardian_custom_leash:IsPurgable() return true end
function modifier_marci_guardian_custom_leash:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_marci_guardian_custom_leash:CheckState()
return
{
	[MODIFIER_STATE_ROOTED] = true,
	[MODIFIER_STATE_EVADE_DISABLED] = true
}
end

function modifier_marci_guardian_custom_leash:OnCreated()
self.parent = self:GetParent()

if not IsServer() then return end
self:StartIntervalThink(0.25)
end

function modifier_marci_guardian_custom_leash:OnIntervalThink()
if not IsServer() then return end

self.parent:GenericParticle("particles/units/heroes/hero_troll_warlord/troll_warlord_bersekers_net.vpcf", self)
self.parent:EmitSound("n_creep_TrollWarlord.Ensnare")
self:StartIntervalThink(-1)
end






modifier_marci_guardian_custom_tracker = class({})
function modifier_marci_guardian_custom_tracker:IsHidden() return true end
function modifier_marci_guardian_custom_tracker:IsPurgable() return false end
function modifier_marci_guardian_custom_tracker:OnCreated()
self.parent = self:GetParent()
self.ability = self:GetAbility()
self.cleave = self.ability:GetSpecialValueFor("cleave_damage")

self.parent:AddAttackEvent_out(self)
end

function modifier_marci_guardian_custom_tracker:OnRefresh(table)
self.cleave = self.ability:GetSpecialValueFor("cleave_damage")
end

function modifier_marci_guardian_custom_tracker:AttackEvent_out(params)
if not IsServer() then return end
if not params.target:IsUnit() then return end

local attacker = params.attacker
if attacker.owner then
	attacker = attacker.owner
end

if attacker ~= self.parent then return end
local leash_mod = params.attacker:FindModifierByName("modifier_marci_guardian_custom_break_attack")
if leash_mod then
	leash_mod:AttackEvent(params)
end

if params.attacker ~= self.parent then return end
if self.parent:HasModifier("modifier_no_cleave") then return end

local mod = self.parent:FindModifierByName("modifier_marci_guardian_custom")
if not mod then return end

params.target:EmitSound("Hero_Sven.GreatCleave")
DoCleaveAttack( self.parent, params.target, self.ability, self.cleave*params.damage/100, 150, 360, 500, "particles/units/heroes/hero_sven/sven_spell_great_cleave.vpcf" )
end

