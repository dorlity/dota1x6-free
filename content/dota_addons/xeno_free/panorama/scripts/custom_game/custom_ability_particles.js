var vectorTargetParticle_hoodwink = undefined;
var last_state = false;

function Think_hoodwink()
{

	if (HasModifier(Players.GetPlayerHeroEntityIndex( Players.GetLocalPlayer() ), "modifier_hoodwink_sharpshooter_custom") )
	{
		if (vectorTargetParticle_hoodwink == undefined) {
			vectorTargetParticle_hoodwink = Particles.CreateParticle("particles/units/heroes/hero_hoodwink/hoodwink_sharpshooter_range_finder.vpcf", ParticleAttachment_t.PATTACH_ABSORIGIN_FOLLOW, Players.GetPlayerHeroEntityIndex( Players.GetLocalPlayer() ) );
		}
	} else {
		if (vectorTargetParticle_hoodwink) {
			Particles.DestroyParticleEffect(vectorTargetParticle_hoodwink, true)
			vectorTargetParticle_hoodwink = undefined;
		}
	}

	if (vectorTargetParticle_hoodwink)
	{
		const cursor = GameUI.GetCursorPosition();
		const worldPosition = GameUI.GetScreenWorldPosition(cursor);

	    if (HasModifier(Players.GetPlayerHeroEntityIndex( Players.GetLocalPlayer() ), "modifier_hoodwink_sharpshooter_custom")  )
	    {
	    	let cast_range = Abilities.GetSpecialValueFor(Buffs.GetAbility( Players.GetPlayerHeroEntityIndex( Players.GetLocalPlayer() ), FindModifier(Players.GetPlayerHeroEntityIndex( Players.GetLocalPlayer() ), "modifier_hoodwink_sharpshooter_custom") ), "arrow_range");
	    	let origin = Entities.GetAbsOrigin( Players.GetPlayerHeroEntityIndex( Players.GetLocalPlayer() ) )
	    	let forward = Entities.GetForward( Players.GetPlayerHeroEntityIndex( Players.GetLocalPlayer() ))
	    	Particles.SetParticleControl(vectorTargetParticle_hoodwink, 0, origin );
			Particles.SetParticleControl(vectorTargetParticle_hoodwink, 1, Vector_add(origin, Vector_mult(forward, cast_range)) );
	    }
	}


    $.Schedule(0, Think_hoodwink)
}

function HasModifier(unit, modifier) {
    for (var i = 0; i < Entities.GetNumBuffs(unit); i++) {
        if (Buffs.GetName(unit, Entities.GetBuff(unit, i)) == modifier){
            return true
        }
    }
    return false
}

function FindModifier(unit, modifier) {
    for (var i = 0; i < Entities.GetNumBuffs(unit); i++) {
        if (Buffs.GetName(unit, Entities.GetBuff(unit, i)) == modifier){
            return Entities.GetBuff(unit, i);
        }
    }
}

Think_hoodwink()

function Vector_normalize(vec)
{
	const val = 1 / Math.sqrt(Math.pow(vec[0], 2) + Math.pow(vec[1], 2) + Math.pow(vec[2], 2));
	return [vec[0] * val, vec[1] * val, vec[2] * val];
}

function Vector_mult(vec, mult)
{
	return [vec[0] * mult, vec[1] * mult, vec[2] * mult];
}

function Vector_add(vec1, vec2)
{
	return [vec1[0] + vec2[0], vec1[1] + vec2[1], vec1[2] + vec2[2]];
}

function Vector_sub(vec1, vec2)
{
	return [vec1[0] - vec2[0], vec1[1] - vec2[1], vec1[2] - vec2[2]];
}

function Vector_negate(vec)
{
	return [-vec[0], -vec[1], -vec[2]];
}

function Vector_flatten(vec)
{
	return [vec[0], vec[1], 0];
}

function Vector_raiseZ(vec, inc)
{
	return [vec[0], vec[1], vec[2] + inc];
}

function Vector_distance (vec1, vec2) {
	return Math.sqrt(((vec2[0] - vec1[0]) ** 2) + ((vec2[1] - vec1[1]) ** 2));
}


Think_snapfire()
var vectorTargetParticle_snapfire;
var lastAbility_snapfire = -1;

function Think_snapfire()
{
	if (Abilities.GetLocalPlayerActiveAbility() != lastAbility_snapfire) 
	{
		lastAbility_snapfire = Abilities.GetLocalPlayerActiveAbility()
		if (vectorTargetParticle_snapfire) {
			Particles.DestroyParticleEffect(vectorTargetParticle_snapfire, true)
			vectorTargetParticle_snapfire = undefined;
		}
		if ( (Abilities.GetLocalPlayerActiveAbility() != -1) && (Abilities.GetAbilityName(Abilities.GetLocalPlayerActiveAbility()) == "snapfire_scatterblast_custom") ) {
			vectorTargetParticle_snapfire = Particles.CreateParticle("particles/units/heroes/hero_snapfire/hero_snapfire_shotgun_range_finder_aoe.vpcf", ParticleAttachment_t.PATTACH_ABSORIGIN_FOLLOW, Players.GetLocalPlayerPortraitUnit() );
		}
	}

	if (vectorTargetParticle_snapfire)
	{
		const cursor = GameUI.GetCursorPosition();
		const worldPosition = GameUI.GetScreenWorldPosition(cursor);
	    if ( (Abilities.GetLocalPlayerActiveAbility() != -1) && (Abilities.GetAbilityName(Abilities.GetLocalPlayerActiveAbility()) == "snapfire_scatterblast_custom") ) {

	    	let point_blank = Abilities.GetSpecialValueFor(Abilities.GetLocalPlayerActiveAbility(), "point_blank_range");
	    	let blast_width_end = Abilities.GetSpecialValueFor(Abilities.GetLocalPlayerActiveAbility(), "blast_width_end");
	    	let origin = Entities.GetAbsOrigin( Players.GetLocalPlayerPortraitUnit() )

	    	if (HasModifier(Players.GetLocalPlayerPortraitUnit(), "modifier_scp682_ultimate")) {
	    		point_blank = point_blank + 150
	    	}

	    	let direction = Vector_normalize(Vector_sub(origin, worldPosition));
	    	let cast_range = Abilities.GetCastRange( Abilities.GetLocalPlayerActiveAbility() )

	    	Particles.SetParticleControl(vectorTargetParticle_snapfire, 0, origin );
			Particles.SetParticleControl(vectorTargetParticle_snapfire, 1, Vector_sub(origin, Vector_mult(direction, (cast_range + (blast_width_end / 2) ))) );
			Particles.SetParticleControl(vectorTargetParticle_snapfire, 6, Vector_sub(origin, Vector_mult(direction, point_blank)) );
	    }
	}

    $.Schedule(1/144, Think_snapfire)
}

Think_muerta()
var vectorTargetParticle_muerta;
var lastAbility_muerta = -1;

function Think_muerta()
{
	if (HasModifier(Players.GetPlayerHeroEntityIndex( Players.GetLocalPlayer() ), "modifier_muerta_calling_7"))
	{
		if (vectorTargetParticle_muerta) {
			Particles.DestroyParticleEffect(vectorTargetParticle_muerta, true)
			vectorTargetParticle_muerta = undefined;
		}
		return
	}


	if (Abilities.GetLocalPlayerActiveAbility() != lastAbility_muerta) 
	{
		lastAbility_muerta = Abilities.GetLocalPlayerActiveAbility()
		if (vectorTargetParticle_muerta) {
			Particles.DestroyParticleEffect(vectorTargetParticle_muerta, true)
			vectorTargetParticle_muerta = undefined;
		
		}
		if ( (Abilities.GetLocalPlayerActiveAbility() != 1) && (Abilities.GetAbilityName(Abilities.GetLocalPlayerActiveAbility()) == "muerta_the_calling_custom") ) {
			vectorTargetParticle_muerta = Particles.CreateParticle("particles/units/heroes/hero_muerta/muerta_calling_reticule_2.vpcf", ParticleAttachment_t.PATTACH_WORLDORIGIN, Players.GetLocalPlayerPortraitUnit() );
		}
	}

	if (vectorTargetParticle_muerta)
	{


		const cursor = GameUI.GetCursorPosition();
		const worldPosition = GameUI.GetScreenWorldPosition(cursor);
	    if ( (Abilities.GetLocalPlayerActiveAbility() != 1) && (Abilities.GetAbilityName(Abilities.GetLocalPlayerActiveAbility()) == "muerta_the_calling_custom") ) 
		{
			let radius = 580
	    	let origin = Entities.GetAbsOrigin( Players.GetLocalPlayerPortraitUnit() )

	    	Particles.SetParticleControl(vectorTargetParticle_muerta, 1, [radius, radius, radius] );

		    let c = Math.sqrt( 2 ) * 0.5 * radius 
		    let x_offset = [ -radius+120, -c, 0.0, c, radius-120, c, 0.0, -c ]
		    let y_offset = [ 0.0, c, radius-120, c, 0.0, -c, -radius+120, -c ]

		    Particles.SetParticleControl(vectorTargetParticle_muerta, 0, worldPosition );
		    Particles.SetParticleControl(vectorTargetParticle_muerta, 2, Vector_add2(worldPosition,[x_offset[0], y_offset[0], 0]) );
		    Particles.SetParticleControl(vectorTargetParticle_muerta, 3, Vector_add2(worldPosition,[x_offset[0], y_offset[0], 0]) );
		    Particles.SetParticleControl(vectorTargetParticle_muerta, 4, Vector_add2(worldPosition,[x_offset[2], y_offset[2], 0]) );
		    Particles.SetParticleControl(vectorTargetParticle_muerta, 5, Vector_add2(worldPosition,[x_offset[2], y_offset[2], 0]) );
		    Particles.SetParticleControl(vectorTargetParticle_muerta, 6, Vector_add2(worldPosition,[x_offset[4], y_offset[4], 0]) );
		    Particles.SetParticleControl(vectorTargetParticle_muerta, 7, Vector_add2(worldPosition,[x_offset[4], y_offset[4], 0]) );
		    Particles.SetParticleControl(vectorTargetParticle_muerta, 8, Vector_add2(worldPosition,[x_offset[6], y_offset[6], 0]) );
		    Particles.SetParticleControl(vectorTargetParticle_muerta, 9, Vector_add2(worldPosition,[x_offset[6], y_offset[6], 0]) );
		}
	}

    $.Schedule(1/144, Think_muerta)
}



function Vector_add2(vec1, vec2)
{
	if (vec1)
	{
		return [vec1[0] + vec2[0], vec1[1] + vec2[1], vec1[2] + vec2[2]];
	}
}















