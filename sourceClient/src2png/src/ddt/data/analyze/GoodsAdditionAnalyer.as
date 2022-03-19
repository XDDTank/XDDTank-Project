// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.data.analyze.GoodsAdditionAnalyer

package ddt.data.analyze
{
    import com.pickgliss.loader.DataAnalyzer;

    public class GoodsAdditionAnalyer extends DataAnalyzer 
    {

        private var _xml:XML;
        private var _additionArr:Array;

        public function GoodsAdditionAnalyer(_arg_1:Function)
        {
            super(_arg_1);
        }

        override public function analyze(_arg_1:*):void
        {
            var _local_3:int;
            var _local_4:Object;
            this._additionArr = new Array();
            this._xml = new XML(_arg_1);
            var _local_2:XMLList = this._xml.Item;
            if (this._xml.@value == "true")
            {
                _local_3 = 0;
                while (_local_3 < _local_2.length())
                {
                    _local_4 = new Object();
                    _local_4.ItemCatalog = int(_local_2[_local_3].@ItemCatalog);
                    _local_4.SubCatalog = int(_local_2[_local_3].@SubCatalog);
                    _local_4.StrengthenLevel = int(_local_2[_local_3].@StrengthenLevel);
                    _local_4.FailtureTimes = int(_local_2[_local_3].@FailtureTimes);
                    _local_4.PropertyPlus = int(_local_2[_local_3].@PropertyPlus);
                    _local_4.SuccessRatePlus = int(_local_2[_local_3].@SuccessRatePlus);
                    this._additionArr.push(_local_4);
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

        public function get additionArr():Array
        {
            return (this._additionArr);
        }


    }
}//package ddt.data.analyze

