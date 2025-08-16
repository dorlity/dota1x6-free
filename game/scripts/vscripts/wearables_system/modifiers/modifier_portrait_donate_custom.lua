modifier_portrait_donate_custom = class({})
function modifier_portrait_donate_custom:IsHidden() return true end
function modifier_portrait_donate_custom:IsPurgable() return false end
function modifier_portrait_donate_custom:IsPurgeException() return false end
function modifier_portrait_donate_custom:RemoveOnDeath() return false end



function modifier_portrait_donate_custom:OnCreated(table)
self.parent = self:GetParent()
self.parent:AddDeathEvent(self)
end


function modifier_portrait_donate_custom:DeathEvent(params)
    if not IsServer() then return end
    if params.unit ~= self:GetParent() then return end
    if params.attacker == nil then return end
    if not self:GetParent():IsRealHero() then return end
    local unitname = params.attacker:GetUnitName()
    if params.attacker:IsHero() and params.attacker.portrait_custom ~= nil then
        CustomNetTables:SetTableValue("heroes_donate_portraits", "killer_"..self:GetParent():GetPlayerOwnerID(), {heroname = unitname, id = params.attacker:GetPlayerOwnerID()})
    else
        CustomNetTables:SetTableValue("heroes_donate_portraits", "killer_"..self:GetParent():GetPlayerOwnerID(), {})
    end
end