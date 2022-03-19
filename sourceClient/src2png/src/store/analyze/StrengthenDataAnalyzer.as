// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//store.analyze.StrengthenDataAnalyzer

package store.analyze
{
    import com.pickgliss.loader.DataAnalyzer;
    import __AS3__.vec.Vector;
    import flash.utils.Dictionary;
    import __AS3__.vec.*;

    public class StrengthenDataAnalyzer extends DataAnalyzer 
    {

        public var _strengthData:Vector.<Dictionary>;
        private var _xml:XML;

        public function StrengthenDataAnalyzer(_arg_1:Function)
        {
            super(_arg_1);
        }

        override public function analyze(_arg_1:*):void
        {
            var _local_3:int;
            var _local_4:int;
            var _local_5:int;
            var _local_6:int;
            this._xml = new XML(_arg_1);
            this.initData();
            var _local_2:XMLList = this._xml.Item;
            if (this._xml.@value == "true")
            {
                _local_3 = 0;
                while (_local_3 < _local_2.length())
                {
                    _local_4 = int(_local_2[_local_3].@TemplateID);
                    _local_5 = int(_local_2[_local_3].@StrengthenLevel);
                    _local_6 = int(_local_2[_local_3].@Data);
                    this._strengthData[_local_5][_local_4] = _local_6;
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

        private function initData():void
        {
            var _local_2:Dictionary;
            this._strengthData = new Vector.<Dictionary>();
            var _local_1:int;
            while (_local_1 <= 12)
            {
                _local_2 = new Dictionary();
                this._strengthData.push(_local_2);
                _local_1++;
            };
        }


    }
}//package store.analyze

