#include "script_component.hpp"

params ["_handle", "_frameNumber", "_unitRegister"];
private ["_frame", "_startTime", "_firedEvents", "_animEvents"];

//systemChat "Capture frame";

_startTime = GETMVAR(GVAR(startTime), 0);
_frame = "Replay" callExtension format ["startFrame %1 %2 %3", _handle, _frameNumber, time - _startTime];

{
    private ["_pos", "_dir", "_id"];
    _id = [_frame, _x, _unitRegister] call FUNC(getUnitIndex);
    _pos = getPosASL _x;
    _dir = vectorDir _x;
    
    "Replay" callExtension format ["keyFrame %1 %2 %3 %4", _frame, _id, _pos, _dir];
}
forEach allUnits;

_firedEvents = GETMVAR(GVAR(firedEvents), []);
{
    _x params ["_time", "_unitIndex", "_type", "_pos", "_velocity"];
    "Replay" callExtension format ["fireEvent %1 %2 %3 %4 %5 %6", _frame, _time - _startTime, _unitIndex, _pos, _velocity, _type];
}
forEach _firedEvents;
SETMVAR(GVAR(firedEvents), []);

_animEvents = GETMVAR(GVAR(animEvents), []);
{
    _x params ["_time", "_unitIndex", "_anim"];
    "Replay" callExtension format ["animEvent %1 %2 %3 %4", _frame, _time - _startTime, _unitIndex, _anim];
}
forEach _animEvents;
SETMVAR(GVAR(animEvents), []);  

"Replay" callExtension format ["endFrame %1", _frame];