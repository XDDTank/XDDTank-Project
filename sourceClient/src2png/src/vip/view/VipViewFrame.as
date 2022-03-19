﻿// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//vip.view.VipViewFrame

package vip.view
{
    import com.pickgliss.ui.controls.Frame;
    import flash.display.Bitmap;
    import com.pickgliss.ui.controls.BaseButton;
    import com.pickgliss.ui.image.Scale9CornerImage;
    import com.pickgliss.ui.image.ScaleBitmapImage;
    import com.pickgliss.ui.image.MutipleImage;
    import com.pickgliss.ui.core.Disposeable;
    import ddt.view.bossbox.VipInfoTipBox;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import ddt.view.bossbox.AwardsViewII;
    import com.pickgliss.ui.text.FilterFrameText;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.utils.PositionUtils;
    import ddt.manager.PlayerManager;
    import ddt.data.player.SelfInfo;
    import flash.events.MouseEvent;
    import com.pickgliss.events.FrameEvent;
    import ddt.manager.SoundManager;
    import vip.VipController;
    import ddt.manager.BossBoxManager;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.ui.AlertManager;
    import ddt.view.bossbox.AwardsView;
    import ddt.data.goods.ItemTemplateInfo;
    import flash.events.Event;
    import road7th.data.DictionaryData;
    import ddt.manager.ItemManager;
    import com.greensock.TweenMax;

    public class VipViewFrame extends Frame 
    {

        private static var _instance:VipViewFrame;
        public static const VIP_LEVEL1:String = "112112";
        public static const VIP_LEVEL2:String = "112113";
        public static const VIP_LEVEL3:String = "112114";
        public static const VIP_LEVEL4:String = "112115";
        public static const VIP_LEVEL5:String = "112116";
        public static const VIP_LEVEL6:String = "112117";
        public static const VIP_LEVEL7:String = "112118";
        public static const VIP_LEVEL8:String = "112119";
        public static const VIP_LEVEL9:String = "112120";
        public static const VIP_LEVEL10:String = "112204";
        public static const VIP_LEVEL11:String = "112205";
        public static const VIP_LEVEL12:String = "112206";
        public static var _vipChestsArr:Array = [VIP_LEVEL1, VIP_LEVEL2, VIP_LEVEL3, VIP_LEVEL4, VIP_LEVEL5, VIP_LEVEL6, VIP_LEVEL7, VIP_LEVEL8, VIP_LEVEL9, VIP_LEVEL10, VIP_LEVEL11, VIP_LEVEL12];
        public static var millisecondsPerDays:int = (((1000 * 60) * 60) * 24);//86400000

        private var _currentVip:Bitmap;
        private var _nextVip:Bitmap;
        private var _receiveBtn:BaseButton;
        private var _receiveShin:Scale9CornerImage;
        private var _openVipBtn:BaseButton;
        private var _BG:ScaleBitmapImage;
        private var _vipViewBg1:MutipleImage;
        private var _vipViewBg2:MutipleImage;
        private var _vipSp:Disposeable;
        private var _vipFrame:VipFrame;
        private var _head:VipFrameHead;
        private var _vipInfoTipBox:VipInfoTipBox;
        private var alertFrame:BaseAlerFrame;
        private var awards:AwardsViewII;
        private var LeftRechargeAlerTxt:VipPrivilegeTxt;
        private var RightRechargeAlerTxt:VipPrivilegeTxt;
        private var _text:FilterFrameText;
        private var _Pattern:Bitmap;
        private var _Pattern1:Bitmap;

        public function VipViewFrame()
        {
            this._init();
        }

        public static function get instance():VipViewFrame
        {
            if ((!(_instance)))
            {
                _instance = new (VipViewFrame)();
            };
            return (_instance);
        }


        private function _init():void
        {
            this.initView();
            this.initEvent();
        }

        private function initView():void
        {
            titleText = LanguageMgr.GetTranslation("ddt.vip.vipViewFrame.title");
            this._BG = ComponentFactory.Instance.creatComponentByStylename("VIPViewFrame.BG");
            this._head = new VipFrameHead();
            this._vipViewBg1 = ComponentFactory.Instance.creatComponentByStylename("vipView.BG1");
            this._vipViewBg2 = ComponentFactory.Instance.creatComponentByStylename("vipView.BG2");
            this._Pattern = ComponentFactory.Instance.creatBitmap("asset.vip.PrivilegeTxtBg");
            this._Pattern1 = ComponentFactory.Instance.creatBitmap("asset.vip.PrivilegeTxtBg");
            PositionUtils.setPos(this._Pattern1, "PrivilegeTxtBgPos");
            this._currentVip = ComponentFactory.Instance.creatBitmap("asset.vip.currentVip");
            this._nextVip = ComponentFactory.Instance.creatBitmap("asset.vip.nextVip");
            this._receiveBtn = ComponentFactory.Instance.creatComponentByStylename("GiveYourselfOpenView.rewardBtn");
            PositionUtils.setPos(this._receiveBtn, "vip.ReceiveBtnPos");
            this._receiveShin = ComponentFactory.Instance.creatComponentByStylename("rewardBtn.shin");
            PositionUtils.setPos(this._receiveShin, "vip.ReceiveShinPos");
            this._openVipBtn = ComponentFactory.Instance.creatComponentByStylename("GiveYourselfOpenView.openVipBtn");
            PositionUtils.setPos(this._openVipBtn, "vip.OpenVipBtnPos");
            this._text = ComponentFactory.Instance.creatComponentByStylename("VipView.Text");
            this._text.text = LanguageMgr.GetTranslation("tank.vip.PrivilegeTxt11");
            addToContent(this._BG);
            addToContent(this._vipViewBg1);
            addToContent(this._vipViewBg2);
            addToContent(this._Pattern);
            addToContent(this._Pattern1);
            addToContent(this._head);
            addToContent(this._currentVip);
            addToContent(this._nextVip);
            addToContent(this._receiveBtn);
            addToContent(this._receiveShin);
            this._receiveShin.mouseEnabled = (this._receiveShin.mouseChildren = false);
            addToContent(this._openVipBtn);
            this.receiveBtnCanUse();
            var _local_1:SelfInfo = PlayerManager.Instance.Self;
            if (_local_1.VIPLevel < 12)
            {
                this.LeftRechargeAlerTxt = new VipPrivilegeTxt();
                this.LeftRechargeAlerTxt.AlertContent = _local_1.VIPLevel;
                PositionUtils.setPos(this.LeftRechargeAlerTxt, "LeftRechageAlerTxtPos");
                this.RightRechargeAlerTxt = new VipPrivilegeTxt();
                this.RightRechargeAlerTxt.AlertContent = (_local_1.VIPLevel + 1);
                PositionUtils.setPos(this.RightRechargeAlerTxt, "RightRechageAlerTxtPos");
                addToContent(this.LeftRechargeAlerTxt);
                addToContent(this.RightRechargeAlerTxt);
            };
            if (_local_1.VIPLevel == 12)
            {
                this.LeftRechargeAlerTxt = new VipPrivilegeTxt();
                this.LeftRechargeAlerTxt.AlertContent = 12;
                PositionUtils.setPos(this.LeftRechargeAlerTxt, "LeftRechageAlerTxtPos");
                addToContent(this.LeftRechargeAlerTxt);
                addToContent(this._text);
            };
        }

        private function initEvent():void
        {
            this._receiveBtn.addEventListener(MouseEvent.CLICK, this.__receive);
            this._openVipBtn.addEventListener(MouseEvent.CLICK, this.__openVipHandler);
            addEventListener(FrameEvent.RESPONSE, this.__frameEventHandler);
        }

        private function removeEvent():void
        {
            this._receiveBtn.removeEventListener(MouseEvent.CLICK, this.__receive);
            this._openVipBtn.removeEventListener(MouseEvent.CLICK, this.__openVipHandler);
            removeEventListener(FrameEvent.RESPONSE, this.__frameEventHandler);
        }

        private function __openVipHandler(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            if (this._vipFrame == null)
            {
                this._vipFrame = ComponentFactory.Instance.creatComponentByStylename("vip.VipFrame");
            };
            this._vipFrame.show();
            VipController.instance.hide();
        }

        private function __receive(_arg_1:MouseEvent):void
        {
            var _local_2:int;
            var _local_3:Date;
            var _local_4:Date;
            SoundManager.instance.play("008");
            if (((PlayerManager.Instance.Self.canTakeVipReward) || (PlayerManager.Instance.Self.IsVIP == false)))
            {
                this._vipInfoTipBox = ComponentFactory.Instance.creat("vip.VipInfoTipFrame");
                this._vipInfoTipBox.escEnable = true;
                this._vipInfoTipBox.vipAwardGoodsList = this.getVIPInfoTip(BossBoxManager.instance.inventoryItemList);
                this._vipInfoTipBox.addEventListener(FrameEvent.RESPONSE, this.__responseVipInfoTipHandler);
                LayerManager.Instance.addToLayer(this._vipInfoTipBox, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
            }
            else
            {
                _local_2 = 0;
                _local_3 = (PlayerManager.Instance.Self.systemDate as Date);
                _local_4 = new Date();
                this.alertFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("ddt.vip.vipView.cueDateScript", (_local_4.month + 1), (_local_4.date + 1)), LanguageMgr.GetTranslation("ok"), "", false, false, false, LayerManager.ALPHA_BLOCKGOUND);
                this.alertFrame.moveEnable = false;
                this.alertFrame.addEventListener(FrameEvent.RESPONSE, this.__alertHandler);
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

        private function __sendReward(_arg_1:Event):void
        {
            SoundManager.instance.play("008");
            this.awards.removeEventListener(AwardsView.HAVEBTNCLICK, this.__sendReward);
            this.awards.dispose();
            PlayerManager.Instance.Self.canTakeVipReward = false;
            this.receiveBtnCanUse();
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

        private function _getStrArr(_arg_1:DictionaryData):Array
        {
            return (_arg_1[_vipChestsArr[(PlayerManager.Instance.Self.VIPLevel - 1)]]);
        }

        private function getVIPInfoTip(_arg_1:DictionaryData):Array
        {
            var _local_2:Array;
            return ((PlayerManager.Instance.Self.VIPLevel == 12) ? [ItemManager.Instance.getTemplateById(int(_vipChestsArr[(PlayerManager.Instance.Self.VIPLevel - 1)])), ItemManager.Instance.getTemplateById(int(_vipChestsArr[(PlayerManager.Instance.Self.VIPLevel - 2)]))] : [ItemManager.Instance.getTemplateById(int(_vipChestsArr[(PlayerManager.Instance.Self.VIPLevel - 1)])), ItemManager.Instance.getTemplateById(int(_vipChestsArr[PlayerManager.Instance.Self.VIPLevel]))]);
        }

        private function receiveBtnCanUse():void
        {
            if (PlayerManager.Instance.Self.IsVIP)
            {
                if (PlayerManager.Instance.Self.canTakeVipReward)
                {
                    this._receiveShin.alpha = 1;
                    this._receiveShin.visible = true;
                    TweenMax.to(this._receiveShin, 0.5, {
                        "alpha":0,
                        "yoyo":true,
                        "repeat":-1
                    });
                }
                else
                {
                    this._receiveShin.visible = false;
                    TweenMax.killChildTweensOf(this._receiveShin);
                };
            }
            else
            {
                this._receiveShin.visible = false;
                TweenMax.killChildTweensOf(this._receiveShin);
            };
        }

        private function __frameEventHandler(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            switch (_arg_1.responseCode)
            {
                case FrameEvent.ESC_CLICK:
                case FrameEvent.CLOSE_CLICK:
                    VipController.instance.hide();
                    return;
            };
        }

        public function show():void
        {
            LayerManager.Instance.addToLayer(this, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.ALPHA_BLOCKGOUND);
        }

        public function hide():void
        {
            if (this._vipFrame != null)
            {
                this._vipFrame.dispose();
            };
            this._vipFrame = null;
        }

        override public function dispose():void
        {
            super.dispose();
            this.removeEvent();
            if (this._BG)
            {
                this._BG.dispose();
            };
            this._BG = null;
            if (this._head)
            {
                this._head.dispose();
                this._head = null;
            };
            if (this._vipViewBg1)
            {
                this._vipViewBg1.dispose();
            };
            this._vipViewBg1 = null;
            if (this._vipViewBg2)
            {
                this._vipViewBg2.dispose();
            };
            this._vipViewBg2 = null;
            if (this._receiveBtn)
            {
                this._receiveBtn.dispose();
            };
            this._receiveBtn = null;
            if (this._openVipBtn)
            {
                this._openVipBtn.dispose();
            };
            this._openVipBtn = null;
            if (this.parent)
            {
                this.parent.removeChild(this);
            };
        }


    }
}//package vip.view

