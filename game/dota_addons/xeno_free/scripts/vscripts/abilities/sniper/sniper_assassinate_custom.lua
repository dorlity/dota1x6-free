LinkLuaModifier( "modifier_sniper_assassinate_custom", "abilities/sniper/sniper_assassinate_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sniper_assassinate_custom_legendary_unit", "abilities/sniper/sniper_assassinate_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sniper_assassinate_custom_legendary_anim", "abilities/sniper/sniper_assassinate_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sniper_assassinate_custom_legendary_slow", "abilities/sniper/sniper_assassinate_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sniper_assassinate_custom_legendary_stack", "abilities/sniper/sniper_assassinate_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sniper_assassinate_custom_kill_stack", "abilities/sniper/sniper_assassinate_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sniper_assassinate_custom_kill_tracker", "abilities/sniper/sniper_assassinate_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sniper_assassinate_custom_break", "abilities/sniper/sniper_assassinate_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sniper_assassinate_custom_slow", "abilities/sniper/sniper_assassinate_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sniper_assassinate_custom_mark", "abilities/sniper/sniper_assassinate_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sniper_assassinate_custom_speed", "abilities/sniper/sniper_assassinate_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sniper_assassinate_custom_attack", "abilities/sniper/sniper_assassinate_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sniper_assassinate_custom_attack_damage", "abilities/sniper/sniper_assassinate_custom", LUA_MODIFIER_MOTION_NONE )



sniper_assassinate_custom = class({})


sniper_assassinate_custom.storedTargets = {}
sniper_assassinate_custom.thinkers = {}

sniper_assassinate_custom.damage_inc = {0.05, 0.075, 0.1}
sniper_assassinate_custom.damage_creeps = 0.33


sniper_assassinate_custom.break_duration = 3
sniper_assassinate_custom.break_heal = -50

sniper_assassinate_custom.knock_slow = {-20, -30, -40}
sniper_assassinate_custom.knock_duration = 4
sniper_assassinate_custom.knock_distance = {200, 300, 400}
sniper_assassinate_custom.knock_distance_min = 500

sniper_assassinate_custom.range_duration = 4
sniper_assassinate_custom.range_speed = {30, 45, 60}
sniper_assassinate_custom.range_heal = {0.2, 0.3, 0.4}
sniper_assassinate_custom.range_creeps = 0.33


function sniper_assassinate_custom:Precache(context)

PrecacheResource( "particle", "particles/units/heroes/hero_sniper/sniper_crosshair.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_sniper/sniper_assassinate.vpcf", context )
PrecacheResource( "particle", "particles/econ/items/sniper/sniper_fall20_immortal/sniper_legendary_assassinate.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_monkey_king/monkey_king_quad_tap_hit.vpcf", context )
PrecacheResource( "particle", "particles/sniper_assassinate_stack.vpcf", context )
PrecacheResource( "particle", "particles/items3_fx/silver_edge.vpcf", context )
PrecacheResource( "particle", "particles/generic_gameplay/generic_break.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_snapfire/hero_snapfire_shotgun_debuff.vpcf", context )
PrecacheResource( "particle", "particles/status_fx/status_effect_snapfire_slow.vpcf", context )
PrecacheResource( "particle", "particles/lc_odd_proc_.vpcf", context )
PrecacheResource( "particle", "particles/lc_odd_charge_mark.vpcf", context )
PrecacheResource( "particle", "particles/sniper_ult_mark.vpcf", context )
PrecacheResource( "particle", "particles/items2_fx/sange_maim.vpcf", context )

end


function sniper_assassinate_custom:GetCastPoint(iLevel)
if self:GetCaster():HasScepter() then 
	return self:GetSpecialValueFor("scepter_cast_point")
end

return self.BaseClass.GetCastPoint(self)
end



function sniper_assassinate_custom:GetAOERadius()
return self:GetSpecialValueFor("aoe_radius")
end



function sniper_assassinate_custom:OnAbilityPhaseStart()

local caster = self:GetCaster()
caster:EmitSound("Ability.AssassinateLoad")
self.storedTargets = {}

local point = self:GetCursorPosition()

local enemies = FindUnitsInRadius(caster:GetTeamNumber(), point, caster,self:GetSpecialValueFor("aoe_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false)
    
for _,enemy in pairs(enemies) do
    enemy:AddNewModifier(caster,self,"modifier_sniper_assassinate_custom", {duration = self:GetSpecialValueFor("debuff_duration")})
    table.insert(self.storedTargets, enemy)
end

return true

end


function sniper_assassinate_custom:OnAbilityPhaseInterrupted()
if not self.storedTargets then return end
if #self.storedTargets == 0 then return end

for i,target in pairs(self.storedTargets) do 
	target:RemoveModifierByName("modifier_sniper_assassinate_custom")
end

self.storedTargets = {}

end










function sniper_assassinate_custom:OnSpellStart(new_target)

local mouse_target = self:GetCursorTarget()
if new_target then 
	mouse_target = new_target
end

self:GetCaster():UpdateQuest(0)

EmitSoundOnLocationWithCaster(self:GetCaster():GetAbsOrigin(),"Ability.Assassinate",self:GetCaster())
  
local targets_array = {}


if #self.storedTargets > 0 then 
	for i,target in pairs(self.storedTargets) do 
		targets_array[#targets_array + 1] = target
	end
	self.storedTargets = {}
else 
	targets_array[1] = mouse_target
end


if self:GetCaster():HasModifier("modifier_sniper_assassinate_3") then 
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_sniper_assassinate_custom_speed", {duration = self.range_duration})
end


for _,target in pairs(targets_array) do


	local sound_thinker = CreateModifierThinker( self:GetCaster(),  self,  "modifier_sniper_assassinate_custom_legendary_unit", {duration = self:GetSpecialValueFor("distance")/self:GetSpecialValueFor("projectile_speed")}, self:GetCaster():GetAbsOrigin(), self:GetCaster():GetTeamNumber(),  false )

	sound_thinker:EmitSound("Hero_Sniper.AssassinateProjectile")

    local projTable = {
      EffectName = "particles/units/heroes/hero_sniper/sniper_assassinate.vpcf",
      Ability = self,
      Target = target,
      Source = self:GetCaster(),
      bDodgeable = not self:GetCaster():HasModifier("modifier_sniper_assassinate_5"),
      vSpawnOrigin = self:GetCaster():GetAbsOrigin(),
      iMoveSpeed = self:GetSpecialValueFor("projectile_speed"), --
      iVisionRadius = 100,--
      iVisionTeamNumber = self:GetCaster():GetTeamNumber(),
      bProvidesVision = true,
      iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1,
	  ExtraData =   
		{
		  thinker = sound_thinker:entindex(),
		},
    }


	table.insert(self.thinkers, sound_thinker:entindex())


    ProjectileManager:CreateTrackingProjectile(projTable)
end


end



function sniper_assassinate_custom:OnProjectileThink_ExtraData(location, data)
if not IsServer() then return end

if data.thinker and EntIndexToHScript(data.thinker) and not EntIndexToHScript(data.thinker):IsNull() then 
	EntIndexToHScript(data.thinker):SetAbsOrigin(location)
end

end




function sniper_assassinate_custom:OnProjectileHit_ExtraData(hTarget, vLocation, data)
if not hTarget then return end

local caster = self:GetCaster()
local ability = self
local target = hTarget
  
target:RemoveModifierByName("modifier_sniper_assassinate_custom")

if data.thinker and EntIndexToHScript(data.thinker) and not EntIndexToHScript(data.thinker):IsNull() then 
	EntIndexToHScript(data.thinker):StopSound("Hero_Sniper.AssassinateProjectile")
	UTIL_Remove(EntIndexToHScript(data.thinker))
end


if target:TriggerSpellAbsorb(self) then return end
if target:IsMagicImmune() then return end

target:EmitSound("Hero_Sniper.AssassinateDamage")

local damage = self:GetAbilityDamage()

if self:GetCaster():HasModifier("modifier_sniper_assassinate_1") then 

	local bonus = self:GetCaster():GetTalentValue("modifier_sniper_assassinate_1", "damage")

	damage = damage + bonus
end

local count = 1 
local mod = target:FindModifierByName("modifier_sniper_assassinate_custom_legendary_stack")

if mod and mod.damage then 
	damage = damage*(1 + mod:GetStackCount()*mod.damage/100)
	count = count + mod:GetStackCount()

	mod:Destroy()
end


if target:IsValidKill(self:GetCaster()) then 
	target:AddNewModifier(self:GetCaster(), self, "modifier_sniper_assassinate_custom_kill_tracker", {duration = self:GetCaster():GetTalentValue("modifier_sniper_assassinate_6", "timer", true) + 0.1})
end

if self:GetCaster():HasModifier("modifier_sniper_assassinate_5") then 
	target:AddNewModifier(self:GetCaster(), self, "modifier_sniper_assassinate_custom_break", {duration = self.break_duration})
end


if self:GetCaster():HasModifier("modifier_sniper_assassinate_2") and (target:GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Length2D() <= self.knock_distance_min then 

	local knockback =	
	{
	    should_stun = 0,
	    knockback_duration = 0.2,
	    duration = 0.2,
	    knockback_distance = self.knock_distance[self:GetCaster():GetUpgradeStack("modifier_sniper_assassinate_2")] ,
	    knockback_height = 50,
	    center_x = caster:GetAbsOrigin().x,
	    center_y = caster:GetAbsOrigin().y,
	    center_z = caster:GetAbsOrigin().z,
	}

	target:AddNewModifier(caster,self,"modifier_knockback",knockback)
	target:AddNewModifier(self:GetCaster(), self, "modifier_sniper_assassinate_custom_slow", {duration = self.knock_duration})
end

if self:GetCaster():HasModifier("modifier_sniper_assassinate_4") then 
	target:AddNewModifier(self:GetCaster(), self, "modifier_sniper_assassinate_custom_mark", {duration = self:GetCaster():GetTalentValue("modifier_sniper_assassinate_4", "duration")})
end



local damageTable = {  victim = target, attacker = caster, ability = self, damage = damage,  damage_type = self:GetAbilityDamageType(), }
ApplyDamage(damageTable)

local duration = 0.03
if self:GetCaster():HasScepter() then 
	duration = self:GetSpecialValueFor("scepter_stun_duration")
end
target:AddNewModifier(self:GetCaster(), self, "modifier_sniper_assassinate_custom_attack", {count = count})

target:AddNewModifier(self:GetCaster(), self, "modifier_stunned", {duration = (1 - target:GetStatusResistance())*duration})

end




modifier_sniper_assassinate_custom = class({})

function modifier_sniper_assassinate_custom:IsHidden()
  return false
end
function modifier_sniper_assassinate_custom:IsPurgable()
  return false
end
function modifier_sniper_assassinate_custom:IsDebuff()
  return true
end



function modifier_sniper_assassinate_custom:GetAuraRadius()
	return 10
end

function modifier_sniper_assassinate_custom:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE
end

function modifier_sniper_assassinate_custom:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_sniper_assassinate_custom:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_sniper_assassinate_custom:GetModifierAura()
	return "modifier_truesight"
end
function modifier_sniper_assassinate_custom:IsAura() return true end



function modifier_sniper_assassinate_custom:OnCreated()
if not IsServer() then return end

	self.effect_cast = ParticleManager:CreateParticleForTeam( "particles/units/heroes/hero_sniper/sniper_crosshair.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent(), self:GetCaster():GetTeamNumber() )
	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, self:GetStackCount(), 0 ) )

	self:AddParticle(self.effect_cast,false, false, -1, false, false)


	self:StartIntervalThink(0.1)
end

function modifier_sniper_assassinate_custom:OnIntervalThink()
if not IsServer() then return end 

AddFOWViewer(self:GetCaster():GetTeamNumber(),self:GetParent():GetAbsOrigin(),10,0.1,true)

end








sniper_assassinate_custom_legendary = class({})

sniper_assassinate_custom_legendary.projectiles = {}
sniper_assassinate_custom_legendary.thinkers = {}


function sniper_assassinate_custom_legendary:OnAbilityPhaseStart()

self:GetCaster():EmitSound("Sniper.Assassinate_legendary_cast")

self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_sniper_assassinate_custom_legendary_anim", {})
--self:GetCaster():StartGesture(ACT_DOTA_CAST_ABILITY_4)

return true
end

function sniper_assassinate_custom_legendary:OnAbilityPhaseInterrupted()
if not IsServer() then return end


self:GetCaster():RemoveModifierByName("modifier_sniper_assassinate_custom_legendary_anim")
end




function sniper_assassinate_custom_legendary:OnProjectileThink_ExtraData(location, data)
if not IsServer() then return end

if data.thinker and EntIndexToHScript(data.thinker) and not EntIndexToHScript(data.thinker):IsNull() then 
	EntIndexToHScript(data.thinker):SetAbsOrigin(location)
end


end


function sniper_assassinate_custom_legendary:OnProjectileHit_ExtraData(hTarget, vLocation, data)
if not hTarget then return end
if not data.index or not self.projectiles or not self.projectiles[data.index] then return end

local enemy = hTarget


if self.projectiles[data.index] == 0 then 

	local cd = self:GetCooldownTimeRemaining()
	self:EndCooldown()
	self:StartCooldown(cd*self:GetSpecialValueFor("hit_cd")/100)

	self.projectiles[data.index] = 1
end


enemy:AddNewModifier(self:GetCaster(), self, "modifier_sniper_assassinate_custom_legendary_slow", {duration = self:GetSpecialValueFor("slow_duration")})
enemy:AddNewModifier(self:GetCaster(), self, "modifier_sniper_assassinate_custom_legendary_stack", {duration = self:GetSpecialValueFor("stack_duration")})


local particle_aoe_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_quad_tap_hit.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy)
ParticleManager:SetParticleControlEnt( particle_aoe_fx, 0, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true )
ParticleManager:SetParticleControlEnt( particle_aoe_fx, 1, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true )
ParticleManager:DestroyParticle(particle_aoe_fx, false)
ParticleManager:ReleaseParticleIndex(particle_aoe_fx) 


local damage = self:GetSpecialValueFor("damage")*enemy:GetHealth()/100

if enemy:IsCreep() then 
	damage = math.max(self:GetSpecialValueFor("damage_creeps"), damage)
end

EmitSoundOnLocationWithCaster(enemy:GetAbsOrigin(), "Sniper.Assassinate_legendary_damage", nil)

local damageTable = {  victim = enemy, attacker = self:GetCaster(), damage = damage, ability = self, damage_type = DAMAGE_TYPE_MAGICAL, }
ApplyDamage(damageTable)

end







function sniper_assassinate_custom_legendary:GetCooldown(iLevel)
return self:GetCaster():GetTalentValue("modifier_sniper_assassinate_7", "cd")
end


function sniper_assassinate_custom_legendary:OnSpellStart()


self:GetCaster():RemoveModifierByName("modifier_sniper_assassinate_custom_legendary_anim")

local caster = self:GetCaster()

local vect = self:GetCursorPosition() - self:GetCaster():GetAbsOrigin()
local dir = vect:Normalized()
local point = self:GetCaster():GetAbsOrigin() + dir*(self:GetSpecialValueFor("distance") + self:GetCaster():GetCastRangeBonus())




local sound_thinker = CreateModifierThinker( self:GetCaster(),  self,  "modifier_sniper_assassinate_custom_legendary_unit", {duration = self:GetSpecialValueFor("distance")/self:GetSpecialValueFor("projectile_speed")}, self:GetCaster():GetAbsOrigin(), self:GetCaster():GetTeamNumber(),  false )

sound_thinker:EmitSound("Sniper.Assassinate_legendary_proj")

local index = #self.projectiles + 1

self.projectiles[index] = 0


ProjectileManager:CreateLinearProjectile({
	EffectName = "particles/econ/items/sniper/sniper_fall20_immortal/sniper_legendary_assassinate.vpcf",
	Ability = self,
	vSpawnOrigin = caster:GetAbsOrigin(),
	fStartRadius = self:GetSpecialValueFor("projectile_width"),
	fEndRadius = self:GetSpecialValueFor("projectile_width"),
	vVelocity = dir * self:GetSpecialValueFor("projectile_speed"),
	fDistance = self:GetSpecialValueFor("distance") + self:GetCaster():GetCastRangeBonus(),
	Source = caster,
	iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
	iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
	bProvidesVision = true,
	iVisionTeamNumber = caster:GetTeamNumber(),
	iVisionRadius = self:GetSpecialValueFor("projectile_width")*2,
	ExtraData =   
	{
		index = index, 
		thinker = sound_thinker:entindex(),
	},
})



table.insert(self.thinkers, sound_thinker:entindex())

self:GetCaster():EmitSound("Sniper.Assassinate_legendary_shot")

end







modifier_sniper_assassinate_custom_legendary_unit = class({})
function modifier_sniper_assassinate_custom_legendary_unit:IsHidden() return true end
function modifier_sniper_assassinate_custom_legendary_unit:IsPurgable() return false end




modifier_sniper_assassinate_custom_legendary_anim = class({})
function modifier_sniper_assassinate_custom_legendary_anim:IsHidden() return true end
function modifier_sniper_assassinate_custom_legendary_anim:IsPurgable() return false end
function modifier_sniper_assassinate_custom_legendary_anim:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
}
end

function modifier_sniper_assassinate_custom_legendary_anim:GetActivityTranslationModifiers()
return "ultimate_scepter"
end



modifier_sniper_assassinate_custom_legendary_slow = class({})
function modifier_sniper_assassinate_custom_legendary_slow:IsHidden() return true end
function modifier_sniper_assassinate_custom_legendary_slow:IsPurgable() return true end
function modifier_sniper_assassinate_custom_legendary_slow:GetEffectName() return "particles/items2_fx/sange_maim.vpcf" end


function modifier_sniper_assassinate_custom_legendary_slow:OnCreated(table)

self.slow = self:GetAbility():GetSpecialValueFor("slow")

if not IsServer() then return end
self:OnIntervalThink()
self:StartIntervalThink(0.1)
end


function modifier_sniper_assassinate_custom_legendary_slow:OnIntervalThink()
if not IsServer() then return end 

AddFOWViewer(self:GetCaster():GetTeamNumber(),self:GetParent():GetAbsOrigin(),10,0.1,true)

end


function modifier_sniper_assassinate_custom_legendary_slow:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end


function modifier_sniper_assassinate_custom_legendary_slow:GetModifierMoveSpeedBonus_Percentage()
return self.slow
end






modifier_sniper_assassinate_custom_legendary_stack = class({})

function modifier_sniper_assassinate_custom_legendary_stack:IsHidden() return false end
function modifier_sniper_assassinate_custom_legendary_stack:IsPurgable() return false end
function modifier_sniper_assassinate_custom_legendary_stack:OnCreated(table)

self.RemoveForDuel = true

self.damage = self:GetCaster():GetTalentValue("modifier_sniper_assassinate_7", "damage")
self.max = self:GetCaster():GetTalentValue("modifier_sniper_assassinate_7", "max")
if not IsServer() then return end
self:SetStackCount(1)
end

function modifier_sniper_assassinate_custom_legendary_stack:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end

self:IncrementStackCount()
end


function modifier_sniper_assassinate_custom_legendary_stack:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOOLTIP
}
end

function modifier_sniper_assassinate_custom_legendary_stack:OnTooltip()
return self.damage*self:GetStackCount()
end





function modifier_sniper_assassinate_custom_legendary_stack:OnStackCountChanged(iStackCount)
if self:GetStackCount() == 0 then return end
if not self.effect_cast then 

	local particle_cast = "particles/sniper_assassinate_stack.vpcf"

	self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, self:GetStackCount(), 0 ) )

	self:AddParticle(self.effect_cast,false, false, -1, false, false)
else 

  ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, self:GetStackCount(), 0 ) )

end

end



modifier_sniper_assassinate_custom_kill_tracker = class({})
function modifier_sniper_assassinate_custom_kill_tracker:IsHidden() return true end
function modifier_sniper_assassinate_custom_kill_tracker:IsPurgable() return false end
function modifier_sniper_assassinate_custom_kill_tracker:RemoveOnDeath() return false end
function modifier_sniper_assassinate_custom_kill_tracker:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_DEATH
}
end

function modifier_sniper_assassinate_custom_kill_tracker:OnDeath(params)
if not IsServer() then return end
if self:GetParent() ~= params.unit then return end
if self:GetParent():IsReincarnating() then return end

if self:GetCaster():GetQuest() == "Sniper.Quest_8" then 
	self:GetCaster():UpdateQuest(1)
end


self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_sniper_assassinate_custom_kill_stack",  {})

self:Destroy()
end


modifier_sniper_assassinate_custom_kill_stack = class({})
function modifier_sniper_assassinate_custom_kill_stack:IsHidden() return not self:GetParent():HasModifier("modifier_sniper_assassinate_6") end
function modifier_sniper_assassinate_custom_kill_stack:IsPurgable() return false end
function modifier_sniper_assassinate_custom_kill_stack:RemoveOnDeath() return false end
function modifier_sniper_assassinate_custom_kill_stack:GetTexture() return "buffs/assassinate_kill" end
function modifier_sniper_assassinate_custom_kill_stack:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
	MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
    MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
    MODIFIER_PROPERTY_TOOLTIP
}
end



function modifier_sniper_assassinate_custom_kill_stack:OnTooltip()
return self:GetStackCount()
end

function modifier_sniper_assassinate_custom_kill_stack:GetModifierPercentageCooldown()
if not self:GetParent():HasModifier("modifier_sniper_assassinate_6") then return 0 end 
if self:GetStackCount() < self.max then return 0 end

	return self.cdr
end
   

function modifier_sniper_assassinate_custom_kill_stack:GetModifierSpellAmplify_Percentage() 
if not self:GetParent():HasModifier("modifier_sniper_assassinate_6") then return 0 end 

	return self:GetStackCount()*self.damage
end

function modifier_sniper_assassinate_custom_kill_stack:GetModifierDamageOutgoing_Percentage()
if not self:GetParent():HasModifier("modifier_sniper_assassinate_6") then return 0 end 

	return self:GetStackCount()*self.damage
end



function modifier_sniper_assassinate_custom_kill_stack:OnCreated(table)

self.max = self:GetCaster():GetTalentValue("modifier_sniper_assassinate_6", "max", true)
self.damage = self:GetCaster():GetTalentValue("modifier_sniper_assassinate_6", "damage", true)
self.cdr = self:GetCaster():GetTalentValue("modifier_sniper_assassinate_6", "cdr", true)

if not IsServer() then return end

self:SetStackCount(1)
end

function modifier_sniper_assassinate_custom_kill_stack:OnRefresh()
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



modifier_sniper_assassinate_custom_break = class({})
function modifier_sniper_assassinate_custom_break:IsHidden() return false end
function modifier_sniper_assassinate_custom_break:IsPurgable() return false end
function modifier_sniper_assassinate_custom_break:GetTexture() return 'buffs/assassinate_break' end
function modifier_sniper_assassinate_custom_break:CheckState()
return
{
	[MODIFIER_STATE_PASSIVES_DISABLED] = true
}
end

function modifier_sniper_assassinate_custom_break:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
  MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
  MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE
}
end



function modifier_sniper_assassinate_custom_break:GetModifierLifestealRegenAmplify_Percentage() 
return self:GetAbility().break_heal
end

function modifier_sniper_assassinate_custom_break:GetModifierHealAmplify_PercentageTarget()
return self:GetAbility().break_heal
end


function modifier_sniper_assassinate_custom_break:GetModifierHPRegenAmplify_Percentage() 
return self:GetAbility().break_heal
end



function modifier_sniper_assassinate_custom_break:GetEffectName() return "particles/items3_fx/silver_edge.vpcf" end


function modifier_sniper_assassinate_custom_break:OnCreated(table)

if not IsServer() then return end
  self.particle = ParticleManager:CreateParticle("particles/generic_gameplay/generic_break.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
  ParticleManager:SetParticleControl(self.particle, 1, self:GetParent():GetAbsOrigin())
  self:AddParticle(self.particle, false, false, -1, false, false)

end



modifier_sniper_assassinate_custom_slow = class({})
function modifier_sniper_assassinate_custom_slow:IsHidden() return false end
function modifier_sniper_assassinate_custom_slow:IsPurgable() return true end
function modifier_sniper_assassinate_custom_slow:GetTexture() return "buffs/assassinate_slow" end
function modifier_sniper_assassinate_custom_slow:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end
function modifier_sniper_assassinate_custom_slow:GetModifierMoveSpeedBonus_Percentage()
return self:GetAbility().knock_slow[self:GetCaster():GetUpgradeStack("modifier_sniper_assassinate_2")]
end


function modifier_sniper_assassinate_custom_slow:GetEffectName()
    return "particles/units/heroes/hero_snapfire/hero_snapfire_shotgun_debuff.vpcf"
end

function modifier_sniper_assassinate_custom_slow:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_sniper_assassinate_custom_slow:GetStatusEffectName()
    return "particles/status_fx/status_effect_snapfire_slow.vpcf"
end

function modifier_sniper_assassinate_custom_slow:StatusEffectPriority()
    return MODIFIER_PRIORITY_NORMAL
end



modifier_sniper_assassinate_custom_mark = class({})
function modifier_sniper_assassinate_custom_mark:IsHidden() return false end
function modifier_sniper_assassinate_custom_mark:IsPurgable() return false end
function modifier_sniper_assassinate_custom_mark:GetTexture() return "buffs/pulverize_kill" end
function modifier_sniper_assassinate_custom_mark:OnCreated(table)
if not IsServer() then return end

self.heal = self:GetCaster():GetTalentValue("modifier_sniper_assassinate_4", "heal")
self.heal_creeps = self:GetCaster():GetTalentValue("modifier_sniper_assassinate_4", "heal_creeps")
self.damage = self:GetCaster():GetTalentValue("modifier_sniper_assassinate_4", "damage")/100

self:SetStackCount(0)
self:StartIntervalThink(0.1)
end

function modifier_sniper_assassinate_custom_mark:OnIntervalThink()
if not IsServer() then return end

AddFOWViewer(self:GetCaster():GetTeamNumber(),self:GetParent():GetAbsOrigin(),10,0.1,true)
end


function modifier_sniper_assassinate_custom_mark:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_TAKEDAMAGE
}

end

function modifier_sniper_assassinate_custom_mark:GetEffectName() return "particles/lc_odd_charge_mark.vpcf" end
function modifier_sniper_assassinate_custom_mark:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end


function modifier_sniper_assassinate_custom_mark:OnTakeDamage(params)
if not IsServer() then return end
if self:GetParent() ~= params.unit then return end
if self:GetCaster() ~= params.attacker then return end

self:SetStackCount(self:GetStackCount() + params.damage*self.damage)
end


function modifier_sniper_assassinate_custom_mark:OnDestroy()
if not IsServer() then return end
if not self:GetParent():IsAlive() then return end
if self:GetStackCount() < 1 then return end


self:GetParent():EmitSound("Sniper.Assassinate_mark_damage")

local effect = ParticleManager:CreateParticle("particles/sniper_ult_mark.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:DestroyParticle(effect, false)
ParticleManager:ReleaseParticleIndex(effect) 

local damageTable = {  victim = self:GetParent(), attacker = self:GetCaster(), ability = self:GetAbility(), damage = self:GetStackCount(),  damage_type = DAMAGE_TYPE_PURE, }
local real_damage = ApplyDamage(damageTable)

if self:GetParent():IsIllusion() then return end

local heal = real_damage*self.heal/100
if self:GetParent():IsCreep() then 
	heal = heal/self.heal_creeps
end 

self:GetCaster():GenericHeal(heal, self:GetAbility())
end



modifier_sniper_assassinate_custom_speed = class({})
function modifier_sniper_assassinate_custom_speed:IsHidden() return false end
function modifier_sniper_assassinate_custom_speed:IsPurgable() return false end
function modifier_sniper_assassinate_custom_speed:GetTexture() return "buffs/acorn_range" end
function modifier_sniper_assassinate_custom_speed:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	MODIFIER_EVENT_ON_TAKEDAMAGE
}

end

function modifier_sniper_assassinate_custom_speed:GetModifierAttackSpeedBonus_Constant()
return self:GetAbility().range_speed[self:GetCaster():GetUpgradeStack("modifier_sniper_assassinate_3")]
end

function modifier_sniper_assassinate_custom_speed:OnTakeDamage(params)
if not IsServer() then return end
if params.attacker ~= self:GetParent() then return end
if not params.unit:IsHero() and not params.unit:IsCreep() then return end
if bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then return end

local heal = params.damage*self:GetAbility().range_heal[self:GetCaster():GetUpgradeStack("modifier_sniper_assassinate_3")]

if params.unit:IsCreep() then 
	heal = heal*self:GetAbility().range_creeps
end

self:GetCaster():GenericHeal(heal, self:GetAbility(), true)

end



modifier_sniper_assassinate_custom_attack = class({})
function modifier_sniper_assassinate_custom_attack:IsHidden() return true end
function modifier_sniper_assassinate_custom_attack:IsPurgable() return false end
function modifier_sniper_assassinate_custom_attack:OnCreated(table)
if not IsServer() then return end 

self:SetStackCount(table.count)

self:OnIntervalThink()
self:StartIntervalThink(0.05)
end 

function modifier_sniper_assassinate_custom_attack:OnIntervalThink()
if not IsServer() then return end 

local mod = self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_sniper_assassinate_custom_attack_damage", {duration = FrameTime()*2})

self:GetCaster():PerformAttack(self:GetParent(), true, true, true, true, false, false, true)
self:DecrementStackCount()

if mod then 
	mod:Destroy()
end 

if self:GetStackCount() < 1 then 
	self:Destroy()
end

end 


modifier_sniper_assassinate_custom_attack_damage = class({})
function modifier_sniper_assassinate_custom_attack_damage:IsPurgable() return false end
function modifier_sniper_assassinate_custom_attack_damage:IsHidden() return true end
function modifier_sniper_assassinate_custom_attack_damage:OnCreated()
if not IsServer() then return end 

self.damage = self:GetCaster():GetTalentValue("modifier_sniper_assassinate_1", "attack")
end 

function modifier_sniper_assassinate_custom_attack_damage:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE
}
end

function modifier_sniper_assassinate_custom_attack_damage:GetModifierDamageOutgoing_Percentage()
return self.damage
end