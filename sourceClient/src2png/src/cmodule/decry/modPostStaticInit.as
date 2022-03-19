// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//cmodule.decry.modPostStaticInit

package cmodule.decry
{
    import flash.events.*;
    import flash.display.*;
    import flash.utils.*;
    import flash.text.*;
    import flash.net.*;
    import flash.system.*;

    public function modPostStaticInit():void
    {
        var _local_1:int;
        if (gpostStaticInits)
        {
            _local_1 = 0;
            while (_local_1 < gpostStaticInits.length)
            {
                var _local_2:* = gpostStaticInits;
                (_local_2[_local_1]());
                _local_1++;
            };
        };
    }

}//package cmodule.decry

