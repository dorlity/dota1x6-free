LinkLuaModifier( "modifier_phantom_assassin_phantom_blur", "abilities/phantom_assassin/custom_phantom_assassin_blur", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_phantom_assassin_phantom_smoke", "abilities/phantom_assassin/custom_phantom_assassin_blur", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_phantom_assassin_phantom_reduction", "abilities/phantom_assassin/custom_phantom_assassin_blur", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_phantom_assassin_phantom_stunready", "abilities/phantom_assassin/custom_phantom_assassin_blur", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_phantom_assassin_phantom_absorb_cd", "abilities/phantom_assassin/custom_phantom_assassin_blur", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_phantom_assassin_phantom_absorb", "abilities/phantom_assassin/custom_phantom_assassin_blur", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_blur_slow", "abilities/phantom_assassin/custom_phantom_assassin_blur", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_phantom_assassin_phantom_heal", "abilities/phantom_assassin/custom_phantom_assassin_blur", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_phantom_assassin_phantom_speed", "abilities/phantom_assassin/custom_phantom_assassin_blur", LUA_MODIFIER_MOTION_NONE )


    
custom_phantom_assassin_blur = class({})

custom_phantom_assassin_blur.legendary_duration = 1
custom_phantom_assassin_blur.legendary_hit = 0.5

custom_phantom_assassin_blur.attack_speed = {30, 45, 60}
custom_phantom_assassin_blur.attack_speed_duration = 5

custom_phantom_assassin_blur.absorb_damage = -80
custom_phantom_assassin_blur.absorb_cd = 25
custom_phantom_assassin_blur.absorb_duration = 1.5


custom_phantom_assassin_blur.stun_ready = 2
custom_phantom_assassin_blur.stun_stun = {0.8, 1.2}
custom_phantom_assassin_blur.stun_damage = {0.08, 0.12}
custom_phantom_assassin_blur.stun_creeps = 0.33

custom_phantom_assassin_blur.evasion_bonus = 10
custom_phantom_assassin_blur.evasion = 1
custom_phantom_assassin_blur.evasion_chance = 0.20

custom_phantom_assassin_blur.heal_move = {10, 15, 20}
custom_phantom_assassin_blur.heal_health = {10, 15, 20}
custom_phantom_assassin_blur.heal_duration = 4


custom_phantom_assassin_blur.delay_inc = {0.5, 0.75, 1}





function custom_phantom_assassin_blur:Precache(context)

PrecacheResource( "particle", "particles/units/heroes/hero_phantom_assassin/phantom_assassin_active_start.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_phantom_assassin/phantom_assassin_active_blur.vpcf", context )
PrecacheResource( "particle", "particles/blur_linken.vpcf", context )
PrecacheResource( "particle", "particles/pa_legendary_blur.vpcf", context )
PrecacheResource( "particle", "particles/blur_absorb.vpcf", context )
PrecacheResource( "particle", "particles/pa_blur_attack.vpcf", context )

end

function custom_phantom_assassin_blur:GetAbilityTextureName()

if self:GetCaster():HasModifier("modifier_phantom_assassin_persona_custom") then
  return "phantom_assassin/persona/phantom_assassin_blur_persona1"
end

if self:GetCaster():HasModifier("modifier_pa_shoulder_immortal_red_custom") then
    return "phantom_assassin/pa_fall20_immortal_ability_icon/pa_fall20_immortal_blur_crimson"
end
if self:GetCaster():HasModifier("modifier_pa_shoulder_immortal_custom") then
    return "phantom_assassin/pa_fall20_immortal_ability_icon/pa_fall20_immortal_blur"
end
if self:GetCaster():HasModifier("modifier_pa_arcana_custom") then
    return "phantom_assassin_arcana_blur"
end
return "phantom_assassin_blur"
end





function custom_phantom_assassin_blur:GetIntrinsicModifierName() return "modifier_phantom_assassin_phantom_blur" end


function custom_phantom_assassin_blur:GetBehavior()
 if self:GetCaster():HasShard() then return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE end
return DOTA_ABILITY_BEHAVIOR_NO_TARGET 
end

function custom_phantom_assassin_blur:OnSpellStart()
if not IsServer() then return end
  
  if self:GetCaster():HasShard() then 
   self:GetCaster():Purge(false, true, false, false, false)
end

local particle_name = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_active_start.vpcf"
if self:GetCaster():HasModifier("modifier_phantom_assassin_persona_custom") then
  particle_name = "particles/units/heroes/hero_phantom_assassin_persona/pa_persona_phantom_blur_active_start.vpcf"
elseif self:GetCaster():HasModifier("modifier_pa_shoulder_immortal_red_custom") then
  particle_name = "particles/econ/items/phantom_assassin/pa_crimson_witness_2021/pa_crimson_witness_blur_start.vpcf"
elseif self:GetCaster():HasModifier("modifier_pa_shoulder_immortal_custom") then
  particle_name = "particles/econ/items/phantom_assassin/pa_fall20_immortal_shoulders/pa_fall20_blur_start.vpcf"
end


local particle = ParticleManager:CreateParticle(particle_name, PATTACH_WORLDORIGIN, self:GetCaster())
ParticleManager:SetParticleControl(particle, 0, self:GetCaster():GetAbsOrigin())


ProjectileManager:ProjectileDodge(self:GetCaster())
self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_phantom_assassin_phantom_smoke", { duration = self:GetSpecialValueFor("duration")})

if (self:GetCaster():HasModifier("modifier_phantom_assassin_blur_legendary"))then  
   
  if self:GetCaster():HasModifier("modifier_phantom_assassin_phantom_reduction") then 
    self:GetCaster():RemoveModifierByName("modifier_phantom_assassin_phantom_reduction")
  end

  self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_phantom_assassin_phantom_reduction", {})

end

if self:GetCaster():HasModifier("modifier_phantom_assassin_blur_heal") then 
  self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_phantom_assassin_phantom_heal", {duration = self.heal_duration})
end


if self:GetCaster():HasModifier("modifier_phantom_assassin_blur_chance") then 
  self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_phantom_assassin_phantom_speed", {})
end

local enemy = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE , FIND_CLOSEST, false)
  for _,i in ipairs(enemy) do
    i:AddNewModifier(self:GetCaster(), self, "modifier_blur_slow", {duration = 3})
  end



end



modifier_phantom_assassin_phantom_blur = class({})



function modifier_phantom_assassin_phantom_blur:OnCreated( kv )

  self.caster = self:GetCaster()
  self.evasion = self:GetAbility():GetSpecialValueFor( "evasion" )
  self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
  self.interval = 0.2

 if not IsServer() then return end
  self:StartIntervalThink( self.interval )
end

function modifier_phantom_assassin_phantom_blur:OnRefresh(table)
  self:OnCreated(table)
  end


function modifier_phantom_assassin_phantom_blur:DeclareFunctions()
if self:GetCaster():IsRealHero() then 
  return 
  {
    MODIFIER_PROPERTY_EVASION_CONSTANT, 
    MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK,
    MODIFIER_EVENT_ON_ATTACK_LANDED,
    MODIFIER_PROPERTY_ABSORB_SPELL,
  }
else 
  return 
  {
    MODIFIER_PROPERTY_EVASION_CONSTANT, 
  }

end 

end



function modifier_phantom_assassin_phantom_blur:GetAbsorbSpell(params) 
if not IsServer() then return end

if self:GetParent():PassivesDisabled() then return end
if not self:GetParent():HasModifier("modifier_phantom_assassin_blur_stun") then return end
if self:GetParent():HasModifier("modifier_phantom_assassin_phantom_absorb_cd") then return end
if params.ability:GetCaster():GetTeamNumber() == self:GetParent():GetTeamNumber() then return end

local particle = ParticleManager:CreateParticle("particles/blur_linken.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControlEnt(particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
ParticleManager:ReleaseParticleIndex(particle)

self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_phantom_assassin_phantom_absorb_cd", {duration = self:GetAbility().absorb_cd})
self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_phantom_assassin_phantom_absorb", {duration = self:GetAbility().absorb_duration})

self:GetCaster():EmitSound("PA.Blur_absorb")

return 0
end


function modifier_phantom_assassin_phantom_blur:OnAttackLanded(params)
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_phantom_assassin_blur_legendary") then return end
if params.attacker ~= self:GetParent() then return end

local cd = self:GetAbility():GetCooldownTimeRemaining()
self:GetAbility():EndCooldown()

if cd > self:GetAbility().legendary_hit then 
  self:GetAbility():StartCooldown(cd - self:GetAbility().legendary_hit)
end


end








function modifier_phantom_assassin_phantom_blur:GetModifierTotal_ConstantBlock(params)
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_phantom_assassin_blur_reduction") then return end
if params.target ~= self:GetParent() then return end
if self:GetParent():PassivesDisabled() then return end

local chance = self:GetParent():GetEvasion()*100


chance = chance*self:GetAbility().evasion_chance


local random = RollPseudoRandomPercentage(chance,76,self:GetParent())

if not random then return end

  self:GetParent():EmitSound("Hero_FacelessVoid.TimeDilation.Target") 

local trail_pfx = ParticleManager:CreateParticle("particles/pa_legendary_blur.vpcf", PATTACH_ABSORIGIN, self:GetParent())
   ParticleManager:ReleaseParticleIndex(trail_pfx)


return params.damage*self:GetAbility().evasion

end









function modifier_phantom_assassin_phantom_blur:GetModifierEvasion_Constant() 
if self:GetParent():PassivesDisabled() then return end
local bonus = 0

if self:GetCaster():HasModifier("modifier_phantom_assassin_blur_reduction") then 
  bonus = self:GetAbility().evasion_bonus
end

return self.evasion + bonus

end


function modifier_phantom_assassin_phantom_blur:IsHidden() return true end

function modifier_phantom_assassin_phantom_blur:IsDebuff() return false end

function modifier_phantom_assassin_phantom_blur:IsPurgable() return false end




modifier_phantom_assassin_phantom_smoke = class({})

function modifier_phantom_assassin_phantom_smoke:IsHidden()  return false end
function modifier_phantom_assassin_phantom_smoke:IsDebuff()  return false end
function modifier_phantom_assassin_phantom_smoke:IsPurgable() return false end






function modifier_phantom_assassin_phantom_smoke:OnCreated()
if not self:GetAbility() then self:Destroy() return end
self.RemoveForDuel = true

self.vanish_radius = self:GetAbility():GetSpecialValueFor("radius")

if not IsServer() then return end


local particle_name = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_active_blur.vpcf"
if self:GetCaster():HasModifier("modifier_phantom_assassin_persona_custom") then
  particle_name = "particles/units/heroes/hero_phantom_assassin_persona/pa_persona_phantom_blur_active.vpcf"
elseif self:GetCaster():HasModifier("modifier_pa_shoulder_immortal_red_custom") then
  particle_name = "particles/econ/items/phantom_assassin/pa_crimson_witness_2021/pa_crimson_witness_blur_ambient.vpcf"
elseif self:GetCaster():HasModifier("modifier_pa_shoulder_immortal_custom") then
  particle_name = "particles/econ/items/phantom_assassin/pa_fall20_immortal_shoulders/pa_fall20_blur_ambient.vpcf"
end

local particle_buff = ParticleManager:CreateParticle(particle_name, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
self:AddParticle(particle_buff, false, false, -1, false, false)



self.delay = self:GetAbility():GetSpecialValueFor("delay")

if self:GetParent():HasModifier("modifier_phantom_assassin_blur_delay") then 
  self.delay = self.delay + self:GetAbility().delay_inc[self:GetParent():GetUpgradeStack("modifier_phantom_assassin_blur_delay")]
end

self:GetParent():EmitSound("Hero_PhantomAssassin.Blur")

self.linger = false
self:OnIntervalThink()
self:StartIntervalThink(FrameTime())

end

function modifier_phantom_assassin_phantom_smoke:OnRefresh()
  self:OnCreated()
end

function modifier_phantom_assassin_phantom_smoke:OnIntervalThink()
  if self.linger == true then return end
  
  local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.vanish_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BUILDING + DOTA_UNIT_TARGET_BASIC,  DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_ANY_ORDER, false) 
    
  local count =  0

  for _,unit in pairs(enemies) do 
    if unit:IsCourier() or (unit:IsCreep() and unit:GetTeamNumber() ~= DOTA_TEAM_CUSTOM_5) then  
       
    else 
      count = count + 1
      break
    end
  end


  if count > 0 then 
    self.linger = true
    self:SetDuration(self.delay, true)
    self:StartIntervalThink(-1)
    
  end

end


function modifier_phantom_assassin_phantom_smoke:OnDestroy()
if IsServer() and (self:GetParent():IsConsideredHero() or self:GetParent():IsBuilding() or self:GetParent():IsCreep()) then

    if self:GetParent():HasModifier("modifier_phantom_assassin_blur_legendary") then  
       
      local mod_legen = self:GetParent():FindModifierByName("modifier_phantom_assassin_phantom_reduction")
        if mod_legen then 
          mod_legen:SetDuration(self:GetAbility().legendary_duration,true)
      end

    end

    if self:GetParent():HasModifier("modifier_phantom_assassin_blur_chance") then  
       
      local mod = self:GetParent():FindModifierByName("modifier_phantom_assassin_phantom_speed")
        if mod then 
          mod:SetDuration(self:GetCaster():GetTalentValue("modifier_phantom_assassin_blur_chance", "duration") ,true)
      end

    end

    self:GetParent():EmitSound("Hero_PhantomAssassin.Blur.Break")

    if self:GetParent():HasModifier("modifier_phantom_assassin_blur_blood") then 
      self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_phantom_assassin_phantom_stunready", {duration = self:GetAbility().stun_ready})
    end

  end
end

function modifier_phantom_assassin_phantom_smoke:CheckState()
  return {
    [MODIFIER_STATE_INVISIBLE] = true,
    [MODIFIER_STATE_TRUESIGHT_IMMUNE] = true
  }
end

function modifier_phantom_assassin_phantom_smoke:GetPriority()
  return MODIFIER_PRIORITY_SUPER_ULTRA
end

function modifier_phantom_assassin_phantom_smoke:DeclareFunctions()
  return {
    MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
  }
end

function modifier_phantom_assassin_phantom_smoke:GetModifierInvisibilityLevel()
  return 1
end




---------------------------------------ТАЛАНТ ЛОУ ХП--------------------------------------------


modifier_phantom_assassin_phantom_reduction = class({})


function modifier_phantom_assassin_phantom_reduction:IsPurgable() return true end
function modifier_phantom_assassin_phantom_reduction:IsHidden() return false end
function modifier_phantom_assassin_phantom_reduction:IsDebuff() return false end
function modifier_phantom_assassin_phantom_reduction:RemoveOnDeath() return true end

function modifier_phantom_assassin_phantom_reduction:OnCreated(table)
if not IsServer() then return end
self.parent = self:GetParent()

self.particle_ally_fx = ParticleManager:CreateParticle("particles/blur_absorb.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
ParticleManager:SetParticleControl(self.particle_ally_fx, 0, self.parent:GetAbsOrigin())
self:AddParticle(self.particle_ally_fx, false, false, -1, false, false)  
end


function modifier_phantom_assassin_phantom_reduction:GetTexture()
  return "buffs/Blur_reduction" end

function modifier_phantom_assassin_phantom_reduction:DeclareFunctions()
  return 
{ 
  MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
  MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
  MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
  }
end

function modifier_phantom_assassin_phantom_reduction:GetAbsoluteNoDamagePhysical() return 1 end
function modifier_phantom_assassin_phantom_reduction:GetAbsoluteNoDamagePure() return 1 end
function modifier_phantom_assassin_phantom_reduction:GetAbsoluteNoDamageMagical() return 1 end





modifier_phantom_assassin_phantom_absorb_cd = class({})

function modifier_phantom_assassin_phantom_absorb_cd:IsPurgable() return false end
function modifier_phantom_assassin_phantom_absorb_cd:IsHidden() return false end
function modifier_phantom_assassin_phantom_absorb_cd:GetTexture() return "buffs/Blur_cd" end
function modifier_phantom_assassin_phantom_absorb_cd:IsDebuff() return true end
function modifier_phantom_assassin_phantom_absorb_cd:OnCreated(table)
self.RemoveForDuel = true
end

modifier_phantom_assassin_phantom_absorb = class({})
function modifier_phantom_assassin_phantom_absorb:IsHidden() return false end
function modifier_phantom_assassin_phantom_absorb:IsPurgable() return false end
function modifier_phantom_assassin_phantom_absorb:GetTexture() return "buffs/Blur_cd" end


function modifier_phantom_assassin_phantom_absorb:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
}
end



function modifier_phantom_assassin_phantom_absorb:GetModifierIncomingDamage_Percentage()
return self:GetAbility().absorb_damage
end



function modifier_phantom_assassin_phantom_absorb:OnCreated(table)
if not IsServer() then return end

self.particle_ally_fx = ParticleManager:CreateParticle("particles/blur_absorb.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControl(self.particle_ally_fx, 0, self:GetParent():GetAbsOrigin())
self:AddParticle(self.particle_ally_fx, false, false, -1, false, false) 
end







modifier_phantom_assassin_phantom_stunready = class({})

function modifier_phantom_assassin_phantom_stunready:IsPurgable() return false end
function modifier_phantom_assassin_phantom_stunready:IsHidden() return false end
function modifier_phantom_assassin_phantom_stunready:GetTexture()
  return "buffs/Blur_silence" end

function modifier_phantom_assassin_phantom_stunready:DeclareFunctions()
  return 
{
  MODIFIER_EVENT_ON_ATTACK_LANDED

}
end

function modifier_phantom_assassin_phantom_stunready:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end
if params.target:IsBuilding() then return end

local damage = self:GetAbility().stun_damage[self:GetCaster():GetUpgradeStack("modifier_phantom_assassin_blur_blood")]*params.target:GetMaxHealth()
if params.target:IsCreep() then 
  damage = damage*self:GetAbility().stun_creeps
end

params.target:EmitSound("PA.Blur_attack")

local effect_cast = ParticleManager:CreateParticle( "particles/pa_blur_attack.vpcf", PATTACH_OVERHEAD_FOLLOW, params.target )
ParticleManager:SetParticleControl( effect_cast, 0,  params.target:GetOrigin() )
ParticleManager:SetParticleControl( effect_cast, 1, params.target:GetOrigin() )


ApplyDamage({ victim = params.target, attacker = self:GetCaster(), ability = self:GetAbility(), damage = damage, damage_type = DAMAGE_TYPE_PURE})

SendOverheadEventMessage(params.target, 4, params.target, damage, nil)


params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_stunned", {duration = self:GetAbility().stun_stun[self:GetCaster():GetUpgradeStack("modifier_phantom_assassin_blur_blood")]*(1 - params.target:GetStatusResistance())})
self:Destroy()


end






------------------------------------------------------------------------------------------------------------------------------------------

modifier_blur_slow = class({})
function modifier_blur_slow:IsHidden() return false end
function modifier_blur_slow:IsPurgable() return true end
function modifier_blur_slow:DeclareFunctions()
return 
{
  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end

function modifier_blur_slow:GetModifierMoveSpeedBonus_Percentage() return -50 end





modifier_phantom_assassin_phantom_heal = class({})
function modifier_phantom_assassin_phantom_heal:IsHidden() return false end
function modifier_phantom_assassin_phantom_heal:IsPurgable() return false end
function modifier_phantom_assassin_phantom_heal:GetTexture() return "buffs/Blur_heal" end

function modifier_phantom_assassin_phantom_heal:OnCreated(table)
self.regen = self:GetAbility().heal_health[self:GetParent():GetUpgradeStack("modifier_phantom_assassin_blur_heal")]/self:GetRemainingTime()
end

function modifier_phantom_assassin_phantom_heal:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end


function modifier_phantom_assassin_phantom_heal:GetModifierHealthRegenPercentage()
return self.regen
end


function modifier_phantom_assassin_phantom_heal:GetModifierMoveSpeedBonus_Percentage()
return self:GetAbility().heal_move[self:GetParent():GetUpgradeStack("modifier_phantom_assassin_blur_heal")]
end





modifier_phantom_assassin_phantom_speed = class({})
function modifier_phantom_assassin_phantom_speed:IsHidden() return false end
function modifier_phantom_assassin_phantom_speed:IsPurgable() return false end
function modifier_phantom_assassin_phantom_speed:GetTexture() return "buffs/Blur_blood" end


function modifier_phantom_assassin_phantom_speed:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
  MODIFIER_EVENT_ON_ATTACK_LANDED
}
end



function modifier_phantom_assassin_phantom_speed:GetModifierAttackSpeedBonus_Constant()
return self.speed
end


function modifier_phantom_assassin_phantom_speed:OnAttackLanded(params)
if not IsServer() then return  end 
if self:GetParent() ~= params.attacker then return end 
if not params.target:IsHero() and not params.target:IsCreep() then return end 

local real_damage = ApplyDamage({victim = params.target, attacker = self:GetParent(), ability = self:GetAbility(), damage = self.damage, damage_type = DAMAGE_TYPE_PURE})

params.target:SendNumber(4, real_damage)

end 


function modifier_phantom_assassin_phantom_speed:OnCreated()
self.damage = self:GetCaster():GetTalentValue("modifier_phantom_assassin_blur_chance", "damage")
self.speed = self:GetCaster():GetTalentValue("modifier_phantom_assassin_blur_chance", "speed")

end