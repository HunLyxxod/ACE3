/**
 * fn_moveToTempGroup_f.sqf
 * Moves a unit into a temporarly group and stores its original group to allow rejoining.
 * @Author: Glowbal
 *
 * @Arguments: [unit OBJECT, moveToTempGroup BOOL]
 * @Return: void
 * @PublicAPI: false
 */

private ["_unit","_moveTo","_previousGroup","_newGroup", "_currentGroup", "_switchToGroup"];
_unit = [_this, 0,ObjNull,[ObjNull]] call BIS_fnc_Param;
_moveTo = [_this, 1,false,[false]] call BIS_fnc_Param;

if (_moveTo) then {
	_previousGroup = group _unit;
	_newGroup = createGroup (side _previousGroup);
	[_unit] joinSilent _newGroup;
	_unit setvariable ["cse_previous_group_f",_previousGroup];
} else {
	_previousGroup = _unit getvariable "cse_previous_group_f";
	if (!isnil "_previousGroup") then {
		_currentGroup = group _unit;
		_unit setvariable ["cse_previous_group_f",nil];
		[_unit] joinSilent _previousGroup;
		if (count units _currentGroup == 0) then {
			deleteGroup _currentGroup;
		};
	};
};