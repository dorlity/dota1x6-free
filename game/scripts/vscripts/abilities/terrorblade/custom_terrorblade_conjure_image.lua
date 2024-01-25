LinkLuaModifier("modifier_conjure_image_tracker", "abilities/terrorblade/custom_terrorblade_conjure_image", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_conjure_image_reduce_aura", "abilities/terrorblade/custom_terrorblade_conjure_image", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_conjure_image_legendary_aura", "abilities/terrorblade/custom_terrorblade_conjure_image", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_conjure_image_legendary_aura_damage", "abilities/terrorblade/custom_terrorblade_conjure_image", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_conjure_image_legendary_aura_damage_count", "abilities/terrorblade/custom_terrorblade_conjure_image", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_conjure_image_legendary_invun", "abilities/terrorblade/custom_terrorblade_conjure_image", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_conjure_image_legendary_invun_illusion", "abilities/terrorblade/custom_terrorblade_conjure_image", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_conjure_image_legendary_legendary_cd", "abilities/terrorblade/custom_terrorblade_conjure_image", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_conjure_image_legendary_visual", "abilities/terrorblade/custom_terrorblade_conjure_image", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_conjure_image_invun", "abilities/terrorblade/custom_terrorblade_conjure_image", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_conjure_image_illusion_mod", "abilities/terrorblade/custom_terrorblade_conjure_image", LUA_MODIFIER_MOTION_NONE)


custom_terrorblade_conjure_image = class({})

custom_terrorblade_conjure_image.cd_inc = {-2, -3, -4}

custom_terrorblade_conjure_image.outgoing_inc = {8, 12, 16}
custom_terrorblade_conjure_image.incoming_inc = {-20, -30, -40}

custom_terrorblade_conjure_image.double_chance = 20
custom_terrorblade_conjure_image.double_heal = 8
custom_terrorblade_conjure_image.double_radius = 1200

custom_terrorblade_conjure_image.union_move = {3, 4.5, 6}
custom_terrorblade_conjure_image.union_resist = {3, 4.5, 6}
custom_terrorblade_conjure_image.union_radius = 600


custom_terrorblade_conjure_image.legendary_invun = 0.12
custom_terrorblade_conjure_image.legendary_damage = -70
custom_terrorblade_conjure_image.legendary_duration = 5
custom_terrorblade_conjure_image.legendary_chance = 15
custom_terrorblade_conjure_image.legendary_incoming = 400
custom_terrorblade_conjure_image.legendary_max = 3



custom_terrorblade_conjure_image.burn_radius = 400
custom_terrorblade_conjure_image.burn_damage = {0.15, 0.25}
custom_terrorblade_conjure_image.burn_slow = {-4, -6}
custom_terrorblade_conjure_image.burn_interval = 1


function custom_terrorblade_conjure_image:GetManaCost(level)


if self:GetCaster():HasModifier("modifier_terror_meta_legendary") then 
	return 0
end

return self.BaseClass.GetManaCost(self,level)
end


function custom_terrorblade_conjure_image:Precache(context)

PrecacheResource( "particle", "particles/units/heroes/hero_terrorblade/terrorblade_sunder.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/heroes_underlord/abyssal_underlord_firestorm_wave_burn.vpcf", context )
PrecacheResource( "particle", "particles/tb_illusion_legendary.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_meepo/meepo_ransack.vpcf", context )

end



function custom_terrorblade_conjure_image:GetCooldown(iLevel)

local upgrade_cooldown = 0

if self:GetCaster():HasModifier("modifier_terror_illusion_duration") then 
	upgrade_cooldown = self.cd_inc[self:GetCaster():GetUpgradeStack("modifier_terror_illusion_duration")]
end

return self.BaseClass.GetCooldown(self, iLevel) + upgrade_cooldown
end





function custom_terrorblade_conjure_image:GetBehavior()
if self:GetCaster():HasModifier("modifier_terror_illusion_legendary") then 
	return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE
end

return DOTA_ABILITY_BEHAVIOR_NO_TARGET
end


function custom_terrorblade_conjure_image:GetIntrinsicModifierName()
if not self:GetCaster():IsRealHero() then return end
return "modifier_conjure_image_tracker"
end



function custom_terrorblade_conjure_image:SpawnIllusion(passive)
if not IsServer() then return end


self.duration = self:GetSpecialValueFor("illusion_duration")


self.outgoing = self:GetSpecialValueFor("illusion_outgoing_damage")
self.incoming = self:GetSpecialValueFor("illusion_incoming_damage")

if self:GetCaster():HasModifier("modifier_terror_illusion_incoming") then 
	self.outgoing = self.outgoing + self.outgoing_inc[self:GetCaster():GetUpgradeStack("modifier_terror_illusion_incoming")]
end

if self:GetCaster():HasModifier("modifier_terror_illusion_incoming") then 
	self.incoming = self.incoming + self.incoming_inc[self:GetCaster():GetUpgradeStack("modifier_terror_illusion_incoming")]
end




local position = 108
local scramble = false 
local count = 1

if self:GetCaster():HasModifier("modifier_terror_illusion_legendary") then 
	position = 0
	scramble = true
end

if passive and passive == 1 then 

	self.duration = self:GetCaster():GetTalentValue("modifier_terror_illusion_legendary", "duration")
	self.outgoing = self:GetCaster():GetTalentValue("modifier_terror_illusion_legendary", "damage") - 100
	self.incoming = self:GetCaster():GetTalentValue("modifier_terror_illusion_legendary", "incoming") - 100
	scramble = false
end



if self:GetCaster():HasModifier("modifier_terror_illusion_resist") then 
	local chance = self.double_chance

	local random = RollPseudoRandomPercentage(chance,41,self:GetCaster())
	if random then
		count = 2
	end

end


local illusions = CreateIllusions(self:GetCaster(), self:GetCaster(), {
	outgoing_damage = self.outgoing,
	incoming_damage	= self.incoming,
	bounty_base		= nil, 
	bounty_growth	= nil,
	outgoing_damage_structure	= nil,
	outgoing_damage_roshan		= nil,
	duration		= self.duration
}
, count, position, scramble, true)

if illusions then
	for _, illusion in pairs(illusions) do



	self:GetCaster():EmitSound("Hero_Terrorblade.ConjureImage")
	illusion.owner = self:GetCaster()	

	if not self:GetCaster():HasModifier("modifier_terror_illusion_legendary") then 

		illusion:AddNewModifier(self:GetCaster(), self, "modifier_terrorblade_conjureimage", {})
		illusion:StartGesture(ACT_DOTA_CAST_ABILITY_3_END)
	end

	if passive and passive == 1 then 

		illusion:AddNewModifier(self:GetCaster(), self, "modifier_conjure_image_illusion_mod", {})
	end


    for _,mod in pairs(self:GetCaster():FindAllModifiers()) do
      if mod.StackOnIllusion ~= nil and mod.StackOnIllusion == true then
        illusion:UpgradeIllusion(mod:GetName(), mod:GetStackCount() )
      end
    end

	end
end


end



function custom_terrorblade_conjure_image:OnSpellStart()
if not IsServer() then return end

if self:GetCaster():HasModifier("modifier_terror_illusion_legendary") then 
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_conjure_image_invun", {duration = self:GetCaster():GetTalentValue("modifier_terror_illusion_legendary", "invun")})
else
	self:SpawnIllusion()
end

end


modifier_conjure_image_tracker = class({})
function modifier_conjure_image_tracker:IsHidden() 
	return not self:GetParent():HasModifier("modifier_terror_illusion_legendary")
end

function modifier_conjure_image_tracker:IsPurgable() return false end
function modifier_conjure_image_tracker:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_TAKEDAMAGE,
	MODIFIER_EVENT_ON_ATTACK_LANDED

}
end


function modifier_conjure_image_tracker:OnAttackLanded(params)
if not IsServer() then return end
if not params.target:IsCreep() and not params.target:IsHero() then return end
if params.target:GetUnitName() == "npc_teleport" then return end

if self:GetParent() == params.attacker and self:GetParent():HasModifier("modifier_terror_illusion_legendary") and
	self:GetStackCount() < self:GetCaster():GetTalentValue("modifier_terror_illusion_legendary", "max") then 


	local random = RollPseudoRandomPercentage(self:GetCaster():GetTalentValue("modifier_terror_illusion_legendary", "chance"),1842,self:GetParent())

	if random then 
		self:GetAbility():SpawnIllusion(1)
	end
end


if not self:GetParent():HasModifier("modifier_terror_illusion_resist") then return end

local attacker = params.attacker

if (attacker:IsIllusion() and attacker.owner and attacker.owner == self:GetParent()) or self:GetParent() == attacker then 

	local all_illusions = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), params.attacker:GetAbsOrigin(), nil, self:GetAbility().double_radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false) 
		
	for _,unit in pairs(all_illusions) do
		if unit == self:GetParent() or (unit.owner and unit.owner == self:GetParent() and unit:IsIllusion()) then 
			unit:GenericHeal(self:GetAbility().double_heal, self:GetAbility(), true, "particles/units/heroes/hero_meepo/meepo_ransack.vpcf")
		end
	end


end


end



function modifier_conjure_image_tracker:OnCreated(table)
if not IsServer() then return end
if not self:GetParent():IsRealHero() then return end

self:StartIntervalThink(1)
end


function modifier_conjure_image_tracker:OnIntervalThink()
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_terror_illusion_texture") then return end

local all_illusions = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self:GetCaster():GetTalentValue("modifier_terror_illusion_texture", "radius"), DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO + DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED  , FIND_CLOSEST, false) 
	
if #all_illusions > 0 and self:GetParent():HasModifier("modifier_backdoor_knock_aura_damage") then 

	for i = 1,#all_illusions do 
		if all_illusions[i] and not all_illusions[i]:HasModifier("modifier_backdoor_knock_aura_damage") then
			table.remove(all_illusions, i)
		end
	end

end

if #all_illusions > 1 and not self:GetParent():HasModifier("modifier_conjure_image_legendary_visual") then 
	self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_conjure_image_legendary_visual", {})
end

if #all_illusions < 2 and self:GetParent():HasModifier("modifier_conjure_image_legendary_visual") then 

	self:GetParent():RemoveModifierByName("modifier_conjure_image_legendary_visual")
end


self:StartIntervalThink(0.2)
end




function modifier_conjure_image_tracker:OnTakeDamage(params)
if not IsServer() then return end
if self:GetParent():GetHealth() > 1 then return end 
if not self:GetParent():HasModifier("modifier_terror_illusion_texture") then return end
if self:GetParent() ~= params.unit then return end
if params.attacker == self:GetParent() then return end
if self:GetParent():HasModifier("modifier_death") then return end
if self:GetParent():HasModifier("modifier_up_res") and not self:GetParent():HasModifier("modifier_up_res_cd") then return end
if self:GetParent():HasModifier("modifier_terror_meta_lowhp")
and self:GetParent():HasModifier("modifier_custom_terrorblade_metamorphosis") and not self:GetParent():HasModifier("modifier_custom_terrorblade_metamorphosis_lowhp_cd") then return end
if self:GetParent():HasModifier("modifier_conjure_image_legendary_legendary_cd") then return end


local delay = self:GetCaster():GetTalentValue("modifier_terror_illusion_texture", "delay")

local all_illusions = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self:GetCaster():GetTalentValue("modifier_terror_illusion_texture", "radius"), DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO + DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED  , FIND_CLOSEST, false) 
	if #all_illusions < 1 then return end	
	for _,i in ipairs(all_illusions) do

		local barrier = true
		if self:GetParent():HasModifier("modifier_backdoor_knock_aura_damage") and not i:HasModifier("modifier_backdoor_knock_aura_damage") then 
			barrier = false
		end


		if i:IsAlive() and i:GetHealth() > 1 and barrier == true
			and i:FindModifierByName("modifier_illusion"):GetRemainingTime() > delay + 0.1 then 
			self:GetParent():SetHealth(1)

			--self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_conjure_image_legendary_legendary_cd", {duration = self:GetAbility().death_cd})
			self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_conjure_image_legendary_invun", {duration = delay, target = i:entindex()})
 			i:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_conjure_image_legendary_invun_illusion", {})

			self:GetParent():EmitSound("TB.Image_legendary") 



 			break

		end
end


end










modifier_conjure_image_reduce_aura = class({})
function modifier_conjure_image_reduce_aura:IsHidden() return false end
function modifier_conjure_image_reduce_aura:IsPurgable() return false end
function modifier_conjure_image_reduce_aura:RemoveOnDeath() return false end
function modifier_conjure_image_reduce_aura:GetTexture() return "buffs/image_reduce" end
function modifier_conjure_image_reduce_aura:OnCreated(table)
if not IsServer() then return end
self.radius = self:GetAbility().union_radius
self:StartIntervalThink(0.3)
end


function modifier_conjure_image_reduce_aura:OnIntervalThink()
if not IsServer() then return end

if not self:GetParent():IsIllusion() then 

	if not self:GetParent():IsAlive() then self:SetStackCount(0) return end


	local all_illusions = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO + DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED  , FIND_CLOSEST, false) 
	local count = 0

	for _,i in ipairs(all_illusions) do 
		if not i:HasModifier("modifier_custom_terrorblade_reflection_unit") and i ~= self:GetParent() then 

			local mod = i:FindModifierByName("modifier_conjure_image_reduce_aura") 
			if not mod then 
				mod = i:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_conjure_image_reduce_aura", {})
			end

			count = count + 1
		end
	end

	self:SetStackCount(count)



else
	if (self:GetParent():GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Length2D() > self.radius
	or not self:GetCaster():IsAlive() then self:Destroy() return end

	local mod = self:GetCaster():FindModifierByName("modifier_conjure_image_reduce_aura")
	if mod then 
		self:SetStackCount(mod:GetStackCount())
	end
end


end

function modifier_conjure_image_reduce_aura:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING
}

end

function modifier_conjure_image_reduce_aura:GetModifierMoveSpeedBonus_Percentage() return
self:GetStackCount()*self:GetAbility().union_move[self:GetCaster():GetUpgradeStack("modifier_terror_illusion_stack")]
end

function modifier_conjure_image_reduce_aura:GetModifierStatusResistanceStacking() return 
self:GetStackCount()*self:GetAbility().union_resist[self:GetCaster():GetUpgradeStack("modifier_terror_illusion_stack")]
end






modifier_conjure_image_legendary_invun = class({})
function modifier_conjure_image_legendary_invun:IsHidden() return true end
function modifier_conjure_image_legendary_invun:IsPurgable() return false end
function modifier_conjure_image_legendary_invun:CheckState() 
return 
{
	[MODIFIER_STATE_INVULNERABLE] = true , 
	[MODIFIER_STATE_STUNNED] = true,
	[MODIFIER_STATE_OUT_OF_GAME] = true
} 
end


function modifier_conjure_image_legendary_invun:OnCreated(table)
if not IsServer() then return end
self:GetParent():AddNoDraw()

self.NoDraw = true
ProjectileManager:ProjectileDodge(self:GetParent())

self.target = EntIndexToHScript(table.target)
self.origin = self.target:GetAbsOrigin()

local point_1 = self.origin + Vector(0,0,150)
local point_2 = self:GetParent():GetAbsOrigin() + Vector(0,0,150)
local sunder_particle_2 = ParticleManager:CreateParticle("particles/units/heroes/hero_terrorblade/terrorblade_sunder.vpcf", PATTACH_WORLDORIGIN, self:GetParent())
ParticleManager:SetParticleControl(sunder_particle_2, 0, point_1)
ParticleManager:SetParticleControl(sunder_particle_2, 1, point_2)
ParticleManager:SetParticleControl(sunder_particle_2, 61, Vector(1,0,0))
ParticleManager:SetParticleControl(sunder_particle_2, 60, Vector(150,150,150))
ParticleManager:ReleaseParticleIndex(sunder_particle_2)

end

function modifier_conjure_image_legendary_invun:OnDestroy()
if not IsServer() then return end
self:GetParent():RemoveNoDraw()
self.origin = self.target:GetAbsOrigin()


local face_origin = self.target:GetForwardVector()*50 + self.origin

self:GetParent():SetHealth(math.max(1,self.target:GetHealth()*self:GetCaster():GetTalentValue("modifier_terror_illusion_texture", "health")/100))
	
for _,mod in ipairs(self.target:FindAllModifiers()) do 
	if mod and not mod:IsNull() then 
  	 mod:Destroy()
  end 
end

if self.target and not self.target:IsNull() then 
	self.target:ForceKill(false)
end 

self:GetParent():SetOrigin(self.origin)
FindClearSpaceForUnit( self:GetParent(), self.origin, true )
if IsServer() then

   local angel = face_origin - self:GetParent():GetAbsOrigin()
   angel.z = 0.0
   angel = angel:Normalized()

   self:GetParent():SetForwardVector(angel)
   self:GetParent():FaceTowards(face_origin)
end


end



function modifier_conjure_image_legendary_invun:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MIN_HEALTH
}
end
function modifier_conjure_image_legendary_invun:GetMinHealth()
if not self:GetParent():HasModifier("modifier_death") then 
	return 1
end

end


modifier_conjure_image_legendary_invun_illusion = class({})
function modifier_conjure_image_legendary_invun_illusion:IsHidden() return true  end
function modifier_conjure_image_legendary_invun_illusion:IsPurgable() return false end
function modifier_conjure_image_legendary_invun_illusion:CheckState()
return
{
	[MODIFIER_STATE_INVULNERABLE] = true
}
end


modifier_conjure_image_legendary_aura = class({})

function modifier_conjure_image_legendary_aura:IsHidden() return true end
function modifier_conjure_image_legendary_aura:IsPurgable() return false end
function modifier_conjure_image_legendary_aura:IsDebuff() return false end



function modifier_conjure_image_legendary_aura:GetAuraRadius()
	return self:GetAbility().burn_radius
end

function modifier_conjure_image_legendary_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_conjure_image_legendary_aura:GetAuraSearchType() 
	return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end


function modifier_conjure_image_legendary_aura:GetModifierAura()
	return "modifier_conjure_image_legendary_aura_damage"
end

function modifier_conjure_image_legendary_aura:IsAura()
	return true
end


modifier_conjure_image_legendary_aura_damage = class({})
function modifier_conjure_image_legendary_aura_damage:IsHidden() return true end
function modifier_conjure_image_legendary_aura_damage:IsPurgable() return false end
function modifier_conjure_image_legendary_aura_damage:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_conjure_image_legendary_aura_damage:OnCreated(table)
if not IsServer() then return end
self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_conjure_image_legendary_aura_damage_count", {})

end

function modifier_conjure_image_legendary_aura_damage:OnDestroy()
if not IsServer() then return end
local mod = self:GetParent():FindModifierByName("modifier_conjure_image_legendary_aura_damage_count")
if mod then 
	mod:DecrementStackCount()
	if mod:GetStackCount() < 1 then 
		mod:Destroy()
	end
end

end


modifier_conjure_image_legendary_aura_damage_count = class({})
function modifier_conjure_image_legendary_aura_damage_count:IsHidden() return false end
function modifier_conjure_image_legendary_aura_damage_count:IsPurgable() return false end
function modifier_conjure_image_legendary_aura_damage_count:GetTexture() return "buffs/illusion_burn" end

function modifier_conjure_image_legendary_aura_damage_count:OnCreated(table)

self.caster = self:GetCaster()
if self.caster.owner then 
	self.caster = self.caster.owner
end

self.slow = self:GetAbility().burn_slow[self.caster:GetUpgradeStack("modifier_terror_illusion_double")]

if not IsServer() then return end


self.damage = self:GetAbility().burn_interval*self:GetAbility().burn_damage[self.caster:GetUpgradeStack("modifier_terror_illusion_double")]*self.caster:GetAgility()


self:SetStackCount(1)
self:StartIntervalThink(self:GetAbility().burn_interval)

end

function modifier_conjure_image_legendary_aura_damage_count:OnIntervalThink()
if not IsServer() then return end


ApplyDamage({victim = self:GetParent(), attacker = self.caster, ability = self:GetAbility(), damage = self:GetStackCount()*self.damage, damage_type = DAMAGE_TYPE_MAGICAL})
end



function modifier_conjure_image_legendary_aura_damage_count:OnRefresh(table)
if not IsServer() then return end
self:IncrementStackCount()
end

function modifier_conjure_image_legendary_aura_damage_count:GetEffectName()
	return "particles/units/heroes/heroes_underlord/abyssal_underlord_firestorm_wave_burn.vpcf"
end

function modifier_conjure_image_legendary_aura_damage_count:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end




function modifier_conjure_image_legendary_aura_damage_count:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end



function modifier_conjure_image_legendary_aura_damage_count:GetModifierMoveSpeedBonus_Percentage()
return self.slow*self:GetStackCount()
end


modifier_conjure_image_legendary_legendary_cd = class({})
function modifier_conjure_image_legendary_legendary_cd:IsHidden() return false end
function modifier_conjure_image_legendary_legendary_cd:IsPurgable() return false end
function modifier_conjure_image_legendary_legendary_cd:RemoveOnDeath() return false end
function modifier_conjure_image_legendary_legendary_cd:IsDebuff() return true end




modifier_conjure_image_legendary_visual = class({})
function modifier_conjure_image_legendary_visual:IsHidden() return true end
function modifier_conjure_image_legendary_visual:IsPurgable() return false end
function modifier_conjure_image_legendary_visual:OnCreated(table)
if not IsServer() then return end

  self.effect = ParticleManager:CreateParticleForTeam("particles/tb_illusion_legendary.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent(), self:GetParent():GetTeamNumber())
  ParticleManager:SetParticleControlEnt(self.effect, 0, self:GetParent(), PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
  ParticleManager:SetParticleControlEnt(self.effect, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
  ParticleManager:SetParticleControlEnt(self.effect, 5, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
  self:AddParticle(self.effect, false, false, -1, true, false)
end









modifier_conjure_image_invun = class({})

function modifier_conjure_image_invun:IsHidden()     return true end
function modifier_conjure_image_invun:IsPurgable()   return false end

function modifier_conjure_image_invun:GetEffectName()
    return "particles/items2_fx/manta_phase.vpcf"
end

function modifier_conjure_image_invun:OnDestroy()
if not IsServer() or not self:GetParent():IsAlive() or not self:GetAbility() then return end

if self:GetParent() == self:GetCaster() then
   -- self:GetParent():Stop()
end

self:GetAbility():SpawnIllusion()

end

function modifier_conjure_image_invun:CheckState()
return {
  [MODIFIER_STATE_INVULNERABLE]       = true,
  [MODIFIER_STATE_NO_HEALTH_BAR]      = true,
  [MODIFIER_STATE_STUNNED]            = true,
  [MODIFIER_STATE_OUT_OF_GAME]        = true,
  
  [MODIFIER_STATE_NO_UNIT_COLLISION]  = true
}
end



modifier_conjure_image_illusion_mod = class({})
function modifier_conjure_image_illusion_mod:IsHidden() return true end
function modifier_conjure_image_illusion_mod:IsPurgable() return false end
function modifier_conjure_image_illusion_mod:OnCreated(table)
if not IsServer() then return end

self.mod = self:GetCaster():FindModifierByName("modifier_conjure_image_tracker")
if not self.mod then 
	self:GetParent():Kill(nil, nil)
	self:Destroy()
	return
end

self.mod:IncrementStackCount()
end

function modifier_conjure_image_illusion_mod:OnDestroy()
if not IsServer() then return end
if not self.mod then return end

self.mod:DecrementStackCount()

end