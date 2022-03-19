// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.actions.ChangeDirectionAction

package game.actions
{
    import game.objects.GameLiving;
    import road.game.resource.ActionMovie;

    public class ChangeDirectionAction extends BaseAction 
    {

        private var _living:GameLiving;
        private var _dir:int;
        private var _direction:String;

        public function ChangeDirectionAction(_arg_1:GameLiving, _arg_2:int)
        {
            this._living = _arg_1;
            this._dir = _arg_2;
            if (this._dir > 0)
            {
                this._direction = ActionMovie.RIGHT;
            }
            else
            {
                this._direction = ActionMovie.LEFT;
            };
        }

        override public function canReplace(_arg_1:BaseAction):Boolean
        {
            var _local_2:ChangeDirectionAction = (_arg_1 as ChangeDirectionAction);
            if (((_local_2) && (this._dir == _local_2.dir)))
            {
                return (true);
            };
            return (false);
        }

        override public function connect(_arg_1:BaseAction):Boolean
        {
            var _local_2:ChangeDirectionAction = (_arg_1 as ChangeDirectionAction);
            if (((_local_2) && (this._dir == _local_2.dir)))
            {
                return (true);
            };
            return (false);
        }

        public function get dir():int
        {
            return (this._dir);
        }

        override public function prepare():void
        {
            if (_isPrepare)
            {
                return;
            };
            _isPrepare = true;
            if ((!(this._living.isLiving)))
            {
                _isFinished = true;
            };
        }

        override public function execute():void
        {
            this._living.actionMovie.direction = this._direction;
            _isFinished = true;
        }

        override public function executeAtOnce():void
        {
            super.executeAtOnce();
            this._living.actionMovie.direction = this._direction;
        }


    }
}//package game.actions

