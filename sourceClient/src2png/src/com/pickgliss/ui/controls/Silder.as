// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.ui.controls.Silder

package com.pickgliss.ui.controls
{
    import com.pickgliss.ui.core.Component;
    import com.pickgliss.ui.core.IOrientable;
    import flash.display.DisplayObject;
    import flash.display.Shape;
    import com.pickgliss.geom.InnerRectangle;
    import com.pickgliss.ui.ComponentFactory;
    import flash.events.MouseEvent;
    import com.pickgliss.toplevel.StageReferance;
    import com.pickgliss.utils.ObjectUtils;
    import com.pickgliss.utils.ClassUtils;
    import com.pickgliss.events.InteractiveEvent;
    import flash.geom.Point;
    import flash.geom.Rectangle;

    public class Silder extends Component implements IOrientable 
    {

        public static const P_bar:String = "bar";
        public static const P_maskShowAreaInnerRect:String = "maskShowAreaInnerRect";
        public static const P_maximum:String = "maximum";
        public static const P_minimum:String = "minimum";
        public static const P_orientation:String = "orientation";
        public static const P_progressBar:String = "progressBar";
        public static const P_thumb:String = "thumb";
        public static const P_thumbShowInnerRect:String = "thumbShowInnerRect";
        public static const P_value:String = "value";

        protected var _bar:DisplayObject;
        protected var _barStyle:String;
        protected var _isDragging:Boolean;
        protected var _maskShape:Shape;
        protected var _maskShowAreaInnerRect:InnerRectangle;
        protected var _maskShowAreaInnerRectString:String;
        protected var _model:BoundedRangeModel;
        protected var _orientation:int = -1;
        protected var _progressBar:DisplayObject;
        protected var _progressBarStyle:String;
        protected var _thumb:BaseButton;
        protected var _thumbDownOffset:int;
        protected var _thumbShowInnerRect:InnerRectangle;
        protected var _thumbShowInnerRectString:String;
        protected var _thumbStyle:String;
        protected var _value:Number;


        public function set bar(_arg_1:DisplayObject):void
        {
            if (this._bar == _arg_1)
            {
                return;
            };
            this._bar = _arg_1;
            onPropertiesChanged(P_bar);
        }

        public function set barStyle(_arg_1:String):void
        {
            if (this._barStyle == _arg_1)
            {
                return;
            };
            this._barStyle = _arg_1;
            this.bar = ComponentFactory.Instance.creat(this._barStyle);
        }

        override public function dispose():void
        {
            removeEventListener(MouseEvent.CLICK, this.__onSilderClick);
            StageReferance.stage.removeEventListener(MouseEvent.MOUSE_UP, this.__onThumbMouseUp);
            StageReferance.stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.__onThumbMouseMoved);
            if (this._thumb)
            {
                this._thumb.addEventListener(MouseEvent.MOUSE_DOWN, this.__onThumbMouseDown);
            };
            ObjectUtils.disposeObject(this._thumb);
            ObjectUtils.disposeObject(this._bar);
            ObjectUtils.disposeObject(this._progressBar);
            ObjectUtils.disposeObject(this._maskShape);
            super.dispose();
        }

        public function getModel():BoundedRangeModel
        {
            return (this._model);
        }

        public function isVertical():Boolean
        {
            return (this._orientation == 0);
        }

        public function set maskShowAreaInnerRectString(_arg_1:String):void
        {
            if (this._maskShowAreaInnerRectString == _arg_1)
            {
                return;
            };
            this._maskShowAreaInnerRectString = _arg_1;
            this._maskShowAreaInnerRect = ClassUtils.CreatInstance(ClassUtils.INNERRECTANGLE, ComponentFactory.parasArgs(this._maskShowAreaInnerRectString));
            onPropertiesChanged(P_maskShowAreaInnerRect);
        }

        public function get maximum():int
        {
            return (this.getModel().getMaximum());
        }

        public function set maximum(_arg_1:int):void
        {
            if (this.getModel().getMaximum() == _arg_1)
            {
                return;
            };
            this.getModel().setMaximum(_arg_1);
            onPropertiesChanged(P_maximum);
        }

        public function get minimum():int
        {
            return (this.getModel().getMinimum());
        }

        public function set minimum(_arg_1:int):void
        {
            if (this.getModel().getMinimum() == _arg_1)
            {
                return;
            };
            this.getModel().setMinimum(_arg_1);
            onPropertiesChanged(P_minimum);
        }

        public function get orientation():int
        {
            return (this._orientation);
        }

        public function set orientation(_arg_1:int):void
        {
            if (this._orientation == _arg_1)
            {
                return;
            };
            this._orientation = _arg_1;
            onPropertiesChanged(P_orientation);
        }

        public function set progressBar(_arg_1:DisplayObject):void
        {
            if (this._progressBar == _arg_1)
            {
                return;
            };
            this._progressBar = _arg_1;
            onPropertiesChanged(P_progressBar);
        }

        public function set progressBarStyle(_arg_1:String):void
        {
            if (this._progressBarStyle == _arg_1)
            {
                return;
            };
            this._progressBarStyle = _arg_1;
            this.progressBar = ComponentFactory.Instance.creat(this._progressBarStyle);
        }

        public function removeStateListener(_arg_1:Function):void
        {
            removeEventListener(InteractiveEvent.STATE_CHANGED, _arg_1);
        }

        public function setupModel(_arg_1:BoundedRangeModel):void
        {
            if (this._model)
            {
                this._model.removeStateListener(this.__onModelChange);
            }
            else
            {
                this._model = _arg_1;
            };
            this._model.addStateListener(this.__onModelChange);
        }

        public function set thumb(_arg_1:BaseButton):void
        {
            if (this._thumb == _arg_1)
            {
                return;
            };
            if (this._thumb)
            {
                ObjectUtils.disposeObject(this._thumb);
                this._thumb.removeEventListener(MouseEvent.MOUSE_DOWN, this.__onThumbMouseDown);
            };
            this._thumb = _arg_1;
            this._thumb.addEventListener(MouseEvent.MOUSE_DOWN, this.__onThumbMouseDown);
            onPropertiesChanged(P_thumb);
        }

        public function set thumbShowInnerRectString(_arg_1:String):void
        {
            if (this._thumbShowInnerRectString == _arg_1)
            {
                return;
            };
            this._thumbShowInnerRectString = _arg_1;
            this._thumbShowInnerRect = ClassUtils.CreatInstance(ClassUtils.INNERRECTANGLE, ComponentFactory.parasArgs(this._thumbShowInnerRectString));
            onPropertiesChanged(P_thumbShowInnerRect);
        }

        public function set thumbStyle(_arg_1:String):void
        {
            if (this._thumbStyle == _arg_1)
            {
                return;
            };
            this._thumbStyle = _arg_1;
            this.thumb = ComponentFactory.Instance.creat(this._thumbStyle);
        }

        public function get value():Number
        {
            return (this.getModel().getValue());
        }

        public function set value(_arg_1:Number):void
        {
            if (this._value == _arg_1)
            {
                return;
            };
            this._value = _arg_1;
            this.getModel().setValue(this._value);
            onPropertiesChanged(P_value);
        }

        protected function __onModelChange(_arg_1:InteractiveEvent):void
        {
            dispatchEvent(new InteractiveEvent(InteractiveEvent.STATE_CHANGED));
        }

        protected function __onSilderClick(_arg_1:MouseEvent):void
        {
            this.scrollThumbToCurrentMousePosition();
            _arg_1.updateAfterEvent();
        }

        protected function __onThumbMouseDown(_arg_1:MouseEvent):void
        {
            var _local_2:Point = getMousePosition();
            var _local_3:int = _local_2.x;
            var _local_4:int = _local_2.y;
            if (this.isVertical())
            {
                this._thumbDownOffset = (_local_4 - this._thumb.y);
            }
            else
            {
                this._thumbDownOffset = (_local_3 - this._thumb.x);
            };
            this._isDragging = true;
            StageReferance.stage.addEventListener(MouseEvent.MOUSE_UP, this.__onThumbMouseUp);
            StageReferance.stage.addEventListener(MouseEvent.MOUSE_MOVE, this.__onThumbMouseMoved);
        }

        protected function __onThumbMouseMoved(_arg_1:MouseEvent):void
        {
            this.scrollThumbToCurrentMousePosition();
            _arg_1.updateAfterEvent();
        }

        protected function __onThumbMouseUp(_arg_1:MouseEvent):void
        {
            StageReferance.stage.removeEventListener(MouseEvent.MOUSE_UP, this.__onThumbMouseUp);
            StageReferance.stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.__onThumbMouseMoved);
        }

        override protected function addChildren():void
        {
            super.addChildren();
            if (this._bar)
            {
                addChild(this._bar);
            };
            if (this._progressBar)
            {
                addChild(this._progressBar);
                addChild(this._maskShape);
            };
            if (this._thumb)
            {
                addChild(this._thumb);
            };
        }

        override protected function init():void
        {
            this.setupModel(new BoundedRangeModel());
            this.setupMask();
            addEventListener(MouseEvent.CLICK, this.__onSilderClick);
            super.init();
        }

        override protected function onProppertiesUpdate():void
        {
            super.onProppertiesUpdate();
            if (((_changedPropeties[Component.P_width]) || (_changedPropeties[Component.P_height])))
            {
                this.updateSize();
            };
            if ((((((((_changedPropeties[P_value]) || (_changedPropeties[P_thumbShowInnerRect])) || (_changedPropeties[P_maskShowAreaInnerRect])) || (_changedPropeties[Component.P_width])) || (_changedPropeties[Component.P_height])) || (_changedPropeties[P_maximum])) || (_changedPropeties[P_minimum])))
            {
                this.updateThumbPos();
                this.updateMask();
                if (this._bar)
                {
                    this._bar.width = _width;
                    this._bar.height = _height;
                };
            };
        }

        protected function scrollThumbToCurrentMousePosition():void
        {
            var _local_5:int;
            var _local_6:int;
            var _local_7:int;
            var _local_1:Point = getMousePosition();
            var _local_2:int = _local_1.x;
            var _local_3:int = _local_1.y;
            var _local_4:Rectangle = this._thumbShowInnerRect.getInnerRect(_width, _height);
            if (this.isVertical())
            {
                _local_5 = _local_4.y;
                _local_6 = (_local_4.y + _local_4.height);
                _local_7 = Math.min(_local_6, Math.max(_local_5, (_local_3 - this._thumbDownOffset)));
            }
            else
            {
                _local_5 = _local_4.x;
                _local_6 = (_local_4.x + _local_4.width);
                _local_7 = Math.min(_local_6, Math.max(_local_5, (_local_2 - this._thumbDownOffset)));
            };
            this.value = this.getValueWithThumbMaxMinPos(_local_5, _local_6, _local_7);
        }

        protected function setupMask():void
        {
            this._maskShape = new Shape();
            this._maskShape.graphics.beginFill(0xFF0000, 1);
            this._maskShape.graphics.drawRect(0, 0, 100, 100);
            this._maskShape.graphics.endFill();
        }

        protected function updateMask():void
        {
            if (this._maskShowAreaInnerRect == null)
            {
                return;
            };
            var _local_1:Rectangle = this._maskShowAreaInnerRect.getInnerRect(_width, _height);
            this._maskShape.x = _local_1.x;
            this._maskShape.y = _local_1.y;
            var _local_2:Number = this.calculateValuePercent();
            if (this.isVertical())
            {
                this._maskShape.height = (_local_1.height * _local_2);
                this._maskShape.width = _local_1.width;
            }
            else
            {
                this._maskShape.width = (_local_1.width * _local_2);
                this._maskShape.height = _local_1.height;
            };
            if (this._maskShape)
            {
                this._progressBar.mask = this._maskShape;
            };
        }

        protected function updateSize():void
        {
            this._bar.width = _width;
            this._bar.height = _height;
            if (this._progressBar)
            {
                this._progressBar.width = _width;
                this._progressBar.height = _height;
            };
        }

        protected function updateThumbPos():void
        {
            var _local_2:int;
            var _local_3:int;
            if (this._thumbShowInnerRect == null)
            {
                return;
            };
            var _local_1:Rectangle = this._thumbShowInnerRect.getInnerRect(_width, _height);
            var _local_4:Number = this.calculateValuePercent();
            if (this.isVertical())
            {
                this._thumb.x = _local_1.x;
                _local_2 = _local_1.height;
                _local_3 = _local_1.y;
                this._thumb.y = (Math.round((_local_4 * _local_2)) + _local_3);
            }
            else
            {
                this._thumb.y = _local_1.y;
                _local_2 = _local_1.width;
                _local_3 = _local_1.x;
                this._thumb.x = (Math.round((_local_4 * _local_2)) + _local_3);
            };
            this._thumb.tipData = this._value;
        }

        private function calculateValuePercent():Number
        {
            var _local_1:Number;
            if (((this._value < this.minimum) || (isNaN(this._value))))
            {
                this._value = this.minimum;
            };
            if (this._value > this.maximum)
            {
                this._value = this.maximum;
            };
            if (this.maximum > this.minimum)
            {
                _local_1 = ((this._value - this.minimum) / (this.maximum - this.minimum));
            }
            else
            {
                _local_1 = 1;
            };
            return (_local_1);
        }

        private function getValueWithThumbMaxMinPos(_arg_1:Number, _arg_2:Number, _arg_3:Number):Number
        {
            var _local_4:Number = (_arg_2 - _arg_1);
            var _local_5:Number = ((_arg_3 - _arg_1) / _local_4);
            var _local_6:Number = (this.maximum - this.minimum);
            return ((_local_5 * _local_6) + this.minimum);
        }


    }
}//package com.pickgliss.ui.controls

