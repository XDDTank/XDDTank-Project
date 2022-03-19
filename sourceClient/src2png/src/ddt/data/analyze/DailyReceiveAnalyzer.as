// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.data.analyze.DailyReceiveAnalyzer

package ddt.data.analyze
{
    import com.pickgliss.loader.DataAnalyzer;
    import ddt.data.DaylyGiveInfo;
    import com.pickgliss.utils.ObjectUtils;

    public class DailyReceiveAnalyzer extends DataAnalyzer 
    {

        private var _xml:XML;
        private var _awardDic:Array;

        public function DailyReceiveAnalyzer(_arg_1:Function)
        {
            super(_arg_1);
        }

        override public function analyze(_arg_1:*):void
        {
            var _local_2:XMLList;
            var _local_3:int;
            var _local_4:DaylyGiveInfo;
            this._xml = new XML(_arg_1);
            this._awardDic = new Array();
            if (this._xml.@value == "true")
            {
                _local_2 = this._xml..Item;
                _local_3 = 0;
                while (_local_3 < _local_2.length())
                {
                    _local_4 = new DaylyGiveInfo();
                    ObjectUtils.copyPorpertiesByXML(_local_4, _local_2[_local_3]);
                    this._awardDic.push(_local_4);
                    _local_3++;
                };
                onAnalyzeComplete();
            }
            else
            {
                message = this._xml.@message;
                onAnalyzeError();
                onAnalyzeComplete();
            };
        }

        public function get awardList():Array
        {
            return (this._awardDic);
        }


    }
}//package ddt.data.analyze

