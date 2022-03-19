// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.actions.pet.PetBeatAction

package game.actions.pet
{
    import game.actions.BaseAction;
    import game.objects.GamePet;
    import flash.geom.Point;
    import game.objects.GamePlayer;
    import game.model.Living;
    import game.model.Player;

    public class PetBeatAction extends BaseAction 
    {

        private var _pet:GamePet;
        private var _act:String;
        private var _pt:Point;
        private var _targets:Array;
        private var _master:GamePlayer;
        private var _updated:Boolean = false;

        public function PetBeatAction(_arg_1:GamePet, _arg_2:GamePlayer, _arg_3:String, _arg_4:Point, _arg_5:Array)
        {
            this._pet = _arg_1;
            this._act = _arg_3;
            this._pt = _arg_4;
            this._targets = _arg_5;
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
            this._pet.map.bringToFront(this._pet.info);
            this._pet.actionMovie.doAction(this._act, this.updateHp);
        }

        private function updateHp():void
        {
            var _local_1:Object;
            var _local_2:Living;
            var _local_3:int;
            var _local_4:int;
            var _local_5:int;
            if (((((this._pet == null) || (this._pet.info == null)) || (this._master == null)) || (this._master.info == null)))
            {
                this.finish();
                return;
            };
            if ((!(this._updated)))
            {
                for each (_local_1 in this._targets)
                {
                    _local_2 = _local_1.target;
                    _local_3 = _local_1.hp;
                    _local_4 = _local_1.damage;
                    _local_5 = _local_1.dander;
                    _local_2.updateBlood(_local_3, 3, _local_4);
                    if ((_local_2 is Player))
                    {
                        Player(_local_2).dander = _local_5;
                    };
                };
                this._updated = true;
                this._pet.blinkTo(this._master.info.pos);
            };
        }

        override public function cancel():void
        {
            var _local_1:Object;
            var _local_2:Living;
            var _local_3:int;
            var _local_4:int;
            var _local_5:int;
            if (((((this._pet == null) || (this._pet.info == null)) || (this._master == null)) || (this._master.info == null)))
            {
                this.finish();
                return;
            };
            if ((!(this._updated)))
            {
                for each (_local_1 in this._targets)
                {
                    _local_2 = _local_1.target;
                    _local_3 = _local_1.hp;
                    _local_4 = _local_1.dam;
                    _local_5 = _local_1.dander;
                    _local_2.isHidden = false;
                    _local_2.updateBlood(_local_3, 3, _local_4);
                    if ((_local_2 is Player))
                    {
                        Player(_local_2).dander = _local_5;
                    };
                };
                this._pet.info.pos = this._master.info.pos;
                this._updated = true;
            };
        }

        private function finish():void
        {
            this._pet = null;
            this._targets = null;
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

