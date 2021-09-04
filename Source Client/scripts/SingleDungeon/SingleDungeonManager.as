package SingleDungeon
{
   import SingleDungeon.dataAnalyzer.BigMapDataAnalyzer;
   import SingleDungeon.dataAnalyzer.MapSceneDataAnalyzer;
   import SingleDungeon.dataAnalyzer.MapSceneObjectsAnalyzer;
   import SingleDungeon.event.CDCollingEvent;
   import SingleDungeon.event.SingleDungeonEvent;
   import SingleDungeon.expedition.ExpeditionHistory;
   import SingleDungeon.hardMode.HardModeManager;
   import SingleDungeon.model.BigMapModel;
   import SingleDungeon.model.MapSceneModel;
   import SingleDungeon.model.MissionType;
   import SingleDungeon.model.SingleDungeonPlayerInfo;
   import SingleDungeon.model.SingleDungeonWalkMapModel;
   import SingleDungeon.model.WalkMapObject;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.UIModuleTypes;
   import ddt.data.player.PlayerInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.ChatManager;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SharedManager;
   import ddt.manager.SocketManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import ddt.view.UIModuleSmallLoading;
   import flash.display.Shape;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.geom.Point;
   import flash.utils.setTimeout;
   import game.GameManager;
   import road7th.comm.PackageIn;
   import road7th.data.DictionaryData;
   import room.RoomManager;
   import room.model.RoomInfo;
   
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
      
      public var CanPointClick:DictionaryData;
      
      private var blackBG:Shape;
      
      private var _bigMapImageFun:Function;
      
      private var _loader:BaseLoader;
      
      public function SingleDungeonManager()
      {
         this.CanPointClick = new DictionaryData();
         super();
         this._singleDungeonWalkMapModel = new SingleDungeonWalkMapModel();
         this.mapObjDic = new DictionaryData();
         this.mapSceneList = new Vector.<MapSceneModel>();
         this.mapHardSceneList = new Vector.<MapSceneModel>();
         this.hardModeDungeonInfoDic = new DictionaryData();
         this.initEvent();
      }
      
      public static function get Instance() : SingleDungeonManager
      {
         if(_instance == null)
         {
            _instance = new SingleDungeonManager();
         }
         return _instance;
      }
      
      public function get loadComplete() : Boolean
      {
         return this._loadComplete;
      }
      
      public function loadModule(param1:Function = null, param2:Array = null, param3:Boolean = false) : void
      {
         this._func = param1;
         this._funcParams = param2;
         if(this.loadComplete)
         {
            if(null != this._func)
            {
               this._func.apply(null,this._funcParams);
            }
            this._func = null;
            this._funcParams = null;
         }
         else
         {
            UIModuleSmallLoading.Instance.progress = 0;
            if(!param3)
            {
               UIModuleSmallLoading.Instance.show();
            }
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.loadCompleteHandler);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.DDTSINGLEDUNGEON);
         }
      }
      
      private function onUimoduleLoadProgress(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.DDTSINGLEDUNGEON)
         {
            UIModuleSmallLoading.Instance.progress = param1.loader.progress * 100;
         }
      }
      
      private function loadCompleteHandler(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.DDTSINGLEDUNGEON)
         {
            this._loadComplete = true;
            UIModuleSmallLoading.Instance.hide();
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.loadCompleteHandler);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
            if(null != this._func)
            {
               this._func.apply(null,this._funcParams);
            }
            this._func = null;
            this._funcParams = null;
         }
      }
      
      public function DungeonListComplete(param1:MapSceneDataAnalyzer) : void
      {
         var _loc2_:MapSceneModel = null;
         for each(_loc2_ in param1.mapSceneList)
         {
            if(_loc2_.Type != 4)
            {
               this.mapSceneList.push(_loc2_);
            }
            else
            {
               this.mapHardSceneList.push(_loc2_);
            }
         }
      }
      
      public function mapListComplete(param1:BigMapDataAnalyzer) : void
      {
         this.mapList = param1.bigMapList;
      }
      
      private function drawBg() : void
      {
         if(this.blackBG == null)
         {
            this.blackBG = new Shape();
            this.blackBG.graphics.beginFill(0,1);
            this.blackBG.graphics.drawRect(-1000,-1000,3000,3000);
            this.blackBG.graphics.endFill();
            this.mainView.addChild(this.blackBG);
         }
      }
      
      public function getBigMapImage(param1:Function, param2:String) : void
      {
         var _loc3_:BaseLoader = LoadResourceManager.instance.createLoader(param2,BaseLoader.BITMAP_LOADER);
         this.drawBg();
         this._bigMapImageFun = param1;
         UIModuleSmallLoading.Instance.progress = 0;
         UIModuleSmallLoading.Instance.show();
         UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onSmallLoadingClose);
         _loc3_.addEventListener(LoaderEvent.PROGRESS,this.__onResourceProgress);
         _loc3_.addEventListener(LoaderEvent.COMPLETE,this.__onResourceComplete);
         LoadResourceManager.instance.startLoad(_loc3_);
      }
      
      public function removeBigLoaderListener() : void
      {
         this._bigMapImageFun = null;
      }
      
      private function __onResourceProgress(param1:LoaderEvent) : void
      {
         UIModuleSmallLoading.Instance.progress = param1.loader.progress * 100;
      }
      
      private function __onResourceComplete(param1:LoaderEvent) : void
      {
         param1.target.removeEventListener(LoaderEvent.PROGRESS,this.__onResourceProgress);
         param1.target.removeEventListener(LoaderEvent.COMPLETE,this.__onResourceComplete);
         if(this._bigMapImageFun != null)
         {
            this._bigMapImageFun(param1);
         }
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onSmallLoadingClose);
         ObjectUtils.disposeObject(this.blackBG);
         this.blackBG = null;
      }
      
      private function __onSmallLoadingClose(param1:Event) : void
      {
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onSmallLoadingClose);
      }
      
      public function loadResFile(param1:Function, param2:String) : void
      {
         var _loc3_:BaseLoader = null;
         _loc3_ = LoadResourceManager.instance.createLoader(param2,BaseLoader.MODULE_LOADER);
         _loc3_.addEventListener(LoaderEvent.COMPLETE,param1);
         LoadResourceManager.instance.startLoad(_loc3_);
      }
      
      public function setMapObjList(param1:MapSceneObjectsAnalyzer) : void
      {
         this.mapObjDic = param1.walkMapObjectsDic;
      }
      
      public function getObjectByID(param1:int) : WalkMapObject
      {
         return this.mapObjDic[param1];
      }
      
      public function setupFightEvent() : void
      {
         RoomManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_ROOM_CREATE,this.__gameStart);
         RoomManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_ROOM_SETUP_CHANGE,this.__onSetupChanged);
      }
      
      public function setBossPetNull() : void
      {
         PlayerManager.Instance.Self.currentPet = null;
      }
      
      private function initEvent() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.WALKSCENE_PLAYER_ENTER,this.__onEnterSceneMap);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.WALKSCENE_SAVE_POINTS,this._fbDoneUpdate);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.WALKSCENE_ADD_ROBOT,this.__addRobot);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CD_COOLING_TIME,this.__CDColling);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.WALKSCENE_REMOVE_CD,this.__removeCD);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.MONEY_ENTER,this.__moneyEnter);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SINGLEDUNGEON_MODE_UPDATE,this.__updateModeInfo);
      }
      
      private function __updateModeInfo(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         HardModeManager.instance.baseNum = _loc2_.readInt();
         HardModeManager.instance.enterDgCountArr = _loc2_.readByteArray();
         dispatchEvent(new SingleDungeonEvent(SingleDungeonEvent.UPDATE_TIMES));
      }
      
      private function __CDColling(param1:CrazyTankSocketEvent) : void
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:CDCollingEvent = null;
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readInt();
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = _loc2_.readInt();
            _loc6_ = _loc2_.readInt();
            _loc7_ = _loc2_.readInt();
            _loc8_ = new CDCollingEvent(CDCollingEvent.CD_COLLING);
            _loc8_.ID = _loc5_;
            _loc8_.count = _loc6_;
            _loc8_.collingTime = _loc7_;
            dispatchEvent(_loc8_);
            _loc4_++;
         }
      }
      
      private function __removeCD(param1:CrazyTankSocketEvent) : void
      {
         var _loc5_:MapSceneModel = null;
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readInt();
         var _loc4_:Boolean = _loc2_.readBoolean();
         if(_loc4_)
         {
            for each(_loc5_ in this.mapSceneList)
            {
               if(_loc3_ == _loc5_.ID)
               {
                  _loc5_.cdColling = 0;
               }
            }
         }
      }
      
      private function __moneyEnter(param1:CrazyTankSocketEvent) : void
      {
      }
      
      private function _fbDoneUpdate(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readInt();
         ExpeditionHistory.instance.set(_loc3_ - ExpeditionHistory.FB_BASEID);
      }
      
      private function __gameStart(param1:CrazyTankSocketEvent) : void
      {
         RoomManager.Instance.removeEventListener(CrazyTankSocketEvent.GAME_ROOM_CREATE,this.__gameStart);
         var _loc2_:MapSceneModel = this._singleDungeonWalkMapModel._mapSceneModel;
         var _loc3_:int = _loc2_.Type == MissionType.HARDMODE ? int(2) : int(1);
         GameInSocketOut.sendGameRoomSetUp(_loc2_.MissionID,RoomInfo.SINGLE_DUNGEON,false,"","",1,_loc3_,0,false,_loc2_.MissionID);
      }
      
      private function __onSetupChanged(param1:CrazyTankSocketEvent) : void
      {
         RoomManager.Instance.removeEventListener(CrazyTankSocketEvent.GAME_ROOM_SETUP_CHANGE,this.__onSetupChanged);
         GameInSocketOut.sendGameStart();
         GameManager.Instance.addEventListener(GameManager.START_LOAD,this.__startLoading,false,0);
      }
      
      protected function __startLoading(param1:Event) : void
      {
         GameManager.Instance.removeEventListener(GameManager.START_LOAD,this.__startLoading);
         StateManager.getInGame_Step_6 = true;
         ChatManager.Instance.input.faceEnabled = false;
         if(GameManager.Instance.Current == null)
         {
            return;
         }
         LayerManager.Instance.clearnGameDynamic();
         GameManager.Instance.gotoRoomLoading();
         StateManager.getInGame_Step_7 = true;
         this.startBtnEnabled = true;
      }
      
      private function __onEnterSceneMap(param1:CrazyTankSocketEvent) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:Boolean = false;
         var _loc9_:PlayerInfo = null;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:SingleDungeonPlayerInfo = null;
         var _loc13_:int = 0;
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:Boolean = _loc2_.readBoolean();
         if(_loc3_)
         {
            _loc4_ = _loc2_.readInt();
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               _loc9_ = new PlayerInfo();
               _loc9_.beginChanges();
               _loc9_.Grade = _loc2_.readInt();
               _loc9_.Hide = _loc2_.readInt();
               _loc9_.Repute = _loc2_.readInt();
               _loc9_.ID = _loc2_.readInt();
               _loc9_.NickName = _loc2_.readUTF();
               _loc9_.VIPtype = _loc2_.readByte();
               _loc9_.VIPLevel = _loc2_.readInt();
               _loc9_.Sex = _loc2_.readBoolean();
               _loc9_.Style = _loc2_.readUTF();
               _loc9_.Colors = _loc2_.readUTF();
               _loc9_.Skin = _loc2_.readUTF();
               _loc10_ = _loc2_.readInt();
               _loc11_ = _loc2_.readInt();
               _loc9_.FightPower = _loc2_.readInt();
               _loc9_.WinCount = _loc2_.readInt();
               _loc9_.TotalCount = _loc2_.readInt();
               _loc9_.Offer = _loc2_.readInt();
               _loc9_.isRobot = _loc2_.readBoolean();
               _loc9_.commitChanges();
               _loc12_ = new SingleDungeonPlayerInfo();
               _loc12_.playerInfo = _loc9_;
               _loc12_.playerPos = new Point(_loc10_,_loc11_);
               if(_loc9_.ID != PlayerManager.Instance.Self.ID)
               {
                  this._singleDungeonWalkMapModel.addPlayer(_loc12_);
               }
               else
               {
                  this.SelfPoint = new Point(_loc10_,_loc11_);
               }
               _loc5_++;
            }
            _loc6_ = _loc2_.readInt();
            this._singleDungeonWalkMapModel.getObjects().clear();
            _loc7_ = 0;
            while(_loc7_ < _loc6_)
            {
               _loc13_ = _loc2_.readInt();
               this._singleDungeonWalkMapModel.addObjects(this.getObjectByID(_loc13_),_loc7_);
               _loc7_++;
            }
            _loc8_ = _loc2_.readBoolean();
            if(this._singleDungeonWalkMapModel._mapSceneModel.Type == 2)
            {
               UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onChatBallComplete);
               UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.CHAT_BALL);
            }
            else
            {
               SocketManager.Instance.out.createUserGuide(15);
               this.setupFightEvent();
            }
         }
         else
         {
            this.startBtnEnabled = true;
         }
      }
      
      public function __addRobot(param1:CrazyTankSocketEvent) : void
      {
         var _loc5_:PlayerInfo = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:SingleDungeonPlayerInfo = null;
         this.disposeRobot();
         this.robotList = new Vector.<SingleDungeonPlayerInfo>();
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readInt();
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            if(param1.pkg.bytesAvailable > 10)
            {
               _loc5_ = new PlayerInfo();
               _loc5_.beginChanges();
               _loc5_.Grade = _loc2_.readInt();
               _loc5_.Hide = _loc2_.readInt();
               _loc5_.Repute = _loc2_.readInt();
               _loc5_.ID = _loc2_.readInt();
               _loc5_.NickName = _loc2_.readUTF();
               _loc5_.VIPtype = _loc2_.readByte();
               _loc5_.VIPLevel = _loc2_.readInt();
               _loc5_.Sex = _loc2_.readBoolean();
               _loc5_.Style = _loc2_.readUTF();
               _loc5_.Colors = _loc2_.readUTF();
               _loc5_.Skin = _loc2_.readUTF();
               _loc6_ = _loc2_.readInt();
               _loc7_ = _loc2_.readInt();
               _loc5_.FightPower = _loc2_.readInt();
               _loc5_.WinCount = _loc2_.readInt();
               _loc5_.TotalCount = _loc2_.readInt();
               _loc5_.Offer = _loc2_.readInt();
               _loc5_.isRobot = true;
               _loc5_.commitChanges();
               _loc8_ = new SingleDungeonPlayerInfo();
               _loc8_.playerInfo = _loc5_;
               _loc8_.playerPos = new Point(_loc6_,_loc7_);
               this.robotList.push(_loc8_);
            }
            _loc4_++;
         }
         setTimeout(this.updateRobot,1500);
      }
      
      private function updateRobot() : void
      {
         var _loc2_:SingleDungeonPlayerInfo = null;
         var _loc1_:int = 4;
         _loc1_ -= SingleDungeonManager.Instance._singleDungeonWalkMapModel.getPlayers().length;
         for each(_loc2_ in SingleDungeonManager.Instance._singleDungeonWalkMapModel.getPlayers())
         {
            if(_loc2_.playerInfo.isRobot)
            {
               SingleDungeonManager.Instance._singleDungeonWalkMapModel.removeRobot();
               SingleDungeonManager.Instance._singleDungeonWalkMapModel.addPlayer(this.robotList.pop());
            }
         }
         while(_loc1_-- > 0)
         {
            SingleDungeonManager.Instance._singleDungeonWalkMapModel.addPlayer(this.robotList.pop());
         }
      }
      
      private function disposeRobot() : void
      {
         var _loc1_:SingleDungeonPlayerInfo = null;
         if(this.robotList)
         {
            for each(_loc1_ in this.robotList)
            {
               _loc1_.dispose();
               _loc1_ = null;
            }
            this.robotList = null;
         }
      }
      
      private function __onChatBallComplete(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.CHAT_BALL)
         {
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onChatBallComplete);
            this.loadResFile(this.loadResComplete,PathManager.solveWalkSceneMapPath(this._singleDungeonWalkMapModel._mapSceneModel.Path));
         }
      }
      
      private function loadResComplete(param1:LoaderEvent) : void
      {
         StateManager.setState(StateType.SINGLEDUNGEON_WALK_MAP);
      }
      
      public function get maplistIndex() : int
      {
         return SharedManager.Instance.maplistIndex;
      }
      
      public function set maplistIndex(param1:int) : void
      {
         SharedManager.Instance.maplistIndex = param1;
         SharedManager.Instance.save();
      }
   }
}
