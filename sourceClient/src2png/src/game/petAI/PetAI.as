// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.petAI.PetAI

package game.petAI
{
    import com.pickgliss.ui.core.Disposeable;
    import game.objects.GamePet;
    import game.view.map.MapView;
    import game.model.Player;
    import game.objects.GamePlayer;
    import game.model.PetLiving;
    import flash.geom.Point;

    public class PetAI implements Disposeable 
    {

        private var _pet:GamePet;
        private var _map:MapView;
        private var _master:Player;
        private var _gameMaster:GamePlayer;
        private var _petLiving:PetLiving;
        private var _target:Point;
        private var _count:int;
        private var _puased:Boolean;

        public function PetAI(_arg_1:GamePet, _arg_2:MapView)
        {
            this._pet = _arg_1;
            this._map = _arg_2;
            this._petLiving = (this._pet.info as PetLiving);
            this._master = this._petLiving.master;
            this.generTarget();
        }

        public function excute():void
        {
            if ((!(this._puased)))
            {
                this._count++;
                if (this._pet.isDefence)
                {
                    return;
                };
                if (this._master.isAttacking)
                {
                    if (((Point.distance(this._master.pos, this._pet.pos) > 100) && (!(this._master.isFalling))))
                    {
                        this._pet.colseToMaster();
                    }
                    else
                    {
                        this._pet.standby();
                    };
                }
                else
                {
                    if (((Point.distance(this._master.pos, this._pet.pos) > 100) && (!(this._master.isFalling))))
                    {
                        this._pet.colseToMaster();
                    }
                    else
                    {
                        this._pet.walkTo(this._target);
                    };
                };
                if (((this._map.IsOutMap(this._pet.pos.x, this._pet.pos.y)) || (!(this._pet.canStand(this._pet.pos.x, this._pet.pos.y)))))
                {
                    this._pet.blinkTo(this._map.findYLineNotEmptyPointDown(this._master.pos.x, this._master.pos.y, this._map.bound.height));
                };
                if ((this._count % 50) == 0)
                {
                    this.generTarget();
                };
            };
        }

        private function generTarget():void
        {
            this._target = this.getRandomPoint();
        }

        public function getRandomPoint():Point
        {
            return (new Point((this._master.pos.x + this.random()), this._master.pos.y));
        }

        private function random():Number
        {
            var _local_1:Number = ((Math.random() * 100) - 50);
            if (_local_1 > 0)
            {
                _local_1 = (_local_1 + 50);
            }
            else
            {
                _local_1 = (_local_1 - 50);
            };
            return (_local_1);
        }

        private function walkAround():void
        {
        }

        private function standby():void
        {
        }

        private function blink():void
        {
        }

        private function walkToMaster():void
        {
        }

        public function get puased():Boolean
        {
            return (this._puased);
        }

        public function set puased(_arg_1:Boolean):void
        {
            this._puased = _arg_1;
        }

        public function dispose():void
        {
            this._petLiving = null;
            this._gameMaster = null;
            this._map = null;
            this._master = null;
            this._pet = null;
        }


    }
}//package game.petAI

