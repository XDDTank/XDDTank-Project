// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//platformapi.tencent.view.ListenWeiboFrame

package platformapi.tencent.view
{
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import flash.display.Bitmap;
    import com.pickgliss.ui.image.Scale9CornerImage;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.controls.container.HBox;
    import com.pickgliss.ui.controls.SimpleBitmapButton;
    import com.pickgliss.ui.vo.AlertInfo;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.events.FrameEvent;
    import flash.events.MouseEvent;
    import ddt.utils.RequestVairableCreater;
    import flash.net.URLVariables;
    import ddt.manager.SoundManager;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.utils.ObjectUtils;

    public class ListenWeiboFrame extends BaseAlerFrame 
    {

        private var _title1:Bitmap;
        private var _title2:Bitmap;
        private var _BG1:Scale9CornerImage;
        private var _BG2:Scale9CornerImage;
        private var _BG3:Bitmap;
        private var _desc:FilterFrameText;
        private var _cells:HBox;
        private var _listenBtn:SimpleBitmapButton;
        private var _line:Bitmap;


        override protected function init():void
        {
            super.init();
            var _local_1:AlertInfo = new AlertInfo(LanguageMgr.GetTranslation("ddt.view.ListenWeiboFrame.title"));
            _local_1.bottomGap = 10;
            info = _local_1;
            this._BG1 = ComponentFactory.Instance.creatComponentByStylename("ListenWeiboFrame.core.scale9CornerImage22");
            addToContent(this._BG1);
            this._BG2 = ComponentFactory.Instance.creatComponentByStylename("ListenWeiboFrame.core.BG2");
            addToContent(this._BG2);
            this._BG3 = ComponentFactory.Instance.creatBitmap("ddt.view.ListenWeiboFrame.cellBG");
            addToContent(this._BG3);
            this._title1 = ComponentFactory.Instance.creatBitmap("ddt.view.ListenWeiboFrame.title1");
            addToContent(this._title1);
            this._title2 = ComponentFactory.Instance.creatBitmap("ddt.view.ListenWeiboFrame.title2");
            addToContent(this._title2);
            this._desc = ComponentFactory.Instance.creatComponentByStylename("ListenWeiboFrame.core.desc");
            this._desc.text = LanguageMgr.GetTranslation("ddt.view.ListenWeiboFrame.desc");
            addToContent(this._desc);
            this._listenBtn = ComponentFactory.Instance.creatComponentByStylename("ListenWeiboFrame.core.view.ListenBtn");
            addToContent(this._listenBtn);
            this._line = ComponentFactory.Instance.creatBitmap("ddt.view.ListenWeiboFrame.line");
            addToContent(this._line);
            this._cells = ComponentFactory.Instance.creatComponentByStylename("ListenWeiboFrame.core.hbox");
            addToContent(this._cells);
            this.createCell();
            addEventListener(FrameEvent.RESPONSE, this.__onFrameEvent);
            this._listenBtn.addEventListener(MouseEvent.CLICK, this.__onListenClick);
        }

        protected function __onListenClick(_arg_1:MouseEvent):void
        {
            var _local_2:URLVariables = RequestVairableCreater.creatWidthKey(true);
        }

        protected function __onFrameEvent(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            switch (_arg_1.responseCode)
            {
                case FrameEvent.SUBMIT_CLICK:
                    return;
            };
        }

        private function createCell():void
        {
        }

        private function clearCell():void
        {
        }

        public function show():void
        {
            LayerManager.Instance.addToLayer(this, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.ALPHA_BLOCKGOUND);
        }

        override public function dispose():void
        {
            removeEventListener(FrameEvent.RESPONSE, this.__onFrameEvent);
            this._listenBtn.removeEventListener(MouseEvent.CLICK, this.__onListenClick);
            this.clearCell();
            ObjectUtils.disposeObject(this._title1);
            this._title1 = null;
            ObjectUtils.disposeObject(this._title2);
            this._title2 = null;
            ObjectUtils.disposeObject(this._BG1);
            this._BG1 = null;
            ObjectUtils.disposeObject(this._BG2);
            this._BG2 = null;
            ObjectUtils.disposeObject(this._BG3);
            this._BG3 = null;
            ObjectUtils.disposeObject(this._desc);
            this._desc = null;
            ObjectUtils.disposeObject(this._cells);
            this._cells = null;
            ObjectUtils.disposeObject(this._listenBtn);
            this._listenBtn = null;
            super.dispose();
            if (this.parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package platformapi.tencent.view

