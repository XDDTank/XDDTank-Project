// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.ui.controls.DisplayObjectViewport

package com.pickgliss.ui.controls
{
    import com.pickgliss.ui.core.Component;
    import com.pickgliss.ui.core.IViewprot;
    import com.pickgliss.ui.ComponentSetting;
    import flash.display.Shape;
    import com.pickgliss.geom.IntPoint;
    import flash.display.DisplayObject;
    import com.pickgliss.events.InteractiveEvent;
    import com.pickgliss.events.ComponentEvent;
    import com.pickgliss.utils.ObjectUtils;
    import com.pickgliss.geom.IntDimension;
    import com.pickgliss.geom.IntRectangle;

    public class DisplayObjectViewport extends Component implements IViewprot 
    {

        public static const P_horizontalBlockIncrement:String = "horizontalBlockIncrement";
        public static const P_horizontalUnitIncrement:String = "horizontalUnitIncrement";
        public static const P_verticalBlockIncrement:String = "verticalBlockIncrement";
        public static const P_verticalUnitIncrement:String = "verticalUnitIncrement";
        public static const P_view:String = "view";
        public static const P_viewPosition:String = "viewPosition";

        protected var _horizontalBlockIncrement:int = ComponentSetting.SCROLL_BLOCK_INCREMENT;
        protected var _horizontalUnitIncrement:int = ComponentSetting.SCROLL_UINT_INCREMENT;
        protected var _maskShape:Shape;
        protected var _mouseActiveObjectShape:Shape;
        protected var _verticalBlockIncrement:int = ComponentSetting.SCROLL_BLOCK_INCREMENT;
        protected var _verticalUnitIncrement:int = ComponentSetting.SCROLL_UINT_INCREMENT;
        protected var _viewHeight:int;
        protected var _viewPosition:IntPoint;
        protected var _viewWidth:int;
        private var _view:DisplayObject;


        public function addStateListener(_arg_1:Function, _arg_2:int=0, _arg_3:Boolean=false):void
        {
            addEventListener(InteractiveEvent.STATE_CHANGED, _arg_1);
        }

        override public function dispose():void
        {
            if ((this._view is Component))
            {
                Component(this._view).removeEventListener(ComponentEvent.PROPERTIES_CHANGED, this.__onResize);
            };
            ObjectUtils.disposeObject(this._view);
            this._view = null;
            if (this._mouseActiveObjectShape)
            {
                ObjectUtils.disposeObject(this._mouseActiveObjectShape);
            };
            this._mouseActiveObjectShape = null;
            if (this._maskShape)
            {
                ObjectUtils.disposeObject(this._maskShape);
            };
            this._maskShape = null;
            super.dispose();
        }

        public function getExtentSize():IntDimension
        {
            return (new IntDimension(_width, _height));
        }

        public function getViewSize():IntDimension
        {
            return (new IntDimension(this._viewWidth, this._viewHeight));
        }

        public function getViewportPane():Component
        {
            return (this);
        }

        public function get horizontalBlockIncrement():int
        {
            return (this._horizontalBlockIncrement);
        }

        public function set horizontalBlockIncrement(_arg_1:int):void
        {
            if (this._horizontalBlockIncrement == _arg_1)
            {
                return;
            };
            this._horizontalBlockIncrement = _arg_1;
            onPropertiesChanged(P_horizontalBlockIncrement);
        }

        public function get horizontalUnitIncrement():int
        {
            return (this._horizontalUnitIncrement);
        }

        public function set horizontalUnitIncrement(_arg_1:int):void
        {
            if (this._horizontalUnitIncrement == _arg_1)
            {
                return;
            };
            this._horizontalUnitIncrement = _arg_1;
            onPropertiesChanged(P_horizontalUnitIncrement);
        }

        public function removeStateListener(_arg_1:Function):void
        {
            removeEventListener(InteractiveEvent.STATE_CHANGED, _arg_1);
        }

        public function scrollRectToVisible(_arg_1:IntRectangle):void
        {
            this.viewPosition = new IntPoint(_arg_1.x, _arg_1.y);
        }

        public function setView(_arg_1:DisplayObject):void
        {
            if (this._view == _arg_1)
            {
                return;
            };
            if ((this._view is Component))
            {
                Component(this._view).removeEventListener(ComponentEvent.PROPERTIES_CHANGED, this.__onResize);
            };
            if (this._view)
            {
                ObjectUtils.disposeObject(this._view);
            };
            this._view = _arg_1;
            if ((this._view is Component))
            {
                Component(this._view).addEventListener(ComponentEvent.PROPERTIES_CHANGED, this.__onResize);
            };
            onPropertiesChanged(P_view);
        }

        public function setViewportTestSize(_arg_1:IntDimension):void
        {
        }

        public function get verticalBlockIncrement():int
        {
            return (this._verticalBlockIncrement);
        }

        public function set verticalBlockIncrement(_arg_1:int):void
        {
            if (this._verticalBlockIncrement == _arg_1)
            {
                return;
            };
            this._verticalBlockIncrement = _arg_1;
            onPropertiesChanged(P_verticalBlockIncrement);
        }

        public function get verticalUnitIncrement():int
        {
            return (this._verticalUnitIncrement);
        }

        public function set verticalUnitIncrement(_arg_1:int):void
        {
            if (this._verticalUnitIncrement == _arg_1)
            {
                return;
            };
            this._verticalUnitIncrement = _arg_1;
            onPropertiesChanged(P_verticalUnitIncrement);
        }

        public function get viewPosition():IntPoint
        {
            return (this._viewPosition);
        }

        public function set viewPosition(_arg_1:IntPoint):void
        {
            if (this._viewPosition.equals(_arg_1))
            {
                return;
            };
            this._viewPosition.setLocation(_arg_1);
            onPropertiesChanged(P_viewPosition);
        }

        public function invalidateView():void
        {
            onPropertiesChanged(P_view);
        }

        override protected function addChildren():void
        {
            super.addChildren();
            addChild(this._mouseActiveObjectShape);
            addChild(this._maskShape);
        }

        protected function creatMaskShape():void
        {
            this._maskShape = new Shape();
            this._maskShape.graphics.beginFill(0xFF0000, 1);
            this._maskShape.graphics.drawRect(0, 0, 100, 100);
            this._maskShape.graphics.endFill();
            this._mouseActiveObjectShape = new Shape();
            this._mouseActiveObjectShape.graphics.beginFill(0xFF0000, 0);
            this._mouseActiveObjectShape.graphics.drawRect(0, 0, 100, 100);
            this._mouseActiveObjectShape.graphics.endFill();
        }

        protected function fireStateChanged(_arg_1:Boolean=true):void
        {
            dispatchEvent(new InteractiveEvent(InteractiveEvent.STATE_CHANGED));
        }

        protected function getViewMaxPos():IntPoint
        {
            var _local_1:IntDimension = this.getExtentSize();
            var _local_2:IntDimension = this.getViewSize();
            var _local_3:IntPoint = new IntPoint((_local_2.width - _local_1.width), (_local_2.height - _local_1.height));
            if (_local_3.x < 0)
            {
                _local_3.x = 0;
            };
            if (_local_3.y < 0)
            {
                _local_3.y = 0;
            };
            return (_local_3);
        }

        override protected function init():void
        {
            this.creatMaskShape();
            this._viewPosition = new IntPoint(0, 0);
            super.init();
        }

        override protected function onProppertiesUpdate():void
        {
            super.onProppertiesUpdate();
            if (((_changedPropeties[Component.P_height]) || (_changedPropeties[Component.P_width])))
            {
                this.updateShowMask();
            };
            if (((_changedPropeties[P_view]) || (_changedPropeties[P_viewPosition])))
            {
                this._viewWidth = this._view.width;
                this._viewHeight = this._view.height;
                addChild(this._view);
                this._view.mask = this._maskShape;
                this.updatePos();
                this.fireStateChanged();
            };
        }

        protected function restrictionViewPos(_arg_1:IntPoint):IntPoint
        {
            var _local_2:IntPoint = this.getViewMaxPos();
            _arg_1.x = Math.max(0, Math.min(_local_2.x, _arg_1.x));
            _arg_1.y = Math.max(0, Math.min(_local_2.y, _arg_1.y));
            return (_arg_1);
        }

        protected function updatePos():void
        {
            this.restrictionViewPos(this._viewPosition);
            this._view.x = -(this._viewPosition.x);
            this._view.y = -(this._viewPosition.y);
        }

        protected function updateShowMask():void
        {
            this._mouseActiveObjectShape.width = (this._maskShape.width = _width);
            this._mouseActiveObjectShape.height = (this._maskShape.height = _height);
        }

        private function __onResize(_arg_1:ComponentEvent):void
        {
            if (((_arg_1.changedProperties[Component.P_height]) || (_arg_1.changedProperties[Component.P_width])))
            {
                onPropertiesChanged(P_view);
            };
        }


    }
}//package com.pickgliss.ui.controls

