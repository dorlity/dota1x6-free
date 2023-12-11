LinkLuaModifier( "modifier_sniper_take_aim_custom", "abilities/sniper/sniper_take_aim_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sniper_take_aim_custom_legendary", "abilities/sniper/sniper_take_aim_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sniper_take_aim_custom_legendary_disarm", "abilities/sniper/sniper_take_aim_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sniper_take_aim_custom_blink", "abilities/sniper/sniper_take_aim_custom", LUA_MODIFIER_MOTION_HORIZONTAL )
LinkLuaModifier( "modifier_sniper_take_aim_custom_blink_speed", "abilities/sniper/sniper_take_aim_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sniper_take_aim_custom_agility", "abilities/sniper/sniper_take_aim_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sniper_take_aim_custom_evasion", "abilities/sniper/sniper_take_aim_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sniper_take_aim_custom_evasion_cd", "abilities/sniper/sniper_take_aim_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sniper_take_aim_custom_attack_speed", "abilities/sniper/sniper_take_aim_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sniper_take_aim_custom_slow", "abilities/sniper/sniper_take_aim_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sniper_take_aim_custom_shield", "abilities/sniper/sniper_take_aim_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sniper_take_aim_custom_shield_cd", "abilities/sniper/sniper_take_aim_custom", LUA_MODIFIER_MOTION_NONE )



sniper_take_aim_custom = class({})

sniper_take_aim_custom.agility_range = 400
sniper_take_aim_custom.agility_regen = {1, 2}
sniper_take_aim_custom.agility_bonus = {0.15, 0.25}

sniper_take_aim_custom.attack_speed = {30, 45, 60}
sniper_take_aim_custom.attack_timer = 2

sniper_take_aim_custom.evasion_speed = {10, 15, 20}
sniper_take_aim_custom.evasion_bonus = {20, 30, 40}
sniper_take_aim_custom.evasion_cd = 10
sniper_take_aim_custom.evasion_duration = 3

sniper_take_aim_custom.range_slow = {-8, -12, -16}
sniper_take_aim_custom.range_slow_duration = 2
sniper_take_aim_custom.range_distance = 500
sniper_take_aim_custom.range_armor = {-3, -4, -5}


sniper_take_aim_custom.shield_duration = 3
sniper_take_aim_custom.shield_health = 30
sniper_take_aim_custom.shield_durability = 0.2
sniper_take_aim_custom.shield_cd = 40


function sniper_take_aim_custom:Precache(context)

PrecacheResource( "particle", "particles/units/heroes/hero_oracle/oracle_purifyingflames.vpcf", context )
PrecacheResource( "particle", "particles/items3_fx/blink_swift_buff.vpcf", context )
PrecacheResource( "particle", "particles/sniper_aim_blink.vpcf", context )
PrecacheResource( "particle", "particles/items_fx/force_staff.vpcf", context )
PrecacheResource( "particle", "particles/lc_odd_proc_hands.vpcf", context )
PrecacheResource( "particle", "particles/status_fx/status_effect_forcestaff.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_snapfire/hero_snapfire_shotgun_debuff.vpcf", context )
PrecacheResource( "particle", "particles/status_fx/status_effect_snapfire_slow.vpcf", context )

end


function sniper_take_aim_custom:GetCooldown(iLevel)
if self:GetCaster():HasModifier("modifier_sniper_aim_7") or self:GetCaster():HasModifier("modifier_sniper_aim_6") then 
	return self:GetCaster():GetTalentValue("modifier_sniper_aim_7", "cd", true)
end

end


function sniper_take_aim_custom:GetIntrinsicModifierName()
return "modifier_sniper_take_aim_custom"
end



function sniper_take_aim_custom:GetCastRange(vLocation, hTarget)
if self:GetCaster():HasModifier("modifier_sniper_aim_6") then 
	if IsClient() then 
		return self:GetCaster():GetTalentValue("modifier_sniper_aim_6", "range")
	else 
		return 999999
	end
end

end

function sniper_take_aim_custom:GetBehavior()

if self:GetCaster():HasModifier("modifier_sniper_aim_6") then 
	return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_IMMEDIATE
else 

	if self:GetCaster():HasModifier("modifier_sniper_aim_7") then 
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE
	end

end

return DOTA_ABILITY_BEHAVIOR_PASSIVE
end




function sniper_take_aim_custom:OnSpellStart()
if not IsServer() then return end


if self:GetCaster():HasModifier('modifier_sniper_aim_7') then 

	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_sniper_take_aim_custom_legendary", {duration = self:GetCaster():GetTalentValue("modifier_sniper_aim_7", "duration")})

	local duration = self:GetCaster():GetTalentValue("modifier_sniper_aim_7", "illusions_duration")
	local damage = self:GetCaster():GetTalentValue("modifier_sniper_aim_7", "illusions_damage")
	local incoming = self:GetCaster():GetTalentValue("modifier_sniper_aim_7", "illusions_incoming") - 100


	local illusion = CreateIllusions( self:GetCaster(), self:GetCaster(), {duration=duration, outgoing_damage= -100 + damage,incoming_damage=incoming}, 1, 0, false, false )  
	for k, v in pairs(illusion) do

	    v.owner = self:GetCaster()

	    for _,mod in pairs(self:GetCaster():FindAllModifiers()) do
	        if mod.StackOnIllusion ~= nil and mod.StackOnIllusion == true then
	            v:UpgradeIllusion(mod:GetName(), mod:GetStackCount() )
	        end
	    end

	    FindClearSpaceForUnit(v, self:GetCaster():GetAbsOrigin(), true)

	    v.aim_illusion = true

		if self:GetCaster():IsMoving() then 

			v:AddNewModifier(self:GetCaster(), self, "modifier_sniper_take_aim_custom_legendary_disarm", {duration = FrameTime()*2})

			local forward_dir = self:GetCaster():GetForwardVector()

		    Timers:CreateTimer(FrameTime()*2, function() 
			    	v:MoveToPosition(self:GetCaster():GetAbsOrigin() + forward_dir*800)
			end)
		end
	end

	Timers:CreateTimer(FrameTime(), function()
		self:GetCaster():EmitSound("Sniper.Aim_legendary_cast")
	end)

end

if self:GetCaster():HasModifier("modifier_sniper_aim_6") then 

	local point = self:GetCaster():GetCursorPosition()
	if point == self:GetCaster():GetAbsOrigin() then 
		point = self:GetCaster():GetForwardVector()*10 + self:GetCaster():GetAbsOrigin()
	end

	local dir = (point - self:GetCaster():GetAbsOrigin()):Normalized()

	self:GetCaster():SetForwardVector(dir)
	self:GetCaster():FaceTowards(point)

	ProjectileManager:ProjectileDodge(self:GetCaster())

	self:GetCaster():EmitSound("Sniper.Aim_blink")

	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_sniper_take_aim_custom_blink_speed", {duration = self:GetCaster():GetTalentValue("modifier_sniper_aim_6", "speed")})
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_sniper_take_aim_custom_blink", {x = point.x, y = point.y, z = point.z, duration = self:GetCaster():GetTalentValue("modifier_sniper_aim_6", "duration")})

end



end




modifier_sniper_take_aim_custom = class({})
function modifier_sniper_take_aim_custom:IsHidden() return true end
function modifier_sniper_take_aim_custom:IsPurgable() return false end

function modifier_sniper_take_aim_custom:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_EVENT_ON_TAKEDAMAGE,
        MODIFIER_PROPERTY_MIN_HEALTH
    }
end



function modifier_sniper_take_aim_custom:GetMinHealth()
if not IsServer() then return end
if not self:GetParent():IsAlive() then return end
if not self:GetParent():HasModifier("modifier_sniper_aim_5") then return end
if self:GetParent():PassivesDisabled() then return end
if self:GetParent():HasModifier("modifier_death") then return end
if self:GetParent():HasModifier("modifier_sniper_take_aim_custom_shield_cd") then return end

return 1
end


function modifier_sniper_take_aim_custom:OnTakeDamage(params)
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_sniper_aim_5") then return end
if self:GetParent() ~= params.unit then return end
if self:GetParent():PassivesDisabled() then return end
if self:GetParent():HasModifier("modifier_death") then return end
if self:GetParent():HasModifier("modifier_sniper_take_aim_custom_shield_cd") then return end
if self:GetParent():GetHealthPercent() > self:GetAbility().shield_health then return end

self:GetParent():Purge(false, true, false, false, false)

self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_sniper_take_aim_custom_shield", {duration = self:GetAbility().shield_duration})
self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_sniper_take_aim_custom_shield_cd", {duration = self:GetAbility().shield_cd})

end






function modifier_sniper_take_aim_custom:OnAttackLanded(params)
if not IsServer() then return end



if self:GetParent() == params.target and self:GetParent():HasModifier("modifier_sniper_aim_1") and (params.attacker:IsHero() or params.attacker:IsCreep())
	and not self:GetParent():HasModifier("modifier_sniper_take_aim_custom_evasion_cd") then 

	self:GetParent():EmitSound("Sniper.Aim_evasion")

	self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_sniper_take_aim_custom_evasion_cd", {duration = self:GetAbility().evasion_cd})
	self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_sniper_take_aim_custom_evasion", {duration = self:GetAbility().evasion_duration})

end



if self:GetParent() ~= params.attacker then return end
if not params.target:IsHero() and not params.target:IsCreep() then return end


if self:GetParent():HasModifier("modifier_sniper_aim_3") and (self:GetParent():GetAbsOrigin() - params.target:GetAbsOrigin()):Length2D() >= self:GetAbility().range_distance then 
	params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_sniper_take_aim_custom_slow", {duration = self:GetAbility().range_slow_duration})
end

if (self:GetParent():HasModifier("modifier_sniper_aim_7") or self:GetParent():HasModifier("modifier_sniper_aim_6")) and self:GetAbility():GetCooldownTimeRemaining() > 0 then 
	self:GetParent():CdAbility(self:GetAbility(), self:GetCaster():GetTalentValue("modifier_sniper_aim_7", "cd_inc", true))
end

end





function modifier_sniper_take_aim_custom:OnCreated(table)

self.range = self:GetAbility():GetSpecialValueFor("bonus_attack_range")
self.move = self:GetAbility():GetSpecialValueFor("bonus_movespeed")
end

function modifier_sniper_take_aim_custom:OnRefresh(table)

self:OnCreated(table)
end


function modifier_sniper_take_aim_custom:GetModifierMoveSpeedBonus_Constant()
return self.move
end


function modifier_sniper_take_aim_custom:GetModifierAttackRangeBonus()
local bonus = 0


return self.range + bonus
end






modifier_sniper_take_aim_custom_legendary = class({})

function modifier_sniper_take_aim_custom_legendary:IsPurgable() return false end
function modifier_sniper_take_aim_custom_legendary:IsHidden() return false end


function modifier_sniper_take_aim_custom_legendary:OnCreated(table)
self.speed = self:GetCaster():GetTalentValue("modifier_sniper_aim_7", "speed")

if not IsServer() then return end

 --CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetCaster():GetPlayerOwnerID()), 'generic_sound',  {sound = "Sniper.Aim_legendary_cast"})
   
end


function modifier_sniper_take_aim_custom_legendary:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_ABILITY_EXECUTED,
    }
    return funcs
end




function modifier_sniper_take_aim_custom_legendary:OnAbilityExecuted( params )
if not IsServer() then return end
if not params.ability then return end
if not params.unit then return end
if params.unit ~= self:GetParent() then return end

self:Destroy()
end


function modifier_sniper_take_aim_custom_legendary:OnAttack(params)
if not IsServer() then return end
if not params.attacker then return end
if params.attacker ~= self:GetParent() then return end

self:Destroy()
end



function modifier_sniper_take_aim_custom_legendary:GetModifierMoveSpeedBonus_Percentage()
   return self.speed
end






function modifier_sniper_take_aim_custom_legendary:GetModifierInvisibilityLevel()
    return 1
end

function modifier_sniper_take_aim_custom_legendary:CheckState()
    return {
        [MODIFIER_STATE_INVISIBLE] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true
    }
end




modifier_sniper_take_aim_custom_legendary_disarm = class({})
function modifier_sniper_take_aim_custom_legendary_disarm:IsHidden() return true end
function modifier_sniper_take_aim_custom_legendary_disarm:IsPurgable() return false end
function modifier_sniper_take_aim_custom_legendary_disarm:CheckState()
return
{
	[MODIFIER_STATE_DISARMED] = true
}
end






modifier_sniper_take_aim_custom_blink_speed = class({})
function modifier_sniper_take_aim_custom_blink_speed:IsHidden() return false end
function modifier_sniper_take_aim_custom_blink_speed:IsPurgable() return true end
function modifier_sniper_take_aim_custom_blink_speed:GetTexture() return "buffs/aim_speed" end
function modifier_sniper_take_aim_custom_blink_speed:GetEffectName() 
  return "particles/items3_fx/blink_swift_buff.vpcf" 
end



function modifier_sniper_take_aim_custom_blink_speed:CheckState()
return
{
    [MODIFIER_STATE_UNSLOWABLE] = true
}
end





modifier_sniper_take_aim_custom_blink = class({})

function modifier_sniper_take_aim_custom_blink:IsDebuff() return false end
function modifier_sniper_take_aim_custom_blink:IsHidden() return true end
function modifier_sniper_take_aim_custom_blink:IsPurgable() return true end

function modifier_sniper_take_aim_custom_blink:OnCreated(kv)
    if not IsServer() then return end
    self.pfx = ParticleManager:CreateParticle("particles/items_fx/force_staff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
    self:GetParent():StartGesture(ACT_DOTA_RUN)

    self.point = Vector(kv.x, kv.y, kv.z)


    self.angle = self:GetParent():GetForwardVector():Normalized()--(self.point - self:GetParent():GetAbsOrigin()):Normalized() 

    self.distance = self:GetCaster():GetTalentValue("modifier_sniper_aim_6", "range") / ( self:GetDuration() / FrameTime())

    self.targets = {}

    if self:ApplyHorizontalMotionController() == false then
        self:Destroy()
    end
end

function modifier_sniper_take_aim_custom_blink:DeclareFunctions()
return
{
 MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
    MODIFIER_PROPERTY_DISABLE_TURNING
}
end

function modifier_sniper_take_aim_custom_blink:GetActivityTranslationModifiers()
    return "haste"
end


function modifier_sniper_take_aim_custom_blink:GetModifierDisableTurning() return 1 end

function modifier_sniper_take_aim_custom_blink:GetEffectName() return "particles/sniper_aim_blink.vpcf" end
function modifier_sniper_take_aim_custom_blink:GetStatusEffectName() return "particles/status_fx/status_effect_forcestaff.vpcf" end
function modifier_sniper_take_aim_custom_blink:StatusEffectPriority() return 100 end

function modifier_sniper_take_aim_custom_blink:OnDestroy()
    if not IsServer() then return end
    self:GetParent():InterruptMotionControllers( true )
    ParticleManager:DestroyParticle(self.pfx, false)
    ParticleManager:ReleaseParticleIndex(self.pfx)

    self:GetParent():FadeGesture(ACT_DOTA_RUN)
   -- self:GetParent():StartGesture(ACT_DOTA_FORCESTAFF_END)

 
    local dir = self:GetParent():GetForwardVector()
    dir.z = 0
    self:GetParent():SetForwardVector(dir)
    self:GetParent():FaceTowards(self:GetParent():GetAbsOrigin() + dir*10)

    ResolveNPCPositions(self:GetParent():GetAbsOrigin(), 128)

end


function modifier_sniper_take_aim_custom_blink:UpdateHorizontalMotion( me, dt )
    if not IsServer() then return end
    local pos = self:GetParent():GetAbsOrigin()
    GridNav:DestroyTreesAroundPoint(pos, 80, false)
    local pos_p = self.angle * self.distance
    local next_pos = GetGroundPosition(pos + pos_p,self:GetParent())
    self:GetParent():SetAbsOrigin(next_pos)


end

function modifier_sniper_take_aim_custom_blink:OnHorizontalMotionInterrupted()
    self:Destroy()
end



modifier_sniper_take_aim_custom_agility = class({})
function modifier_sniper_take_aim_custom_agility:IsHidden() return self:GetStackCount() == 1 end
function modifier_sniper_take_aim_custom_agility:IsPurgable() return false end
function modifier_sniper_take_aim_custom_agility:RemoveOnDeath() return false end
function modifier_sniper_take_aim_custom_agility:GetTexture() return "buffs/aim_agility" end
function modifier_sniper_take_aim_custom_agility:OnCreated(table)
if not IsServer() then return end

self.agi = 0
self.particle = nil

self:OnIntervalThink()
self:StartIntervalThink(0.1)
end

function modifier_sniper_take_aim_custom_agility:OnIntervalThink()
if not IsServer() then return end

local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self:GetAbility().agility_range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, 0, false)

if #enemies > 0 or not self:GetParent():IsAlive() then 
	self:SetStackCount(1)

	if self.particle then 
		ParticleManager:DestroyParticle(self.particle, false)
		ParticleManager:ReleaseParticleIndex(self.particle)

		self.particle = nil
	end


else
	self:SetStackCount(0)


	if self.particle == nil then 

		self.particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_oracle/oracle_purifyingflames.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		self:AddParticle(self.particle, false, false, -1, false, false)
	end

	self.agi  = 0
	self.agi   = self:GetParent():GetAgility() * self:GetAbility().agility_bonus[self:GetCaster():GetUpgradeStack("modifier_sniper_aim_4")]
	self:GetParent():CalculateStatBonus(true)
end

end




function modifier_sniper_take_aim_custom_agility:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
	MODIFIER_PROPERTY_TOOLTIP
}

end


function modifier_sniper_take_aim_custom_agility:GetModifierHealthRegenPercentage()
if self:GetStackCount() == 1 then return end

return self:GetAbility().agility_regen[self:GetCaster():GetUpgradeStack('modifier_sniper_aim_4')]

end

function modifier_sniper_take_aim_custom_agility:GetModifierBonusStats_Agility()
if self:GetStackCount() == 1 then return end
return self.agi
end

function modifier_sniper_take_aim_custom_agility:OnTooltip()
return self:GetAbility().agility_bonus[self:GetCaster():GetUpgradeStack("modifier_sniper_aim_4")]*100
end




modifier_sniper_take_aim_custom_evasion = class({})
function modifier_sniper_take_aim_custom_evasion:IsHidden() return false end
function modifier_sniper_take_aim_custom_evasion:IsPurgable() return true end
function modifier_sniper_take_aim_custom_evasion:GetTexture() return 'buffs/aim_evasion' end
function modifier_sniper_take_aim_custom_evasion:GetEffectName() 
  return "particles/items3_fx/blink_swift_buff.vpcf" 
end

function modifier_sniper_take_aim_custom_evasion:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	MODIFIER_PROPERTY_EVASION_CONSTANT,
}

end



function modifier_sniper_take_aim_custom_evasion:GetModifierMoveSpeedBonus_Percentage()
return self:GetAbility().evasion_speed[self:GetCaster():GetUpgradeStack("modifier_sniper_aim_1")]
end

function modifier_sniper_take_aim_custom_evasion:GetModifierEvasion_Constant()
return self:GetAbility().evasion_bonus[self:GetCaster():GetUpgradeStack("modifier_sniper_aim_1")]
end


modifier_sniper_take_aim_custom_evasion_cd = class({})
function modifier_sniper_take_aim_custom_evasion_cd:IsHidden() return false end
function modifier_sniper_take_aim_custom_evasion_cd:IsPurgable() return false end
function modifier_sniper_take_aim_custom_evasion_cd:IsDebuff() return true end
function modifier_sniper_take_aim_custom_evasion_cd:RemoveOnDeath() return false end
function modifier_sniper_take_aim_custom_evasion_cd:GetTexture() return "buffs/aim_evasion" end
function modifier_sniper_take_aim_custom_evasion_cd:OnCreated(table)

self.RemoveForDuel = true
end



modifier_sniper_take_aim_custom_attack_speed = class({})

function modifier_sniper_take_aim_custom_attack_speed:IsHidden() return (self:GetStackCount() == 1) end
function modifier_sniper_take_aim_custom_attack_speed:IsPurgable() return false end
function modifier_sniper_take_aim_custom_attack_speed:GetTexture() return "buffs/aim_attack" end
function modifier_sniper_take_aim_custom_attack_speed:RemoveOnDeath() return false end

function modifier_sniper_take_aim_custom_attack_speed:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }
end

function modifier_sniper_take_aim_custom_attack_speed:OnCreated(table)
if not IsServer() then return end

if self:GetParent():IsRealHero() then 
	self:SetStackCount(0)
	self:Activate()
else 
	local caster = self:GetParent().owner
	local mod 


	if caster then 
		mod = caster:FindModifierByName("modifier_sniper_take_aim_custom_attack_speed")
	else 
		return
	end

	self:SetStackCount(mod:GetStackCount())
	if mod:GetStackCount() == 0 then 
		self:Activate(true)
	end

end

self:StartIntervalThink(self:GetAbility().attack_timer)
end



function modifier_sniper_take_aim_custom_attack_speed:OnAttackLanded(params)
if not IsServer() then return end

if self:GetParent():HasModifier("modifier_sniper_aim_2") and self:GetParent() == params.target and (params.attacker:IsHero() or params.attacker:IsCreep()) then 
	self:SetStackCount(1)

	if self.particle then 
		ParticleManager:DestroyParticle(self.particle, true)
		ParticleManager:ReleaseParticleIndex(self.particle)
		self.particle = nil
	end

	self:StartIntervalThink(self:GetAbility().attack_timer)
end


end


function modifier_sniper_take_aim_custom_attack_speed:GetModifierAttackSpeedBonus_Constant()
if self:GetStackCount() == 1 then return end
if not self:GetParent():HasModifier("modifier_sniper_aim_2") then return end
if not self:GetAbility() then return end

return self:GetAbility().attack_speed[self:GetParent():GetUpgradeStack("modifier_sniper_aim_2")]
end



function modifier_sniper_take_aim_custom_attack_speed:OnIntervalThink()
if not IsServer() then return end
if self:GetStackCount() == 0 then return end

self:SetStackCount(0)

self:Activate()

self:StartIntervalThink(-1)
end




function modifier_sniper_take_aim_custom_attack_speed:Activate(no_sound)
if not IsServer() then return end
if self:GetParent():IsIllusion() and not self:GetParent():IsAlive() then return end

if self.particle == nil then 

	self.particle = ParticleManager:CreateParticle( "particles/lc_odd_proc_hands.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	self:AddParticle(self.particle, false, false, -1, false, false)

end

if no_sound then return end

self:GetParent():EmitSound("Sniper.Aim_attack")
end



modifier_sniper_take_aim_custom_slow = class({})
function modifier_sniper_take_aim_custom_slow:IsHidden() return false end
function modifier_sniper_take_aim_custom_slow:IsPurgable() return true end
function modifier_sniper_take_aim_custom_slow:GetTexture() return "buffs/aim_slow" end
function modifier_sniper_take_aim_custom_slow:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
}
end

function modifier_sniper_take_aim_custom_slow:GetModifierMoveSpeedBonus_Percentage()
return self:GetAbility().range_slow[self:GetCaster():GetUpgradeStack("modifier_sniper_aim_3")]
end

function modifier_sniper_take_aim_custom_slow:GetModifierPhysicalArmorBonus()
return self:GetAbility().range_armor[self:GetCaster():GetUpgradeStack("modifier_sniper_aim_3")]
end

function modifier_sniper_take_aim_custom_slow:GetEffectName()
    return "particles/units/heroes/hero_snapfire/hero_snapfire_shotgun_debuff.vpcf"
end

function modifier_sniper_take_aim_custom_slow:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_sniper_take_aim_custom_slow:GetStatusEffectName()
    return "particles/status_fx/status_effect_snapfire_slow.vpcf"
end

function modifier_sniper_take_aim_custom_slow:StatusEffectPriority()
    return MODIFIER_PRIORITY_NORMAL
end




modifier_sniper_take_aim_custom_shield = class({})

function modifier_sniper_take_aim_custom_shield:IsHidden() return false end
function modifier_sniper_take_aim_custom_shield:IsPurgable() return false end
function modifier_sniper_take_aim_custom_shield:GetTexture() return "buffs/back_ground" end
function modifier_sniper_take_aim_custom_shield:OnCreated()

self.max_shield = self:GetParent():GetMaxHealth()*self:GetAbility().shield_durability
self:SetStackCount(self.max_shield)

if not IsServer() then return end

self:GetParent():EmitSound("Sniper.Aim_shield")
self:GetParent():EmitSound("Sniper.Aim_shield2")



self.particle = ParticleManager:CreateParticle("particles/sniper_matrix.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self:GetParent())
local position = self:GetParent():GetAbsOrigin()


ParticleManager:SetParticleControlEnt(  self.particle, 0, self:GetParent(), PATTACH_CENTER_FOLLOW , nil, self:GetParent():GetOrigin(), true )
ParticleManager:SetParticleControlEnt(self.particle, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", position, true)
self:AddParticle(self.particle, false, false, -1, false, false)

end




function modifier_sniper_take_aim_custom_shield:DeclareFunctions()
    local funcs = {
		MODIFIER_PROPERTY_REFLECT_SPELL,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_CONSTANT,
    }
    return funcs
end


function modifier_sniper_take_aim_custom_shield:GetModifierIncomingDamageConstant( params )


if IsClient() then 
	if params.report_max then 
		return self.max_shield 
	else 
		return self:GetStackCount()
	end
end

if not IsServer() then return end
if bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) == DOTA_DAMAGE_FLAG_HPLOSS then return end

self:GetParent():EmitSound("Sniper.Aim_shield_damage")

local forward = self:GetParent():GetAbsOrigin() - params.attacker:GetAbsOrigin()
forward.z = 0
forward = forward:Normalized()

local particle_2 = ParticleManager:CreateParticle("particles/sniper_shield_hit.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent())
ParticleManager:SetParticleControlEnt(particle_2, 0, self:GetParent(), PATTACH_POINT, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
ParticleManager:SetParticleControl(particle_2, 1, self:GetParent():GetAbsOrigin())
ParticleManager:SetParticleControlForward(particle_2, 1, forward)
ParticleManager:SetParticleControlEnt(particle_2, 2, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetAbsOrigin(), false)
ParticleManager:ReleaseParticleIndex(particle_2)

if self:GetStackCount() > params.damage then
    self:SetStackCount(self:GetStackCount() - params.damage)
    local i = params.damage
    return -i
else
    
    local i = self:GetStackCount()
    self:SetStackCount(0)
    self:Destroy()
    return -i
end

end





modifier_sniper_take_aim_custom_shield_cd = class({})

function modifier_sniper_take_aim_custom_shield_cd:IsHidden() return false end
function modifier_sniper_take_aim_custom_shield_cd:IsPurgable() return false end
function modifier_sniper_take_aim_custom_shield_cd:GetTexture() return "buffs/back_ground" end
function modifier_sniper_take_aim_custom_shield_cd:IsDebuff() return true end
function modifier_sniper_take_aim_custom_shield_cd:RemoveOnDeath() return false end
function modifier_sniper_take_aim_custom_shield_cd:OnCreated(table)
self.RemoveForDuel = true
end