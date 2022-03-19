// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hall.AddFavoriteFrame

package hall
{
    import com.pickgliss.ui.controls.Frame;
    import com.pickgliss.ui.controls.TextButton;
    import flash.display.Bitmap;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.events.FrameEvent;
    import flash.events.MouseEvent;
    import ddt.manager.SoundManager;
    import ddt.manager.SharedManager;
    import ddt.manager.PageInterfaceManager;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.utils.ObjectUtils;

    public class AddFavoriteFrame extends Frame 
    {

        private var _okBtn:TextButton;
        private var _txtBmp:Bitmap;
        private var _catoonBmp:Bitmap;

        public function AddFavoriteFrame()
        {
            this.initView();
            this.initEvents();
        }

        private function initView():void
        {
            this._okBtn = ComponentFactory.Instance.creatComponentByStylename("saveFile.okBtn");
            this._okBtn.text = LanguageMgr.GetTranslation("consortion.takeIn.agreeBtn.text");
            this._okBtn.x = 185;
            this._okBtn.y = 165;
            addToContent(this._okBtn);
            this._txtBmp = ComponentFactory.Instance.creatBitmap("asset.addfavorite.txtbmp");
            this._catoonBmp = ComponentFactory.Instance.creatBitmap("asset.addfavorite.catoonbmp");
            addToContent(this._txtBmp);
            addToContent(this._catoonBmp);
        }

        private function initEvents():void
        {
            addEventListener(FrameEvent.RESPONSE, this._response);
            this._okBtn.addEventListener(MouseEvent.CLICK, this._okClick);
        }

        private function removeEvents():void
        {
            removeEventListener(FrameEvent.RESPONSE, this._response);
            this._okBtn.removeEventListener(MouseEvent.CLICK, this._okClick);
        }

        private function _response(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            if (((_arg_1.responseCode == FrameEvent.CLOSE_CLICK) || (_arg_1.responseCode == FrameEvent.ESC_CLICK)))
            {
                SharedManager.Instance.isAddedToFavorite = true;
                SharedManager.Instance.save();
                this.dispose();
            };
        }

        private function _okClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            this.dispose();
            SharedManager.Instance.isAddedToFavorite = true;
            SharedManager.Instance.save();
            PageInterfaceManager.askForFavorite();
        }

        public function show():void
        {
            LayerManager.Instance.addToLayer(this, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
        }

        override public function dispose():void
        {
            this.removeEvents();
            if (this._okBtn)
            {
                ObjectUtils.disposeObject(this._okBtn);
            };
            this._okBtn = null;
            if (this._txtBmp)
            {
                ObjectUtils.disposeObject(this._txtBmp);
                this._txtBmp = null;
            };
            if (this._catoonBmp)
            {
                ObjectUtils.disposeObject(this._catoonBmp);
                this._catoonBmp = null;
            };
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package hall

