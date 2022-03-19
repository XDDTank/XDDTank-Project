// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.actions.PlayerWalkAction

package game.actions
{
    import game.objects.GameLiving;
    import flash.geom.Point;
    import ddt.view.character.GameCharacter;
    import game.objects.GamePlayer;
    import playerParticle.PlayerParticleManager;
    import ddt.manager.SoundManager;
    import game.GameManager;
    import game.animations.AnimationLevel;

    public class PlayerWalkAction extends BaseAction 
    {

        private var _living:GameLiving;
        private var _action:*;
        private var _target:Point;
        private var _dir:Number;

        public function PlayerWalkAction(_arg_1:GameLiving, _arg_2:Point, _arg_3:Number, _arg_4:*=null)
        {
            _isFinished = false;
            this._living = _arg_1;
            this._action = ((_arg_4) ? _arg_4 : GameCharacter.WALK);
            this._target = _arg_2;
            this._dir = _arg_3;
        }

        override public function connect(_arg_1:BaseAction):Boolean
        {
            var _local_2:PlayerWalkAction = (_arg_1 as PlayerWalkAction);
            if (_local_2)
            {
                this._target = _local_2._target;
                this._dir = _local_2._dir;
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
            if (this._living.isLiving)
            {
                this._living.startMoving();
            }
            else
            {
                this.finish();
            };
        }

        override public function execute():void
        {
            var _local_1:Point;
            if (((Point.distance(this._living.pos, this._target) <= this._living.stepX) || (this._target.x == this._living.x)))
            {
                this.finish();
            }
            else
            {
                this._living.info.direction = ((this._target.x > this._living.x) ? 1 : -1);
                _local_1 = this._living.getNextWalkPoint(this._living.info.direction);
                if ((((_local_1 == null) || ((this._living.info.direction > 0) && (_local_1.x >= this._target.x))) || ((this._living.info.direction < 0) && (_local_1.x <= this._target.x))))
                {
                    this.finish();
                }
                else
                {
                    if ((this._living is GamePlayer))
                    {
                        PlayerParticleManager.instance.saveParticlePos(GamePlayer(this._living).info.pos, GamePlayer(this._living).info.direction, GamePlayer(this._living).Id);
                    };
                    this._living.info.pos = _local_1;
                    this._living.doAction(this._action);
                    if ((this._living is GamePlayer))
                    {
                        GamePlayer(this._living).body.WingState = GameCharacter.GAME_WING_MOVE;
                    };
                    SoundManager.instance.play("044", false, false);
                    if (GameManager.Instance.Current.isMultiGame)
                    {
                        if ((!(this._living.info.isHidden)))
                        {
                            this._living.needFocus(0, 0, {
                                "strategy":"directly",
                                "priority":AnimationLevel.MIDDLE
                            });
                        };
                    }
                    else
                    {
                        if (this._living.info.isSelf)
                        {
                            this._living.needFocus(0, 0, {
                                "strategy":"directly",
                                "priority":AnimationLevel.MIDDLE
                            });
                        };
                    };
                };
            };
        }

        private function finish():void
        {
            this._living.info.pos = this._target;
            this._living.info.direction = this._dir;
            this._living.stopMoving();
            if (this._living.isLiving)
            {
                this._living.doAction(GameCharacter.STAND);
            };
            _isFinished = true;
        }

        override public function executeAtOnce():void
        {
            super.executeAtOnce();
            this._living.info.pos = this._target;
            this._living.info.direction = this._dir;
            this._living.stopMoving();
        }


    }
}//package game.actions

