LinkLuaModifier( "modifier_alchemist_goblins_greed_custom", "abilities/alchemist/alchemist_goblins_greed_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_alchemist_goblins_greed_custom_stack", "abilities/alchemist/alchemist_goblins_greed_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_alchemist_goblins_greed_custom_inventory_attribute", "abilities/alchemist/alchemist_goblins_greed_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_alchemist_goblins_greed_custom_scepter", "abilities/alchemist/alchemist_goblins_greed_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_alchemist_goblins_greed_custom_haste", "abilities/alchemist/alchemist_goblins_greed_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_alchemist_goblins_greed_custom_dd", "abilities/alchemist/alchemist_goblins_greed_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_alchemist_goblins_greed_custom_regen", "abilities/alchemist/alchemist_goblins_greed_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_alchemist_goblins_greed_custom_arcane", "abilities/alchemist/alchemist_goblins_greed_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_alchemist_goblins_greed_custom_orbs", "abilities/alchemist/alchemist_goblins_greed_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_alchemist_goblins_greed_custom_runes", "abilities/alchemist/alchemist_goblins_greed_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_alchemist_goblins_greed_custom_kills", "abilities/alchemist/alchemist_goblins_greed_custom", LUA_MODIFIER_MOTION_NONE )

alchemist_goblins_greed_custom = class({})

alchemist_goblins_greed_custom.current_items = 0

alchemist_goblins_greed_custom.gold_inc = {2, 4, 6}

alchemist_goblins_greed_custom.bonus_damage_fromgold = 5

alchemist_goblins_greed_custom.gold_to_attribute = 200
alchemist_goblins_greed_custom.bonus_attribute = {1, 1.5}
alchemist_goblins_greed_custom.bonus_resist = {10, 15}
alchemist_goblins_greed_custom.bonus_attribute_maxstacks = 25

alchemist_goblins_greed_custom.blue = {2,3,4}

alchemist_goblins_greed_custom.kills_max = 10
alchemist_goblins_greed_custom.kills_attack = {4, 6, 8}
alchemist_goblins_greed_custom.kills_move = {4, 6, 8}
alchemist_goblins_greed_custom.kills_duration = 12


alchemist_goblins_greed_custom.scepter_k = 150
alchemist_goblins_greed_custom.scepter_max_per_creep = 15
alchemist_goblins_greed_custom.scepter_max = 150

alchemist_goblins_greed_custom.rune_duration = 30
alchemist_goblins_greed_custom.rune_haste = 100
alchemist_goblins_greed_custom.rune_arcane = 25
alchemist_goblins_greed_custom.rune_regen = 3
alchemist_goblins_greed_custom.rune_dd = 25

alchemist_goblins_greed_custom.runes_max = 35
alchemist_goblins_greed_custom.runes_damage = 50
alchemist_goblins_greed_custom.runes_speed = 2


function alchemist_goblins_greed_custom:OnInventoryContentsChanged()
    if not IsServer() then return end
    for i=0, 8 do
        local item = self:GetCaster():GetItemInSlot(i)
        if item then
            if ( item:GetName() == "item_alchemist_gold_skadi" or item:GetName() == "item_alchemist_gold_shiva" or item:GetName() == "item_alchemist_gold_daedalus" or item:GetName() == "item_alchemist_gold_cuirass" or item:GetName() == "item_alchemist_gold_octarine" or item:GetName() == "item_alchemist_gold_heart" or item:GetName() == "item_alchemist_gold_bfury" ) and not item.alchemist_check_item then
                if self:GetCaster():IsRealHero() then
                    local alchemist_modifier = self:GetCaster():FindModifierByName("modifier_alchemist_goblins_greed_custom")
                    if alchemist_modifier and self.current_items < 2 then
                    	item.alchemist_check_item = true
                    	alchemist_modifier.item_droppable = true
                    end
                end
            end
        end
    end
end

function alchemist_goblins_greed_custom:GetIntrinsicModifierName()
	return "modifier_alchemist_goblins_greed_custom"
end



modifier_alchemist_goblins_greed_custom = class({})

function modifier_alchemist_goblins_greed_custom:IsPurgable()
	return false
end

function modifier_alchemist_goblins_greed_custom:AllowIllusionDuplicate()
	return false
end

function modifier_alchemist_goblins_greed_custom:OnCreated( kv )
	self.base_gold = self:GetAbility():GetSpecialValueFor( "bonus_gold" )
	self.bonus_gold = self:GetAbility():GetSpecialValueFor( "bonus_bonus_gold" )
	self.max_gold = self:GetAbility():GetSpecialValueFor( "bonus_gold_cap" )
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
	if not IsServer() then return end

	self.legendary_recipes = {
		"item_recipe_alchemist_gold_skadi",
		"item_recipe_alchemist_gold_daedalus",
		"item_recipe_alchemist_gold_cuirass",
		"item_recipe_alchemist_gold_octarine",
		"item_recipe_alchemist_gold_heart",
		"item_recipe_alchemist_gold_bfury",
	}



	if self:GetCaster():IsIllusion() then self:Destroy() return end
	self.actual_stack = 0

	self.legendary_gold_reach = 0
	self.legendary_gold_maximum = 4500
	self.item_droppable = true

	self:CalculateStack()
	self:StartIntervalThink(FrameTime())



end

function modifier_alchemist_goblins_greed_custom:OnRefresh( kv )
	self.base_gold = self:GetAbility():GetSpecialValueFor( "bonus_gold" )
	self.bonus_gold = self:GetAbility():GetSpecialValueFor( "bonus_bonus_gold" )
	self.max_gold = self:GetAbility():GetSpecialValueFor( "bonus_gold_cap" )
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
	if not IsServer() then return end
	self:CalculateStack()
end

function modifier_alchemist_goblins_greed_custom:OnIntervalThink()
	if not IsServer() then return end
	if self:GetParent():HasModifier("modifier_alchemist_greed_4") then

		if not self:GetParent():HasModifier("modifier_alchemist_goblins_greed_custom_inventory_attribute") then
			self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_alchemist_goblins_greed_custom_inventory_attribute", {})
		end

		local modifier = self:GetParent():FindModifierByName("modifier_alchemist_goblins_greed_custom_inventory_attribute")
		if modifier then

			local prev_stack = modifier:GetStackCount()

			local price = 0
			price = self:GetCaster():GetGold()
			local stack = math.floor(price / self:GetAbility().gold_to_attribute)
		
			local new_stack = math.min(stack,self:GetAbility().bonus_attribute_maxstacks)

			modifier:SetStackCount(new_stack)
			
			if new_stack ~= prev_stack then 
				self:GetParent():CalculateStatBonus(true)
			end

		end
	end
	if self:GetParent():HasModifier("modifier_alchemist_greed_legendary") then
		if self.item_droppable then
			self.legendary_gold_reach = self:GetCaster():GetGold()
			if self.legendary_gold_reach < self.legendary_gold_maximum then
				CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), "alchemist_progress_update", {current_gold = self.legendary_gold_reach, max_gold = self.legendary_gold_maximum})
			else
				CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), "alchemist_progress_update", {current_gold = self.legendary_gold_maximum, max_gold = self.legendary_gold_maximum})
			end
		end


		if self.legendary_gold_reach >= self.legendary_gold_maximum and self.item_droppable then
			local recipe_name = 'item_alchemist_recipe'--table.remove(self.legendary_recipes, RandomInt(1, #self.legendary_recipes))

			self.item_droppable = false
			self.legendary_gold_maximum = 6000

			self:GetAbility().current_items = self:GetAbility().current_items + 1


			local hero = self:GetParent()

			local item = CreateItem(recipe_name, hero, hero)

 			item_effect = ParticleManager:CreateParticle( "particles/orange_drop.vpcf", PATTACH_WORLDORIGIN, nil )

			local point = Vector(0,0,0)

 			if self:GetCaster():IsAlive() then

 				point = hero:GetAbsOrigin() + hero:GetForwardVector()*150 

			else

 				if towers[hero:GetTeamNumber()] ~= nil then 
 					point = towers[hero:GetTeamNumber()]:GetAbsOrigin() + towers[hero:GetTeamNumber()]:GetForwardVector()*300
 				end

 			end

    		ParticleManager:SetParticleControl( item_effect, 0, point )
       
    		EmitSoundOnEntityForPlayer("powerup_02", hero,  hero:GetPlayerOwnerID())


			Timers:CreateTimer(0.4,function()
 				CreateItemOnPositionSync(GetGroundPosition(point, unit), item)
			end)

			CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), "alchemist_progress_close", {})
		end

	end
end

function modifier_alchemist_goblins_greed_custom:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_DEATH,
	}

	return funcs
end




function modifier_alchemist_goblins_greed_custom:OnDeath( params )
	if not IsServer() then return end
	if params.attacker~=self:GetParent() then return end
	if self:GetCaster():GetTeamNumber()==params.unit:GetTeamNumber() then return end
	if params.unit:IsBuilding() then return end
	if not self:GetParent():IsAlive() then return end


	local gold = self:GetStackCount()

	if self:GetParent():GetQuest() == "Alch.Quest_7" and self:GetParent():QuestCompleted() == false then 
		self:GetParent():UpdateQuest(gold)
	end

	PlayerResource:ModifyGold( self:GetParent():GetPlayerOwnerID(), gold, false, DOTA_ModifyGold_Unspecified )

	self:AddStack()

	local target = params.unit

	if target:IsCreep() and self:GetParent():HasModifier("modifier_alchemist_greed_3") then 
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_alchemist_goblins_greed_custom_kills", {duration = self:GetAbility().kills_duration})
	end



	if target:GetTeam() == DOTA_TEAM_NEUTRALS and self:GetCaster():HasScepter() and self:GetParent():IsRealHero()  then 
		local inc = math.min(self:GetAbility().scepter_max_per_creep, target:GetMaxHealth()/self:GetAbility().scepter_k)

		local mod = self:GetCaster():FindModifierByName("modifier_alchemist_goblins_greed_custom_scepter")

		if not mod then 
			mod = self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_alchemist_goblins_greed_custom_scepter", {})
		end

		local max = self:GetAbility():GetSpecialValueFor("scepter_max")

		if mod:GetStackCount() + inc < max then 
			mod:SetStackCount(mod:GetStackCount() + inc)
		else 
			mod:SetStackCount(inc - (max - mod:GetStackCount()))

			local mod_o = self:GetParent():FindModifierByName("modifier_alchemist_goblins_greed_custom_orbs")
			if mod_o then 
				mod_o:IncrementStackCount()
			end

			local hero = self:GetParent()

			local item = CreateItem("item_gray_upgrade", hero, hero)

 			item_effect = ParticleManager:CreateParticle( "particles/gray_drop.vpcf", PATTACH_WORLDORIGIN, nil )

			local point = Vector(0,0,0)



 			if self:GetCaster():IsAlive() then

 				point = hero:GetAbsOrigin() + hero:GetForwardVector()*150 

			else

 				if towers[hero:GetTeamNumber()] ~= nil then 
 					point = towers[hero:GetTeamNumber()]:GetAbsOrigin() + towers[hero:GetTeamNumber()]:GetForwardVector()*300
 				end

 			end

    		ParticleManager:SetParticleControl( item_effect, 0, point )
       
    		EmitSoundOnEntityForPlayer("powerup_04", hero,  hero:GetPlayerOwnerID())


			Timers:CreateTimer(0.8,function()
 				CreateItemOnPositionSync(GetGroundPosition(point, unit), item)
			end)
		end

	end




	local effect_cast = ParticleManager:CreateParticleForPlayer( "particles/units/heroes/hero_alchemist/alchemist_lasthit_coins.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent(), self:GetParent():GetPlayerOwner() )
	ParticleManager:SetParticleControl( effect_cast, 1, self:GetParent():GetOrigin() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	local digit = string.len(tostring(math.floor(gold))) + 1
	local effect_cast_2 = ParticleManager:CreateParticleForPlayer( "particles/units/heroes/hero_alchemist/alchemist_lasthit_msg_gold.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent(), self:GetParent():GetPlayerOwner() )
	ParticleManager:SetParticleControl( effect_cast_2, 1, Vector( 0, gold, 0 ) )
	ParticleManager:SetParticleControl( effect_cast_2, 2, Vector( 1, digit, 0 ) )
	ParticleManager:SetParticleControl( effect_cast_2, 3, Vector( 255, 255, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast_2 )


	
end

function modifier_alchemist_goblins_greed_custom:AddStack()
	self.actual_stack = self.actual_stack + 1
	self:CalculateStack()
	local duration = self.duration

	local modifier = self:GetParent():AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_alchemist_goblins_greed_custom_stack", { duration = self.duration } )

	modifier.parent_modifier = self
end

function modifier_alchemist_goblins_greed_custom:RemoveStack()
	self.actual_stack = self.actual_stack - 1
	self:CalculateStack()
end

function modifier_alchemist_goblins_greed_custom:CalculateStack()
	local max_gold_bonus = self.max_gold

	if self:GetParent():HasModifier("modifier_alchemist_greed_1") then
		max_gold_bonus = max_gold_bonus + (self:GetAbility().gold_inc[self:GetCaster():GetUpgradeStack("modifier_alchemist_greed_1")])
	end

	local stack = math.min( self.base_gold + self.actual_stack*self.bonus_gold, max_gold_bonus )
	self:SetStackCount( stack )

end



modifier_alchemist_goblins_greed_custom_stack = class({})

function modifier_alchemist_goblins_greed_custom_stack:IsHidden()
	return true
end

function modifier_alchemist_goblins_greed_custom_stack:IsPurgable()
	return false
end

function modifier_alchemist_goblins_greed_custom_stack:RemoveOnDeath()
	return false
end

function modifier_alchemist_goblins_greed_custom_stack:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_alchemist_goblins_greed_custom_stack:OnDestroy()
	if not IsServer() then return end
	self.parent_modifier:RemoveStack()
end

modifier_alchemist_goblins_greed_custom_inventory_attribute = class({})

function modifier_alchemist_goblins_greed_custom_inventory_attribute:IsPurgable() return false end
function modifier_alchemist_goblins_greed_custom_inventory_attribute:RemoveOnDeath() return false end
function modifier_alchemist_goblins_greed_custom_inventory_attribute:GetTexture() return "buffs/greed_gold" end



function modifier_alchemist_goblins_greed_custom_inventory_attribute:DeclareFunctions() 
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
  		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
	}
end
function modifier_alchemist_goblins_greed_custom_inventory_attribute:GetModifierBonusStats_Strength() return self:GetStackCount() * self:GetAbility().bonus_attribute[self:GetParent():GetUpgradeStack("modifier_alchemist_greed_4")] end
function modifier_alchemist_goblins_greed_custom_inventory_attribute:GetModifierBonusStats_Agility() return self:GetStackCount() * self:GetAbility().bonus_attribute[self:GetParent():GetUpgradeStack("modifier_alchemist_greed_4")] end
function modifier_alchemist_goblins_greed_custom_inventory_attribute:GetModifierBonusStats_Intellect() return self:GetStackCount() * self:GetAbility().bonus_attribute[self:GetParent():GetUpgradeStack("modifier_alchemist_greed_4")]  end

function modifier_alchemist_goblins_greed_custom_inventory_attribute:GetModifierStatusResistanceStacking() 
if self:GetStackCount() < self:GetAbility().bonus_attribute_maxstacks then return end
	return self:GetAbility().bonus_resist[self:GetParent():GetUpgradeStack("modifier_alchemist_greed_4")]
end










modifier_alchemist_goblins_greed_custom_scepter = class({})
function modifier_alchemist_goblins_greed_custom_scepter:IsHidden()
 return false
end
function modifier_alchemist_goblins_greed_custom_scepter:IsPurgable() return false end
function modifier_alchemist_goblins_greed_custom_scepter:RemoveOnDeath() return false end
function modifier_alchemist_goblins_greed_custom_scepter:GetTexture() return "buffs/greed_scepter" end
function modifier_alchemist_goblins_greed_custom_scepter:OnCreated(table)
self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_alchemist_goblins_greed_custom_orbs", {})
end



function modifier_alchemist_goblins_greed_custom_scepter:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOOLTIP,
	MODIFIER_PROPERTY_TOOLTIP2
}
end

function modifier_alchemist_goblins_greed_custom_scepter:OnTooltip()
return self:GetAbility().scepter_max
end


function modifier_alchemist_goblins_greed_custom_scepter:OnTooltip2()
return self:GetParent():GetUpgradeStack("modifier_alchemist_goblins_greed_custom_orbs")
end




modifier_alchemist_goblins_greed_custom_haste = class({})
function modifier_alchemist_goblins_greed_custom_haste:IsHidden() return false end
function modifier_alchemist_goblins_greed_custom_haste:IsPurgable() return true end
function modifier_alchemist_goblins_greed_custom_haste:GetTexture() return "rune_haste" end
function modifier_alchemist_goblins_greed_custom_haste:GetEffectName()
return "particles/generic_gameplay/rune_haste_owner.vpcf"
end

function modifier_alchemist_goblins_greed_custom_haste:OnCreated(table)
if not IsServer() then return end
self:GetParent():EmitSound("Alch.Rune_haste")
self.RemoveForDuel = true
end

function modifier_alchemist_goblins_greed_custom_haste:OnRefresh(table)
if not IsServer() then return end
self:GetParent():EmitSound("Alch.Rune_haste")
end


function modifier_alchemist_goblins_greed_custom_haste:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
}
end

function modifier_alchemist_goblins_greed_custom_haste:GetModifierMoveSpeedBonus_Constant()
return self:GetAbility().rune_haste
end





modifier_alchemist_goblins_greed_custom_dd = class({})
function modifier_alchemist_goblins_greed_custom_dd:IsHidden() return false end
function modifier_alchemist_goblins_greed_custom_dd:IsPurgable() return true end
function modifier_alchemist_goblins_greed_custom_dd:GetTexture() return "rune_doubledamage" end
function modifier_alchemist_goblins_greed_custom_dd:GetEffectName()
return "particles/generic_gameplay/rune_doubledamage_owner.vpcf"
end

function modifier_alchemist_goblins_greed_custom_dd:OnCreated(table)
if not IsServer() then return end
self:GetParent():EmitSound("Alch.Rune_dd")
self.RemoveForDuel = true
end

function modifier_alchemist_goblins_greed_custom_dd:OnRefresh(table)
if not IsServer() then return end
self:GetParent():EmitSound("Alch.Rune_dd")
end


function modifier_alchemist_goblins_greed_custom_dd:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE
}
end

function modifier_alchemist_goblins_greed_custom_dd:GetModifierDamageOutgoing_Percentage()
return self:GetAbility().rune_dd
end





modifier_alchemist_goblins_greed_custom_regen = class({})
function modifier_alchemist_goblins_greed_custom_regen:IsHidden() return false end
function modifier_alchemist_goblins_greed_custom_regen:IsPurgable() return true end
function modifier_alchemist_goblins_greed_custom_regen:GetTexture() return "rune_regen" end
function modifier_alchemist_goblins_greed_custom_regen:GetEffectName()
return "particles/generic_gameplay/rune_regen_owner.vpcf"
end

function modifier_alchemist_goblins_greed_custom_regen:OnCreated(table)
if not IsServer() then return end
self:GetParent():EmitSound("Alch.Rune_regen")
self.RemoveForDuel = true
end

function modifier_alchemist_goblins_greed_custom_regen:OnRefresh(table)
if not IsServer() then return end
self:GetParent():EmitSound("Alch.Rune_regen")
end


function modifier_alchemist_goblins_greed_custom_regen:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE
}
end

function modifier_alchemist_goblins_greed_custom_regen:GetModifierHealthRegenPercentage()
return self:GetAbility().rune_regen
end




modifier_alchemist_goblins_greed_custom_arcane = class({})
function modifier_alchemist_goblins_greed_custom_arcane:IsHidden() return false end
function modifier_alchemist_goblins_greed_custom_arcane:IsPurgable() return true end
function modifier_alchemist_goblins_greed_custom_arcane:GetTexture() return "rune_arcane" end
function modifier_alchemist_goblins_greed_custom_arcane:GetEffectName()
return "particles/generic_gameplay/rune_arcane_owner.vpcf"
end

function modifier_alchemist_goblins_greed_custom_arcane:OnCreated(table)
if not IsServer() then return end
self:GetParent():EmitSound("Alch.Rune_arcane")
self.RemoveForDuel = true
end

function modifier_alchemist_goblins_greed_custom_arcane:OnRefresh(table)
if not IsServer() then return end
self:GetParent():EmitSound("Alch.Rune_arcane")
end


function modifier_alchemist_goblins_greed_custom_arcane:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE
}
end

function modifier_alchemist_goblins_greed_custom_arcane:GetModifierPercentageCooldown()
return self:GetAbility().rune_arcane
end

modifier_alchemist_goblins_greed_custom_orbs = class({})
function modifier_alchemist_goblins_greed_custom_orbs:RemoveOnDeath() return false end
function modifier_alchemist_goblins_greed_custom_orbs:IsHidden() return true end
function modifier_alchemist_goblins_greed_custom_orbs:IsPurgable() return false end



modifier_alchemist_goblins_greed_custom_runes = class({})
function modifier_alchemist_goblins_greed_custom_runes:IsHidden() return not self:GetParent():HasModifier("modifier_alchemist_greed_6") end
function modifier_alchemist_goblins_greed_custom_runes:IsPurgable() return false end
function modifier_alchemist_goblins_greed_custom_runes:RemoveOnDeath() return false end
function modifier_alchemist_goblins_greed_custom_runes:GetTexture() return "buffs/greed_rune" end
function modifier_alchemist_goblins_greed_custom_runes:OnCreated(table)
if not IsServer() then return end

self:SetStackCount(1)


end


function modifier_alchemist_goblins_greed_custom_runes:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self:GetAbility().runes_max then return end

self:IncrementStackCount()

if self:GetStackCount() >= self:GetAbility().runes_max then 


	local particle_peffect = ParticleManager:CreateParticle("particles/lc_odd_proc_.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
    ParticleManager:SetParticleControl(particle_peffect, 0, self:GetParent():GetAbsOrigin())
    ParticleManager:SetParticleControl(particle_peffect, 2, self:GetParent():GetAbsOrigin())
   	ParticleManager:ReleaseParticleIndex(particle_peffect)

self:GetCaster():EmitSound("BS.Thirst_legendary_active")
end

end

function modifier_alchemist_goblins_greed_custom_runes:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOOLTIP,
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
}
end


function modifier_alchemist_goblins_greed_custom_runes:GetModifierAttackSpeedBonus_Constant()
if not self:GetParent():HasModifier("modifier_alchemist_greed_6") then return end
return self:GetAbility().runes_speed*self:GetStackCount()
end


function modifier_alchemist_goblins_greed_custom_runes:GetModifierPreAttack_BonusDamage()
if not self:GetParent():HasModifier("modifier_alchemist_greed_6") then return end
if self:GetStackCount() < self:GetAbility().runes_max then return end
return self:GetAbility().runes_damage
end


function modifier_alchemist_goblins_greed_custom_runes:OnTooltip()
return self:GetStackCount()
end


modifier_alchemist_goblins_greed_custom_kills = class({})
function modifier_alchemist_goblins_greed_custom_kills:IsHidden() return false end
function modifier_alchemist_goblins_greed_custom_kills:IsPurgable() return false end
function modifier_alchemist_goblins_greed_custom_kills:GetTexture() return "buffs/greed_kills" end
function modifier_alchemist_goblins_greed_custom_kills:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
end

function modifier_alchemist_goblins_greed_custom_kills:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self:GetAbility().kills_max then return end
self:IncrementStackCount()
end


function modifier_alchemist_goblins_greed_custom_kills:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
end


function modifier_alchemist_goblins_greed_custom_kills:GetModifierAttackSpeedBonus_Constant()
return self:GetStackCount()*self:GetAbility().kills_attack[self:GetCaster():GetUpgradeStack("modifier_alchemist_greed_3")]
end


function modifier_alchemist_goblins_greed_custom_kills:GetModifierMoveSpeedBonus_Constant()
return self:GetStackCount()*self:GetAbility().kills_move[self:GetCaster():GetUpgradeStack("modifier_alchemist_greed_3")]
end