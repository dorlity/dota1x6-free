LinkLuaModifier("modifier_target_vision", "modifiers/modifier_target", LUA_MODIFIER_MOTION_NONE)


modifier_target = class({})


function modifier_target:IsHidden() return false end
function modifier_target:IsPurgable() return false end
function modifier_target:IsDebuff() return true end
function modifier_target:GetTexture() return "buffs/odds_fow" end
function modifier_target:GetEffectName() return
"particles/econ/items/bounty_hunter/bounty_hunter_hunters_hoard/bounty_hunter_hoard_track_trail.vpcf"
end


function modifier_target:OnCreated(table)
if not IsServer() then return end

self.attackers = {}

CustomGameEventManager:Send_ServerToAllClients('TargetAttack',  {hero = self:GetParent():GetUnitName()})

self:StartIntervalThink(10)
self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_target_vision", {})

self.gold = Target_gold_reward*100
self.init = false
self:SetHasCustomTransmitterData(true)
end


function modifier_target:OnIntervalThink()
if not IsServer() then return end
for id = 0,24 do
	if PlayerResource:IsValidPlayerID(id) and PlayerResource:GetSteamAccountID(id) ~= 0  then 
		
		local hero = GlobalHeroes[id]
		if hero and players[hero:GetTeamNumber()] ~= nil then 
			local net_target = PlayerResource:GetNetWorth(id)
			local net_self = PlayerResource:GetNetWorth(self:GetParent():GetPlayerOwnerID()) 

			bonus_gold = 0

			if net_self > net_target then 
				bonus_gold = (net_self - net_target)*Target_gold_reward
			end
			local time = math.floor(self:GetRemainingTime())
			bonus_gold = math.floor(bonus_gold)

			local is_target = hero == self:GetParent()

			if self.init == false then
				CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(id), 'TargetTimer',  {gold = bonus_gold, is_target = is_target, hero = self:GetParent():GetUnitName(), time = time})
			else 
				CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(id), 'TargetTimer_change',  {gold = bonus_gold, is_target = is_target, hero = self:GetParent():GetUnitName(), time = time})
			end
		end

	end
end

if self.init == false then 
	self.init = true 
end

self:StartIntervalThink(1)
end

 


			

function modifier_target:AddCustomTransmitterData() return {
gold = self.gold,


} end

function modifier_target:HandleCustomTransmitterData(data)
self.gold = data.gold
end

function modifier_target:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
	MODIFIER_EVENT_ON_DEATH,
	MODIFIER_PROPERTY_TOOLTIP,
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	MODIFIER_EVENT_ON_TAKEDAMAGE
}
end

function modifier_target:GetModifierIncomingDamage_Percentage(params)
if not IsServer() then return end
if not params.attacker then return end
if params.attacker:GetTeamNumber() == DOTA_TEAM_CUSTOM_5 then return end
if params.attacker:GetTeamNumber() == self:GetParent():GetTeamNumber() then return end 

local attacker = params.attacker:CheckOwner()

if not attacker:IsRealHero() then return end

return 25

end


function modifier_target:OnTakeDamage(params)
if not IsServer() then return end
if not params.attacker then return end
if params.attacker:GetTeamNumber() == DOTA_TEAM_CUSTOM_5 or params.attacker:GetTeamNumber() == DOTA_TEAM_NEUTRALS then return end
if params.attacker:GetTeamNumber() == self:GetParent():GetTeamNumber() then return end
if params.unit ~= self:GetParent() then return end

local new = true

if #self.attackers > 0 then 

	for i = 1,#self.attackers do 
		if self.attackers[i][1] == params.attacker:GetTeamNumber() then 
			new = false
			self.attackers[i][2] = GameRules:GetDOTATime(false, false)
			break
		end
	end

end


if new == true then 
	local n = #self.attackers + 1
	self.attackers[n] = {}
	self.attackers[n][1] = params.attacker:GetTeamNumber()
	self.attackers[n][2] = GameRules:GetDOTATime(false, false)
end

end



function modifier_target:GetModifierProvidesFOWVision()
return 1
end

function modifier_target:OnTooltip()
return self.gold
end


function modifier_target:RemoveOnDeath() return false end

function modifier_target:OnDeath(params)
if not IsServer() then return end
if params.unit ~= self:GetParent() then return end
if params.attacker == nil then return end
if params.attacker:GetTeamNumber() == self:GetParent():GetTeamNumber() then return end
if params.attacker:GetTeamNumber() == DOTA_TEAM_CUSTOM_5 then return end
if params.unit:IsReincarnating() then return end

local attacker = params.attacker:CheckOwner()

if not attacker:IsRealHero() then return end


local heroes = {}

for _,a in pairs(self.attackers) do 
	if a[1] ~= attacker:GetTeamNumber() and (GameRules:GetDOTATime(false, false) - a[2]) < 15 then 
		if players[a[1]] ~= nil then 
			heroes[#heroes+1] = players[a[1]]
		end
	end
end

local enemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), nil, Target_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
	
for _,enemy in pairs(enemies) do 
	if not enemy:HasModifier("modifier_monkey_king_wukongs_command_custom_soldier") and not enemy:IsTempestDouble() then 
		local new = true

		for _,old in pairs(heroes) do 
			if old == enemy then 
				new = false
				break
			end
		end
		if new == true then 
			table.insert(heroes, enemy)
		end
	end
end



local net_self = PlayerResource:GetNetWorth(self:GetParent():GetPlayerOwnerID()) 


for _,hero in pairs(heroes) do 
	if hero ~= params.attacker then 

 		my_game:AddPurplePoints(hero, 1)

	end
end


for _,hero in pairs(players) do 

	EmitSoundOnEntityForPlayer("Hunt.End", hero, hero:GetPlayerOwnerID()) 

	local net_enemy = PlayerResource:GetNetWorth(hero:GetPlayerOwnerID())

	bonus_gold = 0

	if net_self > net_enemy then 
		bonus_gold = (net_self - net_enemy)*Target_gold_reward
	end

	hero:ModifyGold(bonus_gold , true , DOTA_ModifyGold_HeroKill)
	SendOverheadEventMessage(hero, 0, hero, bonus_gold, nil)

end 

end




function modifier_target:OnDestroy()
if not IsServer() then return end
CustomGameEventManager:Send_ServerToAllClients( 'TargetTimer_delete',  {})
--my_game:StartTargetCooldown()
self:GetParent():RemoveModifierByName("modifier_target_vision")

end


modifier_target_vision = class({})
function modifier_target_vision:IsHidden() return true end
function modifier_target_vision:IsPurgable() return false end
function modifier_target_vision:RemoveOnDeath() return false end
function modifier_target_vision:OnCreated(table)
if not IsServer() then return end
self:StartIntervalThink(0.3)
end

function modifier_target_vision:OnIntervalThink()
if not IsServer() then return end

for _,player in pairs(players) do
	AddFOWViewer(player:GetTeamNumber(), self:GetParent():GetAbsOrigin(), Target_radius, 0.3, false)
end

end