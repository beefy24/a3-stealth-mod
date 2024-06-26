/*
	Description:
		This script adds a FiredMan event handler to a stealth unit.
		When triggered, it checks if there are nearby enemies that could hear the sound.
		Placed explosives, like satchels or mines, and mounted weapons are excluded.

	Parameter(s):
		_unit

	Returns:
		NUMBER - index of the new event handler, -1 if failed
*/

#include "..\..\define.hpp"

params ["_unit"];


_unit addEventHandler ["FiredMan", {
	params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_vehicle"];

	//Exclude mounted weapons.
	if ( !(_vehicle isEqualTo objNull) ) exitWith {};

	scopeName "eventHandler";

	private _audibleFire = nil;
	private _gunshotSoundRange = 0;

	//Classic firearm?
	if ("B_" in _ammo) then
	{
		_gunshotSoundRange = _unit getVariable "STMOD_weaponSoundRange";
	}
	else
	{
		//Only grenades/rockets, not mines/satchels.
		if (_weapon == "Put") then { breakOut "eventHandler"; };
		
		_audibleFire = getNumber (configfile >> "CfgAmmo" >> _ammo >> "audibleFire");
		_gunshotSoundRange =  _audibleFire call STMOD_fnc_weaponSoundRange;


		_projectile addEventHandler ["Explode",
		{
			params ["_projectile", "_pos", "_velocity"];
		
			private _unit = getShotParents _projectile select 1;

			private _magnitude = getNumber (configfile >> "CfgAmmo" >> (typeOf _projectile) >> "hit");
			private _explosionSoundRange = _magnitude call STMOD_fnc_explosionSoundRange;
	
			#ifdef DEBUG_MODE_ON
			if (STMOD_debug_explodeEvent) then
			{
				private _message = ("EXPLOSION FROM:  " + str _unit + "  AT: " + str time + "  MAGNITUDE: " + str _magnitude + "  SOUND RANGE: " + str _explosionSoundRange + ".");
				_message remoteExecCall ["systemChat"];
			};
			#endif

			//Find nearby enemies who can hear the explosion.
			private _targets = (ASLToAGL _pos) nearEntities [["CAManBase", "LandVehicle", "Ship"], _explosionSoundRange];
			{
				if (_x getVariable ["STMOD_enemyFlag", false]) then {
					[group _x, _unit, "Explode"] call STMOD_fnc_targetDetected;
				};
				
			} forEach _targets;
		}];
	};
	
	#ifdef DEBUG_MODE_ON
	if (STMOD_debug_firedManEvent) then
	{
		private _message = (str _unit + "  FIRED AT: " + str time + "  SOUND RANGE: " + str _gunshotSoundRange + ".");
		_message remoteExecCall ["hintSilent"];
	};
	#endif
	
	//Find nearby enemies who can hear the gunshot.
	private _targets = _unit nearEntities [["CAManBase", "LandVehicle", "Ship"], _gunshotSoundRange];
	{
		if (_x getVariable ["STMOD_enemyFlag", false]) then {
			[group _x, _unit, "FiredMan"] call STMOD_fnc_targetDetected;
		};
		
	} forEach _targets;
}];