// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//vip.view.VipFrameHeadOne

package vip.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.image.ScaleBitmapImage;
    import com.pickgliss.ui.controls.BaseButton;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.LanguageMgr;
    import ddt.utils.PositionUtils;
    import ddt.manager.PlayerManager;
    import ddt.events.PlayerPropertyEvent;
    import flash.events.MouseEvent;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import ddt.manager.SoundManager;
    import baglocked.BaglockedManager;
    import ddt.manager.LeavePageManager;
    import com.pickgliss.ui.AlertManager;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.events.FrameEvent;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.manager.ItemManager;
    import ddt.data.EquipType;
    import ddt.data.goods.ItemTemplateInfo;
    import ddt.manager.SocketManager;

    public class VipFrameHeadOne extends Sprite implements Disposeable 
    {

        private var _topBG:ScaleBitmapImage;
        private var _buyPackageBtn:BaseButton;
        private var _dueDataWord:FilterFrameText;
        private var _dueData:FilterFrameText;
        private var _buyPackageTxt:FilterFrameText;
        private var _buyPackageTxt1:FilterFrameText;
        private var _price:int = 6680;

        public function VipFrameHeadOne()
        {
            this._init();
            this.addEvent();
        }

        private function _init():void
        {
            this._topBG = ComponentFactory.Instance.creatComponentByStylename("VIPFrame.topBG1");
            this._buyPackageBtn = ComponentFactory.Instance.creatComponentByStylename("vip.buyPackageBtn");
            this._buyPackageTxt = ComponentFactory.Instance.creatComponentByStylename("vip.buyPackageTxt");
            this._buyPackageTxt.text = LanguageMgr.GetTranslation("ddt.vip.vipFrameHead.text");
            this._buyPackageTxt1 = ComponentFactory.Instance.creatComponentByStylename("vip.buyPackageTxt");
            PositionUtils.setPos(this._buyPackageTxt1, "buyPackagePos");
            this._buyPackageTxt1.text = LanguageMgr.GetTranslation("ddt.vip.vipFrameHead.text1");
            this._dueDataWord = ComponentFactory.Instance.creatComponentByStylename("VipStatusView.dueDateFontTxt");
            this._dueDataWord.text = LanguageMgr.GetTranslation("ddt.vip.dueDateFontTxt");
            PositionUtils.setPos(this._dueDataWord, "dueDataWordTxtPos");
            this._dueData = ComponentFactory.Instance.creat("VipStatusView.dueDate");
            PositionUtils.setPos(this._dueData, "dueDataTxtPos");
            addChild(this._topBG);
            addChild(this._buyPackageBtn);
            addChild(this._buyPackageTxt);
            addChild(this._buyPackageTxt1);
            addChild(this._dueDataWord);
            addChild(this._dueData);
            this.upView();
        }

        private function addEvent():void
        {
            PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE, this.__propertyChange);
            this._buyPackageBtn.addEventListener(MouseEvent.CLICK, this.__onBuyClick);
        }

        private function __onBuyClick(_arg_1:MouseEvent):void
        {
            var _local_2:BaseAlerFrame;
            _arg_1.stopImmediatePropagation();
            SoundManager.instance.play("008");
            if (PlayerManager.Instance.Self.bagLocked)
            {
                BaglockedManager.Instance.show();
                return;
            };
            if (PlayerManager.Instance.Self.Money < this._price)
            {
                LeavePageManager.showFillFrame();
                return;
            };
            _local_2 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("tank.vip.view.buyVipGift"), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), true, true, true, LayerManager.ALPHA_BLOCKGOUND);
            _local_2.mouseEnabled = false;
            _local_2.addEventListener(FrameEvent.RESPONSE, this._responseI);
        }

        private function _responseI(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            (_arg_1.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE, this._responseI);
            if (((_arg_1.responseCode == FrameEvent.SUBMIT_CLICK) || (_arg_1.responseCode == FrameEvent.ENTER_CLICK)))
            {
                this.dobuy();
            };
            ObjectUtils.disposeObject(_arg_1.target);
        }

        private function dobuy():void
        {
            var _local_1:Array = new Array();
            var _local_2:Array = new Array();
            var _local_3:Array = new Array();
            var _local_4:Array = new Array();
            var _local_5:Array = new Array();
            var _local_6:Array = [];
            var _local_7:ItemTemplateInfo = ItemManager.Instance.getTemplateById(EquipType.VIP_GIFT_BAG);
            _local_1.push(_local_7.TemplateID);
            _local_2.push("1");
            _local_3.push("");
            _local_4.push("");
            _local_5.push("");
            _local_6.push("1");
            SocketManager.Instance.out.sendBuyGoods(_local_1, _local_2, _local_3, _local_5, _local_4, null, 0, _local_6);
        }

        private function removeEvent():void
        {
            PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE, this.__propertyChange);
            this._buyPackageBtn.removeEventListener(MouseEvent.CLICK, this.__onBuyClick);
        }

        private function __propertyChange(_arg_1:PlayerPropertyEvent):void
        {
            if ((((_arg_1.changedProperties["isVip"]) || (_arg_1.changedProperties["VipExpireDay"])) || (_arg_1.changedProperties["VIPNextLevelDaysNeeded"])))
            {
                this.upView();
            };
        }

        private function upView():void
        {
            var _local_1:Date = (PlayerManager.Instance.Self.VIPExpireDay as Date);
            this._dueData.text = ((((_local_1.fullYear + "-") + (_local_1.month + 1)) + "-") + _local_1.date);
            if ((!(PlayerManager.Instance.Self.IsVIP)))
            {
                this._dueData.text = "";
            };
        }

        public function dispose():void
        {
            this.removeEvent();
            if (this._topBG)
            {
                ObjectUtils.disposeObject(this._topBG);
            };
            this._topBG = null;
            if (this._buyPackageTxt)
            {
                ObjectUtils.disposeObject(this._buyPackageTxt);
            };
            this._buyPackageTxt = null;
            if (this._buyPackageTxt1)
            {
                ObjectUtils.disposeObject(this._buyPackageTxt1);
            };
            this._buyPackageTxt1 = null;
        }


    }
}//package vip.view

