params ["_newUnit", "_oldUnit", "_respawn", "_respawnDelay"];

if (_newUnit getVariable "STMOD_stealthFlag" && !(clientOwner in [0,2])) then {

	_newUnit call STMOD_fnc_setupPlayerClient;
};