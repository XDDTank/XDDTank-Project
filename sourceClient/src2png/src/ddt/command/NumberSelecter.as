// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.command.NumberSelecter

package ddt.command
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.controls.BaseButton;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.ui.image.Image;
    import flash.events.MouseEvent;
    import flash.events.KeyboardEvent;
    import flash.events.Event;
    import ddt.manager.SoundManager;
    import flash.ui.Keyboard;
    import com.pickgliss.utils.ObjectUtils;

    public class NumberSelecter extends Sprite implements Disposeable 
    {

        public static const NUMBER_CLOSE:String = "number_close";
        public static const NUMBER_ENTER:String = "number_enter";

        private var _minNum:int;
        private var _maxNum:int;
        private var _num:int;
        private var _reduceBtn:BaseButton;
        private var _addBtn:BaseButton;
        private var numText:FilterFrameText;

        public function NumberSelecter(_arg_1:int=1, _arg_2:int=999)
        {
            this._minNum = _arg_1;
            this._maxNum = _arg_2;
            this.init();
            this.initEvents();
        }

        private function init():void
        {
            var _local_1:Image = ComponentFactory.Instance.creatComponentByStylename("ddtcore.NumberSelecterTextBg");
            addChild(_local_1);
            this._reduceBtn = ComponentFactory.Instance.creatComponentByStylename("ddtcore.NumberSelecterDownButton");
            addChild(this._reduceBtn);
            this._addBtn = ComponentFactory.Instance.creatComponentByStylename("ddtcore.NumberSelecterUpButton");
            addChild(this._addBtn);
            this.numText = ComponentFactory.Instance.creatComponentByStylename("ddtcore.NumberSelecterText");
            addChild(this.numText);
            this._num = 1;
            this.updateView();
        }

        private function initEvents():void
        {
            this._reduceBtn.addEventListener(MouseEvent.CLICK, this.reduceBtnClickHandler);
            this._addBtn.addEventListener(MouseEvent.CLICK, this.addBtnClickHandler);
            this.numText.addEventListener(MouseEvent.CLICK, this.clickHandler);
            this.numText.addEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDown);
            this.numText.addEventListener(Event.CHANGE, this.changeHandler);
            addEventListener(Event.ADDED_TO_STAGE, this.addtoStageHandler);
        }

        private function removeEvents():void
        {
            this._reduceBtn.removeEventListener(MouseEvent.CLICK, this.reduceBtnClickHandler);
            this._addBtn.removeEventListener(MouseEvent.CLICK, this.addBtnClickHandler);
            this.numText.removeEventListener(MouseEvent.CLICK, this.clickHandler);
            this.numText.removeEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDown);
            this.numText.removeEventListener(Event.CHANGE, this.changeHandler);
            removeEventListener(Event.ADDED_TO_STAGE, this.addtoStageHandler);
        }

        private function addtoStageHandler(_arg_1:Event):void
        {
            this.setFocus();
        }

        private function clickHandler(_arg_1:MouseEvent):void
        {
            _arg_1.stopImmediatePropagation();
        }

        private function changeHandler(_arg_1:Event):void
        {
            this.number = int(this.numText.text);
        }

        private function onKeyDown(_arg_1:KeyboardEvent):void
        {
            SoundManager.instance.play("008");
            _arg_1.stopImmediatePropagation();
            if (_arg_1.keyCode == Keyboard.ENTER)
            {
                this.number = int(this.numText.text);
                dispatchEvent(new Event(NUMBER_ENTER, true));
            };
            if (_arg_1.keyCode == Keyboard.ESCAPE)
            {
                dispatchEvent(new Event(NUMBER_CLOSE));
            };
        }

        private function reduceBtnClickHandler(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            this.number = (this.number - 1);
        }

        private function addBtnClickHandler(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            this.number = (this.number + 1);
        }

        public function setFocus():void
        {
            if (stage.focus != this.numText)
            {
                this.numText.text = "";
                this.numText.appendText(String(this._num));
                stage.focus = this.numText;
            };
        }

        public function set maximum(_arg_1:int):void
        {
            this._maxNum = _arg_1;
            this.number = this._num;
        }

        public function set minimum(_arg_1:int):void
        {
            this._minNum = _arg_1;
            this.number = this._num;
        }

        public function set number(_arg_1:int):void
        {
            if (_arg_1 < this._minNum)
            {
                _arg_1 = this._minNum;
            }
            else
            {
                if (_arg_1 > this._maxNum)
                {
                    _arg_1 = this._maxNum;
                };
            };
            this._num = _arg_1;
            this.updateView();
            dispatchEvent(new Event(Event.CHANGE));
        }

        public function get number():int
        {
            return (this._num);
        }

        private function updateView():void
        {
            this.numText.text = this._num.toString();
            this._reduceBtn.enable = (this._num > this._minNum);
            this._addBtn.enable = (this._num < this._maxNum);
        }

        public function dispose():void
        {
            this.removeEvents();
            if (this._reduceBtn)
            {
                ObjectUtils.disposeObject(this._reduceBtn);
            };
            this._reduceBtn = null;
            if (this._addBtn)
            {
                ObjectUtils.disposeObject(this._addBtn);
            };
            this._addBtn = null;
            if (this.numText)
            {
                ObjectUtils.disposeObject(this.numText);
            };
            this.numText = null;
            ObjectUtils.disposeAllChildren(this);
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package ddt.command

