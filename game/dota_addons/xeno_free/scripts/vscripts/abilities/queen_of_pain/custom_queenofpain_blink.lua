LinkLuaModifier("modifier_custom_blink_shard", "abilities/queen_of_pain/custom_queenofpain_blink", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_blink_tracker", "abilities/queen_of_pain/custom_queenofpain_blink", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_blink_hit", "abilities/queen_of_pain/custom_queenofpain_blink", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_blink_hit_count", "abilities/queen_of_pain/custom_queenofpain_blink", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_blink_legendary_attacks", "abilities/queen_of_pain/custom_queenofpain_blink", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_blink_legendary_nocount", "abilities/queen_of_pain/custom_queenofpain_blink", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_blink_legendary_nospeed", "abilities/queen_of_pain/custom_queenofpain_blink", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_blink_spell", "abilities/queen_of_pain/custom_queenofpain_blink", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_blink_speed", "abilities/queen_of_pain/custom_queenofpain_blink", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_blink_absorb", "abilities/queen_of_pain/custom_queenofpain_blink", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_blink_legendary_tracker", "abilities/queen_of_pain/custom_queenofpain_blink", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_blink_damage", "abilities/queen_of_pain/custom_queenofpain_blink", LUA_MODIFIER_MOTION_NONE)



custom_queenofpain_blink = class({})


custom_queenofpain_blink.legendary_duration = 2.5
custom_queenofpain_blink.legendary_radius = 400
custom_queenofpain_blink.legendary_duration_attacks = FrameTime()*3



custom_queenofpain_blink.speed_duration = 3
custom_queenofpain_blink.speed_damage = {6, 9, 12}
custom_queenofpain_blink.speed_inc = {40, 60, 80}

custom_queenofpain_blink.move_duration = 3
custom_queenofpain_blink.move_range = {40, 60, 80}
custom_queenofpain_blink.move_evasion = {10, 15, 20}


custom_queenofpain_blink.magic_radius = 200
custom_queenofpain_blink.magic_damage = 0.8
custom_queenofpain_blink.magic_chance_init = 10
custom_queenofpain_blink.magic_chance_inc = 10
custom_queenofpain_blink.magic_cd = 0.5



function custom_queenofpain_blink:Precache(context)

PrecacheResource( "particle", "particles/units/heroes/hero_queenofpain/queen_blink_shard_start.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_queenofpain/queen_blink_start.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_queenofpain/queen_blink_end.vpcf", context )
PrecacheResource( "particle", "particles/econ/items/queen_of_pain/qop_arcana/qop_arcana_blink_start.vpcf", context )
PrecacheResource( "particle", "particles/econ/items/queen_of_pain/qop_arcana/qop_arcana_blink_end.vpcf", context )
PrecacheResource( "particle", "particles/qop_attack_.vpcf", context )
PrecacheResource( "particle", "particles/qop_marker.vpcf", context )
PrecacheResource( "particle", "particles/qop_linken_buff.vpcf", context )
PrecacheResource( "particle", "particles/qop_linken.vpcf", context )
PrecacheResource( "particle", "particles/items4_fx/ascetic_cap.vpcf" , context )

end




function custom_queenofpain_blink:GetIntrinsicModifierName() return "modifier_custom_blink_tracker" end


function custom_queenofpain_blink:GetCastPoint(iLevel)

local bonus = 0

if self:GetCaster():HasModifier('modifier_queen_Blink_absorb') then 
	bonus = self:GetCaster():GetTalentValue("modifier_queen_Blink_absorb", "cast")
end


return self.BaseClass.GetCastPoint(self) + bonus
end




function custom_queenofpain_blink:GetCooldown(iLevel)
local upgrade_cooldown = 0	
if self:GetCaster():HasModifier("modifier_queen_Blink_cd") then 
	upgrade_cooldown = self:GetCaster():GetTalentValue("modifier_queen_Blink_cd", "cd")
end

return self.BaseClass.GetCooldown(self, iLevel) + upgrade_cooldown 
end


function custom_queenofpain_blink:GetManaCost(iLevel)

if self:GetCaster():HasModifier("modifier_queenofpain_blood_pact") and self:GetCaster():FindAbilityByName("custom_queenofpain_blood_pact") then 
	return 0
end

return self.BaseClass.GetManaCost(self,iLevel)
end 


function custom_queenofpain_blink:GetHealthCost(level)

if self:GetCaster():HasModifier("modifier_queenofpain_blood_pact") and self:GetCaster():FindAbilityByName("custom_queenofpain_blood_pact") then 
	return self:GetCaster():GetTalentValue("modifier_queen_Scream_legendary", "cost")*self:GetCaster():GetMaxHealth()/100
end

end 


function custom_queenofpain_blink:GetCastRange(vLocation, hTarget)
local range = self:GetSpecialValueFor("blink_range") 
if IsClient() then 
	return range
end
return
end


function custom_queenofpain_blink:GetBehavior()
  if self:GetCaster():HasShard() or self:GetCaster():HasModifier("modifier_queen_Blink_legendary") then
    return DOTA_ABILITY_BEHAVIOR_AOE + DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_ROOT_DISABLES end
 return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_ROOT_DISABLES 
end


function custom_queenofpain_blink:GetAOERadius() 
if self:GetCaster():HasModifier("modifier_queen_Blink_legendary") then 
	return self.legendary_radius
end

if self:GetCaster():HasShard() then
	return self:GetSpecialValueFor("shard_radius")
end

return 0
end


function custom_queenofpain_blink:ShardStrike(location)
if not IsServer() then return end
local radius = self:GetSpecialValueFor("shard_radius")
local damage = self:GetSpecialValueFor("shard_damage")
local silence = self:GetSpecialValueFor("shard_silence")
local caster = self:GetCaster()

local blink_shard_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_queenofpain/queen_blink_shard_start.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(blink_shard_pfx, 0, location )
ParticleManager:SetParticleControl(blink_shard_pfx, 1, location )
ParticleManager:SetParticleControl(blink_shard_pfx, 2, Vector(radius,radius,radius) )
ParticleManager:ReleaseParticleIndex(blink_shard_pfx)


local enemies = FindUnitsInRadius(caster:GetTeamNumber(), location, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
for _, enemy in pairs(enemies) do
	if not enemy:IsMagicImmune() then 

		ApplyDamage({victim = enemy, attacker = self:GetCaster(), ability = self, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
		enemy:AddNewModifier(self:GetCaster(), self, "modifier_custom_blink_shard", {duration = (1 - enemy:GetStatusResistance())*silence})
	end
end

end

function custom_queenofpain_blink:OnSpellStart()
if not IsServer() then return end

local caster = self:GetCaster()
local caster_pos = caster:GetAbsOrigin()
local target_pos = self:GetCursorPosition()


if caster:HasModifier("modifier_queen_Blink_damage") then 
	caster:AddNewModifier(caster, self, "modifier_custom_blink_speed", {duration = self:GetCaster():GetTalentValue("modifier_queen_Blink_damage", "duration")})
end


local blink_range = self:GetSpecialValueFor("blink_range") + self:GetCaster():GetCastRangeBonus()
local distance = (target_pos - caster_pos)


if distance:Length2D() > blink_range then
	target_pos = caster_pos + (distance:Normalized() * blink_range)
end

local start_b = "particles/units/heroes/hero_queenofpain/queen_blink_start.vpcf"
local end_b = "particles/units/heroes/hero_queenofpain/queen_blink_end.vpcf"


if self:GetCaster():GetModelName() == "models/items/queenofpain/queenofpain_arcana/queenofpain_arcana.vmdl" then 
	start_b = "particles/econ/items/queen_of_pain/qop_arcana/qop_arcana_blink_start.vpcf"
	end_b = "particles/econ/items/queen_of_pain/qop_arcana/qop_arcana_blink_end.vpcf"


	local direction = (target_pos - caster_pos)
    direction = direction:Normalized()

    local particle_one = ParticleManager:CreateParticle(start_b, PATTACH_WORLDORIGIN, nil) 
    ParticleManager:SetParticleControl( particle_one, 0, self:GetCaster():GetAbsOrigin() )
    ParticleManager:SetParticleControlForward( particle_one, 0, direction:Normalized() )
    ParticleManager:SetParticleControl( particle_one, 1, self:GetCaster():GetForwardVector() )
   ParticleManager:SetParticleControl( particle_one, 4,Vector(10,1,0) )
    ParticleManager:ReleaseParticleIndex( particle_one )


else 
	local blink_pfx = ParticleManager:CreateParticle(start_b, PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(blink_pfx, 0, caster_pos )
	ParticleManager:SetParticleControl(blink_pfx, 1, target_pos )
	ParticleManager:ReleaseParticleIndex(blink_pfx)
end

ProjectileManager:ProjectileDodge(caster)

caster:EmitSound("Hero_QueenOfPain.Blink_in")


if caster:HasShard() then 
	caster:EmitSound("Hero_QueenOfPain.Blink_in.Shard")
	self:ShardStrike(caster_pos)
end


FindClearSpaceForUnit(caster, target_pos, true)

if caster:HasShard() then 
	caster:EmitSound("Hero_QueenOfPain.Blink_Out.Shard")
	self:ShardStrike(target_pos)
end

if caster:GetQuest() == "Queen.Quest_6" then 

	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target_pos, nil, caster.quest.number, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO  + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)

	if #enemies > 0 then 
		caster:UpdateQuest(1)
	end

end


local ability = self:GetCaster():FindAbilityByName("custom_queenofpain_scream_of_pain")
if self:GetCaster():HasModifier("modifier_queen_Scream_shield") then 
	ability:ProcHeal()
end


caster:EmitSound("Hero_QueenOfPain.Blink_out")
local blink_end_pfx = ParticleManager:CreateParticle(end_b, PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(blink_end_pfx, 0, target_pos )
ParticleManager:SetParticleControlForward(blink_end_pfx, 0, distance:Normalized())
ParticleManager:ReleaseParticleIndex(blink_end_pfx)

caster:StartGesture(ACT_DOTA_CAST_ABILITY_2_END)


if caster:HasModifier("modifier_queen_Blink_legendary") and self:GetCaster():HasModifier("modifier_custom_blink_hit_count") then

	local mod = caster:FindModifierByName("modifier_custom_blink_hit_count")

	caster:AddNewModifier(caster, self, "modifier_custom_blink_legendary_attacks", {hits = mod:GetStackCount()})
	caster:StartGesture(ACT_DOTA_CAST_ABILITY_1)
	for _,m in pairs(caster:FindAllModifiers()) do
		if m:GetName() == "modifier_custom_blink_hit" then 
			m:Destroy()
		end
	end
end

if caster:HasModifier("modifier_queen_Blink_spells") then 
	caster:AddNewModifier(caster, self, "modifier_custom_blink_spell", {})
end




if caster:HasModifier("modifier_queen_Blink_absorb") then 
	caster:AddNewModifier(caster, self, "modifier_custom_blink_absorb", { duration = self:GetCaster():GetTalentValue("modifier_queen_Blink_absorb", "duration")})
end	


end


modifier_custom_blink_shard = class({})

function modifier_custom_blink_shard:IsHidden() return false end
function modifier_custom_blink_shard:IsPurgable() return true end
function modifier_custom_blink_shard:GetTexture() return "silencer_last_word" end
function modifier_custom_blink_shard:CheckState() return {[MODIFIER_STATE_SILENCED] = true} end
function modifier_custom_blink_shard:GetEffectName() return "particles/generic_gameplay/generic_silenced.vpcf" end
function modifier_custom_blink_shard:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end







modifier_custom_blink_tracker = class({})

function modifier_custom_blink_tracker:IsHidden() return true end
function modifier_custom_blink_tracker:IsPurgable() return false end

function modifier_custom_blink_tracker:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_ATTACK,
	MODIFIER_EVENT_ON_ATTACK_LANDED,
	MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
}

end


function modifier_custom_blink_tracker:GetModifierAttackRangeBonus()
if not self:GetParent():HasModifier("modifier_queen_Blink_damage") then return end 

return self:GetAbility().move_range[self:GetCaster():GetUpgradeStack("modifier_queen_Blink_damage")]
end 

function modifier_custom_blink_tracker:OnAttack(params)
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_queen_Blink_legendary") then return end
if self:GetParent() ~= params.attacker then return end
if self:GetParent():HasModifier("modifier_custom_blink_legendary_nocount") then return end

self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_blink_hit", {duration = self:GetAbility().legendary_duration})
self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_blink_hit_count", {})

end


function modifier_custom_blink_tracker:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end
if not params.target:IsHero() and not params.target:IsCreep() then return end

if self:GetCaster():HasModifier("modifier_queen_Blink_speed") then 
	self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_blink_damage", {duration = self:GetCaster():GetTalentValue("modifier_queen_Blink_speed", "duration")})
end 


if not self:GetParent():HasModifier("modifier_queen_Blink_magic") then return end


local chance = self:GetCaster():GetTalentValue("modifier_queen_Blink_magic", "chance")

local random = RollPseudoRandomPercentage(chance,41,self:GetParent())

if not random then return end

params.target:EmitSound("QoP.Blink_attack")

local blink_shard_pfx = ParticleManager:CreateParticle("particles/qop_attack_.vpcf", PATTACH_ABSORIGIN_FOLLOW, params.target)
ParticleManager:SetParticleControlEnt(blink_shard_pfx, 0, params.target, PATTACH_POINT_FOLLOW, "attach_hitloc", params.target:GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(blink_shard_pfx, 1, params.target, PATTACH_POINT_FOLLOW, "attach_hitloc", params.target:GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(blink_shard_pfx, 3, params.target, PATTACH_POINT_FOLLOW, "attach_hitloc", params.target:GetAbsOrigin(), true)
ParticleManager:ReleaseParticleIndex(blink_shard_pfx)



self:GetCaster():CdAbility(self:GetAbility(), self:GetCaster():GetTalentValue("modifier_queen_Blink_magic", "cd"))

local damage = self:GetCaster():GetTalentValue("modifier_queen_Blink_magic", "damage") * self:GetParent():GetIntellect() / 100

local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), params.target:GetAbsOrigin() , nil, self:GetCaster():GetTalentValue("modifier_queen_Blink_magic", "radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)

for _, enemy in pairs(enemies) do
	local real_damage = ApplyDamage({victim = enemy, attacker = self:GetParent(), ability = self:GetAbility(), damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
	SendOverheadEventMessage(enemy, 4, enemy, real_damage, nil)
end


end



modifier_custom_blink_hit = class({})
function modifier_custom_blink_hit:IsHidden() return true end
function modifier_custom_blink_hit:IsPurgable() return false end
function modifier_custom_blink_hit:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_custom_blink_hit:OnDestroy()
if not IsServer() then return end

local mod = self:GetParent():FindModifierByName("modifier_custom_blink_hit_count")
if mod then 
	mod:DecrementStackCount()
	if mod:GetStackCount() == 0 then 
		mod:Destroy()
	end
end


end

modifier_custom_blink_hit_count = class({})
function modifier_custom_blink_hit_count:IsHidden() return false end
function modifier_custom_blink_hit_count:IsPurgable() return false end
function modifier_custom_blink_hit_count:GetTexture() return "buffs/qop_blink_attack" end
function modifier_custom_blink_hit_count:OnCreated(table)
if not IsServer() then return end
	self:SetStackCount(1)
end

function modifier_custom_blink_hit_count:OnRefresh(table)
if not IsServer() then return end
	self:IncrementStackCount()
end

function modifier_custom_blink_hit_count:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOOLTIP
}

end
function modifier_custom_blink_hit_count:OnTooltip() return self:GetStackCount() end

modifier_custom_blink_legendary_attacks = class({})
function modifier_custom_blink_legendary_attacks:IsHidden() return true end
function modifier_custom_blink_legendary_attacks:IsPurgable() return false end 
function modifier_custom_blink_legendary_attacks:OnCreated(table)
if not IsServer() then return end
self.hits = table.hits
self.radius = self:GetAbility().legendary_radius
self.count = 0
self:GetParent():EmitSound("QoP.Blink_legendary")



self.enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self:GetAbility().legendary_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)

for _,enemy in ipairs(self.enemies) do
	enemy.qop_mark = ParticleManager:CreateParticle("particles/qop_marker.vpcf", PATTACH_OVERHEAD_FOLLOW, enemy)
	ParticleManager:SetParticleControl(enemy.qop_mark, 0 , enemy:GetAbsOrigin())
end

if #self.enemies == 0 then 
	self:Destroy()
end

self:StartIntervalThink(self:GetAbility().legendary_duration_attacks)
end

function modifier_custom_blink_legendary_attacks:OnIntervalThink()
if not IsServer() then return end
self.count = self.count + 1 


local array = {}

for _,enemy in ipairs(self.enemies) do 
	if enemy:IsAlive() then 
		array[#array+1] = enemy
	end
end

if #array > 0 then 
	 local random = RandomInt(1, #array)

	 	local no = self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_blink_legendary_nocount", {})
	 	self:GetParent():PerformAttack(array[random], true, true, true, false, true, false, false)	
		 if no then no:Destroy() end
else 
	self:Destroy()
end


if self.count >= self.hits then self:Destroy() end

end

function modifier_custom_blink_legendary_attacks:OnDestroy()
if not IsServer() then return end
for _,enemy in ipairs(self.enemies) do
	if  enemy.qop_mark then 
		ParticleManager:DestroyParticle(enemy.qop_mark, false)
		ParticleManager:ReleaseParticleIndex(enemy.qop_mark)
	end
end
end

modifier_custom_blink_legendary_nocount = class({})
function modifier_custom_blink_legendary_nocount:IsHidden() return true end
function modifier_custom_blink_legendary_nocount:IsPurgable() return false end

modifier_custom_blink_legendary_nospeed = class({})
function modifier_custom_blink_legendary_nospeed:IsHidden() return true end
function modifier_custom_blink_legendary_nospeed:IsPurgable() return false end


modifier_custom_blink_spell = class({})
function modifier_custom_blink_spell:IsHidden() return false end
function modifier_custom_blink_spell:IsPurgable() return false end
function modifier_custom_blink_spell:GetTexture() return "buffs/qop_blink_spell" end

function modifier_custom_blink_spell:OnCreated(table)
 self.RemoveForDuel = true
end




modifier_custom_blink_speed = class({})
function modifier_custom_blink_speed:IsHidden() return false end
function modifier_custom_blink_speed:IsPurgable() return true end
function modifier_custom_blink_speed:GetTexture() return "buffs/Crit_damage" end

function modifier_custom_blink_speed:OnCreated(table)
self.speed = self:GetCaster():GetTalentValue("modifier_queen_Blink_damage", "speed")
end

function modifier_custom_blink_speed:DeclareFunctions()
return 
{
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
}
end

function modifier_custom_blink_speed:GetModifierAttackSpeedBonus_Constant()
return self.speed
end





modifier_custom_blink_absorb = class({})
function modifier_custom_blink_absorb:IsHidden() return false end
function modifier_custom_blink_absorb:IsPurgable() return false end
function modifier_custom_blink_absorb:GetTexture() return "buffs/qop_blink_cd" end

function modifier_custom_blink_absorb:OnCreated(table)
self.status = self:GetCaster():GetTalentValue("modifier_queen_Blink_absorb", "status_bonus")
self.damage = self:GetCaster():GetTalentValue("modifier_queen_Blink_absorb", "damage_reduce")

if not IsServer() then return end

end

function modifier_custom_blink_absorb:GetEffectName()
return "particles/items4_fx/ascetic_cap.vpcf" 
end


function modifier_custom_blink_absorb:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING
}
end


function modifier_custom_blink_absorb:GetModifierStatusResistanceStacking() 
return self.status
end


function modifier_custom_blink_absorb:GetModifierIncomingDamage_Percentage()
return self.damage
end



modifier_custom_blink_legendary_tracker = class({})
function modifier_custom_blink_legendary_tracker:IsHidden() return true end
function modifier_custom_blink_legendary_tracker:IsPurgable() return false end
function modifier_custom_blink_legendary_tracker:RemoveOnDeath() return false end
function modifier_custom_blink_legendary_tracker:OnCreated(table)
if not IsServer() then return end
self:StartIntervalThink(0.1)

end

function modifier_custom_blink_legendary_tracker:OnIntervalThink()
if not IsServer() then return end
local stack = 0
if self:GetParent():HasModifier("modifier_custom_blink_hit_count") then 
	stack = self:GetParent():FindModifierByName("modifier_custom_blink_hit_count"):GetStackCount()
end

CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), 'qop_attack_change',  {rage =stack})

end





modifier_custom_blink_damage = class({})
function modifier_custom_blink_damage:IsHidden() return false end
function modifier_custom_blink_damage:IsPurgable() return false end
function modifier_custom_blink_damage:GetTexture() return "buffs/Shift_attacks" end
function modifier_custom_blink_damage:OnCreated(table)

self.damage = self:GetCaster():GetTalentValue("modifier_queen_Blink_speed", "damage")
self.max = self:GetCaster():GetTalentValue("modifier_queen_Blink_speed", "max")

if not IsServer() then return end

self:SetStackCount(1)
end

function modifier_custom_blink_damage:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end

self:IncrementStackCount()
end

function modifier_custom_blink_damage:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
}
end



function modifier_custom_blink_damage:GetModifierSpellAmplify_Percentage()

  return self.damage*self:GetStackCount()
end
