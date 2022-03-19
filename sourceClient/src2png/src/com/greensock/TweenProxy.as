// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.greensock.TweenProxy

package com.greensock
{
    import flash.utils.Proxy;
    import flash.utils.Dictionary;
    import flash.display.DisplayObject;
    import flash.geom.Point;
    import flash.display.Sprite;
    import flash.geom.Rectangle;
    import flash.geom.Matrix;
    import flash.utils.*;
    import flash.display.*;
    import flash.geom.*;
    import flash.utils.flash_proxy; 

    use namespace flash.utils.flash_proxy;

    public dynamic class TweenProxy extends Proxy 
    {

        public static const VERSION:Number = 0.94;
        private static const _DEG2RAD:Number = (Math.PI / 180);//0.0174532925199433
        private static const _RAD2DEG:Number = (180 / Math.PI);//57.2957795130823
        private static var _dict:Dictionary = new Dictionary(false);
        private static var _addedProps:String = " tint tintPercent scale skewX skewY skewX2 skewY2 target registration registrationX registrationY localRegistration localRegistrationX localRegistrationY ";

        private var _target:DisplayObject;
        private var _angle:Number;
        private var _scaleX:Number;
        private var _scaleY:Number;
        private var _proxies:Array;
        private var _localRegistration:Point;
        private var _registration:Point;
        private var _regAt0:Boolean;
        public var ignoreSiblingUpdates:Boolean = false;
        public var isTweenProxy:Boolean = true;

        public function TweenProxy(_arg_1:DisplayObject, _arg_2:Boolean=false)
        {
            this._target = _arg_1;
            if (_dict[this._target] == undefined)
            {
                _dict[this._target] = [];
            };
            this._proxies = _dict[this._target];
            this._proxies.push(this);
            this._localRegistration = new Point(0, 0);
            this.ignoreSiblingUpdates = _arg_2;
            this.calibrate();
        }

        public static function create(_arg_1:DisplayObject, _arg_2:Boolean=true):TweenProxy
        {
            if (((!(_dict[_arg_1] == null)) && (_arg_2)))
            {
                return (_dict[_arg_1][0]);
            };
            return (new TweenProxy(_arg_1));
        }


        public function getCenter():Point
        {
            var _local_4:Sprite;
            var _local_1:Boolean;
            if (this._target.parent == null)
            {
                _local_1 = true;
                _local_4 = new Sprite();
                _local_4.addChild(this._target);
            };
            var _local_2:Rectangle = this._target.getBounds(this._target.parent);
            var _local_3:Point = new Point((_local_2.x + (_local_2.width / 2)), (_local_2.y + (_local_2.height / 2)));
            if (_local_1)
            {
                this._target.parent.removeChild(this._target);
            };
            return (_local_3);
        }

        public function get target():DisplayObject
        {
            return (this._target);
        }

        public function calibrate():void
        {
            this._scaleX = this._target.scaleX;
            this._scaleY = this._target.scaleY;
            this._angle = (this._target.rotation * _DEG2RAD);
            this.calibrateRegistration();
        }

        public function destroy():void
        {
            var _local_2:int;
            var _local_1:Array = _dict[this._target];
            _local_2 = (_local_1.length - 1);
            while (_local_2 > -1)
            {
                if (_local_1[_local_2] == this)
                {
                    _local_1.splice(_local_2, 1);
                };
                _local_2--;
            };
            if (_local_1.length == 0)
            {
                delete _dict[this._target];
            };
            this._target = null;
            this._localRegistration = null;
            this._registration = null;
            this._proxies = null;
        }

        override flash_proxy function callProperty(_arg_1:*, ... _args):*
        {
            return (this._target[_arg_1].apply(null, _args));
        }

        override flash_proxy function getProperty(_arg_1:*):*
        {
            return (this._target[_arg_1]);
        }

        override flash_proxy function setProperty(_arg_1:*, _arg_2:*):void
        {
            this._target[_arg_1] = _arg_2;
        }

        override flash_proxy function hasProperty(_arg_1:*):Boolean
        {
            if (this._target.hasOwnProperty(_arg_1))
            {
                return (true);
            };
            if (_addedProps.indexOf(((" " + _arg_1) + " ")) != -1)
            {
                return (true);
            };
            return (false);
        }

        public function moveRegX(_arg_1:Number):void
        {
            this._registration.x = (this._registration.x + _arg_1);
        }

        public function moveRegY(_arg_1:Number):void
        {
            this._registration.y = (this._registration.y + _arg_1);
        }

        private function reposition():void
        {
            var _local_1:Point = this._target.parent.globalToLocal(this._target.localToGlobal(this._localRegistration));
            this._target.x = (this._target.x + (this._registration.x - _local_1.x));
            this._target.y = (this._target.y + (this._registration.y - _local_1.y));
        }

        private function updateSiblingProxies():void
        {
            var _local_1:int = (this._proxies.length - 1);
            while (_local_1 > -1)
            {
                if (this._proxies[_local_1] != this)
                {
                    this._proxies[_local_1].onSiblingUpdate(this._scaleX, this._scaleY, this._angle);
                };
                _local_1--;
            };
        }

        private function calibrateLocal():void
        {
            this._localRegistration = this._target.globalToLocal(this._target.parent.localToGlobal(this._registration));
            this._regAt0 = ((this._localRegistration.x == 0) && (this._localRegistration.y == 0));
        }

        private function calibrateRegistration():void
        {
            this._registration = this._target.parent.globalToLocal(this._target.localToGlobal(this._localRegistration));
            this._regAt0 = ((this._localRegistration.x == 0) && (this._localRegistration.y == 0));
        }

        public function onSiblingUpdate(_arg_1:Number, _arg_2:Number, _arg_3:Number):void
        {
            this._scaleX = _arg_1;
            this._scaleY = _arg_2;
            this._angle = _arg_3;
            if (this.ignoreSiblingUpdates)
            {
                this.calibrateLocal();
            }
            else
            {
                this.calibrateRegistration();
            };
        }

        public function get localRegistration():Point
        {
            return (this._localRegistration);
        }

        public function set localRegistration(_arg_1:Point):void
        {
            this._localRegistration = _arg_1;
            this.calibrateRegistration();
        }

        public function get localRegistrationX():Number
        {
            return (this._localRegistration.x);
        }

        public function set localRegistrationX(_arg_1:Number):void
        {
            this._localRegistration.x = _arg_1;
            this.calibrateRegistration();
        }

        public function get localRegistrationY():Number
        {
            return (this._localRegistration.y);
        }

        public function set localRegistrationY(_arg_1:Number):void
        {
            this._localRegistration.y = _arg_1;
            this.calibrateRegistration();
        }

        public function get registration():Point
        {
            return (this._registration);
        }

        public function set registration(_arg_1:Point):void
        {
            this._registration = _arg_1;
            this.calibrateLocal();
        }

        public function get registrationX():Number
        {
            return (this._registration.x);
        }

        public function set registrationX(_arg_1:Number):void
        {
            this._registration.x = _arg_1;
            this.calibrateLocal();
        }

        public function get registrationY():Number
        {
            return (this._registration.y);
        }

        public function set registrationY(_arg_1:Number):void
        {
            this._registration.y = _arg_1;
            this.calibrateLocal();
        }

        public function get x():Number
        {
            return (this._registration.x);
        }

        public function set x(_arg_1:Number):void
        {
            var _local_2:Number = (_arg_1 - this._registration.x);
            this._target.x = (this._target.x + _local_2);
            var _local_3:int = (this._proxies.length - 1);
            while (_local_3 > -1)
            {
                if (((this._proxies[_local_3] == this) || (!(this._proxies[_local_3].ignoreSiblingUpdates))))
                {
                    this._proxies[_local_3].moveRegX(_local_2);
                };
                _local_3--;
            };
        }

        public function get y():Number
        {
            return (this._registration.y);
        }

        public function set y(_arg_1:Number):void
        {
            var _local_2:Number = (_arg_1 - this._registration.y);
            this._target.y = (this._target.y + _local_2);
            var _local_3:int = (this._proxies.length - 1);
            while (_local_3 > -1)
            {
                if (((this._proxies[_local_3] == this) || (!(this._proxies[_local_3].ignoreSiblingUpdates))))
                {
                    this._proxies[_local_3].moveRegY(_local_2);
                };
                _local_3--;
            };
        }

        public function get rotation():Number
        {
            return (this._angle * _RAD2DEG);
        }

        public function set rotation(_arg_1:Number):void
        {
            var _local_2:Number = (_arg_1 * _DEG2RAD);
            var _local_3:Matrix = this._target.transform.matrix;
            _local_3.rotate((_local_2 - this._angle));
            this._target.transform.matrix = _local_3;
            this._angle = _local_2;
            this.reposition();
            if (this._proxies.length > 1)
            {
                this.updateSiblingProxies();
            };
        }

        public function get skewX():Number
        {
            var _local_1:Matrix = this._target.transform.matrix;
            return ((Math.atan2(-(_local_1.c), _local_1.d) - this._angle) * _RAD2DEG);
        }

        public function set skewX(_arg_1:Number):void
        {
            var _local_2:Number = (_arg_1 * _DEG2RAD);
            var _local_3:Matrix = this._target.transform.matrix;
            var _local_4:Number = ((this._scaleY < 0) ? -(this._scaleY) : this._scaleY);
            _local_3.c = (-(_local_4) * Math.sin((_local_2 + this._angle)));
            _local_3.d = (_local_4 * Math.cos((_local_2 + this._angle)));
            this._target.transform.matrix = _local_3;
            if ((!(this._regAt0)))
            {
                this.reposition();
            };
            if (this._proxies.length > 1)
            {
                this.updateSiblingProxies();
            };
        }

        public function get skewY():Number
        {
            var _local_1:Matrix = this._target.transform.matrix;
            return ((Math.atan2(_local_1.b, _local_1.a) - this._angle) * _RAD2DEG);
        }

        public function set skewY(_arg_1:Number):void
        {
            var _local_2:Number = (_arg_1 * _DEG2RAD);
            var _local_3:Matrix = this._target.transform.matrix;
            var _local_4:Number = ((this._scaleX < 0) ? -(this._scaleX) : this._scaleX);
            _local_3.a = (_local_4 * Math.cos((_local_2 + this._angle)));
            _local_3.b = (_local_4 * Math.sin((_local_2 + this._angle)));
            this._target.transform.matrix = _local_3;
            if ((!(this._regAt0)))
            {
                this.reposition();
            };
            if (this._proxies.length > 1)
            {
                this.updateSiblingProxies();
            };
        }

        public function get skewX2():Number
        {
            return (this.skewX2Radians * _RAD2DEG);
        }

        public function set skewX2(_arg_1:Number):void
        {
            this.skewX2Radians = (_arg_1 * _DEG2RAD);
        }

        public function get skewY2():Number
        {
            return (this.skewY2Radians * _RAD2DEG);
        }

        public function set skewY2(_arg_1:Number):void
        {
            this.skewY2Radians = (_arg_1 * _DEG2RAD);
        }

        public function get skewX2Radians():Number
        {
            return (-(Math.atan(this._target.transform.matrix.c)));
        }

        public function set skewX2Radians(_arg_1:Number):void
        {
            var _local_2:Matrix = this._target.transform.matrix;
            _local_2.c = Math.tan(-(_arg_1));
            this._target.transform.matrix = _local_2;
            if ((!(this._regAt0)))
            {
                this.reposition();
            };
            if (this._proxies.length > 1)
            {
                this.updateSiblingProxies();
            };
        }

        public function get skewY2Radians():Number
        {
            return (Math.atan(this._target.transform.matrix.b));
        }

        public function set skewY2Radians(_arg_1:Number):void
        {
            var _local_2:Matrix = this._target.transform.matrix;
            _local_2.b = Math.tan(_arg_1);
            this._target.transform.matrix = _local_2;
            if ((!(this._regAt0)))
            {
                this.reposition();
            };
            if (this._proxies.length > 1)
            {
                this.updateSiblingProxies();
            };
        }

        public function get scaleX():Number
        {
            return (this._scaleX);
        }

        public function set scaleX(_arg_1:Number):void
        {
            if (_arg_1 == 0)
            {
                _arg_1 = 0.0001;
            };
            var _local_2:Matrix = this._target.transform.matrix;
            _local_2.rotate(-(this._angle));
            _local_2.scale((_arg_1 / this._scaleX), 1);
            _local_2.rotate(this._angle);
            this._target.transform.matrix = _local_2;
            this._scaleX = _arg_1;
            this.reposition();
            if (this._proxies.length > 1)
            {
                this.updateSiblingProxies();
            };
        }

        public function get scaleY():Number
        {
            return (this._scaleY);
        }

        public function set scaleY(_arg_1:Number):void
        {
            if (_arg_1 == 0)
            {
                _arg_1 = 0.0001;
            };
            var _local_2:Matrix = this._target.transform.matrix;
            _local_2.rotate(-(this._angle));
            _local_2.scale(1, (_arg_1 / this._scaleY));
            _local_2.rotate(this._angle);
            this._target.transform.matrix = _local_2;
            this._scaleY = _arg_1;
            this.reposition();
            if (this._proxies.length > 1)
            {
                this.updateSiblingProxies();
            };
        }

        public function get scale():Number
        {
            return ((this._scaleX + this._scaleY) / 2);
        }

        public function set scale(_arg_1:Number):void
        {
            if (_arg_1 == 0)
            {
                _arg_1 = 0.0001;
            };
            var _local_2:Matrix = this._target.transform.matrix;
            _local_2.rotate(-(this._angle));
            _local_2.scale((_arg_1 / this._scaleX), (_arg_1 / this._scaleY));
            _local_2.rotate(this._angle);
            this._target.transform.matrix = _local_2;
            this._scaleX = (this._scaleY = _arg_1);
            this.reposition();
            if (this._proxies.length > 1)
            {
                this.updateSiblingProxies();
            };
        }

        public function get alpha():Number
        {
            return (this._target.alpha);
        }

        public function set alpha(_arg_1:Number):void
        {
            this._target.alpha = _arg_1;
        }

        public function get width():Number
        {
            return (this._target.width);
        }

        public function set width(_arg_1:Number):void
        {
            this._target.width = _arg_1;
            if ((!(this._regAt0)))
            {
                this.reposition();
            };
            if (this._proxies.length > 1)
            {
                this.updateSiblingProxies();
            };
        }

        public function get height():Number
        {
            return (this._target.height);
        }

        public function set height(_arg_1:Number):void
        {
            this._target.height = _arg_1;
            if ((!(this._regAt0)))
            {
                this.reposition();
            };
            if (this._proxies.length > 1)
            {
                this.updateSiblingProxies();
            };
        }


    }
}//package com.greensock

