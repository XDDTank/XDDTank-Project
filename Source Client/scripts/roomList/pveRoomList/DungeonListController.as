package roomList.pveRoomList
{
   import com.pickgliss.manager.CacheSysManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import ddt.constants.CacheConsts;
   import ddt.data.TaskDirectorType;
   import ddt.data.map.DungeonInfo;
   import ddt.data.player.FriendListPlayer;
   import ddt.data.player.PlayerInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.loader.StartupResourceLoader;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MapManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.PlayerTipManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StatisticManager;
   import ddt.manager.TaskDirectorManager;
   import ddt.states.BaseStateView;
   import ddt.states.StateType;
   import ddt.view.MainToolBar;
   import ddt.view.tips.PlayerTip;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import road7th.comm.PackageIn;
   import room.RoomManager;
   import room.model.RoomInfo;
   import roomList.LookupEnumerate;
   import roomList.LookupRoomFrame;
   import roomList.pvpRoomList.RoomListCreateRoomView;
   
   public class DungeonListController extends BaseStateView
   {
      
      private static var _instance:DungeonListController;
       
      
      private var _container:Sprite;
      
      private var _model:DungeonListModel;
      
      private var _findRoom:LookupRoomFrame;
      
      private var _dungeonListFrame:DungeonListViewFrame;
      
      private var _defaluDungeonMapId_3:int;
      
      private var _defaluDungeonMapId_4:int;
      
      public function DungeonListController()
      {
         super();
         this.upMapId();
      }
      
      public static function get Instance() : DungeonListController
      {
         if(_instance == null)
         {
            _instance = new DungeonListController();
         }
         return _instance;
      }
      
      public static function disorder(param1:Array) : Array
      {
         var _loc5_:int = 0;
         var _loc6_:RoomInfo = null;
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            _loc5_ = Math.random() * 10000 % param1.length;
            _loc6_ = param1[_loc2_];
            param1[_loc2_] = param1[_loc5_];
            param1[_loc5_] = _loc6_;
            _loc2_++;
         }
         var _loc3_:Array = [];
         var _loc4_:int = 0;
         while(_loc4_ < param1.length)
         {
            if(!(param1[_loc4_] as RoomInfo).isPlaying)
            {
               _loc3_.push(param1[_loc4_]);
            }
            else
            {
               _loc3_.unshift(param1[_loc4_]);
            }
            _loc4_++;
         }
         return _loc3_;
      }
      
      public function setup() : void
      {
         this.createDungeonRooms();
      }
      
      private function init() : void
      {
         if(this._model)
         {
            this._model = null;
         }
         this._model = new DungeonListModel();
         if(this._dungeonListFrame)
         {
            this._dungeonListFrame = null;
         }
         this._dungeonListFrame = ComponentFactory.Instance.creatCustomObject("ddtDungeonListViewFrame",[this,this._model]);
         this._dungeonListFrame.show();
      }
      
      override public function showDirect() : void
      {
         TaskDirectorManager.instance.showDirector(TaskDirectorType.DUNGEON_LIST);
      }
      
      private function initEvent() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_ROOMLIST_UPDATE,this.__addRoom);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SCENE_ADD_USER,this.__addWaitingPlayer);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SCENE_REMOVE_USER,this.__removeWaitingPlayer);
         PlayerTipManager.instance.addEventListener(PlayerTip.CHALLENGE,this.__onChanllengeClick);
      }
      
      private function __addRoom(param1:CrazyTankSocketEvent) : void
      {
         var _loc6_:int = 0;
         var _loc7_:RoomInfo = null;
         var _loc2_:Array = [];
         var _loc3_:PackageIn = param1.pkg;
         this._model.roomTotal = _loc3_.readInt();
         var _loc4_:int = _loc3_.readInt();
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = _loc3_.readInt();
            _loc7_ = this._model.getRoomById(_loc6_);
            if(_loc7_ == null)
            {
               _loc7_ = new RoomInfo();
            }
            _loc7_.ID = _loc6_;
            _loc7_.type = _loc3_.readByte();
            _loc7_.timeType = _loc3_.readByte();
            _loc7_.totalPlayer = _loc3_.readByte();
            _loc7_.viewerCnt = _loc3_.readByte();
            _loc7_.maxViewerCnt = _loc3_.readByte();
            _loc7_.placeCount = _loc3_.readByte();
            _loc7_.IsLocked = _loc3_.readBoolean();
            _loc7_.mapId = _loc3_.readInt();
            _loc7_.isPlaying = _loc3_.readBoolean();
            _loc7_.Name = _loc3_.readUTF();
            _loc7_.gameMode = _loc3_.readByte();
            _loc7_.hardLevel = _loc3_.readByte();
            _loc7_.levelLimits = _loc3_.readInt();
            _loc7_.isOpenBoss = _loc3_.readBoolean();
            if(_loc7_.type != RoomInfo.FRESHMAN_ROOM)
            {
               _loc2_.push(_loc7_);
            }
            _loc5_++;
         }
         this.updataRoom(_loc2_);
      }
      
      private function updataRoom(param1:Array) : void
      {
         if(param1.length == 0)
         {
            this._model.updateRoom(param1);
            return;
         }
         if((param1[0] as RoomInfo).type > 2)
         {
            this._model.updateRoom(param1);
         }
      }
      
      private function __addWaitingPlayer(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = null;
         _loc2_ = param1.pkg;
         var _loc3_:PlayerInfo = PlayerManager.Instance.findPlayer(_loc2_.clientId);
         _loc3_.beginChanges();
         _loc3_.Grade = _loc2_.readInt();
         _loc3_.Sex = _loc2_.readBoolean();
         _loc3_.NickName = _loc2_.readUTF();
         _loc3_.VIPtype = _loc2_.readByte();
         _loc3_.VIPLevel = _loc2_.readInt();
         _loc3_.ConsortiaName = _loc2_.readUTF();
         _loc3_.Offer = _loc2_.readInt();
         _loc3_.WinCount = _loc2_.readInt();
         _loc3_.TotalCount = _loc2_.readInt();
         _loc3_.EscapeCount = _loc2_.readInt();
         _loc3_.ConsortiaID = _loc2_.readInt();
         _loc3_.Repute = _loc2_.readInt();
         _loc3_.IsMarried = _loc2_.readBoolean();
         if(_loc3_.IsMarried)
         {
            _loc3_.SpouseID = _loc2_.readInt();
            _loc3_.SpouseName = _loc2_.readUTF();
         }
         _loc3_.LoginName = _loc2_.readUTF();
         _loc3_.FightPower = _loc2_.readInt();
         _loc3_.apprenticeshipState = _loc2_.readInt();
         _loc3_.isOld = _loc2_.readBoolean();
         _loc3_.commitChanges();
         this._model.addWaitingPlayer(_loc3_);
      }
      
      private function __removeWaitingPlayer(param1:CrazyTankSocketEvent) : void
      {
         this._model.removeWaitingPlayer(param1.pkg.clientId);
      }
      
      public function setRoomShowMode(param1:int) : void
      {
         this._model.roomShowMode = param1;
      }
      
      private function createDungeonRooms() : void
      {
         ++StatisticManager.loginRoomListNum;
         SocketManager.Instance.out.sendCurrentState(1);
         this.init();
         this.initEvent();
         SocketManager.Instance.out.sendSceneLogin(LookupEnumerate.DUNGEON_LIST);
         MainToolBar.Instance.show();
         CacheSysManager.unlock(CacheConsts.ALERT_IN_FIGHT);
         CacheSysManager.getInstance().release(CacheConsts.ALERT_IN_FIGHT,1200);
         PlayerManager.Instance.Self.isUpGradeInGame = false;
      }
      
      override public function enter(param1:BaseStateView, param2:Object = null) : void
      {
         if(!StartupResourceLoader.firstEnterHall)
         {
            SoundManager.instance.playMusic("062");
         }
         super.enter(param1,param2);
         ++StatisticManager.loginRoomListNum;
         SocketManager.Instance.out.sendCurrentState(1);
         this.init();
         this.initEvent();
         SocketManager.Instance.out.sendSceneLogin(LookupEnumerate.DUNGEON_LIST);
         MainToolBar.Instance.show();
         CacheSysManager.unlock(CacheConsts.ALERT_IN_FIGHT);
         CacheSysManager.getInstance().release(CacheConsts.ALERT_IN_FIGHT,1200);
         PlayerManager.Instance.Self.isUpGradeInGame = false;
      }
      
      override public function leaving(param1:BaseStateView) : void
      {
         this.dispose();
         GameInSocketOut.sendExitScene();
         MainToolBar.Instance.hide();
         super.leaving(param1);
      }
      
      override public function getView() : DisplayObject
      {
         return this._container;
      }
      
      override public function getType() : String
      {
         return StateType.DUNGEON_LIST;
      }
      
      public function sendGoIntoRoom(param1:RoomInfo) : void
      {
      }
      
      public function showFindRoom() : void
      {
         if(this._findRoom)
         {
            this._findRoom.dispose();
         }
         this._findRoom = null;
         this._findRoom = ComponentFactory.Instance.creat("asset.ddtroomList.LookupRoomFrame");
         LayerManager.Instance.addToLayer(this._findRoom,LayerManager.GAME_DYNAMIC_LAYER);
      }
      
      protected function __onChanllengeClick(param1:Event) : void
      {
         if(PlayerTipManager.instance.info.Grade < 13)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.roomlist.cantBeChallenged"));
            return;
         }
         if(PlayerManager.Instance.checkExpedition())
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("singledungeon.expedition.doing"));
            return;
         }
         if(PlayerTipManager.instance.info.playerState.StateID == 0 && param1.target.info is FriendListPlayer)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.roomlist.friendOffline"));
            return;
         }
         var _loc2_:int = int(Math.random() * RoomListCreateRoomView.PREWORD.length);
         GameInSocketOut.sendCreateRoom(RoomListCreateRoomView.PREWORD[_loc2_],1,2,"");
         RoomManager.Instance.tempInventPlayerID = PlayerTipManager.instance.info.ID;
         PlayerTipManager.instance.removeEventListener(PlayerTip.CHALLENGE,this.__onChanllengeClick);
      }
      
      private function upMapId() : void
      {
         var _loc1_:DungeonInfo = MapManager.getListByType(3)[0] as DungeonInfo;
         if(_loc1_)
         {
            this._defaluDungeonMapId_3 = _loc1_.ID;
         }
         var _loc2_:DungeonInfo = MapManager.getListByType(4)[0] as DungeonInfo;
         if(_loc2_)
         {
            this._defaluDungeonMapId_4 = _loc2_.ID;
         }
      }
      
      public function removeEvent() : void
      {
         PlayerTipManager.instance.removeEventListener(PlayerTip.CHALLENGE,this.__onChanllengeClick);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.GAME_ROOMLIST_UPDATE,this.__addRoom);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.SCENE_ADD_USER,this.__addWaitingPlayer);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.SCENE_REMOVE_USER,this.__removeWaitingPlayer);
      }
      
      override public function dispose() : void
      {
         PlayerTipManager.instance.removeEventListener(PlayerTip.CHALLENGE,this.__onChanllengeClick);
         if(this._findRoom)
         {
            this._findRoom.dispose();
         }
         if(this._model)
         {
            this._model.dispose();
         }
         this._findRoom = null;
         this._model = null;
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.GAME_ROOMLIST_UPDATE,this.__addRoom);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.SCENE_ADD_USER,this.__addWaitingPlayer);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.SCENE_REMOVE_USER,this.__removeWaitingPlayer);
      }
      
      override public function getBackType() : String
      {
         return StateType.MAIN;
      }
   }
}
