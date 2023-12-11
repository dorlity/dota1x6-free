LinkLuaModifier( "modifier_tower_vision", "abilities/tower_abilities_backdoor.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_aura_backdoor", "abilities/tower_abilities_backdoor.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_backdoor", "abilities/tower_abilities_backdoor.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_backdoor_buff", "abilities/tower_abilities_backdoor.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_backdoor_buff_aura", "abilities/tower_abilities_backdoor.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_backdoor_knock_aura", "abilities/tower_abilities_backdoor.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_backdoor_knock_aura_damage", "abilities/tower_abilities_backdoor.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_backdoor_attack_stack", "abilities/tower_abilities_backdoor.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_backdoor_attack_items_cd", "abilities/tower_abilities_backdoor.lua", LUA_MODIFIER_MOTION_NONE )


tower_aura_backdoor = class({})

function tower_aura_backdoor:GetIntrinsicModifierName() return "modifier_aura_backdoor" end



modifier_aura_backdoor = class({})


function modifier_aura_backdoor:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_TAKEDAMAGE,
	MODIFIER_EVENT_ON_ATTACK_LANDED

}
end


modifier_aura_backdoor.creep_names =
{
	["npc_dota_invoker_forged_spirit_custom"] = 0.5,
}


function modifier_aura_backdoor:OnCreated(table)
if not IsServer() then return end
self.duration = self:GetAbility():GetSpecialValueFor("damage_duration")
self.damage = 0 ---self:GetAbility():GetSpecialValueFor("damage_stack")
end

function modifier_aura_backdoor:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end

if params.target:IsCreep() and self.creep_names[params.target:GetUnitName()] == nil then return end

--local mod = params.target:FindModifierByName("modifier_backdoor_attack_stack")
local k = 0.03
if GameRules:GetDOTATime(false, false) < push_timer then 
	k = 0.15
end
if params.target:IsIllusion() then 
	k = 1
end

if params.target:IsTalentIllusion() then 
	k = 0
end

if params.target:IsCreep() and self.creep_names[params.target:GetUnitName()] then 
	k = self.creep_names[params.target:GetUnitName()]
end 


local bonus = params.target:GetMaxHealth()*k
ApplyDamage({ victim = params.target, attacker = self:GetParent(), ability = self:GetAbility(), damage = bonus, damage_type = DAMAGE_TYPE_PURE, damage_flags = DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION})

end

function modifier_aura_backdoor:CheckState()
return
{
	[MODIFIER_STATE_CANNOT_MISS] = true
}
end



function modifier_aura_backdoor:OnTakeDamage(params)
if not IsServer() then return end
if params.attacker ~= self:GetParent() then return end

local target = params.unit

if not target then return end

if not target:IsHero() then return end


target:AddNewModifier(self:GetParent(), nil, "modifier_tower_vision", {duration = 5})

target:AddNewModifier(self:GetParent(), nil, "modifier_backdoor_attack_items_cd", {duration = 3})


end


function modifier_aura_backdoor:IsHidden() return true end

function modifier_aura_backdoor:IsPurgable() return false end




function modifier_aura_backdoor:CheckState()
if not IsServer() then return end
if not players then return end

local player = players[self:GetParent():GetTeamNumber()]

if not player then return end 
if player:IsNull() then return end
if not player:HasModifier("modifier_target") then return end 

return
{
	[MODIFIER_STATE_DISARMED] = true	
}

end 





modifier_tower_vision = class({})
function modifier_tower_vision:IsHidden() return false end
function modifier_tower_vision:IsPurgable() return false end

function modifier_tower_vision:GetTexture() return "buffs/odds_fow" end

function modifier_tower_vision:OnCreated(table)
if not IsServer() then return end
self:StartIntervalThink(0.2)
end



function modifier_tower_vision:OnIntervalThink()
if not IsServer() then return end
local player = players[self:GetCaster():GetTeamNumber()]

if not player then 
	self:Destroy()
	return
end


AddFOWViewer(player:GetTeamNumber(), self:GetParent():GetAbsOrigin(), 50, 0.2, true)

end




modifier_backdoor_buff = class({})
function modifier_backdoor_buff:IsHidden() return true end
function modifier_backdoor_buff:IsPurgable() return false end

function modifier_backdoor_buff:IsAura() return true end

function modifier_backdoor_buff:GetAuraDuration() return 1 end

function modifier_backdoor_buff:GetAuraRadius() return 1000 end

function modifier_backdoor_buff:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end

function modifier_backdoor_buff:GetAuraSearchType() return DOTA_UNIT_TARGET_BUILDING + DOTA_UNIT_TARGET_HERO
 end

function modifier_backdoor_buff:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
 end

function modifier_backdoor_buff:GetModifierAura() return "modifier_backdoor_buff_aura" end






modifier_backdoor_buff_aura = class({})
function modifier_backdoor_buff_aura:IsHidden() return true end
function modifier_backdoor_buff_aura:IsPurgable() return false end

function modifier_backdoor_buff_aura:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
}
end


function modifier_backdoor_buff_aura:OnCreated(table)
if not IsServer() then return end
self.particle = ParticleManager:CreateParticle("particles/items_fx/glyph.vpcf" , PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControl(self.particle, 0, self:GetParent():GetAbsOrigin())
ParticleManager:SetParticleControl(self.particle, 1, Vector(150,1,1))
self:AddParticle(self.particle, false, false, -1, false, false)

end





function modifier_backdoor_buff_aura:GetModifierIncomingDamage_Percentage()
return -200
end






modifier_backdoor_knock_aura = class({})
function modifier_backdoor_knock_aura:IsHidden() return true end
function modifier_backdoor_knock_aura:IsPurgable() return false end
function modifier_backdoor_knock_aura:OnCreated(table)
self.radius = 900


if not IsServer() then return end

self:GetParent():EmitSound("Puck.Orb_wall")

self.ending = false

self.target = EntIndexToHScript(table.target)
self:StartIntervalThink(FrameTime())

self.tower = towers[self:GetParent():GetTeamNumber()]

local number = tostring(teleports[self:GetParent():GetTeamNumber()]:GetName())
self.wall_particle = {}

for _,wall_point in pairs(wall_points[number]) do

	local count = #self.wall_particle + 1

	self.wall_particle[count] = ParticleManager:CreateParticle("particles/duel_wall.vpcf", PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(self.wall_particle[count], 0, Vector(wall_point[1], wall_point[2], 224))
	ParticleManager:SetParticleControl(self.wall_particle[count], 1, Vector(wall_point[3], wall_point[4], 224))
end

if players[self:GetParent():GetTeamNumber()] then 
	self.caster = players[self:GetParent():GetTeamNumber()]
end 

end


function modifier_backdoor_knock_aura:OnDestroy()
if not IsServer() then return end

for _,wall in pairs(self.wall_particle) do
	
	ParticleManager:DestroyParticle(wall, false)
	ParticleManager:ReleaseParticleIndex(wall)
end

end





function modifier_backdoor_knock_aura:IsAura() return true end

function modifier_backdoor_knock_aura:GetAuraDuration() return 0 end

function modifier_backdoor_knock_aura:GetAuraRadius() return self.radius end

function modifier_backdoor_knock_aura:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_BOTH end

function modifier_backdoor_knock_aura:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_backdoor_knock_aura:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end

function modifier_backdoor_knock_aura:GetModifierAura() return "modifier_backdoor_knock_aura_damage" end


function modifier_backdoor_knock_aura:GetAuraEntityReject(hEntity)
if not self.target or self.target:IsNull() then return end 
if not self.caster or self.caster:IsNull() then return end 
return hEntity ~= self.target and self.caster ~= hEntity
end 	

function modifier_backdoor_knock_aura:OnIntervalThink()
if not IsServer() then return end


if not self.target or
	self.target:IsNull() or self.target:HasModifier("modifier_target") or
	(not self.target:IsAlive() and not self.target:IsReincarnating()) or
	(self.tower:GetAbsOrigin() - self.target:GetAbsOrigin()):Length2D() > self.radius or not self:GetParent():IsAlive() then 

	if self.ending == false then 
		self.ending = true
		self:SetDuration(3, true)
	end
else 
	self.ending = false
	self:SetDuration(-1, true)
end


local enemies = FindUnitsInRadius(self.tower:GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self.radius*(1.05), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE  + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_CLOSEST, false)

for _,unit in pairs(enemies) do 
	if unit:GetTeamNumber() ~= self.target:GetTeamNumber() 
		and unit:GetTeamNumber() ~= DOTA_TEAM_CUSTOM_5
		and unit:GetAbsOrigin().z >= 300 
		and not unit:IsCourier() 
		and not unit:HasModifier("modifier_unselect") 
		and not unit:HasModifier("modifier_mars_arena_of_blood_custom_legendary")
		and not unit:HasModifier("modifier_custom_terrorblade_reflection_unit")
		and not unit:HasModifier("modifier_monkey_king_wukongs_command_custom_soldier") 
		and not unit:HasModifier("modifier_mars_arena_of_blood_custom_soldier") then 

			local dir = (unit:GetAbsOrigin() - self.tower:GetAbsOrigin()):Normalized()

			local point = self.tower:GetAbsOrigin() + dir*(self.radius*(1.15))

			FindClearSpaceForUnit(unit, point, true)

			unit:EmitSound("Hero_Rattletrap.Power_Cogs_Impact")
			unit:Stop()
			local attack_particle = ParticleManager:CreateParticle("particles/duel_stun.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit)
			ParticleManager:SetParticleControlEnt(attack_particle, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(attack_particle, 0, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
			ParticleManager:SetParticleControl(attack_particle, 60, Vector(31,82,167))
			ParticleManager:SetParticleControl(attack_particle, 61, Vector(1,0,0))

			unit:AddNewModifier(nil, nil, "modifier_stunned", {duration = field_stun})



	end
end


end


modifier_backdoor_knock_aura_damage = class({})
function modifier_backdoor_knock_aura_damage:IsHidden() return true end
function modifier_backdoor_knock_aura_damage:IsPurgable() return false end
function modifier_backdoor_knock_aura_damage:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
	MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
	MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
    MODIFIER_PROPERTY_ABSORB_SPELL
}
end 


function modifier_backdoor_knock_aura_damage:OnCreated()
if not IsServer() then return end 

local mod = self:GetCaster():FindModifierByName("modifier_backdoor_knock_aura")

if mod and mod.radius then
	self.radius = mod.radius
end

self.target = nil

if self:GetParent():GetTeamNumber() == self:GetCaster():GetTeamNumber() then 
	local mod = self:GetCaster():FindModifierByName("modifier_backdoor_knock_aura")

	if mod and mod.target then
		self.target = mod.target
	end

else 
	if players[self:GetCaster():GetTeamNumber()] then 
		self.target = players[self:GetCaster():GetTeamNumber()] 
	end 
end 


end 


function modifier_backdoor_knock_aura_damage:NoDamage(attacker)
if not IsServer() then return end 
if not attacker then return end
if not self.target then return end 
if attacker == self:GetParent() then return end
if attacker:GetTeamNumber() == DOTA_TEAM_CUSTOM_5 then return end 
if attacker == self.target then return end 
if attacker:IsBuilding() then return end 
if attacker:GetTeamNumber() == self:GetCaster():GetTeamNumber() then return end

return 1
end 


function modifier_backdoor_knock_aura_damage:GetAbsorbSpell(params)
if not IsServer() then return end
if self:GetParent():HasModifier("modifier_antimage_counterspell_custom_active") then return 0 end
if self:GetParent():IsInvulnerable() then return end
if not params.ability:GetCaster() then return end


local caster = params.ability:GetCaster():CheckOwner()

if caster:IsNull() then return end
if caster:GetTeamNumber() == self:GetParent():GetTeamNumber() then return 0 end


if self:NoDamage(caster) == 1 then 

	local particle = ParticleManager:CreateParticle("particles/items_fx/immunity_sphere.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControlEnt(particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(particle)

	self:GetParent():EmitSound("DOTA_Item.LinkensSphere.Activate")

	return 1
end

return 0

end



function modifier_backdoor_knock_aura_damage:GetAbsoluteNoDamagePure(params)
if not IsServer() then return end
if not params.attacker then return end


return self:NoDamage(params.attacker:CheckOwner())
end



function modifier_backdoor_knock_aura_damage:GetAbsoluteNoDamagePhysical(params)
if not IsServer() then return end
if not params.attacker then return end

return self:NoDamage(params.attacker:CheckOwner())
end




function modifier_backdoor_knock_aura_damage:GetAbsoluteNoDamageMagical(params)
if not IsServer() then return end
if not params.attacker then return end

return self:NoDamage(params.attacker:CheckOwner())
end












modifier_backdoor_attack_items_cd = class({})
function modifier_backdoor_attack_items_cd:IsHidden() return true end
function modifier_backdoor_attack_items_cd:IsPurgable() return false end
function modifier_backdoor_attack_items_cd:RemoveOnDeath() return false end
function modifier_backdoor_attack_items_cd:OnCreated(table)
if not IsServer() then return end
self.items = {
	["item_blink"] = true,
	["item_swift_blink"] = true,
	["item_arcane_blink"] = true,
	["item_overwhelming_blink"] = true,
	["item_falcon_blade_custom"] = true,
}
self:OnIntervalThink()
self:StartIntervalThink(FrameTime())
end


function modifier_backdoor_attack_items_cd:OnIntervalThink()
if not IsServer() then return end


for i = 0, 6 do
	local current_item = self:GetParent():GetItemInSlot(i)
	

	if current_item then	
		if self.items[current_item:GetName()] then 
			local cd = current_item:GetCooldownTimeRemaining()

			if cd < self:GetRemainingTime() then 
				current_item:StartCooldown(self:GetRemainingTime())
			end
		end
	end
end


end