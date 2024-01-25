LinkLuaModifier( "modifier_skeleton_king_hellfire_blast_custom_debuff", "abilities/wraith_king/skeleton_king_hellfire_blast.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_skeleton_king_hellfire_blast_custom_speed", "abilities/wraith_king/skeleton_king_hellfire_blast.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_skeleton_king_hellfire_blast_custom_illusion", "abilities/wraith_king/skeleton_king_hellfire_blast.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_skeleton_king_hellfire_blast_skelet_buff", "abilities/wraith_king/skeleton_king_hellfire_blast.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_skeleton_king_hellfire_blast_tracker", "abilities/wraith_king/skeleton_king_hellfire_blast.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_skeleton_king_hellfire_blast_custom_damage", "abilities/wraith_king/skeleton_king_hellfire_blast.lua", LUA_MODIFIER_MOTION_NONE )

skeleton_king_hellfire_blast_custom = class({})



skeleton_king_hellfire_blast_custom.slow_heal = 0.25

skeleton_king_hellfire_blast_custom.healing_damage = -30
skeleton_king_hellfire_blast_custom.healing_heal = -50 
skeleton_king_hellfire_blast_custom.healing_duration = 4




function skeleton_king_hellfire_blast_custom:Precache(context)


PrecacheResource( "particle", "particles/units/heroes/hero_skeletonking/skeleton_king_weapon_blur_critical.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_skeletonking/skeleton_king_weapon_blur.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_skeletonking/skeleton_king_weapon_blur_reverse.vpcf", context )

PrecacheResource( "particle", "particles/units/heroes/hero_skeletonking/skeletonking_hellfireblast_warmup.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_skeletonking/skeletonking_hellfireblast.vpcf", context )
PrecacheResource( "particle", "particles/wk_stun_legen.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_skeletonking/skeletonking_hellfireblast_explosion.vpcf", context )
PrecacheResource( "particle", "particles/wk_aoe.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_skeletonking/skeletonking_hellfireblast_debuff.vpcf", context )
PrecacheResource( "particle", "particles/wk_haste.vpcf", context )
PrecacheResource( "particle", "particles/status_fx/status_effect_wraithking_ghosts.vpcf", context )
PrecacheResource( "particle", "particles/jugg_ward_damage.vpcf", context )

my_game:PrecacheShopItems("npc_dota_hero_skeleton_king", context)
end

function skeleton_king_hellfire_blast_custom:GetAbilityTextureName()
    if self:GetCaster():HasModifier("modifier_wraith_king_blistering_shade_custom") then
        return "skeleton_king/blistering_shade/skeleton_king_hellfire_blast"
    end
    if self:GetCaster():HasModifier("modifier_wraith_king_arcana_custom_v1") then
        return "skeleton_king/arcana/skeleton_king_hellfire_blast_arcana"
    end
    if self:GetCaster():HasModifier("modifier_wraith_king_arcana_custom_v2") then
        return "skeleton_king/arcana/skeleton_king_hellfire_blast_arcana_alt"
    end
    return "skeleton_king_hellfire_blast"
end


function skeleton_king_hellfire_blast_custom:GetIntrinsicModifierName()
return "modifier_skeleton_king_hellfire_blast_tracker"
end





function skeleton_king_hellfire_blast_custom:GetCastPoint(iLevel)

local bonus = 0

if self:GetCaster():HasModifier('modifier_skeleton_blast_5') then 
    bonus = self:GetCaster():GetTalentValue("modifier_skeleton_blast_5", "cast")
end

return self.BaseClass.GetCastPoint(self) + bonus
end






function skeleton_king_hellfire_blast_custom:GetCastRange(vLocation, hTarget)
return self.BaseClass.GetCastRange(self , vLocation , hTarget)
end




function skeleton_king_hellfire_blast_custom:GetCooldown(level)
local bonus = 0

if self:GetCaster():HasModifier("modifier_skeleton_blast_5") then 
    bonus = self:GetCaster():GetTalentValue("modifier_skeleton_blast_5", "cd")
end

return self.BaseClass.GetCooldown( self, level ) + bonus
end




function skeleton_king_hellfire_blast_custom:GetManaCost(level)
    return self.BaseClass.GetManaCost(self, level)
end



function skeleton_king_hellfire_blast_custom:OnAbilityPhaseStart()
    local part_name = "particles/units/heroes/hero_skeletonking/skeletonking_hellfireblast_warmup.vpcf"
    if self:GetCaster():HasModifier("modifier_wraith_king_blistering_shade_custom") then
        part_name = "particles/econ/items/wraith_king/wraith_king_ti6_bracer/wraith_king_ti6_hellfireblast_warmup.vpcf"
    end
    local particle = ParticleManager:CreateParticle(part_name, PATTACH_CUSTOMORIGIN_FOLLOW, self:GetCaster())
    ParticleManager:SetParticleControlEnt(particle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack2", self:GetCaster():GetAbsOrigin(), true)
    ParticleManager:ReleaseParticleIndex(particle)
    return true
end

function skeleton_king_hellfire_blast_custom:OnSpellStart(new_target)
if not IsServer() then return end


local target = self:GetCursorTarget()
if new_target ~= nil then 
    target = new_target
end

local proj_name = "particles/units/heroes/hero_skeletonking/skeletonking_hellfireblast.vpcf"
if self:GetCaster():HasModifier("modifier_wraith_king_blistering_shade_custom") then
    proj_name = "particles/econ/items/wraith_king/wraith_king_ti6_bracer/wraith_king_ti6_hellfireblast.vpcf"
elseif self:GetCaster():HasModifier("modifier_wraith_king_arcana_custom_v1") then
    proj_name = "particles/econ/items/wraith_king/wraith_king_arcana/wk_arc_wraithfireblast.vpcf"
elseif self:GetCaster():HasModifier("modifier_wraith_king_arcana_custom_v2") then
    proj_name = "particles/econ/items/wraith_king/wraith_king_arcana/wk_arc_wraithfireblast_style2.vpcf"
end

local info = 
{
    EffectName = proj_name,
    Ability = self,
    iMoveSpeed = self:GetSpecialValueFor("blast_speed"),
    Source = self:GetCaster(),
    Target = target,
    iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2
}
ProjectileManager:CreateTrackingProjectile( info )
self:GetCaster():EmitSound("Hero_SkeletonKing.Hellfire_Blast")

if self:GetCaster():HasModifier("modifier_skeleton_blast_2") then 
    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_skeleton_king_hellfire_blast_custom_speed", {duration = self:GetCaster():GetTalentValue("modifier_skeleton_blast_2", "duration")})
end


local all_skeletons = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), target:GetAbsOrigin(), nil, 2000, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, 0, FIND_CLOSEST, false )
            
for _, skelet in pairs(all_skeletons) do
    
    local mod = skelet:FindModifierByName("modifier_skeleton_king_vampiric_aura_custom_skeleton_ai")

    if mod then
                
        mod:SetTarget(target    )
        skelet:AddNewModifier(self:GetCaster(), self, "modifier_skeleton_king_hellfire_blast_skelet_buff", {duration = self:GetSpecialValueFor("skelet_buff_duration")})
    end
end



end



function skeleton_king_hellfire_blast_custom:UseStun(target)
if not IsServer() then return end


local stun_duration = self:GetSpecialValueFor( "blast_stun_duration" )
local slow_duration = self:GetSpecialValueFor( "blast_dot_duration" )

if self:GetCaster():HasModifier("modifier_skeleton_blast_1") then 
    slow_duration = slow_duration + self:GetCaster():GetTalentValue("modifier_skeleton_blast_1", "duration")
end

if self:GetCaster():HasModifier("modifier_skeleton_blast_4") then 

    stun_duration = stun_duration + self:GetCaster():GetTalentValue("modifier_skeleton_blast_4", "stun")
end


local stun_damage = self:GetAbilityDamage()


if self:GetCaster():HasModifier("modifier_skeleton_blast_3") then 
    stun_damage = stun_damage + self:GetCaster():GetAverageTrueAttackDamage(nil)*self:GetCaster():GetTalentValue("modifier_skeleton_blast_3", "damage_init")/100
end

stun_duration = stun_duration * (1 - target:GetStatusResistance())
 
target:AddNewModifier(self:GetCaster(), self, "modifier_stunned", {duration = stun_duration})

if self:GetCaster():HasModifier("modifier_skeleton_blast_4") then 
    target:AddNewModifier( self:GetCaster(), self, "modifier_skeleton_king_hellfire_blast_custom_damage", { duration = self:GetCaster():GetTalentValue("modifier_skeleton_blast_4", "duration") + stun_duration, delay = stun_duration} )
 
end 

target:AddNewModifier( self:GetCaster(), self, "modifier_skeleton_king_hellfire_blast_custom_debuff", { duration = stun_duration + slow_duration, delay = stun_duration} )
       


local damage = {
    victim = target,
    attacker = self:GetCaster(),
    damage = stun_damage,
    damage_type = DAMAGE_TYPE_MAGICAL,
    ability = self
}
ApplyDamage( damage )



target:EmitSound("Hero_SkeletonKing.Hellfire_BlastImpact")
local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_skeletonking/skeletonking_hellfireblast_explosion.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
ParticleManager:SetParticleControlEnt(particle, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
ParticleManager:ReleaseParticleIndex(particle)




end

function skeleton_king_hellfire_blast_custom:OnProjectileHit( target, vLocation )
if not IsServer() then return end
if not target then return end
if target:IsMagicImmune() then return end
if target:TriggerSpellAbsorb( self ) then return end


if self:GetCaster():HasModifier("modifier_skeleton_vampiric_legendary") then
    local ability = self:GetCaster():FindAbilityByName("skeleton_king_vampiric_aura_custom")

    if ability then

        local duration = self:GetCaster():GetTalentValue("modifier_skeleton_vampiric_legendary", "duration")
        
        for i = 1,self:GetCaster():GetTalentValue("modifier_skeleton_vampiric_legendary", "stun") do 
            ability:CreateSkeleton(target:GetAbsOrigin(), target, duration, false, true)
        end
    end 
end



self:UseStun(target)

local mod = target:FindModifierByName("modifier_skeleton_king_hellfire_blast_custom_illusion")

if mod and mod.target and not mod.target:IsNull() and mod.target:IsAlive() and not mod.target:IsMagicImmune() and not mod.target:IsInvulnerable() then 
    self:UseStun(mod.target)
end

end







modifier_skeleton_king_hellfire_blast_custom_debuff = class({})

function modifier_skeleton_king_hellfire_blast_custom_debuff:IsPurgable() return not self:GetCaster():HasModifier("modifier_skeleton_blast_6")
end
function modifier_skeleton_king_hellfire_blast_custom_debuff:IsPurgeException() return true end

function modifier_skeleton_king_hellfire_blast_custom_debuff:OnCreated( kv )
self.per_damage = self:GetAbility():GetSpecialValueFor( "blast_dot_damage" )
self.move_slow = self:GetAbility():GetSpecialValueFor( "blast_slow" ) + self:GetCaster():GetTalentValue("modifier_skeleton_blast_1", "slow")

self.more_damage = self:GetCaster():GetTalentValue("modifier_skeleton_blast_3","damage_inc")/100

self.heal_reduce = self:GetCaster():GetTalentValue("modifier_skeleton_blast_6", "heal_reduce")
self.damage_reduce = self:GetCaster():GetTalentValue("modifier_skeleton_blast_6", "damage")

if not IsServer() then return end

if self:GetCaster():HasModifier("modifier_skeleton_blast_6") then 

    local particle = ParticleManager:CreateParticle("particles/items4_fx/spirit_vessel_damage.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
    self:AddParticle(particle, false, false, -1, false, false)   
end

local particle_name_debuff = "particles/units/heroes/hero_skeletonking/skeletonking_hellfireblast_debuff.vpcf"
if self:GetCaster():HasModifier("modifier_wraith_king_blistering_shade_custom") then
    particle_name_debuff = "particles/econ/items/wraith_king/wraith_king_ti6_bracer/wraith_king_ti6_hellfireblast_debuff.vpcf"
elseif self:GetCaster():HasModifier("modifier_wraith_king_arcana_custom_v1") then
    particle_name_debuff = "particles/econ/items/wraith_king/wraith_king_arcana/wk_arc_wraithfireblast_debuff.vpcf"
elseif self:GetCaster():HasModifier("modifier_wraith_king_arcana_custom_v2") then
    particle_name_debuff = "particles/econ/items/wraith_king/wraith_king_arcana/wk_arc_wraithfireblast_debuff_style2.vpcf"
end
local debuff_particle = ParticleManager:CreateParticle(particle_name_debuff, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
self:AddParticle(debuff_particle, false, false, -1, false, false)

self.heal = self:GetCaster():GetTalentValue("modifier_skeleton_blast_6", "heal")/100

self.interval = 1

self.count = self:GetAbility():GetSpecialValueFor( "blast_dot_duration" )

if self:GetCaster():HasModifier("modifier_skeleton_blast_1") then 
    self.count = self.count + self:GetCaster():GetTalentValue("modifier_skeleton_blast_1", "duration")
end


self:StartIntervalThink( kv.delay + FrameTime())
end



function modifier_skeleton_king_hellfire_blast_custom_debuff:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_EVENT_ON_TAKEDAMAGE,    
        MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
        MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
        MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
        MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE
    }

    return funcs
end




function modifier_skeleton_king_hellfire_blast_custom_debuff:GetModifierLifestealRegenAmplify_Percentage() 
if not self:GetCaster():HasModifier("modifier_skeleton_blast_6") then return end
    return self.heal_reduce
end
function modifier_skeleton_king_hellfire_blast_custom_debuff:GetModifierHealAmplify_PercentageTarget() 
if not self:GetCaster():HasModifier("modifier_skeleton_blast_6") then return end
    return self.heal_reduce
end

function modifier_skeleton_king_hellfire_blast_custom_debuff:GetModifierHPRegenAmplify_Percentage()
if not self:GetCaster():HasModifier("modifier_skeleton_blast_6") then return end
    return self.heal_reduce
end

function modifier_skeleton_king_hellfire_blast_custom_debuff:GetModifierTotalDamageOutgoing_Percentage()
if not self:GetCaster():HasModifier("modifier_skeleton_blast_6") then return end
    return self.damage_reduce
end


function modifier_skeleton_king_hellfire_blast_custom_debuff:OnTakeDamage(params)
if not IsServer() then return end
if self:GetParent() ~= params.unit then return end

if self:GetCaster():HasModifier("modifier_skeleton_blast_6") and self:GetCaster() == params.attacker 
    and bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) ~= DOTA_DAMAGE_FLAG_REFLECTION  then

    local heal = params.damage*self.heal

    self:GetCaster():GenericHeal(heal, self:GetAbility(), true)
end


end



function modifier_skeleton_king_hellfire_blast_custom_debuff:GetModifierMoveSpeedBonus_Percentage( params )
    return self.move_slow
end



function modifier_skeleton_king_hellfire_blast_custom_debuff:OnIntervalThink()
if not IsServer() then return end
if self.count < 1 then return end 


self.count = self.count - 1

local damage = self.per_damage

if self:GetCaster():HasModifier("modifier_skeleton_blast_3") then 
     damage = damage + self:GetCaster():GetAverageTrueAttackDamage(nil)*self.more_damage
end


local damageTable = {
    attacker = self:GetCaster(),
    damage = damage,
    damage_type = DAMAGE_TYPE_MAGICAL,
    ability = self:GetAbility()
}

damageTable.victim = self:GetParent()

ApplyDamage( damageTable )


self:StartIntervalThink(self.interval)

end



modifier_skeleton_king_hellfire_blast_custom_speed = class({})
function modifier_skeleton_king_hellfire_blast_custom_speed:IsHidden() return false end
function modifier_skeleton_king_hellfire_blast_custom_speed:IsPurgable() return true end
function modifier_skeleton_king_hellfire_blast_custom_speed:GetTexture() return "buffs/blast_speed" end
function modifier_skeleton_king_hellfire_blast_custom_speed:GetEffectName()
 return "particles/wk_haste.vpcf" end





modifier_skeleton_king_hellfire_blast_custom_illusion = class({})
function modifier_skeleton_king_hellfire_blast_custom_illusion:IsHidden() return true end
function modifier_skeleton_king_hellfire_blast_custom_illusion:IsPurgable() return false end

function modifier_skeleton_king_hellfire_blast_custom_illusion:GetStatusEffectName()
    return "particles/status_fx/status_effect_wraithking_ghosts.vpcf"
end
function modifier_skeleton_king_hellfire_blast_custom_illusion:StatusEffectPriority()
 return 99999 end

function modifier_skeleton_king_hellfire_blast_custom_illusion:CheckState()
return
{
    [MODIFIER_STATE_STUNNED] = true,
    [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
    [MODIFIER_STATE_NO_UNIT_COLLISION] = true
}
end

function modifier_skeleton_king_hellfire_blast_custom_illusion:OnCreated(table)
if not IsServer() then return end
self.damage = self:GetAbility():GetSpecialValueFor("damage")/100


self.target = EntIndexToHScript(table.target)

self:GetParent():StartGesture(ACT_DOTA_DISABLED)
end



function modifier_skeleton_king_hellfire_blast_custom_illusion:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
    MODIFIER_PROPERTY_MODEL_SCALE,
    MODIFIER_EVENT_ON_TAKEDAMAGE,
}
end



function modifier_skeleton_king_hellfire_blast_custom_illusion:GetOverrideAnimation()
return ACT_DOTA_DISABLED
end


function modifier_skeleton_king_hellfire_blast_custom_illusion:GetModifierModelScale() 
return 20 
end

function modifier_skeleton_king_hellfire_blast_custom_illusion:OnTakeDamage(params)
if not IsServer() then return end
if params.attacker ~= self:GetCaster() then return end
if not self.target then return end
if self.target:IsNull() then return end
if not self.target:IsAlive() then return end
if self:GetParent() ~= params.unit then return end
if params.original_damage < 0 then return end

self.target:EmitSound("WK.Stun_legendary_damage")

local damage = {
    victim = self.target,
    attacker = params.attacker,
    damage = params.original_damage*self.damage,
    damage_type = DAMAGE_TYPE_MAGICAL,
    ability = self:GetAbility()
}
ApplyDamage( damage )

local particle = ParticleManager:CreateParticle("particles/jugg_ward_damage.vpcf", PATTACH_POINT_FOLLOW, self:GetParent())
ParticleManager:SetParticleControlEnt(particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(particle, 1, self.target, PATTACH_POINT_FOLLOW, "attach_hitloc", self.target:GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(particle, 2, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
ParticleManager:ReleaseParticleIndex(particle)


end





modifier_skeleton_king_hellfire_blast_skelet_buff = class({})
function modifier_skeleton_king_hellfire_blast_skelet_buff:IsHidden() return false end
function modifier_skeleton_king_hellfire_blast_skelet_buff:IsPurgable() return false end
function modifier_skeleton_king_hellfire_blast_skelet_buff:OnCreated(table)
self.speed = self:GetAbility():GetSpecialValueFor("skelet_buff_speed")
self.move = self:GetAbility():GetSpecialValueFor("skelet_buff_move")

end

function modifier_skeleton_king_hellfire_blast_skelet_buff:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
end


function modifier_skeleton_king_hellfire_blast_skelet_buff:GetModifierMoveSpeedBonus_Constant()
return self.move
end

function modifier_skeleton_king_hellfire_blast_skelet_buff:GetModifierAttackSpeedBonus_Constant()
return self.speed
end








skeleton_king_hellfire_blast_custom_legendary = class({})



function skeleton_king_hellfire_blast_custom_legendary:OnAbilityPhaseStart()
    local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_skeletonking/skeletonking_hellfireblast_warmup.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self:GetCaster())
    ParticleManager:SetParticleControlEnt(particle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack2", self:GetCaster():GetAbsOrigin(), true)
    ParticleManager:ReleaseParticleIndex(particle)
    return true
end

function skeleton_king_hellfire_blast_custom_legendary:OnSpellStart(new_target)
if not IsServer() then return end

local target = self:GetCursorTarget()
if new_target ~= nil then 
     target = new_target
end

self:GetCaster():EmitSound("WK.Stun_legendary")
self:GetCaster():EmitSound("WK.Stun_legendary2")


local vector = (self:GetCaster():GetAbsOrigin() - target:GetAbsOrigin()):Normalized()

local illusion = CreateUnitByName(target:GetUnitName(), self:GetCaster():GetAbsOrigin() + self:GetCaster():GetForwardVector()*200, false, target, target, target:GetTeamNumber())
            
local particle = ParticleManager:CreateParticle("particles/wk_stun_legen.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
ParticleManager:SetParticleControl(particle, 0, target:GetAbsOrigin())
ParticleManager:SetParticleControl(particle, 1, illusion:GetAbsOrigin())
ParticleManager:ReleaseParticleIndex(particle)
            

FindClearSpaceForUnit(illusion, illusion:GetAbsOrigin(), false) 
illusion:AddNewModifier(self:GetCaster(), self, "modifier_kill", {duration = self:GetSpecialValueFor("duration")})

illusion:AddNewModifier(self:GetCaster(), self, "modifier_chaos_knight_phantasm_illusion", {})

illusion:AddNewModifier(self:GetCaster(), self, "modifier_skeleton_king_hellfire_blast_custom_illusion", {duration = self:GetSpecialValueFor("duration"), target = target:entindex()})
        
illusion:AddNewModifier(self:GetCaster(), self, "modifier_illusion", {outgoing_damage = 0, incoming_damage = 0, duration = self:GetSpecialValueFor("duration")})
illusion.owner = self:GetCaster()   


if target:IsHero() then 

    for i = 1,target:GetLevel() - 1 do 
        illusion:HeroLevelUp(false)
    end


    for itemSlot=0,5 do

        local itemName = target:GetItemInSlot(itemSlot)
        if itemName then 
            local newItem = CreateItem(itemName:GetName(), illusion, illusion)

            illusion:AddItem(newItem)
        end
    end


    for _,modifier in pairs(target:FindAllModifiers()) do 

        if modifier.StackOnIllusion ~= nil and modifier.StackOnIllusion == true then
            local mod = illusion:AddNewModifier(illusion, nil, modifier:GetName(), {})
            mod:SetStackCount(modifier:GetStackCount())
            illusion:CalculateStatBonus(true)
         end
    end
end


illusion:MakeIllusion()
      
end



modifier_skeleton_king_hellfire_blast_tracker = class({})
function modifier_skeleton_king_hellfire_blast_tracker:IsHidden() return true end
function modifier_skeleton_king_hellfire_blast_tracker:IsPurgable() return false end
function modifier_skeleton_king_hellfire_blast_tracker:OnCreated()
self.bonus = self:GetCaster():GetTalentValue("modifier_skeleton_blast_2", "bonus", true)

end




function modifier_skeleton_king_hellfire_blast_tracker:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
    MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING,
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
end

function modifier_skeleton_king_hellfire_blast_tracker:GetModifierCastRangeBonusStacking()
if not self:GetCaster():HasModifier("modifier_skeleton_blast_5") then return end 


return self:GetCaster():GetTalentValue("modifier_skeleton_blast_5", "range")
end


function modifier_skeleton_king_hellfire_blast_tracker:GetModifierAttackSpeedBonus_Constant()
if not self:GetCaster():HasModifier("modifier_skeleton_blast_2") then return end 

local bonus = self:GetCaster():GetTalentValue("modifier_skeleton_blast_2", "speed") 
if self:GetCaster():HasModifier("modifier_skeleton_king_hellfire_blast_custom_speed") then 
    bonus = bonus*self.bonus
end

return bonus
end

function modifier_skeleton_king_hellfire_blast_tracker:GetModifierMoveSpeedBonus_Constant()

if not self:GetCaster():HasModifier("modifier_skeleton_blast_2") then return end 

local bonus = self:GetCaster():GetTalentValue("modifier_skeleton_blast_2", "move") 
if self:GetCaster():HasModifier("modifier_skeleton_king_hellfire_blast_custom_speed") then 
    bonus = bonus*self.bonus
end

return bonus
end



modifier_skeleton_king_hellfire_blast_custom_damage = class({})
function modifier_skeleton_king_hellfire_blast_custom_damage:IsHidden() return true end
function modifier_skeleton_king_hellfire_blast_custom_damage:IsPurgable() return false end
function modifier_skeleton_king_hellfire_blast_custom_damage:OnCreated(kv)
if not IsServer() then return end 


self.count = self:GetCaster():GetTalentValue("modifier_skeleton_blast_4", "duration") + 1
self.radius = self:GetCaster():GetTalentValue("modifier_skeleton_blast_4", "radius")
self.damage_count = self:GetCaster():GetTalentValue("modifier_skeleton_blast_4", "damage")/100
self.aoe_damage = self:GetCaster():GetTalentValue("modifier_skeleton_blast_4", "aoe_damage")/100
self.damage = 0
self.damage_tick = 0

self.interval = 1 - FrameTime()

self:SetStackCount(0)

self:StartIntervalThink(kv.delay - FrameTime())
end 


function modifier_skeleton_king_hellfire_blast_custom_damage:OnIntervalThink()
if not IsServer() then return end 
if self.damage == 0 then return end 
if self.count < 1 then return end 

if self:GetStackCount() == 0 then 

    self.damage_tick = self.damage/self.count
    self:SetStackCount(1)

end


self.count = self.count - 1


local damage = {
    victim = self:GetParent(),
    attacker = self:GetCaster(),
    damage = self.damage_tick,
    damage_type = DAMAGE_TYPE_MAGICAL,
    ability = self:GetAbility()
}
local real_damage = ApplyDamage( damage )

self:GetParent():SendNumber(4, real_damage)

self:GetParent():EmitSound("WK.Stun_burn")

self.effect_target = ParticleManager:CreateParticle( "particles/wk_aoe.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
ParticleManager:SetParticleControl( self.effect_target, 0, self:GetParent():GetAbsOrigin() )

local enemies  = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, 0, FIND_CLOSEST, false )

for _,enemy in pairs(enemies) do 
    if enemy ~= self:GetParent() then 

        local damage = {
            victim = enemy,
            attacker = self:GetCaster(),
            damage = self.damage_tick*self.aoe_damage,
            damage_type = DAMAGE_TYPE_MAGICAL,
            ability = self:GetAbility()
        }
        ApplyDamage(damage)
    end
end

self:StartIntervalThink(self.interval)
end 


function modifier_skeleton_king_hellfire_blast_custom_damage:DeclareFunctions()
return
{
    MODIFIER_EVENT_ON_TAKEDAMAGE
}
end


function modifier_skeleton_king_hellfire_blast_custom_damage:OnTakeDamage(params)
if not IsServer() then return end 
if self:GetStackCount() == 1 then return end 
if params.attacker ~= self:GetCaster() then return end 
if params.unit ~= self:GetParent() then return end 

self.damage = self.damage + self.damage_count*params.damage
end

