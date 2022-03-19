// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//activity.view.ActivityFirstRechargeView

package activity.view
{
    import com.pickgliss.ui.controls.Frame;
    import flash.display.Bitmap;
    import com.pickgliss.ui.controls.BaseButton;
    import com.pickgliss.ui.controls.container.SimpleTileList;
    import com.pickgliss.ui.controls.ScrollPanel;
    import activity.data.ActivityInfo;
    import activity.ActivityController;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.PlayerManager;
    import road7th.data.DictionaryData;
    import activity.data.ActivityGiftbagInfo;
    import com.pickgliss.events.FrameEvent;
    import flash.events.MouseEvent;
    import ddt.events.PlayerEvent;
    import ddt.manager.SoundManager;
    import ddt.manager.MessageTipManager;
    import ddt.manager.LanguageMgr;
    import ddt.manager.LeavePageManager;
    import com.pickgliss.utils.ObjectUtils;

    public class ActivityFirstRechargeView extends Frame 
    {

        public static const CELL_NUM:int = 6;

        private var _bitmap:Bitmap;
        private var _getButton:BaseButton;
        private var _chargeBtn:BaseButton;
        private var _cellList:SimpleTileList;
        private var _panel:ScrollPanel;
        private var _info:ActivityInfo = ActivityController.instance.checkHasFirstCharge();

        public function ActivityFirstRechargeView()
        {
            this.initView();
            this.initEvent();
        }

        public function show():void
        {
            LayerManager.Instance.addToLayer(this, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
            ActivityController.instance.sendAskForActiviLog(this._info);
        }

        public function hide():void
        {
            if (parent)
            {
                parent.removeChild(this);
            };
        }

        private function initView():void
        {
            this._bitmap = ComponentFactory.Instance.creatBitmap("ddtactivity.ActivityFirstRechargeView.bitmap");
            addToContent(this._bitmap);
            this._chargeBtn = ComponentFactory.Instance.creatComponentByStylename("ddtactivity.ActivityFirstRechargeView.btn");
            addToContent(this._chargeBtn);
            this._getButton = ComponentFactory.Instance.creatComponentByStylename("activity.ActivityFirstRechargeView.GetButton");
            this._getButton.visible = false;
            addToContent(this._getButton);
            this._cellList = ComponentFactory.Instance.creatCustomObject("ddtcalendar.ActivityFirstRechargeView.cellList", [3]);
            addToContent(this._cellList);
            this._panel = ComponentFactory.Instance.creatComponentByStylename("ddtactivity.ActivityFirstRechargeView.cellPanel");
            addToContent(this._panel);
            this._panel.setView(this._cellList);
            this.initCells();
        }

        private function checkBtn():void
        {
            this._getButton.visible = (PlayerManager.Instance.Self.moneyOfCharge > 0);
            this._chargeBtn.visible = ((!(PlayerManager.Instance.Self.moneyOfCharge)) > 0);
        }

        private function initCells():void
        {
            var _local_1:DictionaryData;
            var _local_2:ActivityCell;
            var _local_3:ActivityGiftbagInfo;
            var _local_4:int;
            this.removeCells();
            for each (_local_3 in ActivityController.instance.getAcitivityGiftBagByActID(this._info.ActivityId))
            {
                _local_1 = ActivityController.instance.getRewardsByGiftbagID(_local_3.GiftbagId);
                _local_4 = 0;
                while (_local_4 < _local_1.list.length)
                {
                    _local_2 = new ActivityCell(_local_1.list[_local_4]);
                    _local_2.count = _local_1.list[_local_4].Count;
                    this._cellList.addChild(_local_2);
                    _local_4++;
                };
            };
            this._panel.vScrollProxy = ((this._cellList.numChildren > CELL_NUM) ? 0 : 2);
        }

        private function removeCells():void
        {
            this._cellList.disposeAllChildren();
        }

        private function initEvent():void
        {
            addEventListener(FrameEvent.RESPONSE, this.__response);
            this._getButton.addEventListener(MouseEvent.CLICK, this.__getAward);
            this._chargeBtn.addEventListener(MouseEvent.CLICK, this.__sendCharge);
            PlayerManager.Instance.Self.addEventListener(PlayerEvent.MONEY_CHARGE, this.__moneyChargeHandle);
        }

        private function __getAward(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            if (ActivityController.instance.model.getLog(this._info.ActivityId) > 0)
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.activity.activityFirstRechargeView.hasGet"));
            }
            else
            {
                ActivityController.instance.getActivityAward(this._info);
                this.hide();
            };
        }

        private function __sendCharge(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            if (ActivityController.instance.model.getLog(this._info.ActivityId) > 0)
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.activity.activityFirstRechargeView.hasGet"));
            }
            else
            {
                LeavePageManager.leaveToFillPath();
                this.hide();
            };
        }

        private function __moneyChargeHandle(_arg_1:PlayerEvent):void
        {
            this.checkBtn();
        }

        private function __response(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            switch (_arg_1.responseCode)
            {
                case FrameEvent.CANCEL_CLICK:
                case FrameEvent.ESC_CLICK:
                case FrameEvent.CLOSE_CLICK:
                    this.hide();
                    return;
            };
        }

        private function removeEvent():void
        {
            removeEventListener(FrameEvent.RESPONSE, this.__response);
            this._chargeBtn.removeEventListener(MouseEvent.CLICK, this.__sendCharge);
            PlayerManager.Instance.Self.removeEventListener(PlayerEvent.MONEY_CHARGE, this.__moneyChargeHandle);
        }

        override public function dispose():void
        {
            this.removeEvent();
            this.removeCells();
            ObjectUtils.disposeObject(this._cellList);
            this._cellList = null;
            ObjectUtils.disposeObject(this._bitmap);
            this._bitmap = null;
            ObjectUtils.disposeObject(this._chargeBtn);
            this._chargeBtn = null;
            super.dispose();
        }


    }
}//package activity.view

