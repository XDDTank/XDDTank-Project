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
       
      
      public var data;
      
      public function FarmEvent(param1:String, param2:* = null)
      {
         super(param1,true);
         this.data = param2;
      }
   }
}
