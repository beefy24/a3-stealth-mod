/*
	Description:
		Sets up client-side event handlers for player's unit.
		Once finished, it doesn't need to be called again. Only when object locality changes.
	
	Target machine:
		Client or server (depending on the object locality).

	Parameter(s):
		_unit
	
	Returns:
		NOTHING
*/

params [
	["_unit", objNull, [objNull]]
];

if (_unit isEqualTo objNull) exitWith { };

/*
	---- INITIALIZE VARIABLES ----
*/
_unit call STMOD_fnc_updateWeapon;

/*
	---- ADD EVENT HANDLERS ----
*/
_unit call STMOD_fnc_playerWeaponTracking;
