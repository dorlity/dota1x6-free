LinkLuaModifier("modifier_custom_juggernaut_healing_ward", "abilities/juggernaut/custom_juggernaut_healing_ward.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_healing_ward_aura", "abilities/juggernaut/custom_juggernaut_healing_ward.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_healing_ward_reduction_aura", "abilities/juggernaut/custom_juggernaut_healing_ward.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_healing_ward_reduction", "abilities/juggernaut/custom_juggernaut_healing_ward.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_healing_ward_reduction_effect", "abilities/juggernaut/custom_juggernaut_healing_ward.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_healing_ward_buff", "abilities/juggernaut/custom_juggernaut_healing_ward.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_healing_ward_damage", "abilities/juggernaut/custom_juggernaut_healing_ward.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_healing_ward_slow_aura", "abilities/juggernaut/custom_juggernaut_healing_ward.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_healing_ward_slow", "abilities/juggernaut/custom_juggernaut_healing_ward.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_healing_ward_slow_strong", "abilities/juggernaut/custom_juggernaut_healing_ward.lua", LUA_MODIFIER_MOTION_NONE)

 
custom_juggernaut_healing_ward = class({})




function custom_juggernaut_healing_ward:Precache(context)

  PrecacheResource( "particle", "particles/units/heroes/hero_juggernaut/juggernaut_healing_ward.vpcf", context )
  PrecacheResource( "particle", "particles/jugg_ward_count.vpcf", context )
  PrecacheResource( "particle", "particles/units/heroes/hero_zuus/zuus_arc_lightning.vpcf", context )
  PrecacheResource( "particle", "particles/units/heroes/hero_oracle/oracle_false_promise_heal.vpcf", context )
  PrecacheResource( "particle", "particles/jugger_ward_legend.vpcf", context )
  PrecacheResource( "particle", "particles/jugg_ward_slow.vpcf", context )
  PrecacheResource( "particle", "particles/jugg_ward_buff.vpcf", context )
  PrecacheResource( "particle", "particles/items2_fx/heavens_halberd.vpcf", context )


end

function custom_juggernaut_healing_ward:GetAbilityTextureName()

    if self:GetCaster():HasModifier("modifier_juggernaut_fortunes_toat_golden_ward") then
        return "juggernaut/fortunes_tout_gold/juggernaut_healing_ward"
    end
    if self:GetCaster():HasModifier("modifier_juggernaut_fall_ward") then
        return "juggernaut_fall20_healingward"
    end

    if self:GetCaster():HasModifier("modifier_juggernaut_fortunes_toat_ward") then
        return "juggernaut/fortunes_tout/juggernaut_healing_ward"
    end
    if self:GetCaster():HasModifier("modifier_juggernaut_bladekeeper_weapon") then
        return "juggernaut/bladekeeper/juggernaut_healing_ward"
    end
    if self:GetCaster():HasModifier("modifier_juggernaut_arcana") or self:GetCaster():HasModifier("modifier_juggernaut_arcana_v2") then
        return "juggernaut_healing_ward_arcana"
    end
    return "juggernaut_healing_ward"
end




function custom_juggernaut_healing_ward:GetCooldown(iLevel)
local upgrade_cooldown = self:GetCaster():GetTalentValue("modifier_juggernaut_healingward_cd", "cd")

return self.BaseClass.GetCooldown(self, iLevel) + upgrade_cooldown 
end





function custom_juggernaut_healing_ward:OnSpellStart()
self.duration = self:GetSpecialValueFor("duration")
self.radius = self:GetSpecialValueFor("radius")

if self:GetCaster():HasModifier("modifier_juggernaut_healingward_cd") then 
  self.radius = self.radius + self:GetCaster():GetTalentValue("modifier_juggernaut_healingward_cd", "radius")
end 


if not IsServer() then return end

self:SetActivated(false)
self:EndCooldown()


self.ward = CreateUnitByName("juggernaut_healing_ward", self:GetCursorPosition(), true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber())
self.ward:AddNewModifier(self:GetCaster(), self, "modifier_kill", {duration = self.duration})
self.ward:SetControllableByPlayer(self:GetCaster():GetPlayerOwnerID(), true)

self.ward.owner = self:GetCaster()

Timers:CreateTimer(0.05, function()self.ward:MoveToNPC(self:GetCaster()) end)

self.ward:AddNewModifier(self:GetCaster(), self, "modifier_custom_juggernaut_healing_ward", {duration = self.duration})

if self:GetCaster():HasModifier("modifier_juggernaut_healingward_legendary") then
  self.ward:AddNewModifier(self:GetCaster(), self, "modifier_custom_juggernaut_healing_ward_reduction", {})
end

if self:GetCaster():HasModifier("modifier_juggernaut_healingward_purge") then
  self.ward:AddNewModifier(self:GetCaster(), self, "modifier_custom_juggernaut_healing_ward_slow_aura", {})

  local targets = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self.ward:GetAbsOrigin(), nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)

  for _,target in pairs(targets) do 
    target:EmitSound("Jugg.Disarm_ward")
    target:AddNewModifier(self:GetCaster(), self, "modifier_custom_juggernaut_healing_ward_slow_strong", {duration = (1 - target:GetStatusResistance())*self:GetCaster():GetTalentValue("modifier_juggernaut_healingward_purge", "disarm")})
  end

end



end




modifier_custom_juggernaut_healing_ward = class({})



function modifier_custom_juggernaut_healing_ward:OnCreated(table)

self.legendary_move = self:GetCaster():GetTalentValue("modifier_juggernaut_healingward_legendary", "move")
self.hits_melee = self:GetCaster():GetTalentValue("modifier_juggernaut_healingward_legendary", "hits_melee")
self.hits_ranged = self:GetCaster():GetTalentValue("modifier_juggernaut_healingward_legendary", "hits_ranged")

self.radius = self:GetAbility():GetSpecialValueFor("radius")

self.damage = self:GetCaster():GetTalentValue("modifier_juggernaut_healingward_heal", "damage")/100

if self:GetCaster():HasModifier("modifier_juggernaut_healingward_cd") then 
  self.radius = self.radius + self:GetCaster():GetTalentValue("modifier_juggernaut_healingward_cd", "radius")
end 

if not IsServer() then return end
self.hits = 12

self.buff_max = self:GetCaster():GetTalentValue("modifier_juggernaut_healingward_return", "interval")


self.sound = "Hero_Juggernaut.HealingWard.Loop"
local sound_cast = "Hero_Juggernaut.HealingWard.Cast"
self.sound_stop = "Hero_Juggernaut.HealingWard.Stop"

local particle_fx = "particles/units/heroes/hero_juggernaut/juggernaut_healing_ward.vpcf"
if self:GetCaster():HasModifier("modifier_juggernaut_fortunes_toat_ward") then

    self:GetParent():SetModel("models/items/juggernaut/ward/fortunes_tout/fortunes_tout.vmdl")
    self:GetParent():SetOriginalModel("models/items/juggernaut/ward/fortunes_tout/fortunes_tout.vmdl")
    particle_fx = "particles/econ/items/juggernaut/jugg_fortunes_tout/jugg_healling_ward_fortunes_tout_ward.vpcf"
    self.sound = "Hero_Juggernaut.FortunesTout.Loop"
    sound_cast = "Hero_Juggernaut.FortunesTout.Cast"
    self.sound_stop = "Hero_Juggernaut.FortunesTout.Stop"
    self:GetParent():SetModelScale(0.85)
end

if self:GetCaster():HasModifier("modifier_juggernaut_fortunes_toat_golden_ward") then
    self:GetParent():SetModel("models/items/juggernaut/ward/fortunes_tout/fortunes_tout.vmdl")
    self:GetParent():SetOriginalModel("models/items/juggernaut/ward/fortunes_tout/fortunes_tout.vmdl")
    self:GetParent():SetMaterialGroup("1")
    particle_fx = "particles/econ/items/juggernaut/jugg_fortunes_tout/jugg_healing_ward_fortunes_tout_gold.vpcf"
    self.sound = "Hero_Juggernaut.FortunesTout.Loop"
    sound_cast = "Hero_Juggernaut.FortunesTout.Cast"
    self.sound_stop = "Hero_Juggernaut.FortunesTout.Stop"
    self:GetParent():SetModelScale(0.85)
end
if self:GetCaster():HasModifier("modifier_juggernaut_fall_ward") then
    self:GetParent():SetModel("models/items/juggernaut/ward/fall20_juggernaut_katz_ward/fall20_juggernaut_katz_ward.vmdl")
    self:GetParent():SetOriginalModel("models/items/juggernaut/ward/fall20_juggernaut_katz_ward/fall20_juggernaut_katz_ward.vmdl")
    particle_fx = "particles/econ/items/juggernaut/jugg_fall20_immortal/jugg_fall20_immortal_healing_ward.vpcf"

end
if self:GetCaster():HasModifier("modifier_juggernaut_isle_of_dragons_ward") then
    self:GetParent():SetModel("models/items/juggernaut/ward/miyamoto_musash_ward/miyamoto_musash_ward.vmdl")
    self:GetParent():SetOriginalModel("models/items/juggernaut/ward/miyamoto_musash_ward/miyamoto_musash_ward.vmdl")
    self:GetParent():SetMaterialGroup("1")
end

if self:GetCaster():HasModifier("modifier_juggernaut_isle_of_dragons_ward_2") then
    self:GetParent():SetModel("models/items/juggernaut/ward/miyamoto_musash_ward/miyamoto_musash_ward.vmdl")
    self:GetParent():SetOriginalModel("models/items/juggernaut/ward/miyamoto_musash_ward/miyamoto_musash_ward.vmdl")
    self:GetParent():SetMaterialGroup("2")
end


self.ward_particle = ParticleManager:CreateParticle(particle_fx, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControl(self.ward_particle, 0, self:GetParent():GetAbsOrigin())
ParticleManager:SetParticleControl(self.ward_particle, 1, Vector(self:GetAbility().radius, 1, 1))
ParticleManager:SetParticleControlEnt(self.ward_particle, 2, self:GetParent(), PATTACH_POINT_FOLLOW, "flame_attachment", self:GetParent():GetAbsOrigin(), true)


self:GetParent():EmitSound(self.sound) 
self:GetParent():EmitSound(sound_cast)

self.interval = 0.5

if self:GetCaster():HasModifier("modifier_juggernaut_healingward_return") then 

  local name = "particles/jugg_ward_count.vpcf"
  self.particle = ParticleManager:CreateParticle(name, PATTACH_OVERHEAD_FOLLOW, self:GetParent())
  self:AddParticle(self.particle, false, false, -1, false, false)

  for i = 1,self.buff_max do 
    if i <= 0 then 
      ParticleManager:SetParticleControl(self.particle, i, Vector(1, 0, 0)) 
    else 
      ParticleManager:SetParticleControl(self.particle, i, Vector(0, 0, 0)) 
    end
  end


  self.tick = self:GetCaster():GetTalentValue("modifier_juggernaut_healingward_return", "tick")
  self.count = -self.interval

end

self:OnIntervalThink()
self:StartIntervalThink(self.interval)
end



function modifier_custom_juggernaut_healing_ward:OnIntervalThink()
if not IsServer() then return end
if not self:GetParent():IsAlive() then return end

if self:GetCaster():HasModifier("modifier_juggernaut_healingward_heal") then 
  local targets = self:GetCaster():FindTargets(self.radius, self:GetParent():GetAbsOrigin())

  local damage = self:GetCaster():GetMaxHealth()*self.interval*self.damage

  for _,target in pairs(targets) do
    ApplyDamage({victim = target, attacker = self:GetCaster(), damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self:GetAbility()})
  end

end 


if not self:GetCaster():HasModifier("modifier_juggernaut_healingward_return") then return end 

self.count = self.count + self.interval

if self.count >= self.tick then 
  self.count = 0
else 
  return
end




if (self:GetCaster():GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D() > self.radius then 
  self:SetStackCount(0)
else 
  if not self:GetCaster():HasModifier("modifier_custom_juggernaut_healing_ward_buff") then 
    self:IncrementStackCount()
  end
end


if self:GetStackCount() >= self.buff_max then 

  self:Buff()
  self:SetStackCount(0)
end



if self.particle then

  for i = 1,self.buff_max do 
    if i <= self:GetStackCount() then 
      ParticleManager:SetParticleControl(self.particle, i, Vector(1, 0, 0)) 
    else 
      ParticleManager:SetParticleControl(self.particle, i, Vector(0, 0, 0)) 
    end
  end

end



end






function modifier_custom_juggernaut_healing_ward:Buff()
if not IsServer() then return end

  local item_effect = ParticleManager:CreateParticle( "particles/units/heroes/hero_zuus/zuus_arc_lightning.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
  ParticleManager:SetParticleControlEnt(item_effect, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetOrigin(), true )
  ParticleManager:SetParticleControlEnt(item_effect, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )
    
  ParticleManager:ReleaseParticleIndex(item_effect)
  self:GetParent():EmitSound("Juggernaut.Ward_buff")

 
  local duration = self:GetCaster():GetTalentValue("modifier_juggernaut_healingward_return", "duration")
  self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_juggernaut_healing_ward_buff", {duration = duration})

  for _,target in pairs(self:GetCaster():FindTargets(self.radius, self:GetParent():GetAbsOrigin())) do 

    local item_effect = ParticleManager:CreateParticle( "particles/units/heroes/hero_zuus/zuus_arc_lightning.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
    ParticleManager:SetParticleControlEnt(item_effect, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetOrigin(), true )
    ParticleManager:SetParticleControlEnt(item_effect, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )
    ParticleManager:ReleaseParticleIndex(item_effect)

    target:AddNewModifier(self:GetCaster(), self:GetAbility(), 'modifier_custom_juggernaut_healing_ward_damage', {duration = duration})
  end 

end


function modifier_custom_juggernaut_healing_ward:OnDeath( params )
if not IsServer() then return end
if params.unit ~= self:GetParent() then return end


self.killer = params.attacker
self:Destroy()

end


function modifier_custom_juggernaut_healing_ward:OnDestroy()
if not IsServer() then return end

if self:GetCaster():HasModifier("modifier_juggernaut_fall_ward") then
    local death_particle = ParticleManager:CreateParticle("particles/econ/items/juggernaut/jugg_fall20_immortal/jugg_fall20_immortal_healing_ward_death.vpcf", PATTACH_WORLDORIGIN, self:GetParent())
    ParticleManager:SetParticleControl(death_particle, 0, self:GetParent():GetAbsOrigin())
    ParticleManager:ReleaseParticleIndex(death_particle)
end

if self:GetCaster():HasModifier("modifier_juggernaut_healingward_return") then 
  self:Buff()
end

self:GetParent():EmitSound(self.sound_stop)

ParticleManager:DestroyParticle(self.ward_particle, true)
ParticleManager:ReleaseParticleIndex(self.ward_particle)



self:GetParent():StopSound(self.sound)


if self:GetAbility() then 
  self:GetAbility():UseResources(false, false, false, true)
  self:GetAbility():SetActivated(true)
end

local damage = false
local stun = false


if self:GetCaster():HasModifier("modifier_juggernaut_healingward_heal") then 
  damage = true
end


if self:GetCaster():HasModifier("modifier_juggernaut_healingward_stun") then 

  stun = true

  local heal =  self:GetCaster():GetTalentValue("modifier_juggernaut_healingward_stun", "heal")*self:GetCaster():GetMaxHealth()/100

  self:GetCaster():GenericHeal(heal, self:GetAbility())
   

  local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_oracle/oracle_false_promise_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
  ParticleManager:ReleaseParticleIndex( particle )

end


if stun == true or damage == true then
  self:GetParent():EmitSound("Juggernaut.WardDeath")  
  local targets = self:GetCaster():FindTargets(self.radius, self:GetParent():GetAbsOrigin())

  local duration = self:GetCaster():GetTalentValue("modifier_juggernaut_healingward_stun", "stun") 
  local deal_damage = self:GetCaster():GetMaxHealth()*self.damage*(self:GetCaster():GetTalentValue("modifier_juggernaut_healingward_heal", "death")/100)



  for _,target in pairs(targets) do 

    if stun == true then 
      target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stunned", {duration = duration*( 1 - target:GetStatusResistance())})
    end 

    if damage == true then 

      ApplyDamage({victim = target, attacker = self:GetCaster(), damage = deal_damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self:GetAbility()})
    end
      
    local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_oracle/oracle_false_promise_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, target )
    ParticleManager:ReleaseParticleIndex( particle )
 
    particle = ParticleManager:CreateParticle("particles/jugg_ward_damage.vpcf", PATTACH_POINT_FOLLOW, self:GetParent())
    ParticleManager:SetParticleControlEnt(particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
    ParticleManager:SetParticleControlEnt(particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
    ParticleManager:SetParticleControlEnt(particle, 2, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
    ParticleManager:ReleaseParticleIndex(particle)
  end 

end 

end






function modifier_custom_juggernaut_healing_ward:GetModifierMoveSpeedBonus_Constant()
return self.legendary_move
end



function modifier_custom_juggernaut_healing_ward:IsHidden() return true end

function modifier_custom_juggernaut_healing_ward:IsPurgable() return false end

function modifier_custom_juggernaut_healing_ward:IsAura() return true end

function modifier_custom_juggernaut_healing_ward:GetAuraDuration() return 2 end

function modifier_custom_juggernaut_healing_ward:GetAuraRadius() return self:GetAbility().radius end

function modifier_custom_juggernaut_healing_ward:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end

function modifier_custom_juggernaut_healing_ward:GetAuraSearchType() return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO end

function modifier_custom_juggernaut_healing_ward:GetModifierAura() return "modifier_custom_juggernaut_healing_ward_aura" end

function modifier_custom_juggernaut_healing_ward:CheckState() 

if self:GetCaster():HasModifier("modifier_juggernaut_healingward_legendary") then 
  return 
  {
    [MODIFIER_STATE_MAGIC_IMMUNE] = true,
    [MODIFIER_STATE_LOW_ATTACK_PRIORITY] = true
  }
else 
  return 
  {
    [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
    [MODIFIER_STATE_MAGIC_IMMUNE] = true,
    [MODIFIER_STATE_LOW_ATTACK_PRIORITY] = true
  }
end

end

function modifier_custom_juggernaut_healing_ward:DeclareFunctions() return
{
  MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
  MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
  MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
  MODIFIER_EVENT_ON_ATTACK_LANDED,
  MODIFIER_EVENT_ON_DEATH,
  MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
} 
end





function modifier_custom_juggernaut_healing_ward:GetAbsoluteNoDamageMagical() return 1 end

function modifier_custom_juggernaut_healing_ward:GetAbsoluteNoDamagePhysical() return 1 end

function modifier_custom_juggernaut_healing_ward:GetAbsoluteNoDamagePure() return 1 end

function modifier_custom_juggernaut_healing_ward:OnAttackLanded( param )
if not IsServer() then return end


if self:GetAbility():GetCaster():HasModifier("modifier_juggernaut_healingward_legendary") and param.attacker.owner and param.attacker.owner:IsRealHero() then return end
if self:GetParent() ~= param.target then return end

if self:GetAbility():GetCaster():HasModifier("modifier_juggernaut_healingward_legendary") then

  local hits = self.hits_ranged
  if param.attacker:IsRangedAttacker() then 
    hits = self.hits_melee
  end

  self.hits = self.hits - hits
else 

  self.hits = self.hits - 12
end
        

if self.hits <= 0 then
  self:GetParent():Kill(nil, param.attacker)
else 

  self:GetParent():SetHealth(self.hits)
end



end






modifier_custom_juggernaut_healing_ward_aura = class({})

function modifier_custom_juggernaut_healing_ward_aura:IsPurgable() return false end

function modifier_custom_juggernaut_healing_ward_aura:DeclareFunctions()
return 
{
    MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
    MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end 

function modifier_custom_juggernaut_healing_ward_aura:GetModifierStatusResistanceStacking()
return self.status
end


function modifier_custom_juggernaut_healing_ward_aura:GetModifierMoveSpeedBonus_Percentage()
return self.move
end



function modifier_custom_juggernaut_healing_ward_aura:OnCreated(table)
self.health_regen = self:GetAbility():GetSpecialValueFor("health_regen") + self:GetCaster():GetTalentValue("modifier_juggernaut_healingward_stun", "regen")

self.move = self:GetCaster():GetTalentValue("modifier_juggernaut_healingward_move", "move_status")
self.status = self:GetCaster():GetTalentValue("modifier_juggernaut_healingward_move", "move_status")


end








function modifier_custom_juggernaut_healing_ward_aura:GetModifierHealthRegenPercentage() return self.health_regen end




modifier_custom_juggernaut_healing_ward_reduction = class({})

function modifier_custom_juggernaut_healing_ward_reduction:IsHidden() return true end
function modifier_custom_juggernaut_healing_ward_reduction:IsPurgable() return false end
function modifier_custom_juggernaut_healing_ward_reduction:IsAura() return true end
function modifier_custom_juggernaut_healing_ward_reduction:GetAuraDuration() return 0.1 end
function modifier_custom_juggernaut_healing_ward_reduction:GetAuraRadius() return self:GetAbility().radius end
function modifier_custom_juggernaut_healing_ward_reduction:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_custom_juggernaut_healing_ward_reduction:GetAuraSearchType() return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO end
function modifier_custom_juggernaut_healing_ward_reduction:GetModifierAura() return "modifier_custom_juggernaut_healing_ward_reduction_aura" end

function modifier_custom_juggernaut_healing_ward_reduction:GetAuraEntityReject(hEntity)

local mod = hEntity:FindModifierByName("modifier_backdoor_knock_aura_damage")



if mod and mod:GetCaster():GetTeamNumber() ~= self:GetParent():GetTeamNumber() and mod.radius then 

  local point = mod:GetCaster():GetAbsOrigin()

  if (self:GetParent():GetAbsOrigin() - point):Length2D() > mod.radius then 
    return true
  end 

end

return false
end



modifier_custom_juggernaut_healing_ward_reduction_aura = class({})

function modifier_custom_juggernaut_healing_ward_reduction_aura:GetEffectName() return "particles/jugger_ward_legend.vpcf" end
function modifier_custom_juggernaut_healing_ward_reduction_aura:IsPurgable() return false end
function modifier_custom_juggernaut_healing_ward_reduction_aura:IsHidden() return true end
function modifier_custom_juggernaut_healing_ward_reduction_aura:DeclareFunctions() 
  return 
  {
    MODIFIER_PROPERTY_MIN_HEALTH
  }
end

function modifier_custom_juggernaut_healing_ward_reduction_aura:GetMinHealth()
if not self:GetCaster():HasModifier("modifier_death") then 
 return 1 
else 
 return 0
end
end

function modifier_custom_juggernaut_healing_ward_reduction_aura:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end






modifier_custom_juggernaut_healing_ward_slow_aura = class({})

function modifier_custom_juggernaut_healing_ward_slow_aura:IsHidden() return true end
function modifier_custom_juggernaut_healing_ward_slow_aura:IsPurgable() return false end
function modifier_custom_juggernaut_healing_ward_slow_aura:IsAura() return true end
function modifier_custom_juggernaut_healing_ward_slow_aura:GetAuraDuration() return 0.1 end
function modifier_custom_juggernaut_healing_ward_slow_aura:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("radius") end
function modifier_custom_juggernaut_healing_ward_slow_aura:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_custom_juggernaut_healing_ward_slow_aura:GetAuraSearchType() return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO end

function modifier_custom_juggernaut_healing_ward_slow_aura:GetAuraSearchFlags()
  return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_custom_juggernaut_healing_ward_slow_aura:GetModifierAura()
 return "modifier_custom_juggernaut_healing_ward_slow" 

end





modifier_custom_juggernaut_healing_ward_slow = class({})
function modifier_custom_juggernaut_healing_ward_slow:IsHidden() return false end

function modifier_custom_juggernaut_healing_ward_slow:GetEffectName()
return "particles/jugg_ward_slow.vpcf"
end
function modifier_custom_juggernaut_healing_ward_slow:GetTexture()
return "buffs/Healing_ward_slow"
end

function modifier_custom_juggernaut_healing_ward_slow:IsPurgable() return false end
function modifier_custom_juggernaut_healing_ward_slow:OnCreated(table)
self.slow = self:GetCaster():GetTalentValue("modifier_juggernaut_healingward_purge", "slow")
end

function modifier_custom_juggernaut_healing_ward_slow:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
}
end

function modifier_custom_juggernaut_healing_ward_slow:GetModifierMoveSpeedBonus_Percentage()
return self.slow
end



modifier_custom_juggernaut_healing_ward_slow_strong = class({})
function modifier_custom_juggernaut_healing_ward_slow_strong:IsHidden() return true end

function modifier_custom_juggernaut_healing_ward_slow_strong:GetEffectName()
return "particles/items2_fx/heavens_halberd.vpcf"
end


function modifier_custom_juggernaut_healing_ward_slow_strong:GetEffectAttachType()
return PATTACH_OVERHEAD_FOLLOW
end



function modifier_custom_juggernaut_healing_ward_slow_strong:IsPurgable() return false end
function modifier_custom_juggernaut_healing_ward_slow_strong:CheckState()
return
{
  [MODIFIER_STATE_DISARMED] = true
}
end







modifier_custom_juggernaut_healing_ward_buff = class({})
function modifier_custom_juggernaut_healing_ward_buff:IsHidden() return false end

function modifier_custom_juggernaut_healing_ward_buff:GetEffectName()
return "particles/jugg_ward_buff.vpcf"
end

function modifier_custom_juggernaut_healing_ward_buff:GetTexture()
return "buffs/Healing_ward_buff"
end

function modifier_custom_juggernaut_healing_ward_buff:IsPurgable() return false end
function modifier_custom_juggernaut_healing_ward_buff:OnCreated(table)
self.speed = self:GetCaster():GetTalentValue("modifier_juggernaut_healingward_return", "bonus_speed")
end

function modifier_custom_juggernaut_healing_ward_buff:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
end

function modifier_custom_juggernaut_healing_ward_buff:GetModifierAttackSpeedBonus_Constant()
return self.speed
end



modifier_custom_juggernaut_healing_ward_damage = class({})
function modifier_custom_juggernaut_healing_ward_damage:IsHidden() return true end
function modifier_custom_juggernaut_healing_ward_damage:IsPurgable() return false end
function modifier_custom_juggernaut_healing_ward_damage:DeclareFunctions()
return 
{
  MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
}
end

function modifier_custom_juggernaut_healing_ward_damage:OnCreated(table)

self.damage = self:GetCaster():GetTalentValue("modifier_juggernaut_healingward_return", "bonus_damage")

if not IsServer() then return end
self.particle_peffect = ParticleManager:CreateParticle("particles/items3_fx/star_emblem.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent()) 
ParticleManager:SetParticleControl(self.particle_peffect, 0, self:GetParent():GetAbsOrigin())
self:AddParticle(self.particle_peffect, false, false, -1, false, true)
end

function modifier_custom_juggernaut_healing_ward_damage:GetModifierIncomingDamage_Percentage() 
  return self.damage
end
