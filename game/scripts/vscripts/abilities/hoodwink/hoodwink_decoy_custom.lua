LinkLuaModifier( "modifier_hoodwink_decoy_custom_illusion", "abilities/hoodwink/hoodwink_decoy_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hoodwink_decoy_custom_thinker", "abilities/hoodwink/hoodwink_decoy_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hoodwink_decoy_custom_debuff", "abilities/hoodwink/hoodwink_decoy_custom", LUA_MODIFIER_MOTION_HORIZONTAL )
LinkLuaModifier( "modifier_hoodwink_scurry_custom_buff", "abilities/hoodwink/hoodwink_scurry_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hoodwink_bushwhack_custom_debuff", "abilities/hoodwink/hoodwink_bushwhack_custom", LUA_MODIFIER_MOTION_HORIZONTAL )
LinkLuaModifier( "modifier_hoodwink_sharpshooter_custom", "abilities/hoodwink/hoodwink_sharpshooter_custom", LUA_MODIFIER_MOTION_NONE )


hoodwink_decoy_custom = class({})



function hoodwink_decoy_custom:Precache(context)

    
PrecacheResource( "particle", "particles/units/heroes/hero_hoodwink/hoodwink_sharpshooter_range_finder.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_hoodwink/hoodwink_bushwhack_projectile.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_hoodwink/hoodwink_bushwhack_fail.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_hoodwink/hoodwink_bushwhack.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_hoodwink/hoodwink_bushwhack_target.vpcf", context )
PrecacheResource( "particle", "particles/tree_fx/tree_simple_explosion.vpcf", context )

end





function hoodwink_decoy_custom:OnSpellStart()
if not IsServer() then return end

local point = self:GetCursorPosition()
local dir = (point - self:GetCaster():GetAbsOrigin())
local range = (self:GetSpecialValueFor("AbilityCastRange")  + self:GetCaster():GetCastRangeBonus()) 

if dir:Length2D() > range then 
	point = self:GetCaster():GetAbsOrigin() + dir:Normalized()*range
end 

local duration = self:GetSpecialValueFor("lifetime")
local damage_out = -100
local damage_in = self:GetSpecialValueFor("incoming") - 100
local illusion = CreateIllusions(  self:GetCaster(), self:GetCaster(), {duration=duration,outgoing_damage=damage_out,incoming_damage=damage_in}, 1, 0, false, false )  

local scurry_ability = self:GetCaster():FindAbilityByName("hoodwink_scurry_custom")      


for k, v in pairs(illusion) do
	v:AddNewModifier(self:GetCaster(), scurry_ability, "modifier_hoodwink_scurry_custom_buff", {duration = duration})
	v:AddNewModifier(self:GetCaster(), self, "modifier_hoodwink_decoy_custom_illusion", {x = point.x, y = point.y})
	v:SetAbsOrigin(self:GetCaster():GetAbsOrigin())
	v:SetHealth(v:GetMaxHealth())
	v.owner = self:GetCaster()	
	v:SetOwner(nil)

    for _,mod in pairs(self:GetCaster():FindAllModifiers()) do
      if mod.StackOnIllusion ~= nil and mod.StackOnIllusion == true then
        v:UpgradeIllusion(mod:GetName(), mod:GetStackCount() )
      end
    end


end 


end





modifier_hoodwink_decoy_custom_illusion = class({})

function modifier_hoodwink_decoy_custom_illusion:IsHidden() return true end
function modifier_hoodwink_decoy_custom_illusion:IsPurgable() return false end

function modifier_hoodwink_decoy_custom_illusion:OnCreated(table)
if not IsServer() then return end

self.point = GetGroundPosition(Vector(table.x, table.y, 0), nil)
self.parent = self:GetParent()

self.ability = self:GetCaster():FindAbilityByName("hoodwink_sharpshooter_custom")

if not self.ability then return end
self.start_point = self.parent:GetAbsOrigin()
self.can_pass = GridNav:CanFindPath(self.start_point, self.point)

local dist = (self.point - self.start_point):Length2D()
local speed = self:GetParent():GetMoveSpeedModifier(self:GetParent():GetBaseMoveSpeed(), false)
self.timer = dist / speed + 0.3



self.radius = self.ability:GetSpecialValueFor("arrow_range")
self:StartIntervalThink(FrameTime())
end


function modifier_hoodwink_decoy_custom_illusion:SetEnd()
if not IsServer() then return end 
self.ended = true
self:SetDuration(0.3, true)

if self.particle then 
	ParticleManager:DestroyParticle(self.particle, true)
	ParticleManager:ReleaseParticleIndex(self.particle)
	self.particle = nil
end 

end 


function modifier_hoodwink_decoy_custom_illusion:OnIntervalThink()
if not IsServer() then return end
if not self.point then return end 
if self.ended then return end
if not self.ability or self.ability:GetLevel() < 1 then return end

local abs = self.parent:GetAbsOrigin()

if self:GetStackCount() == 0 then 


	if (abs - self.point):Length2D() <= 10 or (self.can_pass == false and self:GetElapsedTime() >= self.timer) then 
		self:SetStackCount(1)
		FindClearSpaceForUnit(self.parent, self.parent:GetAbsOrigin(), true)
	else 
		self.parent:MoveToPosition(self.point)
		return
	end 

end

local units = FindUnitsInRadius( self.parent:GetTeamNumber(), self.parent:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
if #units <= 0 then 
	units =  FindUnitsInRadius( self.parent:GetTeamNumber(), self.parent:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
end 



if not self.modifier then 
	self:EffectVisual()

	local origin = self.parent:GetAbsOrigin() + self.parent:GetForwardVector()
	self.modifier = self.parent:AddNewModifier( self:GetCaster(), self.ability, "modifier_hoodwink_sharpshooter_custom", { duration = 2.5, x = origin.x, y = origin.y, } )
	self.parent:StartGesture(ACT_DOTA_CHANNEL_ABILITY_6)
end 


if #units == 0 then return end

self:UpdateEffect()
self.modifier:IllusionScepterDirection(units[1])
self:UpdateEffect()

end


function modifier_hoodwink_decoy_custom_illusion:OnDestroy()
if not IsServer() then return end 

self:GetParent():Kill(nil, self:GetParent())
end 



function modifier_hoodwink_decoy_custom_illusion:EffectVisual()
local startpos = self:GetParent():GetAbsOrigin()
local endpos = startpos + self:GetParent():GetForwardVector() * self.ability:GetSpecialValueFor( "arrow_range" )

self.particle = ParticleManager:CreateParticleForPlayer( "particles/units/heroes/hero_hoodwink/hoodwink_sharpshooter_range_finder.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent(), self:GetCaster():GetPlayerOwner() )
ParticleManager:SetParticleControl( self.particle, 0, startpos )
ParticleManager:SetParticleControl( self.particle, 1, endpos )

self:AddParticle( self.particle, false, false, -1, false, false  )
end

function modifier_hoodwink_decoy_custom_illusion:UpdateEffect()
local startpos = self:GetParent():GetAbsOrigin()
local endpos = startpos + self:GetParent():GetForwardVector() * self.ability:GetSpecialValueFor( "arrow_range" )
ParticleManager:SetParticleControl( self.particle, 1, endpos )
end


function modifier_hoodwink_decoy_custom_illusion:CheckState()
return 
{
	[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
	[MODIFIER_STATE_DISARMED] = true,
}
end














