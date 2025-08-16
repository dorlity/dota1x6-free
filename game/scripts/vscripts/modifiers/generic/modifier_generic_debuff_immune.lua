
modifier_generic_debuff_immune = class({})

function modifier_generic_debuff_immune:IsHidden() return true end
function modifier_generic_debuff_immune:GetTexture() return "buffs/press_root" end
function modifier_generic_debuff_immune:IsPurgable() return false end 
function modifier_generic_debuff_immune:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_generic_debuff_immune:CheckState()
    return {
        [MODIFIER_STATE_DEBUFF_IMMUNE] = true
    }
end




function modifier_generic_debuff_immune:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
    }
end



function modifier_generic_debuff_immune:GetModifierIncomingDamage_Percentage(params)
if not IsServer() then return end
if self ~= self.parent:FindAllModifiersByName(self:GetName())[1] then return end
if not params.attacker then return end
if not params.inflictor then return end

if bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION and params.inflictor:GetName() ~= "abaddon_borrowed_time_custom_legendary" then 
	return -100 
end

local behavior = params.inflictor:GetAbilityTargetFlags()

local muerta_ulti = params.attacker:FindAbilityByName("muerta_pierce_the_veil_custom")

local bonus = 0
local gunslinger = (params.inflictor:GetName() == "muerta_gunslinger_custom" and params.attacker:HasModifier("modifier_muerta_pierce_the_veil_custom"))


if muerta_ulti and (params.inflictor == muerta_ulti or gunslinger) then 
    bonus = muerta_ulti:GetSpecialValueFor("bkb_damage")
end 


if bit.band(behavior, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES) == 0 
    or gunslinger then

    if params.damage_type == DAMAGE_TYPE_MAGICAL then 
        return self.magic_damage + bonus
    end

    if params.damage_type == DAMAGE_TYPE_PURE then 
        return -100
    end
end

end


function modifier_generic_debuff_immune:GetModifierMagicalResistanceBonus()
if not IsClient() then return end

return self.magic_damage * -1
end


function modifier_generic_debuff_immune:OnCreated(table)
if not IsServer() then return end

self.parent = self:GetParent()
self.RemoveForDuel = true

if table.effect then
    local effect 
    if table.effect == 1 then 
       effect = "particles/items_fx/black_king_bar_avatar.vpcf"
    elseif table.effect == 2 then
        effect = "particles/items5_fx/minotaur_horn.vpcf"
    end 
    self.parent:GenericParticle(effect, self)
end

self.magic_damage = -60

if (table.magic_damage and table.magic_damage < self.magic_damage) or table.magic_damage == 0 then 
    self.magic_damage = table.magic_damage
end

if self.magic_damage > 0 then 
	self.magic_damage = self.magic_damage * -1
end

self:SetHasCustomTransmitterData(true)
end

function modifier_generic_debuff_immune:AddCustomTransmitterData() return 
{
magic_damage = self.magic_damage,
} 
end

function modifier_generic_debuff_immune:HandleCustomTransmitterData(data)
self.magic_damage  = data.magic_damage
end