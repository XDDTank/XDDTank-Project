// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//store.view.strength.analyzer.ItemStrengthenGoodsInfoAnalyzer

package store.view.strength.analyzer
{
    import com.pickgliss.loader.DataAnalyzer;
    import flash.utils.Dictionary;
    import store.view.strength.vo.ItemStrengthenGoodsInfo;
    import com.pickgliss.utils.ObjectUtils;

    public class ItemStrengthenGoodsInfoAnalyzer extends DataAnalyzer 
    {

        public var list:Dictionary = new Dictionary();
        private var _xml:XML;

        public function ItemStrengthenGoodsInfoAnalyzer(_arg_1:Function)
        {
            super(_arg_1);
        }

        override public function analyze(_arg_1:*):void
        {
            var _local_3:int;
            var _local_4:ItemStrengthenGoodsInfo;
            this._xml = new XML(_arg_1);
            this.list = new Dictionary();
            var _local_2:XMLList = this._xml..Item;
            if (this._xml.@value == "true")
            {
                _local_3 = 0;
                while (_local_3 < _local_2.length())
                {
                    _local_4 = new ItemStrengthenGoodsInfo();
                    ObjectUtils.copyPorpertiesByXML(_local_4, _local_2[_local_3]);
                    this.list[((_local_4.CurrentEquip + ",") + _local_4.Level)] = _local_4;
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


    }
}//package store.view.strength.analyzer

