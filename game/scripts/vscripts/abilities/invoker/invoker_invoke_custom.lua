LinkLuaModifier("modifier_invoker_deafening_blast_custom", "abilities/invoker/invoker_invoke_custom",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_invoker_invoke_custom_legendary", "abilities/invoker/invoker_invoke_custom",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_invoker_invoke_custom_legendary_tracker", "abilities/invoker/invoker_invoke_custom",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_invoker_invoke_custom_legendary_stacks", "abilities/invoker/invoker_invoke_custom",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_invoker_invoke_custom_legendary_illusion", "abilities/invoker/invoker_invoke_custom",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_invoker_invoke_custom_tracker", "abilities/invoker/invoker_invoke_custom",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_invoker_invoke_custom_move", "abilities/invoker/invoker_invoke_custom",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_invoker_deafening_blast_custom_cd", "abilities/invoker/invoker_invoke_custom",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_invoker_deafening_blast_custom_damage", "abilities/invoker/invoker_invoke_custom",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_invoker_invoke_custom_scepter", "abilities/invoker/invoker_invoke_custom",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_invoker_invoke_custom_scepter_cd", "abilities/invoker/invoker_invoke_custom",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_invoker_invoke_custom_cast", "abilities/invoker/invoker_invoke_custom",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_invoker_invoke_custom_cast_count", "abilities/invoker/invoker_invoke_custom",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_invoker_invoke_custom_heal", "abilities/invoker/invoker_invoke_custom",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_invoker_invoke_custom_heal_count", "abilities/invoker/invoker_invoke_custom",LUA_MODIFIER_MOTION_NONE )

invoker_invoke_custom = class({})

function invoker_invoke_custom:Precache(context)
    PrecacheResource( "particle", "particles/units/heroes/hero_invoker/invoker_invoke.vpcf", context )
end

function invoker_invoke_custom:ProcsMagicStick()
    return false
end


function invoker_invoke_custom:GetIntrinsicModifierName()
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


function invoker_invoke_custom:AbilityHit()
if not IsServer() then return end 

local mod = self:GetCaster():FindModifierByName("modifier_invoker_invoke_custom_legendary_stacks")

if mod then 
    mod:AddStack()
end 

if self:GetCaster():GetQuest() == "Invoker.Quest_8" and not self:GetCaster():QuestCompleted() then 
    self:GetCaster():UpdateQuest(1)
end 


end 




function invoker_invoke_custom:UseScepter()

local cd = self:GetSpecialValueFor("scepter_cd")
self:GetCaster():RemoveModifierByName("modifier_invoker_invoke_custom_scepter")
self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_invoker_invoke_custom_scepter_cd", {duration = cd})

local item = self:GetCaster():FindItemInInventory("item_ultimate_scepter")

if item then 
    item:StartCooldown(cd)
end 

local particle_peffect = ParticleManager:CreateParticle("particles/maiden_shield_active.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
ParticleManager:SetParticleControl(particle_peffect, 0, self:GetCaster():GetAbsOrigin())
ParticleManager:SetParticleControl(particle_peffect, 2, self:GetCaster():GetAbsOrigin())
ParticleManager:ReleaseParticleIndex(particle_peffect)
self:GetCaster():EmitSound("Invoker.Scepter_activate")

--self:ToggleAutoCast()

end 

--[[
function invoker_invoke_custom:GetAbilityTextureName()
if self:GetCaster():HasScepter() and not self:GetCaster():HasModifier("modifier_invoker_invoke_custom_scepter_cd") then 
    --return "invoker_invoke_aghanim"
else
    return "invoker_invoke"
end

end
]]--

function invoker_invoke_custom:GetBehavior()
local bonus = 0


if self:GetCaster():HasScepter()  then 
    bonus = DOTA_ABILITY_BEHAVIOR_AUTOCAST
end 

return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_SHOW_IN_GUIDES + DOTA_ABILITY_BEHAVIOR_NOT_LEARNABLE + bonus
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


return cooldown * (1 - self:GetCaster():GetWexCd()/100)
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
    MODIFIER_EVENT_ON_DEATH,
    MODIFIER_EVENT_ON_TAKEDAMAGE,
    MODIFIER_EVENT_ON_ABILITY_EXECUTED,
    MODIFIER_EVENT_ON_RESPAWN,
    MODIFIER_PROPERTY_MANACOST_PERCENTAGE
}
end


function modifier_invoker_invoke_custom_tracker:GetModifierPercentageManacost()
local reduce = 0

if self:GetCaster():HasModifier("modifier_invoker_invoke_3") then 
    reduce = self:GetCaster():GetTalentValue("modifier_invoker_invoke_3", "mana")
end

return reduce
end



function modifier_invoker_invoke_custom_tracker:OnCreated()
if not IsServer() then return end 
if not self:GetParent():IsRealHero() then return end
self:StartIntervalThink(0.5)
end 

function modifier_invoker_invoke_custom_tracker:OnIntervalThink()
if not IsServer() then return end 

if self:GetCaster():HasScepter() and
 not self:GetCaster():HasModifier("modifier_invoker_invoke_custom_scepter_cd") and
  not self:GetCaster():HasModifier("modifier_invoker_invoke_custom_scepter") then 

    self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_invoker_invoke_custom_scepter", {})
end 

if not self:GetCaster():HasScepter() and self:GetCaster():HasModifier("modifier_invoker_invoke_custom_scepter") then 
    self:GetCaster():RemoveModifierByName("modifier_invoker_invoke_custom_scepter")
end

end 


function modifier_invoker_invoke_custom_tracker:OnAbilityExecuted( params )
if not IsServer() then return end
if params.unit~=self:GetParent() then return end
if not params.ability then return end
if params.ability:IsToggle() then return end
if UnvalidAbilities[params.ability:GetName()] then return end
if UnvalidItems[params.ability:GetName()] then return end
if  params.ability:IsItem()  and params.ability:GetCurrentCharges() > 0 then return end
if params.ability:GetName() == "invoker_quas_custom" or 
    params.ability:GetName() == "invoker_exort_custom" or 
    params.ability:GetName() == "invoker_wex_custom" or 
    params.ability:GetName() == "invoker_invoke_custom"  then return end


if self:GetCaster():HasModifier("modifier_invoker_invoke_4") then 
    local duration = self:GetCaster():GetTalentValue("modifier_invoker_invoke_4", "duration")

    self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_invoker_invoke_custom_cast_count", {duration = duration})
    self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_invoker_invoke_custom_cast", {duration = duration})
end 


if params.ability:IsItem() then return end

if self:GetCaster():HasModifier("modifier_invoker_invoke_2") then 
    self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_invoker_invoke_custom_move", {duration = self:GetCaster():GetTalentValue("modifier_invoker_invoke_2", "duration")})
end 

if self:GetCaster():HasModifier("modifier_invoker_invoke_6") then 
    self:GetCaster():CdItems(self:GetCaster():GetTalentValue("modifier_invoker_invoke_6", "cd"))    
end 


if self:GetCaster():HasModifier("modifier_invoker_invoke_3") then 
    local duration = self:GetCaster():GetTalentValue("modifier_invoker_invoke_3", "duration")

    self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_invoker_invoke_custom_heal_count", {duration = duration})
    self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_invoker_invoke_custom_heal", {duration = duration})
end 


end 





function modifier_invoker_invoke_custom_tracker:OnTakeDamage(params)
if not IsServer() then return end 
if not self:GetParent():HasModifier("modifier_invoker_invoke_5") then return end
if self:GetParent():GetHealthPercent() > self:GetCaster():GetTalentValue("modifier_invoker_invoke_5", "health") then return end 
if self:GetParent() ~= params.unit then return end 
if self:GetParent():PassivesDisabled() then return end 
if self:GetParent():HasModifier("modifier_invoker_deafening_blast_custom_cd") then return end 


local ability = self:GetCaster():FindAbilityByName("invoker_deafening_blast_custom")
if ability then 
    ability:OnSpellStart(true)
end 

self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_invoker_deafening_blast_custom_cd", {duration = self:GetCaster():GetTalentValue("modifier_invoker_invoke_5", "cd")})
--self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_invoker_deafening_blast_custom_damage", {duration = self:GetCaster():GetTalentValue("modifier_invoker_invoke_5", "duration")})

end 

function modifier_invoker_invoke_custom_tracker:OnDeath(params)
if not IsServer() then return end 
if not self:GetParent():IsRealHero() then return end
if params.unit ~= self:GetParent() then return end 


orb_manager:DestroyParticles(self:GetParent())
end 

function modifier_invoker_invoke_custom_tracker:OnRespawn(params)
if not IsServer() then return end 
if not self:GetParent():IsRealHero() then return end
if params.unit ~= self:GetParent() then return end 


orb_manager:RestoreParticles(self:GetParent())
end 


invoker_deafening_blast_custom = class({})

function invoker_deafening_blast_custom:Precache(context)
    PrecacheResource( "particle", "particles/units/heroes/hero_invoker/invoker_deafening_blast.vpcf", context )
    PrecacheResource( "particle", "particles/units/heroes/hero_invoker/invoker_deafening_blast_knockback_debuff.vpcf", context )
    PrecacheResource( "particle", "particles/units/heroes/hero_invoker/invoker_deafening_blast_disarm_debuff.vpcf", context )
    PrecacheResource( "particle", "particles/status_fx/status_effect_iceblast.vpcf", context )
end

function invoker_deafening_blast_custom:GetAbilityTextureName()
if self:GetCaster():HasScepter() and not self:GetCaster():HasModifier("modifier_invoker_invoke_custom_scepter_cd") then 
    return "invoker_deafening_blast_aghanim"
else
    return "invoker_deafening_blast"
end

end




function invoker_deafening_blast_custom:GetCooldown(level)

local bonus = 0

if self:GetCaster():HasModifier("modifier_invoker_invoke_1") then 
    bonus = self:GetCaster():GetTalentValue("modifier_invoker_invoke_1", "cd")
end 

return (self.BaseClass.GetCooldown( self, self:GetLevel() ) + bonus) * (1 - self:GetCaster():GetWexCd()/100)

end 




function invoker_deafening_blast_custom:GetManaCost(level)
    return self.BaseClass.GetManaCost(self, level)
end



function invoker_deafening_blast_custom:OnSpellStart(aoe)
if not IsServer() then return end

local exort = self:GetCaster():GetExortDamage()/100
local quas = self:GetCaster():GetQuasHeal()/100

local ult = self:GetCaster():FindAbilityByName("invoker_invoke_custom")
local scepter = 0

local scepter_damage = 0
local scepter_heal = 0

if self:GetCaster():HasScepter() and ult and ult:GetAutoCastState() == true and not aoe
    and not self:GetCaster():HasModifier("modifier_invoker_invoke_custom_scepter_cd") then

    scepter_damage = self:GetSpecialValueFor("scepter_damage")/100
    scepter_heal = self:GetSpecialValueFor("scepter_heal")/100

    self:GetCaster():CdAbility(self, self:GetCooldownTimeRemaining()*self:GetSpecialValueFor("scepter_cd")/100)

    ult:UseScepter()
end 



self:GetCaster():StartGesture(ACT_DOTA_CAST_DEAFENING_BLAST)

local caster = self:GetCaster()
local target_loc = self:GetCursorPosition()
local caster_loc = caster:GetAbsOrigin()
local distance = self:GetCastRange(caster_loc,caster)

if target_loc == self:GetCaster():GetAbsOrigin() then
    target_loc = target_loc + self:GetCaster():GetForwardVector()
end

local direction = (target_loc - caster_loc):Normalized()

local index = DoUniqueString("invoker_deafening_blast_custom")
self[index] = {}

local travel_distance = self:GetSpecialValueFor("travel_distance")
local travel_speed = self:GetSpecialValueFor("travel_speed")
local radius_start = self:GetSpecialValueFor("radius_start")
local radius_end = self:GetSpecialValueFor("radius_end")

local projectile =
{
    Ability             = self,
    EffectName          = "particles/units/heroes/hero_invoker/invoker_deafening_blast.vpcf",
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
    ExtraData           = {index = index, quas = quas, exort = exort, scepter_damage = scepter_damage, scepter_heal = scepter_heal}
}


local count = 0
if aoe and aoe == true then 
    count = self:GetCaster():GetTalentValue("modifier_invoker_invoke_5", "count")
end 

for i=0,count do
    projectile.vVelocity = RotatePosition(Vector(0,0,0), QAngle(0,i*30,0), direction) * travel_speed
    ProjectileManager:CreateLinearProjectile(projectile)
end

caster:EmitSound("Hero_Invoker.DeafeningBlast")
end



function invoker_deafening_blast_custom:OnProjectileHit_ExtraData(target, location, ExtraData)
if target then

    local was_hit = false

    for _, stored_target in ipairs(self[ExtraData.index]) do
        if target == stored_target then
            was_hit = true
            break
        end
    end

    if was_hit then
        return false
    end

    table.insert(self[ExtraData.index],target)

    local damage = self:GetCaster():GetValueExort(self, "damage")
    local knockback_duration = self:GetCaster():GetValueQuas(self, "knockback_duration")
    local knockback_distance = self:GetCaster():GetValueQuas(self, "knockback_distance")
    local disarm_duration = self:GetCaster():GetValueWex(self, "disarm_duration")

    if self:GetCaster():HasModifier("modifier_invoker_invoke_1") then 
        damage = damage + (self:GetCaster():GetTalentValue("modifier_invoker_invoke_1", "damage")/100)*self:GetCaster():GetIntellect()
    end 

    local bonus = ExtraData.scepter_damage

    if self:GetCaster():HasModifier("modifier_invoker_invoke_4") then

        local mod = self:GetCaster():FindModifierByName("modifier_invoker_invoke_custom_cast_count")

        if mod then 
            bonus = bonus + mod:GetStackCount()*self:GetCaster():GetTalentValue("modifier_invoker_invoke_4", "blast_damage")/100
        end 
    end 


    damage = damage*(1 + bonus)

    if ExtraData.exort and ExtraData.exort > 0 then 
      damage = damage * (1 + ExtraData.exort)
    end 


    if target:IsRealHero() then 
        local ability = self:GetCaster():FindAbilityByName("invoker_invoke_custom")
        if ability then 
            ability:AbilityHit()
        end 
    end


    local center = location

    if location == target:GetAbsOrigin() then 
        center = self:GetCaster():GetAbsOrigin()
    end 

    local direction = (target:GetAbsOrigin() - center):Normalized()
    direction.z = 0

    local point = target:GetAbsOrigin() + direction*knockback_distance

    local knockback = target:AddNewModifier( self:GetCaster(), self, "modifier_generic_arc",
    {
        target_x = point.x,
        target_y = point.y,
        distance = knockback_distance,
        duration = knockback_duration,
        height = 0,
        fix_end = true,
        isStun = false,
    })

    if not self[ExtraData.index].hit_hero and target:IsRealHero() then 
        self[ExtraData.index].hit_hero = true

        local mod = self:GetCaster():FindModifierByName("modifier_invoker_chaos_meteor_custom_cataclysm_stack")

        if mod then 
          --  mod:AddStack()
        end 
    end 

    local real_damage = ApplyDamage({victim = target, attacker = self:GetCaster(), damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self})


    if not target:IsIllusion() then

        local heal = ExtraData.scepter_heal

        if ExtraData.quas and ExtraData.quas > 0 then
            heal = heal + ExtraData.quas
        end 

        heal = real_damage*heal

        if target:IsCreep() then 
            heal = heal/3
        end 

        self:GetCaster():GenericHeal(heal, self, true, "particles/items3_fx/octarine_core_lifesteal.vpcf")
    end


    target:AddNewModifier(self:GetCaster(), self, "modifier_invoker_deafening_blast_custom", {duration = disarm_duration * (1 - target:GetStatusResistance())})

    if knockback then
        local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_deafening_blast_knockback_debuff.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
        knockback:AddParticle(particle, false, false, -1, false, false)
    end
else
    self[ExtraData.index]["count"] = self[ExtraData.index]["count"] or 0
    self[ExtraData.index]["count"] = self[ExtraData.index]["count"] + 1
    if self[ExtraData.index]["count"] == ExtraData.arrows then
        self[ExtraData.index] = nil
    end
end

end

modifier_invoker_deafening_blast_custom = class({})

function modifier_invoker_deafening_blast_custom:IsPurgable()
    return false
end

function modifier_invoker_deafening_blast_custom:IsPurgeException()
    return false
end

function modifier_invoker_deafening_blast_custom:GetEffectName() return "particles/units/heroes/hero_invoker/invoker_deafening_blast_disarm_debuff.vpcf" end
function modifier_invoker_deafening_blast_custom:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
function modifier_invoker_deafening_blast_custom:GetStatusEffectName() return "particles/status_fx/status_effect_iceblast.vpcf" end
function modifier_invoker_deafening_blast_custom:StatusEffectPriority() return 10 end

function modifier_invoker_deafening_blast_custom:CheckState() 
    local state = 
    {
        [MODIFIER_STATE_DISARMED] = true,
    }
    return state
end




function modifier_invoker_deafening_blast_custom:OnCreated()
self.damage = self:GetCaster():GetTalentValue("modifier_invoker_invoke_5", "damage")
end 



function modifier_invoker_deafening_blast_custom:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
}
end


function modifier_invoker_deafening_blast_custom:GetModifierTotalDamageOutgoing_Percentage()
return self.damage
end





item_invoker_custom_legendary = class({})

function item_invoker_custom_legendary:GetIntrinsicModifierName()
return "modifier_invoker_invoke_custom_legendary_tracker"   
end



function item_invoker_custom_legendary:OnSpellStart()

self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_invoker_invoke_custom_legendary", {duration = self:GetCaster():GetTalentValue("modifier_invoker_invoke_7", "duration", true)})
end 


modifier_invoker_invoke_custom_legendary = class({})
function modifier_invoker_invoke_custom_legendary:IsHidden() return true end
function modifier_invoker_invoke_custom_legendary:IsPurgable() return false end
function modifier_invoker_invoke_custom_legendary:GetEffectName()
return "particles/invoker/item_speed.vpcf"
end
function modifier_invoker_invoke_custom_legendary:GetStatusEffectName() return "particles/status_fx/status_effect_huskar_lifebreak.vpcf" end
function modifier_invoker_invoke_custom_legendary:StatusEffectPriority() return 999999 end


function modifier_invoker_invoke_custom_legendary:OnCreated(table)
if not IsServer() then return end 
self.RemoveForDuel = true


local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_dark_seer/dark_seer_surge.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
self:AddParticle(particle, false, false, -1, false, false)

particle = ParticleManager:CreateParticle("particles/invoker/invoke_legendary_clock.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
self:AddParticle(particle, false, false, -1, false, false)

particle = ParticleManager:CreateParticle("particles/econ/items/faceless_void/faceless_void_bracers_of_aeons/fv_bracers_of_aeons_dialatedebuf.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
self:AddParticle(particle, false, false, -1, false, false)


self:GetParent():EmitSound("Invoker.Invoke_legendary_start")
self:GetParent():EmitSound("Invoker.Invoke_legendary_loop")

self.pos = self:GetParent():GetAbsOrigin()
self.parent = self:GetParent()

self.health_level = self.parent:GetHealthPercent()/100
self.mana_level = self.parent:GetManaPercent()/100

local illusion_self = CreateIllusions(self:GetCaster(), self:GetCaster(), {
outgoing_damage = 0,
duration        = self:GetRemainingTime() + 0.2 
}, 1, 0, false, false)

for _,illusion in pairs(illusion_self) do
    illusion.owner = caster
    illusion:AddNewModifier(illusion, self:GetAbility(), "modifier_invoker_invoke_custom_legendary_illusion", {})
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
            local particle = ParticleManager:CreateParticle(name, PATTACH_CUSTOMORIGIN, self.parent)
            ParticleManager:SetParticleControlEnt(particle, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_attack"..RandomInt(1, 2), self.parent:GetAbsOrigin(), false)
            ParticleManager:SetParticleControlEnt(particle, 1, self.parent, PATTACH_POINT_FOLLOW, self.parent.invoked_orbs_particle_attach[i], self.parent:GetAbsOrigin(), false)
            self:AddParticle(particle, false, false, -1, false, false)
        end
    end 
end

orb_manager:DestroyParticles(self:GetParent())

self.max_time = self:GetRemainingTime()

self:StartIntervalThink(FrameTime())
self:OnIntervalThink()
end 




function modifier_invoker_invoke_custom_legendary:OnIntervalThink()
if not IsServer() then return end 

CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetCaster():GetPlayerOwnerID()), 'invoker_ult_change',  {hide = 0, max_time = self.max_time, time = (self.max_time - self:GetElapsedTime()), damage = self:GetRemainingTime()})

end 


function modifier_invoker_invoke_custom_legendary:OnDestroy()
if not IsServer() then return end 

CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetCaster():GetPlayerOwnerID()), 'invoker_ult_change',  {hide = 1, max_time = self.max_time, time = (self.max_time - self:GetElapsedTime()), damage = 0})


if self.illusion and not self.illusion:IsNull() then 
    self.illusion:Kill(nil, nil)
end 

self:GetParent():StopSound("Invoker.Invoke_legendary_loop")

if self:GetRemainingTime() > 0.1 then return end 
if not self.parent:IsAlive() then return end 


orb_manager:RestoreParticles(self:GetParent())

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


local particle = ParticleManager:CreateParticle("particles/econ/items/faceless_void/faceless_void_bracers_of_aeons/fv_bracers_of_aeons_dialatedebuf.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
self:AddParticle(particle, false, false, -1, false, false)


particle = ParticleManager:CreateParticle("particles/invoker/invoke_legendary_clock.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
self:AddParticle(particle, false, false, -1, false, false)


self.freeze = false

self:GetParent():StartGesture(ACT_DOTA_TELEPORT)
self:StartIntervalThink(0.4)
end

function modifier_invoker_invoke_custom_legendary_illusion:OnIntervalThink()
if not IsServer() then return end 

self.freeze = true
self:StartIntervalThink(-1)
end 


function modifier_invoker_invoke_custom_legendary_illusion:StatusEffectPriority()
    return 10010
end

function modifier_invoker_invoke_custom_legendary_illusion:CheckState()
return
{
    [MODIFIER_STATE_INVULNERABLE] = true,
    [MODIFIER_STATE_UNTARGETABLE] = true,
    [MODIFIER_STATE_UNSELECTABLE] = true,
    [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
  --  [MODIFIER_STATE_NO_HEALTH_BAR] = true,
    [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
    [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
    [MODIFIER_STATE_OUT_OF_GAME]    = true,
    [MODIFIER_STATE_STUNNED]    = true,
    [MODIFIER_STATE_FROZEN]    = self.freeze,
}

end




modifier_invoker_invoke_custom_legendary_tracker = class({})
function modifier_invoker_invoke_custom_legendary_tracker:IsHidden() return true end
function modifier_invoker_invoke_custom_legendary_tracker:IsPurgable() return false end



function modifier_invoker_invoke_custom_legendary_tracker:OnCreated()

self.damage_init = self:GetAbility():GetSpecialValueFor("spell_amp")
self.damage_inc = self:GetAbility():GetSpecialValueFor("bonus_inc")
self.heal_init = self:GetAbility():GetSpecialValueFor("spell_lifesteal")
self.heal_inc = self:GetAbility():GetSpecialValueFor("bonus_inc")
self.cd_init = self:GetAbility():GetSpecialValueFor("cooldown_reduction")
self.cd_inc = self:GetAbility():GetSpecialValueFor("bonus_inc_cdr")
self.bonus_active = self:GetAbility():GetSpecialValueFor("bonus_active")
self.max = self:GetAbility():GetSpecialValueFor("max")
self.heal_creeps = self:GetAbility():GetSpecialValueFor("spell_lifesteal_creep")
if not IsServer() then return end 

self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_invoker_invoke_custom_legendary_stacks", {})
end 


function modifier_invoker_invoke_custom_legendary_tracker:DeclareFunctions()
return
{
    MODIFIER_EVENT_ON_TAKEDAMAGE,
    MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
    MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE
}

end

function modifier_invoker_invoke_custom_legendary_tracker:GetModifierSpellAmplify_Percentage() 
local bonus = 1 

if self:GetCaster():HasModifier("modifier_invoker_invoke_custom_legendary") then 
    bonus = self.bonus_active
end 


return (self.damage_init + self.damage_inc*self:GetParent():GetUpgradeStack("modifier_invoker_invoke_custom_legendary_stacks"))*bonus
end


function modifier_invoker_invoke_custom_legendary_tracker:GetModifierPercentageCooldown()
local bonus = 1 

if self:GetCaster():HasModifier("modifier_invoker_invoke_custom_legendary") then 
    bonus = self.bonus_active
end 

return (self.cd_init + self.cd_inc*self:GetParent():GetUpgradeStack("modifier_invoker_invoke_custom_legendary_stacks"))*bonus
end




function modifier_invoker_invoke_custom_legendary_tracker:OnTakeDamage( params )
if not IsServer() then return end 
if not params.unit then return end
if not params.unit:IsCreep() and not params.unit:IsHero() then return end
if self:GetCaster() ~= params.attacker then return end
if params.unit:IsIllusion() then return end
if bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then return end
if not params.inflictor then return end

local bonus = 1 

if self:GetCaster():HasModifier("modifier_invoker_invoke_custom_legendary") then 
    bonus = self.bonus_active
end 

local heal = (self.heal_init + self.heal_inc*self:GetParent():GetUpgradeStack("modifier_invoker_invoke_custom_legendary_stacks"))*bonus

if params.unit:IsCreep() then 
    heal = heal*self.heal_creeps
end 

self:GetCaster():GenericHeal(params.damage*heal/100, self:GetAbility(), true, "particles/items3_fx/octarine_core_lifesteal.vpcf")

end 



modifier_invoker_invoke_custom_legendary_stacks = class({})
function modifier_invoker_invoke_custom_legendary_stacks:IsHidden() return false end
function modifier_invoker_invoke_custom_legendary_stacks:IsPurgable() return false end
function modifier_invoker_invoke_custom_legendary_stacks:RemoveOnDeath() return false end
function modifier_invoker_invoke_custom_legendary_stacks:OnCreated()

self.damage_init = self:GetAbility():GetSpecialValueFor("spell_amp")
self.damage_inc = self:GetAbility():GetSpecialValueFor("bonus_inc")
self.cd_init = self:GetAbility():GetSpecialValueFor("cooldown_reduction")
self.cd_inc = self:GetAbility():GetSpecialValueFor("bonus_inc_cdr")
self.bonus_active = self:GetAbility():GetSpecialValueFor("bonus_active")

self.max = self:GetAbility():GetSpecialValueFor("max")
self:SetStackCount(0)
end


function modifier_invoker_invoke_custom_legendary_stacks:AddStack()
if not self:GetParent():FindItemInInventory("item_invoker_custom_legendary") then return end

if self:GetStackCount() < self.max then 
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
if not self:GetParent():HasModifier("modifier_invoker_invoke_custom_legendary_tracker") then return end

local bonus = 1 

if self:GetCaster():HasModifier("modifier_invoker_invoke_custom_legendary") then 
    bonus = self.bonus_active
end 


return (self.damage_init + self.damage_inc*self:GetParent():GetUpgradeStack("modifier_invoker_invoke_custom_legendary_stacks"))*bonus
end


function modifier_invoker_invoke_custom_legendary_stacks:OnTooltip2()
if not self:GetParent():HasModifier("modifier_invoker_invoke_custom_legendary_tracker") then return end
local bonus = 1 

if self:GetCaster():HasModifier("modifier_invoker_invoke_custom_legendary") then 
    bonus = self.bonus_active
end 

return (self.cd_init + self.cd_inc*self:GetParent():GetUpgradeStack("modifier_invoker_invoke_custom_legendary_stacks"))*bonus
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




modifier_invoker_deafening_blast_custom_damage = class({})
function modifier_invoker_deafening_blast_custom_damage:IsHidden() return true end
function modifier_invoker_deafening_blast_custom_damage:IsPurgable() return false end
function modifier_invoker_deafening_blast_custom_damage:GetTexture() return "buffs/counter_cd" end
function modifier_invoker_deafening_blast_custom_damage:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
}
end


function modifier_invoker_deafening_blast_custom_damage:OnCreated(table)

self.damage = self:GetCaster():GetTalentValue("modifier_invoker_invoke_5", "damage")

if not IsServer() then return end

self:GetParent():EmitSound("Invoker.Blast_lowhp")
local shield_size = self:GetParent():GetModelRadius()*0.7

local particle = ParticleManager:CreateParticle("particles/zuus_shield_wrath.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
local common_vector = Vector(shield_size,0,shield_size)
ParticleManager:SetParticleControl(particle, 1, common_vector)
ParticleManager:SetParticleControl(particle, 2, common_vector)
ParticleManager:SetParticleControl(particle, 4, common_vector)

ParticleManager:SetParticleControlEnt(particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
self:AddParticle(particle, false, false, -1, false, false)

end


function modifier_invoker_deafening_blast_custom_damage:GetModifierIncomingDamage_Percentage()
 return self.damage
end





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
self.damage = self:GetCaster():GetTalentValue("modifier_invoker_invoke_4", "damage")

if not IsServer() then return end 

self:SetStackCount(1)
end 

function modifier_invoker_invoke_custom_cast_count:OnRefresh()
if not IsServer() then return end 
self:IncrementStackCount()

end 



function modifier_invoker_invoke_custom_cast_count:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
}
end


 


function modifier_invoker_invoke_custom_cast_count:GetModifierSpellAmplify_Percentage()
return self.damage*self:GetStackCount()
end 









modifier_invoker_invoke_custom_heal = class({})
function modifier_invoker_invoke_custom_heal:IsHidden() return true end
function modifier_invoker_invoke_custom_heal:IsPurgable() return false end
function modifier_invoker_invoke_custom_heal:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_invoker_invoke_custom_heal:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
}
end


function modifier_invoker_invoke_custom_heal:OnCreated(table)
self.heal = self:GetCaster():GetTalentValue("modifier_invoker_invoke_3", "heal")/self:GetRemainingTime()
end


function modifier_invoker_invoke_custom_heal:GetModifierConstantHealthRegen()
return self.heal
end


function modifier_invoker_invoke_custom_heal:OnDestroy()
if not IsServer() then return end

local mod = self:GetParent():FindModifierByName("modifier_invoker_invoke_custom_heal_count")

if mod then 
    mod:DecrementStackCount()
    if mod:GetStackCount() == 0 then 
        mod:Destroy()
    end
end

end


modifier_invoker_invoke_custom_heal_count = class({})
function modifier_invoker_invoke_custom_heal_count:GetTexture() return "buffs/arcane_regen" end
function modifier_invoker_invoke_custom_heal_count:IsHidden() return true end
function modifier_invoker_invoke_custom_heal_count:IsPurgable() return false end
function modifier_invoker_invoke_custom_heal_count:OnCreated(table)
self.heal = self:GetCaster():GetTalentValue("modifier_invoker_invoke_3", "heal")/self:GetCaster():GetTalentValue("modifier_invoker_invoke_3", "duration")

if not IsServer() then return end

self:SetStackCount(1)
end

function modifier_invoker_invoke_custom_heal_count:OnRefresh(table)
if not IsServer() then return end

self:IncrementStackCount()
end

function modifier_invoker_invoke_custom_heal_count:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_TOOLTIP
}
end

function modifier_invoker_invoke_custom_heal_count:OnTooltip()
return self:GetStackCount()*self.heal
end
