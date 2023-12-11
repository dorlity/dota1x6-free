LinkLuaModifier( "modifier_voice_module_move_attack_cd", "modifiers/modifier_voice_module", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_voice_module_cast_cd", "modifiers/modifier_voice_module", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_voice_module_damage_cd", "modifiers/modifier_voice_module", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_voice_module_active", "modifiers/modifier_voice_module", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_voice_module_lasthit_cd", "modifiers/modifier_voice_module", LUA_MODIFIER_MOTION_NONE)


modifier_voice_module = class({})


function modifier_voice_module:IsHidden() return true end
function modifier_voice_module:IsPurgable() return false end 
function modifier_voice_module:RemoveOnDeath() return false end

function modifier_voice_module:OnCreated(table)

self.parent = self:GetParent()

self.sound = nil
self.for_player = nil
self.more_players = -1

self.attack_move_cd = 6
self.cast_cd = 6
self.lasthit_cd = 30
self.damage_cd = 4
self.kill_timer = 2

self.rivaL_chance = 30

if false and test then 
    self.rivaL_chance = 100
    self.cast_cd = 2
    self.lasthit_cd = 1
    self.attack_move_cd = 2
end 

if false then 
    self:Destroy()
    return
end 

end

function modifier_voice_module:GetNumber(number, hundred)

local str = tostring(number)

if hundred and hundred == 1 then 
    
    if number < 10 then 
        str = "00"..tostring(number)
    elseif number < 100 then 
        str = "0"..tostring(number)
    end 

    return str
end 


if number < 10 then 
    str = "0"..tostring(number)
end    

return str
end 



function modifier_voice_module:OnIntervalThink()
if not IsServer() then return end 
if self.sound == nil then return end 
if self.for_player == nil then return end 

local sound = self.sound
self.sound = nil

self:MakeSound(sound, self.for_player, 0, self.more_players, self.priority, self.global)


self.global = nil
self.priority = nil
self.for_player = nil
self.more_players = -1

self:StartIntervalThink(-1)
end 




function modifier_voice_module:MakeSound(sound, player_only, timer, more_players, priority, global)
if not IsServer() then return end 
if self:GetParent():IsHexed() then return end
if self.sound ~= nil and not priority then return false end

if timer and timer > 0 then 
    
    self.sound = sound
    self.for_player = player_only or false
    self.more_players = more_players or -1
    self.global = global or false
    self.priority = priority or false

    self:StartIntervalThink(timer)
    return
end 

if self.parent:HasModifier("modifier_voice_module_active") and not priority then return false end

print(sound)

if more_players and more_players ~= -1 then 
    EmitAnnouncerSoundForPlayer(sound, more_players)
end

self.parent:AddNewModifier(self.parent, nil, "modifier_voice_module_active", {duration = self.parent:GetSoundDuration(sound, nil)})

if global and global == true then 
    EmitAnnouncerSound(sound)
    return
end 



if player_only then 
    EmitAnnouncerSoundForPlayer(sound, self.parent:GetPlayerOwnerID())
else
    self.parent:EmitSound(sound)
end 

return true
end 




function modifier_voice_module:DeclareFunctions()
return
{
    MODIFIER_EVENT_ON_ORDER,
    MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
    MODIFIER_EVENT_ON_ABILITY_START,
    MODIFIER_EVENT_ON_TAKEDAMAGE,
    MODIFIER_EVENT_ON_DEATH,
}
end 






function modifier_voice_module:OnOrder(ord)
if not IsServer() then return end
if self.parent:HasModifier("modifier_voice_module_active") then return end
if ord.unit~=self.parent then return end

local type = ord.order_type
local sounds = {}
local activity = 0
local string_table = {}


if not self.parent:HasModifier("modifier_voice_module_move_attack_cd") then 

    if type == DOTA_UNIT_ORDER_MOVE_TO_POSITION or type == DOTA_UNIT_ORDER_MOVE_TO_TARGET then 

        activity = 1
        string_table = self:GetMoveVoice()
    end


    if type == DOTA_UNIT_ORDER_ATTACK_MOVE or type == DOTA_UNIT_ORDER_ATTACK_TARGET then 

        activity = 1
        string_table = self:GetAttackVoice()
    end
end

if ord.ability and not self.parent:HasModifier("modifier_voice_module_cast_cd") and (type == DOTA_UNIT_ORDER_CAST_POSITION or type == DOTA_UNIT_ORDER_CAST_TARGET) then 

    local range = ord.ability:GetCastRange(self.parent:GetAbsOrigin(), nil) + self.parent:GetCastRangeBonus()
    local point = ord.new_pos 

    if ord.target then 
        point = ord.target:GetAbsOrigin()
    end

    if (point - self.parent:GetAbsOrigin()):Length2D() >= math.min(300 + range, range*2) then 

        activity = 2

        string_table = self:GetCastVoice()
    end 
end 

for _,data in pairs(string_table) do 
    for i = data[2],data[3] do 
        table.insert(sounds, data[1]..self:GetNumber(i))
    end 
end  

if #sounds > 0 then 
    if self:MakeSound(sounds[RandomInt(1, #sounds)], true) == true then 

        if activity == 1 then 
            self.parent:AddNewModifier(self.parent, nil, "modifier_voice_module_move_attack_cd", {duration = self.attack_move_cd})
        end 

        if activity == 2 then 
            self.parent:AddNewModifier(self.parent, nil, "modifier_voice_module_cast_cd", {duration = self.cast_cd})
        end 
    end 
end 

return true
end 


function modifier_voice_module:JuggKill()

local name = "particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_trigger.vpcf"

if self.parent:HasModifier("modifier_juggernaut_arcana_v2") then 
    name = "particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_v2_trigger.vpcf"
end 

self.parent:EmitSound("Hero_Juggernaut.ArcanaTrigger")

self.parent:StartGesture(ACT_DOTA_TAUNT_SPECIAL)

local trail_pfx = ParticleManager:CreateParticle(name, PATTACH_ABSORIGIN, self.parent)
ParticleManager:ReleaseParticleIndex(trail_pfx)

end 

function modifier_voice_module:OnDeath(params)
if not IsServer() then return end 

local unit = params.unit
local sounds = {}
local timer = 0
local for_player = false
local more_players = -1
local is_last_hit = false
local priority = false
local global = false
local string_table = {}


if self.parent == params.attacker and unit:GetTeamNumber() ~= self.parent:GetTeamNumber() then 

    if unit:IsCreep() and not self.parent:HasModifier("modifier_voice_module_lasthit_cd") then 
        for_player = true
        is_last_hit = true

        string_table = self:GetLastHitVoice()
    end 

    if unit:IsRealHero() and unit:IsValidKill(self.parent) then 

        timer = self.kill_timer

        if my_game.KillCount == 0 then 
            global = true
            priority = true
        end

        string_table = self:GetKillVoice(unit)

        if global == false then 
            more_players = unit:GetPlayerOwnerID()
        end
    end 
end

if self.parent == unit and not self.parent:IsReincarnating() then 

    priority = true
    more_players = self.parent:GetPlayerOwnerID()

    string_table = self:GetDeathVoice()
end 


if #sounds == 0 then 

    for _,data in pairs(string_table) do 
        for i = data[2],data[3] do 

            local hundred = 0 
            if data[4] and data[4] == 1 then 
                hundred = 1
            end  

            table.insert(sounds, data[1]..self:GetNumber(i, hundred))
        end 
    end  
end 
    

if #sounds > 0 then 
    local sound = sounds[RandomInt(1, #sounds)]

    if self:MakeSound(sound, for_player, timer, more_players, priority, global) then 
        if is_last_hit == true then 
            self.parent:AddNewModifier(self.parent, nil, "modifier_voice_module_lasthit_cd", {duration = self.lasthit_cd})
        end
    end 

end 

end 



function modifier_voice_module:OnTakeDamage(params)
if not IsServer() then return end 
if self.parent:HasModifier("modifier_voice_module_active") then return end
if params.unit ~= self.parent then return end
if not params.attacker or not params.attacker:IsHero() then return end 
if params.attacker:GetTeamNumber() == self.parent:GetTeamNumber() then return end 
if self.parent:HasModifier("modifier_voice_module_damage_cd") then return end

local sounds = {}
local string_table = self:GetDamageVoice()

for _,data in pairs(string_table) do 
    for i = data[2],data[3] do 
        table.insert(sounds, data[1]..self:GetNumber(i))
    end 
end 

if #sounds > 0 then 
    if self:MakeSound(sounds[RandomInt(1, #sounds)], true) == true then 
        self.parent:AddNewModifier(self.parent, nil, "modifier_voice_module_damage_cd", {duration = self.damage_cd})
    end 
end

end 


function modifier_voice_module:OnAbilityStart(params)
if not IsServer() then return end 
if not params.ability then return end
if params.unit ~= self.parent then return end

local ability = params.ability
local sounds = {}
local string_table = {}
local for_player = false

if self.parent:GetUnitName() == "npc_dota_hero_juggernaut" then 

    if ability:GetName() == "custom_juggernaut_omnislash" and not self.parent:HasModifier("modifier_juggernaut_omnislash_legendary") then 

        if self.parent:GetModelName() == "models/heroes/juggernaut/juggernaut_arcana.vmdl" then
            string_table = 
            {
                {"juggernaut_custom_jug_arc_ability_omnislash_", 1, 3},
            }
        else 

            string_table = 
            {
                {"juggernaut_custom_jug_ability_omnislash_", 1, 3},
            }
        end 
    end
end


for _,data in pairs(string_table) do 
    for i = data[2],data[3] do 
        table.insert(sounds, data[1]..self:GetNumber(i))
    end 
end 


if #sounds > 0 then 
    self:MakeSound(sounds[RandomInt(1, #sounds)], for_player)
end 

end 



function modifier_voice_module:OnAbilityFullyCast(params)
if not IsServer() then return end 
if not params.ability then return end
if params.unit ~= self:GetCaster() then return end

local ability = params.ability
local sounds = {}
local priority = false
local for_player = false
local string_table = {}

if self.parent:GetUnitName() == "npc_dota_hero_juggernaut" then 

    if ability:GetName() == "custom_juggernaut_blade_fury" then

        priority = true
        if self.parent:GetModelName() == "models/heroes/juggernaut/juggernaut_arcana.vmdl" then
            string_table = 
            {
                {"juggernaut_custom_jug_arc_ability_bladefury_", 2, 3},
                {"juggernaut_custom_jug_arc_ability_bladefury_", 5, 9},
            }
        else 
            string_table = 
            {
                {"juggernaut_custom_jug_ability_bladefury_", 2, 3},
                {"juggernaut_custom_jug_ability_bladefury_", 5, 5},
                {"juggernaut_custom_jugg_ability_bladefury_", 10, 18},
            }
        end 
    end 

     if ability:GetName() == "custom_juggernaut_whirling_blade_custom" then 

        if self.parent:GetModelName() == "models/heroes/juggernaut/juggernaut_arcana.vmdl" then

            string_table = 
            {
                {"juggernaut_custom_jugsc_arc_ability_bladefury_", 6, 8},
            }
        else 

            string_table = 
            {
                {"juggernaut_custom_jug_ability_bladefury_", 6, 8},
            }
        end 
    end 
end 


if self.parent:GetUnitName() == "npc_dota_hero_phantom_assassin" then 

    if self.parent:GetModelName() == "models/heroes/phantom_assassin_persona/phantom_assassin_persona.vmdl" then
        for_player = true    

        if ability:GetName() == "custom_phantom_assassin_stifling_dagger" then 
            string_table = 
            {
                {"phantom_assassin_custom_pa_asan_dagger_", 1, 15},
            }
        end 
        if ability:GetName() == "custom_phantom_assassin_phantom_strike" then 

            string_table = 
            {
                {"phantom_assassin_custom_pa_asan_strike_", 1, 11},
            }
        end 
        if ability:GetName() == "custom_phantom_assassin_blur" then 

            string_table = 
            {
                {"phantom_assassin_custom_pa_asan_blur_", 1, 11},
            }
        end 
        if ability:GetName() == "custom_phantom_assassin_fan_of_knives" then 

            string_table = 
            {
                {"phantom_assassin_custom_pa_asan_fan_of_knives_", 1, 10},
            }
        end 
    end 
end 



for _,data in pairs(string_table) do 
    for i = data[2],data[3] do 
        table.insert(sounds, data[1]..self:GetNumber(i))
    end 
end 


if #sounds > 0 then 
    self:MakeSound(sounds[RandomInt(1, #sounds)], for_player, 0, -1, priority)
end 

end 





function modifier_voice_module:LevelEvent()
if not IsServer() then return end 

local sounds = {}
local string_table = {}
local timer = 1

if self.parent:GetUnitName() == "npc_dota_hero_juggernaut" then 

    if self.parent:GetModelName() == "models/heroes/juggernaut/juggernaut_arcana.vmdl" then
    
        string_table = 
        {
            {"juggernaut_custom_jug_arc_level_", 2, 9},
        }
    else 

        string_table = 
        {
            {"juggernaut_custom_jug_level_", 2, 6},
        }
    end 
end 


if self.parent:GetUnitName() == "npc_dota_hero_phantom_assassin" then 

    if self.parent:GetModelName() == "models/heroes/phantom_assassin/pa_arcana.vmdl" then
    
        string_table = 
        {
            {"phantom_assassin_custom_phass_arc_level_", 1, 8},
        }
    elseif self.parent:GetModelName() == "models/heroes/phantom_assassin_persona/phantom_assassin_persona.vmdl" then 

        string_table = 
        {
            {"phantom_assassin_custom_pa_asan_levelup_", 1, 21},
        }

    else 
        string_table = 
        {
            {"phantom_assassin_custom_phass_level_", 1, 8},
        }
    end 
end 




for _,data in pairs(string_table) do 
    for i = data[2],data[3] do 
        table.insert(sounds, data[1]..self:GetNumber(i))
    end 
end 

if #sounds > 0 then 
    self:MakeSound(sounds[RandomInt(1, #sounds)], true, timer)
end 

end 


function modifier_voice_module:BountyEvent()
if not IsServer() then return end 

local sounds = {}

if self.parent:GetUnitName() == "npc_dota_hero_juggernaut" then 
    if self.parent:GetModelName() == "models/heroes/juggernaut/juggernaut_arcana.vmdl" then

        table.insert(sounds, "juggernaut_custom_jug_arc_bounty_01")
        table.insert(sounds, "juggernaut_custom_jug_arc_bounty_04")
        table.insert(sounds, "juggernaut_custom_jug_arc_lasthit_05")
    else 
        table.insert(sounds, "juggernaut_custom_jug_lasthit_05")
    end 
end 

if self.parent:GetUnitName() == "npc_dota_hero_phantom_assassin" then 
    if self.parent:GetModelName() == "models/heroes/phantom_assassin/pa_arcana.vmdl" then

        table.insert(sounds, "phantom_assassin_custom_phass_arc_purch_01")
    elseif self.parent:GetModelName() == "models/heroes/phantom_assassin_persona/phantom_assassin_persona.vmdl" then 

        table.insert(sounds, "phantom_assassin_custom_pa_asan_bounty_01")
        table.insert(sounds, "phantom_assassin_custom_pa_asan_bounty_01_02")
        table.insert(sounds, "phantom_assassin_custom_pa_asan_bounty_02")
    else 
        table.insert(sounds, "phantom_assassin_custom_phass_purch_01")
    end 
end 




if #sounds > 0 then 
    self:MakeSound(sounds[RandomInt(1, #sounds)], true)
end 

end 


function modifier_voice_module:RespawnEvent()
if not IsServer() then return end 

local sounds = {}
local string_table = {}

if self.parent:GetUnitName() == "npc_dota_hero_juggernaut" then 

    if self.parent:GetModelName() == "models/heroes/juggernaut/juggernaut_arcana.vmdl" then
        string_table = 
        {
            {"juggernaut_custom_jug_arc_respawn_", 1, 7},
        }
    else 
        string_table = 
        {
            {"juggernaut_custom_jug_respawn_", 1, 7},
        }
    end 
end 

if self.parent:GetUnitName() == "npc_dota_hero_phantom_assassin" then 

    if self.parent:GetModelName() == "models/heroes/phantom_assassin/pa_arcana.vmdl" then
        string_table = 
        {
            {"phantom_assassin_custom_phass_arc_respawn_", 1, 10},
        }
    elseif self.parent:GetModelName() == "models/heroes/phantom_assassin_persona/phantom_assassin_persona.vmdl" then 

        string_table = 
        {
            {"phantom_assassin_custom_pa_asan_respawn_", 1, 13},
        }
    else
        string_table = 
        {
            {"phantom_assassin_custom_phass_respawn_", 1, 10},
        }
    end 
end 



for _,data in pairs(string_table) do 
    for i = data[2],data[3] do 
        table.insert(sounds, data[1]..self:GetNumber(i))
    end 
end 


if #sounds > 0 then 
    self:MakeSound(sounds[RandomInt(1, #sounds)], true, 1)
end 

end 







modifier_voice_module_move_attack_cd = class({})
function modifier_voice_module_move_attack_cd:IsHidden() return true end
function modifier_voice_module_move_attack_cd:IsPurgable() return false end
function modifier_voice_module_move_attack_cd:RemoveOnDeath() return false end

modifier_voice_module_cast_cd = class({})
function modifier_voice_module_cast_cd:IsHidden() return true end
function modifier_voice_module_cast_cd:IsPurgable() return false end
function modifier_voice_module_cast_cd:RemoveOnDeath() return false end


modifier_voice_module_lasthit_cd = class({})
function modifier_voice_module_lasthit_cd:IsHidden() return true end
function modifier_voice_module_lasthit_cd:IsPurgable() return false end
function modifier_voice_module_lasthit_cd:RemoveOnDeath() return false end


modifier_voice_module_active = class({})
function modifier_voice_module_active:IsHidden() return true end
function modifier_voice_module_active:IsPurgable() return false end
function modifier_voice_module_active:RemoveOnDeath() return false end


modifier_voice_module_damage_cd = class({})
function modifier_voice_module_damage_cd:IsHidden() return true end
function modifier_voice_module_damage_cd:IsPurgable() return false end
function modifier_voice_module_damage_cd:RemoveOnDeath() return false end









function modifier_voice_module:GetDamageVoice()
if not IsServer() then return end

local string_table = {}

if self.parent:GetUnitName() == "npc_dota_hero_juggernaut" then 

    if self.parent:GetModelName() == "models/heroes/juggernaut/juggernaut_arcana.vmdl" then
    
        string_table = 
        {
            {"juggernaut_custom_jug_arc_underattack_", 1, 1},
            {"juggernaut_custom_jug_arc_pain_", 1, 23},
        }
    else 
        string_table = 
        {
            {"juggernaut_custom_jugg_underattack_", 1, 1},
            {"juggernaut_custom_jug_pain_", 1, 10},
        }
    end 

    return string_table
end 


if self.parent:GetUnitName() == "npc_dota_hero_phantom_assassin" then 

    if self.parent:GetModelName() == "models/heroes/phantom_assassin/pa_arcana.vmdl" then
    
        string_table = 
        {
            {"juggernaut_custom_jug_arc_underattack_", 1, 1},
            {"phantom_assassin_custom_phass_arc_pain_", 1, 14},
        }
    elseif self.parent:GetModelName() == "models/heroes/phantom_assassin_persona/phantom_assassin_persona.vmdl" then 
        string_table = 
        {
            {"phantom_assassin_custom_pa_asan_pain_", 1, 9},
            {"phantom_assassin_custom_pa_asan_underattack_", 1, 4},
        }

    else 
        string_table = 
        {
            {"phantom_assassin_custom_phass_underattack_", 1, 1},
            {"phantom_assassin_custom_phass_pain_", 1, 14},
        }
    end 

    return string_table
end 

return string_table
end





function modifier_voice_module:GetMoveVoice()
if not IsServer() then return end

local string_table = {}
if self.parent:GetUnitName() == "npc_dota_hero_juggernaut" then  

    if self.parent:GetModelName() == "models/heroes/juggernaut/juggernaut_arcana.vmdl" then 

        if self.parent:GetHealthPercent() <= 30 then 
            string_table = 
            {
                {"juggernaut_custom_jug_arc_move_pain_", 1, 7},
                {"juggernaut_custom_jug_arc_move_pain_", 9, 19},
                {"juggernaut_custom_jug_arc_acknow_", 1, 9},
            }
        else 
            string_table = 
            {
                {"juggernaut_custom_jug_arc_move_", 1, 7},
                {"juggernaut_custom_jug_arc_move_", 9, 19},
                {"juggernaut_custom_jug_arc_acknow_", 1, 9},
            }
        end 
    else 
        string_table = 
        {
            {"juggernaut_custom_jug_move_", 1, 7},
            {"juggernaut_custom_jug_move_", 9, 19},
            {"juggernaut_custom_jug_acknow_", 1, 5},
        }
    end

    return string_table
end

if self.parent:GetUnitName() == "npc_dota_hero_phantom_assassin" then  

    if self.parent:GetModelName() == "models/heroes/phantom_assassin/pa_arcana.vmdl" then 
        string_table = 
        {
            {"phantom_assassin_custom_phass_arc_move_", 1, 19},
        }
    elseif self.parent:GetModelName() == "models/heroes/phantom_assassin_persona/phantom_assassin_persona.vmdl" then 

        if self.parent:GetHealthPercent() <= 30 then 
            string_table = 
            {
                {"phantom_assassin_custom_pa_asan_move_pain_", 1, 10},
            }
        else 
            string_table = 
            {
                {"phantom_assassin_custom_pa_asan_move_", 1, 22},
            }
        end 
    else
        string_table = 
        {
            {"phantom_assassin_custom_phass_move_", 1, 19},
        }
    end
    return string_table
end

return string_table
end



function modifier_voice_module:GetAttackVoice()
if not IsServer() then return end

local string_table = {}

if self.parent:GetUnitName() == "npc_dota_hero_juggernaut" then  
    if self.parent:GetModelName() == "models/heroes/juggernaut/juggernaut_arcana.vmdl" then 
        string_table = 
        {
            {"juggernaut_custom_jug_arc_attack_", 1, 13},
        }
    else 
        string_table = 
        {
            {"juggernaut_custom_jug_attack_", 1, 13},
        }
    end 

    return string_table
end 

if self.parent:GetUnitName() == "npc_dota_hero_phantom_assassin" then  
    if self.parent:GetModelName() == "models/heroes/phantom_assassin/pa_arcana.vmdl" then 
        string_table = 
        {
            {"phantom_assassin_custom_phass_arc_attack_", 1, 10},
        }
    elseif self.parent:GetModelName() == "models/heroes/phantom_assassin_persona/phantom_assassin_persona.vmdl" then 
        if self.parent:GetHealthPercent() <= 30 then 
            string_table = 
            {
                {"phantom_assassin_custom_pa_asan_attack_pain_", 1, 10},
            }
        else 
            string_table = 
            {
                {"phantom_assassin_custom_pa_asan_attack_", 1, 20},
                {"phantom_assassin_custom_pa_asan_attack_big_", 1, 1},
                {"phantom_assassin_custom_pa_asan_attack_emote_", 1, 2},
                {"phantom_assassin_custom_pa_asan_attack_small_", 8, 8}
            }
        end 
    else  
        string_table = 
        {
            {"phantom_assassin_custom_phass_attack_", 1, 10},
        }
    end 

    return string_table
end 

return string_table
end




function modifier_voice_module:GetCastVoice()
if not IsServer() then return end

local string_table = {}

if self.parent:GetUnitName() == "npc_dota_hero_juggernaut" then  

    if self.parent:GetModelName() == "models/heroes/juggernaut/juggernaut_arcana.vmdl" then 
        string_table = 
        {
            {"juggernaut_custom_jug_arc_cast_", 1, 3},
        }
    else 
        string_table = 
        {
            {"juggernaut_custom_jug_cast_", 1, 3},
        }
    end 
    return string_table
end 


if self.parent:GetUnitName() == "npc_dota_hero_phantom_assassin" then  

    if self.parent:GetModelName() == "models/heroes/phantom_assassin/pa_arcana.vmdl" then 
        string_table = 
        {
            {"phantom_assassin_custom_phass_arc_cast_", 1, 4},
        }
    elseif self.parent:GetModelName() == "models/heroes/phantom_assassin_persona/phantom_assassin_persona.vmdl" then 

        if self.parent:GetHealthPercent() <= 30 then 

            string_table = 
            {
                {"phantom_assassin_custom_pa_asan_cast_pain_", 1, 4},
            }
        else 
            string_table = 
            {
                {"phantom_assassin_custom_pa_asan_cast_", 1, 6},
            }
        end
    else  
        string_table = 
        {
            {"phantom_assassin_custom_phass_cast_", 1, 4},
        }
    end 

    return string_table
end

return string_table
end





function modifier_voice_module:GetDeathVoice()
if not IsServer() then return end

local string_table = {}
if self.parent:GetUnitName() == "npc_dota_hero_juggernaut" then 

    if self.parent:GetModelName() == "models/heroes/juggernaut/juggernaut_arcana.vmdl" then
        string_table = 
        {
            {"juggernaut_custom_jug_arc_death_", 1, 1},
            {"juggernaut_custom_jug_arc_death_", 3, 12},
        }
    else 
        string_table = 
        {
            {"juggernaut_custom_jug_death_", 1, 1},
            {"juggernaut_custom_jug_death_", 3, 12},
        }
    end 

    return string_table
end 


if self.parent:GetUnitName() == "npc_dota_hero_phantom_assassin" then 

    if self.parent:GetModelName() == "models/heroes/phantom_assassin/pa_arcana.vmdl" then
        string_table = 
        {
            {"phantom_assassin_custom_phass_arc_death_", 1, 9},
        }
    elseif self.parent:GetModelName() == "models/heroes/phantom_assassin_persona/phantom_assassin_persona.vmdl" then 
        
        string_table = 
        {
            {"phantom_assassin_custom_pa_asan_death_", 1, 20},
        }
    else  
        string_table = 
        {
            {"phantom_assassin_custom_phass_death_", 1, 9},
        }
    end 
    
    return string_table
end 

return string_table
end 



function modifier_voice_module:GetLastHitVoice()
if not IsServer() then return end

local string_table = {}

if self.parent:GetUnitName() == "npc_dota_hero_juggernaut" then 

    if self.parent:GetModelName() == "models/heroes/juggernaut/juggernaut_arcana.vmdl" then
        string_table = 
        {
            {"juggernaut_custom_jug_arc_lasthit_", 1, 12},
        }

    else 
        string_table = 
        {
            {"juggernaut_custom_jug_lasthit_", 1, 12},
        }
    end

    return string_table
end 

if self.parent:GetUnitName() == "npc_dota_hero_phantom_assassin" then 

    if self.parent:GetModelName() == "models/heroes/phantom_assassin/pa_arcana.vmdl" then
        string_table = 
        {
            {"phantom_assassin_custom_phass_arc_lasthit_", 1, 10},
        }

    elseif self.parent:GetModelName() == "models/heroes/phantom_assassin_persona/phantom_assassin_persona.vmdl" then 

        if self.parent:GetHealthPercent() <= 30 then 
            string_table = 
            {
                {"phantom_assassin_custom_pa_asan_lasthit_pain_", 1, 10},
            }
        else
            string_table = 
            {
                {"phantom_assassin_custom_pa_asan_lasthit_", 1, 15},
            }
        end  
    else  
        string_table = 
        {
            {"phantom_assassin_custom_phass_lasthit_", 1, 10},
        }
    end
    return string_table
end 


return string_table
end 






function modifier_voice_module:GetKillVoice(unit)
if not IsServer() then return end

local string_table = {}

local unit_table = nil

if self.parent:GetUnitName() == "npc_dota_hero_juggernaut" then 

    if self.parent:GetModelName() == "models/heroes/juggernaut/juggernaut_arcana.vmdl" then
        self:JuggKill()
    end 

    if my_game.KillCount == 0 then 

        if self.parent:GetModelName() == "models/heroes/juggernaut/juggernaut_arcana.vmdl" then
            string_table = {{"juggernaut_custom_jug_arc_firstblood_", 1, 1}}
        else 
            string_table = {{"juggernaut_custom_jugg_firstblood_", 1, 1}}
        end
    else

        local key = ""
        if self.parent:GetModelName() == "models/heroes/juggernaut/juggernaut_arcana.vmdl" then
            unit_table = rival_table.juggernaut_arc[unit:GetUnitName()]
            key = "juggernaut_custom_jug_arc_rival_"
        else 
            unit_table = rival_table.juggernaut[unit:GetUnitName()]
            key = "juggernaut_custom_jugg_rival_"
        end 

        if unit_table and RollPseudoRandomPercentage(self.rivaL_chance,4251,self.parent) then 
            string_table = {{key, unit_table[1], unit_table[#unit_table]}}
        else 

            if self.parent:GetModelName() == "models/heroes/juggernaut/juggernaut_arcana.vmdl" then
                string_table = 
                {
                    {"juggernaut_custom_jug_arc_kill_", 1, 12},
                }
            else
                string_table = 
                {
                    {"juggernaut_custom_jug_kill_", 1, 12},
                }
            end 
        end 
    end 

    return string_table
end 



if self.parent:GetUnitName() == "npc_dota_hero_phantom_assassin" then 

    if my_game.KillCount == 0 then 

        if self.parent:GetModelName() == "models/heroes/phantom_assassin/pa_arcana.vmdl" then
            string_table = {{"phantom_assassin_custom_phass_arc_firstblood_", 1, 2}}
        elseif self.parent:GetModelName() == "models/heroes/phantom_assassin_persona/phantom_assassin_persona.vmdl" then 
            string_table = {{"phantom_assassin_custom_pa_asan_firstblood_", 1, 6}}
        else 
            string_table = {{"phantom_assassin_custom_phass_firstblood_", 1, 2}}
        end
    else

        local key = ""
        if self.parent:GetModelName() == "models/heroes/phantom_assassin_persona/phantom_assassin_persona.vmdl" then
            key = "phantom_assassin_custom_pa_asan_rival_"
            unit_table = rival_table.pa_persona[unit:GetUnitName()]
        end 


        if unit_table and RollPseudoRandomPercentage(self.rivaL_chance,4251,self.parent) then 

            for i = 1, #unit_table do 
                table.insert(string_table, {key, unit_table[i], unit_table[i], 1})
            end 

        else 

            if self.parent:GetModelName() == "models/heroes/phantom_assassin/pa_arcana.vmdl" then
                string_table = 
                {
                    {"phantom_assassin_custom_phass_arc_kill_", 1, 13},
                    {"phantom_assassin_custom_phass_arc_ability_blur_", 2, 2},
                    {"phantom_assassin_custom_phass_arc_ability_phantomstrike_", 1, 3},
                    {"phantom_assassin_custom_phass_arc_laugh_", 1, 7}
                }
            elseif self.parent:GetModelName() == "models/heroes/phantom_assassin_persona/phantom_assassin_persona.vmdl" then 

                string_table = 
                {
                    {"phantom_assassin_custom_pa_asan_big_crit_", 1, 8},
                    {"phantom_assassin_custom_pa_asan_crit_kill_", 1, 18},
                    {"phantom_assassin_custom_pa_asan_dagger_kill_", 1, 10},
                    {"phantom_assassin_custom_pa_asan_kill_", 1, 20},
                    {"phantom_assassin_custom_pa_asan_laugh_", 1, 6}
                }

            else 
                string_table = 
                {
                    {"phantom_assassin_custom_phass_kill_", 1, 13},
                    {"phantom_assassin_custom_phass_ability_blur_", 2, 2},
                    {"phantom_assassin_custom_phass_ability_phantomstrike_", 1, 3},
                    {"phantom_assassin_custom_phass_laugh_", 1, 7}
                }
            end 
        end 
    end 

    return string_table
end 



return string_table
end