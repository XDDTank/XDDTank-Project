// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.ui.controls.alert.SimpleAlert

package com.pickgliss.ui.controls.alert
{
    import flash.text.TextField;
    import com.pickgliss.geom.InnerRectangle;
    import com.pickgliss.utils.ObjectUtils;
    import com.pickgliss.utils.ClassUtils;
    import com.pickgliss.ui.ComponentFactory;
    import flash.geom.Rectangle;
    import com.pickgliss.ui.core.Component;
    import flash.text.TextFieldAutoSize;
    import com.pickgliss.utils.DisplayUtils;

    public class SimpleAlert extends BaseAlerFrame 
    {

        public static const P_frameInnerRect:String = "frameInnerRect";
        public static const P_frameMiniH:String = "frameMiniH";
        public static const P_frameMiniW:String = "frameMiniW";
        public static const P_textField:String = "textFieldStyle";

        protected var _frameMiniH:int = -2147483648;
        protected var _frameMiniW:int = -2147483648;
        protected var _textField:TextField;
        protected var _textFieldStyle:String;
        private var _frameInnerRect:InnerRectangle;
        private var _frameInnerRectString:String;


        override public function dispose():void
        {
            if (this._textField)
            {
                ObjectUtils.disposeObject(this._textField);
            };
            this._textField = null;
            this._frameInnerRect = null;
            super.dispose();
        }

        public function set frameInnerRectString(_arg_1:String):void
        {
            if (this._frameInnerRectString == _arg_1)
            {
                return;
            };
            this._frameInnerRectString = _arg_1;
            this._frameInnerRect = ClassUtils.CreatInstance(ClassUtils.INNERRECTANGLE, ComponentFactory.parasArgs(this._frameInnerRectString));
            onPropertiesChanged(P_frameInnerRect);
        }

        public function set frameMiniH(_arg_1:int):void
        {
            if (this._frameMiniH == _arg_1)
            {
                return;
            };
            this._frameMiniH = _arg_1;
            onPropertiesChanged(P_frameMiniH);
        }

        public function set frameMiniW(_arg_1:int):void
        {
            if (this._frameMiniW == _arg_1)
            {
                return;
            };
            this._frameMiniW = _arg_1;
            onPropertiesChanged(P_frameMiniW);
        }

        public function set textStyle(_arg_1:String):void
        {
            if (this._textFieldStyle == _arg_1)
            {
                return;
            };
            if (this._textField)
            {
                ObjectUtils.disposeObject(this._textField);
            };
            this._textFieldStyle = _arg_1;
            this._textField = ComponentFactory.Instance.creat(this._textFieldStyle);
            onPropertiesChanged(P_textField);
        }

        override protected function addChildren():void
        {
            super.addChildren();
            if (this._textField)
            {
                addChild(this._textField);
            };
        }

        protected function layoutFrameRect():void
        {
            var _local_1:Rectangle;
            _local_1 = this._frameInnerRect.getInnerRect(this._textField.width, this._textField.height);
            if (_local_1.width > this._frameMiniW)
            {
                this._textField.x = this._frameInnerRect.para1;
                _width = _local_1.width;
            }
            else
            {
                this._textField.x = (this._frameInnerRect.para1 + ((this._frameMiniW - _local_1.width) / 2));
                _width = this._frameMiniW;
            };
            if (_local_1.height > this._frameMiniH)
            {
                this._textField.y = this._frameInnerRect.para3;
                _height = _local_1.height;
            }
            else
            {
                this._textField.y = (this._frameInnerRect.para3 + ((this._frameMiniH - _local_1.height) / 2));
                _height = this._frameMiniH;
            };
        }

        override protected function onProppertiesUpdate():void
        {
            if (_changedPropeties[P_info])
            {
                this.updateMsg();
                if (this._frameInnerRect)
                {
                    this.layoutFrameRect();
                    _changedPropeties[Component.P_width] = true;
                    _changedPropeties[Component.P_height] = true;
                };
            };
            super.onProppertiesUpdate();
        }

        protected function updateMsg():void
        {
            this._textField.autoSize = TextFieldAutoSize.LEFT;
            if (_info.mutiline)
            {
                this._textField.multiline = true;
                if ((!(info.enableHtml)))
                {
                    this._textField.wordWrap = true;
                };
                if (_info.textShowWidth > 0)
                {
                    this._textField.width = _info.textShowWidth;
                }
                else
                {
                    this._textField.width = DisplayUtils.getTextFieldMaxLineWidth(String(_info.data), this._textField.defaultTextFormat, info.enableHtml);
                };
            };
            if (_info.enableHtml)
            {
                this._textField.htmlText = String(_info.data);
            }
            else
            {
                this._textField.text = String(_info.data);
            };
        }


    }
}//package com.pickgliss.ui.controls.alert

