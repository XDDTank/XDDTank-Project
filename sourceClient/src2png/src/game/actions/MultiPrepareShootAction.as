// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.actions.MultiPrepareShootAction

package game.actions
{
    import __AS3__.vec.Vector;
    import game.objects.GamePlayer;
    import ddt.command.PlayerAction;
    import pet.date.PetSkillInfo;
    import ddt.data.BallInfo;
    import ddt.manager.BallManager;
    import ddt.view.character.GameCharacter;

    public class MultiPrepareShootAction extends BaseAction 
    {

        public static var hasDoSkillAnimation:Boolean;

        protected var _playerList:Vector.<GamePlayer>;
        protected var _actionType:PlayerAction;
        protected var _hasDonePrepareAction:Boolean;
        protected var _skill:PetSkillInfo;
        protected var _petMovieOver:Boolean = true;
        private var _petSkillCount:int;

        public function MultiPrepareShootAction(_arg_1:Vector.<GamePlayer>)
        {
            this._playerList = _arg_1;
        }

        override public function connect(_arg_1:BaseAction):Boolean
        {
            return (_arg_1 is MultiPrepareShootAction);
        }

        override public function prepare():void
        {
            var _local_2:PetSkillInfo;
            if (this._playerList.length == 0)
            {
                _isFinished = true;
                return;
            };
            this._petSkillCount++;
            var _local_1:int = (this._playerList.length - 1);
            while (_local_1 >= 0)
            {
                if ((((this._playerList[_local_1]) && (this._playerList[_local_1].player)) && (this._playerList[_local_1].isLiving)))
                {
                    if (((this._playerList[_local_1].UsedPetSkill.length > 0) && (this._playerList[_local_1].UsedPetSkill.list[0].BallType == 1)))
                    {
                        _local_2 = this._playerList[_local_1].UsedPetSkill.list[0];
                        this._skill = _local_2;
                        this._petMovieOver = false;
                        this._petSkillCount++;
                        this._playerList[_local_1].usePetSkill(_local_2, this.finishPetMovie);
                    }
                    else
                    {
                        this.doPrepareToShootAction();
                    };
                };
                _local_1--;
            };
            this._petSkillCount--;
        }

        private function finishPetMovie():void
        {
            var _local_1:int;
            this._petSkillCount--;
            if (this._petSkillCount == 0)
            {
                this.doPrepareToShootAction();
                this._petMovieOver = true;
                _local_1 = (this._playerList.length - 1);
                while (_local_1 >= 0)
                {
                    this._playerList[_local_1].hidePetMovie();
                    _local_1--;
                };
            };
        }

        protected function doPrepareToShootAction():void
        {
            var _local_1:int;
            var _local_2:BallInfo;
            this._hasDonePrepareAction = true;
            _local_1 = (this._playerList.length - 1);
            while (_local_1 >= 0)
            {
                if (this._playerList[_local_1])
                {
                    _local_2 = BallManager.findBall(this._playerList[_local_1].player.currentBomb);
                    this._actionType = ((_local_2.ActionType == 0) ? GameCharacter.SHOWTHROWS : GameCharacter.SHOWGUN);
                    this._playerList[_local_1].weaponMovie = BallManager.createShootMovieMovie(this._playerList[_local_1].player.currentBomb);
                    this._playerList[_local_1].body.doAction(this._actionType);
                    if (this._playerList[_local_1].weaponMovie)
                    {
                        this._playerList[_local_1].weaponMovie.visible = true;
                        this._playerList[_local_1].setWeaponMoiveActionSyc("start");
                        this._playerList[_local_1].body.WingState = GameCharacter.GAME_WING_SHOOT;
                    };
                };
                _local_1--;
            };
        }

        override public function execute():void
        {
            var _local_3:Boolean;
            if ((!(this._petMovieOver)))
            {
                return;
            };
            if (this._playerList.length == 0)
            {
                _isFinished = true;
                return;
            };
            var _local_1:Boolean = true;
            var _local_2:int = (this._playerList.length - 1);
            while (_local_2 >= 0)
            {
                _local_3 = false;
                if (this._playerList[_local_2])
                {
                    if (this._playerList[_local_2].body.currentAction != this._actionType)
                    {
                        if (this._playerList[_local_2].weaponMovie)
                        {
                            this._playerList[_local_2].weaponMovie.visible = false;
                        };
                        this._playerList[_local_2].body.WingState = GameCharacter.GAME_WING_WAIT;
                    };
                    if (((this._hasDonePrepareAction) && ((!(this._playerList[_local_2].map.isPlayingMovie)) && ((!(this._playerList[_local_2].body.actionPlaying())) || (!(this._playerList[_local_2].body.currentAction == this._actionType))))))
                    {
                        _local_3 = true;
                    };
                };
                _local_1 = ((_local_1) && (_local_3));
                _local_2--;
            };
            _isFinished = _local_1;
        }


    }
}//package game.actions

