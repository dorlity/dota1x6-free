LinkLuaModifier( "modifier_templar_assassin_meld_custom_buff", "abilities/templar_assasssin/templar_assassin_meld_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_templar_assassin_meld_custom_debuff", "abilities/templar_assasssin/templar_assassin_meld_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_templar_assassin_meld_custom_speed", "abilities/templar_assasssin/templar_assassin_meld_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_templar_assassin_meld_custom_slow", "abilities/templar_assasssin/templar_assassin_meld_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_templar_assassin_meld_custom_quest", "abilities/templar_assasssin/templar_assassin_meld_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_templar_assassin_meld_custom_kills", "abilities/templar_assasssin/templar_assassin_meld_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_templar_assassin_meld_custom_tracker", "abilities/templar_assasssin/templar_assassin_meld_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_templar_assassin_meld_custom_armor", "abilities/templar_assasssin/templar_assassin_meld_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_templar_assassin_meld_custom_toggle", "abilities/templar_assasssin/templar_assassin_meld_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_templar_assassin_meld_custom_heal", "abilities/templar_assasssin/templar_assassin_meld_custom", LUA_MODIFIER_MOTION_NONE )

templar_assassin_meld_custom = class({})






templar_assassin_meld_custom.legendary_damage = 20
templar_assassin_meld_custom.legendary_incoming = 100
templar_assassin_meld_custom.legendary_duration = 6
templar_assassin_meld_custom.legendary_speed = 20
templar_assassin_meld_custom.legendary_duration_move = 3

templar_assassin_meld_custom.attacks_max = {4, 8}
templar_assassin_meld_custom.attacks_chance = {30, 50}
templar_assassin_meld_custom.attacks_cd = 0.5
templar_assassin_meld_custom.attacks_armor = -1
templar_assassin_meld_custom.attacks_armor_duration = 6




function templar_assassin_meld_custom:Precache(context)

PrecacheResource( "particle", 'particles/units/heroes/hero_templar_assassin/templar_assassin_meld_attack.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_templar_assassin/templar_assassin_meld.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_templar_assassin/templar_assassin_meld_armor.vpcf', context ) 
PrecacheResource( "particle", 'particles/units/heroes/hero_terrorblade/terrorblade_reflection_slow.vpcf', context )
PrecacheResource( "particle", 'particles/beast_ult_count.vpcf', context )
PrecacheResource( "particle", 'particles/econ/items/oracle/oracle_ti10_immortal/ta_meld_heal.vpcf', context )

end


function templar_assassin_meld_custom:GetCastRange(vLocation, hTarget)

if self:GetCaster():HasModifier("modifier_templar_assassin_meld_5") and self:GetCaster():HasModifier("modifier_templar_assassin_meld_custom_toggle") then 

    if IsClient() then 
        return self:GetCaster():GetTalentValue("modifier_templar_assassin_meld_5", "distance")
    else
        return 999999 
    end
end

return 0
end


function templar_assassin_meld_custom:GetIntrinsicModifierName()
return "modifier_templar_assassin_meld_custom_tracker"
end

function templar_assassin_meld_custom:GetBehavior()
if  self:GetCaster():HasModifier("modifier_templar_assassin_meld_5")  then 

    if not self:GetCaster():HasModifier("modifier_templar_assassin_meld_custom_toggle") then 
        return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_MOVEMENT + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK + DOTA_ABILITY_BEHAVIOR_AUTOCAST
   
    else 
        return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_MOVEMENT + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK + DOTA_ABILITY_BEHAVIOR_AUTOCAST
    end
end

return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_MOVEMENT + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK
end


function templar_assassin_meld_custom:OnSpellStart()
if not IsServer() then return end


self:GiveMeld(self:GetCaster())


if self:GetCaster():HasModifier("modifier_templar_assassin_meld_5") and self:GetCaster():HasModifier("modifier_templar_assassin_meld_custom_toggle") then 

        ProjectileManager:ProjectileDodge(self:GetCaster())


        local point = self:GetCursorPosition()
        local start_point = self:GetCaster():GetAbsOrigin()

        local vec = (point - start_point)

        EmitSoundOnLocationWithCaster( start_point, "Hero_Antimage.Blink_out", self:GetCaster() )

        if point == start_point then 
            point = start_point + self:GetCaster():GetForwardVector()*5
        end

        local distance = self:GetCaster():GetTalentValue("modifier_templar_assassin_meld_5", "distance")

        if vec:Length2D() > distance then 
            point = vec:Normalized()*distance + self:GetCaster():GetAbsOrigin()
        end


        local effect = ParticleManager:CreateParticleForTeam("particles/items3_fx/blink_arcane_start.vpcf", PATTACH_WORLDORIGIN, nil, self:GetCaster():GetTeamNumber())
        ParticleManager:SetParticleControl(effect, 0, start_point)


        effect = ParticleManager:CreateParticleForTeam("particles/items3_fx/blink_arcane_end.vpcf", PATTACH_WORLDORIGIN, nil, self:GetCaster():GetTeamNumber())
        ParticleManager:SetParticleControl(effect, 0, point)


        self:GetCaster():SetAbsOrigin(point)
        FindClearSpaceForUnit(self:GetCaster(), point, true)

end


if self:GetCaster():HasModifier("modifier_templar_assassin_meld_7") then 

    local illusion = CreateIllusions( self:GetCaster(), self:GetCaster(), {duration=self.legendary_duration, outgoing_damage= -100 + self.legendary_damage,incoming_damage=self.legendary_incoming}, 1, 0, false, false )  
    for k, v in pairs(illusion) do

        for _,mod in pairs(self:GetCaster():FindAllModifiers()) do
            if mod.StackOnIllusion ~= nil and mod.StackOnIllusion == true then
                v:UpgradeIllusion(mod:GetName(), mod:GetStackCount() )
            end

            if mod:GetName() == "modifier_templar_assassin_refraction_custom_absorb" then 
                local shield = v:AddNewModifier(v, v:FindAbilityByName("templar_assassin_refraction_custom"), mod:GetName(), {})
                shield:SetStackCount(mod:GetStackCount())
            end

        end

        v.owner = self:GetCaster()
        FindClearSpaceForUnit(v, self:GetCaster():GetAbsOrigin(), true)
        self:GiveMeld(v)
    end

end

end


function templar_assassin_meld_custom:OnProjectileHit_ExtraData(hTarget, vLocation, table)
if not IsServer() then return end

self.damage = self:GetSpecialValueFor("bonus_damage")
self.duration = self:GetSpecialValueFor("duration")

if self:GetCaster():HasModifier("modifier_templar_assassin_meld_1") then 
    self.damage = self.damage + self:GetCaster():GetTalentValue("modifier_templar_assassin_meld_1", "damage")
end


local unit = EntIndexToHScript(table.caster)

unit:RemoveModifierByName("modifier_templar_assassin_meld_custom_buff")
local target = hTarget

if not target then return end


hTarget:EmitSound("Hero_TemplarAssassin.Meld.Attack")
if not hTarget:IsBuilding() then 

    local mod = self:GetCaster():FindModifierByName("modifier_templar_assassin_meld_custom_kills")

    if self:GetCaster():HasModifier("modifier_templar_assassin_meld_6") and mod and mod:GetStackCount() >= self:GetCaster():GetTalentValue("modifier_templar_assassin_meld_6", "max") then
        target:AddNewModifier(self:GetCaster(), self, "modifier_stunned", {duration = self:GetCaster():GetTalentValue("modifier_templar_assassin_meld_6", "stun")*(1 - target:GetStatusResistance())})
    end

    hTarget:AddNewModifier(unit, self, "modifier_templar_assassin_meld_custom_debuff", { duration = self.duration})
    SendOverheadEventMessage(nil, OVERHEAD_ALERT_CRITICAL, hTarget, self.damage, nil)


    ApplyDamage({victim = hTarget, attacker = unit, damage = self.damage, damage_type = DAMAGE_TYPE_PHYSICAL, ability = self})
end




end




function templar_assassin_meld_custom:GiveMeld(target)
if not IsServer() then return end

target:AddNewModifier(target, self, "modifier_templar_assassin_meld_custom_buff", {})
target:EmitSound("Hero_TemplarAssassin.Meld")




target:Stop()
end




modifier_templar_assassin_meld_custom_buff = class({})

function modifier_templar_assassin_meld_custom_buff:IsPurgable() return false end

function modifier_templar_assassin_meld_custom_buff:OnCreated()


self.range = self:GetCaster():GetTalentValue("modifier_templar_assassin_meld_5", "range")

if not IsServer() then return end



self.abs = self:GetParent():GetAbsOrigin()
self.record = nil
self.attack = true
self.time = 0
self.moved = false
self.can_break = false
self:StartIntervalThink(FrameTime())
end

function modifier_templar_assassin_meld_custom_buff:OnRefresh()
self:OnCreated()
end

function modifier_templar_assassin_meld_custom_buff:OnDestroy()
if not IsServer() then return end

if self:GetCaster():GetQuest() == "Templar.Quest_6" then 
    self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_templar_assassin_meld_custom_quest", {duration = self:GetCaster().quest.number})
end


self:GetParent():EmitSound("Hero_TemplarAssassin.Meld.Move")
end

function modifier_templar_assassin_meld_custom_buff:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK,
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_EVENT_ON_ATTACK_FAIL,
        MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
        MODIFIER_EVENT_ON_ORDER,
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
		MODIFIER_PROPERTY_PROJECTILE_NAME,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_EVENT_ON_ATTACK_CANCELLED,
        MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
    }
    return funcs
end


function modifier_templar_assassin_meld_custom_buff:GetModifierMoveSpeedBonus_Percentage()
if self:GetParent():HasModifier("modifier_templar_assassin_meld_7") then 
    return self:GetAbility().legendary_speed
end

end

function modifier_templar_assassin_meld_custom_buff:GetModifierAttackRangeBonus()
if self:GetParent():HasModifier("modifier_templar_assassin_meld_5") then 
    return self.range
end

end




function modifier_templar_assassin_meld_custom_buff:GetActivityTranslationModifiers()
	return "meld"
end

function modifier_templar_assassin_meld_custom_buff:OnAttack(params)
    if self:GetParent() ~= params.attacker then return end
    if self.attack then
        self.record = params.record


        local projectile =
        {
            Target = params.target,
            Source = self:GetParent(),
            Ability = self:GetAbility(),
            EffectName = "particles/units/heroes/hero_templar_assassin/templar_assassin_meld_attack.vpcf",
            iMoveSpeed = self:GetParent():GetProjectileSpeed()*1.2,
            vSourceLoc = self:GetParent():GetAbsOrigin(),
            bDodgeable = true,
            bProvidesVision = false,
            ExtraData = {caster = self:GetParent():entindex(),}
        }

        local hProjectile = ProjectileManager:CreateTrackingProjectile( projectile )
        self.attack = false

        if self:GetCaster():HasModifier("modifier_templar_assassin_meld_3") then 
          self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_templar_assassin_meld_custom_speed", {duration = self:GetCaster():GetTalentValue("modifier_templar_assassin_meld_3",  "duration")})
        end

        if self:GetCaster():HasModifier("modifier_templar_assassin_meld_2") then 
            self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_templar_assassin_meld_custom_heal", {duration = self:GetCaster():GetTalentValue("modifier_templar_assassin_meld_2", "duration")})
        end 

       self:Destroy()

    end
end



function modifier_templar_assassin_meld_custom_buff:OnOrder(params)
if not IsServer() then return end
if self.can_break == false then return end
    if params.unit == self:GetParent() then
        local cancel_commands = 
        {
            [DOTA_UNIT_ORDER_MOVE_TO_POSITION]  = true,
            [DOTA_UNIT_ORDER_CAST_POSITION]    = true,
            [DOTA_UNIT_ORDER_CAST_TARGET]       = true,
            [DOTA_UNIT_ORDER_CAST_NO_TARGET]     = true,
            [DOTA_UNIT_ORDER_CAST_TOGGLE]     = true,
            [DOTA_UNIT_ORDER_MOVE_ITEM]       = true,
            [DOTA_UNIT_ORDER_MOVE_TO_DIRECTION]  = true,
            [DOTA_UNIT_ORDER_MOVE_RELATIVE]     = true,
        }

        if params.ability then
            if params.ability:GetAbilityName() == "templar_assassin_trap_teleport_custom" then
                return
            end
        end
        
        if cancel_commands[params.order_type] then
            if self.attack then

                if self:GetParent():HasModifier("modifier_templar_assassin_meld_7") then 
                       if self.moved == false then  
                	       self:SetDuration(self:GetAbility().legendary_duration_move, true)
                           self.moved = true
                       end
                else 
                    self:Destroy()
                end
            end
        end
    end
end



function modifier_templar_assassin_meld_custom_buff:OnIntervalThink()

if self.can_break == false then 
    self.can_break = true
    self.abs = self:GetParent():GetAbsOrigin()
    self:StartIntervalThink(0.1)
end

self.time = self.time + 0.1

if self:GetParent():GetAbsOrigin() == self.abs then return end
if not self.attack then return end
        
if self:GetParent():HasModifier("modifier_templar_assassin_meld_7") then 

    if self.moved == false then  
        self:SetDuration(self:GetAbility().legendary_duration_move, true)
        self.moved = true
    end
else 
  self:Destroy()
end

end



function modifier_templar_assassin_meld_custom_buff:OnAttackFail(params)
	if not IsServer() then return end
	if params.attacker ~= self:GetParent() then return end
    if params.record == self.record then
	   self:Destroy()
    end
end

function modifier_templar_assassin_meld_custom_buff:GetEffectName()
	return "particles/units/heroes/hero_templar_assassin/templar_assassin_meld.vpcf"
end

function modifier_templar_assassin_meld_custom_buff:GetModifierInvisibilityLevel()
    return 1
end

function modifier_templar_assassin_meld_custom_buff:CheckState()
    return {
        [MODIFIER_STATE_INVISIBLE] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true
    }
end














modifier_templar_assassin_meld_custom_debuff = class({})

function modifier_templar_assassin_meld_custom_debuff:OnCreated(table)

self.armor = self:GetAbility():GetSpecialValueFor("bonus_armor")

if self:GetCaster():HasModifier("modifier_templar_assassin_meld_1") then 
    self.armor = self.armor + self:GetCaster():GetTalentValue("modifier_templar_assassin_meld_1", "armor")
end 

if self:GetCaster():HasModifier("modifier_templar_assassin_meld_custom_kills") and self:GetCaster():HasModifier("modifier_templar_assassin_meld_6") then 
    self.armor = self.armor + self:GetCaster():GetUpgradeStack("modifier_templar_assassin_meld_custom_kills")*self:GetCaster():GetTalentValue("modifier_templar_assassin_meld_6", "armor")
end

if not IsServer() then return end

self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_templar_assassin/templar_assassin_meld_armor.vpcf", PATTACH_POINT_FOLLOW, self:GetCaster())
ParticleManager:SetParticleControlEnt(self.particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
self:AddParticle(self.particle, false, false, -1, false, false)

end


function modifier_templar_assassin_meld_custom_debuff:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
    }
    return funcs
end

function modifier_templar_assassin_meld_custom_debuff:GetModifierPhysicalArmorBonus()
if self:GetCaster() and not self:GetCaster():IsNull() and not self:GetCaster():IsIllusion() then 
    return self.armor
else 
    return 0
end

end

function modifier_templar_assassin_meld_custom_debuff:GetAttributes()
return MODIFIER_ATTRIBUTE_MULTIPLE
end


modifier_templar_assassin_meld_custom_speed = class({})
function modifier_templar_assassin_meld_custom_speed:IsHidden() return false end
function modifier_templar_assassin_meld_custom_speed:IsPurgable() return false end
function modifier_templar_assassin_meld_custom_speed:GetTexture() return "buffs/meld_speed" end
function modifier_templar_assassin_meld_custom_speed:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
end

function modifier_templar_assassin_meld_custom_speed:GetModifierAttackSpeedBonus_Constant()
return self.speed
end


function modifier_templar_assassin_meld_custom_speed:OnCreated()

self.speed = self:GetCaster():GetTalentValue("modifier_templar_assassin_meld_3", "speed")
end








modifier_templar_assassin_meld_custom_quest = class({})
function modifier_templar_assassin_meld_custom_quest:IsHidden() return true end
function modifier_templar_assassin_meld_custom_quest:IsPurgable() return false end





modifier_templar_assassin_meld_custom_kills = class({})
function modifier_templar_assassin_meld_custom_kills:IsHidden() return not self:GetCaster():HasModifier("modifier_templar_assassin_meld_6") end
function modifier_templar_assassin_meld_custom_kills:IsPurgable() return false end
function modifier_templar_assassin_meld_custom_kills:RemoveOnDeath() return false end
function modifier_templar_assassin_meld_custom_kills:GetTexture() return "buffs/meld_kills" end
function modifier_templar_assassin_meld_custom_kills:OnCreated(table)

self.max = self:GetCaster():GetTalentValue("modifier_templar_assassin_meld_6", "max", true)
self.armor = self:GetCaster():GetTalentValue("modifier_templar_assassin_meld_6", "armor", true)

if not IsServer() then return end
self:SetStackCount(1)
end

function modifier_templar_assassin_meld_custom_kills:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end

self:IncrementStackCount()

if self:GetCaster():HasModifier("modifier_templar_assassin_meld_6") and self:GetStackCount() >= self.max then 

    local particle_peffect = ParticleManager:CreateParticle("particles/lc_odd_proc_.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
    ParticleManager:SetParticleControl(particle_peffect, 0, self:GetParent():GetAbsOrigin())
    ParticleManager:SetParticleControl(particle_peffect, 2, self:GetParent():GetAbsOrigin())
    ParticleManager:ReleaseParticleIndex(particle_peffect)
    self:GetCaster():EmitSound("BS.Thirst_legendary_active")

    self:GetAbility():ToggleAutoCast()
end

end


function modifier_templar_assassin_meld_custom_kills:OnTooltip()
if not self:GetCaster():HasModifier("modifier_templar_assassin_meld_6") then return 0 end
return self:GetStackCount()*self.armor
end

function modifier_templar_assassin_meld_custom_kills:OnTooltip2()
return self:GetStackCount()
end


function modifier_templar_assassin_meld_custom_kills:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_TOOLTIP,
    MODIFIER_PROPERTY_TOOLTIP2
}
end


modifier_templar_assassin_meld_custom_tracker = class({})
function modifier_templar_assassin_meld_custom_tracker:IsHidden() return true end
function modifier_templar_assassin_meld_custom_tracker:IsPurgable() return false end
function modifier_templar_assassin_meld_custom_tracker:DeclareFunctions()
return
{
    MODIFIER_EVENT_ON_DEATH,
    MODIFIER_EVENT_ON_ATTACK_LANDED
}
end

function modifier_templar_assassin_meld_custom_tracker:OnDeath(params)
if not IsServer() then return end
if not params.unit:IsValidKill(self:GetParent()) then return end
 
local attacker = params.attacker
if attacker.owner then 
    attacker = attacker.owner
end

if attacker ~= self:GetParent() then return end

self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_templar_assassin_meld_custom_kills", {})
end




function modifier_templar_assassin_meld_custom_tracker:OnAttackLanded(params)
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_templar_assassin_meld_4") then return end
if self:GetParent() ~= params.attacker then return end
if not params.target:IsHero() and not params.target:IsCreep() then return end



params.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_templar_assassin_meld_custom_armor", {duration = self:GetCaster():GetTalentValue("modifier_templar_assassin_meld_4", "duration")})

self:GetCaster():CdAbility(self:GetAbility(), self:GetCaster():GetTalentValue("modifier_templar_assassin_meld_4", "cd"))

end





modifier_templar_assassin_meld_custom_armor = class({})
function modifier_templar_assassin_meld_custom_armor:IsHidden() return false end
function modifier_templar_assassin_meld_custom_armor:IsPurgable() return false end
function modifier_templar_assassin_meld_custom_armor:GetTexture() return "buffs/meld_armor" end
function modifier_templar_assassin_meld_custom_armor:OnCreated(table)

self.armor = self:GetCaster():GetTalentValue("modifier_templar_assassin_meld_4", "armor")
if not IsServer() then return end
self.max = self:GetCaster():GetTalentValue("modifier_templar_assassin_meld_4", "max")

self:GetParent():EmitSound("TA.Meld_attack")
self:SetStackCount(1)
end

function modifier_templar_assassin_meld_custom_armor:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end
self:IncrementStackCount()


self:GetParent():EmitSound("TA.Meld_attack")

if self:GetStackCount() >= self.max then

    self.particle_peffect = ParticleManager:CreateParticle("particles/items3_fx/star_emblem.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())   
    ParticleManager:SetParticleControl(self.particle_peffect, 0, self:GetParent():GetAbsOrigin())
    self:AddParticle(self.particle_peffect, false, false, -1, false, true)
end

end

function modifier_templar_assassin_meld_custom_armor:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
}
end

function modifier_templar_assassin_meld_custom_armor:GetModifierPhysicalArmorBonus()
return self:GetStackCount()*self.armor
end





modifier_templar_assassin_meld_custom_toggle = class({})
function modifier_templar_assassin_meld_custom_toggle:IsHidden() return true end
function modifier_templar_assassin_meld_custom_toggle:IsPurgable() return false end
function modifier_templar_assassin_meld_custom_toggle:RemoveOnDeath() return false end




modifier_templar_assassin_meld_custom_heal = class({})

function modifier_templar_assassin_meld_custom_heal:IsPurgable() return false end
function modifier_templar_assassin_meld_custom_heal:GetTexture() return "buffs/Crit_blood" end


function modifier_templar_assassin_meld_custom_heal:OnCreated()
self.heal = self:GetCaster():GetTalentValue("modifier_templar_assassin_meld_2", "heal")
self.creeps = self:GetCaster():GetTalentValue("modifier_hoodwink_sharp_1", "creeps")
end 

function modifier_templar_assassin_meld_custom_heal:DeclareFunctions()
return
{
  MODIFIER_EVENT_ON_TAKEDAMAGE,
}
end



function modifier_templar_assassin_meld_custom_heal:OnTakeDamage(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end
if not params.unit:IsCreep() and not params.unit:IsHero() then return end
if self:GetParent() == params.unit then return end
if bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then return end

local heal = self.heal/100
if params.unit:IsCreep() then 
 -- heal = heal / self.creeps
end

heal = heal*params.damage

self:GetParent():GenericHeal(heal, self:GetAbility(), true)

end