

test_mode = class({})

test_mode.TeamList =
{
	[DOTA_TEAM_BADGUYS] = 0,
	[DOTA_TEAM_GOODGUYS] = 0,
	[DOTA_TEAM_CUSTOM_1] = 0,
	[DOTA_TEAM_CUSTOM_2] = 0,
	[DOTA_TEAM_CUSTOM_3] = 0,
	[DOTA_TEAM_CUSTOM_4] = 0
}


test_mode.BotNames =
{
	[DOTA_TEAM_GOODGUYS] = 'fyva__',
	[DOTA_TEAM_BADGUYS] = 'XENO1X6',
	[DOTA_TEAM_CUSTOM_1] = 'Raze1x6',
	[DOTA_TEAM_CUSTOM_2] = 'Paradox_1s',
	[DOTA_TEAM_CUSTOM_3] = 'Biba1x6',
	[DOTA_TEAM_CUSTOM_4] = 'trafalgar1o'
}


test_mode.BannedHeroes = {}
test_mode.BotHeroes = {}
test_mode.PlayerHeroes = {}

function test_mode:InitGameMode()


CustomGameEventManager:RegisterListener( "AddTalent", Dynamic_Wrap(self, "AddTalent"))
CustomGameEventManager:RegisterListener( "AddLevel", Dynamic_Wrap(self, "AddLevel"))
CustomGameEventManager:RegisterListener( "AddGold", Dynamic_Wrap(self, "AddGold"))
CustomGameEventManager:RegisterListener( "AddItem", Dynamic_Wrap(self, "AddItem"))
CustomGameEventManager:RegisterListener( "AddHero", Dynamic_Wrap(self, "AddHero"))
CustomGameEventManager:RegisterListener( "LevelBots", Dynamic_Wrap(self, "LevelBots"))
CustomGameEventManager:RegisterListener( "AddBotItem", Dynamic_Wrap(self, "AddBotItem"))
CustomGameEventManager:RegisterListener( "NoBot", Dynamic_Wrap(self, "NoBot"))
CustomGameEventManager:RegisterListener( "RefreshButton", Dynamic_Wrap(self, "RefreshButton"))


end


function test_mode:NoBot(data)
if _G.TestMode == false then return end
if data.PlayerID == nil then return end



CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(data.PlayerID), "CreateIngameErrorMessage", {message = "no_selected_bot"})
end


function test_mode:AddLevel(data)
if _G.TestMode == false then return end
if data.PlayerID == nil then return end


local player = players[GlobalHeroes[data.PlayerID]:GetTeamNumber()]

if not player then return end

for i = 1,data.value do 
	player:HeroLevelUp(false)
end 


test_mode:MaxSkills(player)

end


test_mode.init_players = false

function test_mode:InitPlayers()
if test_mode.init_players == true then return end

for id = 0, 24 do
	if PlayerResource:IsValidPlayerID(id) and PlayerResource:GetSteamAccountID(id) ~= 0 and PlayerResource:GetPlayer(id) and PlayerResource:GetPlayer(id):GetAssignedHero() then
		
		test_mode.init_players = true

		local hero = PlayerResource:GetPlayer(id):GetAssignedHero() 
		test_mode.TeamList[hero:GetTeamNumber()] = 1
		test_mode.BannedHeroes[hero:GetUnitName()] = hero:GetUnitName()

		local count = #test_mode.PlayerHeroes + 1

		test_mode.PlayerHeroes[count] = {}
		test_mode.PlayerHeroes[count].id = id 
		test_mode.PlayerHeroes[count].ent = hero:entindex()


	end
end

CustomGameEventManager:Send_ServerToAllClients("set_test_mode",  {state = _G.TestMode})
CustomNetTables:SetTableValue("test_mode", "banned_heroes", test_mode.BannedHeroes)
CustomNetTables:SetTableValue("test_mode", "players_heroes", test_mode.PlayerHeroes)

end




function test_mode:AddGold(data)
if _G.TestMode == false then return end
if data.PlayerID == nil then return end


local player = players[GlobalHeroes[data.PlayerID]:GetTeamNumber()]

if not player then return end

player:ModifyGold(data.value, true, DOTA_ModifyGold_Unspecified)

end







function test_mode:AddTalent(data)
if _G.TestMode == false then return end
if data.PlayerID == nil then return end
if data.ent == nil then return end 

local unit = EntIndexToHScript(data.ent)
local player = players[GlobalHeroes[data.PlayerID]:GetTeamNumber()]

if not player then return end
if not unit then return end 

local hero = unit

if not hero:IsAlive() then return end

local skill_data = nil
local skill_name = data.value

if not skill_name then return end


for _, group_name in pairs({hero:GetUnitName(), "all", "lowest", "patrol_1","patrol_2","alchemist_items"}) do
	local skills_group = skills[group_name]
	for _, talent_data in ipairs(skills_group) do
		if talent_data[1] == skill_name then
			skill_data = talent_data
			break
		end
	end
end

if skill_data == nil then
	return
end


local mod = hero:FindModifierByName(skill_name)

local max = skill_data[4]

local type_name = skill_data[3]

if type(type_name) == "table" then 
	for _,data in pairs(type_name) do 
		if data == "gray" or data == "blue" or data == "purple" then 
			type_name = data
			break
		end 
	end 
end 

if type_name == "gray" then 
	max = 999999
end 

if not mod or mod:GetStackCount() < max then 
	mod = hero:AddNewModifier(hero, nil, skill_name, {})

	if skill_data[3] == "orange" or skill_data[3] == "purple" then
		CustomGameEventManager:Send_ServerToAllClients("show_skill_event", {hero = hero:GetUnitName(), skill = skill_name})
	end

else 
	return
end 


if mod then
	mod.IsUpgrade = true
	mod.IsOrangeTalent = skill_data[3] == "orange"
	mod.Talenttree = skill_data[6]
end

if hero:FindModifierByName(skill_name) then 
	players[hero:GetTeamNumber()].upgrades[skill_name] = hero:FindModifierByName(skill_name):GetStackCount()
end



CustomNetTables:SetTableValue(
	"upgrades_player",
	hero:GetUnitName(),
	{
		upgrades = players[hero:GetTeamNumber()].upgrades,
		hasup = hero:HasModifier("modifier_up_graypoints")
	}
)



CustomGameEventManager:Send_ServerToAllClients("update_test_talents",  {name = skill_name, type = skill_data[3], level = mod:GetStackCount(), max = skill_data[4]})

end



function test_mode:AddItem(data)
if _G.TestMode == false then return end
if data.PlayerID == nil then return end


local player = players[GlobalHeroes[data.PlayerID]:GetTeamNumber()]

if not player then return end

test_mode:GiveItem(player, data.value)
end





function test_mode:AddHero(data)
if _G.TestMode == false then return end
test_mode:InitPlayers()

if data.PlayerID == nil then return end

local player = players[GlobalHeroes[data.PlayerID]:GetTeamNumber()]

if not player then return end
if test_mode.BannedHeroes[data.value] then return end


local team = nil

for team_number,data in pairs(test_mode.TeamList) do 
	if data == 0 then 
		team = team_number
		break
	end 
end 

if team == nil then return end

local unit = GameRules:AddBotPlayerWithEntityScript(data.value, test_mode.BotNames[team], team, nil, false)
local point = player:GetAbsOrigin() + player:GetForwardVector()*300

--GlobalHeroes[#GlobalHeroes + 1] = unit

test_mode.BannedHeroes[data.value] = data.value
test_mode.BotHeroes[data.value] = unit:entindex()

test_mode.TeamList[team] = unit
unit:SetTeam(team)

unit.is_bot = true

unit:SetControllableByPlayer(player:GetPlayerID(), true)

unit:AddNewModifier(unit, nil, "modifier_test_hero_custom", {x = point.x, y = point.y})


CustomNetTables:SetTableValue("test_mode", "banned_heroes", test_mode.BannedHeroes)
CustomNetTables:SetTableValue("test_mode", "bot_heroes", test_mode.BotHeroes)



my_game:initiate_player(unit, 30)
end




function test_mode:LevelBots(data)
if _G.TestMode == false then return end
if data.PlayerID == nil then return end
if data.ent == nil then return end 

local unit = EntIndexToHScript(data.ent)

local player = players[GlobalHeroes[data.PlayerID]:GetTeamNumber()]

if not player then return end
if not unit then return end

for i = 1,data.value do 
	unit:HeroLevelUp(true)
end 

test_mode:MaxSkills(unit)

end


function test_mode:MaxSkills(unit)
if _G.TestMode == false then return end


if unit:GetLevel() == 30 then 
	for i = 0, 30 do
		local current_ability = unit:GetAbilityByIndex(i)

		if current_ability then
			current_ability:SetLevel(current_ability:GetMaxLevel())
		end
	end
end

end




function test_mode:AddBotItem(data)
if _G.TestMode == false then return end
if data.PlayerID == nil then return end
if data.ent == nil then return end 

local unit = EntIndexToHScript(data.ent)

local player = players[GlobalHeroes[data.PlayerID]:GetTeamNumber()]

if not player then return end
if not unit then return end

test_mode:GiveItem(unit, data.value)

end


function test_mode:GiveItem(unit, name)
if _G.TestMode == false then return end

if unit:GetNumItemsInInventory() >= 9 then return end 

local item = CreateItem(name, unit, unit)
unit:AddItem(item)

end



function test_mode:RefreshButton(data)
if _G.TestMode == false then return end
if data.PlayerID == nil then return end

test_mode:RefreshAll()
end


function test_mode:RefreshAll()
if _G.TestMode == false then return end

local units = FindUnitsInRadius(DOTA_TEAM_GOODGUYS, Vector(0,0,0), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_DEAD + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)

for _,unit in pairs(units) do 

	if unit:IsAlive() then 
		unit:SetHealth(unit:GetMaxHealth())
		unit:SetMana(unit:GetMaxMana())
	end 

	my_game:RefreshCooldowns(unit)

end 

end
