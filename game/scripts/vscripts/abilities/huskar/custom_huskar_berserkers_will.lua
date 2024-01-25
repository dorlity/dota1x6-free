LinkLuaModifier("modifier_custom_huskar_berserkers_will_shield", "abilities/huskar/custom_huskar_berserkers_will", LUA_MODIFIER_MOTION_NONE)



custom_huskar_berserkers_will                  = class({})


function custom_huskar_berserkers_will:GetHealthCost(level)
return self:GetCaster():GetHealth()*self:GetSpecialValueFor("cost")/100
end

function custom_huskar_berserkers_will:OnAbilityPhaseStart()
self:GetCaster():EmitSound("Huskar.Shard_cast2")
return true
end 



function custom_huskar_berserkers_will:OnSpellStart()
if self:GetCaster():GetMaxHealth() == self:GetCaster():GetHealth() then return end

self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_custom_huskar_berserkers_will_shield", {duration = self:GetSpecialValueFor("duration")})
end



modifier_custom_huskar_berserkers_will_shield = class({})
function modifier_custom_huskar_berserkers_will_shield:IsHidden() return false end
function modifier_custom_huskar_berserkers_will_shield:IsPurgable() return false end
function modifier_custom_huskar_berserkers_will_shield:OnCreated(table)
self.max_shield = (self:GetParent():GetMaxHealth() - self:GetParent():GetHealth())*self:GetAbility():GetSpecialValueFor("shield")/100

self.heal_reduce = self:GetAbility():GetSpecialValueFor("heal_reduce")

if not IsServer() then return end

local particle = ParticleManager:CreateParticle("particles/brist_proc.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:ReleaseParticleIndex(particle)

self:GetParent():EmitSound("Huskar.Shard_cast")
self:GetParent():EmitSound("Huskar.Shard_lp")

self.particle = ParticleManager:CreateParticle("particles/huskar/shard_shield.vpcf" , PATTACH_CUSTOMORIGIN, self:GetCaster())
ParticleManager:SetParticleControlEnt( self.particle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetOrigin(), true )
self:AddParticle(self.particle,false,false,-1,false,false)

self:SetStackCount(self.max_shield)

self.RemoveForDuel = true
end

function modifier_custom_huskar_berserkers_will_shield:OnDestroy()
if not IsServer() then return end 

self:GetParent():StopSound("Huskar.Shard_lp")
end 


function modifier_custom_huskar_berserkers_will_shield:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_INCOMING_DAMAGE_CONSTANT,
  MODIFIER_PROPERTY_DISABLE_HEALING,
  MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
  MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
  MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE
}
end


function modifier_custom_huskar_berserkers_will_shield:GetDisableHealing()
--return 1
end

function modifier_custom_huskar_berserkers_will_shield:GetModifierLifestealRegenAmplify_Percentage() 
return self.heal_reduce
end

function modifier_custom_huskar_berserkers_will_shield:GetModifierHealAmplify_PercentageTarget()
return self.heal_reduce
end



function modifier_custom_huskar_berserkers_will_shield:GetModifierHPRegenAmplify_Percentage() 
return self.heal_reduce
end


function modifier_custom_huskar_berserkers_will_shield:GetModifierIncomingDamageConstant( params )

if IsClient() then 
  if params.report_max then 
    return self.max_shield
  else 
    return self:GetStackCount()
  end 
end

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




function modifier_custom_huskar_berserkers_will_shield:GetStatusEffectName()
return "particles/econ/items/effigies/status_fx_effigies/se_effigy_ti6_lvl2.vpcf"
end

function modifier_custom_huskar_berserkers_will_shield:StatusEffectPriority()
return 999999
end