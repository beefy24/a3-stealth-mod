/*
	Description:
		Sets up server-side event handlers for a player.
		Must be called on every spawn, except for units located on the server.
	
	Parameter(s):
		_unit
	
	Returns:
		NOTHING
*/

params [
	["_unit", objNull, [objNull]]
];

if (_unit isEqualTo objNull) exitWith {};

if (isServer) then {

	/*
		---- INITIALIZE VARIABLES ----
	*/

	if ( isNil{_unit getVariable "STMOD_weaponSoundRange"} ) then {
		_unit setVariable ["STMOD_weaponSoundRange", 0];
	};

	_unit setVariable ["STMOD_footstepDetectionChance", 0];


	/*
		---- ADD EVENT HANDLERS ----
	*/

	//EH1 AnimStateChanged
	private _oldIndex1 = _unit getVariable ["STMOD_eh1s", -1];

	private _info1 = _unit getEventHandlerInfo ["AnimStateChanged", _oldIndex1];

	if ( !(_info1#0) ) then {
			private _newIndex = _unit call STMOD_fnc_playerStanceTracking;
			_unit setVariable ["STMOD_eh1s", _newIndex];
	};

	//EH2 FiredMan
	private _oldIndex2 = _unit getVariable ["STMOD_eh2s", -1];

	private _info2 = _unit getEventHandlerInfo ["FiredMan", _oldIndex2];

	if ( !(_info2#0) ) then {
			private _newIndex = _unit call STMOD_fnc_playerFiredTracking;
			_unit setVariable ["STMOD_eh2s", _newIndex];
	};
};