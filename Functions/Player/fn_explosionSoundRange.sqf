/*
	Description:
		Calculates the sound range of an explosion based on its magnitude.

		The function below mimics the original Arma 3 detection distances.
	
		_magnitude(x)		_distance(y)		WEAPON
		8					~30					Grenade
		80					~100				GL HE
		150					~187.5				PG32V

		y = ax^2 + bx + c
	
	Parameter(s):
		_magnitude: NUMBER - 'hit' config property from the ammo class

	Returns:
		NUMBER
*/

params ["_magnitude"];

private _distance = 0.002 * _magnitude^2 + 0.80 * _magnitude + 23.47;

_distance;