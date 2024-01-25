GameEvents.Subscribe_custom( 'NetTableDebugErrors', NetTableDebugErrors );

errorLabels = []

function NetTableDebugErrors( data ) {

	var data = CustomNetTables.GetTableValue("debug", "errors");
	$( "#DebugPanel" ).visible = true

	let i = 0

	for ( let k in data ) {
		if ( !errorLabels[i] ) {
			errorLabels[i] = $.CreatePanel( "Label", $( "#ErrorContainer" ), "" )
		}
			
		errorLabels[i].visible = true
		errorLabels[i].text = data[k]

		i++
	}

	while ( true ) {
		let err = errorLabels[i]

		if ( err ) {
			err.visible = false
		} else {
			break
		}

		i++
	}
}

$( "#DebugPanel" ).visible = false

