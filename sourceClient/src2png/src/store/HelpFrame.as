// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//store.HelpFrame

package store
{
    import com.pickgliss.ui.controls.Frame;
    import flash.display.Sprite;
    import com.pickgliss.ui.controls.TextButton;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.events.FrameEvent;
    import flash.events.MouseEvent;
    import flash.display.DisplayObject;
    import ddt.manager.SoundManager;
    import com.pickgliss.utils.ObjectUtils;

    public class HelpFrame extends Frame 
    {

        private var _view:Sprite;
        private var _submitButton:TextButton;

        public function HelpFrame()
        {
            this.initView();
            this.addEvent();
        }

        private function initView():void
        {
            this._view = new Sprite();
            this._submitButton = ComponentFactory.Instance.creat("ddtstore.HelpFrame.EnterBtn");
            this._submitButton.text = LanguageMgr.GetTranslation("ok");
            this._view.addChild(this._submitButton);
            addToContent(this._view);
            escEnable = true;
            enterEnable = true;
        }

        private function addEvent():void
        {
            addEventListener(FrameEvent.RESPONSE, this._response);
            this._submitButton.addEventListener(MouseEvent.CLICK, this._submit);
        }

        public function setView(_arg_1:DisplayObject):void
        {
            this._view.addChild(_arg_1);
        }

        private function _submit(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            this.close();
        }

        private function _response(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            if ((((_arg_1.responseCode == FrameEvent.CLOSE_CLICK) || (_arg_1.responseCode == FrameEvent.ESC_CLICK)) || (_arg_1.responseCode == FrameEvent.ENTER_CLICK)))
            {
                this.close();
            };
        }

        private function close():void
        {
            removeEventListener(FrameEvent.RESPONSE, this._response);
            this._submitButton.removeEventListener(MouseEvent.CLICK, this._submit);
            ObjectUtils.disposeObject(this._view);
            ObjectUtils.disposeObject(this);
        }

        override public function dispose():void
        {
            super.dispose();
            removeEventListener(FrameEvent.RESPONSE, this._response);
            if (this._submitButton)
            {
                this._submitButton.removeEventListener(MouseEvent.CLICK, this._submit);
                ObjectUtils.disposeObject(this._submitButton);
            };
            this._submitButton = null;
            if (this._view)
            {
                ObjectUtils.disposeAllChildren(this._view);
            };
            this._view = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package store

