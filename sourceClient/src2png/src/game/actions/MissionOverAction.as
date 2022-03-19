// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.actions.MissionOverAction

package game.actions
{
    import ddt.events.CrazyTankSocketEvent;
    import game.view.map.MapView;
    import game.view.MissionOverInfoPanel;
    import game.model.BaseSettleInfo;
    import game.model.Player;
    import road7th.comm.PackageIn;
    import game.GameManager;
    import game.model.GameInfo;
    import game.view.experience.ExpView;
    import room.RoomManager;
    import ddt.manager.SocketManager;
    import worldboss.WorldBossRoomController;
    import road7th.utils.MovieClipWrapper;
    import flash.display.MovieClip;
    import com.pickgliss.utils.ClassUtils;
    import SingleDungeon.SingleDungeonManager;
    import room.model.RoomInfo;
    import ddt.manager.SoundManager;
    import flash.events.Event;
    import flash.utils.setInterval;
    import game.view.DropGoods;
    import flash.utils.clearInterval;
    import ddt.data.map.MissionInfo;
    import ddt.manager.PlayerManager;
    import ddt.manager.LanguageMgr;

    public class MissionOverAction extends BaseAction 
    {

        private var _event:CrazyTankSocketEvent;
        private var _executed:Boolean;
        private var _count:int;
        private var _map:MapView;
        private var _func:Function;
        private var _intervalId:uint;
        private var infoPane:MissionOverInfoPanel;

        public function MissionOverAction(_arg_1:MapView, _arg_2:CrazyTankSocketEvent, _arg_3:Function, _arg_4:Number=3000)
        {
            this._event = _arg_2;
            this._map = _arg_1;
            this._func = _arg_3;
            this._count = (_arg_4 / 40);
            this.readInfo(this._event);
        }

        private function readInfo(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_6:Object;
            var _local_7:BaseSettleInfo;
            var _local_8:Player;
            var _local_9:int;
            var _local_10:int;
            var _local_11:uint;
            var _local_2:PackageIn = _arg_1.pkg;
            var _local_3:GameInfo = GameManager.Instance.Current;
            _local_3.missionInfo.missionOverPlayer = [];
            _local_3.missionInfo.tackCardType = _local_2.readInt();
            _local_3.hasNextMission = _local_2.readBoolean();
            if (_local_3.hasNextMission)
            {
                _local_3.missionInfo.pic = _local_2.readUTF();
            };
            _local_3.missionInfo.canEnterFinall = _local_2.readBoolean();
            var _local_4:int = _local_2.readInt();
            var _local_5:int;
            while (_local_5 < _local_4)
            {
                _local_6 = new Object();
                _local_7 = new BaseSettleInfo();
                _local_7.playerid = _local_2.readInt();
                _local_7.level = _local_2.readInt();
                _local_7.treatment = _local_2.readInt();
                _local_8 = _local_3.findGamerbyPlayerId(_local_7.playerid);
                _local_6.baseExp = _local_2.readInt();
                _local_6.gpForVIP = _local_2.readInt();
                _local_6.gpForApprenticeTeam = _local_2.readInt();
                _local_6.gpForApprenticeOnline = _local_2.readInt();
                _local_6.gpForSpouse = _local_2.readInt();
                _local_6.gpForServer = _local_2.readInt();
                _local_6.gpForDoubleCard = _local_2.readInt();
                _local_6.consortiaSkill = _local_2.readInt();
                _local_6.gainGP = _local_2.readInt();
                _local_6.totalKill = _local_2.readInt();
                _local_8.isWin = _local_2.readBoolean();
                _local_9 = _local_2.readInt();
                _local_8.GetCardCount = _local_9;
                _local_8.BossCardCount = _local_9;
                _local_8.hasLevelAgain = _local_2.readBoolean();
                _local_8.hasGardGet = _local_2.readBoolean();
                if (_local_8.isWin)
                {
                    if (_local_9 == 0)
                    {
                        _local_6.gameOverType = ExpView.GAME_OVER_TYPE_0;
                    }
                    else
                    {
                        if (((_local_9 == 1) && (!(_local_3.hasNextMission))))
                        {
                            _local_6.gameOverType = ExpView.GAME_OVER_TYPE_6;
                        }
                        else
                        {
                            if (((_local_9 == 1) && (_local_3.hasNextMission)))
                            {
                                _local_6.gameOverType = ExpView.GAME_OVER_TYPE_2;
                                GameManager.Instance.MissionOverType = ExpView.GAME_OVER_TYPE_2;
                            }
                            else
                            {
                                if (((_local_9 == 2) && (_local_3.hasNextMission)))
                                {
                                    _local_6.gameOverType = ExpView.GAME_OVER_TYPE_3;
                                }
                                else
                                {
                                    if (((_local_9 == 2) && (!(_local_3.hasNextMission))))
                                    {
                                        _local_6.gameOverType = ExpView.GAME_OVER_TYPE_4;
                                        GameManager.Instance.MissionOverType = ExpView.GAME_OVER_TYPE_4;
                                    }
                                    else
                                    {
                                        _local_6.gameOverType = ExpView.GAME_OVER_TYPE_0;
                                    };
                                };
                            };
                        };
                    };
                }
                else
                {
                    _local_6.gameOverType = ExpView.GAME_OVER_TYPE_5;
                    if (RoomManager.Instance.current.type == 14)
                    {
                        SocketManager.Instance.out.sendWorldBossRoomStauts(3);
                        WorldBossRoomController.Instance.setSelfStatus(3);
                    };
                };
                _local_8.expObj = _local_6;
                if (_local_8.playerInfo.ID == _local_3.selfGamePlayer.playerInfo.ID)
                {
                    _local_3.selfGamePlayer.BossCardCount = _local_8.BossCardCount;
                };
                _local_3.missionInfo.missionOverPlayer.push(_local_7);
                _local_5++;
            };
            if (_local_3.selfGamePlayer.BossCardCount > 0)
            {
                _local_10 = _local_2.readInt();
                _local_3.missionInfo.missionOverNPCMovies = [];
                _local_11 = 0;
                while (_local_11 < _local_10)
                {
                    _local_3.missionInfo.missionOverNPCMovies.push(_local_2.readUTF());
                    _local_11++;
                };
            };
            _local_3.missionInfo.nextMissionIndex = (_local_3.missionInfo.missionIndex + 1);
        }

        override public function cancel():void
        {
            this._event.executed = true;
        }

        override public function execute():void
        {
            var _local_1:MovieClipWrapper;
            var _local_2:MovieClip;
            if (RoomManager.Instance.current.selfRoomPlayer.isViewer)
            {
                this._executed = true;
            };
            if ((!(this._executed)))
            {
                if (((this._map.hasSomethingMoving() == false) && ((this._map.currentPlayer == null) || (this._map.currentPlayer.actionCount == 0))))
                {
                    this._executed = true;
                    this._event.executed = true;
                    if (this._map.currentPlayer)
                    {
                        this._map.currentPlayer.beginNewTurn();
                    };
                    this.infoPane = new MissionOverInfoPanel();
                    this.upContextView(this.infoPane);
                    if (GameManager.Instance.Current.selfGamePlayer.isWin)
                    {
                        _local_2 = ClassUtils.CreatInstance("asset.game.winAsset");
                    }
                    else
                    {
                        if (((GameManager.Instance.Current.roomType == RoomInfo.SINGLE_DUNGEON) && (SingleDungeonManager.Instance.currentFightType == 3)))
                        {
                            _local_2 = ClassUtils.CreatInstance("asset.game.endAsset");
                        }
                        else
                        {
                            _local_2 = ClassUtils.CreatInstance("asset.game.lostAsset");
                        };
                    };
                    this.infoPane.x = 77;
                    _local_2.addChild(this.infoPane);
                    _local_1 = new MovieClipWrapper(_local_2, false, true);
                    SoundManager.instance.play("040");
                    _local_1.movie.x = 500;
                    _local_1.movie.y = 360;
                    _local_1.addEventListener(Event.COMPLETE, this.__complete);
                    this._intervalId = setInterval(this.showMovie, 100, _local_1);
                };
            }
            else
            {
                this._count--;
                if (this._count <= 0)
                {
                    this._func();
                    _isFinished = true;
                };
            };
        }

        private function showMovie(_arg_1:MovieClipWrapper):void
        {
            if (DropGoods.isOver)
            {
                if (((this._map) && (this._map.gameView)))
                {
                    this._map.gameView.addChild(_arg_1.movie);
                    _arg_1.play();
                };
                clearInterval(this._intervalId);
            };
        }

        private function __complete(_arg_1:Event):void
        {
            MovieClipWrapper(_arg_1.target).removeEventListener(Event.COMPLETE, this.__complete);
            this.infoPane.dispose();
            this.infoPane = null;
        }

        private function upContextView(_arg_1:MissionOverInfoPanel):void
        {
            var _local_2:MissionInfo = GameManager.Instance.Current.missionInfo;
            var _local_3:BaseSettleInfo = GameManager.Instance.Current.missionInfo.findMissionOverInfo(PlayerManager.Instance.Self.ID);
            _arg_1.titleTxt1.text = LanguageMgr.GetTranslation("tank.game.actions.kill");
            _arg_1.valueTxt1.text = String(_local_2.currentValue2);
            _arg_1.titleTxt2.text = LanguageMgr.GetTranslation("tank.game.actions.turn");
            _arg_1.valueTxt2.text = String(_local_2.currentValue1);
            _arg_1.titleTxt3.text = LanguageMgr.GetTranslation("tank.game.BloodStrip.HP");
            _arg_1.valueTxt3.text = String(_local_3.treatment);
        }


    }
}//package game.actions

