LinkLuaModifier("modifier_item_midas_custom", "abilities/items/item_midas_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_midas_noblue", "abilities/items/item_midas_custom", LUA_MODIFIER_MOTION_NONE)


item_midas_custom = class({})

function item_midas_custom:GetIntrinsicModifierName()
	return "modifier_item_midas_custom"
end

function item_midas_custom:CastFilterResultTarget(target)
  if IsServer() then
    local caster = self:GetCaster()

    if target:GetTeamNumber() == DOTA_TEAM_CUSTOM_5 or target:IsAncient() or my_game:IsPatrol(target:GetUnitName()) then
      return UF_FAIL_OTHER
    end


    return UnitFilter( target, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), self:GetCaster():GetTeamNumber() )
  end
end



function item_midas_custom:OnSpellStart()
if not IsServer() then return end


self:GiveBonuses(self:GetCursorTarget(), false)

self:GetCursorTarget():SetMinimumGoldBounty(self:GetSpecialValueFor("gold"))
self:GetCursorTarget():SetMaximumGoldBounty(self:GetSpecialValueFor("gold"))

if (self:GetCaster():GetQuest() == "General.Quest_5")  then 
    self:GetCaster():UpdateQuest(self:GetSpecialValueFor("gold"))
end

local mod = self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_item_midas_noblue", {duration = 0.1})

self:GetCursorTarget():Kill(self, self:GetCaster())

mod:Destroy()
end



function item_midas_custom:GiveBonuses(target, givegold)
if not IsServer() then return end

local bonus_gold = self:GetSpecialValueFor("gold")

if givegold == true then 


    if (self:GetCaster():GetQuest() == "General.Quest_5")  then 
        self:GetCaster():UpdateQuest(bonus_gold)
    end

    self:GetCaster():ModifyGold(bonus_gold , true , DOTA_ModifyGold_CreepKill)

    SendOverheadEventMessage(self:GetCaster(), 0, self:GetCaster(), bonus_gold, nil)
end

self:GetCaster():EmitSound("DOTA_Item.Hand_Of_Midas")
local item_effect = ParticleManager:CreateParticle( "particles/items2_fx/hand_of_midas.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
ParticleManager:SetParticleControl( item_effect, 0, target:GetAbsOrigin() )
ParticleManager:SetParticleControlEnt(item_effect, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetOrigin(), true )
  
ParticleManager:ReleaseParticleIndex(item_effect)


if givegold == false then 
    local points = 0
    if BluePoints[target:GetUnitName()] then 
        points = BluePoints[target:GetUnitName()]*self:GetSpecialValueFor("blue_creeps")
    end

    my_game:AddBluePoints(self:GetCaster(), points)
else 
    my_game:AddBluePoints(self:GetCaster(), self:GetSpecialValueFor("blue"))
end


end




modifier_item_midas_custom = class({})

function modifier_item_midas_custom:IsHidden() return true end
function modifier_item_midas_custom:IsPurgable() return false end
function modifier_item_midas_custom:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_item_midas_custom:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
        MODIFIER_EVENT_ON_DEATH
    }

    return funcs
end


function modifier_item_midas_custom:GetModifierAttackSpeedBonus_Constant()
    if self:GetAbility() then return self:GetAbility():GetSpecialValueFor("attack_speed") 
    end
end
function modifier_item_midas_custom:GetModifierMoveSpeedBonus_Constant()
    if self:GetAbility() then return self:GetAbility():GetSpecialValueFor("move_speed") 
    end
end


function modifier_item_midas_custom:OnDeath(params)
if not IsServer() then return end
if not self:GetParent():IsRealHero() then return end
if not self:GetAbility() then return end
if self:GetParent():HasModifier("modifier_monkey_king_wukongs_command_custom_soldier") then return end
if self ~= self:GetParent():FindAllModifiersByName(self:GetName())[1] then return end
if not params.unit:IsValidKill(self:GetParent()) then return end
if self:GetParent():IsTempestDouble() then return end

local attacker = params.attacker 

if attacker.owner then 
    attacker = attacker.owner
end 

if ((self:GetParent():GetAbsOrigin() - params.unit:GetAbsOrigin()):Length2D() > self:GetAbility():GetSpecialValueFor("radius")) 
 and attacker ~= self:GetParent() then return end


self:GetAbility():GiveBonuses(params.unit, true)

end


function modifier_item_midas_custom:OnCreated(table)
if not self:GetAbility() then return end 

if self:GetAbility():GetCurrentCharges() > 1 then 
   -- self:GetAbility():SetCurrentCharges(1)
end

end 


modifier_item_midas_noblue = class({})
function modifier_item_midas_noblue:IsHidden() return true end
function modifier_item_midas_noblue:IsPurgable() return false end