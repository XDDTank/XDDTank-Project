package ddt.manager
{
   import arena.ArenaManager;
   import arena.model.ArenaScenePlayerInfo;
   import baglocked.BagLockedController;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import consortion.ConosrtionTimerManager;
   import ddt.DDT;
   import ddt.data.ServerInfo;
   import ddt.data.analyze.ServerListAnalyzer;
   import ddt.data.player.PlayerInfo;
   import ddt.data.player.SelfInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.events.DuowanInterfaceEvent;
   import ddt.loader.StartupResourceLoader;
   import ddt.states.StateType;
   import ddt.view.MainToolBar;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.Timer;
   import flash.utils.setTimeout;
   import platformapi.tencent.DiamondManager;
   import platformapi.tencent.TencentPlatformData;
   import road7th.comm.PackageIn;
   import totem.TotemManager;
   
   [Event(name="change",type="flash.events.Event")]
   public class ServerManager extends EventDispatcher
   {
      
      public static const CHANGE_SERVER:String = "changeServer";
      
      public static var AUTO_UNLOCK:Boolean = false;
      
      public static var GAME_BEGIN:String = "game_begin";
      
      private static const CONNENT_TIME_OUT:int = 30000;
      
      private static var _instance:ServerManager;
       
      
      private var _list:Vector.<ServerInfo>;
      
      private var _current:ServerInfo;
      
      private var _zoneName:String;
      
      private var _agentid:int;
      
      private var _connentTimer:Timer;
      
      public function ServerManager()
      {
         super();
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LOGIN,this.__onLoginComplete);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PFINFO,this.__onpfInfoComplete);
      }
      
      public static function get Instance() : ServerManager
      {
         if(_instance == null)
         {
            _instance = new ServerManager();
         }
         return _instance;
      }
      
      protected function __onpfInfoComplete(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:TencentPlatformData = DiamondManager.instance.model.pfdata;
         var _loc4_:SelfInfo = PlayerManager.Instance.Self;
         _loc3_.openID = _loc2_.readUTF();
         _loc3_.openKey = _loc2_.readUTF();
         _loc3_.pf = _loc2_.readUTF();
         _loc3_.pfKey = _loc2_.readUTF();
         DiamondManager.instance.model.update();
         _loc4_.beginChanges();
         _loc4_.isYellowVip = _loc2_.readBoolean();
         _loc4_.MemberDiamondLevel = _loc2_.readByte();
         _loc4_.Level3366 = _loc2_.readByte();
         _loc4_.canTakeVIPPack = _loc2_.readBoolean();
         _loc4_.canTakeVIPYearPack = _loc2_.readBoolean();
         _loc4_.canTakeLevel3366Pack = _loc2_.readBoolean();
         _loc4_.isYearVip = _loc2_.readBoolean();
         _loc4_.isGetNewHandPack = _loc2_.readBoolean();
         ExternalInterfaceManager.traceToBrowser("openID=" + _loc3_.openID + ",openKey=" + _loc3_.openKey + ",pf=" + _loc3_.pf + ",pfkey=" + _loc3_.pfKey);
         ExternalInterfaceManager.traceToBrowser("isYellowVip=" + _loc4_.isYellowVip + ",MemberDiamondLevel=" + _loc4_.MemberDiamondLevel + ",Level3366=" + _loc4_.Level3366 + ",canTakeVIPPack=" + _loc4_.canTakeVIPPack + ",canTakeVIPYearPack=" + _loc4_.canTakeVIPYearPack + ",canTakeLevel3366Pack=" + _loc4_.canTakeLevel3366Pack + ",isGetNewHandPack=" + _loc4_.isGetNewHandPack);
         _loc4_.commitChanges();
      }
      
      public function get zoneName() : String
      {
         return this._zoneName;
      }
      
      public function set zoneName(param1:String) : void
      {
         this._zoneName = param1;
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function get AgentID() : int
      {
         return this._agentid;
      }
      
      public function set AgentID(param1:int) : void
      {
         this._agentid = param1;
      }
      
      public function set current(param1:ServerInfo) : void
      {
         this._current = param1;
      }
      
      public function get current() : ServerInfo
      {
         return this._current;
      }
      
      public function get list() : Vector.<ServerInfo>
      {
         return this._list;
      }
      
      public function set list(param1:Vector.<ServerInfo>) : void
      {
         this._list = param1;
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function setup(param1:ServerListAnalyzer) : void
      {
         this._list = param1.list;
         this._agentid = param1.agentId;
         this._zoneName = param1.zoneName;
      }
      
      public function canAutoLogin() : Boolean
      {
         this.searchAvailableServer();
         return this._current != null;
      }
      
      public function connentCurrentServer() : void
      {
         SocketManager.Instance.isLogin = false;
         SocketManager.Instance.connect(this._current.IP,this._current.Port);
      }
      
      private function searchAvailableServer() : void
      {
         var _loc1_:PlayerInfo = PlayerManager.Instance.Self;
         if(DDT.SERVER_ID != -1)
         {
            this._current = this._list[DDT.SERVER_ID];
            return;
         }
         this._current = this.searchServerByState(ServerInfo.UNIMPEDED);
         if(this._current == null)
         {
            this._current = this.searchServerByState(ServerInfo.HALF);
         }
         if(this._current == null)
         {
            this._current = this._list[0];
         }
      }
      
      private function searchServerByState(param1:int) : ServerInfo
      {
         var _loc2_:int = 0;
         while(_loc2_ < this._list.length)
         {
            if(this._list[_loc2_].State == param1)
            {
               return this._list[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function connentServer(param1:ServerInfo) : Boolean
      {
         var _loc2_:BaseAlerFrame = null;
         if(param1 == null)
         {
            _loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.serverlist.ServerListPosView.choose"));
            this.alertControl(_loc2_);
            return false;
         }
         if(param1.MustLevel < PlayerManager.Instance.Self.Grade)
         {
            _loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.serverlist.ServerListPosView.your"));
            this.alertControl(_loc2_);
            return false;
         }
         if(param1.LowestLevel > PlayerManager.Instance.Self.Grade)
         {
            _loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.serverlist.ServerListPosView.low"));
            this.alertControl(_loc2_);
            return false;
         }
         if(SocketManager.Instance.socket.connected && SocketManager.Instance.socket.isSame(param1.IP,param1.Port) && SocketManager.Instance.isLogin)
         {
            StateManager.setState(StateType.MAIN);
            return false;
         }
         if(param1.State == ServerInfo.ALL_FULL)
         {
            _loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.serverlist.ServerListPosView.full"));
            this.alertControl(_loc2_);
            return false;
         }
         if(param1.State == ServerInfo.MAINTAIN)
         {
            _loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.serverlist.ServerListPosView.maintenance"));
            this.alertControl(_loc2_);
            return false;
         }
         this._current = param1;
         this.connentCurrentServer();
         dispatchEvent(new Event(CHANGE_SERVER));
         return true;
      }
      
      private function alertControl(param1:BaseAlerFrame) : void
      {
         param1.addEventListener(FrameEvent.RESPONSE,this.__alertResponse);
      }
      
      private function __alertResponse(param1:FrameEvent) : void
      {
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__alertResponse);
         _loc2_.dispose();
      }
      
      private function __onLoginComplete(param1:CrazyTankSocketEvent) : void
      {
         var _loc4_:String = null;
         var _loc5_:Array = null;
         var _loc6_:Boolean = false;
         var _loc7_:Boolean = false;
         var _loc8_:String = null;
         var _loc9_:Array = null;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:ArenaScenePlayerInfo = null;
         var _loc13_:BaseAlerFrame = null;
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:SelfInfo = PlayerManager.Instance.Self;
         if(_loc2_.readByte() == 0)
         {
            _loc3_.beginChanges();
            SocketManager.Instance.isLogin = true;
            _loc3_.ZoneID = _loc2_.readInt();
            _loc3_.Attack = _loc2_.readInt();
            _loc3_.Defence = _loc2_.readInt();
            _loc3_.Agility = _loc2_.readInt();
            _loc3_.Luck = _loc2_.readInt();
            _loc3_.Stormdamage = _loc2_.readInt();
            _loc3_.Crit = _loc2_.readInt();
            _loc3_.Uprisinginjury = _loc2_.readInt();
            _loc3_.Uprisingstrike = _loc2_.readInt();
            _loc3_.GP = _loc2_.readInt();
            _loc3_.Repute = _loc2_.readInt();
            _loc3_.Gold = _loc2_.readInt();
            _loc3_.Money = _loc2_.readInt();
            _loc3_.DDTMoney = _loc2_.readInt();
            _loc3_.Hide = _loc2_.readInt();
            _loc3_.FightPower = _loc2_.readInt();
            _loc3_.apprenticeshipState = _loc2_.readInt();
            _loc3_.masterID = _loc2_.readInt();
            _loc3_.setMasterOrApprentices(_loc2_.readUTF());
            _loc3_.graduatesCount = _loc2_.readInt();
            _loc3_.honourOfMaster = _loc2_.readUTF();
            _loc3_.freezesDate = _loc2_.readDate();
            _loc3_.VIPtype = _loc2_.readByte();
            _loc3_.VIPLevel = _loc2_.readInt();
            _loc3_.VIPExp = _loc2_.readInt();
            _loc3_.VIPExpireDay = _loc2_.readDate();
            _loc3_.openVipType = _loc2_.readBoolean();
            _loc3_.LastDate = _loc2_.readDate();
            _loc3_.VIPNextLevelDaysNeeded = _loc2_.readInt();
            _loc3_.systemDate = _loc2_.readDate();
            _loc3_.isFightVip = _loc2_.readBoolean();
            _loc3_.fightToolBoxSkillNum = _loc2_.readInt();
            _loc3_.fightVipStartTime = _loc2_.readDate();
            _loc3_.fightVipValidDate = _loc2_.readInt();
            _loc3_.OptionOnOff = _loc2_.readInt();
            _loc3_.AchievementPoint = _loc2_.readInt();
            _loc3_.honor = _loc2_.readUTF();
            TimeManager.Instance.enthrallTime = _loc2_.readInt();
            _loc3_.Sex = _loc2_.readBoolean();
            _loc4_ = _loc2_.readUTF();
            _loc5_ = _loc4_.split("&");
            _loc3_.Style = _loc5_[0];
            _loc3_.Colors = _loc5_[1];
            _loc3_.Skin = _loc2_.readUTF();
            _loc3_.ConsortiaID = _loc2_.readInt();
            _loc3_.ConsortiaName = _loc2_.readUTF();
            _loc3_.badgeID = _loc2_.readInt();
            _loc3_.DutyLevel = _loc2_.readInt();
            _loc3_.DutyName = _loc2_.readUTF();
            _loc3_.Right = _loc2_.readInt();
            _loc3_.consortiaInfo.ChairmanName = _loc2_.readUTF();
            _loc3_.consortiaInfo.Honor = _loc2_.readInt();
            _loc3_.consortiaInfo.Riches = _loc2_.readInt();
            _loc6_ = _loc2_.readBoolean();
            _loc7_ = _loc3_.bagPwdState && !_loc3_.bagLocked;
            _loc3_.bagPwdState = _loc6_;
            if(_loc7_)
            {
               setTimeout(this.releaseLock,1000);
            }
            _loc3_.bagLocked = _loc6_;
            _loc3_.questionOne = _loc2_.readUTF();
            _loc3_.questionTwo = _loc2_.readUTF();
            _loc3_.leftTimes = _loc2_.readInt();
            _loc3_.LoginName = _loc2_.readUTF();
            TaskManager.instance.requestCanAcceptTask();
            _loc3_.PvePermission = _loc2_.readUTF();
            _loc3_.fightLibMission = _loc2_.readUTF();
            _loc3_.userGuildProgress = _loc2_.readInt();
            _loc3_.UseOffer = _loc2_.readInt();
            _loc3_.beforeOffer = _loc2_.readInt();
            _loc3_.matchInfo.dailyScore = _loc2_.readInt();
            _loc3_.matchInfo.dailyWinCount = _loc2_.readInt();
            _loc3_.matchInfo.dailyGameCount = _loc2_.readInt();
            _loc3_.DailyLeagueFirst = _loc2_.readBoolean();
            _loc3_.DailyLeagueLastScore = _loc2_.readInt();
            _loc3_.matchInfo.weeklyScore = _loc2_.readInt();
            _loc3_.matchInfo.weeklyGameCount = _loc2_.readInt();
            _loc3_.matchInfo.weeklyRanking = _loc2_.readInt();
            _loc3_.bagCellUpdateIndex = _loc2_.readInt();
            _loc3_.bagCellUpdateTime = _loc2_.readDate();
            _loc3_.beadScore = _loc2_.readInt();
            _loc3_.beadGetStatus = _loc2_.readInt();
            _loc3_.fbDoneByString = _loc2_.readUTF();
            _loc3_.totemId = _loc2_.readInt();
            _loc3_.MilitaryRankScores = _loc2_.readInt();
            _loc3_.MilitaryRankTotalScores = _loc2_.readInt();
            _loc3_.FightCount = _loc2_.readInt();
            _loc8_ = _loc2_.readUTF();
            _loc9_ = _loc8_.split(",");
            while(_loc10_ < _loc9_.length)
            {
               _loc3_.isLearnSkill.add(_loc10_,_loc9_[_loc10_]);
               _loc10_++;
            }
            _loc11_ = _loc2_.readInt();
            TimeManager.Instance.totalGameTime = _loc11_;
            EnthrallManager.getInstance().setup();
            ConosrtionTimerManager.Instance.startimer(3600 - _loc11_ * 60);
            _loc12_ = ArenaManager.instance.model.selfInfo;
            _loc12_.arenaCount = _loc2_.readInt();
            _loc12_.arenaFlag = _loc2_.readInt();
            _loc3_.returnEnergy = _loc2_.readInt();
            _loc3_.commitChanges();
            TotemManager.instance.updatePropertyAddtion(_loc3_.totemId,PlayerManager.Instance.Self.propertyAddition);
            MapManager.buildMap();
            PlayerManager.Instance.Self.loadRelatedPlayersInfo();
            MainToolBar.Instance.signEffectEnable = true;
            SavePointManager.Instance.syncDungeonSavePoints();
            SavePointManager.Instance.syncTaskSavePoints();
            SavePointManager.Instance.getSavePoint(0,this.getSavePoints);
            ExternalInterfaceManager.sendTo360Agent(4);
            if(!StartupResourceLoader.firstEnterHall)
            {
               StartupResourceLoader.Instance.startLoadRelatedInfo();
            }
            if(DesktopManager.Instance.isDesktop)
            {
               setTimeout(TaskManager.instance.onDesktopApp,500);
            }
            DuowanInterfaceManage.Instance.dispatchEvent(new DuowanInterfaceEvent(DuowanInterfaceEvent.ONLINE));
         }
         else
         {
            _loc13_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("alert"),LanguageMgr.GetTranslation("ServerLinkError"));
            this.alertControl(_loc13_);
         }
      }
      
      private function getSavePoints(param1:Array) : void
      {
         var _loc3_:uint = 0;
         SavePointManager.Instance.savePoints = param1;
         var _loc2_:uint = 80;
         while(_loc2_ < 84)
         {
            if(!param1[_loc2_])
            {
               SavePointManager.Instance.setSavePoint(_loc2_);
            }
            _loc2_++;
         }
         if(PlayerManager.Instance.Self.Grade >= SavePointManager.SKIP_BASE_SAVEPOINT_LEVEL)
         {
            _loc3_ = 0;
            while(_loc3_ <= SavePointManager.MAX_SAVEPOINT)
            {
               if(!SavePointManager.Instance.checkInSkipSavePoint(_loc3_))
               {
                  SavePointManager.Instance.setSavePoint(_loc3_);
               }
               _loc3_++;
            }
         }
         this.enterHall();
      }
      
      private function enterHall() : void
      {
         dispatchEvent(new Event(ServerManager.GAME_BEGIN));
         StateManager.setState(StateType.MAIN);
      }
      
      private function releaseLock() : void
      {
         AUTO_UNLOCK = true;
         SocketManager.Instance.out.sendBagLocked(BagLockedController.PWD,2);
      }
   }
}
