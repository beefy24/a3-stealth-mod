/*
	Description:
		Makes a group forget its target after a period of no contact.
	
	Parameter(s):
		_group - group that should forget a target
		_targetUnit - unit to be forgotten
		_targetRecord - array returned by STMOD_fnc_registerTarget
	
	Returns:
		SCRIPT HANDLE - handle for the spawned timer
*/

#include "..\..\define.hpp"

#define TIME_BETWEEN_CHECKS 5

params ["_group", "_targetUnit", "_targetRecord"];


[_group, _targetUnit, _targetRecord] spawn
{
	params ["_group", "_targetUnit", "_targetRecord"];
	
	private _targetAge = 0;
	private _timeToLoseTarget = [_group, _targetUnit, _targetRecord ] call STMOD_fnc_getTimeToLoseTarget;

	private _whileCondition = true;

	while { _whileCondition } do
	{
		scopeName "while";
		
		//False to stop the next iteration if the code below fails for any reason.
		_whileCondition = false;

		#ifdef DEBUG_MODE_ON
		if (STMOD_debug_targetLosing) then {
			private _message = (str _group + "  WILL LOSE TRACK OF:  " + str _targetUnit + "  IN: " + str ((_timeToLoseTarget - _targetAge) max 1) + " SECS.");
			_message remoteExecCall ["systemChat"];
		};
		#endif

		//Timer
		sleep ((_timeToLoseTarget - _targetAge) max 1);

		//Evaluation
		isNil 
		{
			private _units = units _group;


			private _lastSeenArray = [];

			//Get the last seen value.
			{
				_lastSeenArray pushBack ((_x targetKnowledge _targetUnit) select 2);
			} forEach _units;

			private _lastSeen = selectMax _lastSeenArray;


			_units = _units select { alive _x };

			
			// If a target is not force-revealed upon detection, _lastSeen can be still undefined (<0).
			if (_lastSeen < 0) then
			{
				_timeToLoseTarget = 0;
				{
					//Vision field check, because the AI doesn't see the target on its own yet.
					if ([_x, _targetUnit] call STMOD_fnc_checkVisionField) exitWith
					{
						_targetAge = 0;
						_timeToLoseTarget = TIME_BETWEEN_CHECKS;

						#ifdef DEBUG_MODE_ON
						if (STMOD_debug_targetLosing) then
						{
							private _message = (str _targetUnit + "  IN VISION FIELD OF:  " + str _group + "  , CAN'T BE FORGOTTEN.");
							_message remoteExecCall ["systemChat"];
						};
						#endif
					};
				} forEach _units;
			}
			else
			{
				_targetAge = time - _lastSeen;
				_timeToLoseTarget = [_group, _targetUnit, _targetRecord ] call STMOD_fnc_getTimeToLoseTarget;
			};

			//While condition
			if ( alive _targetUnit && _targetAge < _timeToLoseTarget && (count _units >= 1) ) then {
				_whileCondition = true;
			};

			//Forget the target and reset array fields before exitting.
			if (!_whileCondition) then {
				//_group ignoreTarget _targetUnit;
				_group forgetTarget _targetUnit;

				_targetRecord set [1, false]; //Detection state OFF.
				_targetRecord set [2, false]; //Semaphore state OFF.
				_targetRecord set [3, 0]; //knowsAbout value RESET.

				#ifdef DEBUG_MODE_ON
				if (STMOD_debug_targetLosing) then
				{
					private _message = (str _group + "  LOST TRACK OF:  " + str _targetUnit + ".");
					_message remoteExecCall ["systemChat"];
				};
				#endif
			};
		};
	};
};