// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//cmodule.decry.__subc

package cmodule.decry
{
    public function __subc(_arg_1:uint, _arg_2:uint):uint
    {
        var _local_3:uint = (_arg_1 - _arg_2);
        gstate.cf = uint((_local_3 > _arg_1));
        return (_local_3);
    }

}//package cmodule.decry

