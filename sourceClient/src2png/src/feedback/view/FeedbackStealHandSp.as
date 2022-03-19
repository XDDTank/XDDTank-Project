// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//feedback.view.FeedbackStealHandSp

package feedback.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import flash.display.Bitmap;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.controls.TextInput;
    import com.pickgliss.ui.controls.TextButton;
    import com.pickgliss.ui.text.TextArea;
    import flash.geom.Point;
    import ddt.manager.MessageTipManager;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.manager.SoundManager;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import feedback.FeedbackManager;
    import feedback.data.FeedbackInfo;
    import flash.geom.Rectangle;
    import com.pickgliss.ui.ComponentFactory;
    import flash.text.TextFieldType;
    import ddt.manager.PathManager;
    import road7th.utils.StringHelper;
    import ddt.utils.PositionUtils;

    public class FeedbackStealHandSp extends Sprite implements Disposeable 
    {

        private var _acquirementAsterisk:Bitmap;
        private var _acquirementTextImg:FilterFrameText;
        private var _acquirementTextInput:TextInput;
        private var _backBtn:TextButton;
        private var _closeBtn:TextButton;
        private var _detailTextArea:TextArea;
        private var _csTelPos:Point;
        private var _csTelText:FilterFrameText;
        private var _detailTextImg:FilterFrameText;
        private var _infoText:FilterFrameText;
        private var _explainTextArea:TextArea;
        private var _getTimeAsterisk:Bitmap;
        private var _infoDateText:FilterFrameText;
        private var _getTimeTextImg:FilterFrameText;
        private var _getTimeTextInput:TextInput;
        private var _nextBtn:TextButton;
        private var _submitBtn:TextButton;
        private var _submitFrame:FeedbackSubmitFrame;

        public function FeedbackStealHandSp()
        {
            this._init();
        }

        public function get check():Boolean
        {
            if ((!(this._submitFrame.feedbackInfo.goods_get_method)))
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("feedback.view.goods_get_method"));
                return (false);
            };
            if ((!(this._submitFrame.feedbackInfo.goods_get_date)))
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("feedback.view.goods_get_date"));
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
            this._explainTextArea = null;
            this._acquirementTextImg = null;
            this._acquirementTextInput = null;
            this._acquirementAsterisk = null;
            this._getTimeTextImg = null;
            this._getTimeTextInput = null;
            this._getTimeAsterisk = null;
            this._infoDateText = null;
            this._detailTextImg = null;
            this._csTelText = null;
            this._infoText = null;
            this._detailTextArea = null;
            this._nextBtn = null;
            this._closeBtn = null;
            this._backBtn = null;
            this._submitBtn = null;
            this._submitFrame = null;
            if (this.parent)
            {
                this.parent.removeChild(this);
            };
        }

        public function setFeedbackInfo():void
        {
            this._submitFrame.feedbackInfo.question_content = this._detailTextArea.text;
            this._submitFrame.feedbackInfo.goods_get_method = this._acquirementTextInput.text;
            this._submitFrame.feedbackInfo.goods_get_date = this._getTimeTextInput.text;
        }

        public function set submitFrame(_arg_1:FeedbackSubmitFrame):void
        {
            this._submitFrame = _arg_1;
            if (this._submitFrame.feedbackInfo.question_content)
            {
                this._detailTextArea.text = this._submitFrame.feedbackInfo.question_content;
            };
            if (this._submitFrame.feedbackInfo.goods_get_method)
            {
                this._acquirementTextInput.text = this._submitFrame.feedbackInfo.goods_get_method;
            };
            if (this._submitFrame.feedbackInfo.goods_get_date)
            {
                this._getTimeTextInput.text = this._submitFrame.feedbackInfo.goods_get_date;
            };
            this.__texeInput(null);
        }

        private function __backBtnClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            this._submitFrame.problemCombox.mouseEnabled = true;
            this._submitFrame.problemCombox.mouseChildren = true;
            this._submitFrame.problemTitleInput.mouseEnabled = true;
            this._submitFrame.problemTitleInput.mouseChildren = true;
            this._explainTextArea.visible = true;
            this._nextBtn.visible = true;
            this._closeBtn.visible = true;
            this._backBtn.visible = false;
            this._submitBtn.visible = false;
            this._detailTextImg.visible = false;
            this._detailTextArea.visible = false;
            this._csTelText.y = 85;
            this._infoText.visible = false;
            this._acquirementTextImg.visible = false;
            this._acquirementTextInput.visible = false;
            this._acquirementAsterisk.visible = false;
            this._getTimeTextImg.visible = false;
            this._getTimeTextInput.visible = false;
            this._getTimeAsterisk.visible = false;
            this._infoDateText.visible = false;
            this._csTelText.visible = true;
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

        private function __nextBtnClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            if (this._submitFrame.feedbackInfo.question_type < 0)
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("feedback.view.question_type"));
                return;
            };
            if ((!(this._submitFrame.feedbackInfo.question_title)))
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("feedback.view.question_title"));
                return;
            };
            this._submitFrame.problemCombox.mouseEnabled = false;
            this._submitFrame.problemCombox.mouseChildren = false;
            this._submitFrame.problemTitleInput.mouseEnabled = false;
            this._submitFrame.problemTitleInput.mouseChildren = false;
            this._explainTextArea.visible = false;
            this._nextBtn.visible = false;
            this._closeBtn.visible = false;
            this._infoText.visible = true;
            this._backBtn.visible = true;
            this._submitBtn.visible = true;
            this._detailTextImg.visible = true;
            this._detailTextArea.visible = true;
            this._csTelText.y = 164;
            this._acquirementTextImg.visible = true;
            this._acquirementTextInput.visible = true;
            this._acquirementAsterisk.visible = true;
            this._getTimeTextImg.visible = true;
            this._getTimeTextInput.visible = true;
            this._getTimeAsterisk.visible = true;
            this._infoDateText.visible = true;
            this._csTelText.visible = true;
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
                _local_2.goods_get_method = this._submitFrame.feedbackInfo.goods_get_method;
                _local_2.goods_get_date = this._submitFrame.feedbackInfo.goods_get_date;
                FeedbackManager.instance.submitFeedbackInfo(_local_2);
            };
        }

        private function _init():void
        {
            var _local_1:Rectangle;
            this._explainTextArea = ComponentFactory.Instance.creatComponentByStylename("feedback.simpleTextArea");
            _local_1 = ComponentFactory.Instance.creatCustomObject("feedback.stealHandExplainTextAreaRec");
            ObjectUtils.copyPropertyByRectangle(this._explainTextArea, _local_1);
            this._explainTextArea.textField.htmlText = LanguageMgr.GetTranslation("feedback.view.explainTextAreaText");
            this._explainTextArea.textField.type = TextFieldType.DYNAMIC;
            this._explainTextArea.invalidateViewport();
            addChildAt(this._explainTextArea, 0);
            this._acquirementTextImg = ComponentFactory.Instance.creatComponentByStylename("ddtfeedback.typeText");
            this._acquirementTextImg.text = LanguageMgr.GetTranslation("feedback.view.Feedback.text9");
            _local_1 = ComponentFactory.Instance.creatCustomObject("feedback.stealHandAcquirementTextImgRec");
            ObjectUtils.copyPropertyByRectangle(this._acquirementTextImg, _local_1);
            this._acquirementTextImg.visible = false;
            addChildAt(this._acquirementTextImg, 0);
            this._acquirementTextInput = ComponentFactory.Instance.creatComponentByStylename("feedback.textInput");
            _local_1 = ComponentFactory.Instance.creatCustomObject("feedback.stealHandAcquirementInputRec");
            ObjectUtils.copyPropertyByRectangle(this._acquirementTextInput, _local_1);
            this._acquirementTextInput.visible = false;
            addChildAt(this._acquirementTextInput, 0);
            this._acquirementAsterisk = ComponentFactory.Instance.creatBitmap("asset.feedback.asteriskImg");
            _local_1 = ComponentFactory.Instance.creatCustomObject("feedback.stealHandAcquirementAsteriskRec");
            ObjectUtils.copyPropertyByRectangle(this._acquirementAsterisk, _local_1);
            this._acquirementAsterisk.visible = false;
            addChildAt(this._acquirementAsterisk, 0);
            this._getTimeTextImg = ComponentFactory.Instance.creatComponentByStylename("ddtfeedback.typeText");
            this._getTimeTextImg.text = LanguageMgr.GetTranslation("feedback.view.Feedback.text10");
            _local_1 = ComponentFactory.Instance.creatCustomObject("feedback.stealHandGetTimeTextImgRec");
            ObjectUtils.copyPropertyByRectangle(this._getTimeTextImg, _local_1);
            this._getTimeTextImg.visible = false;
            addChildAt(this._getTimeTextImg, 0);
            this._getTimeTextInput = ComponentFactory.Instance.creatComponentByStylename("feedback.textInput");
            _local_1 = ComponentFactory.Instance.creatCustomObject("feedback.stealHandGetTimeInputRec");
            ObjectUtils.copyPropertyByRectangle(this._getTimeTextInput, _local_1);
            this._getTimeTextInput.visible = false;
            this._getTimeTextInput.textField.restrict = "0-9\\-";
            addChildAt(this._getTimeTextInput, 0);
            this._getTimeAsterisk = ComponentFactory.Instance.creatBitmap("asset.feedback.asteriskImg");
            _local_1 = ComponentFactory.Instance.creatCustomObject("feedback.stealHandGetTimeAsteriskRec");
            ObjectUtils.copyPropertyByRectangle(this._getTimeAsterisk, _local_1);
            this._getTimeAsterisk.visible = false;
            addChildAt(this._getTimeAsterisk, 0);
            this._infoDateText = ComponentFactory.Instance.creatComponentByStylename("feedback.infoText");
            _local_1 = ComponentFactory.Instance.creatCustomObject("feedback.stealHandInfoDateTextRec");
            ObjectUtils.copyPropertyByRectangle(this._infoDateText, _local_1);
            this._infoDateText.text = LanguageMgr.GetTranslation("feedback.view.infoDateText");
            addChildAt(this._infoDateText, 0);
            this._infoDateText.visible = false;
            this._detailTextImg = ComponentFactory.Instance.creatComponentByStylename("ddtfeedback.descriptionText");
            this._detailTextImg.text = LanguageMgr.GetTranslation("feedback.view.Feedback.text6");
            _local_1 = ComponentFactory.Instance.creatCustomObject("feedback.stealHandDetailTextImgRec");
            ObjectUtils.copyPropertyByRectangle(this._detailTextImg, _local_1);
            this._detailTextImg.visible = false;
            addChildAt(this._detailTextImg, 0);
            this._infoText = ComponentFactory.Instance.creatComponentByStylename("feedback.infoText");
            _local_1 = ComponentFactory.Instance.creatCustomObject("feedback.stealHandDisappearInfoTextRec");
            ObjectUtils.copyPropertyByRectangle(this._infoText, _local_1);
            addChildAt(this._infoText, 0);
            this._infoText.visible = false;
            this._csTelText = ComponentFactory.Instance.creatComponentByStylename("feedback.csTelText");
            this._csTelText.text = LanguageMgr.GetTranslation("feedback.view.csTelNumber", PathManager.solveFeedbackTelNumber());
            if ((!(StringHelper.isNullOrEmpty(PathManager.solveFeedbackTelNumber()))))
            {
                addChild(this._csTelText);
            };
            this._csTelPos = new Point();
            PositionUtils.setPos(this._csTelPos, this._csTelText);
            this._csTelText.y = 85;
            this._csTelText.visible = true;
            this._detailTextArea = ComponentFactory.Instance.creatComponentByStylename("feedback.simpleTextArea");
            _local_1 = ComponentFactory.Instance.creatCustomObject("feedback.stealHandDetailTextAreaRec");
            ObjectUtils.copyPropertyByRectangle(this._detailTextArea, _local_1);
            this._detailTextArea.text = "";
            this._detailTextArea.visible = false;
            addChildAt(this._detailTextArea, 0);
            this._infoText.text = LanguageMgr.GetTranslation("feedback.view.infoText", this._detailTextArea.maxChars);
            this._nextBtn = ComponentFactory.Instance.creatComponentByStylename("feedback.btn");
            _local_1 = ComponentFactory.Instance.creatCustomObject("feedback.stealHandNextBtnRec");
            ObjectUtils.copyPropertyByRectangle(this._nextBtn, _local_1);
            this._nextBtn.text = LanguageMgr.GetTranslation("tank.view.bagII.baglocked.next");
            addChildAt(this._nextBtn, 0);
            this._closeBtn = ComponentFactory.Instance.creatComponentByStylename("feedback.closebtn");
            _local_1 = ComponentFactory.Instance.creatCustomObject("feedback.stealHandCloseBtnRec");
            ObjectUtils.copyPropertyByRectangle(this._closeBtn, _local_1);
            this._closeBtn.text = LanguageMgr.GetTranslation("tank.invite.InviteView.close");
            addChildAt(this._closeBtn, 0);
            this._backBtn = ComponentFactory.Instance.creatComponentByStylename("feedback.btn");
            _local_1 = ComponentFactory.Instance.creatCustomObject("feedback.stealHandBackBtnRec");
            ObjectUtils.copyPropertyByRectangle(this._backBtn, _local_1);
            this._backBtn.text = LanguageMgr.GetTranslation("tank.view.bagII.baglocked.preview");
            this._backBtn.visible = false;
            addChildAt(this._backBtn, 0);
            this._submitBtn = ComponentFactory.Instance.creatComponentByStylename("feedback.btn");
            _local_1 = ComponentFactory.Instance.creatCustomObject("feedback.stealHandSubmitBtnRec");
            ObjectUtils.copyPropertyByRectangle(this._submitBtn, _local_1);
            this._submitBtn.text = LanguageMgr.GetTranslation("feedback.view.FeedbackSubmitSp.submitBtnText");
            this._submitBtn.visible = false;
            addChildAt(this._submitBtn, 0);
            this.addEvent();
        }

        private function addEvent():void
        {
            this._nextBtn.addEventListener(MouseEvent.CLICK, this.__nextBtnClick);
            this._backBtn.addEventListener(MouseEvent.CLICK, this.__backBtnClick);
            this._submitBtn.addEventListener(MouseEvent.CLICK, this.__submitBtnClick);
            this._closeBtn.addEventListener(MouseEvent.CLICK, this.__closeBtnClick);
            this._detailTextArea.textField.addEventListener(Event.CHANGE, this.__texeInput);
        }

        private function remvoeEvent():void
        {
            this._nextBtn.addEventListener(MouseEvent.CLICK, this.__nextBtnClick);
            this._backBtn.addEventListener(MouseEvent.CLICK, this.__backBtnClick);
            this._submitBtn.addEventListener(MouseEvent.CLICK, this.__submitBtnClick);
            this._closeBtn.removeEventListener(MouseEvent.CLICK, this.__closeBtnClick);
            this._detailTextArea.textField.removeEventListener(Event.CHANGE, this.__texeInput);
        }


    }
}//package feedback.view

