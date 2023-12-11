LinkLuaModifier( "modifier_antimage_mana_void_custom_legendary", "abilities/antimage/antimage_mana_void_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_antimage_mana_void_custom_slow", "abilities/antimage/antimage_mana_void_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_antimage_mana_void_custom_tracker", "abilities/antimage/antimage_mana_void_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_antimage_mana_void_custom_int", "abilities/antimage/antimage_mana_void_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_antimage_mana_void_custom_aura", "abilities/antimage/antimage_mana_void_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_antimage_mana_void_custom_aura_damage", "abilities/antimage/antimage_mana_void_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_antimage_mana_void_custom_cast_cd", "abilities/antimage/antimage_mana_void_custom", LUA_MODIFIER_MOTION_NONE )

antimage_mana_void_custom = class({})

antimage_mana_void_custom.damage = {0.08, 0.12,0.16}

antimage_mana_void_custom.slow_move = -80
antimage_mana_void_custom.slow_duration = 4

antimage_mana_void_custom.cast_radius = 600
antimage_mana_void_custom.cast_stun = 0.8
antimage_mana_void_custom.cast_heal = 0.15
antimage_mana_void_custom.cast_cd = 8

antimage_mana_void_custom.int_duration = 10
antimage_mana_void_custom.int_max = 8
antimage_mana_void_custom.int_self = {0.05, 0.08}
antimage_mana_void_custom.int_slow = {-2, -3}

antimage_mana_void_custom.burn_radius = 500
antimage_mana_void_custom.burn_interval = 1
antimage_mana_void_custom.burn_mana = {0.02, 0.03, 0.04}



function antimage_mana_void_custom:Precache(context)

PrecacheResource( "particle", 'particles/units/heroes/hero_antimage/antimage_manavoid.vpcf', context )
PrecacheResource( "particle", 'particles/void_astral_slow.vpcf', context )
PrecacheResource( "particle", 'particles/am_void_cd.vpcf', context )
PrecacheResource( "particle", 'particles/am_mana_stack.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_faceless_void/faceless_void_dialatedebuf_2.vpcf', context )
PrecacheResource( "particle", 'particles/am_cast.vpcf', context )
PrecacheResource( "particle", 'particles/am_mana_mark.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_silencer/silencer_last_word_status.vpcf', context )
PrecacheResource( "particle", 'particles/econ/items/antimage/antimage_weapon_basher_ti5/antimage_manavoid_ti_5.vpcf', context )

end




function antimage_mana_void_custom:GetIntrinsicModifierName()
	return "modifier_antimage_mana_void_custom_tracker"
end



function antimage_mana_void_custom:GetAOERadius()
	return self:GetSpecialValueFor( "mana_void_aoe_radius" )
end


function antimage_mana_void_custom:GetCooldown(iLevel)

local bonus = 0

if self:GetCaster():HasModifier("modifier_antimage_void_2") then  
  bonus = self:GetCaster():GetTalentValue("modifier_antimage_void_2", "cd")
end

 return self.BaseClass.GetCooldown(self, iLevel) + bonus
 
end


function antimage_mana_void_custom:GetCastRange(location, target)
local bonus = 0

if self:GetCaster():HasModifier("modifier_antimage_void_2") then 
	bonus = self:GetCaster():GetTalentValue("modifier_antimage_void_2", "range")
end

	return self.BaseClass.GetCastRange(self, location, target) + bonus
end


function antimage_mana_void_custom:OnAbilityPhaseStart( kv )
	self.target = self:GetCursorTarget()
	self.target:EmitSound("Hero_Antimage.ManaVoidCast")
	return true
end

function antimage_mana_void_custom:OnAbilityPhaseInterrupted()
	self.target:StopSound("Hero_Antimage.ManaVoidCast")
end

function antimage_mana_void_custom:OnSpellStart(new_target)
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	if new_target then 
		target = new_target
	end

	if target:TriggerSpellAbsorb( self ) then return end


	if self:GetCaster():HasModifier("modifier_antimage_counter_4") then 
	    local ability = self:GetCaster():FindAbilityByName("antimage_counterspell_custom")
	    if ability then 
	       ability:ProcDamage()
	    end
	end


	local mana_void_damage_per_mana = self:GetSpecialValueFor("mana_void_damage_per_mana")
	local radius = self:GetSpecialValueFor( "mana_void_aoe_radius" )


	if target:IsRealHero() and caster:GetQuest() == "Anti.Quest_8" and target:GetManaPercent() <= caster.quest.number and not caster:QuestCompleted() then 
		caster:UpdateQuest(1)
	end



	local bonus_damage = 0

	if self:GetCaster():HasModifier("modifier_antimage_void_1") then 

	   bonus_damage = self.damage[self:GetCaster():GetUpgradeStack("modifier_antimage_void_1")]*target:GetMaxMana()
	  
	   local k = 1
	   if self:GetCaster():IsIllusion() and self:GetCaster().am_scepter then 
	   		local ability = self:GetCaster():FindAbilityByName("antimage_mana_overload_custom")
	   		k = ability:GetSpecialValueFor("ulti_damage")/100
	   end
	   bonus_damage = bonus_damage * k

	   ApplyDamage({ victim = target, attacker = caster, damage = bonus_damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self, })	
	   SendOverheadEventMessage(target, 4, target, bonus_damage, nil)

	end 

	
	self:DealDamage(target, mana_void_damage_per_mana, radius)


	if target:IsCreep() then 
		self:EndCooldown()
		self:StartCooldown(self:GetSpecialValueFor("creep_cd"))
	end
end



function antimage_mana_void_custom:DealDamage(target, damage, radius)
if not IsServer() then return end

local mana_damage = (target:GetMaxMana() - target:GetMana()) * damage

local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), target:GetOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )

target:EmitSound("Hero_Antimage.ManaVoid")

local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_antimage/antimage_manavoid.vpcf", PATTACH_POINT_FOLLOW, target )
ParticleManager:SetParticleControlEnt( particle, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true )
ParticleManager:SetParticleControl( particle, 1, Vector( radius, 0, 0 ) )
ParticleManager:ReleaseParticleIndex( particle )

local k = 1
if self:GetCaster():IsIllusion() and self:GetCaster().am_scepter then 
	local ability = self:GetCaster():FindAbilityByName("antimage_mana_overload_custom")
	k = ability:GetSpecialValueFor("ulti_damage")/100
end

local mana_void_ministun = self:GetSpecialValueFor("mana_void_ministun")

for _,enemy in pairs(enemies) do
	if self:GetCaster():HasModifier("modifier_antimage_void_6") then 
		enemy:AddNewModifier(self:GetCaster(), self, "modifier_antimage_mana_void_custom_slow", {duration = (1 - enemy:GetStatusResistance())*self.slow_duration})

	end


	enemy:AddNewModifier( caster, self, "modifier_stunned", { duration = mana_void_ministun } )
	
	ApplyDamage({ victim = enemy, attacker = self:GetCaster(), damage = mana_damage*k, damage_type = DAMAGE_TYPE_MAGICAL, ability = self, })

end



end







modifier_antimage_mana_void_custom_slow = class({})

function modifier_antimage_mana_void_custom_slow:IsPurgable() return false end

function modifier_antimage_mana_void_custom_slow:IsHidden() return false end 
function modifier_antimage_mana_void_custom_slow:IsDebuff() return true end
function modifier_antimage_mana_void_custom_slow:GetTexture() return "buffs/manavoid_slow" end


function modifier_antimage_mana_void_custom_slow:GetEffectName() return "particles/void_astral_slow.vpcf" end

function modifier_antimage_mana_void_custom_slow:DeclareFunctions()
return
{
 MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}

end


function modifier_antimage_mana_void_custom_slow:OnCreated(table)
if not IsServer() then return end
  self.particle = ParticleManager:CreateParticle("particles/generic_gameplay/generic_break.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
  ParticleManager:SetParticleControl(self.particle, 1, self:GetParent():GetAbsOrigin())
  self:AddParticle(self.particle, false, false, -1, false, false)
end

function modifier_antimage_mana_void_custom_slow:GetModifierMoveSpeedBonus_Percentage() 
return 
self:GetAbility().slow_move
end



function modifier_antimage_mana_void_custom_slow:CheckState()
return
{
	[MODIFIER_STATE_PASSIVES_DISABLED] = true
}
end







modifier_antimage_mana_void_custom_tracker = class({})
function modifier_antimage_mana_void_custom_tracker:IsHidden() return true end
function modifier_antimage_mana_void_custom_tracker:IsPurgable() return false end
function modifier_antimage_mana_void_custom_tracker:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	MODIFIER_EVENT_ON_ATTACK_LANDED
}
end


function modifier_antimage_mana_void_custom_tracker:OnAttackLanded(params)
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_antimage_void_4") then return end
if self:GetParent() ~= params.attacker then return end
if not params.target:IsHero() and not params.target:IsCreep() then return end
if params.target:GetMaxMana() == 0 then return end

local mana = params.target:GetMana()
params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_antimage_mana_void_custom_int", {duration = self:GetAbility().int_duration})

params.target:SetMana(mana)

end





function modifier_antimage_mana_void_custom_tracker:OnAbilityFullyCast(keys)
if not keys.ability then return end 
if keys.unit:GetTeamNumber() == self:GetCaster():GetTeamNumber() then return end
if keys.ability:IsItem() or UnvalidAbilities[keys.ability:GetName()] then return end
if keys.unit:IsMagicImmune() then return end
if keys.unit:HasModifier("modifier_antimage_mana_void_custom_cast_cd") then return end
if (keys.unit:GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D() > self:GetAbility().cast_radius then return end
if not self:GetParent():HasModifier("modifier_antimage_void_5") then return end
if not self:GetParent():IsAlive() then return end

local unit = keys.unit

self:GetParent():EmitSound("Antimage.Void_stun")

local heal = unit:GetMaxMana()*self:GetAbility().cast_heal
my_game:GenericHeal(self:GetCaster(), heal, self:GetAbility())
          
local zap_pfx = ParticleManager:CreateParticle("particles/am_void_cd.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
ParticleManager:SetParticleControlEnt(zap_pfx, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(zap_pfx, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
ParticleManager:ReleaseParticleIndex(zap_pfx)


unit:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_stunned", {duration = self:GetAbility().cast_stun})
unit:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_antimage_mana_void_custom_cast_cd", {duration = self:GetAbility().cast_cd})
end



modifier_antimage_mana_void_custom_int = class({})
function modifier_antimage_mana_void_custom_int:IsHidden() return false end
function modifier_antimage_mana_void_custom_int:IsPurgable() return false end
function modifier_antimage_mana_void_custom_int:GetTexture() return "buffs/manavoid_int" end


function modifier_antimage_mana_void_custom_int:OnCreated(table)
if not IsServer() then return end


self:SetStackCount(1)
self.RemoveForDuel = true 
end

function modifier_antimage_mana_void_custom_int:OnRefresh(table)
if not IsServer() then return end

if self:GetParent():IsHero() then 
 	self:GetParent():CalculateStatBonus(true)
end


if self:GetStackCount() >= self:GetAbility().int_max then return end

self:IncrementStackCount()
end


function modifier_antimage_mana_void_custom_int:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MANA_BONUS,
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end


function modifier_antimage_mana_void_custom_int:GetModifierManaBonus()
return self:GetStackCount()*self:GetCaster():GetMaxMana()*self:GetAbility().int_self[self:GetCaster():GetUpgradeStack("modifier_antimage_void_4")]
end 

function modifier_antimage_mana_void_custom_int:GetModifierMoveSpeedBonus_Percentage()
return self:GetStackCount()*self:GetAbility().int_slow[self:GetCaster():GetUpgradeStack("modifier_antimage_void_4")]
end 


function modifier_antimage_mana_void_custom_int:OnStackCountChanged(iStackCount)
if self:GetStackCount() == 0 then return end
if self:GetStackCount() == 1 then 

	local particle_cast = "particles/am_mana_stack.vpcf"

	self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, self:GetStackCount(), 0 ) )

	self:AddParticle(self.effect_cast,false, false, -1, false, false)
else 
  if self.effect_cast then 
  	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, self:GetStackCount(), 0 ) )
  end
end

end






modifier_antimage_mana_void_custom_aura = class({})

function modifier_antimage_mana_void_custom_aura:IsHidden() return false end
function modifier_antimage_mana_void_custom_aura:IsPurgable() return false end
function modifier_antimage_mana_void_custom_aura:IsDebuff() return false end
function modifier_antimage_mana_void_custom_aura:GetTexture() return "buffs/astral_burn" end
function modifier_antimage_mana_void_custom_aura:RemoveOnDeath() return false end



function modifier_antimage_mana_void_custom_aura:GetAuraRadius()
	return self:GetAbility().burn_radius
end

function modifier_antimage_mana_void_custom_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_antimage_mana_void_custom_aura:GetAuraSearchType() 
	return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end


function modifier_antimage_mana_void_custom_aura:GetModifierAura()
	return "modifier_antimage_mana_void_custom_aura_damage"
end

function modifier_antimage_mana_void_custom_aura:IsAura()
	return true
end







modifier_antimage_mana_void_custom_aura_damage = class({})
function modifier_antimage_mana_void_custom_aura_damage:IsHidden() return false end
function modifier_antimage_mana_void_custom_aura_damage:IsPurgable() return false end
function modifier_antimage_mana_void_custom_aura_damage:GetTexture() return "buffs/astral_burn" end

function modifier_antimage_mana_void_custom_aura_damage:OnCreated(table)
if not IsServer() then return end
self:StartIntervalThink(self:GetAbility().burn_interval)

end

function modifier_antimage_mana_void_custom_aura_damage:OnIntervalThink()
if not IsServer() then return end



self.damage =  self:GetAbility().burn_interval*self:GetParent():GetMaxMana()*self:GetAbility().burn_mana[self:GetCaster():GetUpgradeStack("modifier_antimage_void_3")]


ApplyDamage({victim = self:GetParent(), attacker = self:GetCaster(), ability = self:GetAbility(), damage = self.damage, damage_type = DAMAGE_TYPE_MAGICAL})
end




function modifier_antimage_mana_void_custom_aura_damage:GetEffectName()
	return "particles/units/heroes/hero_faceless_void/faceless_void_dialatedebuf_2.vpcf"
end

function modifier_antimage_mana_void_custom_aura_damage:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
function modifier_antimage_mana_void_custom_aura_damage:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOOLTIP
}
end


function modifier_antimage_mana_void_custom_aura_damage:OnTooltip()



return self:GetAbility().burn_interval*self:GetParent():GetMaxMana()*self:GetAbility().burn_mana[self:GetCaster():GetUpgradeStack("modifier_antimage_void_3")]
end















antimage_spell_seal_custom = class({})


function antimage_spell_seal_custom:OnAbilityPhaseStart()
if not IsServer() then return end
self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_antimage_mana_break_custom_anim", {})

return true
end


function antimage_spell_seal_custom:OnAbilityPhaseInterrupted()
if not IsServer() then return end
self:GetCaster():RemoveModifierByName("modifier_antimage_mana_break_custom_anim")
end






function antimage_spell_seal_custom:OnSpellStart()
if not IsServer() then return end
self:GetCaster():RemoveModifierByName("modifier_antimage_mana_break_custom_anim")

local target = self:GetCursorTarget()
local caster = self:GetCaster()

local leakCast = ParticleManager:CreateParticle("particles/am_cast.vpcf", PATTACH_POINT_FOLLOW, target)
ParticleManager:SetParticleControlEnt(leakCast, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true) 
ParticleManager:SetParticleControlEnt(leakCast, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
ParticleManager:ReleaseParticleIndex(leakCast)


target:AddNewModifier(self:GetCaster(), self, "modifier_antimage_mana_void_custom_legendary", {duration = self:GetSpecialValueFor("duration")})

end


modifier_antimage_mana_void_custom_legendary = class({})


function modifier_antimage_mana_void_custom_legendary:IsHidden() return false end
function modifier_antimage_mana_void_custom_legendary:IsPurgable() return false end
function modifier_antimage_mana_void_custom_legendary:GetEffectName() return "particles/am_mana_mark.vpcf" end
function modifier_antimage_mana_void_custom_legendary:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end


function modifier_antimage_mana_void_custom_legendary:OnCreated(table)
if not IsServer() then return end
self.mana = self:GetAbility():GetSpecialValueFor("mana")/100

  self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_silencer/silencer_last_word_status.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
  ParticleManager:SetParticleControl(self.particle, 1, self:GetParent():GetAbsOrigin())
  self:AddParticle(self.particle, false, false, -1, false, false)

end




function modifier_antimage_mana_void_custom_legendary:DeclareFunctions()
return
{
    MODIFIER_EVENT_ON_ABILITY_EXECUTED,
}
end


function modifier_antimage_mana_void_custom_legendary:OnAbilityExecuted( params )
if not IsServer() then return end
if params.unit~=self:GetParent() then return end
if not params.ability:ProcsMagicStick() then return end
if not params.ability then return end
if params.ability:IsItem() or params.ability:IsToggle() then return end
if UnvalidAbilities[params.ability:GetName()] then return end

self:GetParent():EmitSound("Hero_Antimage.ManaVoid")

local particle = ParticleManager:CreateParticle( "particles/econ/items/antimage/antimage_weapon_basher_ti5/antimage_manavoid_ti_5.vpcf", PATTACH_POINT_FOLLOW, self:GetParent())
ParticleManager:SetParticleControlEnt( particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true )
ParticleManager:SetParticleControl( particle, 1, Vector( 350, 0, 0 ) )
ParticleManager:ReleaseParticleIndex( particle )

local damage = self:GetParent():GetMaxMana()*self.mana

self:GetParent():SpendMana(damage, nil)


ApplyDamage({ victim = self:GetParent(), attacker = self:GetCaster(), damage = damage, damage_type = DAMAGE_TYPE_PURE, ability = self:GetAbility(), })

self:GetCaster():GenericHeal(damage, self:GetAbility())

SendOverheadEventMessage(self:GetParent(), 4, self:GetParent(), damage, nil)


end



modifier_antimage_mana_void_custom_cast_cd = class({})
function modifier_antimage_mana_void_custom_cast_cd:IsHidden() return true end
function modifier_antimage_mana_void_custom_cast_cd:IsPurgable() return false end
function modifier_antimage_mana_void_custom_cast_cd:OnCreated(table)
self.RemoveForDuel = true
end