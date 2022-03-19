// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.data.analyze.ItemTempleteAnalyzer

package ddt.data.analyze
{
    import com.pickgliss.loader.DataAnalyzer;
    import road7th.data.DictionaryData;
    import flash.utils.Timer;
    import flash.events.TimerEvent;
    import ddt.data.goods.ItemTemplateInfo;
    import com.pickgliss.utils.ObjectUtils;

    public class ItemTempleteAnalyzer extends DataAnalyzer 
    {

        public var list:DictionaryData = new DictionaryData();
        private var _xml:XML;
        private var _timer:Timer;
        private var _xmllist:XMLList;
        private var _index:int;

        public function ItemTempleteAnalyzer(_arg_1:Function)
        {
            super(_arg_1);
        }

        override public function analyze(_arg_1:*):void
        {
            this._xml = new XML(_arg_1);
            this.list = new DictionaryData();
            this.parseTemplate();
        }

        protected function parseTemplate():void
        {
            if (this._xml.@value == "true")
            {
                this._xmllist = this._xml.ItemTemplate..Item;
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
            var _local_3:ItemTemplateInfo;
            var _local_2:int;
            while (_local_2 < 40)
            {
                this._index++;
                if (this._index < this._xmllist.length())
                {
                    _local_3 = new ItemTemplateInfo();
                    ObjectUtils.copyPorpertiesByXML(_local_3, this._xmllist[this._index]);
                    this.list.add(_local_3.TemplateID, _local_3);
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

