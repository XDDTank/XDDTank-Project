// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//liveness.DailyReceiveManager

package liveness
{
    import flash.events.EventDispatcher;
    import ddt.utils.RequestVairableCreater;
    import flash.net.URLVariables;
    import com.pickgliss.loader.LoadResourceManager;
    import ddt.manager.PathManager;
    import com.pickgliss.loader.BaseLoader;
    import ddt.data.analyze.CalendarSignAnalyze;
    import com.pickgliss.loader.LoaderEvent;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.data.analyze.DaylyGiveAnalyzer;
    import ddt.manager.PlayerManager;

    public class DailyReceiveManager extends EventDispatcher 
    {

        private static var _instance:DailyReceiveManager;
        public static const CLOSE_ICON:String = "closeIcon";

        private var _dailyAwards:Array;


        public static function get Instance():DailyReceiveManager
        {
            if ((!(_instance)))
            {
                _instance = new (DailyReceiveManager)();
            };
            return (_instance);
        }


        public function request():BaseLoader
        {
            var _local_1:URLVariables = RequestVairableCreater.creatWidthKey(true);
            _local_1["rnd"] = Math.random();
            var _local_2:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("DailyLogList.ashx"), BaseLoader.COMPRESS_REQUEST_LOADER, _local_1);
            _local_2.analyzer = new CalendarSignAnalyze(null);
            _local_2.addEventListener(LoaderEvent.LOAD_ERROR, this.__onLoadError);
            _local_2.addEventListener(LoaderEvent.COMPLETE, this.__complete);
            LoadResourceManager.instance.startLoad(_local_2);
            return (_local_2);
        }

        private function __complete(_arg_1:LoaderEvent):void
        {
            var _local_2:BaseLoader = (_arg_1.currentTarget as BaseLoader);
            _local_2.removeEventListener(LoaderEvent.LOAD_ERROR, this.__onLoadError);
            _local_2.removeEventListener(LoaderEvent.COMPLETE, this.__complete);
        }

        public function show():void
        {
            var _local_1:DailyReceive = ComponentFactory.Instance.creatCustomObject("liveness.hall.DailyReceive");
            _local_1.show();
        }

        private function __onLoadError(_arg_1:LoaderEvent):void
        {
            var _local_2:BaseLoader = (_arg_1.currentTarget as BaseLoader);
            _local_2.removeEventListener(LoaderEvent.LOAD_ERROR, this.__onLoadError);
            _local_2.removeEventListener(LoaderEvent.COMPLETE, this.__complete);
        }

        public function setDailyReceiveInfo(_arg_1:DaylyGiveAnalyzer):void
        {
            this._dailyAwards = _arg_1.awardList;
        }

        public function getByDayTemplateId(_arg_1:int):Array
        {
            var _local_2:Array = new Array();
            var _local_3:int;
            while (_local_3 < this._dailyAwards.length)
            {
                if (this._dailyAwards[_local_3].Type == _arg_1)
                {
                    _local_2.push(this._dailyAwards[_local_3]);
                };
                _local_3++;
            };
            return (_local_2);
        }

        public function getByGradeAwards(_arg_1:Array):Array
        {
            var _local_2:Array = new Array();
            var _local_3:int;
            while (_local_3 < _arg_1.length)
            {
                if (((PlayerManager.Instance.Self.Grade < 20) || (PlayerManager.Instance.Self.Grade == 20)))
                {
                    if (_arg_1[_local_3].NeedLevel == 20)
                    {
                        _local_2.push(_arg_1[_local_3]);
                    };
                }
                else
                {
                    if (((PlayerManager.Instance.Self.Grade < 40) || (PlayerManager.Instance.Self.Grade == 40)))
                    {
                        if (_arg_1[_local_3].NeedLevel == 40)
                        {
                            _local_2.push(_arg_1[_local_3]);
                        };
                    }
                    else
                    {
                        if (_arg_1[_local_3].NeedLevel == 70)
                        {
                            _local_2.push(_arg_1[_local_3]);
                        };
                    };
                };
                _local_3++;
            };
            return (_local_2);
        }


    }
}//package liveness

