// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.actions.pet.CloseToMasterAction

package game.actions.pet
{
    import game.actions.BaseAction;
    import game.objects.GamePet;
    import flash.geom.Point;
    import game.view.map.MapView;

    public class CloseToMasterAction extends BaseAction 
    {

        private var _pet:GamePet;
        private var _target:Point;
        private var _map:MapView;
        private var _path:Array;
        private var _canWalk:Boolean = false;
        private var _count:int = 0;
        private var _walkAction:String;
        private var _standAtion:String;

        public function CloseToMasterAction(_arg_1:GamePet, _arg_2:Point)
        {
            this._pet = _arg_1;
            this._target = _arg_2;
            this._map = this._pet.map;
            _isFinished = false;
            this._walkAction = ((Math.random() > 0.5) ? "walkA" : "walkB");
            this._standAtion = ((Math.random() > 0.5) ? "standA" : "standB");
        }

        public function get target():Point
        {
            return (this._target);
        }

        override public function connect(_arg_1:BaseAction):Boolean
        {
            if (_isFinished)
            {
                return (false);
            };
            if ((_arg_1 is CloseToMasterAction))
            {
                this._target = CloseToMasterAction(_arg_1).target;
                this.findPath();
                return (true);
            };
            return (false);
        }

        override public function prepare():void
        {
            this.findPath();
        }

        override public function canReplace(_arg_1:BaseAction):Boolean
        {
            if (((_arg_1 is PetBlinkAction) || (_arg_1 is PetBeatAction)))
            {
                return (true);
            };
            return (false);
        }

        private function findPath():void
        {
            this._count = 0;
            this._path = [];
            if (Point.distance(this._pet.pos, this._target) > 400)
            {
                this._canWalk = false;
                return;
            };
            var _local_1:int = this._pet.x;
            var _local_2:int = this._pet.y;
            var _local_3:int = ((this._target.x > _local_1) ? 1 : -1);
            this._pet.info.direction = _local_3;
            var _local_4:Point = new Point(_local_1, _local_2);
            while (((this._target.x - _local_1) * _local_3) > 0)
            {
                _local_4 = this._map.findNextWalkPoint(_local_1, _local_2, _local_3, this._pet.stepX, this._pet.stepY);
                if (_local_4)
                {
                    this._path.push(_local_4);
                    _local_1 = _local_4.x;
                    _local_2 = _local_4.y;
                }
                else
                {
                    break;
                };
            };
            var _local_5:Point = this._path[(this._path.length - 1)];
            this._canWalk = ((_local_5) && (Point.distance(_local_5, this._target) <= new Point(this._pet.stepX, this._pet.stepY).length));
        }

        override public function execute():void
        {
            if (Point.distance(this._pet.pos, this._target) > 50)
            {
                if (((this._canWalk) && (this._path[this._count])))
                {
                    this._pet.doAction(this._walkAction);
                    if (this._pet.info)
                    {
                        this._pet.info.pos = this._path[this._count++];
                    };
                }
                else
                {
                    this._pet.blinkTo(this._target);
                };
            }
            else
            {
                this.finish();
            };
        }

        override public function executeAtOnce():void
        {
            if (_isFinished)
            {
                return;
            };
            this._pet.info.pos = this._target;
            this.finish();
        }

        private function finish():void
        {
            this._pet.doAction(this._standAtion);
            _isFinished = true;
            this._pet = null;
        }


    }
}//package game.actions.pet

