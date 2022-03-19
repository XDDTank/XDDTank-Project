// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//baglocked.SetPassFrame2

package baglocked
{
    import com.pickgliss.ui.controls.Frame;
    import com.pickgliss.ui.controls.TextButton;
    import com.pickgliss.ui.controls.ComboBox;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.controls.TextInput;
    import flash.events.KeyboardEvent;
    import com.pickgliss.utils.ObjectUtils;
    import com.pickgliss.ui.LayerManager;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.SoundManager;
    import flash.events.MouseEvent;
    import com.pickgliss.events.FrameEvent;
    import flash.text.TextFieldType;
    import flash.events.Event;
    import ddt.manager.MessageTipManager;
    import com.pickgliss.utils.StringUtils;
    import com.pickgliss.events.InteractiveEvent;

    public class SetPassFrame2 extends Frame 
    {

        private var _backBtn1:TextButton;
        private var _bagLockedController:BagLockedController;
        private var _bag_Combox1:ComboBox;
        private var _bag_Combox2:ComboBox;
        private var _nextBtn2:TextButton;
        private var _textInfo2_1:FilterFrameText;
        private var _textInfo2_2:FilterFrameText;
        private var _textInfo2_3:FilterFrameText;
        private var _textInfo2_4:FilterFrameText;
        private var _textInfo2_5:FilterFrameText;
        private var _textInfo2_6:FilterFrameText;
        private var _textinput2_1:TextInput;
        private var _textinput2_2:TextInput;
        private var _textInfo2_7:FilterFrameText;
        private var _isSkip:Boolean;


        public function __onTextEnter(_arg_1:KeyboardEvent):void
        {
            if (_arg_1.keyCode == 13)
            {
                if (this._nextBtn2.enable)
                {
                    this.__nextBtn2Click(null);
                };
            };
        }

        public function set bagLockedController(_arg_1:BagLockedController):void
        {
            this._bagLockedController = _arg_1;
        }

        override public function dispose():void
        {
            this.remvoeEvent();
            this._bagLockedController = null;
            ObjectUtils.disposeObject(this._textInfo2_1);
            this._textInfo2_1 = null;
            ObjectUtils.disposeObject(this._textInfo2_2);
            this._textInfo2_2 = null;
            ObjectUtils.disposeObject(this._textInfo2_3);
            this._textInfo2_3 = null;
            ObjectUtils.disposeObject(this._textInfo2_4);
            this._textInfo2_4 = null;
            ObjectUtils.disposeObject(this._textInfo2_5);
            this._textInfo2_5 = null;
            ObjectUtils.disposeObject(this._textInfo2_6);
            this._textInfo2_6 = null;
            ObjectUtils.disposeObject(this._textInfo2_7);
            this._textInfo2_7 = null;
            ObjectUtils.disposeObject(this._textinput2_1);
            this._textinput2_1 = null;
            ObjectUtils.disposeObject(this._textinput2_2);
            this._textinput2_2 = null;
            ObjectUtils.disposeObject(this._bag_Combox1);
            this._bag_Combox1 = null;
            ObjectUtils.disposeObject(this._bag_Combox2);
            this._bag_Combox2 = null;
            ObjectUtils.disposeObject(this._backBtn1);
            this._backBtn1 = null;
            ObjectUtils.disposeObject(this._nextBtn2);
            this._nextBtn2 = null;
            super.dispose();
        }

        public function show():void
        {
            LayerManager.Instance.addToLayer(this, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
            this._textinput2_1.setFocus();
            if (((this._bagLockedController.bagLockedInfo.questionOne.length > 0) || (this._bagLockedController.bagLockedInfo.isSelectCustomQuestion1 == true)))
            {
                this._bag_Combox1.textField.text = this._bagLockedController.bagLockedInfo.questionOne;
            };
            if (((this._bagLockedController.bagLockedInfo.questionTwo.length > 0) || (this._bagLockedController.bagLockedInfo.isSelectCustomQuestion2 == true)))
            {
                this._bag_Combox2.textField.text = this._bagLockedController.bagLockedInfo.questionTwo;
            };
            if (this._bagLockedController.bagLockedInfo.answerOne.length > 0)
            {
                this._textinput2_1.text = this._bagLockedController.bagLockedInfo.answerOne;
            };
            if (this._bagLockedController.bagLockedInfo.answerTwo.length > 0)
            {
                this._textinput2_2.text = this._bagLockedController.bagLockedInfo.answerTwo;
            };
            if (((this._textinput2_1.text.length > 0) && (this._textinput2_2.text.length > 0)))
            {
                this._nextBtn2.enable = true;
                this._isSkip = true;
            };
        }

        override protected function init():void
        {
            super.init();
            this.titleText = LanguageMgr.GetTranslation("tank.view.bagII.baglocked.guide");
            this._textInfo2_1 = ComponentFactory.Instance.creat("baglocked.text2_1");
            this._textInfo2_1.text = LanguageMgr.GetTranslation("baglocked.SetPassFrame2.question1");
            addToContent(this._textInfo2_1);
            this._textInfo2_2 = ComponentFactory.Instance.creat("baglocked.text2_2");
            this._textInfo2_2.text = LanguageMgr.GetTranslation("baglocked.SetPassFrame2.answer1");
            addToContent(this._textInfo2_2);
            this._textInfo2_3 = ComponentFactory.Instance.creat("baglocked.text2_3");
            this._textInfo2_3.text = LanguageMgr.GetTranslation("baglocked.SetPassFrame2.inputTextInfo1");
            addToContent(this._textInfo2_3);
            this._textInfo2_4 = ComponentFactory.Instance.creat("baglocked.text2_4");
            this._textInfo2_4.text = LanguageMgr.GetTranslation("baglocked.SetPassFrame2.question2");
            addToContent(this._textInfo2_4);
            this._textInfo2_5 = ComponentFactory.Instance.creat("baglocked.text2_5");
            this._textInfo2_5.text = LanguageMgr.GetTranslation("baglocked.SetPassFrame2.answer2");
            addToContent(this._textInfo2_5);
            this._textInfo2_6 = ComponentFactory.Instance.creat("baglocked.text2_6");
            this._textInfo2_6.text = LanguageMgr.GetTranslation("baglocked.SetPassFrame2.inputTextInfo1");
            addToContent(this._textInfo2_6);
            this._textInfo2_7 = ComponentFactory.Instance.creat("baglocked.text2_7");
            this._textInfo2_7.text = LanguageMgr.GetTranslation("baglocked.SetPassFrame2.textInfo2_7");
            addToContent(this._textInfo2_7);
            this._textinput2_1 = ComponentFactory.Instance.creat("baglocked.textInput2_1");
            addToContent(this._textinput2_1);
            this._textinput2_2 = ComponentFactory.Instance.creat("baglocked.textInput2_2");
            addToContent(this._textinput2_2);
            this._backBtn1 = ComponentFactory.Instance.creat("baglocked.backBtn1");
            this._backBtn1.text = LanguageMgr.GetTranslation("tank.view.bagII.baglocked.preview");
            addToContent(this._backBtn1);
            this._nextBtn2 = ComponentFactory.Instance.creat("baglocked.nextBtn2");
            this._nextBtn2.text = LanguageMgr.GetTranslation("tank.view.bagII.baglocked.next");
            addToContent(this._nextBtn2);
            this._bag_Combox1 = ComponentFactory.Instance.creat("baglocked.bag_Combox1");
            this._bag_Combox1.selctedPropName = "text";
            this._bag_Combox1.textField.text = LanguageMgr.GetTranslation("feedback.view.FeedbackSubmitSp.comBoxText");
            this._bag_Combox1.beginChanges();
            this._bag_Combox1.listPanel.vectorListModel.append(LanguageMgr.GetTranslation("tank.view.bagII.baglocked.question1"));
            this._bag_Combox1.listPanel.vectorListModel.append(LanguageMgr.GetTranslation("tank.view.bagII.baglocked.question2"));
            this._bag_Combox1.listPanel.vectorListModel.append(LanguageMgr.GetTranslation("tank.view.bagII.baglocked.question3"));
            this._bag_Combox1.listPanel.vectorListModel.append(LanguageMgr.GetTranslation("tank.view.bagII.baglocked.question4"));
            this._bag_Combox1.listPanel.vectorListModel.append(LanguageMgr.GetTranslation("tank.view.bagII.baglocked.question5"));
            this._bag_Combox1.listPanel.vectorListModel.append(LanguageMgr.GetTranslation("tank.view.bagII.baglocked.question6"));
            this._bag_Combox1.listPanel.vectorListModel.append(LanguageMgr.GetTranslation("tank.view.bagII.baglocked.customer"));
            this._bag_Combox1.listPanel.list.updateListView();
            this._bag_Combox1.commitChanges();
            this._bag_Combox2 = ComponentFactory.Instance.creat("baglocked.bag_Combox2");
            this._bag_Combox2.selctedPropName = "text";
            this._bag_Combox2.textField.text = LanguageMgr.GetTranslation("feedback.view.FeedbackSubmitSp.comBoxText");
            this._bag_Combox2.beginChanges();
            this._bag_Combox2.listPanel.vectorListModel.append(LanguageMgr.GetTranslation("tank.view.bagII.baglocked.question1"));
            this._bag_Combox2.listPanel.vectorListModel.append(LanguageMgr.GetTranslation("tank.view.bagII.baglocked.question2"));
            this._bag_Combox2.listPanel.vectorListModel.append(LanguageMgr.GetTranslation("tank.view.bagII.baglocked.question3"));
            this._bag_Combox2.listPanel.vectorListModel.append(LanguageMgr.GetTranslation("tank.view.bagII.baglocked.question4"));
            this._bag_Combox2.listPanel.vectorListModel.append(LanguageMgr.GetTranslation("tank.view.bagII.baglocked.question5"));
            this._bag_Combox2.listPanel.vectorListModel.append(LanguageMgr.GetTranslation("tank.view.bagII.baglocked.question6"));
            this._bag_Combox2.listPanel.vectorListModel.append(LanguageMgr.GetTranslation("tank.view.bagII.baglocked.customer"));
            this._bag_Combox2.listPanel.list.updateListView();
            this._bag_Combox2.commitChanges();
            addToContent(this._bag_Combox2);
            addToContent(this._bag_Combox1);
            this._textinput2_1.textField.tabIndex = 0;
            this._textinput2_2.textField.tabIndex = 1;
            this._textinput2_1.text = "";
            this._textinput2_2.text = "";
            this._nextBtn2.enable = false;
            this.addEvent();
        }

        private function __backBtn1Click(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            this._bagLockedController.bagLockedInfo.questionOne = this._bag_Combox1.textField.text;
            this._bagLockedController.bagLockedInfo.questionTwo = this._bag_Combox2.textField.text;
            this._bagLockedController.bagLockedInfo.answerOne = this._textinput2_1.text;
            this._bagLockedController.bagLockedInfo.answerTwo = this._textinput2_2.text;
            this._bagLockedController.openSetPassFrame1();
            this._bagLockedController.closeSetPassFrame2();
        }

        private function __frameEventHandler(_arg_1:FrameEvent):void
        {
            switch (_arg_1.responseCode)
            {
                case FrameEvent.ESC_CLICK:
                case FrameEvent.CLOSE_CLICK:
                    SoundManager.instance.play("008");
                    this._bagLockedController.bagLockedInfo = null;
                    this._bagLockedController.close();
                    return;
            };
        }

        private function __listItemClick(_arg_1:Event):void
        {
            var _local_3:Boolean;
            var _local_4:Boolean;
            SoundManager.instance.play("008");
            var _local_2:ComboBox = (_arg_1.currentTarget as ComboBox);
            if (_local_2.currentSelectedIndex == (_local_2.listPanel.vectorListModel.elements.length - 1))
            {
                stage.focus = _local_2.textField;
                _local_2.textField.type = TextFieldType.INPUT;
                _local_2.textField.autoSize = "none";
                _local_2.textField.maxChars = 14;
                _local_2.textField.width = 200;
                _local_2.textField.text = "";
                _local_2.textField.selectable = true;
                _local_2.textField.wordWrap = false;
                _local_2.textField.multiline = false;
                _local_3 = true;
            }
            else
            {
                _local_2.textField.type = TextFieldType.DYNAMIC;
                _local_2.textField.selectable = false;
                _local_2.textField.mouseEnabled = false;
            };
            _local_4 = true;
            if (_local_2 == this._bag_Combox1)
            {
                this._bagLockedController.bagLockedInfo.isSelectCustomQuestion1 = _local_3;
                this._bagLockedController.bagLockedInfo.isSelectQuestion1 = _local_4;
            }
            else
            {
                this._bagLockedController.bagLockedInfo.isSelectCustomQuestion2 = _local_3;
                this._bagLockedController.bagLockedInfo.isSelectQuestion2 = _local_4;
            };
        }

        private function __nextBtn2Click(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            if ((!(this._bagLockedController.bagLockedInfo.isSelectQuestion1)))
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.bagII.baglocked.selectQustion"));
                return;
            };
            if ((!(this._bagLockedController.bagLockedInfo.isSelectQuestion2)))
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.bagII.baglocked.selectQustion"));
                return;
            };
            if (StringUtils.trim(this._bag_Combox1.textField.text) == "")
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.bagII.baglocked.inputCompletely"));
                return;
            };
            if (StringUtils.trim(this._bag_Combox2.textField.text) == "")
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.bagII.baglocked.inputCompletely"));
                return;
            };
            if (this._bag_Combox1.textField.text == this._bag_Combox2.textField.text)
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.bagII.baglocked.cantRepeat"));
                return;
            };
            this._bagLockedController.bagLockedInfo.questionOne = this._bag_Combox1.textField.text;
            this._bagLockedController.bagLockedInfo.questionTwo = this._bag_Combox2.textField.text;
            this._bagLockedController.bagLockedInfo.answerOne = this._textinput2_1.text;
            this._bagLockedController.bagLockedInfo.answerTwo = this._textinput2_2.text;
            this._bagLockedController.openSetPassFrame3();
            this._bagLockedController.closeSetPassFrame2();
        }

        private function __textChange(_arg_1:Event):void
        {
            var _local_2:String = this._textinput2_1.text;
            var _local_3:String = this._textinput2_2.text;
            if (((!(StringUtils.trim(_local_2) == "")) && (!(StringUtils.trim(_local_3) == ""))))
            {
                this._nextBtn2.enable = true;
            }
            else
            {
                this._nextBtn2.enable = false;
            };
        }

        private function addEvent():void
        {
            addEventListener(FrameEvent.RESPONSE, this.__frameEventHandler);
            this._textinput2_1.textField.addEventListener(Event.CHANGE, this.__textChange);
            this._textinput2_2.textField.addEventListener(Event.CHANGE, this.__textChange);
            this._textinput2_1.textField.addEventListener(KeyboardEvent.KEY_DOWN, this.__onTextEnter);
            this._textinput2_2.textField.addEventListener(KeyboardEvent.KEY_DOWN, this.__onTextEnter);
            this._backBtn1.addEventListener(MouseEvent.CLICK, this.__backBtn1Click);
            this._nextBtn2.addEventListener(MouseEvent.CLICK, this.__nextBtn2Click);
            this._bag_Combox1.addEventListener(InteractiveEvent.STATE_CHANGED, this.__listItemClick);
            this._bag_Combox2.addEventListener(InteractiveEvent.STATE_CHANGED, this.__listItemClick);
            this._bag_Combox1.addEventListener(MouseEvent.CLICK, this.__ComboxClick);
            this._bag_Combox2.addEventListener(MouseEvent.CLICK, this.__ComboxClick);
        }

        private function __ComboxClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
        }

        private function remvoeEvent():void
        {
            removeEventListener(FrameEvent.RESPONSE, this.__frameEventHandler);
            this._textinput2_1.textField.removeEventListener(Event.CHANGE, this.__textChange);
            this._textinput2_2.textField.removeEventListener(Event.CHANGE, this.__textChange);
            this._textinput2_1.textField.removeEventListener(KeyboardEvent.KEY_DOWN, this.__onTextEnter);
            this._textinput2_2.textField.removeEventListener(KeyboardEvent.KEY_DOWN, this.__onTextEnter);
            this._backBtn1.removeEventListener(MouseEvent.CLICK, this.__backBtn1Click);
            this._nextBtn2.removeEventListener(MouseEvent.CLICK, this.__nextBtn2Click);
            this._bag_Combox1.removeEventListener(Event.CHANGE, this.__listItemClick);
            this._bag_Combox2.removeEventListener(Event.CHANGE, this.__listItemClick);
            this._bag_Combox1.removeEventListener(MouseEvent.CLICK, this.__ComboxClick);
            this._bag_Combox2.removeEventListener(MouseEvent.CLICK, this.__ComboxClick);
        }


    }
}//package baglocked

