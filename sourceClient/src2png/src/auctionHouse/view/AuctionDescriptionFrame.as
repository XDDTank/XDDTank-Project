// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//auctionHouse.view.AuctionDescriptionFrame

package auctionHouse.view
{
    import com.pickgliss.ui.controls.Frame;
    import flash.display.Sprite;
    import com.pickgliss.ui.controls.TextButton;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.ui.image.Scale9CornerImage;
    import com.pickgliss.ui.image.MovieImage;
    import com.pickgliss.events.FrameEvent;
    import flash.events.MouseEvent;
    import ddt.manager.SoundManager;
    import com.pickgliss.utils.ObjectUtils;

    public class AuctionDescriptionFrame extends Frame 
    {

        private var _view:Sprite;
        private var _submitButton:TextButton;

        public function AuctionDescriptionFrame()
        {
            this.initView();
            this.addEvent();
        }

        private function initView():void
        {
            this._view = new Sprite();
            titleText = LanguageMgr.GetTranslation("ddt.auctionHouse.notesTitle");
            var _local_1:Scale9CornerImage = ComponentFactory.Instance.creatComponentByStylename("ddtauction.HelpFrame.FrameBg");
            this._view.addChild(_local_1);
            var _local_2:MovieImage = ComponentFactory.Instance.creatComponentByStylename("asset.ddtauctionHouse.NotesContent");
            this._view.addChild(_local_2);
            this._submitButton = ComponentFactory.Instance.creat("auctionHouse.NotesFrameEnter");
            this._submitButton.text = LanguageMgr.GetTranslation("ok");
            this._view.addChild(this._submitButton);
            addToContent(this._view);
            enterEnable = true;
            escEnable = true;
        }

        private function addEvent():void
        {
            addEventListener(FrameEvent.RESPONSE, this._response);
            this._submitButton.addEventListener(MouseEvent.CLICK, this._submit);
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
                ObjectUtils.disposeObject(this._view);
            };
            this._view = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package auctionHouse.view

