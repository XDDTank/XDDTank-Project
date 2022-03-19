// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//login.view.RoleRenameFrame

package login.view
{
    import com.pickgliss.ui.controls.Frame;
    import com.pickgliss.ui.image.Scale9CornerImage;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.controls.BaseButton;
    import ddt.manager.LanguageMgr;
    import flash.filters.ColorMatrixFilter;
    import ddt.data.Role;
    import com.pickgliss.ui.ComponentFactory;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import flash.events.TextEvent;
    import road7th.utils.StringHelper;
    import ddt.manager.SoundManager;
    import com.pickgliss.loader.BaseLoader;
    import com.pickgliss.loader.LoadResourceManager;
    import ddt.utils.RequestVairableCreater;
    import flash.net.URLVariables;
    import ddt.manager.PlayerManager;
    import ddt.manager.PathManager;
    import ddt.data.analyze.ReworkNameAnalyzer;
    import com.pickgliss.loader.LoaderEvent;
    import com.pickgliss.loader.RequestLoader;
    import ddt.data.analyze.LoginRenameAnalyzer;
    import ddt.data.AccountInfo;
    import flash.utils.ByteArray;
    import ddt.utils.CrytoUtils;
    import ddt.Version;
    import flash.text.TextFormat;
    import com.pickgliss.utils.ObjectUtils;

    public class RoleRenameFrame extends Frame 
    {

        protected static var w:String = "abcdefghijklmnopqrstuvwxyz";
        protected static const Aviable:String = "aviable";
        protected static const UnAviable:String = "unaviable";
        protected static const Input:String = "input";

        private var _nicknameBack:Scale9CornerImage;
        protected var _nicknameField:FilterFrameText;
        protected var _nicknameLabel:FilterFrameText;
        protected var _modifyButton:BaseButton;
        protected var _resultString:String = LanguageMgr.GetTranslation("choosecharacter.ChooseCharacterView.check_txt");
        protected var _resultField:FilterFrameText;
        protected var _disenabelFilter:ColorMatrixFilter;
        protected var _tempPass:String;
        protected var _roleInfo:Role;
        protected var _path:String = "RenameNick.ashx";
        protected var _checkPath:String = "NickNameCheck.ashx";
        protected var _complete:Boolean = false;
        protected var _isCanRework:Boolean = false;
        protected var _state:String;
        protected var _newName:String;

        public function RoleRenameFrame()
        {
            this.configUi();
            this.addEvent();
        }

        protected function configUi():void
        {
            this._disenabelFilter = ComponentFactory.Instance.model.getSet("login.ChooseRole.DisenableGF");
            titleStyle = "login.Title";
            titleText = LanguageMgr.GetTranslation("tank.loginstate.characterModify");
            this._nicknameBack = ComponentFactory.Instance.creatComponentByStylename("login.Rename.NicknameBackground");
            addToContent(this._nicknameBack);
            this._nicknameLabel = ComponentFactory.Instance.creatComponentByStylename("login.Rename.NicknameLabel");
            this._nicknameLabel.text = LanguageMgr.GetTranslation("tank.loginstate.characterModify");
            addToContent(this._nicknameLabel);
            this._nicknameField = ComponentFactory.Instance.creatComponentByStylename("login.Rename.NicknameInput");
            addToContent(this._nicknameField);
            this._resultField = ComponentFactory.Instance.creatComponentByStylename("login.Rename.RenameResult");
            addToContent(this._resultField);
            this._modifyButton = ComponentFactory.Instance.creatComponentByStylename("login.Rename.ModifyButton");
            addToContent(this._modifyButton);
            this._modifyButton.enable = false;
            this._modifyButton.filters = [this._disenabelFilter];
            this.state = Input;
        }

        private function addEvent():void
        {
            this._modifyButton.addEventListener(MouseEvent.CLICK, this.__onModifyClick);
            this._nicknameField.addEventListener(Event.CHANGE, this.__onTextChange);
            this._nicknameField.addEventListener(TextEvent.TEXT_INPUT, this.__onTextInputChange);
        }

        private function removeEvent():void
        {
            if (this._modifyButton)
            {
                this._modifyButton.removeEventListener(MouseEvent.CLICK, this.__onModifyClick);
            };
            if (this._nicknameField)
            {
                this._nicknameField.removeEventListener(Event.CHANGE, this.__onTextChange);
                this._nicknameField.removeEventListener(TextEvent.TEXT_INPUT, this.__onTextInputChange);
            };
        }

        private function __onTextInputChange(_arg_1:TextEvent):void
        {
            var _local_2:int = StringHelper.getStringByteLength(_arg_1.target.text);
            if (_local_2 >= _arg_1.target.maxChars)
            {
                _arg_1.preventDefault();
            };
        }

        private function __onTextChange(_arg_1:Event):void
        {
            this.state = Input;
            if (((this._nicknameField.text == "") || (!(this._nicknameField.text))))
            {
                if (this._modifyButton.enable)
                {
                    this._modifyButton.enable = false;
                    this._modifyButton.filters = [this._disenabelFilter];
                };
            }
            else
            {
                if ((!(this._modifyButton.enable)))
                {
                    this._modifyButton.enable = true;
                    this._modifyButton.filters = null;
                };
            };
        }

        protected function __onModifyClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            if (this._modifyButton.enable)
            {
                this._modifyButton.enable = false;
                this._modifyButton.filters = [this._disenabelFilter];
            };
            this._newName = this._nicknameField.text;
            var _local_2:BaseLoader = this.createCheckLoader(this._checkPath, this.checkCallBack);
            LoadResourceManager.instance.startLoad(_local_2);
        }

        protected function createCheckLoader(_arg_1:String, _arg_2:Function):BaseLoader
        {
            var _local_3:URLVariables = RequestVairableCreater.creatWidthKey(true);
            _local_3["id"] = PlayerManager.Instance.Self.ID;
            _local_3["NickName"] = this._newName;
            var _local_4:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath(_arg_1), BaseLoader.REQUEST_LOADER, _local_3);
            _local_4.analyzer = new ReworkNameAnalyzer(_arg_2);
            _local_4.addEventListener(LoaderEvent.LOAD_ERROR, this.__onLoadError);
            LoadResourceManager.instance.startLoad(_local_4);
            return (_local_4);
        }

        protected function createModifyLoader(_arg_1:String, _arg_2:URLVariables, _arg_3:String, _arg_4:Function):RequestLoader
        {
            var _local_5:RequestLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath(_arg_1), BaseLoader.REQUEST_LOADER, _arg_2);
            _local_5.addEventListener(LoaderEvent.LOAD_ERROR, this.__onLoadLoginError);
            var _local_6:LoginRenameAnalyzer = new LoginRenameAnalyzer(_arg_4);
            _local_6.tempPassword = _arg_3;
            _local_5.analyzer = _local_6;
            return (_local_5);
        }

        private function __onLoadLoginError(_arg_1:LoaderEvent):void
        {
        }

        protected function checkCallBack(_arg_1:ReworkNameAnalyzer):void
        {
            var _local_2:XML = _arg_1.result;
            if (_local_2.@value == "true")
            {
                this.state = Aviable;
                this._resultField.text = _local_2.@message;
                this.doRename();
            }
            else
            {
                this._resultField.text = _local_2.@message;
                this.state = UnAviable;
            };
        }

        protected function renameCallBack(_arg_1:LoginRenameAnalyzer):void
        {
            var _local_2:XML = _arg_1.result;
            if (_local_2.@value == "true")
            {
                this.state = Aviable;
                this.renameComplete();
            }
            else
            {
                this._resultField.text = _local_2.@message;
                this.state = UnAviable;
            };
        }

        protected function doRename():void
        {
            if (this._modifyButton.enable)
            {
                this._modifyButton.enable = false;
                this._modifyButton.filters = [this._disenabelFilter];
            };
            var _local_1:AccountInfo = PlayerManager.Instance.Account;
            var _local_2:Date = new Date();
            var _local_3:ByteArray = new ByteArray();
            _local_3.writeShort(_local_2.fullYearUTC);
            _local_3.writeByte((_local_2.monthUTC + 1));
            _local_3.writeByte(_local_2.dateUTC);
            _local_3.writeByte(_local_2.hoursUTC);
            _local_3.writeByte(_local_2.minutesUTC);
            _local_3.writeByte(_local_2.secondsUTC);
            var _local_4:String = "";
            var _local_5:int;
            while (_local_5 < 6)
            {
                _local_4 = (_local_4 + w.charAt(int((Math.random() * 26))));
                _local_5++;
            };
            _local_3.writeUTFBytes(((((((((_local_1.Account + ",") + _local_1.Password) + ",") + _local_4) + ",") + this._roleInfo.NickName) + ",") + this._newName));
            var _local_6:String = CrytoUtils.rsaEncry4(_local_1.Key, _local_3);
            var _local_7:URLVariables = RequestVairableCreater.creatWidthKey(false);
            _local_7["p"] = _local_6;
            _local_7["v"] = Version.Build;
            _local_7["site"] = PathManager.solveConfigSite();
            var _local_8:RequestLoader = this.createModifyLoader(this._path, _local_7, _local_4, this.renameCallBack);
            LoadResourceManager.instance.startLoad(_local_8);
        }

        protected function renameComplete():void
        {
            if ((!(this._modifyButton.enable)))
            {
                this._modifyButton.enable = true;
                this._modifyButton.filters = null;
            };
            this._roleInfo.NameChanged = true;
            dispatchEvent(new Event(Event.COMPLETE));
        }

        private function __onLoadError(_arg_1:LoaderEvent):void
        {
        }

        public function get roleInfo():Role
        {
            return (this._roleInfo);
        }

        public function set roleInfo(_arg_1:Role):void
        {
            this._roleInfo = _arg_1;
        }

        public function get state():String
        {
            return (this._state);
        }

        public function set state(_arg_1:String):void
        {
            var _local_2:TextFormat;
            if (this._state != _arg_1)
            {
                this._state = _arg_1;
                if (this._state == Aviable)
                {
                    _local_2 = ComponentFactory.Instance.model.getSet("login.Rename.ResultAvailableTF");
                    this._resultField.defaultTextFormat = _local_2;
                    if (this._resultField.length > 0)
                    {
                        this._resultField.setTextFormat(_local_2, 0, this._resultField.length);
                    };
                }
                else
                {
                    if (this._state == UnAviable)
                    {
                        if (this._modifyButton.enable)
                        {
                            this._modifyButton.enable = false;
                            this._modifyButton.filters = [this._disenabelFilter];
                        };
                        _local_2 = ComponentFactory.Instance.model.getSet("login.Rename.ResultUnAvailableTF");
                        this._resultField.defaultTextFormat = _local_2;
                        if (this._resultField.length > 0)
                        {
                            this._resultField.setTextFormat(_local_2, 0, this._resultField.length);
                        };
                    }
                    else
                    {
                        this._resultField.text = this._resultString;
                        _local_2 = ComponentFactory.Instance.model.getSet("login.Rename.ResultDefaultTF");
                        this._resultField.defaultTextFormat = _local_2;
                        if (this._resultField.length > 0)
                        {
                            this._resultField.setTextFormat(_local_2, 0, this._resultField.length);
                        };
                    };
                };
            };
        }

        override public function dispose():void
        {
            if (this._nicknameBack)
            {
                ObjectUtils.disposeObject(this._nicknameBack);
                this._nicknameBack = null;
            };
            if (this._nicknameLabel)
            {
                ObjectUtils.disposeObject(this._nicknameLabel);
                this._nicknameLabel = null;
            };
            if (this._nicknameField)
            {
                ObjectUtils.disposeObject(this._nicknameField);
                this._nicknameField = null;
            };
            if (this._modifyButton)
            {
                ObjectUtils.disposeObject(this._modifyButton);
                this._modifyButton = null;
            };
            this._roleInfo = null;
            super.dispose();
        }


    }
}//package login.view

