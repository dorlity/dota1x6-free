LinkLuaModifier("modifier_custom_phantom_assassin_fan_of_knives_thinker", "abilities/phantom_assassin/custom_phantom_assassin_fan_of_knives", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_phantom_assassin_fan_of_knives", "abilities/phantom_assassin/custom_phantom_assassin_fan_of_knives", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_phantom_assassin_fan_of_damage", "abilities/phantom_assassin/custom_phantom_assassin_fan_of_knives", LUA_MODIFIER_MOTION_NONE)


custom_phantom_assassin_fan_of_knives              = class({})


function custom_phantom_assassin_fan_of_knives:GetAbilityTextureName()
  if self:GetCaster():HasModifier("modifier_phantom_assassin_persona_custom") then
    return "phantom_assassin/persona/phantom_assassin_fan_of_knives_persona1"
  end
  return "phantom_assassin_fan_of_knives"
end



function custom_phantom_assassin_fan_of_knives:GetAOERadius() 
return self:GetSpecialValueFor("radius")
end

function custom_phantom_assassin_fan_of_knives:OnInventoryContentsChanged()
    if self:GetCaster():HasScepter() then
        self:SetHidden(false)   
        if not self:IsTrained() then      
          self:SetLevel(1)
        end
    else
        self:SetHidden(true)

    end
end

function custom_phantom_assassin_fan_of_knives:OnHeroCalculateStatBonus()
    self:OnInventoryContentsChanged()
end


function custom_phantom_assassin_fan_of_knives:Precache(context)

PrecacheResource( "particle", "particles/units/heroes/hero_phantom_assassin/phantom_assassin_shard_fan_of_knives.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_phantom_assassin/phantom_assassin_shard_fan_of_knives_dot.vpcf", context )

end





function custom_phantom_assassin_fan_of_knives:OnSpellStart()

self.caster = self:GetCaster()
self.radius         = self:GetSpecialValueFor("radius") 
self.projectile_speed   = self:GetSpecialValueFor("projectile_speed")
self.location = self:GetCaster():GetAbsOrigin()
self.duration       = self.radius / self.projectile_speed
local ability = self:GetCaster():FindAbilityByName("custom_phantom_assassin_coup_de_grace")

if not IsServer() then return end

if ability and ability:IsTrained() then 
  self:GetCaster():AddNewModifier(self:GetCaster(), ability, "modifier_phantom_assassin_phantom_coup_de_grace_focus",  {duration = ability:GetSpecialValueFor("duration")})
end 

self:GetCaster():EmitSound("Hero_PhantomAssassin.FanOfKnives.Cast")


CreateModifierThinker(self.caster, self, "modifier_custom_phantom_assassin_fan_of_knives_thinker", {duration = self.duration}, self.location, self.caster:GetTeamNumber(), false)

end



modifier_custom_phantom_assassin_fan_of_knives_thinker = class({})


function modifier_custom_phantom_assassin_fan_of_knives_thinker:OnCreated()
  self.ability  = self:GetAbility()
  self.caster   = self:GetCaster()
  self.parent   = self:GetParent()
  

  self.radius         = self.ability:GetSpecialValueFor("radius")
  if not IsServer() then return end
  
  local start_effect = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_shard_fan_of_knives.vpcf"
  if self:GetCaster():HasModifier("modifier_phantom_assassin_persona_custom") then
    start_effect = "particles/units/heroes/hero_phantom_assassin_persona/pa_persona_shard_fan_of_knives.vpcf"
  end
  self.particle = ParticleManager:CreateParticle(start_effect, PATTACH_ABSORIGIN, self.parent)
  ParticleManager:SetParticleControl(self.particle, 0, self:GetParent():GetAbsOrigin())
  ParticleManager:SetParticleControl(self.particle, 3, self:GetParent():GetAbsOrigin())
  self:AddParticle(self.particle, false, false, -1, false, false)
  
  self.hit_enemies = {}
  
  self:StartIntervalThink(FrameTime())
end

function modifier_custom_phantom_assassin_fan_of_knives_thinker:OnIntervalThink()
  if not IsServer() then return end

  local radius_pct = math.min((self:GetDuration() - self:GetRemainingTime()) / self:GetDuration(), 1)
  
  local enemies = FindUnitsInRadius(self.parent:GetTeamNumber(), self.parent:GetAbsOrigin(), nil, self.radius * radius_pct, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
  
  for _, enemy in pairs(enemies) do
  
    local hit_already = false
  
    for _, hit_enemy in pairs(self.hit_enemies) do
      if hit_enemy == enemy then
        hit_already = true
        break
      end
    end

    if not hit_already then
      
      local damage = enemy:GetMaxHealth()*self:GetAbility():GetSpecialValueFor("damage")/100
    
      if enemy:IsCreep() then 
        damage = damage/self:GetAbility():GetSpecialValueFor("damage_creeps")
      end

      local duration = self:GetAbility():GetSpecialValueFor("duration")*(1 - enemy:GetStatusResistance())
      enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_phantom_assassin_fan_of_knives", {duration = duration})

      enemy:EmitSound("Hero_PhantomAssassin.Attack")

      table.insert(self.hit_enemies, enemy)
      
      local real_damage = ApplyDamage({victim = enemy, attacker = self:GetCaster(), damage = damage, ability = self:GetAbility(), damage_type = DAMAGE_TYPE_PURE})

      enemy:SendNumber(4, real_damage)
    end

  end

end


modifier_custom_phantom_assassin_fan_of_knives = class({})
function modifier_custom_phantom_assassin_fan_of_knives:IsHidden() return false end
function modifier_custom_phantom_assassin_fan_of_knives:IsPurgable() return true end
function modifier_custom_phantom_assassin_fan_of_knives:CheckState() return {[MODIFIER_STATE_PASSIVES_DISABLED] = true} end
function modifier_custom_phantom_assassin_fan_of_knives:OnCreated()
  if not IsServer() then return end
  local particle_name = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_shard_fan_of_knives_dot.vpcf"
  if self:GetCaster():HasModifier("modifier_phantom_assassin_persona_custom") then
    particle_name = "particles/units/heroes/hero_phantom_assassin_persona/pa_persona_shard_fan_of_knives_debuff.vpcf"
  end
  local particle = ParticleManager:CreateParticle(particle_name, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
  self:AddParticle(particle, false, false, -1, false, false)
end