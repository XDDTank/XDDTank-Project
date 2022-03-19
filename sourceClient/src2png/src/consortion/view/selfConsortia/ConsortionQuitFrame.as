// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//consortion.view.selfConsortia.ConsortionQuitFrame

package consortion.view.selfConsortia
{
    import com.pickgliss.ui.controls.Frame;
    import com.pickgliss.ui.image.MutipleImage;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.controls.TextInput;
    import com.pickgliss.ui.controls.TextButton;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.events.FrameEvent;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.events.KeyboardEvent;
    import ddt.manager.SoundManager;
    import ddt.manager.PlayerManager;
    import baglocked.BaglockedManager;
    import ddt.manager.SocketManager;
    import flash.ui.Keyboard;

    public class ConsortionQuitFrame extends Frame 
    {

        private var _bg:MutipleImage;
        private var _explain:FilterFrameText;
        private var _input:TextInput;
        private var _ok:TextButton;
        private var _cancel:TextButton;
        private var _quitWord:FilterFrameText;

        public function ConsortionQuitFrame()
        {
            this.initView();
            this.initEvent();
        }

        private function initView():void
        {
            escEnable = true;
            disposeChildren = true;
            titleText = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.ExitConsortiaFrame.titleText");
            this._bg = ComponentFactory.Instance.creatComponentByStylename("consortion.quitFrame.bg");
            this._explain = ComponentFactory.Instance.creatComponentByStylename("consortion.quitFrame.explain");
            this._quitWord = ComponentFactory.Instance.creatComponentByStylename("consortion.quit.word");
            this._input = ComponentFactory.Instance.creatComponentByStylename("consortion.quitFrame.input");
            this._ok = ComponentFactory.Instance.creatComponentByStylename("consortion.quitFrame.ok");
            this._cancel = ComponentFactory.Instance.creatComponentByStylename("consortion.quitFrame.cancel");
            addToContent(this._bg);
            addToContent(this._quitWord);
            this._explain = ComponentFactory.Instance.creatComponentByStylename("consortion.quitFrame.explain");
            addToContent(this._explain);
            addToContent(this._input);
            addToContent(this._ok);
            addToContent(this._cancel);
            this._explain.text = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.ExitConsortiaFrame.quit");
            this._quitWord.text = LanguageMgr.GetTranslation("consortion.quit.word.text");
            this._ok.text = LanguageMgr.GetTranslation("ok");
            this._cancel.text = LanguageMgr.GetTranslation("cancel");
            this._ok.enable = false;
            this._input.textField.maxChars = 8;
        }

        private function initEvent():void
        {
            addEventListener(FrameEvent.RESPONSE, this.__responseHandler);
            addEventListener(Event.ADDED_TO_STAGE, this.__addToStageHandler);
            this._ok.addEventListener(MouseEvent.CLICK, this.__clickHandler);
            this._cancel.addEventListener(MouseEvent.CLICK, this.__cancelHandler);
            this._input.addEventListener(Event.CHANGE, this.__inputChangeHandler);
            this._input.addEventListener(KeyboardEvent.KEY_DOWN, this.__keyDownHandler);
        }

        private function removeEvent():void
        {
            removeEventListener(FrameEvent.RESPONSE, this.__responseHandler);
            removeEventListener(Event.ADDED_TO_STAGE, this.__addToStageHandler);
            this._ok.removeEventListener(MouseEvent.CLICK, this.__clickHandler);
            this._cancel.removeEventListener(MouseEvent.CLICK, this.__cancelHandler);
            this._input.removeEventListener(Event.CHANGE, this.__inputChangeHandler);
            this._input.removeEventListener(KeyboardEvent.KEY_DOWN, this.__keyDownHandler);
        }

        private function __responseHandler(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            if (((_arg_1.responseCode == FrameEvent.CLOSE_CLICK) || (_arg_1.responseCode == FrameEvent.ESC_CLICK)))
            {
                this.dispose();
            };
            if (_arg_1.responseCode == FrameEvent.ENTER_CLICK)
            {
                this.quit();
            };
        }

        private function __addToStageHandler(_arg_1:Event):void
        {
            this._input.setFocus();
        }

        private function __clickHandler(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            this.quit();
        }

        private function quit():void
        {
            if (this._input.text.toLowerCase() == "quit")
            {
                if (PlayerManager.Instance.Self.bagLocked)
                {
                    BaglockedManager.Instance.show();
                    return;
                };
                SocketManager.Instance.out.sendConsortiaOut(PlayerManager.Instance.Self.ID);
                this.dispose();
            };
        }

        private function __cancelHandler(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            this.dispose();
        }

        private function __inputChangeHandler(_arg_1:Event):void
        {
            if (this._input.text.toLowerCase() == "quit")
            {
                this._ok.enable = true;
            }
            else
            {
                this._ok.enable = false;
            };
        }

        private function __keyDownHandler(_arg_1:KeyboardEvent):void
        {
            if (_arg_1.keyCode == Keyboard.ENTER)
            {
                SoundManager.instance.play("008");
                this.quit();
            }
            else
            {
                if (_arg_1.keyCode == Keyboard.ESCAPE)
                {
                    SoundManager.instance.play("008");
                    this.dispose();
                };
            };
        }

        override public function dispose():void
        {
            this.removeEvent();
            super.dispose();
            this._bg = null;
            this._quitWord = null;
            this._explain.text = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.ExitConsortiaFrame.quit");
            this._explain = null;
            this._input = null;
            this._ok = null;
            this._cancel = null;
            if (this.parent)
            {
                this.parent.removeChild(this);
            };
        }


    }
}//package consortion.view.selfConsortia

