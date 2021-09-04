package consortion.managers
{
   import com.pickgliss.ui.LayerManager;
   import consortion.data.MonsterInfo;
   import consortion.event.ConsortionMonsterEvent;
   import consortion.objects.ConsortionMonster;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.SocketManager;
   import ddt.manager.StateManager;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import game.GameManager;
   import road7th.comm.PackageIn;
   import road7th.utils.DateUtils;
   import room.RoomManager;
   import room.model.RoomInfo;
   import worldboss.WorldBossRoomController;
   import worldboss.player.RankingPersonInfo;
   import worldboss.player.WorldBossActiveTimeInfo;
   
   public class ConsortionMonsterManager extends EventDispatcher
   {
      
      private static var _instance:ConsortionMonsterManager;
       
      
      public var currentRank:Object;
      
      public var currentSelfInfo:Object;
      
      public var RankArray:Array;
      
      private var _monsterInfo:MonsterInfo;
      
      public var isFighting:Boolean = false;
      
      private var _activeState:Boolean = false;
      
      public var curMonster:ConsortionMonster;
      
      public var currentTimes:int;
      
      public function ConsortionMonsterManager(param1:ThisIsSingleTon)
      {
         super();
         if(param1 == null)
         {
            throw new Error("this is singleton,can\'t be new like this!");
         }
         this.initEvent();
      }
      
      public static function get Instance() : ConsortionMonsterManager
      {
         if(_instance == null)
         {
            _instance = new ConsortionMonsterManager(new ThisIsSingleTon());
         }
         return _instance;
      }
      
      public function setup() : void
      {
      }
      
      private function initEvent() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.FIGHT_MONSTER,this.__onFightReturned);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.MONSTER_RANK_INFO,this.__monsterRankInfo);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SELF_MONSTER_INFO,this.__selfMonsterInfo);
      }
      
      private function __onFightReturned(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readInt();
         if(_loc3_ == 0)
         {
            SocketManager.Instance.out.createUserGuide(RoomInfo.CONSORTION_MONSTER);
         }
      }
      
      private function __monsterRankInfo(param1:CrazyTankSocketEvent) : void
      {
         var _loc6_:RankingPersonInfo = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc2_:Array = new Array();
         var _loc3_:PackageIn = param1.pkg;
         var _loc4_:int = _loc3_.readInt();
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = new RankingPersonInfo();
            _loc7_ = _loc3_.readInt();
            _loc6_.isVip = _loc7_ >= 1;
            _loc6_.name = _loc3_.readUTF();
            _loc6_.damage = _loc3_.readInt();
            _loc2_.push(_loc6_);
            _loc5_++;
         }
         if(this.RankArray)
         {
            _loc8_ = 0;
            while(_loc8_ < this.RankArray.length)
            {
               this.RankArray.shift();
               _loc8_--;
               _loc8_++;
            }
         }
         this.RankArray = _loc2_;
         this.currentRank = _loc2_;
         dispatchEvent(new ConsortionMonsterEvent(ConsortionMonsterEvent.UPDATE_RANKING,_loc2_));
      }
      
      private function __selfMonsterInfo(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readInt();
         var _loc4_:int = _loc2_.readInt();
         this.currentSelfInfo = {
            "Count":_loc3_,
            "Scores":_loc4_
         };
         dispatchEvent(new ConsortionMonsterEvent(ConsortionMonsterEvent.UPDATE_SELF_RANK_INFO,this.currentSelfInfo));
      }
      
      public function set CurrentMonster(param1:MonsterInfo) : void
      {
         this._monsterInfo = param1;
      }
      
      public function set ActiveState(param1:Boolean) : void
      {
         this._activeState = param1;
         ConsortionMonsterManager.Instance.dispatchEvent(new ConsortionMonsterEvent(ConsortionMonsterEvent.MONSTER_ACTIVE_START,param1));
      }
      
      public function get ActiveState() : Boolean
      {
         return this._activeState;
      }
      
      public function removeFightEvent() : void
      {
         RoomManager.Instance.removeEventListener(CrazyTankSocketEvent.GAME_ROOM_CREATE,this.__gameStart);
         RoomManager.Instance.removeEventListener(CrazyTankSocketEvent.GAME_ROOM_SETUP_CHANGE,this.__onSetupChanged);
         GameManager.Instance.removeEventListener(GameManager.START_LOAD,this.__startLoading);
      }
      
      public function setupFightEvent() : void
      {
         RoomManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_ROOM_CREATE,this.__gameStart);
         RoomManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_ROOM_SETUP_CHANGE,this.__onSetupChanged);
      }
      
      private function __gameStart(param1:CrazyTankSocketEvent) : void
      {
         RoomManager.Instance.removeEventListener(CrazyTankSocketEvent.GAME_ROOM_CREATE,this.__gameStart);
         GameInSocketOut.sendGameRoomSetUp(this._monsterInfo.MissionID,RoomInfo.CONSORTION_MONSTER,false,"","",3,1,0,false,this._monsterInfo.MissionID);
         ConsortionMonsterManager.Instance.curMonster = null;
      }
      
      private function __onSetupChanged(param1:CrazyTankSocketEvent) : void
      {
         RoomManager.Instance.removeEventListener(CrazyTankSocketEvent.GAME_ROOM_SETUP_CHANGE,this.__onSetupChanged);
         GameInSocketOut.sendGameStart();
         GameManager.Instance.addEventListener(GameManager.START_LOAD,this.__startLoading);
      }
      
      protected function __startLoading(param1:Event) : void
      {
         GameManager.Instance.removeEventListener(GameManager.START_LOAD,this.__startLoading);
         StateManager.getInGame_Step_6 = true;
         if(GameManager.Instance.Current == null)
         {
            return;
         }
         LayerManager.Instance.clearnGameDynamic();
         GameManager.Instance.gotoRoomLoading();
         StateManager.getInGame_Step_7 = true;
      }
      
      public function getCountDownStr(param1:int) : String
      {
         var _loc2_:int = Math.floor(param1 / 60);
         var _loc3_:int = param1 % 60;
         return _loc2_ + " : " + _loc3_;
      }
      
      public function beginTime() : Date
      {
         var _loc1_:Date = null;
         var _loc2_:WorldBossActiveTimeInfo = null;
         for each(_loc2_ in WorldBossRoomController.Instance._sceneModel.timeList)
         {
            if(_loc2_.worldBossId == 11)
            {
               _loc1_ = DateUtils.dealWithStringDate(_loc2_.worldBossBeginTime);
               break;
            }
         }
         return _loc1_;
      }
   }
}

class ThisIsSingleTon
{
    
   
   function ThisIsSingleTon()
   {
      super();
   }
}
