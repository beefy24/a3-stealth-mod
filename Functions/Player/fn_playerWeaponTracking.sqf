/*
	Description:
		This script adds event handlers to a stealth unit locally for
		monitoring player's active weapon.
	
	Target machine:
		Client or server (depending on the object locality).
	
	Parameter(s):
		_unit
	
	Returns:
		NOTHING
*/

#include "..\..\define.hpp"

params ["_unit"];


//EH1 SlotItemChanged
private _oldIndex1 = _unit getVariable ["STMOD_eh1c", -1];
private _info1 = _unit getEventHandlerInfo ["SlotItemChanged", _oldIndex1];

if ( !(_info1#0) ) then {
	private _newIndex = _unit addEventHandler ["SlotItemChanged", {
		params ["_unit", "_name", "_slot", "_assigned", "_weapon"];
		
		_unit call STMOD_fnc_updateWeapon;
	}];

	_unit setVariable ["STMOD_eh1c", _newIndex];
};


//EH2 WeaponChanged
private _oldIndex2 = _unit getVariable ["STMOD_eh2c", -1];
private _info2 = _unit getEventHandlerInfo ["WeaponChanged", _oldIndex2];

if ( !(_info2#0) ) then {
	private _newIndex = _unit addEventHandler ["WeaponChanged", {
		params ["_unit", "_oldWeapon", "_newWeapon", "_oldMode", "_newMode", "_oldMuzzle", "_newMuzzle", "_turretIndex"];

		_unit call STMOD_fnc_updateWeapon;
	}];

	_unit setVariable ["STMOD_eh2c", _newIndex];
};


//EH3 Reloaded
private _oldIndex3 = _unit getVariable ["STMOD_eh3c", -1];
private _info3 = _unit getEventHandlerInfo ["Reloaded", _oldIndex3];

if ( !(_info3#0) ) then {
		private _newIndex =_unit addEventHandler ["Reloaded", {
			params ["_unit", "_weapon", "_muzzle", "_newMagazine", "_oldMagazine"];

			_unit call STMOD_fnc_updateWeapon;
		}];

	_unit setVariable ["STMOD_eh3c", _newIndex];
};


//EH4 InventoryClosed
private _oldIndex4 = _unit getVariable ["STMOD_eh4c", -1];
private _info4 = _unit getEventHandlerInfo ["InventoryClosed", _oldIndex4];

if ( !(_info4#0) ) then {
		private _newIndex = _unit addEventHandler ["InventoryClosed", {
			params ["_unit", "_container"];

			_unit call STMOD_fnc_updateWeapon;
		}];

	_unit setVariable ["STMOD_eh4c", _newIndex];
};