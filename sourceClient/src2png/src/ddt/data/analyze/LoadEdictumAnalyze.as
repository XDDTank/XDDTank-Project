// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.data.analyze.LoadEdictumAnalyze

package ddt.data.analyze
{
    import com.pickgliss.loader.DataAnalyzer;
    import road7th.data.DictionaryData;

    public class LoadEdictumAnalyze extends DataAnalyzer 
    {

        public var edictumDataList:DictionaryData;

        public function LoadEdictumAnalyze(_arg_1:Function)
        {
            super(_arg_1);
        }

        override public function analyze(_arg_1:*):void
        {
            var _local_4:int;
            var _local_5:Object;
            this.edictumDataList = new DictionaryData();
            var _local_2:XML = new XML(_arg_1);
            var _local_3:XMLList = _local_2..Item;
            if (_local_2.@value == "true")
            {
                while (_local_4 < _local_3.length())
                {
                    _local_5 = new Object();
                    _local_5["id"] = _local_3[_local_4].@ID.toString();
                    _local_5["Title"] = _local_3[_local_4].@Title.toString();
                    _local_5["Text"] = _local_3[_local_4].@Text.toString();
                    _local_5["IsExist"] = _local_3[_local_4].@IsExist.toString();
                    this.edictumDataList[_local_5["id"]] = _local_5;
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
}//package ddt.data.analyze

