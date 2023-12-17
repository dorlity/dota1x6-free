return 
{
    [4481] = {
        ["item_id"] = 4481,
        ["name"] = "Provocation of Ruin Sword",
        ["icon"] = "econ/items/juggernaut/fall20_juggernaut_katz_weapon/fall20_juggernaut_katz_weapon",
        ["price"] = 3000,
        ["HeroModel"] = nil,
        ["ArcanaAnim"] = nil,
        ["MaterialGroupItem"] = "0",
        ["ItemModel"] = "models/items/juggernaut/fall20_juggernaut_katz_weapon/fall20_juggernaut_katz_weapon.vmdl",
        ["ParticlesItems"] = {
            {
                ["ParticleName"] = "particles/econ/items/juggernaut/jugg_fall20_immortal/jugg_fall20_immortal_weapon.vpcf",
                ["DefaultPattch"] = PATTACH_ABSORIGIN_FOLLOW,
                ["ControllPoints"] = {[0] = {"SetParticleControl", "default"}}
            }
        },
        ["ParticlesHero"] = nil,
        ["SetItems"] = nil,
        ["hide"] = 1,
        ['OtherItemsBundle'] = {{2012, "#FFFFFF"}, {4481, "#000000"}},
        ["SlotType"] = "weapon",
        ["RemoveDefaultItemsList"] = nil,
        ["Modifier"] = nil,
        ["sets"] = "katz",
    },
    [4482] = {
        ["item_id"] = 4482,
        ["name"] = "Provocation of Ruin Mask",
        ["icon"] = "econ/items/juggernaut/fall20_juggernaut_katz_head/fall20_juggernaut_katz_head",
        ["price"] = 2000,
        ["HeroModel"] = "models/heroes/juggernaut/juggernaut.vmdl",
        ["ArcanaAnim"] = nil,
        ["MaterialGroupItem"] = "0",
        ["ItemModel"] = "models/items/juggernaut/fall20_juggernaut_katz_head/fall20_juggernaut_katz_head.vmdl",
        ["ParticlesItems"] = {
            {
                ["ParticleName"] = "particles/econ/items/juggernaut/jugg_fall20_immortal/jugg_fall20_immortal_head.vpcf",
                ["DefaultPattch"] = PATTACH_ABSORIGIN_FOLLOW,
                ["ControllPoints"] = {
                    [0] = {"SetParticleControl", "default"},
                    [1] = {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_eye_l_fx"
                    },
                    [2] = {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_eye_r_fx"
                    },
                    [3] = {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_horn_l_fx"
                    },
                    [4] = {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_horn_r_fx"
                    }
                }
            }
        },
        ["ParticlesHero"] = nil,
        ["SetItems"] = nil,
        ["hide"] = 1,
        ['OtherItemsBundle'] = {{2064, "#FFFFFF"}, {4482, "#000000"}},
        ["SlotType"] = "head",
        ["RemoveDefaultItemsList"] = nil,
        ["Modifier"] = nil,
        ["sets"] = "katz",
    },
    [4483] = {
        ['item_id'] = 4483,
        ['name'] = 'Provocation of Ruin Bracers',
        ['icon'] = 'econ/items/juggernaut/fall20_juggernaut_katz_arms/fall20_juggernaut_katz_arms',
        ['price'] = 1000,
        ['HeroModel'] = nil,
        ['ArcanaAnim'] = nil,
        ['MaterialGroupItem'] = "0",
        ['ItemModel'] = 'models/items/juggernaut/fall20_juggernaut_katz_arms/fall20_juggernaut_katz_arms.vmdl',
        ['ParticlesItems'] = {
            {
                ['ParticleName'] = 'particles/econ/items/juggernaut/jugg_fall20_immortal/jugg_fall20_immortal_arms.vpcf',
                ['DefaultPattch'] = PATTACH_ABSORIGIN_FOLLOW,
                ['ControllPoints'] = {[0] = {'SetParticleControl', 'default'}}
            }
        },
        ['ParticlesHero'] = nil,
        ['SetItems'] = nil,
        ['hide'] = 1,
        ['OtherItemsBundle'] = {{2078, "#FFFFFF"}, {4483, "#000000"}},
        ['SlotType'] = 'arms',
        ['RemoveDefaultItemsList'] = nil,
        ['Modifier'] = nil,
        ["sets"] = "katz",
    },
    [4484] = {
        ['item_id'] = 4484,
        ['name'] = 'Provocation of Ruin Pauldron',
        ['icon'] = 'econ/items/juggernaut/fall20_juggernaut_katz_back/fall20_juggernaut_katz_back',
        ['price'] = 2000,
        ['HeroModel'] = nil,
        ['ArcanaAnim'] = nil,
        ['MaterialGroupItem'] = "0",
        ['ItemModel'] = 'models/items/juggernaut/fall20_juggernaut_katz_back/fall20_juggernaut_katz_back.vmdl',
        ['ParticlesItems'] = {
            {
                ['ParticleName'] = 'particles/econ/items/juggernaut/jugg_fall20_immortal/jugg_fall20_immortal_back.vpcf',
                ['DefaultPattch'] = PATTACH_ABSORIGIN_FOLLOW,
                ['ControllPoints'] = {[0] = {'SetParticleControl', 'default'}}
            }
        },
        ['ParticlesHero'] = nil,
        ['SetItems'] = nil,
        ['hide'] = 1,
        ['OtherItemsBundle'] = {{2111, "#FFFFFF"}, {4484, "#000000"}},
        ['SlotType'] = 'back',
        ['RemoveDefaultItemsList'] = nil,
        ['Modifier'] = nil,
        ["sets"] = "katz",
    },
    [4485] = {
        ['item_id'] = 4485,
        ['name'] = 'Provocation of Ruin Belt',
        ['icon'] = 'econ/items/juggernaut/fall20_juggernaut_katz_legs/fall20_juggernaut_katz_legs',
        ['price'] = 1000,
        ['HeroModel'] = nil,
        ['ArcanaAnim'] = nil,
        ['MaterialGroupItem'] = "0",
        ['ItemModel'] = 'models/items/juggernaut/fall20_juggernaut_katz_legs/fall20_juggernaut_katz_legs.vmdl',
        ['ParticlesItems'] = nil,
        ['ParticlesHero'] = nil,
        ['SetItems'] = nil,
        ['hide'] = 1,
        ['OtherItemsBundle'] = {{2118, "#FFFFFF"}, {4485, "#000000"}},
        ['SlotType'] = 'legs',
        ['RemoveDefaultItemsList'] = nil,
        ['Modifier'] = nil,
        ["sets"] = "katz",
    },
    [4478] = {
        ["item_id"] = 4478,
        ["name"] = "Fortunes Tout",
        ["icon"] = "econ/items/juggernaut/ward/fortunes_tout/fortunes_tout_npc_dota_juggernaut_healing_ward",
        ["price"] = 1000,
        ["HeroModel"] = nil,
        ["ArcanaAnim"] = nil,
        ["MaterialGroup"] = nil,
        ["ItemModel"] = "",
        ["ParticlesItems"] = nil,
        ["ParticlesHero"] = nil,
        ["SetItems"] = nil,
        ["hide"] = 0,
        ["OtherItemsBundle"] = nil,
        ["SlotType"] = "juggernaut_ward",
        ["RemoveDefaultItemsList"] = {},
        ["Modifier"] = "modifier_juggernaut_fortunes_toat_ward",
        ['sets'] = "rare",
    },
    [4499] = 
    {
        ["item_id"] = 4499,
        ["name"] = "Golden Fortune's Tout",
        ["icon"] = "econ/items/juggernaut/ward/golden_fortunes_tout/golden_fortunes_tout_npc_dota_juggernaut_healing_ward",
        ["price"] = 2000,
        ["HeroModel"] = nil,
        ["ArcanaAnim"] = nil,
        ["MaterialGroup"] = nil,
        ["ItemModel"] = "",
        ["ParticlesItems"] = nil,
        ["ParticlesHero"] = nil,
        ["SetItems"] = nil,
        ["hide"] = 0,
        ["OtherItemsBundle"] = nil,
        ["SlotType"] = "juggernaut_ward",
        ["RemoveDefaultItemsList"] = {},
        ["Modifier"] = "modifier_juggernaut_fortunes_toat_golden_ward",
        ['sets'] = "rare",
    },
    [5132] = 
    {
        ["item_id"] = 5132,
        ["name"] = "Provocation of Ruin Ward",
        ["icon"] = "econ/items/juggernaut/ward/fall20_juggernaut_katz_ward/fall20_juggernaut_katz_ward_npc_dota_juggernaut_healing_ward",
        ["price"] = 1000,
        ["HeroModel"] = nil,
        ["ArcanaAnim"] = nil,
        ["MaterialGroup"] = nil,
        ["ItemModel"] = "",
        ["ParticlesItems"] = nil,
        ["ParticlesHero"] = nil,
        ["SetItems"] = nil,
        ["hide"] = 0,
        ["OtherItemsBundle"] = nil,
        ["SlotType"] = "juggernaut_ward",
        ["RemoveDefaultItemsList"] = {},
        ["Modifier"] = "modifier_juggernaut_fall_ward",
        ["sets"] = "katz",
    },
    [5133] = 
    {
        ["item_id"] = 5133,
        ["name"] = "Isle of Dragons Ward",
        ["icon"] = "econ/items/juggernaut/ward/miyamoto_musash_ward/miyamoto_musash_ward_npc_dota_juggernaut_healing_ward_style1",
        ["price"] = 100,
        ["HeroModel"] = nil,
        ["ArcanaAnim"] = nil,
        ["MaterialGroup"] = nil,
        ["ItemModel"] = "",
        ["ParticlesItems"] = nil,
        ["ParticlesHero"] = nil,
        ["SetItems"] = nil,
        ["hide"] = 0,
        ['OtherItemsBundle'] = {{5133, "#51ccff"}, {7999, "#ff3423"}},
        ["SlotType"] = "juggernaut_ward",
        ["RemoveDefaultItemsList"] = {},
        ["Modifier"] = "modifier_juggernaut_isle_of_dragons_ward",
        ['sets'] = "miyamoto",
    },
    [7999] = 
    {
        ["item_id"] = 7999,
        ["name"] = "Isle of Dragons Ward",
        ["icon"] = "econ/items/juggernaut/ward/miyamoto_musash_ward/miyamoto_musash_ward_npc_dota_juggernaut_healing_ward_style2",
        ["price"] = 100,
        ["HeroModel"] = nil,
        ["ArcanaAnim"] = nil,
        ["MaterialGroup"] = nil,
        ["ItemModel"] = "",
        ["ParticlesItems"] = nil,
        ["ParticlesHero"] = nil,
        ["SetItems"] = nil,
        ["hide"] = 1,
        ['OtherItemsBundle'] = {{5133, "#51ccff"}, {7999, "#ff3423"}},
        ["SlotType"] = "juggernaut_ward",
        ["RemoveDefaultItemsList"] = {},
        ["Modifier"] = "modifier_juggernaut_isle_of_dragons_ward_2",
        ['sets'] = "miyamoto",
    },
    [4479] = {
        ["item_id"] = 4479,
        ["name"] = "Lineage of the Stormlords Weapon",
        ["icon"] = "econ/items/juggernaut/susano_os_descendant_weapon/susano_os_descendant_weapon",
        ["price"] = 3000,
        ["HeroModel"] = nil,
        ["ArcanaAnim"] = nil,
        ["MaterialGroup"] = nil,
        ["ItemModel"] = "models/items/juggernaut/susano_os_descendant_weapon/susano_os_descendant_weapon.vmdl",
        ["ParticlesItems"] = {
            {
                ["ParticleName"] = "particles/econ/items/juggernaut/jugg_ti10_cache/jugg_ti10_cache_weapon.vpcf",
                ["DefaultPattch"] = PATTACH_ABSORIGIN_FOLLOW,
                ["ControllPoints"] = {
                    [0] = {"SetParticleControl", "default"},
                    [1] = {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_sword_fx"
                    },
                    [2] = {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_sword_tip_fx"
                    }
                }
            }
        },
        ["ParticlesHero"] = nil,
        ["SetItems"] = nil,
        ["hide"] = 0,
        ["OtherItemsBundle"] = nil,
        ["SlotType"] = "weapon",
        ["RemoveDefaultItemsList"] = nil,
        ["Modifier"] = nil,
        ['sets'] = "susano",
    },

    [20041] = {
        ["item_id"] = 20041,
        ["name"] = "Golden Edge of the Lost Order",
        ["icon"] = "econ/items/juggernaut/jugg_ti8/jugg_ti8_sword1",
        ["price"] = 3000,
        ["HeroModel"] = nil,
        ["ArcanaAnim"] = nil,
        ["MaterialGroupItem"] = "1",
        ["ItemModel"] = "models/items/juggernaut/jugg_ti8/jugg_ti8_sword.vmdl",
        ["ParticlesItems"] = {
            {
                ["ParticleName"] = "particles/econ/items/juggernaut/jugg_ti8_sword/jugg_ti8_sword_ambient_golden.vpcf",
                ["DefaultPattch"] = PATTACH_ABSORIGIN_FOLLOW,
                ["ControllPoints"] = {
                    [0] = {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "blade_attachment", "hero"
                    },
                    [10] = {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_abyssal_a"
                    },
                    [11] = {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_abyssal_tip"
                    },
                    [12] = {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_abyssal_b"
                    },
                    [13] = {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_abyssal_c"
                    },
                    [15] = {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_smoketwist"
                    },
                    [20] = {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_gem"
                    },
                    [25] = {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_gem_b"
                    },
                    [26] = {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_gem_c"
                    }
                }
            }
        },
        ["ParticlesHero"] = nil,
        ["SetItems"] = nil,
        ["hide"] = 0,
        ["OtherItemsBundle"] = nil,
        ["SlotType"] = "weapon",
        ["RemoveDefaultItemsList"] = nil,
        ["Modifier"] = "modifier_juggernaut_edge_of_the_lost_gold",
        ['sets'] = "rare",
    },
    [2004] = {
        ["item_id"] = 2004,
        ["name"] = "Serrakura",
        ["icon"] = "econ/items/juggernaut/serrakura/serrakura",
        ["price"] = 1500,
        ["HeroModel"] = nil,
        ["ArcanaAnim"] = nil,
        ["MaterialGroup"] = nil,
        ["ItemModel"] = "models/items/juggernaut/serrakura/serrakura.vmdl",
        ["ParticlesItems"] = {
            {
                ["ParticleName"] = "particles/econ/items/juggernaut/jugg_serrakura/jugg_serrakurra_ambient.vpcf",
                ["DefaultPattch"] = PATTACH_ABSORIGIN_FOLLOW,
                ["ControllPoints"] = {
                    [0] = {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_sword", "hero"
                    }
                }
            }
        },
        ["ParticlesHero"] = nil,
        ["SetItems"] = nil,
        ["hide"] = 0,
        ["OtherItemsBundle"] = nil,
        ["SlotType"] = "weapon",
        ["RemoveDefaultItemsList"] = nil,
        ["Modifier"] = "modifier_juggernaut_item_custom_serrakura",
        ['sets'] = "rare",
    },
    [2006] = {
        ["item_id"] = 2006,
        ["name"] = "Jagged Honor Blade",
        ["icon"] = "econ/items/juggernaut/jugg_year_beast_slayer_weapon/jugg_year_beast_slayer_weapon",
        ["price"] = 3000,
        ["HeroModel"] = nil,
        ["ArcanaAnim"] = nil,
        ["MaterialGroup"] = nil,
        ["ItemModel"] = "models/items/juggernaut/jugg_year_beast_slayer_weapon/jugg_year_beast_slayer_weapon.vmdl",
        ["ParticlesItems"] = {
            {
                ["ParticleName"] = "particles/econ/items/juggernaut/jugg_slayer/jugg_slayer_weapon_ambient.vpcf",
                ["DefaultPattch"] = PATTACH_ABSORIGIN_FOLLOW,
                ["ControllPoints"] = {[0] = {"SetParticleControl", "default"}}
            }
        },
        ["ParticlesHero"] = nil,
        ["SetItems"] = nil,
        ["hide"] = 0,
        ["OtherItemsBundle"] = nil,
        ["SlotType"] = "weapon",
        ["RemoveDefaultItemsList"] = nil,
        ["Modifier"] = nil,
        ["sets"] = "beast_slayer",
    },
    [2012] = {
        ["item_id"] = 2012,
        ["name"] = "Provocation of Ruin Sword",
        ["icon"] = "econ/items/juggernaut/fall20_juggernaut_katz_weapon/fall20_juggernaut_katz_weapon",
        ["price"] = 3000,
        ["HeroModel"] = nil,
        ["ArcanaAnim"] = nil,
        ["MaterialGroupItem"] = "1",
        ["ItemModel"] = "models/items/juggernaut/fall20_juggernaut_katz_weapon/fall20_juggernaut_katz_weapon.vmdl",
        ["ParticlesItems"] = {
            {
                ["ParticleName"] = "particles/econ/items/juggernaut/jugg_fall20_immortal/jugg_fall20_immortal_weapon.vpcf",
                ["DefaultPattch"] = PATTACH_ABSORIGIN_FOLLOW,
                ["ControllPoints"] = {[0] = {"SetParticleControl", "default"}}
            }
        },
        ["ParticlesHero"] = nil,
        ["SetItems"] = nil,
        ["hide"] = 0,
        ['OtherItemsBundle'] = {{2012, "#FFFFFF"}, {4481, "#000000"}},
        ["SlotType"] = "weapon",
        ["RemoveDefaultItemsList"] = nil,
        ["Modifier"] = nil,
        ["sets"] = "katz",
    },
    [2013] = {
        ["item_id"] = 2013,
        ["name"] = "Relic Blade of the Kuur-Ishiminari",
        ["icon"] = "econ/items/juggernaut/generic_wep_jadesword",
        ["price"] = 1000,
        ["HeroModel"] = nil,
        ["ArcanaAnim"] = nil,
        ["MaterialGroup"] = nil,
        ["ItemModel"] = "models/items/juggernaut/generic_wep_jadesword.vmdl",
        ["ParticlesItems"] = {
            {
                ["ParticleName"] = "particles/econ/items/juggernaut/jugg_sword_jade/jugg_weapon_glow_variation_jade.vpcf",
                ["DefaultPattch"] = PATTACH_ABSORIGIN_FOLLOW,
                ["ControllPoints"] = {
                    [0] = {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "blade_attachment", "hero"
                    }
                }
            }
        },
        ["ParticlesHero"] = nil,
        ["SetItems"] = nil,
        ["hide"] = 0,
        ["OtherItemsBundle"] = nil,
        ["SlotType"] = "weapon",
        ["RemoveDefaultItemsList"] = nil,
        ["Modifier"] = "modifier_juggernaut_jade",
        ['sets'] = "rare",
    },
    [2014] = {
        ["item_id"] = 2014,
        ["name"] = "Kantusa the Script Sword",
        ["icon"] = "econ/items/juggernaut/generic_wep_broadsword",
        ["price"] = 8000,
        ["HeroModel"] = nil,
        ["ArcanaAnim"] = nil,
        ["MaterialGroup"] = nil,
        ["ItemModel"] = "models/items/juggernaut/generic_wep_broadsword.vmdl",
        ["ParticlesItems"] = {
            {
                ["ParticleName"] = "particles/econ/items/juggernaut/jugg_sword_script/jugg_weapon_glow_variation_script.vpcf",
                ["DefaultPattch"] = PATTACH_ABSORIGIN_FOLLOW,
                ["ControllPoints"] = {
                    [0] = {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_sword", "hero"
                    }
                }
            }
        },
        ["ParticlesHero"] = nil,
        ["SetItems"] = nil,
        ["hide"] = 0,
        ["OtherItemsBundle"] = nil,
        ["SlotType"] = "weapon",
        ["RemoveDefaultItemsList"] = nil,
        ["Modifier"] = "modifier_juggernaut_kantusa",
        ['sets'] = "rare",
    },
    [2022] = {
        ["item_id"] = 2022,
        ["name"] = "Edge of the Lost Order",
        ["icon"] = "econ/items/juggernaut/jugg_ti8/jugg_ti8_sword",
        ["price"] = 1500,
        ["HeroModel"] = nil,
        ["ArcanaAnim"] = nil,
        ["MaterialGroup"] = nil,
        ["ItemModel"] = "models/items/juggernaut/jugg_ti8/jugg_ti8_sword.vmdl",
        ["ParticlesItems"] = {
            {
                ["ParticleName"] = "particles/econ/items/juggernaut/jugg_ti8_sword/jugg_ti8_sword_ambient.vpcf",
                ["DefaultPattch"] = PATTACH_ABSORIGIN_FOLLOW,
                ["ControllPoints"] = {
                    [0] = {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "blade_attachment", "hero"
                    },
                    [10] = {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_abyssal_a"
                    },
                    [11] = {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_abyssal_tip"
                    },
                    [12] = {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_abyssal_b"
                    },
                    [13] = {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_abyssal_c"
                    },
                    [15] = {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_smoketwist"
                    },
                    [20] = {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_gem"
                    },
                    [25] = {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_gem_b"
                    },
                    [26] = {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_gem_c"
                    }
                }
            }
        },
        ["ParticlesHero"] = nil,
        ["SetItems"] = nil,
        ["hide"] = 0,
        ["OtherItemsBundle"] = nil,
        ["SlotType"] = "weapon",
        ["RemoveDefaultItemsList"] = nil,
        ["Modifier"] = "modifier_juggernaut_edge_of_the_lost",
        ['sets'] = "rare",
    },
    [2025] = {
        ["item_id"] = 2025,
        ["name"] = "Dragon Sword",
        ["icon"] = "econ/items/juggernaut/dragon_sword",
        ["price"] = 1000,
        ["HeroModel"] = nil,
        ["ArcanaAnim"] = nil,
        ["MaterialGroup"] = nil,
        ["ItemModel"] = "models/items/juggernaut/dragon_sword.vmdl",
        ["ParticlesItems"] = {
            {
                ["ParticleName"] = "particles/econ/items/juggernaut/jugg_sword_dragon/juggernaut_blade_ambient_dragon.vpcf",
                ["DefaultPattch"] = PATTACH_ABSORIGIN_FOLLOW,
                ["ControllPoints"] = {[0] = {"SetParticleControl", "default"}}
            }
        },
        ["ParticlesHero"] = nil,
        ["SetItems"] = nil,
        ["hide"] = 0,
        ["OtherItemsBundle"] = nil,
        ["SlotType"] = "weapon",
        ["RemoveDefaultItemsList"] = nil,
        ["Modifier"] = "modifier_juggernaut_dragonsword",
        ['sets'] = "rare",
    },
    [2029] = {
        ["item_id"] = 2029,
        ["name"] = "Blackened Edge of the Bladekeeper",
        ["icon"] = "econ/items/juggernaut/dc_weaponupdate/dc_weaponupdate",
        ["price"] = 1500,
        ["HeroModel"] = nil,
        ["ArcanaAnim"] = nil,
        ["MaterialGroup"] = nil,
        ["ItemModel"] = "models/items/juggernaut/dc_weaponupdate/dc_weaponupdate.vmdl",
        ["ParticlesItems"] = {
            {
                ["ParticleName"] = "particles/econ/items/juggernaut/bladekeeper_swordglow/dc_juggernaut_blade.vpcf",
                ["DefaultPattch"] = PATTACH_ABSORIGIN_FOLLOW,
                ["ControllPoints"] = {
                    [0] = {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_jugg_blade"
                    }
                }
            }
        },
        ["ParticlesHero"] = nil,
        ["SetItems"] = nil,
        ["hide"] = 0,
        ["OtherItemsBundle"] = nil,
        ["SlotType"] = "weapon",
        ["RemoveDefaultItemsList"] = nil,
        ["Modifier"] = "modifier_juggernaut_bladekeeper_weapon",
        ['sets'] = "dc",
    },
    [2031] = {
        ["item_id"] = 2031,
        ["name"] = "Sword of the Bladeform Aesthete",
        ["icon"] = "econ/items/juggernaut/armor_for_the_favorite_weapon/armor_for_the_favorite_weapon",
        ["price"] = 3000,
        ["HeroModel"] = nil,
        ["ArcanaAnim"] = nil,
        ["MaterialGroup"] = nil,
        ["ItemModel"] = "models/items/juggernaut/armor_for_the_favorite_weapon/armor_for_the_favorite_weapon.vmdl",
        ["ParticlesItems"] = {
            {
                ["ParticleName"] = "particles/econ/items/juggernaut/armor_of_the_favorite/juggernaut_favorite_weapon.vpcf",
                ["DefaultPattch"] = PATTACH_ABSORIGIN_FOLLOW,
                ["ControllPoints"] = {[0] = {"SetParticleControl", "default"}}
            }
        },
        ["ParticlesHero"] = nil,
        ["SetItems"] = nil,
        ["hide"] = 0,
        ["OtherItemsBundle"] = nil,
        ["SlotType"] = "weapon",
        ["RemoveDefaultItemsList"] = nil,
        ["Modifier"] = "modifier_juggernaut_bladeform",
        ["sets"] = "favorite",
    },
    [2034] = {
        ["item_id"] = 2034,
        ["name"] = "Crimson Edge of the Lost Order",
        ["icon"] = "econ/items/juggernaut/jugg_ti8/jugg_ti8_sword2",
        ["price"] = 10000,
        ["HeroModel"] = nil,
        ["ArcanaAnim"] = nil,
        ["MaterialGroupItem"] = "2",
        ["ItemModel"] = "models/items/juggernaut/jugg_ti8/jugg_ti8_sword.vmdl",
        ["ParticlesItems"] = {
            {
                ["ParticleName"] = "particles/econ/items/juggernaut/jugg_ti8_sword/jugg_ti8_crimson_sword_ambient.vpcf",
                ["DefaultPattch"] = PATTACH_ABSORIGIN_FOLLOW,
                ["ControllPoints"] = {
                    [0] = {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "blade_attachment", "hero"
                    },
                    [10] = {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_abyssal_a"
                    },
                    [11] = {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_abyssal_tip"
                    },
                    [12] = {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_abyssal_b"
                    },
                    [13] = {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_abyssal_c"
                    },
                    [15] = {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_smoketwist"
                    },
                    [20] = {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_gem"
                    },
                    [25] = {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_gem_b"
                    },
                    [26] = {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_gem_c"
                    }
                }
            }
        },
        ["ParticlesHero"] = nil,
        ["SetItems"] = nil,
        ["hide"] = 0,
        ["OtherItemsBundle"] = nil,
        ["SlotType"] = "weapon",
        ["RemoveDefaultItemsList"] = nil,
        ["Modifier"] = "modifier_juggernaut_edge_of_the_lost_crimson",
        ['sets'] = "rare",
    },
    [2040] = {
        ["item_id"] = 2040,
        ["name"] = "Lineage of the Stormlords Mask",
        ["icon"] = "econ/items/juggernaut/susano_os_descendant_head/susano_os_descendant_head",
        ["price"] = 1000,
        ["HeroModel"] = "models/heroes/juggernaut/juggernaut.vmdl",
        ["ArcanaAnim"] = nil,
        ["MaterialGroup"] = nil,
        ["ItemModel"] = "models/items/juggernaut/susano_os_descendant_head/susano_os_descendant_head.vmdl",
        ["ParticlesItems"] = {
            {
                ["ParticleName"] = "particles/econ/items/juggernaut/jugg_ti10_cache/jugg_ti10_cache_head.vpcf",
                ["DefaultPattch"] = PATTACH_ABSORIGIN_FOLLOW,
                ["ControllPoints"] = {
                    [0] = {"SetParticleControl", "default"},
                    [1] = {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_eye_l_fx"
                    },
                    [2] = {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_eye_r_fx"
                    },
                    [3] = {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_forehead_fx"
                    }
                }
            }
        },
        ["ParticlesHero"] = nil,
        ["SetItems"] = nil,
        ["hide"] = 0,
        ["OtherItemsBundle"] = nil,
        ["SlotType"] = "head",
        ["RemoveDefaultItemsList"] = nil,
        ["Modifier"] = nil,
        ['sets'] = "susano",
    },
    [2049] = {
        ["item_id"] = 2049,
        ["name"] = "Hood of the Bladeform Aesthete",
        ["icon"] = "econ/items/juggernaut/armor_for_the_favorite_head/armor_for_the_favorite_head",
        ["price"] = 1000,
        ["HeroModel"] = "models/heroes/juggernaut/juggernaut.vmdl",
        ["ArcanaAnim"] = nil,
        ["MaterialGroup"] = nil,
        ["ItemModel"] = "models/items/juggernaut/armor_for_the_favorite_head/armor_for_the_favorite_head.vmdl",
        ["ParticlesItems"] = {
            {
                ["ParticleName"] = "particles/econ/items/juggernaut/armor_of_the_favorite/juggernaut_favorite_eyes.vpcf",
                ["DefaultPattch"] = PATTACH_ABSORIGIN_FOLLOW,
                ["ControllPoints"] = {
                    [0] = {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_eye_l"
                    },
                    [1] = {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_eye_r"
                    }
                }
            }
        },
        ["ParticlesHero"] = nil,
        ["SetItems"] = nil,
        ["hide"] = 0,
        ["OtherItemsBundle"] = nil,
        ["SlotType"] = "head",
        ["RemoveDefaultItemsList"] = nil,
        ["Modifier"] = nil,
        ["sets"] = "favorite",
    },
    [2052] = {
        ["item_id"] = 2052,
        ["name"] = "Sigil Mask of the Bladekeeper",
        ["icon"] = "econ/items/juggernaut/dc_headupdate/dc_headupdate",
        ["price"] = 600,
        ["HeroModel"] = "models/heroes/juggernaut/juggernaut.vmdl",
        ["ArcanaAnim"] = nil,
        ["MaterialGroup"] = nil,
        ["ItemModel"] = "models/items/juggernaut/dc_headupdate/dc_headupdate.vmdl",
        ["ParticlesItems"] = {
            {
                ["ParticleName"] = "particles/econ/items/juggernaut/bladekeeper_headglow/dc_juggernaut_bladekeeper_head.vpcf",
                ["DefaultPattch"] = PATTACH_ABSORIGIN_FOLLOW,
                ["ControllPoints"] = {
                    [0] = {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_jugg_head"
                    }
                }
            }
        },
        ["ParticlesHero"] = nil,
        ["SetItems"] = nil,
        ["hide"] = 0,
        ["OtherItemsBundle"] = nil,
        ["SlotType"] = "head",
        ["RemoveDefaultItemsList"] = nil,
        ["Modifier"] = nil,
        ['sets'] = "dc",
    },
    [2059] = {
        ["item_id"] = 2059,
        ["name"] = "Bladeform Legacy",
        ["icon"] = "econ/items/juggernaut/arcana/juggernaut_arcana_mask_style1",
        ["price"] = 15000,
        ["HeroModel"] = "models/heroes/juggernaut/juggernaut_arcana.vmdl",
        ["ArcanaAnim"] = "arcana",
        ["MaterialGroup"] = "0",
        ["ItemModel"] = "models/items/juggernaut/arcana/juggernaut_arcana_mask.vmdl",
        ["ParticlesItems"] = {
            {
                ["ParticleName"] = "particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_ambient.vpcf",
                ["DefaultPattch"] = PATTACH_ABSORIGIN_FOLLOW,
                ["ControllPoints"] = {
                    [0] = {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_head"
                    },
                    [1] = {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_tail"
                    },
                    [3] = {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_eye_l"
                    },
                    [4] = {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_eye_r"
                    }
                }
            }
        },
        ["ParticlesHero"] = {
            {
                ["ParticleName"] = "particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_body_ambient.vpcf",
                ["DefaultPattch"] = PATTACH_ABSORIGIN_FOLLOW,
                ['IsHero'] = 1,
                ["ControllPoints"] = {[0] = {"SetParticleControl", "default"}}
            }
        },
        ["SetItems"] = nil,
        ["hide"] = 0,
        ["OtherItemsBundle"] = {{2059, "#73ffee"}, {2068, "#ff713f"}},
        ["SlotType"] = "head",
        ["RemoveDefaultItemsList"] = nil,
        ["Modifier"] = "modifier_juggernaut_arcana",
        ['sets'] = "rare",
    },
    [2068] = {
        ["item_id"] = 2068,
        ["name"] = "Bladeform Legacy",
        ["icon"] = "econ/items/juggernaut/arcana/juggernaut_arcana_mask_style2",
        ["price"] = 15000,
        ["HeroModel"] = "models/heroes/juggernaut/juggernaut_arcana.vmdl",
        ["ArcanaAnim"] = "arcana",
        ["MaterialGroup"] = "1",
        ["ItemModel"] = "models/items/juggernaut/arcana/juggernaut_arcana_mask.vmdl",
        ["ParticlesItems"] = {
            {
                ["ParticleName"] = "particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_v2_ambient.vpcf",
                ["DefaultPattch"] = PATTACH_ABSORIGIN_FOLLOW,
                ["ControllPoints"] = {
                    [0] = {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_head"
                    },
                    [1] = {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_tail"
                    },
                    [3] = {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_eye_l"
                    },
                    [4] = {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_eye_r"
                    }
                }
            }
        },
        ["ParticlesHero"] = {
            {
                ["ParticleName"] = "particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_v2_body_ambient.vpcf",
                ["DefaultPattch"] = PATTACH_ABSORIGIN_FOLLOW,
                ['IsHero'] = 1,
                ["ControllPoints"] = {[0] = {"SetParticleControl", "default"}}
            }
        },
        ["SetItems"] = nil,
        ["hide"] = 1,
        ["OtherItemsBundle"] = {{2059, "#73ffee"}, {2068, "#ff713f"}},
        ["SlotType"] = "head",
        ["RemoveDefaultItemsList"] = nil,
        ["Modifier"] = "modifier_juggernaut_arcana_v2",
        ['sets'] = "rare",
    },
    [2064] = {
        ["item_id"] = 2064,
        ["name"] = "Provocation of Ruin Mask",
        ["icon"] = "econ/items/juggernaut/fall20_juggernaut_katz_head/fall20_juggernaut_katz_head",
        ["price"] = 2000,
        ["HeroModel"] = "models/heroes/juggernaut/juggernaut.vmdl",
        ["ArcanaAnim"] = nil,
        ["MaterialGroupItem"] = "1",
        ["ItemModel"] = "models/items/juggernaut/fall20_juggernaut_katz_head/fall20_juggernaut_katz_head.vmdl",
        ["ParticlesItems"] = {
            {
                ["ParticleName"] = "particles/econ/items/juggernaut/jugg_fall20_immortal/jugg_fall20_immortal_head.vpcf",
                ["DefaultPattch"] = PATTACH_ABSORIGIN_FOLLOW,
                ["ControllPoints"] = {
                    [0] = {"SetParticleControl", "default"},
                    [1] = {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_eye_l_fx"
                    },
                    [2] = {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_eye_r_fx"
                    },
                    [3] = {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_horn_l_fx"
                    },
                    [4] = {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_horn_r_fx"
                    }
                }
            }
        },
        ["ParticlesHero"] = nil,
        ["SetItems"] = nil,
        ["hide"] = 0,
        ['OtherItemsBundle'] = {{2064, "#FFFFFF"}, {4482, "#000000"}},
        ["SlotType"] = "head",
        ["RemoveDefaultItemsList"] = nil,
        ["Modifier"] = nil,
        ["sets"] = "katz",
    },
    [2078] = {
        ['item_id'] = 2078,
        ['name'] = 'Provocation of Ruin Bracers',
        ['icon'] = 'econ/items/juggernaut/fall20_juggernaut_katz_arms/fall20_juggernaut_katz_arms',
        ['price'] = 1000,
        ['HeroModel'] = nil,
        ['ArcanaAnim'] = nil,
        ['MaterialGroupItem'] = "1",
        ['ItemModel'] = 'models/items/juggernaut/fall20_juggernaut_katz_arms/fall20_juggernaut_katz_arms.vmdl',
        ['ParticlesItems'] = {
            {
                ['ParticleName'] = 'particles/econ/items/juggernaut/jugg_fall20_immortal/jugg_fall20_immortal_arms.vpcf',
                ['DefaultPattch'] = PATTACH_ABSORIGIN_FOLLOW,
                ['ControllPoints'] = {[0] = {'SetParticleControl', 'default'}}
            }
        },
        ['ParticlesHero'] = nil,
        ['SetItems'] = nil,
        ['hide'] = 0,
        ['OtherItemsBundle'] = {{2078, "#FFFFFF"}, {4483, "#000000"}},
        ['SlotType'] = 'arms',
        ['RemoveDefaultItemsList'] = nil,
        ['Modifier'] = nil,
        ["sets"] = "katz",
    },
    [2067] = {
        ["item_id"] = 2067,
        ["name"] = "Jagged Honor Mask",
        ["icon"] = "econ/items/juggernaut/jugg_year_beast_slayer_head/jugg_year_beast_slayer_head",
        ["price"] = 1000,
        ["HeroModel"] = "models/heroes/juggernaut/juggernaut.vmdl",
        ["ArcanaAnim"] = nil,
        ["MaterialGroup"] = nil,
        ["ItemModel"] = "models/items/juggernaut/jugg_year_beast_slayer_head/jugg_year_beast_slayer_head.vmdl",
        ["ParticlesItems"] = {
            {
                ["ParticleName"] = "particles/econ/items/juggernaut/jugg_slayer/jugg_slayer_head_ambient.vpcf",
                ["DefaultPattch"] = PATTACH_ABSORIGIN_FOLLOW,
                ["ControllPoints"] = {
                    [0] = {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_eye_r"
                    },
                    [1] = {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_eye_l"
                    }
                }
            }
        },
        ["ParticlesHero"] = nil,
        ["SetItems"] = nil,
        ["hide"] = 0,
        ["OtherItemsBundle"] = nil,
        ["SlotType"] = "head",
        ["RemoveDefaultItemsList"] = nil,
        ["Modifier"] = nil,
        ["sets"] = "beast_slayer",
    },
    [2097] = {
        ['item_id'] = 2097,
        ['name'] = 'Jagged Honor Banner',
        ['icon'] = 'econ/items/juggernaut/jugg_year_beast_slayer_back/jugg_year_beast_slayer_back',
        ['price'] = 3000,
        ['HeroModel'] = nil,
        ['ArcanaAnim'] = nil,
        ['MaterialGroup'] = nil,
        ['ItemModel'] = 'models/items/juggernaut/jugg_year_beast_slayer_back/jugg_year_beast_slayer_back.vmdl',
        ["ParticlesItems"] = {
            {
                ["ParticleName"] = "particles/econ/items/juggernaut/jugg_slayer/jugg_slayer_back_ambient.vpcf",
                ["DefaultPattch"] = PATTACH_ABSORIGIN_FOLLOW,
                ["ControllPoints"] = {[0] = {"SetParticleControl", "default"}}
            }
        },
        ['ParticlesHero'] = nil,
        ['SetItems'] = nil,
        ['hide'] = 0,
        ['OtherItemsBundle'] = nil,
        ['SlotType'] = 'back',
        ['RemoveDefaultItemsList'] = nil,
        ['Modifier'] = nil,
        ["sets"] = "beast_slayer",
    },
    [2070] = {
        ['item_id'] = 2070,
        ['name'] = 'Prayer Beads of the Bladekeeper',
        ['icon'] = 'econ/items/juggernaut/dc_armsupdate/dc_armsupdate',
        ['price'] = 600,
        ['HeroModel'] = nil,
        ['ArcanaAnim'] = nil,
        ['MaterialGroup'] = nil,
        ['ItemModel'] = 'models/items/juggernaut/dc_armsupdate/dc_armsupdate.vmdl',
        ['ParticlesItems'] = nil,
        ['ParticlesHero'] = nil,
        ['SetItems'] = nil,
        ['hide'] = 0,
        ['OtherItemsBundle'] = nil,
        ['SlotType'] = 'arms',
        ['RemoveDefaultItemsList'] = nil,
        ['Modifier'] = nil,
        ['sets'] = "dc",
    },
    [2079] = {
        ['item_id'] = 2079,
        ['name'] = 'Lineage of the Stormlords Arms',
        ['icon'] = 'econ/items/juggernaut/susano_os_descendant_arms/susano_os_descendant_arms',
        ['price'] = 1000,
        ['HeroModel'] = nil,
        ['ArcanaAnim'] = nil,
        ['MaterialGroup'] = nil,
        ['ItemModel'] = 'models/items/juggernaut/susano_os_descendant_arms/susano_os_descendant_arms.vmdl',
        ['ParticlesItems'] = {
            {
                ['ParticleName'] = 'particles/econ/items/juggernaut/jugg_ti10_cache/jugg_ti10_cache_arms.vpcf',
                ['DefaultPattch'] = PATTACH_ABSORIGIN_FOLLOW,
                ['ControllPoints'] = {[0] = {'SetParticleControl', 'default'}}
            }
        },
        ['ParticlesHero'] = nil,
        ['SetItems'] = nil,
        ['hide'] = 0,
        ['OtherItemsBundle'] = nil,
        ['SlotType'] = 'arms',
        ['RemoveDefaultItemsList'] = nil,
        ['Modifier'] = nil,
        ['sets'] = "susano",
    },
    [2080] = {
        ['item_id'] = 2080,
        ['name'] = 'Jagged Honor Bracer',
        ['icon'] = 'econ/items/juggernaut/jugg_year_beast_slayer_arms/jugg_year_beast_slayer_arms',
        ['price'] = 1000,
        ['HeroModel'] = nil,
        ['ArcanaAnim'] = nil,
        ['MaterialGroup'] = nil,
        ['ItemModel'] = 'models/items/juggernaut/jugg_year_beast_slayer_arms/jugg_year_beast_slayer_arms.vmdl',
        ['ParticlesItems'] = {
            {
                ['ParticleName'] = 'particles/econ/items/juggernaut/jugg_slayer/jugg_slayer_arms_ambient.vpcf',
                ['DefaultPattch'] = PATTACH_ABSORIGIN_FOLLOW,
                ['ControllPoints'] = {[0] = {'SetParticleControl', 'default'}}
            }
        },
        ['ParticlesHero'] = nil,
        ['SetItems'] = nil,
        ['hide'] = 0,
        ['OtherItemsBundle'] = nil,
        ['SlotType'] = 'arms',
        ['RemoveDefaultItemsList'] = nil,
        ['Modifier'] = nil,
        ["sets"] = "beast_slayer",
    },
    [2083] = {
        ['item_id'] = 2083,
        ['name'] = 'Bracers of the Bladeform Aesthete',
        ['icon'] = 'econ/items/juggernaut/armor_for_the_favorite_arms/armor_for_the_favorite_arms',
        ['price'] = 1000,
        ['HeroModel'] = nil,
        ['ArcanaAnim'] = nil,
        ['MaterialGroup'] = nil,
        ['ItemModel'] = 'models/items/juggernaut/armor_for_the_favorite_arms/armor_for_the_favorite_arms.vmdl',
        ['ParticlesItems'] = nil,
        ['ParticlesHero'] = nil,
        ['SetItems'] = nil,
        ['hide'] = 0,
        ['OtherItemsBundle'] = nil,
        ['SlotType'] = 'arms',
        ['RemoveDefaultItemsList'] = nil,
        ['Modifier'] = nil,
        ["sets"] = "favorite",
    },
    [2096] = {
        ['item_id'] = 2096,
        ['name'] = 'Lineage of the Stormlords Back',
        ['icon'] = 'econ/items/juggernaut/susano_os_descendant_back/susano_os_descendant_back',
        ['price'] = 2000,
        ['HeroModel'] = nil,
        ['ArcanaAnim'] = nil,
        ['MaterialGroup'] = nil,
        ['ItemModel'] = 'models/items/juggernaut/susano_os_descendant_back/susano_os_descendant_back.vmdl',
        ['ParticlesItems'] = {
            {
                ['ParticleName'] = 'particles/econ/items/juggernaut/jugg_ti10_cache/jugg_ti10_cache_back.vpcf',
                ['DefaultPattch'] = PATTACH_ABSORIGIN_FOLLOW,
                ['ControllPoints'] = {[0] = {'SetParticleControl', 'default'}}
            }
        },
        ['ParticlesHero'] = nil,
        ['SetItems'] = nil,
        ['hide'] = 0,
        ['OtherItemsBundle'] = nil,
        ['SlotType'] = 'back',
        ['RemoveDefaultItemsList'] = nil,
        ['Modifier'] = nil,
        ['sets'] = "susano",
    },
    [2098] = {
        ['item_id'] = 2098,
        ['name'] = 'Arsenal of the Bladekeeper',
        ['icon'] = 'econ/items/juggernaut/dc_backupdate4/dc_backupdate4',
        ['price'] = 700,
        ['HeroModel'] = nil,
        ['ArcanaAnim'] = nil,
        ['MaterialGroup'] = nil,
        ['ItemModel'] = 'models/items/juggernaut/dc_backupdate4/dc_backupdate4.vmdl',
        ['ParticlesItems'] = nil,
        ['ParticlesHero'] = nil,
        ['SetItems'] = nil,
        ['hide'] = 0,
        ['OtherItemsBundle'] = nil,
        ['SlotType'] = 'back',
        ['RemoveDefaultItemsList'] = nil,
        ['Modifier'] = nil,
        ['sets'] = "dc",
    },
    [2105] = {
        ['item_id'] = 2105,
        ['name'] = 'Shoulders of the Bladeform Aesthete',
        ['icon'] = 'econ/items/juggernaut/armor_for_the_favorite_back/armor_for_the_favorite_back',
        ['price'] = 1000,
        ['HeroModel'] = nil,
        ['ArcanaAnim'] = nil,
        ['MaterialGroup'] = nil,
        ['ItemModel'] = 'models/items/juggernaut/armor_for_the_favorite_back/armor_for_the_favorite_back.vmdl',
        ['ParticlesItems'] = {
            {
                ['ParticleName'] = 'particles/econ/items/juggernaut/armor_of_the_favorite/juggernaut_favorite_shoulder_ambient.vpcf',
                ['DefaultPattch'] = PATTACH_ABSORIGIN_FOLLOW,
                ['ControllPoints'] = {[0] = {'SetParticleControl', 'default'}}
            }
        },
        ['ParticlesHero'] = nil,
        ['SetItems'] = nil,
        ['hide'] = 0,
        ['OtherItemsBundle'] = nil,
        ['SlotType'] = 'back',
        ['RemoveDefaultItemsList'] = nil,
        ['Modifier'] = nil,
        ["sets"] = "favorite",
    },
    [2111] = {
        ['item_id'] = 2111,
        ['name'] = 'Provocation of Ruin Pauldron',
        ['icon'] = 'econ/items/juggernaut/fall20_juggernaut_katz_back/fall20_juggernaut_katz_back',
        ['price'] = 2000,
        ['HeroModel'] = nil,
        ['ArcanaAnim'] = nil,
        ['MaterialGroupItem'] = "1",
        ['ItemModel'] = 'models/items/juggernaut/fall20_juggernaut_katz_back/fall20_juggernaut_katz_back.vmdl',
        ['ParticlesItems'] = {
            {
                ['ParticleName'] = 'particles/econ/items/juggernaut/jugg_fall20_immortal/jugg_fall20_immortal_back.vpcf',
                ['DefaultPattch'] = PATTACH_ABSORIGIN_FOLLOW,
                ['ControllPoints'] = {[0] = {'SetParticleControl', 'default'}}
            }
        },
        ['ParticlesHero'] = nil,
        ['SetItems'] = nil,
        ['hide'] = 0,
        ['OtherItemsBundle'] = {{2111, "#FFFFFF"}, {4484, "#000000"}},
        ['SlotType'] = 'back',
        ['RemoveDefaultItemsList'] = nil,
        ['Modifier'] = nil,
        ["sets"] = "katz",
    },
    [2118] = {
        ['item_id'] = 2118,
        ['name'] = 'Provocation of Ruin Belt',
        ['icon'] = 'econ/items/juggernaut/fall20_juggernaut_katz_legs/fall20_juggernaut_katz_legs',
        ['price'] = 1000,
        ['HeroModel'] = nil,
        ['ArcanaAnim'] = nil,
        ['MaterialGroupItem'] = "1",
        ['ItemModel'] = 'models/items/juggernaut/fall20_juggernaut_katz_legs/fall20_juggernaut_katz_legs.vmdl',
        ['ParticlesItems'] = nil,
        ['ParticlesHero'] = nil,
        ['SetItems'] = nil,
        ['hide'] = 0,
        ['OtherItemsBundle'] = {{2118, "#FFFFFF"}, {4485, "#000000"}},
        ['SlotType'] = 'legs',
        ['RemoveDefaultItemsList'] = nil,
        ['Modifier'] = nil,
        ["sets"] = "katz",
    },
    [2120] = {
        ['item_id'] = 2120,
        ['name'] = 'Jagged Honor Legs',
        ['icon'] = 'econ/items/juggernaut/jugg_year_beast_slayer_legs/jugg_year_beast_slayer_legs',
        ['price'] = 2000,
        ['HeroModel'] = nil,
        ['ArcanaAnim'] = nil,
        ['MaterialGroup'] = nil,
        ['ItemModel'] = 'models/items/juggernaut/jugg_year_beast_slayer_legs/jugg_year_beast_slayer_legs.vmdl',
        ['ParticlesItems'] = {
            {
                ['ParticleName'] = 'particles/econ/items/juggernaut/jugg_slayer/jugg_slayer_legs_ambient.vpcf',
                ['DefaultPattch'] = PATTACH_ABSORIGIN_FOLLOW,
                ['ControllPoints'] = {[0] = {'SetParticleControl', 'default'}}
            }
        },
        ['ParticlesHero'] = nil,
        ['SetItems'] = nil,
        ['hide'] = 0,
        ['OtherItemsBundle'] = nil,
        ['SlotType'] = 'legs',
        ['RemoveDefaultItemsList'] = nil,
        ['Modifier'] = nil,
        ["sets"] = "beast_slayer",
    },
    [2121] = {
        ['item_id'] = 2121,
        ['name'] = 'Belt of the Bladeform Aesthete',
        ['icon'] = 'econ/items/juggernaut/armor_for_the_favorite_legs/armor_for_the_favorite_legs',
        ['price'] = 2000,
        ['HeroModel'] = nil,
        ['ArcanaAnim'] = nil,
        ['MaterialGroup'] = nil,
        ['ItemModel'] = 'models/items/juggernaut/armor_for_the_favorite_legs/armor_for_the_favorite_legs.vmdl',
        ['ParticlesItems'] = {
            {
                ['ParticleName'] = 'particles/econ/items/juggernaut/armor_of_the_favorite/juggernaut_favorite_body_ambient.vpcf',
                ['DefaultPattch'] = PATTACH_ABSORIGIN_FOLLOW,
                ['ControllPoints'] = {
                    [0] = {'SetParticleControl', 'default'},
                    [1] = {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_belt", "hero"
                    }
                }
            }
        },
        ['ParticlesHero'] = nil,
        ['SetItems'] = nil,
        ['hide'] = 0,
        ['OtherItemsBundle'] = nil,
        ['SlotType'] = 'legs',
        ['RemoveDefaultItemsList'] = nil,
        ['Modifier'] = nil,
        ["sets"] = "favorite",
    },
    [2132] = {
        ['item_id'] = 2132,
        ['name'] = 'Pantaloons of the Bladekeeper',
        ['icon'] = 'econ/items/juggernaut/dc_legsupdate5/dc_legsupdate5',
        ['price'] = 600,
        ['HeroModel'] = nil,
        ['ArcanaAnim'] = nil,
        ['MaterialGroup'] = nil,
        ['ItemModel'] = 'models/items/juggernaut/dc_legsupdate5/dc_legsupdate5.vmdl',
        ['ParticlesItems'] = nil,
        ['ParticlesHero'] = nil,
        ['SetItems'] = nil,
        ['hide'] = 0,
        ['OtherItemsBundle'] = nil,
        ['SlotType'] = 'legs',
        ['RemoveDefaultItemsList'] = nil,
        ['Modifier'] = nil,
        ['sets'] = "dc",
    },
    [2133] = {
        ['item_id'] = 2133,
        ['name'] = 'Lineage of the Stormlords Legs',
        ['icon'] = 'econ/items/juggernaut/susano_os_descendant_legs/susano_os_descendant_legs',
        ['price'] = 1000,
        ['HeroModel'] = nil,
        ['ArcanaAnim'] = nil,
        ['MaterialGroup'] = nil,
        ['ItemModel'] = 'models/items/juggernaut/susano_os_descendant_legs/susano_os_descendant_legs.vmdl',
        ['ParticlesItems'] = {
            {
                ['ParticleName'] = 'particles/econ/items/juggernaut/jugg_ti10_cache/jugg_ti10_cache_legs.vpcf',
                ['DefaultPattch'] = PATTACH_ABSORIGIN_FOLLOW,
                ['ControllPoints'] = {[0] = {'SetParticleControl', 'default'}}
            }
        },
        ['ParticlesHero'] = nil,
        ['SetItems'] = nil,
        ['hide'] = 0,
        ['OtherItemsBundle'] = nil,
        ['SlotType'] = 'legs',
        ['RemoveDefaultItemsList'] = nil,
        ['Modifier'] = nil,
        ['sets'] = "susano",
    },
    [4501] = 
    {
        ['item_id'] = 4501,
        ['name'] = 'Isle of Dragons Bracers',
        ['icon'] = 'econ/items/juggernaut/miyamoto_musash_arms/miyamoto_musash_arms_1',
        ['price'] = 100,
        ['HeroModel'] = nil,
        ['ArcanaAnim'] = nil,
        ['MaterialGroupItem'] = "1",
        ['ItemModel'] = 'models/items/juggernaut/miyamoto_musash_arms/miyamoto_musash_arms.vmdl',
        ['ParticlesItems'] = nil,
        ['ParticlesHero'] = nil,
        ['SetItems'] = nil,
        ['hide'] = 0,
        ['OtherItemsBundle'] = {{4501, "#51ccff"} , {4502, "#ff3423"}},
        ['SlotType'] = 'arms',
        ['RemoveDefaultItemsList'] = nil,
        ['Modifier'] = nil,
        ['sets'] = "miyamoto",
    },
    [4502] = 
    {
        ['item_id'] = 4502,
        ['name'] = 'Isle of Dragons Bracers',
        ['icon'] = 'econ/items/juggernaut/miyamoto_musash_arms/miyamoto_musash_arms_style2',
        ['price'] = 100,
        ['HeroModel'] = nil,
        ['ArcanaAnim'] = nil,
        ['MaterialGroupItem'] = "2",
        ['ItemModel'] = 'models/items/juggernaut/miyamoto_musash_arms/miyamoto_musash_arms.vmdl',
        ['ParticlesItems'] = nil,
        ['ParticlesHero'] = nil,
        ['SetItems'] = nil,
        ['hide'] = 1,
        ['OtherItemsBundle'] = {{4501, "#51ccff"} , {4502, "#ff3423"}},
        ['SlotType'] = 'arms',
        ['RemoveDefaultItemsList'] = nil,
        ['Modifier'] = nil,
        ['sets'] = "miyamoto",
    },
    [4504] = 
    {
        ['item_id'] = 4504,
        ['name'] = 'Isle of Dragons Armor',
        ['icon'] = 'econ/items/juggernaut/miyamoto_musash_back/miyamoto_musash_back_style1',
        ['price'] = 200,
        ['HeroModel'] = nil,
        ['ArcanaAnim'] = nil,
        ['MaterialGroupItem'] = "1",
        ['ItemModel'] = 'models/items/juggernaut/miyamoto_musash_back/miyamoto_musash_back.vmdl',
        ["ParticlesItems"] = 
        {
            {
                ["ParticleName"] = "particles/econ/items/juggernaut/jugg_2022_cc/jugg_2022_cc_back_ambient.vpcf",
                ["DefaultPattch"] = PATTACH_ABSORIGIN_FOLLOW,
                ["ControllPoints"] = 
                {
                    [0] = {"SetParticleControl", "default"},
                    [2] = 
                    {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_back_fx"
                    }
                }
            }
        },
        ['ParticlesHero'] = nil,
        ['SetItems'] = nil,
        ['hide'] = 0,
        ['OtherItemsBundle'] = {{4504, "#51ccff"} , {4505, "#ff3423"}},
        ['SlotType'] = 'back',
        ['RemoveDefaultItemsList'] = nil,
        ['Modifier'] = nil,
        ['sets'] = "miyamoto",
    },
    [4505] = 
    {
        ['item_id'] = 4505,
        ['name'] = 'Isle of Dragons Armor',
        ['icon'] = 'econ/items/juggernaut/miyamoto_musash_back/miyamoto_musash_back_style2',
        ['price'] = 200,
        ['HeroModel'] = nil,
        ['ArcanaAnim'] = nil,
        ['MaterialGroupItem'] = "2",
        ['ItemModel'] = 'models/items/juggernaut/miyamoto_musash_back/miyamoto_musash_back.vmdl',
        ["ParticlesItems"] = 
        {
            {
                ["ParticleName"] = "particles/econ/items/juggernaut/jugg_2022_cc/jugg_2022_cc_back_ambient_v2.vpcf",
                ["DefaultPattch"] = PATTACH_ABSORIGIN_FOLLOW,
                ["ControllPoints"] = 
                {
                    [0] = {"SetParticleControl", "default"},
                    [2] = 
                    {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_back_fx"
                    }
                }
            }
        },
        ['ParticlesHero'] = nil,
        ['SetItems'] = nil,
        ['hide'] = 1,
        ['OtherItemsBundle'] = {{4504, "#51ccff"} , {4505, "#ff3423"}},
        ['SlotType'] = 'back',
        ['RemoveDefaultItemsList'] = nil,
        ['Modifier'] = nil,
        ['sets'] = "miyamoto",
    },
    [4507] = 
    {
        ['item_id'] = 4507,
        ['name'] = 'Isle of Dragons Mask',
        ['icon'] = 'econ/items/juggernaut/miyamoto_musash_head/miyamoto_musash_head_style1',
        ['price'] = 100,
        ['HeroModel'] = "models/heroes/juggernaut/juggernaut.vmdl",
        ['ArcanaAnim'] = nil,
        ['MaterialGroupItem'] = "1",
        ['ItemModel'] = 'models/items/juggernaut/miyamoto_musash_head/miyamoto_musash_head.vmdl',
        ["ParticlesItems"] = 
        {
            {
                ["ParticleName"] = "particles/econ/items/juggernaut/jugg_2022_cc/jugg_2022_cc_head_ambient.vpcf",
                ["DefaultPattch"] = PATTACH_ABSORIGIN_FOLLOW,
                ["ControllPoints"] = 
                {
                    [0] = {"SetParticleControl", "default"},
                    [1] = 
                    {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_eye_fx_left"
                    },
                    [2] = 
                    {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_eye_fx_right"
                    }
                }
            }
        },
        ['ParticlesHero'] = nil,
        ['SetItems'] = nil,
        ['hide'] = 0,
        ['OtherItemsBundle'] = {{4507, "#51ccff"} , {4508, "#ff3423"}},
        ['SlotType'] = 'head',
        ['RemoveDefaultItemsList'] = nil,
        ['Modifier'] = nil,
        ['sets'] = "miyamoto",
    },
    [4508] = 
    {
        ['item_id'] = 4508,
        ['name'] = 'Isle of Dragons Mask',
        ['icon'] = 'econ/items/juggernaut/miyamoto_musash_head/miyamoto_musash_head_style2',
        ['price'] = 100,
        ['HeroModel'] = "models/heroes/juggernaut/juggernaut.vmdl",
        ['ArcanaAnim'] = nil,
        ['MaterialGroupItem'] = "2",
        ['ItemModel'] = 'models/items/juggernaut/miyamoto_musash_head/miyamoto_musash_head.vmdl',
        ["ParticlesItems"] = 
        {
            {
                ["ParticleName"] = "particles/econ/items/juggernaut/jugg_2022_cc/jugg_2022_cc_v2_head_ambient.vpcf",
                ["DefaultPattch"] = PATTACH_ABSORIGIN_FOLLOW,
                ["ControllPoints"] = 
                {
                    [0] = {"SetParticleControl", "default"},
                    [1] = 
                    {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_eye_fx_left"
                    },
                    [2] = 
                    {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_eye_fx_right"
                    }
                }
            }
        },
        ['ParticlesHero'] = nil,
        ['SetItems'] = nil,
        ['hide'] = 1,
        ['OtherItemsBundle'] = {{4507, "#51ccff"} , {4508, "#ff3423"}},
        ['SlotType'] = 'head',
        ['RemoveDefaultItemsList'] = nil,
        ['Modifier'] = nil,
        ['sets'] = "miyamoto",
    },
    [4510] = 
    {
        ['item_id'] = 4510,
        ['name'] = 'Isle of Dragons Skirt',
        ['icon'] = 'econ/items/juggernaut/miyamoto_musash_legs/miyamoto_musash_legs_style1',
        ['price'] = 100,
        ['HeroModel'] = nil,
        ['ArcanaAnim'] = nil,
        ['MaterialGroupItem'] = "1",
        ['ItemModel'] = 'models/items/juggernaut/miyamoto_musash_legs/miyamoto_musash_legs.vmdl',
        ["ParticlesItems"] = 
        {
            {
                ["ParticleName"] = "particles/econ/items/juggernaut/jugg_2022_cc/jugg_2022_cc_legs_ambient.vpcf",
                ["DefaultPattch"] = PATTACH_ABSORIGIN_FOLLOW,
                ["ControllPoints"] = 
                {
                    [0] = {"SetParticleControl", "default"},
                    [1] = 
                    {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_belt_fx"
                    },
                }
            }
        },
        ['ParticlesHero'] = nil,
        ['SetItems'] = nil,
        ['hide'] = 0,
        ['OtherItemsBundle'] = {{4510, "#51ccff"} , {4511, "#ff3423"}},
        ['SlotType'] = 'legs',
        ['RemoveDefaultItemsList'] = nil,
        ['Modifier'] = nil,
        ['sets'] = "miyamoto",
    },
    [4511] = 
    {
        ['item_id'] = 4511,
        ['name'] = 'Isle of Dragons Skirt',
        ['icon'] = 'econ/items/juggernaut/miyamoto_musash_legs/miyamoto_musash_legs_style2',
        ['price'] = 100,
        ['HeroModel'] = nil,
        ['ArcanaAnim'] = nil,
        ['MaterialGroupItem'] = "2",
        ['ItemModel'] = 'models/items/juggernaut/miyamoto_musash_legs/miyamoto_musash_legs.vmdl',
        ["ParticlesItems"] = 
        {
            {
                ["ParticleName"] = "particles/econ/items/juggernaut/jugg_2022_cc/jugg_2022_cc_legs_ambient_v2.vpcf",
                ["DefaultPattch"] = PATTACH_ABSORIGIN_FOLLOW,
                ["ControllPoints"] = 
                {
                    [0] = {"SetParticleControl", "default"},
                    [1] = 
                    {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_belt_fx"
                    },
                }
            }
        },
        ['ParticlesHero'] = nil,
        ['SetItems'] = nil,
        ['hide'] = 1,
        ['OtherItemsBundle'] = {{4510, "#51ccff"} , {4511, "#ff3423"}},
        ['SlotType'] = 'legs',
        ['RemoveDefaultItemsList'] = nil,
        ['Modifier'] = nil,
        ['sets'] = "miyamoto",
    },
    [4513] = 
    {
        ['item_id'] = 4513,
        ['name'] = 'Isle of Dragons Sword',
        ['icon'] = 'econ/items/juggernaut/miyamoto_musash_weapon/miyamoto_musash_weapon_style1',
        ['price'] = 400,
        ['HeroModel'] = nil,
        ['ArcanaAnim'] = nil,
        ['MaterialGroupItem'] = "1",
        ['ItemModel'] = 'models/items/juggernaut/miyamoto_musash_weapon/miyamoto_musash_weapon.vmdl',
        ["ParticlesItems"] = 
        {
            {
                ["ParticleName"] = "particles/econ/items/juggernaut/jugg_2022_cc/jugg_2022_cc_weapon_ambient.vpcf",
                ["DefaultPattch"] = PATTACH_ABSORIGIN_FOLLOW,
                ["ControllPoints"] = 
                {
                    [0] = {"SetParticleControl", "default"},
                    [3] = 
                    {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_weapon_core_fx"
                    },
                    [4] = 
                    {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_weapon_core_end_fx"
                    },
                    [5] = 
                    {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_weapon_core_tip_fx"
                    },
                }
            }
        },
        ['ParticlesHero'] = nil,
        ['SetItems'] = nil,
        ['hide'] = 0,
        ['OtherItemsBundle'] = {{4513, "#51ccff"} , {4514, "#ff3423"}},
        ['SlotType'] = 'weapon',
        ['RemoveDefaultItemsList'] = nil,
        ['Modifier'] = nil,
        ['sets'] = "miyamoto",
    },
    [4514] = 
    {
        ['item_id'] = 4514,
        ['name'] = 'Isle of Dragons Sword',
        ['icon'] = 'econ/items/juggernaut/miyamoto_musash_weapon/miyamoto_musash_weapon_style2',
        ['price'] = 400,
        ['HeroModel'] = nil,
        ['ArcanaAnim'] = nil,
        ['MaterialGroupItem'] = "2",
        ['ItemModel'] = 'models/items/juggernaut/miyamoto_musash_weapon/miyamoto_musash_weapon.vmdl',
        ["ParticlesItems"] = 
        {
            {
                ["ParticleName"] = "particles/econ/items/juggernaut/jugg_2022_cc/jugg_2022_cc_weapon_ambient_v2.vpcf",
                ["DefaultPattch"] = PATTACH_ABSORIGIN_FOLLOW,
                ["ControllPoints"] = 
                {
                    [0] = {"SetParticleControl", "default"},
                    [3] = 
                    {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_weapon_core_fx"
                    },
                    [4] = 
                    {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_weapon_core_end_fx"
                    },
                    [5] = 
                    {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_weapon_core_tip_fx"
                    },
                }
            }
        },
        ['ParticlesHero'] = nil,
        ['SetItems'] = nil,
        ['hide'] = 1,
        ['OtherItemsBundle'] = {{4513, "#51ccff"} , {4514, "#ff3423"}},
        ['SlotType'] = 'weapon',
        ['RemoveDefaultItemsList'] = nil,
        ['Modifier'] = nil,
        ['sets'] = "miyamoto",
    },



    [22405] = 
    {
        ['item_id'] = 22405,
        ['name'] = 'Default Jugger Weapon',
        ['icon'] = '',
        ['price'] = 1,
        ['HeroModel'] = nil,
        ['ArcanaAnim'] = nil,
        ['MaterialGroup'] = nil,
        ['ItemModel'] = 'models/heroes/juggernaut/jugg_sword.vmdl',
        ['ParticlesItems'] = {
            {
                ['ParticleName'] = 'particles/units/heroes/hero_juggernaut/juggernaut_blade_generic.vpcf',
                ['DefaultPattch'] = PATTACH_ABSORIGIN_FOLLOW,
                ['ControllPoints'] = {
                    [0] = 
                    {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_sword", "hero"
                    },
                }
            }
        },
        ['ParticlesHero'] = nil,
        ['SetItems'] = nil,
        ['hide'] = 1,
        ['OtherItemsBundle'] = nil,
        ['SlotType'] = 'weapon',
        ['RemoveDefaultItemsList'] = nil,
        ['Modifier'] = nil,
        ['sets'] = "rare",
    },
}
