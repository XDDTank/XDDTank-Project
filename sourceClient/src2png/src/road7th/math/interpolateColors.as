// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//road7th.math.interpolateColors

package road7th.math
{
    public function interpolateColors(_arg_1:uint, _arg_2:uint, _arg_3:Number):uint
    {
        var _local_4:Number = (1 - _arg_3);
        var _local_5:uint = Math.round(((((_arg_1 >>> 16) & 0xFF) * _arg_3) + (((_arg_2 >>> 16) & 0xFF) * _local_4)));
        var _local_6:uint = Math.round(((((_arg_1 >>> 8) & 0xFF) * _arg_3) + (((_arg_2 >>> 8) & 0xFF) * _local_4)));
        var _local_7:uint = Math.round((((_arg_1 & 0xFF) * _arg_3) + ((_arg_2 & 0xFF) * _local_4)));
        var _local_8:uint = Math.round(((((_arg_1 >>> 24) & 0xFF) * _arg_3) + (((_arg_2 >>> 24) & 0xFF) * _local_4)));
        return ((((_local_8 << 24) | (_local_5 << 16)) | (_local_6 << 8)) | _local_7);
    }

}//package road7th.math

