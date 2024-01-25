LinkLuaModifier("modifier_sandking_caustic_finale_custom", "abilities/sand_king/sandking_caustic_finale_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_sandking_caustic_finale_custom_slow", "abilities/sand_king/sandking_caustic_finale_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_sandking_caustic_finale_custom_legendary", "abilities/sand_king/sandking_caustic_finale_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_sandking_caustic_finale_custom_legendary_caster", "abilities/sand_king/sandking_caustic_finale_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_sandking_caustic_finale_custom_speed", "abilities/sand_king/sandking_caustic_finale_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_sandking_caustic_finale_custom_resist", "abilities/sand_king/sandking_caustic_finale_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_sandking_caustic_finale_custom_attack", "abilities/sand_king/sandking_caustic_finale_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_sandking_caustic_finale_custom_no_attack", "abilities/sand_king/sandking_caustic_finale_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_sandking_caustic_finale_custom_perma", "abilities/sand_king/sandking_caustic_finale_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_sandking_caustic_finale_custom_attack_slow", "abilities/sand_king/sandking_caustic_finale_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_sandking_caustic_finale_custom_lowhp", "abilities/sand_king/sandking_caustic_finale_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_sandking_caustic_finale_custom_pull_cd", "abilities/sand_king/sandking_caustic_finale_custom", LUA_MODIFIER_MOTION_NONE)

sandking_caustic_finale_custom = class({})
		
function sandking_caustic_finale_custom:Precache(context)
    
PrecacheResource( "particle", "particles/sand_king/sandking_caustic_finale_explode_custom.vpcf", context )
PrecacheResource( "particle", "particles/sand_king/finale_legendary_hit.vpcf", context )
PrecacheResource( "particle", "particles/sand_king/finale_legendary.vpcf", context )
PrecacheResource( "particle", "particles/sand_king/finale_legendary_explode.vpcf", context )
PrecacheResource( "particle", "particles/sand_king/finale_double_hit.vpcf", context )
end

function sandking_caustic_finale_custom:GetBehavior()
if self:GetCaster():HasModifier("modifier_sand_king_finale_7") then
	return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET
end

return DOTA_ABILITY_BEHAVIOR_PASSIVE
end

function sandking_caustic_finale_custom:GetCastRange(vLocation, hTarget)
if self:GetCaster():HasModifier("modifier_sand_king_finale_7") then
	return self:GetCaster():GetTalentValue("modifier_sand_king_finale_7", "range")
end

return 
end

function sandking_caustic_finale_custom:GetCooldown(iLevel)
if self:GetCaster():HasModifier("modifier_sand_king_finale_7") then
	return self:GetCaster():GetTalentValue("modifier_sand_king_finale_7", "cd")
end

return 
end


function sandking_caustic_finale_custom:GetAbilityTargetFlags()
if self:GetCaster():HasModifier("modifier_sand_king_finale_6") then 
  return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
else 
  return DOTA_UNIT_TARGET_FLAG_NONE
end

end




function sandking_caustic_finale_custom:OnAbilityPhaseStart()
self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_ATTACK, 1.7)

return true
end

function sandking_caustic_finale_custom:OnAbilityPhaseInterrupted()

self:GetCaster():RemoveGesture(ACT_DOTA_ATTACK)
end




function sandking_caustic_finale_custom:GetIntrinsicModifierName()
return "modifier_sandking_caustic_finale_custom"
end



function sandking_caustic_finale_custom:OnSpellStart()

local target = self:GetCursorTarget()

for i = 1,3 do 
	local particle = ParticleManager:CreateParticle( "particles/sand_king/finale_legendary_hit.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControlEnt( particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true )
	ParticleManager:DestroyParticle(particle, false)
	ParticleManager:ReleaseParticleIndex( particle )
end

self:GetCaster():EmitSound("SandKing.Finale_legerndary_caster")

target:AddNewModifier(self:GetCaster(), self, "modifier_sandking_caustic_finale_custom_legendary", {duration = self:GetCaster():GetTalentValue("modifier_sand_king_finale_7", "duration")})
self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_sandking_caustic_finale_custom_legendary_caster", {duration = self:GetCaster():GetTalentValue("modifier_sand_king_finale_7", "duration")})

end 



function sandking_caustic_finale_custom:ProcTalents(unit)

local resist_duration = self:GetCaster():GetTalentValue("modifier_sand_king_finale_4", "duration")
local mod = self:GetCaster():FindModifierByName("modifier_sandking_caustic_finale_custom_perma")

if self:GetCaster():HasModifier("modifier_sand_king_finale_1") then 
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_sandking_caustic_finale_custom_speed", {duration = self:GetCaster():GetTalentValue("modifier_sand_king_finale_1", "duration")})
end 

if mod and self:GetCaster():HasModifier("modifier_sand_king_finale_4") and mod:GetStackCount() >= self:GetCaster():GetTalentValue("modifier_sand_king_finale_4", "max") then 
	unit:AddNewModifier(self:GetCaster(), self:GetCaster():BkbAbility(self, self:GetCaster():HasModifier("modifier_sand_king_finale_6")), "modifier_sandking_caustic_finale_custom_resist", {duration = resist_duration})

end 

if self:GetCaster():HasModifier("modifier_sand_king_finale_3") then 
	unit:AddNewModifier(self:GetCaster(), self:GetCaster():BkbAbility(self, self:GetCaster():HasModifier("modifier_sand_king_finale_6")), "modifier_sandking_caustic_finale_custom_attack_slow", {duration = self:GetCaster():GetTalentValue("modifier_sand_king_finale_3", "duration")})
end 

if unit:IsRealHero() then 

	if self:GetCaster():GetQuest() == "Sand.Quest_7" then 
		self:GetCaster():UpdateQuest(1)
	end

	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_sandking_caustic_finale_custom_perma", {})
end 

if self:GetCaster():HasModifier("modifier_sand_king_finale_5")  then 
	local heal = self:GetCaster():GetTalentValue("modifier_sand_king_finale_5", "heal")*self:GetCaster():GetMaxHealth()/100

	if unit:IsCreep() then 
	--	heal = heal/self:GetCaster():GetTalentValue("modifier_sand_king_finale_5", "heal_creeps")
	end

	if self:GetCaster():GetHealthPercent() <= self:GetCaster():GetTalentValue("modifier_sand_king_finale_5", "health") then 
		heal = heal*self:GetCaster():GetTalentValue("modifier_sand_king_finale_5", "bonus")
	end 

	self:GetCaster():GenericHeal(heal, self)
end 

end 




function sandking_caustic_finale_custom:ApplyEffect(target)
if not IsServer() then return end
if self:GetCaster():PassivesDisabled() then return end

local duration = self:GetSpecialValueFor("caustic_finale_duration")

target:AddNewModifier(self:GetCaster(), self:GetCaster():BkbAbility(self, self:GetCaster():HasModifier("modifier_sand_king_finale_6")), "modifier_sandking_caustic_finale_custom_slow", {duration = duration})
end 


function sandking_caustic_finale_custom:GetDamage()
local damage = self:GetSpecialValueFor("caustic_finale_damage")

local mod = self:GetCaster():FindModifierByName("modifier_sandking_caustic_finale_custom_perma")

if mod and self:GetCaster():HasModifier("modifier_sand_king_finale_4") then 
	damage = damage + self:GetCaster():GetTalentValue("modifier_sand_king_finale_4","damage")*mod:GetStackCount()
end 


return damage
end


function sandking_caustic_finale_custom:DealDamage(unit, scepter)
if not IsServer() then return end

local damage = self:GetDamage()
local radius = self:GetSpecialValueFor("caustic_finale_radius")

self:ProcTalents(unit)

local effect_cast = ParticleManager:CreateParticle( "particles/sand_king/sandking_caustic_finale_explode_custom.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit )
ParticleManager:SetParticleControlEnt( effect_cast, 0, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetOrigin(), true )
ParticleManager:ReleaseParticleIndex( effect_cast )

unit:EmitSound("Ability.SandKing_CausticFinale")




local targets = self:GetCaster():FindTargets(radius, unit:GetAbsOrigin())

local damage_table = {attacker = self:GetCaster(), ability = self, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL}

if scepter then 

		damage_table.victim = unit
		local real_damage = ApplyDamage(damage_table)
else 

	for _,target in pairs(targets) do

		damage_table.victim = target
		local real_damage = ApplyDamage(damage_table)
	end 
end 

end 



modifier_sandking_caustic_finale_custom = class({})
function modifier_sandking_caustic_finale_custom:IsHidden() return true end
function modifier_sandking_caustic_finale_custom:IsPurgable() return false end


function modifier_sandking_caustic_finale_custom:OnCreated(table)

self.double_delay = self:GetCaster():GetTalentValue("modifier_sand_king_finale_7", "delay", true)
self.double_chance = self:GetCaster():GetTalentValue("modifier_sand_king_finale_7", "chance", true)

self.caster = self:GetCaster()
end 

function modifier_sandking_caustic_finale_custom:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_ATTACK_LANDED,
	MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
}
end



function modifier_sandking_caustic_finale_custom:GetModifierAttackRangeBonus()
if not self:GetParent():HasModifier("modifier_sand_king_finale_2") then return end 

return self:GetCaster():GetTalentValue("modifier_sand_king_finale_2", "range")
end

function modifier_sandking_caustic_finale_custom:OnAttackLanded(params)
if not IsServer() then return end 
if not self:GetParent():IsRealHero() then return end
if self.caster ~= params.attacker then return end 
if not params.target:IsCreep() and not params.target:IsHero() then return end

local target = params.target

if self.caster:HasModifier("modifier_sandking_caustic_finale_custom_legendary_caster") then

	local particle = ParticleManager:CreateParticle( "particles/sand_king/finale_legendary_hit.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.caster )
	ParticleManager:SetParticleControlEnt( particle, 1, params.target, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true )
	ParticleManager:DestroyParticle(particle, false)
	ParticleManager:ReleaseParticleIndex( particle )


end 

if self.caster:HasModifier("modifier_sand_king_finale_7") and not self.caster:HasModifier("modifier_sandking_caustic_finale_custom_no_attack") then

	if RollPseudoRandomPercentage(self.double_chance, 1523, self.caster) then 
		params.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_sandking_caustic_finale_custom_attack", {duration = self.double_delay})
	end 

end 

local mod = params.target:FindModifierByName("modifier_sandking_caustic_finale_custom_legendary")

if mod then 
	mod:IncrementStackCount()
end 

if self.caster:HasModifier("modifier_sand_king_finale_2") and target:GetUnitName() ~= "npc_teleport" and not params.no_attack_cooldown and not target:HasModifier("modifier_sandking_caustic_finale_custom_pull_cd") then 

	local caster = self.caster

	local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_marci/marci_dispose_debuff.vpcf", PATTACH_POINT_FOLLOW, caster )
	ParticleManager:SetParticleControlEnt( particle, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true )
	ParticleManager:SetParticleControlEnt( particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true )
	ParticleManager:SetParticleControl( particle, 5, Vector( 2, 0, 0 ) )
	ParticleManager:DestroyParticle(particle, false)
	ParticleManager:ReleaseParticleIndex( particle )
	target:EmitSound("SandKing.Attack_pull")

	target:AddNewModifier(self.caster, self:GetAbility(), "modifier_sandking_caustic_finale_custom_pull_cd", {duration = self.caster:GetTalentValue("modifier_sand_king_finale_2", "cd")})

	local dir = (self.caster:GetAbsOrigin() - target:GetAbsOrigin()):Normalized()
	local point = self.caster:GetAbsOrigin() - dir*50
	local distance = (point - target:GetAbsOrigin()):Length2D()

	distance = math.max(40, distance)
	point = target:GetAbsOrigin() + dir*distance

	local mod = target:AddNewModifier( self:GetCaster(),  self:GetAbility(),  "modifier_generic_arc",  
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

	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_marci/marci_rebound_allymovespeed.vpcf", PATTACH_ABSORIGIN_FOLLOW, target )
	mod:AddParticle(effect_cast,false, false, -1, false, false)

end 

self:GetAbility():ApplyEffect(params.target)
end 



modifier_sandking_caustic_finale_custom_slow = class({})
function modifier_sandking_caustic_finale_custom_slow:IsHidden() return self:GetParent():HasModifier("modifier_sandking_caustic_finale_custom_legendary") end
function modifier_sandking_caustic_finale_custom_slow:IsPurgable() return true end
function modifier_sandking_caustic_finale_custom_slow:GetEffectName()
	return "particles/neutral_fx/gnoll_poison_debuff.vpcf"
end

function modifier_sandking_caustic_finale_custom_slow:GetTexture() return "sandking_caustic_finale" end

function modifier_sandking_caustic_finale_custom_slow:OnCreated()

self.ability = self:GetCaster():FindAbilityByName("sandking_caustic_finale_custom")

if not self.ability then 
	self:Destroy()
	return
end 

self.damage_reduce = self:GetCaster():GetTalentValue("modifier_sand_king_finale_3", "damage")

self.legendary_bonus = self:GetCaster():GetTalentValue("modifier_sand_king_finale_7", "slow", true)

self.max = self.ability:GetSpecialValueFor("max_attacks")
self.slow = self.ability:GetSpecialValueFor("caustic_finale_slow") + self:GetCaster():GetTalentValue("modifier_sand_king_finale_6", "slow")
self.parent = self:GetParent()

if not IsServer() then return end

self:SetStackCount(1)
end 

function modifier_sandking_caustic_finale_custom_slow:OnRefresh(table)
if not IsServer() then return end 

self:IncrementStackCount()


if self:GetStackCount() >= self.max + self:GetCaster():GetTalentValue("modifier_sand_king_finale_6", "stack") then 
	self:SetStackCount(0)
	self.ability:DealDamage(self:GetParent())
end

end 



function modifier_sandking_caustic_finale_custom_slow:HideParticle()
if not IsServer() then return end 

if self.particle then 
	ParticleManager:DestroyParticle(self.particle, true)
	ParticleManager:ReleaseParticleIndex(self.particle)
	self.particle = nil
end 

end 



function modifier_sandking_caustic_finale_custom_slow:ShowParticle()
if not IsServer() then return end 
if self:GetStackCount() == 0 then return end

if not self.particle then 
	self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_bristleback/bristleback_viscous_nasal_stack.vpcf", PATTACH_OVERHEAD_FOLLOW, self.parent)
	self:AddParticle(self.particle, false, false, -1, false, false)
end

ParticleManager:SetParticleControl(self.particle, 1, Vector(0, self:GetStackCount(), 0))

end 



function modifier_sandking_caustic_finale_custom_slow:OnStackCountChanged(iStackCount)
if not IsServer() then return end 
if self.parent:HasModifier("modifier_sandking_caustic_finale_custom_legendary") then return end

if self:GetStackCount() > 0 then 
	self:ShowParticle()
else 
	self:HideParticle()
end 

end 





function modifier_sandking_caustic_finale_custom_slow:OnDestroy()
if not IsServer() then return end 

if not self:GetParent():IsAlive() then 
	self.ability:DealDamage(self:GetParent())
end 

end 


function modifier_sandking_caustic_finale_custom_slow:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
}
end 


function modifier_sandking_caustic_finale_custom_slow:GetModifierMoveSpeedBonus_Percentage()

local bonus = 1
if self:GetParent():HasModifier("modifier_sandking_caustic_finale_custom_legendary") then 
	bonus = self.legendary_bonus
end 

return self.slow * bonus
end

function modifier_sandking_caustic_finale_custom_slow:GetModifierTotalDamageOutgoing_Percentage()
if not self:GetCaster():HasModifier("modifier_sand_king_finale_3") then return end 

return self.damage_reduce
end






modifier_sandking_caustic_finale_custom_legendary = class({})
function modifier_sandking_caustic_finale_custom_legendary:IsHidden() return false end
function modifier_sandking_caustic_finale_custom_legendary:IsPurgable() return false end
function modifier_sandking_caustic_finale_custom_legendary:GetEffectName() return "particles/sand_king/finale_legendary_poison.vpcf" end
function modifier_sandking_caustic_finale_custom_legendary:GetStatusEffectName() return "particles/status_fx/status_effect_poison_venomancer.vpcf" end
function modifier_sandking_caustic_finale_custom_legendary:StatusEffectPriority() return 999999 end

function modifier_sandking_caustic_finale_custom_legendary:OnCreated()
if not IsServer() then return end
self.parent = self:GetParent()

self.RemoveForDuel = true

self.parent:EmitSound("SandKing.Finale_legerndary_start")
self.parent:EmitSound("SandKing.Finale_legerndary_loop")

local duration = self:GetCaster():GetTalentValue("modifier_sand_king_finale_7", "duration")

self.mod = self:GetParent():FindModifierByName("modifier_sandking_caustic_finale_custom_slow") 

if self.mod and not self.mod:IsNull() then 
	self.mod:HideParticle()
end 

self.time = self:GetCaster():GetTalentValue("modifier_sand_king_finale_7", "duration")

local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_venomancer/venomancer_venomous_gale_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
ParticleManager:ReleaseParticleIndex(particle)


self.particle = ParticleManager:CreateParticle("particles/sand_king/finale_legendary.vpcf", PATTACH_OVERHEAD_FOLLOW, self.parent)
ParticleManager:SetParticleControl( self.particle, 1, Vector(duration, duration, duration) )
ParticleManager:SetParticleControlEnt( self.particle, 4, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true )
self:AddParticle(self.particle, false, false, -1, false, false)

self:OnIntervalThink()
self:StartIntervalThink(FrameTime())
end 



function modifier_sandking_caustic_finale_custom_legendary:OnIntervalThink()
if not IsServer() then return end 

CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetCaster():GetPlayerOwnerID()), 'sandking_finale_change',  {hide = 0, max_time = self.time, time = self:GetRemainingTime(), damage = self:GetStackCount()})

end 




function modifier_sandking_caustic_finale_custom_legendary:OnStackCountChanged()
if not IsServer() then return end

self.parent:EmitSound("SandKing.Finale_legerndary_hit")
end 


function modifier_sandking_caustic_finale_custom_legendary:OnDestroy()
if not IsServer() then return end 

CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetCaster():GetPlayerOwnerID()), 'sandking_finale_change',  {hide = 1, max_time = self.time, time = self:GetRemainingTime(), damage = self:GetStackCount()})


self:GetParent():StopSound("SandKing.Finale_legerndary_loop")

self.mod = self:GetParent():FindModifierByName("modifier_sandking_caustic_finale_custom_slow") 

if self.mod and not self.mod:IsNull() then 
	self.mod:ShowParticle()
end 

if self:GetStackCount() == 0 then return end

local damage = self:GetAbility():GetDamage()
local radius = self:GetAbility():GetSpecialValueFor("caustic_finale_radius")


self:GetAbility():ProcTalents(self:GetParent())

local targets = self:GetCaster():FindTargets(radius, self:GetParent():GetAbsOrigin())

local damage_table = {attacker = self:GetCaster(), ability = self:GetAbility(), damage = damage*self:GetStackCount()*self:GetCaster():GetTalentValue("modifier_sand_king_finale_7", "damage")/100, damage_type = DAMAGE_TYPE_MAGICAL}

for _,target in pairs(targets) do
	damage_table.victim = target
	local real_damage = ApplyDamage(damage_table)

	target:SendNumber(6, real_damage)
end 

local effect_cast = ParticleManager:CreateParticle( "particles/sand_king/finale_legendary_explode.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent )
ParticleManager:SetParticleControlEnt( effect_cast, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetOrigin(), true )
ParticleManager:ReleaseParticleIndex( effect_cast )

self.parent:EmitSound("SandKing.Finale_legerndary_explode")
self.parent:EmitSound("Ability.SandKing_CausticFinale")

end 






modifier_sandking_caustic_finale_custom_legendary_caster = class({})
function modifier_sandking_caustic_finale_custom_legendary_caster:IsHidden() return true end
function modifier_sandking_caustic_finale_custom_legendary_caster:IsPurgable() return false end
function modifier_sandking_caustic_finale_custom_legendary_caster:OnCreated()
if not IsServer() then return end

end 

function modifier_sandking_caustic_finale_custom_legendary_caster:DeclareFunctions()
return
{
}
end










modifier_sandking_caustic_finale_custom_resist = class({})
function modifier_sandking_caustic_finale_custom_resist:IsHidden() return false end
function modifier_sandking_caustic_finale_custom_resist:IsPurgable() return false end
function modifier_sandking_caustic_finale_custom_resist:GetTexture() return "buffs/finale_resist" end
function modifier_sandking_caustic_finale_custom_resist:OnCreated(table)
self.resist = self:GetCaster():GetTalentValue("modifier_sand_king_finale_4", "resist")


end


function modifier_sandking_caustic_finale_custom_resist:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
}
end

function modifier_sandking_caustic_finale_custom_resist:GetModifierMagicalResistanceBonus()
return self.resist
end







modifier_sandking_caustic_finale_custom_speed = class({})
function modifier_sandking_caustic_finale_custom_speed:IsHidden() return false end
function modifier_sandking_caustic_finale_custom_speed:IsPurgable() return false end
function modifier_sandking_caustic_finale_custom_speed:GetTexture() return "buffs/finale_resist" end
function modifier_sandking_caustic_finale_custom_speed:OnCreated(table)
self.speed = self:GetCaster():GetTalentValue("modifier_sand_king_finale_1", "speed")
self.damage = self:GetCaster():GetTalentValue("modifier_sand_king_finale_1", "damage")

end

function modifier_sandking_caustic_finale_custom_speed:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE
}
end

function modifier_sandking_caustic_finale_custom_speed:GetModifierAttackSpeedBonus_Constant()
return self.speed
end


function modifier_sandking_caustic_finale_custom_speed:GetModifierSpellAmplify_Percentage()
return self.damage
end





modifier_sandking_caustic_finale_custom_attack = class({})
function modifier_sandking_caustic_finale_custom_attack:IsHidden() return true end
function modifier_sandking_caustic_finale_custom_attack:IsPurgable() return false end
function modifier_sandking_caustic_finale_custom_attack:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_sandking_caustic_finale_custom_attack:OnCreated()
if not IsServer() then return end 

local target = self:GetParent()
self.caster = self:GetCaster()

self.caster:StartGestureWithPlaybackRate(ACT_DOTA_ATTACK, 2)

local dir =  (target:GetOrigin() - self.caster:GetOrigin() ):Normalized()

self.caster:EmitSound("SandKing.Double_hit")

local particle = ParticleManager:CreateParticle( "particles/sand_king/finale_double_hit.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.caster )
ParticleManager:SetParticleControl( particle, 0, self.caster:GetAbsOrigin() )
ParticleManager:SetParticleControl( particle, 1, self.caster:GetAbsOrigin() )
ParticleManager:SetParticleControlForward( particle, 1, dir)
ParticleManager:SetParticleControl( particle, 2, Vector(1,1,1) )
ParticleManager:SetParticleControlForward( particle, 5, dir )
ParticleManager:ReleaseParticleIndex(particle)
end 

function modifier_sandking_caustic_finale_custom_attack:OnDestroy()
if not IsServer() then return end 
if not self:GetParent():IsAlive() or self:GetParent():IsNull() then return end

local target = self:GetParent()
local mod = self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_sandking_caustic_finale_custom_no_attack", {duration = FrameTime()})

self:GetCaster():PerformAttack(self:GetParent(), true, true, true, true, false, false, false)
if mod and not mod:IsNull() then 
	mod:Destroy()
end 

local hit_effect = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_quad_tap_hit.vpcf", PATTACH_CUSTOMORIGIN, target)
ParticleManager:SetParticleControlEnt(hit_effect, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), false) 
ParticleManager:SetParticleControlEnt(hit_effect, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), false) 
ParticleManager:ReleaseParticleIndex(hit_effect)
end 


modifier_sandking_caustic_finale_custom_no_attack = class({})
function modifier_sandking_caustic_finale_custom_no_attack:IsHidden() return true end
function modifier_sandking_caustic_finale_custom_no_attack:IsPurgable() return false end



modifier_sandking_caustic_finale_custom_perma = class({})
function modifier_sandking_caustic_finale_custom_perma:IsHidden() return not self:GetParent():HasModifier("modifier_sand_king_finale_4") end
function modifier_sandking_caustic_finale_custom_perma:IsPurgable() return false end
function modifier_sandking_caustic_finale_custom_perma:RemoveOnDeath() return false end
function modifier_sandking_caustic_finale_custom_perma:GetTexture() return "buffs/finale_damage" end
function modifier_sandking_caustic_finale_custom_perma:OnCreated()

self.max = self:GetCaster():GetTalentValue("modifier_sand_king_finale_4", "max", true)

if not IsServer() then return end 

self:SetStackCount(1)
self:StartIntervalThink(0.5)
end

function modifier_sandking_caustic_finale_custom_perma:OnRefresh()
if not IsServer() then return end 
if self:GetStackCount() >= self.max then return end 

self:IncrementStackCount()
end 

function modifier_sandking_caustic_finale_custom_perma:OnIntervalThink()
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_sand_king_finale_4") then return end 

if self:GetStackCount() >= self.max then 

	self:GetParent():EmitSound("BS.Thirst_legendary_active")
	local particle_peffect = ParticleManager:CreateParticle("particles/mars_revenge_proc.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	ParticleManager:SetParticleControl(particle_peffect, 0, self:GetCaster():GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_peffect, 2, self:GetCaster():GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(particle_peffect)
	self:StartIntervalThink(-1)
end

end 


function modifier_sandking_caustic_finale_custom_perma:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOOLTIP,
}
end 




function modifier_sandking_caustic_finale_custom_perma:OnTooltip()
return self:GetStackCount()
end





modifier_sandking_caustic_finale_custom_attack_slow = class({})
function modifier_sandking_caustic_finale_custom_attack_slow:IsHidden() return true end
function modifier_sandking_caustic_finale_custom_attack_slow:IsPurgable() return true end
function modifier_sandking_caustic_finale_custom_attack_slow:OnCreated()

self.slow = self:GetCaster():GetTalentValue("modifier_sand_king_finale_3", "slow")
end

function modifier_sandking_caustic_finale_custom_attack_slow:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
end

function modifier_sandking_caustic_finale_custom_attack_slow:GetModifierAttackSpeedBonus_Constant()
return self.slow
end






modifier_sandking_caustic_finale_custom_lowhp = class({})

function modifier_sandking_caustic_finale_custom_lowhp:IsHidden()
if self:GetParent():GetHealthPercent() <= self:GetCaster():GetTalentValue("modifier_sand_king_finale_5", "health") then 
  return false 
else 
  return true
end

end

function modifier_sandking_caustic_finale_custom_lowhp:GetTexture() return "buffs/finale_lowhp" end
function modifier_sandking_caustic_finale_custom_lowhp:IsPurgable() return false end
function modifier_sandking_caustic_finale_custom_lowhp:RemoveOnDeath() return false end

function modifier_sandking_caustic_finale_custom_lowhp:OnCreated(table)

self.health = self:GetCaster():GetTalentValue("modifier_sand_king_finale_5", "health", true)
self.bva = self:GetCaster():GetTalentValue("modifier_sand_king_finale_5", "bva", true)

if not IsServer() then return end
self:StartIntervalThink(0.2)
self:SetStackCount(1)
end

function modifier_sandking_caustic_finale_custom_lowhp:OnIntervalThink()
if not IsServer() then return end

if self:GetStackCount() == 1 then 


  if self:GetParent():GetHealthPercent() <= self.health then 

		self:GetParent():EmitSound("Lc.Moment_Lowhp")
		self:SetStackCount(0)
		self.particle = ParticleManager:CreateParticle( "particles/lc_lowhp.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControl( self.particle, 0, self:GetParent():GetAbsOrigin() )
		ParticleManager:SetParticleControl( self.particle, 1, self:GetParent():GetAbsOrigin() )
		ParticleManager:SetParticleControl( self.particle, 2, self:GetParent():GetAbsOrigin() )

  end
end

if self:GetStackCount() == 0 then
  if self:GetParent():GetHealthPercent() > self.health then
    self:SetStackCount(1)
    ParticleManager:DestroyParticle(self.particle, false)
    ParticleManager:ReleaseParticleIndex(self.particle)
  end
end

end


function modifier_sandking_caustic_finale_custom_lowhp:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT
}
end


function modifier_sandking_caustic_finale_custom_lowhp:GetModifierBaseAttackTimeConstant()
if self:GetStackCount() == 1 then return end 
return self.bva
end



modifier_sandking_caustic_finale_custom_pull_cd = class({})
function modifier_sandking_caustic_finale_custom_pull_cd:IsHidden() return true end
function modifier_sandking_caustic_finale_custom_pull_cd:IsPurgable() return false end