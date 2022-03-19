// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//consortion.data.ConsortionSkillInfo

package consortion.data
{
    import ddt.manager.TimeManager;
    import ddt.manager.LanguageMgr;

    public class ConsortionSkillInfo 
    {

        public var id:int;
        public var type:int;
        public var descript:String;
        public var value:int;
        public var level:int;
        public var riches:int;
        public var name:String;
        public var pic:int;
        public var group:int;
        public var metal:int;
        public var isOpen:Boolean;
        public var beginDate:Date;
        public var validDate:int;


        public function get validity():String
        {
            var _local_1:int = TimeManager.Instance.TotalDaysToNow(this.beginDate);
            var _local_2:int = (this.validDate - _local_1);
            if (_local_2 <= 1)
            {
                _local_2 = ((this.validDate * 24) - TimeManager.Instance.TotalHoursToNow(this.beginDate));
                if (_local_2 < 1)
                {
                    return (int((((this.validDate * 24) * 60) - TimeManager.Instance.TotalMinuteToNow(this.beginDate))) + LanguageMgr.GetTranslation("minute"));
                };
                return (int(((this.validDate * 24) - TimeManager.Instance.TotalHoursToNow(this.beginDate))) + LanguageMgr.GetTranslation("hours"));
            };
            return (_local_2 + LanguageMgr.GetTranslation("shop.ShopIIShoppingCarItem.day"));
        }


    }
}//package consortion.data

