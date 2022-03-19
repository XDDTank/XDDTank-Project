// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//weekend.WeekendEvent

package weekend
{
    import flash.events.Event;

    public class WeekendEvent extends Event 
    {

        public static const ENERGY_CHANGE:String = "energyChange";

        public var data:Object;

        public function WeekendEvent(_arg_1:String, _arg_2:Object=null)
        {
            this.data = _arg_2;
            super(_arg_1, bubbles, cancelable);
        }

    }
}//package weekend

