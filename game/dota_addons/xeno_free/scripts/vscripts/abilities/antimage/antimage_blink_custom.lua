LinkLuaModifier("modifier_antimage_blink_custom_active", "abilities/antimage/antimage_blink_custom", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_antimage_blink_custom_evasion", "abilities/antimage/antimage_blink_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_antimage_blink_custom_illusion", "abilities/antimage/antimage_blink_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_antimage_blink_custom_slow", "abilities/antimage/antimage_blink_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_antimage_blink_custom_agility", "abilities/antimage/antimage_blink_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_antimage_blink_custom_attacks", "abilities/antimage/antimage_blink_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_antimage_blink_custom_legendary_damage", "abilities/antimage/antimage_blink_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_antimage_blink_custom_count", "abilities/antimage/antimage_blink_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_antimage_blink_custom_turn", "abilities/antimage/antimage_blink_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_antimage_blink_custom_quest", "abilities/antimage/antimage_blink_custom", LUA_MODIFIER_MOTION_NONE)


antimage_blink_custom = class({})



antimage_blink_custom.evasion_chance = {20, 30, 40}
antimage_blink_custom.evasion_speed = {10, 15, 20}
antimage_blink_custom.evasion_duration = 2.5

antimage_blink_custom.speed_max = 3
antimage_blink_custom.speed_duration = 3
antimage_blink_custom.speed_attack = {40, 60, 80}


antimage_blink_custom.slow = -40
antimage_blink_custom.slow_turn = -50
antimage_blink_custom.slow_attack = -60
antimage_blink_custom.slow_duration = 2.5

antimage_blink_custom.attacks_max = 3
antimage_blink_custom.attacks_damage = {0.3, 0.4, 0.5}

antimage_blink_custom.double_count = 3
antimage_blink_custom.double_heal = 0.1





function antimage_blink_custom:Precache(context)

PrecacheResource( "particle", 'particles/units/heroes/hero_antimage/antimage_blink_start.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_antimage/antimage_blink_end.vpcf', context )
PrecacheResource( "particle", 'particles/antimage_charge.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_antimage/antimage_manabreak_slow.vpcf', context )
PrecacheResource( "particle", 'particles/void_step_speed.vpcf', context )
PrecacheResource( "particle", 'particles/status_fx/status_effect_dark_seer_normal_punch_replica.vpcf', context )
PrecacheResource( "particle", 'particles/am_heal.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_terrorblade/terrorblade_reflection_slow.vpcf', context )
PrecacheResource( "particle", 'particles/am_blink_refresh.vpcf', context )
PrecacheResource( "particle", 'particles/am_blink_count.vpcf', context )

end


function antimage_blink_custom:GetCastPoint(iLevel)

local bonus = 0

if self:GetCaster():HasModifier('modifier_antimage_blink_6') then 
	bonus = self:GetCaster():GetTalentValue("modifier_antimage_blink_6", "cast")
end


return self.BaseClass.GetCastPoint(self) + bonus
end


function antimage_blink_custom:GetBehavior()
  if self:GetCaster():HasModifier("modifier_antimage_blink_7") then
    return  DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_ROOT_DISABLES + DOTA_ABILITY_BEHAVIOR_IMMEDIATE
  end
 return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_ROOT_DISABLES
end



function antimage_blink_custom:GetCastRange(vLocation, hTarget)
local max_dist = self:GetSpecialValueFor( "blink_range" )

if self:GetCaster():HasModifier("modifier_antimage_blink_7") then 
	max_dist = self:GetCaster():GetTalentValue("modifier_antimage_blink_7", "distance")
end

if IsClient() then 
	return max_dist 
end
return 99999
end






function antimage_blink_custom:GetCooldown(iLevel)

local bonus = 0
if self:GetCaster():HasModifier("modifier_antimage_blink_3") then 
	bonus = self:GetCaster():GetTalentValue("modifier_antimage_blink_3", "cd")
end

local k = 1

if self:GetCaster():HasModifier("modifier_antimage_blink_7") then  
  k = 1 - self:GetCaster():GetTalentValue("modifier_antimage_blink_7", "cd")/100
end

 return (self.BaseClass.GetCooldown(self, iLevel) + bonus)*k
 
end

function antimage_blink_custom:GetManaCost(level)

if self:GetCaster():HasModifier("modifier_antimage_blink_7") then  
  return self:GetCaster():GetTalentValue("modifier_antimage_blink_7", "mana")
end

return self.BaseClass.GetManaCost(self,level) 
end


function antimage_blink_custom:ProceedProc()
if not IsServer() then return end


if self:GetCaster():HasModifier("modifier_antimage_counter_4") then 
    local ability = self:GetCaster():FindAbilityByName("antimage_counterspell_custom")
    if ability then 
       ability:ProcDamage()
    end
end

if self:GetCaster():HasModifier("modifier_antimage_blink_2")  then 
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_antimage_blink_custom_evasion", {duration = self.evasion_duration})
end

if self:GetCaster():HasModifier("modifier_antimage_blink_1") then 
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_antimage_blink_custom_agility", {duration = self.speed_duration})
end



if self:GetCaster():HasModifier("modifier_antimage_blink_6") then 
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_antimage_blink_custom_count", {})
end


if self:GetCaster():HasModifier("modifier_antimage_blink_4") then 

	local duration = self:GetCaster():GetTalentValue("modifier_antimage_blink_4", "duration")
	local damage = self:GetCaster():GetTalentValue("modifier_antimage_blink_4", "damage") - 100

	local illusion = CreateIllusions( self:GetCaster(), self:GetCaster(), {duration=duration, outgoing_damage=damage,incoming_damage=0}, 1, 0, false, true)  

	for k, v in pairs(illusion) do

		for _,mod in pairs(self:GetCaster():FindAllModifiers()) do
		    if mod.StackOnIllusion ~= nil and mod.StackOnIllusion == true then
		        v:UpgradeIllusion(mod:GetName(), mod:GetStackCount() )
		    end
		end

		v.owner = self:GetCaster()
		v:AddNewModifier(self:GetCaster(), self, "modifier_antimage_blink_custom_illusion", {})
		Timers:CreateTimer(0.1, function()
		   	v:MoveToPositionAggressive(v:GetAbsOrigin())
		end)

	end

end


end


function antimage_blink_custom:OnSpellStart()


ProjectileManager:ProjectileDodge(self:GetCaster())

if self:GetCaster():GetQuest() == "Anti.Quest_6" and not self:GetCaster():QuestCompleted() then 
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_antimage_blink_custom_quest", {duration = self:GetCaster().quest.number})
end

if self:GetCaster():HasModifier("modifier_antimage_blink_7") then 
	self:GetCaster():EmitSound("Antimage.Blink_legen")
	
	--local point = self:GetCursorPosition()

	--if point == self:GetCaster():GetAbsOrigin() then 
		--point = self:GetCaster():GetAbsOrigin() + self:GetCaster():GetForwardVector()*10
	--end

	--local dir = (point - self:GetCaster():GetAbsOrigin())
	--dir.z = 0
	----dir = dir:Normalized()
--	self:GetCaster():FaceTowards(point)
	--self:GetCaster():SetForwardVector(dir)

	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_antimage_blink_custom_active", {duration = self:GetCaster():GetTalentValue("modifier_antimage_blink_7", "duration")})

else 



	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local origin = caster:GetOrigin()
	local blink_range = self:GetSpecialValueFor("blink_range")
	local direction = (point - origin)
	direction.z = 0
	if direction:Length2D() > blink_range then
		direction = direction:Normalized() * blink_range
	end

	local particle_start = ParticleManager:CreateParticle( "particles/units/heroes/hero_antimage/antimage_blink_start.vpcf", PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( particle_start, 0, origin )
	ParticleManager:SetParticleControlForward( particle_start, 0, direction:Normalized() )
	ParticleManager:ReleaseParticleIndex( particle_start )
	EmitSoundOnLocationWithCaster( origin, "Hero_Antimage.Blink_out", self:GetCaster() )

	FindClearSpaceForUnit( caster, origin + direction, true )

	self:ProceedProc()

	local particle_end = ParticleManager:CreateParticle( "particles/units/heroes/hero_antimage/antimage_blink_end.vpcf", PATTACH_ABSORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( particle_end, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControlForward( particle_end, 0, direction:Normalized() )
	ParticleManager:ReleaseParticleIndex( particle_end )
	EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), "Hero_Antimage.Blink_in", self:GetCaster() )


	if self:GetCaster():HasModifier("modifier_antimage_blink_5") then 

		local units = FindUnitsInLine(self:GetCaster():GetTeamNumber(), origin, self:GetCaster():GetAbsOrigin(), nil, 200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE)

  		for _,unit in ipairs(units) do
  			unit:AddNewModifier(self:GetCaster(), self, "modifier_antimage_blink_custom_slow", {duration = self.slow_duration})
  		end
		
	end




end

end




modifier_antimage_blink_custom_active = class({})

function modifier_antimage_blink_custom_active:IsDebuff() return false end
function modifier_antimage_blink_custom_active:IsHidden() return true end
function modifier_antimage_blink_custom_active:IsPurgable() return false end

function modifier_antimage_blink_custom_active:OnCreated()
    if not IsServer() then return end
    self.pfx = ParticleManager:CreateParticle("particles/items_fx/force_staff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
    self:GetParent():StartGesture(ACT_DOTA_RUN)
    self.angle = self:GetParent():GetForwardVector():Normalized()
    self.distance = self:GetCaster():GetTalentValue("modifier_antimage_blink_7", "distance") / ( self:GetDuration() / FrameTime())

    self.targets = {}

    self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_antimage_blink_custom_turn", {duration = self:GetRemainingTime() + 1})
    if self:ApplyHorizontalMotionController() == false then
        self:Destroy()
    end
end

function modifier_antimage_blink_custom_active:DeclareFunctions()
return
{
 MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
    MODIFIER_PROPERTY_DISABLE_TURNING
}
end

function modifier_antimage_blink_custom_active:GetActivityTranslationModifiers()
    return "haste"
end


function modifier_antimage_blink_custom_active:GetModifierDisableTurning() return 1 end

function modifier_antimage_blink_custom_active:GetEffectName() return "particles/antimage_charge.vpcf" end
function modifier_antimage_blink_custom_active:GetStatusEffectName() return "particles/status_fx/status_effect_forcestaff.vpcf" end
function modifier_antimage_blink_custom_active:StatusEffectPriority() return 100 end

function modifier_antimage_blink_custom_active:OnDestroy()
    if not IsServer() then return end
    self:GetParent():InterruptMotionControllers( true )
    ParticleManager:DestroyParticle(self.pfx, false)
    ParticleManager:ReleaseParticleIndex(self.pfx)
    self:GetParent():FadeGesture(ACT_DOTA_RUN)
    ResolveNPCPositions(self:GetParent():GetAbsOrigin(), 128)

	local dir = self:GetParent():GetForwardVector()
    dir.z = 0
    self:GetParent():SetForwardVector(dir)
    self:GetParent():FaceTowards(self:GetParent():GetAbsOrigin() + dir*10)

    ResolveNPCPositions(self:GetParent():GetAbsOrigin(), 128)
    self:GetAbility():ProceedProc()



end


function modifier_antimage_blink_custom_active:UpdateHorizontalMotion( me, dt )
    if not IsServer() then return end
    local pos = self:GetParent():GetAbsOrigin()
    GridNav:DestroyTreesAroundPoint(pos, 80, false)
    local pos_p = self.angle * self.distance
    local next_pos = GetGroundPosition(pos + pos_p,self:GetParent())
    self:GetParent():SetAbsOrigin(next_pos)



	local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetParent():GetOrigin(), nil, 120, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
	
	for _,enemy in pairs(enemies) do 
		local attack = true
		for _,target in pairs(self.targets) do 
			if target == enemy then 
				attack = false 
			end
		end

		if attack then 
			self.targets[#self.targets + 1] = enemy

			local damage = self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_antimage_blink_custom_legendary_damage", {})
			local no_cleave = self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_no_cleave", {})
			
			self:GetParent():PerformAttack(enemy, true, true, true, true, false, false, false)
			
			if damage then 
				damage:Destroy()
			end
			
			if no_cleave then 
				no_cleave:Destroy()
			end
			


		if self:GetCaster():HasModifier("modifier_antimage_blink_5") then 
	  		enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_antimage_blink_custom_slow", {duration = self:GetAbility().slow_duration})
		end

			local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_antimage/antimage_manabreak_slow.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy)
			ParticleManager:SetParticleControl(particle, 0, enemy:GetAbsOrigin())
			ParticleManager:SetParticleControl(particle, 1, enemy:GetAbsOrigin())
		end

	end

end

function modifier_antimage_blink_custom_active:OnHorizontalMotionInterrupted()
    self:Destroy()
end




modifier_antimage_blink_custom_evasion = class({})
function modifier_antimage_blink_custom_evasion:IsHidden() return false end
function modifier_antimage_blink_custom_evasion:IsPurgable() return false end
function modifier_antimage_blink_custom_evasion:GetEffectName() return "particles/void_step_speed.vpcf" end
function modifier_antimage_blink_custom_evasion:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_EVASION_CONSTANT,
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end

function modifier_antimage_blink_custom_evasion:GetTexture() return "buffs/blink_evasion" end

function modifier_antimage_blink_custom_evasion:GetModifierEvasion_Constant()
local bonus = 0
if self:GetParent():HasModifier("modifier_antimage_blink_2") then 
	bonus = self:GetAbility().evasion_chance[self:GetCaster():GetUpgradeStack("modifier_antimage_blink_2")]
end	

return bonus
end

function modifier_antimage_blink_custom_evasion:GetModifierMoveSpeedBonus_Percentage()
local bonus = 0
if self:GetParent():HasModifier("modifier_antimage_blink_2") then 
	bonus = self:GetAbility().evasion_speed[self:GetCaster():GetUpgradeStack("modifier_antimage_blink_2")]
end	

return bonus
end





modifier_antimage_blink_custom_illusion = class({})
function modifier_antimage_blink_custom_illusion:IsHidden() return false end
function modifier_antimage_blink_custom_illusion:IsPurgable() return false end
function modifier_antimage_blink_custom_illusion:GetStatusEffectName() return "particles/status_fx/status_effect_dark_seer_normal_punch_replica.vpcf" end

function modifier_antimage_blink_custom_illusion:StatusEffectPriority()
    return 10010
end


function modifier_antimage_blink_custom_illusion:CheckState()
return
{
	[MODIFIER_STATE_NO_HEALTH_BAR] = true,
	[MODIFIER_STATE_INVULNERABLE] = true,
	[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	[MODIFIER_STATE_UNTARGETABLE] = true,
	[MODIFIER_STATE_UNSELECTABLE] = true,
	[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
}
end

function modifier_antimage_blink_custom_illusion:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_ATTACK_LANDED,
}
end



function modifier_antimage_blink_custom_illusion:OnCreated(table)
if not IsServer() then return end

self.heal = self:GetCaster():GetTalentValue("modifier_antimage_blink_4", "heal")/100

end


function modifier_antimage_blink_custom_illusion:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end

if self:GetParent().owner and self:GetParent().owner:IsAlive() then 
	local heal = self:GetParent().owner:GetMaxHealth()*self.heal
	self:GetParent().owner:GenericHeal(heal, self:GetAbility(), true, "particles/am_heal.vpcf")

end



end






modifier_antimage_blink_custom_turn = class({})
function modifier_antimage_blink_custom_turn:IsHidden() return true end
function modifier_antimage_blink_custom_turn:IsPurgable() return true end
function modifier_antimage_blink_custom_turn:GetTexture() return "buffs/step_cd" end

function modifier_antimage_blink_custom_turn:DeclareFunctions()
return 
{
	MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE
}
end


function modifier_antimage_blink_custom_turn:GetModifierTurnRate_Percentage()
return 100
 end





modifier_antimage_blink_custom_slow = class({})
function modifier_antimage_blink_custom_slow:IsHidden() return false end
function modifier_antimage_blink_custom_slow:IsPurgable() return true end
function modifier_antimage_blink_custom_slow:GetTexture() return "buffs/step_cd" end

function modifier_antimage_blink_custom_slow:DeclareFunctions()
return 
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE
}
end
function modifier_antimage_blink_custom_slow:GetModifierMoveSpeedBonus_Percentage()
return self:GetAbility().slow
end

function modifier_antimage_blink_custom_slow:GetModifierAttackSpeedBonus_Constant()
return self:GetAbility().slow_attack
end


function modifier_antimage_blink_custom_slow:GetModifierTurnRate_Percentage()
return self:GetAbility().slow_turn
end

function modifier_antimage_blink_custom_slow:GetEffectName()
	return "particles/units/heroes/hero_terrorblade/terrorblade_reflection_slow.vpcf"
end


function modifier_antimage_blink_custom_slow:OnCreated(table)
if not IsServer() then return end
local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_antimage/antimage_manabreak_slow.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControl(particle, 0, self:GetParent():GetAbsOrigin())
ParticleManager:SetParticleControl(particle, 1, self:GetParent():GetAbsOrigin())
end



function modifier_antimage_blink_custom_slow:OnRefresh(table)
if not IsServer() then return end
self:OnCreated(table)
end



modifier_antimage_blink_custom_agility = class({})
function modifier_antimage_blink_custom_agility:IsHidden() return false end
function modifier_antimage_blink_custom_agility:IsPurgable() return false end
function modifier_antimage_blink_custom_agility:GetTexture() return "buffs/antimage_blink_agility" end

function modifier_antimage_blink_custom_agility:OnCreated(table)
if not IsServer() then return end
self.RemoveForDuel = true
end




function modifier_antimage_blink_custom_agility:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	--MODIFIER_EVENT_ON_ATTACK_LANDED
}
end


function modifier_antimage_blink_custom_agility:GetModifierAttackSpeedBonus_Constant()
return self:GetAbility().speed_attack[self:GetParent():GetUpgradeStack("modifier_antimage_blink_1")]
end


function modifier_antimage_blink_custom_agility:OnAttackLanded(params)
if not IsServer() then return end
if params.attacker ~= self:GetParent() then return end

self:DecrementStackCount()

if self:GetStackCount() == 0 then
	self:Destroy()
end

end


modifier_antimage_blink_custom_attacks = class({})
function modifier_antimage_blink_custom_attacks:IsHidden() return false end
function modifier_antimage_blink_custom_attacks:IsPurgable() return false end
function modifier_antimage_blink_custom_attacks:GetTexture() return "buffs/antimage_blink_damage" end


function modifier_antimage_blink_custom_attacks:OnCreated(table)
if not IsServer() then return end
self.RemoveForDuel = true
self:SetStackCount(self:GetAbility().attacks_max)

end


function modifier_antimage_blink_custom_attacks:OnRefresh(table)
self:OnCreated(table)
end


function modifier_antimage_blink_custom_attacks:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_ATTACK_LANDED,
	MODIFIER_PROPERTY_TOOLTIP
}
end




function modifier_antimage_blink_custom_attacks:OnAttackLanded(params)
if not IsServer() then return end
if params.attacker ~= self:GetParent() then return end
if params.target:IsBuilding() then return end

local damage = self:GetParent():GetAgility()*self:GetAbility().attacks_damage[self:GetCaster():GetUpgradeStack("modifier_antimage_blink_3")]

ApplyDamage({ victim = params.target, attacker = self:GetParent(), damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self:GetAbility(), })
	
SendOverheadEventMessage(params.target, 4, params.target, damage, nil)
		


self:DecrementStackCount()
if self:GetStackCount() == 0 then 
	self:Destroy()
end

end



function modifier_antimage_blink_custom_attacks:OnTooltip()
 return self:GetParent():GetAgility()*self:GetAbility().attacks_damage[self:GetCaster():GetUpgradeStack("modifier_antimage_blink_3")]
end


modifier_antimage_blink_custom_legendary_damage = class({})
function modifier_antimage_blink_custom_legendary_damage:IsHidden() return false end
function modifier_antimage_blink_custom_legendary_damage:IsPurgable() return false end
function modifier_antimage_blink_custom_legendary_damage:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE
}
end

function modifier_antimage_blink_custom_legendary_damage:GetModifierDamageOutgoing_Percentage()
	return self.damage
end


function modifier_antimage_blink_custom_legendary_damage:OnCreated()

self.damage = self:GetCaster():GetTalentValue("modifier_antimage_blink_7", "damage") - 100
end 


modifier_antimage_blink_custom_count = class({})
function modifier_antimage_blink_custom_count:IsHidden() return true end
function modifier_antimage_blink_custom_count:IsPurgable() return false end
function modifier_antimage_blink_custom_count:RemoveOnDeath() return false end

function modifier_antimage_blink_custom_count:OnCreated(table)
if not IsServer() then return end
self.max = self:GetCaster():GetTalentValue("modifier_antimage_blink_6", "count")
self.heal = self:GetCaster():GetTalentValue("modifier_antimage_blink_6", "heal")/100

self.RemoveForDuel = true
self:SetStackCount(1)
end


function modifier_antimage_blink_custom_count:OnRefresh(table)
if not IsServer() then return end
self:IncrementStackCount()

if self:GetStackCount() >= self.max  then 


	local particle = ParticleManager:CreateParticle("particles/am_blink_refresh.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent())
   	ParticleManager:SetParticleControlEnt( particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )
   	ParticleManager:ReleaseParticleIndex(particle)


	self:GetAbility():EndCooldown()
	self:GetAbility():StartCooldown(0.3)
	self:GetParent():EmitSound("Antimage.Blink_refresh")

	local heal = (self:GetCaster():GetMaxHealth())*self.heal
	self:GetCaster():GenericHeal(heal, self:GetAbility())


	self:Destroy()
end

end


function modifier_antimage_blink_custom_count:OnStackCountChanged(iStackCount)
if self:GetStackCount() == 0 then return end
if self:GetStackCount() == 1 then 

	local particle_cast = "particles/am_blink_count.vpcf"

	self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, self:GetStackCount(), 0 ) )

	self:AddParticle(self.effect_cast,false, false, -1, false, false)
else 
  if self.effect_cast then 
  	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, self:GetStackCount(), 0 ) )
  end
end

end


modifier_antimage_blink_custom_quest = class({})
function modifier_antimage_blink_custom_quest:IsHidden() return true end
function modifier_antimage_blink_custom_quest:IsPurgable() return false end