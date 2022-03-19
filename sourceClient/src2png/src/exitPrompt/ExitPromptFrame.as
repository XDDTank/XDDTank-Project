// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//exitPrompt.ExitPromptFrame

package exitPrompt
{
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import com.pickgliss.ui.vo.AlertInfo;
    import flash.display.Bitmap;
    import com.pickgliss.ui.image.Scale9CornerImage;
    import com.pickgliss.ui.controls.ScrollPanel;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.toplevel.StageReferance;
    import flash.events.Event;
    import com.pickgliss.utils.ObjectUtils;
    import com.pickgliss.events.FrameEvent;
    import ddt.manager.SoundManager;
    import ddt.manager.DuowanInterfaceManage;
    import ddt.events.DuowanInterfaceEvent;

    public class ExitPromptFrame extends BaseAlerFrame 
    {

        private const CENTERX:int = 13;
        private const CENTERY:int = 46;

        private var _alertInfo:AlertInfo;
        private var _titleBg:Bitmap;
        private var _BG:Scale9CornerImage;
        private var _menu:ExitAllButton;
        private var _listScroll:ScrollPanel;

        public function ExitPromptFrame()
        {
            this.initialize();
        }

        protected function initialize():void
        {
            this.setView();
            this.setEvent();
        }

        private function setView():void
        {
            submitButtonStyle = "core.simplebt";
            this._alertInfo = new AlertInfo(LanguageMgr.GetTranslation("ddt.exitPrompt.prompt"), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), true, true);
            this._alertInfo.moveEnable = false;
            info = this._alertInfo;
            this.escEnable = true;
            this._BG = ComponentFactory.Instance.creatComponentByStylename("ExitPromptFrame.bg");
            addToContent(this._BG);
            this._titleBg = ComponentFactory.Instance.creatBitmap("exit.ExitPromptFrame.title");
            addToContent(this._titleBg);
            this._menu = ComponentFactory.Instance.creatComponentByStylename("ExitAllButton");
            this._menu.start();
            if (this._menu.needScorllBar)
            {
                this._listScroll = ComponentFactory.Instance.creatComponentByStylename("ExitPromptFrame.scrollPanel");
                this._listScroll.hScrollProxy = ScrollPanel.OFF;
                this._listScroll.vScrollProxy = ScrollPanel.ON;
                this._listScroll.setView(this._menu);
                addToContent(this._listScroll);
                this._listScroll.invalidateViewport();
            }
            else
            {
                this._menu.x = this.CENTERX;
                this._menu.y = this.CENTERY;
                addToContent(this._menu);
            };
        }

        public function show():void
        {
            LayerManager.Instance.addToLayer(this, LayerManager.GAME_DYNAMIC_LAYER, false, LayerManager.ALPHA_BLOCKGOUND);
            StageReferance.stage.focus = this;
        }

        public function setList(_arg_1:Array):void
        {
        }

        public function _menuChange(_arg_1:Event):void
        {
            if (this._listScroll)
            {
                this._listScroll.invalidateViewport();
            };
        }

        private function removeView():void
        {
            if (this._BG)
            {
                ObjectUtils.disposeObject(this._BG);
            };
            if (this._titleBg)
            {
                ObjectUtils.disposeObject(this._titleBg);
            };
            if (this._menu)
            {
                ObjectUtils.disposeObject(this._menu);
            };
            if (this._listScroll)
            {
                ObjectUtils.disposeObject(this._listScroll);
            };
            this._BG = null;
            this._titleBg = null;
            this._menu = null;
            this._listScroll = null;
        }

        private function setEvent():void
        {
            addEventListener(FrameEvent.RESPONSE, this.onFrameResponse);
            this._menu.addEventListener(ExitAllButton.CHANGE, this._menuChange);
        }

        private function removeEvent():void
        {
            removeEventListener(FrameEvent.RESPONSE, this.onFrameResponse);
        }

        private function onFrameResponse(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            switch (_arg_1.responseCode)
            {
                case FrameEvent.CANCEL_CLICK:
                case FrameEvent.CLOSE_CLICK:
                case FrameEvent.ESC_CLICK:
                    this.dispose();
                    dispatchEvent(new Event("close"));
                    return;
                case FrameEvent.ENTER_CLICK:
                case FrameEvent.SUBMIT_CLICK:
                    this.dispose();
                    DuowanInterfaceManage.Instance.dispatchEvent(new DuowanInterfaceEvent(DuowanInterfaceEvent.OUTLINE));
                    dispatchEvent(new Event("submit"));
                    return;
            };
        }

        override public function dispose():void
        {
            super.dispose();
            this.removeEvent();
            this.removeView();
            ObjectUtils.disposeAllChildren(this);
        }


    }
}//package exitPrompt

