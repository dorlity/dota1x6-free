LinkLuaModifier("modifier_bloodseeker_blood_bath_custom_thinker", "abilities/bloodseeker/bloodseeker_blood_bath_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bloodseeker_blood_bath_custom_silence", "abilities/bloodseeker/bloodseeker_blood_bath_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bloodseeker_blood_bath_custom_slow_aura", "abilities/bloodseeker/bloodseeker_blood_bath_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bloodseeker_blood_bath_custom_slow_blood", "abilities/bloodseeker/bloodseeker_blood_bath_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bloodseeker_blood_bath_custom_center", "abilities/bloodseeker/bloodseeker_blood_bath_custom", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_bloodseeker_blood_bath_custom_attack", "abilities/bloodseeker/bloodseeker_blood_bath_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bloodseeker_blood_bath_custom_attack_root", "abilities/bloodseeker/bloodseeker_blood_bath_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bloodseeker_blood_bath_custom_attack_str", "abilities/bloodseeker/bloodseeker_blood_bath_custom", LUA_MODIFIER_MOTION_NONE)

bloodseeker_blood_bath_custom = class({})






function bloodseeker_blood_bath_custom:Precache(context)

PrecacheResource( "particle", 'particles/units/heroes/hero_bloodseeker/bloodseeker_bloodritual_ring.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_bloodseeker/bloodseeker_bloodritual_impact.vpcf', context )
PrecacheResource( "particle", 'particles/status_fx/status_effect_rupture.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_bloodseeker/bloodseeker_rupture.vpcf', context )
PrecacheResource( "particle", 'particles/bs_root.vpcf', context )
PrecacheResource( "particle", 'particles/bloodseeker/rite_stun.vpcf', context )

end


function bloodseeker_blood_bath_custom:GetCastAnimation()
if self:GetCaster():HasModifier("modifier_bloodseeker_bloodrite_6") then 
	return 0
end 
	return ACT_DOTA_CAST_ABILITY_2
end



function bloodseeker_blood_bath_custom:GetManaCost(level)

local bonus = 0
if self:GetCaster():HasModifier("modifier_bloodseeker_bloodrite_3") then 
	bonus = self:GetCaster():GetTalentValue("modifier_bloodseeker_bloodrite_3", "mana")
end 

return self.BaseClass.GetManaCost(self,level) + bonus
end



function bloodseeker_blood_bath_custom:GetCastPoint()


if self:GetCaster():HasModifier("modifier_bloodseeker_bloodrite_6") then 
  return self:GetCaster():GetTalentValue("modifier_bloodseeker_bloodrite_6", "cast")
end

return self:GetSpecialValueFor("AbilityCastPoint")
end



function bloodseeker_blood_bath_custom:GetAOERadius()
	return self:GetSpecialValueFor( "radius" ) + self:GetCaster():GetTalentValue("modifier_bloodseeker_bloodrite_6", "radius")
end


function bloodseeker_blood_bath_custom:GetCooldown(iLevel)

local up = 0
if self:GetCaster():HasModifier("modifier_bloodseeker_bloodrite_3") then 
  up = self:GetCaster():GetTalentValue("modifier_bloodseeker_bloodrite_3", "cd")
end

return self.BaseClass.GetCooldown(self, iLevel) + up
 
end




function bloodseeker_blood_bath_custom:OnSpellStart()
if not IsServer() then return end
local point = self:GetCursorPosition()
local delay = self:GetSpecialValueFor("delay")

if self:GetCaster():HasModifier("modifier_bloodseeker_bloodrite_7") then 
	delay = self:GetCaster():GetTalentValue("modifier_bloodseeker_bloodrite_7", "duration")
end


self.thinker = CreateModifierThinker( self:GetCaster(), self, "modifier_bloodseeker_blood_bath_custom_thinker", {duration = delay}, point, self:GetCaster():GetTeamNumber(), false )
self.thinker:EmitSound("Hero_Bloodseeker.BloodRite.Cast")

local ability_end = self:GetCaster():FindAbilityByName("bloodseeker_blood_bath_custom_end")

if self:GetCaster():HasModifier("modifier_bloodseeker_bloodrite_7") and ability_end:IsHidden() then 
	self:GetCaster():SwapAbilities(self:GetName(), "bloodseeker_blood_bath_custom_end", false, true)

	ability_end:StartCooldown(self:GetCaster():GetTalentValue("modifier_bloodseeker_bloodrite_7", "delay"))
end

if self:GetCaster():HasModifier("modifier_bloodseeker_bloodrite_6") then 

  self:GetCaster():StartGesture(ACT_DOTA_CAST_ABILITY_4)
end 

if self:GetCaster():HasModifier("modifier_bloodseeker_bloodrite_4") then 
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_bloodseeker_blood_bath_custom_attack", {duration = self:GetCaster():GetTalentValue("modifier_bloodseeker_bloodrite_4", "duration")})
end

end


bloodseeker_blood_bath_custom_end = class({})

function bloodseeker_blood_bath_custom_end:OnSpellStart()

local ability = self:GetCaster():FindAbilityByName("bloodseeker_blood_bath_custom")

if self:GetCaster():HasModifier("modifier_bloodseeker_bloodrite_7") and ability and ability:IsHidden() then 
	self:GetCaster():SwapAbilities("bloodseeker_blood_bath_custom_end", "bloodseeker_blood_bath_custom", false, true)
end


if ability.thinker then 
	ability.thinker:FindModifierByName("modifier_bloodseeker_blood_bath_custom_thinker"):Destroy()
end

end








modifier_bloodseeker_blood_bath_custom_thinker = class({})

function modifier_bloodseeker_blood_bath_custom_thinker:IsPurgable()
	return false
end



function modifier_bloodseeker_blood_bath_custom_thinker:IsHidden() return true end

function modifier_bloodseeker_blood_bath_custom_thinker:IsPurgable() return false end

function modifier_bloodseeker_blood_bath_custom_thinker:IsAura() 
if self:GetCaster():HasModifier("modifier_bloodseeker_bloodrite_1") or self:GetCaster():HasModifier("modifier_bloodseeker_bloodrite_6") then 
	return true 
end

end

function modifier_bloodseeker_blood_bath_custom_thinker:GetAuraDuration() return 0.1 end

function modifier_bloodseeker_blood_bath_custom_thinker:GetAuraRadius() return self.radius
end

function modifier_bloodseeker_blood_bath_custom_thinker:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end

function modifier_bloodseeker_blood_bath_custom_thinker:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO +  DOTA_UNIT_TARGET_BASIC end

function modifier_bloodseeker_blood_bath_custom_thinker:GetModifierAura() return "modifier_bloodseeker_blood_bath_custom_slow_aura" end

function modifier_bloodseeker_blood_bath_custom_thinker:OnCreated( kv )
if not IsServer() then return end

self:GetAbility():EndCooldown()
self:GetAbility():SetActivated(false)

self.caster = self:GetCaster()

self.damage_duration = self:GetCaster():GetTalentValue("modifier_bloodseeker_bloodrite_1", "duration")

self.legendary_damage = self:GetCaster():GetTalentValue("modifier_bloodseeker_bloodrite_7", "damage")/100
self.legendary_interval = self:GetCaster():GetTalentValue("modifier_bloodseeker_bloodrite_7", "interval")
self.legendary_damage_self = self.legendary_interval * self:GetCaster():GetTalentValue("modifier_bloodseeker_bloodrite_7", "self_damage")/100

self.legendary_count = 0
self.damage = self:GetAbility():GetSpecialValueFor("damage")
self.think_interval = 0.03

local sound = "Hero_Bloodseeker.BloodRite"

if self:GetCaster():HasModifier("modifier_bloodseeker_bloodrite_7") then 
	sound = "BS.Bloodrite"
	self:StartIntervalThink(self.think_interval)
	self.sound = 2.25
end

self.max_timer = self:GetRemainingTime()

self.radius = self:GetAbility():GetSpecialValueFor("radius") + self:GetCaster():GetTalentValue("modifier_bloodseeker_bloodrite_6", "radius")
self.silence_duration = self:GetAbility():GetSpecialValueFor("silence_duration")

self.knockback_duration = self:GetCaster():GetTalentValue("modifier_bloodseeker_bloodrite_6", "duration")


if self:GetCaster():HasModifier("modifier_bloodseeker_bloodrite_6") then 


	local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetParent():GetOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
	for _,enemy in pairs(enemies) do 
		enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_bloodseeker_blood_bath_custom_center", {duration = self.knockback_duration, x = self:GetParent():GetAbsOrigin().x, y = self:GetParent():GetAbsOrigin().y})
	end
end

AddFOWViewer( self:GetCaster():GetTeamNumber(), self:GetParent():GetOrigin(), self.radius, 6 + self:GetRemainingTime(), false)

self.particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_bloodseeker/bloodseeker_bloodritual_ring.vpcf", PATTACH_WORLDORIGIN, nil )
ParticleManager:SetParticleControl( self.particle, 0, self:GetParent():GetOrigin() )
ParticleManager:SetParticleControl( self.particle, 1, Vector( self.radius, self.radius, self.radius ) )
self:AddParticle(self.particle, false, false, -1, false, false)

self:GetParent():EmitSound(sound)
end



function modifier_bloodseeker_blood_bath_custom_thinker:OnIntervalThink()
if not IsServer() then return end 

self.legendary_count = self.legendary_count + self.think_interval

if self.legendary_count >= self.legendary_interval then 

	self.legendary_count = 0
	if (self.caster:GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D() <= self.radius and self.caster:IsAlive() then 
		ApplyDamage({attacker = self.caster, victim = self.caster, damage_type = DAMAGE_TYPE_PURE, ability = self:GetAbility(), damage = self.caster:GetMaxHealth()*self.legendary_damage_self, damage_flags =  DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS + DOTA_DAMAGE_FLAG_NON_LETHAL + DOTA_DAMAGE_FLAG_BYPASSES_BLOCK})
	end 

end

CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetCaster():GetPlayerOwnerID()), 'bloodseeker_rite_change',  {hide = 0, max_time = self.max_timer, time = self:GetRemainingTime(), damage = self:GetStackCount(),})				
	
if self:GetElapsedTime() >= self.sound then 
	self.sound = 9999
	self:GetParent():StopSound("BS.Bloodrite")
end 

end 



function modifier_bloodseeker_blood_bath_custom_thinker:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_TAKEDAMAGE
}
end


function modifier_bloodseeker_blood_bath_custom_thinker:OnTakeDamage(params)
if not IsServer() then return end 
if not self:GetCaster():HasModifier("modifier_bloodseeker_bloodrite_7") then return end 
if not params.attacker then return end 

local target = params.unit
local attacker = params.attacker

if attacker:IsBuilding() then return end
if target ~= self:GetCaster() then return end
if (target:GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D() > self.radius then return end

local damage = params.damage*self.legendary_damage


self:SetStackCount(self:GetStackCount() + damage)

end



function modifier_bloodseeker_blood_bath_custom_thinker:OnDestroy( kv )
if not IsServer() then return end


self:GetAbility():SetActivated(true)
self:GetAbility():UseResources(false, false, false, true)

CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetCaster():GetPlayerOwnerID()), 'bloodseeker_rite_change',  {hide = 1, max_time = self.max_timer, damage = self:GetStackCount(),})				
	

self:GetAbility().thinker = nil

if self:GetCaster():HasModifier("modifier_bloodseeker_bloodrite_7") then

	if self:GetAbility():IsHidden() then 
		self:GetCaster():SwapAbilities("bloodseeker_blood_bath_custom_end", "bloodseeker_blood_bath_custom", false, true)
	end 

	self:GetParent():EmitSound("hero_bloodseeker.bloodRite.silence")
	self:GetParent():StopSound("Hero_Bloodseeker.BloodRite")
	self:GetParent():StopSound("BS.Bloodrite")
end


if self:GetStackCount() > 0 then 
	self.damage = self.damage + self:GetStackCount()
end

local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetParent():GetOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )

for _,enemy in pairs(enemies) do
	if enemy:IsRealHero() and self:GetCaster():GetQuest() == "Blood.Quest_6" then 
		self:GetCaster():UpdateQuest(1)
	end

	enemy:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_bloodseeker_blood_bath_custom_silence", { duration = self.silence_duration*(1 - enemy:GetStatusResistance()) } )

	ApplyDamage({ attacker = self:GetCaster(), victim = enemy, damage = self.damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self:GetAbility() })

	if self:GetCaster():HasModifier("modifier_bloodseeker_bloodrite_1") then
		enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_bloodseeker_blood_bath_custom_slow_blood", {duration = self.damage_duration})
	end

	local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_bloodseeker/bloodseeker_bloodritual_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy )
	ParticleManager:ReleaseParticleIndex( particle )
	enemy:EmitSound("hero_bloodseeker.bloodRite.silence")
end


if (self:GetCaster():GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D() <= self.radius then

	if self:GetCaster():HasModifier("modifier_bloodseeker_bloodrite_5") then 
		self:GetCaster():EmitSound("BS.Bloodrite_purge")
		self:GetCaster():Purge(false, true, false, true, false)
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_generic_debuff_immune", {effect = 1, duration = self:GetCaster():GetTalentValue("modifier_bloodseeker_bloodrite_5", "bkb")})
	end

	if self:GetCaster():HasModifier("modifier_bloodseeker_bloodrite_2") then 
		self:GetCaster():GenericHeal(self:GetCaster():GetMaxHealth()*self:GetCaster():GetTalentValue("modifier_bloodseeker_bloodrite_2", "heal")/100, self:GetAbility())
	end

end

UTIL_Remove(self:GetParent())
end







modifier_bloodseeker_blood_bath_custom_silence = class({})

function modifier_bloodseeker_blood_bath_custom_silence:IsPurgable() return true end

function modifier_bloodseeker_blood_bath_custom_silence:CheckState()
	local state = {
		[MODIFIER_STATE_SILENCED] = true,
	}

	return state
end

function modifier_bloodseeker_blood_bath_custom_silence:GetEffectName()
	return "particles/generic_gameplay/generic_silenced.vpcf"
end

function modifier_bloodseeker_blood_bath_custom_silence:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end



function modifier_bloodseeker_blood_bath_custom_silence:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
}
end


function modifier_bloodseeker_blood_bath_custom_silence:GetModifierMoveSpeedBonus_Percentage()
if not self:GetCaster():HasModifier("modifier_bloodseeker_bloodrite_6") then return end
return self.slow
end


function modifier_bloodseeker_blood_bath_custom_silence:OnCreated()
self.slow = self:GetCaster():GetTalentValue("modifier_bloodseeker_bloodrite_6", "slow")
end 




modifier_bloodseeker_blood_bath_custom_slow_aura = class({})
function modifier_bloodseeker_blood_bath_custom_slow_aura:IsHidden() return false end
function modifier_bloodseeker_blood_bath_custom_slow_aura:IsPurgable() return false end
function modifier_bloodseeker_blood_bath_custom_slow_aura:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
}
end

function modifier_bloodseeker_blood_bath_custom_slow_aura:GetModifierMoveSpeedBonus_Percentage()
if not self:GetCaster():HasModifier("modifier_bloodseeker_bloodrite_6") then return end 
if self:GetParent():HasModifier("modifier_bloodseeker_blood_bath_custom_silence") then return end
return self.slow
end


function modifier_bloodseeker_blood_bath_custom_slow_aura:GetModifierIncomingDamage_Percentage()
if not self:GetCaster():HasModifier("modifier_bloodseeker_bloodrite_1") then return end 
if self:GetParent():HasModifier("modifier_bloodseeker_blood_bath_custom_slow_blood") then return end
return self.damage
end



function modifier_bloodseeker_blood_bath_custom_slow_aura:OnCreated()

self.damage = self:GetCaster():GetTalentValue("modifier_bloodseeker_bloodrite_1", "damage")
self.slow = self:GetCaster():GetTalentValue("modifier_bloodseeker_bloodrite_6", "slow")

end 





modifier_bloodseeker_blood_bath_custom_slow_blood = class({})
function modifier_bloodseeker_blood_bath_custom_slow_blood:IsHidden() return false end
function modifier_bloodseeker_blood_bath_custom_slow_blood:IsPurgable() return false end
function modifier_bloodseeker_blood_bath_custom_slow_blood:GetTexture() return "buffs/Crit_blood" end
function modifier_bloodseeker_blood_bath_custom_slow_blood:GetEffectName() return "particles/items2_fx/sange_maim.vpcf" end

function modifier_bloodseeker_blood_bath_custom_slow_blood:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
}

end

function modifier_bloodseeker_blood_bath_custom_slow_blood:GetModifierIncomingDamage_Percentage()
return self.damage 
end

function modifier_bloodseeker_blood_bath_custom_slow_blood:OnCreated()

self.damage = self:GetCaster():GetTalentValue("modifier_bloodseeker_bloodrite_1", "damage")
end 






modifier_bloodseeker_blood_bath_custom_center = class({})

function modifier_bloodseeker_blood_bath_custom_center:IsHidden() return true end





function modifier_bloodseeker_blood_bath_custom_center:GetStatusEffectName()
	return "particles/status_fx/status_effect_rupture.vpcf"
end

function modifier_bloodseeker_blood_bath_custom_center:StatusEffectPriority()
	return 500
end


		


function modifier_bloodseeker_blood_bath_custom_center:OnCreated(params)
if not IsServer() then return end

self.ability        = self:GetAbility()
self.caster         = self:GetCaster()
self.parent         = self:GetParent()
self:GetParent():StartGesture(ACT_DOTA_FLAIL)

self.knockback_duration   = self:GetRemainingTime()

local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_bloodseeker/bloodseeker_rupture.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControlEnt(particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
self:AddParticle(particle, false, false, -1, false, false)


self.position = GetGroundPosition(Vector(params.x, params.y, 0), nil)

self.knockback_distance = (self:GetParent():GetAbsOrigin() -self.position):Length2D() 

self.knockback_speed    = self.knockback_distance / self.knockback_duration


if self:ApplyHorizontalMotionController() == false then 
  self:Destroy()
  return
end

end

function modifier_bloodseeker_blood_bath_custom_center:UpdateHorizontalMotion( me, dt )
  if not IsServer() then return end

  local distance = (self.position - me:GetOrigin()):Normalized()
  
  me:SetOrigin( me:GetOrigin() + distance * self.knockback_speed * dt )

  GridNav:DestroyTreesAroundPoint( self.parent:GetOrigin(), self.parent:GetHullRadius(), true )
end

function modifier_bloodseeker_blood_bath_custom_center:DeclareFunctions()
  local decFuncs = {
    MODIFIER_PROPERTY_OVERRIDE_ANIMATION
    }

    return decFuncs
end

function modifier_bloodseeker_blood_bath_custom_center:GetOverrideAnimation()
   return ACT_DOTA_FLAIL
end


function modifier_bloodseeker_blood_bath_custom_center:OnDestroy()
  if not IsServer() then return end
 self.parent:RemoveHorizontalMotionController( self )
  self:GetParent():FadeGesture(ACT_DOTA_FLAIL)
end







modifier_bloodseeker_blood_bath_custom_attack = class({})
function modifier_bloodseeker_blood_bath_custom_attack:IsHidden() return false end
function modifier_bloodseeker_blood_bath_custom_attack:IsPurgable() return false end
function modifier_bloodseeker_blood_bath_custom_attack:GetTexture() return "buffs/bloodrite_attack" end
function modifier_bloodseeker_blood_bath_custom_attack:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_ATTACK_LANDED,
	MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
}
end

function modifier_bloodseeker_blood_bath_custom_attack:GetModifierAttackRangeBonus()
return self.range
end

function modifier_bloodseeker_blood_bath_custom_attack:OnCreated()

self.duration = self:GetCaster():GetTalentValue("modifier_bloodseeker_bloodrite_4", "duration")
self.str = self:GetCaster():GetTalentValue("modifier_bloodseeker_bloodrite_4", "str")/100
self.taunt = self:GetCaster():GetTalentValue("modifier_bloodseeker_bloodrite_4", "taunt")
self.range = self:GetCaster():GetTalentValue("modifier_bloodseeker_bloodrite_4", "range")

end 


function modifier_bloodseeker_blood_bath_custom_attack:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end
if params.target:IsMagicImmune() or params.target:IsBuilding() then return end

local root = (1 - params.target:GetStatusResistance())*self.taunt

local str = 0
if params.target:IsHero() then 
	str = self.str*params.target:GetStrength()
end

if params.target:IsCreep() then 
	str = self.str*self:GetParent():GetStrength()
end

for i = 1,3 do
	local particle = ParticleManager:CreateParticle( "particles/bloodseeker/rite_stun.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControlEnt( particle, 1, params.target, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true )
	ParticleManager:DestroyParticle(particle, false)
	ParticleManager:ReleaseParticleIndex( particle )
end 

if not params.target:IsDebuffImmune() then 
	params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_generic_taunt", {duration = root})
end
 
local mod = params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_bloodseeker_blood_bath_custom_attack_str", {duration = self.duration})
mod:SetStackCount(str)

mod = self:GetCaster():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_bloodseeker_blood_bath_custom_attack_str", {duration = self.duration})
mod:SetStackCount(str)

self:Destroy()
end







modifier_bloodseeker_blood_bath_custom_attack_root = class({})
function modifier_bloodseeker_blood_bath_custom_attack_root:IsHidden() return true end
function modifier_bloodseeker_blood_bath_custom_attack_root:IsPurgable() return true end



function modifier_bloodseeker_blood_bath_custom_attack_root:CheckState()
return
{
	[MODIFIER_STATE_ROOTED] = true
}
end

function modifier_bloodseeker_blood_bath_custom_attack_root:GetEffectName()
return "particles/bs_root.vpcf"
end



modifier_bloodseeker_blood_bath_custom_attack_str = class({})
function modifier_bloodseeker_blood_bath_custom_attack_str:IsHidden() return false end
function modifier_bloodseeker_blood_bath_custom_attack_str:IsPurgable() return false end
function modifier_bloodseeker_blood_bath_custom_attack_str:GetTexture() return "buffs/bloodrite_attack" end
function modifier_bloodseeker_blood_bath_custom_attack_str:OnCreated(table)
if self:GetParent():IsCreep() then 
	self:Destroy()
	return
end

self.k = 1
if self:GetCaster() ~= self:GetParent() then 
	self.k = -1
end


end

function modifier_bloodseeker_blood_bath_custom_attack_str:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_STATS_STRENGTH_BONUS
}
end


function modifier_bloodseeker_blood_bath_custom_attack_str:GetModifierBonusStats_Strength()
return self.k*self:GetStackCount()
end
