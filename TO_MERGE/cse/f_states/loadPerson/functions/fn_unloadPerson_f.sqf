/**
 * fn_unloadPerson_f.sqf
 * @Descr: Unload a person from a vehicle
 * @Author: Glowbal
 *
 * @Arguments: [caller OBJECT, unit OBJECT]
 * @Return: BOOL Returns true if succesfully unloaded person
 * @PublicAPI: true
 */

#define GROUP_SWITCH_ID "cse_fnc_loadPerson_F"

private ["_caller", "_unit","_vehicle", "_loaded"];
_caller = [_this, 0, ObjNull,[ObjNull]] call BIS_fnc_Param;
_unit = [_this, 1, ObjNull,[ObjNull]] call BIS_fnc_Param;
_vehicle = vehicle _unit;

if (_vehicle == _unit) exitwith {false;};
if !(speed _vehicle <1 && (((getpos _vehicle) select 2) < 2)) exitwith {false;};
if (!([_caller] call cse_fnc_isAwake)) exitwith{false;};

moveOut _unit;
unassignVehicle _unit;
if (!alive _unit) then {
	_unit action ["Eject", vehicle _unit];
};

[_unit, false, GROUP_SWITCH_ID, side group _caller] call cse_fnc_switchToGroupSide_f;

_loaded = _vehicle getvariable ["cse_loaded_persons_F",[]];
_loaded = _loaded - [_unit];
_vehicle setvariable ["cse_loaded_persons_F",_loaded,true];

if (!([_unit] call cse_fnc_isAwake)) then {
	_handle = [_unit,_vehicle] spawn {
		private ["_unit","_vehicle"];
		_unit = _this select 0;
		_vehicle = _this select 1;
		waituntil {vehicle _unit != _vehicle};
		[_unit,([_unit] call cse_fnc_getDeathAnim)] call cse_fnc_broadcastAnim;
		[format["Unit should move into death anim: %1", _unit]] call cse_fnc_Debug;
	};
} else {
	if ([_unit] call cse_fnc_isArrested) then {
		_handle = [_unit,_vehicle] spawn {
			_unit = _this select 0;
			_vehicle = _this select 1;
			waituntil {vehicle _unit != _vehicle};
			[_unit,"UnaErcPoslechVelitele2",true] call cse_fnc_broadcastAnim;
			[format["Unit should move into arrested anim: %1", _unit]] call cse_fnc_Debug;
		};
	} else {
		[format["Unit should move into normal anim: %1", _unit]] call cse_fnc_Debug;
	};
};

true;