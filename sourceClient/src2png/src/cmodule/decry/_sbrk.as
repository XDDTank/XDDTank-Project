// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//cmodule.decry._sbrk

package cmodule.decry
{
    public function _sbrk(_arg_1:int):int
    {
        var _local_2:int = gstate.ds.length;
        var _local_3:int = (_local_2 + _arg_1);
        gstate.ds.length = _local_3;
        return (_local_2);
    }

}//package cmodule.decry

