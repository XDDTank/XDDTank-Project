// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.animations.AnimationSet

package game.animations
{
    import game.view.map.MapView;

    public class AnimationSet 
    {

        public static const PUBLIC_OWNER:int = 10000;

        private var _map:MapView;
        private var _running:Boolean;
        private var _current:IAnimate;
        private var _stageWidth:Number;
        private var _stageHeight:Number;
        private var _minX:Number;
        private var _minY:Number;
        private var _lockLevel:int;
        private var _lockOwnerID:int = -1;

        public function AnimationSet(_arg_1:MapView, _arg_2:Number, _arg_3:Number)
        {
            this._map = _arg_1;
            this._running = true;
            this._current = null;
            this._stageHeight = _arg_3;
            this._stageWidth = _arg_2;
            this._minX = (-(this._map.width) + _arg_2);
            this._minY = (-(this._map.height) + _arg_3);
        }

        public function get lockLevel():int
        {
            return (this._lockLevel);
        }

        public function set lockLevel(_arg_1:int):void
        {
            this._lockLevel = _arg_1;
        }

        public function get stageWidth():Number
        {
            return (this._stageWidth);
        }

        public function get stageHeight():Number
        {
            return (this._stageHeight);
        }

        public function get map():MapView
        {
            return (this._map);
        }

        public function get minX():Number
        {
            return (this._minX);
        }

        public function get minY():Number
        {
            return (this._minY);
        }

        public function get current():IAnimate
        {
            return (this._current);
        }

        public function addAnimation(_arg_1:IAnimate):void
        {
            if (_arg_1.level < this._lockLevel)
            {
                return;
            };
            if (this.lockOwnerID != -1)
            {
                if (_arg_1.ownerID != PUBLIC_OWNER)
                {
                    if (_arg_1.ownerID != this.lockOwnerID)
                    {
                        return;
                    };
                };
            };
            if (this._current)
            {
                if (((this._current.level <= _arg_1.level) && (this._current.canReplace(_arg_1))))
                {
                    if ((_arg_1 is BaseSetCenterAnimation))
                    {
                    };
                    this._current.cancel();
                    this._current = _arg_1;
                    this._current.prepare(this);
                };
            }
            else
            {
                this._current = _arg_1;
                this._current.prepare(this);
            };
        }

        public function pause():void
        {
            this._running = false;
        }

        public function play():void
        {
            this._running = true;
        }

        public function dispose():void
        {
            if (this._current)
            {
                this._current.cancel();
                this._current = null;
            };
            this._map = null;
        }

        public function clear():void
        {
            if (this._current)
            {
                this._current.cancel();
            };
            this._current = null;
        }

        public function update():Boolean
        {
            if (((this._running) && (this._current)))
            {
                if (this._current.canAct())
                {
                    if (this._current.update(this._map))
                    {
                        return (true);
                    };
                    this._current = null;
                }
                else
                {
                    this._current = null;
                };
            };
            return (false);
        }

        public function get lockOwnerID():int
        {
            return (this._lockOwnerID);
        }

        public function set lockOwnerID(_arg_1:int):void
        {
            this._lockOwnerID = _arg_1;
        }


    }
}//package game.animations

