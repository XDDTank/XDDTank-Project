// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.data.analyze.ServerConfigAnalyz

package ddt.data.analyze
{
    import com.pickgliss.loader.DataAnalyzer;
    import road7th.data.DictionaryData;
    import ddt.data.ServerConfigInfo;
    import com.pickgliss.utils.ObjectUtils;

    public class ServerConfigAnalyz extends DataAnalyzer 
    {

        public var serverConfigInfoList:DictionaryData;

        public function ServerConfigAnalyz(_arg_1:Function)
        {
            super(_arg_1);
        }

        override public function analyze(_arg_1:*):void
        {
            var _local_3:XMLList;
            var _local_4:int;
            var _local_5:ServerConfigInfo;
            this.serverConfigInfoList = new DictionaryData();
            var _local_2:XML = new XML(_arg_1);
            if (_local_2.@value == "true")
            {
                _local_3 = _local_2..Item;
                _local_4 = 0;
                while (_local_4 < _local_3.length())
                {
                    _local_5 = new ServerConfigInfo();
                    ObjectUtils.copyPorpertiesByXML(_local_5, _local_3[_local_4]);
                    this.serverConfigInfoList.add(_local_5.Name, _local_5);
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
            return (this.serverConfigInfoList);
        }


    }
}//package ddt.data.analyze

