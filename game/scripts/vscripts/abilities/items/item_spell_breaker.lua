LinkLuaModifier("modifier_item_spell_breaker", "abilities/items/item_spell_breaker", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_spell_breaker_shield", "abilities/items/item_spell_breaker", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_spell_breaker_passive", "abilities/items/item_spell_breaker", LUA_MODIFIER_MOTION_NONE)

item_spell_breaker = class({})

function item_spell_breaker:GetIntrinsicModifierName()
	return "modifier_item_spell_breaker"
end
function item_spell_breaker:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end
PrecacheResource( "particle","particles/spell_breaker.vpcf", context )
PrecacheResource( "particle","particles/units/heroes/hero_muerta/muerta_spell_amp_steal_debuff.vpcf", context )
PrecacheResource( "particle","particles/items3_fx/status_effect_mage_slayer_debuff.vpcf", context )
end

function item_spell_breaker:OnSpellStart()
if not IsServer() then return end 

self:GetCaster():EmitSound("Items.Spell_breaker")
self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_item_spell_breaker_shield", {duration = self:GetSpecialValueFor("duration_active")})
end 


modifier_item_spell_breaker = class({})

function modifier_item_spell_breaker:IsHidden() return true end
function modifier_item_spell_breaker:IsPurgable() return false end
function modifier_item_spell_breaker:DeclareFunctions()
return 
{
    MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
    MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
    MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
}
end


function modifier_item_spell_breaker:OnCreated()

self.parent = self:GetParent()
self.ability = self:GetAbility()
self.parent:AddAttackEvent_out(self, true)

self.duration = self.ability:GetSpecialValueFor("duration")
self.damage = self.ability:GetSpecialValueFor("bonus_damage")
self.regen = self.ability:GetSpecialValueFor("bonus_mana_regen")
self.health_regen = self.ability:GetSpecialValueFor("bonus_health_regen")
self.resist = self.ability:GetSpecialValueFor("bonus_magical_armor")
self.speed = self.ability:GetSpecialValueFor("bonus_attack_speed")
end 

function modifier_item_spell_breaker:AttackEvent_out(params)
if not IsServer() then return end 
if self.parent ~= params.attacker then return end 
if not params.target:IsUnit() then return end

params.target:AddNewModifier(self.parent , self.ability, "modifier_item_spell_breaker_passive", {duration = self.duration})
end



function modifier_item_spell_breaker:GetModifierMagicalResistanceBonus()
if self.parent :HasModifier("modifier_item_pipe_custom") then return end
if self.parent :HasModifier("modifier_item_eternal_shroud_custom") then return end
if self.parent :HasModifier("modifier_item_mage_slayer") then return end

return self.resist
end



function modifier_item_spell_breaker:GetModifierConstantManaRegen()
return self.regen
end

function modifier_item_spell_breaker:GetModifierConstantHealthRegen()
return self.health_regen
end

function modifier_item_spell_breaker:GetModifierAttackSpeedBonus_Constant()
return self.speed
end

function modifier_item_spell_breaker:GetModifierPreAttack_BonusDamage()
return self.damage
end






modifier_item_spell_breaker_shield = class({})
function modifier_item_spell_breaker_shield:IsHidden() return false end
function modifier_item_spell_breaker_shield:IsPurgable() return true end


function modifier_item_spell_breaker_shield:OnCreated(table)

self.damage = self:GetAbility():GetSpecialValueFor("resist_active")*-1
if not IsServer() then return end



local particle = ParticleManager:CreateParticle("particles/spell_breaker.vpcf", PATTACH_POINT_FOLLOW, self:GetParent())
ParticleManager:SetParticleControlEnt(particle,0,self:GetParent(),PATTACH_POINT_FOLLOW,"attach_hitloc",self:GetParent():GetAbsOrigin(),false)
ParticleManager:SetParticleControl(particle, 1 , Vector(100,1,1))
self:AddParticle(particle, false, false, -1, false, false)   



end

function modifier_item_spell_breaker_shield:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    MODIFIER_PROPERTY_TOOLTIP
}

end
function modifier_item_spell_breaker_shield:GetModifierIncomingDamage_Percentage(params)
--if self:GetParent() ~= params.unit then return end
if params.inflictor == nil then return end
--if bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then return end

if Not_spell_damage[params.inflictor:GetName()] then return end

return self.damage
end

function modifier_item_spell_breaker_shield:OnTooltip()
return self.damage
end


modifier_item_spell_breaker_passive = class({})
function modifier_item_spell_breaker_passive:IsHidden() return false end
function modifier_item_spell_breaker_passive:IsPurgable() return false end

function modifier_item_spell_breaker_passive:GetEffectName()
return "particles/units/heroes/hero_muerta/muerta_spell_amp_steal_debuff.vpcf"
end 


function modifier_item_spell_breaker_passive:GetEffectAttachType()
return PATTACH_OVERHEAD_FOLLOW
end

function modifier_item_spell_breaker_passive:GetStatusEffectName()
return "particles/items3_fx/status_effect_mage_slayer_debuff.vpcf"
end

function modifier_item_spell_breaker_passive:StatusEffectPriority()
return MODIFIER_PRIORITY_NORMAL 
end

function modifier_item_spell_breaker_passive:OnCreated()

self.parent = self:GetParent()
self.ability = self:GetAbility()
self.caster = self:GetCaster()

self.dps = self.ability:GetSpecialValueFor("dps")
self.interval = self.ability:GetSpecialValueFor("interval")
self.amp = self.ability:GetSpecialValueFor("spell_amp_debuff")
self.damageTable = {victim = self.parent, attacker = self.caster, damage = self.dps*self.interval, ability = self.ability, damage_type = DAMAGE_TYPE_MAGICAL}

if not IsServer() then return end 

self:StartIntervalThink(self.interval)
end 

function modifier_item_spell_breaker_passive:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
}
end

function modifier_item_spell_breaker_passive:GetModifierSpellAmplify_Percentage() 
if self.parent:HasModifier("modifier_item_mage_slayer_debuff") then return end
return self.amp
end


function modifier_item_spell_breaker_passive:OnIntervalThink()
if not IsServer() then return end 
if not self.caster or self.caster:IsNull() then return end
if not self.ability or self.ability:IsNull() then return end
DoDamage(self.damageTable)
end