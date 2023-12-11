LinkLuaModifier("modifier_custom_juggernaut_omnislash", "abilities/juggernaut/custom_juggernaut_omnislash.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_omnislash_check", "abilities/juggernaut/custom_juggernaut_omnislash.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_omnislash_cd", "abilities/juggernaut/custom_juggernaut_omnislash.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_omnislash_effect", "abilities/juggernaut/custom_juggernaut_omnislash.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_omnislash_root", "abilities/juggernaut/custom_juggernaut_omnislash.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_omnislash_blink", "abilities/juggernaut/custom_juggernaut_omnislash.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_omnislash_regen", "abilities/juggernaut/custom_juggernaut_omnislash.lua", LUA_MODIFIER_MOTION_NONE)


custom_juggernaut_omnislash = class({})


custom_juggernaut_swift_slash = class({})







function custom_juggernaut_omnislash:Precache(context)

PrecacheResource( "particle", "particles/units/heroes/hero_juggernaut/juggernaut_omni_slash_trail.vpcf", context )
PrecacheResource( "particle", "particles/status_fx/status_effect_omnislash.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_juggernaut/juggernaut_omni_slash_tgt.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_juggernaut/juggernaut_omni_slash_tgt_scepter.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_juggernaut/juggernaut_omni_slash_trail_scepter.vpcf", context )
PrecacheResource( "particle", "particles/jugg_omni_aoe.vpcf", context )
PrecacheResource( "particle", "particles/jugger_stack.vpcf", context )
PrecacheResource( "particle", "particles/jugg_omni_proc.vpcf", context )
PrecacheResource( "particle", "particles/beast_root.vpcf", context )
PrecacheResource( "particle", "particles/status_fx/status_effect_huskar_lifebreak.vpcf", context )

end




function custom_juggernaut_omnislash:GetAbilityTextureName()
    if self:GetCaster():HasModifier("modifier_juggernaut_bladekeeper_weapon") then
        return "juggernaut/bladekeeper/juggernaut_omni_slash"
    end
    if self:GetCaster():HasModifier("modifier_juggernaut_arcana") or self:GetCaster():HasModifier("modifier_juggernaut_arcana_v2") then
        return "juggernaut_omni_slash_arcana"
    end
    return "juggernaut_omni_slash"
end



function custom_juggernaut_swift_slash:GetCastPoint()
if self:GetCaster():HasModifier("modifier_juggernaut_omnislash_legendary") then 
  return self:GetCaster():GetTalentValue("modifier_juggernaut_omnislash_legendary", "cast")
else 
  return 0.3 
end 

end



function custom_juggernaut_omnislash:GetCastPoint()
if self:GetCaster():HasModifier("modifier_juggernaut_omnislash_legendary") then 
  return self:GetCaster():GetTalentValue("modifier_juggernaut_omnislash_legendary", "cast")
else 
  return 0.3 
end 

end


function custom_juggernaut_omnislash:GetCooldown(iLevel)

if self:GetCaster():HasModifier("modifier_juggernaut_omnislash_legendary") then 
  return self:GetCaster():GetTalentValue("modifier_juggernaut_omnislash_legendary", "cd")
end

return self.BaseClass.GetCooldown(self, iLevel)

end



function custom_juggernaut_omnislash:GetAOERadius() 
if self:GetCaster():HasModifier("modifier_juggernaut_omnislash_legendary") then 
  return self:GetCaster():GetTalentValue("modifier_juggernaut_omnislash_legendary", "radius")
end
return 0
end

function custom_juggernaut_omnislash:GetBehavior()
if self:GetCaster():HasModifier("modifier_juggernaut_omnislash_legendary") then
    return DOTA_ABILITY_BEHAVIOR_AOE + DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK  end
 return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK
end


function custom_juggernaut_omnislash:GetCastRange(vLocation, hTarget)
if self:GetCaster():HasModifier("modifier_juggernaut_omnislash_legendary") then 
  if IsClient() then 
    return self:GetCaster():GetTalentValue("modifier_juggernaut_omnislash_legendary", "range")
  end
  return 999999
end
 return self.BaseClass.GetCastRange(self , vLocation , hTarget)
end



function custom_juggernaut_omnislash:GetIntrinsicModifierName()
if self:GetCaster():IsRealHero()  then  return "modifier_omnislash_check" end
end



function custom_juggernaut_omnislash:GetManaCost(iLevel)
if self:GetCaster():HasModifier("modifier_juggernaut_omnislash_legendary") then 
  return self:GetCaster():GetTalentValue("modifier_juggernaut_omnislash_legendary", "mana")
else 
  return self:GetSpecialValueFor("mana")
end

end



function custom_juggernaut_omnislash:OnSpellStart(target)

if self:GetCaster():HasModifier("modifier_juggernaut_omnislash_legendary") then 
    
  self.target = self:GetCursorPosition()
  local distance = (self.target - self:GetCaster():GetAbsOrigin())
  local range = self:GetCaster():GetTalentValue("modifier_juggernaut_omnislash_legendary", "range")  + self:GetCaster():GetCastRangeBonus()

  if distance:Length2D() > range then 
    self.target = self:GetCaster():GetAbsOrigin() + distance:Normalized()*range
  end 

else 

  if target then 
    self.target = target:GetAbsOrigin()
  else 
    self.target = self:GetCursorTarget():GetAbsOrigin()
  end
end

self:GetCaster():Purge(false, true, false, false, false)
self.duration = self:GetSpecialValueFor("duration")

if self:GetCaster():HasModifier("modifier_juggernaut_omnislash_legendary") then 
  self.duration = self:GetCaster():GetTalentValue("modifier_juggernaut_omnislash_legendary", "duration")
end

if self:GetCaster():IsIllusion() then 
  self.duration = 1
end 

if not IsServer() then return end

if (self:GetCaster():HasModifier("modifier_juggernaut_arcana") or self:GetCaster():HasModifier("modifier_juggernaut_arcana_v2")) then 

    local name = "particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_v2_omni_dash.vpcf"
    if self:GetCaster():HasModifier("modifier_juggernaut_arcana") then 
      name = "particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_omni_dash.vpcf"
    end 

    local hTarget = self:GetCursorTarget() or nil
    local hParent = self:GetCaster()

    local vDirection = self.target - hParent:GetAbsOrigin()
    vDirection.z = 0
    local vPosition = self.target + vDirection:Normalized() * (hParent:GetHullRadius() + 70)

    local iParticleID = ParticleManager:CreateParticle(name, PATTACH_CUSTOMORIGIN, hParent)
    ParticleManager:SetParticleControl(iParticleID, 0, hParent:GetAbsOrigin())
    ParticleManager:SetParticleControlForward(iParticleID, 0, -vDirection:Normalized())

    if self:GetCursorTarget() then 

      ParticleManager:SetParticleControlEnt(iParticleID, 1, hTarget, PATTACH_ABSORIGIN_FOLLOW, nil, hTarget:GetAbsOrigin(), true)
      ParticleManager:SetParticleControlEnt(iParticleID, 2, hTarget, PATTACH_ABSORIGIN_FOLLOW, nil, hTarget:GetAbsOrigin(), true)
    else 

      ParticleManager:SetParticleControl(iParticleID, 1, self.target)
      ParticleManager:SetParticleControl(iParticleID, 2, self.target)
    end

    ParticleManager:ReleaseParticleIndex(iParticleID)

end 

self:Omnislash(self:GetCaster(), self.target, self.duration, false)

end

  



function custom_juggernaut_omnislash:Omnislash( caster , target , duration)
if not IsServer() then return end
self.caster = caster

self.juggernaut_tgt_particle = "particles/units/heroes/hero_juggernaut/juggernaut_omni_slash_tgt.vpcf"

if self:GetCaster():HasModifier("modifier_juggernaut_arcana_v2") then
    self.juggernaut_tgt_particle = "particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_v2_omni_slash_tgt.vpcf"
elseif self:GetCaster():HasModifier("modifier_juggernaut_arcana") then
    self.juggernaut_tgt_particle = "particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_omni_slash_tgt.vpcf"
elseif self:GetCaster():HasModifier("modifier_juggernaut_bladekeeper_weapon") then
    self.juggernaut_tgt_particle = "particles/econ/items/juggernaut/bladekeeper_omnislash/_dc_juggernaut_omni_slash_tgt.vpcf"
elseif self:GetCaster():HasModifier("modifier_juggernaut_item_custom_serrakura") then
    self.juggernaut_tgt_particle = "particles/econ/items/juggernaut/jugg_serrakura/juggernaut_omni_slash_tgt_serrakura.vpcf"
elseif self:GetCaster():HasModifier("modifier_juggernaut_bladeform") then
    self.juggernaut_tgt_particle = "particles/econ/items/juggernaut/pw_blossom_sword/juggernaut_omni_slash_tgt.vpcf"
end

self.juggernaut_trail_particle = "particles/units/heroes/hero_juggernaut/juggernaut_omni_slash_trail.vpcf"
if self:GetCaster():HasModifier("modifier_juggernaut_arcana_v2") then
    self.juggernaut_trail_particle = "particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_v2_omni_slash_trail.vpcf"
elseif self:GetCaster():HasModifier("modifier_juggernaut_arcana") then
    self.juggernaut_trail_particle = "particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_omni_slash_trail.vpcf"
elseif self:GetCaster():HasModifier("modifier_juggernaut_bladekeeper_weapon") then
    self.juggernaut_trail_particle = "particles/econ/items/juggernaut/bladekeeper_omnislash/_dc_juggernaut_omni_slash_trail.vpcf"
elseif self:GetCaster():HasModifier("modifier_juggernaut_item_custom_serrakura") then
    self.juggernaut_trail_particle = "particles/econ/items/juggernaut/jugg_serrakura/juggernaut_omni_slash_trail_serrakura.vpcf"
elseif self:GetCaster():HasModifier("modifier_juggernaut_bladeform") then
    self.juggernaut_trail_particle = "particles/econ/items/juggernaut/pw_blossom_sword/juggernaut_omni_slash_trail.vpcf"
end


if caster:HasModifier("modifier_custom_juggernaut_omnislash") then 
  caster:RemoveModifierByName("modifier_custom_juggernaut_omnislash")
end

self.caster:EmitSound("Hero_Juggernaut.OmniSlash")

local position = self.caster:GetAbsOrigin()
FindClearSpaceForUnit(self.caster, target, false)

local radius = 10
if self.caster:HasModifier("modifier_juggernaut_omnislash_legendary") then 
  radius = self:GetCaster():GetTalentValue("modifier_juggernaut_omnislash_legendary", "radius")
end

local targets = FindUnitsInRadius(self.caster:GetTeamNumber(), target, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
local first_target = nil 

for _,i in ipairs(targets) do 
   if not i:IsCourier() and i:GetUnitName() ~= "npc_teleport" then 
      first_target = i
      break
  end
end

if first_target == nil then 


  if self.caster:HasModifier("modifier_juggernaut_omnislash_legendary") then  

    if self.caster:HasModifier("modifier_custom_juggernaut_omnislash_effect") then 
      self.caster:RemoveModifierByName("modifier_custom_juggernaut_omnislash_effect")
    end
    self.caster:AddNewModifier(self.caster, self, "modifier_custom_juggernaut_omnislash_effect", {duration = 0.5})

  end

else 
   
  self.caster:AddNewModifier(self.caster, self, "modifier_custom_juggernaut_omnislash", {duration = duration, first_target = first_target:entindex(), scepter = false})
end   

if self.caster:IsRealHero() then 
   PlayerResource:SetCameraTarget(self.caster:GetPlayerOwnerID(), self.caster)
  PlayerResource:SetCameraTarget(self.caster:GetPlayerOwnerID(), nil)
end


local position2 = self.caster:GetAbsOrigin()




local particle = ParticleManager:CreateParticle(self.juggernaut_trail_particle, PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(particle, 0, position)
ParticleManager:SetParticleControl(particle, 1, position2)
ParticleManager:ReleaseParticleIndex(particle)


end






modifier_custom_juggernaut_omnislash = class({})

function modifier_custom_juggernaut_omnislash:IsPurgable() return false end

function modifier_custom_juggernaut_omnislash:OnCreated(table)

self.root_target = nil

local omni = self:GetAbility()
self.damage = omni:GetSpecialValueFor("damage")
self.speed = omni:GetSpecialValueFor("speed")
self.radius = omni:GetSpecialValueFor("radius")

self.ishitting = false
self.lastenemy = nil

self.stack_damage = self:GetCaster():GetTalentValue("modifier_juggernaut_omnislash_cd", "damage")/100


if not IsServer() then return end 

self.damage = 0

self.ability = self:GetParent():FindAbilityByName("custom_juggernaut_omnislash")
if table.scepter == 1 then 
  self.ability = self:GetParent():FindAbilityByName("custom_juggernaut_swift_slash")
  self:SetStackCount(1)
end
self.scepter = table.scepter


self.juggernaut_trail_particle = self:GetAbility().juggernaut_trail_particle
self.juggernaut_tgt_particle = self:GetAbility().juggernaut_tgt_particle


self.arcana = self.juggernaut_trail_particle == "particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_omni_slash_trail.vpcf" or self.juggernaut_trail_particle == "particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_v2_omni_slash_trail.vpcf"

self.first_target = EntIndexToHScript(table.first_target)


self.turn = self:GetCaster():GetForwardVector()

self.omni = self:GetParent():FindAbilityByName("custom_juggernaut_omnislash")
--if self.omni then  self.omni:SetActivated(false) end 

self.fury = self:GetParent():FindAbilityByName("custom_juggernaut_blade_fury")
if self.fury then  self.fury:SetActivated(false) end 

self.crit = self:GetParent():FindAbilityByName("custom_juggernaut_blade_dance")
if self.crit and self:GetParent():HasModifier("modifier_juggernaut_bladedance_legendary") then  self.crit:SetActivated(false) end 



self:SetHasCustomTransmitterData(true)

self.bonusrate = omni:GetSpecialValueFor("bonus_rate")


Timers:CreateTimer(FrameTime(),function()
  self:slash(true)
  self.rate = (1/self:GetParent():GetAttacksPerSecond())/self.bonusrate
  self:StartIntervalThink(self.rate)    
end)

end

 


function modifier_custom_juggernaut_omnislash:StatusEffectPriority()
    return 999999
end

function modifier_custom_juggernaut_omnislash:GetStatusEffectName()
if self:GetStackCount() == 0 then 

  if self:GetParent():HasModifier("modifier_juggernaut_arcana") then 
    return "particles/econ/items/juggernaut/jugg_arcana/status_effect_jugg_arcana_omni.vpcf"
  end 

  if self:GetParent():HasModifier("modifier_juggernaut_arcana_v2") then 
    return "particles/econ/items/juggernaut/jugg_arcana/status_effect_jugg_arcana_v2_omni.vpcf"
  end 

  return "particles/status_fx/status_effect_omnislash.vpcf"
else 
  return "particles/status_fx/status_effect_swiftslash.vpcf"
end 

end 


function modifier_custom_juggernaut_omnislash:OnIntervalThink()

self.rate = (1/self:GetParent():GetAttacksPerSecond())/(self.bonusrate)
self:slash()
self:StartIntervalThink(self.rate)
end

function modifier_custom_juggernaut_omnislash:TargetNear( target , near )
if not IsServer() then return end

for _,i in ipairs(near) do 
  if i == target then return true end
end

return false
end



function modifier_custom_juggernaut_omnislash:slash( first )
if not IsServer() then return end

local order = FIND_ANY_ORDER

if first then
  order = FIND_CLOSEST
  number = 1 
else 
  number = number + 1 
end

self.ishitting = false

local target = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS  + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, order, false)
    
if #target >= 1 then 

  for _,enemy in ipairs(target) do

    local can_hit = true



    if enemy:GetUnitName() == "npc_teleport" or enemy:IsCourier() then can_hit = false end

    if can_hit == true then

      self.ishitting = true
      self:GetParent():RemoveGesture(ACT_DOTA_OVERRIDE_ABILITY_4)
      self:GetParent():StartGesture(ACT_DOTA_OVERRIDE_ABILITY_4)

      local position1 = self:GetParent():GetAbsOrigin()

      if number%2 ~= 0 then       
        local position = (enemy:GetAbsOrigin() - (self.turn)*70)
        FindClearSpaceForUnit(self:GetParent(), position, false)
      else 
        local position = (enemy:GetAbsOrigin() + (self.turn)*70)
        FindClearSpaceForUnit(self:GetParent(), position, false)   
      end


      if number ~= 1 then  
          
        local angel = (enemy:GetAbsOrigin() - self:GetParent():GetAbsOrigin())
        angel.z = 0.0
        angel = angel:Normalized()

        self:GetParent():SetForwardVector(angel)
        self:GetParent():FaceTowards(enemy:GetAbsOrigin())
      
      end

      local position2 = self:GetParent():GetAbsOrigin()


      local linken = false 
      if first and self:GetParent():IsRealHero() and self:GetCaster():GetName() == "npc_dota_hero_juggernaut" and not self:GetParent():HasModifier("modifier_juggernaut_omnislash_legendary")  then 
        if enemy:TriggerSpellAbsorb(self.ability) then 
          linken = true
        end
      end

      if linken == false then

        self:GetParent():PerformAttack(enemy, true, true, true, false, false, false, false)
        self.root_target = enemy

        enemy:EmitSound("Hero_Juggernaut.OmniSlash")
      end


      local effect = self.juggernaut_tgt_particle
      if self.scepter == 1 then effect = "particles/units/heroes/hero_juggernaut/juggernaut_omni_slash_tgt_scepter.vpcf" end

      if self.arcana == true and self.scepter == 0 then 
          local particle = ParticleManager:CreateParticle( effect, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
          ParticleManager:SetParticleControlEnt( particle, 0, enemy, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true )
          ParticleManager:SetParticleControlEnt( particle, 1, enemy, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true )
          ParticleManager:ReleaseParticleIndex(particle)

      else 
         local particle = ParticleManager:CreateParticle( effect, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
          ParticleManager:SetParticleControlEnt( particle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_sword", self:GetCaster():GetAbsOrigin(), true )
          ParticleManager:SetParticleControl( particle, 1, position2 )
          ParticleManager:ReleaseParticleIndex(particle)
      end

   
      effect = self.juggernaut_trail_particle
      if self.scepter == 1 then effect = "particles/units/heroes/hero_juggernaut/juggernaut_omni_slash_trail_scepter.vpcf" end

      local trail_pfx = ParticleManager:CreateParticle(effect, PATTACH_ABSORIGIN, self:GetParent())
      ParticleManager:SetParticleControl(trail_pfx, 0, position1)
      ParticleManager:SetParticleControl(trail_pfx, 1, position2)
      ParticleManager:ReleaseParticleIndex(trail_pfx)


      self.lastenemy = enemy
      return

    end
  end
end

Timers:CreateTimer(0.15,function()
if self then 

  if self ~= nil and not self:IsNull() and self.ishitting == false and self:GetParent() ~= nil then

    if not self:GetParent():IsRealHero() then 
      self:GetParent():ForceKill(false)
    end  
    
    self:Destroy() 
  end

end

end)
   
end

function modifier_custom_juggernaut_omnislash:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
  MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
  MODIFIER_PROPERTY_IGNORE_CAST_ANGLE,
  MODIFIER_EVENT_ON_ATTACK_LANDED,
  MODIFIER_EVENT_ON_TAKEDAMAGE
}
end

function modifier_custom_juggernaut_omnislash:OnTakeDamage(params)
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_juggernaut_omnislash_cd") then return end
if self:GetParent() ~= params.attacker then return end

self.damage = self.damage + params.damage*self.stack_damage

end



function modifier_custom_juggernaut_omnislash:OnAttackLanded( params )
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end

if self:GetParent():HasModifier("modifier_juggernaut_omnislash_heal") then 

  local heal = self:GetCaster():GetTalentValue("modifier_juggernaut_omnislash_heal", "heal")

  self:GetParent():GenericHeal( heal, self.omni)

end
 
if self:GetParent():HasModifier("modifier_juggernaut_omnislash_speed") then 

  local damage = self:GetCaster():GetTalentValue("modifier_juggernaut_omnislash_speed", "damage")

  local damageTable = 
  {
    attacker = self:GetParent(),
    damage_type = DAMAGE_TYPE_MAGICAL,
    ability = self.omni,
    damage = damage
  }

  local targets = FindUnitsInRadius(self:GetParent():GetTeamNumber(), params.target:GetAbsOrigin(), nil, self:GetCaster():GetTalentValue("modifier_juggernaut_omnislash_speed", "radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, FIND_CLOSEST, false)

  local particle = ParticleManager:CreateParticle("particles/jugg_omni_aoe.vpcf", PATTACH_WORLDORIGIN, nil)  
  ParticleManager:SetParticleControl(particle, 0, params.target:GetAbsOrigin())

  for _,target in pairs(targets) do
    damageTable.victim = target
    ApplyDamage(damageTable)


    local particle_cast = "particles/units/heroes/hero_juggernaut/juggernaut_blade_fury_tgt.vpcf"
    local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
    ParticleManager:ReleaseParticleIndex( effect_cast )
  end

end

end




function modifier_custom_juggernaut_omnislash:GetModifierAttackSpeedBonus_Constant()
local bonus = 0
local omni = self:GetParent():FindAbilityByName("custom_juggernaut_omnislash")

return self.speed + self:GetCaster():GetTalentValue("modifier_juggernaut_omnislash_stack", "speed")
end



function modifier_custom_juggernaut_omnislash:GetModifierPreAttack_BonusDamage() return self.damage end


function modifier_custom_juggernaut_omnislash:OnDestroy()
if not IsServer() then return end

if self:GetParent():HasModifier("modifier_juggernaut_arcana") then 

  local arcana_particle = ParticleManager:CreateParticle("particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_omni_end.vpcf", PATTACH_POINT_FOLLOW, self:GetParent() )
  ParticleManager:SetParticleControlEnt(  arcana_particle, 2, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true )
  ParticleManager:SetParticleControlEnt(  arcana_particle, 3, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true )
  ParticleManager:ReleaseParticleIndex(arcana_particle)
end 
  

if self:GetParent():HasModifier("modifier_juggernaut_arcana_v2") then 

  local arcana_particle = ParticleManager:CreateParticle("particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_v2_omni_end.vpcf", PATTACH_POINT_FOLLOW, self:GetParent() )
  ParticleManager:SetParticleControlEnt(  arcana_particle, 2, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true )
  ParticleManager:SetParticleControlEnt(  arcana_particle, 3, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true )
  ParticleManager:ReleaseParticleIndex(arcana_particle)
end 
  

if self:GetParent():IsRealHero() then

  if self.fury and not self:GetParent():HasModifier("modifier_custom_juggernaut_blade_fury_passive_fury") then
    self.fury:SetActivated(true) 
  end

  if self.crit then self.crit:SetActivated(true) end 
end


self:GetParent():FadeGesture(ACT_DOTA_OVERRIDE_ABILITY_4)
self:GetParent():MoveToPositionAggressive(self:GetParent():GetAbsOrigin())


if self:GetParent():HasModifier("modifier_juggernaut_omnislash_cd") then 
  self:GetParent():AddNewModifier(self:GetParent(), self.omni, "modifier_custom_juggernaut_omnislash_blink", {duration = self:GetCaster():GetTalentValue("modifier_juggernaut_omnislash_cd", "duration"), damage = self.damage})
end



if self:GetParent():HasModifier("modifier_juggernaut_omnislash_aoe_attack") and self.root_target and self.root_target:IsAlive() then 


  local point_1 = self.root_target:GetAbsOrigin()
  point_1.z = point_1.z - 100

  local point_2 = self.root_target:GetAbsOrigin()

  local particle = ParticleManager:CreateParticle("particles/jugger_stack.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.root_target )
  ParticleManager:SetParticleControl( particle, 2, point_1  )
  ParticleManager:SetParticleControl( particle, 3, point_2 )
  ParticleManager:ReleaseParticleIndex(particle)
  self.root_target:EmitSound("PBeast.Uproar_root")
  self.root_target:AddNewModifier(self:GetParent(), self.omni, "modifier_custom_juggernaut_omnislash_root", {duration = (1 - self.root_target:GetStatusResistance())*self:GetCaster():GetTalentValue("modifier_juggernaut_omnislash_aoe_attack", "root")})
  self.root_target:AddNewModifier(self:GetParent(), self.omni, "modifier_custom_juggernaut_omnislash_regen", {duration = self:GetCaster():GetTalentValue("modifier_juggernaut_omnislash_aoe_attack", "root")})
 
end



end

function modifier_custom_juggernaut_omnislash:CheckState()
    local state = {
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_MAGIC_IMMUNE] = true,
        [MODIFIER_STATE_DISARMED] = true,
        [MODIFIER_STATE_ROOTED] = true,
    }

    return state
end

function modifier_custom_juggernaut_omnislash:GetModifierIgnoreCastAngle()
   return 1
end








--------------------------------------------------------------------------------------------------------------


modifier_omnislash_check = class({})

function modifier_omnislash_check:IsHidden() return true end

function modifier_omnislash_check:IsPurgable() return false end 

function modifier_omnislash_check:DeclareFunctions()
return 
{
    MODIFIER_EVENT_ON_TAKEDAMAGE,
    MODIFIER_EVENT_ON_ATTACK_LANDED
}

end


function modifier_omnislash_check:OnAttackLanded(params)
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_juggernaut_omnislash_clone") then return end
if self:GetParent() ~= params.attacker then return end

local chance = self:GetCaster():GetTalentValue("modifier_juggernaut_omnislash_clone", "chance")

if self:GetParent():HasModifier("modifier_custom_juggernaut_omnislash") then 
  chance = chance*self:GetCaster():GetTalentValue("modifier_juggernaut_omnislash_clone", "chance_multi")
end


local random = RollPseudoRandomPercentage(chance,22,self:GetParent())

if not random then return end

local cd_reduce = self:GetCaster():GetTalentValue("modifier_juggernaut_omnislash_clone", "cd")


local effect_cast = ParticleManager:CreateParticle( "particles/jugg_omni_proc.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetAbsOrigin() )
ParticleManager:ReleaseParticleIndex( effect_cast )

self:GetParent():EmitSound("Juggernaut.Omni_cd")

if self:GetAbility():GetCooldownTimeRemaining() > 0 then 
  local cd = self:GetAbility():GetCooldownTimeRemaining()
  self:GetAbility():EndCooldown()

  if cd > cd_reduce then 
    cd = cd - cd_reduce
  end
  self:GetAbility():StartCooldown(cd)

end

local ability = self:GetCaster():FindAbilityByName("custom_juggernaut_swift_slash")

if ability:GetCooldownTimeRemaining() > 0 then 
  local cd = ability:GetCooldownTimeRemaining()
  ability:EndCooldown()

  if cd > cd_reduce then 
    cd = cd - cd_reduce
  end
  ability:StartCooldown(cd)

end



end














function custom_juggernaut_swift_slash:GetAOERadius() 
if  self:GetCaster():HasModifier("modifier_juggernaut_omnislash_legendary") then 
  return self:GetCaster():GetTalentValue("modifier_juggernaut_omnislash_legendary", "radius")
end
return 0
end

function custom_juggernaut_swift_slash:GetBehavior()
if self:GetCaster():HasModifier("modifier_juggernaut_omnislash_legendary") then
    return DOTA_ABILITY_BEHAVIOR_AOE + DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK  end
 return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK
end




function custom_juggernaut_swift_slash:GetManaCost(iLevel)
if self:GetCaster():HasModifier("modifier_juggernaut_omnislash_legendary") then 
return self:GetCaster():GetTalentValue("modifier_juggernaut_omnislash_legendary", "mana")
else 
return self:GetSpecialValueFor("mana") end
end



function custom_juggernaut_swift_slash:GetCastRange(vLocation, hTarget)
if self:GetCaster():HasModifier("modifier_juggernaut_omnislash_legendary") then 
  if IsClient() then 
    return self:GetCaster():GetTalentValue("modifier_juggernaut_omnislash_legendary", "range")
  end
  return 999999
end
 return self.BaseClass.GetCastRange(self , vLocation , hTarget)
end





function custom_juggernaut_swift_slash:OnInventoryContentsChanged()
    if self:GetCaster():HasScepter() and self:GetCaster():GetUnitName() == "npc_dota_hero_juggernaut" then
        self:SetHidden(false)        
        if not self:IsTrained() then
            local ab = self:GetCaster():FindAbilityByName("custom_juggernaut_omnislash"):GetLevel()
            if ab > 0 then
                self:SetLevel(1)
            end
        end
    else
        self:SetHidden(true)
    end
end

function custom_juggernaut_swift_slash:OnHeroCalculateStatBonus()
    self:OnInventoryContentsChanged()
end






function custom_juggernaut_swift_slash:OnSpellStart(target)

if self:GetCaster():HasModifier("modifier_juggernaut_omnislash_legendary") then 
    
  self.target = self:GetCursorPosition()
  local distance = (self.target - self:GetCaster():GetAbsOrigin())
  local range = self:GetCaster():GetTalentValue("modifier_juggernaut_omnislash_legendary", "range")  + self:GetCaster():GetCastRangeBonus()

  if distance:Length2D() > range then 
    self.target = self:GetCaster():GetAbsOrigin() + distance:Normalized()*range
  end 

else 

  if target then 
    self.target = target:GetAbsOrigin()
  else 
    self.target = self:GetCursorTarget():GetAbsOrigin()
  end
end



   
self:GetCaster():Purge(false, true, false, false, false)

self.duration = self:GetSpecialValueFor("duration")



self:Omnislash(self:GetCaster(), self.target, self.duration)


end








function custom_juggernaut_swift_slash:Omnislash( caster , target , duration)
if not IsServer() then return end
self.caster = caster

if caster:HasModifier("modifier_custom_juggernaut_omnislash") then 
  caster:RemoveModifierByName("modifier_custom_juggernaut_omnislash")
end
self.caster:EmitSound("Hero_Juggernaut.OmniSlash")

local position = self.caster:GetAbsOrigin()
FindClearSpaceForUnit(self.caster, target, false)

local radius = 10
if self.caster:HasModifier("modifier_juggernaut_omnislash_legendary") then 
  radius = self:GetCaster():GetTalentValue("modifier_juggernaut_omnislash_legendary", "radius")
end

local targets = FindUnitsInRadius(self.caster:GetTeamNumber(), target, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
local first_target = nil 

for _,i in ipairs(targets) do 
   if not i:IsCourier() and i:GetUnitName() ~= "npc_teleport" then 
      first_target = i
      break
  end
end

if first_target == nil then 


  if self.caster:HasModifier("modifier_juggernaut_omnislash_legendary") then  

    if self.caster:HasModifier("modifier_custom_juggernaut_omnislash_effect") then 
      self.caster:RemoveModifierByName("modifier_custom_juggernaut_omnislash_effect")
    end
    self.caster:AddNewModifier(self.caster, self, "modifier_custom_juggernaut_omnislash_effect", {duration = 0.5})

  end

else 
   
  self.caster:AddNewModifier(self.caster, self, "modifier_custom_juggernaut_omnislash", {duration = duration, first_target = first_target:entindex(), scepter = true})
end   

if self.caster:IsRealHero() then 
   PlayerResource:SetCameraTarget(self.caster:GetPlayerOwnerID(), self.caster)
  PlayerResource:SetCameraTarget(self.caster:GetPlayerOwnerID(), nil)
end


local position2 = self.caster:GetAbsOrigin()
effect = "particles/units/heroes/hero_juggernaut/juggernaut_omni_slash_trail_scepter.vpcf"

local particle = ParticleManager:CreateParticle(effect, PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(particle, 0, position)
ParticleManager:SetParticleControl(particle, 1, position2)
ParticleManager:ReleaseParticleIndex(particle)


end















modifier_custom_juggernaut_omnislash_effect = class({})
function modifier_custom_juggernaut_omnislash_effect:IsHidden() return true end
function modifier_custom_juggernaut_omnislash_effect:IsPurgable() return false end

function modifier_custom_juggernaut_omnislash_effect:StatusEffectPriority()
    return 20
end

function modifier_custom_juggernaut_omnislash_effect:GetStatusEffectName()
    return "particles/status_fx/status_effect_omnislash.vpcf"
end


function modifier_custom_juggernaut_omnislash_effect:OnCreated(table)
if not IsServer() then return end
self:GetParent():StartGesture(ACT_DOTA_SPAWN_STATUE)
self.pos = self:GetParent():GetAbsOrigin()
self.fade = false
self:StartIntervalThink(0.1)
end

function modifier_custom_juggernaut_omnislash_effect:OnIntervalThink()
if not IsServer() then return end
if self:GetParent():GetAbsOrigin() ~= self.pos then 
  self.fade = true 
  self:GetParent():FadeGesture(ACT_DOTA_SPAWN_STATUE)

end

end

function modifier_custom_juggernaut_omnislash_effect:OnDestroy()
if not IsServer() then return end
if self.fade == true then return end
self:GetParent():FadeGesture(ACT_DOTA_SPAWN_STATUE)
end
      
      

modifier_custom_juggernaut_omnislash_root = class({})
function modifier_custom_juggernaut_omnislash_root:IsPurgable() return true end
function modifier_custom_juggernaut_omnislash_root:IsHidden() return true end
function modifier_custom_juggernaut_omnislash_root:CheckState()
return
{
  [MODIFIER_STATE_ROOTED] = true
}
end

function modifier_custom_juggernaut_omnislash_root:GetEffectName()
return "particles/beast_root.vpcf"
end


modifier_custom_juggernaut_omnislash_blink = class({})
function modifier_custom_juggernaut_omnislash_blink:IsHidden() return false end
function modifier_custom_juggernaut_omnislash_blink:IsPurgable() return false end
function modifier_custom_juggernaut_omnislash_blink:GetTexture() return "buffs/Omnislash_cd" end 
function modifier_custom_juggernaut_omnislash_blink:DeclareFunctions()
return
{
  MODIFIER_EVENT_ON_ORDER,
}

end

function modifier_custom_juggernaut_omnislash_blink:OnCreated(table)
if not IsServer() then return end

self.range = self:GetCaster():GetTalentValue("modifier_juggernaut_omnislash_cd", "range")

self.damage = table.damage
self:SetStackCount(self.damage)

self.moved = false
end

function modifier_custom_juggernaut_omnislash_blink:OnRefresh(table)
if not IsServer() then return end
end

function modifier_custom_juggernaut_omnislash_blink:OnOrder( ord )
if not IsServer() then return end
if ord.unit ~= self:GetParent() then return end
if self:GetParent():HasModifier("modifier_custom_juggernaut_omnislash") then return end
if self.moved == true then return end
if ord.order_type ~= DOTA_UNIT_ORDER_MOVE_TO_POSITION then return end


local position1 = self:GetParent():GetAbsOrigin()
local position2 = ord.new_pos
local dir = (position2 - position1):Normalized()

if (position2 - position1):Length2D() > self.range then 

  position2 =  position1 + dir*self.range
end

local effect = "particles/units/heroes/hero_juggernaut/juggernaut_omni_slash_trail.vpcf"

if self:GetAbility().juggernaut_trail_particle then 
  effect = self:GetAbility().juggernaut_trail_particle
end 


local particle = ParticleManager:CreateParticle(effect, PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(particle, 0, position1)
ParticleManager:SetParticleControl(particle, 1, position2)
ParticleManager:ReleaseParticleIndex(particle)

self:GetParent():EmitSound("Juggernaut.Stack")
self:GetParent():EmitSound("Hero_Juggernaut.OmniSlash")
self:GetParent():SetAbsOrigin(position2)

self.moved = true

self:GetParent():SetForwardVector(dir)
FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetAbsOrigin(), false)

self:GetParent():RemoveModifierByName("modifier_custom_juggernaut_omnislash_effect")
self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_juggernaut_omnislash_effect", {duration = 0.5})

 
local damageTable = {
      attacker = self:GetParent(),
      damage_type = DAMAGE_TYPE_MAGICAL,
      ability = self:GetAbility()}
    ApplyDamage( damageTable )

local attack = FindUnitsInLine(self:GetParent():GetTeamNumber(), position1, position2, nil, 200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE)

for _,i in ipairs(attack) do
  damageTable.victim = i

  local damage = self.damage


  damageTable.damage = damage

  SendOverheadEventMessage(i, 6, i, damage, nil)

  ApplyDamage(damageTable)
  local trail_pfx2 = ParticleManager:CreateParticle("particles/jugg_legendary_proc_.vpcf", PATTACH_ABSORIGIN_FOLLOW, i)

end


self:Destroy()
end







modifier_custom_juggernaut_omnislash_regen = class({})
function modifier_custom_juggernaut_omnislash_regen:IsHidden() return false end
function modifier_custom_juggernaut_omnislash_regen:IsPurgable() 
return true
end


function modifier_custom_juggernaut_omnislash_regen:GetTexture() return "buffs/chains_resist" end



function modifier_custom_juggernaut_omnislash_regen:DeclareFunctions()
return
{
MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE,
}
end



function modifier_custom_juggernaut_omnislash_regen:GetModifierLifestealRegenAmplify_Percentage() return self.reduce
 end
function modifier_custom_juggernaut_omnislash_regen:GetModifierHealAmplify_PercentageTarget() return self.reduce
 end
function modifier_custom_juggernaut_omnislash_regen:GetModifierHPRegenAmplify_Percentage() return self.reduce end

function modifier_custom_juggernaut_omnislash_regen:GetStatusEffectName()
  return "particles/status_fx/status_effect_huskar_lifebreak.vpcf"
end


function modifier_custom_juggernaut_omnislash_regen:OnCreated()
self.reduce = self:GetCaster():GetTalentValue("modifier_juggernaut_omnislash_aoe_attack", "heal")
end