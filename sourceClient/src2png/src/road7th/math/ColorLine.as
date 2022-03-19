// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//road7th.math.ColorLine

package road7th.math
{
    import flash.geom.Point;

    public class ColorLine extends XLine 
    {


        override public function interpolate(_arg_1:Number):Number
        {
            var _local_2:Point;
            var _local_3:Point;
            var _local_4:int;
            if ((!(fix)))
            {
                _local_4 = 1;
                while (_local_4 < list.length)
                {
                    _local_3 = list[_local_4];
                    _local_2 = list[(_local_4 - 1)];
                    if (_local_3.x > _arg_1) break;
                    _local_4++;
                };
                return (interpolateColors(_local_2.y, _local_3.y, (1 - ((_arg_1 - _local_2.x) / (_local_3.x - _local_2.x)))));
            };
            return (fixValue);
        }


    }
}//package road7th.math

