LinkLuaModifier( "modifier_tower_backdoor_timer", "abilities/tower_abilities_backdoor.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_tower_vision", "abilities/tower_abilities_backdoor.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_aura_backdoor", "abilities/tower_abilities_backdoor.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_backdoor", "abilities/tower_abilities_backdoor.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_backdoor_buff", "abilities/tower_abilities_backdoor.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_backdoor_buff_aura", "abilities/tower_abilities_backdoor.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_backdoor_knock_aura", "abilities/tower_abilities_backdoor.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_backdoor_attack_stack", "abilities/tower_abilities_backdoor.lua", LUA_MODIFIER_MOTION_NONE )


tower_aura_backdoor = class({})

function tower_aura_backdoor:GetIntrinsicModifierName() return "modifier_aura_backdoor" end



modifier_aura_backdoor = class({})


function modifier_aura_backdoor:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_TAKEDAMAGE,
	MODIFIER_PROPERTY_PROCATTACK_FEEDBACK

}
end

function modifier_aura_backdoor:OnCreated(table)
if not IsServer() then return end
self.duration = self:GetAbility():GetSpecialValueFor("damage_duration")
self.damage = self:GetAbility():GetSpecialValueFor("damage_stack")
end

function modifier_aura_backdoor:GetModifierProcAttack_Feedback(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end
if params.target:IsCreep() then return end

local mod = params.target:FindModifierByName("modifier_backdoor_attack_stack")
local bonus = 0

if mod then 
	bonus = mod:GetStackCount()*self.damage
	ApplyDamage({ victim = params.target, attacker = self:GetParent(), ability = self:GetAbility(), damage = bonus, damage_type = DAMAGE_TYPE_PHYSICAL})
end

params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_backdoor_attack_stack", {duration = self.duration})

end

function modifier_aura_backdoor:CheckState()
return
{
	[MODIFIER_STATE_CANNOT_MISS] = true
}
end

modifier_aura_backdoor.items = 
{
	["item_blink"] = true,
	["item_swift_blink"] = true,
	["item_arcane_blink"] = true,
	["item_overwhelming_blink"] = true,
}


function modifier_aura_backdoor:OnTakeDamage(params)
if not IsServer() then return end
if params.attacker ~= self:GetParent() then return end

local target = params.unit

if not target then return end

if not target:IsHero() then return end


target:AddNewModifier(self:GetParent(), nil, "modifier_tower_vision", {duration = 5})


for i = 0, 8 do
	local current_item = target:GetItemInSlot(i)
	

	if current_item then	
		if self.items[current_item:GetName()] then 
			local cd = current_item:GetCooldownTimeRemaining()

			if cd < 5 then 
				current_item:StartCooldown(3)
			end
		end
	end
end



end


function modifier_aura_backdoor:IsHidden() return true end

function modifier_aura_backdoor:IsPurgable() return false end

function modifier_aura_backdoor:IsAura() return true end

function modifier_aura_backdoor:GetAuraDuration() return 1 end

function modifier_aura_backdoor:GetAuraRadius() return 1000 end

function modifier_aura_backdoor:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end

function modifier_aura_backdoor:GetAuraSearchType() return DOTA_UNIT_TARGET_BUILDING
 end

function modifier_aura_backdoor:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_INVULNERABLE end

function modifier_aura_backdoor:GetModifierAura() return "modifier_backdoor" end

modifier_backdoor = class({})
function modifier_backdoor:IsHidden() return true end
function modifier_backdoor:IsPurgable() return false end

function modifier_backdoor:OnCreated(table)
if not IsServer() then return end

self.state = 0


self:StartIntervalThink(0.2)
end

function modifier_backdoor:OnIntervalThink()
if not IsServer() then return end
if not self:GetCaster() then return end
if not self:GetParent() then return end

local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, 900, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_INVULNERABLE  + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO, FIND_CLOSEST, false)

if #enemies > 0 then 

	if self.state == 0 then 
		self.state = 1
   		self:GetParent():AddNewModifier(self:GetCaster(), nil, "modifier_tower_backdoor_timer", {duration = 3})
   	end 

   	if self.state == 1 and not self:GetParent():HasModifier("modifier_tower_backdoor_timer") then 
   		self.state = 2
   	end

else 
	self.state = 0

	if self:GetParent():HasModifier("modifier_tower_backdoor_timer") then 
		self:GetParent():RemoveModifierByName("modifier_tower_backdoor_timer")
	end
end



if #enemies >= 2 and not self:GetCaster():HasModifier("modifier_backdoor_buff") then 
	--self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_backdoor_buff", {})
end



if #enemies < 2 and self:GetCaster():HasModifier("modifier_backdoor_buff") then 
	--self:GetCaster():RemoveModifierByName("modifier_backdoor_buff")
end


end






function modifier_backdoor:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_TAKEDAMAGE,
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
}
end
function modifier_backdoor:GetModifierIncomingDamage_Percentage(params) 
if not IsServer() then return end
local tower = towers[self:GetParent():GetTeamNumber()]

if not tower then return end

if (tower:GetAbsOrigin() - params.attacker:GetAbsOrigin()):Length2D() > 900  or not params.attacker:IsAlive() then return
	-100
end

if params.attacker:IsInvulnerable() or params.attacker:IsOutOfGame() then 
	return -100
end

local attacker = params.attacker

if self.state ~= 2 and attacker:GetTeamNumber() ~= DOTA_TEAM_CUSTOM_5 then 
	return -100
end

if attacker.owner ~= nil and attacker:GetTeamNumber() ~= DOTA_TEAM_CUSTOM_5 then 

	if (tower:GetAbsOrigin() - attacker.owner:GetAbsOrigin()):Length2D() > 900 or not attacker.owner:IsAlive() then 
		return -100
	end

end


return 0 
end



function modifier_backdoor:OnTakeDamage(params) 
if not IsServer() then return end
if self:GetParent() ~= params.unit then return end


local tower = towers[self:GetParent():GetTeamNumber()]

if not tower then return end
local back = false

if params.attacker:IsInvulnerable() or params.attacker:IsOutOfGame() then 
	back = true
end

if (tower:GetAbsOrigin() - params.attacker:GetAbsOrigin()):Length2D() > 900 or not params.attacker:IsAlive() then 
	back = true 
end



local attacker = params.attacker
if attacker.owner ~= nil and attacker:GetTeamNumber() ~= DOTA_TEAM_CUSTOM_5  then 

	if (tower:GetAbsOrigin() - attacker.owner:GetAbsOrigin()):Length2D() > 900 or not attacker.owner:IsAlive() then 
		back = true
	end

end
	
if self.state ~= 2 and attacker:GetTeamNumber() ~= DOTA_TEAM_CUSTOM_5 then 
	back = true
end

if back == true then
	self:GetParent():EmitSound("Huskar.Disarm_Str")
	self.effect_cast = ParticleManager:CreateParticle("particles/items_fx/backdoor_protection.vpcf", PATTACH_ABSORIGIN, self:GetParent())
	ParticleManager:SetParticleControl( self.effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 200, 0, 0) )
	ParticleManager:ReleaseParticleIndex(self.effect_cast)
else 

	if not towers[self:GetParent():GetTeamNumber()]:HasModifier("modifier_backdoor_knock_aura") and params.attacker and params.attacker:IsRealHero()
	and self:GetParent():GetTeamNumber() ~= params.attacker:GetTeamNumber() then 
		towers[self:GetParent():GetTeamNumber()]:AddNewModifier(towers[self:GetParent():GetTeamNumber()], nil, "modifier_backdoor_knock_aura", {target = params.attacker:entindex()})
	end
end

end











modifier_tower_backdoor_timer = class({})
function modifier_tower_backdoor_timer:IsHidden() return true end
function modifier_tower_backdoor_timer:IsPurgable() return false end

function modifier_tower_backdoor_timer:OnCreated(table)
if not IsServer() then return end
  self.t = -1
  self.timer = 3*2 
  self:StartIntervalThink(0.5)
  self:OnIntervalThink()
end


function modifier_tower_backdoor_timer:OnIntervalThink()
if not IsServer() then return end
self.t = self.t + 1

local caster = self:GetParent()

        local number = (self.timer-self.t)/2 
        local int = 0
        int = number
       if number % 1 ~= 0 then int = number - 0.5  end

        local digits = math.floor(math.log10(number)) + 2

        local decimal = number % 1

        if decimal == 0.5 then
            decimal = 8
        else 
            decimal = 1
        end

local particleName = "particles/huskar_timer.vpcf"

if self:GetCaster():GetUnitName() == "npc_towerdire" then 
	particleName = "particles/lina_timer.vpcf"
end

local particle = ParticleManager:CreateParticle(particleName, PATTACH_OVERHEAD_FOLLOW, caster)
ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin())
ParticleManager:SetParticleControl(particle, 1, Vector(0, int, decimal))
ParticleManager:SetParticleControl(particle, 2, Vector(digits, 0, 0))
ParticleManager:ReleaseParticleIndex(particle)

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



wall_points =
{
	['7'] = 
	{
		[1] = {2025.97, -5998.23, 2025.97, -6868.48},
		[2] = {694.821, -7259, 296.336, -6879.3},
		[3] = {347.44, -5955.41, 739.645, -5579.22}
	},
	['2'] =
	{
		[1] = {-4790.61, -6228.27, -4390.61, -5839.96},
		[2] = {-4386.9, -4969.1, -4791.75, -4553.28},
		[3] = {-5657.16, -4549.78, -6077.51, -4978.99},
		[4] = {-6076.5, -5820.35, -5672.04, -6203.93},
	},
	['6'] = 
	{
		[1] = {-5398.15, 561.633, -5806.26, 153.704},
		[2] = {-6692.4, 162.416, -7124.17, 573.562},
		[3] = {-6684.28, 1826.74, -5807.56, 1826.74}
	},
	['8'] = 
	{
		[1] = {-1705.89, 6873.77, -1705.89, 5906.28},
		[2] = {-452.015, 5550.84, -56.8497, 5947.8},
		[3] = {-56.8497, 6833.42, -407.981, 7232.22}
	},
	['3'] = 
	{
		[1] = {4666.34, 4938.2, 5090.61, 4521.21},
		[2] = {5926.45, 4549.92, 6340.09, 4933.79},
		[3] = {6349.83, 5774.71, 5910.17, 6214.89},
		[4] = {5127.78, 6216.08, 4699.64, 5787.46},
	},
	['9'] = 
	{
		[1] = {5677.74, -609.471, 6157.36, -147.471},
		[2] = {6981.28, -174.853, 7402.69, -611.983},
		[3] = {7022.56, -1848.37, 6054.74, -1848.28},
	},
}




modifier_backdoor_knock_aura = class({})
function modifier_backdoor_knock_aura:IsHidden() return false end
function modifier_backdoor_knock_aura:IsPurgable() return false end
function modifier_backdoor_knock_aura:OnCreated(table)
if not IsServer() then return end


self:GetParent():EmitSound("Puck.Orb_wall")

self.target = EntIndexToHScript(table.target)
self.radius = 900
self:StartIntervalThink(0.05)
self.tower = towers[self:GetParent():GetTeamNumber()]

local number = tostring(teleports[self:GetParent():GetTeamNumber()]:GetName())
self.wall_particle = {}

for _,wall_point in pairs(wall_points[number]) do

	local count = #self.wall_particle + 1

	self.wall_particle[count] = ParticleManager:CreateParticle("particles/duel_wall.vpcf", PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(self.wall_particle[count], 0, Vector(wall_point[1], wall_point[2], 224))
	ParticleManager:SetParticleControl(self.wall_particle[count], 1, Vector(wall_point[3], wall_point[4], 224))
end

end


function modifier_backdoor_knock_aura:OnDestroy()
if not IsServer() then return end

for _,wall in pairs(self.wall_particle) do
	
	ParticleManager:DestroyParticle(wall, false)
	ParticleManager:ReleaseParticleIndex(wall)
end

end

function modifier_backdoor_knock_aura:OnIntervalThink()
if not IsServer() then return end


if not self.target or
	self.target:IsNull() or
	not self.target:IsAlive() or
	(self.tower:GetAbsOrigin() - self.target:GetAbsOrigin()):Length2D() > self.radius then 

	self:Destroy()
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



modifier_backdoor_attack_stack = class({})
function modifier_backdoor_attack_stack:IsHidden() return false end
function modifier_backdoor_attack_stack:IsPurgable() return false end
function modifier_backdoor_attack_stack:OnCreated(table)
self.damage = self:GetAbility():GetSpecialValueFor("damage_stack")
if not IsServer() then return end
self:SetStackCount(1)
end


function modifier_backdoor_attack_stack:OnRefresh(table)

if not IsServer() then return end
self:IncrementStackCount()
end


function modifier_backdoor_attack_stack:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOOLTIP
}
end


function modifier_backdoor_attack_stack:OnTooltip()
return self.damage*self:GetStackCount()
end