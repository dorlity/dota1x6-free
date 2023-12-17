LinkLuaModifier( "modifier_skeleton_king_mortal_strike_custom", "abilities/wraith_king/skeleton_king_mortal_strike.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_skeleton_king_mortal_strike_armor", "abilities/wraith_king/skeleton_king_mortal_strike.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_skeleton_king_mortal_strike_legendary", "abilities/wraith_king/skeleton_king_mortal_strike.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_skeleton_king_mortal_strike_legendary_stack", "abilities/wraith_king/skeleton_king_mortal_strike.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_skeleton_king_mortal_strike_cd", "abilities/wraith_king/skeleton_king_mortal_strike.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_skeleton_king_mortal_strike_stack", "abilities/wraith_king/skeleton_king_mortal_strike.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_skeleton_king_mortal_strike_stack_count", "abilities/wraith_king/skeleton_king_mortal_strike.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_skeleton_king_mortal_strike_scepter", "abilities/wraith_king/skeleton_king_mortal_strike.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_skeleton_king_mortal_strike_bkb", "abilities/wraith_king/skeleton_king_mortal_strike.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_skeleton_king_mortal_strike_bkb_cd", "abilities/wraith_king/skeleton_king_mortal_strike.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_skeleton_king_mortal_strike_slow", "abilities/wraith_king/skeleton_king_mortal_strike.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_skeleton_king_mortal_strike_damage", "abilities/wraith_king/skeleton_king_mortal_strike.lua", LUA_MODIFIER_MOTION_NONE )


skeleton_king_mortal_strike_custom = class({})

skeleton_king_mortal_strike_custom.scepter_duration = 7

skeleton_king_mortal_strike_custom.cd_init = 0
skeleton_king_mortal_strike_custom.cd_inc = 0.5

skeleton_king_mortal_strike_custom.cleave_damage = {0.2, 0.4, 0.6}
skeleton_king_mortal_strike_custom.cleave_range = {40, 60, 80}

skeleton_king_mortal_strike_custom.cleave_slow = -100
skeleton_king_mortal_strike_custom.cleave_slow_duration = 1

skeleton_king_mortal_strike_custom.armor_inc = 3
skeleton_king_mortal_strike_custom.armor_max = 4
skeleton_king_mortal_strike_custom.armor_duration = 7

skeleton_king_mortal_strike_custom.damage_inc = {4, 6, 8}
skeleton_king_mortal_strike_custom.damage_duration = 3
skeleton_king_mortal_strike_custom.damage_max = 6

skeleton_king_mortal_strike_custom.legendary_duration = 8
skeleton_king_mortal_strike_custom.legendary_speed = 50
skeleton_king_mortal_strike_custom.legendary_max = 6
skeleton_king_mortal_strike_custom.legendary_damage = 60
skeleton_king_mortal_strike_custom.legendary_cd = 18
skeleton_king_mortal_strike_custom.legendary_stack_duration = 8
skeleton_king_mortal_strike_custom.legendary_stun = 1

skeleton_king_mortal_strike_custom.stack_duration = 3
skeleton_king_mortal_strike_custom.stack_damage = {0.15, 0.25}




function skeleton_king_mortal_strike_custom:Precache(context)

    
PrecacheResource( "particle", "particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave_gods_strength.vpcf", context )
PrecacheResource( "particle", "particles/lc_attack_buf.vpcf", context )
PrecacheResource( "particle", "particles/status_fx/status_effect_beserkers_call.vpcf", context )
PrecacheResource( "particle", "particles/wk_crit_buf.vpcf", context )
PrecacheResource( "particle", "particles/wk_stack.vpcf", context )
PrecacheResource( "particle", "particles/strike_wk_damage.vpcf", context )

end


function skeleton_king_mortal_strike_custom:GetIntrinsicModifierName()
	return "modifier_skeleton_king_mortal_strike_custom"
end

function  skeleton_king_mortal_strike_custom:GetBehavior()
  if self:GetCaster():HasModifier("modifier_skeleton_strike_legendary") then
    return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING end
 return DOTA_ABILITY_BEHAVIOR_PASSIVE
end


function skeleton_king_mortal_strike_custom:OnSpellStart()
if not IsServer() then return end
if not self:GetCaster():HasModifier("modifier_skeleton_strike_legendary") then return end


self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_skeleton_king_mortal_strike_legendary", {duration = self.legendary_duration})

end


function skeleton_king_mortal_strike_custom:GetCooldown(iLevel)

if self:GetCaster():HasModifier("modifier_skeleton_strike_legendary") then 
    return self.legendary_cd
end

local upgrade_cooldown = 0  
if self:GetCaster():HasModifier("modifier_skeleton_strike_1") then 
    upgrade_cooldown = self.cd_init + self.cd_inc*self:GetCaster():GetUpgradeStack("modifier_skeleton_strike_1")
end

return self.BaseClass.GetCooldown(self, iLevel) - upgrade_cooldown 
end

modifier_skeleton_king_mortal_strike_custom = class({})

function modifier_skeleton_king_mortal_strike_custom:IsHidden() return true end
function modifier_skeleton_king_mortal_strike_custom:IsPurgable() return false end

function modifier_skeleton_king_mortal_strike_custom:GetCritDamage() 
local crit = self:GetAbility():GetSpecialValueFor("crit_mult")
if self:GetParent():HasModifier("modifier_skeleton_king_mortal_strike_legendary_stack") then 
    crit = crit + self:GetAbility().legendary_damage*self:GetParent():GetUpgradeStack("modifier_skeleton_king_mortal_strike_legendary_stack")
end

    return crit
end

function modifier_skeleton_king_mortal_strike_custom:OnCreated(table)
    self.record = nil
end

function modifier_skeleton_king_mortal_strike_custom:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
        MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
        MODIFIER_EVENT_ON_ATTACK_CANCELLED,
        MODIFIER_EVENT_ON_ATTACK_FAIL,
        MODIFIER_EVENT_ON_TAKEDAMAGE,
        MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
    }

    return funcs
end

function modifier_skeleton_king_mortal_strike_custom:GetModifierAttackRangeBonus()
if not self:GetParent():HasModifier("modifier_skeleton_strike_2") then return end  

return self:GetAbility().cleave_range[self:GetCaster():GetUpgradeStack("modifier_skeleton_strike_2")]
end 

function modifier_skeleton_king_mortal_strike_custom:OnTakeDamage(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end
if params.inflictor ~= nil then return end
if self.record == nil then return end
if params.unit:IsBuilding() then return end
if params.original_damage < 0 then return end

if self:GetParent():GetQuest() == "Wraith.Quest_7" and params.unit:IsRealHero() then 
    self:GetParent():UpdateQuest(math.floor(params.damage))
end


if not self:GetParent():HasModifier("modifier_skeleton_strike_4") then return end

local damage = self:GetAbility().stack_damage[self:GetParent():GetUpgradeStack("modifier_skeleton_strike_4")]

damage = math.floor(damage*params.original_damage)
params.unit:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_skeleton_king_mortal_strike_stack", {stack = damage, duration = self:GetAbility().stack_duration})

end





function modifier_skeleton_king_mortal_strike_custom:GetModifierPreAttack_CriticalStrike( params )
local crit = self:GetAbility():GetSpecialValueFor("crit_mult")

if self:GetParent():HasModifier("modifier_skeleton_king_mortal_strike_legendary_stack") then 
    crit = crit + self:GetAbility().legendary_damage*self:GetParent():GetUpgradeStack("modifier_skeleton_king_mortal_strike_legendary_stack")
end

self.record = nil
if not IsServer() then return end
if self:GetParent():HasModifier("modifier_skeleton_king_mortal_strike_legendary") then return end
if self:GetParent():PassivesDisabled() then return end
if self:GetParent():HasModifier("modifier_skeleton_king_mortal_strike_cd") and not self:GetParent():HasModifier("modifier_skeleton_king_mortal_strike_scepter")
 then return end

if self:GetAbility():IsFullyCastable() or self:GetParent():HasModifier("modifier_skeleton_strike_legendary") or self:GetParent():HasModifier("modifier_skeleton_king_mortal_strike_scepter") then
    self:GetParent():RemoveGesture(ACT_DOTA_ATTACK_EVENT)
    self:GetParent():StartGestureWithPlaybackRate(ACT_DOTA_ATTACK_EVENT, self:GetParent():GetAttackSpeed(true))
    self.record = params.record




    return crit
end
 
return 0
end

function modifier_skeleton_king_mortal_strike_custom:GetModifierProcAttack_Feedback( params )
if not IsServer() then return end

if self:GetParent():HasModifier("modifier_skeleton_strike_3") then 
    self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_skeleton_king_mortal_strike_damage", {duration = self:GetAbility().damage_duration})
end

if self.record and self.record == params.record then


    if self:GetCaster():HasModifier("modifier_skeleton_vampiric_legendary") then
        local ability = self:GetParent():FindAbilityByName("skeleton_king_vampiric_aura_custom")

        if ability then 
            ability:CreateSkeleton(params.target:GetAbsOrigin(), params.target, self:GetCaster():GetTalentValue("modifier_skeleton_vampiric_legendary", "duration"), false, true)
        end 
    end

    if self:GetParent():HasModifier("modifier_skeleton_strike_6") and not self:GetParent():HasModifier("modifier_skeleton_king_mortal_strike_bkb_cd")
    and (params.target:IsCreep() or params.target:IsHero()) then   

        local duration = self:GetCaster():GetTalentValue("modifier_skeleton_strike_6", "duration")
        local cd = self:GetCaster():GetTalentValue("modifier_skeleton_strike_6", "cd")

        self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_skeleton_king_mortal_strike_bkb", {duration = duration})
         
        self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_generic_debuff_immune", {effect = 1, duration = duration})
        self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_skeleton_king_mortal_strike_bkb_cd", {duration = cd})
    end 


    if self:GetParent():HasModifier("modifier_skeleton_strike_2") then 
        DoCleaveAttack(self:GetParent(), params.target, self:GetAbility(), params.damage*(self:GetAbility().cleave_damage[self:GetParent():GetUpgradeStack("modifier_skeleton_strike_2")]), 150, 360, 650, "particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave_gods_strength.vpcf")
    end

    if self:GetParent():HasModifier("modifier_skeleton_strike_5") then 
        params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_skeleton_king_mortal_strike_armor", {duration = self:GetAbility().armor_duration})
        self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_skeleton_king_mortal_strike_armor", {duration = self:GetAbility().armor_duration})
   end

    local mod = self:GetParent():FindModifierByName("modifier_skeleton_king_mortal_strike_legendary_stack")
    if mod then 
        if mod:GetStackCount() >= self:GetAbility().legendary_max then 
            params.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_bashed", {duration = (1 - params.target:GetStatusResistance())*self:GetAbility().legendary_stun})
        end
        mod:Destroy()
    end

    self:GetParent():EmitSound("Hero_SkeletonKing.CriticalStrike")
 	

    local cd = self:GetAbility():GetSpecialValueFor("cd")

    if self:GetCaster():HasModifier("modifier_skeleton_strike_1") then 
         cd = cd - (self:GetAbility().cd_init + self:GetAbility().cd_inc*self:GetCaster():GetUpgradeStack("modifier_skeleton_strike_1"))
    end
    cd = cd*self:GetParent():GetCooldownReduction()

    if not self:GetParent():HasModifier("modifier_skeleton_king_mortal_strike_scepter") then 

        if self:GetParent():HasModifier("modifier_skeleton_strike_legendary") then 
            self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_skeleton_king_mortal_strike_cd", {duration = cd})
        else
            self:GetAbility():UseResources(false, false, false, true)
        end
    else 
        local mod = self:GetParent():FindModifierByName("modifier_skeleton_king_mortal_strike_scepter")
        if mod then 
            mod:DecrementStackCount()
            if mod:GetStackCount() == 0 then 
                mod:Destroy()
            end
        end
    end


end


end







modifier_skeleton_king_mortal_strike_armor = class({})
function modifier_skeleton_king_mortal_strike_armor:IsHidden() return false end
function modifier_skeleton_king_mortal_strike_armor:IsPurgable() return false end
function modifier_skeleton_king_mortal_strike_armor:GetTexture() return "buffs/strike_armor" end
function modifier_skeleton_king_mortal_strike_armor:RemoveOnDeath() return false end



function modifier_skeleton_king_mortal_strike_armor:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
if self:GetParent() ~= self:GetCaster() then 
    self.particle_peffect = ParticleManager:CreateParticle("particles/items3_fx/star_emblem.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())   
    ParticleManager:SetParticleControl(self.particle_peffect, 0, self:GetParent():GetAbsOrigin())
    self:AddParticle(self.particle_peffect, false, false, -1, false, true)
end

end



function modifier_skeleton_king_mortal_strike_armor:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self:GetAbility().armor_max then return end

self:IncrementStackCount()
end

function modifier_skeleton_king_mortal_strike_armor:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
}
end



function modifier_skeleton_king_mortal_strike_armor:GetModifierPhysicalArmorBonus()
local k = 1
if self:GetCaster() ~= self:GetParent() then 
    k = -1
end

return self:GetAbility().armor_inc*k*self:GetStackCount()
end





modifier_skeleton_king_mortal_strike_legendary = class({})
function modifier_skeleton_king_mortal_strike_legendary:IsHidden() return false end
function modifier_skeleton_king_mortal_strike_legendary:IsPurgable() return false end
function modifier_skeleton_king_mortal_strike_legendary:GetEffectName() return "particles/lc_attack_buf.vpcf" end
function modifier_skeleton_king_mortal_strike_legendary:GetStatusEffectName() return "particles/status_fx/status_effect_beserkers_call.vpcf" end
function modifier_skeleton_king_mortal_strike_legendary:StatusEffectPriority() return 10 end

function modifier_skeleton_king_mortal_strike_legendary:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    MODIFIER_EVENT_ON_ATTACK_LANDED
}
end

function modifier_skeleton_king_mortal_strike_legendary:OnCreated(table)
if not IsServer() then return end
self.RemoveForDuel = true
self:GetParent():EmitSound("WK.crit_buf")
    self.effect_cast = ParticleManager:CreateParticle( "particles/wk_crit_buf.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
    ParticleManager:SetParticleControl( self.effect_cast, 0, self:GetParent():GetAbsOrigin() )
    ParticleManager:SetParticleControl( self.effect_cast, 1, self:GetParent():GetAbsOrigin() )

    self:AddParticle(self.effect_cast,false, false, -1, false, false)
end


function modifier_skeleton_king_mortal_strike_legendary:GetModifierAttackSpeedBonus_Constant()
return self:GetAbility().legendary_speed
end

function modifier_skeleton_king_mortal_strike_legendary:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end
if not params.target:IsCreep() and not params.target:IsHero() then return end

self:GetParent():EmitSound("WK.crit_hit")
self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_skeleton_king_mortal_strike_legendary_stack", {duration = self:GetAbility().legendary_stack_duration})

end

modifier_skeleton_king_mortal_strike_legendary_stack = class({})
function modifier_skeleton_king_mortal_strike_legendary_stack:IsHidden() return false end
function modifier_skeleton_king_mortal_strike_legendary_stack:IsPurgable() return false end
function modifier_skeleton_king_mortal_strike_legendary_stack:GetTexture() return "buffs/strike_legen_count" end
function modifier_skeleton_king_mortal_strike_legendary_stack:RemoveOnDeath() return false end


function modifier_skeleton_king_mortal_strike_legendary_stack:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
end

function modifier_skeleton_king_mortal_strike_legendary_stack:OnRefresh(table)
if not IsServer() then return end
self:IncrementStackCount()

if self:GetStackCount() >= self:GetAbility().legendary_max then 
    local mod = self:GetParent():FindModifierByName("modifier_skeleton_king_mortal_strike_legendary")
    if mod then 
        mod:Destroy()
    end
end

end


function modifier_skeleton_king_mortal_strike_legendary_stack:CheckState()
if self:GetStackCount() < self:GetAbility().legendary_max then return end
if self:GetParent():PassivesDisabled() then return end
return
{
    [MODIFIER_STATE_CANNOT_MISS] = true
}

end


function modifier_skeleton_king_mortal_strike_legendary_stack:OnStackCountChanged(iStackCount)
if self:GetStackCount() == 0 then return end
if not self.effect_cast then 

    local particle_cast = "particles/wk_stack.vpcf"

    self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
    ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, self:GetStackCount(), 0 ) )

    self:AddParticle(self.effect_cast,false, false, -1, false, false)
else 

  ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, self:GetStackCount(), 0 ) )

end

end



function modifier_skeleton_king_mortal_strike_legendary_stack:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_TOOLTIP
}

end

function modifier_skeleton_king_mortal_strike_legendary_stack:OnTooltip()
local crit = self:GetAbility():GetSpecialValueFor("crit_mult")
if self:GetParent():HasModifier("modifier_skeleton_king_mortal_strike_legendary_stack") then 
    crit = crit + self:GetAbility().legendary_damage*self:GetParent():GetUpgradeStack("modifier_skeleton_king_mortal_strike_legendary_stack")
end

return crit
end



modifier_skeleton_king_mortal_strike_cd = class({})
function modifier_skeleton_king_mortal_strike_cd:IsHidden() return false end
function modifier_skeleton_king_mortal_strike_cd:IsPurgable() return false end
function modifier_skeleton_king_mortal_strike_cd:IsDebuff() return true end


modifier_skeleton_king_mortal_strike_stack = class({})
function modifier_skeleton_king_mortal_strike_stack:IsHidden() return false end
function modifier_skeleton_king_mortal_strike_stack:IsPurgable() return false end
function modifier_skeleton_king_mortal_strike_stack:GetTexture() return "buffs/strike_stack" end

function modifier_skeleton_king_mortal_strike_stack:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_skeleton_king_mortal_strike_stack:OnCreated(table)
if not IsServer() then return end
self.RemoveForDuel = true
self.damage = table.stack

end

function modifier_skeleton_king_mortal_strike_stack:OnDestroy()
if not IsServer() then return end
if not self:GetParent():IsAlive() then return end

local effect_cast = ParticleManager:CreateParticle( "particles/strike_wk_damage.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetAbsOrigin() )
ParticleManager:ReleaseParticleIndex( effect_cast )

self:GetParent():EmitSound("WK.Strike_damage")
    local damage = {
        victim = self:GetParent(),
        attacker = self:GetCaster(),
        damage =  self.damage,
        damage_type = DAMAGE_TYPE_PURE,
        ability = self:GetAbility()
    }
   local real = ApplyDamage( damage )

self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_skeleton_king_mortal_strike_slow", {duration = self:GetAbility().cleave_slow_duration*(1 - self:GetParent():GetStatusResistance())})
       
end 


modifier_skeleton_king_mortal_strike_stack_count = class({})
function modifier_skeleton_king_mortal_strike_stack_count:GetTexture() return "buffs/strike_stack" end

function modifier_skeleton_king_mortal_strike_stack_count:IsHidden() return false end
function modifier_skeleton_king_mortal_strike_stack_count:IsPurgable() return false end

function modifier_skeleton_king_mortal_strike_stack_count:OnCreated(table)
if not IsServer() then return end
self.RemoveForDuel = true
self:SetStackCount(0)
end

function modifier_skeleton_king_mortal_strike_stack_count:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
}
end
function modifier_skeleton_king_mortal_strike_stack_count:GetModifierPreAttack_BonusDamage()
return self:GetStackCount()
end


modifier_skeleton_king_mortal_strike_scepter = class({})
function modifier_skeleton_king_mortal_strike_scepter:IsHidden() return false end
function modifier_skeleton_king_mortal_strike_scepter:IsPurgable() return false end
function modifier_skeleton_king_mortal_strike_scepter:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(table.stack)
end


modifier_skeleton_king_mortal_strike_bkb = class({})
function modifier_skeleton_king_mortal_strike_bkb:IsHidden() return false end
function modifier_skeleton_king_mortal_strike_bkb:IsPurgable() return false end
function modifier_skeleton_king_mortal_strike_bkb:GetTexture() return "buffs/strike_bkb" end


function modifier_skeleton_king_mortal_strike_bkb:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
end
function modifier_skeleton_king_mortal_strike_bkb:GetModifierAttackSpeedBonus_Constant()
return self.speed
end

function modifier_skeleton_king_mortal_strike_bkb:OnCreated()
self.speed = self:GetCaster():GetTalentValue("modifier_skeleton_strike_6", "speed")
end


modifier_skeleton_king_mortal_strike_slow = class({})
function modifier_skeleton_king_mortal_strike_slow:IsHidden() return false end
function modifier_skeleton_king_mortal_strike_slow:IsPurgable() return true end
function modifier_skeleton_king_mortal_strike_slow:GetTexture() return "buffs/strike_slow" end
function modifier_skeleton_king_mortal_strike_slow:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end
function modifier_skeleton_king_mortal_strike_slow:GetModifierMoveSpeedBonus_Percentage()
return self:GetAbility().cleave_slow
end

function modifier_skeleton_king_mortal_strike_slow:GetEffectName()
return "particles/items2_fx/sange_maim.vpcf"
end

modifier_skeleton_king_mortal_strike_damage = class({})
function modifier_skeleton_king_mortal_strike_damage:IsHidden() return false end
function modifier_skeleton_king_mortal_strike_damage:IsPurgable() return false end
function modifier_skeleton_king_mortal_strike_damage:GetTexture() return "buffs/mortal_bash" end
function modifier_skeleton_king_mortal_strike_damage:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
end

function modifier_skeleton_king_mortal_strike_damage:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self:GetAbility().damage_max then return end

self:IncrementStackCount()
end


function modifier_skeleton_king_mortal_strike_damage:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
}
end


function modifier_skeleton_king_mortal_strike_damage:GetModifierPreAttack_BonusDamage()
return self:GetAbility().damage_inc[self:GetCaster():GetUpgradeStack("modifier_skeleton_strike_3")]*self:GetStackCount()
end


modifier_skeleton_king_mortal_strike_bkb_cd = class({})
function modifier_skeleton_king_mortal_strike_bkb_cd:IsHidden() return false end
function modifier_skeleton_king_mortal_strike_bkb_cd:IsPurgable() return false end
function modifier_skeleton_king_mortal_strike_bkb_cd:RemoveOnDeath() return false end
function modifier_skeleton_king_mortal_strike_bkb_cd:IsDebuff() return true end
function modifier_skeleton_king_mortal_strike_bkb_cd:OnCreated(table)
if not IsServer() then return end

self.RemoveForDuel = true
end

function modifier_skeleton_king_mortal_strike_bkb_cd:GetTexture() return "buffs/strike_bkb" end