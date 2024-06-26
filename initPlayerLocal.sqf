params ["_player", "_didJIP"];

call STMOD_fnc_syncSettings;

if (_player getVariable "STMOD_stealthFlag" && !(clientOwner in [0,2])) then {

	_player call STMOD_fnc_setupPlayerClient;
};