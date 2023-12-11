LinkLuaModifier("modifier_haste_zone_thinker_buff", "modifiers/modifier_haste_zone_thinker", LUA_MODIFIER_MOTION_NONE)


modifier_haste_zone_thinker = class({})

function modifier_haste_zone_thinker:IsHidden() return false end


function modifier_haste_zone_thinker:CheckState()
return 
{
  [MODIFIER_STATE_UNSELECTABLE] = true,
  [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
  [MODIFIER_STATE_OUT_OF_GAME] = true,
  [MODIFIER_STATE_INVULNERABLE] = true,
  [MODIFIER_STATE_NO_HEALTH_BAR] = true,
  [MODIFIER_STATE_NOT_ON_MINIMAP_FOR_ENEMIES] = true,
}
end




function modifier_haste_zone_thinker:OnCreated(table)
if not IsServer() then return end 

local pos = GetGroundPosition(self:GetParent():GetAbsOrigin(), nil)
pos.z = pos.z + 60

self.radius = 300


local ring_fx = ParticleManager:CreateParticle("particles/shrine/haste_zone.vpcf", PATTACH_WORLDORIGIN, nil)

ParticleManager:SetParticleControl(ring_fx, 0, pos)
ParticleManager:SetParticleControl(ring_fx, 3, Vector(220,0, 0))
ParticleManager:SetParticleControl(ring_fx, 9, Vector(self.radius, 0, 0))
self:AddParticle(ring_fx, false, false, -1, false, false)

self:StartIntervalThink(0.1)
end




function modifier_haste_zone_thinker:OnIntervalThink()
if not IsServer() then return end 

local targets = FindUnitsInRadius(DOTA_TEAM_NEUTRALS, self:GetParent():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)

for _,hero in pairs(targets) do 
    hero:AddNewModifier(hero, nil, "modifier_haste_zone_thinker_buff", {duration = 15, thinker = self:GetParent():entindex()})
end 


end 





modifier_haste_zone_thinker_buff = class({})
function modifier_haste_zone_thinker_buff:IsHidden() return false end
function modifier_haste_zone_thinker_buff:IsPurgable() return true end
function modifier_haste_zone_thinker_buff:GetTexture() return "rune_haste" end
function modifier_haste_zone_thinker_buff:GetEffectName()
return "particles/generic_gameplay/rune_haste_owner.vpcf"
end

function modifier_haste_zone_thinker_buff:OnCreated(table)
if not IsServer() then return end
self:GetParent():EmitSound("Alch.Rune_haste")
self.RemoveForDuel = true

self.thinker = EntIndexToHScript(table.thinker)
end




function modifier_haste_zone_thinker_buff:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
  MODIFIER_EVENT_ON_TAKEDAMAGE
}
end

function modifier_haste_zone_thinker_buff:GetModifierMoveSpeedBonus_Percentage()
return 30
end


function modifier_haste_zone_thinker_buff:OnTakeDamage(params)
if not IsServer() then return end 
if params.unit ~= self:GetParent() then return end 
if self:GetParent() == params.attacker then return end 
if (self.thinker and (self.thinker:GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D() <= 300) then return end 


self:Destroy()
end 


