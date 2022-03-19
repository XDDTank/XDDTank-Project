// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//consortion.analyze.ConsortionListAnalyzer

package consortion.analyze
{
    import com.pickgliss.loader.DataAnalyzer;
    import __AS3__.vec.Vector;
    import ddt.data.ConsortiaInfo;
    import com.pickgliss.utils.ObjectUtils;
    import __AS3__.vec.*;

    public class ConsortionListAnalyzer extends DataAnalyzer 
    {

        public var consortionList:Vector.<ConsortiaInfo>;
        public var consortionsTotalCount:int;

        public function ConsortionListAnalyzer(_arg_1:Function)
        {
            super(_arg_1);
        }

        override public function analyze(_arg_1:*):void
        {
            var _local_3:XMLList;
            var _local_4:int;
            var _local_5:ConsortiaInfo;
            this.consortionList = new Vector.<ConsortiaInfo>();
            var _local_2:XML = new XML(_arg_1);
            if (_local_2.@value == "true")
            {
                this.consortionsTotalCount = Math.ceil((int(_local_2.@total) / 12));
                _local_3 = _local_2..Item;
                _local_4 = 0;
                while (_local_4 < _local_3.length())
                {
                    _local_5 = new ConsortiaInfo();
                    _local_5.beginChanges();
                    ObjectUtils.copyPorpertiesByXML(_local_5, _local_3[_local_4]);
                    _local_5.Number = (_local_4 + 1);
                    _local_5.commitChanges();
                    this.consortionList.push(_local_5);
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

