// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//petsBag.view.RePetNameFrame

package petsBag.view
{
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import flash.display.DisplayObject;
    import com.pickgliss.ui.vo.AlertInfo;
    import com.pickgliss.ui.text.FilterFrameText;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.ComponentFactory;
    import flash.events.Event;
    import ddt.manager.SoundManager;
    import flash.events.MouseEvent;
    import road7th.utils.StringHelper;
    import ddt.utils.FilterWordManager;
    import com.pickgliss.ui.AlertManager;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.events.FrameEvent;
    import com.pickgliss.toplevel.StageReferance;
    import com.pickgliss.utils.ObjectUtils;

    public class RePetNameFrame extends BaseAlerFrame 
    {

        protected var _inputBackground:DisplayObject;
        private var _alertInfo:AlertInfo;
        private var _inputText:FilterFrameText;
        private var _inputLbl:FilterFrameText;
        private var _petName:String = "";

        public function RePetNameFrame()
        {
            this.initView();
            this.initEvent();
        }

        public function get petName():String
        {
            return (this._petName);
        }

        private function initView():void
        {
            this._alertInfo = new AlertInfo(LanguageMgr.GetTranslation("ddt.pets.rePetNameTitle"), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"));
            this._alertInfo.moveEnable = false;
            info = this._alertInfo;
            this.escEnable = true;
            this._inputBackground = ComponentFactory.Instance.creat("petsBag.repetName.inputBG");
            this._inputText = ComponentFactory.Instance.creat("petsBag.text.inputPetName");
            addToContent(this._inputBackground);
            addToContent(this._inputText);
            this._inputLbl = ComponentFactory.Instance.creat("petsBag.text.inputPetNameLbl");
            this._inputLbl.text = LanguageMgr.GetTranslation("ddt.pets.reInputPetName");
            addToContent(this._inputLbl);
        }

        private function initEvent():void
        {
            this._inputText.addEventListener(Event.CHANGE, this.__inputChange);
        }

        private function removeEvent():void
        {
            this._inputText.removeEventListener(Event.CHANGE, this.__inputChange);
        }

        override protected function __onSubmitClick(_arg_1:MouseEvent):void
        {
            _arg_1.stopImmediatePropagation();
            SoundManager.instance.play("008");
            if (this.nameInputCheck())
            {
                this._petName = this._inputText.text;
            }
            else
            {
                return;
            };
            super.__onSubmitClick(_arg_1);
        }

        private function __inputChange(_arg_1:Event):void
        {
            StringHelper.checkTextFieldLength(this._inputText, 10);
        }

        private function getStrActualLen(_arg_1:String):int
        {
            return (_arg_1.replace(/[^\x00-\xff]/g, "xx").length);
        }

        private function nameInputCheck():Boolean
        {
            var _local_1:BaseAlerFrame;
            if (this._inputText.text != "")
            {
                if (FilterWordManager.isGotForbiddenWords(this._inputText.text, "name"))
                {
                    _local_1 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("choosecharacter.ChooseCharacterView.name"), LanguageMgr.GetTranslation("ok"), "", false, false, false, LayerManager.ALPHA_BLOCKGOUND);
                    _local_1.addEventListener(FrameEvent.RESPONSE, this.__onAlertResponse);
                    return (false);
                };
                if (FilterWordManager.IsNullorEmpty(this._inputText.text))
                {
                    _local_1 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("choosecharacter.ChooseCharacterView.space"), LanguageMgr.GetTranslation("ok"), "", false, false, false, LayerManager.ALPHA_BLOCKGOUND);
                    _local_1.addEventListener(FrameEvent.RESPONSE, this.__onAlertResponse);
                    return (false);
                };
                if (FilterWordManager.containUnableChar(this._inputText.text))
                {
                    _local_1 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("choosecharacter.ChooseCharacterView.string"), LanguageMgr.GetTranslation("ok"), "", false, false, false, LayerManager.ALPHA_BLOCKGOUND);
                    _local_1.addEventListener(FrameEvent.RESPONSE, this.__onAlertResponse);
                    return (false);
                };
                return (true);
            };
            _local_1 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("choosecharacter.ChooseCharacterView.input"), LanguageMgr.GetTranslation("ok"), "", false, false, false, LayerManager.ALPHA_BLOCKGOUND);
            _local_1.addEventListener(FrameEvent.RESPONSE, this.__onAlertResponse);
            return (false);
        }

        protected function __onAlertResponse(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            var _local_2:BaseAlerFrame = (_arg_1.currentTarget as BaseAlerFrame);
            _local_2.removeEventListener(FrameEvent.RESPONSE, this.__onAlertResponse);
            switch (_arg_1.responseCode)
            {
                case FrameEvent.ESC_CLICK:
                case FrameEvent.ENTER_CLICK:
                case FrameEvent.SUBMIT_CLICK:
                case FrameEvent.CANCEL_CLICK:
                case FrameEvent.CLOSE_CLICK:
                    _local_2.dispose();
                    break;
            };
            StageReferance.stage.focus = this._inputText;
        }

        public function show():void
        {
            LayerManager.Instance.addToLayer(this, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
        }

        override public function dispose():void
        {
            this.removeEvent();
            ObjectUtils.disposeObject(this._inputLbl);
            this._inputLbl = null;
            if (this._inputText)
            {
                ObjectUtils.disposeObject(this._inputText);
                this._inputText = null;
            };
            if (this._inputBackground)
            {
                ObjectUtils.disposeObject(this._inputBackground);
                this._inputBackground = null;
            };
            ObjectUtils.disposeAllChildren(this);
            this._petName = "";
            super.dispose();
        }


    }
}//package petsBag.view

