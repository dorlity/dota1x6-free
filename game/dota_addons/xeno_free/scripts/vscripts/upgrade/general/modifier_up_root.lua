LinkLuaModifier("modifier_up_root_debuff", "upgrade/general/modifier_up_root", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_up_root_cd", "upgrade/general/modifier_up_root", LUA_MODIFIER_MOTION_NONE)


modifier_up_root = class({})

modifier_up_root.root_cd = 15
modifier_up_root.root_duration = {1, 1.5, 2}


function modifier_up_root:IsHidden() return true end
function modifier_up_root:IsPurgable() return false end
function modifier_up_root:RemoveOnDeath() return false end

function modifier_up_root:DeclareFunctions()
return {

        MODIFIER_EVENT_ON_ATTACK_LANDED,
} end



function modifier_up_root:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_up_root:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
end



function modifier_up_root:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end
if not params.target:IsHero() and not params.target:IsCreep() then return end
if self:GetParent():HasModifier("modifier_up_root_cd") then return end
if params.target:IsMagicImmune() then return end
if not self:GetParent():IsAlive() then return end
if params.target:IsDebuffImmune() then return end

local duration = self.root_duration[self:GetStackCount()]*(1 - params.target:GetStatusResistance())
params.target:AddNewModifier(self:GetParent(), nil, "modifier_up_root_debuff", {duration = duration})

self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_up_root_cd", {duration = self.root_cd})
end
  

modifier_up_root_debuff = class({})

function modifier_up_root_debuff:GetEffectName()
  return "particles/units/heroes/hero_troll_warlord/troll_warlord_bersekers_net.vpcf"
end

function modifier_up_root_debuff:CheckState()
  return {[MODIFIER_STATE_ROOTED] = true}
end


function modifier_up_root_debuff:IsHidden() return true end
function modifier_up_root_debuff:IsPurgable() return true end


function modifier_up_root_debuff:OnCreated(table)
if not IsServer() then return end
self:GetParent():EmitSound("n_creep_TrollWarlord.Ensnare")

end

modifier_up_root_cd = class({})
function modifier_up_root_cd:IsHidden() return false end
function modifier_up_root_cd:GetTexture() return "meepo_earthbind" end
function modifier_up_root_cd:IsPurgable() return false end
function modifier_up_root_cd:RemoveOnDeath() return false end
function modifier_up_root_cd:IsDebuff() return true end
function modifier_up_root_cd:OnCreated(table)
if not IsServer() then return end

self.RemoveForDuel = true
end