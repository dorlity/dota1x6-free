LinkLuaModifier( "modifier_hoodwink_innate_custom", "abilities/hoodwink/hoodwink_innate_custom", LUA_MODIFIER_MOTION_NONE )


hoodwink_innate_custom = class({})


function hoodwink_innate_custom:GetIntrinsicModifierName()
if not self:GetCaster():IsRealHero() then return end 
return "modifier_hoodwink_innate_custom"
end


function hoodwink_innate_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end
PrecacheResource( "soundfile", "soundevents/npc_dota_hero_hoodwink.vsndevts", context )
dota1x6:PrecacheShopItems("npc_dota_hero_hoodwink", context)
end


modifier_hoodwink_innate_custom = class({})
function modifier_hoodwink_innate_custom:IsHidden() return self:GetStackCount()~=0 end
function modifier_hoodwink_innate_custom:IsPurgable() return false end
function modifier_hoodwink_innate_custom:RemoveOnDeath() return false end
function modifier_hoodwink_innate_custom:OnCreated(table)
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.evasion = self.ability:GetSpecialValueFor( "evasion" )
self.radius = self.ability:GetSpecialValueFor( "radius" )

self.main_ability = self.parent:FindAbilityByName("hoodwink_scurry_custom")

if not IsServer() then return end
self:StartIntervalThink( 0.1 )
self:OnIntervalThink()
end

function modifier_hoodwink_innate_custom:OnRefresh(table)
self.evasion = self.ability:GetSpecialValueFor( "evasion" )
end

function modifier_hoodwink_innate_custom:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_EVASION_CONSTANT,
	MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
}
end



function modifier_hoodwink_innate_custom:GetModifierIncomingDamage_Percentage()
if self:GetStackCount()==1 then return 0 end
if not self.parent:HasTalent("modifier_hoodwink_scurry_2") then return end
return self.parent:GetTalentValue("modifier_hoodwink_scurry_2", "damage_reduce")
end


function modifier_hoodwink_innate_custom:GetModifierStatusResistanceStacking() 
if self:GetStackCount()==1 then return 0 end
if not self.parent:HasTalent("modifier_hoodwink_scurry_2") then return end
return self.parent:GetTalentValue("modifier_hoodwink_scurry_2", "status")
end



function modifier_hoodwink_innate_custom:GetModifierEvasion_Constant()
if self:GetStackCount()==1 then return 0 end
return self.evasion
end




function modifier_hoodwink_innate_custom:OnIntervalThink()
if not IsServer() then return end

if self.parent:HasTalent("modifier_hoodwink_scurry_6") and not self.parent:HasModifier("modifier_hoodwink_scurry_custom_damaged") and self.main_ability then 
	self.parent:AddNewModifier(self.parent, self.main_ability, "modifier_hoodwink_scurry_custom_shield", {})
end

local stack = 1

if not self.parent:HasTalent("modifier_hoodwink_scurry_6") then 
	local trees = GridNav:GetAllTreesAroundPoint( self.parent:GetOrigin(), self.radius, false )
	if #trees>0 then
	 	stack = 0 
	end
else 
	stack = 0
end 

if self.parent:PassivesDisabled() then
	stack = 1
end

if self:GetStackCount()~=stack then
	self:SetStackCount( stack )
	if stack==0 then
		self.effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_hoodwink/hoodwink_scurry_passive.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent )
		ParticleManager:SetParticleControl( self.effect_cast, 2, Vector( self.radius, 0, 0 ) )
		self:AddParticle( self.effect_cast, false, false, -1, false, false  )
	else

		if not self.effect_cast then return end
		ParticleManager:DestroyParticle( self.effect_cast, false )
		ParticleManager:ReleaseParticleIndex( self.effect_cast )
	end
end

end
