require("debug_")




function CDOTA_BaseNPC:IsValidKill(killer)

if killer:GetTeamNumber() == self:GetTeamNumber() then return false end
if not self:IsRealHero() or self:IsTempestDouble() then return false end
if self:IsReincarnating() then return false end 

return true
end 



function CDOTA_BaseNPC:CheckCastMods(ability)

for _,unit in pairs(self:FindTargets(1000)) do 
	for _,mod in pairs(unit:FindAllModifiers()) do 

		if mod.OnAbilityFullyCast ~= nil then 
			local params = 
			{
				ability = ability,
				unit = self,
			}
			mod:OnAbilityFullyCast(params)
		end 
	end 
end 


end 



function CDOTA_BaseNPC:GiveKillExp(target)

local diff = math.max(0, (target:GetCurrentXP() - self:GetCurrentXP()))
local exp = 100 + 0.04*target:GetCurrentXP() + diff*0.2

--print(exp)

self:AddExperience(exp, 0, false, false)
end 


function CDOTA_BaseNPC:TargetLockedOnBase(target)

local target_mod = target:FindModifierByName("modifier_backdoor_knock_aura_damage")

if not target_mod or not target_mod.target then return false end
if target_mod.target == self then return false end

return true
end 



function CDOTA_BaseNPC:IsOnSameBaseWith(target)

local mod = self:FindModifierByName("modifier_backdoor_knock_aura_damage")

if not mod then 
	return 1
end 

if (mod and mod.target and mod.target == target)  then 
	return 3
end 

return 2
end 



function CDOTA_BaseNPC:GetTalentValue(name, property, ignore_level)



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

local level = self:FindModifierByName(name):GetStackCount()

if level == 0 then return 0 end


if type(value) == "table" then
	return value[level]
else
	return value
end

return 0
end



function CDOTA_BaseNPC:IsLeashed()
if not IsServer() then return end

for _, mod in pairs(self:FindAllModifiers()) do
    local tables = {}
    mod:CheckStateToTable(tables)
    local bkb_allowed = true

    if mod:GetAbility() then 
		local behavior = mod:GetAbility():GetAbilityTargetFlags()

    	if bit.band(behavior, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES) == 0 and self:IsDebuffImmune() then 
    		bkb_allowed = false
    	end 
    end 

    if bkb_allowed == true then 
	    for state_name, mod_table in pairs(tables) do
	        if tostring(state_name) == '45'  then
	             return true
	        end
	    end
	end
end
return false
end







function CDOTA_BaseNPC:IgnoredByCreeps()


if self:IsCourier() or self:GetUnitName() == "npc_teleport" or self:GetUnitName() == "npc_dota_donate_item_illusion" then 
	return true
end

local mods =
{
	["modifier_monkey_king_wukongs_command_custom_soldier"] = true,
	["modifier_monkey_king_mischief_custom"] = true,
	["modifier_donate_pet"] = true,
	["modifier_arc_warden_tempest_double_custom_far"] = true
}


for _,mod in pairs(self:FindAllModifiers()) do 
	if mods[mod:GetName()] then 
		return true
	end
end 

return false
end 

function CDOTA_BaseNPC:CheckOwner()
if self.owner then 
	return self.owner
else 
	return self
end 

end



function CDOTA_BaseNPC:TeleportThink()

if self:IsRooted() or self:IsLeashed() or self:IsHexed() or
    self:HasModifier("modifier_custom_puck_phase_shift") then

    return false
end

return true
end




function CDOTA_BaseNPC:GetValueQuas(ability, value)
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


function CDOTA_BaseNPC:GetValueWex(ability, value)
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

function CDOTA_BaseNPC:GetValueExort(ability, value)
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







function CDOTA_BaseNPC:GetWexCd(new_stack)

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



function CDOTA_BaseNPC:GetQuasHeal(new_stack)

local ability = self:FindAbilityByName("invoker_quas_custom")
if not ability then return 0 end 

local stack = 0
if new_stack then 
	stack = new_stack
else
	if self:HasModifier("modifier_invoker_quas_custom_passive") then 
		stack = self:GetUpgradeStack("modifier_invoker_quas_custom_passive")
	end 
end 

local heal = ability:GetSpecialValueFor("spell_lifesteal")

return heal*stack
end 	



function CDOTA_BaseNPC:GetExortDamage(new_stack)

local ability = self:FindAbilityByName("invoker_exort_custom")
if not ability then return 0 end 

local stack = 0
if new_stack then 
	stack = new_stack
else
	if self:HasModifier("modifier_invoker_exort_custom_passive") then 
		stack = self:GetUpgradeStack("modifier_invoker_exort_custom_passive")
	end 
end 

local damage = ability:GetSpecialValueFor("spell_amp")

return damage*stack
end 	



function CDOTA_BaseNPC:IsTalentIllusion()

return self:HasModifier("modifier_muerta_dead_shot_custom_legendary")
	or self:HasModifier("modifier_skeleton_king_hellfire_blast_custom_illusion") 
	or self:HasModifier("modifier_razor_plasma_field_custom_legendary") 
end

function CDOTA_BaseNPC:GetUpgradeStack(mod)
	if self:HasModifier(mod) then 
		return self:GetModifierStackCount(mod, self)
	end
	return 0
end

function CDOTA_BaseNPC:HasShard()
	return self:HasModifier("modifier_item_aghanims_shard")
end


function CDOTA_BaseNPC:UpgradeIllusion(mod, stack, modifier)

	local ability = nil 

	if modifier then 
		ability = modifier:GetAbility()
	end

	local i = self:AddNewModifier(self, ability, mod, {})
	i:SetStackCount(stack)
end

function CDOTA_BaseNPC:IsDebuffImmune()
if not IsServer() then return end

for _, mod in pairs(self:FindAllModifiers()) do

    local tables = {}
    mod:CheckStateToTable(tables)
    for state_name, mod_table in pairs(tables) do
        if tostring(state_name) == '56'  then
             return true
        end
    end

end

return false
end




function CDOTA_BaseNPC:FindTargets(radius, point)

local search_point = self:GetAbsOrigin()

if point then 
	search_point = point
end 

local units = FindUnitsInRadius( self:GetTeamNumber(), search_point, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST,false)
  
return units
end 



function CDOTA_BaseNPC:PrintModifiers()

print('-------- ',self:GetUnitName(),' ----------')

for _,mod in pairs(self:FindAllModifiers()) do
	print(mod:GetName())
end

print('-------------------------')


end 



function CDOTA_BaseNPC:IsMidPlayer()

local teleport = teleports[self:GetTeam()]



if teleport and (teleport:GetName() == "2" or teleport:GetName() == "3") then 
	return true
end 

return false
end 


function CDOTA_BaseNPC:GetBase()

local teleport = teleports[self:GetTeam()]

if teleport then 
	return tonumber(teleport:GetName())
end 

return -1
end 


function CDOTA_BaseNPC:IsOnDuel()
if not self.duel_data then return false end 
if not duel_data[self.duel_data] then return false end 

if duel_data[self.duel_data].stage ~= 2 then return false end

return true
end 



function CDOTA_BaseNPC:CanTeleport()

if self:HasModifier("modifier_custom_pudge_dismember_no_tp") or self:HasModifier("modifier_snapfire_mortimer_kisses_custom_gobble_caster")
	or self:HasModifier("modifier_custom_puck_phase_shift") or self:HasModifier("modifier_pangolier_gyroshell_custom")
	or self:HasModifier("modifier_sniper_headshot_custom_legendary") or self:HasModifier("modifier_custom_void_dissimilate") then 
		
	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetPlayerOwnerID()), "CreateIngameErrorMessage", {message = "#cant_tp"})
	
	return false
end 


return true
end 


function CDOTA_BaseNPC:CdItems(amount)



for i = 0, 8 do
    local current_item = self:GetItemInSlot(i)


    if current_item and not NoCdItems[current_item:GetName()] then  
      local cd = current_item:GetCooldownTimeRemaining()
      
      if test then 
      	print('before:', cd)
  	  end 

      current_item:EndCooldown()

      if cd > math.abs(amount) then 
        current_item:StartCooldown(cd - math.abs(amount))
      end


      if test then 
      	print('after:', current_item:GetCooldownTimeRemaining())
  	  end 

	  if test then 
      	print('------')
  	  end 

    end
end


end 


function CDOTA_BaseNPC:CdAbility(ability, amount)
  
local reduce_cd = math.abs(amount) 

if test then 
	print('-----')
	print(ability:GetCooldownTime())
end 

local cd = ability:GetCooldownTime()
ability:EndCooldown()
if cd > reduce_cd then 
	ability:StartCooldown(cd - reduce_cd)
end 

if test then 
	print(ability:GetCooldownTime())
	print('-----')
end 

return ability:GetCooldownTime() <= 0.1

end 



function CDOTA_BaseNPC:BkbAbility(ability, pierce_bkb)
if not IsServer() then return end

local new_ability = ability
if pierce_bkb and self:HasAbility("custom_bkb_effects") then 
	new_ability = self:FindAbilityByName("custom_bkb_effects")
end

return new_ability 
end


function CDOTA_BaseNPC:ApplyStun(ability, pierce_bkb, caster, duration)
if not IsServer() then return end

local stun_ability = ability
if pierce_bkb and caster:HasAbility("custom_bkb_effects") then 
	stun_ability = caster:FindAbilityByName("custom_bkb_effects")
end
		
self:AddNewModifier(caster, stun_ability, "modifier_stunned", {duration = duration*(1 - self:GetStatusResistance())})

end


function CDOTA_BaseNPC:SendNumber(type, number)

SendOverheadEventMessage(self, type, self, number, nil)
end 



function CDOTA_BaseNPC:GenericHeal(heal, ability, no_text, effect)
if not IsServer() then return end

self:Heal(heal, ability)

local part = "particles/generic_gameplay/generic_lifesteal.vpcf"

if effect then 
	part = effect
end

local particle = ParticleManager:CreateParticle( part, PATTACH_ABSORIGIN_FOLLOW, self )
ParticleManager:ReleaseParticleIndex( particle )


if no_text and no_text == true then return end

SendOverheadEventMessage(self, 10, self, heal, nil)
end


function CDOTA_BaseNPC:SetQuest(table)

self.quest = {}
self.quest.name = table.name and table.name or ""
self.quest.exp = table.exp and table.exp or 0
self.quest.shards = table.shards and table.shards or 0
self.quest.icon = table.icon and table.icon or ""
self.quest.goal = table.goal and table.goal or 0
self.quest.number = table.number and table.number or 0
self.quest.legendary = table.legendary
self.quest.progress = 0
self.quest.completed = 0

CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetPlayerOwnerID()), 'hero_quest_init',
 {
 	name = self.quest.name,
 	exp = self.quest.exp,
 	shards = self.quest.shards,
 	icon = self.quest.icon,
 	goal = self.quest.goal,
 	legendary = self.quest.legendary
 }) 
end



function CDOTA_BaseNPC:UpdateQuest(inc)
if not self.quest then return end 
if inc == nil then return end

if self.quest.completed == 1 then 
	return
end

self.quest.progress = math.min(self.quest.goal, (self.quest.progress + inc))

if (self.quest.progress >= self.quest.goal) then 
	self.quest.completed = 1

	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetPlayerOwnerID()), 'hero_quest_complete', {}) 
else 
	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetPlayerOwnerID()), 'hero_quest_update',
	 {
	 	goal = self.quest.goal,
	 	progress = self.quest.progress,
	 	icon = self.quest.icon,
	 	inc = inc,
	 }) 
end

end


function CDOTA_BaseNPC:QuestCompleted()

local complete = false

if self.quest and self.quest.completed == 1 then 
	complete = true
end

return complete
end



function CDOTA_BaseNPC:GetQuest()
local name = nil 

if self.quest and self.quest.name then 
	name = self.quest.name
end

return name
end



function CDOTA_BaseNPC:IsPatrolCreep()
if self:GetUnitName() == "patrol_melee_good" or 
	self:GetUnitName() == "patrol_range_good" or 
	self:GetUnitName() == "patrol_melee_bad" or
	self:GetUnitName() == "patrol_range_bad" then return true end

return false

end







function CDOTABaseAbility:GetState()
	return self:GetAutoCastState()
end


CDOTA_Ability_Lua.GetCastRangeBonus = function(self, hTarget)
	if not self or self:IsNull() then
		return 0
	end

	local caster = self:GetCaster()
	if not caster or caster:IsNull() then
		return 0
	end

	return caster:GetCastRangeBonus()
end
 
CDOTABaseAbility.GetCastRangeBonus = function(self, hTarget)
	if not self or self:IsNull() then
		return 0
	end

	local caster = self:GetCaster()
	if not caster or caster:IsNull() then
		return 0
	end

	return caster:GetCastRangeBonus()
end

CDOTA_BaseNPC.StartGesture_old = CDOTA_BaseNPC.StartGesture
CDOTA_BaseNPC.StartGesture = function(npc, activity)
	if type(activity) == "number" then
		npc:StartGesture_old(activity)
	else
		Debug:Log("invalid StartGesture(" .. npc:GetUnitName() .. ", " .. tostring(activity) .. ") at " .. debug.traceback())
	end
end

CDOTA_BaseNPC.StartGestureFadeWithSequenceSettings_old = CDOTA_BaseNPC.StartGestureFadeWithSequenceSettings
CDOTA_BaseNPC.StartGestureFadeWithSequenceSettings = function(npc, activity)
	if type(activity) == "number" then
		npc:StartGestureFadeWithSequenceSettings_old(activity)
	else
		Debug:Log("invalid StartGestureFadeWithSequenceSettings(" .. npc:GetUnitName() .. ", " .. tostring(activity) .. ") at " .. debug.traceback())
	end
end

CDOTA_BaseNPC.StartGestureWithFade_old = CDOTA_BaseNPC.StartGestureWithFade
CDOTA_BaseNPC.StartGestureWithFade = function(npc, activity, fadeIn, fadeOut)
	if type(activity) == "number" then
		npc:StartGestureWithFade_old(activity, fadeIn, fadeOut)
	else
		Debug:Log("invalid StartGestureWithFade(" .. npc:GetUnitName() .. ", " .. tostring(activity) .. ", " .. tostring(fadeIn) .. ", " .. tostring(fadeOut) .. ") at " .. debug.traceback())
	end
end

CDOTA_BaseNPC.StartGestureWithPlaybackRate_old = CDOTA_BaseNPC.StartGestureWithPlaybackRate
CDOTA_BaseNPC.StartGestureWithPlaybackRate = function(npc, activity, rate)
	if type(activity) == "number" then
		npc:StartGestureWithPlaybackRate_old(activity, rate)
	else
		Debug:Log("invalid StartGestureWithPlaybackRate(" .. npc:GetUnitName() .. ", " .. tostring(activity) .. ", " .. tostring(rate) .. ") at " .. debug.traceback())
	end
end

CDOTA_BaseNPC.FadeGesture_old = CDOTA_BaseNPC.FadeGesture
CDOTA_BaseNPC.FadeGesture = function(npc, activity)
	if type(activity) == "number" then
		npc:FadeGesture_old(activity)
	else
		Debug:Log("invalid FadeGesture(" .. npc:GetUnitName() .. ", " .. tostring(activity) .. ") at " .. debug.traceback())
	end
end

CDOTA_BaseNPC.RemoveGesture_old = CDOTA_BaseNPC.RemoveGesture
CDOTA_BaseNPC.RemoveGesture = function(npc, activity)
	if type(activity) == "number" then
		npc:RemoveGesture_old(activity)
	else
		Debug:Log("invalid RemoveGesture(" .. npc:GetUnitName() .. ", " .. tostring(activity) .. ") at " .. debug.traceback())
	end
end
