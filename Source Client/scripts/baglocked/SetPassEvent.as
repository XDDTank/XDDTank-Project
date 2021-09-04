package baglocked
{
   import flash.events.Event;
   
   public class SetPassEvent extends Event
   {
      
      public static const CANCELBTN:String = "cancelBtn";
      
      public static const OKBTN:String = "okBtn";
       
      
      public var data:Object;
      
      public function SetPassEvent(param1:String, param2:Object = null, param3:Boolean = false, param4:Boolean = false)
      {
         super(param1,param3,param4);
         this.data = param2;
      }
   }
}
