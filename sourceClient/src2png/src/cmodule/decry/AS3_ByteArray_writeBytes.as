// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//cmodule.decry.AS3_ByteArray_writeBytes

package cmodule.decry
{
    import cmodule.decry.log;
    import cmodule.decry.gstate;
    import flash.utils.ByteArray;

    internal function AS3_ByteArray_writeBytes(_arg_1:ByteArray, _arg_2:int, _arg_3:int):int
    {
        log(5, ((("--- wrteBytes: ba length = " + _arg_1.length) + " / ") + _arg_3));
        if (_arg_3 > 0)
        {
            _arg_1.writeBytes(gstate.ds, _arg_2, _arg_3);
            return (_arg_3);
        };
        return (0);
    }

}//package cmodule.decry

