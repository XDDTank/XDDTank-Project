// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.data.analyze.BeadDataAnalyzer

package ddt.data.analyze
{
    import com.pickgliss.loader.DataAnalyzer;
    import bead.model.BeadConfig;
    import com.pickgliss.utils.ObjectUtils;

    public class BeadDataAnalyzer extends DataAnalyzer 
    {

        private var _list:Object;
        private var _beadConfig:BeadConfig;

        public function BeadDataAnalyzer(_arg_1:Function)
        {
            super(_arg_1);
            this._beadConfig = new BeadConfig();
        }

        public function get list():Object
        {
            return (this._list);
        }

        public function get beadConfig():BeadConfig
        {
            return (this._beadConfig);
        }

        override public function analyze(_arg_1:*):void
        {
            var _local_3:XMLList;
            var _local_4:XMLList;
            var _local_5:int;
            var _local_6:int;
            var _local_7:Object;
            var _local_8:XMLList;
            var _local_9:Object;
            var _local_10:XML;
            this._list = {};
            var _local_2:XML = new XML(_arg_1);
            if (_local_2.@value == "true")
            {
                _local_3 = _local_2..Config;
                ObjectUtils.copyPorpertiesByXML(this._beadConfig, _local_3[0]);
                _local_4 = _local_2..Item;
                _local_5 = _local_4.length();
                _local_6 = 0;
                while (_local_6 < _local_5)
                {
                    if (this._list[_local_4[_local_6].@Type])
                    {
                        _local_7 = this._list[_local_4[_local_6].@Type];
                    }
                    else
                    {
                        _local_7 = {};
                        this._list[_local_4[_local_6].@Type] = _local_7;
                    };
                    _local_8 = (_local_4[_local_6] as XML).attributes();
                    _local_9 = {};
                    for each (_local_10 in _local_8)
                    {
                        _local_9[_local_10.name().toString()] = _local_10.toString();
                    };
                    _local_7[_local_4[_local_6].@Level] = _local_9;
                    _local_6++;
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

