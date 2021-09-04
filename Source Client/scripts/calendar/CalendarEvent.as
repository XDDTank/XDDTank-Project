package calendar
{
   import flash.events.Event;
   
   public class CalendarEvent extends Event
   {
      
      public static const SignCountChanged:String = "SignCountChanged";
      
      public static const TodayChanged:String = "TodayChanged";
      
      public static const DayLogChanged:String = "DayLogChanged";
      
      public static const LuckyNumChanged:String = "LuckyNumChanged";
      
      public static const ExchangeGoodsChange:String = "ExchangeGoodsChange";
       
      
      private var _enable:Boolean;
      
      public function CalendarEvent(param1:String, param2:Boolean = true, param3:Boolean = false, param4:Boolean = false)
      {
         super(param1,param3,param4);
         this._enable = param2;
      }
      
      public function get enable() : Boolean
      {
         return this._enable;
      }
   }
}
