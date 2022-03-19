// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.actions.pet.PetBlinkAction

package game.actions.pet
{
    import game.actions.BaseAction;
    import game.objects.GamePet;
    import flash.geom.Point;

    public class PetBlinkAction extends BaseAction 
    {

        private var _pet:GamePet;
        private var _origin:Point;
        private var _target:Point;
        private var _life:int = 1;
        private var _total:int = 20;

        public function PetBlinkAction(_arg_1:GamePet, _arg_2:Point)
        {
            this._pet = _arg_1;
            this._origin = this._pet.info.pos;
            this._target = _arg_2;
            super();
        }

        public function get target():Point
        {
            return (this._target);
        }

        public function get origin():Point
        {
            return (this._origin);
        }

        override public function prepare():void
        {
            this._pet.actionMovie.doAction("call");
        }

        override public function connect(_arg_1:BaseAction):Boolean
        {
            if ((_arg_1 is PetBlinkAction))
            {
                this._target = PetBlinkAction(_arg_1).target;
                return (true);
            };
            return (false);
        }

        override public function canReplace(_arg_1:BaseAction):Boolean
        {
            return (false);
        }

        private function finish():void
        {
            if (((this._pet) && (this._pet.info)))
            {
                this._pet.info.pos = this._target;
                this._pet.stopMoving();
                this._pet.walkToRandom();
            };
            _isFinished = true;
            this._pet = null;
        }

        override public function cancel():void
        {
            this.finish();
        }

        override public function execute():void
        {
            var _local_1:Point;
            if (((((!(this._pet)) || (!(this._pet.actionMovie))) || (!(this._origin))) || (!(this._target))))
            {
                this.finish();
                return;
            };
            this._pet.actionMovie.doAction("call");
            _local_1 = new Point((this._origin.x + ((this._target.x - this._origin.x) * (this._life / this._total))), (this._origin.y + ((this._target.y - this._origin.y) * (this._life / this._total))));
            this._pet.x = _local_1.x;
            this._pet.y = _local_1.y;
            this._life++;
            if ((((!(this._pet.info)) || (this._life > this._total)) || (Point.distance(this._target, this._pet.info.pos) < 1)))
            {
                this.finish();
            };
        }

        override public function executeAtOnce():void
        {
            this.finish();
        }


    }
}//package game.actions.pet

