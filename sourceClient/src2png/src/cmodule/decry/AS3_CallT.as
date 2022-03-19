// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//cmodule.decry.AS3_CallT

package cmodule.decry
{
    import cmodule.decry.*;
    import flash.events.*;
    import flash.display.*;
    import flash.utils.*;
    import flash.text.*;
    import flash.net.*;
    import flash.system.*;

    internal function AS3_CallT(_arg_1:*, _arg_2:Object, _arg_3:String, _arg_4:int):*
    {
        return (_arg_1.apply(_arg_2, AS3_Array(_arg_3, _arg_4)));
    }

}//package cmodule.decry

