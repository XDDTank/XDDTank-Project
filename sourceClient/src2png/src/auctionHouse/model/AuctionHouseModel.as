// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//auctionHouse.model.AuctionHouseModel

package auctionHouse.model
{
    import flash.events.EventDispatcher;
    import __AS3__.vec.Vector;
    import ddt.data.goods.CateCoryInfo;
    import road7th.data.DictionaryData;
    import auctionHouse.AuctionState;
    import flash.events.IEventDispatcher;
    import auctionHouse.event.AuctionHouseEvent;
    import ddt.data.auctionHouse.AuctionGoodsInfo;
    import __AS3__.vec.*;

    [Event(name="changeState", type="auctionHouse.event.AuctionHouseEvent")]
    [Event(name="getGoodCategory", type="auctionHouse.event.event.AuctionHouseEvent")]
    [Event(name="deleteAuction", type="auctionHouse.event.AuctionHouseEvent")]
    [Event(name="addAuction", type="auctionHouse.event.AuctionHouseEvent")]
    [Event(name="updatePage", type="auctionHouse.event.AuctionHouseEvent")]
    [Event(name="browseTypeChange", type="auctionHouse.event.AuctionHouseEvent")]
    public class AuctionHouseModel extends EventDispatcher 
    {

        public static var searchType:int;
        public static var SINGLE_PAGE_NUM:int = 20;
        public static var _dimBooble:Boolean;

        private var _state:String;
        private var _categorys:Vector.<CateCoryInfo> = new Vector.<CateCoryInfo>();
        private var _myAuctionData:DictionaryData;
        private var _sellTotal:int;
        private var _sellCurrent:int;
        private var _browseAuctionData:DictionaryData;
        private var _browseTotal:int;
        private var _browseCurrent:int = 1;
        private var _currentBrowseGoodInfo:CateCoryInfo;
        private var _buyAuctionData:DictionaryData;
        private var _buyTotal:int;
        private var _buyCurrent:int = 1;

        public function AuctionHouseModel(_arg_1:IEventDispatcher=null)
        {
            super(_arg_1);
            this._state = AuctionState.BROWSE;
            this._myAuctionData = new DictionaryData();
            this._browseAuctionData = new DictionaryData();
            this._buyAuctionData = new DictionaryData();
        }

        public function get state():String
        {
            return (this._state);
        }

        public function set state(_arg_1:String):void
        {
            this._state = _arg_1;
            dispatchEvent(new AuctionHouseEvent(AuctionHouseEvent.CHANGE_STATE));
        }

        public function get category():Vector.<CateCoryInfo>
        {
            return (this._categorys.slice(0));
        }

        public function set category(_arg_1:Vector.<CateCoryInfo>):void
        {
            this._categorys = _arg_1;
            if (_arg_1.length != 0)
            {
                dispatchEvent(new AuctionHouseEvent(AuctionHouseEvent.GET_GOOD_CATEGORY));
            };
        }

        public function getCatecoryById(_arg_1:int):CateCoryInfo
        {
            var _local_2:CateCoryInfo;
            for each (_local_2 in this._categorys)
            {
                if (_local_2.ID == _arg_1)
                {
                    return (_local_2);
                };
            };
            return (null);
        }

        public function get myAuctionData():DictionaryData
        {
            return (this._myAuctionData);
        }

        public function addMyAuction(_arg_1:AuctionGoodsInfo):void
        {
            if (this._state == AuctionState.SELL)
            {
                this._myAuctionData.add(_arg_1.AuctionID, _arg_1);
            }
            else
            {
                if (this._state == AuctionState.BROWSE)
                {
                    this._browseAuctionData.add(_arg_1.AuctionID, _arg_1);
                }
                else
                {
                    if (this._state == AuctionState.BUY)
                    {
                        this._buyAuctionData.add(_arg_1.AuctionID, _arg_1);
                    };
                };
            };
        }

        public function clearMyAuction():void
        {
            this._myAuctionData.clear();
        }

        public function removeMyAuction(_arg_1:AuctionGoodsInfo):void
        {
            if (this._state == AuctionState.SELL)
            {
                this._myAuctionData.remove(_arg_1.AuctionID);
            }
            else
            {
                if (this._state == AuctionState.BROWSE)
                {
                    this._browseAuctionData.remove(_arg_1.AuctionID);
                }
                else
                {
                    if (this._state == AuctionState.BUY)
                    {
                        this._buyAuctionData.remove(_arg_1.AuctionID);
                    };
                };
            };
        }

        public function set sellTotal(_arg_1:int):void
        {
            this._sellTotal = _arg_1;
            dispatchEvent(new AuctionHouseEvent(AuctionHouseEvent.UPDATE_PAGE));
        }

        public function get sellTotal():int
        {
            return (this._sellTotal);
        }

        public function get sellTotalPage():int
        {
            return (Math.ceil((this._sellTotal / SINGLE_PAGE_NUM)));
        }

        public function set sellCurrent(_arg_1:int):void
        {
            this._sellCurrent = _arg_1;
        }

        public function get sellCurrent():int
        {
            return (this._sellCurrent);
        }

        public function get browseAuctionData():DictionaryData
        {
            return (this._browseAuctionData);
        }

        public function addBrowseAuctionData(_arg_1:AuctionGoodsInfo):void
        {
            this._browseAuctionData.add(_arg_1.AuctionID, _arg_1);
        }

        public function clearBrowseAuctionData():void
        {
            this._browseAuctionData.clear();
        }

        public function removeBrowseAuctionData(_arg_1:AuctionGoodsInfo):void
        {
            this._browseAuctionData.remove(_arg_1.AuctionID);
        }

        public function set browseTotal(_arg_1:int):void
        {
            this._browseTotal = _arg_1;
            dispatchEvent(new AuctionHouseEvent(AuctionHouseEvent.UPDATE_PAGE));
        }

        public function get browseTotal():int
        {
            return (this._browseTotal);
        }

        public function get browseTotalPage():int
        {
            return (Math.ceil((this._browseTotal / SINGLE_PAGE_NUM)));
        }

        public function set browseCurrent(_arg_1:int):void
        {
            this._browseCurrent = _arg_1;
        }

        public function get browseCurrent():int
        {
            return (this._browseCurrent);
        }

        public function get currentBrowseGoodInfo():CateCoryInfo
        {
            return (this._currentBrowseGoodInfo);
        }

        public function set currentBrowseGoodInfo(_arg_1:CateCoryInfo):void
        {
            this._currentBrowseGoodInfo = _arg_1;
            this._browseCurrent = 1;
            dispatchEvent(new AuctionHouseEvent(AuctionHouseEvent.BROWSE_TYPE_CHANGE));
        }

        public function get buyAuctionData():DictionaryData
        {
            return (this._buyAuctionData);
        }

        public function addBuyAuctionData(_arg_1:AuctionGoodsInfo):void
        {
            this._buyAuctionData.add(_arg_1.AuctionID, _arg_1);
        }

        public function removeBuyAuctionData(_arg_1:AuctionGoodsInfo):void
        {
            this._buyAuctionData.remove(_arg_1);
        }

        public function clearBuyAuctionData():void
        {
            this._buyAuctionData.clear();
        }

        public function set buyTotal(_arg_1:int):void
        {
            this._buyTotal = _arg_1;
            dispatchEvent(new AuctionHouseEvent(AuctionHouseEvent.UPDATE_PAGE));
        }

        public function get buyTotal():int
        {
            return (this._buyTotal);
        }

        public function get buyTotalPage():int
        {
            return (Math.ceil((this._buyTotal / 50)));
        }

        public function set buyCurrent(_arg_1:int):void
        {
            this._buyCurrent = _arg_1;
        }

        public function get buyCurrent():int
        {
            return (this._buyCurrent);
        }

        public function dispose():void
        {
            this._categorys = new Vector.<CateCoryInfo>();
            if (this._myAuctionData)
            {
                this._myAuctionData.clear();
            };
            this._myAuctionData = null;
            if (this._browseAuctionData)
            {
                this._browseAuctionData.clear();
            };
            this._browseAuctionData = null;
            if (this._buyAuctionData)
            {
                this._buyAuctionData.clear();
            };
            this._buyAuctionData = null;
        }


    }
}//package auctionHouse.model

