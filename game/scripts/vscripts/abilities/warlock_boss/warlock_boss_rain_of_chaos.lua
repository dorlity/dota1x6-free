LinkLuaModifier("modifier_warlock_boss_rain_of_chaos_cd", "abilities/warlock_boss/warlock_boss_rain_of_chaos.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_warlock_boss_rain_of_chaos_passive", "abilities/warlock_boss/warlock_boss_rain_of_chaos.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_warlock_boss_rain_of_chaos_thinker", "abilities/warlock_boss/warlock_boss_rain_of_chaos.lua", LUA_MODIFIER_MOTION_NONE)

warlock_boss_rain_of_chaos = class({})

function warlock_boss_rain_of_chaos:GetIntrinsicModifierName()
return "modifier_warlock_boss_rain_of_chaos_passive"
end


function warlock_boss_rain_of_chaos:OnAbilityPhaseStart()

self:GetCaster():EmitSound("Warlock.Ult_pre")
return true
end


function warlock_boss_rain_of_chaos:OnSpellStart()
if not IsServer() then return end

self:GetCaster():EmitSound("Warlock.Ult_Voice")

CreateModifierThinker(self:GetCaster(), self, "modifier_warlock_boss_rain_of_chaos_thinker", {duration = self:GetSpecialValueFor("delay")}, self:GetCursorPosition(), self:GetCaster():GetTeamNumber(), false)

self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_warlock_boss_rain_of_chaos_cd", {duration = self:GetCooldownTimeRemaining()})
end



modifier_warlock_boss_rain_of_chaos_cd = class({})

function modifier_warlock_boss_rain_of_chaos_cd:IsHidden() return false end
function modifier_warlock_boss_rain_of_chaos_cd:IsPurgable() return false end



modifier_warlock_boss_rain_of_chaos_passive = class({})
function modifier_warlock_boss_rain_of_chaos_passive:IsHidden() return true end
function modifier_warlock_boss_rain_of_chaos_passive:IsPurgable() return false end
function modifier_warlock_boss_rain_of_chaos_passive:DeclareFunctions()
return
{
  MODIFIER_EVENT_ON_DEATH
}
end

function modifier_warlock_boss_rain_of_chaos_passive:OnDeath(params)
if not IsServer() then return end
if self:GetParent() ~= params.unit then return end

self:GetParent():EmitSound("Warlock.Death_voice")
self:GetParent():EmitSound("Warlock.Death_sound")

local particle = ParticleManager:CreateParticle( "particles/warlock_death.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
ParticleManager:SetParticleControl(particle, 0, self:GetParent():GetAbsOrigin())

ParticleManager:ReleaseParticleIndex( particle )
end




modifier_warlock_boss_rain_of_chaos_thinker = class({})


function modifier_warlock_boss_rain_of_chaos_thinker:IsHidden() return false end

function modifier_warlock_boss_rain_of_chaos_thinker:IsPurgable() return false end

function modifier_warlock_boss_rain_of_chaos_thinker:OnCreated(table)
if not IsServer() then return end

self.damage = self:GetAbility():GetSpecialValueFor("damage")/100
self.stun = self:GetAbility():GetSpecialValueFor("stun")

self.radius = self:GetAbility():GetSpecialValueFor("radius")
local particle_cast = "particles/warlock_aoe_cast.vpcf"
self.effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_CUSTOMORIGIN, self:GetParent())
ParticleManager:SetParticleControl( self.effect_cast, 0, self:GetParent():GetOrigin() )
ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( self.radius, 0, -self.radius) )
ParticleManager:SetParticleControl( self.effect_cast, 2, Vector( self:GetRemainingTime(), 0, 0 ) )

self:StartIntervalThink(self:GetRemainingTime() - 0.5)

end


function modifier_warlock_boss_rain_of_chaos_thinker:OnIntervalThink()
if not IsServer() then return end

local seed_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_warlock/warlock_rain_of_chaos_start.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(seed_particle, 0, self:GetParent():GetAbsOrigin())
ParticleManager:SetParticleControl(seed_particle, 1, Vector(self.radius, self.radius, self.radius))
ParticleManager:ReleaseParticleIndex(seed_particle)

end

function modifier_warlock_boss_rain_of_chaos_thinker:OnDestroy(table)
if not IsServer() then return end
  
ParticleManager:DestroyParticle( self.effect_cast, true )
ParticleManager:ReleaseParticleIndex( self.effect_cast )

self:GetParent():EmitSound("Warlock.Ult_cast")

local seed_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_warlock/warlock_rain_of_chaos.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(seed_particle, 0, self:GetParent():GetAbsOrigin())
ParticleManager:SetParticleControl(seed_particle, 1, Vector(self.radius, self.radius, self.radius))
ParticleManager:ReleaseParticleIndex(seed_particle)


for i = 1,self:GetCaster():GetUpgradeStack("modifier_waveupgrade_boss") do

  local golem = CreateUnitByName("npc_warlock_golem_custom", self:GetParent():GetAbsOrigin(), true, nil, nil, DOTA_TEAM_CUSTOM_5)
  golem:SetOwner(self:GetCaster())
  golem.mkb = self:GetCaster().mkb
  golem.summoned = true
  golem.owner = self:GetCaster().owner
  golem.summoner = self:GetCaster()
  golem:AddNewModifier(golem, nil, "modifier_waveupgrade", {})

  golem:EmitSound("Warlock.Golem_spawn")

  golem:SetBaseDamageMin(self:GetAbility():GetSpecialValueFor("golem_damage_"..self:GetCaster():GetUpgradeStack("modifier_waveupgrade_boss")))
  golem:SetBaseDamageMax(self:GetAbility():GetSpecialValueFor("golem_damage_"..self:GetCaster():GetUpgradeStack("modifier_waveupgrade_boss")))

  golem:SetBaseMaxHealth(self:GetAbility():GetSpecialValueFor("golem_health_"..self:GetCaster():GetUpgradeStack("modifier_waveupgrade_boss")))
  golem:SetHealth(self:GetAbility():GetSpecialValueFor("golem_health_"..self:GetCaster():GetUpgradeStack("modifier_waveupgrade_boss")))


  golem:SetPhysicalArmorBaseValue(self:GetAbility():GetSpecialValueFor("golem_armor_"..self:GetCaster():GetUpgradeStack("modifier_waveupgrade_boss")))
  golem:SetBaseMagicalResistanceValue(self:GetAbility():GetSpecialValueFor("golem_magic_"..self:GetCaster():GetUpgradeStack("modifier_waveupgrade_boss")))

  golem:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stunned", {duration = 0.1})
end

local  enemy_for_ability = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES , FIND_CLOSEST, false)
for _,i in ipairs(enemy_for_ability) do

  local damageTable = {victim = i,  damage = self.damage*i:GetMaxHealth(), damage_type = DAMAGE_TYPE_PURE, damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION, attacker = self:GetCaster(), ability = self:GetAbility()}
  local actualy_damage = ApplyDamage(damageTable)

  SendOverheadEventMessage(i, 4, i, self.damage*i:GetMaxHealth(), nil)

  i:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stunned", {duration = (1 -i:GetStatusResistance())*self.stun})
  
   
end
   


end