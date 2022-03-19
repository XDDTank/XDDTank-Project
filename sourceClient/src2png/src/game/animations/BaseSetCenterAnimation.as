// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.animations.BaseSetCenterAnimation

package game.animations
{
    import flash.geom.Point;
    import flash.utils.getDefinitionByName;
    import game.view.map.MapView;

    public class BaseSetCenterAnimation extends BaseAnimate 
    {

        protected var _target:Point;
        protected var _life:int;
        protected var _directed:Boolean;
        protected var _speed:int;
        protected var _moveSpeed:int = 4;
        protected var _tween:BaseStageTween;

        public function BaseSetCenterAnimation(_arg_1:Number, _arg_2:Number, _arg_3:int=0, _arg_4:Boolean=false, _arg_5:int=0, _arg_6:int=-1, _arg_7:int=4, _arg_8:Object=null)
        {
            var _local_9:TweenObject;
            super();
            _local_9 = new TweenObject(_arg_8);
            this._target = new Point(_arg_1, _arg_2);
            _local_9.target = this._target;
            var _local_10:String = StageTweenStrategys.getTweenClassNameByShortName(_local_9.strategy);
            _finished = false;
            this._life = _arg_3;
            _level = _arg_5;
            _ownerID = _arg_6;
            if (((_arg_8) && (!(_arg_8.priority == null))))
            {
                _level = _arg_8.priority;
            };
            if (((_arg_8) && (!(_arg_8.duration == null))))
            {
                this._life = _arg_8.duration;
            };
            this._directed = _arg_4;
            this._speed = _arg_7;
            var _local_11:Class = (getDefinitionByName(_local_10) as Class);
            this._tween = new _local_11(_local_9);
        }

        override public function canAct():Boolean
        {
            if (_finished)
            {
                return (false);
            };
            if (this._life <= 0)
            {
                return (false);
            };
            return (true);
        }

        override public function prepare(_arg_1:AnimationSet):void
        {
            this._target.x = ((_arg_1.stageWidth / 2) - this._target.x);
            this._target.y = ((_arg_1.stageHeight / 2) - this._target.y);
            this._target.x = ((this._target.x < _arg_1.minX) ? _arg_1.minX : ((this._target.x > 0) ? 0 : this._target.x));
            this._target.y = ((this._target.y < _arg_1.minY) ? _arg_1.minY : ((this._target.y > 0) ? 0 : this._target.y));
        }

        override public function update(_arg_1:MapView):Boolean
        {
            var _local_2:Point;
            this._life--;
            if (this._life <= 0)
            {
                this.finished();
            };
            if (((!(_finished)) && (this._life > 0)))
            {
                if ((!(this._directed)))
                {
                    this._tween.target = this._target;
                    _local_2 = this._tween.update(_arg_1);
                    _arg_1.x = _local_2.x;
                    _arg_1.y = _local_2.y;
                    if (this._tween.isFinished)
                    {
                        this.finished();
                    };
                }
                else
                {
                    _arg_1.x = this._target.x;
                    _arg_1.y = this._target.y;
                    this.finished();
                };
                _arg_1.setExpressionLoction();
                return (true);
            };
            return (false);
        }

        protected function finished():void
        {
            _finished = true;
        }


    }
}//package game.animations

