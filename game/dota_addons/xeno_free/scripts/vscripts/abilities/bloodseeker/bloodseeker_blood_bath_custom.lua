LinkLuaModifier("modifier_bloodseeker_blood_bath_custom_thinker", "abilities/bloodseeker/bloodseeker_blood_bath_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bloodseeker_blood_bath_custom_silence", "abilities/bloodseeker/bloodseeker_blood_bath_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bloodseeker_blood_bath_custom_bkb", "abilities/bloodseeker/bloodseeker_blood_bath_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bloodseeker_blood_bath_custom_slow_aura", "abilities/bloodseeker/bloodseeker_blood_bath_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bloodseeker_blood_bath_custom_slow_blood", "abilities/bloodseeker/bloodseeker_blood_bath_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bloodseeker_blood_bath_custom_center", "abilities/bloodseeker/bloodseeker_blood_bath_custom", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_bloodseeker_blood_bath_custom_attack", "abilities/bloodseeker/bloodseeker_blood_bath_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bloodseeker_blood_bath_custom_attack_root", "abilities/bloodseeker/bloodseeker_blood_bath_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bloodseeker_blood_bath_custom_attack_str", "abilities/bloodseeker/bloodseeker_blood_bath_custom", LUA_MODIFIER_MOTION_NONE)

bloodseeker_blood_bath_custom = class({})

bloodseeker_blood_bath_custom.dispel_bkb = 1.5

bloodseeker_blood_bath_custom.damage_inc = {6, 9, 12}
bloodseeker_blood_bath_custom.damage_duration = 5

bloodseeker_blood_bath_custom.slow_stun = 1.5
bloodseeker_blood_bath_custom.knockback_duration = 0.5

bloodseeker_blood_bath_custom.slow_move = {-20, -30, -40}
bloodseeker_blood_bath_custom.slow_attack = {-20, -30, -40}

bloodseeker_blood_bath_custom.self_heal = {0.15, 0.20, 0.25}

bloodseeker_blood_bath_custom.legendary_max = 5
bloodseeker_blood_bath_custom.legendary_interval = 0.25
bloodseeker_blood_bath_custom.legendary_damage = 1
bloodseeker_blood_bath_custom.legendary_self = 0.04

bloodseeker_blood_bath_custom.attack_root = {1, 1.5}
bloodseeker_blood_bath_custom.attack_duration = 5
bloodseeker_blood_bath_custom.attack_str_duration = 6
bloodseeker_blood_bath_custom.attack_str = {0.1, 0.15}

bloodseeker_blood_bath_custom.pull_cd = 1





function bloodseeker_blood_bath_custom:Precache(context)

PrecacheResource( "particle", 'particles/units/heroes/hero_bloodseeker/bloodseeker_bloodritual_ring.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_bloodseeker/bloodseeker_bloodritual_impact.vpcf', context )
PrecacheResource( "particle", 'particles/status_fx/status_effect_rupture.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_bloodseeker/bloodseeker_rupture.vpcf', context )
PrecacheResource( "particle", 'particles/bs_root.vpcf', context )

end




function bloodseeker_blood_bath_custom:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end


function bloodseeker_blood_bath_custom:GetCooldown(iLevel)

local up = 0
if self:GetCaster():HasModifier("modifier_bloodseeker_bloodrite_6") then 
  up = self.pull_cd
end

return self.BaseClass.GetCooldown(self, iLevel) - up
 
end




function bloodseeker_blood_bath_custom:OnSpellStart()
if not IsServer() then return end
local point = self:GetCursorPosition()
local delay = self:GetSpecialValueFor("delay")

if self:GetCaster():HasModifier("modifier_bloodseeker_bloodrite_7") then 
	delay = self.legendary_max
end


self.thinker = CreateModifierThinker( self:GetCaster(), self, "modifier_bloodseeker_blood_bath_custom_thinker", {duration = delay}, point, self:GetCaster():GetTeamNumber(), false )
self.thinker:EmitSound("Hero_Bloodseeker.BloodRite.Cast")

local ability_end = self:GetCaster():FindAbilityByName("bloodseeker_blood_bath_custom_end")

if self:GetCaster():HasModifier("modifier_bloodseeker_bloodrite_7") and ability_end:IsHidden() then 
	self:GetCaster():SwapAbilities(self:GetName(), "bloodseeker_blood_bath_custom_end", false, true)

	ability_end:StartCooldown(0.3)
end

if self:GetCaster():HasModifier("modifier_bloodseeker_bloodrite_4") then 
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_bloodseeker_blood_bath_custom_attack", {duration = self.attack_duration})
end

end


bloodseeker_blood_bath_custom_end = class({})

function bloodseeker_blood_bath_custom_end:OnSpellStart()

local ability = self:GetCaster():FindAbilityByName("bloodseeker_blood_bath_custom")

if self:GetCaster():HasModifier("modifier_bloodseeker_bloodrite_7") and ability and ability:IsHidden() then 
	self:GetCaster():SwapAbilities("bloodseeker_blood_bath_custom_end", "bloodseeker_blood_bath_custom", false, true)
end


if ability.thinker then 
	ability.thinker:FindModifierByName("modifier_bloodseeker_blood_bath_custom_thinker"):Destroy()
end

end








modifier_bloodseeker_blood_bath_custom_thinker = class({})

function modifier_bloodseeker_blood_bath_custom_thinker:IsPurgable()
	return false
end



function modifier_bloodseeker_blood_bath_custom_thinker:IsHidden() return true end

function modifier_bloodseeker_blood_bath_custom_thinker:IsPurgable() return false end

function modifier_bloodseeker_blood_bath_custom_thinker:IsAura() 
if self:GetCaster():HasModifier("modifier_bloodseeker_bloodrite_3") then 
	return true 
end

end

function modifier_bloodseeker_blood_bath_custom_thinker:GetAuraDuration() return 0.1 end

function modifier_bloodseeker_blood_bath_custom_thinker:GetAuraRadius() return self.radius
end

function modifier_bloodseeker_blood_bath_custom_thinker:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end

function modifier_bloodseeker_blood_bath_custom_thinker:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO +  DOTA_UNIT_TARGET_BASIC end

function modifier_bloodseeker_blood_bath_custom_thinker:GetModifierAura() return "modifier_bloodseeker_blood_bath_custom_slow_aura" end

function modifier_bloodseeker_blood_bath_custom_thinker:OnCreated( kv )
if not IsServer() then return end

self.damage = self:GetAbility():GetSpecialValueFor("damage")

if self:GetCaster():HasModifier("modifier_bloodseeker_bloodrite_7") then 
	self.sound_count = 0
	self:StartIntervalThink( self:GetAbility().legendary_interval )
end

self.radius = self:GetAbility():GetSpecialValueFor("radius")
self.silence_duration = self:GetAbility():GetSpecialValueFor("silence_duration")


if self:GetCaster():HasModifier("modifier_bloodseeker_bloodrite_6") then 

	local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetParent():GetOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
	for _,enemy in pairs(enemies) do 
		enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_bloodseeker_blood_bath_custom_center", {duration = self:GetAbility().knockback_duration, x = self:GetParent():GetAbsOrigin().x, y = self:GetParent():GetAbsOrigin().y})
	end
end

AddFOWViewer( self:GetCaster():GetTeamNumber(), self:GetParent():GetOrigin(), 600, 6 + self:GetRemainingTime(), false)

self.particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_bloodseeker/bloodseeker_bloodritual_ring.vpcf", PATTACH_WORLDORIGIN, nil )
ParticleManager:SetParticleControl( self.particle, 0, self:GetParent():GetOrigin() )
ParticleManager:SetParticleControl( self.particle, 1, Vector( self.radius, self.radius, self.radius ) )
self:AddParticle(self.particle, false, false, -1, false, false)
self:GetParent():EmitSound("Hero_Bloodseeker.BloodRite")
end

function modifier_bloodseeker_blood_bath_custom_thinker:OnIntervalThink()
if not IsServer() then return end

self.sound_count = self.sound_count + self:GetAbility().legendary_interval
if self.sound_count >= 2.25 then 
	self:GetParent():StopSound("Hero_Bloodseeker.BloodRite")
	self.sound_count = -999
end

if (self:GetParent():GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Length2D() > self.radius then return end

local damage = self:GetCaster():GetMaxHealth()*self:GetAbility().legendary_self*self:GetAbility().legendary_interval

ApplyDamage({attacker = self:GetCaster(), victim = self:GetCaster(), damage_type = DAMAGE_TYPE_PURE, ability = self:GetAbility(), damage = damage, damage_flags = DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS + DOTA_DAMAGE_FLAG_NON_LETHAL})
self:SetStackCount(self:GetStackCount() + damage*self:GetAbility().legendary_damage)

end



function modifier_bloodseeker_blood_bath_custom_thinker:OnDestroy( kv )
if not IsServer() then return end


self:GetAbility().thinker = nil

if self:GetCaster():HasModifier("modifier_bloodseeker_bloodrite_7") then

	if self:GetAbility():IsHidden() then 
		self:GetCaster():SwapAbilities("bloodseeker_blood_bath_custom_end", "bloodseeker_blood_bath_custom", false, true)
	end 

	self:GetParent():EmitSound("hero_bloodseeker.bloodRite.silence")
	self:GetParent():StopSound("Hero_Bloodseeker.BloodRite")
end


local search_type = DOTA_UNIT_TARGET_TEAM_ENEMY
if self:GetCaster():HasModifier("modifier_bloodseeker_bloodrite_5") or self:GetCaster():HasModifier("modifier_bloodseeker_bloodrite_2") then 
	search_type = DOTA_UNIT_TARGET_TEAM_BOTH
end

if self:GetStackCount() > 0 then 
	self.damage = self.damage + self:GetStackCount()
end

local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetParent():GetOrigin(), nil, self.radius, search_type, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )

for _,enemy in pairs(enemies) do
	if enemy:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then 


		if enemy:IsRealHero() and self:GetCaster():GetQuest() == "Blood.Quest_6" then 
			self:GetCaster():UpdateQuest(1)
		end

		enemy:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_bloodseeker_blood_bath_custom_silence", { duration = self.silence_duration*(1 - enemy:GetStatusResistance()) } )

		if self:GetCaster():HasModifier("modifier_bloodseeker_bloodrite_1") then
			enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_bloodseeker_blood_bath_custom_slow_blood", {duration = self:GetAbility().damage_duration})
		end


		ApplyDamage({ attacker = self:GetCaster(), victim = enemy, damage = self.damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self:GetAbility() })

		if self:GetCaster():HasModifier("modifier_bloodseeker_bloodrite_6") and not enemy:HasModifier("modifier_bloodseeker_blood_bath_custom_center") then 
			enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_bloodseeker_blood_bath_custom_center", {duration = self:GetAbility().knockback_duration, x = self:GetParent():GetAbsOrigin().x, y = self:GetParent():GetAbsOrigin().y})
		end

		local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_bloodseeker/bloodseeker_bloodritual_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy )
		ParticleManager:ReleaseParticleIndex( particle )
		enemy:EmitSound("hero_bloodseeker.bloodRite.silence")
	else 
		if self:GetCaster() == enemy then 
			if self:GetCaster():HasModifier("modifier_bloodseeker_bloodrite_5") then 
				self:GetCaster():EmitSound("BS.Bloodrite_purge")
				self:GetCaster():Purge(false, true, false, true, false)
				self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_generic_debuff_immune", {effect = 1, duration = self:GetAbility().dispel_bkb})
			end

			if self:GetCaster():HasModifier("modifier_bloodseeker_bloodrite_2") then 
				my_game:GenericHeal(self:GetCaster(), self:GetCaster():GetMaxHealth()*self:GetAbility().self_heal[self:GetCaster():GetUpgradeStack("modifier_bloodseeker_bloodrite_2")], self:GetAbility())
			end
		end
	end
end


UTIL_Remove(self:GetParent())
end







modifier_bloodseeker_blood_bath_custom_silence = class({})

function modifier_bloodseeker_blood_bath_custom_silence:IsPurgable() return true end

function modifier_bloodseeker_blood_bath_custom_silence:CheckState()
	local state = {
		[MODIFIER_STATE_SILENCED] = true,
	}

	return state
end

function modifier_bloodseeker_blood_bath_custom_silence:GetEffectName()
	return "particles/generic_gameplay/generic_silenced.vpcf"
end

function modifier_bloodseeker_blood_bath_custom_silence:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end



function modifier_bloodseeker_blood_bath_custom_silence:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
end


function modifier_bloodseeker_blood_bath_custom_silence:GetModifierMoveSpeedBonus_Percentage()
if self:GetCaster():HasModifier("modifier_bloodseeker_bloodrite_3") then 
	return self:GetAbility().slow_move[self:GetCaster():GetUpgradeStack("modifier_bloodseeker_bloodrite_3")]
end

end


function modifier_bloodseeker_blood_bath_custom_silence:GetModifierAttackSpeedBonus_Constant()
if self:GetCaster():HasModifier("modifier_bloodseeker_bloodrite_3") then 
	return self:GetAbility().slow_attack[self:GetCaster():GetUpgradeStack("modifier_bloodseeker_bloodrite_3")]
end

end


function modifier_bloodseeker_blood_bath_custom_silence:OnDestroy()
if not IsServer() then return end

if false and self:GetCaster():HasModifier("modifier_bloodseeker_bloodrite_6") and self:GetRemainingTime() > 0.1 then 
	self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stunned", {duration = (1 - self:GetParent():GetStatusResistance())*self:GetAbility().slow_stun})
end


end


modifier_bloodseeker_blood_bath_custom_bkb = class({})
function modifier_bloodseeker_blood_bath_custom_bkb:IsHidden() return true end
function modifier_bloodseeker_blood_bath_custom_bkb:IsPurgable() return false end 
function modifier_bloodseeker_blood_bath_custom_bkb:GetEffectName() return "particles/items_fx/black_king_bar_avatar.vpcf" end
function modifier_bloodseeker_blood_bath_custom_bkb:CheckState() return {[MODIFIER_STATE_MAGIC_IMMUNE] = true} end


modifier_bloodseeker_blood_bath_custom_slow_aura = class({})
function modifier_bloodseeker_blood_bath_custom_slow_aura:IsHidden() return true end
function modifier_bloodseeker_blood_bath_custom_slow_aura:IsPurgable() return false end
function modifier_bloodseeker_blood_bath_custom_slow_aura:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
end

function modifier_bloodseeker_blood_bath_custom_slow_aura:GetModifierMoveSpeedBonus_Percentage()
return self:GetAbility().slow_move[self:GetCaster():GetUpgradeStack("modifier_bloodseeker_bloodrite_3")]

end


function modifier_bloodseeker_blood_bath_custom_slow_aura:GetModifierAttackSpeedBonus_Constant()
return self:GetAbility().slow_attack[self:GetCaster():GetUpgradeStack("modifier_bloodseeker_bloodrite_3")]

end








modifier_bloodseeker_blood_bath_custom_slow_blood = class({})
function modifier_bloodseeker_blood_bath_custom_slow_blood:IsHidden() return false end
function modifier_bloodseeker_blood_bath_custom_slow_blood:IsPurgable() return false end
function modifier_bloodseeker_blood_bath_custom_slow_blood:GetTexture() return "buffs/Crit_blood" end
function modifier_bloodseeker_blood_bath_custom_slow_blood:GetEffectName() return "particles/items2_fx/sange_maim.vpcf" end

function modifier_bloodseeker_blood_bath_custom_slow_blood:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
}

end

function modifier_bloodseeker_blood_bath_custom_slow_blood:GetModifierIncomingDamage_Percentage()
return self:GetAbility().damage_inc[self:GetCaster():GetUpgradeStack("modifier_bloodseeker_bloodrite_1")]
end







modifier_bloodseeker_blood_bath_custom_center = class({})

function modifier_bloodseeker_blood_bath_custom_center:IsHidden() return true end





function modifier_bloodseeker_blood_bath_custom_center:GetStatusEffectName()
	return "particles/status_fx/status_effect_rupture.vpcf"
end

function modifier_bloodseeker_blood_bath_custom_center:StatusEffectPriority()
	return 500
end


		


function modifier_bloodseeker_blood_bath_custom_center:OnCreated(params)
  if not IsServer() then return end
  
  self.ability        = self:GetAbility()
  self.caster         = self:GetCaster()
  self.parent         = self:GetParent()
  self:GetParent():StartGesture(ACT_DOTA_FLAIL)
  
  self.knockback_duration   = self.ability.knockback_duration

	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_bloodseeker/bloodseeker_rupture.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControlEnt(particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
	self:AddParticle(particle, false, false, -1, false, false)

  --self.knockback_distance   = math.max(self.ability.knockback_distance - (self.caster:GetAbsOrigin() - self.parent:GetAbsOrigin()):Length2D(), 50)
  
  self.position = GetGroundPosition(Vector(params.x, params.y, 0), nil)

  self.knockback_distance = (self:GetParent():GetAbsOrigin() -self.position):Length2D() 

  self.knockback_speed    = self.knockback_distance / self.knockback_duration
  
  
  if self:ApplyHorizontalMotionController() == false then 
    self:Destroy()
    return
  end
end

function modifier_bloodseeker_blood_bath_custom_center:UpdateHorizontalMotion( me, dt )
  if not IsServer() then return end

  local distance = (self.position - me:GetOrigin()):Normalized()
  
  me:SetOrigin( me:GetOrigin() + distance * self.knockback_speed * dt )

  GridNav:DestroyTreesAroundPoint( self.parent:GetOrigin(), self.parent:GetHullRadius(), true )
end

function modifier_bloodseeker_blood_bath_custom_center:DeclareFunctions()
  local decFuncs = {
    MODIFIER_PROPERTY_OVERRIDE_ANIMATION
    }

    return decFuncs
end

function modifier_bloodseeker_blood_bath_custom_center:GetOverrideAnimation()
   return ACT_DOTA_FLAIL
end


function modifier_bloodseeker_blood_bath_custom_center:OnDestroy()
  if not IsServer() then return end
 self.parent:RemoveHorizontalMotionController( self )
  self:GetParent():FadeGesture(ACT_DOTA_FLAIL)
end



modifier_bloodseeker_blood_bath_custom_attack = class({})
function modifier_bloodseeker_blood_bath_custom_attack:IsHidden() return false end
function modifier_bloodseeker_blood_bath_custom_attack:IsPurgable() return false end
function modifier_bloodseeker_blood_bath_custom_attack:GetTexture() return "buffs/bloodrite_attack" end
function modifier_bloodseeker_blood_bath_custom_attack:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_ATTACK_LANDED
}
end

function modifier_bloodseeker_blood_bath_custom_attack:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end
if params.target:IsMagicImmune() or params.target:IsBuilding() then return end
local root = (1 - params.target:GetStatusResistance())*(self:GetAbility().attack_root[self:GetCaster():GetUpgradeStack("modifier_bloodseeker_bloodrite_4")])

local str = 0
if params.target:IsHero() then 
	str = self:GetAbility().attack_str[self:GetCaster():GetUpgradeStack("modifier_bloodseeker_bloodrite_4")]*params.target:GetStrength()
end

if params.target:IsCreep() then 

	str = self:GetAbility().attack_str[self:GetCaster():GetUpgradeStack("modifier_bloodseeker_bloodrite_4")]*self:GetParent():GetStrength()
end

params.target:EmitSound("BS.Bloodrite_root")

params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_bloodseeker_blood_bath_custom_attack_root", {duration = root})
local mod = params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_bloodseeker_blood_bath_custom_attack_str", {duration = self:GetAbility().attack_str_duration})
mod:SetStackCount(str)

mod = self:GetCaster():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_bloodseeker_blood_bath_custom_attack_str", {duration = self:GetAbility().attack_str_duration})
mod:SetStackCount(str)

self:GetParent():CalculateStatBonus(true)
if params.target:IsHero() then 
	params.target:CalculateStatBonus(true)
end

self:Destroy()
end




modifier_bloodseeker_blood_bath_custom_attack_root = class({})
function modifier_bloodseeker_blood_bath_custom_attack_root:IsHidden() return true end
function modifier_bloodseeker_blood_bath_custom_attack_root:IsPurgable() return true end



function modifier_bloodseeker_blood_bath_custom_attack_root:CheckState()
return
{
	[MODIFIER_STATE_ROOTED] = true
}
end

function modifier_bloodseeker_blood_bath_custom_attack_root:GetEffectName()
return "particles/bs_root.vpcf"
end



modifier_bloodseeker_blood_bath_custom_attack_str = class({})
function modifier_bloodseeker_blood_bath_custom_attack_str:IsHidden() return false end
function modifier_bloodseeker_blood_bath_custom_attack_str:IsPurgable() return false end
function modifier_bloodseeker_blood_bath_custom_attack_str:GetTexture() return "buffs/bloodrite_attack" end
function modifier_bloodseeker_blood_bath_custom_attack_str:OnCreated(table)
if self:GetParent():IsCreep() then 
	self:Destroy()
	return
end

self.k = 1
if self:GetCaster() ~= self:GetParent() then 
	self.k = -1
end


end

function modifier_bloodseeker_blood_bath_custom_attack_str:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_STATS_STRENGTH_BONUS
}
end


function modifier_bloodseeker_blood_bath_custom_attack_str:GetModifierBonusStats_Strength()
return self.k*self:GetStackCount()
end
