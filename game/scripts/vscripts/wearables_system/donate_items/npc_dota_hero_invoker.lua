return 
{

    [9415] = 
    {
        ["item_id"] = 9415,
        ["name"] = "Covenant of the Depths Spirit",
        ["icon"] = "econ/items/invoker/forge_spirit/covenant_of_the_depths_deep_forged/covenant_of_the_depths_deep_forged_npc_dota_invoker_forged_spirit",
        ["price"] = 400,
        ["HeroModel"] = nil,
        ["ArcanaAnim"] = nil,
        ["MaterialGroup"] = nil,
        ["ItemModel"] = "",
        ["ParticlesItems"] = nil,
        ["ParticlesHero"] = nil,
        ["SetItems"] = nil,
        ["hide"] = 0,
        ["OtherItemsBundle"] = nil,
        ["SlotType"] = "invoker_forge",
        ["RemoveDefaultItemsList"] = {},
        ["Modifier"] = "modifier_invoker_forge_1",
        ['sets'] = "rare",
        ["OtherModelsPrecache"] =
        {
            "models/items/invoker/forge_spirit/covenant_of_the_depths_deep_forged/covenant_of_the_depths_deep_forged.vmdl"
        }
    },
    [7231] = 
    {
        ["item_id"] = 7231,
        ["name"] = "Infernus",
        ["icon"] = "econ/items/invoker/forge_spirit/infernus/infernus_npc_dota_invoker_forged_spirit",
        ["price"] = 800,
        ["HeroModel"] = nil,
        ["ArcanaAnim"] = nil,
        ["MaterialGroup"] = nil,
        ["ItemModel"] = "",
        ["ParticlesItems"] = nil,
        ["ParticlesHero"] = nil,
        ["SetItems"] = nil,
        ["hide"] = 0,
        ["OtherItemsBundle"] = nil,
        ["SlotType"] = "invoker_forge",
        ["RemoveDefaultItemsList"] = {},
        ["Modifier"] = "modifier_invoker_forge_2",
        ['sets'] = "rare",
        ["OtherModelsPrecache"] =
        {
           "models/items/invoker/forge_spirit/infernus/infernus.vmdl"
        }
    },
    [8375] = 
    {
        ["item_id"] = 8375,
        ["name"] = "Familiars of Glorious Inspiration",
        ["icon"] = "econ/items/invoker/forge_spirit/esl_relics_forge_spirit/esl_relics_forge_spirit_npc_dota_invoker_forged_spirit",
        ["price"] = 400,
        ["HeroModel"] = nil,
        ["ArcanaAnim"] = nil,
        ["MaterialGroup"] = nil,
        ["ItemModel"] = "",
        ["ParticlesItems"] = nil,
        ["ParticlesHero"] = nil,
        ["SetItems"] = nil,
        ["hide"] = 0,
        ["OtherItemsBundle"] = nil,
        ["SlotType"] = "invoker_forge",
        ["RemoveDefaultItemsList"] = {},
        ["Modifier"] = "modifier_invoker_forge_3",
        ['sets'] = "rare",
        ["ParticlesSkills"] =
        {
            "particles/econ/items/invoker/glorious_inspiration/invoker_forge_spirit_ambient_esl.vpcf",
           "models/items/invoker/forge_spirit/esl_relics_forge_spirit/esl_relics_forge_spirit.vmdl"
        },
        ["OtherModelsPrecache"] =
        {
           "models/items/invoker/forge_spirit/esl_relics_forge_spirit/esl_relics_forge_spirit.vmdl"
        }
    },


    [8746] = 
    {
        ['item_id'] =8746,
        ['name'] ='Magus Apex',
        ['icon'] ='econ/items/invoker/magus_apex/magus_apex2',
        ['price'] = 1500,
        ['HeroModel'] = nil,
        ['ArcanaAnim'] = nil,
        ['MaterialGroup'] = nil,
        ['ItemModel'] ='models/items/invoker/magus_apex/magus_apex.vmdl',
        ['SetItems'] = nil,
        ['hide'] = 0,
        ['OtherItemsBundle'] = nil,
        ['SlotType'] = 'head',
        ['RemoveDefaultItemsList'] = nil,
        ['Modifier'] = "modifier_magus_apex_custom",
        ['sets'] = 'rare',
        ['ParticlesItems'] = 
        {
            {
                ['ParticleName'] = 'particles/econ/items/invoker/invoker_apex/invoker_magus_apex_ambient.vpcf',
                ['DefaultPattch'] = PATTACH_ABSORIGIN_FOLLOW,
                ['ControllPoints'] = 
                {
                    [0] = 
                    {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_head",
                    },
                    [1] = 
                    {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_eye_r",
                    },
                    [2] = 
                    {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_eye_l",
                    }
                }
            }
        },
        ["ParticlesSkills"] =
        {
            "particles/econ/items/invoker/invoker_apex/invoker_apex_quas_orb.vpcf",
            "particles/econ/items/invoker/invoker_apex/invoker_apex_wex_orb.vpcf",
            "particles/econ/items/invoker/invoker_apex/invoker_apex_exort_orb.vpcf",
            "particles/econ/items/invoker/invoker_apex/invoker_sun_strike_immortal1.vpcf", 
            "particles/econ/items/invoker/invoker_apex/invoker_sun_strike_team_immortal1.vpcf",
            "particles/invoker_sunstrike_donate/invoker_sun_strike_team_immortal.vpcf",
            "particles/invoker_sunstrike/invoker_sun_strike_immortal_donateexplos.vpcf"
        }
    },
    [7821] = 
    {
        ['item_id'] =7821,
        ['name'] ='Magus Accord',
        ['icon'] ='econ/items/invoker/immortal_arms_ti7/immortal_arms_ti7',
        ['price'] = 2500,
        ['HeroModel'] = nil,
        ['ArcanaAnim'] = nil,
        ['MaterialGroup'] = nil,
        ['ItemModel'] ='models/items/invoker/immortal_arms_ti7/immortal_arms_ti7.vmdl',
        ['SetItems'] = nil,
        ['hide'] = 0,
        ['OtherItemsBundle'] = nil,
        ['SlotType'] = 'arms',
        ['RemoveDefaultItemsList'] = nil,
        ['Modifier'] = "modifier_magus_accord_custom",
        ['sets'] = 'rare',
        ['ParticlesItems'] = 
        {
            {
                ['ParticleName'] = "particles/econ/items/invoker/invoker_ti7/invoker_ti7_bracer_ambient.vpcf",
                ['DefaultPattch'] = PATTACH_ABSORIGIN_FOLLOW,
                ['ControllPoints'] = 
                {
                    [0] = 
                    {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_hand_l",
                    },
                    [1] = 
                    {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_hand_r",
                    },
                }
            }
        },
        ["ParticlesSkills"] =
        {
            "particles/econ/items/invoker/invoker_ti7/invoker_ti7_alacrity_cast.vpcf",
            "particles/econ/items/invoker/invoker_ti7/invoker_ti7_alacrity.vpcf",
            "particles/econ/items/invoker/invoker_ti7/invoker_ti7_alacrity_buff.vpcf",
        }
    },

    [9975] = 
    {
        ['item_id'] =9975,
        ['name'] ='Crown of Fate Meridian',
        ['icon'] ='econ/items/invoker/ti8_invoker_prism_crystal_spellcaster_head/ti8_invoker_prism_crystal_spellcaster_head',
        ['price'] = 1,
        ['HeroModel'] = nil,
        ['ArcanaAnim'] = nil,
        ['MaterialGroup'] = nil,
        ['ItemModel'] ='models/items/invoker/ti8_invoker_prism_crystal_spellcaster_head/ti8_invoker_prism_crystal_spellcaster_head.vmdl',
        ['SetItems'] = nil,
        ['hide'] = 1,
        ['OtherItemsBundle'] = nil,
        ['SlotType'] = 'head',
        ['RemoveDefaultItemsList'] = nil,
        ['Modifier'] = "modifier_invoker_fate_meridian_head",
        ['sets'] = 'fate_meridian_invoke',
    },
    [9976] = 
    {
        ['item_id'] =9976,
        ['name'] ='Mantle of Fate Meridian',
        ['icon'] ='econ/items/invoker/ti8_invoker_prism_crystal_spellcaster_shoulder/ti8_invoker_prism_crystal_spellcaster_shoulder',
        ['price'] = 1,
        ['HeroModel'] = nil,
        ['ArcanaAnim'] = nil,
        ['MaterialGroup'] = nil,
        ['ItemModel'] ='models/items/invoker/ti8_invoker_prism_crystal_spellcaster_shoulder/ti8_invoker_prism_crystal_spellcaster_shoulder.vmdl',
        ['SetItems'] = nil,
        ['hide'] = 1,
        ['OtherItemsBundle'] = nil,
        ['SlotType'] = 'shoulder',
        ['RemoveDefaultItemsList'] = nil,
        ['Modifier'] = nil,
        ['sets'] = 'fate_meridian_invoke',
    },
    [9977] = 
    {
        ['item_id'] =9977,
        ['name'] ='Arms of Fate Meridian',
        ['icon'] ='econ/items/invoker/ti8_invoker_prism_crystal_spellcaster_arms/ti8_invoker_prism_crystal_spellcaster_arms',
        ['price'] = 1,
        ['HeroModel'] = nil,
        ['ArcanaAnim'] = nil,
        ['MaterialGroup'] = nil,
        ['ItemModel'] ='models/items/invoker/ti8_invoker_prism_crystal_spellcaster_arms/ti8_invoker_prism_crystal_spellcaster_arms.vmdl',
        ['SetItems'] = nil,
        ['hide'] = 1,
        ['OtherItemsBundle'] = nil,
        ['SlotType'] = 'arms',
        ['RemoveDefaultItemsList'] = nil,
        ['Modifier'] = nil,
        ['sets'] = 'fate_meridian_invoke',
    },
    [9978] = 
    {
        ['item_id'] =9978,
        ['name'] ='Belt of Fate Meridian',
        ['icon'] ='econ/items/invoker/ti8_invoker_prism_crystal_spellcaster_belt/ti8_invoker_prism_crystal_spellcaster_belt',
        ['price'] = 1,
        ['HeroModel'] = nil,
        ['ArcanaAnim'] = nil,
        ['MaterialGroup'] = nil,
        ['ItemModel'] ='models/items/invoker/ti8_invoker_prism_crystal_spellcaster_belt/ti8_invoker_prism_crystal_spellcaster_belt.vmdl',
        ['SetItems'] = nil,
        ['hide'] = 1,
        ['OtherItemsBundle'] = nil,
        ['SlotType'] = 'belt',
        ['RemoveDefaultItemsList'] = nil,
        ['Modifier'] = nil,
        ['sets'] = 'fate_meridian_invoke',
    },
    [9979] = 
    {
        ['item_id'] =9979,
        ['name'] ='Cape of Fate Meridian',
        ['icon'] ='econ/items/invoker/ti8_invoker_prism_crystal_spellcaster_back/ti8_invoker_prism_crystal_spellcaster_back',
        ['price'] = 1,
        ['HeroModel'] = nil,
        ['ArcanaAnim'] = nil,
        ['MaterialGroup'] = nil,
        ['ItemModel'] ='models/items/invoker/ti8_invoker_prism_crystal_spellcaster_back/ti8_invoker_prism_crystal_spellcaster_back.vmdl',
        ['SetItems'] = nil,
        ['hide'] = 1,
        ['OtherItemsBundle'] = nil,
        ['SlotType'] = 'back',
        ['RemoveDefaultItemsList'] = nil,
        ['Modifier'] = nil,
        ['sets'] = 'fate_meridian_invoke',
    },

    [9416] = 
    {
        ['item_id'] =9416,
        ['name'] ='Covenant of the Depths Mantle',
        ['icon'] ='econ/items/invoker/covenant_of_the_depths_back/covenant_of_the_depths_back',
        ['price'] = 200,
        ['HeroModel'] = nil,
        ['ArcanaAnim'] = nil,
        ['MaterialGroup'] = nil,
        ['ItemModel'] ='models/items/invoker/covenant_of_the_depths_back/covenant_of_the_depths_back.vmdl',
        ['SetItems'] = nil,
        ['hide'] = 0,
        ['OtherItemsBundle'] = nil,
        ['SlotType'] = 'back',
        ['RemoveDefaultItemsList'] = nil,
        ['Modifier'] = nil,
        ['sets'] = 'covenant_depth_mantle',
    },
    [9418] = 
    {
        ['item_id'] =9418,
        ['name'] ='Covenant of the Depths Bracers',
        ['icon'] ='econ/items/invoker/covenant_of_the_depths_arms/covenant_of_the_depths_arms',
        ['price'] = 200,
        ['HeroModel'] = nil,
        ['ArcanaAnim'] = nil,
        ['MaterialGroup'] = nil,
        ['ItemModel'] ='models/items/invoker/covenant_of_the_depths_arms/covenant_of_the_depths_arms.vmdl',
        ['SetItems'] = nil,
        ['hide'] = 0,
        ['OtherItemsBundle'] = nil,
        ['SlotType'] = 'arms',
        ['RemoveDefaultItemsList'] = nil,
        ['Modifier'] = nil,
        ['sets'] = 'covenant_depth_mantle',
    },
    [9420] = 
    {
        ['item_id'] =9420,
        ['name'] ='Covenant of the Depths Belt',
        ['icon'] ='econ/items/invoker/covenant_of_the_depths_belt_v2/covenant_of_the_depths_belt_v2',
        ['price'] = 200,
        ['HeroModel'] = nil,
        ['ArcanaAnim'] = nil,
        ['MaterialGroup'] = nil,
        ['ItemModel'] ='models/items/invoker/covenant_of_the_depths_belt_v2/covenant_of_the_depths_belt_v2.vmdl',
        ['SetItems'] = nil,
        ['hide'] = 0,
        ['OtherItemsBundle'] = nil,
        ['SlotType'] = 'belt',
        ['RemoveDefaultItemsList'] = nil,
        ['Modifier'] = nil,
        ['sets'] = 'covenant_depth_mantle',
    },
    [9419] = 
    {
        ['item_id'] =9419,
        ['name'] ='Covenant of the Depths Mask',
        ['icon'] ='econ/items/invoker/covenant_of_the_depths_head/covenant_of_the_depths_head',
        ['price'] = 200,
        ['HeroModel'] = nil,
        ['ArcanaAnim'] = nil,
        ['MaterialGroup'] = nil,
        ['ItemModel'] ='models/items/invoker/covenant_of_the_depths_head/covenant_of_the_depths_head.vmdl',
        ['SetItems'] = nil,
        ['hide'] = 0,
        ['OtherItemsBundle'] = nil,
        ['SlotType'] = 'head',
        ['RemoveDefaultItemsList'] = nil,
        ['Modifier'] = nil,
        ['sets'] = 'covenant_depth_mantle',
    },
    [9417] = 
    {
        ['item_id'] =9417,
        ['name'] ='Covenant of the Depths Robes',
        ['icon'] ='econ/items/invoker/covenant_of_the_depths_shoulder/covenant_of_the_depths_shoulder',
        ['price'] = 200,
        ['HeroModel'] = nil,
        ['ArcanaAnim'] = nil,
        ['MaterialGroup'] = nil,
        ['ItemModel'] ='models/items/invoker/covenant_of_the_depths_shoulder/covenant_of_the_depths_shoulder.vmdl',
        ['SetItems'] = nil,
        ['hide'] = 0,
        ['OtherItemsBundle'] = nil,
        ['SlotType'] = 'shoulder',
        ['RemoveDefaultItemsList'] = nil,
        ['Modifier'] = nil,
        ['sets'] = 'covenant_depth_mantle',
        ['ParticlesItems'] = 
        {
            {
                ['ParticleName'] = "particles/econ/items/invoker/invoker_depths/invoker_depths_ambient.vpcf",
                ['DefaultPattch'] = PATTACH_ABSORIGIN_FOLLOW,
                ['ControllPoints'] = 
                {
                    [0] = 
                    {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_potion",
                    },
                }
            }
        },
    },

    [7979] = 
    {
        ['item_id'] =7979,
        ['name'] ='Dark Artistry Cape',
        ['icon'] ='econ/items/invoker/dark_artistry/dark_artistry_cape_model',
        ['price'] = 4000,
        ['HeroModel'] = nil,
        ['ArcanaAnim'] = nil,
        ['MaterialGroup'] = nil,
        ['ItemModel'] ='models/items/invoker/dark_artistry/dark_artistry_cape_model.vmdl',
        ['SetItems'] = nil,
        ['hide'] = 0,
        ['OtherItemsBundle'] = nil,
        ['SlotType'] = 'back',
        ['RemoveDefaultItemsList'] = nil,
        ['Modifier'] = "modifier_invoker_dark_artistry_cape",
        ['sets'] = 'dark_artistry_invoke',
        ['ParticlesItems'] = 
        {
            {
                ['ParticleName'] = "particles/econ/items/invoker/invoker_ti6/invoker_ti6_cape_ambient.vpcf",
                ['DefaultPattch'] = PATTACH_ABSORIGIN_FOLLOW,
                ['ControllPoints'] = 
                {
                    [0] = 
                    {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_spine",
                    },
                }
            }
        },
        ["ParticlesSkills"] =
        {
            "particles/econ/items/invoker/invoker_ti6/invoker_ti6_exort_orb.vpcf",
            "particles/econ/items/invoker/invoker_ti6/invoker_ti6_wex_orb.vpcf",
            "particles/econ/items/invoker/invoker_ti6/invoker_tornado_ti6.vpcf",
            "particles/econ/items/invoker/invoker_ti6/invoker_deafening_blast_ti6.vpcf",
            "particles/econ/items/invoker/invoker_ti6/invoker_ti6_quas_orb.vpcf"
        }
    },
    [7986] = 
    {
        ['item_id'] =7986,
        ['name'] ='Dark Artistry Hair',
        ['icon'] ='econ/items/invoker/dark_artistry/dark_artistry_hair_model',
        ['price'] = 800,
        ['HeroModel'] = nil,
        ['ArcanaAnim'] = nil,
        ['MaterialGroup'] = nil,
        ['ItemModel'] ='models/items/invoker/dark_artistry/dark_artistry_hair_model.vmdl',
        ['SetItems'] = nil,
        ['hide'] = 0,
        ['OtherItemsBundle'] = nil,
        ['SlotType'] = 'head',
        ['RemoveDefaultItemsList'] = nil,
        ['Modifier'] = "modifier_invoker_dark_artistry_hair",
        ['sets'] = 'dark_artistry_invoke',
    },
    [7987] = 
    {
        ['item_id'] =7987,
        ['name'] ='Dark Artistry Pauldrons',
        ['icon'] ='econ/items/invoker/dark_artistry/dark_artistry_shoulder_model',
        ['price'] = 800,
        ['HeroModel'] = nil,
        ['ArcanaAnim'] = nil,
        ['MaterialGroup'] = nil,
        ['ItemModel'] ='models/items/invoker/dark_artistry/dark_artistry_shoulder_model.vmdl',
        ['SetItems'] = nil,
        ['hide'] = 0,
        ['OtherItemsBundle'] = nil,
        ['SlotType'] = 'shoulder',
        ['RemoveDefaultItemsList'] = nil,
        ['Modifier'] = nil,
        ['sets'] = 'dark_artistry_invoke',
    },
    [7988] = 
    {
        ['item_id'] =7988,
        ['name'] ='Dark Artistry Bracers',
        ['icon'] ='econ/items/invoker/dark_artistry/dark_artistry_bracer_model',
        ['price'] = 800,
        ['HeroModel'] = nil,
        ['ArcanaAnim'] = nil,
        ['MaterialGroup'] = nil,
        ['ItemModel'] ='models/items/invoker/dark_artistry/dark_artistry_bracer_model.vmdl',
        ['SetItems'] = nil,
        ['hide'] = 0,
        ['OtherItemsBundle'] = nil,
        ['SlotType'] = 'arms',
        ['RemoveDefaultItemsList'] = nil,
        ['Modifier'] = nil,
        ['sets'] = 'dark_artistry_invoke',
    },
    [7989] = 
    {
        ['item_id'] =7989,
        ['name'] ='Dark Artistry Belt',
        ['icon'] ='econ/items/invoker/dark_artistry/dark_artistry_belt_model',
        ['price'] = 800,
        ['HeroModel'] = nil,
        ['ArcanaAnim'] = nil,
        ['MaterialGroup'] = nil,
        ['ItemModel'] ='models/items/invoker/dark_artistry/dark_artistry_belt_model.vmdl',
        ['SetItems'] = nil,
        ['hide'] = 0,
        ['OtherItemsBundle'] = nil,
        ['SlotType'] = 'belt',
        ['RemoveDefaultItemsList'] = nil,
        ['Modifier'] = nil,
        ['sets'] = 'dark_artistry_invoke',
    },


[29031] = 
{
    ['item_id'] =29031,
    ['name'] ='Wyrdwing Exaltation - Wings',
    ['icon'] ='econ/items/invoker/invoker_wings_of_wisdom_back/invoker_wings_of_wisdom_back',
    ['price'] = 1000,
    ['HeroModel'] = nil,
    ['ArcanaAnim'] = nil,
    ['MaterialGroup'] = nil,
    ['MaterialGroupItem'] = "3",
    ['ItemModel'] ='models/items/invoker/invoker_wings_of_wisdom_back/invoker_wings_of_wisdom_back.vmdl',
    ['SetItems'] = nil,
    ['hide'] = 0,
    ['OtherItemsBundle'] = {{29031, "#724d85"}, {290311, "#1c71c7"}, {290312, "#c465f0"}, {290313, "#d47719"}},
    ['SlotType'] = 'back',
    ['RemoveDefaultItemsList'] = nil,
    ['Modifier'] = nil,
    ['sets'] = 'invoker_wyrdling_exaltation',
    ['ParticlesItems'] = 
    {
        {
            ['ParticleName'] = 'particles/econ/items/invoker/invoker_crownfall/invoker_crownfall_wings_ambient.vpcf',
            ['DefaultPattch'] = PATTACH_ABSORIGIN_FOLLOW,
            ['ControllPoints'] = 
            {
                [0] = {"SetParticleControl", "default"},
            }
        }
    },
},
[29026] = 
{
    ['item_id'] =29026,
    ['name'] ='Wyrdwing Exaltation - Arms',
    ['icon'] ='econ/items/invoker/invoker_wings_of_wisdom_arms/invoker_wings_of_wisdom_arms',
    ['price'] = 400,
    ['HeroModel'] = nil,
    ['ArcanaAnim'] = nil,
    ['MaterialGroup'] = nil,
    ['MaterialGroupItem'] = "1",
    ['ItemModel'] ='models/items/invoker/invoker_wings_of_wisdom_arms/invoker_wings_of_wisdom_arms.vmdl',
    ['SetItems'] = nil,
    ['hide'] = 0,
    ['OtherItemsBundle'] = {{29026, "#724d85"}, {290261, "#1c71c7"}, {290262, "#c465f0"}, {290263, "#d47719"}},
    ['SlotType'] = 'arms',
    ['RemoveDefaultItemsList'] = nil,
    ['Modifier'] = nil,
    ['sets'] = 'invoker_wyrdling_exaltation',
},
[29028] = 
{
    ['item_id'] =29028,
    ['name'] ='Wyrdwing Exaltation - Head',
    ['icon'] ='econ/items/invoker/invoker_wings_of_wisdom_head/invoker_wings_of_wisdom_head',
    ['price'] = 800,
    ['HeroModel'] = nil,
    ['ArcanaAnim'] = nil,
    ['MaterialGroup'] = nil,
    ['MaterialGroupItem'] = "3",
    ['ItemModel'] ='models/items/invoker/invoker_wings_of_wisdom_head/invoker_wings_of_wisdom_head.vmdl',
    ['SetItems'] = nil,
    ['hide'] = 0,
    ['OtherItemsBundle'] = {{29028, "#724d85"}, {290281, "#1c71c7"}, {290282, "#c465f0"}, {290283, "#d47719"}},
    ['SlotType'] = 'head',
    ['RemoveDefaultItemsList'] = nil,
    ['Modifier'] = nil,
    ['sets'] = 'invoker_wyrdling_exaltation',
},
[29029] = 
{
    ['item_id'] =29029,
    ['name'] ='Wyrdwing Exaltation - Shoulder',
    ['icon'] ='econ/items/invoker/invoker_wings_of_wisdom_shoulder/invoker_wings_of_wisdom_shoulder',
    ['price'] = 800,
    ['HeroModel'] = nil,
    ['ArcanaAnim'] = nil,
    ['MaterialGroup'] = nil,
    ['MaterialGroupItem'] = "3",
    ['ItemModel'] ='models/items/invoker/invoker_wings_of_wisdom_shoulder/invoker_wings_of_wisdom_shoulder.vmdl',
    ['SetItems'] = nil,
    ['hide'] = 0,
    ['OtherItemsBundle'] = {{29029, "#724d85"}, {290291, "#1c71c7"}, {290292, "#c465f0"}, {290293, "#d47719"}},
    ['SlotType'] = 'shoulder',
    ['RemoveDefaultItemsList'] = nil,
    ['Modifier'] = nil,
    ['sets'] = 'invoker_wyrdling_exaltation',
    ['ParticlesItems'] = 
    {
        {
            ['ParticleName'] = "particles/econ/items/invoker/invoker_crownfall/invoker_crownfall_back_ambient_neutral.vpcf",
            ['DefaultPattch'] = PATTACH_ABSORIGIN_FOLLOW,
            ['ControllPoints'] = 
            {
                [4] = 
                {
                    'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                    "attach_gem_fx",
                },
                [5] = 
                {
                    'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                    "attach_gem_fx1",
                },
                [6] = 
                {
                    'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                    "attach_gem_fx2",
                },
                [7] = 
                {
                    'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                    "attach_gem_fx3",
                },
                [8] = 
                {
                    'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                    "attach_gem_fx4",
                },
            }
        }
    },
},
[28859] = 
{
    ['item_id'] =28859,
    ['name'] ='Wyrdwing Exaltation - Belt',
    ['icon'] ='econ/items/invoker/invoker_wings_of_wisdom_belt/invoker_wings_of_wisdom_belt',
    ['price'] = 600,
    ['HeroModel'] = nil,
    ['ArcanaAnim'] = nil,
    ['MaterialGroup'] = nil,
    ['MaterialGroupItem'] = "3",
    ['ItemModel'] ='models/items/invoker/invoker_wings_of_wisdom_belt/invoker_wings_of_wisdom_belt.vmdl',
    ['SetItems'] = nil,
    ['hide'] = 0,
    ['OtherItemsBundle'] = {{28859, "#724d85"}, {288591, "#1c71c7"}, {288592, "#c465f0"}, {288593, "#d47719"}},
    ['SlotType'] = 'belt',
    ['RemoveDefaultItemsList'] = nil,
    ['Modifier'] = nil,
    ['sets'] = 'invoker_wyrdling_exaltation',
},


[290311] = 
{
    ['item_id'] =290311,
    ['name'] ='Wyrdwing Exaltation - Wings',
    ['icon'] ='econ/items/invoker/invoker_wings_of_wisdom_back/invoker_wings_of_wisdom_back_style1',
    ['price'] = 1,
    ['HeroModel'] = nil,
    ['ArcanaAnim'] = nil,
    ['MaterialGroup'] = nil,
    ['MaterialGroupItem'] = "default",
    ['ItemModel'] ='models/items/invoker/invoker_wings_of_wisdom_back/invoker_wings_of_wisdom_back.vmdl',
    ['SetItems'] = nil,
    ['hide'] = 1,
    ['OtherItemsBundle'] = {{29031, "#724d85"}, {290311, "#1c71c7"}, {290312, "#c465f0"}, {290313, "#d47719"}},
    ['SlotType'] = 'back',
    ['RemoveDefaultItemsList'] = nil,
    ['Modifier'] = nil,
    ['sets'] = 'invoker_wyrdling_exaltation',
    ['ParticlesItems'] = 
    {
        {
            ['ParticleName'] = 'particles/econ/items/invoker/invoker_crownfall/invoker_crownfall_wings_ambient_blue.vpcf',
            ['DefaultPattch'] = PATTACH_ABSORIGIN_FOLLOW,
            ['ControllPoints'] = 
            {
                [0] = {"SetParticleControl", "default"},
            }
        }
    },
},
[290261] = 
{
    ['item_id'] =290261,
    ['name'] ='Wyrdwing Exaltation - Arms',
    ['icon'] ='econ/items/invoker/invoker_wings_of_wisdom_arms/invoker_wings_of_wisdom_arms_style1',
    ['price'] = 1,
    ['HeroModel'] = nil,
    ['ArcanaAnim'] = nil,
    ['MaterialGroup'] = nil,
    ['MaterialGroupItem'] = "default",
    ['ItemModel'] ='models/items/invoker/invoker_wings_of_wisdom_arms/invoker_wings_of_wisdom_arms.vmdl',
    ['SetItems'] = nil,
    ['hide'] = 1,
    ['OtherItemsBundle'] = {{29026, "#724d85"}, {290261, "#1c71c7"}, {290262, "#c465f0"}, {290263, "#d47719"}},
    ['SlotType'] = 'arms',
    ['RemoveDefaultItemsList'] = nil,
    ['Modifier'] = nil,
    ['sets'] = 'invoker_wyrdling_exaltation',
},
[290281] = 
{
    ['item_id'] =290281,
    ['name'] ='Wyrdwing Exaltation - Head',
    ['icon'] ='econ/items/invoker/invoker_wings_of_wisdom_head/invoker_wings_of_wisdom_head_style1',
    ['price'] = 1,
    ['HeroModel'] = nil,
    ['ArcanaAnim'] = nil,
    ['MaterialGroup'] = nil,
    ['MaterialGroupItem'] = "default",
    ['ItemModel'] ='models/items/invoker/invoker_wings_of_wisdom_head/invoker_wings_of_wisdom_head.vmdl',
    ['SetItems'] = nil,
    ['hide'] = 1,
    ['OtherItemsBundle'] = {{29028, "#724d85"}, {290281, "#1c71c7"}, {290282, "#c465f0"}, {290283, "#d47719"}},
    ['SlotType'] = 'head',
    ['RemoveDefaultItemsList'] = nil,
    ['Modifier'] = nil,
    ['sets'] = 'invoker_wyrdling_exaltation',
},
[290291] = 
{
    ['item_id'] =290291,
    ['name'] ='Wyrdwing Exaltation - Shoulder',
    ['icon'] ='econ/items/invoker/invoker_wings_of_wisdom_shoulder/invoker_wings_of_wisdom_shoulder_style1',
    ['price'] = 1,
    ['HeroModel'] = nil,
    ['ArcanaAnim'] = nil,
    ['MaterialGroup'] = nil,
    ['ItemModel'] ="models/items/invoker/invoker_wings_of_wisdom_shoulder/invoker_wings_of_knowledge_shoulder_alt.vmdl",
    ['SetItems'] = nil,
    ['hide'] = 1,
    ['OtherItemsBundle'] = {{29029, "#724d85"}, {290291, "#1c71c7"}, {290292, "#c465f0"}, {290293, "#d47719"}},
    ['SlotType'] = 'shoulder',
    ['RemoveDefaultItemsList'] = nil,
    ['Modifier'] = nil,
    ['sets'] = 'invoker_wyrdling_exaltation',
    ['ParticlesItems'] = 
    {
        {
            ['ParticleName'] = "particles/econ/items/invoker/invoker_crownfall/invoker_crownfall_back_ambient_blue.vpcf",
            ['DefaultPattch'] = PATTACH_ABSORIGIN_FOLLOW,
            ['ControllPoints'] = 
            {
                [4] = 
                {
                    'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                    "attach_gem_fx",
                },
                [5] = 
                {
                    'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                    "attach_gem_fx1",
                },
                [6] = 
                {
                    'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                    "attach_gem_fx2",
                },
                [7] = 
                {
                    'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                    "attach_gem_fx3",
                },
                [8] = 
                {
                    'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                    "attach_gem_fx4",
                },
            }
        }
    },
},
[288591] = 
{
    ['item_id'] =288591,
    ['name'] ='Wyrdwing Exaltation - Belt',
    ['icon'] ='econ/items/invoker/invoker_wings_of_wisdom_belt/invoker_wings_of_wisdom_belt_style1',
    ['price'] = 1,
    ['HeroModel'] = nil,
    ['ArcanaAnim'] = nil,
    ['MaterialGroup'] = nil,
    ['MaterialGroupItem'] = "default",
    ['ItemModel'] ='models/items/invoker/invoker_wings_of_wisdom_belt/invoker_wings_of_wisdom_belt.vmdl',
    ['SetItems'] = nil,
    ['hide'] = 1,
    ['OtherItemsBundle'] = {{28859, "#724d85"}, {288591, "#1c71c7"}, {288592, "#c465f0"}, {288593, "#d47719"}},
    ['SlotType'] = 'belt',
    ['RemoveDefaultItemsList'] = nil,
    ['Modifier'] = nil,
    ['sets'] = 'invoker_wyrdling_exaltation',
},



[290312] = 
{
    ['item_id'] =290312,
    ['name'] ='Wyrdwing Exaltation - Wings',
    ['icon'] ='econ/items/invoker/invoker_wings_of_wisdom_back/invoker_wings_of_wisdom_back_style2',
    ['price'] = 1,
    ['HeroModel'] = nil,
    ['ArcanaAnim'] = nil,
    ['MaterialGroup'] = nil,
    ['MaterialGroupItem'] = "1",
    ['ItemModel'] ='models/items/invoker/invoker_wings_of_wisdom_back/invoker_wings_of_wisdom_back.vmdl',
    ['SetItems'] = nil,
    ['hide'] = 1,
    ['OtherItemsBundle'] = {{29031, "#724d85"}, {290311, "#1c71c7"}, {290312, "#c465f0"}, {290313, "#d47719"}},
    ['SlotType'] = 'back',
    ['RemoveDefaultItemsList'] = nil,
    ['Modifier'] = nil,
    ['sets'] = 'invoker_wyrdling_exaltation',
    ['ParticlesItems'] = 
    {
        {
            ['ParticleName'] = 'particles/econ/items/invoker/invoker_crownfall/invoker_crownfall_wings_ambient_red.vpcf',
            ['DefaultPattch'] = PATTACH_ABSORIGIN_FOLLOW,
            ['ControllPoints'] = 
            {
                [0] = {"SetParticleControl", "default"},
            }
        }
    },
},
[290262] = 
{
    ['item_id'] =290262,
    ['name'] ='Wyrdwing Exaltation - Arms',
    ['icon'] ='econ/items/invoker/invoker_wings_of_wisdom_arms/invoker_wings_of_wisdom_arms_style2',
    ['price'] = 1,
    ['HeroModel'] = nil,
    ['ArcanaAnim'] = nil,
    ['MaterialGroup'] = nil,
    ['MaterialGroupItem'] = "3",
    ['ItemModel'] ='models/items/invoker/invoker_wings_of_wisdom_arms/invoker_wings_of_wisdom_arms.vmdl',
    ['SetItems'] = nil,
    ['hide'] = 1,
    ['OtherItemsBundle'] = {{29026, "#724d85"}, {290261, "#1c71c7"}, {290262, "#c465f0"}, {290263, "#d47719"}},
    ['SlotType'] = 'arms',
    ['RemoveDefaultItemsList'] = nil,
    ['Modifier'] = nil,
    ['sets'] = 'invoker_wyrdling_exaltation',
},
[290282] = 
{
    ['item_id'] =290282,
    ['name'] ='Wyrdwing Exaltation - Head',
    ['icon'] ='econ/items/invoker/invoker_wings_of_wisdom_head/invoker_wings_of_wisdom_head_style2',
    ['price'] = 1,
    ['HeroModel'] = nil,
    ['ArcanaAnim'] = nil,
    ['MaterialGroup'] = nil,
    ['MaterialGroupItem'] = "1",
    ['ItemModel'] ='models/items/invoker/invoker_wings_of_wisdom_head/invoker_wings_of_wisdom_head.vmdl',
    ['SetItems'] = nil,
    ['hide'] = 1,
    ['OtherItemsBundle'] = {{29028, "#724d85"}, {290281, "#1c71c7"}, {290282, "#c465f0"}, {290283, "#d47719"}},
    ['SlotType'] = 'head',
    ['RemoveDefaultItemsList'] = nil,
    ['Modifier'] = nil,
    ['sets'] = 'invoker_wyrdling_exaltation',
},
[290292] = 
{
    ['item_id'] =290292,
    ['name'] ='Wyrdwing Exaltation - Shoulder',
    ['icon'] ='econ/items/invoker/invoker_wings_of_wisdom_shoulder/invoker_wings_of_wisdom_shoulder_style2',
    ['price'] = 1,
    ['HeroModel'] = nil,
    ['ArcanaAnim'] = nil,
    ['MaterialGroup'] = nil,
    ['ItemModel'] ="models/items/invoker/invoker_wings_of_wisdom_shoulder/invoker_wings_of_knowledge_shoulder_alt1.vmdl",
    ['SetItems'] = nil,
    ['hide'] = 1,
    ['OtherItemsBundle'] = {{29029, "#724d85"}, {290291, "#1c71c7"}, {290292, "#c465f0"}, {290293, "#d47719"}},
    ['SlotType'] = 'shoulder',
    ['RemoveDefaultItemsList'] = nil,
    ['Modifier'] = nil,
    ['sets'] = 'invoker_wyrdling_exaltation',
    ['ParticlesItems'] = 
    {
        {
            ['ParticleName'] = "particles/econ/items/invoker/invoker_crownfall/invoker_crownfall_back_ambient_red.vpcf",
            ['DefaultPattch'] = PATTACH_ABSORIGIN_FOLLOW,
            ['ControllPoints'] = 
            {
                [4] = 
                {
                    'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                    "attach_gem_fx",
                },
                [5] = 
                {
                    'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                    "attach_gem_fx1",
                },
                [6] = 
                {
                    'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                    "attach_gem_fx2",
                },
                [7] = 
                {
                    'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                    "attach_gem_fx3",
                },
                [8] = 
                {
                    'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                    "attach_gem_fx4",
                },
            }
        }
    },
},
[288592] = 
{
    ['item_id'] =288592,
    ['name'] ='Wyrdwing Exaltation - Belt',
    ['icon'] ='econ/items/invoker/invoker_wings_of_wisdom_belt/invoker_wings_of_wisdom_belt_style2',
    ['price'] = 1,
    ['HeroModel'] = nil,
    ['ArcanaAnim'] = nil,
    ['MaterialGroup'] = nil,
    ['MaterialGroupItem'] = "1",
    ['ItemModel'] ='models/items/invoker/invoker_wings_of_wisdom_belt/invoker_wings_of_wisdom_belt.vmdl',
    ['SetItems'] = nil,
    ['hide'] = 1,
    ['OtherItemsBundle'] = {{28859, "#724d85"}, {288591, "#1c71c7"}, {288592, "#c465f0"}, {288593, "#d47719"}},
    ['SlotType'] = 'belt',
    ['RemoveDefaultItemsList'] = nil,
    ['Modifier'] = nil,
    ['sets'] = 'invoker_wyrdling_exaltation',
},



[290313] = 
{
    ['item_id'] =290313,
    ['name'] ='Wyrdwing Exaltation - Wings',
    ['icon'] ='econ/items/invoker/invoker_wings_of_wisdom_back/invoker_wings_of_wisdom_back_style3',
    ['price'] = 1,
    ['HeroModel'] = nil,
    ['ArcanaAnim'] = nil,
    ['MaterialGroup'] = nil,
    ['MaterialGroupItem'] = "2",
    ['ItemModel'] ='models/items/invoker/invoker_wings_of_wisdom_back/invoker_wings_of_wisdom_back.vmdl',
    ['SetItems'] = nil,
    ['hide'] = 1,
    ['OtherItemsBundle'] = {{29031, "#724d85"}, {290311, "#1c71c7"}, {290312, "#c465f0"}, {290313, "#d47719"}},
    ['SlotType'] = 'back',
    ['RemoveDefaultItemsList'] = nil,
    ['Modifier'] = nil,
    ['sets'] = 'invoker_wyrdling_exaltation',
    ['ParticlesItems'] = 
    {
        {
            ['ParticleName'] = 'particles/econ/items/invoker/invoker_crownfall/invoker_crownfall_wings_ambient_orange.vpcf',
            ['DefaultPattch'] = PATTACH_ABSORIGIN_FOLLOW,
            ['ControllPoints'] = 
            {
                [0] = {"SetParticleControl", "default"},
            }
        }
    },
},
[290263] = 
{
    ['item_id'] =290263,
    ['name'] ='Wyrdwing Exaltation - Arms',
    ['icon'] ='econ/items/invoker/invoker_wings_of_wisdom_arms/invoker_wings_of_wisdom_arms_style3',
    ['price'] = 1,
    ['HeroModel'] = nil,
    ['ArcanaAnim'] = nil,
    ['MaterialGroup'] = nil,
    ['MaterialGroupItem'] = "2",
    ['ItemModel'] ='models/items/invoker/invoker_wings_of_wisdom_arms/invoker_wings_of_wisdom_arms.vmdl',
    ['SetItems'] = nil,
    ['hide'] = 1,
    ['OtherItemsBundle'] = {{29026, "#724d85"}, {290261, "#1c71c7"}, {290262, "#c465f0"}, {290263, "#d47719"}},
    ['SlotType'] = 'arms',
    ['RemoveDefaultItemsList'] = nil,
    ['Modifier'] = nil,
    ['sets'] = 'invoker_wyrdling_exaltation',
},
[290283] = 
{
    ['item_id'] =290283,
    ['name'] ='Wyrdwing Exaltation - Head',
    ['icon'] ='econ/items/invoker/invoker_wings_of_wisdom_head/invoker_wings_of_wisdom_head_style3',
    ['price'] = 1,
    ['HeroModel'] = nil,
    ['ArcanaAnim'] = nil,
    ['MaterialGroup'] = nil,
    ['MaterialGroupItem'] = "2",
    ['ItemModel'] ='models/items/invoker/invoker_wings_of_wisdom_head/invoker_wings_of_wisdom_head.vmdl',
    ['SetItems'] = nil,
    ['hide'] = 1,
    ['OtherItemsBundle'] = {{29028, "#724d85"}, {290281, "#1c71c7"}, {290282, "#c465f0"}, {290283, "#d47719"}},
    ['SlotType'] = 'head',
    ['RemoveDefaultItemsList'] = nil,
    ['Modifier'] = nil,
    ['sets'] = 'invoker_wyrdling_exaltation',
},
[290293] = 
{
    ['item_id'] =290293,
    ['name'] ='Wyrdwing Exaltation - Shoulder',
    ['icon'] ='econ/items/invoker/invoker_wings_of_wisdom_shoulder/invoker_wings_of_wisdom_shoulder_style3',
    ['price'] = 1,
    ['HeroModel'] = nil,
    ['ArcanaAnim'] = nil,
    ['MaterialGroup'] = nil,
    ['ItemModel'] ='models/items/invoker/invoker_wings_of_wisdom_shoulder/invoker_wings_of_knowledge_shoulder_alt2.vmdl',
    ['SetItems'] = nil,
    ['hide'] = 1,
    ['OtherItemsBundle'] = {{29029, "#724d85"}, {290291, "#1c71c7"}, {290292, "#c465f0"}, {290293, "#d47719"}},
    ['SlotType'] = 'shoulder',
    ['RemoveDefaultItemsList'] = nil,
    ['Modifier'] = nil,
    ['sets'] = 'invoker_wyrdling_exaltation',
    ['ParticlesItems'] = 
    {
        {
            ['ParticleName'] = "particles/econ/items/invoker/invoker_crownfall/invoker_crownfall_back_ambient_orange.vpcf",
            ['DefaultPattch'] = PATTACH_ABSORIGIN_FOLLOW,
            ['ControllPoints'] = 
            {
                [4] = 
                {
                    'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                    "attach_gem_fx",
                },
                [5] = 
                {
                    'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                    "attach_gem_fx1",
                },
                [6] = 
                {
                    'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                    "attach_gem_fx2",
                },
                [7] = 
                {
                    'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                    "attach_gem_fx3",
                },
                [8] = 
                {
                    'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                    "attach_gem_fx4",
                },
            }
        }
    },
},
[288593] = 
{
    ['item_id'] =288593,
    ['name'] ='Wyrdwing Exaltation - Belt',
    ['icon'] ='econ/items/invoker/invoker_wings_of_wisdom_belt/invoker_wings_of_wisdom_belt_style3',
    ['price'] = 1,
    ['HeroModel'] = nil,
    ['ArcanaAnim'] = nil,
    ['MaterialGroup'] = nil,
    ['MaterialGroupItem'] = "2",
    ['ItemModel'] ='models/items/invoker/invoker_wings_of_wisdom_belt/invoker_wings_of_wisdom_belt.vmdl',
    ['SetItems'] = nil,
    ['hide'] = 1,
    ['OtherItemsBundle'] = {{28859, "#724d85"}, {288591, "#1c71c7"}, {288592, "#c465f0"}, {288593, "#d47719"}},
    ['SlotType'] = 'belt',
    ['RemoveDefaultItemsList'] = nil,
    ['Modifier'] = nil,
    ['sets'] = 'invoker_wyrdling_exaltation',
},

    [13042] = 
    {
        ['item_id'] = 13042,
        ['name'] = "Acolyte of the Lost Arts",
        ['icon'] = "econ/heroes/invoker_kid/invoker_kid_persona",
        ['price'] = 15000,
        ['sale'] = 0,
        ['sale_price'] = 0,
        ['HeroModel'] = "models/heroes/invoker_kid/invoker_kid.vmdl",
        ['ArcanaAnim'] = nil,
        ['MaterialGroup'] = nil,
        ['ItemModel'] = nil,
        ['SetItems'] = nil,
        ['hide'] = 0,
        ['OtherItemsBundle'] = nil,
        ['SlotType'] = 'hero_base',
        ['RemoveDefaultItemsList'] = nil,
        ['Modifier'] = "modifier_invoker_persona_1",
        ['sets'] = 'invoker_persona',
        ['persona'] = 1,
        ['is_exclusive'] = 1,
        ["ParticlesSkills"] =
        {
            "particles/units/heroes/hero_invoker_kid/invoker_kid_exort_orb.vpcf",
            "particles/units/heroes/hero_invoker_kid/invoker_kid_wex_orb.vpcf",
            "particles/units/heroes/hero_invoker_kid/invoker_kid_quas_orb.vpcf",
            "particles/units/heroes/hero_invoker_kid/invoker_kid_forge_spirit_ambient.vpcf",
            "models/heroes/invoker_kid/invoker_kid_trainer_dragon.vmdl",
            "particles/units/heroes/hero_invoker_kid/invoker_kid_forged_spirit_projectile.vpcf",
            "particles/units/heroes/hero_invoker_kid/invoker_kid_base_attack_all.vpcf",
            "particles/units/heroes/hero_invoker_kid/invoker_kid_base_attack_exort.vpcf",
            "particles/units/heroes/hero_invoker_kid/invoker_kid_base_attack_quas.vpcf",
            "particles/units/heroes/hero_invoker_kid/invoker_kid_base_attack_wex.vpcf",
        },
        ["OtherModelsPrecache"] =
        {
            "models/heroes/invoker_kid/invoker_kid_hair.vmdl",
            "models/heroes/invoker_kid/invoker_kid_shoulder.vmdl",
            "models/heroes/invoker_kid/invoker_kid_cape.vmdl",
            "models/heroes/invoker_kid/invoker_kid_sleeves.vmdl",
        },
    },
    [21836] = 
    {
        ['item_id'] = 21836,
        ['name'] = "Dark Artistry Throwback",
        ['icon'] = "econ/sets/DOTA_Item_Dark_Artistry_Kid",
        ['price'] = 1000,
        ['sale'] = 0,
        ['sale_price'] = 0,
        ['HeroModel'] = "models/heroes/invoker_kid/invoker_kid.vmdl",
        ['ArcanaAnim'] = nil,
        ['MaterialGroup'] = nil,
        ['ItemModel'] = nil,
        ['SetItems'] = nil,
        ['hide'] = 0,
        ['OtherItemsBundle'] = nil,
        ['SlotType'] = 'hero_base',
        ['RemoveDefaultItemsList'] = nil,
        ['Modifier'] = "modifier_invoker_persona_2",
        ['sets'] = 'invoker_persona',
        ['persona'] = 2,
        ['is_exclusive'] = 1,
        ["ParticlesSkills"] =
        {
            "particles/units/heroes/hero_invoker_kid/invoker_kid_exort_orb.vpcf",
            "particles/units/heroes/hero_invoker_kid/invoker_kid_wex_orb.vpcf",
            "particles/units/heroes/hero_invoker_kid/invoker_kid_quas_orb.vpcf",
            "particles/units/heroes/hero_invoker_kid/invoker_kid_forge_spirit_ambient.vpcf",
            "models/heroes/invoker_kid/invoker_kid_trainer_dragon.vmdl",
            "particles/units/heroes/hero_invoker_kid/invoker_kid_forged_spirit_projectile.vpcf",
            "particles/econ/items/invoker/invoker_ti6/invoker_tornado_child_ti6.vpcf",
            "particles/econ/items/invoker_kid/invoker_dark_artistry/invoker_kid_dark_artistry_wex_orb.vpcf",
            "particles/econ/items/invoker_kid/invoker_dark_artistry/invoker_kid_dark_artistry_quas_orb.vpcf",
            "particles/econ/items/invoker_kid/invoker_dark_artistry/invoker_kid_dark_artistry_exort_orb.vpcf",
            "particles/units/heroes/hero_invoker_kid/invoker_kid_base_attack_all.vpcf",
            "particles/units/heroes/hero_invoker_kid/invoker_kid_base_attack_exort.vpcf",
            "particles/units/heroes/hero_invoker_kid/invoker_kid_base_attack_quas.vpcf",
            "particles/units/heroes/hero_invoker_kid/invoker_kid_base_attack_wex.vpcf",
            "particles/econ/items/invoker_kid/invoker_dark_artistry/invoker_kid_dark_artistry_cape_ambient.vpcf"
        },
        ["OtherModelsPrecache"] =
        {
            "models/items/invoker_kid/dark_artistry_kid/invoker_kid_dark_artistry_arms.vmdl",
            "models/items/invoker_kid/dark_artistry_kid/invoker_kid_dark_artistry_back.vmdl",
            "models/items/invoker_kid/dark_artistry_kid/invoker_kid_dark_artistry_head.vmdl",
            "models/items/invoker_kid/dark_artistry_kid/invoker_kid_dark_artistry_shoulder.vmdl",
            "models/items/invoker_kid/dark_artistry_kid/invoker_kid_dark_artistry_armor.vmdl",
        },
    },
    [25513] = 
    {
        ['item_id'] = 25513,
        ['name'] = "Angel of Vex",
        ['icon'] = "econ/sets/DOTA_Item_Angel_of_Vex",
        ['price'] = 1000,
        ['sale'] = 0,
        ['sale_price'] = 0,
        ['HeroModel'] = "models/heroes/invoker_kid/invoker_kid.vmdl",
        ['ArcanaAnim'] = nil,
        ['MaterialGroup'] = nil,
        ['ItemModel'] = nil,
        ['SetItems'] = nil,
        ['hide'] = 0,
        ['OtherItemsBundle'] = nil,
        ['SlotType'] = 'hero_base',
        ['RemoveDefaultItemsList'] = nil,
        ['Modifier'] = "modifier_invoker_persona_3",
        ['sets'] = 'invoker_persona',
        ['persona'] = 3,
        ['is_exclusive'] = 1,
        ["ParticlesSkills"] =
        {
            "particles/units/heroes/hero_invoker_kid/invoker_kid_exort_orb.vpcf",
            "particles/units/heroes/hero_invoker_kid/invoker_kid_wex_orb.vpcf",
            "particles/units/heroes/hero_invoker_kid/invoker_kid_quas_orb.vpcf",
            "particles/units/heroes/hero_invoker_kid/invoker_kid_forge_spirit_ambient.vpcf",
            "models/heroes/invoker_kid/invoker_kid_trainer_dragon.vmdl",
            "particles/units/heroes/hero_invoker_kid/invoker_kid_forged_spirit_projectile.vpcf",
            "particles/units/heroes/hero_invoker_kid/invoker_kid_base_attack_all.vpcf",
            "particles/units/heroes/hero_invoker_kid/invoker_kid_base_attack_exort.vpcf",
            "particles/units/heroes/hero_invoker_kid/invoker_kid_base_attack_quas.vpcf",
            "particles/units/heroes/hero_invoker_kid/invoker_kid_base_attack_wex.vpcf",
            "particles/econ/items/invoker_kid/kid_invoker_psychokinesis/invoker_kid_psychokinesis_armor.vpcf",
            "particles/econ/items/invoker_kid/kid_invoker_psychokinesis/invoker_kid_psychokinesis_head.vpcf",
        },
        ["OtherModelsPrecache"] =
        {
            "models/items/invoker/invoker_arrow_of_psychokinesis_armor_persona_1/invoker_arrow_of_psychokinesis_armor_persona_1.vmdl", 
            "models/items/invoker/invoker_arrow_of_psychokinesis_arms_persona_1/invoker_arrow_of_psychokinesis_arms_persona_1.vmdl",
            "models/items/invoker/invoker_arrow_of_psychokinesis_head_persona_1/invoker_arrow_of_psychokinesis_head_persona_1.vmdl",
            "models/items/invoker/invoker_arrow_of_psychokinesis_shoulder_persona_1/invoker_arrow_of_psychokinesis_shoulder_persona_1.vmdl",
            "models/items/invoker/invoker_arrow_of_psychokinesis_back_persona_1/invoker_arrow_of_psychokinesis_back_persona_1.vmdl",
        },
    },
    [23257] = 
    {
        ['item_id'] = 23257,
        ['name'] = "Heir of Menace",
        ['icon'] = "econ/loading_screens/the_little_king_ls",
        ['price'] = 1000,
        ['sale'] = 0,
        ['sale_price'] = 0,
        ['HeroModel'] = "models/heroes/invoker_kid/invoker_kid.vmdl",
        ['ArcanaAnim'] = nil,
        ['MaterialGroup'] = nil,
        ['ItemModel'] = nil,
        ['SetItems'] = nil,
        ['hide'] = 0,
        ['OtherItemsBundle'] = nil,
        ['SlotType'] = 'hero_base',
        ['RemoveDefaultItemsList'] = nil,
        ['Modifier'] = "modifier_invoker_persona_4",
        ['sets'] = 'invoker_persona',
        ['persona'] = 4,
        ['is_exclusive'] = 1,
        ["ParticlesSkills"] =
        {
            "particles/units/heroes/hero_invoker_kid/invoker_kid_exort_orb.vpcf",
            "particles/units/heroes/hero_invoker_kid/invoker_kid_wex_orb.vpcf",
            "particles/units/heroes/hero_invoker_kid/invoker_kid_quas_orb.vpcf",
            "particles/units/heroes/hero_invoker_kid/invoker_kid_forge_spirit_ambient.vpcf",
            "models/heroes/invoker_kid/invoker_kid_trainer_dragon.vmdl",
            "particles/units/heroes/hero_invoker_kid/invoker_kid_forged_spirit_projectile.vpcf",
            "particles/units/heroes/hero_invoker_kid/invoker_kid_base_attack_all.vpcf",
            "particles/units/heroes/hero_invoker_kid/invoker_kid_base_attack_exort.vpcf",
            "particles/units/heroes/hero_invoker_kid/invoker_kid_base_attack_quas.vpcf",
            "particles/units/heroes/hero_invoker_kid/invoker_kid_base_attack_wex.vpcf",
        },
        ["OtherModelsPrecache"] =
        {
            "models/items/invoker/the_little_king_armor/the_little_king_armor.vmdl",
            "models/items/invoker/the_little_king_arms/the_little_king_arms.vmdl",
            "models/items/invoker/the_little_king_back/the_little_king_back.vmdl",
            "models/items/invoker/the_little_king_head/the_little_king_head.vmdl",
        },
    },
    [30575] = 
    {
        ['item_id'] = 30575,
        ['name'] = "Magus Mimicry",
        ['icon'] = "econ/sets/DOTA_Item_Magus_Mimicry",
        ['price'] = 1000,
        ['sale'] = 0,
        ['sale_price'] = 0,
        ['HeroModel'] = "models/heroes/invoker_kid/invoker_kid.vmdl",
        ['ArcanaAnim'] = nil,
        ['MaterialGroup'] = nil,
        ['ItemModel'] = nil,
        ['SetItems'] = nil,
        ['hide'] = 0,
        ['OtherItemsBundle'] = nil,
        ['SlotType'] = 'hero_base',
        ['RemoveDefaultItemsList'] = nil,
        ['Modifier'] = "modifier_invoker_persona_5",
        ['sets'] = 'invoker_persona',
        ['persona'] = 5,
        ['is_exclusive'] = 1,
        ["ParticlesSkills"] =
        {
            "particles/units/heroes/hero_invoker_kid/invoker_kid_exort_orb.vpcf",
            "particles/units/heroes/hero_invoker_kid/invoker_kid_wex_orb.vpcf",
            "particles/units/heroes/hero_invoker_kid/invoker_kid_quas_orb.vpcf",
            "particles/units/heroes/hero_invoker_kid/invoker_kid_forge_spirit_ambient.vpcf",
            "models/items/invoker_kid/continuum_echoes_forge_spirit/continuum_echoes_forge_spirit.vmdl",
            "models/heroes/invoker_kid/invoker_kid_trainer_dragon.vmdl",
            "particles/units/heroes/hero_invoker_kid/invoker_kid_forged_spirit_projectile.vpcf",
            "particles/econ/items/invoker_kid/invoker_cc_2024_echoes/invoker_cc_2024_echoes_armor.vpcf",
            "particles/units/heroes/hero_invoker_kid/invoker_kid_base_attack_all.vpcf",
            "particles/units/heroes/hero_invoker_kid/invoker_kid_base_attack_exort.vpcf",
            "particles/units/heroes/hero_invoker_kid/invoker_kid_base_attack_quas.vpcf",
            "particles/units/heroes/hero_invoker_kid/invoker_kid_base_attack_wex.vpcf",
        },
        ["OtherModelsPrecache"] =
        {
            "models/items/invoker_kid/continuum_echoes_armor/continuum_echoes_armor.vmdl",
            "models/items/invoker_kid/continuum_echoes_arms/continuum_echoes_arms.vmdl",
            "models/items/invoker_kid/continuum_echoes_head/continuum_echoes_head.vmdl",
            "models/items/invoker_kid/continuum_echoes_shoulders/continuum_echoes_shoulders.vmdl",
            "models/items/invoker_kid/continuum_echoes_back/continuum_echoes_back.vmdl",
        },
    },
    [8572] = 
    {
        ['item_id'] =8572,
        ['name'] ='Collar of the Blackguard Magus',
        ['icon'] ='econ/items/invoker/nightlord_head/nightlord_head',
        ['price'] = 600,
        ['HeroModel'] = nil,
        ['ArcanaAnim'] = nil,
        ['MaterialGroup'] = nil,
        ['ItemModel'] ='models/items/invoker/nightlord_head/nightlord_head.vmdl',
        ['SetItems'] = nil,
        ['hide'] = 0,
        ['OtherItemsBundle'] = nil,
        ['SlotType'] = 'head',
        ['RemoveDefaultItemsList'] = nil,
        ['Modifier'] = nil,
        ['sets'] = 'trials_blackguard',
    },
    [8573] = 
    {
        ['item_id'] =8573,
        ['name'] ='Sleeves of the Blackguard Magus',
        ['icon'] ='econ/items/invoker/nightlord_arms/nightlord_arms',
        ['price'] = 600,
        ['HeroModel'] = nil,
        ['ArcanaAnim'] = nil,
        ['MaterialGroup'] = nil,
        ['ItemModel'] ='models/items/invoker/nightlord_arms/nightlord_arms.vmdl',
        ['SetItems'] = nil,
        ['hide'] = 0,
        ['OtherItemsBundle'] = nil,
        ['SlotType'] = 'arms',
        ['RemoveDefaultItemsList'] = nil,
        ['Modifier'] = nil,
        ['sets'] = 'trials_blackguard',
    },
    [8574] = 
    {
        ['item_id'] =8574,
        ['name'] ='Vestments of the Blackguard Magus',
        ['icon'] ='econ/items/invoker/nightlord_belt/nightlord_belt',
        ['price'] = 800,
        ['HeroModel'] = nil,
        ['ArcanaAnim'] = nil,
        ['MaterialGroup'] = nil,
        ['ItemModel'] ='models/items/invoker/nightlord_belt/nightlord_belt.vmdl',
        ['SetItems'] = nil,
        ['hide'] = 0,
        ['OtherItemsBundle'] = nil,
        ['SlotType'] = 'belt',
        ['RemoveDefaultItemsList'] = nil,
        ['Modifier'] = nil,
        ['sets'] = 'trials_blackguard',
    },
    [8575] = 
    {
        ['item_id'] =8575,
        ['name'] ='Mantle of the Blackguard Magus',
        ['icon'] ='econ/items/invoker/nightlord_shoulder/nightlord_shoulder_style1',
        ['price'] = 1000,
        ['HeroModel'] = nil,
        ['ArcanaAnim'] = nil,
        ['MaterialGroup'] = nil,
        ['ItemModel'] ='models/items/invoker/nightlord_shoulder/nightlord_shoulder.vmdl',
        ['SetItems'] = nil,
        ['hide'] = 0,
        ['OtherItemsBundle'] = nil,
        ['SlotType'] = 'shoulder',
        ['RemoveDefaultItemsList'] = nil,
        ['Modifier'] = nil,
        ['sets'] = 'trials_blackguard',
        ['ParticlesItems'] = 
        {
            {
                ['ParticleName'] = "particles/econ/items/invoker/invoker_darklord/invoker_darklord_ambient.vpcf",
                ['DefaultPattch'] = PATTACH_ABSORIGIN_FOLLOW,
                ['ControllPoints'] = 
                {
                    [0] = 
                    {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_gem_front",
                    },
                    [1] = 
                    {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_gem_back",
                    },
                    [2] = 
                    {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_shoulder_l",
                    },
                    [3] = 
                    {
                        'SetParticleControlEnt', PATTACH_POINT_FOLLOW,
                        "attach_shoulder_r",
                    },
                }
            }
        },
    },
    [8597] = 
    {
        ['item_id'] =8597,
        ['name'] ='Cape of the Blackguard Magus',
        ['icon'] ='econ/items/invoker/nightlord_back/nightlord_back',
        ['price'] = 800,
        ['HeroModel'] = nil,
        ['ArcanaAnim'] = nil,
        ['MaterialGroup'] = nil,
        ['ItemModel'] ='models/items/invoker/nightlord_back/nightlord_back.vmdl',
        ['SetItems'] = nil,
        ['hide'] = 0,
        ['OtherItemsBundle'] = nil,
        ['SlotType'] = 'back',
        ['RemoveDefaultItemsList'] = nil,
        ['Modifier'] = nil,
        ['sets'] = 'trials_blackguard',
    },
    [30721] = 
    {
        ['item_id'] = 30721,
        ['name'] = "Urchin of Kazim",
        ['icon'] = "econ/sets/DOTA_Item_Urchin_of_Kazim",
        ['price'] = 1000,
        ['sale'] = 0,
        ['sale_price'] = 0,
        ['HeroModel'] = "models/heroes/invoker_kid/invoker_kid.vmdl",
        ['ArcanaAnim'] = nil,
        ['MaterialGroup'] = nil,
        ['ItemModel'] = nil,
        ['SetItems'] = nil,
        ['hide'] = 0,
        ['OtherItemsBundle'] = nil,
        ['SlotType'] = 'hero_base',
        ['RemoveDefaultItemsList'] = nil,
        ['Modifier'] = "modifier_invoker_persona_6",
        ['sets'] = 'invoker_persona',
        ['persona'] = 5,
        ['is_exclusive'] = 1,
        ["ParticlesSkills"] =
        {
            "particles/units/heroes/hero_invoker_kid/invoker_kid_exort_orb.vpcf",
            "particles/units/heroes/hero_invoker_kid/invoker_kid_wex_orb.vpcf",
            "particles/units/heroes/hero_invoker_kid/invoker_kid_quas_orb.vpcf",
            "particles/units/heroes/hero_invoker_kid/invoker_kid_forge_spirit_ambient.vpcf",
            "models/items/invoker_kid/continuum_echoes_forge_spirit/continuum_echoes_forge_spirit.vmdl",
            "models/heroes/invoker_kid/invoker_kid_trainer_dragon.vmdl",
            "particles/units/heroes/hero_invoker_kid/invoker_kid_forged_spirit_projectile.vpcf",
            "particles/econ/items/invoker_kid/invoker_cc_2024_echoes/invoker_cc_2024_echoes_armor.vpcf",
            "particles/units/heroes/hero_invoker_kid/invoker_kid_base_attack_all.vpcf",
            "particles/units/heroes/hero_invoker_kid/invoker_kid_base_attack_exort.vpcf",
            "particles/units/heroes/hero_invoker_kid/invoker_kid_base_attack_quas.vpcf",
            "particles/units/heroes/hero_invoker_kid/invoker_kid_base_attack_wex.vpcf",
            "models/items/invoker_kid/the_little_thief_of_kazim_forge_spirit_red/the_little_thief_of_kazim_forge_spirit_red.vmdl",
        },
        ["OtherModelsPrecache"] =
        {
            "models/items/invoker_kid/the_little_thief_of_kazim_armor_blue/the_little_thief_of_kazim_armor_blue.vmdl",
            "models/items/invoker_kid/the_little_thief_of_kazim_arms_blue/the_little_thief_of_kazim_arms_blue.vmdl",
            "models/items/invoker_kid/the_little_thief_of_kazim_back_blue/the_little_thief_of_kazim_back_blue.vmdl",
            "models/items/invoker_kid/the_little_thief_of_kazim_head_blue/the_little_thief_of_kazim_head_blue.vmdl",
            "models/items/invoker_kid/the_little_thief_of_kazim_shoulder_blue/the_little_thief_of_kazim_shoulder_blue.vmdl",
            "models/items/invoker_kid/the_little_thief_of_kazim_forge_spirit_red/the_little_thief_of_kazim_forge_spirit_red.vmdl",
        },
    },
}