LinkLuaModifier("modifier_item_custom_smoke_cd", "abilities/ui/smoke", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_custom_smoke_charges", "abilities/ui/smoke", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_custom_smoke_quest", "abilities/ui/smoke", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_custom_smoke_quest_kill", "abilities/ui/smoke", LUA_MODIFIER_MOTION_NONE)

custom_ability_smoke = class({})

function custom_ability_smoke:Spawn()
    if not IsServer() then return end
    if self and not self:IsTrained() then
        self:SetLevel(1)
    end
end


function custom_ability_smoke:GetIntrinsicModifierName()
    return "modifier_item_custom_smoke_charges"
end


function custom_ability_smoke:OnInventoryContentsChanged()
    if not IsServer() then return end
    for i=0, 8 do
        local item = self:GetCaster():GetItemInSlot(i)
        if item then
            if item:GetName() == "item_smoke_of_deceit" and not item.use_ui then
                if self:GetCaster():IsRealHero() then
                    local modifier_sentry = self:GetCaster():FindModifierByName("modifier_item_custom_smoke_charges")
                    if modifier_sentry then
                        modifier_sentry:SetStackCount(modifier_sentry:GetStackCount() + item:GetCurrentCharges())
                    end
                    item.use_ui = true
                    Timers:CreateTimer(0, function()
                        UTIL_Remove( item )
                    end)
                end
            end
        end
    end
end

function custom_ability_smoke:OnSpellStart()
if not IsServer() then return end
if self:GetCaster():HasModifier("modifier_item_custom_smoke_cd") then return end


    local heroes = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, 1300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS +  DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO +  DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES +  DOTA_UNIT_TARGET_FLAG_INVULNERABLE +  DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, 0, false )
    if #heroes > 0 then 
        CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer( self:GetCaster():GetPlayerOwnerID() ), "CreateIngameErrorMessage", {message = "#smoke_heroes_near"})
        return
    end 


    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_item_custom_smoke_cd", {duration = 1})
    local mod_stacks = self:GetCaster():GetModifierStackCount("modifier_item_custom_smoke_charges", self:GetCaster())
    if mod_stacks and mod_stacks <= 0 then
        local player = PlayerResource:GetPlayer( self:GetCaster():GetPlayerOwnerID() )
        CustomGameEventManager:Send_ServerToPlayer(player, "CreateIngameErrorMessage", {message = "#dota_hud_error_no_charges"})
        self:EndCooldown()
        return
    end





    self:GetCaster():EmitSound("DOTA_Item.SmokeOfDeceit.Activate")
    local particle = ParticleManager:CreateParticle("particles/items2_fx/smoke_of_deceit.vpcf", PATTACH_WORLDORIGIN, nil)
    ParticleManager:SetParticleControl(particle, 0, self:GetCaster():GetAbsOrigin())
    ParticleManager:SetParticleControl(particle, 1, Vector(800, 1, 800))
    ParticleManager:ReleaseParticleIndex(particle)
    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_smoke_of_deceit", 
    {
        duration = self:GetSpecialValueFor("duration"),
        application_radius = self:GetSpecialValueFor("application_radius"),
        visibility_radius = self:GetSpecialValueFor("visibility_radius"),
        bonus_movement_speed = self:GetSpecialValueFor("bonus_movement_speed"),
        secondary_application_radius = self:GetSpecialValueFor("secondary_application_radius"),
        second_cast_cooldown = self:GetSpecialValueFor("second_cast_cooldown"),
    })

    if self:GetCaster():GetQuest() == "General.Quest_16" and not self:GetCaster():QuestCompleted() then 
        self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_item_custom_smoke_quest", {})
    end

    local mod = self:GetCaster():FindModifierByName("modifier_item_custom_smoke_charges")
    if mod then
        mod:DecrementStackCount()
    end
end

modifier_item_custom_smoke_charges = class({})
function modifier_item_custom_smoke_charges:IsHidden() return true end
function modifier_item_custom_smoke_charges:DestroyOnExpire() return false end
function modifier_item_custom_smoke_charges:IsPurgable() return false end

function modifier_item_custom_smoke_charges:OnCreated()
    self:SetStackCount(0)
    self.cooldown = 150
    self.duration = self.cooldown
    self:SetDuration(self.duration, true)
    self:StartIntervalThink(0.1)
end

function modifier_item_custom_smoke_charges:OnIntervalThink()
    if not IsServer() then return end
    if self:GetStackCount() >= 4 then
        self:SetDuration(self.cooldown + 0.5, true)
        return
    end
    if self.duration <= 0 then
        self:IncrementStackCount()
        self:SetDuration(self.cooldown, true)
        self.duration = self:GetRemainingTime()
        return
    end
    self.duration = self:GetRemainingTime()
end

modifier_item_custom_smoke_cd = class({})
function modifier_item_custom_smoke_cd:IsHidden() return true end
function modifier_item_custom_smoke_cd:IsPurgable() return false end



modifier_item_custom_smoke_quest = class({})
function modifier_item_custom_smoke_quest:IsHidden() return true end
function modifier_item_custom_smoke_quest:IsPurgable() return false end
function modifier_item_custom_smoke_quest:RemoveOnDeath() return false end

function modifier_item_custom_smoke_quest:OnCreated(table)
if not IsServer() then return end
self:StartIntervalThink(0.1)
end


function modifier_item_custom_smoke_quest:OnIntervalThink()
if not IsServer() then return end

local mod = self:GetParent():FindModifierByName("modifier_smoke_of_deceit")

if not mod then
    self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_item_custom_smoke_quest_kill", {duration = self:GetParent().quest.number}) 
    self:Destroy()
end


end


modifier_item_custom_smoke_quest_kill = class({})
function modifier_item_custom_smoke_quest_kill:IsHidden() return false end
function modifier_item_custom_smoke_quest_kill:IsPurgable() return false end
function modifier_item_custom_smoke_quest_kill:RemoveOnDeath() return false end
function modifier_item_custom_smoke_quest_kill:GetTexture() return "buffs/quest_smoke" end
