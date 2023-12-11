LinkLuaModifier( "modifier_snapfire_lil_shredder_custom", "abilities/snapfire/snapfire_lil_shredder_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_snapfire_lil_shredder_custom_debuff", "abilities/snapfire/snapfire_lil_shredder_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_snapfire_lil_shredder_custom_debuff_count", "abilities/snapfire/snapfire_lil_shredder_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_snapfire_lil_shredder_custom_no_aoe", "abilities/snapfire/snapfire_lil_shredder_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_snapfire_lil_shredder_custom_tracker", "abilities/snapfire/snapfire_lil_shredder_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_snapfire_lil_shredder_custom_armor", "abilities/snapfire/snapfire_lil_shredder_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_snapfire_lil_shredder_custom_armor_count", "abilities/snapfire/snapfire_lil_shredder_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_snapfire_lil_shredder_custom_silence", "abilities/snapfire/snapfire_lil_shredder_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_snapfire_lil_shredder_custom_silence_count", "abilities/snapfire/snapfire_lil_shredder_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_snapfire_lil_shredder_custom_resist", "abilities/snapfire/snapfire_lil_shredder_custom", LUA_MODIFIER_MOTION_NONE )




snapfire_lil_shredder_custom = class({})


snapfire_lil_shredder_custom.dispel_heal = 0.02
snapfire_lil_shredder_custom.dispel_resit = 30
snapfire_lil_shredder_custom.dispel_resit_duration = 4





function snapfire_lil_shredder_custom:Precache(context)

PrecacheResource( "particle", "particles/beast_ult_count.vpcf", context )
PrecacheResource( "particle", "particles/econ/items/troll_warlord/troll_warlord_ti7_axe/troll_ti7_axe_bash_explosion.vpcf", context )
PrecacheResource( "particle", "pparticles/units/heroes/hero_snapfire/hero_snapfire_shells_projectile.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_snapfire/hero_snapfire_shells_buff.vpcf", context )
PrecacheResource( "particle", "particles/items3_fx/black_powder_bag.vpcf", context )

end






function snapfire_lil_shredder_custom:GetIntrinsicModifierName()
return "modifier_snapfire_lil_shredder_custom_tracker"
end


function snapfire_lil_shredder_custom:GetCooldown(iLevel)

local bonus = 0
if self:GetCaster():HasModifier("modifier_snapfire_shredder_6") then 
  bonus = self:GetCaster():GetTalentValue("modifier_snapfire_shredder_6", "cd")
end

 return self.BaseClass.GetCooldown(self, iLevel) + bonus
 
end


function snapfire_lil_shredder_custom:OnSpellStart()

local caster = self:GetCaster()

local duration = self:GetDuration()

if self:GetCaster():HasModifier("modifier_snapfire_shredder_2") then
  duration = duration + self:GetCaster():GetTalentValue("modifier_snapfire_shredder_2", "duration")
end 

if self:GetCaster():HasModifier("modifier_snapfire_shredder_5") then 

  local mod = self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_snapfire_lil_shredder_custom_resist", {duration = self.dispel_resit_duration})

  local particle = ParticleManager:CreateParticle("particles/items4_fx/ascetic_cap.vpcf" , PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
  ParticleManager:SetParticleControl(particle, 0, self:GetCaster():GetAbsOrigin())
  mod:AddParticle(particle, false, false, -1, false, false)

end


caster:AddNewModifier( caster,   self, "modifier_snapfire_lil_shredder_custom", { duration = duration } )

self:EndCooldown()
end




modifier_snapfire_lil_shredder_custom = class({})


function modifier_snapfire_lil_shredder_custom:IsHidden()
  return false
end


function modifier_snapfire_lil_shredder_custom:IsPurgable()
  return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_snapfire_lil_shredder_custom:OnCreated( kv )
  -- references
self.attacks = self:GetAbility():GetSpecialValueFor( "buffed_attacks" )
self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
self.as_bonus = self:GetAbility():GetSpecialValueFor( "attack_speed_bonus" )
self.range_bonus = self:GetAbility():GetSpecialValueFor( "attack_range_bonus" )
self.bat = self:GetAbility():GetSpecialValueFor( "base_attack_time" )

if self:GetCaster():HasModifier("modifier_snapfire_shredder_7") then 
  self.damage = self.damage*(1 + self:GetCaster():GetTalentValue("modifier_snapfire_shredder_7", "damage")/100)
end 

if self:GetParent():HasModifier("modifier_snapfire_shredder_1") then 
  self.damage = self.damage + self:GetCaster():GetTalentValue("modifier_snapfire_shredder_1", "damage")*self:GetParent():GetAverageTrueAttackDamage(nil)/100
end

if self:GetParent():HasModifier("modifier_snapfire_shredder_2") then
  self.attacks = self.attacks + self:GetCaster():GetTalentValue("modifier_snapfire_shredder_2", "attacks")
end 

self.aoe_attacks = self:GetAbility():GetSpecialValueFor("aoe_attacks")

self.duration = self:GetAbility():GetSpecialValueFor( "armor_duration" )

if not IsServer() then return end

self.scatter_ability = self:GetParent():FindAbilityByName("snapfire_scatterblast_custom")
self.scatter_count = 0


if not self:GetParent():HasModifier("modifier_snapfire_shredder_7") then 
  self:SetStackCount( self.attacks )
else
  local name = "particles/beast_ult_count.vpcf"
  self.particle = ParticleManager:CreateParticle(name, PATTACH_OVERHEAD_FOLLOW, self:GetParent())
  self:AddParticle(self.particle, false, false, -1, false, false)

  self.max = self:GetCaster():GetTalentValue("modifier_snapfire_shredder_7", "max")
  self.decay = self:GetCaster():GetTalentValue("modifier_snapfire_shredder_7", "decay")
  self.stun = self:GetCaster():GetTalentValue("modifier_snapfire_shredder_7", "stun")
  self.attack = self:GetCaster():GetTalentValue("modifier_snapfire_shredder_7", "attack")

  self:SetStackCount(0)

  self:StartIntervalThink(0.1)
end
self.RemoveForDuel = true

self:GetParent():StartGesture(ACT_DOTA_CAST_ABILITY_3)

self.records = {}

self:GetAbility():SetActivated(false)

-- play Effects & Sound
self:PlayEffects()
self:GetParent():EmitSound("Hero_Snapfire.ExplosiveShells.Cast")
end











function modifier_snapfire_lil_shredder_custom:OnIntervalThink()
if not IsServer() then return end

self:SetStackCount(math.max(0, self:GetStackCount() - self.decay*0.1))
  
if self:GetStackCount() >= self.max then 
  self:GetParent():EmitSound("Troll.Fervor_legendary_stun")
  self:GetParent():EmitSound("Snapfire.Shredder_stun")
  local effect_cast = ParticleManager:CreateParticle( "particles/econ/items/troll_warlord/troll_warlord_ti7_axe/troll_ti7_axe_bash_explosion.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
  ParticleManager:SetParticleControl( effect_cast, 0,  self:GetParent():GetOrigin() )
  ParticleManager:SetParticleControl( effect_cast, 1, self:GetParent():GetOrigin() )

  self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_stunned", {duration = ( 1 - self:GetParent():GetStatusResistance())*self.stun})
  self:Destroy()
end


end



function modifier_snapfire_lil_shredder_custom:OnStackCountChanged(iStackCount)
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_snapfire_shredder_7") then return end

local time = self:GetRemainingTime()/(self:GetElapsedTime() + self:GetRemainingTime())

CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), 'snapfire_shredder_change',  {time = time, max = self.max, damage = self:GetStackCount()})

if not self.particle then return end

local count = math.floor(self:GetStackCount()/20)

for i = 1,5 do 
  
  if i <= count then 
    ParticleManager:SetParticleControl(self.particle, i, Vector(1, 0, 0)) 
  else 
    ParticleManager:SetParticleControl(self.particle, i, Vector(0, 0, 0)) 
  end
end


end





function modifier_snapfire_lil_shredder_custom:OnDestroy()
if not IsServer() then return end

self:GetAbility():SetActivated(true)
self:GetAbility():UseResources(false, false, false, true)


self:GetParent():StartGesture(ACT_DOTA_CAST_ABILITY_3_END)

self:GetParent():FadeGesture(ACT_DOTA_CAST_ABILITY_3)

self:GetParent():StopSound("Hero_Snapfire.ExplosiveShells.Cast")

if not self:GetParent():HasModifier("modifier_snapfire_shredder_7") then return end

CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), 'snapfire_shredder_change',  {time = 0, max = self.max, damage = self:GetStackCount()})

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_snapfire_lil_shredder_custom:DeclareFunctions()
  local funcs = {
    MODIFIER_EVENT_ON_ATTACK,
    MODIFIER_EVENT_ON_ATTACK_LANDED,
    MODIFIER_EVENT_ON_ATTACK_RECORD_DESTROY,

    MODIFIER_PROPERTY_PROJECTILE_NAME,
    MODIFIER_PROPERTY_OVERRIDE_ATTACK_DAMAGE,
    MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
    MODIFIER_PROPERTY_FIXED_ATTACK_RATE,
  }

  return funcs
end

function modifier_snapfire_lil_shredder_custom:GetModifierFixedAttackRate()
if self:GetParent():HasModifier("modifier_tower_incoming_speed") then return end
if not self:GetParent():HasModifier("modifier_snapfire_shredder_7") then return end
return 0.23
end


function modifier_snapfire_lil_shredder_custom:GetActivityTranslationModifiers()
return "explosive_shells"
end


function modifier_snapfire_lil_shredder_custom:OnAttack( params )
if params.attacker~=self:GetParent() then return end
if self:GetStackCount()<=0 and not self:GetParent():HasModifier("modifier_snapfire_shredder_7") then return end
if self:GetParent():HasModifier("modifier_snapfire_firesnap_cookie_custom_attacks") then return end



self.records[params.record] = true
  
self:GetParent():EmitSound("Hero_Snapfire.ExplosiveShellsBuff.Attack")

local projectile =
{
  Target = params.target,
  Source = self:GetParent(),
  Ability = self:GetAbility(),
  EffectName = "particles/units/heroes/hero_snapfire/hero_snapfire_shells_projectile.vpcf",
  iMoveSpeed = self:GetParent():GetProjectileSpeed(),
  vSourceLoc = self:GetParent():GetAbsOrigin(),
  bDodgeable = true,
  bProvidesVision = false,
}

local hProjectile = ProjectileManager:CreateTrackingProjectile( projectile )


if not self:GetParent():HasModifier("modifier_snapfire_lil_shredder_custom_no_aoe") then 


  if self:GetCaster():HasModifier("modifier_snapfire_scatter_7") and self.scatter_ability and self.scatter_ability:GetLevel() > 0 then 
    self.scatter_count = self.scatter_count + 1

    if self.scatter_count >= self:GetCaster():GetTalentValue("modifier_snapfire_scatter_7", "count") then 
      self.scatter_count = 0

      self.scatter_ability:OnSpellStart(self:GetParent():GetAbsOrigin() + self:GetParent():GetForwardVector()*10)
    end
  end

  if self:GetParent():HasModifier("modifier_snapfire_shredder_7") then 
    self:SetStackCount(self:GetStackCount() + self.attack)


  end

  if self:GetCaster():HasModifier("modifier_snapfire_shredder_3") then 
    self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_snapfire_lil_shredder_custom_armor", {duration = self:GetCaster():GetTalentValue("modifier_snapfire_shredder_3", "duration")})
    self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_snapfire_lil_shredder_custom_armor_count", {duration = self:GetCaster():GetTalentValue("modifier_snapfire_shredder_3", "duration")})
  end

  if self:GetCaster():HasModifier("modifier_snapfire_shredder_5") then 
    my_game:GenericHeal(self:GetParent(), self:GetParent():GetMaxHealth()*self:GetAbility().dispel_heal, self:GetAbility())
  end

  self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_snapfire_lil_shredder_custom_no_aoe", {})

  local n = 0

  local targets = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self:GetParent():Script_GetAttackRange()*1.2 , DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false)

  for _,enemy in pairs(targets) do
    if enemy ~= params.target and n < self.aoe_attacks and enemy:GetUnitName() ~= "npc_teleport" then 
      n = n + 1
      self:GetParent():PerformAttack(enemy, true, false, true, false, true, false, false)
    end
  end     

  self:GetParent():RemoveModifierByName("modifier_snapfire_lil_shredder_custom_no_aoe")

  if self:GetStackCount()>0 and not self:GetParent():HasModifier("modifier_snapfire_shredder_7") then
    self:DecrementStackCount()
  end
end



end

function modifier_snapfire_lil_shredder_custom:OnAttackLanded( params )
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end


  if self.records[params.record] then

    if self:GetParent():HasModifier("modifier_snapfire_shredder_6") then 
      params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_snapfire_lil_shredder_custom_silence_count", {duration = self:GetCaster():GetTalentValue("modifier_snapfire_shredder_6", "duration")})
    end

    params.target:AddNewModifier( self:GetParent(),  self:GetAbility(), "modifier_snapfire_lil_shredder_custom_debuff", { duration = self.duration } )
    params.target:AddNewModifier( self:GetParent(),  self:GetAbility(), "modifier_snapfire_lil_shredder_custom_debuff_count", { duration = self.duration } )
  end

  params.target:EmitSound("Hero_Snapfire.ExplosiveShellsBuff.Target")
end

function modifier_snapfire_lil_shredder_custom:OnAttackRecordDestroy( params )
  if self.records[params.record] then
    self.records[params.record] = nil

    -- if table is empty and no stack left, destroy
    if next(self.records)==nil and (self:GetStackCount()<=0 and not self:GetParent():HasModifier("modifier_snapfire_shredder_7")) then
      self:Destroy()
    end
  end
end

function modifier_snapfire_lil_shredder_custom:GetModifierProjectileName()
  if self:GetStackCount()<=0 and not self:GetParent():HasModifier("modifier_snapfire_shredder_7") then return end
 -- return "particles/units/heroes/hero_snapfire/hero_snapfire_shells_projectile.vpcf"
end

function modifier_snapfire_lil_shredder_custom:GetModifierOverrideAttackDamage()
  if self:GetStackCount()<=0 and not self:GetParent():HasModifier("modifier_snapfire_shredder_7") then return end
if self:GetParent():HasModifier("modifier_snapfire_firesnap_cookie_custom_attacks") then return end
  return self.damage
end

function modifier_snapfire_lil_shredder_custom:GetModifierAttackRangeBonus()
  if self:GetStackCount()<=0 and not self:GetParent():HasModifier("modifier_snapfire_shredder_7") then return end
if self:GetParent():HasModifier("modifier_snapfire_firesnap_cookie_custom_attacks") then return end
  return self.range_bonus
end

function modifier_snapfire_lil_shredder_custom:GetModifierAttackSpeedBonus_Constant()
  if self:GetStackCount()<=0 and not self:GetParent():HasModifier("modifier_snapfire_shredder_7") then return end
if self:GetParent():HasModifier("modifier_snapfire_firesnap_cookie_custom_attacks") then return end
  return self.as_bonus
end

function modifier_snapfire_lil_shredder_custom:GetModifierBaseAttackTimeConstant()
  if self:GetStackCount()<=0 and not self:GetParent():HasModifier("modifier_snapfire_shredder_7") then return end
if self:GetParent():HasModifier("modifier_snapfire_firesnap_cookie_custom_attacks") then return end
  return self.bat
end



function modifier_snapfire_lil_shredder_custom:PlayEffects()

  local particle_cast = "particles/units/heroes/hero_snapfire/hero_snapfire_shells_buff.vpcf"

  local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
  ParticleManager:SetParticleControlEnt( effect_cast, 3, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_vent_01_fx", Vector(0,0,0),  true )
  ParticleManager:SetParticleControlEnt( effect_cast, 4, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_vent_02_fx", Vector(0,0,0),  true  )
  ParticleManager:SetParticleControlEnt( effect_cast, 5,  self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc",  Vector(0,0,0), true  )


  self:AddParticle( effect_cast, false,  false,  -1, false, false )
end



modifier_snapfire_lil_shredder_custom_debuff = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_snapfire_lil_shredder_custom_debuff:IsHidden()
  return false
end

function modifier_snapfire_lil_shredder_custom_debuff:IsDebuff()
  return true
end

function modifier_snapfire_lil_shredder_custom_debuff:IsStunDebuff()
  return false
end

function modifier_snapfire_lil_shredder_custom_debuff:IsPurgable()
  return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_snapfire_lil_shredder_custom_debuff:OnCreated( kv )
  -- references
  self.armor = -self:GetAbility():GetSpecialValueFor( "armor_reduction_per_attack" )

  if not IsServer() then return end
  self:SetStackCount( 1 )
end

function modifier_snapfire_lil_shredder_custom_debuff:OnRefresh( kv )
  if not IsServer() then return end
  self:IncrementStackCount()
end

function modifier_snapfire_lil_shredder_custom_debuff:OnRemoved()
end

function modifier_snapfire_lil_shredder_custom_debuff:OnDestroy()
end


function modifier_snapfire_lil_shredder_custom_debuff:DeclareFunctions()
  local funcs = {
    MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
  }

  return funcs
end

function modifier_snapfire_lil_shredder_custom_debuff:GetModifierPhysicalArmorBonus()
  return self.armor * self:GetStackCount()
end


function modifier_snapfire_lil_shredder_custom_debuff:GetEffectName()
 -- return "particles/items2_fx/medallion_of_courage_b.vpcf"
end

function modifier_snapfire_lil_shredder_custom_debuff:GetEffectAttachType()
 -- return PATTACH_OVERHEAD_FOLLOW
end






modifier_snapfire_lil_shredder_custom_debuff_count = class({})
function modifier_snapfire_lil_shredder_custom_debuff_count:IsHidden() return true end
function modifier_snapfire_lil_shredder_custom_debuff_count:IsPurgable() return false end
function modifier_snapfire_lil_shredder_custom_debuff_count:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_snapfire_lil_shredder_custom_debuff_count:OnDestroy()
if not IsServer() then return end

local mod = self:GetParent():FindModifierByName("modifier_snapfire_lil_shredder_custom_debuff")

if mod then 
  mod:DecrementStackCount()

  if mod:GetStackCount() == 0 then 
    mod:Destroy()
  end
end



end

modifier_snapfire_lil_shredder_custom_no_aoe = class({})
function modifier_snapfire_lil_shredder_custom_no_aoe:IsHidden() return true end
function modifier_snapfire_lil_shredder_custom_no_aoe:IsPurgable() return false end



modifier_snapfire_lil_shredder_custom_tracker = class({})
function modifier_snapfire_lil_shredder_custom_tracker:IsHidden() return true end
function modifier_snapfire_lil_shredder_custom_tracker:IsPurgable() return false end
function modifier_snapfire_lil_shredder_custom_tracker:DeclareFunctions()
return
{
  MODIFIER_EVENT_ON_ATTACK_LANDED
}
end

function modifier_snapfire_lil_shredder_custom_tracker:OnAttackLanded(params)
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_snapfire_shredder_4") then return end
if self:GetParent() ~= params.attacker then return end
if not params.target:IsHero() and not params.target:IsCreep() then return end

local chance = self:GetCaster():GetTalentValue("modifier_snapfire_shredder_4", "chance")

if not RollPseudoRandomPercentage(chance ,283,self:GetParent()) then return end
    

local duration = self:GetAbility():GetSpecialValueFor("armor_duration")

for i = 1, self:GetCaster():GetTalentValue("modifier_snapfire_shredder_4", "stack") do 
  params.target:AddNewModifier( self:GetParent(),  self:GetAbility(), "modifier_snapfire_lil_shredder_custom_debuff", { duration = duration } )
  params.target:AddNewModifier( self:GetParent(),  self:GetAbility(), "modifier_snapfire_lil_shredder_custom_debuff_count", { duration = duration } )
end

params.target:EmitSound("Snapfire.Shredder_bash")
params.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_bashed", {duration = self:GetCaster():GetTalentValue("modifier_snapfire_shredder_4", "stun")})

end



modifier_snapfire_lil_shredder_custom_armor = class({})
function modifier_snapfire_lil_shredder_custom_armor:IsHidden() return false end
function modifier_snapfire_lil_shredder_custom_armor:IsPurgable() return false end
function modifier_snapfire_lil_shredder_custom_armor:GetTexture() return "buffs/shredder_armor" end
function modifier_snapfire_lil_shredder_custom_armor:OnCreated(table)

self.armor = self:GetCaster():GetTalentValue("modifier_snapfire_shredder_3", "armor")
self.move = self:GetCaster():GetTalentValue("modifier_snapfire_shredder_3", "move")

if not IsServer() then return end

self:SetStackCount(1)

end

function modifier_snapfire_lil_shredder_custom_armor:OnRefresh(table)
if not IsServer() then return end
self:IncrementStackCount()
end

function modifier_snapfire_lil_shredder_custom_armor:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
  MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
}
end


function modifier_snapfire_lil_shredder_custom_armor:GetModifierPhysicalArmorBonus()
return self:GetStackCount()*self.armor
end


function modifier_snapfire_lil_shredder_custom_armor:GetModifierMoveSpeedBonus_Constant()
return self:GetStackCount()*self.move 
end




modifier_snapfire_lil_shredder_custom_armor_count = class({})
function modifier_snapfire_lil_shredder_custom_armor_count:IsHidden() return true end
function modifier_snapfire_lil_shredder_custom_armor_count:IsPurgable() return false end
function modifier_snapfire_lil_shredder_custom_armor_count:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_snapfire_lil_shredder_custom_armor_count:OnDestroy()
if not IsServer() then return end

local mod = self:GetParent():FindModifierByName("modifier_snapfire_lil_shredder_custom_armor")

if mod then 
  mod:DecrementStackCount()

  if mod:GetStackCount() == 0 then 
    mod:Destroy()
  end
end



end



modifier_snapfire_lil_shredder_custom_silence_count = class({})
function modifier_snapfire_lil_shredder_custom_silence_count:IsHidden() return true end
function modifier_snapfire_lil_shredder_custom_silence_count:IsPurgable() return false end
function modifier_snapfire_lil_shredder_custom_silence_count:OnCreated(table)
if not IsServer() then return end
self.count = self:GetCaster():GetTalentValue("modifier_snapfire_shredder_6", "count")

self:SetStackCount(1)
end

function modifier_snapfire_lil_shredder_custom_silence_count:OnRefresh()
if not IsServer() then return end

self:IncrementStackCount()

if self:GetStackCount() >= self.count then 

  self:GetParent():EmitSound("Snapfire.Shredder_silence")
  local effect_cast = ParticleManager:CreateParticle( "particles/items3_fx/black_powder_bag.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
  ParticleManager:SetParticleControl( effect_cast, 0,  self:GetParent():GetOrigin() )
  ParticleManager:SetParticleControl( effect_cast, 1, self:GetParent():GetOrigin() )
  ParticleManager:ReleaseParticleIndex(effect_cast)

  self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_snapfire_lil_shredder_custom_silence", {duration = (1 - self:GetParent():GetStatusResistance())*self:GetCaster():GetTalentValue("modifier_snapfire_shredder_6", "silence")})
  self:Destroy()
end

end

modifier_snapfire_lil_shredder_custom_silence = class({})
function modifier_snapfire_lil_shredder_custom_silence:IsHidden() return false end
function modifier_snapfire_lil_shredder_custom_silence:IsPurgable() return true end
function modifier_snapfire_lil_shredder_custom_silence:GetTexture() return "buffs/shredder_silence" end
function modifier_snapfire_lil_shredder_custom_silence:CheckState()
return
{
  [MODIFIER_STATE_SILENCED] = true
}
end

function modifier_snapfire_lil_shredder_custom_silence:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end


function modifier_snapfire_lil_shredder_custom_silence:OnCreated()
self.slow = self:GetCaster():GetTalentValue("modifier_snapfire_shredder_6", "slow")
end

function modifier_snapfire_lil_shredder_custom_silence:GetEffectName() return "particles/generic_gameplay/generic_silenced.vpcf" end

function modifier_snapfire_lil_shredder_custom_silence:ShouldUseOverheadOffset() return true end
function modifier_snapfire_lil_shredder_custom_silence:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end

function modifier_snapfire_lil_shredder_custom_silence:GetModifierMoveSpeedBonus_Percentage()
return self.slow
end


modifier_snapfire_lil_shredder_custom_resist = class({})
function modifier_snapfire_lil_shredder_custom_resist:IsHidden() return false end
function modifier_snapfire_lil_shredder_custom_resist:IsPurgable() return false end
function modifier_snapfire_lil_shredder_custom_resist:GetTexture() return "buffs/shredder_resist" end
function modifier_snapfire_lil_shredder_custom_resist:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
}
end



function modifier_snapfire_lil_shredder_custom_resist:GetModifierStatusResistanceStacking() 

  return self:GetAbility().dispel_resit
end