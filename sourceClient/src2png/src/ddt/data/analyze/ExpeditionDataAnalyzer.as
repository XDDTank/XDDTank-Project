// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.data.analyze.ExpeditionDataAnalyzer

package ddt.data.analyze
{
    import com.pickgliss.loader.DataAnalyzer;
    import road7th.data.DictionaryData;
    import SingleDungeon.expedition.ExpeditionInfo;
    import com.pickgliss.utils.ObjectUtils;

    public class ExpeditionDataAnalyzer extends DataAnalyzer 
    {

        private var _list:DictionaryData;

        public function ExpeditionDataAnalyzer(_arg_1:Function)
        {
            super(_arg_1);
        }

        public function get list():DictionaryData
        {
            return (this._list);
        }

        override public function analyze(_arg_1:*):void
        {
            var _local_3:XMLList;
            var _local_4:int;
            var _local_5:int;
            var _local_6:ExpeditionInfo;
            this._list = new DictionaryData();
            var _local_2:XML = new XML(_arg_1);
            if (_local_2.@value == "true")
            {
                _local_3 = _local_2..Item;
                _local_4 = _local_3.length();
                _local_5 = 0;
                while (_local_5 < _local_3.length())
                {
                    _local_6 = new ExpeditionInfo();
                    ObjectUtils.copyPorpertiesByXML(_local_6, _local_3[_local_5]);
                    this._list.add(_local_6.SceneID, _local_6);
                    _local_5++;
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
}//package ddt.data.analyze

