package ddt.manager
{
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class InviteManager
   {
      
      private static var _ins:InviteManager;
       
      
      private var _timer:Timer;
      
      private var secCount:int = 62;
      
      private var _enabled:Boolean = true;
      
      public function InviteManager()
      {
         super();
         this._timer = new Timer(1000);
         this._timer.addEventListener(TimerEvent.TIMER,this.__onTimerRun);
      }
      
      public static function get Instance() : InviteManager
      {
         return _ins = _ins || new InviteManager();
      }
      
      private function __onTimerRun(param1:TimerEvent) : void
      {
         ++this.secCount;
         if(this.secCount > 61)
         {
            this._timer.stop();
         }
      }
      
      public function StartTimer() : void
      {
         this.secCount = 0;
         this._timer.start();
      }
      
      public function get enabled() : Boolean
      {
         return this._enabled;
      }
      
      public function set enabled(param1:Boolean) : void
      {
         if(this._enabled == param1)
         {
            return;
         }
         this._enabled = param1;
      }
      
      public function get canUseDungeonBugle() : Boolean
      {
         return this.secCount > 60;
      }
   }
}
