// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//road7th.utils.DateUtils

package road7th.utils
{
    public class DateUtils 
    {

        public static const DAY_SECONDS:int = ((24 * 60) * 60);//86400
        public static const HOUR_SECONDS:int = (60 * 60);//3600
        public static const MINITE_SECONDS:int = 60;


        public static function getDateByStr(_arg_1:String):Date
        {
            var _local_2:Array;
            var _local_3:Array;
            var _local_4:int;
            var _local_5:int;
            var _local_6:int;
            var _local_7:Array;
            var _local_8:int;
            var _local_9:int;
            var _local_10:int;
            if (_arg_1)
            {
                _local_2 = _arg_1.split(" ");
                _local_3 = _local_2[0].split("-");
                _local_4 = _local_3[0];
                _local_5 = (_local_3[1] - 1);
                _local_6 = _local_3[2];
                _local_7 = _local_2[1].split(":");
                _local_8 = _local_7[0];
                _local_9 = _local_7[1];
                _local_10 = _local_7[2];
                return (new Date(_local_4, _local_5, _local_6, _local_8, _local_9, _local_10));
            };
            return (new Date(0));
        }

        public static function getHourDifference(_arg_1:Number, _arg_2:Number):int
        {
            return (Math.floor(((_arg_2 - _arg_1) / 3600000)));
        }

        public static function getDays(_arg_1:int, _arg_2:int):int
        {
            var _local_3:Date = new Date(_arg_1, _arg_2);
            return (_local_3.getUTCDate());
        }

        public static function decodeDated(_arg_1:String):Date
        {
            var _local_2:Array = _arg_1.split("T");
            var _local_3:Array = _local_2[0].split("-");
            var _local_4:Array = _local_2[1].split(":");
            return (new Date(_local_3[0], (_local_3[1] - 1), _local_3[2], _local_4[0], _local_4[1], _local_4[2]));
        }

        public static function encodeDated(_arg_1:Date):String
        {
            var _local_2:String = "";
            var _local_3:String = _arg_1.fullYear.toString();
            var _local_4:String = (((_arg_1.month + 1) < 10) ? (("0" + _arg_1.month) + 1) : (_arg_1.month + 1).toString());
            var _local_5:String = ((_arg_1.date < 10) ? ("0" + _arg_1.date) : _arg_1.date.toString());
            var _local_6:String = ((_arg_1.hours < 10) ? ("0" + _arg_1.hours) : _arg_1.hours.toString());
            var _local_7:String = ((_arg_1.minutes < 10) ? ("0" + _arg_1.minutes) : _arg_1.minutes.toString());
            var _local_8:String = ((_arg_1.seconds < 10) ? ("0" + _arg_1.seconds) : _arg_1.seconds.toString());
            return ((((((((((_local_3 + "-") + _local_4) + "-") + _local_5) + "T") + _local_6) + ":") + _local_7) + ":") + _local_8);
        }

        public static function isToday(_arg_1:Date):Boolean
        {
            var _local_2:Date = new Date();
            return (((_arg_1.getDate() == _local_2.getDate()) && (_arg_1.getMonth() == _local_2.getMonth())) && (_arg_1.getFullYear() == _local_2.getFullYear()));
        }

        public static function dealWithStringDate(_arg_1:String):Date
        {
            var _local_2:int;
            var _local_3:int;
            var _local_4:int;
            var _local_5:int;
            var _local_6:int;
            if (_arg_1.indexOf("-") > 0)
            {
                _local_2 = parseInt(_arg_1.split(" ")[1].split(":")[0]);
                _local_6 = parseInt(_arg_1.split(" ")[1].split(":")[1]);
                _local_3 = parseInt(_arg_1.split(" ")[0].split("-")[2]);
                _local_4 = (parseInt(_arg_1.split(" ")[0].split("-")[1]) - 1);
                _local_5 = parseInt(_arg_1.split(" ")[0].split("-")[0]);
            };
            if (_arg_1.indexOf("/") > 0)
            {
                if (_arg_1.indexOf("PM") > 0)
                {
                    _local_2 = (parseInt(_arg_1.split(" ")[1].split(":")[0]) + 12);
                }
                else
                {
                    _local_2 = parseInt(_arg_1.split(" ")[1].split(":")[0]);
                };
                _local_6 = parseInt(_arg_1.split(" ")[1].split(":")[1]);
                _local_3 = parseInt(_arg_1.split(" ")[0].split("/")[1]);
                _local_4 = (parseInt(_arg_1.split(" ")[0].split("/")[0]) - 1);
                _local_5 = parseInt(_arg_1.split(" ")[0].split("/")[2]);
            };
            return (new Date(_local_5, _local_4, _local_3, _local_2, _local_6));
        }

        public static function dateFormat(_arg_1:Date):String
        {
            var _local_2:String = "";
            var _local_3:String = _arg_1.fullYear.toString();
            var _local_4:String = (((_arg_1.month + 1) < 10) ? ("0" + (_arg_1.month + 1)) : (_arg_1.month + 1).toString());
            var _local_5:String = ((_arg_1.date < 10) ? ("0" + _arg_1.date) : _arg_1.date.toString());
            var _local_6:String = ((_arg_1.hours < 10) ? ("0" + _arg_1.hours) : _arg_1.hours.toString());
            var _local_7:String = ((_arg_1.minutes < 10) ? ("0" + _arg_1.minutes) : _arg_1.minutes.toString());
            var _local_8:String = ((_arg_1.seconds < 10) ? ("0" + _arg_1.seconds) : _arg_1.seconds.toString());
            return ((((((((((_local_3 + "-") + _local_4) + "-") + _local_5) + " ") + _local_6) + ":") + _local_7) + ":") + _local_8);
        }


    }
}//package road7th.utils

