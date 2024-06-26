/*
	Description:
		Determines if a target unit is heard or not, based on proximity and a detection chance.
	
	TODO:
		This function should be replaced with a mechanism which doesn't rely on a dice roll.
		Distance can be mapped using a non-linear function.
	
	Parameter(s):
		_unit - the detecting unit
		_targetUnit - the stealth unit
		_distance - distance between units
	
	Returns:
		BOOLEAN - detection result
*/

#include "..\..\define.hpp"

params ["_unit", "_targetUnit", "_distance"];

//Sound source distance treshold.
if ( _distance > STMOD_cfg_footstepSoundRange) exitWith { false; };

//Calculate detection chance.
private _baseChance = _targetUnit getVariable "STMOD_footstepDetectionChance";
private _distanceCoef = STMOD_footstepDistanceCoef_a * _distance + STMOD_footstepDistanceCoef_b;

private _randomNumber = random 1; 

private _heardFootsteps = _randomNumber < _baseChance * _distanceCoef;

#ifdef DEBUG_MODE_ON
if (STMOD_debug_footstepDetection) then {
	private _message = nil;
	if (_heardFootsteps) then {_message = "  HEARD:  ";} else {_message = "  DIDN'T HEAR:  ";};
    private _message = (str _unit + _message + str _targetUnit + "  RAND:  " + str _randomNumber + "  CHANCE:  " + str _baseChance + "  *  " + str _distanceCoef + "  =  " + str (_baseChance *_distanceCoef) + ".");
    _message remoteExecCall ["systemChat"];
};
#endif

_heardFootsteps;