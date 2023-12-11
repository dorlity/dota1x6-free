LinkLuaModifier("modifier_item_muerta_mercy_custom_stats", "abilities/items/item_muerta_mercy_custom", LUA_MODIFIER_MOTION_NONE)

item_muerta_mercy_custom                = class({})


function item_muerta_mercy_custom:GetIntrinsicModifierName()
return "modifier_item_muerta_mercy_custom_stats"
end






modifier_item_muerta_mercy_custom_stats = class({})
function modifier_item_muerta_mercy_custom_stats:IsHidden() return true end
function modifier_item_muerta_mercy_custom_stats:IsPurgable() return false end
function modifier_item_muerta_mercy_custom_stats:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	MODIFIER_EVENT_ON_ATTACK_LANDED,
	MODIFIER_EVENT_ON_DEATH
}
end

function modifier_item_muerta_mercy_custom_stats:OnCreated(table)
self.move = self:GetAbility():GetSpecialValueFor("movespeed")
self.stats = self:GetAbility():GetSpecialValueFor("stats")
self.speed = self:GetAbility():GetSpecialValueFor("attack_speed")
self.speed_inc = self:GetAbility():GetSpecialValueFor("attack_speed_inc")
self.passive_damage = self:GetAbility():GetSpecialValueFor("passive_damage")/100


if not IsServer() then return end
end

function modifier_item_muerta_mercy_custom_stats:GetModifierMoveSpeedBonus_Constant()
return self.move
end


function modifier_item_muerta_mercy_custom_stats:GetModifierBonusStats_Strength()
return self.stats
end

function modifier_item_muerta_mercy_custom_stats:GetModifierBonusStats_Agility()
return self.stats
end

function modifier_item_muerta_mercy_custom_stats:GetModifierBonusStats_Intellect()
return self.stats
end

function modifier_item_muerta_mercy_custom_stats:GetModifierAttackSpeedBonus_Constant()
return self.speed + self:GetAbility():GetCurrentCharges()*self.speed_inc
end





function modifier_item_muerta_mercy_custom_stats:OnDeath(params)
if not IsServer() then return end
if not params.attacker then return end
if self:GetParent():IsIllusion() then return end
if not params.unit:HasModifier("modifier_muerta_creep") then return end

local attacker = params.attacker

if attacker.owner then 
 attacker = attacker.owner
end

if attacker ~= self:GetParent() then return end


local effect_cast = ParticleManager:CreateParticle( "particles/heroes/muerta/muerta_quest_kill.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
ParticleManager:SetParticleControlEnt(effect_cast, 2, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
ParticleManager:ReleaseParticleIndex( effect_cast )

self:GetAbility():SetCurrentCharges(self:GetAbility():GetCurrentCharges() + 1)

	
if self:GetAbility():GetCurrentCharges() >= self:GetAbility():GetSpecialValueFor('goal') then 

	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), 'muerta_quest_panel',  { max = 0, stack = 0, stage = 3})	
	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), 'muerta_quest_alert',  {type = 5})


	local particle_peffect = ParticleManager:CreateParticle("particles/muerta/muerta_quest_item.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	ParticleManager:SetParticleControl(particle_peffect, 0, self:GetCaster():GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_peffect, 2, self:GetCaster():GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(particle_peffect)
	self:GetCaster():EmitSound("Muerta.Quest_item")
	self:GetCaster():EmitSound("Muerta.Quest_item2")


	self:GetAbility():Destroy()
    local grace = CreateItem("item_muerta_mercy_and_grace_custom", self:GetParent(), self:GetParent())
    self:GetParent():AddItem(grace)

	my_game:MuertaQuestPhase()
else 

	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), 'muerta_quest_panel',  { max = 0, stack = self:GetAbility():GetCurrentCharges(), stage = 2})
	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetCaster():GetPlayerOwnerID()), 'muerta_quest_alert',  {type = 2, max = self:GetAbility():GetSpecialValueFor("goal"), stack = self:GetAbility():GetCurrentCharges()})
	
end

end



function modifier_item_muerta_mercy_custom_stats:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end
if self:GetParent():IsIllusion() then return end
if not params.target:IsHero() and not params.target:IsCreep() then return end

local health = params.target:GetHealth()

local part = "particles/units/heroes/hero_skeletonking/wraith_king_vampiric_aura_lifesteal.vpcf"

if self:GetParent():HasModifier("modifier_item_muerta_mercy_and_grace_custom_active") then 
	health = (params.target:GetMaxHealth() - params.target:GetHealth())

	part = "particles/muerta_item_heal.vpcf"
end

local damage = health*self.passive_damage

if params.target:IsCreep() then 
	damage = math.min(damage, self:GetAbility():GetSpecialValueFor("passive_creeps"))
end

local apply = ApplyDamage({victim = params.target, attacker = self:GetCaster(), ability = self:GetAbility(), damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})


self:GetParent():Heal(apply, self:GetAbility())

if self:GetParent():HasModifier("modifier_item_muerta_mercy_and_grace_custom_active") then 
	SendOverheadEventMessage(params.target, 4, params.target, apply, nil)
end

local effect_cast = ParticleManager:CreateParticle( part, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
ParticleManager:SetParticleControlEnt(effect_cast, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
ParticleManager:ReleaseParticleIndex( effect_cast )
end