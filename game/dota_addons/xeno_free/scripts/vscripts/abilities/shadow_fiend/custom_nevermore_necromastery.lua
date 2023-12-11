 LinkLuaModifier("modifier_custom_necromastery_souls", "abilities/shadow_fiend/custom_nevermore_necromastery", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_necromastery_kills", "abilities/shadow_fiend/custom_nevermore_necromastery", LUA_MODIFIER_MOTION_NONE) 
LinkLuaModifier("modifier_custom_necromastery_tempo_track", "abilities/shadow_fiend/custom_nevermore_necromastery", LUA_MODIFIER_MOTION_NONE) 
LinkLuaModifier("modifier_custom_necromastery_tempo", "abilities/shadow_fiend/custom_nevermore_necromastery", LUA_MODIFIER_MOTION_NONE) 
LinkLuaModifier("modifier_custom_necromastery_legendary", "abilities/shadow_fiend/custom_nevermore_necromastery", LUA_MODIFIER_MOTION_NONE) 
LinkLuaModifier("modifier_custom_necromastery_heal_cd", "abilities/shadow_fiend/custom_nevermore_necromastery", LUA_MODIFIER_MOTION_NONE) 
LinkLuaModifier("modifier_custom_necromastery_attack_count", "abilities/shadow_fiend/custom_nevermore_necromastery", LUA_MODIFIER_MOTION_NONE) 
LinkLuaModifier("modifier_custom_necromastery_attack_slow", "abilities/shadow_fiend/custom_nevermore_necromastery", LUA_MODIFIER_MOTION_NONE)

custom_nevermore_necromastery = class({})	


custom_nevermore_necromastery.max_init = 0
custom_nevermore_necromastery.max_inc = 2


custom_nevermore_necromastery.speed_bonus = {1, 2, 3}



custom_nevermore_necromastery.legendary_duration = 8
custom_nevermore_necromastery.legendary_cd = 25
custom_nevermore_necromastery.legendary_bva = 1.3
custom_nevermore_necromastery.legendary_soul_duration = 14

custom_nevermore_necromastery.heal_health = 30
custom_nevermore_necromastery.heal_heal = 0.008
custom_nevermore_necromastery.heal_cd = 30

custom_nevermore_necromastery.attack_max = {6, 4}
custom_nevermore_necromastery.attack_damage = 6 
custom_nevermore_necromastery.attack_heal = 1 
custom_nevermore_necromastery.attack_radius = 200
custom_nevermore_necromastery.attack_max_slow = -50
custom_nevermore_necromastery.attack_max_slow_duration = 0.6

custom_nevermore_necromastery.souls_health = {8, 12, 16}
custom_nevermore_necromastery.souls_move = {1, 1.5, 2}





function custom_nevermore_necromastery:Precache(context)

PrecacheResource( "particle", "particles/units/heroes/hero_nevermore/nevermore_necro_souls.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_nevermore/nevermore_souls_hero_effect.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_nevermore/sf_necromastery_attack.vpcf", context )
PrecacheResource( "particle", "particles/sf_souls_attack.vpcf", context )
PrecacheResource( "particle", "particles/huskar_leap_heal.vpcf", context )
PrecacheResource( "particle", "particles/sf_souls_heal.vpcf", context )
PrecacheResource( "particle", "particles/sf_wings.vpcf", context )
PrecacheResource( "particle", "particles/sf_hands_.vpcf", context )
PrecacheResource( "particle", "particles/sf_souls_souls.vpcf", context )
PrecacheResource( "particle", "particles/sf_slow_attack.vpcf", context )

end




function custom_nevermore_necromastery:GetCooldown(iLevel)

if self:GetCaster():HasModifier("modifier_nevermore_souls_legendary") then 
	return self.legendary_cd
end

  return self.BaseClass.GetCooldown(self, iLevel)
end



function custom_nevermore_necromastery:GetIntrinsicModifierName()
	return "modifier_custom_necromastery_souls"
end

function custom_nevermore_necromastery:GetBehavior()
  if self:GetCaster():HasModifier("modifier_nevermore_souls_legendary") then
   		 return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE
   end

 return DOTA_ABILITY_BEHAVIOR_PASSIVE 
end




function custom_nevermore_necromastery:OnSpellStart()

local caster = self:GetCaster()


caster:EmitSound("Sf.Souls_Legendary")
local duration = self.legendary_duration 


caster:AddNewModifier(caster, self, "modifier_custom_necromastery_legendary", {duration = duration})

end






---------------------------------------------------------------------------------------------------------------------------------------



modifier_custom_necromastery_souls = class({})






function modifier_custom_necromastery_souls:OnCreated()

self.cast = false
self.records = {}

self.caster = self:GetCaster()
self.ability = self:GetAbility()
self.particle_soul_creep = "particles/units/heroes/hero_nevermore/nevermore_necro_souls.vpcf"

self.max_kills = self:GetCaster():GetTalentValue("modifier_nevermore_souls_kills", "max", true)
self.max_damage = self:GetCaster():GetTalentValue("modifier_nevermore_souls_kills", "max_damage", true)

self.damage_per_soul = self.ability:GetSpecialValueFor("necromastery_damage_per_soul")
self.base_max_souls = self.ability:GetSpecialValueFor("necromastery_max_souls")
self.scepter_max_souls = self.ability:GetSpecialValueFor("necromastery_max_souls_scepter")
self.max_souls = self.base_max_souls
self.souls_lost_on_death_pct = self.ability:GetSpecialValueFor("necromastery_soul_release")

if IsServer() then
	self:StartIntervalThink(0.1)
end

end




function modifier_custom_necromastery_souls:GetHeroEffectName()
	return "particles/units/heroes/hero_nevermore/nevermore_souls_hero_effect.vpcf"
end

function modifier_custom_necromastery_souls:OnIntervalThink()
	self:RefreshSoulsMax()
end

function modifier_custom_necromastery_souls:RefreshSoulsMax()

	self.max_souls = self.ability:GetSpecialValueFor("necromastery_max_souls")

	local bonus = 0 
	if self.caster:HasScepter() then
		bonus = self.scepter_max_souls
	end

	if self.caster:HasModifier("modifier_nevermore_souls_max") then 
		bonus = bonus + (self:GetAbility().max_init + self:GetAbility().max_inc*self.caster:GetUpgradeStack("modifier_nevermore_souls_max"))
	end 

	if self.caster:HasModifier("modifier_nevermore_souls_kills")  then 
		bonus = bonus + self.caster:GetTalentValue("modifier_nevermore_souls_kills", "bonus")*self.caster:GetUpgradeStack("modifier_custom_necromastery_kills")
	end 

	self.max_souls = self.max_souls + bonus

end


function modifier_custom_necromastery_souls:OnRefresh()
	self:OnCreated()
end



function modifier_custom_necromastery_souls:DestroyOnExpire()
	return false
end




function modifier_custom_necromastery_souls:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_TOOLTIP,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT


	}
end


function modifier_custom_necromastery_souls:OnStackCountChanged(iStackCount)
if not IsServer() then return end

self:GetParent():CalculateStatBonus(true)
end


function modifier_custom_necromastery_souls:GetModifierMoveSpeedBonus_Constant()
local bonus = 0

if self:GetParent():HasModifier("modifier_nevermore_souls_attack") then 
	bonus = self:GetStackCount()*self:GetAbility().souls_move[self:GetParent():GetUpgradeStack("modifier_nevermore_souls_attack")]
end

return bonus
end



function modifier_custom_necromastery_souls:GetModifierHealthBonus()
local bonus = 0

if self:GetParent():HasModifier("modifier_nevermore_souls_attack") then 
	bonus = self:GetStackCount()*self:GetAbility().souls_health[self:GetParent():GetUpgradeStack("modifier_nevermore_souls_attack")]
end

return bonus
end



function modifier_custom_necromastery_souls:OnAttackLanded(params)
if not IsServer() then return end
if params.attacker ~= self:GetParent() then return end
if params.target:IsBuilding() then return end



if self:GetParent():HasModifier("modifier_custom_necromastery_legendary") and self:GetParent():IsAlive() then

	local duration = self:GetAbility().legendary_soul_duration

	self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_necromastery_tempo", {duration = duration})
	self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_necromastery_tempo_track", {duration = duration})


	local soul_projectile = {Target = self:GetParent(),Source = params.target, Ability = self:GetAbility(),EffectName = self.particle_soul_creep,bDodgeable = false,bProvidesVision = false,iMoveSpeed = self.soul_projectile_speed,iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION}
	ProjectileManager:CreateTrackingProjectile(soul_projectile)

end




if params.target:IsMagicImmune() then return end

if not self:GetParent():HasModifier("modifier_nevermore_souls_tempo") then return end
if self:GetParent():PassivesDisabled() then return end

local mod = self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_necromastery_attack_count", {})
if mod then 

	if mod:GetStackCount() >= self:GetAbility().attack_max[self:GetCaster():GetUpgradeStack("modifier_nevermore_souls_tempo")] then 
		mod:Destroy()
		local damage = self:GetAbility().attack_damage *self:GetStackCount()
		params.target:EmitSound("Sf.Souls_Attack")

		my_game:GenericHeal(self:GetParent(), damage, self:GetAbility())


		ApplyDamage({ victim = params.target, attacker = self:GetParent(), ability = self:GetAbility(), damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
  	SendOverheadEventMessage(params.target, 4, params.target, damage, nil)
  	params.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_necromastery_attack_slow", {duration = self:GetAbility().attack_max_slow_duration})



 		local particle = ParticleManager:CreateParticle( "particles/sf_souls_attack.vpcf", PATTACH_ABSORIGIN_FOLLOW, params.target )
  
 		ParticleManager:SetParticleControl(particle, 0, params.target:GetAbsOrigin())
  	ParticleManager:ReleaseParticleIndex( particle )
    	
	end
end

end

function modifier_custom_necromastery_souls:GetModifierAttackSpeedBonus_Constant()
if not self:GetParent():HasModifier("modifier_nevermore_souls_damage") then return end
	local stacks = self:GetStackCount()
	return (self:GetAbility().speed_bonus[self:GetCaster():GetUpgradeStack("modifier_nevermore_souls_damage")] )* stacks 
end



function modifier_custom_necromastery_souls:GetModifierPreAttack_BonusDamage()
local stacks = self:GetStackCount()
local bonus = 0 


if self:GetCaster():GetUpgradeStack("modifier_custom_necromastery_kills") >= self.max_kills and self:GetCaster():HasModifier("modifier_nevermore_souls_kills") then 
	bonus = self.max_damage
end

	return (self.damage_per_soul + bonus)* stacks 
end

function modifier_custom_necromastery_souls:OnTakeDamage(params)
if not IsServer() then return end
if self:GetParent():PassivesDisabled() then return end
if not self:GetParent():HasModifier("modifier_nevermore_souls_heal") then return end
if params.unit ~= self:GetParent() then return end
if self:GetParent():GetHealthPercent() > self:GetAbility().heal_health then return end
if self:GetParent():HasModifier("modifier_custom_necromastery_heal_cd") then return end
if self:GetParent():HasModifier("modifier_death") then return end


local heal = self:GetParent():GetMaxHealth()*(self:GetAbility().heal_heal)*self:GetStackCount()

self:GetParent():Heal(heal, self:GetParent())
self:GetParent():EmitSound("Sf.Souls_Heal")        
SendOverheadEventMessage(self:GetParent(), 10, self:GetParent(), heal, nil)

local particle = ParticleManager:CreateParticle( "particles/huskar_leap_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
ParticleManager:ReleaseParticleIndex( particle )

local particle_aoe_fx = ParticleManager:CreateParticle("particles/sf_souls_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControl(particle_aoe_fx, 0,  self:GetParent():GetAbsOrigin())
ParticleManager:SetParticleControl(particle_aoe_fx, 1, Vector(150, 1, 1))
ParticleManager:ReleaseParticleIndex(particle_aoe_fx)  


self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_necromastery_heal_cd", {duration = self:GetAbility().heal_cd})

end

function modifier_custom_necromastery_souls:OnTooltip()
local max_souls = self.ability:GetSpecialValueFor("necromastery_max_souls")

local bonus = 0 

if self:GetParent():HasScepter() then 
	bonus = self.scepter_max_souls
end

if self:GetParent():HasModifier("modifier_nevermore_souls_max") then 
	bonus = bonus + (self:GetAbility().max_init + self:GetAbility().max_inc*self:GetParent():GetUpgradeStack("modifier_nevermore_souls_max"))
end 

if self:GetParent():HasModifier("modifier_nevermore_souls_kills") and self:GetParent():HasModifier("modifier_nevermore_souls_kills") then 
	bonus = bonus +  self.caster:GetTalentValue("modifier_nevermore_souls_kills", "bonus")*self.caster:GetUpgradeStack("modifier_custom_necromastery_kills")
end 

max_souls = max_souls + bonus


return max_souls 
end


function modifier_custom_necromastery_souls:OnDeath(keys)
if not IsServer() then return end
	local target = keys.unit
	local attacker = keys.attacker

	if self.ability:IsStolen() then
		return nil
	end


	if self.caster == attacker and self.caster ~= target then

		if target:IsIllusion() then
			return nil
		end

		if target:IsTempestDouble() then
			return nil
		end

		if target:IsBuilding() then
			return nil
		end

		if target:IsValidKill(self:GetParent()) then 
			self.caster:AddNewModifier(self.caster, self:GetAbility(), "modifier_custom_necromastery_kills", {})
		end

		local ability = self:GetAbility()

		local soul_count = 1

		local mod_tempo = self.caster:FindModifierByName("modifier_custom_necromastery_tempo")
		local tempo_souls = 0
		if mod_tempo then 
			tempo_souls = mod_tempo:GetStackCount()
		end


		self:RefreshSoulsMax()



		local incr_souls =  (self.max_souls) - (self:GetStackCount() - tempo_souls)


		if incr_souls > 0 then 
			self:SetStackCount(self:GetStackCount() + math.min(incr_souls, soul_count))
		end

		

		local soul_projectile = {Target = self.caster,Source = target, Ability = self.ability,EffectName = self.particle_soul_creep,bDodgeable = false,bProvidesVision = false,iMoveSpeed = self.soul_projectile_speed,iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION}
		ProjectileManager:CreateTrackingProjectile(soul_projectile)



	end
	
	if self:GetParent() == target and not target:IsIllusion() and  not self:GetParent():IsReincarnating() then
		local mod = self.caster:FindModifierByName("modifier_custom_necromastery_tempo")
		if mod then 
			mod:Destroy()
			for _,track in pairs(self.caster:FindAllModifiers()) do
				if track:GetName() == "modifier_custom_necromastery_tempo_track" then 
					track:Destroy()
				end
			end
		end
		local stacks = self:GetStackCount()
		local stacks_lost = math.floor(stacks * (self.souls_lost_on_death_pct))

		if my_game:FinalDuel() == false then 
			self:SetStackCount(stacks - stacks_lost)
		end
		
		self.requiem_ability = "custom_nevermore_requiem"
		if self.caster:HasAbility(self.requiem_ability) then
			local requiem_ability_handler = self.caster:FindAbilityByName(self.requiem_ability)
			if requiem_ability_handler then
				if requiem_ability_handler:GetLevel() >= 1 then
					requiem_ability_handler:OnSpellStart(true)
				end
			end
		end


	end


end



function modifier_custom_necromastery_souls:RemoveOnDeath() return false end
function modifier_custom_necromastery_souls:IsHidden() return false end
function modifier_custom_necromastery_souls:IsPurgable() return false end
function modifier_custom_necromastery_souls:IsDebuff() return false end
function modifier_custom_necromastery_souls:AllowIllusionDuplicate() return true end



modifier_custom_necromastery_kills = class({})

function modifier_custom_necromastery_kills:IsHidden() return not self:GetParent():HasModifier("modifier_nevermore_souls_kills") end
function modifier_custom_necromastery_kills:IsPurgable() return false end
function modifier_custom_necromastery_kills:OnCreated(table)

self.max = self:GetCaster():GetTalentValue("modifier_nevermore_souls_kills", "max", true)
self.bonus = self:GetCaster():GetTalentValue("modifier_nevermore_souls_kills", "bonus", true)

if not IsServer() then return end

self:SetStackCount(1)
self:StartIntervalThink(0.5)
end


function modifier_custom_necromastery_kills:OnRefresh(table)
if not  IsServer() then return end
if self:GetStackCount() >= self.max then return end

self:IncrementStackCount()
end



function modifier_custom_necromastery_kills:OnIntervalThink()
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_nevermore_souls_kills") then return end 

if self:GetStackCount() >= self.max then 


	self:GetParent():EmitSound("BS.Thirst_legendary_active")
	local particle_peffect = ParticleManager:CreateParticle("particles/brist_lowhp_.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	ParticleManager:SetParticleControl(particle_peffect, 0, self:GetCaster():GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_peffect, 2, self:GetCaster():GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(particle_peffect)
	
	self:StartIntervalThink(-1)
end

end 

function modifier_custom_necromastery_kills:RemoveOnDeath() return false end
function modifier_custom_necromastery_kills:GetTexture() return "buffs/souls_kills" end

function modifier_custom_necromastery_kills:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOOLTIP,
	MODIFIER_PROPERTY_TOOLTIP2
}

end
function modifier_custom_necromastery_kills:OnTooltip()
return self:GetStackCount()
end

function modifier_custom_necromastery_kills:OnTooltip2()
if self:GetParent():HasModifier("modifier_nevermore_souls_kills") then 
	return self.bonus*self:GetStackCount()
end
return
end




modifier_custom_necromastery_tempo = class({})

function modifier_custom_necromastery_tempo:IsHidden() return false end
function modifier_custom_necromastery_tempo:IsPurgable() return false end
function modifier_custom_necromastery_tempo:GetTexture() return "buffs/souls_tempo" end
function modifier_custom_necromastery_tempo:DeclareFunctions()
return 
{
	MODIFIER_PROPERTY_TOOLTIP
}
end

function modifier_custom_necromastery_tempo:OnTooltip()
return self:GetStackCount()
end
function modifier_custom_necromastery_tempo:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
end
function modifier_custom_necromastery_tempo:OnRefresh(table)
if not IsServer() then return end
self:IncrementStackCount()
end



modifier_custom_necromastery_tempo_track = class({})

function modifier_custom_necromastery_tempo_track:IsHidden() return true end
function modifier_custom_necromastery_tempo_track:IsPurgable() return false end
function modifier_custom_necromastery_tempo_track:GetAttributes()  return MODIFIER_ATTRIBUTE_MULTIPLE end


function modifier_custom_necromastery_tempo_track:OnCreated(table)
if not IsServer() then return end
	local souls = self:GetParent():FindModifierByName("modifier_custom_necromastery_souls")
	if souls then 
		souls:IncrementStackCount()
	end
end
function modifier_custom_necromastery_tempo_track:OnDestroy()
  if not IsServer() then return end
  
  local tempo = self:GetParent():FindModifierByNameAndCaster("modifier_custom_necromastery_tempo", self:GetCaster())
  
  if tempo then
    tempo:DecrementStackCount()
    if tempo:GetStackCount() == 0 then 
    	tempo:Destroy()
    end
  end

  local souls = self:GetParent():FindModifierByName("modifier_custom_necromastery_souls")
	if souls and souls:GetStackCount() > 0 then 
		souls:DecrementStackCount()
   end
end


modifier_custom_necromastery_legendary = class({})
function modifier_custom_necromastery_legendary:GetTexture() return "buffs/souls_active" end
function modifier_custom_necromastery_legendary:IsHidden() return false end
function modifier_custom_necromastery_legendary:IsPurgable() return false end
function modifier_custom_necromastery_legendary:OnCreated(table)
if not IsServer() then return end


self.wings_particle = ParticleManager:CreateParticle("particles/sf_wings.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
local mod = self:GetParent():FindModifierByName("modifier_custom_necromastery_souls")

self.hands = ParticleManager:CreateParticle("particles/sf_hands_.vpcf",PATTACH_ABSORIGIN_FOLLOW,self:GetParent())
ParticleManager:SetParticleControlEnt(self.hands,0,self:GetParent(),PATTACH_ABSORIGIN_FOLLOW,"follow_origin",self:GetParent():GetOrigin(),false)
self:AddParticle(self.hands,true,false,0,false,false)
 	
local n = 0
if mod then 
	n = mod:GetStackCount()
end
self.effect = ParticleManager:CreateParticle("particles/sf_souls_souls.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
ParticleManager:SetParticleControl(self.effect, 1, Vector(n, 0, 0))

 
Timers:CreateTimer(4,function()
	ParticleManager:DestroyParticle(self.wings_particle, false)
	ParticleManager:ReleaseParticleIndex(self.wings_particle)   
end)

end

function modifier_custom_necromastery_legendary:OnDestroy()
if not IsServer() then return end

ParticleManager:DestroyParticle(self.effect, false)
ParticleManager:ReleaseParticleIndex(self.effect)

ParticleManager:DestroyParticle(self.hands, false)
ParticleManager:ReleaseParticleIndex(self.hands)


end




function modifier_custom_necromastery_legendary:DeclareFunctions()
return 
{
	MODIFIER_PROPERTY_PROJECTILE_NAME,
	MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT
}
end



function modifier_custom_necromastery_legendary:GetModifierBaseAttackTimeConstant()
return self:GetAbility().legendary_bva
end

function modifier_custom_necromastery_legendary:GetModifierProjectileName()
return "particles/units/heroes/hero_nevermore/sf_necromastery_attack.vpcf"
end





modifier_custom_necromastery_heal_cd = class({})
function modifier_custom_necromastery_heal_cd:IsHidden() return false end
function modifier_custom_necromastery_heal_cd:IsPurgable() return false end
function modifier_custom_necromastery_heal_cd:IsDebuff() return true end
function modifier_custom_necromastery_heal_cd:RemoveOnDeath() return false end
function modifier_custom_necromastery_heal_cd:GetTexture() return "buffs/souls_heal_cd" end
function modifier_custom_necromastery_heal_cd:OnCreated(table)
	self.RemoveForDuel = true
if not IsServer() then return end


end





modifier_custom_necromastery_attack_count = class({})
function modifier_custom_necromastery_attack_count:IsHidden() return false end
function modifier_custom_necromastery_attack_count:IsPurgable() return false end
function modifier_custom_necromastery_attack_count:RemoveOnDeath() return false end
function modifier_custom_necromastery_attack_count:GetTexture() return "buffs/souls_attack" end


function modifier_custom_necromastery_attack_count:OnCreated(table)
if not IsServer() then return end
self.RemoveForDuel = true
self:SetStackCount(1)
end
function modifier_custom_necromastery_attack_count:OnRefresh(table)
if not IsServer() then return end
self:IncrementStackCount()
end

function modifier_custom_necromastery_attack_count:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOOLTIP,
	MODIFIER_PROPERTY_TOOLTIP2
}
end
function modifier_custom_necromastery_attack_count:OnTooltip()

return self:GetAbility().attack_max[self:GetCaster():GetUpgradeStack("modifier_nevermore_souls_tempo")]

end

function modifier_custom_necromastery_attack_count:OnTooltip2()

return
self:GetParent():GetUpgradeStack("modifier_custom_necromastery_souls")*self:GetAbility().attack_damage[self:GetCaster():GetUpgradeStack("modifier_nevermore_souls_tempo")]
end

modifier_custom_necromastery_attack_slow = class({})
function modifier_custom_necromastery_attack_slow:IsHidden() return false end
function modifier_custom_necromastery_attack_slow:IsPurgable() return true end
function modifier_custom_necromastery_attack_slow:GetTexture() return "buffs/souls_attack" end
function modifier_custom_necromastery_attack_slow:GetEffectName() return "particles/sf_slow_attack.vpcf" end




function modifier_custom_necromastery_attack_slow:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
}
end
function modifier_custom_necromastery_attack_slow:GetModifierMoveSpeedBonus_Percentage()

return self:GetAbility().attack_max_slow

end




