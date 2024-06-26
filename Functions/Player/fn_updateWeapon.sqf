/*
	Description:
		Updates player's weapon sound range value based on the current weapon,
		suppressor and loaded ammunition.

	Target machine:
		Client or server (depending on the object locality).

	Parameter(s):
		_unit

	Returns:
		NOTHING
*/

#include "..\..\define.hpp"

params [ "_unit" ];

private _weapon = currentWeapon _unit;
private _magazine = currentMagazine _unit;
private _silencer = (_unit weaponAccessories _weapon) select 0;

if ( !([_magazine, _silencer] isEqualTo (_unit getVariable ["STMOD_oldWeapon", ["undef", "undef"]])) ) then {

	_unit setVariable ["STMOD_oldWeapon", [_magazine, _silencer]];
	
	private _ammo = getText (configfile >> "CfgMagazines" >> _magazine >> "ammo");
	private _audibleFire = getNumber (configfile >> "CfgAmmo" >> _ammo >> "audibleFire");
	
	if (_silencer != "") then
	{
		//private _silencerAudible = getNumber (configfile >> "CfgWeapons" >> _silencer >> "ItemInfo" >> "AmmoCoef" >> "audibleFire");
		_audibleFire = _audibleFire * 0.1;
	};

	private _weaponSoundRange = _audibleFire call STMOD_fnc_weaponSoundRange;

	_unit setVariable ["STMOD_weaponSoundRange", _weaponSoundRange, STMOD_serverID];

	#ifdef DEBUG_MODE_ON
	if (STMOD_debug_weaponChanged) then
	{
		private _message = (str _unit + "  WEAPON: " + str _weapon + "  SUPPRESSOR: " + str _silencer + "  AUDIBLE: " + str _audibleFire + "  SOUND RANGE: " + str _weaponSoundRange + ".");
		_message remoteExecCall ["systemChat"];
	};
	#endif
};