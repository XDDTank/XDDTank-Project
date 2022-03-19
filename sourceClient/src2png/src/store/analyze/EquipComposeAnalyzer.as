// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//store.analyze.EquipComposeAnalyzer

package store.analyze
{
    import com.pickgliss.loader.DataAnalyzer;
    import road7th.data.DictionaryData;
    import store.data.EquipComposeInfo;
    import com.pickgliss.utils.ObjectUtils;

    public class EquipComposeAnalyzer extends DataAnalyzer 
    {

        public var list:DictionaryData;
        private var _xml:XML;

        public function EquipComposeAnalyzer(_arg_1:Function)
        {
            super(_arg_1);
        }

        override public function analyze(_arg_1:*):void
        {
            var _local_3:int;
            var _local_4:EquipComposeInfo;
            var _local_5:String;
            var _local_6:Array;
            this._xml = new XML(_arg_1);
            var _local_2:XMLList = this._xml.item;
            if (this._xml.@value == "true")
            {
                this.list = new DictionaryData();
                _local_3 = 0;
                while (_local_3 < _local_2.length())
                {
                    _local_4 = new EquipComposeInfo();
                    if (Boolean(_local_2[_local_3].@TemplateIDs))
                    {
                        _local_5 = _local_2[_local_3].@TemplateIDs;
                        _local_6 = _local_5.split("|");
                        _local_4.TemplateID = _local_6[0];
                        _local_4.rate = _local_6[1];
                    };
                    ObjectUtils.copyPorpertiesByXML(_local_4, _local_2[_local_3]);
                    this.list.add(_local_4.TemplateID, _local_4);
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


    }
}//package store.analyze

