/*
	Description:
		Checks the orientation, distance, and visibility, and then calculates the detection meter.
		If the meter reaches 1, the target is detected.

	Parameter(s):
		_unit - the detecting unit
		_targetUnit - the stealth unit
		_distance - distance between units

	Returns:
		BOOLEAN - detection result
*/

#include "..\..\define.hpp"

params [
	"_unit",
	"_targetUnit",
	"_distance"
];

//Orientation
private _eyeDirVec = eyeDirection _unit; 
private _dirVec = (eyePos _unit) vectorFromTo (eyePos _targetUnit); 

private _dotProduct = _eyeDirVec vectorDotProduct _dirVec; 
private _yaw = acos _dotProduct;

/*private _targetPitch = asin (_dirVec#2); 
private _eyePitch = asin (_eyeDirVec#2);
private _pitch = abs(_eyePitch - _targetPitch);*/

#ifdef DEBUG_MODE_ON
if (STMOD_debug_spottingAngle) then {
	private _message = (str _unit + "  TO:  " + str _targetUnit + "  HOR ANGLE: " + str _yaw + /*"  VERT ANG: " + str _pitch +*/ ".");
	_message remoteExecCall ["systemChat"];
};
#endif

//Angle and distance treshold
if (_yaw > STMOD_cfg_spottingAngle or {_distance > STMOD_cfg_spottingDistance}) exitWith
{
	false;
};

//Visibility
private _headVisibility = [_targetUnit, "VIEW", _unit] checkVisibility [eyePos _unit, eyePos _targetUnit];
private _bodyVisibility = [_targetUnit, "VIEW", _unit] checkVisibility [eyePos _unit, (AGLToASL (_targetUnit modelToWorld (_targetUnit selectionPosition "body")))];

#ifdef DEBUG_MODE_ON
if (STMOD_debug_visibility) then {
	private _message = (str _unit + "  TO:  " + str _targetUnit + "  HEAD VIS: " + str _headVisibility + "  BODY VIS: " + str _bodyVisibility + ".");
	_message remoteExecCall ["systemChat"];
};
#endif

//Visibility treshold
if ( _headVisibility < STMOD_cfg_headVisibilityTreshold && {_bodyVisibility < STMOD_cfg_bodyVisibilityTreshold} ) exitWith
{
	false;
};	

//Get the last spotting meter value.
private _allMeters = _unit getVariable "STMOD_spottingMeters"; 
private _spottingMeter = _allMeters findIf {(_x select 0) == _targetUnit};

if (_spottingMeter == -1) then
{	
	//[[targetUnit, spottingMeter, lastUpdateTime]]
	_spottingMeter = _allMeters pushBack [_targetUnit, 0, 0];
};

_spottingMeter = _allMeters select _spottingMeter;

private _oldMeter = _spottingMeter select 1;
private _updateTime = _spottingMeter select 2;

//Calculate a new spotting meter value.
private _newMeter = nil;

//private _distanceCoef = 1.0 * 0.9958^_distance; //Exponential
private _distanceCoef = 1 - ( (_distance^0.27)/(700^0.27) ); //Non-linear

private _increase = 1*_distanceCoef * ((_headVisibility + _bodyVisibility)/2) * (((STMOD_cfg_spottingAngle-_yaw) / STMOD_cfg_spottingAngle) /*max 0.22*/);

//Deduce a time based meter reduction.
if (time - _updateTime > STMOD_cfg_spottingFalloffTime) then
{
	_newMeter = ( ( _oldMeter - ( time - _updateTime - STMOD_cfg_spottingFalloffTime ) * STMOD_cfg_spottingFalloffSpeed ) max 0 ) + _increase;
}
else
{
	_newMeter = (_oldMeter + _increase);
};

#ifdef DEBUG_MODE_ON
_newMeter = _newMeter min 1;
#endif

//Update the spotting meter.
_spottingMeter set [1, _newMeter];
_spottingMeter set [2, time];

#ifdef DEBUG_MODE_ON
if (STMOD_debug_spottingMeter) then {
	private _message = (str _unit + "  TO:  " + str _targetUnit + "  COEF: " + str _distanceCoef + "  INCREASE: " + str _increase + "  METER: " + str _newMeter + ".");
	_message remoteExecCall ["hintSilent"];
};
#endif

_newMeter >= 1;