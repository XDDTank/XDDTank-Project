// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.effect.AlphaShinerAnimation

package com.pickgliss.effect
{
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.display.Bitmap;
    import com.greensock.TweenMax;
    import com.pickgliss.utils.ObjectUtils;
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import com.greensock.easing.Sine;
    import com.pickgliss.utils.EffectUtils;
    import flash.geom.Matrix;
    import flash.display.GradientType;
    import flash.display.SpreadMethod;
    import flash.display.InterpolationMethod;

    public class AlphaShinerAnimation extends BaseEffect 
    {

        public static const SPEED:String = "speed";
        public static const INTENSITY:String = "intensity";
        public static const WIDTH:String = "width";
        public static const EFFECT:String = "effect";
        public static const COLOR:String = "color";
        public static const BLUR_WIDTH:String = "blurWidth";
        public static const IS_LOOP:String = "isLoop";
        public static const STRENGTH:String = "strength";

        private var _addGlowEffect:Boolean = true;
        private var _alphas:Array;
        private var _colors:Array;
        private var _glowBlurWidth:Number = 3;
        private var _glowColorName:String = "blue";
        private var _glowStrength:Number = 1;
        protected var _isLoop:Boolean = true;
        protected var _maskHeight:Number;
        protected var _maskShape:Shape = new Shape();
        protected var _maskWidth:Number;
        private var _percent:Array;
        protected var _shineAnimationContainer:Sprite;
        private var _sourceBitmap:Bitmap;
        private var _shineBitmapContainer:Sprite;
        private var _shineIntensity:Number = 30;
        protected var _shineMoveSpeed:Number = 0.75;
        private var _shineWidth:Number = 100;

        public function AlphaShinerAnimation(_arg_1:int)
        {
            super(_arg_1);
        }

        override public function dispose():void
        {
            TweenMax.killTweensOf(this._maskShape);
            ObjectUtils.disposeObject(this._shineAnimationContainer);
            ObjectUtils.disposeObject(this._sourceBitmap);
            ObjectUtils.disposeObject(this._shineBitmapContainer);
            this._shineAnimationContainer = null;
            this._sourceBitmap = null;
            this._shineBitmapContainer = null;
            super.dispose();
        }

        override public function initEffect(_arg_1:DisplayObject, _arg_2:Array):void
        {
            super.initEffect(_arg_1, _arg_2);
            var _local_3:Object = _arg_2[0];
            if (_local_3)
            {
                if (_local_3[SPEED])
                {
                    this._shineMoveSpeed = _local_3[SPEED];
                };
                if (_local_3[INTENSITY])
                {
                    this._shineIntensity = _local_3[INTENSITY];
                };
                if (_local_3[WIDTH])
                {
                    this._shineWidth = _local_3[WIDTH];
                };
                if (_local_3[EFFECT])
                {
                    this._addGlowEffect = _local_3[EFFECT];
                };
                if (_local_3[COLOR])
                {
                    this._glowColorName = _local_3[COLOR];
                };
                if (_local_3[BLUR_WIDTH])
                {
                    this._glowBlurWidth = _local_3[BLUR_WIDTH];
                };
                if (_local_3[IS_LOOP])
                {
                    this._isLoop = _local_3[IS_LOOP];
                };
                if (_local_3[STRENGTH])
                {
                    this._glowStrength = _local_3[STRENGTH];
                };
            };
            this.image_shiner(this._shineMoveSpeed, this._shineIntensity, this._shineWidth, this._addGlowEffect, this._glowColorName, this._glowBlurWidth, this._glowStrength, this._isLoop);
        }

        override public function play():void
        {
            if (TweenMax.isTweening(this._maskShape))
            {
                return;
            };
            super.play();
            if ((!(target is DisplayObjectContainer)))
            {
                this._shineAnimationContainer.x = target.x;
                this._shineAnimationContainer.y = target.y;
                target.parent.addChild(this._shineAnimationContainer);
            }
            else
            {
                DisplayObjectContainer(target).addChild(this._shineAnimationContainer);
            };
            if (this._isLoop)
            {
                TweenMax.to(this._maskShape, this._shineMoveSpeed, {
                    "startAt":{"alpha":0},
                    "alpha":1,
                    "yoyo":true,
                    "repeat":-1,
                    "ease":Sine.easeOut
                });
            }
            else
            {
                TweenMax.to(this._maskShape, this._shineMoveSpeed, {
                    "startAt":{"alpha":0},
                    "alpha":1,
                    "ease":Sine.easeOut
                });
            };
        }

        override public function stop():void
        {
            super.stop();
            if ((!(this._shineAnimationContainer.parent)))
            {
                return;
            };
            this._shineAnimationContainer.parent.removeChild(this._shineAnimationContainer);
            this._maskShape.alpha = 0;
            TweenMax.killTweensOf(this._maskShape);
        }

        private function image_shiner(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Boolean, _arg_5:String, _arg_6:Number, _arg_7:Number, _arg_8:Boolean):void
        {
            this._shineAnimationContainer = new Sprite();
            this._shineBitmapContainer = new Sprite();
            this._sourceBitmap = EffectUtils.creatMcToBitmap(target, 0xFF0000);
            this._shineBitmapContainer.addChild(this._sourceBitmap);
            this._shineAnimationContainer.addChild(this._shineBitmapContainer);
            EffectUtils.imageShiner(this._shineAnimationContainer, _arg_2);
            EffectUtils.imageGlower(this._shineBitmapContainer, _arg_7, _arg_6, 15, _arg_5);
            this.linear_fade(_arg_3, _arg_1, 60);
        }

        private function linear_fade(_arg_1:Number, _arg_2:Number, _arg_3:Number):void
        {
            this._maskShape.cacheAsBitmap = true;
            this._shineAnimationContainer.cacheAsBitmap = true;
            this._shineAnimationContainer.mask = this._maskShape;
            this._maskWidth = (this._shineAnimationContainer.width + _arg_3);
            this._maskHeight = (this._shineAnimationContainer.height + _arg_3);
            this._maskShape.x = (this._shineAnimationContainer.x - (_arg_3 / 2));
            this._maskShape.y = (this._shineAnimationContainer.y - (_arg_3 / 2));
            this._colors = [0xFFFFFF, 0xFFFFFF];
            this._alphas = [100, 100];
            this._percent = [0, 0xFF];
            var _local_4:Matrix = new Matrix();
            _local_4.createGradientBox(this._maskWidth, this._maskHeight, 0, ((this._maskWidth - this._shineWidth) / 2), 0);
            this._maskShape.graphics.beginGradientFill(GradientType.RADIAL, this._colors, this._alphas, this._percent, _local_4, SpreadMethod.PAD, InterpolationMethod.LINEAR_RGB);
            this._maskShape.graphics.drawRect(0, 0, this._maskWidth, this._maskHeight);
            this._maskShape.graphics.endFill();
            this._shineAnimationContainer.addChild(this._maskShape);
        }


    }
}//package com.pickgliss.effect

