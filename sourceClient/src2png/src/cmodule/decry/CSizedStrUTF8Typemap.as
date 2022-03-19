// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//cmodule.decry.CSizedStrUTF8Typemap

package cmodule.decry
{
    import cmodule.decry.*;
    import flash.events.*;
    import flash.display.*;
    import flash.utils.*;
    import flash.text.*;
    import flash.net.*;
    import flash.system.*;

    internal class CSizedStrUTF8Typemap extends CTypemap 
    {


        override public function fromC(_arg_1:Array):*
        {
            mstate.ds.position = _arg_1[0];
            return (mstate.ds.readUTFBytes(_arg_1[1]));
        }

        override public function get typeSize():int
        {
            return (8);
        }


    }
}//package cmodule.decry

