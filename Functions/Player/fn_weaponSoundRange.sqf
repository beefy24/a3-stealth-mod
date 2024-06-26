/*
	Description:
		Calculates the sound range of a gunshot based on its intensity.
		
		The function below mimics the original Arma 3 detection distances.

		_intensity(x)		_distance(y)		WEAPON		NOTE
		120					~850				srifle		Large caliber
		40					~450				arifle
		30					~350				hgun
		0.05				~15					Throw 		Frag grenade

		y = ax^2 + bx + c

	Parameter(s):
		_intensity: NUMBER - 'audibleFire' config property from the ammo class

	Returns:
		NUMBER
*/

params ["_intensity"];

private _distance = -0.0483*_intensity^2 + 	12.7697*_intensity + 13.7365;

_distance;