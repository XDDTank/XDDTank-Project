// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//mainbutton.AwardFrame

package mainbutton
{
    import com.pickgliss.ui.controls.Frame;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.image.MutipleImage;
    import com.pickgliss.ui.controls.BaseButton;
    import ddt.view.bossbox.VipInfoTipBox;
    import ddt.view.bossbox.AwardsViewII;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.ComponentFactory;
    import flash.events.MouseEvent;
    import com.pickgliss.events.FrameEvent;
    import ddt.manager.SoundManager;
    import calendar.CalendarManager;
    import ddt.manager.PlayerManager;
    import vip.VipController;
    import ddt.manager.BossBoxManager;
    import com.pickgliss.ui.LayerManager;
    import ddt.view.UIModuleSmallLoading;
    import flash.events.Event;
    import com.pickgliss.loader.UIModuleLoader;
    import com.pickgliss.events.UIModuleEvent;
    import ddt.data.UIModuleTypes;
    import ddt.utils.DatetimeHelper;
    import com.pickgliss.ui.AlertManager;
    import ddt.manager.ItemManager;
    import vip.view.VipViewFrame;
    import road7th.data.DictionaryData;
    import ddt.view.bossbox.AwardsView;
    import ddt.data.goods.ItemTemplateInfo;
    import com.pickgliss.utils.ObjectUtils;

    public class AwardFrame extends Frame 
    {

        private var _text:FilterFrameText;
        private var _topImgBG:MutipleImage;
        private var _getButton:BaseButton;
        private var _vipBtn:BaseButton;
        private var _vipInfoTipBox:VipInfoTipBox;
        private var awards:AwardsViewII;
        private var alertFrame:BaseAlerFrame;

        public function AwardFrame()
        {
            this.initView();
            this.addEvent();
        }

        private function initView():void
        {
            titleText = LanguageMgr.GetTranslation("ddt.getReward");
            this._text = ComponentFactory.Instance.creatComponentByStylename("mainbtn.award.text");
            this._text.htmlText = LanguageMgr.GetTranslation("ddt.Reward.get");
            addToContent(this._text);
            this._topImgBG = ComponentFactory.Instance.creatComponentByStylename("mainbtn.award.topBg");
            addToContent(this._topImgBG);
            this._getButton = ComponentFactory.Instance.creatComponentByStylename("mainbtn.award.dailyGetButton");
            addToContent(this._getButton);
            this._vipBtn = ComponentFactory.Instance.creatComponentByStylename("mainbtn.award.vipBigButton");
        }

        private function addEvent():void
        {
            this._getButton.addEventListener(MouseEvent.CLICK, this.__getAward);
            this._vipBtn.addEventListener(MouseEvent.CLICK, this.__vipOpen);
            addEventListener(FrameEvent.RESPONSE, this.__confirmResponse);
        }

        private function __getAward(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            CalendarManager.getInstance().reciveDayAward();
        }

        private function __vipOpen(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            this.showVipPackage();
        }

        private function showVipPackage():void
        {
            var _local_1:int;
            var _local_2:Date;
            var _local_3:Date;
            if (((PlayerManager.Instance.Self.canTakeVipReward) || (PlayerManager.Instance.Self.IsVIP == false)))
            {
                if (VipController.loadComplete)
                {
                    this._vipInfoTipBox = ComponentFactory.Instance.creat("vip.VipInfoTipFrame");
                    this._vipInfoTipBox.escEnable = true;
                    this._vipInfoTipBox.vipAwardGoodsList = this.getVIPInfoTip(BossBoxManager.instance.inventoryItemList);
                    this._vipInfoTipBox.addEventListener(FrameEvent.RESPONSE, this.__responseVipInfoTipHandler);
                    LayerManager.Instance.addToLayer(this._vipInfoTipBox, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
                }
                else
                {
                    if (VipController.useFirst)
                    {
                        UIModuleSmallLoading.Instance.progress = 0;
                        UIModuleSmallLoading.Instance.show();
                        UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE, this.__onClose);
                        UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS, this.__progressShow);
                        UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__complainShow);
                        UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.VIP_VIEW);
                        VipController.useFirst = false;
                    };
                };
            }
            else
            {
                _local_1 = 0;
                _local_2 = (PlayerManager.Instance.Self.systemDate as Date);
                _local_3 = new Date();
                _local_3.setTime((_local_3.getTime() + DatetimeHelper.millisecondsPerDay));
                this.alertFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("ddt.vip.vipView.cueDateScript", (_local_3.month + 1), _local_3.date), LanguageMgr.GetTranslation("ok"), "", false, false, false, LayerManager.ALPHA_BLOCKGOUND);
                this.alertFrame.moveEnable = false;
                this.alertFrame.addEventListener(FrameEvent.RESPONSE, this.__alertHandler);
            };
        }

        private function getVIPInfoTip(_arg_1:DictionaryData):Array
        {
            var _local_2:Array;
            return ((PlayerManager.Instance.Self.VIPLevel == 12) ? [ItemManager.Instance.getTemplateById(int(VipViewFrame._vipChestsArr[(PlayerManager.Instance.Self.VIPLevel - 2)])), ItemManager.Instance.getTemplateById(int(VipViewFrame._vipChestsArr[(PlayerManager.Instance.Self.VIPLevel - 1)]))] : [ItemManager.Instance.getTemplateById(int(VipViewFrame._vipChestsArr[(PlayerManager.Instance.Self.VIPLevel - 1)])), ItemManager.Instance.getTemplateById(int(VipViewFrame._vipChestsArr[PlayerManager.Instance.Self.VIPLevel]))]);
        }

        private function __responseVipInfoTipHandler(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            this._vipInfoTipBox.removeEventListener(FrameEvent.RESPONSE, this.__responseHandler);
            switch (_arg_1.responseCode)
            {
                case FrameEvent.CLOSE_CLICK:
                case FrameEvent.ESC_CLICK:
                    this._vipInfoTipBox.dispose();
                    this._vipInfoTipBox = null;
                    return;
                case FrameEvent.ENTER_CLICK:
                    this.showAwards(this._vipInfoTipBox.selectCellInfo);
                    this._vipInfoTipBox.dispose();
                    this._vipInfoTipBox = null;
                    return;
            };
        }

        private function __onClose(_arg_1:Event):void
        {
            UIModuleSmallLoading.Instance.hide();
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE, this.__onClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS, this.__progressShow);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__complainShow);
        }

        private function __progressShow(_arg_1:UIModuleEvent):void
        {
            if (_arg_1.module == UIModuleTypes.VIP_VIEW)
            {
                UIModuleSmallLoading.Instance.progress = (_arg_1.loader.progress * 100);
            };
        }

        private function __complainShow(_arg_1:UIModuleEvent):void
        {
            if (_arg_1.module == UIModuleTypes.VIP_VIEW)
            {
                UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE, this.__onClose);
                UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS, this.__progressShow);
                UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__complainShow);
                UIModuleSmallLoading.Instance.hide();
                VipController.loadComplete = true;
                this.showVipPackage();
            };
        }

        private function __alertHandler(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            this.alertFrame.removeEventListener(FrameEvent.RESPONSE, this.__alertHandler);
            if (((this.alertFrame) && (this.alertFrame.parent)))
            {
                this.alertFrame.parent.removeChild(this.alertFrame);
            };
            if (this.alertFrame)
            {
                this.alertFrame.dispose();
            };
            this.alertFrame = null;
        }

        private function __responseHandler(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            this.awards.removeEventListener(FrameEvent.RESPONSE, this.__responseHandler);
            switch (_arg_1.responseCode)
            {
                case FrameEvent.CLOSE_CLICK:
                case FrameEvent.ESC_CLICK:
                    this.awards.dispose();
                    this.awards = null;
                    return;
            };
        }

        private function showAwards(_arg_1:ItemTemplateInfo):void
        {
            this.awards = ComponentFactory.Instance.creat("vip.awardFrame");
            this.awards.escEnable = true;
            this.awards.boxType = 2;
            this.awards.vipAwardGoodsList = this._getStrArr(BossBoxManager.instance.inventoryItemList);
            this.awards.addEventListener(FrameEvent.RESPONSE, this.__responseHandler);
            this.awards.addEventListener(AwardsView.HAVEBTNCLICK, this.__sendReward);
            LayerManager.Instance.addToLayer(this.awards, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
        }

        private function _getStrArr(_arg_1:DictionaryData):Array
        {
            return (_arg_1[VipViewFrame._vipChestsArr[(PlayerManager.Instance.Self.VIPLevel - 1)]]);
        }

        private function __sendReward(_arg_1:Event):void
        {
            SoundManager.instance.play("008");
            this.awards.removeEventListener(AwardsView.HAVEBTNCLICK, this.__sendReward);
            this.awards.dispose();
            PlayerManager.Instance.Self.canTakeVipReward = false;
        }

        private function __confirmResponse(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            removeEventListener(FrameEvent.RESPONSE, this.__confirmResponse);
            switch (_arg_1.responseCode)
            {
                case FrameEvent.CLOSE_CLICK:
                    this.dispose();
                    return;
                case FrameEvent.ESC_CLICK:
                    this.dispose();
                    return;
            };
        }

        override public function dispose():void
        {
            ObjectUtils.disposeObject(this._text);
            this._text = null;
            if (this._topImgBG)
            {
                ObjectUtils.disposeObject(this._topImgBG);
            };
            this._topImgBG = null;
            if (this._getButton)
            {
                ObjectUtils.disposeObject(this._getButton);
            };
            this._getButton = null;
            if (this._vipBtn)
            {
                ObjectUtils.disposeObject(this._vipBtn);
            };
            this._vipBtn = null;
            super.dispose();
        }


    }
}//package mainbutton

