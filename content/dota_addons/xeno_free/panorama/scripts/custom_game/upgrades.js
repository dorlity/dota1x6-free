var dotaHud = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("AbilitiesAndStatBranch");
$.GetContextPanel().SetParent(dotaHud.FindChildrenWithClassTraverse("LeftRightFlow")[0]);

var dotaH = $.GetContextPanel().GetParent().GetParent().GetParent().GetParent().GetParent().GetParent()
var dota_neutral_shop_window = dotaH.FindChildTraverse("GridNeutralsCategory")
dota_neutral_shop_window.style.overflow = "squish scroll";


dotaHud.FindChildrenWithClassTraverse("LeftRightFlow")[0].MoveChildBefore($.GetContextPanel(),dotaHud.FindChildTraverse("StatBranch"))


Hack()


//rating1()

//rating()

function rating()
{

let players = [0,5000,0,0,0,0,0]
let player = 1

let place = 4 

let r_summ = 0

for (var i = 0; i <= 6; i++)
{
	r_summ = r_summ + players[i]
}

let avg = r_summ/6
avg = 1200



let ratings = [0, 40, 30, 10, -10, -30, -40]
let ratings_max = [0, 20,15,5,-5,-15,-20]



let rating_diff = players[player] / avg

let k = 0
let change = ratings[place]


if ((rating_diff) > 1.5 && (players[player] > 2000))
{ 

	k = (rating_diff*rating_diff)/20
	if (place <= 3)
	{ 
		change = Math.max((ratings[place] - ratings[place]*k),ratings_max[place])
	}
	else 
	{
		change = ratings[place] + ratings[place]*k
	}
	
}

if (rating_diff < 0.7 )
{ 

	k = 1/(20*rating_diff*rating_diff)
	if (place <= 3)
	{ 
		change = (ratings[place] + ratings[place]*k)
	}
	else 
	{
		change = Math.min((ratings[place] - ratings[place]*k),ratings_max[place])
	}
	
}


$.Msg(players[player],' ',Math.floor(avg),' ',rating_diff,' ---- ',change)

}



function median(values){
  values = [...values].sort(function(a,b){
    return a-b;
  })

  var half = Math.floor(values.length / 2)
  
  if (values.length % 2)
    return values[half]
  
  return (values[half - 1] + values[half]) / 2
}

function rating1()
{
	let players_rating = [1500,2000,2000,1250,750,1750]
	let self_id = 1
	let avg = (players_rating[0] + players_rating[1] + players_rating[2] + players_rating[3] + players_rating[4] + players_rating[5])/6

	let places = [-40,-30,-10,10,30,40]
	let p = 5

	$.Msg(players_rating[self_id],' ',median(players_rating),' ', places[p]*Math.min(Math.max(median(players_rating)/players_rating[self_id],0.25),2))
}


ma()
function ma()
{

let h = []

h[1] = 0
h[2] = 0

let n = 0
let n2 = 0

let timer = 20
let timer2 = 20



$.Msg('--------------------------------')

for (var i = 1; i < 30; i++)
{


	if (i > 1)
	{
		timer = 70
		timer2 = 70
	}

	if (i >= 6)
	{
		timer = 120
	}	

	if (i >= 6)
	{
		timer2 = 120
	}

	if (i >= 16)
	{
		timer = 180

	}
	if (i >= 14)
	{
		timer2 = 180

	}

	if (i >= 21)
	{
		timer = 180
	}

	if (i >= 21)
	{
		timer2 = 180
	}


	n = n + timer
	n2 = n2 + timer2

	let min1 = Math.floor(n/60)
	let sec1 = n - min1 * 60

	let min2 = Math.floor(n2/60)
	let sec2 = n2 - min2 * 60

	$.Msg(i,' ',min1,':',sec1,' --- ',min2,':',sec2,)

}



}


function ma_3()
{

let h = []

h[1] = 0
h[2] = 0

let n = 1.02
let n2 = 0


let wave1 = 20
let wave2 = 20

let time1 = 0
let time2 = 0

let min1 = 0
let sec1 = 0


let damage1 = 44
let health1 = 720

let damage_up1 = 1
let health_up1 = 1


let damage2 = 44
let health2 = 720

let damage_up2 = 1
let health_up2 = 1

let reward_1 = 250
let reward_2 = 275
let total_reward_1 = 0
let total_reward_2 = 0

let respawn_1 = 10
let respawn_1_wave = 1.5

let respawn_2 = 10
let respawn_2_wave = 2


$.Msg('--------------------------------')

for (var i = 0; i < 25; i++)
{

	if (i == 1)
	{
		wave1 = 70
	}
	if (i >= 9)
	{
		wave1 = 120
	}
	if (i >= 15)
	{
		wave1 = 150
	}	
	if (i >= 20)
	{
		wave1 = 180
	}


	if (i >= 1)
	{
		damage_up1 = 1.22
		health_up1 = 1.26
	}
	if (i >= 10)
	{
		damage_up1 = 1.19
		health_up1 = 1.21
	}	
	if (i >= 15)
	{
		damage_up1 = 1.18
		health_up1 = 1.20
	}	
	if (i >= 20)
	{
		damage_up1 = 1.17
		health_up1 = 1.22
	}	










	if (i == 1)
	{
		wave2 = 70
	}
	if (i >= 5)
	{
		wave2 = 120
	}
	if (i >= 15)
	{
		wave2 = 180
	}


	if (i >= 1)
	{
		damage_up2 = 1.25
		health_up2 = 1.31
	}
	if (i >= 10)
	{
		damage_up2 = 1.19
		health_up2 = 1.21
	}	
	if (i >= 15)
	{
		damage_up2 = 1.18
		health_up2 = 1.20
	}	
	if (i >= 20)
	{
		damage_up2 = 1.17
		health_up2 = 1.22
	}	







	damage1 = damage1*damage_up1
	health1 = health1*health_up1

	damage2 = damage2*damage_up2
	health2 = health2*health_up2

	if (i == 11)
	{
		damage1 = damage1*1.3
		health1 = health1*1.4

		damage2 = damage2*1.3
		health2 = health2*1.4
	}




	time1 = time1 + wave1
	min1 = Math.floor(time1/60)
	sec1 = time1 - min1*60

	time2 = time2 + wave2
	min2 = Math.floor(time2/60)
	sec2 = time2 - min2*60

	total_reward_1 = total_reward_1 + reward_1
	total_reward_2 = total_reward_2 + reward_2

	respawn_1 = respawn_1 + respawn_1_wave
	respawn_2 = respawn_2 + respawn_2_wave


	$.Msg(i+1,' ', min1,':',sec1,' ',respawn_1, ' ||| ',' ', min2,':',sec2,' ',respawn_2)

	//$.Msg(min + ':' + sec + ' +' + n +' --- ',min2 + ':' + sec2 + ' +' + n2 +' | ',i  )

}
}


















function Hack()
{
	var parentHUDElements = $.GetContextPanel().GetParent().GetParent().GetParent().GetParent().GetParent().GetParent().GetParent().FindChild("HUDElements");
	var check_local = parentHUDElements.FindChildTraverse("center_block");
	var Button = dotaHud.FindChildrenWithClassTraverse("LeftRightFlow")[0].FindChildrenWithClassTraverse("MainUpgrades")[0]
 
    if (check_local.BHasClass("NonHero")) {
        Button.visible = false;
      
    } else {
    	  Button.visible = true;
    }
    $.Schedule(0.03, Hack)
}


