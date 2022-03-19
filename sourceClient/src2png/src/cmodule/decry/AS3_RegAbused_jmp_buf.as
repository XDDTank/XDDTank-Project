// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//cmodule.decry.AS3_RegAbused_jmp_buf

package cmodule.decry
{
    import cmodule.decry.log;

    internal function AS3_RegAbused_jmp_buf(_arg_1:int):void
    {
        log(4, ("regAbused: " + _arg_1));
        log(1, "Can't RegAbused -- abuse support disabled");
    }

}//package cmodule.decry

