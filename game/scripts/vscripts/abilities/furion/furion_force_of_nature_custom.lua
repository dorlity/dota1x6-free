LinkLuaModifier("modifier_furion_force_of_nature_custom", "abilities/furion/furion_force_of_nature_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_furion_force_of_nature_custom_tracker", "abilities/furion/furion_force_of_nature_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_furion_force_of_nature_custom_legendary", "abilities/furion/furion_force_of_nature_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_furion_force_of_nature_custom_legendary_active", "abilities/furion/furion_force_of_nature_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_furion_force_of_nature_custom_root", "abilities/furion/furion_force_of_nature_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_furion_force_of_nature_custom_root_cd", "abilities/furion/furion_force_of_nature_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_furion_force_of_nature_custom_root_treant", "abilities/furion/furion_force_of_nature_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_furion_force_of_nature_custom_fear_speed", "abilities/furion/furion_force_of_nature_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_furion_force_of_nature_custom_stats", "abilities/furion/furion_force_of_nature_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_furion_force_of_nature_custom_armor", "abilities/furion/furion_force_of_nature_custom", LUA_MODIFIER_MOTION_NONE)

furion_force_of_nature_custom = class({})
		

furion_force_of_nature_custom.treants = {}




function furion_force_of_nature_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end


PrecacheResource( "particle", "particles/units/heroes/hero_furion/furion_force_of_nature_cast.vpcf", context )
PrecacheResource( "particle", "particles/nature_prophet/call_legendary_cast.vpcf", context )
PrecacheResource( "particle", "particles/nature_prophet/call_legendary_body.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_centaur/centaur_return_buff.vpcf", context )
PrecacheResource( "particle", "particles/nature_prophet/call_legendary_link.vpcf", context )
PrecacheResource( "particle", "particles/nature_prophet/call_legendary_hands.vpcf", context )
PrecacheResource( "particle", "particles/nature_prophet/call_legendary_overhead.vpcf", context )
PrecacheResource( "particle", "particles/status_fx/status_effect_doom.vpcf", context )
PrecacheResource( "particle", "particles/nature_prophet/call_root.vpcf", context )
PrecacheResource( "particle", "particles/general/patrol_refresh.vpcf", context )
PrecacheResource( "particle", "particles/general/generic_armor_reduction.vpcf", context )


end






function furion_force_of_nature_custom:GetIntrinsicModifierName()
return "modifier_furion_force_of_nature_custom_tracker"
end

function furion_force_of_nature_custom:GetAOERadius()
return self:GetSpecialValueFor("area_of_effect")
end


function furion_force_of_nature_custom:GetCooldown(iLevel)
local bonus = 0

if self:GetCaster():HasTalent("modifier_furion_call_5") then 
	bonus = self:GetCaster():GetTalentValue("modifier_furion_call_5", "cd")
end 

return self.BaseClass.GetCooldown(self, iLevel) + bonus
end



function furion_force_of_nature_custom:OnAbilityPhaseStart()
if self:GetCaster():HasTalent("modifier_furion_call_5") then return true end

if #GridNav:GetAllTreesAroundPoint( self:GetCursorPosition(), self:GetSpecialValueFor("area_of_effect"), false ) > 0 then 
	return true
else 
	self:GetCaster():SendError("#no_trees")
	return false
end

end



function furion_force_of_nature_custom:SpawnTreant(point, duration, not_controlled)

local health = self:GetSpecialValueFor("treant_health")
local damage_min = self:GetSpecialValueFor("treant_damage_min")
local damage_max = self:GetSpecialValueFor("treant_damage_max")
local armor = self:GetSpecialValueFor("base_armor")
local magic = self:GetSpecialValueFor("magic_resistance")

local mod = self:GetCaster():FindModifierByName("modifier_furion_force_of_nature_custom_stats")

if mod and self:GetCaster():HasTalent("modifier_furion_call_1") then 

	local max = self:GetCaster():GetTalentValue("modifier_furion_call_1", "max")

	health = health + mod:GetStackCount()*self:GetCaster():GetTalentValue("modifier_furion_call_1", "health")/max
	damage_min = damage_min + mod:GetStackCount()*self:GetCaster():GetTalentValue("modifier_furion_call_1", "damage")/max
	damage_max = damage_max + mod:GetStackCount()*self:GetCaster():GetTalentValue("modifier_furion_call_1", "damage")/max
end 

local treant = CreateUnitByName("npc_dota_furion_treant_custom", point, true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber())
treant:AddNewModifier(self:GetCaster(), self, "modifier_kill", { duration = duration })
treant.owner = self:GetCaster()
treant.is_treant = treant

treant:AddNewModifier(self:GetCaster(), self, "modifier_furion_force_of_nature_custom", {})

if not not_controlled then 
	treant:SetControllableByPlayer(self:GetCaster():GetPlayerID(), true)
end
treant:SetOwner(self:GetCaster())
treant:SetBaseMaxHealth(health)
treant:SetMaxHealth(health)
treant:SetHealth(health)
treant:SetBaseDamageMin(damage_min)
treant:SetBaseDamageMax(damage_max)
treant:SetPhysicalArmorBaseValue(armor)
treant:SetBaseMagicalResistanceValue(magic)
treant:SetAngles(0, 0, 0)
treant:SetForwardVector(self:GetCaster():GetForwardVector())
FindClearSpaceForUnit(treant, treant:GetAbsOrigin(), true)

return treant
end



function furion_force_of_nature_custom:OnSpellStart()

local point = self:GetCursorPosition()
local radius = self:GetSpecialValueFor("area_of_effect")
local max = self:GetSpecialValueFor("max_treants")
local duration = self:GetSpecialValueFor("treant_duration")


if self:GetCaster():HasTalent("modifier_furion_call_7") then 
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_furion_force_of_nature_custom_legendary", {duration = self:GetCooldownTimeRemaining()})
end 

if not self:GetCaster():HasTalent("modifier_furion_call_5") then 
	GridNav:DestroyTreesAroundPoint(point, radius*0.8, true)
else 
	local fear_duration = self:GetCaster():GetTalentValue("modifier_furion_call_5", "fear")

	for _,target in pairs(self:GetCaster():FindTargets(radius, point)) do 
	  target:EmitSound("BS.Rupture_fear")
	  target:AddNewModifier(self:GetCaster(), self, "modifier_nevermore_requiem_fear", {duration = fear_duration * (1 - target:GetStatusResistance())})
	  target:AddNewModifier(self:GetCaster(), self, "modifier_furion_force_of_nature_custom_fear_speed", {duration  = fear_duration * (1 - target:GetStatusResistance())})
	end 
end 

local particle1 = ParticleManager:CreateParticle( "particles/units/heroes/hero_furion/furion_force_of_nature_cast.vpcf", PATTACH_WORLDORIGIN, nil )
ParticleManager:SetParticleControl( particle1, 0, self:GetCaster():GetAbsOrigin() + self:GetCaster():GetForwardVector()*50 )
ParticleManager:SetParticleControl( particle1, 1, point )
ParticleManager:SetParticleControl( particle1, 2, Vector(radius,0,0) )

EmitSoundOnLocationWithCaster( point, "Hero_Furion.ForceOfNature", self:GetCaster() )

for i,treant in pairs(self.treants) do 
	if not treant:IsNull() then 
		treant:AddNewModifier(treant, nil, "modifier_death", {})
		treant:Kill(nil, nil)
	end

	self.treants[i] = nil
end 

for i = 1,max do 
	local treant = self:SpawnTreant(point, duration)

	table.insert(self.treants, treant)
end


end





modifier_furion_force_of_nature_custom = class({})
function modifier_furion_force_of_nature_custom:IsHidden() return true end
function modifier_furion_force_of_nature_custom:IsPurgable() return false end
function modifier_furion_force_of_nature_custom:OnCreated(table)

self.parent = self:GetParent()
self.caster = self:GetCaster()
self.bva = self.caster:GetTalentValue("modifier_furion_call_6", "bva", true)
end 

function modifier_furion_force_of_nature_custom:OnDestroy()
if not IsServer() then return end
self.parent:EmitSound("Hero_Furion.TreantDeath")
end 



function modifier_furion_force_of_nature_custom:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
}
end


function modifier_furion_force_of_nature_custom:GetModifierBaseAttackTimeConstant()
if not self.caster:HasTalent("modifier_furion_call_6") then return end
return self.bva
end



function modifier_furion_force_of_nature_custom:CheckState()
if not self.caster:HasTalent("modifier_furion_call_6") then return end
return 
{
	[MODIFIER_STATE_DEBUFF_IMMUNE] = true
}
end







modifier_furion_force_of_nature_custom_tracker = class({})
function modifier_furion_force_of_nature_custom_tracker:IsHidden() return true end
function modifier_furion_force_of_nature_custom_tracker:IsPurgable() return false end
function modifier_furion_force_of_nature_custom_tracker:GetTexture() return "buffs/call_damage_reduce" end
function modifier_furion_force_of_nature_custom_tracker:OnCreated()
self.parent = self:GetParent()
self.parent:AddDeathEvent(self)

self.ability = self:GetAbility()

self.parent:AddAttackEvent_out(self)

self.root_treant = self:GetCaster():GetTalentValue("modifier_furion_call_4", "duration", true)
self.root_duration = self:GetCaster():GetTalentValue("modifier_furion_call_4", "root", true)
self.root_cd = self:GetCaster():GetTalentValue("modifier_furion_call_4", "cd", true)

self.heal = self:GetCaster():GetTalentValue("modifier_furion_call_6", "heal", true)/100
self.heal_health = self:GetCaster():GetTalentValue("modifier_furion_call_6", "health", true)
self.heal_bonus = self:GetCaster():GetTalentValue("modifier_furion_call_6", "bonus", true)

self.armor_duration = self:GetCaster():GetTalentValue("modifier_furion_call_2", "duration", true)
if not IsServer() then return end

self:StartIntervalThink(1)
end 




function modifier_furion_force_of_nature_custom_tracker:AttackEvent_out(params)
if not IsServer() then return end 
if not params.target:IsUnit() then return end 

if (params.attacker.owner and params.attacker.owner == self.parent and params.attacker.is_treant) or self.parent == params.attacker then 

	if self.parent:HasTalent("modifier_furion_call_2") then 
		params.target:AddNewModifier(self.parent, self.ability, "modifier_furion_force_of_nature_custom_armor", {duration = self.armor_duration})
	end 

	if self.parent:HasTalent("modifier_furion_call_6") and self.parent:IsAlive() and params.attacker.is_treant then 

		local heal = self.parent:GetMaxHealth()*self.heal
		if self.parent:GetHealthPercent() <= self.heal_health then 
			heal = heal*self.heal_bonus
		end 

		self.parent:GenericHeal(heal, self.ability, true, nil, "modifier_furion_call_6")

	end
end


if self.parent ~= params.attacker then return end

if self.parent:HasModifier("modifier_furion_innate_custom") and self.parent:HasTalent("modifier_furion_call_3") then 
	self.parent:FindModifierByName("modifier_furion_innate_custom"):HealTreants()
end


local mod = self.parent:FindModifierByName("modifier_furion_force_of_nature_custom_legendary")

if mod and mod.max_stack and mod:GetStackCount() < mod.max_stack then 
	mod:IncrementStackCount()
end

if not self.parent:HasTalent("modifier_furion_call_4") then return end 
if self.parent:HasModifier("modifier_furion_force_of_nature_custom_root_cd") then return end

if not RollPseudoRandomPercentage(self:GetCaster():GetTalentValue("modifier_furion_call_4", "chance"),1983,self.parent) then return end

params.target:EmitSound("Furion.Call_root")
params.target:EmitSound("Furion.Call_root2")
params.target:AddNewModifier(self.parent, self.ability, "modifier_furion_force_of_nature_custom_root", {duration = (1 - params.target:GetStatusResistance())*self.root_duration})
self.parent:AddNewModifier(self.parent, self.ability, "modifier_furion_force_of_nature_custom_root_cd", {duration = self.root_cd})

local treant = self:GetAbility():SpawnTreant(params.target:GetAbsOrigin() + RandomVector(150), self.root_treant, true)

treant:AddNewModifier(self.parent, self.ability, "modifier_furion_force_of_nature_custom_root_treant", {target = params.target:entindex()})

end



function modifier_furion_force_of_nature_custom_tracker:DeathEvent(params)
if not IsServer() then return end
if not params.attacker then return end

local attacker = params.attacker

if attacker.owner then 
	attacker = attacker.owner
end 

if attacker ~= self.parent then return end 
if not params.unit:IsCreep() then return end 

self.parent:AddNewModifier(self.parent, self.ability, "modifier_furion_force_of_nature_custom_stats", {})
end 











modifier_furion_force_of_nature_custom_legendary = class({})
function modifier_furion_force_of_nature_custom_legendary:IsHidden() return true end
function modifier_furion_force_of_nature_custom_legendary:IsPurgable() return false end
function modifier_furion_force_of_nature_custom_legendary:OnCreated()
if not IsServer() then return end 

self.ability = self:GetCaster():FindAbilityByName("furion_force_of_nature_custom")
self.legendary = self:GetCaster():FindAbilityByName("furion_force_of_nature_custom_legendary")

if not self.ability or not self.legendary then 
	self:Destroy()
	return
end

if not self.ability:IsHidden() then 
	self:GetParent():SwapAbilities(self.ability:GetName(), self.legendary:GetName(), false, true)
end 

self.time = self:GetRemainingTime()
self.parent = self:GetParent()

self:SetStackCount(0)
self.max_stack = self:GetCaster():GetTalentValue("modifier_furion_call_7", "max")


self:OnIntervalThink()
self:StartIntervalThink(FrameTime())
end 


function modifier_furion_force_of_nature_custom_legendary:OnIntervalThink()
if not IsServer() then return end
if self.parent:HasModifier("modifier_furion_force_of_nature_custom_legendary_active") then return end

self.parent:UpdateUIlong({active = 0, max = self.time, stack = self:GetRemainingTime(), override_stack = tostring(self:GetStackCount()).." / "..tostring(self.max_stack), style = "FurionCall"})
end



function modifier_furion_force_of_nature_custom_legendary:OnDestroy()
if not IsServer() then return end

if not self.parent:HasModifier("modifier_furion_force_of_nature_custom_legendary_active") then 
	self.parent:UpdateUIlong({hide = 1, style = "FurionCall"})
end 

if not self.ability or not self.legendary then return end

if self.ability:IsHidden() then 
	self:GetParent():SwapAbilities(self.ability:GetName(), self.legendary:GetName(), true, false)
end 

end












furion_force_of_nature_custom_legendary = class({})



function furion_force_of_nature_custom_legendary:OnSpellStart()

local mod = self:GetCaster():FindModifierByName("modifier_furion_force_of_nature_custom_legendary")

local caster = self:GetCaster()

local pfx = ParticleManager:CreateParticle("particles/nature_prophet/call_legendary_cast.vpcf", PATTACH_ABSORIGIN, caster)
ParticleManager:ReleaseParticleIndex(pfx)

if not mod then return end 

self:GetCaster():EmitSound("Furion.Call_legendary_cast")
self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_furion_force_of_nature_custom_legendary_active", {duration = self:GetCaster():GetTalentValue("modifier_furion_call_7", "duration"), stack = mod:GetStackCount()})

mod:Destroy()
end









modifier_furion_force_of_nature_custom_legendary_active = class({})
function modifier_furion_force_of_nature_custom_legendary_active:IsHidden() return false end
function modifier_furion_force_of_nature_custom_legendary_active:IsPurgable() return false end
function modifier_furion_force_of_nature_custom_legendary_active:OnCreated(table)

self.parent = self:GetParent()
self.caster = self:GetCaster()

self.radius = 2000
self.max = self:GetCaster():GetTalentValue("modifier_furion_call_7", "max")
self.speed = self:GetCaster():GetTalentValue("modifier_furion_call_7", "speed")/self.max
self.move = self:GetCaster():GetTalentValue("modifier_furion_call_7", "move")/self.max
self.damage_reduce = self:GetCaster():GetTalentValue("modifier_furion_call_7", "damage_reduce")/self.max
self.self_k = self:GetCaster():GetTalentValue("modifier_furion_call_7", "self_k")

if self.caster == self.parent then 
	self.speed = self.speed/self.self_k 
	self.move = self.move/self.self_k
	self.damage_reduce = self.damage_reduce/self.self_k
end 

if not IsServer() then return end

self.effect = ParticleManager:CreateParticle( "particles/nature_prophet/call_legendary_body.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self.parent )
ParticleManager:SetParticleControlEnt(self.effect, 0, self.parent, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", Vector(0,0,0), true)
ParticleManager:SetParticleControlEnt(self.effect, 1, self.parent, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", Vector(0,0,0), true)
self:AddParticle(self.effect,false, false, -1, false, false)

self:GetParent():EmitSound("Furion.Call_legendary_buff")
self:GetParent():EmitSound("Furion.Call_legendary_buff2")

if self.caster == self.parent then 

	self.effect = ParticleManager:CreateParticle( "particles/units/heroes/hero_centaur/centaur_return_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	self:AddParticle(self.effect,false, false, -1, false, false)

	self:SetStackCount(table.stack)
else 
	local mod = self.caster:FindModifierByName(self:GetName())

	local pfx = ParticleManager:CreateParticle("particles/nature_prophet/call_legendary_link.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self.parent)
	ParticleManager:SetParticleControlEnt(pfx, 0, self.caster, PATTACH_POINT_FOLLOW, "attach_hitloc", self.caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(pfx, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(pfx)


	self.effect = ParticleManager:CreateParticle( "particles/nature_prophet/call_legendary_hands.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	self:AddParticle(self.effect,false, false, -1, false, false)

	if mod then 
		self:SetStackCount(mod:GetStackCount())
	end 
end

self.time = self:GetRemainingTime()

if self.parent ~= self.caster then return end

self:OnIntervalThink()
self:StartIntervalThink(FrameTime())
end 


function modifier_furion_force_of_nature_custom_legendary_active:OnIntervalThink()
if not IsServer() then return end

self.parent:UpdateUIlong({active = 1, max = self.time, stack = self:GetRemainingTime(), override_stack = self:GetStackCount(), style = "FurionCall"})
end


function modifier_furion_force_of_nature_custom_legendary_active:OnDestroy()
if not IsServer() then return end

self.parent:StopSound("Furion.Call_legendary_buff2")

if self.parent ~= self.caster then return end

self.parent:UpdateUIlong({active = 1, hide = 1, style = "FurionCall"})
end


function modifier_furion_force_of_nature_custom_legendary_active:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	MODIFIER_PROPERTY_MODEL_SCALE
}
end

function modifier_furion_force_of_nature_custom_legendary_active:CheckState()
if self.parent.is_shard_treant then return end
return
{
	[MODIFIER_STATE_NO_UNIT_COLLISION] = true
}
end

function modifier_furion_force_of_nature_custom_legendary_active:GetModifierAttackSpeedBonus_Constant()
return self.speed*self:GetStackCount()
end

function modifier_furion_force_of_nature_custom_legendary_active:GetModifierMoveSpeedBonus_Percentage()
return self.move*self:GetStackCount()
end

function modifier_furion_force_of_nature_custom_legendary_active:GetModifierIncomingDamage_Percentage()
return self.damage_reduce*self:GetStackCount()
end

function modifier_furion_force_of_nature_custom_legendary_active:GetModifierModelScale()
if self.caster == self.parent then return end
if self:GetStackCount() < self.max then return end
return 30
end



function modifier_furion_force_of_nature_custom_legendary_active:GetEffectName() return "particles/nature_prophet/call_legendary_overhead.vpcf" end
function modifier_furion_force_of_nature_custom_legendary_active:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end

function modifier_furion_force_of_nature_custom_legendary_active:GetStatusEffectName() return "particles/status_fx/status_effect_doom.vpcf" end
function modifier_furion_force_of_nature_custom_legendary_active:StatusEffectPriority() return MODIFIER_PRIORITY_ULTRA  end

function modifier_furion_force_of_nature_custom_legendary_active:IsAura() return self.caster == self.parent end
function modifier_furion_force_of_nature_custom_legendary_active:GetAuraDuration() return 0.1 end
function modifier_furion_force_of_nature_custom_legendary_active:GetAuraRadius() return self.radius end
function modifier_furion_force_of_nature_custom_legendary_active:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_furion_force_of_nature_custom_legendary_active:GetAuraSearchType() return DOTA_UNIT_TARGET_BASIC end
function modifier_furion_force_of_nature_custom_legendary_active:GetModifierAura() return self:GetName() end
function modifier_furion_force_of_nature_custom_legendary_active:GetAuraEntityReject(hEntity)
return not hEntity.is_treant
end







modifier_furion_force_of_nature_custom_root = class({})
function modifier_furion_force_of_nature_custom_root:IsHidden() return true end
function modifier_furion_force_of_nature_custom_root:IsPurgable() return true end
function modifier_furion_force_of_nature_custom_root:CheckState()
return
{
	[MODIFIER_STATE_ROOTED] = true,
	[MODIFIER_STATE_DISARMED] = true,
}
end

function modifier_furion_force_of_nature_custom_root:OnCreated()
if not IsServer() then return end 

local nfx = ParticleManager:CreateParticle("particles/nature_prophet/call_root.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self:GetParent()) 
ParticleManager:SetParticleControlEnt(nfx, 0, self:GetParent(), PATTACH_ABSORIGIN, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(nfx, 1, self:GetParent(), PATTACH_ABSORIGIN, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
self:AddParticle(nfx,false, false, -1, false, false)

end



modifier_furion_force_of_nature_custom_root_cd = class({})
function modifier_furion_force_of_nature_custom_root_cd:IsHidden() return false end
function modifier_furion_force_of_nature_custom_root_cd:IsPurgable() return false end
function modifier_furion_force_of_nature_custom_root_cd:GetTexture() return "buffs/call_root" end
function modifier_furion_force_of_nature_custom_root_cd:IsDebuff() return true end



modifier_furion_force_of_nature_custom_root_treant = class({})
function modifier_furion_force_of_nature_custom_root_treant:IsHidden() return true end
function modifier_furion_force_of_nature_custom_root_treant:IsPurgable() return false end
function modifier_furion_force_of_nature_custom_root_treant:OnCreated(table)
if not IsServer() then return end 
self.target = nil
self.parent = self:GetParent()
self.radius = 1000
self.vec = RandomVector(200)

if table.target then 
	self:SetTarget(EntIndexToHScript(table.target))
end


self:OnIntervalThink()
self:StartIntervalThink(0.1)
end


function modifier_furion_force_of_nature_custom_root_treant:IsValidTarget(target)
if not IsServer() then return end 

if not target or target:IsNull() or not target:IsAlive() or 
 ((target:GetAbsOrigin() - self.parent:GetAbsOrigin()):Length2D() > self.radius) or (not target:IsHero() and not target:IsCreep())
or target:IsCourier() or target:GetUnitName() == "npc_teleport" or target:HasModifier("modifier_monkey_king_wukongs_command_custom_soldier") then 
	return false 
end

return true
end 


function modifier_furion_force_of_nature_custom_root_treant:SetTarget(target)
if not IsServer() then return end
if not self:IsValidTarget(target) then return end
if self.target == target then return end


self.target = target
self.parent:MoveToPositionAggressive(self.target:GetAbsOrigin())
self.parent:SetForceAttackTarget(self.target)
end 



function modifier_furion_force_of_nature_custom_root_treant:MoveToCaster()
if not IsServer() then return end

self.target = nil
self.parent:SetForceAttackTarget(nil)

local point = self:GetCaster():GetAbsOrigin() + self.vec

if (point - self.parent:GetAbsOrigin()):Length2D() > 50 then 
	self.parent:MoveToPosition(self:GetCaster():GetAbsOrigin() + self.vec)
end

end




function modifier_furion_force_of_nature_custom_root_treant:OnIntervalThink()
if not IsServer() then return end


if self.parent:GetAggroTarget() then
    self.target = self.parent:GetAggroTarget()
end


if self:IsValidTarget(self.target) then
    self:SetTarget(self.target)
    return
else 

	local enemies = FindUnitsInRadius( self.parent:GetTeamNumber(), self.parent:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )

	for _,enemy in pairs(enemies) do
		if self:IsValidTarget(enemy) then 
			self:SetTarget(enemy)
        	break
		end
	end
end 

if not self:IsValidTarget(self.target) then 
	self:MoveToCaster()
end


end






modifier_furion_force_of_nature_custom_fear_speed = class({})
function modifier_furion_force_of_nature_custom_fear_speed:IsHidden() return true end
function modifier_furion_force_of_nature_custom_fear_speed:IsPurgable() return false end
function modifier_furion_force_of_nature_custom_fear_speed:OnCreated()
self.speed = self:GetCaster():GetTalentValue("modifier_furion_call_5", "speed")
end

function modifier_furion_force_of_nature_custom_fear_speed:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MAX,
}
end

function modifier_furion_force_of_nature_custom_fear_speed:GetModifierMoveSpeed_AbsoluteMax()
return self.speed
end



modifier_furion_force_of_nature_custom_stats = class({})
function modifier_furion_force_of_nature_custom_stats:IsHidden() return not self:GetCaster():HasTalent("modifier_furion_call_1") or self:GetStackCount() == self.max end
function modifier_furion_force_of_nature_custom_stats:IsPurgable() return false end
function modifier_furion_force_of_nature_custom_stats:RemoveOnDeath() return false end
function modifier_furion_force_of_nature_custom_stats:GetTexture() return "buffs/call_stats" end
function modifier_furion_force_of_nature_custom_stats:OnCreated()
self.max = self:GetCaster():GetTalentValue("modifier_furion_call_1", "max", true)
self.caster = self:GetCaster()
if not IsServer() then return end 

self:SetStackCount(1)
self:StartIntervalThink(0.5)
end





function modifier_furion_force_of_nature_custom_stats:OnIntervalThink()
if not IsServer() then return end 
if not self:GetCaster():HasTalent("modifier_furion_call_1") then return end 
if self:GetStackCount() < self.max then return end 


local particle_peffect = ParticleManager:CreateParticle("particles/general/patrol_refresh.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
ParticleManager:SetParticleControl(particle_peffect, 0, self:GetCaster():GetAbsOrigin())
ParticleManager:SetParticleControl(particle_peffect, 2, self:GetCaster():GetAbsOrigin())
ParticleManager:ReleaseParticleIndex(particle_peffect)

self:GetCaster():EmitSound("BS.Thirst_legendary_active")

self:StartIntervalThink(-1)
end 


function modifier_furion_force_of_nature_custom_stats:OnRefresh(table)
if not IsServer() then return end 
if self:GetStackCount() >= self.max then return end 

self:IncrementStackCount()
end 


function modifier_furion_force_of_nature_custom_stats:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOOLTIP,
	MODIFIER_PROPERTY_TOOLTIP2
}
end


function modifier_furion_force_of_nature_custom_stats:OnTooltip()
if not self.caster then return end
if not self.caster:HasTalent("modifier_furion_call_1") then return end 

return self:GetStackCount()*self.caster:GetTalentValue("modifier_furion_call_1", "damage")/self.max
end

function modifier_furion_force_of_nature_custom_stats:OnTooltip2()
if not self.caster then return end
if not self.caster:HasTalent("modifier_furion_call_1") then return end 

return self:GetStackCount()*self.caster:GetTalentValue("modifier_furion_call_1", "health")/self.max
end




modifier_furion_force_of_nature_custom_armor = class({})
function modifier_furion_force_of_nature_custom_armor:IsHidden() return false end
function modifier_furion_force_of_nature_custom_armor:IsPurgable() return false end
function modifier_furion_force_of_nature_custom_armor:GetTexture() return "buffs/call_armor" end
function modifier_furion_force_of_nature_custom_armor:OnCreated()
self.max = self:GetCaster():GetTalentValue("modifier_furion_call_2", "max", true)
self.armor = self:GetCaster():GetTalentValue("modifier_furion_call_2", "armor")/self.max
self.slow = self:GetCaster():GetTalentValue("modifier_furion_call_2", "slow")/self.max

if not IsServer() then return end 
self:SetStackCount(1)
end 

function modifier_furion_force_of_nature_custom_armor:OnRefresh()
if not IsServer() then return end 
if self:GetStackCount() >= self.max then return end 

self:IncrementStackCount()

if self:GetStackCount() >= self.max then 

	self:GetParent():EmitSound("Phantom_Assassin.Armor") 
	self.particle_peffect = ParticleManager:CreateParticle("particles/general/generic_armor_reduction.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())	
	ParticleManager:SetParticleControl(self.particle_peffect, 0, self:GetParent():GetAbsOrigin())
	self:AddParticle(self.particle_peffect, false, false, -1, false, true)
end 

end


function modifier_furion_force_of_nature_custom_armor:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
}
end


function modifier_furion_force_of_nature_custom_armor:GetModifierPhysicalArmorBonus()
return self:GetStackCount()*self.armor
end


function modifier_furion_force_of_nature_custom_armor:GetModifierMoveSpeedBonus_Percentage()
return self:GetStackCount()*self.slow
end