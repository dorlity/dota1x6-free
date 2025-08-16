patrol_center =
{
	Vector(131.305, 3, 200),
	Vector(-51.9879, 45.3812, 200),
	Vector(-100.008, 209.3142, 200),
	--Vector(-101.906, 248.814, 200),
	Vector(157.341, 270.047, 200),
--	Vector(76.7689, 275.243, 200)
}


dota1x6.radiant_patrol_alive = false
dota1x6.dire_patrol_alive = false
dota1x6.current_patrol = 2


function dota1x6:RandomUnit(unit1,max)

local n = RandomInt(1, max)
if n == unit1 then 
	return dota1x6:RandomUnit(unit1,max)
else 
	return n
end

end


function dota1x6:spawn_patrol(side, item_1, item_2, second_tier, center_patrol, is_tormentor)

local units = {}
local count = 4


local base_unit = nil

if is_tormentor then
	if side == 0 then
		base_unit = Entities:FindByName(nil, "tormentor_base_radiant")
	else
		base_unit = Entities:FindByName(nil, "tormentor_base_dire")
	end
else
	if side == 0 then
		base_unit = Entities:FindByName(nil, "patrol_portal_radiant")
	else
		base_unit = Entities:FindByName(nil, "patrol_portal_dire")
	end
end

if not base_unit then return end

if is_tormentor == true then

	local point = base_unit:GetAbsOrigin()

	local unit = CreateUnitByName("npc_dota_tormentor_custom", point, false, nil, nil, DOTA_TEAM_NEUTRALS)
	local health_unit = CreateUnitByName("npc_dota_tormentor_custom_health", point, false, nil, nil, DOTA_TEAM_NEUTRALS)
	unit.is_patrol_creep = true

	local reflect_ability = unit:FindAbilityByName("patrol_tormentor_reflect_custom")
	if reflect_ability then
		reflect_ability:SetLevel(1)
	end

	local shield_ability = unit:FindAbilityByName("patrol_tormentor_shield_custom")
	if shield_ability then
		shield_ability:SetLevel(1)
	end

	unit:AddNewModifier(unit, nil, "modifier_tormentor_custom", {side = side, health_unit = health_unit:entindex()})
	health_unit:AddNewModifier(unit, nil, "modifier_tormentor_custom_health", {})
	return
end


for i = 1,count do 

	local point = base_unit:GetAbsOrigin()
	local name = ""

	if side == 0 then 
		name = "patrol_melee_good"
		if i > 3 then 
			name = "patrol_range_good"
		end
	else 
		name = "patrol_melee_bad"
		if i > 3 then 
			name = "patrol_range_bad"
		end
	end
	
	if center_patrol == true then 
		point = Vector(41,140,440)
	end

	local point = point + RandomVector(RandomInt(-100, 100))

	units[i] = CreateUnitByName(name, point, true, nil, nil, DOTA_TEAM_NEUTRALS)


	if center_patrol == true then 
		units[i].spawn = patrol_center[i]
		units[i].dire_patrol = true
	else
		local pos_name = ""
		local new_pos = units[i]:GetAbsOrigin()

		if side == 0 then 
			pos_name = "patrol_position_radiant_"..tostring(dota1x6.current_patrol).."_"..tostring(i)

			if second_tier == true then 
				pos_name = "patrol_position_radiant_"..i
			end

			units[i].radiant_patrol = true
		else 
			pos_name = "patrol_position_dire_"..tostring(dota1x6.current_patrol).."_"..tostring(i)

			if second_tier == true then 
				pos_name = "patrol_position_dire_"..i
			end
			units[i].dire_patrol = true
		end

		local pos_unit = Entities:FindByName(nil, pos_name)
		if pos_unit then
			new_pos = pos_unit:GetAbsOrigin()
		end
		units[i].spawn = new_pos
	end

	units[i]:AddNewModifier(units[i], nil, "modifier_patrol_death", {})
	units[i]:AddNewModifier(units[i], nil, "modifier_patrolupgrade", {})
	units[i].is_patrol_creep = true

end

local unit_1 = RandomInt(1, #units)
local unit_2 = dota1x6:RandomUnit(unit_1,#units)

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





function dota1x6:patrol_portal( side )


local point = Vector(0, 0, 343)

if side == 0 then 
	local portal_unit = Entities:FindByName(nil, "patrol_portal_radiant")
	if portal_unit then
		point = portal_unit:GetAbsOrigin()
	end
end

if side == 1 then 
	local portal_unit = Entities:FindByName(nil, "patrol_portal_dire")
	if portal_unit then
		point = portal_unit:GetAbsOrigin()
	end
end

if side == 3 then
	local base_unit = Entities:FindByName(nil, "tormentor_base_radiant")
	if base_unit then
		point = base_unit:GetAbsOrigin() + Vector(0, 0, 80)
	end
end

if side == 4 then
	local base_unit = Entities:FindByName(nil, "tormentor_base_dire")
	if base_unit then
		point = base_unit:GetAbsOrigin() + Vector(0, 0, 80)
	end
end


for team,tower in pairs(towers) do 

 	AddFOWViewer(team, point, 500, PortalDelay+0.3, false)
	local count = 0

	Timers:CreateTimer(0, function()
		GameRules:ExecuteTeamPing( team, point.x, point.y, players[dota1x6:FindPlayers(team)[1]], 0 )
		count = count + 1
		if count <= 1 then
			return 1.5
		end
	end)
end




local teleport_center = CreateUnitByName("npc_dota_companion", point, false, nil, nil, 0)
teleport_center:AddNewModifier(teleport_center, nil, "modifier_phased", {})
teleport_center:AddNewModifier(teleport_center, nil, "modifier_invulnerable", {})
teleport_center:AddNewModifier(teleport_center, nil, "modifier_unselect", {})


EmitSoundOn("UI.Creep_portal_loop", teleport_center)

teleport_center.nWarningFX = ParticleManager:CreateParticle( "particles/portals/portal_ground_spawn_endpoint.vpcf", PATTACH_WORLDORIGIN, nil )
ParticleManager:SetParticleControl( teleport_center.nWarningFX, 0, point )


Timers:CreateTimer(PortalDelay+0.3,function()
    ParticleManager:DestroyParticle(teleport_center.nWarningFX, true)
    teleport_center:StopSound("UI.Creep_portal_loop")
    teleport_center:EmitSound("UI.Creep_portal_end")
    teleport_center:Destroy()
end)


end