// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.ui.controls.TextButton

package com.pickgliss.ui.controls
{
    import com.pickgliss.geom.InnerRectangle;
    import flash.text.TextField;
    import com.pickgliss.utils.ClassUtils;
    import com.pickgliss.ui.ComponentFactory;
    import flash.events.MouseEvent;
    import com.pickgliss.utils.ObjectUtils;
    import flash.geom.Rectangle;
    import com.pickgliss.utils.DisplayUtils;

    public class TextButton extends BaseButton 
    {

        public static const P_backOuterRect:String = "backOuterRect";
        public static const P_text:String = "text";
        public static const P_textField:String = "textField";
        public static const P_overTextField:String = "overTextField";

        protected var _backgoundInnerRect:InnerRectangle = new InnerRectangle(0, 0, 0, 0, -1);
        protected var _backgoundInnerRectString:String;
        protected var _text:String = "";
        protected var _textField:TextField;
        protected var _textStyle:String;
        protected var _overTextStyle:String;


        public function set backgoundInnerRectString(_arg_1:String):void
        {
            if (this._backgoundInnerRectString == _arg_1)
            {
                return;
            };
            this._backgoundInnerRectString = _arg_1;
            this._backgoundInnerRect = ClassUtils.CreatInstance(ClassUtils.INNERRECTANGLE, ComponentFactory.parasArgs(this._backgoundInnerRectString));
            onPropertiesChanged(P_backOuterRect);
        }

        override protected function __onMouseRollover(_arg_1:MouseEvent):void
        {
            if (((_enable) && (!(_arg_1.buttonDown))))
            {
                this.setFrame(2);
                if (overbackStyle == null)
                {
                    return;
                };
                backgound = ComponentFactory.Instance.creat(overbackStyle);
                onPropertiesChanged(P_backStyle);
            };
            if (this.textStyle == null)
            {
                return;
            };
            if (this.overTextStyle == null)
            {
                this.textField = ComponentFactory.Instance.creat(this.textStyle);
            }
            else
            {
                this.textField = ComponentFactory.Instance.creat(this.overTextStyle);
            };
        }

        override protected function __onMouseRollout(_arg_1:MouseEvent):void
        {
            if (((_enable) && (!(_arg_1.buttonDown))))
            {
                this.setFrame(1);
                if (overbackStyle == null)
                {
                    return;
                };
                backgound = ComponentFactory.Instance.creat(backStyle);
                onPropertiesChanged(P_backStyle);
            };
            if (this.textStyle)
            {
                this.textField = ComponentFactory.Instance.creat(this.textStyle);
            };
        }

        override public function dispose():void
        {
            if (this._textField)
            {
                ObjectUtils.disposeObject(this._textField);
            };
            this._textField = null;
            super.dispose();
        }

        public function get text():String
        {
            return (this._text);
        }

        public function set text(_arg_1:String):void
        {
            if (this._text == _arg_1)
            {
                return;
            };
            this._text = _arg_1;
            onPropertiesChanged(P_text);
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

        public function set textStyle(_arg_1:String):void
        {
            if (this._textStyle == _arg_1)
            {
                return;
            };
            this._textStyle = _arg_1;
            this.textField = ComponentFactory.Instance.creat(this._textStyle);
        }

        public function get textStyle():String
        {
            return (this._textStyle);
        }

        public function set overTextStyle(_arg_1:String):void
        {
            if (this._overTextStyle == _arg_1)
            {
                return;
            };
            this._overTextStyle = _arg_1;
        }

        public function get overTextStyle():String
        {
            return (this._overTextStyle);
        }

        override protected function addChildren():void
        {
            super.addChildren();
            if (this._textField)
            {
                addChild(this._textField);
            };
        }

        override protected function onProppertiesUpdate():void
        {
            var _local_1:Rectangle;
            super.onProppertiesUpdate();
            if (this._textField == null)
            {
                return;
            };
            this._textField.text = this._text;
            if (_autoSizeAble)
            {
                _local_1 = this._backgoundInnerRect.getInnerRect(this._textField.textWidth, this._textField.textHeight);
                _width = (_back.width = _local_1.width);
                _height = (_back.height = _local_1.height);
                this._textField.x = this._backgoundInnerRect.para1;
                this._textField.y = this._backgoundInnerRect.para3;
            }
            else
            {
                _back.width = _width;
                _back.height = _height;
                this._textField.x = this._backgoundInnerRect.para1;
                this._textField.y = this._backgoundInnerRect.para3;
            };
        }

        override public function setFrame(_arg_1:int):void
        {
            super.setFrame(_arg_1);
            DisplayUtils.setFrame(this._textField, _arg_1);
        }


    }
}//package com.pickgliss.ui.controls

