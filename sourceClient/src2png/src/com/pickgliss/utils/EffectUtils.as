// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.utils.EffectUtils

package com.pickgliss.utils
{
    import com.pickgliss.effect.EffectColorType;
    import flash.filters.GradientGlowFilter;
    import flash.display.DisplayObject;
    import flash.geom.ColorTransform;
    import flash.display.BitmapData;
    import flash.display.Bitmap;

    public class EffectUtils 
    {


        public static function imageGlower(_arg_1:DisplayObject, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:String):void
        {
            var _local_8:Array;
            var _local_6:Number = 0;
            var _local_7:Number = 45;
            if (_arg_5 == EffectColorType.YELLOW)
            {
                _local_8 = [0xFFA600, 0xFFA600, 0xFFA600, 0xFFA600];
            };
            if (_arg_5 == EffectColorType.GOLD)
            {
                _local_8 = [0x660000, 0xFF6600, 0xFFAA00, 16777164];
            };
            if (_arg_5 == EffectColorType.BLUE)
            {
                _local_8 = [13209, 13209, 39423, 10079487];
            };
            if (_arg_5 == EffectColorType.GREEN)
            {
                _local_8 = [0x6600, 0x339900, 0x99FF00, 16777164];
            };
            if (_arg_5 == EffectColorType.OCEAN)
            {
                _local_8 = [0x3333, 3368550, 10079436, 13434879];
            };
            if (_arg_5 == EffectColorType.AQUA)
            {
                _local_8 = [0x3333, 0x6666, 0xCCCC, 0xFFFF];
            };
            if (_arg_5 == EffectColorType.ICE)
            {
                _local_8 = [13158, 3368601, 6724044, 10079487];
            };
            if (_arg_5 == EffectColorType.SPARK)
            {
                _local_8 = [102, 26265, 3394815, 13434879];
            };
            if (_arg_5 == EffectColorType.SILVER)
            {
                _local_8 = [0x333333, 0x666666, 0xBBBBBB, 0xFFFFFF];
            };
            if (_arg_5 == EffectColorType.NEON)
            {
                _local_8 = [3355596, 6697932, 10066431, 13421823];
            };
            var _local_9:Array = [0, 1, 1, 1];
            var _local_10:Array = [0, 63, 126, 0xFF];
            var _local_11:Number = _arg_3;
            var _local_12:Number = _arg_3;
            var _local_13:Number = _arg_2;
            var _local_14:String = "outer";
            var _local_15:Boolean;
            var _local_16:GradientGlowFilter = new GradientGlowFilter(_local_6, _local_7, _local_8, _local_9, _local_10, _local_11, _local_12, _local_13, _arg_4, _local_14, _local_15);
            var _local_17:Array = new Array();
            _local_17.push(_local_16);
            _arg_1.filters = _local_17;
        }

        public static function imageShiner(_arg_1:DisplayObject, _arg_2:Number):void
        {
            var _local_3:ColorTransform = new ColorTransform();
            var _local_4:Number = _arg_2;
            _local_3.redOffset = _local_4;
            _local_3.redMultiplier = ((_local_4 / 100) + 1);
            _local_3.greenOffset = _local_4;
            _local_3.greenMultiplier = ((_local_4 / 100) + 1);
            _local_3.blueOffset = _local_4;
            _local_3.blueMultiplier = ((_local_4 / 100) + 1);
            _arg_1.transform.colorTransform = _local_3;
        }

        public static function creatMcToBitmap(_arg_1:DisplayObject, _arg_2:uint):Bitmap
        {
            var _local_3:BitmapData = new BitmapData(_arg_1.width, _arg_1.height, true, _arg_2);
            _local_3.draw(_arg_1);
            return (new Bitmap(_local_3));
        }

        public static function toRadian(_arg_1:Number):Number
        {
            return ((Math.PI / 180) * _arg_1);
        }


    }
}//package com.pickgliss.utils

