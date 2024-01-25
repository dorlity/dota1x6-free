LinkLuaModifier( "modifier_phantom_assassin_phantom_coup_de_grace", "abilities/phantom_assassin/custom_phantom_assassin_coup_de_grace", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_phantom_assassin_phantom_coup_de_grace_legendary", "abilities/phantom_assassin/custom_phantom_assassin_coup_de_grace", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_phantom_assassin_phantom_coup_de_grace_legendaryself", "abilities/phantom_assassin/custom_phantom_assassin_coup_de_grace", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_phantom_assassin_phantom_coup_de_grace_armor", "abilities/phantom_assassin/custom_phantom_assassin_coup_de_grace", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_phantom_assassin_phantom_coup_de_grace_blood", "abilities/phantom_assassin/custom_phantom_assassin_coup_de_grace", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_phantom_assassin_phantom_coup_de_grace_cd", "abilities/phantom_assassin/custom_phantom_assassin_coup_de_grace", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_phantom_assassin_phantom_coup_de_grace_silence", "abilities/phantom_assassin/custom_phantom_assassin_coup_de_grace", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_phantom_assassin_phantom_coup_de_grace_damage", "abilities/phantom_assassin/custom_phantom_assassin_coup_de_grace", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_phantom_assassin_phantom_coup_de_grace_kill", "abilities/phantom_assassin/custom_phantom_assassin_coup_de_grace", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_phantom_assassin_phantom_coup_de_grace_slow", "abilities/phantom_assassin/custom_phantom_assassin_coup_de_grace", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_phantom_assassin_phantom_coup_de_grace_quest", "abilities/phantom_assassin/custom_phantom_assassin_coup_de_grace", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_phantom_assassin_phantom_coup_de_grace_focus", "abilities/phantom_assassin/custom_phantom_assassin_coup_de_grace", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_phantom_assassin_phantom_coup_de_grace_silence_cd", "abilities/phantom_assassin/custom_phantom_assassin_coup_de_grace", LUA_MODIFIER_MOTION_NONE )




    
custom_phantom_assassin_coup_de_grace = class({})

custom_phantom_assassin_coup_de_grace.legendary_gold_max = 250
custom_phantom_assassin_coup_de_grace.legendary_gold_avg = 350
custom_phantom_assassin_coup_de_grace.legendary_gold_k = 0.4
custom_phantom_assassin_coup_de_grace.legendary_gold_init = 100
custom_phantom_assassin_coup_de_grace.legendary_gold_net = 0.04
custom_phantom_assassin_coup_de_grace.legendary_cd = 60
custom_phantom_assassin_coup_de_grace.legendary_duration = 90
custom_phantom_assassin_coup_de_grace.legendary_chance = 10

custom_phantom_assassin_coup_de_grace.armor_reduction = {-4, -6, -8}
custom_phantom_assassin_coup_de_grace.armor_duration = 3

custom_phantom_assassin_coup_de_grace.damage_stack = {10, 20}
custom_phantom_assassin_coup_de_grace.damage_stack_max = 8



custom_phantom_assassin_coup_de_grace.kill_damage = 10
custom_phantom_assassin_coup_de_grace.kill_max = 8
custom_phantom_assassin_coup_de_grace.kill_chance = 5
custom_phantom_assassin_coup_de_grace.kill_radius = 700


custom_phantom_assassin_coup_de_grace.blood_damage = {0.15, 0.25}
custom_phantom_assassin_coup_de_grace.blood_duration = 5
custom_phantom_assassin_coup_de_grace.blood_heal = 1

custom_phantom_assassin_coup_de_grace.cleave_damage = {0.2, 0.3 ,0.4}
custom_phantom_assassin_coup_de_grace.cleave_slow = {-20, -30, -40}
custom_phantom_assassin_coup_de_grace.cleave_slow_duration = 2


function custom_phantom_assassin_coup_de_grace:GetAbilityTextureName()
if self:GetCaster():HasModifier("modifier_phantom_assassin_persona_custom") then
  return "phantom_assassin/persona/phantom_assassin_coup_de_grace_persona2"
end

if self:GetCaster():HasModifier("modifier_pa_arcana_custom") then
    return "phantom_assassin_arcana_coup_de_grace"
end
return "phantom_assassin_coup_de_grace"
end

function custom_phantom_assassin_coup_de_grace:Precache(context)

PrecacheResource( "particle", "particles/pa_cry.vpcf", context )
PrecacheResource( "particle", "particles/pa_vendetta.vpcf", context )
PrecacheResource( "particle", "particles/pa_arc.vpcf", context )
PrecacheResource( "particle", "particles/huskar_leap_heal.vpcf", context )
PrecacheResource( "particle", "particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave_gods_strength.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf", context )
PrecacheResource( "particle", "particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/phantom_assassin_crit_arcana_swoop.vpcf", context )
PrecacheResource( "particle", "particles/axe_culling_stack.vpcf", context )
PrecacheResource( "particle", "particles/brist_lowhp_.vpcf", context )

PrecacheResource( "particle", "particles/units/heroes/hero_phantom_assassin_persona/pa_persona_attack_blur_crit.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_phantom_assassin_persona/pa_persona_phantom_blur_attack_twirl_fx.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_phantom_assassin_persona/pa_persona_attack_blur_crit_spin_fx.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_phantom_assassin_persona/pa_persona_phantom_blur_attack_backhand_fx.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_phantom_assassin_persona/pa_persona_attack_blur_crit_swing_fx.vpcf", context )

PrecacheResource( "particle", "particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/phantom_assassin_arcana_attack_blur_b.vpcf", context )
PrecacheResource( "particle", "particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/pa_arcana_event_glitch.vpcf", context )
PrecacheResource( "particle", "particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/phantom_assassin_arcana_attack_blur_c.vpcf", context )
PrecacheResource( "particle", "particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/phantom_assassin_arcana_attack_blur.vpcf", context )
PrecacheResource( "particle", "particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/pa_arcana_attack_crit.vpcf", context )
end






function custom_phantom_assassin_coup_de_grace:GetCooldown()

return self:GetSpecialValueFor("crit_cd")
end


function custom_phantom_assassin_coup_de_grace:GetIntrinsicModifierName()
if not self:GetCaster():IsRealHero() then return end
  return "modifier_phantom_assassin_phantom_coup_de_grace"
end

function custom_phantom_assassin_coup_de_grace:GetBehavior()
  if self:GetCaster():HasModifier("modifier_phantom_assassin_crit_legendary") then
    return DOTA_ABILITY_BEHAVIOR_NO_TARGET end
 return DOTA_ABILITY_BEHAVIOR_PASSIVE 
end


function custom_phantom_assassin_coup_de_grace:OnSpellStart()
if not IsServer() then return end


local p = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), Vector(0,0,0), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, 0, false)

if #p < 1 then 
  CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetCaster():GetPlayerOwnerID()), "CreateIngameErrorMessage", {message = "#vendetta_notargets"})
  return 
end

local heroes = {}

for _,player in pairs(p) do 
  if not player:IsTempestDouble() then 
    heroes[#heroes + 1] = player
  end 
end 

if #heroes == 0 then return end

self:GetCaster():EmitSound("Phantom_Assassin.SuperCrit")


local particle = ParticleManager:CreateParticle( "particles/pa_cry.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() ) 
   
ParticleManager:ReleaseParticleIndex( particle )


self.target = heroes[RandomInt(1, #heroes)]


if #heroes > 1 and self:GetCaster().last_target then 
	repeat self.target = heroes[RandomInt(1, #heroes)]
	until self:GetCaster().last_target ~= self.target
end

self:GetCaster().last_target = self.target


self:SetActivated(false)
local mod = self.target:AddNewModifier(self:GetCaster(), self, "modifier_phantom_assassin_phantom_coup_de_grace_legendary", {duration = self.legendary_duration})
mod.pa_mod = self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_phantom_assassin_phantom_coup_de_grace_legendaryself", {duration = self.legendary_duration})


end


modifier_phantom_assassin_phantom_coup_de_grace_legendary = class({})

function modifier_phantom_assassin_phantom_coup_de_grace_legendary:IsPurgable() return false end
function modifier_phantom_assassin_phantom_coup_de_grace_legendary:IsHidden() return true end
function modifier_phantom_assassin_phantom_coup_de_grace_legendary:GetTexture() return "buffs/odds_fow" end
function modifier_phantom_assassin_phantom_coup_de_grace_legendary:RemoveOnDeath() return false end
function modifier_phantom_assassin_phantom_coup_de_grace_legendary:OnCreated(table) 
if not IsServer() then  return end
self.parent = self:GetParent()
self.caster = self:GetCaster()
--self.RemoveForDuel = true

self.duration = 0

self.gold = 0
local k = 1
local diff = 1

local net_target = PlayerResource:GetNetWorth(self:GetParent():GetPlayerOwnerID())
local net_killer = PlayerResource:GetNetWorth(self:GetCaster():GetPlayerOwnerID())

if net_target < net_killer then 
	k = -1
	diff = 1 - net_target / net_killer
else 
	diff = 1 - net_killer / net_target
end


--self.gold = math.floor(math.min((diff / self:GetAbility().legendary_gold_k), 1) * self:GetAbility().legendary_gold_max * k + self:GetAbility().legendary_gold_avg)
self.gold = self:GetAbility().legendary_gold_init + math.floor(PlayerResource:GetNetWorth(self:GetParent():GetPlayerOwnerID())*self:GetAbility().legendary_gold_net)


self.particle_trail = ParticleManager:CreateParticleForTeam("particles/lc_odd_charge_mark.vpcf", PATTACH_OVERHEAD_FOLLOW, self.parent, self.caster:GetTeamNumber())
self:AddParticle(self.particle_trail, false, false, -1, false, false)

self.particle_trail_fx = ParticleManager:CreateParticleForTeam("particles/pa_vendetta.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent, self.caster:GetTeamNumber())
self:AddParticle(self.particle_trail_fx, false, false, -1, false, false)

self.kill_done = false
self:StartIntervalThink(FrameTime())
end


function modifier_phantom_assassin_phantom_coup_de_grace_legendary:OnIntervalThink()
if not IsServer() then return end
if not self:GetParent():IsAlive() then return end

AddFOWViewer(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), 10, FrameTime(), true)

CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetCaster():GetPlayerOwnerID()), 'pa_hunt_think',  {hero = self:GetParent():GetUnitName(), timer = math.floor(self:GetRemainingTime()), gold = self.gold})

end


function modifier_phantom_assassin_phantom_coup_de_grace_legendary:DeclareFunctions()
return
{
  MODIFIER_EVENT_ON_DEATH,
}

end

function modifier_phantom_assassin_phantom_coup_de_grace_legendary:OnDeath(params)
if not IsServer() then return end

if params.unit == self:GetCaster() and not self:GetCaster():IsReincarnating() then 
  self:Destroy()
end

if params.unit == self:GetParent() and (self:GetCaster() == params.attacker or
    (params.attacker.owner and params.attacker.owner == self:GetCaster())) then  

    self.kill_done = true 
    self:Destroy()

end




end




function modifier_phantom_assassin_phantom_coup_de_grace_legendary:OnDestroy()
if not IsServer() then return end

CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetCaster():GetPlayerOwnerID()), 'pa_hunt_end',  {})

self:GetAbility():SetActivated(true)

local mod = self:GetCaster():FindModifierByName("modifier_phantom_assassin_phantom_coup_de_grace_legendaryself")
if mod then 
  mod:Destroy()
end


self:GetAbility():StartCooldown(self:GetAbility().legendary_cd)

if self:GetParent():IsRealHero() and self.kill_done then 

  self.particle = ParticleManager:CreateParticle( "particles/pa_arc.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() ) 
     
  self:GetCaster():EmitSound("Phantom_Assassin.SuperCrit")

  Timers:CreateTimer(1,function()
   ParticleManager:DestroyParticle( self.particle , false)
   ParticleManager:ReleaseParticleIndex( self.particle )
  end)


   local more_gold = self.gold

   self:GetCaster():ModifyGold(more_gold, true, DOTA_ModifyGold_HeroKill)
   SendOverheadEventMessage(self:GetCaster(), 0, self:GetCaster(), more_gold, nil)

end





end





modifier_phantom_assassin_phantom_coup_de_grace = class({})

function modifier_phantom_assassin_phantom_coup_de_grace:IsHidden()
  return true
end

function modifier_phantom_assassin_phantom_coup_de_grace:IsPurgable()
  return false
end

function modifier_phantom_assassin_phantom_coup_de_grace:DeclareFunctions()
return  {
  MODIFIER_EVENT_ON_ATTACK_LANDED,
  MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
  MODIFIER_EVENT_ON_DEATH
}

end



function modifier_phantom_assassin_phantom_coup_de_grace:GetModifierAttackRangeBonus()
if not self:GetParent():HasModifier("modifier_phantom_assassin_crit_speed") then return end 

return self:GetCaster():GetTalentValue("modifier_phantom_assassin_crit_speed", "range")
end 


function modifier_phantom_assassin_phantom_coup_de_grace:OnDeath(params)
if not IsServer() then return end

local attacker = params.attacker
if not attacker then return end
if attacker:IsIllusion() and attacker.owner then 
  attacker = attacker.owner
end 


if self:GetParent() ~= attacker then return end
if not params.unit:IsValidKill(self:GetParent()) then return end


self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_phantom_assassin_phantom_coup_de_grace_kill", {})
end


function modifier_phantom_assassin_phantom_coup_de_grace:OnAttackLanded(params)
if not IsServer() then return end

local attacker = params.attacker

if attacker:IsIllusion() and attacker.owner then 
  attacker = attacker.owner
end 

if attacker ~= self:GetCaster() then return end 
if attacker:PassivesDisabled() then return end
if not params.target:IsHero() and not params.target:IsCreep() then return end 
   
if params.attacker:HasModifier("modifier_phantom_assassin_crit_stack") then 
  params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_phantom_assassin_phantom_coup_de_grace_armor", {duration = self:GetCaster():GetTalentValue("modifier_phantom_assassin_crit_stack", "duration")})
end 

local ability = params.attacker:FindAbilityByName(self:GetAbility():GetName())

if not ability then return end

if attacker:HasModifier("modifier_phantom_assassin_phantom_coup_de_grace_cd") and attacker:HasModifier("modifier_phantom_assassin_crit_legendary") then return end
if not attacker:HasModifier("modifier_phantom_assassin_crit_legendary") and not ability:IsFullyCastable() then return end


self.chance = self:GetAbility():GetSpecialValueFor( "crit_chance" )

local dagger = self:GetParent():FindModifierByName("modifier_custom_phantom_assassin_stifling_dagger_attack")

if dagger and dagger.main then 
  if dagger.main == 0 then 
    return
  end  
  self.chance = self:GetAbility():GetSpecialValueFor("dagger_crit_chance")
end 


if params.target:HasModifier("modifier_phantom_assassin_phantom_coup_de_grace_legendary") then 
    self.chance = self.chance + self:GetAbility().legendary_chance
end

local mod = self:GetParent():FindModifierByName("modifier_phantom_assassin_phantom_coup_de_grace_kill")

if mod and mod:GetStackCount() >= self:GetAbility().kill_max and self:GetParent():HasModifier("modifier_phantom_assassin_crit_steal") then 
    self.chance = self.chance + self:GetAbility().kill_chance
end


local random = RollPseudoRandomPercentage(self.chance,123,params.attacker)


if not random then return end

params.attacker:AddNewModifier(params.attacker,  ability, "modifier_phantom_assassin_phantom_coup_de_grace_focus", {duration = self:GetAbility():GetSpecialValueFor("duration")})
end 









modifier_phantom_assassin_phantom_coup_de_grace_armor = class({})
function modifier_phantom_assassin_phantom_coup_de_grace_armor:IsHidden() return false end
function modifier_phantom_assassin_phantom_coup_de_grace_armor:IsPurgable() return false end
function modifier_phantom_assassin_phantom_coup_de_grace_armor:DeclareFunctions()
return 
{
  MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS, 
}
end

function modifier_phantom_assassin_phantom_coup_de_grace_armor:OnCreated(table)

self.armor = self:GetCaster():GetTalentValue("modifier_phantom_assassin_crit_stack", "armor")
self.max = self:GetCaster():GetTalentValue("modifier_phantom_assassin_crit_stack", "max")

if not IsServer() then return end

self:SetStackCount(1)
end

function modifier_phantom_assassin_phantom_coup_de_grace_armor:GetModifierPhysicalArmorBonus() 
	return self.armor*self:GetStackCount()
end


function modifier_phantom_assassin_phantom_coup_de_grace_armor:OnRefresh()
if not IsServer() then return end 
if self:GetStackCount() >= self.max then return end 

self:IncrementStackCount()

if self:GetStackCount() >= self.max then 

  self:GetParent():EmitSound("Hoodwink.Acorn_armor")

  self.particle_peffect = ParticleManager:CreateParticle("particles/items3_fx/star_emblem.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent()) 
  ParticleManager:SetParticleControl(self.particle_peffect, 0, self:GetParent():GetAbsOrigin())
  self:AddParticle(self.particle_peffect, false, false, -1, false, true)
end

end 








modifier_phantom_assassin_phantom_coup_de_grace_legendaryself = class({})
function modifier_phantom_assassin_phantom_coup_de_grace_legendaryself:IsHidden() return false end
function modifier_phantom_assassin_phantom_coup_de_grace_legendaryself:IsPurgable() return false end
function modifier_phantom_assassin_phantom_coup_de_grace_legendaryself:RemoveOnDeath() return false end
function modifier_phantom_assassin_phantom_coup_de_grace_legendaryself:GetTexture() return "buffs/odds_fow" end



modifier_phantom_assassin_phantom_coup_de_grace_blood = class({})
function modifier_phantom_assassin_phantom_coup_de_grace_blood:IsHidden() return false end
function modifier_phantom_assassin_phantom_coup_de_grace_blood:IsPurgable() return false end
function modifier_phantom_assassin_phantom_coup_de_grace_blood:GetTexture() return "buffs/Crit_blood" end
function modifier_phantom_assassin_phantom_coup_de_grace_blood:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_phantom_assassin_phantom_coup_de_grace_blood:OnCreated(table)
if not IsServer() then return end
self.RemoveForDuel = true

self.damage = table.damage/self:GetRemainingTime()

self:StartIntervalThink(1)
end 

function modifier_phantom_assassin_phantom_coup_de_grace_blood:OnIntervalThink()
if not IsServer() then return end


local damageTable = 
{
  victim      = self:GetParent(),
  damage      = self.damage,
  damage_type   = DAMAGE_TYPE_MAGICAL,
  damage_flags  = DOTA_DAMAGE_FLAG_NONE,
  attacker    = self:GetCaster(),
  ability     = self:GetAbility()
}
                  
local damage =  ApplyDamage(damageTable)
      
SendOverheadEventMessage(self:GetParent(), 4, self:GetParent(), self.damage, nil)

if self:GetCaster() and self:GetCaster():IsAlive() then 
 self:GetCaster():GenericHeal(damage*self:GetAbility().blood_heal, self:GetAbility())
end

end





modifier_phantom_assassin_phantom_coup_de_grace_cd = class({})
function modifier_phantom_assassin_phantom_coup_de_grace_cd:IsHidden() return true end
function modifier_phantom_assassin_phantom_coup_de_grace_cd:IsPurgable() return false end




modifier_phantom_assassin_phantom_coup_de_grace_silence = class({})
function modifier_phantom_assassin_phantom_coup_de_grace_silence:IsHidden() return false end
function modifier_phantom_assassin_phantom_coup_de_grace_silence:IsPurgable() return true end
function modifier_phantom_assassin_phantom_coup_de_grace_silence:GetTexture() return "buffs/strike_stack" end
function modifier_phantom_assassin_phantom_coup_de_grace_silence:CheckState() return {[MODIFIER_STATE_SILENCED] = true} end


function modifier_phantom_assassin_phantom_coup_de_grace_silence:GetEffectName() return "particles/generic_gameplay/generic_silenced.vpcf" end
 
function modifier_phantom_assassin_phantom_coup_de_grace_silence:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end


function modifier_phantom_assassin_phantom_coup_de_grace_silence:OnCreated()

self.slow = self:GetCaster():GetTalentValue("modifier_phantom_assassin_crit_lowhp", "slow")

if not IsServer() then return end
self:GetParent():EmitSound("Sf.Raze_Silence")
end

function modifier_phantom_assassin_phantom_coup_de_grace_silence:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
end


function modifier_phantom_assassin_phantom_coup_de_grace_silence:GetModifierAttackSpeedBonus_Constant()
return self.slow
end




modifier_phantom_assassin_phantom_coup_de_grace_damage = class({})
function modifier_phantom_assassin_phantom_coup_de_grace_damage:IsHidden() return false end
function modifier_phantom_assassin_phantom_coup_de_grace_damage:IsPurgable() return false end
function modifier_phantom_assassin_phantom_coup_de_grace_damage:GetTexture() return "buffs/Blade_dance_stack" end


function modifier_phantom_assassin_phantom_coup_de_grace_damage:OnCreated(table)
self.damage = self:GetCaster():GetTalentValue("modifier_phantom_assassin_crit_chance", "damage")
end



function modifier_phantom_assassin_phantom_coup_de_grace_damage:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
}
end


function modifier_phantom_assassin_phantom_coup_de_grace_damage:GetModifierPreAttack_BonusDamage()
return self.damage
end





modifier_phantom_assassin_phantom_coup_de_grace_kill = class({})
function modifier_phantom_assassin_phantom_coup_de_grace_kill:IsHidden() return not self:GetParent():HasModifier("modifier_phantom_assassin_crit_steal") end
function modifier_phantom_assassin_phantom_coup_de_grace_kill:IsPurgable() return false end
function modifier_phantom_assassin_phantom_coup_de_grace_kill:RemoveOnDeath() return false end
function modifier_phantom_assassin_phantom_coup_de_grace_kill:GetTexture() return "buffs/crit_resist" end
--function modifier_phantom_assassin_phantom_coup_de_grace_kill:GetEffectName() return "particles/lc_odd_proc_hands.vpcf" end
function modifier_phantom_assassin_phantom_coup_de_grace_kill:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOOLTIP,
	MODIFIER_PROPERTY_TOOLTIP2
}
end

function modifier_phantom_assassin_phantom_coup_de_grace_kill:OnTooltip()
if not self:GetParent():HasModifier("modifier_phantom_assassin_crit_steal") then return end
return self:GetAbility().kill_damage*self:GetStackCount()
end

function modifier_phantom_assassin_phantom_coup_de_grace_kill:OnTooltip2()
if not self:GetParent():HasModifier("modifier_phantom_assassin_crit_steal") then return end
if self:GetStackCount() < self:GetAbility().kill_max then return end
return self:GetAbility().kill_chance
end


function modifier_phantom_assassin_phantom_coup_de_grace_kill:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
end

function modifier_phantom_assassin_phantom_coup_de_grace_kill:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self:GetAbility().kill_max then return end

self:IncrementStackCount()

if self:GetStackCount() >= self:GetAbility().kill_max then 

  local particle_peffect = ParticleManager:CreateParticle("particles/brist_lowhp_.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
  ParticleManager:SetParticleControl(particle_peffect, 0, self:GetCaster():GetAbsOrigin())
  ParticleManager:SetParticleControl(particle_peffect, 2, self:GetCaster():GetAbsOrigin())
  ParticleManager:ReleaseParticleIndex(particle_peffect)
  self:GetCaster():EmitSound("BS.Thirst_legendary_active")
end

end


modifier_phantom_assassin_phantom_coup_de_grace_slow = class({})
function modifier_phantom_assassin_phantom_coup_de_grace_slow:IsHidden() return false end
function modifier_phantom_assassin_phantom_coup_de_grace_slow:IsPurgable() return true end



function modifier_phantom_assassin_phantom_coup_de_grace_slow:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end


function modifier_phantom_assassin_phantom_coup_de_grace_slow:GetModifierMoveSpeedBonus_Percentage()
return self:GetAbility().cleave_slow[self:GetCaster():GetUpgradeStack("modifier_phantom_assassin_crit_speed")]
end






modifier_phantom_assassin_phantom_coup_de_grace_quest = class({})
function modifier_phantom_assassin_phantom_coup_de_grace_quest:IsHidden() return true end
function modifier_phantom_assassin_phantom_coup_de_grace_quest:IsPurgable() return false end
function modifier_phantom_assassin_phantom_coup_de_grace_quest:OnCreated(table)
if not IsServer() then return end

self:SetStackCount(1)
end

function modifier_phantom_assassin_phantom_coup_de_grace_quest:OnRefresh(table)
if not IsServer() then return end
if not self:GetCaster():GetQuest() then return end

self:IncrementStackCount()


if self:GetStackCount() >= self:GetCaster().quest.number then 
  self:GetCaster():UpdateQuest(1)
  self:Destroy()
end

end


modifier_phantom_assassin_phantom_coup_de_grace_focus = class({})
function modifier_phantom_assassin_phantom_coup_de_grace_focus:IsHidden() return false end
function modifier_phantom_assassin_phantom_coup_de_grace_focus:IsPurgable() return false end


function modifier_phantom_assassin_phantom_coup_de_grace_focus:OnCreated( kv )

if not IsServer() then return end

if self:GetParent():HasModifier("modifier_phantom_assassin_crit_chance") then 
  self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_phantom_assassin_phantom_coup_de_grace_damage", {duration = self:GetCaster():GetTalentValue("modifier_phantom_assassin_crit_chance", "duration")})

end

self.record = nil
end

function modifier_phantom_assassin_phantom_coup_de_grace_focus:GetEffectName()
return "particles/units/heroes/hero_phantom_assassin/phantom_assassin_mark_overhead.vpcf"
end

function modifier_phantom_assassin_phantom_coup_de_grace_focus:GetEffectAttachType()
return PATTACH_OVERHEAD_FOLLOW
end




function modifier_phantom_assassin_phantom_coup_de_grace_focus:GetCritDamage() 
local damage = self:GetAbility():GetSpecialValueFor("damage")

if self:GetParent():HasModifier("modifier_phantom_assassin_phantom_coup_de_grace_kill") then 
  damage = damage + self:GetParent():FindModifierByName("modifier_phantom_assassin_phantom_coup_de_grace_kill"):GetStackCount()*self:GetAbility().kill_damage
end

  return damage 
end

function modifier_phantom_assassin_phantom_coup_de_grace_focus:DeclareFunctions()
 return  {
    MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
    MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
    MODIFIER_EVENT_ON_TAKEDAMAGE,
  }

end




function modifier_phantom_assassin_phantom_coup_de_grace_focus:OnTakeDamage(params)
if not IsServer() then return end
if params.attacker ~= self:GetParent() then return end
if params.inflictor ~= nil and not self.proced then return end
if params.unit:IsBuilding() then return end

if self.record and self.proced then 

  if self:GetParent():HasModifier("modifier_phantom_assassin_crit_damage") then
    local heal = params.damage*self:GetCaster():GetTalentValue("modifier_phantom_assassin_crit_damage", "heal")/100

    self:GetParent():GenericHeal(heal, self:GetParent())
  end

  self:Destroy()
end

end

function modifier_phantom_assassin_phantom_coup_de_grace_focus:GetModifierPreAttack_CriticalStrike( params )
if not IsServer() then return end
if not params.target:IsHero() and not params.target:IsCreep() then return end


local dagger = self:GetParent():FindModifierByName("modifier_custom_phantom_assassin_stifling_dagger_attack")


if dagger and dagger.main then 
  
  if dagger.main == 0 then 
    return
  end  
end 

self.record = params.record


local mod = self:GetParent():FindModifierByName("modifier_phantom_assassin_phantom_coup_de_grace_kill")


self.damage = self:GetAbility():GetSpecialValueFor( "crit_bonus" )

if mod then 
  self.damage = self.damage + mod:GetStackCount()*self:GetAbility().kill_damage
end

return self.damage

end



function modifier_phantom_assassin_phantom_coup_de_grace_focus:GetModifierProcAttack_Feedback( params )
if self:GetParent():PassivesDisabled() then return end
if not IsServer() then return end
if not self.record or params.target:IsBuilding() then return end



if self:GetParent():GetQuest() == "Phantom.Quest_8" and params.target:IsRealHero() then 
  params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_phantom_assassin_phantom_coup_de_grace_quest", {duration = 3})
end


if self:GetParent():HasModifier("modifier_phantom_assassin_crit_lowhp") and not params.target:HasModifier("modifier_phantom_assassin_phantom_coup_de_grace_silence_cd") then
  params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_phantom_assassin_phantom_coup_de_grace_silence_cd", {duration = self:GetCaster():GetTalentValue("modifier_phantom_assassin_crit_lowhp", "cd")}) 
  params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_phantom_assassin_phantom_coup_de_grace_silence", {duration = (1 - params.target:GetStatusResistance())*self:GetCaster():GetTalentValue("modifier_phantom_assassin_crit_lowhp", "silence")})
end


if self:GetParent():HasModifier("modifier_phantom_assassin_crit_speed") then 
  DoCleaveAttack(self:GetParent(), params.target, nil, params.damage*(self:GetAbility().cleave_damage[self:GetCaster():GetUpgradeStack("modifier_phantom_assassin_crit_speed")]), 150, 360, 650, "particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave_gods_strength.vpcf")
end

if self:GetCaster():HasModifier("modifier_phantom_assassin_crit_stack") then 
  local mod = params.target:FindModifierByName("modifier_phantom_assassin_phantom_coup_de_grace_armor")

  local count = self:GetCaster():GetTalentValue("modifier_phantom_assassin_crit_stack", "crit_stack") - 1

  for i = 1, count do 
    params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_phantom_assassin_phantom_coup_de_grace_armor", {duration = self:GetCaster():GetTalentValue("modifier_phantom_assassin_crit_stack", "duration")})
  end 


end 
      
self:PlayEffects( params.target )


if self:GetParent():HasModifier("modifier_phantom_assassin_crit_legendary") then 
  self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_phantom_assassin_phantom_coup_de_grace_cd", {duration = self:GetAbility():GetSpecialValueFor("crit_cd")})
else 
  self:GetAbility():UseResources(false, false, false, true)
end

self.proced = true

end




function modifier_phantom_assassin_phantom_coup_de_grace_focus:PlayEffects( target )

local sound_cast = "Hero_PhantomAssassin.CoupDeGrace"

local crit_effect = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf"
if self:GetCaster():HasModifier("modifier_phantom_assassin_persona_custom") then
  crit_effect = "particles/units/heroes/hero_phantom_assassin_persona/pa_persona_crit_impact.vpcf"
end

local vec = (target:GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Normalized()

local coup_pfx = ParticleManager:CreateParticle(crit_effect, PATTACH_ABSORIGIN_FOLLOW, target)
ParticleManager:SetParticleControlEnt( coup_pfx, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetOrigin(), true )
ParticleManager:SetParticleControl( coup_pfx, 1, target:GetOrigin() )
ParticleManager:SetParticleControlForward( coup_pfx, 1, -vec )
ParticleManager:ReleaseParticleIndex( coup_pfx )


target:EmitSound(sound_cast)

if self:GetCaster():GetModelName() == "models/heroes/phantom_assassin/pa_arcana.vmdl" then 

  target:EmitSound("Hero_PhantomAssassin.Arcana_Layer")

  local coup_pfx2 = ParticleManager:CreateParticle("particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/phantom_assassin_crit_arcana_swoop.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
  ParticleManager:SetParticleControlEnt(coup_pfx2, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
  ParticleManager:SetParticleControl(coup_pfx2, 1, target:GetAbsOrigin())
  ParticleManager:SetParticleControlForward( coup_pfx2, 1, -vec )
  ParticleManager:ReleaseParticleIndex(coup_pfx2)
end


end




modifier_phantom_assassin_phantom_coup_de_grace_silence_cd = class({})
function modifier_phantom_assassin_phantom_coup_de_grace_silence_cd:IsHidden() return true end
function modifier_phantom_assassin_phantom_coup_de_grace_silence_cd:IsPurgable() return false end
function modifier_phantom_assassin_phantom_coup_de_grace_silence_cd:RemoveOnDeath() return false end