LinkLuaModifier("modifier_antimage_mana_overload_custom_illusion", "abilities/antimage/antimage_mana_overload_custom", LUA_MODIFIER_MOTION_NONE)

antimage_mana_overload_custom = class({})

function antimage_mana_overload_custom:OnInventoryContentsChanged()
    if self:GetCaster():HasScepter() then
        self:SetHidden(false)       
        if not self:IsTrained() then
            self:SetLevel(1)
        end
    else
        self:SetHidden(true)
    end
end

function antimage_mana_overload_custom:OnHeroCalculateStatBonus()
    self:OnInventoryContentsChanged()
end

function antimage_mana_overload_custom:OnSpellStart()
if not IsServer() then return end

local point = self:GetCursorPosition()

local duration = self:GetSpecialValueFor("duration")

local outgoing_damage = self:GetSpecialValueFor("outgoing_damage")

local incoming_damage = self:GetSpecialValueFor("incoming_damage")	

local illusion = CreateIllusions( self:GetCaster(), self:GetCaster(), {duration=duration,outgoing_damage=outgoing_damage,incoming_damage=incoming_damage}, 1, 0, false, false )  

for k, v in pairs(illusion) do
	v.illusion_counter_spell = true
	--v:SetControllableByPlayer(-1, true)
	v.owner = self:GetCaster()
	v.am_scepter = true
	
	v:AddNewModifier(self:GetCaster(), self, "modifier_antimage_mana_overload_custom_illusion", {})

	local direction = (point - v:GetAbsOrigin())
	direction.z = 0
	direction = direction:Normalized()


    for _,mod in pairs(self:GetCaster():FindAllModifiers()) do
       if mod.StackOnIllusion ~= nil and mod.StackOnIllusion == true then
          v:UpgradeIllusion(mod:GetName(), mod:GetStackCount() )
       end
    end
      
	local particle_start = ParticleManager:CreateParticle( "particles/units/heroes/hero_antimage/antimage_blink_start.vpcf", PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( particle_start, 0, v:GetAbsOrigin() )
	ParticleManager:SetParticleControlForward( particle_start, 0, direction:Normalized() )
	ParticleManager:ReleaseParticleIndex( particle_start )
	EmitSoundOnLocationWithCaster( v:GetAbsOrigin(), "Hero_Antimage.Blink_out", v )

	FindClearSpaceForUnit(v, point, true)

	v:StartGesture(ACT_DOTA_CAST_ABILITY_2)

	local particle_end = ParticleManager:CreateParticle( "particles/units/heroes/hero_antimage/antimage_blink_end.vpcf", PATTACH_ABSORIGIN_FOLLOW, v )
	ParticleManager:SetParticleControl( particle_end, 0, v:GetOrigin() )
	ParticleManager:SetParticleControlForward( particle_end, 0, direction:Normalized() )
	ParticleManager:ReleaseParticleIndex( particle_end )
	EmitSoundOnLocationWithCaster( v:GetOrigin(), "Hero_Antimage.Blink_in", v )

	if self:GetCaster():HasModifier("modifier_antimage_blink_2") or self:GetCaster():HasModifier("modifier_antimage_blink_1") then 
		v:AddNewModifier(self:GetCaster(), self, "modifier_antimage_blink_custom_evasion", {duration = self:GetCaster():GetTalentValue("modifier_antimage_blink_1", "duration", true)})
	end


	Timers:CreateTimer(0.1, function()
		v:MoveToPositionAggressive(point)
	end)
end

end






modifier_antimage_mana_overload_custom_illusion = class({})
function modifier_antimage_mana_overload_custom_illusion:IsHidden() return true end
function modifier_antimage_mana_overload_custom_illusion:IsPurgable() return false end
function modifier_antimage_mana_overload_custom_illusion:OnCreated(table)
if not IsServer() then return end

self.ulti = self:GetParent():FindAbilityByName("antimage_mana_void_custom")

if not self.ulti or self.ulti:GetLevel() == 0 then 
	self:Destroy()
	return
end

self.max = self:GetAbility():GetSpecialValueFor("ulti_timer")
self.ready = false

self:StartIntervalThink(self.max)
end

function modifier_antimage_mana_overload_custom_illusion:OnIntervalThink()
if not IsServer() then return end
self.ready = true

self:StartIntervalThink(-1)
end


function modifier_antimage_mana_overload_custom_illusion:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_ATTACK
}
end


function modifier_antimage_mana_overload_custom_illusion:OnAttack(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end
if not params.target:IsHero() and not params.target:IsCreep() then return end
if params.target:IsMagicImmune() then return end
if not self.ulti then return end
if self.ready == false then return end
if not params.target:IsAlive() then return end

self:GetParent():CastAbilityOnTarget(params.target, self.ulti, -1)
self:Destroy()


end