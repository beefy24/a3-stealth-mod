/*
	Description:
		This script initializes all configuration variables for the stealth system.
		Use this as a config file.

	Parameter(s):
		NOTHING

	Returns:
		NOTHING
*/

#include "..\..\define.hpp"

/*
	---- STEALTH SETTINGS ----
*/

//SPOTTING
STMOD_cfg_semaphoreSleepTime = 0.5; //Wait time between processing KnowsAboutChanged events.
STMOD_cfg_spottingDistance = 500;
STMOD_cfg_spottingAngle = 88;
STMOD_cfg_headVisibilityTreshold = 0.66;
STMOD_cfg_bodyVisibilityTreshold = 0.62;
STMOD_cfg_spottingFalloffTime = 8; //Time after which the spotting meter starts decreasing.
STMOD_cfg_spottingFalloffSpeed = 0.25; //Amount per second.
STMOD_cfg_camouflageRange = [0.45, 0.85];

//FOOTSTEPS SOUND
STMOD_cfg_footstepSoundRange = 25;
STMOD_cfg_footstepDetectionChance = createHashMapFromArray [
	[["STAND", "stp"], 0.0], [["STAND", "wlk"], 0.30], [["STAND", "tac"], 0.40], [["STAND", "run"], 0.50], [["STAND", "eva"], 0.60],
	[["CROUCH", "stp"], 0.0], [["CROUCH", "wlk"], 0.20], [["CROUCH", "tac"], 0.30], [["CROUCH", "run"], 0.45], [["CROUCH", "eva"], 0.55],
	[["PRONE", "stp"], 0.0], [["PRONE", "run"], 0.15], [["PRONE", "spr"], 0.30], [["PRONE", "eva"], 0.35],
	[["UNDEFINED", "stp"], 0.0], [["UNDEFINED", "wlk"], 0.20], [["UNDEFINED", "run"], 0.20], [["UNDEFINED", "spr"], 0.35], //Swimming
	[["UNDEFINED", "default"], 0.17] //Ladder climbing
];
STMOD_cfg_footstepDistanceCoef = [[0, 0.6], [25, 0]]; //[[distanceClose, coefHigh], [distanceFar, coefLow]]

//TARGET LOSING
STMOD_cfg_timeToLoseKnown = [[1.35, 40], [ 3, 60], [ 4, 80]]; //Time to lose if a target is fully detected. [[knowsAboutValue, timetoLose]]
STMOD_cfg_timeToLoseUnknown = [[ 0.5, 20], [4, 30]]; //Time to lose if a target is not fully detected.


/*
	---- DEBUG SETTINGS ----

	Before using these options, make sure DEBUG_MODE_ON is defined in define.hpp.
	STMOD_debug_ variables toggle debugging outputs to the in-game system chat.
	STMOD_enable_ variables toggle parts of the system, but don't affect debug outputs.
*/

//COMMON
STMOD_enable_knowsAboutEvent = true;
STMOD_debug_knowsAboutEvent = 0; //0 disabled; 1 evaluated events only; 2 evaluated+skipped events.
STMOD_debug_targetDetected = true;

//SPOTTING
STMOD_enable_spotting = true;
STMOD_debug_spottingAngle = false;
STMOD_debug_visibility = false;
STMOD_debug_spottingMeter = true;
STMOD_debug_camouflage = false;

//FOOTSTEPS SOUND
STMOD_enable_footstepDetection = true;
STMOD_debug_footstepDetection = true;
STMOD_debug_stanceChanged = false;

//WEAPONS
STMOD_debug_firedManEvent = true;
STMOD_debug_weaponChanged = true;
STMOD_debug_explodeEvent = true;

//TARGET LOSING
STMOD_debug_targetLosing = true;


/*
	---- BROADCAST VARIABLES ----
*/

#ifdef DEBUG_MODE_ON
publicVariable "STMOD_debug_weaponChanged";
#endif


/*
	---- PROCESS VARIABLES ----
*/

//Footsteps noise detection coefficient
STMOD_footstepDistanceCoef_a =
(
	(STMOD_cfg_footstepDistanceCoef#1#1 - STMOD_cfg_footstepDistanceCoef#0#1) /
	(STMOD_cfg_footstepDistanceCoef#1#0 - STMOD_cfg_footstepDistanceCoef#0#0)
);

STMOD_footstepDistanceCoef_b =
(
	STMOD_cfg_footstepDistanceCoef#0#1 + (-(STMOD_cfg_footstepDistanceCoef#0#0)) * STMOD_footstepDistanceCoef_a
);

STMOD_footstepDistanceCoef_a = [STMOD_footstepDistanceCoef_a, 4] call BIS_fnc_cutDecimals;
STMOD_footstepDistanceCoef_b = [STMOD_footstepDistanceCoef_b, 4] call BIS_fnc_cutDecimals;