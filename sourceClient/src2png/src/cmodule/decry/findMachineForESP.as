// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//cmodule.decry.findMachineForESP

package cmodule.decry
{
    import cmodule.decry.gsetjmpMachine2ESPMap;
    import cmodule.decry.Machine;
    import cmodule.decry.*;
    import flash.events.*;
    import flash.display.*;
    import flash.utils.*;
    import flash.text.*;
    import flash.net.*;
    import flash.system.*;

    internal function findMachineForESP(_arg_1:int):Machine
    {
        var _local_2:Object;
        for (_local_2 in gsetjmpMachine2ESPMap)
        {
            if (gsetjmpMachine2ESPMap[_local_2] == _arg_1)
            {
                return (Machine(_local_2));
            };
        };
        return (null);
    }

}//package cmodule.decry

