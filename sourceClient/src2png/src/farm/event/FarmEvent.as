// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//farm.event.FarmEvent

package farm.event
{
    import flash.events.Event;

    public class FarmEvent extends Event 
    {

        public static const FIELDS_INFO_READY:String = "fieldsInfoReady";
        public static const HAS_SEEDING:String = "hasSeeding";
        public static const GAIN_FIELD:String = "gainField";
        public static const SEED:String = "seed";
        public static const PLANETDELETE:String = "plantdelete";
        public static const PLANTSPEED:String = "plantspeed";

        public var data:*;

        public function FarmEvent(_arg_1:String, _arg_2:*=null)
        {
            super(_arg_1, true);
            this.data = _arg_2;
        }

    }
}//package farm.event

