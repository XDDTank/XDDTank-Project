// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//store.analyze.RefiningAnayzer

package store.analyze
{
    import com.pickgliss.loader.DataAnalyzer;
    import road7th.data.DictionaryData;
    import store.data.RefiningConfigInfo;
    import com.pickgliss.utils.ObjectUtils;

    public class RefiningAnayzer extends DataAnalyzer 
    {

        public var list:DictionaryData;
        private var _xml:XML;

        public function RefiningAnayzer(_arg_1:Function)
        {
            super(_arg_1);
        }

        override public function analyze(_arg_1:*):void
        {
            var _local_3:RefiningConfigInfo;
            var _local_4:int;
            this._xml = new XML(_arg_1);
            var _local_2:XMLList = this._xml.Item;
            if (this._xml.@value == "true")
            {
                this.list = new DictionaryData();
                _local_4 = 0;
                while (_local_4 < _local_2.length())
                {
                    _local_3 = new RefiningConfigInfo();
                    ObjectUtils.copyPorpertiesByXML(_local_3, _local_2[_local_4]);
                    this.list.add(_local_3.Level, _local_3);
                    _local_4++;
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

