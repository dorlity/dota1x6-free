require( 'talents_values')


function C_DOTA_BaseNPC:IsOnDuel()
if not self.duel_data then return false end 
if not duel_data[self.duel_data] then return false end 
if duel_data[self.duel_data].stage ~= 2 then return false end

return true
end 




function C_DOTA_BaseNPC:GetTalentValue(name, property, ignore_level)


local hero_table = global_values[self:GetUnitName()]


if not hero_table then return 0 end

local talent_table = hero_table[name]


if not talent_table then return 0 end

local value = talent_table[property]


if not value then return 0 end

if ignore_level and ignore_level == true and type(value) ~= "table" then 
    return value
end 


if not self:HasModifier(name) then
return 0
end

local level = self:GetModifierStackCount(name, self)



if level == 0 then return 0 end


if type(value) == "table" then
    return value[level]
else
    return value
end

return 0
end




function C_DOTA_BaseNPC:GetWexCd(new_stack)

local ability = self:FindAbilityByName("invoker_wex_custom")
if not ability then return 0 end

local stack = 0
if new_stack then 
    stack = new_stack
else
    if self:HasModifier("modifier_invoker_wex_custom_passive") then 
       stack = self:GetUpgradeStack("modifier_invoker_wex_custom_passive")
    end 
end 

return ability:GetSpecialValueFor("cooldown_reduction")*stack
end     



function C_DOTA_BaseNPC:GetValueQuas(ability, value)
local quas = self:FindAbilityByName("invoker_quas_custom")

if quas then
    local level = quas:GetLevel() - 1

    if self:HasModifier("modifier_invoker_invoke_6") then  
        level = level + self:GetTalentValue("modifier_invoker_invoke_6", "level")
    end 

    return ability:GetLevelSpecialValueFor(value, level)
end
return 0
end


function C_DOTA_BaseNPC:GetValueWex(ability, value)
local wex = self:FindAbilityByName("invoker_wex_custom")
if wex then
    local level = wex:GetLevel() - 1

    if self:HasModifier("modifier_invoker_invoke_6") then  
        level = level + self:GetTalentValue("modifier_invoker_invoke_6", "level")
    end  

    return ability:GetLevelSpecialValueFor(value, level)
end
return 0
end

function C_DOTA_BaseNPC:GetValueExort(ability, value)
local exort = self:FindAbilityByName("invoker_exort_custom")
if exort then
    local level = exort:GetLevel() - 1

    if self:HasModifier("modifier_invoker_invoke_6") then  
        level = level + self:GetTalentValue("modifier_invoker_invoke_6", "level")
    end 

    return ability:GetLevelSpecialValueFor(value, level)
end
return 0
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

