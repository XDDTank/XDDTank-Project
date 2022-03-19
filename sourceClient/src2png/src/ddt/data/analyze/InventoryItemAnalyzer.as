// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.data.analyze.InventoryItemAnalyzer

package ddt.data.analyze
{
    import com.pickgliss.loader.DataAnalyzer;
    import __AS3__.vec.Vector;
    import ddt.data.goods.InventoryItemInfo;
    import flash.utils.Timer;
    import flash.events.TimerEvent;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.manager.ItemManager;
    import __AS3__.vec.*;

    public class InventoryItemAnalyzer extends DataAnalyzer 
    {

        public var list:Vector.<InventoryItemInfo> = new Vector.<InventoryItemInfo>();
        private var _xml:XML;
        private var _timer:Timer;
        private var _xmllist:XMLList;
        private var _index:int;

        public function InventoryItemAnalyzer(_arg_1:Function)
        {
            super(_arg_1);
        }

        override public function analyze(_arg_1:*):void
        {
            this._xml = new XML(_arg_1);
            this.list = new Vector.<InventoryItemInfo>();
            this.parseTemplate();
        }

        protected function parseTemplate():void
        {
            if (this._xml.@value == "true")
            {
                this._xmllist = this._xml..Item;
                this._index = -1;
                this._timer = new Timer(30);
                this._timer.addEventListener(TimerEvent.TIMER, this.__partexceute);
                this._timer.start();
            }
            else
            {
                message = this._xml.@message;
                onAnalyzeError();
            };
        }

        private function __partexceute(_arg_1:TimerEvent):void
        {
            var _local_3:InventoryItemInfo;
            var _local_2:int;
            while (_local_2 < 40)
            {
                this._index++;
                if (this._index < this._xmllist.length())
                {
                    _local_3 = new InventoryItemInfo();
                    ObjectUtils.copyPorpertiesByXML(_local_3, this._xmllist[this._index]);
                    ItemManager.fill(_local_3);
                    this.list.push(_local_3);
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

