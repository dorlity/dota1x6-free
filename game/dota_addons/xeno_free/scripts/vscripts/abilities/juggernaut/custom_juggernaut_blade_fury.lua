LinkLuaModifier("modifier_custom_juggernaut_blade_fury", "abilities/juggernaut/custom_juggernaut_blade_fury.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_blade_fury_silence", "abilities/juggernaut/custom_juggernaut_blade_fury.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_blade_fury_shard_damage", "abilities/juggernaut/custom_juggernaut_blade_fury.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_blade_fury_passive_fury", "abilities/juggernaut/custom_juggernaut_blade_fury.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_blade_fury_legendary_thinker", "abilities/juggernaut/custom_juggernaut_blade_fury.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_blade_fury_legendary_fly", "abilities/juggernaut/custom_juggernaut_blade_fury.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_blade_fury_legendary_pause", "abilities/juggernaut/custom_juggernaut_blade_fury.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_blade_fury_legendary_fly_back", "abilities/juggernaut/custom_juggernaut_blade_fury.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_blade_fury_anim", "abilities/juggernaut/custom_juggernaut_blade_fury.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_blade_fury_tracker", "abilities/juggernaut/custom_juggernaut_blade_fury.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_blade_fury_mini", "abilities/juggernaut/custom_juggernaut_blade_fury.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_blade_fury_slow", "abilities/juggernaut/custom_juggernaut_blade_fury.lua", LUA_MODIFIER_MOTION_NONE)





custom_juggernaut_blade_fury = class({})




function custom_juggernaut_blade_fury:Precache(context)
PrecacheResource( "particle", "particles/units/heroes/hero_juggernaut/jugg_crit_blur.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_juggernaut/jugg_attack_blur.vpcf", context )

PrecacheResource( "particle", "particles/units/heroes/hero_juggernaut/juggernaut_blade_fury_tgt.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_juggernaut/juggernaut_blade_fury.vpcf", context )

PrecacheResource( "particle", "particles/jugg_small_fury.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_terrorblade/ember_slow.vpcf", context )

my_game:PrecacheShopItems("npc_dota_hero_juggernaut", context)
end



function custom_juggernaut_blade_fury:GetAbilityTextureName()
  if self:GetCaster():HasModifier("modifier_juggernaut_edge_of_the_lost_crimson") then
      return "juggernaut/ti8_immortal_weapon/juggernaut_blade_fury_immortal_crimson"
  end
  if self:GetCaster():HasModifier("modifier_juggernaut_edge_of_the_lost_gold") then
      return "juggernaut/ti8_immortal_weapon/juggernaut_blade_fury_immortal_gold"
  end
  if self:GetCaster():HasModifier("modifier_juggernaut_edge_of_the_lost") then
      return "juggernaut/ti8_immortal_weapon/juggernaut_blade_fury_immortal"
  end
  if self:GetCaster():HasModifier("modifier_juggernaut_bladekeeper_weapon") then
      return "juggernaut/bladekeeper/juggernaut_blade_fury"
  end
  if self:GetCaster():HasModifier("modifier_juggernaut_arcana") or self:GetCaster():HasModifier("modifier_juggernaut_arcana_v2") then
      return "juggernaut_blade_fury_arcana"
  end
  return "juggernaut_blade_fury"
end





function custom_juggernaut_blade_fury:GetIntrinsicModifierName()
return "modifier_custom_juggernaut_blade_fury_tracker"
end


function custom_juggernaut_blade_fury:GetCooldown(iLevel)

local upgrade_cooldown = self:GetCaster():GetTalentValue("modifier_juggernaut_bladefury_chance", "cd")

 return self.BaseClass.GetCooldown(self, iLevel) + upgrade_cooldown

end



function custom_juggernaut_blade_fury:BladeFury_DealDamage(point, radius, inc_damage)
if not IsServer() then return end

local tick = 0.2
local bonus = self:GetCaster():GetAgility()*self:GetCaster():GetTalentValue("modifier_juggernaut_bladefury_damage", "damage")/100


local damage = (self:GetSpecialValueFor("damage") + bonus)*tick

local ability = self

if inc_damage and self:GetCaster():HasAbility("custom_juggernaut_whirling_blade_custom") then 
	damage = damage*(1 + self:GetCaster():GetTalentValue("modifier_juggernaut_bladefury_legendary", "damage")/100)
	ability = self:GetCaster():FindAbilityByName("custom_juggernaut_whirling_blade_custom")
end




if not IsServer() then return end

local targets = nil 
targets = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), point, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)
for _,target in ipairs(targets) do

  local real_damage = ApplyDamage({victim = target, attacker = self:GetCaster(), damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
  
  if self:GetCaster():HasModifier("modifier_juggernaut_bladefury_duration") then 
  	target:AddNewModifier(self:GetCaster(), self, "modifier_custom_juggernaut_blade_fury_slow", {duration = (1 - target:GetStatusResistance())*self:GetCaster():GetTalentValue("modifier_juggernaut_bladefury_duration", "slow_duration")})
  end

  local particle_cast = "particles/units/heroes/hero_juggernaut/juggernaut_blade_fury_tgt.vpcf"
  local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
  ParticleManager:ReleaseParticleIndex( effect_cast )
end



end


 


function custom_juggernaut_blade_fury:OnSpellStart()
self.duration = self:GetSpecialValueFor("duration")

if not IsServer() then return end


self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_generic_debuff_immune", {magic_damage = self:GetSpecialValueFor("magic_resist"), duration = self.duration})

if self:GetCaster():HasModifier("modifier_custom_juggernaut_blade_fury") then 
    self:GetCaster():RemoveModifierByName("modifier_custom_juggernaut_blade_fury")
end


self:GetCaster():StartGesture(ACT_DOTA_OVERRIDE_ABILITY_1)
self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_custom_juggernaut_blade_fury", {duration = self.duration, anim = 1})
self:GetCaster():Purge(false, true, false, false, false)

end










modifier_custom_juggernaut_blade_fury = class({})

function modifier_custom_juggernaut_blade_fury:IsPurgable() return false end

function modifier_custom_juggernaut_blade_fury:DeclareFunctions()
return
{

	MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL,
	MODIFIER_EVENT_ON_TAKEDAMAGE,
	MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	MODIFIER_PROPERTY_TOOLTIP,
	MODIFIER_EVENT_ON_ATTACK_LANDED
}  

end






function modifier_custom_juggernaut_blade_fury:OnTooltip()
return self.damage/self.tick

end


function modifier_custom_juggernaut_blade_fury:GetModifierPhysicalArmorBonus()

return self:GetParent():GetTalentValue("modifier_juggernaut_bladefury_shield", "armor")
end 

function modifier_custom_juggernaut_blade_fury:GetModifierMoveSpeedBonus_Constant()
if self:GetParent():HasShard() then 
 return self:GetAbility():GetSpecialValueFor("shard_move")
end
end


function modifier_custom_juggernaut_blade_fury:GetModifierProcAttack_BonusDamage_Physical( params ) 
if params.target:IsBuilding() then return end
if self:GetParent():HasModifier("modifier_custom_juggernaut_blade_fury_shard_damage") then return end

return -params.damage

end


function modifier_custom_juggernaut_blade_fury:OnCreated(table)
self.RemoveForDuel = true

self.damage = self:GetAbility():GetSpecialValueFor("damage")
self.radius = self:GetAbility():GetSpecialValueFor("radius") + self:GetCaster():GetTalentValue("modifier_juggernaut_bladefury_silence", "radius")


self.tick = 0.2
self.count = self:GetAbility():GetSpecialValueFor("shard_interval")
self:StartIntervalThink(self.tick)

self:PlayEffects()
   
self.silence_targets = {}

if not IsServer() then return end


if self:GetParent():HasModifier("modifier_juggernaut_bladefury_shield") then 

	self.effect = ParticleManager:CreateParticle( "particles/items2_fx/vindicators_axe_armor.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	self:AddParticle(self.effect,false, false, -1, false, false)
end 

if self:GetParent():IsHero() then 
	self.omni = self:GetCaster():FindAbilityByName("custom_juggernaut_omnislash")
	self.swift = self:GetCaster():FindAbilityByName("custom_juggernaut_swift_slash")
	self.blade = self:GetCaster():FindAbilityByName("custom_juggernaut_whirling_blade_custom")

	if self.omni then 
		self.omni:SetActivated(false)
	end

	if self.swift then 
		self.swift:SetActivated(false)
	end

	if self.blade then 
		self.blade:SetActivated(false)
	end

end
 

end



function modifier_custom_juggernaut_blade_fury:OnIntervalThink()
if not IsServer() then return end

local targets = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)

if self:GetCaster():HasShard() and self:GetParent():IsHero() then 
	self.count = self.count + self.tick

	if self.count >= self:GetAbility():GetSpecialValueFor("shard_interval") and #targets > 0 then 

    self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_juggernaut_blade_fury_shard_damage", {})
    local random = RandomInt(1, #targets)

    self:GetParent():PerformAttack(targets[random],true,true,true,false,false,false, false)
    self:GetParent():RemoveModifierByName("modifier_custom_juggernaut_blade_fury_shard_damage")
    self.count = 0
	end

end	

if self:GetCaster():HasModifier("modifier_juggernaut_bladefury_silence") and self:GetParent():IsHero() then 
	for _,target in pairs(targets) do 

		if not self.silence_targets[target] then 
			self.silence_targets[target] = true
      target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_juggernaut_blade_fury_silence", {duration = (1 - target:GetStatusResistance())*self:GetRemainingTime()})  
      target:EmitSound("Juggernaut.Fury_silence")
    end 
	end 

end 

self:GetAbility():BladeFury_DealDamage(self:GetParent():GetAbsOrigin(), self.radius, not self:GetParent():IsHero())
end




function modifier_custom_juggernaut_blade_fury:OnDestroy( kv )
if not IsServer() then return end

if not self:GetParent():HasModifier("modifier_custom_juggernaut_blade_fury_mini") then 
	self:GetParent():StopSound("Hero_Juggernaut.BladeFuryStart" )
end
self:GetParent():EmitSound("Hero_Juggernaut.BladeFuryStop")

self:GetParent():RemoveGesture(ACT_DOTA_OVERRIDE_ABILITY_1)



if self:GetParent():IsHero() then 
	self.omni = self:GetCaster():FindAbilityByName("custom_juggernaut_omnislash")
	self.swift = self:GetCaster():FindAbilityByName("custom_juggernaut_swift_slash")
	self.blade = self:GetCaster():FindAbilityByName("custom_juggernaut_whirling_blade_custom")

	if self.omni then 
		self.omni:SetActivated(true)
	end

	if self.swift then 
		self.swift:SetActivated(true)
	end
	
	if self.blade then 
		self.blade:SetActivated(true)
	end

end


end



function modifier_custom_juggernaut_blade_fury:PlayEffects()
if not IsServer() then return end

local particle_cast = "particles/units/heroes/hero_juggernaut/juggernaut_blade_fury.vpcf"


if self:GetCaster():HasModifier("modifier_juggernaut_edge_of_the_lost_crimson") then
    particle_cast = "particles/econ/items/juggernaut/jugg_ti8_sword/juggernaut_crimson_blade_fury_abyssal.vpcf"
elseif self:GetCaster():HasModifier("modifier_juggernaut_edge_of_the_lost_gold") then
    particle_cast = "particles/econ/items/juggernaut/jugg_ti8_sword/juggernaut_blade_fury_abyssal_golden.vpcf"
elseif self:GetCaster():HasModifier("modifier_juggernaut_edge_of_the_lost") then
    particle_cast = "particles/econ/items/juggernaut/jugg_ti8_sword/juggernaut_blade_fury_abyssal.vpcf"
elseif self:GetCaster():HasModifier("modifier_juggernaut_bladekeeper_weapon") then
    particle_cast = "particles/econ/items/juggernaut/bladekeeper_bladefury/_dc_juggernaut_blade_fury.vpcf"
elseif self:GetCaster():HasModifier("modifier_juggernaut_jade") then
    particle_cast = "particles/econ/items/juggernaut/jugg_sword_jade/juggernaut_blade_fury_jade.vpcf"
elseif self:GetCaster():HasModifier("modifier_juggernaut_bladeform") then
    particle_cast = "particles/econ/items/juggernaut/armor_of_the_favorite/juggernaut_blade_fury_favoriteblade.vpcf"
elseif self:GetCaster():HasModifier("modifier_juggernaut_kantusa") then
    particle_cast = "particles/econ/items/juggernaut/jugg_sword_script/juggernaut_blade_fury_script_new.vpcf"
elseif self:GetCaster():HasModifier("modifier_juggernaut_dragonsword") then
    particle_cast = "particles/econ/items/juggernaut/jugg_sword_dragon/juggernaut_blade_fury_dragon.vpcf"
end

if self:GetParent():HasModifier("modifier_custom_juggernaut_blade_fury_legendary_thinker") then 
	local  particle_cast = "particles/jugg_small_fury.vpcf"

	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 5, Vector( self.radius/1.6, 0, 0 ) )
	self:AddParticle(effect_cast,false,false,-1,false,false)
end

local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
ParticleManager:SetParticleControl( effect_cast, 5, Vector( self.radius, 0, 0 ) )



local particle_cast_2 = nil
local effect_cast_2

if self:GetCaster():HasModifier("modifier_juggernaut_arcana") then
    particle_cast_2 = "particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_blade_fury.vpcf"
end 

if self:GetCaster():HasModifier("modifier_juggernaut_arcana_v2") then
    particle_cast_2 = "particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_v2_blade_fury.vpcf"
end 


if particle_cast_2 ~= nil then 
	effect_cast_2 = ParticleManager:CreateParticle( particle_cast_2, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast_2, 5, Vector( self.radius, 0, 0 ) )
end 

self:AddParticle(effect_cast,false,false,-1,false,false)

if effect_cast_2 then 
	self:AddParticle(effect_cast_2,false,false,-1,false,false)
end 

if self:GetParent():IsHero() then 
	self:GetParent():EmitSound("Hero_Juggernaut.BladeFuryStart")
end


end














modifier_custom_juggernaut_blade_fury_mini = class({})

function modifier_custom_juggernaut_blade_fury_mini:IsPurgable() return false end

function modifier_custom_juggernaut_blade_fury_mini:IsHidden() return false end
function modifier_custom_juggernaut_blade_fury_mini:GetTexture() return "buffs/bladefury_agility" end

function modifier_custom_juggernaut_blade_fury_mini:OnCreated(table)
self.RemoveForDuel = true

self.tick = 0.2

if not IsServer() then return end
self:StartIntervalThink(self.tick)

self.radius = self:GetParent():GetTalentValue("modifier_juggernaut_bladefury_agility", "radius")

if self:GetParent():HasModifier("modifier_juggernaut_bladefury_shield") and false then 

	self.effect = ParticleManager:CreateParticle( "particles/items2_fx/vindicators_axe_armor.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	self:AddParticle(self.effect,false, false, -1, false, false)
end 

local  particle_cast = "particles/jugg_small_fury.vpcf"


local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
ParticleManager:SetParticleControl( effect_cast, 5, Vector( self:GetAbility():GetSpecialValueFor("radius")/1.3, 0, 0 ) )


self:AddParticle(effect_cast,false,false,-1,false,false)
self:GetParent():EmitSound("Hero_Juggernaut.BladeFuryStart")
end



function modifier_custom_juggernaut_blade_fury_mini:OnIntervalThink()
self:GetAbility():BladeFury_DealDamage(self:GetParent():GetAbsOrigin(), self.radius)
end


function modifier_custom_juggernaut_blade_fury_mini:OnDestroy( kv )
if not IsServer() then return end

if not self:GetParent():HasModifier("modifier_custom_juggernaut_blade_fury") then 
	self:GetParent():StopSound("Hero_Juggernaut.BladeFuryStart" )
end

self:GetParent():EmitSound("Hero_Juggernaut.BladeFuryStop")
end








modifier_custom_juggernaut_blade_fury_slow = class({})
function modifier_custom_juggernaut_blade_fury_slow:IsHidden() return false end
function modifier_custom_juggernaut_blade_fury_slow:IsPurgable() return true end
function modifier_custom_juggernaut_blade_fury_slow:GetTexture() return "buffs/Blade_fury_slow" end


function modifier_custom_juggernaut_blade_fury_slow:OnCreated(table)

self.slow_move = self:GetCaster():GetTalentValue("modifier_juggernaut_bladefury_duration", "slow_move")
self.slow_heal = self:GetCaster():GetTalentValue("modifier_juggernaut_bladefury_duration", "slow_heal")

if not IsServer() then return end

local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_terrorblade/ember_slow.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControl(iParticleID, 0, self:GetParent():GetAbsOrigin())
self:AddParticle(iParticleID, true, false, -1, false, false)

end




function modifier_custom_juggernaut_blade_fury_slow:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
 	MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
 	MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
	MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE
}

end

function modifier_custom_juggernaut_blade_fury_slow:GetModifierMoveSpeedBonus_Percentage()
return self.slow_move
end






function modifier_custom_juggernaut_blade_fury_slow:GetModifierLifestealRegenAmplify_Percentage() 
return self.slow_heal
end

function modifier_custom_juggernaut_blade_fury_slow:GetModifierHealAmplify_PercentageTarget() 
return self.slow_heal
end

function modifier_custom_juggernaut_blade_fury_slow:GetModifierHPRegenAmplify_Percentage() 
return self.slow_heal
end












modifier_custom_juggernaut_blade_fury_silence = class({})

function modifier_custom_juggernaut_blade_fury_silence:IsHidden() return false end

function modifier_custom_juggernaut_blade_fury_silence:IsPurgable() return true end

function modifier_custom_juggernaut_blade_fury_silence:GetTexture() return "silencer_last_word" end

function modifier_custom_juggernaut_blade_fury_silence:CheckState() return {[MODIFIER_STATE_SILENCED] = true} end


function modifier_custom_juggernaut_blade_fury_silence:GetEffectName() return "particles/generic_gameplay/generic_silenced.vpcf" end
 
function modifier_custom_juggernaut_blade_fury_silence:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end











modifier_custom_juggernaut_blade_fury_shard_damage = class({})

function modifier_custom_juggernaut_blade_fury_shard_damage:IsHidden() return true end
function modifier_custom_juggernaut_blade_fury_shard_damage:IsPurgable() return false end
function modifier_custom_juggernaut_blade_fury_shard_damage:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE
}
end

function modifier_custom_juggernaut_blade_fury_shard_damage:GetModifierDamageOutgoing_Percentage()
if IsClient() then return end

return -100 + self:GetAbility():GetSpecialValueFor("shard_damage")
end





modifier_custom_juggernaut_blade_fury_passive_fury = class({})
function modifier_custom_juggernaut_blade_fury_passive_fury:IsHidden() return true end
function modifier_custom_juggernaut_blade_fury_passive_fury:IsPurgable() return false end
function modifier_custom_juggernaut_blade_fury_passive_fury:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_custom_juggernaut_blade_fury_passive_fury:RemoveOnDeath() return false end














modifier_custom_juggernaut_blade_fury_tracker = class({})
function modifier_custom_juggernaut_blade_fury_tracker:IsHidden() return true end
function modifier_custom_juggernaut_blade_fury_tracker:IsPurgable() return false end
function modifier_custom_juggernaut_blade_fury_tracker:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_TAKEDAMAGE,
	MODIFIER_EVENT_ON_ATTACK_LANDED
}

end







function modifier_custom_juggernaut_blade_fury_tracker:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end


if self:GetParent():HasModifier("modifier_juggernaut_bladefury_agility") and not self:GetParent():HasModifier("modifier_custom_juggernaut_blade_fury_mini") then 

	if RollPseudoRandomPercentage(self:GetParent():GetTalentValue("modifier_juggernaut_bladefury_agility", "chance"),194,self:GetParent()) then 
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_juggernaut_blade_fury_mini", {duration = self:GetParent():GetTalentValue("modifier_juggernaut_bladefury_agility", "duration") })
	end

end



end


function modifier_custom_juggernaut_blade_fury_tracker:OnTakeDamage(params)
if not IsServer() then return end
if params.attacker ~= self:GetParent() then return end
if params.unit:IsIllusion() then return end

if (self:GetParent():GetQuest() == "Jugg.Quest_5") and params.unit:IsRealHero() and params.inflictor and params.inflictor == self:GetAbility() then 
	self:GetParent():UpdateQuest(math.floor(params.damage))
end

if not self:GetParent():HasModifier("modifier_juggernaut_bladefury_shield") then return end 

if self:GetParent():HasModifier("modifier_custom_juggernaut_blade_fury") or self:GetParent():HasModifier("modifier_custom_juggernaut_blade_fury_mini") 
	or (params.inflictor and params.inflictor:GetName() == "custom_juggernaut_whirling_blade_custom") then 

	local heal = self:GetParent():GetTalentValue("modifier_juggernaut_bladefury_shield", "heal")*params.damage/100
	if params.unit:IsCreep() then 
		heal = heal/self:GetParent():GetTalentValue("modifier_juggernaut_bladefury_shield", "heal_creeps")
	end 

	self:GetParent():GenericHeal(heal, self:GetAbility(), true)

end

end 


















custom_juggernaut_whirling_blade_custom = class({})



function custom_juggernaut_whirling_blade_custom:GetCooldown(iLevel)

local cd_max = self:GetCaster():GetTalentValue("modifier_juggernaut_bladefury_legendary", "cd_max")
local cd_min = self:GetCaster():GetTalentValue("modifier_juggernaut_bladefury_legendary", "cd_min")

return cd_max - (cd_max - cd_min)*(math.min(1, self:GetCaster():GetAttackSpeed(true)/7))
end


function custom_juggernaut_whirling_blade_custom:GetAOERadius()

return self:GetCaster():FindAbilityByName("custom_juggernaut_blade_fury"):GetSpecialValueFor("radius") + self:GetCaster():GetTalentValue("modifier_juggernaut_bladefury_silence", "radius")
end



function custom_juggernaut_whirling_blade_custom:OnAbilityPhaseStart( )
self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_custom_juggernaut_blade_fury_anim", {})
self:GetCaster():StartGesture(ACT_DOTA_ATTACK_EVENT)
return true 
end


modifier_custom_juggernaut_blade_fury_anim = class({})
function modifier_custom_juggernaut_blade_fury_anim:IsHidden() return true end
function modifier_custom_juggernaut_blade_fury_anim:IsPurgable() return false end
function modifier_custom_juggernaut_blade_fury_anim:DeclareFunctions() return { MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS } end
function modifier_custom_juggernaut_blade_fury_anim:GetActivityTranslationModifiers() return "ti8" end

function modifier_custom_juggernaut_blade_fury_anim:OnAbilityPhaseInterrupted()


self:GetCaster():FadeGesture(ACT_DOTA_ATTACK_EVENT)
local mod = self:GetCaster():FindModifierByName("modifier_custom_juggernaut_blade_fury_anim")
if mod then mod:Destroy() end
end


function custom_juggernaut_whirling_blade_custom:OnSpellStart()
if not IsServer() then return end

self:GetCaster():RemoveModifierByName("modifier_custom_juggernaut_blade_fury_anim")
self:GetCaster():EmitSound("Juggernaut.Whirling_start")
local target = self:GetCursorPosition()

local thinker = CreateModifierThinker( self:GetCaster(), self, "modifier_custom_juggernaut_blade_fury_legendary_thinker", {x = target.x, y = target.y }, self:GetCaster():GetAbsOrigin(), self:GetCaster():GetTeamNumber(), false )

thinker:AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("custom_juggernaut_blade_fury"), "modifier_custom_juggernaut_blade_fury", {})
end


modifier_custom_juggernaut_blade_fury_legendary_thinker = class({})
function modifier_custom_juggernaut_blade_fury_legendary_thinker:IsHidden() return true end
function modifier_custom_juggernaut_blade_fury_legendary_thinker:IsPurgable() return false end
function modifier_custom_juggernaut_blade_fury_legendary_thinker:OnCreated(table)
if not IsServer() then return end
self.fury = self:GetCaster():FindAbilityByName("custom_juggernaut_blade_fury")

	
if self.fury then 
	self.fury:SetActivated(false)
end

self.mod =  self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_juggernaut_blade_fury_passive_fury", {})

local point = Vector(table.x, table.y, self:GetParent():GetAbsOrigin().z)

local speed = self:GetCaster():GetTalentValue("modifier_juggernaut_bladefury_legendary", "speed")

local distance = (point - self:GetParent():GetAbsOrigin()):Length2D()
local duration = distance/speed

self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_juggernaut_blade_fury_legendary_fly", { x = table.x, y = table.y, duration = duration})

self:StartIntervalThink(0.1)
self.sound = false
end


function modifier_custom_juggernaut_blade_fury_legendary_thinker:OnIntervalThink()
if not IsServer() then return end
AddFOWViewer(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), self:GetAbility():GetSpecialValueFor("radius"), 0.1, false)

if self.sound == false then 	
	self:GetParent():EmitSound("Hero_Juggernaut.BladeFuryStart")
	self.sound = true
end

if not self:GetCaster() or self:GetCaster():IsNull() or not self:GetCaster():IsAlive() then 
	self:Destroy()
end

end


function modifier_custom_juggernaut_blade_fury_legendary_thinker:OnDestroy()
if not IsServer() then return end
self:GetParent():StopSound("Hero_Juggernaut.BladeFuryStart")
self:GetCaster():EmitSound("Hero_Juggernaut.BladeFuryStop")

if self.mod then 
	self.mod:Destroy()
end

self.fury = self:GetCaster():FindAbilityByName("custom_juggernaut_blade_fury")


if self.fury and not self:GetCaster():HasModifier("modifier_custom_juggernaut_omnislash") and not self:GetCaster():HasModifier("modifier_custom_juggernaut_blade_fury_passive_fury") then 
	self.fury:SetActivated(true)
end


UTIL_Remove(self:GetParent())
end




modifier_custom_juggernaut_blade_fury_legendary_fly = class({})

function modifier_custom_juggernaut_blade_fury_legendary_fly:IsHidden() return true end

function modifier_custom_juggernaut_blade_fury_legendary_fly:OnCreated(params)
  if not IsServer() then return end


  self.ability        = self:GetAbility()
  self.caster         = self:GetCaster()
  self.parent         = self:GetParent()

  self.knockback_speed = self:GetCaster():GetTalentValue("modifier_juggernaut_bladefury_legendary", "speed")
  self.interval = 0.05

  --self.knockback_distance   = math.max(self.ability.knockback_distance - (self.caster:GetAbsOrigin() - self.parent:GetAbsOrigin()):Length2D(), 50)
  
  self.position = GetGroundPosition(Vector(params.x, params.y, 0), nil)


  
  self.direction = (self.position - self:GetParent():GetAbsOrigin()):Normalized()
  
  self:StartIntervalThink(self.interval)
end

function modifier_custom_juggernaut_blade_fury_legendary_fly:OnIntervalThink()
if not IsServer() then return end

 
  self:GetParent():SetOrigin( self:GetParent():GetAbsOrigin() + self.direction*self.interval*self.knockback_speed )

  --GridNav:DestroyTreesAroundPoint( self.parent:GetOrigin(),  self:GetAbility():GetSpecialValueFor("radius"), true )
end


function modifier_custom_juggernaut_blade_fury_legendary_fly:OnDestroy()
if not IsServer() then return end
	self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_juggernaut_blade_fury_legendary_pause", {duration = self:GetCaster():GetTalentValue("modifier_juggernaut_bladefury_legendary", "duration")})

end

modifier_custom_juggernaut_blade_fury_legendary_pause = class({})
function modifier_custom_juggernaut_blade_fury_legendary_pause:IsPurgable() return false end
function modifier_custom_juggernaut_blade_fury_legendary_pause:OnDestroy()
if not IsServer() then return end

if not self:GetCaster() or self:GetCaster():IsNull() or not self:GetCaster():IsAlive() then 
	return
end


local point = self:GetCaster():GetAbsOrigin()

self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_juggernaut_blade_fury_legendary_fly_back", {})

end







modifier_custom_juggernaut_blade_fury_legendary_fly_back = class({})

function modifier_custom_juggernaut_blade_fury_legendary_fly_back:IsHidden() return true end

function modifier_custom_juggernaut_blade_fury_legendary_fly_back:OnCreated(params)
  if not IsServer() then return end


self:GetParent():EmitSound("Juggernaut.Whirling_start")
  self.ability        = self:GetAbility()
  self.caster         = self:GetCaster()
  self.parent         = self:GetParent()
  self.start = params.start

  self.knockback_speed = self:GetCaster():GetTalentValue("modifier_juggernaut_bladefury_legendary", "speed")
  self.interval = 0.05


  self:StartIntervalThink(self.interval)
end

function modifier_custom_juggernaut_blade_fury_legendary_fly_back:OnIntervalThink()
if not IsServer() then return end

if not self:GetCaster() or self:GetCaster():IsNull() or not self:GetCaster():IsAlive() then 
	return
end

self.direction = (self:GetCaster():GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Normalized()
 
self:GetParent():SetOrigin( self:GetParent():GetAbsOrigin() + self.direction*self.interval*self.knockback_speed )

if  (self:GetCaster():GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D() <= 50 then 
	self:Destroy()
end

end


function modifier_custom_juggernaut_blade_fury_legendary_fly_back:OnDestroy()
if not IsServer() then return end
	self:GetParent():FindModifierByName("modifier_custom_juggernaut_blade_fury_legendary_thinker"):Destroy()

end