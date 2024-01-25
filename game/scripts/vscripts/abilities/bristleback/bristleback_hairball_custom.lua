

bristleback_hairball_custom              = class({})

function bristleback_hairball_custom:GetAOERadius() 
return self:GetSpecialValueFor("radius")
end

function bristleback_hairball_custom:OnInventoryContentsChanged()
if self:GetCaster():HasShard() then
    self:SetHidden(false)   
    if not self:IsTrained() then      
      self:SetLevel(1)
    end
else
  self:SetHidden(true)
end

end

function bristleback_hairball_custom:OnHeroCalculateStatBonus()
  self:OnInventoryContentsChanged()
end

function bristleback_hairball_custom:OnSpellStart()

self:GetCaster():EmitSound("Hero_Bristleback.Hairball.Cast")

local projectile =
{
  Ability              = self,
  EffectName           = "particles/units/heroes/hero_bristleback/bristleback_hairball.vpcf",
  vSpawnOrigin        = self:GetCaster():GetAttachmentOrigin(self:GetCaster():ScriptLookupAttachment("attach_hitloc")),
  fDistance            = (self:GetCursorPosition() - self:GetCaster():GetAbsOrigin()):Length2D(),
  fStartRadius        = 0,
  fEndRadius            = 0,
  Source                = self:GetCaster(),
  bHasFrontalCone        = false,
  bReplaceExisting    = false,
  iUnitTargetTeam        = DOTA_UNIT_TARGET_TEAM_NONE,
  iUnitTargetFlags    = DOTA_UNIT_TARGET_FLAG_NONE,
  iUnitTargetType        = DOTA_UNIT_TARGET_NONE,
  fExpireTime         = GameRules:GetGameTime() + 5.0,
  bDeleteOnHit        = false,
  vVelocity            = (self:GetCursorPosition() - self:GetCaster():GetAbsOrigin()):Normalized()*self:GetSpecialValueFor("projectile_speed")*(Vector(1,1,0)),
  bProvidesVision        = false,
}
ProjectileManager:CreateLinearProjectile(projectile)

end


function bristleback_hairball_custom:OnProjectileHit(hTarget, vLocation)
if not IsServer() then return end

local spray = self:GetCaster():FindAbilityByName("bristleback_quill_spray_custom")


AddFOWViewer(self:GetCaster():GetTeamNumber(), vLocation, self:GetSpecialValueFor("radius"), 2, false)

self:AddGoo(vLocation)

Timers:CreateTimer(0.15, function()
    self:AddGoo(vLocation)
end)

if spray and spray:IsTrained() then 
  spray:MakeSpray(GetGroundPosition(vLocation, nil))
end

end


function bristleback_hairball_custom:AddGoo(vLocation)

local goo = self:GetCaster():FindAbilityByName("bristleback_viscous_nasal_goo_custom")
if goo and goo:IsTrained() then 

  goo:OnSpellStart(nil, vLocation)

end

end