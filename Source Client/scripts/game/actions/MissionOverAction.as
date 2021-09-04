package game.actions
{
   import SingleDungeon.SingleDungeonManager;
   import com.pickgliss.utils.ClassUtils;
   import ddt.data.map.MissionInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   import game.GameManager;
   import game.model.BaseSettleInfo;
   import game.model.GameInfo;
   import game.model.Player;
   import game.view.DropGoods;
   import game.view.MissionOverInfoPanel;
   import game.view.experience.ExpView;
   import game.view.map.MapView;
   import road7th.comm.PackageIn;
   import road7th.utils.MovieClipWrapper;
   import room.RoomManager;
   import room.model.RoomInfo;
   import worldboss.WorldBossRoomController;
   
   public class MissionOverAction extends BaseAction
   {
       
      
      private var _event:CrazyTankSocketEvent;
      
      private var _executed:Boolean;
      
      private var _count:int;
      
      private var _map:MapView;
      
      private var _func:Function;
      
      private var _intervalId:uint;
      
      private var infoPane:MissionOverInfoPanel;
      
      public function MissionOverAction(param1:MapView, param2:CrazyTankSocketEvent, param3:Function, param4:Number = 3000)
      {
         super();
         this._event = param2;
         this._map = param1;
         this._func = param3;
         this._count = param4 / 40;
         this.readInfo(this._event);
      }
      
      private function readInfo(param1:CrazyTankSocketEvent) : void
      {
         var _loc6_:Object = null;
         var _loc7_:BaseSettleInfo = null;
         var _loc8_:Player = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:uint = 0;
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:GameInfo = GameManager.Instance.Current;
         _loc3_.missionInfo.missionOverPlayer = [];
         _loc3_.missionInfo.tackCardType = _loc2_.readInt();
         _loc3_.hasNextMission = _loc2_.readBoolean();
         if(_loc3_.hasNextMission)
         {
            _loc3_.missionInfo.pic = _loc2_.readUTF();
         }
         _loc3_.missionInfo.canEnterFinall = _loc2_.readBoolean();
         var _loc4_:int = _loc2_.readInt();
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = new Object();
            _loc7_ = new BaseSettleInfo();
            _loc7_.playerid = _loc2_.readInt();
            _loc7_.level = _loc2_.readInt();
            _loc7_.treatment = _loc2_.readInt();
            _loc8_ = _loc3_.findGamerbyPlayerId(_loc7_.playerid);
            _loc6_.baseExp = _loc2_.readInt();
            _loc6_.gpForVIP = _loc2_.readInt();
            _loc6_.gpForApprenticeTeam = _loc2_.readInt();
            _loc6_.gpForApprenticeOnline = _loc2_.readInt();
            _loc6_.gpForSpouse = _loc2_.readInt();
            _loc6_.gpForServer = _loc2_.readInt();
            _loc6_.gpForDoubleCard = _loc2_.readInt();
            _loc6_.consortiaSkill = _loc2_.readInt();
            _loc6_.gainGP = _loc2_.readInt();
            _loc6_.totalKill = _loc2_.readInt();
            _loc8_.isWin = _loc2_.readBoolean();
            _loc9_ = _loc2_.readInt();
            _loc8_.GetCardCount = _loc9_;
            _loc8_.BossCardCount = _loc9_;
            _loc8_.hasLevelAgain = _loc2_.readBoolean();
            _loc8_.hasGardGet = _loc2_.readBoolean();
            if(_loc8_.isWin)
            {
               if(_loc9_ == 0)
               {
                  _loc6_.gameOverType = ExpView.GAME_OVER_TYPE_0;
               }
               else if(_loc9_ == 1 && !_loc3_.hasNextMission)
               {
                  _loc6_.gameOverType = ExpView.GAME_OVER_TYPE_6;
               }
               else if(_loc9_ == 1 && _loc3_.hasNextMission)
               {
                  _loc6_.gameOverType = ExpView.GAME_OVER_TYPE_2;
                  GameManager.Instance.MissionOverType = ExpView.GAME_OVER_TYPE_2;
               }
               else if(_loc9_ == 2 && _loc3_.hasNextMission)
               {
                  _loc6_.gameOverType = ExpView.GAME_OVER_TYPE_3;
               }
               else if(_loc9_ == 2 && !_loc3_.hasNextMission)
               {
                  _loc6_.gameOverType = ExpView.GAME_OVER_TYPE_4;
                  GameManager.Instance.MissionOverType = ExpView.GAME_OVER_TYPE_4;
               }
               else
               {
                  _loc6_.gameOverType = ExpView.GAME_OVER_TYPE_0;
               }
            }
            else
            {
               _loc6_.gameOverType = ExpView.GAME_OVER_TYPE_5;
               if(RoomManager.Instance.current.type == 14)
               {
                  SocketManager.Instance.out.sendWorldBossRoomStauts(3);
                  WorldBossRoomController.Instance.setSelfStatus(3);
               }
            }
            _loc8_.expObj = _loc6_;
            if(_loc8_.playerInfo.ID == _loc3_.selfGamePlayer.playerInfo.ID)
            {
               _loc3_.selfGamePlayer.BossCardCount = _loc8_.BossCardCount;
            }
            _loc3_.missionInfo.missionOverPlayer.push(_loc7_);
            _loc5_++;
         }
         if(_loc3_.selfGamePlayer.BossCardCount > 0)
         {
            _loc10_ = _loc2_.readInt();
            _loc3_.missionInfo.missionOverNPCMovies = [];
            _loc11_ = 0;
            while(_loc11_ < _loc10_)
            {
               _loc3_.missionInfo.missionOverNPCMovies.push(_loc2_.readUTF());
               _loc11_++;
            }
         }
         _loc3_.missionInfo.nextMissionIndex = _loc3_.missionInfo.missionIndex + 1;
      }
      
      override public function cancel() : void
      {
         this._event.executed = true;
      }
      
      override public function execute() : void
      {
         var _loc1_:MovieClipWrapper = null;
         var _loc2_:MovieClip = null;
         if(RoomManager.Instance.current.selfRoomPlayer.isViewer)
         {
            this._executed = true;
         }
         if(!this._executed)
         {
            if(this._map.hasSomethingMoving() == false && (this._map.currentPlayer == null || this._map.currentPlayer.actionCount == 0))
            {
               this._executed = true;
               this._event.executed = true;
               if(this._map.currentPlayer)
               {
                  this._map.currentPlayer.beginNewTurn();
               }
               this.infoPane = new MissionOverInfoPanel();
               this.upContextView(this.infoPane);
               if(GameManager.Instance.Current.selfGamePlayer.isWin)
               {
                  _loc2_ = ClassUtils.CreatInstance("asset.game.winAsset");
               }
               else if(GameManager.Instance.Current.roomType == RoomInfo.SINGLE_DUNGEON && SingleDungeonManager.Instance.currentFightType == 3)
               {
                  _loc2_ = ClassUtils.CreatInstance("asset.game.endAsset");
               }
               else
               {
                  _loc2_ = ClassUtils.CreatInstance("asset.game.lostAsset");
               }
               this.infoPane.x = 77;
               _loc2_.addChild(this.infoPane);
               _loc1_ = new MovieClipWrapper(_loc2_,false,true);
               SoundManager.instance.play("040");
               _loc1_.movie.x = 500;
               _loc1_.movie.y = 360;
               _loc1_.addEventListener(Event.COMPLETE,this.__complete);
               this._intervalId = setInterval(this.showMovie,100,_loc1_);
            }
         }
         else
         {
            --this._count;
            if(this._count <= 0)
            {
               this._func();
               _isFinished = true;
            }
         }
      }
      
      private function showMovie(param1:MovieClipWrapper) : void
      {
         if(DropGoods.isOver)
         {
            if(this._map && this._map.gameView)
            {
               this._map.gameView.addChild(param1.movie);
               param1.play();
            }
            clearInterval(this._intervalId);
         }
      }
      
      private function __complete(param1:Event) : void
      {
         MovieClipWrapper(param1.target).removeEventListener(Event.COMPLETE,this.__complete);
         this.infoPane.dispose();
         this.infoPane = null;
      }
      
      private function upContextView(param1:MissionOverInfoPanel) : void
      {
         var _loc2_:MissionInfo = GameManager.Instance.Current.missionInfo;
         var _loc3_:BaseSettleInfo = GameManager.Instance.Current.missionInfo.findMissionOverInfo(PlayerManager.Instance.Self.ID);
         param1.titleTxt1.text = LanguageMgr.GetTranslation("tank.game.actions.kill");
         param1.valueTxt1.text = String(_loc2_.currentValue2);
         param1.titleTxt2.text = LanguageMgr.GetTranslation("tank.game.actions.turn");
         param1.valueTxt2.text = String(_loc2_.currentValue1);
         param1.titleTxt3.text = LanguageMgr.GetTranslation("tank.game.BloodStrip.HP");
         param1.valueTxt3.text = String(_loc3_.treatment);
      }
   }
}
