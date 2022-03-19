// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//cmodule.decry.AS3_ObjectValue

package cmodule.decry
{
    import cmodule.decry.*;
    import flash.events.*;
    import flash.display.*;
    import flash.utils.*;
    import flash.text.*;
    import flash.net.*;
    import flash.system.*;

    internal function AS3_ObjectValue(_arg_1:Object, _arg_2:String, _arg_3:int):void
    {
        var _local_6:String;
        var _local_7:CTypemap;
        var _local_8:int;
        var _local_9:Array;
        var _local_10:int;
        if (((!(_arg_2)) || (!(_arg_2.length))))
        {
            return;
        };
        var _local_4:Array = _arg_2.split(/\s*[,\:]\s*/);
        var _local_5:int;
        while (_local_5 < _local_4.length)
        {
            _local_6 = _local_4[_local_5];
            _local_7 = CTypemap.getTypeByName(_local_4[(_local_5 + 1)]);
            mstate.ds.position = _arg_3;
            _local_8 = mstate.ds.readInt();
            _arg_3 = (_arg_3 + 4);
            _local_9 = _local_7.createC(_arg_1[_local_6]);
            mstate.ds.position = _local_8;
            _local_10 = 0;
            while (_local_10 < _local_9.length)
            {
                mstate.ds.writeInt(_local_9[_local_10]);
                _local_10++;
            };
            _local_5 = (_local_5 + 2);
        };
    }

}//package cmodule.decry

