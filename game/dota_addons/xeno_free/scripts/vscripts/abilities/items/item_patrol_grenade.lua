LinkLuaModifier("modifier_item_patrol_grenade_heal", "abilities/items/item_patrol_grenade", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_patrol_grenade_damage", "abilities/items/item_patrol_grenade", LUA_MODIFIER_MOTION_NONE)


item_patrol_grenade = class({})

function item_patrol_grenade:OnSpellStart()
if not IsServer() then return end

self:GetCaster():EmitSound("Item.Paintball.Cast")


local info = {
                 Target = self:GetCursorTarget(),
                 Source = self:GetCaster(),
                 Ability = self, 
                 EffectName = "particles/items2_fx/paintball.vpcf",
                 iMoveSpeed = 900,
                 bReplaceExisting = false,                         
                 bProvidesVision = true,                           
                 iVisionRadius = 30,        
                 iVisionTeamNumber = self:GetCaster():GetTeamNumber()      
                  }
              ProjectileManager:CreateTrackingProjectile(info)



end


function item_patrol_grenade:OnProjectileHit(hTarget, vLocation)
if not IsServer() then return end

  if hTarget==nil then return end
  if hTarget:IsInvulnerable() then return end
  if hTarget:TriggerSpellAbsorb( self ) then return end
  if hTarget:IsMagicImmune() then return end



if hTarget:GetTeamNumber() == self:GetCaster():GetTeamNumber() then 
	hTarget:AddNewModifier(self:GetCaster(), self, "modifier_item_patrol_grenade_heal", {duration = self:GetSpecialValueFor("heal_duration")})
else 
  hTarget:AddNewModifier(self:GetCaster(), self, "modifier_item_patrol_grenade_damage", {duration = self:GetSpecialValueFor("damage_duration")})

end

hTarget:EmitSound("Item.Paintball.Target")
my_game:ChangeGrenadeCount(self:GetCaster(), -1)
self:SpendCharge()
end








modifier_item_patrol_grenade_damage = class({})
function modifier_item_patrol_grenade_damage:IsHidden() return false end
function modifier_item_patrol_grenade_damage:IsPurgable() return false end

function modifier_item_patrol_grenade_damage:GetEffectName()
    return "particles/items4_fx/meteor_hammer_spell_debuff.vpcf"
end



function modifier_item_patrol_grenade_damage:OnCreated(table)
if not IsServer() then return end
self.heal = self:GetAbility():GetSpecialValueFor("heal")
self.ability = self:GetAbility()

self.damage = self:GetAbility():GetSpecialValueFor("damage")
if self:GetParent():GetUnitName() ~= "npc_towerradiant" and self:GetParent():GetUnitName() ~= "npc_towerdire" then 
  self.damage = self:GetAbility():GetSpecialValueFor("damage_shrine")
end

self.damage = (self.damage/100)*self:GetParent():GetMaxHealth() / (self:GetRemainingTime() + 1)

self:OnIntervalThink()
self:StartIntervalThink(1)
self:SetHasCustomTransmitterData(true)
end



function modifier_item_patrol_grenade_damage:OnIntervalThink()
if not IsServer() then return end

ApplyDamage({victim = self:GetParent(), attacker = self:GetCaster(), damage = self.damage, damage_type = DAMAGE_TYPE_PURE, ability = self.ability, damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION})

SendOverheadEventMessage(self:GetParent(), 4, self:GetParent(), self.damage, nil)

end







modifier_item_patrol_grenade_heal = class({})
function modifier_item_patrol_grenade_heal:IsHidden() return false end
function modifier_item_patrol_grenade_heal:IsPurgable() return false end
function modifier_item_patrol_grenade_heal:OnCreated(table)
if not IsServer() then return end
self.heal = self:GetAbility():GetSpecialValueFor("heal")

if self:GetParent():GetUnitName() ~= "npc_towerradiant" and self:GetParent():GetUnitName() ~= "npc_towerdire" then 
	self.heal = self:GetAbility():GetSpecialValueFor("heal_shrine")
end

self.heal = (self.heal*self:GetParent():GetMaxHealth()/100)/self:GetRemainingTime()


self:OnIntervalThink()
self:StartIntervalThink(1)
self:SetHasCustomTransmitterData(true)
end


function modifier_item_patrol_grenade_heal:AddCustomTransmitterData() return 
{
heal = self.heal,
} 
end

function modifier_item_patrol_grenade_heal:HandleCustomTransmitterData(data)

self.heal = data.heal
end


function modifier_item_patrol_grenade_heal:OnIntervalThink()
if not IsServer() then return end

local particle = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
ParticleManager:ReleaseParticleIndex( particle )

SendOverheadEventMessage(self:GetParent(), 10, self:GetParent(), self.heal, nil)

end


function modifier_item_patrol_grenade_heal:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
	MODIFIER_EVENT_ON_TAKEDAMAGE
}
end


function modifier_item_patrol_grenade_heal:GetModifierConstantHealthRegen()
return self.heal
end


function modifier_item_patrol_grenade_heal:OnTakeDamage(params)
if not IsServer() then return end
if self:GetParent() ~= params.unit then return end

self:Destroy()
end