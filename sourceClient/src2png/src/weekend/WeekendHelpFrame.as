// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//weekend.WeekendHelpFrame

package weekend
{
    import com.pickgliss.ui.controls.Frame;
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import com.pickgliss.ui.controls.TextButton;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.utils.PositionUtils;
    import com.pickgliss.events.FrameEvent;
    import flash.events.MouseEvent;
    import ddt.manager.SoundManager;
    import com.pickgliss.ui.LayerManager;

    public class WeekendHelpFrame extends Frame 
    {

        private var _bg:DisplayObject;
        private var _view:Sprite;
        private var _submitButton:TextButton;

        public function WeekendHelpFrame()
        {
            this.initEvent();
            titleText = LanguageMgr.GetTranslation("petsbag.frame.helpFrame.title");
        }

        override protected function init():void
        {
            super.init();
            this._bg = ComponentFactory.Instance.creat("weekendframe.HelpFrame.FrameBg");
            addToContent(this._bg);
            this._view = new Sprite();
            addToContent(this._view);
            this._submitButton = ComponentFactory.Instance.creat("ddtstore.HelpFrame.EnterBtn");
            this._submitButton.text = LanguageMgr.GetTranslation("ok");
            addToContent(this._submitButton);
            escEnable = true;
            enterEnable = true;
        }

        public function setView(_arg_1:DisplayObject, _arg_2:*=null):void
        {
            ObjectUtils.disposeAllChildren(this._view);
            if (_arg_2)
            {
                PositionUtils.setPos(_arg_1, _arg_2);
            };
            this._view.addChild(_arg_1);
        }

        private function initEvent():void
        {
            addEventListener(FrameEvent.RESPONSE, this.___response);
            this._submitButton.addEventListener(MouseEvent.CLICK, this._submit);
        }

        private function removeEvent():void
        {
            removeEventListener(FrameEvent.RESPONSE, this.___response);
            this._submitButton.removeEventListener(MouseEvent.CLICK, this._submit);
        }

        protected function _submit(_arg_1:MouseEvent):void
        {
            onResponse(FrameEvent.SUBMIT_CLICK);
        }

        protected function ___response(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            this.dispose();
        }

        public function show():void
        {
            LayerManager.Instance.addToLayer(this, LayerManager.GAME_TOP_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
        }

        override public function dispose():void
        {
            this.removeEvent();
            ObjectUtils.disposeObject(this._bg);
            this._bg = null;
            ObjectUtils.disposeAllChildren(this._view);
            ObjectUtils.disposeObject(this._view);
            this._view = null;
            ObjectUtils.disposeObject(this._submitButton);
            this._submitButton = null;
            super.dispose();
        }


    }
}//package weekend

