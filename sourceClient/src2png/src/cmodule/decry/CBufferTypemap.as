﻿// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//cmodule.decry.CBufferTypemap

package cmodule.decry
{
    import cmodule.decry.*;
    import flash.events.*;
    import flash.display.*;
    import flash.utils.*;
    import flash.text.*;
    import flash.net.*;
    import flash.system.*;

    internal class CBufferTypemap extends CTypemap 
    {


        override public function destroyC(_arg_1:Array):void
        {
            CBuffer.free(_arg_1[0]);
        }

        override public function createC(_arg_1:*, _arg_2:int=0):Array
        {
            var _local_3:CBuffer = _arg_1;
            _local_3.reset();
            return ([_local_3.ptr]);
        }


    }
}//package cmodule.decry

