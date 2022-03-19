// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//packagePurchaseBox.view.PackagePurchaseBoxFrame

package packagePurchaseBox.view
{
    import com.pickgliss.ui.controls.Frame;
    import flash.display.Sprite;
    import com.pickgliss.ui.controls.ScrollPanel;
    import com.pickgliss.ui.controls.container.VBox;
    import com.pickgliss.ui.image.ScaleBitmapImage;
    import com.pickgliss.ui.image.Scale9CornerImage;
    import __AS3__.vec.Vector;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.utils.ObjectUtils;
    import packagePurchaseBox.PackagePurchaseBoxController;
    import ddt.manager.ShopManager;
    import ddt.data.goods.ShopItemInfo;
    import com.pickgliss.ui.LayerManager;
    import ddt.events.PurchaseBoxEvent;
    import com.pickgliss.events.FrameEvent;
    import ddt.manager.TimeManager;
    import ddt.events.TimeEvents;
    import ddt.manager.SoundManager;
    import __AS3__.vec.*;

    public class PackagePurchaseBoxFrame extends Frame 
    {

        public static var STACTICITEM:int = 4;
        public static const PURCHASEPACKAGEBOX:int = 86;

        private var itemMount:int;
        private var _goodItemContainerAll:Sprite;
        private var _cartScroll:ScrollPanel;
        private var _cartList:VBox;
        private var _BG0:ScaleBitmapImage;
        private var _BG:Scale9CornerImage;
        private var _goodItems:Vector.<PackagePurchaseBoxItem>;
        private var itemlength:uint;

        public function PackagePurchaseBoxFrame()
        {
            this.intview();
            this.intEvent();
        }

        private function intview():void
        {
            this._BG0 = ComponentFactory.Instance.creatComponentByStylename("packagePurchaseBoxFrameBG0");
            this._BG = ComponentFactory.Instance.creatComponentByStylename("packagePurchaseBoxFrameBg");
            titleText = LanguageMgr.GetTranslation("ddt.packagePurchaseBox.frameTitle");
            this._goodItems = new Vector.<PackagePurchaseBoxItem>();
            this._cartList = new VBox();
            this._cartScroll = ComponentFactory.Instance.creatComponentByStylename("ddtshop.CheckOutViewItemListI");
            this._cartList.spacing = 5;
            this._cartScroll.setView(this._cartList);
            this._cartScroll.vScrollProxy = ScrollPanel.ON;
            this._cartList.isReverAdd = true;
            addToContent(this._BG0);
            addToContent(this._BG);
            addToContent(this._cartScroll);
            this.updateItems();
            this.clearitems();
            this.loadList();
        }

        private function updateItems():void
        {
            var _local_1:int;
            var _local_2:Number;
            var _local_3:Number;
            if (this._goodItemContainerAll)
            {
                ObjectUtils.disposeObject(this._goodItemContainerAll);
                this._goodItemContainerAll = null;
            };
            this._goodItemContainerAll = ComponentFactory.Instance.creatCustomObject("ddtshop.GoodItemContainerAll");
            this.itemlength = PackagePurchaseBoxController.instance.measureList(ShopManager.Instance.getValidSortedGoodsByType(PURCHASEPACKAGEBOX, 1)).length;
            this.itemMount = Math.max(this.itemlength, STACTICITEM);
            _local_1 = 0;
            while (_local_1 < this.itemMount)
            {
                this._goodItems[_local_1] = ComponentFactory.Instance.creatCustomObject("ddtshop.packagePurchaseBoxItem");
                _local_2 = this._goodItems[_local_1].width;
                _local_3 = this._goodItems[_local_1].height;
                _local_2 = (_local_2 * int((_local_1 % 2)));
                _local_3 = (_local_3 * int((_local_1 / 2)));
                this._goodItems[_local_1].x = _local_2;
                this._goodItems[_local_1].y = (_local_3 + ((_local_1 / 2) * 2));
                this._goodItemContainerAll.addChild(this._goodItems[_local_1]);
                _local_1++;
            };
            this._cartList.addChild(this._goodItemContainerAll);
            this._cartScroll.invalidateViewport();
        }

        private function clearitems():void
        {
            var _local_1:int;
            while (_local_1 < this.itemMount)
            {
                this._goodItems[_local_1].shopItemInfo = null;
                _local_1++;
            };
        }

        public function loadList():void
        {
            this.clearitems();
            this.setList(ShopManager.Instance.getValidSortedGoodsByType(PURCHASEPACKAGEBOX, 1));
        }

        public function setList(_arg_1:Vector.<ShopItemInfo>):void
        {
            var _local_2:int;
            while (_local_2 < this.itemlength)
            {
                this._goodItems[_local_2].selected = false;
                if ((!(_arg_1))) break;
                this._goodItems[_local_2].ableButton();
                if (((_local_2 < _arg_1.length) && (_arg_1[_local_2])))
                {
                    if (_arg_1[_local_2].isValid)
                    {
                        this._goodItems[_local_2].shopItemInfo = _arg_1[_local_2];
                    };
                };
                _local_2++;
            };
        }

        public function show():void
        {
            LayerManager.Instance.addToLayer(this, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.ALPHA_BLOCKGOUND);
        }

        public function intEvent():void
        {
            PackagePurchaseBoxController.instance.addEventListener(PurchaseBoxEvent.PURCHAESBOX_CHANGE, this.__update);
            addEventListener(FrameEvent.RESPONSE, this.__frameEventHandler);
            TimeManager.addEventListener(TimeEvents.MINUTES, this.__updateByMinutes);
        }

        private function __updateByMinutes(_arg_1:TimeEvents):void
        {
            this.updateItems();
            this.loadList();
        }

        private function __update(_arg_1:PurchaseBoxEvent):void
        {
            this.updateItems();
            this.loadList();
        }

        private function __frameEventHandler(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            switch (_arg_1.responseCode)
            {
                case FrameEvent.ESC_CLICK:
                case FrameEvent.CLOSE_CLICK:
                    PackagePurchaseBoxController.instance.hide();
                    return;
            };
        }

        private function removeEvent():void
        {
            TimeManager.removeEventListener(TimeEvents.MINUTES, this.__updateByMinutes);
            PackagePurchaseBoxController.instance.removeEventListener(PurchaseBoxEvent.PURCHAESBOX_CHANGE, this.__update);
        }

        override public function dispose():void
        {
            this.removeEvent();
            super.dispose();
            ObjectUtils.disposeObject(this._BG0);
            this._BG0 = null;
            ObjectUtils.disposeObject(this._BG);
            this._BG = null;
            var _local_1:int;
            while (_local_1 < this.itemlength)
            {
                ObjectUtils.disposeObject(this._goodItems[_local_1]);
                this._goodItems[_local_1] = null;
                _local_1++;
            };
            this._goodItems = null;
            ObjectUtils.disposeObject(this._goodItemContainerAll);
            this._goodItemContainerAll = null;
        }


    }
}//package packagePurchaseBox.view

