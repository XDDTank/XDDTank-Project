// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.model.TurnedLiving

package game.model
{
    import flash.utils.Dictionary;
    import ddt.events.LivingEvent;

    [Event(name="attackingChanged", type="ddt.events.LivingEvent")]
    public class TurnedLiving extends Living 
    {

        protected var _isAttacking:Boolean = false;
        private var _fightBuffs:Dictionary;

        public function TurnedLiving(_arg_1:int, _arg_2:int, _arg_3:int)
        {
            super(_arg_1, _arg_2, _arg_3);
        }

        public function get isAttacking():Boolean
        {
            return (this._isAttacking);
        }

        public function set isAttacking(_arg_1:Boolean):void
        {
            if (this._isAttacking == _arg_1)
            {
                return;
            };
            this._isAttacking = _arg_1;
            dispatchEvent(new LivingEvent(LivingEvent.ATTACKING_CHANGED));
        }

        override public function beginNewTurn():void
        {
            super.beginNewTurn();
            this.isAttacking = false;
            this._fightBuffs = new Dictionary();
        }

        override public function die(_arg_1:Boolean=true):void
        {
            if (isLiving)
            {
                if (this._isAttacking)
                {
                    this.stopAttacking();
                };
                super.die(_arg_1);
            };
        }

        public function hasState(_arg_1:int):Boolean
        {
            return (!(this._fightBuffs[_arg_1] == null));
        }

        public function addState(_arg_1:int, _arg_2:String=""):void
        {
            if (((!(_arg_1 == 0)) && (this._fightBuffs)))
            {
                this._fightBuffs[_arg_1] = true;
            };
            dispatchEvent(new LivingEvent(LivingEvent.ADD_STATE, _arg_1, 0, _arg_2));
        }

        public function startAttacking():void
        {
            this.isAttacking = true;
        }

        public function stopAttacking():void
        {
            this.isAttacking = false;
        }

        override public function dispose():void
        {
            this._fightBuffs = null;
            super.dispose();
        }


    }
}//package game.model

