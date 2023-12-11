LinkLuaModifier("modifier_item_celestial_spear_custom", "abilities/items/item_celestial_spear_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_celestial_spear_custom_debuff", "abilities/items/item_celestial_spear_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_celestial_spear_custom_speed", "abilities/items/item_celestial_spear_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_celestial_spear_custom_leash", "abilities/items/item_celestial_spear_custom", LUA_MODIFIER_MOTION_NONE)


item_celestial_spear_custom = class({})

function item_celestial_spear_custom:GetIntrinsicModifierName()
	return "modifier_item_celestial_spear_custom"
end


function item_celestial_spear_custom:OnSpellStart()
if not IsServer() then return end 

local target = self:GetCursorTarget()

local projectile =
{
  Target = target,
  Source = self:GetCaster(),
  Ability = self,
  EffectName = "particles/items/celestial_spear_proj.vpcf",
  iMoveSpeed = self:GetSpecialValueFor("projectile_speed"),
  vSourceLoc = self:GetCaster():GetAbsOrigin(),
  bDodgeable = true,
  bProvidesVision = false,
}

local hProjectile = ProjectileManager:CreateTrackingProjectile( projectile )

self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_item_celestial_spear_custom_speed", {duration = self:GetSpecialValueFor("duration")})
self:GetCaster():EmitSound("Celestial_spear.Cast")

end 



function item_celestial_spear_custom:OnProjectileHit(hTarget, vLocation)
if not hTarget then return end 
if not IsServer() then return end
if hTarget:TriggerSpellAbsorb(self) then return end

local hit_effect = ParticleManager:CreateParticle("particles/econ/items/dragon_knight/dk_persona/dk_persona_dragon_tail_dragon_form_proj_impact.vpcf", PATTACH_CUSTOMORIGIN, hTarget)
ParticleManager:SetParticleControlEnt(hit_effect, 0, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin(), false) 
ParticleManager:SetParticleControlEnt(hit_effect, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin(), false) 
ParticleManager:SetParticleControlEnt(hit_effect, 3, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin(), false) 
ParticleManager:ReleaseParticleIndex(hit_effect)

local hit_effect = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_quad_tap_hit.vpcf", PATTACH_CUSTOMORIGIN, hTarget)
ParticleManager:SetParticleControlEnt(hit_effect, 0, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin(), false) 
ParticleManager:SetParticleControlEnt(hit_effect, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin(), false) 
ParticleManager:ReleaseParticleIndex(hit_effect)


hTarget:EmitSound("Hero_Mars.Spear.Target")
hTarget:EmitSound("Item.StarEmblem.Enemy")

hTarget:AddNewModifier(self:GetCaster(), self, "modifier_item_celestial_spear_custom_debuff", {duration = self:GetSpecialValueFor("duration")})
hTarget:AddNewModifier(self:GetCaster(), self, "modifier_item_celestial_spear_custom_leash", {duration = self:GetSpecialValueFor("leash_duration")*(1 - hTarget:GetStatusResistance())})

end 


modifier_item_celestial_spear_custom = class({})

function modifier_item_celestial_spear_custom:IsHidden() return true end
function modifier_item_celestial_spear_custom:IsPurgable() return false end
function modifier_item_celestial_spear_custom:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_item_celestial_spear_custom:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS, 
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
    }

    return funcs
end


function modifier_item_celestial_spear_custom:GetModifierPhysicalArmorBonus()
    if self:GetAbility() then return self:GetAbility():GetSpecialValueFor("bonus_armor") end
end

function modifier_item_celestial_spear_custom:GetModifierConstantManaRegen()
    if self:GetAbility() then return self:GetAbility():GetSpecialValueFor("bonus_mana_regen_pct") end
end



function modifier_item_celestial_spear_custom:GetModifierBonusStats_Strength()
    if self:GetAbility() then return self:GetAbility():GetSpecialValueFor("bonus_all_stats") end
end


function modifier_item_celestial_spear_custom:GetModifierBonusStats_Agility()
    if self:GetAbility() then return self:GetAbility():GetSpecialValueFor("bonus_all_stats") end
end


function modifier_item_celestial_spear_custom:GetModifierBonusStats_Intellect()
    if self:GetAbility() then return self:GetAbility():GetSpecialValueFor("bonus_all_stats") end
end


function modifier_item_celestial_spear_custom:GetModifierMoveSpeedBonus_Constant()
    if self:GetAbility() then return self:GetAbility():GetSpecialValueFor("self_movement_speed") end
end




modifier_item_celestial_spear_custom_debuff = class({})
function modifier_item_celestial_spear_custom_debuff:IsHidden() return false end
function modifier_item_celestial_spear_custom_debuff:IsPurgable() return true end
function modifier_item_celestial_spear_custom_debuff:IsDebuff() return true end 

function modifier_item_celestial_spear_custom_debuff:OnCreated(table)

self.armor = self:GetAbility():GetSpecialValueFor("target_armor")

self.move = 0 

if self:GetCaster() ~= self:GetParent() then
    self.move = self:GetAbility():GetSpecialValueFor("target_movement_speed")
end 

if not IsServer() then return end

local nFXIndex = ParticleManager:CreateParticle( "particles/items3_fx/star_emblem_caster.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetAbsOrigin(), true )
self:AddParticle( nFXIndex, false, false, -1, false, true )

end

function modifier_item_celestial_spear_custom_debuff:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}

end
function modifier_item_celestial_spear_custom_debuff:GetModifierPhysicalArmorBonus()
return self.armor
end 

function modifier_item_celestial_spear_custom_debuff:GetModifierMoveSpeedBonus_Percentage()
return self.move
end 




modifier_item_celestial_spear_custom_speed = class({})
function modifier_item_celestial_spear_custom_speed:IsHidden() return false end
function modifier_item_celestial_spear_custom_speed:IsPurgable() return false end

function modifier_item_celestial_spear_custom_speed:OnCreated(table)

self.attack = self:GetAbility():GetSpecialValueFor("self_attack_speed") 

end

function modifier_item_celestial_spear_custom_speed:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
}

end

function modifier_item_celestial_spear_custom_speed:GetModifierAttackSpeedBonus_Constant()
return self.attack
end 






modifier_item_celestial_spear_custom_leash = class({})

function modifier_item_celestial_spear_custom_leash:IsHidden() return true end
function modifier_item_celestial_spear_custom_leash:IsPurgable() return false end
function modifier_item_celestial_spear_custom_leash:OnCreated(table)
if not IsServer() then return end

self.center = self:GetParent():GetAbsOrigin() - (self:GetCaster():GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Normalized()*60

self.effect_cast = ParticleManager:CreateParticle( "particles/huskar_disarm_coil.vpcf", PATTACH_WORLDORIGIN, self:GetParent() )
ParticleManager:SetParticleControl( self.effect_cast, 0, self.center )
self:AddParticle(self.effect_cast,false,false,-1,false,false)


self.break_radius = self:GetAbility():GetSpecialValueFor("break_radius")

local effect_cast_2 = ParticleManager:CreateParticle( "particles/items/celestial_spear_leash.vpcf", PATTACH_ABSORIGIN, self:GetParent() )
ParticleManager:SetParticleControl( effect_cast_2, 0, self.center )
ParticleManager:SetParticleControlEnt(effect_cast_2,1,self:GetParent(),PATTACH_POINT_FOLLOW,"attach_hitloc",self:GetParent():GetOrigin(),true)
self:AddParticle(effect_cast_2,false,false,-1,false,false)

self:StartIntervalThink(FrameTime())
end

function modifier_item_celestial_spear_custom_leash:CheckState()
return
{
    [MODIFIER_STATE_TETHERED] = true
}

end 



function modifier_item_celestial_spear_custom_leash:OnIntervalThink()
if not IsServer() then return end 
if (self:GetParent():GetAbsOrigin() - self.center):Length2D() <= self.break_radius then return end 

local direction = self:GetParent():GetOrigin()-self.center
direction.z = 0
direction = direction:Normalized()

local center = self:GetParent():GetAbsOrigin() + direction*10

local knockbackProperties =
{
    center_x = center.x,
    center_y = center.y,
    center_z = center.z,
    duration = 0.2,
    knockback_duration = 0.2,
    knockback_distance = (self:GetParent():GetOrigin()-self.center):Length2D()*0.7,
    knockback_height = 0,
    isStun = true,
}
self:GetParent():AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_knockback", knockbackProperties )

self:GetParent():EmitSound("Celestial_spear.Break")
self:Destroy()
end 
