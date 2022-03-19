// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//cmodule.decry.CRefTypemap

package cmodule.decry
{
    import cmodule.decry.*;
    import flash.events.*;
    import flash.display.*;
    import flash.utils.*;
    import flash.text.*;
    import flash.net.*;
    import flash.system.*;

    internal class CRefTypemap extends CTypemap 
    {

        private var subtype:CTypemap;

        public function CRefTypemap(_arg_1:CTypemap)
        {
            this.subtype = _arg_1;
        }

        override public function fromC(_arg_1:Array):*
        {
            var _local_2:int = _arg_1[0];
            var _local_3:int;
            while (_local_3 < this.subtype.ptrLevel)
            {
                mstate.ds.position = _local_2;
                _local_2 = mstate.ds.readInt();
                _local_3++;
            };
            return (this.subtype.readValue(_local_2));
        }

        override public function createC(_arg_1:*, _arg_2:int=0):Array
        {
            return (null);
        }


    }
}//package cmodule.decry

