// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//feedback.view.FeedbackConsultingSp

package feedback.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.controls.TextButton;
    import com.pickgliss.ui.text.TextArea;
    import ddt.manager.MessageTipManager;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.utils.ObjectUtils;
    import flash.events.Event;
    import ddt.manager.SoundManager;
    import feedback.FeedbackManager;
    import flash.events.MouseEvent;
    import feedback.data.FeedbackInfo;
    import flash.geom.Rectangle;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.PathManager;
    import road7th.utils.StringHelper;

    public class FeedbackConsultingSp extends Sprite implements Disposeable 
    {

        private var _csTelText:FilterFrameText;
        private var _infoText:FilterFrameText;
        private var _closeBtn:TextButton;
        private var _detailTextArea:TextArea;
        private var _detailTextImg:FilterFrameText;
        private var _submitBtn:TextButton;
        private var _submitFrame:FeedbackSubmitFrame;

        public function FeedbackConsultingSp()
        {
            this._init();
        }

        public function get check():Boolean
        {
            if (this._submitFrame.feedbackInfo.question_type <= 0)
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("feedback.view.question_type"));
                return (false);
            };
            if ((!(this._submitFrame.feedbackInfo.question_title)))
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("feedback.view.question_title"));
                return (false);
            };
            if ((!(this._submitFrame.feedbackInfo.question_content)))
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("feedback.view.question_content"));
                return (false);
            };
            if (this._submitFrame.feedbackInfo.question_content.length < 8)
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("feedback.view.question_LessThanEight"));
                return (false);
            };
            return (true);
        }

        public function dispose():void
        {
            this.remvoeEvent();
            ObjectUtils.disposeAllChildren(this);
            this._detailTextImg = null;
            this._csTelText = null;
            this._infoText = null;
            this._detailTextArea = null;
            this._submitBtn = null;
            this._closeBtn = null;
            this._submitFrame = null;
            if (this.parent)
            {
                this.parent.removeChild(this);
            };
        }

        public function setFeedbackInfo():void
        {
            this._submitFrame.feedbackInfo.question_content = this._detailTextArea.text;
        }

        public function set submitFrame(_arg_1:FeedbackSubmitFrame):void
        {
            this._submitFrame = _arg_1;
            if (this._submitFrame.feedbackInfo.question_content)
            {
                this._detailTextArea.text = this._submitFrame.feedbackInfo.question_content;
            };
            this.__texeInput(null);
        }

        private function __texeInput(_arg_1:Event):void
        {
            this._infoText.text = LanguageMgr.GetTranslation("feedback.view.infoText", (this._detailTextArea.maxChars - this._detailTextArea.textField.length));
        }

        private function __closeBtnClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            FeedbackManager.instance.closeFrame();
        }

        private function __submitBtnClick(_arg_1:MouseEvent):void
        {
            var _local_2:FeedbackInfo;
            SoundManager.instance.play("008");
            this.setFeedbackInfo();
            if (this.check)
            {
                _local_2 = new FeedbackInfo();
                _local_2.question_type = this._submitFrame.feedbackInfo.question_type;
                _local_2.question_title = this._submitFrame.feedbackInfo.question_title;
                _local_2.occurrence_date = this._submitFrame.feedbackInfo.occurrence_date;
                _local_2.question_content = this._submitFrame.feedbackInfo.question_content;
                FeedbackManager.instance.submitFeedbackInfo(_local_2);
            };
        }

        private function _init():void
        {
            var _local_1:Rectangle;
            this._detailTextImg = ComponentFactory.Instance.creatComponentByStylename("ddtfeedback.descriptionText");
            this._detailTextImg.text = LanguageMgr.GetTranslation("feedback.view.Feedback.text6");
            _local_1 = ComponentFactory.Instance.creatCustomObject("feedback.detailTextImgRec");
            ObjectUtils.copyPropertyByRectangle(this._detailTextImg, _local_1);
            addChildAt(this._detailTextImg, 0);
            this._csTelText = ComponentFactory.Instance.creatComponentByStylename("feedback.csTelText");
            this._csTelText.text = LanguageMgr.GetTranslation("feedback.view.csTelNumber", PathManager.solveFeedbackTelNumber());
            if ((!(StringHelper.isNullOrEmpty(PathManager.solveFeedbackTelNumber()))))
            {
                addChild(this._csTelText);
            };
            this._infoText = ComponentFactory.Instance.creatComponentByStylename("feedback.infoText");
            _local_1 = ComponentFactory.Instance.creatCustomObject("feedback.detailInfoTextRec");
            ObjectUtils.copyPropertyByRectangle(this._infoText, _local_1);
            addChildAt(this._infoText, 0);
            this._csTelText.y = 138;
            this._detailTextArea = ComponentFactory.Instance.creatComponentByStylename("feedback.simpleTextArea");
            _local_1 = ComponentFactory.Instance.creatCustomObject("feedback.detailSimpleTextAreaRec");
            ObjectUtils.copyPropertyByRectangle(this._detailTextArea, _local_1);
            addChildAt(this._detailTextArea, 0);
            this._infoText.text = LanguageMgr.GetTranslation("feedback.view.infoText", this._detailTextArea.maxChars);
            this._submitBtn = ComponentFactory.Instance.creatComponentByStylename("feedback.btn");
            _local_1 = ComponentFactory.Instance.creatCustomObject("feedback.submitBtnRec");
            ObjectUtils.copyPropertyByRectangle(this._submitBtn, _local_1);
            this._submitBtn.text = LanguageMgr.GetTranslation("feedback.view.FeedbackSubmitSp.submitBtnText");
            addChildAt(this._submitBtn, 0);
            this._closeBtn = ComponentFactory.Instance.creatComponentByStylename("feedback.closebtn");
            _local_1 = ComponentFactory.Instance.creatCustomObject("feedback.closeBtnRec");
            ObjectUtils.copyPropertyByRectangle(this._closeBtn, _local_1);
            this._closeBtn.text = LanguageMgr.GetTranslation("tank.invite.InviteView.close");
            addChildAt(this._closeBtn, 0);
            this.addEvent();
        }

        private function addEvent():void
        {
            this._submitBtn.addEventListener(MouseEvent.CLICK, this.__submitBtnClick);
            this._closeBtn.addEventListener(MouseEvent.CLICK, this.__closeBtnClick);
            this._detailTextArea.textField.addEventListener(Event.CHANGE, this.__texeInput);
        }

        private function remvoeEvent():void
        {
            this._submitBtn.removeEventListener(MouseEvent.CLICK, this.__submitBtnClick);
            this._closeBtn.removeEventListener(MouseEvent.CLICK, this.__closeBtnClick);
            this._detailTextArea.textField.removeEventListener(Event.CHANGE, this.__texeInput);
        }


    }
}//package feedback.view

