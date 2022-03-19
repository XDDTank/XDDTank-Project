// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.NameInputDropListTarget

package ddt.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.controls.list.IDropListTarget;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.image.Image;
    import com.pickgliss.ui.controls.TextInput;
    import com.pickgliss.ui.controls.BaseButton;
    import flash.display.Bitmap;
    import com.pickgliss.ui.ComponentFactory;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import flash.events.FocusEvent;
    import flash.display.DisplayObject;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.manager.SoundManager;
    import road7th.utils.StringHelper;

    public class NameInputDropListTarget extends Sprite implements IDropListTarget, Disposeable 
    {

        public static const LOOK:int = 1;
        public static const CLOSE:int = 2;
        public static const CLOSE_CLICK:String = "closeClick";
        public static const CLEAR_CLICK:String = "clearClick";
        public static const LOOK_CLICK:String = "lookClick";

        private var _background:Image;
        private var _nameInput:TextInput;
        private var _closeBtn:BaseButton;
        private var _lookBtn:Bitmap;
        private var _isListening:Boolean;

        public function NameInputDropListTarget()
        {
            this.initView();
            this.initEvent();
        }

        private function initView():void
        {
            this._background = ComponentFactory.Instance.creatComponentByStylename("core.nameInputDropListTarget.InputTextBg");
            this._nameInput = ComponentFactory.Instance.creatComponentByStylename("core.nameInputDropListTarget.NameInput");
            this._closeBtn = ComponentFactory.Instance.creatComponentByStylename("core.nameInputDropListTarget.Close");
            this._lookBtn = ComponentFactory.Instance.creatBitmap("asset.core.searchIcon");
            addChild(this._background);
            addChild(this._nameInput);
            addChild(this._closeBtn);
            addChild(this._lookBtn);
            this.switchView(LOOK);
        }

        public function set text(_arg_1:String):void
        {
            this._nameInput.text = _arg_1;
        }

        public function get text():String
        {
            return (this._nameInput.text);
        }

        public function switchView(_arg_1:int):void
        {
            switch (_arg_1)
            {
                case LOOK:
                    this._lookBtn.visible = true;
                    this._closeBtn.visible = false;
                    return;
                case CLOSE:
                    this._lookBtn.visible = false;
                    this._closeBtn.visible = true;
                    return;
            };
        }

        private function initEvent():void
        {
            this._closeBtn.addEventListener(MouseEvent.CLICK, this.__closeHandler);
            this._nameInput.addEventListener(Event.CHANGE, this.__changeDropList);
            this._nameInput.addEventListener(FocusEvent.FOCUS_IN, this._focusHandler);
        }

        private function removeEvent():void
        {
            this._closeBtn.removeEventListener(MouseEvent.CLICK, this.__closeHandler);
            this._nameInput.removeEventListener(Event.CHANGE, this.__changeDropList);
            this._nameInput.removeEventListener(FocusEvent.FOCUS_IN, this._focusHandler);
        }

        public function setCursor(_arg_1:int):void
        {
            this._nameInput.textField.setSelection(_arg_1, _arg_1);
        }

        public function get caretIndex():int
        {
            return (this._nameInput.textField.caretIndex);
        }

        public function setValue(_arg_1:*):void
        {
            if (_arg_1)
            {
                this._nameInput.text = _arg_1.NickName;
            };
        }

        public function getValueLength():int
        {
            if (this._nameInput)
            {
                return (this._nameInput.text.length);
            };
            return (0);
        }

        public function asDisplayObject():DisplayObject
        {
            return (this);
        }

        public function dispose():void
        {
            this.removeEvent();
            ObjectUtils.disposeObject(this._background);
            this._background = null;
            if (this._nameInput)
            {
                ObjectUtils.disposeObject(this._nameInput);
            };
            this._nameInput = null;
            if (this._closeBtn)
            {
                ObjectUtils.disposeObject(this._closeBtn);
            };
            this._closeBtn = null;
            if (this._lookBtn)
            {
                ObjectUtils.disposeObject(this._lookBtn);
            };
            this._lookBtn = null;
            if (this.parent)
            {
                this.parent.removeChild(this);
            };
        }

        protected function __clearhandler(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            dispatchEvent(new Event(CLEAR_CLICK));
        }

        protected function __closeHandler(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            this._nameInput.text = "";
            this.switchView(LOOK);
            dispatchEvent(new Event(CLOSE_CLICK));
        }

        protected function __changeDropList(_arg_1:Event):void
        {
            StringHelper.checkTextFieldLength(this._nameInput.textField, 14);
            if (this._nameInput.text == "")
            {
                this.switchView(LOOK);
            }
            else
            {
                this.switchView(CLOSE);
            };
            dispatchEvent(new Event(Event.CHANGE));
        }

        protected function _focusHandler(_arg_1:FocusEvent):void
        {
            this.__changeDropList(null);
        }


    }
}//package ddt.view

