/*
	Description:
		Determines the time after which a group will forget a detected target.
		There are two ways to obtain the time value.
		Which will be used depends on whether knowsAbout command returns =0 or >0.

	Parameter(s):
		_group - the detecting group
		_targetUnit - the stealth unit
		_targetRecord - array returned by STMOD_fnc_registerTarget

	Returns:
		NUMBER - time to lose target
*/

params ["_group", "_targetUnit", "_targetRecord"];

	//knowsAbout command may return zero even if KnowsAboutChanged event reports >0
	private _knowsAboutActual = _group knowsAbout _targetUnit; 
	private _timeToLoseTarget = nil;

	if (_knowsAboutActual > 0) then
	{
		_timeToLoseTarget = STMOD_cfg_timeToLoseKnown findIf { _x#0 >= _knowsAboutActual };
		_timeToLoseTarget = (STMOD_cfg_timeToLoseKnown select _timeToLoseTarget) select 1;
	}
	else
	{
		private _knowsAboutEvent = _targetRecord select 3;
		_timeToLoseTarget = STMOD_cfg_timeToLoseUnknown findIf { _x#0 >= _knowsAboutEvent };
		_timeToLoseTarget = (STMOD_cfg_timeToLoseUnknown select _timeToLoseTarget) select 1;
	};

	_timeToLoseTarget;