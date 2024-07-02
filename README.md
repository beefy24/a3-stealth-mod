# Stealth for Arma 3
This is an experimental stealth mod for Arma 3 that partially replaces the original detection system and allows customization of AI behavior. It is written as a scenario script that can be modified and integrated into a mission. Considering all the limitations of Arma 3, I have decided to stop developing this mod. However, some of you may still find it useful for creating small-scale singleplayer or co-op missions.

## Features
* Custom spotting and hearing
* Adjustable gun and explosion sound range
* Adjustable time to lose a target
* Camouflage affected by player's stance
* Multiplayer compatibility [*](#issues)

## Installation
Arma 3 version 2.18 or later is required (currently available in the [Development Build](https://dev.arma3.com/dev-branch)).

To install the mod, download this repository, and move the files into a mission directory:

```
C:\Users\USERNAME\Documents\Arma 3\missions\MISSION_DIRECTORY
```

## Configuration
To setup a stealth unit, put this line into the unit's *Init field* in the Eden editor: 

```sqf
this setVariable ["STMOD_stealthFlag", true];
```

To setup enemy units, call this function from *initServer.sqf*:

```sqf
opfor call STMOD_fnc_setupEnemy; //For a side
groupName call STMOD_fnc_setupEnemy; //For a single group
```

It is best to split enemy units into small groups of 1 to 3 units.

Configuration variables are located in `Functions\Init\initSettings.sqf` and in `define.hpp`.

## Issues
1. AI-controlled stealth squadmates in multiplayer are not supported. To avoid issues, do not add the `STMOD_stealthFlag` to any friendly AI units in multiplayer scenarios. Or disable AI for all playable characters by adding `disabledAI=1;` in *Description.ext* file.

2. On a listen server, the hosting player (admin) should avoid exiting the game and switching units. If the admin needs to switch a unit, restart the game.

(The cause of issues 1 and 2 is that the mod currently cannot handle locality changes of stealth units.)

3. In the current A3 Development Build, the [ignoreTarget](https://community.bistudio.com/wiki/ignoreTarget) command causes freezing when used on a player in a vehicle. This issue has been temporarily resolved by repeatedly calling the [forgetTarget](https://community.bistudio.com/wiki/forgetTarget) command. While not ideal,  it produces a similar effect.

4. Grenade explosions are sometimes not registered by the event handler on the server.

5. Silenced weapons don't trigger firedMan event on a listen server if the unit is far from the hosting player.
