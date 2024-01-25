return
{
    [13544] = {
            ['item_id'] =13544,
            ['name'] ='Mask of the Demon Trickster',
            ['icon'] ='econ/items/monkey_king/mk_ti9_immortal_head/mk_ti9_immortal_head',
            ['price'] = 1000,
            ['HeroModel'] = nil,
            ['ArcanaAnim'] = nil,
            ['MaterialGroup'] = "default",
            ['ItemModel'] ='models/items/monkey_king/mk_ti9_immortal_head/mk_ti9_immortal_head.vmdl',
            ["ParticlesItems"] = 
            {
                {
                    ["ParticleName"] = "particles/econ/items/monkey_king/mk_ti9_immortal/mk_ti9_immortal_head_ambient.vpcf",
                    ["DefaultPattch"] = PATTACH_ABSORIGIN_FOLLOW,
                    ["ControllPoints"] = 
                    {
                        [0] = 
                        {
                            'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                            "attach_eye_l"
                        },
                        [1] = 
                        {
                            'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                            "attach_eye_r"
                        },
                    }
                },
            },
            ['SetItems'] = nil,
            ['hide'] = 0,
            ['OtherItemsBundle'] = nil,
            ['SlotType'] = 'head',
            ['RemoveDefaultItemsList'] = nil,
            ['Modifier'] = nil,
            ['sets'] = 'demon_trickster',
    },
    [13545] = {
            ['item_id'] =13545,
            ['name'] ='Pauldrons of the Demon Trickster',
            ['icon'] ='econ/items/monkey_king/mk_ti9_immortal_shoulder/mk_ti9_immortal_shoulder',
            ['price'] = 1000,
            ['HeroModel'] = nil,
            ['ArcanaAnim'] = nil,
            ['MaterialGroup'] = nil,
            ['ItemModel'] ='models/items/monkey_king/mk_ti9_immortal_shoulder/mk_ti9_immortal_shoulder.vmdl',
            ["ParticlesItems"] = 
            {
                {
                    ["ParticleName"] = "particles/econ/items/monkey_king/mk_ti9_immortal/mk_ti9_immortal_shoulders_ambient.vpcf",
                    ["DefaultPattch"] = PATTACH_ABSORIGIN_FOLLOW,
                    ["ControllPoints"] = 
                    {
                        [0] = 
                        {
                            'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                            "attach_wrist_l_1"
                        },
                        [1] = 
                        {
                            'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                            "attach_wrist_l_2"
                        },
                        [2] = 
                        {
                            'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                            "attach_wrist_l_3"
                        },
                        [3] = 
                        {
                            'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                            "attach_wrist_l_4"
                        },
                        [4] = 
                        {
                            'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                            "attach_wrist_r_1"
                        },
                        [5] = 
                        {
                            'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                            "attach_wrist_r_2"
                        },
                        [6] = 
                        {
                            'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                            "attach_wrist_r_3"
                        },
                        [7] = 
                        {
                            'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                            "attach_wrist_r_4"
                        },
                    }
                },
            },
            ['SetItems'] = nil,
            ['hide'] = 0,
            ['OtherItemsBundle'] = nil,
            ['SlotType'] = 'shoulder',
            ['RemoveDefaultItemsList'] = nil,
            ['Modifier'] = nil,
            ['sets'] = 'demon_trickster',
    },
    [13546] = {
            ['item_id'] =13546,
            ['name'] ='Staff of the Demon Trickster',
            ['icon'] ='econ/items/monkey_king/mk_ti9_immortal_weapon/mk_ti9_immortal_weapon',
            ['price'] = 1000,
            ['HeroModel'] = nil,
            ['ArcanaAnim'] = nil,
            ['MaterialGroup'] = nil,
            ['ItemModel'] ='models/items/monkey_king/mk_ti9_immortal_weapon/mk_ti9_immortal_weapon.vmdl',
            ["ParticlesItems"] = 
            {
                {
                    ["ParticleName"] = "particles/econ/items/monkey_king/mk_ti9_immortal/mk_ti9_immortal_weapon_ambient.vpcf",
                    ["DefaultPattch"] = PATTACH_ABSORIGIN_FOLLOW,
                    ["ControllPoints"] = 
                    {
                        [0] = 
                        {
                            'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                            "attach_eye_l"
                        },
                        [1] = 
                        {
                            'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                            "attach_eye_r"
                        },
                        [2] = 
                        {
                            'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                            "attach_attack1", "hero"
                        },
                        [3] = 
                        {
                            'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                            "attach_eye_l"
                        },
                    }
                },
            },
            ['SetItems'] = nil,
            ['hide'] = 0,
            ['OtherItemsBundle'] = nil,
            ['SlotType'] = 'weapon',
            ['RemoveDefaultItemsList'] = nil,
            ['Modifier'] = nil,
            ['sets'] = 'demon_trickster',
    },
    [13008] = {
            ['item_id'] =13008,
            ['name'] ='Armor of the Demon Trickster',
            ['icon'] ='econ/items/monkey_king/mk_ti9_immortal_armor/mk_ti9_immortal_armor',
            ['price'] = 5000,
            ['HeroModel'] = nil,
            ['ArcanaAnim'] = nil,
            ['MaterialGroup'] = nil,
            ['MaterialGroupItem'] = "0",
            ['ItemModel'] ='models/items/monkey_king/mk_ti9_immortal_armor/mk_ti9_immortal_armor.vmdl',
            ["ParticlesItems"] = 
            {
                {
                    ["ParticleName"] = "particles/econ/items/monkey_king/mk_ti9_immortal/mk_ti9_immortal_armor_ambient.vpcf",
                    ["DefaultPattch"] = PATTACH_ABSORIGIN_FOLLOW,
                    ["ControllPoints"] = 
                    {
                        [0] = {"SetParticleControl", "default"},
                    }
                },
            },
            ['SetItems'] = nil,
            ['hide'] = 0,
            ['OtherItemsBundle'] = {{13008, "#f42c1d"}, {1300801, "#5c8cff"}, {1300802, "#5dd35b"}, {1300803, "#eea820"}},
            ['SlotType'] = 'armor',
            ['RemoveDefaultItemsList'] = nil,
            ['Modifier'] = "modifier_monkey_king_demon_tricker_custom",
            ['sets'] = 'demon_trickster',
    },
    [1300801] = {
            ['item_id'] =1300801,
            ['name'] ='Armor of the Demon Trickster',
            ['icon'] ='econ/items/monkey_king/mk_ti9_immortal_armor/mk_ti9_immortal_armor',
            ['price'] = 5000,
            ['HeroModel'] = nil,
            ['ArcanaAnim'] = nil,
            ['MaterialGroup'] = nil,
            ['MaterialGroupItem'] = "1",
            ['ItemModel'] ='models/items/monkey_king/mk_ti9_immortal_armor/mk_ti9_immortal_armor.vmdl',
            ["ParticlesItems"] = 
            {
                {
                    ["ParticleName"] = "particles/econ/items/monkey_king/mk_ti9_immortal/mk_ti9_immortal_armor_ambient.vpcf",
                    ["DefaultPattch"] = PATTACH_ABSORIGIN_FOLLOW,
                    ["ControllPoints"] = 
                    {
                        [0] = {"SetParticleControl", "default"},
                    }
                },
            },
            ['SetItems'] = nil,
            ['hide'] = 1,
            ['OtherItemsBundle'] = {{13008, "#f42c1d"}, {1300801, "#5c8cff"}, {1300802, "#5dd35b"}, {1300803, "#eea820"}},
            ['SlotType'] = 'armor',
            ['RemoveDefaultItemsList'] = nil,
            ['Modifier'] = "modifier_monkey_king_demon_tricker_custom",
            ['sets'] = 'demon_trickster',
    },
    [1300802] = {
        ['item_id'] =1300802,
        ['name'] ='Armor of the Demon Trickster',
        ['icon'] ='econ/items/monkey_king/mk_ti9_immortal_armor/mk_ti9_immortal_armor',
        ['price'] = 5000,
        ['HeroModel'] = nil,
        ['ArcanaAnim'] = nil,
        ['MaterialGroup'] = nil,
        ['MaterialGroupItem'] = "2",
        ['ItemModel'] ='models/items/monkey_king/mk_ti9_immortal_armor/mk_ti9_immortal_armor.vmdl',
        ["ParticlesItems"] = 
        {
            {
                ["ParticleName"] = "particles/econ/items/monkey_king/mk_ti9_immortal/mk_ti9_immortal_armor_ambient.vpcf",
                ["DefaultPattch"] = PATTACH_ABSORIGIN_FOLLOW,
                ["ControllPoints"] = 
                {
                    [0] = {"SetParticleControl", "default"},
                }
            },
        },
        ['SetItems'] = nil,
        ['hide'] = 1,
        ['OtherItemsBundle'] = {{13008, "#f42c1d"}, {1300801, "#5c8cff"}, {1300802, "#5dd35b"}, {1300803, "#eea820"}},
        ['SlotType'] = 'armor',
        ['RemoveDefaultItemsList'] = nil,
        ['Modifier'] = "modifier_monkey_king_demon_tricker_custom",
        ['sets'] = 'demon_trickster',
    },
    [1300803] = {
        ['item_id'] =1300803,
        ['name'] ='Armor of the Demon Trickster',
        ['icon'] ='econ/items/monkey_king/mk_ti9_immortal_armor/mk_ti9_immortal_armor',
        ['price'] = 5000,
        ['HeroModel'] = nil,
        ['ArcanaAnim'] = nil,
        ['MaterialGroup'] = nil,
        ['MaterialGroupItem'] = "3",
        ['ItemModel'] ='models/items/monkey_king/mk_ti9_immortal_armor/mk_ti9_immortal_armor.vmdl',
        ["ParticlesItems"] = 
        {
            {
                ["ParticleName"] = "particles/econ/items/monkey_king/mk_ti9_immortal/mk_ti9_immortal_armor_ambient.vpcf",
                ["DefaultPattch"] = PATTACH_ABSORIGIN_FOLLOW,
                ["ControllPoints"] = 
                {
                    [0] = {"SetParticleControl", "default"},
                }
            },
        },
        ['SetItems'] = nil,
        ['hide'] = 1,
        ['OtherItemsBundle'] = {{13008, "#f42c1d"}, {1300801, "#5c8cff"}, {1300802, "#5dd35b"}, {1300803, "#eea820"}},
        ['SlotType'] = 'armor',
        ['RemoveDefaultItemsList'] = nil,
        ['Modifier'] = "modifier_monkey_king_demon_tricker_custom",
        ['sets'] = 'demon_trickster',
    },

    [12693] = {
            ['item_id'] =12693,
            ['name'] ='Staff of the Masks of Mischief',
            ['icon'] ='econ/items/monkey_king/dota_plus_monkey_king_weapon/dota_plus_monkey_king_weapon',
            ['price'] = 200,
            ['HeroModel'] = nil,
            ['ArcanaAnim'] = nil,
            ['MaterialGroup'] = nil,
            ['ItemModel'] ='models/items/monkey_king/dota_plus_monkey_king_weapon/dota_plus_monkey_king_weapon.vmdl',
            ['SetItems'] = nil,
            ['hide'] = 0,
            ["ParticlesItems"] = 
            {
                {
                    ["ParticleName"] = "particles/econ/items/monkey_king/plus_2018/monkey_king_plus_2018_weapon_ambient.vpcf",
                    ["DefaultPattch"] = PATTACH_ABSORIGIN_FOLLOW,
                    ["ControllPoints"] = 
                    {
                        [0] = {"SetParticleControl", "default"},
                        [1] = 
                        {
                            'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                            "attach_weapon_tip"
                        },
                        [2] = 
                        {
                            'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                            "attach_weapon_bot"
                        },
                    }
                },
            },
            ['OtherItemsBundle'] = nil,
            ['SlotType'] = 'weapon',
            ['RemoveDefaultItemsList'] = nil,
            ['Modifier'] = nil,
            ['sets'] = 'mask_mischief',
    },
    [12695] = {
            ['item_id'] =12695,
            ['name'] ='Garb of the Masks of Mischief',
            ['icon'] ='econ/items/monkey_king/dota_plus_monkey_king_shoulders/dota_plus_monkey_king_shoulders',
            ['price'] = 200,
            ['HeroModel'] = nil,
            ['ArcanaAnim'] = nil,
            ['MaterialGroup'] = nil,
            ['ItemModel'] ='models/items/monkey_king/dota_plus_monkey_king_shoulders/dota_plus_monkey_king_shoulders.vmdl',
            ['SetItems'] = nil,
            ['hide'] = 0,
            ["ParticlesItems"] = 
            {
                {
                    ["ParticleName"] = "particles/econ/items/monkey_king/plus_2018/monkey_king_plus_2018_shoulders_ambient.vpcf",
                    ["DefaultPattch"] = PATTACH_ABSORIGIN_FOLLOW,
                    ["ControllPoints"] = 
                    {
                        [0] = {"SetParticleControl", "default"},
                    }
                },
            },
            ['OtherItemsBundle'] = nil,
            ['SlotType'] = 'shoulder',
            ['RemoveDefaultItemsList'] = nil,
            ['Modifier'] = nil,
            ['sets'] = 'mask_mischief',
    },
    [12696] = {
            ['item_id'] =12696,
            ['name'] ='Crown of the Masks of Mischief',
            ['icon'] ='econ/items/monkey_king/dota_plus_monkey_king_head/dota_plus_monkey_king_head',
            ['price'] = 300,
            ['HeroModel'] = nil,
            ['ArcanaAnim'] = nil,
            ['MaterialGroup'] = "default",
            ['ItemModel'] ='models/items/monkey_king/dota_plus_monkey_king_head/dota_plus_monkey_king_head.vmdl',
            ['SetItems'] = nil,
            ['hide'] = 0,
            ["ParticlesItems"] = 
            {
                {
                    ["ParticleName"] = "particles/econ/items/monkey_king/plus_2018/monkey_king_plus_2018_head_ambient.vpcf",
                    ["DefaultPattch"] = PATTACH_ABSORIGIN_FOLLOW,
                    ["ControllPoints"] = 
                    {
                        [0] = {"SetParticleControl", "default"},
                        [2] = 
                        {
                            'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                            "attach_head"
                        },
                        [2] = 
                        {
                            'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                            "attach_eye_l"
                        },
                        [3] = 
                        {
                            'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                            "attach_eye_r"
                        },
                        [4] = {"SetParticleControl", "default"},
                    }
                },
            },
            ['OtherItemsBundle'] = nil,
            ['SlotType'] = 'head',
            ['RemoveDefaultItemsList'] = nil,
            ['Modifier'] = nil,
            ['sets'] = 'mask_mischief',
    },
    [12694] = {
        ['item_id'] =12694,
        ['name'] ='Armor of the Masks of Mischief',
        ['icon'] ='econ/items/monkey_king/dota_plus_monkey_king_armor/dota_plus_monkey_king_armor',
        ['price'] = 300,
        ['HeroModel'] = nil,
        ['ArcanaAnim'] = nil,
        ['MaterialGroup'] = nil,
        ['ItemModel'] ='models/items/monkey_king/dota_plus_monkey_king_armor/dota_plus_monkey_king_armor.vmdl',
        ['SetItems'] = nil,
        ['hide'] = 0,
        ['OtherItemsBundle'] = nil,
        ['SlotType'] = 'armor',
        ['RemoveDefaultItemsList'] = nil,
        ['Modifier'] = nil,
        ['sets'] = 'mask_mischief',
        ["ParticlesItems"] = 
        {
            {
                ["ParticleName"] = "particles/econ/items/monkey_king/plus_2018/monkey_king_plus_2018_armor_ambient.vpcf",
                ["DefaultPattch"] = PATTACH_ABSORIGIN_FOLLOW,
                ["ControllPoints"] = 
                {
                    [0] = {"SetParticleControl", "default"},
                }
            },
        },
    },

    [25352] = {
            ['item_id'] =25352,
            ['name'] ='Champion of the Fire Lotus - Armor',
            ['icon'] ='econ/items/monkey_king/mk_fiery_vajrapani_armor/mk_fiery_vajrapani_armor',
            ['price'] = 1000,
            ['HeroModel'] = nil,
            ['ArcanaAnim'] = nil,
            ['MaterialGroup'] = nil,
            ['ItemModel'] ='models/items/monkey_king/mk_fiery_vajrapani_armor/mk_fiery_vajrapani_armor.vmdl',
            ['SetItems'] = nil,
            ['hide'] = 0,
            ['OtherItemsBundle'] = nil,
            ['SlotType'] = 'armor',
            ['RemoveDefaultItemsList'] = nil,
            ['Modifier'] = nil,
            ['sets'] = 'fire_lotus_champ',
    },
    [25353] = {
        ['item_id'] =25353,
        ['name'] ='Champion of the Fire Lotus - Head',
        ['icon'] ='econ/items/monkey_king/mk_fiery_vajrapani_head/mk_fiery_vajrapani_head',
        ['price'] = 800,
        ['HeroModel'] = nil,
        ['ArcanaAnim'] = nil,
        ['MaterialGroup'] = "default",
        ['ItemModel'] ='models/items/monkey_king/mk_fiery_vajrapani_head/mk_fiery_vajrapani_head.vmdl',
        ['SetItems'] = nil,
        ['hide'] = 0,
        ['OtherItemsBundle'] = nil,
        ['SlotType'] = 'head',
        ['RemoveDefaultItemsList'] = nil,
        ['Modifier'] = nil,
        ['sets'] = 'fire_lotus_champ',
        ["ParticlesItems"] = 
        {
            {
                ["ParticleName"] = "particles/econ/items/monkey_king/mk_collectors_cache_2022/mk_collectors_cache_ambient_head.vpcf",
                ["DefaultPattch"] = PATTACH_ABSORIGIN_FOLLOW,
                ["ControllPoints"] = 
                {
                    [0] = {"SetParticleControl", "default"},
                    [1] = {"SetParticleControl", "default"},
                    [10] = 
                    {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "r_eye"
                    },
                    [11] = 
                    {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "l_eye"
                    },
                }
            },
        },
    },
    [25371] = {
        ['item_id'] =25371,
        ['name'] ='Champion of the Fire Lotus - Weapon',
        ['icon'] ='econ/items/monkey_king/mk_fiery_vajrapani_weapon/mk_fiery_vajrapani_weapon',
        ['price'] = 600,
        ['HeroModel'] = nil,
        ['ArcanaAnim'] = nil,
        ['MaterialGroup'] = nil,
        ['ItemModel'] ='models/items/monkey_king/mk_fiery_vajrapani_weapon/mk_fiery_vajrapani_weapon.vmdl',
        ['SetItems'] = nil,
        ['hide'] = 0,
        ['OtherItemsBundle'] = nil,
        ['SlotType'] = 'weapon',
        ['RemoveDefaultItemsList'] = nil,
        ['Modifier'] = nil,
        ['sets'] = 'fire_lotus_champ',
        ["ParticlesItems"] = 
        {
            {
                ["ParticleName"] = "particles/econ/items/monkey_king/mk_collectors_cache_2022/mk_collectors_cache_ambient_weapon.vpcf",
                ["DefaultPattch"] = PATTACH_ABSORIGIN_FOLLOW,
                ["ControllPoints"] = 
                {
                    [0] = {"SetParticleControl", "default"},
                }
            },
        },
    },
    [25354] = {
            ['item_id'] =25354,
            ['name'] ='Champion of the Fire Lotus - Shoulder',
            ['icon'] ='econ/items/monkey_king/mk_fiery_vajrapani_shoulder/mk_fiery_vajrapani_shoulder',
            ['price'] = 600,
            ['HeroModel'] = nil,
            ['ArcanaAnim'] = nil,
            ['MaterialGroup'] = nil,
            ['ItemModel'] ='models/items/monkey_king/mk_fiery_vajrapani_shoulder/mk_fiery_vajrapani_shoulder.vmdl',
            ['SetItems'] = nil,
            ['hide'] = 0,
            ['OtherItemsBundle'] = nil,
            ['SlotType'] = 'shoulder',
            ['RemoveDefaultItemsList'] = nil,
            ['Modifier'] = nil,
            ['sets'] = 'fire_lotus_champ',
            ["ParticlesItems"] = 
            {
                {
                    ["ParticleName"] = "particles/econ/items/monkey_king/mk_collectors_cache_2022/mk_collectors_cache_ambient_shoulder.vpcf",
                    ["DefaultPattch"] = PATTACH_ABSORIGIN_FOLLOW,
                    ["ControllPoints"] = 
                    {
                        [0] = {"SetParticleControl", "default"},
                        [10] = 
                        {
                            'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                            "snake_mouth"
                        },
                    }
                },
            },
    },

    [9212] = 
    {
        ['item_id'] =9212,
        ['name'] ='Staff of Gun-Yu',
        ['icon'] ='econ/items/monkey_king/monkey_king_immortal_weapon/monkey_king_immortal_weapon',
        ['price'] = 1000,
        ['HeroModel'] = nil,
        ['ArcanaAnim'] = nil,
        ['MaterialGroup'] = nil,
        ['ItemModel'] ='models/items/monkey_king/monkey_king_immortal_weapon/monkey_king_immortal_weapon.vmdl',
        ['SetItems'] = nil,
        ['hide'] = 0,
        ['OtherItemsBundle'] = nil,
        ['SlotType'] = 'weapon',
        ['RemoveDefaultItemsList'] = nil,
        ['Modifier'] = "modifier_monkey_king_staff_of_gunyu_custom",
        ['sets'] = 'rare',
        ['MaterialGroupItem'] = "default",
        ["ParticlesItems"] = 
        {
            {
                ["ParticleName"] = "particles/econ/items/monkey_king/ti7_weapon/mk_ti7_immortal_weapon_ambient.vpcf",
                ["DefaultPattch"] = PATTACH_ABSORIGIN_FOLLOW,
                ["ControllPoints"] = 
                {
                    [0] = {"SetParticleControl", "default"},
                    [3] = 
                    {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_weapon_jugg"
                    },
                    [5] = 
                    {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_swirl_tip_l"
                    },
                    [6] = 
                    {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_swirl_tip_r"
                    },
                    [7] = 
                    {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_swirl_end"
                    },
                }
            },
        },
    },
    [9453] = {
            ['item_id'] =9453,
            ['name'] ='Golden Staff of Gun-Yu',
            ['icon'] ='econ/items/monkey_king/monkey_king_immortal_weapon/monkey_king_immortal_weapon2',
            ['price'] = 2000,
            ['HeroModel'] = nil,
            ['ArcanaAnim'] = nil,
            ['MaterialGroup'] = nil,
            ['ItemModel'] ='models/items/monkey_king/monkey_king_immortal_weapon/monkey_king_immortal_weapon.vmdl',
            ['SetItems'] = nil,
            ['hide'] = 0,
            ['OtherItemsBundle'] = nil,
            ['SlotType'] = 'weapon',
            ['RemoveDefaultItemsList'] = nil,
            ['Modifier'] = "modifier_monkey_king_staff_of_gunyu_custom_golden",
            ['sets'] = 'rare',
            ['MaterialGroupItem'] = "2",
            ["ParticlesItems"] = 
            {
                {
                    ["ParticleName"] = "particles/econ/items/monkey_king/ti7_weapon/mk_ti7_golden_immortal_weapon_ambient.vpcf",
                    ["DefaultPattch"] = PATTACH_ABSORIGIN_FOLLOW,
                    ["ControllPoints"] = 
                    {
                        [0] = {"SetParticleControl", "default"},
                        [3] = 
                        {
                            'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                            "attach_weapon_jugg"
                        },
                        [5] = 
                        {
                            'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                            "attach_swirl_tip_l"
                        },
                        [6] = 
                        {
                            'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                            "attach_swirl_tip_r"
                        },
                        [7] = 
                        {
                            'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                            "attach_swirl_end"
                        },
                    }
                },
            },
    },
    [29347] = {
            ['item_id'] =29347,
            ['name'] ='10th Anniversary Staff of Gun-Yu',
            ['icon'] ='econ/items/monkey_king/monkey_king_immortal_weapon/monkey_king_immortal_weapon3',
            ['price'] = 3000,
            ['HeroModel'] = nil,
            ['ArcanaAnim'] = nil,
            ['MaterialGroup'] = nil,
            ['ItemModel'] ='models/items/monkey_king/monkey_king_immortal_weapon/monkey_king_immortal_weapon.vmdl',
            ['SetItems'] = nil,
            ['hide'] = 0,
            ['OtherItemsBundle'] = nil,
            ['SlotType'] = 'weapon',
            ['RemoveDefaultItemsList'] = nil,
            ['Modifier'] = "modifier_monkey_king_staff_of_gunyu_custom_anniversary",
            ['sets'] = 'rare',
            ['MaterialGroupItem'] = "3",
            ["ParticlesItems"] = 
            {
                {
                    ["ParticleName"] = "particles/econ/items/monkey_king/ti7_weapon/mk_10th_anniversary_weapon_ambient.vpcf",
                    ["DefaultPattch"] = PATTACH_ABSORIGIN_FOLLOW,
                    ["ControllPoints"] = 
                    {
                        [0] = {"SetParticleControl", "default"},
                        [3] = 
                        {
                            'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                            "attach_weapon_jugg"
                        },
                        [5] = 
                        {
                            'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                            "attach_swirl_tip_l"
                        },
                        [6] = 
                        {
                            'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                            "attach_swirl_tip_r"
                        },
                        [7] = 
                        {
                            'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                            "attach_swirl_end"
                        },
                    }
                },
            },
    },



    [905001] = 
    {
        ['item_id'] =905001,
        ['name'] ='Great Sages Reckoning',
        ['icon'] ='econ/items/monkey_king/monkey_king_arcana_head/monkey_king_arcana',
        ['price'] = 15000,
        ['sale'] = 0,
        ['sale_price'] = 0,
        ['HeroModel'] = nil,
        ['ArcanaAnim'] = nil,
        ['MaterialGroup'] = "1",
        ['is_exclusive'] = 1,
        ['MaterialGroupItem'] = "0",
        ['ItemModel'] ='models/items/monkey_king/monkey_king_arcana_head/mesh/monkey_king_arcana.vmdl',
        ['SetItems'] = nil,
        ['hide'] = 0,
        ['OtherItemsBundle'] = {{905001, "#ebc3af"}, {905002, "#5c8cff"}, {905003, "#5dd35b"}, {905004, "#eea820"}},
        ['SlotType'] = 'head',
        ['RemoveDefaultItemsList'] = nil,
        ['Modifier'] = "modifier_monkey_king_arcana_custom_v1",
        ['sets'] = 'rare',
        ["ParticlesItems"] = 
        {
            {
                ["ParticleName"] = "particles/econ/items/monkey_king/arcana/monkey_king_arcana_crown.vpcf",
                ["DefaultPattch"] = PATTACH_ABSORIGIN_FOLLOW,
                ["ControllPoints"] = 
                {
                    [0] = 
                    {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_crownfx"
                    },
                }
            },
        },
    },
    [905002] = 
    {
        ['item_id'] =905002,
        ['name'] ='Great Sages Reckoning',
        ['icon'] ='econ/items/monkey_king/monkey_king_arcana_head/monkey_king_arcana_style1',
        ['price'] = 15000,
        ['HeroModel'] = nil,
        ['ArcanaAnim'] = nil,
        ['MaterialGroup'] = "2",
        ['MaterialGroupItem'] = "1",
        ['ItemModel'] ='models/items/monkey_king/monkey_king_arcana_head/mesh/monkey_king_arcana.vmdl',
        ['SetItems'] = nil,
        ['hide'] = 1,
        ['OtherItemsBundle'] = {{905001, "#ebc3af"}, {905002, "#5c8cff"}, {905003, "#5dd35b"}, {905004, "#eea820"}},
        ['SlotType'] = 'head',
        ['RemoveDefaultItemsList'] = nil,
        ['Modifier'] = "modifier_monkey_king_arcana_custom_v2",
        ['sets'] = 'rare',
        ['ParticlesHero'] = 
        {
            {
                ["ParticleName"] = "particles/econ/items/monkey_king/arcana/monkey_king_arcana_water.vpcf",
                ["DefaultPattch"] = PATTACH_ABSORIGIN_FOLLOW,
                ['IsHero'] = 1,
                ["ControllPoints"] = 
                {
                    [0] = {"SetParticleControl", "default"},
                    [1] = 
                    {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_eye_l", "hero",
                    },
                    [2] = 
                    {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_eye_r", "hero",
                    },
                    [3] = 
                    {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_hand_l", "hero",
                    },
                    [4] = 
                    {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_hand_r", "hero",
                    },
                }
            },
        },
        ["ParticlesItems"] = 
        {
            {
                ["ParticleName"] = "particles/econ/items/monkey_king/arcana/monkey_king_arcana_crown_water.vpcf",
                ["DefaultPattch"] = PATTACH_ABSORIGIN_FOLLOW,
                ["ControllPoints"] = 
                {
                    [0] = 
                    {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_crownfx"
                    },
                }
            },
        },
    },
    [905003] = 
    {
        ['item_id'] =905003,
        ['name'] ='Great Sages Reckoning',
        ['icon'] ='econ/items/monkey_king/monkey_king_arcana_head/monkey_king_arcana_style2',
        ['price'] = 15000,
        ['HeroModel'] = nil,
        ['ArcanaAnim'] = nil,
        ['MaterialGroup'] = "3",
        ['MaterialGroupItem'] = "2",
        ['ItemModel'] ='models/items/monkey_king/monkey_king_arcana_head/mesh/monkey_king_arcana.vmdl',
        ['SetItems'] = nil,
        ['hide'] = 1,
        ['OtherItemsBundle'] = {{905001, "#ebc3af"}, {905002, "#5c8cff"}, {905003, "#5dd35b"}, {905004, "#eea820"}},
        ['SlotType'] = 'head',
        ['RemoveDefaultItemsList'] = nil,
        ['Modifier'] = "modifier_monkey_king_arcana_custom_v3",
        ['sets'] = 'rare',
        ['ParticlesHero'] = 
        {
            {
                ["ParticleName"] = "particles/econ/items/monkey_king/arcana/monkey_king_arcana_death.vpcf",
                ["DefaultPattch"] = PATTACH_ABSORIGIN_FOLLOW,
                ['IsHero'] = 1,
                ["ControllPoints"] = 
                {
                    [0] = {"SetParticleControl", "default"},
                    [1] = 
                    {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_eye_l", "hero",
                    },
                    [2] = 
                    {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_eye_r", "hero",
                    },
                    [3] = 
                    {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_hand_l", "hero",
                    },
                    [4] = 
                    {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_hand_r", "hero",
                    },
                }
            },
        },
        ["ParticlesItems"] = 
        {
            {
                ["ParticleName"] = "particles/econ/items/monkey_king/arcana/monkey_king_arcana_crown_death.vpcf",
                ["DefaultPattch"] = PATTACH_ABSORIGIN_FOLLOW,
                ["ControllPoints"] = 
                {
                    [0] = 
                    {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_crownfx"
                    },
                }
            },
        },
    },
    [905004] = 
    {
        ['item_id'] =905004,
        ['name'] ='Great Sages Reckoning',
        ['icon'] ='econ/items/monkey_king/monkey_king_arcana_head/monkey_king_arcana_style3',
        ['price'] = 15000,
        ['HeroModel'] = nil,
        ['ArcanaAnim'] = nil,
        ['MaterialGroup'] = "4",
        ['MaterialGroupItem'] = "3",
        ['ItemModel'] ='models/items/monkey_king/monkey_king_arcana_head/mesh/monkey_king_arcana.vmdl',
        ['SetItems'] = nil,
        ['hide'] = 1,
        ['OtherItemsBundle'] = {{905001, "#ebc3af"}, {905002, "#5c8cff"}, {905003, "#5dd35b"}, {905004, "#eea820"}},
        ['SlotType'] = 'head',
        ['RemoveDefaultItemsList'] = nil,
        ['Modifier'] = "modifier_monkey_king_arcana_custom_v4",
        ['sets'] = 'rare',
        ['ParticlesHero'] = 
        {
            {
                ["ParticleName"] = "particles/econ/items/monkey_king/arcana/monkey_king_arcana_fire.vpcf",
                ["DefaultPattch"] = PATTACH_ABSORIGIN_FOLLOW,
                ['IsHero'] = 1,
                ["ControllPoints"] = 
                {
                    [0] = {"SetParticleControl", "default"},
                    [1] = 
                    {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_eye_l", "hero",
                    },
                    [2] = 
                    {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_eye_r", "hero",
                    },
                    [3] = 
                    {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_hand_l", "hero",
                    },
                    [4] = 
                    {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_hand_r", "hero",
                    },
                }
            },
        },
        ["ParticlesItems"] = 
        {
            {
                ["ParticleName"] = "particles/econ/items/monkey_king/arcana/monkey_king_arcana_crown_fire.vpcf",
                ["DefaultPattch"] = PATTACH_ABSORIGIN_FOLLOW,
                ["ControllPoints"] = 
                {
                    [0] = 
                    {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_crownfx"
                    },
                }
            },
        },
    },

}

--[[
[9399] = {
    ['item_id'] =9399,
    ['name'] ='Trident of the Riptide Raider',
    ['icon'] ='econ/items/monkey_king/monkey_king_king_of_the_dark_reef_ti_2017_weapon/monkey_king_king_of_the_dark_reef_ti_2017_weapon',
    ['price'] = 1,
    ['HeroModel'] = nil,
    ['ArcanaAnim'] = nil,
    ['MaterialGroup'] = nil,
    ['ItemModel'] ='models/items/monkey_king/monkey_king_king_of_the_dark_reef_ti_2017_weapon/monkey_king_king_of_the_dark_reef_ti_2017_weapon.vmdl',
    ['SetItems'] = nil,
    ['hide'] = 0,
    ['OtherItemsBundle'] = nil,
    ['SlotType'] = 'weapon',
    ['RemoveDefaultItemsList'] = nil,
    ['Modifier'] = nil,
    ['sets'] = 'weapon',
    },
    [657] = {
    ['item_id'] =657,
    ['name'] ='Monkey King Shoulders',
    ['icon'] ='econ/heroes/monkey_king/monkey_king_shoulders',
    ['price'] = 1,
    ['HeroModel'] = nil,
    ['ArcanaAnim'] = nil,
    ['MaterialGroup'] = nil,
    ['ItemModel'] ='models/heroes/monkey_king/monkey_king_shoulders.vmdl',
    ['SetItems'] = nil,
    ['hide'] = 0,
    ['OtherItemsBundle'] = nil,
    ['SlotType'] = 'shoulder',
    ['RemoveDefaultItemsList'] = nil,
    ['Modifier'] = nil,
    ['sets'] = 'shoulder',
    },
    [9195] = {
    ['item_id'] =9195,
    ['name'] ='Helm of the Dragon Palace',
    ['icon'] ='econ/items/monkey_king/the_havoc_of_dragon_palacesix_ear_head/the_havoc_of_dragon_palacesix_ear_head',
    ['price'] = 1,
    ['HeroModel'] = nil,
    ['ArcanaAnim'] = nil,
    ['MaterialGroup'] = nil,
    ['ItemModel'] ='models/items/monkey_king/the_havoc_of_dragon_palacesix_ear_head/the_havoc_of_dragon_palacesix_ear_head.vmdl',
    ['SetItems'] = nil,
    ['hide'] = 0,
    ['OtherItemsBundle'] = nil,
    ['SlotType'] = 'head',
    ['RemoveDefaultItemsList'] = nil,
    ['Modifier'] = nil,
    ['sets'] = 'head',
    },
    ,
    [608] = {
    ['item_id'] =608,
    ['name'] ='Monkey King Armor',
    ['icon'] ='econ/heroes/monkey_king/monkey_king_armor',
    ['price'] = 1,
    ['HeroModel'] = nil,
    ['ArcanaAnim'] = nil,
    ['MaterialGroup'] = nil,
    ['ItemModel'] ='models/heroes/monkey_king/monkey_king_armor.vmdl',
    ['SetItems'] = nil,
    ['hide'] = 0,
    ['OtherItemsBundle'] = nil,
    ['SlotType'] = 'armor',
    ['RemoveDefaultItemsList'] = nil,
    ['Modifier'] = nil,
    ['sets'] = 'armor',
    },
    [609] = {
    ['item_id'] =609,
    ['name'] ='Monkey King Weapon',
    ['icon'] ='econ/heroes/monkey_king/monkey_king_base_weapon',
    ['price'] = 1,
    ['HeroModel'] = nil,
    ['ArcanaAnim'] = nil,
    ['MaterialGroup'] = nil,
    ['ItemModel'] ='models/heroes/monkey_king/monkey_king_base_weapon.vmdl',
    ['SetItems'] = nil,
    ['hide'] = 0,
    ['OtherItemsBundle'] = nil,
    ['SlotType'] = 'weapon',
    ['RemoveDefaultItemsList'] = nil,
    ['Modifier'] = nil,
    ['sets'] = 'weapon',
    },
    
    [22390] = {
    ['item_id'] =22390,
    ['name'] ='Baubles of the Preening King - Crown',
    ['icon'] ='econ/items/monkey_king/return_of_the_monkey_king_head/return_of_the_monkey_king_head',
    ['price'] = 1,
    ['HeroModel'] = nil,
    ['ArcanaAnim'] = nil,
    ['MaterialGroup'] = nil,
    ['ItemModel'] ='models/items/monkey_king/return_of_the_monkey_king_head/return_of_the_monkey_king_head.vmdl',
    ['SetItems'] = nil,
    ['hide'] = 0,
    ['OtherItemsBundle'] = nil,
    ['SlotType'] = 'head',
    ['RemoveDefaultItemsList'] = nil,
    ['Modifier'] = nil,
    ['sets'] = 'head',
    },
    [23702] = {
    ['item_id'] =23702,
    ['name'] ='Tangled Tropics - Weapon',
    ['icon'] ='econ/items/monkey_king/path_of_the_jungle_weapon/path_of_the_jungle_weapon',
    ['price'] = 1,
    ['HeroModel'] = nil,
    ['ArcanaAnim'] = nil,
    ['MaterialGroup'] = nil,
    ['ItemModel'] ='models/items/monkey_king/path_of_the_jungle_weapon/path_of_the_jungle_weapon.vmdl',
    ['SetItems'] = nil,
    ['hide'] = 0,
    ['OtherItemsBundle'] = nil,
    ['SlotType'] = 'weapon',
    ['RemoveDefaultItemsList'] = nil,
    ['Modifier'] = nil,
    ['sets'] = 'weapon',
    },
    [23705] = {
    ['item_id'] =23705,
    ['name'] ='Tangled Tropics - Shoulder',
    ['icon'] ='econ/items/monkey_king/path_of_the_jungle_shoulder/path_of_the_jungle_shoulder',
    ['price'] = 1,
    ['HeroModel'] = nil,
    ['ArcanaAnim'] = nil,
    ['MaterialGroup'] = nil,
    ['ItemModel'] ='models/items/monkey_king/path_of_the_jungle_shoulder/path_of_the_jungle_shoulder.vmdl',
    ['SetItems'] = nil,
    ['hide'] = 0,
    ['OtherItemsBundle'] = nil,
    ['SlotType'] = 'shoulder',
    ['RemoveDefaultItemsList'] = nil,
    ['Modifier'] = nil,
    ['sets'] = 'shoulder',
    },
    [23706] = {
    ['item_id'] =23706,
    ['name'] ='Tangled Tropics - Head',
    ['icon'] ='econ/items/monkey_king/path_of_the_jungle_head/path_of_the_jungle_head',
    ['price'] = 1,
    ['HeroModel'] = nil,
    ['ArcanaAnim'] = nil,
    ['MaterialGroup'] = nil,
    ['ItemModel'] ='models/items/monkey_king/path_of_the_jungle_head/path_of_the_jungle_head.vmdl',
    ['SetItems'] = nil,
    ['hide'] = 0,
    ['OtherItemsBundle'] = nil,
    ['SlotType'] = 'head',
    ['RemoveDefaultItemsList'] = nil,
    ['Modifier'] = nil,
    ['sets'] = 'head',
    },
    [9673] = {
    ['item_id'] =9673,
    ['name'] ='Shoulders of the Dragon Palace',
    ['icon'] ='econ/items/monkey_king/the_havoc_of_dragon_palacesix_ear_armor/the_havoc_of_dragon_palacesix_ear_shoulders',
    ['price'] = 1,
    ['HeroModel'] = nil,
    ['ArcanaAnim'] = nil,
    ['MaterialGroup'] = nil,
    ['ItemModel'] ='models/items/monkey_king/the_havoc_of_dragon_palacesix_ear_armor/the_havoc_of_dragon_palacesix_ear_shoulders.vmdl',
    ['SetItems'] = nil,
    ['hide'] = 0,
    ['OtherItemsBundle'] = nil,
    ['SlotType'] = 'shoulder',
    ['RemoveDefaultItemsList'] = nil,
    ['Modifier'] = nil,
    ['sets'] = 'shoulder',
    },
    [9400] = {
    ['item_id'] =9400,
    ['name'] ='Crown of the Riptide Raider',
    ['icon'] ='econ/items/monkey_king/monkey_king_king_of_the_dark_reef_ti_2017_head/monkey_king_king_of_the_dark_reef_ti_2017_head',
    ['price'] = 1,
    ['HeroModel'] = nil,
    ['ArcanaAnim'] = nil,
    ['MaterialGroup'] = nil,
    ['ItemModel'] ='models/items/monkey_king/monkey_king_king_of_the_dark_reef_ti_2017_head/monkey_king_king_of_the_dark_reef_ti_2017_head.vmdl',
    ['SetItems'] = nil,
    ['hide'] = 0,
    ['OtherItemsBundle'] = nil,
    ['SlotType'] = 'head',
    ['RemoveDefaultItemsList'] = nil,
    ['Modifier'] = nil,
    ['sets'] = 'head',
    },
    [9401] = {
    ['item_id'] =9401,
    ['name'] ='Armor of the Riptide Raider',
    ['icon'] ='econ/items/monkey_king/monkey_king_king_of_the_dark_reef_ti_2017_armor/monkey_king_king_of_the_dark_reef_ti_2017_armor',
    ['price'] = 1,
    ['HeroModel'] = nil,
    ['ArcanaAnim'] = nil,
    ['MaterialGroup'] = nil,
    ['ItemModel'] ='models/items/monkey_king/monkey_king_king_of_the_dark_reef_ti_2017_armor/monkey_king_king_of_the_dark_reef_ti_2017_armor.vmdl',
    ['SetItems'] = nil,
    ['hide'] = 0,
    ['OtherItemsBundle'] = nil,
    ['SlotType'] = 'armor',
    ['RemoveDefaultItemsList'] = nil,
    ['Modifier'] = nil,
    ['sets'] = 'armor',
    },
    [23802] = {
    ['item_id'] =23802,
    ['name'] ='Baubles of the Preening King - Shoulder',
    ['icon'] ='econ/items/monkey_king/return_of_the_monkey_king_shoulders/return_of_the_monkey_king_shoulders',
    ['price'] = 1,
    ['HeroModel'] = nil,
    ['ArcanaAnim'] = nil,
    ['MaterialGroup'] = nil,
    ['ItemModel'] ='models/items/monkey_king/return_of_the_monkey_king_shoulders/return_of_the_monkey_king_shoulders.vmdl',
    ['SetItems'] = nil,
    ['hide'] = 0,
    ['OtherItemsBundle'] = nil,
    ['SlotType'] = 'shoulder',
    ['RemoveDefaultItemsList'] = nil,
    ['Modifier'] = nil,
    ['sets'] = 'shoulder',
    },
    
    
    
    
    [23704] = {
    ['item_id'] =23704,
    ['name'] ='Tangled Tropics - Armor',
    ['icon'] ='econ/items/monkey_king/path_of_the_jungle_armor/path_of_the_jungle_armor',
    ['price'] = 1,
    ['HeroModel'] = nil,
    ['ArcanaAnim'] = nil,
    ['MaterialGroup'] = nil,
    ['ItemModel'] ='models/items/monkey_king/path_of_the_jungle_armor/path_of_the_jungle_armor.vmdl',
    ['SetItems'] = nil,
    ['hide'] = 0,
    ['OtherItemsBundle'] = nil,
    ['SlotType'] = 'armor',
    ['RemoveDefaultItemsList'] = nil,
    ['Modifier'] = nil,
    ['sets'] = 'armor',
    },
    [9463] = {
    ['item_id'] =9463,
    ['name'] ='Armor of the Dragon Palace',
    ['icon'] ='econ/items/monkey_king/the_havoc_of_dragon_palacesix_ear_armor/the_havoc_of_dragon_palacesix_ear_armor',
    ['price'] = 1,
    ['HeroModel'] = nil,
    ['ArcanaAnim'] = nil,
    ['MaterialGroup'] = nil,
    ['ItemModel'] ='models/items/monkey_king/the_havoc_of_dragon_palacesix_ear_armor/the_havoc_of_dragon_palacesix_ear_armor.vmdl',
    ['SetItems'] = nil,
    ['hide'] = 0,
    ['OtherItemsBundle'] = nil,
    ['SlotType'] = 'armor',
    ['RemoveDefaultItemsList'] = nil,
    ['Modifier'] = nil,
    ['sets'] = 'armor',
    },
    [9464] = {
    ['item_id'] =9464,
    ['name'] ='Staff of the Dragon Palace',
    ['icon'] ='econ/items/monkey_king/the_havoc_of_dragon_palacesix_ear_weapon/the_havoc_of_dragon_palacesix_ear_weapon',
    ['price'] = 1,
    ['HeroModel'] = nil,
    ['ArcanaAnim'] = nil,
    ['MaterialGroup'] = nil,
    ['ItemModel'] ='models/items/monkey_king/the_havoc_of_dragon_palacesix_ear_weapon/the_havoc_of_dragon_palacesix_ear_weapon.vmdl',
    ['SetItems'] = nil,
    ['hide'] = 0,
    ['OtherItemsBundle'] = nil,
    ['SlotType'] = 'weapon',
    ['RemoveDefaultItemsList'] = nil,
    ['Modifier'] = nil,
    ['sets'] = 'weapon',
    },
    [22392] = {
    ['item_id'] =22392,
    ['name'] ='Baubles of the Preening King - Weapon',
    ['icon'] ='econ/items/monkey_king/return_of_the_monkey_king_weapon/return_of_the_monkey_king_weapon',
    ['price'] = 1,
    ['HeroModel'] = nil,
    ['ArcanaAnim'] = nil,
    ['MaterialGroup'] = nil,
    ['ItemModel'] ='models/items/monkey_king/return_of_the_monkey_king_weapon/return_of_the_monkey_king_weapon.vmdl',
    ['SetItems'] = nil,
    ['hide'] = 0,
    ['OtherItemsBundle'] = nil,
    ['SlotType'] = 'weapon',
    ['RemoveDefaultItemsList'] = nil,
    ['Modifier'] = nil,
    ['sets'] = 'weapon',
    },
    [22378] = {
    ['item_id'] =22378,
    ['name'] ='Baubles of the Preening King - Armor',
    ['icon'] ='econ/items/monkey_king/return_of_the_monkey_king_armor_v2/return_of_the_monkey_king_armor_v2',
    ['price'] = 1,
    ['HeroModel'] = nil,
    ['ArcanaAnim'] = nil,
    ['MaterialGroup'] = nil,
    ['ItemModel'] ='models/items/monkey_king/return_of_the_monkey_king_armor_v2/return_of_the_monkey_king_armor_v2.vmdl',
    ['SetItems'] = nil,
    ['hide'] = 0,
    ['OtherItemsBundle'] = nil,
    ['SlotType'] = 'armor',
    ['RemoveDefaultItemsList'] = nil,
    ['Modifier'] = nil,
    ['sets'] = 'armor',
    },
    
    [9675] = {
    ['item_id'] =9675,
    ['name'] ='Shoulders of the Riptide Raider',
    ['icon'] ='econ/items/monkey_king/monkey_king_king_of_the_dark_reef_ti_2017_armor/mk_king_of_the_dark_reef_t7_shoulders',
    ['price'] = 1,
    ['HeroModel'] = nil,
    ['ArcanaAnim'] = nil,
    ['MaterialGroup'] = nil,
    ['ItemModel'] ='models/items/monkey_king/monkey_king_king_of_the_dark_reef_ti_2017_armor/mk_king_of_the_dark_reef_t7_shoulders.vmdl',
    ['SetItems'] = nil,
    ['hide'] = 0,
    ['OtherItemsBundle'] = nil,
    ['SlotType'] = 'shoulder',
    ['RemoveDefaultItemsList'] = nil,
    ['Modifier'] = nil,
    ['sets'] = 'shoulder',
    },
    
    
    
    
    [594] = {
    ['item_id'] =594,
    ['name'] ='Monkey King Head',
    ['icon'] ='econ/heroes/monkey_king/monkey_king_hair',
    ['price'] = 1,
    ['HeroModel'] = nil,
    ['ArcanaAnim'] = nil,
    ['MaterialGroup'] = nil,
    ['ItemModel'] ='models/heroes/monkey_king/monkey_king_hair.vmdl',
    ['SetItems'] = nil,
    ['hide'] = 0,
    ['OtherItemsBundle'] = nil,
    ['SlotType'] = 'head',
    ['RemoveDefaultItemsList'] = nil,
    ['Modifier'] = nil,
    ['sets'] = 'head',
    }, ]]--