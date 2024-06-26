/*
	Description:
		Performs a transition to the detected state based on the triggering event.
	
	Parameter(s):
		_group - group that detected a target
		_targetUnit - the detected stealth unit
		_eventName:STRING - event that triggerred the transition
	
	Returns:
		BOOLEAN
*/

#include "..\..\define.hpp"

params ["_group", "_targetUnit", "_eventName"];

if ( !(_targetUnit getVariable ["STMOD_stealthFlag", false]) ) exitWith {false;};

private _targetRecord = [_group, _targetUnit] call STMOD_fnc_registerTarget;

if (_targetRecord select 1) exitWith {true;};

_targetRecord set [1, true];
//_group ignoreTarget [_targetUnit, false];

#ifdef TARGET_LOSS_ON
[_group, _targetUnit, _targetRecord] call STMOD_fnc_startTargetLossTimer;
#endif

switch (_eventName) do {

	case "KnowsAboutChanged": {
		//Target can be revealed here for immediate reaction.
		//_group reveal [_targetUnit, 0.1];
	};

	case "FiredMan": {
		//Sound travel time delay can be added here.
	};

	case "Hit": {
	};

	case "Suppressed": {
	};

	case "Explode": {
	};
};

#ifdef DEBUG_MODE_ON
if (STMOD_debug_targetDetected) then {
	private _message = (str _targetUnit + "  HAS BEEN DETECTED BY:  " + str _group + "  CAUSE:  " + toUpper _eventName);
	_message remoteExecCall ["systemChat"];
};
#endif

true;
