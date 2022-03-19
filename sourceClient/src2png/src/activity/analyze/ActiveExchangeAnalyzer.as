// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//activity.analyze.ActiveExchangeAnalyzer

package activity.analyze
{
    import com.pickgliss.loader.DataAnalyzer;
    import activity.view.goodsExchange.GoodsExchangeInfo;
    import com.pickgliss.utils.ObjectUtils;

    public class ActiveExchangeAnalyzer extends DataAnalyzer 
    {

        private var _list:Array;
        private var _xml:XML;

        public function ActiveExchangeAnalyzer(_arg_1:Function)
        {
            super(_arg_1);
        }

        override public function analyze(_arg_1:*):void
        {
            var _local_3:int;
            var _local_4:GoodsExchangeInfo;
            this._xml = new XML(_arg_1);
            this._list = new Array();
            var _local_2:XMLList = this._xml..Item;
            if (this._xml.@value == "true")
            {
                _local_3 = 0;
                while (_local_3 < _local_2.length())
                {
                    _local_4 = new GoodsExchangeInfo();
                    ObjectUtils.copyPorpertiesByXML(_local_4, _local_2[_local_3]);
                    this._list.push(_local_4);
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

        public function get list():Array
        {
            return (this._list.slice(0));
        }


    }
}//package activity.analyze

