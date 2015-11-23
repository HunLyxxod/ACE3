#include "script_component.hpp"

params ["_handle", "_frame", "_unitRegister"];
private ["_numKeys", "_fireEvents", "_animEvents"];

{
    private ["_keyFrame"];
    
    _keyFrame = [[0, 0, 0], [0, 0, 0]];
    _keyFrame = GETVAR(_x, GVAR(nextKeyFrame), _keyFrame);
    SETVAR(_x, GVAR(prevKeyFrame), _keyFrame);
}
forEach allUnits;

_numKeys = parseNumber ("Replay" callExtension format ["getNumKeys %1", _frame]);
for "_i" from 1 to _numKeys do
{
    private ["_keyFrame", "_unit"];
    
    _keyFrame = call compile ("Replay" callExtension format ["getNextKeyFrame %1", _frame]);   
    _keyFrame params ["_id", "_pos", "_dir"];
    
    _unit = [_handle, _id, _unitRegister] call FUNC(getUnit);
    
    SETVAR(_unit, GVAR(nextKeyFrame), [ARR_2(_pos, _dir)]);
    _keyFrame = GETVAR(_unit, GVAR(nextKeyFrame), 0);
};

_numKeys = parseNumber ("Replay" callExtension format ["getNumFireEvents %1", _frame]);
_fireEvents = [];
for "_i" from 1 to _numKeys do
{
    private ["_event"];

    _event = call compile ("Replay" callExtension format ["getNextFireEvent %1", _frame]);
    _fireEvents pushBack _event;
};
SETMVAR(GVAR(fireEvents), _fireEvents);

_numKeys = parseNumber ("Replay" callExtension format ["getNumAnimEvents %1", _frame]);
_animEvents = [];
for "_i" from 1 to _numKeys do
{
    private ["_event"];

    _event = call compile ("Replay" callExtension format ["getNextAnimEvent %1", _frame]);
    _animEvents pushBack _event;
};
SETMVAR(GVAR(animEvents), _animEvents);

