LinkLuaModifier("modifier_sandking_epicenter_custom", "abilities/sand_king/sandking_epicenter_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_sandking_epicenter_custom_slow", "abilities/sand_king/sandking_epicenter_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_sandking_epicenter_custom_tracker", "abilities/sand_king/sandking_epicenter_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_sandking_epicenter_custom_legendary", "abilities/sand_king/sandking_epicenter_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_sandking_epicenter_custom_auto_cd", "abilities/sand_king/sandking_epicenter_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_sandking_epicenter_custom_heal_reduce", "abilities/sand_king/sandking_epicenter_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_sandking_epicenter_custom_heal", "abilities/sand_king/sandking_epicenter_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_sandking_epicenter_custom_absorb", "abilities/sand_king/sandking_epicenter_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_sandking_epicenter_custom_absorb_cd", "abilities/sand_king/sandking_epicenter_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_sandking_epicenter_custom_speed", "abilities/sand_king/sandking_epicenter_custom", LUA_MODIFIER_MOTION_NONE)

sandking_epicenter_custom = class({})
		

function sandking_epicenter_custom:Precache(context)
    
PrecacheResource( "particle", "particles/sand_king/sandking_sandstorm_custom.vpcf", context )
end



function sandking_epicenter_custom:GetIntrinsicModifierName()
if self:GetCaster():IsRealHero() then 
	return "modifier_sandking_epicenter_custom_tracker"
end 

end

function sandking_epicenter_custom:GetCastPoint()
local bonus = 0


if self:GetCaster():HasShard() then 
  bonus = self:GetSpecialValueFor("shard_cast")
end

 return self:GetSpecialValueFor("AbilityCastPoint") + bonus
 
end





function sandking_epicenter_custom:GetCooldown(level)
local bonus = 0

if self:GetCaster():HasModifier("modifier_sand_king_epicenter_2") then 
	bonus = self:GetCaster():GetTalentValue("modifier_sand_king_epicenter_2", "cd")
end 

	return self.BaseClass.GetCooldown(self, level)  + bonus
end




function sandking_epicenter_custom:OnAbilityPhaseStart()
local caster = self:GetCaster()
caster:EmitSound("Ability.SandKing_Epicenter.spell")

local k = 1

if caster:HasShard() then 
	k = self:GetSpecialValueFor("AbilityCastPoint") / (self:GetSpecialValueFor("AbilityCastPoint") + self:GetSpecialValueFor("shard_cast"))
end 

caster:StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_4, k)

self.particle_sandblast_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_sandking/sandking_epicenter_tell.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, caster)
ParticleManager:SetParticleControlEnt(self.particle_sandblast_fx, 0, caster, PATTACH_POINT_FOLLOW, "attach_tail", caster:GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(self.particle_sandblast_fx, 1, caster, PATTACH_POINT_FOLLOW, "attach_tail", caster:GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(self.particle_sandblast_fx, 2, caster, PATTACH_POINT_FOLLOW, "attach_tail", caster:GetAbsOrigin(), true)

if caster:HasModifier("modifier_sand_king_epicenter_5") and not caster:HasModifier("modifier_sandking_epicenter_custom_absorb_cd") then 	
	caster:AddNewModifier(caster, self, "modifier_sandking_epicenter_custom_absorb", {})
end 

end 


function sandking_epicenter_custom:OnAbilityPhaseInterrupted()
self:GetCaster():StopSound("Ability.SandKing_Epicenter.spell")

local caster = self:GetCaster()

caster:FadeGesture(ACT_DOTA_CAST_ABILITY_4)
if self.particle_sandblast_fx then 
	ParticleManager:DestroyParticle(self.particle_sandblast_fx, false)
	ParticleManager:ReleaseParticleIndex(self.particle_sandblast_fx)
end 

if caster:HasModifier("modifier_sand_king_epicenter_5") and not caster:HasModifier("modifier_sandking_epicenter_custom_absorb_cd") then 
	caster:AddNewModifier(caster, self, "modifier_sandking_epicenter_custom_absorb_cd", {duration = caster:GetTalentValue("modifier_sand_king_epicenter_5", "cd")})
	caster:RemoveModifierByName("modifier_sandking_epicenter_custom_absorb")
end 

end 


function sandking_epicenter_custom:OnSpellStart()

if self:GetCaster():HasShard() then 
	self:GetCaster():StopSound("Ability.SandKing_Epicenter.spell")
end 

local caster = self:GetCaster()
caster:FadeGesture(ACT_DOTA_CAST_ABILITY_4)

local mod = self:GetCaster():FindModifierByName("modifier_sandking_epicenter_custom_absorb")

if mod then 
	mod:SetDuration(self:GetSpecialValueFor("AbilityDuration"), true)
end 

if self:GetCaster():HasModifier("modifier_sand_king_epicenter_3") then 
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_sandking_epicenter_custom_heal", {duration = self:GetCaster():GetTalentValue("modifier_sand_king_epicenter_3", "duration")})
end 

self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_sandking_epicenter_custom", {})

if self.particle_sandblast_fx then 
	ParticleManager:DestroyParticle(self.particle_sandblast_fx, false)
	ParticleManager:ReleaseParticleIndex(self.particle_sandblast_fx)
end 

self:GetCaster():EmitSound("Ability.SandKing_SandStorm.start")
end 


function sandking_epicenter_custom:Pulse(caster, radius, is_scepter, shard)
if self:GetLevel() < 1 then return end


self.particle_epicenter_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_sandking/sandking_epicenter.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(self.particle_epicenter_fx, 0, GetGroundPosition(caster:GetAbsOrigin(), nil))
ParticleManager:SetParticleControl(self.particle_epicenter_fx, 1, Vector(radius, radius, 1))
ParticleManager:ReleaseParticleIndex(self.particle_epicenter_fx)

local damage = self:GetSpecialValueFor("epicenter_damage")
local duration = self:GetSpecialValueFor("AbilityDuration")
local finale = self:GetCaster():FindAbilityByName("sandking_caustic_finale_custom")

if is_scepter then 
	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "SandKing.Pulse", self:GetCaster())
	duration = self:GetSpecialValueFor("scepter_slow")
end 

self.damage_duration = self:GetCaster():GetTalentValue("modifier_sand_king_epicenter_1", "duration")
self.damage_inc = self:GetCaster():GetTalentValue("modifier_sand_king_epicenter_1", "damage")

local break_duration = self:GetSpecialValueFor("shard_break")

local targets = self:GetCaster():FindTargets(radius)

if #targets > 0 then 

	if self:GetCaster():HasModifier("modifier_sand_king_epicenter_7") then 
		local ability = self:GetCaster():FindAbilityByName("sandking_epicenter_custom_legendary")

		if ability then 
			self:GetCaster():CdAbility(ability, self:GetCaster():GetTalentValue("modifier_sand_king_epicenter_7", "cd_inc"))
		end 
	end 



	if self:GetCaster():HasModifier("modifier_sand_king_epicenter_6")  then 
		self:GetCaster():CdItems(self:GetCaster():GetTalentValue("modifier_sand_king_epicenter_6", "cd"))
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_sandking_epicenter_custom_speed", {duration = self:GetCaster():GetTalentValue("modifier_sand_king_epicenter_6", "duration")})
	end 

end

local scepter_chance = self:GetSpecialValueFor("scepter_chance")

for _,target in pairs(targets) do 

	if self:GetCaster():HasModifier("modifier_sand_king_epicenter_1") then 
		target:AddNewModifier(self:GetCaster(), self, "modifier_sandking_epicenter_custom_heal_reduce", {duration = self.damage_duration})
	end 

	if shard then 
		target:AddNewModifier(self:GetCaster(), self, "modifier_generic_break", {duration = (1 - target:GetStatusResistance())*break_duration})
	end 


	local real_damage = damage
	local mod = target:FindModifierByName("modifier_sandking_epicenter_custom_heal_reduce")

	if mod then 
		real_damage = real_damage + mod:GetStackCount()*self.damage_inc
	end 

	ApplyDamage({victim = target, attacker = self:GetCaster(), ability = self, damage_type = DAMAGE_TYPE_MAGICAL, damage = real_damage})

	if self:GetCaster():HasScepter() and target and not target:IsNull() and finale then 
		if RollPseudoRandomPercentage(scepter_chance, 1923, self:GetCaster()) then 
			finale:DealDamage(target, true)
		end
	end 
	target:AddNewModifier(self:GetCaster(), self, "modifier_sandking_epicenter_custom_slow", {duration = (1 - target:GetStatusResistance())*duration})
end 

end 



modifier_sandking_epicenter_custom = class({})
function modifier_sandking_epicenter_custom:IsHidden() return false end
function modifier_sandking_epicenter_custom:IsPurgable() return false end
function modifier_sandking_epicenter_custom:RemoveOnDeath() return false end

function modifier_sandking_epicenter_custom:OnCreated(table)

self.duration = self:GetAbility():GetSpecialValueFor("AbilityDuration")
self.pulses = self:GetAbility():GetSpecialValueFor("epicenter_pulses") + self:GetCaster():GetTalentValue("modifier_sand_king_epicenter_4", "max")
self.radius_init = self:GetAbility():GetSpecialValueFor("epicenter_radius_base")
self.radius_inc = self:GetAbility():GetSpecialValueFor("epicenter_radius_increment")
self.interval = self.duration/self.pulses

self.caster = self:GetCaster()
self.parent = self:GetParent()

if not IsServer() then return end

if self.parent:HasShard() then 
	self.radius_init = self.radius_init + self:GetAbility():GetSpecialValueFor("shard_radius")
end 

self.ability = self.caster:FindAbilityByName("sandking_epicenter_custom_legendary")

if self.ability then 
	self.ability:SetActivated(false)
end 


self.parent:EmitSound("Ability.SandKing_Epicenter")

self.parent:StartGesture(ACT_DOTA_OVERRIDE_ABILITY_4)

self:StartIntervalThink(self.interval)
end 


function modifier_sandking_epicenter_custom:OnDestroy()
if not IsServer() then return end

if self.ability then 
	self.ability:SetActivated(true)
end 

self.parent:FadeGesture(ACT_DOTA_OVERRIDE_ABILITY_4)
self.parent:StopSound("Ability.SandKing_Epicenter")
end 


function modifier_sandking_epicenter_custom:OnIntervalThink()
if not IsServer() then return end 

self:GetAbility():Pulse(self.parent, self.radius_init + self.radius_inc*self:GetStackCount(), false, self.parent:HasShard() and self:GetStackCount() == 0)

self:IncrementStackCount()

if self:GetStackCount() >= self.pulses then 
	self:Destroy()
	return
end 

end 




modifier_sandking_epicenter_custom_slow = class({})
function modifier_sandking_epicenter_custom_slow:IsHidden() return false end
function modifier_sandking_epicenter_custom_slow:IsPurgable() return true end
function modifier_sandking_epicenter_custom_slow:OnCreated()

self.slow_move = self:GetAbility():GetSpecialValueFor("epicenter_slow")
self.slow_attack = self:GetAbility():GetSpecialValueFor("epicenter_slow_as")
end 

function modifier_sandking_epicenter_custom_slow:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end

function modifier_sandking_epicenter_custom_slow:GetModifierMoveSpeedBonus_Percentage()
return self.slow_move
end


function modifier_sandking_epicenter_custom_slow:GetModifierAttackSpeedBonus_Constant()
return self.slow_attack
end




modifier_sandking_epicenter_custom_tracker = class({})
function modifier_sandking_epicenter_custom_tracker:IsHidden() return true end
function modifier_sandking_epicenter_custom_tracker:IsPurgable() return false end
function modifier_sandking_epicenter_custom_tracker:OnCreated()

self.interval = self:GetCaster():GetTalentValue("modifier_sand_king_epicenter_4", "timer", true)
self.radius = self:GetCaster():GetTalentValue("modifier_sand_king_epicenter_4", "radius", true)
self.parent = self:GetParent()

self.creeps_count = self:GetParent():GetTalentValue("modifier_sand_king_epicenter_7", "damage_cd")
self.cd_inc = self:GetParent():GetTalentValue("modifier_sand_king_epicenter_7", "cd_inc")
self.damage_creeps = self:GetParent():GetTalentValue("modifier_sand_king_epicenter_7", "damage_creeps")/100

self:StartIntervalThink(self.interval)
end 

function modifier_sandking_epicenter_custom_tracker:OnIntervalThink()
if not IsServer() then return end 
if not self.parent:IsAlive() or not self.parent:HasModifier("modifier_sand_king_epicenter_4") then return end 

self.parent:RemoveModifierByName("modifier_sandking_epicenter_custom_auto_cd")
self.parent:AddNewModifier(self.parent, self:GetAbility(), "modifier_sandking_epicenter_custom_auto_cd", {duration = self.interval})

self:GetAbility():Pulse(self.parent, self.radius, true)
self:StartIntervalThink(self.interval)
end 



function modifier_sandking_epicenter_custom_tracker:DeclareFunctions()
return
{
    MODIFIER_EVENT_ON_ABILITY_EXECUTED,
    MODIFIER_PROPERTY_MANACOST_PERCENTAGE
}
end

function modifier_sandking_epicenter_custom_tracker:OnAbilityExecuted( params )
if not IsServer() then return end
if not self.parent:HasModifier("modifier_sand_king_epicenter_4") then return end
if params.unit~=self:GetParent() then return end
if not params.ability then return end
if params.ability:IsToggle() then return end
if UnvalidAbilities[params.ability:GetName()] then return end
if UnvalidItems[params.ability:GetName()] then return end
if params.ability:IsItem() and params.ability:GetCurrentCharges() > 0 then return end

local chance = self.parent:GetTalentValue("modifier_sand_king_epicenter_4", "chance")

if RollPseudoRandomPercentage(chance, 1223, self.parent) then 
	self:OnIntervalThink()
end

end


function modifier_sandking_epicenter_custom_tracker:GetModifierPercentageManacost()
local reduce = 0

if self:GetCaster():HasModifier("modifier_sand_king_epicenter_2") then 
    reduce = self:GetCaster():GetTalentValue("modifier_sand_king_epicenter_2", "mana")
end

return reduce
end






sandking_epicenter_custom_legendary = class({})

sandking_epicenter_custom_legendary.anim = ACT_DOTA_TELEPORT_END


function sandking_epicenter_custom_legendary:GetCooldown(level)
return self:GetCaster():GetTalentValue("modifier_sand_king_epicenter_7", "cd")
end

function sandking_epicenter_custom_legendary:OnAbilityPhaseStart()

self:GetCaster():StartGestureWithPlaybackRate(self.anim, 1.1)

self:GetCaster():EmitSound("SandKing.Epicenter_legendary_pre")
self:GetCaster():EmitSound("SandKing.Epicenter_legendary_pre2")

return true
end

function sandking_epicenter_custom_legendary:OnAbilityPhaseInterrupted()


self:GetCaster():StopSound("SandKing.Epicenter_legendary_pre")
self:GetCaster():StopSound("SandKing.Epicenter_legendary_pre2")

self:GetCaster():FadeGesture(self.anim)
end


function sandking_epicenter_custom_legendary:OnSpellStart()

self:GetCaster():FadeGesture(self.anim)

self:GetCaster():EmitSound("SandKing.Epicenter_legendary_start")

self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_sandking_epicenter_custom_legendary", {duration = self:GetCaster():GetTalentValue("modifier_sand_king_epicenter_7", "duration")})
end


modifier_sandking_epicenter_custom_legendary = class({})
function modifier_sandking_epicenter_custom_legendary:IsHidden() return false end
function modifier_sandking_epicenter_custom_legendary:IsPurgable() return false end

function modifier_sandking_epicenter_custom_legendary:GetEffectName() return "particles/sand_king/epicenter_legendary.vpcf" end
function modifier_sandking_epicenter_custom_legendary:GetStatusEffectName() return "particles/status_fx/status_effect_valkyrie_fire_wreath_magic_immunity.vpcf" end
function modifier_sandking_epicenter_custom_legendary:StatusEffectPriority() return 99999 end

function modifier_sandking_epicenter_custom_legendary:OnCreated()

if not self:GetCaster():HasModifier("modifier_sand_king_epicenter_7") then
	self:Destroy()
	return
end 

self.caster = self:GetCaster()
self.moving = false
self.status = self:GetCaster():GetTalentValue("modifier_sand_king_epicenter_7", "status")
self.pos = self.caster:GetAbsOrigin()
self.max_distance = self:GetCaster():GetTalentValue("modifier_sand_king_epicenter_7", "distance")
self.distance = 0

self.ability = self.caster:FindAbilityByName("sandking_epicenter_custom")

if not self.ability then self:Destroy() return end

self.radius = self:GetAbility():GetSpecialValueFor("radius")

if not IsServer() then return end 

self.ability:SetActivated(false)

self.caster:EmitSound("SandKing.Epicenter_legendary_loop")

self.particle_epicenter_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_sandking/sandking_epicenter.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(self.particle_epicenter_fx, 0, self.caster:GetAbsOrigin())
ParticleManager:SetParticleControl(self.particle_epicenter_fx, 1, Vector(150, 150, 1))
ParticleManager:ReleaseParticleIndex(self.particle_epicenter_fx)

self:OnIntervalThink()
self:StartIntervalThink(0.03)
end 


function modifier_sandking_epicenter_custom_legendary:OnIntervalThink()
if not IsServer() then return end 

local pos = self.caster:GetAbsOrigin()

self.distance = self.distance + (pos - self.pos):Length2D()
if self.distance >= self.max_distance then 
	self.distance = 0
	EmitSoundOnLocationWithCaster(self.caster:GetAbsOrigin(), "SandKing.Pulse", self.caster)
	EmitSoundOnLocationWithCaster(self.caster:GetAbsOrigin(), "SandKing.Epicenter_legendary_pulse", self.caster)
	self.ability:Pulse(self.caster, self.radius)
end 

self.pos = pos

if not self.moving and self:GetCaster():IsMoving() then 
	self.moving = true
	self:GetCaster():StartGesture(ACT_DOTA_OVERRIDE_ABILITY_4)
end 


if self.moving and not self:GetCaster():IsMoving() then 
	self.moving = false
	self:GetCaster():RemoveGesture(ACT_DOTA_OVERRIDE_ABILITY_4)
end 


end 


function modifier_sandking_epicenter_custom_legendary:OnDestroy()
if not IsServer() then return end 

self.ability:SetActivated(true)

self.caster:StopSound("SandKing.Epicenter_legendary_loop")

self:GetCaster():RemoveGesture(ACT_DOTA_OVERRIDE_ABILITY_4)
end 


function modifier_sandking_epicenter_custom_legendary:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
}
end


function modifier_sandking_epicenter_custom_legendary:GetModifierStatusResistanceStacking()
return self.status
end



modifier_sandking_epicenter_custom_auto_cd = class({})
function modifier_sandking_epicenter_custom_auto_cd:IsHidden() return false end
function modifier_sandking_epicenter_custom_auto_cd:IsPurgable() return false end
function modifier_sandking_epicenter_custom_auto_cd:RemoveOnDeath() return false end
function modifier_sandking_epicenter_custom_auto_cd:IsDebuff() return true end
function modifier_sandking_epicenter_custom_auto_cd:GetTexture() return "buffs/epicenter_auto" end







modifier_sandking_epicenter_custom_heal_reduce = class({})
function modifier_sandking_epicenter_custom_heal_reduce:IsHidden() return false end
function modifier_sandking_epicenter_custom_heal_reduce:IsPurgable() return false end
function modifier_sandking_epicenter_custom_heal_reduce:GetTexture() return "buffs/epicenter_damage" end
function modifier_sandking_epicenter_custom_heal_reduce:OnCreated()
self.heal_reduce = self:GetCaster():GetTalentValue("modifier_sand_king_epicenter_1", "heal_reduce")
self.max = self:GetCaster():GetTalentValue("modifier_sand_king_epicenter_1", "max")

if not IsServer() then return end 
self:SetStackCount(1)
end 


function modifier_sandking_epicenter_custom_heal_reduce:OnRefresh(table)
if not IsServer() then return end 
if self:GetStackCount() >= self.max then return end 

self:IncrementStackCount()
end 


function modifier_sandking_epicenter_custom_heal_reduce:DeclareFunctions()
return
{
 	MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
 	MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
	MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE,
}
end


function modifier_sandking_epicenter_custom_heal_reduce:GetModifierLifestealRegenAmplify_Percentage() 
return self.heal_reduce
end

function modifier_sandking_epicenter_custom_heal_reduce:GetModifierHealAmplify_PercentageTarget() 
return self.heal_reduce
end
function modifier_sandking_epicenter_custom_heal_reduce:GetModifierHPRegenAmplify_Percentage() 
return self.heal_reduce
end












modifier_sandking_epicenter_custom_heal = class({})
function modifier_sandking_epicenter_custom_heal:IsHidden() return true end
function modifier_sandking_epicenter_custom_heal:IsPurgable() return false end
function modifier_sandking_epicenter_custom_heal:GetTexture() return "buffs/epicenter_heal" end
function modifier_sandking_epicenter_custom_heal:OnCreated()

self.heal = self:GetCaster():GetTalentValue("modifier_sand_king_epicenter_3", "heal")/100
self.heal_creeps = self:GetCaster():GetTalentValue("modifier_sand_king_epicenter_3", "heal_creeps")
self.max_shield = self:GetCaster():GetMaxHealth()*self:GetCaster():GetTalentValue("modifier_sand_king_epicenter_3", "shield")/100
self:SetStackCount(self.max_shield)

end 

function modifier_sandking_epicenter_custom_heal:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_TAKEDAMAGE,
	MODIFIER_PROPERTY_INCOMING_DAMAGE_CONSTANT,
}
end


function modifier_sandking_epicenter_custom_heal:GetModifierIncomingDamageConstant( params )
if self:GetStackCount() == 0 then return 0 end

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
    return -i
end

end


function modifier_sandking_epicenter_custom_heal:OnTakeDamage(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end
if not params.unit:IsCreep() and not params.unit:IsHero() then return end
if self:GetParent() == params.unit then return end
if bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then return end

local heal = self.heal
if params.unit:IsCreep() then 
  heal = heal / self.heal_creeps
end

heal = heal*params.damage

self:GetParent():GenericHeal(heal, self:GetAbility(), true)

end














modifier_sandking_epicenter_custom_absorb = class({})
function modifier_sandking_epicenter_custom_absorb:IsHidden() return true end
function modifier_sandking_epicenter_custom_absorb:IsPurgable() return false end
function modifier_sandking_epicenter_custom_absorb:OnCreated(table)

self.damage = self:GetCaster():GetTalentValue("modifier_sand_king_epicenter_5", "damage")

if not IsServer() then return end


self.effect = ParticleManager:CreateParticle( "particles/items2_fx/vindicators_axe_armor.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
self:AddParticle(self.effect,false, false, -1, false, false)

self.particle = ParticleManager:CreateParticle("particles/sand_king/linken_active.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControlEnt(self.particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
self:AddParticle(self.particle, false, false, -1, false, false)

self.blocked = false
end



function modifier_sandking_epicenter_custom_absorb:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_ABSORB_SPELL,
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
}
end

function modifier_sandking_epicenter_custom_absorb:GetModifierIncomingDamage_Percentage()
return self.damage
end 


function modifier_sandking_epicenter_custom_absorb:GetAbsorbSpell(params) 
if params.ability:GetCaster():GetTeamNumber() == self:GetParent():GetTeamNumber() then return end
if self.blocked == true then return end 

self.blocked = true

local particle = ParticleManager:CreateParticle("particles/sand_king/linken_activea.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControlEnt(particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
ParticleManager:ReleaseParticleIndex(particle)

if self.particle then 
	ParticleManager:DestroyParticle(self.particle, true)
	ParticleManager:ReleaseParticleIndex(self.particle)
end 

self:GetCaster():EmitSound("DOTA_Item.LinkensSphere.Activate")

--self:Destroy()

return 1 
end




modifier_sandking_epicenter_custom_absorb_cd = class({})
function modifier_sandking_epicenter_custom_absorb_cd:IsHidden() return false end
function modifier_sandking_epicenter_custom_absorb_cd:IsPurgable() return false end
function modifier_sandking_epicenter_custom_absorb_cd:RemoveOnDeath() return false end
function modifier_sandking_epicenter_custom_absorb_cd:IsDebuff() return true end
function modifier_sandking_epicenter_custom_absorb_cd:GetTexture() return "buffs/epicenter_linken" end




modifier_sandking_epicenter_custom_speed = class({})
function modifier_sandking_epicenter_custom_speed:IsHidden() return false end
function modifier_sandking_epicenter_custom_speed:IsPurgable() return false end
function modifier_sandking_epicenter_custom_speed:GetTexture() return "buffs/epicenter_speed" end
function modifier_sandking_epicenter_custom_speed:OnCreated()

self.max = self:GetCaster():GetTalentValue("modifier_sand_king_epicenter_6", "max")
self.speed = self:GetCaster():GetTalentValue("modifier_sand_king_epicenter_6", "speed")
if not IsServer() then return end 

self:SetStackCount(1)
end 

function modifier_sandking_epicenter_custom_speed:OnRefresh()
if not IsServer() then return end 
if self:GetStackCount() >= self.max then return end 

self:IncrementStackCount()

if self:GetStackCount() >= self.max then 

	self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_marci/marci_rebound_allymovespeed.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	self:AddParticle(self.particle, false, false, -1, false, false)
end 

end

function modifier_sandking_epicenter_custom_speed:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end

function modifier_sandking_epicenter_custom_speed:GetModifierMoveSpeedBonus_Percentage()
return self.speed*self:GetStackCount()
end