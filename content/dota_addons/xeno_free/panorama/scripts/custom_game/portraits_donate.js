var portrait_video_kill_cam = null
var selected_portrait = null
var killer_name = null
var similar_id = 
{
    4239: [4239, 4560, 4561],
    23097: [23097, 2309799],
    23096: [23096, 2309699],
    9784: [9784, 978499, 9784999], 
    9780: [9780, 978099, 9780999], 
}

var first_timer_loading = -1
var first_timer_loading_killcam = -1
var last_hero_entity_camera_portrait = null
var last_hero_entity_camera_kill_cam = null

var unique_cameras_heroes_items = 
{
    "npc_dota_hero_juggernaut" :
    [
        [2059, 2111],
        [2059, 4484],
        [2059, 2096],
        [2059, 2105],
        [2059, 2098],
        [2059, 4504],
        [2059, 4505],
        [2059, 2097],
        [2068, 2111],
        [2068, 4484],
        [2068, 2096],
        [2068, 2105],
        [2068, 2098],
        [2068, 4504],
        [2068, 4505],
        [2068, 2097],
        [4482],
        [2040],
        [2049],
        [2052],
        [2064],
        [2067],
        [4507],
        [4508],
        [2059],
        [2068],
    ],
    "npc_dota_hero_phantom_assassin" :
    [
        [4480],
        [4239, 3357, 3379],
        [4239, 3357, 3384],
        [4239, 3357, 3369],
        [4239, 3357, 4492],
        [4239, 3357, 4488],
        [4239, 3379, 3367],
        [4239, 3379, 4491],
        [4239, 3379, 4487],
        [4239, 3384, 3367],
        [4239, 3384, 4491],
        [4239, 3384, 4487],
        [3357, 3379],
        [3357, 3384],
        [3357, 3369],
        [3357, 4492],
        [3357, 4488],
        [3379, 3367],
        [3379, 4491],
        [3379, 4487],
        [3384, 3367],
        [3384, 4491],
        [3384, 4487],
        [4239, 3367],
        [4239, 4487],
        [4239, 4491],
        [4239, 3357],
        [4239, 3379],
        [4239, 3384],
        [3367],
        [4487],
        [4491],
        [3357],
        [3379],
        [3384],
        [4239],
    ],
    "npc_dota_hero_huskar" :
    [
        [2428, 2414],
        [2428, 2404],
        [2428, 22404],
        [2404, 2429],
        [2404, 2431],
        [2404, 2426],
        [2414, 2429],
        [2414, 2431],
        [2414, 2426],
        [22404, 2429],
        [22404, 2431],
        [22404, 2426],
        [2402],
        [2417],
        [5872],
        [2414],
        [2404],
        [22404],
        [4494],
        [2428],
    ],

    "npc_dota_hero_legion_commander":
    [

        [5810, 9236, 8821],
        [5810, 9236, 13052],
        [5810, 9236, 13986],
        [5810, 9236, 25759],
        [5810, 9236, 29256],
        [5810, 9236, 9780],
        [5810, 9236],
        [5810, 8824],
        [5810, 13050],
        [5810, 13988],
        [5810, 25761],
        [5810, 29254],
        [5810, 9784],
        [9236, 8821],
        [9236, 13052],
        [9236, 13986],
        [9236, 25759],
        [9236, 29256],
        [9236, 9780],
        [9784],
        [5810],
        [9236],
        [8824],
        [13050],
        [13988],
        [25761],
        [29254],
    ],

    "npc_dota_hero_nevermore":
    [
        [6996, 9020],
        [6996, 22844],
        [6996, 12677],
        [6996, 13507],
        [6996, 18036],
        [6996, 8259],
        [9021],
        [18035],
        [22845],
        [12678],
        [13505],
        [6996],
        [8259],
    ],

    "npc_dota_hero_razor":
    [
      //  [2309599, 6646, 14812],
     //   [2309599, 6646, 18132],
     //   [2309599, 6646, 19500],
    //    [2309599, 6646, 23097],
    //    [2309599, 6916, 14812],
      //  [2309599, 6916, 18132],
      //  [2309599, 6916, 19500],
     //   [2309599, 6916, 23097],
        [2309599, 14814],
        [2309599, 18130],
        [2309599, 19503],
        [2309599, 23096],
        [2309599, 6646],
        [2309599, 6916],
      //  [23095, 6646, 14812],
      //  [23095, 6646, 18132],
      //  [23095, 6646, 19500],
      //  [23095, 6646, 23097],
      //  [23095, 6916, 14812],
       // [23095, 6916, 18132],
      //  [23095, 6916, 19500],
     //   [23095, 6916, 23097],
        [23095, 14814],
        [23095, 18130],
        [23095, 19503],
        [23095, 23096],
        [23095, 6646],
        [23095, 6916],
       // [6916, 14812],
       // [6916, 18132],
       // [6916, 19500],
       // [6916, 23097],
       // [6646, 14812],
       // [6646, 18132],
       // [6646, 19500],
       // [6646, 23097],
        [23095],
        [2309599],
        [14814],
        [18130],
        [19503],
        [23096],
        [6646],
        [6916]
    ]
}

var allow_camera_change =
{
    "npc_dota_hero_juggernaut" : true,
    "npc_dota_hero_phantom_assassin" : true,
    "npc_dota_hero_huskar" : true,
    "npc_dota_hero_razor" : true,
    "npc_dota_hero_nevermore" : true,
    "npc_dota_hero_legion_commander" : true,
}

var portraits_panels = {}

function Think()
{
	UpdateMainHudHero()
    $.Schedule(1/144, Think)
}

function UpdateMainHudHero(fast)
{
    let hero_current = Entities.GetUnitName( Players.GetLocalPlayerPortraitUnit() )
    let portraitHUDOverlay = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("portraitHUDOverlay");

    if ( (selected_portrait != hero_current) || fast)
    {
        if (allow_camera_change[hero_current] == null)
        {
            for (var i = 0; i <= Object.keys(portraits_panels).length; i++) 
            {
                if (portraits_panels[Object.keys(portraits_panels)[i]])
                {
                    portraits_panels[Object.keys(portraits_panels)[i]].style.visibility = "collapse"
                }
            }
        } 
        else
        {
            for (var i = 0; i <= Object.keys(portraits_panels).length; i++) 
            {
                if (portraits_panels[Object.keys(portraits_panels)[i]])
                {
                    portraits_panels[Object.keys(portraits_panels)[i]].style.visibility = "collapse"
                }
            }
            let player_id = Entities.GetPlayerOwnerID( Players.GetLocalPlayerPortraitUnit() )
            let camera_info = GetCameraInfo(hero_current, player_id)
            ChangeCamera(camera_info[0], camera_info[1], portraits_panels[hero_current], hero_current)  
        }
    }

    if (portraits_panels[hero_current] != null)
    {
        if (Entities.IsHexed( Players.GetLocalPlayerPortraitUnit() ))
        {
            portraits_panels[hero_current].style.visibility = "collapse"
        }
        else
        {
            portraits_panels[hero_current].style.visibility = "visible"
        }
        if (portraitHUDOverlay)
        {
            portraitHUDOverlay.style.visibility = "collapse"
        }
    }
    else
    {
        if (portraitHUDOverlay)
        {
            portraitHUDOverlay.style.visibility = "visible"
        }
    }

    selected_portrait = hero_current
}
 
function ChangeCamera(camera_name, light_name, scene_panel, hero_name)
{


    let dotahud = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("portraitHUD");
    
    if (scene_panel == null)
    {
        let portrait_video = $.CreatePanel("DOTAScenePanel", dotahud, "portrait_donate_hero", { class:"portrait_donate_hero", style: "width:100px;height:100px;", map: "portraits/"+hero_name, light:light_name, particleonly:"false", camera: camera_name, renderdeferred:"false", antialias:"false", renderwaterreflections:"false", deferredalpha:"false", environment:"default" })
        portrait_video.style.width = "143px"
        portrait_video.style.height = "175px"
        portrait_video.style.marginLeft = "14px"
        portraits_panels[hero_name] = portrait_video

        $.RegisterEventHandler("DOTAScenePanelSceneLoaded", portraits_panels[hero_name], function() 
        {
            $.Schedule(0.2, function () 
            {
                RemovedTimer()
                UpdateMainHudHero(true)
            });
        });
        
        ChangeUnitCamera(camera_name, hero_name)
    }
    else
    {
        scene_panel.style.visibility = "visible"
        scene_panel.LerpToCameraEntity( camera_name, 0 )
        $.Schedule(0.1, function()
        { 
            last_hero_entity_camera_portrait = camera_name + "_unit"
            scene_panel.FireEntityInput(last_hero_entity_camera_portrait, "Enable", "", 0.0);   
        }) 
    }
}
 
function ChangeUnitCamera(camera_name, hero_name)
{
    first_timer_loading = $.Schedule(0.1, function ()
    {
        first_timer_loading = -1
        last_hero_entity_camera_portrait = camera_name + "_unit"
        portraits_panels[hero_name].FireEntityInput(last_hero_entity_camera_portrait, "Enable", "", 0.0);
        ChangeUnitCamera(camera_name, hero_name)
    })
}

function RemovedTimer()
{
    if (first_timer_loading != -1)
    {
        $.CancelScheduled(first_timer_loading)
        first_timer_loading = -1
    }
}

function GetCameraInfo(hero_name, player_id)
{
    let camera_name = hero_name
    let light_name = hero_name + "_light"
    let heroes_items = GetHeroesItems(player_id, hero_name)

    if (unique_cameras_heroes_items[hero_name] != null)
    {
        for (var i = 0; i < Object.keys(unique_cameras_heroes_items[hero_name]).length; i++) 
        {
            let has_this_list = true
            let item_id_list = unique_cameras_heroes_items[hero_name][i]
            for (var d = 0; d < item_id_list.length; d++) 
            {
                if (similar_id[item_id_list[d]] != null)
                {
                    let has_double_check_item = false
                    for (var j = 0; j < Object.keys(similar_id[item_id_list[d]]).length; j++) 
                    {
                        if (heroes_items[similar_id[item_id_list[d]][j]] != null)
                        {
                            has_double_check_item = true
                        }
                    }
                    if (!has_double_check_item)
                    {
                        has_this_list = false
                    }
                }
                else
                {
                    if (heroes_items[item_id_list[d]] == null)
                    {
                        has_this_list = false
                    }
                }
            }
            if (has_this_list)
            {   
                for (var d = 0; d < item_id_list.length; d++) 
                {
                    camera_name = camera_name + "_" + item_id_list[d]
                    light_name = light_name + "_" + item_id_list[d]
                }
                break
            }
        }
    }

    return [camera_name, light_name]
}

function GetHeroesItems(player_id, hero)
{
    let fast_table = {}
	let player_table = CustomNetTables.GetTableValue("heroes_items_info", "portrait_items_" + String(player_id));
	if (player_table)
	{
        for (var i = 1; i <= Object.keys(player_table).length; i++) 
        {
            fast_table[player_table[i]] = true
        }
	}
    return fast_table
}

CustomNetTables.SubscribeNetTableListener( "heroes_items_info", UpdateSubDataPortraits );

function UpdateSubDataPortraits(table, key, data ) 
{
	if (table == "heroes_items_info") 
	{
		if (key == "portrait_items_"+Players.GetLocalPlayer()) 
        {
            let player_id = Entities.GetPlayerOwnerID( Players.GetLocalPlayerPortraitUnit() )
            if (player_id == Players.GetLocalPlayer())
            {
                let hero_name = Entities.GetUnitName( Players.GetLocalPlayerPortraitUnit())
                let camera_info = GetCameraInfo(hero_name, player_id)
                ChangeCamera(camera_info[0], camera_info[1], portraits_panels[hero_name], hero_name)
            }
		}
	}
}

function UpdateKillCam(data)
{
    var KillCam = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("KillCam");
    if (KillCam)
    {
        let KillCamHeroImageOrMovie = KillCam.FindChildTraverse("KillCamHeroImageOrMovie")
        if (KillCamHeroImageOrMovie)
        {
            let KillCamHeroRender = KillCamHeroImageOrMovie.GetChild(0)
            if (KillCamHeroRender)  
            { 
                ChangeKillCamCamera(data, KillCamHeroRender)
            }
        }
    }
}

function ChangeKillCamCamera(data, KillCamHeroRender, hero_name)
{
    let portrait_donate_hero = KillCamHeroRender.FindChildTraverse("portrait_donate_hero")
    if (data && data.heroname != null)
    {
        let hero_name = data.heroname
        let player_id = data.id
        let camera_info = GetCameraInfo(hero_name, player_id)
        let camera_name = camera_info[0]
        let camera_light = camera_info[1]
        if (portrait_donate_hero != null)
        {
            portrait_donate_hero.DeleteAsync(0)
            portrait_video_kill_cam = null
        }
        if (portrait_video_kill_cam == null)
        { 
            portrait_video_kill_cam = $.CreatePanel("DOTAScenePanel", KillCamHeroRender, "portrait_donate_hero", { class:"portrait_donate_hero", style: "width:100px;height:100px;", map: "portraits/"+hero_name, light: camera_light, particleonly:"false", camera: camera_name, renderdeferred:"false", antialias:"false", renderwaterreflections:"false" });
            portrait_video_kill_cam.style.width = "100%"
            portrait_video_kill_cam.style.height = "100%"
            portrait_video_kill_cam.style.visibility = "visible"
            $.RegisterEventHandler("DOTAScenePanelSceneLoaded", portrait_video_kill_cam, function () 
            {
                $.Schedule(0.2, function () 
                {
                    RemovedTimerKillCam()
                });
            });
            ChangeUnitCameraKillCam(camera_name)
        }
        else
        {
            let hero_name = data.heroname
            let player_id = data.id
            let camera_info = GetCameraInfo(hero_name, player_id)
            let camera_name = camera_info[0]
            let camera_light = camera_info[1]
            portrait_video_kill_cam.style.visibility = "visible"
            portrait_video_kill_cam.LerpToCameraEntity( camera_name, 0 )
            $.Schedule(0.1, function()
            { 

                last_hero_entity_camera_kill_cam = camera_name + "_unit"
                portrait_video_kill_cam.FireEntityInput(last_hero_entity_camera_kill_cam, "Enable", "", 0.0);   
            })
        }
    }
    else if (data == null || (data && data.heroname == null))
    {
        if (portrait_video_kill_cam != null)
        {
            portrait_donate_hero.DeleteAsync(0)
            portrait_video_kill_cam = null
        }
    }
}

CustomNetTables.SubscribeNetTableListener( "heroes_donate_portraits", UpdateKillCamData );

function UpdateKillCamData(table, key, data ) 
{
	if (table == "heroes_donate_portraits") 
	{
		if (key == "killer_" + Players.GetLocalPlayer()) 
        {
            UpdateKillCam(data)
		}
	}
} 

function RemovedTimerKillCam()
{
    if (first_timer_loading_killcam != -1)
    {
        $.CancelScheduled(first_timer_loading_killcam)
        first_timer_loading_killcam = -1
    }
}

function ChangeUnitCameraKillCam(camera_name)
{
    first_timer_loading_killcam = $.Schedule(0.1, function ()
    {
        first_timer_loading_killcam = -1
        last_hero_entity_camera_kill_cam = camera_name + "_unit"
        portrait_video_kill_cam.FireEntityInput(last_hero_entity_camera_kill_cam, "Enable", "", 0.0);    
        ChangeUnitCameraKillCam(camera_name)
    })
}
 
Think()