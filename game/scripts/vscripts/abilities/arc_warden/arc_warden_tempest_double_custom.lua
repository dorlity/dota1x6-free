LinkLuaModifier("modifier_arc_warden_tempest_double_custom", "abilities/arc_warden/arc_warden_tempest_double_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_arc_warden_tempest_double_custom_far", "abilities/arc_warden/arc_warden_tempest_double_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_arc_warden_tempest_double_custom_tracker", "abilities/arc_warden/arc_warden_tempest_double_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_arc_warden_tempest_double_custom_legendary", "abilities/arc_warden/arc_warden_tempest_double_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_arc_warden_tempest_double_custom_legendary_tp", "abilities/arc_warden/arc_warden_tempest_double_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_arc_warden_tempest_double_custom_cdr_stack", "abilities/arc_warden/arc_warden_tempest_double_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_arc_warden_tempest_double_custom_lowhp", "abilities/arc_warden/arc_warden_tempest_double_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_arc_warden_tempest_double_custom_rune_1", "abilities/arc_warden/arc_warden_tempest_double_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_arc_warden_tempest_double_custom_rune_2", "abilities/arc_warden/arc_warden_tempest_double_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_arc_warden_tempest_double_custom_rune_3", "abilities/arc_warden/arc_warden_tempest_double_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_arc_warden_tempest_double_custom_rune_4", "abilities/arc_warden/arc_warden_tempest_double_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_arc_warden_tempest_double_custom_proj", "abilities/arc_warden/arc_warden_tempest_double_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_arc_warden_tempest_double_custom_slow", "abilities/arc_warden/arc_warden_tempest_double_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_arc_warden_tempest_double_custom_items", "abilities/arc_warden/arc_warden_tempest_double_custom", LUA_MODIFIER_MOTION_NONE)

--

arc_warden_tempest_double_custom = class({})





arc_warden_tempest_double_custom.cd_items = 
{
	["item_sheepstick"] = true,
	["item_abyssal_blade"] = true
}




function arc_warden_tempest_double_custom:Precache(context)

PrecacheResource( "particle", "particles/arc_warden/legendary_kill.vpcf", context )
PrecacheResource( "particle", "particles/arc_warden/legendary_tp_start.vpcf", context )
PrecacheResource( "particle", "particles/arc_warden/legendary_tp_end.vpcf", context )
PrecacheResource( "particle", "particles/arc_warden/legendary_tp_tube.vpcf", context )
PrecacheResource( "particle", "particles/arc_warden/legendary_tp_tube_tempest.vpcf", context )
PrecacheResource( "particle", "particles/rare_orb_patrol.vpcf", context )
PrecacheResource( "particle", "particles/arc_warden/tempest_reduce.vpcf", context )
PrecacheResource( "particle", "particles/arc_warden/tempest_tether.vpcf", context )
PrecacheResource( "particle", "particles/lc_odd_proc_.vpcf", context )
PrecacheResource( "particle", "particles/arc_warden/tempest_rune_arcane.vpcf", context )
PrecacheResource( "particle", "particles/brist_lowhp_.vpcf", context )
PrecacheResource( "particle", "particles/arc_warden/tempest_attack.vpcf", context )

end



function arc_warden_tempest_double_custom:GetCastPoint()

if self:GetCaster():HasModifier("modifier_arc_warden_double_6") then 
  return 0
end

return self:GetSpecialValueFor("AbilityCastPoint")
 
end




function arc_warden_tempest_double_custom:GetCooldown(level)
local bonus = 0

if self:GetCaster():HasModifier("modifier_arc_warden_double_3") then 
	bonus = self:GetCaster():GetTalentValue("modifier_arc_warden_double_3", "cd")
end 

	return self.BaseClass.GetCooldown(self, level)  + bonus
end



function arc_warden_tempest_double_custom:GetIntrinsicModifierName()
if self:GetCaster():HasModifier("modifier_arc_warden_tempest_double") then return end
return "modifier_arc_warden_tempest_double_custom_tracker"
end


function arc_warden_tempest_double_custom:OnInventoryContentsChanged()
if not self:GetCaster():HasModifier("modifier_arc_warden_double_7") then return end

local tempest = self.tempest
if not tempest or tempest:IsNull() then return end 

tempest:AddNewModifier(tempest, self, "modifier_arc_warden_tempest_double_custom_items", {})


end 



function arc_warden_tempest_double_custom:OnSpellStart()
if not IsServer() then return end
local caster = self:GetCaster()
local ability = self

local point = self:GetCursorPosition()

if not caster or caster:IsNull() then return end

if caster:IsTempestDouble() then return end

local tempest = ability:GetHerotempest()

if not tempest or tempest:IsNull() then return end

tempest:RespawnHero(false, false)

self:ModifyTempest(tempest)

tempest:SetHealth(caster:GetMaxHealth())
tempest:SetMana(caster:GetMaxMana())
tempest:SetBaseAgility(caster:GetBaseAgility())
tempest:SetBaseStrength(caster:GetBaseStrength())
tempest:SetBaseIntellect(caster:GetBaseIntellect())
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
local duration = ability:GetSpecialValueFor("duration")

caster.tempest_double_tempest = tempest

tempest:RemoveGesture(ACT_DOTA_DIE)


FindClearSpaceForUnit(tempest, point, true)

if not self:GetCaster():HasModifier("modifier_arc_warden_double_7") then 
	tempest:AddNewModifier(caster, self, "modifier_kill", {duration = duration})
	tempest:AddNewModifier(caster, self, "modifier_arc_warden_tempest_double_custom", {duration = duration})
else 
	tempest:AddNewModifier(caster, self, "modifier_arc_warden_tempest_double_custom", {})
end

local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_arc_warden/arc_warden_tempest_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
ParticleManager:SetParticleControlEnt(particle, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
ParticleManager:ReleaseParticleIndex(particle)


local particle2 = ParticleManager:CreateParticle( "particles/units/heroes/hero_arc_warden/arc_warden_tempest_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, tempest )
ParticleManager:SetParticleControlEnt(particle2, 0, tempest, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", tempest:GetAbsOrigin(), true)
ParticleManager:ReleaseParticleIndex(particle2)

caster:EmitSound("Hero_ArcWarden.TempestDouble")

self:ScepterSpark(tempest)

end



function arc_warden_tempest_double_custom:OnProjectileHit(hTarget, vLocation)
if not IsServer() then return end 
if not hTarget then return end 


hTarget:EmitSound("Arc.Legendary_kill")
local particle = ParticleManager:CreateParticle( "particles/arc_warden/legendary_kill.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
ParticleManager:SetParticleControlEnt(particle, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(particle, 2, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
ParticleManager:ReleaseParticleIndex(particle)

end 




function arc_warden_tempest_double_custom:ScepterSpark(caster)

local spark = caster:FindAbilityByName("arc_warden_spark_wraith_custom")
if spark and spark:GetLevel() > 0 and caster:HasScepter() then 
	
	local qangle_rotation_rate = 360/spark:GetSpecialValueFor("scepter_tempest")
	local line_position = caster:GetAbsOrigin() + caster:GetForwardVector() * spark:GetSpecialValueFor("scepter_radius")
	for i = 1, spark:GetSpecialValueFor("scepter_tempest") do

		local qangle = QAngle(0, qangle_rotation_rate, 0)
		line_position = RotatePosition(caster:GetAbsOrigin() , qangle, line_position)

		spark:CreateSpark(line_position)

	end

end 

end 





function arc_warden_tempest_double_custom:GetHerotempest()
local caster = self:GetCaster()
if not caster or caster:IsNull() then return end

-- Создание или респавн клона
if not self.tempest then
	if caster.tempest_double_tempest then
		self.tempest = caster.tempest_double_tempest
	else
		local tempest = CreateUnitByName( caster:GetUnitName(), caster:GetAbsOrigin(), true, caster, caster, caster:GetTeamNumber()  )

        tempest:AddNewModifier(caster, self, "modifier_arc_warden_tempest_double", {})
        local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_arc_warden/arc_warden_tempest_eyes.vpcf", PATTACH_ABSORIGIN, tempest )
        ParticleManager:SetParticleControlEnt(particle, 0, tempest, PATTACH_POINT_FOLLOW, "attach_head", tempest:GetAbsOrigin(), true)
    --    tempest:SetPlayerID(caster:GetPlayerOwnerID())
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


for i = 0 , 16 do
	local tempest_item = tempest:GetItemInSlot(i)
	if tempest_item then
		UTIL_Remove(tempest_item)
	end
end

-- Выдача предметов
for itemSlot = 0,16 do
    local itemName = caster:GetItemInSlot(itemSlot)


    if itemName then 
        if itemName:GetName() ~= "item_rapier" and itemName:GetName() ~= "item_gem" and itemName:IsPermanent() then


            local newItem = CreateItem(itemName:GetName(), nil, nil)
            tempest:AddItem(newItem)


            if itemName and itemName:GetCurrentCharges() > 0 and newItem and not newItem:IsNull() then
                newItem:SetCurrentCharges(itemName:GetCurrentCharges())
            end
            if newItem and not newItem:IsNull() then
                tempest:SwapItems(newItem:GetItemSlot(), itemSlot)
            end

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

for _,modifier in pairs(caster:FindAllModifiers()) do 

    if (modifier.StackOnIllusion ~= nil and modifier.StackOnIllusion == true) or modifier:GetName() == "modifier_item_ultimate_scepter_consumed"
    or modifier:GetName() == "modifier_item_aghanims_shard" or modifier:GetName() == "modifier_item_moon_shard_consumed" then 

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

				if caster:HasModifier("modifier_arc_warden_double_7") and legendary and legendary:IsHidden() then 
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


----------------------------------------------------------------------------
modifier_arc_warden_tempest_double_custom = class({})
function modifier_arc_warden_tempest_double_custom:IsHidden() return true end
function modifier_arc_warden_tempest_double_custom:IsPurgable() return false end


function modifier_arc_warden_tempest_double_custom:OnCreated()
local caster = self:GetCaster()
local ability = self:GetAbility()
if not ability or ability:IsNull() then return end

self.far_distance = ability:GetSpecialValueFor("far_distance")

if not IsServer() then return end

self.bounty = ability:GetSpecialValueFor("bounty")
self.parent = self:GetParent()
self.caster = caster
self.ability = ability
self.far_distance = ability:GetSpecialValueFor("far_distance")
self.damage_reduce = ability:GetSpecialValueFor("damage_reduce")

self.health_loss = ability:GetSpecialValueFor("health_loss")

self.str = 0

self:GetAbility():EndCooldown()
self:GetAbility():SetActivated(false)

local legendary = self:GetCaster():FindAbilityByName("arc_warden_tempest_double_custom_legendary")

if self:GetCaster():HasModifier("modifier_arc_warden_double_7") and legendary and legendary:IsHidden() then 
	self:GetCaster():SwapAbilities(self:GetAbility():GetName(), legendary:GetName(), false, true)
end

self:StartIntervalThink(0.1)
end

function modifier_arc_warden_tempest_double_custom:OnIntervalThink()
if not IsServer() then return end


local length = (self.caster:GetAbsOrigin() - self.parent:GetAbsOrigin()):Length2D()
if length > self.far_distance and self.caster:IsAlive() then
    self.parent:AddNewModifier(self.caster, self.ability, "modifier_arc_warden_tempest_double_custom_far", {})
else
    self.parent:RemoveModifierByName("modifier_arc_warden_tempest_double_custom_far")
end


if not self:GetParent():HasModifier("modifier_arc_warden_double_3") then return end

self.str_percentage = self:GetCaster():GetTalentValue("modifier_arc_warden_double_3", "strength")/100

self.PercentStr = self.str_percentage
self.PercentAgi = self.str_percentage
self.PercentInt = self.str_percentage

self:GetParent():CalculateStatBonus(true)

end


function modifier_arc_warden_tempest_double_custom:DeclareFunctions()
	return 
    {
        MODIFIER_EVENT_ON_DEATH,
        MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
    	MODIFIER_EVENT_ON_ABILITY_EXECUTED,
    	MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
    	MODIFIER_EVENT_ON_ATTACK_LANDED,

		MODIFIER_PROPERTY_MANACOST_PERCENTAGE
	}
end



function modifier_arc_warden_tempest_double_custom:GetModifierAttackRangeBonus()
if not self:GetCaster():HasModifier("modifier_arc_warden_double_2") then return end 

return self:GetCaster():GetTalentValue("modifier_arc_warden_double_2", "range")
end



function modifier_arc_warden_tempest_double_custom:OnAttackLanded(params)
if not IsServer() then return end 
if not self:GetParent():HasModifier("modifier_arc_warden_double_2") then return end 
if self:GetParent() ~= params.attacker then return end 
if not params.target:IsHero() and not params.target:IsCreep() then return end 

params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_arc_warden_tempest_double_custom_slow", {})

end 


function modifier_arc_warden_tempest_double_custom:OnAbilityExecuted( params )
if not IsServer() then return end
if params.unit~=self:GetParent() then return end
if not params.ability then return end
if params.ability:IsToggle() then return end
if UnvalidAbilities[params.ability:GetName()] then return end
if UnvalidItems[params.ability:GetName()] then return end
if params.ability:IsItem() and params.ability:GetCurrentCharges() > 0 then return end
if not self:GetParent().owner then return end 

local owner = self:GetParent().owner




if not self:GetParent():HasModifier("modifier_arc_warden_double_6") then return end
	owner:CdItems(self:GetCaster():GetTalentValue("modifier_arc_warden_double_6", "cd"))

end








function modifier_arc_warden_tempest_double_custom:GetModifierPercentageManacost()
local reduce = 0

if self:GetCaster():HasModifier("modifier_arc_warden_double_6") then 
	reduce = self:GetCaster():GetTalentValue("modifier_arc_warden_double_6", "mana")
end

return reduce
end



function modifier_arc_warden_tempest_double_custom:GetModifierDamageOutgoing_Percentage()
if not self:GetAbility() then return end 
return self:GetAbility():GetSpecialValueFor("damage_reduce")
end


function modifier_arc_warden_tempest_double_custom:OnDeath( params )
if not IsServer() then return end
if not self.parent or self.parent:IsNull() then return end

if self.parent.owner and self.parent.owner == params.unit then 
	local damage = self.parent:GetMaxHealth()*self.health_loss/100

	SendOverheadEventMessage(self:GetParent(), 6, self:GetParent(), damage, nil)

	local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_lone_druid/lone_druid_bear_blink_end.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent )
	ParticleManager:SetParticleControl(particle, 0, self.parent:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex( particle )
	
	self:GetParent():SetHealth(math.max(1, self.parent:GetHealth() - damage))
end 


if params.unit ~= self.parent then return end


if not params.attacker or params.attacker:IsNull() then return end
if params.attacker and params.attacker.GetPlayerOwnerID and params.attacker:GetPlayerOwnerID() then
    local hKillerHero = PlayerResource:GetSelectedHeroEntity(params.attacker:GetPlayerOwnerID())
    if hKillerHero and hKillerHero.IsRealHero and hKillerHero:IsRealHero() then
        if hKillerHero:GetTeamNumber()~=self.parent:GetTeamNumber() then

        end
    end
end



end

function modifier_arc_warden_tempest_double_custom:OnDestroy()
if not IsServer() then return end 

local legendary = self:GetCaster():FindAbilityByName("arc_warden_tempest_double_custom_legendary")

if self:GetCaster():HasModifier("modifier_arc_warden_double_7") and legendary and not legendary:IsHidden() then 
	self:GetCaster():SwapAbilities(self:GetAbility():GetName(), legendary:GetName(), true, false)
end


self:GetAbility():SetActivated(true)
self:GetAbility():UseResources(false, false, false, true)

self:GetAbility():ScepterSpark(self:GetParent())
end 



----------------------------------------------------------------------------
modifier_arc_warden_tempest_double_custom_far = class({})
function modifier_arc_warden_tempest_double_custom_far:IsPurgable() return false end
function modifier_arc_warden_tempest_double_custom_far:IsHidden() return true end
function modifier_arc_warden_tempest_double_custom_far:IsPurgeException() return false end

function modifier_arc_warden_tempest_double_custom_far:CheckState()
if self:GetParent():HasModifier("modifier_arc_warden_tempest_double_custom_legendary") then return end
return
{
	[MODIFIER_STATE_DISARMED] = true,
	[MODIFIER_STATE_MUTED] = true,
	[MODIFIER_STATE_SILENCED] = true,
}
end

function modifier_arc_warden_tempest_double_custom_far:GetEffectName() 
	return "particles/units/heroes/hero_demonartist/demonartist_engulf_disarm/items2_fx/heavens_halberd.vpcf"
end
function modifier_arc_warden_tempest_double_custom_far:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end




function modifier_arc_warden_tempest_double_custom_far:OnCreated()
if not IsServer() then return end 

end 




function modifier_arc_warden_tempest_double_custom_far:OnDestroy()
if not IsServer() then return end 



end 








modifier_arc_warden_tempest_double_custom_tracker = class({})
function modifier_arc_warden_tempest_double_custom_tracker:IsHidden() return true end
function modifier_arc_warden_tempest_double_custom_tracker:IsPurgable() return false end
function modifier_arc_warden_tempest_double_custom_tracker:DeclareFunctions()
return
{
    MODIFIER_EVENT_ON_ABILITY_EXECUTED,
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    MODIFIER_EVENT_ON_TAKEDAMAGE,
    MODIFIER_EVENT_ON_DEATH
}
end


function modifier_arc_warden_tempest_double_custom_tracker:OnCreated()
if not IsServer() then return end 

self.interval = 0.1
self.count = 0
self.max = 5

self:StartIntervalThink(self.interval)
end 


function modifier_arc_warden_tempest_double_custom_tracker:OnIntervalThink() 
if not IsServer() then return end
if not self:GetParent().tempest_double_tempest then return end 

local player =    PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID())
if player then
    CustomGameEventManager:Send_ServerToPlayer(player, "update_tempest_entindex_js", {entindex = self:GetParent().tempest_double_tempest:entindex()} )
end


local tempest = self:GetParent().tempest_double_tempest

self.count = self.count + self.interval

if self:GetParent():HasModifier("modifier_arc_warden_double_5") then

	if not tempest:IsNull() and tempest:IsAlive() and self:GetParent():GetHealthPercent() <= self:GetCaster():GetTalentValue("modifier_arc_warden_double_5", "health")
		and (tempest:GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D() <= self:GetCaster():GetTalentValue("modifier_arc_warden_double_5", "range") then

		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_arc_warden_tempest_double_custom_lowhp", {target = tempest:entindex()})
	else 
		self:GetParent():RemoveModifierByName("modifier_arc_warden_tempest_double_custom_lowhp")
	end
end


if self.count >= self.max then 
	self.count = 0
else 
	return
end 

if tempest:IsNull() or not tempest:IsAlive() then return end 

self:GetAbility():ManageBuffs(tempest)

end 



function modifier_arc_warden_tempest_double_custom_tracker:GetModifierIncomingDamage_Percentage(params)
if not IsServer() then return end 
if self:GetParent():IsTempestDouble() or self:GetParent():IsIllusion() then return end
if not self:GetParent():HasModifier("modifier_arc_warden_double_5") then return end 
if self:GetParent():GetHealthPercent() > self:GetCaster():GetTalentValue("modifier_arc_warden_double_5", "health") then return end 

if not self:GetParent().tempest_double_tempest or self:GetParent().tempest_double_tempest:IsNull() then return end 
if not self:GetParent().tempest_double_tempest:IsAlive() then return end

local tempest = self:GetParent().tempest_double_tempest 
if (tempest:GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D() > self:GetCaster():GetTalentValue("modifier_arc_warden_double_5", "range") then return end 

local damage = params.damage*self:GetCaster():GetTalentValue("modifier_arc_warden_double_5", "damage")/100

ApplyDamage({damage = damage, victim = tempest, attacker = params.attacker, ability = params.inflictor, damage_type = DAMAGE_TYPE_PURE, damage_flags = DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION})

return self:GetCaster():GetTalentValue("modifier_arc_warden_double_5", "damage")*-1
end 



function modifier_arc_warden_tempest_double_custom_tracker:OnTakeDamage(params)
if not IsServer() then return end 
if self:GetParent():IsTempestDouble() or self:GetParent():IsIllusion() then return end 
if not self:GetParent():HasModifier("modifier_arc_warden_double_5") then return end 
if not self:GetParent().tempest_double_tempest then return end 

local tempest = self:GetParent().tempest_double_tempest 

if (tempest:GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D() > self:GetCaster():GetTalentValue("modifier_arc_warden_double_5", "range") then return end 
if tempest ~= params.attacker then return end 
if not params.unit:IsHero() and not params.unit:IsCreep() then return end 

local heal = params.damage*self:GetCaster():GetTalentValue("modifier_arc_warden_double_5", "heal")/100

if params.unit:IsCreep() then 
	heal = heal*self:GetCaster():GetTalentValue("modifier_arc_warden_double_5", "heal_creeps")
end  

self:GetParent():GenericHeal(heal, self:GetAbility(), true)

end 









function modifier_arc_warden_tempest_double_custom_tracker:OnDeath(params)
if not IsServer() then return end 
if self:GetParent():IsTempestDouble() then return end 
if self:GetParent():IsIllusion() then return end
if not self:GetParent():HasModifier("modifier_arc_warden_double_7") then return end 
if not params.attacker then return end
if not params.unit:IsValidKill(self:GetParent()) then return end

local attacker = params.attacker

if attacker.owner then 
	attacker = attacker.owner
end 


if (params.unit:GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D() > self:GetCaster():GetTalentValue("modifier_arc_warden_double_7", "range") and (self:GetParent() ~= attacker) then return end

local mod = self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_arc_warden_tempest_double_custom_cdr_stack", {})

if mod and mod:GetStackCount() >= self:GetCaster():GetTalentValue("modifier_arc_warden_double_7", "max") then return end
if not self:GetParent():IsAlive() then return end

if (params.unit:GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D() > 1500 then return end

ProjectileManager:CreateTrackingProjectile({
	EffectName			= "particles/units/heroes/hero_arc_warden/arc_warden_wraith_prj.vpcf",
	Ability				= self:GetAbility(),
	Source				= params.unit,
	vSourceLoc			= params.unit:GetAbsOrigin(),
	Target				= self:GetParent(),
	iMoveSpeed			= 800,
	flExpireTime		= nil,
	bDodgeable			= false,
	bIsAttack			= false,
	bReplaceExisting	= false,
	iSourceAttachment	= nil,
	bDrawsOnMinimap		= nil,
	bVisibleToEnemies	= true,
	bProvidesVision		= false,
	iVisionRadius		= 0,
	iVisionTeamNumber	= self:GetCaster():GetTeamNumber(),
	ExtraData			= {
	}
})




end 


function modifier_arc_warden_tempest_double_custom_tracker:OnAbilityExecuted( params )
if not IsServer() then return end
if self:GetParent():IsTempestDouble() then return end 
if not params.unit:IsRealHero() then return end

if not params.ability then return end
if params.ability:IsToggle() then return end
if UnvalidAbilities[params.ability:GetName()] then return end
if UnvalidItems[params.ability:GetName()] then return end
if params.ability:IsItem() and params.ability:GetCurrentCharges() > 0 then return end
if params.unit ~= self:GetParent() and params.unit ~= self:GetParent().tempest_double_tempest then return end





local unit
local caster = params.unit


if caster:HasModifier("modifier_arc_warden_double_1") and not caster:IsInvisible() then 


	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, self:GetCaster():GetTalentValue("modifier_arc_warden_double_1", "range"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false)
	local creeps = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, self:GetCaster():GetTalentValue("modifier_arc_warden_double_1", "range"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false)
	local target = nil

	if #enemies > 0 then 
		target = enemies[1]
	else 
		if #creeps > 0 then 
			target = creeps[1]
		end 
	end  


	if target and  RollPseudoRandomPercentage(self:GetCaster():GetTalentValue("modifier_arc_warden_double_1", "chance"),830,caster) then 
		caster:EmitSound("Arc.Tempest_attack")

		caster:AddNewModifier(caster, self:GetAbility(), "modifier_arc_warden_tempest_double_custom_proj", {})

		caster:PerformAttack(target, true, true, true, false, true, false, false)

		caster:RemoveModifierByName("modifier_arc_warden_tempest_double_custom_proj")
	end
end 


if caster:HasModifier("modifier_arc_warden_tempest_double_custom") and caster.owner then 
	unit = caster.owner

else 
	if caster:IsRealHero() and caster.tempest_double_tempest then 
		unit = caster.tempest_double_tempest
	end 
end


if not unit then return end



if not self:GetAbility().cd_items[params.ability:GetName()] then return end 


local item = unit:FindItemInInventory(params.ability:GetName())

if not item then return end 

local cd = item:GetCooldownTimeRemaining()

item:UseResources(false, false, false, true)


--if cd < self:GetAbility():GetSpecialValueFor("cd_items") then 
	--item:EndCooldown()
	--item:StartCooldown(self:GetAbility():GetSpecialValueFor("cd_items"))
--end 



end




arc_warden_tempest_double_custom_legendary = class({})



function arc_warden_tempest_double_custom_legendary:OnAbilityPhaseStart()

return self:GetCaster():CanTeleport() 
end

function arc_warden_tempest_double_custom_legendary:GetCooldown()
	return self:GetCaster():GetTalentValue("modifier_arc_warden_double_7", "cd")
end 

function arc_warden_tempest_double_custom_legendary:GetChannelTime()
	return self:GetCaster():GetTalentValue("modifier_arc_warden_double_7", "cast")
end 

function arc_warden_tempest_double_custom_legendary:OnSpellStart()
if not IsServer() then return end 

self.target = nil 

if self:GetCaster():IsTempestDouble() and self:GetCaster().owner then 
	self.target = self:GetCaster().owner
end 

if self:GetCaster().tempest_double_tempest then 
	self.target = self:GetCaster().tempest_double_tempest
end 

if not self.target or self.target:IsNull() or not self.target:IsAlive() then 
	self:EndChannel()
	return
end 


self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_arc_warden_tempest_double_custom_legendary", {target = self.target:entindex()})

end 

function arc_warden_tempest_double_custom_legendary:OnChannelThink(flInterval)


if not self:GetCaster():TeleportThink() or not self.target or self.target:IsNull() or not self.target:IsAlive() then 
	
    self:GetCaster():Stop()
    self:GetCaster():Interrupt() 
end 

end


function arc_warden_tempest_double_custom_legendary:OnChannelFinish(bInterrupted)

self:GetCaster():RemoveModifierByName("modifier_arc_warden_tempest_double_custom_legendary")

if bInterrupted then return end 

if not self.target or self.target:IsNull() or not self.target:IsAlive() then 
	return
end

local point = self.target:GetAbsOrigin() + RandomVector(200)

EmitSoundOnLocationWithCaster(self:GetCaster():GetAbsOrigin(), "Arc.Teleport_start", self:GetCaster())
EmitSoundOnLocationWithCaster(self:GetCaster():GetAbsOrigin(), "Arc.Teleport_start2", self:GetCaster())
EmitSoundOnLocationWithCaster(point, "Arc.Teleport_end", self:GetCaster())

local particle = ParticleManager:CreateParticle( "particles/arc_warden/legendary_tp_start.vpcf", PATTACH_WORLDORIGIN, nil )
ParticleManager:SetParticleControl(particle, 0,  self:GetCaster():GetAbsOrigin())
ParticleManager:ReleaseParticleIndex(particle)

particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_arc_warden/arc_warden_tempest_cast.vpcf", PATTACH_WORLDORIGIN, self:GetCaster() )
ParticleManager:SetParticleControl(particle, 0, self:GetCaster():GetAbsOrigin())
ParticleManager:ReleaseParticleIndex(particle)

self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_arc_warden_tempest_double_custom_legendary_tp", {duration = 0.2, x = point.x, y = point.y, z = point.z})


particle = ParticleManager:CreateParticle( "particles/arc_warden/legendary_tp_end.vpcf", PATTACH_WORLDORIGIN, nil )
ParticleManager:SetParticleControl(particle, 0,  point)
ParticleManager:ReleaseParticleIndex(particle)

end 



modifier_arc_warden_tempest_double_custom_legendary = class({})
function modifier_arc_warden_tempest_double_custom_legendary:IsHidden() return true end
function modifier_arc_warden_tempest_double_custom_legendary:IsPurgable() return false end

function modifier_arc_warden_tempest_double_custom_legendary:OnCreated(table)
if not IsServer() then return end 

self:GetCaster():EmitSound("Arc.Teleport_cast")

self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_VICTORY, 1.45)

local part = "particles/arc_warden/legendary_tp_tube.vpcf"

if self:GetParent():IsTempestDouble() then 
	part = "particles/arc_warden/legendary_tp_tube_tempest.vpcf"
end 

self.particle = ParticleManager:CreateParticle(part, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
self:AddParticle(self.particle, false, false, -1, false, false)

self:GetParent():EmitSound("Arc.Teleport_loop")
end 


function modifier_arc_warden_tempest_double_custom_legendary:OnDestroy()
if not IsServer() then return end 

self:GetParent():StopSound("Arc.Teleport_loop")

self:GetCaster():FadeGesture(ACT_DOTA_VICTORY)
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

self:GetParent():AddNoDraw()

self.point = Vector(table.x, table.y, table.z)

self:StartIntervalThink(0.1)
end 

function modifier_arc_warden_tempest_double_custom_legendary_tp:OnIntervalThink()
if not IsServer() then return end 
if not self:GetParent() or self:GetParent():IsNull() then return end

FindClearSpaceForUnit(self:GetParent(), self.point, false)
self:StartIntervalThink(-1)
end 


function modifier_arc_warden_tempest_double_custom_legendary_tp:OnDestroy()
if not IsServer() then return end 
self:GetParent():RemoveNoDraw()


self:GetParent():EmitSound("Arc.Teleport_end2")
self:GetParent():StartGesture(ACT_DOTA_TELEPORT_END)

particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_arc_warden/arc_warden_tempest_cast.vpcf", PATTACH_WORLDORIGIN, self:GetParent() )
ParticleManager:SetParticleControl(particle, 0, self:GetParent():GetAbsOrigin())
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





modifier_arc_warden_tempest_double_custom_cdr_stack = class({})
function modifier_arc_warden_tempest_double_custom_cdr_stack:IsHidden() return false end
function modifier_arc_warden_tempest_double_custom_cdr_stack:IsPurgable() return false end
function modifier_arc_warden_tempest_double_custom_cdr_stack:RemoveOnDeath() return false end
function modifier_arc_warden_tempest_double_custom_cdr_stack:GetTexture() return "item_octarine_core" end
function modifier_arc_warden_tempest_double_custom_cdr_stack:OnCreated()

self.damage = self:GetCaster():GetTalentValue("modifier_arc_warden_double_7", "damage")
self.cdr = self:GetCaster():GetTalentValue("modifier_arc_warden_double_7", "cdr")
self.max = self:GetCaster():GetTalentValue("modifier_arc_warden_double_7", "max")

if not IsServer() then return end 
self:SetStackCount(1)

self.StackOnIllusion = true
end 

function modifier_arc_warden_tempest_double_custom_cdr_stack:OnRefresh(table)
if not IsServer() then return end 
if self:GetStackCount() >= self.max then return end 
self:IncrementStackCount()

if self:GetStackCount() >= self.max then 

	self:GetParent():EmitSound("BS.Thirst_legendary_active")
	local particle_peffect = ParticleManager:CreateParticle("particles/rare_orb_patrol.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	ParticleManager:SetParticleControl(particle_peffect, 0, self:GetCaster():GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_peffect, 2, self:GetCaster():GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(particle_peffect)
end 

end 


function modifier_arc_warden_tempest_double_custom_cdr_stack:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
    MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
    MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
    MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
    MODIFIER_PROPERTY_TOOLTIP,
    MODIFIER_PROPERTY_TOOLTIP2

}
end

function modifier_arc_warden_tempest_double_custom_cdr_stack:GetModifierPercentageCooldown() 

if self:GetStackCount() < self.max then return 0 end
if self:GetParent():HasModifier("modifier_arc_warden_tempest_double") then 
	return self.cdr
end 

end 

function modifier_arc_warden_tempest_double_custom_cdr_stack:GetModifierTotalDamageOutgoing_Percentage()

if IsClient() then 
	return self.damage*self:GetStackCount() 
end 

end 


function modifier_arc_warden_tempest_double_custom_cdr_stack:GetModifierSpellAmplify_Percentage() 
if self:GetParent():HasModifier("modifier_arc_warden_tempest_double") then 
	return self.damage*self:GetStackCount() 
end 

end 

function modifier_arc_warden_tempest_double_custom_cdr_stack:GetModifierDamageOutgoing_Percentage()
if self:GetParent():HasModifier("modifier_arc_warden_tempest_double") then 
	return self.damage*self:GetStackCount() 
end 

end 




function modifier_arc_warden_tempest_double_custom_cdr_stack:OnTooltip()
return self:GetStackCount() 
end 

function modifier_arc_warden_tempest_double_custom_cdr_stack:OnTooltip2()
if self:GetStackCount() < self.max then return 0 end

return self.cdr
end 






modifier_arc_warden_tempest_double_custom_lowhp = class({})

function modifier_arc_warden_tempest_double_custom_lowhp:IsHidden() return false end
function modifier_arc_warden_tempest_double_custom_lowhp:IsPurgable() return false end
function modifier_arc_warden_tempest_double_custom_lowhp:OnCreated(table)
if not IsServer() then return end
self.target = EntIndexToHScript(table.target)

self:GetParent():EmitSound("Arc.Tempest_reduce")

self.particle_ally_fx = ParticleManager:CreateParticle("particles/arc_warden/tempest_reduce.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControl(self.particle_ally_fx, 0, self:GetParent():GetAbsOrigin())
self:AddParticle(self.particle_ally_fx, false, false, -1, false, false)  


self.particle = ParticleManager:CreateParticle("particles/arc_warden/tempest_tether.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControlEnt( self.particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )
ParticleManager:SetParticleControlEnt( self.particle, 1, self.target, PATTACH_POINT_FOLLOW, "attach_hitloc", self.target:GetOrigin(), true )
self:AddParticle(self.particle, false, false, -1, false, false)

end 








arc_warden_tempest_double_custom_buff = class({})



function arc_warden_tempest_double_custom_buff :GetCooldown(level)

if self:GetCaster():HasModifier("modifier_arc_warden_double_4") then 
	return self:GetCaster():GetTalentValue("modifier_arc_warden_double_4", "cd")
end 

	return self.BaseClass.GetCooldown(self, level)
end






function arc_warden_tempest_double_custom_buff:OnSpellStart()

local caster = self:GetCaster()



local tempest = nil

if caster:IsTempestDouble() and caster.owner and not caster.owner:IsNull() and caster.owner:IsAlive() then 
	tempest = caster.owner
else 
	if caster.tempest_double_tempest and not caster.tempest_double_tempest:IsNull() and caster.tempest_double_tempest:IsAlive()  then 
		tempest = caster.tempest_double_tempest
	end 
end 


local buffs =
{
	"modifier_arc_warden_tempest_double_custom_rune_1",
	"modifier_arc_warden_tempest_double_custom_rune_2",
	"modifier_arc_warden_tempest_double_custom_rune_3",
	"modifier_arc_warden_tempest_double_custom_rune_4",
}

local all_buffs = true
local buff = nil

for i = 1,#buffs do 
	if not caster:HasModifier(buffs[i]) then 
		all_buffs = false
		break
	end
end 

if all_buffs == true then 
	buff = buffs[RandomInt(1, #buffs)]
else 
	local random = 1

	repeat random = RandomInt(1, #buffs)
		buff = buffs[random]
	until not caster:HasModifier(buff)

end 

if buff == nil then return end 


self:PlayEffect(caster, buff)
self:PlayEffect(tempest, buff)

end


function arc_warden_tempest_double_custom_buff:PlayEffect(unit, buff)
if not IsServer() then return end
if not unit then return end


unit:EmitSound("Arc.Tempest_rune")


local mod = buff

local sound = "Arc.Rune_Shield"
local particle = "particles/lc_odd_proc_.vpcf"

if mod == "modifier_arc_warden_tempest_double_custom_rune_2" then 
	sound = "Arc.Rune_Damage"
	particle = "particles/rare_orb_patrol.vpcf"
end 

if mod == "modifier_arc_warden_tempest_double_custom_rune_3" then 
	sound = "Arc.Rune_Arcane"
	particle = "particles/arc_warden/tempest_rune_arcane.vpcf"
end 

if mod == "modifier_arc_warden_tempest_double_custom_rune_4" then 
	sound = "Arc.Rune_Haste"
	particle = "particles/brist_lowhp_.vpcf"
end 

Timers:CreateTimer(0.5, function()
	if unit and not unit:IsNull() and unit:IsAlive() then 
		unit:EmitSound(sound)
	end 	
end)

local particle_peffect = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN_FOLLOW, unit)
ParticleManager:SetParticleControl(particle_peffect, 0, unit:GetAbsOrigin())
ParticleManager:SetParticleControl(particle_peffect, 2, unit:GetAbsOrigin())
ParticleManager:ReleaseParticleIndex(particle_peffect)

unit:AddNewModifier(unit, self, mod, {duration = self:GetCaster():GetTalentValue("modifier_arc_warden_double_4", "duration")})
end 



modifier_arc_warden_tempest_double_custom_rune_1 = class({})
function modifier_arc_warden_tempest_double_custom_rune_1:IsHidden() return false end
function modifier_arc_warden_tempest_double_custom_rune_1:IsPurgable() return false end

function modifier_arc_warden_tempest_double_custom_rune_1:GetTexture() return "buffs/back_shield" end
function modifier_arc_warden_tempest_double_custom_rune_1:OnCreated(table)

self.max_shield = self:GetParent():GetMaxHealth()*self:GetCaster():GetTalentValue("modifier_arc_warden_double_4", "shield")/100

if not IsServer() then return end

self.RemoveForDuel = true

self:SetStackCount(self.max_shield)
end


function modifier_arc_warden_tempest_double_custom_rune_1:OnRefresh()
self:OnCreated()
end 

function modifier_arc_warden_tempest_double_custom_rune_1:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_INCOMING_DAMAGE_CONSTANT,
}

end


function modifier_arc_warden_tempest_double_custom_rune_1:GetEffectName()
return "particles/items2_fx/vindicators_axe_armor.vpcf"
end



function modifier_arc_warden_tempest_double_custom_rune_1:GetModifierIncomingDamageConstant( params )

if IsClient() then 
	if params.report_max then 
		return self.max_shield
	else 
    	return self:GetStackCount()
    end 
end

if not IsServer() then return end

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



modifier_arc_warden_tempest_double_custom_rune_2 = class({})
function modifier_arc_warden_tempest_double_custom_rune_2:IsHidden() return false end
function modifier_arc_warden_tempest_double_custom_rune_2:IsPurgable() return false end

function modifier_arc_warden_tempest_double_custom_rune_2:GetTexture() return "rune_doubledamage" end

function modifier_arc_warden_tempest_double_custom_rune_2:OnCreated(table)
self.speed = self:GetCaster():GetTalentValue("modifier_arc_warden_double_4", "speed")
self.range = self:GetCaster():GetTalentValue("modifier_arc_warden_double_4", "attack_range")
self.RemoveForDuel = true
end

function modifier_arc_warden_tempest_double_custom_rune_2:OnRefresh()
self:OnCreated()
end 

function modifier_arc_warden_tempest_double_custom_rune_2:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
end

function modifier_arc_warden_tempest_double_custom_rune_2:GetModifierAttackRangeBonus()
return self.range
end

function modifier_arc_warden_tempest_double_custom_rune_2:GetModifierAttackSpeedBonus_Constant()
return self.speed
end


function modifier_arc_warden_tempest_double_custom_rune_2:GetEffectName()
return "particles/generic_gameplay/rune_doubledamage_owner.vpcf"
end







modifier_arc_warden_tempest_double_custom_rune_3 = class({})
function modifier_arc_warden_tempest_double_custom_rune_3:IsHidden() return false end
function modifier_arc_warden_tempest_double_custom_rune_3:IsPurgable() return false end

function modifier_arc_warden_tempest_double_custom_rune_3:GetTexture() return "rune_arcane" end

function modifier_arc_warden_tempest_double_custom_rune_3:OnCreated(table)
self.damage = self:GetCaster():GetTalentValue("modifier_arc_warden_double_4", "damage")
self.range = self:GetCaster():GetTalentValue("modifier_arc_warden_double_4", "spell_range")

self.RemoveForDuel = true
end

function modifier_arc_warden_tempest_double_custom_rune_3:OnRefresh()
self:OnCreated()
end 

function modifier_arc_warden_tempest_double_custom_rune_3:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING,
    MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE
}
end

function modifier_arc_warden_tempest_double_custom_rune_3:GetModifierCastRangeBonusStacking()
return self.range
end

function modifier_arc_warden_tempest_double_custom_rune_3:GetModifierSpellAmplify_Percentage() 
return self.damage
end


function modifier_arc_warden_tempest_double_custom_rune_3:GetEffectName()
return "particles/generic_gameplay/rune_arcane_owner.vpcf"
end




modifier_arc_warden_tempest_double_custom_rune_4 = class({})
function modifier_arc_warden_tempest_double_custom_rune_4:IsHidden() return false end
function modifier_arc_warden_tempest_double_custom_rune_4:IsPurgable() return false end

function modifier_arc_warden_tempest_double_custom_rune_4:GetTexture() return "rune_haste" end

function modifier_arc_warden_tempest_double_custom_rune_4:OnCreated(table)
self.move = self:GetCaster():GetTalentValue("modifier_arc_warden_double_4", "move")
self.status = self:GetCaster():GetTalentValue("modifier_arc_warden_double_4", "status")
self.RemoveForDuel = true
end

function modifier_arc_warden_tempest_double_custom_rune_4:OnRefresh()
self:OnCreated()
end 

function modifier_arc_warden_tempest_double_custom_rune_4:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
    MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING
}
end

function modifier_arc_warden_tempest_double_custom_rune_4:GetModifierMoveSpeedBonus_Constant()
return self.move
end

function modifier_arc_warden_tempest_double_custom_rune_4:GetModifierStatusResistanceStacking() 
return self.status
end

function modifier_arc_warden_tempest_double_custom_rune_4:GetEffectName()
return "particles/generic_gameplay/rune_haste_owner.vpcf"
end




modifier_arc_warden_tempest_double_custom_proj = class({})

function modifier_arc_warden_tempest_double_custom_proj:IsHidden() return true end
function modifier_arc_warden_tempest_double_custom_proj:IsPurgable() return false end


function modifier_arc_warden_tempest_double_custom_proj:DeclareFunctions()
return
{
  	MODIFIER_PROPERTY_PROJECTILE_NAME,
}
end 


function modifier_arc_warden_tempest_double_custom_proj:GetModifierProjectileName()

return "particles/arc_warden/tempest_attack.vpcf"
end





modifier_arc_warden_tempest_double_custom_slow = class({})
function modifier_arc_warden_tempest_double_custom_slow:IsHidden() return true end
function modifier_arc_warden_tempest_double_custom_slow:IsPurgable() return true end
function modifier_arc_warden_tempest_double_custom_slow:GetEffectName() return "particles/units/heroes/hero_terrorblade/terrorblade_reflection_slow.vpcf" end

function modifier_arc_warden_tempest_double_custom_slow:OnCreated()

self.duration = self:GetCaster():GetTalentValue("modifier_arc_warden_double_2", "duration")
self.damage = self:GetCaster():GetTalentValue("modifier_arc_warden_double_2", "damage")

if not IsServer() then return end
self:SetStackCount(0)

self:StartIntervalThink(1)
end 


function modifier_arc_warden_tempest_double_custom_slow:OnRefresh()
if not IsServer() then return end 

self:SetStackCount(0)
end

function modifier_arc_warden_tempest_double_custom_slow:OnIntervalThink()
if not IsServer() then return end 

self:IncrementStackCount()

ApplyDamage({damage = self.damage, victim = self:GetParent(), attacker = self:GetCaster(), ability = self:GetAbility(), damage_type = DAMAGE_TYPE_MAGICAL})


if self:GetStackCount() >= self.duration then 
	self:Destroy()
	return
end 

end 






modifier_arc_warden_tempest_double_custom_items = class({})
function modifier_arc_warden_tempest_double_custom_items:IsHidden() return true end
function modifier_arc_warden_tempest_double_custom_items:IsPurgable() return false end
function modifier_arc_warden_tempest_double_custom_items:RemoveOnDeath() return false end
function modifier_arc_warden_tempest_double_custom_items:OnCreated()
if not IsServer() then return end 

self:StartIntervalThink(0.1)
end 


function modifier_arc_warden_tempest_double_custom_items:OnRefresh()
if not IsServer() then return end 

self:OnCreated()
end 

function modifier_arc_warden_tempest_double_custom_items:OnIntervalThink()
if not IsServer() then return end

local tempest = self:GetAbility().tempest

if not tempest or tempest:IsNull() or not tempest:IsAlive() then return end
--if tempest:HasModifier("modifier_custom_ability_teleport") then return end
if tempest:IsChanneling() then return end 

self:GetAbility():ManageItems(tempest)

self:Destroy()
end 