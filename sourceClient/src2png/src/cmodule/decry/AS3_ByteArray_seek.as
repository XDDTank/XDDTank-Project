// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//cmodule.decry.AS3_ByteArray_seek

package cmodule.decry
{
    import flash.utils.ByteArray;

    internal function AS3_ByteArray_seek(_arg_1:ByteArray, _arg_2:int, _arg_3:int):int
    {
        if (_arg_3 == 0)
        {
            _arg_1.position = _arg_2;
        }
        else
        {
            if (_arg_3 == 1)
            {
                _arg_1.position = (_arg_1.position + _arg_2);
            }
            else
            {
                if (_arg_3 == 2)
                {
                    _arg_1.position = (_arg_1.length + _arg_2);
                }
                else
                {
                    return (-1);
                };
            };
        };
        return (_arg_1.position);
    }

}//package cmodule.decry

