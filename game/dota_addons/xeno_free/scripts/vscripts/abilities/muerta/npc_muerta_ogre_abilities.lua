LinkLuaModifier("modifier_npc_muerta_ogre_hit_slow", "abilities/muerta/npc_muerta_ogre_abilities", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_npc_muerta_ogre_passive", "abilities/muerta/npc_muerta_ogre_abilities", LUA_MODIFIER_MOTION_NONE)



npc_muerta_ogre_hit = class({})




function npc_muerta_ogre_hit:OnAbilityPhaseStart()
    self.sign = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_has_quest.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetCaster())
  

  --  self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_1, 1.1)

    return true
end 


function npc_muerta_ogre_hit:OnAbilityPhaseInterrupted()

ParticleManager:DestroyParticle(self.sign, true)
ParticleManager:ReleaseParticleIndex(self.sign)
--self:GetCaster():FadeGesture(ACT_DOTA_CAST_ABILITY_1)
end


function npc_muerta_ogre_hit:OnSpellStart()
if not IsServer() then return end


ParticleManager:DestroyParticle(self.sign, true)
ParticleManager:ReleaseParticleIndex(self.sign)
--self:GetCaster():FadeGesture(ACT_DOTA_CAST_ABILITY_1)

local point = self:GetCaster():GetAbsOrigin() + self:GetCaster():GetForwardVector()*self:GetSpecialValueFor("range")

local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), point, nil, self:GetSpecialValueFor("aoe"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, 0, 0, false )

EmitSoundOnLocationWithCaster(point, "Hero_Centaur.HoofStomp", self:GetCaster())

local nFXIndex = ParticleManager:CreateParticle( "particles/act_2/ogre_seal_suprise.vpcf", PATTACH_WORLDORIGIN,  self:GetCaster()  )
ParticleManager:SetParticleControl( nFXIndex, 0, point )
ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 50, 50, 50 ) )
ParticleManager:ReleaseParticleIndex( nFXIndex )


for _,unit in pairs(units) do 
    local damage = self:GetSpecialValueFor("damage")*unit:GetMaxHealth()/100

    ApplyDamage({victim = unit, attacker = self:GetCaster(), damage_type = DAMAGE_TYPE_MAGICAL,  damage = damage, ability = self,})

    SendOverheadEventMessage(unit, 4, unit, damage, nil)

    unit:AddNewModifier(self:GetCaster(), self, "modifier_npc_muerta_ogre_hit_slow", {duration = (1 - unit:GetStatusResistance())*self:GetSpecialValueFor("duration")})
   
    local knockbackProperties =
    {
        center_x = unit:GetOrigin().x,
        center_y = unit:GetOrigin().y,
        center_z = unit:GetOrigin().z,
        duration = self:GetSpecialValueFor("stun"),
        knockback_duration = self:GetSpecialValueFor("stun"),
        knockback_distance = 0,
        knockback_height = 70,
        isStun = true,
    }
    unit:AddNewModifier( self:GetCaster(), self, "modifier_knockback", knockbackProperties )
end

end



modifier_npc_muerta_ogre_hit_slow = class({})
function modifier_npc_muerta_ogre_hit_slow:IsHidden() return false end
function modifier_npc_muerta_ogre_hit_slow:IsPurgable() return true end

function modifier_npc_muerta_ogre_hit_slow:OnCreated(table)
self.slow = self:GetAbility():GetSpecialValueFor("slow")
self.heal = self:GetAbility():GetSpecialValueFor("heal")
end

function modifier_npc_muerta_ogre_hit_slow:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
    MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
    MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE
}
end

function modifier_npc_muerta_ogre_hit_slow:GetModifierMoveSpeedBonus_Percentage()
return self.slow
end


function modifier_npc_muerta_ogre_hit_slow:GetModifierLifestealRegenAmplify_Percentage() 
return self.heal
end

function modifier_npc_muerta_ogre_hit_slow:GetModifierHealAmplify_PercentageTarget()
return self.heal
end


function modifier_npc_muerta_ogre_hit_slow:GetModifierHPRegenAmplify_Percentage() 
return self.heal
end



function modifier_npc_muerta_ogre_hit_slow:GetEffectName()
    return "particles/units/heroes/hero_snapfire/hero_snapfire_shotgun_debuff.vpcf"
end

function modifier_npc_muerta_ogre_hit_slow:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_npc_muerta_ogre_hit_slow:GetStatusEffectName()
    return "particles/status_fx/status_effect_snapfire_slow.vpcf"
end

function modifier_npc_muerta_ogre_hit_slow:StatusEffectPriority()
    return MODIFIER_PRIORITY_NORMAL
end











npc_muerta_ogre_jump = class({})




function npc_muerta_ogre_jump:OnAbilityPhaseStart()
    self.sign = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_has_quest.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetCaster())
  
    local particle_cast = "particles/red_zone.vpcf"
    self.effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_CUSTOMORIGIN, self:GetCaster())
    ParticleManager:SetParticleControl( self.effect_cast, 0, self:GetCaster():GetOrigin() )
    ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( self:GetSpecialValueFor("radius"), 0, -self:GetSpecialValueFor("radius")) )
    ParticleManager:SetParticleControl( self.effect_cast, 2, Vector( 1, 0, 0 ) )

  --  self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_1, 1.1)

    return true
end 


function npc_muerta_ogre_jump:OnAbilityPhaseInterrupted()

ParticleManager:DestroyParticle(self.sign, true)
ParticleManager:ReleaseParticleIndex(self.sign)

ParticleManager:DestroyParticle(self.effect_cast, true)
ParticleManager:ReleaseParticleIndex(self.effect_cast)
--self:GetCaster():FadeGesture(ACT_DOTA_CAST_ABILITY_1)
end


function npc_muerta_ogre_jump:OnSpellStart()
if not IsServer() then return end


ParticleManager:DestroyParticle(self.sign, true)
ParticleManager:ReleaseParticleIndex(self.sign)
--self:GetCaster():FadeGesture(ACT_DOTA_CAST_ABILITY_1)

ParticleManager:DestroyParticle(self.effect_cast, true)
ParticleManager:ReleaseParticleIndex(self.effect_cast)

local point = self:GetCaster():GetAbsOrigin()

local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), point, nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, 0, 0, false )

EmitSoundOnLocationWithCaster(point, "Hero_Centaur.HoofStomp", self:GetCaster())

local nFXIndex = ParticleManager:CreateParticle( "particles/act_2/ogre_seal_suprise.vpcf", PATTACH_WORLDORIGIN,  self:GetCaster()  )
ParticleManager:SetParticleControl( nFXIndex, 0, point )
ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 200, 200, 200 ) )
ParticleManager:ReleaseParticleIndex( nFXIndex )


for _,unit in pairs(units) do 
    local damage = self:GetSpecialValueFor("damage")*unit:GetMaxHealth()/100

    ApplyDamage({victim = unit, attacker = self:GetCaster(), damage_type = DAMAGE_TYPE_MAGICAL,  damage = damage, ability = self,})

    SendOverheadEventMessage(unit, 4, unit, damage, nil)

    unit:AddNewModifier(self:GetCaster(), self, "modifier_npc_muerta_ogre_hit_slow", {duration = (1 - unit:GetStatusResistance())*self:GetSpecialValueFor("duration")})
   
    local knockbackProperties =
    {
        center_x = unit:GetOrigin().x,
        center_y = unit:GetOrigin().y,
        center_z = unit:GetOrigin().z,
        duration = self:GetSpecialValueFor("stun"),
        knockback_duration = self:GetSpecialValueFor("stun"),
        knockback_distance = 0,
        knockback_height = 70,
        isStun = true,
    }
    unit:AddNewModifier( self:GetCaster(), self, "modifier_knockback", knockbackProperties )
end

end





npc_muerta_ogre_passive = class({})

function npc_muerta_ogre_passive:GetIntrinsicModifierName()
return "modifier_npc_muerta_ogre_passive"
end

modifier_npc_muerta_ogre_passive = class({})

function modifier_npc_muerta_ogre_passive:IsHidden() return true end
function modifier_npc_muerta_ogre_passive:IsPurgable() return false end
function modifier_npc_muerta_ogre_passive:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
end

function modifier_npc_muerta_ogre_passive:GetModifierMoveSpeedBonus_Percentage()
return self.move*(1 - self:GetParent():GetHealthPercent()/100)
end

function modifier_npc_muerta_ogre_passive:GetModifierAttackSpeedBonus_Constant()
return self.speed*(1 - self:GetParent():GetHealthPercent()/100)
end


function modifier_npc_muerta_ogre_passive:OnCreated(table)
self.move = self:GetAbility():GetSpecialValueFor("move")
self.speed = self:GetAbility():GetSpecialValueFor("speed")
end