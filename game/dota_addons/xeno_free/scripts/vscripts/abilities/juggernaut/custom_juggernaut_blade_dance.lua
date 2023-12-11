LinkLuaModifier("modifier_custom_juggernaut_blade_dance", "abilities/juggernaut/custom_juggernaut_blade_dance.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_blade_dance_buff", "abilities/juggernaut/custom_juggernaut_blade_dance.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_blade_dance_legendary", "abilities/juggernaut/custom_juggernaut_blade_dance.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_blade_dance_legendary_run", "abilities/juggernaut/custom_juggernaut_blade_dance.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_blade_dance_parry", "abilities/juggernaut/custom_juggernaut_blade_dance.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_blade_dance_speed", "abilities/juggernaut/custom_juggernaut_blade_dance.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_blade_dance_mortal", "abilities/juggernaut/custom_juggernaut_blade_dance.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_blade_dance_anim", "abilities/juggernaut/custom_juggernaut_blade_dance.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_blade_dance_slow", "abilities/juggernaut/custom_juggernaut_blade_dance.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_blade_dance_move", "abilities/juggernaut/custom_juggernaut_blade_dance.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_juggernaut_bladedance_double_no", "abilities/juggernaut/custom_juggernaut_blade_dance.lua", LUA_MODIFIER_MOTION_NONE)



custom_juggernaut_blade_dance = class({})



function custom_juggernaut_blade_dance:Precache(context)

PrecacheResource( "particle", "particles/units/heroes/hero_mars/mars_shield_bash_crit_strike.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_mars/mars_shield_bash.vpcf", context )
PrecacheResource( "particle", "particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_v2_trigger.vpcf", context )
PrecacheResource( "particle", "particles/jugg_legendary_proc_.vpcf", context )
PrecacheResource( "particle", "particles/items3_fx/iron_talon_active.vpcf", context )
PrecacheResource( "particle", "particles/jugger_legendary.vpcf", context )
PrecacheResource( "particle", "particles/jugg_parry.vpcf", context )

end




function custom_juggernaut_blade_dance:GetIntrinsicModifierName() return "modifier_custom_juggernaut_blade_dance" end


function custom_juggernaut_blade_dance:GetAbilityTextureName()
    if self:GetCaster():HasModifier("modifier_juggernaut_bladekeeper_weapon") then
        return "juggernaut/bladekeeper/juggernaut_blade_dance"
    end
    if self:GetCaster():HasModifier("modifier_juggernaut_arcana") or self:GetCaster():HasModifier("modifier_juggernaut_arcana_v2") then
        return "juggernaut_blade_dance_arcana"
    end
    return "juggernaut_blade_dance"
end


function custom_juggernaut_blade_dance:GetBehavior()
if self:GetCaster():HasModifier("modifier_juggernaut_bladedance_legendary") then
  return DOTA_ABILITY_BEHAVIOR_NO_TARGET  end
return DOTA_ABILITY_BEHAVIOR_PASSIVE 
end


function custom_juggernaut_blade_dance:GetCooldown(iLevel)
if self:GetCaster():HasModifier("modifier_juggernaut_bladedance_legendary") then 
  return self:GetCaster():GetTalentValue("modifier_juggernaut_bladedance_legendary", "cd")
end 

end

function custom_juggernaut_blade_dance:OnSpellStart()
if not IsServer() then return end



local mod = self:GetCaster():FindModifierByName("modifier_custom_juggernaut_blade_dance_anim")
if mod then mod:Destroy() end

self:GetCaster():EmitSound("Hero_Juggernaut.ArcanaTrigger")
local sound_cast = "Juggernaut.ShockWave"
self:GetCaster():EmitSound(sound_cast)

local range = self:GetCaster():GetTalentValue("modifier_juggernaut_bladedance_legendary", "range")
local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(),self:GetCaster():GetOrigin(), nil, range, DOTA_UNIT_TARGET_TEAM_ENEMY,  DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,   0,  false )


local origin = self:GetCaster():GetOrigin()
local cast_direction = (self:GetCaster():GetAbsOrigin() + self:GetCaster():GetForwardVector()*range - origin):Normalized()
local cast_angle = VectorToAngles( cast_direction ).y
local angle = 140 / 2

-- for each units
local caught = false

for _,enemy in pairs(enemies) do
  local enemy_direction = (enemy:GetOrigin() - origin):Normalized()
  local enemy_angle = VectorToAngles( enemy_direction ).y
  local angle_diff = math.abs( AngleDiff( cast_angle, enemy_angle ) )

  if angle_diff <= angle and not enemy:IsMagicImmune() then

    enemy:EmitSound("BB.Warpath_proc")
    enemy:AddNewModifier(self:GetCaster(), self, "modifier_bashed", {duration = self:GetCaster():GetTalentValue("modifier_juggernaut_bladedance_legendary", "stun")*(1 - enemy:GetStatusResistance())})

    local effect = ParticleManager:CreateParticle( "particles/units/heroes/hero_mars/mars_shield_bash_crit_strike.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy )
    ParticleManager:SetParticleControl( effect, 0, enemy:GetOrigin() )
    ParticleManager:SetParticleControl( effect, 1, enemy:GetOrigin() )
    ParticleManager:ReleaseParticleIndex( effect )

  end
end


local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_mars/mars_shield_bash.vpcf", PATTACH_WORLDORIGIN, self:GetCaster() )
ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
ParticleManager:SetParticleControl( effect_cast, 1, Vector(range,range,range) )
ParticleManager:SetParticleControlForward( effect_cast, 0, cast_direction )
ParticleManager:ReleaseParticleIndex( effect_cast )



self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_custom_juggernaut_blade_dance_legendary", {duration = self:GetCaster():GetTalentValue("modifier_juggernaut_bladedance_legendary", "duration")})
self:UseResources(false, false, false, true)

end


function custom_juggernaut_blade_dance:OnAbilityPhaseStart( )
self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_custom_juggernaut_blade_dance_anim", {})
self:GetCaster():StartGesture(ACT_DOTA_ATTACK_EVENT)
return true 
end


modifier_custom_juggernaut_blade_dance_anim = class({})
function modifier_custom_juggernaut_blade_dance_anim:IsHidden() return true end
function modifier_custom_juggernaut_blade_dance_anim:IsPurgable() return false end
function modifier_custom_juggernaut_blade_dance_anim:DeclareFunctions() return { MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS } end
function modifier_custom_juggernaut_blade_dance_anim:GetActivityTranslationModifiers() return "ti8" end

function custom_juggernaut_blade_dance:OnAbilityPhaseInterrupted()


self:GetCaster():FadeGesture(ACT_DOTA_ATTACK_EVENT)
local mod = self:GetCaster():FindModifierByName("modifier_custom_juggernaut_blade_dance_anim")
if mod then mod:Destroy() end
  end


modifier_custom_juggernaut_blade_dance_legendary = class({})


function modifier_custom_juggernaut_blade_dance_legendary:IsHidden() return false end

function modifier_custom_juggernaut_blade_dance_legendary:IsPurgable() return false end

function modifier_custom_juggernaut_blade_dance_legendary:GetTexture() return "buffs/Blade_dance_legendary" end

function modifier_custom_juggernaut_blade_dance_legendary:CheckState() return {[MODIFIER_STATE_SILENCED] = true} end

function modifier_custom_juggernaut_blade_dance_legendary:OnCreated(table)
self.anim = "ti8"
self.RemoveForDuel = true

self.status = self:GetCaster():GetTalentValue("modifier_juggernaut_bladedance_legendary", "status")
if not IsServer() then return end

local trail_pfx = ParticleManager:CreateParticle("particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_v2_trigger.vpcf", PATTACH_ABSORIGIN, self:GetParent())
ParticleManager:ReleaseParticleIndex(trail_pfx)

self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_juggernaut_blade_dance_legendary_run", {duration = self:GetRemainingTime()})
end


function modifier_custom_juggernaut_blade_dance_legendary:DeclareFunctions()
return
{ 
  MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
  MODIFIER_EVENT_ON_ATTACK_LANDED,
  MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING
}
end


function modifier_custom_juggernaut_blade_dance_legendary:GetModifierStatusResistanceStacking() 
return self.status
end

function modifier_custom_juggernaut_blade_dance_legendary:OnAttackLanded(params)
if self.anim == "ti8" then 
  self.anim = "favor"
else 
  self.anim = "ti8"
end

end
function modifier_custom_juggernaut_blade_dance_legendary:GetActivityTranslationModifiers() return self.anim end

function modifier_custom_juggernaut_blade_dance_legendary:GetEffectName() return "particles/jugger_legendary.vpcf" end
 
function modifier_custom_juggernaut_blade_dance_legendary:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end




modifier_custom_juggernaut_blade_dance_legendary_run = class({})
function modifier_custom_juggernaut_blade_dance_legendary_run:IsHidden() return true end
function modifier_custom_juggernaut_blade_dance_legendary_run:IsPurgable() return false end
function modifier_custom_juggernaut_blade_dance_legendary_run:DeclareFunctions()
  return
  {


    MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS

} end



function modifier_custom_juggernaut_blade_dance_legendary_run:GetActivityTranslationModifiers() return "chase" end









modifier_custom_juggernaut_blade_dance = class({})


function modifier_custom_juggernaut_blade_dance:IsHidden() return true end

function modifier_custom_juggernaut_blade_dance:GetCritDamage()
local damage = self:GetAbility():GetSpecialValueFor("damage") + self:GetCaster():GetTalentValue("modifier_juggernaut_bladedance_chance","damage")

 return damage
end
 
function modifier_custom_juggernaut_blade_dance:DeclareFunctions() 
return 
{
    MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
    MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
    MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
    MODIFIER_EVENT_ON_TAKEDAMAGE,
} 
end


function modifier_custom_juggernaut_blade_dance:GetModifierAttackRangeBonus()
if not self:GetParent():HasModifier("modifier_juggernaut_bladedance_parry") then return end 

return self:GetCaster():GetTalentValue("modifier_juggernaut_bladedance_parry", "range")
end 


function modifier_custom_juggernaut_blade_dance:OnCreated(table)
self.chance = self:GetAbility():GetSpecialValueFor("chance")
self.target = nil
self.damage = self:GetAbility():GetSpecialValueFor("damage")
self.record = nil
    
end



function modifier_custom_juggernaut_blade_dance:OnTakeDamage(params)
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_juggernaut_bladedance_lowhp") then return end
if params.attacker ~= self:GetParent() then return end
if params.inflictor ~= nil then return end
if params.unit:IsBuilding() then return end

if self.record then 

  local heal = params.damage*self:GetCaster():GetTalentValue("modifier_juggernaut_bladedance_lowhp", "heal")/100
  self:GetParent():GenericHeal(heal, self:GetAbility())
end

end



function modifier_custom_juggernaut_blade_dance:GetModifierPreAttack_CriticalStrike( params )
if not IsServer() then return end
if self:GetParent():PassivesDisabled() then return end
if params.target:GetTeamNumber()==self:GetParent():GetTeamNumber() then return end


self.record = nil

self.chance = self:GetAbility():GetSpecialValueFor("chance")

self.chance = self.chance 
        
self.damage = self:GetAbility():GetSpecialValueFor("damage") + self:GetCaster():GetTalentValue("modifier_juggernaut_bladedance_chance","damage")





local random = RollPseudoRandomPercentage(self.chance,12,self:GetParent())
if random or self:GetParent():HasModifier("modifier_custom_juggernaut_blade_dance_legendary") then


  self.record = params.record

  return self.damage
end

end



function modifier_custom_juggernaut_blade_dance:GetModifierProcAttack_Feedback( params )
if not IsServer() then return end
if not self.record or self.record ~= params.record then return end


if self:GetParent():HasModifier("modifier_juggernaut_bladedance_stack") then 

  params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_juggernaut_blade_dance_mortal", { duration = self:GetCaster():GetTalentValue("modifier_juggernaut_bladedance_stack", "duration")})
end
          
          
if self:GetParent():HasModifier("modifier_juggernaut_bladedance_speed") then 
  self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_juggernaut_blade_dance_speed", { duration = self:GetCaster():GetTalentValue("modifier_juggernaut_bladedance_speed", "duration")})
end
          
if self:GetParent():HasModifier("modifier_juggernaut_bladedance_double") then 

  self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_juggernaut_blade_dance_move", {duration = self:GetCaster():GetTalentValue("modifier_juggernaut_bladedance_double", "duration")})
  params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_juggernaut_blade_dance_move", {duration = self:GetCaster():GetTalentValue("modifier_juggernaut_bladedance_double", "duration")})

end

if self:GetParent():HasModifier("modifier_juggernaut_bladedance_parry") then 
  self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_juggernaut_blade_dance_parry", { duration = self:GetCaster():GetTalentValue("modifier_juggernaut_bladedance_parry", "duration")})
end


if (self:GetParent():GetQuest() == "Jugg.Quest_6") and params.target:IsRealHero() then 
    self:GetParent():UpdateQuest(1)
end



local sound_cast = "Hero_Juggernaut.BladeDance"

if params.target and not params.target:IsNull() then 
  params.target:EmitSound(sound_cast)

  
  if self:GetCaster():HasModifier("modifier_juggernaut_bladeform") then
      local crit_start = ParticleManager:CreateParticle("particles/econ/items/juggernaut/armor_of_the_favorite/juggernaut_armor_of_the_favorite_crit.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
      ParticleManager:ReleaseParticleIndex(crit_start)
  end


  if self:GetParent():HasModifier("modifier_juggernaut_arcana") then
      local particle_crit = ParticleManager:CreateParticle("particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_crit_tgt.vpcf", PATTACH_ABSORIGIN_FOLLOW, params.target)
      ParticleManager:SetParticleControlEnt(particle_crit, 1, params.target, PATTACH_ABSORIGIN_FOLLOW, nil, params.target:GetAbsOrigin(), true)
      ParticleManager:ReleaseParticleIndex(particle_crit)
      params.target:EmitSound("Hero_Juggernaut.BladeDance.Arcana")
  elseif self:GetParent():HasModifier("modifier_juggernaut_arcana_v2") then
      local particle_crit = ParticleManager:CreateParticle("particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_v2_crit_tgt.vpcf", PATTACH_ABSORIGIN_FOLLOW, params.target)
      ParticleManager:SetParticleControlEnt(particle_crit, 1, params.target, PATTACH_ABSORIGIN_FOLLOW, nil, params.target:GetAbsOrigin(), true)
      ParticleManager:ReleaseParticleIndex(particle_crit)
      params.target:EmitSound("Hero_Juggernaut.BladeDance.Arcana")
  end

end


end












modifier_custom_juggernaut_blade_dance_parry = class({})

function modifier_custom_juggernaut_blade_dance_parry:IsHidden() return true end
function modifier_custom_juggernaut_blade_dance_parry:IsPurgable() return false end
function modifier_custom_juggernaut_blade_dance_parry:GetTexture() return  "buffs/Blade_dance_parry" end

function modifier_custom_juggernaut_blade_dance_parry:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
}
end



function modifier_custom_juggernaut_blade_dance_parry:OnCreated()

self.reduce = self:GetCaster():GetTalentValue("modifier_juggernaut_bladedance_parry", "damage_reduce")
end 



function modifier_custom_juggernaut_blade_dance_parry:GetModifierIncomingDamage_Percentage()


self:GetParent():EmitSound("Juggernaut.Parry")
local particle = ParticleManager:CreateParticle( "particles/jugg_parry.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
ParticleManager:SetParticleControlEnt( particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_sword", self:GetParent():GetAbsOrigin(), true )
ParticleManager:SetParticleControl( particle, 1, self:GetParent():GetAbsOrigin() )


return self.reduce
end



-----------------------------------------ТАЛАНТ СКОРОСТЬ-----------------------------------------------

modifier_custom_juggernaut_blade_dance_speed = class({})

function modifier_custom_juggernaut_blade_dance_speed:IsHidden() return false end
function modifier_custom_juggernaut_blade_dance_speed:IsPurgable() return true end
function modifier_custom_juggernaut_blade_dance_speed:GetTexture() return  "buffs/Blade_dance_speed" end
function modifier_custom_juggernaut_blade_dance_speed:OnCreated(table)

self.speed =  self:GetCaster():GetTalentValue("modifier_juggernaut_bladedance_speed", "speed")
self.max =  self:GetCaster():GetTalentValue("modifier_juggernaut_bladedance_speed", "max")

if not IsServer() then return end
self:SetStackCount(1)
end 

function modifier_custom_juggernaut_blade_dance_speed:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() < self.max then 
  self:IncrementStackCount()
end
end 

function modifier_custom_juggernaut_blade_dance_speed:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
end


function modifier_custom_juggernaut_blade_dance_speed:GetModifierAttackSpeedBonus_Constant() 
return self:GetStackCount()*self.speed
end



modifier_custom_juggernaut_blade_dance_move = class({})


function modifier_custom_juggernaut_blade_dance_move:IsHidden() return false end
function modifier_custom_juggernaut_blade_dance_move:IsPurgable() return true end
function modifier_custom_juggernaut_blade_dance_move:GetTexture() return  "buffs/Blade_dance_move" end
function modifier_custom_juggernaut_blade_dance_move:GetEffectName() 
if self:GetParent() == self:GetCaster() then 
  return "particles/items3_fx/blink_swift_buff.vpcf" end
end

function modifier_custom_juggernaut_blade_dance_move:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end


function modifier_custom_juggernaut_blade_dance_move:DeclareFunctions()
    return
{
  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
  end



function modifier_custom_juggernaut_blade_dance_move:GetModifierMoveSpeedBonus_Percentage() 
if self:GetParent() == self:GetCaster() then 
  return self.move
else 
  return self.slow
end

end

function modifier_custom_juggernaut_blade_dance_move:OnCreated()

self.slow = self:GetCaster():GetTalentValue("modifier_juggernaut_bladedance_double", "slow")
self.move = self:GetCaster():GetTalentValue("modifier_juggernaut_bladedance_double", "move")

end 




----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------ТАЛАНТ СМЕРТЕЛЬНАЯ РАНА--------------------------------------------------

modifier_custom_juggernaut_blade_dance_mortal = class({})

function modifier_custom_juggernaut_blade_dance_mortal:IsHidden() return false end
function modifier_custom_juggernaut_blade_dance_mortal:IsPurgable() return false end

function modifier_custom_juggernaut_blade_dance_mortal:GetTexture() return  "buffs/Blade_dance_mortal" end

function modifier_custom_juggernaut_blade_dance_mortal:OnCreated(table)
self.damage = self:GetCaster():GetTalentValue("modifier_juggernaut_bladedance_stack", "damage")
self.health = self:GetCaster():GetTalentValue("modifier_juggernaut_bladedance_stack", "health")

if not IsServer() then return end
  
self.RemoveForDuel = true
self.ability = self:GetAbility()
self.caster = self:GetCaster()

if self.caster:IsIllusion() then 
   self.caster = self.caster.owner
end

self:SetStackCount(1)
self:StartIntervalThink(0.1)
end


function modifier_custom_juggernaut_blade_dance_mortal:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
end

function modifier_custom_juggernaut_blade_dance_mortal:OnDestroy()
if not IsServer() then return end

local parent = self:GetParent()

local trail_pfx2 = ParticleManager:CreateParticle("particles/jugg_legendary_proc_.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:DestroyParticle(trail_pfx2, false)
ParticleManager:ReleaseParticleIndex(trail_pfx2)

local trail_pfx = ParticleManager:CreateParticle("particles/items3_fx/iron_talon_active.vpcf", PATTACH_ABSORIGIN, self:GetParent())

ParticleManager:SetParticleControlEnt(trail_pfx, 0, parent, PATTACH_ABSORIGIN_FOLLOW, nil, parent:GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt( trail_pfx, 1, parent, PATTACH_ABSORIGIN_FOLLOW, nil, parent:GetAbsOrigin(), true)
ParticleManager:ReleaseParticleIndex(trail_pfx)
self:GetParent():EmitSound("DOTA_Item.Daedelus.Crit")


ApplyDamage({ victim = self:GetParent(), attacker = self.caster, ability = self.ability, damage = self.damage*self:GetStackCount(), damage_type = DAMAGE_TYPE_PURE})

end

function modifier_custom_juggernaut_blade_dance_mortal:OnIntervalThink()
if not IsServer() then return end
if self:GetParent():GetHealthPercent() > self.health then return end

self:Destroy()
end



function modifier_custom_juggernaut_blade_dance_mortal:DeclareFunctions()
return 
{
  MODIFIER_PROPERTY_TOOLTIP
} 
end



function modifier_custom_juggernaut_blade_dance_mortal:OnTooltip()
return self.damage*self:GetStackCount() 

end





----------------------------------------------------------------------------------------------------------------------------------

modifier_juggernaut_bladedance_double_no = class({})
function modifier_juggernaut_bladedance_double_no:IsHidden() return true end
function modifier_juggernaut_bladedance_double_no:IsPurgable() return false end
