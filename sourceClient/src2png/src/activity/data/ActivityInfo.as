// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//activity.data.ActivityInfo

package activity.data
{
    import road7th.utils.DateUtils;
    import ddt.manager.LanguageMgr;
    import ddt.manager.TimeManager;

    public class ActivityInfo 
    {

        public var ActivityId:String;
        public var ActivityName:String;
        public var ActivityType:int;
        public var ActivityChildType:int;
        private var _BeginTime:String;
        private var _EndTime:String;
        public var Status:int;
        public var IsContinue:Boolean;
        public var GetWay:int;
        public var Desc:String;
        private var _RewardDesc:String;
        private var _BeginShowTime:String;
        private var _EndShowTime:String;
        public var Icon:String;
        public var Remain1:String;
        public var Remain2:String;
        private var _beginDate:Date;
        private var _endDate:Date;
        private var _beginShowDate:Date;
        private var _endShowDate:Date;
        public var receiveNum:int;
        public var ActionTimeContent:String;


        public function get beginDate():Date
        {
            return (this._beginDate);
        }

        public function get beginShowDate():Date
        {
            return (this._beginShowDate);
        }

        public function get endShowDate():Date
        {
            return (this._endShowDate);
        }

        public function set BeginShowTime(_arg_1:String):void
        {
            this._BeginShowTime = _arg_1;
            this._beginShowDate = DateUtils.getDateByStr(_arg_1);
        }

        public function get endDate():Date
        {
            return (this._endDate);
        }

        public function set EndShowTime(_arg_1:String):void
        {
            this._EndShowTime = _arg_1;
            this._endShowDate = DateUtils.getDateByStr(_arg_1);
        }

        public function activeTime():String
        {
            var _local_1:String;
            if (this.ActionTimeContent)
            {
                _local_1 = this.ActionTimeContent;
            }
            else
            {
                if (this._EndShowTime)
                {
                    _local_1 = ((this.getActiveString(this.beginDate) + "-") + this.getActiveString(this.endDate));
                }
                else
                {
                    _local_1 = LanguageMgr.GetTranslation("tank.data.MovementInfo.begin", this.getActiveString(this.beginDate));
                };
            };
            return (_local_1);
        }

        private function getActiveString(_arg_1:Date):String
        {
            return (LanguageMgr.GetTranslation("tank.data.MovementInfo.date", this.addZero(_arg_1.getFullYear()), this.addZero((_arg_1.getMonth() + 1)), this.addZero(_arg_1.getDate())));
        }

        private function addZero(_arg_1:Number):String
        {
            var _local_2:String;
            if (_arg_1 < 10)
            {
                _local_2 = ("0" + _arg_1.toString());
            }
            else
            {
                _local_2 = _arg_1.toString();
            };
            return (_local_2);
        }

        public function overdue():Boolean
        {
            var _local_1:Date = TimeManager.Instance.Now();
            var _local_2:Number = _local_1.time;
            if (_local_2 < this.beginDate.getTime())
            {
                return (true);
            };
            if (this._EndShowTime)
            {
                if (_local_2 > this.endDate.getTime())
                {
                    return (true);
                };
            };
            return (false);
        }

        public function get BeginTime():String
        {
            return (this._BeginTime);
        }

        public function set BeginTime(_arg_1:String):void
        {
            this._BeginTime = _arg_1;
            this._beginDate = DateUtils.getDateByStr(_arg_1);
        }

        public function get EndTime():String
        {
            return (this._EndTime);
        }

        public function set EndTime(_arg_1:String):void
        {
            this._EndTime = _arg_1;
            this._endDate = DateUtils.getDateByStr(_arg_1);
        }

        public function get RewardDesc():String
        {
            if (this._RewardDesc == null)
            {
                this._RewardDesc = "";
            };
            return (this._RewardDesc);
        }

        public function set RewardDesc(_arg_1:String):void
        {
            this._RewardDesc = _arg_1;
        }


    }
}//package activity.data

