// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.objects.GameTurnedLiving

package game.objects
{
    import game.model.TurnedLiving;
    import ddt.events.LivingEvent;
    import game.view.smallMap.SmallLiving;

    public class GameTurnedLiving extends GameLiving 
    {

        public function GameTurnedLiving(_arg_1:TurnedLiving)
        {
            super(_arg_1);
        }

        public function get turnedLiving():TurnedLiving
        {
            return (_info as TurnedLiving);
        }

        override protected function initListener():void
        {
            super.initListener();
            this.turnedLiving.addEventListener(LivingEvent.ATTACKING_CHANGED, this.__attackingChanged);
        }

        override protected function removeListener():void
        {
            super.removeListener();
            if (this.turnedLiving)
            {
                this.turnedLiving.removeEventListener(LivingEvent.ATTACKING_CHANGED, this.__attackingChanged);
            };
        }

        protected function __attackingChanged(_arg_1:LivingEvent):void
        {
            _turns++;
            SmallLiving(_smallView).isAttacking = this.turnedLiving.isAttacking;
        }

        override public function die():void
        {
            this.turnedLiving.isAttacking = false;
            super.die();
        }


    }
}//package game.objects

