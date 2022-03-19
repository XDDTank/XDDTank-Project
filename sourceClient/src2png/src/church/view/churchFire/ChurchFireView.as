// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//church.view.churchFire.ChurchFireView

package church.view.churchFire
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import church.controller.ChurchRoomController;
    import church.model.ChurchRoomModel;
    import flash.display.Bitmap;
    import com.pickgliss.ui.controls.BaseButton;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.controls.container.HBox;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.LanguageMgr;
    import ddt.manager.PlayerManager;
    import com.pickgliss.utils.ObjectUtils;
    import flash.events.MouseEvent;
    import ddt.events.PlayerPropertyEvent;
    import church.events.WeddingRoomEvent;
    import ddt.manager.ShopManager;
    import ddt.manager.SoundManager;
    import baglocked.BaglockedManager;
    import com.pickgliss.ui.AlertManager;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.events.FrameEvent;
    import ddt.manager.SocketManager;
    import ddt.command.QuickBuyFrame;
    import ddt.data.EquipType;

    public class ChurchFireView extends Sprite implements Disposeable 
    {

        public static const FIRE_USE_GOLD:int = 2000;

        private var _controller:ChurchRoomController;
        private var _model:ChurchRoomModel;
        private var _fireBg:Bitmap;
        private var _fireClose:BaseButton;
        private var _fireGlodLabel:FilterFrameText;
        private var _fireGlod:FilterFrameText;
        private var _fireGoldIcon:Bitmap;
        private var _fireIcon21002:Bitmap;
        private var _fireIcon21006:Bitmap;
        private var All_Fires:Array;
        private var All_FireIcons:Array;
        private var _fireListBox:HBox;
        private var _fireUseGold:int;
        private var _fireListFilter:Array;
        private var _alert:BaseAlerFrame;

        public function ChurchFireView(_arg_1:ChurchRoomController, _arg_2:ChurchRoomModel)
        {
            this._controller = _arg_1;
            this._model = _arg_2;
            this.initialize();
        }

        private function initialize():void
        {
            this.setView();
            this.setEvent();
            this.getFireList();
        }

        private function setView():void
        {
            this._fireBg = ComponentFactory.Instance.creatBitmap("asset.church.room.fireBgAsset");
            addChild(this._fireBg);
            this._fireClose = ComponentFactory.Instance.creat("church.room.fireCloseAsset");
            this._fireClose.buttonMode = true;
            addChild(this._fireClose);
            this._fireGlodLabel = ComponentFactory.Instance.creat("church.room.fireGlodLabelAsset");
            this._fireGlodLabel.text = LanguageMgr.GetTranslation("church.view.churchFire.ChurchFireView");
            addChild(this._fireGlodLabel);
            this._fireGlod = ComponentFactory.Instance.creat("church.room.fireGlodAsset");
            this._fireGlod.text = PlayerManager.Instance.Self.Gold.toString();
            addChild(this._fireGlod);
            this._fireGoldIcon = ComponentFactory.Instance.creatBitmap("asset.church.room.fireGoldIconAsset");
            addChild(this._fireGoldIcon);
            this._fireListBox = ComponentFactory.Instance.creat("church.room.fireListBoxAsset");
            addChild(this._fireListBox);
            this._fireUseGold = FIRE_USE_GOLD;
            this._fireIcon21002 = ComponentFactory.Instance.creatBitmap("asset.church.room.fireIcon21002");
            this._fireIcon21002.smoothing = true;
            this._fireIcon21006 = ComponentFactory.Instance.creatBitmap("asset.church.room.fireIcon21006");
            this._fireIcon21006.smoothing = true;
            this.All_Fires = this._model.fireTemplateIDList;
            this.All_FireIcons = [this._fireIcon21002, this._fireIcon21006];
        }

        private function removeView():void
        {
            this.All_Fires = null;
            this.All_FireIcons = null;
            if (this._fireBg)
            {
                if (this._fireBg.parent)
                {
                    this._fireBg.parent.removeChild(this._fireBg);
                };
                this._fireBg.bitmapData.dispose();
                this._fireBg.bitmapData = null;
            };
            this._fireBg = null;
            if (this._fireClose)
            {
                if (this._fireClose.parent)
                {
                    this._fireClose.parent.removeChild(this._fireClose);
                };
                this._fireClose.dispose();
            };
            this._fireClose = null;
            if (this._fireGlodLabel)
            {
                if (this._fireGlodLabel.parent)
                {
                    this._fireGlodLabel.parent.removeChild(this._fireGlodLabel);
                };
                this._fireGlodLabel.dispose();
            };
            this._fireGlodLabel = null;
            if (this._fireGlod)
            {
                if (this._fireGlod.parent)
                {
                    this._fireGlod.parent.removeChild(this._fireGlod);
                };
                this._fireGlod.dispose();
            };
            this._fireGlod = null;
            if (this._fireGoldIcon)
            {
                if (this._fireGoldIcon.parent)
                {
                    this._fireGoldIcon.parent.removeChild(this._fireGoldIcon);
                };
                this._fireGoldIcon.bitmapData.dispose();
                this._fireGoldIcon.bitmapData = null;
            };
            this._fireGoldIcon = null;
            ObjectUtils.disposeObject(this._fireIcon21002);
            this._fireIcon21002 = null;
            ObjectUtils.disposeObject(this._fireIcon21006);
            this._fireIcon21006 = null;
            if (this._fireListBox)
            {
                if (this._fireListBox.parent)
                {
                    this._fireListBox.parent.removeChild(this._fireListBox);
                };
                this._fireListBox.dispose();
            };
            this._fireListBox = null;
            this._fireListFilter = null;
            if (parent)
            {
                this.parent.removeChild(this);
            };
        }

        private function setEvent():void
        {
            this._fireClose.addEventListener(MouseEvent.CLICK, this.onCloseClick);
            PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE, this.updateGold);
            this._model.addEventListener(WeddingRoomEvent.ROOM_FIRE_ENABLE_CHANGE, this.fireEnableChange);
        }

        private function removeEvent():void
        {
            var _local_1:int;
            this._fireClose.removeEventListener(MouseEvent.CLICK, this.onCloseClick);
            PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE, this.updateGold);
            this._model.removeEventListener(WeddingRoomEvent.ROOM_FIRE_ENABLE_CHANGE, this.fireEnableChange);
            if (this._fireListBox)
            {
                while (_local_1 < this._fireListBox.numChildren)
                {
                    this._fireListBox.getChildAt(_local_1).removeEventListener(MouseEvent.CLICK, this.itemClickHandler);
                    _local_1++;
                };
            };
        }

        private function getFireList():void
        {
            var _local_2:ChurchFireCell;
            var _local_1:int;
            while (_local_1 < this.All_Fires.length)
            {
                _local_2 = new ChurchFireCell(this.All_FireIcons[_local_1], ShopManager.Instance.getGoldShopItemByTemplateID(this.All_Fires[_local_1]), this.All_Fires[_local_1]);
                _local_2.addEventListener(MouseEvent.CLICK, this.itemClickHandler);
                this._fireListBox.addChild(_local_2);
                _local_1++;
            };
        }

        private function itemClickHandler(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            if (PlayerManager.Instance.Self.bagLocked)
            {
                BaglockedManager.Instance.show();
                return;
            };
            if (PlayerManager.Instance.Self.Gold < this._fireUseGold)
            {
                if ((!(this._alert)))
                {
                    this._alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tank.room.RoomIIView2.notenoughmoney.title"), LanguageMgr.GetTranslation("tank.view.GoldInadequate"), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), false, false, false, LayerManager.BLCAK_BLOCKGOUND);
                    this._alert.addEventListener(FrameEvent.RESPONSE, this._responseV);
                    this._alert.moveEnable = false;
                    return;
                };
            };
            var _local_2:ChurchFireCell = (_arg_1.currentTarget as ChurchFireCell);
            this._controller.useFire(PlayerManager.Instance.Self.ID, _local_2.fireTemplateID);
            SocketManager.Instance.out.sendUseFire(PlayerManager.Instance.Self.ID, _local_2.fireTemplateID);
        }

        private function _responseV(_arg_1:FrameEvent):void
        {
            this._alert.removeEventListener(FrameEvent.RESPONSE, this._responseV);
            this._alert.dispose();
            this._alert = null;
            switch (_arg_1.responseCode)
            {
                case FrameEvent.SUBMIT_CLICK:
                case FrameEvent.ENTER_CLICK:
                    this.okFastPurchaseGold();
                    return;
            };
        }

        private function okFastPurchaseGold():void
        {
            var _local_1:QuickBuyFrame = ComponentFactory.Instance.creatComponentByStylename("ddtcore.QuickFrame");
            _local_1.setTitleText(LanguageMgr.GetTranslation("tank.view.store.matte.goldQuickBuy"));
            _local_1.itemID = EquipType.GOLD_BOX;
            LayerManager.Instance.addToLayer(_local_1, LayerManager.GAME_TOP_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
        }

        private function updateGold(_arg_1:PlayerPropertyEvent):void
        {
            this._fireGlod.text = PlayerManager.Instance.Self.Gold.toString();
        }

        private function fireEnableChange(_arg_1:WeddingRoomEvent):void
        {
            var _local_2:int;
            var _local_3:int;
            this.setButtnEnable(this._fireListBox, this._model.fireEnable);
            if (this._model.fireEnable)
            {
                while (_local_2 < this._fireListBox.numChildren)
                {
                    this._fireListBox.getChildAt(_local_2).removeEventListener(MouseEvent.CLICK, this.itemClickHandler);
                    this._fireListBox.getChildAt(_local_2).addEventListener(MouseEvent.CLICK, this.itemClickHandler);
                    _local_2++;
                };
            }
            else
            {
                while (_local_3 < this._fireListBox.numChildren)
                {
                    this._fireListBox.getChildAt(_local_3).removeEventListener(MouseEvent.CLICK, this.itemClickHandler);
                    _local_3++;
                };
            };
        }

        private function setButtnEnable(_arg_1:Sprite, _arg_2:Boolean):void
        {
            _arg_1.mouseEnabled = _arg_2;
            this._fireListFilter = ComponentFactory.Instance.creatFilters("grayFilter");
            _arg_1.filters = ((_arg_2) ? [] : this._fireListFilter);
        }

        private function onCloseClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            if (parent)
            {
                parent.removeChild(this);
            };
        }

        public function dispose():void
        {
            this.removeEvent();
            this.removeView();
        }


    }
}//package church.view.churchFire

