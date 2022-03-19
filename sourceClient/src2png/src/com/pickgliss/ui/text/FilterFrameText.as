// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.ui.text.FilterFrameText

package com.pickgliss.ui.text
{
    import flash.text.TextField;
    import com.pickgliss.ui.core.Disposeable;
    import __AS3__.vec.Vector;
    import flash.text.TextFormat;
    import flash.text.TextFieldAutoSize;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.toplevel.StageReferance;
    import flash.text.TextFieldType;
    import __AS3__.vec.*;

    public class FilterFrameText extends TextField implements Disposeable 
    {

        public static const P_frameFilters:String = "frameFilters";
        public static var isInputChangeWmode:Boolean = true;

        protected var _currentFrameIndex:int;
        protected var _filterString:String;
        protected var _frameFilter:Array;
        protected var _frameTextFormat:Vector.<TextFormat>;
        protected var _id:int;
        protected var _width:Number;
        protected var _height:Number;
        protected var _isAutoFitLength:Boolean = false;
        public var stylename:String;
        protected var _textFormatStyle:String;

        public function FilterFrameText()
        {
            autoSize = TextFieldAutoSize.LEFT;
            mouseEnabled = false;
            this._currentFrameIndex = 1;
            this._frameTextFormat = new Vector.<TextFormat>();
        }

        public function dispose():void
        {
            this._frameFilter = null;
            if (parent)
            {
                parent.removeChild(this);
            };
            ComponentFactory.Instance.removeComponent(this._id);
        }

        public function set filterString(_arg_1:String):void
        {
            if (this._filterString == _arg_1)
            {
                return;
            };
            this._filterString = _arg_1;
            this.frameFilters = ComponentFactory.Instance.creatFrameFilters(this._filterString);
            this.setFrame(1);
        }

        public function set frameFilters(_arg_1:Array):void
        {
            if (this._frameFilter == _arg_1)
            {
                return;
            };
            this._frameFilter = _arg_1;
        }

        public function get id():int
        {
            return (this._id);
        }

        public function set id(_arg_1:int):void
        {
            this._id = _arg_1;
        }

        public function setFocus():void
        {
            StageReferance.stage.focus = this;
        }

        public function setFrame(_arg_1:int):void
        {
            this._currentFrameIndex = _arg_1;
            if (((!(this._frameFilter == null)) && (this._frameFilter.length >= _arg_1)))
            {
                filters = this._frameFilter[(_arg_1 - 1)];
            };
            if (((!(this._frameTextFormat == null)) && (this._frameTextFormat.length >= _arg_1)))
            {
                this.textFormat = this._frameTextFormat[(_arg_1 - 1)];
            };
        }

        protected function set textFormat(_arg_1:TextFormat):void
        {
            setTextFormat(_arg_1);
            defaultTextFormat = _arg_1;
        }

        public function set textFormatStyle(_arg_1:String):void
        {
            var _local_4:TextFormat;
            if (this._textFormatStyle == _arg_1)
            {
                return;
            };
            this._textFormatStyle = _arg_1;
            var _local_2:Array = ComponentFactory.parasArgs(this._textFormatStyle);
            this._frameTextFormat = new Vector.<TextFormat>();
            var _local_3:int;
            while (_local_3 < _local_2.length)
            {
                _local_4 = ComponentFactory.Instance.model.getSet(_local_2[_local_3]);
                this._frameTextFormat.push(_local_4);
                _local_3++;
            };
            this.setFrame(1);
        }

        public function set isAutoFitLength(_arg_1:Boolean):void
        {
            this._isAutoFitLength = _arg_1;
        }

        override public function set visible(_arg_1:Boolean):void
        {
            super.visible = _arg_1;
        }

        override public function set text(_arg_1:String):void
        {
            var _local_2:int;
            super.text = _arg_1;
            if (((this._isAutoFitLength) && (textWidth > width)))
            {
                _local_2 = getCharIndexAtPoint((width - 22), 5);
                super.text = (text.substring(0, _local_2) + "...");
            };
            if (((this._width > 0) || (this._height > 0)))
            {
                if (wordWrap == true)
                {
                    this.width = this._width;
                };
            };
            this.setFrame(this._currentFrameIndex);
        }

        override public function set htmlText(_arg_1:String):void
        {
            if (((this._width > 0) || (this._height > 0)))
            {
                if (wordWrap == true)
                {
                    this.width = this._width;
                };
            };
            this.setFrame(this._currentFrameIndex);
            super.htmlText = _arg_1;
        }

        override public function set width(_arg_1:Number):void
        {
            this._width = _arg_1;
            super.width = _arg_1;
        }

        override public function set height(_arg_1:Number):void
        {
            this._height = _arg_1;
            super.height = _arg_1;
        }

        override public function set type(_arg_1:String):void
        {
            if (_arg_1 == TextFieldType.INPUT)
            {
                mouseEnabled = true;
            };
            super.type = _arg_1;
        }


    }
}//package com.pickgliss.ui.text

