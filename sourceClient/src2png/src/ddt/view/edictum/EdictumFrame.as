// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.edictum.EdictumFrame

package ddt.view.edictum
{
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import com.pickgliss.ui.controls.ScrollPanel;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.vo.AlertInfo;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.ui.image.Scale9CornerImage;
    import flash.display.Bitmap;
    import com.pickgliss.events.FrameEvent;
    import ddt.manager.SoundManager;
    import com.pickgliss.utils.ObjectUtils;
    import com.pickgliss.ui.LayerManager;

    public class EdictumFrame extends BaseAlerFrame 
    {

        private var _panel:ScrollPanel;
        private var _titleTxt:FilterFrameText;
        private var _contenTxt:FilterFrameText;

        public function EdictumFrame()
        {
            this.initView();
            this.initEvents();
        }

        private function initView():void
        {
            var _local_1:AlertInfo = new AlertInfo();
            _local_1.submitLabel = LanguageMgr.GetTranslation("ok");
            _local_1.showCancel = false;
            info = _local_1;
            var _local_2:Scale9CornerImage = ComponentFactory.Instance.creatComponentByStylename("edictum.edictumBGI");
            var _local_3:Bitmap = ComponentFactory.Instance.creatBitmap("asset.coreIcon.EdictumTitle");
            this._titleTxt = ComponentFactory.Instance.creatComponentByStylename("edictum.edictumTitle");
            this._contenTxt = ComponentFactory.Instance.creatComponentByStylename("edictum.edictumContent");
            this._panel = ComponentFactory.Instance.creatComponentByStylename("edictum.edictumPanel");
            this._panel.setView(this._contenTxt);
            this._panel.invalidateViewport();
            addToContent(_local_2);
            addToContent(_local_3);
            addToContent(this._titleTxt);
            addToContent(this._panel);
        }

        private function initEvents():void
        {
            addEventListener(FrameEvent.RESPONSE, this.__response);
        }

        private function removeEvents():void
        {
            addEventListener(FrameEvent.RESPONSE, this.__response);
        }

        private function __response(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            ObjectUtils.disposeObject(this);
        }

        public function set data(_arg_1:Object):void
        {
            this._titleTxt.text = _arg_1["Title"];
            this._contenTxt.htmlText = _arg_1["Text"];
            this._panel.invalidateViewport();
        }

        public function show():void
        {
            LayerManager.Instance.addToLayer(this, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.ALPHA_BLOCKGOUND);
        }

        override public function dispose():void
        {
            this.removeEvents();
            if (this._panel)
            {
                ObjectUtils.disposeObject(this._panel);
            };
            this._panel = null;
            if (this._titleTxt)
            {
                ObjectUtils.disposeObject(this._titleTxt);
            };
            this._titleTxt = null;
            if (this._contenTxt)
            {
                ObjectUtils.disposeObject(this._contenTxt);
            };
            this._contenTxt = null;
            super.dispose();
            ObjectUtils.disposeAllChildren(this);
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package ddt.view.edictum

