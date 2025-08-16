LinkLuaModifier( "modifier_tower_heal", "modifiers/main_mods/modifier_on_respawn", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_tower_heal_hero", "modifiers/main_mods/modifier_on_respawn", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_respawn_invun", "modifiers/main_mods/modifier_on_respawn", LUA_MODIFIER_MOTION_NONE )


modifier_on_respawn = class({})
function modifier_on_respawn:IsHidden() return true end
function modifier_on_respawn:IsPurgable() return false end
function modifier_on_respawn:RemoveOnDeath() return false end


function modifier_on_respawn:OnCreated(table)
self.parent = self:GetParent()
self.parent:AddDeathEvent(self, true)
self.parent:AddRespawnEvent(self, true)
end



function modifier_on_respawn:DeclareFunctions()
return 
{
    MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL
}

end

function modifier_on_respawn:GetAbsoluteNoDamagePhysical(params)
if not params.attacker then return end
if (params.attacker:GetUnitName() == "npc_towerdire" or params.attacker:GetUnitName() == "npc_towerradiant") then return 1 end

return 0
end


function modifier_on_respawn:DeathEvent(params)
if not IsServer() then return end
if not params.attacker then return end

if params.unit:IsTempestDouble() or params.unit:IsCreepHero() then return end

local attacker = params.attacker
if attacker.owner then 
    attacker = attacker.owner
end

if attacker == self.parent and params.unit:GetTeamNumber() == DOTA_TEAM_NEUTRALS and params.unit:GetMaximumGoldBounty() > 0 then 
    local k = 0
    if self.parent:HasModifier("modifier_lownet_gold_buff") then 
        k = k + lownet_gold
    end

    if self.parent:HasModifier("modifier_patrol_reward_1_gold") then
        k = k + self.parent:FindModifierByName("modifier_patrol_reward_1_gold").gold
    end

    if self.parent:HasModifier("modifier_item_bfury_custom")  then
        k = k + self.parent:FindModifierByName("modifier_item_bfury_custom").gold_bonus
    end
    
    if k > 0 then 
        local gold = math.max(1, params.unit:GetMaximumGoldBounty()*k)

        self.parent:GiveGold(gold)
    end
end

if params.unit:IsRealHero() and params.unit:GetTeamNumber() ~= self.parent:GetTeamNumber() and not params.unit:IsReincarnating() 
and ((params.unit:GetAbsOrigin() - self.parent:GetAbsOrigin()):Length2D() < more_gold_radius or self.parent == attacker) then 

    self.parent:ModifyGold(kill_net_gold, true, DOTA_ModifyGold_HeroKill)
    self.parent:SendNumber(0, kill_net_gold)
end



local player = players[self.parent:GetId()]

if player then 
    if params.attacker:GetTeamNumber() == self.parent:GetTeamNumber() and (params.unit:IsRealHero() and not params.unit:IsReincarnating())
    and params.unit ~= self.parent then 

        local tower = towers[self.parent:GetTeamNumber()]
        if tower then 
            tower:EmitSound("DOTA_Item.RepairKit.Target")
            tower:AddNewModifier(player, nil, "modifier_generic_repair", {duration = 10, tower_heal = 15})
            self.parent:AddNewModifier(self.parent, nil, "modifier_tower_heal_hero", {duration = 10})
        end

    end
end



if self.parent ~= params.unit then return end

self.reinc = false 
if self.parent:IsReincarnating() then 
	self.reinc = true
end

end




function modifier_on_respawn:RespawnEvent(param)
if not IsServer() then return end
if param.unit ~= self.parent then return end 

self.parent.died_on_duel = nil

self.parent:UpdateTalentsClient(true)

if self.reinc == false then 

    local mod = self.parent:FindModifierByName('modifier_voice_module')
    if mod then 
        mod:RespawnEvent()
    end 

    if towers[self.parent:GetTeamNumber()] then
        local respaw_pos = Entities:FindByName(nil, towers[self.parent:GetTeamNumber()]:GetName().."_respawn")
        if respaw_pos then
            self.parent:AddNewModifier(self.parent, nil, "modifier_respawn_invun", {x = respaw_pos:GetAbsOrigin().x, y = respaw_pos:GetAbsOrigin().y})
        end
    end

    self.parent:AddNewModifier(self.parent, nil, "modifier_invulnerable", {duration = 1})
end

self.parent:RemoveModifierByName("modifier_fountain_invulnerability")

self.reinc = false

local parent_player = players[self.parent:GetId()]
if parent_player == nil then
    return
end

if parent_player.respawn_mod ~= nil then 
    self.parent:InitTalent(parent_player.respawn_mod)
    parent_player.respawn_mod = nil
end


end






modifier_tower_heal_hero = class({})
function modifier_tower_heal_hero:IsHidden() return false end
function modifier_tower_heal_hero:IsPurgable() return false end
function modifier_tower_heal_hero:RemoveOnDeath() return false end
function modifier_tower_heal_hero:GetTexture() return "item_repair_kit" end
function modifier_tower_heal_hero:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_TOOLTIP
}
end

function modifier_tower_heal_hero:OnTooltip() return 10 end




modifier_respawn_invun = class({})
function modifier_respawn_invun:IsHidden() return true end
function modifier_respawn_invun:IsPurgable() return false end
function modifier_respawn_invun:CheckState()
return
{
    [MODIFIER_STATE_DISARMED] = true,
    [MODIFIER_STATE_SILENCED] = true,
    [MODIFIER_STATE_MUTED] = true,
    [MODIFIER_STATE_INVULNERABLE] = true,
    [MODIFIER_STATE_NO_HEALTH_BAR] = true,
}
end

function modifier_respawn_invun:OnCreated(params)
if not IsServer() then return end

self.parent = self:GetParent()
self.point = GetGroundPosition(Vector(params.x, params.y, 0), nil)
self.radius = 250

self.particle = ParticleManager:CreateParticle("particles/items_fx/glyph.vpcf" , PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(self.particle, 0, self.point)
ParticleManager:SetParticleControl(self.particle, 1, Vector(self.radius*1.4,1,1))
self:AddParticle(self.particle, false, false, -1, false, false)

self:OnIntervalThink()
self:StartIntervalThink(0.1)
end


function modifier_respawn_invun:OnIntervalThink()
if not IsServer() then return end

local dist = (self.point - self.parent:GetAbsOrigin()):Length2D()
if dist >= self.radius then
    self:Destroy()
    return
end

end

function modifier_respawn_invun:GetStatusEffectName()
return "particles/status_fx/status_effect_dark_willow_shadow_realm.vpcf"
end


function modifier_respawn_invun:StatusEffectPriority()
return MODIFIER_PRIORITY_SUPER_ULTRA
end