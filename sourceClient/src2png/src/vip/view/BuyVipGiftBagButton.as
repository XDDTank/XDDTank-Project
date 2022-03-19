// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//vip.view.BuyVipGiftBagButton

package vip.view
{
    import com.pickgliss.ui.controls.BaseButton;
    import com.pickgliss.ui.ComponentFactory;
    import flash.events.MouseEvent;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import ddt.manager.SoundManager;
    import ddt.manager.PlayerManager;
    import baglocked.BaglockedManager;
    import ddt.manager.LeavePageManager;
    import com.pickgliss.ui.AlertManager;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.events.FrameEvent;
    import com.pickgliss.utils.ObjectUtils;

    public class BuyVipGiftBagButton extends BaseButton 
    {

        public static const VIPGIFTBAG_PRICE:int = 6680;

        private var _buyPackageBtn:BaseButton;

        public function BuyVipGiftBagButton()
        {
            this._init();
            this._addEvent();
        }

        private function _init():void
        {
            this._buyPackageBtn = ComponentFactory.Instance.creatComponentByStylename("vip.buyPackageBtn");
            addChild(this._buyPackageBtn);
        }

        public function _addEvent():void
        {
            this._buyPackageBtn.addEventListener(MouseEvent.CLICK, this.__onbuyMouseCilck);
        }

        private function __onbuyMouseCilck(_arg_1:MouseEvent):void
        {
            var _local_2:BaseAlerFrame;
            if (_enable)
            {
                _arg_1.stopImmediatePropagation();
                SoundManager.instance.play("008");
                if (PlayerManager.Instance.Self.bagLocked)
                {
                    BaglockedManager.Instance.show();
                    return;
                };
                if (PlayerManager.Instance.Self.Money < VIPGIFTBAG_PRICE)
                {
                    LeavePageManager.showFillFrame();
                    return;
                };
                _local_2 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("tank.vip.view.buyVipGift"), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), false, true, false, LayerManager.ALPHA_BLOCKGOUND);
                _local_2.mouseEnabled = false;
                _local_2.addEventListener(FrameEvent.RESPONSE, this._responseI);
            };
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
        }


    }
}//package vip.view

