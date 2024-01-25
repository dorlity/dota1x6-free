LinkLuaModifier("modifier_monkey_king_mischief_custom", "abilities/monkey_king/monkey_king_mischief_custom.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_monkey_king_mischief_anim", "abilities/monkey_king/monkey_king_mischief_custom.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_monkey_king_mischief_invun", "abilities/monkey_king/monkey_king_mischief_custom.lua", LUA_MODIFIER_MOTION_NONE)




monkey_king_mischief_custom = class({})


function monkey_king_mischief_custom:Precache(context)

PrecacheResource( "particle", 'particles/units/heroes/hero_monkey_king/monkey_king_disguise.vpcf', context )

end

function monkey_king_mischief_custom:GetCooldown(iLevel)
return self:GetCaster():GetTalentValue("modifier_monkey_king_command_7", "cd")
end


function monkey_king_mischief_custom:OnSpellStart()
if not IsServer() then return end
local point = self:GetCursorPosition()
local radius = self:GetSpecialValueFor("radius")
local flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD


ProjectileManager:ProjectileDodge(self:GetCaster())

local main = self:GetCaster():FindAbilityByName("monkey_king_wukongs_command_custom")

if main:GetLevel() < 1 then return end

self:GetCaster():RemoveModifierByName("modifier_monkey_king_tree_dance_custom")
FindClearSpaceForUnit(self:GetCaster(), self:GetCaster():GetAbsOrigin(), false)

self:GetCaster():SwapAbilities(self:GetName(), "monkey_king_mischief_end_custom", false, true)
self:GetCaster():FindAbilityByName("monkey_king_mischief_end_custom"):StartCooldown(0.5)


local targets = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), point, nil, -1, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, flags, FIND_CLOSEST, false)


local caster_dir = self:GetCaster():GetForwardVector()
local caster = self:GetCaster()
local target_dir = nil 

local old_monkey = nil
local tp = false
caster:Stop()

caster:AddNewModifier(caster, self, "modifier_monkey_king_mischief_invun", {duration = self:GetSpecialValueFor("invun")})
caster:AddNewModifier(caster, main, "modifier_monkey_king_mischief_custom", {duration = self:GetSpecialValueFor("duration")})

EmitSoundOnLocationWithCaster(self:GetCaster():GetAbsOrigin(), "Hero_MonkeyKing.Transform.On", self:GetCaster())

local new_pos = self:GetCaster():GetAbsOrigin()

for _,target in pairs(targets) do 

if (target:GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Length2D() <= radius and tp == false then 

    if target:HasModifier("modifier_monkey_king_wukongs_command_custom_soldier_active") then
      tp = true
      new_pos = target:GetAbsOrigin()
      target_dir = target:GetForwardVector()

      FindClearSpaceForUnit(target, self:GetCaster():GetAbsOrigin(), false)
      target:SetForwardVector(caster_dir)
      target:FaceTowards(target:GetAbsOrigin() + caster_dir*10)


      old_monkey = target
      FindClearSpaceForUnit(self:GetCaster(), new_pos, false)
    else 
      if target == self:GetCaster() then 
        tp = true
      end
    end

end



if target:HasModifier("modifier_monkey_king_wukongs_command_custom_soldier_active") then 

  target:RemoveModifierByName("modifier_monkey_king_jingu_mastery_custom_hit")
  target:RemoveModifierByName("modifier_monkey_king_jingu_mastery_custom_buff")


  local part = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_disguise.vpcf", PATTACH_WORLDORIGIN, nil)
  ParticleManager:SetParticleControl(part, 0, target:GetAbsOrigin())
end 

end

local monkey = main:SpawnMonkeyKingPointScepter(self:GetCaster():GetAbsOrigin(), nil, true, true)

if target_dir == nil then 
  target_dir = self:GetCaster():GetForwardVector()
end

if monkey == nil then 
  caster:RemoveModifierByName("modifier_monkey_king_mischief_custom")
  return
end


if false and old_monkey ~= nil then 

  local stack_mod = old_monkey:FindModifierByName("modifier_monkey_king_jingu_mastery_custom_hit")
  local buff_mod = old_monkey:FindModifierByName("modifier_monkey_king_jingu_mastery_custom_buff")
  local ability = old_monkey:FindAbilityByName("monkey_king_jingu_mastery_custom")

  if stack_mod then 
    local new_stack =monkey:AddNewModifier(monkey, ability, stack_mod:GetName(), {duration = stack_mod:GetRemainingTime()})
    new_stack:SetStackCount(stack_mod:GetStackCount())
    stack_mod:Destroy()
  end

  if buff_mod then 
    local new_buff = monkey:AddNewModifier(monkey, ability, buff_mod:GetName(), {duration = buff_mod:GetRemainingTime()})
    new_buff:SetStackCount(buff_mod:GetStackCount())
    buff_mod:Destroy()
  end

end

monkey:SetForwardVector(target_dir)
monkey:FaceTowards(monkey:GetAbsOrigin() + target_dir*10)


if not monkey then return end 

caster:AddNewModifier(caster, main, "modifier_monkey_king_mischief_custom", {monkey = monkey:entindex()})


local part = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_disguise.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(part, 0, monkey:GetAbsOrigin())


 -- target:AddNewModifier(self:GetCaster(), self, "modifier_monkey_king_mischief_anim", {duration = 0.5})


self:EndCooldown()

end





modifier_monkey_king_mischief_custom = class({})

function modifier_monkey_king_mischief_custom:IsHidden()
  return true
end

function modifier_monkey_king_mischief_custom:IsPurgable()
  return false
end


function modifier_monkey_king_mischief_custom:OnCreated(params)
if not IsServer() then return end
self.NoDraw = true
self:GetParent():AddNoDraw()
self:StartIntervalThink(0.3)
self.RemoveForDuel = true 

self.skills = {}

self.skills[1] = self:GetParent():FindAbilityByName("monkey_king_boundless_strike_custom")
self.skills[2] = self:GetParent():FindAbilityByName("monkey_king_tree_dance_custom")
self.skills[3] = self:GetParent():FindAbilityByName("monkey_king_primal_spring_custom")
self.skills[4] = self:GetParent():FindAbilityByName("monkey_king_jingu_mastery_custom")
self.skills[5] = self:GetParent():FindAbilityByName("monkey_king_wukongs_command_custom")

for _,skill in pairs(self.skills) do 
  skill:SetActivated(false)
end


end



function modifier_monkey_king_mischief_custom:OnIntervalThink()
if not IsServer() then return end
if not self.pos then return end
FindClearSpaceForUnit(self:GetParent(), self.pos, false)
end

function modifier_monkey_king_mischief_custom:OnRefresh(table)
if not IsServer() then return end
self.monkey = EntIndexToHScript(table.monkey)
self.pos = self:GetCaster():GetAbsOrigin()
end


function modifier_monkey_king_mischief_custom:CheckState()
return {
    [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
    [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
    [MODIFIER_STATE_NO_HEALTH_BAR] = true,
    [MODIFIER_STATE_NOT_ON_MINIMAP] = true,
    [MODIFIER_STATE_MAGIC_IMMUNE] = true,
    [MODIFIER_STATE_ROOTED] = true,
    [MODIFIER_STATE_DISARMED] = true,
    [MODIFIER_STATE_INVULNERABLE] = true,
    [MODIFIER_STATE_OUT_OF_GAME] = true,
  }
end



function modifier_monkey_king_mischief_custom:DeclareFunctions()
return
{
  MODIFIER_EVENT_ON_ATTACK_LANDED,
  MODIFIER_EVENT_ON_ATTACK_FAIL
}
end

function modifier_monkey_king_mischief_custom:OnAttackLanded(params)
if not IsServer() then return end
if not params.attacker:IsHero() then return end
if self.monkey == nil then 
  self:Destroy()
  return
end

if self.monkey ~= params.target then return end

self:Destroy()

end


function modifier_monkey_king_mischief_custom:OnAttackFail(params)
if not IsServer() then return end
if not params.attacker:IsHero() then return end
if self.monkey == nil then 
  self:Destroy()
  return
end

if self.monkey ~= params.target then return end


self:Destroy()

end


function modifier_monkey_king_mischief_custom:OnDestroy()
if not IsServer() then return end
self:GetParent():RemoveNoDraw()

local ability = self:GetParent():FindAbilityByName("monkey_king_mischief_custom")

if ability then 
  ability:UseResources(false, false, false, true)
end

for _,skill in pairs(self.skills) do 
  if skill:GetName() == "monkey_king_primal_spring_custom" then 

    skill:SetActivated(skill:CanBeCast())
  else 
    skill:SetActivated(true)
  end 
end

self:GetCaster():SetForwardVector(self.monkey:GetForwardVector())
self:GetCaster():FaceTowards(self:GetCaster():GetAbsOrigin() + self.monkey:GetForwardVector()*10)

if self.monkey then 
 self.monkey:RemoveModifierByName("modifier_monkey_king_wukongs_command_custom_soldier_active")
end

self:GetCaster():SwapAbilities("monkey_king_mischief_end_custom", "monkey_king_mischief_custom", false, true)

local part = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_disguise.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(part, 0, self:GetParent():GetAbsOrigin())
EmitSoundOnLocationWithCaster(self:GetParent():GetAbsOrigin(), "Hero_MonkeyKing.Transform.On", self:GetParent())
end







monkey_king_mischief_end_custom = class({})

function monkey_king_mischief_end_custom:OnSpellStart()
if not IsServer() then return end
self:GetCaster():RemoveModifierByName("modifier_monkey_king_mischief_custom")



end





modifier_monkey_king_mischief_anim = class({})
function modifier_monkey_king_mischief_anim:IsHidden() return false end
function modifier_monkey_king_mischief_anim:IsPurgable() return false end


modifier_monkey_king_mischief_invun = class({})
function modifier_monkey_king_mischief_invun:IsHidden() return true end
function modifier_monkey_king_mischief_invun:IsPurgable() return false end