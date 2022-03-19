// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//feedback.view.FeedbackPrepaidCardSp

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

    public class FeedbackPrepaidCardSp extends Sprite implements Disposeable 
    {

        private var _closeBtn:TextButton;
        private var _detailTextArea:TextArea;
        private var _csTelText:FilterFrameText;
        private var _detailTextImg:FilterFrameText;
        private var _infoText:FilterFrameText;
        private var _orderNumberValueAsterisk:Bitmap;
        private var _orderNumberValueTextImg:FilterFrameText;
        private var _orderNumberValueTextInput:TextInput;
        private var _prepaidAmountAsterisk:Bitmap;
        private var _prepaidAmountTextImg:FilterFrameText;
        private var _prepaidAmountTextInput:TextInput;
        private var _prepaidModeAsterisk:Bitmap;
        private var _prepaidModeTextImg:FilterFrameText;
        private var _prepaidModeTextInput:TextInput;
        private var _submitBtn:TextButton;
        private var _submitFrame:FeedbackSubmitFrame;

        public function FeedbackPrepaidCardSp()
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
            if ((!(this._submitFrame.feedbackInfo.charge_order_id)))
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("feedback.view.charge_order_id"));
                return (false);
            };
            if ((!(this._submitFrame.feedbackInfo.charge_method)))
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("feedback.view.charge_method"));
                return (false);
            };
            if ((!(this._submitFrame.feedbackInfo.charge_moneys)))
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("feedback.view.charge_moneys"));
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
            this._orderNumberValueTextImg = null;
            this._orderNumberValueTextInput = null;
            this._orderNumberValueAsterisk = null;
            this._prepaidModeTextImg = null;
            this._prepaidModeTextInput = null;
            this._prepaidModeAsterisk = null;
            this._prepaidAmountTextImg = null;
            this._prepaidAmountTextInput = null;
            this._prepaidAmountAsterisk = null;
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
            this._submitFrame.feedbackInfo.charge_order_id = this._orderNumberValueTextInput.text;
            this._submitFrame.feedbackInfo.charge_method = this._prepaidModeTextInput.text;
            this._submitFrame.feedbackInfo.charge_moneys = Number(this._prepaidAmountTextInput.text);
        }

        public function set submitFrame(_arg_1:FeedbackSubmitFrame):void
        {
            this._submitFrame = _arg_1;
            if (this._submitFrame.feedbackInfo.question_content)
            {
                this._detailTextArea.text = this._submitFrame.feedbackInfo.question_content;
            };
            if (this._submitFrame.feedbackInfo.charge_order_id)
            {
                this._orderNumberValueTextInput.text = this._submitFrame.feedbackInfo.charge_order_id;
            };
            if (this._submitFrame.feedbackInfo.charge_method)
            {
                this._prepaidModeTextInput.text = this._submitFrame.feedbackInfo.charge_method;
            };
            if (this._submitFrame.feedbackInfo.charge_moneys)
            {
                this._prepaidAmountTextInput.text = String(this._submitFrame.feedbackInfo.charge_moneys);
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
                _local_2.charge_order_id = this._submitFrame.feedbackInfo.charge_order_id;
                _local_2.charge_method = this._submitFrame.feedbackInfo.charge_method;
                _local_2.charge_moneys = this._submitFrame.feedbackInfo.charge_moneys;
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
            this._orderNumberValueTextImg = ComponentFactory.Instance.creatComponentByStylename("ddtfeedback.typeText");
            this._orderNumberValueTextImg.text = LanguageMgr.GetTranslation("feedback.view.Feedback.text11");
            _local_1 = ComponentFactory.Instance.creatCustomObject("feedback.prepaidCardOrderNumberValueTextImgRec");
            ObjectUtils.copyPropertyByRectangle(this._orderNumberValueTextImg, _local_1);
            addChildAt(this._orderNumberValueTextImg, 0);
            this._orderNumberValueTextInput = ComponentFactory.Instance.creatComponentByStylename("feedback.textInput.OrderNum");
            _local_1 = ComponentFactory.Instance.creatCustomObject("feedback.prepaidCardOrderNumberValueInputRec");
            ObjectUtils.copyPropertyByRectangle(this._orderNumberValueTextInput, _local_1);
            this._orderNumberValueTextInput.textField.restrict = "a-zA-Z0-9";
            addChildAt(this._orderNumberValueTextInput, 0);
            this._orderNumberValueAsterisk = ComponentFactory.Instance.creatBitmap("asset.feedback.asteriskImg");
            _local_1 = ComponentFactory.Instance.creatCustomObject("feedback.prepaidCardOrderNumberValueAsteriskRec");
            ObjectUtils.copyPropertyByRectangle(this._orderNumberValueAsterisk, _local_1);
            addChildAt(this._orderNumberValueAsterisk, 0);
            this._prepaidModeTextImg = ComponentFactory.Instance.creatComponentByStylename("ddtfeedback.typeText");
            this._prepaidModeTextImg.text = LanguageMgr.GetTranslation("feedback.view.Feedback.text12");
            _local_1 = ComponentFactory.Instance.creatCustomObject("feedback.prepaidCardPrepaidModeTextImgRec");
            ObjectUtils.copyPropertyByRectangle(this._prepaidModeTextImg, _local_1);
            addChildAt(this._prepaidModeTextImg, 0);
            this._prepaidModeTextInput = ComponentFactory.Instance.creatComponentByStylename("feedback.textInput");
            this._prepaidModeTextInput.maxChars = 10;
            _local_1 = ComponentFactory.Instance.creatCustomObject("feedback.prepaidCardPrepaidModeInputRec");
            ObjectUtils.copyPropertyByRectangle(this._prepaidModeTextInput, _local_1);
            addChildAt(this._prepaidModeTextInput, 0);
            this._prepaidModeAsterisk = ComponentFactory.Instance.creatBitmap("asset.feedback.asteriskImg");
            _local_1 = ComponentFactory.Instance.creatCustomObject("feedback.prepaidCardPrepaidModeAsteriskRec");
            ObjectUtils.copyPropertyByRectangle(this._prepaidModeAsterisk, _local_1);
            addChildAt(this._prepaidModeAsterisk, 0);
            this._prepaidAmountTextImg = ComponentFactory.Instance.creatComponentByStylename("ddtfeedback.typeText");
            this._prepaidAmountTextImg.text = LanguageMgr.GetTranslation("feedback.view.Feedback.text13");
            _local_1 = ComponentFactory.Instance.creatCustomObject("feedback.prepaidCardPrepaidAmountTextImgRec");
            ObjectUtils.copyPropertyByRectangle(this._prepaidAmountTextImg, _local_1);
            addChildAt(this._prepaidAmountTextImg, 0);
            this._prepaidAmountTextInput = ComponentFactory.Instance.creatComponentByStylename("feedback.textInput");
            _local_1 = ComponentFactory.Instance.creatCustomObject("feedback.prepaidCardPrepaidAmountInputRec");
            this._prepaidAmountTextInput.textField.restrict = "0-9";
            ObjectUtils.copyPropertyByRectangle(this._prepaidAmountTextInput, _local_1);
            addChildAt(this._prepaidAmountTextInput, 0);
            this._prepaidAmountAsterisk = ComponentFactory.Instance.creatBitmap("asset.feedback.asteriskImg");
            _local_1 = ComponentFactory.Instance.creatCustomObject("feedback.prepaidCardPrepaidAmountAsteriskRec");
            ObjectUtils.copyPropertyByRectangle(this._prepaidAmountAsterisk, _local_1);
            addChildAt(this._prepaidAmountAsterisk, 0);
            this._detailTextImg = ComponentFactory.Instance.creatComponentByStylename("ddtfeedback.descriptionText");
            this._detailTextImg.text = LanguageMgr.GetTranslation("feedback.view.Feedback.text6");
            _local_1 = ComponentFactory.Instance.creatCustomObject("feedback.prepaidCardDetailTextImgRec");
            ObjectUtils.copyPropertyByRectangle(this._detailTextImg, _local_1);
            addChildAt(this._detailTextImg, 0);
            this._csTelText = ComponentFactory.Instance.creatComponentByStylename("feedback.csTelText");
            this._csTelText.text = LanguageMgr.GetTranslation("feedback.view.csTelNumber", PathManager.solveFeedbackTelNumber());
            if ((!(StringHelper.isNullOrEmpty(PathManager.solveFeedbackTelNumber()))))
            {
                addChild(this._csTelText);
            };
            this._infoText = ComponentFactory.Instance.creatComponentByStylename("feedback.infoText");
            _local_1 = ComponentFactory.Instance.creatCustomObject("feedback.prepaidCardDisappearInfoTextRec");
            ObjectUtils.copyPropertyByRectangle(this._infoText, _local_1);
            this._csTelText.y = 210;
            addChildAt(this._infoText, 0);
            this._detailTextArea = ComponentFactory.Instance.creatComponentByStylename("feedback.simpleTextArea");
            _local_1 = ComponentFactory.Instance.creatCustomObject("feedback.prepaidCardDetailTextAreaRec");
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

