// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.ui.controls.ScrollPanel

package com.pickgliss.ui.controls
{
    import com.pickgliss.ui.core.Component;
    import flash.display.DisplayObject;
    import com.pickgliss.geom.InnerRectangle;
    import com.pickgliss.ui.core.IViewprot;
    import com.pickgliss.utils.ObjectUtils;
    import com.pickgliss.utils.ClassUtils;
    import com.pickgliss.ui.ComponentFactory;
    import flash.events.MouseEvent;
    import flash.geom.Rectangle;
    import com.pickgliss.geom.IntDimension;
    import com.pickgliss.geom.IntRectangle;
    import com.pickgliss.geom.IntPoint;
    import com.pickgliss.events.InteractiveEvent;
    import com.pickgliss.utils.DisplayUtils;

    public class ScrollPanel extends Component 
    {

        public static const AUTO:int = 1;
        public static const OFF:int = 2;
        public static const ON:int = 0;
        public static const P_backgound:String = "backgound";
        public static const P_backgoundInnerRect:String = "backgoundInnerRect";
        public static const P_hScrollProxy:String = "hScrollProxy";
        public static const P_hScrollbar:String = "hScrollbar";
        public static const P_hScrollbarInnerRect:String = "hScrollbarInnerRect";
        public static const P_vScrollProxy:String = "vScrollProxy";
        public static const P_vScrollbar:String = "vScrollbar";
        public static const P_vScrollbarInnerRect:String = "vScrollbarInnerRect";
        public static const P_viewSource:String = "viewSource";
        public static const P_viewportInnerRect:String = "viewportInnerRect";

        protected var _backgound:DisplayObject;
        protected var _backgoundInnerRect:InnerRectangle;
        protected var _backgoundInnerRectString:String;
        protected var _backgoundStyle:String;
        protected var _hScrollProxy:int;
        protected var _hScrollbar:Scrollbar;
        protected var _hScrollbarInnerRect:InnerRectangle;
        protected var _hScrollbarInnerRectString:String;
        protected var _hScrollbarStyle:String;
        protected var _vScrollProxy:int;
        protected var _vScrollbar:Scrollbar;
        protected var _vScrollbarInnerRect:InnerRectangle;
        protected var _vScrollbarInnerRectString:String;
        protected var _vScrollbarStyle:String;
        protected var _viewSource:IViewprot;
        protected var _viewportInnerRect:InnerRectangle;
        protected var _viewportInnerRectString:String;

        public function ScrollPanel(_arg_1:Boolean=true)
        {
            if (_arg_1)
            {
                this._viewSource = new DisplayObjectViewport();
                this._viewSource.addStateListener(this.__onViewportStateChanged);
            };
        }

        public function set backgound(_arg_1:DisplayObject):void
        {
            if (this._backgound == _arg_1)
            {
                return;
            };
            if (this._backgound)
            {
                ObjectUtils.disposeObject(this._backgound);
            };
            this._backgound = _arg_1;
            onPropertiesChanged(P_backgound);
        }

        public function set backgoundInnerRectString(_arg_1:String):void
        {
            if (this._backgoundInnerRectString == _arg_1)
            {
                return;
            };
            this._backgoundInnerRectString = _arg_1;
            this._backgoundInnerRect = ClassUtils.CreatInstance(ClassUtils.INNERRECTANGLE, ComponentFactory.parasArgs(this._backgoundInnerRectString));
            onPropertiesChanged(P_backgoundInnerRect);
        }

        public function set backgoundStyle(_arg_1:String):void
        {
            if (this._backgoundStyle == _arg_1)
            {
                return;
            };
            this._backgoundStyle = _arg_1;
            this.backgound = ComponentFactory.Instance.creat(this._backgoundStyle);
        }

        public function get displayObjectViewport():DisplayObjectViewport
        {
            return (this._viewSource as DisplayObjectViewport);
        }

        override public function dispose():void
        {
            if (this._vScrollbar)
            {
                this._vScrollbar.removeStateListener(this.__onScrollValueChange);
                ObjectUtils.disposeObject(this._vScrollbar);
            };
            this._vScrollbar = null;
            if (this._hScrollbar)
            {
                this._hScrollbar.removeStateListener(this.__onScrollValueChange);
                ObjectUtils.disposeObject(this._hScrollbar);
            };
            this._hScrollbar = null;
            if (this._backgound)
            {
                ObjectUtils.disposeObject(this._backgound);
            };
            this._backgound = null;
            if (this._viewSource)
            {
                ObjectUtils.disposeObject(this._viewSource);
            };
            this._viewSource = null;
            removeEventListener(MouseEvent.MOUSE_WHEEL, this.__onMouseWheel);
            super.dispose();
        }

        public function getShowHScrollbarExtendHeight():Number
        {
            var _local_1:Rectangle;
            if (((_height == 0) || (this._hScrollbarInnerRect == null)))
            {
                return (0);
            };
            var _local_2:Rectangle = this._viewportInnerRect.getInnerRect(_width, _height);
            var _local_3:Rectangle = this._hScrollbarInnerRect.getInnerRect(_width, _height);
            _local_1 = _local_2.union(_local_3);
            return (_local_2.height - _local_1.height);
        }

        public function getVisibleRect():IntRectangle
        {
            var _local_1:int;
            var _local_2:int;
            var _local_3:int;
            var _local_4:int;
            var _local_5:IntDimension = this._viewSource.getViewSize();
            if (this._hScrollbar == null)
            {
                _local_2 = 0;
                _local_4 = _local_5.width;
            }
            else
            {
                _local_2 = this._hScrollbar.scrollValue;
                _local_4 = this._hScrollbar.visibleAmount;
            };
            if (this._vScrollbar == null)
            {
                _local_1 = 0;
                _local_3 = _local_5.height;
            }
            else
            {
                _local_1 = this._vScrollbar.scrollValue;
                _local_3 = this._vScrollbar.visibleAmount;
            };
            return (new IntRectangle(_local_2, _local_1, _local_4, _local_3));
        }

        public function set hScrollProxy(_arg_1:int):void
        {
            if (this._hScrollProxy == _arg_1)
            {
                return;
            };
            this._hScrollProxy = _arg_1;
            onPropertiesChanged(P_hScrollProxy);
        }

        public function get hScrollbar():Scrollbar
        {
            return (this._hScrollbar);
        }

        public function set hScrollbar(_arg_1:Scrollbar):void
        {
            if (this._hScrollbar == _arg_1)
            {
                return;
            };
            if (this._hScrollbar)
            {
                this._hScrollbar.removeStateListener(this.__onScrollValueChange);
                ObjectUtils.disposeObject(this._hScrollbar);
            };
            this._hScrollbar = _arg_1;
            this._hScrollbar.addStateListener(this.__onScrollValueChange);
            onPropertiesChanged(P_hScrollbar);
        }

        public function set hScrollbarInnerRectString(_arg_1:String):void
        {
            if (this._hScrollbarInnerRectString == _arg_1)
            {
                return;
            };
            this._hScrollbarInnerRectString = _arg_1;
            this._hScrollbarInnerRect = ClassUtils.CreatInstance(ClassUtils.INNERRECTANGLE, ComponentFactory.parasArgs(this._hScrollbarInnerRectString));
            onPropertiesChanged(P_hScrollbarInnerRect);
        }

        public function set hScrollbarStyle(_arg_1:String):void
        {
            if (this._hScrollbarStyle == _arg_1)
            {
                return;
            };
            this._hScrollbarStyle = _arg_1;
            this.hScrollbar = ComponentFactory.Instance.creat(this._hScrollbarStyle);
        }

        public function set hUnitIncrement(_arg_1:int):void
        {
            this._viewSource.horizontalUnitIncrement = _arg_1;
        }

        public function invalidateViewport(_arg_1:Boolean=false):void
        {
            var _local_2:int;
            var _local_3:IntPoint;
            if ((this._viewSource is DisplayObjectViewport))
            {
                if (_arg_1)
                {
                    this.displayObjectViewport.invalidateView();
                    _local_2 = this.viewPort.getViewSize().height;
                    _local_3 = new IntPoint(0, _local_2);
                    this.viewPort.viewPosition = _local_3;
                }
                else
                {
                    this.displayObjectViewport.invalidateView();
                };
            };
        }

        public function setView(_arg_1:DisplayObject):void
        {
            if ((this._viewSource is DisplayObjectViewport))
            {
                this.displayObjectViewport.setView(_arg_1);
            };
        }

        public function set vScrollProxy(_arg_1:int):void
        {
            if (this._vScrollProxy == _arg_1)
            {
                return;
            };
            this._vScrollProxy = _arg_1;
            onPropertiesChanged(P_vScrollProxy);
        }

        public function get vScrollbar():Scrollbar
        {
            return (this._vScrollbar);
        }

        public function set vScrollbar(_arg_1:Scrollbar):void
        {
            if (this._vScrollbar == _arg_1)
            {
                return;
            };
            if (this._vScrollbar)
            {
                this._vScrollbar.removeStateListener(this.__onScrollValueChange);
                ObjectUtils.disposeObject(this._vScrollbar);
            };
            this._vScrollbar = _arg_1;
            this._vScrollbar.addStateListener(this.__onScrollValueChange);
            onPropertiesChanged(P_vScrollbar);
        }

        public function set vScrollbarInnerRectString(_arg_1:String):void
        {
            if (this._vScrollbarInnerRectString == _arg_1)
            {
                return;
            };
            this._vScrollbarInnerRectString = _arg_1;
            this._vScrollbarInnerRect = ClassUtils.CreatInstance(ClassUtils.INNERRECTANGLE, ComponentFactory.parasArgs(this._vScrollbarInnerRectString));
            onPropertiesChanged(P_vScrollbarInnerRect);
        }

        public function set vScrollbarStyle(_arg_1:String):void
        {
            if (this._vScrollbarStyle == _arg_1)
            {
                return;
            };
            this._vScrollbarStyle = _arg_1;
            this.vScrollbar = ComponentFactory.Instance.creat(this._vScrollbarStyle);
        }

        public function set vUnitIncrement(_arg_1:int):void
        {
            this._viewSource.verticalUnitIncrement = _arg_1;
        }

        public function get viewPort():IViewprot
        {
            return (this._viewSource);
        }

        public function set viewPort(_arg_1:IViewprot):void
        {
            if (this._viewSource == _arg_1)
            {
                return;
            };
            if (this._viewSource)
            {
                this._viewSource.removeStateListener(this.__onViewportStateChanged);
                ObjectUtils.disposeObject(this._viewSource);
            };
            this._viewSource = _arg_1;
            this._viewSource.addStateListener(this.__onViewportStateChanged);
            onPropertiesChanged(P_viewSource);
        }

        public function set viewportInnerRectString(_arg_1:String):void
        {
            if (this._viewportInnerRectString == _arg_1)
            {
                return;
            };
            this._viewportInnerRectString = _arg_1;
            this._viewportInnerRect = ClassUtils.CreatInstance(ClassUtils.INNERRECTANGLE, ComponentFactory.parasArgs(this._viewportInnerRectString));
            onPropertiesChanged(P_viewportInnerRect);
        }

        protected function __onMouseWheel(_arg_1:MouseEvent):void
        {
            var _local_2:IntPoint = this._viewSource.viewPosition.clone();
            _local_2.y = (_local_2.y - (_arg_1.delta * this._viewSource.verticalUnitIncrement));
            this._viewSource.viewPosition = _local_2;
            _arg_1.stopImmediatePropagation();
        }

        public function setViewPosition(_arg_1:int):void
        {
            var _local_2:IntPoint = this._viewSource.viewPosition.clone();
            _local_2.y = (_local_2.y + (_arg_1 * this._viewSource.verticalUnitIncrement));
            this._viewSource.viewPosition = _local_2;
        }

        protected function __onScrollValueChange(_arg_1:InteractiveEvent):void
        {
            this.viewPort.scrollRectToVisible(this.getVisibleRect());
        }

        protected function __onViewportStateChanged(_arg_1:InteractiveEvent):void
        {
            this.syncScrollPaneWithViewport();
        }

        override protected function addChildren():void
        {
            super.addChildren();
            if (this._backgound)
            {
                addChild(this._backgound);
            };
            if (this._viewSource)
            {
                addChild(this._viewSource.asDisplayObject());
            };
            if (this._vScrollbar)
            {
                addChild(this._vScrollbar);
            };
            if (this._hScrollbar)
            {
                addChild(this._hScrollbar);
            };
        }

        override protected function init():void
        {
            this.initEvent();
            super.init();
        }

        protected function initEvent():void
        {
            addEventListener(MouseEvent.MOUSE_WHEEL, this.__onMouseWheel);
        }

        protected function layoutComponent():void
        {
            if (this._vScrollbar)
            {
                DisplayUtils.layoutDisplayWithInnerRect(this._vScrollbar, this._vScrollbarInnerRect, _width, _height);
            };
            if (this._hScrollbar)
            {
                DisplayUtils.layoutDisplayWithInnerRect(this._hScrollbar, this._hScrollbarInnerRect, _width, _height);
            };
            if (this._backgound)
            {
                DisplayUtils.layoutDisplayWithInnerRect(this._backgound, this._backgoundInnerRect, _width, _height);
            };
            if (this._viewSource)
            {
                DisplayUtils.layoutDisplayWithInnerRect(this._viewSource.asDisplayObject(), this._viewportInnerRect, _width, _height);
            };
        }

        override protected function onProppertiesUpdate():void
        {
            super.onProppertiesUpdate();
            if (((((((((_changedPropeties[Component.P_height]) || (_changedPropeties[Component.P_width])) || (_changedPropeties[P_vScrollbarInnerRect])) || (_changedPropeties[P_hScrollbarInnerRect])) || (_changedPropeties[P_vScrollbar])) || (_changedPropeties[P_hScrollbar])) || (_changedPropeties[P_viewportInnerRect])) || (_changedPropeties[P_viewSource])))
            {
                this.layoutComponent();
            };
            if (_changedPropeties[P_viewSource])
            {
                this.syncScrollPaneWithViewport();
            };
            if (((_changedPropeties[P_vScrollProxy]) || (_changedPropeties[P_hScrollProxy])))
            {
                if (this._vScrollbar)
                {
                    this._vScrollbar.visible = (this._vScrollProxy == ON);
                };
                if (this._hScrollbar)
                {
                    this._hScrollbar.visible = (this._hScrollProxy == ON);
                };
            };
        }

        protected function syncScrollPaneWithViewport():void
        {
            var _local_1:IntDimension;
            var _local_2:IntDimension;
            var _local_3:IntPoint;
            var _local_4:int;
            var _local_5:int;
            var _local_6:int;
            if (this._viewSource != null)
            {
                _local_1 = this._viewSource.getExtentSize();
                if (((_local_1.width <= 0) || (_local_1.height <= 0)))
                {
                    return;
                };
                _local_2 = this._viewSource.getViewSize();
                _local_3 = this._viewSource.viewPosition;
                if (this._vScrollbar != null)
                {
                    _local_4 = _local_1.height;
                    _local_5 = _local_2.height;
                    _local_6 = Math.max(0, Math.min(_local_3.y, (_local_5 - _local_4)));
                    this._vScrollbar.unitIncrement = this._viewSource.verticalUnitIncrement;
                    this._vScrollbar.blockIncrement = this._viewSource.verticalBlockIncrement;
                    this._vScrollbar.getModel().setRangeProperties(_local_6, _local_4, 0, _local_5, false);
                };
                if (this._hScrollbar != null)
                {
                    _local_4 = _local_1.width;
                    _local_5 = _local_2.width;
                    _local_6 = Math.max(0, Math.min(_local_3.x, (_local_5 - _local_4)));
                    this._hScrollbar.unitIncrement = this._viewSource.horizontalUnitIncrement;
                    this._hScrollbar.blockIncrement = this._viewSource.horizontalBlockIncrement;
                    this._hScrollbar.getModel().setRangeProperties(_local_6, _local_4, 0, _local_5, false);
                };
                this.updateAutoHiddenScroll();
            };
        }

        private function updateAutoHiddenScroll():void
        {
            var _local_1:Rectangle;
            var _local_2:Rectangle;
            var _local_3:Rectangle;
            var _local_4:Rectangle;
            if (((this._vScrollbar == null) && (this._hScrollbar == null)))
            {
                return;
            };
            if (this._vScrollbar != null)
            {
                if (this._vScrollProxy == AUTO)
                {
                    this._vScrollbar.visible = this._vScrollbar.getThumbVisible();
                };
                if (((this._vScrollProxy == AUTO) && (this._vScrollbar.maximum == 0)))
                {
                    this._vScrollbar.visible = false;
                };
            };
            if (this._hScrollbar)
            {
                if (this._hScrollProxy == AUTO)
                {
                    this._hScrollbar.visible = this._hScrollbar.getThumbVisible();
                };
                if (((this._hScrollProxy == AUTO) && (this._hScrollbar.maximum == 0)))
                {
                    this._hScrollbar.visible = false;
                };
            };
            if (((this._vScrollProxy == AUTO) || (this._hScrollProxy == AUTO)))
            {
                _local_2 = this._viewportInnerRect.getInnerRect(_width, _height);
                if (this._vScrollbarInnerRect)
                {
                    _local_3 = this._vScrollbarInnerRect.getInnerRect(_width, _height);
                };
                if (this._hScrollbarInnerRect)
                {
                    _local_4 = this._hScrollbarInnerRect.getInnerRect(_width, _height);
                };
                if (this._vScrollbar != null)
                {
                    if (((!(this._vScrollbar.getThumbVisible())) || (this._vScrollbar.visible == false)))
                    {
                        _local_1 = _local_2.union(_local_3);
                    };
                };
                if (this._hScrollbar != null)
                {
                    if (((!(this._hScrollbar.getThumbVisible())) || (this._hScrollbar.visible == false)))
                    {
                        if (_local_1)
                        {
                            _local_1 = _local_1.union(_local_4);
                        }
                        else
                        {
                            _local_1 = _local_2.union(_local_4);
                        };
                    };
                };
                if (_local_1 == null)
                {
                    _local_1 = _local_2;
                };
                this._viewSource.x = _local_1.x;
                this._viewSource.y = _local_1.y;
                this._viewSource.width = _local_1.width;
                this._viewSource.height = _local_1.height;
            };
        }


    }
}//package com.pickgliss.ui.controls

