LinkLuaModifier("modifier_custom_phantom_assassin_stifling_dagger_attack", "abilities/phantom_assassin/custom_phantom_assassin_stifling_dagger", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_phantom_assassin_stifling_dagger_slow", "abilities/phantom_assassin/custom_phantom_assassin_stifling_dagger", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_phantom_assassin_stifling_dagger_armor", "abilities/phantom_assassin/custom_phantom_assassin_stifling_dagger", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_phantom_assassin_stifling_dagger_stackig_damage", "abilities/phantom_assassin/custom_phantom_assassin_stifling_dagger", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_phantom_assassin_stifling_dagger_tracker", "abilities/phantom_assassin/custom_phantom_assassin_stifling_dagger", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_phantom_assassin_stifling_dagger_poison", "abilities/phantom_assassin/custom_phantom_assassin_stifling_dagger", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_phantom_assassin_stifling_dagger_poisonstack", "abilities/phantom_assassin/custom_phantom_assassin_stifling_dagger", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_phantom_assassin_stifling_dagger_sleep_thinker", "abilities/phantom_assassin/custom_phantom_assassin_stifling_dagger", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_phantom_assassin_stifling_dagger_sleep", "abilities/phantom_assassin/custom_phantom_assassin_stifling_dagger", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_phantom_assassin_stifling_dagger_sleep_cd", "abilities/phantom_assassin/custom_phantom_assassin_stifling_dagger", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_phantom_assassin_stifling_legendary_stack", "abilities/phantom_assassin/custom_phantom_assassin_stifling_dagger", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_phantom_assassin_stifling_legendary_caster", "abilities/phantom_assassin/custom_phantom_assassin_stifling_dagger", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_phantom_assassin_stifling_blink", "abilities/phantom_assassin/custom_phantom_assassin_stifling_dagger", LUA_MODIFIER_MOTION_HORIZONTAL)


custom_phantom_assassin_stifling_dagger = class({})

custom_phantom_assassin_stifling_dagger.cd_inc = {1, 1.5, 2}

custom_phantom_assassin_stifling_dagger.attack_heal = {20, 30, 40}

custom_phantom_assassin_stifling_dagger.healing_speed = 10
custom_phantom_assassin_stifling_dagger.healing_speed_duration = 3
custom_phantom_assassin_stifling_dagger.jump_speed = 1500
custom_phantom_assassin_stifling_dagger.jump_range = 200

custom_phantom_assassin_stifling_dagger.sleep_radius = 500
custom_phantom_assassin_stifling_dagger.sleep_duration = 2.5
custom_phantom_assassin_stifling_dagger.sleep_delay = 0.5
custom_phantom_assassin_stifling_dagger.sleep_cd = 40
custom_phantom_assassin_stifling_dagger.sleep_heal = 0.15


custom_phantom_assassin_stifling_dagger.legendary_interval = 0.15
custom_phantom_assassin_stifling_dagger.legendary_duration = 8
custom_phantom_assassin_stifling_dagger.legendary_max = 4
custom_phantom_assassin_stifling_dagger.legendary_cast = 0.15


custom_phantom_assassin_stifling_dagger.incoming_damage = {3, 5}
custom_phantom_assassin_stifling_dagger.incoming_heal = {-5, -8}
custom_phantom_assassin_stifling_dagger.incoming_max = 5
custom_phantom_assassin_stifling_dagger.incoming_duration = 7


custom_phantom_assassin_stifling_dagger.poison_inc = 50
custom_phantom_assassin_stifling_dagger.poison_init = 50
custom_phantom_assassin_stifling_dagger.poison_duration = 4




function custom_phantom_assassin_stifling_dagger:Precache(context)
PrecacheResource( "particle", "particles/units/heroes/hero_phantom_assassin/phantom_assassin_attack_blur_b.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_phantom_assassin/phantom_assassin_attack_blur.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_phantom_assassin/phantom_assassin_attack_blur_crit", context )


PrecacheResource( "particle", "particles/units/heroes/hero_phantom_assassin/phantom_assassin_stifling_dagger.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_marci/marci_rebound_allymovespeed.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_phantom_assassin/phantom_assassin_stifling_dagger_debuff.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_centaur/centaur_shard_buff_strength_counter_stack.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_bloodseeker/bloodseeker_bloodbath.vpcf", context )

my_game:PrecacheShopItems("npc_dota_hero_phantom_assassin", context)

end


function custom_phantom_assassin_stifling_dagger:GetAbilityTextureName()
if self:GetCaster():HasModifier("modifier_phantom_assassin_persona_custom") then
  return "phantom_assassin/persona/phantom_assassin_stifling_dagger_persona1"
end

if self:GetCaster():HasModifier("modifier_pa_immortal_helmet_custom") then
    return "phantom_assassin/ti8_immortal_helmet/phantom_assassin_stifling_dagger_immortal"
end
if self:GetCaster():HasModifier("modifier_pa_arcana_custom") then
    return "phantom_assassin_arcana_stifling_dagger"
end
return "phantom_assassin_stifling_dagger"
end






function custom_phantom_assassin_stifling_dagger:GetCastPoint()
if self:GetCaster():HasModifier("modifier_phantom_assassin_dagger_legendary") then return self.legendary_cast
else return 0.3 end end



function custom_phantom_assassin_stifling_dagger:GetIntrinsicModifierName()
if not self:GetCaster():IsRealHero() then return end
return "modifier_custom_phantom_assassin_stifling_dagger_tracker"
end

function custom_phantom_assassin_stifling_dagger:GetAOERadius()
  return self:GetSpecialValueFor("additional_targets_radius")
end


function custom_phantom_assassin_stifling_dagger:GetBehavior()

if self:GetCaster():HasModifier("modifier_phantom_assassin_dagger_heal") then 
  return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_AOE + DOTA_ABILITY_BEHAVIOR_AUTOCAST
end

return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_AOE
end


function custom_phantom_assassin_stifling_dagger:OnSpellStart(target)
  
local caster = self:GetCaster() 



self.target = self:GetCursorTarget()
if target ~= nil then 
  self.target = target
end


local mod = self.target:FindModifierByName("modifier_custom_phantom_assassin_stifling_legendary_stack")

self:Dagger(self.target, 1)

if self:GetCaster():HasModifier("modifier_phantom_assassin_dagger_heal") and self:GetAutoCastState() == true then

  self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_custom_phantom_assassin_stifling_blink", {duration = self.jump_range/self.jump_speed})

  EmitSoundOnLocationWithCaster( self:GetCaster():GetAbsOrigin(), sound_cast_start, self:GetCaster() )

end


if not mod then return end

self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_custom_phantom_assassin_stifling_legendary_caster", {target = self.target:entindex(), count = mod:GetStackCount()})



end




function custom_phantom_assassin_stifling_dagger:Dagger( target, original )

local caster = self:GetCaster()
self.duration = self:GetSpecialValueFor("duration")
local projectile_name = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_stifling_dagger.vpcf"
local projectile_speed = self:GetSpecialValueFor("speed")
local projectile_vision = 450

if self:GetCaster():HasModifier("modifier_phantom_assassin_persona_custom") then
  projectile_name = "particles/units/heroes/hero_phantom_assassin_persona/pa_persona_stifling_dagger.vpcf"
elseif self:GetCaster():HasModifier("modifier_pa_immortal_helmet_custom") then
  projectile_name = "particles/econ/items/phantom_assassin/pa_ti8_immortal_head/pa_ti8_immortal_stifling_dagger.vpcf"
elseif self:GetCaster():HasModifier("modifier_pa_arcana_custom") then
  projectile_name = "particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/phantom_assassin_stifling_dagger_arcana.vpcf"
end

local j = 0
local count = self:GetSpecialValueFor("additional_targets") + 1

if self:GetCaster():HasModifier("modifier_phantom_assassin_dagger_heal") then 

  self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_generic_movespeed", 
  {
    duration = self.healing_speed_duration,
    movespeed = self.healing_speed,
    effect = "particles/units/heroes/hero_marci/marci_rebound_allymovespeed.vpcf"
  })
end



local more_targets = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, self:GetSpecialValueFor("additional_targets_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false)

for _,i in pairs(more_targets) do
  if (j < count ) and (i:GetUnitName() ~= "npc_teleport") and not i:IsCourier() then 
    j = j+1

    local main = 0 

    if i == target then 
      main = 1
    end 

    local origin = 0
    if original == 1 and i == target then 
      origin = 1
    end

    local info = {
        Target = i,
        Source = caster,
        Ability = self, 
        EffectName = projectile_name,
        iMoveSpeed = projectile_speed,
        bReplaceExisting = false,                         
        bProvidesVision = true,                           
        iVisionRadius = projectile_vision,        
        iVisionTeamNumber = caster:GetTeamNumber() ,
        ExtraData = {original = origin, main = main}       
      }
      ProjectileManager:CreateTrackingProjectile(info)

      self:PlayEffects1()
  end
end


end


function custom_phantom_assassin_stifling_dagger:GetCooldown(iLevel)
local upgrade_cooldown = 0 

if self:GetCaster():HasModifier("modifier_phantom_assassin_dagger_cd") then 
  upgrade_cooldown = self.cd_inc[self:GetCaster():GetUpgradeStack("modifier_phantom_assassin_dagger_cd")]
end

 return self.BaseClass.GetCooldown(self, iLevel) - upgrade_cooldown
 
  end




function custom_phantom_assassin_stifling_dagger:OnProjectileHit_ExtraData(hTarget, vLocation, table)
local target = hTarget
if target==nil then return end
if target:IsInvulnerable() then return end
if target:TriggerSpellAbsorb( self ) then return end
  
if table.original and table.original == 1 and self:GetCaster():HasModifier("modifier_phantom_assassin_dagger_legendary") then 
  hTarget:AddNewModifier(self:GetCaster(), self, "modifier_custom_phantom_assassin_stifling_legendary_stack", {duration = self.legendary_duration})
end

local modifier = self:GetCaster():AddNewModifier(self:GetCaster(),self,"modifier_custom_phantom_assassin_stifling_dagger_attack",{main = table.main})


if self:GetCaster():HasModifier("modifier_phantom_assassin_dagger_double") then
  hTarget:AddNewModifier(self:GetCaster(), self, "modifier_custom_phantom_assassin_stifling_dagger_stackig_damage", {duration = self.incoming_duration})
end


if self:GetCaster():HasModifier("modifier_phantom_assassin_dagger_damage") then 
    local damage = self.poison_init + self.poison_inc*self:GetCaster():GetUpgradeStack("modifier_phantom_assassin_dagger_damage")
     
    hTarget:EmitSound("Phantom_Assassin.PoisonImpact")
    hTarget:AddNewModifier(self:GetCaster(), self, "modifier_custom_phantom_assassin_stifling_dagger_poison", {duration = self.poison_duration, damage = damage/self.poison_duration})
    hTarget:AddNewModifier(self:GetCaster(), self, "modifier_custom_phantom_assassin_stifling_dagger_poisonstack", {duration = self.poison_duration})
end

if not hTarget:IsMagicImmune() then 
    hTarget:AddNewModifier(self:GetCaster(),self,"modifier_custom_phantom_assassin_stifling_dagger_slow",{duration = self.duration* (1-hTarget:GetStatusResistance())})
end


if self:GetCaster():GetQuest() == "Phantom.Quest_5" and (hTarget:GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Length2D() >= self:GetCaster().quest.number and hTarget:IsRealHero() then 
  self:GetCaster():UpdateQuest(1)
end


self:GetCaster():PerformAttack(hTarget,true,true,true,false,false,false,true)

--ApplyDamage({ victim = hTarget, attacker = self:GetCaster(), ability = self, damage = self:GetCaster():GetAverageTrueAttackDamage(hTarget), damage_type = DAMAGE_TYPE_PHYSICAL})

--self:GetCaster():PerformAttack(hTarget, true, true, true, false, false, true, true)

if modifier then 
  modifier:Destroy()
end



self:PlayEffects2( hTarget )
end

function custom_phantom_assassin_stifling_dagger:PlayEffects1()
 
  local sound_cast = "Hero_PhantomAssassin.Dagger.Cast"

  
  self:GetCaster():EmitSound( sound_cast  )
end


function custom_phantom_assassin_stifling_dagger:PlayEffects2( target )
  
  local sound_target = "Hero_PhantomAssassin.Dagger.Target"

    target:EmitSound( sound_target  )
end


modifier_custom_phantom_assassin_stifling_dagger_attack = class({})


function modifier_custom_phantom_assassin_stifling_dagger_attack:IsHidden() return true end
function modifier_custom_phantom_assassin_stifling_dagger_attack:IsPurgable() return false end


function modifier_custom_phantom_assassin_stifling_dagger_attack:OnCreated( kv )
self.base_damage = self:GetAbility():GetSpecialValueFor( "base_damage" )  
self.attack_factor = self:GetAbility():GetSpecialValueFor( "attack_factor" )

if not IsServer() then return end 

self.main = kv.main

end


function modifier_custom_phantom_assassin_stifling_dagger_attack:DeclareFunctions()
   return   {
    MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
    MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,

  }

 
end


function modifier_custom_phantom_assassin_stifling_dagger_attack:GetModifierDamageOutgoing_Percentage( params )
  if IsServer() then
    return self.attack_factor
  end
end

function modifier_custom_phantom_assassin_stifling_dagger_attack:GetModifierPreAttack_BonusDamage( params )
  if IsServer() then
    return self.base_damage * 100/(100+self.attack_factor)
  end
end




modifier_custom_phantom_assassin_stifling_dagger_slow = class({})


function modifier_custom_phantom_assassin_stifling_dagger_slow:IsHidden() return false end

function modifier_custom_phantom_assassin_stifling_dagger_slow:IsDebuff() return true end

function modifier_custom_phantom_assassin_stifling_dagger_slow:IsPurgable()  return true   end 


function modifier_custom_phantom_assassin_stifling_dagger_slow:OnCreated( kv )

self.move_slow = self:GetAbility():GetSpecialValueFor( "move_slow" )

if not IsServer() then return end

local particle_name = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_stifling_dagger_debuff.vpcf"
if self:GetCaster():HasModifier("modifier_phantom_assassin_persona_custom") then
  particle_name = "particles/units/heroes/hero_phantom_assassin_persona/pa_persona_stifling_dagger_debuff.vpcf"
elseif self:GetCaster():HasModifier("modifier_pa_immortal_helmet_custom") then
  particle_name = "particles/econ/items/phantom_assassin/pa_ti8_immortal_head/pa_ti8_immortal_dagger_debuff.vpcf"
elseif self:GetCaster():HasModifier("modifier_pa_arcana_custom") then
  particle_name = "particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/phantom_assassin_stifling_dagger_debuff_arcana.vpcf"
end

local particle_debuff = ParticleManager:CreateParticle(particle_name, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
self:AddParticle(particle_debuff, false, false, -1, false, false)

self:StartIntervalThink(FrameTime())
end

function modifier_custom_phantom_assassin_stifling_dagger_slow:OnIntervalThink()
if not IsServer() then return end
 AddFOWViewer(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), 10, FrameTime(), false)
end

function modifier_custom_phantom_assassin_stifling_dagger_slow:OnRefresh( kv )

  self.move_slow = self:GetAbility():GetSpecialValueFor( "move_slow" )  
end



function modifier_custom_phantom_assassin_stifling_dagger_slow:DeclareFunctions()
return {
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    MODIFIER_PROPERTY_TOOLTIP,
    MODIFIER_EVENT_ON_ATTACK_LANDED
  }
end

function modifier_custom_phantom_assassin_stifling_dagger_slow:OnTooltip() return 
  self.move_slow  end

function modifier_custom_phantom_assassin_stifling_dagger_slow:GetModifierMoveSpeedBonus_Percentage()
  return self.move_slow
end


function modifier_custom_phantom_assassin_stifling_dagger_slow:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent() ~= params.target then return end
if self:GetCaster() ~= params.attacker then return end
if not self:GetCaster():HasModifier("modifier_phantom_assassin_dagger_aoe") then return end

local heal = self:GetAbility().attack_heal[self:GetCaster():GetUpgradeStack("modifier_phantom_assassin_dagger_aoe")]
self:GetCaster():Heal(heal, self:GetAbility())

local particle = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
ParticleManager:ReleaseParticleIndex( particle )

SendOverheadEventMessage(self:GetCaster(), 10, self:GetCaster(), heal, nil)

end




---------------------------------------------------------ТАЛАНТ ЛЕГЕНДАРНЫЙ-----------------------------------------------------------------------------------

modifier_custom_phantom_assassin_stifling_dagger_stackig_damage = class({})

function modifier_custom_phantom_assassin_stifling_dagger_stackig_damage:IsHidden() return false end
function modifier_custom_phantom_assassin_stifling_dagger_stackig_damage:GetTexture() return "buffs/dagger_heal" end
function modifier_custom_phantom_assassin_stifling_dagger_stackig_damage:IsPurgable() return true end
function modifier_custom_phantom_assassin_stifling_dagger_stackig_damage:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)

self:GetParent():EmitSound("Phantom_Assassin.LegendaryPosison")
end

function modifier_custom_phantom_assassin_stifling_dagger_stackig_damage:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self:GetAbility().incoming_max then return end
self:IncrementStackCount()


self:GetParent():EmitSound("Phantom_Assassin.LegendaryPosison")
end

function modifier_custom_phantom_assassin_stifling_dagger_stackig_damage:DeclareFunctions()
return 
{ 
  MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
  MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
  MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
  MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE
}
end


function modifier_custom_phantom_assassin_stifling_dagger_stackig_damage:GetModifierIncomingDamage_Percentage()
return self:GetStackCount()*self:GetAbility().incoming_damage[self:GetCaster():GetUpgradeStack("modifier_phantom_assassin_dagger_double")]
end 

function modifier_custom_phantom_assassin_stifling_dagger_stackig_damage:GetModifierLifestealRegenAmplify_Percentage() 
  return self:GetStackCount()*self:GetAbility().incoming_heal[self:GetCaster():GetUpgradeStack("modifier_phantom_assassin_dagger_double")]
end
function modifier_custom_phantom_assassin_stifling_dagger_stackig_damage:GetModifierHealAmplify_PercentageTarget() 
  return self:GetStackCount()*self:GetAbility().incoming_heal[self:GetCaster():GetUpgradeStack("modifier_phantom_assassin_dagger_double")] 
end
function modifier_custom_phantom_assassin_stifling_dagger_stackig_damage:GetModifierHPRegenAmplify_Percentage() 
  return self:GetStackCount()*self:GetAbility().incoming_heal[self:GetCaster():GetUpgradeStack("modifier_phantom_assassin_dagger_double")]
end










modifier_custom_phantom_assassin_stifling_dagger_poison = class({})

function modifier_custom_phantom_assassin_stifling_dagger_poison:IsHidden() return true end

function modifier_custom_phantom_assassin_stifling_dagger_poison:IsPurgable()
  return true  end

 
function modifier_custom_phantom_assassin_stifling_dagger_poison:GetAttributes()
  return MODIFIER_ATTRIBUTE_MULTIPLE 
end



function modifier_custom_phantom_assassin_stifling_dagger_poison:OnCreated(table)
if not IsServer() then return end
self.damage = table.damage
self:StartIntervalThink(1)

end

function modifier_custom_phantom_assassin_stifling_dagger_poison:OnIntervalThink()
if not IsServer() then return end
local tik = self.damage

ApplyDamage({ victim = self:GetParent(), attacker = self:GetCaster(), ability = self:GetAbility(), damage = tik, damage_type = DAMAGE_TYPE_MAGICAL})

SendOverheadEventMessage(self:GetParent(), 9, self:GetParent(), tik, nil)


end



function modifier_custom_phantom_assassin_stifling_dagger_poison:OnDestroy()
if not IsServer() then return end
  local mod = self:GetParent():FindModifierByName("modifier_custom_phantom_assassin_stifling_dagger_poisonstack")
  if mod then
  mod:RemoveStack()
end
end





modifier_custom_phantom_assassin_stifling_dagger_poisonstack = class({})


function modifier_custom_phantom_assassin_stifling_dagger_poisonstack:IsPurgable() return true  end

 

function modifier_custom_phantom_assassin_stifling_dagger_poisonstack:IsDebuff() return true end


function modifier_custom_phantom_assassin_stifling_dagger_poisonstack:GetTexture() return "buffs/dagger_damage" end

function modifier_custom_phantom_assassin_stifling_dagger_poisonstack:OnCreated(table) 
if not IsServer() then return end
self:SetStackCount(1)
 end

 function modifier_custom_phantom_assassin_stifling_dagger_poisonstack:OnRefresh(table) 
if not IsServer() then return end
self:SetStackCount(self:GetStackCount()+1)
 end

 function modifier_custom_phantom_assassin_stifling_dagger_poisonstack:RemoveStack()
if not IsServer() then return end
self:SetStackCount(self:GetStackCount()-1)
if self:GetStackCount() == 0 then self:Destroy() end
 end








modifier_custom_phantom_assassin_stifling_dagger_tracker = class({})
function modifier_custom_phantom_assassin_stifling_dagger_tracker:IsHidden() return true end
function modifier_custom_phantom_assassin_stifling_dagger_tracker:IsPurgable() return false end
function modifier_custom_phantom_assassin_stifling_dagger_tracker:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_MIN_HEALTH,
  MODIFIER_EVENT_ON_TAKEDAMAGE
}
end


function modifier_custom_phantom_assassin_stifling_dagger_tracker:GetMinHealth()

if not IsServer() then return end
if not self:GetParent():IsAlive() then return end
if not self:GetParent():HasModifier("modifier_phantom_assassin_dagger_duration") then return end
if self:GetParent():HasModifier("modifier_custom_phantom_assassin_stifling_dagger_sleep_cd") then return end
if self:GetParent():HasModifier("modifier_death") then return end
if self:GetParent():PassivesDisabled() then return end

return 1
end


function modifier_custom_phantom_assassin_stifling_dagger_tracker:OnTakeDamage(params)
if not IsServer() then return end
if self:GetParent() ~= params.unit then return end
if self:GetParent():GetHealth() > 1 then return end
if self:GetParent():PassivesDisabled() then return end
if not self:GetParent():HasModifier("modifier_phantom_assassin_dagger_duration") then return end
if self:GetParent():HasModifier("modifier_custom_phantom_assassin_stifling_dagger_sleep_cd") then return end
if self:GetParent():HasModifier("modifier_death") then return end

self.caster = self:GetCaster()
self.radius         = self:GetAbility().sleep_radius
self.projectile_speed   = 1000
self.location = self:GetCaster():GetAbsOrigin()
self.duration       = self.radius / self.projectile_speed
  
local heal = self:GetParent():GetMaxHealth()*self:GetAbility().sleep_heal

SendOverheadEventMessage(self:GetParent(), 10, self:GetParent(), heal, nil)

self:GetParent():Heal(heal, self:GetParent())

local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_bloodseeker/bloodseeker_bloodbath.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
ParticleManager:ReleaseParticleIndex( particle )

self:GetCaster():EmitSound("Hero_PhantomAssassin.FanOfKnives.Cast")
self:GetCaster():EmitSound("Phantom_Assassin.Dagger_Sleep")

self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_phantom_assassin_stifling_dagger_sleep_cd", {duration = self:GetAbility().sleep_cd})
CreateModifierThinker(self.caster, self:GetAbility(), "modifier_custom_phantom_assassin_stifling_dagger_sleep_thinker", {duration = self.duration}, self.location, self.caster:GetTeamNumber(), false)
  
end



modifier_custom_phantom_assassin_stifling_dagger_sleep_thinker = class({})


function modifier_custom_phantom_assassin_stifling_dagger_sleep_thinker:OnCreated()
  self.ability  = self:GetAbility()
  self.caster   = self:GetCaster()
  self.parent   = self:GetParent()
  

  self.radius         = self:GetAbility().sleep_radius
  if not IsServer() then return end
  
  self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_phantom_assassin/phantom_assassin_shard_fan_of_knives.vpcf", PATTACH_ABSORIGIN, self.parent)
  ParticleManager:SetParticleControl(self.particle, 0, self:GetParent():GetAbsOrigin())
  ParticleManager:SetParticleControl(self.particle, 3, self:GetParent():GetAbsOrigin())
  self:AddParticle(self.particle, false, false, -1, false, false)
  
  self.hit_enemies = {}
  
  self:StartIntervalThink(FrameTime())
end

function modifier_custom_phantom_assassin_stifling_dagger_sleep_thinker:OnIntervalThink()
  if not IsServer() then return end

  local radius_pct = math.min((self:GetDuration() - self:GetRemainingTime()) / self:GetDuration(), 1)
  
  local enemies = FindUnitsInRadius(self.parent:GetTeamNumber(), self.parent:GetAbsOrigin(), nil, self.radius * radius_pct, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
  
  for _, enemy in pairs(enemies) do
  
    local hit_already = false
  
    for _, hit_enemy in pairs(self.hit_enemies) do
      if hit_enemy == enemy then
        hit_already = true
        break
      end
    end

    if not hit_already and not enemy:IsMagicImmune() then


      enemy:EmitSound("Hero_PhantomAssassin.Attack")
      enemy:EmitSound("Phantom_Assassin.Dagger_Sleep_target")
      local duration = self:GetAbility().sleep_duration*(1 - enemy:GetStatusResistance())
      enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_phantom_assassin_stifling_dagger_sleep", {duration = duration})

      table.insert(self.hit_enemies, enemy)
      

    end

  end

end



modifier_custom_phantom_assassin_stifling_dagger_sleep = class({})
function modifier_custom_phantom_assassin_stifling_dagger_sleep:IsHidden() return false end
function modifier_custom_phantom_assassin_stifling_dagger_sleep:IsPurgable() return true end
function modifier_custom_phantom_assassin_stifling_dagger_sleep:CheckState() return 
  {[MODIFIER_STATE_STUNNED] = true} 
end
function modifier_custom_phantom_assassin_stifling_dagger_sleep:GetEffectName() return "particles/generic_gameplay/generic_sleep.vpcf" end


function modifier_custom_phantom_assassin_stifling_dagger_sleep:GetEffectAttachType()
return PATTACH_OVERHEAD_FOLLOW
end


function modifier_custom_phantom_assassin_stifling_dagger_sleep:DeclareFunctions()
return
{
MODIFIER_EVENT_ON_ATTACK_LANDED
}
end


function modifier_custom_phantom_assassin_stifling_dagger_sleep:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent() ~= params.target then return end
if not params.attacker:IsHero() then return end
if (self.max_duration - self:GetRemainingTime()) <= self:GetAbility().sleep_delay then return end
 
 self:Destroy()
end



function modifier_custom_phantom_assassin_stifling_dagger_sleep:OnCreated(table)
if not IsServer() then return end
self.max_duration = self:GetRemainingTime()
self:GetParent():StartGesture(ACT_DOTA_DISABLED)
end



function modifier_custom_phantom_assassin_stifling_dagger_sleep:OnDestroy()
if not IsServer() then return end
self:GetParent():FadeGesture(ACT_DOTA_DISABLED)
end

modifier_custom_phantom_assassin_stifling_dagger_sleep_cd = class({})
function modifier_custom_phantom_assassin_stifling_dagger_sleep_cd:IsHidden() return false end
function modifier_custom_phantom_assassin_stifling_dagger_sleep_cd:IsPurgable() return false end
function modifier_custom_phantom_assassin_stifling_dagger_sleep_cd:IsDebuff() return true end 
function modifier_custom_phantom_assassin_stifling_dagger_sleep_cd:RemoveOnDeath() return false end
function modifier_custom_phantom_assassin_stifling_dagger_sleep_cd:GetTexture() return "buffs/dagger_sleep" end
function modifier_custom_phantom_assassin_stifling_dagger_sleep_cd:OnCreated(table)
self.RemoveForDuel = true
end



modifier_custom_phantom_assassin_stifling_legendary_stack = class({})
function modifier_custom_phantom_assassin_stifling_legendary_stack:IsHidden() return false end
function modifier_custom_phantom_assassin_stifling_legendary_stack:IsPurgable() return false end
function modifier_custom_phantom_assassin_stifling_legendary_stack:GetTexture() return "buffs/dagger_legendary" end
function modifier_custom_phantom_assassin_stifling_legendary_stack:OnCreated(table)
if not IsServer() then return end

self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_centaur/centaur_shard_buff_strength_counter_stack.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())

self:AddParticle(self.pfx, false, false, -1, false, false)

self:SetStackCount(1)
end

function modifier_custom_phantom_assassin_stifling_legendary_stack:OnRefresh(table)
if not IsServer() then return end
self:IncrementStackCount()

if self:GetStackCount() >= self:GetAbility().legendary_max then 
  self:Destroy()
end

end





function modifier_custom_phantom_assassin_stifling_legendary_stack:OnStackCountChanged(iStackCount)
if not IsServer() then return end

ParticleManager:SetParticleControl(self.pfx, 2, Vector(self:GetStackCount(), 0 , 0))
ParticleManager:SetParticleControlEnt(self.pfx, 3, self:GetParent(), PATTACH_OVERHEAD_FOLLOW, nil , self:GetParent():GetAbsOrigin(), true )
end



modifier_custom_phantom_assassin_stifling_legendary_caster = class({})
function modifier_custom_phantom_assassin_stifling_legendary_caster:IsHidden() return true end
function modifier_custom_phantom_assassin_stifling_legendary_caster:IsPurgable() return false end
function modifier_custom_phantom_assassin_stifling_legendary_caster:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(table.count)
self.target = EntIndexToHScript(table.target)

self:StartIntervalThink(self:GetAbility().legendary_interval)
end

function modifier_custom_phantom_assassin_stifling_legendary_caster:OnIntervalThink()
if not IsServer() then return end
if not self.target or self.target:IsNull() or not self.target:IsAlive() then 
  self:Destroy()
  return
end

self:GetAbility():Dagger(self.target, 0)
self:DecrementStackCount()

if self:GetStackCount() == 0 then 
  self:Destroy()
end

end











modifier_custom_phantom_assassin_stifling_blink = class({})

function modifier_custom_phantom_assassin_stifling_blink:IsDebuff() return false end
function modifier_custom_phantom_assassin_stifling_blink:IsHidden() return true end
function modifier_custom_phantom_assassin_stifling_blink:IsPurgable() return true end

function modifier_custom_phantom_assassin_stifling_blink:OnCreated(kv)
if not IsServer() then return end
self.pfx = ParticleManager:CreateParticle("particles/items_fx/force_staff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())

self:GetParent():RemoveGesture(ACT_DOTA_CAST_ABILITY_1)
self:GetParent():StartGesture(ACT_DOTA_CAST_ABILITY_3)


local particle_cast_end = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_phantom_strike_start.vpcf"
if self:GetCaster():GetModelName() == "models/heroes/phantom_assassin/pa_arcana.vmdl" then 
  particle_cast_end = "particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/pa_arcana_phantom_strike_start.vpcf"
end

local effect_cast_end = ParticleManager:CreateParticle( particle_cast_end, PATTACH_WORLDORIGIN, nil )
ParticleManager:SetParticleControl( effect_cast_end, 0, self:GetParent():GetAbsOrigin() )
ParticleManager:ReleaseParticleIndex( effect_cast_end )


local sound_cast_start = "Hero_PhantomAssassin.Strike.Start"
self:GetParent():EmitSound(sound_cast_end)

self.angle = -1*self:GetParent():GetForwardVector():Normalized()

self.distance = self:GetAbility().jump_range / ( self:GetDuration() / FrameTime())

self.targets = {}

if self:ApplyHorizontalMotionController() == false then
    self:Destroy()
end
end

function modifier_custom_phantom_assassin_stifling_blink:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_DISABLE_TURNING
}
end



function modifier_custom_phantom_assassin_stifling_blink:GetModifierDisableTurning() return 1 end

function modifier_custom_phantom_assassin_stifling_blink:GetStatusEffectName() return "particles/status_fx/status_effect_forcestaff.vpcf" end
function modifier_custom_phantom_assassin_stifling_blink:StatusEffectPriority() return 100 end

function modifier_custom_phantom_assassin_stifling_blink:OnDestroy()
if not IsServer() then return end


EmitSoundOnLocationWithCaster( self:GetParent():GetAbsOrigin(), sound_cast_end, self:GetCaster() )

self:GetParent():InterruptMotionControllers( true )
ParticleManager:DestroyParticle(self.pfx, false)
ParticleManager:ReleaseParticleIndex(self.pfx)

--self:GetParent():FadeGesture(ACT_DOTA_CAST_ABILITY_3)

self:GetParent():Stop()

local dir = self:GetParent():GetForwardVector()
dir.z = 0
self:GetParent():SetForwardVector(dir)
self:GetParent():FaceTowards(self:GetParent():GetAbsOrigin() + dir*10)

ResolveNPCPositions(self:GetParent():GetAbsOrigin(), 128)

local sound_cast_end = "Hero_PhantomAssassin.Strike.End"
self:GetParent():EmitSound(sound_cast_end)

end


function modifier_custom_phantom_assassin_stifling_blink:UpdateHorizontalMotion( me, dt )
if not IsServer() then return end
local pos = self:GetParent():GetAbsOrigin()
GridNav:DestroyTreesAroundPoint(pos, 80, false)
local pos_p = self.angle * self.distance
local next_pos = GetGroundPosition(pos + pos_p,self:GetParent())
self:GetParent():SetAbsOrigin(next_pos)


end

function modifier_custom_phantom_assassin_stifling_blink:OnHorizontalMotionInterrupted()
    self:Destroy()
end


function modifier_custom_phantom_assassin_stifling_blink:CheckState()
return
{
  [MODIFIER_STATE_STUNNED] = true
}
end