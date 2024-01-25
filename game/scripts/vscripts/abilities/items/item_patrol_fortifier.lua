LinkLuaModifier("modifier_item_patrol_fortifier_tower", "abilities/items/item_patrol_fortifier", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_patrol_fortifier", "abilities/items/item_patrol_fortifier", LUA_MODIFIER_MOTION_NONE)

item_patrol_fortifier = class({})



function item_patrol_fortifier:OnSpellStart()
if not IsServer() then return end

local tower = towers[self:GetParent():GetTeamNumber()]
if not tower then return end

if tower:HasModifier("modifier_item_patrol_fortifier_tower") then 
 	--CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetCaster():GetPlayerOwnerID()), "CreateIngameErrorMessage", {message = "#fortifier_ready"})
  
--	return
end

tower:AddNewModifier(self:GetCaster(), self, "modifier_generic_repair", {duration = self:GetSpecialValueFor("heal_duration"), tower_heal = self:GetSpecialValueFor("heal_tower")})
tower:AddNewModifier(self:GetCaster(), self, "modifier_item_patrol_fortifier_tower", {})


self:GetCaster():EmitSound("BB.Quill_cdr")
self:SpendCharge()
end






modifier_item_patrol_fortifier_tower = class({})
function modifier_item_patrol_fortifier_tower:IsHidden() return false end
function modifier_item_patrol_fortifier_tower:IsPurgable() return false end
function modifier_item_patrol_fortifier_tower:GetTexture() return "buffs/patrol_fortifier" end
function modifier_item_patrol_fortifier_tower:OnCreated(table)
if not IsServer() then return end

self.duration = self:GetAbility():GetSpecialValueFor("duration")
self.damage = self:GetAbility():GetSpecialValueFor("damage")
self.speed = self:GetAbility():GetSpecialValueFor("speed")
self.incoming = self:GetAbility():GetSpecialValueFor("incoming")


self.particle = ParticleManager:CreateParticle("particles/glyph_damage.vpcf" , PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControl(self.particle, 0, self:GetParent():GetAbsOrigin())
ParticleManager:SetParticleControl(self.particle, 1, Vector(170,1,1))
self:AddParticle(self.particle, false, false, -1, false, false)

end

function modifier_item_patrol_fortifier_tower:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_ATTACK_LANDED
}
end 


function modifier_item_patrol_fortifier_tower:OnAttackLanded(params)
if not IsServer() then return end 
if self:GetParent() ~= params.target then return end 
if params.attacker:GetTeamNumber() ~= DOTA_TEAM_CUSTOM_5 then return end 

self:Activate()

end 

function modifier_item_patrol_fortifier_tower:Activate()
if not IsServer() then return end

local  fillers = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, 2000, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
for _,filler in pairs(fillers) do
	filler:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_patrol_fortifier", {duration = self.duration, damage = self.damage, speed = self.speed, incoming = self.incoming})
end 

self:Destroy()

end 



modifier_item_patrol_fortifier = class({})
function modifier_item_patrol_fortifier:IsHidden() return false end
function modifier_item_patrol_fortifier:IsPurgable() return false end
function modifier_item_patrol_fortifier:GetTexture() return "buffs/patrol_fortifier" end
function modifier_item_patrol_fortifier:GetEffectName() 
return "particles/tower_dd.vpcf"
end



function modifier_item_patrol_fortifier:OnCreated(table)
if not IsServer() then return end

self.damage = table.damage
self.speed = table.speed
self.incoming = table.incoming

self:SetHasCustomTransmitterData(true)

self:GetParent():EmitSound("BB.Quill_cdr")

self.particle = ParticleManager:CreateParticle("particles/glyph_damage.vpcf" , PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControl(self.particle, 0, self:GetParent():GetAbsOrigin())
ParticleManager:SetParticleControl(self.particle, 1, Vector(170,1,1))
self:AddParticle(self.particle, false, false, -1, false, false)
end





function modifier_item_patrol_fortifier:AddCustomTransmitterData() return 
{
incoming = self.incoming,
speed = self.speed
} 
end

function modifier_item_patrol_fortifier:HandleCustomTransmitterData(data)
self.speed = data.speed
self.incoming = data.incoming
end





function modifier_item_patrol_fortifier:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
end



function modifier_item_patrol_fortifier:GetModifierIncomingDamage_Percentage()
return self.incoming
end


function modifier_item_patrol_fortifier:GetModifierAttackSpeedBonus_Constant()
return self.speed
end

