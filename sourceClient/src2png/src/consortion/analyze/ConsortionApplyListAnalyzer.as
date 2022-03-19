// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//consortion.analyze.ConsortionApplyListAnalyzer

package consortion.analyze
{
    import com.pickgliss.loader.DataAnalyzer;
    import __AS3__.vec.Vector;
    import consortion.data.ConsortiaApplyInfo;
    import com.pickgliss.utils.ObjectUtils;
    import __AS3__.vec.*;

    public class ConsortionApplyListAnalyzer extends DataAnalyzer 
    {

        public var applyList:Vector.<ConsortiaApplyInfo>;
        public var totalCount:int;

        public function ConsortionApplyListAnalyzer(_arg_1:Function)
        {
            super(_arg_1);
        }

        override public function analyze(_arg_1:*):void
        {
            var _local_3:XMLList;
            var _local_4:int;
            var _local_5:ConsortiaApplyInfo;
            this.applyList = new Vector.<ConsortiaApplyInfo>();
            var _local_2:XML = new XML(_arg_1);
            if (_local_2.@value == "true")
            {
                this.totalCount = int(_local_2.@total);
                _local_3 = XML(_local_2)..Item;
                _local_4 = 0;
                while (_local_4 < _local_3.length())
                {
                    _local_5 = new ConsortiaApplyInfo();
                    ObjectUtils.copyPorpertiesByXML(_local_5, _local_3[_local_4]);
                    _local_5.IsOld = (int(_local_3[_local_4].@OldPlayer) == 1);
                    this.applyList.push(_local_5);
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
}//package consortion.analyze

