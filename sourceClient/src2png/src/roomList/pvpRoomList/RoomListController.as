// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//roomList.pvpRoomList.RoomListController

package roomList.pvpRoomList
{
    import ddt.states.BaseStateView;
    import roomList.LookupRoomFrame;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.SavePointManager;
    import ddt.manager.TaskManager;
    import trainer.view.NewHandContainer;
    import trainer.data.ArrowType;
    import com.pickgliss.ui.LayerManager;
    import ddt.manager.TaskDirectorManager;
    import ddt.data.TaskDirectorType;
    import ddt.manager.SocketManager;
    import ddt.events.CrazyTankSocketEvent;
    import ddt.manager.PlayerTipManager;
    import ddt.view.tips.PlayerTip;
    import room.model.RoomInfo;
    import road7th.comm.PackageIn;
    import ddt.manager.PlayerManager;
    import ddt.data.player.PlayerInfo;
    import ddt.manager.StatisticManager;
    import roomList.LookupEnumerate;
    import par.ParticleManager;
    import ddt.manager.PathManager;
    import com.pickgliss.manager.CacheSysManager;
    import ddt.constants.CacheConsts;
    import ddt.loader.StartupResourceLoader;
    import ddt.manager.SoundManager;
    import ddt.view.MainToolBar;
    import ddt.events.TaskEvent;
    import flash.events.Event;
    import ddt.manager.GameInSocketOut;
    import flash.display.DisplayObject;
    import ddt.states.StateType;
    import flash.events.MouseEvent;
    import ddt.manager.MessageTipManager;
    import ddt.manager.LanguageMgr;
    import ddt.data.player.FriendListPlayer;
    import room.RoomManager;

    public class RoomListController extends BaseStateView 
    {

        private static var isShowTutorial:Boolean = false;
        private static var _instance:RoomListController;

        private var _model:RoomListModel;
        private var _view:RoomListView;
        private var _createRoomView:RoomListCreateRoomView;
        private var _findRoom:LookupRoomFrame;
        private var _roomListFrame:RoomListViewFrame;

        public function RoomListController()
        {
            this._model = new RoomListModel();
        }

        public static function get Instance():RoomListController
        {
            if (_instance == null)
            {
                _instance = new (RoomListController)();
            };
            return (_instance);
        }


        public function setup():void
        {
            this.createRoom();
        }

        private function init():void
        {
            if (this._roomListFrame)
            {
                this._roomListFrame = null;
            };
            this._roomListFrame = ComponentFactory.Instance.creatCustomObject("ddtRoomListViewFrame", [this, this._model]);
            this._roomListFrame.show();
            if ((((((TaskManager.instance.isNewHandTaskAchieved(10)) && (SavePointManager.Instance.isInSavePoint(15))) && (!(TaskManager.instance.isNewHandTaskCompleted(11)))) || (((TaskManager.instance.isNewHandTaskAchieved(14)) && (TaskManager.instance.isNewHandTaskAchieved(13))) && (SavePointManager.Instance.isInSavePoint(19)))) || ((TaskManager.instance.isNewHandTaskAchieved(17)) && (SavePointManager.Instance.isInSavePoint(22)))))
            {
                NewHandContainer.Instance.showArrow(ArrowType.BACK_GUILDE, -135, "roomList.back", "", "", LayerManager.Instance.getLayerByType(LayerManager.BLCAK_BLOCKGOUND));
            };
        }

        override public function showDirect():void
        {
            TaskDirectorManager.instance.showDirector(TaskDirectorType.ROOM_LIST);
        }

        private function initEvent():void
        {
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_ROOMLIST_UPDATE, this.__addRoom);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SCENE_ADD_USER, this.__addWaitingPlayer);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SCENE_REMOVE_USER, this.__removeWaitingPlayer);
            PlayerTipManager.instance.addEventListener(PlayerTip.CHALLENGE, this.__onChanllengeClick);
        }

        private function __addRoom(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_6:int;
            var _local_7:RoomInfo;
            var _local_2:Array = [];
            var _local_3:PackageIn = _arg_1.pkg;
            this._model.roomTotal = _local_3.readInt();
            var _local_4:int = _local_3.readInt();
            var _local_5:int;
            while (_local_5 < _local_4)
            {
                _local_6 = _local_3.readInt();
                _local_7 = this._model.getRoomById(_local_6);
                if (_local_7 == null)
                {
                    _local_7 = new RoomInfo();
                };
                _local_7.ID = _local_6;
                _local_7.type = _local_3.readByte();
                _local_7.timeType = _local_3.readByte();
                _local_7.totalPlayer = _local_3.readByte();
                _local_7.viewerCnt = _local_3.readByte();
                _local_7.maxViewerCnt = _local_3.readByte();
                _local_7.placeCount = _local_3.readByte();
                _local_7.IsLocked = _local_3.readBoolean();
                _local_7.mapId = _local_3.readInt();
                _local_7.isPlaying = _local_3.readBoolean();
                _local_7.Name = _local_3.readUTF();
                _local_7.gameMode = _local_3.readByte();
                _local_7.hardLevel = _local_3.readByte();
                _local_7.levelLimits = _local_3.readInt();
                _local_7.isOpenBoss = _local_3.readBoolean();
                _local_2.push(_local_7);
                _local_5++;
            };
            this.updataRoom(_local_2);
        }

        private function updataRoom(_arg_1:Array):void
        {
            if (_arg_1.length == 0)
            {
                this._model.updateRoom(_arg_1);
                return;
            };
            if ((((_arg_1[0] as RoomInfo).type <= 2) || ((_arg_1[0] as RoomInfo).type == RoomInfo.MULTI_MATCH)))
            {
                this._model.updateRoom(_arg_1);
            };
        }

        private function __addWaitingPlayer(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:PackageIn = _arg_1.pkg;
            var _local_3:PlayerInfo = PlayerManager.Instance.findPlayer(_local_2.clientId);
            _local_3.beginChanges();
            _local_3.Grade = _local_2.readInt();
            _local_3.Sex = _local_2.readBoolean();
            _local_3.NickName = _local_2.readUTF();
            _local_3.VIPtype = _local_2.readByte();
            _local_3.VIPLevel = _local_2.readInt();
            _local_3.ConsortiaName = _local_2.readUTF();
            _local_3.Offer = _local_2.readInt();
            _local_3.WinCount = _local_2.readInt();
            _local_3.TotalCount = _local_2.readInt();
            _local_3.EscapeCount = _local_2.readInt();
            _local_3.ConsortiaID = _local_2.readInt();
            _local_3.Repute = _local_2.readInt();
            _local_3.IsMarried = _local_2.readBoolean();
            if (_local_3.IsMarried)
            {
                _local_3.SpouseID = _local_2.readInt();
                _local_3.SpouseName = _local_2.readUTF();
            };
            _local_3.LoginName = _local_2.readUTF();
            _local_3.FightPower = _local_2.readInt();
            _local_3.apprenticeshipState = _local_2.readInt();
            _local_3.isOld = _local_2.readBoolean();
            _local_3.commitChanges();
            this._model.addWaitingPlayer(_local_3);
        }

        private function __removeWaitingPlayer(_arg_1:CrazyTankSocketEvent):void
        {
            this._model.removeWaitingPlayer(_arg_1.pkg.clientId);
        }

        public function setRoomShowMode(_arg_1:int):void
        {
            this._model.roomShowMode = _arg_1;
        }

        private function createRoom():void
        {
            StatisticManager.loginRoomListNum++;
            SocketManager.Instance.out.sendCurrentState(1);
            this.init();
            this.initEvent();
            SocketManager.Instance.out.sendSceneLogin(LookupEnumerate.ROOM_LIST);
            ParticleManager.initPartical(PathManager.FLASHSITE);
            CacheSysManager.unlock(CacheConsts.ALERT_IN_FIGHT);
            CacheSysManager.getInstance().release(CacheConsts.ALERT_IN_FIGHT, 1200);
            this.__showWeakGuilde();
            PlayerManager.Instance.Self.isUpGradeInGame = false;
        }

        override public function enter(_arg_1:BaseStateView, _arg_2:Object=null):void
        {
            if ((!(StartupResourceLoader.firstEnterHall)))
            {
                SoundManager.instance.playMusic("062");
            };
            super.enter(_arg_1, _arg_2);
            StatisticManager.loginRoomListNum++;
            SocketManager.Instance.out.sendCurrentState(1);
            SocketManager.Instance.out.sendSceneLogin(LookupEnumerate.ROOM_LIST);
            this.init();
            this.initEvent();
            MainToolBar.Instance.show();
            ParticleManager.initPartical(PathManager.FLASHSITE);
            CacheSysManager.unlock(CacheConsts.ALERT_IN_FIGHT);
            CacheSysManager.getInstance().release(CacheConsts.ALERT_IN_FIGHT, 1200);
            this.__showWeakGuilde();
            PlayerManager.Instance.Self.isUpGradeInGame = false;
        }

        private function __showWeakGuilde(_arg_1:TaskEvent=null):void
        {
            if ((((((SavePointManager.Instance.isInSavePoint(14)) && (!(TaskManager.instance.isNewHandTaskCompleted(10)))) || ((SavePointManager.Instance.isInSavePoint(17)) && (!(TaskManager.instance.isNewHandTaskCompleted(13))))) || ((SavePointManager.Instance.isInSavePoint(18)) && (!(TaskManager.instance.isNewHandTaskCompleted(14))))) || ((SavePointManager.Instance.isInSavePoint(55)) && (!(TaskManager.instance.isNewHandTaskCompleted(27))))))
            {
                NewHandContainer.Instance.showArrow(ArrowType.CREAT_ROOM, 0, "trainer.creatRoomArrowPos", "asset.trainer.clickCreatRoom", "trainer.creatRoomTipPos", LayerManager.Instance.getLayerByType(LayerManager.BLCAK_BLOCKGOUND));
            };
        }

        private function __modelCompleted(_arg_1:Event):void
        {
        }

        override public function leaving(_arg_1:BaseStateView):void
        {
            this.dispose();
            GameInSocketOut.sendExitScene();
            MainToolBar.Instance.hide();
            super.leaving(_arg_1);
        }

        override public function getView():DisplayObject
        {
            return (null);
        }

        override public function getType():String
        {
            return (StateType.ROOM_LIST);
        }

        public function sendGoIntoRoom(_arg_1:RoomInfo):void
        {
        }

        public function showFindRoom():void
        {
            if (this._findRoom)
            {
                this._findRoom.dispose();
            };
            this._findRoom = null;
            this._findRoom = ComponentFactory.Instance.creat("asset.ddtroomList.lookupFrame");
            LayerManager.Instance.addToLayer(this._findRoom, LayerManager.GAME_DYNAMIC_LAYER);
        }

        protected function __containerClick(_arg_1:MouseEvent):void
        {
        }

        protected function __onChanllengeClick(_arg_1:Event):void
        {
            if (PlayerTipManager.instance.info.Grade < 13)
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.roomlist.cantBeChallenged"));
                return;
            };
            if (PlayerManager.Instance.checkExpedition())
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("singledungeon.expedition.doing"));
                return;
            };
            if (((PlayerTipManager.instance.info.playerState.StateID == 0) && (_arg_1.target.info is FriendListPlayer)))
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.roomlist.friendOffline"));
                return;
            };
            var _local_2:int = int((Math.random() * RoomListCreateRoomView.PREWORD.length));
            GameInSocketOut.sendCreateRoom(RoomListCreateRoomView.PREWORD[_local_2], RoomInfo.CHALLENGE_ROOM, 2, "");
            RoomManager.Instance.tempInventPlayerID = PlayerTipManager.instance.info.ID;
            PlayerTipManager.instance.removeEventListener(PlayerTip.CHALLENGE, this.__onChanllengeClick);
        }

        public function Dungeondisorder(_arg_1:Array):Array
        {
            var _local_5:int;
            var _local_6:RoomInfo;
            var _local_2:int;
            while (_local_2 < _arg_1.length)
            {
                _local_5 = ((Math.random() * 10000) % _arg_1.length);
                _local_6 = _arg_1[_local_2];
                _arg_1[_local_2] = _arg_1[_local_5];
                _arg_1[_local_5] = _local_6;
                _local_2++;
            };
            var _local_3:Array = [];
            var _local_4:int;
            while (_local_4 < _arg_1.length)
            {
                if ((!((_arg_1[_local_4] as RoomInfo).isPlaying)))
                {
                    _local_3.push(_arg_1[_local_4]);
                }
                else
                {
                    _local_3.unshift(_arg_1[_local_4]);
                };
                _local_4++;
            };
            return (_local_3);
        }

        public function disorder(_arg_1:Array):Array
        {
            var _local_5:int;
            var _local_6:RoomInfo;
            var _local_2:int;
            while (_local_2 < _arg_1.length)
            {
                _local_5 = ((Math.random() * 10000) % _arg_1.length);
                _local_6 = _arg_1[_local_2];
                _arg_1[_local_2] = _arg_1[_local_5];
                _arg_1[_local_5] = _local_6;
                _local_2++;
            };
            var _local_3:Array = [];
            var _local_4:int;
            while (_local_4 < _arg_1.length)
            {
                if (!((!(this._model.currentType == RoomListBGView.FULL_MODE)) && (!((_arg_1[_local_4] as RoomInfo).type == this._model.currentType))))
                {
                    if ((!((_arg_1[_local_4] as RoomInfo).isPlaying)))
                    {
                        _local_3.push(_arg_1[_local_4]);
                    }
                    else
                    {
                        _local_3.unshift(_arg_1[_local_4]);
                    };
                };
                _local_4++;
            };
            return (_local_3);
        }

        public function removeEvent():void
        {
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.GAME_ROOMLIST_UPDATE, this.__addRoom);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.SCENE_ADD_USER, this.__addWaitingPlayer);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.SCENE_REMOVE_USER, this.__removeWaitingPlayer);
        }

        override public function dispose():void
        {
            NewHandContainer.Instance.clearArrowByID(ArrowType.CREAT_ROOM);
            PlayerTipManager.instance.removeEventListener(PlayerTip.CHALLENGE, this.__onChanllengeClick);
            if (this._createRoomView)
            {
                this._createRoomView.dispose();
            };
            if (this._findRoom)
            {
                this._findRoom.dispose();
            };
            if (this._model)
            {
                this._model.dispose();
            };
            if (NewHandContainer.Instance.hasArrow(ArrowType.BACK_GUILDE))
            {
                NewHandContainer.Instance.clearArrowByID(ArrowType.BACK_GUILDE);
            };
            this._createRoomView = null;
            this._roomListFrame.dispose();
            this._model = null;
            this._findRoom = null;
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.GAME_ROOMLIST_UPDATE, this.__addRoom);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.SCENE_ADD_USER, this.__addWaitingPlayer);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.SCENE_REMOVE_USER, this.__removeWaitingPlayer);
        }

        override public function getBackType():String
        {
            return (StateType.MAIN);
        }

        public function showCreateView():void
        {
            if (this._createRoomView != null)
            {
                this._createRoomView.dispose();
            };
            this._createRoomView = null;
            this._createRoomView = ComponentFactory.Instance.creat("roomList.pvpRoomList.RoomListCreateRoomView");
            LayerManager.Instance.addToLayer(this._createRoomView, LayerManager.GAME_DYNAMIC_LAYER, false, LayerManager.BLCAK_BLOCKGOUND);
        }


    }
}//package roomList.pvpRoomList

