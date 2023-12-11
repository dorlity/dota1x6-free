LinkLuaModifier( "modifier_antimage_counterspell_custom", "abilities/antimage/antimage_counterspell_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_antimage_counterspell_custom_active", "abilities/antimage/antimage_counterspell_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_antimage_counterspell_custom_slow", "abilities/antimage/antimage_counterspell_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_antimage_counterspell_custom_heal", "abilities/antimage/antimage_counterspell_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_antimage_counterspell_custom_heal_cd", "abilities/antimage/antimage_counterspell_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_antimage_counterspell_custom_heal_damage", "abilities/antimage/antimage_counterspell_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_antimage_counterspell_custom_shard", "abilities/antimage/antimage_counterspell_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_antimage_counterspell_custom_shard_cd", "abilities/antimage/antimage_counterspell_custom", LUA_MODIFIER_MOTION_NONE )

antimage_counterspell_custom = class({})


antimage_counterspell_custom.shard_mana = 0.8
antimage_counterspell_custom.shard_regen = 1

antimage_counterspell_custom.magic_return = {0.08, 0.12, 0.16}
antimage_counterspell_custom.magic_return_range = 1000

antimage_counterspell_custom.slow_aoe = 500
antimage_counterspell_custom.slow_duration = 3
antimage_counterspell_custom.slow_damage = {8, 12, 16}
antimage_counterspell_custom.slow_move = {-15, -20, -25}

antimage_counterspell_custom.legendary_duration = 3.5
antimage_counterspell_custom.legendary_resist = 40
antimage_counterspell_custom.legendary_shield = 0.3

antimage_counterspell_custom.heal = {6,9,12}
antimage_counterspell_custom.heal_duration = 4

antimage_counterspell_custom.proc_aoe = 300
antimage_counterspell_custom.proc_damage = {0.08, 0.14}
antimage_counterspell_custom.proc_cd = {-0.5, -1}

antimage_counterspell_custom.save_health = 0.2
antimage_counterspell_custom.save_cd = 40
antimage_counterspell_custom.save_damage = -50
antimage_counterspell_custom.save_duration = 2

antimage_counterspell_custom.block_damage = 0.1
antimage_counterspell_custom.block_stun = 1.2
antimage_counterspell_custom.block_max = 2





function antimage_counterspell_custom:Precache(context)

PrecacheResource( "particle", 'particles/am_spell_damage.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_oracle/oracle_false_promise_heal.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_antimage/antimage_counter.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_antimage/antimage_spellshield_reflect.vpcf', context )
PrecacheResource( "particle", 'particles/am_lightning.vpcf', context )
PrecacheResource( "particle", 'particles/void_astral_slow.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_vengeful/vengeful_swap_buff_overhead.vpcf', context )
PrecacheResource( "particle", 'particles/am_no_mana.vpcf', context )

end


function antimage_counterspell_custom:GetCooldown(iLevel)

local bonus = 0


if self:GetCaster():HasModifier("modifier_antimage_counter_4") then  
  bonus = self.proc_cd[self:GetCaster():GetUpgradeStack("modifier_antimage_counter_4")]
end

 return self.BaseClass.GetCooldown(self, iLevel) + bonus
 
end




function antimage_counterspell_custom:ProcDamage()
if not IsServer() then return end


local particle_cast = "particles/am_spell_damage.vpcf"

local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN,  nil)
ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetAbsOrigin() )
ParticleManager:SetParticleControl( effect_cast, 1, Vector( 150 , 0, 0 ) )
ParticleManager:ReleaseParticleIndex( effect_cast )

--if test then 
   
--end

--local particle_start = ParticleManager:CreateParticle( "particles/antimage_blink_blast.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
--ParticleManager:SetParticleControl( particle_start, 0, self:GetCaster():GetAbsOrigin() )
--ParticleManager:SetParticleControl( particle_start, 1, Vector(self.proc_aoe,0,0) )
--ParticleManager:ReleaseParticleIndex( particle_start )

local damage = self.proc_damage[self:GetCaster():GetUpgradeStack("modifier_antimage_counter_4")]*self:GetCaster():GetMaxMana()

local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self.proc_aoe, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, 0, false )
   
for _,unit in pairs(units) do  
    ApplyDamage({ victim = unit, attacker = self:GetCaster(), damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self, })

end


end



function antimage_counterspell_custom:OnSpellStart()
if not IsServer() then return end

local duration = self:GetSpecialValueFor("duration")

if self:GetCaster():HasModifier("modifier_antimage_counter_4") then 
    local ability = self:GetCaster():FindAbilityByName("antimage_counterspell_custom")
    if ability then 
        ability:ProcDamage()
    end
end


if test then 
 --   my_game:FindDuelPairs()
   -- local array = {{"npc_dota_hero_abaddon", "npc_dota_hero_alchemist"}, {"npc_dota_hero_axe", "npc_dota_hero_juggernaut"},{"npc_dota_hero_lina", "npc_dota_hero_antimage"}}
  --  CustomGameEventManager:Send_ServerToAllClients( "DuelAlert", {array = array} )

    --my_game:FindDuelPairs()
  -- self:GetCaster():AddNewModifier(self:GetCaster(), nil, "modifier_target", {duration = 99999})
end 


if self:GetCaster():HasModifier("modifier_antimage_counter_3") then 
    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_antimage_counterspell_custom_heal", {duration = self.heal_duration})
end

self:GetCaster():EmitSound("Hero_Antimage.Counterspell.Cast")
--    self:GetCaster():StartGesture(ACT_DOTA_CAST_ABILITY_3)

if self:GetCaster():HasModifier("modifier_antimage_counter_7") then 
    duration = self.legendary_duration
end

self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_antimage_counterspell_custom_active", {duration = duration})


end

function antimage_counterspell_custom:GetIntrinsicModifierName()
	return "modifier_antimage_counterspell_custom"
end



modifier_antimage_counterspell_custom = class({})

function modifier_antimage_counterspell_custom:GetTexture() return "buffs/sunder_amplify" end

function modifier_antimage_counterspell_custom:IsHidden() 

local show = true

if false and self:GetParent():GetMana()/self:GetParent():GetMaxMana() > self:GetAbility().shard_mana then 
    show = false
end
return show



end


function modifier_antimage_counterspell_custom:OnCreated(table)
if not IsServer() then return end
self.sound_k = 1

end


function modifier_antimage_counterspell_custom:IsPurgable() return false end

function modifier_antimage_counterspell_custom:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
        MODIFIER_EVENT_ON_TAKEDAMAGE,
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

local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self:GetAbility().slow_aoe, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, 0, false )
self:GetParent():EmitSound("Antimage.Counter_slow")

for _,unit in pairs(units) do 
  

    local particle = ParticleManager:CreateParticle( "particles/am_lightning.vpcf", PATTACH_POINT_FOLLOW, unit )
    ParticleManager:SetParticleControlEnt( particle, 0, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true )
    ParticleManager:SetParticleControlEnt( particle, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true )
    ParticleManager:ReleaseParticleIndex( particle )

   unit:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_antimage_counterspell_custom_slow", {duration = (1 - unit:GetStatusResistance())*self:GetAbility().slow_duration})
end

return 0
end




function modifier_antimage_counterspell_custom:GetModifierHealthRegenPercentage()
if not false then return end
if self:GetParent():GetMana()/self:GetParent():GetMaxMana() < self:GetAbility().shard_mana then return end

return self:GetAbility().shard_regen
end


function modifier_antimage_counterspell_custom:OnTakeDamage(params)
if not IsServer() then return end
if self:GetParent() ~= params.unit then return end
if self:GetParent():HasModifier("modifier_death") then return end

if self:GetParent():HasModifier("modifier_antimage_counter_1") and bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) ~= DOTA_DAMAGE_FLAG_REFLECTION
    and params.inflictor and (self:GetParent():GetAbsOrigin() - params.attacker:GetAbsOrigin()):Length2D() <= self:GetAbility().magic_return_range then 

    local damage = self:GetAbility().magic_return[self:GetParent():GetUpgradeStack("modifier_antimage_counter_1")]*params.original_damage

    ApplyDamage({victim = params.attacker, attacker = self:GetParent(), damage = damage, damage_type = DAMAGE_TYPE_PURE, damage_flags = DOTA_DAMAGE_FLAG_REFLECTION,  ability = self:GetAbility()})
end





if not self:GetParent():HasModifier("modifier_antimage_counter_6") then return end
if not params.inflictor then return end
if self:GetParent():GetHealth() > 1 then return end
if self:GetParent():HasModifier("modifier_antimage_counterspell_custom_heal_cd") then return end
if self:GetParent():PassivesDisabled() then return end

self:GetParent():SetHealth(1)
self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_antimage_counterspell_custom_heal_cd", {duration = self:GetAbility().save_cd})
self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_antimage_counterspell_custom_heal_damage", {duration = self:GetAbility().save_duration})

self:GetParent():EmitSound("Antimage.Counter_heal")

local heal = self:GetParent():GetMaxHealth()*self:GetAbility().save_health
self:GetParent():Heal(heal, self:GetAbility())



local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_oracle/oracle_false_promise_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
ParticleManager:ReleaseParticleIndex( particle )
end


function modifier_antimage_counterspell_custom:GetModifierMagicalResistanceBonus( params )
if self:GetParent():PassivesDisabled() then return end
if self:GetParent():IsIllusion() then return end
local bonus = self:GetAbility():GetSpecialValueFor("magic_resistance")


return bonus
end






function modifier_antimage_counterspell_custom:OnCreated()
    if IsServer() then
        self:GetParent().tOldSpells = {}
        self:StartIntervalThink(FrameTime())
    end
end

function modifier_antimage_counterspell_custom:OnIntervalThink()
    if IsServer() then
        local caster = self:GetParent()
        for i=#caster.tOldSpells,1,-1 do
            local hSpell = caster.tOldSpells[i]
            if hSpell:NumModifiersUsingAbility() <= -1 and not hSpell:IsChanneling() then
                hSpell:RemoveSelf()
                table.remove(caster.tOldSpells,i)
            end
        end
    end
end















modifier_antimage_counterspell_custom_active = class({})

function modifier_antimage_counterspell_custom_active:OnCreated()

if self:GetParent():HasModifier("modifier_antimage_counter_7") then 
    self.max_shield = self:GetAbility().legendary_shield*self:GetParent():GetMaxMana()
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

self:GetAbility():SetActivated(true)
self:GetAbility():UseResources(false, false, false, true)
end

function modifier_antimage_counterspell_custom_active:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_REFLECT_SPELL,
		MODIFIER_PROPERTY_ABSORB_SPELL,
        MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_PROPERTY_INCOMING_DAMAGE_CONSTANT,
	}

	return funcs
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

if self:GetStackCount() > params.damage then
    self:SetStackCount(self:GetStackCount() - params.damage)
    local i = params.damage
    return -i
else
    
    local i = self:GetStackCount()
    self:SetStackCount(0)
    self:Destroy()
    return -i
end

end


function modifier_antimage_counterspell_custom_active:OnAttackLanded(params)
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_antimage_counter_5") then return end
if not params.attacker:IsCreep() and not params.attacker:IsHero() then return end 
if self:GetParent() ~= params.target then return end
if self.targets[params.attacker] and self.targets[params.attacker] > self:GetAbility().block_max then return end

if not self.targets[params.attacker] then 
    self.targets[params.attacker] = 0
end

self.targets[params.attacker] = self.targets[params.attacker] + 1


if self.targets[params.attacker] == self:GetAbility().block_max then 

    params.attacker:EmitSound("Antimage.Break_stun")

    local effect_cast = ParticleManager:CreateParticle( "particles/am_no_mana.vpcf", PATTACH_OVERHEAD_FOLLOW, params.attacker )
    ParticleManager:SetParticleControl( effect_cast, 0, params.attacker:GetOrigin() )
    ParticleManager:SetParticleControl( effect_cast, 1, params.attacker:GetOrigin() )

    params.attacker:AddNewModifier(params.attacker, self:GetAbility(), "modifier_stunned", {duration = (1 - params.attacker:GetStatusResistance())*self:GetAbility().block_stun})



    local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_antimage/antimage_spellshield_reflect.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
    ParticleManager:SetParticleControlEnt( particle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetOrigin(), true )
    ParticleManager:ReleaseParticleIndex( particle )

    local damage = self:GetCaster():GetMaxMana()*self:GetAbility().block_damage

    ApplyDamage({ victim = params.attacker, attacker = self:GetCaster(), damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self:GetAbility(),})

    self:GetCaster():EmitSound("Antimage.Block_" .. tostring(RandomInt(1, 3)))


    SendOverheadEventMessage(params.attacker, 4, params.attacker, damage, nil)



end

end




function modifier_antimage_counterspell_custom_active:GetModifierStatusResistanceStacking()
if self:GetParent():HasModifier("modifier_antimage_counter_7") then
    return self:GetAbility().legendary_resist
end
return
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

    if parent:HasModifier("modifier_antimage_counter_4") then 
        local ability = parent:FindAbilityByName("antimage_counterspell_custom")
        if ability then 
            ability:ProcDamage()
        end
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


modifier_antimage_counterspell_custom_slow = class({})
function modifier_antimage_counterspell_custom_slow:IsHidden() return false end
function modifier_antimage_counterspell_custom_slow:IsPurgable() return true end
function modifier_antimage_counterspell_custom_slow:GetTexture() return "buffs/counterspell_slow" end
function modifier_antimage_counterspell_custom_slow:GetEffectName() return "particles/void_astral_slow.vpcf" end

function modifier_antimage_counterspell_custom_slow:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
}
end

function modifier_antimage_counterspell_custom_slow:GetModifierIncomingDamage_Percentage()
return self:GetAbility().slow_damage[self:GetCaster():GetUpgradeStack("modifier_antimage_counter_2")]
end

function modifier_antimage_counterspell_custom_slow:GetModifierMoveSpeedBonus_Percentage()
return self:GetAbility().slow_move[self:GetCaster():GetUpgradeStack("modifier_antimage_counter_2")]
end


function modifier_antimage_counterspell_custom_slow:OnCreated(table)
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
    return self:GetAbility().heal[self:GetCaster():GetUpgradeStack("modifier_antimage_counter_3")]/self:GetAbility().heal_duration
end



function modifier_antimage_counterspell_custom_heal:GetEffectName() return "particles/units/heroes/hero_oracle/oracle_purifyingflames.vpcf" end

function modifier_antimage_counterspell_custom_heal:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

modifier_antimage_counterspell_custom_heal_cd = class({})
function modifier_antimage_counterspell_custom_heal_cd:IsHidden() return false end
function modifier_antimage_counterspell_custom_heal_cd:IsPurgable() return false end
function modifier_antimage_counterspell_custom_heal_cd:GetTexture() return "buffs/counter_cd" end
function modifier_antimage_counterspell_custom_heal_cd:IsDebuff() return true end
function modifier_antimage_counterspell_custom_heal_cd:RemoveOnDeath() return false end
function modifier_antimage_counterspell_custom_heal_cd:OnCreated(table)
if not IsServer() then return end
self.RemoveForDuel = true 
end


modifier_antimage_counterspell_custom_heal_damage = class({})
function modifier_antimage_counterspell_custom_heal_damage:IsHidden() return false end
function modifier_antimage_counterspell_custom_heal_damage:IsPurgable() return false end
function modifier_antimage_counterspell_custom_heal_damage:GetTexture() return "buffs/counter_cd" end
function modifier_antimage_counterspell_custom_heal_damage:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
}
end


function modifier_antimage_counterspell_custom_heal_damage:OnCreated(table)
if not IsServer() then return end

self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_vengeful/vengeful_swap_buff_overhead.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent())
ParticleManager:SetParticleControlEnt(self.particle, 0, self:GetParent(), PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(self.particle, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(self.particle, 5, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
self:AddParticle(self.particle, false, false, -1, false, false)

end


function modifier_antimage_counterspell_custom_heal_damage:GetModifierIncomingDamage_Percentage()
 return self:GetAbility().save_damage
end




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