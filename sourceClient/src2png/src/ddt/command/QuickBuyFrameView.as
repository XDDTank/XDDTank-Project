// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.command.QuickBuyFrameView

package ddt.command
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import ddt.data.goods.ItemTemplateInfo;
    import ddt.data.goods.ShopItemInfo;
    import bagAndInfo.cell.BaseCell;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.ui.image.Image;
    import ddt.manager.LanguageMgr;
    import flash.events.Event;
    import ddt.data.EquipType;
    import ddt.manager.ShopManager;
    import ddt.manager.ItemManager;
    import ddt.manager.ServerConfigManager;
    import com.pickgliss.utils.ObjectUtils;

    public class QuickBuyFrameView extends Sprite implements Disposeable 
    {

        private var _number:NumberSelecter;
        private var _itemTemplateInfo:ItemTemplateInfo;
        private var _shopItem:ShopItemInfo;
        private var _cell:BaseCell;
        private var _totalTipText:FilterFrameText;
        private var totalText:FilterFrameText;
        public var _itemID:int;
        private var _stoneNumber:int = 1;
        private var _buyFrom:int;
        private var _price:int;
        private var _priceType:int = 0;

        public function QuickBuyFrameView()
        {
            this.initView();
            this.initEvents();
        }

        private function initView():void
        {
            var _local_1:Image = ComponentFactory.Instance.creatComponentByStylename("ddtcore.CellBg");
            addChild(_local_1);
            this._number = ComponentFactory.Instance.creatCustomObject("ddtcore.numberSelecter");
            addChild(this._number);
            var _local_2:Sprite = new Sprite();
            _local_2.addChild(ComponentFactory.Instance.creatBitmap("asset.ddtcore.EquipCellBG"));
            this._totalTipText = ComponentFactory.Instance.creatComponentByStylename("ddtcore.TotalTipsText");
            this._totalTipText.text = LanguageMgr.GetTranslation("ddt.QuickFrame.TotalTipText");
            addChild(this._totalTipText);
            this.totalText = ComponentFactory.Instance.creatComponentByStylename("ddtcore.TotalText");
            addChild(this.totalText);
            this._cell = new BaseCell(_local_2);
            this._cell.x = (_local_1.x + 4);
            this._cell.y = (_local_1.y + 4);
            addChild(this._cell);
            this._cell.tipDirctions = "7,0";
        }

        private function initEvents():void
        {
            this._number.addEventListener(Event.CHANGE, this.selectHandler);
            this._number.addEventListener(NumberSelecter.NUMBER_CLOSE, this._numberClose);
        }

        private function selectHandler(_arg_1:Event):void
        {
            this._stoneNumber = this._number.number;
            this.refreshNumText();
        }

        private function _numberClose(_arg_1:Event):void
        {
            dispatchEvent(_arg_1);
        }

        public function set ItemID(_arg_1:int):void
        {
            this._itemID = _arg_1;
            if (this._itemID == EquipType.STRENGTH_STONE4)
            {
                this._stoneNumber = 3;
            }
            else
            {
                this._stoneNumber = 1;
            };
            this._number.number = this._stoneNumber;
            this._shopItem = ShopManager.Instance.getMoneyShopItemByTemplateID(this._itemID);
            this.initInfo();
            this.refreshNumText();
        }

        public function set stoneNumber(_arg_1:int):void
        {
            this._stoneNumber = _arg_1;
            this._number.number = this._stoneNumber;
            this.refreshNumText();
        }

        public function get stoneNumber():int
        {
            return (this._stoneNumber);
        }

        public function get ItemID():int
        {
            return (this._itemID);
        }

        public function set maxLimit(_arg_1:int):void
        {
            this._number.maximum = _arg_1;
        }

        private function initInfo():void
        {
            this._itemTemplateInfo = ItemManager.Instance.getTemplateById(this._itemID);
            this._cell.info = this._itemTemplateInfo;
        }

        private function refreshNumText():void
        {
            if (this._itemID == EquipType.BOGU_COIN)
            {
                this.totalText.text = ((String((this._stoneNumber * this.price)) + " ") + LanguageMgr.GetTranslation("shop.RechargeView.TicketText"));
            }
            else
            {
                this.totalText.text = ((String((this._stoneNumber * this.price)) + " ") + LanguageMgr.GetTranslation(("tank.auctionHouse.view.AuctionBrowseView.stipple" + this._priceType)));
            };
        }

        public function set price(_arg_1:int):void
        {
            this._price = _arg_1;
        }

        public function get price():int
        {
            if (this._buyFrom == QuickBuyFrame.ACTIVITY)
            {
                return (this._price);
            };
            if (this._itemID == EquipType.BOGU_COIN)
            {
                return (ServerConfigManager.instance.getBoguCoinPrice());
            };
            return ((this._shopItem == null) ? 0 : this._shopItem.getItemPrice(1).moneyValue);
        }

        public function dispose():void
        {
            if (this._number)
            {
                this._number.removeEventListener(Event.CANCEL, this.selectHandler);
                this._number.removeEventListener(NumberSelecter.NUMBER_CLOSE, this._numberClose);
                ObjectUtils.disposeObject(this._number);
            };
            if (this._totalTipText)
            {
                ObjectUtils.disposeObject(this._totalTipText);
            };
            this._totalTipText = null;
            if (this.totalText)
            {
                ObjectUtils.disposeObject(this.totalText);
            };
            this.totalText = null;
            if (this._cell)
            {
                ObjectUtils.disposeObject(this._cell);
            };
            this._cell = null;
            this._number = null;
            this._itemTemplateInfo = null;
            this._shopItem = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }

        public function get buyFrom():int
        {
            return (this._buyFrom);
        }

        public function set buyFrom(_arg_1:int):void
        {
            this._buyFrom = _arg_1;
        }

        public function get priceType():int
        {
            return (this._priceType);
        }

        public function set priceType(_arg_1:int):void
        {
            this._priceType = _arg_1;
        }


    }
}//package ddt.command

