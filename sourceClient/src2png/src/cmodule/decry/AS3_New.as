﻿// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//cmodule.decry.AS3_New

package cmodule.decry
{
    import cmodule.decry.log;
    import cmodule.decry.*;
    import flash.events.*;
    import flash.display.*;
    import flash.utils.*;
    import flash.text.*;
    import flash.net.*;
    import flash.system.*;

    internal function AS3_New(_arg_1:*, _arg_2:Array):*
    {
        switch (_arg_2.length)
        {
            case 0:
                return (new (_arg_1)());
            case 1:
                return (new _arg_1(_arg_2[0]));
            case 2:
                return (new _arg_1(_arg_2[0], _arg_2[1]));
            case 3:
                return (new _arg_1(_arg_2[0], _arg_2[1], _arg_2[2]));
            case 4:
                return (new _arg_1(_arg_2[0], _arg_2[1], _arg_2[2], _arg_2[3]));
            case 5:
                return (new _arg_1(_arg_2[0], _arg_2[1], _arg_2[2], _arg_2[3], _arg_2[4]));
        };
        log(1, (("New with too many params! (" + _arg_2.length) + ")"));
        return (undefined);
    }

}//package cmodule.decry

