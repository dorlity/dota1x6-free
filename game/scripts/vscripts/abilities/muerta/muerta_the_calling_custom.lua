LinkLuaModifier( "modifier_muerta_the_calling_custom", "abilities/muerta/muerta_the_calling_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_muerta_the_calling_custom_thinker", "abilities/muerta/muerta_the_calling_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_muerta_the_calling_custom_debuff", "abilities/muerta/muerta_the_calling_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_muerta_the_calling_custom_damage", "abilities/muerta/muerta_the_calling_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_muerta_the_calling_caster", "abilities/muerta/muerta_the_calling_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_muerta_the_calling_caster_damage_cd", "abilities/muerta/muerta_the_calling_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_muerta_the_calling_custom_root", "abilities/muerta/muerta_the_calling_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_muerta_the_calling_custom_root_cd", "abilities/muerta/muerta_the_calling_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_muerta_the_calling_custom_scepter", "abilities/muerta/muerta_the_calling_custom", LUA_MODIFIER_MOTION_NONE )

muerta_the_calling_custom = class({})
muerta_the_calling_custom_target = class({})



muerta_the_calling_custom.target_damage = 1.5
muerta_the_calling_custom.target_knock = 180
muerta_the_calling_custom.target_aoe = 250
muerta_the_calling_custom_target.target_aoe = 250
muerta_the_calling_custom_target.target_cd = {6, 4}

muerta_the_calling_custom.stack_slow = {-2, -3, -4}
muerta_the_calling_custom.stack_magic = {-2, -3, -4}
muerta_the_calling_custom.stack_max = 5
muerta_the_calling_custom.stack_interval = 1

muerta_the_calling_custom.self_damage = {-8, -12, -16}
muerta_the_calling_custom.self_status = {10, 15, 20}

muerta_the_calling_custom.damage_inc = {0.02, 0.03, 0.04}

muerta_the_calling_custom.root_timer = 4
muerta_the_calling_custom.root_duration = 1.5

muerta_the_calling_custom.heal_reduce = -30
muerta_the_calling_custom.heal_self = 0.3
muerta_the_calling_custom.heal_self_creep = 0.33




function muerta_the_calling_custom:Precache(context)

    
PrecacheResource( "particle", "particles/muerta/calling_aoe.vpcf", context )
PrecacheResource( "particle", "particles/muerta/muerta_calling_target.vpcf", context )
PrecacheResource( "particle", "particles/muerta/calling_hero.vpcf", context )
PrecacheResource( "particle", "particles/muerta_calling_caster_start_2.vpcf", context )
PrecacheResource( "particle", "particles/muerta/muerta_calling_caster_end.vpcf", context )
PrecacheResource( "particle", "particles/muerta/muerta_calling_caster_start.vpcf", context )
PrecacheResource( "particle", "particles/muerta/calling_root.vpcf", context )

end



function muerta_the_calling_custom:GetBehavior()
if self:GetCaster():HasScepter() then 
	return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AOE + DOTA_ABILITY_BEHAVIOR_AUTOCAST
else 
	return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AOE
end

end 


function muerta_the_calling_custom_target:GetCooldown(iLevel)
if self:GetCaster():HasModifier("modifier_muerta_calling_4") then 
	return self.target_cd[self:GetCaster():GetUpgradeStack("modifier_muerta_calling_4")]
end

return 1
end

function muerta_the_calling_custom:GetCastRange(location, target)

local bonus = 0 

if self:GetCaster():HasScepter() then 
	bonus = self:GetSpecialValueFor("scepter_range")
end 

return self.BaseClass.GetCastRange(self, location, target) + bonus
end



function muerta_the_calling_custom:GetAOERadius()
if self:GetCaster():HasModifier("modifier_muerta_calling_7") then 
	return self:GetCaster():GetTalentValue("modifier_muerta_calling_7", "big_radius")
end

return
end



function muerta_the_calling_custom:GetCooldown(iLevel)

local upgrade_cooldown = 0

if self:GetCaster():HasScepter() then  
  upgrade_cooldown = self:GetSpecialValueFor("scepter_cd")
end 

 return self.BaseClass.GetCooldown(self, iLevel) + upgrade_cooldown

end




function muerta_the_calling_custom:OnSpellStart()
if not IsServer() then return end


local point = self:GetCursorPosition()
local duration = self:GetSpecialValueFor("duration")

local radius = self:GetSpecialValueFor( "radius" )

if self:GetCaster():HasScepter() then 
	if self:GetAutoCastState() == false then 

		local old_pos = self:GetCaster():GetAbsOrigin() 

		self:GetCaster():EmitSound("Muerta.Calling_scepter_start")

		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_muerta_the_calling_custom_scepter", {duration = 0.1})

		local effect = ParticleManager:CreateParticle("particles/econ/events/ti7/blink_dagger_start_ti7.vpcf", PATTACH_WORLDORIGIN, nil)
		ParticleManager:SetParticleControl(effect, 0, old_pos)

		ProjectileManager:ProjectileDodge( self:GetCaster() )

		self:GetCaster():SetAbsOrigin(point)
		FindClearSpaceForUnit(self:GetCaster(), point, false)


	end 
end


local thinker = CreateModifierThinker( self:GetCaster(), self, "modifier_muerta_the_calling_custom", { duration = duration }, point, self:GetCaster():GetTeamNumber(), false )

if self:GetCaster():HasModifier("modifier_muerta_calling_7") then 
	radius = self:GetCaster():GetTalentValue("modifier_muerta_calling_7", "big_radius")
end




EmitSoundOnLocationWithCaster(point, "Hero_Muerta.Revenants.Cast", self:GetCaster())
end


function muerta_the_calling_custom:ProcRoot(target)
if not IsServer() then return end
if not self:GetCaster():HasModifier("modifier_muerta_calling_5") then return end
if target:GetTeamNumber() == self:GetCaster():GetTeamNumber() then return end

target:AddNewModifier(self:GetCaster(), self, "modifier_muerta_the_calling_custom_root", {duration = self.root_duration*(1 - target:GetStatusResistance())})
target:AddNewModifier(self:GetCaster(), self, "modifier_muerta_the_calling_custom_root_cd", {duration = self.root_timer - FrameTime()*2})


end



function muerta_the_calling_custom:DealDamage(target, k)
if not IsServer() then return end

local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_muerta/muerta_calling_impact.vpcf", PATTACH_CUSTOMORIGIN, target)
ParticleManager:SetParticleControlEnt( particle, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true )
ParticleManager:SetParticleControlEnt( particle, 1, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true )
ParticleManager:ReleaseParticleIndex(particle)

local damage = self:GetSpecialValueFor("damage")


bonus = 0

if self:GetCaster():HasModifier("modifier_muerta_calling_1") then 
	bonus = self.damage_inc[self:GetCaster():GetUpgradeStack("modifier_muerta_calling_1")]*target:GetMaxHealth()
end

if target:IsCreep() then 
	bonus = bonus*0.33
end


damage = damage + bonus

if k then 
	damage = damage*k
end

ApplyDamage({victim = target, attacker = self:GetCaster(), damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self})

local duration = self:GetSpecialValueFor("silence_duration")

if target:IsCreep() then 
	duration = self:GetSpecialValueFor("silence_creeps")
end

target:AddNewModifier(self:GetCaster(), self, "modifier_generic_silence", {duration = duration * (1-target:GetStatusResistance())})

local sound_cast = "Hero_Muerta.Revenants.Damage.Hero"
if not target:IsHero() then
	sound_cast = "Hero_Muerta.Revenants.Damage.Creep"
end

target:EmitSound(sound_cast)
target:EmitSound("Hero_Muerta.Revenants.Silence")

end







modifier_muerta_the_calling_custom = class({})

function modifier_muerta_the_calling_custom:IsHidden() return true end
function modifier_muerta_the_calling_custom:IsPurgable() return false end

function modifier_muerta_the_calling_custom:OnCreated()
if not IsServer() then return end


if self:GetCaster():HasModifier("modifier_muerta_calling_4") then 

	local ability = self:GetAbility()
	local ability_target = self:GetCaster():FindAbilityByName("muerta_the_calling_custom_target")


	if ability_target then 

		if ability_target:IsHidden() then 
			self:GetCaster():SwapAbilities(ability:GetName(), ability_target:GetName(), false, true)
		end

	end
end




self:GetParent():EmitSound("Hero_Muerta.Revenants")
self:GetParent():EmitSound("Hero_Muerta.Revenants.Layer")


self.hit_radius = self:GetAbility():GetSpecialValueFor( "hit_radius" )
self.radius = self:GetAbility():GetSpecialValueFor( "radius" )

self.aura_radius = self.radius

self.radius_2 = 0

if self:GetCaster():HasModifier("modifier_muerta_calling_7") then 

	self.radius_2 = self:GetCaster():GetTalentValue("modifier_muerta_calling_7", "big_radius")
	self.radius = self:GetCaster():GetTalentValue("modifier_muerta_calling_7", "small_radius")
	self.num_revenants_2 = self:GetCaster():GetTalentValue("modifier_muerta_calling_7", "count")
	self.aura_radius = self.radius_2

	local particle = ParticleManager:CreateParticle("particles/muerta/calling_aoe.vpcf", PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(particle, 0, self:GetParent():GetAbsOrigin())
	ParticleManager:SetParticleControl(particle, 1, Vector(self.radius_2, self.radius_2, self.radius_2))
	ParticleManager:SetParticleControl(particle, 2, Vector(self:GetDuration(), self:GetDuration(), self:GetDuration()))
	self:AddParticle(particle, false, false, -1, false, false)
else 

	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_muerta/muerta_calling_aoe.vpcf", PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(particle, 0, self:GetParent():GetAbsOrigin())
	ParticleManager:SetParticleControl(particle, 1, Vector(self.radius, self.radius, self.radius))
	ParticleManager:SetParticleControl(particle, 2, Vector(self:GetDuration(), self:GetDuration(), self:GetDuration()))
	self:AddParticle(particle, false, false, -1, false, false)
end



self.wisps = {}

self.num_revenants = 4


for i = 1,self.num_revenants do

	local origin = self:GetParent():GetAbsOrigin()
	local angel = (math.pi/2 + 2*math.pi/self.num_revenants * i)
	local abs = GetGroundPosition(origin + Vector( math.cos( angel), math.sin( angel ), 0 ) * (self.radius - self.hit_radius), nil)
	abs.z = abs.z + 100

	self.wisps[i] = CreateUnitByName( "npc_dota_companion", abs, true, self:GetCaster(), self:GetCaster():GetOwner(), self:GetCaster():GetTeamNumber())
	

	self.wisps[i]:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_muerta_the_calling_custom_thinker", {speed_k = 1, x = origin.x, y = origin.y, z = origin.z, radius = self.radius, angel = angel})

end

if not self:GetCaster():HasModifier("modifier_muerta_calling_7") then return end


local number = #self.wisps


local count = 0

for i =  number + 1,number + self.num_revenants_2 do

	count = count + 1

	local origin = self:GetParent():GetAbsOrigin()
	local angel = (math.pi/2 + 2*math.pi/self.num_revenants_2 * count)
	local abs = GetGroundPosition(origin + Vector( math.cos( angel), math.sin( angel ), 0 ) * (self.radius_2 - self.hit_radius), nil)
	abs.z = abs.z + 100

	self.wisps[i] = CreateUnitByName( "npc_dota_companion", abs, true, self:GetCaster(), self:GetCaster():GetOwner(), self:GetCaster():GetTeamNumber())
	
	self.wisps[i]:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_muerta_the_calling_custom_thinker", {speed_k = -1, radius = self.radius_2, x = origin.x, y = origin.y, z = origin.z, angel = angel})

end


end








function modifier_muerta_the_calling_custom:OnDestroy()
if not IsServer() then return end


if self:GetCaster():HasModifier("modifier_muerta_calling_4") then 

	local ability = self:GetAbility()
	local ability_target = self:GetCaster():FindAbilityByName("muerta_the_calling_custom_target")


	if ability then 

		if ability:IsHidden() then 
			self:GetCaster():SwapAbilities(ability:GetName(), ability_target:GetName(), true, false)
		end

	end
end

self:GetParent():StopSound("Hero_Muerta.Revenants")



for i = 1,#self.wisps do 
	if self.wisps[i] and not self.wisps[i]:IsNull() then 
		UTIL_Remove(self.wisps[i])
	end
end
 

end



function modifier_muerta_the_calling_custom:IsAura()
    return true
end

function modifier_muerta_the_calling_custom:GetModifierAura()
    return "modifier_muerta_the_calling_custom_debuff"
end

function modifier_muerta_the_calling_custom:GetAuraRadius()
    return self.aura_radius
end

function modifier_muerta_the_calling_custom:GetAuraDuration()
    return 0
end

function modifier_muerta_the_calling_custom:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_BOTH
end

function modifier_muerta_the_calling_custom:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_muerta_the_calling_custom:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD
end


function modifier_muerta_the_calling_custom:GetAuraEntityReject(hEntity)

if self:GetParent():GetTeamNumber() == hEntity:GetTeamNumber() and self:GetCaster() ~= hEntity then 
	return true
end

if (hEntity:IsInvulnerable() or hEntity:IsOutOfGame()) and self:GetCaster() ~= hEntity then 
	return true
end


end





modifier_muerta_the_calling_custom_thinker = class({})

function modifier_muerta_the_calling_custom_thinker:IsHidden() return true end
function modifier_muerta_the_calling_custom_thinker:IsPurgable() return false end
function modifier_muerta_the_calling_custom_thinker:RemoveOnDeath() return false end

function modifier_muerta_the_calling_custom_thinker:OnCreated(table)
if not IsServer() then return end

self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_muerta/muerta_calling.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControlEnt( self.particle, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetAbsOrigin(), true )
ParticleManager:SetParticleControl(self.particle, 1, Vector(120, 120, 120))
self:AddParticle(self.particle, false, false, -1, false, false)

self:GetParent():SetDayTimeVisionRange(400)
self:GetParent():SetNightTimeVisionRange(400)

self.radius = table.radius
self.speed_k = table.speed_k

self.hit_radius = self:GetAbility():GetSpecialValueFor( "hit_radius" )

local ability = self:GetAbility()
self.ability =  self:GetAbility()
self.caster = self:GetCaster()
self.target_point = nil
self.damage_dealt = false

self.center = Vector(table.x, table.y, table.z)


self.distance = self.radius - self.hit_radius
self.current_angle = table.angel

self.accel = ability:GetSpecialValueFor( "acceleration" )
self.init_speed = ability:GetSpecialValueFor( "speed_initial" )
self.max_speed = ability:GetSpecialValueFor( "speed_max" )
self.direction = ability:GetSpecialValueFor( "rotation_direction" )

self.damage = ability:GetSpecialValueFor( "damage" )
self.hit_radius = ability:GetSpecialValueFor( "hit_radius" )
self.silence_duration = ability:GetSpecialValueFor( "silence_duration" )

self.current_speed = self.init_speed



self.dt = 0.01
self:StartIntervalThink(self.dt)

end







function modifier_muerta_the_calling_custom_thinker:OnIntervalThink()
if not IsServer() then return end
if self:GetStackCount() == 1 then 

	if not self.target_speed or not self.target_x or not self.target_y or not self.target_z then 
		return
	end

	if not self.target_point then 

    	self.pfx = ParticleManager:CreateParticle("particles/items_fx/force_staff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(self.pfx, false, false, -1, false, false)

    	--self.pfx2 = ParticleManager:CreateParticle("particles/muerta/muerta_gun_active.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		--self:AddParticle(self.pfx2, false, false, -1, false, false)

		self.target_point = Vector(self.target_x, self.target_y, self.target_z + 100)
		self.target_distance = (self.target_point - self:GetParent():GetAbsOrigin()):Length2D()

	end

	if (self.target_point - self:GetParent():GetAbsOrigin()):Length2D() <= 10 and self.damage_dealt == false then 

		self.damage_dealt = true

		self:GetParent():EmitSound("Muerta.Calling_target_end")
		self:GetParent():EmitSound("Hero_Muerta.Revenants.Damage.Hero")

		local particle_cast = "particles/muerta/muerta_calling_target.vpcf"

		local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN,  nil)
		ParticleManager:SetParticleControl( effect_cast, 0, GetGroundPosition(self:GetParent():GetAbsOrigin(), nil) )
		ParticleManager:SetParticleControl( effect_cast, 1, Vector( 125 , 0, 0 ) )
		ParticleManager:ReleaseParticleIndex( effect_cast )


		local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetParent():GetOrigin(), nil, self:GetAbility().target_aoe, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, 0, 0, false )

		for _,unit in pairs(units) do 

			local dir = (unit:GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Normalized()
			local point = self:GetParent():GetAbsOrigin() + dir*self:GetAbility().target_knock

			local distance = (point - unit:GetAbsOrigin()):Length2D()

			distance = math.max(self:GetAbility().target_knock, distance)
			point = point + dir*distance

			unit:AddNewModifier( self:GetCaster(),  self:GetAbility(),  "modifier_generic_arc",  
			{
			  target_x = point.x,
			  target_y = point.y,
			  distance = distance,
			  duration = 0.2,
			  height = 50,
			  fix_end = false,
			  isStun = false,
			  activity = ACT_DOTA_FLAIL,
			})

			self:GetAbility():DealDamage(unit, self:GetAbility().target_damage)
		end


		self:Destroy()
		UTIL_Remove(self:GetParent())
		return
	end

	self.target_angel = (self.target_point - self:GetParent():GetAbsOrigin()):Normalized()

	local pos = self:GetParent():GetAbsOrigin()

    local pos_p = self.target_angel * self.target_speed * self.dt
    local next_pos = pos + pos_p

    --next_pos.z = next_pos.z + 100

    self:GetParent():SetAbsOrigin(next_pos)

else 

	self.current_speed = math.min( self.current_speed + self.accel * self.dt, self.max_speed )

	if self:GetCaster():HasModifier("modifier_muerta_the_calling_caster") and self:GetCaster():HasModifier("modifier_muerta_the_calling_custom_debuff") then 
		self.current_speed = self.current_speed*(self:GetCaster():GetTalentValue("modifier_muerta_calling_7", "speed")/100 + 1)
	end

	self.current_angle = self.current_angle + self.current_speed * self.dt * self.speed_k
	if self.current_angle > 2*math.pi then
		self.current_angle = self.current_angle - 2*math.pi
	end

	local position = self:GetPosition()

	local caster = self.ability:GetCaster()


	self:GetParent():SetAbsOrigin(position)
end

end


function modifier_muerta_the_calling_custom_thinker:GetPosition()

local abs = GetGroundPosition(self.center + Vector( math.cos( self.current_angle ), math.sin( self.current_angle ), 0 ) * self.distance, nil)
abs.z = abs.z + 100

	return abs
end





function modifier_muerta_the_calling_custom_thinker:CheckState()
    return 
    {
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_NOT_ON_MINIMAP] = true,
        [MODIFIER_STATE_STUNNED] = true,
        [MODIFIER_STATE_UNSELECTABLE] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
    }
end

function modifier_muerta_the_calling_custom_thinker:OnDestroy()
	if not IsServer() then return end
end

function modifier_muerta_the_calling_custom_thinker:IsAura()
if self:GetStackCount() == 1 then return end
    return true
end

function modifier_muerta_the_calling_custom_thinker:GetModifierAura()
    return "modifier_muerta_the_calling_custom_damage"
end

function modifier_muerta_the_calling_custom_thinker:GetAuraRadius()
    return self.hit_radius
end

function modifier_muerta_the_calling_custom_thinker:GetAuraDuration()
    return 0
end

function modifier_muerta_the_calling_custom_thinker:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_muerta_the_calling_custom_thinker:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end




modifier_muerta_the_calling_custom_damage = class({})

function modifier_muerta_the_calling_custom_damage:IsHidden() return true end
function modifier_muerta_the_calling_custom_damage:OnCreated()
if not IsServer() then return end
self:GetAbility():DealDamage(self:GetParent())

end





modifier_muerta_the_calling_custom_debuff = class({})

function modifier_muerta_the_calling_custom_debuff:IsHidden() return self:GetParent():GetTeamNumber() == self:GetCaster():GetTeamNumber()
end
function modifier_muerta_the_calling_custom_debuff:IsPurgable() return false end

function modifier_muerta_the_calling_custom_debuff:GetEffectName()
if  self:GetParent():GetTeamNumber() == self:GetCaster():GetTeamNumber() then return end
    return "particles/units/heroes/hero_muerta/muerta_calling_debuff_slow.vpcf"
end

function modifier_muerta_the_calling_custom_debuff:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end



function modifier_muerta_the_calling_custom_debuff:OnCreated(table)
if not IsServer() then return end

self:SetStackCount(0)

if self:GetParent() == self:GetCaster() and self:GetCaster():HasModifier("modifier_muerta_calling_6") then 

	self.particle2 = ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_purifyingflames.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	self:AddParticle(self.particle2, false, false, -1, false, false)
end

if self:GetCaster():HasModifier("modifier_muerta_calling_3") and self:GetCaster() == self:GetParent() then 


	--self.particle = ParticleManager:CreateParticle("particles/muerta/calling_self.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
	--self:AddParticle(self.particle, false, false, -1, false, false)
end

if not self:GetParent():HasModifier("modifier_muerta_the_calling_custom_root_cd") then 
	self:GetAbility():ProcRoot(self:GetParent())
end

self.count = 0
self.interval = 0.1

self:StartIntervalThink(self.interval)
end




function modifier_muerta_the_calling_custom_debuff:OnIntervalThink()
if not IsServer() then return end

self.count = self.count + self.interval

if self:GetCaster():GetQuest() == "Muerta.Quest_6" and self:GetCaster():QuestCompleted() == false and self:GetParent():IsRealHero() and 
	self:GetParent():GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then 

	self:GetCaster():UpdateQuest(self.interval)
end

if self.count < 1 then return end

self.count = 0


local ult = self:GetParent():FindAbilityByName("muerta_pierce_the_veil_custom")
if self:GetParent() == self:GetCaster() and ult and ult:GetLevel() > 0 and self:GetParent():HasModifier("modifier_muerta_veil_7") then 
	--ult:LegendaryProc(2)
end


if not self:GetParent():HasModifier("modifier_muerta_the_calling_custom_root_cd") then 
	self:GetAbility():ProcRoot(self:GetParent())
end

if self:GetCaster():HasModifier("modifier_muerta_calling_2") and 
	self:GetCaster():GetTeamNumber() ~= self:GetParent():GetTeamNumber() and 
	self:GetStackCount() < self:GetAbility().stack_max then

	self:IncrementStackCount()
end

end


function modifier_muerta_the_calling_custom_debuff:DeclareFunctions()
	return 
	{
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
		MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
	}
end


function modifier_muerta_the_calling_custom_debuff:GetModifierIncomingDamage_Percentage()
if not self:GetCaster():HasModifier("modifier_muerta_calling_3") or self:GetCaster() ~= self:GetParent() then return end

return self:GetAbility().self_damage[self:GetCaster():GetUpgradeStack("modifier_muerta_calling_3")]
end


function modifier_muerta_the_calling_custom_debuff:GetModifierStatusResistanceStacking() 
if not self:GetCaster():HasModifier("modifier_muerta_calling_3") or self:GetCaster() ~= self:GetParent() then return end

return self:GetAbility().self_status[self:GetCaster():GetUpgradeStack("modifier_muerta_calling_3")]
end




function modifier_muerta_the_calling_custom_debuff:OnTakeDamage(params)
if not IsServer() then return end
if not self:GetCaster():HasModifier("modifier_muerta_calling_6") or self:GetCaster() ~= self:GetParent() then return end
if self:GetParent() ~= params.attacker then return end
if self:GetParent() == params.unit  then return end
if not params.unit:IsHero() and not params.unit:IsCreep() then return end
if bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then return end
if params.unit:IsIllusion() then return end

local heal = self:GetAbility().heal_self*params.damage 

if params.unit:IsCreep() then 
	heal = heal*self:GetAbility().heal_self_creep
end

self:GetParent():GenericHeal(heal, self:GetAbility(), true)

end



function modifier_muerta_the_calling_custom_debuff:GetModifierMoveSpeedBonus_Percentage()
if self:GetParent():GetTeamNumber() == self:GetCaster():GetTeamNumber() then return end

local bonus = 0
if self:GetCaster():HasModifier("modifier_muerta_calling_2") then 
	bonus = self:GetStackCount()*self:GetAbility().stack_slow[self:GetCaster():GetUpgradeStack("modifier_muerta_calling_2")]
end

	return self:GetAbility():GetSpecialValueFor("aura_movespeed_slow") + bonus
end



function modifier_muerta_the_calling_custom_debuff:GetModifierMagicalResistanceBonus()
if self:GetParent():GetTeamNumber() == self:GetCaster():GetTeamNumber() then return end

local bonus = 0
if self:GetCaster():HasModifier("modifier_muerta_calling_2") then 
	bonus = self:GetStackCount()*self:GetAbility().stack_magic[self:GetCaster():GetUpgradeStack("modifier_muerta_calling_2")]
end

	return bonus
end





function modifier_muerta_the_calling_custom_debuff:GetModifierAttackSpeedBonus_Constant()
if self:GetParent():GetTeamNumber() == self:GetCaster():GetTeamNumber() then return end
	return self:GetAbility():GetSpecialValueFor("aura_attackspeed_slow")
end


function modifier_muerta_the_calling_custom_debuff:GetModifierLifestealRegenAmplify_Percentage() 
if self:GetParent():GetTeamNumber() ~= self:GetCaster():GetTeamNumber() and self:GetCaster():HasModifier("modifier_muerta_calling_6") then 
  return self:GetAbility().heal_reduce
end

end
function modifier_muerta_the_calling_custom_debuff:GetModifierHealAmplify_PercentageTarget()
if self:GetParent():GetTeamNumber() ~= self:GetCaster():GetTeamNumber() and self:GetCaster():HasModifier("modifier_muerta_calling_6") then 
  return self:GetAbility().heal_reduce
end

end

function modifier_muerta_the_calling_custom_debuff:GetModifierHPRegenAmplify_Percentage() 
if self:GetParent():GetTeamNumber() ~= self:GetCaster():GetTeamNumber() and self:GetCaster():HasModifier("modifier_muerta_calling_6") then 
  return self:GetAbility().heal_reduce
end

end



function modifier_muerta_the_calling_custom_debuff:CheckState()
if self:GetCaster() ~= self:GetParent() then return end 
if not self:GetCaster():HasModifier("modifier_muerta_calling_6") then return end 
return
{
	[MODIFIER_STATE_UNSLOWABLE] = true
}

end 









modifier_muerta_the_calling_caster = class({})

function modifier_muerta_the_calling_caster:IsHidden() return false end
function modifier_muerta_the_calling_caster:IsPurgable() return false end
function modifier_muerta_the_calling_caster:GetTexture() return "buffs/calling_legendary" end

function modifier_muerta_the_calling_caster:OnCreated(table)
if not IsServer() then return end

self:GetCaster():EmitSound("Muerta.Calling_caster_start")


for i = 0,self:GetParent():GetAbilityCount() do
	local a = self:GetParent():GetAbilityByIndex(i)

	if not a or a:GetName() == "ability_capture" then break end

	if a:GetName() ~= "muerta_the_calling_custom" and a:GetName() ~= "muerta_the_calling_custom_legendary" and a:GetName() ~= "muerta_the_calling_custom_target" then 
		a:SetActivated(false)
	end		

end


self.damage_aoe = self:GetAbility():GetSpecialValueFor("hit_radius")

self:GetCaster():StartGesture(ACT_DOTA_SPAWN)
self:GetCaster():SetModelScale(1.5)

self.particle = ParticleManager:CreateParticle("particles/muerta/calling_hero.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControlEnt( self.particle, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetAbsOrigin(), true )
ParticleManager:SetParticleControl(self.particle, 1, Vector(120, 120, 120))
self:AddParticle(self.particle, false, false, -1, false, false)


local particle = ParticleManager:CreateParticle( "particles/muerta_calling_caster_start_2.vpcf", PATTACH_WORLDORIGIN, nil )
ParticleManager:SetParticleControl(particle, 0, self:GetParent():GetAbsOrigin())
ParticleManager:ReleaseParticleIndex( particle )

self:StartIntervalThink(0.1)
end

function modifier_muerta_the_calling_caster:OnIntervalThink()
if not IsServer() then return end


local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetParent():GetOrigin(), nil, self.damage_aoe, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )

for _,enemy in pairs(enemies) do 
	if not enemy:HasModifier("modifier_muerta_the_calling_caster_damage_cd") then 
		enemy:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_muerta_the_calling_caster_damage_cd", {duration = self:GetCaster():GetTalentValue("modifier_muerta_calling_7", "interval")})

		self:GetAbility():DealDamage(enemy)
	end
end


end



function modifier_muerta_the_calling_caster:OnDestroy()
if not IsServer() then return end



for i = 0,self:GetParent():GetAbilityCount() do
	local a = self:GetParent():GetAbilityByIndex(i)

	if not a or a:GetName() == "ability_capture" then break end

	if a:GetName() ~= "muerta_the_calling_custom" and a:GetName() ~= "muerta_the_calling_custom_legendary" and a:GetName() ~= "muerta_the_calling_custom_target" then 
		a:SetActivated(true)
	end		

end

self:GetCaster():EmitSound("Muerta.Calling_caster_end")

local particle = ParticleManager:CreateParticle( "particles/muerta/muerta_calling_caster_end.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
ParticleManager:SetParticleControl(particle, 0, self:GetCaster():GetAbsOrigin())
ParticleManager:ReleaseParticleIndex( particle )


self:GetCaster():StartGesture(ACT_DOTA_CAST_ABILITY_2)
self:GetCaster():SetModelScale(1)
FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetAbsOrigin(), true)

if self:GetParent():FindAbilityByName("muerta_the_calling_custom_legendary") then 

	self:GetParent():FindAbilityByName("muerta_the_calling_custom_legendary"):UseResources(false, false, false, true)
end

end



function modifier_muerta_the_calling_caster:CheckState()
    return 
    {
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_OUT_OF_GAME] = true,
        [MODIFIER_STATE_DISARMED] = true,
        [MODIFIER_STATE_MUTED] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,

    }
end


function modifier_muerta_the_calling_caster:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MODEL_CHANGE,
	MODIFIER_PROPERTY_MODEL_SCALE,
	MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	MODIFIER_PROPERTY_VISUAL_Z_DELTA
}

end

function modifier_muerta_the_calling_caster:GetEffectName()
	return "particles/muerta/muerta_calling_caster_start.vpcf"
end

function modifier_muerta_the_calling_caster:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end


function modifier_muerta_the_calling_caster:GetModifierMoveSpeedBonus_Percentage()
if not self:GetParent():HasModifier("modifier_muerta_the_calling_custom_debuff") then return end

return self:GetCaster():GetTalentValue("modifier_muerta_calling_7", "self_move")
end


function modifier_muerta_the_calling_caster:GetModifierModelChange()
return "models/heroes/muerta/muerta_summon_model.vmdl"
end

function modifier_muerta_the_calling_caster:GetVisualZDelta()
return 100
end

function modifier_muerta_the_calling_caster:GetOverrideAnimation()
return ACT_DOTA_RUN
end


modifier_muerta_the_calling_caster_damage_cd = class({})
function modifier_muerta_the_calling_caster_damage_cd:IsHidden() return true end
function modifier_muerta_the_calling_caster_damage_cd:IsPurgable() return false end











muerta_the_calling_custom_legendary = class({})

function muerta_the_calling_custom_legendary:OnSpellStart()
if not IsServer() then return end

local ability = self:GetCaster():FindAbilityByName("muerta_the_calling_custom")

local duration = self:GetCaster():GetTalentValue("modifier_muerta_calling_7", "duration")

if self:GetCaster():HasModifier("modifier_muerta_the_calling_custom_debuff") then 
	duration = self:GetCaster():GetTalentValue("modifier_muerta_calling_7", "duration_full")
end

if self:GetCaster():HasModifier("modifier_muerta_the_calling_caster") then 

	self:GetCaster():RemoveModifierByName("modifier_muerta_the_calling_caster")
else 
	self:EndCooldown()
	self:StartCooldown(0.5)
	self:GetCaster():AddNewModifier(self:GetCaster(), ability, "modifier_muerta_the_calling_caster", {duration = duration})
end


end








function muerta_the_calling_custom_target:GetAOERadius()
	return self.target_aoe
end

function muerta_the_calling_custom_target:GetCastRange(vLocation, hTarget)

	return self:GetSpecialValueFor("cast")
end

function muerta_the_calling_custom_target:OnSpellStart()
if not IsServer() then return end

local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), nil, self:GetSpecialValueFor("search"), DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,  FIND_CLOSEST, false )

local point = self:GetCursorPosition()

local dis = (point - self:GetCaster():GetAbsOrigin()):Length2D()

if dis > self:GetSpecialValueFor("cast") then 
	point = (point - self:GetCaster():GetAbsOrigin()):Normalized()*self:GetSpecialValueFor("cast") + self:GetCaster():GetAbsOrigin()
end

local speed = self:GetSpecialValueFor("speed")

local active = false

for _,unit in pairs(units) do 

	local mod = unit:FindModifierByName("modifier_muerta_the_calling_custom_thinker")
	if mod and mod:GetStackCount() == 0 then 

		unit:EmitSound("Muerta.Calling_target_start")

		mod:SetStackCount(1)

		mod.target_speed = speed
		mod.target_x = point.x
		mod.target_y = point.y
		mod.target_z = point.z

		active = true
		break
	end
end

if active == false then 

--	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetCaster():GetPlayerOwnerID()), "CreateIngameErrorMessage", {message = "#no_near_ghost"})
  
--	self:EndCooldown()
end


end






modifier_muerta_the_calling_custom_root = class({})

function modifier_muerta_the_calling_custom_root:IsHidden() return true end
function modifier_muerta_the_calling_custom_root:IsPurgable() return true end
function modifier_muerta_the_calling_custom_root:OnCreated(table)
if not IsServer() then return end

self:GetParent():EmitSound("Muerta.Calling_root")
end

function modifier_muerta_the_calling_custom_root:CheckState()
return
{
	[MODIFIER_STATE_ROOTED] = true
}
end

function modifier_muerta_the_calling_custom_root:GetEffectName()
return "particles/muerta/calling_root.vpcf"
end

function modifier_muerta_the_calling_custom_root:GetEffectAttachType()
return PATTACH_ABSORIGIN_FOLLOW
end



modifier_muerta_the_calling_custom_root_cd = class({})
function modifier_muerta_the_calling_custom_root_cd:IsHidden() return true end
function modifier_muerta_the_calling_custom_root_cd:IsPurgable() return false end

function modifier_muerta_the_calling_custom_root_cd:OnDestroy()
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_muerta_the_calling_custom_debuff") then return end

self:GetAbility():ProcRoot(self:GetParent())

end





modifier_muerta_the_calling_custom_scepter = class({})
function modifier_muerta_the_calling_custom_scepter:IsHidden() return true end
function modifier_muerta_the_calling_custom_scepter:IsPurgable() return false end 

function modifier_muerta_the_calling_custom_scepter:GetEffectName()
	return "particles/muerta/muerta_calling_caster_start.vpcf"
end

function modifier_muerta_the_calling_custom_scepter:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end


function modifier_muerta_the_calling_custom_scepter:OnCreated()
if not IsServer() then return end 

self.NoDraw = true
self:GetParent():AddNoDraw()
end 



function modifier_muerta_the_calling_custom_scepter:OnDestroy()
if not IsServer() then return end 

self:GetParent():RemoveNoDraw()

local effect = ParticleManager:CreateParticle("particles/econ/events/ti7/blink_dagger_end_ti7.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(effect, 0, self:GetParent():GetAbsOrigin())

self:GetParent():EmitSound("Muerta.Calling_scepter_end")

local particle = ParticleManager:CreateParticle( "particles/muerta/muerta_calling_caster_end.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
ParticleManager:SetParticleControl(particle, 0, self:GetCaster():GetAbsOrigin())
ParticleManager:ReleaseParticleIndex( particle )

end 


function modifier_muerta_the_calling_custom_scepter:CheckState()
return
{
	[MODIFIER_STATE_INVULNERABLE] = true,
	[MODIFIER_STATE_OUT_OF_GAME] = true,
	[MODIFIER_STATE_UNSELECTABLE] = true
}
end 