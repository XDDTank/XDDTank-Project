// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.model.SimpleBoss

package game.model
{
    import ddt.events.LivingEvent;
    import ddt.events.CrazyTankSocketEvent;

    public class SimpleBoss extends TurnedLiving 
    {

        public function SimpleBoss(_arg_1:int, _arg_2:int, _arg_3:int)
        {
            super(_arg_1, _arg_2, _arg_3);
        }

        override public function shoot(_arg_1:Array, _arg_2:CrazyTankSocketEvent):void
        {
            dispatchEvent(new LivingEvent(LivingEvent.SHOOT, 0, 0, _arg_1, _arg_2));
        }

        override public function beginNewTurn():void
        {
            isAttacking = false;
        }


    }
}//package game.model

