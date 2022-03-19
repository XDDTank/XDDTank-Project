﻿// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//fightToolBox.view.YourSelfView

package fightToolBox.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.text.TextArea;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import ddt.manager.SoundManager;
    import ddt.manager.PlayerManager;
    import baglocked.BaglockedManager;
    import fightToolBox.FightToolBoxController;
    import com.pickgliss.ui.AlertManager;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.events.FrameEvent;
    import ddt.manager.LeavePageManager;
    import com.pickgliss.utils.ObjectUtils;

    public class YourSelfView extends Sprite implements Disposeable 
    {

        private var _textArea:TextArea;
        private var _payNum:int;
        private var _level:int;
        private var _moneyConfirm:BaseAlerFrame;
        private var _confirmFrame:BaseAlerFrame;


        public function show():void
        {
            this.visible = true;
        }

        public function hide():void
        {
            this.visible = false;
        }

        public function sendOpen(_arg_1:int):void
        {
            SoundManager.instance.play("008");
            if (PlayerManager.Instance.Self.bagLocked)
            {
                BaglockedManager.Instance.show();
                return;
            };
            switch (_arg_1)
            {
                case 0:
                    this._level = FightToolBoxController.instance.model.fightVipTime_high;
                    this._payNum = FightToolBoxController.instance.model.fightVipPrice_high;
                    break;
                case 1:
                    this._level = FightToolBoxController.instance.model.fightVipTime_mid;
                    this._payNum = FightToolBoxController.instance.model.fightVipPrice_mid;
                    break;
                case 2:
                    this._level = FightToolBoxController.instance.model.fightVipTime_low;
                    this._payNum = FightToolBoxController.instance.model.fightVipPrice_low;
                    break;
            };
            if (PlayerManager.Instance.Self.Money < this._payNum)
            {
                this._moneyConfirm = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("tank.view.comon.lack"), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), false, false, false, LayerManager.ALPHA_BLOCKGOUND);
                this._moneyConfirm.moveEnable = false;
                this._moneyConfirm.addEventListener(FrameEvent.RESPONSE, this.__moneyConfirmHandler);
                return;
            };
            var _local_2:String = LanguageMgr.GetTranslation("FightToolBox.yourselfView.confirmforSelf", this._level, this._payNum);
            this._confirmFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("FightToolBox.ConfirmTitle"), _local_2, LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), false, true, true, LayerManager.BLCAK_BLOCKGOUND);
            this._confirmFrame.moveEnable = false;
            this._confirmFrame.addEventListener(FrameEvent.RESPONSE, this.__confirm);
        }

        private function __moneyConfirmHandler(_arg_1:FrameEvent):void
        {
            this._moneyConfirm.removeEventListener(FrameEvent.RESPONSE, this.__moneyConfirmHandler);
            switch (_arg_1.responseCode)
            {
                case FrameEvent.ENTER_CLICK:
                case FrameEvent.SUBMIT_CLICK:
                    LeavePageManager.leaveToFillPath();
                    break;
            };
            this._moneyConfirm.dispose();
            if (this._moneyConfirm.parent)
            {
                this._moneyConfirm.parent.removeChild(this._moneyConfirm);
            };
            this._moneyConfirm = null;
        }

        private function __confirm(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            this._confirmFrame.removeEventListener(FrameEvent.RESPONSE, this.__confirm);
            switch (_arg_1.responseCode)
            {
                case FrameEvent.SUBMIT_CLICK:
                case FrameEvent.ENTER_CLICK:
                    FightToolBoxController.instance.sendOpen(PlayerManager.Instance.Self.NickName, this._level);
                    break;
            };
            this._confirmFrame.dispose();
            if (this._confirmFrame.parent)
            {
                this._confirmFrame.parent.removeChild(this._confirmFrame);
            };
        }

        private function removeView():void
        {
            if (this._textArea)
            {
                ObjectUtils.disposeObject(this._textArea);
            };
            this._textArea = null;
            if (this._confirmFrame)
            {
                this._confirmFrame.dispose();
            };
            this._confirmFrame = null;
            if (this._moneyConfirm)
            {
                this._moneyConfirm.dispose();
            };
            this._moneyConfirm = null;
        }

        public function dispose():void
        {
            this.removeView();
        }


    }
}//package fightToolBox.view

