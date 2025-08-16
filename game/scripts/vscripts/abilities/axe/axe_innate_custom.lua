LinkLuaModifier( "modifier_axe_coat_of_blood_custom", "abilities/axe/axe_innate_custom", LUA_MODIFIER_MOTION_NONE )


axe_innate_custom = class({})


function axe_innate_custom:GetIntrinsicModifierName()
if not self:GetCaster():IsRealHero() then return end 
return "modifier_axe_coat_of_blood_custom"
end

function axe_innate_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end
PrecacheResource( "soundfile", "soundevents/npc_dota_hero_axe.vsndevts", context )
PrecacheResource( "soundfile", "soundevents/vo_custom/axe_vo_custom.vsndevts", context ) 
end

modifier_axe_coat_of_blood_custom = class(mod_visible)
function modifier_axe_coat_of_blood_custom:RemoveOnDeath() return false end
function modifier_axe_coat_of_blood_custom:OnCreated(table)
self.parent = self:GetParent()
self.ability = self:GetAbility()
self.parent:AddDeathEvent(self, true)

self.armor = self.ability:GetSpecialValueFor("armor")
self.max = self.ability:GetSpecialValueFor("max")

self.kills_damage = self.parent:GetTalentValue("modifier_axe_hero_8", "damage", true)
self.kills_max = self.parent:GetTalentValue("modifier_axe_hero_8", "max", true)
self.kills_heal = self.parent:GetTalentValue("modifier_axe_hero_8", "heal", true)
self.kills_bonus = self.parent:GetTalentValue("modifier_axe_hero_8", "bonus", true)

if not IsServer() then return end 
self:SetStackCount(0)
end

function modifier_axe_coat_of_blood_custom:OnRefresh(table)
self.armor = self.ability:GetSpecialValueFor("armor")
end

function modifier_axe_coat_of_blood_custom:UpdateTalent(name)
if not IsServer() then return end

if name == "modifier_axe_hero_8" or self.parent:HasTalent("modifier_axe_hero_8") then
	self:StartIntervalThink(1)
end

end

function modifier_axe_coat_of_blood_custom:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
	MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
}
end

function modifier_axe_coat_of_blood_custom:GetModifierSpellAmplify_Percentage()
if not self.parent:HasTalent("modifier_axe_hero_8") then return end
return self:GetStackCount() >= self.kills_max and self.kills_damage*self.kills_bonus or self.kills_damage
end

function modifier_axe_coat_of_blood_custom:GetModifierHealthRegenPercentage()
if not self.parent:HasTalent("modifier_axe_hero_8") then return end
return self:GetStackCount() >= self.kills_max and self.kills_heal*self.kills_bonus or self.kills_heal
end

function modifier_axe_coat_of_blood_custom:GetModifierPhysicalArmorBonus()
return self.armor*self:GetStackCount()
end

function modifier_axe_coat_of_blood_custom:DeathEvent(params)
if not IsServer() then return end 
if not params.attacker then return end
if params.attacker ~= self.parent then return end
if not params.unit:IsValidKill(self.parent) then return end

self:AddStack()
end

function modifier_axe_coat_of_blood_custom:AddStack()
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end 
self:IncrementStackCount()
end

function modifier_axe_coat_of_blood_custom:OnIntervalThink()
if not IsServer() then return end 
if self:GetStackCount() < self.kills_max then return end

self.parent:GenericParticle("particles/brist_lowhp_.vpcf")
self.parent:EmitSound("BS.Thirst_legendary_active")

self:StartIntervalThink(-1)
end 

