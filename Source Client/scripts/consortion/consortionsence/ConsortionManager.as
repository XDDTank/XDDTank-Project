package consortion.consortionsence
{
   import SingleDungeon.SingleDungeonManager;
   import SingleDungeon.model.WalkMapObject;
   import com.pickgliss.action.FunctionAction;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.QueueLoader;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.manager.CacheSysManager;
   import com.pickgliss.ui.ComponentFactory;
   import consortion.data.MonsterInfo;
   import consortion.managers.ConsortionMonsterManager;
   import consortion.view.monsterReflash.ConsortionMonsterRankFrame;
   import ddt.constants.CacheConsts;
   import ddt.data.UIModuleTypes;
   import ddt.data.player.PlayerInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.ChatManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.Event;
   import flash.geom.Point;
   import road7th.comm.PackageIn;
   
   public class ConsortionManager
   {
      
      private static var _instance:ConsortionManager;
       
      
      public var _consortionWalkMode:ConsortionWalkMapModel;
      
      private var _monsterAllCount:int = 0;
      
      public var SelfPoint:Point;
      
      private var _loadedCallBack:Function;
      
      private var _loadingModuleType:Vector.<String>;
      
      private var completeedUIModule:Vector.<String>;
      
      private var isComplete:Boolean = false;
      
      private var _buyType:int = 10;
      
      public function ConsortionManager()
      {
         this._loadingModuleType = new Vector.<String>();
         this.completeedUIModule = new Vector.<String>();
         super();
      }
      
      public static function get Instance() : ConsortionManager
      {
         if(!ConsortionManager._instance)
         {
            ConsortionManager._instance = new ConsortionManager();
         }
         return ConsortionManager._instance;
      }
      
      public function setup() : void
      {
         this._consortionWalkMode = new ConsortionWalkMapModel();
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ENTER_CONSORTION,this.__init);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTION_ADDMONSTER,this.__onAddMonster);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTION_REMOVEALLMONSTER,this.__removeAllMonster);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTION_MONSTER_STATE,this.__syncMonsterState);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ACTIVE_STATE,this.__MonsterActiveState);
      }
      
      private function __onAddMonster(param1:CrazyTankSocketEvent) : void
      {
         var _loc5_:MonsterInfo = null;
         var _loc6_:int = 0;
         var _loc7_:WalkMapObject = null;
         var _loc2_:QueueLoader = new QueueLoader();
         var _loc3_:PackageIn = param1.pkg;
         this._monsterAllCount = _loc3_.readInt();
         ConsortionMonsterManager.Instance.currentTimes = _loc3_.readInt();
         var _loc4_:int = 0;
         while(_loc4_ < this._monsterAllCount)
         {
            _loc5_ = new MonsterInfo();
            _loc6_ = _loc3_.readInt();
            _loc5_.ID = _loc3_.readInt();
            _loc7_ = SingleDungeonManager.Instance.getObjectByID(_loc6_);
            _loc5_.MonsterName = _loc7_.Name;
            _loc5_.MissionID = _loc7_.SceneID;
            _loc5_.ActionMovieName = "game.living." + _loc7_.Path;
            _loc5_.State = _loc3_.readInt();
            _loc5_.MonsterPos = new Point(_loc3_.readInt(),_loc3_.readInt());
            if(_loc5_.State != MonsterInfo.DEAD)
            {
               _loc2_.addLoader(LoadResourceManager.instance.createLoader(PathManager.solveConsortionMonsterPath(_loc7_.Path),BaseLoader.MODULE_LOADER));
               this._consortionWalkMode._mapObjects.add(_loc5_.ID,_loc5_);
            }
            _loc4_++;
         }
         _loc2_.addEventListener(Event.COMPLETE,this.__onLoadComplete);
         _loc2_.start();
      }
      
      private function __onLoadComplete(param1:Event) : void
      {
         var _loc2_:QueueLoader = param1.currentTarget as QueueLoader;
         if(_loc2_.completeCount == this._monsterAllCount)
         {
            _loc2_.removeEvent();
         }
      }
      
      private function __syncMonsterState(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readInt();
         var _loc4_:int = _loc2_.readInt();
         var _loc5_:int = _loc2_.readInt();
         if(this._consortionWalkMode._mapObjects && this._consortionWalkMode._mapObjects.hasKey(_loc4_))
         {
            this._consortionWalkMode._mapObjects[_loc4_].State = _loc5_;
         }
      }
      
      private function __removeAllMonster(param1:CrazyTankSocketEvent) : void
      {
         var o:MonsterInfo = null;
         var rankArr:Array = null;
         var rankFrame:ConsortionMonsterRankFrame = null;
         var i:int = 0;
         var pEvent:CrazyTankSocketEvent = param1;
         for each(o in this._consortionWalkMode._mapObjects)
         {
            this._consortionWalkMode._mapObjects.remove(o.ID);
         }
         this._consortionWalkMode._mapObjects.clear();
         rankArr = ConsortionMonsterManager.Instance.RankArray;
         if(rankArr && rankArr.length > 0)
         {
            rankFrame = ComponentFactory.Instance.creat("consortion.ranking.frame");
            i = 0;
            while(i < rankArr.length)
            {
               rankFrame.addPersonRanking(rankArr[i]);
               i++;
            }
            if(!StateManager.isInFight)
            {
               rankFrame.show();
            }
            else
            {
               CacheSysManager.getInstance().cacheFunction(CacheConsts.ALERT_IN_FIGHT,new FunctionAction(function():void
               {
                  rankFrame.show();
               }));
            }
         }
         ConsortionMonsterManager.Instance.ActiveState = false;
         MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("consortion.monster.activeStopped"));
         ChatManager.Instance.sysChatYellow(LanguageMgr.GetTranslation("consortion.monster.activeStopped"));
      }
      
      private function __MonsterActiveState(param1:CrazyTankSocketEvent) : void
      {
         ConsortionMonsterManager.Instance.ActiveState = true;
         ConsortionMonsterManager.Instance.currentRank = null;
         ConsortionMonsterManager.Instance.currentSelfInfo = null;
         MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("consortion.monster.activeStart"));
         ChatManager.Instance.sysChatYellow(LanguageMgr.GetTranslation("consortion.monster.activeStart"));
         if(ConsortionMonsterManager.Instance.ActiveState && StateManager.currentStateType == StateType.CONSORTIA)
         {
            SocketManager.Instance.out.sendAddMonsterRequest();
         }
      }
      
      private function __init(param1:CrazyTankSocketEvent) : void
      {
         var _loc5_:PlayerInfo = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:ConsortionWalkPlayerInfo = null;
         var _loc2_:PackageIn = param1.pkg as PackageIn;
         var _loc3_:int = _loc2_.readInt();
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
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
            _loc5_.commitChanges();
            _loc8_ = new ConsortionWalkPlayerInfo();
            _loc8_.playerInfo = _loc5_;
            _loc8_.playerPos = new Point(_loc6_,_loc7_);
            if(_loc5_.ID != PlayerManager.Instance.Self.ID)
            {
               this._consortionWalkMode.addPlayer(_loc8_);
            }
            else
            {
               this.SelfPoint = new Point(_loc6_,_loc7_);
            }
            _loc4_++;
         }
         UIModuleSmallLoading.Instance.progress = 0;
         UIModuleSmallLoading.Instance.show();
         UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onLoadingClose);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onChatBallComplete);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.CHAT_BALL);
      }
      
      private function __onLoadingClose(param1:Event = null) : void
      {
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onLoadingClose);
      }
      
      private function __onChatBallComplete(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.CHAT_BALL)
         {
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onChatBallComplete);
            this.loadResFile(this.loadResComplete,PathManager.solveConsortionWalkSceneMapPath("map5"));
         }
      }
      
      private function loadResFile(param1:Function, param2:String) : void
      {
         var _loc3_:BaseLoader = null;
         _loc3_ = LoadResourceManager.instance.createLoader(param2,BaseLoader.MODULE_LOADER);
         _loc3_.addEventListener(LoaderEvent.COMPLETE,param1);
         _loc3_.addEventListener(LoaderEvent.PROGRESS,this.__uiProgress);
         LoadResourceManager.instance.startLoad(_loc3_);
      }
      
      private function __uiProgress(param1:LoaderEvent) : void
      {
         UIModuleSmallLoading.Instance.progress = param1.loader.progress * 100;
      }
      
      private function loadResComplete(param1:LoaderEvent) : void
      {
         this.__onLoadingClose();
         StateManager.setState(StateType.CONSORTIA);
      }
      
      public function showClubFrame(param1:Function, param2:String) : void
      {
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(this.isComplete)
         {
            if(param1 != null)
            {
               param1();
            }
         }
         else
         {
            _loc3_ = param2.split(",");
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length)
            {
               this._loadingModuleType.push(_loc3_[_loc4_]);
               _loc4_++;
            }
            this._loadedCallBack = param1;
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__loadComplete);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__loadProgress);
            _loc5_ = 0;
            while(_loc5_ < this._loadingModuleType.length)
            {
               UIModuleLoader.Instance.addUIModuleImp(this._loadingModuleType[_loc5_]);
               _loc5_++;
            }
         }
      }
      
      private function __onClose(param1:Event) : void
      {
         this._loadedCallBack = null;
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__loadComplete);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__loadProgress);
      }
      
      private function __loadComplete(param1:UIModuleEvent) : void
      {
         if(this.completeedUIModule.indexOf(param1.module) == -1)
         {
            this.completeedUIModule.push(param1.module);
         }
         var _loc2_:Boolean = true;
         var _loc3_:int = 0;
         while(_loc3_ < this._loadingModuleType.length)
         {
            if(this.completeedUIModule.indexOf(this._loadingModuleType[_loc3_]) == -1)
            {
               _loc2_ = false;
            }
            _loc3_++;
         }
         this.isComplete = _loc2_;
         if(this.isComplete)
         {
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__loadComplete);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__loadProgress);
            UIModuleSmallLoading.Instance.hide();
            this.showClubFrame(this._loadedCallBack,UIModuleTypes.CONSORTIAII + "," + UIModuleTypes.DDTCONSORTIA);
         }
      }
      
      public function set buyType(param1:int) : void
      {
         this._buyType = param1;
      }
      
      public function get buyType() : int
      {
         return this._buyType;
      }
      
      private function __loadProgress(param1:UIModuleEvent) : void
      {
         if(this._loadingModuleType.indexOf(param1.module) != -1)
         {
            UIModuleSmallLoading.Instance.progress = param1.loader.progress * 100;
         }
      }
      
      public function isSameConsortion(param1:PlayerInfo, param2:PlayerInfo) : Boolean
      {
         if(param1 == null || param2 == null)
         {
            return false;
         }
         if(param1.ConsortiaID == param2.ConsortiaID)
         {
            return true;
         }
         return false;
      }
   }
}
