// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//feedback.view.FeedbackSubmitFrame

package feedback.view
{
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import flash.display.Bitmap;
    import com.pickgliss.ui.image.ScaleUpDownImage;
    import flash.display.Sprite;
    import com.pickgliss.ui.controls.ComboBox;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.controls.TextInput;
    import com.pickgliss.utils.ObjectUtils;
    import feedback.FeedbackManager;
    import ddt.manager.PlayerManager;
    import feedback.data.FeedbackInfo;
    import com.pickgliss.ui.LayerManager;
    import ddt.manager.SoundManager;
    import com.pickgliss.events.FrameEvent;
    import flash.events.Event;
    import flash.geom.Rectangle;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.ComponentFactory;
    import road7th.utils.DateUtils;
    import com.pickgliss.events.InteractiveEvent;
    import flash.events.MouseEvent;
    import ddt.utils.PositionUtils;

    public class FeedbackSubmitFrame extends BaseAlerFrame 
    {

        private var _bg:Bitmap;
        private var _topbg:ScaleUpDownImage;
        private var _buttomBg:ScaleUpDownImage;
        private var _box:Sprite;
        private var _dayCombox:ComboBox;
        private var _dayTextImg:FilterFrameText;
        private var _feedbackSp:Disposeable;
        private var _monthCombox:ComboBox;
        private var _monthTextImg:FilterFrameText;
        private var _occurrenceTimeTextImg:FilterFrameText;
        private var _problemCombox:ComboBox;
        private var _problemTitleAsterisk:Bitmap;
        private var _problemTitleInput:TextInput;
        private var _problemTitleTextImg:FilterFrameText;
        private var _problemTypesAsterisk:Bitmap;
        private var _problemTypesTextImg:FilterFrameText;
        private var _yearCombox:ComboBox;
        private var _yearTextImg:FilterFrameText;

        public function FeedbackSubmitFrame()
        {
            this._init();
        }

        public function get problemCombox():ComboBox
        {
            return (this._problemCombox);
        }

        public function get problemTitleInput():TextInput
        {
            return (this._problemTitleInput);
        }

        override public function dispose():void
        {
            this.remvoeEvent();
            if (this._feedbackSp)
            {
                this._feedbackSp.dispose();
            };
            this._bg = null;
            this._topbg = null;
            ObjectUtils.disposeAllChildren(this._box);
            ObjectUtils.disposeObject(this._box);
            this._box = null;
            ObjectUtils.disposeAllChildren((this._feedbackSp as Sprite));
            this._feedbackSp = null;
            ObjectUtils.disposeAllChildren(this);
            this._problemTypesTextImg = null;
            this._problemCombox = null;
            this._problemTitleTextImg = null;
            this._problemTypesAsterisk = null;
            this._problemTitleInput = null;
            this._problemTitleAsterisk = null;
            this._occurrenceTimeTextImg = null;
            this._yearCombox = null;
            this._yearTextImg = null;
            this._monthCombox = null;
            this._monthTextImg = null;
            this._dayCombox = null;
            this._dayTextImg = null;
            super.dispose();
            if (this.parent)
            {
                this.parent.removeChild(this);
            };
        }

        public function get feedbackInfo():FeedbackInfo
        {
            FeedbackManager.instance.feedbackInfo.user_id = PlayerManager.Instance.Self.ID;
            FeedbackManager.instance.feedbackInfo.user_name = PlayerManager.Instance.Self.LoginName;
            FeedbackManager.instance.feedbackInfo.user_nick_name = PlayerManager.Instance.Self.NickName;
            if (this._problemCombox)
            {
                FeedbackManager.instance.feedbackInfo.question_type = (this._problemCombox.currentSelectedIndex + 1);
                FeedbackManager.instance.feedbackInfo.question_title = this._problemTitleInput.text;
                FeedbackManager.instance.feedbackInfo.occurrence_date = ((((this._yearCombox.textField.text + "-") + this._monthCombox.textField.text) + "-") + this._dayCombox.textField.text);
            };
            return (FeedbackManager.instance.feedbackInfo);
        }

        public function show():void
        {
            LayerManager.Instance.addToLayer(this, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
        }

        private function __frameEventHandler(_arg_1:FrameEvent):void
        {
            switch (_arg_1.responseCode)
            {
                case FrameEvent.ESC_CLICK:
                case FrameEvent.CLOSE_CLICK:
                    SoundManager.instance.play("008");
                    FeedbackManager.instance.closeFrame();
                    return;
            };
        }

        private function __problemComboxChanged(_arg_1:Event):void
        {
            SoundManager.instance.play("008");
            if (this._feedbackSp)
            {
                var _local_2:* = this._feedbackSp;
                (_local_2["setFeedbackInfo"]());
                this._feedbackSp.dispose();
            };
            this._feedbackSp = this.getFeedbackSp(this._problemCombox.currentSelectedIndex);
            if (this._feedbackSp)
            {
                addToContent(this._box);
                addToContent((this._feedbackSp as Sprite));
                this.fixFeedBackTopImg(this._problemCombox.currentSelectedIndex);
            };
        }

        private function fixFeedBackTopImg(_arg_1:int):void
        {
            switch (_arg_1)
            {
                case 0:
                case 3:
                case 5:
                case 6:
                case 9:
                    this._topbg.height = 112;
                    return;
                case 1:
                    this._topbg.height = 148;
                    return;
                case 4:
                    this._topbg.height = 180;
                    return;
                case 2:
                    this._topbg.height = 188;
                    return;
                case 8:
                    this._topbg.height = 178;
                    return;
                case 7:
                    this._topbg.height = 188;
                    return;
                default:
                    this._topbg.height = 112;
            };
        }

        private function _init():void
        {
            var _local_1:Rectangle;
            var _local_3:uint;
            titleText = LanguageMgr.GetTranslation("feedback.view.FeedbackSubmitFrame.title");
            this._bg = ComponentFactory.Instance.creatBitmap("asset.feedback.bg");
            addToContent(this._bg);
            this._topbg = ComponentFactory.Instance.creatComponentByStylename("asset.feedback.topBg");
            addToContent(this._topbg);
            this._feedbackSp = this.getFeedbackSp(0);
            addToContent((this._feedbackSp as Sprite));
            this._box = new Sprite();
            addToContent(this._box);
            this._problemTypesTextImg = ComponentFactory.Instance.creatComponentByStylename("ddtfeedback.typeText");
            this._problemTypesTextImg.text = LanguageMgr.GetTranslation("feedback.view.Feedback.text");
            _local_1 = ComponentFactory.Instance.creatCustomObject("feedback.problemTypesTextImgRec");
            ObjectUtils.copyPropertyByRectangle(this._problemTypesTextImg, _local_1);
            this._box.addChildAt(this._problemTypesTextImg, 0);
            this._problemCombox = ComponentFactory.Instance.creatComponentByStylename("feedback.combox");
            _local_1 = ComponentFactory.Instance.creatCustomObject("feedback.comboxRec");
            ObjectUtils.copyPropertyByRectangle(this._problemCombox, _local_1);
            this._problemCombox.beginChanges();
            this._problemCombox.selctedPropName = "text";
            this._problemCombox.listPanel.vectorListModel.append(LanguageMgr.GetTranslation("feedback.view.problemCombox_text0"));
            this._problemCombox.listPanel.vectorListModel.append(LanguageMgr.GetTranslation("feedback.view.problemCombox_text1"));
            this._problemCombox.listPanel.vectorListModel.append(LanguageMgr.GetTranslation("feedback.view.problemCombox_text2"));
            this._problemCombox.listPanel.vectorListModel.append(LanguageMgr.GetTranslation("feedback.view.problemCombox_text3"));
            this._problemCombox.listPanel.vectorListModel.append(LanguageMgr.GetTranslation("feedback.view.problemCombox_text4"));
            this._problemCombox.listPanel.vectorListModel.append(LanguageMgr.GetTranslation("feedback.view.problemCombox_text5"));
            this._problemCombox.listPanel.vectorListModel.append(LanguageMgr.GetTranslation("feedback.view.problemCombox_text6"));
            this._problemCombox.listPanel.vectorListModel.append(LanguageMgr.GetTranslation("feedback.view.problemCombox_text7"));
            this._problemCombox.listPanel.vectorListModel.append(LanguageMgr.GetTranslation("feedback.view.problemCombox_text8"));
            this._problemCombox.listPanel.vectorListModel.append(LanguageMgr.GetTranslation("feedback.view.problemCombox_text9"));
            this._problemCombox.commitChanges();
            this._problemCombox.textField.text = LanguageMgr.GetTranslation("feedback.view.FeedbackSubmitSp.comBoxText");
            this._box.addChildAt(this._problemCombox, 0);
            this._problemTypesAsterisk = ComponentFactory.Instance.creatBitmap("asset.feedback.asteriskImg");
            _local_1 = ComponentFactory.Instance.creatCustomObject("feedback.problemTypesAsteriskTextRec");
            ObjectUtils.copyPropertyByRectangle(this._problemTypesAsterisk, _local_1);
            this._box.addChildAt(this._problemTypesAsterisk, 0);
            this._problemTitleTextImg = ComponentFactory.Instance.creatComponentByStylename("ddtfeedback.titleText");
            this._problemTitleTextImg.text = LanguageMgr.GetTranslation("feedback.view.Feedback.text1");
            _local_1 = ComponentFactory.Instance.creatCustomObject("feedback.problemTitleTextImgRec");
            ObjectUtils.copyPropertyByRectangle(this._problemTitleTextImg, _local_1);
            this._box.addChildAt(this._problemTitleTextImg, 0);
            this._problemTitleInput = ComponentFactory.Instance.creatComponentByStylename("feedback.textInput");
            _local_1 = ComponentFactory.Instance.creatCustomObject("feedback.problemTitleInputRec");
            ObjectUtils.copyPropertyByRectangle(this._problemTitleInput, _local_1);
            this._box.addChildAt(this._problemTitleInput, 0);
            this._problemTitleAsterisk = ComponentFactory.Instance.creatBitmap("asset.feedback.asteriskImg");
            _local_1 = ComponentFactory.Instance.creatCustomObject("feedback.problemTitleAsteriskTextRec");
            ObjectUtils.copyPropertyByRectangle(this._problemTitleAsterisk, _local_1);
            this._box.addChildAt(this._problemTitleAsterisk, 0);
            this._occurrenceTimeTextImg = ComponentFactory.Instance.creatComponentByStylename("ddtfeedback.timerText");
            this._occurrenceTimeTextImg.text = LanguageMgr.GetTranslation("feedback.view.Feedback.text2");
            _local_1 = ComponentFactory.Instance.creatCustomObject("feedback.occurrenceTimeTextImgRec");
            ObjectUtils.copyPropertyByRectangle(this._occurrenceTimeTextImg, _local_1);
            this._box.addChildAt(this._occurrenceTimeTextImg, 0);
            this._yearCombox = ComponentFactory.Instance.creatComponentByStylename("feedback.combox2");
            _local_1 = ComponentFactory.Instance.creatCustomObject("feedback.yearComboxRec");
            ObjectUtils.copyPropertyByRectangle(this._yearCombox, _local_1);
            this._yearCombox.beginChanges();
            var _local_2:Number = new Date().getFullYear();
            this._yearCombox.textField.text = String(_local_2);
            this._yearCombox.snapItemHeight = true;
            this._yearCombox.selctedPropName = "text";
            _local_3 = _local_2;
            while (_local_3 >= (_local_2 - 2))
            {
                this._yearCombox.listPanel.vectorListModel.append(_local_3);
                _local_3--;
            };
            this._yearCombox.commitChanges();
            this._box.addChildAt(this._yearCombox, 0);
            this._yearTextImg = ComponentFactory.Instance.creatComponentByStylename("ddtfeedback.yearText");
            this._yearTextImg.text = LanguageMgr.GetTranslation("feedback.view.Feedback.text3");
            _local_1 = ComponentFactory.Instance.creatCustomObject("feedback.yearTextImgRec");
            ObjectUtils.copyPropertyByRectangle(this._yearTextImg, _local_1);
            this._box.addChildAt(this._yearTextImg, 0);
            this._monthCombox = ComponentFactory.Instance.creatComponentByStylename("feedback.combox3");
            _local_1 = ComponentFactory.Instance.creatCustomObject("feedback.monthComboxRec");
            ObjectUtils.copyPropertyByRectangle(this._monthCombox, _local_1);
            this._monthCombox.beginChanges();
            var _local_4:Number = (new Date().getMonth() + 1);
            this._monthCombox.textField.text = String(_local_4);
            this._monthCombox.selctedPropName = "text";
            _local_3 = 1;
            while (_local_3 <= 12)
            {
                this._monthCombox.listPanel.vectorListModel.append(_local_3);
                _local_3++;
            };
            this._monthCombox.commitChanges();
            this._box.addChildAt(this._monthCombox, 0);
            this._monthTextImg = ComponentFactory.Instance.creatComponentByStylename("ddtfeedback.monthText");
            this._monthTextImg.text = LanguageMgr.GetTranslation("feedback.view.Feedback.text4");
            _local_1 = ComponentFactory.Instance.creatCustomObject("feedback.monthTextImgRec");
            ObjectUtils.copyPropertyByRectangle(this._monthTextImg, _local_1);
            this._box.addChildAt(this._monthTextImg, 0);
            this._dayCombox = ComponentFactory.Instance.creatComponentByStylename("feedback.combox4");
            _local_1 = ComponentFactory.Instance.creatCustomObject("feedback.dayComboxRec");
            ObjectUtils.copyPropertyByRectangle(this._dayCombox, _local_1);
            this._dayCombox.beginChanges();
            var _local_5:Number = new Date().getDate();
            this._dayCombox.textField.text = String(_local_5);
            this._dayCombox.selctedPropName = "text";
            var _local_6:Number = DateUtils.getDays(_local_2, _local_4);
            _local_3 = 1;
            while (_local_3 <= _local_6)
            {
                this._dayCombox.listPanel.vectorListModel.append(_local_3);
                _local_3++;
            };
            this._dayCombox.commitChanges();
            this._box.addChildAt(this._dayCombox, 0);
            this._dayTextImg = ComponentFactory.Instance.creatComponentByStylename("ddtfeedback.dayText");
            this._dayTextImg.text = LanguageMgr.GetTranslation("feedback.view.Feedback.text5");
            _local_1 = ComponentFactory.Instance.creatCustomObject("feedback.dayTextImgRec");
            ObjectUtils.copyPropertyByRectangle(this._dayTextImg, _local_1);
            this._box.addChildAt(this._dayTextImg, 0);
            this.addEvent();
        }

        private function addEvent():void
        {
            addEventListener(FrameEvent.RESPONSE, this.__frameEventHandler);
            this._problemCombox.addEventListener(InteractiveEvent.STATE_CHANGED, this.__problemComboxChanged);
            this._yearCombox.addEventListener(InteractiveEvent.STATE_CHANGED, this._dateChanged);
            this._monthCombox.addEventListener(InteractiveEvent.STATE_CHANGED, this._dateChanged);
            this._dayCombox.addEventListener(InteractiveEvent.STATE_CHANGED, this.__comboxClick);
            this._problemCombox.addEventListener(MouseEvent.CLICK, this.__comboxClick);
            this._yearCombox.addEventListener(MouseEvent.CLICK, this.__comboxClick);
            this._monthCombox.addEventListener(MouseEvent.CLICK, this.__comboxClick);
            this._dayCombox.addEventListener(MouseEvent.CLICK, this.__comboxClick);
        }

        private function __comboxClick(_arg_1:Event):void
        {
            SoundManager.instance.play("008");
        }

        private function _dateChanged(_arg_1:InteractiveEvent):void
        {
            SoundManager.instance.play("008");
            this._dayCombox.textField.text = "1";
            var _local_2:Number = DateUtils.getDays(Number(this._yearCombox.textField.text), Number(this._monthCombox.textField.text));
            this._dayCombox.listPanel.vectorListModel.clear();
            this._dayCombox.beginChanges();
            var _local_3:uint = 1;
            while (_local_3 <= _local_2)
            {
                this._dayCombox.listPanel.vectorListModel.append(_local_3);
                _local_3++;
            };
            this._dayCombox.commitChanges();
        }

        private function getFeedbackSp(_arg_1:int):Disposeable
        {
            var _local_2:Disposeable;
            switch (_arg_1)
            {
                case 0:
                case 5:
                case 6:
                case 9:
                    _local_2 = new FeedbackConsultingSp();
                    this.height = 450;
                    this.y = 75;
                    break;
                case 1:
                    _local_2 = new FeedbackProblemsSp();
                    this.height = 450;
                    this.y = 75;
                    break;
                case 2:
                    _local_2 = new FeedbackPropsDisappearSp();
                    this.height = 450;
                    this.y = 75;
                    break;
                case 3:
                    _local_2 = new FeedbackStealHandSp();
                    PositionUtils.setPos(_local_2, "feedback.FeedbackStealHandSp.pos");
                    this.height = 450;
                    this.y = 55;
                    break;
                case 4:
                    _local_2 = new FeedbackPrepaidCardSp();
                    this.height = 450;
                    this.y = 75;
                    break;
                case 8:
                    _local_2 = new FeedbackReportSp();
                    this.height = 450;
                    this.y = 75;
                    break;
                case 7:
                    _local_2 = new FeedbackComplaintSp();
                    this.height = 450;
                    this.y = 75;
                    break;
            };
            _local_2["submitFrame"] = this;
            return (_local_2);
        }

        private function remvoeEvent():void
        {
            removeEventListener(FrameEvent.RESPONSE, this.__frameEventHandler);
            this._problemCombox.removeEventListener(InteractiveEvent.STATE_CHANGED, this.__problemComboxChanged);
            this._yearCombox.removeEventListener(InteractiveEvent.STATE_CHANGED, this._dateChanged);
            this._monthCombox.removeEventListener(InteractiveEvent.STATE_CHANGED, this._dateChanged);
            this._dayCombox.removeEventListener(InteractiveEvent.STATE_CHANGED, this.__comboxClick);
            this._problemCombox.removeEventListener(MouseEvent.CLICK, this.__comboxClick);
            this._yearCombox.removeEventListener(MouseEvent.CLICK, this.__comboxClick);
            this._monthCombox.removeEventListener(MouseEvent.CLICK, this.__comboxClick);
            this._dayCombox.removeEventListener(MouseEvent.CLICK, this.__comboxClick);
        }


    }
}//package feedback.view

