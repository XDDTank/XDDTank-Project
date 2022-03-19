// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.manager.BadgeInfoManager

package ddt.manager
{
    import flash.utils.Dictionary;
    import ddt.data.analyze.BadgeInfoAnalyzer;
    import consortion.data.BadgeInfo;

    public class BadgeInfoManager 
    {

        private static var _instance:BadgeInfoManager;

        private var _badgeList:Dictionary;

        public function BadgeInfoManager()
        {
            this._badgeList = new Dictionary();
        }

        public static function get instance():BadgeInfoManager
        {
            if (_instance == null)
            {
                _instance = new (BadgeInfoManager)();
            };
            return (_instance);
        }


        public function setup(_arg_1:BadgeInfoAnalyzer):void
        {
            this._badgeList = _arg_1.list;
        }

        public function getBadgeInfoByID(_arg_1:int):BadgeInfo
        {
            return (this._badgeList[_arg_1]);
        }

        public function getBadgeInfoByLevel(_arg_1:int, _arg_2:int):Array
        {
            var _local_4:BadgeInfo;
            var _local_3:Array = [];
            for each (_local_4 in this._badgeList)
            {
                if (((_local_4.LimitLevel >= _arg_1) && (_local_4.LimitLevel <= _arg_2)))
                {
                    _local_3.push(_local_4);
                };
            };
            return (_local_3);
        }


    }
}//package ddt.manager

