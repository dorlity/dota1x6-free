LinkLuaModifier("modifier_patrol_repsawn", "abilities/items/item_patrol_respawn", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_patrol_repsawn_cd", "abilities/items/item_patrol_respawn", LUA_MODIFIER_MOTION_NONE)

item_patrol_respawn               = class({})




function item_patrol_respawn:OnAbilityPhaseStart()

if self:GetCaster():HasModifier("modifier_patrol_repsawn") then 
 	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetCaster():GetPlayerOwnerID()), "CreateIngameErrorMessage", {message = "#respawn_active"})
 
	return false
end


if self:GetCaster():HasModifier("modifier_patrol_repsawn_cd") then 
 	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetCaster():GetPlayerOwnerID()), "CreateIngameErrorMessage", {message = "#respawn_cd"})
 
	return false
end


return true
end

function item_patrol_respawn:OnSpellStart()
if not IsServer() then return end

self:GetCaster():EmitSound("Patrol.Respawn")
self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_patrol_repsawn", {})
self:GetParent():AddNewModifier(self:GetParent(), self, "modifier_patrol_repsawn_cd", {})
self:SpendCharge()

end

modifier_patrol_repsawn = class({})

function modifier_patrol_repsawn:IsHidden() return false end
function modifier_patrol_repsawn:GetTexture() return "omniknight_guardian_angel" end
function modifier_patrol_repsawn:IsPurgable() return false end
function modifier_patrol_repsawn:RemoveOnDeath() return false end

function modifier_patrol_repsawn:GetEffectName() return "particles/patrol_respawn.vpcf" end



function modifier_patrol_repsawn:OnCreated(table)
if not IsServer() then return end

if self:GetParent():HasModifier("modifier_monkey_king_wukongs_command_custom_soldier") then 
	self:Destroy()
end

--self.RemoveForDuel = true

self.StackOnIllusion = true 
end




modifier_patrol_repsawn_cd = class({})
function modifier_patrol_repsawn_cd:IsHidden() return self:GetStackCount() == 1
end
function modifier_patrol_repsawn_cd:IsPurgable() return false end
function modifier_patrol_repsawn_cd:IsDebuff() return true end
function modifier_patrol_repsawn_cd:RemoveOnDeath() return false end
function modifier_patrol_repsawn_cd:GetTexture() return "omniknight_guardian_angel" end

function modifier_patrol_repsawn_cd:OnCreated(table)
if not IsServer() then return end 

self.cd = self:GetAbility():GetSpecialValueFor("cd")*60
self:SetStackCount(1)
end



function modifier_patrol_repsawn_cd:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_DEATH
}
end


function modifier_patrol_repsawn_cd:OnDeath(params)
if self:GetParent() ~= params.unit then return end
if self:GetParent():IsReincarnating() then return end
if self:GetStackCount() == 0 then return end
if self:GetParent().died_on_duel == true then return end 

self:SetStackCount(0)
self:SetDuration(self.cd, true)

end