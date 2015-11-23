#include "script_component.hpp"

[] spawn
{
    waitUntil { alive player };
    "Replay" callExtension "init";
    player addAction ["Start recording", FUNC(startRecord)];
    player addAction ["Load recording", FUNC(loadRecord)];
    
    // [player] call BIS_fnc_traceBullets;
    // player addEventHandler ["AnimChanged", { systemChat format ["AnimChanged: %1", _this select 1]; }];
    // player addEventHandler ["Fired", { systemChat format ["Fired: %1 %2 %3 %4 %5", _this select 1, _this select 2, _this select 3, _this select 4, _this select 5]; }];
    
    //[{
    //    systemChat format ["Player: (%1-%2) %3", vectorDir player, eyeDirection player, vectorUp player];
    //}, 5.0, []] call CBA_fnc_addPerFrameHandler;
}