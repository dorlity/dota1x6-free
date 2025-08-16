require( 'talents_values')


function C_DOTA_BaseNPC:IsOnDuel()
return false
end 

function C_DOTA_BaseNPC:PrintTalents()
DeepPrintTable(active_talents)
end

function C_DOTA_BaseNPC:IsCreepHero()
return self:HasModifier("modifier_life_stealer_infest_custom_legendary_creep") or (self:IsCreep() and self:IsConsideredHero())
end



function C_DOTA_BaseNPC:IsUnit()
return not self:IsNull() 
    and (self:IsHero() or self:IsCreep() or self.is_crystal) 
    and self:GetUnitName() ~= "npc_teleport" 
    and not self.is_hero_icon 
    and self:GetUnitName() ~= "npc_dota_donate_item_illusion"
    and not self:HasModifier("modifier_bounty_map")
end


function C_DOTA_BaseNPC:IsTempest()
return self:HasModifier("modifier_arc_warden_tempest_double_custom") or self:HasModifier("modifier_monkey_king_wukongs_command_custom_soldier")
end

function C_DOTA_BaseNPC:TalentLevel(talent)

local player_id = self:GetUnitName() -- self:GetPlayerOwnerID()


if self:HasModifier(talent) then 
    return self:GetModifierStackCount(talent, self)
end 

if not active_talents[player_id] then return 0 end
if not active_talents[player_id][talent] then return 0 end

return active_talents[player_id][talent].level
end




function C_DOTA_BaseNPC:HasTalent(talent)
if not self or self:IsNull() then return false end

local player_id = self:GetUnitName() -- self:GetPlayerOwnerID()

if self:HasModifier(talent) then return true end
if not active_talents[player_id] then return false end
if not active_talents[player_id][talent] then return false end

if (self:IsIllusion() or self:IsTempest()) and (not active_talents[player_id][talent].allow_illusion or active_talents[player_id][talent].allow_illusion ~= 1) then 
    return false
end

return true
end

function C_DOTA_BaseNPC:AddTalent(talent, new_level)

local player_id = self:GetUnitName() -- self:GetPlayerOwnerID()

if not active_talents[player_id] then 
    active_talents[player_id] = {}
end 

if not active_talents[player_id][talent] then 
    active_talents[player_id][talent] = {}
    active_talents[player_id][talent].level = 1

    if self:GetTalentValue(talent, "allow_illusion") ~= 0 then 
        active_talents[player_id][talent].allow_illusion = self:GetTalentValue(talent, "allow_illusion")
    end
else 
    active_talents[player_id][talent].level = active_talents[player_id][talent].level + 1
end

if new_level then 
    active_talents[player_id][talent].level = new_level
end

end



function C_DOTA_BaseNPC:GetTalentValue(name, property, ignore_level)

local hero_table = nil

if global_values[self:GetUnitName()] and global_values[self:GetUnitName()][name] then
    hero_table = global_values[self:GetUnitName()]
elseif global_values["general"][name] then 
    hero_table = global_values["general"]
elseif global_values["patrol"][name] then
    hero_table = global_values["patrol"]
elseif talents_heroes[name] and global_values[talents_heroes[name]] then
    hero_table = global_values[talents_heroes[name]]
end

if not hero_table then return 0 end

local talent_table = hero_table[name]

if not talent_table then return 0 end

local value = talent_table[property]

if not value then return 0 end

if ignore_level and ignore_level == true and type(value) ~= "table" then 
    return value
end 

if not self:HasTalent(name) then return 0 end

local level = self:TalentLevel(name)

if level == 0 then return 0 end

if type(value) == "table" then
    return value[level]
else
    if property == "general_bonus" then 
        return value*level
    else
        return value
    end
end

return 0
end



function C_DOTA_BaseNPC:UpdateTalentsClient()


end




function C_DOTA_BaseNPC:UpdateUIshort(params)

end


function C_DOTA_BaseNPC:UpdateUIlong(params)

end



function C_DOTA_BaseNPC:GetId()
local id = self:GetPlayerOwnerID()
if self.owner then
    id = self.owner:GetPlayerOwnerID()
end
return id
end


function C_DOTA_BaseNPC:GetValueQuas(ability, value)
local quas = self:FindAbilityByName("invoker_quas_custom")
local level = 0
if quas then
    level = quas:GetLevel() - 1

    if self:HasTalent("modifier_invoker_invoke_6") then  
        level = level + self:GetTalentValue("modifier_invoker_invoke_6", "level")
    end 
else
    local quas_mod = self:GetUpgradeStack("modifier_morphling_replicate_custom_quas")
    if quas_mod then
        level = math.max(0, quas_mod - 1)
    end
end
if self:HasTalent("modifier_slark_essence_7") or self:HasTalent("modifier_terror_reflection_7") then
    level = 3
end
return ability:GetLevelSpecialValueFor(value, level)
end


function C_DOTA_BaseNPC:GetValueWex(ability, value)
local wex = self:FindAbilityByName("invoker_wex_custom")
local level = 0
if wex then
    level = wex:GetLevel() - 1

    if self:HasTalent("modifier_invoker_invoke_6") then  
        level = level + self:GetTalentValue("modifier_invoker_invoke_6", "level")
    end  
else
    local wex_mod = self:GetUpgradeStack("modifier_morphling_replicate_custom_wex")
    if wex_mod then
        level = math.max(0, wex_mod - 1)
    end
end
if self:HasTalent("modifier_slark_essence_7") then
    level = 3
end
return ability:GetLevelSpecialValueFor(value, level)
end


function C_DOTA_BaseNPC:GetValueExort(ability, value)
local exort = self:FindAbilityByName("invoker_exort_custom")
local level = 0

if exort then
    level = exort:GetLevel() - 1

    if self:HasTalent("modifier_invoker_invoke_6") then  
        level = level + self:GetTalentValue("modifier_invoker_invoke_6", "level")
    end 
else
    local exort_mod = self:GetUpgradeStack("modifier_morphling_replicate_custom_exort")
    if exort_mod then
        level = math.max(0, exort_mod - 1)
    end
end
if self:HasTalent("modifier_slark_essence_7") then
    level = 3
end
return ability:GetLevelSpecialValueFor(value, level)
end





function C_DOTA_BaseNPC:AddAttackEvent_out(new_mod) end
function C_DOTA_BaseNPC:AddAttackEvent_inc(new_mod) end

function C_DOTA_BaseNPC:AddAttackStartEvent_out(mod) end
function C_DOTA_BaseNPC:AddAttackStartEvent_inc(mod) end

function C_DOTA_BaseNPC:AddAttackRecordEvent_out(mod) end
function C_DOTA_BaseNPC:AddAttackRecordEvent_inc(mod) end

function C_DOTA_BaseNPC:AddAttackFailEvent_out(mod) end
function C_DOTA_BaseNPC:AddAttackFailEvent_inc(mod) end

function C_DOTA_BaseNPC:AddRecordDestroyEvent(mod) end
function C_DOTA_BaseNPC:AddAttackCreateEvent(mod) end

function C_DOTA_BaseNPC:AddDamageEvent_out(new_mod) end
function C_DOTA_BaseNPC:AddDamageEvent_inc(new_mod) end

function C_DOTA_BaseNPC:AddHealEvent_inc(new_mod) end

function C_DOTA_BaseNPC:AddSpellStartEvent(mod) end
function C_DOTA_BaseNPC:AddSpellEvent(mod) end
function C_DOTA_BaseNPC:AddDeathEvent(mod) end
function C_DOTA_BaseNPC:AddRespawnEvent(mod) end
function C_DOTA_BaseNPC:AddOrderEvent(mod) end



function C_DOTA_BaseNPC:GetLeshracRadius()
if not self:HasModifier("modifier_leshrac_defilement_custom") then return 0 end
return self:GetUpgradeStack("modifier_leshrac_defilement_custom")
end



function C_DOTA_BaseNPC:IsTalentIllusion()

return self:HasModifier("modifier_muerta_dead_shot_custom_legendary")
    or self:HasModifier("modifier_skeleton_king_hellfire_blast_custom_illusion") 
end


function C_DOTA_BaseNPC:GetUpgradeStack( mod )
if self:HasModifier(mod) then 
			
	return self:GetModifierStackCount(mod, self)
else return 0 end 

end

function C_DOTA_BaseNPC:HasShard()
    if self:HasModifier("modifier_item_aghanims_shard") then
        return true
    end

    return false
end



function C_DOTA_BaseNPC:GetDisplayAttackSpeedClient()

    return self:GetDisplayAttackSpeed()
end






function C_DOTA_BaseNPC:UpgradeIllusion(mod, stack  )

    local i = self:AddNewModifier(self, nil, mod, {})

    i:SetStackCount(stack)
end


function C_DOTA_BaseNPC:SetQuest(table)

self.quest = {}
self.quest.name = table.name and table.name or ""
self.quest.exp = table.exp and table.exp or 0
self.quest.shards = table.shards and table.shards or 0
self.quest.icon = table.icon and table.icon or ""
self.quest.goal = table.goal and table.goal or 0
self.quest.legendary = table.legendary
self.quest.number = table.number and table.number or 0
self.quest.progress = 0
self.quest.completed = 0

end






function C_DOTA_BaseNPC:QuestCompleted()

local complete = false

if self.quest and self.quest.completed == 1 then 
    complete = true
end

return complete
end



function C_DOTA_BaseNPC:GetQuest()
local name = nil 

if self.quest and self.quest.name then 
    name = self.quest.name
end

return name
end



function C_DOTA_BaseNPC:IsPatrolCreep()
if self:GetUnitName() == "patrol_melee_good" or 
    self:GetUnitName() == "patrol_range_good" or 
    self:GetUnitName() == "patrol_melee_bad" or
    self:GetUnitName() == "patrol_range_bad" then return true end

return false

end


function C_DOTA_BaseNPC:GenericParticle()

end


function C_DOTA_BaseNPC:GenericHeal(heal, ability, no_text)
if not IsServer() then return end

self:Heal(heal, ability)


local particle = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self )
ParticleManager:ReleaseParticleIndex( particle )


if no_text and no_text == true then return end

SendOverheadEventMessage(self, 10, self, heal, nil)
end





function C_DOTABaseAbility:GetState()
return self:GetAutoCastState()
end

C_DOTA_Ability_Lua.GetCastRangeBonus = function(self, hTarget)
    if(not self or self:IsNull() == true) then
        return 0
    end
    local caster = self:GetCaster()
    if(not caster or caster:IsNull() == true) then
        return 0
    end
    return caster:GetCastRangeBonus()
end
 
C_DOTABaseAbility.GetCastRangeBonus = function(self, hTarget)
    if(not self or self:IsNull() == true) then
        return 0
    end
    local caster = self:GetCaster()
    if(not caster or caster:IsNull() == true) then
        return 0
    end
    return caster:GetCastRangeBonus()
end

