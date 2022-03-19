// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.actions.ChangePlayerAction

package game.actions
{
    import game.view.map.MapView;
    import game.model.Living;
    import road7th.comm.PackageIn;
    import ddt.events.CrazyTankSocketEvent;
    import game.model.LocalPlayer;
    import game.objects.SimpleBox;
    import game.GameManager;
    import room.RoomManager;
    import ddt.data.PathInfo;
    import flash.geom.Point;
    import game.animations.AnimationLevel;
    import game.model.TurnedLiving;
    import road7th.data.DictionaryData;
    import road7th.utils.MovieClipWrapper;
    import game.objects.GameLiving;
    import org.aswing.KeyboardManager;
    import ddt.manager.SoundManager;
    import flash.display.MovieClip;
    import com.pickgliss.utils.ClassUtils;

    public class ChangePlayerAction extends BaseAction 
    {

        private var _map:MapView;
        private var _info:Living;
        private var _count:int;
        private var _changed:Boolean;
        private var _pkg:PackageIn;
        private var _event:CrazyTankSocketEvent;

        public function ChangePlayerAction(_arg_1:MapView, _arg_2:Living, _arg_3:CrazyTankSocketEvent, _arg_4:PackageIn, _arg_5:Number=200)
        {
            this._event = _arg_3;
            this._event.executed = false;
            this._pkg = _arg_4;
            this._map = _arg_1;
            this._info = _arg_2;
            this._count = (_arg_5 / 40);
        }

        private function syncMap():void
        {
            var _local_7:LocalPlayer;
            var _local_12:int;
            var _local_13:int;
            var _local_14:int;
            var _local_15:int;
            var _local_16:SimpleBox;
            var _local_17:int;
            var _local_18:Boolean;
            var _local_19:int;
            var _local_20:int;
            var _local_21:int;
            var _local_22:Boolean;
            var _local_23:int;
            var _local_24:int;
            var _local_25:int;
            var _local_26:int;
            var _local_27:int;
            var _local_28:int;
            var _local_29:Living;
            GameManager.Instance.Current.currentTurn = this._pkg.readInt();
            var _local_1:Boolean = this._pkg.readBoolean();
            var _local_2:int = this._pkg.readByte();
            var _local_3:int = this._pkg.readByte();
            var _local_4:int = this._pkg.readByte();
            var _local_5:Array = new Array();
            _local_5 = [_local_1, _local_2, _local_3, _local_4];
            GameManager.Instance.Current.setWind(GameManager.Instance.Current.wind, (this._info.LivingID == GameManager.Instance.Current.selfGamePlayer.LivingID), _local_5);
            this._info.isHidden = this._pkg.readBoolean();
            var _local_6:int = this._pkg.readInt();
            if ((this._info is LocalPlayer))
            {
                _local_7 = LocalPlayer(this._info);
                if (_local_6 > 0)
                {
                    _local_7.turnTime = _local_6;
                }
                else
                {
                    _local_7.turnTime = RoomManager.getTurnTimeByType(RoomManager.Instance.current.timeType);
                };
                if (_local_6 != RoomManager.getTurnTimeByType(RoomManager.Instance.current.timeType))
                {
                };
            };
            var _local_8:int = this._pkg.readInt();
            var _local_9:uint;
            while (_local_9 < _local_8)
            {
                _local_12 = this._pkg.readInt();
                _local_13 = this._pkg.readInt();
                _local_14 = this._pkg.readInt();
                _local_15 = this._pkg.readInt();
                _local_16 = new SimpleBox(_local_12, String(PathInfo.GAME_BOXPIC), _local_15);
                _local_16.x = _local_13;
                _local_16.y = _local_14;
                this._map.addPhysical(_local_16);
                _local_9++;
            };
            var _local_10:int = this._pkg.readInt();
            var _local_11:int;
            while (_local_11 < _local_10)
            {
                _local_17 = this._pkg.readInt();
                _local_18 = this._pkg.readBoolean();
                _local_19 = this._pkg.readInt();
                _local_20 = this._pkg.readInt();
                _local_21 = this._pkg.readInt();
                _local_22 = this._pkg.readBoolean();
                _local_23 = this._pkg.readInt();
                _local_24 = this._pkg.readInt();
                _local_25 = this._pkg.readInt();
                _local_26 = this._pkg.readInt();
                _local_27 = this._pkg.readInt();
                _local_28 = this._pkg.readInt();
                _local_29 = GameManager.Instance.Current.livings[_local_17];
                if (_local_29)
                {
                    _local_29.updateBlood(_local_21, 5);
                    _local_29.isNoNole = _local_22;
                    _local_29.maxEnergy = _local_23;
                    _local_29.psychic = _local_24;
                    if (_local_29.isSelf)
                    {
                        _local_7 = LocalPlayer(_local_29);
                        _local_7.energy = _local_29.maxEnergy;
                        _local_7.shootCount = _local_28;
                        _local_7.dander = _local_25;
                        if (_local_7.currentPet)
                        {
                            _local_7.currentPet.MaxMP = _local_26;
                            _local_7.currentPet.MP = _local_27;
                        };
                        _local_7.soulPropCount = 0;
                    };
                    if ((!(_local_18)))
                    {
                        _local_29.die();
                    }
                    else
                    {
                        _local_29.onChange = false;
                        _local_29.pos = new Point(_local_19, _local_20);
                        _local_29.onChange = true;
                    };
                };
                _local_11++;
            };
        }

        override public function execute():void
        {
            if ((!(this._changed)))
            {
                this._map.lockOwner = -1;
                this._map.animateSet.lockLevel = AnimationLevel.LOW;
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
            var _local_1:Living;
            for each (_local_1 in GameManager.Instance.Current.livings)
            {
                _local_1.lastBombIndex = -1;
            };
            if ((this._info is TurnedLiving))
            {
                TurnedLiving(this._info).isAttacking = true;
            };
            this._info.isReady = false;
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
            var _local_4:MovieClipWrapper;
            if ((!(this._info.isExist)))
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
                _local_2 = GameManager.Instance.Current.livings;
                for each (_local_3 in GameManager.Instance.Current.livings)
                {
                    _local_3.beginNewTurn();
                };
                this._map.gameView.setCurrentPlayer(this._info);
                if (((this._info.playerInfo) && (this._info.playerInfo.isSelf)))
                {
                    (this._map.getPhysical(this._info.LivingID) as GameLiving).needFocus(0, 0, {"priority":3}, true);
                };
                this._info.gemDefense = false;
                if ((((this._info.isLiving) && (this._info is LocalPlayer)) && (!(_arg_1))))
                {
                    KeyboardManager.getInstance().reset();
                    SoundManager.instance.play("016");
                    _local_4 = new MovieClipWrapper(MovieClip(ClassUtils.CreatInstance("asset.game.TurnAsset")), true, true);
                    _local_4.repeat = false;
                    _local_4.movie.mouseChildren = (_local_4.movie.mouseEnabled = false);
                    _local_4.movie.x = 440;
                    _local_4.movie.y = 180;
                    this._map.gameView.addChild(_local_4.movie);
                }
                else
                {
                    SoundManager.instance.play("038");
                    this.changePlayer();
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

