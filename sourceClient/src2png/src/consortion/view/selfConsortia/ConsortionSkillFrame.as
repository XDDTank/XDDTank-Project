// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//consortion.view.selfConsortia.ConsortionSkillFrame

package consortion.view.selfConsortia
{
    import com.pickgliss.ui.controls.Frame;
    import flash.display.Bitmap;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.controls.container.VBox;
    import com.pickgliss.ui.controls.ScrollPanel;
    import __AS3__.vec.Vector;
    import ddt.manager.LanguageMgr;
    import ddt.manager.PlayerManager;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.events.FrameEvent;
    import consortion.ConsortionModelControl;
    import consortion.event.ConsortionEvent;
    import ddt.events.PlayerPropertyEvent;
    import ddt.manager.SoundManager;
    import flash.events.MouseEvent;
    import consortion.ConsortionModel;
    import __AS3__.vec.*;

    public class ConsortionSkillFrame extends Frame 
    {

        public static const CONSORTION_SKILL:int = 0;
        public static const PERSONAL_SKILL_CON:int = 1;
        public static const PERSONAL_SKILL_METAL:int = 2;

        private var _titleBg:Bitmap;
        private var _richLabel:Bitmap;
        private var _riches:FilterFrameText;
        private var _vbox:VBox;
        private var _panel:ScrollPanel;
        private var _items:Vector.<ConsortionSkillItem>;
        private var _oldType:int = 0;

        public function ConsortionSkillFrame()
        {
            this.initView();
            this.initEvent();
        }

        private function initView():void
        {
            escEnable = true;
            disposeChildren = true;
            titleText = ((LanguageMgr.GetTranslation("ddt.consortion.skillFrame.title") + PlayerManager.Instance.Self.consortiaInfo.SmithLevel) + "级");
            this._titleBg = ComponentFactory.Instance.creatBitmap("asset.consortionSkillFrame.titleBg");
            this._richLabel = ComponentFactory.Instance.creatBitmap("consortion.skillFrame.richesBg");
            this._riches = ComponentFactory.Instance.creatComponentByStylename("consortion.skillFrame.riches");
            this._riches.text = String(PlayerManager.Instance.Self.RichesOffer);
            this._vbox = ComponentFactory.Instance.creatComponentByStylename("consortion.skillFrame.vbox");
            this._panel = ComponentFactory.Instance.creatComponentByStylename("consortion.skillFrame.panel");
            addToContent(this._titleBg);
            addToContent(this._richLabel);
            addToContent(this._riches);
            addToContent(this._panel);
            this._panel.setView(this._vbox);
            this.showContent();
        }

        private function initEvent():void
        {
            addEventListener(FrameEvent.RESPONSE, this.__responseHandler);
            ConsortionModelControl.Instance.addEventListener(ConsortionEvent.SKILL_STATE_CHANGE, this.__stateChange);
            PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE, this.__selfRichChangeHandler);
        }

        private function removeEvent():void
        {
            removeEventListener(FrameEvent.RESPONSE, this.__responseHandler);
            ConsortionModelControl.Instance.removeEventListener(ConsortionEvent.SKILL_STATE_CHANGE, this.__stateChange);
            PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE, this.__selfRichChangeHandler);
        }

        private function __selfRichChangeHandler(_arg_1:PlayerPropertyEvent):void
        {
            if (((_arg_1.changedProperties["RichesRob"]) || (_arg_1.changedProperties["RichesOffer"])))
            {
                this._riches.text = String(PlayerManager.Instance.Self.RichesOffer);
            };
        }

        private function __stateChange(_arg_1:ConsortionEvent):void
        {
            ConsortionModelControl.Instance.model.shinePlay = true;
            this.showContent();
        }

        private function __responseHandler(_arg_1:FrameEvent):void
        {
            if (((_arg_1.responseCode == FrameEvent.CLOSE_CLICK) || (_arg_1.responseCode == FrameEvent.ESC_CLICK)))
            {
                SoundManager.instance.play("008");
                this.dispose();
            };
        }

        private function __manageHandler(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            ConsortionModelControl.Instance.alertManagerFrame();
        }

        private function showContent():void
        {
            var _local_2:Boolean;
            var _local_3:ConsortionSkillItem;
            this.clearItem();
            this._riches.text = PlayerManager.Instance.Self.RichesOffer.toString();
            var _local_1:int;
            while (_local_1 < ConsortionModel.SKILL_MAX_LEVEL)
            {
                _local_2 = (((_local_1 + 1) > PlayerManager.Instance.Self.consortiaInfo.SmithLevel) ? false : true);
                _local_3 = new ConsortionSkillItem((_local_1 + 1), _local_2);
                _local_3.data = ConsortionModelControl.Instance.model.getskillInfoWithTypeAndLevel((_local_1 + 1));
                this._vbox.addChild(_local_3);
                this._items.push(_local_3);
                _local_1++;
            };
            this._panel.invalidateViewport();
        }

        private function clearItem():void
        {
            var _local_1:int;
            if (this._items)
            {
                _local_1 = 0;
                while (_local_1 < this._items.length)
                {
                    this._items[_local_1].dispose();
                    this._items[_local_1] = null;
                    _local_1++;
                };
            };
            this._items = new Vector.<ConsortionSkillItem>();
        }

        override public function dispose():void
        {
            this.removeEvent();
            this.clearItem();
            this._items = null;
            super.dispose();
            this._titleBg = null;
            this._richLabel = null;
            this._riches = null;
            this._vbox = null;
            this._panel = null;
            if (this.parent)
            {
                this.parent.removeChild(this);
            };
        }


    }
}//package consortion.view.selfConsortia

