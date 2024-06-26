//Machine ID for targeting a server.
if (isMultiplayer) then { STMOD_serverID=2 } else { STMOD_serverID=0 };

if (isServer) then {
	call STMOD_fnc_initSettings;

	//Executed on the server in MP when a player joins a game or respawns.
	addMissionEventHandler ["OnUserSelectedPlayer", {
		params ["_networkId", "_playerObject", "_attempts"];
		
		if (_playerObject getVariable "STMOD_stealthFlag") then {
		
			_playerObject call STMOD_fnc_setupPlayerServer;	

			private _machineID = (getUserInfo _networkId)#1;

			if (_machineID == 2) then {
				_playerObject call STMOD_fnc_setupPlayerClient;
			};
		};
	}];
};