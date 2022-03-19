// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//calendar.CalendarEvent

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

        public function CalendarEvent(_arg_1:String, _arg_2:Boolean=true, _arg_3:Boolean=false, _arg_4:Boolean=false)
        {
            super(_arg_1, _arg_3, _arg_4);
            this._enable = _arg_2;
        }

        public function get enable():Boolean
        {
            return (this._enable);
        }


    }
}//package calendar

