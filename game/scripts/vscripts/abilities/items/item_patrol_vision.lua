LinkLuaModifier("modifier_patrol_vision", "abilities/items/item_patrol_vision", LUA_MODIFIER_MOTION_NONE)

item_patrol_vision              = class({})


function item_patrol_vision:OnSpellStart()
if not IsServer() then return end


--CustomGameEventManager:Send_ServerToAllClients('patrol_vision',  {hero = self:GetCaster():GetUnitName()})
self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_patrol_vision", {duration = self:GetSpecialValueFor("duration")})


self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_contract_speed", {duration = self:GetSpecialValueFor("duration")})

EmitSoundOnEntityForPlayer("Item.SeerStone", self:GetCaster(), self:GetCaster():GetPlayerOwnerID())
self:SpendCharge()

end

modifier_patrol_vision = class({})
function modifier_patrol_vision:IsHidden() return false end
function modifier_patrol_vision:IsPurgable() return false end
function modifier_patrol_vision:RemoveOnDeath() return false end
function modifier_patrol_vision:GetTexture() return "item_third_eye" end
function modifier_patrol_vision:OnCreated(table)

self.damage = self:GetAbility():GetSpecialValueFor("damage")

if not IsServer() then return end

self:StartIntervalThink(0.2)
end

function modifier_patrol_vision:OnIntervalThink()
if not IsServer() then return end

local heroes = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)


for _,hero in pairs(heroes) do 
	if not hero:HasModifier("modifier_monkey_king_wukongs_command_custom_soldier") then 
    	AddFOWViewer(self:GetCaster():GetTeamNumber(), hero:GetAbsOrigin(), 10, 0.2, false)
    end
end


end


function modifier_patrol_vision:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
}
end 


function modifier_patrol_vision:GetModifierTotalDamageOutgoing_Percentage(params)

if IsClient() then 
	return self.damage
end 

if not IsServer() then return end
if not params.target then return end 
if not params.target:IsHero() then return end 
if not players[self:GetParent():GetTeamNumber()] then return end 

if duel_data[self:GetParent().duel_data] and duel_data[self:GetParent().duel_data].stage == 2 then return end

return self.damage

end 