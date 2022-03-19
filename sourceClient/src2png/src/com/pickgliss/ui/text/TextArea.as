// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.ui.text.TextArea

package com.pickgliss.ui.text
{
    import com.pickgliss.ui.controls.ScrollPanel;
    import flash.events.MouseEvent;
    import flash.ui.Mouse;
    import flash.ui.MouseCursor;
    import flash.events.KeyboardEvent;
    import flash.events.Event;
    import com.pickgliss.utils.ObjectUtils;
    import flash.text.TextFieldType;
    import com.pickgliss.ui.controls.DisplayObjectViewport;
    import com.pickgliss.ui.ComponentFactory;
    import flash.geom.Rectangle;
    import flash.ui.Keyboard;
    import com.pickgliss.geom.IntPoint;
    import com.pickgliss.utils.DisplayUtils;

    public class TextArea extends ScrollPanel 
    {

        public static const P_textField:String = "textField";

        protected var _currentTextHeight:int = 0;
        protected var _enable:Boolean = true;
        protected var _textField:FilterFrameText;
        protected var _textStyle:String;

        public function TextArea()
        {
            _viewSource.addEventListener(MouseEvent.CLICK, this.__onTextAreaClick);
            _viewSource.addEventListener(MouseEvent.MOUSE_OVER, this.__onTextAreaOver);
            _viewSource.addEventListener(MouseEvent.MOUSE_OUT, this.__onTextAreaOut);
        }

        override public function dispose():void
        {
            Mouse.cursor = MouseCursor.AUTO;
            _viewSource.removeEventListener(MouseEvent.CLICK, this.__onTextAreaClick);
            _viewSource.removeEventListener(MouseEvent.MOUSE_OVER, this.__onTextAreaOver);
            _viewSource.removeEventListener(MouseEvent.MOUSE_OUT, this.__onTextAreaOut);
            this._textField.removeEventListener(KeyboardEvent.KEY_DOWN, this.__onTextKeyDown);
            this._textField.removeEventListener(Event.CHANGE, this.__onTextChanged);
            ObjectUtils.disposeObject(this._textField);
            this._textField = null;
            super.dispose();
        }

        public function get editable():Boolean
        {
            return (this._textField.type == TextFieldType.INPUT);
        }

        public function set editable(_arg_1:Boolean):void
        {
            if (_arg_1)
            {
                this._textField.type = TextFieldType.INPUT;
                _viewSource.addEventListener(MouseEvent.MOUSE_OVER, this.__onTextAreaOver);
                _viewSource.addEventListener(MouseEvent.MOUSE_OUT, this.__onTextAreaOut);
            }
            else
            {
                this._textField.type = TextFieldType.DYNAMIC;
                _viewSource.removeEventListener(MouseEvent.MOUSE_OVER, this.__onTextAreaOver);
                _viewSource.removeEventListener(MouseEvent.MOUSE_OUT, this.__onTextAreaOut);
            };
        }

        public function get enable():Boolean
        {
            return (this._enable);
        }

        public function set enable(_arg_1:Boolean):void
        {
            this._textField.mouseEnabled = this._enable;
            if (this._enable)
            {
                _viewSource.addEventListener(MouseEvent.MOUSE_OVER, this.__onTextAreaOver);
                _viewSource.addEventListener(MouseEvent.MOUSE_OUT, this.__onTextAreaOut);
            }
            else
            {
                _viewSource.removeEventListener(MouseEvent.MOUSE_OVER, this.__onTextAreaOver);
                _viewSource.removeEventListener(MouseEvent.MOUSE_OUT, this.__onTextAreaOut);
            };
        }

        public function get maxChars():int
        {
            return (this._textField.maxChars);
        }

        public function set maxChars(_arg_1:int):void
        {
            this._textField.maxChars = _arg_1;
        }

        public function get text():String
        {
            return (this._textField.text);
        }

        public function set text(_arg_1:String):void
        {
            this._textField.text = _arg_1;
            DisplayObjectViewport(_viewSource).invalidateView();
        }

        public function set htmlText(_arg_1:String):void
        {
            this._textField.htmlText = _arg_1;
            DisplayObjectViewport(_viewSource).invalidateView();
        }

        public function get htmlText():String
        {
            return (this._textField.htmlText);
        }

        public function get textField():FilterFrameText
        {
            return (this._textField);
        }

        public function set textField(_arg_1:FilterFrameText):void
        {
            if (this._textField == _arg_1)
            {
                return;
            };
            if (this._textField)
            {
                this._textField.removeEventListener(Event.CHANGE, this.__onTextChanged);
                this._textField.removeEventListener(KeyboardEvent.KEY_DOWN, this.__onTextKeyDown);
                ObjectUtils.disposeObject(this._textField);
            };
            this._textField = _arg_1;
            this._textField.multiline = true;
            this._textField.mouseWheelEnabled = false;
            this._textField.addEventListener(KeyboardEvent.KEY_DOWN, this.__onTextKeyDown);
            this._textField.addEventListener(Event.CHANGE, this.__onTextChanged);
            onPropertiesChanged(P_textField);
        }

        public function set textStyle(_arg_1:String):void
        {
            if (this._textStyle == _arg_1)
            {
                return;
            };
            this._textStyle = _arg_1;
            this.textField = ComponentFactory.Instance.creat(this._textStyle);
        }

        override protected function layoutComponent():void
        {
            var _local_1:Rectangle;
            super.layoutComponent();
            _local_1 = _viewportInnerRect.getInnerRect(_width, _height);
            this._textField.x = _local_1.x;
            this._textField.y = _local_1.y;
            this._textField.width = _viewSource.width;
        }

        override protected function onProppertiesUpdate():void
        {
            super.onProppertiesUpdate();
            if (_changedPropeties[P_textField])
            {
                DisplayObjectViewport(_viewSource).setView(this._textField);
            };
        }

        private function __onTextAreaClick(_arg_1:MouseEvent):void
        {
            this._textField.setFocus();
        }

        private function __onTextAreaOut(_arg_1:MouseEvent):void
        {
            Mouse.cursor = MouseCursor.AUTO;
        }

        private function __onTextAreaOver(_arg_1:MouseEvent):void
        {
            Mouse.cursor = MouseCursor.IBEAM;
        }

        private function __onTextChanged(_arg_1:Event):void
        {
            this.upScrollArea();
        }

        private function __onTextKeyDown(_arg_1:KeyboardEvent):void
        {
            if (_arg_1.keyCode == Keyboard.ENTER)
            {
                _arg_1.stopPropagation();
            }
            else
            {
                if (_arg_1.keyCode == Keyboard.UP)
                {
                    this.upScrollArea();
                }
                else
                {
                    if (_arg_1.keyCode == Keyboard.DOWN)
                    {
                        this.upScrollArea();
                    }
                    else
                    {
                        if (_arg_1.keyCode == Keyboard.DELETE)
                        {
                            this.upScrollArea();
                        };
                    };
                };
            };
        }

        public function upScrollArea():void
        {
            var _local_1:Number;
            var _local_2:IntPoint;
            var _local_3:Number;
            var _local_4:Number;
            var _local_5:Number;
            var _local_6:Number;
            var _local_7:Number;
            var _local_8:Number;
            DisplayObjectViewport(_viewSource).invalidateView();
            if (this._textField.caretIndex <= 0)
            {
                viewPort.viewPosition = new IntPoint(0, 0);
            }
            else
            {
                _local_1 = DisplayUtils.getTextFieldLineHeight(this._textField);
                _local_2 = viewPort.viewPosition;
                _local_3 = DisplayUtils.getTextFieldCareLinePosX(this._textField);
                _local_4 = DisplayUtils.getTextFieldCareLinePosY(this._textField);
                _local_5 = (_local_3 - _local_2.x);
                _local_6 = ((_local_4 + _local_1) - _local_2.y);
                DisplayObjectViewport(_viewSource).invalidateView();
                _local_7 = _local_2.x;
                _local_8 = _local_2.y;
                if (_local_5 < 0)
                {
                    _local_7 = _local_3;
                }
                else
                {
                    if (_local_5 > viewPort.getExtentSize().width)
                    {
                        _local_7 = (_local_3 + viewPort.getExtentSize().width);
                    };
                };
                if (_local_6 < _local_1)
                {
                    _local_8 = _local_4;
                }
                else
                {
                    if (_local_6 > viewPort.getExtentSize().height)
                    {
                        _local_8 = (_local_4 + viewPort.getExtentSize().height);
                    };
                };
                if (((_local_7 > 0) || (_local_8 > 0)))
                {
                    viewPort.viewPosition = new IntPoint(_local_7, _local_8);
                };
            };
        }


    }
}//package com.pickgliss.ui.text

