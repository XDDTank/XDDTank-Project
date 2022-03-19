// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//vip.analyze.PlayerVIPLevleInfoAnalyzer

package vip.analyze
{
    import com.pickgliss.loader.DataAnalyzer;
    import vip.data.VipModelInfo;
    import flash.utils.Dictionary;

    public class PlayerVIPLevleInfoAnalyzer extends DataAnalyzer 
    {

        public var info:VipModelInfo;

        public function PlayerVIPLevleInfoAnalyzer(_arg_1:Function)
        {
            super(_arg_1);
        }

        override public function analyze(_arg_1:*):void
        {
            var _local_2:XML;
            var _local_3:XMLList;
            var _local_4:int;
            var _local_5:Dictionary;
            this.info = new VipModelInfo();
            _local_2 = new XML(_arg_1);
            if (_local_2.@value == "true")
            {
                this.info.maxExp = _local_2.@maxExp;
                this.info.ExpForEachDay = _local_2.@ExpForEachDay;
                this.info.ExpDecreaseForEachDay = _local_2.@ExpDecreaseForEachDay;
                this.info.upRuleDescription = _local_2.@Description;
                this.info.RewardDescription = _local_2.@RewardInfo;
                _local_3 = _local_2..Levels;
                _local_4 = 0;
                while (_local_4 < _local_3.length())
                {
                    _local_5 = new Dictionary();
                    _local_5["level"] = _local_3[_local_4].@Level;
                    _local_5["ExpNeeded"] = _local_3[_local_4].@ExpNeeded;
                    _local_5["Description"] = _local_3[_local_4].@Description;
                    this.info.levelInfo[_local_4] = _local_5;
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


    }
}//package vip.analyze

