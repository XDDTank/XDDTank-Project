// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//petsBag.event.UpdatePetFarmGuildeEvent

package petsBag.event
{
    import flash.events.Event;

    public class UpdatePetFarmGuildeEvent extends Event 
    {

        public static const FINISH:String = "finish";

        public var data:Object;

        public function UpdatePetFarmGuildeEvent(_arg_1:String, _arg_2:Object=null, _arg_3:Boolean=false, _arg_4:Boolean=false)
        {
            this.data = _arg_2;
            super(_arg_1, _arg_3, _arg_4);
        }

    }
}//package petsBag.event

