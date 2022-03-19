// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//road7th.math.interpolatePointByX

package road7th.math
{
    import flash.geom.Point;

    public function interpolatePointByX(_arg_1:Point, _arg_2:Point, _arg_3:Number):Number
    {
        return ((((_arg_3 - _arg_1.x) * (_arg_2.y - _arg_1.y)) / (_arg_2.x - _arg_1.x)) + _arg_1.y);
    }

}//package road7th.math

