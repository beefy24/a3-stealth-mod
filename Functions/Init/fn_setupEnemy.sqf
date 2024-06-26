/*
	Description:
		Sets up an enemy group or all groups on a given side
		for detecting stealth units.
	
	Parameter(s):
		_groupOrSide
	
	Returns:
		ARRAY - groups which has been set up
*/

params [
	["_groupOrSide", sideEmpty, [civilian, grpNull]]
];

if (_groupOrSide isEqualTo sideEmpty || _groupOrSide isEqualTo grpNull) exitWith { []; };

private _allGroups = nil;

if ((typeName _groupOrSide) == "SIDE") then {
	_allGroups = groups _groupOrSide;
} else {
	_allGroups = [_groupOrSide];
};

{
	private _group = _x;

	if (isNil {_group getVariable "STMOD_targets"} ) then {
		_group setVariable ["STMOD_targets", []];
		_group call STMOD_fnc_groupKnowsAbout;
	};

	{
		if (isNil {_x getVariable "STMOD_enemyFlag"}) then {
			_x setVariable ["STMOD_enemyFlag", true];
			_x setVariable ["STMOD_spottingMeters", []];
			_x call STMOD_fnc_unitHit;
		};
	} forEach units _group;

} forEach _allGroups;

_allGroups;