// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//store.view.Compose.StoreIIComposeBG

package store.view.Compose
{
    import flash.display.Sprite;
    import store.IStoreViewBG;
    import store.StoreDragInArea;
    import com.pickgliss.ui.image.MutipleImage;
    import flash.display.Bitmap;
    import store.view.Compose.view.ComposeMaterialShow;
    import store.view.Compose.view.ComposeItemsView;
    import flash.display.MovieClip;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import ddt.command.QuickBuyFrame;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.data.goods.InventoryItemInfo;
    import ddt.manager.SocketManager;
    import ddt.data.BagInfo;
    import ddt.manager.MessageTipManager;
    import ddt.manager.LanguageMgr;
    import bagAndInfo.cell.BagCell;
    import flash.utils.Dictionary;
    import com.pickgliss.utils.ClassUtils;
    import flash.events.Event;
    import ddt.utils.PositionUtils;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.manager.PlayerManager;
    import baglocked.BaglockedManager;
    import com.pickgliss.ui.AlertManager;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.events.FrameEvent;
    import ddt.manager.SoundManager;
    import ddt.data.EquipType;
    import flash.events.MouseEvent;
    import store.HelpPrompt;
    import store.HelpFrame;

    public class StoreIIComposeBG extends Sprite implements IStoreViewBG 
    {

        public static const MAX_COUNT:int = 99;

        private var _area:StoreDragInArea;
        private var _mainCellArray:Array;
        private var _bg:MutipleImage;
        private var _composeTitle:Bitmap;
        private var _composeMaterialShow:ComposeMaterialShow;
        public var START_COMPOSE:int = 0;
        private var _composeItemsView:ComposeItemsView;
        private var _composeUpgrades:MovieClip;
        private var _goldAlertFrame:BaseAlerFrame;
        private var _quickBuyFrame:QuickBuyFrame;

        public function StoreIIComposeBG()
        {
            this.init();
            this.initEvent();
        }

        private function init():void
        {
            this._mainCellArray = new Array();
            this._composeTitle = ComponentFactory.Instance.creatBitmap("asset.ddtstore.ComposeTitle");
            this._area = new StoreDragInArea(this._mainCellArray);
            this.hide();
            this._composeMaterialShow = new ComposeMaterialShow();
            addChild(this._composeMaterialShow);
            this._composeItemsView = ComponentFactory.Instance.creatCustomObject("ddtstore.ComposeItemsView");
            addChild(this._composeItemsView);
        }

        public function setCell(_arg_1:BagCell):void
        {
            var _local_2:int;
            var _local_3:InventoryItemInfo = (_arg_1.info as InventoryItemInfo);
            if (ComposeController.instance.model.composeItemInfoDic[_local_3.TemplateID])
            {
                SocketManager.Instance.out.sendMoveGoods(_local_3.BagType, _local_3.Place, BagInfo.STOREBAG, _local_2, _local_3.Count, true);
            }
            else
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.StoreIIComposeBG.cannotCompose"));
            };
        }

        public function startShine(_arg_1:int):void
        {
        }

        public function refreshData(_arg_1:Dictionary):void
        {
            this._composeMaterialShow.info = this._composeMaterialShow.info;
        }

        public function updateData():void
        {
        }

        public function stopShine():void
        {
        }

        private function initEvent():void
        {
            this._composeMaterialShow.addEventListener(ComposeEvents.START_COMPOSE, this.__sendCompose);
            ComposeController.instance.addEventListener(ComposeController.COMPOSE_PLAY, this.__playMc);
        }

        private function __playMc(_arg_1:Event):void
        {
            if ((!(this._composeUpgrades)))
            {
                this._composeUpgrades = ClassUtils.CreatInstance("asset.strength.weaponUpgrades");
            };
            this._composeUpgrades.gotoAndPlay(1);
            this._composeUpgrades.addEventListener(Event.ENTER_FRAME, this.__composeUpgradesFrame);
            PositionUtils.setPos(this._composeUpgrades, "ddtstore.StoreIIStrengthBG.composeUpgradesPoint");
            addChild(this._composeUpgrades);
        }

        private function __composeUpgradesFrame(_arg_1:Event):void
        {
            if (this._composeUpgrades)
            {
                if (this._composeUpgrades.currentFrame == this._composeUpgrades.totalFrames)
                {
                    this.removeComposeUpgradesMovie();
                };
            };
        }

        private function removeComposeUpgradesMovie():void
        {
            if (this._composeUpgrades.hasEventListener(Event.ENTER_FRAME))
            {
                this._composeUpgrades.removeEventListener(Event.ENTER_FRAME, this.__composeUpgradesFrame);
            };
            if (this.contains(this._composeUpgrades))
            {
                this.removeChild(this._composeUpgrades);
            };
            if (this._composeUpgrades)
            {
                this._composeUpgrades.stop();
                ObjectUtils.disposeObject(this._composeUpgrades);
                this._composeUpgrades = null;
            };
        }

        private function __sendCompose(_arg_1:ComposeEvents):void
        {
            var _local_2:BaseAlerFrame;
            if (this._composeMaterialShow.info)
            {
                if (PlayerManager.Instance.Self.bagLocked)
                {
                    BaglockedManager.Instance.show();
                    return;
                };
                if (this._composeMaterialShow.getBind())
                {
                    _local_2 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("store.StoreIIComposeBG.use"), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), false, false, false, LayerManager.ALPHA_BLOCKGOUND);
                    _local_2.moveEnable = false;
                    _local_2.info.enableHtml = true;
                    _local_2.info.mutiline = true;
                    _local_2.addEventListener(FrameEvent.RESPONSE, this._bingResponse);
                }
                else
                {
                    this.sendSocket();
                };
            }
            else
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.StoreIIComposeBG.selectComposeItem"));
            };
        }

        private function sendSocket():void
        {
            SocketManager.Instance.out.sendItemCompose(this.START_COMPOSE, this._composeMaterialShow.info.TemplateID, this._composeMaterialShow.composeCount);
        }

        public function show():void
        {
            this.visible = true;
        }

        public function hide():void
        {
            this.visible = false;
        }

        public function get area():Array
        {
            return (null);
        }

        private function _bingResponse(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            var _local_2:BaseAlerFrame = (_arg_1.currentTarget as BaseAlerFrame);
            _local_2.removeEventListener(FrameEvent.RESPONSE, this._bingResponse);
            if (((_arg_1.responseCode == FrameEvent.SUBMIT_CLICK) || (_arg_1.responseCode == FrameEvent.ENTER_CLICK)))
            {
                this.sendSocket();
            };
            ObjectUtils.disposeObject(_arg_1.target);
        }

        private function __quickBuyResponse(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            this._goldAlertFrame.removeEventListener(FrameEvent.RESPONSE, this.__quickBuyResponse);
            this._goldAlertFrame.dispose();
            this._goldAlertFrame = null;
            if (_arg_1.responseCode == FrameEvent.SUBMIT_CLICK)
            {
                this._quickBuyFrame = ComponentFactory.Instance.creatComponentByStylename("ddtcore.QuickFrame");
                this._quickBuyFrame.itemID = EquipType.GOLD_BOX;
                this._quickBuyFrame.setTitleText(LanguageMgr.GetTranslation("tank.view.store.matte.goldQuickBuy"));
                LayerManager.Instance.addToLayer(this._quickBuyFrame, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
            };
        }

        private function __openHelp(_arg_1:MouseEvent):void
        {
        }

        public function dispose():void
        {
            this._mainCellArray = null;
            this._composeMaterialShow.removeEventListener(ComposeEvents.START_COMPOSE, this.__sendCompose);
            if (this._composeItemsView)
            {
                ObjectUtils.disposeObject(this._composeItemsView);
            };
            this._composeItemsView = null;
            if (this._composeMaterialShow)
            {
                ObjectUtils.disposeObject(this._composeMaterialShow);
            };
            this._composeMaterialShow = null;
            if (this._area)
            {
                this._area.dispose();
            };
            this._area = null;
            if (this._bg)
            {
                ObjectUtils.disposeObject(this._bg);
            };
            this._bg = null;
            if (parent)
            {
                parent.removeChild(this);
            };
            if (this._composeTitle)
            {
                ObjectUtils.disposeObject(this._composeTitle);
            };
            this._composeTitle = null;
            if (this._goldAlertFrame)
            {
                ObjectUtils.disposeObject(this._goldAlertFrame);
            };
            this._goldAlertFrame = null;
            if (this._quickBuyFrame)
            {
                ObjectUtils.disposeObject(this._quickBuyFrame);
            };
            this._quickBuyFrame = null;
            if (this._composeUpgrades)
            {
                this._composeUpgrades.stop();
                ObjectUtils.disposeObject(this._composeUpgrades);
                this._composeUpgrades = null;
            };
        }

        public function openHelp():void
        {
            var _local_1:HelpPrompt = ComponentFactory.Instance.creat("ddtstore.ComposeHelpPrompt");
            var _local_2:HelpFrame = ComponentFactory.Instance.creat("ddtstore.HelpFrame");
            _local_2.setView(_local_1);
            _local_2.titleText = LanguageMgr.GetTranslation("store.StoreIIComposeBG.say");
            LayerManager.Instance.addToLayer(_local_2, LayerManager.STAGE_DYANMIC_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
        }


    }
}//package store.view.Compose

