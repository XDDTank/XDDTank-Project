// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.data.analyze.DailyLeagueLevelAnalyzer

package ddt.data.analyze
{
    import com.pickgliss.loader.DataAnalyzer;
    import ddt.data.DailyLeagueLevelInfo;
    import com.pickgliss.utils.ObjectUtils;

    public class DailyLeagueLevelAnalyzer extends DataAnalyzer 
    {

        public var list:Array;

        public function DailyLeagueLevelAnalyzer(_arg_1:Function)
        {
            super(_arg_1);
        }

        override public function analyze(_arg_1:*):void
        {
            var _local_3:XMLList;
            var _local_4:int;
            var _local_5:DailyLeagueLevelInfo;
            var _local_2:XML = new XML(_arg_1);
            this.list = new Array();
            if (_local_2.@value == "true")
            {
                _local_3 = _local_2..item;
                _local_4 = 0;
                while (_local_4 < _local_3.length())
                {
                    _local_5 = new DailyLeagueLevelInfo();
                    ObjectUtils.copyPorpertiesByXML(_local_5, _local_3[_local_4]);
                    this.list.push(_local_5);
                    _local_4++;
                };
                this.list.sortOn("Score", Array.NUMERIC);
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
}//package ddt.data.analyze

