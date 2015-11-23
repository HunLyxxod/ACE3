#include "script_component.hpp"

params ["_frame", "_unit", "_register"];
private ["_index"];

_index = -1;

{
    if(_x == _unit) then
    {
        _index = _forEachIndex;
    };
}
forEach _register;

if(_index == -1) then
{
    _register pushBack _unit;
    _index = (count _register) - 1;
    
    [_frame, _unit, _index] call FUNC(registerUnit);
};

_index;
