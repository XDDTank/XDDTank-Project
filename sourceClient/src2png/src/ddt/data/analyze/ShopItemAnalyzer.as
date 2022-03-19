// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.data.analyze.ShopItemAnalyzer

package ddt.data.analyze
{
    import com.pickgliss.loader.DataAnalyzer;
    import road7th.data.DictionaryData;
    import flash.utils.Timer;
    import flash.events.TimerEvent;
    import flash.events.Event;
    import ddt.data.goods.ShopItemInfo;
    import com.pickgliss.utils.ObjectUtils;

    public class ShopItemAnalyzer extends DataAnalyzer 
    {

        public var shopinfolist:DictionaryData;
        private var _xml:XML;
        private var _shoplist:XMLList;
        private var index:int = -1;
        private var _timer:Timer;

        public function ShopItemAnalyzer(_arg_1:Function)
        {
            super(_arg_1);
        }

        override public function analyze(_arg_1:*):void
        {
            this._xml = new XML(_arg_1);
            if (this._xml.@value == "true")
            {
                this.shopinfolist = new DictionaryData();
                this._shoplist = this._xml.Store..Item;
                this.parseShop(null);
            }
            else
            {
                message = this._xml.@message;
                onAnalyzeError();
            };
        }

        private function parseShop(_arg_1:Event):void
        {
            this._timer = new Timer(30);
            this._timer.addEventListener(TimerEvent.TIMER, this.__partexceute);
            this._timer.start();
        }

        private function __partexceute(_arg_1:TimerEvent):void
        {
            var _local_3:ShopItemInfo;
            var _local_2:int;
            while (_local_2 < 40)
            {
                this.index++;
                if (this.index < this._shoplist.length())
                {
                    _local_3 = new ShopItemInfo(int(this._shoplist[this.index].@ID), int(this._shoplist[this.index].@TemplateID));
                    ObjectUtils.copyPorpertiesByXML(_local_3, this._shoplist[this.index]);
                    this.shopinfolist.add(_local_3.GoodsID, _local_3);
                }
                else
                {
                    this._timer.removeEventListener(TimerEvent.TIMER, this.__partexceute);
                    this._timer.stop();
                    this._timer = null;
                    onAnalyzeComplete();
                    return;
                };
                _local_2++;
            };
        }


    }
}//package ddt.data.analyze

