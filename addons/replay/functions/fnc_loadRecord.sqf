#include "script_component.hpp"

private ["_handle"];

systemChat "Load recording";

_handle = "Replay" callExtension format ["loadRecord %1", worldName];

[{
    private ["_ready"];
    
    params ["_args", "_idPFH"];
    _args params ["_handle"];
    
    _ready = "Replay" callExtension format ["recordReady %1", _handle];
    if (_ready == "true") then
    {   
        [private "_frame"];
        
        [_idPFH] call CBA_fnc_removePerFrameHandler;
        
        _frame = "Replay" callExtension format ["loadFrame %1 0", _handle];
        _unitRegister = [];
        
        SETMVAR(GVAR(frameNum), 0);
        SETMVAR(GVAR(frame), _frame);
        SETMVAR(GVAR(currentTime), 0);
        SETMVAR(GVAR(lastCallRealTime), time);
        SETMVAR(GVAR(nextFrameTime), 0);
        SETMVAR(GVAR(prevFrameTime), 0);
        
        call FUNC(initReplay);
        
        [{
            private ["_frame", "_frameNum", "_frameReady", "_currentTime", "_lastCallRealTime", "_nextFrameTime", "_prevFrameTime", "_lastCallTime", "_ratio"];
            
            params ["_args", "_idPFH"];
            _args params ["_handle", "_unitRegister"];
            
            _currentTime = GETMVAR(GVAR(currentTime), 0);
            _lastCallRealTime = GETMVAR(GVAR(lastCallRealTime), 0);
            _nextFrameTime = GETMVAR(GVAR(nextFrameTime), 0);
            _prevFrameTime = GETMVAR(GVAR(prevFrameTime), 0);
            _lastCallTime = _currentTime;
            
            if(_currentTime < _nextFrameTime) then
            {
                _currentTime = _currentTime + (time - _lastCallRealTime);
                SETMVAR(GVAR(lastCallRealTime), time);
                SETMVAR(GVAR(currentTime), _currentTime);
            };
            
            if(_currentTime >= _nextFrameTime) then
            {
                _frame = GETMVAR(GVAR(frame), 0);
                
                if(_frame == "0") then
                {
                    "Replay" callExtension format ["closeRecord %1", _handle];
                    [_idPFH] call CBA_fnc_removePerFrameHandler;
                }
                else
                {
                    _frameReady = "Replay" callExtension format ["waitFrame %1", _frame];
                    if (_frameReady == "true") then
                    {
                        [_handle, _frame, _unitRegister] call FUNC(readFrame);
                        
                        _prevFrameTime = _nextFrameTime;
                        _nextFrameTime = parseNumber ("Replay" callExtension format ["getFrameTime %1", _frame]);
                        SETMVAR(GVAR(nextFrameTime), _nextFrameTime);
                        SETMVAR(GVAR(prevFrameTime), _prevFrameTime);
                        
                        _frameNum = (GETMVAR(GVAR(frameNum), 0)) + 1;
                        _frame = "Replay" callExtension format ["loadFrame %1 %2", _handle, _frameNum];
                        
                        // TEMP !!!
                        if(_frame == "0") then
                        {
                            _frameNum = 0;
                            _frame = "Replay" callExtension format ["loadFrame %1 %2", _handle, _frameNum];
                            _currentTime = 0;
                            _nextFrameTime = 0;
                            _prevFrameTime = 0;
                            SETMVAR(GVAR(currentTime), _currentTime);
                            SETMVAR(GVAR(nextFrameTime), _nextFrameTime);
                            SETMVAR(GVAR(prevFrameTime), _prevFrameTime);
                        };
                        // TEMP !!!
                        
                        SETMVAR(GVAR(frameNum), _frameNum);
                        SETMVAR(GVAR(frame), _frame);
                    };
                };
            };
            
            if(_nextFrameTime == _prevFrameTime) then
            {
                _ratio = 1.0;
            }
            else
            {
                _ratio = (_currentTime - _prevFrameTime) / (_nextFrameTime - _prevFrameTime);
            };
            [_ratio] call FUNC(interpolate);
            [_handle, _unitRegister, _lastCallTime, _currentTime] call FUNC(processEvents);
        }, 0, [_handle, _unitRegister]] call CBA_fnc_addPerFrameHandler;
    };
}, 0.5, [_handle]] call CBA_fnc_addPerFrameHandler;