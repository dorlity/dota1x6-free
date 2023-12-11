LinkLuaModifier("modifier_item_corrosion_custom", "abilities/items/item_corrosion_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_corrosion_custom_active_slow", "abilities/items/item_corrosion_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_corrosion_custom_passive_slow", "abilities/items/item_corrosion_custom", LUA_MODIFIER_MOTION_NONE)

item_corrosion_custom = class({})

function item_corrosion_custom:GetIntrinsicModifierName()
return "modifier_item_corrosion_custom"
end

function item_corrosion_custom:OnSpellStart()
if not IsServer() then return end

self:GetCaster():EmitSound("Item.Paintball.Cast")

for _,mod in pairs(self:GetCaster():FindAllModifiers()) do 
  print(mod:GetName())
end

local info = {
                 Target = self:GetCursorTarget(),
                 Source = self:GetCaster(),
                 Ability = self, 
                 EffectName = "particles/corrosion_custom.vpcf",
                 iMoveSpeed = 900,
                 bReplaceExisting = false,                         
                 bProvidesVision = true,                           
                 iVisionRadius = 30,        
                 iVisionTeamNumber = self:GetCaster():GetTeamNumber()      
                  }
              ProjectileManager:CreateTrackingProjectile(info)



end


function item_corrosion_custom:OnProjectileHit(hTarget, vLocation)
if not IsServer() then return end
if hTarget==nil then return end
if hTarget:IsInvulnerable() then return end
if hTarget:IsMagicImmune() then return end

hTarget:AddNewModifier(self:GetCaster(), self, "modifier_item_corrosion_custom_active_slow", {duration = self:GetSpecialValueFor("duration")})
hTarget:EmitSound("Item.Paintball.Target")
hTarget:EmitSound("Hero_Dazzle.Poison_Touch")

end



modifier_item_corrosion_custom_active_slow = class({})
function modifier_item_corrosion_custom_active_slow:IsHidden() return false end
function modifier_item_corrosion_custom_active_slow:IsPurgable() return true end
function modifier_item_corrosion_custom_active_slow:GetStatusEffectName()
return "particles/status_fx/status_effect_poison_dazzle.vpcf"
end 

function modifier_item_corrosion_custom_active_slow:GetEffectName()
return "particles/units/heroes/hero_dazzle/dazzle_poison_debuff.vpcf"
end 


function modifier_item_corrosion_custom_active_slow:StatusEffectPriority()
return 10000
end

function modifier_item_corrosion_custom_active_slow:OnCreated(table)
self.max_slow = self:GetAbility():GetSpecialValueFor("max_slow")
self.tick = self.max_slow/self:GetRemainingTime()
self.damage = self:GetAbility():GetSpecialValueFor("total_damage")/(self:GetAbility():GetSpecialValueFor("duration") + 1)
self.damageTable = { attacker = self:GetCaster(), victim = self:GetParent(), damage = self.damage, damage_type = DAMAGE_TYPE_PHYSICAL, ability = self:GetAbility() }


if not IsServer() then return end
self:OnIntervalThink()
self:StartIntervalThink(1)
end

function modifier_item_corrosion_custom_active_slow:OnIntervalThink()

ApplyDamage(self.damageTable)
SendOverheadEventMessage(self:GetParent(), 4, self:GetParent(), self.damage, nil)
self:IncrementStackCount()
end


function modifier_item_corrosion_custom_active_slow:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end


function modifier_item_corrosion_custom_active_slow:GetModifierMoveSpeedBonus_Percentage()
return self.tick*self:GetStackCount()
end



modifier_item_corrosion_custom_passive_slow = class({})
function modifier_item_corrosion_custom_passive_slow:IsHidden() return false end
function modifier_item_corrosion_custom_passive_slow:IsPurgable() return true end
function modifier_item_corrosion_custom_passive_slow:OnCreated(table)
self.slow = self:GetAbility():GetSpecialValueFor("melee_slow")
if self:GetCaster():IsRangedAttacker() then 
  self.slow = self:GetAbility():GetSpecialValueFor("ranged_slow")
end

self.armor = self:GetAbility():GetSpecialValueFor("armor") 
self.damage = self:GetAbility():GetSpecialValueFor("damage")
self.damageTable = { attacker = self:GetCaster(), victim = self:GetParent(), damage = self:GetAbility():GetSpecialValueFor("damage"), damage_type = DAMAGE_TYPE_MAGICAL, ability = self:GetAbility() }


if not IsServer() then return end
self:StartIntervalThink(1)
end

function modifier_item_corrosion_custom_passive_slow:OnRefresh(table)
self.slow = self:GetAbility():GetSpecialValueFor("melee_slow")
if self:GetCaster():IsRangedAttacker() then 
  self.slow = self:GetAbility():GetSpecialValueFor("ranged_slow")
end


end

function modifier_item_corrosion_custom_passive_slow:OnIntervalThink()
if not IsServer() then return end
ApplyDamage(self.damageTable)
SendOverheadEventMessage(self:GetParent(), 4, self:GetParent(), self.damage, nil)
end


function modifier_item_corrosion_custom_passive_slow:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
  MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
}
end


function modifier_item_corrosion_custom_passive_slow:GetModifierMoveSpeedBonus_Percentage()
return self.slow
end


function modifier_item_corrosion_custom_passive_slow:GetModifierPhysicalArmorBonus()
return self.armor
end







modifier_item_corrosion_custom = class({})
function modifier_item_corrosion_custom:IsHidden() return true end
function modifier_item_corrosion_custom:IsPurgable() return false end
function modifier_item_corrosion_custom:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_HEALTH_BONUS,
  MODIFIER_EVENT_ON_ATTACK_LANDED
}
end

function modifier_item_corrosion_custom:GetModifierHealthBonus()
if self:GetAbility() then 
  return self:GetAbility():GetSpecialValueFor("health_bonus")
end

end


function modifier_item_corrosion_custom:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end
if not params.target:IsHero() and not params.target:IsCreep() then return end
if params.target:IsMagicImmune() then return end
if self:GetParent():HasModifier("modifier_item_blight_stone") then return end
if self:GetParent():HasModifier("modifier_item_orb_of_venom") then return end

params.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_corrosion_custom_passive_slow", {duration = self:GetAbility():GetSpecialValueFor("duration_passive")})

end


