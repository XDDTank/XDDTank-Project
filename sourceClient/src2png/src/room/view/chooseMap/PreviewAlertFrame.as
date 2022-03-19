// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//room.view.chooseMap.PreviewAlertFrame

package room.view.chooseMap
{
    import com.pickgliss.ui.controls.Frame;
    import com.pickgliss.ui.controls.ScrollPanel;
    import flash.display.Bitmap;
    import com.pickgliss.ui.controls.TextButton;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.LanguageMgr;
    import flash.events.MouseEvent;
    import ddt.manager.SoundManager;

    public class PreviewAlertFrame extends Frame 
    {

        private var _scrollPanel:ScrollPanel;
        private var _bg:Bitmap;
        private var _okBtn:TextButton;

        public function PreviewAlertFrame()
        {
            this.initView();
            this.initEvents();
        }

        private function initView():void
        {
            this._scrollPanel = ComponentFactory.Instance.creatComponentByStylename("room.PreviewScrollPanel");
            this._bg = ComponentFactory.Instance.creatBitmap("asset.room.fifthPreviewAsset");
            this._okBtn = ComponentFactory.Instance.creatComponentByStylename("room.PreviewBtn");
            titleText = LanguageMgr.GetTranslation("tank.room.DungeonSneak");
            addToContent(this._scrollPanel);
            this._scrollPanel.setView(this._bg);
            this._okBtn.text = LanguageMgr.GetTranslation("ok");
            addToContent(this._okBtn);
            escEnable = true;
        }

        private function initEvents():void
        {
            this._okBtn.addEventListener(MouseEvent.CLICK, this.__onClick);
        }

        private function __onClick(_arg_1:MouseEvent):void
        {
            this.dispose();
        }

        override protected function __onCloseClick(_arg_1:MouseEvent):void
        {
            super.__onCloseClick(_arg_1);
        }

        private function removeEvents():void
        {
            this._okBtn.removeEventListener(MouseEvent.CLICK, this.__onClick);
        }

        override public function dispose():void
        {
            SoundManager.instance.play("008");
            this.removeEvents();
            super.dispose();
        }


    }
}//package room.view.chooseMap

