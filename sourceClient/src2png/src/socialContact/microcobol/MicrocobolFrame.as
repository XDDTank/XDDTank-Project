// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//socialContact.microcobol.MicrocobolFrame

package socialContact.microcobol
{
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import com.pickgliss.ui.vo.AlertInfo;
    import flash.display.Bitmap;
    import com.pickgliss.ui.text.TextArea;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.controls.BaseButton;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.toplevel.StageReferance;
    import flash.events.Event;
    import ddt.manager.SoundManager;
    import ddt.manager.MessageTipManager;
    import flash.net.URLVariables;
    import ddt.manager.ServerManager;
    import ddt.manager.PlayerManager;
    import com.pickgliss.loader.LoadResourceManager;
    import ddt.manager.PathManager;
    import com.pickgliss.loader.BaseLoader;
    import flash.events.MouseEvent;
    import com.pickgliss.events.FrameEvent;

    public class MicrocobolFrame extends BaseAlerFrame 
    {

        private const _maxChatNum:int = 140;
        private const _addYNum:int = 6;

        private var _alertInfo:AlertInfo;
        private var _textBg:Bitmap;
        private var _inputText:TextArea;
        private var _infoText:FilterFrameText;
        private var _textOldY:int;
        private var _issueBt:BaseButton;

        public function MicrocobolFrame()
        {
            this.initialize();
        }

        protected function initialize():void
        {
            this.setView();
            this.setEvent();
        }

        private function setView():void
        {
            submitButtonStyle = "core.simplebt";
            this._alertInfo = new AlertInfo(LanguageMgr.GetTranslation("tank.view.im.microcobol.tip"), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), false, false);
            this._alertInfo.moveEnable = false;
            info = this._alertInfo;
            this.escEnable = true;
            this._textBg = ComponentFactory.Instance.creatBitmap("microBlog.TextArea");
            addToContent(this._textBg);
            this._inputText = ComponentFactory.Instance.creatComponentByStylename("Microcobol.inputText");
            addToContent(this._inputText);
            this._infoText = ComponentFactory.Instance.creatComponentByStylename("Microcobol.InfoText");
            this._textOldY = this._infoText.y;
            this._inputTextChange();
            addToContent(this._infoText);
            this._issueBt = ComponentFactory.Instance.creatComponentByStylename("MicroBlog.IssueBt");
            addToContent(this._issueBt);
        }

        public function show():void
        {
            LayerManager.Instance.addToLayer(this, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.ALPHA_BLOCKGOUND);
            if (this._inputText)
            {
                StageReferance.stage.focus = this._inputText.textField;
            };
        }

        public function setList(_arg_1:Array):void
        {
        }

        private function _inputTextChange(_arg_1:Event=null):void
        {
            var _local_2:String = "";
            if (this._inputText.text.length > this._maxChatNum)
            {
                this._infoText.setFrame(2);
                _local_2 = LanguageMgr.GetTranslation("socialContact.microcobol.infoTextII");
                _local_2 = _local_2.replace(/r/g, String((this._inputText.text.length - this._maxChatNum)));
            }
            else
            {
                this._infoText.setFrame(2);
                _local_2 = LanguageMgr.GetTranslation("socialContact.microcobol.infoTextIII");
                _local_2 = _local_2.replace(/r/g, String((this._maxChatNum - this._inputText.text.length)));
            };
            this._infoText.htmlText = _local_2;
            this._infoText.y = this._textOldY;
        }

        private function _clickIssueBt(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            if (this._inputText.text.length == 0)
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("socialContact.microcobol.infoTextI"));
                return;
            };
            if (this._inputText.text.length > this._maxChatNum)
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("socialContact.microcobol.infoTextTooLong"));
                return;
            };
            var _local_2:URLVariables = new URLVariables();
            _local_2.serverId = ServerManager.Instance.AgentID;
            _local_2.fuid = PlayerManager.Instance.Account.Account;
            _local_2.inviteCaption = this._inputText.text;
            _local_2.ran = Math.random();
            _local_2.screenshot = "";
            var _local_3:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.getMicrocobolPath(), BaseLoader.REQUEST_LOADER, _local_2);
            LoadResourceManager.instance.startLoad(_local_3);
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("socialContact.microcobol.succeed"));
            this.dispose();
            dispatchEvent(new Event("submit"));
        }

        private function removeView():void
        {
            super.dispose();
        }

        private function setEvent():void
        {
            addEventListener(FrameEvent.RESPONSE, this.onFrameResponse);
            this._inputText.addEventListener(Event.CHANGE, this._inputTextChange);
            this._issueBt.addEventListener(MouseEvent.CLICK, this._clickIssueBt);
        }

        private function removeEvent():void
        {
            removeEventListener(FrameEvent.RESPONSE, this.onFrameResponse);
            this._inputText.removeEventListener(Event.CHANGE, this._inputTextChange);
            this._issueBt.removeEventListener(MouseEvent.CLICK, this._clickIssueBt);
        }

        private function onFrameResponse(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            switch (_arg_1.responseCode)
            {
                case FrameEvent.CANCEL_CLICK:
                case FrameEvent.CLOSE_CLICK:
                case FrameEvent.ESC_CLICK:
                    this.dispose();
                    dispatchEvent(new Event("close"));
                    return;
                case FrameEvent.ENTER_CLICK:
                case FrameEvent.SUBMIT_CLICK:
                    this.dispose();
                    dispatchEvent(new Event("submit"));
                    return;
            };
        }

        override public function dispose():void
        {
            this.removeEvent();
            this.removeView();
            super.dispose();
            this._alertInfo = null;
            this._textBg = null;
            this._inputText = null;
            this._infoText = null;
            this._issueBt = null;
        }


    }
}//package socialContact.microcobol

