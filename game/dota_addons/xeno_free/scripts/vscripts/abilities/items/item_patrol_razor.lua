LinkLuaModifier("modifier_razor_tower_custom", "abilities/items/item_patrol_razor", LUA_MODIFIER_MOTION_NONE)

item_patrol_razor                = class({})





function item_patrol_razor:OnSpellStart()
if not IsServer() then return end


local towers = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCursorPosition(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)

if #towers == 0 then 
    return false 
end

local tower = towers[1]


AddFOWViewer(self:GetCaster():GetTeamNumber(), tower:GetAbsOrigin(), 1000, 2, false)




self:GetCaster():EmitSound("Patrol_razor")

local all_towers = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), tower:GetAbsOrigin(), nil, 2200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)


for _,t in pairs(all_towers) do
	t:AddNewModifier(self:GetCaster(), self, "modifier_razor_tower_custom", {duration = self:GetSpecialValueFor("duration")})
	
	local item_effect = ParticleManager:CreateParticle( "particles/units/heroes/hero_zuus/zuus_arc_lightning.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	ParticleManager:SetParticleControl( item_effect, 0, self:GetCaster():GetAbsOrigin() )
	ParticleManager:SetParticleControlEnt(item_effect, 1, t, PATTACH_POINT_FOLLOW, "attach_hitloc", t:GetOrigin(), true )
  
	ParticleManager:ReleaseParticleIndex(item_effect)
end


self:SpendCharge()

end

modifier_razor_tower_custom = class({})
function modifier_razor_tower_custom:IsHidden() return false end
function modifier_razor_tower_custom:IsPurgable() return false end
function modifier_razor_tower_custom:GetTexture() return "item_ex_machina" end



function modifier_razor_tower_custom:OnCreated(table)
self.damage = self:GetAbility():GetSpecialValueFor("damage")
end

function modifier_razor_tower_custom:GetEffectName()
return "particles/items2_fx/mjollnir_shield.vpcf"
end
function modifier_razor_tower_custom:CheckState()
return
{
	[MODIFIER_STATE_DISARMED] = true
}
end

function modifier_razor_tower_custom:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
}
end
function modifier_razor_tower_custom:GetModifierIncomingDamage_Percentage()
return self.damage
end

