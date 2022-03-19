// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.data.analyze.ComposeConfigListAnalyzer

package ddt.data.analyze
{
    import com.pickgliss.loader.DataAnalyzer;
    import road7th.data.DictionaryData;
    import ddt.data.goods.ComposeListInfo;
    import com.pickgliss.utils.ObjectUtils;

    public class ComposeConfigListAnalyzer extends DataAnalyzer 
    {

        private var _list:DictionaryData;

        public function ComposeConfigListAnalyzer(_arg_1:Function)
        {
            super(_arg_1);
        }

        override public function analyze(_arg_1:*):void
        {
            var _local_2:String;
            var _local_4:XMLList;
            var _local_5:int;
            var _local_6:ComposeListInfo;
            var _local_7:Array;
            this._list = new DictionaryData();
            var _local_3:XML = new XML(_arg_1);
            if (_local_3.@value == "true")
            {
                _local_4 = _local_3.item;
                _local_5 = 0;
                while (_local_5 < _local_4.length())
                {
                    _local_6 = new ComposeListInfo();
                    ObjectUtils.copyPorpertiesByXML(_local_6, _local_4[_local_5]);
                    if (Boolean(_local_3.item.@TemplateIDs))
                    {
                        _local_2 = _local_3.item[_local_5].@TemplateIDs;
                        if (_local_6.Type != 1)
                        {
                            _local_6.TemplateArray1 = _local_2.split(",");
                        }
                        else
                        {
                            _local_7 = _local_2.split("|");
                            if (_local_7[0])
                            {
                                _local_6.TemplateArray1 = _local_7[0].split(",");
                            };
                            if (_local_7[1])
                            {
                                _local_6.TemplateArray2 = _local_7[1].split(",");
                            };
                            if (_local_7[2])
                            {
                                _local_6.TemplateArray3 = _local_7[2].split(",");
                            };
                            if (_local_7[3])
                            {
                                _local_6.TemplateArray4 = _local_7[3].split(",");
                            };
                            if (_local_7[4])
                            {
                                _local_6.TemplateArray5 = _local_7[4].split(",");
                            };
                        };
                    };
                    this._list.add(_local_6.ID, _local_6);
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

