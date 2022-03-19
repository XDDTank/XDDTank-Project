// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//consortion.analyze.ConsortiaShopListAnalyzer

package consortion.analyze
{
    import com.pickgliss.loader.DataAnalyzer;
    import __AS3__.vec.Vector;
    import consortion.data.ConsortionProbabilityInfo;
    import com.pickgliss.utils.ObjectUtils;
    import __AS3__.vec.*;

    public class ConsortiaShopListAnalyzer extends DataAnalyzer 
    {

        public var ProbabilityInfoList:Vector.<ConsortionProbabilityInfo>;

        public function ConsortiaShopListAnalyzer(_arg_1:Function)
        {
            super(_arg_1);
        }

        override public function analyze(_arg_1:*):void
        {
            var _local_3:XMLList;
            var _local_4:int;
            var _local_5:ConsortionProbabilityInfo;
            this.ProbabilityInfoList = new Vector.<ConsortionProbabilityInfo>();
            var _local_2:XML = new XML(_arg_1);
            if (_local_2.@value == "true")
            {
                _local_3 = XML(_local_2)..Item;
                _local_4 = 0;
                while (_local_4 < _local_3.length())
                {
                    _local_5 = new ConsortionProbabilityInfo();
                    ObjectUtils.copyPorpertiesByXML(_local_5, _local_3[_local_4]);
                    this.ProbabilityInfoList.push(_local_5);
                    _local_4++;
                };
                onAnalyzeComplete();
            }
            else
            {
                message = _local_2.@message;
                onAnalyzeError();
            };
        }


    }
}//package consortion.analyze

