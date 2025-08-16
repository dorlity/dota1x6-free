LinkLuaModifier("modifier_arc_warden_tempest_double_custom", "abilities/arc_warden/arc_warden_tempest_double_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_arc_warden_tempest_double_custom_far", "abilities/arc_warden/arc_warden_tempest_double_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_arc_warden_tempest_double_custom_tracker", "abilities/arc_warden/arc_warden_tempest_double_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_arc_warden_tempest_double_custom_legendary", "abilities/arc_warden/arc_warden_tempest_double_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_arc_warden_tempest_double_custom_legendary_tp", "abilities/arc_warden/arc_warden_tempest_double_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_arc_warden_tempest_double_custom_legendary_buff", "abilities/arc_warden/arc_warden_tempest_double_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_arc_warden_tempest_double_custom_lowhp", "abilities/arc_warden/arc_warden_tempest_double_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_arc_warden_tempest_double_custom_slow", "abilities/arc_warden/arc_warden_tempest_double_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_arc_warden_tempest_double_custom_items", "abilities/arc_warden/arc_warden_tempest_double_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_arc_warden_tempest_double_custom_scepter_tp", "abilities/arc_warden/arc_warden_tempest_double_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_arc_warden_tempest_double_custom_bkb_cd", "abilities/arc_warden/arc_warden_tempest_double_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_arc_warden_tempest_double_custom_auto_cd", "abilities/arc_warden/arc_warden_tempest_double_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_arc_warden_tempest_double_custom_auto_damage", "abilities/arc_warden/arc_warden_tempest_double_custom", LUA_MODIFIER_MOTION_NONE)


arc_warden_tempest_double_custom = class({})

arc_warden_tempest_double_custom.cd_items = 
{
	["item_sheepstick_custom"] = true,
	["item_abyssal_blade_custom"] = true
}

arc_warden_tempest_double_custom.give_buffs =
{
	["modifier_item_ultimate_scepter_consumed"] = true,
	["modifier_item_aghanims_shard"] = true,
	["modifier_item_moon_shard_consumed"] = true,
}

function arc_warden_tempest_double_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end

PrecacheResource( "particle", "particles/units/heroes/hero_arc_warden/arc_warden_tempest_cast.vpcf", context )
PrecacheResource( "particle", "particles/arc_warden/legendary_kill.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_arc_warden/arc_warden_tempest_eyes.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_lone_druid/lone_druid_bear_blink_end.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_demonartist/demonartist_engulf_disarm/items2_fx/heavens_halberd.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_arc_warden/arc_warden_wraith_prj.vpcf", context )
PrecacheResource( "particle", "particles/arc_warden/legendary_tp_start.vpcf", context )
PrecacheResource( "particle", "particles/arc_warden/legendary_tp_end.vpcf", context )
PrecacheResource( "particle", "particles/arc_warden/legendary_tp_tube.vpcf", context )
PrecacheResource( "particle", "particles/arc_warden/legendary_tp_tube_tempest.vpcf", context )
PrecacheResource( "particle", "particles/rare_orb_patrol.vpcf", context )
PrecacheResource( "particle", "particles/arc_warden/tempest_reduce.vpcf", context )
PrecacheResource( "particle", "particles/arc_warden/tempest_tether.vpcf", context )
PrecacheResource( "particle", "particles/lc_odd_proc_.vpcf", context )
PrecacheResource( "particle", "particles/rare_orb_patrol.vpcf", context )
PrecacheResource( "particle", "particles/arc_warden/tempest_rune_arcane.vpcf", context )
PrecacheResource( "particle", "particles/brist_lowhp_.vpcf", context )
PrecacheResource( "particle", "particles/items2_fx/vindicators_axe_armor.vpcf", context )
PrecacheResource( "particle", "particles/generic_gameplay/rune_doubledamage_owner.vpcf", context )
PrecacheResource( "particle", "particles/generic_gameplay/rune_arcane_owner.vpcf", context )
PrecacheResource( "particle", "particles/generic_gameplay/rune_haste_owner.vpcf", context )
PrecacheResource( "particle", "particles/arc_warden/tempest_attack.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_terrorblade/terrorblade_reflection_slow.vpcf", context )
end


function arc_warden_tempest_double_custom:GetCooldown(level)
return self.BaseClass.GetCooldown(self, level)
end

function arc_warden_tempest_double_custom:GetIntrinsicModifierName()
if not self:GetCaster():IsRealHero() or self:GetCaster():IsTempestDouble() then return end
return "modifier_arc_warden_tempest_double_custom_tracker"
end

function arc_warden_tempest_double_custom:GetCooldown(level)
local bonus = self:GetCaster():HasTalent("modifier_arc_warden_hero_4") and self:GetCaster():GetTalentValue("modifier_arc_warden_hero_4", "cd") or 0
return self.BaseClass.GetCooldown(self, level)  + bonus
end

function arc_warden_tempest_double_custom:OnInventoryContentsChanged()
local caster = self:GetCaster()
local tempest = caster.tempest_double_tempest
if not IsValid(tempest) then return end
if not tempest:IsAlive() then return end

tempest:AddNewModifier(caster, self, "modifier_arc_warden_tempest_double_custom_items", {})
end

function arc_warden_tempest_double_custom:OnAbilityPhaseStart()
return not self:GetCaster():IsTempestDouble()
end

function arc_warden_tempest_double_custom:OnSpellStart()
local caster = self:GetCaster()
local point = self:GetCursorPosition()

local tempest = self:GetHerotempest()

if not tempest or tempest:IsNull() then return end

tempest:RespawnHero(false, false)

self:ModifyTempest(tempest)

tempest:SetHealth(caster:GetMaxHealth())
tempest:SetMana(caster:GetMaxMana())

tempest:Purge(true, true, false, true, true)
tempest:SetAbilityPoints(0)
tempest:SetHasInventory(false)
tempest:SetCanSellItems(false)
tempest.owner = caster
tempest:RemoveModifierByName("modifier_fountain_invulnerability")
tempest:AddNewModifier(caster, self, "modifier_arc_warden_tempest_double", {})
Timers:CreateTimer(FrameTime(), function()
    tempest:RemoveModifierByName("modifier_fountain_invulnerability")
end)

caster.tempest_double_tempest = tempest

tempest:RemoveGesture(ACT_DOTA_DIE)

FindClearSpaceForUnit(tempest, point, true)

local duration = nil
if not caster:HasScepter() then
	duration = self:GetSpecialValueFor("duration")
	tempest:AddNewModifier(caster, self, "modifier_kill", {duration = duration})
end
tempest:AddNewModifier(caster, self, "modifier_arc_warden_tempest_double_custom", {duration = duration})

local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_arc_warden/arc_warden_tempest_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
ParticleManager:SetParticleControlEnt(particle, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
ParticleManager:ReleaseParticleIndex(particle)


local particle2 = ParticleManager:CreateParticle( "particles/units/heroes/hero_arc_warden/arc_warden_tempest_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, tempest )
ParticleManager:SetParticleControlEnt(particle2, 0, tempest, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", tempest:GetAbsOrigin(), true)
ParticleManager:ReleaseParticleIndex(particle2)

caster:EmitSound("Hero_ArcWarden.TempestDouble")
end

function arc_warden_tempest_double_custom:OnProjectileHit(target, vLocation)
if not target then return end
local caster = self:GetCaster()

target:EmitSound("Arc.Tempest_attack_end")
caster:AddNewModifier(caster, self, "modifier_arc_warden_tempest_double_custom_auto_damage", {duration = FrameTime()})
caster:PerformAttack(target, true, true, true, true, false, false, false)
caster:RemoveModifierByName("modifier_arc_warden_tempest_double_custom_auto_damage")
end

function arc_warden_tempest_double_custom:GetHerotempest()
local caster = self:GetCaster()
if not caster or caster:IsNull() then return end

if not self.tempest then
	if caster.tempest_double_tempest then
		self.tempest = caster.tempest_double_tempest
	else
		local tempest = CreateUnitByName( caster:GetUnitName(), caster:GetAbsOrigin(), true, caster, caster, caster:GetTeamNumber()  )

        tempest:AddNewModifier(caster, self, "modifier_arc_warden_tempest_double", {})
        tempest:AddNewModifier(tempest, self, "modifier_arc_warden_tempest_double_custom_tracker", {})
        local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_arc_warden/arc_warden_tempest_eyes.vpcf", PATTACH_ABSORIGIN, tempest )
        ParticleManager:SetParticleControlEnt(particle, 0, tempest, PATTACH_POINT_FOLLOW, "attach_head", tempest:GetAbsOrigin(), true)

        tempest.talents = {}
		tempest.owner = caster
        tempest:SetUnitCanRespawn(true)
        tempest:SetRespawnsDisabled(true)
        tempest:RemoveModifierByName("modifier_fountain_invulnerability")
		tempest.IsRealHero = function() return true end
		tempest.IsMainHero = function() return false end
		tempest.IsTempestDouble = function() return true end
		tempest:SetControllableByPlayer(caster:GetPlayerOwnerID(), true)
		tempest:SetRenderColor(0, 0, 190)
		self.tempest = tempest
	end
end

return self.tempest
end


function arc_warden_tempest_double_custom:ManageItems(tempest)
if not IsServer() then return end 
if not tempest or tempest:IsNull() then return end

local caster = self:GetCaster()
if not caster or caster:IsNull() then return end

print('-----')

for i = 0 , 16 do
	local tempest_item = tempest:GetItemInSlot(i)
	if tempest_item then
		UTIL_Remove(tempest_item)
	end
end

for itemSlot = 0,16 do
    local itemName = caster:GetItemInSlot(itemSlot)
    if itemName and itemName:GetName() ~= "item_rapier" and itemName:GetName() ~= "item_gem" and itemName:IsPermanent() then

        local newItem = CreateItem(itemName:GetName(), nil, nil)
        tempest:AddItem(newItem)

        if IsValid(newItem) then
            if itemName and itemName:GetCurrentCharges() > 0 then
                newItem:SetCurrentCharges(itemName:GetCurrentCharges())
            end
            tempest:SwapItems(newItem:GetItemSlot(), itemSlot)

            if self.cd_items[itemName:GetName()] and itemName:GetCooldownTimeRemaining() > 0 
            	and newItem:GetCooldownTimeRemaining() <= itemName:GetCooldownTimeRemaining()  then 

            	newItem:StartCooldown(itemName:GetCooldownTime())
            end  

            newItem:SetSellable(false)
			newItem:SetDroppable(false)
			newItem:SetShareability( ITEM_FULLY_SHAREABLE )
			newItem:SetPurchaser( nil )
        end
    end
end

end 



function arc_warden_tempest_double_custom:ManageBuffs(tempest) 
if not IsServer() then return end 
if not tempest or tempest:IsNull() then return end

local caster = self:GetCaster()
if not caster or caster:IsNull() then return end

while tempest:GetLevel() < caster:GetLevel() do
	tempest:HeroLevelUp( false )
end

tempest:SetAbilityPoints(0)

if active_talents[caster:GetUnitName()] then
    for talent,data in pairs(active_talents[caster:GetUnitName()]) do 
        if data.allow_illusion == 1 then
            if not tempest.talents[talent] then
                tempest.talents[talent] = 0
            end

            if tempest.talents[talent] ~= data.level then
                tempest.talents[talent] = data.level
                tempest:ProcTrigger(talent)
            end
        end
    end
end

for _,modifier in pairs(caster:FindAllModifiers()) do 
    if modifier.StackOnIllusion == true or self.give_buffs[modifier:GetName()] then 

    	local mod = tempest:FindModifierByName(modifier:GetName())
    	local ability = modifier:GetAbility()
    	local cast_ability = nil

    	if ability and tempest:HasAbility(ability:GetName()) then 
    		cast_ability = tempest:FindAbilityByName(ability:GetName())
    	end

    	if not mod then 
        	mod = tempest:AddNewModifier(tempest, cast_ability, modifier:GetName(), {})
    	end 
    	if mod then 
    		mod:SetStackCount(modifier:GetStackCount())
    	end 
    end 
end

for i = 0, 24 do
    local ability = caster:GetAbilityByIndex(i)
    if ability then
        local tempest_ability = tempest:FindAbilityByName(ability:GetAbilityName())
        if tempest_ability then
            tempest_ability:SetLevel(ability:GetLevel())

            if ability:GetAbilityName() == "arc_warden_tempest_double_custom" then
				local legendary = tempest:FindAbilityByName("arc_warden_tempest_double_custom_legendary")
				if caster:HasTalent("modifier_arc_warden_double_7") and legendary and legendary:IsHidden() then 
					tempest:SwapAbilities(tempest_ability:GetAbilityName(), legendary:GetName(), false, true)
				end
                tempest_ability:SetActivated(false)
            end
        end
    end
end

tempest:CalculateStatBonus(true)
end 


function arc_warden_tempest_double_custom:ModifyTempest(tempest)
if not IsServer() then return end 
local caster = self:GetCaster()
if not caster or caster:IsNull() then return end

tempest:AddNewModifier(tempest, self, "modifier_arc_warden_tempest_double_custom_items", {})

self:ManageBuffs(tempest)
end 


modifier_arc_warden_tempest_double_custom = class(mod_hidden)
function modifier_arc_warden_tempest_double_custom:OnCreated()
self.caster = self:GetCaster()
self.ability = self:GetAbility()
self.parent = self:GetParent()

self.parent:AddDeathEvent(self, true)

self.far_distance = self.ability:GetSpecialValueFor("far_distance")
self.damage_reduce = self.ability:GetSpecialValueFor("damage_reduce")
self.health_loss = self.ability:GetSpecialValueFor("health_loss")
self.bounty = self.ability:GetSpecialValueFor("bounty")

if not IsServer() then return end
self.has_scepter = self.caster:HasScepter()

self.ability:EndCd()
if self.has_scepter and not self.ability:IsHidden() then
	self.caster:SwapAbilities("arc_warden_tempest_double_custom_reunion", self.ability:GetName(), true, false)
end

self:StartIntervalThink(0.5)

if self.parent.items_data_custom then
    for _, item_handle in pairs(self.parent.items_data_custom) do
        if item_handle and not item_handle:IsNull() then
            item_handle:SetRenderColor(0, 0, 190)
        end
    end
end
if self.parent.other_model_backup then
    for _, item_handle in pairs(self.parent.other_model_backup) do
        if item_handle and not item_handle:IsNull() then
            item_handle:SetRenderColor(0, 0, 190)
        end
    end
end

end

function modifier_arc_warden_tempest_double_custom:OnIntervalThink()
if not IsServer() then return end

local length = (self.caster:GetAbsOrigin() - self.parent:GetAbsOrigin()):Length2D()
if length > self.far_distance and self.caster:IsAlive() then
    self.parent:AddNewModifier(self.caster, self.ability, "modifier_arc_warden_tempest_double_custom_far", {})
else
    self.parent:RemoveModifierByName("modifier_arc_warden_tempest_double_custom_far")
end

end

function modifier_arc_warden_tempest_double_custom:OnDestroy()
    if not IsServer() then return end 
    if self.has_scepter and self.ability:IsHidden() then
        self.caster:SwapAbilities("arc_warden_tempest_double_custom_reunion", self.ability:GetName(), false, true)
    end
    self.ability:StartCd()
    local parent = self.parent
    local modifier_hero_donate_hex_checking = parent:FindModifierByName("modifier_hero_donate_hex_checking")
    Timers:CreateTimer(2.1, function()
        if not parent:IsAlive() and modifier_hero_donate_hex_checking then
            modifier_hero_donate_hex_checking.NoDraw = true
            modifier_hero_donate_hex_checking:AddNoDrawMod(modifier_hero_donate_hex_checking)            
            parent:AddNoDraw()
        end
    end)
end 

function modifier_arc_warden_tempest_double_custom:DeclareFunctions()
return 
{
    MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
}
end

function modifier_arc_warden_tempest_double_custom:GetModifierDamageOutgoing_Percentage()
return self.damage_reduce
end

function modifier_arc_warden_tempest_double_custom:DeathEvent( params )
if not IsServer() then return end
if not self.parent.owner or self.parent.owner ~= params.unit then return end

local damage = self.parent:GetMaxHealth()*self.health_loss/100

self.parent:GenericParticle("particles/units/heroes/hero_lone_druid/lone_druid_bear_blink_end.vpcf")
self.parent:SetHealth(math.max(1, self.parent:GetHealth() - damage))
self.parent:SendNumber(6, damage)
end



modifier_arc_warden_tempest_double_custom_far = class(mod_hidden)
function modifier_arc_warden_tempest_double_custom_far:CheckState()
return
{
	[MODIFIER_STATE_DISARMED] = true,
	[MODIFIER_STATE_SILENCED] = true,
	[MODIFIER_STATE_MUTED] = true,
}
end

function modifier_arc_warden_tempest_double_custom_far:GetEffectName() 
return "particles/units/heroes/hero_demonartist/demonartist_engulf_disarm/items2_fx/heavens_halberd.vpcf"
end
function modifier_arc_warden_tempest_double_custom_far:GetEffectAttachType()
return PATTACH_OVERHEAD_FOLLOW
end


modifier_arc_warden_tempest_double_custom_tracker = class(mod_hidden)
function modifier_arc_warden_tempest_double_custom_tracker:RemoveOnDeath() return false end
function modifier_arc_warden_tempest_double_custom_tracker:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
	MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
	MODIFIER_PROPERTY_ABSORB_SPELL,
	MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
	MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
	MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE,
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
end

function modifier_arc_warden_tempest_double_custom_tracker:OnCreated()
self.ability = self:GetAbility()
self.parent = self:GetParent()

self.interval = 0.1
self.count = 0
self.max = 5

self.status_bonus = 0

self.crit_damage = self.parent:GetTalentValue("modifier_arc_warden_double_1", "crit")
self.crit_chance = self.parent:GetTalentValue("modifier_arc_warden_double_1", "chance", true)
self.crit_heal = self.parent:GetTalentValue("modifier_arc_warden_double_1", "heal", true)/100
self.crit_heal_creeps = self.parent:GetTalentValue("modifier_arc_warden_double_1", "creeps", true)

self.slow_duration = self.parent:GetTalentValue("modifier_arc_warden_double_2", "duration", true)

self.bkb_cd = self.parent:GetTalentValue("modifier_arc_warden_double_4", "talent_cd", true)
self.bkb_duration = self.parent:GetTalentValue("modifier_arc_warden_double_4", "duration", true)
self.bkb_damage = self.parent:GetTalentValue("modifier_arc_warden_double_4", "damage", true)

self.auto_cd = self.parent:GetTalentValue("modifier_arc_warden_double_3", "cd", true)
self.auto_range = self.parent:GetTalentValue("modifier_arc_warden_double_3", "bonus_range", true)

self.has_reduction = self.parent:HasTalent("modifier_arc_warden_hero_8")
self.heal_inc = self.parent:GetTalentValue("modifier_arc_warden_hero_8", "heal_inc")
self.damage_reduce = self.parent:GetTalentValue("modifier_arc_warden_hero_8", "damage_reduce", true)
self.damage_reduce_bonus = self.parent:GetTalentValue("modifier_arc_warden_hero_8", "bonus", true)
self.damage_reduce_health = self.parent:GetTalentValue("modifier_arc_warden_hero_8", "health", true)
self.damage_reduce_radius = self.parent:GetTalentValue("modifier_arc_warden_hero_8", "radius", true)

if self.parent:HasModifier("modifier_arc_warden_tempest_double") then
	self.status_bonus = self.parent:GetTalentValue("modifier_arc_warden_double_4", "status")
	self.has_crit = self.parent:HasTalent("modifier_arc_warden_double_1")
	self.has_slow = self.parent:HasTalent("modifier_arc_warden_double_2")
	self.has_auto = self.parent:HasTalent("modifier_arc_warden_double_3")
	self.has_bkb = self.parent:HasTalent("modifier_arc_warden_double_4")
end

self.records = {}

if not IsServer() then return end 

self.parent:AddSpellEvent(self, true)
self.tempest_ability = self.parent:FindAbilityByName(self.ability:GetName())

self.tempest_init = false
if not self.parent:IsTempestDouble() then 	
	self:StartIntervalThink(self.interval)
end

self:SetHasCustomTransmitterData(true)
self:UpdateTalent()
end 

function modifier_arc_warden_tempest_double_custom_tracker:OnRefresh()
if not IsServer() then return end
self.tempest_init = false
end

function modifier_arc_warden_tempest_double_custom_tracker:OnIntervalThink() 
if not IsServer() then return end

local tempest = self.parent.tempest_double_tempest

if not self.parent:IsTempestDouble() and tempest and not self.tempest_init then 	
	self.tempest_init = true
	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self.parent:GetPlayerOwnerID()), "update_tempest_entindex_js", {entindex = tempest:entindex()} )
end

if self.has_auto and not self.parent:HasModifier("modifier_arc_warden_tempest_double_custom_auto_cd") and self.parent:IsAlive() and self.tempest_ability 
	and not self.parent:IsInvisible() and not self.parent:HasModifier("modifier_arc_warden_tempest_double_custom_far") then
	local target = self.parent:RandomTarget(self.auto_range + self.parent:Script_GetAttackRange())
	if target then
		ProjectileManager:CreateTrackingProjectile(
		{
			EffectName			= "particles/arc_warden/tempest_attack.vpcf",
			Ability				= self.tempest_ability,
			Source				= self.parent,
			vSourceLoc			= self.parent:GetAbsOrigin(),
			Target				= target,
			iMoveSpeed			= self.parent:GetProjectileSpeed(),
			bDodgeable			= false,
			bVisibleToEnemies	= true,
		})
		self.parent:EmitSound("Arc.Tempest_attack")
		self.parent:AddNewModifier(self.parent, self.ability, "modifier_arc_warden_tempest_double_custom_auto_cd", {duration = self.auto_cd})
	end
end

if self.has_reduction then
	if IsValid(tempest) and tempest:IsAlive() and self.parent:GetHealthPercent() <= self.damage_reduce_health and (tempest:GetAbsOrigin() - self.parent:GetAbsOrigin()):Length2D() <= self.damage_reduce_radius then
		if not self.parent:HasModifier("modifier_arc_warden_tempest_double_custom_lowhp") then
			self.parent:AddNewModifier(self.parent, self.ability, "modifier_arc_warden_tempest_double_custom_lowhp", {target = tempest:entindex()})
		end
	else 
		if self.parent:HasModifier("modifier_arc_warden_tempest_double_custom_lowhp") then
			self.parent:RemoveModifierByName("modifier_arc_warden_tempest_double_custom_lowhp")
		end
	end
end

self.count = self.count + self.interval

if self.count < self.max then return end
self.count = 0

if not IsValid(tempest) then return end 
self.ability:ManageBuffs(tempest)
end 


function modifier_arc_warden_tempest_double_custom_tracker:UpdateTalent(name)
if not IsServer() then return end

if (name == "modifier_arc_warden_double_1" or self.parent:HasTalent("modifier_arc_warden_double_1")) and self.parent:IsTempestDouble() then
	self.has_crit = true
	self.crit_damage = self.parent:GetTalentValue("modifier_arc_warden_double_1", "crit")
	self.parent:AddDamageEvent_out(self, true)
 	self.parent:AddRecordDestroyEvent(self, true)
end

if (name == "modifier_arc_warden_double_2" or self.parent:HasTalent("modifier_arc_warden_double_2")) and self.parent:IsTempestDouble() then
	self.has_slow = true
	self.parent:AddAttackEvent_out(self, true)
end

if (name == "modifier_arc_warden_double_4" or self.parent:HasTalent("modifier_arc_warden_double_4")) and self.parent:IsTempestDouble() then
	self.has_bkb = true
	self.status_bonus = self.parent:GetTalentValue("modifier_arc_warden_double_4", "status")
    self.parent:AddDamageEvent_inc(self, true)
end

if (name == "modifier_arc_warden_double_3" or self.parent:HasTalent("modifier_arc_warden_double_3")) and self.parent:IsTempestDouble() then
	self.has_auto = true
	self:StartIntervalThink(self.interval)
end

if name == "modifier_arc_warden_hero_8" or self.parent:HasTalent("modifier_arc_warden_hero_8") then
	self.has_reduction = not self.parent:IsTempestDouble()
	self.heal_inc = self.parent:GetTalentValue("modifier_arc_warden_hero_8", "heal_inc")
end

if not self.parent:IsTempestDouble() then
	local tempest = self.parent.tempest_double_tempest
	if IsValid(tempest) and tempest:HasModifier(self:GetName()) then
		tempest:FindModifierByName(self:GetName()):UpdateTalent(name)
	end
end

self:SendBuffRefreshToClients()
end

function modifier_arc_warden_tempest_double_custom_tracker:AddCustomTransmitterData() 
return 
{
	status_bonus = self.status_bonus,
  	heal_inc = self.heal_inc,
} 
end

function modifier_arc_warden_tempest_double_custom_tracker:HandleCustomTransmitterData(data)
self.heal_inc = data.heal_inc
self.status_bonus = data.status_bonus
end

function modifier_arc_warden_tempest_double_custom_tracker:GetCritDamage() 
if not self.has_crit then return end
return self.crit_damage
end

function modifier_arc_warden_tempest_double_custom_tracker:GetModifierStatusResistanceStacking()
return self.status_bonus
end

function modifier_arc_warden_tempest_double_custom_tracker:GetModifierLifestealRegenAmplify_Percentage() 
return self.heal_inc
end

function modifier_arc_warden_tempest_double_custom_tracker:GetModifierHealAmplify_PercentageTarget()
return self.heal_inc
end

function modifier_arc_warden_tempest_double_custom_tracker:GetModifierHPRegenAmplify_Percentage() 
return self.heal_inc
end

function modifier_arc_warden_tempest_double_custom_tracker:SpellEvent( params )
if not IsServer() then return end
local unit = params.unit

if unit ~= self.parent then return end

local tempest = self.parent:GetTempest()

if not self.parent:IsTempestDouble() and self.parent:HasTalent("modifier_arc_warden_double_3") then
	if IsValid(tempest) then
		tempest:RemoveModifierByName("modifier_arc_warden_tempest_double_custom_auto_cd")
	end
end
 
if not self.ability.cd_items[params.ability:GetName()] then return end 

local item = tempest:FindItemInInventory(params.ability:GetName())

if not item then return end 
item:UseResources(false, false, false, true)
end


function modifier_arc_warden_tempest_double_custom_tracker:GetModifierPreAttack_CriticalStrike(params)
if not IsServer() then return end
if not self.has_crit then return end
if not params.target:IsUnit() then return end

if not RollPseudoRandomPercentage(self.crit_chance, 830, self.parent) then return end

self.records[params.record] = true
return self.crit_damage
end

function modifier_arc_warden_tempest_double_custom_tracker:DamageEvent_out(params)
if not IsServer() then return end
if not self.has_crit then return end
if not params.unit:IsUnit() then return end
if self.parent ~= params.attacker then return end
if not self.records[params.record] then return end

if self.parent:CheckLifesteal(params, 2) and self.parent.owner then
	local heal = params.damage*self.crit_heal
	heal = params.unit:IsCreep() and heal/self.crit_heal_creeps or heal
	self.parent.owner:GenericHeal(heal, self.ability, nil, nil, "modifier_arc_warden_double_1")
end

params.unit:EmitSound("Arc.Field_crit")
end

function modifier_arc_warden_tempest_double_custom_tracker:RecordDestroyEvent(params)
if not self.records[params.record] then return end
self.records[params.record] = nil
end


function modifier_arc_warden_tempest_double_custom_tracker:AttackEvent_out(params)
if not IsServer() then return end 
if self.parent ~= params.attacker then return end
if not params.target:IsUnit() then return end

if self.has_slow then
	params.target:AddNewModifier(self.parent, self.ability, "modifier_arc_warden_tempest_double_custom_slow", {duration = self.slow_duration})
end

end

function modifier_arc_warden_tempest_double_custom_tracker:DamageEvent_inc(params)
if not IsServer() then return end
if not self.has_bkb then return end
local attacker = params.attacker

if attacker:IsCreep() then return end
if self.parent ~= params.unit then return end
if self.parent:PassivesDisabled() then return end
if attacker:GetTeamNumber() == self.parent:GetTeamNumber() then return end
if self.parent:HasModifier("modifier_arc_warden_tempest_double_custom_bkb_cd") then return end
if params.original_damage < self.bkb_damage then return end

self.parent:AddNewModifier(self.parent, self.ability, "modifier_arc_warden_tempest_double_custom_bkb_cd", {duration = self.bkb_cd})
self.parent:AddNewModifier(self.parent, self.ability, "modifier_generic_debuff_immune", {effect = 2, duration = self.bkb_duration})
self.parent:EmitSound("Arc.Tempest_bkb")

Timers:CreateTimer(0.1, function()
	if IsValid(self.parent) then
		self.parent:Purge(false, true, false, true, false)
	end
end)

return 0
end

function modifier_arc_warden_tempest_double_custom_tracker:GetModifierIncomingDamage_Percentage(params)
if not IsServer() then return end 
if not self.has_reduction then return end

local tempest = self.parent.tempest_double_tempest
if not IsValid(tempest) or not tempest:IsAlive() then return end
if (tempest:GetAbsOrigin() - self.parent:GetAbsOrigin()):Length2D() > self.damage_reduce_radius then return end

local damage_reduce = self.parent:GetHealthPercent() <= self.damage_reduce_health and self.damage_reduce_bonus*self.damage_reduce or self.damage_reduce

local damage = (params.damage*damage_reduce*-1)/100

DoDamage({damage = damage, victim = tempest, attacker = params.attacker, ability = params.inflictor, damage_type = DAMAGE_TYPE_PURE, damage_flags = DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION})
return damage_reduce
end 





arc_warden_tempest_double_custom_legendary = class({})

function arc_warden_tempest_double_custom_legendary:GetCooldown()
return self:GetCaster():GetTalentValue("modifier_arc_warden_double_7", "talent_cd")
end 

function arc_warden_tempest_double_custom_legendary:GetChannelTime()
return self:GetCaster():GetTalentValue("modifier_arc_warden_double_7", "cast")
end 

function arc_warden_tempest_double_custom_legendary:OnSpellStart()
local caster = self:GetCaster()

caster:RemoveModifierByName("modifier_arc_warden_tempest_double_custom_legendary_buff")
caster:AddNewModifier(caster, self, "modifier_arc_warden_tempest_double_custom_legendary", {})
self:EndCd()
end 


function arc_warden_tempest_double_custom_legendary:OnChannelFinish(bInterrupted)
local caster = self:GetCaster()
self:StartCd()

caster:RemoveModifierByName("modifier_arc_warden_tempest_double_custom_legendary")

local target = caster.owner
if not IsValid(target) or not target:IsAlive() then return end

local point = target:GetAbsOrigin()
local caster_point = caster:GetAbsOrigin()

EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Arc.Teleport_start", caster)
EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Arc.Teleport_start2", caster)
EmitSoundOnLocationWithCaster(point, "Arc.Teleport_end", caster)

local particle = ParticleManager:CreateParticle( "particles/arc_warden/legendary_tp_start.vpcf", PATTACH_WORLDORIGIN, nil )
ParticleManager:SetParticleControl(particle, 0,  caster:GetAbsOrigin())
ParticleManager:ReleaseParticleIndex(particle)

particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_arc_warden/arc_warden_tempest_cast.vpcf", PATTACH_WORLDORIGIN, caster )
ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin())
ParticleManager:ReleaseParticleIndex(particle)

caster:AddNewModifier(caster, self, "modifier_arc_warden_tempest_double_custom_legendary_tp", {duration = 0.2, x = point.x, y = point.y})
target:AddNewModifier(target, self, "modifier_arc_warden_tempest_double_custom_legendary_tp", {duration = 0.2, x = caster_point.x, y = caster_point.y})

particle = ParticleManager:CreateParticle( "particles/arc_warden/legendary_tp_end.vpcf", PATTACH_WORLDORIGIN, nil )
ParticleManager:SetParticleControl(particle, 0,  point)
ParticleManager:ReleaseParticleIndex(particle)
end 



modifier_arc_warden_tempest_double_custom_legendary = class(mod_hidden)
function modifier_arc_warden_tempest_double_custom_legendary:OnCreated(table)
if not IsServer() then return end 

self.parent = self:GetParent()
self.ability = self:GetAbility()

self.parent:EmitSound("Arc.Teleport_cast")
self.parent:StartGestureWithPlaybackRate(ACT_DOTA_VICTORY, 1.4)
self.parent:GenericParticle("particles/arc_warden/legendary_tp_tube_tempest.vpcf", self)
self.parent:EmitSound("Arc.Teleport_loop")
self.parent:EmitSound("Arc.Teleport_loop2")

self.duration = self.parent:GetTalentValue("modifier_arc_warden_double_7", "duration")
self.cast = self.parent:GetTalentValue("modifier_arc_warden_double_7", "cast")
self.max = self.parent:GetTalentValue("modifier_arc_warden_double_7", "stack")

self.interval = self.cast/self.max
self.visual_interval = 2
self.visual_count = 0

self:OnIntervalThink()
self:StartIntervalThink(self.interval)
end 

function modifier_arc_warden_tempest_double_custom_legendary:OnIntervalThink()
if not IsServer() then return end

self.parent:AddNewModifier(self.parent, self.ability, "modifier_arc_warden_tempest_double_custom_legendary_buff", {duration = self.duration})

self.visual_count = self.visual_count + 1
if self.visual_count < self.visual_interval then return end

self.visual_count = 0

local cast_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_arc_warden/arc_warden_flux_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
ParticleManager:SetParticleControlEnt(cast_particle, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
ParticleManager:SetParticleControl(cast_particle, 1, self.parent:GetAbsOrigin() + RandomVector(RandomInt(50, 250)))
ParticleManager:SetParticleControlEnt(cast_particle, 2, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
ParticleManager:ReleaseParticleIndex(cast_particle)
end

function modifier_arc_warden_tempest_double_custom_legendary:OnDestroy()
if not IsServer() then return end 
self.parent:StopSound("Arc.Teleport_loop")
self.parent:StopSound("Arc.Teleport_loop2")
self.parent:FadeGesture(ACT_DOTA_VICTORY)
end 


function modifier_arc_warden_tempest_double_custom_legendary:CheckState()
return
{
	[MODIFIER_STATE_IGNORING_MOVE_AND_ATTACK_ORDERS] = true
}
end


modifier_arc_warden_tempest_double_custom_legendary_tp = class({})
function modifier_arc_warden_tempest_double_custom_legendary_tp:IsHidden() return true end
function modifier_arc_warden_tempest_double_custom_legendary_tp:IsPurgable() return false end
function modifier_arc_warden_tempest_double_custom_legendary_tp:OnCreated(table)
if not IsServer() then return end 
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.parent:NoDraw(self)
self.parent:AddNoDraw()

self.parent:InterruptMotionControllers(false)

self.point = GetGroundPosition(Vector(table.x, table.y, 0), nil)
self:StartIntervalThink(0.1)
end 

function modifier_arc_warden_tempest_double_custom_legendary_tp:OnIntervalThink()
if not IsServer() then return end 
if not self.parent or self.parent:IsNull() then return end

FindClearSpaceForUnit(self.parent, self.point, false)
self:StartIntervalThink(-1)
end 


function modifier_arc_warden_tempest_double_custom_legendary_tp:OnDestroy()
if not IsServer() then return end 
self.parent:RemoveNoDraw()

self.parent:Stop()
self.parent:EmitSound("Arc.Teleport_end2")
self.parent:StartGesture(ACT_DOTA_TELEPORT_END)

particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_arc_warden/arc_warden_tempest_cast.vpcf", PATTACH_WORLDORIGIN, self.parent )
ParticleManager:SetParticleControl(particle, 0, self.parent:GetAbsOrigin())
ParticleManager:ReleaseParticleIndex(particle)
end 

function modifier_arc_warden_tempest_double_custom_legendary_tp:CheckState()
return
{
	[MODIFIER_STATE_STUNNED] = true,
	[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
	[MODIFIER_STATE_INVULNERABLE] = true,
	[MODIFIER_STATE_OUT_OF_GAME] = true
}
end



modifier_arc_warden_tempest_double_custom_legendary_buff = class(mod_hidden)
function modifier_arc_warden_tempest_double_custom_legendary_buff:OnCreated(table)
self.parent = self:GetParent()
self.ability = self:GetAbility()
self.owner = self.parent.owner

self.duration = self.parent:GetTalentValue("modifier_arc_warden_double_7", "duration")
self.cast = self.parent:GetTalentValue("modifier_arc_warden_double_7", "cast")
self.max = self.parent:GetTalentValue("modifier_arc_warden_double_7", "stack")
self.damage = self.parent:GetTalentValue("modifier_arc_warden_double_7", "damage")/self.max
self.health = self.parent:GetTalentValue("modifier_arc_warden_double_7", "health")/self.max
self.size = 30/self.max
if not IsServer() then return end
self.parent:EmitSound("Arc.Buff_loop")

self:SetStackCount(1)
self:OnIntervalThink()
self:StartIntervalThink(0.1)
end

function modifier_arc_warden_tempest_double_custom_legendary_buff:OnRefresh()
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end
self:IncrementStackCount()
self.parent:CalculateStatBonus(true)
end

function modifier_arc_warden_tempest_double_custom_legendary_buff:OnIntervalThink()
if not IsServer() then return end

local max_time = self.duration
local time = self:GetRemainingTime()
local stack = (100/self.max)*self:GetStackCount()
local active = 1
local mod = self.parent:FindModifierByName("modifier_arc_warden_tempest_double_custom_legendary")
if mod then
	active = 0
	max_time = self.cast
	time = mod:GetElapsedTime()
end

self.owner:UpdateUIshort({max_time = max_time, time = time, stack = stack.."%", active = active, priority = 2, style = "ArcTempest"})
end

function modifier_arc_warden_tempest_double_custom_legendary_buff:OnDestroy()
if not IsServer() then return end
self.owner:UpdateUIshort({hide = 1, priority = 2, style = "ArcTempest"})
self.parent:StopSound("Arc.Buff_loop")
self.parent:CalculateStatBonus(true)
end

function modifier_arc_warden_tempest_double_custom_legendary_buff:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
	MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE,
  	MODIFIER_PROPERTY_PROJECTILE_NAME,
	MODIFIER_PROPERTY_MODEL_SCALE
}
end

function modifier_arc_warden_tempest_double_custom_legendary_buff:GetModifierExtraHealthPercentage()
return self.health*self:GetStackCount()
end

function modifier_arc_warden_tempest_double_custom_legendary_buff:GetModifierDamageOutgoing_Percentage()
return self.damage*self:GetStackCount()
end

function modifier_arc_warden_tempest_double_custom_legendary_buff:GetModifierModelScale()
return self.size*self:GetStackCount()
end

function modifier_arc_warden_tempest_double_custom_legendary_buff:GetEffectName()
return "particles/generic_gameplay/rune_doubledamage_owner.vpcf"
end

function modifier_arc_warden_tempest_double_custom_legendary_buff:GetModifierProjectileName()
return "particles/arc_warden/field_attack.vpcf"
end



modifier_arc_warden_tempest_double_custom_lowhp = class(mod_hidden)
function modifier_arc_warden_tempest_double_custom_lowhp:OnCreated(table)
if not IsServer() then return end
self.parent = self:GetParent()
self.target = EntIndexToHScript(table.target)

self.parent:EmitSound("Arc.Tempest_reduce")
self.parent:GenericParticle("particles/arc_warden/tempest_reduce.vpcf", self)

self.particle = ParticleManager:CreateParticle("particles/arc_warden/tempest_tether.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
ParticleManager:SetParticleControlEnt( self.particle, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetOrigin(), true )
ParticleManager:SetParticleControlEnt( self.particle, 1, self.target, PATTACH_POINT_FOLLOW, "attach_hitloc", self.target:GetOrigin(), true )
self:AddParticle(self.particle, false, false, -1, false, false)
end 



modifier_arc_warden_tempest_double_custom_slow = class({})
function modifier_arc_warden_tempest_double_custom_slow:IsHidden() return true end
function modifier_arc_warden_tempest_double_custom_slow:IsPurgable() return true end
function modifier_arc_warden_tempest_double_custom_slow:GetEffectName() return "particles/units/heroes/hero_terrorblade/terrorblade_reflection_slow.vpcf" end
function modifier_arc_warden_tempest_double_custom_slow:OnCreated()
self.caster = self:GetCaster()
self.slow = self.caster:GetTalentValue("modifier_arc_warden_double_2", "slow")
self.heal_reduce = self.caster:GetTalentValue("modifier_arc_warden_double_2", "heal_reduce")
end 

function modifier_arc_warden_tempest_double_custom_slow:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
	MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
	MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE,
}
end

function modifier_arc_warden_tempest_double_custom_slow:GetModifierLifestealRegenAmplify_Percentage() 
return self.heal_reduce
end

function modifier_arc_warden_tempest_double_custom_slow:GetModifierHealAmplify_PercentageTarget()
return self.heal_reduce
end

function modifier_arc_warden_tempest_double_custom_slow:GetModifierHPRegenAmplify_Percentage() 
return self.heal_reduce
end

function modifier_arc_warden_tempest_double_custom_slow:GetModifierMoveSpeedBonus_Percentage()
return self.slow
end




modifier_arc_warden_tempest_double_custom_items = class(mod_hidden)
function modifier_arc_warden_tempest_double_custom_items:RemoveOnDeath() return false end
function modifier_arc_warden_tempest_double_custom_items:OnCreated()
if not IsServer() then return end 
self.parent = self:GetParent()
self.ability = self:GetAbility()
self:StartIntervalThink(0.1)
end 

function modifier_arc_warden_tempest_double_custom_items:OnIntervalThink()
if not IsServer() then return end
if not self.parent:IsAlive() then return end
if self.parent:IsChanneling() then return end

self.ability:ManageItems(self.parent)
self:Destroy()
end 



arc_warden_tempest_double_custom_reunion = class({})

function arc_warden_tempest_double_custom_reunion:GetChannelTime() 
return self:GetSpecialValueFor("channel_time")
end

function arc_warden_tempest_double_custom_reunion:OnAbilityPhaseStart()
return self:GetCaster():CanTeleport() 
end

function arc_warden_tempest_double_custom_reunion:OnSpellStart()
local caster = self:GetCaster()

caster:AddNewModifier(caster, self, "modifier_arc_warden_tempest_double_custom_scepter_tp", {})
end 


function arc_warden_tempest_double_custom_reunion:OnChannelFinish(bInterrupted)
local caster = self:GetCaster()

caster:RemoveModifierByName("modifier_arc_warden_tempest_double_custom_scepter_tp")

local target = caster.tempest_double_tempest
if bInterrupted then return end
if not IsValid(target) or not target:IsAlive() then return end

local point = target:GetAbsOrigin()

EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Arc.Teleport_start", caster)
EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Arc.Teleport_start2", caster)
EmitSoundOnLocationWithCaster(point, "Arc.Teleport_end", caster)

local particle = ParticleManager:CreateParticle( "particles/arc_warden/legendary_tp_start.vpcf", PATTACH_WORLDORIGIN, nil )
ParticleManager:SetParticleControl(particle, 0,  caster:GetAbsOrigin())
ParticleManager:ReleaseParticleIndex(particle)

particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_arc_warden/arc_warden_tempest_cast.vpcf", PATTACH_WORLDORIGIN, caster )
ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin())
ParticleManager:ReleaseParticleIndex(particle)

caster:AddNewModifier(caster, self, "modifier_arc_warden_tempest_double_custom_legendary_tp", {duration = 0.2, x = point.x, y = point.y})

particle = ParticleManager:CreateParticle( "particles/arc_warden/legendary_tp_end.vpcf", PATTACH_WORLDORIGIN, nil )
ParticleManager:SetParticleControl(particle, 0,  point)
ParticleManager:ReleaseParticleIndex(particle)

local spark = caster:FindAbilityByName("arc_warden_spark_wraith_custom")
local tempest = caster:FindAbilityByName("arc_warden_tempest_double_custom")
if spark and spark:IsTrained() and tempest then
	local radius = tempest:GetSpecialValueFor("scepter_radius")
	for _,aoe_target in pairs(caster:FindTargets(radius, point)) do
		spark:LaunchSpark(aoe_target, target, "Scepter")
	end
end

end 


function arc_warden_tempest_double_custom_reunion:OnChannelThink(fInterval)
local caster = self:GetCaster()
if not caster:TeleportThink() then 
    caster:Stop()
    caster:Interrupt() 
end 

end


modifier_arc_warden_tempest_double_custom_scepter_tp = class(mod_hidden)
function modifier_arc_warden_tempest_double_custom_scepter_tp:OnCreated(table)
if not IsServer() then return end 

self.parent = self:GetParent()
self.ability = self:GetAbility()

self.parent:EmitSound("Arc.Teleport_cast")
self.parent:StartGestureWithPlaybackRate(ACT_DOTA_VICTORY, 1.4)
self.parent:GenericParticle("particles/arc_warden/legendary_tp_tube.vpcf", self)
self.parent:EmitSound("Arc.Teleport_loop")
end 


function modifier_arc_warden_tempest_double_custom_scepter_tp:OnDestroy()
if not IsServer() then return end 
self.parent:StopSound("Arc.Teleport_loop")
self.parent:FadeGesture(ACT_DOTA_VICTORY)
end 


function modifier_arc_warden_tempest_double_custom_scepter_tp:CheckState()
return
{
	[MODIFIER_STATE_IGNORING_MOVE_AND_ATTACK_ORDERS] = true
}
end


modifier_arc_warden_tempest_double_custom_bkb_cd = class(mod_cd)
function modifier_arc_warden_tempest_double_custom_bkb_cd:GetTexture() return "buffs/arc_warden/double_4" end


modifier_arc_warden_tempest_double_custom_auto_cd = class(mod_hidden)
function modifier_arc_warden_tempest_double_custom_auto_cd:OnDestroy()
if not IsServer() then return end
local mod = self:GetParent():FindModifierByName("modifier_arc_warden_tempest_double_custom_tracker")
if mod then
	mod:OnIntervalThink()
end

end


modifier_arc_warden_tempest_double_custom_auto_damage = class(mod_hidden)
function modifier_arc_warden_tempest_double_custom_auto_damage:OnCreated()
self.damage = self:GetParent():GetTalentValue("modifier_arc_warden_double_3", "damage") - 100
end

function modifier_arc_warden_tempest_double_custom_auto_damage:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
}
end

function modifier_arc_warden_tempest_double_custom_auto_damage:GetModifierTotalDamageOutgoing_Percentage()
return self.damage
end