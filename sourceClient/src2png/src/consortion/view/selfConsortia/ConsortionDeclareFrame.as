// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//consortion.view.selfConsortia.ConsortionDeclareFrame

package consortion.view.selfConsortia
{
    import com.pickgliss.ui.controls.Frame;
    import com.pickgliss.ui.image.Scale9CornerImage;
    import com.pickgliss.ui.text.TextArea;
    import com.pickgliss.ui.controls.TextButton;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.PlayerManager;
    import com.pickgliss.events.FrameEvent;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import ddt.manager.SoundManager;
    import flash.utils.ByteArray;
    import road7th.utils.StringHelper;
    import ddt.manager.MessageTipManager;
    import ddt.utils.FilterWordManager;
    import ddt.manager.SocketManager;

    public class ConsortionDeclareFrame extends Frame 
    {

        private var _bg:Scale9CornerImage;
        private var _input:TextArea;
        private var _ok:TextButton;
        private var _cancel:TextButton;

        public function ConsortionDeclareFrame()
        {
            this.initView();
            this.initEvent();
        }

        private function initView():void
        {
            escEnable = true;
            disposeChildren = true;
            titleText = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaDeclarationFrame.titleText");
            this._bg = ComponentFactory.Instance.creatComponentByStylename("consortion.ConsortionDeclareFrameBG");
            this._input = ComponentFactory.Instance.creatComponentByStylename("consortion.declareFrame.input");
            this._ok = ComponentFactory.Instance.creatComponentByStylename("consortion.declareFrame.ok");
            this._cancel = ComponentFactory.Instance.creatComponentByStylename("consortion.declareFrame.cancel");
            addToContent(this._bg);
            addToContent(this._input);
            addToContent(this._ok);
            addToContent(this._cancel);
            this._ok.text = LanguageMgr.GetTranslation("ok");
            this._cancel.text = LanguageMgr.GetTranslation("cancel");
            this._ok.enable = false;
            this._input.text = PlayerManager.Instance.Self.consortiaInfo.Description;
        }

        private function initEvent():void
        {
            addEventListener(FrameEvent.RESPONSE, this.__responseHandler);
            addEventListener(Event.ADDED_TO_STAGE, this.__addToStageHandler);
            this._ok.addEventListener(MouseEvent.CLICK, this.__okHandler);
            this._cancel.addEventListener(MouseEvent.CLICK, this.__cancelHandler);
            this._input.addEventListener(Event.CHANGE, this.__inputChangeHandler);
        }

        private function removeEvent():void
        {
            removeEventListener(FrameEvent.RESPONSE, this.__responseHandler);
            removeEventListener(Event.ADDED_TO_STAGE, this.__addToStageHandler);
            this._ok.removeEventListener(MouseEvent.CLICK, this.__okHandler);
            this._cancel.removeEventListener(MouseEvent.CLICK, this.__cancelHandler);
            this._input.removeEventListener(Event.CHANGE, this.__inputChangeHandler);
        }

        private function __addToStageHandler(_arg_1:Event):void
        {
            this._input.textField.setFocus();
            this._input.textField.setSelection(this._input.text.length, this._input.text.length);
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
                this.sendDeclar();
            };
        }

        private function __okHandler(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            this.sendDeclar();
        }

        private function sendDeclar():void
        {
            var _local_1:ByteArray = new ByteArray();
            _local_1.writeUTF(StringHelper.trim(this._input.text));
            if (_local_1.length > 300)
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaDeclarationFrame.long"));
                return;
            };
            if (FilterWordManager.isGotForbiddenWords(this._input.text))
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaAfficheFrame"));
                return;
            };
            var _local_2:String = FilterWordManager.filterWrod(this._input.text);
            _local_2.replace("\r", "");
            _local_2.replace("\n", "");
            _local_2 = StringHelper.trim(_local_2);
            SocketManager.Instance.out.sendConsortiaUpdateDescription(_local_2);
            this.dispose();
        }

        private function __cancelHandler(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            this.dispose();
        }

        private function __inputChangeHandler(_arg_1:Event):void
        {
            StringHelper.checkTextFieldLength(this._input.textField, 300);
            if (this._input.text != PlayerManager.Instance.Self.consortiaInfo.Description)
            {
                this._ok.enable = true;
            }
            else
            {
                this._ok.enable = false;
            };
        }

        override public function dispose():void
        {
            this.removeEvent();
            super.dispose();
            this._bg.dispose();
            this._bg = null;
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

