// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.actions.MultiChangePlayerAction

package game.actions
{
    import game.model.GameInfo;
    import game.view.map.MapView;
    import game.model.Living;
    import road7th.comm.PackageIn;
    import ddt.events.CrazyTankSocketEvent;
    import game.GameManager;
    import game.model.LocalPlayer;
    import game.objects.SimpleBox;
    import room.RoomManager;
    import ddt.data.PathInfo;
    import flash.geom.Point;
    import game.animations.AnimationLevel;
    import game.model.TurnedLiving;
    import game.model.Player;
    import road7th.data.DictionaryData;
    import game.objects.GameLiving;
    import road7th.utils.MovieClipWrapper;
    import org.aswing.KeyboardManager;
    import ddt.manager.SoundManager;
    import flash.display.MovieClip;
    import com.pickgliss.utils.ClassUtils;

    public class MultiChangePlayerAction extends BaseAction 
    {

        private var _gameInfo:GameInfo;
        private var _map:MapView;
        private var _info:Living;
        private var _count:int;
        private var _changed:Boolean;
        private var _pkg:PackageIn;
        private var _event:CrazyTankSocketEvent;
        private var _isFirstExecute:Boolean = true;
        private var _isNewTurn:Boolean;

        public function MultiChangePlayerAction(_arg_1:MapView, _arg_2:Living, _arg_3:CrazyTankSocketEvent, _arg_4:PackageIn, _arg_5:Number=200)
        {
            this._event = _arg_3;
            this._event.executed = false;
            this._pkg = _arg_4;
            this._map = _arg_1;
            this._info = _arg_2;
            this._count = (_arg_5 / 40);
            this._gameInfo = GameManager.Instance.Current;
        }

        private function syncMap():void
        {
            var _local_9:LocalPlayer;
            var _local_14:int;
            var _local_15:int;
            var _local_16:int;
            var _local_17:int;
            var _local_18:SimpleBox;
            var _local_19:int;
            var _local_20:Boolean;
            var _local_21:Boolean;
            var _local_22:Boolean;
            var _local_23:int;
            var _local_24:int;
            var _local_25:int;
            var _local_26:int;
            var _local_27:Boolean;
            var _local_28:int;
            var _local_29:int;
            var _local_30:int;
            var _local_31:int;
            var _local_32:int;
            var _local_33:int;
            var _local_34:Living;
            GameManager.Instance.Current.currentTurn = this._pkg.readInt();
            this._isNewTurn = GameManager.Instance.Current.isTurnChanged();
            var _local_1:Boolean = this._pkg.readBoolean();
            var _local_2:int = this._pkg.readByte();
            var _local_3:int = this._pkg.readByte();
            var _local_4:int = this._pkg.readByte();
            var _local_5:Array = [_local_1, _local_2, _local_3, _local_4];
            GameManager.Instance.Current.setWind(GameManager.Instance.Current.wind, (this._info.LivingID == GameManager.Instance.Current.selfGamePlayer.LivingID), _local_5);
            var _local_6:Living = this._gameInfo.findLiving(this._pkg.extend2);
            var _local_7:Boolean = this._pkg.readBoolean();
            if (_local_6)
            {
                _local_6.isHidden = _local_7;
            };
            var _local_8:int = this._pkg.readInt();
            if ((this._info is LocalPlayer))
            {
                _local_9 = LocalPlayer(this._info);
                if (_local_8 > 0)
                {
                    _local_9.turnTime = _local_8;
                }
                else
                {
                    _local_9.turnTime = RoomManager.getTurnTimeByType(RoomManager.Instance.current.timeType);
                };
                if (_local_8 != RoomManager.getTurnTimeByType(RoomManager.Instance.current.timeType))
                {
                };
            };
            var _local_10:int = this._pkg.readInt();
            var _local_11:uint;
            while (_local_11 < _local_10)
            {
                _local_14 = this._pkg.readInt();
                _local_15 = this._pkg.readInt();
                _local_16 = this._pkg.readInt();
                _local_17 = this._pkg.readInt();
                if (this._isNewTurn)
                {
                    _local_18 = new SimpleBox(_local_14, String(PathInfo.GAME_BOXPIC), _local_17);
                    _local_18.x = _local_15;
                    _local_18.y = _local_16;
                    this._map.addPhysical(_local_18);
                };
                _local_11++;
            };
            var _local_12:int = this._pkg.readInt();
            var _local_13:int;
            while (_local_13 < _local_12)
            {
                _local_19 = this._pkg.readInt();
                _local_20 = this._pkg.readBoolean();
                _local_21 = this._pkg.readBoolean();
                _local_22 = this._pkg.readBoolean();
                _local_23 = this._pkg.readInt();
                _local_24 = this._pkg.readInt();
                _local_25 = this._pkg.readInt();
                _local_26 = this._pkg.readInt();
                _local_27 = this._pkg.readBoolean();
                _local_28 = this._pkg.readInt();
                _local_29 = this._pkg.readInt();
                _local_30 = this._pkg.readInt();
                _local_31 = this._pkg.readInt();
                _local_32 = this._pkg.readInt();
                _local_33 = this._pkg.readInt();
                _local_34 = GameManager.Instance.Current.livings[_local_19];
                if (_local_34)
                {
                    _local_34.isHidden = _local_21;
                    _local_34.isFrozen = _local_22;
                    _local_34.updateBlood(_local_26, 5);
                    _local_34.isNoNole = _local_27;
                    _local_34.maxEnergy = _local_28;
                    _local_34.psychic = _local_29;
                    if (_local_34.isSelf)
                    {
                        _local_9 = LocalPlayer(_local_34);
                        _local_9.turnTime = _local_23;
                        _local_9.energy = _local_34.maxEnergy;
                        _local_9.shootCount = _local_33;
                        _local_9.dander = _local_30;
                        if (_local_9.currentPet)
                        {
                            _local_9.currentPet.MaxMP = _local_31;
                            _local_9.currentPet.MP = _local_32;
                        };
                    };
                    if ((!(_local_20)))
                    {
                        _local_34.die();
                    }
                    else
                    {
                        _local_34.onChange = false;
                        _local_34.pos = new Point(_local_24, _local_25);
                        _local_34.onChange = true;
                    };
                };
                _local_13++;
            };
            if ((!(this._isNewTurn)))
            {
                this.changePlayer();
            };
        }

        override public function execute():void
        {
            if (this._isFirstExecute)
            {
                this._map.lockOwner = -1;
                this._map.animateSet.lockLevel = AnimationLevel.LOW;
                this._isFirstExecute = false;
            };
            if ((!(this._changed)))
            {
                if (((this._map.hasSomethingMoving() == false) && ((this._map.currentPlayer == null) || (this._map.currentPlayer.actionCount == 0))))
                {
                    this.executeImp(false);
                };
            }
            else
            {
                this._count--;
                if (this._count <= 0)
                {
                    this.changePlayer();
                };
            };
        }

        private function changePlayer():void
        {
            var _local_2:Living;
            var _local_1:int = this._pkg.extend1;
            if (((this._isNewTurn) && (this._info is TurnedLiving)))
            {
                for each (_local_2 in GameManager.Instance.Current.livings)
                {
                    _local_2.lastBombIndex = -1;
                    if (((_local_2 is Player) && (_local_2.team == _local_1)))
                    {
                        TurnedLiving(_local_2).isAttacking = ((_local_2.isLiving) && (!(_local_2.isFrozen)));
                        TurnedLiving(_local_2).isReady = false;
                    };
                };
            };
            this._gameInfo.selfGamePlayer.soulPropCount = 0;
            this._map.gameView.updateControlBarState(this._info);
            _isFinished = true;
        }

        override public function cancel():void
        {
            this._event.executed = true;
        }

        private function executeImp(_arg_1:Boolean):void
        {
            var _local_2:DictionaryData;
            var _local_3:Living;
            var _local_4:LocalPlayer;
            var _local_5:Living;
            var _local_6:GameLiving;
            var _local_7:MovieClipWrapper;
            if (((!(this._info)) || (!(this._info.isExist))))
            {
                _isFinished = true;
                this._map.gameView.updateControlBarState(null);
                return;
            };
            if ((!(this._changed)))
            {
                this._event.executed = true;
                this._changed = true;
                if (this._pkg)
                {
                    this.syncMap();
                };
                if (this._isNewTurn)
                {
                    _local_2 = GameManager.Instance.Current.livings;
                    for each (_local_3 in _local_2)
                    {
                        _local_3.beginNewTurn();
                    };
                    this._map.gameView.setCurrentPlayer(this._info);
                    if ((this._info is Player))
                    {
                        if (((((this._info.playerInfo) && (this._info.playerInfo.isSelf)) && (!(this._info.isFrozen))) && (this._info.isLiving)))
                        {
                            (this._map.getPhysical(this._info.LivingID) as GameLiving).needFocus(0, 0, {"priority":3}, true);
                            this._map.lockOwner = this._gameInfo.self.LivingID;
                        }
                        else
                        {
                            _local_5 = this._gameInfo.getNearestPlayer(this._gameInfo.teams[this._gameInfo.currentTeam]);
                            if (_local_5)
                            {
                                _local_6 = (this._map.getPhysical(_local_5.LivingID) as GameLiving);
                                if (_local_6)
                                {
                                    if ((_local_6 is Player))
                                    {
                                        this._map.lockOwner = _local_6.info.LivingID;
                                    };
                                    _local_6.needFocus(0, 0, {"priority":3}, true);
                                };
                            };
                        };
                    }
                    else
                    {
                        (this._map.getPhysical(this._info.LivingID) as GameLiving).needFocus(0, 0, {"priority":3}, true);
                    };
                    this._info.gemDefense = false;
                    if ((((((!(_arg_1)) && (this._info.isLiving)) && (this._info is LocalPlayer)) && (this._info.isLiving)) && (!(this._info.isFrozen))))
                    {
                        KeyboardManager.getInstance().reset();
                        SoundManager.instance.play("016");
                        _local_7 = new MovieClipWrapper(MovieClip(ClassUtils.CreatInstance("asset.game.TurnAsset")), true, true);
                        _local_7.repeat = false;
                        _local_7.movie.mouseChildren = (_local_7.movie.mouseEnabled = false);
                        _local_7.movie.x = 440;
                        _local_7.movie.y = 180;
                        this._map.gameView.addChild(_local_7.movie);
                    }
                    else
                    {
                        SoundManager.instance.play("038");
                        this.changePlayer();
                    };
                    _local_4 = GameManager.Instance.Current.selfGamePlayer;
                    if (this._map.currentPlayer)
                    {
                        if (_local_4)
                        {
                            _local_4.soulPropEnabled = ((!(_local_4.isLiving)) && (this._map.currentPlayer.team == _local_4.team));
                        };
                    }
                    else
                    {
                        if (_local_4)
                        {
                            _local_4.soulPropEnabled = false;
                        };
                    };
                    PrepareShootAction.hasDoSkillAnimation = false;
                };
            };
        }

        override public function executeAtOnce():void
        {
            super.executeAtOnce();
            this.executeImp(true);
        }


    }
}//package game.actions

