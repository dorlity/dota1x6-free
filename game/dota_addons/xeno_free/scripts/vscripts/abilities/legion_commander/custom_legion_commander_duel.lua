LinkLuaModifier("modifier_duel_buff", "abilities/legion_commander/custom_legion_commander_duel", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_duel_damage", "abilities/legion_commander/custom_legion_commander_duel", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_duel_win_duration", "abilities/legion_commander/custom_legion_commander_duel", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_duel_double_tracker", "abilities/legion_commander/custom_legion_commander_duel", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_duel_double_choosing", "abilities/legion_commander/custom_legion_commander_duel", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_duel_double_effect", "abilities/legion_commander/custom_legion_commander_duel", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_duel_double_effect_target", "abilities/legion_commander/custom_legion_commander_duel", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_duel_double_win", "abilities/legion_commander/custom_legion_commander_duel", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_duel_target_damage", "abilities/legion_commander/custom_legion_commander_duel", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_duel_custom_scepter", "abilities/legion_commander/custom_legion_commander_duel", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_duel_custom_scepter_unit", "abilities/legion_commander/custom_legion_commander_duel", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_duel_custom_scepter_knock_cd", "abilities/legion_commander/custom_legion_commander_duel", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_duel_custom_str", "abilities/legion_commander/custom_legion_commander_duel", LUA_MODIFIER_MOTION_NONE)


custom_legion_commander_duel = class({})


function custom_legion_commander_duel:GetAbilityTextureName()
    if self:GetCaster():HasModifier("modifier_legion_commander_arcana_custom") then
        return "legion_commander_duel_alt1"
    end
    return "legion_commander_duel"
end


function custom_legion_commander_duel:Precache(context)

PrecacheResource( "particle", "particles/units/heroes/hero_legion_commander/legion_commander_duel_victory.vpcf", context )
PrecacheResource( "particle", "particles/beast_grave.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_legion_commander/legion_duel_ring.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_oracle/oracle_false_promise_heal.vpcf", context )
PrecacheResource( "particle", "particles/lc_odd_charge_hit_.vpcf", context )
PrecacheResource( "particle", "particles/lc_odd_charge.vpcf", context )
PrecacheResource( "particle", "particles/lc_odd_proc_.vpcf", context )
PrecacheResource( "particle", "particles/lc_press_heal.vpcf", context )
PrecacheResource( "particle", "particles/lc_odd_proc_hands_2.vpcf", context )
PrecacheResource( "particle", "particles/jugg_parry.vpcf", context )
PrecacheResource( "particle", "particles/legion_commander/scepter_duel.vpcf", context )

end


function custom_legion_commander_duel:GetCooldown(iLevel)

local upgrade_cooldown = 0

if self:GetCaster():HasModifier("modifier_legion_duel_passive") then  
  upgrade_cooldown = self:GetCaster():GetTalentValue("modifier_legion_duel_passive", "cd")
end 

 return self.BaseClass.GetCooldown(self, iLevel) + upgrade_cooldown

end






function custom_legion_commander_duel:GetIntrinsicModifierName()
return "modifier_duel_double_tracker"
end


function custom_legion_commander_duel:GetCastRange(vLocation, hTarget)

local upgrade = 0
if self:GetCaster():HasModifier("modifier_legion_duel_passive") then 
  upgrade = self:GetCaster():GetTalentValue("modifier_legion_duel_passive", "range")
end
return self.BaseClass.GetCastRange(self , vLocation , hTarget) + upgrade 
end




function custom_legion_commander_duel:StartDuel(target)
if not IsServer() then return end


self.caster = self:GetCaster()
local duration = self:GetSpecialValueFor("duration") + self:GetCaster():GetTalentValue("modifier_legion_duel_damage", "duration")

if self:GetCaster():IsIllusion() then 
  duration = 1.5
end

duration = duration*(1 - target:GetStatusResistance())


if self.caster:HasModifier("modifier_legion_duel_speed") then 
  target:AddNewModifier(self.caster, self, "modifier_duel_target_damage", {duration = duration})
end

local sound_cast = "Hero_LegionCommander.Duel.Cast"
if self:GetCaster():HasModifier("modifier_legion_commander_arcana_custom") then
    sound_cast = "Hero_LegionCommander.Duel.Cast.Arcana"
end

self.caster:EmitSound(sound_cast)
self.caster:AddNewModifier(self.caster, self, "modifier_duel_buff", {duration = duration, target = target:entindex()})
target:AddNewModifier(self.caster, self, "modifier_duel_buff", {duration = duration, target = self.caster:entindex()})

local odds = self:GetCaster():FindAbilityByName("custom_legion_commander_overwhelming_odds")

if odds and odds:IsFullyCastable() and self:GetCaster():IsRealHero() then 
  odds:OnSpellStart(1)
  odds:UseResources(true, false, false, true)
end


end

function custom_legion_commander_duel:OnSpellStart(target)

self.target = self:GetCursorTarget()
if target ~= nil then 
  self.target = target
end

if self.target:TriggerSpellAbsorb(self) then return end

self:StartDuel(self.target)
end


function custom_legion_commander_duel:WinDuel(winner, loser)
if not IsServer() then return end

winner:RemoveModifierByName("modifier_duel_buff")
loser:RemoveModifierByName("modifier_duel_buff")


if loser:IsIllusion() then return end
if loser:IsTempestDouble() then return end

local mod = winner:FindModifierByName("modifier_duel_damage")

if not mod then 
  mod = winner:AddNewModifier(winner, self, "modifier_duel_damage", {})
end 

local damage = self:GetSpecialValueFor("reward_damage")

if loser:IsCreep() then 
  damage = self:GetSpecialValueFor("creeps_damage")
end

if winner:GetQuest() == "Legion.Quest_8" then 
  winner:UpdateQuest(damage)
end

mod:SetStackCount(math.min(self:GetSpecialValueFor("max_damage"), mod:GetStackCount() + damage)) 
  
local duel_victory_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_legion_commander/legion_commander_duel_victory.vpcf", PATTACH_OVERHEAD_FOLLOW, winner)
winner:EmitSound("Hero_LegionCommander.Duel.Victory")

local ability = winner:FindAbilityByName("custom_legion_commander_press_the_attack")
if winner == self:GetCaster() and ability and ability:GetLevel() > 0 then 
    ability:OnSpellStart()
end




end








modifier_duel_buff = class({})
function modifier_duel_buff:IsHidden() return false end
function modifier_duel_buff:IsPurgable() return false end
function modifier_duel_buff:IsDebuff() return true end
function modifier_duel_buff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_duel_buff:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_MIN_HEALTH,
  MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
  MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
  MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE,
  MODIFIER_EVENT_ON_ATTACK_LANDED,
  MODIFIER_EVENT_ON_DEATH,
  MODIFIER_EVENT_ON_TAKEDAMAGE
}
end


function modifier_duel_buff:OnDeath(params)
if not IsServer() then return end 
if self:GetParent() ~= self:GetCaster() then return end 
if not self.target or self.target:IsNull() then return end
if self.ended == true then return end


if self:GetParent() == params.unit then 
  self.ended = true
  self:GetAbility():WinDuel(self.target, self:GetParent())
elseif self.target == params.unit then 
  self.ended = true
  self:GetAbility():WinDuel(self:GetParent(), self.target)
end 

end 



function modifier_duel_buff:GetModifierLifestealRegenAmplify_Percentage() 
if self:GetParent() ~= self:GetCaster() then 
  return self.heal_reduce
end

end

function modifier_duel_buff:GetModifierHealAmplify_PercentageTarget()
if self:GetParent() ~= self:GetCaster() then 
  return self.heal_reduce
end

end

function modifier_duel_buff:GetModifierHPRegenAmplify_Percentage() 
if self:GetParent() ~= self:GetCaster() then 
  return self.heal_reduce
end

end

function modifier_duel_buff:GetEffectName()
if self:GetParent() ~= self:GetCaster() then return end
if not self:GetCaster():HasModifier("modifier_legion_duel_win") then return end
return "particles/beast_grave.vpcf"
end

function modifier_duel_buff:GetMinHealth()
if self:GetParent():HasModifier("modifier_death") then return end
if self:GetParent() ~= self:GetCaster() then return end
if not self:GetCaster():HasModifier("modifier_legion_duel_win") then return end

return 1
end



function modifier_duel_buff:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent() ~= self:GetCaster() then return end 
if self:GetParent() ~= params.attacker then return end
if params.target ~= self.target then return end 
if not self.target:IsRealHero() then return end 

self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_duel_custom_str", {})

end



function modifier_duel_buff:OnTakeDamage(params)
if not IsServer() then return end 
if self:GetParent() ~= self:GetCaster() then return end 
if not self.caster:HasModifier("modifier_legion_duel_damage") then return end 

if (params.attacker == self.caster and params.unit == self.target) or (params.unit == self.caster and params.attacker == self.target) then 
  self:SetStackCount(params.damage*self.after_damage + self:GetStackCount())
end

end 




function modifier_duel_buff:OnCreated(table)
self.caster = self:GetCaster()

self.heal_reduce = self.caster:GetTalentValue("modifier_legion_duel_speed", "heal_reduce")

self.ended = false
if not IsServer() then return end	

self.after_damage = self:GetCaster():GetTalentValue("modifier_legion_duel_damage", "damage")/100

self.RemoveForDuel = true
self.target = EntIndexToHScript(table.target)

if not self:GetParent():IsCreep() then 
  self:GetParent():SetForceAttackTarget(self.target)
  self:GetParent():MoveToTargetToAttack(self.target)
end

if self:GetCaster() == self:GetParent() then 
    self:GetCaster():EmitSound("Hero_LegionCommander.Duel")
    local particle_name = "particles/legion_duel_ring.vpcf"
    if self:GetCaster():HasModifier("modifier_legion_commander_arcana_custom") then
        particle_name = "particles/legion_custom_odds/legion_duel_ring_arcana.vpcf"
    end
    self.particle = ParticleManager:CreateParticle(particle_name, PATTACH_WORLDORIGIN, nil)
	
  local dir = (self:GetCaster():GetAbsOrigin() - self.target:GetAbsOrigin())

  local center_point = self.target:GetAbsOrigin() + dir:Normalized()*80


  ParticleManager:SetParticleControl(self.particle, 0, center_point)
  ParticleManager:SetParticleControl(self.particle, 7, center_point)
  self:AddParticle(self.particle, false, false, -1, true, false)

end

self.interval = 0.1


self:StartIntervalThink(0.1)
end






function modifier_duel_buff:OnIntervalThink()
if not IsServer() then return end	

if not self:GetParent():IsCreep() then 
  self:GetParent():SetForceAttackTarget(self.target)
  self:GetParent():MoveToTargetToAttack(self.target)
end

if (self:GetParent():GetAbsOrigin() - self.target:GetAbsOrigin()):Length2D() > self:GetAbility():GetSpecialValueFor("victory_range")
or not self.target:HasModifier(self:GetName()) then 
	self:Destroy()
end

end

function modifier_duel_buff:OnDestroy()
if not IsServer() then return end
self:GetCaster():StopSound("Hero_LegionCommander.Duel")


if self:GetCaster() == self:GetParent() and self:GetStackCount() > 0 and self.target:IsAlive() then 

  self.target:EmitSound("LC.Duel_damage")


  local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_omniknight/omniknight_hammer_of_purity_detonation.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self.target )
  ParticleManager:SetParticleControlEnt( particle, 0, self.target, PATTACH_POINT_FOLLOW, "attach_hitloc", self.target:GetAbsOrigin(), true )
  ParticleManager:SetParticleControlEnt( particle, 3, self.target, PATTACH_POINT_FOLLOW, "attach_hitloc", self.target:GetAbsOrigin(), true )
  ParticleManager:ReleaseParticleIndex( particle )

  local effect_target = ParticleManager:CreateParticle( "particles/lc_press_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.target )
  ParticleManager:SetParticleControl( effect_target, 1, Vector( 200, 100, 100 ) )
  ParticleManager:ReleaseParticleIndex( effect_target )


  local real_damage = ApplyDamage({victim = self.target, attacker = self:GetCaster(), damage = self:GetStackCount(), ability = self:GetAbility(), damage_type = DAMAGE_TYPE_PURE})
  
  self.target:SendNumber(6, real_damage)
  if not self.target:IsAlive() then 
    self.ended = true
    self:GetAbility():WinDuel(self:GetParent(), self.target)
  end 
end 


if self:GetParent() == self:GetCaster() and self:GetCaster():HasModifier("modifier_legion_duel_win") then
  local heal = self:GetParent():GetMaxHealth()*self.caster:GetTalentValue("modifier_legion_duel_win", "heal")/100

  self:GetParent():GenericHeal(heal, self:GetParent())

  local particle = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
  ParticleManager:ReleaseParticleIndex( particle )
  local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_oracle/oracle_false_promise_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
  ParticleManager:ReleaseParticleIndex( particle )
end

if self.target:IsAlive() and self:GetCaster():HasShard() then 
  if self:GetParent() == self:GetCaster() then 
    self.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_duel_win_duration", { duration = self:GetAbility():GetSpecialValueFor("shard_duration")})
  end
end

if not self:GetParent():IsCreep() then 
  self:GetParent():SetForceAttackTarget(nil)
end

end



function modifier_duel_buff:CheckState() 

return {
  [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
  [MODIFIER_STATE_TAUNTED] = true, 
  [MODIFIER_STATE_SILENCED] = true
}

end




modifier_duel_damage = class({})
function modifier_duel_damage:IsHidden() return false end
function modifier_duel_damage:IsPurgable() return false end
function modifier_duel_damage:RemoveOnDeath() return false end
function modifier_duel_damage:GetTexture() return "legion_commander_duel" end
function modifier_duel_damage:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
}
end

function modifier_duel_damage:GetModifierPreAttack_BonusDamage() 
local bonus = 1 

if self:GetParent():HasModifier("modifier_duel_custom_scepter_unit") and self:GetParent():FindAbilityByName("custom_legion_commander_duel_scepter") then 

  bonus = bonus + self:GetParent():FindAbilityByName("custom_legion_commander_duel_scepter"):GetSpecialValueFor("damage")/100
end 

return self:GetStackCount() * bonus
end










modifier_duel_win_duration = class({})
function modifier_duel_win_duration:IsHidden() return false end
function modifier_duel_win_duration:IsPurgable() return false end
function modifier_duel_win_duration:GetEffectName() return "particles/lc_odd_charge_mark.vpcf" end
function modifier_duel_win_duration:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
function modifier_duel_win_duration:DeclareFunctions()
return
{
  MODIFIER_EVENT_ON_DEATH,
  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}

end


function modifier_duel_win_duration:OnCreated(table)
if not IsServer() then return end


end

function modifier_duel_win_duration:OnDeath(params)
if not IsServer() then return end
if params.unit ~= self:GetParent() then return end
if not self:GetCaster():IsAlive() then return end  

self:GetAbility():WinDuel(self:GetCaster(), self:GetCaster(), self:GetParent())
self:Destroy()
end

function modifier_duel_win_duration:GetModifierMoveSpeedBonus_Percentage()
return self:GetAbility():GetSpecialValueFor("shard_slow")
end





custom_legion_commander_duel_double = class({})


function custom_legion_commander_duel_double:GetCooldown()
return self:GetCaster():GetTalentValue("modifier_legion_duel_legendary", "cd")
end 


function custom_legion_commander_duel_double:OnAbilityPhaseStart()

if self:GetCaster():HasModifier("modifier_duel_double_effect") then 
  return false
end 

return true
end


function custom_legion_commander_duel_double:OnSpellStart()
if not IsServer() then return end

local target = nil
local possible_heroes = {}

local total_count = 0 
for _,hero in pairs(players) do 
  total_count = total_count + 1
end 


for _,hero in pairs(players) do

  if hero ~= self:GetCaster() and (self.last_target ~= hero or total_count < 4) then 
    table.insert(possible_heroes, hero)
  end 
end 

if #possible_heroes == 0 then return end

self:SetActivated(false)
self:EndCooldown()

if #possible_heroes == 1 then 
  self:SetTarget(possible_heroes[1])
else 
    local random_1 = RandomInt(1, #possible_heroes)
    local random_2 = random_1

    repeat random_2 = RandomInt(1, #possible_heroes)
    until random_2 ~= random_1
   
    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_duel_double_choosing", {hero_1 = possible_heroes[random_1]:entindex(), hero_2 = possible_heroes[random_2]:entindex()})

end 

end


function custom_legion_commander_duel_double:SetTarget(target)
if not IsServer() then return end

if not players[target:GetTeamNumber()] then 
  self:SetActivated(true)
  return 
end 

self.last_target = target
self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_duel_double_effect", {target = target:entindex()})

end 



modifier_duel_double_choosing = class({})
function modifier_duel_double_choosing:IsHidden() return true end
function modifier_duel_double_choosing:IsPurgable() return false end
function modifier_duel_double_choosing:RemoveOnDeath() return false end
function modifier_duel_double_choosing:OnCreated(table)
if not IsServer() then return end 

self.caster = self:GetParent()

self.heroes = {}
self.heroes[1] = EntIndexToHScript(table.hero_1)
self.heroes[2] = EntIndexToHScript(table.hero_2)


self:OnIntervalThink()
self:StartIntervalThink(0.5)
end 

function modifier_duel_double_choosing:OnIntervalThink()
if not IsServer() then return end


CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self.caster:GetPlayerOwnerID()), 'legion_duel_init',  {hero_1 = self.heroes[1]:GetUnitName(), hero_2 = self.heroes[2]:GetUnitName()})

end 


function modifier_duel_double_choosing:EndPick(pick)
if not IsServer() then return end


--CustomGameEventManager:Send_ServerToAllClients('generic_sound',  {sound = "Lc.Duel_target_end"})
self:GetAbility():SetTarget(self.heroes[pick])

self:Destroy()
end 


function modifier_duel_double_choosing:OnDestroy()
if not IsServer() then return end


EmitAnnouncerSoundForPlayer("Lc.Duel_target_end", self:GetParent():GetPlayerOwnerID())
CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), 'legion_duel_end',  {})
end 





modifier_duel_double_effect = class({})
function modifier_duel_double_effect:IsHidden() return false end
function modifier_duel_double_effect:GetTexture() return "buffs/duel_mini" end

function modifier_duel_double_effect:IsPurgable() return false end
function modifier_duel_double_effect:RemoveOnDeath() return false end
function modifier_duel_double_effect:OnCreated(table)
if not IsServer() then return end

self.caster = self:GetParent()
self.target = EntIndexToHScript(table.target)

CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self.caster:GetPlayerOwnerID()), 'generic_sound',  {sound = "Lc.Duel_target_effect_sound"})
CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self.caster:GetPlayerOwnerID()), 'generic_sound', {sound = "Lc.Duel_target_effect_voice"})

CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self.target:GetPlayerOwnerID()), 'generic_sound',  {sound = "Lc.Duel_target_effect_sound"})
CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self.target:GetPlayerOwnerID()), 'generic_sound', {sound = "Lc.Duel_target_effect_voice"})


CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self.target:GetPlayerOwnerID()), 'legion_duel_alert',  {})


self:SetStackCount(self:GetCaster():GetTalentValue("modifier_legion_duel_legendary", "timer"))
self.interval = 0.2
self.count = -self.interval


self:OnIntervalThink()
self:StartIntervalThink(0.2)
end 



function modifier_duel_double_effect:OnIntervalThink()
if not IsServer() then return end 

if not self.target or not players[self.target:GetTeamNumber()] or not players[self:GetParent():GetTeamNumber()] then 
  self:Destroy()
  return
end 


CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self.caster:GetPlayerOwnerID()), 'legion_duel_status',  {hero_1 = self.caster:GetUnitName(), hero_2 = self.target:GetUnitName()})
CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self.target:GetPlayerOwnerID()), 'legion_duel_status',  {hero_1 = self.caster:GetUnitName(), hero_2 = self.target:GetUnitName()})

if self:GetStackCount() > 0 then 

  self.count = self.count + self.interval
  if self.count >= 1 then 
    self.count = 0
    self:DecrementStackCount()
  end 

end

AddFOWViewer(self.caster:GetTeamNumber(), self.target:GetAbsOrigin(), 10, self.interval, false)
--AddFOWViewer(self.target:GetTeamNumber(), self.caster:GetAbsOrigin(), 10, self.interval, false)

self.target:AddNewModifier(self.target, self:GetAbility(), "modifier_duel_double_effect_target", {})

end 


function modifier_duel_double_effect:DeclareFunctions()
return
{
  MODIFIER_EVENT_ON_DEATH
}

end 

function modifier_duel_double_effect:OnDestroy()
if not IsServer() then return end 

CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self.caster:GetPlayerOwnerID()), 'legion_duel_status_end',  {})
CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self.target:GetPlayerOwnerID()), 'legion_duel_status_end',  {})

if self.target and not self.target:IsNull() then 
  self.target:RemoveModifierByName("modifier_duel_double_effect_target")
end 

self:GetAbility():SetActivated(true)
self:GetAbility():UseResources(true, false, false, true)
end 

function modifier_duel_double_effect:OnDeath(params)
if not IsServer() then return end 
if params.unit:IsReincarnating() then return end
if self:GetStackCount() > 0 then return end


if self.caster == params.unit then 
  self:SetWinner(self.target)
  self:Destroy()
  return
end 

if self.target == params.unit then
  self:SetWinner(self.caster) 
  self:Destroy()
  return
end 

end 


function modifier_duel_double_effect:SetWinner(target)
if not IsServer() then return end 

local winner = target

Timers:CreateTimer(1, function()
  if winner and not winner:IsNull() then 
    local duel_victory_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_legion_commander/legion_commander_duel_victory.vpcf", PATTACH_OVERHEAD_FOLLOW, winner)
    winner:EmitSound("Hero_LegionCommander.Duel.Victory")
    winner:EmitSound("Lc.Duel_double")
  end 
end)

local damage = self:GetCaster():GetTalentValue("modifier_legion_duel_legendary", "damage")
local amp = self:GetCaster():GetTalentValue("modifier_legion_duel_legendary", "amp")


target:AddNewModifier(target, self:GetAbility(), "modifier_duel_double_win", {damage = damage, amp = amp})

end 


modifier_duel_double_win = class({})

function modifier_duel_double_win:IsHidden() return false end
function modifier_duel_double_win:IsPurgable() return false end
function modifier_duel_double_win:RemoveOnDeath() return false end
function modifier_duel_double_win:OnCreated(table)
if not IsServer() then return end

self.damage = table.damage
self.amp = table.amp
self:SetStackCount(1)


self:SetHasCustomTransmitterData(true)
end 

function modifier_duel_double_win:AddCustomTransmitterData() return 
{
  amp = self.amp ,
  damage = self.damage
} 
end

function modifier_duel_double_win:HandleCustomTransmitterData(data)
self.amp  = data.amp
self.damage = data.damage
end



function modifier_duel_double_win:OnRefresh()
if not IsServer() then return end 

self:IncrementStackCount()
end 


function modifier_duel_double_win:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
  MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
}

end


function modifier_duel_double_win:GetModifierPreAttack_BonusDamage()
return self.damage*self:GetStackCount()
end


function modifier_duel_double_win:GetModifierSpellAmplify_Percentage()
return self.amp*self:GetStackCount()
end



modifier_duel_double_effect_target = class({})
function modifier_duel_double_effect_target:IsHidden() return false end
function modifier_duel_double_effect_target:IsPurgable() return false end
function modifier_duel_double_effect_target:IsDebuff() return true end
function modifier_duel_double_effect_target:RemoveOnDeath() return false end
function modifier_duel_double_effect_target:GetTexture() return "buffs/duel_mini" end





modifier_duel_double_tracker = class({})
function modifier_duel_double_tracker:IsHidden() return true end
function modifier_duel_double_tracker:IsPurgable() return false end
function modifier_duel_double_tracker:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK,
  MODIFIER_EVENT_ON_TAKEDAMAGE
}
end


function modifier_duel_double_tracker:OnCreated()

self.legendary_damage_cd = self:GetParent():GetTalentValue("modifier_legion_duel_legendary", "damage_cd", true)
end 

function modifier_duel_double_tracker:GetModifierTotal_ConstantBlock(params)
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_legion_duel_return") then return end


if params.damage_type == DAMAGE_TYPE_MAGICAL then 
  local mod = self:GetParent():FindModifierByName("modifier_magic_shield")
  if mod and mod:GetStackCount() > 0 then 
    return
  end
end

if params.damage_type == DAMAGE_TYPE_PHYSICAL then 
  local mod = self:GetParent():FindModifierByName("modifier_attack_shield")
  if mod and mod:GetStackCount() > 0 then 
    return
  end
end


local vector = (self:GetCaster():GetAbsOrigin()-params.attacker:GetAbsOrigin()):Normalized()

local center_angle = VectorToAngles( vector ).y
local facing_angle = VectorToAngles(self:GetParent():GetForwardVector() ).y


local facing = ( math.abs( AngleDiff(center_angle,facing_angle) ) > 85 )

if facing then 
  return params.damage*self:GetCaster():GetTalentValue("modifier_legion_duel_return", "damage_reduce")/100
end 

end

function modifier_duel_double_tracker:OnTakeDamage(params)
if not IsServer() then return end
if not params.attacker then return end
if self:GetParent() ~= params.unit then return end
if self:GetParent() == params.attacker then return end


if not self:GetParent():HasModifier("modifier_legion_duel_return") then return end

local vector = (self:GetCaster():GetAbsOrigin()-params.attacker:GetAbsOrigin()):Normalized()

local center_angle = VectorToAngles( vector ).y
local facing_angle = VectorToAngles(self:GetParent():GetForwardVector() ).y


local facing = ( math.abs( AngleDiff(center_angle,facing_angle) ) > 85 )

if facing and RandomInt(1, 3) == 3 then 
  self:GetParent():EmitSound("Juggernaut.Parry")
  local particle = ParticleManager:CreateParticle( "particles/jugg_parry.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
  ParticleManager:SetParticleControlEnt( particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetParent():GetAbsOrigin(), true )
  ParticleManager:SetParticleControl( particle, 1, self:GetParent():GetAbsOrigin() )
end 

end


modifier_duel_target_damage = class({})
function modifier_duel_target_damage:IsHidden() return true end 
function modifier_duel_target_damage:IsPurgable() return false end
function modifier_duel_target_damage:OnCreated()
if not IsServer() then return end

self.caster = self:GetCaster()
self.parent = self:GetParent()

self.interval = 0.25

self.damage = self.caster:GetTalentValue("modifier_legion_duel_speed", "damage")*self.interval

self:OnIntervalThink()
self:StartIntervalThink(self.interval)
end 

function modifier_duel_target_damage:OnIntervalThink()
if not IsServer() then return end

local real_damage = ApplyDamage({victim = self.parent, attacker = self.caster, damage = self.damage, ability = self:GetAbility(), damage_type = DAMAGE_TYPE_PURE})

--self.caster:GenericHeal(real_damage*self.damage_heal, self:GetAbility(), true, "")
end




custom_legion_commander_duel_scepter = class({})




function custom_legion_commander_duel_scepter:OnSpellStart()

local target = self:GetCursorTarget()
local dir = target:GetAbsOrigin() - self:GetCaster():GetAbsOrigin()

local point = self:GetCaster():GetAbsOrigin() + dir:Normalized()*(dir:Length2D()/2)

CreateModifierThinker( self:GetCaster(), self, "modifier_duel_custom_scepter", {duration = self:GetSpecialValueFor("duration"), target = target:entindex()}, point, self:GetCaster():GetTeamNumber(), false )


end 

modifier_duel_custom_scepter = class({})
function modifier_duel_custom_scepter:IsHidden() return true end
function modifier_duel_custom_scepter:IsPurgable() return false end
function modifier_duel_custom_scepter:OnCreated(table)
if not IsServer() then return end

self.target = EntIndexToHScript(table.target)
self.caster = self:GetCaster()
self.thinker = self:GetParent()

self:GetParent():EmitSound("Lc.Duel_scepter_duel")
self:GetParent():EmitSound("Lc.Duel_scepter_cast")
local center_point = self:GetParent():GetAbsOrigin()
self.radius = self:GetAbility():GetSpecialValueFor("radius")

GridNav:DestroyTreesAroundPoint(self.thinker:GetAbsOrigin(), self.radius + 200, true)

self.particle = ParticleManager:CreateParticle("particles/legion_commander/scepter_duel.vpcf", PATTACH_WORLDORIGIN, nil)

ParticleManager:SetParticleControl(self.particle, 0, center_point)
ParticleManager:SetParticleControl(self.particle, 2, Vector(self.radius, 0, 0))
ParticleManager:SetParticleControl(self.particle, 7, center_point)
self:AddParticle(self.particle, false, false, -1, true, false)

self.caster:AddNewModifier(self.caster, self:GetAbility(), "modifier_duel_custom_scepter_unit", {duration = self:GetRemainingTime() + 0.1, target = self.target:entindex()})

if self.target then 
  self.target:AddNewModifier(self.caster, self:GetAbility(), "modifier_duel_custom_scepter_unit", {duration = self:GetRemainingTime() + 0.1,target = self.caster:entindex()})
end 

self:OnIntervalThink()
self:StartIntervalThink(0.05)
end 

function modifier_duel_custom_scepter:OnDestroy()
if not IsServer() then return end
self:GetParent():StopSound("Lc.Duel_scepter_duel")
self:GetParent():StopSound("Lc.Duel_scepter_cast")

if self.caster then 
  self.caster:RemoveModifierByName("modifier_duel_custom_scepter_unit")
end

if self.target then 
  self.target:RemoveModifierByName("modifier_duel_custom_scepter_unit")
end 

end 


function modifier_duel_custom_scepter:OnIntervalThink()
if not IsServer() then return end



self:CheckPos(self.target)
self:CheckPos(self.caster)

local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(),self.thinker:GetAbsOrigin(),nil,self.radius,DOTA_UNIT_TARGET_TEAM_ENEMY,DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,FIND_ANY_ORDER,false)

for _,target in pairs(enemies) do 
  if self.target ~= target and not target:HasModifier("modifier_duel_custom_scepter_knock_cd") and target:GetUnitName() ~= "npc_teleport" then 

    local dir = target:GetAbsOrigin() - self.thinker:GetAbsOrigin() 
    local point = self.thinker:GetAbsOrigin() + dir:Normalized()*self.radius*1.2

    target:InterruptMotionControllers(false)
    self:ChangePos(target, point)
    target:AddNewModifier(target, nil, "modifier_duel_custom_scepter_knock_cd", {duration = 0.2})
  end
end

end 


function modifier_duel_custom_scepter:CheckPos(target)
if not IsServer() then return end

if not target or target:IsNull() or not target:IsAlive() or not target:HasModifier("modifier_duel_custom_scepter_unit") then 
  self:Destroy()
  return
end 

local radius = self.radius*0.9

if target and not target:IsNull() and target:IsAlive() and not target:IsInvulnerable() then 
  local dir = (target:GetAbsOrigin() - self.thinker:GetAbsOrigin())

  if dir:Length2D() > radius then 

    target:InterruptMotionControllers(false)
    local point = self.thinker:GetAbsOrigin() + dir:Normalized()*(radius*0.8)

    if dir:Length2D() > radius*1.4 then 
      FindClearSpaceForUnit(target, point, true)
    else 
      self:ChangePos(target, point)
    end
  end 
end 

end


function modifier_duel_custom_scepter:ChangePos(target, point)
if not IsServer() then return end

local duration = 0.2
local distance = (target:GetAbsOrigin() - point):Length2D()
local knockbackProperties =
{
  target_x = point.x,
  target_y = point.y,
  distance = distance,
  speed = distance/duration,
  height = 0,
  fix_end = true,
  isStun = true,
  activity = ACT_DOTA_FLAIL,
}
target:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_generic_arc", knockbackProperties )


end 









modifier_duel_custom_scepter_unit = class({})
function modifier_duel_custom_scepter_unit:IsHidden() return true end
function modifier_duel_custom_scepter_unit:IsPurgable() return false end
function modifier_duel_custom_scepter_unit:RemoveOnDeath() return false end
function modifier_duel_custom_scepter_unit:OnCreated(table)
self.speed = self:GetAbility():GetSpecialValueFor("speed")
if not IsServer() then return end 
self.RemoveForDuel = true

self.target = EntIndexToHScript(table.target)
self.parent = self:GetParent()

end

function modifier_duel_custom_scepter_unit:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
  MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
  MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
  MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
  MODIFIER_PROPERTY_ABSORB_SPELL,

}
end


function modifier_duel_custom_scepter_unit:GetModifierAttackSpeedBonus_Constant()
return self.speed
end

function modifier_duel_custom_scepter_unit:GetAbsoluteNoDamagePhysical(params)
if not IsServer() then return end
if params.attacker ~= self.target then return 1 end

return 0
end 

function modifier_duel_custom_scepter_unit:GetAbsoluteNoDamageMagical(params)
if not IsServer() then return end
if params.attacker ~= self.target then return 1 end

return 0
end 

function modifier_duel_custom_scepter_unit:GetAbsoluteNoDamagePure(params)
if not IsServer() then return end
if params.attacker ~= self.target then return 1 end

return 0
end 



function modifier_duel_custom_scepter_unit:GetAbsorbSpell( params )
if not IsServer() then return end
if not params.ability then return end 
if params.ability:GetCaster() == self.parent then return 0 end
if params.ability:GetCaster() ~= self.target then return 1 end

return 0
end

modifier_duel_custom_scepter_knock_cd = class({})
function modifier_duel_custom_scepter_knock_cd:IsHidden() return true end
function modifier_duel_custom_scepter_knock_cd:IsPurgable() return false end





modifier_duel_custom_str = class({})
function modifier_duel_custom_str:IsHidden() return not self:GetCaster():HasModifier("modifier_legion_duel_blood") end
function modifier_duel_custom_str:IsPurgable() return false end
function modifier_duel_custom_str:RemoveOnDeath() return false end
function modifier_duel_custom_str:GetTexture() return "buffs/duel_win" end
function modifier_duel_custom_str:OnCreated()

self.max = self:GetCaster():GetTalentValue("modifier_legion_duel_blood", "max", true)
self.cdr = self:GetCaster():GetTalentValue("modifier_legion_duel_blood", "cdr", true)
self.str = self:GetCaster():GetTalentValue("modifier_legion_duel_blood", "str", true)

if not IsServer() then return end 
self:SetStackCount(1)
self:GetParent():CalculateStatBonus(true)
self:StartIntervalThink(0.5)
end


function modifier_duel_custom_str:OnIntervalThink()
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_legion_duel_blood") then return end 

if self:GetStackCount() >= self.max then 


  self:GetParent():EmitSound("BS.Thirst_legendary_active")
  local particle_peffect = ParticleManager:CreateParticle("particles/lc_odd_proc_.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
  ParticleManager:SetParticleControl(particle_peffect, 0, self:GetParent():GetAbsOrigin())
  ParticleManager:SetParticleControl(particle_peffect, 2, self:GetParent():GetAbsOrigin())
  ParticleManager:ReleaseParticleIndex(particle_peffect)
  
  self:StartIntervalThink(-1)
end

end 

function modifier_duel_custom_str:OnRefresh()
if not IsServer() then return end 
if self:GetStackCount() >= self.max then return end 

self:IncrementStackCount()
self:GetParent():CalculateStatBonus(true)

end 


function modifier_duel_custom_str:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
  MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE
}

end 


function modifier_duel_custom_str:GetModifierPercentageCooldown()
if not self:GetParent():HasModifier("modifier_legion_duel_blood") then return end 
if self:GetStackCount() < self.max then return end 

return self.cdr
end 


function modifier_duel_custom_str:GetModifierBonusStats_Strength()
if not self:GetParent():HasModifier("modifier_legion_duel_blood") then return end 
return self.str*self:GetStackCount()
end 