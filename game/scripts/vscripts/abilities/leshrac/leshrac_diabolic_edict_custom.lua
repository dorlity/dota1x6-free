LinkLuaModifier( "modifier_leshrac_diabolic_edict_custom", "abilities/leshrac/leshrac_diabolic_edict_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_leshrac_diabolic_edict_custom_speed", "abilities/leshrac/leshrac_diabolic_edict_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_leshrac_diabolic_edict_custom_legendary", "abilities/leshrac/leshrac_diabolic_edict_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_leshrac_diabolic_edict_custom_legendary_damage", "abilities/leshrac/leshrac_diabolic_edict_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_leshrac_diabolic_edict_custom_proc", "abilities/leshrac/leshrac_diabolic_edict_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_leshrac_diabolic_edict_custom_tracker", "abilities/leshrac/leshrac_diabolic_edict_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_leshrac_diabolic_edict_custom_shield", "abilities/leshrac/leshrac_diabolic_edict_custom", LUA_MODIFIER_MOTION_NONE )

leshrac_diabolic_edict_custom = class({})



function leshrac_diabolic_edict_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end

PrecacheResource( "particle", "particles/units/heroes/hero_leshrac/leshrac_diabolic_edict.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_leshrac/leshrac_diabolic_edict.vpcf", context )
PrecacheResource( "particle", "particles/leshrac_diabolic_legendary_damage.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_monkey_king/monkey_king_quad_tap_hit.vpcf", context )
PrecacheResource( "particle", "particles/leshrac/edict_proc.vpcf", context )
PrecacheResource( "particle", "particles/items3_fx/star_emblem_friend.vpcf", context )
PrecacheResource( "particle", "particles/leshrac/edict_speed.vpcf", context )
PrecacheResource( "particle", "particles/leshrac_edict_legendary.vpcf", context )
PrecacheResource( "particle", "particles/lesh_edict_stun.vpcf", context )
PrecacheResource( "particle", "particles/leshrac_edict_mark.vpcf", context )
PrecacheResource( "particle", "particles/cleance_blade.vpcf", context )
PrecacheResource( "particle", "particles/leshrac/edict_shield.vpcf", context )

end


function leshrac_diabolic_edict_custom:GetIntrinsicModifierName()
if self:GetCaster():IsRealHero() then 
  return "modifier_leshrac_diabolic_edict_custom_tracker"
end 

end



function leshrac_diabolic_edict_custom:GetRadius()
return self:GetSpecialValueFor("radius") + self:GetCaster():GetLeshracRadius()
end


function leshrac_diabolic_edict_custom:GetCastRange(vLocation, hTarget)
return self:GetRadius()
end



function leshrac_diabolic_edict_custom:GetCooldown(iLevel)

local upgrade_cooldown = 0

if self:GetCaster():HasTalent("modifier_leshrac_edict_2") then  
  upgrade_cooldown = self:GetCaster():GetTalentValue("modifier_leshrac_edict_2", "cd")
end 
return self.BaseClass.GetCooldown(self, iLevel) + upgrade_cooldown
end



function leshrac_diabolic_edict_custom:GetBehavior()
if self:GetCaster():HasTalent("modifier_leshrac_edict_7") then 
  return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE
end

return DOTA_ABILITY_BEHAVIOR_NO_TARGET
end



function leshrac_diabolic_edict_custom:GetManaCost(iLevel)
if self:GetCaster():HasModifier("modifier_leshrac_pulse_nova_custom_low_mana") then
  return self:GetCaster():GetUpgradeStack("modifier_leshrac_pulse_nova_custom_low_mana")
end
return self.BaseClass.GetManaCost(self, iLevel)
end


function leshrac_diabolic_edict_custom:OnSpellStart()
local caster = self:GetCaster()
local duration = self:GetDuration() * (1 + caster:GetTalentValue("modifier_leshrac_edict_2", "duration")/100)

if caster:HasTalent("modifier_leshrac_edict_6") and caster:FindAbilityByName("leshrac_diabolic_edict_custom_surge"):IsHidden() then 
  caster:SwapAbilities("leshrac_diabolic_edict_custom", "leshrac_diabolic_edict_custom_surge", false, true)
end


if self:GetCaster():HasTalent("modifier_leshrac_edict_7") then 
  caster:StartGesture(ACT_DOTA_CAST_ABILITY_4)

  local enemies = caster:FindTargets(self:GetRadius())
  local leash = caster:GetTalentValue("modifier_leshrac_edict_7", "duration")

  for _,enemy in pairs(enemies) do 
    enemy:AddNewModifier(caster, self, "modifier_leshrac_diabolic_edict_custom_legendary", {duration = leash})
  end

  if #enemies > 0 then 
    caster:EmitSound("Leshrac.Edict_legendary_link")
  end
end

caster:RemoveModifierByName("modifier_leshrac_diabolic_edict_custom")
caster:AddNewModifier(caster, self, "modifier_leshrac_diabolic_edict_custom", { duration = duration + FrameTime() })
end




function leshrac_diabolic_edict_custom:PlayEffects( unit )
local particle_cast = "particles/units/heroes/hero_leshrac/leshrac_diabolic_edict.vpcf"
local sound_cast = "Hero_Leshrac.Diabolic_Edict"

local effect_cast 
local point

if unit then
  if unit:HasModifier("modifier_leshrac_diabolic_edict_custom_legendary_damage") then 
    particle_cast = "particles/leshrac_diabolic_legendary_damage.vpcf"

    EmitSoundOnLocationWithCaster(unit:GetAbsOrigin(), "Leshrac.Edict_legendary_break_active"..RandomInt(1, 4), self:GetCaster())

    local abs = unit:GetAbsOrigin()
    abs.z = abs.z + RandomInt(-20, 130)

    local hit_effect = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_quad_tap_hit.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit)
    ParticleManager:SetParticleControl(hit_effect, 1, abs)
    ParticleManager:ReleaseParticleIndex(hit_effect)
  end

  effect_cast  = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN, unit )
  ParticleManager:SetParticleControlEnt( effect_cast, 1, unit, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", Vector(0,0,0), true)
else

  effect_cast  = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )

  point = self:GetCaster():GetOrigin() + RandomVector( RandomInt(0,self:GetRadius()) )
  ParticleManager:SetParticleControl( effect_cast, 1, point )
end

ParticleManager:ReleaseParticleIndex( effect_cast )

if unit then
  unit:EmitSound(sound_cast)
else
  EmitSoundOnLocationWithCaster(point, sound_cast, self:GetCaster())
end

end




function leshrac_diabolic_edict_custom:ProcExtra()
if not IsServer() then return end 
local caster = self:GetCaster()

if not caster:HasTalent("modifier_leshrac_edict_4") then return end

if ulti then 
  if RollPseudoRandomPercentage(caster:GetTalentValue("modifier_leshrac_edict_4", "chance"), 1998, caster) then 

    local particle_peffect = ParticleManager:CreateParticle("particles/leshrac/edict_proc.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
    ParticleManager:SetParticleControl(particle_peffect, 0, caster:GetAbsOrigin())
    ParticleManager:SetParticleControl(particle_peffect, 2, caster:GetAbsOrigin())
    ParticleManager:ReleaseParticleIndex(particle_peffect)

    caster:EmitSound("Leshrac.Edict_proc")
  else 
    return
  end 
end 

caster:AddNewModifier(caster, self, "modifier_leshrac_diabolic_edict_custom_proc", {})
end 



function leshrac_diabolic_edict_custom:DealDamage(proc)
if not IsServer() then return end
local caster = self:GetCaster()
local radius = self:GetRadius()
local enemies = caster:FindTargets(radius, nil, FIND_ANY_ORDER)
local damage = self:GetAbilityDamage()
local enemy = nil
local max = 1
local damage_ability = nil
local mana = caster:GetTalentValue("modifier_leshrac_edict_4", "mana")

if proc then 
  damage_ability = "modifier_leshrac_edict_4"
end 

if caster:HasTalent("modifier_leshrac_edict_3") then 
  damage = damage + caster:GetTalentValue("modifier_leshrac_edict_3", "damage")
  max = caster:GetTalentValue("modifier_leshrac_edict_3", "targets")
end

local count = 0

for _,enemy in pairs(enemies) do 
  if count < max then

    local mod = enemy:FindModifierByName("modifier_leshrac_diabolic_edict_custom_legendary_damage")
    if mod then 
      mod:IncrementStackCount()
    end

    if caster:HasTalent("modifier_leshrac_edict_4") then 
      caster:GiveMana(mana)
      if not enemy:IsDebuffImmune() then 
        enemy:Script_ReduceMana(mana, self)
      end
    end 

    DoDamage( {attacker = caster, victim = enemy, damage = damage, damage_type = DAMAGE_TYPE_PURE, ability = self,}, damage_ability)
    self:PlayEffects( enemy )
  else 
    break
  end
  count = count + 1
end

if count == 0 then 
  self:PlayEffects( nil )
end

end





modifier_leshrac_diabolic_edict_custom = class({})


function modifier_leshrac_diabolic_edict_custom:IsHidden() return false end
function modifier_leshrac_diabolic_edict_custom:IsPurgable()return false end
function modifier_leshrac_diabolic_edict_custom:RemoveOnDeath() return false end

function modifier_leshrac_diabolic_edict_custom:OnCreated( kv )

self.parent = self:GetParent()
self.ability = self:GetAbility()

self.armor = self:GetCaster():GetTalentValue("modifier_leshrac_edict_1", "armor")
self.status = self:GetCaster():GetTalentValue("modifier_leshrac_edict_1", "status")

local duration_k = (1 + self.parent:GetTalentValue("modifier_leshrac_edict_2", "duration")/100)

self.shield = self:GetCaster():GetTalentValue("modifier_leshrac_edict_5", "shield", true)/100
self.shield_max = self:GetCaster():GetTalentValue("modifier_leshrac_edict_5", "max", true)/100
self.creeps = self:GetCaster():GetTalentValue("modifier_leshrac_edict_5", "creeps", true)

self.proced = false
self.count = 0

if not IsServer() then return end

self.parent:AddDamageEvent_out(self)
self.parent:AddDamageEvent_inc(self)

if self.parent:HasTalent("modifier_leshrac_edict_1") then 
  self.particle_peffect = ParticleManager:CreateParticle("particles/items3_fx/star_emblem_friend.vpcf", PATTACH_OVERHEAD_FOLLOW, self.parent) 
  ParticleManager:SetParticleControl(self.particle_peffect, 0, self.parent:GetAbsOrigin())
  self:AddParticle(self.particle_peffect, false, false, -1, false, true)
end 

self.ability:EndCooldown()
self.ability:SetActivated(false)

self.RemoveForDuel = true
self.explosion = self:GetAbility():GetSpecialValueFor( "num_explosions" )*duration_k
local duration = self:GetAbility():GetSpecialValueFor( "duration" )*duration_k
local interval = duration/self.explosion 

self.parent:EmitSound("Hero_Leshrac.Diabolic_Edict_lp")
self:StartIntervalThink( interval )
end



function modifier_leshrac_diabolic_edict_custom:OnDestroy()
if not IsServer() then return end

self.ability:UseResources(false, false, false, true)
self.ability:SetActivated(true)

self:GiveShield()

self.parent:StopSound("Hero_Leshrac.Diabolic_Edict_lp")

if self:GetCaster():HasTalent("modifier_leshrac_edict_6") and not self:GetCaster():FindAbilityByName("leshrac_diabolic_edict_custom_surge"):IsHidden() then 
  self:GetCaster():SwapAbilities("leshrac_diabolic_edict_custom", "leshrac_diabolic_edict_custom_surge", true, false)
end

end


function modifier_leshrac_diabolic_edict_custom:GiveShield()
if not IsServer() then return end 
if self:GetStackCount() <= 0 then return end 
if self.proced == true then return end 

self.parent:RemoveModifierByName("modifier_leshrac_diabolic_edict_custom_shield")
self.parent:AddNewModifier(self.parent, self.ability, "modifier_leshrac_diabolic_edict_custom_shield", {shield = self:GetStackCount(), duration = self.parent:GetTalentValue("modifier_leshrac_edict_5", "duration", true)})

self.proced = true
self:SetStackCount(0)
end 



function modifier_leshrac_diabolic_edict_custom:OnIntervalThink()
if not IsServer() then return end
if self.count >= self.explosion then return end

self.count = self.count + 1
self.ability:DealDamage()
end

 
function modifier_leshrac_diabolic_edict_custom:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
  MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
  MODIFIER_PROPERTY_MIN_HEALTH
}
end


function modifier_leshrac_diabolic_edict_custom:GetModifierPhysicalArmorBonus()
if not self.parent:HasTalent("modifier_leshrac_edict_1") then return end
return self.armor
end


function modifier_leshrac_diabolic_edict_custom:GetModifierStatusResistanceStacking() 
if not self.parent:HasTalent("modifier_leshrac_edict_1") then return end
return self.status
end



function modifier_leshrac_diabolic_edict_custom:GetMinHealth()
if not self.parent:HasTalent("modifier_leshrac_edict_5") then return end
if self:GetCaster():HasModifier("modifier_death") then return end
if self.proced == true then return end
if self:GetStackCount() == 0 then return end

return 1 
end 


function modifier_leshrac_diabolic_edict_custom:DamageEvent_inc(params)
if not IsServer() then return end
if not self.parent:HasTalent("modifier_leshrac_edict_5") then return end
if self.proced == true then return end
if not params.attacker then return end

local unit = params.unit
local attacker = params.attacker

if unit == self.parent and self.parent:GetHealth() <= 1 and not self.parent:HasModifier("modifier_death") then
  self:GiveShield()
end 

end


function modifier_leshrac_diabolic_edict_custom:DamageEvent_out(params)
if not IsServer() then return end
if not self.parent:HasTalent("modifier_leshrac_edict_5") then return end
if self.proced == true then return end

local unit = params.unit
local attacker = params.attacker

if attacker ~= self.parent then return end
if not unit:IsUnit() then return end
if bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then return end
if unit:IsIllusion() then return end

local heal = params.damage*self.shield

if params.unit:IsCreep() then 
  heal = heal/self.creeps
end

local max = self.parent:GetMaxHealth()*self.shield_max

self:SetStackCount(math.min(max, self:GetStackCount() + heal))
end 







modifier_leshrac_diabolic_edict_custom_speed = class({})
function modifier_leshrac_diabolic_edict_custom_speed:IsHidden() return false end
function modifier_leshrac_diabolic_edict_custom_speed:IsPurgable() return false end
function modifier_leshrac_diabolic_edict_custom_speed:GetTexture() return "buffs/edict_speed" end
function modifier_leshrac_diabolic_edict_custom_speed:OnCreated(table)
self.speed = self:GetCaster():GetTalentValue("modifier_leshrac_edict_6", "speed")

if not IsServer() then return end

local effect_cast = ParticleManager:CreateParticle( "particles/leshrac/edict_speed.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetAbsOrigin()) 
self:AddParticle( effect_cast, false, false, -1, false, false )

end

function modifier_leshrac_diabolic_edict_custom_speed:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
}
end


function modifier_leshrac_diabolic_edict_custom_speed:GetModifierMoveSpeedBonus_Percentage()
return self.speed
end

function modifier_leshrac_diabolic_edict_custom_speed:CheckState()
return
{
  [MODIFIER_STATE_UNSLOWABLE] = true,
  [MODIFIER_STATE_NO_UNIT_COLLISION] = true
}
end








modifier_leshrac_diabolic_edict_custom_legendary = class({})
function modifier_leshrac_diabolic_edict_custom_legendary:IsHidden() return true end
function modifier_leshrac_diabolic_edict_custom_legendary:IsPurgable() return false end
function modifier_leshrac_diabolic_edict_custom_legendary:OnCreated(table)
if not IsServer() then return end

self.parent = self:GetParent()
self.caster = self:GetCaster()

self.radius = self:GetAbility():GetRadius() + 50
self.stun = self.caster:GetTalentValue("modifier_leshrac_edict_7", "stun")

local effect_cast = ParticleManager:CreateParticle( "particles/leshrac_edict_legendary.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent )
ParticleManager:SetParticleControlEnt(effect_cast,0,self.caster,PATTACH_POINT_FOLLOW,"attach_hitloc",self.caster:GetOrigin(),true)
ParticleManager:SetParticleControlEnt(effect_cast,1,self.parent,PATTACH_POINT_FOLLOW,"attach_hitloc",self.parent:GetOrigin(),true)
self:AddParticle(effect_cast,false,false,-1,false,false)

self:StartIntervalThink(FrameTime())
end


function modifier_leshrac_diabolic_edict_custom_legendary:CheckState()
return
{
  [MODIFIER_STATE_TETHERED] = true
}
end

function modifier_leshrac_diabolic_edict_custom_legendary:OnIntervalThink()
if not IsServer() then return end

AddFOWViewer(self.caster:GetTeamNumber(), self.parent:GetAbsOrigin(), 10, FrameTime()*2, false)

if (self.caster:GetAbsOrigin() - self.parent:GetAbsOrigin()):Length2D() > self.radius
  or not self.caster:IsAlive() then
    self:Destroy()
end


end


function modifier_leshrac_diabolic_edict_custom_legendary:OnDestroy()
if not IsServer() then return end

if self:GetRemainingTime() > 0.1 then
  self.parent:EmitSound("Leshrac.Edict_legendary_break")
  return
end

self.parent:EmitSound("Leshrac.Edict_legendary_stun")

local particle_peffect = ParticleManager:CreateParticle("particles/lesh_edict_stun.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
ParticleManager:ReleaseParticleIndex(particle_peffect)

local mod = self.caster:FindModifierByName("modifier_leshrac_diabolic_edict_custom")
if mod then 
  self.parent:AddNewModifier(self.caster, self:GetAbility(), "modifier_leshrac_diabolic_edict_custom_legendary_damage", {duration = mod:GetRemainingTime()})
end

self.parent:AddNewModifier(self.caster, self:GetAbility(), "modifier_stunned", {duration = self.stun*(1 - self.parent:GetStatusResistance())})
end









modifier_leshrac_diabolic_edict_custom_legendary_damage = class({})
function modifier_leshrac_diabolic_edict_custom_legendary_damage:IsHidden() return false end
function modifier_leshrac_diabolic_edict_custom_legendary_damage:IsPurgable() return false end
function modifier_leshrac_diabolic_edict_custom_legendary_damage:GetEffectName() return "particles/leshrac_edict_mark.vpcf" end
function modifier_leshrac_diabolic_edict_custom_legendary_damage:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
function modifier_leshrac_diabolic_edict_custom_legendary_damage:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
}
end


function modifier_leshrac_diabolic_edict_custom_legendary_damage:OnCreated()
self.damage = self:GetCaster():GetTalentValue("modifier_leshrac_edict_7", "damage")
end


function modifier_leshrac_diabolic_edict_custom_legendary_damage:GetModifierIncomingDamage_Percentage()
return self.damage*self:GetStackCount()
end











leshrac_diabolic_edict_custom_surge = class({})


function leshrac_diabolic_edict_custom_surge:OnSpellStart()
if not IsServer() then return end
local caster = self:GetCaster()

caster:StartGesture(ACT_DOTA_CAST_ABILITY_4)

local effect_cast = ParticleManager:CreateParticle( "particles/cleance_blade.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetAbsOrigin())
ParticleManager:SetParticleControl( effect_cast, 1, Vector(300,0,0) )
ParticleManager:ReleaseParticleIndex( effect_cast )

caster:EmitSound("Leshrac.Edict_purge")
caster:Purge(false, true, false, false, false)
caster:AddNewModifier(caster, self, "modifier_leshrac_diabolic_edict_custom_speed", {duration = self:GetCaster():GetTalentValue("modifier_leshrac_edict_6", "duration")})

self:GetCaster():SwapAbilities("leshrac_diabolic_edict_custom", "leshrac_diabolic_edict_custom_surge", true, false)
end













modifier_leshrac_diabolic_edict_custom_proc = class({})
function modifier_leshrac_diabolic_edict_custom_proc:IsHidden() return true end
function modifier_leshrac_diabolic_edict_custom_proc:IsPurgable() return false end
function modifier_leshrac_diabolic_edict_custom_proc:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_leshrac_diabolic_edict_custom_proc:OnCreated()
self:SetStackCount(self:GetCaster():GetTalentValue("modifier_leshrac_edict_4", "max"))
self.ability = self:GetAbility()
if not IsServer() then return end 

self:StartIntervalThink(0.25)
end 



function modifier_leshrac_diabolic_edict_custom_proc:OnIntervalThink()
if not IsServer() then return end 
self.ability:DealDamage(true)

self:DecrementStackCount()
if self:GetStackCount() == 0 then
  self:Destroy()
end

end 








modifier_leshrac_diabolic_edict_custom_tracker = class({})
function modifier_leshrac_diabolic_edict_custom_tracker:IsHidden() return true end
function modifier_leshrac_diabolic_edict_custom_tracker:IsPurgable() return false end
function modifier_leshrac_diabolic_edict_custom_tracker:OnCreated()
self.ability = self:GetAbility()
self.parent = self:GetParent()
self.parent:AddSpellEvent(self)
end 




function modifier_leshrac_diabolic_edict_custom_tracker:SpellEvent( params )
if not IsServer() then return end
if not self.parent:HasTalent("modifier_leshrac_edict_4") then return end
if params.unit~=self.parent then return end

self.ability:ProcExtra()
end 










modifier_leshrac_diabolic_edict_custom_shield = class({})
function modifier_leshrac_diabolic_edict_custom_shield:IsHidden() return false end
function modifier_leshrac_diabolic_edict_custom_shield:IsPurgable() return false end
function modifier_leshrac_diabolic_edict_custom_shield:GetTexture() return "buffs/orb_slow" end
function modifier_leshrac_diabolic_edict_custom_shield:OnCreated(table)

self.parent = self:GetParent()
self.shield_talent = "modifier_leshrac_edict_5"
self.max_shield = self:GetCaster():GetTalentValue("modifier_leshrac_edict_5", "max")*self:GetCaster():GetMaxHealth()/100

if not IsServer() then return end

self.RemoveForDuel = true
self.parent = self:GetParent()
self.parent:EmitSound("Leshrac.Edict_shield")

local effect_cast = ParticleManager:CreateParticle( "particles/leshrac/edict_shield.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self.parent)
ParticleManager:SetParticleControl(effect_cast, 0, self.parent:GetAbsOrigin())
ParticleManager:SetParticleControlEnt(effect_cast, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
self:AddParticle( effect_cast, false, false, -1, false, false )

self:SetStackCount(math.min(table.shield, self.max_shield))
end

function modifier_leshrac_diabolic_edict_custom_shield:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_INCOMING_DAMAGE_CONSTANT,
}
end



function modifier_leshrac_diabolic_edict_custom_shield:GetModifierIncomingDamageConstant( params )

if IsClient() then 
  if params.report_max then 
    return self.max_shield
  else 
      return self:GetStackCount()
    end 
end

if not IsServer() then return end
local damage = math.min(params.damage, self:GetStackCount())
self.parent:AddShieldInfo({shield_mod = self, healing = damage, healing_type = "shield"})

self:SetStackCount(self:GetStackCount() - damage)
if self:GetStackCount() <= 0 then
  self:Destroy()
end

return -damage
end
