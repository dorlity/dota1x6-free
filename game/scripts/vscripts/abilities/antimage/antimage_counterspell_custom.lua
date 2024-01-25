LinkLuaModifier( "modifier_antimage_counterspell_custom", "abilities/antimage/antimage_counterspell_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_antimage_counterspell_custom_active", "abilities/antimage/antimage_counterspell_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_antimage_counterspell_custom_legendary_damage", "abilities/antimage/antimage_counterspell_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_antimage_counterspell_custom_heal", "abilities/antimage/antimage_counterspell_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_antimage_counterspell_custom_shard", "abilities/antimage/antimage_counterspell_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_antimage_counterspell_custom_shard_cd", "abilities/antimage/antimage_counterspell_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_antimage_counterspell_custom_aura", "abilities/antimage/antimage_counterspell_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_antimage_counterspell_custom_aura_damage", "abilities/antimage/antimage_counterspell_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_antimage_counterspell_custom_damage", "abilities/antimage/antimage_counterspell_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_antimage_counterspell_custom_slow", "abilities/antimage/antimage_counterspell_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_antimage_counterspell_custom_lowhp", "abilities/antimage/antimage_counterspell_custom", LUA_MODIFIER_MOTION_NONE )

antimage_counterspell_custom = class({})






function antimage_counterspell_custom:Precache(context)

PrecacheResource( "particle", 'particles/am_spell_damage.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_oracle/oracle_false_promise_heal.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_antimage/antimage_counter.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_antimage/antimage_spellshield_reflect.vpcf', context )
PrecacheResource( "particle", 'particles/am_lightning.vpcf', context )
PrecacheResource( "particle", 'particles/void_astral_slow.vpcf', context )
PrecacheResource( "particle", 'particles/antimage/counter_lowhp.vpcf', context )
PrecacheResource( "particle", 'particles/am_no_mana.vpcf', context )

end


function antimage_counterspell_custom:GetCooldown(iLevel)

local bonus = 0


if self:GetCaster():HasModifier("modifier_antimage_counter_5") then  
  bonus = self:GetCaster():GetTalentValue("modifier_antimage_counter_5", "cd")
end

 return self.BaseClass.GetCooldown(self, iLevel) + bonus
 
end


function antimage_counterspell_custom:GetBehavior()

local bonus = 0

if self:GetCaster():HasModifier("modifier_antimage_counter_6") then 
    bonus = DOTA_ABILITY_BEHAVIOR_AUTOCAST
end 

return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_IGNORE_CHANNEL + bonus
end 



function antimage_counterspell_custom:OnSpellStart()
if not IsServer() then return end

local duration = self:GetSpecialValueFor("duration")


if self:GetCaster():HasModifier("modifier_antimage_counter_4") then 
    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_antimage_counterspell_custom_damage", {duration = self:GetCaster():GetTalentValue("modifier_antimage_counter_4", "duration")})
end 

if self:GetCaster():HasModifier("modifier_antimage_counter_3") then 
    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_antimage_counterspell_custom_heal", {duration = self:GetCaster():GetTalentValue("modifier_antimage_counter_3", "duration")})
end

self:GetCaster():EmitSound("Hero_Antimage.Counterspell.Cast")

if self:GetCaster():HasModifier("modifier_antimage_counter_7") then 
    duration = self:GetCaster():GetTalentValue("modifier_antimage_counter_7", "duration")
end

self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_antimage_counterspell_custom_active", {duration = duration + self:GetCaster():GetTalentValue("modifier_antimage_counter_5", "duration")})


end

function antimage_counterspell_custom:GetIntrinsicModifierName()
	return "modifier_antimage_counterspell_custom"
end



modifier_antimage_counterspell_custom = class({})

function modifier_antimage_counterspell_custom:IsHidden() return true end

function modifier_antimage_counterspell_custom:IsPurgable() return false end






function modifier_antimage_counterspell_custom:IsPurgable() return false end

function modifier_antimage_counterspell_custom:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
        MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
        MODIFIER_PROPERTY_ABSORB_SPELL,
	}

	return funcs
end




function modifier_antimage_counterspell_custom:GetAbsorbSpell( params )
if not IsServer() then return end
if not params.ability then return end 
if params.ability:GetCaster():GetTeamNumber() == self:GetParent():GetTeamNumber() then return end


local parent = self:GetParent()

local target = params.ability:GetCaster()

if parent:HasShard() and not parent:HasModifier("modifier_antimage_counterspell_custom_shard_cd") and self:GetParent():IsRealHero() then 

    local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_antimage/antimage_spellshield_reflect.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
    ParticleManager:SetParticleControlEnt( particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )
    ParticleManager:ReleaseParticleIndex( particle )
    self:GetParent():EmitSound("Hero_Antimage.Counterspell.Target")

    parent:AddNewModifier(parent, self:GetAbility(), "modifier_antimage_counterspell_custom_shard_cd", {duration = self:GetAbility():GetSpecialValueFor("shard_cd")})

    local duration = self:GetAbility():GetSpecialValueFor("shard_duration")
    local outgoing_damage = self:GetAbility():GetSpecialValueFor("shard_damage") - 100
    local incoming_damage = self:GetAbility():GetSpecialValueFor("shard_incoming") - 100  

    local illusion = CreateIllusions( parent, parent, {duration=duration,outgoing_damage=outgoing_damage,incoming_damage=incoming_damage}, 1, 0, false, false )  

    for k, v in pairs(illusion) do

        v.owner = parent

        for _,mod in pairs(parent:FindAllModifiers()) do
           if mod.StackOnIllusion ~= nil and mod.StackOnIllusion == true then
              v:UpgradeIllusion(mod:GetName(), mod:GetStackCount() )
           end
        end
          
        FindClearSpaceForUnit(v, target:GetAbsOrigin(), true)

        v:StartGesture(ACT_DOTA_CAST_ABILITY_2)

        v:AddNewModifier(v, self:GetAbility(), "modifier_antimage_counterspell_custom_shard", {})

        Timers:CreateTimer(0.1, function()
            v:SetForceAttackTarget(target)
        end)
    end

end 

if not self:GetParent():HasModifier("modifier_antimage_counter_2") then return end

self:GetParent():EmitSound("Antimage.Counter_slow")

for _,unit in pairs(self:GetParent():FindTargets(self.slow_radius)) do 
  

    local particle = ParticleManager:CreateParticle( "particles/am_lightning.vpcf", PATTACH_POINT_FOLLOW, unit )
    ParticleManager:SetParticleControlEnt( particle, 0, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true )
    ParticleManager:SetParticleControlEnt( particle, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true )
    ParticleManager:ReleaseParticleIndex( particle )

   unit:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_antimage_counterspell_custom_slow", {duration = (1 - unit:GetStatusResistance())*self.slow_duration})
end


return 0
end









function modifier_antimage_counterspell_custom:GetModifierMagicalResistanceBonus( params )
if self:GetParent():PassivesDisabled() then return end
if self:GetParent():IsIllusion() then return end
local bonus = self:GetAbility():GetSpecialValueFor("magic_resistance")


return bonus
end






function modifier_antimage_counterspell_custom:OnCreated()
if not IsServer() then return end

self:GetParent().tOldSpells = {}

self.slow_radius = self:GetCaster():GetTalentValue("modifier_antimage_counter_2", "radius", true)
self.slow_duration = self:GetCaster():GetTalentValue("modifier_antimage_counter_2", "duration", true)

self.lowhp_health = self:GetCaster():GetTalentValue("modifier_antimage_counter_6", "health", true)

self:StartIntervalThink(FrameTime())
end

function modifier_antimage_counterspell_custom:OnIntervalThink()
if not IsServer() then return end
local caster = self:GetParent()
for i=#caster.tOldSpells,1,-1 do
    local hSpell = caster.tOldSpells[i]
    if hSpell:NumModifiersUsingAbility() <= -1 and not hSpell:IsChanneling() then
        hSpell:RemoveSelf()
        table.remove(caster.tOldSpells,i)
    end
end

if not caster:HasModifier("modifier_antimage_counter_6") then return end

if caster:IsAlive() and caster:GetHealthPercent() <= self.lowhp_health and not caster:PassivesDisabled() then 

    if self:GetAbility():IsFullyCastable() and self:GetAbility():GetAutoCastState() == true and not caster:HasModifier("modifier_antimage_counterspell_custom_active") then 
        caster:CastAbilityNoTarget(self:GetAbility(), -1)
    end 

    if not caster:HasModifier("modifier_antimage_counterspell_custom_lowhp") then 
        caster:AddNewModifier(caster, self:GetAbility(), "modifier_antimage_counterspell_custom_lowhp", {})
    end 
else 
    if caster:HasModifier("modifier_antimage_counterspell_custom_lowhp") then 
        caster:RemoveModifierByName("modifier_antimage_counterspell_custom_lowhp")
    end
end 


end















modifier_antimage_counterspell_custom_active = class({})

function modifier_antimage_counterspell_custom_active:IsPurgable()
return not self:GetCaster():HasModifier("modifier_antimage_counter_7")
end


function modifier_antimage_counterspell_custom_active:OnCreated()


self.status = self:GetCaster():GetTalentValue("modifier_antimage_counter_5", "status")

if self:GetParent():HasModifier("modifier_antimage_counter_7") then 
    self.max_shield = self:GetCaster():GetTalentValue("modifier_antimage_counter_7", "shield")*self:GetParent():GetMaxHealth()/100
    self:SetStackCount(self.max_shield)
end


if not IsServer() then return end
self.damage = 0
local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_antimage/antimage_counter.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
ParticleManager:SetParticleControlEnt( particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )
ParticleManager:SetParticleControl(particle, 1, Vector(100,0,0))
self:AddParticle(particle, false, false, -1, false, false)

self.targets = {}

if self:GetParent():HasModifier("modifier_antimage_counter_7") then 
    self:GetAbility():EndCooldown()
    self:GetAbility():SetActivated(false)
end 

end


function modifier_antimage_counterspell_custom_active:OnDestroy()
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_antimage_counter_7") then return end

if self:GetRemainingTime() > 0.1 then 
    local duration = self:GetCaster():GetTalentValue("modifier_antimage_counter_7", "damage_duration")
    local stun = self:GetCaster():GetTalentValue("modifier_antimage_counter_7", "stun")

    local targets = self:GetCaster():FindTargets(self:GetCaster():GetTalentValue("modifier_antimage_counter_7", "radius"))

    local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_antimage/antimage_spellshield_reflect.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
    ParticleManager:SetParticleControlEnt( particle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetOrigin(), true )
    ParticleManager:ReleaseParticleIndex( particle )

    self:GetParent():EmitSound("Hero_Antimage.Counterspell.Target")
    for _,target in pairs(targets) do
        target:EmitSound("Antimage.Break_stun")
        target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_antimage_counterspell_custom_legendary_damage", {duration = duration})
        target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stunned", {duration = (1 - target:GetStatusResistance())*stun})

        local particle = ParticleManager:CreateParticle( "particles/am_lightning.vpcf", PATTACH_POINT_FOLLOW, target )
        ParticleManager:SetParticleControlEnt( particle, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true )
        ParticleManager:SetParticleControlEnt( particle, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true )
        ParticleManager:ReleaseParticleIndex( particle )


        local effect_cast = ParticleManager:CreateParticle( "particles/am_no_mana.vpcf", PATTACH_OVERHEAD_FOLLOW, target )
        ParticleManager:SetParticleControl( effect_cast, 0, target:GetOrigin() )
        ParticleManager:SetParticleControl( effect_cast, 1, target:GetOrigin() )
    end 

end 

self:GetAbility():SetActivated(true)
self:GetAbility():UseResources(false, false, false, true)
end

function modifier_antimage_counterspell_custom_active:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_REFLECT_SPELL,
		MODIFIER_PROPERTY_ABSORB_SPELL,
        MODIFIER_PROPERTY_INCOMING_DAMAGE_CONSTANT,
        MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
	}

	return funcs
end


function modifier_antimage_counterspell_custom_active:GetModifierStatusResistanceStacking()
if self:GetCaster():HasModifier("modifier_antimage_counter_5") then
    return self.status
end 

end




function modifier_antimage_counterspell_custom_active:GetModifierIncomingDamageConstant( params )
if not self:GetParent():HasModifier("modifier_antimage_counter_7") then return end
if params.attacker == self:GetCaster() then return end

if IsClient() then 
    if params.report_max then 
        return self.max_shield
    else  
        return self:GetStackCount()
    end 
end

if not IsServer() then return end

local mod = self:GetParent():FindModifierByName("modifier_antimage_counterspell_custom_damage")

if self:GetStackCount() > params.damage then
    self:SetStackCount(self:GetStackCount() - params.damage)
    local i = params.damage
    if mod then 
        mod:AddStack(i)
    end 
    return -i
else
    
    local i = self:GetStackCount()
    self:SetStackCount(0)
    self:Destroy()
    if mod then 
        mod:AddStack(i)
    end 
    return -i
end

end


















function modifier_antimage_counterspell_custom_active:GetAbsorbSpell( params )
if not IsServer() then return end
if not params.ability:GetCaster() then return end 
if params.ability:GetCaster():GetTeamNumber() == self:GetParent():GetTeamNumber() then return end 

local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_antimage/antimage_spellshield_reflect.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
ParticleManager:SetParticleControlEnt( particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )
ParticleManager:ReleaseParticleIndex( particle )
self:GetParent():EmitSound("Hero_Antimage.SpellShield.Reflect")


return 1

end


local function SpellReflect(parent, params)
local reflected_spell_name = params.ability:GetAbilityName()
local target = params.ability:GetCaster()


local main_ability = parent:FindAbilityByName("antimage_counterspell_custom")


target:EmitSound("Hero_Antimage.Counterspell.Target")
if target:GetTeamNumber() == parent:GetTeamNumber() then
    return nil
end


if parent:GetQuest() == "Anti.Quest_7" and target:IsRealHero() and not parent:QuestCompleted() then
    parent:UpdateQuest(1)
end

if target:HasModifier("modifier_item_lotus_orb_active") then
    return nil
end

if target:HasModifier("modifier_item_mirror_shield") then
    return nil
end


if params.ability.spell_shield_reflect then
    return nil
end

local old_spell = false
for _,hSpell in pairs(parent.tOldSpells) do
    if hSpell ~= nil and hSpell:GetAbilityName() == reflected_spell_name then
        old_spell = true
        break
    end
end
if old_spell then
    ability = parent:FindAbilityByName(reflected_spell_name)
else
    ability = parent:AddAbility(reflected_spell_name)
    ability:SetStolen(true)
    ability:SetHidden(true)
    ability.spell_shield_reflect = true
    ability:SetRefCountsModifiers(true)
    table.insert(parent.tOldSpells, ability)
end
ability:SetLevel(params.ability:GetLevel())
parent:SetCursorCastTarget(target)
ability:OnSpellStart()


local mod = parent:FindModifierByName("modifier_antimage_counterspell_custom_heal")
if mod then 
    --mod:SetStackCount(1)
end 


if ability.OnChannelFinish then
    ability:OnChannelFinish(false)
end

if ability:GetIntrinsicModifierName() ~= nil then
    local modifier_intrinsic = parent:FindModifierByName(ability:GetIntrinsicModifierName())
    if modifier_intrinsic then
        parent:RemoveModifierByName(modifier_intrinsic:GetName())
    end
end

return false
end

function modifier_antimage_counterspell_custom_active:GetReflectSpell( params )
if not IsServer() then return 0 end
if not params.ability:GetCaster() then return end 
if params.ability:GetCaster():GetTeamNumber() == self:GetParent():GetTeamNumber() then return end 
if params.ability:GetCaster():IsCreep() then 

    params.ability:GetCaster():EmitSound("Hero_Antimage.Counterspell.Target")
    return 
end

	return SpellReflect(self:GetParent(), params)
end


modifier_antimage_counterspell_custom_legendary_damage = class({})
function modifier_antimage_counterspell_custom_legendary_damage:IsHidden() return false end
function modifier_antimage_counterspell_custom_legendary_damage:IsPurgable() return true end
function modifier_antimage_counterspell_custom_legendary_damage:GetTexture() return "buffs/counter_block" end
function modifier_antimage_counterspell_custom_legendary_damage:GetEffectName() return "particles/void_astral_slow.vpcf" end

function modifier_antimage_counterspell_custom_legendary_damage:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
}
end

function modifier_antimage_counterspell_custom_legendary_damage:GetModifierIncomingDamage_Percentage()
return self.damage
end

function modifier_antimage_counterspell_custom_legendary_damage:OnCreated(table)
self.damage = self:GetCaster():GetTalentValue("modifier_antimage_counter_7", "damage")

if not IsServer() then return end

self.particle_peffect = ParticleManager:CreateParticle("particles/zeus_resist_stack.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())   
ParticleManager:SetParticleControl(self.particle_peffect, 0, self:GetParent():GetAbsOrigin())
self:AddParticle(self.particle_peffect, false, false, -1, false, true)
end





modifier_antimage_counterspell_custom_heal = class({})
function modifier_antimage_counterspell_custom_heal:IsHidden() return false end
function modifier_antimage_counterspell_custom_heal:IsPurgable() return false end
function modifier_antimage_counterspell_custom_heal:GetTexture() return "buffs/counterspell_heal" end
function modifier_antimage_counterspell_custom_heal:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE
}
end

function modifier_antimage_counterspell_custom_heal:GetModifierHealthRegenPercentage()
local bonus = 1
if self:GetStackCount() > 0 then 
  --  bonus = self.bonus
end 

    return self.heal * bonus
end


function modifier_antimage_counterspell_custom_heal:OnCreated()
self.heal = self:GetCaster():GetTalentValue("modifier_antimage_counter_3", "heal")/self:GetCaster():GetTalentValue("modifier_antimage_counter_3", "duration")
--self.bonus = self:GetCaster():GetTalentValue("modifier_antimage_counter_3", "bonus")
end 

function modifier_antimage_counterspell_custom_heal:GetEffectName() return "particles/units/heroes/hero_oracle/oracle_purifyingflames.vpcf" end

function modifier_antimage_counterspell_custom_heal:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end





modifier_antimage_counterspell_custom_shard = class({})
function modifier_antimage_counterspell_custom_shard:IsHidden() return true end
function modifier_antimage_counterspell_custom_shard:IsPurgable() return false end
function modifier_antimage_counterspell_custom_shard:CheckState()
return
{
    [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
    [MODIFIER_STATE_IGNORING_MOVE_AND_ATTACK_ORDERS] = true,
}

end 

modifier_antimage_counterspell_custom_shard_cd = class({})
function modifier_antimage_counterspell_custom_shard_cd:IsHidden() return true end
function modifier_antimage_counterspell_custom_shard_cd:IsPurgable() return false end
function modifier_antimage_counterspell_custom_shard_cd:RemoveOnDeath() return false end
function modifier_antimage_counterspell_custom_shard_cd:OnCreated()

self.RemoveForDuel = true
end







modifier_antimage_counterspell_custom_aura = class({})

function modifier_antimage_counterspell_custom_aura:IsHidden() return false end
function modifier_antimage_counterspell_custom_aura:IsPurgable() return false end
function modifier_antimage_counterspell_custom_aura:IsDebuff() return false end
function modifier_antimage_counterspell_custom_aura:GetTexture() return "buffs/astral_burn" end
function modifier_antimage_counterspell_custom_aura:RemoveOnDeath() return false end


function modifier_antimage_counterspell_custom_aura:OnCreated()
self.radius = self:GetCaster():GetTalentValue("modifier_antimage_counter_1", "radius", true)
end 

function modifier_antimage_counterspell_custom_aura:GetAuraRadius()
    return self.radius
end

function modifier_antimage_counterspell_custom_aura:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_antimage_counterspell_custom_aura:GetAuraSearchType() 
    return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end


function modifier_antimage_counterspell_custom_aura:GetModifierAura()
    return "modifier_antimage_counterspell_custom_aura_damage"
end

function modifier_antimage_counterspell_custom_aura:IsAura()
    return true
end







modifier_antimage_counterspell_custom_aura_damage = class({})
function modifier_antimage_counterspell_custom_aura_damage:IsHidden() return false end
function modifier_antimage_counterspell_custom_aura_damage:IsPurgable() return false end
function modifier_antimage_counterspell_custom_aura_damage:GetTexture() return "buffs/astral_burn" end

function modifier_antimage_counterspell_custom_aura_damage:OnCreated(table)
self.damage = self:GetCaster():GetTalentValue("modifier_antimage_counter_1", "damage")/100
self.interval = self:GetCaster():GetTalentValue("modifier_antimage_counter_1", "interval")

if not IsServer() then return end
self:StartIntervalThink(self.interval)
end

function modifier_antimage_counterspell_custom_aura_damage:OnIntervalThink()
if not IsServer() then return end
local damage =  self.interval*self:GetParent():GetMaxMana()*self.damage

ApplyDamage({victim = self:GetParent(), attacker = self:GetCaster(), ability = self:GetAbility(), damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
end



function modifier_antimage_counterspell_custom_aura_damage:GetEffectName()
    return "particles/units/heroes/hero_faceless_void/faceless_void_dialatedebuf_2.vpcf"
end

function modifier_antimage_counterspell_custom_aura_damage:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end
function modifier_antimage_counterspell_custom_aura_damage:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_TOOLTIP
}
end


function modifier_antimage_counterspell_custom_aura_damage:OnTooltip()

return self:GetParent():GetMaxMana()*self.damage
end





modifier_antimage_counterspell_custom_damage = class({})
function modifier_antimage_counterspell_custom_damage:IsHidden() return true end
function modifier_antimage_counterspell_custom_damage:IsPurgable() return false end
function modifier_antimage_counterspell_custom_damage:OnCreated()

self.damage = self:GetCaster():GetTalentValue("modifier_antimage_counter_4", "damage")/100
self.heal = self:GetCaster():GetTalentValue("modifier_antimage_counter_4", "heal")/100
self.radius = self:GetCaster():GetTalentValue("modifier_antimage_counter_4", "radius")
if not IsServer() then return end 
self.time = self:GetRemainingTime()

self:StartIntervalThink(0.1)
end



function modifier_antimage_counterspell_custom_damage:OnIntervalThink()
if not IsServer() then return end

CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), 'antimage_counter_damage',  {hide = 0, max_time = self.time, time = self:GetRemainingTime(), damage = self:GetStackCount()})
end 

 

function modifier_antimage_counterspell_custom_damage:DeclareFunctions()
return
{
    MODIFIER_EVENT_ON_TAKEDAMAGE
}
end

function modifier_antimage_counterspell_custom_damage:OnTakeDamage(params)
if not IsServer() then return end 
if params.unit:IsIllusion() then return end
if not params.attacker then return end

if self:GetParent() == params.unit or (self:GetParent() == params.attacker or (params.attacker.owner and params.attacker.owner == self:GetParent())) then 
    self:AddStack(params.damage)
end 

end



function modifier_antimage_counterspell_custom_damage:AddStack(damage)
if not IsServer() then return end 


self:SetStackCount(self:GetStackCount() + damage*self.damage)
end 


function modifier_antimage_counterspell_custom_damage:OnDestroy()
if not IsServer() then return end 

CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), 'antimage_counter_damage',  {hide = 1, max_time = self.time, time = self:GetRemainingTime(), damage = 0})

if not self:GetParent():IsAlive() then return end 
if self:GetStackCount() == 0 then return end

self:GetParent():EmitSound("Antimage.Counterspell_damage")
self:GetParent():EmitSound("Antimage.Counterspell_damage2")

local particle_cast = "particles/am_spell_damage.vpcf"

local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN,  nil)
ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetAbsOrigin() )
ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius/2 , 0, 0 ) )
ParticleManager:ReleaseParticleIndex( effect_cast )

local damage = self:GetStackCount()

for _,unit in pairs(self:GetParent():FindTargets(self.radius)) do  


    unit:EmitSound("Antimage.Counterspell_damage_target")
    local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_antimage/antimage_manabreak_slow.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit)
    ParticleManager:SetParticleControlEnt( particle, 0, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetOrigin(), true )
    ParticleManager:SetParticleControlEnt( particle, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetOrigin(), true )
    ParticleManager:ReleaseParticleIndex(particle)

    ApplyDamage({ victim = unit, attacker = self:GetCaster(), damage = damage, damage_type = DAMAGE_TYPE_PURE, ability = self:GetAbility(), })
end

self:GetParent():GenericHeal(damage*self.heal, self:GetAbility())
end 



modifier_antimage_counterspell_custom_slow = class({})
function modifier_antimage_counterspell_custom_slow:IsHidden() return false end
function modifier_antimage_counterspell_custom_slow:IsPurgable() return true end
function modifier_antimage_counterspell_custom_slow:GetTexture() return "buffs/counterspell_slow" end
function modifier_antimage_counterspell_custom_slow:GetEffectName() return "particles/void_astral_slow.vpcf" end

function modifier_antimage_counterspell_custom_slow:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
}
end

function modifier_antimage_counterspell_custom_slow:GetModifierAttackSpeedBonus_Constant()
return self.slow_attack
end

function modifier_antimage_counterspell_custom_slow:GetModifierMoveSpeedBonus_Percentage()
return self.slow_move
end


function modifier_antimage_counterspell_custom_slow:OnCreated(table)
self.slow_attack = self:GetCaster():GetTalentValue("modifier_antimage_counter_2", "attack")
self.slow_move = self:GetCaster():GetTalentValue("modifier_antimage_counter_2", "slow")
end


modifier_antimage_counterspell_custom_lowhp = class({})

function modifier_antimage_counterspell_custom_lowhp:IsHidden() return false end
function modifier_antimage_counterspell_custom_lowhp:IsPurgable() return false end
function modifier_antimage_counterspell_custom_lowhp:GetTexture() return "buffs/counter_cd" end
function modifier_antimage_counterspell_custom_lowhp:OnCreated()

self.damage = self:GetCaster():GetTalentValue("modifier_antimage_counter_6", "damage_reduce")
if not IsServer() then return end

self:GetParent():EmitSound("Antimage.Counter_heal")

self.particle = ParticleManager:CreateParticle("particles/antimage/counter_lowhp.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent())
ParticleManager:SetParticleControlEnt(self.particle, 0, self:GetParent(), PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(self.particle, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(self.particle, 2, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(self.particle, 5, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
self:AddParticle(self.particle, false, false, -1, false, false)
end 

function modifier_antimage_counterspell_custom_lowhp:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
}
end


function modifier_antimage_counterspell_custom_lowhp:GetModifierIncomingDamage_Percentage(params)
if IsClient() then 
    return self.damage
end 

if params.inflictor then 
    return self.damage
end 

end 