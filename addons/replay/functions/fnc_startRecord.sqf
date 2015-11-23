#include "script_component.hpp"

private ["_handle", "_unitRegister"];

systemChat "Start recording";

_handle = "Replay" callExtension format ["startCapture %1", worldName];
_unitRegister = [];

SETMVAR(GVAR(frameNum), 0);
SETMVAR(GVAR(startTime), time);
SETMVAR(GVAR(firedEvents), []);

[{
    private ["_frameNum"];
    
    params ["_args", "_idPFH"];
    _args params ["_handle", "_unitRegister"];

    _frameNum = GETMVAR(GVAR(frameNum), 0);

    [_handle, _frameNum, _unitRegister] call FUNC(captureFrameData);
    _frameNum = _frameNum + 1;
    
    SETMVAR(GVAR(frameNum), _frameNum);
}, 0.5, [_handle, _unitRegister]] call CBA_fnc_addPerFrameHandler;