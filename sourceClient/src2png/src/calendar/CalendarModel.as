// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//calendar.CalendarModel

package calendar
{
    import flash.events.EventDispatcher;
    import com.pickgliss.ui.core.Disposeable;
    import flash.utils.Dictionary;

    [Event(name="LuckyNumChanged", type="calendar.CalendarEvent")]
    [Event(name="SignCountChanged", type="calendar.CalendarEvent")]
    [Event(name="TodayChanged", type="calendar.CalendarEvent")]
    public class CalendarModel extends EventDispatcher implements Disposeable 
    {

        public static const Current:int = 1;
        public static const NewAward:int = 2;
        public static const Received:int = 3;
        public static const Calendar:int = 1;
        public static const Activity:int = 2;
        public static const MS_of_Day:int = 86400000;

        private var _luckyNum:int;
        private var _myLuckyNum:int;
        private var _signCount:int = 0;
        private var _awardCounts:Array;
        private var _awards:Array;
        private var _today:Date;
        private var _dayLog:Dictionary;
        private var _activityInfoArr:Array;

        public function CalendarModel(_arg_1:Date, _arg_2:int, _arg_3:Dictionary, _arg_4:Array, _arg_5:Array)
        {
            this._today = _arg_1;
            this._signCount = _arg_2;
            this._dayLog = _arg_3;
            this._awards = _arg_4;
            this._awardCounts = _arg_5;
        }

        public static function getMonthMaxDay(_arg_1:int, _arg_2:int):int
        {
            switch (_arg_1)
            {
                case 0:
                    return (31);
                case 1:
                    if ((_arg_2 % 4) == 0)
                    {
                        return (29);
                    };
                    return (28);
                case 2:
                    return (31);
                case 3:
                    return (30);
                case 4:
                    return (31);
                case 5:
                    return (30);
                case 6:
                    return (31);
                case 7:
                    return (31);
                case 8:
                    return (30);
                case 9:
                    return (31);
                case 10:
                    return (30);
                case 11:
                    return (31);
                default:
                    return (0);
            };
        }


        public function get luckyNum():int
        {
            return (this._luckyNum);
        }

        public function set luckyNum(_arg_1:int):void
        {
            if (this._luckyNum == _arg_1)
            {
                return;
            };
            this._luckyNum = _arg_1;
            dispatchEvent(new CalendarEvent(CalendarEvent.LuckyNumChanged));
        }

        public function get myLuckyNum():int
        {
            return (this._myLuckyNum);
        }

        public function set myLuckyNum(_arg_1:int):void
        {
            if (this._myLuckyNum == _arg_1)
            {
                return;
            };
            this._myLuckyNum = _arg_1;
            dispatchEvent(new CalendarEvent(CalendarEvent.LuckyNumChanged));
        }

        public function get signCount():int
        {
            return (this._signCount);
        }

        public function set signCount(_arg_1:int):void
        {
            if (this._signCount == _arg_1)
            {
                return;
            };
            this._signCount = _arg_1;
            dispatchEvent(new CalendarEvent(CalendarEvent.SignCountChanged));
        }

        public function get awardCounts():Array
        {
            return (this._awardCounts);
        }

        public function get awards():Array
        {
            return (this._awards);
        }

        public function get today():Date
        {
            return (this._today);
        }

        public function set today(_arg_1:Date):void
        {
            if (this._today == _arg_1)
            {
                return;
            };
            this._today = _arg_1;
            dispatchEvent(new CalendarEvent(CalendarEvent.TodayChanged));
        }

        public function get dayLog():Dictionary
        {
            return (this._dayLog);
        }

        public function set dayLog(_arg_1:Dictionary):void
        {
            if (this._dayLog == _arg_1)
            {
                return;
            };
            this._dayLog = _arg_1;
            dispatchEvent(new CalendarEvent(CalendarEvent.DayLogChanged));
        }

        public function hasSigned(_arg_1:Date):Boolean
        {
            return ((((this._dayLog) && (_arg_1.fullYear == this._today.fullYear)) && (_arg_1.month == this._today.month)) && (this._dayLog[_arg_1.date.toString()] == "True"));
        }

        public function hasReceived(_arg_1:int):Boolean
        {
            if (_arg_1 <= this._signCount)
            {
                return (true);
            };
            return (false);
        }

        public function dispose():void
        {
        }

        public function get activityInfoArr():Array
        {
            return (this._activityInfoArr);
        }


    }
}//package calendar

