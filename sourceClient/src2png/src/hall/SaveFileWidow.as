// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hall.SaveFileWidow

package hall
{
    import com.pickgliss.ui.controls.Frame;
    import com.pickgliss.ui.controls.TextButton;
    import flash.display.Bitmap;
    import com.pickgliss.ui.image.Image;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.events.FrameEvent;
    import flash.events.MouseEvent;
    import ddt.manager.SoundManager;
    import com.pickgliss.loader.LoaderSavingManager;
    import ddt.manager.PathManager;
    import ddt.manager.StatisticManager;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.utils.ObjectUtils;

    public class SaveFileWidow extends Frame 
    {

        private var _okBtn:TextButton;
        private var _novice:Bitmap;
        private var _npc:Image;

        public function SaveFileWidow()
        {
            this.initView();
            this.initEvents();
        }

        private function initView():void
        {
            titleText = LanguageMgr.GetTranslation("tips");
            this._novice = ComponentFactory.Instance.creatBitmap("asset.hallSaveFile.noviceBG");
            this._npc = ComponentFactory.Instance.creatComponentByStylename("hall.womenNPC");
            this._okBtn = ComponentFactory.Instance.creatComponentByStylename("saveFile.okBtn");
            this._okBtn.text = LanguageMgr.GetTranslation("consortion.takeIn.agreeBtn.text");
            addToContent(this._novice);
            addToContent(this._npc);
            addToContent(this._okBtn);
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
                this.dispose();
                this.sendStatInfo("no");
            };
        }

        private function _okClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            this.dispose();
            LoaderSavingManager.cacheAble = true;
            LoaderSavingManager.saveFilesToLocal();
            this.sendStatInfo("yes");
        }

        private function sendStatInfo(_arg_1:String):void
        {
            if (PathManager.solveParterId() == null)
            {
                return;
            };
            StatisticManager.Instance().startAction(StatisticManager.SAVEFILE, _arg_1);
        }

        public function show():void
        {
            LayerManager.Instance.addToLayer(this, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
        }

        override public function dispose():void
        {
            this.removeEvents();
            super.dispose();
            if (this._novice)
            {
                ObjectUtils.disposeObject(this._novice);
            };
            this._novice = null;
            if (this._npc)
            {
                ObjectUtils.disposeObject(this._npc);
            };
            this._npc = null;
            if (this._okBtn)
            {
                ObjectUtils.disposeObject(this._okBtn);
            };
            this._okBtn = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package hall

