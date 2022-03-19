// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.chat.ChatBugleView

package ddt.view.chat
{
    import flash.display.Sprite;
    import flash.utils.Timer;
    import com.pickgliss.ui.image.ScaleFrameImage;
    import flash.display.Bitmap;
    import com.pickgliss.ui.text.FilterFrameText;
    import __AS3__.vec.Vector;
    import flash.display.MovieClip;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.utils.PositionUtils;
    import ddt.manager.ChatManager;
    import ddt.data.goods.ItemTemplateInfo;
    import ddt.utils.Helpers;
    import ddt.manager.ItemManager;
    import ddt.manager.LanguageMgr;
    import flash.events.TimerEvent;
    import ddt.manager.PlayerManager;
    import flash.events.Event;
    import ddt.manager.StateManager;
    import ddt.states.StateType;
    import com.pickgliss.ui.LayerManager;
    import ddt.manager.SharedManager;
    import __AS3__.vec.*;

    public class ChatBugleView extends Sprite 
    {

        private static const BIG_BUGLE:uint = 1;
        private static const SMALL_BUGLE:uint = 2;
        private static const ADMIN_NOTICE:uint = 3;
        private static const DEFY_AFFICHE:uint = 3;
        private static const CROSS_BUGLE:uint = 4;
        private static const CROSS_NOTICE:uint = 5;
        private static const MOVE_STEP:uint = 3;
        private static var _instance:ChatBugleView;

        private var _scrollTimer:Timer;
        private var _showTimer:Timer;
        private var _timer:Timer;
        private var _isplaying:Boolean;
        private var _bugleList:Array;
        private var _currentBugle:String;
        private var _currentBugleType:int;
        private var _currentBigBugleType:int;
        private var _buggleTypeMc:ScaleFrameImage;
        private var _bg:Bitmap;
        private var _bgMask:Bitmap;
        private var _bgMask1:Bitmap;
        private var _contentTxt:FilterFrameText;
        private var _contentTxt1:FilterFrameText;
        private var _animationTxt:FilterFrameText;
        private var _textCount:int;
        private var _bigBugleAnimations:Vector.<MovieClip>;


        public static function get instance():ChatBugleView
        {
            if (_instance == null)
            {
                _instance = new (ChatBugleView)();
            };
            return (_instance);
        }


        public function setup():void
        {
            this._bigBugleAnimations = new Vector.<MovieClip>(5);
            this._bg = ComponentFactory.Instance.creatBitmap("asset.chat.BugleViewBg");
            this._bgMask = ComponentFactory.Instance.creatBitmap("asset.chat.BugleViewBg");
            this._bgMask1 = ComponentFactory.Instance.creatBitmap("asset.chat.BugleViewBg");
            this._buggleTypeMc = ComponentFactory.Instance.creatComponentByStylename("chat.BugleViewType");
            this._contentTxt = ComponentFactory.Instance.creatComponentByStylename("chat.BugleViewText");
            this._contentTxt1 = ComponentFactory.Instance.creatComponentByStylename("chat.BugleViewText");
            this._animationTxt = ComponentFactory.Instance.creatComponentByStylename("chat.BugleAnimationText");
            this._showTimer = new Timer(8000);
            PositionUtils.setPos(this, "chat.BugleViewPos");
            this._isplaying = false;
            this._bugleList = [];
            this._currentBugleType = -1;
            addChild(this._bg);
            addChild(this._bgMask);
            addChild(this._bgMask1);
            this._bgMask.visible = false;
            this._bgMask1.visible = false;
            addChild(this._buggleTypeMc);
            addChild(this._contentTxt);
            mouseEnabled = (mouseChildren = false);
            this.initEvent();
        }

        private function initEvent():void
        {
            ChatManager.Instance.model.addEventListener(ChatEvent.ADD_CHAT, this.__onAddChat);
        }

        private function __onAddChat(_arg_1:ChatEvent):void
        {
            var _local_9:int;
            var _local_10:Object;
            var _local_11:Number;
            var _local_12:int;
            var _local_13:ItemTemplateInfo;
            var _local_14:uint;
            if ((((((ChatManager.Instance.state == ChatManager.CHAT_WEDDINGROOM_STATE) || (ChatManager.Instance.state == ChatManager.CHAT_HOTSPRING_ROOM_VIEW)) || (ChatManager.Instance.state == ChatManager.CHAT_TRAINER_STATE)) || (ChatManager.Instance.state == ChatManager.CHAT_LITTLEGAME)) || (ChatManager.Instance.isInGame)))
            {
                return;
            };
            var _local_2:ChatData = (_arg_1.data as ChatData);
            var _local_3:String = "";
            var _local_4:RegExp = /&lt;/g;
            var _local_5:RegExp = /&gt;/g;
            var _local_6:String = _local_2.msg.replace(_local_4, "<").replace(_local_5, ">");
            _local_6 = Helpers.deCodeString(_local_6);
            if (_local_2.link)
            {
                _local_9 = 0;
                _local_2.link.sortOn("index");
                for each (_local_10 in _local_2.link)
                {
                    _local_11 = _local_10.ItemID;
                    _local_12 = _local_10.TemplateID;
                    _local_13 = ItemManager.Instance.getTemplateById(_local_12);
                    _local_14 = (_local_10.index + _local_9);
                    if (_local_13 == null)
                    {
                        if (_local_12 == 0)
                        {
                            _local_6 = ((((_local_6.substring(0, _local_14) + "[") + LanguageMgr.GetTranslation("tank.view.card.chatLinkText0")) + "]") + _local_6.substring(_local_14));
                            _local_9 = (_local_9 + LanguageMgr.GetTranslation("tank.view.card.chatLinkText0").length);
                        }
                        else
                        {
                            _local_6 = (((((_local_6.substring(0, _local_14) + "[") + String(_local_12)) + LanguageMgr.GetTranslation("tank.view.card.chatLinkText")) + "]") + _local_6.substring(_local_14));
                            _local_9 = (_local_9 + (String(_local_12) + LanguageMgr.GetTranslation("tank.view.card.chatLinkText")).length);
                        };
                    }
                    else
                    {
                        _local_6 = ((((_local_6.substring(0, _local_14) + "[") + _local_13.Name) + "]") + _local_6.substring(_local_14));
                        _local_9 = (_local_9 + _local_13.Name.length);
                    };
                };
            };
            var _local_7:int = BIG_BUGLE;
            var _local_8:int = ChatData.B_BUGGLE_TYPE_NORMAL;
            if (_local_2.channel == ChatInputView.SMALL_BUGLE)
            {
                _local_7 = SMALL_BUGLE;
                _local_3 = ((("[" + _local_2.sender) + "]:") + _local_6);
            }
            else
            {
                if (_local_2.channel == ChatInputView.BIG_BUGLE)
                {
                    _local_7 = BIG_BUGLE;
                    if (_local_2.bigBuggleType != ChatData.B_BUGGLE_TYPE_NORMAL)
                    {
                        _local_8 = _local_2.bigBuggleType;
                        _local_3 = ((("[" + _local_2.sender) + "]:") + _local_6);
                    }
                    else
                    {
                        _local_8 = ChatData.B_BUGGLE_TYPE_NORMAL;
                        _local_3 = ((("[" + _local_2.sender) + "]:") + _local_6);
                    };
                }
                else
                {
                    if (_local_2.channel == ChatInputView.CROSS_BUGLE)
                    {
                        _local_7 = CROSS_BUGLE;
                        _local_3 = ((("[" + _local_2.sender) + "]:") + _local_6);
                    }
                    else
                    {
                        if (_local_2.channel == ChatInputView.CROSS_NOTICE)
                        {
                            _local_7 = ADMIN_NOTICE;
                            _local_3 = _local_6;
                        }
                        else
                        {
                            if (_local_2.channel == ChatInputView.DEFY_AFFICHE)
                            {
                                _local_7 = DEFY_AFFICHE;
                                _local_3 = _local_6;
                            }
                            else
                            {
                                if (((_local_2.channel == ChatInputView.SYS_NOTICE) || (_local_2.channel == ChatInputView.SYS_TIP)))
                                {
                                    if (((((((((_local_2.type == 1) || (_local_2.type == 3)) || (_local_2.type == 9)) || (_local_2.type == 5)) || (_local_2.type == 21)) || (_local_2.type == 4)) || (_local_2.type == 16)) || (_local_2.type == 6)))
                                    {
                                        _local_7 = ADMIN_NOTICE;
                                        _local_3 = _local_6;
                                    }
                                    else
                                    {
                                        return;
                                    };
                                }
                                else
                                {
                                    return;
                                };
                            };
                        };
                    };
                };
            };
            this._bugleList.push(new ChatBugleData(_local_3, _local_7, _local_8));
            this.checkPlay();
        }

        private function __showTimer(_arg_1:TimerEvent):void
        {
            this._isplaying = false;
            this._showTimer.stop();
            this._showTimer.removeEventListener(TimerEvent.TIMER, this.__showTimer);
            this.checkPlay();
        }

        private function checkPlay():void
        {
            var _local_1:ChatBugleData;
            if (PlayerManager.Instance.Self.Grade > 1)
            {
                if (this._isplaying)
                {
                    return;
                };
                if (this._bugleList.length > 0)
                {
                    if (this._bugleList.length > 10)
                    {
                        this._bugleList.splice(0, (this._bugleList.length - 10));
                    };
                    _local_1 = this._bugleList.splice(0, 1)[0];
                    this._currentBugle = _local_1.content;
                    this._currentBugleType = _local_1.BugleType;
                    this._currentBigBugleType = _local_1.subBugleType;
                    if (this._animationTxt.parent)
                    {
                        this._animationTxt.parent.removeChild(this._animationTxt);
                    };
                    this.removeAllBuggleAnimations();
                    this._buggleTypeMc.setFrame(this._currentBugleType);
                    addChild(this._bg);
                    addChild(this._buggleTypeMc);
                    addChild(this._contentTxt);
                    if (this._currentBugleType == BIG_BUGLE)
                    {
                        this._contentTxt.textColor = ChatFormats.getColorByChannel(ChatInputView.BIG_BUGLE);
                        if (this._currentBigBugleType != ChatData.B_BUGGLE_TYPE_NORMAL)
                        {
                            if (this._contentTxt.parent)
                            {
                                this._contentTxt.parent.removeChild(this._contentTxt);
                            };
                            if (this._buggleTypeMc.parent)
                            {
                                this._buggleTypeMc.parent.removeChild(this._buggleTypeMc);
                            };
                            if (this._bg.parent)
                            {
                                this._bg.parent.removeChild(this._bg);
                            };
                            this._animationTxt.textColor = ChatFormats.getColorByBigBuggleType((this._currentBigBugleType - 1));
                            if (this._bigBugleAnimations[(this._currentBigBugleType - 1)] == null)
                            {
                                this._bigBugleAnimations[(this._currentBigBugleType - 1)] = ComponentFactory.Instance.creat(("chat.BugleAnimation_" + (this._currentBigBugleType - 1).toString()));
                                PositionUtils.setPos(this._bigBugleAnimations[(this._currentBigBugleType - 1)], ("chat.BugleAnimationPos_" + (this._currentBigBugleType - 1).toString()));
                            };
                            this._animationTxt.x = this._bigBugleAnimations[(this._currentBigBugleType - 1)].x;
                            this._animationTxt.y = this._bigBugleAnimations[(this._currentBigBugleType - 1)].y;
                            this._bigBugleAnimations[(this._currentBigBugleType - 1)].play();
                            addChild(this._bigBugleAnimations[(this._currentBigBugleType - 1)]);
                            addChild(this._animationTxt);
                            this._animationTxt.text = this._currentBugle;
                            this._isplaying = true;
                            this._showTimer.addEventListener(TimerEvent.TIMER, this.__showTimer);
                            this.checkNeedTimer();
                            this.show();
                            return;
                        };
                    }
                    else
                    {
                        if (this._currentBugleType == SMALL_BUGLE)
                        {
                            this._contentTxt.textColor = ChatFormats.getColorByChannel(ChatInputView.SMALL_BUGLE);
                        }
                        else
                        {
                            if (this._currentBugleType == ADMIN_NOTICE)
                            {
                                this._contentTxt.textColor = ChatFormats.getColorByChannel(ChatInputView.ADMIN_NOTICE);
                            }
                            else
                            {
                                if (this._currentBugleType == DEFY_AFFICHE)
                                {
                                    this._contentTxt.textColor = ChatFormats.getColorByChannel(ChatInputView.DEFY_AFFICHE);
                                }
                                else
                                {
                                    if (this._currentBugleType == CROSS_BUGLE)
                                    {
                                        this._contentTxt.textColor = ChatFormats.getColorByChannel(ChatInputView.BIG_BUGLE);
                                    }
                                    else
                                    {
                                        if (this._currentBugleType == CROSS_NOTICE)
                                        {
                                            this._contentTxt.textColor = ChatFormats.getColorByChannel(ChatInputView.CROSS_NOTICE);
                                        };
                                    };
                                };
                            };
                        };
                    };
                    this._contentTxt.text = this._currentBugle;
                    this._contentTxt.mask = this._bgMask;
                    this.stringSplic();
                    this._isplaying = true;
                    this._contentTxt.visible = true;
                    this._contentTxt.y = 30;
                    this._contentTxt1.y = 30;
                    addEventListener(Event.ENTER_FRAME, this.moveFFT);
                    this.show();
                }
                else
                {
                    this.hide();
                };
            };
        }

        private function checkNeedTimer():void
        {
            this._showTimer.start();
        }

        public function show():void
        {
            if ((((StateManager.isInFight) || (StateManager.currentStateType == StateType.SHOP)) || ((StateManager.currentStateType == StateType.HOT_SPRING_ROOM) && (ChatManager.Instance.state == ChatManager.CHAT_HOTSPRING_ROOM_VIEW))))
            {
                return;
            };
            if ((((StateManager.currentStateType == StateType.TRAINER1) || (StateManager.currentStateType == StateType.TRAINER2)) || (StateManager.currentStateType == StateType.LODING_TRAINER)))
            {
                return;
            };
            if (((StateManager.currentStateType == StateType.FIGHT_LIB_GAMEVIEW) || (StateManager.currentStateType == StateType.WORLDBOSS_ROOM)))
            {
                return;
            };
            this.updatePos();
            if (this._currentBugleType == ADMIN_NOTICE)
            {
                LayerManager.Instance.addToLayer(this, LayerManager.STAGE_TOP_LAYER, false, 0, false);
                this.parent.setChildIndex(this, (this.parent.numChildren - 1));
                return;
            };
            if (SharedManager.Instance.showTopMessageBar)
            {
                LayerManager.Instance.addToLayer(this, LayerManager.STAGE_TOP_LAYER, false, 0, false);
                this.parent.setChildIndex(this, (this.parent.numChildren - 1));
            }
            else
            {
                this.hide();
            };
        }

        public function updatePos():void
        {
            if (this._currentBigBugleType == ChatData.B_BUGGLE_TYPE_NORMAL)
            {
                x = 167;
            }
            else
            {
                x = 0;
            };
            if (StateManager.currentStateType == StateType.SINGLEDUNGEON)
            {
                y = 45;
            }
            else
            {
                y = 0;
            };
        }

        private function removeAllBuggleAnimations():void
        {
            var _local_1:int;
            while (_local_1 < this._bigBugleAnimations.length)
            {
                if (this._bigBugleAnimations[_local_1])
                {
                    if (this._bigBugleAnimations[_local_1].parent)
                    {
                        this._bigBugleAnimations[_local_1].parent.removeChild(this._bigBugleAnimations[_local_1]);
                    };
                    this._bigBugleAnimations[_local_1].stop();
                };
                _local_1++;
            };
        }

        private function stringSplic():void
        {
            var _local_1:int;
            if (this._contentTxt.textWidth > 535)
            {
                _local_1 = 0;
                while (_local_1 < this._currentBugle.length)
                {
                    this._contentTxt.text = this._currentBugle.substr(0, _local_1);
                    if (this._contentTxt.textWidth >= 530)
                    {
                        this._contentTxt1.text = this._currentBugle.substr(_local_1, (this._currentBugle.length - 1));
                        addChild(this._contentTxt1);
                        this._textCount = 2;
                        this._contentTxt1.visible = false;
                        this._contentTxt1.textColor = this._contentTxt.textColor;
                        this._contentTxt1.mask = this._bgMask1;
                        return;
                    };
                    _local_1++;
                };
            }
            else
            {
                this._textCount = 2;
            };
        }

        private function moveFFT(_arg_1:Event):void
        {
            if (((this._contentTxt) && (this._contentTxt1.length == 0)))
            {
                this._contentTxt.y--;
                if (this._contentTxt.y == 6)
                {
                    this._timer = new Timer(5000);
                    this._timer.start();
                    removeEventListener(Event.ENTER_FRAME, this.moveFFT);
                    this._timer.addEventListener(TimerEvent.TIMER, this.stopEnterFrame);
                };
                if (this._contentTxt.y < -(this._contentTxt.textHeight + 6))
                {
                    this._contentTxt.visible = false;
                    this._isplaying = false;
                    removeEventListener(Event.ENTER_FRAME, this.moveFFT);
                    this.checkPlay();
                };
            };
            if (this._contentTxt1.length != 0)
            {
                if (this._contentTxt.visible)
                {
                    this._contentTxt.y--;
                };
                if (this._contentTxt1.visible)
                {
                    this._contentTxt1.y--;
                };
                if (this._contentTxt.y == 6)
                {
                    this._timer = new Timer(3000);
                    this._timer.start();
                    removeEventListener(Event.ENTER_FRAME, this.moveFFT);
                    this._timer.addEventListener(TimerEvent.TIMER, this.stopEnterFrame);
                };
                if (this._contentTxt.y < -(this._contentTxt.textHeight + 6))
                {
                    this._contentTxt1.visible = true;
                    this._contentTxt.visible = false;
                    this._contentTxt.y = 30;
                };
                if (this._contentTxt1.y == 6)
                {
                    this._timer = new Timer(3000);
                    this._timer.start();
                    removeEventListener(Event.ENTER_FRAME, this.moveFFT);
                    this._timer.addEventListener(TimerEvent.TIMER, this.stopEnterFrame);
                };
                if (this._contentTxt1.y < -(this._contentTxt1.textHeight + 6))
                {
                    this._contentTxt1.visible = false;
                    this._isplaying = false;
                    this._contentTxt1.text = "";
                    removeEventListener(Event.ENTER_FRAME, this.moveFFT);
                    this.checkPlay();
                };
            };
        }

        private function stopEnterFrame(_arg_1:TimerEvent):void
        {
            this._timer.stop();
            if (this._contentTxt.y == 6)
            {
                this._contentTxt.y = (this._contentTxt.y - 1);
            };
            if (this._contentTxt1.visible)
            {
                this._contentTxt1.y = (this._contentTxt1.y - 1);
            };
            this._timer.removeEventListener(TimerEvent.TIMER, this.stopEnterFrame);
            addEventListener(Event.ENTER_FRAME, this.moveFFT);
        }

        public function hide():void
        {
            if (parent)
            {
                parent.removeChild(this);
            };
            this.removeAllBuggleAnimations();
            if (this._animationTxt.parent)
            {
                this._animationTxt.parent.removeChild(this._animationTxt);
            };
        }


    }
}//package ddt.view.chat

class ChatBugleData 
{

    public var content:String;
    public var BugleType:int;
    public var subBugleType:int;

    public function ChatBugleData(_arg_1:String, _arg_2:int, _arg_3:int)
    {
        this.content = _arg_1;
        this.BugleType = _arg_2;
        this.subBugleType = _arg_3;
    }

}


