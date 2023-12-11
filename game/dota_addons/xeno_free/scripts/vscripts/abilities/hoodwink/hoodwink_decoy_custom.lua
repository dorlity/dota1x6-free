LinkLuaModifier( "modifier_hoodwink_decoy_custom_illusion", "abilities/hoodwink/hoodwink_decoy_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hoodwink_decoy_custom_thinker", "abilities/hoodwink/hoodwink_decoy_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hoodwink_decoy_custom_debuff", "abilities/hoodwink/hoodwink_decoy_custom", LUA_MODIFIER_MOTION_HORIZONTAL )
LinkLuaModifier( "modifier_hoodwink_scurry_custom_buff", "abilities/hoodwink/hoodwink_scurry_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hoodwink_bushwhack_custom_debuff", "abilities/hoodwink/hoodwink_bushwhack_custom", LUA_MODIFIER_MOTION_HORIZONTAL )
LinkLuaModifier( "modifier_hoodwink_sharpshooter_custom", "abilities/hoodwink/hoodwink_sharpshooter_custom", LUA_MODIFIER_MOTION_NONE )


hoodwink_decoy_custom = class({})

function hoodwink_decoy_custom:OnInventoryContentsChanged()

	if self:GetCaster():HasScepter() then
		self:SetHidden(false)		
		if not self:IsTrained() then
			self:SetLevel(1)
		end
	else
		self:SetHidden(true)
	end
end


function hoodwink_decoy_custom:Precache(context)

    
PrecacheResource( "particle", "particles/units/heroes/hero_hoodwink/hoodwink_sharpshooter_range_finder.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_hoodwink/hoodwink_bushwhack_projectile.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_hoodwink/hoodwink_bushwhack_fail.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_hoodwink/hoodwink_bushwhack.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_hoodwink/hoodwink_bushwhack_target.vpcf", context )
PrecacheResource( "particle", "particles/tree_fx/tree_simple_explosion.vpcf", context )

end









function hoodwink_decoy_custom:OnHeroCalculateStatBonus()
	self:OnInventoryContentsChanged()
end

function hoodwink_decoy_custom:OnSpellStart()
	if not IsServer() then return end
	local point = self:GetCursorPosition()
	local duration = self:GetSpecialValueFor("duration")
	local damage_out = self:GetSpecialValueFor("images_do_damage_percent")
	local damage_in = self:GetSpecialValueFor("images_take_damage_percent")
	local illusion = CreateIllusions( self:GetCaster(), self:GetCaster(), {duration=duration,outgoing_damage=damage_out,incoming_damage=damage_in}, 1, 0, false, false )  
	local scurry_ability = self:GetCaster():FindAbilityByName("hoodwink_scurry_custom")      
   
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_hoodwink_decoy_invisibility", {duration = duration})

    for k, v in pairs(illusion) do
    	v:AddNewModifier(self:GetCaster(), scurry_ability, "modifier_hoodwink_scurry_custom_buff", {duration = scurry_ability:GetSpecialValueFor("duration")})
    	v:AddNewModifier(self:GetCaster(), self, "modifier_hoodwink_decoy_custom_illusion", {})
    	v:SetAbsOrigin(self:GetCaster():GetAbsOrigin())

		v.owner = self:GetCaster()	

	    for _,mod in pairs(self:GetCaster():FindAllModifiers()) do
          if mod.StackOnIllusion ~= nil and mod.StackOnIllusion == true then
            v:UpgradeIllusion(mod:GetName(), mod:GetStackCount() )
          end
        end

        local ability = self:GetCaster():FindAbilityByName("hoodwink_sharpshooter_custom")
        if ability then
        	local origin = v:GetAbsOrigin() + v:GetForwardVector()
        	v:AddNewModifier( self:GetCaster(), ability, "modifier_hoodwink_sharpshooter_custom", { duration = ability:GetSpecialValueFor( "misfire_time" ), x = origin.x, y = origin.y, } )
        	v:StartGesture(ACT_DOTA_CHANNEL_ABILITY_6)
        end
    end 


end


modifier_hoodwink_decoy_custom_illusion = class({})

function modifier_hoodwink_decoy_custom_illusion:IsHidden() return true end

function modifier_hoodwink_decoy_custom_illusion:OnCreated()
	if not IsServer() then return end
	self:StartIntervalThink(FrameTime())
	self.ability = nil

	local ability = self:GetCaster():FindAbilityByName("hoodwink_sharpshooter_custom")
    if ability and ability:GetLevel() > 0 then
    	self.ability = ability
    	self:EffectVisual()
    end
end

function modifier_hoodwink_decoy_custom_illusion:OnIntervalThink()
	if not IsServer() then return end
	local radius = self:GetCaster():FindAbilityByName("hoodwink_sharpshooter_custom"):GetSpecialValueFor("arrow_range")
	local units = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
		
	if #units <= 0 then
		units = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
	end

	if #units > 0 then
		local modifier = self:GetParent():FindModifierByName("modifier_hoodwink_sharpshooter_custom")
		if modifier then
			if self.ability ~= nil and self.ability:GetLevel() > 0 then
				self:UpdateEffect()
				modifier:IllusionScepterDirection(units[1])
				self:UpdateEffect()
			end
		else
			if self.particle then
				ParticleManager:DestroyParticle(self.particle, true)
				ParticleManager:ReleaseParticleIndex(self.particle)
				self.particle = nil
			end
		end
	end
end

function modifier_hoodwink_decoy_custom_illusion:EffectVisual()
	local startpos = self:GetParent():GetAbsOrigin()
	local endpos = startpos + self:GetParent():GetForwardVector() * self.ability:GetSpecialValueFor( "arrow_range" )

	self.particle = ParticleManager:CreateParticleForPlayer( "particles/units/heroes/hero_hoodwink/hoodwink_sharpshooter_range_finder.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent(), self:GetParent():GetPlayerOwner() )
	ParticleManager:SetParticleControl( self.particle, 0, startpos )
	ParticleManager:SetParticleControl( self.particle, 1, endpos )

	self:AddParticle( self.particle, false, false, -1, false, false  )
end

function modifier_hoodwink_decoy_custom_illusion:UpdateEffect()
	local startpos = self:GetParent():GetAbsOrigin()
	local endpos = startpos + self:GetParent():GetForwardVector() * self.ability:GetSpecialValueFor( "arrow_range" )
	ParticleManager:SetParticleControl( self.particle, 1, endpos )
end

function modifier_hoodwink_decoy_custom_illusion:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_EVENT_ON_ABILITY_EXECUTED,
    }

    return funcs
end

function modifier_hoodwink_decoy_custom_illusion:CheckState()
	return {
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
	}
end

function modifier_hoodwink_decoy_custom_illusion:OnAbilityExecuted( params )
    if not IsServer() then return end
    local hAbility = params.ability
    if hAbility == nil then
        return 0
    end
    if params.target and params.target == self:GetParent() then
    	self:UseBushwhack( params.unit, self:GetParent() )
    	self:GetParent():RemoveModifierByName("modifier_hoodwink_sharpshooter_custom")
    	self:Destroy()
    	self:GetParent():Kill(nil, self:GetParent())
    	return
    end    
end

function modifier_hoodwink_decoy_custom_illusion:OnAttackLanded( params )
    if not IsServer() then return end
    if params.target == self:GetParent() and params.attacker ~= self:GetParent() then
    	self:UseBushwhack( params.attacker, self:GetParent() )
        self:GetParent():RemoveModifierByName("modifier_hoodwink_sharpshooter_custom")
        self:Destroy()
        self:GetParent():Kill(nil, nil)
    end
end

function modifier_hoodwink_decoy_custom_illusion:UseBushwhack( target, parent )
    local tree = CreateTempTreeWithModel( target:GetAbsOrigin(), 20, "models/heroes/hoodwink/hoodwink_tree_model.vmdl" )
	tree:SetSequence("hoodwink_tree_spawn")
	tree:SetSequence("hoodwink_tree_idle")

    local projectile_speed = self:GetAbility():GetSpecialValueFor( "projectile_speed" )
	local delay = (target:GetAbsOrigin()-parent:GetOrigin()):Length2D()/projectile_speed
	local target = CreateModifierThinker( self:GetCaster(), self:GetAbility(), "modifier_hoodwink_decoy_custom_thinker", {origin_x = parent:GetAbsOrigin().x, origin_y = parent:GetAbsOrigin().y, duration = delay, hero = self:GetCaster():entindex() }, target:GetAbsOrigin(), parent:GetTeamNumber(), false )
end

modifier_hoodwink_decoy_custom_thinker = class({})

function modifier_hoodwink_decoy_custom_thinker:IsHidden()
	return false
end

function modifier_hoodwink_decoy_custom_thinker:IsPurgable()
	return true
end

function modifier_hoodwink_decoy_custom_thinker:OnCreated( kv )
	if not IsServer() then return end
	self.hero = EntIndexToHScript(kv.hero)
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.duration = self:GetAbility():GetSpecialValueFor( "decoy_stun_duration" )
	self.speed = self:GetAbility():GetSpecialValueFor( "projectile_speed" )
	self.radius = self:GetAbility():GetSpecialValueFor( "decoy_detonate_radius" )
	self.location = self:GetParent():GetOrigin()
	self.origin = GetGroundPosition(Vector(kv.origin_x, kv.origin_y, 0) , nil)
	local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_hoodwink/hoodwink_bushwhack_projectile.vpcf", PATTACH_WORLDORIGIN, self:GetParent() )
	ParticleManager:SetParticleControl( particle, 0, self.origin + Vector(0,0,50) )
	ParticleManager:SetParticleControl( particle, 1, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( particle, 2, Vector( self.speed, 0, 0 ) )
	self:AddParticle( particle, false, false, -1, false, false )
	self.caster:EmitSound("Hero_Hoodwink.Bushwhack.Cast")
	
	local bkb_enemies = FindUnitsInRadius( self.caster:GetTeamNumber(), self.location, nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
	
	for _,enemy in pairs(bkb_enemies) do
		if enemy:GetUnitName() ~= "npc_teleport" then 
			FindClearSpaceForUnit(enemy, enemy:GetAbsOrigin(), true)
		end
	end

end

function modifier_hoodwink_decoy_custom_thinker:OnDestroy()
	if not IsServer() then return end
	AddFOWViewer( self.caster:GetTeamNumber(), self.location, self.radius, self.duration, false )

	local enemies = FindUnitsInRadius( self.caster:GetTeamNumber(), self.location, nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NO_INVIS, 0, false )


	if #enemies<1 then
		local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_hoodwink/hoodwink_bushwhack_fail.vpcf", PATTACH_WORLDORIGIN, nil )
		ParticleManager:SetParticleControl( particle, 0, self.location )
		ParticleManager:SetParticleControl( particle, 1, Vector( self.radius, 0, 0 ) )
		ParticleManager:ReleaseParticleIndex( particle )
		EmitSoundOnLocationWithCaster(self.location, "Hero_Hoodwink.Bushwhack.Impact", self.caster)
		EmitSoundOnLocationWithCaster(self.origin, "Hero_Hoodwink.Bushwhack.Cast", self.caster)
		self.caster:EmitSound()
		return
	end

	local trees = GridNav:GetAllTreesAroundPoint( self.location, self.radius, false )
	if #trees<1 then
		local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_hoodwink/hoodwink_bushwhack_fail.vpcf", PATTACH_WORLDORIGIN, nil )
		ParticleManager:SetParticleControl( particle, 0, self.location )
		ParticleManager:SetParticleControl( particle, 1, Vector( self.radius, 0, 0 ) )
		ParticleManager:ReleaseParticleIndex( particle )
		EmitSoundOnLocationWithCaster(self.origin, "Hero_Hoodwink.Bushwhack.Cast", self.caster)
		EmitSoundOnLocationWithCaster(self.location, "Hero_Hoodwink.Bushwhack.Impact", self.caster)
		return
	end

	local bush_ability = self:GetCaster():FindAbilityByName("hoodwink_bushwhack_custom")

	for _,enemy in pairs(enemies) do

	

		local origin = enemy:GetOrigin()
		local mytree = trees[1]
		local mytreedist = (trees[1]:GetOrigin()-origin):Length2D()
		for _,tree in pairs(trees) do
			local treedist = (tree:GetOrigin()-origin):Length2D()
			if treedist<mytreedist then
				mytree = tree
				mytreedist = treedist
			end
		end
		enemy:AddNewModifier( self.hero , bush_ability, "modifier_hoodwink_bushwhack_custom_debuff", { duration = self.duration*(1 - enemy:GetStatusResistance()), damage = 0, tree = mytree:entindex(), }  )
	end

	local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_hoodwink/hoodwink_bushwhack.vpcf", PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( particle, 0, self.location )
	ParticleManager:SetParticleControl( particle, 1, Vector( self.radius, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( particle )
	EmitSoundOnLocationWithCaster(self.origin, "Hero_Hoodwink.Bushwhack.Cast", self.caster)
	EmitSoundOnLocationWithCaster(self.location, "Hero_Hoodwink.Bushwhack.Impact", self.caster)

	UTIL_Remove( self:GetParent() )
end

modifier_hoodwink_decoy_custom_debuff = class({})

function modifier_hoodwink_decoy_custom_debuff:IsPurgable()
	return true
end

function modifier_hoodwink_decoy_custom_debuff:OnCreated( kv )
	self.parent = self:GetParent()
	self.height = 50
	self.rate = 0.3
	self.distance = 150
	self.speed = 900
	self.interval = 0.3
	if not IsServer() then return end
	self.tree = EntIndexToHScript( kv.tree )
	self.tree_origin = self.tree:GetOrigin()
	if not self:ApplyHorizontalMotionController() then
		return
	end
	self:StartIntervalThink( self.interval )
	local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_hoodwink/hoodwink_bushwhack_target.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent )
	ParticleManager:SetParticleControl( particle, 15, self.tree_origin )
	self:AddParticle( particle, false, false, -1, false, false )
	self.parent:EmitSound("Hero_Hoodwink.Bushwhack.Target")
end

function modifier_hoodwink_decoy_custom_debuff:OnDestroy()
	if not IsServer() then return end
	self:GetParent():RemoveHorizontalMotionController( self )

end

function modifier_hoodwink_decoy_custom_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_FIXED_DAY_VISION,
		MODIFIER_PROPERTY_FIXED_NIGHT_VISION,

		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE,
		MODIFIER_PROPERTY_VISUAL_Z_DELTA,
	}

	return funcs
end

function modifier_hoodwink_decoy_custom_debuff:GetFixedDayVision()
	return 0
end

function modifier_hoodwink_decoy_custom_debuff:GetFixedNightVision()
	return 0
end

function modifier_hoodwink_decoy_custom_debuff:GetOverrideAnimation()
	return ACT_DOTA_FLAIL
end

function modifier_hoodwink_decoy_custom_debuff:GetOverrideAnimationRate()
	return self.rate
end

function modifier_hoodwink_decoy_custom_debuff:GetVisualZDelta()
	return self.height
end

function modifier_hoodwink_decoy_custom_debuff:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
	}

	return state
end

function modifier_hoodwink_decoy_custom_debuff:OnIntervalThink()
	if not self.tree.IsStanding then
		if self.tree:IsNull() then
			self:Destroy()
		end

	elseif not self.tree:IsStanding() then
		self:Destroy()
	end
end

function modifier_hoodwink_decoy_custom_debuff:UpdateHorizontalMotion( me, dt )
	local origin = me:GetOrigin()
	local dir = self.tree_origin-origin
	local dist = dir:Length2D()
	dir.z = 0
	dir = dir:Normalized()

	if dist<self.distance then
		self:GetParent():RemoveHorizontalMotionController( self )
		local particle = ParticleManager:CreateParticle( "particles/tree_fx/tree_simple_explosion.vpcf", PATTACH_WORLDORIGIN, nil )
		ParticleManager:SetParticleControl( particle, 0, self.parent:GetOrigin() )
		ParticleManager:ReleaseParticleIndex( particle )
		return
	end

	local target = dir * self.speed*dt
	me:SetOrigin( origin + target )
end

function modifier_hoodwink_decoy_custom_debuff:OnHorizontalMotionInterrupted()
	self:GetParent():RemoveHorizontalMotionController( self )
end