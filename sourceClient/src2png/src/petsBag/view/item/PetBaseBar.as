// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//petsBag.view.item.PetBaseBar

package petsBag.view.item
{
    import com.pickgliss.ui.core.Component;
    import flash.display.DisplayObject;
    import flash.display.Shape;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.utils.ObjectUtils;
    import com.pickgliss.ui.ComponentFactory;

    public class PetBaseBar extends Component 
    {

        public static const P_bgStyle:String = "bgStyle";
        public static const P_maxStyle:String = "maxStyle";
        public static const P_progressTextStyle:String = "progressTextStyle";
        public static const P_maxValue:String = "maxValue";
        public static const P_value:String = "value";

        protected var _backGround:DisplayObject;
        protected var _maxBar:DisplayObject;
        protected var _maxMask:Shape;
        protected var _progressLabel:FilterFrameText;
        protected var _bgStyle:String;
        protected var _maxStyle:String;
        protected var _progressTextStyle:String;
        protected var _value:Number;
        protected var _maxValue:Number;


        override public function get tipData():Object
        {
            return (_tipData);
        }

        override protected function onProppertiesUpdate():void
        {
            super.onProppertiesUpdate();
            if ((((_changedPropeties[P_bgStyle]) || (_changedPropeties[P_maxStyle])) || (_changedPropeties[P_progressTextStyle])))
            {
                this.resetView();
            };
            if (((_changedPropeties[P_value]) || (_changedPropeties[P_maxValue])))
            {
                this.resetProgress();
            };
        }

        protected function resetView():void
        {
            ObjectUtils.disposeObject(this._backGround);
            if (this._bgStyle)
            {
                this._backGround = ComponentFactory.Instance.creat(this._bgStyle);
            };
            addChild(this._backGround);
            ObjectUtils.disposeObject(this._maxBar);
            if (this._maxStyle)
            {
                this._maxBar = ComponentFactory.Instance.creat(this._maxStyle);
            };
            this._maxBar.cacheAsBitmap = true;
            addChild(this._maxBar);
            ObjectUtils.disposeObject(this._maxMask);
            this._maxMask = this.creatMask(this._maxBar);
            addChild(this._maxMask);
            ObjectUtils.disposeObject(this._progressLabel);
            if (this._progressTextStyle)
            {
                this._progressLabel = ComponentFactory.Instance.creatComponentByStylename(this._progressTextStyle);
            };
            addChild(this._progressLabel);
            _width = this._backGround.width;
            _height = this._backGround.height;
        }

        private function creatMask(_arg_1:DisplayObject):Shape
        {
            var _local_2:Shape;
            _local_2 = new Shape();
            _local_2.graphics.beginFill(0xFF0000, 1);
            _local_2.graphics.drawRect(0, 0, _arg_1.width, _arg_1.height);
            _local_2.graphics.endFill();
            _local_2.x = _arg_1.x;
            _local_2.y = _arg_1.y;
            _arg_1.mask = _local_2;
            return (_local_2);
        }

        protected function resetProgress():void
        {
            this._maxBar.visible = true;
            if (this._progressLabel)
            {
                this._progressLabel.visible = true;
            };
            this.drawProgress();
        }

        public function noData():void
        {
            if (this._maxBar)
            {
                this._maxBar.visible = false;
            };
            if (this._progressLabel)
            {
                this._progressLabel.visible = false;
            };
        }

        private function drawProgress():void
        {
            var _local_1:Number = ((this._maxValue > 0) ? (this._value / this._maxValue) : 0);
            this._maxMask.width = (this._maxBar.width * _local_1);
            if (this._progressLabel)
            {
                this._progressLabel.text = [this._value, this._maxValue].join("/");
            };
        }

        public function get bgStyle():String
        {
            return (this._bgStyle);
        }

        public function set bgStyle(_arg_1:String):void
        {
            this._bgStyle = _arg_1;
            onPropertiesChanged(P_bgStyle);
        }

        public function get maxStyle():String
        {
            return (this._maxStyle);
        }

        public function set maxStyle(_arg_1:String):void
        {
            this._maxStyle = _arg_1;
            onPropertiesChanged(P_maxStyle);
        }

        public function get progressTextStyle():String
        {
            return (this._progressTextStyle);
        }

        public function set progressTextStyle(_arg_1:String):void
        {
            this._progressTextStyle = _arg_1;
            onPropertiesChanged(P_progressTextStyle);
        }

        public function get value():Number
        {
            return (this._value);
        }

        public function set value(_arg_1:Number):void
        {
            this._value = _arg_1;
            onPropertiesChanged(P_value);
        }

        public function get maxValue():Number
        {
            return (this._maxValue);
        }

        public function set maxValue(_arg_1:Number):void
        {
            this._maxValue = _arg_1;
            onPropertiesChanged(P_maxValue);
        }

        override public function dispose():void
        {
            ObjectUtils.disposeObject(this._backGround);
            this._backGround = null;
            ObjectUtils.disposeObject(this._progressLabel);
            this._progressLabel = null;
            ObjectUtils.disposeObject(this._maxBar);
            this._maxBar = null;
            ObjectUtils.disposeObject(this._maxMask);
            this._maxMask = null;
            ObjectUtils.disposeAllChildren(this);
            super.dispose();
        }


    }
}//package petsBag.view.item

