LinkLuaModifier("modifier_custom_scream_knockback", "abilities/queen_of_pain/custom_queenofpain_scream_of_pain", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_custom_scream_slow", "abilities/queen_of_pain/custom_queenofpain_scream_of_pain", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_scream_tracker", "abilities/queen_of_pain/custom_queenofpain_scream_of_pain", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_scream_armor", "abilities/queen_of_pain/custom_queenofpain_scream_of_pain", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_scream_lowhp", "abilities/queen_of_pain/custom_queenofpain_scream_of_pain", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_scream_slow_cd", "abilities/queen_of_pain/custom_queenofpain_scream_of_pain", LUA_MODIFIER_MOTION_NONE)




custom_queenofpain_scream_of_pain = class({})


function custom_queenofpain_scream_of_pain:GetAbilityTextureName()
    if self:GetCaster():HasModifier("modifier_queenofpain_immortal_custom") then
        return "queen_of_pain/qop_2022_immortal/qop_2022_immortal_scream_of_pain_red"
    elseif self:GetCaster():HasModifier("modifier_queenofpain_immortal_custom_v2") then
        return "queen_of_pain/qop_2022_immortal/qop_2022_immortal_scream_of_pain_blue"
    elseif self:GetCaster():HasModifier("modifier_queenofpain_arcana_custom_1") then
        return "queen_of_pain/arcana/queenofpain_scream_of_pain_alt1"
    elseif self:GetCaster():HasModifier("modifier_queenofpain_arcana_custom_2") then
        return "queen_of_pain/arcana/queenofpain_scream_of_pain_alt2"
    end
    return "queenofpain_scream_of_pain"
end


function custom_queenofpain_scream_of_pain:Precache(context)

PrecacheResource( "particle", "particles/units/heroes/hero_queenofpain/queen_scream_of_pain_owner.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_queenofpain/queen_scream_of_pain.vpcf", context )
PrecacheResource( "particle", "particles/huskar_leap_heal.vpcf", context )
PrecacheResource( "particle", "particles/queen_of_pain/queen_scream_proc.vpcf", context )

end


function custom_queenofpain_scream_of_pain:GetManaCost(iLevel)

if self:GetCaster():HasModifier("modifier_queenofpain_blood_pact") and self:GetCaster():FindAbilityByName("custom_queenofpain_blood_pact") then 
	return 0
end

return self.BaseClass.GetManaCost(self,iLevel)
end 


function custom_queenofpain_scream_of_pain:GetHealthCost(level)

if self:GetCaster():HasModifier("modifier_queenofpain_blood_pact") and self:GetCaster():FindAbilityByName("custom_queenofpain_blood_pact") then 
	return self:GetCaster():GetTalentValue("modifier_queen_Scream_legendary", "cost")*self:GetCaster():GetMaxHealth()/100
end

end 

function custom_queenofpain_scream_of_pain:GetCooldown(iLevel)
local upgrade_cooldown = 0	
local k = 1

if self:GetCaster():HasModifier("modifier_queen_Scream_cd") then 
	upgrade_cooldown =  self:GetCaster():GetTalentValue("modifier_queen_Scream_cd", "cd")
end

if self:GetCaster():HasModifier("modifier_custom_scream_lowhp") then 
	k = 1 - self:GetCaster():GetTalentValue("modifier_queen_Scream_fear", "cd")/100
end

return (self.BaseClass.GetCooldown(self, iLevel) - upgrade_cooldown)*k
end



function custom_queenofpain_scream_of_pain:GetCastRange( location , target)
	return self:GetSpecialValueFor("radius")
end



function custom_queenofpain_scream_of_pain:GetIntrinsicModifierName()
return "modifier_custom_scream_tracker"
end


function custom_queenofpain_scream_of_pain:ProcHeal()
if not IsServer() then return end

local random = RollPseudoRandomPercentage(self:GetCaster():GetTalentValue("modifier_queen_Scream_shield", "chance"),451,self:GetCaster())
if not random then return end

local heal = (self:GetCaster():GetMaxHealth())*self:GetCaster():GetTalentValue("modifier_queen_Scream_shield", "heal")/100

self:GetCaster():GenericHeal(heal, self)

local damage = heal

local particle_cast = "particles/queen_of_pain/queen_scream_proc.vpcf"

self:GetCaster():EmitSound("QoP.Scream_heal")

local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN,  nil)
ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetAbsOrigin() )
ParticleManager:SetParticleControl( effect_cast, 1, Vector( 180 , 0, 0 ) )
ParticleManager:ReleaseParticleIndex( effect_cast )



local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self:GetCaster():GetTalentValue("modifier_queen_Scream_shield", "radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, 0, false )
   
for _,unit in pairs(units) do  
    ApplyDamage({ victim = unit, attacker = self:GetCaster(), damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self, })
	SendOverheadEventMessage(unit, 6, unit, damage, nil)
end


end






function custom_queenofpain_scream_of_pain:OnSpellStart(damage_k, new_caster, can_hits, slow)
if not IsServer() then return end		
		
if test then 

  --  CustomGameEventManager:Send_ServerToAllClients('show_new_shop_heroes', {heroes = new_shop_heroes} ) 
end

local damage = self:GetSpecialValueFor("damage")
local projectile_speed = self:GetSpecialValueFor("projectile_speed")
local radius = self:GetSpecialValueFor("radius")


local caster = self:GetCaster()
if new_caster then 
	caster = new_caster
end

local can_hit = false
if not can_hits then
	can_hit = true
end

	
local scream_loc = caster:GetAbsOrigin()

if self:GetCaster():HasModifier("modifier_queen_Scream_damage") then 
	damage = damage + self:GetCaster():GetTalentValue("modifier_queen_Scream_damage", "damage")*self:GetCaster():GetMaxHealth()/100
end

if damage_k then 
	damage = damage*damage_k
end



local hits = false 	
if self:GetCaster():HasModifier("modifier_custom_blink_spell") and can_hit == true then 
	hits = true 
	self:GetCaster():RemoveModifierByName("modifier_custom_blink_spell")
end



EmitSoundOnLocationWithCaster(scream_loc, "Hero_QueenOfPain.ScreamOfPain", self:GetCaster())

local particle_name = "particles/units/heroes/hero_queenofpain/queen_scream_of_pain_owner.vpcf"
if self:GetCaster():HasModifier("modifier_queenofpain_immortal_custom") then
    particle_name = "particles/econ/items/queen_of_pain/qop_2022_immortal/queen_2022_scream_of_pain_owner.vpcf"
end
if self:GetCaster():HasModifier("modifier_queenofpain_immortal_custom_v2") then
    particle_name = "particles/econ/items/queen_of_pain/qop_2022_immortal/queen_2022_scream_of_pain_owner_blue.vpcf"
end

local scream_pfx = ParticleManager:CreateParticle(particle_name, PATTACH_ABSORIGIN, caster)
ParticleManager:SetParticleControl(scream_pfx, 0, scream_loc )
ParticleManager:ReleaseParticleIndex(scream_pfx)


local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), scream_loc, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)

if caster == self:GetCaster() then 

	if #enemies > 0 and self:GetCaster():HasModifier("modifier_queen_Scream_double") then 
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_custom_scream_armor", {duration = self:GetCaster():GetTalentValue("modifier_queen_Scream_double", "duration")})
	end

	if self:GetCaster():HasModifier("modifier_queen_Scream_shield") then 
		self:ProcHeal()
	end

end

local particle_name = "particles/units/heroes/hero_queenofpain/queen_scream_of_pain.vpcf"
if self:GetCaster():HasModifier("modifier_queenofpain_immortal_custom") then
    particle_name = "particles/econ/items/queen_of_pain/qop_2022_immortal/queen_2022_scream_of_pain_projectile.vpcf"
end
if self:GetCaster():HasModifier("modifier_queenofpain_immortal_custom_v2") then
    particle_name = "particles/econ/items/queen_of_pain/qop_2022_immortal/queen_2022_scream_of_pain_projectile_blue.vpcf"
end

for _, enemy in pairs(enemies) do

	local projectile =
		{
			Target 				= enemy,
			Source 				= caster,
			Ability 			= self,
			EffectName 			= particle_name,
			iMoveSpeed			= projectile_speed,
			vSourceLoc 			= scream_loc,
			bDrawsOnMinimap 	= false,
			bDodgeable 			= true,
			bIsAttack 			= false,
			bVisibleToEnemies 	= true,
			bReplaceExisting 	= false,
			flExpireTime 		= GameRules:GetGameTime() + 20,
			bProvidesVision 	= false,
			iSourceAttachment 	= DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,
			ExtraData			= {damage = damage}
		}
	ProjectileManager:CreateTrackingProjectile(projectile)

	if hits == true then 

		local no = self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_custom_blink_legendary_nospeed", {})

		self:GetCaster():PerformAttack(enemy, true, true, true, false , true, false , false)
		if no then no:Destroy() end
	end

	if slow then 
		enemy:AddNewModifier(self:GetCaster(), self, "modifier_custom_scream_knockback", {duration = self:GetCaster():GetTalentValue("modifier_queen_Scream_slow", "knock_duration") * (1 - enemy:GetStatusResistance()), x = self:GetCaster():GetAbsOrigin().x, y = self:GetCaster():GetAbsOrigin().y})
	end

	
end


end





function custom_queenofpain_scream_of_pain:OnProjectileHit_ExtraData(target, location, ExtraData)
if not IsServer() then return end
if not target then return end
if target:IsMagicImmune() then return end

local caster = self:GetCaster()

local damage  = ExtraData.damage


ApplyDamage({victim = target, attacker = caster, ability = self, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})


end









modifier_custom_scream_knockback = class({})

function modifier_custom_scream_knockback:IsHidden() return true end

function modifier_custom_scream_knockback:OnCreated(params)
  if not IsServer() then return end
  
  self.ability        = self:GetAbility()
  self.caster         = self:GetCaster()
  self.parent         = self:GetParent()
  self:GetParent():StartGesture(ACT_DOTA_FLAIL)
  
  self.knockback_duration   = self:GetCaster():GetTalentValue("modifier_queen_Scream_slow", "knock_duration")

  self.knockback_distance   = math.max(self:GetCaster():GetTalentValue("modifier_queen_Scream_slow", "knock_distance") - (self.caster:GetAbsOrigin() - self.parent:GetAbsOrigin()):Length2D(), 50)
  
  self.knockback_speed    = self.knockback_distance / self.knockback_duration


  self.position = GetGroundPosition(Vector(params.x, params.y, 0), nil)
  
  if self:ApplyHorizontalMotionController() == false then 
    self:Destroy()
    return
  end
end

function modifier_custom_scream_knockback:UpdateHorizontalMotion( me, dt )
  if not IsServer() then return end

  local distance = (me:GetOrigin() - self.position):Normalized()
  
  me:SetOrigin( me:GetOrigin() + distance * self.knockback_speed * dt )

  GridNav:DestroyTreesAroundPoint( self.parent:GetOrigin(), self.parent:GetHullRadius(), true )
end

function modifier_custom_scream_knockback:DeclareFunctions()
  local decFuncs = {
    MODIFIER_PROPERTY_OVERRIDE_ANIMATION
    }

    return decFuncs
end

function modifier_custom_scream_knockback:GetOverrideAnimation()
   return ACT_DOTA_FLAIL
end


function modifier_custom_scream_knockback:OnDestroy()
  if not IsServer() then return end
  self.parent:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_scream_slow", {duration = self:GetCaster():GetTalentValue("modifier_queen_Scream_slow", "duration")})
  self.parent:RemoveHorizontalMotionController( self )
  self:GetParent():FadeGesture(ACT_DOTA_FLAIL)
end






modifier_custom_scream_slow = class({})
function modifier_custom_scream_slow:IsHidden() return false end
function modifier_custom_scream_slow:IsPurgable() return true end
function modifier_custom_scream_slow:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end
function modifier_custom_scream_slow:GetModifierMoveSpeedBonus_Percentage() return self.slow end

function modifier_custom_scream_slow:GetStatusEffectName()
  return "particles/status_fx/status_effect_huskar_lifebreak.vpcf"
end


function modifier_custom_scream_slow:OnCreated()
  self.slow = self:GetCaster():GetTalentValue("modifier_queen_Scream_slow", "slow")
end 


modifier_custom_scream_tracker = class({})
function modifier_custom_scream_tracker:IsHidden() return true end
function modifier_custom_scream_tracker:IsPurgable() return false end
function modifier_custom_scream_tracker:DeclareFunctions()
return
{
    MODIFIER_EVENT_ON_ATTACK_LANDED
}
end



function modifier_custom_scream_tracker:OnCreated(table)
if not IsServer() then return end

self:StartIntervalThink(1)
end


function modifier_custom_scream_tracker:OnIntervalThink()
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_queen_Scream_fear") then return end
if not self:GetParent():IsAlive() then return end

local mod = self:GetParent():FindModifierByName("modifier_custom_scream_lowhp")

if (self:GetParent():GetHealthPercent() > self:GetCaster():GetTalentValue("modifier_queen_Scream_fear", "health") and mod) or self:GetParent():PassivesDisabled() then 
	mod:Destroy()
end

if self:GetParent():GetHealthPercent() <= self:GetCaster():GetTalentValue("modifier_queen_Scream_fear", "health") and not mod and not self:GetParent():PassivesDisabled() then 
	self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_scream_lowhp", {})
end

self:StartIntervalThink(0.1)
end


function modifier_custom_scream_tracker:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent() ~= params.target then return end
if not params.attacker:IsHero() and not params.attacker:IsCreep() then return end

if not self:GetParent():HasModifier("modifier_queen_Scream_slow") then return end
if self:GetParent():HasModifier("modifier_custom_scream_slow_cd") then return end
if (params.attacker:GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D() > self:GetCaster():GetTalentValue("modifier_queen_Scream_slow", "range") then return end
if self:GetParent():PassivesDisabled() then return end


self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_scream_slow_cd", {duration = self:GetCaster():GetTalentValue("modifier_queen_Scream_slow", "cd")})

self:GetAbility():OnSpellStart(1, self:GetParent(), false, true)

end



modifier_custom_scream_armor = class({})
function modifier_custom_scream_armor:IsHidden() return false end
function modifier_custom_scream_armor:IsPurgable() return false end
function modifier_custom_scream_armor:GetTexture() return "buffs/bloodlust_damage" end
function modifier_custom_scream_armor:OnCreated(table)

self.max = self:GetCaster():GetTalentValue("modifier_queen_Scream_double", "max")
self.damage = self:GetCaster():GetTalentValue("modifier_queen_Scream_double", "damage_reduce")


if not IsServer() then return end

self:SetStackCount(1)

end

function modifier_custom_scream_armor:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end

self:IncrementStackCount()
end


function modifier_custom_scream_armor:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
}
end


function modifier_custom_scream_armor:GetModifierIncomingDamage_Percentage()
return self.damage*self:GetStackCount()
end


modifier_custom_scream_lowhp = class({})
function modifier_custom_scream_lowhp:IsHidden() return false end
function modifier_custom_scream_lowhp:IsPurgable() return false end
function modifier_custom_scream_lowhp:GetTexture() return "buffs/scream_fear" end

function modifier_custom_scream_lowhp:OnCreated()

self.heal = self:GetCaster():GetTalentValue("modifier_queen_Scream_fear", "heal")/100
self.creeps = self:GetCaster():GetTalentValue("modifier_queen_Scream_fear", "heal_creeps")
if not IsServer() then return end

self:GetParent():EmitSound("Lc.Moment_Lowhp")
self.particle = ParticleManager:CreateParticle( "particles/lc_lowhp.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
ParticleManager:SetParticleControl( self.particle, 0, self:GetParent():GetAbsOrigin() )
ParticleManager:SetParticleControl( self.particle, 1, self:GetParent():GetAbsOrigin() )
ParticleManager:SetParticleControl( self.particle, 2, self:GetParent():GetAbsOrigin() )
self:AddParticle(self.particle, false, false, 0, true, false)
end

function modifier_custom_scream_lowhp:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_TAKEDAMAGE
}
end

function modifier_custom_scream_lowhp:OnTakeDamage(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end
if not params.unit:IsCreep() and not params.unit:IsHero() then return end
if bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then return end

local heal = self.heal

if params.unit:IsCreep() then 
	heal = heal/self.creeps
end

self:GetParent():GenericHeal(heal*params.damage, self:GetParent(), false, "particles/items3_fx/octarine_core_lifesteal.vpcf")

end

function modifier_custom_scream_lowhp:GetEffectName()
return "particles/units/heroes/hero_pudge/pudge_fleshheap_block_shield_model.vpcf"
end
function modifier_custom_scream_lowhp:GetEffectAttachType()
return PATTACH_ABSORIGIN_FOLLOW
end








modifier_custom_scream_slow_cd = class({})
function modifier_custom_scream_slow_cd:IsHidden() return false end
function modifier_custom_scream_slow_cd:IsPurgable() return false end
function modifier_custom_scream_slow_cd:RemoveOnDeath() return false end
function modifier_custom_scream_slow_cd:GetTexture() return "buffs/scream_slow" end
function modifier_custom_scream_slow_cd:IsDebuff() return true end
function modifier_custom_scream_slow_cd:OnCreated(table)
self.RemoveForDuel = true
end