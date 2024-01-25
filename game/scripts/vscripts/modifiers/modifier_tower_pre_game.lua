

modifier_tower_pre_game = class({})


function modifier_tower_pre_game:IsHidden() return true end


function modifier_tower_pre_game:IsPurgable() return false end


function modifier_tower_pre_game:OnCreated(table)
if not IsServer() then return end


self.target = EntIndexToHScript(table.target)
self.radius = 860
self:StartIntervalThink(0.05)
self.tower = towers[self:GetParent():GetTeamNumber()]

local number = tostring(teleports[self:GetParent():GetTeamNumber()]:GetName())
self.wall_particle = {}

for _,wall_point in pairs(wall_points[number]) do

  local count = #self.wall_particle + 1

  self.wall_particle[count] = ParticleManager:CreateParticle("particles/duel_wall.vpcf", PATTACH_WORLDORIGIN, nil)
  ParticleManager:SetParticleControl(self.wall_particle[count], 0, Vector(wall_point[1], wall_point[2], 224))
  ParticleManager:SetParticleControl(self.wall_particle[count], 1, Vector(wall_point[3], wall_point[4], 224))
end

end


function modifier_tower_pre_game:OnDestroy()
if not IsServer() then return end

for _,wall in pairs(self.wall_particle) do
  
  ParticleManager:DestroyParticle(wall, false)
  ParticleManager:ReleaseParticleIndex(wall)
end

end



function modifier_tower_pre_game:OnIntervalThink()
if not IsServer() then return end
if not self.target then return end
if (self:GetParent():GetAbsOrigin() - self.target:GetAbsOrigin()):Length2D() <= self.radius then return end

local dir = (self.target:GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Normalized()

self.point = GetGroundPosition(self:GetParent():GetAbsOrigin() + dir*self.radius*0.9, self.target)


FindClearSpaceForUnit(self.target, self.point, true)
self.target:SetOrigin(self.point)

self.target:EmitSound("Hero_Rattletrap.Power_Cogs_Impact")
self.target:Stop()

local attack_particle = ParticleManager:CreateParticle("particles/duel_stun.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.target)
ParticleManager:SetParticleControlEnt(attack_particle, 1, self.target, PATTACH_POINT_FOLLOW, "attach_hitloc", self.target:GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(attack_particle, 0, self.target, PATTACH_POINT_FOLLOW, "attach_hitloc", self.target:GetAbsOrigin(), true)
ParticleManager:SetParticleControl(attack_particle, 60, Vector(31,82,167))
ParticleManager:SetParticleControl(attack_particle, 61, Vector(1,0,0))

self.target:AddNewModifier(nil, nil, "modifier_stunned", {duration = field_stun})

end
