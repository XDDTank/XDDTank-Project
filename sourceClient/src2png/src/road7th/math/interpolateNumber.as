// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//road7th.math.interpolateNumber

package road7th.math
{
    public function interpolateNumber(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Number):Number
    {
        return ((((_arg_5 - _arg_1) * (_arg_4 - _arg_2)) / (_arg_3 - _arg_1)) + _arg_2);
    }

}//package road7th.math

