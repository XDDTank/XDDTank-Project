package com.pickgliss.events
{
   import flash.events.Event;
   
   public class ResourceLoaderEvent extends Event
   {
      
      public static const CORE_SETUP_COMPLETE:String = "coreSetupLoadComplete";
      
      public static const USER_DATA_COMPLETE:String = "userDataComplete";
       
      
      public function ResourceLoaderEvent(param1:String)
      {
         super(param1);
      }
   }
}
