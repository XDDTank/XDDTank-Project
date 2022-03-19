// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.SNSFrame

package ddt.view
{
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import flash.display.Bitmap;
    import com.pickgliss.ui.image.Scale9CornerImage;
    import com.pickgliss.ui.controls.TextButton;
    import com.pickgliss.ui.controls.SelectedCheckButton;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.vo.AlertInfo;
    import flash.geom.Point;
    import com.pickgliss.ui.text.TextArea;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.toplevel.StageReferance;
    import ddt.manager.SharedManager;
    import com.pickgliss.events.FrameEvent;
    import flash.events.MouseEvent;
    import ddt.manager.SoundManager;
    import flash.events.Event;
    import ddt.manager.PathManager;
    import com.pickgliss.ui.LayerManager;
    import flash.net.URLVariables;
    import ddt.manager.ServerManager;
    import ddt.manager.PlayerManager;
    import ddt.manager.SocketManager;
    import com.pickgliss.loader.LoadResourceManager;
    import com.pickgliss.loader.BaseLoader;
    import ddt.manager.MessageTipManager;
    import com.pickgliss.utils.ObjectUtils;

    public class SNSFrame extends BaseAlerFrame 
    {

        private var _inputBG:Bitmap;
        private var _SNSFrameBg1:Scale9CornerImage;
        private var _shareBtn:TextButton;
        private var _visibleBtn:SelectedCheckButton;
        private var _text:FilterFrameText;
        private var _textinput:FilterFrameText;
        private var _alertInfo:AlertInfo;
        private var _textInputBgPoint:Point;
        private var _inputText:TextArea;
        public var typeId:int;
        public var backgroundServerTxt:String;

        public function SNSFrame()
        {
            this.initView();
            this.addEvent();
        }

        private function initView():void
        {
            submitButtonStyle = "core.simplebt";
            this._alertInfo = new AlertInfo(LanguageMgr.GetTranslation("ddt.view.SnsFrame.titleText"), LanguageMgr.GetTranslation("ddt.view.SnsFrame.shareBtnText"), LanguageMgr.GetTranslation("cancel"), true, true);
            this._alertInfo.moveEnable = false;
            info = this._alertInfo;
            this.escEnable = true;
            this.titleText = LanguageMgr.GetTranslation("ddt.view.SnsFrame.titleText");
            this._inputText = ComponentFactory.Instance.creatComponentByStylename("Microcobol.inputText");
            addToContent(this._inputText);
            this._inputBG = ComponentFactory.Instance.creatBitmap("ddt.view.SNSFrameBg");
            addToContent(this._inputBG);
            this._textInputBgPoint = ComponentFactory.Instance.creatCustomObject("core.SNSFramePoint");
            this._inputText.x = this._textInputBgPoint.x;
            this._inputText.y = this._textInputBgPoint.y;
            if (this._inputText)
            {
                StageReferance.stage.focus = this._inputText.textField;
            };
            this._text = ComponentFactory.Instance.creat("core.SNSFrameViewText");
            this.addToContent(this._text);
            this._visibleBtn = ComponentFactory.Instance.creatComponentByStylename("core.SNSFrameCheckBox");
            this._visibleBtn.text = LanguageMgr.GetTranslation("ddt.view.SnsFrame.visibleBtnText");
            this._visibleBtn.selected = SharedManager.Instance.autoSnsSend;
            this.addToContent(this._visibleBtn);
        }

        private function _getStr():String
        {
            var _local_1:String = "";
            switch (this.typeId)
            {
                case 1:
                    _local_1 = LanguageMgr.GetTranslation("ddt.view.SnsFrame.inputTextI");
                    break;
                case 2:
                    _local_1 = LanguageMgr.GetTranslation("ddt.view.SnsFrame.inputTextII");
                    break;
                case 3:
                    _local_1 = LanguageMgr.GetTranslation("ddt.view.SnsFrame.inputTextIII");
                    break;
                case 4:
                case 6:
                case 7:
                case 8:
                    _local_1 = LanguageMgr.GetTranslation("ddt.view.SnsFrame.inputTextIV");
                    break;
                case 5:
                    _local_1 = LanguageMgr.GetTranslation("ddt.view.SnsFrame.inputTextV");
                    break;
                case 9:
                    _local_1 = LanguageMgr.GetTranslation("ddt.view.SnsFrame.inputTextVI");
                    break;
                case 10:
                    _local_1 = LanguageMgr.GetTranslation("ddt.view.SnsFrame.inputTextVII");
                    break;
                case 11:
                    _local_1 = LanguageMgr.GetTranslation("ddt.view.SnsFrame.inputTextVIII");
                    break;
                default:
                    _local_1 = LanguageMgr.GetTranslation("ddt.view.SnsFrame.inputTextIV");
            };
            return (_local_1);
        }

        private function addEvent():void
        {
            addEventListener(FrameEvent.RESPONSE, this.__frameEventHandler);
            this._inputText.addEventListener(MouseEvent.CLICK, this._clickInputText);
            this._visibleBtn.addEventListener(MouseEvent.CLICK, this.__visibleBtnClick);
            StageReferance.stage.addEventListener(MouseEvent.CLICK, this._clickStage);
        }

        private function removeEvent():void
        {
            removeEventListener(FrameEvent.RESPONSE, this.__frameEventHandler);
            this._inputText.removeEventListener(MouseEvent.CLICK, this._clickInputText);
            if (this._visibleBtn)
            {
                this._visibleBtn.removeEventListener(MouseEvent.CLICK, this.__visibleBtnClick);
            };
            StageReferance.stage.removeEventListener(MouseEvent.CLICK, this._clickStage);
        }

        private function _clickInputText(_arg_1:MouseEvent):void
        {
            this._inputText.removeEventListener(MouseEvent.CLICK, this._clickInputText);
            this._inputText.text = "";
        }

        private function _clickStage(_arg_1:MouseEvent):void
        {
            if (((this._inputText.text == "") && (!(StageReferance.stage.focus == this._inputText.textField))))
            {
                this._inputText.text = this._getStr();
            };
        }

        protected function __shareBtnClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            this.sendDynamic();
        }

        protected function __visibleBtnClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            SharedManager.Instance.autoSnsSend = this._visibleBtn.selected;
        }

        private function __frameEventHandler(_arg_1:FrameEvent):void
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
                    this.sendDynamic();
                    dispatchEvent(new Event("submit"));
                    return;
            };
        }

        public function set receptionistTxt(_arg_1:String):void
        {
            if (this._text.text == _arg_1)
            {
                return;
            };
            this._text.text = _arg_1;
        }

        public function show():void
        {
            if (((SharedManager.Instance.allowSnsSend) || (!(PathManager.CommunityExist()))))
            {
                this.dispose();
                return;
            };
            if (SharedManager.Instance.autoSnsSend)
            {
                this.sendDynamic();
            }
            else
            {
                LayerManager.Instance.addToLayer(this, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.ALPHA_BLOCKGOUND);
            };
            if (this._inputText)
            {
                this._inputText.text = this._getStr();
            };
        }

        private function sendDynamic():void
        {
            var _local_1:URLVariables = new URLVariables();
            _local_1.typeId = this.typeId;
            _local_1.playerTest = this._getStr();
            switch (_local_1.typeId)
            {
                case 6:
                case 7:
                case 8:
                    _local_1.typeId = 4;
                    break;
                case 9:
                case 10:
                case 11:
                    _local_1.typeId = (_local_1.typeId - 3);
                    break;
            };
            _local_1.serverId = ServerManager.Instance.AgentID;
            _local_1.fuid = PlayerManager.Instance.Account.Account;
            _local_1.inviteCaption = this.backgroundServerTxt;
            if (this._inputText)
            {
                _local_1.playerTest = this._inputText.text;
            };
            _local_1.ran = Math.random();
            SocketManager.Instance.out.sendSnsMsg(this.typeId);
            var _local_2:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.getSnsPath(), BaseLoader.REQUEST_LOADER, _local_1);
            LoadResourceManager.instance.startLoad(_local_2);
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("socialContact.microcobol.succeed"));
            this.dispose();
        }

        override public function dispose():void
        {
            this.removeEvent();
            super.dispose();
            ObjectUtils.disposeObject(this._text);
            this._text = null;
            this._inputText = null;
            ObjectUtils.disposeObject(this._textinput);
            this._textinput = null;
            ObjectUtils.disposeObject(this._shareBtn);
            this._shareBtn = null;
            ObjectUtils.disposeObject(this._visibleBtn);
            this._visibleBtn = null;
            ObjectUtils.disposeObject(this._inputBG);
            this._inputBG = null;
            ObjectUtils.disposeObject(this._SNSFrameBg1);
            this._SNSFrameBg1 = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package ddt.view

