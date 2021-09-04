package ddt.events
{
   import flash.events.Event;
   
   public class TempleteLoaderEvent extends Event
   {
      
      public static const LOAD_COMPLETE:String = "TempleteLoadComplete";
      
      public static const LOAD_ERROR:String = "TempleteLoadError";
      
      public static const LOAD_PROGRESS:String = "TempleteLoadProgress";
      
      public static const ZIP_COMPLETE:String = "TempleteZipComplete";
      
      public static const ZIP_ERROR:String = "TempleteZipError";
      
      public static const ZIP_PROGRESS:String = "TempleteZipProgress";
       
      
      public var data:Object;
      
      public function TempleteLoaderEvent(param1:String, param2:Object = null, param3:Boolean = false, param4:Boolean = false)
      {
         super(param1,param3,param4);
         this.data = param2;
      }
   }
}
