// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//worldboss.WorldBossRoomController

package worldboss
{
    import ddt.states.BaseStateView;
    import worldboss.model.WorldBossRoomModel;
    import worldboss.view.WorldBossRoomView;
    import worldboss.view.WaitingWorldBossView;
    import ddt.manager.InviteManager;
    import com.pickgliss.manager.CacheSysManager;
    import ddt.constants.CacheConsts;
    import com.pickgliss.ui.LayerManager;
    import ddt.view.MainToolBar;
    import worldboss.event.WorldBossRoomEvent;
    import flash.events.Event;
    import ddt.data.analyze.WorldBossRankAnalyzer;
    import ddt.data.analyze.WorldBossTimeAnalyzer;
    import road7th.utils.DateUtils;
    import ddt.manager.SocketManager;
    import ddt.events.CrazyTankSocketEvent;
    import ddt.states.StateType;
    import ddt.data.player.PlayerInfo;
    import worldboss.player.PlayerVO;
    import road7th.comm.PackageIn;
    import flash.geom.Point;
    import ddt.manager.PlayerManager;
    import ddt.manager.StateManager;
    import worldboss.player.RankingPersonInfo;
    import com.pickgliss.utils.ObjectUtils;

    public class WorldBossRoomController extends BaseStateView 
    {

        private static var _instance:WorldBossRoomController;
        private static var _isFirstCome:Boolean = true;

        public var _sceneModel:WorldBossRoomModel;
        private var _view:WorldBossRoomView;
        private var _waitingView:WaitingWorldBossView;

        public function WorldBossRoomController()
        {
            this._sceneModel = new WorldBossRoomModel();
        }

        public static function get Instance():WorldBossRoomController
        {
            if ((!(_instance)))
            {
                _instance = new (WorldBossRoomController)();
            };
            return (_instance);
        }


        override public function enter(_arg_1:BaseStateView, _arg_2:Object=null):void
        {
            InviteManager.Instance.enabled = false;
            CacheSysManager.lock(CacheConsts.WORLDBOSS_IN_ROOM);
            super.enter(_arg_1, _arg_2);
            LayerManager.Instance.clearnGameDynamic();
            LayerManager.Instance.clearnStageDynamic();
            MainToolBar.Instance.hide();
            this.addEvent();
            if (_isFirstCome)
            {
                this.init();
                _isFirstCome = false;
            }
            else
            {
                if (this._view)
                {
                    if (WorldBossManager.IsSuccessStartGame)
                    {
                        WorldBossManager.Instance.bossInfo.myPlayerVO.buffs = new Array();
                        this._view.clearBuff();
                    };
                    this.checkSelfStatus();
                    this._view.setViewAgain();
                };
            };
        }

        private function init():void
        {
            this._view = new WorldBossRoomView(this, this._sceneModel);
            this._view.show();
            this._view.showBuff();
            this._waitingView = new WaitingWorldBossView();
            addChild(this._waitingView);
            this._waitingView.visible = false;
            this._waitingView.addEventListener(WorldBossRoomEvent.ENTER_GAME_TIME_OUT, this.__onTimeOut);
        }

        protected function __onTimeOut(_arg_1:Event):void
        {
            this._waitingView.stop();
            this._waitingView.visible = false;
            WorldBossManager.Instance.exitGame();
            this.checkSelfStatus();
        }

        public function setup(_arg_1:WorldBossRankAnalyzer):void
        {
            this._sceneModel.list = _arg_1.list;
            WorldBossManager.Instance.dispatchEvent(new Event(WorldBossManager.UPDATE_WORLDBOSS_SCORE));
        }

        public function timeSetup(_arg_1:WorldBossTimeAnalyzer):void
        {
            this._sceneModel.timeList = _arg_1.list;
        }

        public function beginTime():Array
        {
            var _local_3:Date;
            var _local_1:Array = new Array();
            var _local_2:int;
            while (_local_2 < this._sceneModel.timeList.length)
            {
                if (this._sceneModel.timeList[_local_2].worldBossId != 11)
                {
                    _local_3 = DateUtils.dealWithStringDate(this._sceneModel.timeList[_local_2].worldBossBeginTime);
                    _local_1.push(_local_3);
                };
                _local_2++;
            };
            return (_local_1);
        }

        private function addEvent():void
        {
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.WORLDBOSS_ROOM, this.__addPlayer);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.WORLDBOSS_MOVE, this.__movePlayer);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.WORLDBOSS_EXIT, this.__removePlayer);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.WORLDBOSS_PLAYERSTAUTSUPDATE, this.__updatePlayerStauts);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.WORLDBOSS_PLAYERREVIVE, this.__playerRevive);
            WorldBossManager.Instance.addEventListener(WorldBossRoomEvent.FIGHT_OVER, this.__updata);
            WorldBossManager.Instance.addEventListener(CrazyTankSocketEvent.WORLDBOSS_RANKING_INROOM, this.__updataRanking);
            WorldBossManager.Instance.addEventListener(WorldBossRoomEvent.ENTERING_GAME, this.__onEnteringGame);
            WorldBossManager.Instance.addEventListener(WorldBossRoomEvent.GAME_INIT, this.__onGameInit);
        }

        protected function __onUpdateBlood(_arg_1:Event):void
        {
            if (this._view)
            {
                this._view.refreshHpScript();
            };
        }

        protected function __onGameInit(_arg_1:Event):void
        {
            if (this._view)
            {
                this._view.refreshHpScript();
            };
        }

        protected function __onEnteringGame(_arg_1:Event):void
        {
            this._waitingView.visible = true;
            this._waitingView.start();
        }

        public function checkSelfStatus():void
        {
            this._view.checkSelfStatus();
        }

        public function setSelfStatus(_arg_1:int):void
        {
            this._view.updateSelfStatus(_arg_1);
        }

        private function removeEvent():void
        {
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.WORLDBOSS_ROOM, this.__addPlayer);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.WORLDBOSS_MOVE, this.__movePlayer);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.WORLDBOSS_EXIT, this.__removePlayer);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.WORLDBOSS_PLAYERSTAUTSUPDATE, this.__updatePlayerStauts);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.WORLDBOSS_PLAYERREVIVE, this.__playerRevive);
            WorldBossManager.Instance.removeEventListener(WorldBossRoomEvent.FIGHT_OVER, this.__updata);
            WorldBossManager.Instance.removeEventListener(CrazyTankSocketEvent.WORLDBOSS_RANKING_INROOM, this.__updataRanking);
            WorldBossManager.Instance.removeEventListener(WorldBossRoomEvent.ENTERING_GAME, this.__onEnteringGame);
            WorldBossManager.Instance.removeEventListener(WorldBossRoomEvent.GAME_INIT, this.__onGameInit);
            WorldBossManager.Instance.removeEventListener(WorldBossRoomEvent.BOSS_HP_UPDATA, this.__onUpdateBlood);
            if (this._waitingView)
            {
                this._waitingView.removeEventListener(WorldBossRoomEvent.ENTER_GAME_TIME_OUT, this.__onTimeOut);
            };
        }

        override public function getBackType():String
        {
            return (StateType.MAIN);
        }

        public function __addPlayer(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_3:PlayerInfo;
            var _local_4:int;
            var _local_5:int;
            var _local_6:PlayerVO;
            var _local_2:PackageIn = _arg_1.pkg;
            if (_arg_1.pkg.bytesAvailable > 10)
            {
                _local_3 = new PlayerInfo();
                _local_3.beginChanges();
                _local_3.Grade = _local_2.readInt();
                _local_3.Hide = _local_2.readInt();
                _local_3.Repute = _local_2.readInt();
                _local_3.ID = _local_2.readInt();
                _local_3.NickName = _local_2.readUTF();
                _local_3.VIPtype = _local_2.readByte();
                _local_3.VIPLevel = _local_2.readInt();
                _local_3.Sex = _local_2.readBoolean();
                _local_3.Style = _local_2.readUTF();
                _local_3.Colors = _local_2.readUTF();
                _local_3.Skin = _local_2.readUTF();
                _local_4 = _local_2.readInt();
                _local_5 = _local_2.readInt();
                _local_3.FightPower = _local_2.readInt();
                _local_3.WinCount = _local_2.readInt();
                _local_3.TotalCount = _local_2.readInt();
                _local_3.Offer = _local_2.readInt();
                _local_3.commitChanges();
                _local_6 = new PlayerVO();
                _local_6.playerInfo = _local_3;
                _local_6.playerPos = new Point(_local_4, _local_5);
                _local_6.playerStauts = _local_2.readByte();
                if (_local_3.ID == PlayerManager.Instance.Self.ID)
                {
                    return;
                };
                this._sceneModel.addPlayer(_local_6);
            };
        }

        public function __removePlayer(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:int = _arg_1.pkg.readInt();
            this._sceneModel.removePlayer(_local_2);
        }

        public function __movePlayer(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_9:Point;
            var _local_2:int = _arg_1.pkg.readInt();
            var _local_3:int = _arg_1.pkg.readInt();
            var _local_4:int = _arg_1.pkg.readInt();
            var _local_5:String = _arg_1.pkg.readUTF();
            if (_local_2 == PlayerManager.Instance.Self.ID)
            {
                return;
            };
            var _local_6:Array = _local_5.split(",");
            var _local_7:Array = [];
            var _local_8:uint;
            while (_local_8 < _local_6.length)
            {
                _local_9 = new Point(_local_6[_local_8], _local_6[(_local_8 + 1)]);
                _local_7.push(_local_9);
                _local_8 = (_local_8 + 2);
            };
            this._view.movePlayer(_local_2, _local_7);
        }

        public function __updatePlayerStauts(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:PackageIn = _arg_1.pkg;
            var _local_3:int = _local_2.readInt();
            var _local_4:int = _local_2.readByte();
            var _local_5:Point = new Point(_local_2.readInt(), _local_2.readInt());
            this._view.updatePlayerStauts(_local_3, _local_4, _local_5);
            this._sceneModel.updatePlayerStauts(_local_3, _local_4, _local_5);
        }

        private function __playerRevive(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:PackageIn = _arg_1.pkg;
            var _local_3:int = _local_2.readInt();
            this._view.playerRevive(_local_3);
            WorldBossManager.Instance.dispatchEvent(new WorldBossRoomEvent(WorldBossRoomEvent.REVIER_SUCCESS, _local_3));
        }

        public function __updata(_arg_1:Event):void
        {
            if (StateManager.currentStateType == StateType.WORLDBOSS_ROOM)
            {
                this._view.gameOver();
            };
            this._view.timeComplete();
        }

        public function __updataRanking(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_6:RankingPersonInfo;
            var _local_2:PackageIn = _arg_1.pkg;
            var _local_3:Array = new Array();
            var _local_4:int = _arg_1.pkg.readInt();
            var _local_5:int;
            while (_local_5 < _local_4)
            {
                _local_6 = new RankingPersonInfo();
                _local_6.id = _arg_1.pkg.readInt();
                _local_6.name = _arg_1.pkg.readUTF();
                _local_6.damage = _arg_1.pkg.readInt();
                _local_3.push(_local_6);
                _local_5++;
            };
            this._view.updataRanking(_local_3);
        }

        override public function getType():String
        {
            return (StateType.WORLDBOSS_ROOM);
        }

        override public function leaving(_arg_1:BaseStateView):void
        {
            InviteManager.Instance.enabled = true;
            CacheSysManager.unlock(CacheConsts.WORLDBOSS_IN_ROOM);
            CacheSysManager.getInstance().release(CacheConsts.WORLDBOSS_IN_ROOM);
            super.leaving(_arg_1);
        }

        override public function dispose():void
        {
            this.removeEvent();
            ObjectUtils.disposeAllChildren(this);
            this._view = null;
            CacheSysManager.unlock(CacheConsts.WORLDBOSS_IN_ROOM);
            CacheSysManager.getInstance().release(CacheConsts.WORLDBOSS_IN_ROOM);
            _isFirstCome = true;
        }


    }
}//package worldboss

