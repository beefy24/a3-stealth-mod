/*
	Description:
		This script adds an AnimStateChanged event handler to a stealth unit.
		It updates "camouflageCoef" and footsteps detection chance every time
		player's animation state changes.
	
	Parameter(s):
		_unit
	
	Returns:
		NUMBER - index of the new EH, -1 if failed
*/

#include "..\..\define.hpp"

STMOD_const_paces = ["stp", "wlk", "tac", "run", "eva", "spr"];

params ["_unit"];


_unit addEventHandler ["AnimStateChanged", 
{
	params ["_unit", "_anim"];

	/*
		---- FOOTSTEPS SOUND ----
	*/
	private _stance = stance _unit;

	private _pace = _anim select [9, 3];
	if (!(_pace in STMOD_const_paces)) then {_pace = "default";};

	private _detectionChance = STMOD_cfg_footstepDetectionChance getOrDefault [ [_stance, _pace], 0];

	_unit setVariable ["STMOD_footstepDetectionChance", _detectionChance];

	#ifdef DEBUG_MODE_ON
	if (STMOD_debug_stanceChanged) then
	{
		private _message = (str _unit + "  PACE: " + str _pace + "  STANCE: " + str _stance + "  DETECTION CHANCE: " + str _detectionChance + ".");
		_message remoteExecCall ["hintSilent"];
	};
	#endif


	/*
		---- CAMOUFLAGE ----
	*/
	#ifdef CAMOUFLAGE_ON

	private _height = (_unit selectionPosition "pelvis") select 2;
	_height = ((_height max 0.1) min 1);

	private _camouflageCoef = [STMOD_cfg_camouflageRange#0, STMOD_cfg_camouflageRange#1, _height] call BIS_fnc_lerp;

	_unit setUnitTrait ["camouflageCoef", _camouflageCoef]; 

	#ifdef DEBUG_MODE_ON
	if (STMOD_debug_camouflage) then
	{
		private _message =  (str _unit + "  CAMOUFLAGE: " + str _camouflageCoef + "  PELVIS: " + str _height + ".");
		_message remoteExecCall ["systemChat"];
	};
	#endif

	#endif
}];