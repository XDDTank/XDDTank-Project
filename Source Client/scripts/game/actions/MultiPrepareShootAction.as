package game.actions
{
   import ddt.command.PlayerAction;
   import ddt.data.BallInfo;
   import ddt.manager.BallManager;
   import ddt.view.character.GameCharacter;
   import game.objects.GamePlayer;
   import pet.date.PetSkillInfo;
   
   public class MultiPrepareShootAction extends BaseAction
   {
      
      public static var hasDoSkillAnimation:Boolean;
       
      
      protected var _playerList:Vector.<GamePlayer>;
      
      protected var _actionType:PlayerAction;
      
      protected var _hasDonePrepareAction:Boolean;
      
      protected var _skill:PetSkillInfo;
      
      protected var _petMovieOver:Boolean = true;
      
      private var _petSkillCount:int;
      
      public function MultiPrepareShootAction(param1:Vector.<GamePlayer>)
      {
         super();
         this._playerList = param1;
      }
      
      override public function connect(param1:BaseAction) : Boolean
      {
         return param1 is MultiPrepareShootAction;
      }
      
      override public function prepare() : void
      {
         var _loc2_:PetSkillInfo = null;
         if(this._playerList.length == 0)
         {
            _isFinished = true;
            return;
         }
         ++this._petSkillCount;
         var _loc1_:int = this._playerList.length - 1;
         while(_loc1_ >= 0)
         {
            if(this._playerList[_loc1_] && this._playerList[_loc1_].player && this._playerList[_loc1_].isLiving)
            {
               if(this._playerList[_loc1_].UsedPetSkill.length > 0 && this._playerList[_loc1_].UsedPetSkill.list[0].BallType == 1)
               {
                  _loc2_ = this._playerList[_loc1_].UsedPetSkill.list[0];
                  this._skill = _loc2_;
                  this._petMovieOver = false;
                  ++this._petSkillCount;
                  this._playerList[_loc1_].usePetSkill(_loc2_,this.finishPetMovie);
               }
               else
               {
                  this.doPrepareToShootAction();
               }
            }
            _loc1_--;
         }
         --this._petSkillCount;
      }
      
      private function finishPetMovie() : void
      {
         var _loc1_:int = 0;
         --this._petSkillCount;
         if(this._petSkillCount == 0)
         {
            this.doPrepareToShootAction();
            this._petMovieOver = true;
            _loc1_ = this._playerList.length - 1;
            while(_loc1_ >= 0)
            {
               this._playerList[_loc1_].hidePetMovie();
               _loc1_--;
            }
         }
      }
      
      protected function doPrepareToShootAction() : void
      {
         var _loc1_:int = 0;
         var _loc2_:BallInfo = null;
         this._hasDonePrepareAction = true;
         _loc1_ = this._playerList.length - 1;
         while(_loc1_ >= 0)
         {
            if(this._playerList[_loc1_])
            {
               _loc2_ = BallManager.findBall(this._playerList[_loc1_].player.currentBomb);
               this._actionType = _loc2_.ActionType == 0 ? GameCharacter.SHOWTHROWS : GameCharacter.SHOWGUN;
               this._playerList[_loc1_].weaponMovie = BallManager.createShootMovieMovie(this._playerList[_loc1_].player.currentBomb);
               this._playerList[_loc1_].body.doAction(this._actionType);
               if(this._playerList[_loc1_].weaponMovie)
               {
                  this._playerList[_loc1_].weaponMovie.visible = true;
                  this._playerList[_loc1_].setWeaponMoiveActionSyc("start");
                  this._playerList[_loc1_].body.WingState = GameCharacter.GAME_WING_SHOOT;
               }
            }
            _loc1_--;
         }
      }
      
      override public function execute() : void
      {
         var _loc3_:Boolean = false;
         if(!this._petMovieOver)
         {
            return;
         }
         if(this._playerList.length == 0)
         {
            _isFinished = true;
            return;
         }
         var _loc1_:Boolean = true;
         var _loc2_:int = this._playerList.length - 1;
         while(_loc2_ >= 0)
         {
            _loc3_ = false;
            if(this._playerList[_loc2_])
            {
               if(this._playerList[_loc2_].body.currentAction != this._actionType)
               {
                  if(this._playerList[_loc2_].weaponMovie)
                  {
                     this._playerList[_loc2_].weaponMovie.visible = false;
                  }
                  this._playerList[_loc2_].body.WingState = GameCharacter.GAME_WING_WAIT;
               }
               if(this._hasDonePrepareAction && (!this._playerList[_loc2_].map.isPlayingMovie && (!this._playerList[_loc2_].body.actionPlaying() || this._playerList[_loc2_].body.currentAction != this._actionType)))
               {
                  _loc3_ = true;
               }
            }
            _loc1_ = _loc1_ && _loc3_;
            _loc2_--;
         }
         _isFinished = _loc1_;
      }
   }
}
