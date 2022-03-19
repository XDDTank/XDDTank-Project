// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//cmodule.decry.CIntTypemap

package cmodule.decry
{
    import cmodule.decry.*;
    import flash.events.*;
    import flash.display.*;
    import flash.utils.*;
    import flash.text.*;
    import flash.net.*;
    import flash.system.*;

    internal class CIntTypemap extends CTypemap 
    {


        override public function fromC(_arg_1:Array):*
        {
            return (int(_arg_1[0]));
        }

        override public function createC(_arg_1:*, _arg_2:int=0):Array
        {
            return ([int(_arg_1)]);
        }


    }
}//package cmodule.decry

