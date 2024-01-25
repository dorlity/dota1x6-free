LinkLuaModifier("modifier_muerta_shovel_custom_stats", "abilities/items/item_muerta_shovel_custom", LUA_MODIFIER_MOTION_NONE)

item_muerta_shovel_custom                = class({})


function item_muerta_shovel_custom:GetIntrinsicModifierName()
return "modifier_muerta_shovel_custom_stats"
end


function item_muerta_shovel_custom:OnAbilityPhaseStart()
if not IsServer() then return end

self.area = nil

local thinkers = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCursorPosition(), nil, 550, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL ,DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, 0 , false)

local dig = false

for _,thinker in pairs(thinkers) do
	if thinker:HasModifier("modifier_muerta_gunslinger_custom_dig_area") then 
		dig = true
		self.area = thinker
		break
	end
end

if dig == false then 
	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetCaster():GetPlayerOwnerID()), "CreateIngameErrorMessage", {message = "#no_dig_area"})
end

return dig
end


function item_muerta_shovel_custom:GetChannelTime()
return self:GetSpecialValueFor("time")
end



function item_muerta_shovel_custom:GetAOERadius()
return self:GetSpecialValueFor("radius")
end


function item_muerta_shovel_custom:OnSpellStart()
if not IsServer() then return end

self:GetCaster():EmitSound("SeasonalConsumable.TI9.Shovel.Dig")

local position = self:GetCursorPosition()

self.pfx = ParticleManager:CreateParticle("particles/econ/events/ti9/shovel_dig.vpcf", PATTACH_WORLDORIGIN, caster)
ParticleManager:SetParticleControl(self.pfx, 0, position)

end


item_muerta_shovel_custom.items =
{
	"item_ward_observer",
	"item_smoke_of_deceit",
	"item_mantle",
	"item_faerie_fire",
	"item_blood_grenade",
	"item_enchanted_mango",
	"item_dust",
	"item_patrol_warp_amulet",
	"item_contract",
	"item_patrol_restrained_orb",
	"item_patrol_midas",

}





function item_muerta_shovel_custom:OnChannelFinish(bInterrupted)
if not IsServer() then return end
self:GetCaster():StopSound("SeasonalConsumable.TI9.Shovel.Dig")

if not self.pfx then return end


ParticleManager:DestroyParticle(self.pfx, false)
ParticleManager:ReleaseParticleIndex(self.pfx)


if not self.area then return end
if bInterrupted then return end

local caster = self:GetCaster()

local point = self:GetCursorPosition()

local thinkers = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), point, nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL ,DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, 0 , false)

local found = false

for _,thinker in pairs(thinkers) do

	local mod = thinker:FindModifierByName("modifier_muerta_gunslinger_custom_dig_bounty")

	if thinker:HasModifier("modifier_muerta_gunslinger_custom_dig_bounty") then 
		found = true
		mod:Complete()
		break
	end
end


local particle = "particles/econ/events/ti9/shovel_smoke_cloud.vpcf" 


if found == true then 

	self:SetCurrentCharges(self:GetCurrentCharges() + 1)
	self:GetCaster():CalculateStatBonus(true)


	local effect_cast = ParticleManager:CreateParticle( "particles/heroes/muerta/muerta_quest_kill.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControlEnt(effect_cast, 2, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex( effect_cast )

	local effect_cast = ParticleManager:CreateParticle("particles/econ/events/ti9/muerta_dig_treasure.vpcf" , PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, point )
	ParticleManager:SetParticleControl( effect_cast, 1, point )
	ParticleManager:ReleaseParticleIndex(effect_cast)

	particle = "particles/muerta_dig_drop.vpcf"

	self:GetCaster():EmitSound("Muerta.Quest_hero_kill")

	if self:GetCurrentCharges() >= self:GetSpecialValueFor("goal") then 

		local particle_peffect = ParticleManager:CreateParticle("particles/muerta/muerta_quest_item.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
		ParticleManager:SetParticleControl(particle_peffect, 0, self:GetCaster():GetAbsOrigin())
		ParticleManager:SetParticleControl(particle_peffect, 2, self:GetCaster():GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(particle_peffect)
		self:GetCaster():EmitSound("Muerta.Quest_item")
		self:GetCaster():EmitSound("Muerta.Quest_item2")


		self:Destroy()
	    local mercy = CreateItem("item_muerta_mercy_custom", caster, caster)
	    caster:AddItem(mercy)

		my_game:MuertaQuestPhase()

		CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(caster:GetPlayerOwnerID()), 'muerta_quest_panel',  { max = 0, stack = 0, stage = 2})
			
		CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(caster:GetPlayerOwnerID()), 'muerta_quest_alert',  {type = 3})

	else 

		CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetCaster():GetPlayerOwnerID()), 'muerta_quest_alert',  {type = 2, max = self:GetSpecialValueFor("goal"), stack = self:GetCurrentCharges()})
		CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetCaster():GetPlayerOwnerID()), 'muerta_quest_panel',  { max = self:GetSpecialValueFor("goal"), stack = self:GetCurrentCharges(), stage = 1})
	end
else 

	if RollPseudoRandomPercentage(50,131,self:GetCaster()) then 


		if not self.area then return end
		if self.area:IsNull() then return end

		local area_mod = self.area:FindModifierByName("modifier_muerta_gunslinger_custom_dig_area")
		if not area_mod then return end

		if area_mod:GetStackCount() < 3 then 

			particle = "particles/econ/events/ti9/shovel_revealed_nothing.vpcf"


			area_mod:IncrementStackCount()

			if RollPseudoRandomPercentage(10,129,self:GetCaster()) then 

				CreateRune(point, DOTA_RUNE_BOUNTY)  

				local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_alchemist/alchemist_lasthit_coins.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
				ParticleManager:SetParticleControl( effect_cast, 1, self:GetCaster():GetOrigin() )
				ParticleManager:ReleaseParticleIndex( effect_cast )

				return
			end

			local item = CreateItem(self.items[RandomInt(1, #self.items)], self:GetCaster(), self:GetCaster())

			CreateItemOnPositionSync(GetGroundPosition(point, nil), item)

		end
	end

end

local effect_cast = ParticleManager:CreateParticle(particle , PATTACH_WORLDORIGIN, nil )
ParticleManager:SetParticleControl( effect_cast, 0, point )
ParticleManager:SetParticleControl( effect_cast, 1, point )
ParticleManager:ReleaseParticleIndex(effect_cast)


end



modifier_muerta_shovel_custom_stats = class({})
function modifier_muerta_shovel_custom_stats:IsHidden() return true end
function modifier_muerta_shovel_custom_stats:IsPurgable() return false end
function modifier_muerta_shovel_custom_stats:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
}
end

function modifier_muerta_shovel_custom_stats:OnCreated(table)
self.move = self:GetAbility():GetSpecialValueFor("movespeed")
self.stats = self:GetAbility():GetSpecialValueFor("stats")
self.stats_inc = self:GetAbility():GetSpecialValueFor("stats_inc")
self.goal = self:GetAbility():GetSpecialValueFor("goal")

if not IsServer() then return end


end

function modifier_muerta_shovel_custom_stats:GetModifierMoveSpeedBonus_Constant()
return self.move
end


function modifier_muerta_shovel_custom_stats:GetModifierBonusStats_Strength()
return self.stats + self:GetAbility():GetCurrentCharges()*self.stats_inc
end

function modifier_muerta_shovel_custom_stats:GetModifierBonusStats_Agility()
return self.stats + self:GetAbility():GetCurrentCharges()*self.stats_inc
end

function modifier_muerta_shovel_custom_stats:GetModifierBonusStats_Intellect()
return self.stats + self:GetAbility():GetCurrentCharges()*self.stats_inc
end