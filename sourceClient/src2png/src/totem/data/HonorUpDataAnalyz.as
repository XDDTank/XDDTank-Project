// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//totem.data.HonorUpDataAnalyz

package totem.data
{
    import com.pickgliss.loader.DataAnalyzer;

    public class HonorUpDataAnalyz extends DataAnalyzer 
    {

        private var _dataList:Array;

        public function HonorUpDataAnalyz(_arg_1:Function)
        {
            super(_arg_1);
        }

        override public function analyze(_arg_1:*):void
        {
            var _local_3:XMLList;
            var _local_4:int;
            var _local_5:HonorUpDataVo;
            var _local_2:XML = new XML(_arg_1);
            this._dataList = [];
            if (_local_2.@value == "true")
            {
                _local_3 = _local_2..item;
                _local_4 = 0;
                while (_local_4 < _local_3.length())
                {
                    _local_5 = new HonorUpDataVo();
                    _local_5.index = _local_3[_local_4].@ID;
                    _local_5.honor = _local_3[_local_4].@AddHonor;
                    _local_5.money = _local_3[_local_4].@NeedMoney;
                    this._dataList.push(_local_5);
                    _local_4++;
                };
                this._dataList.sortOn("index", Array.NUMERIC);
                onAnalyzeComplete();
            }
            else
            {
                message = _local_2.@message;
                onAnalyzeError();
                onAnalyzeError();
            };
        }

        public function get dataList():Array
        {
            return (this._dataList);
        }


    }
}//package totem.data

