

modifier_tower_pre_game = class({})
function modifier_tower_pre_game:IsHidden() return true end
function modifier_tower_pre_game:IsPurgable() return false end


function modifier_tower_pre_game:OnCreated(table)
if not IsServer() then return end
self.parent = self:GetParent()
self.team = self.parent:GetTeamNumber()

self.radius = 860
self.intervak = 0.05

self.wall_particle = {}
local tower_name = self.parent:GetName()
for count = 1,4 do
  local wall_1 = Entities:FindByName(nil, tower_name.."_wall_"..tostring(count).."_1")
  local wall_2 = Entities:FindByName(nil, tower_name.."_wall_"..tostring(count).."_2")
  if wall_1 and wall_2 then
    self.wall_particle[count] = ParticleManager:CreateParticle("particles/duel_wall.vpcf", PATTACH_WORLDORIGIN, nil)
    ParticleManager:SetParticleControl(self.wall_particle[count], 0, wall_1:GetAbsOrigin())
    ParticleManager:SetParticleControl(self.wall_particle[count], 1, wall_2:GetAbsOrigin())
    self:AddParticle( self.wall_particle[count], false, false, -1, false, false  )
  end
end

self:StartIntervalThink(0.05) 
end


function modifier_tower_pre_game:OnIntervalThink()
if not IsServer() then return end

local ids = dota1x6:FindPlayers(self.team)
if not ids then return end

for _,id in pairs(ids) do

  local player = players[id]
  if player and (self.parent:GetAbsOrigin() - player:GetAbsOrigin()):Length2D() > self.radius then

    local dir = (player:GetAbsOrigin() - self.parent:GetAbsOrigin()):Normalized()

    self.point = GetGroundPosition(self.parent:GetAbsOrigin() + dir*self.radius*0.9, player)


    player:SetOrigin(self.point)
    FindClearSpaceForUnit(player, self.point, true)

    player:EmitSound("UI.Walls_hit")
    player:Stop()

    local attack_particle = ParticleManager:CreateParticle("particles/duel_stun.vpcf", PATTACH_ABSORIGIN_FOLLOW, player)
    ParticleManager:SetParticleControlEnt(attack_particle, 1, player, PATTACH_POINT_FOLLOW, "attach_hitloc", player:GetAbsOrigin(), true)
    ParticleManager:SetParticleControlEnt(attack_particle, 0, player, PATTACH_POINT_FOLLOW, "attach_hitloc", player:GetAbsOrigin(), true)
    ParticleManager:SetParticleControl(attack_particle, 60, Vector(31,82,167))
    ParticleManager:SetParticleControl(attack_particle, 61, Vector(1,0,0))
    ParticleManager:ReleaseParticleIndex(attack_particle)

    player:AddNewModifier(nil, nil, "modifier_stunned", {duration = field_stun})
  end

end

end
