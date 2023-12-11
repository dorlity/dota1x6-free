LinkLuaModifier( "modifier_arc_warden_flux_custom", "abilities/arc_warden/arc_warden_flux_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_arc_warden_flux_custom_legendary", "abilities/arc_warden/arc_warden_flux_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_arc_warden_flux_custom_legendary_cd", "abilities/arc_warden/arc_warden_flux_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_arc_warden_flux_custom_legendary_tempest_cd", "abilities/arc_warden/arc_warden_flux_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_arc_warden_flux_custom_dash", "abilities/arc_warden/arc_warden_flux_custom", LUA_MODIFIER_MOTION_HORIZONTAL )
LinkLuaModifier( "modifier_arc_warden_flux_custom_count", "abilities/arc_warden/arc_warden_flux_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_arc_warden_flux_custom_resist", "abilities/arc_warden/arc_warden_flux_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_arc_warden_flux_custom_tracker", "abilities/arc_warden/arc_warden_flux_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_arc_warden_flux_custom_speed", "abilities/arc_warden/arc_warden_flux_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_arc_warden_flux_custom_silence", "abilities/arc_warden/arc_warden_flux_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_arc_warden_flux_custom_incoming", "abilities/arc_warden/arc_warden_flux_custom", LUA_MODIFIER_MOTION_NONE )


arc_warden_flux_custom = class({})








function arc_warden_flux_custom:GetIntrinsicModifierName()
return "modifier_arc_warden_flux_custom_tracker"
end 


function arc_warden_flux_custom:GetCastPoint(iLevel)
if self:GetCaster():HasModifier('modifier_arc_warden_flux_6') then 
	return self.BaseClass.GetCastPoint(self) + self:GetCaster():GetTalentValue("modifier_arc_warden_flux_6", "cast")
end

return self.BaseClass.GetCastPoint(self)
end



function arc_warden_flux_custom:GetBehavior()
  if self:GetCaster():HasModifier("modifier_arc_warden_flux_6") then
    return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_VECTOR_TARGETING
  end
 return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET
end





function arc_warden_flux_custom:Precache(context)

PrecacheResource( "particle", "particles/arc_warden/flux_self.vpcf", context )
PrecacheResource( "particle", "particles/arc_warden/flux_self_tempest.vpcf", context )
PrecacheResource( "particle", "particles/void_astral_slow.vpcf", context )
PrecacheResource( "particle", "particles/econ/items/outworld_devourer/od_shards_exile/od_shards_exile_prison_end.vpcf", context )
PrecacheResource( "particle", "particles/zuus_speed.vpcf", context )
PrecacheResource( "particle", "particles/ta_trap_damage.vpcf", context )

end




function arc_warden_flux_custom:GetCastRange(location, target)
local bonus = 0

if self:GetCaster():HasModifier("modifier_arc_warden_flux_1") then 
	bonus = self:GetCaster():GetTalentValue("modifier_arc_warden_flux_1", "cast")
end

	return self.BaseClass.GetCastRange(self, location, target) + bonus
end


function arc_warden_flux_custom:GetAbilityTextureName()
	if self:GetCaster():HasModifier("modifier_arc_warden_tempest_double") then
		return 'arc_warden_flux_tempest'
	else
		return "arc_warden_flux"
	end
end

function arc_warden_flux_custom:GetCastAnimation()
return
end


function arc_warden_flux_custom:GetFluxDamage()

local damage_per_second	= self:GetSpecialValueFor("damage_per_second")

local bonus = 0

if self:GetCaster():HasModifier("modifier_arc_warden_flux_2") then 
	--bonus = self.damage_inc[self:GetCaster():GetUpgradeStack("modifier_arc_warden_flux_2")]*self:GetCaster():GetMaxHealth()
end 


if self:GetCaster():HasModifier("modifier_arc_warden_tempest_double") then
	damage_per_second = self:GetSpecialValueFor("tempest_damage_per_second")
--	bonus = bonus*self.damage_tempest
end



return damage_per_second + bonus

end 




function arc_warden_flux_custom:Cast(target)

local duration = self:GetSpecialValueFor("duration")

if self:GetCaster():HasModifier("modifier_arc_warden_flux_5") then 
	duration = duration + self:GetCaster():GetTalentValue("modifier_arc_warden_flux_5", "duration")
end 

self:GetCaster():MoveToTargetToAttack(target)

self:GetCaster():EmitSound("Hero_ArcWarden.Flux.Cast")
target:EmitSound("Hero_ArcWarden.Flux.Target")

local cast_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_arc_warden/arc_warden_flux_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
ParticleManager:SetParticleControlEnt(cast_particle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(cast_particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(cast_particle, 2, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack2", self:GetCaster():GetAbsOrigin(), true)
ParticleManager:ReleaseParticleIndex(cast_particle)

local tempest = 0
if self:GetCaster():HasModifier("modifier_arc_warden_tempest_double") then
	tempest = 1
end 

if self:GetCaster():HasModifier("modifier_arc_warden_flux_7") then 

	self.parent = self:GetCaster()

	local qangle_rotation_rate = 60
	local line_position = self.parent:GetAbsOrigin() + self.parent:GetForwardVector() * 350
	for i = 1, 6 do

		local qangle = QAngle(0, qangle_rotation_rate, 0)
		line_position = RotatePosition(self.parent:GetAbsOrigin() , qangle, line_position)

		local cast_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_arc_warden/arc_warden_flux_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
		ParticleManager:SetParticleControlEnt(cast_particle, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(cast_particle, 1, line_position)
		ParticleManager:SetParticleControlEnt(cast_particle, 2, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(cast_particle)

	end

	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_arc_warden_flux_custom_legendary", {duration = duration})
end

if self:GetCaster():HasModifier("modifier_arc_warden_flux_1") then 
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_arc_warden_flux_custom_speed", {duration = self:GetCaster():GetTalentValue("modifier_arc_warden_flux_1", "duration")})
end 

local spark = self:GetCaster():FindAbilityByName("arc_warden_spark_wraith_custom")
if spark and spark:GetLevel() > 0 and self:GetCaster():HasScepter() then 
	spark:CreateSpark(target:GetAbsOrigin())
end 


target:AddNewModifier(self:GetCaster(), self, "modifier_arc_warden_flux_custom", {duration = duration})

end



function arc_warden_flux_custom:OnVectorCastStart(vStartLocation, vDirection)

local target = self:GetCursorTarget()


if target:TriggerSpellAbsorb(self) then return end 

self:Cast(target)

local point = self:GetVector2Position()

local point_check = self:GetTargetPositionCheck()

local vel = point - point_check
vel.z = 0
vel = vel:Normalized()


if (target == self:GetCaster()) and 
	(math.abs(vel.x) - math.abs(self:GetCaster():GetForwardVector().x)) < 0.01 and  (math.abs(vel.y) - math.abs(self:GetCaster():GetForwardVector().y)) < 0.01 then 
	vel = vel*-1
end 	

local point = target:GetAbsOrigin() + vel*self:GetCaster():GetTalentValue("modifier_arc_warden_flux_6", "range")

target:AddNewModifier(self:GetCaster(), self, "modifier_arc_warden_flux_custom_dash", {x = point.x, y = point.y, z = point.z, duration = self:GetCaster():GetTalentValue("modifier_arc_warden_flux_6", "duration")})

end





function arc_warden_flux_custom:OnSpellStart(new_target)
local target = self:GetCursorTarget()

if new_target then 
	target = new_target
end 


if target:TriggerSpellAbsorb(self) then return end 
self:Cast(target)
end



modifier_arc_warden_flux_custom = class({})

function modifier_arc_warden_flux_custom:IsHidden() return true end 

function modifier_arc_warden_flux_custom:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_arc_warden_flux_custom:IgnoreTenacity()	return true end

function modifier_arc_warden_flux_custom:OnCreated(table)
if not self:GetAbility() then self:Destroy() return end

self.think_interval			= self:GetAbility():GetSpecialValueFor("think_interval")
self.search_radius			= self:GetAbility():GetSpecialValueFor("search_radius")
self.move_speed_slow_pct	= self:GetAbility():GetSpecialValueFor("move_speed_slow_pct")


self.part = "particles/units/heroes/hero_arc_warden/arc_warden_flux_tgt.vpcf"

if self:GetCaster():HasModifier("modifier_arc_warden_tempest_double") then
	self.damage_per_second = self:GetAbility():GetSpecialValueFor("tempest_damage_per_second")
	self.part = "particles/units/heroes/hero_arc_warden/arc_warden_flux_tempest_tgt.vpcf"
end

self.damage_per_interval	= self:GetAbility():GetFluxDamage() * self.think_interval

if IsServer() then 
	self:SetStackCount(self.move_speed_slow_pct * (1 - self:GetParent():GetStatusResistance()))
end 

self.slow = self:GetStackCount()* (-1)

if not IsServer() then return end

self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_arc_warden_flux_custom_count", {duration = self:GetRemainingTime()})

self.flux_particle = ParticleManager:CreateParticle(self.part, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControlEnt(self.flux_particle, 2, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetAbsOrigin(), true)
self:AddParticle(self.flux_particle, false, false, -1, false, false)

self.count = 0

local duration = self:GetAbility():GetSpecialValueFor("duration")

if self:GetCaster():HasModifier("modifier_arc_warden_flux_5") then 
	duration = duration + self:GetCaster():GetTalentValue("modifier_arc_warden_flux_5", "duration")
end 

self.max = duration/self.think_interval + 1

self:StartIntervalThink(FrameTime())
end

function modifier_arc_warden_flux_custom:DestroyOnExpire() return false end



function modifier_arc_warden_flux_custom:OnIntervalThink()
if not IsServer() then return end 

self:SetStackCount(0)


local units = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.search_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)

local no_near = true 

for _,unit in pairs(units) do 
	if unit ~= self:GetParent() then 
		no_near = false
	end 
end 


if no_near == true or self:GetParent():IsCreep() then

	ParticleManager:SetParticleControl(self.flux_particle, 4, Vector(1, 0, 0))
	
	ApplyDamage({
		victim 			= self:GetParent(),
		damage 			= self.damage_per_interval,
		damage_type		= DAMAGE_TYPE_MAGICAL,
		damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
		attacker 		= self:GetCaster(),
		ability 		= self:GetAbility()
	})
else
	ParticleManager:SetParticleControl(self.flux_particle, 4, Vector(0, 0, 0))
	
end

self.count = self.count + 1 

if self.count >= self.max then
	self:Destroy()
	return 
end


self:StartIntervalThink(self.think_interval)
end





function modifier_arc_warden_flux_custom:DeclareFunctions()
return 
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end

function modifier_arc_warden_flux_custom:GetModifierMoveSpeedBonus_Percentage()
	return self.slow
end


function modifier_arc_warden_flux_custom:OnDestroy()
if not IsServer() then return end 

local mod = self:GetParent():FindModifierByName("modifier_arc_warden_flux_custom_count")

if mod then 
	mod:DecrementStackCount() 
	if mod:GetStackCount() < 1 then 
 		mod:Destroy()
	end

end 


if self:GetCaster():HasModifier("modifier_arc_warden_flux_5") and self:GetRemainingTime() > 0.1 then 
	self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_arc_warden_flux_custom_silence", {duration = (1 - self:GetParent():GetStatusResistance())*self:GetCaster():GetTalentValue("modifier_arc_warden_flux_5", "silence")})
end

end 




modifier_arc_warden_flux_custom_legendary = class({})

function modifier_arc_warden_flux_custom_legendary:IsHidden() return false end
function modifier_arc_warden_flux_custom_legendary:IsPurgable() return false end
function modifier_arc_warden_flux_custom_legendary:OnCreated(table)

self.heal = self:GetParent():GetMaxHealth()*self:GetCaster():GetTalentValue("modifier_arc_warden_flux_7", "heal")/100

self.real_heal = self:GetCaster():GetTalentValue("modifier_arc_warden_flux_7", "heal")

if not IsServer() then return end

self.parent = self:GetParent()

self.part = "particles/units/heroes/hero_arc_warden/arc_warden_flux_tgt.vpcf"
self.part_2 = "particles/arc_warden/flux_self.vpcf"
self.cd_mod = "modifier_arc_warden_flux_custom_legendary_cd"
self.tempest = table.tempest


if self:GetCaster():HasModifier("modifier_arc_warden_tempest_double") then
	self.part = "particles/units/heroes/hero_arc_warden/arc_warden_flux_tempest_tgt.vpcf"
	self.part_2 = "particles/arc_warden/flux_self_tempest.vpcf"
	self.cd_mod = "modifier_arc_warden_flux_custom_legendary_tempest_cd"
end



self.radius = self:GetCaster():GetTalentValue("modifier_arc_warden_flux_7", "radius")

self.flux_particle = ParticleManager:CreateParticle(self.part, PATTACH_ABSORIGIN_FOLLOW, self.parent)
ParticleManager:SetParticleControlEnt(self.flux_particle, 2, self.parent, PATTACH_ABSORIGIN_FOLLOW, nil, self.parent:GetAbsOrigin(), true)
ParticleManager:SetParticleControl(self.flux_particle, 4, Vector(1, 0, 0))
self:AddParticle(self.flux_particle, false, false, -1, false, false)





local effect_cast = ParticleManager:CreateParticle( self.part_2, PATTACH_ABSORIGIN_FOLLOW, self.parent )
ParticleManager:SetParticleControl( effect_cast, 0, self.parent:GetOrigin() )
ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, 1, 1 ) )
self:AddParticle( effect_cast, false, false, -1, false, false )


self.count = 1
self.interval = FrameTime()

self:OnIntervalThink()

self:StartIntervalThink(self.interval)
end 




function modifier_arc_warden_flux_custom_legendary:OnIntervalThink()
if not IsServer() then return end 

self.count = self.count + self.interval 
if self.count >= 1 then 
	self.count = 0 
	SendOverheadEventMessage(self:GetParent(), 10, self:GetParent(), self.heal, nil)
end 


local units = FindUnitsInRadius(self.parent:GetTeamNumber(), self.parent:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)

for _,unit in pairs(units) do 
	if not unit:HasModifier(self.cd_mod) then 
		unit:AddNewModifier(self.parent, self:GetAbility(), self.cd_mod, {duration = self:GetCaster():GetTalentValue("modifier_arc_warden_flux_7", "interval") - 0.1})


		local duration = self:GetAbility():GetSpecialValueFor("duration")

		self.parent:EmitSound("Hero_ArcWarden.Flux.Cast")
		unit:EmitSound("Hero_ArcWarden.Flux.Target")

		local cast_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_arc_warden/arc_warden_flux_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
		ParticleManager:SetParticleControlEnt(cast_particle, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(cast_particle, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(cast_particle, 2, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(cast_particle)

		unit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_arc_warden_flux_custom", { duration = duration})



	end 
end 



end


function modifier_arc_warden_flux_custom_legendary:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE
}

end

function modifier_arc_warden_flux_custom_legendary:GetModifierHealthRegenPercentage()
return self.real_heal
end 

modifier_arc_warden_flux_custom_legendary_cd = class({})
function modifier_arc_warden_flux_custom_legendary_cd:IsHidden() return true end
function modifier_arc_warden_flux_custom_legendary_cd:IsPurgable() return false end


modifier_arc_warden_flux_custom_legendary_tempest_cd = class({})
function modifier_arc_warden_flux_custom_legendary_tempest_cd:IsHidden() return true end
function modifier_arc_warden_flux_custom_legendary_tempest_cd:IsPurgable() return false end










modifier_arc_warden_flux_custom_dash = class({})

function modifier_arc_warden_flux_custom_dash:IsDebuff() return false end
function modifier_arc_warden_flux_custom_dash:IsHidden() return true end
function modifier_arc_warden_flux_custom_dash:IsPurgable() return true end

function modifier_arc_warden_flux_custom_dash:OnCreated(kv)
    if not IsServer() then return end
    self.pfx = ParticleManager:CreateParticle("particles/items_fx/force_staff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
    self:GetParent():StartGesture(ACT_DOTA_FLAIL)

    self.point = Vector(kv.x, kv.y, kv.z)


    self.angle = (self.point - self:GetParent():GetAbsOrigin()):Normalized() 

    self.distance = self:GetCaster():GetTalentValue("modifier_arc_warden_flux_6", "range") / ( self:GetDuration() / FrameTime())

    self.targets = {}

    if self:ApplyHorizontalMotionController() == false then
        self:Destroy()
    end
end

function modifier_arc_warden_flux_custom_dash:DeclareFunctions()
return
{
 MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
    MODIFIER_PROPERTY_DISABLE_TURNING
}
end

function modifier_arc_warden_flux_custom_dash:GetActivityTranslationModifiers()
    return "forcestaff_friendly"
end


function modifier_arc_warden_flux_custom_dash:GetModifierDisableTurning() return 1 end

function modifier_arc_warden_flux_custom_dash:GetEffectName() return "particles/items_fx/harpoon_pull.vpcf" end
function modifier_arc_warden_flux_custom_dash:StatusEffectPriority() return 100 end

function modifier_arc_warden_flux_custom_dash:OnDestroy()
    if not IsServer() then return end
    self:GetParent():InterruptMotionControllers( true )
    ParticleManager:DestroyParticle(self.pfx, false)
    ParticleManager:ReleaseParticleIndex(self.pfx)

    self:GetParent():FadeGesture(ACT_DOTA_FLAIL)
    self:GetParent():StartGesture(ACT_DOTA_FORCESTAFF_END)

--   local dir = self.angle 
 --   dir.z = 0
   -- self:GetParent():SetForwardVector(dir)
   -- self:GetParent():FaceTowards(self:GetParent():GetAbsOrigin() + dir*10)

    ResolveNPCPositions(self:GetParent():GetAbsOrigin(), 128)

end


function modifier_arc_warden_flux_custom_dash:UpdateHorizontalMotion( me, dt )
    if not IsServer() then return end
    local pos = self:GetParent():GetAbsOrigin()
    GridNav:DestroyTreesAroundPoint(pos, 80, false)
    local pos_p = self.angle * self.distance
    local next_pos = GetGroundPosition(pos + pos_p,self:GetParent())
    self:GetParent():SetAbsOrigin(next_pos)


end

function modifier_arc_warden_flux_custom_dash:OnHorizontalMotionInterrupted()
    self:Destroy()
end






modifier_arc_warden_flux_custom_count = class({})
function modifier_arc_warden_flux_custom_count:IsHidden() return false end
function modifier_arc_warden_flux_custom_count:IsPurgable() return false end
function modifier_arc_warden_flux_custom_count:DestroyOnExpire() return false end
function modifier_arc_warden_flux_custom_count:OnCreated()

self.reduce = self:GetCaster():GetTalentValue("modifier_arc_warden_flux_3", "heal_reduce")

if not IsServer() then return end 

self:SetStackCount(1)
self.think_interval = 0.2

self.count = 0


self:StartIntervalThink(self.think_interval)
end 

function modifier_arc_warden_flux_custom_count:OnRefresh(table)
if not IsServer() then return end 

self:IncrementStackCount()
end 

function modifier_arc_warden_flux_custom_count:DeclareFunctions()
return
{
 	MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
   	MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
  	MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE
}
end



function modifier_arc_warden_flux_custom_count:GetModifierLifestealRegenAmplify_Percentage() 
return self.reduce
end

function modifier_arc_warden_flux_custom_count:GetModifierHealAmplify_PercentageTarget() 
return self.reduce
end

function modifier_arc_warden_flux_custom_count:GetModifierHPRegenAmplify_Percentage() 
return self.reduce
end

function modifier_arc_warden_flux_custom_count:OnIntervalThink()
if not IsServer() then return end 


local hero = self:GetCaster()

if hero:IsTempestDouble() and hero.owner then 
	hero = hero.owner
end

if hero:GetQuest() == "Arc.Quest_5" and self:GetParent():IsRealHero() and not hero:QuestCompleted() then 
	hero:UpdateQuest(self.think_interval)
end

self.count = self.count + self.think_interval 

if self.count >= 1 then 
	self.count = 0
else 
	return
end


if self:GetCaster():HasModifier("modifier_arc_warden_flux_2") then 
	self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_arc_warden_flux_custom_incoming",{duration = self:GetCaster():GetTalentValue("modifier_arc_warden_flux_2", "duration")})
end 

end









modifier_arc_warden_flux_custom_resist = class({})
function modifier_arc_warden_flux_custom_resist:IsHidden() return false end
function modifier_arc_warden_flux_custom_resist:IsPurgable() return false end
function modifier_arc_warden_flux_custom_resist:GetTexture() return "buffs/flux_resist" end
function modifier_arc_warden_flux_custom_resist:OnCreated()
self.resist = self:GetCaster():GetTalentValue("modifier_arc_warden_flux_4", "resist")

if not IsServer() then return end 

self:SetStackCount(1)
end 

function modifier_arc_warden_flux_custom_resist:OnRefresh()
if not IsServer() then return end 
if self:GetStackCount() >= self:GetCaster():GetTalentValue("modifier_arc_warden_flux_4", "max") then return end 

self:IncrementStackCount()
end 


function modifier_arc_warden_flux_custom_resist:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
}
end 


function modifier_arc_warden_flux_custom_resist:GetModifierMagicalResistanceBonus()
return self.resist*self:GetStackCount()
end 




modifier_arc_warden_flux_custom_tracker = class({})
function modifier_arc_warden_flux_custom_tracker:IsHidden() return true end
function modifier_arc_warden_flux_custom_tracker:IsPurgable() return false end
function modifier_arc_warden_flux_custom_tracker:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_ATTACK_LANDED,
	MODIFIER_EVENT_ON_TAKEDAMAGE
}
end 

function modifier_arc_warden_flux_custom_tracker:OnAttackLanded(params)
if not IsServer() then return end 
if self:GetParent():IsIllusion() then return end
if self:GetParent() ~= params.attacker then return end 
if not params.target:IsHero() and not params.target:IsCreep() then return end

if self:GetParent():HasModifier("modifier_arc_warden_flux_4") then 
	local cd = self:GetAbility():GetCooldownTimeRemaining() 

	if cd > self:GetCaster():GetTalentValue("modifier_arc_warden_flux_4", "cd") then 
		self:GetAbility():EndCooldown()
		self:GetAbility():StartCooldown(cd - self:GetCaster():GetTalentValue("modifier_arc_warden_flux_4", "cd"))
	end

	params.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_arc_warden_flux_custom_resist", {duration = self:GetCaster():GetTalentValue("modifier_arc_warden_flux_4", "duration")})

end 

end 


function modifier_arc_warden_flux_custom_tracker:OnTakeDamage(params)
if not IsServer() then return end 
if not self:GetParent():HasModifier("modifier_arc_warden_flux_3") then return end 
if not params.unit:HasModifier("modifier_arc_warden_flux_custom_count") then return end 
if self:GetParent() ~= params.attacker then return end 

local heal = self:GetCaster():GetTalentValue("modifier_arc_warden_flux_3", "heal")*params.damage/100

if params.unit:IsCreep() then 
	heal = heal*self:GetCaster():GetTalentValue("modifier_arc_warden_flux_3", "heal_creeps")
end 

self:GetCaster():GenericHeal(heal, self:GetAbility(), true)

end 




modifier_arc_warden_flux_custom_speed = class({})
function modifier_arc_warden_flux_custom_speed:IsHidden() return false end
function modifier_arc_warden_flux_custom_speed:IsPurgable() return true end
function modifier_arc_warden_flux_custom_speed:GetTexture() return "buffs/flux_speed" end
function modifier_arc_warden_flux_custom_speed:GetEffectName() return "particles/zuus_speed.vpcf" end
function modifier_arc_warden_flux_custom_speed:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}

end

function modifier_arc_warden_flux_custom_speed:GetModifierMoveSpeedBonus_Percentage()
 return self.speed
end


function modifier_arc_warden_flux_custom_speed:OnCreated()

self.speed = self:GetCaster():GetTalentValue("modifier_arc_warden_flux_1", "speed")
end 






modifier_arc_warden_flux_custom_silence = class({})

function modifier_arc_warden_flux_custom_silence:IsHidden() return true end
function modifier_arc_warden_flux_custom_silence:IsPurgable() return true end
function modifier_arc_warden_flux_custom_silence:GetTexture() return "silencer_last_word" end
function modifier_arc_warden_flux_custom_silence:OnCreated(table)

self.slow = self:GetCaster():GetTalentValue("modifier_arc_warden_flux_5", "speed_move")
self.attack = self:GetCaster():GetTalentValue("modifier_arc_warden_flux_5", "speed_attack")

if not IsServer() then return end
self.flux_particle = ParticleManager:CreateParticle("particles/void_astral_slow.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
self:AddParticle(self.flux_particle, false, false, -1, false, false)


local part = ParticleManager:CreateParticle("particles/econ/items/outworld_devourer/od_shards_exile/od_shards_exile_prison_end.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:ReleaseParticleIndex(part)
self:GetParent():EmitSound("Juggernaut.Fury_silence")
end

function modifier_arc_warden_flux_custom_silence:CheckState()
return
{
	[MODIFIER_STATE_SILENCED] = true,
}
end


function modifier_arc_warden_flux_custom_silence:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
end 


function modifier_arc_warden_flux_custom_silence:GetModifierMoveSpeedBonus_Percentage()
return self.slow
end 


function modifier_arc_warden_flux_custom_silence:GetModifierAttackSpeedBonus_Constant()
return self.attack
end 


function modifier_arc_warden_flux_custom_silence:GetEffectName() return "particles/generic_gameplay/generic_silenced.vpcf" end

function modifier_arc_warden_flux_custom_silence:ShouldUseOverheadOffset() return true end
function modifier_arc_warden_flux_custom_silence:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end









modifier_arc_warden_flux_custom_incoming = class({})

function modifier_arc_warden_flux_custom_incoming:IsHidden() return false end
function modifier_arc_warden_flux_custom_incoming:GetTexture() return "buffs/remnant_lowhp" end
function modifier_arc_warden_flux_custom_incoming:IsPurgable() return false end

function modifier_arc_warden_flux_custom_incoming:OnCreated(table)

self.damage = self:GetCaster():GetTalentValue("modifier_arc_warden_flux_2", "damage")

if not IsServer() then return end
self:SetStackCount(1)


end


function modifier_arc_warden_flux_custom_incoming:OnRefresh()
if not IsServer() then return end 
if self:GetStackCount() >= self:GetCaster():GetTalentValue("modifier_arc_warden_flux_2", "max") then return end 

self:IncrementStackCount()

if self:GetStackCount() >= self:GetCaster():GetTalentValue("modifier_arc_warden_flux_2", "max") then 

	self.particle_peffect = ParticleManager:CreateParticle("particles/ta_trap_damage.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())   
	ParticleManager:SetParticleControl(self.particle_peffect, 0, self:GetParent():GetAbsOrigin())
	self:AddParticle(self.particle_peffect, false, false, -1, false, true)
end 

end 


function modifier_arc_warden_flux_custom_incoming:DeclareFunctions()
return 
{ 
  MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
}
end


function modifier_arc_warden_flux_custom_incoming:GetModifierIncomingDamage_Percentage()
return self.damage*self:GetStackCount()
end 
  
