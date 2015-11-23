#include "script_component.hpp"

params ["_handle", "_unitRegister", "_minTime", "_maxTime"];
private ["_fireEvents", "_animEvents"];

_fireEvents = GETMVAR(GVAR(fireEvents), []);
{
    _x params ["_time", "_unitIndex", "_type", "_position", "_velocity"];
    
    if(_time > _minTime && _time <= _maxTime) then
    {
        private ["_projectile"];
        systemChat format ["Unit %1 Fire: %2 %3 %4", _unitIndex, _type, _position, _velocity];
        
        _projectile = createVehicle [_type, _position, [], 0, "NONE"];
        _projectile setVectorDir (vectorNormalized _velocity);
        _projectile setVelocity _velocity;
    };
}
forEach _fireEvents;

_animEvents = GETMVAR(GVAR(animEvents), []);
{
    _x params ["_time", "_unitIndex", "_anim"];
    
    if(_time > _minTime && _time <= _maxTime) then
    {
        private ["_unit"];
    
        _unit = [_handle, _unitIndex, _unitRegister] call FUNC(getUnit);
        _unit playMove _anim;
    };
}
forEach _animEvents;