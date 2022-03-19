// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.data.analyze.EffortItemTemplateInfoAnalyzer

package ddt.data.analyze
{
    import com.pickgliss.loader.DataAnalyzer;
    import road7th.data.DictionaryData;
    import ddt.data.effort.EffortInfo;
    import ddt.data.effort.EffortQualificationInfo;
    import ddt.data.effort.EffortRewardInfo;

    public class EffortItemTemplateInfoAnalyzer extends DataAnalyzer 
    {

        private static const PATH:String = "AchievementList.xml";

        public var list:DictionaryData;

        public function EffortItemTemplateInfoAnalyzer(_arg_1:Function)
        {
            super(_arg_1);
        }

        override public function analyze(_arg_1:*):void
        {
            var _local_3:XMLList;
            var _local_4:int;
            var _local_5:XML;
            var _local_6:EffortInfo;
            var _local_7:XMLList;
            var _local_8:int;
            var _local_9:XMLList;
            var _local_10:int;
            var _local_11:EffortQualificationInfo;
            var _local_12:EffortRewardInfo;
            var _local_2:XML = new XML(_arg_1);
            this.list = new DictionaryData();
            if (_local_2.@value == "true")
            {
                _local_3 = _local_2..Item;
                _local_4 = 0;
                while (_local_4 < _local_3.length())
                {
                    _local_5 = _local_3[_local_4];
                    _local_6 = new EffortInfo();
                    _local_6.ID = _local_5.@ID;
                    _local_6.PlaceID = _local_5.@PlaceID;
                    _local_6.Title = _local_5.@Title;
                    _local_6.Detail = _local_5.@Detail;
                    _local_6.NeedMinLevel = _local_5.@NeedMinLevel;
                    _local_6.NeedMaxLevel = _local_5.@NeedMaxLevel;
                    _local_6.PreAchievementID = _local_5.@PreAchievementID;
                    _local_6.IsOther = this.getBoolean(_local_5.@IsOther);
                    _local_6.AchievementType = _local_5.@AchievementType;
                    _local_6.CanHide = this.getBoolean(_local_5.@CanHide);
                    _local_6.picId = _local_5.@PicID;
                    _local_6.StartDate = new Date(((((String(_local_5.@StartDate).substr(5, 2) + "/") + String(_local_5.@StartDate).substr(8, 2)) + "/") + String(_local_5.@StartDate).substr(0, 4)));
                    _local_6.EndDate = new Date(((((String(_local_5.@StartDate).substr(5, 2) + "/") + String(_local_5.@StartDate).substr(8, 2)) + "/") + String(_local_5.@StartDate).substr(0, 4)));
                    _local_6.AchievementPoint = _local_5.@AchievementPoint;
                    _local_7 = _local_5..Item_Condiction;
                    _local_8 = 0;
                    while (_local_8 < _local_7.length())
                    {
                        _local_11 = new EffortQualificationInfo();
                        _local_11.AchievementID = _local_7[_local_8].@AchievementID;
                        _local_11.CondictionID = _local_7[_local_8].@CondictionID;
                        _local_11.CondictionType = _local_7[_local_8].@CondictionType;
                        _local_11.Condiction_Para1 = _local_7[_local_8].@Condiction_Para1;
                        _local_11.Condiction_Para2 = _local_7[_local_8].@Condiction_Para2;
                        _local_6.addEffortQualification(_local_11);
                        _local_8++;
                    };
                    _local_9 = _local_5..Item_Reward;
                    _local_10 = 0;
                    while (_local_10 < _local_9.length())
                    {
                        _local_12 = new EffortRewardInfo();
                        _local_12.AchievementID = _local_9[_local_10].@AchievementID;
                        _local_12.RewardCount = _local_9[_local_10].@RewardCount;
                        _local_12.RewardPara = _local_9[_local_10].@RewardPara;
                        _local_12.RewardType = _local_9[_local_10].@RewardType;
                        _local_12.RewardValueId = _local_9[_local_10].@RewardValueId;
                        _local_6.addEffortReward(_local_12);
                        _local_10++;
                    };
                    this.list[_local_6.ID] = _local_6;
                    _local_4++;
                };
                onAnalyzeComplete();
            }
            else
            {
                message = _local_2.@message;
                onAnalyzeError();
                onAnalyzeComplete();
            };
        }

        private function getBoolean(_arg_1:String):Boolean
        {
            if (((_arg_1 == "true") || (_arg_1 == "1")))
            {
                return (true);
            };
            return (false);
        }


    }
}//package ddt.data.analyze

