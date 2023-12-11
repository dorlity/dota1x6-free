LinkLuaModifier("modifier_custom_puck_dream_coil", "abilities/puck/custom_puck_dream_coil", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_puck_dream_coil_thinker", "abilities/puck/custom_puck_dream_coil", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_puck_dream_coil_resist", "abilities/puck/custom_puck_dream_coil", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_puck_dream_coil_knockback", "abilities/puck/custom_puck_dream_coil", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_custom_puck_dream_coil_knockback_legendary", "abilities/puck/custom_puck_dream_coil", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_custom_puck_dream_coil_cd", "abilities/puck/custom_puck_dream_coil", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_puck_dream_coil_tether", "abilities/puck/custom_puck_dream_coil", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_puck_dream_coil_mini_thinker", "abilities/puck/custom_puck_dream_coil", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_puck_dream_coil_mini_debuff", "abilities/puck/custom_puck_dream_coil", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_puck_dream_coil_mini_tracker", "abilities/puck/custom_puck_dream_coil", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_puck_dream_coil_mini_cd", "abilities/puck/custom_puck_dream_coil", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_puck_dream_coil_kills", "abilities/puck/custom_puck_dream_coil", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_puck_dream_coil_kill_timer", "abilities/puck/custom_puck_dream_coil", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_puck_dream_coil_thinker_scepter", "abilities/puck/custom_puck_dream_coil", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_puck_dream_coil_stun", "abilities/puck/custom_puck_dream_coil", LUA_MODIFIER_MOTION_NONE)

custom_puck_dream_coil = class({})

custom_puck_dream_coil.cd_inc = {-6, -9, -12}
custom_puck_dream_coil.duration_inc = {1, 1.5, 2}

custom_puck_dream_coil.resist_incoming = {8, 12, 16}

custom_puck_dream_coil.legendary_radius = 150
custom_puck_dream_coil.legendary_knockback_distance = 100
custom_puck_dream_coil.legendary_knockback_duration = 0.25
custom_puck_dream_coil.legendary_k = 0.5
custom_puck_dream_coil.legendary_damage = 1


custom_puck_dream_coil.reduction_damage = {-8, -12, -16}
custom_puck_dream_coil.reduction_heal = {-10, -15, -20}
custom_puck_dream_coil.reduction_duration = 4


custom_puck_dream_coil.kill_max = 10
custom_puck_dream_coil.kill_damage = 2
custom_puck_dream_coil.kill_speed = 10
custom_puck_dream_coil.kill_timer = 4



function custom_puck_dream_coil:Precache(context)

PrecacheResource( "particle", "particles/units/heroes/hero_puck/puck_dreamcoil_tether.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_puck/puck_dreamcoil.vpcf", context )
PrecacheResource( "particle", "particles/puck_magic.vpcf", context )
PrecacheResource( "particle", "particles/huskar_timer.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_puck/puck_dreamcoil_mini.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_puck/puck_dreamcoil_mini_center.vpcf", context )

end

function custom_puck_dream_coil:GetAbilityTargetFlags()
if self:GetCaster():HasModifier("modifier_puck_coil_attacks") then 
	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
else 
	return DOTA_UNIT_TARGET_FLAG_NONE
end

end


function custom_puck_dream_coil:GetIntrinsicModifierName()

return "modifier_custom_puck_dream_coil_mini_tracker"
end 


function custom_puck_dream_coil:GetCooldown(iLevel)

local upgrade_cooldown = 0
if self:GetCaster():HasModifier("modifier_puck_coil_cd") then 
 upgrade_cooldown = self.cd_inc[self:GetCaster():GetUpgradeStack("modifier_puck_coil_cd")]
end

local k = 1 
if self:GetCaster():HasModifier("modifier_puck_coil_legendary") then 
	k = self:GetCaster():GetTalentValue("modifier_puck_coil_legendary", "cd")/100
end 


 return (self.BaseClass.GetCooldown(self, iLevel) + upgrade_cooldown)*k
 
end



function custom_puck_dream_coil:GetBreakDamage()

local damage = self:GetSpecialValueFor("coil_break_damage")

if self:GetCaster():HasModifier("modifier_puck_coil_legendary") then 
	damage = damage + self:GetCaster():GetIntellect()*self.legendary_damage
end 

return damage
end 


function custom_puck_dream_coil:LegendaryProc(point)
if not IsServer() then return end 
if not self:GetCaster():HasModifier("modifier_puck_coil_legendary") then return end
if self:GetCaster():HasModifier("modifier_custom_puck_dream_coil_cd")	then return end

self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_custom_puck_dream_coil_cd", {duration = self:GetCaster():GetTalentValue("modifier_puck_coil_legendary", "effect_cd")})

local radius = self:GetCaster():GetTalentValue("modifier_puck_coil_legendary", "radius")

local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), point, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
local damage = self:GetCaster():GetTalentValue("modifier_puck_coil_legendary", "damage")*self:GetCaster():GetIntellect()/100

EmitSoundOnLocationWithCaster(point,"Puck.Coil_Wave" , self:GetCaster())

local particle = ParticleManager:CreateParticle("particles/puck_magic.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(particle, 0, point)
ParticleManager:SetParticleControl(particle, 1, point)
ParticleManager:SetParticleControl(particle, 2, Vector(radius, 0, 0))
ParticleManager:ReleaseParticleIndex(particle)

for _, enemy in pairs(enemies) do

  local damageTable = {
    victim      = enemy,
    damage      = damage,
    damage_type   = DAMAGE_TYPE_MAGICAL,
    damage_flags  = DOTA_DAMAGE_FLAG_NONE,
    attacker    = self:GetCaster(),
    ability     = self
  }

  ApplyDamage(damageTable)

  SendOverheadEventMessage(enemy, 4, enemy, damage, nil)
	enemy:AddNewModifier(self:GetCaster(), self, "modifier_custom_puck_dream_coil_knockback", {duration = self:GetCaster():GetTalentValue("modifier_puck_coil_legendary", "knock_duration") * (1 - enemy:GetStatusResistance()), x = point.x, y = point.y})

end 


end 



function custom_puck_dream_coil:GetCoilDuration()

local latch_duration	= self:GetSpecialValueFor("coil_duration")

if self:GetCaster():HasModifier("modifier_puck_coil_cd") then 
	latch_duration = latch_duration + self.duration_inc[self:GetCaster():GetUpgradeStack("modifier_puck_coil_cd")]
end

if self:GetCaster():HasModifier("modifier_puck_coil_legendary") then 
	latch_duration = latch_duration*self:GetCaster():GetTalentValue("modifier_puck_coil_legendary", "cd")/100
end 

return latch_duration
end 


function custom_puck_dream_coil:GetAOERadius()
	return self:GetSpecialValueFor("coil_radius")
end

function custom_puck_dream_coil:OnSpellStart()

if self:GetCaster():GetName() == "npc_dota_hero_puck" then
	self:GetCaster():EmitSound("puck_puck_ability_dreamcoil_0"..RandomInt(1, 2))
end

local damage = self:GetSpecialValueFor("coil_initial_damage")
local latch_duration	= self:GetCoilDuration() 

local coil_stun_duration			= self:GetSpecialValueFor("coil_stun_duration")

local coil_thinker = CreateModifierThinker(self:GetCaster(), self, "modifier_custom_puck_dream_coil_thinker", {duration = latch_duration}, self:GetCursorPosition(), self:GetCaster():GetTeamNumber(), false )


if self:GetCaster():HasScepter() then 
	CreateModifierThinker(self:GetCaster(), self, "modifier_custom_puck_dream_coil_thinker_scepter", {duration = latch_duration + coil_stun_duration + 1}, self:GetCursorPosition(), self:GetCaster():GetTeamNumber(), false )
end 

local no_heroes = true

local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCursorPosition(), nil, self:GetSpecialValueFor("coil_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,  DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

for _, enemy in pairs(enemies) do

 	if enemy:IsHero() then 
 		no_heroes = false
 	end


	ApplyDamage({ victim = enemy, damage = damage, damage_type = self:GetAbilityDamageType(), attacker= self:GetCaster(), ability = self })

	if not enemy:HasModifier("modifier_custom_puck_dream_coil") then
		enemy:AddNewModifier(self:GetCaster(), self, "modifier_custom_puck_dream_coil",  {duration= latch_duration*(1 - enemy:GetStatusResistance()), coil_thinker	= coil_thinker:entindex() })
	end
end

self:LegendaryProc(self:GetCursorPosition())

end


function custom_puck_dream_coil:OnProjectileHit(hTarget, vLocation)
if not hTarget then return end
if not IsServer() then return end

hTarget:EmitSound("Puck.Coil_Attack_impact")
self:GetCaster():PerformAttack(hTarget, true, true, true, false, false, false, false)
end





modifier_custom_puck_dream_coil = class({})

function modifier_custom_puck_dream_coil:IsPurgable()		return false end
function modifier_custom_puck_dream_coil:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_custom_puck_dream_coil:OnDestroy()
if not IsServer() then return end

self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_puck_dream_coil_kill_timer", {duration = self:GetAbility().kill_timer})
end


function modifier_custom_puck_dream_coil:OnCreated(params)

self.coil_break_radius			= self:GetAbility():GetSpecialValueFor("coil_break_radius")
self.coil_stun_duration			= self:GetAbility():GetSpecialValueFor("coil_stun_duration")
self.coil_break_damage			= self:GetAbility():GetBreakDamage() 


self.RemoveForDuel = true



if not IsServer() then return end

if self:GetCaster():HasModifier("modifier_puck_coil_attacks") then 
	self.coil_break_radius = self.coil_break_radius - self:GetAbility().legendary_radius
end

self.leash = self:GetParent():AddNewModifier(self:GetCaster(), self:GetCaster():BkbAbility(self:GetAbility(), self:GetCaster():HasModifier("modifier_puck_coil_attacks")), "modifier_custom_puck_dream_coil_tether", {duration = self:GetRemainingTime()})
	


self.ability_damage_type		= self:GetAbility():GetAbilityDamageType()
self.coil_thinker				= EntIndexToHScript(params.coil_thinker)
self.coil_thinker_location		= self.coil_thinker:GetAbsOrigin()

local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_puck/puck_dreamcoil_tether.vpcf", PATTACH_ABSORIGIN, self:GetParent() )
ParticleManager:SetParticleControl( effect_cast, 0, self.coil_thinker_location )
ParticleManager:SetParticleControlEnt(effect_cast,1,self:GetParent(),PATTACH_POINT_FOLLOW,"attach_hitloc",self:GetParent():GetOrigin(),true)
self:AddParticle(effect_cast,false,false,-1,false,false)

self.interval 	= 0.05

self:OnIntervalThink()
self:StartIntervalThink(self.interval)
end


function modifier_custom_puck_dream_coil:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
}
end 



function modifier_custom_puck_dream_coil:GetModifierMagicalResistanceBonus()
if not self:GetCaster():HasScepter() then return end 

return self:GetAbility():GetSpecialValueFor("scepter_magic")
end 

function modifier_custom_puck_dream_coil:OnIntervalThink()
if not IsServer() then return end




if self:GetCaster():HasModifier("modifier_puck_coil_duration") or self:GetCaster():HasModifier("modifier_puck_coil_resist") then 
	self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_puck_dream_coil_resist", {duration = self:GetAbility().reduction_duration})
end 




if (self:GetParent():GetAbsOrigin() - self.coil_thinker_location):Length2D() >= self.coil_break_radius and not self:GetParent():HasModifier("modifier_custom_puck_dream_coil_cd") then

	local stun_duration	= self.coil_stun_duration
	local break_damage	= self.coil_break_damage


	local damageTable = {
		victim 			= self:GetParent(),
		damage 			= break_damage,
		damage_type		= self.ability_damage_type,
		damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
		attacker 		= self:GetCaster(),
		ability 		= self:GetAbility()
	}

	if self:GetCaster():GetQuest() == "Puck.Quest_8" and self:GetParent():IsRealHero() then 
		self:GetCaster():UpdateQuest(1)
	end

	ApplyDamage(damageTable)
	self:GetParent():EmitSound("Hero_Puck.Dream_Coil_Snap")
	self:GetParent():ApplyStun(self:GetAbility(), self:GetCaster():HasModifier("modifier_puck_coil_attacks"), self:GetCaster(), stun_duration)
	self:GetParent():AddNewModifier(self:GetAbility(), self:GetAbility(), "modifier_custom_puck_dream_coil_stun", {duration = (1 - self:GetParent():GetStatusResistance())*stun_duration})

	if self:GetParent():IsRealHero() then 
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_puck_dream_coil_kills", {})
	end 

	if self.leash and not self.leash:IsNull() then 
		self.leash:Destroy()
	end 	

	
	if self:GetCaster():HasModifier("modifier_puck_coil_attacks") and  (not self:GetParent():IsDebuffImmune() or self:GetCaster():HasModifier("modifier_puck_coil_attacks"))  then 
		self:GetParent():AddNewModifier(self:GetCaster(), self:GetCaster():BkbAbility(self, self:GetCaster():HasModifier("modifier_puck_coil_attacks")), "modifier_custom_puck_dream_coil_knockback_legendary", {duration = self:GetAbility().legendary_knockback_duration, x = self.coil_thinker_location.x, y = self.coil_thinker_location.y})
	end
	
	local mod = self:GetParent():FindModifierByName("modifier_custom_puck_dream_coil_resist")

	if mod then 
		mod.active = true
	end 

	self:Destroy()
end

end



---------------------------------
-- DREAM COIL THINKER MODIFIER --
---------------------------------

modifier_custom_puck_dream_coil_thinker = class({})

function modifier_custom_puck_dream_coil_thinker:OnCreated()
if not IsServer() then return end

self:GetParent():EmitSound("Puck.Coil")

self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_puck/puck_dreamcoil.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(self.pfx, 0, self:GetParent():GetAbsOrigin())
self:AddParticle(self.pfx, false, false, -1, false, true)

		
end



function modifier_custom_puck_dream_coil_thinker:OnDestroy()
if not IsServer() then return end

self:GetParent():StopSound("Puck.Coil")
self:GetParent():RemoveSelf()
end




modifier_custom_puck_dream_coil_resist = class({})
function modifier_custom_puck_dream_coil_resist:IsHidden() return false end
function modifier_custom_puck_dream_coil_resist:IsPurgable() return false end
function modifier_custom_puck_dream_coil_resist:GetTexture() return "buffs/coil_resist" end

function modifier_custom_puck_dream_coil_resist:OnCreated(table)
if not IsServer() then return end
self.RemoveForDuel = true
self.active = false

if self:GetCaster():HasModifier("modifier_puck_coil_resist") then 

	self.particle_peffect = ParticleManager:CreateParticle("particles/ta_trap_damage.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())   
	ParticleManager:SetParticleControl(self.particle_peffect, 0, self:GetParent():GetAbsOrigin())
	self:AddParticle(self.particle_peffect, false, false, -1, false, true)
	--self:GetParent():EmitSound("DOTA_Item.MedallionOfCourage.Activate")
end

self:StartIntervalThink(FrameTime())
end


function modifier_custom_puck_dream_coil_resist:OnIntervalThink() 
if not IsServer() then return end 
if not self:GetParent():HasModifier("modifier_custom_puck_dream_coil") and self.active == false then 
	self:Destroy()
end 


end 



function modifier_custom_puck_dream_coil_resist:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
  MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
  MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
  MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE,
  MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
}
end

function modifier_custom_puck_dream_coil_resist:GetModifierIncomingDamage_Percentage()
if not self:GetCaster():HasModifier("modifier_puck_coil_resist") then return end
return self:GetAbility().resist_incoming[self:GetCaster():GetUpgradeStack("modifier_puck_coil_resist")]
end



function modifier_custom_puck_dream_coil_resist:GetModifierLifestealRegenAmplify_Percentage() 
if not self:GetCaster():HasModifier("modifier_puck_coil_duration") then return end
return self:GetAbility().reduction_heal[self:GetCaster():GetUpgradeStack("modifier_puck_coil_duration")]
end

function modifier_custom_puck_dream_coil_resist:GetModifierHealAmplify_PercentageTarget()
if not self:GetCaster():HasModifier("modifier_puck_coil_duration") then return end
return self:GetAbility().reduction_heal[self:GetCaster():GetUpgradeStack("modifier_puck_coil_duration")]
end

function modifier_custom_puck_dream_coil_resist:GetModifierHPRegenAmplify_Percentage() 
if not self:GetCaster():HasModifier("modifier_puck_coil_duration") then return end
return self:GetAbility().reduction_heal[self:GetCaster():GetUpgradeStack("modifier_puck_coil_duration")]
end

function modifier_custom_puck_dream_coil_resist:GetModifierTotalDamageOutgoing_Percentage()
if not self:GetCaster():HasModifier("modifier_puck_coil_duration") then return end
return self:GetAbility().reduction_damage[self:GetCaster():GetUpgradeStack("modifier_puck_coil_duration")]
end










modifier_custom_puck_dream_coil_knockback = class({})

function modifier_custom_puck_dream_coil_knockback:IsHidden() return true end

function modifier_custom_puck_dream_coil_knockback:OnCreated(params)
  if not IsServer() then return end
  
  self.ability        = self:GetCaster():FindAbilityByName("custom_puck_dream_coil")
  if not self.ability then 
  	self:Destroy()
  	return
  end

  self.caster         = self:GetCaster()
  self.parent         = self:GetParent()
  self:GetParent():StartGesture(ACT_DOTA_FLAIL)
  
  self.knockback_duration   = self:GetCaster():GetTalentValue("modifier_puck_coil_legendary", "knock_duration")

  --self.knockback_distance   = math.max(self.ability.knockback_distance - (self.caster:GetAbsOrigin() - self.parent:GetAbsOrigin()):Length2D(), 50)
  
  self.knockback_distance = self:GetCaster():GetTalentValue("modifier_puck_coil_legendary", "knock_distance")

  self.knockback_speed    = self.knockback_distance / self.knockback_duration
  
  self.position = GetGroundPosition(Vector(params.x, params.y, 0), nil)
  
  if self:ApplyHorizontalMotionController() == false then 
    self:Destroy()
    return
  end
end

function modifier_custom_puck_dream_coil_knockback:UpdateHorizontalMotion( me, dt )
  if not IsServer() then return end

  local distance = (me:GetOrigin() - self.position):Normalized()
  
  me:SetOrigin( me:GetOrigin() + distance * self.knockback_speed * dt )

  GridNav:DestroyTreesAroundPoint( self.parent:GetOrigin(), self.parent:GetHullRadius(), true )
end

function modifier_custom_puck_dream_coil_knockback:DeclareFunctions()
  local decFuncs = {
    MODIFIER_PROPERTY_OVERRIDE_ANIMATION
    }

    return decFuncs
end

function modifier_custom_puck_dream_coil_knockback:GetOverrideAnimation()
   return ACT_DOTA_FLAIL
end


function modifier_custom_puck_dream_coil_knockback:OnDestroy()
  if not IsServer() then return end
 self.parent:RemoveHorizontalMotionController( self )
  self:GetParent():FadeGesture(ACT_DOTA_FLAIL)
end





modifier_custom_puck_dream_coil_knockback_legendary = class({})

function modifier_custom_puck_dream_coil_knockback_legendary:IsHidden() return true end

function modifier_custom_puck_dream_coil_knockback_legendary:OnCreated(params)
  if not IsServer() then return end
  
    
  self.ability        = self:GetCaster():FindAbilityByName("custom_puck_dream_coil")
  if not self.ability then 
  	self:Destroy()
  	return
  end

  self.caster         = self:GetCaster()
  self.parent         = self:GetParent()
  self:GetParent():StartGesture(ACT_DOTA_FLAIL)
  
  self.knockback_duration   = self.ability.legendary_knockback_duration

 
  self.position = GetGroundPosition(Vector(params.x, params.y, 0), nil) 

  local dist = self.ability.legendary_knockback_distance

 	if  (self:GetParent():GetAbsOrigin() -self.position):Length2D() < dist then 
 		self:Destroy()
 		return
 	end 

  self.knockback_distance = (self:GetParent():GetAbsOrigin() -self.position):Length2D() - dist

  self.knockback_speed    = self.knockback_distance / self.knockback_duration
  
  
  if self:ApplyHorizontalMotionController() == false then 
    self:Destroy()
    return
  end

end

function modifier_custom_puck_dream_coil_knockback_legendary:UpdateHorizontalMotion( me, dt )
  if not IsServer() then return end

  local distance = (self.position - me:GetOrigin()):Normalized()
  
  me:SetOrigin( me:GetOrigin() + distance * self.knockback_speed * dt )

  GridNav:DestroyTreesAroundPoint( self.parent:GetOrigin(), self.parent:GetHullRadius(), true )
end

function modifier_custom_puck_dream_coil_knockback_legendary:DeclareFunctions()
  local decFuncs = {
    MODIFIER_PROPERTY_OVERRIDE_ANIMATION
    }

    return decFuncs
end

function modifier_custom_puck_dream_coil_knockback_legendary:GetOverrideAnimation()
   return ACT_DOTA_FLAIL
end


function modifier_custom_puck_dream_coil_knockback_legendary:OnDestroy()
  if not IsServer() then return end
 self.parent:RemoveHorizontalMotionController( self )
  self:GetParent():FadeGesture(ACT_DOTA_FLAIL)
end


modifier_custom_puck_dream_coil_cd = class({})
function modifier_custom_puck_dream_coil_cd:IsHidden() return false end
function modifier_custom_puck_dream_coil_cd:IsPurgable() return false end
function modifier_custom_puck_dream_coil_cd:RemoveOnDeath() return false end
function modifier_custom_puck_dream_coil_cd:IsDebuff() return true end



modifier_custom_puck_dream_coil_tether = class({})
function modifier_custom_puck_dream_coil_tether:IsHidden() return true end
function modifier_custom_puck_dream_coil_tether:IsPurgable() return false end
function modifier_custom_puck_dream_coil_tether:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_custom_puck_dream_coil_tether:CheckState()
return
{
	[MODIFIER_STATE_TETHERED] = true
}
end










modifier_custom_puck_dream_coil_mini_thinker = class({})

function modifier_custom_puck_dream_coil_mini_thinker:OnCreated()
if not IsServer() then return end

	self:GetParent():EmitSound("Puck.Coil_mini")

self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_puck/puck_dreamcoil_mini_center.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(self.pfx, 0, self:GetParent():GetAbsOrigin())
self:AddParticle(self.pfx, false, false, -1, false, true)

		
end



function modifier_custom_puck_dream_coil_mini_thinker:OnDestroy()
if not IsServer() then return end

	self:GetParent():StopSound("Puck.Coil_mini")
self:GetParent():RemoveSelf()
end






modifier_custom_puck_dream_coil_mini_debuff = class({})

function modifier_custom_puck_dream_coil_mini_debuff:IsHidden() return true end
function modifier_custom_puck_dream_coil_mini_debuff:IsPurgable()		return false end
function modifier_custom_puck_dream_coil_mini_debuff:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_custom_puck_dream_coil_mini_debuff:OnDestroy()
if not IsServer() then return end

end


function modifier_custom_puck_dream_coil_mini_debuff:OnCreated(params)

self.coil_break_radius			= self:GetCaster():GetTalentValue("modifier_puck_coil_cooldowns", "radius")
self.coil_stun_duration			= self:GetCaster():GetTalentValue("modifier_puck_coil_cooldowns", "stun")
self.coil_break_damage			= self:GetCaster():GetTalentValue("modifier_puck_coil_cooldowns", "damage")*self:GetCaster():GetIntellect()/100

self.RemoveForDuel = true

if not IsServer() then return end

self.leash =  self:GetParent():AddNewModifier(self:GetCaster(), self:GetCaster():BkbAbility(self:GetAbility(), self:GetCaster():HasModifier("modifier_puck_coil_attacks")), "modifier_custom_puck_dream_coil_tether", {duration = self:GetRemainingTime()})
	

self.coil_thinker				= EntIndexToHScript(params.coil_thinker)

self.coil_thinker_location		= self.coil_thinker:GetAbsOrigin()

local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_puck/puck_dreamcoil_mini.vpcf", PATTACH_ABSORIGIN, self:GetParent() )
ParticleManager:SetParticleControl( effect_cast, 0, self.coil_thinker_location )
ParticleManager:SetParticleControlEnt(effect_cast,1,self:GetParent(),PATTACH_POINT_FOLLOW,"attach_hitloc",self:GetParent():GetOrigin(),true)
self:AddParticle(effect_cast,false,false,-1,false,false)

self.interval 	= 0.05

self:OnIntervalThink()
self:StartIntervalThink(self.interval)
end



function modifier_custom_puck_dream_coil_mini_debuff:OnIntervalThink()
if not IsServer() then return end

if (self:GetParent():GetAbsOrigin() - self.coil_thinker_location):Length2D() >= self.coil_break_radius then

	local stun_duration	= self.coil_stun_duration
	local break_damage	= self.coil_break_damage

	local damageTable = {
		victim 			= self:GetParent(),
		damage 			= break_damage,
		damage_type		= DAMAGE_TYPE_MAGICAL,
		damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
		attacker 		= self:GetCaster(),
		ability 		= self:GetAbility()
	}

	if self.leash and not self.leash:IsNull() then 
		self.leash:Destroy()
	end 	


	ApplyDamage(damageTable)
	self:GetParent():EmitSound("Puck.Coil_mini_break")
	self:GetParent():ApplyStun(self:GetAbility(), self:GetCaster():HasModifier("modifier_puck_coil_attacks"), self:GetCaster(), stun_duration)

	
	if self:GetCaster():HasModifier("modifier_puck_coil_attacks") and  (not self:GetParent():IsDebuffImmune() or self:GetCaster():HasModifier("modifier_puck_coil_attacks"))  then 
		self:GetParent():AddNewModifier(self:GetCaster(), self:GetCaster():BkbAbility(self, self:GetCaster():HasModifier("modifier_puck_coil_attacks")), "modifier_custom_puck_dream_coil_knockback_legendary", {duration = self:GetAbility().legendary_knockback_duration, x = self.coil_thinker_location.x, y = self.coil_thinker_location.y})
	end


	local effect = ParticleManager:CreateParticle("particles/puck_silence_damage.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:ReleaseParticleIndex(effect)
	self:Destroy()
end

end



modifier_custom_puck_dream_coil_mini_tracker = class({})
function modifier_custom_puck_dream_coil_mini_tracker:IsHidden() return true end
function modifier_custom_puck_dream_coil_mini_tracker:IsPurgable() return false end
function modifier_custom_puck_dream_coil_mini_tracker:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_ATTACK_LANDED,
	MODIFIER_EVENT_ON_DEATH
}
end 

function modifier_custom_puck_dream_coil_mini_tracker:OnAttackLanded(params)
if not IsServer() then return end 
if self:GetParent() ~= params.attacker then return end 
if not params.target:IsHero() and not params.target:IsCreep() then return end 

if self:GetParent():HasModifier("modifier_puck_coil_legendary") and not self:GetCaster():HasModifier("modifier_custom_puck_dream_coil_cd") then 

	if RollPseudoRandomPercentage(self:GetCaster():GetTalentValue("modifier_puck_coil_legendary", "chance"),788,self:GetCaster()) then 
		self:GetAbility():LegendaryProc(self:GetParent():GetAbsOrigin())
	end 

end 



if not self:GetCaster():HasModifier("modifier_puck_coil_cooldowns") then return end 
if params.target:HasModifier("modifier_custom_puck_dream_coil_mini_debuff") then return end
if params.target:HasModifier("modifier_custom_puck_dream_coil") then return end
if params.target:HasModifier("modifier_custom_puck_dream_coil_stun") then return end
if params.target:HasModifier("modifier_custom_puck_dream_coil_mini_cd") then return end 

local enemy = params.target

enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_puck_dream_coil_mini_cd", {duration = self:GetCaster():GetTalentValue("modifier_puck_coil_cooldowns", "cd")})

local latch_duration = self:GetCaster():GetTalentValue("modifier_puck_coil_cooldowns", "duration")
local dir = (self:GetCaster():GetAbsOrigin() - enemy:GetAbsOrigin())
dir.z = 0

local point = enemy:GetAbsOrigin() + dir:Normalized()*100


local coil_thinker = CreateModifierThinker(self:GetCaster(), self:GetAbility(), "modifier_custom_puck_dream_coil_mini_thinker", {duration = latch_duration}, point, self:GetCaster():GetTeamNumber(), false )


enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_puck_dream_coil_mini_debuff",  {duration= latch_duration*(1 - enemy:GetStatusResistance()), coil_thinker	= coil_thinker:entindex() })

end 





modifier_custom_puck_dream_coil_kills = class({})
function modifier_custom_puck_dream_coil_kills:IsHidden() return not self:GetParent():HasModifier("modifier_puck_coil_magic") end
function modifier_custom_puck_dream_coil_kills:IsPurgable() return false end
function modifier_custom_puck_dream_coil_kills:RemoveOnDeath() return false end
function modifier_custom_puck_dream_coil_kills:GetTexture() return "buffs/coil_kills" end
function modifier_custom_puck_dream_coil_kills:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
  MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
  MODIFIER_PROPERTY_TOOLTIP
}
end



function modifier_custom_puck_dream_coil_kills:OnTooltip()
return self:GetStackCount()
end

function modifier_custom_puck_dream_coil_kills:GetModifierAttackSpeedBonus_Constant()
if not self:GetParent():HasModifier("modifier_puck_coil_magic") then return 0 end 

	return self:GetStackCount()*self:GetCaster():GetTalentValue("modifier_puck_coil_magic", "speed")
end
   

function modifier_custom_puck_dream_coil_kills:GetModifierSpellAmplify_Percentage() 
if not self:GetParent():HasModifier("modifier_puck_coil_magic") then return 0 end 
if self:GetStackCount() < self.max then return end

	return self:GetCaster():GetTalentValue("modifier_puck_coil_magic", "damage")
end


function modifier_custom_puck_dream_coil_kills:OnCreated(table)

self.max = self:GetCaster():GetTalentValue("modifier_puck_coil_magic", "max", true)

if not IsServer() then return end

self:SetStackCount(1)
end




function modifier_custom_puck_dream_coil_kills:OnRefresh()
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end

self:IncrementStackCount()

if self:GetStackCount() >= self.max then 

	local particle_peffect = ParticleManager:CreateParticle("particles/lc_odd_proc_.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
    ParticleManager:SetParticleControl(particle_peffect, 0, self:GetParent():GetAbsOrigin())
    ParticleManager:SetParticleControl(particle_peffect, 2, self:GetParent():GetAbsOrigin())
    ParticleManager:ReleaseParticleIndex(particle_peffect)

    self:GetCaster():EmitSound("BS.Thirst_legendary_active")

end

end



modifier_custom_puck_dream_coil_kill_timer = class({})
function modifier_custom_puck_dream_coil_kill_timer:IsHidden() return true end
function modifier_custom_puck_dream_coil_kill_timer:IsPurgable() return false end






modifier_custom_puck_dream_coil_thinker_scepter = class({})
function modifier_custom_puck_dream_coil_thinker_scepter:IsHidden() return false end
function modifier_custom_puck_dream_coil_thinker_scepter:IsPurgable() return false end
function modifier_custom_puck_dream_coil_thinker_scepter:OnCreated()
if not IsServer() then return end

self.targets = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("coil_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,  DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)



self.rapid_fire_interval		= self:GetAbility():GetSpecialValueFor("scepter_attacks") - FrameTime()*2

self:StartIntervalThink(self.rapid_fire_interval)
end 

function modifier_custom_puck_dream_coil_thinker_scepter:OnIntervalThink()
if not IsServer() then return end
if not self:GetCaster():IsAlive() then return end 
	
for _,target in pairs(self.targets) do 
	if (target:HasModifier("modifier_custom_puck_dream_coil") or target:HasModifier("modifier_custom_puck_dream_coil_stun")) and not target:IsAttackImmune() then 


		local projectile =
		{
		  Target = target,
		  Source = self:GetParent(),
		  Ability = self:GetAbility(),
		  EffectName = "particles/units/heroes/hero_puck/puck_base_attack.vpcf",
		  iMoveSpeed = self:GetCaster():GetProjectileSpeed(),
		  vSourceLoc = self:GetParent():GetAbsOrigin(),
		  bDodgeable = true,
		  bProvidesVision = false,
		}


		self:GetParent():EmitSound("Puck.Coil_Attack")
		local hProjectile = ProjectileManager:CreateTrackingProjectile( projectile )	
	end
end 


end


modifier_custom_puck_dream_coil_stun = class({})
function modifier_custom_puck_dream_coil_stun:IsHidden() return true end
function modifier_custom_puck_dream_coil_stun:IsPurgable() return false end
function modifier_custom_puck_dream_coil_stun:IsPurgeException() return true end
function modifier_custom_puck_dream_coil_stun:IsStunDebuff() return true end


modifier_custom_puck_dream_coil_mini_cd = class({})
function modifier_custom_puck_dream_coil_mini_cd:IsHidden() return true end
function modifier_custom_puck_dream_coil_mini_cd:IsPurgable() return false end
function modifier_custom_puck_dream_coil_mini_cd:RemoveOnDeath() return false end