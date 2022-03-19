// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//daily.DailyManager

package daily
{
    import ddt.data.analyze.DaylyGiveAnalyzer;

    public class DailyManager 
    {

        public static var list:Array;
        private static var _instance:DailyManager;


        public static function setupDailyInfo(_arg_1:DaylyGiveAnalyzer):void
        {
            list = _arg_1.list;
        }

        public static function get Instance():DailyManager
        {
            if (_instance == null)
            {
                _instance = new (DailyManager)();
            };
            return (_instance);
        }


        public function show():void
        {
        }


    }
}//package daily

