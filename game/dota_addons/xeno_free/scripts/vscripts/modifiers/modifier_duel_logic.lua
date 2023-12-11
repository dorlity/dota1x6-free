LinkLuaModifier("modifier_duel_hero_start", "modifiers/modifier_duel_logic", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_duel_hero_end", "modifiers/modifier_duel_logic", LUA_MODIFIER_MOTION_NONE)

modifier_duel_field_thinker = class({})

function modifier_duel_field_thinker:IsHidden() return true end
function modifier_duel_field_thinker:IsPurgable() return false end
function modifier_duel_field_thinker:OnCreated(table)
if not IsServer() then return end

self.index = table.index

if not duel_data[self.index] then return end 
if not duel_data[self.index].field then return end 

duel_data[self.index].stage = duel_data[self.index].stage + 1

self.field_array = duel_data[self.index].field

self.heroes = {duel_data[self.index].hero1, duel_data[self.index].hero2}

duel_data[self.index].hero1.last_enemy = duel_data[self.index].hero2
duel_data[self.index].hero2.last_enemy = duel_data[self.index].hero1

self.winner = nil

self.start_points = {}

self.start_points[1] = self.field_array.start1
self.start_points[2] = self.field_array.start2

local start_dir = {}

start_dir[1] = (self.start_points[2] - self.start_points[1]):Normalized()
start_dir[2] = (self.start_points[1] - self.start_points[2]):Normalized()


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

for i,hero in pairs(self.heroes) do 


	my_game:EndAllCooldowns(hero)

	if duel_data[self.index].top3 then 
		hero.won_duel = -1
	end 

	if duel_data[self.index].final_duel == 1 then 
		my_game:Destroy_All_Units(hero)
	end

	local point = self.start_points[i]

	if not hero:IsAlive() then 
		hero:RespawnHero(false, false)
	end

	hero:StopSound("Hero_Chen.TeleportLoop")
	hero:RemoveModifierByName("modifier_duel_hero_teleport")

	hero:SetAbsOrigin(point)
	FindClearSpaceForUnit(hero, point, false)

	hero:SetForwardVector(start_dir[i])
	hero:FaceTowards(hero:GetAbsOrigin() + start_dir[i]*10)

	self:SetStart(hero, point)
end 

self.interval = FrameTime()
self:StartIntervalThink(self.interval)
end 




function modifier_duel_field_thinker:SetStart(hero, point)
if not IsServer() then return end

PlayerResource:SetCameraTarget(hero:GetPlayerOwnerID(), hero)

hero:AddNewModifier(hero, nil, "modifier_duel_hero_thinker", {x = point.x, y = point.y, z = point.z})

hero:Purge(false, true, false, true, true)
hero:SetHealth(hero:GetMaxHealth())
hero:SetMana(hero:GetMaxMana())


Timers:CreateTimer(1, function()
	PlayerResource:SetCameraTarget(hero:GetPlayerOwnerID(), nil)
end)


end


















function modifier_duel_field_thinker:OnIntervalThink()
if not IsServer() then return end 

local all_units = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_CLOSEST, false)

for _,unit in pairs(all_units) do 
	if not unit:IsCourier() and unit:GetUnitName() ~= "npc_teleport" then 
		self:CheckPosition(unit)
	end 

end 


end 

function modifier_duel_field_thinker:CheckPosition(unit)
if unit:HasModifier("modifier_custom_juggernaut_omnislash") then return end
if unit:HasModifier("modifier_monkey_king_wukongs_command_custom_soldier") then return end
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

		local dir = (self.field_array.start1 - unit:GetAbsOrigin()):Normalized()

		new_point = unit:GetAbsOrigin() - dir*150
		change = true
	end

end 



if change == true then 

	unit:SetAbsOrigin(new_point)
	FindClearSpaceForUnit(unit, new_point, true)

	unit:EmitSound("Hero_Rattletrap.Power_Cogs_Impact")
	local attack_particle = ParticleManager:CreateParticle("particles/duel_stun.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit)
	ParticleManager:SetParticleControlEnt(attack_particle, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(attack_particle, 0, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(attack_particle, 60, Vector(31,82,167))
	ParticleManager:SetParticleControl(attack_particle, 61, Vector(1,0,0))



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

for _,hero in pairs(self.heroes) do 
	if hero:GetTeamNumber() == unit:GetTeamNumber() then 
		return true
	end 
end 

return false
end 


function modifier_duel_field_thinker:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_DEATH
}
end



function modifier_duel_field_thinker:OnDeath(params)
if not IsServer() then return end 
if not params.attacker then return end 
if params.unit == params.attacker then return end 
if params.unit:IsReincarnating() then return end 

local attacker = params.attacker

if attacker.owner then 
	attacker = attacker.owner
end 

local unit = params.unit


for _,hero1 in pairs(self.heroes) do 
	if hero1 == attacker then 
		for _,hero2 in pairs(self.heroes) do 
			if hero2 == unit then 
				unit.died_on_duel = true
				self.winner = hero1
				self:Destroy()
				return
			end 
		end 
	end 
end 


end 


function modifier_duel_field_thinker:FinishDuel()
if not IsServer() then return end

if not self.winner then 
	if not players[self.heroes[1]:GetTeamNumber()] then 
		self.winner = self.heroes[2]
	else 
		if not players[self.heroes[2]:GetTeamNumber()] then 
			self.winner = self.heroes[1]
		end 
	end 
end 

if not self.winner then 

	if self.heroes[1]:GetHealthPercent() > self.heroes[2]:GetHealthPercent() then 
		self.winner = self.heroes[1]
	end 

	if self.heroes[1]:GetHealthPercent() < self.heroes[2]:GetHealthPercent() then 
		self.winner = self.heroes[2]
	end

	if self.heroes[1]:GetHealthPercent() == self.heroes[2]:GetHealthPercent() then 

		if self.heroes[1]:GetHealth() >= self.heroes[2]:GetHealth() then 
			self.winner = self.heroes[1]
		else 
			self.winner = self.heroes[2]
		end

	end
end 

local duel_victory_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_legion_commander/legion_commander_duel_victory.vpcf", PATTACH_OVERHEAD_FOLLOW, self.winner)
ParticleManager:ReleaseParticleIndex(duel_victory_particle)

self.winner:EmitSound("Hero_LegionCommander.Duel.Victory")



if duel_data[self.index].top3 == 1 then 
	self.winner.won_duel = 1
end 

if duel_data[self.index].final_duel == 0 then

	for _,hero in pairs(self.heroes) do 
		hero:RemoveModifierByName("modifier_duel_hero_thinker")
		hero:RemoveModifierByName("modifier_duel_hero_thinker")


		hero:ModifyGold(300, true, DOTA_ModifyGold_Unspecified)

		Timers:CreateTimer(0.1, function()
			my_game:EndAllCooldowns(hero)
		end)

		if hero:IsAlive() then 
			hero:AddNewModifier(hero, nil, "modifier_duel_hero_end", {duration = 2, winner = self.winner == hero})
		
		end 

		hero.duel_data = -1

	end  

	duel_data[self.index].finished = 1
else 

	duel_data[self.index].field_created = 0
	duel_data[self.index].stage = 1
	duel_data[self.index].timer = 0
	
	duel_data[self.index].new_round = true

	for _,hero in pairs(self.heroes) do
		hero:RemoveModifierByName("modifier_duel_hero_thinker")
		hero:RemoveModifierByName("modifier_duel_hero_thinker")

		hero:AddNewModifier(hero, nil, "modifier_invulnerable", {duration = 5})
	end

	if self.winner == duel_data[self.index].hero1 then 
		duel_data[self.index].wins1 = duel_data[self.index].wins1 + 1

		if duel_data[self.index].wins1 >= 2 then 
			self:EndGame(duel_data[self.index].hero2)
		end 
	else 
		duel_data[self.index].wins2 = duel_data[self.index].wins2 + 1

		if duel_data[self.index].wins2 >= 2 then 
			self:EndGame(duel_data[self.index].hero1)
		end 
	end 
end 

		

end 



function modifier_duel_field_thinker:EndGame(loser)
if not IsServer() then return end

for _,hero in pairs(self.heroes) do
	hero:AddNewModifier(hero, nil, "modifier_invulnerable", {})
end

my_game:destroy_player(loser:GetTeamNumber())
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

self.point = Vector(table.x, table.y, table.z)

self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_duel_hero_start", {duration = duel_start})

self.init = false

self:StartIntervalThink(duel_start)
end 

function modifier_duel_hero_thinker:OnIntervalThink()
if not IsServer() then return end 

if self.init == false then 

	self.init = true

	self:GetParent():SetAbsOrigin(self.point)
	FindClearSpaceForUnit(self:GetParent(), self.point, false)
	self:GetParent():StopSound("Hero_Chen.TeleportLoop")

end

--AddFOWViewer(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), 2000, 0.1, false)

self:StartIntervalThink(0.1)

end 



function modifier_duel_hero_thinker:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
	MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
	MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
    MODIFIER_PROPERTY_ABSORB_SPELL,
	MODIFIER_PROPERTY_BONUS_DAY_VISION,
	MODIFIER_PROPERTY_BONUS_NIGHT_VISION,
}
end



function modifier_duel_hero_thinker:GetBonusDayVision() return 2500 end

function modifier_duel_hero_thinker:GetBonusNightVision() return 2500 end

function modifier_duel_hero_thinker:DamageAllowed(unit)
if not IsServer() then return end
if not unit then return end  


if duel_data[self:GetParent().duel_data] and 
 duel_data[self:GetParent().duel_data].hero1:GetTeamNumber() ~= unit:GetTeamNumber() and 
 duel_data[self:GetParent().duel_data].hero2:GetTeamNumber() ~= unit:GetTeamNumber() then 

	return 1
end 	

return 0
end


function modifier_duel_hero_thinker:GetAbsorbSpell(params)
if not IsServer() then return end
if self:GetParent():HasModifier("modifier_antimage_counterspell_custom_active") then return 0 end
if self:GetParent():IsInvulnerable() then return end
if not params.ability:GetCaster() then return end
if params.ability:GetCaster():IsNull() then return end
if params.ability:GetCaster():GetTeamNumber() == self:GetParent():GetTeamNumber() then return 0 end

if duel_data[self:GetParent().duel_data] and 
 duel_data[self:GetParent().duel_data].hero1:GetTeamNumber() ~= params.ability:GetCaster():GetTeamNumber() and 
 duel_data[self:GetParent().duel_data].hero2:GetTeamNumber() ~= params.ability:GetCaster():GetTeamNumber() then 

	local particle = ParticleManager:CreateParticle("particles/items_fx/immunity_sphere.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControlEnt(particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(particle)

	self:GetParent():EmitSound("DOTA_Item.LinkensSphere.Activate")

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
function modifier_duel_hero_start:CheckState() return {[MODIFIER_STATE_INVULNERABLE] = true, [MODIFIER_STATE_STUNNED] = true}
 end

function modifier_duel_hero_start:OnCreated(table)
if not IsServer() then return end

self:GetParent():EmitSound("Hero_LegionCommander.Duel.Cast.Arcana")
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
self:GetParent():EmitSound("Hero_LegionCommander.PressTheAttack")


my_game:EndAllCooldowns(self:GetParent())
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

local particleName = "particles/duel_timer.vpcf"
local particle = ParticleManager:CreateParticle(particleName, PATTACH_OVERHEAD_FOLLOW, caster)
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
local hero = self:GetParent()


if towers[self:GetParent():GetTeamNumber()] then

	local point = towers[self:GetParent():GetTeamNumber()]:GetAbsOrigin() + towers[self:GetParent():GetTeamNumber()]:GetForwardVector()*300

	self:GetParent():SetAbsOrigin(point)
	FindClearSpaceForUnit(self:GetParent(), point, false)

	local id = self:GetParent():GetPlayerOwnerID()

	PlayerResource:SetCameraTarget(id, self:GetParent())
	Timers:CreateTimer(0.5, function()
		PlayerResource:SetCameraTarget(id, nil)
	end)
end 


if self.winner == 1 then 
	local item = CreateItem("item_patrol_reward_2", self:GetParent(), self:GetParent())

	if self:GetParent():GetNumItemsInInventory() < 10 then
		self:GetParent():AddItem(item)
	else
		CreateItemOnPositionSync(GetGroundPosition(self:GetParent():GetAbsOrigin(),  self:GetParent()), item)
	end

	my_game:CreateUpgradeOrb(hero, 1)

end 

hero:Purge(false, true, false, true, true)
hero:SetHealth(hero:GetMaxHealth())
hero:SetMana(hero:GetMaxMana())

end 






modifier_duel_hero_teleport = class({})
function modifier_duel_hero_teleport:IsHidden() return true end
function modifier_duel_hero_teleport:IsPurgable() return false end 
function modifier_duel_hero_teleport:GetEffectName() 
return  "particles/units/heroes/hero_chen/chen_teleport.vpcf"
end 

function modifier_duel_hero_teleport:OnCreated()
if not IsServer() then return end 

self:GetParent():EmitSound("Hero_Chen.TeleportLoop")
end 


function modifier_duel_hero_teleport:OnDestroy()
if not IsServer() then return end 

self:GetParent():StopSound("Hero_Chen.TeleportLoop")
local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_chen/chen_teleport_flash.vpcf", PATTACH_POINT, self:GetParent())
ParticleManager:ReleaseParticleIndex(particle)

EmitSoundOnLocationWithCaster(self:GetParent():GetAbsOrigin(), "Hero_Chen.TeleportIn", self:GetParent())

end 