// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.data.analyze.EquipStrengthListAnalyzer

package ddt.data.analyze
{
    import com.pickgliss.loader.DataAnalyzer;
    import road7th.data.DictionaryData;
    import ddt.data.goods.EquipStrengthInfo;
    import com.pickgliss.utils.ObjectUtils;

    public class EquipStrengthListAnalyzer extends DataAnalyzer 
    {

        private var _list:DictionaryData;

        public function EquipStrengthListAnalyzer(_arg_1:Function)
        {
            super(_arg_1);
        }

        override public function analyze(_arg_1:*):void
        {
            var _local_3:XMLList;
            var _local_4:int;
            var _local_5:EquipStrengthInfo;
            var _local_6:String;
            this._list = new DictionaryData();
            var _local_2:XML = new XML(_arg_1);
            if (_local_2.@value == "true")
            {
                _local_3 = _local_2.item;
                _local_4 = 0;
                while (_local_4 < _local_3.length())
                {
                    _local_5 = new EquipStrengthInfo();
                    ObjectUtils.copyPorpertiesByXML(_local_5, _local_3[_local_4]);
                    _local_6 = (_local_5.Level.toString() + _local_5.Quality.toString());
                    this._list.add(_local_6, _local_5);
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

