// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//feedback.view.FeedbackReportSp

package feedback.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.controls.TextButton;
    import com.pickgliss.ui.text.TextArea;
    import com.pickgliss.ui.text.FilterFrameText;
    import flash.display.Bitmap;
    import com.pickgliss.ui.controls.TextInput;
    import ddt.manager.MessageTipManager;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.manager.SoundManager;
    import feedback.FeedbackManager;
    import flash.events.MouseEvent;
    import feedback.data.FeedbackInfo;
    import flash.events.Event;
    import flash.geom.Rectangle;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.PathManager;
    import road7th.utils.StringHelper;

    public class FeedbackReportSp extends Sprite implements Disposeable 
    {

        private var _closeBtn:TextButton;
        private var _detailTextArea:TextArea;
        private var _csTelText:FilterFrameText;
        private var _detailTextImg:FilterFrameText;
        private var _infoText:FilterFrameText;
        private var _reportTitleOrUrlAsterisk:Bitmap;
        private var _reportTitleOrUrlInput:TextInput;
        private var _reportTitleOrUrlTextImg:FilterFrameText;
        private var _reportUserNameAsterisk:Bitmap;
        private var _reportUserNameInput:TextInput;
        private var _reportUserNameTextImg:FilterFrameText;
        private var _submitBtn:TextButton;
        private var _submitFrame:FeedbackSubmitFrame;

        public function FeedbackReportSp()
        {
            this._init();
        }

        public function get check():Boolean
        {
            if (this._submitFrame.feedbackInfo.question_type < 0)
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("feedback.view.question_type"));
                return (false);
            };
            if ((!(this._submitFrame.feedbackInfo.question_title)))
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("feedback.view.question_title"));
                return (false);
            };
            if ((!(this._submitFrame.feedbackInfo.report_url)))
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("feedback.view.report_url"));
                return (false);
            };
            if ((!(this._submitFrame.feedbackInfo.report_user_name)))
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("feedback.view.report_user_name"));
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
            this._reportTitleOrUrlTextImg = null;
            this._reportTitleOrUrlInput = null;
            this._reportTitleOrUrlAsterisk = null;
            this._reportUserNameTextImg = null;
            this._reportUserNameInput = null;
            this._reportUserNameAsterisk = null;
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
            this._submitFrame.feedbackInfo.report_url = this._reportTitleOrUrlInput.text;
            this._submitFrame.feedbackInfo.report_user_name = this._reportUserNameInput.text;
        }

        public function set submitFrame(_arg_1:FeedbackSubmitFrame):void
        {
            this._submitFrame = _arg_1;
            if (this._submitFrame.feedbackInfo.question_content)
            {
                this._detailTextArea.text = this._submitFrame.feedbackInfo.question_content;
            };
            if (this._submitFrame.feedbackInfo.report_url)
            {
                this._reportTitleOrUrlInput.text = this._submitFrame.feedbackInfo.report_url;
            };
            if (this._submitFrame.feedbackInfo.report_user_name)
            {
                this._reportUserNameInput.text = this._submitFrame.feedbackInfo.report_user_name;
            };
            this.__texeInput(null);
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
                _local_2.report_url = this._submitFrame.feedbackInfo.report_url;
                _local_2.report_user_name = this._submitFrame.feedbackInfo.report_user_name;
                FeedbackManager.instance.submitFeedbackInfo(_local_2);
            };
        }

        private function __texeInput(_arg_1:Event):void
        {
            this._infoText.text = LanguageMgr.GetTranslation("feedback.view.infoText", (this._detailTextArea.maxChars - this._detailTextArea.textField.length));
        }

        private function _init():void
        {
            var _local_1:Rectangle;
            this._reportTitleOrUrlTextImg = ComponentFactory.Instance.creatComponentByStylename("ddtfeedback.descriptionText");
            this._reportTitleOrUrlTextImg.text = LanguageMgr.GetTranslation("feedback.view.Feedback.text14");
            _local_1 = ComponentFactory.Instance.creatCustomObject("feedback.reportTitleOrUrlTextImgRec");
            ObjectUtils.copyPropertyByRectangle(this._reportTitleOrUrlTextImg, _local_1);
            addChildAt(this._reportTitleOrUrlTextImg, 0);
            this._reportTitleOrUrlInput = ComponentFactory.Instance.creatComponentByStylename("feedback.textInput");
            _local_1 = ComponentFactory.Instance.creatCustomObject("feedback.reportTitleOrUrlInputRec");
            ObjectUtils.copyPropertyByRectangle(this._reportTitleOrUrlInput, _local_1);
            addChildAt(this._reportTitleOrUrlInput, 0);
            this._reportTitleOrUrlAsterisk = ComponentFactory.Instance.creatBitmap("asset.feedback.asteriskImg");
            _local_1 = ComponentFactory.Instance.creatCustomObject("feedback.reportTitleOrUrlAsteriskRec");
            ObjectUtils.copyPropertyByRectangle(this._reportTitleOrUrlAsterisk, _local_1);
            addChildAt(this._reportTitleOrUrlAsterisk, 0);
            this._reportUserNameTextImg = ComponentFactory.Instance.creatComponentByStylename("ddtfeedback.descriptionText");
            this._reportUserNameTextImg.text = LanguageMgr.GetTranslation("feedback.view.Feedback.text15");
            _local_1 = ComponentFactory.Instance.creatCustomObject("feedback.reportUserNameTextImgRec");
            ObjectUtils.copyPropertyByRectangle(this._reportUserNameTextImg, _local_1);
            addChildAt(this._reportUserNameTextImg, 0);
            this._reportUserNameInput = ComponentFactory.Instance.creatComponentByStylename("feedback.textInput");
            _local_1 = ComponentFactory.Instance.creatCustomObject("feedback.reportUserNameInputRec");
            ObjectUtils.copyPropertyByRectangle(this._reportUserNameInput, _local_1);
            addChildAt(this._reportUserNameInput, 0);
            this._reportUserNameAsterisk = ComponentFactory.Instance.creatBitmap("asset.feedback.asteriskImg");
            _local_1 = ComponentFactory.Instance.creatCustomObject("feedback.reportUserNameAsteriskRec");
            ObjectUtils.copyPropertyByRectangle(this._reportUserNameAsterisk, _local_1);
            addChildAt(this._reportUserNameAsterisk, 0);
            this._detailTextImg = ComponentFactory.Instance.creatComponentByStylename("ddtfeedback.descriptionText");
            this._detailTextImg.text = LanguageMgr.GetTranslation("feedback.view.Feedback.text6");
            _local_1 = ComponentFactory.Instance.creatCustomObject("feedback.reportDetailTextImgRec");
            ObjectUtils.copyPropertyByRectangle(this._detailTextImg, _local_1);
            addChildAt(this._detailTextImg, 0);
            this._infoText = ComponentFactory.Instance.creatComponentByStylename("feedback.infoText");
            _local_1 = ComponentFactory.Instance.creatCustomObject("feedback.reportDisappearInfoTextRec");
            ObjectUtils.copyPropertyByRectangle(this._infoText, _local_1);
            addChildAt(this._infoText, 0);
            this._csTelText = ComponentFactory.Instance.creatComponentByStylename("feedback.csTelText");
            this._csTelText.text = LanguageMgr.GetTranslation("feedback.view.csTelNumber", PathManager.solveFeedbackTelNumber());
            if ((!(StringHelper.isNullOrEmpty(PathManager.solveFeedbackTelNumber()))))
            {
                addChild(this._csTelText);
            };
            this._csTelText.y = 196;
            this._detailTextArea = ComponentFactory.Instance.creatComponentByStylename("feedback.simpleTextArea");
            _local_1 = ComponentFactory.Instance.creatCustomObject("feedback.reportDetailTextAreaRec");
            ObjectUtils.copyPropertyByRectangle(this._detailTextArea, _local_1);
            addChildAt(this._detailTextArea, 0);
            this._detailTextArea.text = "";
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

