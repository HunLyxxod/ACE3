#include "script_component.hpp"

params ["_ratio"];

{
    if(!(isObjectHidden _x)) then
    {
        private ["_defaultFrame", "_prevKeyFrame", "_nextKeyFrame", "_pos", "_dir", "_right", "_up"];

        _defaultFrame = [[0, 0, 0], [0, 0, 0]];
        _prevKeyFrame = GETVAR(_x, GVAR(prevKeyFrame), _defaultFrame);
        _nextKeyFrame = GETVAR(_x, GVAR(nextKeyFrame), _defaultFrame);
        _prevKeyFrame params ["_prevPos", "_prevDir"];
        _nextKeyFrame params ["_nextPos", "_nextDir"];

        _pos = _prevPos vectorAdd ((_nextPos vectorDiff _prevPos) vectorMultiply _ratio);
        _dir = _prevDir vectorAdd ((_nextDir vectorDiff _prevDir) vectorMultiply _ratio);
        
        _x setPosASL _pos;
        _x setVectorDir (vectorNormalized _dir);
    };
}
forEach allUnits;