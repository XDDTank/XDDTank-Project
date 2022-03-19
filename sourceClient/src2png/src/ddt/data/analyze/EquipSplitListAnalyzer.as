// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.data.analyze.EquipSplitListAnalyzer

package ddt.data.analyze
{
    import com.pickgliss.loader.DataAnalyzer;
    import road7th.data.DictionaryData;
    import ddt.data.goods.SpliteListInfo;
    import com.pickgliss.utils.ObjectUtils;

    public class EquipSplitListAnalyzer extends DataAnalyzer 
    {

        private var _list:DictionaryData;

        public function EquipSplitListAnalyzer(_arg_1:Function)
        {
            super(_arg_1);
        }

        override public function analyze(_arg_1:*):void
        {
            var _local_2:String;
            var _local_4:XMLList;
            var _local_5:int;
            var _local_6:SpliteListInfo;
            this._list = new DictionaryData();
            var _local_3:XML = new XML(_arg_1);
            if (_local_3.@value == "true")
            {
                _local_4 = _local_3.item;
                _local_5 = 0;
                while (_local_5 < _local_4.length())
                {
                    _local_6 = new SpliteListInfo();
                    ObjectUtils.copyPorpertiesByXML(_local_6, _local_4[_local_5]);
                    this._list.add(_local_6.TemplateID, _local_6);
                    _local_5++;
                };
                onAnalyzeComplete();
            }
            else
            {
                message = _local_3.@message;
                onAnalyzeError();
            };
        }

        public function get list():DictionaryData
        {
            return (this._list);
        }


    }
}//package ddt.data.analyze

