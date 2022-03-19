// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.actions.pet.PetDefenceAction

package game.actions.pet
{
    import game.actions.BaseAction;
    import game.objects.GamePet;
    import flash.geom.Point;
    import game.objects.GamePlayer;

    public class PetDefenceAction extends BaseAction 
    {

        private var _pet:GamePet;
        private var _act:String;
        private var _pt:Point;
        private var _master:GamePlayer;
        private var _updated:Boolean = false;

        public function PetDefenceAction(_arg_1:GamePet, _arg_2:GamePlayer, _arg_3:String, _arg_4:Point)
        {
            this._pet = _arg_1;
            this._act = _arg_3;
            this._pt = _arg_4;
            this._master = _arg_2;
            super();
        }

        override public function prepare():void
        {
            super.prepare();
            if (((this._pet == null) || (this._pet.info == null)))
            {
                this.finish();
                return;
            };
            this._pet.info.pos = this._pt;
            this._pet.info.direction = this._master.info.direction;
            this._pet.isDefence = true;
            this._pet.map.addMapThing(this._pet);
            this._pet.actionMovie.doAction(this._act, this.updateHp);
        }

        override public function canReplace(_arg_1:BaseAction):Boolean
        {
            return (true);
        }

        private function updateHp():void
        {
            if (((((this._pet == null) || (this._pet.info == null)) || (this._master == null)) || (this._master.info == null)))
            {
                this.finish();
                return;
            };
            if ((!(this._updated)))
            {
                this._updated = true;
            };
        }

        override public function cancel():void
        {
            if (((((this._pet == null) || (this._pet.info == null)) || (this._master == null)) || (this._master.info == null)))
            {
                this.finish();
                return;
            };
            if ((!(this._updated)))
            {
                this._pet.info.pos = this._master.info.pos;
                this._updated = true;
            };
        }

        private function finish():void
        {
            if (this._pet)
            {
                this._pet.isDefence = false;
                if (this._pet.map)
                {
                    this._pet.map.addPhysical(this._pet);
                    this._pet.map.bringToFront(this._master.player);
                    this._pet.walkToRandom();
                };
            };
            this._pet = null;
            this._master = null;
            _isFinished = true;
        }

        override public function executeAtOnce():void
        {
            this.cancel();
        }

        override public function execute():void
        {
            if (((((this._pet == null) || (this._pet.info == null)) || (this._master == null)) || (this._master.info == null)))
            {
                this.finish();
                return;
            };
            if (this._updated)
            {
                this.finish();
            };
        }


    }
}//package game.actions.pet

