// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.actions.LivingTurnAction

package game.actions
{
    import game.objects.GameLiving;

    public class LivingTurnAction extends BaseAction 
    {

        public static const PLUS:int = 0;
        public static const REDUCE:int = 1;

        private var _movie:GameLiving;
        private var _rotation:int;
        private var _speed:int;
        private var _endPlay:String;
        private var _dir:int;
        private var _turnRo:int;

        public function LivingTurnAction(_arg_1:GameLiving, _arg_2:int, _arg_3:int, _arg_4:String)
        {
            _isFinished = false;
            this._movie = _arg_1;
            this._rotation = _arg_2;
            this._speed = _arg_3;
            this._endPlay = _arg_4;
        }

        override public function connect(_arg_1:BaseAction):Boolean
        {
            var _local_2:LivingTurnAction = (_arg_1 as LivingTurnAction);
            if (_local_2)
            {
                this._rotation = _local_2._rotation;
                this._speed = _local_2._speed;
                this._endPlay = _local_2._endPlay;
                this._dir = ((this._movie.rotation > this._rotation) ? REDUCE : PLUS);
                return (true);
            };
            return (false);
        }

        override public function prepare():void
        {
            if (this._movie)
            {
                this._dir = ((this._movie.rotation > this._rotation) ? REDUCE : PLUS);
                this._turnRo = this._movie.rotation;
            }
            else
            {
                _isFinished = true;
            };
        }

        override public function execute():void
        {
            if (this._dir == PLUS)
            {
                if ((this._turnRo + this._speed) >= this._rotation)
                {
                    this.finish();
                }
                else
                {
                    this._turnRo = (this._turnRo + this._speed);
                    this._movie.rotation = this._turnRo;
                };
            }
            else
            {
                if ((this._turnRo - this._speed) <= this._rotation)
                {
                    this.finish();
                }
                else
                {
                    this._turnRo = (this._turnRo - this._speed);
                    this._movie.rotation = this._turnRo;
                };
            };
        }

        private function finish():void
        {
            this._movie.rotation = this._rotation;
            this._movie.doAction(this._endPlay);
            _isFinished = true;
        }

        override public function executeAtOnce():void
        {
            super.executeAtOnce();
            this._movie.rotation = this._rotation;
            this._movie.doAction(this._endPlay);
        }


    }
}//package game.actions

