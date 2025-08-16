return
{
    [13670] = 
    {
        ['item_id'] =13670,
        ['name'] ='Flockhearts Gamble',
        ['icon'] ='econ/items/ogre_magi/ogre_magi_arcana/ogre_magi_arcana_head',
        ['price'] = 10000,
        ['sale'] = 0,
        ['sale_price'] = 0,
        ['HeroModel'] = "models/items/ogre_magi/ogre_arcana/ogre_magi_arcana.vmdl",
        ['ArcanaAnim'] = nil,
        ['MaterialGroupItem'] = "0",
        ['MaterialGroup'] = "0",
        ['ItemModel'] ='models/items/ogre_magi/ogre_arcana/ogre_magi_arcana_head.vmdl',
        ['SetItems'] = nil,
        ['hide'] = 0,
        ['OtherItemsBundle'] = {
            {13670, "#f0ac0e"}, {136701, "#4298cf"}
        },
        ['SlotType'] = 'head',
        ['RemoveDefaultItemsList'] = nil,
        ['Modifier'] = "modifier_ogre_magi_arcana_custom",
        ['sets'] = 'rare',
        ['ParticlesHero'] = 
        {
            {
                ["ParticleName"] = "particles/econ/items/ogre_magi/ogre_magi_arcana/ogre_magi_arcana_ambient.vpcf",
                ["DefaultPattch"] = PATTACH_ABSORIGIN_FOLLOW,
                ['IsHero'] = 1,
                ["ControllPoints"] = 
                {
                    [0] = {"SetParticleControl", "default"},
                    [1] = 
                    {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_eye_l_fx"
                    },
                    [2] = 
                    {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_eye_r_fx"
                    },
                    [3] = 
                    {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_horn_left_fx"
                    },
                    [5] = 
                    {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_root_fx"
                    },
                    [6] = 
                    {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_wrist_r_fx"
                    },
                    [7] = 
                    {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_head_r_fx"
                    },
                    [8] = 
                    {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_wrist_l_fx"
                    },
                    [9] = 
                    {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_tail_fx"
                    },
                    [10] = 
                    {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_frill_l_fx"
                    },
                    [11] = 
                    {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_frill_r_fx"
                    },
                }
            },
        },
        ["ParticlesSkills"] =
        {
            "particles/econ/items/ogre_magi/ogre_magi_arcana/ogre_magi_arcana_multicast_counter.vpcf",
            "particles/econ/items/ogre_magi/ogre_magi_arcana/ogre_magi_arcana_unrefined_fireblast.vpcf",
            "particles/econ/items/ogre_magi/ogre_magi_arcana/ogre_magi_arcana_fireblast_cast.vpcf",
            "particles/econ/items/ogre_magi/ogre_magi_arcana/ogre_magi_arcana_unrefined_fireblast.vpcf",
            "particles/econ/items/ogre_magi/ogre_magi_arcana/ogre_magi_arcana_ignite_debuff_explosion.vpcf",
            "particles/econ/items/ogre_magi/ogre_magi_arcana/ogre_magi_arcana_ignite_debuff.vpcf",
            "particles/econ/items/ogre_magi/ogre_magi_arcana/ogre_magi_arcana_ignite.vpcf",
        }
    },
    [136701] = 
    {
        ['item_id'] =136701,
        ['name'] ='Flockhearts Gamble',
        ['icon'] ='econ/items/ogre_magi/ogre_magi_arcana/ogre_magi_arcana_head_style1',
        ['price'] = 1,
        ['HeroModel'] = "models/items/ogre_magi/ogre_arcana/ogre_magi_arcana.vmdl",
        ['ArcanaAnim'] = nil,
        ['MaterialGroupItem'] = "1",
        ['MaterialGroup'] = "1",
        ['ItemModel'] ='models/items/ogre_magi/ogre_arcana/ogre_magi_arcana_head.vmdl',
        ['SetItems'] = nil,
        ['hide'] = 1,
        ['OtherItemsBundle'] = {
            {13670, "#f0ac0e"}, {136701, "#4298cf"}
        },
        ['SlotType'] = 'head',
        ['RemoveDefaultItemsList'] = nil,
        ['Modifier'] = "modifier_ogre_magi_arcana_custom_2",
        ['sets'] = 'rare',
        ['ParticlesHero'] = 
        {
            {
                ["ParticleName"] = "particles/econ/items/ogre_magi/ogre_magi_arcana/ogre_magi_arcana_secondstyle_ambient.vpcf",
                ["DefaultPattch"] = PATTACH_ABSORIGIN_FOLLOW,
                ['IsHero'] = 1,
                ["ControllPoints"] = 
                {
                    [0] = {"SetParticleControl", "default"},
                    [1] = 
                    {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_eye_l_fx"
                    },
                    [2] = 
                    {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_eye_r_fx"
                    },
                    [3] = 
                    {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_horn_left_fx"
                    },
                    [5] = 
                    {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_root_fx"
                    },
                    [6] = 
                    {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_wrist_r_fx"
                    },
                    [7] = 
                    {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_head_r_fx"
                    },
                    [8] = 
                    {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_wrist_l_fx"
                    },
                    [9] = 
                    {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_tail_fx"
                    },
                    [10] = 
                    {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_frill_l_fx"
                    },
                    [11] = 
                    {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_frill_r_fx"
                    },
                }
            },
        },
        ["ParticlesSkills"] =
        {
            "particles/econ/items/ogre_magi/ogre_magi_arcana/ogre_magi_arcana_multicast_counter.vpcf",
            "particles/econ/items/ogre_magi/ogre_magi_arcana/ogre_magi_arcana_unrefined_fireblast.vpcf",
            "particles/econ/items/ogre_magi/ogre_magi_arcana/ogre_magi_arcana_fireblast_cast.vpcf",
            "particles/econ/items/ogre_magi/ogre_magi_arcana/ogre_magi_arcana_unrefined_fireblast.vpcf",
            "particles/econ/items/ogre_magi/ogre_magi_arcana/ogre_magi_arcana_ignite_debuff_explosion.vpcf",
            "particles/econ/items/ogre_magi/ogre_magi_arcana/ogre_magi_arcana_ignite_debuff.vpcf",
            "particles/econ/items/ogre_magi/ogre_magi_arcana/ogre_magi_arcana_ignite.vpcf",
        }
    },
    [12318] = 
    {
        ['item_id'] =12318,
        ['name'] ='Gimlek Decanter',
        ['icon'] ='econ/items/ogre_magi/ogre_ti8_immortal_weapon/ogre_ti8_immortal_weapon',
        ['price'] = 1500,
        ['HeroModel'] = nil,
        ['ArcanaAnim'] = nil,
        ['MaterialGroup'] = nil,
        ['ItemModel'] ='models/items/ogre_magi/ogre_ti8_immortal_weapon/ogre_ti8_immortal_weapon.vmdl',
        ['SetItems'] = nil,
        ['hide'] = 0,
        ['OtherItemsBundle'] = nil,
        ['SlotType'] = 'weapon',
        ['RemoveDefaultItemsList'] = nil,
        ['Modifier'] = "modifier_ogre_magi_immortal_weapon_custom",
        ['sets'] = 'rare',
        ['ParticlesItems'] = 
        {
            {
                ["ParticleName"] = "particles/econ/items/ogre_magi/ogre_ti8_immortal_weapon/ogre_ti8_immortal_weapon_ambient.vpcf",
                ["DefaultPattch"] = PATTACH_ABSORIGIN_FOLLOW,
                ["ControllPoints"] = 
                {
                    [0] = 
                    {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_bottle"
                    },
                }
            },
        },
        ["ParticlesSkills"] =
        {
            "particles/econ/items/ogre_magi/ogre_ti8_immortal_weapon/ogre_ti8_immortal_bloodlust_buff.vpcf"
        }
    },
    [7910] = 
    {
        ['item_id'] =7910,
        ['name'] ='Auspice of the Whyrlegyge',
        ['icon'] ='econ/items/ogre_magi/auspice_of_the_whyrlegyge/mesh/auspice_of_the_whyrlegyge_model',
        ['price'] = 1500,
        ['HeroModel'] = nil,
        ['ArcanaAnim'] = nil,
        ['MaterialGroup'] = nil,
        ['ItemModel'] ='models/items/ogre_magi/auspice_of_the_whyrlegyge/mesh/auspice_of_the_whyrlegyge_model.vmdl',
        ['SetItems'] = nil,
        ['hide'] = 0,
        ['OtherItemsBundle'] = {
            {7910, "#f0c70e"}, {79101, "#f03f0e"}
        },
        ['SlotType'] = 'back',
        ['RemoveDefaultItemsList'] = nil,
        ['Modifier'] = "modifier_ogre_magi_immortal_back_custom",
        ['sets'] = 'rare',
        ['ParticlesItems'] = 
        {
            {
                ["ParticleName"] = "particles/econ/items/ogre_magi/ogre_magi_jackpot/ogre_magi_jackpot_ambient.vpcf",
                ["DefaultPattch"] = PATTACH_ABSORIGIN_FOLLOW,
                ["ControllPoints"] = 
                {
                    [0] = 
                    {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_wheel"
                    },
                    [1] = 
                    {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_back"
                    },
                }
            },
        },
        ["ParticlesSkills"] =
        {
            "particles/econ/items/ogre_magi/ogre_magi_jackpot/ogre_magi_jackpot_multicast.vpcf",
            "particles/econ/items/ogre_magi/ogre_magi_arcana/ogre_magi_arcana_multicast_style.vpcf"
        }
    },
    [79101] = 
    {
        ['item_id'] =79101,
        ['name'] ='Auspice of the Whyrlegyge',
        ['icon'] ='econ/items/ogre_magi/auspice_of_the_whyrlegyge/mesh/auspice_of_the_whyrlegyge_model_style1',
        ['price'] = 1,
        ['HeroModel'] = nil,
        ['ArcanaAnim'] = nil,
        ['MaterialGroup'] = nil,
        ['ItemModel'] ='models/items/ogre_magi/auspice_of_the_whyrlegyge/ogre_arcana_immortal.vmdl',
        ['SetItems'] = nil,
        ['hide'] = 1,
        ['OtherItemsBundle'] = {
            {7910, "#f0c70e"}, {79101, "#f03f0e"}
        },
        ['SlotType'] = 'back',
        ['RemoveDefaultItemsList'] = nil,
        ['Modifier'] = "modifier_ogre_magi_immortal_back_custom_arcana",
        ['sets'] = 'rare',
        ['ParticlesItems'] = 
        {
            {
                ["ParticleName"] = "particles/econ/items/ogre_magi/ogre_magi_arcana/ogre_magi_arcana_back.vpcf",
                ["DefaultPattch"] = PATTACH_ABSORIGIN_FOLLOW,
                ["ControllPoints"] = 
                {
                    [1] = 
                    {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_back"
                    },
                    [2] = 
                    {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_wheel"
                    },
                }
            },
        },
        ["ParticlesSkills"] =
        {
            "particles/econ/items/ogre_magi/ogre_magi_jackpot/ogre_magi_jackpot_multicast.vpcf",
            "particles/econ/items/ogre_magi/ogre_magi_arcana/ogre_magi_arcana_multicast_style.vpcf"
        }
    },


    [9226] = 
    {
        ['item_id'] =9226,
        ['name'] ='Back Buoy of the Shoreline Sapper',
        ['icon'] ='econ/items/ogre_magi/ogre_magi_set_back/ogre_magi_set_back',
        ['price'] = 200,
        ['HeroModel'] = nil,
        ['ArcanaAnim'] = nil,
        ['MaterialGroupItem'] = "0",
        ['ItemModel'] ='models/items/ogre_magi/ogre_magi_set_back/ogre_magi_set_back.vmdl',
        ['SetItems'] = nil,
        ['hide'] = 0,
        ['OtherItemsBundle'] = {{9226, "#f0c70e"}, {92261, "#4298cf"}},
        ['SlotType'] = 'back',
        ['RemoveDefaultItemsList'] = nil,
        ['Modifier'] = nil,
        ['sets'] = 'ogre_shoreline',
        ['ParticlesItems'] = 
        {
            {
                ["ParticleName"] = "particles/econ/items/ogre_magi/ogre_ti7_set/ogre_ti7_set_back_ambient.vpcf",
                ["DefaultPattch"] = PATTACH_ABSORIGIN_FOLLOW,
                ["ControllPoints"] = 
                {
                    [0] = {"SetParticleControl", "default"},
                    [1] = 
                    {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_flower_r"
                    },
                    [2] = 
                    {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_flower_l"
                    },
                }
            },
        },
    },
    [92261] = 
    {
        ['item_id'] =92261,
        ['name'] ='Back Buoy of the Shoreline Sapper',
        ['icon'] ='econ/items/ogre_magi/ogre_magi_set_back/ogre_magi_set_back_style1',
        ['price'] = 200,
        ['HeroModel'] = nil,
        ['ArcanaAnim'] = nil,
        ['MaterialGroupItem'] = "1",
        ['ItemModel'] ='models/items/ogre_magi/ogre_magi_set_back/ogre_magi_set_back.vmdl',
        ['SetItems'] = nil,
        ['hide'] = 1,
        ['OtherItemsBundle'] = {{9226, "#f0c70e"}, {92261, "#4298cf"}},
        ['SlotType'] = 'back',
        ['RemoveDefaultItemsList'] = nil,
        ['Modifier'] = nil,
        ['sets'] = 'ogre_shoreline',
        ['ParticlesItems'] = 
        {
            {
                ["ParticleName"] = "particles/econ/items/ogre_magi/ogre_ti7_set/ogre_ti7_set_back_ambient.vpcf",
                ["DefaultPattch"] = PATTACH_ABSORIGIN_FOLLOW,
                ["ControllPoints"] = 
                {
                    [0] = {"SetParticleControl", "default"},
                    [1] = 
                    {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_flower_r"
                    },
                    [2] = 
                    {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_flower_l"
                    },
                }
            },
        },
    },
    [9229] = 
    {
        ['item_id'] =9229,
        ['name'] ='Headgear of the Shoreline Sapper',
        ['icon'] ='econ/items/ogre_magi/ogre_magi_set_head/ogre_magi_set_head',
        ['price'] = 200,
        ['HeroModel'] = nil,
        ['ArcanaAnim'] = nil,
        ['MaterialGroupItem'] = "0",
        ['MaterialGroup'] = "0",
        ['ItemModel'] ='models/items/ogre_magi/ogre_magi_set_head/ogre_magi_set_head.vmdl',
        ['SetItems'] = nil,
        ['hide'] = 0,
        ['OtherItemsBundle'] = {{9229, "#f0c70e"}, {92291, "#4298cf"}},
        ['SlotType'] = 'head',
        ['RemoveDefaultItemsList'] = nil,
        ['Modifier'] = nil,
        ['sets'] = 'ogre_shoreline',
        ['ParticlesItems'] = 
        {
            {
                ["ParticleName"] = "particles/econ/items/ogre_magi/ogre_ti7_set/ogre_ti7_set_head_ambient.vpcf",
                ["DefaultPattch"] = PATTACH_ABSORIGIN_FOLLOW,
                ["ControllPoints"] = 
                {
                    [0] = 
                    {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_snorkel"
                    },
                }
            },
        },
    },
    [92291] = 
    {
        ['item_id'] =92291,
        ['name'] ='Headgear of the Shoreline Sapper',
        ['icon'] ='econ/items/ogre_magi/ogre_magi_set_head/ogre_magi_set_head_style1',
        ['price'] = 200,
        ['HeroModel'] = nil,
        ['ArcanaAnim'] = nil,
        ['MaterialGroupItem'] = "1",
        ['ItemModel'] ='models/items/ogre_magi/ogre_magi_set_head/ogre_magi_set_head.vmdl',
        ['SetItems'] = nil,
        ['hide'] = 1,
        ['MaterialGroup'] = "0",
        ['OtherItemsBundle'] = {{9229, "#f0c70e"}, {92291, "#4298cf"}},
        ['SlotType'] = 'head',
        ['RemoveDefaultItemsList'] = nil,
        ['Modifier'] = nil,
        ['sets'] = 'ogre_shoreline',
        ['ParticlesItems'] = 
        {
            {
                ["ParticleName"] = "particles/econ/items/ogre_magi/ogre_ti7_set/ogre_ti7_set_style_head_ambient.vpcf",
                ["DefaultPattch"] = PATTACH_ABSORIGIN_FOLLOW,
                ["ControllPoints"] = 
                {
                    [0] = 
                    {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_snorkel"
                    },
                }
            },
        },
    },
    [9227] = 
    {
        ['item_id'] =9227,
        ['name'] ='Floathide Belt of the Shoreline Sapper',
        ['icon'] ='econ/items/ogre_magi/ogre_magi_set_belt/ogre_magi_set_belt',
        ['price'] = 200,
        ['HeroModel'] = nil,
        ['ArcanaAnim'] = nil,
        ['MaterialGroupItem'] = "0",
        ['ItemModel'] ='models/items/ogre_magi/ogre_magi_set_belt/ogre_magi_set_belt.vmdl',
        ['SetItems'] = nil,
        ['hide'] = 0,
        ['OtherItemsBundle'] = {{9227, "#f0c70e"}, {92271, "#4298cf"}},
        ['SlotType'] = 'belt',
        ['RemoveDefaultItemsList'] = nil,
        ['Modifier'] = nil,
        ['sets'] = 'ogre_shoreline',
    },
    [92271] = 
    {
        ['item_id'] =92271,
        ['name'] ='Floathide Belt of the Shoreline Sapper',
        ['icon'] ='econ/items/ogre_magi/ogre_magi_set_belt/ogre_magi_set_belt_style1',
        ['price'] = 200,
        ['HeroModel'] = nil,
        ['ArcanaAnim'] = nil,
        ['MaterialGroupItem'] = "1",
        ['ItemModel'] ='models/items/ogre_magi/ogre_magi_set_belt/ogre_magi_set_belt.vmdl',
        ['SetItems'] = nil,
        ['hide'] = 1,
        ['OtherItemsBundle'] = {{9227, "#f0c70e"}, {92271, "#4298cf"}},
        ['SlotType'] = 'belt',
        ['RemoveDefaultItemsList'] = nil,
        ['Modifier'] = nil,
        ['sets'] = 'ogre_shoreline',
    },
    [9224] = 
    {
        ['item_id'] =9224,
        ['name'] ='Shovel of the Shoreline Sapper',
        ['icon'] ='econ/items/ogre_magi/ogre_magi_set_weapon/ogre_magi_set_weapon',
        ['price'] = 200,
        ['HeroModel'] = nil,
        ['ArcanaAnim'] = nil,
        ['MaterialGroupItem'] = "0",
        ['ItemModel'] ='models/items/ogre_magi/ogre_magi_set_weapon/ogre_magi_set_weapon.vmdl',
        ['SetItems'] = nil,
        ['hide'] = 0,
        ['OtherItemsBundle'] = {{9224, "#f0c70e"}, {92241, "#4298cf"}},
        ['SlotType'] = 'weapon',
        ['RemoveDefaultItemsList'] = nil,
        ['Modifier'] = nil,
        ['sets'] = 'ogre_shoreline',
    },
    [92241] = 
    {
        ['item_id'] =92241,
        ['name'] ='Shovel of the Shoreline Sapper',
        ['icon'] ='econ/items/ogre_magi/ogre_magi_set_weapon/ogre_magi_set_weapon_style1',
        ['price'] = 200,
        ['HeroModel'] = nil,
        ['ArcanaAnim'] = nil,
        ['MaterialGroupItem'] = "1",
        ['ItemModel'] ='models/items/ogre_magi/ogre_magi_set_weapon/ogre_magi_set_weapon.vmdl',
        ['SetItems'] = nil,
        ['hide'] = 1,
        ['OtherItemsBundle'] = {{9224, "#f0c70e"}, {92241, "#4298cf"}},
        ['SlotType'] = 'weapon',
        ['RemoveDefaultItemsList'] = nil,
        ['Modifier'] = nil,
        ['sets'] = 'ogre_shoreline',
    },
    [9225] = 
    {
        ['item_id'] =9225,
        ['name'] ='Floathide Bands of the Shoreline Sapper',
        ['icon'] ='econ/items/ogre_magi/ogre_magi_set_arms/ogre_magi_set_arms',
        ['price'] = 200,
        ['HeroModel'] = nil,
        ['ArcanaAnim'] = nil,
        ['MaterialGroupItem'] = "0",
        ['ItemModel'] ='models/items/ogre_magi/ogre_magi_set_arms/ogre_magi_set_arms.vmdl',
        ['SetItems'] = nil,
        ['hide'] = 0,
        ['OtherItemsBundle'] = {{9225, "#f0c70e"}, {92251, "#4298cf"}},
        ['SlotType'] = 'arms',
        ['RemoveDefaultItemsList'] = nil,
        ['Modifier'] = nil,
        ['sets'] = 'ogre_shoreline',
    },
    [92251] = 
    {
        ['item_id'] =92251,
        ['name'] ='Floathide Bands of the Shoreline Sapper',
        ['icon'] ='econ/items/ogre_magi/ogre_magi_set_arms/ogre_magi_set_arms_style1',
        ['price'] = 200,
        ['HeroModel'] = nil,
        ['ArcanaAnim'] = nil,
        ['MaterialGroupItem'] = "1",
        ['ItemModel'] ='models/items/ogre_magi/ogre_magi_set_arms/ogre_magi_set_arms.vmdl',
        ['SetItems'] = nil,
        ['hide'] = 1,
        ['OtherItemsBundle'] = {{9225, "#f0c70e"}, {92251, "#4298cf"}},
        ['SlotType'] = 'arms',
        ['RemoveDefaultItemsList'] = nil,
        ['Modifier'] = nil,
        ['sets'] = 'ogre_shoreline',
    },
    [18098] = 
    {
        ['item_id'] =18098,
        ['name'] ='Pyrexae Polymorph Perfected - Head',
        ['icon'] ='econ/items/ogre_magi/ogre_magi_enter_the_dragon_head/ogre_magi_enter_the_dragon_head',
        ['price'] = 800,
        ['HeroModel'] = nil,
        ['ArcanaAnim'] = nil,
        ['MaterialGroup'] = "0",
        ['ItemModel'] ='models/items/ogre_magi/ogre_magi_enter_the_dragon_head/ogre_magi_enter_the_dragon_head.vmdl',
        ['SetItems'] = nil,
        ['hide'] = 0,
        ['OtherItemsBundle'] = nil,
        ['SlotType'] = 'head',
        ['RemoveDefaultItemsList'] = nil,
        ['Modifier'] = nil,
        ['sets'] = 'ogre_pyrexae',
    },
    [18099] = 
    {
        ['item_id'] =18099,
        ['name'] ='Pyrexae Polymorph Perfected - Belt',
        ['icon'] ='econ/items/ogre_magi/ogre_magi_enter_the_dragon_belt/ogre_magi_enter_the_dragon_belt',
        ['price'] = 800,
        ['HeroModel'] = nil,
        ['ArcanaAnim'] = nil,
        ['MaterialGroup'] = nil,
        ['ItemModel'] ='models/items/ogre_magi/ogre_magi_enter_the_dragon_belt/ogre_magi_enter_the_dragon_belt.vmdl',
        ['SetItems'] = nil,
        ['hide'] = 0,
        ['OtherItemsBundle'] = nil,
        ['SlotType'] = 'belt',
        ['RemoveDefaultItemsList'] = nil,
        ['Modifier'] = nil,
        ['sets'] = 'ogre_pyrexae',
        ['ParticlesItems'] = 
        {
            {
                ["ParticleName"] = "particles/econ/items/ogre_magi/ogre_2022_cc/ogre_2022_cc_belt.vpcf",
                ["DefaultPattch"] = PATTACH_ABSORIGIN_FOLLOW,
                ["ControllPoints"] = 
                {
                    [0] = {"SetParticleControl", "default"},
                    [1] = 
                    {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_tail_fx_left"
                    },
                    [2] = 
                    {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_tail_fx_right"
                    },
                }
            },
        },
    },
    [18100] = 
    {
        ['item_id'] =18100,
        ['name'] ='Pyrexae Polymorph Perfected - Back',
        ['icon'] ='econ/items/ogre_magi/ogre_magi_enter_the_dragon_back/ogre_magi_enter_the_dragon_back',
        ['price'] = 800,
        ['HeroModel'] = nil,
        ['ArcanaAnim'] = nil,
        ['MaterialGroup'] = nil,
        ['ItemModel'] ='models/items/ogre_magi/ogre_magi_enter_the_dragon_back/ogre_magi_enter_the_dragon_back.vmdl',
        ['SetItems'] = nil,
        ['hide'] = 0,
        ['OtherItemsBundle'] = nil,
        ['SlotType'] = 'back',
        ['RemoveDefaultItemsList'] = nil,
        ['Modifier'] = nil,
        ['sets'] = 'ogre_pyrexae',
    },
    [18101] = 
    {
        ['item_id'] =18101,
        ['name'] ='Pyrexae Polymorph Perfected - Arms',
        ['icon'] ='econ/items/ogre_magi/ogre_magi_enter_the_dragon_arms/ogre_magi_enter_the_dragon_arms',
        ['price'] = 600,
        ['HeroModel'] = nil,
        ['ArcanaAnim'] = nil,
        ['MaterialGroup'] = nil,
        ['ItemModel'] ='models/items/ogre_magi/ogre_magi_enter_the_dragon_arms/ogre_magi_enter_the_dragon_arms.vmdl',
        ['SetItems'] = nil,
        ['hide'] = 0,
        ['OtherItemsBundle'] = nil,
        ['SlotType'] = 'arms',
        ['RemoveDefaultItemsList'] = nil,
        ['Modifier'] = nil,
        ['sets'] = 'ogre_pyrexae',
        ['ParticlesItems'] = 
        {
            {
                ["ParticleName"] = "particles/econ/items/ogre_magi/ogre_2022_cc/ogre_2022_cc_arm_stuffing.vpcf",
                ["DefaultPattch"] = PATTACH_ABSORIGIN_FOLLOW,
                ["ControllPoints"] = 
                {
                    [0] = {"SetParticleControl", "default"},
                }
            },
        },
    },
    [18097] = 
    {
        ['item_id'] =18097,
        ['name'] ='Pyrexae Polymorph Perfected - Weapon',
        ['icon'] ='econ/items/ogre_magi/ogre_magi_enter_the_dragon_weapon/ogre_magi_enter_the_dragon_weapon',
        ['price'] = 800,
        ['HeroModel'] = nil,
        ['ArcanaAnim'] = nil,
        ['MaterialGroup'] = nil,
        ['ItemModel'] ='models/items/ogre_magi/ogre_magi_enter_the_dragon_weapon/ogre_magi_enter_the_dragon_weapon.vmdl',
        ['SetItems'] = nil,
        ['hide'] = 0,
        ['OtherItemsBundle'] = nil,
        ['SlotType'] = 'weapon',
        ['RemoveDefaultItemsList'] = nil,
        ['Modifier'] = nil,
        ['sets'] = 'ogre_pyrexae',
        ['ParticlesItems'] = 
        {
            {
                ["ParticleName"] = "particles/econ/items/ogre_magi/ogre_2022_cc/ogre_2022_cc_weapon.vpcf",
                ["DefaultPattch"] = PATTACH_ABSORIGIN_FOLLOW,
                ["ControllPoints"] = 
                {
                    [0] = {"SetParticleControl", "default"},
                    [1] = 
                    {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_weapon_fx"
                    },
                }
            },
        },
    },
    [19370] = 
    {
        ['item_id'] =19370,
        ['name'] ='Freeboot Fortunes - Arms',
        ['icon'] ='econ/items/ogre_magi/adventurers_of_fortune_arms/adventurers_of_fortune_arms',
        ['price'] = 400,
        ['HeroModel'] = nil,
        ['ArcanaAnim'] = nil,
        ['MaterialGroup'] = nil,
        ['ItemModel'] ='models/items/ogre_magi/adventurers_of_fortune_arms/adventurers_of_fortune_arms.vmdl',
        ['SetItems'] = nil,
        ['hide'] = 0,
        ['OtherItemsBundle'] = nil,
        ['SlotType'] = 'arms',
        ['RemoveDefaultItemsList'] = nil,
        ['Modifier'] = nil,
        ['sets'] = 'ogre_freebot',
    },
    [19372] = 
    {
        ['item_id'] =19372,
        ['name'] ='Freeboot Fortunes - Belt',
        ['icon'] ='econ/items/ogre_magi/adventurers_of_fortune_belt/adventurers_of_fortune_belt',
        ['price'] = 600,
        ['HeroModel'] = nil,
        ['ArcanaAnim'] = nil,
        ['MaterialGroup'] = nil,
        ['ItemModel'] ='models/items/ogre_magi/adventurers_of_fortune_belt/adventurers_of_fortune_belt.vmdl',
        ['SetItems'] = nil,
        ['hide'] = 0,
        ['OtherItemsBundle'] = nil,
        ['SlotType'] = 'belt',
        ['RemoveDefaultItemsList'] = nil,
        ['Modifier'] = nil,
        ['sets'] = 'ogre_freebot',
        ['ParticlesItems'] = 
        {
            {
                ["ParticleName"] = "particles/econ/items/ogre_magi/ogre_2022_cc_fortune/ogre_2022_cc_fortune_belt_ambient.vpcf",
                ["DefaultPattch"] = PATTACH_ABSORIGIN_FOLLOW,
                ["ControllPoints"] = 
                {
                    [0] = {"SetParticleControl", "default"},
                }
            },
        },
    },
    [19373] = 
    {
        ['item_id'] =19373,
        ['name'] ='Freeboot Fortunes - Head',
        ['icon'] ='econ/items/ogre_magi/adventurers_of_fortune_head/adventurers_of_fortune_head',
        ['price'] = 800,
        ['HeroModel'] = nil,
        ['ArcanaAnim'] = nil,
        ['MaterialGroup'] = "0",
        ['ItemModel'] ='models/items/ogre_magi/adventurers_of_fortune_head/adventurers_of_fortune_head.vmdl',
        ['SetItems'] = nil,
        ['hide'] = 0,
        ['OtherItemsBundle'] = nil,
        ['SlotType'] = 'head',
        ['RemoveDefaultItemsList'] = nil,
        ['Modifier'] = nil,
        ['sets'] = 'ogre_freebot',
    },
    [19374] = 
    {
        ['item_id'] =19374,
        ['name'] ='Freeboot Fortunes - Weapon',
        ['icon'] ='econ/items/ogre_magi/adventurers_of_fortune_weapon/adventurers_of_fortune_weapon',
        ['price'] = 600,
        ['HeroModel'] = nil,
        ['ArcanaAnim'] = nil,
        ['MaterialGroup'] = "0",
        ['ItemModel'] ='models/items/ogre_magi/adventurers_of_fortune_weapon/adventurers_of_fortune_weapon.vmdl',
        ['SetItems'] = nil,
        ['hide'] = 0,
        ['OtherItemsBundle'] = nil,
        ['SlotType'] = 'weapon',
        ['RemoveDefaultItemsList'] = nil,
        ['Modifier'] = nil,
        ['sets'] = 'ogre_freebot',
        ['ParticlesItems'] = 
        {
            {
                ["ParticleName"] = "particles/econ/items/ogre_magi/ogre_2022_cc_fortune/ogre_2022_cc_fortune_weapon_ambient.vpcf",
                ["DefaultPattch"] = PATTACH_ABSORIGIN_FOLLOW,
                ["ControllPoints"] = 
                {
                    [0] = {"SetParticleControl", "default"},
                }
            },
        },
    },
    [19371] = 
    {
        ['item_id'] =19371,
        ['name'] ='Freeboot Fortunes - Back',
        ['icon'] ='econ/items/ogre_magi/adventurers_of_fortune_back/adventurers_of_fortune_back',
        ['price'] = 800,
        ['HeroModel'] = nil,
        ['ArcanaAnim'] = nil,
        ['MaterialGroup'] = nil,
        ['ItemModel'] ='models/items/ogre_magi/adventurers_of_fortune_back/adventurers_of_fortune_back.vmdl',
        ['SetItems'] = nil,
        ['hide'] = 0,
        ['OtherItemsBundle'] = nil,
        ['SlotType'] = 'back',
        ['RemoveDefaultItemsList'] = nil,
        ['Modifier'] = nil,
        ['sets'] = 'ogre_freebot',
        ['ParticlesItems'] = 
        {
            {
                ["ParticleName"] = "particles/econ/items/ogre_magi/ogre_2022_cc_fortune/ogre_2022_cc_fortune_back_ambient.vpcf",
                ["DefaultPattch"] = PATTACH_ABSORIGIN_FOLLOW,
                ["ControllPoints"] = 
                {
                    [0] = {"SetParticleControl", "default"},
                    [1] = 
                    {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_loot_fx"
                    },
                }
            },
        },
    },
}

--[[

[7611] = {
['item_id'] =7611,
['name'] ='Club of Pagus',
['icon'] ='econ/items/ogre_magi/fortunes_veil_weapon/fortunes_veil_weapon',
['price'] = 1,
['HeroModel'] = nil,
['ArcanaAnim'] = nil,
['MaterialGroup'] = nil,
['ItemModel'] ='models/items/ogre_magi/fortunes_veil_weapon/fortunes_veil_weapon.vmdl',
['SetItems'] = nil,
['hide'] = 0,
['OtherItemsBundle'] = nil,
['SlotType'] = 'weapon',
['RemoveDefaultItemsList'] = nil,
['Modifier'] = nil,
['sets'] = 'weapon',
},
[7612] = {
['item_id'] =7612,
['name'] ='Cloak of Pagus',
['icon'] ='econ/items/ogre_magi/fortunes_veil_back/fortunes_veil_back',
['price'] = 1,
['HeroModel'] = nil,
['ArcanaAnim'] = nil,
['MaterialGroup'] = nil,
['ItemModel'] ='models/items/ogre_magi/fortunes_veil_back/fortunes_veil_back.vmdl',
['SetItems'] = nil,
['hide'] = 0,
['OtherItemsBundle'] = nil,
['SlotType'] = 'back',
['RemoveDefaultItemsList'] = nil,
['Modifier'] = nil,
['sets'] = 'back',
},
[7613] = {
['item_id'] =7613,
['name'] ='Hood of Pagus',
['icon'] ='econ/items/ogre_magi/fortunes_veil_head/fortunes_veil_head',
['price'] = 1,
['HeroModel'] = nil,
['ArcanaAnim'] = nil,
['MaterialGroup'] = nil,
['ItemModel'] ='models/items/ogre_magi/fortunes_veil_head/fortunes_veil_head.vmdl',
['SetItems'] = nil,
['hide'] = 0,
['OtherItemsBundle'] = nil,
['SlotType'] = 'head',
['RemoveDefaultItemsList'] = nil,
['Modifier'] = nil,
['sets'] = 'head',
},
[7614] = {
['item_id'] =7614,
['name'] ='Belt of Pagus',
['icon'] ='econ/items/ogre_magi/fortunes_veil_belt/fortunes_veil_belt',
['price'] = 1,
['HeroModel'] = nil,
['ArcanaAnim'] = nil,
['MaterialGroup'] = nil,
['ItemModel'] ='models/items/ogre_magi/fortunes_veil_belt/fortunes_veil_belt.vmdl',
['SetItems'] = nil,
['hide'] = 0,
['OtherItemsBundle'] = nil,
['SlotType'] = 'belt',
['RemoveDefaultItemsList'] = nil,
['Modifier'] = nil,
['sets'] = 'belt',
},
[7633] = {
['item_id'] =7633,
['name'] ='Bracers of Pagus',
['icon'] ='econ/items/ogre_magi/fortunes_veil_arms/fortunes_veil_arms',
['price'] = 1,
['HeroModel'] = nil,
['ArcanaAnim'] = nil,
['MaterialGroup'] = nil,
['ItemModel'] ='models/items/ogre_magi/fortunes_veil_arms/fortunes_veil_arms.vmdl',
['SetItems'] = nil,
['hide'] = 0,
['OtherItemsBundle'] = nil,
['SlotType'] = 'arms',
['RemoveDefaultItemsList'] = nil,
['Modifier'] = nil,
['sets'] = 'arms',
},



[5607] = {
['item_id'] =5607,
['name'] ='Lighted Scepter of Serendipity',
['icon'] ='econ/items/ogre_magi/batter_snag/batter_snag',
['price'] = 1,
['HeroModel'] = nil,
['ArcanaAnim'] = nil,
['MaterialGroup'] = nil,
['ItemModel'] ='models/items/ogre_magi/batter_snag/batter_snag.vmdl',
['SetItems'] = nil,
['hide'] = 0,
['OtherItemsBundle'] = nil,
['SlotType'] = 'weapon',
['RemoveDefaultItemsList'] = nil,
['Modifier'] = nil,
['sets'] = 'weapon',
},
[12798] = {
['item_id'] =12798,
['name'] ='Bracer of the Grey Wastes',
['icon'] ='econ/items/ogre_magi/frostivus2018_ogre_prehistoric_hunter_arms/frostivus2018_ogre_prehistoric_hunter_arms',
['price'] = 1,
['HeroModel'] = nil,
['ArcanaAnim'] = nil,
['MaterialGroup'] = nil,
['ItemModel'] ='models/items/ogre_magi/frostivus2018_ogre_prehistoric_hunter_arms/frostivus2018_ogre_prehistoric_hunter_arms.vmdl',
['SetItems'] = nil,
['hide'] = 0,
['OtherItemsBundle'] = nil,
['SlotType'] = 'arms',
['RemoveDefaultItemsList'] = nil,
['Modifier'] = nil,
['sets'] = 'arms',
},
[12801] = {
['item_id'] =12801,
['name'] ='Heads of the Grey Wastes',
['icon'] ='econ/items/ogre_magi/frostivus2018_ogre_prehistoric_hunter_head/frostivus2018_ogre_prehistoric_hunter_head',
['price'] = 1,
['HeroModel'] = nil,
['ArcanaAnim'] = nil,
['MaterialGroup'] = nil,
['ItemModel'] ='models/items/ogre_magi/frostivus2018_ogre_prehistoric_hunter_head/frostivus2018_ogre_prehistoric_hunter_head.vmdl',
['SetItems'] = nil,
['hide'] = 0,
['OtherItemsBundle'] = nil,
['SlotType'] = 'head',
['RemoveDefaultItemsList'] = nil,
['Modifier'] = nil,
['sets'] = 'head',
},
[12802] = {
['item_id'] =12802,
['name'] ='Club of the Grey Wastes',
['icon'] ='econ/items/ogre_magi/frostivus2018_ogre_prehistoric_hunter_weapon/frostivus2018_ogre_prehistoric_hunter_weapon',
['price'] = 1,
['HeroModel'] = nil,
['ArcanaAnim'] = nil,
['MaterialGroup'] = nil,
['ItemModel'] ='models/items/ogre_magi/frostivus2018_ogre_prehistoric_hunter_weapon/frostivus2018_ogre_prehistoric_hunter_weapon.vmdl',
['SetItems'] = nil,
['hide'] = 0,
['OtherItemsBundle'] = nil,
['SlotType'] = 'weapon',
['RemoveDefaultItemsList'] = nil,
['Modifier'] = nil,
['sets'] = 'weapon',
},
[18535] = {
['item_id'] =18535,
['name'] ='Stonebreak Excavators - Heads',
['icon'] ='econ/items/ogre_magi/aghs_bp_2021_ogre_magi_head/aghs_bp_2021_ogre_magi_head1',
['price'] = 1,
['HeroModel'] = nil,
['ArcanaAnim'] = nil,
['MaterialGroup'] = nil,
['ItemModel'] ='models/items/ogre_magi/ti8_ogre_crypt_treasure_hunting_team_head/ti8_ogre_crypt_treasure_hunting_team_head.vmdl',
['SetItems'] = nil,
['hide'] = 0,
['OtherItemsBundle'] = nil,
['SlotType'] = 'head',
['RemoveDefaultItemsList'] = nil,
['Modifier'] = nil,
['sets'] = 'head',
},
[18536] = {
['item_id'] =18536,
['name'] ='Stonebreak Excavators - Belt',
['icon'] ='econ/items/ogre_magi/aghs_bp_2021_ogre_magi_belt/aghs_bp_2021_ogre_magi_belt1',
['price'] = 1,
['HeroModel'] = nil,
['ArcanaAnim'] = nil,
['MaterialGroup'] = nil,
['ItemModel'] ='models/items/ogre_magi/ti8_ogre_crypt_treasure_hunting_team_belt/ti8_ogre_crypt_treasure_hunting_team_belt.vmdl',
['SetItems'] = nil,
['hide'] = 0,
['OtherItemsBundle'] = nil,
['SlotType'] = 'belt',
['RemoveDefaultItemsList'] = nil,
['Modifier'] = nil,
['sets'] = 'belt',
},
[18537] = {
['item_id'] =18537,
['name'] ='Stonebreak Excavators - Back',
['icon'] ='econ/items/ogre_magi/aghs_bp_2021_ogre_magi_back/aghs_bp_2021_ogre_magi_back_agh1',
['price'] = 1,
['HeroModel'] = nil,
['ArcanaAnim'] = nil,
['MaterialGroup'] = nil,
['ItemModel'] ='models/items/ogre_magi/ti8_ogre_crypt_treasure_hunting_team_back/ti8_ogre_crypt_treasure_hunting_team_back_agh.vmdl',
['SetItems'] = nil,
['hide'] = 0,
['OtherItemsBundle'] = nil,
['SlotType'] = 'back',
['RemoveDefaultItemsList'] = nil,
['Modifier'] = nil,
['sets'] = 'back',
},
[18538] = {
['item_id'] =18538,
['name'] ='Stonebreak Excavators - Arms',
['icon'] ='econ/items/ogre_magi/aghs_bp_2021_ogre_magi_arms/aghs_bp_2021_ogre_magi_arms',
['price'] = 1,
['HeroModel'] = nil,
['ArcanaAnim'] = nil,
['MaterialGroup'] = nil,
['ItemModel'] ='models/items/ogre_magi/ti8_ogre_crypt_treasure_hunting_team_arms/ti8_ogre_crypt_treasure_hunting_team_arms.vmdl',
['SetItems'] = nil,
['hide'] = 0,
['OtherItemsBundle'] = nil,
['SlotType'] = 'arms',
['RemoveDefaultItemsList'] = nil,
['Modifier'] = nil,
['sets'] = 'arms',
},
[4358] = {
['item_id'] =4358,
['name'] ='Lucky Belly Belt',
['icon'] ='econ/items/ogre_magi/belt_rich',
['price'] = 1,
['HeroModel'] = nil,
['ArcanaAnim'] = nil,
['MaterialGroup'] = nil,
['ItemModel'] ='models/items/ogre_magi/belt_rich.vmdl',
['SetItems'] = nil,
['hide'] = 0,
['OtherItemsBundle'] = nil,
['SlotType'] = 'belt',
['RemoveDefaultItemsList'] = nil,
['Modifier'] = nil,
['sets'] = 'belt',
},
[4360] = {
['item_id'] =4360,
['name'] ='Golden Walrus Whacker',
['icon'] ='econ/items/ogre_magi/goldenwalruswhacker/goldenwalruswhacker',
['price'] = 1,
['HeroModel'] = nil,
['ArcanaAnim'] = nil,
['MaterialGroup'] = nil,
['ItemModel'] ='models/items/ogre_magi/goldenwalruswhacker/goldenwalruswhacker.vmdl',
['SetItems'] = nil,
['hide'] = 0,
['OtherItemsBundle'] = nil,
['SlotType'] = 'weapon',
['RemoveDefaultItemsList'] = nil,
['Modifier'] = nil,
['sets'] = 'weapon',
},


[105] = {
['item_id'] =105,
['name'] ='Ogre Magi's Weapon',
['icon'] ='econ/heroes/ogre_magi/ogre_magi_weapon',
['price'] = 1,
['HeroModel'] = nil,
['ArcanaAnim'] = nil,
['MaterialGroup'] = nil,
['ItemModel'] ='models/heroes/ogre_magi/ogre_magi_weapon.vmdl',
['SetItems'] = nil,
['hide'] = 0,
['OtherItemsBundle'] = nil,
['SlotType'] = 'weapon',
['RemoveDefaultItemsList'] = nil,
['Modifier'] = nil,
['sets'] = 'weapon',
},
[12800] = {
['item_id'] =12800,
['name'] ='Belt of the Grey Wastes',
['icon'] ='econ/items/ogre_magi/frostivus2018_ogre_prehistoric_hunter_belt/frostivus2018_ogre_prehistoric_hunter_belt',
['price'] = 1,
['HeroModel'] = nil,
['ArcanaAnim'] = nil,
['MaterialGroup'] = nil,
['ItemModel'] ='models/items/ogre_magi/frostivus2018_ogre_prehistoric_hunter_belt/frostivus2018_ogre_prehistoric_hunter_belt.vmdl',
['SetItems'] = nil,
['hide'] = 0,
['OtherItemsBundle'] = nil,
['SlotType'] = 'belt',
['RemoveDefaultItemsList'] = nil,
['Modifier'] = nil,
['sets'] = 'belt',
},

[25945] = {
['item_id'] =25945,
['name'] ='Oni Magi - Weapon',
['icon'] ='econ/items/ogre_magi/ogre_magi_oni_lord_weapon/ogre_magi_oni_lord_weapon',
['price'] = 1,
['HeroModel'] = nil,
['ArcanaAnim'] = nil,
['MaterialGroup'] = nil,
['ItemModel'] ='models/items/ogre_magi/ogre_magi_oni_lord_weapon/ogre_magi_oni_lord_weapon.vmdl',
['SetItems'] = nil,
['hide'] = 0,
['OtherItemsBundle'] = nil,
['SlotType'] = 'weapon',
['RemoveDefaultItemsList'] = nil,
['Modifier'] = nil,
['sets'] = 'weapon',
},
[25948] = {
['item_id'] =25948,
['name'] ='Oni Magi - Head',
['icon'] ='econ/items/ogre_magi/ogre_magi_oni_lord_head/ogre_magi_oni_lord_head',
['price'] = 1,
['HeroModel'] = nil,
['ArcanaAnim'] = nil,
['MaterialGroup'] = nil,
['ItemModel'] ='models/items/ogre_magi/ogre_magi_oni_lord_head/ogre_magi_oni_lord_head.vmdl',
['SetItems'] = nil,
['hide'] = 0,
['OtherItemsBundle'] = nil,
['SlotType'] = 'head',
['RemoveDefaultItemsList'] = nil,
['Modifier'] = nil,
['sets'] = 'head',
},
[25949] = {
['item_id'] =25949,
['name'] ='Oni Magi - Back',
['icon'] ='econ/items/ogre_magi/ogre_magi_oni_lord_back/ogre_magi_oni_lord_back',
['price'] = 1,
['HeroModel'] = nil,
['ArcanaAnim'] = nil,
['MaterialGroup'] = nil,
['ItemModel'] ='models/items/ogre_magi/ogre_magi_oni_lord_back/ogre_magi_oni_lord_back.vmdl',
['SetItems'] = nil,
['hide'] = 0,
['OtherItemsBundle'] = nil,
['SlotType'] = 'back',
['RemoveDefaultItemsList'] = nil,
['Modifier'] = nil,
['sets'] = 'back',
},
[25947] = {
['item_id'] =25947,
['name'] ='Oni Magi - Arms',
['icon'] ='econ/items/ogre_magi/ogre_magi_oni_lord_arms/ogre_magi_oni_lord_arms',
['price'] = 1,
['HeroModel'] = nil,
['ArcanaAnim'] = nil,
['MaterialGroup'] = nil,
['ItemModel'] ='models/items/ogre_magi/ogre_magi_oni_lord_arms/ogre_magi_oni_lord_arms.vmdl',
['SetItems'] = nil,
['hide'] = 0,
['OtherItemsBundle'] = nil,
['SlotType'] = 'arms',
['RemoveDefaultItemsList'] = nil,
['Modifier'] = nil,
['sets'] = 'arms',
},
[25946] = {
['item_id'] =25946,
['name'] ='Oni Magi - Belt',
['icon'] ='econ/items/ogre_magi/ogre_magi_oni_lord_belt/ogre_magi_oni_lord_belt',
['price'] = 1,
['HeroModel'] = nil,
['ArcanaAnim'] = nil,
['MaterialGroup'] = nil,
['ItemModel'] ='models/items/ogre_magi/ogre_magi_oni_lord_belt/ogre_magi_oni_lord_belt.vmdl',
['SetItems'] = nil,
['hide'] = 0,
['OtherItemsBundle'] = nil,
['SlotType'] = 'belt',
['RemoveDefaultItemsList'] = nil,
['Modifier'] = nil,
['sets'] = 'belt',
},

[7839] = {
['item_id'] =7839,
['name'] ='Shield and Bracelet of the Antipodeans',
['icon'] ='econ/items/ogre_magi/antipodean_arms/antipodean_arms',
['price'] = 1,
['HeroModel'] = nil,
['ArcanaAnim'] = nil,
['MaterialGroup'] = nil,
['ItemModel'] ='models/items/ogre_magi/antipodean_arms/antipodean_arms.vmdl',
['SetItems'] = nil,
['hide'] = 0,
['OtherItemsBundle'] = nil,
['SlotType'] = 'arms',
['RemoveDefaultItemsList'] = nil,
['Modifier'] = nil,
['sets'] = 'arms',
},
[133] = {
['item_id'] =133,
['name'] ='Ogre Magi's Cape',
['icon'] ='econ/heroes/ogre_magi/ogre_magi_cape',
['price'] = 1,
['HeroModel'] = nil,
['ArcanaAnim'] = nil,
['MaterialGroup'] = nil,
['ItemModel'] ='models/heroes/ogre_magi/ogre_magi_cape.vmdl',
['SetItems'] = nil,
['hide'] = 0,
['OtherItemsBundle'] = nil,
['SlotType'] = 'back',
['RemoveDefaultItemsList'] = nil,
['Modifier'] = nil,
['sets'] = 'back',
},
[134] = {
['item_id'] =134,
['name'] ='Ogre Magi's Bracers',
['icon'] ='econ/heroes/ogre_magi/ogre_magi_bracers',
['price'] = 1,
['HeroModel'] = nil,
['ArcanaAnim'] = nil,
['MaterialGroup'] = nil,
['ItemModel'] ='models/heroes/ogre_magi/ogre_magi_bracers.vmdl',
['SetItems'] = nil,
['hide'] = 0,
['OtherItemsBundle'] = nil,
['SlotType'] = 'arms',
['RemoveDefaultItemsList'] = nil,
['Modifier'] = nil,
['sets'] = 'arms',
},
[135] = {
['item_id'] =135,
['name'] ='Ogre Magi's Hats',
['icon'] ='econ/heroes/ogre_magi/ogre_magi_hats',
['price'] = 1,
['HeroModel'] = nil,
['ArcanaAnim'] = nil,
['MaterialGroup'] = nil,
['ItemModel'] ='models/heroes/ogre_magi/ogre_magi_hats.vmdl',
['SetItems'] = nil,
['hide'] = 0,
['OtherItemsBundle'] = nil,
['SlotType'] = 'head',
['RemoveDefaultItemsList'] = nil,
['Modifier'] = nil,
['sets'] = 'head',
},
[4359] = {
['item_id'] =4359,
['name'] ='Champion's Belly Belt',
['icon'] ='econ/items/ogre_magi/championbelt/championbelt',
['price'] = 1,
['HeroModel'] = nil,
['ArcanaAnim'] = nil,
['MaterialGroup'] = nil,
['ItemModel'] ='models/items/ogre_magi/championbelt/championbelt.vmdl',
['SetItems'] = nil,
['hide'] = 0,
['OtherItemsBundle'] = nil,
['SlotType'] = 'belt',
['RemoveDefaultItemsList'] = nil,
['Modifier'] = nil,
['sets'] = 'belt',
},

[4736] = {
['item_id'] =4736,
['name'] ='Ignited Scepter',
['icon'] ='econ/items/ogre_magi/embersceptre/embersceptre',
['price'] = 1,
['HeroModel'] = nil,
['ArcanaAnim'] = nil,
['MaterialGroup'] = nil,
['ItemModel'] ='models/items/ogre_magi/embersceptre/embersceptre.vmdl',
['SetItems'] = nil,
['hide'] = 0,
['OtherItemsBundle'] = nil,
['SlotType'] = 'weapon',
['RemoveDefaultItemsList'] = nil,
['Modifier'] = nil,
['sets'] = 'weapon',
},

[136] = {
['item_id'] =136,
['name'] ='Ogre Magi's Belt',
['icon'] ='econ/heroes/ogre_magi/ogre_magi_belt',
['price'] = 1,
['HeroModel'] = nil,
['ArcanaAnim'] = nil,
['MaterialGroup'] = nil,
['ItemModel'] ='models/heroes/ogre_magi/ogre_magi_belt.vmdl',
['SetItems'] = nil,
['hide'] = 0,
['OtherItemsBundle'] = nil,
['SlotType'] = 'belt',
['RemoveDefaultItemsList'] = nil,
['Modifier'] = nil,
['sets'] = 'belt',
},
[5241] = {
['item_id'] =5241,
['name'] ='Flaming Scepter of Ancestral Luck',
['icon'] ='econ/items/ogre_magi/ogre_ancestral_weapon/ogre_ancestral_weapon',
['price'] = 1,
['HeroModel'] = nil,
['ArcanaAnim'] = nil,
['MaterialGroup'] = nil,
['ItemModel'] ='models/items/ogre_magi/ogre_ancestral_weapon/ogre_ancestral_weapon.vmdl',
['SetItems'] = nil,
['hide'] = 0,
['OtherItemsBundle'] = nil,
['SlotType'] = 'weapon',
['RemoveDefaultItemsList'] = nil,
['Modifier'] = nil,
['sets'] = 'weapon',
},
[5242] = {
['item_id'] =5242,
['name'] ='Bracer and Band of Ancestral Luck',
['icon'] ='econ/items/ogre_magi/ogre_ancestral_arms/ogre_ancestral_arms',
['price'] = 1,
['HeroModel'] = nil,
['ArcanaAnim'] = nil,
['MaterialGroup'] = nil,
['ItemModel'] ='models/items/ogre_magi/ogre_ancestral_arms/ogre_ancestral_arms.vmdl',
['SetItems'] = nil,
['hide'] = 0,
['OtherItemsBundle'] = nil,
['SlotType'] = 'arms',
['RemoveDefaultItemsList'] = nil,
['Modifier'] = nil,
['sets'] = 'arms',
},

[7845] = {
['item_id'] =7845,
['name'] ='Pauldron and Cloak of the Antipodeans',
['icon'] ='econ/items/ogre_magi/antipodean_back/antipodean_back',
['price'] = 1,
['HeroModel'] = nil,
['ArcanaAnim'] = nil,
['MaterialGroup'] = nil,
['ItemModel'] ='models/items/ogre_magi/antipodean_back/antipodean_back.vmdl',
['SetItems'] = nil,
['hide'] = 0,
['OtherItemsBundle'] = nil,
['SlotType'] = 'back',
['RemoveDefaultItemsList'] = nil,
['Modifier'] = nil,
['sets'] = 'back',
},
[7846] = {
['item_id'] =7846,
['name'] ='Belt of the Antipodeans',
['icon'] ='econ/items/ogre_magi/antipodean_belt/antipodean_belt',
['price'] = 1,
['HeroModel'] = nil,
['ArcanaAnim'] = nil,
['MaterialGroup'] = nil,
['ItemModel'] ='models/items/ogre_magi/antipodean_belt/antipodean_belt.vmdl',
['SetItems'] = nil,
['hide'] = 0,
['OtherItemsBundle'] = nil,
['SlotType'] = 'belt',
['RemoveDefaultItemsList'] = nil,
['Modifier'] = nil,
['sets'] = 'belt',
},
[7847] = {
['item_id'] =7847,
['name'] ='Helmet and hood of the Antipodeans',
['icon'] ='econ/items/ogre_magi/antipodean_head/antipodean_head',
['price'] = 1,
['HeroModel'] = nil,
['ArcanaAnim'] = nil,
['MaterialGroup'] = nil,
['ItemModel'] ='models/items/ogre_magi/antipodean_head/antipodean_head.vmdl',
['SetItems'] = nil,
['hide'] = 0,
['OtherItemsBundle'] = nil,
['SlotType'] = 'head',
['RemoveDefaultItemsList'] = nil,
['Modifier'] = nil,
['sets'] = 'head',
},
[7848] = {
['item_id'] =7848,
['name'] ='Burning scepter of the Antipodeans',
['icon'] ='econ/items/ogre_magi/antipodean_weapon/antipodean_weapon',
['price'] = 1,
['HeroModel'] = nil,
['ArcanaAnim'] = nil,
['MaterialGroup'] = nil,
['ItemModel'] ='models/items/ogre_magi/antipodean_weapon/antipodean_weapon.vmdl',
['SetItems'] = nil,
['hide'] = 0,
['OtherItemsBundle'] = nil,
['SlotType'] = 'weapon',
['RemoveDefaultItemsList'] = nil,
['Modifier'] = nil,
['sets'] = 'weapon',
},
[12799] = {
['item_id'] =12799,
['name'] ='Cape of the Grey Wastes',
['icon'] ='econ/items/ogre_magi/frostivus2018_ogre_prehistoric_hunter_back/frostivus2018_ogre_prehistoric_hunter_back',
['price'] = 1,
['HeroModel'] = nil,
['ArcanaAnim'] = nil,
['MaterialGroup'] = nil,
['ItemModel'] ='models/items/ogre_magi/frostivus2018_ogre_prehistoric_hunter_back/frostivus2018_ogre_prehistoric_hunter_back.vmdl',
['SetItems'] = nil,
['hide'] = 0,
['OtherItemsBundle'] = nil,
['SlotType'] = 'back',
['RemoveDefaultItemsList'] = nil,
['Modifier'] = nil,
['sets'] = 'back',
},
[5243] = {
['item_id'] =5243,
['name'] ='Mantle of Ancestral Luck',
['icon'] ='econ/items/ogre_magi/ogre_ancestral_back/ogre_ancestral_back',
['price'] = 1,
['HeroModel'] = nil,
['ArcanaAnim'] = nil,
['MaterialGroup'] = nil,
['ItemModel'] ='models/items/ogre_magi/ogre_ancestral_back/ogre_ancestral_back.vmdl',
['SetItems'] = nil,
['hide'] = 0,
['OtherItemsBundle'] = nil,
['SlotType'] = 'back',
['RemoveDefaultItemsList'] = nil,
['Modifier'] = nil,
['sets'] = 'back',
},
[5244] = {
['item_id'] =5244,
['name'] ='Belt of Ancestral Luck',
['icon'] ='econ/items/ogre_magi/ogre_ancestral_belt/ogre_ancestral_belt',
['price'] = 1,
['HeroModel'] = nil,
['ArcanaAnim'] = nil,
['MaterialGroup'] = nil,
['ItemModel'] ='models/items/ogre_magi/ogre_ancestral_belt/ogre_ancestral_belt.vmdl',
['SetItems'] = nil,
['hide'] = 0,
['OtherItemsBundle'] = nil,
['SlotType'] = 'belt',
['RemoveDefaultItemsList'] = nil,
['Modifier'] = nil,
['sets'] = 'belt',
},
[5245] = {
['item_id'] =5245,
['name'] ='Masks of Ancestral Luck',
['icon'] ='econ/items/ogre_magi/ogre_ancestral_head/ogre_ancestral_head',
['price'] = 1,
['HeroModel'] = nil,
['ArcanaAnim'] = nil,
['MaterialGroup'] = nil,
['ItemModel'] ='models/items/ogre_magi/ogre_ancestral_head/ogre_ancestral_head.vmdl',
['SetItems'] = nil,
['hide'] = 0,
['OtherItemsBundle'] = nil,
['SlotType'] = 'head',
['RemoveDefaultItemsList'] = nil,
['Modifier'] = nil,
['sets'] = 'head',
},


[18534] = {
['item_id'] =18534,
['name'] ='Stonebreak Excavators - Weapon',
['icon'] ='econ/items/ogre_magi/aghs_bp_2021_ogre_magi_weapon/aghs_bp_2021_ogre_magi_weapon1',
['price'] = 1,
['HeroModel'] = nil,
['ArcanaAnim'] = nil,
['MaterialGroup'] = nil,
['ItemModel'] ='models/items/ogre_magi/ti8_ogre_crypt_treasure_hunting_team_weapon/ti8_ogre_crypt_treasure_hunting_team_weapon.vmdl',
['SetItems'] = nil,
['hide'] = 0,
['OtherItemsBundle'] = nil,
['SlotType'] = 'weapon',
['RemoveDefaultItemsList'] = nil,
['Modifier'] = nil,
['sets'] = 'weapon',
},


]]