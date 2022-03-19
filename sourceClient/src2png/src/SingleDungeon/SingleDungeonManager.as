// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//SingleDungeon.SingleDungeonManager

package SingleDungeon
{
    import flash.events.EventDispatcher;
    import __AS3__.vec.Vector;
    import SingleDungeon.model.MapSceneModel;
    import SingleDungeon.model.BigMapModel;
    import road7th.data.DictionaryData;
    import SingleDungeon.model.SingleDungeonWalkMapModel;
    import SingleDungeon.model.SingleDungeonPlayerInfo;
    import flash.geom.Point;
    import flash.display.Shape;
    import com.pickgliss.loader.BaseLoader;
    import ddt.view.UIModuleSmallLoading;
    import com.pickgliss.loader.UIModuleLoader;
    import com.pickgliss.events.UIModuleEvent;
    import ddt.data.UIModuleTypes;
    import SingleDungeon.dataAnalyzer.MapSceneDataAnalyzer;
    import SingleDungeon.dataAnalyzer.BigMapDataAnalyzer;
    import com.pickgliss.loader.LoadResourceManager;
    import flash.events.Event;
    import com.pickgliss.loader.LoaderEvent;
    import com.pickgliss.utils.ObjectUtils;
    import SingleDungeon.dataAnalyzer.MapSceneObjectsAnalyzer;
    import SingleDungeon.model.WalkMapObject;
    import room.RoomManager;
    import ddt.events.CrazyTankSocketEvent;
    import ddt.manager.PlayerManager;
    import ddt.manager.SocketManager;
    import road7th.comm.PackageIn;
    import SingleDungeon.hardMode.HardModeManager;
    import SingleDungeon.event.SingleDungeonEvent;
    import SingleDungeon.event.CDCollingEvent;
    import SingleDungeon.expedition.ExpeditionHistory;
    import SingleDungeon.model.MissionType;
    import ddt.manager.GameInSocketOut;
    import room.model.RoomInfo;
    import game.GameManager;
    import ddt.manager.StateManager;
    import ddt.manager.ChatManager;
    import com.pickgliss.ui.LayerManager;
    import ddt.data.player.PlayerInfo;
    import flash.utils.setTimeout;
    import ddt.manager.PathManager;
    import ddt.states.StateType;
    import ddt.manager.SharedManager;
    import __AS3__.vec.*;

    public class SingleDungeonManager extends EventDispatcher 
    {

        private static var _instance:SingleDungeonManager;

        public var mapSceneList:Vector.<MapSceneModel>;
        public var mapList:Vector.<BigMapModel>;
        public var mapHardSceneList:Vector.<MapSceneModel>;
        public var hardModeDungeonInfoDic:DictionaryData;
        public var _singleDungeonWalkMapModel:SingleDungeonWalkMapModel;
        public var mainView:SingleDungeonMainStateView;
        private var mapObjDic:DictionaryData;
        public var startBtnEnabled:Boolean = true;
        public var robotList:Vector.<SingleDungeonPlayerInfo>;
        public var currentMapId:int;
        public var isNowBossFight:Boolean = false;
        public var isHardMode:Boolean = false;
        private var _func:Function;
        private var _funcParams:Array;
        private var _loadComplete:Boolean = false;
        public var currentFightType:int;
        public var SelfPoint:Point;
        public var CanPointClick:DictionaryData = new DictionaryData();
        private var blackBG:Shape;
        private var _bigMapImageFun:Function;
        private var _loader:BaseLoader;

        public function SingleDungeonManager()
        {
            this._singleDungeonWalkMapModel = new SingleDungeonWalkMapModel();
            this.mapObjDic = new DictionaryData();
            this.mapSceneList = new Vector.<MapSceneModel>();
            this.mapHardSceneList = new Vector.<MapSceneModel>();
            this.hardModeDungeonInfoDic = new DictionaryData();
            this.initEvent();
        }

        public static function get Instance():SingleDungeonManager
        {
            if (_instance == null)
            {
                _instance = new (SingleDungeonManager)();
            };
            return (_instance);
        }


        public function get loadComplete():Boolean
        {
            return (this._loadComplete);
        }

        public function loadModule(_arg_1:Function=null, _arg_2:Array=null, _arg_3:Boolean=false):void
        {
            this._func = _arg_1;
            this._funcParams = _arg_2;
            if (this.loadComplete)
            {
                if (null != this._func)
                {
                    this._func.apply(null, this._funcParams);
                };
                this._func = null;
                this._funcParams = null;
            }
            else
            {
                UIModuleSmallLoading.Instance.progress = 0;
                if ((!(_arg_3)))
                {
                    UIModuleSmallLoading.Instance.show();
                };
                UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.loadCompleteHandler);
                UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS, this.onUimoduleLoadProgress);
                UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.DDTSINGLEDUNGEON);
            };
        }

        private function onUimoduleLoadProgress(_arg_1:UIModuleEvent):void
        {
            if (_arg_1.module == UIModuleTypes.DDTSINGLEDUNGEON)
            {
                UIModuleSmallLoading.Instance.progress = (_arg_1.loader.progress * 100);
            };
        }

        private function loadCompleteHandler(_arg_1:UIModuleEvent):void
        {
            if (_arg_1.module == UIModuleTypes.DDTSINGLEDUNGEON)
            {
                this._loadComplete = true;
                UIModuleSmallLoading.Instance.hide();
                UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.loadCompleteHandler);
                UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS, this.onUimoduleLoadProgress);
                if (null != this._func)
                {
                    this._func.apply(null, this._funcParams);
                };
                this._func = null;
                this._funcParams = null;
            };
        }

        public function DungeonListComplete(_arg_1:MapSceneDataAnalyzer):void
        {
            var _local_2:MapSceneModel;
            for each (_local_2 in _arg_1.mapSceneList)
            {
                if (_local_2.Type != 4)
                {
                    this.mapSceneList.push(_local_2);
                }
                else
                {
                    this.mapHardSceneList.push(_local_2);
                };
            };
        }

        public function mapListComplete(_arg_1:BigMapDataAnalyzer):void
        {
            this.mapList = _arg_1.bigMapList;
        }

        private function drawBg():void
        {
            if (this.blackBG == null)
            {
                this.blackBG = new Shape();
                this.blackBG.graphics.beginFill(0, 1);
                this.blackBG.graphics.drawRect(-1000, -1000, 3000, 3000);
                this.blackBG.graphics.endFill();
                this.mainView.addChild(this.blackBG);
            };
        }

        public function getBigMapImage(_arg_1:Function, _arg_2:String):void
        {
            var _local_3:BaseLoader = LoadResourceManager.instance.createLoader(_arg_2, BaseLoader.BITMAP_LOADER);
            this.drawBg();
            this._bigMapImageFun = _arg_1;
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE, this.__onSmallLoadingClose);
            _local_3.addEventListener(LoaderEvent.PROGRESS, this.__onResourceProgress);
            _local_3.addEventListener(LoaderEvent.COMPLETE, this.__onResourceComplete);
            LoadResourceManager.instance.startLoad(_local_3);
        }

        public function removeBigLoaderListener():void
        {
            this._bigMapImageFun = null;
        }

        private function __onResourceProgress(_arg_1:LoaderEvent):void
        {
            UIModuleSmallLoading.Instance.progress = (_arg_1.loader.progress * 100);
        }

        private function __onResourceComplete(_arg_1:LoaderEvent):void
        {
            _arg_1.target.removeEventListener(LoaderEvent.PROGRESS, this.__onResourceProgress);
            _arg_1.target.removeEventListener(LoaderEvent.COMPLETE, this.__onResourceComplete);
            if (this._bigMapImageFun != null)
            {
                this._bigMapImageFun(_arg_1);
            };
            UIModuleSmallLoading.Instance.hide();
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE, this.__onSmallLoadingClose);
            ObjectUtils.disposeObject(this.blackBG);
            this.blackBG = null;
        }

        private function __onSmallLoadingClose(_arg_1:Event):void
        {
            UIModuleSmallLoading.Instance.hide();
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE, this.__onSmallLoadingClose);
        }

        public function loadResFile(_arg_1:Function, _arg_2:String):void
        {
            var _local_3:BaseLoader;
            _local_3 = LoadResourceManager.instance.createLoader(_arg_2, BaseLoader.MODULE_LOADER);
            _local_3.addEventListener(LoaderEvent.COMPLETE, _arg_1);
            LoadResourceManager.instance.startLoad(_local_3);
        }

        public function setMapObjList(_arg_1:MapSceneObjectsAnalyzer):void
        {
            this.mapObjDic = _arg_1.walkMapObjectsDic;
        }

        public function getObjectByID(_arg_1:int):WalkMapObject
        {
            return (this.mapObjDic[_arg_1]);
        }

        public function setupFightEvent():void
        {
            RoomManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_ROOM_CREATE, this.__gameStart);
            RoomManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_ROOM_SETUP_CHANGE, this.__onSetupChanged);
        }

        public function setBossPetNull():void
        {
            PlayerManager.Instance.Self.currentPet = null;
        }

        private function initEvent():void
        {
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.WALKSCENE_PLAYER_ENTER, this.__onEnterSceneMap);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.WALKSCENE_SAVE_POINTS, this._fbDoneUpdate);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.WALKSCENE_ADD_ROBOT, this.__addRobot);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CD_COOLING_TIME, this.__CDColling);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.WALKSCENE_REMOVE_CD, this.__removeCD);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.MONEY_ENTER, this.__moneyEnter);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SINGLEDUNGEON_MODE_UPDATE, this.__updateModeInfo);
        }

        private function __updateModeInfo(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:PackageIn = _arg_1.pkg;
            HardModeManager.instance.baseNum = _local_2.readInt();
            HardModeManager.instance.enterDgCountArr = _local_2.readByteArray();
            dispatchEvent(new SingleDungeonEvent(SingleDungeonEvent.UPDATE_TIMES));
        }

        private function __CDColling(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_5:int;
            var _local_6:int;
            var _local_7:int;
            var _local_8:CDCollingEvent;
            var _local_2:PackageIn = _arg_1.pkg;
            var _local_3:int = _local_2.readInt();
            var _local_4:int;
            while (_local_4 < _local_3)
            {
                _local_5 = _local_2.readInt();
                _local_6 = _local_2.readInt();
                _local_7 = _local_2.readInt();
                _local_8 = new CDCollingEvent(CDCollingEvent.CD_COLLING);
                _local_8.ID = _local_5;
                _local_8.count = _local_6;
                _local_8.collingTime = _local_7;
                dispatchEvent(_local_8);
                _local_4++;
            };
        }

        private function __removeCD(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_5:MapSceneModel;
            var _local_2:PackageIn = _arg_1.pkg;
            var _local_3:int = _local_2.readInt();
            var _local_4:Boolean = _local_2.readBoolean();
            if (_local_4)
            {
                for each (_local_5 in this.mapSceneList)
                {
                    if (_local_3 == _local_5.ID)
                    {
                        _local_5.cdColling = 0;
                    };
                };
            };
        }

        private function __moneyEnter(_arg_1:CrazyTankSocketEvent):void
        {
        }

        private function _fbDoneUpdate(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:PackageIn = _arg_1.pkg;
            var _local_3:int = _local_2.readInt();
            ExpeditionHistory.instance.set((_local_3 - ExpeditionHistory.FB_BASEID));
        }

        private function __gameStart(_arg_1:CrazyTankSocketEvent):void
        {
            RoomManager.Instance.removeEventListener(CrazyTankSocketEvent.GAME_ROOM_CREATE, this.__gameStart);
            var _local_2:MapSceneModel = this._singleDungeonWalkMapModel._mapSceneModel;
            var _local_3:int = ((_local_2.Type == MissionType.HARDMODE) ? 2 : 1);
            GameInSocketOut.sendGameRoomSetUp(_local_2.MissionID, RoomInfo.SINGLE_DUNGEON, false, "", "", 1, _local_3, 0, false, _local_2.MissionID);
        }

        private function __onSetupChanged(_arg_1:CrazyTankSocketEvent):void
        {
            RoomManager.Instance.removeEventListener(CrazyTankSocketEvent.GAME_ROOM_SETUP_CHANGE, this.__onSetupChanged);
            GameInSocketOut.sendGameStart();
            GameManager.Instance.addEventListener(GameManager.START_LOAD, this.__startLoading, false, 0);
        }

        protected function __startLoading(_arg_1:Event):void
        {
            GameManager.Instance.removeEventListener(GameManager.START_LOAD, this.__startLoading);
            StateManager.getInGame_Step_6 = true;
            ChatManager.Instance.input.faceEnabled = false;
            if (GameManager.Instance.Current == null)
            {
                return;
            };
            LayerManager.Instance.clearnGameDynamic();
            GameManager.Instance.gotoRoomLoading();
            StateManager.getInGame_Step_7 = true;
            this.startBtnEnabled = true;
        }

        private function __onEnterSceneMap(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_4:int;
            var _local_5:int;
            var _local_6:int;
            var _local_7:int;
            var _local_8:Boolean;
            var _local_9:PlayerInfo;
            var _local_10:int;
            var _local_11:int;
            var _local_12:SingleDungeonPlayerInfo;
            var _local_13:int;
            var _local_2:PackageIn = _arg_1.pkg;
            var _local_3:Boolean = _local_2.readBoolean();
            if (_local_3)
            {
                _local_4 = _local_2.readInt();
                _local_5 = 0;
                while (_local_5 < _local_4)
                {
                    _local_9 = new PlayerInfo();
                    _local_9.beginChanges();
                    _local_9.Grade = _local_2.readInt();
                    _local_9.Hide = _local_2.readInt();
                    _local_9.Repute = _local_2.readInt();
                    _local_9.ID = _local_2.readInt();
                    _local_9.NickName = _local_2.readUTF();
                    _local_9.VIPtype = _local_2.readByte();
                    _local_9.VIPLevel = _local_2.readInt();
                    _local_9.Sex = _local_2.readBoolean();
                    _local_9.Style = _local_2.readUTF();
                    _local_9.Colors = _local_2.readUTF();
                    _local_9.Skin = _local_2.readUTF();
                    _local_10 = _local_2.readInt();
                    _local_11 = _local_2.readInt();
                    _local_9.FightPower = _local_2.readInt();
                    _local_9.WinCount = _local_2.readInt();
                    _local_9.TotalCount = _local_2.readInt();
                    _local_9.Offer = _local_2.readInt();
                    _local_9.isRobot = _local_2.readBoolean();
                    _local_9.commitChanges();
                    _local_12 = new SingleDungeonPlayerInfo();
                    _local_12.playerInfo = _local_9;
                    _local_12.playerPos = new Point(_local_10, _local_11);
                    if (_local_9.ID != PlayerManager.Instance.Self.ID)
                    {
                        this._singleDungeonWalkMapModel.addPlayer(_local_12);
                    }
                    else
                    {
                        this.SelfPoint = new Point(_local_10, _local_11);
                    };
                    _local_5++;
                };
                _local_6 = _local_2.readInt();
                this._singleDungeonWalkMapModel.getObjects().clear();
                _local_7 = 0;
                while (_local_7 < _local_6)
                {
                    _local_13 = _local_2.readInt();
                    this._singleDungeonWalkMapModel.addObjects(this.getObjectByID(_local_13), _local_7);
                    _local_7++;
                };
                _local_8 = _local_2.readBoolean();
                if (this._singleDungeonWalkMapModel._mapSceneModel.Type == 2)
                {
                    UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__onChatBallComplete);
                    UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.CHAT_BALL);
                }
                else
                {
                    SocketManager.Instance.out.createUserGuide(15);
                    this.setupFightEvent();
                };
            }
            else
            {
                this.startBtnEnabled = true;
            };
        }

        public function __addRobot(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_5:PlayerInfo;
            var _local_6:int;
            var _local_7:int;
            var _local_8:SingleDungeonPlayerInfo;
            this.disposeRobot();
            this.robotList = new Vector.<SingleDungeonPlayerInfo>();
            var _local_2:PackageIn = _arg_1.pkg;
            var _local_3:int = _local_2.readInt();
            var _local_4:int;
            while (_local_4 < _local_3)
            {
                if (_arg_1.pkg.bytesAvailable > 10)
                {
                    _local_5 = new PlayerInfo();
                    _local_5.beginChanges();
                    _local_5.Grade = _local_2.readInt();
                    _local_5.Hide = _local_2.readInt();
                    _local_5.Repute = _local_2.readInt();
                    _local_5.ID = _local_2.readInt();
                    _local_5.NickName = _local_2.readUTF();
                    _local_5.VIPtype = _local_2.readByte();
                    _local_5.VIPLevel = _local_2.readInt();
                    _local_5.Sex = _local_2.readBoolean();
                    _local_5.Style = _local_2.readUTF();
                    _local_5.Colors = _local_2.readUTF();
                    _local_5.Skin = _local_2.readUTF();
                    _local_6 = _local_2.readInt();
                    _local_7 = _local_2.readInt();
                    _local_5.FightPower = _local_2.readInt();
                    _local_5.WinCount = _local_2.readInt();
                    _local_5.TotalCount = _local_2.readInt();
                    _local_5.Offer = _local_2.readInt();
                    _local_5.isRobot = true;
                    _local_5.commitChanges();
                    _local_8 = new SingleDungeonPlayerInfo();
                    _local_8.playerInfo = _local_5;
                    _local_8.playerPos = new Point(_local_6, _local_7);
                    this.robotList.push(_local_8);
                };
                _local_4++;
            };
            setTimeout(this.updateRobot, 1500);
        }

        private function updateRobot():void
        {
            var _local_2:SingleDungeonPlayerInfo;
            var _local_1:int = 4;
            _local_1 = (_local_1 - SingleDungeonManager.Instance._singleDungeonWalkMapModel.getPlayers().length);
            for each (_local_2 in SingleDungeonManager.Instance._singleDungeonWalkMapModel.getPlayers())
            {
                if (_local_2.playerInfo.isRobot)
                {
                    SingleDungeonManager.Instance._singleDungeonWalkMapModel.removeRobot();
                    SingleDungeonManager.Instance._singleDungeonWalkMapModel.addPlayer(this.robotList.pop());
                };
            };
            while (_local_1-- > 0)
            {
                SingleDungeonManager.Instance._singleDungeonWalkMapModel.addPlayer(this.robotList.pop());
            };
        }

        private function disposeRobot():void
        {
            var _local_1:SingleDungeonPlayerInfo;
            if (this.robotList)
            {
                for each (_local_1 in this.robotList)
                {
                    _local_1.dispose();
                    _local_1 = null;
                };
                this.robotList = null;
            };
        }

        private function __onChatBallComplete(_arg_1:UIModuleEvent):void
        {
            if (_arg_1.module == UIModuleTypes.CHAT_BALL)
            {
                UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__onChatBallComplete);
                this.loadResFile(this.loadResComplete, PathManager.solveWalkSceneMapPath(this._singleDungeonWalkMapModel._mapSceneModel.Path));
            };
        }

        private function loadResComplete(_arg_1:LoaderEvent):void
        {
            StateManager.setState(StateType.SINGLEDUNGEON_WALK_MAP);
        }

        public function get maplistIndex():int
        {
            return (SharedManager.Instance.maplistIndex);
        }

        public function set maplistIndex(_arg_1:int):void
        {
            SharedManager.Instance.maplistIndex = _arg_1;
            SharedManager.Instance.save();
        }


    }
}//package SingleDungeon

