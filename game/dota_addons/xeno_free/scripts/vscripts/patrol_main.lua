LinkLuaModifier( "modifier_patrol_death", "modifiers/modifier_patrol_start", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_patrolupgrade", "modifiers/modifier_patrolupgrade", LUA_MODIFIER_MOTION_NONE )


patrol_2 = 
{
	Vector(-3722.85,-4363.31,100),
	Vector(-3900.02,-4305.05,100),
	Vector(-3935.01,-4138.93,100),
	--Vector(-3683.33,-3935.65,100),
	Vector(-3673.56,-4100.3,100),
--	Vector(-3504.33,-3909.39,100)
}


patrol_6 = 
{
	Vector(-4374.48,-128.081,100),
	Vector(-4464.17, 35.2387,100),
	Vector(-4374.19, 181.3878,100),
--	Vector(-4255.61,177.353,100),
	Vector(-4157.67,28.956,100),
--	Vector(-4038.56,90,100)
}


patrol_7 = 
{
	Vector(201.115,-4234.39,100),
	Vector(36.107,-4322.85,100),
	Vector(-108.55327,-4230.14,100),
--	Vector(-103.541,-4351.75,100),
	Vector(47.1609,-4015.58,100),
--	Vector(-12.1945,-4195.58,100)
}

patrol_3 = 
{
	Vector(4020.7,4276.45,100),
	Vector(4200.51,4222.9,100),
	Vector(4238.72,4055.87,100),
--	Vector(4052.88,3838.41,100),
	Vector(3976.48,4012.95,100),
--	Vector(3874.21,3809.98,100)
}


patrol_8 = 
{
	Vector(-391.702,4569.31,100),
	Vector(-220.326,4647,100),
	Vector(-81.385,4547.71,100),
--	Vector(-44.9347,4476.94,100),
	Vector(-249.606,4342.45,100),
--	Vector(-159.015,4336.52,100)
}

patrol_9 = 
{
	Vector(4458.96,-231.435,100),
	Vector(4538.06,-401.356,100),
	Vector(4439.54,-540.72,100),
	--Vector(4404.09,-550.473,100),
	Vector(4232.72,-374.685,100),
--	Vector(4259.71,-441.453,100)
}


patrol_center_1 =
{
	Vector(1943.07, 2437.35, 100),
	Vector(2121.56, 2378.35,100),
	Vector(2154.97, 2210.03,100),
--	Vector(2173.4, 2157.03,100),
	Vector(1891.38, 2175.5,100),
--	Vector(1939.94, 2110.17,100)
}

patrol_center_2 =
{
	Vector(-1656.04, -2431.67, 100),
	Vector(-1835.16, -2355.99, 100),
	Vector(-1870 ,-2188.23, 100),
--	Vector(-1893.61, -2143.13,100),
	Vector(-1607.34, -2150.3,100),
--	Vector(-1662.6, -2085.38,100)
}

patrol_center =
{
	Vector(131.305, 3, 200),
	Vector(-51.9879, 45.3812, 200),
	Vector(-100.008, 209.3142, 200),
	--Vector(-101.906, 248.814, 200),
	Vector(157.341, 270.047, 200),
--	Vector(76.7689, 275.243, 200)
}


my_game.radiant_patrol_alive = false
my_game.dire_patrol_alive = false
my_game.current_patrol = 2


function my_game:RandomUnit(unit1,max)

local n = RandomInt(1, max)
if n == unit1 then 
	return my_game:RandomUnit(unit1,max)
else 
	return n
end

end


function my_game:spawn_patrol(side,item_1,item_2, second_tier, center_patrol)

	local units = {}

	for i = 1,4 do 

		local point

		local name = ""

		if side == 0 then 
			point = Vector(-282, -457, 343)
			name = "patrol_melee_good"
			if i > 3 then 
				name = "patrol_range_good"
			end

		else 
			name = "patrol_melee_bad"
			point = Vector(428, 704, 343)
			if i > 3 then 
				name = "patrol_range_bad"
			end
		end
	
		
		if center_patrol == true then 

			point = Vector(41,140,440)
		
		end



		units[i] = CreateUnitByName(name, point + RandomVector(RandomInt(-100, 100)), true, nil, nil, DOTA_TEAM_NEUTRALS)


		local spawn_array = {}

		local radiant_net = {}
		local dire_net = {}


		for _,player in pairs(players) do
			if teleports[player:GetTeamNumber()] then 
				local team = teleports[player:GetTeamNumber()]:GetName()
				team = tonumber(team)

				if (side == 0) then 

				    if (team == 2) or (team == 6) or (team == 7) then 
				    	local i = #radiant_net+1
				    	radiant_net[i] = {}
				    	radiant_net[i].team = team
						radiant_net[i].gold = PlayerResource:GetNetWorth(player:GetPlayerOwnerID())
					end

				else 
				
				    if (team == 3) or (team == 8) or (team == 9) then 
				    	local i = #dire_net+1
				    	dire_net[i] = {}
				    	dire_net[i].team = team
						dire_net[i].gold = PlayerResource:GetNetWorth(player:GetPlayerOwnerID())
					end
				end
			end
		end

		local min_team = 2
		if side == 1 then 
			min_team = 3
		end

		local min_gold = 999999

		if side == 0 then 
			for _,r in pairs(radiant_net) do 
				if r.gold <= min_gold then 
					min_team = r.team
					min_gold = r.gold
				end
			end
	

		else 

			for _,r in pairs(dire_net) do 
				if r.gold <= min_gold then 
					min_team = r.team
					min_gold = r.gold
				end
			end
		end



		if center_patrol == true then 

			units[i].spawn = patrol_center[i]
			units[i].dire_patrol = true
		else 		


			if side == 0 then 

				if my_game.current_patrol == 1 then 
					units[i].spawn = patrol_6[i]
				end

				if my_game.current_patrol == 2 then 
					units[i].spawn = patrol_2[i]
				end

				if my_game.current_patrol == 3 then 
					units[i].spawn = patrol_7[i]
				end

				if second_tier == true then 
					units[i].spawn = patrol_center_2[i]
				end

				units[i].radiant_patrol = true
			else 

				if my_game.current_patrol == 1 then 
					units[i].spawn = patrol_9[i]
				end

				if my_game.current_patrol == 2 then 
					units[i].spawn = patrol_3[i]
				end

				if my_game.current_patrol == 3 then 
					units[i].spawn = patrol_8[i]
				end


				if second_tier == true then 
					units[i].spawn = patrol_center_1[i]
				end

				units[i].dire_patrol = true
			end

		end

		units[i]:AddNewModifier(units[i], nil, "modifier_patrol_death", {})
		units[i]:AddNewModifier(units[i], nil, "modifier_patrolupgrade", {})
	end


	local unit_1 = RandomInt(1, #units)
	local unit_2 = my_game:RandomUnit(unit_1,#units)



	units[unit_1].item = item_1

	if item_2 ~= "" then 
		units[unit_2].item = item_2
	end


	for _,unit in pairs(units) do 
		unit.friends = {}
		for _,friend in pairs(units) do 
			if friend ~= unit then 
				table.insert(unit.friends, friend)
			end
		end
	end


	
end





function my_game:patrol_portal( side )


local point = Vector(-282, -457, 343)

if side == 1 then 
	point = Vector(428, 704, 343)
end

if side == 2 then 
	point = Vector(41,140,440)
end

for team,player in pairs(players) do 

 	AddFOWViewer(team, point, 500, PortalDelay+0.3, false)


	if teleports[team] then 
		local teleport = teleports[team]:GetName()


		teleport = tonumber(teleport)

		if side == 2 or ((side == 0) and (teleport == 2 or teleport == 6 or teleport == 7)) or
			((side == 1) and (teleport == 3 or teleport == 8 or teleport == 9)) then 

 			local table_tips = CustomNetTables:GetTableValue("TipsType", tostring( players[team]:GetPlayerOwnerID()))
			local count = 0

			
			if table_tips.type == 2 or table_tips.type == 3 then
				Timers:CreateTimer(0, function()
					GameRules:ExecuteTeamPing( team, point.x, point.y, players[team], 0 )
					count = count + 1
					if count <= 1 then
						return 1.5
					end
				end)
			end
		end
	end
end




local teleport_center = CreateUnitByName("npc_dota_companion", point, false, nil, nil, 0)
teleport_center:AddNewModifier(teleport_center, nil, "modifier_phased", {})
teleport_center:AddNewModifier(teleport_center, nil, "modifier_invulnerable", {})
teleport_center:AddNewModifier(teleport_center, nil, "modifier_unselect", {})


EmitSoundOn("Hero_AbyssalUnderlord.DarkRift.Cast", teleport_center)

teleport_center.nWarningFX = ParticleManager:CreateParticle( "particles/portals/portal_ground_spawn_endpoint.vpcf", PATTACH_WORLDORIGIN, nil )
ParticleManager:SetParticleControl( teleport_center.nWarningFX, 0, point )


Timers:CreateTimer(PortalDelay+0.3,function()
    ParticleManager:DestroyParticle(teleport_center.nWarningFX, true)
    teleport_center:StopSound("Hero_AbyssalUnderlord.DarkRift.Cast")
    teleport_center:EmitSound("Hero_AbyssalUnderlord.DarkRift.Complete")
    teleport_center:Destroy()
end)


end