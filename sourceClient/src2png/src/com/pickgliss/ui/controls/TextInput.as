// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.ui.controls.TextInput

package com.pickgliss.ui.controls
{
    import com.pickgliss.ui.core.Component;
    import flash.display.DisplayObject;
    import com.pickgliss.geom.InnerRectangle;
    import flash.text.TextField;
    import com.pickgliss.utils.ObjectUtils;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.utils.DisplayUtils;
    import flash.events.FocusEvent;
    import com.pickgliss.utils.ClassUtils;
    import flash.events.Event;
    import com.pickgliss.toplevel.StageReferance;
    import flash.geom.Rectangle;
    import flash.text.TextFieldType;

    public class TextInput extends Component 
    {

        public static const P_back:String = "back";
        public static const P_focusBack:String = "focusBack";
        public static const P_focusBackgoundInnerRect:String = "focusBackOuterRect";
        public static const P_textField:String = "textField";
        public static const P_textInnerRect:String = "textInnerRect";
        public static const P_backgroundColor:String = "backgroundColor";
        public static const P_enable:String = "enable";

        protected var _back:DisplayObject;
        protected var _backStyle:String;
        protected var _focusBack:DisplayObject;
        protected var _focusBackgoundInnerRect:InnerRectangle;
        protected var _focusBackgoundInnerRectString:String;
        protected var _focusBackStyle:String;
        protected var _textField:TextField;
        protected var _textInnerRect:InnerRectangle;
        protected var _textInnerRectString:String;
        protected var _textStyle:String;
        protected var _backgroundColor:uint;
        protected var _filterString:String;
        protected var _frameFilter:Array;
        protected var _enable:Boolean = true;
        protected var _currentFrameIndex:int = 1;


        public function set back(_arg_1:DisplayObject):void
        {
            if (this._back == _arg_1)
            {
                return;
            };
            ObjectUtils.disposeObject(this._back);
            this._back = _arg_1;
            onPropertiesChanged(P_back);
        }

        public function set backStyle(_arg_1:String):void
        {
            if (this._backStyle == _arg_1)
            {
                return;
            };
            this._backStyle = _arg_1;
            this.back = ComponentFactory.Instance.creat(this._backStyle);
        }

        public function set backgroundColor(_arg_1:uint):void
        {
            if (((this._back) || (!(_arg_1))))
            {
                return;
            };
            this._backgroundColor = _arg_1;
            onPropertiesChanged(P_backgroundColor);
        }

        public function get backgroundColor():uint
        {
            return (this._backgroundColor);
        }

        public function set filterString(_arg_1:String):void
        {
            if (this._filterString == _arg_1)
            {
                return;
            };
            this._filterString = _arg_1;
            this._frameFilter = ComponentFactory.Instance.creatFrameFilters(this._filterString);
        }

        public function get enable():Boolean
        {
            return (this._enable);
        }

        public function set enable(_arg_1:Boolean):void
        {
            if (this._enable == _arg_1)
            {
                return;
            };
            this._enable = _arg_1;
            onPropertiesChanged(P_enable);
        }

        protected function setFrame(_arg_1:int):void
        {
            this._currentFrameIndex = _arg_1;
            DisplayUtils.setFrame(this._back, this._currentFrameIndex);
            if ((((this._frameFilter == null) || (_arg_1 <= 0)) || (_arg_1 > this._frameFilter.length)))
            {
                return;
            };
            filters = this._frameFilter[(_arg_1 - 1)];
        }

        override public function dispose():void
        {
            ObjectUtils.disposeObject(this._back);
            this._back = null;
            ObjectUtils.disposeObject(this._focusBack);
            this._focusBack = null;
            if (this._textField)
            {
                this._textField.removeEventListener(FocusEvent.FOCUS_IN, this.__onFocusText);
                this._textField.removeEventListener(FocusEvent.FOCUS_OUT, this.__onFocusText);
            };
            ObjectUtils.disposeObject(this._textField);
            this._textField = null;
            graphics.clear();
            super.dispose();
        }

        public function set focusBack(_arg_1:DisplayObject):void
        {
            if (this._focusBack == _arg_1)
            {
                return;
            };
            ObjectUtils.disposeObject(this._focusBack);
            this._focusBack = _arg_1;
            this._focusBack.visible = false;
            onPropertiesChanged();
        }

        public function set focusBackgoundInnerRectString(_arg_1:String):void
        {
            if (this._focusBackgoundInnerRectString == _arg_1)
            {
                return;
            };
            this._focusBackgoundInnerRectString = _arg_1;
            this._focusBackgoundInnerRect = ClassUtils.CreatInstance(ClassUtils.INNERRECTANGLE, ComponentFactory.parasArgs(this._focusBackgoundInnerRectString));
            onPropertiesChanged(P_focusBackgoundInnerRect);
        }

        public function set focusBackStyle(_arg_1:String):void
        {
            if (this._focusBackStyle == _arg_1)
            {
                return;
            };
            this._focusBackStyle = _arg_1;
            this.focusBack = ComponentFactory.Instance.creat(this._focusBackStyle);
        }

        public function get textField():TextField
        {
            return (this._textField);
        }

        public function set textField(_arg_1:TextField):void
        {
            if (this._textField == _arg_1)
            {
                return;
            };
            ObjectUtils.disposeObject(this._textField);
            this._textField = _arg_1;
            onPropertiesChanged(P_textField);
        }

        public function set textInnerRectString(_arg_1:String):void
        {
            if (this._textInnerRectString == _arg_1)
            {
                return;
            };
            this._textInnerRectString = _arg_1;
            this._textInnerRect = ClassUtils.CreatInstance(ClassUtils.INNERRECTANGLE, ComponentFactory.parasArgs(this._textInnerRectString));
            onPropertiesChanged(P_textInnerRect);
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

        protected function __onFocusText(_arg_1:Event):void
        {
            if (this._focusBack)
            {
                this._focusBack.visible = (_arg_1.type == FocusEvent.FOCUS_IN);
            };
        }

        override protected function addChildren():void
        {
            super.addChildren();
            if (this._back)
            {
                addChild(this._back);
            };
            if (this._focusBack)
            {
                addChild(this._focusBack);
            };
            if (this._textField)
            {
                addChild(this._textField);
            };
        }

        public function set displayAsPassword(_arg_1:Boolean):void
        {
            this._textField.displayAsPassword = _arg_1;
        }

        public function get displayAsPassword():Boolean
        {
            return (this._textField.displayAsPassword);
        }

        public function set multiline(_arg_1:Boolean):void
        {
            this._textField.multiline = _arg_1;
        }

        public function get multiline():Boolean
        {
            return (this._textField.multiline);
        }

        public function set maxChars(_arg_1:int):void
        {
            this._textField.maxChars = _arg_1;
        }

        public function get maxChars():int
        {
            return (this._textField.maxChars);
        }

        public function set autoSize(_arg_1:String):void
        {
            this._textField.autoSize = _arg_1;
        }

        public function get autoSize():String
        {
            return (this._textField.autoSize);
        }

        public function set text(_arg_1:String):void
        {
            this._textField.text = _arg_1;
        }

        public function get text():String
        {
            return (this._textField.text);
        }

        public function setFocus():void
        {
            StageReferance.stage.focus = this._textField;
        }

        override protected function onProppertiesUpdate():void
        {
            var _local_1:Rectangle;
            super.onProppertiesUpdate();
            if (_changedPropeties[P_textField])
            {
                this._textField.type = TextFieldType.INPUT;
                this._textField.wordWrap = true;
                this._textField.addEventListener(FocusEvent.FOCUS_IN, this.__onFocusText);
                this._textField.addEventListener(FocusEvent.FOCUS_OUT, this.__onFocusText);
            };
            if (this._back)
            {
                this._back.width = _width;
                this._back.height = _height;
                _local_1 = this._textInnerRect.getInnerRect(_width, _height);
                this._textField.width = _local_1.width;
                this._textField.height = _local_1.height;
                this._textField.x = _local_1.x;
                this._textField.y = _local_1.y;
                if (this._focusBack)
                {
                    DisplayUtils.layoutDisplayWithInnerRect(this._focusBack, this._focusBackgoundInnerRect, _width, _height);
                };
            }
            else
            {
                this._textField.width = _width;
                this._textField.height = _height;
            };
            if (_changedPropeties[P_backgroundColor])
            {
                graphics.beginFill(this._backgroundColor);
                graphics.drawRect(0, 0, _width, _height);
                graphics.endFill();
            };
            if (_changedPropeties[P_enable])
            {
                mouseChildren = (mouseEnabled = this._enable);
                if (this._enable)
                {
                    this.setFrame(1);
                }
                else
                {
                    this.setFrame(2);
                };
            };
        }


    }
}//package com.pickgliss.ui.controls

