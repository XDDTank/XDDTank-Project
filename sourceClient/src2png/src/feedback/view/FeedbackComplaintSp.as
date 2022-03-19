// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//feedback.view.FeedbackComplaintSp

package feedback.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.controls.TextButton;
    import flash.display.Bitmap;
    import com.pickgliss.ui.controls.TextInput;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.text.TextArea;
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

    public class FeedbackComplaintSp extends Sprite implements Disposeable 
    {

        private var _closeBtn:TextButton;
        private var _complaintSourceAsterisk:Bitmap;
        private var _complaintSourceInput:TextInput;
        private var _complaintSourceTextImg:FilterFrameText;
        private var _complaintTitleAsterisk:Bitmap;
        private var _complaintTitleInput:TextInput;
        private var _complaintTitleTextImg:FilterFrameText;
        private var _detailTextArea:TextArea;
        private var _csTelText:FilterFrameText;
        private var _detailTextImg:FilterFrameText;
        private var _infoText:FilterFrameText;
        private var _playersMobileAsterisk:Bitmap;
        private var _playersMobileInput:TextInput;
        private var _playersMobileTextImg:FilterFrameText;
        private var _playersNameAsterisk:Bitmap;
        private var _playersNameInput:TextInput;
        private var _playersNameTextImg:FilterFrameText;
        private var _submitBtn:TextButton;
        private var _submitFrame:FeedbackSubmitFrame;

        public function FeedbackComplaintSp()
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
            if ((!(this._submitFrame.feedbackInfo.user_full_name)))
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("feedback.view.user_full_name"));
                return (false);
            };
            if ((!(this._submitFrame.feedbackInfo.user_phone)))
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("feedback.view.user_phone"));
                return (false);
            };
            if ((!(this._submitFrame.feedbackInfo.complaints_title)))
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("feedback.view.complaints_title"));
                return (false);
            };
            if ((!(this._submitFrame.feedbackInfo.complaints_source)))
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("feedback.view.complaints_source"));
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
            this._playersNameTextImg = null;
            this._playersNameInput = null;
            this._playersNameAsterisk = null;
            this._playersMobileTextImg = null;
            this._playersMobileInput = null;
            this._playersMobileAsterisk = null;
            this._complaintTitleTextImg = null;
            this._complaintTitleInput = null;
            this._complaintTitleAsterisk = null;
            this._complaintSourceTextImg = null;
            this._complaintSourceInput = null;
            this._complaintSourceAsterisk = null;
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
            this._submitFrame.feedbackInfo.user_full_name = this._playersNameInput.text;
            this._submitFrame.feedbackInfo.user_phone = this._playersMobileInput.text;
            this._submitFrame.feedbackInfo.complaints_title = this._complaintTitleInput.text;
            this._submitFrame.feedbackInfo.complaints_source = this._complaintSourceInput.text;
        }

        public function set submitFrame(_arg_1:FeedbackSubmitFrame):void
        {
            this._submitFrame = _arg_1;
            if (this._submitFrame.feedbackInfo.question_content)
            {
                this._detailTextArea.text = this._submitFrame.feedbackInfo.question_content;
            };
            if (this._submitFrame.feedbackInfo.user_full_name)
            {
                this._playersNameInput.text = this._submitFrame.feedbackInfo.user_full_name;
            };
            if (this._submitFrame.feedbackInfo.user_phone)
            {
                this._playersMobileInput.text = this._submitFrame.feedbackInfo.user_phone;
            };
            if (this._submitFrame.feedbackInfo.complaints_title)
            {
                this._complaintTitleInput.text = this._submitFrame.feedbackInfo.complaints_title;
            };
            if (this._submitFrame.feedbackInfo.complaints_source)
            {
                this._complaintSourceInput.text = this._submitFrame.feedbackInfo.complaints_source;
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
                _local_2.user_full_name = this._submitFrame.feedbackInfo.user_full_name;
                _local_2.user_phone = this._submitFrame.feedbackInfo.user_phone;
                _local_2.complaints_title = this._submitFrame.feedbackInfo.complaints_title;
                _local_2.complaints_source = this._submitFrame.feedbackInfo.complaints_source;
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
            this._playersNameTextImg = ComponentFactory.Instance.creatComponentByStylename("ddtfeedback.typeText");
            this._playersNameTextImg.text = LanguageMgr.GetTranslation("feedback.view.Feedback.text16");
            _local_1 = ComponentFactory.Instance.creatCustomObject("feedback.playersNameTextImgRec");
            ObjectUtils.copyPropertyByRectangle(this._playersNameTextImg, _local_1);
            addChildAt(this._playersNameTextImg, 0);
            this._playersNameInput = ComponentFactory.Instance.creatComponentByStylename("feedback.textInput");
            _local_1 = ComponentFactory.Instance.creatCustomObject("feedback.playersNamelInputRec");
            ObjectUtils.copyPropertyByRectangle(this._playersNameInput, _local_1);
            addChildAt(this._playersNameInput, 0);
            this._playersNameAsterisk = ComponentFactory.Instance.creatBitmap("asset.feedback.asteriskImg");
            _local_1 = ComponentFactory.Instance.creatCustomObject("feedback.playersNameAsteriskRec");
            ObjectUtils.copyPropertyByRectangle(this._playersNameAsterisk, _local_1);
            addChildAt(this._playersNameAsterisk, 0);
            this._playersMobileTextImg = ComponentFactory.Instance.creatComponentByStylename("ddtfeedback.typeText");
            this._playersMobileTextImg.text = LanguageMgr.GetTranslation("feedback.view.Feedback.text17");
            _local_1 = ComponentFactory.Instance.creatCustomObject("feedback.playersMobileTextImgRec");
            ObjectUtils.copyPropertyByRectangle(this._playersMobileTextImg, _local_1);
            addChildAt(this._playersMobileTextImg, 0);
            this._playersMobileInput = ComponentFactory.Instance.creatComponentByStylename("feedback.textInputMobile");
            _local_1 = ComponentFactory.Instance.creatCustomObject("feedback.playersMobileInputRec");
            ObjectUtils.copyPropertyByRectangle(this._playersMobileInput, _local_1);
            this._playersMobileInput.textField.restrict = "0-9";
            addChildAt(this._playersMobileInput, 0);
            this._playersMobileAsterisk = ComponentFactory.Instance.creatBitmap("asset.feedback.asteriskImg");
            _local_1 = ComponentFactory.Instance.creatCustomObject("feedback.playersMobileAsteriskRec");
            ObjectUtils.copyPropertyByRectangle(this._playersMobileAsterisk, _local_1);
            addChildAt(this._playersMobileAsterisk, 0);
            this._complaintTitleTextImg = ComponentFactory.Instance.creatComponentByStylename("ddtfeedback.typeText");
            this._complaintTitleTextImg.text = LanguageMgr.GetTranslation("feedback.view.Feedback.text18");
            _local_1 = ComponentFactory.Instance.creatCustomObject("feedback.complaintTitleTextImgRec");
            ObjectUtils.copyPropertyByRectangle(this._complaintTitleTextImg, _local_1);
            addChildAt(this._complaintTitleTextImg, 0);
            this._complaintTitleInput = ComponentFactory.Instance.creatComponentByStylename("feedback.textInput");
            _local_1 = ComponentFactory.Instance.creatCustomObject("feedback.complaintTitleInputRec");
            ObjectUtils.copyPropertyByRectangle(this._complaintTitleInput, _local_1);
            addChildAt(this._complaintTitleInput, 0);
            this._complaintTitleAsterisk = ComponentFactory.Instance.creatBitmap("asset.feedback.asteriskImg");
            _local_1 = ComponentFactory.Instance.creatCustomObject("feedback.complaintTitleAsteriskRec");
            ObjectUtils.copyPropertyByRectangle(this._complaintTitleAsterisk, _local_1);
            addChildAt(this._complaintTitleAsterisk, 0);
            this._complaintSourceTextImg = ComponentFactory.Instance.creatComponentByStylename("ddtfeedback.typeText");
            this._complaintSourceTextImg.text = LanguageMgr.GetTranslation("feedback.view.Feedback.text20");
            _local_1 = ComponentFactory.Instance.creatCustomObject("feedback.complaintSourceTextImgRec");
            ObjectUtils.copyPropertyByRectangle(this._complaintSourceTextImg, _local_1);
            addChildAt(this._complaintSourceTextImg, 0);
            this._complaintSourceInput = ComponentFactory.Instance.creatComponentByStylename("feedback.textInput");
            _local_1 = ComponentFactory.Instance.creatCustomObject("feedback.complaintSourceInputRec");
            ObjectUtils.copyPropertyByRectangle(this._complaintSourceInput, _local_1);
            addChildAt(this._complaintSourceInput, 0);
            this._complaintSourceAsterisk = ComponentFactory.Instance.creatBitmap("asset.feedback.asteriskImg");
            _local_1 = ComponentFactory.Instance.creatCustomObject("feedback.complaintSourceAsteriskRec");
            ObjectUtils.copyPropertyByRectangle(this._complaintSourceAsterisk, _local_1);
            addChildAt(this._complaintSourceAsterisk, 0);
            this._detailTextImg = ComponentFactory.Instance.creatComponentByStylename("ddtfeedback.descriptionText");
            this._detailTextImg.text = LanguageMgr.GetTranslation("feedback.view.Feedback.text6");
            _local_1 = ComponentFactory.Instance.creatCustomObject("feedback.complaintDetailTextImgRec");
            ObjectUtils.copyPropertyByRectangle(this._detailTextImg, _local_1);
            addChildAt(this._detailTextImg, 0);
            this._csTelText = ComponentFactory.Instance.creatComponentByStylename("feedback.csTelText");
            this._csTelText.text = LanguageMgr.GetTranslation("feedback.view.csTelNumber", PathManager.solveFeedbackTelNumber());
            if ((!(StringHelper.isNullOrEmpty(PathManager.solveFeedbackTelNumber()))))
            {
                addChild(this._csTelText);
            };
            this._infoText = ComponentFactory.Instance.creatComponentByStylename("feedback.infoText");
            _local_1 = ComponentFactory.Instance.creatCustomObject("feedback.complaintDisappearInfoTextRec");
            ObjectUtils.copyPropertyByRectangle(this._infoText, _local_1);
            this._csTelText.y = 214;
            addChildAt(this._infoText, 0);
            this._detailTextArea = ComponentFactory.Instance.creatComponentByStylename("feedback.simpleTextArea");
            _local_1 = ComponentFactory.Instance.creatCustomObject("feedback.complaintDetailTextAreaRec");
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

