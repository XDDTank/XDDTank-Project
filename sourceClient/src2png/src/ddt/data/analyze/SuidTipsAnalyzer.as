// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.data.analyze.SuidTipsAnalyzer

package ddt.data.analyze
{
    import com.pickgliss.loader.DataAnalyzer;
    import road7th.data.DictionaryData;
    import ddt.data.goods.SuidTipInfo;
    import com.pickgliss.utils.ObjectUtils;

    public class SuidTipsAnalyzer extends DataAnalyzer 
    {

        private var _list:DictionaryData;

        public function SuidTipsAnalyzer(_arg_1:Function)
        {
            super(_arg_1);
        }

        override public function analyze(_arg_1:*):void
        {
            var _local_3:XMLList;
            var _local_4:int;
            var _local_5:SuidTipInfo;
            this._list = new DictionaryData();
            var _local_2:XML = new XML(_arg_1);
            if (_local_2.@value == "true")
            {
                _local_3 = _local_2..item;
                _local_4 = 0;
                while (_local_4 < _local_3.length())
                {
                    _local_5 = new SuidTipInfo();
                    ObjectUtils.copyPorpertiesByXML(_local_5, _local_3[_local_4]);
                    this._list.add(_local_5.Level, _local_5);
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

        public function get list():DictionaryData
        {
            return (this._list);
        }


    }
}//package ddt.data.analyze

