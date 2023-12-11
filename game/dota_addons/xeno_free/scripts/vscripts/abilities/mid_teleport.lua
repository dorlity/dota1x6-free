mid_teleport = class ({})

LinkLuaModifier("modifier_mid_teleport_cd", "abilities/mid_teleport", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_mid_teleport_cast", "abilities/mid_teleport", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_mid_teleport_speed", "abilities/mid_teleport", LUA_MODIFIER_MOTION_NONE)


function mid_teleport:GetChannelTime() return 3 end

function mid_teleport:OnSpellStart()
	local hero = self:GetCaster()

	--if self.roshan == false then 
	--	self.point = Vector(38.047356, 150.919510, 343)
	--else {

		
	local point_1 = GetGroundPosition( Vector(1422.55, 1652.11, 103.706), self:GetCaster())
	local point_2 = GetGroundPosition( Vector(-1193.24, -1613.35, 103.706), self:GetCaster())

	--if (self:GetCaster():GetAbsOrigin() - point_1):Length2D() > (self:GetCaster():GetAbsOrigin() - point_2):Length2D() then 
		--self.point = point_1
	--else
	--	self.point = point_2
	--end
	--end

	local teleport = teleports[hero:GetTeamNumber()]
	if not teleport then return end


	local tp_ent = Entities:FindAllByName("global_teleport_"..tostring(teleport:GetName()))


	if #tp_ent == 0 then return end

	self.point = tp_ent[1]:GetAbsOrigin()


	AddFOWViewer(self:GetCaster():GetTeamNumber(), self.point, 1400, 3, false)

	local duration_cd = teleport_cd


	hero:AddNewModifier(hero, self, "modifier_mid_teleport_cast", {target = teleports[hero:GetTeamNumber()]:entindex()})	
	--hero:AddNewModifier(hero, self, "modifier_mid_teleport_cd", { duration = duration_cd })

	teleports[self:GetCaster():GetTeamNumber()]:RemoveGesture(ACT_DOTA_IDLE)
	teleports[self:GetCaster():GetTeamNumber()]:StartGesture(ACT_DOTA_CHANNEL_ABILITY_1)
	teleports[hero:GetTeamNumber()]:EmitSound("Portal.Channel")

	self.blight_spot = ParticleManager:CreateParticle("particles/base_static/team_portal_active.vpcf", PATTACH_CUSTOMORIGIN, teleports[hero:GetTeamNumber()])
	ParticleManager:SetParticleControlEnt(self.blight_spot, 0, teleports[hero:GetTeamNumber()], PATTACH_POINT_FOLLOW, "attach_portal", teleports[hero:GetTeamNumber()]:GetAbsOrigin(), true)


	local number = tonumber(teleports[hero:GetTeamNumber()]:GetName())

	if number == 3 or number == 8 or number == 9 then
		ParticleManager:SetParticleControl(self.blight_spot, 12, Vector(1, 0, 0))
	end

 	--self.teleportFromEffect = ParticleManager:CreateParticle("particles/items2_fx/teleport_start.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
   -- ParticleManager:SetParticleControl(self.teleportFromEffect, 2, Vector(255, 255, 255))
    self.teleport_center = CreateUnitByName("npc_dota_companion", self.point, false, nil, nil, 0)

    EmitSoundOn("Portal.Loop_Appear", self.teleport_center)
    self.teleport_center:AddNewModifier(self.teleport_center, nil, "modifier_phased", {})
    self.teleport_center:AddNewModifier(self.teleport_center, nil, "modifier_invulnerable", {})

    self.teleport_center:SetAbsOrigin(self.point)

    self.teleportToEffect = ParticleManager:CreateParticle("particles/items2_fx/teleport_end.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.teleport_center)
    ParticleManager:SetParticleControlEnt(self.teleportToEffect, 1, self.teleport_center, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self.teleport_center:GetAbsOrigin(), true)
    ParticleManager:SetParticleControlEnt(self.teleportToEffect, 3, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self.teleport_center:GetAbsOrigin(), true)
    ParticleManager:SetParticleControl(self.teleportToEffect, 4, Vector(0.9, 0, 0))
    ParticleManager:SetParticleControlEnt(self.teleportToEffect, 5, self.teleport_center, PATTACH_POINT_FOLLOW, "attach_hitloc", self.teleport_center:GetAbsOrigin(), true)

         

end



function mid_teleport:OnChannelFinish(bInterrupted)
if not self.point then return end

self:GetCaster():RemoveModifierByName("modifier_mid_teleport_cast")

--ParticleManager:DestroyParticle(self.teleportFromEffect, false)
--  ParticleManager:ReleaseParticleIndex(self.teleportFromEffect)
ParticleManager:DestroyParticle(self.teleportToEffect, false)
ParticleManager:ReleaseParticleIndex(self.teleportToEffect)
ParticleManager:DestroyParticle(self.blight_spot, false)
ParticleManager:ReleaseParticleIndex(self.blight_spot)

  
local hero = self:GetCaster()
teleports[hero:GetTeamNumber()]:StopSound("Portal.Channel")


StopSoundOn("Portal.Loop_Appear", self.teleport_center)
self.teleport_center:Destroy()

local ability_name = self:GetAbilityName()
for i = 0,23 do
	local ability_search = hero:GetAbilityByIndex(i)
	if ability_search ~= nil then
	if ability_search:GetAbilityName() == ability_name then hero:RemoveAbility(ability_name)	
	end
end

end
local point = Entities:FindByName(nil, "mid_teleport"):GetAbsOrigin()
teleports[hero:GetTeamNumber()]:FadeGesture(ACT_DOTA_CHANNEL_ABILITY_1)
teleports[hero:GetTeamNumber()]:StartGesture(ACT_DOTA_IDLE)

if bInterrupted then 
  return 
end   
hero:EmitSound("Portal.Hero_Disappear")



local particle = ParticleManager:CreateParticle("particles/econ/events/fall_2021/blink_dagger_fall_2021_end.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(particle, 0, hero:GetAbsOrigin())   
ParticleManager:ReleaseParticleIndex(particle)


hero:AddNewModifier(hero, nil, "modifier_mid_teleport_speed", {duration = 10} )

teleports[hero:GetTeamNumber()]:EmitSound("Portal.End")
hero:SetAbsOrigin(self.point)
FindClearSpaceForUnit(hero, self.point, true)
hero:Stop()
hero:Interrupt()
end


modifier_mid_teleport_cd = class({})

function modifier_mid_teleport_cd:IsDebuff() return true end
function modifier_mid_teleport_cd:IsPurgable() return false end
function modifier_mid_teleport_cd:RemoveOnDeath() return false end
function modifier_mid_teleport_cd:GetTexture() return "item_tpscroll" end

function modifier_mid_teleport_cd:OnDestroy()
if not IsServer() then return end

EmitSoundOnEntityForPlayer("Outpost.Captured.Notification", self:GetParent(), self:GetParent():GetPlayerOwnerID())

end


function modifier_mid_teleport_cd:OnCreated(table)
if not IsServer() then return end	
--	if teleports[self:GetParent():GetTeamNumber()].ray then
 --  	  ParticleManager:DestroyParticle(teleports[self:GetParent():GetTeamNumber()].ray, false)
	--end
end


modifier_mid_teleport_cast = class({})

function modifier_mid_teleport_cast:IsHidden() return true end
function modifier_mid_teleport_cast:IsPurgable() return false end
function modifier_mid_teleport_cast:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	MODIFIER_EVENT_ON_TAKEDAMAGE
}
end

function modifier_mid_teleport_cast:GetOverrideAnimation()
return ACT_DOTA_TELEPORT
end


function modifier_mid_teleport_cast:OnTakeDamage(params)
if not IsServer() then return end 
if self:GetParent() ~= params.unit then return end 
if not params.attacker then return end 
if params.attacker == self:GetParent() then return end 
if not params.attacker:IsHero() then return end

self:GetParent():Interrupt()
end


function modifier_mid_teleport_cast:OnCreated(table)
if not IsServer() then return end

self.target = EntIndexToHScript(table.target)

self:GetParent():SetForwardVector((self.target:GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Normalized())
self:GetParent():FaceTowards(self.target:GetAbsOrigin())

local particle = ParticleManager:CreateParticle("particles/base_static/team_portal_pull.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControl(particle, 0, self:GetParent():GetAbsOrigin())   
ParticleManager:SetParticleControl(particle, 1, self.target:GetAbsOrigin())

self:AddParticle(particle, false, false, -1, false, false)

end





modifier_mid_teleport_speed = class({})

function modifier_mid_teleport_speed:IsHidden() return false end
function modifier_mid_teleport_speed:IsPurgable() return false end
function modifier_mid_teleport_speed:GetTexture() return "rune_haste" end
function modifier_mid_teleport_speed:OnCreated(table)

self.move_speed = 15

if not IsServer() then return end

end

function modifier_mid_teleport_speed:GetEffectName()
return "particles/generic_gameplay/rune_haste_owner.vpcf"
end

function modifier_mid_teleport_speed:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
  MODIFIER_EVENT_ON_TAKEDAMAGE
}
end


function modifier_mid_teleport_speed:GetModifierMoveSpeedBonus_Percentage()
return self.move_speed
end


function modifier_mid_teleport_speed:OnTakeDamage(params)
if not IsServer() then return end
if self:GetParent() ~= params.unit then return end
if self:GetParent() == params.atttacker then return end

self:Destroy()
end