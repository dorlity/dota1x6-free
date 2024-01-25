LinkLuaModifier("modifier_monkey_king_wukongs_command_custom_soldier_active", "abilities/monkey_king/monkey_king_wukongs_command_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_monkey_king_wukongs_command_custom_thinker", "abilities/monkey_king/monkey_king_wukongs_command_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_monkey_king_wukongs_command_custom_soldier", "abilities/monkey_king/monkey_king_wukongs_command_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_monkey_king_wukongs_command_custom_buff", "abilities/monkey_king/monkey_king_wukongs_command_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_monkey_king_wukongs_command_custom_effect", "abilities/monkey_king/monkey_king_wukongs_command_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_monkey_king_wukongs_command_custom_scepter", "abilities/monkey_king/monkey_king_wukongs_command_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_monkey_king_wukongs_command_custom_cooldown", "abilities/monkey_king/monkey_king_wukongs_command_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_monkey_king_wukongs_command_custom_slow", "abilities/monkey_king/monkey_king_wukongs_command_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_monkey_king_wukongs_command_custom_run", "abilities/monkey_king/monkey_king_wukongs_command_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_monkey_king_wukongs_command_custom_rapier", "abilities/monkey_king/monkey_king_wukongs_command_custom", LUA_MODIFIER_MOTION_NONE)

monkey_king_wukongs_command_custom = class({})

function monkey_king_wukongs_command_custom:GetAbilityTextureName()
    if self:GetCaster():HasModifier("modifier_monkey_king_demon_tricker_custom") then
        return "monkey_king_wukongs_command_ti9"
    end
    return "monkey_king_wukongs_command"
end

monkey_king_wukongs_command_custom.soldiers_max = 7
monkey_king_wukongs_command_custom.soldiers_scepter = 2

monkey_king_wukongs_command_custom.attack_interval = {-0.1, -0.2, -0.3}

monkey_king_wukongs_command_custom.cd_inc = {-10, -20, -30}

monkey_king_wukongs_command_custom.attack_heal = {20, 30, 40}

monkey_king_wukongs_command_custom.slow_turn = -10
monkey_king_wukongs_command_custom.slow_move = -5
monkey_king_wukongs_command_custom.slow_max = 6
monkey_king_wukongs_command_custom.slow_duration = 3
monkey_king_wukongs_command_custom.slow_range = 80

monkey_king_wukongs_command_custom.death_cast = 0.5
monkey_king_wukongs_command_custom.death_heal = 0.25




function monkey_king_wukongs_command_custom:Precache(context)

PrecacheResource( "particle", 'particles/units/heroes/hero_monkey_king/monkey_king_fur_army_cast.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_monkey_king/monkey_king_fur_army_positions.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_monkey_king/monkey_king_fur_army_attack.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_monkey_king/monkey_king_furarmy_ring.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_oracle/oracle_false_promise_heal.vpcf', context )
PrecacheResource( "particle", 'particles/status_fx/status_effect_monkey_king_fur_army.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_monkey_king/monkey_king_spring_slow.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_sniper/sniper_headshot_slow.vpcf', context )
PrecacheResource( "particle", 'particles/status_fx/status_effect_monkey_king_spring_slow.vpcf', context )

end



function monkey_king_wukongs_command_custom:GetCooldown(iLevel)

local bonus = 0
if self:GetCaster():HasModifier("modifier_monkey_king_command_2") then 
  bonus = self.cd_inc[self:GetCaster():GetUpgradeStack("modifier_monkey_king_command_2")]
end

 return self.BaseClass.GetCooldown(self, iLevel) + bonus
 
end

function monkey_king_wukongs_command_custom:GetCastPoint()
if self:GetCaster():HasModifier("modifier_monkey_king_command_5") then 
	return self.death_cast
end
return 0.8
end



function monkey_king_wukongs_command_custom:GetCastAnimation()
	return ACT_DOTA_MK_FUR_ARMY
end

function monkey_king_wukongs_command_custom:GetCastRange(vLocation, hTarget)
	return self:GetSpecialValueFor("cast_range")
end

function monkey_king_wukongs_command_custom:GetAOERadius()
	return self:GetSpecialValueFor("second_radius")
end

function monkey_king_wukongs_command_custom:GetIntrinsicModifierName()
	return "modifier_monkey_king_wukongs_command_custom_scepter"
end

function monkey_king_wukongs_command_custom:OnAbilityPhaseStart()
self:GetCaster():EmitSound("Hero_MonkeyKing.FurArmy.Channel")
	
	local max = self:GetSpecialValueFor("num_first_soldiers") + self:GetSpecialValueFor("num_second_soldiers")

	if not self.soldiers or #self.soldiers < max then 

		for i = 1, self.soldiers_max do
			self:CreateSoldier(i)
		end

	end
    local particle_name = "particles/units/heroes/hero_monkey_king/monkey_king_fur_army_cast.vpcf"
    if self:GetCaster():HasModifier("modifier_monkey_king_demon_tricker_custom") then
        particle_name = "particles/econ/items/monkey_king/mk_ti9_immortal/mk_ti9_immortal_army_cast.vpcf"
    end
	self.cast_particle = ParticleManager:CreateParticle(particle_name, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	return true
end

function monkey_king_wukongs_command_custom:OnAbilityPhaseInterrupted()
	self:GetCaster():StopSound("Hero_MonkeyKing.FurArmy.Channel")
	if self.cast_particle ~= nil then
		ParticleManager:DestroyParticle(self.cast_particle, true)
		self.cast_particle = nil
	end
	return true
end
function monkey_king_wukongs_command_custom:OnSpellStart()
    if self.cast_particle ~= nil then
        ParticleManager:DestroyParticle(self.cast_particle, false)
        self.cast_particle = nil
    end

    local position = self:GetCursorPosition()
    local cast_range = self:GetSpecialValueFor("cast_range") + self:GetCaster():GetCastRangeBonus()

    self:GetCaster():RemoveModifierByName("modifier_monkey_king_tree_dance_custom")
	FindClearSpaceForUnit(self:GetCaster(), self:GetCaster():GetAbsOrigin(), false)

    local vDirection = position - self:GetCaster():GetAbsOrigin()
    vDirection.z = 0
    position = GetGroundPosition(self:GetCaster():GetAbsOrigin()+vDirection:Normalized()*math.min(vDirection:Length2D(), cast_range), self:GetCaster())

    local first_radius = self:GetSpecialValueFor("first_radius")
    local second_radius = self:GetSpecialValueFor("second_radius")
    local scepter_third_radius = self:GetSpecialValueFor("scepter_third_radius")
    local num_first_soldiers = self:GetSpecialValueFor("num_first_soldiers")
    local num_second_soldiers = self:GetSpecialValueFor("num_second_soldiers")
    local duration = self:GetSpecialValueFor("duration")
    local max_radius = second_radius

    if self.thinker then
        UTIL_Remove(self.thinker)
    end


	self.thinker = CreateModifierThinker(self:GetCaster(), self, "modifier_monkey_king_wukongs_command_custom_thinker", {radius = max_radius}, position, self:GetCaster():GetTeamNumber(), false)

    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_monkey_king_wukongs_command_custom_buff", {duration=duration})

        for i = 1, num_second_soldiers, 1 do
            Timers:CreateTimer(i*0.1, function()
                if self:GetCaster():HasModifier("modifier_monkey_king_wukongs_command_custom_buff") then
                    local soldier = self:GetFreeSoldier()
    
                    local vTargetPosition = GetGroundPosition(position + second_radius*Rotation2D(Vector(0,1,0), math.rad((i-0.25)*360/num_second_soldiers)), soldier)
    
                    soldier:RemoveModifierByName("modifier_monkey_king_wukongs_command_custom_soldier_active")

                    soldier:AddNewModifier(self:GetCaster(), self, "modifier_monkey_king_wukongs_command_custom_soldier_active", {position=position, radius = max_radius, target_position=vTargetPosition, ultimate = true})
                end
            end)
        end

	Timers:CreateTimer(num_first_soldiers*0.1, function()

        for i = 1, num_first_soldiers, 1 do
        Timers:CreateTimer(i*0.1, function()
            if self:GetCaster():HasModifier("modifier_monkey_king_wukongs_command_custom_buff") then
                local soldier = self:GetFreeSoldier()
    
                local vTargetPosition = GetGroundPosition(position + first_radius*Rotation2D(Vector(0,1,0), math.rad((i-0.5)*360/num_first_soldiers)), soldier)
    
                soldier:RemoveModifierByName("modifier_monkey_king_wukongs_command_custom_soldier_active")
    
                soldier:AddNewModifier(self:GetCaster(), self, "modifier_monkey_king_wukongs_command_custom_soldier_active", {position=position, radius = max_radius, target_position=vTargetPosition, ultimate = true})
            end
        end)
    end

    end)

    self.vLastPosition = position
end






function monkey_king_wukongs_command_custom:GetFreeSoldier()
if not IsServer() then return end


if not self.soldiers then return end

local new_monkey = nil

local max_time = 0
local j = 0 

for i,monkey_scepter in pairs(self.soldiers) do

	local mod = monkey_scepter:FindModifierByName("modifier_monkey_king_wukongs_command_custom_soldier_active")

	if monkey_scepter and not monkey_scepter:IsNull() and not mod then
		new_monkey = monkey_scepter
		break
	end

	if mod and mod:GetElapsedTime() > max_time then 
		max_time = mod:GetElapsedTime()
		j = i
	end
end

if new_monkey == nil then 
	new_monkey = self.soldiers[j] 
end


return new_monkey

end







function monkey_king_wukongs_command_custom:CreateSoldier(count)

	if self.soldiers == nil then self.soldiers = {} end

	if #self.soldiers >= self.soldiers_max then return end


	local soldier = CreateUnitByName(self:GetCaster():GetUnitName(), self:GetCaster():GetAbsOrigin(), false, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber())
	
	if soldier then
		soldier.owner = self:GetCaster()
		soldier:AddNewModifier(self:GetCaster(), self, "modifier_monkey_king_wukongs_command_custom_soldier", nil)
		table.insert(self.soldiers, soldier)
	end
end

function monkey_king_wukongs_command_custom:SpawnMonkeyKingPointScepter(point, duration, teleport, no_particle)
if not self:GetCaster():IsRealHero() then return end
if not self.soldiers then return end

local new_monkey = self:GetFreeSoldier()
if not new_monkey then return end

new_monkey:RemoveModifierByName("modifier_monkey_king_wukongs_command_custom_soldier_active")

local origin = nil
if teleport then 
	origin = point
end
new_monkey:AddNewModifier(self:GetCaster(), self, "modifier_monkey_king_wukongs_command_custom_soldier_active", {position=point, radius = max_radius, target_position=point, duration = duration, ultimate = false, origin = origin, no_particle = no_particle})
		


return new_monkey
end

function monkey_king_wukongs_command_custom:CreateSoldiers()
if self:GetCaster():HasModifier("modifier_monkey_king_wukongs_command_custom_soldier") then return end
local count = 1

if self.soldiers == nil then 
	count = 1
	self.soldiers = {} 
else 
	count = #self.soldiers
end

print('start mk', count, self.soldiers_max)

for i = count, self.soldiers_max do
	Timers:CreateTimer(
        "mk"..i,
        {
            useGameTime = false,
            endTime = 0.5*i,
            callback = function()
            self:CreateSoldier(i)
            end
        }
    )
end

end

function monkey_king_wukongs_command_custom:IsHiddenWhenStolen()
	return false
end

modifier_monkey_king_wukongs_command_custom_cooldown = class({})

function modifier_monkey_king_wukongs_command_custom_cooldown:IsPurgable() return false end
function modifier_monkey_king_wukongs_command_custom_cooldown:RemoveOnDeath() return false end
function modifier_monkey_king_wukongs_command_custom_cooldown:IsDebuff() return true end

modifier_monkey_king_wukongs_command_custom_scepter = class({})

function modifier_monkey_king_wukongs_command_custom_scepter:IsHidden() return true end
function modifier_monkey_king_wukongs_command_custom_scepter:IsPurgable() return false end
function modifier_monkey_king_wukongs_command_custom_scepter:OnCreated()
if not IsServer() then return end
self.init_scepter = false 
self:StartIntervalThink(0.2)
end

function modifier_monkey_king_wukongs_command_custom_scepter:OnIntervalThink()
if not IsServer() then return end
if not self:GetParent():IsRealHero() then return end

if (self:GetParent():HasScepter() or self:GetParent():HasModifier("modifier_monkey_king_command_4") or self:GetParent():HasModifier("modifier_monkey_king_command_7")) and self.init_scepter == false then 

	--self:GetAbility().soldiers_max = self:GetAbility().soldiers_max + self:GetAbility().soldiers_scepter
	--self:GetAbility():CreateSoldiers()
	self.init_scepter = true
end

if not self:GetParent():HasScepter() then return end
if self:GetParent():HasModifier("modifier_monkey_king_wukongs_command_custom_soldier") then return end
if not self:GetParent():IsAlive() then return end
if self:GetParent():IsInvisible() then return end
if self:GetParent():HasModifier("modifier_monkey_king_mischief_custom") then return end
if self:GetParent():HasModifier("modifier_generic_arc") then return end
if self:GetParent():HasModifier("modifier_monkey_king_tree_dance_custom") then return end
if self:GetParent():HasModifier("modifier_monkey_king_tree_dance_custom_jump") then return end
if self:GetParent():HasModifier("modifier_monkey_king_transform") then return end
if self:GetParent():HasModifier("modifier_final_duel_start") then return end
if self:GetParent():HasModifier("modifier_monkey_king_wukongs_command_custom_cooldown") then return end

self:GetAbility():SpawnMonkeyKingPointScepter(self:GetParent():GetAbsOrigin()+RandomVector(RandomInt(100, 300)), self:GetAbility():GetSpecialValueFor("scepter_spawn_duration"))
self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_monkey_king_wukongs_command_custom_cooldown", {duration = 4})
end













modifier_monkey_king_wukongs_command_custom_soldier_active = class({})

function modifier_monkey_king_wukongs_command_custom_soldier_active:IsHidden()
	return true
end

function modifier_monkey_king_wukongs_command_custom_soldier_active:IsPurgable()
	return false
end

function modifier_monkey_king_wukongs_command_custom_soldier_active:IsPurgeException()
	return false
end

function modifier_monkey_king_wukongs_command_custom_soldier_active:OnCreated(params)
self.attack_speed = self:GetAbility():GetSpecialValueFor("attack_speed")

if self:GetCaster():HasModifier("modifier_monkey_king_command_1") then 
    self.attack_speed = self.attack_speed + self:GetCaster():GetTalentValue("modifier_monkey_king_command_1", "speed")
end


self.attack_range = self:GetCaster():Script_GetAttackRange()
if self:GetCaster():HasModifier("modifier_monkey_king_command_6") then 
	self.attack_range = self.attack_range + self:GetAbility().slow_range
end

self.damage_reduction = self:GetAbility():GetSpecialValueFor("damage_reduction")

self.move_speed = 550

if IsServer() then
	local soldier = self:GetParent()
	local hCaster = self:GetCaster()

	self:GetParent():SetDayTimeVisionRange(600)
	self:GetParent():SetNightTimeVisionRange(600)

	for i = 0, 18 do
		local item = self:GetParent():GetItemInSlot(i)
		if item then
			item:Destroy()
		end
	end


	local jingu_caster = self:GetCaster():FindAbilityByName("monkey_king_jingu_mastery_custom")
	local jingu_parent = self:GetParent():FindAbilityByName("monkey_king_jingu_mastery_custom")

	if jingu_caster and jingu_parent then 
		if self:GetCaster():HasScepter() then
			jingu_parent:SetLevel(jingu_caster:GetLevel())
		else 
			jingu_parent:SetLevel(0)
		end
	end

	for i = 0, 18 do
		local item = self:GetCaster():GetItemInSlot(i)
		if item then
			local new_item = CreateItem(item:GetName(), nil, nil)
    		local soldier_item = self:GetParent():AddItem(new_item)

			if soldier_item:GetName() == "item_rapier" then 
				self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_monkey_king_wukongs_command_custom_rapier", {})
			end
			soldier_item:SetPurchaser(nil)


    		if item and item:GetCurrentCharges() > 0 and new_item and not new_item:IsNull() then
    			new_item:SetCurrentCharges(item:GetCurrentCharges())
    		end
    		if new_item and not new_item:IsNull() then 
    			self:GetParent():SwapItems(new_item:GetItemSlot(), i)
    		end
		end
	end

	for level = 1, self:GetCaster():GetLevel() do
		if self:GetParent():GetLevel() < self:GetCaster():GetLevel() then
			self:GetParent():HeroLevelUp(false)
		end
	end

	for _,mod in pairs(self:GetCaster():FindAllModifiers()) do
    	if mod.StackOnIllusion ~= nil and mod.StackOnIllusion == true or mod:GetName() == "modifier_item_ultimate_scepter_consumed"
    	or mod:GetName() == "modifier_item_aghanims_shard" then

    		local old_mod = self:GetParent():FindModifierByName(mod:GetName())
    		if not old_mod then
        		old_mod = self:GetParent():AddNewModifier(self:GetParent(), nil, mod:GetName(), {})
        	end
    		old_mod:SetStackCount(mod:GetStackCount())
        end
    end





	self.outer_attack_buffer = self:GetAbility():GetSpecialValueFor("outer_attack_buffer")
	self.radius = params.radius
	self.position = StringToVector(params.position)
	self.target_position = StringToVector(params.target_position)
	self.target = nil
	self.ultimate = params.ultimate

	self.origin = hCaster:GetAbsOrigin()

	if params.origin ~= nil then 
		self.origin = StringToVector(params.origin)
	end
	soldier:SetAbsOrigin(self.origin)

	self:StartIntervalThink((self.target_position-soldier:GetAbsOrigin()):Length()/self.move_speed)

	self.phase = "moving"

	soldier:MoveToPosition(self.target_position)

	soldier:AddNewModifier(hCaster, self:GetAbility(), "modifier_monkey_king_wukongs_command_custom_effect", nil)

	self.attack_time_record = GameRules:GetGameTime()

	if not params.no_particle then 
        local particle_name = "particles/units/heroes/hero_monkey_king/monkey_king_fur_army_positions.vpcf"
        if self:GetCaster():HasModifier("modifier_monkey_king_demon_tricker_custom") then
            particle_name = "particles/econ/items/monkey_king/mk_ti9_immortal/mk_ti9_immortal_army_positions.vpcf"
        end
		self.particleID = ParticleManager:CreateParticle(particle_name, PATTACH_WORLDORIGIN, nil)
		ParticleManager:SetParticleControl(self.particleID, 0, self.target_position)

		self:AddParticle(self.particleID, false, false, -1, false, false)
	end

	Timers:CreateTimer(FrameTime(), function()
		soldier:RemoveNoDraw()
	end)
end


end

function modifier_monkey_king_wukongs_command_custom_soldier_active:OnDestroy()
	if IsServer() then
		if self.particleID then 
			ParticleManager:SetParticleControl(self.particleID, 0, self:GetParent():GetAbsOrigin())
		end

		for _,mod in pairs(self:GetParent():FindAllModifiersByName("modifier_monkey_king_wukongs_command_custom_rapier")) do 
			mod:Destroy()
		end

		self:GetParent():SetDayTimeVisionRange(0)
		self:GetParent():SetNightTimeVisionRange(0)
		self:GetParent():AddNoDraw()
		self:GetParent():Stop()
		self:GetParent():RemoveModifierByName("modifier_rooted")
		self:GetParent():RemoveModifierByName("modifier_monkey_king_jingu_mastery_custom_buff")
		self:GetParent():RemoveModifierByName("modifier_monkey_king_jingu_mastery_custom_hit")
		self:GetParent():SetOrigin(Vector(-7500.25, 7594.84, 15))
	end
end

function modifier_monkey_king_wukongs_command_custom_soldier_active:OnIntervalThink()
	if IsServer() then
		local soldier = self:GetParent()
		local hCaster = self:GetCaster()

		if not IsValid(hCaster) then
			self:Destroy()
			return
		end

		if self.phase == "moving" and (self:GetParent():GetAbsOrigin() - self.target_position):Length2D() <= 10 then
			self.phase = "stand"
			soldier:AddNewModifier(hCaster, nil, "modifier_rooted", nil)
			FindClearSpaceForUnit(soldier, self.target_position, false)
		end

		if self.phase == "stand" then
			local targets = FindUnitsInRadius(hCaster:GetTeamNumber(), soldier:GetAbsOrigin(), nil, self.attack_range+soldier:GetHullRadius(), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES+DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE+DOTA_UNIT_TARGET_FLAG_NO_INVIS+DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, FIND_CLOSEST, false)

		--	if self.ultimate ~= 0 and self.ultimate ~= "0" then
				--for i = #targets, 1, -1 do
				--	if not targets[i]:IsPositionInRange(self.position, self.radius+self.outer_attack_buffer) then
				--		table.remove(targets, i)
				--	end
				--end
			--end




			local target = targets[1]
			if target ~= nil and target:GetUnitName() ~= "npc_teleport" then
				self.target = target
				if not self:GetParent():IsDisarmed()  then

					soldier:SetAggroTarget(self.target)

					soldier:MoveToTargetToAttack(self.target)
				else
					if soldier:GetAggroTarget() then
						soldier:Stop()
						soldier:SetAggroTarget(nil)
					end
				end
				if soldier:HasModifier("modifier_monkey_king_wukongs_command_custom_effect") then
					soldier:RemoveModifierByName("modifier_monkey_king_wukongs_command_custom_effect")

					local particleID = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_fur_army_attack.vpcf", PATTACH_ABSORIGIN_FOLLOW, soldier)
					ParticleManager:ReleaseParticleIndex(particleID)
				end
			else
				if soldier:GetAggroTarget() then
					soldier:Stop()
					soldier:SetAggroTarget(nil)
				end
				if not soldier:HasModifier("modifier_monkey_king_wukongs_command_custom_effect") then
					soldier:AddNewModifier(hCaster, self:GetAbility(), "modifier_monkey_king_wukongs_command_custom_effect", nil)
				end
			end
		end

		self:StartIntervalThink(self.attack_speed)
	end
end

function modifier_monkey_king_wukongs_command_custom_soldier_active:CheckState()
	return {
	}
end

function modifier_monkey_king_wukongs_command_custom_soldier_active:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
		MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACK_START
	}
end


function modifier_monkey_king_wukongs_command_custom_soldier_active:GetModifierDamageOutgoing_Percentage()
return self.damage_reduction
end


function modifier_monkey_king_wukongs_command_custom_soldier_active:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end

if self:GetCaster():HasModifier("modifier_monkey_king_command_3") then 
	local heal = self:GetAbility().attack_heal[self:GetCaster():GetUpgradeStack("modifier_monkey_king_command_3")] 
	local target = self:GetCaster()
	target:Heal(heal, target)

	local particle = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:ReleaseParticleIndex( particle )

	if not self:GetCaster():HasModifier("modifier_monkey_king_mischief_custom") then  
		SendOverheadEventMessage(target, 10, target, heal, nil)
	end
end


if not self:GetCaster():HasModifier("modifier_monkey_king_command_6") then return end
if params.target:IsMagicImmune() then return end 


params.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_monkey_king_wukongs_command_custom_slow", {duration = self:GetAbility().slow_duration})
end



function modifier_monkey_king_wukongs_command_custom_soldier_active:GetModifierAttackSpeedBonus_Constant()
if not IsServer() then return end
return -1*self:GetCaster():GetDisplayAttackSpeed() + 300
end

function modifier_monkey_king_wukongs_command_custom_soldier_active:GetModifierMoveSpeed_Absolute(params)
	return self.move_speed
end

function modifier_monkey_king_wukongs_command_custom_soldier_active:GetActivityTranslationModifiers(params)
	return "run_fast"
end



function modifier_monkey_king_wukongs_command_custom_soldier_active:OnAttack(params)
	if params.attacker == self:GetParent() then
		
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_disarmed", {duration = self.attack_speed - FrameTime()})
		self:GetParent():Stop()
		self:GetParent():SetAggroTarget(nil)

		self:StartIntervalThink(self.attack_speed)
	end
end











modifier_monkey_king_wukongs_command_custom_thinker = class({})

function modifier_monkey_king_wukongs_command_custom_thinker:IsHidden()
	return true
end

function modifier_monkey_king_wukongs_command_custom_thinker:IsPurgable()
	return false
end

function modifier_monkey_king_wukongs_command_custom_thinker:IsPurgeException()
	return false
end

function modifier_monkey_king_wukongs_command_custom_thinker:OnCreated(params)
	self.leadership_radius_buffer = self:GetAbility():GetSpecialValueFor("leadership_radius_buffer")
	if IsServer() then
		self.radius = params.radius
		self:GetCaster():EmitSound("Hero_MonkeyKing.FurArmy")
        local particle_name = "particles/units/heroes/hero_monkey_king/monkey_king_furarmy_ring.vpcf"
        if self:GetCaster():HasModifier("modifier_monkey_king_demon_tricker_custom") then
            particle_name = "particles/econ/items/monkey_king/mk_ti9_immortal/mk_ti9_immortal_army_ring.vpcf"
        end
		local particleID = ParticleManager:CreateParticle(particle_name, PATTACH_WORLDORIGIN, nil)
		ParticleManager:SetParticleControl(particleID, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:SetParticleControl(particleID, 1, Vector(self.radius,self.radius,self.radius))
		self:AddParticle(particleID, false, false, -1, false, false)

		self:StartIntervalThink(1)
	end
end

function modifier_monkey_king_wukongs_command_custom_thinker:OnDestroy()
	if IsServer() then
		local hCaster = self:GetCaster()
		if not IsValid(hCaster) then
			return
		end
		hCaster:StopSound("Hero_MonkeyKing.FurArmy")
		EmitSoundOnLocationWithCaster(self:GetParent():GetAbsOrigin(), "Hero_MonkeyKing.FurArmy.End", self:GetCaster())
		self:GetParent():RemoveSelf()
	end
end

function modifier_monkey_king_wukongs_command_custom_thinker:OnIntervalThink()
	if IsServer() then
		local hCaster = self:GetCaster()
		
		if not IsValid(hCaster) then
			self:Destroy()
			return
		end

		if not hCaster:IsPositionInRange(self:GetParent():GetAbsOrigin(), self.radius+self.leadership_radius_buffer) or not hCaster:HasModifier("modifier_monkey_king_wukongs_command_custom_buff") then
			hCaster:RemoveModifierByName("modifier_monkey_king_wukongs_command_custom_buff")
			for n, soldier in pairs(self:GetAbility().soldiers) do

				local mod = soldier:FindModifierByName("modifier_monkey_king_wukongs_command_custom_soldier_active")
				if mod and mod.ultimate == 1 then 
					soldier:RemoveModifierByName("modifier_monkey_king_wukongs_command_custom_soldier_active")
				end

			end
			self:Destroy()
		end
		self:StartIntervalThink(0)
	end
end

function modifier_monkey_king_wukongs_command_custom_thinker:CheckState()
	return {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
	}
end


-- Модификатор солдата
modifier_monkey_king_wukongs_command_custom_soldier = class({})

function modifier_monkey_king_wukongs_command_custom_soldier:IsHidden()
	return true
end

function modifier_monkey_king_wukongs_command_custom_soldier:IsPurgable()
	return false
end

function modifier_monkey_king_wukongs_command_custom_soldier:IsPurgeException()
	return false
end

function modifier_monkey_king_wukongs_command_custom_soldier:OnCreated(params)
if IsServer() then

	self:GetParent():SetDayTimeVisionRange(0)
	self:GetParent():SetNightTimeVisionRange(0)
	self:GetParent():AddNoDraw()

	self:GetParent():SetOrigin(Vector(-7500.25, 7594.84, 15))
end

end

function modifier_monkey_king_wukongs_command_custom_soldier:CheckState()

if self:GetCaster():HasModifier("modifier_monkey_king_mischief_custom")
and not self:GetCaster():HasModifier("modifier_monkey_king_mischief_invun") then 
	return
	{
		    [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		    [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
		    [MODIFIER_STATE_NO_HEALTH_BAR] = true,
		    [MODIFIER_STATE_NOT_ON_MINIMAP] = true,
		    [MODIFIER_STATE_MAGIC_IMMUNE] = true,
   	}
else 

	return {
			[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
			[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
			[MODIFIER_STATE_INVULNERABLE] = true,
			[MODIFIER_STATE_OUT_OF_GAME] = true,
			[MODIFIER_STATE_NO_HEALTH_BAR] = true,
			[MODIFIER_STATE_UNSELECTABLE] = true,
			[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
			[MODIFIER_STATE_UNTARGETABLE] = true,
			[MODIFIER_STATE_MAGIC_IMMUNE] = true,
		}
end

end

function modifier_monkey_king_wukongs_command_custom_soldier:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
		MODIFIER_PROPERTY_DISABLE_AUTOATTACK,
		MODIFIER_PROPERTY_TEMPEST_DOUBLE,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_PROPERTY_TEMPEST_DOUBLE
	}
end

function modifier_monkey_king_wukongs_command_custom_soldier:GetModifierTempestDouble() return 1 end

function modifier_monkey_king_wukongs_command_custom_soldier:GetModifierAttackRangeBonus()
if not self:GetCaster():HasModifier("modifier_monkey_king_command_6") then return end
return self:GetAbility().slow_range
end


function modifier_monkey_king_wukongs_command_custom_soldier:GetAbsoluteNoDamagePhysical()
return 1
end

function modifier_monkey_king_wukongs_command_custom_soldier:GetAbsoluteNoDamagePure()
return 1
end

function modifier_monkey_king_wukongs_command_custom_soldier:GetAbsoluteNoDamageMagical()
return 1
end
function modifier_monkey_king_wukongs_command_custom_soldier:GetActivityTranslationModifiers(params)
if self:GetParent():HasModifier("modifier_monkey_king_mischief_anim") then return end
	return "fur_army_soldier"
end

function modifier_monkey_king_wukongs_command_custom_soldier:GetDisableAutoAttack(params)
	return 1
end

function modifier_monkey_king_wukongs_command_custom_soldier:GetModifierTempestDouble(params)
	return 1
end


function modifier_monkey_king_wukongs_command_custom_soldier:OnDestroy()
if not IsServer() then return end

end

-- Модификатор брони в thinkere
modifier_monkey_king_wukongs_command_custom_buff = class({})

function modifier_monkey_king_wukongs_command_custom_buff:IsHidden()
	return false
end

function modifier_monkey_king_wukongs_command_custom_buff:IsPurgable()
	return false
end

function modifier_monkey_king_wukongs_command_custom_buff:IsPurgeException()
	return false
end

function modifier_monkey_king_wukongs_command_custom_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_MIN_HEALTH
	}
end


function modifier_monkey_king_wukongs_command_custom_buff:OnCreated(table)
self.death_heal = false
end

function modifier_monkey_king_wukongs_command_custom_buff:GetMinHealth()
if not IsServer() then return end
if not self:GetParent():IsAlive() then return end
if self:GetParent():HasModifier("modifier_death") then return end
if not self:GetCaster():HasModifier("modifier_monkey_king_command_5") then return end
if self.death_heal == true then return end

return 1
end

function modifier_monkey_king_wukongs_command_custom_buff:OnTakeDamage( params )
if not IsServer() then return end

if self:GetCaster():HasModifier("modifier_monkey_king_command_5") and 
	self:GetParent() == params.unit and 
	self:GetParent():GetHealth() <= 1 and

	not self:GetParent():HasModifier("modifier_death") and 
	self.death_heal == false 
	then 
	self.death_heal = true

	local heal = self:GetParent():GetMaxHealth()*self:GetAbility().death_heal

	self:GetParent():Heal(heal, self)
	self:GetParent():Purge(false, true, false, true, false)

	SendOverheadEventMessage(self:GetParent(), 10, self:GetParent(), heal, nil)

	local particle = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( particle )

	self:GetParent():EmitSound("MK.Arena_heal")

	local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_oracle/oracle_false_promise_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	
	ParticleManager:SetParticleControl( particle, 0, self:GetParent():GetAbsOrigin() )
	ParticleManager:SetParticleControl( particle, 1, self:GetParent():GetAbsOrigin() )
	ParticleManager:ReleaseParticleIndex( particle )



end

end


function modifier_monkey_king_wukongs_command_custom_buff:GetModifierPhysicalArmorBonus(params)
	return self:GetAbility():GetSpecialValueFor("bonus_armor")
end


-- Модификатор активности мк
modifier_monkey_king_wukongs_command_custom_effect = class({})

function modifier_monkey_king_wukongs_command_custom_effect:IsHidden()
	return true
end

function modifier_monkey_king_wukongs_command_custom_effect:IsPurgable()
	return false
end

function modifier_monkey_king_wukongs_command_custom_effect:IsPurgeException()
	return false
end

function modifier_monkey_king_wukongs_command_custom_effect:GetStatusEffectName()
    if self:GetCaster():HasModifier("modifier_monkey_king_demon_tricker_custom") then
        return "particles/econ/items/monkey_king/mk_ti9_immortal/status_effect_mk_ti9_immortal_army.vpcf"
    end
	return "particles/status_fx/status_effect_monkey_king_fur_army.vpcf"
end

function modifier_monkey_king_wukongs_command_custom_effect:StatusEffectPriority()
	return 10
end





-- Функции

function string.split(str, delimiter)
	if str == nil or str == '' or delimiter == nil then
		return nil
	end

	local result = {}
	for match in (str..delimiter):gmatch("(.-)"..delimiter) do
		table.insert(result, match)
	end
	return result
end

function string.gsplit(str)
	local str_tb = {}
	if string.len(str) ~= 0 then
		for i=1,string.len(str) do
			new_str= string.sub(str,i,i)			
			if (string.byte(new_str) >=48 and string.byte(new_str) <=57) or (string.byte(new_str)>=65 and string.byte(new_str)<=90) or (string.byte(new_str)>=97 and string.byte(new_str)<=122) then
				table.insert(str_tb,string.sub(str,i,i))				
			else
				return nil
			end
		end
		return str_tb
	else
		return nil
	end
end


function IsValid(h)
	return h ~= nil and not h:IsNull()
end

function Rotation2D(vVector, radian)
	local fLength2D = vVector:Length2D()
	local vUnitVector2D = vVector / fLength2D
	local fCos = math.cos(radian)
	local fSin = math.sin(radian)
	return Vector(vUnitVector2D.x*fCos-vUnitVector2D.y*fSin, vUnitVector2D.x*fSin+vUnitVector2D.y*fCos, vUnitVector2D.z)*fLength2D
end

function StringToVector(str)
	if str == nil then return end
	local table = string.split(str, " ")
	return Vector(tonumber(table[1]), tonumber(table[2]), tonumber(table[3])) or nil
end








modifier_monkey_king_wukongs_command_custom_slow = class({})
function modifier_monkey_king_wukongs_command_custom_slow:IsHidden() return false end
function modifier_monkey_king_wukongs_command_custom_slow:IsPurgable() return true end
function modifier_monkey_king_wukongs_command_custom_slow:GetTexture() return "buffs/trample_silence" end
function modifier_monkey_king_wukongs_command_custom_slow:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
end
function modifier_monkey_king_wukongs_command_custom_slow:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self:GetAbility().slow_max then return end
self:IncrementStackCount()

if self:GetStackCount() == self:GetAbility().slow_max then 

	local particleID = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_spring_slow.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControl(particleID, 0, self:GetParent():GetAbsOrigin())
	self:AddParticle(particleID, false, false, -1, false, false)

	self.effect = ParticleManager:CreateParticle("particles/units/heroes/hero_sniper/sniper_headshot_slow.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
	self:AddParticle(self.effect,true,false,0,false,false)
end

end

function modifier_monkey_king_wukongs_command_custom_slow:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE
}
end

function modifier_monkey_king_wukongs_command_custom_slow:GetModifierTurnRate_Percentage()
return self:GetAbility().slow_turn*self:GetStackCount()
end


function modifier_monkey_king_wukongs_command_custom_slow:GetModifierMoveSpeedBonus_Percentage()
return self:GetAbility().slow_move*self:GetStackCount()
end


function modifier_monkey_king_wukongs_command_custom_slow:GetStatusEffectName()
  return "particles/status_fx/status_effect_monkey_king_spring_slow.vpcf"
end


function modifier_monkey_king_wukongs_command_custom_slow:StatusEffectPriority()
  return MODIFIER_PRIORITY_NORMAL
end







modifier_monkey_king_wukongs_command_custom_run = class({})
function modifier_monkey_king_wukongs_command_custom_run:IsHidden() return false end
function modifier_monkey_king_wukongs_command_custom_run:IsPurgable() return false end
function modifier_monkey_king_wukongs_command_custom_run:OnCreated(table)
if not IsServer() then return end

end


modifier_monkey_king_wukongs_command_custom_rapier = class({})
function modifier_monkey_king_wukongs_command_custom_rapier:IsHidden() return true end
function modifier_monkey_king_wukongs_command_custom_rapier:IsPurgable() return false end
function modifier_monkey_king_wukongs_command_custom_rapier:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_monkey_king_wukongs_command_custom_rapier:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
}
end
function modifier_monkey_king_wukongs_command_custom_rapier:GetModifierPreAttack_BonusDamage()
return 350
end