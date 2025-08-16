LinkLuaModifier("modifier_duel_hero_start", "modifiers/game_mode/modifier_duel_logic", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_duel_hero_end", "modifiers/game_mode/modifier_duel_logic", LUA_MODIFIER_MOTION_NONE)

modifier_duel_field_thinker = class({})

function modifier_duel_field_thinker:IsHidden() return true end
function modifier_duel_field_thinker:IsPurgable() return false end
function modifier_duel_field_thinker:OnCreated(table)
if not IsServer() then return end
self.parent = self:GetParent()
self.index = table.index

if not duel_data[self.index] then return end 
if not duel_data[self.index].field then return end 

duel_data[self.index].stage = duel_data[self.index].stage + 1

self.field_array = duel_data[self.index].field

self.teams = {duel_data[self.index].tower1:GetTeamNumber(), duel_data[self.index].tower2:GetTeamNumber()}

duel_data[self.index].tower1.last_enemy = duel_data[self.index].tower2:GetTeamNumber()
duel_data[self.index].tower2.last_enemy = duel_data[self.index].tower1:GetTeamNumber()

self.heroes = {}

self.winner = nil
self.start_points = {}

self.start_points[1] = {} 
self.start_points[1][1] = self.field_array.start1_1

self.start_points[2] = {} 
self.start_points[2][1] = self.field_array.start2_1

if self.field_array.start1_2 then
	self.start_points[1][2] = self.field_array.start1_2
	self.start_points[2][2] = self.field_array.start2_2
else
	self.start_points[1][2] = self.field_array.start1_1
	self.start_points[2][2] = self.field_array.start2_1
end

local start_dir = {}
start_dir[1] = (self.start_points[2][1] - self.start_points[1][1]):Normalized()
start_dir[2] = (self.start_points[1][1] - self.start_points[2][1]):Normalized()

local wall_start = {}
local wall_end = {}

wall_start[1] =  Vector(self.field_array.Xmax, self.field_array.Ymin, self.field_array.z)
wall_end[1] = Vector(self.field_array.Xmin, self.field_array.Ymin, self.field_array.z)

wall_start[2] = Vector(self.field_array.Xmax, self.field_array.Ymax, self.field_array.z)
wall_end[2] = Vector(self.field_array.Xmin, self.field_array.Ymax, self.field_array.z)

wall_start[3] = Vector(self.field_array.Xmax, self.field_array.Ymin, self.field_array.z)
wall_end[3] = Vector(self.field_array.Xmax, self.field_array.Ymax, self.field_array.z)

wall_start[4] = Vector(self.field_array.Xmin, self.field_array.Ymin, self.field_array.z)
wall_end[4] = Vector(self.field_array.Xmin, self.field_array.Ymax, self.field_array.z)

if table.use_walls == 1 then 
	for w = 1, 4 do 
	    local particle = ParticleManager:CreateParticle("particles/duel_wall.vpcf", PATTACH_WORLDORIGIN, nil)
	    ParticleManager:SetParticleControl(particle, 0, wall_start[w])
	    ParticleManager:SetParticleControl(particle, 1, wall_end[w])
	    self:AddParticle(particle, false, false, -1, false, false)
	end
end 


for i,team in pairs(self.teams) do
	if duel_data[self.index].top3 then 
		towers[team].won_duel = -1
	end 
	local ids = dota1x6:FindPlayers(team)
	if ids then
		local count = 1

		for _,id in pairs(ids) do
			local hero = players[id]
			if hero then
				self.heroes[hero] = 1

				dota1x6:EndAllCooldowns(hero)

				if duel_data[self.index].final_duel == 1 then 
					dota1x6:Destroy_All_Units(hero)
					hero:RemoveModifierByName("modifier_patrol_reward_2_buff")
					hero:RemoveModifierByName("modifier_patrol_reward_2_portal")
					hero:RemoveModifierByName("modifier_patrol_vision")
				end

				local point = self.start_points[i][count]
				count = count + 1

				if hero:IsAlive() then
					hero:SetHealth(hero:GetMaxHealth())
					hero:SetMana(hero:GetMaxMana())
					hero:Purge(false, true, false, true, true)
				end

				if not hero:IsAlive() then 
					hero:RespawnHero(false, false)
				end

				hero:StopSound("UI.Duel_teleport_loop")
				hero:RemoveModifierByName("modifier_duel_hero_teleport")

				hero:SetAbsOrigin(point)
				FindClearSpaceForUnit(hero, point, false)
				hero:SetForwardVector(start_dir[i])
				hero:FaceTowards(hero:GetAbsOrigin() + start_dir[i]*10)

				self:SetStart(hero, point)
			end
		end
	end
end

self.parent:AddDeathEvent(self)

self.interval = 0.1
self:StartIntervalThink(0.5)
end 


function modifier_duel_field_thinker:SetStart(hero, point)
if not IsServer() then return end

PlayerResource:SetCameraTarget(hero:GetId(), hero)

hero:AddNewModifier(hero, nil, "modifier_duel_hero_thinker", {team_1 = self.teams[1], team_2 = self.teams[2], x = point.x, y = point.y})
hero:AddNewModifier(hero, nil, "modifier_duel_hero_start", {duration = duel_start})

local mod = hero:FindModifierByName("modifier_custom_necromastery_souls")
if mod then 
	mod:SetMax()
end

Timers:CreateTimer(1, function()
	PlayerResource:SetCameraTarget(hero:GetId(), nil)
end)

end



function modifier_duel_field_thinker:OnIntervalThink()
if not IsServer() then return end 

for _,team in pairs(self.teams) do 
	AddFOWViewer(team, self.parent:GetAbsOrigin(), 1100, self.interval, true)
end

local all_units = FindUnitsInRadius(self.parent:GetTeamNumber(), self.parent:GetAbsOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_CLOSEST, false)

for _,unit in pairs(all_units) do 
	if not unit:IsCourier() and unit:GetUnitName() ~= "npc_teleport" then 
		self:CheckPosition(unit)
	end 
end 

self:StartIntervalThink(self.interval)
end 

function modifier_duel_field_thinker:CheckPosition(unit)
if unit:HasModifier("modifier_monkey_king_wukongs_command_custom_soldier") then return end
if unit:GetUnitName() == "npc_dota_donate_item_illusion" then return end
if unit:IsInvulnerable() then return end
if unit:HasModifier("modifier_primal_beast_pulverize_custom_debuff") then return end
if unit:GetTeamNumber() == DOTA_TEAM_CUSTOM_5 then return end
if not unit:IsAlive() then return end
if unit:IsUnselectable() then return end

local point = unit:GetAbsOrigin()
local new_point = point
local change = false 


if self:IsAllowed(unit) then

	if point.z < -1000 then 
		change = true
	end 

	if point.x > self.field_array.Xmax then 
		new_point.x = self.field_array.Xmax - 150
		change = true
	end

	if point.x < self.field_array.Xmin then 
		new_point.x = self.field_array.Xmin + 150
		change = true
	end

	if point.y > self.field_array.Ymax then 
		new_point.y = self.field_array.Ymax - 150
		change = true
	end

	if point.y < self.field_array.Ymin then 
		new_point.y = self.field_array.Ymin + 150 
		change = true	
	end   
else 

	if point.x <= self.field_array.Xmax and point.x >= self.field_array.Xmin
	and point.y <= self.field_array.Ymax and point.y >= self.field_array.Ymin then 
		local dir = (self.field_array.start1_1 - unit:GetAbsOrigin()):Normalized()

		new_point = unit:GetAbsOrigin() - dir*150
		change = true
	end

end 

if change == true then 

	unit:SetAbsOrigin(new_point)
	FindClearSpaceForUnit(unit, new_point, true)

	unit:EmitSound("UI.Walls_hit")
	local attack_particle = ParticleManager:CreateParticle("particles/duel_stun.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit)
	ParticleManager:SetParticleControlEnt(attack_particle, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(attack_particle, 0, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(attack_particle, 60, Vector(31,82,167))
	ParticleManager:SetParticleControl(attack_particle, 61, Vector(1,0,0))
	ParticleManager:ReleaseParticleIndex(attack_particle)

	local mod = unit:FindModifierByName("modifier_pangolier_gyroshell_custom")
	if mod then 
		mod:Crash()
		return
	end 

	unit:Stop()
	unit:AddNewModifier(nil, nil, "modifier_stunned", {duration = field_stun})
end

end 


function modifier_duel_field_thinker:IsAllowed(unit)
if not IsServer() then return end 

for _,team in pairs(self.teams) do 
	if team == unit:GetTeamNumber() then 
		return true
	end 
end 

return false
end 




function modifier_duel_field_thinker:DeathEvent(params)
if not IsServer() then return end 
local unit = params.unit

if unit:IsReincarnating() then return end 
if not self.heroes[unit] or self.heroes[unit] == 0 then return end
self.heroes[unit] = 0
unit.died_on_duel = true

local timer = 100
local data = duel_data[self.index]
if data.max_timer and data.timer then
	timer = data.max_timer - data.timer + 1
end

if players[unit:GetId()] then
	unit:SetTimeUntilRespawn(timer)
end

local team_count = {}

for hero,alive in pairs(self.heroes) do
	local team = hero:GetTeamNumber()
	if not team_count[team] then
		team_count[team] = 0
	end
	if alive == 1 then
		team_count[team] = team_count[team] + 1
	end
end

local winner = nil

for team,count in pairs(team_count) do
	if count > 0 then
		if winner == nil then
			winner = team
		else
			return
		end
	end
end

self.winner = winner
self:Destroy()
end 


function modifier_duel_field_thinker:FinishDuel()
if not IsServer() then return end

if not self.winner then 
	if not towers[self.teams[1]] then 
		self.winner = self.teams[2]
	else 
		if not towers[self.teams[2]] then 
			self.winner = self.teams[1]
		end 
	end 
end 

local alive = {0, 0}
local percent = {0, 0}
local health = {0, 0}

if not self.winner then 
	for i,team in pairs(self.teams) do
		local ids = dota1x6:FindPlayers(team)
		if ids then
			for _,id in pairs(ids) do
				local hero = players[id]
				if hero and self.heroes[hero] then
					alive[i] = alive[i] + self.heroes[hero]
					percent[i] = percent[i] + hero:GetHealthPercent()
					health[i] = health[i] + hero:GetHealth()
				end
			end
		end
	end

	if alive[1] > alive[2] then
		self.winner = self.teams[1]
	elseif alive[2] > alive[1] then
		self.winner = self.teams[2]
	end
end

if not self.winner then
	if percent[1] > percent[2] then
		self.winner = self.teams[1]
	elseif percent[2] > percent[1] then
		self.winner = self.teams[2]
	end
end

if not self.winner then
	if health[1] >= health[2] then
		self.winner = self.teams[1]
	else
		self.winner = self.teams[2]
	end
end

if not self.winner then return end

if duel_data[self.index].top3 == 1 then 
	local tower = towers[self.winner]
	if tower then
		tower.won_duel = 1
	end
end 

local finish = duel_data[self.index].final_duel

for hero,_ in pairs(self.heroes) do
	local team = hero:GetTeamNumber()	

	start_quest:CheckQuest({id = hero:GetId(), quest_name = "Quest_11"})

	if team == self.winner then
		hero:GenericParticle("particles/units/heroes/hero_legion_commander/legion_commander_duel_victory.vpcf", nil, true)
		hero:EmitSound("UI.Duel_victory")
	end

	if finish == 1 then
		hero:RemoveModifierByName("modifier_duel_hero_thinker")

		if hero:IsAlive() then
			hero:AddNewModifier(hero, nil, "modifier_invulnerable", {duration = 5})
		else
			if players[hero:GetId()] then
				hero:SetTimeUntilRespawn(5)
			end
		end
	else
		local mod = hero:FindModifierByName("modifier_duel_hero_thinker")
		if mod and not mod.ended then
			mod:SetEnd(self.winner == team)
		end

		if not hero:IsAlive() and players[hero:GetId()] then
			hero:SetTimeUntilRespawn(2)
		end

		hero:ModifyGold(300, true, DOTA_ModifyGold_Unspecified)

		Timers:CreateTimer(0.1, function()
			dota1x6:EndAllCooldowns(hero)
		end)
		local tower = towers[team]
		if tower then
			tower.duel_data = -1
		end
	end
end  

if finish == 0 then
	duel_data[self.index].finished = 1


	local hero = nil
	local ids = dota1x6:FindPlayers(self.winner)
	if ids then
		hero = players[ids[RandomInt(1, #ids)]]
	end

	if hero then
		hero.razor_count = hero.razor_count + 1
		local item = CreateItem("item_patrol_razor", hero, hero)
		if hero:GetNumItemsInInventory() < 10 then
			hero:AddItem(item)
		else
			CreateItemOnPositionSync(GetGroundPosition(hero:GetAbsOrigin(), hero), item)
		end
	end

else
	duel_data[self.index].field_created = 0
	duel_data[self.index].stage = 1
	duel_data[self.index].timer = 0
	duel_data[self.index].new_round = true

	if self.winner == self.teams[1] then 
		duel_data[self.index].wins1 = duel_data[self.index].wins1 + 1

		if duel_data[self.index].wins1 >= 2 then 
			self:EndGame(self.teams[2])
		end 
	else 
		duel_data[self.index].wins2 = duel_data[self.index].wins2 + 1

		if duel_data[self.index].wins2 >= 2 then 
			self:EndGame(self.teams[1])
		end 
	end 
end

end 


function modifier_duel_field_thinker:EndGame(loser)
if not IsServer() then return end
dota1x6:WinAnimation(loser)
duel_data[self.index].finished = 1
end 


function modifier_duel_field_thinker:OnDestroy()
if not IsServer() then return end

self:FinishDuel()
end 





modifier_duel_hero_thinker = class({})
function modifier_duel_hero_thinker:IsHidden() return true end
function modifier_duel_hero_thinker:IsPurgable() return false end
function modifier_duel_hero_thinker:RemoveOnDeath() return false end
function modifier_duel_hero_thinker:OnCreated(table)
if not IsServer() then return end 
self.parent = self:GetParent()
self.point = GetGroundPosition(Vector(table.x, table.y, 0), nil)
self.team_1 = table.team_1
self.team_2 = table.team_2

self.ended = false
self.winner = false
self:StartIntervalThink(duel_start)
end 

function modifier_duel_hero_thinker:OnIntervalThink()
if not IsServer() then return end 
self.parent:Purge(false, true, false, true, true)
self.parent:SetAbsOrigin(self.point)
FindClearSpaceForUnit(self.parent, self.point, false)
self.parent:StopSound("UI.Duel_teleport_loop")

self:StartIntervalThink(-1)
end 



function modifier_duel_hero_thinker:SetEnd(winner)
if not IsServer() then return end 
self.ended = true
self.winner = winner
self:SetDuration(2, true)
end 

function modifier_duel_hero_thinker:CheckState()
if not self.ended then return end
return
{
	[MODIFIER_STATE_INVULNERABLE] = true
}
end 


function modifier_duel_hero_thinker:OnDestroy()
if not IsServer() then return end 
if not self.ended then return end

if towers[self.parent:GetTeamNumber()] then

	local point = towers[self.parent:GetTeamNumber()]:GetAbsOrigin() + RandomVector(300)
	self.parent:Purge(false, true, false, true, true)
	self.parent:SetAbsOrigin(point)
	FindClearSpaceForUnit(self.parent, point, false)

	self.parent:AddNewModifier(self.parent, nil, "modifier_invulnerable", {duration = 3})

	local id = self.parent:GetPlayerOwnerID()

	PlayerResource:SetCameraTarget(id, self.parent)
	Timers:CreateTimer(0.5, function()
		PlayerResource:SetCameraTarget(id, nil)
	end)
end 

if self.winner then 
	dota1x6:CreateUpgradeOrb(self.parent, 1)
end 

self.parent:Purge(false, true, false, true, true)
self.parent:SetHealth(self.parent:GetMaxHealth())
self.parent:SetMana(self.parent:GetMaxMana())

end 





function modifier_duel_hero_thinker:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
	MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
	MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
    MODIFIER_PROPERTY_ABSORB_SPELL,
}
end



function modifier_duel_hero_thinker:DamageAllowed(unit)
if not IsServer() then return end
if not unit then return end  
if not self.team_1 or not self.team_2 then return end
if self.ended then return end

if self.team_1 ~= unit:GetTeamNumber() and self.team_2 ~= unit:GetTeamNumber() then 
	return 1
end 	
return 0
end

function modifier_duel_hero_thinker:GetAbsorbSpell(params)
if not IsServer() then return end
if self.parent:HasModifier("modifier_antimage_counterspell_custom_active") then return 0 end
if self.parent:IsInvulnerable() then return end
local caster = params.ability:GetCaster()

if not caster then return end
if caster:IsNull() then return end
if caster:GetTeamNumber() == self.parent:GetTeamNumber() then return 0 end

if self:DamageAllowed(caster) == 1 then 
	local particle = ParticleManager:CreateParticle("particles/items_fx/immunity_sphere.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
	ParticleManager:SetParticleControlEnt(particle, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(particle)
	self.parent:EmitSound("DOTA_Item.LinkensSphere.Activate")
	return 1
end 	
return 0
end

function modifier_duel_hero_thinker:GetAbsoluteNoDamagePhysical(params)
if not IsServer() then return end
return self:DamageAllowed(params.attacker)
end 

function modifier_duel_hero_thinker:GetAbsoluteNoDamageMagical(params)
if not IsServer() then return end
return self:DamageAllowed(params.attacker)
end 

function modifier_duel_hero_thinker:GetAbsoluteNoDamagePure(params)
if not IsServer() then return end
return self:DamageAllowed(params.attacker)
end 





modifier_duel_hero_start = class({})

function modifier_duel_hero_start:IsHidden() return true end
function modifier_duel_hero_start:IsPurgable() return false end
function modifier_duel_hero_start:GetTexture() return "legion_commander_duel" end
function modifier_duel_hero_start:CheckState() return {[MODIFIER_STATE_INVULNERABLE] = true, [MODIFIER_STATE_STUNNED] = true} end
function modifier_duel_hero_start:OnCreated(table)
if not IsServer() then return end
self:GetParent():EmitSound("UI.Duel_start")
local point = self:GetParent():GetAbsOrigin()

local duel_particle = ParticleManager:CreateParticle("particles/legion_duel_ring.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(duel_particle, 0, point)
ParticleManager:SetParticleControl(duel_particle, 7, point)

self:AddParticle(duel_particle, false, false, -1, false, false)

self.t = -1
self.timer = self:GetRemainingTime()*2 
self:StartIntervalThink(0.5)
self:OnIntervalThink()
end

function modifier_duel_hero_start:OnDestroy()
if not IsServer() then return end
self:GetParent():Stop()
self:GetParent():EmitSound("UI.Duel_horn")

dota1x6:EndAllCooldowns(self:GetParent())
end


function modifier_duel_hero_start:OnIntervalThink()
if not IsServer() then return end

self.t = self.t + 1
local caster = self:GetParent()
local number = (self.timer-self.t)/2 

local int = number

if number % 1 ~= 0 then 
	int = number - 0.5  
end

local digits = math.floor(math.log10(number)) + 2

local decimal = number % 1

if decimal == 0.5 then
    decimal = 8
else 
    decimal = 1
end

local particle = ParticleManager:CreateParticle("particles/duel_timer.vpcf", PATTACH_OVERHEAD_FOLLOW, caster)
ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin())
ParticleManager:SetParticleControl(particle, 1, Vector(0, int, decimal))
ParticleManager:SetParticleControl(particle, 2, Vector(digits, 0, 0))
ParticleManager:ReleaseParticleIndex(particle)
end




modifier_duel_hero_end = class({})
function modifier_duel_hero_end:IsHidden() return true end
function modifier_duel_hero_end:IsPurgable() return false end 
function modifier_duel_hero_end:OnCreated(table)
if not IsServer() then return end 
self.parent = self:GetParent()
self.winner = table.winner
end 

function modifier_duel_hero_end:CheckState()
return
{
	[MODIFIER_STATE_INVULNERABLE] = true
}
end 


function modifier_duel_hero_end:OnDestroy()
if not IsServer() then return end 

if towers[self.parent:GetTeamNumber()] then

	local point = towers[self.parent:GetTeamNumber()]:GetAbsOrigin() + RandomVector(300)
	self.parent:Purge(false, true, false, true, true)
	self.parent:SetAbsOrigin(point)
	FindClearSpaceForUnit(self.parent, point, false)

	local id = self.parent:GetPlayerOwnerID()

	PlayerResource:SetCameraTarget(id, self.parent)
	Timers:CreateTimer(0.5, function()
		PlayerResource:SetCameraTarget(id, nil)
	end)
end 

if self.winner == 1 then 
	local name = "item_patrol_razor" 
	self.parent.razor_count = self.parent.razor_count + 1
	local item = CreateItem(name, self.parent, self.parent)
	if self.parent:GetNumItemsInInventory() < 10 then
		self.parent:AddItem(item)
	else
		CreateItemOnPositionSync(GetGroundPosition(self.parent:GetAbsOrigin(),  self.parent), item)
	end

	dota1x6:CreateUpgradeOrb(self.parent, 1)
end 

self.parent:Purge(false, true, false, true, true)
self.parent:SetHealth(self.parent:GetMaxHealth())
self.parent:SetMana(self.parent:GetMaxMana())

end 






modifier_duel_hero_teleport = class({})
function modifier_duel_hero_teleport:IsHidden() return true end
function modifier_duel_hero_teleport:IsPurgable() return false end 
function modifier_duel_hero_teleport:GetEffectName() 
return  "particles/units/heroes/hero_chen/chen_teleport.vpcf"
end 

function modifier_duel_hero_teleport:OnCreated()
if not IsServer() then return end 

self:GetParent():EmitSound("UI.Duel_teleport_loop")
end 


function modifier_duel_hero_teleport:OnDestroy()
if not IsServer() then return end 

self:GetParent():StopSound("UI.Duel_teleport_loop")
local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_chen/chen_teleport_flash.vpcf", PATTACH_POINT, self:GetParent())
ParticleManager:ReleaseParticleIndex(particle)

EmitSoundOnLocationWithCaster(self:GetParent():GetAbsOrigin(), "UI.Duel_teleport_end", self:GetParent())

end 