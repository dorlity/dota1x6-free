LinkLuaModifier("modifier_invoker_deafening_blast_custom", "abilities/invoker/invoker_invoke_custom",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_invoker_invoke_custom_legendary", "abilities/invoker/invoker_invoke_custom",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_invoker_invoke_custom_shield", "abilities/invoker/invoker_invoke_custom",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_invoker_invoke_custom_legendary_tracker", "abilities/invoker/invoker_invoke_custom",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_invoker_invoke_custom_legendary_stacks", "abilities/invoker/invoker_invoke_custom",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_invoker_invoke_custom_legendary_illusion", "abilities/invoker/invoker_invoke_custom",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_invoker_invoke_custom_tracker", "abilities/invoker/invoker_invoke_custom",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_invoker_invoke_custom_move", "abilities/invoker/invoker_invoke_custom",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_invoker_deafening_blast_custom_cd", "abilities/invoker/invoker_invoke_custom",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_invoker_invoke_custom_scepter", "abilities/invoker/invoker_invoke_custom",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_invoker_invoke_custom_scepter_cd", "abilities/invoker/invoker_invoke_custom",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_invoker_invoke_custom_cast", "abilities/invoker/invoker_invoke_custom",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_invoker_invoke_custom_cast_count", "abilities/invoker/invoker_invoke_custom",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_invoker_invoke_custom_exort_damage", "abilities/invoker/invoker_invoke_custom",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_invoker_invoke_custom_blast_thinker", "abilities/invoker/invoker_invoke_custom",LUA_MODIFIER_MOTION_NONE )

invoker_invoke_custom = class({})



function invoker_invoke_custom:CreateTalent()
local caster = self:GetCaster()

for i = 0, 20 do
    local current_item = caster:GetItemInSlot(i)
    if current_item then   
        if current_item:IsActiveNeutral() or i == 17 then
            caster:RemoveItem(current_item)
        end
    end
end

caster:EmitSound("Invoker.Book_sound")
local item = CreateItem("item_invoker_custom_legendary", caster, caster)
caster:AddItem(item)

CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(caster:GetPlayerOwnerID()), 'invoker_hide_neutral', {} ) 
end


function invoker_invoke_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end

PrecacheResource( "particle", "particles/maiden_shield_active.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_invoker/invoker_invoke.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_invoker/invoker_deafening_blast.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_invoker/invoker_deafening_blast_knockback_debuff.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_invoker/invoker_deafening_blast_disarm_debuff.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_invoker/invoker_deafening_blast.vpcf", context )

PrecacheResource( "particle", "particles/units/heroes/hero_invoker/invoker_deafening_blast_knockback_debuff.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_invoker/invoker_deafening_blast_disarm_debuff.vpcf", context )
PrecacheResource( "particle", "particles/invoker/item_speed.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_dark_seer/dark_seer_surge.vpcf", context )
PrecacheResource( "particle", "particles/invoker/invoke_legendary_clock.vpcf", context )
PrecacheResource( "particle", "particles/econ/items/faceless_void/faceless_void_bracers_of_aeons/fv_bracers_of_aeons_dialatedebuf.vpcf", context )
PrecacheResource( "particle", "particles/troll_warlord/refresh_ranged.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_weaver/weaver_timelapse.vpcf", context )
PrecacheResource( "particle", "particles/huskar_timer.vpcf", context )
PrecacheResource( "particle", "particles/invoker/invoker_scepter.vpcf", context )

dota1x6:PrecacheShopItems("npc_dota_hero_invoker", context)
end

function invoker_invoke_custom:ProcsMagicStick()
    return false
end


function invoker_invoke_custom:GetIntrinsicModifierName()
if not self:GetCaster():IsRealHero() then return end
return "modifier_invoker_invoke_custom_tracker"
end 


orb_manager = {}
ability_manager = {}
orb_manager.orb_order = "qwe"

orb_manager.invoke_list = {
    ["qqq"] = "invoker_cold_snap_custom",
    ["qqw"] = "invoker_ghost_walk_custom",
    ["qqe"] = "invoker_ice_wall_custom",
    ["www"] = "invoker_emp_custom",
    ["qww"] = "invoker_tornado_custom",
    ["wwe"] = "invoker_alacrity_custom",
    ["eee"] = "invoker_sun_strike_custom",
    ["qee"] = "invoker_forge_spirit_custom",
    ["wee"] = "invoker_chaos_meteor_custom",
    ["qwe"] = "invoker_deafening_blast_custom",
}

orb_manager.modifier_list = {
    ["q"] = "modifier_invoker_quas_custom",
    ["w"] = "modifier_invoker_wex_custom",
    ["e"] = "modifier_invoker_exort_custom",

    ["modifier_invoker_quas_custom"] = "q",
    ["modifier_invoker_wex_custom"] = "w",
    ["modifier_invoker_exort_custom"] = "e",
}


orb_manager.particle_list = 
{
    ["modifier_invoker_quas_custom"] = "particles/units/heroes/hero_invoker/invoker_quas_orb.vpcf",
    ["modifier_invoker_wex_custom"] = "particles/units/heroes/hero_invoker/invoker_wex_orb.vpcf",
    ["modifier_invoker_exort_custom"] = "particles/units/heroes/hero_invoker/invoker_exort_orb.vpcf",
}

function invoker_invoke_custom:Spawn()
if not IsServer() then return end
self:SetLevel(1)
end


function invoker_invoke_custom:AbilityHit(target)
if not IsServer() then return end 
local caster = self:GetCaster()

if caster:HasTalent("modifier_invoker_invoke_1") then
    local damage = caster:GetTalentValue("modifier_invoker_invoke_1", "damage")*caster:GetIntellect(false)/100
    DoDamage({victim = target, attacker = caster, ability = self, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL}, "modifier_invoker_invoke_1")
    target:SendNumber(4, damage)
end

if not target:IsRealHero() then return end

local mod = caster:FindModifierByName("modifier_invoker_invoke_custom_legendary_stacks")
if mod then 
    mod:AddStack()
end 

if caster:GetQuest() == "Invoker.Quest_8" and not caster:QuestCompleted() then 
   caster:UpdateQuest(1)
end 

end 



function invoker_invoke_custom:UseScepter()

local cd = self:GetSpecialValueFor("scepter_cd")
local caster = self:GetCaster()

caster:RemoveModifierByName("modifier_invoker_invoke_custom_scepter")
caster:AddNewModifier(caster, self, "modifier_invoker_invoke_custom_scepter_cd", {duration = cd})

local item = caster:FindItemInInventory("item_ultimate_scepter")

if item then 
    item:StartCooldown(cd)
end 

local particle_peffect = ParticleManager:CreateParticle("particles/maiden_shield_active.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
ParticleManager:SetParticleControl(particle_peffect, 0, caster:GetAbsOrigin())
ParticleManager:SetParticleControl(particle_peffect, 2, caster:GetAbsOrigin())
ParticleManager:ReleaseParticleIndex(particle_peffect)
caster:EmitSound("Invoker.Scepter_activate")
end 



function invoker_invoke_custom:GetBehavior()
return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_SHOW_IN_GUIDES + DOTA_ABILITY_BEHAVIOR_NOT_LEARNABLE + DOTA_ABILITY_BEHAVIOR_IGNORE_CHANNEL
end


function invoker_invoke_custom:GetCooldown(level)

if self:GetCaster():HasModifier("modifier_invoker_invoke_custom_legendary") then 
    return self:GetCaster():GetTalentValue("modifier_invoker_invoke_7", "cd", true)
end

local cooldown = self:GetSpecialValueFor("base_cd")
local quas = self:GetCaster():FindAbilityByName("invoker_quas_custom")
local wex = self:GetCaster():FindAbilityByName("invoker_wex_custom")
local exort = self:GetCaster():FindAbilityByName("invoker_exort_custom")
local cd_red = 0
if exort then
    cd_red = cd_red + exort:GetLevel() * self:GetSpecialValueFor("cooldown_reduction_per_orb")
end
if wex then
    cd_red = cd_red + wex:GetLevel() * self:GetSpecialValueFor("cooldown_reduction_per_orb")
end
if quas then
    cd_red = cd_red + quas:GetLevel() * self:GetSpecialValueFor("cooldown_reduction_per_orb")
end
cooldown = cooldown - cd_red

return cooldown
end



function invoker_invoke_custom:OnSpellStart()
    local caster = self:GetCaster()
    local ability_name = self.orb_manager:GetInvokedAbility()
    self.ability_manager:Invoke( ability_name )
    self:PlayEffects()
end

function invoker_invoke_custom:OnUpgrade()
    self.orb_manager = orb_manager:init()
    self.ability_manager = ability_manager:init()
    self.ability_manager.caster = self:GetCaster()
    self.ability_manager.ability = self
    local empty1 = self:GetCaster():FindAbilityByName( "invoker_empty1" )
    local empty2 = self:GetCaster():FindAbilityByName( "invoker_empty2" )
    table.insert(self.ability_manager.ability_slot,empty1)
    table.insert(self.ability_manager.ability_slot,empty2)
end

function invoker_invoke_custom:AddOrb( modifier )
    self.orb_manager:Add( modifier )
end

function invoker_invoke_custom:UpdateOrb( modifer_name, level )
    updates = self.orb_manager:UpdateOrb( modifer_name, level )
    self.ability_manager:UpgradeAbilities()
end

function invoker_invoke_custom:GetOrbLevel( orb_name )
    if not self.orb_manager.status[orb_name] then return 0 end
    return self.orb_manager.status[orb_name].level
end

function invoker_invoke_custom:GetOrbInstances( orb_name )
    if not self.orb_manager.status[orb_name] then return 0 end
    return self.orb_manager.status[orb_name].instances
end

function invoker_invoke_custom:GetOrbs()
    local ret = {}
    for k,v in pairs(self.orb_manager.status) do
        ret[k] = v.level
    end
    return ret
end

function invoker_invoke_custom:PlayEffects()
    local particle_cast = "particles/units/heroes/hero_invoker/invoker_invoke.vpcf"
    local sound_cast = "Hero_Invoker.Invoke"
    local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
    ParticleManager:ReleaseParticleIndex( effect_cast )
    self:GetCaster():EmitSound(sound_cast)
end



function orb_manager:init()
local ret = {}

ret.MAX_ORB = 3
ret.status = {}
ret.modifiers = {}
ret.names = {}

for k,v in pairs(self) do
    ret[k] = v
end
return ret
end

function orb_manager:DestroyParticles(caster)

if caster.invoked_orbs_particle == nil then return end
 

for i = 1,#caster.invoked_orbs_particle do

    if caster.invoked_orbs_particle[i] ~= nil then
        ParticleManager:DestroyParticle(caster.invoked_orbs_particle[i], false)
        caster.invoked_orbs_particle[i] = nil
    end
end

end 


function orb_manager:RestoreParticles(caster)

for _,mod in pairs(caster:FindAllModifiers()) do 
    for name,particle in pairs(self.particle_list) do 
        if mod:GetName() == name then
            if caster:HasModifier("modifier_invoker_persona_1") or caster:HasModifier("modifier_invoker_persona_2") or caster:HasModifier("modifier_invoker_persona_3") or caster:HasModifier("modifier_invoker_persona_4") or caster:HasModifier("modifier_invoker_persona_5") or caster:HasModifier("modifier_invoker_persona_6") then
                local new_spheres_list = 
                {
                    ["particles/units/heroes/hero_invoker/invoker_quas_orb.vpcf"] = "particles/units/heroes/hero_invoker_kid/invoker_kid_quas_orb.vpcf",
                    ["particles/units/heroes/hero_invoker/invoker_wex_orb.vpcf"] = "particles/units/heroes/hero_invoker_kid/invoker_kid_wex_orb.vpcf",
                    ["particles/units/heroes/hero_invoker/invoker_exort_orb.vpcf"] = "particles/units/heroes/hero_invoker_kid/invoker_kid_exort_orb.vpcf",
                }
                if caster:HasModifier("modifier_invoker_persona_2") then
                    new_spheres_list = 
                    {
                        ["particles/units/heroes/hero_invoker/invoker_quas_orb.vpcf"] = "particles/econ/items/invoker_kid/invoker_dark_artistry/invoker_kid_dark_artistry_quas_orb.vpcf",
                        ["particles/units/heroes/hero_invoker/invoker_wex_orb.vpcf"] = "particles/econ/items/invoker_kid/invoker_dark_artistry/invoker_kid_dark_artistry_wex_orb.vpcf",
                        ["particles/units/heroes/hero_invoker/invoker_exort_orb.vpcf"] = "particles/econ/items/invoker_kid/invoker_dark_artistry/invoker_kid_dark_artistry_exort_orb.vpcf",
                    }
                end
                particle = new_spheres_list[particle]
            elseif caster:HasModifier("modifier_magus_apex_custom") then
                local new_spheres_list = 
                {
                    ["particles/units/heroes/hero_invoker/invoker_quas_orb.vpcf"] = "particles/econ/items/invoker/invoker_apex/invoker_apex_quas_orb.vpcf",
                    ["particles/units/heroes/hero_invoker/invoker_wex_orb.vpcf"] = "particles/econ/items/invoker/invoker_apex/invoker_apex_wex_orb.vpcf",
                    ["particles/units/heroes/hero_invoker/invoker_exort_orb.vpcf"] = "particles/econ/items/invoker/invoker_apex/invoker_apex_exort_orb.vpcf",
                }
                particle = new_spheres_list[particle]
            elseif caster:HasModifier("modifier_invoker_dark_artistry_hair") or caster:HasModifier("modifier_invoker_dark_artistry_cape") then
                local new_spheres_list = 
                {
                    ["particles/units/heroes/hero_invoker/invoker_quas_orb.vpcf"] = "particles/econ/items/invoker/invoker_ti6/invoker_ti6_quas_orb.vpcf",
                    ["particles/units/heroes/hero_invoker/invoker_wex_orb.vpcf"] = "particles/econ/items/invoker/invoker_ti6/invoker_ti6_wex_orb.vpcf",
                    ["particles/units/heroes/hero_invoker/invoker_exort_orb.vpcf"] = "particles/econ/items/invoker/invoker_ti6/invoker_ti6_exort_orb.vpcf",
                }
                particle = new_spheres_list[particle]
            end
            self:AddOrbParticle(caster, particle)
        end 
    end 
end 


end 



function orb_manager:AddOrbParticle(caster, particle)
if caster:HasModifier("modifier_invoker_invoke_custom_legendary") then return end

if caster.invoked_orbs_particle == nil then
    caster.invoked_orbs_particle = {}
end

if caster.invoked_orbs_particle_attach == nil then
    caster.invoked_orbs_particle_attach = {}
    caster.invoked_orbs_particle_attach[1] = "attach_orb1"
    caster.invoked_orbs_particle_attach[2] = "attach_orb2"
    caster.invoked_orbs_particle_attach[3] = "attach_orb3"
end

if caster.invoked_orbs_particle[1] ~= nil then
    ParticleManager:DestroyParticle(caster.invoked_orbs_particle[1], false)
    caster.invoked_orbs_particle[1] = nil
end

caster.invoked_orbs_particle[1] = caster.invoked_orbs_particle[2]
caster.invoked_orbs_particle[2] = caster.invoked_orbs_particle[3]
caster.invoked_orbs_particle[3] = ParticleManager:CreateParticle(particle, PATTACH_CUSTOMORIGIN, caster)
ParticleManager:SetParticleControlEnt(caster.invoked_orbs_particle[3], 0, caster, PATTACH_POINT_FOLLOW, "attach_attack"..RandomInt(1, 2), caster:GetAbsOrigin(), false)
ParticleManager:SetParticleControlEnt(caster.invoked_orbs_particle[3], 1, caster, PATTACH_POINT_FOLLOW, caster.invoked_orbs_particle_attach[1], caster:GetAbsOrigin(), false)


local temp_attachment_point = caster.invoked_orbs_particle_attach[1]
caster.invoked_orbs_particle_attach[1] = caster.invoked_orbs_particle_attach[2]
caster.invoked_orbs_particle_attach[2] = caster.invoked_orbs_particle_attach[3]
caster.invoked_orbs_particle_attach[3] = temp_attachment_point

end 


function orb_manager:Add( modifier )

local caster = modifier:GetCaster()

local orb_name = self.modifier_list[modifier:GetName()]
if not self.status[orb_name] then
    self.status[orb_name] = {
        ["instances"] = 0,
        ["level"] = modifier:GetAbility():GetLevel(),
    }
end

local particle = self.particle_list[modifier:GetName()]

if caster:HasModifier("modifier_invoker_persona_1") or caster:HasModifier("modifier_invoker_persona_2") or caster:HasModifier("modifier_invoker_persona_3") or caster:HasModifier("modifier_invoker_persona_4") or caster:HasModifier("modifier_invoker_persona_5") or caster:HasModifier("modifier_invoker_persona_6") then
    local new_spheres_list = 
    {
        ["particles/units/heroes/hero_invoker/invoker_quas_orb.vpcf"] = "particles/units/heroes/hero_invoker_kid/invoker_kid_quas_orb.vpcf",
        ["particles/units/heroes/hero_invoker/invoker_wex_orb.vpcf"] = "particles/units/heroes/hero_invoker_kid/invoker_kid_wex_orb.vpcf",
        ["particles/units/heroes/hero_invoker/invoker_exort_orb.vpcf"] = "particles/units/heroes/hero_invoker_kid/invoker_kid_exort_orb.vpcf",
    }
    if caster:HasModifier("modifier_invoker_persona_2") then
        new_spheres_list = 
        {
            ["particles/units/heroes/hero_invoker/invoker_quas_orb.vpcf"] = "particles/econ/items/invoker_kid/invoker_dark_artistry/invoker_kid_dark_artistry_quas_orb.vpcf",
            ["particles/units/heroes/hero_invoker/invoker_wex_orb.vpcf"] = "particles/econ/items/invoker_kid/invoker_dark_artistry/invoker_kid_dark_artistry_wex_orb.vpcf",
            ["particles/units/heroes/hero_invoker/invoker_exort_orb.vpcf"] = "particles/econ/items/invoker_kid/invoker_dark_artistry/invoker_kid_dark_artistry_exort_orb.vpcf",
        }
    end
    particle = new_spheres_list[particle]
elseif caster:HasModifier("modifier_magus_apex_custom") then
    local new_spheres_list = 
    {
        ["particles/units/heroes/hero_invoker/invoker_quas_orb.vpcf"] = "particles/econ/items/invoker/invoker_apex/invoker_apex_quas_orb.vpcf",
        ["particles/units/heroes/hero_invoker/invoker_wex_orb.vpcf"] = "particles/econ/items/invoker/invoker_apex/invoker_apex_wex_orb.vpcf",
        ["particles/units/heroes/hero_invoker/invoker_exort_orb.vpcf"] = "particles/econ/items/invoker/invoker_apex/invoker_apex_exort_orb.vpcf",
    }
    particle = new_spheres_list[particle]
elseif caster:HasModifier("modifier_invoker_dark_artistry_hair") or caster:HasModifier("modifier_invoker_dark_artistry_cape") then
    local new_spheres_list = 
    {
        ["particles/units/heroes/hero_invoker/invoker_quas_orb.vpcf"] = "particles/econ/items/invoker/invoker_ti6/invoker_ti6_quas_orb.vpcf",
        ["particles/units/heroes/hero_invoker/invoker_wex_orb.vpcf"] = "particles/econ/items/invoker/invoker_ti6/invoker_ti6_wex_orb.vpcf",
        ["particles/units/heroes/hero_invoker/invoker_exort_orb.vpcf"] = "particles/econ/items/invoker/invoker_ti6/invoker_ti6_exort_orb.vpcf",
    }
    particle = new_spheres_list[particle]
end

self:AddOrbParticle(caster, particle)

table.insert(self.modifiers,modifier)
table.insert(self.names,orb_name)
self.status[orb_name].instances = self.status[orb_name].instances + 1

if #self.modifiers>self.MAX_ORB then
    self.status[self.names[1]].instances = self.status[self.names[1]].instances - 1

    if not self.modifiers[1]:IsNull() then
        self.modifiers[1]:Destroy()
    end

    table.remove(self.modifiers,1)
    table.remove(self.names,1)
end
    
end

function orb_manager:GetInvokedAbility()
    local key = ""
    for i=1,string.len(self.orb_order) do
        k = string.sub(self.orb_order,i,i)

        if self.status[k] then 
            for i=1,self.status[k].instances do
                key = key .. k
            end
        end
    end
    return self.invoke_list[key]
end

function orb_manager:UpdateOrb( modifer_name, level )
    for _,modifier in pairs(self.modifiers) do
        if modifier:GetName()==modifer_name then
            modifier:ForceRefresh()
        end
    end

    local orb_name = self.modifier_list[modifer_name]
    if not self.status[orb_name] then
        self.status[orb_name] = {
            ["instances"] = 0,
            ["level"] = level,
        }
    else
        self.status[orb_name].level = level
    end
end

function ability_manager:init()
    local ret = {}

    ret.abilities = {}
    ret.ability_slot = {}
    ret.MAX_ABILITY = 2

    for k,v in pairs(self) do
        ret[k] = v
    end
    return ret
end

function ability_manager:Invoke( ability_name )
    if not ability_name then return end

    local ability = self:GetAbilityHandle( ability_name )
    ability.orbs = self.ability:GetOrbs()

    if self.ability_slot[1] and self.ability_slot[1]==ability then
        self.ability:RefundManaCost()
        self.ability:EndCooldown()
        return
    end

    local exist = 0
    for i=1,#self.ability_slot do
        if self.ability_slot[i]==ability then
            exist = i
        end
    end
    if exist>0 then
        self:InvokeExist( exist )
        self.ability:RefundManaCost()
        self.ability:EndCooldown()
        return
    end

    self:InvokeNew( ability )
end

function ability_manager:InvokeExist( slot )
    for i=slot,2,-1 do
        self.caster:SwapAbilities( 
            self.ability_slot[slot-1]:GetAbilityName(),
            self.ability_slot[slot]:GetAbilityName(),
            true,
            true
        )
        self.ability_slot[slot], self.ability_slot[slot-1] = self.ability_slot[slot-1], self.ability_slot[slot]
    end
end

function ability_manager:InvokeNew( ability )
    if #self.ability_slot<self.MAX_ABILITY then
        table.insert(self.ability_slot,ability)
    else
        self.caster:SwapAbilities( 
            ability:GetAbilityName(),
            self.ability_slot[#self.ability_slot]:GetAbilityName(),
            true,
            false
        )
        self.ability_slot[#self.ability_slot] = ability
    end

    self:InvokeExist( #self.ability_slot )
end

function ability_manager:GetAbilityHandle( ability_name )
    local ability = self.abilities[ability_name]

    if not ability then
        ability = self.caster:FindAbilityByName( ability_name )
        self.abilities[ability_name] = ability
        
        if not ability then
            ability = self.caster:AddAbility( ability_name )
            self.abilities[ability_name] = ability
        end

        ability:SetLevel(1)
    end

    return ability
end



function ability_manager:UpgradeAbilities()
    for _,ability in pairs(self.abilities) do
        ability.orbs = self.ability:GetOrbs()
    end
end






modifier_invoker_invoke_custom_tracker = class({})
function modifier_invoker_invoke_custom_tracker:IsHidden() return true end
function modifier_invoker_invoke_custom_tracker:IsPurgable() return false end
function modifier_invoker_invoke_custom_tracker:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_MANACOST_PERCENTAGE_STACKING
}
end


function modifier_invoker_invoke_custom_tracker:GetModifierPercentageManacostStacking()
local reduce = 0
if self.parent:HasTalent("modifier_invoker_invoke_3") then 
    reduce = self.parent:GetTalentValue("modifier_invoker_invoke_3", "mana")
end
return reduce
end


function modifier_invoker_invoke_custom_tracker:OnCreated()
self.parent = self:GetParent()
self.parent:AddDeathEvent(self)

if not IsServer() then return end 

self.parent:AddDamageEvent_inc(self)
self.parent:AddSpellEvent(self)
self.parent:AddRespawnEvent(self)

self.stack_duration = self.parent:GetTalentValue("modifier_invoker_invoke_4", "duration", true)
self.status_duration = self.parent:GetTalentValue("modifier_invoker_invoke_2", "duration", true)
self.cd_items = self.parent:GetTalentValue("modifier_invoker_invoke_6", "cd", true)

self.low_cd = self.parent:GetTalentValue("modifier_invoker_invoke_5", "cd", true)
self.low_health = self.parent:GetTalentValue("modifier_invoker_invoke_5", "health", true)

self.shield_duration = self.parent:GetTalentValue("modifier_invoker_invoke_3", "duration", true)

self:StartIntervalThink(0.5)
end 



function modifier_invoker_invoke_custom_tracker:OnIntervalThink()
if not IsServer() then return end 

if self.parent:HasScepter() and
 not self.parent:HasModifier("modifier_invoker_invoke_custom_scepter_cd") and
  not self.parent:HasModifier("modifier_invoker_invoke_custom_scepter") then 

    self.parent:AddNewModifier(self.parent, self:GetAbility(), "modifier_invoker_invoke_custom_scepter", {})
end 

if not self.parent:HasScepter() and self.parent:HasModifier("modifier_invoker_invoke_custom_scepter") then 
    self.parent:RemoveModifierByName("modifier_invoker_invoke_custom_scepter")
end

end 


function modifier_invoker_invoke_custom_tracker:SpellEvent( params )
if not IsServer() then return end
if params.unit~=self.parent then return end

if self.parent:HasTalent("modifier_invoker_invoke_4") then 
    self.parent:AddNewModifier(self.parent, self:GetAbility(), "modifier_invoker_invoke_custom_cast_count", {duration = self.stack_duration})
    self.parent:AddNewModifier(self.parent, self:GetAbility(), "modifier_invoker_invoke_custom_cast", {duration = self.stack_duration})
end 

if params.ability:IsItem() then return end

if self.parent:HasTalent("modifier_invoker_invoke_2") then 
    self.parent:AddNewModifier(self.parent, self:GetAbility(), "modifier_invoker_invoke_custom_move", {duration = self.status_duration})
end 

if self.parent:HasTalent("modifier_invoker_invoke_6") then 
    self.parent:CdItems(self.cd_items)  

    local book = self.parent:FindItemInInventory("item_invoker_custom_legendary")
    if book then
        self.parent:CdAbility(book, self.cd_items)
    end
end 

if self.parent:HasTalent("modifier_invoker_invoke_3") then 
    self.parent:AddNewModifier(self.parent, self.ability, "modifier_invoker_invoke_custom_shield", {duration = self.shield_duration})
end 

end 



function modifier_invoker_invoke_custom_tracker:DamageEvent_inc(params)
if not IsServer() then return end 
if not self.parent:HasTalent("modifier_invoker_invoke_5") then return end
if self.parent:GetHealthPercent() > self.low_health then return end 
if self.parent ~= params.unit then return end 
if self.parent:PassivesDisabled() then return end 
if self.parent:HasModifier("modifier_invoker_deafening_blast_custom_cd") then return end 

local ability = self.parent:FindAbilityByName("invoker_deafening_blast_custom")
if ability then 
    ability:OnSpellStart(true)
end 

self.parent:AddNewModifier(self.parent, self:GetAbility(), "modifier_invoker_deafening_blast_custom_cd", {duration = self.low_cd})
end 



function modifier_invoker_invoke_custom_tracker:DeathEvent(params)
if not IsServer() then return end 
if not self.parent:IsRealHero() then return end
if params.unit ~= self.parent then return end 

orb_manager:DestroyParticles(self.parent)
end 

function modifier_invoker_invoke_custom_tracker:RespawnEvent(params)
if not IsServer() then return end 
if not self.parent:IsRealHero() then return end
if params.unit ~= self.parent then return end 

orb_manager:RestoreParticles(self.parent)
end 





invoker_deafening_blast_custom = class({})

function invoker_deafening_blast_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end
PrecacheResource( "particle", "particles/units/heroes/hero_invoker/invoker_deafening_blast.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_invoker/invoker_deafening_blast_knockback_debuff.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_invoker/invoker_deafening_blast_disarm_debuff.vpcf", context )
PrecacheResource( "particle", "particles/status_fx/status_effect_iceblast.vpcf", context )
PrecacheResource( "particle", "particles/econ/items/invoker/invoker_ti6/invoker_deafening_blast_disarm_ti6_debuff.vpcf", context )
PrecacheResource( "particle", "particles/econ/items/invoker/invoker_ti6/invoker_deafening_blast_ti6_knockback_debuff.vpcf", context )
end


function invoker_deafening_blast_custom:GetAbilityTextureName()
local scepter = false
local caster = self:GetCaster()

if caster:HasScepter() and not caster:HasModifier("modifier_invoker_invoke_custom_scepter_cd") and caster:FindAbilityByName("invoker_invoke_custom") then 
   scepter = true
end

if caster:HasModifier("modifier_invoker_persona_2") or (caster:HasModifier("modifier_invoker_dark_artistry_cape") and not (caster:HasModifier("modifier_invoker_persona_1") or caster:HasModifier("modifier_invoker_persona_3") or caster:HasModifier("modifier_invoker_persona_4") or caster:HasModifier("modifier_invoker_persona_5") or caster:HasModifier("modifier_invoker_persona_6"))) then
    if scepter then
        return "invoker_deafening_blast_dark_artistry_aghanim"
    else
        return "invoker/dark_artistry/invoker_deafening_blast"
    end
end

if scepter then
    return "invoker_deafening_blast_aghanim"
else
    return "invoker_deafening_blast"
end

end


function invoker_deafening_blast_custom:GetCooldown(level)
local bonus = 0
if self:GetCaster():HasTalent("modifier_invoker_invoke_1") then 
    bonus = self:GetCaster():GetTalentValue("modifier_invoker_invoke_1", "cd")
end 
return (self.BaseClass.GetCooldown( self, self:GetLevel() ) + bonus)
end 

function invoker_deafening_blast_custom:GetManaCost(level)
return self.BaseClass.GetManaCost(self, level)
end


function invoker_deafening_blast_custom:OnSpellStart(aoe)

local caster = self:GetCaster()
local ult = caster:FindAbilityByName("invoker_invoke_custom")
local scepter = 0


if caster:HasScepter() and ult and not aoe and not caster:HasModifier("modifier_invoker_invoke_custom_scepter_cd") then
    caster:CdAbility(self, self:GetCooldownTimeRemaining()*self:GetSpecialValueFor("scepter_cd")/100)
    scepter = 1
    ult:UseScepter()
end 

caster:StartGesture(ACT_DOTA_CAST_DEAFENING_BLAST)

local caster = caster
local target_loc = self:GetCursorPosition()
local caster_loc = caster:GetAbsOrigin()
local distance = self:GetCastRange(caster_loc,caster)

if target_loc == caster:GetAbsOrigin() then
    target_loc = target_loc + caster:GetForwardVector()
end

local direction = (target_loc - caster_loc):Normalized()

local travel_distance = self:GetSpecialValueFor("travel_distance")
local travel_speed = self:GetSpecialValueFor("travel_speed")
local radius_start = self:GetSpecialValueFor("radius_start")
local radius_end = self:GetSpecialValueFor("radius_end")

local particle_name = "particles/units/heroes/hero_invoker/invoker_deafening_blast.vpcf"
local sound = "Hero_Invoker.DeafeningBlast"
if caster:HasModifier("modifier_invoker_dark_artistry_cape") and not (caster:HasModifier("modifier_invoker_persona_1") or caster:HasModifier("modifier_invoker_persona_3") or caster:HasModifier("modifier_invoker_persona_4") or caster:HasModifier("modifier_invoker_persona_5") or caster:HasModifier("modifier_invoker_persona_6")) then
    particle_name = "particles/econ/items/invoker/invoker_ti6/invoker_deafening_blast_ti6.vpcf"
    sound = "Hero_Invoker.DeafeningBlast.Immortal"
end
if caster:HasModifier("modifier_invoker_persona_2") then
    particle_name = "particles/econ/items/invoker/invoker_ti6/invoker_deafening_blast_ti6.vpcf"
    sound = "Hero_Invoker.DeafeningBlast.Immortal"
end

local thinker = CreateModifierThinker( caster, self, "modifier_invoker_invoke_custom_blast_thinker", {}, caster:GetAbsOrigin(), caster:GetTeamNumber(), false )
thinker.hit_targets = {}

local projectile =
{
    Ability             = self,
    EffectName          = particle_name,
    vSpawnOrigin        = caster_loc,
    fDistance           = travel_distance,
    fStartRadius        = radius_start,
    fEndRadius          = radius_end,
    Source              = caster,
    bHasFrontalCone     = false,
    bReplaceExisting    = false,
    iUnitTargetTeam     = DOTA_UNIT_TARGET_TEAM_ENEMY,
    iUnitTargetType     = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
    fExpireTime         = GameRules:GetGameTime() + 10.5,
    bDeleteOnHit        = false,
    bProvidesVision     = false,
    ExtraData           = {is_scepter = scepter, thinker = thinker:entindex(),}
}


local count = 0
if aoe and aoe == true then 
    count = caster:GetTalentValue("modifier_invoker_invoke_5", "count")
end 

for i=0,count do
    projectile.vVelocity = RotatePosition(Vector(0,0,0), QAngle(0,i*30,0), direction) * travel_speed
    ProjectileManager:CreateLinearProjectile(projectile)
end

caster:EmitSound(sound)
end


function invoker_deafening_blast_custom:OnProjectileHit_ExtraData(target, location, ExtraData)
local caster = self:GetCaster()

local thinker = EntIndexToHScript(ExtraData.thinker)
if not thinker then return end

if not target then
    UTIL_Remove(thinker)
    return nil
end

if thinker.hit_targets[target:entindex()] then return end

thinker.hit_targets[target:entindex()] = true

local ability = caster:FindAbilityByName("invoker_invoke_custom")
if ability then 
    ability:AbilityHit(target)
end 

local damage = caster:GetValueExort(self, "damage")
local knockback_duration = caster:GetValueQuas(self, "knockback_duration")
local knockback_distance = caster:GetValueQuas(self, "knockback_distance")
local disarm_duration = caster:GetValueWex(self, "disarm_duration")
local debuff_ability = self
if ExtraData.is_scepter == 1 then
    debuff_ability = caster:BkbAbility(self, true)
end

local center = location

if location == target:GetAbsOrigin() then 
    center = caster:GetAbsOrigin()
end 

local direction = (target:GetAbsOrigin() - center):Normalized()
direction.z = 0

local point = target:GetAbsOrigin() + direction*knockback_distance

local knockback = target:AddNewModifier( caster, debuff_ability, "modifier_generic_arc",
{
    target_x = point.x,
    target_y = point.y,
    distance = knockback_distance,
    duration = knockback_duration,
    height = 0,
    fix_end = true,
    isStun = false,
})


local real_damage = DoDamage({victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self})

target:AddNewModifier(caster, debuff_ability, "modifier_invoker_deafening_blast_custom", {duration = disarm_duration * (1 - target:GetStatusResistance())})

if knockback then
    local particle_name_knockback = "particles/units/heroes/hero_invoker/invoker_deafening_blast_knockback_debuff.vpcf"
    if caster:HasModifier("modifier_invoker_dark_artistry_cape") and not (caster:HasModifier("modifier_invoker_persona_1") or caster:HasModifier("modifier_invoker_persona_3") or caster:HasModifier("modifier_invoker_persona_4") or caster:HasModifier("modifier_invoker_persona_5") or caster:HasModifier("modifier_invoker_persona_6")) then
        particle_name_knockback = "particles/econ/items/invoker/invoker_ti6/invoker_deafening_blast_ti6_knockback_debuff.vpcf"
    end
    if caster:HasModifier("modifier_invoker_persona_2") then
        particle_name_knockback = "particles/econ/items/invoker/invoker_ti6/invoker_deafening_blast_ti6_knockback_debuff.vpcf"
    end
    local particle = ParticleManager:CreateParticle(particle_name_knockback, PATTACH_ABSORIGIN_FOLLOW, target)
    knockback:AddParticle(particle, false, false, -1, false, false)
end


end

modifier_invoker_invoke_custom_blast_thinker = class({})
function modifier_invoker_invoke_custom_blast_thinker:IsPurgable() return false end



modifier_invoker_deafening_blast_custom = class({})
function modifier_invoker_deafening_blast_custom:IsPurgable() return false end
function modifier_invoker_deafening_blast_custom:IsPurgeException() return false end
function modifier_invoker_deafening_blast_custom:GetTexture() return "invoker_deafening_blast" end
function modifier_invoker_deafening_blast_custom:OnCreated()
self.parent = self:GetParent()
self.caster = self:GetCaster()

self.damage = self.caster:GetTalentValue("modifier_invoker_invoke_5", "damage")

if not IsServer() then return end
local particle_name = "particles/units/heroes/hero_invoker/invoker_deafening_blast_disarm_debuff.vpcf"
if self.caster:HasModifier("modifier_invoker_dark_artistry_cape") and not (self.caster:HasModifier("modifier_invoker_persona_1") or self.caster:HasModifier("modifier_invoker_persona_3") or self.caster:HasModifier("modifier_invoker_persona_4") or self.caster:HasModifier("modifier_invoker_persona_5") or self.caster:HasModifier("modifier_invoker_persona_6")) then
    particle_name = "particles/econ/items/invoker/invoker_ti6/invoker_deafening_blast_disarm_ti6_debuff.vpcf"
end
if self.caster:HasModifier("modifier_invoker_persona_2") then
    particle_name = "particles/econ/items/invoker/invoker_ti6/invoker_deafening_blast_disarm_ti6_debuff.vpcf"
end
local particle = ParticleManager:CreateParticle(particle_name, PATTACH_OVERHEAD_FOLLOW, self:GetParent())
self:AddParticle(particle, false, false, -1, false, false)
end

function modifier_invoker_deafening_blast_custom:GetStatusEffectName() return "particles/status_fx/status_effect_iceblast.vpcf" end
function modifier_invoker_deafening_blast_custom:StatusEffectPriority() return MODIFIER_PRIORITY_HIGH  end
function modifier_invoker_deafening_blast_custom:CheckState() 
return  
{
    [MODIFIER_STATE_DISARMED] = true,
}
end

function modifier_invoker_deafening_blast_custom:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
    MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
}
end

function modifier_invoker_deafening_blast_custom:GetModifierDamageOutgoing_Percentage()
return self.damage
end

function modifier_invoker_deafening_blast_custom:GetModifierSpellAmplify_Percentage()
return self.damage
end




item_invoker_custom_legendary = class({})

function item_invoker_custom_legendary:GetIntrinsicModifierName()
if not self:GetCaster():IsRealHero() then return end
return "modifier_invoker_invoke_custom_legendary_tracker"   
end

function item_invoker_custom_legendary:OnSpellStart()

self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_invoker_invoke_custom_legendary", {duration = self:GetCaster():GetTalentValue("modifier_invoker_invoke_7", "duration", true)})
end 


modifier_invoker_invoke_custom_legendary = class({})
function modifier_invoker_invoke_custom_legendary:IsHidden() return true end
function modifier_invoker_invoke_custom_legendary:IsPurgable() return false end
function modifier_invoker_invoke_custom_legendary:GetEffectName() return "particles/invoker/item_speed.vpcf" end
function modifier_invoker_invoke_custom_legendary:GetStatusEffectName() return "particles/status_fx/status_effect_huskar_lifebreak.vpcf" end
function modifier_invoker_invoke_custom_legendary:StatusEffectPriority() return MODIFIER_PRIORITY_ULTRA  end

function modifier_invoker_invoke_custom_legendary:OnCreated(table)
if not IsServer() then return end 
self.RemoveForDuel = true
self.parent = self:GetParent()

local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_dark_seer/dark_seer_surge.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
self:AddParticle(particle, false, false, -1, false, false)

particle = ParticleManager:CreateParticle("particles/invoker/invoke_legendary_clock.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
self:AddParticle(particle, false, false, -1, false, false)

particle = ParticleManager:CreateParticle("particles/econ/items/faceless_void/faceless_void_bracers_of_aeons/fv_bracers_of_aeons_dialatedebuf.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
self:AddParticle(particle, false, false, -1, false, false)

self.parent:EmitSound("Invoker.Invoke_legendary_start")
self.parent:EmitSound("Invoker.Invoke_legendary_loop")

self.pos = self.parent:GetAbsOrigin()
self.parent = self.parent

self.health_level = self.parent:GetHealthPercent()/100
self.mana_level = self.parent:GetManaPercent()/100

local illusion_self = CreateIllusions(self:GetCaster(), self:GetCaster(), {
outgoing_damage = 0,
duration        = self:GetRemainingTime() + 0.2 
}, 1, 0, false, false)

for _,illusion in pairs(illusion_self) do
    illusion.owner = caster
    illusion:AddNewModifier(self.parent, self:GetAbility(), "modifier_invoker_invoke_custom_legendary_illusion", {duration = self:GetRemainingTime()})
    illusion:SetAbsOrigin(self.pos)

    self.illusion = illusion
end

self.spells = {}

for i = 0, 20 do
    local current_ability = self.parent:GetAbilityByIndex(i)

    if current_ability then
        self.spells[current_ability:GetName()] = current_ability:GetCooldownTimeRemaining()
    end
end

if self.parent.invoked_orbs_particle_attach then 

    for i = 1,3 do 
        for _,name in pairs(orb_manager.particle_list) do 
            if self.parent:HasModifier("modifier_invoker_persona_1") or self.parent:HasModifier("modifier_invoker_persona_2") or self.parent:HasModifier("modifier_invoker_persona_3") or self.parent:HasModifier("modifier_invoker_persona_4") or self.parent:HasModifier("modifier_invoker_persona_5") or self.parent:HasModifier("modifier_invoker_persona_6") then
                local new_spheres_list = 
                {
                    ["particles/units/heroes/hero_invoker/invoker_quas_orb.vpcf"] = "particles/units/heroes/hero_invoker_kid/invoker_kid_quas_orb.vpcf",
                    ["particles/units/heroes/hero_invoker/invoker_wex_orb.vpcf"] = "particles/units/heroes/hero_invoker_kid/invoker_kid_wex_orb.vpcf",
                    ["particles/units/heroes/hero_invoker/invoker_exort_orb.vpcf"] = "particles/units/heroes/hero_invoker_kid/invoker_kid_exort_orb.vpcf",
                }
                if self.parent:HasModifier("modifier_invoker_persona_2") then
                    new_spheres_list = 
                    {
                        ["particles/units/heroes/hero_invoker/invoker_quas_orb.vpcf"] = "particles/econ/items/invoker_kid/invoker_dark_artistry/invoker_kid_dark_artistry_quas_orb.vpcf",
                        ["particles/units/heroes/hero_invoker/invoker_wex_orb.vpcf"] = "particles/econ/items/invoker_kid/invoker_dark_artistry/invoker_kid_dark_artistry_wex_orb.vpcf",
                        ["particles/units/heroes/hero_invoker/invoker_exort_orb.vpcf"] = "particles/econ/items/invoker_kid/invoker_dark_artistry/invoker_kid_dark_artistry_exort_orb.vpcf",
                    }
                end
                name = new_spheres_list[name]
            elseif self.parent:HasModifier("modifier_magus_apex_custom") then
                local new_spheres_list = 
                {
                    ["particles/units/heroes/hero_invoker/invoker_quas_orb.vpcf"] = "particles/econ/items/invoker/invoker_apex/invoker_apex_quas_orb.vpcf",
                    ["particles/units/heroes/hero_invoker/invoker_wex_orb.vpcf"] = "particles/econ/items/invoker/invoker_apex/invoker_apex_wex_orb.vpcf",
                    ["particles/units/heroes/hero_invoker/invoker_exort_orb.vpcf"] = "particles/econ/items/invoker/invoker_apex/invoker_apex_exort_orb.vpcf",
                }
                name = new_spheres_list[name]
            elseif self.parent:HasModifier("modifier_invoker_dark_artistry_hair") or self.parent:HasModifier("modifier_invoker_dark_artistry_cape") then
                local new_spheres_list = 
                {
                    ["particles/units/heroes/hero_invoker/invoker_quas_orb.vpcf"] = "particles/econ/items/invoker/invoker_ti6/invoker_ti6_quas_orb.vpcf",
                    ["particles/units/heroes/hero_invoker/invoker_wex_orb.vpcf"] = "particles/econ/items/invoker/invoker_ti6/invoker_ti6_wex_orb.vpcf",
                    ["particles/units/heroes/hero_invoker/invoker_exort_orb.vpcf"] = "particles/econ/items/invoker/invoker_ti6/invoker_ti6_exort_orb.vpcf",
                }
                name = new_spheres_list[name]
            end
            local particle = ParticleManager:CreateParticle(name, PATTACH_CUSTOMORIGIN, self.parent)
            ParticleManager:SetParticleControlEnt(particle, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_attack"..RandomInt(1, 2), self.parent:GetAbsOrigin(), false)
            ParticleManager:SetParticleControlEnt(particle, 1, self.parent, PATTACH_POINT_FOLLOW, self.parent.invoked_orbs_particle_attach[i], self.parent:GetAbsOrigin(), false)
            self:AddParticle(particle, false, false, -1, false, false)
        end
    end 
end

orb_manager:DestroyParticles(self.parent)

self.max_time = self:GetRemainingTime()

self:StartIntervalThink(FrameTime())
self:OnIntervalThink()
end 


function modifier_invoker_invoke_custom_legendary:OnIntervalThink()
if not IsServer() then return end 

self.parent:UpdateUIshort({max_time = self.max_time, time = (self.max_time - self:GetElapsedTime()), stack = self:GetRemainingTime(), use_zero = 1, style = "InvokerInvoke", priority = 1})
end 


function modifier_invoker_invoke_custom_legendary:OnDestroy()
if not IsServer() then return end 

self.parent:UpdateUIshort({hide = 1, hide_full = 1, style = "InvokerInvoke", priority = 1})

if self.illusion and not self.illusion:IsNull() then 
    self.illusion:Kill(nil, nil)
end 

self.parent:StopSound("Invoker.Invoke_legendary_loop")

if self:GetRemainingTime() > 0.1 then return end 
if not self.parent:IsAlive() then return end 

orb_manager:RestoreParticles(self.parent)

local particle = ParticleManager:CreateParticle("particles/troll_warlord/refresh_ranged.vpcf", PATTACH_CUSTOMORIGIN, self.parent)
ParticleManager:SetParticleControlEnt( particle, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetOrigin(), true )
ParticleManager:ReleaseParticleIndex(particle)

self.parent:EmitSound("Invoker.Invoke_legendary_refresh")

for i = 0, 20 do
    local current_ability = self.parent:GetAbilityByIndex(i)

    if self.spells[current_ability:GetName()] then 
        current_ability:EndCooldown()
        current_ability:StartCooldown(self.spells[current_ability:GetName()])
    end 
end

EmitSoundOnLocationWithCaster(self.parent:GetAbsOrigin(), "Invoker.Invoke_return", self.parent)

local abs = self.pos
abs.z = abs.z + 100

local geminate_lapse_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_weaver/weaver_timelapse.vpcf", PATTACH_WORLDORIGIN, self.parent)
ParticleManager:SetParticleControl(geminate_lapse_particle, 0, self.parent:GetAbsOrigin())
ParticleManager:SetParticleControl(geminate_lapse_particle, 2, abs)
ParticleManager:ReleaseParticleIndex(geminate_lapse_particle)

ProjectileManager:ProjectileDodge(self.parent)
self.parent:Purge(false, true, false, true, true)
self.parent:SetHealth(self.parent:GetMaxHealth()*self.health_level)
self.parent:SetMana(self.parent:GetMaxMana()*self.mana_level)
FindClearSpaceForUnit(self.parent, self.pos, true)
end 





modifier_invoker_invoke_custom_legendary_illusion = class({})
function modifier_invoker_invoke_custom_legendary_illusion:IsHidden() return true end
function modifier_invoker_invoke_custom_legendary_illusion:IsPurgable() return false end
function modifier_invoker_invoke_custom_legendary_illusion:GetStatusEffectName() return "particles/status_fx/status_effect_huskar_lifebreak.vpcf" end
function modifier_invoker_invoke_custom_legendary_illusion:OnCreated(table)
if not IsServer() then return end

self.caster = self:GetCaster()
self.parent = self:GetParent()

self.caster:AddDamageEvent_out(self)

local particle = ParticleManager:CreateParticle("particles/econ/items/faceless_void/faceless_void_bracers_of_aeons/fv_bracers_of_aeons_dialatedebuf.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
self:AddParticle(particle, false, false, -1, false, false)

self.freeze = false
self.targets = {}

self.t = -1
self.timer = self:GetRemainingTime()*2 
self:GetParent():StartGesture(ACT_DOTA_TELEPORT)

self:OnIntervalThink()
self:StartIntervalThink(0.5)
end

function modifier_invoker_invoke_custom_legendary_illusion:OnIntervalThink()
if not IsServer() then return end 

if self.t ~= -1 then 
    self.freeze = true
end 

self.t = self.t + 1

local number = (self.timer-self.t)/2 
local int = 0
int = number
if number % 1 ~= 0 then int = number - 0.5  end

local digits = math.floor(math.log10(number)) + 2

local decimal = number % 1

if decimal == 0.5 then
    decimal = 8
else 
    decimal = 1
end

local particle = ParticleManager:CreateParticle("particles/huskar_timer.vpcf", PATTACH_OVERHEAD_FOLLOW, self.parent)
ParticleManager:SetParticleControl(particle, 0, self.parent:GetAbsOrigin())
ParticleManager:SetParticleControl(particle, 1, Vector(0, int, decimal))
ParticleManager:SetParticleControl(particle, 2, Vector(digits, 0, 0))
ParticleManager:ReleaseParticleIndex(particle)
end

function modifier_invoker_invoke_custom_legendary_illusion:StatusEffectPriority() return MODIFIER_PRIORITY_ILLUSION end

function modifier_invoker_invoke_custom_legendary_illusion:CheckState()
return
{
    [MODIFIER_STATE_INVULNERABLE] = true,
    [MODIFIER_STATE_UNTARGETABLE] = true,
    [MODIFIER_STATE_UNSELECTABLE] = true,
    [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
    [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
    [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
    [MODIFIER_STATE_OUT_OF_GAME]    = true,
    [MODIFIER_STATE_STUNNED]    = true,
    [MODIFIER_STATE_FROZEN]    = self.freeze,
}
end


function modifier_invoker_invoke_custom_legendary_illusion:DamageEvent_out(params)
if not IsServer() then return end 
if not params.attacker then return end 
if not params.unit:IsRealHero() then return end 
if self.caster ~= params.attacker then return end 
if self.targets[params.unit:GetTeamNumber()] then return end 

self.targets[params.unit:GetTeamNumber()] = true

AddFOWViewer(params.unit:GetTeamNumber(), self.parent:GetAbsOrigin(), 10, self:GetRemainingTime(), false)
end 


modifier_invoker_invoke_custom_legendary_tracker = class({})
function modifier_invoker_invoke_custom_legendary_tracker:IsHidden() return true end
function modifier_invoker_invoke_custom_legendary_tracker:IsPurgable() return false end

function modifier_invoker_invoke_custom_legendary_tracker:OnCreated()

self.parent = self:GetParent()
self.ability = self:GetAbility()
self.parent:AddDamageEvent_out(self)

self.stack_max = self.ability:GetSpecialValueFor("max")

self.damage_init = self.ability:GetSpecialValueFor("spell_amp")
self.damage_max = self.ability:GetSpecialValueFor("bonus_inc")
self.damage_inc = (self.damage_max - self.damage_init)/self.stack_max

self.heal_init = self.ability:GetSpecialValueFor("spell_lifesteal")
self.heal_max = self.ability:GetSpecialValueFor("bonus_inc")
self.heal_inc = (self.heal_max - self.heal_init)/self.stack_max

self.cd_init = self.ability:GetSpecialValueFor("cooldown_reduction")
self.cd_max = self.ability:GetSpecialValueFor("bonus_inc_cdr")
self.cd_inc = (self.cd_max - self.cd_init)/self.stack_max

self.bonus_active = self.ability:GetSpecialValueFor("bonus_active")
self.heal_creeps = self.ability:GetSpecialValueFor("spell_lifesteal_creep")

if not IsServer() then return end 
self.parent:AddNewModifier(self.parent, self.ability, "modifier_invoker_invoke_custom_legendary_stacks", {})
end 

function modifier_invoker_invoke_custom_legendary_tracker:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
    MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE
}
end

function modifier_invoker_invoke_custom_legendary_tracker:GetModifierSpellAmplify_Percentage() 
local bonus = 1 
if self.parent:HasModifier("modifier_invoker_invoke_custom_legendary") then 
    bonus = self.bonus_active
end 
return (self.damage_init + self.damage_inc*self.parent:GetUpgradeStack("modifier_invoker_invoke_custom_legendary_stacks"))*bonus
end

function modifier_invoker_invoke_custom_legendary_tracker:GetModifierPercentageCooldown()
local bonus = 1 
if self.parent:HasModifier("modifier_invoker_invoke_custom_legendary") then 
    bonus = self.bonus_active
end 
return (self.cd_init + self.cd_inc*self.parent:GetUpgradeStack("modifier_invoker_invoke_custom_legendary_stacks"))*bonus
end


function modifier_invoker_invoke_custom_legendary_tracker:DamageEvent_out( params )
if not IsServer() then return end 
if not self.parent:CheckLifesteal(params, 1) then return end

local bonus = 1 

if self.parent:HasModifier("modifier_invoker_invoke_custom_legendary") then 
    bonus = self.bonus_active
end 

local heal = (self.heal_init + self.heal_inc*self.parent:GetUpgradeStack("modifier_invoker_invoke_custom_legendary_stacks"))*bonus

if params.unit:IsCreep() then 
    heal = heal*self.heal_creeps
end 

self.parent:GenericHeal(params.damage*heal/100, self.ability, true, "particles/items3_fx/octarine_core_lifesteal.vpcf")
end 




modifier_invoker_invoke_custom_legendary_stacks = class({})
function modifier_invoker_invoke_custom_legendary_stacks:IsHidden() return false end
function modifier_invoker_invoke_custom_legendary_stacks:IsPurgable() return false end
function modifier_invoker_invoke_custom_legendary_stacks:RemoveOnDeath() return false end
function modifier_invoker_invoke_custom_legendary_stacks:OnCreated()

self.parent = self:GetParent()
self.ability = self:GetAbility()

self.stack_max = self.ability:GetSpecialValueFor("max")
self.bonus_active = self.ability:GetSpecialValueFor("bonus_active")

self.damage_init = self.ability:GetSpecialValueFor("spell_amp")
self.damage_max = self.ability:GetSpecialValueFor("bonus_inc")
self.damage_inc = (self.damage_max - self.damage_init)/self.stack_max

self.heal_init = self.ability:GetSpecialValueFor("spell_lifesteal")
self.heal_max = self.ability:GetSpecialValueFor("bonus_inc")
self.heal_inc = (self.heal_max - self.heal_init)/self.stack_max

self.cd_init = self.ability:GetSpecialValueFor("cooldown_reduction")
self.cd_max = self.ability:GetSpecialValueFor("bonus_inc_cdr")
self.cd_inc = (self.cd_max - self.cd_init)/self.stack_max

self:SetStackCount(0)
end

function modifier_invoker_invoke_custom_legendary_stacks:AddStack()
if not self.parent:FindItemInInventory("item_invoker_custom_legendary") then return end

if self:GetStackCount() < self.stack_max then 
    self:IncrementStackCount()
end 

end 

function modifier_invoker_invoke_custom_legendary_stacks:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_TOOLTIP,
    MODIFIER_PROPERTY_TOOLTIP2
}

end

function modifier_invoker_invoke_custom_legendary_stacks:OnTooltip()
if not self.parent:HasModifier("modifier_invoker_invoke_custom_legendary_tracker") then return end
local bonus = 1 
if self:GetCaster():HasModifier("modifier_invoker_invoke_custom_legendary") then 
    bonus = self.bonus_active
end 
return (self.damage_init + self.damage_inc*self.parent:GetUpgradeStack("modifier_invoker_invoke_custom_legendary_stacks"))*bonus
end


function modifier_invoker_invoke_custom_legendary_stacks:OnTooltip2()
if not self.parent:HasModifier("modifier_invoker_invoke_custom_legendary_tracker") then return end
local bonus = 1 
if self:GetCaster():HasModifier("modifier_invoker_invoke_custom_legendary") then 
    bonus = self.bonus_active
end 
return (self.cd_init + self.cd_inc*self.parent:GetUpgradeStack("modifier_invoker_invoke_custom_legendary_stacks"))*bonus
end




modifier_invoker_deafening_blast_custom_cd = class({})
function modifier_invoker_deafening_blast_custom_cd:IsHidden() return false end
function modifier_invoker_deafening_blast_custom_cd:IsPurgable() return false end
function modifier_invoker_deafening_blast_custom_cd:RemoveOnDeath() return false end
function modifier_invoker_deafening_blast_custom_cd:GetTexture() return "buffs/blast_lowhp" end
function modifier_invoker_deafening_blast_custom_cd:OnCreated()
self.RemoveForDuel = true
end

function modifier_invoker_deafening_blast_custom_cd:IsDebuff() return true end







modifier_invoker_invoke_custom_move = class({})
function modifier_invoker_invoke_custom_move:IsHidden() return false end
function modifier_invoker_invoke_custom_move:IsPurgable() return false end
function modifier_invoker_invoke_custom_move:GetTexture() return "buffs/wex_move" end
function modifier_invoker_invoke_custom_move:OnCreated()
self.move = self:GetCaster():GetTalentValue("modifier_invoker_invoke_2", "move")
self.status = self:GetCaster():GetTalentValue("modifier_invoker_invoke_2", "status")

if not IsServer() then return end 
self.max = self:GetCaster():GetTalentValue("modifier_invoker_invoke_2", "max")
self:SetStackCount(1)
end 

function modifier_invoker_invoke_custom_move:OnRefresh()
if not IsServer() then return end 
if self:GetStackCount() >= self.max then return end 
self:IncrementStackCount()
end 

function modifier_invoker_invoke_custom_move:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING
}
end

function modifier_invoker_invoke_custom_move:GetModifierStatusResistanceStacking() 
return self:GetStackCount()*self.status
end

function modifier_invoker_invoke_custom_move:GetModifierMoveSpeedBonus_Percentage()
return self:GetStackCount()*self.move
end




modifier_invoker_invoke_custom_scepter = class({})
function modifier_invoker_invoke_custom_scepter:IsHidden() return false end
function modifier_invoker_invoke_custom_scepter:IsPurgable() return false end
function modifier_invoker_invoke_custom_scepter:RemoveOnDeath() return false end

function modifier_invoker_invoke_custom_scepter:OnCreated()
if not IsServer() then return end

self.nFXIndex = ParticleManager:CreateParticle("particles/invoker/invoker_scepter.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControl(self.nFXIndex, 0, self:GetParent():GetOrigin())
self:AddParticle(self.nFXIndex, false, false, 1, true, false)

self:GetCaster():EmitSound("Lina.Array_triple")
end 






modifier_invoker_invoke_custom_scepter_cd = class({})
function modifier_invoker_invoke_custom_scepter_cd:IsHidden() return false end
function modifier_invoker_invoke_custom_scepter_cd:IsPurgable() return false end
function modifier_invoker_invoke_custom_scepter_cd:RemoveOnDeath() return false end
function modifier_invoker_invoke_custom_scepter_cd:GetTexture() return "item_ultimate_scepter" end
function modifier_invoker_invoke_custom_scepter_cd:OnCreated()
self.RemoveForDuel = true
end

function modifier_invoker_invoke_custom_scepter_cd:IsDebuff() return true end


function modifier_invoker_invoke_custom_scepter_cd:OnDestroy()
if not IsServer() then return end 
self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_invoker_invoke_custom_scepter", {})
end 





modifier_invoker_invoke_custom_cast = class({})
function modifier_invoker_invoke_custom_cast:IsHidden() return true end
function modifier_invoker_invoke_custom_cast:IsPurgable() return false end
function modifier_invoker_invoke_custom_cast:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_invoker_invoke_custom_cast:OnDestroy()
if not IsServer() then return end 

local mod = self:GetParent():FindModifierByName("modifier_invoker_invoke_custom_cast_count")

if mod then 
    mod:DecrementStackCount()

    if mod:GetStackCount() < 1 then
        mod:Destroy()
    end
end 

end 

modifier_invoker_invoke_custom_cast_count = class({})
function modifier_invoker_invoke_custom_cast_count:IsHidden() return false end
function modifier_invoker_invoke_custom_cast_count:IsPurgable() return false end
function modifier_invoker_invoke_custom_cast_count:GetTexture() return "buffs/invoke_cast" end
function modifier_invoker_invoke_custom_cast_count:OnCreated()
self.caster = self:GetCaster()
self.damage = self.caster:GetTalentValue("modifier_invoker_invoke_4", "damage")
self.str = self.caster:GetTalentValue("modifier_invoker_invoke_4", "str")

if not IsServer() then return end 
self:SetStackCount(1)
end 

function modifier_invoker_invoke_custom_cast_count:OnRefresh()
if not IsServer() then return end 
self:IncrementStackCount()
end 


function modifier_invoker_invoke_custom_cast_count:OnStackCountChanged(iStackCount)
if not IsServer() then return end
self.caster:CalculateStatBonus(true)
end

function modifier_invoker_invoke_custom_cast_count:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
    MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
}
end

function modifier_invoker_invoke_custom_cast_count:GetModifierSpellAmplify_Percentage()
return self.damage*self:GetStackCount()
end 

function modifier_invoker_invoke_custom_cast_count:GetModifierBonusStats_Strength()
return self.str*self:GetStackCount()
end






modifier_invoker_invoke_custom_exort_damage = class({})
function modifier_invoker_invoke_custom_exort_damage:IsPurgable() return true end
function modifier_invoker_invoke_custom_exort_damage:IsHidden() return true end
function modifier_invoker_invoke_custom_exort_damage:OnCreated()
if not IsServer() then return end 
self.caster = self:GetCaster()
self:SetStackCount(self.caster:GetExortDamage())
end

function modifier_invoker_invoke_custom_exort_damage:OnRefresh()
self:OnCreated()
end

function modifier_invoker_invoke_custom_exort_damage:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
}
end

function modifier_invoker_invoke_custom_exort_damage:GetModifierIncomingDamage_Percentage(params)
if not params.inflictor then return end 
return self:GetStackCount()
end

function modifier_invoker_invoke_custom_exort_damage:GetEffectName()
return "particles/items2_fx/veil_of_discord_debuff.vpcf"
end






modifier_invoker_invoke_custom_shield = class({})
function modifier_invoker_invoke_custom_shield:IsHidden()  return false end
function modifier_invoker_invoke_custom_shield:GetTexture() return "buffs/laguna_shield" end
function modifier_invoker_invoke_custom_shield:IsPurgable() return false end
function modifier_invoker_invoke_custom_shield:OnCreated(table)

self.parent = self:GetParent()
self.shield_talent = "modifier_invoker_invoke_3"

self.shield = self.parent:GetTalentValue("modifier_invoker_invoke_3", "shield")
self.max = self.parent:GetTalentValue("modifier_invoker_invoke_3", "max")

self.add_shield =  self.shield
self.max_shield = self.add_shield*self.max

if not IsServer() then return end

self.RemoveForDuel = true
self:AddShield()
end

function modifier_invoker_invoke_custom_shield:OnRefresh()
self:OnCreated()
end 

function modifier_invoker_invoke_custom_shield:AddShield()
if not IsServer() then return end
self:SetStackCount(math.min(self.max_shield, self:GetStackCount() + self.add_shield))
end 


function modifier_invoker_invoke_custom_shield:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_INCOMING_DAMAGE_CONSTANT,
}
end


function modifier_invoker_invoke_custom_shield:GetModifierIncomingDamageConstant( params )
if IsClient() then 
    if params.report_max then 
        return self.max_shield
    else 
        return self:GetStackCount()
    end 
end

if not IsServer() then return end

local damage = math.min(params.damage, self:GetStackCount())
self.parent:AddShieldInfo({shield_mod = self, healing = damage, healing_type = "shield"})

self:SetStackCount(self:GetStackCount() - damage)
if self:GetStackCount() <= 0 then
  self:Destroy()
end

return -damage
end
