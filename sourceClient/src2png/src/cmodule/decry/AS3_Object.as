// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//cmodule.decry.AS3_Object

package cmodule.decry
{
    import cmodule.decry.*;
    import flash.events.*;
    import flash.display.*;
    import flash.utils.*;
    import flash.text.*;
    import flash.net.*;
    import flash.system.*;

    internal function AS3_Object(_arg_1:String, _arg_2:int):*
    {
        var _local_6:String;
        var _local_7:CTypemap;
        var _local_8:int;
        var _local_9:Array;
        var _local_3:Object = {};
        if (((!(_arg_1)) || (!(_arg_1.length))))
        {
            return (_local_3);
        };
        var _local_4:Array = _arg_1.split(/\s*[,\:]\s*/);
        var _local_5:int;
        while (_local_5 < _local_4.length)
        {
            _local_6 = _local_4[_local_5];
            _local_7 = CTypemap.getTypeByName(_local_4[(_local_5 + 1)]);
            _local_8 = _local_7.typeSize;
            _local_9 = [];
            mstate.ds.position = _arg_2;
            _arg_2 = (_arg_2 + _local_8);
            while (_local_8)
            {
                _local_9.push(mstate.ds.readInt());
                _local_8 = (_local_8 - 4);
            };
            _local_3[_local_6] = _local_7.fromC(_local_9);
            _local_5 = (_local_5 + 2);
        };
        return (_local_3);
    }

}//package cmodule.decry

