// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.actions.SkillActions.LaserAction

package game.actions.SkillActions
{
    import game.actions.BaseAction;
    import game.objects.GamePlayer;
    import road7th.utils.MovieClipWrapper;
    import ddt.command.PlayerAction;
    import game.model.Living;
    import game.view.map.MapView;
    import ddt.manager.SkillManager;
    import game.model.Player;
    import flash.display.MovieClip;
    import ddt.view.character.GameCharacter;
    import flash.events.Event;
    import game.animations.ShockMapAnimation;

    public class LaserAction extends BaseAction 
    {

        public static const radius:int = 60;

        private var _player:GamePlayer;
        private var _laserMovie:MovieClipWrapper;
        private var _movieComplete:Boolean = false;
        private var _movieStarted:Boolean = false;
        private var _shocked:Boolean = false;
        private var _showAction:PlayerAction;
        private var _hideAction:PlayerAction;
        private var _living:Living;
        private var _map:MapView;
        private var _angle:int;
        private var _speed:int;

        public function LaserAction(_arg_1:Living, _arg_2:MapView, _arg_3:int)
        {
            this._living = _arg_1;
            this._map = _arg_2;
            this._angle = _arg_3;
        }

        override public function prepare():void
        {
            var _local_1:int;
            if (_isPrepare)
            {
                return;
            };
            _isPrepare = true;
            this._laserMovie = new MovieClipWrapper((SkillManager.createWeaponSkillMovieAsset(Player(this._living).currentWeapInfo.skill) as MovieClip));
            var _local_2:int;
            if (this._living.direction == -1)
            {
                _local_2 = (180 + this._angle);
                this._laserMovie.movie.scaleX = -1;
            }
            else
            {
                _local_2 = this._angle;
                this._laserMovie.movie.scaleX = 1;
            };
            this._laserMovie.movie.rotation = _local_2;
            this._laserMovie.movie.x = this._living.pos.x;
            this._laserMovie.movie.y = this._living.pos.y;
            this._map.addChild(this._laserMovie.movie);
            this._showAction = GameCharacter.SHOT;
            this._hideAction = GameCharacter.HIDEGUN;
        }

        override public function execute():void
        {
            if ((!(this._movieStarted)))
            {
                this._laserMovie.addEventListener(Event.COMPLETE, this.__movieComplete);
                this._laserMovie.movie.addEventListener(Event.ENTER_FRAME, this.__laserFrame);
                this._laserMovie.gotoAndPlay(1);
                this._movieStarted = true;
            };
        }

        private function __laserFrame(_arg_1:Event):void
        {
            if (((this._laserMovie.movie.currentFrame >= (this._laserMovie.movie.totalFrames - 6)) && (!(this._shocked))))
            {
                this._map.animateSet.addAnimation(new ShockMapAnimation(null));
            };
        }

        private function __movieComplete(_arg_1:Event):void
        {
            this._laserMovie.removeEventListener(Event.COMPLETE, this.__movieComplete);
            this._laserMovie.movie.removeEventListener(Event.ENTER_FRAME, this.__laserFrame);
            if (this._laserMovie.movie.parent)
            {
                this._laserMovie.movie.parent.removeChild(this._laserMovie.movie);
            };
            this._laserMovie.dispose();
            _isFinished = true;
        }


    }
}//package game.actions.SkillActions

