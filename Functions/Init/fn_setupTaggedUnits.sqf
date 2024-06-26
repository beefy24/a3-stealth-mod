/*
	Description:
		Sets up all tagged units with STMOD_stealthFlag as stealth units. Works only in SP.
	
	Parameter(s):
		NOTHING
	
	Returns:
		ARRAY - units which has been set up
*/

if (isMultiplayer) exitWith { [] };

private _taggedUnits = allUnits select {_x getVariable ["STMOD_stealthFlag", false]};

private _preparedUnits = [];

{
	_x call STMOD_fnc_setupPlayerServer;	
	_x call STMOD_fnc_setupPlayerClient;
	_preparedUnits pushBack _x;
	
} forEach _taggedUnits;

_preparedUnits;