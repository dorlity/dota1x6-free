LinkLuaModifier("modifier_item_travel_boots_custom", "abilities/items/item_travel_boots", LUA_MODIFIER_MOTION_NONE)
item_travel_boots_custom = class({})

function item_travel_boots_custom:GetIntrinsicModifierName()
	return "modifier_item_travel_boots_custom"
end

modifier_item_travel_boots_custom = class({})




function modifier_item_travel_boots_custom:IsHidden() return true end
function modifier_item_travel_boots_custom:IsPurgable() return false end

function modifier_item_travel_boots_custom:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_UNIQUE,
    }
end

function modifier_item_travel_boots_custom:GetModifierMoveSpeedBonus_Special_Boots() 
	if self:GetAbility() then return self:GetAbility():GetSpecialValueFor("bonus_movement_speed") end 
end

---------------------------------------------------------------------------------------------------------------------------------------------

LinkLuaModifier("modifier_item_travel_boots_2_custom", "abilities/items/item_travel_boots", LUA_MODIFIER_MOTION_NONE)

item_travel_boots_2_custom = class({})

function item_travel_boots_2_custom:GetIntrinsicModifierName()
	return "modifier_item_travel_boots_2_custom"
end


function item_travel_boots_2_custom:OnAbilityPhaseStart()


return self:GetCaster():CanTeleport() 
end



function item_travel_boots_2_custom:GetChannelTime()
 return self:GetSpecialValueFor("tp_cast")
end


function item_travel_boots_2_custom:OnSpellStart()

local hero = self:GetCaster()
local boots = self:GetCaster():FindItemInInventory("item_tpscroll_custom")
if boots then 
    boots:EndCooldown()
    boots:StartCooldown(self:GetCooldownTimeRemaining())
end 


self.point = self:GetCursorPosition()
self.point = GetGroundPosition(self.point, nil)
self.point_start = self:GetCaster():GetAbsOrigin()

hero:StartGesture(ACT_DOTA_TELEPORT)

self.teleportFromEffect = ParticleManager:CreateParticle("particles/econ/events/ti10/teleport/teleport_start_ti10_lvl1_rewardline.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
ParticleManager:SetParticleControl(self.teleportFromEffect, 2, Vector(255, 255, 255))
self.teleport_center = CreateUnitByName("npc_dota_companion", self.point, false, nil, nil, 0)


hero:AddNewModifier(self:GetCaster(), self, "modifier_custom_ability_teleport", {duration = self:GetChannelTime()})

self:GetCaster():EmitSound("Portal.Loop_Appear")
EmitSoundOn("Portal.Loop_Appear", self.teleport_center)

self.teleport_center:AddNewModifier(self.teleport_center, nil, "modifier_phased", {})
self.teleport_center:AddNewModifier(self.teleport_center, nil, "modifier_invulnerable", {})
self.teleport_center:SetAbsOrigin(self.point)

self.teleportToEffect = ParticleManager:CreateParticle("particles/econ/events/ti5/teleport_end_lvl2_ti5.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.teleport_center)
ParticleManager:SetParticleControlEnt(self.teleportToEffect, 1, self.teleport_center, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self.teleport_center:GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(self.teleportToEffect, 3, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self.teleport_center:GetAbsOrigin(), true)
ParticleManager:SetParticleControl(self.teleportToEffect, 4, Vector(0.9, 0, 0))
ParticleManager:SetParticleControlEnt(self.teleportToEffect, 5, self.teleport_center, PATTACH_POINT_FOLLOW, "attach_hitloc", self.teleport_center:GetAbsOrigin(), true)


end

function item_travel_boots_2_custom:OnChannelThink(fInterval)

AddFOWViewer(self:GetCaster():GetTeamNumber(), self.point, 300, fInterval, false)


if not self:GetCaster():TeleportThink() then 
    
    self:GetCaster():Stop()
    self:GetCaster():Interrupt() 
end 


end



function item_travel_boots_2_custom:OnChannelFinish(bInterrupted)
if not IsServer() then return end
self:GetCaster():RemoveModifierByName("modifier_custom_ability_teleport")
    
local hero = self:GetCaster()


StopSoundOn("Portal.Loop_Appear", self.teleport_center)
self:GetCaster():StopSound("Portal.Loop_Appear")



self.teleport_center:Destroy()
self:GetCaster():RemoveGesture(ACT_DOTA_TELEPORT)

if bInterrupted then 

    ParticleManager:DestroyParticle(self.teleportFromEffect, true)
    ParticleManager:ReleaseParticleIndex(self.teleportFromEffect)
    ParticleManager:DestroyParticle(self.teleportToEffect, true)
    ParticleManager:ReleaseParticleIndex(self.teleportToEffect)

    return 
end   

ParticleManager:DestroyParticle(self.teleportFromEffect, false)
ParticleManager:ReleaseParticleIndex(self.teleportFromEffect)
ParticleManager:DestroyParticle(self.teleportToEffect, false)
ParticleManager:ReleaseParticleIndex(self.teleportToEffect)

EmitSoundOnLocationWithCaster(self.point_start, "Portal.Hero_Disappear", self:GetCaster())

self:GetCaster():SetAbsOrigin(self.point)
FindClearSpaceForUnit(self:GetCaster(), self.point, true)
self:GetCaster():Stop()
self:GetCaster():Interrupt()
EmitSoundOn("Portal.Hero_Disappear", self:GetCaster())
self:GetCaster():StartGesture(ACT_DOTA_TELEPORT_END)

end


modifier_item_travel_boots_2_custom = class({})


function modifier_item_travel_boots_2_custom:IsHidden() return true end
function modifier_item_travel_boots_2_custom:IsPurgable() return false end

function modifier_item_travel_boots_2_custom:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_UNIQUE,
    }
end

function modifier_item_travel_boots_2_custom:GetModifierMoveSpeedBonus_Special_Boots() 
	if self:GetAbility() then return self:GetAbility():GetSpecialValueFor("bonus_movement_speed") end 
end
