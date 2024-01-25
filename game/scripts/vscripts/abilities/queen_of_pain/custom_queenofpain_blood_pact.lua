LinkLuaModifier("modifier_queenofpain_blood_pact", "abilities/queen_of_pain/custom_queenofpain_blood_pact", LUA_MODIFIER_MOTION_NONE)


custom_queenofpain_blood_pact = class({})



function custom_queenofpain_blood_pact:Precache(context)

PrecacheResource( "particle", "particles/brist_proc.vpcf", context )
PrecacheResource( "particle", "particles/econ/items/bloodseeker/bloodseeker_eztzhok_weapon/bloodseeker_bloodrage_eztzhok.vpcf", context )
PrecacheResource( "particle", "particles/qop_scepter.vpcf", context )

end


function custom_queenofpain_blood_pact:GetCooldown(iLevel)
return self:GetCaster():GetTalentValue("modifier_queen_Scream_legendary", "cd")
end

function custom_queenofpain_blood_pact:GetHealthCost(level)

return self:GetCaster():GetTalentValue("modifier_queen_Scream_legendary", "cost")*self:GetCaster():GetMaxHealth()/100

end 


function custom_queenofpain_blood_pact:OnSpellStart()
if not IsServer() then return end

self:GetCaster():EmitSound("QoP.Scepter")
self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_queenofpain_blood_pact", {duration = self:GetCaster():GetTalentValue("modifier_queen_Scream_legendary", "duration")})

local particle = ParticleManager:CreateParticle("particles/brist_proc.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
ParticleManager:ReleaseParticleIndex(particle)

local ability = self:GetCaster():FindAbilityByName("custom_queenofpain_scream_of_pain")
if self:GetCaster():HasModifier("modifier_queen_Scream_shield") then 
	ability:ProcHeal()
end



end


modifier_queenofpain_blood_pact = class({})
function modifier_queenofpain_blood_pact:IsHidden() return false end
function modifier_queenofpain_blood_pact:IsPurgable() return false end


function modifier_queenofpain_blood_pact:OnCreated(table)

self.interval = self:GetCaster():GetTalentValue("modifier_queen_Scream_legendary", "interval")
self.cost = self:GetCaster():GetTalentValue("modifier_queen_Scream_legendary", "cost")
self.cd = self:GetCaster():GetTalentValue("modifier_queen_Scream_legendary", "cd_bonus")
self.damage = self:GetCaster():GetTalentValue("modifier_queen_Scream_legendary", "damage")

if not IsServer() then return end
self.caster = self:GetParent()

for abilitySlot = 0,8 do

	local ability = self:GetCaster():GetAbilityByIndex(abilitySlot)

	if ability ~= nil and ability ~= self:GetAbility() and ability:GetName() ~= "custom_queenofpain_blink" then
		local cooldown_mod = self.caster:AddNewModifier(self.caster, self:GetAbility(), "modifier_cooldown_speed", {ability = ability:GetName(), cd_inc = self.cd})
		local name = self:GetName()

		cooldown_mod:SetEndRule(function()
			return self.caster:HasModifier(name)
		end)
	end
end


self.particle = ParticleManager:CreateParticle("particles/econ/items/bloodseeker/bloodseeker_eztzhok_weapon/bloodseeker_bloodrage_eztzhok.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControl( self.particle, 3, self:GetParent():GetAbsOrigin())
self:AddParticle(self.particle, false, false, -1, false, false)


self.pfx_2 = ParticleManager:CreateParticle("particles/qop_scepter.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
ParticleManager:SetParticleControlEnt(self.pfx_2, 3, self:GetParent(), PATTACH_OVERHEAD_FOLLOW, nil , self:GetParent():GetAbsOrigin(), true )
self:AddParticle(self.pfx_2, false, false, -1, false, false)

end






function modifier_queenofpain_blood_pact:DeclareFunctions()
return
{
    MODIFIER_EVENT_ON_ABILITY_EXECUTED,
    MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
}
end



function modifier_queenofpain_blood_pact:OnAbilityExecuted( params )
if not IsServer() then return end
if params.unit~=self:GetParent() then return end
if not params.ability then return end
if params.ability:IsItem() or params.ability:IsToggle() then return end
if UnvalidAbilities[params.ability:GetName()] then return end

self:IncrementStackCount()
end 




function modifier_queenofpain_blood_pact:GetModifierSpellAmplify_Percentage()
return self.damage*self:GetStackCount()
end 
