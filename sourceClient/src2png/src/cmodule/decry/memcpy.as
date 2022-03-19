// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//cmodule.decry.memcpy

package cmodule.decry
{
    public function memcpy(_arg_1:int, _arg_2:int, _arg_3:int):int
    {
        if (_arg_3)
        {
            gstate.ds.position = _arg_1;
            gstate.ds.writeBytes(gstate.ds, _arg_2, _arg_3);
        };
        return (_arg_1);
    }

}//package cmodule.decry

