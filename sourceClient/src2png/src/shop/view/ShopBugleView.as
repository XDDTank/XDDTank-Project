// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//shop.view.ShopBugleView

package shop.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import ddt.data.goods.ShopItemInfo;
    import com.pickgliss.ui.controls.container.HBox;
    import com.pickgliss.ui.controls.SelectedButtonGroup;
    import ddt.manager.ChatManager;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.toplevel.StageReferance;
    import flash.events.KeyboardEvent;
    import flash.events.MouseEvent;
    import flash.ui.Keyboard;
    import ddt.manager.SoundManager;
    import ddt.manager.PlayerManager;
    import baglocked.BaglockedManager;
    import ddt.manager.LeavePageManager;
    import ddt.manager.SocketManager;
    import com.pickgliss.events.FrameEvent;
    import flash.events.Event;
    import flash.display.Shape;
    import bagAndInfo.cell.CellFactory;
    import ddt.utils.PositionUtils;
    import ddt.data.EquipType;
    import ddt.manager.LanguageMgr;
    import ddt.manager.ShopManager;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.ui.vo.AlertInfo;

    public class ShopBugleView extends Sprite implements Disposeable 
    {

        private static const BUGLE:uint = 3;
        private static const GOLD:uint = 0;
        private static const TEXP:uint = 6;
        public static const DONT_BUY_ANYTHING:String = "dontBuyAnything";

        private var _frame:BaseAlerFrame;
        private var _info:ShopItemInfo;
        private var _itemContainer:HBox;
        private var _itemGroup:SelectedButtonGroup;
        private var _type:int;
        private var _buyFrom:int;

        public function ShopBugleView(_arg_1:int)
        {
            this._type = _arg_1;
            this.init();
            ChatManager.Instance.focusFuncEnabled = false;
            if (this._info)
            {
                LayerManager.Instance.addToLayer(this, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.ALPHA_BLOCKGOUND);
            };
        }

        public function dispose():void
        {
            var _local_1:ShopBugleViewItem;
            StageReferance.stage.removeEventListener(KeyboardEvent.KEY_DOWN, this.__onKeyDownd);
            while (this._itemContainer.numChildren > 0)
            {
                _local_1 = (this._itemContainer.getChildAt(0) as ShopBugleViewItem);
                _local_1.removeEventListener(MouseEvent.CLICK, this.__click);
                _local_1.dispose();
                _local_1 = null;
            };
            this._frame.dispose();
            this.clearAllItem();
            this._frame = null;
            this._itemContainer.dispose();
            this._itemContainer = null;
            this._info = null;
            if (parent)
            {
                parent.removeChild(this);
            };
            ChatManager.Instance.focusFuncEnabled = true;
        }

        public function get type():int
        {
            return (this._type);
        }

        public function get info():ShopItemInfo
        {
            return (this._info);
        }

        protected function __onKeyDownd(_arg_1:KeyboardEvent):void
        {
            var _local_2:int = this._itemGroup.selectIndex;
            var _local_3:int = this._itemContainer.numChildren;
            if (_arg_1.keyCode == Keyboard.LEFT)
            {
                _local_2 = ((_local_2 == 0) ? 0 : --_local_2);
            }
            else
            {
                if (_arg_1.keyCode == Keyboard.RIGHT)
                {
                    _local_2 = ((_local_2 == (_local_3 - 1)) ? (_local_3 - 1) : ++_local_2);
                };
            };
            if (this._itemGroup.selectIndex != _local_2)
            {
                SoundManager.instance.play("008");
                this._itemGroup.selectIndex = _local_2;
            };
            _arg_1.stopImmediatePropagation();
            _arg_1.stopPropagation();
        }

        private function __frameEventHandler(_arg_1:FrameEvent):void
        {
            var _local_2:ShopBugleViewItem;
            SoundManager.instance.play("008");
            switch (_arg_1.responseCode)
            {
                case FrameEvent.SUBMIT_CLICK:
                case FrameEvent.ENTER_CLICK:
                    if (PlayerManager.Instance.Self.bagLocked)
                    {
                        BaglockedManager.Instance.show();
                        return;
                    };
                    _local_2 = (this._itemContainer.getChildAt(this._itemGroup.selectIndex) as ShopBugleViewItem);
                    if (PlayerManager.Instance.Self.totalMoney < _local_2.money)
                    {
                        LeavePageManager.showFillFrame();
                        return;
                    };
                    SocketManager.Instance.out.sendBuyGoods([this._info.GoodsID], [_local_2.type], [""], [0], [Boolean(0)], [""], this._buyFrom);
                    this.dispose();
                    return;
                case FrameEvent.CANCEL_CLICK:
                case FrameEvent.CLOSE_CLICK:
                case FrameEvent.ESC_CLICK:
                    dispatchEvent(new Event("DONT_BUY_ANYTHING"));
                    this.dispose();
                    return;
            };
        }

        private function addItem(_arg_1:ShopItemInfo, _arg_2:int):void
        {
            var _local_3:Shape = new Shape();
            _local_3.graphics.beginFill(0xFFFFFF, 0);
            _local_3.graphics.drawRect(0, 0, 70, 70);
            _local_3.graphics.endFill();
            var _local_4:ShopItemCell = (CellFactory.instance.createShopItemCell(_local_3, _arg_1.TemplateInfo) as ShopItemCell);
            PositionUtils.setPos(_local_4, "ddtshop.BugleViewItemCellPos");
            var _local_5:ShopBugleViewItem = new ShopBugleViewItem(_arg_2, _arg_1.getTimeToString(_arg_2), _arg_1.getItemPrice(_arg_2).moneyValue, _local_4);
            _local_5.addEventListener(MouseEvent.CLICK, this.__click);
            this._itemContainer.addChild(_local_5);
            this._itemGroup.addSelectItem(_local_5);
        }

        private function __click(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            this._itemGroup.selectIndex = this._itemContainer.getChildIndex((_arg_1.currentTarget as ShopBugleViewItem));
        }

        private function addItems():void
        {
            var _local_1:int;
            if (this._type == EquipType.T_BBUGLE)
            {
                _local_1 = EquipType.T_BBUGLE;
                this._frame.titleText = LanguageMgr.GetTranslation("tank.dialog.showbugleframe.bigbugletitle");
                this._buyFrom = BUGLE;
            }
            else
            {
                if (this._type == EquipType.T_SBUGLE)
                {
                    _local_1 = EquipType.T_SBUGLE;
                    this._frame.titleText = LanguageMgr.GetTranslation("tank.dialog.showbugleframe.smallbugletitle");
                    this._buyFrom = BUGLE;
                }
                else
                {
                    if (this._type == EquipType.T_CBUGLE)
                    {
                        _local_1 = EquipType.T_CBUGLE;
                        this._frame.titleText = LanguageMgr.GetTranslation("tank.dialog.showbugleframe.crossbugletitle");
                        this._buyFrom = BUGLE;
                    }
                    else
                    {
                        if (this._type == EquipType.CADDY_KEY)
                        {
                            _local_1 = EquipType.CADDY_KEY;
                            this._frame.titleText = LanguageMgr.GetTranslation("tank.view.store.matte.goldQuickBuy");
                            this._buyFrom = GOLD;
                        }
                        else
                        {
                            if (this._type == EquipType.TEXP_LV_II)
                            {
                                _local_1 = EquipType.TEXP_LV_II;
                                this._frame.titleText = LanguageMgr.GetTranslation("tank.dialog.showbugleframe.texpQuickBuy");
                                this._buyFrom = TEXP;
                            };
                        };
                    };
                };
            };
            this._info = ShopManager.Instance.getMoneyShopItemByTemplateID(_local_1);
            if (this._info)
            {
                if (this._info.getItemPrice(1).IsValid)
                {
                    this.addItem(this._info, 1);
                };
                if (this._info.getItemPrice(2).IsValid)
                {
                    this.addItem(this._info, 2);
                };
                if (this._info.getItemPrice(3).IsValid)
                {
                    this.addItem(this._info, 3);
                };
            };
        }

        private function clearAllItem():void
        {
            var _local_1:ShopBugleViewItem;
            while (this._itemContainer.numChildren > 0)
            {
                _local_1 = (this._itemContainer.getChildAt(0) as ShopBugleViewItem);
                _local_1.removeEventListener(MouseEvent.CLICK, this.__click);
                _local_1.dispose();
                _local_1 = null;
            };
        }

        private function init():void
        {
            this._itemGroup = new SelectedButtonGroup();
            this._frame = ComponentFactory.Instance.creatComponentByStylename("ddtshop.newBugleFrame");
            this._itemContainer = ComponentFactory.Instance.creatComponentByStylename("ddtshop.newBugleViewItemContainer");
            var _local_1:AlertInfo = new AlertInfo("", LanguageMgr.GetTranslation("tank.dialog.showbugleframe.ok"));
            this._frame.info = _local_1;
            this._frame.addToContent(this._itemContainer);
            this._frame.addEventListener(FrameEvent.RESPONSE, this.__frameEventHandler);
            addChild(this._frame);
            this.updateView();
            this._itemGroup.selectIndex = 0;
            StageReferance.stage.addEventListener(KeyboardEvent.KEY_DOWN, this.__onKeyDownd);
        }

        private function updateView():void
        {
            this.clearAllItem();
            this.addItems();
        }


    }
}//package shop.view

