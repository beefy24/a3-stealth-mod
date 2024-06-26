/*
	Description:
		Creates a new entry for a target unit in the array of targets.

	Parameter(s):
		_group - group which registers a target
		_targetUnit
	
	Returns:
		ARRAY - a new entry in the STMOD_targets
*/

params ["_group", "_targetUnit"];

private _targetRegister = _group getVariable "STMOD_targets"; 
private _targetRecord = _targetRegister findIf {(_x select 0) == _targetUnit};

if (_targetRecord == -1) then
{	
	//_group ignoreTarget _targetUnit; //Ignore the target until it's detected.

	//[[targetUnit, detectionState, semaphoreState, knowsAboutValue]]
	_targetRecord = _targetRegister pushBack [_targetUnit, false, false, 0];
};

_targetRecord = _targetRegister select _targetRecord;

_targetRecord;