// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//auctionHouse.analyze.AuctionAnalyzer

package auctionHouse.analyze
{
    import com.pickgliss.loader.DataAnalyzer;
    import __AS3__.vec.Vector;
    import ddt.data.auctionHouse.AuctionGoodsInfo;
    import ddt.data.goods.InventoryItemInfo;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.manager.ItemManager;
    import __AS3__.vec.*;

    public class AuctionAnalyzer extends DataAnalyzer 
    {

        public var list:Vector.<AuctionGoodsInfo>;
        public var total:int;

        public function AuctionAnalyzer(_arg_1:Function)
        {
            super(_arg_1);
        }

        override public function analyze(_arg_1:*):void
        {
            var _local_4:int;
            var _local_5:AuctionGoodsInfo;
            var _local_6:XMLList;
            var _local_7:InventoryItemInfo;
            this.list = new Vector.<AuctionGoodsInfo>();
            var _local_2:XML = new XML(_arg_1);
            var _local_3:XMLList = _local_2.Item;
            this.total = _local_2.@total;
            if (_local_2.@value == "true")
            {
                _local_4 = 0;
                while (_local_4 < _local_3.length())
                {
                    _local_5 = new AuctionGoodsInfo();
                    ObjectUtils.copyPorpertiesByXML(_local_5, _local_3[_local_4]);
                    _local_6 = _local_3[_local_4].Item;
                    if (_local_6.length() > 0)
                    {
                        _local_7 = new InventoryItemInfo();
                        ObjectUtils.copyPorpertiesByXML(_local_7, _local_6[0]);
                        ItemManager.fill(_local_7);
                        _local_5.BagItemInfo = _local_7;
                        this.list.push(_local_5);
                    };
                    _local_4++;
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
}//package auctionHouse.analyze

