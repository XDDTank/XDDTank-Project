// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//store.view.transfer.HoleConfirmAlert

package store.view.transfer
{
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import com.pickgliss.ui.controls.SelectedCheckButton;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.vo.AlertInfo;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.ComponentFactory;
    import flash.events.Event;
    import ddt.manager.SoundManager;
    import com.pickgliss.utils.ObjectUtils;

    public class HoleConfirmAlert extends BaseAlerFrame 
    {

        private var _state1:Boolean;
        private var _state2:Boolean;
        private var _beforeCheck:SelectedCheckButton;
        private var _afterCheck:SelectedCheckButton;
        private var _textField:FilterFrameText;
        private var _noteField:FilterFrameText;

        public function HoleConfirmAlert(_arg_1:int, _arg_2:int)
        {
            var _local_3:AlertInfo = new AlertInfo();
            _local_3.submitLabel = LanguageMgr.GetTranslation("ok");
            _local_3.cancelLabel = LanguageMgr.GetTranslation("cancel");
            _local_3.title = LanguageMgr.GetTranslation("AlertDialog.Info");
            this.info = _local_3;
            this.addEvent();
            if (_arg_1 == -1)
            {
                this._beforeCheck.enable = false;
            }
            else
            {
                this._beforeCheck.selected = ((_arg_1 == 1) ? true : false);
            };
            if (_arg_2 == -1)
            {
                this._afterCheck.enable = false;
            }
            else
            {
                this._afterCheck.selected = ((_arg_2 == 1) ? true : false);
            };
        }

        override protected function init():void
        {
            super.init();
            this._beforeCheck = ComponentFactory.Instance.creatComponentByStylename("ddtstore.HoleConfirmAlert.StrengthenHoleCheckBtn");
            addToContent(this._beforeCheck);
            this._afterCheck = ComponentFactory.Instance.creatComponentByStylename("ddtstore.HoleConfirmAlert.CloseHoleCheckBtn");
            addToContent(this._afterCheck);
            this._textField = ComponentFactory.Instance.creatComponentByStylename("ddtstore.HoleConfirmAlert.TipsText");
            this._textField.text = LanguageMgr.GetTranslation("store.view.transfer.HoleTipsText");
            addToContent(this._textField);
            this._noteField = ComponentFactory.Instance.creatComponentByStylename("ddtstore.HoleConfirmAlert.NoteText");
            this._noteField.text = LanguageMgr.GetTranslation("store.view.transfer.HoleNoteText");
            addToContent(this._noteField);
        }

        private function addEvent():void
        {
            this._beforeCheck.addEventListener(Event.SELECT, this.__selectChanged);
            this._afterCheck.addEventListener(Event.SELECT, this.__selectChanged);
        }

        private function __selectChanged(_arg_1:Event):void
        {
            SoundManager.instance.play("008");
            var _local_2:SelectedCheckButton = (_arg_1.currentTarget as SelectedCheckButton);
            if (_local_2 == this._beforeCheck)
            {
                this._state1 = this._beforeCheck.selected;
            }
            else
            {
                if (_local_2 == this._afterCheck)
                {
                    this._state2 = this._beforeCheck.selected;
                };
            };
        }

        private function removeEvent():void
        {
            this._beforeCheck.removeEventListener(Event.SELECT, this.__selectChanged);
            this._afterCheck.removeEventListener(Event.SELECT, this.__selectChanged);
        }

        public function get state1():Boolean
        {
            return ((this._beforeCheck.enable) && (this._beforeCheck.selected));
        }

        public function get state2():Boolean
        {
            return ((this._afterCheck.enable) && (this._afterCheck.selected));
        }

        override public function dispose():void
        {
            this.removeEvent();
            if (this._beforeCheck)
            {
                ObjectUtils.disposeObject(this._beforeCheck);
                this._beforeCheck = null;
            };
            if (this._afterCheck)
            {
                ObjectUtils.disposeObject(this._afterCheck);
                this._afterCheck = null;
            };
            if (this._textField)
            {
                ObjectUtils.disposeObject(this._textField);
                this._textField = null;
            };
            if (this._noteField)
            {
                ObjectUtils.disposeObject(this._noteField);
            };
            this._noteField = null;
            super.dispose();
        }


    }
}//package store.view.transfer

