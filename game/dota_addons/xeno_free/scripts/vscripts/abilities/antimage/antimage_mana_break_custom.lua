LinkLuaModifier( "modifier_antimage_mana_break_custom", "abilities/antimage/antimage_mana_break_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_antimage_mana_break_custom_slow", "abilities/antimage/antimage_mana_break_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_antimage_mana_break_custom_slow_legendary", "abilities/antimage/antimage_mana_break_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_antimage_mana_break_custom_silence", "abilities/antimage/antimage_mana_break_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_antimage_mana_break_custom_anim", "abilities/antimage/antimage_mana_break_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_antimage_mana_break_custom_legendary", "abilities/antimage/antimage_mana_break_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_antimage_mana_break_custom_heal_reduce", "abilities/antimage/antimage_mana_break_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_antimage_mana_break_custom_damage_cd", "abilities/antimage/antimage_mana_break_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_antimage_mana_break_custom_anim_normal", "abilities/antimage/antimage_mana_break_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_antimage_mana_break_custom_rooted", "abilities/antimage/antimage_mana_break_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_antimage_mana_break_custom_silence_cd", "abilities/antimage/antimage_mana_break_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_antimage_mana_break_custom_shard", "abilities/antimage/antimage_mana_break_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_antimage_mana_break_custom_armor", "abilities/antimage/antimage_mana_break_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_antimage_mana_break_custom_agility", "abilities/antimage/antimage_mana_break_custom", LUA_MODIFIER_MOTION_NONE )




antimage_mana_break_custom = class({})


antimage_mana_break_custom.no_mana_damage = {10, 15}
antimage_mana_break_custom.no_mana_stun = {1.0, 1.5}
antimage_mana_break_custom.no_mana_damage_duration = 5
antimage_mana_break_custom.no_mana_cd = 10
antimage_mana_break_custom.no_mana_pct = 0.5


antimage_mana_break_custom.slow_reduction = -30
antimage_mana_break_custom.slow_mana = 50






function antimage_mana_break_custom:Precache(context)

PrecacheResource( "particle", 'particles/am_heal_mana.vpcf', context )
PrecacheResource( "particle", 'particles/ogre_hit.vpcf', context )
PrecacheResource( "particle", 'particles/am_no_mana.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_antimage/antimage_manabreak_slow.vpcf', context )
PrecacheResource( "particle", 'particles/econ/items/death_prophet/death_prophet_ti9/death_prophet_silence_custom_ti9_overhead_model.vpcf', context )
PrecacheResource( "particle", 'particles/am_break_2.vpcf', context )
PrecacheResource( "particle", 'particles/am_break_legendary.vpcf', context )
PrecacheResource( "particle", 'particles/am_damage.vpcf', context )
PrecacheResource( "particle", 'particles/items3_fx/gleipnir_root.vpcf', context )
PrecacheResource( "particle", 'particles/anti-mage/manabreak_cleave.vpcf', context )


end





function antimage_mana_break_custom:GetCooldown(iLevel)

if self:GetCaster():HasModifier("modifier_antimage_break_7") then 
	return self:GetCaster():GetTalentValue("modifier_antimage_break_7", "cd")
end

return
end


function antimage_mana_break_custom:GetBehavior()
  if self:GetCaster():HasModifier("modifier_antimage_break_7") then
    return  DOTA_ABILITY_BEHAVIOR_NO_TARGET
  end
 return DOTA_ABILITY_BEHAVIOR_PASSIVE
end

function antimage_mana_break_custom:OnAbilityPhaseStart()
if not IsServer() then return end
self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_2, 1.2)

return true
end


function antimage_mana_break_custom:OnAbilityPhaseInterrupted()
if not IsServer() then return end
self:GetCaster():FadeGesture(ACT_DOTA_CAST_ABILITY_2)
end


function antimage_mana_break_custom:OnSpellStart()
if not IsServer() then return end

self:GetCaster():Purge(false, true, false, false, false)

self:GetCaster():EmitSound("Antimage.Break_legendary")
self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_antimage_mana_break_custom_legendary", {duration = self:GetCaster():GetTalentValue("modifier_antimage_break_7", "duration")})
end









function antimage_mana_break_custom:GetIntrinsicModifierName()
	return "modifier_antimage_mana_break_custom"
end

modifier_antimage_mana_break_custom = class({})

function modifier_antimage_mana_break_custom:IsHidden()
	return true
end

function modifier_antimage_mana_break_custom:IsPurgable()
	return false
end

function modifier_antimage_mana_break_custom:OnCreated( kv )
	self.mana_break = self:GetAbility():GetSpecialValueFor( "mana_per_hit" ) -- special value
	self.mana_damage_pct = self:GetAbility():GetSpecialValueFor( "damage_per_burn" ) -- special value
end

function modifier_antimage_mana_break_custom:OnRefresh( kv )
	self.mana_break = self:GetAbility():GetSpecialValueFor( "mana_per_hit" )
	self.mana_damage_pct = self:GetAbility():GetSpecialValueFor( "damage_per_burn" )
end

function modifier_antimage_mana_break_custom:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}

	return funcs
end

function modifier_antimage_mana_break_custom:GetModifierDamageOutgoing_Percentage(params)
if not IsServer() then return end 
local target = params.target

if not target then return end
if not params.target:IsHero() and not params.target:IsCreep() then return end

local mana_k = target:GetMana()/target:GetMaxMana()

if self:GetParent():HasModifier("modifier_antimage_mana_break_custom_legendary") then 
	bonus_damage = self:GetCaster():GetTalentValue("modifier_antimage_break_7", "damage")*(1 - mana_k)
	return bonus_damage
end

end 

function modifier_antimage_mana_break_custom:GetModifierAttackRangeBonus()
if not self:GetCaster():HasModifier("modifier_antimage_break_5") then return end
return self:GetCaster():GetTalentValue("modifier_antimage_break_5", "range")
end


function modifier_antimage_mana_break_custom:OnAttackLanded(params)
if not IsServer() then return end 
if not self:GetParent():HasModifier("modifier_antimage_break_1") then return end 
if self:GetParent() ~= params.attacker then return end 
if not params.target:IsHero() and not params.target:IsCreep() then return end 

local damage = self:GetCaster():GetTalentValue("modifier_antimage_break_1", "cleave")*params.damage/100

if not self:GetParent():HasModifier("modifier_no_cleave") then 
    DoCleaveAttack( self:GetParent(), params.target, self:GetAbility(), damage, 150, 360, 500, "particles/anti-mage/manabreak_cleave.vpcf" )
end

end 


function modifier_antimage_mana_break_custom:GetModifierProcAttack_BonusDamage_Physical( params )
if not IsServer() then return end
local target = params.target

if not target then return end

local bonus_damage = 0

local mana_k = target:GetMana()/target:GetMaxMana()


if self:GetParent():HasModifier("modifier_antimage_mana_break_custom_legendary") then 

	target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_antimage_mana_break_custom_slow_legendary", {duration = self:GetCaster():GetTalentValue("modifier_antimage_break_7", "slow_duration")})

	target:EmitSound("Antimage.Break_legendary_hit")

	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_antimage/antimage_manabreak_slow.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControl(particle, 0, target:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle, 1, target:GetAbsOrigin())
end


if self:GetParent():PassivesDisabled() then end

if target:GetMaxMana() == 0 then return end
if target:IsMagicImmune() then return bonus_damage end

local percent_damage_per_burn = self:GetAbility():GetSpecialValueFor("percent_damage_per_burn")
local mana_per_hit_pct = self:GetAbility():GetSpecialValueFor("mana_per_hit_pct")
local mana_per_hit = self:GetAbility():GetSpecialValueFor("mana_per_hit")
local illusion_burn = self:GetAbility():GetSpecialValueFor("illusion_burn")
local slow_duration = self:GetAbility():GetSpecialValueFor("slow_duration")



if self:GetParent():HasModifier("modifier_antimage_break_4") then 
	mana_per_hit_pct = mana_per_hit_pct + self:GetCaster():GetTalentValue("modifier_antimage_break_4", "mana_burn")
	self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_antimage_mana_break_custom_agility", {mana_k = mana_k, duration = self:GetCaster():GetTalentValue("modifier_antimage_break_4", "duration")})

end

local reduce_mana_full = mana_per_hit + (target:GetMaxMana() / 100 * mana_per_hit_pct)

if self:GetParent():IsIllusion() then
	reduce_mana_full = illusion_burn

	if self:GetParent():HasShard() then 
		reduce_mana_full = reduce_mana_full + self:GetAbility():GetSpecialValueFor("shard_bonus")
	end
end

if self:GetParent():HasModifier("modifier_antimage_break_3") then 
	target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_antimage_mana_break_custom_shard", {duration = self:GetCaster():GetTalentValue("modifier_antimage_break_3", "duration")})
end

if self:GetParent():HasModifier("modifier_antimage_break_1") then 
	target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_antimage_mana_break_custom_armor", {duration = self:GetCaster():GetTalentValue("modifier_antimage_break_1", "duration")})
end



if self:GetParent():HasModifier("modifier_antimage_break_5") and not target:HasModifier("modifier_antimage_mana_break_custom_silence_cd") then 
	target:EmitSound("Antimage.Break_silence")
	target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_antimage_mana_break_custom_silence", {duration = self:GetCaster():GetTalentValue("modifier_antimage_break_5", "silence")*(1 - params.target:GetStatusResistance())})
	target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_antimage_mana_break_custom_silence_cd", {duration = self:GetCaster():GetTalentValue("modifier_antimage_break_5", "cd")})
end


local mana_burn =  math.min( target:GetMana(), reduce_mana_full )

if self:GetParent():HasModifier("modifier_antimage_break_2") then 
	local heal = self:GetCaster():GetTalentValue("modifier_antimage_break_2", "heal")

	heal = heal * (1 + (self:GetCaster():GetTalentValue("modifier_antimage_break_2", "bonus") - 1)*(1 - mana_k))

	self:GetCaster():GenericHeal(heal, self:GetAbility(), false, "particles/am_heal_mana.vpcf")
end


if self:GetParent():GetQuest() == "Anti.Quest_5" and params.target:IsRealHero() and not self:GetParent():QuestCompleted() then 
	self:GetParent():UpdateQuest(math.floor(mana_burn))
end

target:Script_ReduceMana(mana_burn, self:GetAbility()) 

local particle = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_manaburn.vpcf", PATTACH_ABSORIGIN, target )
ParticleManager:ReleaseParticleIndex( particle )

local sound = "Hero_Antimage.ManaBreak"

if target:GetManaPercent() <= 50 then 
	sound = "Antimage.Low_mana"
end

target:EmitSound(sound)




if target:GetMana()/target:GetMaxMana() <= self:GetCaster():GetTalentValue("modifier_antimage_break_6", "mana")/100 then
	if self:GetParent():HasModifier("modifier_antimage_break_6") then 

		target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_antimage_mana_break_custom_heal_reduce", {duration = self:GetCaster():GetTalentValue("modifier_antimage_break_6", "duration")})


		if not target:HasModifier("modifier_antimage_mana_break_custom_damage_cd") then 
			local duration = self:GetCaster():GetTalentValue("modifier_antimage_break_6", "root")*(1 - target:GetStatusResistance())
			target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_antimage_mana_break_custom_rooted", {duration = duration})
			target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_antimage_mana_break_custom_damage_cd", {duration = self:GetCaster():GetTalentValue("modifier_antimage_break_6", "cd")})

			target:EmitSound("Antimage.Break_stun")

			local effect_cast = ParticleManager:CreateParticle( "particles/am_no_mana.vpcf", PATTACH_OVERHEAD_FOLLOW, target )
			ParticleManager:SetParticleControl( effect_cast, 0,  target:GetOrigin() )
			ParticleManager:SetParticleControl( effect_cast, 1, target:GetOrigin() )
			ParticleManager:ReleaseParticleIndex(effect_cast)
		end 
	end
end


if target:GetMana() <= 1 then
	target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_antimage_mana_break_custom_slow", {duration = slow_duration*(1 - target:GetStatusResistance())})
end	



return mana_burn * percent_damage_per_burn + bonus_damage

end





modifier_antimage_mana_break_custom_slow = class({})

function modifier_antimage_mana_break_custom_slow:IsPurgable() return false end

function modifier_antimage_mana_break_custom_slow:OnCreated()
self.movespeed_slow = self:GetAbility():GetSpecialValueFor("move_slow") * -1
local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_antimage/antimage_manabreak_slow.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControl(particle, 0, self:GetParent():GetAbsOrigin())
ParticleManager:SetParticleControl(particle, 1, self:GetParent():GetAbsOrigin())

end

function modifier_antimage_mana_break_custom_slow:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
end

function modifier_antimage_mana_break_custom_slow:GetModifierMoveSpeedBonus_Percentage()
	return self.movespeed_slow
end



modifier_antimage_mana_break_custom_slow_legendary = class({})

function modifier_antimage_mana_break_custom_slow_legendary:IsPurgable() return false end
function modifier_antimage_mana_break_custom_slow_legendary:IsHidden() return true end

function modifier_antimage_mana_break_custom_slow_legendary:OnCreated()
self.movespeed_slow = self:GetCaster():GetTalentValue("modifier_antimage_break_7", 'slow')
end

function modifier_antimage_mana_break_custom_slow_legendary:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
end

function modifier_antimage_mana_break_custom_slow_legendary:GetModifierMoveSpeedBonus_Percentage()
	return self.movespeed_slow
end




modifier_antimage_mana_break_custom_heal_reduce = class({})
function modifier_antimage_mana_break_custom_heal_reduce:IsHidden() return true end
function modifier_antimage_mana_break_custom_heal_reduce:IsPurgable() return false end
function modifier_antimage_mana_break_custom_heal_reduce:OnCreated()

self.heal_reduce = self:GetCaster():GetTalentValue("modifier_antimage_break_6", "heal_reduce")
end 

function modifier_antimage_mana_break_custom_heal_reduce:DeclareFunctions()
return {
	MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
	MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
	MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE
	}
end
function modifier_antimage_mana_break_custom_heal_reduce:GetModifierLifestealRegenAmplify_Percentage() 
    return self.heal_reduce
end
function modifier_antimage_mana_break_custom_heal_reduce:GetModifierHealAmplify_PercentageTarget() 
    return self.heal_reduce
end
function modifier_antimage_mana_break_custom_heal_reduce:GetModifierHPRegenAmplify_Percentage() 
    return self.heal_reduce
end


modifier_antimage_mana_break_custom_silence = class({})

function modifier_antimage_mana_break_custom_silence:IsHidden() return false end

function modifier_antimage_mana_break_custom_silence:IsPurgable() return true end

function modifier_antimage_mana_break_custom_silence:GetTexture() return "silencer_last_word" end

function modifier_antimage_mana_break_custom_silence:CheckState() return {[MODIFIER_STATE_SILENCED] = true} end


function modifier_antimage_mana_break_custom_silence:GetEffectName() return "particles/econ/items/death_prophet/death_prophet_ti9/death_prophet_silence_custom_ti9_overhead_model.vpcf" end
 
function modifier_antimage_mana_break_custom_silence:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end



modifier_antimage_mana_break_custom_anim = class({}) 
function modifier_antimage_mana_break_custom_anim:IsHidden() return true end
function modifier_antimage_mana_break_custom_anim:IsPurgable() return false end
function modifier_antimage_mana_break_custom_anim:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
}
end

function modifier_antimage_mana_break_custom_anim:GetActivityTranslationModifiers()
	return "basher"
end





modifier_antimage_mana_break_custom_legendary = class({})
function modifier_antimage_mana_break_custom_legendary:IsHidden() return false end
function modifier_antimage_mana_break_custom_legendary:IsPurgable() return false end
function modifier_antimage_mana_break_custom_legendary:OnCreated(table)
if not IsServer() then return end



self.particle_peffect = ParticleManager:CreateParticle("particles/am_break_2.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())	
ParticleManager:SetParticleControl(self.particle_peffect, 0, self:GetParent():GetAbsOrigin())
self:AddParticle(self.particle_peffect, false, false, -1, false, true)

end


function modifier_antimage_mana_break_custom_legendary:GetEffectName() return "particles/am_break_legendary.vpcf" end






modifier_antimage_mana_break_custom_silence_cd = class({})
function modifier_antimage_mana_break_custom_silence_cd:IsHidden() return true end
function modifier_antimage_mana_break_custom_silence_cd:IsPurgable() return false end



modifier_antimage_mana_break_custom_damage_cd = class({})
function modifier_antimage_mana_break_custom_damage_cd:IsHidden() return true end
function modifier_antimage_mana_break_custom_damage_cd:IsPurgable() return false end




modifier_antimage_mana_break_custom_rooted = class({})
function modifier_antimage_mana_break_custom_rooted:IsHidden() return true end
function modifier_antimage_mana_break_custom_rooted:IsPurgable() return true end
function modifier_antimage_mana_break_custom_rooted:CheckState()
return
{
	[MODIFIER_STATE_ROOTED] = true
}
end
function modifier_antimage_mana_break_custom_rooted:GetEffectName() return "particles/items3_fx/gleipnir_root.vpcf" end



modifier_antimage_mana_break_custom_shard = class({})
function modifier_antimage_mana_break_custom_shard:IsHidden() return false end
function modifier_antimage_mana_break_custom_shard:IsPurgable() return false end
function modifier_antimage_mana_break_custom_shard:GetTexture() return "buffs/sunder_damage" end
function modifier_antimage_mana_break_custom_shard:OnCreated(table)

self.damage = self:GetCaster():GetTalentValue("modifier_antimage_break_3", "damage_reduce")
self.max = self:GetCaster():GetTalentValue("modifier_antimage_break_3", "max")

if not IsServer() then return end

self:SetStackCount(1)
end

function modifier_antimage_mana_break_custom_shard:OnRefresh(table)
if not IsServer() then return end
if not self:GetAbility() then return end
if self:GetStackCount() >= self.max then return end

self:IncrementStackCount()
end

function modifier_antimage_mana_break_custom_shard:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
}
end



function modifier_antimage_mana_break_custom_shard:GetModifierTotalDamageOutgoing_Percentage()
return self:GetStackCount()*self.damage
end


modifier_antimage_mana_break_custom_armor = class({})
function modifier_antimage_mana_break_custom_armor:IsHidden() return false end
function modifier_antimage_mana_break_custom_armor:IsPurgable() return false end
function modifier_antimage_mana_break_custom_armor:GetTexture() return "buffs/manabreak_damage" end
function modifier_antimage_mana_break_custom_armor:OnCreated(table)
self.armor =  self:GetCaster():GetTalentValue("modifier_antimage_break_1", "armor")
end 


function modifier_antimage_mana_break_custom_armor:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
}
end

function modifier_antimage_mana_break_custom_armor:GetModifierPhysicalArmorBonus()
local mana_k = 1 - self:GetParent():GetMana()/self:GetParent():GetMaxMana()


return self.armor*mana_k
end



modifier_antimage_mana_break_custom_agility = class({})
function modifier_antimage_mana_break_custom_agility:IsHidden() return false end
function modifier_antimage_mana_break_custom_agility:IsPurgable() return false end
function modifier_antimage_mana_break_custom_agility:GetTexture() return "buffs/manabreak_agility" end
function modifier_antimage_mana_break_custom_agility:OnCreated(table)
if not IsServer() then return end 

local mana_k = 1 - table.mana_k

self:SetStackCount(mana_k * self:GetCaster():GetTalentValue("modifier_antimage_break_4", "agility"))
self:GetCaster():CalculateStatBonus(true)
end 


function modifier_antimage_mana_break_custom_agility:OnRefresh(table)
if not IsServer() then return end  

self:OnCreated(table)
end 



function modifier_antimage_mana_break_custom_agility:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_STATS_AGILITY_BONUS
}
end

function modifier_antimage_mana_break_custom_agility:GetModifierBonusStats_Agility()
return self:GetStackCount()
end 