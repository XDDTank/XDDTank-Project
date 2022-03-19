// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.actions.pet.PetWalkAction

package game.actions.pet
{
    import game.actions.BaseAction;
    import game.objects.GamePet;
    import flash.geom.Point;

    public class PetWalkAction extends BaseAction 
    {

        private var _pet:GamePet;
        private var _target:Point;
        private var _walkAction:String;
        private var _standAction:String;

        public function PetWalkAction(_arg_1:GamePet, _arg_2:Point)
        {
            this._pet = _arg_1;
            this._target = _arg_2;
        }

        override public function canReplace(_arg_1:BaseAction):Boolean
        {
            return (true);
        }

        override public function prepare():void
        {
            if (this._pet.pos.x < this._target.x)
            {
                this._pet.info.direction = 1;
            }
            else
            {
                this._pet.info.direction = -1;
            };
            this._walkAction = ((Math.random() > 0.5) ? "walkA" : "walkB");
            this._standAction = ((Math.random() > 0.5) ? "standA" : "standB");
        }

        public function get target():Point
        {
            return (this._target);
        }

        override public function connect(_arg_1:BaseAction):Boolean
        {
            if (isFinished)
            {
                return (false);
            };
            if ((_arg_1 is PetWalkAction))
            {
                this._target = PetWalkAction(_arg_1).target;
                return (true);
            };
            return (false);
        }

        override public function execute():void
        {
            var _local_1:Point;
            if (Math.abs((this._pet.pos.x - this._target.x)) > this._pet.stepX)
            {
                if (this._pet.pos.x < this._target.x)
                {
                    this._pet.info.direction = 1;
                }
                else
                {
                    this._pet.info.direction = -1;
                };
                _local_1 = this._pet.getNextWalkPoint(this._pet.info.direction);
                if (_local_1)
                {
                    this._pet.info.pos = _local_1;
                    this._pet.doAction(this._walkAction);
                }
                else
                {
                    this.finish();
                };
            }
            else
            {
                this.finish();
            };
        }

        override public function executeAtOnce():void
        {
            this.finish();
        }

        private function finish():void
        {
            if (this._pet)
            {
                this._pet.doAction(this._standAction);
            };
            _isFinished = true;
            this._pet = null;
        }


    }
}//package game.actions.pet

