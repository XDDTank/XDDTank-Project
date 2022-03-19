// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//im.chatFrame.PrivateChatFrame

package im.chatFrame
{
    import com.pickgliss.ui.controls.MinimizeFrame;
    import ddt.data.player.PlayerInfo;
    import com.pickgliss.ui.image.ScaleBitmapImage;
    import com.pickgliss.ui.text.TextArea;
    import com.pickgliss.ui.controls.TextButton;
    import com.pickgliss.ui.controls.SimpleBitmapButton;
    import ddt.view.PlayerPortraitView;
    import com.pickgliss.ui.text.FilterFrameText;
    import ddt.view.common.LevelIcon;
    import com.pickgliss.ui.text.GradientText;
    import flash.display.Bitmap;
    import ddt.data.player.SelfInfo;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.PlayerManager;
    import vip.VipController;
    import __AS3__.vec.Vector;
    import com.pickgliss.events.FrameEvent;
    import flash.events.MouseEvent;
    import flash.events.KeyboardEvent;
    import flash.events.FocusEvent;
    import flash.events.Event;
    import im.IMController;
    import flash.ui.Keyboard;
    import ddt.manager.SoundManager;
    import ddt.utils.PositionUtils;
    import ddt.manager.MessageTipManager;
    import road7th.utils.StringHelper;
    import ddt.utils.FilterWordManager;
    import ddt.manager.SocketManager;
    import com.pickgliss.utils.ObjectUtils;

    public class PrivateChatFrame extends MinimizeFrame 
    {

        private var _info:PlayerInfo;
        private var _outputBG:ScaleBitmapImage;
        private var _inputBG:ScaleBitmapImage;
        private var _output:TextArea;
        private var _input:TextArea;
        private var _send:TextButton;
        private var _record:SimpleBitmapButton;
        private var _recordFrame:PrivateRecordFrame;
        private var _show:Boolean = false;
        private var _selfPortrait:PlayerPortraitView;
        private var _selfLevelT:FilterFrameText;
        private var _selfLevel:LevelIcon;
        private var _selfName:FilterFrameText;
        private var _selfVipName:GradientText;
        private var _targetProtrait:PlayerPortraitView;
        private var _targetLevelT:FilterFrameText;
        private var _targetLevel:LevelIcon;
        private var _targetName:FilterFrameText;
        private var _targetVipName:GradientText;
        private var _warningBg:Bitmap;
        private var _warning:Bitmap;
        private var _warningWord:FilterFrameText;

        public function PrivateChatFrame()
        {
            this.initView();
            this.initEvent();
        }

        private function initView():void
        {
            var _local_1:SelfInfo;
            this.titleText = LanguageMgr.GetTranslation("chat.frameTitle");
            this._selfPortrait = ComponentFactory.Instance.creatCustomObject("chatFrame.selfPortrait", ["right"]);
            this._selfLevelT = ComponentFactory.Instance.creatComponentByStylename("chatFrame.selflevel");
            this._selfLevel = ComponentFactory.Instance.creatCustomObject("chatFrame.selfLevelIcon");
            this._targetProtrait = ComponentFactory.Instance.creatCustomObject("chatFrame.targetPortrait", ["right"]);
            this._targetLevelT = ComponentFactory.Instance.creatComponentByStylename("chatFrame.targetlevel");
            this._targetLevel = ComponentFactory.Instance.creatCustomObject("chatFrame.targetLevelIcon");
            this._outputBG = ComponentFactory.Instance.creatComponentByStylename("chatFrame.outputBG");
            this._inputBG = ComponentFactory.Instance.creatComponentByStylename("chatFrame.inputBG");
            this._output = ComponentFactory.Instance.creatComponentByStylename("chatFrame.output");
            this._input = ComponentFactory.Instance.creatComponentByStylename("chatFrame.input");
            this._send = ComponentFactory.Instance.creatComponentByStylename("chatFrame.send");
            this._send.text = LanguageMgr.GetTranslation("im.InviteDialogFrame.send");
            this._record = ComponentFactory.Instance.creatComponentByStylename("chatFrame.record");
            this._warningBg = ComponentFactory.Instance.creatBitmap("asset.chatFrame.worningbg");
            this._warning = ComponentFactory.Instance.creatBitmap("asset.chatFrame.worning");
            this._warningWord = ComponentFactory.Instance.creatComponentByStylename("chatFrame.warningword");
            addToContent(this._selfPortrait);
            addToContent(this._selfLevelT);
            addToContent(this._selfLevel);
            addToContent(this._targetProtrait);
            addToContent(this._targetLevelT);
            addToContent(this._targetLevel);
            addToContent(this._outputBG);
            addToContent(this._inputBG);
            addToContent(this._output);
            addToContent(this._input);
            addToContent(this._send);
            addToContent(this._record);
            addToContent(this._warningBg);
            addToContent(this._warningWord);
            addToContent(this._warning);
            this._input.textField.maxChars = 150;
            this._send.tipStyle = "ddt.view.tips.OneLineTip";
            this._send.tipDirctions = "0";
            this._send.tipGapV = 5;
            this._send.tipData = LanguageMgr.GetTranslation("IM.privateChatFrame.send.tipdata");
            _local_1 = PlayerManager.Instance.Self;
            this._selfPortrait.info = _local_1;
            this._selfLevelT.text = LanguageMgr.GetTranslation("IM.ChatFrame.level");
            this._selfLevel.setSize(LevelIcon.SIZE_SMALL);
            this._selfLevel.setInfo(_local_1.Grade, _local_1.Repute, _local_1.WinCount, _local_1.TotalCount, _local_1.FightPower, _local_1.Offer, false, true);
            this._selfLevel.mouseChildren = false;
            this._selfLevel.mouseEnabled = false;
            this._selfName = ComponentFactory.Instance.creatComponentByStylename("chatFrame.selfName");
            if (_local_1.IsVIP)
            {
                this._selfVipName = VipController.instance.getVipNameTxt(84, _local_1.VIPtype);
                this._selfVipName.textSize = 14;
                this._selfVipName.x = this._selfName.x;
                this._selfVipName.y = this._selfName.y;
                this._selfVipName.text = _local_1.NickName;
                addToContent(this._selfVipName);
            }
            else
            {
                this._selfName.text = _local_1.NickName;
                addToContent(this._selfName);
            };
            this._targetLevelT.text = LanguageMgr.GetTranslation("IM.ChatFrame.level");
            this._targetLevel.setSize(LevelIcon.SIZE_SMALL);
            this._targetLevel.mouseChildren = false;
            this._targetLevel.mouseEnabled = false;
            this._warningWord.text = LanguageMgr.GetTranslation("IM.ChatFrame.warning");
        }

        public function set playerInfo(_arg_1:PlayerInfo):void
        {
            if (this._info != _arg_1)
            {
                this._input.text = "";
                this._output.htmlText = "";
                this.closeRecordFrame();
            };
            this._info = _arg_1;
            this._targetProtrait.info = this._info;
            this._targetLevel.setInfo(this._info.Grade, this._info.Repute, this._info.WinCount, this._info.TotalCount, this._info.FightPower, this._info.Offer, false, true);
            if (this._targetName == null)
            {
                this._targetName = ComponentFactory.Instance.creatComponentByStylename("chatFrame.targetName");
            };
            if (this._info.IsVIP)
            {
                if (this._targetVipName == null)
                {
                    this._targetVipName = VipController.instance.getVipNameTxt(84, this._info.VIPtype);
                    this._targetVipName.textSize = 14;
                    this._targetVipName.x = this._targetName.x;
                    this._targetVipName.y = this._targetName.y;
                    addToContent(this._targetVipName);
                };
                if (this._targetName)
                {
                    this._targetName.visible = false;
                };
                this._targetVipName.visible = true;
                this._targetVipName.text = this._info.NickName;
            }
            else
            {
                addToContent(this._targetName);
                if (this._targetVipName)
                {
                    this._targetVipName.visible = false;
                };
                this._targetName.visible = true;
                this._targetName.text = this._info.NickName;
            };
        }

        public function clearOutput():void
        {
            this._output.htmlText = "";
        }

        public function addMessage(_arg_1:String):void
        {
            this._output.htmlText = (this._output.htmlText + (_arg_1 + "<br/>"));
            this._output.textField.setSelection((this._output.text.length - 1), (this._output.text.length - 1));
            this._output.upScrollArea();
        }

        public function addAllMessage(_arg_1:Vector.<String>):void
        {
            this._output.htmlText = "";
            var _local_2:int;
            while (_local_2 < _arg_1.length)
            {
                this._output.htmlText = (this._output.htmlText + (_arg_1[_local_2] + "<br/>"));
                _local_2++;
            };
            this._output.textField.setSelection((this._output.text.length - 1), (this._output.text.length - 1));
            this._output.upScrollArea();
        }

        public function get playerInfo():PlayerInfo
        {
            return (this._info);
        }

        private function initEvent():void
        {
            addEventListener(FrameEvent.RESPONSE, this.__responseHandler);
            this._send.addEventListener(MouseEvent.CLICK, this.__sendHandler);
            this._record.addEventListener(MouseEvent.CLICK, this.__recordHandler);
            this._input.addEventListener(KeyboardEvent.KEY_UP, this.__keyUpHandler);
            this._input.addEventListener(KeyboardEvent.KEY_DOWN, this.__keyDownHandler);
            this._input.addEventListener(FocusEvent.FOCUS_IN, this.__focusInHandler);
            this._input.addEventListener(FocusEvent.FOCUS_OUT, this.__focusOutHandler);
            addEventListener(Event.ADDED_TO_STAGE, this.__addToStageHandler);
        }

        private function removeEvent():void
        {
            removeEventListener(FrameEvent.RESPONSE, this.__responseHandler);
            this._send.removeEventListener(MouseEvent.CLICK, this.__sendHandler);
            this._record.removeEventListener(MouseEvent.CLICK, this.__recordHandler);
            this._input.removeEventListener(KeyboardEvent.KEY_UP, this.__keyUpHandler);
            this._input.removeEventListener(KeyboardEvent.KEY_DOWN, this.__keyDownHandler);
            this._input.removeEventListener(FocusEvent.FOCUS_IN, this.__focusInHandler);
            this._input.removeEventListener(FocusEvent.FOCUS_OUT, this.__focusOutHandler);
            removeEventListener(Event.ADDED_TO_STAGE, this.__addToStageHandler);
        }

        private function __keyDownHandler(_arg_1:KeyboardEvent):void
        {
            _arg_1.stopImmediatePropagation();
            _arg_1.stopPropagation();
        }

        protected function __addToStageHandler(_arg_1:Event):void
        {
            this._input.textField.setFocus();
        }

        protected function __focusOutHandler(_arg_1:FocusEvent):void
        {
            IMController.Instance.privateChatFocus = false;
        }

        protected function __focusInHandler(_arg_1:FocusEvent):void
        {
            IMController.Instance.privateChatFocus = true;
        }

        protected function __keyUpHandler(_arg_1:KeyboardEvent):void
        {
            _arg_1.stopImmediatePropagation();
            _arg_1.stopPropagation();
            if (_arg_1.keyCode == Keyboard.ENTER)
            {
                this.__sendHandler(null);
            };
        }

        protected function __recordHandler(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            if (this._recordFrame == null)
            {
                this._recordFrame = ComponentFactory.Instance.creatComponentByStylename("privateRecordFrame");
                this._recordFrame.addEventListener(FrameEvent.RESPONSE, this.__recordResponseHandler);
                this._recordFrame.addEventListener(PrivateRecordFrame.CLOSE, this.__recordCloseHandler);
                PositionUtils.setPos(this._recordFrame, "recordFrame.pos");
            };
            if ((!(this._show)))
            {
                addToContent(this._recordFrame);
                this._recordFrame.playerId = this._info.ID;
                this._show = true;
            }
            else
            {
                this.closeRecordFrame();
            };
        }

        private function closeRecordFrame():void
        {
            if (((this._recordFrame) && (this._recordFrame.parent)))
            {
                this._recordFrame.parent.removeChild(this._recordFrame);
            };
            this._show = false;
        }

        protected function __recordCloseHandler(_arg_1:Event):void
        {
            SoundManager.instance.play("008");
            this._recordFrame.parent.removeChild(this._recordFrame);
            this._show = false;
        }

        protected function __recordResponseHandler(_arg_1:FrameEvent):void
        {
            if (_arg_1.responseCode == FrameEvent.CLOSE_CLICK)
            {
                SoundManager.instance.play("008");
                this._recordFrame.parent.removeChild(this._recordFrame);
                this._show = false;
            };
        }

        protected function __sendHandler(_arg_1:MouseEvent):void
        {
            var _local_2:String;
            SoundManager.instance.play("008");
            if (this._info.Grade < 5)
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("IM.other.noEnough.five"));
                return;
            };
            if (StringHelper.trim(this._input.text) != "")
            {
                _local_2 = this._input.text.replace(/</g, "&lt;").replace(/>/g, "&gt;");
                _local_2 = FilterWordManager.filterWrod(_local_2);
                SocketManager.Instance.out.sendOneOnOneTalk(this._info.ID, _local_2);
                this._input.text = "";
            }
            else
            {
                this._input.text = "";
            };
            this.__addToStageHandler(null);
        }

        private function checkHtmlTag(_arg_1:String):Boolean
        {
            if (((!(_arg_1.indexOf("<") == -1)) || (FilterWordManager.isGotForbiddenWords(_arg_1))))
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("IM.privateChatFrame.failWord"));
                return (false);
            };
            return (true);
        }

        protected function __responseHandler(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            switch (_arg_1.responseCode)
            {
                case FrameEvent.ESC_CLICK:
                case FrameEvent.CLOSE_CLICK:
                    IMController.Instance.disposePrivateFrame(this._info.ID);
                    this._output.htmlText = "";
                    return;
                case FrameEvent.MINIMIZE_CLICK:
                    IMController.Instance.hidePrivateFrame(this._info.ID);
                    return;
            };
        }

        override public function dispose():void
        {
            IMController.Instance.privateChatFocus = false;
            this.removeEvent();
            super.dispose();
            if (this._recordFrame)
            {
                this._recordFrame.removeEventListener(FrameEvent.RESPONSE, this.__recordResponseHandler);
                this._recordFrame.removeEventListener(PrivateRecordFrame.CLOSE, this.__recordCloseHandler);
                this._recordFrame.dispose();
                this._recordFrame = null;
            };
            this._info = null;
            if (this._outputBG)
            {
                ObjectUtils.disposeObject(this._outputBG);
            };
            this._outputBG = null;
            if (this._inputBG)
            {
                ObjectUtils.disposeObject(this._inputBG);
            };
            this._inputBG = null;
            if (this._output)
            {
                ObjectUtils.disposeObject(this._output);
            };
            this._output = null;
            if (this._input)
            {
                ObjectUtils.disposeObject(this._input);
            };
            this._input = null;
            if (this._send)
            {
                ObjectUtils.disposeObject(this._send);
            };
            this._send = null;
            if (this._record)
            {
                ObjectUtils.disposeObject(this._record);
            };
            this._record = null;
            if (this._selfPortrait)
            {
                ObjectUtils.disposeObject(this._selfPortrait);
            };
            this._selfPortrait = null;
            if (this._selfLevelT)
            {
                ObjectUtils.disposeObject(this._selfLevelT);
            };
            this._selfLevelT = null;
            if (this._selfLevel)
            {
                ObjectUtils.disposeObject(this._selfLevel);
            };
            this._selfLevel = null;
            if (this._selfName)
            {
                ObjectUtils.disposeObject(this._selfName);
            };
            this._selfName = null;
            if (this._selfVipName)
            {
                ObjectUtils.disposeObject(this._selfVipName);
            };
            this._selfVipName = null;
            if (this._targetProtrait)
            {
                ObjectUtils.disposeObject(this._targetProtrait);
            };
            this._targetProtrait = null;
            if (this._targetLevelT)
            {
                ObjectUtils.disposeObject(this._targetLevelT);
            };
            this._targetLevelT = null;
            if (this._targetLevel)
            {
                ObjectUtils.disposeObject(this._targetLevel);
            };
            this._targetLevel = null;
            if (this._targetName)
            {
                ObjectUtils.disposeObject(this._targetName);
            };
            this._targetName = null;
            if (this._targetVipName)
            {
                ObjectUtils.disposeObject(this._targetVipName);
            };
            this._targetVipName = null;
            if (this._warningBg)
            {
                ObjectUtils.disposeObject(this._warningBg);
            };
            this._warningBg = null;
            if (this._warning)
            {
                ObjectUtils.disposeObject(this._warning);
            };
            this._warning = null;
            if (this._warningWord)
            {
                ObjectUtils.disposeObject(this._warningWord);
            };
            this._warningWord = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package im.chatFrame

