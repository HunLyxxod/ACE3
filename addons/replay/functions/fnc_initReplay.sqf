#include "script_component.hpp"

[true] call EFUNC(spectator,setSpectator);

{
    if(isPlayer _x) then
    {
        hideObject _x;
    }
    else
    {
        deleteVehicle _x;
    };
}
forEach allUnits;