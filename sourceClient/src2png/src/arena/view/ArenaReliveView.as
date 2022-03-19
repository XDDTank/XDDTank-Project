// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//arena.view.ArenaReliveView

package arena.view
{
    import com.pickgliss.ui.controls.Frame;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.controls.TextButton;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import com.pickgliss.ui.controls.SelectedCheckButton;
    import com.pickgliss.ui.LayerManager;
    import ddt.manager.TimeManager;
    import ddt.events.TimeEvents;
    import arena.ArenaManager;
    import arena.model.ArenaPlayerStates;
    import flash.events.Event;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.events.FrameEvent;
    import com.pickgliss.utils.ObjectUtils;
    import com.pickgliss.ui.ComponentFactory;
    import flash.events.MouseEvent;
    import ddt.manager.SoundManager;
    import com.pickgliss.ui.AlertManager;
    import ddt.manager.PlayerManager;
    import baglocked.BaglockedManager;
    import ddt.manager.LeavePageManager;

    public class ArenaReliveView extends Frame 
    {

        public static const TIME:int = 10;

        private var _showTxt:FilterFrameText;
        private var _timeTxt:FilterFrameText;
        private var _reliveHere:TextButton;
        private var _reliveSafety:TextButton;
        private var _reliveHereAlert:BaseAlerFrame;
        private var _moneyConfirm:BaseAlerFrame;
        private var _checkBtn:SelectedCheckButton;
        private var _tick:int;


        public function show():void
        {
            LayerManager.Instance.addToLayer(this, LayerManager.GAME_TOP_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
            this._tick = TIME;
            TimeManager.addEventListener(TimeEvents.SECONDS, this.__everySeconds);
        }

        public function isShow():Boolean
        {
            return ((parent) ? true : false);
        }

        public function hide():void
        {
            ArenaManager.instance.model.selfInfo.playerStauts = ArenaPlayerStates.NORMAL;
            dispatchEvent(new Event(Event.CLOSE));
        }

        private function __everySeconds(_arg_1:TimeEvents):void
        {
            this._tick--;
            if (this._timeTxt)
            {
                this._timeTxt.htmlText = LanguageMgr.GetTranslation("ddt.arena.arenareliveview.timetxt", this._tick);
            };
            if (this._tick == 0)
            {
                TimeManager.removeEventListener(TimeEvents.SECONDS, this.__everySeconds);
                ArenaManager.instance.sendRelive(1);
                this.hide();
                if (this._reliveHereAlert)
                {
                    this._reliveHereAlert.removeEventListener(FrameEvent.RESPONSE, this.__confirmResponse);
                    ObjectUtils.disposeObject(this._reliveHereAlert);
                    this._reliveHereAlert = null;
                };
            };
        }

        override protected function init():void
        {
            super.init();
            titleText = LanguageMgr.GetTranslation("AlertDialog.Info");
            this._showTxt = ComponentFactory.Instance.creatComponentByStylename("ddtarena.arenaReliveView.showTxt");
            this._showTxt.htmlText = LanguageMgr.GetTranslation("ddt.arena.arenareliveview.showtxt", 10);
            addToContent(this._showTxt);
            this._timeTxt = ComponentFactory.Instance.creatComponentByStylename("ddtarena.arenaReliveView.timeTxt");
            this._timeTxt.htmlText = LanguageMgr.GetTranslation("ddt.arena.arenareliveview.timetxt", TIME);
            addToContent(this._timeTxt);
            this._reliveHere = ComponentFactory.Instance.creatComponentByStylename("ddtarena.arenaReliveView.reliveHereBtn");
            this._reliveHere.text = LanguageMgr.GetTranslation("ddt.arena.arenareliveview.relivehere");
            addToContent(this._reliveHere);
            this._reliveSafety = ComponentFactory.Instance.creatComponentByStylename("ddtarena.arenaReliveView.reliveSafetyBtn");
            this._reliveSafety.text = LanguageMgr.GetTranslation("ddt.arena.arenareliveview.reliveSafety");
            addToContent(this._reliveSafety);
            this._checkBtn = ComponentFactory.Instance.creatComponentByStylename("ddtarena.arenaReliveView.checkButton");
            this._checkBtn.selected = (!(ArenaManager.instance.model.reliveAlertShow));
            this._checkBtn.text = LanguageMgr.GetTranslation("ddt.arena.arenareliveview。reliveCheckTxt");
            this.initEvent();
        }

        private function initEvent():void
        {
            addEventListener(FrameEvent.RESPONSE, this.__frameEvent);
            this._reliveHere.addEventListener(MouseEvent.CLICK, this.__reliveHere);
            this._reliveSafety.addEventListener(MouseEvent.CLICK, this.__reliveSafety);
            this._checkBtn.addEventListener(MouseEvent.CLICK, this.__checkClick);
        }

        private function __checkClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            ArenaManager.instance.model.reliveAlertShow = (!(this._checkBtn.selected));
        }

        private function __frameEvent(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            switch (_arg_1.responseCode)
            {
                case FrameEvent.ESC_CLICK:
                case FrameEvent.CLOSE_CLICK:
                    ArenaManager.instance.sendRelive(1);
                    this.hide();
                    return;
            };
        }

        private function __reliveHere(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            if (this._checkBtn.selected == false)
            {
                this._reliveHereAlert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"), LanguageMgr.GetTranslation("ddt.arena.arenareliveview。relivehereAlertTxt", 10), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), false, true, false, LayerManager.BLCAK_BLOCKGOUND);
                this._reliveHereAlert.addToContent(this._checkBtn);
                this._reliveHereAlert.moveEnable = false;
                this._reliveHereAlert.addEventListener(FrameEvent.RESPONSE, this.__confirmResponse);
            }
            else
            {
                this.pay();
            };
        }

        private function pay():void
        {
            if (PlayerManager.Instance.Self.bagLocked)
            {
                BaglockedManager.Instance.show();
                return;
            };
            if (PlayerManager.Instance.Self.totalMoney >= 10)
            {
                ArenaManager.instance.sendRelive(0);
                this.hide();
            }
            else
            {
                this._moneyConfirm = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("tank.view.comon.lack"), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), false, false, false, LayerManager.ALPHA_BLOCKGOUND);
                this._moneyConfirm.moveEnable = false;
                this._moneyConfirm.addEventListener(FrameEvent.RESPONSE, this.__moneyConfirmHandler);
            };
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

        private function __confirmResponse(_arg_1:FrameEvent):void
        {
            this._reliveHereAlert.removeEventListener(FrameEvent.RESPONSE, this.__confirmResponse);
            if (((_arg_1.responseCode == FrameEvent.ENTER_CLICK) || (_arg_1.responseCode == FrameEvent.SUBMIT_CLICK)))
            {
                this.pay();
            };
            ObjectUtils.disposeObject(this._reliveHereAlert);
            this._reliveHereAlert = null;
        }

        private function __reliveSafety(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            ArenaManager.instance.sendRelive(1);
            this.hide();
        }

        private function removeEvent():void
        {
            removeEventListener(FrameEvent.RESPONSE, this.__frameEvent);
            this._reliveHere.removeEventListener(MouseEvent.CLICK, this.__reliveHere);
            this._reliveSafety.removeEventListener(MouseEvent.CLICK, this.__reliveSafety);
            this._checkBtn.removeEventListener(MouseEvent.CLICK, this.__checkClick);
        }

        override public function dispose():void
        {
            this.removeEvent();
            ObjectUtils.disposeObject(this._showTxt);
            this._showTxt = null;
            ObjectUtils.disposeObject(this._timeTxt);
            this._timeTxt = null;
            ObjectUtils.disposeObject(this._reliveHere);
            this._reliveHere = null;
            ObjectUtils.disposeObject(this._reliveSafety);
            this._reliveSafety = null;
            ObjectUtils.disposeObject(this._reliveHereAlert);
            this._reliveHereAlert = null;
            ObjectUtils.disposeObject(this._checkBtn);
            this._checkBtn = null;
            ObjectUtils.disposeObject(this._moneyConfirm);
            this._moneyConfirm = null;
            super.dispose();
        }


    }
}//package arena.view

