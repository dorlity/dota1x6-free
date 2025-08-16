LinkLuaModifier( "modifier_ogre_magi_bloodlust_custom_buff", "abilities/ogre_magi/ogre_magi_bloodlust", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ogre_magi_bloodlust_custom_tracker", "abilities/ogre_magi/ogre_magi_bloodlust", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ogre_magi_bloodlust_custom_legendary_1", "abilities/ogre_magi/ogre_magi_bloodlust", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ogre_magi_bloodlust_custom_legendary_2", "abilities/ogre_magi/ogre_magi_bloodlust", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ogre_magi_bloodlust_custom_legendary_3", "abilities/ogre_magi/ogre_magi_bloodlust", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ogre_magi_bloodlust_custom_legendary_4", "abilities/ogre_magi/ogre_magi_bloodlust", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ogre_magi_bloodlust_custom_legendary_slow", "abilities/ogre_magi/ogre_magi_bloodlust", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ogre_magi_bloodlust_custom_incoming", "abilities/ogre_magi/ogre_magi_bloodlust", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ogre_magi_bloodlust_custom_quest", "abilities/ogre_magi/ogre_magi_bloodlust", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ogre_magi_bloodlust_custom_charge", "abilities/ogre_magi/ogre_magi_bloodlust", LUA_MODIFIER_MOTION_HORIZONTAL )
LinkLuaModifier( "modifier_ogre_magi_bloodlust_custom_str", "abilities/ogre_magi/ogre_magi_bloodlust", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ogre_magi_bloodlust_custom_damage", "abilities/ogre_magi/ogre_magi_bloodlust", LUA_MODIFIER_MOTION_NONE )

ogre_magi_bloodlust_custom = class({})


ogre_magi_bloodlust_custom.legendary_buffs = 
{
	["modifier_ogre_magi_bloodlust_custom_legendary_1"] = "particles/general/patrol_refresh.vpcf",
	["modifier_ogre_magi_bloodlust_custom_legendary_2"] = "particles/rare_orb_patrol.vpcf",
	["modifier_ogre_magi_bloodlust_custom_legendary_3"] = "particles/lc_odd_proc_.vpcf",
	["modifier_ogre_magi_bloodlust_custom_legendary_4"] = "particles/arc_warden/tempest_rune_arcane.vpcf",
}


function ogre_magi_bloodlust_custom:GetIntrinsicModifierName()
return "modifier_ogre_magi_bloodlust_custom_tracker"
end

function ogre_magi_bloodlust_custom:GetAbilityTextureName()
if self:GetCaster():HasModifier("modifier_ogre_magi_immortal_weapon_custom") then
    return "ogre_magi_bloodlust_ti8"
end
if self:GetCaster():HasModifier("modifier_ogre_magi_arcana_custom") then
    return "ogre_magi/arcana/ogre_magi_bloodlust_arcana"
end
if self:GetCaster():HasModifier("modifier_ogre_magi_arcana_custom_2") then
    return "ogre_magi/arcana/ogre_magi_bloodlust_arcana_alt2"
end
return "ogre_magi_bloodlust"
end

function ogre_magi_bloodlust_custom:CreateTalent()

CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetCaster():GetPlayerOwnerID()), "ability_ogre_bloodlust",  {})
end


function ogre_magi_bloodlust_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end
PrecacheResource( "particle","particles/units/heroes/hero_ogre_magi/ogre_magi_bloodlust_cast.vpcf", context )
PrecacheResource( "particle","particles/units/heroes/hero_sven/sven_spell_great_cleave.vpcf", context )
PrecacheResource( "particle","particles/units/heroes/hero_ogre_magi/ogre_magi_bloodlust_buff.vpcf", context )
PrecacheResource( "particle","particles/orge_lightning.vpcf", context )
PrecacheResource( "particle","particles/generic_gameplay/rune_arcane_owner.vpcf", context )
PrecacheResource( "particle","particles/ogre_dd.vpcf", context )
PrecacheResource( "particle","particles/units/heroes/hero_sniper/sniper_headshot_slow.vpcf", context )
PrecacheResource( "particle","particles/units/heroes/hero_pangolier/pangolier_tailthump_buff.vpcf", context )
PrecacheResource( "particle","particles/units/heroes/hero_pangolier/pangolier_tailthump_buff_egg.vpcf", context )
PrecacheResource( "particle","particles/units/heroes/hero_pangolier/pangolier_tailthump_buff_streaks.vpcf", context )
PrecacheResource( "particle","particles/units/heroes/hero_primal_beast/primal_beast_onslaught_impact.vpcf", context )
PrecacheResource( "particle","particles/ogre_magi/blood_charge.vpcf", context )
PrecacheResource( "particle","particles/econ/items/invoker/invoker_ti7/status_effect_alacrity_ti7.vpcf", context )

PrecacheResource( "particle","particles/general/patrol_refresh.vpcf", context )
PrecacheResource( "particle","particles/rare_orb_patrol.vpcf", context )
PrecacheResource( "particle","particles/lc_odd_proc_.vpcf", context )
PrecacheResource( "particle","particles/arc_warden/tempest_rune_arcane.vpcf", context )
PrecacheResource( "particle","particles/ogre_magi/blood_resist.vpcf", context )
end



function ogre_magi_bloodlust_custom:GetBehavior()
local bonus = 0
local base = DOTA_ABILITY_BEHAVIOR_NO_TARGET
if not IsSoloMode() then 
  base = DOTA_ABILITY_BEHAVIOR_UNIT_TARGET
end
if self:GetCaster():HasTalent("modifier_ogremagi_bloodlust_5") then
	bonus = DOTA_ABILITY_BEHAVIOR_IGNORE_PSEUDO_QUEUE + DOTA_ABILITY_BEHAVIOR_IMMEDIATE
end
return base + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK + bonus
end



function ogre_magi_bloodlust_custom:GetManaCost(level)
if self:GetCaster():HasTalent("modifier_ogremagi_bloodlust_5") then  
  return 0
end
return self.BaseClass.GetManaCost(self,level) 
end




function ogre_magi_bloodlust_custom:LegendaryProc()
if not IsServer() then return end
local caster = self:GetCaster()
local buff_table = {}
local mod = caster:FindModifierByName("modifier_ogre_magi_bloodlust_custom_buff")

if not mod then return end

for name,particle in pairs(self.legendary_buffs) do
	if not caster:HasModifier(name) then 
		buff_table[#buff_table + 1] = name
	end
end

if #buff_table == 0 then 
 	return
end

local name = buff_table[RandomInt(1, #buff_table)]

local particle_peffect = ParticleManager:CreateParticle(self.legendary_buffs[name], PATTACH_ABSORIGIN_FOLLOW, caster)
ParticleManager:SetParticleControl(particle_peffect, 0, caster:GetAbsOrigin())
ParticleManager:SetParticleControl(particle_peffect, 2, caster:GetAbsOrigin())
ParticleManager:ReleaseParticleIndex(particle_peffect)

caster:EmitSound("Ogre.Blood_legendary")
caster:AddNewModifier(caster, self, name, {duration = mod:GetRemainingTime() + FrameTime()})
end




function ogre_magi_bloodlust_custom:OnSpellStart(new_target)
local caster = self:GetCaster()
local target = caster
if self:GetCursorTarget() then
	target = self:GetCursorTarget()
end
if new_target then
	target = new_target
end

local duration = self:GetSpecialValueFor( "duration" )

local slark_mod = caster:FindModifierByName("modifier_slark_essence_shift_custom_legendary_steal")
if slark_mod then
	duration = slark_mod:GetRemainingTime()
end

if caster:HasTalent("modifier_ogremagi_bloodlust_5") then 
	target:AddNewModifier(caster, self, "modifier_ogre_magi_bloodlust_custom_incoming", {duration = caster:GetTalentValue("modifier_ogremagi_bloodlust_5", "duration")})
end

local mod = target:FindModifierByName("modifier_ogre_magi_bloodlust_custom_buff")

if mod then 
	mod:AddStack()
else 
	mod = target:AddNewModifier( caster, self, "modifier_ogre_magi_bloodlust_custom_buff", { duration = duration } )

	if slark_mod then
		local effect_cast = ParticleManager:CreateParticle(  "particles/units/heroes/hero_ogre_magi/ogre_magi_multicast.vpcf", PATTACH_OVERHEAD_FOLLOW, caster )
		ParticleManager:SetParticleControl( effect_cast, 1, Vector( 2, 0, 0 ) )
		ParticleManager:ReleaseParticleIndex( effect_cast )
		caster:EmitSound("Hero_OgreMagi.Fireblast.x2")
		mod:AddStack()
	end
end	

local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_ogre_magi/ogre_magi_bloodlust_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
ParticleManager:SetParticleControlEnt( particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", Vector(0,0,0), true)
ParticleManager:SetParticleControlEnt( particle, 2, caster, PATTACH_POINT_FOLLOW, "attach_attack1", Vector(0,0,0), true )
ParticleManager:SetParticleControlEnt( particle, 3, target, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true )
ParticleManager:ReleaseParticleIndex( particle )

caster:EmitSound("Hero_OgreMagi.Bloodlust.Cast")
end






modifier_ogre_magi_bloodlust_custom_buff = class({})

function modifier_ogre_magi_bloodlust_custom_buff:IsPurgable() return false end
function modifier_ogre_magi_bloodlust_custom_buff:OnCreated( kv )

self.parent = self:GetParent()
self.caster = self:GetCaster()
self.ability = self:GetAbility()

self.model_scale = self.ability:GetSpecialValueFor( "modelscale" )
self.move_bonus = self.ability:GetSpecialValueFor( "bonus_movement_speed" ) + self.caster:GetTalentValue("modifier_ogremagi_bloodlust_1", "move")
self.speed_bonus = self.ability:GetSpecialValueFor( "self_bonus" )

self.max = self.ability:GetSpecialValueFor("max")

self.stack_bonus = self.ability:GetSpecialValueFor("stack_bonus")/100

self.armor = self.caster:GetTalentValue("modifier_ogremagi_bloodlust_3", "armor")
self.magic = self.caster:GetTalentValue("modifier_ogremagi_bloodlust_3", "magic")

self.RemoveForDuel = true

if not IsServer() then return end

local particle_name = "particles/units/heroes/hero_ogre_magi/ogre_magi_bloodlust_buff.vpcf"
if self.caster:HasModifier("modifier_ogre_magi_immortal_weapon_custom") then
    particle_name = "particles/econ/items/ogre_magi/ogre_ti8_immortal_weapon/ogre_ti8_immortal_bloodlust_buff.vpcf"
end

local particle = ParticleManager:CreateParticle(particle_name, PATTACH_ABSORIGIN_FOLLOW, self.parent)
self:AddParticle(particle, false, false, -1, true, false)


self.legendary_count = 0

self.ability:SetActivated(false)

if self.caster:HasTalent("modifier_ogremagi_bloodlust_6") and not self.ability:IsHidden() then 
	self.caster:SwapAbilities(self.ability:GetName(), "ogre_magi_bloodlust_custom_charge", false, true)
end 

if self.parent:HasTalent("modifier_ogremagi_bloodlust_7") then 
	self.ability:LegendaryProc()
end

self:AddStack()
end

function modifier_ogre_magi_bloodlust_custom_buff:OnRefresh( kv )
self:AddStack()
end



function modifier_ogre_magi_bloodlust_custom_buff:AddStack()
if not IsServer() then return end 
if self:GetStackCount() >= self.max then return end
self:IncrementStackCount()

self.parent:EmitSound("Hero_OgreMagi.Bloodlust.Target")
EmitSoundOnClient( "Hero_OgreMagi.Bloodlust.Target.FP", self.parent:GetPlayerOwner() )
end




function modifier_ogre_magi_bloodlust_custom_buff:OnDestroy()
if not IsServer() then return end 
self.ability:SetActivated(true)

if self.caster:HasTalent("modifier_ogremagi_bloodlust_6") and self.ability:IsHidden() then 
	self.caster:SwapAbilities(self.ability:GetName(), "ogre_magi_bloodlust_custom_charge", true, false)
end 

self.parent:RemoveModifierByName("modifier_ogre_magi_bloodlust_custom_str")
end

function modifier_ogre_magi_bloodlust_custom_buff:DeclareFunctions()
return 
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	MODIFIER_PROPERTY_MODEL_SCALE,
	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
}
end

function modifier_ogre_magi_bloodlust_custom_buff:GetModifierAttackSpeedBonus_Constant()
return self.speed_bonus + self.speed_bonus*self.stack_bonus*(self:GetStackCount() - 1)
end

function modifier_ogre_magi_bloodlust_custom_buff:GetModifierMoveSpeedBonus_Percentage()
return self.move_bonus + self.move_bonus*self.stack_bonus*(self:GetStackCount() - 1)
end

function modifier_ogre_magi_bloodlust_custom_buff:GetModifierPhysicalArmorBonus()
if not self.caster:HasTalent("modifier_ogremagi_bloodlust_3") then return end
return self.armor*self:GetStackCount()
end

function modifier_ogre_magi_bloodlust_custom_buff:GetModifierMagicalResistanceBonus()
if not self.caster:HasTalent("modifier_ogremagi_bloodlust_3") then return end
return self.magic*self:GetStackCount()
end

function modifier_ogre_magi_bloodlust_custom_buff:GetModifierModelScale()
return self.model_scale
end





modifier_ogre_magi_bloodlust_custom_tracker = class({})
function modifier_ogre_magi_bloodlust_custom_tracker:IsHidden() return true end
function modifier_ogre_magi_bloodlust_custom_tracker:IsPurgable() return false end


function modifier_ogre_magi_bloodlust_custom_tracker:OnCreated()
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.legendary_chance = self.parent:GetTalentValue("modifier_ogremagi_bloodlust_7", "chance", true)
self.legendary_radius = self.parent:GetTalentValue("modifier_ogremagi_bloodlust_7", "radius", true)
self.legendary_slow = self.parent:GetTalentValue("modifier_ogremagi_bloodlust_7", "duration", true)
self.legendary_damage = self.parent:GetTalentValue("modifier_ogremagi_bloodlust_7", "damage", true)/100
self.legendary_attacks = self.parent:GetTalentValue("modifier_ogremagi_bloodlust_7", "attacks", true)
self.legendary_heal = self.parent:GetTalentValue("modifier_ogremagi_bloodlust_7", "heal", true)/100


self.damage_duration = self.parent:GetTalentValue("modifier_ogremagi_bloodlust_2", "duration", true)

self.cleave = self.ability:GetSpecialValueFor("cleave_damage")/100
self.parent:AddAttackEvent_out(self)
end


function modifier_ogre_magi_bloodlust_custom_tracker:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
}
end


function modifier_ogre_magi_bloodlust_custom_tracker:GetModifierAttackRangeBonus()
if not self.parent:HasTalent("modifier_ogremagi_bloodlust_1") then return end 
return self.parent:GetTalentValue("modifier_ogremagi_bloodlust_1", "range")
end


function modifier_ogre_magi_bloodlust_custom_tracker:AttackEvent_out(params)
if not IsServer() then return end
if self.parent ~= params.attacker then return end
if not params.target:IsUnit() then return end

local mod = self.parent:FindModifierByName("modifier_ogre_magi_bloodlust_custom_buff") 
if mod then 
	params.target:EmitSound("Hero_Sven.GreatCleave")
	DoCleaveAttack( self.parent, params.target, self.ability, self.cleave*params.damage, 150, 360, 500, "particles/units/heroes/hero_sven/sven_spell_great_cleave.vpcf" )

	if self.parent:HasTalent("modifier_ogremagi_bloodlust_7") then 
		mod.legendary_count = mod.legendary_count + 1 
		if mod.legendary_count >= self.legendary_attacks then 
			mod.legendary_count = 0
			self.ability:LegendaryProc()
		end 
	end 
end


if self.parent:HasModifier("modifier_ogre_magi_bloodlust_custom_legendary_1") then 
	self.parent:GenericHeal(self.parent:GetMaxHealth()*self.legendary_heal, self.ability, true, nil, "modifier_ogremagi_bloodlust_7")
end

if self.parent:GetQuest() == "Ogre.Quest_7" and not self.parent:QuestCompleted() and params.target:IsRealHero() then 
	params.target:AddNewModifier(self.parent, self.ability, "modifier_ogre_magi_bloodlust_custom_quest", {duration = 1})
end


if self.parent:HasTalent("modifier_ogremagi_bloodlust_2") then 
	self.parent:AddNewModifier(self.parent, self.ability, "modifier_ogre_magi_bloodlust_custom_damage", {duration = self.damage_duration})
end 

if self.parent:HasModifier("modifier_ogre_magi_bloodlust_custom_legendary_2") and RollPseudoRandomPercentage(self.legendary_chance, 548, self.parent) then 

	self.parent:EmitSound("Item.Maelstrom.Chain_Lightning.Jump")

	local damage = self.legendary_damage*self.parent:GetAverageTrueAttackDamage(nil)
	local damage_table = {attacker = self.parent, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self.ability}

	for _,unit in pairs(self.parent:FindTargets(self.legendary_radius, params.target:GetAbsOrigin())) do

		damage_table.victim = unit
		local real_damage = DoDamage(damage_table, "modifier_ogremagi_bloodlust_7")
		unit:SendNumber(4, real_damage)

		local source = self.parent
		if unit ~= params.target then 
			source = params.target
		end
		unit:EmitSound("Item.Maelstrom.Chain_Lightning")

		local particle = ParticleManager:CreateParticle( "particles/orge_lightning.vpcf", PATTACH_POINT_FOLLOW, unit )
		ParticleManager:SetParticleControlEnt( particle, 0, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true )
		ParticleManager:SetParticleControlEnt( particle, 1, source, PATTACH_POINT_FOLLOW, "attach_hitloc", source:GetAbsOrigin(), true )
		ParticleManager:ReleaseParticleIndex( particle )

		unit:AddNewModifier(self.parent, self.ability, "modifier_ogre_magi_bloodlust_custom_legendary_slow", {duration = (1 - unit:GetStatusResistance())*self.legendary_slow})
	end
end

end




modifier_ogre_magi_bloodlust_custom_legendary_1 = class({})
function modifier_ogre_magi_bloodlust_custom_legendary_1:IsHidden() return true end
function modifier_ogre_magi_bloodlust_custom_legendary_1:IsPurgable() return false end


function modifier_ogre_magi_bloodlust_custom_legendary_1:OnCreated(table)
self.RemoveForDuel = true 
self.PercentStr = self:GetParent():GetTalentValue("modifier_ogremagi_bloodlust_7", "str")/100
end






modifier_ogre_magi_bloodlust_custom_legendary_2 = class({})
function modifier_ogre_magi_bloodlust_custom_legendary_2:IsHidden() return true end
function modifier_ogre_magi_bloodlust_custom_legendary_2:IsPurgable() return false end
function modifier_ogre_magi_bloodlust_custom_legendary_2:GetEffectName()
return "particles/ogre_dd.vpcf"
end


function modifier_ogre_magi_bloodlust_custom_legendary_2:OnCreated(table)
self.caster = self:GetCaster()
self.RemoveForDuel = true 
end






modifier_ogre_magi_bloodlust_custom_legendary_3 = class({})
function modifier_ogre_magi_bloodlust_custom_legendary_3:IsHidden() return true end
function modifier_ogre_magi_bloodlust_custom_legendary_3:IsPurgable() return false end

function modifier_ogre_magi_bloodlust_custom_legendary_3:OnCreated(table)
self.status = self:GetCaster():GetTalentValue("modifier_ogremagi_bloodlust_7", "status")
self.RemoveForDuel = true 
end

function modifier_ogre_magi_bloodlust_custom_legendary_3:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
}
end

function modifier_ogre_magi_bloodlust_custom_legendary_3:GetModifierStatusResistanceStacking()
return self.status
end

function modifier_ogre_magi_bloodlust_custom_legendary_3:CheckState()
return
{
	[MODIFIER_STATE_UNSLOWABLE] = true
}
end

function modifier_ogre_magi_bloodlust_custom_legendary_3:GetEffectName()
return "particles/ogre_magi/blood_resist.vpcf"
end





modifier_ogre_magi_bloodlust_custom_legendary_4 = class({})
function modifier_ogre_magi_bloodlust_custom_legendary_4:IsHidden() return true end
function modifier_ogre_magi_bloodlust_custom_legendary_4:IsPurgable() return false end
function modifier_ogre_magi_bloodlust_custom_legendary_4:GetEffectName()
return "particles/generic_gameplay/rune_arcane_owner.vpcf"
end

function modifier_ogre_magi_bloodlust_custom_legendary_4:OnCreated(table)
self.RemoveForDuel = true 
self.caster = self:GetCaster()

self.cdr = self.caster:GetTalentValue("modifier_ogremagi_bloodlust_7", "cdr")
self.cast = self.caster:GetTalentValue("modifier_ogremagi_bloodlust_7", "cast")
end

function modifier_ogre_magi_bloodlust_custom_legendary_4:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_CASTTIME_PERCENTAGE,
	MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE
}
end

function modifier_ogre_magi_bloodlust_custom_legendary_4:GetModifierPercentageCasttime()
return self.cast
end

function modifier_ogre_magi_bloodlust_custom_legendary_4:GetModifierPercentageCooldown() 
return self.cdr
end
   





modifier_ogre_magi_bloodlust_custom_legendary_slow = class({})
function modifier_ogre_magi_bloodlust_custom_legendary_slow:IsHidden() return true end
function modifier_ogre_magi_bloodlust_custom_legendary_slow:IsPurgable() return true end
function modifier_ogre_magi_bloodlust_custom_legendary_slow:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
}
end

function modifier_ogre_magi_bloodlust_custom_legendary_slow:OnCreated()
self.slow = self:GetCaster():GetTalentValue("modifier_ogremagi_bloodlust_7", "slow")
end

function modifier_ogre_magi_bloodlust_custom_legendary_slow:GetModifierMoveSpeedBonus_Percentage()
return self.slow
end

function modifier_ogre_magi_bloodlust_custom_legendary_slow:GetEffectName()
return "particles/units/heroes/hero_sniper/sniper_headshot_slow.vpcf"
end

function modifier_ogre_magi_bloodlust_custom_legendary_slow:GetEffectAttachType()
return PATTACH_OVERHEAD_FOLLOW
end














modifier_ogre_magi_bloodlust_custom_incoming = class({})
function modifier_ogre_magi_bloodlust_custom_incoming:IsHidden() return false end
function modifier_ogre_magi_bloodlust_custom_incoming:IsPurgable() return false end
function modifier_ogre_magi_bloodlust_custom_incoming:GetTexture() return "buffs/chemical_incoming" end
function modifier_ogre_magi_bloodlust_custom_incoming:OnCreated(table)
self.parent = self:GetParent()
self.caster = self:GetCaster()
self.damage_reduce = self.caster:GetTalentValue("modifier_ogremagi_bloodlust_5", "damage_reduce")

if not IsServer() then return end 
self.buff_particles = {}

self.buff_particles[1] = ParticleManager:CreateParticle("particles/units/heroes/hero_pangolier/pangolier_tailthump_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
ParticleManager:SetParticleControlEnt(self.buff_particles[1], 1, self.parent, PATTACH_ABSORIGIN_FOLLOW, nil, Vector(0,0,0), false) 
self:AddParticle(self.buff_particles[1], false, false, -1, true, false)
ParticleManager:SetParticleControl( self.buff_particles[1], 3, Vector( 255, 255, 255 ) )

self.buff_particles[2] = ParticleManager:CreateParticle("particles/units/heroes/hero_pangolier/pangolier_tailthump_buff_egg.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
ParticleManager:SetParticleControlEnt(self.buff_particles[2], 1, self.parent, PATTACH_ABSORIGIN_FOLLOW, nil, Vector(0,0,0), false) 
self:AddParticle(self.buff_particles[2], false, false, -1, true, false)

self.buff_particles[3] = ParticleManager:CreateParticle("particles/units/heroes/hero_pangolier/pangolier_tailthump_buff_streaks.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
ParticleManager:SetParticleControlEnt(self.buff_particles[3], 1, self.parent, PATTACH_ABSORIGIN_FOLLOW, nil, Vector(0,0,0), false) 
self:AddParticle(self.buff_particles[3], false, false, -1, true, false)
end



function modifier_ogre_magi_bloodlust_custom_incoming:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
}
end

function modifier_ogre_magi_bloodlust_custom_incoming:GetModifierIncomingDamage_Percentage()
return self.damage_reduce
end






ogre_magi_bloodlust_custom_charge = class({})


function ogre_magi_bloodlust_custom_charge:GetCastRange(vLocation, hTarget)
return self:GetCaster():GetTalentValue("modifier_ogremagi_bloodlust_6", "range")
end

function ogre_magi_bloodlust_custom_charge:OnSpellStart()
local caster = self:GetCaster()
local ability = caster:FindAbilityByName("ogre_magi_bloodlust_custom")


if ability and ability:IsHidden() then 
	caster:SwapAbilities(self:GetName(), ability:GetName(), false, true)
end 

caster:AddNewModifier(caster, self, "modifier_ogre_magi_bloodlust_custom_charge", {duration = caster:GetTalentValue("modifier_ogremagi_bloodlust_6", "duration")})
end





modifier_ogre_magi_bloodlust_custom_charge = class({})
function modifier_ogre_magi_bloodlust_custom_charge:IsHidden() return true end
function modifier_ogre_magi_bloodlust_custom_charge:IsPurgable() return false end

function modifier_ogre_magi_bloodlust_custom_charge:OnCreated()
if not IsServer() then return end

self.caster = self:GetCaster()
self.ability = self:GetAbility()
self.caster:StartGesture(ACT_DOTA_FLAIL)

self.angle = self.caster:GetForwardVector():Normalized()
self.distance = self.caster:GetTalentValue("modifier_ogremagi_bloodlust_6", "range") / ( self:GetDuration() / FrameTime())
self.radius = self.caster:GetTalentValue("modifier_ogremagi_bloodlust_6", "radius")
self.stun = self.caster:GetTalentValue("modifier_ogremagi_bloodlust_6", "stun")

self.bkb = self.caster:AddNewModifier(self.caster, self.ability, "modifier_generic_debuff_immune", {})

self.targets = {}


self.caster:EmitSound("Ogre.Blood_charge")
self.caster:EmitSound("Ogre.Blood_charge2")
--self.caster:EmitSound("Ogre.Blood_charge_vo")

if self:ApplyHorizontalMotionController() == false then
    self:Destroy()
end

end

function modifier_ogre_magi_bloodlust_custom_charge:DeclareFunctions()
return
{
 	MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
    MODIFIER_PROPERTY_DISABLE_TURNING
}
end

function modifier_ogre_magi_bloodlust_custom_charge:GetActivityTranslationModifiers()
  return "forcestaff_friendly"
end


function modifier_ogre_magi_bloodlust_custom_charge:GetModifierDisableTurning() return 1 end


function modifier_ogre_magi_bloodlust_custom_charge:OnDestroy()
if not IsServer() then return end
self.caster:InterruptMotionControllers( true )

if self.bkb and not self.bkb:IsNull() then 
	self.bkb:Destroy()
end

self.caster:FadeGesture(ACT_DOTA_FLAIL)
self.caster:StartGesture(ACT_DOTA_FORCESTAFF_END)

ResolveNPCPositions(self.caster:GetAbsOrigin(), 128)

local dir = self.caster:GetForwardVector()
dir.z = 0
self.caster:SetForwardVector(dir)
self.caster:FaceTowards(self.caster:GetAbsOrigin() + dir*10)

end


function modifier_ogre_magi_bloodlust_custom_charge:UpdateHorizontalMotion( me, dt )
if not IsServer() then return end
local pos = self.caster:GetAbsOrigin()
local pos_p = self.angle * self.distance
local next_pos = GetGroundPosition(pos + pos_p,self.caster)
self.caster:SetAbsOrigin(next_pos)

GridNav:DestroyTreesAroundPoint(pos, 120, false)

for _,enemy in pairs(self.caster:FindTargets(self.radius)) do 
	if not self.targets[enemy] then 
		self.targets[enemy] = true
		enemy:AddNewModifier(self.caster, self.ability, "modifier_stunned", {duration = (1 - enemy:GetStatusResistance())*self.stun})

		local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_primal_beast/primal_beast_onslaught_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy )
		ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, self.radius, self.radius ) )
		ParticleManager:ReleaseParticleIndex( effect_cast )
		enemy:EmitSound("Ogre.Blood_hit")


		if not (enemy:IsCurrentlyHorizontalMotionControlled() or enemy:IsCurrentlyVerticalMotionControlled()) then
			local direction = enemy:GetOrigin()-self:GetCaster():GetOrigin()
			direction.z = 0
			direction = direction:Normalized()

			local knockbackProperties =
			{
			  center_x = self.caster:GetOrigin().x,
			  center_y = self.caster:GetOrigin().y,
			  center_z = self.caster:GetOrigin().z,
			  duration = 0.2,
			  knockback_duration = 0.2,
			  knockback_distance = 80,
			  knockback_height = 50
			}
			enemy:AddNewModifier( self.caster, self.ability, "modifier_knockback", knockbackProperties )
		end

	end
end

end

function modifier_ogre_magi_bloodlust_custom_charge:OnHorizontalMotionInterrupted()
self:Destroy()
end



function modifier_ogre_magi_bloodlust_custom_charge:CheckState()
return
{
	[MODIFIER_STATE_DISARMED] = true,
	[MODIFIER_STATE_SILENCED] = true
}
end

function modifier_ogre_magi_bloodlust_custom_charge:GetEffectName()
	return "particles/ogre_magi/blood_charge.vpcf"
end

function modifier_ogre_magi_bloodlust_custom_charge:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end


function modifier_ogre_magi_bloodlust_custom_charge:GetStatusEffectName()
return "particles/econ/items/invoker/invoker_ti7/status_effect_alacrity_ti7.vpcf"
end

function modifier_ogre_magi_bloodlust_custom_charge:StatusEffectPriority()
return MODIFIER_PRIORITY_HIGH 
end









modifier_ogre_magi_bloodlust_custom_quest = class({})
function modifier_ogre_magi_bloodlust_custom_quest:IsHidden() return true end
function modifier_ogre_magi_bloodlust_custom_quest:IsPurgable() return false end
function modifier_ogre_magi_bloodlust_custom_quest:OnCreated(table)
if not IsServer() then return end

self:SetStackCount(1)
end

function modifier_ogre_magi_bloodlust_custom_quest:OnRefresh(table)
if not IsServer() then return end
if not self:GetCaster():GetQuest() then return end

self:IncrementStackCount()

if self:GetStackCount() >= self:GetCaster().quest.number then 
	self:GetCaster():UpdateQuest(1)
	self:Destroy()
end

end



modifier_ogre_magi_bloodlust_custom_str = class({})
function modifier_ogre_magi_bloodlust_custom_str:IsHidden() return false end
function modifier_ogre_magi_bloodlust_custom_str:IsPurgable() return false end
function modifier_ogre_magi_bloodlust_custom_str:GetTexture() return "buffs/bloodlust_str" end
function modifier_ogre_magi_bloodlust_custom_str:OnCreated()
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.max = self.parent:GetTalentValue("modifier_ogremagi_bloodlust_4", "max")
self.str = self.parent:GetTalentValue("modifier_ogremagi_bloodlust_4", "str")
self.speed = self.parent:GetTalentValue("modifier_ogremagi_bloodlust_4", "speed")
self.model = 2

if not IsServer() then return end 
self:SetStackCount(1)
self.parent:CalculateStatBonus(true)
end

function modifier_ogre_magi_bloodlust_custom_str:OnRefresh()
if not IsServer() then return end 
if self:GetStackCount() >= self.max then return end 

self:IncrementStackCount()
self.parent:CalculateStatBonus(true)
end


function modifier_ogre_magi_bloodlust_custom_str:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	MODIFIER_PROPERTY_MODEL_SCALE
}
end


function modifier_ogre_magi_bloodlust_custom_str:GetModifierAttackSpeedBonus_Constant()
return self.speed*self:GetStackCount()
end

function modifier_ogre_magi_bloodlust_custom_str:GetModifierBonusStats_Strength()
return self.str*self:GetStackCount()
end
function modifier_ogre_magi_bloodlust_custom_str:GetModifierModelScale()
return self.model*self:GetStackCount()
end





modifier_ogre_magi_bloodlust_custom_damage = class({})
function modifier_ogre_magi_bloodlust_custom_damage:IsHidden() return false end
function modifier_ogre_magi_bloodlust_custom_damage:IsPurgable() return false end
function modifier_ogre_magi_bloodlust_custom_damage:GetTexture() return "buffs/bloodlust_damage" end
function modifier_ogre_magi_bloodlust_custom_damage:OnCreated()
self.parent = self:GetParent()
self.damage = self.parent:GetTalentValue("modifier_ogremagi_bloodlust_2", "attack")
self.spells = self.parent:GetTalentValue("modifier_ogremagi_bloodlust_2", "spells")
self.max = self.parent:GetTalentValue("modifier_ogremagi_bloodlust_2", "max")

if not IsServer() then return end 
self:SetStackCount(1)
end

function modifier_ogre_magi_bloodlust_custom_damage:OnRefresh()
if not IsServer() then return end 
if self:GetStackCount() >= self.max then return end 

self:IncrementStackCount()
end


function modifier_ogre_magi_bloodlust_custom_damage:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE
}
end


function modifier_ogre_magi_bloodlust_custom_damage:GetModifierSpellAmplify_Percentage()
return self:GetStackCount()*self.spells
end

function modifier_ogre_magi_bloodlust_custom_damage:GetModifierPreAttack_BonusDamage()
return self:GetStackCount()*self.damage
end




