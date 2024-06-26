/*
	Description:
		This script adds Hit and Suppressed event handlers to the provided unit.
		These events are used to detect firing stealth units.
	
	Parameter(s):
		_unit
	
	Returns:
		NOTHING
*/

#include "..\..\define.hpp"

params [
	["_unit", objNull, [objNull]]
];

if (_unit isEqualTo objNull) exitWith { };

private _eh1 = _unit addEventHandler ["Suppressed", {
	params ["_unit", "_distance", "_shooter", "_instigator", "_ammoObject", "_ammoClassName", "_ammoConfig"];

	//Ignore the event when the _instigator is inside a vehicle.
	if ( !(objectParent _instigator isEqualTo objNull)) exitWith {};
	
	[group _unit, _instigator, "Suppressed"] call STMOD_fnc_targetDetected;
}];

private _eh2 = _unit addEventHandler ["Hit", {
	params ["_unit", "_source", "_damage", "_instigator"];

	if ( !(objectParent _instigator isEqualTo objNull)) exitWith {};

	[group _unit, _instigator, "Hit"] call STMOD_fnc_targetDetected;
}];