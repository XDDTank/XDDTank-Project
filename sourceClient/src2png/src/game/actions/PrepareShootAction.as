// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.actions.PrepareShootAction

package game.actions
{
    import game.objects.GamePlayer;
    import game.objects.BossPlayer;
    import ddt.command.PlayerAction;
    import pet.date.PetSkillInfo;
    import game.objects.GameTurnedLiving;
    import ddt.data.BallInfo;
    import ddt.manager.BallManager;
    import ddt.view.character.GameCharacter;
    import ddt.manager.SharedManager;

    public class PrepareShootAction extends BaseAction 
    {

        public static var hasDoSkillAnimation:Boolean;

        protected var _gamePlayer:GamePlayer;
        protected var _bossPlayer:BossPlayer;
        protected var _actionType:PlayerAction;
        protected var _hasDonePrepareAction:Boolean;
        protected var _skill:PetSkillInfo;
        protected var _petMovieOver:Boolean = true;

        public function PrepareShootAction(_arg_1:GameTurnedLiving)
        {
            if ((_arg_1 as GamePlayer))
            {
                this._gamePlayer = GamePlayer(_arg_1);
            }
            else
            {
                if ((_arg_1 as BossPlayer))
                {
                    this._bossPlayer = BossPlayer(_arg_1);
                };
            };
        }

        override public function connect(_arg_1:BaseAction):Boolean
        {
            return (_arg_1 is PrepareShootAction);
        }

        override public function prepare():void
        {
            var _local_1:PetSkillInfo;
            if ((((this._gamePlayer) && (this._gamePlayer.player)) && (this._gamePlayer.isLiving)))
            {
                if (((this._gamePlayer.UsedPetSkill.length > 0) && (this._gamePlayer.UsedPetSkill.list[0].BallType == 1)))
                {
                    _local_1 = this._gamePlayer.UsedPetSkill.list[0];
                    this._skill = _local_1;
                    this._petMovieOver = false;
                    this._gamePlayer.usePetSkill(_local_1, this.finishPetMovie);
                }
                else
                {
                    this.doPrepareToShootAction();
                };
            }
            else
            {
                _isFinished = true;
            };
        }

        private function finishPetMovie():void
        {
            this.doPrepareToShootAction();
            this._petMovieOver = true;
            this._gamePlayer.hidePetMovie();
        }

        protected function doPrepareToShootAction():void
        {
            var _local_1:BallInfo;
            if (this._gamePlayer)
            {
                this._hasDonePrepareAction = true;
                _local_1 = BallManager.findBall(this._gamePlayer.player.currentBomb);
                this._actionType = ((_local_1.ActionType == 0) ? GameCharacter.SHOWTHROWS : GameCharacter.SHOWGUN);
                if (((((this._gamePlayer.player.skill >= 0) || (this._gamePlayer.player.isSpecialSkill)) && (SharedManager.Instance.showParticle)) && (!(hasDoSkillAnimation))))
                {
                    hasDoSkillAnimation = true;
                    this._gamePlayer.map.spellKill(this._gamePlayer);
                };
                this._gamePlayer.weaponMovie = BallManager.createShootMovieMovie(this._gamePlayer.player.currentBomb);
                this._gamePlayer.body.doAction(this._actionType);
                if (this._gamePlayer.weaponMovie)
                {
                    this._gamePlayer.weaponMovie.visible = true;
                    this._gamePlayer.setWeaponMoiveActionSyc("start");
                    this._gamePlayer.body.WingState = GameCharacter.GAME_WING_SHOOT;
                };
            };
        }

        override public function execute():void
        {
            if ((!(this._petMovieOver)))
            {
                return;
            };
            if (((this._hasDonePrepareAction) && (((this._gamePlayer == null) || (this._gamePlayer.body == null)) || (this._gamePlayer.body.currentAction == null))))
            {
                _isFinished = true;
                return;
            };
            if (this._gamePlayer)
            {
                if (this._gamePlayer.body.currentAction != this._actionType)
                {
                    if (this._gamePlayer.weaponMovie)
                    {
                        this._gamePlayer.weaponMovie.visible = false;
                    };
                    this._gamePlayer.body.WingState = GameCharacter.GAME_WING_WAIT;
                };
                if (((this._hasDonePrepareAction) && ((!(this._gamePlayer.map.isPlayingMovie)) && ((!(this._gamePlayer.body.actionPlaying())) || (!(this._gamePlayer.body.currentAction == this._actionType))))))
                {
                    _isFinished = true;
                };
            };
        }


    }
}//package game.actions

