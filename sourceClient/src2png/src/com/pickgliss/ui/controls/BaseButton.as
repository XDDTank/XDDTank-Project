// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.ui.controls.BaseButton

package com.pickgliss.ui.controls
{
    import com.pickgliss.ui.core.Component;
    import flash.display.Sprite;
    import flash.display.DisplayObject;
    import flash.utils.Timer;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.utils.ObjectUtils;
    import com.pickgliss.ui.ComponentSetting;
    import flash.events.MouseEvent;
    import com.pickgliss.utils.PNGHitAreaFactory;
    import com.pickgliss.utils.DisplayUtils;
    import flash.geom.Rectangle;
    import flash.display.MovieClip;
    import com.pickgliss.toplevel.StageReferance;
    import flash.events.TimerEvent;
    import flash.events.Event;

    [Event(name="change", type="flash.events.Event")]
    public class BaseButton extends Component 
    {

        public static const P_backStyle:String = "backStyle";
        public static const P_overbackStyle:String = "overbackStyle";
        public static const P_backgoundRotation:String = "backgoundRotation";
        public static const P_pressEnable:String = "pressEnable";
        public static const P_transparentEnable:String = "transparentEnable";
        public static const P_autoSizeAble:String = "autoSizeAble";
        public static const P_stopMovieAtLastFrame:String = "stopMovieAtLastFrame";

        private var _offsetCount:int;
        protected var _PNGHitArea:Sprite;
        protected var _back:DisplayObject;
        protected var _backStyle:String;
        protected var _backgoundRotation:int;
        protected var _currentFrameIndex:int = 1;
        protected var _enable:Boolean = true;
        protected var _filterString:String;
        protected var _frameFilter:Array;
        protected var _pressEnable:Boolean;
        protected var _stopMovieAtLastFrame:Boolean;
        private var _displacementEnable:Boolean = true;
        private var _pressStartTimer:Timer;
        private var _pressStepTimer:Timer;
        protected var _transparentEnable:Boolean;
        protected var _autoSizeAble:Boolean = true;
        private var _useLogID:int = 0;
        private var _overbackStyle:String;

        public function BaseButton()
        {
            this.init();
            this.addEvent();
        }

        public function set useLogID(_arg_1:int):void
        {
            this._useLogID = _arg_1;
        }

        public function get useLogID():int
        {
            return (this._useLogID);
        }

        public function get frameFilter():Array
        {
            return (this._frameFilter);
        }

        public function set frameFilter(_arg_1:Array):void
        {
            this._frameFilter = _arg_1;
        }

        public function set autoSizeAble(_arg_1:Boolean):void
        {
            if (this._autoSizeAble == _arg_1)
            {
                return;
            };
            this._autoSizeAble = _arg_1;
            onPropertiesChanged(P_autoSizeAble);
        }

        public function get backStyle():String
        {
            return (this._backStyle);
        }

        public function set backStyle(_arg_1:String):void
        {
            if (_arg_1 == this._backStyle)
            {
                return;
            };
            this._backStyle = _arg_1;
            this.backgound = ComponentFactory.Instance.creat(this._backStyle);
            onPropertiesChanged(P_backStyle);
        }

        public function get overbackStyle():String
        {
            return (this._overbackStyle);
        }

        public function set overbackStyle(_arg_1:String):void
        {
            if (_arg_1 == this._overbackStyle)
            {
                return;
            };
            this._overbackStyle = _arg_1;
        }

        public function set backgound(_arg_1:DisplayObject):void
        {
            if (this._back == _arg_1)
            {
                return;
            };
            ObjectUtils.disposeObject(this._back);
            this._back = _arg_1;
            _width = this._back.width;
            _height = this._back.height;
            onPropertiesChanged(P_backStyle);
        }

        public function get backgound():DisplayObject
        {
            return (this._back);
        }

        public function set backgoundRotation(_arg_1:int):void
        {
            if (this._backgoundRotation == _arg_1)
            {
                return;
            };
            this._backgoundRotation = _arg_1;
            onPropertiesChanged(P_backgoundRotation);
        }

        public function get displacement():Boolean
        {
            return (this._displacementEnable);
        }

        public function set displacement(_arg_1:Boolean):void
        {
            this._displacementEnable = _arg_1;
        }

        override public function dispose():void
        {
            this.removeEvent();
            if (this._back)
            {
                this._back.filters = null;
            };
            ObjectUtils.disposeObject(this._back);
            ObjectUtils.disposeObject(this._PNGHitArea);
            this._PNGHitArea = null;
            this._back = null;
            this._frameFilter = null;
            this._pressStepTimer = null;
            this._pressStartTimer = null;
            super.dispose();
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
            mouseEnabled = this._enable;
            if (this._enable)
            {
                this.setFrame(1);
            }
            else
            {
                this.setFrame(4);
            };
            this.updatePosition();
        }

        private function updatePosition():void
        {
            x = (x + (ComponentSetting.DISPLACEMENT_OFFSET * -(this._offsetCount)));
            y = (y + (ComponentSetting.DISPLACEMENT_OFFSET * -(this._offsetCount)));
            this._offsetCount = 0;
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

        public function set pressEnable(_arg_1:Boolean):void
        {
            if (this._pressEnable == _arg_1)
            {
                return;
            };
            this._pressEnable = _arg_1;
            onPropertiesChanged(P_pressEnable);
        }

        public function get transparentEnable():Boolean
        {
            return (this._transparentEnable);
        }

        public function set transparentEnable(_arg_1:Boolean):void
        {
            if (this._transparentEnable == _arg_1)
            {
                return;
            };
            this._transparentEnable = _arg_1;
            onPropertiesChanged(P_transparentEnable);
        }

        protected function __onMouseClick(_arg_1:MouseEvent):void
        {
            if ((!(this._enable)))
            {
                _arg_1.stopImmediatePropagation();
            }
            else
            {
                if (((!(this._useLogID == 0)) && (!(ComponentSetting.SEND_USELOG_ID == null))))
                {
                    ComponentSetting.SEND_USELOG_ID(this._useLogID);
                };
            };
        }

        protected function adaptHitArea():void
        {
            this._PNGHitArea.x = this._back.x;
            this._PNGHitArea.y = this._back.y;
        }

        override protected function addChildren():void
        {
            if (this._back)
            {
                addChild(this._back);
            };
        }

        protected function addEvent():void
        {
            addEventListener(MouseEvent.CLICK, this.__onMouseClick);
            addEventListener(MouseEvent.ROLL_OVER, this.__onMouseRollover);
            addEventListener(MouseEvent.ROLL_OUT, this.__onMouseRollout);
            addEventListener(MouseEvent.MOUSE_DOWN, this.__onMousedown);
        }

        public function set stopMovieAtLastFrame(_arg_1:Boolean):void
        {
            if (this._stopMovieAtLastFrame == _arg_1)
            {
                return;
            };
            this._stopMovieAtLastFrame = _arg_1;
            onPropertiesChanged(P_stopMovieAtLastFrame);
        }

        public function get stopMovieAtLastFrame():Boolean
        {
            return (this._stopMovieAtLastFrame);
        }

        protected function drawHitArea():void
        {
            if (((this._PNGHitArea) && (contains(this._PNGHitArea))))
            {
                removeChild(this._PNGHitArea);
            };
            if (this._back == null)
            {
                return;
            };
            if (this._transparentEnable)
            {
                this._PNGHitArea = PNGHitAreaFactory.drawHitArea(DisplayUtils.getDisplayBitmapData(this._back));
                hitArea = this._PNGHitArea;
                this._PNGHitArea.alpha = 0;
                this.adaptHitArea();
                addChild(this._PNGHitArea);
            }
            else
            {
                if (((this._PNGHitArea) && (contains(this._PNGHitArea))))
                {
                    removeChild(this._PNGHitArea);
                };
            };
        }

        override protected function init():void
        {
            super.init();
            mouseChildren = false;
            buttonMode = true;
        }

        override protected function onProppertiesUpdate():void
        {
            var _local_1:Rectangle;
            var _local_2:MovieClip;
            var _local_3:int;
            var _local_4:MovieClip;
            super.onProppertiesUpdate();
            if (_changedPropeties[P_pressEnable])
            {
                if (this._pressEnable == true)
                {
                    this._pressStartTimer = new Timer(ComponentSetting.BUTTON_PRESS_START_TIME, 1);
                    this._pressStepTimer = new Timer(ComponentSetting.BUTTON_PRESS_STEP_TIME);
                };
            };
            if (((_changedPropeties[P_backStyle]) && (this._autoSizeAble)))
            {
                if (((this._back) && ((this._back.width > 0) || (this._back.height > 0))))
                {
                    _width = this._back.width;
                    _height = this._back.height;
                };
            };
            if (((_changedPropeties[Component.P_width]) || (_changedPropeties[Component.P_height])))
            {
                if (this._back)
                {
                    this._back.width = _width;
                    this._back.height = _height;
                };
            };
            if (_changedPropeties[P_backgoundRotation])
            {
                if (this._back)
                {
                    this._back.rotation = this._backgoundRotation;
                    _local_1 = this._back.getRect(this);
                    this._back.x = -(_local_1.x);
                    this._back.y = -(_local_1.y);
                };
            };
            if ((((((_changedPropeties[Component.P_width]) || (_changedPropeties[Component.P_height])) || (_changedPropeties[P_backStyle])) || (_changedPropeties[P_backgoundRotation])) || (_changedPropeties[P_transparentEnable])))
            {
                this.drawHitArea();
            };
            this.setFrame(this._currentFrameIndex);
            if (((_changedPropeties[P_stopMovieAtLastFrame]) && (this._stopMovieAtLastFrame)))
            {
                _local_2 = (this._back as MovieClip);
                if (_local_2 != null)
                {
                    _local_3 = 0;
                    while (_local_3 < _local_2.numChildren)
                    {
                        _local_4 = (_local_2.getChildAt(_local_3) as MovieClip);
                        if (_local_4)
                        {
                            _local_4.gotoAndStop(_local_4.totalFrames);
                        };
                        _local_3++;
                    };
                };
            };
        }

        protected function removeEvent():void
        {
            removeEventListener(MouseEvent.CLICK, this.__onMouseClick);
            removeEventListener(MouseEvent.ROLL_OVER, this.__onMouseRollover);
            removeEventListener(MouseEvent.ROLL_OUT, this.__onMouseRollout);
            StageReferance.stage.removeEventListener(MouseEvent.MOUSE_UP, this.__onMouseup);
            removeEventListener(MouseEvent.MOUSE_DOWN, this.__onMousedown);
            if (this._pressStartTimer)
            {
                this._pressStartTimer.removeEventListener(TimerEvent.TIMER, this.__onPressedStart);
            };
            if (this._pressStepTimer)
            {
                this._pressStepTimer.removeEventListener(TimerEvent.TIMER, this.__onPressStepTimer);
            };
        }

        public function setFrame(_arg_1:int):void
        {
            this._currentFrameIndex = _arg_1;
            DisplayUtils.setFrame(this._back, this._currentFrameIndex);
            if ((((this._frameFilter == null) || (_arg_1 <= 0)) || (_arg_1 > this._frameFilter.length)))
            {
                return;
            };
            filters = this._frameFilter[(_arg_1 - 1)];
        }

        protected function __onMouseRollout(_arg_1:MouseEvent):void
        {
            if (((this._enable) && (!(_arg_1.buttonDown))))
            {
                this.setFrame(1);
                if (this.overbackStyle == null)
                {
                    return;
                };
                this.backgound = ComponentFactory.Instance.creat(this.backStyle);
                onPropertiesChanged(P_backStyle);
            };
        }

        protected function __onMouseRollover(_arg_1:MouseEvent):void
        {
            if (((this._enable) && (!(_arg_1.buttonDown))))
            {
                this.setFrame(2);
                if (this.overbackStyle == null)
                {
                    return;
                };
                this.backgound = ComponentFactory.Instance.creat(this.overbackStyle);
                onPropertiesChanged(P_backStyle);
            };
        }

        private function __onMousedown(_arg_1:MouseEvent):void
        {
            if ((!(this._enable)))
            {
                return;
            };
            this.setFrame(3);
            if (((this._displacementEnable) && (this._offsetCount < 1)))
            {
                x = (x + ComponentSetting.DISPLACEMENT_OFFSET);
                y = (y + ComponentSetting.DISPLACEMENT_OFFSET);
                this._offsetCount++;
            };
            StageReferance.stage.addEventListener(MouseEvent.MOUSE_UP, this.__onMouseup);
            if (this._pressEnable)
            {
                this.__onPressStepTimer(null);
                this._pressStartTimer.addEventListener(TimerEvent.TIMER, this.__onPressedStart);
                this._pressStartTimer.start();
            };
        }

        private function __onMouseup(_arg_1:MouseEvent):void
        {
            StageReferance.stage.removeEventListener(MouseEvent.MOUSE_UP, this.__onMouseup);
            if ((!(this._enable)))
            {
                return;
            };
            if (((this._displacementEnable) && (this._offsetCount > -1)))
            {
                x = (x - ComponentSetting.DISPLACEMENT_OFFSET);
                y = (y - ComponentSetting.DISPLACEMENT_OFFSET);
                this._offsetCount--;
            };
            if ((!(_arg_1.target is DisplayObject)))
            {
                this.setFrame(1);
            };
            if (_arg_1.target == this)
            {
                this.setFrame(2);
            }
            else
            {
                this.setFrame(1);
            };
            if (this._pressEnable)
            {
                this._pressStartTimer.stop();
                this._pressStepTimer.stop();
                this._pressStepTimer.removeEventListener(TimerEvent.TIMER, this.__onPressStepTimer);
            };
        }

        private function __onPressStepTimer(_arg_1:TimerEvent):void
        {
            dispatchEvent(new Event(Event.CHANGE));
        }

        private function __onPressedStart(_arg_1:TimerEvent):void
        {
            this._pressStartTimer.removeEventListener(TimerEvent.TIMER, this.__onPressedStart);
            this._pressStartTimer.reset();
            this._pressStartTimer.stop();
            this._pressStepTimer.start();
            this._pressStepTimer.addEventListener(TimerEvent.TIMER, this.__onPressStepTimer);
        }


    }
}//package com.pickgliss.ui.controls

