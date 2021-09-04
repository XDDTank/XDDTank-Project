package SingleDungeon.expedition.view
{
   import flash.events.Event;
   import road7th.comm.PackageIn;
   
   public class ExpeditionEvents extends Event
   {
      
      public static const START:String = "start";
      
      public static const STOP:String = "stop";
      
      public static const ACCELERATE:String = "accelerate";
      
      public static const CANCLE:String = "cancle";
      
      public static const UPDATE:String = "update";
      
      public static const ONE_MINUTES:String = "oneMinutes";
      
      public static const LOAD_COMPLETE:String = "loadComplete";
       
      
      private var _pkg:PackageIn;
      
      private var _action:String;
      
      public function ExpeditionEvents(param1:String, param2:String = null, param3:PackageIn = null)
      {
         super(param1,bubbles,cancelable);
         this._pkg = param3;
         this._action = param2;
      }
      
      public function get pkg() : PackageIn
      {
         return this._pkg;
      }
      
      public function get action() : String
      {
         return this._action;
      }
   }
}
