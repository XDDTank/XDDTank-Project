// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.ui.text.GradientText

package com.pickgliss.ui.text
{
    import com.pickgliss.ui.core.Component;
    import flash.geom.Matrix;
    import flash.display.Shape;
    import flash.text.TextField;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.utils.ObjectUtils;
    import flash.text.TextFormat;
    import flash.display.GradientType;

    public class GradientText extends Component 
    {

        public static const P_alpha:String = "alpha";
        public static const P_color:String = "color";
        public static const P_frameFilters:String = "frameFilters";
        public static const P_ratio:String = "ratio";
        public static const P_textField:String = "textField";
        public static const P_size:String = "textSize";

        protected var _filterString:String;
        protected var _frameFilter:Array;
        private var _colorStyle:String = "";
        private var _alphaStyle:String = "";
        private var _ratioStyle:String = "";
        private var _colors:Array;
        private var _alphas:Array;
        private var _ratios:Array;
        private var _gradientRotation:Number = 90;
        private var _currentFrame:int = 1;
        private var _currentMatrix:Matrix;
        private var _gradientBox:Shape;
        private var _textField:TextField;
        private var _textFieldStyle:String = "";
        private var _textSize:int;


        public function set gradientRotation(_arg_1:Number):void
        {
            this._gradientRotation = _arg_1;
        }

        public function set colors(_arg_1:String):void
        {
            if (_arg_1 == this._colorStyle)
            {
                return;
            };
            this._colorStyle = _arg_1;
            this._colors = [];
            var _local_2:Array = this._colorStyle.split("|");
            var _local_3:int;
            while (_local_3 < _local_2.length)
            {
                this._colors.push(_local_2[_local_3].split(","));
                _local_3++;
            };
            onPropertiesChanged(P_color);
        }

        public function set alphas(_arg_1:String):void
        {
            if (_arg_1 == this._alphaStyle)
            {
                return;
            };
            this._alphaStyle = _arg_1;
            if (this._alphas)
            {
                this._alphas = [];
            };
            this._alphas = this._alphaStyle.split(",");
            onPropertiesChanged(P_alpha);
        }

        public function set ratios(_arg_1:String):void
        {
            if (_arg_1 == this._ratioStyle)
            {
                return;
            };
            this._ratioStyle = _arg_1;
            if (this._ratios)
            {
                this._ratios = [];
            };
            this._ratios = this._ratioStyle.split(",");
            onPropertiesChanged(P_ratio);
        }

        public function set filterString(_arg_1:String):void
        {
            if (this._filterString == _arg_1)
            {
                return;
            };
            this._filterString = _arg_1;
            this.frameFilters = ComponentFactory.Instance.creatFrameFilters(this._filterString);
        }

        public function set frameFilters(_arg_1:Array):void
        {
            if (this._frameFilter == _arg_1)
            {
                return;
            };
            this._frameFilter = _arg_1;
            onPropertiesChanged(P_frameFilters);
        }

        public function set text(_arg_1:String):void
        {
            this._textField.text = _arg_1;
            this.refreshBox();
        }

        public function get text():String
        {
            return (this._textField.text);
        }

        public function set textSize(_arg_1:int):void
        {
            if (this._textSize == _arg_1)
            {
                return;
            };
            this._textSize = _arg_1;
            onPropertiesChanged(P_size);
        }

        public function get textSize():int
        {
            return (this._textSize);
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
            this._textField = _arg_1;
            this._textSize = int(this._textField.defaultTextFormat.size);
            onPropertiesChanged(P_textField);
        }

        public function set textFieldStyle(_arg_1:String):void
        {
            if (_arg_1 == this._textFieldStyle)
            {
                return;
            };
            this._textFieldStyle = _arg_1;
            this.textField = ComponentFactory.Instance.creat(this._textFieldStyle);
        }

        override protected function addChildren():void
        {
            if (this._textField)
            {
                addChild(this._textField);
                this._textField.cacheAsBitmap = true;
            };
            if (this._gradientBox)
            {
                this._gradientBox.x = this._textField.x;
                this._gradientBox.y = this._textField.y;
                addChild(this._gradientBox);
                this._gradientBox.cacheAsBitmap = true;
                this._gradientBox.mask = this._textField;
            };
        }

        override public function get width():Number
        {
            return (this._textField.width);
        }

        public function get textWidth():Number
        {
            return (this._textField.textWidth);
        }

        public function getCharIndexAtPoint(_arg_1:Number, _arg_2:Number):int
        {
            return (this._textField.getCharIndexAtPoint(_arg_1, _arg_2));
        }

        public function setFrame(_arg_1:int):void
        {
            if (this._currentFrame == _arg_1)
            {
                return;
            };
            this._currentFrame = _arg_1;
            this.refreshBox();
            filters = this._frameFilter[(_arg_1 - 1)];
        }

        override protected function onProppertiesUpdate():void
        {
            super.onProppertiesUpdate();
            if ((((((_changedPropeties[P_textField]) || (_changedPropeties[P_color])) || (_changedPropeties[P_alpha])) || (_changedPropeties[P_ratio])) || (_changedPropeties[P_size])))
            {
                this.refreshBox();
            };
            if (_changedPropeties[P_frameFilters])
            {
                filters = this._frameFilter[0];
            };
        }

        override public function dispose():void
        {
            if (this._textField)
            {
                ObjectUtils.disposeObject(this._textField);
            };
            this._textField = null;
            if (this._gradientBox)
            {
                this._gradientBox.graphics.clear();
            };
            this._gradientBox = null;
            super.dispose();
        }

        private function refreshBox():void
        {
            var _local_1:TextFormat = this._textField.getTextFormat();
            _local_1.size = this._textSize;
            this._textField.setTextFormat(_local_1);
            if (this._textField.textWidth > this._textField.width)
            {
                _width = (this._textField.width = (this._textField.textWidth + 8));
            };
            this._currentMatrix = new Matrix();
            this._currentMatrix.createGradientBox(this._textField.width, this._textField.height, (Math.PI / 2), 0, 0);
            if (this._gradientBox == null)
            {
                this._gradientBox = new Shape();
            };
            this._gradientBox.graphics.clear();
            this._gradientBox.graphics.beginGradientFill(GradientType.LINEAR, this._colors[(this._currentFrame - 1)], this._alphas, this._ratios, this._currentMatrix);
            this._gradientBox.graphics.drawRect(0, 0, this._textField.width, this._textField.height);
            this._gradientBox.graphics.endFill();
        }


    }
}//package com.pickgliss.ui.text

