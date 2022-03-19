// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//update.UpdateController

package update
{
    import update.data.PopSysNoticeBaseInfo;
    import ddt.manager.SharedManager;
    import update.analyzer.PopSysNoticeBaseAnalyzer;
    import update.analyzer.PopSysNoticeContentAnalyzer;
    import ddt.manager.TimeManager;
    import road7th.utils.DateUtils;

    public class UpdateController 
    {

        private static var _instance:UpdateController;

        private var _noticeBaseList:Array;
        private var _noticeContentList:Array;


        public static function get Instance():UpdateController
        {
            if ((!(_instance)))
            {
                _instance = new (UpdateController)();
            };
            return (_instance);
        }


        public function setPopSysNoticeBase(_arg_1:PopSysNoticeBaseAnalyzer):void
        {
            var _local_3:PopSysNoticeBaseInfo;
            var _local_2:Array = _arg_1.list;
            this._noticeBaseList = new Array();
            for each (_local_3 in _local_2)
            {
                if (((_local_3.Type == 0) && (_local_3.Status == 1)))
                {
                    this._noticeBaseList.push(_local_3);
                };
            };
            if (this.lastNoticeBase)
            {
                if (this.lastNoticeBase.BeginTime != SharedManager.Instance.showUpdateFrameDate)
                {
                    SharedManager.Instance.hasShowUpdateFrame = false;
                };
            };
        }

        public function setPopSysNoticeContent(_arg_1:PopSysNoticeContentAnalyzer):void
        {
            this._noticeContentList = _arg_1.list;
        }

        public function get lastNoticeBase():PopSysNoticeBaseInfo
        {
            var _local_2:PopSysNoticeBaseInfo;
            var _local_4:PopSysNoticeBaseInfo;
            var _local_5:Number;
            var _local_6:Number;
            var _local_1:int;
            var _local_3:Number = TimeManager.Instance.Now().time;
            for each (_local_4 in this._noticeBaseList)
            {
                _local_5 = DateUtils.getDateByStr(_local_4.BeginTime).time;
                _local_6 = DateUtils.getDateByStr(_local_4.EndTime).time;
                if ((((_local_5 > _local_1) && (_local_5 <= _local_3)) && (_local_6 > _local_3)))
                {
                    _local_1 = _local_5;
                    _local_2 = _local_4;
                };
            };
            return (_local_2);
        }

        public function get noticeContentList():Array
        {
            return (this._noticeContentList);
        }


    }
}//package update

