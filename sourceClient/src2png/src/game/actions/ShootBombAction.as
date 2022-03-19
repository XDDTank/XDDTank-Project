// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.actions.ShootBombAction

package game.actions
{
    import game.objects.GameTurnedLiving;
    import ddt.command.PlayerAction;
    import ddt.data.BallInfo;
    import ddt.events.CrazyTankSocketEvent;
    import game.objects.BossPlayer;
    import game.view.Bomb;
    import game.objects.GamePlayer;
    import ddt.manager.BallManager;
    import ddt.view.character.GameCharacter;
    import game.animations.AnimationLevel;
    import game.objects.GameLiving;
    import flash.events.Event;
    import game.objects.BossLocalPlayer;
    import game.objects.GameLocalPlayer;
    import game.model.LocalPlayer;
    import phy.bombs.BaseBomb;
    import ddt.manager.SoundManager;
    import game.objects.ActionType;
    import ddt.data.EquipType;
    import game.objects.SkillBomb;
    import game.objects.SimpleBomb;

    public class ShootBombAction extends BaseAction 
    {

        private var _player:GameTurnedLiving;
        private var _showAction:PlayerAction;
        private var _hideAction:PlayerAction;
        private var _bombs:Array;
        private var _isShoot:Boolean;
        private var _shootInterval:int;
        private var _info:BallInfo;
        private var _event:CrazyTankSocketEvent;
        private var isBossPlayer:Boolean = false;
        private var _prepared:Boolean;
        private var _shootAction:String;
        private var _completeCount:int;
        private var _completeCall:Function;

        public function ShootBombAction(_arg_1:GameTurnedLiving, _arg_2:Array, _arg_3:CrazyTankSocketEvent, _arg_4:int, _arg_5:String="beatA")
        {
            this._player = _arg_1;
            this.isBossPlayer = (((this._player as BossPlayer) == null) ? false : true);
            this._bombs = _arg_2;
            this._event = _arg_3;
            this._shootInterval = _arg_4;
            this._event.executed = false;
            this._prepared = false;
            this._shootAction = _arg_5;
        }

        public function get BombEx():Bomb
        {
            return (this._bombs[0] as Bomb);
        }

        override public function prepare():void
        {
            var _local_1:GamePlayer;
            if (_isPrepare)
            {
                return;
            };
            _isPrepare = true;
            if ((!(this.isBossPlayer)))
            {
                _local_1 = (this._player as GamePlayer);
                if ((((this._player == null) || (_local_1.body == null)) || (_local_1.player == null)))
                {
                    this.finish();
                    return;
                };
            };
            if (_local_1)
            {
                this._info = BallManager.findBall(_local_1.player.currentBomb);
                this._showAction = ((this._info.ActionType == 0) ? GameCharacter.THROWS : GameCharacter.SHOT);
                this._hideAction = ((this._info.ActionType == 0) ? GameCharacter.HIDETHROWS : GameCharacter.HIDEGUN);
                if (_local_1.isLiving)
                {
                    _local_1.body.doAction(this._showAction);
                    if (_local_1.weaponMovie)
                    {
                        _local_1.weaponMovie.visible = true;
                        _local_1.setWeaponMoiveActionSyc("shot");
                        _local_1.body.WingState = GameCharacter.GAME_WING_SHOOT;
                    };
                };
            }
            else
            {
                this._info = BallManager.findBall(this._bombs[0].Template.ID);
                this._player.map.requestForFocus(this._player, AnimationLevel.LOW);
                this._player.actionMovie.addEventListener(GameLiving.SHOOT_PREPARED, this.onEventPrepared);
                this._player.actionMovie.doAction(this._shootAction, this.onCallbackPrepared);
            };
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
            this._player.actionMovie.removeEventListener(GameLiving.SHOOT_PREPARED, this.onEventPrepared);
            this._prepared = true;
            this._player.map.cancelFocus(this._player);
        }

        override public function execute():void
        {
            var _local_1:GamePlayer;
            if (_isFinished)
            {
                return;
            };
            if ((!(this.isBossPlayer)))
            {
                _local_1 = (this._player as GamePlayer);
            };
            if (_local_1)
            {
                if ((((this._player == null) || (_local_1.body == null)) || (_local_1.body.currentAction == null)))
                {
                    this.finish();
                    return;
                };
                if (_local_1.body.currentAction != this._showAction)
                {
                    if (_local_1.weaponMovie)
                    {
                        _local_1.weaponMovie.visible = false;
                    };
                    _local_1.body.WingState = GameCharacter.GAME_WING_WAIT;
                };
                if ((!(this._isShoot)))
                {
                    if (((!(_local_1.body.actionPlaying())) || (!(_local_1.body.currentAction == this._showAction))))
                    {
                        this.executeImp(false);
                    };
                }
                else
                {
                    this._shootInterval--;
                    if (this._shootInterval <= 0)
                    {
                        if (_local_1.body.currentAction == this._showAction)
                        {
                            if (this._player.isLiving)
                            {
                                _local_1.body.doAction(this._hideAction);
                            };
                            if (_local_1.weaponMovie)
                            {
                                _local_1.setWeaponMoiveActionSyc("end");
                            };
                            _local_1.body.WingState = GameCharacter.GAME_WING_WAIT;
                        };
                        this.finish();
                    };
                };
            }
            else
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
                        this.finish();
                    };
                };
            };
        }

        private function setSelfShootFinish():void
        {
            if ((!(this._player.isExist)))
            {
                return;
            };
            if ((!(this._player.info.isSelf)))
            {
                return;
            };
            if ((this._player is BossLocalPlayer))
            {
                return;
            };
            if (GameLocalPlayer(this._player).shootOverCount >= LocalPlayer(this._player.info).shootCount)
            {
                GameLocalPlayer(this._player).shootOverCount = LocalPlayer(this._player.info).shootCount;
            }
            else
            {
                GameLocalPlayer(this._player).shootOverCount++;
            };
            if (GameLocalPlayer(this._player).body.currentAction == this._showAction)
            {
                if (this._player.isLiving)
                {
                    GameLocalPlayer(this._player).body.doAction(this._hideAction);
                };
            };
        }

        private function finish():void
        {
            _isFinished = true;
            this._event.executed = true;
            this.setSelfShootFinish();
        }

        private function executeImp(_arg_1:Boolean):void
        {
            var _local_2:GamePlayer;
            var _local_3:int;
            var _local_4:Bomb;
            var _local_5:int;
            var _local_6:BaseBomb;
            if ((!(this.isBossPlayer)))
            {
                _local_2 = (this._player as GamePlayer);
            };
            if ((!(this._isShoot)))
            {
                this._isShoot = true;
                SoundManager.instance.play(this._info.ShootSound);
                _local_3 = 0;
                while (_local_3 < this._bombs.length)
                {
                    _local_5 = 0;
                    while (_local_5 < this._bombs[_local_3].Actions.length)
                    {
                        if (this._bombs[_local_3].Actions[_local_5].type == ActionType.KILL_PLAYER)
                        {
                            this._bombs.unshift(this._bombs.splice(_local_3, 1)[0]);
                            break;
                        };
                        _local_5++;
                    };
                    _local_3++;
                };
                for each (_local_4 in this._bombs)
                {
                    if (_local_4.Template.ID == EquipType.LaserBomdID)
                    {
                        _local_6 = new SkillBomb(_local_4, this._player.info);
                    }
                    else
                    {
                        if (_local_2)
                        {
                            _local_6 = new SimpleBomb(_local_4, this._player.info, _local_2.player.currentWeapInfo.refineryLevel);
                        }
                        else
                        {
                            _local_6 = new SimpleBomb(_local_4, this._player.info);
                        };
                    };
                    this._player.map.addPhysical(_local_6);
                    if (_arg_1)
                    {
                        _local_6.bombAtOnce();
                    };
                    _local_6.addEventListener(Event.COMPLETE, this.__complete);
                };
            };
        }

        protected function __complete(_arg_1:Event):void
        {
            _arg_1.target.removeEventListener(Event.COMPLETE, this.__complete);
            this._completeCount++;
            if (this._completeCount == this._bombs.length)
            {
                if (this._completeCall != null)
                {
                    this._completeCall();
                };
                this._completeCall = null;
            };
        }

        override public function executeAtOnce():void
        {
            super.executeAtOnce();
            this.executeImp(true);
        }

        public function get completeCall():Function
        {
            return (this._completeCall);
        }

        public function set completeCall(_arg_1:Function):void
        {
            this._completeCall = _arg_1;
        }


    }
}//package game.actions

