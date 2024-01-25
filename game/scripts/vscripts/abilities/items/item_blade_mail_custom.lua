LinkLuaModifier("modifier_item_blade_mail_custom", "abilities/items/item_blade_mail_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_blade_mail_custom_reflect", "abilities/items/item_blade_mail_custom", LUA_MODIFIER_MOTION_NONE)

item_blade_mail_custom = class({})

function item_blade_mail_custom:GetIntrinsicModifierName()
	return "modifier_item_blade_mail_custom"
end

function item_blade_mail_custom:OnSpellStart()
if not IsServer() then return end
    self:GetParent():EmitSound("DOTA_Item.BladeMail.Activate")
    self:GetParent():AddNewModifier(self:GetParent(), self, "modifier_item_blade_mail_custom_reflect", {duration = self:GetSpecialValueFor("duration")})
end


modifier_item_blade_mail_custom = class({})

function modifier_item_blade_mail_custom:IsHidden() return true end
function modifier_item_blade_mail_custom:IsPurgable() return false end
function modifier_item_blade_mail_custom:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_item_blade_mail_custom:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_EVENT_ON_TAKEDAMAGE
    }

    return funcs
end


function modifier_item_blade_mail_custom:GetModifierPreAttack_BonusDamage()
    if self:GetAbility() then return self:GetAbility():GetSpecialValueFor("bonus_damage") end
end


function modifier_item_blade_mail_custom:GetModifierPhysicalArmorBonus()
    if self:GetAbility() then return self:GetAbility():GetSpecialValueFor("bonus_armor") end
end


function modifier_item_blade_mail_custom:OnCreated(table)
self.reflect = self:GetAbility():GetSpecialValueFor("passive_reflection_pct")
self.const_reflect = self:GetAbility():GetSpecialValueFor("passive_reflection_constant")
end



function modifier_item_blade_mail_custom:OnTakeDamage(params)
if self ~= self:GetParent():FindAllModifiersByName(self:GetName())[1] then return end
if params.unit ~= self:GetParent() then return end
if not self:GetParent():IsRealHero() then return end
if params.attacker == self:GetParent() then return end
if bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then return end
if params.inflictor then return end
if self:GetParent():HasModifier("modifier_item_blade_mail_custom_reflect") then return end

local target = params.attacker
if params.attacker:IsBuilding() or target:IsMagicImmune() then return end


local damage_return = self.reflect*params.original_damage/100 + self.const_reflect


ApplyDamage({victim = target, attacker = self:GetParent(), damage = damage_return, damage_type = params.damage_type,  damage_flags = DOTA_DAMAGE_FLAG_BYPASSES_BLOCK + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_REFLECTION, ability = self:GetAbility()})

end








modifier_item_blade_mail_custom_reflect = class({})
function modifier_item_blade_mail_custom_reflect:IsHidden() return false end
function modifier_item_blade_mail_custom_reflect:IsPurgable() return false end
function modifier_item_blade_mail_custom_reflect:GetTexture() return "item_blade_mail" end
function modifier_item_blade_mail_custom_reflect:GetEffectName()
return "particles/items_fx/blademail.vpcf" end



function modifier_item_blade_mail_custom_reflect:OnCreated(table)

self.reflect = self:GetAbility():GetSpecialValueFor("active_reflection")/100
self.healing = self:GetAbility():GetSpecialValueFor("active_heal")/100
self.creeps = self:GetAbility():GetSpecialValueFor("active_creeps")/100


end



function modifier_item_blade_mail_custom_reflect:DeclareFunctions()
return
{
    MODIFIER_EVENT_ON_TAKEDAMAGE,
    MODIFIER_PROPERTY_TOOLTIP
}

end


function modifier_item_blade_mail_custom_reflect:OnTakeDamage(params)

if self:GetParent() == params.attacker and not params.unit:IsIllusion() and params.inflictor == self:GetAbility() and params.unit ~= self:GetParent() then 
	local k = 1 
	if params.unit:IsCreep() then 
		k = self.creeps
	end
	self:SetStackCount(self:GetStackCount() + params.damage*self.healing*k)
end


if params.unit ~= self:GetParent() then return end
if params.attacker == self:GetParent() then return end
if bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then return end

local target = params.attacker
if params.attacker:IsBuilding() or target:IsMagicImmune() then return end

if params.attacker:IsRealHero() then 
	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(params.attacker:GetPlayerOwnerID()), 'generic_sound',  {sound = "DOTA_Item.BladeMail.Damage"})
end

local damage_return = self.reflect*params.original_damage
ApplyDamage({victim = target, attacker = self:GetParent(), damage = damage_return, damage_type = params.damage_type,  damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_BYPASSES_BLOCK, ability = self:GetAbility()})

end


function modifier_item_blade_mail_custom_reflect:OnDestroy()
if not IsServer() then return end
if not self:GetParent():IsAlive() then return end
if self:GetStackCount() == 0 then return end
local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_oracle/oracle_false_promise_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
ParticleManager:ReleaseParticleIndex( particle )
my_game:GenericHeal(self:GetParent(), self:GetStackCount(), self:GetAbility())

self:GetParent():EmitSound("Item.BM_heal")
end


function modifier_item_blade_mail_custom_reflect:OnTooltip()
return self:GetStackCount()
end