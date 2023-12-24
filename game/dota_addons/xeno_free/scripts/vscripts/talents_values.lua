
if talents_values == nil then 
    _G.talents_values = class({})
end


function talents_values:InitGameMode()

    for group_name, skills_group in pairs(global_values) do
        CustomNetTables:SetTableValue("talents_values", group_name, skills_group)
    end
end

global_values = 
{
    npc_dota_hero_juggernaut = 
    {
        ["modifier_juggernaut_bladefury_damage"] = 
        {
            damage = {30, 45, 60}
        },
        ["modifier_juggernaut_bladefury_duration"] = 
        {
            slow_move = {-20, -30, -40},
            slow_heal = {-10, -15, -20},
            slow_duration = 2,
        },
        ["modifier_juggernaut_bladefury_chance"] = 
        {
            cd = {-1, -2, -3}
        },
        ["modifier_juggernaut_bladefury_agility"] = 
        {
            chance = 20,
            duration = {1.2, 2},
            radius = 180
        },
        ["modifier_juggernaut_bladefury_silence"] = 
        {
            radius = 80,
        },
        ["modifier_juggernaut_bladefury_shield"] = 
        {
            armor = 15,
            heal = 30,
            heal_creeps = 3,
        },
        ["modifier_juggernaut_bladefury_legendary"] = 
        {
            damage = 70,
            cd_max = 16,
            cd_min = 5,
            duration = 3,
            speed = 1200,
        },



        ['modifier_juggernaut_healingward_heal'] =
        {
            damage = {2, 3, 4},
            interval = 0.5,
            death = 300
        },
        ['modifier_juggernaut_healingward_move'] =
        {
            move_status = {10, 15, 20}
        },
        ['modifier_juggernaut_healingward_cd'] =
        {
            cd = {-2, -3, -4},
            radius = {50, 75, 100}
        },


        ['modifier_juggernaut_healingward_return'] =
        {
            interval = 4,
            bonus_damage = {10, 15},
            bonus_speed = {80, 120},
            duration = 3,
            tick = 1,
        },
        ['modifier_juggernaut_healingward_purge'] =
        {
            disarm = 2,
            slow = -25,
        },
        ['modifier_juggernaut_healingward_stun'] =
        {
            stun = 1.5,
            heal = 20,
            regen = 2
        },


        ['modifier_juggernaut_healingward_legendary'] =
        {   
            move = 50,
            hits_melee = 3,
            hits_ranged = 4
        },



        ['modifier_juggernaut_bladedance_lowhp'] =
        {
            heal = {20, 30, 40},
        },
        ['modifier_juggernaut_bladedance_chance'] =
        {
            damage = {20, 40, 60},
        },
        ['modifier_juggernaut_bladedance_speed'] =
        {   
            speed = {10, 15, 20},
            duration = 3,
            max = 3,
        },


        ['modifier_juggernaut_bladedance_stack'] =
        {
            damage = {50, 80},
            health = 30,
            duration = 4
        },
        ['modifier_juggernaut_bladedance_double'] =
        {
            move = 40,
            slow = -40,
            duration = 2
        },
        ['modifier_juggernaut_bladedance_parry'] =
        {
            damage_reduce = -25,
            duration = 1,
            range = 60
        },


        ['modifier_juggernaut_bladedance_legendary'] =
        {
            cd = 16,
            duration = 4,
            status = 40,
            chance = 100,
            stun = 1,
            range = 400
        },




        ['modifier_juggernaut_omnislash_stack'] =
        {
            speed = {30, 45, 60}
        },
        ['modifier_juggernaut_omnislash_heal'] =
        {
            heal = {40, 60, 80}
        },
        ['modifier_juggernaut_omnislash_speed'] =
        {
            damage = {30, 45, 60},
            radius = 200
        },


        ['modifier_juggernaut_omnislash_cd'] =
        {
            damage = {20, 30},
            duration = 2,
            range = 600,

        },
        ['modifier_juggernaut_omnislash_clone'] =
        {
            chance = 20,
            cd = 1.5,
            chance_multi = 2
        },
        ['modifier_juggernaut_omnislash_aoe_attack'] =
        {
            root = 2,
            heal = -60,
        },


        ['modifier_juggernaut_omnislash_legendary'] =
        {
            cd = 20,
            duration = 1,
            range = 850,
            mana = 100,
            cast = 0.15,
            radius = 250,
        },

    },


    npc_dota_hero_phantom_assassin =
    {

        ["modifier_phantom_assassin_dagger_cd"] = 
        {
            cd = {-1, -1.5, -2}
        },
        ["modifier_phantom_assassin_dagger_aoe"] = 
        {
            heal = {20, 30, 40}
        },
        ["modifier_phantom_assassin_dagger_damage"] = 
        {
            damage = {100, 150, 200},
            duration = 4
        },
        ["modifier_phantom_assassin_dagger_double"] = 
        {
            damage = {3, 5},
            heal_reduce = {-5, -8},
            max = 5,
            duration = 7
        },
        ["modifier_phantom_assassin_dagger_duration"] = 
        {
            heal = 15,
            duration = 2.5,
            cd = 40,
        },
        ["modifier_phantom_assassin_dagger_heal"] = 
        {
            speed = 10,
            duration = 3,
            distance = 200
        },
        ["modifier_phantom_assassin_dagger_legendary"] = 
        {
            cast = 0.15,
            max = 4,
        },



        ["modifier_phantom_assassin_blink_move"] = 
        {
            speed = {10, 15, 20},
            range = {100, 150, 200}
        },
        ["modifier_phantom_assassin_blink_duration"] = 
        {
            duration = {1, 1.5, 2},
            slow = {-10, -15, -20},
            duration_slow = 2
        },
        ["modifier_phantom_assassin_blink_damage"] = 
        {
            damage = {60, 120, 180},
            illusions_damage = 50,
        },
        ["modifier_phantom_assassin_blink_illusion"] = 
        {   
            agility = {2,3},
            duration = 10,
        },
        ["modifier_phantom_assassin_blink_blink"] = 
        {
            cd = -1,
            slow = -50,
            duration = 2,
        },
        ["modifier_phantom_assassin_blink_blind"] = 
        {
            duration = 4,
            incoming = 200,
        },
        ["modifier_phantom_assassin_blink_legendary"] = 
        {
            cd = 40,
            interval = 2,
            damage = 20,
            incoming = 400,
            illusions_duration = 6,
            duration = 6
        },



        ["modifier_phantom_assassin_blur_delay"] = 
        {
            delay = {0.5, 0.75, 1}
        },
        ["modifier_phantom_assassin_blur_heal"] = 
        {
            speed = {10, 15, 20},
            duration = 4,
            heal = {10, 15, 20}
        },
        ["modifier_phantom_assassin_blur_chance"] = 
        {
            duration = 5,
            speed = {20, 30, 40},
            damage = {20, 30, 40}
        },
        ["modifier_phantom_assassin_blur_blood"] = 
        {
            stun = {0.8, 1.2},
            damage = {8, 12},
            damage_creeps = 3,
        },
        ["modifier_phantom_assassin_blur_reduction"] = 
        {
            evasion = 10,
            chance = 20,
        },
        ["modifier_phantom_assassin_blur_stun"] = 
        {
            damage = -80,
            duration = 1.5,
            cd = 25,
        },
        ["modifier_phantom_assassin_blur_legendary"] = 
        {
            cd = -0.5,
            duration = 1,
        },


        ["modifier_phantom_assassin_crit_chance"] = 
        {
            damage = {30, 45, 60},
            duration = 5,
        },
        ["modifier_phantom_assassin_crit_damage"] = 
        {
            heal = {10, 15, 20}
        },
        ["modifier_phantom_assassin_crit_speed"] = 
        {
            cleave = {20, 30, 40},
            range = {40, 60, 80}
        },  
        ["modifier_phantom_assassin_crit_stack"] = 
        {
            armor = -1,
            max = {12, 20},
            duration = 6,
            crit_stack = 4,
        },
        ["modifier_phantom_assassin_crit_lowhp"] = 
        {
            silence = 2,
            slow = -150,
            cd = 12
        },
        ["modifier_phantom_assassin_crit_steal"] = 
        {
            damage = 10,
            max = 8, 
            chance = 5,
            is_perma = 1,
            mod_name = "modifier_phantom_assassin_phantom_coup_de_grace_kill"
        },
        ["modifier_phantom_assassin_crit_legendary"] = 
        {
            cd = 60,
            duration = 90,
            gold_base = 100,
            gold_net = 4,
            chance = 10
        },


    },



    npc_dota_hero_huskar =
    {


        ["modifier_huskar_disarm_duration"] = 
        {

        },
        ["modifier_huskar_disarm_heal"] = 
        {

        },
        ["modifier_huskar_disarm_crit"] = 
        {
            damage = {50, 75, 100},
        },
        ["modifier_huskar_disarm_str"] = 
        {

        },
        ["modifier_huskar_disarm_silence"] = 
        {

        },
        ["modifier_huskar_disarm_lowhp"] = 
        {

        },
        ["modifier_huskar_disarm_legendary"] = 
        {

        },



        ["modifier_huskar_spears_damage"] = 
        {

        },
        ["modifier_huskar_spears_blast"] = 
        {

        },
        ["modifier_huskar_spears_armor"] = 
        {

        },
        ["modifier_huskar_spears_tick"] = 
        {

        },
        ["modifier_huskar_spears_aoe"] = 
        {

        },
        ["modifier_huskar_spears_pure"] = 
        {

        },
        ["modifier_huskar_spears_legendary"] = 
        {

        },



        ["modifier_huskar_passive_regen"] = 
        {

        },
        ["modifier_huskar_passive_speed"] = 
        {

        },
        ["modifier_huskar_passive_damage"] = 
        {

        },
        ["modifier_huskar_passive_active"] = 
        {

        },
        ["modifier_huskar_passive_lowhp"] = 
        {

        },
        ["modifier_huskar_passive_armor"] = 
        {

        },
        ["modifier_huskar_passive_legendary"] = 
        {
            damage = 5,
            cost = 4,
            move = 20,
            interval = 0.5,
            cd = 2
        },



        ["modifier_huskar_leap_damage"] = 
        {

        },
        ["modifier_huskar_leap_cd"] = 
        {

        },
        ["modifier_huskar_leap_double"] = 
        {

        },
        ["modifier_huskar_leap_shield"] = 
        {

        },
        ["modifier_huskar_leap_resist"] = 
        {

        },
        ["modifier_huskar_leap_immune"] = 
        {

        },
        ["modifier_huskar_leap_legendary"] = 
        {

        },


    },
    
    npc_dota_hero_nevermore =
    {

        ["modifier_nevermore_raze_damage"] = 
        {

        },
        ["modifier_nevermore_raze_cd"] = 
        {

        },
        ["modifier_nevermore_raze_speed"] = 
        {
            heal = {20, 30, 40},
            speed = {4, 6, 8},
            max = 3,
            duration = 4
        },
        ["modifier_nevermore_raze_burn"] = 
        {
            delay = 1.2,
            cd = {10, 7},
            slow = -80,
            duration = 1,
            radius = 600,
            aoe = 0.8
        },
        ["modifier_nevermore_raze_combocd"] = 
        {
            cd = 7,
            slow = -80,
            duration = 2,
            silence = 2,
            fear = 1.2
        },
        ["modifier_nevermore_raze_duration"] = 
        {

        },
        ["modifier_nevermore_raze_legendary"] = 
        {

        },



        ["modifier_nevermore_souls_damage"] = 
        {

        },
        ["modifier_nevermore_souls_max"] = 
        {

        },
        ["modifier_nevermore_souls_attack"] = 
        {

        },
        ["modifier_nevermore_souls_tempo"] = 
        {

        },
        ["modifier_nevermore_souls_heal"] = 
        {

        },
        ["modifier_nevermore_souls_kills"] = 
        {
            max_damage = 1,
            bonus = 1,
            max = 10,
            is_perma = 1,
            mod_name = "modifier_custom_necromastery_kills"
        },
        ["modifier_nevermore_souls_legendary"] = 
        {

        },



        ["modifier_nevermore_darklord_armor"] = 
        {

        },
        ["modifier_nevermore_darklord_slow"] = 
        {

        },
        ["modifier_nevermore_darklord_damage"] = 
        {

        },
        ["modifier_nevermore_darklord_health"] = 
        {

        },
        ["modifier_nevermore_darklord_self"] = 
        {

        },
        ["modifier_nevermore_darklord_silence"] = 
        {

        },
        ["modifier_nevermore_darklord_legendary"] = 
        {

        },



        ["modifier_nevermore_requiem_damage"] = 
        {
            damage = {10, 15, 20}
        },
        ["modifier_nevermore_requiem_cd"] = 
        {

        },
        ["modifier_nevermore_requiem_heal"] = 
        {

        },
        ["modifier_nevermore_requiem_proc"] = 
        {

        },
        ["modifier_nevermore_requiem_bkb"] = 
        {

        },
        ["modifier_nevermore_requiem_cdsoul"] = 
        {

        },
        ["modifier_nevermore_requiem_legendary"] = 
        {

        },

    },



    npc_dota_hero_queenofpain =
    {
        ["modifier_queen_Dagger_damage"] = 
        {

        },
        ["modifier_queen_Dagger_heal"] = 
        {

        },
        ["modifier_queen_Dagger_auto"] = 
        {

        },
        ["modifier_queen_Dagger_proc"] = 
        {

        },
        ["modifier_queen_Dagger_aoe"] = 
        {

        },
        ["modifier_queen_Dagger_poison"] = 
        {

        },
        ["modifier_queen_Dagger_legendary"] = 
        {

        },



        ["modifier_queen_Blink_cd"] = 
        {
            cd = {-1, -1.5, -2}
        },
        ["modifier_queen_Blink_damage"] = 
        {
            range = {40, 60, 80},
            speed = {40, 60, 80},
            duration = 3
        },
        ["modifier_queen_Blink_speed"] = 
        {
            damage = {1, 1.5, 2},
            duration = 8,
            max = 10
        },
        ["modifier_queen_Blink_magic"] = 
        {
            chance = {25, 40},
            damage = 80,
            cd = 0.5,
            radius = 200
        },
        ["modifier_queen_Blink_spells"] = 
        {

        },
        ["modifier_queen_Blink_absorb"] = 
        {
            damage_reduce = -40,
            status_bonus = 40,
            duration = 1.5,
            cast = -0.15,
        },
        ["modifier_queen_Blink_legendary"] = 
        {

        },



        ["modifier_queen_Scream_damage"] =
        {
            damage = {3, 4, 5}
        },
        ["modifier_queen_Scream_cd"] =
        {
            cd = {1, 1.5, 2}
        },
        ["modifier_queen_Scream_double"] =
        {
            damage_reduce = {-3, -4, -5},
            max = 5,
            duration = 10
        },
        ["modifier_queen_Scream_shield"] =
        {
            chance = {30, 50},
            heal = 6,
            radius = 310,
        },
        ["modifier_queen_Scream_fear"] =
        {
            cd = 50,
            health = 50,
            heal = 35,
            heal_creeps = 3,
        },
        ["modifier_queen_Scream_slow"] =
        {
            cd = 12,
            slow = -60,
            duration = 2,
            range = 400,
            knock_distance = 350,
            knock_duration = 0.3,
        },
        ["modifier_queen_Scream_legendary"] =
        {
            cd = 20,
            duration = 10,
            cd_bonus = 100,
            cost = 3,
            interval = 0.5,
            damage = 5
        },



        ["modifier_queen_Sonic_damage"] = 
        {

        },
        ["modifier_queen_Sonic_fire"] = 
        {

        },
        ["modifier_queen_Sonic_reduce"] = 
        {

        },
        ["modifier_queen_Sonic_taken"] = 
        {
            damage = {10, 15},
            max = 5,
            duration = 10,
            radius = 450,
            stun = {1.5, 2.5}
        },
        ["modifier_queen_Sonic_far"] = 
        {
            cast = -0.15,
            mana = -50,
            duration = 3,

        },
        ["modifier_queen_Sonic_cd"] = 
        {

        },
        ["modifier_queen_Sonic_legendary"] = 
        {
            damage_creeps = 2,
            damage_heroes = 10,
            cd = 3,
            max = 8,
            timer = 5,
        },
    },


    npc_dota_hero_legion_commander =
    {
        ["modifier_legion_odds_cd"] =
        {
            slow = {-10, -15, -20},
            duration = {1, 1.5, 2}
        },
        ["modifier_legion_odds_creep"] =
        {
            status = {10, 15, 20},
            shield = {6, 9, 12}    
        },
        ["modifier_legion_odds_triple"] =
        {
            damage = {30, 50, 70}
        },
        ["modifier_legion_odds_proc"] =
        {   
            cd = {-0.25, -0.4},
            speed = {6, 10},
            max = 8
        },
        ["modifier_legion_odds_solo"] =
        {
            silence = 2,
            mana = 0
        },
        ["modifier_legion_odds_mark"] =
        {
            cast = -0.2,
            range = 700,
            speed = 1000
        },
        ["modifier_legion_odds_legendary"] =
        {
            duration = 5,
            stun = 1,
            stun_stacks = 6,
            damage = 25
        },



        ["modifier_legion_press_cd"] =
        {
            move = {6, 9, 12},
            speed = {30, 45, 60},
        },
        ["modifier_legion_press_regen"] =
        {
            regen = {4, 6, 8},
            heal = {8, 12, 16},
            heal_creeps = 3
        },
        ["modifier_legion_press_speed"] =
        {
            cd = {-1, -1.5, -2},
            duration = {1, 1.5, 2},
        },
        ["modifier_legion_press_duration"] =
        {
            interval = 0.25,
            radius = 400,
            damage_min = {25, 40},
            damage_max = {60, 100},
            burn_heal = 40,
        },
        ["modifier_legion_press_after"] =
        {
            radius = 450, 
            root = 2,
            pull_duration = 0.2,
            pull_distance = 100
        },
        ["modifier_legion_press_lowhp"] =
        {
            duration = 3
        },
        ["modifier_legion_press_legendary"] =
        {
            duration = 3,
            damage_reduce = 80,
            damage_duration = 4,
            damage_interval = 1,
            damage_radius = 350,
            damage_creeps = 50
        },
        


        ["modifier_legion_moment_chance"] =
        {
            range = {40, 60, 80},
            slow = {-20, -30, -40},
            duration = 2,
        },
        ["modifier_legion_moment_defence"] =
        {
            armor = {3, 4.5, 6},
            duration = 2
        },
        ["modifier_legion_moment_damage"] =
        {
            damage = {4, 6, 8},
            max = 4,
            duration = 6
        },
        ["modifier_legion_moment_armor"] =
        {
            cd = 10,
            crit = {140, 200},
            stun = {0.5, 0.8},
            cd_reduce = 2,
            cleave = 50
        },
        ["modifier_legion_moment_lowhp"] =
        {
            duration = 5,
            damage_reduce = -25,
            lifesteal = 65,
            cd = 30,
            health = 30
        },
        ["modifier_legion_moment_bkb"] =
        {
            duration = 3,
            chance = 8,
            cd = -0.2
        },
        ["modifier_legion_moment_legendary"] =
        {
            move = 10,
            speed = 30,
            damage_reduce = -10,
            lifesteal = 25,
            chance = 2,
            toggle = 3            
        },



        ["modifier_legion_duel_passive"] =
        {
            cd = {-6, -9, -12},
            range = {100, 150, 200}
        },
        ["modifier_legion_duel_return"] =
        {
            damage_reduce = {8, 12, 16}
        },
        ["modifier_legion_duel_speed"] =
        {
            damage = {60, 90, 120},
            heal_reduce = {-15, -20, -25}, 
        },
        ["modifier_legion_duel_damage"] =
        {
            damage = {10, 15},
            duration = {0.4, 0.6}
        },
        ["modifier_legion_duel_win"] =
        {
            heal = 20
        },
        ["modifier_legion_duel_blood"] =
        {
            str = 0.5,
            max = 70,
            cdr = 20,
            is_perma = 1,
            mod_name = "modifier_duel_custom_str"
        },
        ["modifier_legion_duel_legendary"] =
        {
            damage_cd = 5,
            damage = 15,
            amp = 3,
            timer = 10,
            cd = 60,
            init_charges = 5
        },
    },
    npc_dota_hero_terrorblade =
    {
        ["modifier_terror_reflection_duration"] =
        {

        },
        ["modifier_terror_reflection_speed"] =
        {
            armor = {-4, -6, -8},
            damage = {10, 15, 20}
        },
        ["modifier_terror_reflection_slow"] =
        {

        },
        ["modifier_terror_reflection_silence"] =
        {  
            speed = {60, 100},
            max = 5,
            duration = 3,
            damage = {50, 70}
        },
        ["modifier_terror_reflection_stun"] =
        {

        },
        ["modifier_terror_reflection_double"] =
        {

        },
        ["modifier_terror_reflection_legendary"] =
        {

        },



        ["modifier_terror_illusion_incoming"] =
        {

        },
        ["modifier_terror_illusion_duration"] =
        {

        },
        ["modifier_terror_illusion_stack"] =
        {

        },
        ["modifier_terror_illusion_double"] =
        {

        },
        ["modifier_terror_illusion_resist"] =
        {

        },
        ["modifier_terror_illusion_texture"] =
        {
            health = 70,
            radius = 700,
            delay = 0.25
        },
        ["modifier_terror_illusion_legendary"] =
        {
            chance = 20,
            duration = 5,
            damage = 30,
            incoming = 500,
            max = 3,
            invun = 0.12
        },



        ["modifier_terror_sunder_cd"] =
        {

        },
        ["modifier_terror_sunder_damage"] =
        {

        },
        ["modifier_terror_sunder_amplify"] =
        {

        },
        ["modifier_terror_sunder_stats"] =
        {
            cd = {5, 3},
            slow = -100,
            cost = 9,
            duration = 1
        },
        ["modifier_terror_sunder_heal"] =
        {
            stats_init = 10,
            duration = 12,
            stats_inc = 1,
            max = 10,
            cast = -0.2
        },
        ["modifier_terror_sunder_swap"] =
        {

        },
        ["modifier_terror_sunder_legendary"] =
        {

        },
    },
    npc_dota_hero_bristleback =
    {
        ["modifier_bristle_goo_max"] =
        {
            max = {2, 3, 4}
        },
        ["modifier_bristle_goo_proc"] =
        {
            
        },
        ["modifier_bristle_goo_ground"] =
        {
        },
        ["modifier_bristle_goo_damage"] =
        {
            
            chance = {25, 40},
            damage = 40,
            radius = 150,
            interval = 1,
            armor = -3,
            duration = 8
        },
        ["modifier_bristle_goo_stack"] =
        {
            chance = 20,
            duration = 1,
            more_stacks = 1
        },
        ["modifier_bristle_goo_status"] =
        {
            
        },
        ["modifier_bristle_goo_legendary"] =
        {
            
        },



        ["modifier_bristle_spray_damage"] =
        {
            
        },
        ["modifier_bristle_spray_max"] =
        {
            damage = {50, 75, 100},
            chance = 25,
            slow = {-20, -30, -40},
            duration = 1
        },
        ["modifier_bristle_spray_heal"] =
        {
            
        },
        ["modifier_bristle_spray_double"] =
        {
            
        },
        ["modifier_bristle_spray_lowhp"] =
        {
            health = 30,
            cd = 1.5,
            heal = 20,
            heal_creeps = 3   
        },
        ["modifier_bristle_spray_reduce"] =
        {
            
        },
        ["modifier_bristle_spray_legendary"] =
        {
            cd = 2.5,
            cost = 4.5
        },



        ["modifier_bristle_back_spray"] =
        {
            
        },
        ["modifier_bristle_back_return"] =
        {
            
        },
        ["modifier_bristle_back_heal"] =
        {
            
        },
        ["modifier_bristle_back_damage"] =
        {
            
        },
        ["modifier_bristle_back_reflect"] =
        {
            
        },
        ["modifier_bristle_back_ground"] =
        {
            
        },
        ["modifier_bristle_back_legendary"] =
        {
            cd = 22,
            duration = 6,
            spray_damage = -50,
        },



        ["modifier_bristle_warpath_damage"] =
        {
            damage = {6, 8, 10}
        },
        ["modifier_bristle_warpath_resist"] =
        {
            
        },
        ["modifier_bristle_warpath_pierce"] =
        {
            
        },
        ["modifier_bristle_warpath_bash"] =
        {
            
        },
        ["modifier_bristle_warpath_max"] =
        {
            
        },
        ["modifier_bristle_warpath_lowhp"] =
        {
            
        },
        ["modifier_bristle_warpath_legendary"] =
        {
            
        },
    },
    npc_dota_hero_puck =
    {
        ["modifier_puck_orb_damage"] =
        {
            
        },
        ["modifier_puck_orb_cd"] =
        {
            
        },
        ["modifier_puck_orb_range"] =
        {
            
        },
        ["modifier_puck_orb_distance"] =
        {
            
        },
        ["modifier_puck_orb_double"] =
        {
            
        },
        ["modifier_puck_orb_blind"] =
        {
            
        },
        ["modifier_puck_orb_legendary"] =
        {
            
        },



        ["modifier_puck_rift_damage"] =
        {
            
        },
        ["modifier_puck_rift_cd"] =
        {
            
        },
        ["modifier_puck_rift_mana"] =
        {
            chance = {30, 45, 60},
            mana = 10,
            heal = 1,
        },
        ["modifier_puck_rift_tick"] =
        {
            damage = {20, 30},
            heal = 100,
            heal_creeps = 0.33
        },
        ["modifier_puck_rift_purge"] =
        {
            
        },
        ["modifier_puck_rift_range"] =
        {
            radius = 100,
            range = 100,
        },
        ["modifier_puck_rift_legendary"] =
        {
            
        },



        ["modifier_puck_shift_regen"] =
        {
            
        },
        ["modifier_puck_shift_damage"] =
        {
            
        },
        ["modifier_puck_shift_lowhp"] =
        {
            
        },
        ["modifier_puck_shift_attacks"] =
        {
            
        },
        ["modifier_puck_shift_resist"] =
        {
            
        },
        ["modifier_puck_shift_stun"] =
        {
            
        },
        ["modifier_puck_shift_legendary"] =
        {
            
        },



        ["modifier_puck_coil_duration"] =
        {
            
        },
        ["modifier_puck_coil_cd"] =
        {
            
        },
        ["modifier_puck_coil_resist"] =
        {
            
        },
        ["modifier_puck_coil_magic"] =
        {
            speed = {6, 10},
            max = 12,
            damage = {8, 12},
            is_perma = 1,
            mod_name = "modifier_custom_puck_dream_coil_kills"
        },
        ["modifier_puck_coil_attacks"] =
        {
            
        },
        ["modifier_puck_coil_cooldowns"] =
        {
            duration = 2,
            stun = 1,
            damage = 100,
            cd = 10,
            radius = 220,
        },
        ["modifier_puck_coil_legendary"] =
        {
            cd = 50,
            damage = 85,
            knock_distance = 120,
            chance = 20,
            radius = 450,
            knock_duration = 0.3,
            effect_cd = 0.5
        },
    },


    npc_dota_hero_void_spirit =
    {

        ["modifier_void_remnant_1"] =
        {
            cd = {-1, -1.5, -2}
        },
        ["modifier_void_remnant_2"] =
        {
            duration = 8,
            speed = {10, 15, 20},
            armor = {2, 3, 4},
            max = 3,
        },
        ["modifier_void_remnant_3"] =
        {
            magic = {-3, -4, -5},
            max = 6,
            duration = 8
        },
        ["modifier_void_remnant_4"] =
        {
            damage = {60, 100},
            heal = 100,
            count = 3,
            chance = 30
        },
        ["modifier_void_remnant_5"] =
        {
            stun = 0.5,
            duration = 3,
            speed = -80,
            move = -80,
        },
        ["modifier_void_remnant_6"] =
        {
            duration = 10,
            stats = 8,
            amp = 0
        },
        ["modifier_void_remnant_legendary"] =
        {
            cd = 20,
            duration = 20,
            status = 50,
            move = 40,
            damage = 50,
            count = 1
        },



        ["modifier_void_astral_1"] =
        {
            damage = {60, 90, 120}
        },
        ["modifier_void_astral_2"] =
        {
            mana = {8, 12, 16},
            heal = 1,
            duration = 4,
        },
        ["modifier_void_astral_3"] =
        {
            slow = {-20, -30, -40},
            speed = {10, 15, 20},
            duration = 4
        },
        ["modifier_void_astral_4"] =
        {
            damage = {20, 30},
            delay = 2,
            stun = {0.8, 1.2},
            damage_creeps = 0.33
        },
        ["modifier_void_astral_5"] =
        {
            cast = 0,
            root = 2
        },
        ["modifier_void_astral_6"] =
        {
            duration = 5,
            damage_reduce = -20,
            cd_items = 80
        },
        ["modifier_void_astral_legendary"] =
        {
            duration = 3,
            count = 1,
            damage = 140
        },



        ["modifier_void_pulse_1"] =
        {
            shield = {15, 20, 25},
        },
        ["modifier_void_pulse_2"] =
        {
            spell = {4, 6, 8},
            attack = {8, 12, 16},
            duration = 2
        },
        ["modifier_void_pulse_3"] =
        {
            magic = {4, 6, 8},
            status = {4, 6, 8},
            shield = 2
        },
        ["modifier_void_pulse_4"] =
        {
            damage = {2, 3},
            shield = 40,
            slow = {-20, -30},
            radius = 500,
            interval = 0.5
        },
        ["modifier_void_pulse_5"] =
        {
            damage_reduce = -50,
            duration = 2  
        },
        ["modifier_void_pulse_6"] =
        {
            duration = 3,
            heal = 40,
            cd = -2,
            speed = 40,
            speed_duration = 2,
        },
        ["modifier_void_pulse_legendary"] =
        {
            shield = 10,
            damage = 25,
            creeps = 25
        },



        ["modifier_void_step_1"] =
        {
            damage = {20, 30, 40}
        },
        ["modifier_void_step_2"] =
        {
            cd = {-2, -3, -4}   
        },
        ["modifier_void_step_3"] =
        {
            heal = {20, 30, 40},
            creeps = 3,
            duration = 3
        },
        ["modifier_void_step_4"] =
        {
            max = 4,
            duration = 6,
            damage = {12, 20},
            heal = {-25, -40}
        },
        ["modifier_void_step_5"] =
        {  
            cd = 12,
            range = 300,
            cd_inc = 2,
            stun = 0.5
        },
        ["modifier_void_step_6"] =
        {
            cast = -0.1,
            status = 40,
            duration = 1.5
        },
        ["modifier_void_step_legendary"] =
        {
            cd = 24,
            duration = 6,
            damage = 40,
        },
    },


    npc_dota_hero_ember_spirit =
    {
        ["modifier_ember_chain_1"] =
        {
            duration = {0.3, 0.45, 0.6},
            speed = {-30, -45, -60}
        },
        ["modifier_ember_chain_2"] =
        {
            
        },
        ["modifier_ember_chain_3"] =
        {
            heal = {10, 15, 20},
            damage = {30, 45, 60},
            creeps = 3
        },
        ["modifier_ember_chain_4"] =
        {
            chance = 30,
            bonus = 2,
            damage = {4, 6},
            creeps = 4
        },
        ["modifier_ember_chain_5"] =
        {
            radius = 150,
            range = 50,
            distance = 160,
            duration = 0.3
        },
        ["modifier_ember_chain_6"] =
        {
            cd = -1,
            heal_reduce = -30,
            damage_reduce = -30,
        },
        ["modifier_ember_chain_legendary"] =
        {
            
        },



        ["modifier_ember_fist_1"] =
        {
            
        },
        ["modifier_ember_fist_2"] =
        {
            
        },
        ["modifier_ember_fist_3"] =
        {
        
        },
        ["modifier_ember_fist_4"] =
        {
            
        },
        ["modifier_ember_fist_5"] =
        {
            
        },
        ["modifier_ember_fist_6"] =
        {
            
        },
        ["modifier_ember_fist_legendary"] =
        {
            
        },



        ["modifier_ember_guard_1"] =
        {
            
        },
        ["modifier_ember_guard_2"] =
        {
            
        },
        ["modifier_ember_guard_3"] =
        {
            
        },
        ["modifier_ember_guard_4"] =
        {
            
        },
        ["modifier_ember_guard_5"] =
        {
            
        },
        ["modifier_ember_guard_6"] =
        {
            cd = -3,
            stun = 1.5
        },
        ["modifier_ember_guard_legendary"] =
        {
            damage = 5,
            block = 40,
            shield = 10,
            creeps = 4
        },



        ["modifier_ember_remnant_1"] =
        {
            
        },
        ["modifier_ember_remnant_2"] =
        {
            
        },
        ["modifier_ember_remnant_3"] =
        {
            damage = {40, 60, 80},
            interval = 1,
            radius = 200,
            duration = 10
        },
        ["modifier_ember_remnant_4"] =
        {
            damage = {40, 60},
            stack = {8, 5},
            charge = 1,
            duration = 10
        },
        ["modifier_ember_remnant_5"] =
        {
            
        },
        ["modifier_ember_remnant_6"] =
        {
            cd = 0,
            cast = 0,
            count = 3,
            bkb = 2,
            duration = 2, 
        },
        ["modifier_ember_remnant_legendary"] =
        {
            
        },


    },
    npc_dota_hero_pudge =
    {
        ["modifier_pudge_hook_1"] =
        {
            damage = {6, 9, 12},
            duration = 6
        },
        ["modifier_pudge_hook_2"] =
        {
            cd = {-1, -1.5, -2},
            speed = {40, 60, 80},
            duration = 5
        },
        ["modifier_pudge_hook_3"] =
        {
            heal = {8, 12, 16},
            duration = 5   
        },
        ["modifier_pudge_hook_4"] =
        {
            damage = {8, 12},
            max = 20,
            amp = {8, 12},
            distance = 0,
            is_perma = 1,
            mod_name = "modifier_custom_pudge_meat_hook_legendary"
        },
        ["modifier_pudge_hook_5"] =
        {
            
        },
        ["modifier_pudge_hook_6"] =
        {
            
        },
        ["modifier_pudge_hook_legendary"] =
        {
            cd = -1,
            max = 5,
            damage = 15,
            duration = 12,
            count = 2,
            angle = 5
        },


        ["modifier_pudge_rot_1"] =
        {
            move_slow = {-8, -12, -16},
            attack_slow = {-30, -40, -50}
        },
        ["modifier_pudge_rot_2"] =
        {
            
        },
        ["modifier_pudge_rot_3"] =
        {
            heal = {6, 9, 12},
            heal_creeps = 3
        },
        ["modifier_pudge_rot_4"] =
        {
            timer = 4,
            duration = 3,
            heal = {30, 50},
            damage = {15, 25},
            heal_creeps = 3
        },
        ["modifier_pudge_rot_5"] =
        {
            timer = 4,
            silence = 2.5,
            mana = 2
        },
        ["modifier_pudge_rot_6"] =
        {
            
        },
        ["modifier_pudge_rot_legendary"] =
        {
            damage = 45,
            cost = 2,
            cost_max = 10,
            cost_inc = 1,
            timer = 3,
            radius = 500,
            cd = 3
        },




        ["modifier_pudge_flesh_1"] =
        {
            duration = {1, 1.5, 2},
            heal = {1, 1.5, 2}
        },
        ["modifier_pudge_flesh_2"] =
        {
            
        },
        ["modifier_pudge_flesh_3"] =
        {
            
        },
        ["modifier_pudge_flesh_4"] =
        {
            cd = {10, 6},
            damage = 150,
            heal = 100,
            stun = 0.7
        },
        ["modifier_pudge_flesh_5"] =
        {
            
        },
        ["modifier_pudge_flesh_6"] =
        {
            range = 80,
            duration = 8
        },
        ["modifier_pudge_flesh_legendary"] =
        {
            
        },




        ["modifier_pudge_dismember_1"] =
        {
            
        },
        ["modifier_pudge_dismember_2"] =
        {
           damage = {-10, -15, -20},
           heal = {-20, -30, -40},
           duration = 4 
        },
        ["modifier_pudge_dismember_3"] =
        {
            
        },
        ["modifier_pudge_dismember_4"] =
        {
            
        },
        ["modifier_pudge_dismember_5"] =
        {
            
        },
        ["modifier_pudge_dismember_6"] =
        {
            
        },
        ["modifier_pudge_dismember_legendary"] =
        {
            
        },
    },
    npc_dota_hero_hoodwink =
    {

        ["modifier_hoodwink_acorn_1"] =
        {
        },
        ["modifier_hoodwink_acorn_2"] =
        {
            chance = 20,
            crit = {140, 160, 180}   
        },
        ["modifier_hoodwink_acorn_3"] =
        {
            duration = {1, 1.5, 2},
            attack = {-40, -60, -80},
            turn = -50
        },
        ["modifier_hoodwink_acorn_4"] =
        {
            cd = {-2, -3},
            armor = {-2, -3},
            max = 8,
            duration = 5,
            armor_duration = 4,
        },
        ["modifier_hoodwink_acorn_5"] =
        {
            
        },
        ["modifier_hoodwink_acorn_6"] =
        {
            cast_range = 200,
            attack_range = 200,
            duration = 5,            
        },
        ["modifier_hoodwink_acorn_legendary"] =
        {
            
        },



        ["modifier_hoodwink_bush_1"] =
        {
            cd = {-3, -4, -5}
        },
        ["modifier_hoodwink_bush_2"] =
        {
            
        },
        ["modifier_hoodwink_bush_3"] =
        {
            
        },
        ["modifier_hoodwink_bush_4"] =
        {
            
        },
        ["modifier_hoodwink_bush_5"] =
        {
            
        },
        ["modifier_hoodwink_bush_6"] =
        {
            
        },
        ["modifier_hoodwink_bush_legendary"] =
        {
            cd = 50,
            mana = 50,
            max = 6,
            vision = 600,
            radius = 400,
        },  



        ["modifier_hoodwink_scurry_1"] =
        {
            cd = {-1, -2, -3},
            move = {20, 30, 40} 
        },
        ["modifier_hoodwink_scurry_2"] =
        {
           heal = {1, 1.5, 2},
           damage_reduce = {-10, -15, -20} 
        },
        ["modifier_hoodwink_scurry_3"] =
        {
            speed = {40, 60, 80}
        },
        ["modifier_hoodwink_scurry_4"] =
        {
            damage = 3,
            chance = {30, 50},
            creeps = 3,
            distance = 40,
            duration = 0.15
        },
        ["modifier_hoodwink_scurry_5"] =
        {
            duration = 1,
            range = 200,
        },
        ["modifier_hoodwink_scurry_6"] =
        {
            shield = 15,
            status = 20,
            cd = 3,
            duration = 5,
        },
        ["modifier_hoodwink_scurry_legendary"] =
        {
            distance = 700,
            bva = 1.000,
            duration = 3,
            lifesteal = 50,
            creeps = 3,
            max = 6
        },



        ["modifier_hoodwink_sharp_1"] =
        {
            heal = {20, 30, 40},
            duration = 5,
            creeps = 4,
        },
        ["modifier_hoodwink_sharp_2"] =
        {
            
        },
        ["modifier_hoodwink_sharp_3"] =
        {
            damage = {20, 30, 40},
            duration = 5,
            interval = 1,
        },
        ["modifier_hoodwink_sharp_4"] =
        {
            
        },
        ["modifier_hoodwink_sharp_5"] =
        {
            max = 150,
            damage = 20,
            cd = 25,
        },
        ["modifier_hoodwink_sharp_6"] =
        {
            bkb = 2,
            duration = 3,
            distance = 200
        },
        ["modifier_hoodwink_sharp_legendary"] =
        {
            max = 100,
            damage = 20,
            stack = 15
        },
    },
    npc_dota_hero_skeleton_king =
    {

        ["modifier_skeleton_blast_1"] =
        {
            slow = {-15, -20, -25},
            duration = {1, 2, 3}
        },
        ["modifier_skeleton_blast_2"] =
        {
            speed = {10, 15, 20},
            move = {10, 15, 20},
            bonus = 3,
            duration = 4
        },
        ["modifier_skeleton_blast_3"] =
        {
            damage_init = {40, 60, 80},
            damage_inc = {10, 15, 20}
        },
        ["modifier_skeleton_blast_4"] =
        {
            stun = {0.3, 0.5},
            damage = {30, 50},
            duration = 4,
            aoe_damage = 50,
            radius = 300
        },
        ["modifier_skeleton_blast_5"] =
        {
            range = 150,
            cast = -0.2,
            cd = -1,
        },
        ["modifier_skeleton_blast_6"] =
        {
            heal = 25,
            heal_reduce = -40,
            damage = -20
        },
        ["modifier_skeleton_blast_legendary"] =
        {
            
        },



        ["modifier_skeleton_vampiric_1"] =
        {
            heal = {10, 15, 20}
        },
        ["modifier_skeleton_vampiric_2"] =
        {
            armor = {-1, -1.5, -2},
            self_armor = {4, 6, 8},
            max = 4,
            duration = 5
        },
        ["modifier_skeleton_vampiric_3"] =
        {
            move = {2, 3, 4},
            status = {2, 3, 4},
            radius = 800,
            max = 5
        },
        ["modifier_skeleton_vampiric_4"] =
        {
            speed = {30, 50},
            damage = {0.2, 0.3},
            health = {3, 5},
            stack = 130,
            is_perma = 1,
            mod_name = "modifier_skeleton_king_vampiric_aura_stats"
        },
        ["modifier_skeleton_vampiric_5"] =
        {
            aoe = 300,
            damage = 60,
            damage_inc = 3,
            max = 8,
            duration = 8,
            radius = 300
        },
        ["modifier_skeleton_vampiric_6"] =
        {
            shield = 3,
            max = 5,
            duration = 15,
            damage = -3
        },
        ["modifier_skeleton_vampiric_legendary"] =
        {
            count = 5,
            crit = 1,
            stun = 1,
            reinc = 3,
            duration = 6,
            slow = -25,
            slow_duration = 2,
            stats = 75
        },



        ["modifier_skeleton_strike_1"] =
        {
        },
        ["modifier_skeleton_strike_2"] =
        {
        },
        ["modifier_skeleton_strike_3"] =
        {
            
        },
        ["modifier_skeleton_strike_4"] =
        {
        },
        ["modifier_skeleton_strike_5"] =
        {
        },
        ["modifier_skeleton_strike_6"] =
        {
            duration = 2.5,
            speed = 50,
            cd = 12
        },
        ["modifier_skeleton_strike_legendary"] =
        {
        },



        ["modifier_skeleton_reincarnation_1"] =
        {
            
            slow = {-10, -15, -20},
            attack = {-20, -30, -40},
            radius = 700
        },
        ["modifier_skeleton_reincarnation_2"] =
        {
            
            damage = {6, 9, 12}
        },
        ["modifier_skeleton_reincarnation_3"] =
        {
            str = {4, 6, 8},
            armor = {2, 3, 4},
            bonus = 2
        },
        ["modifier_skeleton_reincarnation_4"] =
        {
            damage = {2, 3},
            radius = 500,
            heal = {2, 3},
            creeps = 3,
            interval = 1
        },
        ["modifier_skeleton_reincarnation_5"] =
        {
            
            delay = -1,
            silence = 5,
            duration = 0.4,
            distance = 600
        },
        ["modifier_skeleton_reincarnation_6"] =
        {  
            str = 4,
            max = 8,
            cd = -15,
            is_perma = 1,
            mod_name = "modifier_skeleton_king_reincarnation_custom_str"
        },
        ["modifier_skeleton_reincarnation_legendary"] =
        {
            cd = 25,
            duration = 3,
            damage = 6,
            damage_reduce = -35,
            cd_inc = 50
        },
    },


    npc_dota_hero_lina =
    {

        ["modifier_lina_dragon_1"] =
        {
            resist = {-4, -6, -8},
            duration = 7,
            max = 3,
        },
        ["modifier_lina_dragon_2"] =
        {
            mana = 10,
            chance = {20, 30, 40}
        },
        ["modifier_lina_dragon_3"] =
        {
            
        },
        ["modifier_lina_dragon_4"] =
        {
            damage = {2, 3},
            duration = {1, 2},
            creeps = 3,
        },
        ["modifier_lina_dragon_5"] =
        {
            
        },
        ["modifier_lina_dragon_6"] =
        {
            slow = -25,
            duration = 5,
            max = 3,
            stun = 1.2,
            stack_duration = 10
        },
        ["modifier_lina_dragon_legendary"] =
        {
            
        },



        ["modifier_lina_array_1"] =
        {
            
        },
        ["modifier_lina_array_2"] =
        {
            
        },
        ["modifier_lina_array_3"] =
        {
            
        },
        ["modifier_lina_array_4"] =
        {
            
        },
        ["modifier_lina_array_5"] =
        {
            
        },
        ["modifier_lina_array_6"] =
        {
            
        },
        ["modifier_lina_array_legendary"] =
        {
            
        },



        ["modifier_lina_soul_1"] =
        {
            move = {0.5, 1, 1.5},
            speed = {6, 9, 12}
        },
        ["modifier_lina_soul_2"] =
        {
            
        },
        ["modifier_lina_soul_3"] =
        {
            
        },
        ["modifier_lina_soul_4"] =
        {
            chance = {20, 35},
            duration = 4,
            damage = 30,
            slow = -80,
            slow_duration = 1
        },
        ["modifier_lina_soul_5"] =
        {
            max = 3,
            move = 100,
            move_real = 650,
        },
        ["modifier_lina_soul_6"] =
        {
            
        },
        ["modifier_lina_soul_legendary"] =
        {
            mana = 50,
            duration = 0.4,
            min_distance = 100,
            range = 500,
            damage = 160,
            cast = 3,
            cd = 3
        },



        ["modifier_lina_laguna_1"] =
        {
            
        },
        ["modifier_lina_laguna_2"] =
        {
            damage = {50, 75, 100}
        },
        ["modifier_lina_laguna_3"] =
        {
            heal = {6, 9, 12},
            active = 3,
            duration = 5,
            creeps = 3,
        },
        ["modifier_lina_laguna_4"] =
        {
            count = 350,
            cd = {-1, -1.5},
            damage = {1, 2},
            duration = 12,
            creeps = 4,
        },
        ["modifier_lina_laguna_5"] =
        {
            
        },
        ["modifier_lina_laguna_6"] =
        {
            
        },
        ["modifier_lina_laguna_legendary"] =
        {
            damage = 20,
            count = 350,
            radius = 800,
            creeps = 4,
            interval = 0.4,
            delay = 0.4,
            aoe = 125
        },
    },

    npc_dota_hero_troll_warlord =
    {
        ["modifier_troll_rage_1"] =
        {
            chance = {8, 12, 16},
            speed = {-30, -45, -60}
        },
        ["modifier_troll_rage_2"] =
        {
            speed = {20, 30, 40},
            slow = {-10, -15, -20},
            duration = 2
        },
        ["modifier_troll_rage_3"] =
        {
            damage = {20, 30, 40},
            chance = 40
        },
        ["modifier_troll_rage_4"] =
        {
            radius = 300,
            chance = {20, 30},
            range = 2
        },
        ["modifier_troll_rage_5"] =
        {
            cd = 10,
            max = 5,
            speed = -100,
            silence = 2,
            duration = 5,
        },
        ["modifier_troll_rage_6"] =
        {
            damage = 12,
            heal = 35,
            max = 6,
        },
        ["modifier_troll_rage_legendary"] =
        {
            range = 50,
            root = 50,
        },



        ["modifier_troll_axes_1"] =
        {
            cd = {-1, -1.5, -2},
            mana = {-20, -30, -40}
        },
        ["modifier_troll_axes_2"] =
        {
            heal = {15, 20, 25},
            heal_reduce = {-15, -20, -25},
            creeps = 3
        },
        ["modifier_troll_axes_3"] =
        {
            max = 3,
            damage = {40, 60, 80},
            radius = 300,
            duration = 6   
        },
        ["modifier_troll_axes_4"] =
        {
            damage = {6, 10},
            max = 12,
            attacks = 5,
            cd = 10,
            stun = {0.6, 1},
            is_perma = 1,
            mod_name = "modifier_troll_warlord_whirling_axes_perma_melee"
        },
        ["modifier_troll_axes_5"] =
        {
            slow = -10,
            cd = 7,
            distance = 350,
            duration = 0.2
        },
        ["modifier_troll_axes_6"] =
        {
            speed = 20,
            distance = 280,
            duration = 0.25
        },
        ["modifier_troll_axes_legendary"] =
        {
            max = 6,
            damage = 25,
            cd = -0.4,
            duration = 6
        },



        ["modifier_troll_fervor_1"] =
        {
            move = {1, 1.5, 2},
            status = {1, 1.5, 2}
        },
        ["modifier_troll_fervor_2"] =
        {
            
        },
        ["modifier_troll_fervor_3"] =
        {
            
        },
        ["modifier_troll_fervor_4"] =
        {
            bva = 1.2,
            stun = 0.3,
            chance = 15,
            duration = {4, 6}
        },
        ["modifier_troll_fervor_5"] =
        {
            str = 2,
            bkb = 2,
        },
        ["modifier_troll_fervor_6"] =
        {
            range = 60,
            speed = 5,
            stack = 2,
        },
        ["modifier_troll_fervor_legendary"] =
        {
            cd = 16,
            duration = 6,
            damage = 15,
            damage_duration = 5,
            timer = 2,
            stun = 0.5
        },



        ["modifier_troll_trance_1"] =
        {
            duration = {1, 1.5, 2}
        },
        ["modifier_troll_trance_2"] =
        {
            damage = {10, 15, 20}
        },
        ["modifier_troll_trance_3"] =
        {
            heal = {4, 6, 8}   
        },
        ["modifier_troll_trance_4"] =
        {
            radius = 500,
            slow = {-15, -25},
            damage = {6, 10},
            interval = 0.5
        },
        ["modifier_troll_trance_5"] =
        {
            duration = 2,
            cd = 40
        },
        ["modifier_troll_trance_6"] =
        {
            cd = -20,
            count = 1
        },
        ["modifier_troll_trance_legendary"] =
        {
            cd = 60,
            duration = 60,
            range = 750
        },
    },
    npc_dota_hero_axe =
    {
        ["modifier_axe_call_1"] =
        {
            armor = {-3, -4, -5},
            damage_return = {20, 30, 40},
            duration = 5
        },
        ["modifier_axe_call_2"] =
        {
            heal = {6, 9, 12},
            duration = 4
        },
        ["modifier_axe_call_3"] =
        {
            speed = {40, 60, 80}
        },
        ["modifier_axe_call_4"] =
        {
            damage = {12, 20},
            heal = 50,
        },
        ["modifier_axe_call_5"] =
        {
            cast = -0.3,
            damage_reduce = -35,
            status = 35,
        },
        ["modifier_axe_call_6"] =
        {
            duration = 1.5,
            cd = 15
        },
        ["modifier_axe_call_legendary"] =
        {
            speed = 40,
            duration = 2.5,
        },



        ["modifier_axe_hunger_1"] =
        {
            damage = {1, 1.5, 2}
        },
        ["modifier_axe_hunger_2"] =
        {
            reduce_attack = {-4, -6, -8},
            reduce_magic = {-8, -12, -16}
        },
        ["modifier_axe_hunger_3"] =
        {
            slow = {-5, -10, -15},
            speed = {10, 15, 20},
        },
        ["modifier_axe_hunger_4"] =
        {
            armor = 1,
            duration = {6, 10},  
        },
        ["modifier_axe_hunger_5"] =
        {
            heal = 60,
        },
        ["modifier_axe_hunger_6"] =
        {
            cd = -1,
            silence = 2,
            timer = 5,
        },
        ["modifier_axe_hunger_legendary"] =
        {
            duration = 3,
            timer = 3,
            multi = 1,
            radius = 350,
            max = 6,
        },



        ["modifier_axe_helix_1"] =
        {
            damage = {30, 45, 60},  
        },
        ["modifier_axe_helix_2"] =
        {
            range = {40, 60, 80},
            slow = {-15, -20, -25},
            duration = 3
        },
        ["modifier_axe_helix_3"] =
        {
            duration = 4,
            max = 2,
            armor = {3, 4, 5},
            move = {10, 15, 20}
        },
        ["modifier_axe_helix_4"] =
        {
            count = {6, 4},
            max = 4,
            duration = 5,
            speed = {12, 20}
        },
        ["modifier_axe_helix_5"] =
        {
            heal = 2,
            health = 40,
            count = -1,
            bonus = 1,
        },
        ["modifier_axe_helix_6"] =
        {
            radius = 120,  
            pull_duration = 0.2,
            cd = 12,
            root = 2,
        },
        ["modifier_axe_helix_legendary"] =
        {
            cd = 5,
            interval = 0.3,
            count = 4,
            timer = 4,
            max = 3,
            status = 70,
        },



        ["modifier_axe_culling_1"] =
        {
            str_pct = {4, 6, 8},
            str = {1, 1.5, 2}
        },
        ["modifier_axe_culling_2"] =
        {
            damage = {1.5, 2, 2.5},
            heal = 100  
        },
        ["modifier_axe_culling_3"] =
        {
            damage = {60, 90, 120},
            range = {80, 120, 160},
        },
        ["modifier_axe_culling_4"] =
        {
            damage = {1, 1.5},
            heal_reduce = {-3, -5},
            max = 8,
            duration = 6,
        },
        ["modifier_axe_culling_5"] =
        {
            cast = -0.15,
            radius = 600,
            status = 35,
            health = 50,
            cd = -8
        },
        ["modifier_axe_culling_6"] =
        {
            duration = 5,
            damage = 2.5,
            heal = 30,
            heal_creeps = 0.25,
            max = 8,
            is_perma = 1,
            mod_name = "modifier_axe_culling_blade_custom_kills"
        },
        ["modifier_axe_culling_legendary"] =
        {
            damage = 8,
            cd = 15,
            cd_low = 4,
            health = 50,
            speed = 40,
            duration = 5,
        },
    },
    npc_dota_hero_alchemist =
    {
        ["modifier_alchemist_spray_1"] =
        {
            cd = {-2, -3, -4},
            mana = {-30, -45, -60},
        },
        ["modifier_alchemist_spray_2"] =
        {
            heal = {15, 20, 25},
            heal_reduce = {-10, -15, -20},
            heal_creeps = 3
        },
        ["modifier_alchemist_spray_3"] =
        {
            damage = {20, 30, 40},
            armor =  {-2, -3, -4}
        },
        ["modifier_alchemist_spray_4"] =
        {
            armor = {-0.8, -1.2},
            damage = {10, 15},
            interval = 0.5
        },
        ["modifier_alchemist_spray_5"] =
        {
            max = 2,
            duration = 1,
        },
        ["modifier_alchemist_spray_6"] =
        {
            radius = 80,
            timer = 4,
            silence = 2
        },
        ["modifier_alchemist_spray_legendary"] =
        {
            delay = 1.8,
            slow = -25,
            damage_reduce = -15,
            damage = 70
        },



        ["modifier_alchemist_unstable_1"] =
        {
            speed = {6, 9, 12},
            status = {10, 15, 20}
        },
        ["modifier_alchemist_unstable_2"] =
        {
            heal = {2, 3, 4},
            mana = {1, 1.5, 2}
        },
        ["modifier_alchemist_unstable_3"] =
        {
            damage = {2, 3, 4},
            duration = 6,
            radius = 450,
            interval = 0.5
        },
        ["modifier_alchemist_unstable_4"] =
        {
            damage = {15, 25},
            cd = {-2, -3},
            duration = 6,
            delay = 4
        },
        ["modifier_alchemist_unstable_5"] =
        {
            range = 300,
            duration = 0.2,
            radius = 350,
            root = 1.5
        },
        ["modifier_alchemist_unstable_6"] =
        {
            delay = 4,
        },
        ["modifier_alchemist_unstable_legendary"] =
        {
            damage = 40,
            shield = 50,
            duration = 6,
            damage_creeps = 0.33
        },



        ["modifier_alchemist_greed_1"] =
        {
            gold = {2, 3, 4},
            blue = {2, 3, 4},   
        },
        ["modifier_alchemist_greed_2"] =
        {
            max = 5,
            damage = {80, 120, 160},
            gold = {20, 30, 40},
            creeps = 4
        },
        ["modifier_alchemist_greed_3"] =
        {
            stats = 1,
            max = {10, 15, 20},
            gold = 100
        },
        ["modifier_alchemist_greed_4"] =
        {
            speed = {2, 3},
            damage = {40, 70},
            max = 25,
            is_perma = 1,
            mod_name = "modifier_alchemist_goblins_greed_custom_runes",  
        },
        ["modifier_alchemist_greed_5"] =
        {
            cast = 1.5,
            cd = 100,
            duration = 30,
            speed = 100,
            arcane = 20,
            regen = 2,
            damage = 25,
            status = 15,
        },
        ["modifier_alchemist_greed_6"] =
        {
            cd = 40,
            duration = 2,
            radius = 600,
            heal = 15,
        },
        ["modifier_alchemist_greed_legendary"] =
        {
            
        },



        ["modifier_alchemist_rage_1"] =
        {
            cd = {-8, -12, -16}
        },
        ["modifier_alchemist_rage_2"] =
        {
            range = {40, 60, 80},
            cleave = {20, 30, 40}
        },
        ["modifier_alchemist_rage_3"] =
        {
            chance = 20,
            armor = {4, 6, 8},
            duration = 4
        },
        ["modifier_alchemist_rage_4"] =
        {
            heal = {8, 12},
            speed = {8, 12},
            max = 10,
            duration = 4
        },
        ["modifier_alchemist_rage_5"] =
        {
            speed = 40,
            duration = 4,
            slow = -25,
            slow_duration = 3
        },
        ["modifier_alchemist_rage_6"] =
        {
            duration = 4,
            damage = -50,
            mana = 0
        },
        ["modifier_alchemist_rage_legendary"] =
        {
            bva = -0.2,
            status = 35,
            bonus_range = 50,
            cd = 1.5
        },

    },
    npc_dota_hero_ogre_magi =
    {
        ["modifier_ogremagi_blast_1"] =
        {
            
        },
        ["modifier_ogremagi_blast_2"] =
        {
            
        },
        ["modifier_ogremagi_blast_3"] =
        {
            
        },
        ["modifier_ogremagi_blast_4"] =
        {
            
        },
        ["modifier_ogremagi_blast_5"] =
        {
            
        },
        ["modifier_ogremagi_blast_6"] =
        {
            
        },
        ["modifier_ogremagi_blast_7"] =
        {
            
        },



        ["modifier_ogremagi_ignite_1"] =
        {
            
        },
        ["modifier_ogremagi_ignite_2"] =
        {
            
        },
        ["modifier_ogremagi_ignite_3"] =
        {
            
        },
        ["modifier_ogremagi_ignite_4"] =
        {
            
        },
        ["modifier_ogremagi_ignite_5"] =
        {
            
        },
        ["modifier_ogremagi_ignite_6"] =
        {
            
        },
        ["modifier_ogremagi_ignite_7"] =
        {
            
        },



        ["modifier_ogremagi_bloodlust_1"] =
        {
            
        },
        ["modifier_ogremagi_bloodlust_2"] =
        {
            
        },
        ["modifier_ogremagi_bloodlust_3"] =
        {
            
        },
        ["modifier_ogremagi_bloodlust_4"] =
        {
            
        },
        ["modifier_ogremagi_bloodlust_5"] =
        {
            
        },
        ["modifier_ogremagi_bloodlust_6"] =
        {
            
        },
        ["modifier_ogremagi_bloodlust_7"] =
        {
            
        },



        ["modifier_ogremagi_multi_1"] =
        {
            
        },
        ["modifier_ogremagi_multi_2"] =
        {
            
        },
        ["modifier_ogremagi_multi_3"] =
        {
            
        },
        ["modifier_ogremagi_multi_4"] =
        {
            damage = {80, 130},
            max = 6,
            range = 250,
            radius = 250,
            duration = 8
        },
        ["modifier_ogremagi_multi_5"] =
        {
            
        },
        ["modifier_ogremagi_multi_6"] =
        {
            
        },
        ["modifier_ogremagi_multi_7"] =
        {
            duration = 3,
            cd = 18,
            spells = 6,
            radius = 1000
        },
    },
    npc_dota_hero_antimage =
    {
        ["modifier_antimage_break_1"] =
        {
            cleave = {20, 30, 40},
            armor = {-4, -6, -8},
            duration = 3
        },
        ["modifier_antimage_break_2"] =
        {
            heal = {10, 15, 20}, 
            bonus = 3
        },
        ["modifier_antimage_break_3"] =
        {
            damage_reduce = {-1, -1.5, -2},
            duration = 2,
            max = 8
        },
        ["modifier_antimage_break_4"] =
        {
            mana_burn = {1.2, 2},
            agility = {30, 50},
            duration = 5
        },
        ["modifier_antimage_break_5"] =
        {
            silence = 1.7,
            cd = 10,
            range = 60
        },
        ["modifier_antimage_break_6"] =
        {
            mana = 50,
            break_duration = 3,
            heal_reduce = -30,
            cd = 15,
            duration = 2
        },
        ["modifier_antimage_break_7"] =
        {
            cd = 15,
            duration = 5,
            damage = 130,
            slow = -40, 
            slow_duration = 1
        },



        ["modifier_antimage_blink_1"] =
        {
            speed = {30, 45, 60},
            slow = {-10, -15, -20},
            duration = 3,
            slow_duration = 2,
        },
        ["modifier_antimage_blink_2"] =
        {
            duration = 3,
            speed = {10, 15, 20},
            armor = {6, 9, 12},
        },
        ["modifier_antimage_blink_3"] =
        {
            cd = {-1, -1.5, -2}  
        },
        ["modifier_antimage_blink_4"] =
        {
            damage = {30, 50},
            duration = 3,
            heal = {0.8, 1.2}
        },
        ["modifier_antimage_blink_5"] =
        {
            duration = 6,
            radius = 265,
            speed = -80,
            status = 20
        },
        ["modifier_antimage_blink_6"] =
        {
            count = 3,
            heal = 10,
            cast = -0.2
        },
        ["modifier_antimage_blink_7"] =
        {
            cd = 45,
            mana = 30,
            damage = 50,
            distance = 350,
            duration = 0.2,
            turn_slow = -50,
            turn_slow_duration = 2,
        },



        ["modifier_antimage_counter_1"] =
        {
            damage = {2, 3, 4},
            radius = 500,
            interval = 0.5
        },
        ["modifier_antimage_counter_2"] =
        {
            slow = {-15, -20, -25},
            duration = 4,
            attack = {-30, -45, -60},
            radius = 600
        },
        ["modifier_antimage_counter_3"] =
        {
            heal = {6, 9, 12},
            duration = 4,
          --  bonus = 3
        },
        ["modifier_antimage_counter_4"] =
        {
            radius = 350,
            damage = {10, 15},
            duration = 3,
            heal = 50
        },
        ["modifier_antimage_counter_5"] =
        {
            cd = -1,
            duration = 0.3,
            status = 50
        },
        ["modifier_antimage_counter_6"] =
        {
            health = 30,
            damage_reduce = -30,
        },
        ["modifier_antimage_counter_7"] =
        {
            duration = 2.3,
            shield = 10,
            radius = 500,
            stun = 1.2,
            damage = 40,
            damage_duration = 4
        },



        ["modifier_antimage_void_1"] =
        {
            damage = {8, 12, 16},
            cd = {-4, -6, -8},
        },
        ["modifier_antimage_void_2"] =
        {
            mana = {1, 1.5, 2},
            interval = 0.5,
            radius = 600,
            str = {-6, -9, -12},
        },
        ["modifier_antimage_void_3"] =
        {
            speed = {10, 15, 20},
            max = 4,
            duration = 8,
            radius = 600,
        },
        ["modifier_antimage_void_4"] =
        {
            damage = {2.5, 4},
            mana = {5, 8},
            max = 8,
            duration = 10
        },
        ["modifier_antimage_void_5"] =
        {
            radius = 600,
            stun = 0.8,
            heal = 15,
            cd = 8
        },
        ["modifier_antimage_void_6"] =
        {
            range = 200,
            duration = 3,
            slow = -80
        },
        ["modifier_antimage_void_7"] =
        {
            cd = 16,
            duration = 5,
            mana = 15,
        },
    },
    npc_dota_hero_primal_beast =
    {
        ["modifier_primal_beast_onslaught_1"] =
        {
            
        },
        ["modifier_primal_beast_onslaught_2"] =
        {
            
        },
        ["modifier_primal_beast_onslaught_3"] =
        {
            
        },
        ["modifier_primal_beast_onslaught_4"] =
        {
            max = 15,
            damage = {10, 15},
            spell = {8, 12},
            is_perma = 1,
            mod_name = "modifier_primal_beast_onslaught_custom_stacks"
        },
        ["modifier_primal_beast_onslaught_5"] =
        {
            
        },
        ["modifier_primal_beast_onslaught_6"] =
        {
            
        },
        ["modifier_primal_beast_onslaught_7"] =
        {
            
        },



        ["modifier_primal_beast_trample_1"] =
        {
            
        },
        ["modifier_primal_beast_trample_2"] =
        {
            
        },
        ["modifier_primal_beast_trample_3"] =
        {
            duration = {1, 1.5, 2}
        },
        ["modifier_primal_beast_trample_4"] =
        {
            
        },
        ["modifier_primal_beast_trample_5"] =
        {
            
        },
        ["modifier_primal_beast_trample_6"] =
        {
            
        },
        ["modifier_primal_beast_trample_7"] =
        {
            cd = 1,
            distance = 350
        },



        ["modifier_primal_beast_uproar_1"] =
        {
          
            speed = {40, 60, 80},
            range = {40, 60, 80},
            duration = 3,  
        },
        ["modifier_primal_beast_uproar_2"] =
        {
            
        },
        ["modifier_primal_beast_uproar_3"] =
        {
        },
        ["modifier_primal_beast_uproar_4"] =
        {
            
        },
        ["modifier_primal_beast_uproar_5"] =
        {
            slow = -4,
            duration = 2,
            root = 1.5
        },
        ["modifier_primal_beast_uproar_6"] =
        {
            
        },
        ["modifier_primal_beast_uproar_7"] =
        {
            cd = 25,
            duration = 2.8
        },



        ["modifier_primal_beast_pulverize_1"] =
        {
            
        },
        ["modifier_primal_beast_pulverize_2"] =
        {
            
        },
        ["modifier_primal_beast_pulverize_3"] =
        {
            
        },
        ["modifier_primal_beast_pulverize_4"] =
        {
            
        },
        ["modifier_primal_beast_pulverize_5"] =
        {
            
        },
        ["modifier_primal_beast_pulverize_6"] =
        {
            
        },
        ["modifier_primal_beast_pulverize_7"] =
        {
            max = 5,
            count = 1,
            uproar = 5,
            trample = 4,
            duration = 5,
        },

    },
    npc_dota_hero_marci =
    {
        ["modifier_marci_dispose_1"] =
        {
            damage = {50, 75, 100}
        },
        ["modifier_marci_dispose_2"] =
        {
            
        },
        ["modifier_marci_dispose_3"] =
        {
            chance = {15, 20, 25},
            damage = 50,
            duration = 1,
        },
        ["modifier_marci_dispose_4"] =
        {
            
        },
        ["modifier_marci_dispose_5"] =
        {
            str = 15,
            duration = 10
        },
        ["modifier_marci_dispose_6"] =
        {
           mana = 30,
           status = 20,
           move = 20,
           duration = 4, 
        },
        ["modifier_marci_dispose_7"] =
        {
            
        },



        ["modifier_marci_rebound_1"] =
        {
            
        },
        ["modifier_marci_rebound_2"] =
        {
            
        },
        ["modifier_marci_rebound_3"] =
        {
            
        },
        ["modifier_marci_rebound_4"] =
        {
           
            cd = {-0.2, -0.3},
            speed = 150,
            duration = {3, 5} 
        },
        ["modifier_marci_rebound_5"] =
        {
            
        },
        ["modifier_marci_rebound_6"] =
        {
            
        },
        ["modifier_marci_rebound_7"] =
        {
            damage = 25,
            duration = 6,
        },



        ["modifier_marci_sidekick_1"] =
        {
            
        },
        ["modifier_marci_sidekick_2"] =
        {
            heal = {10, 15, 20},            
            cast_heal = {8, 12, 16},
        },
        ["modifier_marci_sidekick_3"] =
        {
            cd = {-1, -1.5, -2},
            damage = {10, 15, 20},

        },
        ["modifier_marci_sidekick_4"] =
        {
        },
        ["modifier_marci_sidekick_5"] =
        {
            duration = 1,
            heal = 25,
            cd = 15,
        },
        ["modifier_marci_sidekick_6"] =
        {
            duration = 2,
            speed = 550,
        },
        ["modifier_marci_sidekick_7"] =
        {
            
        },



        ["modifier_marci_unleash_1"] =
        {
            
        },
        ["modifier_marci_unleash_2"] =
        {
            
        },
        ["modifier_marci_unleash_3"] =
        {
            
        },
        ["modifier_marci_unleash_4"] =
        {
            damage = {60, 90},
            max = 6,
            duration = 5
        },
        ["modifier_marci_unleash_5"] =
        {
            
        },
        ["modifier_marci_unleash_6"] =
        {
            
        },
        ["modifier_marci_unleash_7"] =
        {
            
        },

    },
    npc_dota_hero_templar_assassin =
    {

        ["modifier_templar_assassin_refraction_1"] =
        {
            
        },
        ["modifier_templar_assassin_refraction_2"] =
        {
            
        },
        ["modifier_templar_assassin_refraction_3"] =
        {
            
        },
        ["modifier_templar_assassin_refraction_4"] =
        {
            
        },
        ["modifier_templar_assassin_refraction_5"] =
        {
            
        },
        ["modifier_templar_assassin_refraction_6"] =
        {
            
        },
        ["modifier_templar_assassin_refraction_7"] =
        {
            
        },




        ["modifier_templar_assassin_meld_1"] =
        {
            damage = {30, 45, 60},
            armor = {-2, -3, -4}
        },
        ["modifier_templar_assassin_meld_2"] =
        {
            heal = {20, 30, 40},
            duration = 4
        },
        ["modifier_templar_assassin_meld_3"] =
        {
            speed = {40, 60, 80},
            duration = 3
        },
        ["modifier_templar_assassin_meld_4"] =
        {
            armor = {-0.5, -1},
            max = 8,
            cd = {-0.2, -0.3},
            duration = 6,
        },
        ["modifier_templar_assassin_meld_5"] =
        {
            range = 120,
            distance = 250,
        },
        ["modifier_templar_assassin_meld_6"] =
        {
            armor = -1,
            max = 8,
            stun = 1,
            is_perma = 1,
            mod_name = "modifier_templar_assassin_meld_custom_kills"
        },
        ["modifier_templar_assassin_meld_7"] =
        {
            
        },




        ["modifier_templar_assassin_psiblades_1"] =
        {
            
        },
        ["modifier_templar_assassin_psiblades_2"] =
        {
            
        },
        ["modifier_templar_assassin_psiblades_3"] =
        {
            slow = {-4, -6, -8},
            attack = {-6, -9, -12},
            duration = 5,
            max = 5
        },
        ["modifier_templar_assassin_psiblades_4"] =
        {
            
            stun = 0.5,
            chance = {12, 20},
            duration = 5,
        },
        ["modifier_templar_assassin_psiblades_5"] =
        {
        },
        ["modifier_templar_assassin_psiblades_6"] =
        {
            
        },
        ["modifier_templar_assassin_psiblades_7"] =
        {
            cd = 10,
            attacks = 5,
            stun = 0.2,
            radius = 250,
            castrange = 400,
            duration = 8,
            heal = 40,
        },




        ["modifier_templar_assassin_psionic_1"] =
        {
            charge = {-0.5, -0.75, -1},
            cd = {-30, -40, -50}
        },
        ["modifier_templar_assassin_psionic_2"] =
        {
            damage = {8, 12, 16},
            duration = 5,
        },
        ["modifier_templar_assassin_psionic_3"] =
        {
            duration = 5,
            heal = {6, 9, 12},
            heal_reduce = {-15, -20, -25}
        },
        ["modifier_templar_assassin_psionic_4"] =
        {
            
        },
        ["modifier_templar_assassin_psionic_5"] =
        {
            stun = 1.5,
            duration = 2,
            cd = 12,
        },
        ["modifier_templar_assassin_psionic_6"] =
        {
            duration = 20,
            cast = 0,
            move = 12
        },
        ["modifier_templar_assassin_psionic_7"] =
        {
            distance = 150,
        },

    },
    npc_dota_hero_bloodseeker =
    {
        ["modifier_bloodseeker_bloodrage_1"] =
        {
            
        },
        ["modifier_bloodseeker_bloodrage_2"] =
        {
            speed = {20, 30, 40},
            damage = {4, 6, 8},
        },
        ["modifier_bloodseeker_bloodrage_3"] =
        {
            move = {-2, -3, -4},
            attack = {-4, -6, -8},
            max = 6,
            duration = 4,
        },
        ["modifier_bloodseeker_bloodrage_4"] =
        {   
            duration = 5,
            damage = {10, 15},
            heal = 50,
            interval = 0.5,
        },
        ["modifier_bloodseeker_bloodrage_5"] =
        {
            duration = 8,
            max = 8,
            health = 10,
            status = 25,
        },
        ["modifier_bloodseeker_bloodrage_6"] =
        {
            health = 30,
            damage_reduce = -15,
            heal = 1.5,
        },
        ["modifier_bloodseeker_bloodrage_7"] =
        {
            speed = 150,
            damage = 30,
            max = 10,
            max_timer = 10,
            taunt = 2,
            rage_fill = 25,
            rage_decay = -20,
            radius = 1000,
            cd = 2
        },



        ["modifier_bloodseeker_bloodrite_1"] =
        {
            damage = {6, 9, 12},
            duration = 6
        },
        ["modifier_bloodseeker_bloodrite_2"] =
        {
            heal = {15, 20, 25}
        },
        ["modifier_bloodseeker_bloodrite_3"] =
        {
            cd = {-2, -3, -4},
            mana = {-40, -60, -80}
        },
        ["modifier_bloodseeker_bloodrite_4"] =
        {
            range = 150,
            str = {10, 15},
            taunt = {1, 1.5},
            duration = 6
        },
        ["modifier_bloodseeker_bloodrite_5"] =
        {
            bkb = 2,
        },
        ["modifier_bloodseeker_bloodrite_6"] =
        {
            duration = 0.4,
            slow = -30,
            cast = 0,
            radius = 100,
        },
        ["modifier_bloodseeker_bloodrite_7"] =
        {
            duration = 5,
            damage = 60,
            self_damage = 3,
            interval = 0.5,
            delay = 2,
        },



        ["modifier_bloodseeker_thirst_1"] =
        {
            damage = {30, 45, 60},
            speed = {8, 12, 16}
        },
        ["modifier_bloodseeker_thirst_2"] =
        {
            heal = {15, 25, 35},
            creeps = 3,
        },
        ["modifier_bloodseeker_thirst_3"] =
        {
            
        },
        ["modifier_bloodseeker_thirst_4"] =
        {
            radius = 700,
            str = {2, 3},
            agi = {2, 3},
            max = 12,
           -- is_perma = 1,
            mod_name = "modifier_bloodseeker_thirst_custom_stats",
        },
        ["modifier_bloodseeker_thirst_5"] =
        {
            
        },
        ["modifier_bloodseeker_thirst_6"] =
        {
            health = 10,
            status = 25,
            radius = 700
        },
        ["modifier_bloodseeker_thirst_7"] =
        {


            radius = 700,
            max = 15,
            creeps_count = 3,
            heroes_stack = 5,
            vision_radius = 4000,
            duration = 50,
            creeps_stack = 1,
        },



        ["modifier_bloodseeker_rupture_1"] =
        {
            
        },
        ["modifier_bloodseeker_rupture_2"] =
        {
            
        },
        ["modifier_bloodseeker_rupture_3"] =
        {
            
        },
        ["modifier_bloodseeker_rupture_4"] =
        {
            
        },
        ["modifier_bloodseeker_rupture_5"] =
        {
            
        },
        ["modifier_bloodseeker_rupture_6"] =
        {
            
        },
        ["modifier_bloodseeker_rupture_7"] =
        {
            cd = 14,
            damage = 50,
            heal = 70,
            duration = 3.5
        },
    },


    npc_dota_hero_monkey_king =
    {
        ["modifier_monkey_king_boundless_1"] =
        {
            cd = {-4, -6, -8}
        },
        ["modifier_monkey_king_boundless_2"] =
        {
            damage = {30, 45, 60},
            duration = 4
        },
        ["modifier_monkey_king_boundless_3"] =
        {
            range = {100, 150, 200},
            stun = {0.2, 0.3, 0.4}
        },
        ["modifier_monkey_king_boundless_4"] =
        {
            slow = {-25, -40},
            armor = {-25, -40},
            duration = 4,
            cd = 10,
            range = 150,
        },
        ["modifier_monkey_king_boundless_5"] =
        {
            delay = 2.5,
            damage = 50,
        },
        ["modifier_monkey_king_boundless_6"] =
        {
            heal_reduce = -30,
            heal = 30,
            duration = 5,
            heal_creeps = 4,
        },
        ["modifier_monkey_king_boundless_7"] =
        {
            damage = 300,
            delay = 3,
            cd = 50,
            interval = 0.25,
            cast = 0.6
        },



        ["modifier_monkey_king_tree_1"] =
        {
            move = {20, 30, 40},
            evasion = {10, 15, 20},
            bonus = 2,
            duration = 5
        },
        ["modifier_monkey_king_tree_2"] =
        {
            speed = {30, 45, 60},
            range = {50, 75, 100},
            duration = 5
        },
        ["modifier_monkey_king_tree_3"] =
        {
            cd = {-0.2, -0.4, -0.6},
            range = {100, 150, 200}  
        },
        ["modifier_monkey_king_tree_4"] =
        {
            duration = 6,
            chance = {8, 12},
            cast = {-0.6, -1}
        },
        ["modifier_monkey_king_tree_5"] =
        {
            cd = -1.5,
            vision = 700,
            shield = 30,
            regen = 2,
            shield_duration = 5  
        },
        ["modifier_monkey_king_tree_6"] =
        {
            radius = 100,
            silence = 2,
            speed = -150
        },
        ["modifier_monkey_king_tree_7"] =
        {
            cd = 30,
            duration = 90,
            damage = 12,
            max = 20,
            max_2 = 40,
            tower_radius = 1500,
            expire_timer = 30,
            bounty = 50,
            radius = 120,
            vision = 500,
        },



        ["modifier_monkey_king_mastery_1"] =
        {
            
        },
        ["modifier_monkey_king_mastery_2"] =
        {
            agility = {10, 15, 20}
        },
        ["modifier_monkey_king_mastery_3"] =
        {
            
        },
        ["modifier_monkey_king_mastery_4"] =
        {
            agility = 4,
            duration = {9, 16}
        },
        ["modifier_monkey_king_mastery_5"] =
        {
            
        },
        ["modifier_monkey_king_mastery_6"] =
        {
            
        },
        ["modifier_monkey_king_mastery_7"] =
        {
            
        },



        ["modifier_monkey_king_command_1"] =
        {
            speed = {-0.2, -0.3, -0.4}
        },
        ["modifier_monkey_king_command_2"] =
        {
            
        },
        ["modifier_monkey_king_command_3"] =
        {
            
        },
        ["modifier_monkey_king_command_4"] =
        {
            duration = 5,
        },
        ["modifier_monkey_king_command_5"] =
        {
            
        },
        ["modifier_monkey_king_command_6"] =
        {
            
        },
        ["modifier_monkey_king_command_7"] =
        {
            cd = 6
        },
    },



    npc_dota_hero_mars = 
    {

        ["modifier_mars_spear_1"] =
        {
            
        },
        ["modifier_mars_spear_2"] =
        {
            
        },
        ["modifier_mars_spear_3"] =
        {
            
        },
        ["modifier_mars_spear_4"] =
        {
            is_perma = 1,
            mod_name = "modifier_mars_spear_custom_str",
            max = 20
        },
        ["modifier_mars_spear_5"] =
        {
            
        },
        ["modifier_mars_spear_6"] =
        {
            
        },
        ["modifier_mars_spear_7"] =
        {
            
        },




        ["modifier_mars_rebuke_1"] =
        {
            cd = {-1, -1.5, -2},
            mana = {-30, -60, -90}
        },
        ["modifier_mars_rebuke_2"] =
        {
            damage = {40, 60, 80}
        },
        ["modifier_mars_rebuke_3"] =
        {
            
        },
        ["modifier_mars_rebuke_4"] =
        {
            attacks = {2, 3},
            speed = 200,
            range = 200,
            duration = 4,
            distance = 100
        },
        ["modifier_mars_rebuke_5"] =
        {
            cast = -0.1,
            armor = -30,
            duration = 5
        },
        ["modifier_mars_rebuke_6"] =
        {
            
        },
        ["modifier_mars_rebuke_7"] =
        {
            cd = 20,
            duration = 10,
            status = 35,
            cd_reduce = -1.5,
        },




        ["modifier_mars_bulwark_1"] =
        {
            slow = {-8, -12, -16},
            radius = 600,
            damage = {15, 20, 25}
        },
        ["modifier_mars_bulwark_2"] =
        {
            
        },
        ["modifier_mars_bulwark_3"] =
        {
           str = {1, 1.5, 2},
           move = {1, 1.5, 2},
           duration = 5,
           max = 10,
        },
        ["modifier_mars_bulwark_4"] =
        {
            heal = {25, 40},
            damage = {10, 15},
            timer = 3,
            creeps = 3
        },
        ["modifier_mars_bulwark_5"] =
        {
            count = 1,
            status = 20,
            cd = 10
        },
        ["modifier_mars_bulwark_6"] =
        {
            radius = 600,
            timer = 6,
            taunt = 2,
        },
        ["modifier_mars_bulwark_7"] =
        {
            duration = 4,
            spell = 40,
            health = 0.25
        },



        ["modifier_mars_arena_1"] = 
        {
            speed = {30, 40, 50}
        }, 
        ["modifier_mars_arena_2"] = 
        {
            damage = {30, 40, 50},
            interval = 0.5,
        }, 
        ["modifier_mars_arena_3"] = 
        {
            cd = {-10, -15, -20},
            duration = {1, 1.5, 2}
        }, 
        ["modifier_mars_arena_4"] = 
        {
            chance = 15,
            duration = 8,
            damage = {25, 40}
        }, 
        ["modifier_mars_arena_5"] = 
        {
            cast = 0,
            health = 30,
            fear = 1.5,
            radius = 500
        }, 
        ["modifier_mars_arena_6"] = 
        {
            range = 250,
            silence = 2,
            slow = -100
        }, 
        ["modifier_mars_arena_7"] = 
        {    
            damage = 12,
            stack = 5,
            bva = 1.6
        }, 
    },

    npc_dota_hero_zuus =
    {
        ["modifier_zuus_arc_1"] =
        {
            damage = {10, 15, 20}
        },
        ["modifier_zuus_arc_2"] =
        {
            
        },
        ["modifier_zuus_arc_3"] =
        {
            
        },
        ["modifier_zuus_arc_4"] =
        {
            max = 4,
            stun = {1, 1.5},
            duration = 10,
            damage = {3, 5},
            range = 150,
            creeps = 3
        },
        ["modifier_zuus_arc_5"] =
        {
            
        },
        ["modifier_zuus_arc_6"] =
        {
            
        },
        ["modifier_zuus_arc_7"] =
        {
            max = 2,
            damage = 50,
            heal = 6   
        },



        ["modifier_zuus_bolt_1"] =
        {
            
        },
        ["modifier_zuus_bolt_2"] =
        {
            
        },
        ["modifier_zuus_bolt_3"] =
        {
            
        },
        ["modifier_zuus_bolt_4"] =
        {
            
        },
        ["modifier_zuus_bolt_5"] =
        {
            
        },
        ["modifier_zuus_bolt_6"] =
        {
            
        },
        ["modifier_zuus_bolt_7"] =
        {
            
        },



        ["modifier_zuus_jump_1"] =
        {
            
        },
        ["modifier_zuus_jump_2"] =
        {
            
        },
        ["modifier_zuus_jump_3"] =
        {
            
        },
        ["modifier_zuus_jump_4"] =
        {
            
        },
        ["modifier_zuus_jump_5"] =
        {
            
        },
        ["modifier_zuus_jump_6"] =
        {
            
        },
        ["modifier_zuus_jump_7"] =
        {
            
        },



        ["modifier_zuus_wrath_1"] =
        {
            slow = {-40, -60, -80},
            radius = 700,
            distance = {200, 300, 400},
            duration = 5,
            knock_duration = 0.3
        },
        ["modifier_zuus_wrath_2"] =
        {
            damage = {80, 120, 160},
            heal_reduce = {-15, -20, -25},
            duration = 8
        },
        ["modifier_zuus_wrath_3"] =
        {
            shield = {400, 600, 800},
            duration = 15,
            status = 25
        },
        ["modifier_zuus_wrath_4"] =
        {
            chance = 25,
            duration = 5,
            damage = {12, 20},
            heal = {25, 40},
            heal_creeps = 3,
            radius = 500
        },
        ["modifier_zuus_wrath_5"] =
        {
            silence = 3,
            radius = 700
        },
        ["modifier_zuus_wrath_6"] =
        {
            cd = -2.5,
            damage = 5,
            max = 8,
            duration = 8,
            is_perma = 1,
            mod_name = "modifier_zuus_thundergods_wrath_custom_kills"
        },
        ["modifier_zuus_wrath_7"] =
        {
            
        },
    },
    npc_dota_hero_leshrac =
    {
        ["modifier_leshrac_earth_1"] =
        {
            
        },
        ["modifier_leshrac_earth_2"] =
        {
            
        },
        ["modifier_leshrac_earth_3"] =
        {
            heal = {8, 12, 16},
            duration = 5
        },
        ["modifier_leshrac_earth_4"] =
        {
            damage = {25, 40},
            max = 8,
            status = {-12, -20},
            duration = 5,
            radius = 600,
        },
        ["modifier_leshrac_earth_5"] =
        {
            
        },
        ["modifier_leshrac_earth_6"] =
        {
            
        },
        ["modifier_leshrac_earth_7"] =
        {
            count = 600,
            damage = 50,
            stun = 0.5,
            cd = 2.5,
            delay = 1.5,
            radius = 180,
            aoe = 800,
            creeps = 25,
        },



        ["modifier_leshrac_edict_1"] =
        {
            
        },
        ["modifier_leshrac_edict_2"] =
        {
            
        },
        ["modifier_leshrac_edict_3"] =
        {
            
        },
        ["modifier_leshrac_edict_4"] =
        {
            
        },
        ["modifier_leshrac_edict_5"] =
        {
           heal = 30,
           health = 40,
           heal_creeps = 3, 
        },
        ["modifier_leshrac_edict_6"] =
        {
            
        },
        ["modifier_leshrac_edict_7"] =
        {
            radius = 500,
            duration = 3,
            stun = 1.5,
            damage = 2,
            effect_duration = 6  
        },



        ["modifier_leshrac_storm_1"] =
        {
            
        },
        ["modifier_leshrac_storm_2"] =
        {
            
        },
        ["modifier_leshrac_storm_3"] =
        {
            
        },
        ["modifier_leshrac_storm_4"] =
        {
            range = {60, 120},
            damage = 40,
            chance = {30, 50},
            slow = 0.3,
            count = 1
        },
        ["modifier_leshrac_storm_5"] =
        {
            distance = 300,
            cd = 12,
            duration = 0.3,
            distance_max = 400,
            distance_min = 100,
        },
        ["modifier_leshrac_storm_6"] =
        {
            
        },
        ["modifier_leshrac_storm_7"] =
        {
            max = 5,
            damage = 35,
            silence = 1.5,
            radius = 200,
            interval = 0.25,
            waste = 5,
            count = 1,
        },



        ["modifier_leshrac_nova_1"] =
        {
            
        },
        ["modifier_leshrac_nova_2"] =
        {
            
        },
        ["modifier_leshrac_nova_3"] =
        {
            mana = {-10, -15, -20},
            radius = {40, 60, 80}
        },
        ["modifier_leshrac_nova_4"] =
        {
            
        },
        ["modifier_leshrac_nova_5"] =
        {
            
        },
        ["modifier_leshrac_nova_6"] =
        {
            
        },
        ["modifier_leshrac_nova_7"] =
        {
            cast = 2.5,
            damage = 100,
            mana = 50,
            heal = 60,
            cd = 17,
        },
    },
    npc_dota_hero_crystal_maiden =
    {
        ["modifier_maiden_crystal_1"] =
        {
      
        },
        ["modifier_maiden_crystal_2"] =
        {
            damage = {50, 75, 100}
        },
        ["modifier_maiden_crystal_3"] =
        {
            range = {100, 150, 200},
            speed = {30, 45, 60},
            duration = 4
        },
        ["modifier_maiden_crystal_4"] =
        {
            cd = {-0.2, -0.3},
            damage = {10, 15},
            max = 5,
            duration = 5,
        },
        ["modifier_maiden_crystal_5"] =
        {
            cast = -0.2,
            stun = 1.2,
            cd = 10
        },
        ["modifier_maiden_crystal_6"] =
        {
            damage = -15,
            heal = 150,
            duration = 5,
            radius = 100
        },
        ["modifier_maiden_crystal_7"] =
        {
            cd = 28,
            duration = 8,
            attack = 0.8,
            radius = 800,
            range = 900
        },



        ["modifier_maiden_frostbite_1"] =
        {
            
        },
        ["modifier_maiden_frostbite_2"] =
        {
        },
        ["modifier_maiden_frostbite_3"] =
        {   
            health = 1,
            armor = 0.02,
            mana = {12, 9, 6}   
        },
        ["modifier_maiden_frostbite_4"] =
        {
            
        },
        ["modifier_maiden_frostbite_5"] =
        {
            
        },
        ["modifier_maiden_frostbite_6"] =
        {
            damage = -20,
            proc_duration = 1.5,
            cd = 15,
        },
        ["modifier_maiden_frostbite_7"] =
        {
            max = 10,
            damage = 4,
            slow = -4,
            radius = 450,
            interval = 1
        },



        ["modifier_maiden_arcane_1"] =
        {
            mana = {6, 9, 12},
            duration = 5
        },
        ["modifier_maiden_arcane_2"] =
        {
            damage = {2, 3, 4},
            max = 5,
            duration = 6,
        },
        ["modifier_maiden_arcane_3"] =
        {
            slow = {-10, -15, -20},
            speed = {10, 15, 20},
            duration = 3,
        },
        ["modifier_maiden_arcane_4"] =
        {
            range = {100, 150},
            speed = 200,
            attacks = {2, 3},
            duration = 5,
        },
        ["modifier_maiden_arcane_5"] =
        {
            
        },
        ["modifier_maiden_arcane_6"] =
        {
            attacks = 5,
            bkb = 3,
            duration = 6,
        },
        ["modifier_maiden_arcane_7"] =
        {
            mana = 12,
            cd = 2,
            regen = 20,
            speed = 500,
            damage = 70
        },



        ["modifier_maiden_freezing_1"] =
        {
            
        },
        ["modifier_maiden_freezing_2"] =
        {
            
        },
        ["modifier_maiden_freezing_3"] =
        {
            
        },
        ["modifier_maiden_freezing_4"] =
        {
            
        },
        ["modifier_maiden_freezing_5"] =
        {
            
        },
        ["modifier_maiden_freezing_6"] =
        {
            
        },
        ["modifier_maiden_freezing_7"] =
        {
            
        },
    },
    npc_dota_hero_snapfire =
    {
        ["modifier_snapfire_scatter_1"] =
        {
            
        },
        ["modifier_snapfire_scatter_2"] =
        {
            
        },
        ["modifier_snapfire_scatter_3"] =
        {
            
        },
        ["modifier_snapfire_scatter_4"] =
        {
            damage = {30, 50},
            duration = 12,
            cast = 0.1,
            max = 4,
            loss = 1,
        },
        ["modifier_snapfire_scatter_5"] =
        {
            stun = 1.2,
            cd = 8,
            range = 230,
            duration = 0.2
        },
        ["modifier_snapfire_scatter_6"] =
        {
            
        },
        ["modifier_snapfire_scatter_7"] =
        {
            cd = 60,
            count = 6,
            interval = 1.1
        },



        ["modifier_snapfire_cookie_1"] =
        {
            
        },
        ["modifier_snapfire_cookie_2"] =
        {
            
        },
        ["modifier_snapfire_cookie_3"] =
        {
            heal = {200, 250, 300},
            duration = 3,
        },
        ["modifier_snapfire_cookie_4"] =
        {
            count = 3,
            interval = 0.1,
            distance = 230,
            radius = 320,
            timer = 2.5,
            slow = -100,
            duration = 1.5,
            damage = {8, 12},
            damage_creeps = 0.33
        },
        ["modifier_snapfire_cookie_5"] =
        {
            
        },
        ["modifier_snapfire_cookie_6"] =
        {
            
        },
        ["modifier_snapfire_cookie_7"] =
        {
            radius = 150,
            max = 5,
            mana = 0,
            distance = 230,
            timer = 4,
            cd = 1.5
        },

        ["modifier_snapfire_shredder_1"] =
        {
            damage = {35, 55, 75}
        },  
        ["modifier_snapfire_shredder_2"] =
        {
            duration = {2, 3, 4},
            attacks = {2, 3, 4}
        },
        ["modifier_snapfire_shredder_3"] =
        {
            duration =  8,
            armor = {1, 1.5, 2},
            move = {4, 6, 8}
        },
        ["modifier_snapfire_shredder_4"] =
        {
            chance = {20, 30},
            stun = 0.2,
            stack = 3
        },
        ["modifier_snapfire_shredder_5"] =
        {
            
        },
        ["modifier_snapfire_shredder_6"] =
        {
            cd = -3,
            count = 6,
            silence = 1.5,
            slow = -100,
            duration = 8
        },
        ["modifier_snapfire_shredder_7"] =
        {
            max = 100,
            attack = 20,
            decay = 42,
            stun = 0.8,
            damage = -35
        },



        ["modifier_snapfire_kisses_1"] =
        {
            cd = {-8, -12, -16}
        },
        ["modifier_snapfire_kisses_2"] =
        {
            
        },
        ["modifier_snapfire_kisses_3"] =
        {
            heal = {15, 20, 25},
            regen = {2, 3, 4},
            heal_creeps = 0.25
        },
        ["modifier_snapfire_kisses_4"] =
        {
            damage = {30, 50},
            slow = {-2, -4},
            max = 10,
            attack = 4,
            duration = 8,
            range = 800,
            radius = 300
        },
        ["modifier_snapfire_kisses_5"] =
        {
            damage_reduce = -60,
            bkb = 2.5
        },
        ["modifier_snapfire_kisses_6"] =
        {
            duration = 3,
            turn_slow = -70,
            heal_reduce = -35,
        },
        ["modifier_snapfire_kisses_7"] =
        {
            cd = 16,
            damage = 50,
            count = 50
        },
    },
    npc_dota_hero_sven =
    {
        ["modifier_sven_hammer_1"] =
        {
            
        },
        ["modifier_sven_hammer_2"] =
        {
            
        },
        ["modifier_sven_hammer_3"] =
        {
            
        },
        ["modifier_sven_hammer_4"] =
        {
            
        },
        ["modifier_sven_hammer_5"] =
        {
            mana = 0 ,
            slow = -100,
            silence = 1.2
        },
        ["modifier_sven_hammer_6"] =
        {
            
        },
        ["modifier_sven_hammer_7"] =
        {
            radius = 450,
            interval = 1,
            stun = 0.1,
            damage_init = 25,
            damage_inc = 10,
            max = 6,
            duration = 7,

        },



        ["modifier_sven_cleave_1"] =
        {
            
        },
        ["modifier_sven_cleave_2"] =
        {
            
        },
        ["modifier_sven_cleave_3"] =
        {
            
        },
        ["modifier_sven_cleave_4"] =
        {
            
        },
        ["modifier_sven_cleave_5"] =
        {
            
        },
        ["modifier_sven_cleave_6"] =
        {
            health = 50,
            heal_reduce = -25,
            speed = 15,
            duration = 4
        },
        ["modifier_sven_cleave_7"] =
        {
            duration = 1,
            slow = -50,
            damage_min = 80,
            damage_max = 140,
            cd_min = 0.5,
            cd_max = 7,
            speed = 1600,
            distance = 1200,
            width = 150
        },



        ["modifier_sven_cry_1"] =
        {
            
        },
        ["modifier_sven_cry_2"] =
        {
            
        },
        ["modifier_sven_cry_3"] =
        {
            
        },
        ["modifier_sven_cry_4"] =
        {
            radius = 700,
            slow = {-10, -15},
            armor = {-5, -8},
            duration = 6,
            bonus = 2
        },
        ["modifier_sven_cry_5"] =
        {
            
        },
        ["modifier_sven_cry_6"] =
        {
            armor = 12,
            magic = 25,
            regen = 80,
            min = 15
        },
        ["modifier_sven_cry_7"] =
        {
            duration = 4,
            status = 40,
            damage = 150,
            shield = 12,
            radius = 500,
            stun = 0.2
        },



        ["modifier_sven_god_1"] =
        {
            damage = {2, 3, 4},
            max = 10,
            duration = 4,
            bonus = 2   
        },
        ["modifier_sven_god_2"] =
        {
          move = {20, 30, 40},
          heal = {1, 1.5, 2}  
        },
        ["modifier_sven_god_3"] =
        {
            duration = {2, 3, 4},
            cd = {-6, -9, -12}
        },
        ["modifier_sven_god_4"] =
        {
            speed = {25, 40},
            str = {2, 4},
            max = 10
        },
        ["modifier_sven_god_5"] =
        {
            cast = -0.15,
            bkb = 2,
            root = 2,
            radius = 400
        },
        ["modifier_sven_god_6"] =
        {
            duration = 4,
            health = 30,
            cd = 40,
        },
        ["modifier_sven_god_7"] =
        {
            damage = 330,
            stun = 0.8,
            health = 200,
            max = 10,
            range = 1000,
            delay = 3,
        },
    },

    npc_dota_hero_sniper = 
    {
        ["modifier_sniper_shrapnel_1"] = 
        {
            cd = {-6, -9, -12}
        },
        ["modifier_sniper_shrapnel_2"] = 
        {
            damage = {8, 12, 16},
            max = 5,
            duration = 2
        },
        ["modifier_sniper_shrapnel_3"] = 
        {
            heal = {1, 1.5, 2},
            move = {10, 15, 20},
            duration = 3
        },
        ["modifier_sniper_shrapnel_4"] = 
        {
            damage = {200, 300},
            stun = {0.8, 1.2},
            timer = 2.5,
            attacks = 1
        },
        ["modifier_sniper_shrapnel_5"] = 
        {
            timer = 4,
            silence = 2,
            slow = -10
        },
        ["modifier_sniper_shrapnel_6"] = 
        {
            radius = 50,
            charges = 1,
            delay = -0.5,
        },
        ["modifier_sniper_shrapnel_7"] = 
        {
            chance = 15,
            stacks = 3,
            slow = 1.5,
            chance_creeps = 0.5
        },



        ["modifier_sniper_headshot_1"] =
        {
            
        },
        ["modifier_sniper_headshot_2"] =
        {
            
        },
        ["modifier_sniper_headshot_3"] =
        {
            
        },
        ["modifier_sniper_headshot_4"] =
        {
            duration = {0.5, 1},
            armor = {-1.5, -2.5},
            armor_duration = 6
        },
        ["modifier_sniper_headshot_5"] =
        {
            
        },
        ["modifier_sniper_headshot_6"] =
        {
            
        },
        ["modifier_sniper_headshot_7"] =
        {
            damage = 35,
            interval = 0.1,
            distance = 1000,
            auto = 1,
            width = 70,
            duration = 2.5,
            turn = 200
            
        },



        ["modifier_sniper_aim_1"] =
        {
            
        },
        ["modifier_sniper_aim_2"] =
        {
            
        },
        ["modifier_sniper_aim_3"] =
        {
            
        },
        ["modifier_sniper_aim_4"] =
        {
            
        },
        ["modifier_sniper_aim_5"] =
        {
            
        },
        ["modifier_sniper_aim_6"] =
        {
            duration = 0.15,
            range = 220,
            speed = 3,
            cd_inc = -1,
            cd = 22,
        },
        ["modifier_sniper_aim_7"] =
        {
            cd = 22,
            duration = 3,
            speed = 15,
            illusions_duration = 8,
            illusions_damage = 50,
            illusions_incoming = 200,
            cd_inc = -1,
        },



        ["modifier_sniper_assassinate_1"] =
        {
            damage = {100, 150, 200},
            attack = {20, 30, 40}
        },
        ["modifier_sniper_assassinate_2"] =
        {
            
        },
        ["modifier_sniper_assassinate_3"] =
        {
            
        },
        ["modifier_sniper_assassinate_4"] =
        {
            damage = {20, 30},
            duration = 4,
            heal = 100,
            heal_creeps = 3
        },
        ["modifier_sniper_assassinate_5"] =
        {
            
        },
        ["modifier_sniper_assassinate_6"] =
        {
            damage = 2,
            max = 8,
            cdr = 15,
            timer = 5,
            is_perma = 1,
            mod_name = "modifier_sniper_assassinate_custom_kill_stack",
        },
        ["modifier_sniper_assassinate_7"] =
        {
            cd = 4,
            damage = 50,
            attack = 1,
            cd_inc = 2,
            max = 5
        },
    },


   npc_dota_hero_muerta =
    {
        ["modifier_muerta_dead_1"] =
        {
            damage = {60, 100, 140}
        },
        ["modifier_muerta_dead_2"] =
        {
            
        },
        ["modifier_muerta_dead_3"] =
        {
            
        },
        ["modifier_muerta_dead_4"] =
        {
            
        },
        ["modifier_muerta_dead_5"] =
        {
            
        },
        ["modifier_muerta_dead_6"] =
        {
            
        },
        ["modifier_muerta_dead_7"] =
        {
            damage = 150,
            heal = 40,
            duration = 3.5
        },



        ["modifier_muerta_calling_1"] =
        {
            
        },
        ["modifier_muerta_calling_2"] =
        {
            
        },
        ["modifier_muerta_calling_3"] =
        {
            
        },
        ["modifier_muerta_calling_4"] =
        {
            
        },
        ["modifier_muerta_calling_5"] =
        {
            
        },
        ["modifier_muerta_calling_6"] =
        {
            
        },
        ["modifier_muerta_calling_7"] =
        {
            speed = 50,
            count = 7,
            duration = 1.2,
            duration_full = 2.4,
            big_radius = 850,
            small_radius = 400,
            self_move = 50,
            interval = 1.3
        },



        ["modifier_muerta_gun_1"] =
        {
            
        },
        ["modifier_muerta_gun_2"] =
        {
            
        },
        ["modifier_muerta_gun_3"] =
        {
            
        },
        ["modifier_muerta_gun_4"] =
        {
            
        },
        ["modifier_muerta_gun_5"] =
        {
            
        },
        ["modifier_muerta_gun_6"] =
        {
            
        },
        ["modifier_muerta_gun_7"] =
        {
            
        },



        ["modifier_muerta_veil_1"] =
        {
            
        },
        ["modifier_muerta_veil_2"] =
        {
            
        },
        ["modifier_muerta_veil_3"] =
        {
            
        },
        ["modifier_muerta_veil_4"] =
        {
            
        },
        ["modifier_muerta_veil_5"] =
        {
            
        },
        ["modifier_muerta_veil_6"] =
        {
            
        },
        ["modifier_muerta_veil_7"] =
        {
            
        },

    },






        npc_dota_hero_pangolier =
    {
        ["modifier_pangolier_buckle_1"] = 
        {
            cd = {-1, -1.5, -2}
        },
        ["modifier_pangolier_buckle_2"] = 
        {
            range = {100, 150, 200},
            speed = {8, 12, 16},
            duration = 3
        },
        ["modifier_pangolier_buckle_3"] = 
        {
            damage = {15, 20, 25}
        },
        ["modifier_pangolier_buckle_4"] = 
        {
            damage = {6, 10},
            duration = 3,
        },
        ["modifier_pangolier_buckle_5"] = 
        {
            attacks = 2,
            heal = 70,
            range = 400,
            duration = 1,
            slow = -100,
            buff_duration = 5,
        },
        ["modifier_pangolier_buckle_6"] = 
        {
            damage_reduce = -60,
            duration = 0.5,
        },
        ["modifier_pangolier_buckle_7"] = 
        {
            distance = 270,
            max = 5,
            stun = 1,
            hit = 1,
            timer = 5,
            timer_interval = 0.2,

        },



        ["modifier_pangolier_shield_1"] = 
        {
            shield = {10, 15, 20},
        },
        ["modifier_pangolier_shield_2"] = 
        {
            slow = {-10, -15, -20},
            duration = {1, 1.5, 2}
        },
        ["modifier_pangolier_shield_3"] = 
        {
            heal = {10, 15, 20},
            speed = {30, 45, 60},
            heal_creeps = 0.33,
            duration = 5,
        },
        ["modifier_pangolier_shield_4"] = 
        {
            duration = 3,
            heal = {30, 50},
            heal_amount = 1,
        },
        ["modifier_pangolier_shield_5"] = 
        {
            distance = 200,
            silence = 2
        },
        ["modifier_pangolier_shield_6"] = 
        {
            damage_reduce = -20,
            cd = -1,
            duration = 4,
            immune = 1
        },
        ["modifier_pangolier_shield_7"] = 
        {
            damage = 100,
            duration = 4,
            heal = 15,
            creeps = 3
        },




        ["modifier_pangolier_lucky_1"] = 
        {
            chance = {4, 6, 8},
            speed = {-30, -45, -60},
        },
        ["modifier_pangolier_lucky_2"] = 
        {
            damage = {6, 9, 12},
        },
        ["modifier_pangolier_lucky_3"] = 
        {
            range = {40, 60, 80},
            speed = {8, 12, 16},
            duration = 3,
        },
        ["modifier_pangolier_lucky_4"] = 
        {
            status = {25, 40},
            duration = 6,
            speed = {20, 30},
            max = 4,
        },
        ["modifier_pangolier_lucky_5"] = 
        {
            damage = -20,
            cd = 15,
        },
        ["modifier_pangolier_lucky_6"] = 
        {
            cd = 10,
            stun = 0.5,
            cast = 400,
            range = 200,
            dash_speed = 2000,
        },
        ["modifier_pangolier_lucky_7"] = 
        {
            duration = 10,
            stun = 1.2,
            effect_duration = 6,
        },




        ["modifier_pangolier_rolling_1"] = 
        {

        },
        ["modifier_pangolier_rolling_2"] = 
        {

        },
        ["modifier_pangolier_rolling_3"] = 
        {

        },
        ["modifier_pangolier_rolling_4"] = 
        {

        },
        ["modifier_pangolier_rolling_5"] = 
        {

        },
        ["modifier_pangolier_rolling_6"] = 
        {

        },
        ["modifier_pangolier_rolling_7"] = 
        {

        },

    },


    npc_dota_hero_arc_warden =
    {
        ["modifier_arc_warden_flux_1"] = 
        {
            cast = {100, 150, 200},
            speed = {15, 20, 25},
            duration = 5
        },
        ["modifier_arc_warden_flux_2"] =
        {
            damage = {2, 3, 4},
            max = 4,
            duration = 5
        },
        ["modifier_arc_warden_flux_3"] =
        {
            heal = {15, 20, 25},
            heal_reduce = {-15, -20, -25},
            heal_creeps = 0.33
        },
        ["modifier_arc_warden_flux_4"] =
        {
            cd = {0.3, 0.5},
            resist = {-3, -5},
            max = 8,
            duration = 5
        },
        ["modifier_arc_warden_flux_5"] =
        {
            duration = 1.5,
            silence = 2,
            speed_move = -100,
            speed_attack = -100
        },
        ["modifier_arc_warden_flux_6"] =
        {
            cast = -0.2,
            range = 250,
            duration = 0.25,
        },
        ["modifier_arc_warden_flux_7"] =
        {
            heal = 2.5,
            radius = 350,
            interval = 2.2
        },




        ["modifier_arc_warden_field_1"] =
        {  
            damage = {30, 45, 60},
            speed = {30, 45, 60}
        },
        ["modifier_arc_warden_field_2"] =
        {
            damage_reduce = {-10, -15, -20},
            status_bonus = {10, 15, 20}
        },
        ["modifier_arc_warden_field_3"] =
        {
            cd = {-2, -3, -4},
            duration = {1, 1.5, 2}  
        },
        ["modifier_arc_warden_field_4"] =
        {
            damage_stack = {25, 40},
            radius = 300,
            stack_creeps = 0.33,
            duration = 10,
            delay = 5,
        },
        ["modifier_arc_warden_field_5"] =
        {
            stun = 1,
        },
        ["modifier_arc_warden_field_6"] =
        {
            cast = -0.2,
            cd = 12,
            block = 1,
        },
        ["modifier_arc_warden_field_7"] =
        {
            damage = 40,
            cd = 4.5,
            duration = 5,
            incoming = 200,
            radius = 250,
        },



        ["modifier_arc_warden_spark_1"] =
        {
            damage = {30, 45, 60},
            dire_damage = 75
        },
        ["modifier_arc_warden_spark_2"] =
        {
            slow_attack = {-10, -15, -20},
            slow_move = {-4, -6, -8},
            max = 4,
            duration = 8
        },
        ["modifier_arc_warden_spark_3"] =
        {
            mana = {-20, -30, -40},
            heal = {1, 1.5, 2}
        },
        ["modifier_arc_warden_spark_4"] =
        {
            cd = {-0.5, -1},
            chance = {25, 40}
        },
        ["modifier_arc_warden_spark_5"] =
        {
            activate = 20,
            max = 4,
            fear = 1.5,
            cd = 12,
            duration = 8
        },
        ["modifier_arc_warden_spark_6"] =
        {
            cast = -0.2,
            duration = 1,
            move = 15,
        },
        ["modifier_arc_warden_spark_7"] =
        {
            max = 6,
            cd = 18,
            cast = 2
        },




        ["modifier_arc_warden_double_1"] =
        {
            chance = {30, 45, 60},
            range = 900
        },
        ["modifier_arc_warden_double_2"] =
        {
            range = {50, 75, 100},
            duration = 3,
            damage = {30, 45, 60}
        },
        ["modifier_arc_warden_double_3"] =
        {
            cd = {-4, -6, -8},
            strength = {6, 9, 12}
        },
        ["modifier_arc_warden_double_4"] =
        {
            cd = {30, 20},
            duration = 20,
            speed = 50,
            attack_range = 100,
            damage = 15,
            spell_range = 150,
            shield = 15,
            move = 80,
            status = 20
        },
        ["modifier_arc_warden_double_5"] =
        {
            heal = 20,
            health = 50,
            damage = 25,
            range = 800,
            heal_creeps = 0.33,
        },
        ["modifier_arc_warden_double_6"] =
        {
            mana = 50,
            cd = 1,
        },
        ["modifier_arc_warden_double_7"] =
        {
            cast = 2,
            cd = 20,
            damage = 2.5,
            max = 10,
            cdr = 30,
            range = 900
        },
    },

    npc_dota_hero_invoker =
    {

        ["modifier_invoker_quas_1"] =
        {
            cd = {-3, -5, -7},
            damage = {20, 30, 40}
        },
        ["modifier_invoker_quas_2"] =
        {
            duration = {0.8, 1.2, 1.6},
        },
        ["modifier_invoker_quas_3"] =
        {
            cd = {-2, -3, -4},
            heal = {8, 12, 16},
            duration = 4
        },
        ["modifier_invoker_quas_4"] =
        {
            interval = {-0.03, -0.05},
            magic = {-3, -5},
            duration = 8,
            max = 10
        },
        ["modifier_invoker_quas_5"] =
        {
            damage = -30,
            root = 2,
            heal = -40,
            duration = 1
        },  
        ["modifier_invoker_quas_6"] =
        {
            damage = -30,
            duration = 1.5
        },
        ["modifier_invoker_quas_7"] =
        {
            max = 8,
            stun = 3,
            health = 2.5,
            wall_duration = 1.5,
            duration = 6,
            interval = 0.5,
            damage = 80,
            creeps = 150,
        },


        ["modifier_invoker_wex_1"] =
        {
            cd = {-4, -6, -8},
            speed = {200, 300, 400},
        },
        ["modifier_invoker_wex_2"] =
        {
            duration = {1, 1.5, 2},
            heal = {15, 20, 25},
            heal_creeps = 3
        },
        ["modifier_invoker_wex_3"] =
        {
            range = {50, 75, 100},
            damage = {2, 3, 4},
            max = 6,
            duration = 5
        },
        ["modifier_invoker_wex_4"] =
        {   
            duration = 6,
            cdr = {10, 15},
            speed = {10, 15},
            max = 8,
        },
        ["modifier_invoker_wex_5"] =
        {
            delay = -0.8,
            heal = 25,
            speed = 25,
            duration = 3,
        },
        ["modifier_invoker_wex_6"] =
        {
            silence = 2,
            slow = -50,
            duration = 3,
            min_distance = 150,
            knock_duration = 0.3 
        },
        ["modifier_invoker_wex_7"] =
        {
            cd = -2,
            range = 1600,
            damage = 250,
            speed = 750
        },



        ["modifier_invoker_exort_1"] =
        {
            attack = {20, 30, 40},
            speed = {40, 60, 80},
        },
        ["modifier_invoker_exort_2"] =
        {
            duration = 9,
            slow = {-30, -45, -60},
            damage = {80, 120, 160},
            radius = 300
        },
        ["modifier_invoker_exort_3"] =
        {
            cd = {-10, -15, -20},
            damage = {10, 15, 20}
        },
        ["modifier_invoker_exort_4"] =
        {
            cd = {-0.4, -0.6},
            count = {3, 2},
            duration = 8, 
            range = 1000  
        },
        ["modifier_invoker_exort_5"] =
        {
            delay = -0.5,
            radius = 60,
            duration = 2.5,
            miss = 100
        },
        ["modifier_invoker_exort_6"] =
        {
            damage = -55,
            heal = 1.2,
            cd = -12,
            slow = -30,
            duration = 3
        },
        ["modifier_invoker_exort_7"] =
        {
            sun = 9,
            meteor = 3,
            attack_stack = -0.1,
            sun_stack = -1.5,
            radius = 450,
            min_cast = 1,
            duration = 5,
            reset = 10,
        },


        ["modifier_invoker_invoke_1"] =
        {
            damage = {40, 60, 80},
            cd = {-8, -12, -16}
        },
        ["modifier_invoker_invoke_2"] =
        {
            move = {2, 3, 4},
            status = {2, 3, 4},
            duration = 8,
            max = 6,
        },
        ["modifier_invoker_invoke_3"] =
        {
            mana = {10, 15, 20},
            heal = {40, 60, 80},
            duration = 5
        },
        ["modifier_invoker_invoke_4"] =
        {   
            duration = 14,
            damage = {2, 3},
            blast_damage = {2, 3}
        },
        ["modifier_invoker_invoke_5"] =
        {
            damage = -40,
            count = 11,
            cd = 40,
            duration = 3,   
            health = 30
        },
        ["modifier_invoker_invoke_6"] =
        {
            level = 1,
            cd = -0.5
        },
        ["modifier_invoker_invoke_7"] =
        {
            duration = 8,
            cd = 0.3,
        },


    },

    npc_dota_hero_razor =
    {

        ["modifier_razor_plasma_1"] =
        {
            damage = {30, 45, 60},
            radius = {80, 120, 160}
        },
        ["modifier_razor_plasma_2"] =
        {
            duration = {1, 1.5, 2},
            speed = {-30, -45, -60}
        },
        ["modifier_razor_plasma_3"] =
        {
            cd = {-1, -1.5, -2},
            mana = {-30, -45, -60}
        },
        ["modifier_razor_plasma_4"] =
        {
            heal_reduce = {-5, -8},
            duration_reduce = 6,
            max = 6,
            stop = {2, 3},
            interval = 0.5
        },
        ["modifier_razor_plasma_5"] =
        {   
            speed = 30,
            duration = 1.2,
            shield = 10,
            shield_duration = 6,
            interval = 0.05
        },
        ["modifier_razor_plasma_6"] =
        {
            silence = 2,
            slow = 15
        },
        ["modifier_razor_plasma_7"] =
        {
            damage = 150,
            delay = 3,
            radius = 500,
            knock_duration = 0.3,
            knock_distance = 600,
            knock_distance_min = 100,
            incoming = 400,
            cd = 12,
        },



        ["modifier_razor_link_1"] =
        {
            damage = {4, 7, 10},
            duration = 6
        },
        ["modifier_razor_link_2"] =
        {
            range = {100, 150, 200},
            slow = {30, 40, 50},
            duration = 3
        },
        ["modifier_razor_link_3"] =
        {
            heal = {15, 25, 35},
            duration = 6,
            creeps = 3
        },
        ["modifier_razor_link_4"] =
        {
            damage = {8, 12},
            max = 10,
            duration = {-1, -2},
            is_perma = 1,
            mod_name = "modifier_razor_static_link_custom_perma",
        },
        ["modifier_razor_link_5"] =
        {
            status = 20,
            count = 1
        },
        ["modifier_razor_link_6"] =
        {
            cd = -2,
            stun = 1.5,
            knock_distance = 80,
            knock_distance_max = 800,
            knock_duration = 0.3,
            knock_distance_attack = 70,
            knock_duration_attack = 0.2
        },
        ["modifier_razor_link_7"] =
        {
            duration = 4,
            damage = 250,
            lose_duration = 4,
            damage_self = 100,
            swap = 6,
            radius = 200
        },




        ["modifier_razor_current_1"] =
        {
            cd = {-0.6, -0.9, -1.2},
            chance = {4, 6, 8}
        },
        ["modifier_razor_current_2"] =
        {
            heal = {4, 6, 8},
            duration = 6,
        },
        ["modifier_razor_current_3"] =
        {
            str = {1, 1.5, 2},
            agi = {1, 1.5, 2},
            max = 10,
            duration = 8,
            spell = 3,
        },
        ["modifier_razor_current_4"] =
        {
            damage = {20, 40},
            max = 8,
            duration = 8,
            distance = 700
        },
        ["modifier_razor_current_5"] =
        {
            speed_text = 50,
            speed_max = 600,
            speed_bonus = 10,
            cd = -0.7,
            distance = 700
        },
        ["modifier_razor_current_6"] =
        {
            stun = 1,
            cd = 15
        },
        ["modifier_razor_current_7"] =
        {
            duration = 2,
            slow = -70,
            charge_speed = 3000,
            max_distance = 1200,
            stun = 0.3,
            stun_knock = 150,
            max_damage = 270,
            cd = 12,
            cd_inc = -1
        },




        ["modifier_razor_eye_1"] =
        {
            range = {50, 75, 100},
            armor = -1,
            max = {4, 6, 8},
            duration = 6,
        },
        ["modifier_razor_eye_2"] =
        {
            move = {10, 15, 20},
            status = {10, 15, 20},
            max = 15
        },
        ["modifier_razor_eye_3"] =
        {
            duration = {2, 3, 4},
            cd = {-8, -12, -16}
        },
        ["modifier_razor_eye_4"] =
        {
            speed = {2, 3},
            chance = {12, 20}
        },
        ["modifier_razor_eye_5"] =
        {
            radius = 100,
            root = 1.5,
            cd = 8
            
        },
        ["modifier_razor_eye_6"] =
        {
            damage = -15,
            duration = 3
        },
        ["modifier_razor_eye_7"] =
        {   
            duration_min = 0,
            duration_max = 4,
            slow = -70,
            heal = 35,
            max = 10,
            bonus = 2,
            creeps = 3,
            cd = 8,
        },    
    },

    npc_dota_hero_sand_king =
    {
        ["modifier_sand_king_burrow_1"] =
        {
            stun = {0.2, 0.3, 0.4},
            range = {100, 150, 200},
        },
        ["modifier_sand_king_burrow_2"] =
        {
            damage = {50, 75, 100},
            damage_auto = {8, 12, 16}
        },
        ["modifier_sand_king_burrow_3"] =
        {
            duration = 5,
            speed = {20, 30, 40},
            evasion = {6, 9, 12},
            bonus = 2
        },
        ["modifier_sand_king_burrow_4"] =
        {
            delay = 3,
            radius = 250,
            stun = {0.5, 0.8},
            attacks = {2, 3},
        },
        ["modifier_sand_king_burrow_5"] =
        {
            cd = -0.4,
            speed = 50,
            duration = 0.5
        },
        ["modifier_sand_king_burrow_6"] =
        {
            duration = 5,
            range = 400,
            slow = -100,
            slow_duration = 1,
        },
        ["modifier_sand_king_burrow_7"] =
        {
            shield = 20,
            restore_timer = 9,
            speed = 200,
            radius = 350,
            attack_cd = 0.9,
            attack_stun = 0.1,
            cd = 14
        },




        ["modifier_sand_king_sand_1"] =
        {
            damage = {1.5, 2, 2.5},
        },
        ["modifier_sand_king_sand_2"] =
        {
            cd = {-2, -3, -4},
            radius = {60, 90, 120}
        },
        ["modifier_sand_king_sand_3"] =
        {
            heal = {0.6, 0.9, 1.2},
            status = {10, 15, 20}
        },
        ["modifier_sand_king_sand_4"] =
        {
            silence = {1, 1.5},
            slow = -50,
            damage = {100, 150},
            max = 2
        },
        ["modifier_sand_king_sand_5"] =
        {
            sand_speed = 100,
            speed = 20,
            duration = 3
        },
        ["modifier_sand_king_sand_6"] =
        {
            cd = 12,
            duration = 1.2,
            more_radius = 100,
        },
        ["modifier_sand_king_sand_7"] =
        {
            duration = 1.5,
            cd = 12,
            max = 6,
            life_duration = 10,
            health = 25,
            slow_duration = 6,
            damage = 4,
            death_damage = 60,
            radius = 400,
        },




        ["modifier_sand_king_finale_1"] =
        {
            duration = 3,
            speed = {30, 45, 60},
            damage = {6, 9, 12},
        },
        ["modifier_sand_king_finale_2"] =
        {
            range = {40, 60, 80},
            cd = {10, 8, 6},    
        },
        ["modifier_sand_king_finale_3"] =
        {
            damage = {-4, -6, -8},
            slow = {-30, -45, -60},
            duration = 2
        },
        ["modifier_sand_king_finale_4"] =
        {
            damage = {1, 2},
            max = 50,
            resist = {-15, -25},
            duration = 3,
            is_perma = 1,
            mod_name = "modifier_sandking_caustic_finale_custom_perma"
        },
        ["modifier_sand_king_finale_5"] =
        {
            health = 40,
            bva = 1.5,
            heal = 3,
            bonus = 2,
            heal_creeps = 3
        },
        ["modifier_sand_king_finale_6"] =
        {
            stack = -1,
            slow = -10,
            duration = 2
        },
        ["modifier_sand_king_finale_7"] =
        {
            cd = 15,
            range = 300,
            duration = 5,
            slow = 2,
            chance = 20,
            delay = 0.3,
            damage = 85,
        },

        


        ["modifier_sand_king_epicenter_1"] =
        {
            heal_reduce = {-10, -15, -20},
            damage = 10,
            max = {4, 6, 8},
            duration = 6,
        },
        ["modifier_sand_king_epicenter_2"] =
        {
            cd = {-6, -9, -12},
            mana = {10, 15, 20},
        },
        ["modifier_sand_king_epicenter_3"] =
        {
            heal = {20, 30, 40},
            shield = {8, 12, 16},
            heal_creeps = 3,
            duration = 5
        },
        ["modifier_sand_king_epicenter_4"] =
        {
            max = {2, 3},
            timer = 5,
            chance = {60, 100},
            radius = 500,
        },
        ["modifier_sand_king_epicenter_5"] =
        {
            cd = 10,
            count = 1,
            damage = -30,
        },
        ["modifier_sand_king_epicenter_6"] =
        {
            cd = -0.4,
            speed = 4,
            max = 6,
            duration = 8,
        },
        ["modifier_sand_king_epicenter_7"] =
        {
            duration = 4,
            status = 40,
            cd = 25,
            distance = 250,
            cd_inc = -0.8,
        },
    }

}


