#include "script_component.hpp"

params ["_handle", "_unitIndex", "_register"];
private ["_unit"];

_unit = nil;
if(_unitIndex < count _register) then
{
    _unit = _register select _unitIndex;
};

if(isNil "_unit") then
{
    private ["_unitType"];
    
    _unitType = call compile ("Replay" callExtension format ["getUnitData %1 %2", _handle, _unitIndex]);
    _unit = group player createUnit [_unitType, [0, 0, 0], [], 0, "NONE"];   
    _register set [_unitIndex, _unit];
    
    _unit disableAI "MOVE";
    _unit disableAI "FSM";
    _unit disableAI "ANIM";
};

_unit;