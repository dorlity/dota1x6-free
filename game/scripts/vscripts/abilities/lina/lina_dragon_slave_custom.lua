LinkLuaModifier( "modifier_lina_dragon_slave_custom_legendary", "abilities/lina/lina_dragon_slave_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_lina_dragon_slave_custom_tracker", "abilities/lina/lina_dragon_slave_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_lina_dragon_slave_custom_legendary_tracker", "abilities/lina/lina_dragon_slave_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_lina_dragon_slave_custom_burn", "abilities/lina/lina_dragon_slave_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_lina_dragon_slave_custom_burn_count", "abilities/lina/lina_dragon_slave_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_lina_dragon_slave_custom_slow", "abilities/lina/lina_dragon_slave_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_lina_dragon_slave_custom_magic", "abilities/lina/lina_dragon_slave_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_lina_dragon_slave_custom_auto", "abilities/lina/lina_dragon_slave_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_lina_dragon_slave_custom_proc", "abilities/lina/lina_dragon_slave_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_lina_dragon_slave_custom_cd", "abilities/lina/lina_dragon_slave_custom", LUA_MODIFIER_MOTION_NONE )




lina_dragon_slave_custom = class({})


lina_dragon_slave_custom.projectiles = {}
lina_dragon_slave_custom.index = 0


function lina_dragon_slave_custom:CreateTalent()
self:ToggleAutoCast()
end

function lina_dragon_slave_custom:GetAbilityTextureName()
if self:GetCaster():HasModifier("modifier_arcana_lina_custom") then
    return "lina_dragon_slave_alt1"
end
return "lina_dragon_slave"
end



function lina_dragon_slave_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end

PrecacheResource( "particle", "particles/units/heroes/hero_lina/lina_spell_dragon_slave.vpcf", context )
PrecacheResource( "particle", "particles/huskar_spears_legen.vpcf", context ) 
PrecacheResource( "particle", "particles/status_fx/status_effect_omnislash.vpcf", context ) 
PrecacheResource( "particle", "particles/lina/dragon_status.vpcf", context )
PrecacheResource( "particle", "particles/mars_revenge_proc.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_phoenix/phoenix_fire_spirit_burn.vpcf", context )
PrecacheResource( "particle", "particles/lina_attack_slow.vpcf", context )
PrecacheResource( "particle", "particles/status_fx/status_effect_enchantress_shard_debuff.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_essence_effect.vpcf", context )

dota1x6:PrecacheShopItems("npc_dota_hero_lina", context)
end




function lina_dragon_slave_custom:GetCastPoint()
local bonus = 0
if self:GetCaster():HasTalent("modifier_lina_dragon_3") then 
  bonus = self:GetCaster():GetTalentValue("modifier_lina_dragon_3", "cast")
end 

return self:GetSpecialValueFor("AbilityCastPoint") + bonus
end



function lina_dragon_slave_custom:GetCooldown(iLevel)
local k = 1
local bonus = 0
local caster = self:GetCaster()

if caster:HasTalent("modifier_lina_dragon_3") then 
  bonus = caster:GetTalentValue("modifier_lina_dragon_3", "cd")
end

if caster:HasModifier("modifier_lina_dragon_slave_custom_legendary") and caster:HasTalent("modifier_lina_dragon_legendary") then 
  k = 1 - caster:GetTalentValue("modifier_lina_dragon_legendary", "cd")/100
end

return (self.BaseClass.GetCooldown(self, iLevel) + bonus)*k
end



function lina_dragon_slave_custom:GetBehavior()
local bonus = 0
if self:GetCaster():HasTalent("modifier_lina_dragon_6") then 
  bonus = DOTA_ABILITY_BEHAVIOR_AUTOCAST
end 
return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_POINT + bonus
end



function lina_dragon_slave_custom:GetIntrinsicModifierName()
return "modifier_lina_dragon_slave_custom_tracker"
end






function lina_dragon_slave_custom:OnSpellStart(new_target, damage_ability)
local caster = self:GetCaster()

local target = self:GetCursorTarget()
if new_target ~= nil then 
  target = new_target
end

local point = self:GetCursorPosition()
local ability = nil

if damage_ability then
  ability = damage_ability
end 

self.soul = caster:FindAbilityByName("lina_fiery_soul_custom")

if target then 
  point = target:GetAbsOrigin()  
end

if point == caster:GetAbsOrigin() then 
  point = point + caster:GetForwardVector()*10
end

if caster:HasTalent("modifier_lina_dragon_6") and self:GetAutoCastState() == true and not damage_ability and not caster:HasModifier("modifier_lina_dragon_slave_custom_cd")
  and not caster:IsRooted() and not caster:IsLeashed() then 


  caster:AddNewModifier(caster, self, "modifier_lina_dragon_slave_custom_cd", {duration = caster:GetTalentValue("modifier_lina_dragon_6", "cd")})
  local dist = caster:GetTalentValue("modifier_lina_dragon_6", "distance")
  local speed = caster:GetTalentValue("modifier_lina_dragon_6", "speed")

  local dir = (point - caster:GetAbsOrigin()):Normalized()
  local blink_point = caster:GetAbsOrigin() - dir*dist

  caster:AddNewModifier( caster,  self,  "modifier_generic_arc",  
  {
    target_x = blink_point.x,
    target_y = blink_point.y,
    distance = dist,
    duration = dist/speed,
    height = 0,
    fix_end = false,
    isStun = false,
  })
end


local projectile_distance = self:GetSpecialValueFor( "dragon_slave_distance" )
local projectile_speed = self:GetSpecialValueFor( "dragon_slave_speed" )
local projectile_start_radius = self:GetSpecialValueFor( "dragon_slave_width_initial" )
local projectile_end_radius = self:GetSpecialValueFor( "dragon_slave_width_end" )

local direction = point-caster:GetAbsOrigin()
direction.z = 0
local projectile_normalized = direction:Normalized()


local sound = "Hero_Lina.DragonSlave.Cast"
local particle = "particles/units/heroes/hero_lina/lina_spell_dragon_slave.vpcf"
if caster:HasModifier("modifier_arcana_lina_custom") then
  particle = "particles/econ/items/lina/lina_head_headflame/lina_spell_dragon_slave_headflame.vpcf"
  sound = "Hero_Lina.DragonSlave.FireHair"
end

self.index = self.index + 1

local info = {
    Source = caster,
    Ability = self,
    vSpawnOrigin = caster:GetAbsOrigin(),
    bDeleteOnHit = false,
    iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
    iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
    iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
    EffectName = particle,
    fDistance = projectile_distance,
    fStartRadius = projectile_start_radius,
    fEndRadius = projectile_end_radius,
    vVelocity = projectile_normalized * projectile_speed,
    bProvidesVision = false,
    ExtraData =
    {
      x = caster:GetAbsOrigin().x,
      y = caster:GetAbsOrigin().y,
      damage_ability = ability,
      index = self.index
    }
}


ProjectileManager:CreateLinearProjectile(info)

caster:EmitSound(sound)
caster:EmitSound("Hero_Lina.DragonSlave")

end

function lina_dragon_slave_custom:OnProjectileHit_ExtraData(target, vLocation, table)
if not IsServer() then return end
if not target then 

  if table and table.index and self.projectiles[table.index] then 
    self.projectiles[table.index] = nil
  end

  return 
end

local caster = self:GetCaster()
local damage = self:GetSpecialValueFor("dragon_slave_damage")

if table and table.index and not self.projectiles[table.index] then 

  if caster:HasTalent("modifier_lina_soul_4") then 
    caster:AddNewModifier(caster, self, "modifier_lina_fiery_soul_custom_stack", {duration = caster:GetTalentValue("modifier_lina_soul_4", "duration", true)})
  end 
  self.projectiles[table.index] = 1
end

if self.soul and not self.soul:IsNull() and self.soul:GetLevel() > 0 then 
  damage = damage + self.soul:GetShardDamage()
end 

if caster:HasTalent("modifier_lina_dragon_1") then 
  target:AddNewModifier(caster, self, "modifier_lina_dragon_slave_custom_magic", {duration = caster:GetTalentValue("modifier_lina_dragon_1", "duration")})
end 

if caster:HasTalent("modifier_lina_dragon_6") then 
  target:AddNewModifier(caster, self, "modifier_lina_dragon_slave_custom_slow", {duration = (1 - target:GetStatusResistance())*caster:GetTalentValue("modifier_lina_dragon_6", "slow_duration")})
end

if target:IsRealHero() and caster:GetQuest() == "Lina.Quest_5" and (caster:GetAbsOrigin() - target:GetAbsOrigin()):Length2D() >= caster.quest.number then 
  caster:UpdateQuest(1)
end

if caster:GetQuest() == "Lina.Quest_7" and target:IsRealHero() and not caster:QuestCompleted() then 
  target:AddNewModifier(caster, self, "modifier_lina_fiery_soul_custom_quest", {duration = caster.quest.number})
end

local damage_ability = nil
if table and table.damage_ability then 
  damage_ability = table.damage_ability

  if damage_ability == "modifier_lina_dragon_4" then 
    damage = damage*caster:GetTalentValue("modifier_lina_dragon_4", "damage")/100
  end
end 

if caster:HasTalent("modifier_lina_dragon_4") then 
  target:AddNewModifier(caster, self, "modifier_lina_dragon_slave_custom_burn", {duration = caster:GetTalentValue("modifier_lina_dragon_4", "duration") + 2*FrameTime(), damage_ability = damage_ability})
  target:AddNewModifier(caster, self, "modifier_lina_dragon_slave_custom_burn_count", {duration = caster:GetTalentValue("modifier_lina_dragon_4", "duration") + 2*FrameTime()})
end


DoDamage( { victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self }, damage_ability )

if not caster:HasModifier("modifier_arcana_lina_custom") then return end
if not table.x or not table.y then return end 

local cast_point = GetGroundPosition(Vector(table.x, table.y, 0), nil)

local direction = vLocation - cast_point
direction.z = 0
direction = direction:Normalized()

local particle = ParticleManager:CreateParticle( "particles/econ/items/lina/lina_head_headflame/lina_spell_dragon_slave_impact_headflame.vpcf", PATTACH_ABSORIGIN_FOLLOW, target )
ParticleManager:SetParticleControlForward( particle, 1, direction )
ParticleManager:ReleaseParticleIndex( particle )
end









modifier_lina_dragon_slave_custom_legendary = class({})
function modifier_lina_dragon_slave_custom_legendary:IsHidden() return true end
function modifier_lina_dragon_slave_custom_legendary:IsPurgable() return false end 

function modifier_lina_dragon_slave_custom_legendary:GetEffectName() 
if not self:GetCaster():HasTalent("modifier_lina_dragon_legendary") then return end
  return "particles/huskar_spears_legen.vpcf" 
end

function modifier_lina_dragon_slave_custom_legendary:GetStatusEffectName() 
if not self:GetCaster():HasTalent("modifier_lina_dragon_legendary") then return end
  return "particles/status_fx/status_effect_omnislash.vpcf" 
end


function modifier_lina_dragon_slave_custom_legendary:StatusEffectPriority() return MODIFIER_PRIORITY_ULTRA end

function modifier_lina_dragon_slave_custom_legendary:OnCreated(table)

self.parent = self:GetParent()
self.status = self.parent:GetTalentValue("modifier_lina_dragon_5", "status")

if not IsServer() then return end
self.RemoveForDuel = true

if self.parent:HasTalent("modifier_lina_dragon_5") then 
  for i = 0, 8 do
    local current_item = self.parent:GetItemInSlot(i)

    if current_item and not NoCdItems[current_item:GetName()] then  
      local cooldown_mod = self.parent:AddNewModifier(self.parent, self:GetAbility(), "modifier_cooldown_speed", {ability = current_item:entindex(), is_item = true, cd_inc = self.parent:GetTalentValue("modifier_lina_dragon_5", "cd")})
      local name = self:GetName()

      cooldown_mod:SetEndRule(function()
        return self.parent:HasModifier(name)
      end)
    end
  end

  self.parent:EmitSound("Lina.Dragon_status")
  self:AddParticle(ParticleManager:CreateParticle("particles/lina/dragon_status.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent),false,false,-1,false,false)
end 

local particle_peffect = ParticleManager:CreateParticle("particles/mars_revenge_proc.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
ParticleManager:SetParticleControl(particle_peffect, 0, self.parent:GetAbsOrigin())
ParticleManager:SetParticleControl(particle_peffect, 2, self.parent:GetAbsOrigin())
ParticleManager:ReleaseParticleIndex(particle_peffect)

self.player = PlayerResource:GetPlayer(self.parent:GetPlayerOwnerID())

self.duration = self.parent:GetTalentValue("modifier_lina_dragon_legendary", "duration", true)
self.max = self.parent:GetTalentValue("modifier_lina_dragon_legendary", "max", true)

if self.parent:HasTalent("modifier_lina_dragon_legendary") then 
  self.parent:EmitSound("Lina.Dragon_legendary")
end 

self:StartIntervalThink(0.1)
end

function modifier_lina_dragon_slave_custom_legendary:OnIntervalThink()
if not IsServer() then return end

self.parent:UpdateUIlong({max = self.duration, stack = self:GetRemainingTime(), use_zero = 1, active = 1, style = "LinaDragon"})

CustomGameEventManager:Send_ServerToPlayer(self.player, "lina_change",  {max = self.duration, current = self:GetRemainingTime(), active = 1})
end


function modifier_lina_dragon_slave_custom_legendary:OnDestroy()
if not IsServer() then return end

self.parent:UpdateUIlong({max = self.max, stack = 0, active = 0, style = "LinaDragon"})
end

function modifier_lina_dragon_slave_custom_legendary:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
}
end


function modifier_lina_dragon_slave_custom_legendary:GetModifierStatusResistanceStacking()
if not self.parent:HasTalent("modifier_lina_dragon_5") then return end
return self.status
end








modifier_lina_dragon_slave_custom_tracker = class({})
function modifier_lina_dragon_slave_custom_tracker:IsHidden() return true end
function modifier_lina_dragon_slave_custom_tracker:IsPurgable() return false end
function modifier_lina_dragon_slave_custom_tracker:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
}
end

function modifier_lina_dragon_slave_custom_tracker:OnCreated(table)
self.parent = self:GetParent()
self.parent:AddSpellEvent(self)

self.ability = self:GetAbility()

self.legendary_max = self.parent:GetTalentValue("modifier_lina_dragon_legendary", "max", true)
self.legendary_spell = self.parent:GetTalentValue("modifier_lina_dragon_legendary", "spell", true)
self.legendary_attack = self.parent:GetTalentValue("modifier_lina_dragon_legendary", "attack", true)
self.legendary_duration = self.parent:GetTalentValue("modifier_lina_dragon_legendary", "duration", true)
self.legendary_waste = self.parent:GetTalentValue("modifier_lina_dragon_legendary", "waste", true)
self.legendary_range = self.parent:GetTalentValue("modifier_lina_dragon_legendary", "range", true)

self.proc_duration = self.parent:GetTalentValue("modifier_lina_dragon_4", "duration", true)

self.active = 0
if not IsServer() then return end

if self.parent:IsRealHero() then 
  self.parent:AddDamageEvent_inc(self)
  self.parent:AddDamageEvent_out(self)
end

self.player = PlayerResource:GetPlayer(self.parent:GetPlayerOwnerID())
self:StartIntervalThink(1)
end



function modifier_lina_dragon_slave_custom_tracker:OnIntervalThink()
if not IsServer() then return end

if not self.parent:HasTalent("modifier_lina_dragon_legendary") and not self.parent:HasTalent("modifier_lina_dragon_5") then return end

if self.active == 0 then 
  self.active = 1

  self.parent:UpdateUIlong({max = self.legendary_max, stack = self:GetStackCount(), active = 0, style = "LinaDragon"})
end

if self:GetStackCount() == 0 then return end

self:DecrementStackCount()
self:StartIntervalThink(0.2)
end


function modifier_lina_dragon_slave_custom_tracker:DamageEvent_out( params )
if not IsServer() then return end
if self.parent ~= params.attacker then return end
if (self.parent:GetAbsOrigin() - params.unit:GetAbsOrigin()):Length2D() >= self.legendary_range then return end
if params.inflictor and params.inflictor:IsItem() then return end

self:StartIntervalThink(self.legendary_waste)
end

function modifier_lina_dragon_slave_custom_tracker:DamageEvent_inc( params )
if not IsServer() then return end
if self.parent ~= params.unit then return end
if (self.parent:GetAbsOrigin() - params.unit:GetAbsOrigin()):Length2D() >= self.legendary_range then return end
if params.inflictor and params.inflictor:IsItem() then return end

self:StartIntervalThink(self.legendary_waste)
end


function modifier_lina_dragon_slave_custom_tracker:SpellEvent( params )
if not IsServer() then return end
if params.unit~=self.parent then return end

if self.parent:HasTalent("modifier_lina_dragon_4") or self.parent:HasTalent("modifier_lina_dragon_2") then 
  self.parent:AddNewModifier(self.parent, self.ability, "modifier_lina_dragon_slave_custom_proc", {duration = self.proc_duration, dragon = params.ability == self.ability})
end 

if params.ability:IsItem() then return end
if self.parent:HasModifier("modifier_lina_dragon_slave_custom_legendary") then return end
if not self.parent:HasTalent("modifier_lina_dragon_legendary") and not self.parent:HasTalent("modifier_lina_dragon_5") then return end

self:GiveStacks(self.legendary_spell)
self:StartIntervalThink(self.legendary_waste)
end



function modifier_lina_dragon_slave_custom_tracker:GetModifierProcAttack_Feedback(params)
if not IsServer() then return end
if self.parent:HasModifier("modifier_lina_dragon_slave_custom_legendary") then return end
if not self.parent:HasTalent("modifier_lina_dragon_legendary") and not self.parent:HasTalent("modifier_lina_dragon_5") then return end
if self.parent ~= params.attacker then return end
if not params.target:IsCreep() and not params.target:IsHero() then return end

self:GiveStacks(self.legendary_attack)
end



function modifier_lina_dragon_slave_custom_tracker:GiveStacks(count)
if not IsServer() then return end

self:SetStackCount(self:GetStackCount() + count)

if self:GetStackCount() >= self.legendary_max then 

  if self.parent:HasTalent("modifier_lina_dragon_legendary") then 
    self.ability:EndCooldown()
  end
  self.parent:AddNewModifier(self.parent, self.ability, "modifier_lina_dragon_slave_custom_legendary", {duration = self.legendary_duration})
  self:SetStackCount(0)
end

end



function modifier_lina_dragon_slave_custom_tracker:OnStackCountChanged(iStackCount)
if not IsServer() then return end

local mod = self.parent:FindModifierByName("modifier_lina_dragon_slave_custom_legendary")
local max = self.legendary_max
local current = self:GetStackCount()
local active = 0

if mod then 
  max = self.legendary_duration
  current = mod:GetRemainingTime()
  active = 1
end

self.active = 1

self.parent:UpdateUIlong({max = max, stack = current, active = active, use_zero = active, style = "LinaDragon"})
end






modifier_lina_dragon_slave_custom_burn = class({})
function modifier_lina_dragon_slave_custom_burn:IsHidden() return true end
function modifier_lina_dragon_slave_custom_burn:IsPurgable() return true end
function modifier_lina_dragon_slave_custom_burn:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_lina_dragon_slave_custom_burn:OnCreated(table)
if not IsServer() then return end
self.damage_ability = table.damage_ability
self.caster = self:GetCaster()
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.damage = self.caster:GetTalentValue("modifier_lina_dragon_4", "burn")/self:GetRemainingTime()

self.damageTable = { victim = self.parent, attacker = self.caster, damage = self.damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self.ability }
self:StartIntervalThink(1)
end

function modifier_lina_dragon_slave_custom_burn:OnIntervalThink()
if not IsServer() then return end

DoDamage(self.damageTable, self.damage_ability )
end


function modifier_lina_dragon_slave_custom_burn:OnDestroy()
if not IsServer() then return end 

local mod = self.parent:FindModifierByName("modifier_lina_dragon_slave_custom_burn_count")

if not mod then return end 

mod:DecrementStackCount()

if mod:GetStackCount() <= 0 then 
  mod:Destroy()
end 

end 







modifier_lina_dragon_slave_custom_burn_count = class({})
function modifier_lina_dragon_slave_custom_burn_count:IsHidden() return false end
function modifier_lina_dragon_slave_custom_burn_count:IsPurgable() return true end
function modifier_lina_dragon_slave_custom_burn_count:GetEffectName()
return "particles/units/heroes/hero_phoenix/phoenix_fire_spirit_burn.vpcf"
end


function modifier_lina_dragon_slave_custom_burn_count:OnCreated()
if not IsServer() then return end 

self:SetStackCount(1)
end 


function modifier_lina_dragon_slave_custom_burn_count:OnRefresh()
if not IsServer() then return end 

self:IncrementStackCount()
end



modifier_lina_dragon_slave_custom_slow = class({})
function modifier_lina_dragon_slave_custom_slow:IsHidden() return true end
function modifier_lina_dragon_slave_custom_slow:IsPurgable() return true end
function modifier_lina_dragon_slave_custom_slow:GetEffectName() return "particles/lina_attack_slow.vpcf" end
function modifier_lina_dragon_slave_custom_slow:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
  MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
end


function modifier_lina_dragon_slave_custom_slow:OnCreated()
self.slow = self:GetCaster():GetTalentValue("modifier_lina_dragon_6", "slow")
self.attack_slow = self:GetCaster():GetTalentValue("modifier_lina_dragon_6", "attack_slow")

end 

function modifier_lina_dragon_slave_custom_slow:GetModifierMoveSpeedBonus_Percentage()
return self.slow
end

function modifier_lina_dragon_slave_custom_slow:GetModifierAttackSpeedBonus_Constant()
return self.attack_slow
end

function modifier_lina_dragon_slave_custom_slow:GetStatusEffectName()
return "particles/status_fx/status_effect_enchantress_shard_debuff.vpcf"
end

function modifier_lina_dragon_slave_custom_slow:StatusEffectPriority()
return MODIFIER_PRIORITY_HIGH
end





modifier_lina_dragon_slave_custom_cd = class({})
function modifier_lina_dragon_slave_custom_cd:IsHidden() return false end
function modifier_lina_dragon_slave_custom_cd:IsPurgable() return false end
function modifier_lina_dragon_slave_custom_cd:GetTexture() return "buffs/edict_speed" end
function modifier_lina_dragon_slave_custom_cd:RemoveOnDeath() return false end
function modifier_lina_dragon_slave_custom_cd:IsDebuff() return true end
function modifier_lina_dragon_slave_custom_cd:OnCreated()
self.RemoveForDuel = true
end




modifier_lina_dragon_slave_custom_magic = class({})
function modifier_lina_dragon_slave_custom_magic:IsHidden() return false end
function modifier_lina_dragon_slave_custom_magic:IsPurgable() return true end
function modifier_lina_dragon_slave_custom_magic:GetTexture() return "buffs/remnant_lowhp" end
function modifier_lina_dragon_slave_custom_magic:OnCreated(table)

self.resist = self:GetCaster():GetTalentValue("modifier_lina_dragon_1", "resist")
self.max = self:GetCaster():GetTalentValue("modifier_lina_dragon_1", "max")

if not IsServer() then return end
self:SetStackCount(1)
end

function modifier_lina_dragon_slave_custom_magic:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end
self:IncrementStackCount()
end



function modifier_lina_dragon_slave_custom_magic:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
}
end

function modifier_lina_dragon_slave_custom_magic:GetModifierMagicalResistanceBonus()
return self:GetStackCount()*self.resist
end






modifier_lina_dragon_slave_custom_auto = class({})
function modifier_lina_dragon_slave_custom_auto:IsHidden() return true end
function modifier_lina_dragon_slave_custom_auto:IsPurgable() return false end
function modifier_lina_dragon_slave_custom_auto:OnCreated(table)
if not IsServer() then return end 

self.target = EntIndexToHScript(table.target)
end 

function modifier_lina_dragon_slave_custom_auto:OnDestroy()
if not IsServer() then return end 
if not self.target or self.target:IsNull() then return end 

self:GetAbility():OnSpellStart(self.target, "modifier_lina_dragon_4")
end 







modifier_lina_dragon_slave_custom_proc = class({})
function modifier_lina_dragon_slave_custom_proc:IsHidden() return false end
function modifier_lina_dragon_slave_custom_proc:IsPurgable() return false end
function modifier_lina_dragon_slave_custom_proc:GetTexture() return "buffs/bolt_items" end
function modifier_lina_dragon_slave_custom_proc:OnCreated(table)
if not IsServer() then return end 
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.RemoveForDuel = true

self.auto_delay = self.parent:GetTalentValue("modifier_lina_dragon_4", "delay", true)
self.proc_count = self.parent:GetTalentValue("modifier_lina_dragon_4", "count", true)

self.search_radius = self.ability:GetSpecialValueFor( "dragon_slave_distance" )

self:SetStackCount(1)
end 


function modifier_lina_dragon_slave_custom_proc:OnRefresh(table)
if not IsServer() then return end 

self:IncrementStackCount()

if self:GetStackCount() < self.proc_count then return end

if self.parent:HasTalent("modifier_lina_dragon_2") then 
  local mana = self.parent:GetMaxMana()*self.parent:GetTalentValue("modifier_lina_dragon_2", "mana")/100

  local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_essence_effect.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent )
  ParticleManager:SetParticleControl( particle, 0, self.parent:GetAbsOrigin() )
  ParticleManager:ReleaseParticleIndex( particle )
  self.parent:EmitSound("Lina.Dragon_heal")

  self.parent:GenericHeal(mana, self:GetAbility(), nil, nil, "modifier_lina_dragon_2")
  self.parent:GiveMana(mana)
end

if self.parent:HasTalent("modifier_lina_dragon_4") then 

  local enemy_heroes = FindUnitsInRadius( self.parent:GetTeamNumber(), self.parent:GetAbsOrigin() , nil, self.search_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
  local enemy_creeps = FindUnitsInRadius( self.parent:GetTeamNumber(), self.parent:GetAbsOrigin() , nil, self.search_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
  local target = nil

  if #enemy_heroes > 0 then
    target = enemy_heroes[1]
  else 
    if #enemy_creeps > 0 then 
      target = enemy_creeps[1]
    end
  end

  if target then
    if table.dragon and table.dragon == 1 then  
      self.parent:AddNewModifier(self.parent, self.ability, "modifier_lina_dragon_slave_custom_auto", {target = target:entindex(), duration = self.auto_delay})
    else 
      self.ability:OnSpellStart(target, "modifier_lina_dragon_4")
    end 
  end 
end

self:Destroy()
end