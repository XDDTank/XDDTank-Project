package game.actions
{
   import ddt.command.PlayerAction;
   import ddt.data.BallInfo;
   import ddt.manager.BallManager;
   import ddt.manager.SharedManager;
   import ddt.view.character.GameCharacter;
   import game.objects.BossPlayer;
   import game.objects.GamePlayer;
   import game.objects.GameTurnedLiving;
   import pet.date.PetSkillInfo;
   
   public class PrepareShootAction extends BaseAction
   {
      
      public static var hasDoSkillAnimation:Boolean;
       
      
      protected var _gamePlayer:GamePlayer;
      
      protected var _bossPlayer:BossPlayer;
      
      protected var _actionType:PlayerAction;
      
      protected var _hasDonePrepareAction:Boolean;
      
      protected var _skill:PetSkillInfo;
      
      protected var _petMovieOver:Boolean = true;
      
      public function PrepareShootAction(param1:GameTurnedLiving)
      {
         super();
         if(param1 as GamePlayer)
         {
            this._gamePlayer = GamePlayer(param1);
         }
         else if(param1 as BossPlayer)
         {
            this._bossPlayer = BossPlayer(param1);
         }
      }
      
      override public function connect(param1:BaseAction) : Boolean
      {
         return param1 is PrepareShootAction;
      }
      
      override public function prepare() : void
      {
         var _loc1_:PetSkillInfo = null;
         if(this._gamePlayer && this._gamePlayer.player && this._gamePlayer.isLiving)
         {
            if(this._gamePlayer.UsedPetSkill.length > 0 && this._gamePlayer.UsedPetSkill.list[0].BallType == 1)
            {
               _loc1_ = this._gamePlayer.UsedPetSkill.list[0];
               this._skill = _loc1_;
               this._petMovieOver = false;
               this._gamePlayer.usePetSkill(_loc1_,this.finishPetMovie);
            }
            else
            {
               this.doPrepareToShootAction();
            }
         }
         else
         {
            _isFinished = true;
         }
      }
      
      private function finishPetMovie() : void
      {
         this.doPrepareToShootAction();
         this._petMovieOver = true;
         this._gamePlayer.hidePetMovie();
      }
      
      protected function doPrepareToShootAction() : void
      {
         var _loc1_:BallInfo = null;
         if(this._gamePlayer)
         {
            this._hasDonePrepareAction = true;
            _loc1_ = BallManager.findBall(this._gamePlayer.player.currentBomb);
            this._actionType = _loc1_.ActionType == 0 ? GameCharacter.SHOWTHROWS : GameCharacter.SHOWGUN;
            if((this._gamePlayer.player.skill >= 0 || this._gamePlayer.player.isSpecialSkill) && SharedManager.Instance.showParticle && !hasDoSkillAnimation)
            {
               hasDoSkillAnimation = true;
               this._gamePlayer.map.spellKill(this._gamePlayer);
            }
            this._gamePlayer.weaponMovie = BallManager.createShootMovieMovie(this._gamePlayer.player.currentBomb);
            this._gamePlayer.body.doAction(this._actionType);
            if(this._gamePlayer.weaponMovie)
            {
               this._gamePlayer.weaponMovie.visible = true;
               this._gamePlayer.setWeaponMoiveActionSyc("start");
               this._gamePlayer.body.WingState = GameCharacter.GAME_WING_SHOOT;
            }
         }
      }
      
      override public function execute() : void
      {
         if(!this._petMovieOver)
         {
            return;
         }
         if(this._hasDonePrepareAction && (this._gamePlayer == null || this._gamePlayer.body == null || this._gamePlayer.body.currentAction == null))
         {
            _isFinished = true;
            return;
         }
         if(this._gamePlayer)
         {
            if(this._gamePlayer.body.currentAction != this._actionType)
            {
               if(this._gamePlayer.weaponMovie)
               {
                  this._gamePlayer.weaponMovie.visible = false;
               }
               this._gamePlayer.body.WingState = GameCharacter.GAME_WING_WAIT;
            }
            if(this._hasDonePrepareAction && (!this._gamePlayer.map.isPlayingMovie && (!this._gamePlayer.body.actionPlaying() || this._gamePlayer.body.currentAction != this._actionType)))
            {
               _isFinished = true;
            }
         }
      }
   }
}
