
modifier_waveupgrade = class({})


function modifier_waveupgrade:IsHidden() return true end
function modifier_waveupgrade:IsPurgable() return false end

function modifier_waveupgrade:CheckState() 
if self:GetParent().mkb == 1 then 
  return {[MODIFIER_STATE_CANNOT_MISS]  = true } 
else 
  return
end

end

function modifier_waveupgrade:DeclareFunctions()
   return   {
    MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
    MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
    MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
    MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
    MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
    MODIFIER_EVENT_ON_DEATH,
    MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
    MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
    MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,


  }


end


function modifier_waveupgrade:GetAbsoluteNoDamagePhysical(params)
if not IsServer() then return end
if (params.attacker:GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D() > 2000 then return 1 end

if self.no_damage == 0 then return end
if not self:GetParent().owner then return end

if params.attacker:GetTeamNumber() ~= self:GetParent().owner:GetTeamNumber() then return 1 end

return 0
end


function modifier_waveupgrade:GetAbsoluteNoDamagePure(params)
if not IsServer() then return end
if (params.attacker:GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D() > 2000 then return 1 end
if self.no_damage == 0 then return end
if not self:GetParent().owner then return end

if params.attacker:GetTeamNumber() ~= self:GetParent().owner:GetTeamNumber() then return 1 end

return 0
end


function modifier_waveupgrade:GetAbsoluteNoDamageMagical(params)
if not IsServer() then return end
if (params.attacker:GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D() > 2000 then return 1 end
if self.no_damage == 0 then return end
if not self:GetParent().owner then return end

if params.attacker:GetTeamNumber() ~= self:GetParent().owner:GetTeamNumber() then return 1 end

return 0
end




function modifier_waveupgrade:GetModifierIncomingDamage_Percentage(params)
if params.damage_type == DAMAGE_TYPE_PURE then 
  return self.pure
end

end


function modifier_waveupgrade:OnDeath(params)
if not IsServer() then return end
if params.unit ~= self:GetParent() then return end
local n = self:GetParent():GetSpawnGroupHandle()


if self:GetParent():GetSpawnGroupHandle() ~= 1 then 

 --Timers:CreateTimer(8, function() UnloadSpawnGroupByHandle(n) end)

  
end

end

function modifier_waveupgrade:GetModifierStatusResistanceStacking() return 50 end


function modifier_waveupgrade:GetModifierTotalDamageOutgoing_Percentage( params ) 
if params.attacker == self:GetParent() then 
   if params.target then 
      if params.target:IsBuilding() then 

        if self:GetParent():HasModifier("modifier_necro_creeps") then 
          return -45
        end 

        return -65
      end
  	end 
end

end


function modifier_waveupgrade:OnCreated(table)
if not IsServer() then return end


self.multi = 0
self.no_damage = 0

if self:GetParent().owner ~= nil then 
  self.multi = self:GetParent().owner.creeps_upgrade

  if table.wave and table.wave < 5 then 
    self.no_damage = 1
  end

end

for abilitySlot = 0,8 do

  local ability = self:GetParent():GetAbilityByIndex(abilitySlot)

  if ability ~= nil then
    ability:SetLevel(1)
  end
end

if self:GetParent():GetUnitName() == "npc_warlock_golem_custom" then 
  return 
end
 

self.health = self:GetParent():GetBaseMaxHealth()
self.damage = self:GetParent():GetBaseDamageMin()
self.gold = self:GetParent():GetMinimumGoldBounty()*1.15
self.exp = self:GetParent():GetDeathXP()*0.85


self.armor = 0
self.magic = 10
self.amp = 0
self.speed = 0
self.pure = 0

self.change_health = 0
self.change_damage = 0


for i = 2, my_game.current_wave do

  self.up_health = 1.30
  self.up_damage = 1.23
  self.up_gold = 1.00
  self.up_exp = 1.04
 
  if i >= 10 then self.up_damage = 1.18 self.up_health = 1.21 self.armor = 4 self.speed = 20 self.magic = 0 end 
  if i >= 15 then self.up_damage = 1.17 self.up_health = 1.20 self.armor = 6 self.speed = 40 self.magic = -10 self.pure = 10 end 
  if i >= 20 then self.up_damage = 1.18 self.up_health = 1.23 self.armor = 8 self.speed = 80 self.magic = -20 self.pure = 20 end 

  self.health = self.health*self.up_health
  self.damage = self.damage*self.up_damage
  self.gold = self.gold*self.up_gold
  self.exp = self.exp*self.up_exp
  self.amp = self.amp + 33

  if i == 11 then 
    self.health = self.health*1.3
    self.damage = self.damage*1.3
  end

end
  
if self.multi then 
  local multi_up = 1 + self.multi*0.08

  self.health = self.health*multi_up
  self.damage = self.damage*multi_up
end


self.change_health = self.health - self:GetParent():GetBaseMaxHealth()
self.change_damage = self.damage - self:GetParent():GetBaseDamageMin()

self:GetParent():SetMinimumGoldBounty(self.gold)
self:GetParent():SetMaximumGoldBounty(self.gold)

self:GetParent():SetDeathXP(self.exp)

self:SetHasCustomTransmitterData(true)
end



function modifier_waveupgrade:AddCustomTransmitterData() return 
{
amp = self.amp ,
armor = self.armor,
magic = self.magic,
speed = self.speed
} 
end

function modifier_waveupgrade:HandleCustomTransmitterData(data)
self.amp  = data.amp
self.armor = data.armor
self.magic = data.magic
self.speed = data.speed
end

function modifier_waveupgrade:GetModifierAttackSpeedBonus_Constant()
return self.speed
end


function modifier_waveupgrade:GetModifierMagicalResistanceBonus()
return self.magic
end


function modifier_waveupgrade:GetModifierBaseAttack_BonusDamage()
return self.change_damage
end


function modifier_waveupgrade:GetModifierExtraHealthBonus()
return self.change_health
end

function modifier_waveupgrade:GetModifierPhysicalArmorBonus()
return self.armor
end

function modifier_waveupgrade:GetModifierSpellAmplify_Percentage() 
return self.amp
end



