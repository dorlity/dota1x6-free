LinkLuaModifier("modifier_moment_of_courage_custom_tracker", "abilities/legion_commander/custom_legion_commander_moment_of_courage", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_moment_of_courage_custom_speed", "abilities/legion_commander/custom_legion_commander_moment_of_courage", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_moment_of_courage_custom_armor", "abilities/legion_commander/custom_legion_commander_moment_of_courage", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_moment_of_courage_custom_lowhp", "abilities/legion_commander/custom_legion_commander_moment_of_courage", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_moment_of_courage_custom_lowhp_cd", "abilities/legion_commander/custom_legion_commander_moment_of_courage", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_moment_of_courage_custom_crit_attack", "abilities/legion_commander/custom_legion_commander_moment_of_courage", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_moment_of_courage_custom_legendary_defence", "abilities/legion_commander/custom_legion_commander_moment_of_courage", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_moment_of_courage_custom_legendary_attack", "abilities/legion_commander/custom_legion_commander_moment_of_courage", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_moment_of_courage_custom_slow", "abilities/legion_commander/custom_legion_commander_moment_of_courage", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_moment_of_courage_custom_no_trigger", "abilities/legion_commander/custom_legion_commander_moment_of_courage", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_moment_of_courage_custom_cd", "abilities/legion_commander/custom_legion_commander_moment_of_courage", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_moment_of_courage_custom_crit_stack", "abilities/legion_commander/custom_legion_commander_moment_of_courage", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_moment_of_courage_custom_damage", "abilities/legion_commander/custom_legion_commander_moment_of_courage", LUA_MODIFIER_MOTION_NONE)


custom_legion_commander_moment_of_courage = class({})







function custom_legion_commander_moment_of_courage:Precache(context)

PrecacheResource( "particle", "particles/lc_hit.vpcf", context )
PrecacheResource( "particle", "particles/sand_king/finale_double_hit.vpcf", context )
PrecacheResource( "particle", "particles/brist_lowhp_.vpcf", context )
PrecacheResource( "particle", "particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave_gods_strength.vpcf", context )
PrecacheResource( "particle", "particles/lc_charges.vpcf", context )
PrecacheResource( "particle", "particles/lc_attack_buf.vpcf", context )
PrecacheResource( "particle", "particles/lc_attack.vpcf", context )
PrecacheResource( "particle", "particles/lc_defence.vpcf", context )

end



function custom_legion_commander_moment_of_courage:ResetToggleOnRespawn() return false end


function custom_legion_commander_moment_of_courage:GetAbilityTextureName()
if self:GetCaster():HasModifier("modifier_moment_of_courage_custom_legendary_attack") then 
	return "Moment_of_curage_attack"
end

return "legion_commander_moment_of_courage"

end


function custom_legion_commander_moment_of_courage:GetBehavior()
if self:GetCaster():HasModifier("modifier_legion_moment_legendary") then
    return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_TOGGLE + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_IGNORE_SILENCE + DOTA_ABILITY_BEHAVIOR_IGNORE_PSEUDO_QUEUE
end
return DOTA_ABILITY_BEHAVIOR_PASSIVE 
end


function custom_legion_commander_moment_of_courage:GetCooldown(iLevel)
if IsClient() and self:GetCaster():HasModifier("modifier_legion_moment_bkb") then
	return self.BaseClass.GetCooldown(self, iLevel) + self:GetCaster():GetTalentValue("modifier_legion_moment_bkb", "cd")
end

 return self.BaseClass.GetCooldown(self, iLevel)

end


--------------------------------------------------------------------------------
-- Toggle
function custom_legion_commander_moment_of_courage:OnToggle() 
local caster = self:GetCaster()

if self:GetToggleState() then
    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_moment_of_courage_custom_legendary_attack", {})
    self:GetCaster():RemoveModifierByName("modifier_moment_of_courage_custom_legendary_defence")

else
    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_moment_of_courage_custom_legendary_defence", {})
    self:GetCaster():RemoveModifierByName("modifier_moment_of_courage_custom_legendary_attack")
end


self:StartCooldown(self:GetCaster():GetTalentValue("modifier_legion_moment_legendary", "toggle"))

end


function custom_legion_commander_moment_of_courage:GetIntrinsicModifierName() return "modifier_moment_of_courage_custom_tracker" end 

modifier_moment_of_courage_custom_tracker = class({})

function modifier_moment_of_courage_custom_tracker:IsHidden() return true end
function modifier_moment_of_courage_custom_tracker:IsPurgable() return false end
function modifier_moment_of_courage_custom_tracker:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_ATTACK_RECORD,
	MODIFIER_EVENT_ON_TAKEDAMAGE,
	MODIFIER_EVENT_ON_ATTACK_LANDED,
	MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
    MODIFIER_EVENT_ON_ABILITY_EXECUTED,
}

end
function modifier_moment_of_courage_custom_tracker:OnCreated()

self.caster = self:GetCaster()

self.spells_duration = self:GetCaster():GetTalentValue("modifier_legion_moment_bkb", "duration", true)

self.lowhp_health = self:GetCaster():GetTalentValue("modifier_legion_moment_lowhp", "health", true)
self.lowhp_duration = self:GetCaster():GetTalentValue("modifier_legion_moment_lowhp", "duration", true)
self.lowhp_cd = self:GetCaster():GetTalentValue("modifier_legion_moment_lowhp", "cd", true)
end 


function modifier_moment_of_courage_custom_tracker:OnAbilityExecuted( params )
if not IsServer() then return end
if not self.caster:HasModifier("modifier_legion_moment_bkb") then return end
if params.unit~=self:GetParent() then return end
if not params.ability then return end
if params.ability:IsToggle() then return end
if UnvalidAbilities[params.ability:GetName()] then return end
if UnvalidItems[params.ability:GetName()] then return end
if params.ability:IsItem()  then return end --and params.ability:GetCurrentCharges() > 0

self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_moment_of_courage_custom_speed", {duration = self.spells_duration})
end 


function modifier_moment_of_courage_custom_tracker:GetModifierAttackRangeBonus()
if not self:GetCaster():HasModifier("modifier_legion_moment_chance") then return end 

return self:GetCaster():GetTalentValue("modifier_legion_moment_chance", "range")
end 


function modifier_moment_of_courage_custom_tracker:OnRespawn(params)
if not IsServer() then return end
if params.unit ~= self:GetParent() then return end
if not self:GetParent():HasModifier("modifier_legion_moment_legendary") then return end


self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_moment_of_courage_custom_legendary_defence", {})
end




function modifier_moment_of_courage_custom_tracker:OnTakeDamage(params)
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_legion_moment_lowhp") then return end
if self:GetParent():HasModifier("modifier_moment_of_courage_custom_lowhp_cd") then return end 
if self:GetParent():GetHealthPercent() > self.lowhp_health then return end 
if self:GetParent():PassivesDisabled() then return end
if self:GetParent() ~= params.unit then return end  
if self:GetParent():HasModifier("modifier_death") then return end

self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_moment_of_courage_custom_lowhp", {duration = self.lowhp_duration})
self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_moment_of_courage_custom_lowhp_cd", {duration = self.lowhp_cd})

end




function modifier_moment_of_courage_custom_tracker:OnAttackRecord(params)
if not IsServer() then return end
if self:GetParent():PassivesDisabled() then return end
if params.target ~= self:GetParent() then return end

self:TriggerAttack()
end

function modifier_moment_of_courage_custom_tracker:OnAttackLanded(params)
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_moment_of_courage_custom_legendary_attack") then return end
if params.attacker ~= self:GetParent() then return end
if self:GetParent():PassivesDisabled() then return end

self:TriggerAttack()
end



function modifier_moment_of_courage_custom_tracker:TriggerAttack()
if not IsServer() then return end
if not self:GetAbility():IsFullyCastable() and not self:GetParent():HasModifier("modifier_legion_moment_legendary") then return end
if self:GetParent():HasModifier("modifier_moment_of_courage_custom_no_trigger") then return end
if self:GetParent():HasModifier("modifier_moment_of_courage_custom_cd") then return end
if self:GetParent():HasModifier("modifier_moment_of_courage_custom_speed") then return end


self.chance = self:GetAbility():GetSpecialValueFor("trigger_chance") + self:GetCaster():GetTalentValue("modifier_legion_moment_bkb", "chance")

if self:GetParent():HasModifier("modifier_moment_of_courage_custom_legendary_defence") then 
	self.chance = self.chance*self:GetCaster():GetTalentValue("modifier_legion_moment_legendary", "chance")
end

local random = RollPseudoRandomPercentage(self.chance,27,self:GetParent())
if not random then return end

self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_moment_of_courage_custom_speed", {duration = self:GetAbility():GetSpecialValueFor("buff_duration")})

local cd = self:GetAbility().BaseClass.GetCooldown(self:GetAbility(), self:GetAbility():GetLevel())

if self:GetParent():HasModifier("modifier_legion_moment_bkb") then 
	cd = cd + self:GetCaster():GetTalentValue("modifier_legion_moment_bkb", "cd")
end

if not self:GetParent():HasModifier("modifier_legion_moment_legendary") then 
	self:GetAbility():StartCooldown(cd)
else
	self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_moment_of_courage_custom_cd", {duration = cd})
end

end






modifier_moment_of_courage_custom_speed = class({})
function modifier_moment_of_courage_custom_speed:IsHidden() return false end
function modifier_moment_of_courage_custom_speed:IsPurgable() return false end
function modifier_moment_of_courage_custom_speed:OnCreated(table)
if not IsServer() then return end
self:StartIntervalThink(FrameTime())
self.active = false

self.caster = self:GetParent()
end


function modifier_moment_of_courage_custom_speed:OnIntervalThink()
if not IsServer() then return end
if not self.caster:GetAttackTarget() then return end
if self.active == true then return end 

self.active = true


local target = self.caster:GetAttackTarget()

if not target or target:IsNull() or not target:IsAlive() then self:Destroy() return end

self.caster:EmitSound("Hero_LegionCommander.Courage")

self.caster:StartGestureWithPlaybackRate(ACT_DOTA_ATTACK, 2)

local dir = (target:GetOrigin() - self.caster:GetOrigin() ):Normalized()

local part = "particles/lc_hit.vpcf"

if self.caster:HasModifier("modifier_moment_of_courage_custom_legendary_attack") then 
	part = "particles/sand_king/finale_double_hit.vpcf"
end 


local particle = ParticleManager:CreateParticle( part , PATTACH_ABSORIGIN_FOLLOW, self.caster )
ParticleManager:SetParticleControl( particle, 0, self.caster:GetAbsOrigin() )
ParticleManager:SetParticleControl( particle, 1, self.caster:GetAbsOrigin() )
ParticleManager:SetParticleControlForward( particle, 1, dir)
ParticleManager:SetParticleControl( particle, 2, Vector(1,1,1) )
ParticleManager:SetParticleControlForward( particle, 5, dir )
ParticleManager:ReleaseParticleIndex(particle)

if self.caster:HasModifier("modifier_legion_moment_defence") then 
	local duration = self.caster:GetTalentValue("modifier_legion_moment_defence", "duration")

	self.caster:AddNewModifier(self.caster, self:GetAbility(), "modifier_moment_of_courage_custom_armor", {duration = duration})
	target:AddNewModifier(self.caster, self:GetAbility(), "modifier_moment_of_courage_custom_armor", {duration = duration})
end

if self.caster:HasModifier("modifier_legion_moment_damage") then 
	self.caster:AddNewModifier(self.caster, self:GetAbility(), "modifier_moment_of_courage_custom_damage", {duration =self:GetCaster():GetTalentValue("modifier_legion_moment_damage", "duration")})
end

self.caster:AddNewModifier(self.caster, self:GetAbility(), "modifier_moment_of_courage_custom_no_trigger", {})
self.caster:PerformAttack(target, true, true, true, false, true, false, false)
self.caster:RemoveModifierByName("modifier_moment_of_courage_custom_no_trigger")


if self.caster:HasModifier("modifier_legion_moment_chance") then 
	target:AddNewModifier(self.caster, self:GetAbility(), "modifier_moment_of_courage_custom_slow", {duration = self:GetCaster():GetTalentValue("modifier_legion_moment_chance", "duration", true)*(1 - target:GetStatusResistance())})
end 


if self.caster:HasModifier("modifier_legion_moment_armor") then 
	local mod = self.caster:FindModifierByName("modifier_moment_of_courage_custom_crit_stack")

	local max = self:GetCaster():GetTalentValue("modifier_legion_moment_armor", "cd")
	local cd_proc = self:GetCaster():GetTalentValue("modifier_legion_moment_armor", "cd_reduce")

	if mod and mod:GetStackCount() < max then 
		mod:SetStackCount(math.min(max, mod:GetStackCount() + cd_proc) )
	end 

end

self:Destroy()
end










modifier_moment_of_courage_custom_armor = class({})
function modifier_moment_of_courage_custom_armor:IsHidden() return true end
function modifier_moment_of_courage_custom_armor:IsPurgable() return false end

function modifier_moment_of_courage_custom_armor:OnCreated(table)

self.armor = self:GetCaster():GetTalentValue("modifier_legion_moment_defence", "armor")

if self:GetCaster():GetTeamNumber() ~= self:GetParent():GetTeamNumber() then 
	self.armor = self.armor * -1
end 

end



function modifier_moment_of_courage_custom_armor:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
}
end
function modifier_moment_of_courage_custom_armor:GetModifierPhysicalArmorBonus()
 return self.armor
end












modifier_moment_of_courage_custom_crit_stack = class({})
function modifier_moment_of_courage_custom_crit_stack:IsHidden() return true end
function modifier_moment_of_courage_custom_crit_stack:IsPurgable() return false end
function modifier_moment_of_courage_custom_crit_stack:RemoveOnDeath() return false end
function modifier_moment_of_courage_custom_crit_stack:OnCreated(table)

self.max = self:GetCaster():GetTalentValue("modifier_legion_moment_armor", "cd")

if not IsServer() then return end

self:SetStackCount(self.max)

self:StartIntervalThink(FrameTime())
end



function modifier_moment_of_courage_custom_crit_stack:OnIntervalThink()
if not IsServer() then return end 

if self:GetStackCount() >= self.max then 

	if not self:GetParent():HasModifier("modifier_moment_of_courage_custom_crit_attack") then 
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_moment_of_courage_custom_crit_attack", {})
	end 

else 
	self:IncrementStackCount()
end 

end 




function modifier_moment_of_courage_custom_crit_stack:OnStackCountChanged(iStackCount)
if not IsServer() then return end 

CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), 'courage_crit_change',  {max = self.max, damage = self:GetStackCount()})


if self:GetStackCount() >= self.max then 
	self:StartIntervalThink(FrameTime())
else 
	self:StartIntervalThink(1)
end 

end








modifier_moment_of_courage_custom_crit_attack = class({})
function modifier_moment_of_courage_custom_crit_attack:IsHidden() return true end
function modifier_moment_of_courage_custom_crit_attack:IsPurgable() return false end
function modifier_moment_of_courage_custom_crit_attack:GetTexture() return "buffs/Crit_speed" end

function modifier_moment_of_courage_custom_crit_attack:OnCreated(table)

self.cleave = self:GetCaster():GetTalentValue("modifier_legion_moment_armor", "cleave")/100
self.crit = self:GetCaster():GetTalentValue("modifier_legion_moment_armor", "crit")
self.stun = self:GetCaster():GetTalentValue("modifier_legion_moment_armor", "stun")

if not IsServer() then return end

self:GetParent():EmitSound("Lc.Courage_crit")
local particle_peffect = ParticleManager:CreateParticle("particles/brist_lowhp_.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControl(particle_peffect, 0, self:GetParent():GetAbsOrigin())
ParticleManager:SetParticleControl(particle_peffect, 2, self:GetParent():GetAbsOrigin())
ParticleManager:ReleaseParticleIndex(particle_peffect)

end



function modifier_moment_of_courage_custom_crit_attack:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
	MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
	MODIFIER_EVENT_ON_ATTACK_LANDED,
	MODIFIER_EVENT_ON_ATTACK_START
}
end

function modifier_moment_of_courage_custom_crit_attack:OnAttackStart(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end
if self:GetParent():HasModifier("modifier_moment_of_courage_custom_no_trigger") then return end
self:GetParent():EmitSound("Lc.Odds_ChargeHit")
end

function modifier_moment_of_courage_custom_crit_attack:GetActivityTranslationModifiers() return "duel_kill" end


function modifier_moment_of_courage_custom_crit_attack:GetCritDamage() 
return self.crit
end


function modifier_moment_of_courage_custom_crit_attack:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end
if self:GetParent():HasModifier("modifier_moment_of_courage_custom_no_trigger") then return end

params.target:EmitSound("BB.Goo_stun")   

DoCleaveAttack(self:GetParent(), params.target, nil, params.damage*(self.cleave), 150, 360, 650, "particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave_gods_strength.vpcf")

if  params.target:IsHero() or params.target:IsCreep() then
	params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_bashed", {duration = self.stun *(1 - params.target:GetStatusResistance())})
end

local mod = self:GetParent():FindModifierByName('modifier_moment_of_courage_custom_crit_stack')
if mod then 
	mod:SetStackCount(0)
end 

self:Destroy()

end

function modifier_moment_of_courage_custom_crit_attack:GetModifierPreAttack_CriticalStrike(params)
if self:GetParent():HasModifier("modifier_moment_of_courage_custom_no_trigger") then return end

return self.crit
end














modifier_moment_of_courage_custom_no_trigger = class({})
function modifier_moment_of_courage_custom_no_trigger:IsHidden() return true end
function modifier_moment_of_courage_custom_no_trigger:IsPurgable() return false end
function modifier_moment_of_courage_custom_no_trigger:DeclareFunctions()
return 
{
	MODIFIER_EVENT_ON_TAKEDAMAGE
}
end



function modifier_moment_of_courage_custom_no_trigger:OnTakeDamage(params)
if not IsServer() then return end 
if self:GetParent() ~= params.attacker then return end
if params.inflictor then return end 


self.heal = self:GetAbility():GetSpecialValueFor("hp_leech_percent")/100

if self:GetParent():HasModifier("modifier_moment_of_courage_custom_lowhp") then 
	self.heal = self.heal + self:GetCaster():GetTalentValue("modifier_legion_moment_lowhp", "lifesteal")/100
end

if self:GetParent():HasModifier("modifier_moment_of_courage_custom_legendary_defence") then 
	self.heal = self.heal + self:GetCaster():GetTalentValue("modifier_legion_moment_legendary", "lifesteal")/100
end


local heal = params.damage*self.heal

if not params.unit:IsBuilding() and not params.unit:IsIllusion() then 

	if self:GetParent():GetQuest() == "Legion.Quest_7" and params.unit:IsRealHero() and self:GetParent():GetHealthPercent() < 100 then 
	  self:GetParent():UpdateQuest( math.floor( math.min( (self:GetParent():GetMaxHealth() - self:GetParent():GetHealth()), heal )))
	end

	self:GetParent():GenericHeal(heal, self:GetParent())
end

self:Destroy()
end 







modifier_moment_of_courage_custom_cd = class({})
function modifier_moment_of_courage_custom_cd:IsHidden() return true end
function modifier_moment_of_courage_custom_cd:IsPurgable() return false end











modifier_moment_of_courage_custom_legendary_attack = class({})
function modifier_moment_of_courage_custom_legendary_attack:IsHidden() return false end
function modifier_moment_of_courage_custom_legendary_attack:IsPurgable() return false end
function modifier_moment_of_courage_custom_legendary_attack:RemoveOnDeath() return false end
function modifier_moment_of_courage_custom_legendary_attack:GetTexture() return "buffs/moment_attack" end
function modifier_moment_of_courage_custom_legendary_attack:GetEffectName() return "particles/lc_attack_buf.vpcf" end
function modifier_moment_of_courage_custom_legendary_attack:OnCreated(table)

self.move = self:GetCaster():GetTalentValue("modifier_legion_moment_legendary", "move")
self.speed = self:GetCaster():GetTalentValue("modifier_legion_moment_legendary", "speed")

if not IsServer() then return end

self:GetParent():EmitSound("Lc.Moment_Attack")
self.particle_peffect = ParticleManager:CreateParticle("particles/lc_attack.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())	
ParticleManager:SetParticleControl(self.particle_peffect, 0, self:GetParent():GetAbsOrigin())

--self:StartIntervalThink(0.2)
end



function modifier_moment_of_courage_custom_legendary_attack:DestroyPart()
if not IsServer() then return end
if not self.particle_peffect then return end

ParticleManager:DestroyParticle(self.particle_peffect, false)
ParticleManager:ReleaseParticleIndex(self.particle_peffect)
end


function modifier_moment_of_courage_custom_legendary_attack:OnDestroy()
if not IsServer() then return end
self:DestroyPart()
end


function modifier_moment_of_courage_custom_legendary_attack:OnIntervalThink()
if not IsServer() then return end
self:DestroyPart()
self:StartIntervalThink(-1)
end




function modifier_moment_of_courage_custom_legendary_attack:DeclareFunctions()
return 
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
end

function modifier_moment_of_courage_custom_legendary_attack:GetModifierMoveSpeedBonus_Percentage()
return self.move
end

function modifier_moment_of_courage_custom_legendary_attack:GetModifierAttackSpeedBonus_Constant()
return self.speed
end



modifier_moment_of_courage_custom_legendary_defence = class({})
function modifier_moment_of_courage_custom_legendary_defence:IsHidden() return false end
function modifier_moment_of_courage_custom_legendary_defence:GetTexture() return "buffs/moment_defence" end
function modifier_moment_of_courage_custom_legendary_defence:IsPurgable() return false end
function modifier_moment_of_courage_custom_legendary_defence:RemoveOnDeath() return false end
function modifier_moment_of_courage_custom_legendary_defence:OnCreated(table)

self.damage_reduce = self:GetCaster():GetTalentValue("modifier_legion_moment_legendary", "damage_reduce", true)

if not IsServer() then return end

self:GetParent():EmitSound("Lc.Moment_Defence")
self.particle_peffect = ParticleManager:CreateParticle("particles/lc_defence.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())	
ParticleManager:SetParticleControl(self.particle_peffect, 0, self:GetParent():GetAbsOrigin())
self.particle_peffect_2 = ParticleManager:CreateParticle("particles/items3_fx/star_emblem_friend_shield.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())	
ParticleManager:SetParticleControl(self.particle_peffect_2, 0, self:GetParent():GetAbsOrigin())

--self:StartIntervalThink(self:GetAbility().legendary_cd)
end





function modifier_moment_of_courage_custom_legendary_defence:OnDestroy()
if not IsServer() then return end

if self.particle_peffect then 
		
	ParticleManager:DestroyParticle(self.particle_peffect, false)
	ParticleManager:ReleaseParticleIndex(self.particle_peffect)
end
if self.particle_peffect_2 then
	ParticleManager:DestroyParticle(self.particle_peffect_2, false)
	ParticleManager:ReleaseParticleIndex(self.particle_peffect_2)
end

end

function modifier_moment_of_courage_custom_legendary_defence:OnIntervalThink()
if not IsServer() then return end

if self.particle_peffect_2 then
	ParticleManager:DestroyParticle(self.particle_peffect_2, false)
	ParticleManager:ReleaseParticleIndex(self.particle_peffect_2)
end

self:StartIntervalThink(-1)
end


function modifier_moment_of_courage_custom_legendary_defence:DeclareFunctions()
return 
{
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
}
end

function modifier_moment_of_courage_custom_legendary_defence:GetModifierIncomingDamage_Percentage()
return self.damage_reduce
end



modifier_moment_of_courage_custom_lowhp = class({})
function modifier_moment_of_courage_custom_lowhp:IsHidden() return false end
function modifier_moment_of_courage_custom_lowhp:IsPurgable() return false end
function modifier_moment_of_courage_custom_lowhp:GetTexture() return "buffs/moment_lowhp" end

function modifier_moment_of_courage_custom_lowhp:OnCreated(table)
self.damage_reduce = self:GetCaster():GetTalentValue("modifier_legion_moment_lowhp", "damage_reduce")

if not IsServer() then return end
self.RemoveForDuel = true	

self.particle_1 = "particles/units/heroes/hero_pangolier/pangolier_tailthump_buff.vpcf"
self.particle_2 = "particles/units/heroes/hero_pangolier/pangolier_tailthump_buff_egg.vpcf"
self.particle_3 = "particles/units/heroes/hero_pangolier/pangolier_tailthump_buff_streaks.vpcf"
self.sound = "LC.Courage_armor"
self.buff_particles = {}

self:GetCaster():EmitSound( self.sound)


self.buff_particles[1] = ParticleManager:CreateParticle(self.particle_1, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
ParticleManager:SetParticleControlEnt(self.buff_particles[1], 1, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, Vector(0,0,0), false) 
self:AddParticle(self.buff_particles[1], false, false, -1, true, false)
ParticleManager:SetParticleControl( self.buff_particles[1], 3, Vector( 255, 255, 255 ) )

self.buff_particles[2] = ParticleManager:CreateParticle(self.particle_2, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
ParticleManager:SetParticleControlEnt(self.buff_particles[2], 1, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, Vector(0,0,0), false) 
self:AddParticle(self.buff_particles[2], false, false, -1, true, false)

self.buff_particles[3] = ParticleManager:CreateParticle(self.particle_3, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
ParticleManager:SetParticleControlEnt(self.buff_particles[3], 1, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, Vector(0,0,0), false) 
self:AddParticle(self.buff_particles[3], false, false, -1, true, false)
end


function modifier_moment_of_courage_custom_lowhp:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
}
end


function modifier_moment_of_courage_custom_lowhp:GetModifierIncomingDamage_Percentage()
return self.damage_reduce
end


modifier_moment_of_courage_custom_lowhp_cd = class({})
function modifier_moment_of_courage_custom_lowhp_cd:IsHidden() return false end
function modifier_moment_of_courage_custom_lowhp_cd:IsPurgable() return false end
function modifier_moment_of_courage_custom_lowhp_cd:GetTexture() return "buffs/moment_lowhp" end
function modifier_moment_of_courage_custom_lowhp_cd:IsDebuff() return true end
function modifier_moment_of_courage_custom_lowhp_cd:RemoveOnDeath() return false end
function modifier_moment_of_courage_custom_lowhp_cd:OnCreated(table)
self.RemoveForDuel = true
end














modifier_moment_of_courage_custom_slow = class({})
function modifier_moment_of_courage_custom_slow:IsHidden() return true end
function modifier_moment_of_courage_custom_slow:IsPurgable() return true end
function modifier_moment_of_courage_custom_slow:GetTexture() return "buffs/cleave_slow" end
function modifier_moment_of_courage_custom_slow:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end


function modifier_moment_of_courage_custom_slow:OnCreated()
self.slow = self:GetCaster():GetTalentValue("modifier_legion_moment_chance", "slow")
if not IsServer() then return end 

self:GetParent():EmitSound("DOTA_Item.Maim")
end

function modifier_moment_of_courage_custom_slow:GetModifierMoveSpeedBonus_Percentage()
return self.slow
end

function modifier_moment_of_courage_custom_slow:GetEffectName()
return "particles/items2_fx/sange_maim.vpcf"
end


function modifier_moment_of_courage_custom_slow:GetEffectAttachType()
return PATTACH_ABSORIGIN_FOLLOW
end




modifier_moment_of_courage_custom_damage = class({})

function modifier_moment_of_courage_custom_damage:IsHidden() return false end
function modifier_moment_of_courage_custom_damage:IsPurgable() return false end

function modifier_moment_of_courage_custom_damage:OnCreated(table)

self.max = self:GetCaster():GetTalentValue("modifier_legion_moment_damage", "max")
self.damage = self:GetCaster():GetTalentValue("modifier_legion_moment_damage", "damage")

if not IsServer() then return end
self:SetStackCount(1)
end

function modifier_moment_of_courage_custom_damage:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end

self:IncrementStackCount()

end


function modifier_moment_of_courage_custom_damage:GetTexture() return "buffs/moment_damage" end
function modifier_moment_of_courage_custom_damage:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE
}
end
function modifier_moment_of_courage_custom_damage:GetModifierDamageOutgoing_Percentage()
 return self:GetStackCount()*self.damage
end



