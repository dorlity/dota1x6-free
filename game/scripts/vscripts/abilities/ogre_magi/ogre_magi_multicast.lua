LinkLuaModifier( "modifier_ogre_magi_multicast_custom", "abilities/ogre_magi/ogre_magi_multicast", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ogre_magi_multicast_custom_use", "abilities/ogre_magi/ogre_magi_multicast", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ogre_magi_multicast_custom_legendary", "abilities/ogre_magi/ogre_magi_multicast", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ogre_magi_multicast_custom_legendary_status", "abilities/ogre_magi/ogre_magi_multicast", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ogre_magi_multicast_custom_heal", "abilities/ogre_magi/ogre_magi_multicast", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ogre_magi_multicast_custom_fire", "abilities/ogre_magi/ogre_magi_multicast", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ogre_magi_multicast_custom_bkb_count", "abilities/ogre_magi/ogre_magi_multicast", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ogre_magi_multicast_custom_bkb_cd", "abilities/ogre_magi/ogre_magi_multicast", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ogre_magi_multicast_custom_bkb_buff", "abilities/ogre_magi/ogre_magi_multicast", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ogre_magi_multicast_custom_slow", "abilities/ogre_magi/ogre_magi_multicast", LUA_MODIFIER_MOTION_NONE )


ogre_magi_multicast_custom = class({})


function ogre_magi_multicast_custom:GetAbilityTextureName()
if self:GetCaster():HasModifier("modifier_ogre_magi_immortal_back_custom") then
    return "ogre_magi/auspice_of_the_whyrlegyge/ogre_magi_multicast"
end
if self:GetCaster():HasModifier("modifier_ogre_magi_immortal_back_custom_arcana") then
    return "ogre_magi/auspice_of_the_whyrlegyge/ogre_magi_multicast"
end
if self:GetCaster():HasModifier("modifier_ogre_magi_arcana_custom") then
    return "ogre_magi/arcana/ogre_magi_multicast_arcana"
end
if self:GetCaster():HasModifier("modifier_ogre_magi_arcana_custom_2") then
    return "ogre_magi/arcana/ogre_magi_multicast_arcana_alt1"
end
return "ogre_magi_multicast"
end



function ogre_magi_multicast_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end

PrecacheResource( "particle","particles/units/heroes/hero_ogre_magi/ogre_magi_fire_shield_projectile.vpcf", context )
PrecacheResource( "particle","particles/units/heroes/hero_ogre_magi/ogre_magi_multicast.vpcf", context )
PrecacheResource( "particle","particles/ogre_ult.vpcf", context )
PrecacheResource( "particle","particles/general/generic_armor_reduction.vpcf", context )
PrecacheResource( "particle","particles/ogre_magichit.vpcf", context )
PrecacheResource( "particle","particles/ogre_hit.vpcf", context )
PrecacheResource( "particle","particles/ogre_head.vpcf", context )
PrecacheResource( "particle","particles/ogre_count.vpcf", context )
PrecacheResource( "particle","particles/ogre_magi/ogre_magi_multicast_infinity.vpcf", context )
PrecacheResource( "particle","particles/ogre_magi/ogre_magi_multicast_buff.vpcf", context )
PrecacheResource( "particle","particles/econ/items/huskar/huskar_2021_immortal/huskar_2021_immortal_burning_spear_debuff.vpcf", context )
end


function ogre_magi_multicast_custom:GetCooldown(iLevel)
if self:GetCaster():HasTalent("modifier_ogremagi_multi_7") then 
  return self:GetCaster():GetTalentValue("modifier_ogremagi_multi_7", "cd")
end
return
end

function ogre_magi_multicast_custom:GetIntrinsicModifierName()
return "modifier_ogre_magi_multicast_custom"
end

function ogre_magi_multicast_custom:GetBehavior()
if self:GetCaster():HasTalent("modifier_ogremagi_multi_7") then
    return  DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE
end
return DOTA_ABILITY_BEHAVIOR_PASSIVE
end


function ogre_magi_multicast_custom:GetChance(name, is_spell)
local caster = self:GetCaster()
local chance = self:GetSpecialValueFor(name)

if is_spell and caster:HasModifier("modifier_ogre_magi_multicast_custom_bkb_buff") and caster:GetUpgradeStack("modifier_ogre_magi_multicast_custom_bkb_buff") == 0 then 
	if IsServer() then 
		caster:RemoveModifierByName("modifier_ogre_magi_multicast_custom_bkb_buff")
	end
	return 100
end

if not chance or chance == 0 then 
	return 0
end
local bonus_stack = 0
if caster:HasModifier("modifier_ogre_magi_dumb_luck_custom") and caster:HasTalent("modifier_ogremagi_multi_5") then
	chance = chance + caster:GetUpgradeStack("modifier_ogre_magi_dumb_luck_custom")*caster:GetTalentValue("modifier_ogremagi_multi_5", "chance")
end 
local ability = caster:FindAbilityByName("ogre_magi_dumb_luck_custom")
if ability and ability:GetLevel() > 0 then 
	chance = chance + caster:GetStrength()/ability:GetSpecialValueFor("str_chance")
end
return chance
end 


function ogre_magi_multicast_custom:TriggerSpell(ability, target)
local caster = self:GetCaster()
local bloodlust = caster:FindAbilityByName("ogre_magi_bloodlust_custom")
local fireblast = caster:FindAbilityByName("ogre_magi_fireblast_custom")

if target and target:IsBaseNPC() and not target:IsNull() and target:IsRealHero() and target:GetTeamNumber() ~= caster:GetTeamNumber() then 
	local mod = caster:FindModifierByName("modifier_ogre_magi_dumb_luck_custom")
	if mod then 
		mod:AddStack()
	end	
	if caster:GetQuest() == "Ogre.Quest_8" then 
		caster:UpdateQuest(1)
	end
end 

if not ability:IsItem() then

	if caster:HasTalent("modifier_ogremagi_multi_2") then  
	    caster:AddNewModifier(caster, self, "modifier_ogre_magi_multicast_custom_heal", {duration = caster:GetTalentValue("modifier_ogremagi_multi_2", "duration")})
	end 

	if caster:HasTalent("modifier_ogremagi_multi_4") or caster:HasTalent("modifier_ogremagi_multi_1") then 

		local info = {
			Source = caster,
			Ability = self,	
			EffectName = "particles/units/heroes/hero_ogre_magi/ogre_magi_fire_shield_projectile.vpcf",
			iMoveSpeed = 900,
			bReplaceExisting = false,
			bProvidesVision = true,
			iVisionRadius = 50,
			iVisionTeamNumber = caster:GetTeamNumber(),			
		}

		for _,target in pairs(caster:FindTargets(caster:GetTalentValue("modifier_ogremagi_multi_4", "radius", true))) do 
			info.Target = target
			ProjectileManager:CreateTrackingProjectile(info)
		end
	end
end

if fireblast then 
	if caster:HasTalent("modifier_ogremagi_blast_4") and not ability:IsItem() then 
		caster:AddNewModifier(caster, fireblast, "modifier_ogre_magi_fireblast_attack", {duration = caster:GetTalentValue("modifier_ogremagi_blast_4", "duration" )})
	end
end

if not bloodlust then return end
if not caster:HasTalent("modifier_ogremagi_bloodlust_4") then return end
if ability:IsItem() then return end
if ability == bloodlust then return end
if not caster:HasModifier("modifier_ogre_magi_bloodlust_custom_buff") then return end 

caster:AddNewModifier(caster, bloodlust, "modifier_ogre_magi_bloodlust_custom_str", {})
end



function ogre_magi_multicast_custom:OnSpellStart()
if not IsServer() then return end
local caster = self:GetCaster()
caster:AddNewModifier(caster, self, "modifier_ogre_magi_multicast_custom_legendary", {duration = caster:GetTalentValue("modifier_ogremagi_multi_7", "duration")})
end






function ogre_magi_multicast_custom:OnProjectileHit(target, vLocation)
if not target then return end
local caster = self:GetCaster()

if caster:HasTalent("modifier_ogremagi_multi_4") then 
	target:AddNewModifier(caster, self, "modifier_ogre_magi_multicast_custom_fire", {duration = caster:GetTalentValue("modifier_ogremagi_multi_4", "duration")})
end

if caster:HasTalent("modifier_ogremagi_multi_1") then 

	if RollPseudoRandomPercentage(caster:GetTalentValue("modifier_ogremagi_multi_1", "chance"), 2552, caster) then 
		target:AddNewModifier(caster, self, "modifier_ogre_magi_multicast_custom_slow", {duration = caster:GetTalentValue("modifier_ogremagi_multi_1", "duration")*(1 - target:GetStatusResistance())})
	end

	DoDamage({victim = target, attacker = caster, ability = self, damage_type = DAMAGE_TYPE_MAGICAL, damage = caster:GetTalentValue("modifier_ogremagi_multi_1", "damage")}, "modifier_ogremagi_multi_1")
end

target:EmitSound("Hero_OgreMagi.FireShield.Damage")
end





modifier_ogre_magi_multicast_custom = class({})

modifier_ogre_magi_multicast_custom.one_target = {
	["ogre_magi_fireblast_custom"] = true,
	["ogre_magi_unrefined_fireblast_custom"] = true,
	["ogre_magi_bloodlust_custom"] = true,
	["ogre_magi_smash_custom"] = true
}


modifier_ogre_magi_multicast_custom.item_exceptions =
{
	["item_patrol_grenade"] = true,
	["item_patrol_midas"] = true,
	["item_patrol_razor"] = true,
	["item_spirit_vessel_custom"] = true,
	["item_urn_of_shadows_custom"] = true,
	["item_upgrade_repair"] = true,
	["item_holy_locket"] = true,
	["item_moon_shard"] = true,
	["item_midas_custom"] = true,
	["custom_ability_grenade"] = true,
	["item_harpoon_custom"] = true,
}





function modifier_ogre_magi_multicast_custom:IsPurgable()
	return false
end

function modifier_ogre_magi_multicast_custom:IsHidden()
	return true
end

function modifier_ogre_magi_multicast_custom:OnCreated()
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.luck = self.parent:FindAbilityByName("ogre_magi_dumb_luck_custom")

self.bkb_timer = self.parent:GetTalentValue("modifier_ogremagi_multi_6", "duration", true)

self.parent:AddSpellEvent(self)
end


function modifier_ogre_magi_multicast_custom:SpellEvent( params )
if params.unit~=self.parent then return end

self.ability:TriggerSpell(params.ability, params.target)

if params.ability==self.ability then return end

if not params.ability:IsItem() and self.parent:HasTalent("modifier_ogremagi_multi_6") and not self.parent:HasModifier("modifier_ogre_magi_multicast_custom_bkb_cd") then 
	self.parent:AddNewModifier(self.parent, self.ability, "modifier_ogre_magi_multicast_custom_bkb_count", {duration = self.bkb_timer})
end

if self.parent:PassivesDisabled() then return end
if self.item_exceptions[params.ability:GetName()] == true then return end

local selt_target = (params.ability:GetAbilityName() == "ogre_magi_smash_custom" or params.ability:GetAbilityName() == "ogre_magi_bloodlust_custom") and IsSoloMode()

local target = params.target
local point = nil

if (params.ability:GetName() == "ogre_magi_fireblast_custom" or params.ability:GetName() == "ogre_magi_unrefined_fireblast_custom") and self.parent:HasTalent("modifier_ogremagi_blast_7") then 
	point = self.parent:GetCursorPosition()
else 

	if not selt_target then
		if not target then return end
		if bit.band( params.ability:GetBehaviorInt(), DOTA_ABILITY_BEHAVIOR_POINT ) ~= 0 then return end
		if bit.band( params.ability:GetBehaviorInt(), DOTA_ABILITY_BEHAVIOR_OPTIONAL_UNIT_TARGET ) ~= 0 then return end
	end

	if selt_target  then
		target = self.parent
	end
end


local chance_2 = self.ability:GetChance( "multicast_2_times" )
local chance_3 = self.ability:GetChance( "multicast_3_times" )
local chance_4 = self.ability:GetChance( "multicast_4_times", not params.ability:IsItem() )

local multicast_multi = 1

if RollPseudoRandomPercentage(chance_4, 52, self.parent) then 
	multicast_multi = 4 
else 
	if RollPseudoRandomPercentage(chance_3, 51, self.parent) then 
		multicast_multi = 3 
	else 
		if RollPseudoRandomPercentage(chance_2, 50, self.parent) then
			multicast_multi = 2 
		end
	end
end

local delay = params.ability:GetSpecialValueFor( "multicast_delay" ) or 0
local single = self.one_target[params.ability:GetAbilityName()] or false

if self.parent:HasTalent("modifier_ogremagi_multi_4") then 
	self.parent:AddNewModifier(self.parent, self.ability, "modifier_ogre_magi_multicast_custom_attack", {duration = self.parent:GetTalentValue("modifier_ogremagi_multi_4", "duration")})
end


if multicast_multi == 1 then return end

if point == nil then 
	self.parent:AddNewModifier( self.parent, self.ability, "modifier_ogre_magi_multicast_custom_use", { ability = params.ability:entindex(), target = target:entindex(), multicast = multicast_multi, delay = delay, single = single, } )
else 
	self.parent:AddNewModifier( self.parent, self.ability, "modifier_ogre_magi_multicast_custom_use", { ability = params.ability:entindex(), x = point.x, y = point.y, z = point.z, multicast = multicast_multi, delay = delay, single = single, } )
end

end




modifier_ogre_magi_multicast_custom_use = class({})

function modifier_ogre_magi_multicast_custom_use:IsHidden() return true end
function modifier_ogre_magi_multicast_custom_use:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_ogre_magi_multicast_custom_use:IsPurgable() return false end
function modifier_ogre_magi_multicast_custom_use:RemoveOnDeath() return false end

function modifier_ogre_magi_multicast_custom_use:OnCreated( kv )
if not IsServer() then return end
self.caster = self:GetParent()
self.ability = EntIndexToHScript( kv.ability )
self.main_ability = self:GetAbility()

self.point = nil 
self.target = nil 

if kv.target then 
	self.target = EntIndexToHScript( kv.target )
else 
	self.point = Vector(kv.x, kv.y, kv.z)
end

self.multicast = kv.multicast
self.delay = kv.delay
self.single = kv.single==1
self.buffer_range = 600
self:SetStackCount( self.multicast )

self.casts = 0

if self.multicast==1 then
	self:Destroy()
	return
end

self.targets = {}
self.no_target = 0

if self.target ~= nil then 
	if self.ability:GetAbilityName() ~= "ogre_magi_ignite_custom" then
		self.targets[self.target] = true
	end
	if self:GetCaster() == self.target then 
		self.no_target = 1
	end
	self.radius = self.ability:GetCastRange( self.target:GetOrigin(), self.target ) + self.buffer_range
	self.target_team = DOTA_UNIT_TARGET_TEAM_FRIENDLY

	if self.target:GetTeamNumber()~=self.caster:GetTeamNumber() then
		self.target_team = DOTA_UNIT_TARGET_TEAM_ENEMY
	end
end

self.target_type = self.ability:GetAbilityTargetType()

if self.target_type==DOTA_UNIT_TARGET_CUSTOM then
	self.target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

self.target_flags = DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE

if bit.band( self.ability:GetAbilityTargetFlags(), DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES ) ~= 0 then
	self.target_flags = self.target_flags + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end

local target = self.caster
if self.single and self.target then
	target = self.target
end

self:PlayEffects( self.multicast, target )
self:StartIntervalThink( self.delay )
end

function modifier_ogre_magi_multicast_custom_use:OnIntervalThink()
local current_target = nil

if self.no_target == 1 then 
	if not self.ability:IsItem() then 
		self.ability:OnSpellStart()
	end
else 

	if self.single then
		current_target = self.target
	else
		local units = FindUnitsInRadius( self.caster:GetTeamNumber(), self.caster:GetOrigin(), nil, self.radius, self.target_team, self.target_type, self.target_flags, FIND_ANY_ORDER, false )
		for _,unit in pairs(units) do
			if not self.targets[unit] then
				local filter = false
				if self.ability.CastFilterResultTarget then
					filter = self.ability:CastFilterResultTarget( unit ) == UF_SUCCESS
				else
					filter = true
				end

				if filter then

					if #units > 1 and self.ability:GetAbilityName() ~= "ogre_magi_ignite_custom" then
						self.targets[unit] = true
					end
					current_target = unit
					break
				end
			end
		end
		if not current_target then
			self:StartIntervalThink( -1 )
			self:Destroy()
			return
		end
	end


	if self.ability:IsItem() then
		if current_target and not current_target:IsNull() then 
			self.caster:SetCursorCastTarget( current_target )
			self.ability:OnSpellStart()
		end
	else
		if self.point ~= nil then 
			self.ability:OnSpellStart(nil, self.point)
		else 
			if current_target and not current_target:IsNull() then 
				self.ability:OnSpellStart(current_target)
			end
		end
	end
end

self.main_ability:TriggerSpell(self.ability, current_target)

self.casts = self.casts + 1
if self.casts>=(self.multicast-1) then
	self:StartIntervalThink( -1 )
	self:Destroy()
end

end




function modifier_ogre_magi_multicast_custom_use:PlayEffects( value, target )

local effect_name = "particles/units/heroes/hero_ogre_magi/ogre_magi_multicast.vpcf"

if self.caster:HasModifier("modifier_ogre_magi_arcana_custom") or self.caster:HasModifier("modifier_ogre_magi_arcana_custom_2") then
	effect_name = "particles/econ/items/ogre_magi/ogre_magi_arcana/ogre_magi_arcana_multicast_counter.vpcf"
	if self.caster:HasModifier("modifier_ogre_magi_immortal_back_custom") or self.caster:HasModifier("modifier_ogre_magi_immortal_back_custom_arcana") then
	    effect_name = "particles/econ/items/ogre_magi/ogre_magi_arcana/ogre_magi_arcana_multicast_style.vpcf"
	end
else 
	if self.caster:HasModifier("modifier_ogre_magi_immortal_back_custom") or self.caster:HasModifier("modifier_ogre_magi_immortal_back_custom_arcana") then
	    effect_name = "particles/econ/items/ogre_magi/ogre_magi_jackpot/ogre_magi_jackpot_multicast.vpcf"
	end
end

local effect_cast = ParticleManager:CreateParticle(  effect_name, PATTACH_OVERHEAD_FOLLOW, target )
ParticleManager:SetParticleControl( effect_cast, 1, Vector( value, counter_speed, 0 ) )
ParticleManager:ReleaseParticleIndex( effect_cast )

local sound = math.min( value-1, 3 )

local sound_cast = "Hero_OgreMagi.Fireblast.x" .. sound

if sound>0 then
	target:EmitSound(sound_cast)
end

end







modifier_ogre_magi_multicast_custom_legendary = class({})
function modifier_ogre_magi_multicast_custom_legendary:IsHidden() return true end
function modifier_ogre_magi_multicast_custom_legendary:IsPurgable() return false end
function modifier_ogre_magi_multicast_custom_legendary:OnCreated()
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.duration = self.parent:GetTalentValue("modifier_ogremagi_multi_7", "duration")
self.radius = self.parent:GetTalentValue("modifier_ogremagi_multi_7", "radius")

if not IsServer() then return end
self.effect_cast = ParticleManager:CreateParticle( "particles/ogre_magi/ogre_magi_multicast_infinity.vpcf", PATTACH_OVERHEAD_FOLLOW, self.parent )
ParticleManager:SetParticleControl( self.effect_cast, 0, self.parent:GetAbsOrigin())
self:AddParticle(self.effect_cast, false, false, -1, false, true)

self.particle = ParticleManager:CreateParticle( "particles/ogre_magi/ogre_magi_multicast_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent )
ParticleManager:SetParticleControl( self.particle, 0, self.parent:GetAbsOrigin() )
self:AddParticle(self.particle, false, false, -1, false, false) 

self.ability:EndCooldown()
self.ability:SetActivated(false)

local cd_inc = self.parent:GetTalentValue("modifier_ogremagi_multi_7", "cd_inc")

for i = 0, 8 do
    local current_item = self.parent:GetItemInSlot(i)
    if current_item and not NoCdItems[current_item:GetName()] then  
		local cooldown_mod = self.parent:AddNewModifier(self.parent, self.ability, "modifier_cooldown_speed", {ability = current_item:entindex(), is_item = true, cd_inc = cd_inc})
		local name = self:GetName()
		cooldown_mod:SetEndRule(function()
			return self.parent:HasModifier(name)
		end)
    end
end

for i = 0,self.parent:GetAbilityCount()-1 do
	local ability = self.parent:GetAbilityByIndex(i)
	if ability then
		local cooldown_mod = self.parent:AddNewModifier(self.parent, self.ability, "modifier_cooldown_speed", {ability = ability:entindex(),  cd_inc = cd_inc})
		local name = self:GetName()
		cooldown_mod:SetEndRule(function()
			return self.parent:HasModifier(name)
		end)
	else 
		break
	end
end

self.parent:EmitSound("Ogre.Multi_legendary")
self.parent:EmitSound("Ogre.Multi_legendary3")
self.parent:EmitSound("Ogre.Multi_legendary_lp")

self.parent:AddAttackEvent_out(self)
self.interval = FrameTime()
self.sound_count = 0
self.sound_big = 0

self:OnIntervalThink()
self:StartIntervalThink(self.interval)
end


function modifier_ogre_magi_multicast_custom_legendary:OnIntervalThink()
if not IsServer() then return end

self.parent:UpdateUIshort({max_time = self.duration, time = self:GetRemainingTime(), stack = self:GetRemainingTime(), use_zero = 1, style = "OgreMulticast"})


self.sound_count = self.sound_count + self.interval
self.sound_big = self.sound_big + self.interval

if self.sound_big >= 3 then 
	self.sound_big = 0
	self.parent:EmitSound("Ogre.Multi_legendary")
end 

if self.sound_count >= 1 then 
	self.parent:EmitSound("Ogre.Multi_legendary2")
	self.sound_count = 0
end
end

function modifier_ogre_magi_multicast_custom_legendary:AttackEvent_out(params)
if not IsServer() then return end
if self.parent ~= params.attacker then return end 
if not params.target:IsUnit() then return end
self:SetDuration(self.duration, true)
end



function modifier_ogre_magi_multicast_custom_legendary:OnDestroy()
if not IsServer() then return end 
self.ability:SetActivated(true)
self.ability:UseResources(false, false, false, true)

self.parent:StopSound("Ogre.Multi_legendary_lp")

self.parent:UpdateUIshort({hide = 1, hide_full = 1, style = "OgreMulticast"})
end


function modifier_ogre_magi_multicast_custom_legendary:GetStatusEffectName()
return "particles/status_fx/status_effect_brewmaster_cinder_brew.vpcf"
end


function modifier_ogre_magi_multicast_custom_legendary:StatusEffectPriority()
return MODIFIER_PRIORITY_HIGH 
end

function modifier_ogre_magi_multicast_custom_legendary:IsAura() return true end
function modifier_ogre_magi_multicast_custom_legendary:GetAuraDuration() return 0 end
function modifier_ogre_magi_multicast_custom_legendary:GetAuraRadius() return self.radius end
function modifier_ogre_magi_multicast_custom_legendary:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_ogre_magi_multicast_custom_legendary:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO end
function modifier_ogre_magi_multicast_custom_legendary:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE end
function modifier_ogre_magi_multicast_custom_legendary:GetModifierAura() return "modifier_ogre_magi_multicast_custom_legendary_status" end



modifier_ogre_magi_multicast_custom_legendary_status = class({})
function modifier_ogre_magi_multicast_custom_legendary_status:IsHidden() return true end
function modifier_ogre_magi_multicast_custom_legendary_status:IsPurgable() return false end
function modifier_ogre_magi_multicast_custom_legendary_status:OnCreated()
self.status = self:GetCaster():GetTalentValue("modifier_ogremagi_multi_7", "status")
end

function modifier_ogre_magi_multicast_custom_legendary_status:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
}
end


function modifier_ogre_magi_multicast_custom_legendary_status:GetModifierStatusResistanceStacking()
return self.status
end









modifier_ogre_magi_multicast_custom_heal = class({})
function modifier_ogre_magi_multicast_custom_heal:GetTexture() return "buffs/arcane_regen" end
function modifier_ogre_magi_multicast_custom_heal:IsHidden() return false end
function modifier_ogre_magi_multicast_custom_heal:IsPurgable() return false end
function modifier_ogre_magi_multicast_custom_heal:OnCreated(table)
self.parent = self:GetParent()
self.max = self.parent:GetTalentValue("modifier_ogremagi_multi_2", "max")
self.heal = self:GetCaster():GetTalentValue("modifier_ogremagi_multi_2", "heal")/self.max
self.damage_reduce = self:GetCaster():GetTalentValue("modifier_ogremagi_multi_2", "damage_reduce")/self.max
if not IsServer() then return end
self:SetStackCount(1)
end

function modifier_ogre_magi_multicast_custom_heal:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end
self:IncrementStackCount()
end

function modifier_ogre_magi_multicast_custom_heal:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
    MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
}
end

function modifier_ogre_magi_multicast_custom_heal:GetModifierConstantHealthRegen()
return self:GetStackCount()*self.heal
end


function modifier_ogre_magi_multicast_custom_heal:GetModifierIncomingDamage_Percentage()
return self:GetStackCount()*self.damage_reduce
end





modifier_ogre_magi_multicast_custom_fire = class({})
function modifier_ogre_magi_multicast_custom_fire:IsHidden() return false end
function modifier_ogre_magi_multicast_custom_fire:IsPurgable() return false end
function modifier_ogre_magi_multicast_custom_fire:GetTexture() return "buffs/fireblast_fire" end
function modifier_ogre_magi_multicast_custom_fire:GetEffectName()
return "particles/econ/items/huskar/huskar_2021_immortal/huskar_2021_immortal_burning_spear_debuff.vpcf"
end

function modifier_ogre_magi_multicast_custom_fire:OnCreated(table)
self.parent = self:GetParent()
self.caster = self:GetCaster()
self.ability = self:GetAbility()

self.max = self.caster:GetTalentValue("modifier_ogremagi_multi_4", "max")
self.interval = self.caster:GetTalentValue("modifier_ogremagi_multi_4", "interval")
self.heal_reduce = self.caster:GetTalentValue("modifier_ogremagi_multi_4", "heal_reduce")/self.max
self.damage = self.caster:GetTalentValue("modifier_ogremagi_multi_4", "damage")/self.max

self.damageTable = {victim = self.parent, attacker = self.caster, damage_type = DAMAGE_TYPE_MAGICAL, ability = self.ability}

if not IsServer() then return end
self.RemoveForDuel = true

if not self.caster:HasTalent("modifier_ogremagi_blast_7") then 
	self.effect_cast = ParticleManager:CreateParticle( "particles/ogre_fire_stack.vpcf", PATTACH_OVERHEAD_FOLLOW, self.parent )
	self:AddParticle(self.effect_cast,false, false, -1, false, false)
end

self:SetStackCount(1)
self.parent:EmitSound("Ogre.Blast_fire")
self:StartIntervalThink(self.interval)
end

function modifier_ogre_magi_multicast_custom_fire:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end

self:IncrementStackCount()
end

function modifier_ogre_magi_multicast_custom_fire:OnDestroy()
if not IsServer() then return end
self:GetParent():StopSound("Ogre.Blast_fire")
end

function modifier_ogre_magi_multicast_custom_fire:OnIntervalThink()
if not IsServer() then return end
self.damageTable.damage = self.damage*self:GetStackCount()*self.interval
DoDamage(self.damageTable, "modifier_ogremagi_multi_4" )
end

function modifier_ogre_magi_multicast_custom_fire:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOOLTIP,
	MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
	MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
	MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE,
}
end

function modifier_ogre_magi_multicast_custom_fire:OnStackCountChanged(iStackCount)
if not self.effect_cast then return end	

local k1 = 0
local k2 = self:GetStackCount()

if k2 >= 20 then 
    k1 = 2
    k2 = self:GetStackCount() - 20
end

if k2 >= 10 then 
    k1 = 1
    k2 = self:GetStackCount() - 10
end

ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( k1, k2, 0 ) )
end

function modifier_ogre_magi_multicast_custom_fire:OnTooltip()
return self.damage*self:GetStackCount()
end

function modifier_ogre_magi_multicast_custom_fire:GetModifierLifestealRegenAmplify_Percentage() 
return self.heal_reduce*self:GetStackCount()
end

function modifier_ogre_magi_multicast_custom_fire:GetModifierHealAmplify_PercentageTarget()
return self.heal_reduce*self:GetStackCount()
end

function modifier_ogre_magi_multicast_custom_fire:GetModifierHPRegenAmplify_Percentage() 
return self.heal_reduce*self:GetStackCount()
end







modifier_ogre_magi_multicast_custom_bkb_count = class({})
function modifier_ogre_magi_multicast_custom_bkb_count:IsHidden() return false end
function modifier_ogre_magi_multicast_custom_bkb_count:IsPurgable() return false end
function modifier_ogre_magi_multicast_custom_bkb_count:GetTexture() return "buffs/multicast_bkb" end
function modifier_ogre_magi_multicast_custom_bkb_count:OnCreated()
self.parent = self:GetParent()
self.ability = self:GetAbility()
self.bkb = self.parent:GetTalentValue("modifier_ogremagi_multi_6", "bkb")
self.buff_duration = self.parent:GetTalentValue("modifier_ogremagi_multi_6", "buff_duration")
self.cd = self.parent:GetTalentValue("modifier_ogremagi_multi_6", "cd")
self.max = self.parent:GetTalentValue("modifier_ogremagi_multi_6", "max")
if not IsServer() then return end 

self:SetStackCount(1)
end

function modifier_ogre_magi_multicast_custom_bkb_count:OnRefresh()
if not IsServer() then return end
self:IncrementStackCount()

if self:GetStackCount() >= self.max then 
	self.parent:AddNewModifier(self.parent, self.ability, "modifier_generic_debuff_immune", {effect = 1, duration = self.bkb})
	self.parent:AddNewModifier(self.parent, self.ability, "modifier_ogre_magi_multicast_custom_bkb_buff", {duration = self.buff_duration})
	self.parent:AddNewModifier(self.parent, self.ability, "modifier_ogre_magi_multicast_custom_bkb_cd", {duration = self.cd})
	self.parent:EmitSound("Ogre.Multi_bkb")
	self:Destroy()
end

end


modifier_ogre_magi_multicast_custom_bkb_buff = class({})
function modifier_ogre_magi_multicast_custom_bkb_buff:IsHidden() return self:GetStackCount() == 1 end
function modifier_ogre_magi_multicast_custom_bkb_buff:IsPurgable() return false end
function modifier_ogre_magi_multicast_custom_bkb_buff:OnCreated()
self:SetStackCount(1)
self:StartIntervalThink(0.1)
end

function modifier_ogre_magi_multicast_custom_bkb_buff:OnIntervalThink()
if not IsServer() then return end 
self:SetStackCount(0)
self:StartIntervalThink(-1)
end



modifier_ogre_magi_multicast_custom_bkb_cd = class({})
function modifier_ogre_magi_multicast_custom_bkb_cd:IsHidden() return false end
function modifier_ogre_magi_multicast_custom_bkb_cd:IsPurgable() return false end
function modifier_ogre_magi_multicast_custom_bkb_cd:GetTexture() return "buffs/multicast_bkb" end
function modifier_ogre_magi_multicast_custom_bkb_cd:RemoveOnDeath() return false end
function modifier_ogre_magi_multicast_custom_bkb_cd:IsDebuff() return true end
function modifier_ogre_magi_multicast_custom_bkb_cd:OnCreated()
self.RemoveForDuel = true
end







modifier_ogre_magi_multicast_custom_slow = class({})
function modifier_ogre_magi_multicast_custom_slow:IsHidden() return true end
function modifier_ogre_magi_multicast_custom_slow:IsPurgable() return true end
function modifier_ogre_magi_multicast_custom_slow:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
}
end

function modifier_ogre_magi_multicast_custom_slow:OnCreated()
self.slow = self:GetCaster():GetTalentValue("modifier_ogremagi_multi_1", "slow")
end

function modifier_ogre_magi_multicast_custom_slow:GetModifierMoveSpeedBonus_Percentage()
return self.slow
end

function modifier_ogre_magi_multicast_custom_slow:GetEffectName()
return "particles/units/heroes/hero_sniper/sniper_headshot_slow.vpcf"
end

function modifier_ogre_magi_multicast_custom_slow:GetEffectAttachType()
return PATTACH_OVERHEAD_FOLLOW
end

