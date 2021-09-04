package arena
{
   import arena.model.ArenaEvent;
   import arena.model.ArenaPackageTypes;
   import arena.model.ArenaPlayerStates;
   import arena.model.ArenaScenePlayerInfo;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import ddt.data.UIModuleTypes;
   import ddt.data.player.PlayerInfo;
   import ddt.events.TimeEvents;
   import ddt.manager.ChatManager;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SocketManager;
   import ddt.manager.StateManager;
   import ddt.manager.TimeManager;
   import ddt.states.StateType;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Timer;
   import liveness.LivenessBubbleManager;
   import road7th.comm.PackageIn;
   import road7th.utils.DateUtils;
   import room.model.RoomInfo;
   import worldboss.WorldBossManager;
   
   public class ArenaManager
   {
      
      private static var _instance:ArenaManager;
      
      public static const LAST_TIME:int = 600;
       
      
      private var _model:ArenaModel;
      
      private var _loadComplete:Boolean;
      
      private var _lastTime:int;
      
      private var _timer:Timer;
      
      private var _hasSendAsk:Boolean = false;
      
      private var _open:Boolean = false;
      
      private var _enterType:int;
      
      private var _hasIn:Boolean = false;
      
      private var _sendAsk:Boolean = false;
      
      public function ArenaManager()
      {
         super();
         this._model = new ArenaModel();
         this.model.addEventListener(ArenaEvent.ENTER_SCENE,this.__enterScene);
         this.model.addEventListener(ArenaEvent.LEAVE_SCENE,this.__leaveScene);
      }
      
      public static function get instance() : ArenaManager
      {
         if(!_instance)
         {
            _instance = new ArenaManager();
         }
         return _instance;
      }
      
      public function get open() : Boolean
      {
         return this._open;
      }
      
      public function get model() : ArenaModel
      {
         return this._model;
      }
      
      public function sendEnterScene() : void
      {
         GameInSocketOut.sendCreateRoom("",RoomInfo.ARENA,3);
      }
      
      private function __timerComplete(param1:TimerEvent) : void
      {
         this._timer.stop();
         this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.__timerComplete);
         this._timer = null;
      }
      
      public function sendEnterAfterFight() : void
      {
         SocketManager.Instance.out.sendArenaEnterScene(this.model.selfInfo.sceneLevel,this.model.selfInfo.sceneID);
      }
      
      public function sendUpdate() : void
      {
         SocketManager.Instance.out.sendArenaUpdate(this.model.selfInfo.sceneLevel,this.model.selfInfo.sceneID);
      }
      
      public function sendAskForActivityType() : void
      {
         this._sendAsk = true;
         SocketManager.Instance.out.sendAskForActivityType();
      }
      
      public function sendMove(param1:int, param2:int, param3:String) : void
      {
         SocketManager.Instance.out.sendArenaPlayerMove(this.model.selfInfo.sceneLevel,this.model.selfInfo.sceneID,param1,param2,param3);
      }
      
      public function sendExit() : void
      {
         if(this.model.selfInfo)
         {
            SocketManager.Instance.out.sendArenaExitScene(this.model.selfInfo.sceneLevel,this.model.selfInfo.sceneID);
         }
      }
      
      public function sendFight(param1:int) : void
      {
         SocketManager.Instance.out.sendArenaPlayerFight(param1,this.model.selfInfo.sceneLevel,this.model.selfInfo.sceneID);
      }
      
      public function sendRelive(param1:int) : void
      {
         SocketManager.Instance.out.sendArenaRelive(this.model.selfInfo.sceneLevel,this.model.selfInfo.sceneID,param1);
      }
      
      public function dealPackage(param1:PackageIn) : void
      {
         var _loc2_:int = param1.readByte();
         switch(_loc2_)
         {
            case ArenaPackageTypes.ENTER_SCENE:
               this.dealEnter(param1);
               break;
            case ArenaPackageTypes.EXIT_SCENE:
               this.dealExit(param1);
               break;
            case ArenaPackageTypes.FIGHT_SCENE:
               this.dealFight(param1);
               break;
            case ArenaPackageTypes.MOVE_SCENE:
               this.dealMove(param1);
               break;
            case ArenaPackageTypes.RELIVE_SCENE:
               this.dealRelive(param1);
               break;
            case ArenaPackageTypes.UPDATE_SCENE:
               this.dealUpate(param1);
               break;
            case ArenaPackageTypes.ACTIVITY_TYPE:
               this.dealActivityType(param1);
         }
      }
      
      private function checkState() : Boolean
      {
         return this._hasIn;
      }
      
      private function dealEnter(param1:PackageIn) : void
      {
         var _loc3_:PlayerInfo = null;
         var _loc4_:ArenaScenePlayerInfo = null;
         if(!this.checkState())
         {
            return;
         }
         var _loc2_:int = param1.readInt();
         var _loc5_:int = 0;
         while(_loc5_ < _loc2_)
         {
            _loc3_ = new PlayerInfo();
            _loc4_ = new ArenaScenePlayerInfo();
            _loc3_.ID = param1.readInt();
            _loc3_.NickName = param1.readUTF();
            _loc3_.Grade = param1.readInt();
            _loc3_.hp = param1.readInt();
            _loc3_.VIPtype = param1.readInt();
            _loc3_.VIPLevel = param1.readInt();
            _loc3_.Sex = param1.readBoolean();
            _loc3_.Style = param1.readUTF();
            _loc3_.Colors = param1.readUTF();
            _loc3_.Skin = param1.readUTF();
            _loc3_.Hide = param1.readInt();
            _loc4_.playerInfo = _loc3_;
            _loc4_.bufferType = param1.readInt();
            _loc4_.sceneLevel = param1.readInt();
            _loc4_.sceneID = param1.readInt();
            _loc4_.playerPos = new Point(param1.readInt(),param1.readInt());
            _loc4_.playerType = param1.readInt();
            _loc4_.playerStauts = param1.readInt();
            _loc4_.arenaCount = param1.readInt();
            _loc4_.arenaFlag = param1.readInt();
            _loc4_.arenaCurrentBlood = param1.readInt();
            if(_loc4_.playerStauts == ArenaPlayerStates.DEATH)
            {
               _loc4_.arenaCurrentBlood = 0;
            }
            _loc4_.arenaMaxWin = param1.readInt();
            _loc4_.arenaFightScore = param1.readInt();
            _loc4_.arenaWinScore = param1.readInt();
            _loc4_.enterTime = TimeManager.Instance.Now();
            if(_loc3_.ID == PlayerManager.Instance.Self.ID)
            {
               _loc4_.playerInfo = PlayerManager.Instance.Self;
               this.model.selfInfo = _loc4_;
            }
            this.model.addPlayerInfo(_loc3_.ID,_loc4_);
            _loc5_++;
         }
      }
      
      private function dealUpate(param1:PackageIn) : void
      {
         var _loc2_:int = param1.readInt();
         if(!this.checkState() && _loc2_ != PlayerManager.Instance.Self.ID)
         {
            return;
         }
         var _loc3_:ArenaScenePlayerInfo = this.model.playerDic[_loc2_];
         if(_loc2_ == PlayerManager.Instance.Self.ID && _loc3_ == null)
         {
            _loc3_ = ArenaManager._instance.model.selfInfo;
         }
         _loc3_.playerType = param1.readInt();
         _loc3_.playerStauts = param1.readInt();
         _loc3_.arenaCount = param1.readInt();
         _loc3_.arenaFlag = param1.readInt();
         _loc3_.arenaCurrentBlood = param1.readInt();
         _loc3_.arenaMaxWin = param1.readInt();
         _loc3_.arenaFightScore = param1.readInt();
         _loc3_.arenaWinScore = param1.readInt();
         var _loc4_:Point = new Point(param1.readInt(),param1.readInt());
         _loc3_.playerPos = _loc4_;
         _loc3_.bufferType = param1.readInt();
         if(_loc3_.playerStauts == ArenaPlayerStates.DEATH)
         {
            _loc3_.arenaCurrentBlood = 0;
         }
         if(_loc3_.playerInfo.ID == PlayerManager.Instance.Self.ID)
         {
            _loc3_.playerInfo = PlayerManager.Instance.Self;
            this.model.selfInfo = _loc3_;
         }
         this.model.updatePlayerInfo(_loc2_,_loc3_);
      }
      
      private function dealExit(param1:PackageIn) : void
      {
         if(!this.checkState())
         {
            return;
         }
         var _loc2_:int = param1.readInt();
         if(_loc2_ == PlayerManager.Instance.Self.ID)
         {
            StateManager.setState(StateType.MAIN);
         }
         else
         {
            this.model.removePlayerInfo(_loc2_);
            if(this.model.playerDic.length < 10 && this.model.selfInfo.sceneID != 1)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.arena.reassignedNotice"));
               ChatManager.Instance.sysChatYellow(LanguageMgr.GetTranslation("ddt.arena.reassignedNotice"));
            }
         }
      }
      
      private function dealActivityType(param1:PackageIn) : void
      {
         var _loc3_:String = null;
         var _loc2_:Boolean = param1.readBoolean();
         this._open = _loc2_;
         if(this._open)
         {
            _loc3_ = LanguageMgr.GetTranslation("ddt.arena.open");
         }
         this._model.dispatchEvent(new ArenaEvent(ArenaEvent.ARENA_ACTIVITY,this._open));
         if(!this._sendAsk)
         {
            if(StateManager.currentStateType == StateType.MAIN && _loc3_)
            {
               MessageTipManager.getInstance().show(_loc3_);
            }
         }
         this._sendAsk = false;
      }
      
      private function dealFight(param1:PackageIn) : void
      {
      }
      
      private function dealRelive(param1:PackageIn) : void
      {
      }
      
      private function dealMove(param1:PackageIn) : void
      {
         var _loc9_:Point = null;
         if(!this.checkState())
         {
            return;
         }
         var _loc2_:int = param1.readInt();
         var _loc3_:int = param1.readInt();
         var _loc4_:int = param1.readInt();
         var _loc5_:String = param1.readUTF();
         if(_loc2_ == this.model.selfInfo.playerInfo.ID)
         {
            return;
         }
         var _loc6_:Array = _loc5_.split(",");
         var _loc7_:Array = [];
         var _loc8_:uint = 0;
         while(_loc8_ < _loc6_.length)
         {
            _loc9_ = new Point(_loc6_[_loc8_],_loc6_[_loc8_ + 1]);
            _loc7_.push(_loc9_);
            _loc8_ += 2;
         }
         this.model.playerDic[_loc2_].walkPath = _loc7_;
      }
      
      public function enter(param1:int = 0) : void
      {
         var _loc2_:String = null;
         if(!this._open)
         {
            _loc2_ = LanguageMgr.GetTranslation("ddt.arena.notopen");
         }
         else if(!PlayerManager.Instance.Self.Bag.getItemAt(14))
         {
            _loc2_ = LanguageMgr.GetTranslation("ddt.arena.noWeapon");
         }
         else if(PlayerManager.Instance.Self.OvertimeListByBody.length > 0)
         {
            _loc2_ = LanguageMgr.GetTranslation("ddt.arena.overdue");
         }
         else if(PlayerManager.Instance.Self.Grade < ServerConfigManager.instance.getArenaOpenLevel())
         {
            _loc2_ = LanguageMgr.GetTranslation("ddt.arena.level",ServerConfigManager.instance.getArenaOpenLevel());
         }
         else if(this.model.selfInfo.arenaFlag <= 0)
         {
            _loc2_ = LanguageMgr.GetTranslation("ddt.arena.enter.notice1");
         }
         else if(this.model.selfInfo.arenaCount >= 40)
         {
            _loc2_ = LanguageMgr.GetTranslation("ddt.arena.enter.notice2");
         }
         if(_loc2_ != "" && _loc2_ != null)
         {
            MessageTipManager.getInstance().show(_loc2_);
            ChatManager.Instance.sysChatYellow(_loc2_);
            if(StateManager.currentStateType != StateType.MAIN)
            {
               this.sendExit();
            }
            return;
         }
         this._enterType = param1;
         if(this._loadComplete)
         {
            this.turnState();
         }
         else
         {
            this.loadUI();
         }
         if(!WorldBossManager.Instance.isOpen)
         {
            LivenessBubbleManager.Instance.removeBubble();
         }
      }
      
      public function beginTime() : Date
      {
         var _loc1_:Date = null;
         return DateUtils.dealWithStringDate(ServerConfigManager.instance.getArenaBeginTime());
      }
      
      private function turnState() : void
      {
         StateManager.setState(StateType.ARENA);
         this._lastTime = 0;
      }
      
      private function __seconds(param1:TimeEvents) : void
      {
         ++this._lastTime;
         if(this._lastTime == LAST_TIME - 60)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.arena.ticked.notice"));
            ChatManager.Instance.sysChatYellow(LanguageMgr.GetTranslation("ddt.arena.ticked.notice"));
         }
         else if(this._lastTime >= LAST_TIME)
         {
            StateManager.setState(StateType.MAIN);
         }
      }
      
      private function __enterScene(param1:ArenaEvent) : void
      {
         this._hasIn = true;
         TimeManager.addEventListener(TimeEvents.SECONDS,this.__seconds);
         this._hasSendAsk = false;
         if(this._enterType == 0)
         {
            this.sendEnterScene();
         }
         else
         {
            this.sendEnterAfterFight();
         }
      }
      
      private function __leaveScene(param1:ArenaEvent) : void
      {
         this._hasIn = false;
         TimeManager.removeEventListener(TimeEvents.SECONDS,this.__seconds);
         this.model.clearPlayer();
      }
      
      private function loadUI() : void
      {
         UIModuleSmallLoading.Instance.progress = 0;
         UIModuleSmallLoading.Instance.show();
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__moduleComplete);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onProgress);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_ERROR,this.__moduleIOError);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.DDT_ARENA);
      }
      
      private function loadResFile(param1:String) : void
      {
         var _loc2_:BaseLoader = null;
         _loc2_ = LoadResourceManager.instance.createLoader(param1,BaseLoader.MODULE_LOADER);
         _loc2_.addEventListener(LoaderEvent.COMPLETE,this.__onloadResFileComplete);
         LoadResourceManager.instance.startLoad(_loc2_);
      }
      
      private function __onloadResFileComplete(param1:LoaderEvent) : void
      {
         param1.target.removeEventListener(LoaderEvent.COMPLETE,this.__onloadResFileComplete);
         this.turnState();
      }
      
      private function __onProgress(param1:UIModuleEvent) : void
      {
         UIModuleSmallLoading.Instance.progress = param1.loader.progress * 100;
      }
      
      private function __moduleIOError(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.DDT_ARENA)
         {
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__moduleComplete);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onProgress);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_ERROR,this.__moduleIOError);
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__loadingClose);
            UIModuleSmallLoading.Instance.hide();
         }
      }
      
      private function __moduleComplete(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.DDT_ARENA)
         {
            this.loadResFile(PathManager.solveWalkSceneMapPath("map7"));
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__moduleComplete);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onProgress);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_ERROR,this.__moduleIOError);
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__loadingClose);
            UIModuleSmallLoading.Instance.hide();
         }
      }
      
      private function __loadingClose(param1:Event) : void
      {
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__moduleComplete);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onProgress);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_ERROR,this.__moduleIOError);
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__loadingClose);
         UIModuleSmallLoading.Instance.hide();
      }
   }
}
