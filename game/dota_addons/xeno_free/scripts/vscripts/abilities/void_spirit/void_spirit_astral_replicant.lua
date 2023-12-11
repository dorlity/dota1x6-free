LinkLuaModifier("modifier_void_spirit_astral_replicant", "abilities/void_spirit/void_spirit_astral_replicant", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_void_spirit_astral_strikes", "abilities/void_spirit/void_spirit_astral_replicant", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_void_spirit_legendary_illusion", "abilities/void_spirit/void_spirit_astral_replicant", LUA_MODIFIER_MOTION_NONE)

void_spirit_astral_replicant = class({})






function void_spirit_astral_replicant:Precache(context)

PrecacheResource( "particle", "particles/generic_gameplay/void_step_active.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_clinkz/void_buf.vpcf", context )
PrecacheResource( "particle", "particles/void_buf2.vpcf", context )

end



function void_spirit_astral_replicant:GetCooldown(iLevel)
return self:GetCaster():GetTalentValue("modifier_void_step_legendary", "cd")
end



function void_spirit_astral_replicant:OnSpellStart()
if not IsServer() then return end 

local mod = self:GetCaster():FindModifierByName("modifier_void_spirit_astral_replicant")

if mod then 
	mod:Destroy()
	return
end 

self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_void_spirit_astral_replicant", {duration = self:GetCaster():GetTalentValue("modifier_void_step_legendary", "duration")})

self:EndCooldown()
self:StartCooldown(self:GetSpecialValueFor("return"))

end

modifier_void_spirit_astral_replicant = class({})
function modifier_void_spirit_astral_replicant:IsHidden() return false end
function modifier_void_spirit_astral_replicant:IsPurgable() return false end

function modifier_void_spirit_astral_replicant:GetEffectName() return "particles/generic_gameplay/void_step_active.vpcf" end

function modifier_void_spirit_astral_replicant:OnCreated(table)
if not IsServer() then return end
self.targetsx = {}
self.targetsy = {}
self.targetsz = {}


self.ability = self:GetParent():FindAbilityByName("void_spirit_astral_step_custom")

self:GetParent():EmitSound("VoidSpirit.Step.Active")

local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_clinkz/void_buf.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )


local effect_cast2 = ParticleManager:CreateParticle( "particles/void_buf2.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
ParticleManager:SetParticleControl( effect_cast2, 0, self:GetCaster():GetOrigin() )

self.RemoveForDuel = true

self:AddParticle(effect_cast, false,  false,  -1,  false,  false  )
self:AddParticle(effect_cast2, false,  false,  -1,  false,  false  )

self.illusions = {}
end


function modifier_void_spirit_astral_replicant:SetPoint(point)

self:IncrementStackCount()
local caster = self:GetCaster()

local illusion_self = CreateIllusions(self:GetCaster(), self:GetCaster(), {
outgoing_damage = 0,
duration		= self:GetRemainingTime() + 0.2	
}, 1, 0, false, false)

for _,illusion in pairs(illusion_self) do
	illusion.owner = caster

	illusion:SetAbsOrigin(point)

	self.targetsx[self:GetStackCount()] = point.x
	self.targetsy[self:GetStackCount()] = point.y
	self.targetsz[self:GetStackCount()] = point.z
	illusion:AddNewModifier(illusion, self:GetAbility(), "modifier_void_spirit_legendary_illusion", {})

	self.illusions[#self.illusions + 1] = illusion
end


end



function modifier_void_spirit_astral_replicant:OnDestroy()
if not IsServer() then return end

self:GetAbility():UseResources(false, false, false, true)
self:GetCaster():CdAbility(self:GetAbility(), self:GetElapsedTime())

if not self:GetParent():IsAlive() then return end
if self:GetStackCount() == 0 then return end
if self:GetParent():HasModifier("modifier_final_duel_start") then return end
if self:GetParent():IsOutOfGame() then return end


for _,unit in pairs(self.illusions) do 
	unit:Kill(nil, nil)
end 

local ability = self:GetParent():FindAbilityByName("void_spirit_astral_step_custom")

if not ability then return end

self:GetParent():EmitSound("VoidSpirit.Step.Active_End")
local mod = self:GetParent():AddNewModifier(self:GetParent(), ability, "modifier_void_spirit_astral_strikes", {max = self:GetStackCount(), })

if mod then 
	mod:SetStackCount(self:GetStackCount())
	mod.x = self.targetsx
	mod.y = self.targetsy
	mod.z = self.targetsz
end


end

function modifier_void_spirit_astral_replicant:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOOLTIP,
    MODIFIER_EVENT_ON_ABILITY_EXECUTED,
}
end

function modifier_void_spirit_astral_replicant:OnTooltip()
return self:GetStackCount()
end



function modifier_void_spirit_astral_replicant:OnAbilityExecuted( params )
if not IsServer() then return end
if params.unit~=self:GetParent() then return end
if not params.ability then return end
if params.ability:IsItem() or params.ability:IsToggle() then return end
if UnvalidAbilities[params.ability:GetName()] then return end
if self:GetAbility() == params.ability then return end
if not self.ability then return end 
if params.ability:GetName() == "void_spirit_astral_step_custom" or 
	params.ability:GetName() == "void_spirit_astral_step_custom_1" or 
	params.ability:GetName() == "void_spirit_astral_step_custom_2" or 
	params.ability:GetName() == "void_spirit_astral_step_custom_3"  then return end

self.ability:GiveCharge()
end 



--------------------------------------------------------------------------------



modifier_void_spirit_astral_strikes = class({})
function modifier_void_spirit_astral_strikes:IsHidden() return true end
function modifier_void_spirit_astral_strikes:IsPurgable() return false end

function modifier_void_spirit_astral_strikes:OnCreated(table)
if not IsServer() then return end
self.x = {}
self.y = {}
self.z = {}
self.n = table.max 

self.damage = math.abs(100 - self:GetCaster():GetTalentValue("modifier_void_step_legendary", "damage"))

self:StartIntervalThink(0.1)

end

function modifier_void_spirit_astral_strikes:OnIntervalThink()
if not IsServer() then return end
local point = Vector(self.x[self.n],self.y[self.n],self.z[self.n])

self.n = self.n - 1

local ability = self:GetParent():FindAbilityByName("void_spirit_astral_step_custom")

if ability then
	ability:Strike(point, self.damage)
end

if self.n < 1 then 
	self:Destroy()
end

end

function modifier_void_spirit_astral_strikes:CheckState()
return
{
	[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
}

end




modifier_void_spirit_legendary_illusion = class({})
function modifier_void_spirit_legendary_illusion:IsHidden() return true end
function modifier_void_spirit_legendary_illusion:IsPurgable() return false end
function modifier_void_spirit_legendary_illusion:GetStatusEffectName() return "particles/void_step_texture.vpcf" end

function modifier_void_spirit_legendary_illusion:OnCreated(table)
if not IsServer() then return end
self:GetParent():StartGesture(ACT_DOTA_CAPTURE)
end

function modifier_void_spirit_legendary_illusion:StatusEffectPriority()
    return 10010
end

function modifier_void_spirit_legendary_illusion:CheckState()
return
{
	[MODIFIER_STATE_INVULNERABLE] = true,
	[MODIFIER_STATE_UNTARGETABLE] = true,
	[MODIFIER_STATE_UNSELECTABLE] = true,
	[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
	[MODIFIER_STATE_NO_HEALTH_BAR] = true,
	[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
	[MODIFIER_STATE_OUT_OF_GAME]	= true,
	[MODIFIER_STATE_STUNNED]	= true,
}

end