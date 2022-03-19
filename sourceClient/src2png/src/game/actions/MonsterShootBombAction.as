// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.actions.MonsterShootBombAction

package game.actions
{
    import game.objects.GameLiving;
    import ddt.data.BallInfo;
    import ddt.events.CrazyTankSocketEvent;
    import ddt.manager.BallManager;
    import game.animations.AnimationLevel;
    import flash.events.Event;
    import game.view.Bomb;
    import game.objects.SimpleBomb;
    import ddt.manager.SoundManager;
    import game.objects.ActionType;

    public class MonsterShootBombAction extends BaseAction 
    {

        private var _monster:GameLiving;
        private var _bombs:Array;
        private var _isShoot:Boolean;
        private var _prepared:Boolean;
        private var _prepareAction:String;
        private var _shootInterval:int;
        private var _info:BallInfo;
        private var _event:CrazyTankSocketEvent;
        private var _endAction:String = "";
        private var _canShootImp:Boolean;

        public function MonsterShootBombAction(_arg_1:GameLiving, _arg_2:Array, _arg_3:CrazyTankSocketEvent, _arg_4:int)
        {
            this._monster = _arg_1;
            this._bombs = _arg_2;
            this._event = _arg_3;
            this._prepared = false;
            this._shootInterval = (_arg_4 / 40);
        }

        override public function prepare():void
        {
            this._info = BallManager.findBall(this._bombs[0].Template.ID);
            this._monster.map.requestForFocus(this._monster, AnimationLevel.LOW);
            this._monster.actionMovie.addEventListener(GameLiving.SHOOT_PREPARED, this.onEventPrepared);
            this._monster.actionMovie.doAction("shoot", this.onCallbackPrepared);
        }

        protected function onEventPrepared(_arg_1:Event):void
        {
            this.canShoot();
        }

        protected function onCallbackPrepared():void
        {
            this.canShoot();
        }

        private function canShoot():void
        {
            this._monster.actionMovie.removeEventListener(GameLiving.SHOOT_PREPARED, this.onEventPrepared);
            this._prepared = true;
            this._monster.map.cancelFocus(this._monster);
        }

        override public function execute():void
        {
            if ((!(this._prepared)))
            {
                return;
            };
            if ((!(this._isShoot)))
            {
                this.executeImp(false);
            }
            else
            {
                this._shootInterval--;
                if (this._shootInterval <= 0)
                {
                    _isFinished = true;
                    this._event.executed = true;
                };
            };
        }

        private function executeImp(_arg_1:Boolean):void
        {
            var _local_2:int;
            var _local_3:Bomb;
            var _local_4:int;
            var _local_5:SimpleBomb;
            if ((!(this._isShoot)))
            {
                this._isShoot = true;
                SoundManager.instance.play(this._info.ShootSound);
                _local_2 = 0;
                while (_local_2 < this._bombs.length)
                {
                    _local_4 = 0;
                    while (_local_4 < this._bombs[_local_2].Actions.length)
                    {
                        if (this._bombs[_local_2].Actions[_local_4].type == ActionType.KILL_PLAYER)
                        {
                            this._bombs.unshift(this._bombs.splice(_local_2, 1)[0]);
                            break;
                        };
                        _local_4++;
                    };
                    _local_2++;
                };
                for each (_local_3 in this._bombs)
                {
                    _local_5 = new SimpleBomb(_local_3, this._monster.info);
                    this._monster.map.addPhysical(_local_5);
                    if (_arg_1)
                    {
                        _local_5.bombAtOnce();
                    };
                };
            };
        }


    }
}//package game.actions

