LinkLuaModifier("modifier_troll_warlord_whirling_axes_ranged_custom", "abilities/troll_warlord/troll_warlord_whirling_axes_ranged_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_troll_warlord_whirling_axes_attack", "abilities/troll_warlord/troll_warlord_whirling_axes_melee_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_troll_warlord_whirling_axes_ranged_quest", "abilities/troll_warlord/troll_warlord_whirling_axes_ranged_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_troll_warlord_whirling_axes_heal_reduce", "abilities/troll_warlord/troll_warlord_whirling_axes_ranged_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_troll_warlord_whirling_axes_heal_cd", "abilities/troll_warlord/troll_warlord_whirling_axes_ranged_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_troll_warlord_whirling_axes_ranged_cd", "abilities/troll_warlord/troll_warlord_whirling_axes_ranged_custom", LUA_MODIFIER_MOTION_NONE)





troll_warlord_whirling_axes_ranged_custom = class({})






function troll_warlord_whirling_axes_ranged_custom:GetAbilityTargetFlags()
if self:GetCaster():HasScepter() then 
	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
else 
	return DOTA_UNIT_TARGET_FLAG_NONE
end

end


function troll_warlord_whirling_axes_ranged_custom:Precache(context)

    
PrecacheResource( "particle", "particles/troll_ranged.vpcf", context )
PrecacheResource( "particle", "particles/sf_refresh_a.vpcf", context )
end


function troll_warlord_whirling_axes_ranged_custom:OnAbilityPhaseStart()
	if self:GetCaster():HasModifier("modifier_troll_warlord_battle_trance_custom") or self:GetCaster():HasModifier("modifier_troll_axes_5") then
		self:SetOverrideCastPoint(0)
	else
		self:SetOverrideCastPoint(0.2)
	end
	
	return true
end

function troll_warlord_whirling_axes_ranged_custom:GetCooldown(level)
local bonus = 0

if self:GetCaster():HasModifier("modifier_troll_axes_1") then
	bonus = self:GetCaster():GetTalentValue("modifier_troll_axes_1", "cd")
end

return self.BaseClass.GetCooldown( self, level ) + bonus
end

function troll_warlord_whirling_axes_ranged_custom:GetCastRange(location, target)
    return self.BaseClass.GetCastRange(self, location, target)
end




function troll_warlord_whirling_axes_ranged_custom:GetManaCost(level)

local bonus = 0

if self:GetCaster():HasModifier("modifier_troll_axes_1") then
	bonus = self:GetCaster():GetTalentValue("modifier_troll_axes_1", "mana")
end

return self.BaseClass.GetManaCost(self, level) + bonus

end

function troll_warlord_whirling_axes_ranged_custom:OnSpellStart(new_target)
	if not IsServer() then return end
	local point = self:GetCursorPosition()

	if self:GetCursorTarget() ~= nil then 
		point = self:GetCursorTarget():GetAbsOrigin()
	end

	if new_target ~= nil then 
		point = new_target:GetAbsOrigin()
	end

		
	if self:GetCaster():HasModifier("modifier_troll_warlord_berserkers_rage_custom") then 

		local ability = self:GetCaster():FindAbilityByName("troll_warlord_berserkers_rage_custom")

		if ability and ability:IsTrained() then 
			ability:ToggleAbility()
		end 
	end 

	local meel_ability = self:GetCaster():FindAbilityByName("troll_warlord_whirling_axes_melee_custom")

	if self:GetCaster():HasModifier("modifier_troll_axes_3") then 
		self:GetCaster():AddNewModifier(self:GetCaster(), meel_ability, "modifier_troll_warlord_whirling_axes_attack", {duration = self:GetCaster():GetTalentValue("modifier_troll_axes_3", "duration")})
	end

	local caster_abs = self:GetCaster():GetAbsOrigin()
	local axe_width = self:GetSpecialValueFor("axe_width")
	local axe_speed = self:GetSpecialValueFor("axe_speed")
	local axe_range = self:GetSpecialValueFor("axe_range") + self:GetCaster():GetCastRangeBonus()
	local axe_damage = self:GetSpecialValueFor("axe_damage")
	local duration = self:GetSpecialValueFor("axe_slow_duration")
	local axe_spread = self:GetSpecialValueFor("axe_spread")
	local axe_count = self:GetSpecialValueFor("axe_count")

	local legen_mod = self:GetCaster():FindModifierByName("modifier_troll_warlord_whirling_axes_melee_custom_stack")
	local epic_mod = self:GetCaster():FindModifierByName("modifier_troll_warlord_whirling_axes_perma_ranged")

	if not legen_mod then 
		legen_mod = self:GetCaster():FindModifierByName("modifier_troll_warlord_whirling_axes_ranged_custom_stack")
	end 

	if epic_mod and self:GetCaster():HasModifier("modifier_troll_axes_4") then 
		axe_damage = axe_damage + epic_mod:GetStackCount()*self:GetCaster():GetTalentValue("modifier_troll_axes_4", "damage")
	end 

	if legen_mod then 
		axe_damage = axe_damage*(1 + legen_mod:GetStackCount()*self:GetCaster():GetTalentValue("modifier_troll_axes_legendary", "damage")/100)
	end



	local stun = 0


	local particle = "particles/troll_ranged.vpcf"
	local stun_mod = self:GetCaster():FindModifierByName("modifier_troll_warlord_whirling_axes_perma_ranged")

	if stun_mod and not self:GetCaster():HasModifier("modifier_troll_warlord_whirling_axes_ranged_cd")
	 and self:GetCaster():HasModifier("modifier_troll_axes_4") and stun_mod:GetStackCount() >= self:GetCaster():GetTalentValue("modifier_troll_axes_4", "max") then 
		
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_troll_warlord_whirling_axes_ranged_cd", {duration = self:GetCaster():GetTalentValue("modifier_troll_axes_4", "cd")})
		particle = "particles/troll_ranged_legen.vpcf"
		stun = 1
	
	end


	local direction
	if point == caster_abs then
		direction = self:GetCaster():GetForwardVector()
	else
		direction = (point - caster_abs):Normalized()
	end

	self:GetCaster():EmitSound("Hero_TrollWarlord.WhirlingAxes.Ranged")
	local index = DoUniqueString("index")
	self[index] = {}

	local start_angle
	local interval_angle = 0

	start_angle = axe_spread / 2 * (-1)
	interval_angle = axe_spread / (axe_count - 1)

	for i=1, axe_count do
		local angle = start_angle + (i-1) * interval_angle
		local velocity = RotateVector2D(direction,angle,true) * axe_speed

		local projectile =
			{
				Ability				= self,
				EffectName			= particle,
				vSpawnOrigin		= caster_abs,
				fDistance			= axe_range,
				fStartRadius		= axe_width,
				fEndRadius			= axe_width,
				Source				= self:GetCaster(),
				bHasFrontalCone		= false,
				bReplaceExisting	= false,
				iUnitTargetTeam		= self:GetAbilityTargetTeam(),
				iUnitTargetFlags	= self:GetAbilityTargetFlags(),
				iUnitTargetType		= self:GetAbilityTargetType(),
				fExpireTime 		= GameRules:GetGameTime() + 10.0,
				bDeleteOnHit		= false,
				vVelocity			= Vector(velocity.x,velocity.y,0),
				bProvidesVision		= false,
				ExtraData			= {index = index, damage = axe_damage, duration = duration, axe_count = axe_count, on_hit_pct = on_hit_pct, stun = stun}
			}
		ProjectileManager:CreateLinearProjectile(projectile)
	end
end

function troll_warlord_whirling_axes_ranged_custom:OnProjectileHit_ExtraData(target, location, ExtraData)
if target then
	local was_hit = false
	for _, stored_target in ipairs(self[ExtraData.index]) do
		if target == stored_target then
			was_hit = true
			break
		end
	end
	if was_hit then return end
	table.insert(self[ExtraData.index],target)


	local current_damage = ExtraData.damage


	if ExtraData.stun == 1 then 
		target:EmitSound("BB.Goo_stun")
		target:ApplyStun(self, self:GetCaster():HasScepter(), self:GetCaster(), (1 - target:GetStatusResistance())*self:GetCaster():GetTalentValue("modifier_troll_axes_4", "stun"))
	end



	if self:GetCaster():GetQuest() == "Troll.Quest_6" and target:IsRealHero() then 

		local mod = target:FindModifierByName("modifier_troll_warlord_whirling_axes_melee_quest")
		if mod then 
			mod:Destroy()
			self:GetCaster():UpdateQuest(1)
		else 
			target:AddNewModifier(self:GetCaster(), self, "modifier_troll_warlord_whirling_axes_ranged_quest", {duration = self:GetCaster().quest.number})
		end

	end


	if self:GetCaster():HasModifier("modifier_troll_axes_5") and not target:HasModifier("modifier_troll_warlord_whirling_axes_heal_cd") and not target:IsMagicImmune() then 

		target:AddNewModifier(self:GetCaster(), self, "modifier_troll_warlord_whirling_axes_heal_cd", {duration = self:GetCaster():GetTalentValue("modifier_troll_axes_5", "cd")})

		local vec = (target:GetAbsOrigin() - self:GetCaster():GetAbsOrigin())
		local dist = math.max(0, math.min(vec:Length2D() - 120, self:GetCaster():GetTalentValue("modifier_troll_axes_5", "distance")))
		local duration = self:GetCaster():GetTalentValue("modifier_troll_axes_5", "duration")
		local center = target:GetAbsOrigin() + 10*vec:Normalized()


		local knockback =	
		{
		    should_stun = 0,
		    knockback_duration = duration,
		    duration = duration,
		    knockback_distance = dist,
		    knockback_height = 0,
		    center_x = center.x,
		    center_y = center.y,
		    center_z = center.z,
		}


		target:AddNewModifier(self:GetCaster(),self:GetCaster():BkbAbility(self, self:GetCaster():HasScepter()),"modifier_knockback",knockback)

	end

	ApplyDamage({victim = target, attacker = self:GetCaster(), ability = self, damage = current_damage, damage_type = self:GetAbilityDamageType()})


	target:AddNewModifier(self:GetCaster(), self:GetCaster():BkbAbility(self, self:GetCaster():HasScepter()), "modifier_troll_warlord_whirling_axes_ranged_custom", {duration = ExtraData.duration * (1 - target:GetStatusResistance())})
	target:EmitSound("Hero_TrollWarlord.WhirlingAxes.Target")
	if self:GetCaster():HasScepter() then
		target:Purge(true, false, false, false, false)
	end
else
	self[ExtraData.index]["count"] = self[ExtraData.index]["count"] or 0
	self[ExtraData.index]["count"] = self[ExtraData.index]["count"] + 1
	if self[ExtraData.index]["count"] == ExtraData.axe_count then
		self[ExtraData.index] = nil
	end
end


end

modifier_troll_warlord_whirling_axes_ranged_custom = class({})

function modifier_troll_warlord_whirling_axes_ranged_custom:GetTexture() return "troll_warlord_whirling_axes_ranged" end
function modifier_troll_warlord_whirling_axes_ranged_custom:IsPurgable() return not self:GetCaster():HasScepter() end
function modifier_troll_warlord_whirling_axes_ranged_custom:IsPurgeException() return false end

function modifier_troll_warlord_whirling_axes_ranged_custom:DeclareFunctions()
	return 
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	    MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
	    MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
	    MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE
	}
end



function modifier_troll_warlord_whirling_axes_ranged_custom:GetModifierLifestealRegenAmplify_Percentage() 
return self.reduce
end

function modifier_troll_warlord_whirling_axes_ranged_custom:GetModifierHealAmplify_PercentageTarget() 
return self.reduce
end

function modifier_troll_warlord_whirling_axes_ranged_custom:GetModifierHPRegenAmplify_Percentage() 
return self.reduce
end





function modifier_troll_warlord_whirling_axes_ranged_custom:OnCreated()

self.ability = self:GetCaster():FindAbilityByName("troll_warlord_whirling_axes_ranged_custom")
self.reduce = self:GetCaster():GetTalentValue("modifier_troll_axes_2", "heal_reduce")
if not self.ability then self:Destroy() return end

self.slow = self.ability:GetSpecialValueFor("movement_speed") * (-1) + self:GetCaster():GetTalentValue("modifier_troll_axes_5", "slow")

end

function modifier_troll_warlord_whirling_axes_ranged_custom:GetModifierMoveSpeedBonus_Percentage()
	return self.slow
end








function RotateVector2D(v,angle,bIsDegree)
    if bIsDegree then angle = math.rad(angle) end
    local xp = v.x * math.cos(angle) - v.y * math.sin(angle)
    local yp = v.x * math.sin(angle) + v.y * math.cos(angle)

    return Vector(xp,yp,v.z):Normalized()
end





modifier_troll_warlord_whirling_axes_ranged_quest = class({})
function modifier_troll_warlord_whirling_axes_ranged_quest:IsHidden() return true end
function modifier_troll_warlord_whirling_axes_ranged_quest:IsPurgable() return false end


modifier_troll_warlord_whirling_axes_heal_reduce = class({})
function modifier_troll_warlord_whirling_axes_heal_reduce:IsHidden() return true end
function modifier_troll_warlord_whirling_axes_heal_reduce:IsPurgable() return false end
function modifier_troll_warlord_whirling_axes_heal_reduce:GetTexture() return "buffs/arcane_regen" end




modifier_troll_warlord_whirling_axes_heal_cd = class({})
function modifier_troll_warlord_whirling_axes_heal_cd:IsHidden() return true end
function modifier_troll_warlord_whirling_axes_heal_cd:IsPurgable() return false end
function modifier_troll_warlord_whirling_axes_heal_cd:RemoveOnDeath() return false end


modifier_troll_warlord_whirling_axes_ranged_cd = class({})
function modifier_troll_warlord_whirling_axes_ranged_cd:IsHidden() return true end
function modifier_troll_warlord_whirling_axes_ranged_cd:IsPurgable() return false end
function modifier_troll_warlord_whirling_axes_ranged_cd:RemoveOnDeath() return false end
function modifier_troll_warlord_whirling_axes_ranged_cd:OnCreated()
self.RemoveForDuel = true
end