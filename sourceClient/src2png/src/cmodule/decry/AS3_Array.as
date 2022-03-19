// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//cmodule.decry.AS3_Array

package cmodule.decry
{
    import cmodule.decry.*;
    import flash.events.*;
    import flash.display.*;
    import flash.utils.*;
    import flash.text.*;
    import flash.net.*;
    import flash.system.*;

    internal function AS3_Array(_arg_1:String, _arg_2:int):*
    {
        var _local_6:CTypemap;
        var _local_7:int;
        var _local_8:Array;
        var _local_3:Array = [];
        if (((!(_arg_1)) || (!(_arg_1.length))))
        {
            return (_local_3);
        };
        var _local_4:Array = CTypemap.getTypesByNames(_arg_1);
        var _local_5:int;
        while (_local_5 < _local_4.length)
        {
            _local_6 = _local_4[_local_5];
            _local_7 = _local_6.typeSize;
            _local_8 = [];
            mstate.ds.position = _arg_2;
            _arg_2 = (_arg_2 + _local_7);
            while (_local_7)
            {
                _local_8.push(mstate.ds.readInt());
                _local_7 = (_local_7 - 4);
            };
            _local_3.push(_local_6.fromC(_local_8));
            _local_5++;
        };
        return (_local_3);
    }

}//package cmodule.decry

