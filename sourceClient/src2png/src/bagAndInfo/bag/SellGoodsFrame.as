// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//bagAndInfo.bag.SellGoodsFrame

package bagAndInfo.bag
{
    import com.pickgliss.ui.controls.Frame;
    import ddt.data.goods.InventoryItemInfo;
    import com.pickgliss.ui.controls.TextButton;
    import bagAndInfo.cell.BaseCell;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.events.FrameEvent;
    import flash.events.MouseEvent;
    import ddt.manager.SoundManager;
    import ddt.manager.SocketManager;
    import flash.events.Event;
    import ddt.manager.MessageTipManager;
    import ddt.manager.LanguageMgr;
    import ddt.data.EquipType;
    import ddt.data.goods.QualityType;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.utils.PositionUtils;
    import com.pickgliss.utils.ObjectUtils;

    public class SellGoodsFrame extends Frame 
    {

        public static const OK:String = "ok";
        public static const CANCEL:String = "cancel";

        private var _itemInfo:InventoryItemInfo;
        private var _confirm:TextButton;
        private var _cancel:TextButton;
        private var _cell:BaseCell;
        private var _nameTxt:FilterFrameText;
        private var _descript:FilterFrameText;
        private var _price:FilterFrameText;
        private var _num:FilterFrameText;

        public function SellGoodsFrame()
        {
            this.initView();
            addEventListener(FrameEvent.RESPONSE, this.__responseHandler);
            this._confirm.addEventListener(MouseEvent.CLICK, this.__confirmhandler);
            this._cancel.addEventListener(MouseEvent.CLICK, this.__cancelHandler);
        }

        protected function __confirmhandler(_arg_1:MouseEvent):void
        {
            this.ok();
        }

        protected function __cancelHandler(_arg_1:MouseEvent):void
        {
            this.cancel();
        }

        protected function __responseHandler(_arg_1:FrameEvent):void
        {
            switch (_arg_1.responseCode)
            {
                case FrameEvent.ENTER_CLICK:
                case FrameEvent.SUBMIT_CLICK:
                    this.ok();
                    return;
                case FrameEvent.CLOSE_CLICK:
                case FrameEvent.CANCEL_CLICK:
                case FrameEvent.ESC_CLICK:
                    this.cancel();
                    return;
            };
        }

        private function ok():void
        {
            SoundManager.instance.play("008");
            if (this._itemInfo.Property1 != "31")
            {
                SocketManager.Instance.out.reclaimGoods(this._itemInfo.BagType, this._itemInfo.Place, this._itemInfo.Count);
                dispatchEvent(new Event(OK));
            }
            else
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.beadSystem.tipCannotSell"));
            };
            this.dispose();
        }

        private function cancel():void
        {
            SoundManager.instance.play("008");
            dispatchEvent(new Event(CANCEL));
            this.dispose();
        }

        public function set itemInfo(_arg_1:InventoryItemInfo):void
        {
            this._itemInfo = _arg_1;
            this._cell.info = _arg_1;
            this._nameTxt.text = _arg_1.Name;
            if ((((_arg_1.CategoryID == EquipType.EQUIP) || (_arg_1.CategoryID == EquipType.COMPOSE_MATERIAL)) || (_arg_1.CategoryID == EquipType.COMPOSE_SKILL)))
            {
                this._nameTxt.textColor = QualityType.EQUIP_QUALITY_COLOR[_arg_1.Quality];
            }
            else
            {
                this._nameTxt.textColor = QualityType.QUALITY_COLOR[_arg_1.Quality];
            };
            var _local_2:String = ((_arg_1.ReclaimType == 1) ? LanguageMgr.GetTranslation("shop.ShopIIShoppingCarItem.gold") : ((_arg_1.ReclaimType == 2) ? LanguageMgr.GetTranslation("tank.gameover.takecard.gifttoken") : ""));
            this._descript.text = ((LanguageMgr.GetTranslation("bagAndInfo.sellFrame.explainTxtI") + "           ") + _local_2);
            this._num.text = String(_arg_1.Count);
            this._price.text = ((_arg_1.Count * _arg_1.ReclaimValue) + "");
        }

        private function initView():void
        {
            titleText = LanguageMgr.GetTranslation("AlertDialog.Info");
            this._confirm = ComponentFactory.Instance.creatComponentByStylename("sellGoodsFrame.ok");
            this._confirm.text = LanguageMgr.GetTranslation("ok");
            this._cancel = ComponentFactory.Instance.creatComponentByStylename("sellGoodsFrame.cancel");
            this._cancel.text = LanguageMgr.GetTranslation("cancel");
            this._cell = new BaseCell(ComponentFactory.Instance.creatBitmap("asset.newCore.itemCellBg"));
            PositionUtils.setPos(this._cell, "sellFrame.cellPos");
            this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("sellGoodsFrame.name");
            PositionUtils.setPos(this._nameTxt, "sellFrame.namePos");
            this._num = ComponentFactory.Instance.creatComponentByStylename("sellGoodsFrame.num");
            this._descript = ComponentFactory.Instance.creatComponentByStylename("sellGoodsFrame.explain");
            this._price = ComponentFactory.Instance.creatComponentByStylename("sellGoodsFrame.price");
            addToContent(this._confirm);
            addToContent(this._cancel);
            addToContent(this._cell);
            addToContent(this._nameTxt);
            addToContent(this._descript);
            addToContent(this._price);
            addToContent(this._num);
        }

        override public function dispose():void
        {
            removeEventListener(FrameEvent.RESPONSE, this.__responseHandler);
            if (this._confirm)
            {
                this._confirm.removeEventListener(MouseEvent.CLICK, this.__confirmhandler);
            };
            if (this._cancel)
            {
                this._cancel.removeEventListener(MouseEvent.CLICK, this.__cancelHandler);
            };
            super.dispose();
            this._itemInfo = null;
            if (this._confirm)
            {
                ObjectUtils.disposeObject(this._confirm);
            };
            this._confirm = null;
            if (this._cancel)
            {
                ObjectUtils.disposeObject(this._cancel);
            };
            this._cancel = null;
            if (this._cell)
            {
                ObjectUtils.disposeObject(this._cell);
            };
            this._cell = null;
            if (this._nameTxt)
            {
                ObjectUtils.disposeObject(this._nameTxt);
            };
            this._nameTxt = null;
            if (this._num)
            {
                ObjectUtils.disposeObject(this._num);
            };
            this._num = null;
            if (this._descript)
            {
                ObjectUtils.disposeObject(this._descript);
            };
            this._descript = null;
            if (this._price)
            {
                ObjectUtils.disposeObject(this._price);
            };
            this._price = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package bagAndInfo.bag

