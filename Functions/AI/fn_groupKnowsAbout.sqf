/*
	Description:
		This function adds a KnowsAboutChanged event handler to the provided group.
		The script handles spotting and footsteps detection.
		The event is triggered every time a group's target knowledge increases.
		Note that knowsAbout command will return 0, until the group is fully aware of the target.
	
	Parameter(s):
		_group
		
	Returns:
		NOTHING
*/

#include "..\..\define.hpp"

params [ ["_group", grpNull, [grpNull]] ];

if (_group isEqualTo grpNull) exitWith { };


_group addEventHandler ["KnowsAboutChanged",
{
	params ["_group", "_targetUnit", "_newKnowsAbout", "_oldKnowsAbout"];

	if ( !(_targetUnit getVariable ["STMOD_stealthFlag", false]) or { !(alive _targetUnit) } ) exitWith {};


	private _targetRecord = [_group, _targetUnit] call STMOD_fnc_registerTarget; 

	//Update the knowsAbout value.
	_targetRecord set [3, _newKnowsAbout];

	#ifdef DEBUG_MODE_ON
	if ( STMOD_debug_knowsAboutEvent == 1 && !(_targetRecord select 2) || {STMOD_debug_knowsAboutEvent == 2} ) then {
		private _realValue = _group knowsAbout _targetUnit;
		private _message = (str _group + "  KNOWSABOUT:  " + str _targetUnit + "  NEW VAL.: " + str _newKnowsAbout + "  REAL VAL.: " + str _realValue + "  AT: " + str time + ".");
		_message remoteExecCall ["systemChat"];
	};
	#endif

	//1 Exit, if the target has already been detected.
	//2 Process only one instance of this event at a time (semaphore state).
	if (_targetRecord select 1 || _targetRecord select 2 DEBUG_OR(!STMOD_enable_knowsAboutEvent)) exitWith {};

	//Semaphore state ON.
	_targetRecord set [2, true];

	private _detectionResult = false;

	//Detection checks.
	{
		private _distance = _x distance _targetUnit;

		if
		( 
			[_x, _targetUnit, _distance] call STMOD_fnc_checkTargetSpotted DEBUG_AND(STMOD_enable_spotting) or 
			{[_x, _targetUnit, _distance] call STMOD_fnc_checkFootstepHeard DEBUG_AND(STMOD_enable_footstepDetection)}
		)
		exitWith {_detectionResult = true;};

	} forEach units _group;

	if (_detectionResult) then
	{	
		//Detection state ON.
		[_group, _targetUnit, "KnowsAboutChanged"] call STMOD_fnc_targetDetected;

		#ifdef TARGET_LOSS_ON
		_targetRecord set [2, false]; //Semaphore state OFF.
		#else
		[_targetRecord] spawn 
		{
			params ["_targetRecord"];
			
			sleep STMOD_cfg_semaphoreSleepTime;
			
			//Semaphore state OFF.
			_targetRecord set [2, false];
		};
		#endif
	}
	else
	{
		//Forget and wait some time before setting semaphore OFF.
		[_group, _targetUnit, _targetRecord] spawn
		{
			params ["_group", "_targetUnit", "_targetRecord"];

			scopeName "semaphore";

			isNil {
				if ( _targetRecord select 1 ) then {
					_targetRecord set [2, false]; //Semaphore state OFF.
					breakOut "semaphore";
				};
				_group forgetTarget _targetUnit;
			};

			sleep STMOD_cfg_semaphoreSleepTime;
			
			isNil {
				if (!(_targetRecord select 1)) then {
					_group forgetTarget _targetUnit;
				};
				
				_targetRecord set [2, false]; //Semaphore state OFF.
			};
		};
	};
}];