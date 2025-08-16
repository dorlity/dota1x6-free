modifier_drow_ranger_ti9_immortal_weapon_custom = class({})
function modifier_drow_ranger_ti9_immortal_weapon_custom:IsHidden() return true end
function modifier_drow_ranger_ti9_immortal_weapon_custom:IsPurgable() return false end
function modifier_drow_ranger_ti9_immortal_weapon_custom:IsPurgeException() return false end
function modifier_drow_ranger_ti9_immortal_weapon_custom:RemoveOnDeath() return false end
function modifier_drow_ranger_ti9_immortal_weapon_custom:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_PROJECTILE_NAME
    }
end
function modifier_drow_ranger_ti9_immortal_weapon_custom:GetModifierProjectileName()
if not self:GetParent():HasModifier("modifier_drow_ranger_wave_of_silence_custom_legendary_illusion") then 
    return "particles/econ/items/drow/drow_ti9_immortal/drow_ti9_base_attack.vpcf"
end

end