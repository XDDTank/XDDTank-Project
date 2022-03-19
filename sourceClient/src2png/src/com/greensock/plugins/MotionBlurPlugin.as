// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.greensock.plugins.MotionBlurPlugin

package com.greensock.plugins
{
    import flash.geom.Point;
    import flash.geom.ColorTransform;
    import flash.display.DisplayObject;
    import flash.display.BitmapData;
    import flash.display.Bitmap;
    import com.greensock.TweenLite;
    import flash.filters.BlurFilter;
    import flash.geom.Matrix;
    import flash.display.Sprite;
    import flash.geom.Rectangle;
    import flash.utils.getDefinitionByName;
    import flash.geom.*;
    import flash.display.*;
    import com.greensock.*;
    import com.greensock.core.*;

    public class MotionBlurPlugin extends TweenPlugin 
    {

        public static const API:Number = 1;
        private static const _DEG2RAD:Number = (Math.PI / 180);//0.0174532925199433
        private static const _RAD2DEG:Number = (180 / Math.PI);//57.2957795130823
        private static const _point:Point = new Point(0, 0);
        private static const _ct:ColorTransform = new ColorTransform();
        private static const _blankArray:Array = [];
        private static var _classInitted:Boolean;
        private static var _isFlex:Boolean;

        protected var _target:DisplayObject;
        protected var _time:Number;
        protected var _xCurrent:Number;
        protected var _yCurrent:Number;
        protected var _bd:BitmapData;
        protected var _bitmap:Bitmap;
        protected var _strength:Number = 0.05;
        protected var _tween:TweenLite;
        protected var _blur:BlurFilter = new BlurFilter(0, 0, 2);
        protected var _matrix:Matrix = new Matrix();
        protected var _sprite:Sprite;
        protected var _rect:Rectangle;
        protected var _angle:Number;
        protected var _alpha:Number;
        protected var _xRef:Number;
        protected var _yRef:Number;
        protected var _mask:DisplayObject;
        protected var _parentMask:DisplayObject;
        protected var _padding:int;
        protected var _bdCache:BitmapData;
        protected var _rectCache:Rectangle;
        protected var _cos:Number;
        protected var _sin:Number;
        protected var _smoothing:Boolean;
        protected var _xOffset:Number;
        protected var _yOffset:Number;
        protected var _cached:Boolean;
        protected var _fastMode:Boolean;

        public function MotionBlurPlugin()
        {
            this.propName = "motionBlur";
            this.overwriteProps = ["motionBlur"];
            this.onComplete = this.disable;
            this.onDisable = this.onTweenDisable;
            this.priority = -2;
            this.activeDisable = true;
        }

        override public function onInitTween(target:Object, value:*, tween:TweenLite):Boolean
        {
            var x:Number;
            var y:Number;
            if ((!(target is DisplayObject)))
            {
                throw (new Error("motionBlur tweens only work for DisplayObjects."));
            };
            if (value == false)
            {
                this._strength = 0;
            }
            else
            {
                if (typeof(value) == "object")
                {
                    this._strength = (((value.strength) || (1)) * 0.05);
                    this._blur.quality = ((int(value.quality)) || (2));
                    this._fastMode = Boolean((value.fastMode == true));
                };
            };
            if ((!(_classInitted)))
            {
                try
                {
                    _isFlex = Boolean(getDefinitionByName("mx.managers.SystemManager"));
                }
                catch(e:Error)
                {
                    _isFlex = false;
                };
                _classInitted = true;
            };
            this._target = (target as DisplayObject);
            this._tween = tween;
            this._time = 0;
            this._padding = (("padding" in value) ? int(value.padding) : 10);
            this._smoothing = Boolean((this._blur.quality > 1));
            this._xCurrent = (this._xRef = this._target.x);
            this._yCurrent = (this._yRef = this._target.y);
            this._alpha = this._target.alpha;
            if ((((("x" in this._tween.propTweenLookup) && ("y" in this._tween.propTweenLookup)) && (!(this._tween.propTweenLookup.x.isPlugin))) && (!(this._tween.propTweenLookup.y.isPlugin))))
            {
                this._angle = (Math.PI - Math.atan2(this._tween.propTweenLookup.y.change, this._tween.propTweenLookup.x.change));
            }
            else
            {
                if (((!(this._tween.vars.x == null)) || (!(this._tween.vars.y == null))))
                {
                    x = ((this._tween.vars.x) || (this._target.x));
                    y = ((this._tween.vars.y) || (this._target.y));
                    this._angle = (Math.PI - Math.atan2((y - this._target.y), (x - this._target.x)));
                }
                else
                {
                    this._angle = 0;
                };
            };
            this._cos = Math.cos(this._angle);
            this._sin = Math.sin(this._angle);
            this._bd = new BitmapData((this._target.width + (this._padding * 2)), (this._target.height + (this._padding * 2)), true, 0xFFFFFF);
            this._bdCache = this._bd.clone();
            this._bitmap = new Bitmap(this._bd);
            this._bitmap.smoothing = this._smoothing;
            this._sprite = ((_isFlex) ? new (getDefinitionByName("mx.core.UIComponent"))() : new Sprite());
            this._sprite.mouseEnabled = (this._sprite.mouseChildren = false);
            this._sprite.addChild(this._bitmap);
            this._rectCache = new Rectangle(0, 0, this._bd.width, this._bd.height);
            this._rect = this._rectCache.clone();
            if (this._target.mask)
            {
                this._mask = this._target.mask;
            };
            if (((this._target.parent) && (this._target.parent.mask)))
            {
                this._parentMask = this._target.parent.mask;
            };
            return (true);
        }

        private function disable():void
        {
            if (this._strength != 0)
            {
                this._target.alpha = this._alpha;
            };
            if (this._sprite.parent)
            {
                if (((_isFlex) && (this._sprite.parent.hasOwnProperty("removeElement"))))
                {
                    (this._sprite.parent as Object).removeElement(this._sprite);
                }
                else
                {
                    this._sprite.parent.removeChild(this._sprite);
                };
            };
            if (this._mask)
            {
                this._target.mask = this._mask;
            };
        }

        private function onTweenDisable():void
        {
            if (((!(this._tween.cachedTime == this._tween.cachedDuration)) && (!(this._tween.cachedTime == 0))))
            {
                this.disable();
            };
        }

        override public function set changeFactor(_arg_1:Number):void
        {
            var _local_7:Number;
            var _local_8:Number;
            var _local_9:Number;
            var _local_10:Array;
            var _local_11:Boolean;
            var _local_12:Rectangle;
            var _local_2:Number = (this._tween.cachedTime - this._time);
            if (_local_2 < 0)
            {
                _local_2 = -(_local_2);
            };
            if (_local_2 < 1E-7)
            {
                return;
            };
            var _local_3:Number = (this._target.x - this._xCurrent);
            var _local_4:Number = (this._target.y - this._yCurrent);
            var _local_5:Number = (this._target.x - this._xRef);
            var _local_6:Number = (this._target.y - this._yRef);
            _changeFactor = _arg_1;
            if (((((_local_5 > 2) || (_local_6 > 2)) || (_local_5 < -2)) || (_local_6 < -2)))
            {
                this._angle = (Math.PI - Math.atan2(_local_6, _local_5));
                this._cos = Math.cos(this._angle);
                this._sin = Math.sin(this._angle);
                this._xRef = this._target.x;
                this._yRef = this._target.y;
            };
            this._blur.blurX = ((Math.sqrt(((_local_3 * _local_3) + (_local_4 * _local_4))) * this._strength) / _local_2);
            this._xCurrent = this._target.x;
            this._yCurrent = this._target.y;
            this._time = this._tween.cachedTime;
            if (((_arg_1 == 0) || (this._target.parent == null)))
            {
                this.disable();
                return;
            };
            if (((!(this._sprite.parent == this._target.parent)) && (this._target.parent)))
            {
                if (((_isFlex) && (this._target.parent.hasOwnProperty("addElement"))))
                {
                    (this._target.parent as Object).addElementAt(this._sprite, (this._target.parent as Object).getElementIndex(this._target));
                }
                else
                {
                    this._target.parent.addChildAt(this._sprite, this._target.parent.getChildIndex(this._target));
                };
                if (this._mask)
                {
                    this._sprite.mask = this._mask;
                };
            };
            if (((!(this._fastMode)) || (!(this._cached))))
            {
                _local_10 = this._target.parent.filters;
                if (_local_10.length != 0)
                {
                    this._target.parent.filters = _blankArray;
                };
                this._target.x = (this._target.y = 20000);
                _local_11 = this._target.visible;
                this._target.visible = true;
                _local_12 = this._target.getBounds(this._target.parent);
                if ((_local_12.width + (this._blur.blurX * 2)) > 2870)
                {
                    this._blur.blurX = ((_local_12.width >= 2870) ? 0 : ((2870 - _local_12.width) * 0.5));
                };
                this._xOffset = ((20000 - _local_12.x) + this._padding);
                this._yOffset = ((20000 - _local_12.y) + this._padding);
                _local_12.width = (_local_12.width + (this._padding * 2));
                _local_12.height = (_local_12.height + (this._padding * 2));
                if (((_local_12.height > this._bdCache.height) || (_local_12.width > this._bdCache.width)))
                {
                    this._bdCache = new BitmapData(_local_12.width, _local_12.height, true, 0xFFFFFF);
                    this._rectCache = new Rectangle(0, 0, this._bdCache.width, this._bdCache.height);
                };
                this._matrix.tx = (this._padding - _local_12.x);
                this._matrix.ty = (this._padding - _local_12.y);
                this._matrix.a = (this._matrix.d = 1);
                this._matrix.b = (this._matrix.c = 0);
                _local_12.x = (_local_12.y = 0);
                if (this._target.alpha == 0.00390625)
                {
                    this._target.alpha = this._alpha;
                }
                else
                {
                    this._alpha = this._target.alpha;
                };
                if (this._parentMask)
                {
                    this._target.parent.mask = null;
                };
                this._bdCache.fillRect(this._rectCache, 0xFFFFFF);
                this._bdCache.draw(this._target.parent, this._matrix, _ct, "normal", _local_12, this._smoothing);
                if (this._parentMask)
                {
                    this._target.parent.mask = this._parentMask;
                };
                this._target.visible = _local_11;
                this._target.x = this._xCurrent;
                this._target.y = this._yCurrent;
                if (_local_10.length != 0)
                {
                    this._target.parent.filters = _local_10;
                };
                this._cached = true;
            }
            else
            {
                if (this._target.alpha != 0.00390625)
                {
                    this._alpha = this._target.alpha;
                };
            };
            this._target.alpha = 0.00390625;
            this._matrix.tx = (this._matrix.ty = 0);
            this._matrix.a = this._cos;
            this._matrix.b = this._sin;
            this._matrix.c = -(this._sin);
            this._matrix.d = this._cos;
            if ((_local_7 = (this._matrix.a * this._bdCache.width)) < 0)
            {
                this._matrix.tx = -(_local_7);
                _local_7 = -(_local_7);
            };
            if ((_local_9 = (this._matrix.c * this._bdCache.height)) < 0)
            {
                this._matrix.tx = (this._matrix.tx - _local_9);
                _local_7 = (_local_7 - _local_9);
            }
            else
            {
                _local_7 = (_local_7 + _local_9);
            };
            if ((_local_8 = (this._matrix.d * this._bdCache.height)) < 0)
            {
                this._matrix.ty = -(_local_8);
                _local_8 = -(_local_8);
            };
            if ((_local_9 = (this._matrix.b * this._bdCache.width)) < 0)
            {
                this._matrix.ty = (this._matrix.ty - _local_9);
                _local_8 = (_local_8 - _local_9);
            }
            else
            {
                _local_8 = (_local_8 + _local_9);
            };
            _local_7 = (_local_7 + (this._blur.blurX * 2));
            this._matrix.tx = (this._matrix.tx + this._blur.blurX);
            if (((_local_7 > this._bd.width) || (_local_8 > this._bd.height)))
            {
                this._bd = (this._bitmap.bitmapData = new BitmapData(_local_7, _local_8, true, 0xFFFFFF));
                this._rect = new Rectangle(0, 0, this._bd.width, this._bd.height);
                this._bitmap.smoothing = this._smoothing;
            };
            this._bd.fillRect(this._rect, 0xFFFFFF);
            this._bd.draw(this._bdCache, this._matrix, _ct, "normal", this._rect, this._smoothing);
            this._bd.applyFilter(this._bd, this._rect, _point, this._blur);
            this._bitmap.x = (0 - (((this._matrix.a * this._xOffset) + (this._matrix.c * this._yOffset)) + this._matrix.tx));
            this._bitmap.y = (0 - (((this._matrix.d * this._yOffset) + (this._matrix.b * this._xOffset)) + this._matrix.ty));
            this._matrix.b = -(this._sin);
            this._matrix.c = this._sin;
            this._matrix.tx = this._xCurrent;
            this._matrix.ty = this._yCurrent;
            this._sprite.transform.matrix = this._matrix;
        }


    }
}//package com.greensock.plugins

