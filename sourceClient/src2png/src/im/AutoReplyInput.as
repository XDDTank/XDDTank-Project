// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//im.AutoReplyInput

package im
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.text.FilterFrameText;
    import flash.display.Bitmap;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.PlayerManager;
    import flash.text.TextFieldType;
    import flash.text.TextFieldAutoSize;
    import flash.events.MouseEvent;
    import flash.events.FocusEvent;
    import flash.events.KeyboardEvent;
    import ddt.events.PlayerPropertyEvent;
    import flash.ui.Keyboard;
    import com.pickgliss.toplevel.StageReferance;
    import flash.utils.setTimeout;
    import flash.text.TextField;
    import com.pickgliss.utils.ObjectUtils;

    public class AutoReplyInput extends Sprite implements Disposeable 
    {

        private var WIDTH:int = 150;
        private var _input:FilterFrameText;
        private var _overBg:Bitmap;

        public function AutoReplyInput()
        {
            this._input = ComponentFactory.Instance.creatComponentByStylename("IM.stateItem.AutoReplyInputTxt");
            addChild(this._input);
            this._input.text = PlayerManager.Instance.Self.playerState.AutoReply;
            this._input.type = TextFieldType.INPUT;
            this._input.autoSize = TextFieldAutoSize.NONE;
            this._input.width = 160;
            this._input.height = 20;
            this._input.maxChars = 20;
            this._overBg = ComponentFactory.Instance.creatBitmap("asset.IM.replyInputBgAsset");
            addChild(this._overBg);
            this._overBg.visible = false;
            this.initEvents();
        }

        private function initEvents():void
        {
            addEventListener(MouseEvent.MOUSE_OVER, this.__overHandler);
            addEventListener(MouseEvent.MOUSE_OUT, this.__outHandler);
            this._input.addEventListener(FocusEvent.FOCUS_IN, this.__focusIn);
            this._input.addEventListener(FocusEvent.FOCUS_OUT, this.__focusOut);
            this._input.addEventListener(KeyboardEvent.KEY_DOWN, this.__onKeyDown);
            PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE, this.__onChange);
        }

        private function removeEvents():void
        {
            removeEventListener(MouseEvent.MOUSE_OVER, this.__overHandler);
            removeEventListener(MouseEvent.MOUSE_OUT, this.__outHandler);
            this._input.removeEventListener(FocusEvent.FOCUS_IN, this.__focusIn);
            this._input.removeEventListener(FocusEvent.FOCUS_OUT, this.__focusOut);
            this._input.removeEventListener(KeyboardEvent.KEY_DOWN, this.__onKeyDown);
            PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE, this.__onChange);
        }

        private function __onKeyDown(_arg_1:KeyboardEvent):void
        {
            _arg_1.stopImmediatePropagation();
            _arg_1.stopPropagation();
            if (_arg_1.keyCode == Keyboard.ENTER)
            {
                PlayerManager.Instance.Self.playerState.AutoReply = this._input.text;
                this._input.text = this.getShortStr(PlayerManager.Instance.Self.playerState.AutoReply);
                StageReferance.stage.focus = null;
            };
        }

        private function __focusOut(_arg_1:FocusEvent):void
        {
            this._input.background = false;
            this._input.text = this.getShortStr(PlayerManager.Instance.Self.playerState.AutoReply);
            this._input.scrollH = 0;
        }

        private function __onChange(_arg_1:PlayerPropertyEvent):void
        {
            if (_arg_1.changedProperties["State"])
            {
                this._input.text = this.getShortStr(PlayerManager.Instance.Self.playerState.AutoReply);
            };
        }

        private function __focusIn(_arg_1:FocusEvent):void
        {
            this._overBg.visible = false;
            this._input.background = true;
            this._input.text = PlayerManager.Instance.Self.playerState.AutoReply;
            setTimeout(this._input.setSelection, 30, 0, this._input.text.length);
        }

        private function __outHandler(_arg_1:MouseEvent):void
        {
            this._overBg.visible = false;
        }

        private function getShortStr(_arg_1:String):String
        {
            var _local_2:TextField = new TextField();
            _local_2.wordWrap = true;
            _local_2.autoSize = TextFieldAutoSize.LEFT;
            _local_2.width = this._input.width;
            _local_2.text = _arg_1;
            if (_local_2.textWidth > (this._input.width - 15))
            {
                _arg_1 = _local_2.getLineText(0);
                _arg_1 = (_arg_1.substr(0, (_arg_1.length - 3)) + "...");
            };
            return (_arg_1);
        }

        private function __overHandler(_arg_1:MouseEvent):void
        {
            if (this._input.background == false)
            {
                this._overBg.visible = true;
            };
        }

        public function dispose():void
        {
            this.removeEvents();
            ObjectUtils.disposeObject(this._overBg);
            this._overBg = null;
            ObjectUtils.disposeObject(this._input);
            this._input = null;
        }


    }
}//package im

