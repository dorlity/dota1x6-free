LinkLuaModifier( "modifier_lina_fiery_soul_custom", "abilities/lina/lina_fiery_soul_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_lina_fiery_soul_custom_stack", "abilities/lina/lina_fiery_soul_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_lina_fiery_soul_custom_legendary", "abilities/lina/lina_fiery_soul_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_lina_fiery_soul_custom_legendary_attacks", "abilities/lina/lina_fiery_soul_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_lina_fiery_soul_custom_legendary_attacks_caster", "abilities/lina/lina_fiery_soul_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_lina_fiery_soul_custom_heal", "abilities/lina/lina_fiery_soul_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_lina_fiery_soul_custom_heal_cd", "abilities/lina/lina_fiery_soul_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_lina_fiery_soul_custom_cast", "abilities/lina/lina_fiery_soul_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_lina_fiery_soul_custom_damage", "abilities/lina/lina_fiery_soul_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_lina_fiery_soul_custom_quest", "abilities/lina/lina_fiery_soul_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_lina_fiery_soul_custom_stack", "abilities/lina/lina_fiery_soul_custom", LUA_MODIFIER_MOTION_NONE)




lina_fiery_soul_custom = class({})

function lina_fiery_soul_custom:CreateTalent(name)

if name == "modifier_lina_soul_legendary" and self:GetLevel() > 0 then 
  self:SetActivated(false)
end

if name == "modifier_lina_soul_3" then
  local mod = self:GetCaster():FindModifierByName("modifier_lina_fiery_soul_custom")
  if mod then
    mod.PercentStr = self:GetCaster():GetTalentValue("modifier_lina_soul_3", "str")/100
  end
end

end



function lina_fiery_soul_custom:GetAbilityTextureName()
if self:GetCaster():HasModifier("modifier_arcana_lina_custom") then
    return "lina_fiery_soul_alt1"
end
return "lina_fiery_soul"
end

function lina_fiery_soul_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end

PrecacheResource( "particle", "particles/lina_soul.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_lina/lina_fiery_soul.vpcf", context )
PrecacheResource( "particle", "particles/lina_lowhp.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_phoenix/phoenix_icarus_dive_burn_debuff.vpcf", context )
PrecacheResource( "particle", "particles/lina/soul_stack.vpcf", context )
PrecacheResource( "particle", "particles/econ/items/huskar/huskar_2021_immortal/huskar_2021_immortal_burning_spear_debuff.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_sniper/sniper_headshot_slow.vpcf", context )
PrecacheResource( "particle", "particles/lina_attack_slow.vpcf", context )

end



function lina_fiery_soul_custom:GetCastRange(vLocation, hTarget)
if self:GetCaster():HasTalent("modifier_lina_soul_legendary") then
  return self:GetCaster():GetTalentValue("modifier_lina_soul_legendary", "range")
end
return 0
end

function lina_fiery_soul_custom:GetBehavior()
if self:GetCaster():HasTalent("modifier_lina_soul_legendary") then
  return  DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE
end
return DOTA_ABILITY_BEHAVIOR_PASSIVE
end

function lina_fiery_soul_custom:GetManaCost(iLevel)
if self:GetCaster():HasTalent("modifier_lina_soul_legendary") then
  return self:GetCaster():GetTalentValue("modifier_lina_soul_legendary", "mana")
end
return 0
end


function lina_fiery_soul_custom:OnUpgrade()
if self:GetCaster():HasTalent("modifier_lina_soul_legendary") and self:GetLevel() == 1 then
  self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_lina_fiery_soul_custom_cast", {duration = self:GetCaster():GetTalentValue("modifier_lina_soul_legendary", "cast")})
end    

end


function lina_fiery_soul_custom:GetCooldown(iLevel)
  if self:GetCaster():HasTalent("modifier_lina_soul_legendary") then
    return  self:GetCaster():GetTalentValue("modifier_lina_soul_legendary", "cd")
  end
 return 
end


function lina_fiery_soul_custom:GetIntrinsicModifierName()
if not self:GetCaster():IsRealHero() then return end
return "modifier_lina_fiery_soul_custom"
end


function lina_fiery_soul_custom:GetShardDamage()
local caster = self:GetCaster()

if not caster:HasShard() then return 0 end

local mod = caster:FindModifierByName("modifier_lina_fiery_soul_custom")
local damage = 0

if mod then 
  damage = mod:GetStackCount()*self:GetSpecialValueFor("shard_damage")
end 

return damage
end 



function lina_fiery_soul_custom:OnSpellStart()
if not IsServer() then return end

local caster = self:GetCaster()

if not caster:HasTalent("modifier_lina_soul_legendary") then return end

caster:RemoveModifierByName("modifier_lina_fiery_soul_custom_cast")
caster:EmitSound("Lina.Soul_Active")

local range = caster:GetTalentValue("modifier_lina_soul_legendary", "range")
local duration = caster:GetTalentValue("modifier_lina_soul_legendary", "duration")
local min_distance = caster:GetTalentValue("modifier_lina_soul_legendary", "min_distance")
local damage = self:GetShardDamage()

local resist_duration = caster:GetTalentValue("modifier_lina_dragon_1", "duration")

local particle = ParticleManager:CreateParticle("particles/lina_soul.vpcf", PATTACH_POINT, caster)
ParticleManager:SetParticleControl(particle, 1, Vector(range*0.8, 0, 0))
ParticleManager:SetParticleControl(particle, 3, caster:GetAbsOrigin())
ParticleManager:ReleaseParticleIndex(particle)

local targets = caster:FindTargets(range)

for _,enemy in pairs(targets) do 

  local enemyAbs = enemy:GetAbsOrigin()
  local center = caster:GetAbsOrigin()
  local direction = enemyAbs - center
  direction.z = 0
  direction = direction:Normalized()

  if caster == enemyAbs then
    direction = enemy:GetForwardVector()
  end 

  local point = center + range*direction
  local length = (point - enemyAbs):Length2D() 

  local knockbackProperties =
  {
    center_x = center.x,
    center_y = center.y,
    center_z = center.z,
    duration = duration,
    knockback_duration = duration,
    knockback_distance = math.max(length, min_distance),
    knockback_height = 0,
    should_stun = 0
  }
  enemy:AddNewModifier( self:GetCaster(), self, "modifier_knockback", knockbackProperties )

  if caster:GetQuest() == "Lina.Quest_7" and enemy:IsRealHero() and not caster:QuestCompleted() then 
    enemy:AddNewModifier(caster, self, "modifier_lina_fiery_soul_custom_quest", {duration = caster.quest.number})
  end

  if caster:HasTalent("modifier_lina_dragon_1") then 
    enemy:AddNewModifier(caster, self, "modifier_lina_dragon_slave_custom_magic", {duration = resist_duration})
  end 
  
  if damage > 0 then
    DoDamage({victim = enemy, attacker = caster, ability = self, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL}, "modifier_lina_soul_legendary")
  end

  enemy:AddNewModifier(caster, self, "modifier_lina_fiery_soul_custom_legendary_attacks", {duration = 0.5})

  enemy:EmitSound("Lina.Soul_Active_target")
end


if caster:HasTalent("modifier_lina_soul_4") and #targets > 0 then 
  caster:AddNewModifier(caster, self, "modifier_lina_fiery_soul_custom_stack", {duration = caster:GetTalentValue("modifier_lina_soul_4", "duration", true)})
end  

end




modifier_lina_fiery_soul_custom = class({})

function modifier_lina_fiery_soul_custom:IsHidden() return self:GetStackCount() == 0 end
function modifier_lina_fiery_soul_custom:IsPurgable() return false end
function modifier_lina_fiery_soul_custom:DestroyOnExpire() return false end

function modifier_lina_fiery_soul_custom:OnCreated( kv )

self.parent = self:GetParent()
self.parent:AddSpellEvent(self)

self.ability = self:GetAbility()

if self.parent:IsRealHero() then 
  self.parent:AddDamageEvent_out(self)
  self.parent:AddDamageEvent_inc(self)
  self.parent:AddAttackEvent_out(self)
end

self.as_bonus = self.ability:GetSpecialValueFor( "fiery_soul_attack_speed_bonus" )
self.ms_bonus = self.ability:GetSpecialValueFor( "fiery_soul_move_speed_bonus" )
self.max_stacks = self.ability:GetSpecialValueFor( "fiery_soul_max_stacks" )
self.duration = self.ability:GetSpecialValueFor( "fiery_soul_stack_duration" )

self.heal_cd = self.parent:GetTalentValue("modifier_lina_soul_6", "cd", true)
self.heal_amount = self.parent:GetTalentValue("modifier_lina_soul_6", "heal", true)/100
self.heal_duration = self.parent:GetTalentValue("modifier_lina_soul_6", "duration", true)

self.max_inc = self.parent:GetTalentValue("modifier_lina_soul_5", "max", true)
self.move_max = self.parent:GetTalentValue("modifier_lina_soul_5", "move_real", true)

self.damage_duration = self.parent:GetTalentValue("modifier_lina_soul_2", "duration", true)

self.legendary_cast = self.parent:GetTalentValue("modifier_lina_soul_legendary", "cast", true)

self.stun_duration = self.parent:GetTalentValue("modifier_lina_soul_4", "stun", true)

if not IsServer() then return end
self.particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_lina/lina_fiery_soul.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
ParticleManager:SetParticleControl( self.particle, 1, Vector( self:GetStackCount(), 0, 0 ) )
self:AddParticle( self.particle, false, false, -1, false, false  )
end

function modifier_lina_fiery_soul_custom:OnRefresh( kv )
self.as_bonus = self.ability:GetSpecialValueFor( "fiery_soul_attack_speed_bonus" )
self.ms_bonus = self.ability:GetSpecialValueFor( "fiery_soul_move_speed_bonus" )
self.max_stacks = self.ability:GetSpecialValueFor( "fiery_soul_max_stacks" )
self.duration = self.ability:GetSpecialValueFor( "fiery_soul_stack_duration" )
end

function modifier_lina_fiery_soul_custom:DeclareFunctions()
return 
{
  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
  MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
  MODIFIER_PROPERTY_MOVESPEED_LIMIT,
  MODIFIER_PROPERTY_MOVESPEED_MAX,
  MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
  MODIFIER_PROPERTY_MIN_HEALTH,
}
end




function modifier_lina_fiery_soul_custom:AttackEvent_out(params)
if not IsServer() then return end
if self.parent ~= params.attacker then return end
if not params.target:IsUnit() then return end

local mod = self.parent:FindModifierByName("modifier_lina_fiery_soul_custom_stack")
if mod and self.parent:HasTalent("modifier_lina_soul_4") then 

  local chance = self.parent:GetTalentValue("modifier_lina_soul_4", "chance")*mod:GetStackCount()

  if RollPseudoRandomPercentage(chance, 1983, self.parent) then 
    params.target:EmitSound("Lina.Soul_slow")
    params.target:AddNewModifier(self.parent, self.parent:BkbAbility(self.ability, true), "modifier_stunned", {duration = self.stun_duration})
  end 
end 

if self.parent:HasTalent("modifier_lina_soul_3") then
  local heal = (self.parent:GetMaxHealth() - self.parent:GetHealth())*self.parent:GetTalentValue("modifier_lina_soul_3", "heal")/100
  self.parent:GenericHeal(heal, self.ability, true, nil, "modifier_lina_soul_3")
end


if not self.parent:HasTalent("modifier_lina_soul_2") then return end
self.parent:AddNewModifier(self.parent, self.ability, "modifier_lina_fiery_soul_custom_damage", {duration = self.damage_duration})
end






function modifier_lina_fiery_soul_custom:SpellEvent( params )
if not IsServer() then return end
if params.unit~=self.parent then return end
if not params.ability then return end

if params.ability:GetName() == "lina_flame_cloak" then 
  self:SetStacks(0, true)
end

if params.ability:IsItem() then return end

if params.ability ~= self.ability and self.parent:HasTalent("modifier_lina_soul_legendary") then 
  self.parent:AddNewModifier(self.parent, self.ability, "modifier_lina_fiery_soul_custom_cast", {duration = self.legendary_cast})
end

end




function modifier_lina_fiery_soul_custom:GetMinHealth()
if self.parent:LethalDisabled() then return end
if self.parent:PassivesDisabled() then return end
if not self.parent:IsAlive() then return end
if not self.parent:HasTalent("modifier_lina_soul_6") then return end
if self.parent:HasModifier("modifier_lina_fiery_soul_custom_heal_cd") then return end

return 1
end



function modifier_lina_fiery_soul_custom:SetStacks(count, set_max)
if not IsServer() then return end 

local max = self.max_stacks
if self.parent:HasTalent("modifier_lina_soul_5") then 
  max = max + self.max_inc
end

if set_max and set_max == true then 
  self:SetStackCount(max)
else 
  self:SetStackCount(count)
end 

self:SetDuration( self.duration, true )
self:StartIntervalThink( self.duration )
ParticleManager:SetParticleControl( self.particle, 1, Vector( self:GetStackCount(), 0, 0 ) )
end 



function modifier_lina_fiery_soul_custom:DamageEvent_out(params)
if not IsServer() then return end
if not params.attacker then return end 

if self.parent == params.attacker and params.inflictor ~= nil and not UnvalidAbilities[params.inflictor:GetName()] and not params.inflictor:IsItem() then

  local max = self.max_stacks
  if self.parent:HasTalent("modifier_lina_soul_5") then 
    max = max + self.max_inc
  end

  if self:GetStackCount()<max then
    self:SetStacks(self:GetStackCount() + 1)
  else 
    self:SetStacks(self:GetStackCount())
  end 
end

end

function modifier_lina_fiery_soul_custom:DamageEvent_inc(params)
if not IsServer() then return end
if params.unit ~= self.parent then return end
if self.parent:HasModifier("modifier_death") then return end
if not self.parent:HasTalent("modifier_lina_soul_6") then return end
if self.parent:GetHealth() > 1 then return end
if self.parent:PassivesDisabled() then return end
if self.parent:HasModifier("modifier_lina_fiery_soul_custom_heal_cd") then return end

self.parent:SetHealth(self.parent:GetMaxHealth() * self.heal_amount)
self.parent:Purge(false, true, false, false, false)

local particle = ParticleManager:CreateParticle( "particles/lina_lowhp.vpcf", PATTACH_POINT_FOLLOW, self.parent )
ParticleManager:SetParticleControlEnt( particle, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true )
ParticleManager:ReleaseParticleIndex(particle)

self.parent:EmitSound("Lina.Soul_lowhp")
self.parent:AddNewModifier(self.parent, self.ability, "modifier_lina_fiery_soul_custom_heal_cd", {duration = self.heal_cd})
self.parent:AddNewModifier(self.parent, self.ability, "modifier_lina_fiery_soul_custom_heal", {duration = self.heal_duration})
end
function modifier_lina_fiery_soul_custom:GetModifierIgnoreMovespeedLimit( params )
if self.parent:HasTalent("modifier_lina_soul_5") then 
  return 1
end
return 0
end


function modifier_lina_fiery_soul_custom:GetModifierMoveSpeed_Max( params )
if self.parent:HasTalent("modifier_lina_soul_5") then 
  return self.move_max
end
return 
end


function modifier_lina_fiery_soul_custom:GetModifierMoveSpeed_Limit()
if self.parent:HasTalent("modifier_lina_soul_5") then 
  return self.move_max
end
return 
end

function modifier_lina_fiery_soul_custom:GetModifierMoveSpeedBonus_Percentage( params )
local bonus = 0
if self.parent:HasTalent("modifier_lina_soul_1") then 
  bonus = self.parent:GetTalentValue("modifier_lina_soul_1", "move")
end

return self:GetStackCount() * (self.ms_bonus + bonus)
end

function modifier_lina_fiery_soul_custom:GetModifierAttackSpeedBonus_Constant( params )
local bonus = 0
if self.parent:HasTalent("modifier_lina_soul_1") then 
  bonus = self.parent:GetTalentValue("modifier_lina_soul_1", "speed")
end

return self:GetStackCount() * (self.as_bonus + bonus)
end


function modifier_lina_fiery_soul_custom:OnIntervalThink()

self:StartIntervalThink( -1 )
self:SetStackCount( 0 )
ParticleManager:SetParticleControl( self.particle, 1, Vector( self:GetStackCount(), 0, 0 ) )
end






modifier_lina_fiery_soul_custom_heal_cd = class({})

function modifier_lina_fiery_soul_custom_heal_cd:IsPurgable() return false end
function modifier_lina_fiery_soul_custom_heal_cd:IsHidden() return false end
function modifier_lina_fiery_soul_custom_heal_cd:IsDebuff() return true end
function modifier_lina_fiery_soul_custom_heal_cd:RemoveOnDeath() return false end
function modifier_lina_fiery_soul_custom_heal_cd:GetTexture()
  return "buffs/soul_heal" end
function modifier_lina_fiery_soul_custom_heal_cd:OnCreated(table)
  self.RemoveForDuel = true
end






modifier_lina_fiery_soul_custom_heal = class({})
function modifier_lina_fiery_soul_custom_heal:IsPurgable() return false end
function modifier_lina_fiery_soul_custom_heal:IsHidden() return false end
function modifier_lina_fiery_soul_custom_heal:IsDebuff() return true end
function modifier_lina_fiery_soul_custom_heal:GetEffectName() return "particles/units/heroes/hero_phoenix/phoenix_icarus_dive_burn_debuff.vpcf" end
function modifier_lina_fiery_soul_custom_heal:GetTexture() return "buffs/soul_heal" end


function modifier_lina_fiery_soul_custom_heal:OnCreated(table)
if not IsServer() then return end 
self.RemoveForDuel = true
self.parent = self:GetParent()
self.duration = self.parent:GetTalentValue("modifier_lina_soul_6", "duration")
self.interval = self.parent:GetTalentValue("modifier_lina_soul_6", "interval")

self.heal = self.parent:GetTalentValue("modifier_lina_soul_6", "heal")/100
self.reduce = (self.heal/self.duration)*self.interval

self:StartIntervalThink(self.interval)
end


function modifier_lina_fiery_soul_custom_heal:OnIntervalThink()
if not IsServer() then return end
if not self.parent:IsAlive() then return end

self.parent:EmitSound("Lina.Soul_lowhp_burn")
self.parent:SetHealth(math.max(1, self.parent:GetHealth() - self.parent:GetMaxHealth()*self.reduce))
end





modifier_lina_fiery_soul_custom_cast = class({})
function modifier_lina_fiery_soul_custom_cast:IsHidden() return true end
function modifier_lina_fiery_soul_custom_cast:IsPurgable() return false end

function modifier_lina_fiery_soul_custom_cast:OnCreated(table)
if not IsServer() then return end
self:GetAbility():SetActivated(true )
end

function modifier_lina_fiery_soul_custom_cast:OnDestroy()
if not IsServer() then return end
self:GetAbility():SetActivated(false )
end




modifier_lina_fiery_soul_custom_damage = class({})
function modifier_lina_fiery_soul_custom_damage:IsHidden() return false end
function modifier_lina_fiery_soul_custom_damage:IsPurgable() return false end
function modifier_lina_fiery_soul_custom_damage:GetTexture() return "buffs/soul_damage" end
function modifier_lina_fiery_soul_custom_damage:OnCreated(table)
self.parent = self:GetParent()

self.damage = self.parent:GetTalentValue("modifier_lina_soul_2", "damage")
self.max = self.parent:GetTalentValue("modifier_lina_soul_2", "max")
self.armor = self.parent:GetTalentValue("modifier_lina_soul_2", "armor")
self:SetStackCount(1)
end

function modifier_lina_fiery_soul_custom_damage:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end

self:IncrementStackCount()
end

function modifier_lina_fiery_soul_custom_damage:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
  MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
}
end

function modifier_lina_fiery_soul_custom_damage:GetModifierSpellAmplify_Percentage()
return self:GetStackCount()*self.damage
end

function modifier_lina_fiery_soul_custom_damage:GetModifierPhysicalArmorBonus()
return self:GetStackCount()*self.armor
end






modifier_lina_fiery_soul_custom_quest = class({})
function modifier_lina_fiery_soul_custom_quest:IsHidden() return true end
function modifier_lina_fiery_soul_custom_quest:IsPurgable() return false end









modifier_lina_fiery_soul_custom_stack = class({})
function modifier_lina_fiery_soul_custom_stack:IsHidden() return false end
function modifier_lina_fiery_soul_custom_stack:IsPurgable() return false end
function modifier_lina_fiery_soul_custom_stack:GetTexture() return "buffs/soul_proc" end
function modifier_lina_fiery_soul_custom_stack:OnCreated()
self.RemoveForDuel = true
self.parent = self:GetParent()

self.max = self.parent:GetTalentValue("modifier_lina_soul_4", "max", true)
self.damage = self.parent:GetTalentValue("modifier_lina_soul_4", "damage")
self.chance = self.parent:GetTalentValue("modifier_lina_soul_4", "chance")

if not IsServer() then return end 

self.particle = ParticleManager:CreateParticle( "particles/lina/soul_stack.vpcf", PATTACH_OVERHEAD_FOLLOW, self.parent )
self:AddParticle(self.particle,false, false, -1, false, false)

self:SetStackCount(1)
end 

function modifier_lina_fiery_soul_custom_stack:OnRefresh()
if not IsServer() then return end 
if self:GetStackCount() >= self.max then return end 

self:IncrementStackCount()

if self:GetStackCount() >= self.max then 
  self.parent:EmitSound("Lina.Soul_proc")
  self.particle = ParticleManager:CreateParticle( "particles/econ/items/huskar/huskar_2021_immortal/huskar_2021_immortal_burning_spear_debuff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent )
  self:AddParticle( self.particle, false, false, -1, false, false  )
end 

end 

function modifier_lina_fiery_soul_custom_stack:OnStackCountChanged(iStackCount)
if self:GetStackCount() == 0 then return end
if not self.particle then return end

for i = 0,self.max do 
  if i <= self:GetStackCount() then 
    ParticleManager:SetParticleControl(self.particle, i, Vector(1, 0, 0)) 
  else 
    ParticleManager:SetParticleControl(self.particle, i, Vector(0, 0, 0)) 
  end
end


end

function modifier_lina_fiery_soul_custom_stack:DeclareFunctions()
return
{

  MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
  MODIFIER_PROPERTY_TOOLTIP,
  MODIFIER_PROPERTY_MODEL_SCALE
}
end


function modifier_lina_fiery_soul_custom_stack:OnTooltip()
return self:GetStackCount()*self.chance
end

function modifier_lina_fiery_soul_custom_stack:GetModifierDamageOutgoing_Percentage()
return self:GetStackCount()*self.damage
end

function modifier_lina_fiery_soul_custom_stack:GetModifierModelScale()
if self:GetStackCount() < self.max then return end 
return 15
end






modifier_lina_fiery_soul_custom_legendary_attacks = class({})
function modifier_lina_fiery_soul_custom_legendary_attacks:IsHidden() return true end
function modifier_lina_fiery_soul_custom_legendary_attacks:IsPurgable() return false end
function modifier_lina_fiery_soul_custom_legendary_attacks:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_lina_fiery_soul_custom_legendary_attacks:OnCreated()
self.parent = self:GetParent()
self.caster = self:GetCaster()
self.ability = self:GetAbility()
self.interval = 0.15
if not IsServer() then return end
self:SetStackCount(self.caster:GetTalentValue("modifier_lina_soul_legendary", "attacks"))

self:StartIntervalThink(self.interval)
end

function modifier_lina_fiery_soul_custom_legendary_attacks:OnIntervalThink()
if not IsServer() then return end

if self.parent:IsHero() then
  self.caster:AddNewModifier(self.caster, self.ability, "modifier_lina_fiery_soul_custom_legendary_attacks_caster", {duration = FrameTime()})
end

self.caster:PerformAttack(self.parent, true, true, true, true, false, false, true)

if self.parent:IsHero() then
  self.caster:RemoveModifierByName("modifier_lina_fiery_soul_custom_legendary_attacks_caster")
end

self:DecrementStackCount()
if self:GetStackCount() <= 0 then
  self:Destroy()
end

end

modifier_lina_fiery_soul_custom_legendary_attacks_caster = class({})
function modifier_lina_fiery_soul_custom_legendary_attacks_caster:IsHidden() return true end
function modifier_lina_fiery_soul_custom_legendary_attacks_caster:IsPurgable() return false end