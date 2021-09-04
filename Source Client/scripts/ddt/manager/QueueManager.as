package ddt.manager
{
   import ddt.events.CrazyTankSocketEvent;
   import flash.display.Stage;
   import flash.events.Event;
   
   public class QueueManager
   {
      
      private static var _executable:Array = new Array();
      
      public static var _waitlist:Array = new Array();
      
      private static var _lifeTime:int = 0;
      
      private static var _running:Boolean = true;
      
      private static var _diffTimeValue:int = 0;
      
      private static var _speedUp:int = 2;
       
      
      public function QueueManager()
      {
         super();
      }
      
      public static function get lifeTime() : int
      {
         return _lifeTime;
      }
      
      public static function setup(param1:Stage) : void
      {
         param1.addEventListener(Event.ENTER_FRAME,frameHandler);
      }
      
      public static function pause() : void
      {
         _running = false;
      }
      
      public static function resume() : void
      {
         _running = true;
      }
      
      public static function setLifeTime(param1:int) : void
      {
         _lifeTime = param1;
         _executable.concat(_waitlist);
      }
      
      public static function addQueue(param1:CrazyTankSocketEvent) : void
      {
         _waitlist.push(param1);
      }
      
      private static function frameHandler(param1:Event) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:CrazyTankSocketEvent = null;
         var _loc5_:int = 0;
         var _loc6_:CrazyTankSocketEvent = null;
         var _loc7_:int = 0;
         ++_lifeTime;
         if(_running)
         {
            _loc2_ = 0;
            _loc3_ = 0;
            _loc3_ = 0;
            while(_loc3_ < _waitlist.length)
            {
               _loc6_ = _waitlist[_loc3_];
               if(_loc6_.pkg.extend2 <= _lifeTime)
               {
                  _executable.push(_loc6_);
                  _loc2_++;
               }
               _loc3_++;
            }
            for each(_loc4_ in _executable)
            {
               _loc7_ = _waitlist.indexOf(_loc4_);
               if(_loc7_ != -1)
               {
                  _waitlist.splice(_loc7_,1);
               }
            }
            _loc2_ = 0;
            _loc5_ = 0;
            while(_loc5_ < _executable.length)
            {
               if(_running)
               {
                  dispatchEvent(_executable[_loc5_]);
                  _loc2_++;
               }
               _loc5_++;
            }
            _executable.splice(0,_loc2_);
         }
      }
      
      private static function dispatchEvent(param1:Event) : void
      {
         var event:Event = param1;
         try
         {
            SocketManager.Instance.dispatchEvent(event);
         }
         catch(err:Error)
         {
            SocketManager.Instance.out.sendErrorMsg("type:" + event.type + "msg:" + err.message + "\r\n" + err.getStackTrace());
         }
      }
   }
}
