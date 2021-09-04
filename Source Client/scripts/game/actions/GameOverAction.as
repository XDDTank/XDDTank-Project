package game.actions
{
   import SingleDungeon.SingleDungeonManager;
   import com.pickgliss.utils.ClassUtils;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import flash.display.MovieClip;
   import game.GameManager;
   import game.model.GameInfo;
   import game.model.Living;
   import game.model.Player;
   import game.view.experience.ExpView;
   import game.view.map.MapView;
   import road7th.comm.PackageIn;
   import road7th.utils.MovieClipWrapper;
   import room.RoomManager;
   
   public class GameOverAction extends BaseAction
   {
       
      
      private var _event:CrazyTankSocketEvent;
      
      private var _executed:Boolean;
      
      private var _count:int;
      
      private var _map:MapView;
      
      private var _current:GameInfo;
      
      private var _func:Function;
      
      public function GameOverAction(param1:MapView, param2:CrazyTankSocketEvent, param3:Function, param4:Number = 3000)
      {
         super();
         this._func = param3;
         this._event = param2;
         this._map = param1;
         this._count = param4 / 40;
         this._current = GameManager.Instance.Current;
         this.readInfo(param2);
         if(RoomManager.Instance.current.selfRoomPlayer.isViewer)
         {
            this._executed = true;
         }
      }
      
      private function readInfo(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Living = null;
         var _loc6_:int = 0;
         var _loc7_:Boolean = false;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc16_:Object = null;
         var _loc17_:Player = null;
         if(this._current)
         {
            _loc2_ = param1.pkg;
            _loc3_ = _loc2_.readInt();
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               _loc6_ = _loc2_.readInt();
               _loc7_ = _loc2_.readBoolean();
               _loc8_ = _loc2_.readInt();
               _loc9_ = _loc2_.readInt();
               _loc10_ = _loc2_.readInt();
               _loc11_ = _loc2_.readInt();
               _loc12_ = _loc2_.readInt();
               _loc13_ = _loc2_.readInt();
               _loc14_ = _loc2_.readInt();
               _loc15_ = _loc2_.readInt();
               _loc16_ = {};
               _loc16_.killGP = _loc2_.readInt();
               _loc16_.hertGP = _loc2_.readInt();
               _loc16_.baseExp = _loc2_.readInt();
               _loc16_.ghostGP = _loc2_.readInt();
               _loc16_.gpForVIP = _loc2_.readInt();
               _loc16_.gpForConsortia = _loc2_.readInt();
               _loc16_.gpForSpouse = _loc2_.readInt();
               _loc16_.gpForServer = _loc2_.readInt();
               _loc16_.gpForApprenticeOnline = _loc2_.readInt();
               _loc16_.gpForApprenticeTeam = _loc2_.readInt();
               _loc16_.gpForDoubleCard = _loc2_.readInt();
               _loc16_.gpForPower = _loc2_.readInt();
               _loc16_.consortiaSkill = _loc2_.readInt();
               _loc16_.luckyExp = _loc2_.readInt();
               _loc16_.gainGP = _loc2_.readInt();
               _loc16_.offerFight = _loc2_.readInt();
               _loc16_.offerDoubleCard = _loc2_.readInt();
               _loc16_.offerVIP = _loc2_.readInt();
               _loc16_.offerService = _loc2_.readInt();
               _loc16_.offerBuff = _loc2_.readInt();
               _loc16_.offerConsortia = _loc2_.readInt();
               _loc16_.luckyOffer = _loc2_.readInt();
               _loc16_.gainOffer = _loc2_.readInt();
               _loc16_.canTakeOut = _loc2_.readInt();
               _loc16_.militaryScore = _loc2_.readInt();
               _loc16_.exploit = _loc2_.readInt();
               _loc16_.gameOverType = ExpView.GAME_OVER_TYPE_1;
               _loc17_ = this._current.findPlayer(_loc6_);
               if(_loc17_)
               {
                  _loc17_.isWin = _loc7_;
                  _loc17_.CurrentGP = _loc9_;
                  _loc17_.CurrentLevel = _loc8_;
                  _loc17_.expObj = _loc16_;
                  _loc17_.GainGP = _loc16_.gainGP;
                  _loc17_.GainOffer = _loc16_.gainOffer;
                  _loc17_.GetCardCount = _loc16_.canTakeOut;
                  _loc17_.playerInfo.MilitaryRankScores = _loc2_.readInt();
                  _loc17_.playerInfo.FightCount = _loc2_.readInt();
                  _loc17_.playerInfo.FightPower = _loc10_;
                  _loc17_.playerInfo.Damage = _loc11_;
                  _loc17_.playerInfo.Guard = _loc12_;
                  _loc17_.playerInfo.Agility = _loc13_;
                  _loc17_.playerInfo.Luck = _loc14_;
                  _loc17_.playerInfo.hp = _loc15_;
                  _loc17_.fightRobotRewardGold = _loc2_.readInt();
                  _loc17_.fightRobotRewardMagicSoul = _loc2_.readInt();
               }
               _loc4_++;
            }
            this._current.GainRiches = _loc2_.readInt();
            for each(_loc5_ in this._current.livings)
            {
               if(_loc5_.character)
               {
                  _loc5_.character.resetShowBitmapBig();
               }
            }
         }
      }
      
      override public function cancel() : void
      {
         this._event.executed = true;
         this._current = null;
         this._map = null;
         this._event = null;
         this._func = null;
      }
      
      override public function execute() : void
      {
         var _loc1_:MovieClipWrapper = null;
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
               if(this._map.currentPlayer && this._map.currentPlayer.isExist)
               {
                  this._map.currentPlayer.beginNewTurn();
               }
               if(GameManager.Instance.Current.selfGamePlayer.isWin)
               {
                  _loc1_ = new MovieClipWrapper(MovieClip(ClassUtils.CreatInstance("asset.game.winAsset")),true,true);
               }
               else if(StateManager.currentStateType == StateType.SINGLEDUNGEON && (SingleDungeonManager.Instance.currentFightType == 3 || SingleDungeonManager.Instance.currentFightType == 4))
               {
                  _loc1_ = new MovieClipWrapper(MovieClip(ClassUtils.CreatInstance("asset.game.endAsset")),true,true);
               }
               else
               {
                  _loc1_ = new MovieClipWrapper(MovieClip(ClassUtils.CreatInstance("asset.game.lostAsset")),true,true);
               }
               SoundManager.instance.play("040");
               _loc1_.movie.x = 500;
               _loc1_.movie.y = 360;
               this._map.gameView.addChild(_loc1_.movie);
            }
         }
         else
         {
            --this._count;
            if(this._count <= 0)
            {
               this._func();
               _isFinished = true;
               this.cancel();
            }
         }
      }
   }
}
