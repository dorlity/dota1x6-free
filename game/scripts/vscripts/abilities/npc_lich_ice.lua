LinkLuaModifier("modifier_lich_ice_cd", "abilities/npc_lich_ice.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_lich_ice", "abilities/npc_lich_ice.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_lich_ice_resist", "abilities/npc_lich_ice.lua", LUA_MODIFIER_MOTION_NONE)

npc_lich_ice = class({})


function npc_lich_ice:GetCooldown(iLevel)

 return self.BaseClass.GetCooldown(self, iLevel) - (self:GetCaster():GetUpgradeStack("modifier_waveupgrade_boss") - 1)*self:GetSpecialValueFor("cd_inc")
 
end

function npc_lich_ice:OnSpellStart()
if not IsServer() then return end
self:EndCooldown()
  
self.radius = self:GetSpecialValueFor("radius")

self:GetCaster():EmitSound("Lich.Ice_voice")

self:GetCaster():EmitSound("Hero_Lich.IceSpire")

local pilar = CreateUnitByName("npc_lich_ice_unit", self:GetAbsOrigin()+RandomVector(RandomInt(-1, 1)+self.radius), true, nil, nil, DOTA_TEAM_CUSTOM_5)

self:GetCaster():AddNewModifier(pilar, self, "modifier_lich_ice_resist", {})

pilar:AddNewModifier(self:GetCaster(), self, "modifier_lich_ice", {})

pilar:SetBaseMaxHealth(12)
pilar:SetHealth(12)
pilar.owner = self:GetCaster()
  
end


modifier_lich_ice_resist = class({})
function modifier_lich_ice_resist:IsHidden() return true end
function modifier_lich_ice_resist:IsPurgable() return false end
function modifier_lich_ice_resist:GetAttributes() return  MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_lich_ice_resist:GetEffectName() return "particles/units/heroes/hero_lich/lich_frost_armor.vpcf" end
function modifier_lich_ice_resist:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end

function modifier_lich_ice_resist:OnCreated(table)
if not IsServer() then return end

self.particle = ParticleManager:CreateParticle("particles/items_fx/glyph.vpcf" , PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControl(self.particle, 0, self:GetParent():GetAbsOrigin())
ParticleManager:SetParticleControl(self.particle, 1, Vector(170,1,1))
self:AddParticle(self.particle, false, false, -1, false, false)

end


function modifier_lich_ice_resist:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
    MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
    MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
    MODIFIER_EVENT_ON_DEATH,
    MODIFIER_EVENT_ON_ATTACK_LANDED
}
end
function modifier_lich_ice_resist:GetAbsoluteNoDamageMagical() return 1 end

function modifier_lich_ice_resist:GetAbsoluteNoDamagePhysical() return 1 end

function modifier_lich_ice_resist:GetAbsoluteNoDamagePure() return 1 end



function modifier_lich_ice_resist:OnAttackLanded(params)
if not IsServer() then return end
if not params.attacker:IsRealHero() then return end
if self:GetParent() ~= params.target then return end

CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(params.attacker:GetPlayerID()), "CreateIngameErrorMessage", {message = "#lich_invun"})
end


function modifier_lich_ice_resist:OnDeath(params)
if not IsServer() then return end
if self:GetCaster() == params.unit or self:GetCaster().owner == params.unit then 

  self:GetCaster():EmitSound("Hero_Lich.IceSpire.Destroy")
  self:Destroy()

  if self:GetCaster().owner == params.unit then 
      self:GetCaster():Kill(nil,params.attacker)
  end

end


end



modifier_lich_ice = class({})
function modifier_lich_ice:IsHidden() return true end
function modifier_lich_ice:IsPurgable() return false end
function modifier_lich_ice:OnCreated(table)
if not IsServer() then return end

self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_lich/lich_ice_spire.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControl(self.particle, 0, self:GetParent():GetAbsOrigin())
ParticleManager:SetParticleControl(self.particle, 1, self:GetParent():GetAbsOrigin())
ParticleManager:SetParticleControl(self.particle, 2, self:GetParent():GetAbsOrigin())
ParticleManager:SetParticleControl(self.particle, 3, self:GetParent():GetAbsOrigin())
ParticleManager:SetParticleControl(self.particle, 4, self:GetParent():GetAbsOrigin())
ParticleManager:SetParticleControl(self.particle, 5, Vector(550,550,550))  

self:AddParticle(self.particle, false, false, -1, true, false)


local abs = self:GetParent():GetAbsOrigin()
abs.z = abs.z + 400
self.sign = ParticleManager:CreateParticle("particles/generic_gameplay/generic_has_quest.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(self.sign, 0, abs)

self:AddParticle(self.sign, false, false, -1, true, false)

self.hits = 12 
self.health = 12

self:StartIntervalThink(0.2)
end



function modifier_lich_ice:OnIntervalThink()
if not IsServer() then return end

local targets = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, 1200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD  + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_ANY_ORDER, false)
    
for _,target in pairs(targets) do
  AddFOWViewer(target:GetTeamNumber(), self:GetParent():GetAbsOrigin(), 300, 0.2, false)
end

end


function modifier_lich_ice:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
    MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
    MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
    MODIFIER_EVENT_ON_ATTACK_LANDED,
    MODIFIER_EVENT_ON_DEATH
} 
end

function modifier_lich_ice:GetAbsoluteNoDamageMagical() return 1 end

function modifier_lich_ice:GetAbsoluteNoDamagePhysical() return 1 end

function modifier_lich_ice:GetAbsoluteNoDamagePure() return 1 end





function modifier_lich_ice:OnAttackLanded( param )
if not IsServer() then return end
if self:GetParent() ~= param.target then return end

local damage = self.hits/self:GetAbility():GetSpecialValueFor("hits")

if self:GetCaster():GetUpgradeStack("modifier_waveupgrade_boss") == 2 then 
  damage = self.hits/(self:GetAbility():GetSpecialValueFor("hits_inc"))
end

self.health = self.health - damage

if self.health <= 0 then 
  self:GetParent():Kill(nil, param.attacker)
else 
  self:GetParent():SetHealth(self.health)
end

end



function modifier_lich_ice:OnDeath(params)
if not IsServer() then return end
if self:GetParent() ~= params.unit then return end

if not self:GetCaster() or self:GetCaster():IsNull() then return end
if not self:GetAbility() then return end

self:GetAbility():UseResources(false, false, false, true)


self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_lich_ice_cd", {duration = self:GetAbility():GetSpecialValueFor("cd") - (self:GetCaster():GetUpgradeStack("modifier_waveupgrade_boss") - 1)*self:GetAbility():GetSpecialValueFor("cd_inc")})

end





modifier_lich_ice_cd = class({})

function modifier_lich_ice_cd:IsHidden() return false end
function modifier_lich_ice_cd:IsPurgable() return false end