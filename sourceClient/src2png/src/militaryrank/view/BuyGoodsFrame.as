// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//militaryrank.view.BuyGoodsFrame

package militaryrank.view
{
    import com.pickgliss.ui.controls.Frame;
    import com.pickgliss.ui.image.Image;
    import ddt.command.NumberSelecter;
    import ddt.data.goods.ItemTemplateInfo;
    import com.pickgliss.ui.controls.TextButton;
    import ddt.data.goods.ShopItemInfo;
    import bagAndInfo.cell.BaseCell;
    import __AS3__.vec.Vector;
    import com.pickgliss.ui.text.FilterFrameText;
    import flash.display.MovieClip;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.LanguageMgr;
    import flash.display.Sprite;
    import ddt.utils.PositionUtils;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import militaryrank.MilitaryRankManager;
    import ddt.manager.MessageTipManager;
    import com.pickgliss.events.FrameEvent;
    import ddt.manager.ItemManager;
    import ddt.data.goods.Price;
    import ddt.manager.PlayerManager;
    import com.pickgliss.utils.ObjectUtils;
    import __AS3__.vec.*;

    public class BuyGoodsFrame extends Frame 
    {

        private var _bg:Image;
        private var _number:NumberSelecter;
        private var _itemTemplateInfo:ItemTemplateInfo;
        private var _submitButton:TextButton;
        private var _shopItem:ShopItemInfo;
        private var _cell:BaseCell;
        public var _itemID:int;
        private var _goodCount:int = 1;
        private var _priceTxtList:Vector.<FilterFrameText>;
        private var _payTypeList:Vector.<MovieClip>;
        private var _totalTipText:FilterFrameText;

        public function BuyGoodsFrame()
        {
            this.initView();
            this.initEvent();
        }

        public function set ItemID(_arg_1:int):void
        {
            this._itemID = _arg_1;
            this._goodCount = 1;
            this._number.number = this._goodCount;
            this.initInfo();
            this.refreshNumText();
        }

        public function get goodCount():int
        {
            return (this._goodCount);
        }

        public function set shopItem(_arg_1:ShopItemInfo):void
        {
            this._shopItem = _arg_1;
            this.ItemID = this._shopItem.TemplateID;
        }

        public function show():void
        {
            LayerManager.Instance.addToLayer(this, LayerManager.GAME_TOP_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
        }

        private function initView():void
        {
            var _local_2:int;
            escEnable = true;
            enterEnable = true;
            this._submitButton = ComponentFactory.Instance.creatComponentByStylename("ddtcore.quickEnter");
            this._submitButton.text = LanguageMgr.GetTranslation("store.view.shortcutBuy.buyBtn");
            addToContent(this._submitButton);
            this._bg = ComponentFactory.Instance.creatComponentByStylename("ddtcore.CellBg");
            addToContent(this._bg);
            this._number = ComponentFactory.Instance.creatCustomObject("ddtcore.numberSelecter");
            addToContent(this._number);
            var _local_1:Sprite = new Sprite();
            _local_1.addChild(ComponentFactory.Instance.creatBitmap("asset.ddtcore.EquipCellBG"));
            this._cell = new BaseCell(_local_1);
            this._cell.x = (this._bg.x + 4);
            this._cell.y = (this._bg.y + 4);
            addToContent(this._cell);
            this._cell.tipDirctions = "7,0";
            this._priceTxtList = new Vector.<FilterFrameText>(2);
            this._priceTxtList[0] = ComponentFactory.Instance.creat("militaryrank.buyGoodsFrame.exploitTxt");
            this._priceTxtList[1] = ComponentFactory.Instance.creatComponentByStylename("militaryrank.buyGoodsFrame.moneyTxt");
            addToContent(this._priceTxtList[0]);
            addToContent(this._priceTxtList[1]);
            this._payTypeList = new Vector.<MovieClip>(2);
            _local_2 = 0;
            while (_local_2 < 2)
            {
                this._payTypeList[_local_2] = ComponentFactory.Instance.creat(("militaryrank.buygoodsframe.moneyIcon" + (_local_2 + 1)));
                this._payTypeList[_local_2].mouseChildren = false;
                this._payTypeList[_local_2].mouseEnabled = false;
                addToContent(this._payTypeList[_local_2]);
                _local_2++;
            };
            this._totalTipText = ComponentFactory.Instance.creatComponentByStylename("ddtcore.TotalTipsText");
            PositionUtils.setPos(this._totalTipText, "militaryrank.buygoodsframe.TotalTipsTextPos");
            this._totalTipText.text = LanguageMgr.GetTranslation("ddt.QuickFrame.TotalTipText");
            addToContent(this._totalTipText);
        }

        private function initEvent():void
        {
            this._number.addEventListener(Event.CHANGE, this.__selectHandler);
            this._number.addEventListener(NumberSelecter.NUMBER_CLOSE, this.__numberClose);
            this._submitButton.addEventListener(MouseEvent.CLICK, this.__submit);
        }

        private function __selectHandler(_arg_1:Event):void
        {
            this._goodCount = this._number.number;
            if (((this._goodCount > MilitaryRankManager.Instance.getRankShopItemCount(this._shopItem.ID)) && (MilitaryRankManager.Instance.getRankShopItemCount(this._shopItem.ID) > -1000)))
            {
                this._goodCount = MilitaryRankManager.Instance.getRankShopItemCount(this._shopItem.ID);
                this._number.number = this._goodCount;
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("militaryrank.shop.countLimit", this._goodCount));
            };
            this.refreshNumText();
        }

        private function __numberClose(_arg_1:Event):void
        {
            dispatchEvent(_arg_1);
        }

        private function __submit(_arg_1:MouseEvent):void
        {
            dispatchEvent(new FrameEvent(FrameEvent.SUBMIT_CLICK));
        }

        private function initInfo():void
        {
            this._itemTemplateInfo = ItemManager.Instance.getTemplateById(this._itemID);
            this._cell.info = this._itemTemplateInfo;
        }

        private function refreshNumText():void
        {
            var _local_2:Price;
            var _local_1:int;
            while (_local_1 < 2)
            {
                _local_2 = this._shopItem.getItemPrice(0).getPrice(_local_1);
                this._payTypeList[_local_1].gotoAndStop(-(_local_2.Unit));
                if (PlayerManager.Instance.Self.getMoneyByType(_local_2.Unit) < (_local_2.Value * this._goodCount))
                {
                    this._priceTxtList[_local_1].htmlText = LanguageMgr.GetTranslation("redTxt", (_local_2.Value * this._goodCount));
                }
                else
                {
                    this._priceTxtList[_local_1].htmlText = String((_local_2.Value * this._goodCount));
                };
                this._payTypeList[_local_1].visible = (this._priceTxtList[_local_1].visible = (!(_local_2.Value == 0)));
                _local_1++;
            };
        }

        override public function dispose():void
        {
            if (this._number)
            {
                this._number.removeEventListener(Event.CANCEL, this.__selectHandler);
                this._number.removeEventListener(NumberSelecter.NUMBER_CLOSE, this.__numberClose);
                ObjectUtils.disposeObject(this._number);
            };
            this._submitButton.removeEventListener(MouseEvent.CLICK, this.__submit);
            ObjectUtils.disposeObject(this._bg);
            this._bg = null;
            ObjectUtils.disposeObject(this._priceTxtList[0]);
            this._priceTxtList[0] = null;
            ObjectUtils.disposeObject(this._priceTxtList[1]);
            this._priceTxtList[1] = null;
            this._priceTxtList.length = 0;
            this._priceTxtList = null;
            ObjectUtils.disposeObject(this._submitButton);
            this._submitButton = null;
            ObjectUtils.disposeObject(this._totalTipText);
            this._totalTipText = null;
            ObjectUtils.disposeObject(this._payTypeList[0]);
            this._payTypeList[0] = null;
            ObjectUtils.disposeObject(this._payTypeList[1]);
            this._payTypeList[1] = null;
            this._payTypeList.length = 0;
            this._payTypeList = null;
            ObjectUtils.disposeObject(this._cell);
            this._cell = null;
            this._number = null;
            this._itemTemplateInfo = null;
            this._shopItem = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package militaryrank.view

