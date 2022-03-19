﻿// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//worldboss.view.BuffCartItem

package worldboss.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import worldboss.model.WorldBossBuffInfo;
    import flash.display.DisplayObject;
    import com.pickgliss.ui.image.Image;
    import com.pickgliss.ui.text.FilterFrameText;
    import shop.view.ShopPlayerCell;
    import com.pickgliss.loader.BitmapLoader;
    import flash.display.Bitmap;
    import com.pickgliss.ui.controls.BaseButton;
    import com.pickgliss.ui.controls.SelectedCheckButton;
    import com.pickgliss.ui.ComponentFactory;
    import bagAndInfo.cell.CellFactory;
    import ddt.utils.PositionUtils;
    import ddt.manager.LanguageMgr;
    import worldboss.WorldBossManager;
    import com.pickgliss.loader.LoaderEvent;
    import com.pickgliss.utils.ObjectUtils;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import ddt.manager.PlayerManager;
    import com.pickgliss.ui.AlertManager;
    import com.pickgliss.events.FrameEvent;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.ui.controls.Frame;
    import ddt.manager.SoundManager;
    import baglocked.BaglockedManager;
    import ddt.data.goods.InventoryItemInfo;
    import ddt.data.goods.ItemTemplateInfo;
    import ddt.manager.SocketManager;
    import ddt.manager.ItemManager;
    import ddt.manager.MessageTipManager;
    import ddt.manager.LeavePageManager;
    import com.pickgliss.loader.LoadResourceManager;
    import com.pickgliss.loader.BaseLoader;

    public class BuffCartItem extends Sprite implements Disposeable 
    {

        private var _buffInfo:WorldBossBuffInfo;
        private var _bg:DisplayObject;
        private var _itemCellBg:DisplayObject;
        private var _verticalLine:Image;
        private var _itemName:FilterFrameText;
        private var _description:FilterFrameText;
        private var _cell:ShopPlayerCell;
        private var _buffIconLoader:BitmapLoader;
        private var _buffIcon:Bitmap;
        private var _payPaneBuyBtn:BaseButton;
        private var _itemPrice:FilterFrameText;
        private var _moneyBitmap:Bitmap;
        private var _isBuyText:FilterFrameText;
        private var _autoBuySelectedBtn:SelectedCheckButton;
        private var _isAlreadyBuy:Boolean = false;
        private var _isAllSelected:Boolean = false;

        public function BuffCartItem()
        {
            this.drawBackground();
            this.drawNameField();
            this.drawCellField();
            this.init();
            this.addEvent();
        }

        protected function drawBackground():void
        {
            this._bg = ComponentFactory.Instance.creatComponentByStylename("ddtshop.CartItemBg");
            this._itemCellBg = ComponentFactory.Instance.creat("ddtshop.CartItemCellBg");
            this._verticalLine = ComponentFactory.Instance.creatComponentByStylename("ddtshop.VerticalLine");
            addChild(this._bg);
            addChild(this._verticalLine);
            addChild(this._itemCellBg);
        }

        protected function drawNameField():void
        {
            this._itemName = ComponentFactory.Instance.creatComponentByStylename("worldboss.buffCartItemName");
            this._description = ComponentFactory.Instance.creatComponentByStylename("worldboss.buffCartDescription");
            addChild(this._itemName);
            addChild(this._description);
        }

        protected function drawCellField():void
        {
            this._cell = (CellFactory.instance.createShopCartItemCell() as ShopPlayerCell);
            PositionUtils.setPos(this._cell, "ddtshop.CartItemCellPoint");
            addChild(this._cell);
        }

        private function init():void
        {
            this._payPaneBuyBtn = ComponentFactory.Instance.creatComponentByStylename("ddtshop.PayPaneBuyBtn");
            PositionUtils.setPos(this._payPaneBuyBtn, "worldboss.buffCartItem.bugBtn");
            addChild(this._payPaneBuyBtn);
            this._moneyBitmap = ComponentFactory.Instance.creatBitmap("bagAndInfo.info.PointCoupon");
            PositionUtils.setPos(this._moneyBitmap, "worldboss.buffCartItem.moneyBitmapPos");
            addChild(this._moneyBitmap);
            this._itemPrice = ComponentFactory.Instance.creatComponentByStylename("worldboss.buff.price");
            addChild(this._itemPrice);
            this._isBuyText = ComponentFactory.Instance.creatComponentByStylename("worldbossBuffIsBuyText");
            this._isBuyText.text = LanguageMgr.GetTranslation("worldboss.buyBuff.haveBuy");
            addChild(this._isBuyText);
            this._isBuyText.visible = false;
            this._autoBuySelectedBtn = ComponentFactory.Instance.creatComponentByStylename("worldbossAutoBuySelected");
            this._autoBuySelectedBtn.text = LanguageMgr.GetTranslation("worldboss.buyBuff.autoBuy");
            addChild(this._autoBuySelectedBtn);
        }

        private function updateStatus():void
        {
            var _local_1:int;
            while (_local_1 < WorldBossManager.Instance.bossInfo.myPlayerVO.buffs.length)
            {
                if (this.buffID == WorldBossManager.Instance.bossInfo.myPlayerVO.buffs[_local_1])
                {
                    this.changeStatusBuy();
                    return;
                };
                _local_1++;
            };
        }

        private function _buffIconComplete(_arg_1:LoaderEvent):void
        {
            if (_arg_1.loader.isSuccess)
            {
                _arg_1.loader.removeEventListener(LoaderEvent.COMPLETE, this._buffIconComplete);
                ObjectUtils.disposeObject(this._buffIcon);
                this._buffIcon = null;
                this._buffIcon = (_arg_1.loader.content as Bitmap);
                addChild(this._buffIcon);
                PositionUtils.setPos(this._buffIcon, "worldboss.buffCartItem.Iconpos");
                this._buffIcon.width = (this._buffIcon.height = 60);
            };
        }

        private function addEvent():void
        {
            this._autoBuySelectedBtn.addEventListener(Event.SELECT, this.__autoBuyBuff);
            this._payPaneBuyBtn.addEventListener(MouseEvent.CLICK, this.__payBuyBuff);
        }

        protected function __autoBuyBuff(_arg_1:Event):void
        {
            var _local_2:BaseAlerFrame;
            var _local_3:BaseAlerFrame;
            if (this._autoBuySelectedBtn.selected)
            {
                if (PlayerManager.Instance.Self.Money >= this._buffInfo.price)
                {
                    if (WorldBossManager.Instance.isBuyBuffAlert)
                    {
                        this.autoBuy();
                        return;
                    };
                    _local_2 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"), LanguageMgr.GetTranslation("worldboss.buyBuff.autoBuyConfirm"), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"));
                    _local_2.addEventListener(FrameEvent.RESPONSE, this.__onResponse);
                }
                else
                {
                    _local_3 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("tank.view.comon.lack"), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), false, false, false, LayerManager.ALPHA_BLOCKGOUND);
                    _local_3.moveEnable = false;
                    _local_3.addEventListener(FrameEvent.RESPONSE, this._responseI);
                    this._autoBuySelectedBtn.selected = false;
                    WorldBossManager.Instance.isBuyBuffAlert = false;
                    return;
                };
            }
            else
            {
                WorldBossManager.Instance.autoBuyBuffs.remove(this._buffInfo.ID);
            };
            dispatchEvent(new Event(Event.SELECT));
        }

        protected function __onResponse(_arg_1:FrameEvent):void
        {
            WorldBossManager.Instance.isBuyBuffAlert = true;
            switch (_arg_1.responseCode)
            {
                case FrameEvent.CANCEL_CLICK:
                case FrameEvent.CLOSE_CLICK:
                    WorldBossManager.Instance.isBuyBuffAlert = false;
                    this._autoBuySelectedBtn.selected = false;
                    break;
                case FrameEvent.SUBMIT_CLICK:
                case FrameEvent.ENTER_CLICK:
                    this.autoBuy();
                    break;
            };
            Frame(_arg_1.currentTarget).dispose();
        }

        private function autoBuy():void
        {
            SoundManager.instance.play("008");
            if (PlayerManager.Instance.Self.bagLocked)
            {
                BaglockedManager.Instance.show();
                this._autoBuySelectedBtn.selected = false;
                WorldBossManager.Instance.isBuyBuffAlert = false;
                return;
            };
            WorldBossManager.Instance.autoBuyBuffs.add(this._buffInfo.ID, this._buffInfo);
            dispatchEvent(new Event(Event.SELECT));
        }

        private function removeEvent():void
        {
            this._autoBuySelectedBtn.removeEventListener(Event.SELECT, this.__autoBuyBuff);
            this._payPaneBuyBtn.removeEventListener(MouseEvent.CLICK, this.__payBuyBuff);
        }

        private function __selectedBuff(_arg_1:Event):void
        {
            if (this._isAllSelected)
            {
                this._isAllSelected = false;
                return;
            };
            SoundManager.instance.play("008");
            dispatchEvent(new Event(Event.SELECT));
        }

        public function selected(_arg_1:Boolean):void
        {
            this._isAllSelected = true;
            this._autoBuySelectedBtn.selected = _arg_1;
        }

        private function __payBuyBuff(_arg_1:MouseEvent):void
        {
            var _local_2:BaseAlerFrame;
            var _local_3:int;
            var _local_4:InventoryItemInfo;
            var _local_5:ItemTemplateInfo;
            SoundManager.instance.play("008");
            if (PlayerManager.Instance.Self.bagLocked)
            {
                BaglockedManager.Instance.show();
                return;
            };
            if (this._buffInfo.costID == -1)
            {
                if (PlayerManager.Instance.Self.Money >= this._buffInfo.price)
                {
                    SocketManager.Instance.out.sendBuyWorldBossBuff([this._buffInfo.ID]);
                }
                else
                {
                    _local_2 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("tank.view.comon.lack"), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), false, false, false, LayerManager.ALPHA_BLOCKGOUND);
                    _local_2.moveEnable = false;
                    _local_2.addEventListener(FrameEvent.RESPONSE, this._responseI);
                };
            }
            else
            {
                _local_3 = 0;
                for each (_local_4 in PlayerManager.Instance.Self.PropBag.findItemsByTempleteID(this._buffInfo.costID))
                {
                    _local_3 = (_local_3 + _local_4.Count);
                };
                if (_local_3 >= this._buffInfo.price)
                {
                    SocketManager.Instance.out.sendBuyWorldBossBuff([this._buffInfo.ID]);
                }
                else
                {
                    _local_5 = ItemManager.Instance.getTemplateById(this._buffInfo.costID);
                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("worldboss.buyBuff.lackItem", _local_5.Name));
                };
            };
        }

        private function _responseI(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            if (_arg_1.responseCode == FrameEvent.SUBMIT_CLICK)
            {
                LeavePageManager.leaveToFillPath();
            };
            ObjectUtils.disposeObject(_arg_1.target);
        }

        public function set buffItemInfo(_arg_1:WorldBossBuffInfo):void
        {
            var _local_2:ItemTemplateInfo;
            this._buffInfo = _arg_1;
            this._itemName.text = this._buffInfo.name;
            this._description.text = this._buffInfo.decription;
            if (this._buffInfo.costID == -1)
            {
                this._itemPrice.text = LanguageMgr.GetTranslation("worldboss.buyBuff.eachMoney", this._buffInfo.price.toString(), "1");
            }
            else
            {
                _local_2 = ItemManager.Instance.getTemplateById(this._buffInfo.costID);
                this._itemPrice.text = LanguageMgr.GetTranslation("worldboss.buyBuff.eachItem", this._buffInfo.price.toString(), _local_2.Name, "1");
                PositionUtils.setPos(this._itemPrice, "worldboss.buffCartItem.costItemMoneyTxt");
                this._moneyBitmap.visible = false;
            };
            this._buffIconLoader = LoadResourceManager.instance.createLoader(WorldBossRoomView.getImagePath(this._buffInfo.ID), BaseLoader.BITMAP_LOADER);
            this._buffIconLoader.addEventListener(LoaderEvent.COMPLETE, this._buffIconComplete);
            LoadResourceManager.instance.startLoad(this._buffIconLoader);
            this.updateStatus();
        }

        public function changeStatusBuy():void
        {
            this._isAlreadyBuy = true;
            this._isBuyText.visible = true;
            this._autoBuySelectedBtn.visible = false;
            this._payPaneBuyBtn.visible = false;
        }

        public function get IsSelected():Boolean
        {
            return ((this._isAlreadyBuy) || (this._autoBuySelectedBtn.selected));
        }

        public function get price():int
        {
            return (this._buffInfo.price);
        }

        public function get buffID():int
        {
            return (this._buffInfo.ID);
        }

        public function dispose():void
        {
            this.removeEvent();
            ObjectUtils.disposeAllChildren(this);
            this._bg = null;
            this._itemCellBg = null;
            this._verticalLine = null;
            this._itemName = null;
            this._cell = null;
            this._buffIconLoader = null;
            this._buffIcon = null;
            this._payPaneBuyBtn = null;
            this._itemPrice = null;
            this._moneyBitmap = null;
        }


    }
}//package worldboss.view

