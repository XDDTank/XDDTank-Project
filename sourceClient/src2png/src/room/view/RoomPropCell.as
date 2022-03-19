// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//room.view.RoomPropCell

package room.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import flash.display.Bitmap;
    import com.pickgliss.ui.image.Scale9CornerImage;
    import ddt.data.PropInfo;
    import ddt.view.PropItemView;
    import baglocked.BagLockedController;
    import com.pickgliss.ui.ComponentFactory;
    import flash.events.MouseEvent;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import ddt.manager.SoundManager;
    import ddt.manager.SocketManager;
    import ddt.manager.ShopManager;
    import ddt.manager.PlayerManager;
    import ddt.data.BagInfo;
    import ddt.manager.MessageTipManager;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.AlertManager;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.events.FrameEvent;
    import ddt.command.QuickBuyFrame;
    import ddt.data.EquipType;
    import com.pickgliss.utils.ObjectUtils;

    public class RoomPropCell extends Sprite implements Disposeable 
    {

        private var _bg:Bitmap;
        private var _bgI:Scale9CornerImage;
        private var _info:PropInfo;
        private var _container:PropItemView;
        private var _isself:Boolean;
        private var _place:int;
        private var _xyz:Bitmap;
        private var _bagLockControl:BagLockedController;

        public function RoomPropCell(_arg_1:Boolean, _arg_2:int)
        {
            this._isself = _arg_1;
            this._place = _arg_2;
            if (this._isself)
            {
                this._bgI = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroom.selfCellBgAssetI");
                switch (_arg_2)
                {
                    case 0:
                        this._xyz = ComponentFactory.Instance.creatBitmap("asset.ddtroom.cellZ");
                        break;
                    case 1:
                        this._xyz = ComponentFactory.Instance.creatBitmap("asset.ddtroom.cellX");
                        break;
                    case 2:
                        this._xyz = ComponentFactory.Instance.creatBitmap("asset.ddtroom.cellC");
                        break;
                };
                addChild(this._bgI);
                addChild(this._xyz);
            }
            else
            {
                this._bg = ComponentFactory.Instance.creatBitmap("asset.ddtroom.selfCellBgAsset");
                addChild(this._bg);
            };
            super();
            this.initEvent();
        }

        private function initEvent():void
        {
            addEventListener(MouseEvent.CLICK, this.__mouseClick);
            addEventListener(MouseEvent.MOUSE_OVER, this.__mouseOver);
            addEventListener(MouseEvent.MOUSE_OUT, this.__mouseOut);
        }

        private function removeEvent():void
        {
            removeEventListener(MouseEvent.CLICK, this.__mouseClick);
            removeEventListener(MouseEvent.MOUSE_OVER, this.__mouseOver);
            removeEventListener(MouseEvent.MOUSE_OUT, this.__mouseOut);
        }

        public function set info(_arg_1:PropInfo):void
        {
            if (((!(this._info == null)) && (!(_arg_1 == null))))
            {
                if (this._info.Template == _arg_1.Template)
                {
                    return;
                };
            };
            this._info = _arg_1;
            if (this._container != null)
            {
                if (this._container.parent)
                {
                    this._container.parent.removeChild(this._container);
                };
            };
            buttonMode = false;
            if (this._info == null)
            {
                return;
            };
            buttonMode = true;
            this._container = new PropItemView(this._info, true, false);
            addChild(this._container);
        }

        public function get info():PropInfo
        {
            return (this._info);
        }

        private function __mouseClick(_arg_1:MouseEvent):void
        {
            var _local_2:int;
            var _local_3:int;
            var _local_4:BaseAlerFrame;
            SoundManager.instance.play("008");
            if (this._info == null)
            {
                return;
            };
            if (this._isself)
            {
                SocketManager.Instance.out.sendSellProp(this._place, ShopManager.Instance.getGoldShopItemByTemplateID(this._info.Template.TemplateID).GoodsID);
            }
            else
            {
                _local_2 = PlayerManager.Instance.Self.getBag(BagInfo.FIGHTBAG).items.length;
                if (_local_2 >= RoomRightPropView.UPCELLS_NUMBER)
                {
                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("room.roomRightPropView.bagFull"));
                    return;
                };
                _local_3 = 0;
                while (_local_3 < 3)
                {
                    if (PlayerManager.Instance.Self.getBag(BagInfo.FIGHTBAG).items[_local_3])
                    {
                        if (PlayerManager.Instance.Self.getBag(BagInfo.FIGHTBAG).items[_local_3].TemplateID == this._info.Template.TemplateID)
                        {
                            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("room.roomRightPropView.bagUnique"));
                            return;
                        };
                    };
                    _local_3++;
                };
                if (PlayerManager.Instance.Self.Gold < ShopManager.Instance.getGoldShopItemByTemplateID(this._info.Template.TemplateID).getItemPrice(1).goldValue)
                {
                    _local_4 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("tank.view.GoldInadequate"), "", LanguageMgr.GetTranslation("cancel"), false, false, false, LayerManager.BLCAK_BLOCKGOUND);
                    _local_4.moveEnable = false;
                    _local_4.addEventListener(FrameEvent.RESPONSE, this.__onResponse);
                    return;
                };
                SocketManager.Instance.out.sendBuyProp(ShopManager.Instance.getGoldShopItemByTemplateID(this._info.Template.TemplateID).GoodsID);
                this.clientChange(this._info.Template.TemplateID);
            };
        }

        private function clientChange(_arg_1:int):void
        {
            if (PlayerManager.Instance.Self.getBag(BagInfo.FIGHTBAG).items.length < 3)
            {
                PlayerManager.Instance.Self.getBag(BagInfo.FIGHTBAG).addItemIntoFightBag(_arg_1, 1);
                PlayerManager.Instance.Self.Gold = (PlayerManager.Instance.Self.Gold - ShopManager.Instance.getGoldShopItemByTemplateID(this._info.Template.TemplateID).getItemPrice(1).goldValue);
            };
        }

        private function __onResponse(_arg_1:FrameEvent):void
        {
            var _local_3:QuickBuyFrame;
            var _local_2:BaseAlerFrame = BaseAlerFrame(_arg_1.target);
            _local_2.removeEventListener(FrameEvent.RESPONSE, this.__onResponse);
            _local_2.dispose();
            if (((_arg_1.responseCode == FrameEvent.SUBMIT_CLICK) || (_arg_1.responseCode == FrameEvent.ENTER_CLICK)))
            {
                _local_3 = ComponentFactory.Instance.creatComponentByStylename("ddtcore.QuickFrame");
                _local_3.setTitleText(LanguageMgr.GetTranslation("tank.view.store.matte.goldQuickBuy"));
                _local_3.itemID = EquipType.GOLD_BOX;
                LayerManager.Instance.addToLayer(_local_3, LayerManager.GAME_TOP_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
            };
        }

        private function __mouseOver(_arg_1:MouseEvent):void
        {
        }

        private function __mouseOut(_arg_1:MouseEvent):void
        {
        }

        override public function get width():Number
        {
            return (40);
        }

        public function dispose():void
        {
            this.removeEvent();
            if (this._bg)
            {
                ObjectUtils.disposeObject(this._bg);
            };
            this._bg = null;
            if (this._bgI)
            {
                ObjectUtils.disposeObject(this._bgI);
            };
            this._bgI = null;
            if (this._xyz)
            {
                ObjectUtils.disposeObject(this._xyz);
            };
            this._xyz = null;
            if (this._container)
            {
                this._container.dispose();
            };
            this._container = null;
            this._info = null;
            this._bagLockControl = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package room.view

