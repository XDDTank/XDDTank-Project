// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.ui.controls.Scrollbar

package com.pickgliss.ui.controls
{
    import com.pickgliss.ui.core.Component;
    import com.pickgliss.ui.core.IOrientable;
    import com.pickgliss.geom.InnerRectangle;
    import flash.geom.Rectangle;
    import flash.display.DisplayObject;
    import flash.utils.Timer;
    import com.pickgliss.events.InteractiveEvent;
    import flash.events.Event;
    import com.pickgliss.utils.ObjectUtils;
    import com.pickgliss.utils.ClassUtils;
    import com.pickgliss.ui.ComponentFactory;
    import flash.events.MouseEvent;
    import com.pickgliss.toplevel.StageReferance;
    import flash.display.InteractiveObject;
    import flash.events.TimerEvent;
    import flash.geom.Point;
    import com.pickgliss.ui.ComponentSetting;
    import com.pickgliss.utils.DisplayUtils;

    public class Scrollbar extends Component implements IOrientable 
    {

        public static const HORIZONTAL:int = 1;
        public static const P_decreaseButton:String = "decreaseButton";
        public static const P_decreaseButtonInnerRect:String = "decreaseButtonInnerRect";
        public static const P_increaseButton:String = "increaseButton";
        public static const P_increaseButtonInnerRect:String = "increaseButtonInnerRect";
        public static const P_maximum:String = "maximum";
        public static const P_minimum:String = "minimum";
        public static const P_orientation:String = "orientation";
        public static const P_scrollValue:String = "scrollValue";
        public static const P_thumb:String = "thumb";
        public static const P_thumbAreaInnerRect:String = "thumbAreaInnerRect";
        public static const P_thumbMinSize:String = "thumbMinSize";
        public static const P_track:String = "track";
        public static const P_trackInnerRect:String = "trackInnerRect";
        public static const P_valueIsAdjusting:String = "valueIsAdjusting";
        public static const P_visibleAmount:String = "visibleAmount";
        public static const VERTICAL:int = 0;

        protected var _blockIncrement:int = 20;
        protected var _currentTrackClickDirction:int = 0;
        protected var _decreaseButton:BaseButton;
        protected var _decreaseButtonInnerRect:InnerRectangle;
        protected var _decreaseButtonInnerRectString:String;
        protected var _decreaseButtonStyle:String;
        protected var _increaseButton:BaseButton;
        protected var _increaseButtonInnerRect:InnerRectangle;
        protected var _increaseButtonInnerRectString:String;
        protected var _increaseButtonStyle:String;
        protected var _isDragging:Boolean;
        protected var _model:BoundedRangeModel;
        protected var _orientation:int;
        protected var _thumb:BaseButton;
        protected var _thumbAreaInnerRect:InnerRectangle;
        protected var _thumbAreaInnerRectString:String;
        protected var _thumbDownOffset:int;
        protected var _thumbMinSize:int;
        protected var _thumbRect:Rectangle;
        protected var _thumbStyle:String;
        protected var _track:DisplayObject;
        protected var _trackClickTimer:Timer;
        protected var _trackInnerRect:InnerRectangle;
        protected var _trackInnerRectString:String;
        protected var _trackStyle:String;
        protected var _unitIncrement:int = 2;


        public function addStateListener(_arg_1:Function, _arg_2:int=0, _arg_3:Boolean=false):void
        {
            addEventListener(InteractiveEvent.STATE_CHANGED, _arg_1, false, _arg_2);
        }

        public function get blockIncrement():int
        {
            return (this._blockIncrement);
        }

        public function set blockIncrement(_arg_1:int):void
        {
            this._blockIncrement = _arg_1;
        }

        public function set decreaseButton(_arg_1:BaseButton):void
        {
            if (this._decreaseButton == _arg_1)
            {
                return;
            };
            if (this._decreaseButton)
            {
                this._decreaseButton.removeEventListener(Event.CHANGE, this.__increaseButtonClicked);
            };
            ObjectUtils.disposeObject(this._decreaseButton);
            this._decreaseButton = _arg_1;
            if (this._decreaseButton)
            {
                this._decreaseButton.pressEnable = true;
            };
            if (this._decreaseButton)
            {
                this._decreaseButton.addEventListener(Event.CHANGE, this.__increaseButtonClicked);
            };
            onPropertiesChanged(P_decreaseButton);
        }

        public function get decreaseButton():BaseButton
        {
            return (this._decreaseButton);
        }

        public function set decreaseButtonInnerRectString(_arg_1:String):void
        {
            if (this._decreaseButtonInnerRectString == _arg_1)
            {
                return;
            };
            this._decreaseButtonInnerRectString = _arg_1;
            this._decreaseButtonInnerRect = ClassUtils.CreatInstance(ClassUtils.INNERRECTANGLE, ComponentFactory.parasArgs(this._decreaseButtonInnerRectString));
            onPropertiesChanged(P_decreaseButtonInnerRect);
        }

        public function set decreaseButtonStyle(_arg_1:String):void
        {
            if (this._decreaseButtonStyle == _arg_1)
            {
                return;
            };
            this._decreaseButtonStyle = _arg_1;
            this.decreaseButton = ComponentFactory.Instance.creat(this._decreaseButtonStyle);
        }

        override public function dispose():void
        {
            if (this._thumb)
            {
                this._thumb.removeEventListener(MouseEvent.MOUSE_DOWN, this.__onThumbDown);
            };
            ObjectUtils.disposeObject(this._thumb);
            this._thumb = null;
            if (this._decreaseButton)
            {
                this._decreaseButton.removeEventListener(Event.CHANGE, this.__decreaseButtonClicked);
            };
            ObjectUtils.disposeObject(this._decreaseButton);
            this._decreaseButton = null;
            if (this._increaseButton)
            {
                this._increaseButton.removeEventListener(Event.CHANGE, this.__increaseButtonClicked);
            };
            ObjectUtils.disposeObject(this._increaseButton);
            this._increaseButton = null;
            StageReferance.stage.removeEventListener(MouseEvent.MOUSE_UP, this.__onThumbUp);
            StageReferance.stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.__onThumbMoved);
            if (((this._track) && (this._track is InteractiveObject)))
            {
                this._track.removeEventListener(MouseEvent.MOUSE_DOWN, this.__onTrackClickStart);
                this._track.removeEventListener(MouseEvent.MOUSE_UP, this.__onTrackClickStop);
                this._track.removeEventListener(MouseEvent.MOUSE_OUT, this.__onTrackClickStop);
                this._trackClickTimer.stop();
                this._trackClickTimer.removeEventListener(TimerEvent.TIMER, this.__onTrackPressed);
            };
            ObjectUtils.disposeObject(this._track);
            this._track = null;
            this._trackClickTimer = null;
            super.dispose();
        }

        public function set downButtonStyle(_arg_1:String):void
        {
            if (this._decreaseButtonStyle == _arg_1)
            {
                return;
            };
            this._decreaseButtonStyle = _arg_1;
            this.increaseButton = ComponentFactory.Instance.creat(this._decreaseButtonStyle);
        }

        public function getModel():BoundedRangeModel
        {
            return (this._model);
        }

        public function getThumbVisible():Boolean
        {
            return (this._thumb.visible);
        }

        public function set increaseButton(_arg_1:BaseButton):void
        {
            if (this._increaseButton == _arg_1)
            {
                return;
            };
            if (this._increaseButton)
            {
                this._increaseButton.removeEventListener(Event.CHANGE, this.__decreaseButtonClicked);
            };
            ObjectUtils.disposeObject(this._increaseButton);
            this._increaseButton = _arg_1;
            if (this._increaseButton)
            {
                this._increaseButton.pressEnable = true;
            };
            if (this._increaseButton)
            {
                this._increaseButton.addEventListener(Event.CHANGE, this.__decreaseButtonClicked);
            };
            onPropertiesChanged(P_increaseButton);
        }

        public function get increaseButton():BaseButton
        {
            return (this._increaseButton);
        }

        public function set increaseButtonInnerRectString(_arg_1:String):void
        {
            if (this._increaseButtonInnerRectString == _arg_1)
            {
                return;
            };
            this._increaseButtonInnerRectString = _arg_1;
            this._increaseButtonInnerRect = ClassUtils.CreatInstance(ClassUtils.INNERRECTANGLE, ComponentFactory.parasArgs(this._increaseButtonInnerRectString));
            onPropertiesChanged(P_increaseButtonInnerRect);
        }

        public function set increaseButtonStyle(_arg_1:String):void
        {
            if (this._increaseButtonStyle == _arg_1)
            {
                return;
            };
            this._increaseButtonStyle = _arg_1;
            this.increaseButton = ComponentFactory.Instance.creat(this._increaseButtonStyle);
        }

        public function isVertical():Boolean
        {
            return (this._orientation == 0);
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

        public function removeStateListener(_arg_1:Function):void
        {
            removeEventListener(InteractiveEvent.STATE_CHANGED, _arg_1);
        }

        public function get scrollValue():int
        {
            return (this.getModel().getValue());
        }

        public function set scrollValue(_arg_1:int):void
        {
            this.getModel().setValue(_arg_1);
            onPropertiesChanged(P_scrollValue);
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
                this._thumb.removeEventListener(MouseEvent.MOUSE_DOWN, this.__onThumbDown);
            };
            ObjectUtils.disposeObject(this._thumb);
            this._thumb = _arg_1;
            if (this._thumb)
            {
                this._thumb.addEventListener(MouseEvent.MOUSE_DOWN, this.__onThumbDown);
            };
            onPropertiesChanged(P_thumb);
        }

        public function set thumbAreaInnerRectString(_arg_1:String):void
        {
            if (this._thumbAreaInnerRectString == _arg_1)
            {
                return;
            };
            this._thumbAreaInnerRectString = _arg_1;
            this._thumbAreaInnerRect = ClassUtils.CreatInstance(ClassUtils.INNERRECTANGLE, ComponentFactory.parasArgs(this._thumbAreaInnerRectString));
            onPropertiesChanged(P_thumbAreaInnerRect);
        }

        public function get thumbMinSize():int
        {
            return (this._thumbMinSize);
        }

        public function set thumbMinSize(_arg_1:int):void
        {
            if (this._thumbMinSize == _arg_1)
            {
                return;
            };
            this._thumbMinSize = _arg_1;
            onPropertiesChanged(P_thumbMinSize);
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

        public function set track(_arg_1:DisplayObject):void
        {
            if (this._track == _arg_1)
            {
                return;
            };
            if (((this._track) && (this._track is InteractiveObject)))
            {
                this._track.removeEventListener(MouseEvent.MOUSE_DOWN, this.__onTrackClickStart);
                this._track.removeEventListener(MouseEvent.MOUSE_UP, this.__onTrackClickStop);
                this._track.removeEventListener(MouseEvent.MOUSE_OUT, this.__onTrackClickStop);
            };
            ObjectUtils.disposeObject(this._track);
            this._track = _arg_1;
            if ((this._track is InteractiveObject))
            {
                InteractiveObject(this._track).mouseEnabled = true;
            };
            this._track.addEventListener(MouseEvent.MOUSE_DOWN, this.__onTrackClickStart);
            this._track.addEventListener(MouseEvent.MOUSE_UP, this.__onTrackClickStop);
            this._track.addEventListener(MouseEvent.MOUSE_OUT, this.__onTrackClickStop);
            onPropertiesChanged(P_track);
        }

        public function set trackInnerRectString(_arg_1:String):void
        {
            if (this._trackInnerRectString == _arg_1)
            {
                return;
            };
            this._trackInnerRectString = _arg_1;
            this._trackInnerRect = ClassUtils.CreatInstance(ClassUtils.INNERRECTANGLE, ComponentFactory.parasArgs(this._trackInnerRectString));
            onPropertiesChanged(P_trackInnerRect);
        }

        public function set trackStyle(_arg_1:String):void
        {
            if (this._trackStyle == _arg_1)
            {
                return;
            };
            this._trackStyle = _arg_1;
            this.track = ComponentFactory.Instance.creat(this._trackStyle);
        }

        public function get unitIncrement():int
        {
            return (this._unitIncrement);
        }

        public function set unitIncrement(_arg_1:int):void
        {
            this._unitIncrement = _arg_1;
        }

        public function get valueIsAdjusting():Boolean
        {
            return (this.getModel().getValueIsAdjusting());
        }

        public function set valueIsAdjusting(_arg_1:Boolean):void
        {
            if (this.getModel().getValueIsAdjusting() == _arg_1)
            {
                return;
            };
            this.getModel().setValueIsAdjusting(_arg_1);
            onPropertiesChanged(P_valueIsAdjusting);
        }

        public function get visibleAmount():int
        {
            return (this.getModel().getExtent());
        }

        public function set visibleAmount(_arg_1:int):void
        {
            if (this.getModel().getExtent() == _arg_1)
            {
                return;
            };
            this.getModel().setExtent(_arg_1);
            onPropertiesChanged(P_visibleAmount);
        }

        protected function __decreaseButtonClicked(_arg_1:Event):void
        {
            this.scrollByIncrement(this._unitIncrement);
        }

        protected function __increaseButtonClicked(_arg_1:Event):void
        {
            this.scrollByIncrement(-(this._unitIncrement));
        }

        protected function __onModelChange(_arg_1:InteractiveEvent):void
        {
            dispatchEvent(new InteractiveEvent(InteractiveEvent.STATE_CHANGED));
        }

        protected function __onScrollValueChange(_arg_1:InteractiveEvent):void
        {
            if ((!(this._isDragging)))
            {
                this.updatePosByScrollvalue();
            };
        }

        protected function __onThumbDown(_arg_1:MouseEvent):void
        {
            this.valueIsAdjusting = true;
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
            StageReferance.stage.addEventListener(MouseEvent.MOUSE_UP, this.__onThumbUp);
            StageReferance.stage.addEventListener(MouseEvent.MOUSE_MOVE, this.__onThumbMoved);
        }

        protected function __onThumbMoved(_arg_1:MouseEvent):void
        {
            this.scrollThumbToCurrentMousePosition();
            _arg_1.updateAfterEvent();
        }

        protected function __onThumbUp(_arg_1:MouseEvent):void
        {
            this._isDragging = false;
            StageReferance.stage.removeEventListener(MouseEvent.MOUSE_UP, this.__onThumbUp);
            StageReferance.stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.__onThumbMoved);
        }

        protected function __onTrackClickStart(_arg_1:MouseEvent):void
        {
            this._currentTrackClickDirction = ((this.getValueWithPosition(getMousePosition()) > this.scrollValue) ? 1 : -1);
            this.scrollToAimPoint(getMousePosition());
            this._trackClickTimer.addEventListener(TimerEvent.TIMER, this.__onTrackPressed);
            this._track.addEventListener(MouseEvent.MOUSE_UP, this.__onTrackClickStop);
            this._track.addEventListener(MouseEvent.MOUSE_OUT, this.__onTrackClickStop);
            this._trackClickTimer.start();
        }

        protected function __onTrackClickStop(_arg_1:MouseEvent):void
        {
            this._trackClickTimer.stop();
            this._trackClickTimer.removeEventListener(TimerEvent.TIMER, this.__onTrackPressed);
            this._track.removeEventListener(MouseEvent.MOUSE_UP, this.__onTrackClickStop);
            this._track.removeEventListener(MouseEvent.MOUSE_OUT, this.__onTrackClickStop);
        }

        protected function __onTrackPressed(_arg_1:TimerEvent):void
        {
            this.scrollToAimPoint(getMousePosition());
        }

        override protected function addChildren():void
        {
            super.addChildren();
            if (this._track)
            {
                addChild(this._track);
            };
            if (this._increaseButton)
            {
                addChild(this._increaseButton);
            };
            if (this._decreaseButton)
            {
                addChild(this._decreaseButton);
            };
            if (this._thumb)
            {
                addChild(this._thumb);
            };
        }

        protected function getValueWithPosition(_arg_1:Point):int
        {
            var _local_5:int;
            var _local_6:int;
            var _local_7:int;
            var _local_2:int = _arg_1.x;
            var _local_3:int = _arg_1.y;
            var _local_4:Rectangle = this._thumbAreaInnerRect.getInnerRect(_width, _height);
            if (this.isVertical())
            {
                _local_5 = _local_4.y;
                _local_6 = ((_local_4.y + _local_4.height) - this._thumbRect.height);
                _local_7 = _local_3;
            }
            else
            {
                _local_5 = _local_4.x;
                _local_6 = ((_local_4.x + _local_4.width) - this._thumbRect.width);
                _local_7 = _local_2;
            };
            return (this.getValueWithThumbMaxMinPos(_local_5, _local_6, _local_7));
        }

        override protected function init():void
        {
            this.setupModel(new BoundedRangeModel());
            this._thumbRect = new Rectangle();
            this._trackClickTimer = new Timer(ComponentSetting.BUTTON_PRESS_STEP_TIME);
            this.addStateListener(this.__onScrollValueChange);
            super.init();
        }

        protected function layoutComponent():void
        {
            DisplayUtils.layoutDisplayWithInnerRect(this._increaseButton, this._increaseButtonInnerRect, _width, _height);
            DisplayUtils.layoutDisplayWithInnerRect(this._decreaseButton, this._decreaseButtonInnerRect, _width, _height);
            DisplayUtils.layoutDisplayWithInnerRect(this._track, this._trackInnerRect, _width, _height);
        }

        override protected function onProppertiesUpdate():void
        {
            super.onProppertiesUpdate();
            if (((((((_changedPropeties[Component.P_height]) || (_changedPropeties[Component.P_width])) || (_changedPropeties[P_decreaseButtonInnerRect])) || (_changedPropeties[P_increaseButtonInnerRect])) || (_changedPropeties[P_trackInnerRect])) || (_changedPropeties[P_thumbAreaInnerRect])))
            {
                this.layoutComponent();
            };
            if (((((((((_changedPropeties[P_maximum]) || (_changedPropeties[P_minimum])) || (_changedPropeties[P_scrollValue])) || (_changedPropeties[P_valueIsAdjusting])) || (_changedPropeties[P_visibleAmount])) || (_changedPropeties[P_thumbAreaInnerRect])) || (_changedPropeties[P_thumbMinSize])) || (_changedPropeties[P_thumb])))
            {
                this.updatePosByScrollvalue();
            };
        }

        protected function scrollByIncrement(_arg_1:int):void
        {
            this.scrollValue = (this.scrollValue + _arg_1);
        }

        protected function scrollThumbToCurrentMousePosition():void
        {
            var _local_5:int;
            var _local_6:int;
            var _local_7:int;
            var _local_1:Point = getMousePosition();
            var _local_2:int = _local_1.x;
            var _local_3:int = _local_1.y;
            var _local_4:Rectangle = this._thumbAreaInnerRect.getInnerRect(_width, _height);
            if (this.isVertical())
            {
                _local_5 = _local_4.y;
                _local_6 = ((_local_4.y + _local_4.height) - this._thumbRect.height);
                _local_7 = Math.min(_local_6, Math.max(_local_5, (_local_3 - this._thumbDownOffset)));
                this.setThumbPosAndSize(this._thumbRect.x, _local_7, this._thumbRect.width, this._thumbRect.height);
            }
            else
            {
                _local_5 = _local_4.x;
                _local_6 = ((_local_4.x + _local_4.width) - this._thumbRect.width);
                _local_7 = Math.min(_local_6, Math.max(_local_5, (_local_2 - this._thumbDownOffset)));
                this.setThumbPosAndSize(_local_7, this._thumbRect.y, this._thumbRect.width, this._thumbRect.height);
            };
            var _local_8:int = this.getValueWithThumbMaxMinPos(_local_5, _local_6, _local_7);
            this.scrollValue = _local_8;
        }

        protected function scrollToAimPoint(_arg_1:Point):void
        {
            var _local_3:int;
            var _local_2:int = this.getValueWithPosition(_arg_1);
            if (((_local_2 > this.scrollValue) && (this._currentTrackClickDirction > 0)))
            {
                _local_3 = this.blockIncrement;
            }
            else
            {
                if (((_local_2 < this.scrollValue) && (this._currentTrackClickDirction < 0)))
                {
                    _local_3 = -(this.blockIncrement);
                }
                else
                {
                    return;
                };
            };
            this.scrollByIncrement(_local_3);
        }

        protected function setThumbPosAndSize(_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:int):void
        {
            this._thumbRect.x = (this._thumb.x = _arg_1);
            this._thumbRect.y = (this._thumb.y = _arg_2);
            this._thumbRect.width = (this._thumb.width = _arg_3);
            this._thumbRect.height = (this._thumb.height = _arg_4);
        }

        protected function updatePosByScrollvalue():void
        {
            var _local_6:int;
            var _local_7:int;
            var _local_9:int;
            var _local_1:int = this.minimum;
            var _local_2:int = this.visibleAmount;
            var _local_3:int = (this.maximum - _local_1);
            var _local_4:int = this.scrollValue;
            var _local_5:Rectangle = this._thumbAreaInnerRect.getInnerRect(_width, _height);
            if (_local_3 <= 0)
            {
                this._thumb.visible = false;
                return;
            };
            if (this.isVertical())
            {
                _local_6 = _local_5.height;
                _local_7 = int(Math.floor((_local_6 * (_local_2 / _local_3))));
                this._thumb.visible = ((_local_7 > 0) && (_local_7 < _local_5.height));
            }
            else
            {
                _local_6 = _local_5.width;
                _local_7 = int(Math.floor((_local_6 * (_local_2 / _local_3))));
                this._thumb.visible = (_local_7 < _local_5.width);
            };
            this._increaseButton.mouseEnabled = (this._decreaseButton.mouseEnabled = this._thumb.visible);
            if (_local_6 > this.thumbMinSize)
            {
                _local_7 = Math.max(_local_7, this.thumbMinSize);
            }
            else
            {
                this._thumb.visible = false;
                return;
            };
            this._increaseButton.mouseEnabled = (this._decreaseButton.mouseEnabled = this._thumb.visible);
            var _local_8:int = (_local_6 - _local_7);
            if ((_local_3 - _local_2) == 0)
            {
                _local_9 = 0;
            }
            else
            {
                _local_9 = int(Math.round((_local_8 * ((_local_4 - _local_1) / (_local_3 - _local_2)))));
            };
            if (this.isVertical())
            {
                this.setThumbPosAndSize(_local_5.x, (_local_9 + _local_5.y), _local_5.width, _local_7);
            }
            else
            {
                this.setThumbPosAndSize((_local_5.x + _local_9), _local_5.y, _local_7, _local_5.height);
            };
        }

        private function getValueWithThumbMaxMinPos(_arg_1:int, _arg_2:int, _arg_3:int):int
        {
            var _local_4:int;
            var _local_5:int;
            var _local_6:int;
            var _local_7:int;
            var _local_8:int;
            var _local_9:int;
            if (_arg_3 >= _arg_2)
            {
                _local_4 = (this._model.getMaximum() - this._model.getExtent());
            }
            else
            {
                _local_5 = (this._model.getMaximum() - this._model.getExtent());
                _local_6 = (_local_5 - this._model.getMinimum());
                _local_7 = (_arg_3 - _arg_1);
                _local_8 = (_arg_2 - _arg_1);
                _local_9 = int(Math.round(((_local_7 / _local_8) * _local_6)));
                _local_4 = (_local_9 + this._model.getMinimum());
            };
            return (_local_4);
        }


    }
}//package com.pickgliss.ui.controls

