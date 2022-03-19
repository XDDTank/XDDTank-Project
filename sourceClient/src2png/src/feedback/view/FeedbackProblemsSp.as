// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//feedback.view.FeedbackProblemsSp

package feedback.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.controls.TextButton;
    import com.pickgliss.ui.text.TextArea;
    import com.pickgliss.ui.controls.SelectedCheckButton;
    import flash.display.Bitmap;
    import com.pickgliss.ui.controls.TextInput;
    import com.pickgliss.ui.controls.SelectedButtonGroup;
    import ddt.manager.MessageTipManager;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.manager.SoundManager;
    import feedback.FeedbackManager;
    import flash.events.MouseEvent;
    import feedback.data.FeedbackInfo;
    import flash.geom.Rectangle;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.PathManager;
    import road7th.utils.StringHelper;
    import flash.events.Event;

    public class FeedbackProblemsSp extends Sprite implements Disposeable 
    {

        private var _activityTitleTextImg:FilterFrameText;
        private var _closeBtn:TextButton;
        private var _detailTextArea:TextArea;
        private var _csTelText:FilterFrameText;
        private var _detailTextImg:FilterFrameText;
        private var _infoText:FilterFrameText;
        private var _noSelectedCheckButton:SelectedCheckButton;
        private var _problemsActivityTitleAsterisk:Bitmap;
        private var _problemsActivityTitleInput:TextInput;
        private var _selectedButtonGroup:SelectedButtonGroup;
        private var _submitBtn:TextButton;
        private var _submitFrame:FeedbackSubmitFrame;
        private var _whetherTheActivitiesTextImg:FilterFrameText;
        private var _yesSelectedCheckButton:SelectedCheckButton;

        public function FeedbackProblemsSp()
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
            if ((!(this._submitFrame.feedbackInfo.activity_name)))
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("feedback.view.activity_name"));
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
            this._selectedButtonGroup = null;
            this._whetherTheActivitiesTextImg = null;
            this._yesSelectedCheckButton = null;
            this._noSelectedCheckButton = null;
            this._problemsActivityTitleInput = null;
            this._problemsActivityTitleAsterisk = null;
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
            this._submitFrame.feedbackInfo.activity_is_error = ((this._selectedButtonGroup.selectIndex == 0) ? true : false);
            this._submitFrame.feedbackInfo.activity_name = this._problemsActivityTitleInput.text;
        }

        public function set submitFrame(_arg_1:FeedbackSubmitFrame):void
        {
            this._submitFrame = _arg_1;
            if (this._submitFrame.feedbackInfo.question_content)
            {
                this._detailTextArea.text = this._submitFrame.feedbackInfo.question_content;
            };
            if (this._submitFrame.feedbackInfo.activity_is_error)
            {
                this._selectedButtonGroup.selectIndex = 0;
            }
            else
            {
                this._selectedButtonGroup.selectIndex = 1;
            };
            if (this._submitFrame.feedbackInfo.activity_name)
            {
                this._problemsActivityTitleInput.text = this._submitFrame.feedbackInfo.activity_name;
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
                _local_2.activity_is_error = this._submitFrame.feedbackInfo.activity_is_error;
                _local_2.activity_name = this._submitFrame.feedbackInfo.activity_name;
                FeedbackManager.instance.submitFeedbackInfo(_local_2);
            };
        }

        private function _init():void
        {
            var _local_1:Rectangle;
            this._whetherTheActivitiesTextImg = ComponentFactory.Instance.creatComponentByStylename("ddtfeedback.typeText");
            this._whetherTheActivitiesTextImg.text = LanguageMgr.GetTranslation("feedback.view.Feedback.text7");
            _local_1 = ComponentFactory.Instance.creatCustomObject("feedback.problemsWhetherTheActivitiesTextImgRec");
            ObjectUtils.copyPropertyByRectangle(this._whetherTheActivitiesTextImg, _local_1);
            addChildAt(this._whetherTheActivitiesTextImg, 0);
            this._yesSelectedCheckButton = ComponentFactory.Instance.creatComponentByStylename("feedback.yesSelectedCheckButton");
            _local_1 = ComponentFactory.Instance.creatCustomObject("feedback.yesSelectedCheckButtonRec");
            ObjectUtils.copyPropertyByRectangle(this._yesSelectedCheckButton, _local_1);
            this._yesSelectedCheckButton.text = LanguageMgr.GetTranslation("yes");
            addChildAt(this._yesSelectedCheckButton, 0);
            this._noSelectedCheckButton = ComponentFactory.Instance.creatComponentByStylename("feedback.noSelectedCheckButton");
            _local_1 = ComponentFactory.Instance.creatCustomObject("feedback.noSelectedCheckButtonRec");
            ObjectUtils.copyPropertyByRectangle(this._noSelectedCheckButton, _local_1);
            this._noSelectedCheckButton.text = LanguageMgr.GetTranslation("no");
            addChildAt(this._noSelectedCheckButton, 0);
            this._selectedButtonGroup = new SelectedButtonGroup(false, 1);
            this._selectedButtonGroup.addSelectItem(this._yesSelectedCheckButton);
            this._selectedButtonGroup.addSelectItem(this._noSelectedCheckButton);
            this._selectedButtonGroup.selectIndex = 0;
            this._activityTitleTextImg = ComponentFactory.Instance.creatComponentByStylename("ddtfeedback.typeText");
            this._activityTitleTextImg.text = LanguageMgr.GetTranslation("feedback.view.Feedback.text8");
            _local_1 = ComponentFactory.Instance.creatCustomObject("feedback.problemsActivityTitleTextImgRec");
            ObjectUtils.copyPropertyByRectangle(this._activityTitleTextImg, _local_1);
            addChildAt(this._activityTitleTextImg, 0);
            this._problemsActivityTitleInput = ComponentFactory.Instance.creatComponentByStylename("feedback.textInput");
            this._problemsActivityTitleInput.maxChars = 9;
            _local_1 = ComponentFactory.Instance.creatCustomObject("feedback.problemsActivityTitleInputRec");
            ObjectUtils.copyPropertyByRectangle(this._problemsActivityTitleInput, _local_1);
            addChildAt(this._problemsActivityTitleInput, 0);
            this._problemsActivityTitleAsterisk = ComponentFactory.Instance.creatBitmap("asset.feedback.asteriskImg");
            _local_1 = ComponentFactory.Instance.creatCustomObject("feedback.problemsActivityTitleAsteriskRec");
            ObjectUtils.copyPropertyByRectangle(this._problemsActivityTitleAsterisk, _local_1);
            addChildAt(this._problemsActivityTitleAsterisk, 0);
            this._detailTextImg = ComponentFactory.Instance.creatComponentByStylename("ddtfeedback.descriptionText");
            this._detailTextImg.text = LanguageMgr.GetTranslation("feedback.view.Feedback.text6");
            _local_1 = ComponentFactory.Instance.creatCustomObject("feedback.problemsDetailTextImgRec");
            ObjectUtils.copyPropertyByRectangle(this._detailTextImg, _local_1);
            addChildAt(this._detailTextImg, 0);
            this._csTelText = ComponentFactory.Instance.creatComponentByStylename("feedback.csTelText");
            this._csTelText.text = LanguageMgr.GetTranslation("feedback.view.csTelNumber", PathManager.solveFeedbackTelNumber());
            if ((!(StringHelper.isNullOrEmpty(PathManager.solveFeedbackTelNumber()))))
            {
                addChild(this._csTelText);
            };
            this._infoText = ComponentFactory.Instance.creatComponentByStylename("feedback.infoText");
            _local_1 = ComponentFactory.Instance.creatCustomObject("feedback.problemsInfoTextRec");
            ObjectUtils.copyPropertyByRectangle(this._infoText, _local_1);
            this._csTelText.x = 368;
            this._csTelText.y = 168;
            addChildAt(this._infoText, 0);
            this._detailTextArea = ComponentFactory.Instance.creatComponentByStylename("feedback.simpleTextArea");
            _local_1 = ComponentFactory.Instance.creatCustomObject("feedback.problemsDetailTextAreaRec");
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
            this._yesSelectedCheckButton.addEventListener(MouseEvent.CLICK, this.__selectedCheckBtnClick);
            this._noSelectedCheckButton.addEventListener(MouseEvent.CLICK, this.__selectedCheckBtnClick);
        }

        private function __texeInput(_arg_1:Event):void
        {
            this._infoText.text = LanguageMgr.GetTranslation("feedback.view.infoText", (this._detailTextArea.maxChars - this._detailTextArea.textField.length));
        }

        private function __selectedCheckBtnClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
        }

        private function remvoeEvent():void
        {
            this._submitBtn.removeEventListener(MouseEvent.CLICK, this.__submitBtnClick);
            this._closeBtn.removeEventListener(MouseEvent.CLICK, this.__closeBtnClick);
            this._detailTextArea.textField.removeEventListener(Event.CHANGE, this.__texeInput);
            this._yesSelectedCheckButton.removeEventListener(MouseEvent.CLICK, this.__selectedCheckBtnClick);
            this._noSelectedCheckButton.removeEventListener(MouseEvent.CLICK, this.__selectedCheckBtnClick);
        }


    }
}//package feedback.view

