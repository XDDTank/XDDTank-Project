// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.chat.ChatModel

package ddt.view.chat
{
    import flash.events.EventDispatcher;
    import flash.utils.Dictionary;
    import __AS3__.vec.Vector;
    import ddt.utils.FilterWordManager;
    import ddt.data.goods.ItemTemplateInfo;
    import ddt.manager.PlayerManager;
    import com.pickgliss.utils.StringUtils;
    import ddt.manager.ChatManager;
    import __AS3__.vec.*;

    public final class ChatModel extends EventDispatcher 
    {

        private static const OVERCOUNT:int = 200;

        private var _clubChats:Array;
        private var _currentChats:Array;
        private var _privateChats:Array;
        private var _resentChats:Array;
        private var _linkInfoMap:Dictionary;
        private var _customFastReply:Vector.<String>;
        private var _outPutType:Object;

        public function ChatModel()
        {
            this.reset();
        }

        public function addChat(_arg_1:ChatData):void
        {
            this.tryAddToCurrentChats(_arg_1);
            this.tryAddToRecent(_arg_1);
            this.tryAddToClubChats(_arg_1);
            this.tryAddToPrivateChats(_arg_1);
            _arg_1.htmlMessage = FilterWordManager.filterWrodFromServer(_arg_1.htmlMessage);
            dispatchEvent(new ChatEvent(ChatEvent.ADD_CHAT, _arg_1));
            if (((_arg_1.channel == ChatInputView.TEAM) || (_arg_1.channel == ChatInputView.PRIVATE)))
            {
                dispatchEvent(new ChatEvent(ChatEvent.BUTTON_SHINE));
            };
        }

        public function get customFastReply():Vector.<String>
        {
            return (this._customFastReply);
        }

        public function addLink(_arg_1:String, _arg_2:ItemTemplateInfo):void
        {
            this._linkInfoMap[_arg_1] = _arg_2;
        }

        public function getLink(_arg_1:String):ItemTemplateInfo
        {
            return (this._linkInfoMap[_arg_1]);
        }

        public function removeAllLink():void
        {
            this._linkInfoMap = new Dictionary();
        }

        public function getChatsByOutputChannel(_arg_1:int, _arg_2:int, _arg_3:int):Object
        {
            _arg_2 = ((_arg_2 < 0) ? 0 : _arg_2);
            var _local_4:Array = [];
            if (_arg_1 == ChatOutputView.CHAT_OUPUT_CURRENT)
            {
                _local_4 = this._currentChats;
            }
            else
            {
                if (_arg_1 == ChatOutputView.CHAT_OUPUT_CLUB)
                {
                    _local_4 = this._clubChats;
                }
                else
                {
                    if (_arg_1 == ChatOutputView.CHAT_OUPUT_PRIVATE)
                    {
                        _local_4 = this._privateChats;
                    };
                };
            };
            if (_local_4.length <= _arg_3)
            {
                return ({
                    "offset":0,
                    "result":_local_4
                });
            };
            if (_local_4.length <= (_arg_3 + _arg_2))
            {
                return ({
                    "offset":(_local_4.length - _arg_3),
                    "result":_local_4.slice(0, _arg_3)
                });
            };
            return ({
                "offset":_arg_2,
                "result":_local_4.slice(((_local_4.length - _arg_3) - _arg_2), (_local_4.length - _arg_2))
            });
        }

        public function getInputInOutputChannel(_arg_1:int, _arg_2:int):Boolean
        {
            if (_arg_2 == ChatOutputView.CHAT_OUPUT_CLUB)
            {
                switch (_arg_1)
                {
                    case ChatInputView.CONSORTIA:
                    case ChatInputView.SYS_NOTICE:
                    case ChatInputView.SYS_TIP:
                    case ChatInputView.BIG_BUGLE:
                    case ChatInputView.SMALL_BUGLE:
                    case ChatInputView.DEFY_AFFICHE:
                    case ChatInputView.CROSS_NOTICE:
                        return (true);
                    case ChatInputView.CROSS_BUGLE:
                        return (true);
                };
            }
            else
            {
                if (_arg_2 == ChatOutputView.CHAT_OUPUT_PRIVATE)
                {
                    switch (_arg_1)
                    {
                        case ChatInputView.PRIVATE:
                        case ChatInputView.SYS_NOTICE:
                        case ChatInputView.SYS_TIP:
                        case ChatInputView.BIG_BUGLE:
                        case ChatInputView.SMALL_BUGLE:
                        case ChatInputView.DEFY_AFFICHE:
                        case ChatInputView.CROSS_NOTICE:
                            return (true);
                        case ChatInputView.CROSS_BUGLE:
                            return (true);
                    };
                }
                else
                {
                    if (_arg_2 == ChatOutputView.CHAT_OUPUT_CURRENT)
                    {
                        return (true);
                    };
                };
            };
            return (false);
        }

        public function reset():void
        {
            this._currentChats = [];
            this._clubChats = [];
            this._privateChats = [];
            this._resentChats = [];
            this._customFastReply = new Vector.<String>();
            this._linkInfoMap = new Dictionary();
            this._outPutType = new Object();
        }

        public function get clubChats():Array
        {
            return (this._clubChats);
        }

        public function get currentChats():Array
        {
            return (this._currentChats);
        }

        public function get privateChats():Array
        {
            return (this._privateChats);
        }

        public function get resentChats():Array
        {
            return (this._resentChats);
        }

        private function checkOverCount(_arg_1:Array):void
        {
            if (_arg_1.length > OVERCOUNT)
            {
                _arg_1.shift();
            };
        }

        private function tryAddToClubChats(_arg_1:ChatData):void
        {
            if (this.getInputInOutputChannel(_arg_1.channel, ChatOutputView.CHAT_OUPUT_CLUB))
            {
                this._clubChats.push(_arg_1);
            };
            this.checkOverCount(this._clubChats);
        }

        private function tryAddToCurrentChats(_arg_1:ChatData):void
        {
            this._currentChats.push(_arg_1);
            this.checkOverCount(this._currentChats);
        }

        private function tryAddToPrivateChats(_arg_1:ChatData):void
        {
            if (this.getInputInOutputChannel(_arg_1.channel, ChatOutputView.CHAT_OUPUT_PRIVATE))
            {
                this._privateChats.push(_arg_1);
                if (((((!(PlayerManager.Instance.Self.playerState.AutoReply == "")) && (!(StringUtils.isEmpty(_arg_1.sender)))) && (_arg_1.receiver == PlayerManager.Instance.Self.NickName)) && (_arg_1.isAutoReply == false)))
                {
                    ChatManager.Instance.sendPrivateMessage(_arg_1.sender, FilterWordManager.filterWrod(PlayerManager.Instance.Self.playerState.AutoReply), _arg_1.senderID, true);
                };
            };
            this.checkOverCount(this._privateChats);
        }

        private function tryAddToRecent(_arg_1:ChatData):void
        {
            if (_arg_1.sender == PlayerManager.Instance.Self.NickName)
            {
                this._resentChats.push(_arg_1);
            };
            this.checkOverCount(this._resentChats);
        }

        public function get outPutType():Object
        {
            return (this._outPutType);
        }

        public function set outPutType(_arg_1:Object):void
        {
            this._outPutType = _arg_1;
        }


    }
}//package ddt.view.chat

