#include "script_component.hpp"

params ["_frame", "_unit", "_index"];

SETVAR(_unit, GVAR(unitIndex), _index);
"Replay" callExtension format ["registerUnit %1 %2 %3", _frame, _index, typeOf _unit];

_unit addEventHandler ["Fired", 
{
    params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile"];
    private ["_firedEvents", "_unitIndex"];
    
    _unitIndex = GETVAR(_unit, GVAR(unitIndex), -1);
    _firedEvents = GETMVAR(GVAR(firedEvents), []);
    _firedEvents pushBack [time, _unitIndex, typeOf _projectile, getPosASL _projectile, velocity _projectile];
    SETMVAR(GVAR(firedEvents), _firedEvents);
}];

_unit addEventHandler ["AnimChanged",
{
    params ["_unit", "_anim"];
    private ["_animEvents", "_unitIndex"];
    
    _unitIndex = GETVAR(_unit, GVAR(unitIndex), -1);
    _animEvents = GETMVAR(GVAR(animEvents), []);
    _animEvents pushBack [time, _unitIndex, _anim];
    SETMVAR(GVAR(animEvents), _animEvents);
}];
