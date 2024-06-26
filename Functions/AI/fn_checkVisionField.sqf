/*
	Description:
		Checks if the target is in vision field.
		This function is not used for detection, only for target losing.
	
	Parameter(s):
		_unit
		_targetUnit
	
	Returns:
		BOOLEAN - detection result
*/

#define TRESHOLD 0.35

params [
	"_unit",
	"_targetUnit"
];

private _distance = _unit distance _targetUnit;

//Orientation
private _angle = _unit getRelDir _targetUnit;
private _angle = _angle min (360 - _angle);

if (_angle > STMOD_cfg_spottingAngle or {_distance > STMOD_cfg_spottingDistance}) exitWith
{
	false;	
};	

//Visibility
private _headVisibility = [_targetUnit, "VIEW", _unit] checkVisibility [eyePos _unit, eyePos _targetUnit];
private _bodyVisibility = [_targetUnit, "VIEW", _unit] checkVisibility [eyePos _unit, (AGLToASL (_targetUnit modelToWorld (_targetUnit selectionPosition "body")))];

if ( _headVisibility < TRESHOLD && {_bodyVisibility < TRESHOLD} ) exitWith
{
	false;	
};	

true;

