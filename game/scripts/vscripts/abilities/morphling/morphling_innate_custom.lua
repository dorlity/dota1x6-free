LinkLuaModifier( "modifier_morphling_innate_custom", "abilities/morphling/morphling_innate_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_morphling_innate_custom_buff", "abilities/morphling/morphling_innate_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_morphling_innate_custom_lowhp_cd", "abilities/morphling/morphling_innate_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_morphling_innate_custom_lowhp_health", "abilities/morphling/morphling_innate_custom", LUA_MODIFIER_MOTION_NONE )


morphling_innate_custom = class({})

function morphling_innate_custom:GetIntrinsicModifierName()
if not self:GetCaster():IsRealHero() then return end 
return "modifier_morphling_innate_custom"
end


function morphling_innate_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end

PrecacheResource( "particle", "particles/morphling/lowhp_health.vpcf", context )
PrecacheResource( "soundfile", "soundevents/npc_dota_hero_morphling.vsndevts", context )
end



modifier_morphling_innate_custom = class(mod_hidden)
function modifier_morphling_innate_custom:OnCreated(table)

self.parent = self:GetParent()
self.ability = self:GetAbility()

if not IsServer() then return end

self.scepter_max = self.ability:GetSpecialValueFor("scepter_max")

self.lowhp_health = self.parent:GetTalentValue("modifier_morphling_hero_6", "health", true)
self.lowhp_cd = self.parent:GetTalentValue("modifier_morphling_hero_6", "talent_cd", true)
self.lowhp_duration = self.parent:GetTalentValue("modifier_morphling_hero_6", "duration", true)

self.parent:AddDeathEvent(self, true)
self:UpdateTalent()
end

function modifier_morphling_innate_custom:Proc()
if not IsServer() then return end

self.parent:AddNewModifier(self.parent, self.ability, "modifier_morphling_innate_custom_buff", {})
end


function modifier_morphling_innate_custom:DeathEvent(params)
if not IsServer() then return end
if self:GetStackCount() >= self.scepter_max then return end
if not self.parent:HasScepter() then return end
local attacker = params.attacker
if attacker.owner then 
	attacker = attacker.owner
end

if attacker ~= self.parent then return end
if not params.unit:IsValidKill(attacker) then return end

self:IncrementStackCount()
dota1x6:CreateUpgradeOrb(self.parent, 1)
end


function modifier_morphling_innate_custom:OnDestroy()
if not IsServer() then return end
self.parent:RemoveModifierByName("modifier_morphling_innate_custom_buff")
end


function modifier_morphling_innate_custom:UpdateTalent(name)
if not IsServer() then return end

if name == "modifier_morphling_hero_6" or self.parent:HasTalent("modifier_morphling_hero_6") then
	self.parent:AddDamageEvent_inc(self, true)
end

end


function modifier_morphling_innate_custom:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MIN_HEALTH
}
end


function modifier_morphling_innate_custom:GetMinHealth()
if not self.parent:HasTalent("modifier_morphling_hero_6") then return end
if self.parent:PassivesDisabled() then return end
if self.parent:HasModifier("modifier_morphling_innate_custom_lowhp_cd") then return end
if self.parent:LethalDisabled() then return end
if not self.parent:IsAlive() then return end
if self.parent:GetHealth() <= 0 then return end

return 1
end

function modifier_morphling_innate_custom:DamageEvent_inc(params)
if not IsServer() then return end
if not self.parent:HasTalent("modifier_morphling_hero_6") then return end
if self.parent ~= params.unit then return end
if self.parent:PassivesDisabled() then return end
if self.parent:GetHealthPercent() > self.lowhp_health then return end
if self.parent:HasModifier("modifier_death") then return end
if self.parent:HasModifier("modifier_morphling_innate_custom_lowhp_cd") then return end

self.parent:AddNewModifier(self.parent, self.ability, "modifier_morphling_innate_custom_lowhp_cd", {duration = self.lowhp_cd})
self.parent:AddNewModifier(self.parent, self.ability, "modifier_morphling_innate_custom_lowhp_health", {duration = self.lowhp_duration})
self.parent:Purge(false, true, false, true, false)
end



modifier_morphling_innate_custom_buff = class(mod_visible)
function modifier_morphling_innate_custom_buff:RemoveOnDeath() return false end
function modifier_morphling_innate_custom_buff:OnCreated()
self.parent = self:GetParent()
self.ability = self:GetAbility()

if not self.ability then return end
self.stats = self.ability:GetSpecialValueFor("bonus_stat")

self.main_stat = -1
self.StackOnIllusion = true

if not IsServer() then return end
self:SetHasCustomTransmitterData(true)
self:SetStackCount(1)
self:UpdateMainStat()
end

function modifier_morphling_innate_custom_buff:OnRefresh(table)
if not IsServer() then return end
self:IncrementStackCount()
end

function modifier_morphling_innate_custom_buff:UpdateMainStat()
if not IsServer() then return end
self.main_stat = self.parent:GetPrimaryAttribute()
self:SendBuffRefreshToClients()
self.parent:CalculateStatBonus(true)
end


function modifier_morphling_innate_custom_buff:OnStackCountChanged(iStackCount)
if not IsServer() then return end
self.parent:CalculateStatBonus(true)
end

function modifier_morphling_innate_custom_buff:AddCustomTransmitterData() 
return 
{
  main_stat = self.main_stat,
} 
end

function modifier_morphling_innate_custom_buff:HandleCustomTransmitterData(data)
self.main_stat = data.main_stat
end


function modifier_morphling_innate_custom_buff:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
  MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
  MODIFIER_PROPERTY_TOOLTIP,
  MODIFIER_PROPERTY_TOOLTIP2
}
end

function modifier_morphling_innate_custom_buff:OnTooltip()
return self:GetStackCount()*self.stats
end

function modifier_morphling_innate_custom_buff:OnTooltip2()
return self.parent:GetUpgradeStack("modifier_morphling_innate_custom")
end

function modifier_morphling_innate_custom_buff:GetModifierBonusStats_Agility()
if self.main_stat ~= DOTA_ATTRIBUTE_AGILITY then return end
return self:GetStackCount()*self.stats
end

function modifier_morphling_innate_custom_buff:GetModifierBonusStats_Strength()
if self.main_stat ~= DOTA_ATTRIBUTE_STRENGTH then return end
return self:GetStackCount()*self.stats
end


modifier_morphling_innate_custom_lowhp_cd = class(mod_cd)
function modifier_morphling_innate_custom_lowhp_cd:GetTexture() return "buffs/morphling/hero_6" end



modifier_morphling_innate_custom_lowhp_health = class(mod_visible)
function modifier_morphling_innate_custom_lowhp_health:OnCreated()
self.parent = self:GetParent()
self.ability = self:GetAbility()
self.health = self.parent:GetHealth()
self.heal = self.parent:GetAgility()*self.parent:GetTalentValue("modifier_morphling_hero_6", "heal")/100

if not IsServer() then return end

local effect = ParticleManager:CreateParticle( "particles/morphling/lowhp_health.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
ParticleManager:SetParticleControl( effect, 0, self.parent:GetAbsOrigin() )
ParticleManager:SetParticleControlEnt(effect, 1, self.parent, PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(effect, 2, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(effect, 3, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
self:AddParticle(effect,false,false,-1,false,false)

self.parent:EmitSound("Morph.Lowhp_dispel")
self.parent:EmitSound("Morph.Lowhp_dispel2")

self.parent:CalculateStatBonus(true)
self.parent:SetHealth(self.health + self.heal)
end

function modifier_morphling_innate_custom_lowhp_health:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_HEALTH_BONUS
}
end

function modifier_morphling_innate_custom_lowhp_health:GetModifierHealthBonus()
return self.heal
end