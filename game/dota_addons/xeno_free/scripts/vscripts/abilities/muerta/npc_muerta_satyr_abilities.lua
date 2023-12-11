LinkLuaModifier("modifier_npc_muerta_satyr_bkb", "abilities/muerta/npc_muerta_satyr_abilities", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_npc_muerta_satyr_passive", "abilities/muerta/npc_muerta_satyr_abilities", LUA_MODIFIER_MOTION_NONE)

npc_muerta_satyr_silence = class({})



function npc_muerta_satyr_silence:OnAbilityPhaseStart()
    self.sign = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_has_quest.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetCaster())
  
    self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_1, 0.7)


    return true
end 


function npc_muerta_satyr_silence:OnAbilityPhaseInterrupted()

ParticleManager:DestroyParticle(self.sign, true)
ParticleManager:ReleaseParticleIndex(self.sign)
self:GetCaster():FadeGesture(ACT_DOTA_CAST_ABILITY_1)
end



function npc_muerta_satyr_silence:OnSpellStart()
if not IsServer() then return end

self:GetCaster():FadeGesture(ACT_DOTA_CAST_ABILITY_1)

ParticleManager:DestroyParticle(self.sign, true)
ParticleManager:ReleaseParticleIndex(self.sign)

self:GetCaster():EmitSound("n_creep_SatyrHellcaller.Shockwave")

local point = self:GetCursorPosition()

if point == self:GetCaster():GetAbsOrigin() then 
    point = self:GetCaster():GetAbsOrigin() + self:GetCaster():GetForwardVector()*10
end

local vec = (point - self:GetCaster():GetAbsOrigin())

local direction = vec:Normalized()

local distance = self:GetSpecialValueFor("range")
local speed = self:GetSpecialValueFor("speed")


local info = {
        EffectName = "particles/neutral_fx/satyr_hellcaller.vpcf",
        Ability = self,
        vSpawnOrigin = self:GetCaster():GetOrigin(), 
        fStartRadius = 70,
        fEndRadius = 200,
        vVelocity = direction * speed,
        fDistance = distance,
        Source = self:GetCaster(),
        bDeleteOnHit = false,
        fExpireTime = GameRules:GetGameTime() + 4,
        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
    }


ProjectileManager:CreateLinearProjectile(info)


end

function npc_muerta_satyr_silence:OnProjectileHit(hTarget, vLocation)
if not IsServer() then return end
if hTarget==nil then return end
if hTarget:IsInvulnerable() then return end
if hTarget:IsMagicImmune() then return end

self.silence = self:GetSpecialValueFor("silence")
self.damage = self:GetSpecialValueFor("damage")

local damage = self.damage*hTarget:GetMaxHealth()/100

SendOverheadEventMessage(hTarget, 4, hTarget, damage, nil)

hTarget:AddNewModifier(self:GetCaster(), self, "modifier_generic_silence", {duration = self.silence*(1 - hTarget:GetStatusResistance())})     
ApplyDamage({victim = hTarget, attacker = self:GetCaster(), damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self})
hTarget:EmitSound("n_creep_SatyrHellcaller.Shockwave.Damage")

end



npc_muerta_satyr_bkb = class({})

function npc_muerta_satyr_bkb:OnSpellStart()
if not IsServer() then return end

self:GetCaster():EmitSound("BS.Bloodrite_purge")

self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_npc_muerta_satyr_bkb", {duration = self:GetSpecialValueFor("duration")})
self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_generic_debuff_immune", {duration = self:GetSpecialValueFor("duration")})
end




modifier_npc_muerta_satyr_bkb = class({})
function modifier_npc_muerta_satyr_bkb:IsHidden() return true end
function modifier_npc_muerta_satyr_bkb:IsPurgable() return false end 
function modifier_npc_muerta_satyr_bkb:GetEffectName() return "particles/items_fx/black_king_bar_avatar.vpcf" end



function modifier_npc_muerta_satyr_bkb:OnCreated(table)
self.heal = self:GetAbility():GetSpecialValueFor("lifesteal")/100
end

function modifier_npc_muerta_satyr_bkb:DeclareFunctions()
return
{
    MODIFIER_EVENT_ON_TAKEDAMAGE
}

end


function modifier_npc_muerta_satyr_bkb:OnTakeDamage( params )
if not IsServer() then return end
if self:GetParent() == params.unit and self:GetParent():IsIllusion() then return end
if bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then return end
if self:GetParent() ~= params.attacker then return end
if params.unit:IsIllusion() then return end

local heal = self.heal*params.damage

self:GetParent():GenericHeal(heal, self:GetAbility())

end






npc_muerta_satyr_passive = class({})

function npc_muerta_satyr_passive:GetIntrinsicModifierName()
return "modifier_npc_muerta_satyr_passive"
end


modifier_npc_muerta_satyr_passive = class({})

function modifier_npc_muerta_satyr_passive:IsHidden() return true end
function modifier_npc_muerta_satyr_passive:IsPurgable() return false end
function modifier_npc_muerta_satyr_passive:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL
}
end

function modifier_npc_muerta_satyr_passive:GetModifierProcAttack_BonusDamage_Magical(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end
if params.target:GetMana() == 0 then return end

local mana = self:GetAbility():GetSpecialValueFor("mana")*params.target:GetMaxMana()/100

params.target:Script_ReduceMana(mana, self:GetAbility()) 

local damage = mana*self:GetAbility():GetSpecialValueFor("damage")

SendOverheadEventMessage(params.target, 4, params.target, damage, nil)
     

params.target:EmitSound("n_creep_SatyrSoulstealer.ManaBurn")

return damage
end