// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.chat.ChatInputField

package ddt.view.chat
{
    import flash.display.Sprite;
    import flash.text.TextField;
    import ddt.manager.ShopManager;
    import ddt.data.EquipType;
    import com.pickgliss.toplevel.StageReferance;
    import __AS3__.vec.Vector;
    import ddt.manager.SoundManager;
    import ddt.manager.ChatManager;
    import flash.events.Event;
    import ddt.manager.LanguageMgr;
    import flash.ui.Keyboard;
    import ddt.manager.DebugManager;
    import ddt.manager.IMEManager;
    import flash.events.KeyboardEvent;
    import ddt.utils.Helpers;
    import flash.geom.Point;
    import com.pickgliss.ui.ComponentFactory;
    import flash.text.TextFieldType;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;
    import road7th.utils.StringHelper;
    import ddt.utils.FilterWordManager;

    public class ChatInputField extends Sprite 
    {

        public static const INPUT_MAX_CHAT:int = 100;

        private var CHANNEL_KEY_SET:Array = ["d", "x", "w", "g", "p", "s", "k"];
        private var CHANNEL_SET:Array = [0, 1, 2, 3, 4, 5, 15];
        private var _channel:int = -1;
        private var _currentHistoryOffset:int = 0;
        private var _inputField:TextField;
        private var _maxInputWidth:Number = 300;
        private var _nameTextField:TextField;
        private var _privateChatName:String;
        private var _userID:int;
        private var _privateChatInfo:Object;

        public function ChatInputField()
        {
            if ((!(ShopManager.Instance.getMoneyShopItemByTemplateID(EquipType.T_CBUGLE))))
            {
                this.CHANNEL_KEY_SET.splice(this.CHANNEL_KEY_SET.indexOf("k"), 1);
                this.CHANNEL_SET.splice(this.CHANNEL_SET.indexOf(15), 1);
            };
            if ((!(ShopManager.Instance.getMoneyShopItemByTemplateID(EquipType.T_BBUGLE))))
            {
                this.CHANNEL_KEY_SET.splice(this.CHANNEL_KEY_SET.indexOf("d"), 1);
                this.CHANNEL_SET.splice(this.CHANNEL_SET.indexOf(0), 1);
            };
            if ((!(ShopManager.Instance.getMoneyShopItemByTemplateID(EquipType.T_SBUGLE))))
            {
                this.CHANNEL_KEY_SET.splice(this.CHANNEL_KEY_SET.indexOf("x"), 1);
                this.CHANNEL_SET.splice(this.CHANNEL_SET.indexOf(1), 1);
            };
            this.initView();
        }

        public function get channel():int
        {
            return (this._channel);
        }

        public function set channel(_arg_1:int):void
        {
            if (this._channel == _arg_1)
            {
                return;
            };
            this._channel = _arg_1;
            this.setPrivateChatName("");
            if ((((this._channel == 0) || (this._channel == 1)) || (this._channel == 15)))
            {
                this._inputField.maxChars = 70;
            }
            else
            {
                this._inputField.maxChars = INPUT_MAX_CHAT;
            };
            this.setTextFormat(ChatFormats.getTextFormatByChannel(this._channel));
        }

        public function isFocus():Boolean
        {
            var _local_1:Boolean;
            if (StageReferance.stage)
            {
                _local_1 = (StageReferance.stage.focus == this._inputField);
            };
            return (_local_1);
        }

        public function set maxInputWidth(_arg_1:Number):void
        {
            this._maxInputWidth = _arg_1;
            this.updatePosAndSize();
        }

        public function get privateChatName():String
        {
            return (this._privateChatName);
        }

        public function get privateUserID():int
        {
            return (this._userID);
        }

        public function get privateChatInfo():Object
        {
            return (this._privateChatInfo);
        }

        public function sendCurrnetText():void
        {
            var _local_6:int;
            var _local_7:Vector.<String>;
            var _local_8:String;
            var _local_9:String;
            var _local_1:RegExp = /\/\S*\s?/;
            var _local_2:Array = _local_1.exec(this._inputField.text);
            var _local_3:String = this._inputField.text.toLocaleLowerCase();
            var _local_4:Boolean;
            var _local_5:Boolean;
            if (_local_3.indexOf("/") == 0)
            {
                _local_6 = 0;
                while (_local_6 < this.CHANNEL_KEY_SET.length)
                {
                    if (_local_3.indexOf(("/" + this.CHANNEL_KEY_SET[_local_6])) == 0)
                    {
                        _local_4 = true;
                        SoundManager.instance.play("008");
                        this._inputField.text = _local_3.substring(2);
                        dispatchEvent(new ChatEvent(ChatEvent.INPUT_CHANNEL_CHANNGED, this.CHANNEL_SET[_local_6]));
                    };
                    _local_6++;
                };
                if ((!(_local_4)))
                {
                    _local_7 = ChatManager.Instance.model.customFastReply;
                    _local_6 = 0;
                    while (_local_6 < 5)
                    {
                        if (((_local_3.indexOf(("/" + String((_local_6 + 1)))) == 0) && ((_local_3.length == 2) || (_local_3.charAt(2) == " "))))
                        {
                            _local_5 = true;
                            if (_local_7.length > _local_6)
                            {
                                this._inputField.text = _local_7[_local_6];
                            }
                            else
                            {
                                this._inputField.text = "";
                            };
                            break;
                        };
                        _local_6++;
                    };
                };
                if ((((_local_2) && (!(_local_4))) && (!(_local_5))))
                {
                    _local_8 = String(_local_2[0]).replace(" ", "");
                    _local_8 = _local_8.replace("/", "");
                    if (_local_8 == "")
                    {
                        return;
                    };
                    this._inputField.text = this._inputField.text.replace(_local_1, "");
                    dispatchEvent(new ChatEvent(ChatEvent.CUSTOM_SET_PRIVATE_CHAT_TO, {
                        "channel":2,
                        "nickName":_local_8
                    }));
                    return;
                };
            };
            if (_local_3.substr(0, 2) != ("/" + this.CHANNEL_KEY_SET[0]))
            {
                _local_9 = this.parasMsgs(this._inputField.text);
                this._inputField.text = "";
                if (_local_9 == "")
                {
                    return;
                };
                dispatchEvent(new ChatEvent(ChatEvent.INPUT_TEXT_CHANGED, _local_9));
            };
        }

        public function setFocus():void
        {
            if (StageReferance.stage)
            {
                this.setTextFocus();
            }
            else
            {
                addEventListener(Event.ADDED_TO_STAGE, this.__onAddToStage);
            };
        }

        public function setInputText(_arg_1:String):void
        {
            if (((_arg_1.indexOf("&lt;") > -1) || (_arg_1.indexOf("&gt;") > -1)))
            {
                this._inputField.htmlText = _arg_1;
                this._inputField.textColor = ChatFormats.CHAT_COLORS[this._channel];
            }
            else
            {
                this._inputField.text = _arg_1;
            };
            this._inputField.setTextFormat(ChatFormats.getTextFormatByChannel(this._channel));
        }

        public function setPrivateChatName(_arg_1:String, _arg_2:int=0, _arg_3:Object=null):void
        {
            var _local_4:String;
            this.setTextFocus();
            if (this._privateChatName == _arg_1)
            {
                return;
            };
            this._privateChatName = _arg_1;
            this._userID = _arg_2;
            this._privateChatInfo = _arg_3;
            if (this._privateChatName != "")
            {
                _local_4 = "";
                _local_4 = this._privateChatName;
                this._nameTextField.htmlText = LanguageMgr.GetTranslation("tank.view.chat.ChatInput.usernameField.text", _local_4);
            }
            else
            {
                this._nameTextField.text = "";
            };
            this.updatePosAndSize();
        }

        private function __onAddToStage(_arg_1:Event):void
        {
            this.setTextFocus();
            removeEventListener(Event.ADDED_TO_STAGE, arguments.callee);
        }

        private function __onFieldKeyDown(_arg_1:KeyboardEvent):void
        {
            if (this.isFocus())
            {
                _arg_1.stopImmediatePropagation();
                _arg_1.stopPropagation();
                if (_arg_1.keyCode == Keyboard.UP)
                {
                    this.currentHistoryOffset--;
                    if (this.getHistoryChat(this.currentHistoryOffset) != "")
                    {
                        this._inputField.htmlText = this.getHistoryChat(this.currentHistoryOffset);
                        this._inputField.setTextFormat(ChatFormats.getTextFormatByChannel(this._channel));
                        this._inputField.addEventListener(Event.ENTER_FRAME, this.__setSelectIndexSync);
                    };
                }
                else
                {
                    if (_arg_1.keyCode == Keyboard.DOWN)
                    {
                        this.currentHistoryOffset++;
                        this._inputField.text = this.getHistoryChat(this.currentHistoryOffset);
                    };
                };
            };
            if (((_arg_1.keyCode == Keyboard.ENTER) && (!(ChatManager.Instance.chatDisabled))))
            {
                if (this._inputField.text.substr(0, 1) == "#")
                {
                    DebugManager.getInstance().handle(this._inputField.text);
                    this._inputField.text = "";
                }
                else
                {
                    if ((((!(this._inputField.text == "")) && (!(this.parasMsgs(this._inputField.text) == ""))) && (!(ChatManager.Instance.input.parent == null))))
                    {
                        if (this.isFocus())
                        {
                            if (ChatManager.Instance.state != ChatManager.CHAT_SHOP_STATE)
                            {
                                SoundManager.instance.play("008");
                                this.sendCurrnetText();
                            };
                        }
                        else
                        {
                            if (this.canUseKeyboardSetFocus())
                            {
                                this.setFocus();
                            };
                        };
                    }
                    else
                    {
                        ChatManager.Instance.switchVisible();
                        if (this.canUseKeyboardSetFocus())
                        {
                            ChatManager.Instance.setFocus();
                        };
                        if (ChatManager.Instance.visibleSwitchEnable)
                        {
                            SoundManager.instance.play("008");
                        };
                    };
                };
                this._currentHistoryOffset = ChatManager.Instance.model.resentChats.length;
            };
            if (ChatManager.Instance.input.parent != null)
            {
                if (ChatManager.Instance.visibleSwitchEnable)
                {
                    IMEManager.enable();
                };
            };
        }

        private function canUseKeyboardSetFocus():Boolean
        {
            if ((!(ChatManager.Instance.focusFuncEnabled)))
            {
                return (false);
            };
            if (((!(ChatManager.Instance.input.parent == null)) && (((ChatManager.Instance.state == ChatManager.CHAT_GAME_STATE) || (ChatManager.Instance.state == ChatManager.CHAT_GAMEOVER_STATE)) || (ChatManager.Instance.state == ChatManager.CHAT_MULTI_SHOOT_GAME_STATE))))
            {
                return (true);
            };
            if (((!(ChatManager.Instance.input.parent == null)) && (StageReferance.stage.focus == null)))
            {
                return (true);
            };
            return (false);
        }

        private function __onInputFieldChange(_arg_1:Event):void
        {
            if (this._inputField.text)
            {
                this._inputField.text = this._inputField.text.replace("\n", "").replace("\r", "");
            };
        }

        private function __setSelectIndexSync(_arg_1:Event):void
        {
            this._inputField.removeEventListener(Event.ENTER_FRAME, this.__setSelectIndexSync);
            this._inputField.setSelection(this._inputField.text.length, this._inputField.text.length);
        }

        private function get currentHistoryOffset():int
        {
            return (this._currentHistoryOffset);
        }

        private function set currentHistoryOffset(_arg_1:int):void
        {
            if (_arg_1 < 0)
            {
                _arg_1 = 0;
            };
            if (_arg_1 > (ChatManager.Instance.model.resentChats.length - 1))
            {
                _arg_1 = (ChatManager.Instance.model.resentChats.length - 1);
            };
            this._currentHistoryOffset = _arg_1;
        }

        private function getHistoryChat(_arg_1:int):String
        {
            if (_arg_1 == -1)
            {
                return ("");
            };
            return (Helpers.deCodeString(ChatManager.Instance.model.resentChats[_arg_1].msg));
        }

        private function initView():void
        {
            var _local_1:Point;
            _local_1 = ComponentFactory.Instance.creatCustomObject("chat.InputFieldTextFieldStartPos");
            this._nameTextField = new TextField();
            this._nameTextField.type = TextFieldType.DYNAMIC;
            this._nameTextField.mouseEnabled = false;
            this._nameTextField.selectable = false;
            this._nameTextField.autoSize = TextFieldAutoSize.LEFT;
            this._nameTextField.x = _local_1.x;
            this._nameTextField.y = _local_1.y;
            addChild(this._nameTextField);
            this._inputField = new TextField();
            this._inputField.type = TextFieldType.INPUT;
            this._inputField.autoSize = TextFieldAutoSize.NONE;
            this._inputField.multiline = false;
            this._inputField.wordWrap = false;
            this._inputField.maxChars = INPUT_MAX_CHAT;
            this._inputField.x = _local_1.x;
            this._inputField.y = _local_1.y;
            this._inputField.height = 20;
            addChild(this._inputField);
            this._inputField.addEventListener(Event.CHANGE, this.__onInputFieldChange);
            this.setTextFormat(new TextFormat("Arial", 12, 0xFF00));
            this.updatePosAndSize();
            StageReferance.stage.addEventListener(KeyboardEvent.KEY_DOWN, this.__onFieldKeyDown, false, int.MAX_VALUE);
        }

        private function parasMsgs(_arg_1:String):String
        {
            var _local_2:String = _arg_1;
            _local_2 = StringHelper.trim(_local_2);
            _local_2 = FilterWordManager.filterWrod(_local_2);
            return (StringHelper.rePlaceHtmlTextField(_local_2));
        }

        private function setTextFocus():void
        {
            StageReferance.stage.focus = this._inputField;
            this._inputField.setSelection(this._inputField.text.length, this._inputField.text.length);
        }

        private function setTextFormat(_arg_1:TextFormat):void
        {
            this._nameTextField.defaultTextFormat = _arg_1;
            this._nameTextField.setTextFormat(_arg_1);
            this._inputField.defaultTextFormat = _arg_1;
            this._inputField.setTextFormat(_arg_1);
        }

        private function updatePosAndSize():void
        {
            this._inputField.x = (70 + this._nameTextField.textWidth);
            if (this._nameTextField.textWidth > this._maxInputWidth)
            {
                return;
            };
            this._inputField.width = (this._maxInputWidth - this._nameTextField.textWidth);
        }


    }
}//package ddt.view.chat

