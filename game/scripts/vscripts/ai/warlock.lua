

function Spawn( entityKeyValues )
    if not IsServer() then
        return
    end
    if not IsValidEntity(thisEntity) then return end


    thisEntity.init = false
    thisEntity.tower = nil
    thisEntity.ulti = thisEntity:FindAbilityByName("warlock_boss_rain_of_chaos")
    thisEntity.upheaval = thisEntity:FindAbilityByName("warlock_boss_upheaval")
    thisEntity.word = thisEntity:FindAbilityByName("warlock_boss_shadow_word")



    thisEntity:SetContextThink( "bevavior", bevavior, FrameTime() )
end


function bevavior()
	if not IsValidEntity(thisEntity) then return -1 end

	if (not thisEntity:IsAlive()) then
        return -1
    end
	if GameRules:IsGamePaused() == true then
        return 0.5
    end

if not thisEntity.init then
    thisEntity.init = true

    local tower = FindUnitsInRadius(thisEntity:GetTeamNumber(), thisEntity:GetAbsOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BUILDING, 0, FIND_CLOSEST, false)
    for _,t in ipairs(tower) do
        if IsValidEntity(t) and t:GetUnitName() == "npc_towerradiant" or t:GetUnitName() == "npc_towerdire" then
            thisEntity.tower_location = t:GetAbsOrigin()
            thisEntity.tower = t
            break
        end
    end


end
	if not IsValidEntity(thisEntity.tower) then return -1 end
    if not thisEntity.tower:IsAlive() then thisEntity:ForceKill(false)
    return -1 end


    if thisEntity:IsChanneling() then
    	return 0.4
    end






---------------------------------------------------------------------------------------------------

local enemy_for_ability = nil


local enemy_for_ability = FindUnitsInRadius(thisEntity:GetTeamNumber(), thisEntity:GetAbsOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE , FIND_CLOSEST, false)

local enemy_for_attack = FindUnitsInRadius(thisEntity:GetTeamNumber(), thisEntity:GetAbsOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_CLOSEST, false)



local control = false
if thisEntity:IsSilenced() or thisEntity:IsHexed() then
    control = true
end

if control == false then


    if thisEntity.upheaval:IsFullyCastable() then

        if IsValidEntity(enemy_for_ability[1])
        and (thisEntity:GetAbsOrigin() - enemy_for_ability[1]:GetAbsOrigin()):Length2D()  <= thisEntity.upheaval:GetCastRange(thisEntity:GetAbsOrigin(), thisEntity)
            then

            thisEntity:CastAbilityOnPosition(enemy_for_ability[1]:GetAbsOrigin(), thisEntity.upheaval, 1)
            return 0.8
        end

    end



    if thisEntity.ulti:IsFullyCastable() then

        local target = nil 

        if IsValidEntity(enemy_for_ability[1]) and  (thisEntity:GetAbsOrigin() - enemy_for_ability[1]:GetAbsOrigin()):Length2D()  <= thisEntity.ulti:GetCastRange(thisEntity:GetAbsOrigin(), thisEntity) then 
            target = enemy_for_ability[1]
        else 
            if IsValidEntity(thisEntity:GetAttackTarget()) then 
                target = thisEntity:GetAttackTarget()
            end
        end    

        if target ~= nil then
            thisEntity:CastAbilityOnPosition(target:GetAbsOrigin(), thisEntity.ulti, 1)
            return 0.8
        end

    end


    if thisEntity.word:IsFullyCastable() and thisEntity:GetAttackTarget() ~= nil then

        thisEntity:CastAbilityNoTarget(thisEntity.word, 1)
        return 1.9
    end

end


local enemy = nil

if IsValidEntity(enemy_for_attack[1]) 
    and not enemy_for_attack[1]:IgnoredByCreeps()
    and (enemy_for_attack[1]:GetAbsOrigin() - thisEntity.tower:GetAbsOrigin()):Length2D() > 800 then
    enemy = enemy_for_attack[1]
end

for _, target in pairs(enemy_for_attack) do

    if IsValidEntity(target) 
    and not target:IgnoredByCreeps()
    and (target:GetAbsOrigin() - thisEntity.tower:GetAbsOrigin()):Length2D() > 800  
    and not target:IsInvulnerable() 
    and not target:IsAttackImmune() then
        enemy = target
        break
    end


end

if IsValidEntity(enemy) and (thisEntity:GetAbsOrigin() - thisEntity.tower_location):Length2D() > 1000 then
    thisEntity:SetForceAttackTarget(enemy)
    return 0.5
end


if ((thisEntity:GetAbsOrigin() - thisEntity.tower_location):Length2D() < 1000 ) or not IsValidEntity(enemy) then
    thisEntity:SetForceAttackTarget(thisEntity.tower)
    return 0.5
end



return 0.5


end
