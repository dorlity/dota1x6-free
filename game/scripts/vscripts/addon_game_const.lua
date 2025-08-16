
if addon_game_const == nil then
    _G.addon_game_const = class({})
end


_G.icon_hero_width =
{
    ["npc_dota_hero_templar_assassin"] = {0.9, 1},
    ["npc_dota_hero_pudge"] = {0.9, 1},
    ["npc_dota_hero_mars"] = {0.95, 1},
    ["npc_dota_hero_ogre_magi"] = {1, 0.9},
    ["npc_dota_hero_drow_ranger"] = {0.9, 1},
    ["npc_dota_hero_antimage"] = {0.9, 1},
    ["npc_dota_hero_ember_spirit"] = {0.94, 1},
    ["npc_dota_hero_monkey_king"] = {0.9, 1},
    ["npc_dota_hero_nevermore"] = {0.9, 1},
    ["npc_dota_hero_terrorblade"] = {0.9, 1},
    ["npc_dota_hero_crystal_maiden"] = {1, 0.94},
    ["npc_dota_hero_skywrath_mage"] = {0.95, 1},
    ["npc_dota_hero_zuus"] = {0.95, 1},
    ["npc_dota_hero_invoker"] = {1, 0.95},
    ["npc_dota_hero_marci"] = {0.9, 1},
    ["npc_dota_hero_sand_king"] = {0.95, 1},
    ["npc_dota_hero_enigma"] = {0.8, 1},
    ["npc_dota_hero_bane"] = {0.85, 1},
    ["npc_dota_hero_life_stealer"] = {0.9, 1},
    ["npc_dota_hero_tinker"] = {0.95, 1},

}

_G.icon_hero_id =
{
    ["npc_dota_hero_juggernaut"] = 23,
    ["npc_dota_hero_phantom_assassin"] = 79,
    ["npc_dota_hero_huskar"] = 22,
    ["npc_dota_hero_nevermore"] = 33,
    ["npc_dota_hero_queenofpain"] = 39,
    ["npc_dota_hero_legion_commander"] = 106,
    ["npc_dota_hero_bristleback"] = 101,
    ["npc_dota_hero_terrorblade"] = 108,
    ["npc_dota_hero_puck"] = 36,
    ["npc_dota_hero_void_spirit"] = 138,
    ["npc_dota_hero_ember_spirit"] = 105,
    ["npc_dota_hero_pudge"] = 37,
    ["npc_dota_hero_hoodwink"] = 148,
    ["npc_dota_hero_skeleton_king"] = 46,
    ["npc_dota_hero_lina"] = 28,
    ["npc_dota_hero_troll_warlord"] = 99,
    ["npc_dota_hero_axe"] = 0,
    ["npc_dota_hero_alchemist"] = 15,
    ["npc_dota_hero_ogre_magi"] = 82,
    ["npc_dota_hero_antimage"] = 1,
    ["npc_dota_hero_primal_beast"] = 157,
    ["npc_dota_hero_marci"] = 156,
    ["npc_dota_hero_templar_assassin"] = 89,
    ["npc_dota_hero_bloodseeker"] = 6,
    ["npc_dota_hero_monkey_king"] = 113,
    ["npc_dota_hero_mars"] = 133,
    ["npc_dota_hero_zuus"] = 65,
    ["npc_dota_hero_leshrac"] = 25,
    ["npc_dota_hero_crystal_maiden"] = 2,
    ["npc_dota_hero_snapfire"] = 137,
    ["npc_dota_hero_sven"] = 52,
    ["npc_dota_hero_sniper"] = 48,
    ["npc_dota_hero_muerta"] = 158,
    ["npc_dota_hero_pangolier"] = 117,
    ["npc_dota_hero_arc_warden"] = 115,
    ["npc_dota_hero_invoker"] = 66,
    ["npc_dota_hero_razor"] = 41,
    ["npc_dota_hero_sand_king"] = 43,
    ["npc_dota_hero_furion"] = 21,
    ["npc_dota_hero_abaddon"] = 104,
    ["npc_dota_hero_drow_ranger"] = 16,
    ["npc_dota_hero_skywrath_mage"] = 102,
    ["npc_dota_hero_slark"] = 96,
    ["npc_dota_hero_centaur"] = 95,
    ["npc_dota_hero_enigma"] = 19,
    ["npc_dota_hero_bane"] = 69,
    ["npc_dota_hero_morphling"] = 31,
    ["npc_dota_hero_life_stealer"] = 27,
    ["npc_dota_hero_tinker"] = 54,
}

--particles/hero_capture_icon/hero_capture_icon.vpcf

_G.Not_spell_damage = 
{
    ["templar_assassin_psi_blades_custom"] = true,
}


_G.start_abilities =
{
    "ogre_magi_dumb_luck_custom",

}

_G.rating_thresh =
{
    ["ranked_0-500_start"] =
    {
        ['min'] = 0,
        ['max'] = 500,
    },
    ["ranked_500-1000"] = 
    {
        ['min'] = 500,
        ['max'] = 1000,
    },
    ["ranked_1000-x"] = 
    {
        ['min'] = 1000,
        ['max'] = 99999,
    },
}

_G.ranked_tier =
{
    0,150,300,500,750,1000,1300,9999999
}




_G.NonRecordItems = 
{
    ["item_clarity"] = true,
    ["item_faerie_fire"] = true,
    ["item_smoke_of_deceit"] = true,
    ["item_ward_observer"] = true,
    ["item_ward_sentry"] = true,
    ["item_enchanted_mango"] = true,
    ["item_flask"] = true,
    ["item_tango"] = true,
    ["item_blood_grenade"] = true,
    ["item_dust"] = true,
    ["item_bottle"] = true,
    ["item_purple_upgrade_shop"] = true,
    ["item_patrol_trap"] = true,
    ["item_branches"] = true,
    ["item_gauntlets"] = true,
    ["item_slippers"] = true,
    ["item_mantle"] = true,
    ["item_circlet"] = true,
    ["item_belt_of_strength"] = true,
    ["item_boots_of_elves"] = true,
    ["item_robe"] = true,
    ["item_crown"] = true,
    ["item_ogre_axe"] = true,
    ["item_blade_of_alacrity"] = true,
    ["item_staff_of_wizardry"] = true,
    ["item_diadem"] = true,
    ["item_ring_of_protection"] = true,
    ["item_infused_raindrop"] = true,
    ["item_blades_of_attack"] = true,
    ["item_gloves"] = true,
    ["item_chainmail"] = true,
    ["item_quarterstaff"] = true,
    ["item_helm_of_iron_will"] = true,
    ["item_broadsword"] = true,
    ["item_blitz_knuckles"] = true,
    ["item_javelin"] = true,
    ["item_claymore"] = true,
    ["item_mithril_hammer"] = true,
    ["item_ring_of_regen"] = true,
    ["item_sobi_mask"] = true,
    ["item_fluffy_hat"] = true,
    ["item_wind_lace"] = true,
    ["item_cloak"] = true,
    ["item_boots"] = true,
    ["item_lifesteal"] = true,
    ["item_voodoo_mask"] = true,
    ["item_magic_stick"] = true,
    ["item_buckler"] = true,
    ["item_ring_of_basilius"] = true,
    ["item_headdress"] = true,
    ["item_ring_of_health"] = true,
    ["item_void_stone"] = true,
    ["item_cornucopia"] = true,
    ["item_energy_booster"] = true,
    ["item_vitality_booster"] = true,
    ["item_point_booster"] = true,
    ["item_talisman_of_evasion"] = true,
    ["item_platemail"] = true,
    ["item_hyperstone"] = true,
    ["item_ultimate_orb"] = true,
    ["item_demon_edge"] = true,
    ["item_mystic_staff"] = true,
    ["item_reaver"] = true,
    ["item_eagle"] = true,
    ["item_relic"] = true,
    ["item_patrol_warp_amulet"] = true,
    ["item_patrol_restrained_orb"] = true,
    ["item_patrol_midas"] = true,
    ["item_patrol_vision"] = true,
    ["item_patrol_fortifier"] = true,
    ["item_patrol_razor"] = true,
    ["item_gray_upgrade"] = true,
    ["item_ultimate_scepter"] = true,
    ["item_oblivion_staff"] = true,
    ["item_patrol_reward_1"] = true,
    ["item_tiara_of_selemene"] = true,
    ["item_soul_booster"] = true,
    ["item_muerta_shovel_custom"] = true,
    ["item_ring_of_tarrasque"] = true,
    ["item_patrol_reward_2"] = true,
    ["item_pers"] = true,
    ["item_blue_upgrade"] = true,
    ["item_purple_upgrade"] = true,
    ["item_essence_of_speed"] = true,
    ["item_legendary_upgrade"] = true,
    ["item_gray_upgrade"] = true,
    ["item_travel_boots_2_custom"] = true,
}


_G.DeleteAbilities = 
{
    "custom_ability_smoke",
    "custom_ability_observer",
    "custom_ability_sentry",
    "custom_ability_dust",
    "ability_capture",
    "abyssal_underlord_portal_warp",
    "ability_lamp_use",
    "ability_pluck_famango",
}






_G.TopDonat =
{
    ["1168402705"] = "particles/econ/events/ti9/ti9_emblem_effect.vpcf",
    ["1596359337"] = "particles/econ/events/ti7/ti7_hero_effect.vpcf",
    ["128920224"] = "particles/econ/events/ti9/ti9_emblem_effect.vpcf",
    ["172784619"] = "particles/econ/events/ti9/ti9_emblem_effect.vpcf",
    ["244395427"] = "particles/econ/events/ti9/ti9_emblem_effect.vpcf",
}


_G.PassiveAbilities = 
{

}


_G.UnvalidAbilities = 
{
    ["mid_teleport"] = true,
    ["custom_ability_observer"] = true,
    ["custom_ability_sentry"] = true,
    ["custom_ability_smoke"] = true,
    ["custom_ability_dust"] = true,
    ["custom_ability_grenade"] = true,
    ["invoker_exort_custom"] = true,
    ["invoker_wex_custom"] = true,
    ["invoker_quas_custom"] = true,
    ["invoker_invoke_custom"] = true,
    ["hoodwink_sharpshooter_release_custom"] = true,
    ["marci_summon_dragon_knight"] = true,
    ["marci_summon_mirana"] = true,
    ["marci_summon_luna"] = true,
    ["high_five_custom"] = true,
    ["skywrath_mage_mystic_flare_custom_legendary"] = true,
    ["primal_beast_charge_custom"] = true,
    ["custom_puck_illusory_barrier"] = true,
    ["morphling_morph_replicate_custom"] = true,
    ["templar_assassin_trap_custom"] = true,
    ["bane_nightmare_end_custom"] = true,
    ["alchemist_acid_spray_mixing"] = true
}


_G.Recast_mods =
{
    ["item_mask_of_madness_custom"] = "modifier_item_mask_of_madness_custom_speed"
}

_G.UnvalidItems = 
{
    ["item_soul_ring_custom"] = true,
    ["item_bracer_custom"] = true,
    ["item_wraith_band_custom"] = true,
    ["item_null_talisman_custom"] = true,
    ["item_power_treads"] = true,
    ["item_phase_boots"] = true,
    ["item_branches"] = true,
    ["item_quelling_blade"] = true,
    ["item_radiance_custom"] = true,
    ["item_bfury"] = true,
    ["item_vambrace"] = true,   
    ["item_havoc_hammer"] = true,
    ["item_moon_shard"] = true,
    ["item_bottle"] = true,
    ["item_tpscroll_custom"] = true
}


_G.NoCdItems = 
{
    ["item_aeon_disk"] = true,
    ["item_midas_custom"] = true,
    ["item_phylactery_custom"] = true,
    ["item_manaflare_lens_custom"] = true,
    ["item_ultimate_scepter"] = true,
    ["item_tranquil_boots_custom"] = true,
    ["item_falcon_blade_custom"] = true,
    ["item_basher"] = true,
    ["item_basher_custom"] = true
}

_G.custom_voice = 
{
    ["npc_dota_hero_juggernaut"] = true,
    ["npc_dota_hero_phantom_assassin"] = true,
    ["npc_dota_hero_legion_commander"] = true,
    ["npc_dota_hero_nevermore"] = true,
    ["npc_dota_hero_razor"] = true,
    ["npc_dota_hero_queenofpain"] = true,
    ["npc_dota_hero_skeleton_king"] = true,
    ["npc_dota_hero_monkey_king"] = true,
    ["npc_dota_hero_zuus"] = true,
    ["npc_dota_hero_pudge"] = true,
    ["npc_dota_hero_drow_ranger"] = true,
    ["npc_dota_hero_skywrath_mage"] = true,
    ["npc_dota_hero_antimage"] = true,
    ["npc_dota_hero_axe"] = true,
    ["npc_dota_hero_ogre_magi"] = true,
    ["npc_dota_hero_invoker"] = true,
    ["npc_dota_hero_crystal_maiden"] = true,
    ["npc_dota_hero_terrorblade"] = true,
}

_G.new_talent_system =
{
    ["npc_dota_hero_skeleton_king"] = 1,
    ["npc_dota_hero_zuus"] = 1,
    ["npc_dota_hero_morphling"] = 1,
    ["npc_dota_hero_abaddon"] = 1,
    ["npc_dota_hero_alchemist"] = 1,
    ["npc_dota_hero_antimage"] = 1,
    ["npc_dota_hero_life_stealer"] = 1,
    ["npc_dota_hero_arc_warden"] = 1,
    ["npc_dota_hero_axe"] = 1,
    ["npc_dota_hero_bane"] = 1,
    ["npc_dota_hero_tinker"] = 1,
}



_G.attack_mods = 
{
    ["general"] =
    {
        ["item_manta_custom_illusion"] = "",
    },
    ["npc_dota_hero_phantom_assassin"] = 
    {
        ["modifier_custom_phantom_assassin_stifling_dagger_attack"] = "",
        ["modifier_phantom_assassin_phantom_strike_legendary_illusion"] = "modifier_phantom_assassin_blink_7",
    },
    ["npc_dota_hero_ember_spirit"] = 
    {
        ["modifier_ember_spirit_sleight_of_fist_custom_damage"] = "",
    },
    ["npc_dota_hero_bristleback"] = 
    {
        ["modifier_custom_bristleback_warpath_legendary_crit"] = "",
    },
    ["npc_dota_hero_juggernaut"] = 
    {
        ["modifier_custom_juggernaut_omnislash_attacks_damage"] = "modifier_juggernaut_omnislash_3",
        ["modifier_custom_juggernaut_omnislash"] = "",
    },
    ["npc_dota_hero_legion_commander"] = 
    {
        ["modifier_moment_of_courage_custom_no_trigger"] = "",
    },
    ["npc_dota_hero_monkey_king"] = 
    {
        ["modifier_monkey_king_boundless_strike_custom_crit"] = "",
        ["modifier_monkey_king_wukongs_command_custom_soldier"] = "",
    },
    ["npc_dota_hero_sven"] = 
    {
        ["modifier_sven_gods_strength_custom_crit"] = "",
        ["modifier_sven_great_cleave_custom_legendary"] = "",
    },
    ["npc_dota_hero_terrorblade"] = 
    {
        ["modifier_terrorblade_conjureimage"] = "",
        ["modifier_custom_terrorblade_reflection_unit"] = "",
        ["modifier_conjure_image_custom_illusion_basic"] = "",
    },
    ["npc_dota_hero_void_spirit"] = 
    {
        ["modifier_void_spirit_astral_step_attack"] = "",
        ["modifier_custom_void_remnant_legendary_caster"] = "void_spirit_aether_remnant_custom_legendary",
    },
    ["npc_dota_hero_skeleton_king"] = 
    {
        ["modifier_skeleton_king_vampiric_aura_custom_skeleton_ai"] = "",
    },
    ["npc_dota_hero_furion"] = 
    {
        ["modifier_furion_force_of_nature_custom"] = "",
    },
    ["npc_dota_hero_mars"] = 
    {
        ["modifier_mars_gods_rebuke_custom"] = "",
        ["modifier_mars_bulwark_custom_soldier"] = "modifier_mars_bulwark_4",
    },
    ["npc_dota_hero_pangolier"] = 
    {
        ["modifier_pangolier_swashbuckle_custom_attacks"] = "",
        ["modifier_pangolier_shield_crash_custom_scepter"] = "pangolier_swashbuckle_custom",    
        ["modifier_pangolier_gyroshell_custom_attack"] = "modifier_pangolier_rolling_1",
        ["modifier_pangolier_swashbuckle_custom_scepter"] = "",
        ["modifier_pangolier_innate_custom_damage"] = "",
    },
    ["npc_dota_hero_hoodwink"] = 
    {
        ["modifier_hoodwink_acorn_shot_custom"] = "",
    },
    ["npc_dota_hero_invoker"] = 
    {
        ["modifier_forged_spirit_melting_strike_custom_range"] = "",
    },
    ["npc_dota_hero_marci"] = 
    {
        ["modifier_marci_dispose_custom_attacks_caster"] = "",
        ["modifier_marci_summon_tracker"] = "",
    },
    ["npc_dota_hero_sand_king"] = 
    {
        ["modifier_sandking_burrowstrike_custom_legendary"] = "",
        ["modifier_sandking_scorpion_strike_custom_damage"] = "",
    },
    ["npc_dota_hero_razor"] = 
    {
        ["modifier_razor_static_link_custom_attacking"] = "",
        ["modifier_razor_static_link_custom_legendary"] = "modifier_razor_link_7",
        ["modifier_razor_eye_of_the_storm_custom_attack_proc"] = "modifier_razor_eye_4",
    },
    ["npc_dota_hero_abaddon"] = 
    {
        ["modifier_abaddon_frostmourne_custom_illusion"] = "modifier_abaddon_curse_3",
        ["modifier_abaddon_death_coil_custom_shard_proc"] = "shard"
    },
    ["npc_dota_hero_antimage"] = 
    {
        ["modifier_antimage_blink_custom_illusion"] = "modifier_antimage_blink_3",
    },
    ["npc_dota_hero_sniper"] = 
    {
        ["modifier_sniper_take_aim_custom_legendary_illusion"] = "modifier_sniper_aim_7",
    },
    ["npc_dota_hero_arc_warden"] = 
    {
        ["modifier_arc_warden_magnetic_field_custom_legendary_illusion"] = "modifier_arc_warden_field_7",
        ["modifier_arc_warden_tempest_double_custom"] = "",
    },
    ["npc_dota_hero_muerta"] = 
    {
        
    },
    ["npc_dota_hero_drow_ranger"] = 
    {
        ["modifier_drow_ranger_frost_arrows_custom_attack_damage"] = "modifier_drow_frost_4",
        ["modifier_drow_ranger_wave_of_silence_custom_legendary_illusion"] = "drow_ranger_wave_of_silence_custom_legendary",
    },
    ["npc_dota_hero_slark"] = 
    {
        ["modifier_slark_pounce_custom_attacks_damage"] = "modifier_slark_pounce_1",
        ["modifier_slark_essence_shift_custom_double_attack"] = "modifier_slark_essence_4",
    },
    ["npc_dota_hero_centaur"] = 
    {
        ["modifier_centaur_stampede_custom_distance_hit"] = "modifier_centaur_stampede_4",
    },
    ["npc_dota_hero_lina"] = 
    {
        ["modifier_lina_fiery_soul_custom_legendary_attacks_caster"] = "modifier_lina_soul_legendary",
    },
    ["npc_dota_hero_enigma"] = 
    {
        ["modifier_enigma_demonic_conversion_custom"] = "",
    },
    ["npc_dota_hero_troll_warlord"] = 
    {
        ["modifier_troll_warlord_berserkers_rage_custom_proc_damage"] = "modifier_troll_rage_4",    
    },
    ["npc_dota_hero_bane"] = 
    {
        ["modifier_bane_nightmare_custom_attack"] = "modifier_bane_nightmare_3",
    },
    ["npc_dota_hero_zuus"] =
    {
        ["modifier_zuus_heavenly_jump_custom_attacks_caster"] = "modifier_zuus_jump_1",
    },
    ["npc_dota_hero_morphling"] = 
    {
        ["modifier_morphling_waveform_custom_damage"] = "",
        ["modifier_morphling_morph_custom_double_damage"] = "modifier_morphling_attribute_3"
    },
    ["npc_dota_hero_life_stealer"] =
    {
        ["modifier_life_stealer_infest_custom"] = "",
        ["modifier_life_stealer_ghoul_frenzy_custom_double_damage"] = "modifier_lifestealer_ghoul_3",
    },
    ["npc_dota_hero_axe"] = 
    {
        ["modifier_axe_culling_blade_custom_legendary_attacks"] = "modifier_axe_culling_legendary"
    }
}


_G.all_heroes = 
{
    "npc_dota_hero_juggernaut",
    "npc_dota_hero_phantom_assassin",
    "npc_dota_hero_huskar",
    "npc_dota_hero_nevermore",
    "npc_dota_hero_queenofpain",
    "npc_dota_hero_legion_commander",
    "npc_dota_hero_bristleback",
    "npc_dota_hero_terrorblade",
    "npc_dota_hero_puck",
    "npc_dota_hero_void_spirit",
    "npc_dota_hero_ember_spirit",
    "npc_dota_hero_pudge",
    "npc_dota_hero_hoodwink",
    "npc_dota_hero_skeleton_king",
    "npc_dota_hero_lina",
    "npc_dota_hero_troll_warlord",
    "npc_dota_hero_axe",
    "npc_dota_hero_alchemist",
    "npc_dota_hero_ogre_magi",
    "npc_dota_hero_antimage",
    "npc_dota_hero_primal_beast",
    "npc_dota_hero_marci",
    "npc_dota_hero_templar_assassin",
    "npc_dota_hero_bloodseeker",
    "npc_dota_hero_monkey_king",
    "npc_dota_hero_mars",
    "npc_dota_hero_zuus",
    "npc_dota_hero_leshrac",
    "npc_dota_hero_crystal_maiden",
    "npc_dota_hero_snapfire",
    "npc_dota_hero_sven",
    "npc_dota_hero_sniper",
    "npc_dota_hero_muerta",
    "npc_dota_hero_pangolier",
    "npc_dota_hero_arc_warden",
    "npc_dota_hero_invoker",
    "npc_dota_hero_razor",
    "npc_dota_hero_sand_king",
    "npc_dota_hero_furion",
    "npc_dota_hero_abaddon",
    "npc_dota_hero_drow_ranger",
    "npc_dota_hero_skywrath_mage",
    "npc_dota_hero_slark",
    "npc_dota_hero_centaur",
    "npc_dota_hero_enigma",
    "npc_dota_hero_bane",
    "npc_dota_hero_morphling",
    "npc_dota_hero_life_stealer",
    "npc_dota_hero_tinker",
}



_G.duel_fields = 
{
    ['1'] = 
    {
        ['start1_1'] = Vector(6365, -7297, 104),
        ['start2_1'] = Vector(7511, -6220, 104),
        ['Xmax'] = 7980,
        ['Xmin'] = 5922,
        ['Ymax'] = -5759,
        ['Ymin'] = -7814,
        ['z'] = 166,
    },
    ['2'] = 
    {
        ['start1_1'] = Vector(-7212, 6201, 104),
        ['start2_1'] = Vector(-6112, 7286, 104),
        ['Xmax'] = -5652,
        ['Xmin'] = -7647,
        ['Ymax'] = 7813,
        ['Ymin'] = 5781,
        ['z'] = 166,
    },
    ['6'] = 
    {
        ['start1_1'] = Vector(-6242, 2429, 104),
        ['start2_1'] = Vector(-6242, 3899, 104),
        ['Xmax'] = -5546,
        ['Xmin'] = -6946,
        ['Ymax'] = 4249,
        ['Ymin'] = 2079,
        ['z'] = 96,
    },
    ['7'] = 
    {
        ['start1_1'] = Vector(2586, -6400, 96),
        ['start2_1'] = Vector(4046, -6400, 96),
        ['Xmax'] = 4396,
        ['Xmin'] = 2226,
        ['Ymax'] = -5700,
        ['Ymin'] = -7100,
        ['z'] = 96,
    },
    ['8'] = 
    {
        ['start1_1'] = Vector(-3741, 6368, 104),
        ['start2_1'] = Vector(-2271, 6368, 104),
        ['Xmax'] = -1921,
        ['Xmin'] = -4091,
        ['Ymax'] = 7118,
        ['Ymin'] = 5718,
        ['z'] = 96,
    },
    ['9'] = 
    {
        ['start1_1'] = Vector(6559, -2419, 104),
        ['start2_1'] = Vector(6559, -3908, 104),
        ['Xmax'] = 7259,
        ['Xmin'] = 5859,
        ['Ymax'] = -2069,
        ['Ymin'] = -4258,
        ['z'] = 96,
    },
}




function dota1x6:IsSphere( item )
if item:GetName() == "item_legendary_upgrade" or 
    item:GetName() == "item_gray_upgrade" or
    item:GetName() == "item_blue_upgrade" or 
    item:GetName() == "item_purple_upgrade_shop" or 
    item:GetName() == "item_alchemist_recipe" or 
    item:GetName() == "item_purple_upgrade" then 
        return true end 
return false 
end




function dota1x6:GetHeroType( player )
if not IsServer() then return end

if player:GetUnitName() == "npc_dota_hero_juggernaut" then return {"melle","mage"} end 
if player:GetUnitName() == "npc_dota_hero_phantom_assassin" then return {"melle"}  end 
if player:GetUnitName() == "npc_dota_hero_terrorblade" then return {"melle"}  end 
if player:GetUnitName() == "npc_dota_hero_nevermore" then return {"mage"}  end 
if player:GetUnitName() == "npc_dota_hero_puck" then return {"mage"} end 
if player:GetUnitName() == "npc_dota_hero_queenofpain" then return {"mage"} end 
if player:GetUnitName() == "npc_dota_hero_huskar" then return {"mage"} end 
if player:GetUnitName() == "npc_dota_hero_bristleback" then return {"mage","melle"} end 
if player:GetUnitName() == "npc_dota_hero_legion_commander" then return {"mage","melle"} end 
if player:GetUnitName() == "npc_dota_hero_void_spirit" then return {"melle","mage"} end 
if player:GetUnitName() == "npc_dota_hero_ember_spirit" then return {"melle","mage"} end 
if player:GetUnitName() == "npc_dota_hero_pudge" then return {"melle","mage"} end 
if player:GetUnitName() == "npc_dota_hero_hoodwink" then return {"mage"} end 
if player:GetUnitName() == "npc_dota_hero_skeleton_king" then return {"melle"} end
if player:GetUnitName() == "npc_dota_hero_lina" then return {"mage"} end 
if player:GetUnitName() == "npc_dota_hero_troll_warlord" then return {"melle","mage"} end 
if player:GetUnitName() == "npc_dota_hero_axe" then return {"melle","mage"} end 
if player:GetUnitName() == "npc_dota_hero_alchemist" then return {"melle","mage"} end 
if player:GetUnitName() == "npc_dota_hero_ogre_magi" then return {"melle","mage"} end 
if player:GetUnitName() == "npc_dota_hero_antimage" then return {"melle","mage"} end 
if player:GetUnitName() == "npc_dota_hero_primal_beast" then return {"melle","mage"} end 
if player:GetUnitName() == "npc_dota_hero_marci" then return {"melle","mage"} end 
if player:GetUnitName() == "npc_dota_hero_templar_assassin" then return {} end 
if player:GetUnitName() == "npc_dota_hero_bloodseeker" then return {"melle","mage"} end 
if player:GetUnitName() == "npc_dota_hero_monkey_king" then return {"melle","mage"} end 
if player:GetUnitName() == "npc_dota_hero_mars" then return {"melle","mage"} end 
if player:GetUnitName() == "npc_dota_hero_zuus" then return {"mage"} end 
if player:GetUnitName() == "npc_dota_hero_leshrac" then return {"mage"} end 
if player:GetUnitName() == "npc_dota_hero_crystal_maiden" then return {"mage"} end 
if player:GetUnitName() == "npc_dota_hero_snapfire" then return {"mage"} end 
if player:GetUnitName() == "npc_dota_hero_sven" then return {"melle"} end 
if player:GetUnitName() == "npc_dota_hero_sniper" then return {"mage"} end 
if player:GetUnitName() == "npc_dota_hero_muerta" then return {"mage"} end 
if player:GetUnitName() == "npc_dota_hero_pangolier" then return {"melle","mage"} end 
if player:GetUnitName() == "npc_dota_hero_arc_warden" then return {"mage"} end 
if player:GetUnitName() == "npc_dota_hero_invoker" then return {"mage"} end 
if player:GetUnitName() == "npc_dota_hero_razor" then return {"mage"} end 
if player:GetUnitName() == "npc_dota_hero_sand_king" then return {"melle","mage"} end 
if player:GetUnitName() == "npc_dota_hero_furion" then return {"mage"} end 
if player:GetUnitName() == "npc_dota_hero_abaddon" then return {"melle","mage"} end 
if player:GetUnitName() == "npc_dota_hero_drow_ranger" then return {"mage"} end 
if player:GetUnitName() == "npc_dota_hero_skywrath_mage" then return {"mage"} end 
if player:GetUnitName() == "npc_dota_hero_slark" then return {"melle","mage"} end 
if player:GetUnitName() == "npc_dota_hero_centaur" then return {"melle","mage"} end 
if player:GetUnitName() == "npc_dota_hero_enigma" then return {"mage"} end 
if player:GetUnitName() == "npc_dota_hero_bane" then return {"mage"} end 
if player:GetUnitName() == "npc_dota_hero_morphling" then return {"mage"} end 
if player:GetUnitName() == "npc_dota_hero_life_stealer" then return {"melle"} end 
if player:GetUnitName() == "npc_dota_hero_tinker" then return {"mage"} end 
end



function dota1x6:IsPatrol(name)
if name == "patrol_melee_good" or 
    name == "patrol_range_good" or 
    name == "patrol_melee_bad" or
    name == "patrol_range_bad" then return true end

return false
end



function dota1x6:IsAncientCreep( unit )
if not IsServer() then return end
name = unit:GetUnitName()
if name == "npc_dota_neutral_black_dragon" 
or  name == "npc_dota_neutral_black_drake" 
or  name == "npc_dota_neutral_granite_golem"
or  name == "npc_dota_neutral_rock_golem" 
or  name == "npc_dota_neutral_big_thunder_lizard" 
or  name == "npc_dota_neutral_small_thunder_lizard"  then return true end  

return false 
end




_G.RemoveForDuel =
{
    ["modifier_smoke_of_deceit"] = true,
    ["modifier_item_revenants_brooch_counter"] = true,
    ["modifier_item_hurricane_pike_range"] = true,
    ["modifier_sven_gods_strength"] = true,
}







_G.BluePoints = 
{
    ["npc_dota_neutral_kobold"] = 2,
    ["npc_dota_neutral_kobold_tunneler"] = 2,

    ["npc_dota_neutral_kobold_taskmaster"] = 6, 

    ["npc_dota_neutral_forest_troll_berserker"] = 4,
    ["npc_dota_neutral_forest_troll_high_priest"] = 6, 

    ["npc_dota_neutral_harpy_scout"] = 4, 
    ["npc_dota_neutral_harpy_storm"] = 6,

    ["npc_dota_neutral_gnoll_assassin"] = 5, 

    ["npc_dota_neutral_ghost"] = 6, 
    ["npc_dota_neutral_fel_beast"] = 4, 



    ["npc_dota_neutral_centaur_outrunner"] = 9,

    ["npc_dota_neutral_alpha_wolf"] = 8,
    ["npc_dota_neutral_giant_wolf"] = 5,

    ["npc_dota_neutral_satyr_soulstealer"] = 5,
    ["npc_dota_neutral_satyr_trickster"] = 4,

    ["npc_dota_neutral_mud_golem"] = 5,
    ["npc_dota_neutral_mud_golem_split"] = 2,

    ["npc_dota_neutral_ogre_magi"] = 6,
    ["npc_dota_neutral_ogre_mauler"] = 6, 





    ["npc_dota_neutral_polar_furbolg_ursa_warrior"] = 15,
    ["npc_dota_neutral_polar_furbolg_champion"] = 10,

    ["npc_dota_neutral_satyr_hellcaller"] = 16,

    ["npc_dota_neutral_centaur_khan"] = 9,

    ["npc_dota_neutral_wildkin"] = 5, 
    ["npc_dota_neutral_enraged_wildkin"] = 16,

    ["npc_dota_neutral_dark_troll"] = 5,
    ["npc_dota_neutral_dark_troll_warlord"] = 16, 

    ["npc_dota_neutral_warpine_raider"] = 13,



    ["npc_dota_neutral_black_dragon"] = 20,
    ["npc_dota_neutral_black_drake"] = 13,

    ["npc_dota_neutral_granite_golem"] = 20,
    ["npc_dota_neutral_rock_golem"] = 13,

    ["npc_dota_neutral_big_thunder_lizard"] = 20,
    ["npc_dota_neutral_small_thunder_lizard" ] = 13,  

    ["npc_dota_neutral_ice_shaman" ] = 20,  
    ["npc_dota_neutral_frostbitten_golem"] = 13,
    
    ["npc_dota_neutral_prowler_shaman" ] = 20,  
    ["npc_dota_neutral_prowler_acolyte"] = 13,


    ["npc_muerta_ursa"] = 50,
    ["npc_muerta_satyr"] = 50,
    ["npc_muerta_centaur"] = 50,
    ["npc_muerta_ogre"] = 50,

} 



_G.Shared_Bounty =
{

    ["npc_filler_dire_stun"] =
    {
        blue = 40,
        gold = 750,
    },
    ["npc_filler_dire_plasma"] =
    {
        blue = 40,
        gold = 750,
    },
    ["npc_filler_dire_resist"] =
    {
        blue = 40,
        gold = 750,
    },
    ["npc_filler_radiant_stun"] =
    {
        blue = 40,
        gold = 750,
    },
    ["npc_filler_radiant_plasma"] =
    {
        blue = 40,
        gold = 750,
    },
    ["npc_filler_radiant_resist"] =
    {
        blue = 40,
        gold = 750,
    },

    ["patrol_melee_good"] =
    {
        blue = 6,
        gold = 90,
    },
    ["patrol_range_good"] =
    {
        blue = 6,
        gold = 90,
    },
    ["patrol_melee_bad"] =
    {
        blue = 6,
        gold = 90,
    },
    ["patrol_range_bad"] =
    {
        blue = 6,
        gold = 90,
    },
    ["npc_dota_tormentor_custom"] =
    {
        blue = 20,
    },

}



_G.team_color =
{
    [2] = {101, 183, 235},
    [3] = {254, 138, 24},
    [6] = {125, 232, 144},
    [7] = {227, 61, 227},
    [8] = {255, 158, 158},
    [9] = {222, 209, 35},
}


_G.wave_types = 
{
    [1] = 
    {
        ["creeps"] = {"npc_kobold","npc_kobold","npc_kobold","npc_kobold_t","npc_kobold_t","npc_kobold_m"},
        ["skills"] = {},
        ["creeps_type"] = 0,
        ["mkb"] = 1,
    },
    [2] = 
    {
        ["creeps"] = {"npc_treant","npc_treant","npc_treant","npc_treant_b"},
        ["skills"] = {"npc_treant_passive","npc_treant_seed"},
        ["creeps_type"] = 1,
        ["mkb"] = 0,
    },
    [3] = 
    {
        ["creeps"] = {"npc_skelet","npc_skelet","npc_skelet","npc_skelet_a"},
        ["skills"] = {"npc_skelet_aura","npc_skelet_tomb"},
        ["creeps_type"] = 1,
        ["mkb"] = 0,
    },
    [4] = 
    {
        ["creeps"] = {"npc_wolf","npc_wolf","npc_wolf_a","npc_wolf"},
        ["skills"] = {"npc_wolf_howl","npc_wolf_feral"},
        ["creeps_type"] = 1,
        ["mkb"] = 1,
    },
    [5] = 
    {
        ["creeps"] = {"npc_boar_a","npc_boar2","npc_boar"},
        ["skills"] = {"npc_boar_spit", "npc_boar_slow"},
        ["creeps_type"] = 0,
        ["mkb"] = 1,
    },
    [6] = 
    {
        ["creeps"] = {"npc_megacreep_good","npc_megacreep_good","npc_megacreep_good","npc_megacreep_good","npc_megacreep_good","npc_megacreep_good_a"},
        ["skills"] = {"npc_megacreep_upgrade"},
        ["creeps_type"] = 0,
        ["mkb"] = 1,
    },
    [7] = 
    {
        ["creeps"] = {"npc_megacreep_bad","npc_megacreep_bad","npc_megacreep_bad","npc_megacreep_bad","npc_megacreep_bad","npc_megacreep_bad_a"},
        ["skills"] = {"npc_megacreep_debuf"},
        ["creeps_type"] = 0,
        ["mkb"] = 1,
    },
    [8] = 
    {
        ["creeps"] = {"npc_golem_large"},
        ["skills"] = {"golem_double", "npc_golem_passive"},
        ["creeps_type"] = 0,
        ["mkb"] = 0,
    },
    [9] = 
    {
        ["creeps"] = {"npc_troll"},
        ["skills"] = {"npc_troll_summon", "npc_troll_skelet_heal"},
        ["creeps_type"] = 1,
        ["mkb"] = 1,
    },
    [10] = 
    {
        ["creeps"] = {"npc_rogue","npc_warrior","npc_archer"},
        ["skills"] = {"npc_rogue_passive", "npc_warrior_passive", "npc_archer_silence"},
        ["creeps_type"] = 1,
        ["mkb"] = 0,
    },
    [11] = 
    {
        ["creeps"] = {"npc_tusk","npc_tusk","npc_tusk","npc_tusk_a","npc_tusk_a","npc_tusk_a"},
        ["skills"] = {"npc_tusk_passive","npc_tusk_ghost_passive"},
        ["creeps_type"] = 0,
        ["mkb"] = 1,
    },
    [12] = 
    {
        ["creeps"] = {"npc_ogre","npc_ogre_a","npc_ogre_a","npc_ogre_a","npc_ogre_b"},
        ["skills"] = {"npc_ogre_root", "npc_ogre_stun"},
        ["creeps_type"] = 0,
        ["mkb"] = 0,
    },
    [13] = 
    {
        ["creeps"] = {"npc_werewolf","npc_werewolf","npc_werewolf_a","npc_werewolf_a"},
        ["skills"] = {"npc_werewolf_bloodrage", "npc_werewolf_rupture"},
        ["creeps_type"] = 1,
        ["mkb"] = 0,
    },
    [14] = 
    {
        ["creeps"] = {"npc_cone","npc_cone","npc_cone","npc_cone"},
        ["skills"] = {"npc_cone_armor"},
        ["creeps_type"] = 1,
        ["mkb"] = 0,
    },
    [15] = 
    {
        ["creeps"] = {"npc_satyr","npc_satyr_a","npc_satyr_b","npc_satyr_b"},
        ["skills"] = {"npc_satyr_aura","npc_satyr_purge","npc_satyr_manaburn"},
        ["creeps_type"] = 1,
        ["mkb"] = 0,
    },
    [16] = 
    {
        ["creeps"] = {"npc_spider","npc_spider_a","npc_spider_a"},
        ["skills"] = {"npc_spider_toxin","npc_spider_passive","npc_spider_poison"},
        ["creeps_type"] = 1,
        ["mkb"] = 1,
    },
    [17] = 
    {
        ["creeps"] = {"npc_badsiege","npc_badsiege","npc_badsiege_a","npc_badsiege_a"},
        ["skills"] = {"npc_siege_passive","npc_siege_melting"},
        ["creeps_type"] = 1,
        ["mkb"] = 0,
    },
    [18] = 
    {
        ["creeps"] = {"npc_goodsiege","npc_goodsiege","npc_goodsiege_a","npc_goodsiege_a"},
        ["skills"] = {"npc_siege_passive","npc_siege_armor"},
        ["creeps_type"] = 1,
        ["mkb"] = 0,
    },
    [19] = 
    {
        ["creeps"] = {"npc_slardar","npc_slardar","npc_slardar","npc_slardar_a"},
        ["skills"] = {"npc_slardar_armor","npc_slardar_stun"},
        ["creeps_type"] = 1,
        ["mkb"] = 0,
    },
    [20] = 
    {
        ["creeps"] = {"npc_tombgolem","npc_tombgolem"},
        ["skills"] = {"npc_golem_decay","npc_zombie_attack"},
        ["creeps_type"] = 0,
        ["mkb"] = 0,
    },
    [21] = 
    {
        ["creeps"] = {"npc_ancient_satyr","npc_ancient_satyr","npc_ancient_satyr_a","npc_ancient_satyr_a"},
        ["skills"] = {"npc_satyr_stomp","npc_satyr_root"},
        ["creeps_type"] = 1,
        ["mkb"] = 0,
    },
    [22] = 
    {
        ["creeps"] = {"npc_arc","npc_arc","npc_arc_a"},
        ["skills"] = {"npc_arc_field","npc_arc_knockback"},
        ["creeps_type"] = 1,
        ["mkb"] = 0,
    },
    [23] = 
    {
        ["creeps"] = {"npc_techies","npc_techies","npc_techies"},
        ["skills"] = {"npc_techies_bomb","npc_techies_death"},
        ["creeps_type"] = 1,
        ["mkb"] = 0,
    },
    [24] = 
    {
        ["creeps"] = {"npc_huskar","npc_huskar","npc_dazzle","npc_dazzle"},
        ["skills"] = {"npc_huskar_lowhp","npc_dazzle_grave"},
        ["creeps_type"] = 1,
        ["mkb"] = 1,
    },
    [25] = 
    {
        ["creeps"] = {"npc_abbadon","npc_abbadon_a","npc_abbadon_a","npc_abbadon_a"},
        ["skills"] = {"npc_abbadon_ulti","npc_abbadon_silence","npc_abbadon_proc"},
        ["creeps_type"] = 1,
        ["mkb"] = 1,
    },
    [26] = 
    {
        ["creeps"] = {"npc_warlock"},
        ["skills"] = {"warlock_boss_golem_fists_passive","warlock_boss_rain_of_chaos","warlock_boss_shadow_word","warlock_boss_upheaval"},
        ["creeps_type"] = 2,
        ["mkb"] = 1,
    },
    [27] = 
    {
        ["creeps"] = {"npc_lich"},
        ["skills"] = {"npc_lich_blast","npc_lich_ice","npc_lich_ulti","npc_lich_frostbite"},
        ["creeps_type"] = 2,
        ["mkb"] = 1,
    },
    [28] = 
    {
        ["creeps"] = {"npc_enigma"},
        ["skills"] = {"enigma_boss_midnight_custom","enigma_boss_black_hole_custom","enigma_boss_summon_custom","enigma_boss_malefice_custom"},
        ["creeps_type"] = 2,
        ["mkb"] = 1,
    },
    [29] = 
    {
        ["creeps"] = {"npc_centaur","npc_centaur","npc_centaur","npc_centaur_a"},
        ["skills"] = {"npc_centaur_stun","npc_centaur_double"},
        ["creeps_type"] = 1,
        ["mkb"] = 1,
    },
    [30] = 
    {
        ["creeps"] = {"npc_silencer","npc_silencer","npc_antimage","npc_antimage"},
        ["skills"] = {"npc_silencer_lastword","npc_antimage_burn","npc_antimage_resist"},
        ["creeps_type"] = 1,
        ["mkb"] = 0,
    },
    [31] = 
    {
        ["creeps"] = {"npc_frostbitten","npc_frostbitten","npc_frostbitten_a","npc_frostbitten_a"},
        ["skills"] = {"npc_frostbitten_spam","npc_frostbitten_heal"},
        ["creeps_type"] = 0,
        ["mkb"] = 0,
    },
}


_G.necro_wave_info =
{
    "npc_necro_melle",
    "npc_necro_range"
}


_G.particle_attach =
{
    ["point_follow"] = PATTACH_POINT_FOLLOW,
    ["worldorigin"] = PATTACH_WORLDORIGIN,
    ["absorigin_follow"] = PATTACH_ABSORIGIN_FOLLOW,
    ["customorigin"] = PATTACH_CUSTOMORIGIN,
    ["absorigin"] = PATTACH_ABSORIGIN,
    ["renderorigin_follow"] = PATTACH_RENDERORIGIN_FOLLOW,
    ["customorigin_follow"] = PATTACH_CUSTOMORIGIN_FOLLOW,
}
