/*
	Description:
		Waits for synchronization of variables sent from the server.

	Target machine:
		Client
	
	Parameter(s):
		NOTHING
	
	Returns:
		NOTHING
*/

#include "..\..\define.hpp"

if (!isServer) then {
	#ifdef DEBUG_MODE_ON
	waitUntil { !(isNil "STMOD_debug_weaponChanged") };
	#endif
};