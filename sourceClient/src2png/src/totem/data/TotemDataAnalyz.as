// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//totem.data.TotemDataAnalyz

package totem.data
{
    import com.pickgliss.loader.DataAnalyzer;
    import com.pickgliss.utils.ObjectUtils;

    public class TotemDataAnalyz extends DataAnalyzer 
    {

        private var _dataList:Object;
        private var _dataList2:Object;

        public function TotemDataAnalyz(_arg_1:Function)
        {
            super(_arg_1);
        }

        override public function analyze(_arg_1:*):void
        {
            var _local_3:XMLList;
            var _local_4:int;
            var _local_5:TotemDataVo;
            this._dataList = {};
            this._dataList2 = {};
            var _local_2:XML = new XML(_arg_1);
            if (_local_2.@value == "true")
            {
                _local_3 = _local_2..item;
                _local_4 = 0;
                while (_local_4 < _local_3.length())
                {
                    _local_5 = new TotemDataVo();
                    ObjectUtils.copyPorpertiesByXML(_local_5, _local_3[_local_4]);
                    this._dataList[_local_5.ID] = _local_5;
                    this._dataList2[_local_5.Point] = _local_5;
                    _local_4++;
                };
                onAnalyzeComplete();
            }
            else
            {
                message = _local_2.@message;
                onAnalyzeError();
                onAnalyzeError();
            };
        }

        public function get dataList():Object
        {
            return (this._dataList);
        }

        public function get dataList2():Object
        {
            return (this._dataList2);
        }


    }
}//package totem.data

