LinkLuaModifier("modifier_item_butterfly_custom", "abilities/items/item_butterfly_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_butterfly_custom_speed", "abilities/items/item_butterfly_custom", LUA_MODIFIER_MOTION_NONE)

item_butterfly_custom = class({})

function item_butterfly_custom:GetIntrinsicModifierName()
	return "modifier_item_butterfly_custom"
end

function item_butterfly_custom:OnSpellStart()
if not IsServer() then return end
self:GetParent():EmitSound("Juggernaut.Omni_cd")
self:GetParent():AddNewModifier(self:GetParent(), self, "modifier_item_butterfly_custom_speed", {duration = self:GetSpecialValueFor("duration")})


local pfx = ParticleManager:CreateParticle("particles/items2_fx/butterfly_active.vpcf", PATTACH_POINT, self:GetCaster())
ParticleManager:SetParticleControlEnt(pfx, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(pfx, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
ParticleManager:ReleaseParticleIndex(pfx)

end


modifier_item_butterfly_custom = class({})

function modifier_item_butterfly_custom:IsHidden() return true end
function modifier_item_butterfly_custom:IsPurgable() return false end
function modifier_item_butterfly_custom:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_item_butterfly_custom:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_EVASION_CONSTANT

    }

    return funcs
end



function modifier_item_butterfly_custom:GetModifierBonusStats_Agility()
    if self:GetAbility() then return self:GetAbility():GetSpecialValueFor("bonus_agility") end
end
function modifier_item_butterfly_custom:GetModifierPreAttack_BonusDamage()
    if self:GetAbility() then return self:GetAbility():GetSpecialValueFor("bonus_damage") end
end
function modifier_item_butterfly_custom:GetModifierAttackSpeedBonus_Constant()
    if self:GetAbility() then return self:GetAbility():GetSpecialValueFor("bonus_speed")*self:GetParent():GetAgility()/100 
    end
end

function modifier_item_butterfly_custom:GetModifierEvasion_Constant()
    if self:GetAbility() then return self:GetAbility():GetSpecialValueFor("bonus_evasion") end
end




modifier_item_butterfly_custom_speed = class({})
function modifier_item_butterfly_custom_speed:IsHidden() return false end
function modifier_item_butterfly_custom_speed:IsPurgable() return true end
function modifier_item_butterfly_custom_speed:GetEffectName() 
  return "particles/units/heroes/hero_morphling/morphling_morph_agi.vpcf" 
end


function modifier_item_butterfly_custom_speed:OnCreated(table)

self.chance = self:GetAbility():GetSpecialValueFor("active_chance")

if not IsServer() then return end

self.particle = ParticleManager:CreateParticle( "particles/items3_fx/blink_swift_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
self:AddParticle(self.particle, false, false, -1, false, false)


end


function modifier_item_butterfly_custom_speed:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK,
}

end


function modifier_item_butterfly_custom_speed:GetStatusEffectName()
  return "particles/butterfly_status.vpcf" 
end

function modifier_item_butterfly_custom_speed:StatusEffectPriority()
  return 99999
end


function modifier_item_butterfly_custom_speed:GetModifierTotal_ConstantBlock(params)
if not IsServer() then return end
if params.target ~= self:GetParent() then return end
if params.inflictor then return end

local chance = self.chance

local random = RollPseudoRandomPercentage(chance,769,self:GetParent())

if not random then return end

self:GetParent():EmitSound("Hero_FacelessVoid.TimeDilation.Target") 

local trail_pfx = ParticleManager:CreateParticle("particles/butterfly_proc.vpcf", PATTACH_ABSORIGIN, self:GetParent())
ParticleManager:ReleaseParticleIndex(trail_pfx)

return params.damage

end



