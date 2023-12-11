LinkLuaModifier( "modifier_lownet_choose", "modifiers/modifier_lownet_choose", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_tower_mark", "modifiers/modifier_on_respawn", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_tower_heal", "modifiers/modifier_on_respawn", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_tower_heal_hero", "modifiers/modifier_on_respawn", LUA_MODIFIER_MOTION_NONE )


modifier_on_respawn = class({})


function modifier_on_respawn:IsHidden() return false end
function modifier_on_respawn:IsPurgable() return false end



function modifier_on_respawn:DeclareFunctions()
return 
{
	MODIFIER_EVENT_ON_RESPAWN,
	MODIFIER_EVENT_ON_DEATH,
    MODIFIER_EVENT_ON_TAKEDAMAGE,
    MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL
}

end

function modifier_on_respawn:RemoveOnDeath() return false end


function modifier_on_respawn:GetAbsoluteNoDamagePhysical(params)
if not params.attacker then return end
if (params.attacker:GetUnitName() == "npc_towerdire" or params.attacker:GetUnitName() == "npc_towerradiant") then return 1 end

return 0
end

function modifier_on_respawn:OnTakeDamage(params)
if not IsServer() then return end
if not params.attacker then return end
if params.unit:GetTeamNumber() == self:GetParent():GetTeamNumber() then return end
if params.attacker:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then return end
if params.unit:GetUnitName() ~= "npc_towerdire" and params.unit:GetUnitName() ~= "npc_towerradiant" then return end

local attacker = params.attacker
if attacker.owner then 
    attacker = attacker.owner
end

if attacker ~= self:GetParent() then return end

params.unit:RemoveModifierByName("modifier_tower_mark")

if params.unit:GetHealth() > 0 then 
    params.unit:AddNewModifier(self:GetParent(), nil, "modifier_tower_mark", {duration = 10})
else 

    local hero = self:GetParent()

    if players[hero:GetTeamNumber()] then 
        players[hero:GetTeamNumber()].towers_destroyed = players[hero:GetTeamNumber()].towers_destroyed + 1
    end

    if GameRules:GetDOTATime(false, false) >= push_timer then 
        my_game:CreateUpgradeOrb(hero, 3)
    end

    local tower_count = 0
    local p = FindUnitsInRadius(DOTA_TEAM_NOTEAM,Vector(0, 0, 0),nil,FIND_UNITS_EVERYWHERE,DOTA_UNIT_TARGET_TEAM_BOTH,DOTA_UNIT_TARGET_BUILDING,DOTA_UNIT_TARGET_FLAG_INVULNERABLE,0,false)

    for _,tower1 in pairs(p) do 
        if (tower1:GetUnitName() == "npc_towerdire" or tower1:GetUnitName() == "npc_towerradiant") and tower1 ~= params.unit then 
            tower_count = tower_count + 1
        end
    end

    if tower_count == 2 then 
        hero:AddNewModifier(hero, nil, "modifier_duel_damage_final", {})
    end

end


end








function modifier_on_respawn:OnDeath(params)
if not IsServer() then return end
if not params.attacker then return end

if params.unit:IsTempestDouble() then return end

local attacker = params.attacker
if attacker.owner then 
    attacker = attacker.owner
end

if attacker == self:GetParent() and params.unit:GetTeamNumber() == DOTA_TEAM_NEUTRALS and params.unit:GetMaximumGoldBounty() > 0 then 
    local k = 0
    if self:GetParent():HasModifier("modifier_lownet_gold_buff") then 
        k = k + lownet_gold
    end


    if self:GetParent():HasModifier("modifier_item_alchemist_gold_bfury") then 
        k = k + self:GetParent():FindModifierByName("modifier_item_alchemist_gold_bfury").gold_bonus
    else 
        if self:GetParent():HasModifier("modifier_item_bfury_custom")  then
            k = k + self:GetParent():FindModifierByName("modifier_item_bfury_custom").gold_bonus
        end
    end

    if k > 0 then 
        local gold = math.max(1, params.unit:GetMaximumGoldBounty()*k)
        self:GetParent():ModifyGold(gold , true , DOTA_ModifyGold_CreepKill)
        SendOverheadEventMessage(self:GetParent(), 0, self:GetParent(), gold, nil)
    end
end

if params.unit:IsRealHero() and params.unit ~= self:GetParent() and not params.unit:IsReincarnating() 
and ((params.unit:GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D() < more_gold_radius or self:GetParent() == attacker) then 

    self:GetParent():ModifyGold(kill_net_gold, true, DOTA_ModifyGold_HeroKill)
    SendOverheadEventMessage(self:GetParent(), 0, self:GetParent(), kill_net_gold, nil)
end



local player = players[self:GetParent():GetTeamNumber()]

if player then 
    if params.attacker:GetTeamNumber() == self:GetParent():GetTeamNumber() and (params.unit:IsRealHero() and not params.unit:IsReincarnating())
    and params.unit ~= self:GetParent() then 

        local tower = towers[self:GetParent():GetTeamNumber()]
        if tower then 
            tower:EmitSound("DOTA_Item.RepairKit.Target")
            tower:AddNewModifier(player, nil, "modifier_generic_repair", {duration = 10, tower_heal = 15})
            self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_tower_heal_hero", {duration = 10})
        end

    end
end




if player and player.grenade_count < Grenade_Max and GameRules:GetDOTATime(false, false) >= Grenade_Timer and params.attacker and false then 
 
    if params.attacker:GetTeamNumber() == self:GetParent():GetTeamNumber() then 

        if (params.unit:IsRealHero() and not params.unit:IsReincarnating()) then 
            my_game:ChangeGrenadeCount(self:GetParent(), 1)
           -- my_game:ChangeGrenadeCount(self:GetParent(), 1)
        end

        if (params.unit:IsAncient() or my_game:IsPatrol(params.unit:GetUnitName())) then 
            player.grenade_creeps_count = player.grenade_creeps_count + 1

            if player.grenade_creeps_count >= Grenade_Creeps_Max then 
                player.grenade_creeps_count = 0
                my_game:ChangeGrenadeCount(self:GetParent(), 1)
            end
        end
    end

end


if self:GetParent() ~= params.unit then return end

self.reinc = false 
if self:GetParent():IsReincarnating() then 
	self.reinc = true
end

end




function modifier_on_respawn:OnRespawn(param)
if not IsServer() then return end
if param.unit ~= self:GetParent() then return end 

if self.reinc == false then 

    local mod = self:GetParent():FindModifierByName('modifier_voice_module')
    if mod then 
        mod:RespawnEvent()
    end 

    self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_invulnerable", {duration = 1})
end


self:GetParent():RemoveModifierByName("modifier_fountain_invulnerability")

self.reinc = false

local parent_player = players[self:GetParent():GetTeamNumber()]
if parent_player == nil then
    return
end

if parent_player.respawn_mod.name ~= nil then 

    local mod = self:GetParent():AddNewModifier(self:GetParent(), nil, parent_player.respawn_mod.name, {})

    if mod then 
        mod.IsUpgrade = true
        mod.IsOrangeTalent = parent_player.respawn_mod.IsOrangeTalent
        mod.TalentTree = parent_player.respawn_mod.TalentTree
    end


    if self:GetParent():FindModifierByName(parent_player.respawn_mod.name) then 
        players[self:GetParent():GetTeamNumber()].upgrades[parent_player.respawn_mod.name] = self:GetParent():FindModifierByName(parent_player.respawn_mod.name):GetStackCount()
    end


    CustomNetTables:SetTableValue(
        "upgrades_player",
        self:GetParent():GetUnitName(),
        {
            upgrades = parent_player.upgrades,
            hasup = self:GetParent():HasModifier("modifier_up_graypoints")
        }
    )

    local hero = parent_player


    local skill_data = nil
    for _, group_name in pairs({hero:GetUnitName(), "all", "lowest", "patrol_1","patrol_2","alchemist_items"}) do
        local skills_group = skills[group_name]
        for _, data in ipairs(skills_group) do
            if data[1] == parent_player.respawn_mod.name then
                skill_data = data
                break
            end
        end
    end


    if (hero:GetQuest() == "General.Quest_7") and not hero:QuestCompleted() then 
    
        local max = 0
        for _,talent in pairs(skills.all) do 
            local mod = hero:FindModifierByName(talent[1])

            if mod and mod:GetStackCount() >= max and talent[3] == "gray" then 
                max = mod:GetStackCount()
            end
        end

        hero:UpdateQuest(max - hero.quest.progress)
    end


    if (hero:GetQuest() == "General.Quest_8") and not hero:QuestCompleted() and skill_data[3] == "blue" then 

        local mod = hero:FindModifierByName(skill_data[1])

        if mod and mod:GetStackCount() >= skill_data[4] then 
            hero:UpdateQuest(1)
        end
    end


    if (hero:GetQuest() == "General.Quest_9") and not hero:QuestCompleted() and skill_data[3] == "purple" then 

        for _,talent in pairs(skills.all) do 
            local mod = hero:FindModifierByName(talent[1])

            if mod and talent[1] == skill_data[1] then 
                hero:UpdateQuest(1)
                break
            end
        end
            
    
    end

    
    parent_player.respawn_mod = {}
end






if parent_player.give_lownet == 1 then 
    parent_player.give_lownet = 0
    parent_player:AddNewModifier(parent_player, nil, "modifier_lownet_choose", {})
end

end



modifier_tower_mark = class({})
function modifier_tower_mark:IsHidden() return false end
function modifier_tower_mark:IsPurgable() return false end
function modifier_tower_mark:GetTexture() return self:GetCaster():GetUnitName() end

function modifier_tower_mark:DeclareFunctions()
return
{
    MODIFIER_EVENT_ON_DEATH
}
end


function modifier_tower_mark:OnDeath(params)
if not IsServer() then return end
if self:GetParent() ~= params.unit then return end

local hero = self:GetCaster()

if players[hero:GetTeamNumber()] then 
    players[hero:GetTeamNumber()].towers_destroyed = players[hero:GetTeamNumber()].towers_destroyed + 1
end

if GameRules:GetDOTATime(false, false) >= push_timer then 
    my_game:CreateUpgradeOrb(hero, 3)
end


local tower_count = 0
local p = FindUnitsInRadius(DOTA_TEAM_NOTEAM,Vector(0, 0, 0),nil,FIND_UNITS_EVERYWHERE,DOTA_UNIT_TARGET_TEAM_BOTH,DOTA_UNIT_TARGET_BUILDING,DOTA_UNIT_TARGET_FLAG_INVULNERABLE,0,false)




for _,tower1 in pairs(p) do 
    if (tower1:GetUnitName() == "npc_towerdire" or tower1:GetUnitName() == "npc_towerradiant") and tower1 ~= self:GetParent() then 
        tower_count = tower_count + 1
    end
end

if tower_count == 2 then 
    hero:AddNewModifier(hero, nil, "modifier_duel_damage_final", {})
end

end




modifier_tower_heal_hero = class({})
function modifier_tower_heal_hero:IsHidden() return false end
function modifier_tower_heal_hero:IsPurgable() return false end
function modifier_tower_heal_hero:RemoveOnDeath() return false end
function modifier_tower_heal_hero:GetTexture() return "item_repair_kit" end
function modifier_tower_heal_hero:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_TOOLTIP
    }
end

function modifier_tower_heal_hero:OnTooltip() return 10 end

