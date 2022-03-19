// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.data.auctionHouse.AuctionGoodsInfo

package ddt.data.auctionHouse
{
    import ddt.data.goods.InventoryItemInfo;
    import road7th.utils.DateUtils;
    import ddt.manager.TimeManager;
    import ddt.manager.LanguageMgr;

    public class AuctionGoodsInfo 
    {

        public var index:int;
        public var AuctionID:int;
        public var AuctioneerID:int;
        public var AuctioneerName:String;
        public var ItemID:int;
        public var BagItemInfo:InventoryItemInfo;
        public var PayType:int;
        public var Price:int;
        public var Rise:int;
        public var Mouthful:int;
        private var _BeginDate:String;
        private var _beginDateObj:Date;
        public var ValidDate:int;
        public var BuyerID:int;
        public var BuyerName:String;


        public function set BeginDate(_arg_1:String):void
        {
            this._BeginDate = _arg_1;
        }

        public function get BeginDate():String
        {
            return (this._BeginDate);
        }

        public function get beginDateObj():Date
        {
            return ((this._beginDateObj == null) ? DateUtils.getDateByStr(this.BeginDate) : this._beginDateObj);
        }

        public function set beginDateObj(_arg_1:Date):void
        {
            this._beginDateObj = _arg_1;
        }

        public function getTimeDescription():String
        {
            var _local_1:String = "";
            var _local_2:Date = new Date();
            _local_2.setTime(this.beginDateObj.getTime());
            _local_2.hours = (this.ValidDate + _local_2.hours);
            var _local_3:int = Math.abs(TimeManager.Instance.TotalHoursToNow(_local_2));
            if (_local_3 <= 1.5)
            {
                _local_1 = LanguageMgr.GetTranslation("tank.data.auctionHouse.AuctionGoodsInfo.short");
            }
            else
            {
                if (_local_3 <= 3)
                {
                    _local_1 = LanguageMgr.GetTranslation("tank.data.auctionHouse.AuctionGoodsInfo.middle");
                }
                else
                {
                    if (_local_3 <= 13)
                    {
                        _local_1 = LanguageMgr.GetTranslation("tank.data.auctionHouse.AuctionGoodsInfo.long");
                    }
                    else
                    {
                        _local_1 = LanguageMgr.GetTranslation("tank.data.auctionHouse.AuctionGoodsInfo.very");
                    };
                };
            };
            _local_2 = null;
            return (_local_1);
        }

        public function getSithTimeDescription():String
        {
            var _local_1:String = "";
            var _local_2:Date = new Date();
            _local_2.setTime(this.beginDateObj.getTime());
            _local_2.hours = (this.ValidDate + _local_2.hours);
            var _local_3:int = Math.abs(TimeManager.Instance.TotalHoursToNow(_local_2));
            if (_local_3 <= 1.5)
            {
                _local_1 = LanguageMgr.GetTranslation("tank.data.auctionHouse.AuctionGoodsInfo.tshort");
            }
            else
            {
                if (_local_3 <= 3)
                {
                    _local_1 = LanguageMgr.GetTranslation("tank.data.auctionHouse.AuctionGoodsInfo.tmiddle");
                }
                else
                {
                    if (_local_3 <= 13)
                    {
                        _local_1 = LanguageMgr.GetTranslation("tank.data.auctionHouse.AuctionGoodsInfo.tlong");
                    }
                    else
                    {
                        _local_1 = LanguageMgr.GetTranslation("tank.data.auctionHouse.AuctionGoodsInfo.tvery");
                    };
                };
            };
            _local_2 = null;
            return (_local_1);
        }


    }
}//package ddt.data.auctionHouse

