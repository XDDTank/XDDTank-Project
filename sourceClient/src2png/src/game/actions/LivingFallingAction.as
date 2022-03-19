// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.actions.LivingFallingAction

package game.actions
{
    import game.objects.GameLiving;
    import flash.geom.Point;
    import game.animations.ShockMapAnimation;
    import game.animations.AnimationLevel;
    import ddt.manager.SoundManager;
    import game.animations.BaseSetCenterAnimation;
    import game.model.Living;

    public class LivingFallingAction extends BaseAction 
    {

        private var _living:GameLiving;
        protected var _target:Point;
        private var _speed:int;
        private var _fallType:int;
        private var _firstExcuted:Boolean = true;
        private var _acceleration:int = 20;
        private var _state:int = 0;
        private var _times:int = 0;
        private var _tempSpeed:int = 0;
        private var _g:Number = 0.04;
        private var _maxY:Number;

        public function LivingFallingAction(_arg_1:GameLiving, _arg_2:Point, _arg_3:int, _arg_4:int=0)
        {
            this._living = _arg_1;
            this._target = _arg_2;
            this._speed = _arg_3;
            this._fallType = _arg_4;
            super();
        }

        override public function connect(_arg_1:BaseAction):Boolean
        {
            var _local_2:LivingFallingAction = (_arg_1 as LivingFallingAction);
            if (((_local_2) && (_local_2._target.y < this._target.y)))
            {
                return (true);
            };
            return (false);
        }

        override public function prepare():void
        {
            if (_isPrepare)
            {
                return;
            };
            _isPrepare = true;
            super.prepare();
            if (this._living.isLiving)
            {
                if (this._living.x == this._target.x)
                {
                    this._living.startMoving();
                }
                else
                {
                    this.finish();
                };
            }
            else
            {
                this.finish();
            };
        }

        override public function execute():void
        {
            if (this._fallType == 0)
            {
                this.executeImp();
            }
            else
            {
                if (this._fallType == 2)
                {
                    this.executeImpShock();
                }
                else
                {
                    this.fallingAmortize();
                };
            };
        }

        private function fallingAmortize():void
        {
            if (this._state == 0)
            {
                this._times++;
                this._tempSpeed = ((this._speed * 1.5) * (1 - (this._times * 0.1)));
                if (this._tempSpeed < 0)
                {
                    this._tempSpeed = 0;
                };
                this.setPoint(-(this._tempSpeed));
                if (this._times > 4)
                {
                    this._state = 1;
                    this._times = 0;
                    this._maxY = this._living.info.pos.y;
                };
            }
            else
            {
                if (this._state > 15)
                {
                    this._times++;
                    this._tempSpeed = (this._speed + (this._times * 10));
                    if (this._target.y == this._living.info.pos.y)
                    {
                        this.executeAtOnce();
                        this._times = 0;
                        this._tempSpeed = 0;
                        this._living.map.animateSet.addAnimation(new ShockMapAnimation(this._living, 25, 10, AnimationLevel.HIGHT, this._living.info.LivingID));
                        SoundManager.instance.play("078");
                        return;
                    };
                    this.setPoint(this._tempSpeed);
                    if ((this._target.y - this._living.info.pos.y) < this._speed)
                    {
                        this._living.info.pos = this._target;
                    };
                }
                else
                {
                    this._state++;
                    this._living.info.pos = new Point(this._living.info.pos.x, this._maxY);
                    this._living.map.animateSet.addAnimation(new BaseSetCenterAnimation(this._living.x, (this._living.y - 150), 1, true, AnimationLevel.LOW, this._living.info.LivingID));
                };
            };
        }

        private function executeImp():void
        {
            if ((this._target.y - this._living.info.pos.y) <= this._speed)
            {
                this.executeAtOnce();
            }
            else
            {
                this.setPoint(this._speed);
            };
        }

        private function executeImpShock():void
        {
            if ((this._target.y - this._living.info.pos.y) <= this._speed)
            {
                this.executeAtOnce();
                this._living.map.animateSet.addAnimation(new ShockMapAnimation(this._living, 25, 10, AnimationLevel.HIGHT, this._living.info.LivingID));
                SoundManager.instance.play("078");
            }
            else
            {
                this.setPoint(this._speed);
            };
        }

        private function setPoint(_arg_1:Number):void
        {
            this._living.info.pos = new Point(this._target.x, (this._living.info.pos.y + _arg_1));
            this._living.map.animateSet.addAnimation(new BaseSetCenterAnimation(this._living.x, (this._living.y - 150), 1, true, AnimationLevel.LOW, this._living.info.LivingID));
        }

        override public function executeAtOnce():void
        {
            super.executeAtOnce();
            this._living.info.pos = this._target;
            if (this._living.actionMovie)
            {
                if (this._living.actionMovie.currentAction == Living.STAND_ACTION)
                {
                    this._living.info.doDefaultAction();
                };
            };
            if (this._living.map.IsOutMap(this._target.x, this._target.y))
            {
                this._living.info.die();
            };
            this.finish();
        }

        private function finish():void
        {
            this._living.stopMoving();
            _isFinished = true;
        }


    }
}//package game.actions

