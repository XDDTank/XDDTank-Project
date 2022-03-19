// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//cmodule.decry.AS3_Shim

package cmodule.decry
{
    import cmodule.decry.*;
    import flash.events.*;
    import flash.display.*;
    import flash.utils.*;
    import flash.text.*;
    import flash.net.*;
    import flash.system.*;

    internal function AS3_Shim(func:Function, thiz:Object, rt:String, tt:String, varargs:Boolean):int
    {
        var retType:CTypemap = CTypemap.getTypeByName(rt);
        var argTypes:Array = CTypemap.getTypesByNames(tt);
        var tm:CTypemap = new CProcTypemap(retType, argTypes, varargs);
        var id:int = tm.createC(function (... _args):*
        {
            return (func.apply(thiz, _args));
        })[0];
        return (id);
    }

}//package cmodule.decry

