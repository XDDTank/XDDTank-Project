package com.pickgliss.loader
{
   import flash.events.EventDispatcher;
   import flash.external.ExternalInterface;
   import flash.system.fscommand;
   
   public class LoadInterfaceManager
   {
      
      private static var _eventDispatcher:EventDispatcher = new EventDispatcher();
       
      
      public function LoadInterfaceManager()
      {
         super();
      }
      
      [Event(name="setSound",type="com.pickgliss.loader.LoadInterfaceEvent")]
      [Event(name="flashGotoAndPlay",type="com.pickgliss.loader.LoadInterfaceEvent")]
      [Event(name="deleteComplete",type="com.pickgliss.loader.LoadInterfaceEvent")]
      [Event(name="checkComplete",type="com.pickgliss.loader.LoadInterfaceEvent")]
      public static function get eventDispatcher() : EventDispatcher
      {
         return _eventDispatcher;
      }
      
      public static function checkClientType() : void
      {
         if(ExternalInterface.available)
         {
            fscommand("checkLoginType");
            ExternalInterface.call("checkLoginType");
         }
         else
         {
            LoadResourceManager.instance.setLoginType(0);
         }
      }
      
      public static function initAppInterface() : void
      {
         if(ExternalInterface.available)
         {
            ExternalInterface.addCallback("setLoginType",LoadResourceManager.instance.setLoginType);
            ExternalInterface.addCallback("checkComplete",__checkHandler);
            ExternalInterface.addCallback("deleteComplete",__deleteHandler);
            ExternalInterface.addCallback("flashGotoAndPlay",__flashGotoAndPlayHandler);
            ExternalInterface.addCallback("setSound",__setSoundHandler);
         }
      }
      
      private static function __checkHandler(... rest) : void
      {
         _eventDispatcher.dispatchEvent(new LoadInterfaceEvent(LoadInterfaceEvent.CHECK_COMPLETE,rest));
      }
      
      private static function __deleteHandler(... rest) : void
      {
         _eventDispatcher.dispatchEvent(new LoadInterfaceEvent(LoadInterfaceEvent.DELETE_COMPLETE,rest));
      }
      
      private static function __flashGotoAndPlayHandler(... rest) : void
      {
         _eventDispatcher.dispatchEvent(new LoadInterfaceEvent(LoadInterfaceEvent.FLASH_GOTO_AND_PLAY,rest));
      }
      
      private static function __setSoundHandler(... rest) : void
      {
         _eventDispatcher.dispatchEvent(new LoadInterfaceEvent(LoadInterfaceEvent.SET_SOUND,rest));
      }
      
      public static function setVersion(param1:int) : void
      {
         LoadInterfaceManager.traceMsg("setVersion:" + param1);
         if(ExternalInterface.available)
         {
            fscommand("setVersion",param1.toString());
         }
      }
      
      public static function checkResource(param1:int, param2:String, param3:String, param4:Boolean = false) : void
      {
         LoadInterfaceManager.traceMsg("checkResource:" + [param1,param2,param3,param4].join("|"));
         if(ExternalInterface.available)
         {
            fscommand("checkResource",[param1,param2,param3,param4].join("|"));
         }
      }
      
      public static function deleteResource(param1:String) : void
      {
         LoadInterfaceManager.traceMsg("deleteResource:" + param1);
         if(ExternalInterface.available)
         {
            fscommand("deleteResource",param1);
         }
      }
      
      public static function traceMsg(param1:String) : void
      {
         if(ExternalInterface.available)
         {
            ExternalInterface.call("debugTrace",param1);
         }
         if(ExternalInterface.available)
         {
            fscommand("printTest",param1);
         }
      }
      
      public static function alertAndRestart(param1:String) : void
      {
         if(ExternalInterface.available)
         {
            traceMsg("alertAndRestart:" + param1);
            fscommand("alertAndRestart",param1);
         }
      }
      
      public static function setDailyTask(param1:String) : void
      {
         if(ExternalInterface.available)
         {
            traceMsg("setDailyTask:" + param1);
            fscommand("setDailyTask",param1);
         }
      }
      
      public static function setDailyActivity(param1:String) : void
      {
         if(ExternalInterface.available)
         {
            traceMsg("setDailyActivity:" + param1);
            fscommand("setDailyActivity",param1);
         }
      }
      
      public static function setFatigue(param1:String) : void
      {
         if(ExternalInterface.available)
         {
            traceMsg("setFatigue:" + param1);
            fscommand("setFatigue",param1);
         }
      }
      
      public static function setSound(param1:String) : void
      {
         if(ExternalInterface.available)
         {
            traceMsg("setSound:" + param1);
            fscommand("setSound",param1);
         }
      }
      
      public static function SyncDesktopTimer(param1:String) : void
      {
         if(ExternalInterface.available)
         {
            traceMsg("SyncDesktopTimer:" + param1);
            fscommand("SyncDesktopTimer",param1);
         }
      }
   }
}
