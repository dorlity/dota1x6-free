LinkLuaModifier( "modifier_sniper_headshot_custom", "abilities/sniper/sniper_headshot_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sniper_headshot_custom_active", "abilities/sniper/sniper_headshot_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sniper_headshot_custom_slow", "abilities/sniper/sniper_headshot_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sniper_headshot_custom_legendary", "abilities/sniper/sniper_headshot_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sniper_headshot_custom_legendary_unit", "abilities/sniper/sniper_headshot_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sniper_headshot_custom_legendary_damage", "abilities/sniper/sniper_headshot_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sniper_headshot_custom_armor", "abilities/sniper/sniper_headshot_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sniper_headshot_custom_status", "abilities/sniper/sniper_headshot_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sniper_headshot_custom_no_count_status", "abilities/sniper/sniper_headshot_custom", LUA_MODIFIER_MOTION_NONE )



sniper_headshot_custom = class({})


sniper_headshot_custom.damage_inc = {30, 45, 60}

sniper_headshot_custom.attack_heal = {0.2, 0.3, 0.4}


sniper_headshot_custom.proc_chance = 10
sniper_headshot_custom.proc_knock = 10

sniper_headshot_custom.cd_inc = {-2, -4, -6}

sniper_headshot_custom.incoming_status = 30
sniper_headshot_custom.incoming_damage = -30



function sniper_headshot_custom:Precache(context)

PrecacheResource( "particle", "particles/sniper_legendary_attack.vpcf", context )
PrecacheResource( "particle", "particles/sniper_legendary_attacka.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_sniper/sniper_headshot_slow.vpcf", context )
PrecacheResource( "particle", "particles/items3_fx/star_emblem.vpcf", context )
PrecacheResource( "particle", "particles/items4_fx/ascetic_cap.vpcf", context )

end


sniper_headshot_custom.projectiles = {}


function sniper_headshot_custom:GetIntrinsicModifierName()
return "modifier_sniper_headshot_custom"
end

function sniper_headshot_custom:GetCooldown(iLevel)

local upgrade_cooldown = 0

if self:GetCaster():HasModifier("modifier_sniper_headshot_3") then  
	upgrade_cooldown = self.cd_inc[self:GetCaster():GetUpgradeStack("modifier_sniper_headshot_3")]
end 

 return self.BaseClass.GetCooldown(self, iLevel) + upgrade_cooldown

end







function sniper_headshot_custom:OnSpellStart()
if not IsServer() then return end


local duration = self:GetSpecialValueFor("active_duration")


if self:GetCaster():HasModifier("modifier_sniper_headshot_7") then
	duration = self:GetCaster():GetTalentValue("modifier_sniper_headshot_7", "duration")
end

if self:GetCaster():HasModifier('modifier_sniper_headshot_4') then 
	duration = duration + self:GetCaster():GetTalentValue("modifier_sniper_headshot_4", "duration")
end

if self:GetCaster():HasModifier("modifier_sniper_headshot_5") then 
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_sniper_headshot_custom_status", {})
end


if self:GetCaster():HasModifier("modifier_sniper_headshot_7") then
	 
	self:GetCaster():EmitSound("Sniper.Headshot_legendary_voice")
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_sniper_headshot_custom_legendary", {duration = duration})
else 
	self:GetCaster():EmitSound("Hero_Sniper.TakeAim.Cast")
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_sniper_headshot_custom_active", {duration = duration})
end


end



function sniper_headshot_custom:OnProjectileThink_ExtraData(location, data)
if not IsServer() then return end
if not data.index or not self.projectiles or not self.projectiles[data.index] then return end
if not data.thinker then return end

local thinker =  EntIndexToHScript(data.thinker)

if thinker == nil or thinker:IsNull() then return end
if not EntIndexToHScript(data.thinker):HasModifier("modifier_sniper_headshot_custom_legendary_unit") then return end

local width = self:GetCaster():GetTalentValue("modifier_sniper_headshot_7", "width")

local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), location, nil, width, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false)

local hit = false

for _,enemy in pairs(enemies) do 

	if enemy:GetUnitName() ~= "npc_teleport" and not enemy:HasModifier("modifier_skeleton_king_reincarnation_custom_legendary") then 

		hit = true

		if not self:GetCaster():HasModifier("modifier_sniper_headshot_custom_legendary") then 
			self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_sniper_headshot_custom_legendary_damage", {})
		end

		self:GetCaster():PerformAttack(enemy, false, true, true, true, false, false, true)

		local particle_aoe_fx = ParticleManager:CreateParticle("particles/sniper_legendary_attacka.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy)
		ParticleManager:SetParticleControlEnt( particle_aoe_fx, 0, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true )
		ParticleManager:SetParticleControlEnt( particle_aoe_fx, 3, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true )
		ParticleManager:DestroyParticle(particle_aoe_fx, false)
		ParticleManager:ReleaseParticleIndex(particle_aoe_fx) 



		self:GetCaster():RemoveModifierByName("modifier_sniper_headshot_custom_legendary_damage")
		break
	end
end

if hit == true then 

	UTIL_Remove(thinker)
	--ProjectileManager:DestroyTrackingProjectile(self.projectiles[data.index])

end


end






modifier_sniper_headshot_custom = class({})
function modifier_sniper_headshot_custom:IsHidden() return true end
function modifier_sniper_headshot_custom:IsPurgable() return false end

function modifier_sniper_headshot_custom:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL,
        MODIFIER_EVENT_ON_TAKEDAMAGE
    }
end



function modifier_sniper_headshot_custom:OnTakeDamage(params)
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_sniper_headshot_2") then return end
if not params.attacker then return end
if self:GetParent() ~= params.attacker then return end
if not params.unit:IsHero() and not params.unit:IsCreep() then return end
if self.record == nil then return end
if params.record == nil then return end
if params.inflictor then return end
if self.record ~= params.record then return end

self:GetParent():GenericHeal(params.damage*self:GetAbility().attack_heal[self:GetCaster():GetUpgradeStack("modifier_sniper_headshot_2")], self:GetAbility() )

end




function modifier_sniper_headshot_custom:GetModifierProcAttack_BonusDamage_Physical(params)
if not IsServer() then return end

local target = params.target
local caster = self:GetCaster()
local ability = self:GetAbility()

if not caster:IsRealHero() and not caster.aim_illusion then return end
if caster:PassivesDisabled() then return 0 end
if target:IsBuilding() or target:IsOther() then return 0 end
if target:IsDebuffImmune() and not self:GetParent():HasModifier("modifier_sniper_headshot_6") then return end

self.record = nil

local chance = ability:GetSpecialValueFor("proc_chance")
local knockback_dist = ability:GetSpecialValueFor("knockback_distance")


if self:GetParent():HasModifier("modifier_sniper_headshot_6") then 
	chance = chance + self:GetAbility().proc_chance
	knockback_dist = knockback_dist + self:GetAbility().proc_knock
end



if not self:GetParent():HasModifier("modifier_sniper_headshot_custom_active") and
not RollPseudoRandomPercentage(chance,27,self:GetParent()) then return end

if params.target:IsRealHero() and not self:GetParent():QuestCompleted() and self:GetParent():GetQuest() == "Sniper.Quest_6" then 
	self:GetParent():UpdateQuest(1)
end


self.record = params.record


target:AddNewModifier(caster,self:GetCaster():BkbAbility(self:GetAbility(), self:GetCaster():HasModifier("modifier_sniper_headshot_6")),"modifier_sniper_headshot_custom_slow", { duration = ability:GetSpecialValueFor("slow_duration")*(1 - target:GetStatusResistance()) })


               
local knockback =	
{
    should_stun = 0,
    knockback_duration = 0.1,
    duration = 0.1,
    knockback_distance = knockback_dist,
    knockback_height = 0,
    center_x = caster:GetAbsOrigin().x,
    center_y = caster:GetAbsOrigin().y,
    center_z = caster:GetAbsOrigin().z,
}


if not target:IsCurrentlyHorizontalMotionControlled() and not target:IsCurrentlyVerticalMotionControlled() and target:GetUnitName() ~= "npc_teleport" 
	and not target:HasModifier("modifier_monkey_king_wukongs_command_custom_soldier") then 

	target:AddNewModifier(caster,self:GetCaster():BkbAbility(self:GetAbility(), self:GetCaster():HasModifier("modifier_sniper_headshot_6")),"modifier_knockback",knockback)
end 

local damage = ability:GetSpecialValueFor("damage")

if self:GetCaster():HasModifier("modifier_sniper_headshot_1") then 
	damage = damage + self:GetAbility().damage_inc[self:GetCaster():GetUpgradeStack("modifier_sniper_headshot_1")]
end

if self:GetCaster():HasModifier("modifier_sniper_headshot_4") and 
	(self:GetCaster():HasModifier("modifier_sniper_headshot_custom_active") or self:GetCaster():HasModifier("modifier_sniper_headshot_custom_legendary") or self:GetCaster():HasModifier("modifier_sniper_headshot_custom_legendary_damage")) then 

	params.target:AddNewModifier(self:GetCaster(), self:GetCaster():BkbAbility(self:GetAbility(), self:GetCaster():HasModifier("modifier_sniper_headshot_6")), "modifier_sniper_headshot_custom_armor", {duration = self:GetCaster():GetTalentValue("modifier_sniper_headshot_4", "armor_duration")})
end

return damage
end


modifier_sniper_headshot_custom_slow = class({})


function modifier_sniper_headshot_custom_slow:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    }
end


function modifier_sniper_headshot_custom_slow:OnCreated(table)

self.ability = self:GetCaster():FindAbilityByName("sniper_headshot_custom")
if not ability then 
	self:Destroy()
	return 
end

self.move =  self.ability:GetSpecialValueFor("slow")
self.attack =  self.ability:GetSpecialValueFor("slow")

end


function modifier_sniper_headshot_custom_slow:GetModifierMoveSpeedBonus_Percentage()
    return self.move
end


function modifier_sniper_headshot_custom_slow:GetModifierAttackSpeedBonus_Constant()
    return self.attack
end


function modifier_sniper_headshot_custom_slow:GetEffectName()
    return "particles/units/heroes/hero_sniper/sniper_headshot_slow.vpcf"
end


function modifier_sniper_headshot_custom_slow:GetEffectAttachType()
    return PATTACH_OVERHEAD_FOLLOW
end













modifier_sniper_headshot_custom_legendary = class({})
function modifier_sniper_headshot_custom_legendary:IsHidden() return false end
function modifier_sniper_headshot_custom_legendary:IsPurgable() return false end

function modifier_sniper_headshot_custom_legendary:OnCreated(table)
if not IsServer() then return end

self.damage = self:GetCaster():GetTalentValue("modifier_sniper_headshot_7", "damage") - 100
self.width = self:GetCaster():GetTalentValue("modifier_sniper_headshot_7", "width")
self.distance = self:GetCaster():GetTalentValue("modifier_sniper_headshot_7", "distance")
self.attack_pause = self:GetCaster():GetTalentValue("modifier_sniper_headshot_7", "interval")
self.auto = self:GetCaster():GetTalentValue("modifier_sniper_headshot_7", "auto")
self.turn_speed = self:GetCaster():GetTalentValue("modifier_sniper_headshot_7", "turn")


self:GetCaster():EmitSound("Sniper.Headshot_legendary")


self.speed = 2000
self.drow_back = 35

self.anim_return = 0
self.origin = self:GetParent():GetOrigin()
self.charge_finish = false
self.target_angle = self:GetParent():GetAnglesAsVector().y
self.current_angle = self.target_angle
self.face_target = true

self.count = 0
self.interval = FrameTime()

self:StartIntervalThink(self.interval)

end

function modifier_sniper_headshot_custom_legendary:CheckState()
return
{
	[MODIFIER_STATE_DISARMED] = true,
	[MODIFIER_STATE_SILENCED] = true,
}
end


function modifier_sniper_headshot_custom_legendary:OnIntervalThink()
if not IsServer() then return end

self.count = self.count + self.interval

if self:GetParent():IsHexed() or self:GetParent():IsStunned() then 
	--self:Destroy()
	return
end


if self.count >= self.attack_pause then 

	self.count = 0

	self:GetCaster():FadeGesture(ACT_DOTA_ATTACK)
	self:GetCaster():StartGesture(ACT_DOTA_ATTACK)



	local point = self:GetParent():GetForwardVector()*self.distance + self:GetParent():GetAbsOrigin()

	local thinker = CreateModifierThinker( self:GetCaster(),  self:GetAbility(),  "modifier_sniper_headshot_custom_legendary_unit",   { duration = (0.90*self.distance)/self.speed}, GetGroundPosition(point, nil), self:GetCaster():GetTeamNumber(),  false )


	local caster = self:GetParent()

	local index = #self:GetAbility().projectiles + 1

	self:GetAbility().projectiles[index] =  ProjectileManager:CreateTrackingProjectile({

		    Target = thinker,
	        EffectName = "particles/sniper_legendary_attack.vpcf",
	        Ability = self:GetAbility(),

		    iMoveSpeed = self.speed,
		    bDodgeable = false, 

	        vSpawnOrigin = caster:GetAbsOrigin(),
	        vSourceLoc = self:GetCaster():GetAttachmentOrigin(self:GetCaster():ScriptLookupAttachment("attach_attack1")),

	        Source = caster,
	        bDeleteOnHit = true,

	        bProvidesVision = true,
	        iVisionTeamNumber = caster:GetTeamNumber(),
	        iVisionRadius = 100,
	        ExtraData = {index = index, thinker = thinker:entindex()},
	})


	self:GetCaster():EmitSound("Sniper.Headshot_legendary_attack")
	FindClearSpaceForUnit(self:GetCaster(), self:GetCaster():GetAbsOrigin() - self:GetCaster():GetForwardVector()*(self.drow_back*self.attack_pause), false)
end

local qangle_rotation_rate = -60 + 120*(RandomInt(0, 1))

local line_position = self:GetCaster():GetAbsOrigin() + self:GetCaster():GetForwardVector() * 400

local qangle = QAngle(0, qangle_rotation_rate, 0)
line_position = RotatePosition(self:GetCaster():GetAbsOrigin() , qangle, line_position)

self:AutoTurn( line_position )

self:TurnLogic( FrameTime() )

end



function modifier_sniper_headshot_custom_legendary:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ORDER,
		MODIFIER_PROPERTY_MOVESPEED_LIMIT,
		MODIFIER_PROPERTY_DISABLE_TURNING,
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE
	}

	return funcs
end



function modifier_sniper_headshot_custom_legendary:GetModifierDamageOutgoing_Percentage()
return self.damage
end


function modifier_sniper_headshot_custom_legendary:GetModifierMoveSpeed_Limit()
	return 0.1
end

function modifier_sniper_headshot_custom_legendary:GetModifierDisableTurning()
 return 1
end

function modifier_sniper_headshot_custom_legendary:OnOrder( params )
	if params.unit~=self:GetParent() then return end

	if 	params.order_type==DOTA_UNIT_ORDER_MOVE_TO_POSITION or
		params.order_type==DOTA_UNIT_ORDER_MOVE_TO_DIRECTION
	then
		self:SetDirection( params.new_pos )
	elseif 
		params.order_type==DOTA_UNIT_ORDER_MOVE_TO_TARGET or
		params.order_type==DOTA_UNIT_ORDER_ATTACK_TARGET
	then
		self:SetDirection( params.target:GetOrigin() )
	elseif
		params.order_type==DOTA_UNIT_ORDER_STOP or 
		params.order_type==DOTA_UNIT_ORDER_HOLD_POSITION
	then
		self:Destroy()
	end	
end

function modifier_sniper_headshot_custom_legendary:SetDirection( location )
	local dir = ((location-self:GetParent():GetOrigin())*Vector(1,1,0)):Normalized()
	self.target_angle = VectorToAngles( dir ).y
	self.face_target = false
end

function modifier_sniper_headshot_custom_legendary:TurnLogic( dt )
	if self.face_target then return end
	local angle_diff = AngleDiff( self.current_angle, self.target_angle )
	local turn_speed = self.turn_speed*dt

	local sign = -1
	if angle_diff<0 then sign = 1 end

	if math.abs( angle_diff )<1.1*turn_speed then
		self.current_angle = self.target_angle
		self.face_target = true
	else
		self.current_angle = self.current_angle + sign*turn_speed
	end

	local angles = self:GetParent():GetAnglesAsVector()
	self:GetParent():SetLocalAngles( angles.x, self.current_angle, angles.z )
end


function modifier_sniper_headshot_custom_legendary:AutoTurn(location)

local dir = ((location-self:GetParent():GetOrigin())*Vector(1,1,0)):Normalized()
local target_angle = VectorToAngles( dir ).y

local angle_diff = AngleDiff( self.current_angle, target_angle )
local turn_speed = self.turn_speed*self.interval*self.auto

local sign = -1
if angle_diff<0 then sign = 1 end

if math.abs( angle_diff )<1.1*turn_speed then
	self.current_angle = target_angle
else
	self.current_angle = self.current_angle + sign*turn_speed
end

local angles = self:GetParent():GetAnglesAsVector()
self:GetParent():SetLocalAngles( angles.x, self.current_angle, angles.z )

end



function modifier_sniper_headshot_custom_legendary:OnDestroy()
if not IsServer() then return end

	self:GetCaster():FadeGesture(ACT_DOTA_ATTACK)
	self:GetCaster():StopSound("Sniper.Headshot_legendary")

	local dir = self:GetParent():GetForwardVector()
	dir.z = 0

	self:GetParent():FaceTowards(self:GetParent():GetAbsOrigin() + dir*10)
	self:GetParent():SetForwardVector(dir)

	self:GetParent():Stop()

	self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_sniper_headshot_custom_no_count_status", {duration = 0.3})

	FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetAbsOrigin(), false)
end












modifier_sniper_headshot_custom_legendary_unit = class({})
function modifier_sniper_headshot_custom_legendary_unit:IsHidden() return true end
function modifier_sniper_headshot_custom_legendary_unit:IsPurgable() return false end



modifier_sniper_headshot_custom_legendary_damage = class({})
function modifier_sniper_headshot_custom_legendary_damage:IsHidden() return true end
function modifier_sniper_headshot_custom_legendary_damage:IsPurgable() return false end
function modifier_sniper_headshot_custom_legendary_damage:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE
}
end

function modifier_sniper_headshot_custom_legendary_damage:GetModifierDamageOutgoing_Percentage()
return self.damage
end


function modifier_sniper_headshot_custom_legendary_damage:OnCreated()
self.damage = self:GetCaster():GetTalentValue("modifier_sniper_headshot_7", "damage") - 100
end 






modifier_sniper_headshot_custom_active = class({})
function modifier_sniper_headshot_custom_active:IsHidden() return false end
function modifier_sniper_headshot_custom_active:IsPurgable() return false end

function modifier_sniper_headshot_custom_active:OnCreated(table)

self.slow = self:GetAbility():GetSpecialValueFor("active_slow")
self.range = self:GetAbility():GetSpecialValueFor("active_range")

end



function modifier_sniper_headshot_custom_active:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
}
end

function modifier_sniper_headshot_custom_active:GetModifierAttackRangeBonus()
return self.range
end

function modifier_sniper_headshot_custom_active:GetModifierMoveSpeedBonus_Percentage()
return self.slow
end


function modifier_sniper_headshot_custom_active:OnDestroy()
if not IsServer() then return end

self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_sniper_headshot_custom_no_count_status", {duration = 0.3})
end




modifier_sniper_headshot_custom_armor = class({})
function modifier_sniper_headshot_custom_armor:IsHidden() return false end
function modifier_sniper_headshot_custom_armor:IsPurgable() return false end
function modifier_sniper_headshot_custom_armor:GetTexture() return 'buffs/headshot_armor' end

function modifier_sniper_headshot_custom_armor:OnCreated(table)

self.armor = self:GetCaster():GetTalentValue("modifier_sniper_headshot_4", "armor")


if not IsServer() then return end
self:SetStackCount(1)
end

function modifier_sniper_headshot_custom_armor:OnRefresh(table)
if not IsServer() then return end
self:IncrementStackCount()

if self:GetStackCount() == 5 then 

	self:GetParent():EmitSound("Hoodwink.Acorn_armor")
	self.particle_peffect = ParticleManager:CreateParticle("particles/items3_fx/star_emblem.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())	
	ParticleManager:SetParticleControl(self.particle_peffect, 0, self:GetParent():GetAbsOrigin())
	self:AddParticle(self.particle_peffect, false, false, -1, false, true)

end


end


function modifier_sniper_headshot_custom_armor:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
}
end

function modifier_sniper_headshot_custom_armor:GetModifierPhysicalArmorBonus()
	return self.armor*self:GetStackCount()
end




modifier_sniper_headshot_custom_status = class({})
function modifier_sniper_headshot_custom_status:IsHidden() return false end
function modifier_sniper_headshot_custom_status:IsPurgable() return false end
function modifier_sniper_headshot_custom_status:GetTexture() return "buffs/headshot_status" end

function modifier_sniper_headshot_custom_status:OnCreated(table)

self.status = self:GetAbility().incoming_status
self.damage = self:GetAbility().incoming_damage

if not IsServer() then return end
self.pos = self:GetParent():GetAbsOrigin()

self:StartIntervalThink(0.1)

self:GetParent():EmitSound("Sniper.Headshot_status")

local particle = ParticleManager:CreateParticle( "particles/items4_fx/ascetic_cap.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
self:AddParticle( particle, false, false, -1, false, false  )
end


function modifier_sniper_headshot_custom_status:OnIntervalThink()
if not IsServer() then return end

if self:GetParent():HasModifier("modifier_sniper_headshot_custom_legendary") or self:GetParent():HasModifier("modifier_sniper_headshot_custom_active")
	or self:GetParent():HasModifier("modifier_sniper_headshot_custom_no_count_status") then 

	self.pos = self:GetParent():GetAbsOrigin()
	return 
end

if self.pos == self:GetParent():GetAbsOrigin() then return end

self:Destroy()
end



function modifier_sniper_headshot_custom_status:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING
}
end


function modifier_sniper_headshot_custom_status:GetModifierStatusResistanceStacking() 
  return self.status
end

function modifier_sniper_headshot_custom_status:GetModifierIncomingDamage_Percentage()
  return self.damage
end




modifier_sniper_headshot_custom_no_count_status = class({})
function modifier_sniper_headshot_custom_no_count_status:IsHidden() return true end
function modifier_sniper_headshot_custom_no_count_status:IsPurgable() return false end