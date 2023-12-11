// ----------------------------------------------------------
// Vector Targeting Library
// ========================
// Version: 1.0
// Github: https://github.com/Nibuja05/dota_vector_targeting
// ----------------------------------------------------------

/// Vector Targeting
const CONSUME_EVENT = true;
const CONTINUE_PROCESSING_EVENT = false;

//main variables
var vectorTargetParticle;
var vectorTargetUnit;
var vectorStartPosition;
var vectorRange = 800;
var useDual = false;
var currentlyActiveVectorTargetAbility;
var muerta_current_target_index;

const defaultAbilities = 
["pangolier_swashbuckle",
 "clinkz_burning_army",
 "hoodwink_acorn_shot_custom",
 "hoodwink_acorn_shot_custom_2",
 "custom_puck_illusory_barrier",
 "custom_puck_illusory_orb",
 "void_spirit_aether_remnant_custom",
 "muerta_dead_shot_custom",
 "pangolier_swashbuckle_custom",
 "invoker_ice_wall_custom",
 "arc_warden_flux_custom"
];

GameUI.SetMouseCallback(function(eventName, arg, arg2, arg3)
{
	if(GameUI.GetClickBehaviors() == 3 && currentlyActiveVectorTargetAbility != undefined && GameUI.IsMouseDown(2) !== true)
	{

		const abilityName_2 = Abilities.GetAbilityName(currentlyActiveVectorTargetAbility);

		if (abilityName_2 == "muerta_dead_shot_custom")
		{
			var ent=GameUI.FindScreenEntities(GameUI.GetCursorPosition())

			if (ent[0] != null && ent[0].entityIndex != Players.GetPlayerHeroEntityIndex( Players.GetLocalPlayer() )) 
			{
				muerta_current_target_index = ent[0].entityIndex
			}
			const netTable = CustomNetTables.GetTableValue( "vector_targeting", currentlyActiveVectorTargetAbility )
			OnVectorTargetingStart(netTable.startWidth, netTable.endWidth, netTable.castLength, netTable.dual, netTable.ignoreArrow);
		//	currentlyActiveVectorTargetAbility = undefined;


		} else {
			const netTable = CustomNetTables.GetTableValue( "vector_targeting", currentlyActiveVectorTargetAbility )
			OnVectorTargetingStart(netTable.startWidth, netTable.endWidth, netTable.castLength, netTable.dual, netTable.ignoreArrow);
			currentlyActiveVectorTargetAbility = undefined;
		}
	}
	marci_check_mouse_f(eventName, arg, arg2, arg3)
	return CONTINUE_PROCESSING_EVENT;
});

//Listen for class changes
$.RegisterForUnhandledEvent("StyleClassesChanged", CheckAbilityVectorTargeting );
function CheckAbilityVectorTargeting(panel){
	if(panel == null){return;}

	//Check if the panel is an ability or item panel
	const abilityIndex = GetAbilityFromPanel(panel)
	if (abilityIndex >= 0) {

		//Check if the ability/item is vector targeted
		const netTable = CustomNetTables.GetTableValue("vector_targeting", abilityIndex);
		if (netTable == undefined) {
			let behavior = Abilities.GetBehavior(abilityIndex);
			if ((behavior & DOTA_ABILITY_BEHAVIOR.DOTA_ABILITY_BEHAVIOR_VECTOR_TARGETING) !== 0) {

				GameEvents.SendCustomGameEventToServer_custom("check_ability", {"abilityIndex" : abilityIndex} );
			}
			return;
		}


		//Check if the ability/item gets activated or is finished
		if (panel.BHasClass("is_active")) {
			currentlyActiveVectorTargetAbility = abilityIndex;
			if(GameUI.GetClickBehaviors() == 9 ) {
				OnVectorTargetingStart(netTable.startWidth, netTable.endWidth, netTable.castLength, netTable.dual, netTable.ignoreArrow);
			}
		} else {
			OnVectorTargetingEnd();

		}
	}
}

//Find the ability/item entindex from the panorama panel
function GetAbilityFromPanel(panel) {
	if (panel.paneltype == "DOTAAbilityPanel") {

		// Be sure that it is a default ability Button
		const parent = panel.GetParent();
		if (parent != undefined && (parent.id == "abilities" || parent.id == "inventory_list")) {
			const abilityImage = panel.FindChildTraverse("AbilityImage")
			let abilityIndex = abilityImage.contextEntityIndex;
			let abilityName = abilityImage.abilityname

			//Will be undefined for items
			if (abilityName) {
				return abilityIndex;
			}

			//Return item entindex instead
			const itemImage = panel.FindChildTraverse("ItemImage")
			abilityIndex = itemImage.contextEntityIndex;
			return abilityIndex;
		}
	}
	return -1;
}

// Start the vector targeti ng
function OnVectorTargetingStart(fStartWidth, fEndWidth, fCastLength, bDual, bIgnoreArrow)
{

	if (vectorTargetParticle) {

		Particles.DestroyParticleEffect(vectorTargetParticle, true)
		vectorTargetParticle = undefined;
		vectorTargetUnit = undefined;
	}

	const iPlayerID = Players.GetLocalPlayer();
	const selectedEntities = Players.GetSelectedEntities( iPlayerID );
	const mainSelected = Players.GetLocalPlayerPortraitUnit();
	const mainSelectedName = Entities.GetUnitName(mainSelected);
	vectorTargetUnit = mainSelected;
	const cursor = GameUI.GetCursorPosition();
	const worldPosition = GameUI.GetScreenWorldPosition(cursor);

	// particle variables
	let startWidth = fStartWidth || 125;
	let endWidth = fEndWidth || startWidth;
	vectorRange = fCastLength || 800;
	let ignoreArrowWidth = bIgnoreArrow;
	useDual = bDual == 1;
    

	// redo dota's default particles
	const abilityName = Abilities.GetAbilityName(currentlyActiveVectorTargetAbility);

	if (abilityName == "marci_companion_run_custom")
	{
		return 
	}

	if (defaultAbilities.includes(abilityName)) {
		if (abilityName == "void_spirit_aether_remnant_custom") 
		{
			startWidth = Abilities.GetSpecialValueFor(currentlyActiveVectorTargetAbility, "start_radius");
			endWidth = Abilities.GetSpecialValueFor(currentlyActiveVectorTargetAbility, "end_radius");
			vectorRange = Abilities.GetSpecialValueFor(currentlyActiveVectorTargetAbility, "remnant_watch_distance");

			if (HasModifier(Players.GetLocalPlayerPortraitUnit(), "modifier_item_aghanims_shard"))
			{
				vectorRange = vectorRange + Abilities.GetSpecialValueFor(currentlyActiveVectorTargetAbility, "shard_range");
			}

			ignoreArrowWidth = 1;
		} else if (abilityName == "custom_puck_illusory_barrier") {
			vectorRange = 400
			let multiplier = 1
			vectorRange = vectorRange * multiplier
			//useDual = true;

		} else if ((abilityName == "hoodwink_acorn_shot_custom")||(abilityName == "hoodwink_acorn_shot_custom_2")) {
			vectorRange = 500
			let multiplier = 1
			vectorRange = vectorRange * multiplier
			useDual = true;
			
		}else if  (abilityName == "invoker_ice_wall_custom"){
			let spacing = Abilities.GetSpecialValueFor(currentlyActiveVectorTargetAbility, "wall_element_spacing")
			let num = Abilities.GetSpecialValueFor(currentlyActiveVectorTargetAbility, "num_wall_elements")

			vectorRange = spacing*num*0.9
			let multiplier = 1
			vectorRange = vectorRange * multiplier
			useDual = true;

		} else if (abilityName == "custom_puck_illusory_orb") {
			vectorRange = 400
			let multiplier = 1
			vectorRange = vectorRange * multiplier			
		}else if (abilityName == "arc_warden_flux_custom") {
			vectorRange = 250
			let multiplier = 1
			vectorRange = vectorRange * multiplier	

			var ent=GameUI.FindScreenEntities(GameUI.GetCursorPosition())
			if (ent[0] != null) {
				muerta_current_target_index = ent[0].entityIndex
			}
		
		}else if (abilityName == "pangolier_swashbuckle_custom") {
			vectorRange = Abilities.GetSpecialValueFor(currentlyActiveVectorTargetAbility, "range")
			let multiplier = 1
			vectorRange = vectorRange * multiplier	
		}
		else if (abilityName == "muerta_dead_shot_custom") 
		{
			startWidth = Abilities.GetSpecialValueFor(currentlyActiveVectorTargetAbility, "ricochet_radius_start");
			endWidth = Abilities.GetSpecialValueFor(currentlyActiveVectorTargetAbility, "ricochet_radius_end");
			vectorRange = Abilities.GetSpecialValueFor(currentlyActiveVectorTargetAbility, "range");

			if (HasModifier(Players.GetLocalPlayerPortraitUnit(), "modifier_muerta_dead_6"))
			{
				vectorRange = vectorRange + 200
			}


			var ent=GameUI.FindScreenEntities(GameUI.GetCursorPosition())
			if (ent[0] != null && ent[0].entityIndex != Players.GetPlayerHeroEntityIndex( Players.GetLocalPlayer() )) {
				muerta_current_target_index = ent[0].entityIndex
			}
		}
		else 

		{
			vectorRange = Abilities.GetSpecialValueFor(currentlyActiveVectorTargetAbility, "range");
		}
	}

	if (useDual) {
		vectorRange = vectorRange / 2;
	}

	let particleName = "particles/ui_mouseactions/custom_range_finder_cone.vpcf";
	if (useDual) {
		particleName = "particles/ui_mouseactions/custom_range_finder_cone_dual.vpcf"
	}


	if (abilityName == "muerta_dead_shot_custom" && muerta_current_target_index)
	{
		vectorTargetParticle = Particles.CreateParticle(particleName, ParticleAttachment_t.PATTACH_CUSTOMORIGIN, mainSelected);
		vectorTargetUnit = mainSelected
		
		Particles.SetParticleControl(vectorTargetParticle, 1, Vector_raiseZ(Entities.GetAbsOrigin( muerta_current_target_index ), 100));
		Particles.SetParticleControl(vectorTargetParticle, 3, [endWidth, startWidth, ignoreArrowWidth]);
		Particles.SetParticleControl(vectorTargetParticle, 4, [0, 255, 0]);
		vectorStartPosition = Entities.GetAbsOrigin( muerta_current_target_index );
		const unitPosition = Entities.GetAbsOrigin(mainSelected);
		const direction = Vector_normalize(Vector_sub(vectorStartPosition, unitPosition));
		const newPosition = Vector_add(vectorStartPosition, Vector_mult(direction, vectorRange));
		if (!useDual) {
			Particles.SetParticleControl(vectorTargetParticle, 2, newPosition);
		} else {
			Particles.SetParticleControl(vectorTargetParticle, 7, newPosition);
			const secondPosition = Vector_add(vectorStartPosition, Vector_mult(Vector_negate(direction), vectorRange));
			Particles.SetParticleControl(vectorTargetParticle, 8, secondPosition);
		}
	} 
	else 
	{
		vectorTargetParticle = Particles.CreateParticle(particleName, ParticleAttachment_t.PATTACH_CUSTOMORIGIN, mainSelected);
		vectorTargetUnit = mainSelected

		Particles.SetParticleControl(vectorTargetParticle, 1, Vector_raiseZ(worldPosition, 100));
		Particles.SetParticleControl(vectorTargetParticle, 3, [endWidth, startWidth, ignoreArrowWidth]);
		Particles.SetParticleControl(vectorTargetParticle, 4, [0, 255, 0]);
		vectorStartPosition = worldPosition;
		const unitPosition = Entities.GetAbsOrigin(mainSelected);
		const direction = Vector_normalize(Vector_sub(vectorStartPosition, unitPosition));
		const newPosition = Vector_add(vectorStartPosition, Vector_mult(direction, vectorRange));
		if (!useDual) 
		{
			Particles.SetParticleControl(vectorTargetParticle, 2, newPosition);
		} else {
			Particles.SetParticleControl(vectorTargetParticle, 7, newPosition);
			const secondPosition = Vector_add(vectorStartPosition, Vector_mult(Vector_negate(direction), vectorRange));
			Particles.SetParticleControl(vectorTargetParticle, 8, secondPosition);
		}
	}
	

	//Start position updates
	ShowVectorTargetingParticle();
	return CONTINUE_PROCESSING_EVENT;
}

//End the particle effect
function OnVectorTargetingEnd()
{
	currentlyActiveVectorTargetAbility = undefined
	muerta_current_target_index = undefined
	if (vectorTargetParticle) {
		Particles.DestroyParticleEffect(vectorTargetParticle, true)
		vectorTargetParticle = undefined;
		vectorTargetUnit = undefined;
	}
}

//Updates the particle effect and detects when the ability is actually casted
function ShowVectorTargetingParticle()
{
	if (vectorTargetParticle !== undefined)
	{
		const mainSelected = Players.GetLocalPlayerPortraitUnit();
		const cursor = GameUI.GetCursorPosition();
		const worldPosition = GameUI.GetScreenWorldPosition(cursor);

		if (worldPosition == null)
		{
			$.Schedule(1 / 144, ShowVectorTargetingParticle);
			return;
		}

		if (muerta_current_target_index)
		{
			let origin_v = Entities.GetAbsOrigin( muerta_current_target_index );
			const testVec = Vector_sub(worldPosition, origin_v);
			if (!(testVec[0] == 0 && testVec[1] == 0 && testVec[2] == 0))
			{
				Particles.SetParticleControl(vectorTargetParticle, 1, Vector_raiseZ(Entities.GetAbsOrigin( muerta_current_target_index ), 100));
				let direction = Vector_normalize(Vector_sub(origin_v, worldPosition));
				direction = Vector_flatten(Vector_negate(direction));
				const newPosition = Vector_add(origin_v, Vector_mult(direction, vectorRange));

				if (!useDual) {
					Particles.SetParticleControl(vectorTargetParticle, 2, newPosition);
				} else {
					Particles.SetParticleControl(vectorTargetParticle, 7, newPosition);
					const secondPosition = Vector_add(origin_v, Vector_mult(Vector_negate(direction), vectorRange));
					Particles.SetParticleControl(vectorTargetParticle, 8, secondPosition);
				}
			}
			if( mainSelected != vectorTargetUnit ){
				GameUI.SelectUnit(vectorTargetUnit, false )
			}
		} else {
			const testVec = Vector_sub(worldPosition, vectorStartPosition);
			if (!(testVec[0] == 0 && testVec[1] == 0 && testVec[2] == 0))
			{
				let direction = Vector_normalize(Vector_sub(vectorStartPosition, worldPosition));
				direction = Vector_flatten(Vector_negate(direction));
				const newPosition = Vector_add(vectorStartPosition, Vector_mult(direction, vectorRange));

				if (!useDual) {
					Particles.SetParticleControl(vectorTargetParticle, 2, newPosition);
				} else {
					Particles.SetParticleControl(vectorTargetParticle, 7, newPosition);
					const secondPosition = Vector_add(vectorStartPosition, Vector_mult(Vector_negate(direction), vectorRange));
					Particles.SetParticleControl(vectorTargetParticle, 8, secondPosition);
				}
			}
			if( mainSelected != vectorTargetUnit ){
				GameUI.SelectUnit(vectorTargetUnit, false )
			}
		}
		$.Schedule(1 / 144, ShowVectorTargetingParticle);
	}
}

//Some Vector Functions here:
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

