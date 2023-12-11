LinkLuaModifier("modifier_custom_puck_waning_rift", "abilities/puck/custom_puck_waning_rift", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_waning_rift_knockback", "abilities/puck/custom_puck_waning_rift", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_custom_puck_waning_rift_legendary", "abilities/puck/custom_puck_waning_rift", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_puck_waning_rift_tracker", "abilities/puck/custom_puck_waning_rift", LUA_MODIFIER_MOTION_NONE)


custom_puck_waning_rift = class({})

custom_puck_waning_rift.shard_damage = 70
custom_puck_waning_rift.shard_duration = 5	
custom_puck_waning_rift.shard_radius = 200
custom_puck_waning_rift.shard_knockback = 0.4 	 	

custom_puck_waning_rift.damage_mana = {0.04, 0.06, 0.08}

custom_puck_waning_rift.cd_inc = {-3, -4, -5}


custom_puck_waning_rift.purge_duration = 0.5
custom_puck_waning_rift.purge_stun = 1

custom_puck_waning_rift.legendary_interval = 0.5
custom_puck_waning_rift.legendary_max  = 6
custom_puck_waning_rift.legendary_mana = 0.05
custom_puck_waning_rift.legendary_damage = 20



custom_puck_waning_rift.regen_chance = 50
custom_puck_waning_rift.regen_init = 0.05
custom_puck_waning_rift.regen_inc = 0.05



function custom_puck_waning_rift:Precache(context)

PrecacheResource( "particle", "particles/items3_fx/blink_arcane_start.vpcf", context )
PrecacheResource( "particle", "particles/items3_fx/blink_arcane_end.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_puck/puck_waning_rift.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_keeper_of_the_light/keeper_chakra_magic.vpcf", context )
PrecacheResource( "particle", "particles/puck_silence_damage.vpcf", context )
PrecacheResource( "particle", "particles/econ/items/outworld_devourer/od_shards_exile/od_shards_exile_prison_end.vpcf", context )
PrecacheResource( "particle", "particles/puck_silence_charges.vpcf", context )
PrecacheResource( "particle", "particles/generic_gameplay/rune_arcane_owner.vpcf", context )

end


function custom_puck_waning_rift:GetIntrinsicModifierName()
return "modifier_custom_puck_waning_rift_tracker"
end

function custom_puck_waning_rift:GetCooldown(iLevel)

local upgrade_cooldown = 0

if self:GetCaster():HasModifier("modifier_puck_rift_cd") then 
	upgrade_cooldown = self.cd_inc[self:GetCaster():GetUpgradeStack("modifier_puck_rift_cd")]
end

return self.BaseClass.GetCooldown(self, iLevel) + upgrade_cooldown
 
end


function custom_puck_waning_rift:GetCastRange(vLocation, hTarget)
local max_range = self:GetSpecialValueFor("max_distance")
if self:GetCaster():HasModifier("modifier_puck_rift_range") then 
	max_range = max_range + self:GetCaster():GetTalentValue("modifier_puck_rift_range", "range")
end

if IsClient() then
	return max_range
end
return 99999

end




function custom_puck_waning_rift:GetManaCost(level)
return self.BaseClass.GetManaCost(self,level) + self:GetCaster():GetMaxMana()*self.legendary_mana*self:GetCaster():GetUpgradeStack("modifier_custom_puck_waning_rift_legendary")
end

function custom_puck_waning_rift:GetAOERadius()
	return self:GetSpecialValueFor("radius") + self:GetCaster():GetTalentValue("modifier_puck_rift_range", "radius")
end

function custom_puck_waning_rift:CastFilterResultTarget(target)
	return UF_SUCCESS
end




function custom_puck_waning_rift:OnSpellStart()
self:GetCaster():EmitSound("Hero_Puck.Waning_Rift")

if self:GetCaster():GetName() == "npc_dota_hero_puck" then
	self:GetCaster():EmitSound("puck_puck_ability_rift_0"..RandomInt(1, 3))
end


self.max_range = self:GetSpecialValueFor("max_distance") +  self:GetCaster():GetCastRangeBonus()
if self:GetCaster():HasModifier("modifier_puck_rift_range") then 
	self.max_range = self.max_range + self:GetCaster():GetTalentValue("modifier_puck_rift_range", "range")
	self:GetCaster():Purge(false, true, false, false, false)
	ProjectileManager:ProjectileDodge(self:GetCaster())
end


local old_pos = self:GetCaster():GetAbsOrigin()

if not self:GetCaster():IsRooted() then

	self.position = self:GetCursorPosition()
	if (self.position - self:GetCaster():GetAbsOrigin()):Length2D() >= self.max_range then 
		self.position = self:GetCaster():GetAbsOrigin() + self:GetCaster():GetForwardVector()*self.max_range
	end

	FindClearSpaceForUnit(self:GetCaster(), self.position, true)
end



if self:GetCaster():HasModifier("modifier_custom_puck_waning_rift_legendary") 
	and self:GetCaster():FindModifierByName("modifier_custom_puck_waning_rift_legendary"):GetStackCount() >= 5 then 
		self:GetCaster():EmitSound("Puck.Rift_Legendary")
		local effect = ParticleManager:CreateParticle("particles/items3_fx/blink_arcane_start.vpcf", PATTACH_WORLDORIGIN, nil)
		ParticleManager:SetParticleControl(effect, 0, old_pos)
		ParticleManager:ReleaseParticleIndex(effect)



		effect = ParticleManager:CreateParticle("particles/items3_fx/blink_arcane_end.vpcf", PATTACH_WORLDORIGIN, nil)
		ParticleManager:SetParticleControl(effect, 0, self:GetCaster():GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(effect)

end


local radius = self:GetSpecialValueFor("radius") + self:GetCaster():GetTalentValue("modifier_puck_rift_range", "radius")

local rift_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_puck/puck_waning_rift.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(rift_particle, 0, self:GetCaster():GetAbsOrigin())
ParticleManager:SetParticleControl(rift_particle, 1, Vector(radius, 0, 0))
ParticleManager:ReleaseParticleIndex(rift_particle)


self.damage = self:GetSpecialValueFor("damage")

if self:GetCaster():HasModifier("modifier_puck_rift_damage") then 
	self.damage = self.damage + self:GetCaster():GetMaxMana()*self.damage_mana[self:GetCaster():GetUpgradeStack("modifier_puck_rift_damage")]
end



self.silence = self:GetSpecialValueFor("silence_duration")

if self:GetCaster():HasModifier("modifier_puck_rift_purge") then 
	self.silence = self.silence + self.purge_duration
end


local ulti = self:GetCaster():FindAbilityByName("custom_puck_dream_coil")

if ulti then 
  ulti:LegendaryProc(self:GetCaster():GetAbsOrigin())
end


if self:GetCaster():HasModifier("modifier_custom_puck_waning_rift_legendary") then 
	self.damage = self.damage*(1 + self.legendary_damage*self:GetCaster():GetUpgradeStack("modifier_custom_puck_waning_rift_legendary")/100)
end


local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

for _, enemy in pairs(enemies) do

	local damage = self.damage

	local damageTable = {
		victim 			= enemy,
		damage 			= damage,
		damage_type		= self:GetAbilityDamageType(),
		damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
		attacker 		= self:GetCaster(),
		ability 		= self
	}

	if not enemy:IsBuilding() then 
		enemy:AddNewModifier(self:GetCaster(), self, "modifier_custom_puck_waning_rift", {duration = self.silence * (1 - enemy:GetStatusResistance())})
	end

	ApplyDamage(damageTable)
	


end



end

modifier_custom_puck_waning_rift = class({})

function modifier_custom_puck_waning_rift:GetEffectName()
	if not self:GetParent():IsCreep() then
		return "particles/generic_gameplay/generic_silenced.vpcf"
	else
		return "particles/generic_gameplay/generic_silenced_lanecreeps.vpcf"
	end
end

function modifier_custom_puck_waning_rift:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end


function modifier_custom_puck_waning_rift:CheckState()
	return {[MODIFIER_STATE_SILENCED] = true}
end



function modifier_custom_puck_waning_rift:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_TAKEDAMAGE
}
end

function modifier_custom_puck_waning_rift:OnTakeDamage(params)
if not IsServer() then return end
if not self:GetCaster():HasModifier("modifier_puck_rift_tick") then return end
if params.unit ~= self:GetParent() then return end
self.damage = self.damage + params.damage

end


function modifier_custom_puck_waning_rift:OnCreated(table)
if not IsServer() then return end

self.damage = 0

if self:GetCaster():GetQuest() == "Puck.Quest_6" and self:GetParent():IsRealHero() and not self:GetCaster():QuestCompleted() then 
	self:StartIntervalThink(0.1)
end

end

function modifier_custom_puck_waning_rift:OnIntervalThink()
if not IsServer() then return end

self:GetCaster():UpdateQuest(0.1)
end


function modifier_custom_puck_waning_rift:OnDestroy()
if not IsServer() then return end
if not self:GetParent():IsAlive() then return end


if self.damage > 0 and self:GetCaster():HasModifier("modifier_puck_rift_tick") and not self:GetParent():IsMagicImmune() then 
	local damage_number = self.damage*self:GetCaster():GetTalentValue("modifier_puck_rift_tick", "damage")/100

	
	self:GetParent():EmitSound("Puck.Rift_Damage")
	local effect = ParticleManager:CreateParticle("particles/puck_silence_damage.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:ReleaseParticleIndex(effect)

	local damage = ApplyDamage({ victim = self:GetParent(), attacker = self:GetCaster(), ability = self:GetAbility(), damage = damage_number, damage_type = DAMAGE_TYPE_MAGICAL})

	if damage then 
		local k = self:GetCaster():GetTalentValue("modifier_puck_rift_tick", "heal")/100

		if self:GetParent():IsCreep() then 
			k = k*self:GetCaster():GetTalentValue("modifier_puck_rift_tick", "heal_creeps")
		end

		self:GetCaster():GenericHeal(damage*k, self:GetAbility())


		SendOverheadEventMessage(self:GetParent(), 6, self:GetParent(), damage, nil)
	end

end

if not self:GetCaster():HasModifier("modifier_puck_rift_purge") then return end
if self:GetRemainingTime() < 0.1 then return end


local part = ParticleManager:CreateParticle("particles/econ/items/outworld_devourer/od_shards_exile/od_shards_exile_prison_end.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:ReleaseParticleIndex(part)

self:GetParent():EmitSound("Puck.Rift_Stun")
self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stunned", {duration = (1 - self:GetParent():GetStatusResistance())*self:GetAbility().purge_stun})

end


modifier_custom_waning_rift_knockback = class({})

function modifier_custom_waning_rift_knockback:IsHidden() return true end

function modifier_custom_waning_rift_knockback:OnCreated(params)
  if not IsServer() then return end
  
  self.ability        = self:GetAbility()
  self.caster         = self:GetCaster()
  self.parent         = self:GetParent()
  self:GetParent():StartGesture(ACT_DOTA_FLAIL)
  
  self.knockback_duration   = self.ability.knockback_duration

  --self.knockback_distance   = math.max(self.ability.knockback_distance - (self.caster:GetAbsOrigin() - self.parent:GetAbsOrigin()):Length2D(), 50)
  
  self.knockback_distance = self.ability.shard_radius

  self.knockback_speed    = self.ability.shard_radius / self.ability.shard_knockback
  
  self.position = GetGroundPosition(Vector(params.x, params.y, 0), nil)
  
  if self:ApplyHorizontalMotionController() == false then 
    self:Destroy()
    return
  end
end

function modifier_custom_waning_rift_knockback:UpdateHorizontalMotion( me, dt )
  if not IsServer() then return end

  local distance = (me:GetOrigin() - self.position):Normalized()
  
  me:SetOrigin( me:GetOrigin() + distance * self.knockback_speed * dt )

  GridNav:DestroyTreesAroundPoint( self.parent:GetOrigin(), self.parent:GetHullRadius(), true )
end

function modifier_custom_waning_rift_knockback:DeclareFunctions()
  local decFuncs = {
    MODIFIER_PROPERTY_OVERRIDE_ANIMATION
    }

    return decFuncs
end

function modifier_custom_waning_rift_knockback:GetOverrideAnimation()
   return ACT_DOTA_FLAIL
end


function modifier_custom_waning_rift_knockback:OnDestroy()
  if not IsServer() then return end
 self.parent:RemoveHorizontalMotionController( self )
  self:GetParent():FadeGesture(ACT_DOTA_FLAIL)
end




modifier_custom_puck_waning_rift_legendary = class({})
function modifier_custom_puck_waning_rift_legendary:IsHidden() return false end
function modifier_custom_puck_waning_rift_legendary:IsPurgable() return false end
function modifier_custom_puck_waning_rift_legendary:RemoveOnDeath() return false end
function modifier_custom_puck_waning_rift_legendary:OnCreated(table)
if not IsServer() then return end
	self:SetStackCount(0)
	self.stack = 1
	self:StartIntervalThink(self:GetAbility().legendary_interval)

	self.particle = ParticleManager:CreateParticle("particles/puck_silence_charges.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
	self:AddParticle(self.particle, false, false, -1, false, false)

	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), 'puck_charge_change',  {max = self:GetAbility().legendary_max, rage = 0})

end

function modifier_custom_puck_waning_rift_legendary:OnIntervalThink()
if not IsServer() then return end
if self:GetCaster():HasModifier("modifier_custom_puck_waning_rift_legendary_freeze") then return end

if self.stack == 1 and self:GetStackCount() == self:GetAbility().legendary_max then 
	self.stack = -1
end

if self.stack == -1 and self:GetStackCount() == 0 then 
	self.stack = 1
end

self:SetStackCount(self:GetStackCount() + self.stack)

CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), 'puck_charge_change',  {max = self:GetAbility().legendary_max, rage = self:GetStackCount()})


if self:GetStackCount() == 5 and  self.hands == nil then 
	self.hands = ParticleManager:CreateParticle("particles/generic_gameplay/rune_arcane_owner.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	self:AddParticle(self.particle, false, false, -1, false, false)
end

if self:GetStackCount() == 4 and self.hands ~= nil then 
	ParticleManager:DestroyParticle(self.hands, false)
	ParticleManager:ReleaseParticleIndex(self.hands)
	self.hands = nil
end


for i = 1,6 do 
	
	if i <= self:GetStackCount() then 
		ParticleManager:SetParticleControl(self.particle, i, Vector(1, 0, 0))	
	else 
		ParticleManager:SetParticleControl(self.particle, i, Vector(0, 0, 0))	
	end
end

end

function modifier_custom_puck_waning_rift_legendary:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOOLTIP
}

end


function modifier_custom_puck_waning_rift_legendary:OnTooltip()
return self:GetCaster():GetMaxMana()*self:GetStackCount()*self:GetAbility().legendary_mana
end





modifier_custom_puck_waning_rift_tracker = class({})
function modifier_custom_puck_waning_rift_tracker:IsHidden() return true end
function modifier_custom_puck_waning_rift_tracker:IsPurgable() return false end
function modifier_custom_puck_waning_rift_tracker:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_ABILITY_EXECUTED
}
end





function modifier_custom_puck_waning_rift_tracker:OnAbilityExecuted( params )
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_puck_rift_mana") then return end
if params.unit~=self:GetParent() then return end
if not params.ability then return end
if params.ability:IsItem() or params.ability:IsToggle() then return end

local name = params.ability:GetName()

if UnvalidAbilities[name] then return end
if name == "custom_puck_ethereal_jaunt" or name == "custom_puck_illusory_barrier" then return end

local chance = self:GetCaster():GetTalentValue("modifier_puck_rift_mana", "chance")
local random = RollPseudoRandomPercentage(chance,123,self:GetCaster())

if random then 
  local mana = self:GetCaster():GetMaxMana()*self:GetCaster():GetTalentValue("modifier_puck_rift_mana", "mana")/100
  local heal = mana
  

	local mana_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_keeper_of_the_light/keeper_chakra_magic.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	ParticleManager:SetParticleControl(mana_particle, 0, self:GetCaster():GetAbsOrigin())
	ParticleManager:SetParticleControl(mana_particle, 1, self:GetCaster():GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(mana_particle)
	self:GetCaster():EmitSound("Puck.Rift_Mana")

  self:GetCaster():GenericHeal(heal, self:GetAbility())
  self:GetCaster():GiveMana(mana)
end

end



