LinkLuaModifier("modifier_overwhelming_odds_speed", "abilities/legion_commander/custom_legion_commander_overwhelming_odds", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_overwhelming_odds_slow", "abilities/legion_commander/custom_legion_commander_overwhelming_odds", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_overwhelming_odds_passive", "abilities/legion_commander/custom_legion_commander_overwhelming_odds", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_overwhelming_odds_legendary", "abilities/legion_commander/custom_legion_commander_overwhelming_odds", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_overwhelming_odds_proc_charge", "abilities/legion_commander/custom_legion_commander_overwhelming_odds", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_overwhelming_odds_shield", "abilities/legion_commander/custom_legion_commander_overwhelming_odds", LUA_MODIFIER_MOTION_NONE)





custom_legion_commander_overwhelming_odds = class({})



function custom_legion_commander_overwhelming_odds:Precache(context)

PrecacheResource( "particle", "particles/units/heroes/hero_legion_commander/legion_weapon_blur.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_legion_commander/legion_weapon_blurb.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_legion_commander/legion_weapon_blurc.vpcf", context )


PrecacheResource( "particle", "particles/units/heroes/hero_legion_commander/legion_commander_odds_cast.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_legion_commander/legion_commander_odds.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_legion_commander/legion_commander_odds_dmga.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_legion_commander/legion_commander_odds_buff.vpcf", context )
PrecacheResource( "particle", "particles/lc_odd_proc_burst.vpcf", context )
PrecacheResource( "particle", "particles/lc_odd_proc_.vpcf", context )
PrecacheResource( "particle", "particles/lc_odd_proc_hands.vpcf", context )
PrecacheResource( "particle", "particles/lc_odd_charge_hit_.vpcf", context )
PrecacheResource( "particle", "particles/lc_odd_charge.vpcf", context )
PrecacheResource( "particle", "particles/lc_odds_l.vpcf", context )

end

function custom_legion_commander_overwhelming_odds:GetAbilityTextureName()
    if self:GetCaster():HasModifier("modifier_legion_commander_ti7_head_custom") then
        return "legion_commander/immortal/legion_commander_overwhelming_odds"
    end
    return "legion_commander_overwhelming_odds"
end

function custom_legion_commander_overwhelming_odds:GetAbilityTargetFlags()
if self:GetCaster():HasModifier("modifier_legion_odds_solo") then 
  return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
else 
  return DOTA_UNIT_TARGET_FLAG_NONE
end

end


function custom_legion_commander_overwhelming_odds:GetBehavior()

if self:GetCaster():HasModifier("modifier_legion_odds_mark") then 
	return DOTA_ABILITY_BEHAVIOR_AOE + DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING + DOTA_ABILITY_BEHAVIOR_AUTOCAST
end

return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING
end


function custom_legion_commander_overwhelming_odds:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function custom_legion_commander_overwhelming_odds:GetCastPoint(iLevel)
if self:GetCaster():HasModifier('modifier_legion_odds_mark') then 
	return self.BaseClass.GetCastPoint(self) + self:GetCaster():GetTalentValue("modifier_legion_odds_mark", "cast")
end

return self.BaseClass.GetCastPoint(self)
end


function custom_legion_commander_overwhelming_odds:GetManaCost(level)

if self:GetCaster():HasModifier("modifier_legion_odds_solo") then 
	return self:GetCaster():GetTalentValue("modifier_legion_odds_solo", "mana")
end 

return self.BaseClass.GetManaCost(self,level)
end





function custom_legion_commander_overwhelming_odds:GetIntrinsicModifierName() return "modifier_overwhelming_odds_passive" end




function custom_legion_commander_overwhelming_odds:GetCastRange(location, target)
if IsClient() then 

	if self:GetCaster():HasModifier("modifier_legion_odds_mark") then 
		return self:GetCaster():GetTalentValue("modifier_legion_odds_mark", "range")
	end

    return self.BaseClass.GetCastRange(self, location, target)
else 
	return 999999
end

end







function custom_legion_commander_overwhelming_odds:GetAOERadius() 
return self:GetSpecialValueFor("radius") 
end


function custom_legion_commander_overwhelming_odds:OnAbilityPhaseStart()
if not IsServer() then return end
    self.cast = ParticleManager:CreateParticle("particles/units/heroes/hero_legion_commander/legion_commander_odds_cast.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster())
    ParticleManager:SetParticleControlEnt( self.cast, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true )

	self:GetCaster():EmitSound("Hero_LegionCommander.Overwhelming.Cast")
return true 
end

function custom_legion_commander_overwhelming_odds:OnAbilityPhaseInterrupted()
if not IsServer() then return end

	ParticleManager:DestroyParticle(self.cast, false)
    ParticleManager:ReleaseParticleIndex(self.cast)
end





function custom_legion_commander_overwhelming_odds:OnSpellStart( auto, legendary_stacks )
if not IsServer() then return end
self.caster = self:GetCaster()


self.point = self:GetCaster():GetAbsOrigin()

if self:GetCaster():HasModifier("modifier_legion_odds_mark") and auto == nil then 
	self.point = self:GetCursorPosition()

	local vec = (self.point - self:GetCaster():GetAbsOrigin())

	self.caster:FaceTowards(self.point)
	self.caster:SetForwardVector(vec:Normalized() )

	local range = self:GetCaster():GetTalentValue("modifier_legion_odds_mark", "range") + self:GetCaster():GetCastRangeBonus()
	if vec:Length2D() > range  then 
		self.point = self:GetCaster():GetAbsOrigin() + vec:Normalized()*range
	end

	if self:GetAutoCastState() == true then 
		local duration = (self.point - self:GetCaster():GetAbsOrigin()):Length2D()/self.caster:GetTalentValue("modifier_legion_odds_mark", "speed")
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_overwhelming_odds_proc_charge", {x = self.point.x, y = self.point.y, z = self.point.z, duration = duration})
	end
end


self.radius = self:GetSpecialValueFor("radius")
self.damage = self:GetSpecialValueFor("damage")
self.illusion_damage = self:GetSpecialValueFor("illusion_dmg_pct")
self.duration = self:GetSpecialValueFor("duration")
self.speed_change = self:GetSpecialValueFor("speed_change")

if self:GetCaster():HasModifier("modifier_legion_odds_cd") then 
	self.duration = self.duration + self:GetCaster():GetTalentValue("modifier_legion_odds_cd", "duration")
end

if self:GetCaster():HasModifier("modifier_legion_odds_triple") then 
	self.damage = self.damage + self:GetCaster():GetAverageTrueAttackDamage(nil)*self:GetCaster():GetTalentValue("modifier_legion_odds_triple", "damage")/100
end

if legendary_stacks and legendary_stacks > 0 then 
	self.damage = self.damage * (1 + legendary_stacks*self.caster:GetTalentValue("modifier_legion_odds_legendary", "damage")/100)
end

local particle_cast = "particles/units/heroes/hero_legion_commander/legion_commander_odds.vpcf"
local sound_cast = "Hero_LegionCommander.Overwhelming.Location"

if self:GetCaster():HasModifier("modifier_legion_commander_ti7_head_custom") then
    particle_cast = "particles/legion_custom_odds/legion_custom_odds.vpcf"
    sound_cast = "Hero_LegionCommander.Overwhelming.Location.ti7"
end


EmitSoundOnLocationWithCaster(self.point, sound_cast, self.caster)

local particle = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
ParticleManager:SetParticleControl( particle, 0, self.point )
ParticleManager:SetParticleControl( particle, 1, self:GetCaster():GetAbsOrigin() )
ParticleManager:SetParticleControl( particle, 2, self.point )
ParticleManager:SetParticleControl( particle, 3, self.point )
ParticleManager:SetParticleControl( particle, 4, Vector( self.radius, self.radius, self.radius ) )
ParticleManager:SetParticleControl( particle, 6, self.point )
ParticleManager:ReleaseParticleIndex( particle )



local flag = DOTA_UNIT_TARGET_FLAG_NONE

self.enemies = FindUnitsInRadius(self.caster:GetTeamNumber(),self.point,nil,self.radius,DOTA_UNIT_TARGET_TEAM_ENEMY,DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,flag,FIND_ANY_ORDER,false)


  
local stun = false


if legendary_stacks and legendary_stacks >= self.caster:GetTalentValue("modifier_legion_odds_legendary", "stun_stacks") then 
	EmitSoundOnLocationWithCaster(self.point, "Lc.Odds_Proc_Damage", self.caster)
	stun = true
	local particle = ParticleManager:CreateParticle( "particles/lc_odd_proc_burst.vpcf", PATTACH_WORLDORIGIN, nil )
 	ParticleManager:SetParticleControl( particle, 0, self.point )
 	ParticleManager:SetParticleControl( particle, 1, Vector( self.radius, self.radius, self.radius ) )
  	ParticleManager:ReleaseParticleIndex( particle )
end

self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_overwhelming_odds_speed", {duration = self.duration})

if self:GetCaster():HasModifier("modifier_legion_odds_creep") then 
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_overwhelming_odds_shield", {duration = self.duration})
end 

self.legendary_stun = self.caster:GetTalentValue("modifier_legion_odds_legendary", "stun")
self.silence_duration = self.caster:GetTalentValue("modifier_legion_odds_solo", "silence")

for _,enemy in ipairs(self.enemies) do 
	enemy:EmitSound("Hero_LegionCommander.Overwhelming.Creep")

    local particle_damage = "particles/units/heroes/hero_legion_commander/legion_commander_odds_dmga.vpcf"
    if self:GetCaster():HasModifier("modifier_legion_commander_ti7_head_custom") then
        particle_damage = "particles/econ/items/legion/legion_overwhelming_odds_ti7/legion_commander_odds_ti7_creep.vpcf"
    end

	local particle_peffect = ParticleManager:CreateParticle(particle_damage, PATTACH_ABSORIGIN_FOLLOW, enemy)
	ParticleManager:SetParticleControlEnt(particle_peffect , 0, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(particle_peffect , 1, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(particle_peffect , 3, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(particle_peffect)

	enemy:AddNewModifier(self:GetCaster(), self:GetCaster():BkbAbility(self, self:GetCaster():HasModifier("modifier_legion_odds_solo")), "modifier_overwhelming_odds_slow", {duration = self.duration*(1 - enemy:GetStatusResistance())})

	if self:GetCaster():HasModifier("modifier_legion_odds_solo") then 
		local silence_duration = (1 - enemy:GetStatusResistance())*self.silence_duration
		enemy:AddNewModifier(self:GetCaster(), self:GetCaster():BkbAbility(self, self:GetCaster():HasModifier("modifier_legion_odds_solo")), "modifier_generic_silence", {duration = silence_duration })	
	end

	local illusion = 0
	if enemy:IsIllusion() then 
		illusion = enemy:GetMaxHealth()*self.illusion_damage / 100
	end

	if stun == true then 
		enemy:AddNewModifier(self.caster, self:GetCaster():BkbAbility(self, self:GetCaster():HasModifier("modifier_legion_odds_solo")), "modifier_stunned", {duration = self.legendary_stun*(1 - enemy:GetStatusResistance())})
	end 

	local damageTable = {victim = enemy,  damage = self.damage + illusion, damage_type = DAMAGE_TYPE_MAGICAL, attacker = self.caster, ability = self}
	local actualy_damage = ApplyDamage(damageTable)
end


if self:GetCaster():HasModifier("modifier_legion_odds_legendary") and (auto == nil or legendary_stacks == nil) then 
	self:GetCaster():RemoveModifierByName("modifier_overwhelming_odds_legendary")
 	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_overwhelming_odds_legendary", {duration = self.caster:GetTalentValue("modifier_legion_odds_legendary", "duration")})
end


end




modifier_overwhelming_odds_speed = class({})

function modifier_overwhelming_odds_speed:IsHidden() return false end
function modifier_overwhelming_odds_speed:IsPurgable() return true end
function modifier_overwhelming_odds_speed:OnCreated(table)

self.speed = self:GetAbility():GetSpecialValueFor("attack_speed")

self.bonus_speed = self:GetCaster():GetTalentValue("modifier_legion_odds_proc", "speed")
self.bonus_max = self:GetCaster():GetTalentValue("modifier_legion_odds_proc", "max")

self.status = self:GetCaster():GetTalentValue("modifier_legion_odds_creep", "status")


if not IsServer() then return end
 
local particle_buff = "particles/units/heroes/hero_legion_commander/legion_commander_odds_buff.vpcf"
if self:GetCaster():HasModifier("modifier_legion_commander_ti7_head_custom") then
    particle_buff = "particles/econ/items/legion/legion_overwhelming_odds_ti7/legion_commander_odds_ti7_buff.vpcf"
end
self.poof = ParticleManager:CreateParticle(particle_buff, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControl(self.poof, 0, self:GetParent():GetAbsOrigin())

end


function modifier_overwhelming_odds_speed:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
 	MODIFIER_EVENT_ON_ATTACK_LANDED,
	MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
}
end


function modifier_overwhelming_odds_speed:GetModifierStatusResistanceStacking()
return self.status
end







function modifier_overwhelming_odds_speed:OnAttackLanded(params)
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_legion_odds_proc") then return end
if self:GetParent() ~= params.attacker then return end
if not params.target:IsCreep() and not params.target:IsHero() then return end
if self:GetStackCount() >= self.bonus_max then return end

self:IncrementStackCount()
end


function modifier_overwhelming_odds_speed:GetModifierAttackSpeedBonus_Constant()
local bonus = 0

if self:GetParent():HasModifier("modifier_legion_odds_proc") then 
	bonus = self:GetStackCount()*self.bonus_speed
end
return self.speed + bonus
end





function modifier_overwhelming_odds_speed:OnDestroy()
if not IsServer() then return end
	ParticleManager:DestroyParticle(self.poof, false)
	ParticleManager:ReleaseParticleIndex(self.poof)
end







modifier_overwhelming_odds_passive = class({})

function modifier_overwhelming_odds_passive:IsHidden() return true end
function modifier_overwhelming_odds_passive:IsPurgable() return false end
function modifier_overwhelming_odds_passive:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_ATTACK_LANDED
}

end

function modifier_overwhelming_odds_passive:OnAttackLanded(params)
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_legion_odds_proc") then return end
if self:GetParent() ~= params.attacker then return end
if not params.target:IsHero() and not params.target:IsCreep() then return end

local cd = self:GetCaster():GetTalentValue("modifier_legion_odds_proc", "cd")


self:GetCaster():CdAbility(self:GetAbility(), cd)


end










modifier_overwhelming_odds_legendary = class({})
function modifier_overwhelming_odds_legendary:IsHidden() return true end
function modifier_overwhelming_odds_legendary:IsPurgable() return false end
function modifier_overwhelming_odds_legendary:GetTexture() return "buffs/odds_legendary" end

function modifier_overwhelming_odds_legendary:OnCreated(table)
if not IsServer() then return end
self.RemoveForDuel = true 

self.max = self:GetCaster():GetTalentValue("modifier_legion_odds_legendary", "stun_stacks")
self.t = 0


self.interval = 0.05
self.count = 0.5 
self.time = self:GetRemainingTime()

self.timer = table.duration*2 
self:StartIntervalThink(self.interval)
self:OnIntervalThink()


self:SetStackCount(0)
end



function modifier_overwhelming_odds_legendary:OnIntervalThink()
if not IsServer() then return end

CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), 'legion_odds_change',  {hide = 0, active = self:GetStackCount() >= self.max, max_time = self.time, time = self:GetRemainingTime(), damage = self:GetStackCount()})


self.count = self.count + self.interval

if self.count >= 0.5 then 
  self.count = 0
else 
  return
end
self.t = self.t + 1

local caster = self:GetParent()

local number = (self.timer-self.t)/2 
local int = 0
int = number
if number % 1 ~= 0 then int = number - 0.5  end

local digits = math.floor(math.log10(number)) + 2

local decimal = number % 1

if decimal == 0.5 then
  decimal = 8
else 
  decimal = 1
end

local particleName = "particles/lina_timer.vpcf"
local particle = ParticleManager:CreateParticle(particleName, PATTACH_OVERHEAD_FOLLOW, caster)
ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin())
ParticleManager:SetParticleControl(particle, 1, Vector(0, int, decimal))
ParticleManager:SetParticleControl(particle, 2, Vector(digits, 0, 0))
ParticleManager:ReleaseParticleIndex(particle)

end



function modifier_overwhelming_odds_legendary:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_ATTACK_LANDED
}
end


function modifier_overwhelming_odds_legendary:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end
if params.target:IsBuilding() then return end

self:IncrementStackCount()
end


function modifier_overwhelming_odds_legendary:OnDestroy()
if not IsServer() then return end 
CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), 'legion_odds_change',  {hide = 1, active = false, max_time = self.time, time = self:GetRemainingTime(), damage = self:GetStackCount()})


if not self:GetParent():IsAlive() then return end

self:GetAbility():OnSpellStart(1, self:GetStackCount())
end 













modifier_overwhelming_odds_slow = class({})

function modifier_overwhelming_odds_slow:IsHidden() return false end
function modifier_overwhelming_odds_slow:IsPurgable() return true end

function modifier_overwhelming_odds_slow:OnCreated(table)
self.ability = self:GetCaster():FindAbilityByName("custom_legion_commander_overwhelming_odds")

if not self.ability then 
	self:Destroy()
	return
end 

self.move = self.ability:GetSpecialValueFor("move_slow")

if self:GetCaster():HasModifier("modifier_legion_odds_cd")  then 
	self.move = self.move + self:GetCaster():GetTalentValue("modifier_legion_odds_cd", "slow")
end

end

function modifier_overwhelming_odds_slow:DeclareFunctions()
return
{
 	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
}
end



function modifier_overwhelming_odds_slow:GetModifierMoveSpeedBonus_Percentage() 
	return self.move
end


function modifier_overwhelming_odds_slow:GetEffectName()
    return "particles/units/heroes/hero_snapfire/hero_snapfire_shotgun_debuff.vpcf"
end

function modifier_overwhelming_odds_slow:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_overwhelming_odds_slow:GetStatusEffectName()
    return "particles/status_fx/status_effect_snapfire_slow.vpcf"
end

function modifier_overwhelming_odds_slow:StatusEffectPriority()
    return MODIFIER_PRIORITY_NORMAL
end











modifier_overwhelming_odds_proc_charge = class({})

function modifier_overwhelming_odds_proc_charge:IsDebuff() return false end
function modifier_overwhelming_odds_proc_charge:IsHidden() return true end
function modifier_overwhelming_odds_proc_charge:IsPurgable() return true end

function modifier_overwhelming_odds_proc_charge:OnCreated(kv)
    if not IsServer() then return end
    self.pfx = ParticleManager:CreateParticle("particles/items_fx/force_staff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
    self:GetParent():StartGesture(ACT_DOTA_RUN)

    self.point = Vector(kv.x, kv.y, kv.z)

	self:GetParent():EmitSound("Lc.Odds_Charge")

    self.angle = self:GetParent():GetForwardVector():Normalized()--(self.point - self:GetParent():GetAbsOrigin()):Normalized() 

    self.distance = (self.point - self:GetCaster():GetAbsOrigin()):Length2D() / ( self:GetDuration() / FrameTime())

    self.targets = {}

    if self:ApplyHorizontalMotionController() == false then
        self:Destroy()
    end
end

function modifier_overwhelming_odds_proc_charge:GetEffectName() return "particles/lc_odd_charge.vpcf" end

function modifier_overwhelming_odds_proc_charge:DeclareFunctions()
return
{
 MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
    MODIFIER_PROPERTY_DISABLE_TURNING
}
end

function modifier_overwhelming_odds_proc_charge:GetActivityTranslationModifiers()
    return "press_the_attack"
end


function modifier_overwhelming_odds_proc_charge:GetModifierDisableTurning() return 1 end

function modifier_overwhelming_odds_proc_charge:GetStatusEffectName() return "particles/status_fx/status_effect_forcestaff.vpcf" end

function modifier_overwhelming_odds_proc_charge:StatusEffectPriority() return 100 end

function modifier_overwhelming_odds_proc_charge:OnDestroy()
    if not IsServer() then return end
    self:GetParent():InterruptMotionControllers( true )
    ParticleManager:DestroyParticle(self.pfx, false)
    ParticleManager:ReleaseParticleIndex(self.pfx)

    self:GetParent():FadeGesture(ACT_DOTA_RUN)
   -- self:GetParent():StartGesture(ACT_DOTA_FORCESTAFF_END)


    local dir = self:GetParent():GetForwardVector()
    dir.z = 0
    self:GetParent():SetForwardVector(dir)
    self:GetParent():FaceTowards(self:GetParent():GetAbsOrigin() + dir*10)

    ResolveNPCPositions(self:GetParent():GetAbsOrigin(), 128)

end


function modifier_overwhelming_odds_proc_charge:UpdateHorizontalMotion( me, dt )
    if not IsServer() then return end
    local pos = self:GetParent():GetAbsOrigin()
    GridNav:DestroyTreesAroundPoint(pos, 80, false)
    local pos_p = self.angle * self.distance
    local next_pos = GetGroundPosition(pos + pos_p,self:GetParent())
    self:GetParent():SetAbsOrigin(next_pos)


end

function modifier_overwhelming_odds_proc_charge:OnHorizontalMotionInterrupted()
    self:Destroy()
end




function modifier_overwhelming_odds_proc_charge:CheckState()
return
{
	[MODIFIER_STATE_SILENCED] = true,
	[MODIFIER_STATE_DISARMED] = true
}
end












modifier_overwhelming_odds_shield = class({})
function modifier_overwhelming_odds_shield:IsHidden() return true end
function modifier_overwhelming_odds_shield:IsPurgable() return false end
function modifier_overwhelming_odds_shield:OnCreated(table)

self.max_shield = self:GetCaster():GetTalentValue("modifier_legion_odds_creep", "shield")*self:GetCaster():GetMaxHealth()/100

if not IsServer() then return end
self.RemoveForDuel = true

self.effect = ParticleManager:CreateParticle( "particles/items2_fx/vindicators_axe_armor.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
self:AddParticle(self.effect,false, false, -1, false, false)
self:SetStackCount(self.max_shield)
end

function modifier_overwhelming_odds_shield:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_INCOMING_DAMAGE_CONSTANT,
}
end

function modifier_overwhelming_odds_shield:GetModifierIncomingDamageConstant( params )

if IsClient() then 
	if params.report_max then 
		return self.max_shield
	else 
     	return self:GetStackCount()
    end 
end

if not IsServer() then return end

if self:GetStackCount() > params.damage then
    self:SetStackCount(self:GetStackCount() - params.damage)
    local i = params.damage
    return -i
else
    
    local i = self:GetStackCount()
    self:SetStackCount(0)
    self:Destroy()
    return -i
end

end