// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//bagAndInfo.ReworkName.ReworkNameFrame

package bagAndInfo.ReworkName
{
    import com.pickgliss.ui.controls.Frame;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.image.Scale9CornerImage;
    import com.pickgliss.ui.controls.TextButton;
    import ddt.manager.LanguageMgr;
    import flash.text.TextFormat;
    import com.pickgliss.ui.ComponentFactory;
    import flash.events.Event;
    import flash.events.TextEvent;
    import flash.events.MouseEvent;
    import com.pickgliss.events.FrameEvent;
    import road7th.utils.StringHelper;
    import com.pickgliss.toplevel.StageReferance;
    import flash.utils.setTimeout;
    import ddt.manager.SoundManager;
    import com.pickgliss.loader.LoaderEvent;
    import ddt.utils.RequestVairableCreater;
    import flash.net.URLVariables;
    import ddt.manager.PlayerManager;
    import com.pickgliss.loader.LoadResourceManager;
    import ddt.manager.PathManager;
    import com.pickgliss.loader.BaseLoader;
    import ddt.data.analyze.ReworkNameAnalyzer;
    import com.pickgliss.ui.AlertManager;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import ddt.manager.SocketManager;
    import ddt.utils.FilterWordManager;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.utils.ObjectUtils;

    public class ReworkNameFrame extends Frame 
    {

        public static const Close:String = "close";
        public static const ReworkDone:String = "ReworkDone";
        public static const Aviable:String = "aviable";
        public static const Unavialbe:String = "unaviable";
        public static const Input:String = "input";

        protected var _tittleField:FilterFrameText;
        protected var _nicknameInput:FilterFrameText;
        protected var _inputBackground:Scale9CornerImage;
        protected var _resultField:FilterFrameText;
        protected var _checkButton:TextButton;
        protected var _submitButton:TextButton;
        protected var _available:Boolean = true;
        protected var _nicknameDetail:String = LanguageMgr.GetTranslation("choosecharacter.ChooseCharacterView.check_txt");
        private var _resultDefaultFormat:TextFormat;
        private var _avialableFormat:TextFormat;
        private var _unAviableFormat:TextFormat;
        private var _disEnabledFilters:Array = [ComponentFactory.Instance.model.getSet("bagAndInfo.reworkname.ButtonDisenable")];
        private var _complete:Boolean = true;
        protected var _path:String = "NickNameCheck.ashx";
        protected var _bagType:int;
        protected var _place:int;
        protected var _maxChars:int;
        protected var _state:String;
        protected var _isCanRework:Boolean;

        public function ReworkNameFrame()
        {
            escEnable = true;
            enterEnable = true;
            this.configUi();
            this.addEvent();
        }

        protected function configUi():void
        {
            titleText = LanguageMgr.GetTranslation("tank.view.ReworkNameView.reworkName");
            this._resultDefaultFormat = ComponentFactory.Instance.model.getSet("bagAndInfo.reworkname.ResultDefaultTF");
            this._avialableFormat = ComponentFactory.Instance.model.getSet("bagAndInfo.reworkname.ResultAvailableTF");
            this._unAviableFormat = ComponentFactory.Instance.model.getSet("bagAndInfo.reworkname.ResultUnAvailableTF");
            this._inputBackground = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.reworkname.backgound_inputImage");
            addToContent(this._inputBackground);
            this._tittleField = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.reworkname.ReworkNameTittle");
            this._tittleField.text = LanguageMgr.GetTranslation("tank.view.ReworkNameView.inputName");
            addToContent(this._tittleField);
            this._resultField = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.reworkname.ReworkNameCheckResult");
            this._resultField.defaultTextFormat = this._resultDefaultFormat;
            this._resultField.text = this._nicknameDetail;
            addToContent(this._resultField);
            this._nicknameInput = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.reworkname.NicknameInput");
            addToContent(this._nicknameInput);
            this._checkButton = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.reworkname.CheckButton");
            this._checkButton.text = LanguageMgr.GetTranslation("ddtbagAndInfo.reworkNameBtn.txt");
            addToContent(this._checkButton);
            this._submitButton = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.reworkname.SubmitButton");
            this._submitButton.text = LanguageMgr.GetTranslation("tank.view.ReworkNameView.okLabel");
            addToContent(this._submitButton);
            this._submitButton.enable = false;
            this._submitButton.filters = this._disEnabledFilters;
        }

        private function addEvent():void
        {
            this._nicknameInput.addEventListener(Event.CHANGE, this.__onInputChange);
            this._nicknameInput.addEventListener(TextEvent.TEXT_INPUT, this.__onTextInputChange);
            this._checkButton.addEventListener(MouseEvent.CLICK, this.__onCheckClick);
            this._submitButton.addEventListener(MouseEvent.CLICK, this.__onSubmitClick);
            addEventListener(FrameEvent.RESPONSE, this.__onResponse);
            addEventListener(Event.ADDED_TO_STAGE, this.__onToStage);
        }

        private function removeEvent():void
        {
            this._nicknameInput.removeEventListener(Event.CHANGE, this.__onInputChange);
            this._nicknameInput.removeEventListener(TextEvent.TEXT_INPUT, this.__onTextInputChange);
            this._checkButton.removeEventListener(MouseEvent.CLICK, this.__onCheckClick);
            this._submitButton.removeEventListener(MouseEvent.CLICK, this.__onSubmitClick);
            removeEventListener(FrameEvent.RESPONSE, this.__onResponse);
            removeEventListener(Event.ADDED_TO_STAGE, this.__onToStage);
        }

        private function __onTextInputChange(_arg_1:TextEvent):void
        {
            var _local_2:int = StringHelper.getStringByteLength(_arg_1.target.text);
            if (_local_2 >= _arg_1.target.maxChars)
            {
                _arg_1.preventDefault();
            };
        }

        private function __onToStage(_arg_1:Event):void
        {
            removeEventListener(Event.ADDED_TO_STAGE, this.__onToStage);
            StageReferance.stage.focus = this._nicknameInput;
            setTimeout(this._nicknameInput.setFocus, 100);
        }

        private function __onResponse(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            switch (_arg_1.responseCode)
            {
                case FrameEvent.CANCEL_CLICK:
                case FrameEvent.CLOSE_CLICK:
                case FrameEvent.ESC_CLICK:
                    this.close();
                    return;
                case FrameEvent.SUBMIT_CLICK:
                case FrameEvent.ENTER_CLICK:
                    if (this._submitButton.enable)
                    {
                        this.__onSubmitClick(null);
                    };
                    return;
            };
        }

        protected function __onInputChange(_arg_1:Event):void
        {
            this.state = Input;
            if (this.state != Input)
            {
                this.state = Input;
            };
            if (((!(this._nicknameInput.text)) || (this._nicknameInput.text == "")))
            {
                this._submitButton.enable = false;
                this._submitButton.filters = this._disEnabledFilters;
            }
            else
            {
                this._submitButton.enable = true;
                this._submitButton.filters = null;
            };
        }

        protected function __onCheckClick(_arg_1:MouseEvent):void
        {
            if (this.complete)
            {
                SoundManager.instance.play("008");
                this._isCanRework = false;
                if (this.nameInputCheck())
                {
                    this.createCheckLoader(this.checkNameCallBack);
                }
                else
                {
                    this.visibleCheckText();
                };
            };
        }

        protected function visibleCheckText():void
        {
            this.state = Input;
            this._resultField.text = this._nicknameDetail;
        }

        private function __onSubmitClick(_arg_1:MouseEvent):void
        {
            if (this.complete)
            {
                SoundManager.instance.play("008");
                this._isCanRework = false;
                if (this._nicknameInput.text == "")
                {
                    this.setCheckTxt(LanguageMgr.GetTranslation("tank.view.ReworkNameView.inputName"));
                };
                if (this.nameInputCheck())
                {
                    this.createCheckLoader(this.submitCheckCallBack);
                }
                else
                {
                    this.visibleCheckText();
                    return;
                };
            };
        }

        protected function setCheckTxt(_arg_1:String):void
        {
            if (_arg_1 == LanguageMgr.GetTranslation("choosecharacter.ChooseCharacterView.setCheckTxt"))
            {
                this.state = Aviable;
                this._isCanRework = true;
            }
            else
            {
                this.state = Unavialbe;
            };
            this._resultField.text = _arg_1;
        }

        private function __onLoadError(_arg_1:LoaderEvent):void
        {
            this.complete = true;
            this.state = Unavialbe;
            _arg_1.loader.removeEventListener(LoaderEvent.LOAD_ERROR, this.__onLoadError);
        }

        protected function createCheckLoader(_arg_1:Function):BaseLoader
        {
            var _local_2:URLVariables = RequestVairableCreater.creatWidthKey(true);
            _local_2["id"] = PlayerManager.Instance.Self.ID;
            _local_2["bagType"] = this._bagType;
            _local_2["place"] = this._place;
            _local_2["NickName"] = this._nicknameInput.text;
            var _local_3:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath(this._path), BaseLoader.REQUEST_LOADER, _local_2);
            _local_3.loadErrorMessage = LanguageMgr.GetTranslation("choosecharacter.LoadCheckName.m");
            _local_3.analyzer = new ReworkNameAnalyzer(_arg_1);
            _local_3.addEventListener(LoaderEvent.LOAD_ERROR, this.__onLoadError);
            LoadResourceManager.instance.startLoad(_local_3);
            this.complete = false;
            return (_local_3);
        }

        protected function checkNameCallBack(_arg_1:ReworkNameAnalyzer):void
        {
            this.complete = true;
            var _local_2:XML = _arg_1.result;
            this.setCheckTxt(_local_2.@message);
        }

        protected function reworkNameComplete():void
        {
            this.complete = true;
            SoundManager.instance.play("047");
            var _local_1:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("tank.view.ReworkNameView.reworkNameComplete"), LanguageMgr.GetTranslation("ok"));
            _local_1.addEventListener(FrameEvent.RESPONSE, this.__onAlertResponse);
            this.close();
        }

        protected function __onAlertResponse(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            var _local_2:BaseAlerFrame = (_arg_1.currentTarget as BaseAlerFrame);
            _local_2.removeEventListener(FrameEvent.RESPONSE, this.__onAlertResponse);
            switch (_arg_1.responseCode)
            {
                case FrameEvent.ESC_CLICK:
                case FrameEvent.ENTER_CLICK:
                case FrameEvent.SUBMIT_CLICK:
                case FrameEvent.CANCEL_CLICK:
                case FrameEvent.CLOSE_CLICK:
                    _local_2.dispose();
                    break;
            };
            StageReferance.stage.focus = this._nicknameInput;
        }

        protected function submitCheckCallBack(_arg_1:ReworkNameAnalyzer):void
        {
            var _local_3:String;
            this.complete = true;
            var _local_2:XML = _arg_1.result;
            this.setCheckTxt(_local_2.@message);
            if (((this.nameInputCheck()) && (this._isCanRework)))
            {
                _local_3 = this._nicknameInput.text;
                SocketManager.Instance.out.sendUseReworkName(this._bagType, this._place, _local_3);
                this.reworkNameComplete();
            };
        }

        protected function __onFrameResponse(_arg_1:FrameEvent):void
        {
            var _local_2:BaseAlerFrame = (_arg_1.currentTarget as BaseAlerFrame);
            _local_2.removeEventListener(FrameEvent.RESPONSE, this.__onFrameResponse);
            _local_2.dispose();
            this.state = Input;
        }

        protected function nameInputCheck():Boolean
        {
            var _local_1:BaseAlerFrame;
            if (this._nicknameInput.text != "")
            {
                if (FilterWordManager.isGotForbiddenWords(this._nicknameInput.text, "name"))
                {
                    _local_1 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("choosecharacter.ChooseCharacterView.name"), LanguageMgr.GetTranslation("ok"), "", false, false, false, LayerManager.ALPHA_BLOCKGOUND);
                    _local_1.addEventListener(FrameEvent.RESPONSE, this.__onAlertResponse);
                    return (false);
                };
                if (FilterWordManager.IsNullorEmpty(this._nicknameInput.text))
                {
                    _local_1 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("choosecharacter.ChooseCharacterView.space"), LanguageMgr.GetTranslation("ok"), "", false, false, false, LayerManager.ALPHA_BLOCKGOUND);
                    _local_1.addEventListener(FrameEvent.RESPONSE, this.__onAlertResponse);
                    return (false);
                };
                if (FilterWordManager.containUnableChar(this._nicknameInput.text))
                {
                    _local_1 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("choosecharacter.ChooseCharacterView.string"), LanguageMgr.GetTranslation("ok"), "", false, false, false, LayerManager.ALPHA_BLOCKGOUND);
                    _local_1.addEventListener(FrameEvent.RESPONSE, this.__onAlertResponse);
                    return (false);
                };
                return (true);
            };
            _local_1 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("choosecharacter.ChooseCharacterView.input"), LanguageMgr.GetTranslation("ok"), "", false, false, false, LayerManager.ALPHA_BLOCKGOUND);
            _local_1.addEventListener(FrameEvent.RESPONSE, this.__onAlertResponse);
            return (false);
        }

        public function initialize(_arg_1:int, _arg_2:int):void
        {
            this._bagType = _arg_1;
            this._place = _arg_2;
        }

        public function get state():String
        {
            return (this._state);
        }

        public function set state(_arg_1:String):void
        {
            if (this._state != _arg_1)
            {
                this._state = _arg_1;
                if (this._state == Aviable)
                {
                    this._resultField.setFrame(2);
                }
                else
                {
                    if (this._state == Unavialbe)
                    {
                        this._resultField.setFrame(1);
                    }
                    else
                    {
                        this._resultField.setFrame(1);
                        this._resultField.text = this._nicknameDetail;
                        this._isCanRework = true;
                    };
                };
            };
        }

        public function get complete():Boolean
        {
            return (this._complete);
        }

        public function set complete(_arg_1:Boolean):void
        {
            if (this._complete != _arg_1)
            {
                this._complete = _arg_1;
                if (this._complete)
                {
                    if (((!(this._nicknameInput.text)) || (this._nicknameInput.text == "")))
                    {
                        this._submitButton.enable = false;
                        this._submitButton.filters = this._disEnabledFilters;
                    }
                    else
                    {
                        this._submitButton.enable = true;
                        this._submitButton.filters = null;
                    };
                }
                else
                {
                    this._submitButton.enable = false;
                    this._submitButton.filters = this._disEnabledFilters;
                };
            };
        }

        public function close():void
        {
            dispatchEvent(new Event(Event.COMPLETE));
        }

        override public function dispose():void
        {
            this.removeEvent();
            if (this._tittleField)
            {
                ObjectUtils.disposeObject(this._tittleField);
                this._tittleField = null;
            };
            if (this._resultField)
            {
                ObjectUtils.disposeObject(this._resultField);
                this._resultField = null;
            };
            if (this._nicknameInput)
            {
                ObjectUtils.disposeObject(this._nicknameInput);
                this._nicknameInput = null;
            };
            if (this._checkButton)
            {
                ObjectUtils.disposeObject(this._checkButton);
                this._checkButton = null;
            };
            if (this._submitButton)
            {
                ObjectUtils.disposeObject(this._submitButton);
                this._submitButton = null;
            };
            if (this._inputBackground)
            {
                ObjectUtils.disposeObject(this._inputBackground);
                this._inputBackground = null;
            };
            this._resultDefaultFormat = null;
            this._avialableFormat = null;
            this._disEnabledFilters = null;
            super.dispose();
        }


    }
}//package bagAndInfo.ReworkName

