package game.actions
{
   import ddt.command.PlayerAction;
   import ddt.data.BallInfo;
   import ddt.data.EquipType;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.BallManager;
   import ddt.manager.SoundManager;
   import ddt.view.character.GameCharacter;
   import flash.events.Event;
   import game.animations.AnimationLevel;
   import game.model.LocalPlayer;
   import game.objects.ActionType;
   import game.objects.BossLocalPlayer;
   import game.objects.BossPlayer;
   import game.objects.GameLiving;
   import game.objects.GameLocalPlayer;
   import game.objects.GamePlayer;
   import game.objects.GameTurnedLiving;
   import game.objects.SimpleBomb;
   import game.objects.SkillBomb;
   import game.view.Bomb;
   import phy.bombs.BaseBomb;
   
   public class ShootBombAction extends BaseAction
   {
       
      
      private var _player:GameTurnedLiving;
      
      private var _showAction:PlayerAction;
      
      private var _hideAction:PlayerAction;
      
      private var _bombs:Array;
      
      private var _isShoot:Boolean;
      
      private var _shootInterval:int;
      
      private var _info:BallInfo;
      
      private var _event:CrazyTankSocketEvent;
      
      private var isBossPlayer:Boolean = false;
      
      private var _prepared:Boolean;
      
      private var _shootAction:String;
      
      private var _completeCount:int;
      
      private var _completeCall:Function;
      
      public function ShootBombAction(param1:GameTurnedLiving, param2:Array, param3:CrazyTankSocketEvent, param4:int, param5:String = "beatA")
      {
         super();
         this._player = param1;
         this.isBossPlayer = this._player as BossPlayer == null ? Boolean(false) : Boolean(true);
         this._bombs = param2;
         this._event = param3;
         this._shootInterval = param4;
         this._event.executed = false;
         this._prepared = false;
         this._shootAction = param5;
      }
      
      public function get BombEx() : Bomb
      {
         return this._bombs[0] as Bomb;
      }
      
      override public function prepare() : void
      {
         var _loc1_:GamePlayer = null;
         if(_isPrepare)
         {
            return;
         }
         _isPrepare = true;
         if(!this.isBossPlayer)
         {
            _loc1_ = this._player as GamePlayer;
            if(this._player == null || _loc1_.body == null || _loc1_.player == null)
            {
               this.finish();
               return;
            }
         }
         if(_loc1_)
         {
            this._info = BallManager.findBall(_loc1_.player.currentBomb);
            this._showAction = this._info.ActionType == 0 ? GameCharacter.THROWS : GameCharacter.SHOT;
            this._hideAction = this._info.ActionType == 0 ? GameCharacter.HIDETHROWS : GameCharacter.HIDEGUN;
            if(_loc1_.isLiving)
            {
               _loc1_.body.doAction(this._showAction);
               if(_loc1_.weaponMovie)
               {
                  _loc1_.weaponMovie.visible = true;
                  _loc1_.setWeaponMoiveActionSyc("shot");
                  _loc1_.body.WingState = GameCharacter.GAME_WING_SHOOT;
               }
            }
         }
         else
         {
            this._info = BallManager.findBall(this._bombs[0].Template.ID);
            this._player.map.requestForFocus(this._player,AnimationLevel.LOW);
            this._player.actionMovie.addEventListener(GameLiving.SHOOT_PREPARED,this.onEventPrepared);
            this._player.actionMovie.doAction(this._shootAction,this.onCallbackPrepared);
         }
      }
      
      protected function onEventPrepared(param1:Event) : void
      {
         this.canShoot();
      }
      
      protected function onCallbackPrepared() : void
      {
         this.canShoot();
      }
      
      private function canShoot() : void
      {
         this._player.actionMovie.removeEventListener(GameLiving.SHOOT_PREPARED,this.onEventPrepared);
         this._prepared = true;
         this._player.map.cancelFocus(this._player);
      }
      
      override public function execute() : void
      {
         var _loc1_:GamePlayer = null;
         if(_isFinished)
         {
            return;
         }
         if(!this.isBossPlayer)
         {
            _loc1_ = this._player as GamePlayer;
         }
         if(_loc1_)
         {
            if(this._player == null || _loc1_.body == null || _loc1_.body.currentAction == null)
            {
               this.finish();
               return;
            }
            if(_loc1_.body.currentAction != this._showAction)
            {
               if(_loc1_.weaponMovie)
               {
                  _loc1_.weaponMovie.visible = false;
               }
               _loc1_.body.WingState = GameCharacter.GAME_WING_WAIT;
            }
            if(!this._isShoot)
            {
               if(!_loc1_.body.actionPlaying() || _loc1_.body.currentAction != this._showAction)
               {
                  this.executeImp(false);
               }
            }
            else
            {
               --this._shootInterval;
               if(this._shootInterval <= 0)
               {
                  if(_loc1_.body.currentAction == this._showAction)
                  {
                     if(this._player.isLiving)
                     {
                        _loc1_.body.doAction(this._hideAction);
                     }
                     if(_loc1_.weaponMovie)
                     {
                        _loc1_.setWeaponMoiveActionSyc("end");
                     }
                     _loc1_.body.WingState = GameCharacter.GAME_WING_WAIT;
                  }
                  this.finish();
               }
            }
         }
         else
         {
            if(!this._prepared)
            {
               return;
            }
            if(!this._isShoot)
            {
               this.executeImp(false);
            }
            else
            {
               --this._shootInterval;
               if(this._shootInterval <= 0)
               {
                  this.finish();
               }
            }
         }
      }
      
      private function setSelfShootFinish() : void
      {
         if(!this._player.isExist)
         {
            return;
         }
         if(!this._player.info.isSelf)
         {
            return;
         }
         if(this._player is BossLocalPlayer)
         {
            return;
         }
         if(GameLocalPlayer(this._player).shootOverCount >= LocalPlayer(this._player.info).shootCount)
         {
            GameLocalPlayer(this._player).shootOverCount = LocalPlayer(this._player.info).shootCount;
         }
         else
         {
            ++GameLocalPlayer(this._player).shootOverCount;
         }
         if(GameLocalPlayer(this._player).body.currentAction == this._showAction)
         {
            if(this._player.isLiving)
            {
               GameLocalPlayer(this._player).body.doAction(this._hideAction);
            }
         }
      }
      
      private function finish() : void
      {
         _isFinished = true;
         this._event.executed = true;
         this.setSelfShootFinish();
      }
      
      private function executeImp(param1:Boolean) : void
      {
         var _loc2_:GamePlayer = null;
         var _loc3_:int = 0;
         var _loc4_:Bomb = null;
         var _loc5_:int = 0;
         var _loc6_:BaseBomb = null;
         if(!this.isBossPlayer)
         {
            _loc2_ = this._player as GamePlayer;
         }
         if(!this._isShoot)
         {
            this._isShoot = true;
            SoundManager.instance.play(this._info.ShootSound);
            _loc3_ = 0;
            while(_loc3_ < this._bombs.length)
            {
               _loc5_ = 0;
               while(_loc5_ < this._bombs[_loc3_].Actions.length)
               {
                  if(this._bombs[_loc3_].Actions[_loc5_].type == ActionType.KILL_PLAYER)
                  {
                     this._bombs.unshift(this._bombs.splice(_loc3_,1)[0]);
                     break;
                  }
                  _loc5_++;
               }
               _loc3_++;
            }
            for each(_loc4_ in this._bombs)
            {
               if(_loc4_.Template.ID == EquipType.LaserBomdID)
               {
                  _loc6_ = new SkillBomb(_loc4_,this._player.info);
               }
               else if(_loc2_)
               {
                  _loc6_ = new SimpleBomb(_loc4_,this._player.info,_loc2_.player.currentWeapInfo.refineryLevel);
               }
               else
               {
                  _loc6_ = new SimpleBomb(_loc4_,this._player.info);
               }
               this._player.map.addPhysical(_loc6_);
               if(param1)
               {
                  _loc6_.bombAtOnce();
               }
               _loc6_.addEventListener(Event.COMPLETE,this.__complete);
            }
         }
      }
      
      protected function __complete(param1:Event) : void
      {
         param1.target.removeEventListener(Event.COMPLETE,this.__complete);
         ++this._completeCount;
         if(this._completeCount == this._bombs.length)
         {
            if(this._completeCall != null)
            {
               this._completeCall();
            }
            this._completeCall = null;
         }
      }
      
      override public function executeAtOnce() : void
      {
         super.executeAtOnce();
         this.executeImp(true);
      }
      
      public function get completeCall() : Function
      {
         return this._completeCall;
      }
      
      public function set completeCall(param1:Function) : void
      {
         this._completeCall = param1;
      }
   }
}
