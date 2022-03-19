// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.chat.ChatBugleInputFrame

package ddt.view.chat
{
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import com.pickgliss.ui.image.ScaleBitmapImage;
    import com.pickgliss.ui.image.Scale9CornerImage;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.vo.AlertInfo;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.ComponentFactory;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import com.pickgliss.events.FrameEvent;
    import flash.utils.setTimeout;
    import ddt.manager.SoundManager;
    import road7th.utils.StringHelper;
    import ddt.manager.MessageTipManager;
    import ddt.utils.FilterWordManager;
    import ddt.manager.SocketManager;
    import com.pickgliss.utils.ObjectUtils;

    public class ChatBugleInputFrame extends BaseAlerFrame 
    {

        private var _bg:ScaleBitmapImage;
        private var _textBg:Scale9CornerImage;
        private var _textTitle:FilterFrameText;
        private var _remainTxt:FilterFrameText;
        private var _inputTxt:FilterFrameText;
        private var _remainStr:String;
        public var templateID:int;


        override protected function init():void
        {
            super.init();
            var _local_1:AlertInfo = new AlertInfo(LanguageMgr.GetTranslation("chat.BugleInputFrameTitleString"));
            _local_1.moveEnable = false;
            _local_1.submitLabel = LanguageMgr.GetTranslation("chat.BugleInputFrame.ok.text");
            _local_1.customPos = ComponentFactory.Instance.creatCustomObject("chat.BugleInputFrame.ok.textPos");
            info = _local_1;
            this._bg = ComponentFactory.Instance.creatComponentByStylename("chat.BugleInputFrameBg");
            this._textBg = ComponentFactory.Instance.creatComponentByStylename("chat.BugleInputFrameTextBg");
            this._textTitle = ComponentFactory.Instance.creatComponentByStylename("chat.BugleInputTitleBitmap.text");
            this._textTitle.text = LanguageMgr.GetTranslation("chat.BugleInputFrameBg.text");
            this._remainTxt = ComponentFactory.Instance.creatComponentByStylename("chat.BugleInputFrameRemainText");
            this._inputTxt = ComponentFactory.Instance.creatComponentByStylename("chat.BugleInputFrameInputText");
            this._remainStr = LanguageMgr.GetTranslation("chat.BugleInputFrameRemainString");
            this._remainTxt.text = (this._remainStr + this._inputTxt.maxChars.toString());
            addToContent(this._bg);
            addToContent(this._textBg);
            addToContent(this._textTitle);
            addToContent(this._remainTxt);
            addToContent(this._inputTxt);
            addEventListener(Event.ADDED_TO_STAGE, this.__setFocus);
        }

        private function initEvents():void
        {
            _submitButton.addEventListener(MouseEvent.CLICK, __onSubmitClick);
            this._inputTxt.addEventListener(Event.CHANGE, this.__upDateRemainTxt);
            addEventListener(FrameEvent.RESPONSE, this.__onResponse);
        }

        private function __setFocus(_arg_1:Event):void
        {
            setTimeout(this._inputTxt.setFocus, 100);
            this.initEvents();
        }

        private function __onResponse(_arg_1:FrameEvent):void
        {
            var _local_2:String;
            var _local_3:RegExp;
            switch (_arg_1.responseCode)
            {
                case FrameEvent.SUBMIT_CLICK:
                    SoundManager.instance.play("008");
                    if (StringHelper.trim(this._inputTxt.text).length <= 0)
                    {
                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("chat.BugleInputNull"));
                        return;
                    };
                    _local_2 = FilterWordManager.filterWrod(this._inputTxt.text);
                    _local_3 = new RegExp("\\r", "gm");
                    _local_2 = _local_2.replace(_local_3, "");
                    SocketManager.Instance.out.sendBBugle(_local_2, this.templateID);
                    this._inputTxt.text = "";
                    this._remainTxt.text = (this._remainStr + this._inputTxt.maxChars.toString());
                    if (parent)
                    {
                        parent.removeChild(this);
                    };
                    return;
                case FrameEvent.ESC_CLICK:
                case FrameEvent.CLOSE_CLICK:
                    SoundManager.instance.play("008");
                    this._inputTxt.text = "";
                    this._remainTxt.text = (this._remainStr + this._inputTxt.maxChars.toString());
                    if (parent)
                    {
                        parent.removeChild(this);
                    };
                    return;
            };
        }

        private function __upDateRemainTxt(_arg_1:Event):void
        {
            this._remainTxt.text = (this._remainStr + String((this._inputTxt.maxChars - this._inputTxt.text.length)));
        }

        override public function dispose():void
        {
            removeEventListener(Event.ADDED_TO_STAGE, this.__setFocus);
            _submitButton.removeEventListener(MouseEvent.CLICK, __onSubmitClick);
            this._inputTxt.removeEventListener(Event.CHANGE, this.__upDateRemainTxt);
            removeEventListener(FrameEvent.RESPONSE, this.__onResponse);
            if (this._bg)
            {
                ObjectUtils.disposeObject(this._bg);
            };
            this._bg = null;
            if (this._textBg)
            {
                ObjectUtils.disposeObject(this._textBg);
            };
            this._textBg = null;
            if (this._textTitle)
            {
                ObjectUtils.disposeObject(this._textTitle);
            };
            this._textTitle = null;
            if (this._remainTxt)
            {
                ObjectUtils.disposeObject(this._remainTxt);
            };
            this._remainTxt = null;
            if (this._inputTxt)
            {
                ObjectUtils.disposeObject(this._inputTxt);
            };
            this._inputTxt = null;
            super.dispose();
        }


    }
}//package ddt.view.chat

