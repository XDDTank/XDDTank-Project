// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.ui.image.Image

package com.pickgliss.ui.image
{
    import com.pickgliss.ui.core.Component;
    import flash.display.DisplayObject;
    import com.pickgliss.utils.ObjectUtils;
    import com.pickgliss.ui.ComponentFactory;
    import flash.geom.Rectangle;

    public class Image extends Component 
    {

        public static const BITMAP_IMAGE:int = 1;
        public static const COMPONENT_IMAGE:int = 0;
        public static const P_frameFilters:String = "frameFilters";
        public static const P_reourceLink:String = "resourceLink";
        public static const P_scale9Grid:String = "scale9Grid";

        protected var _display:DisplayObject;
        protected var _filterString:String;
        protected var _frameFilter:Array;
        protected var _resourceLink:String;
        protected var _scaleGridArgs:Array;
        protected var _scaleGridString:String;


        override public function dispose():void
        {
            ObjectUtils.disposeObject(this._display);
            this._display = null;
            this._frameFilter = null;
            super.dispose();
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

        public function get resourceLink():String
        {
            return (this._resourceLink);
        }

        public function set resourceLink(_arg_1:String):void
        {
            if (_arg_1 == this._resourceLink)
            {
                return;
            };
            this._resourceLink = _arg_1;
            onPropertiesChanged(P_reourceLink);
        }

        public function get scaleGridString():String
        {
            return (this._scaleGridString);
        }

        public function set scaleGridString(_arg_1:String):void
        {
            if (_arg_1 == this._scaleGridString)
            {
                return;
            };
            this._scaleGridString = _arg_1;
            this._scaleGridArgs = ComponentFactory.parasArgs(this._scaleGridString);
            onPropertiesChanged(P_scale9Grid);
        }

        public function setFrame(_arg_1:int):void
        {
            if ((((this._frameFilter == null) || (_arg_1 <= 0)) || (_arg_1 > this._frameFilter.length)))
            {
                return;
            };
            filters = this._frameFilter[(_arg_1 - 1)];
        }

        override protected function addChildren():void
        {
            if (this._display)
            {
                addChild(this._display);
            };
        }

        public function get display():DisplayObject
        {
            return (this._display);
        }

        override protected function onProppertiesUpdate():void
        {
            super.onProppertiesUpdate();
            if (_changedPropeties[P_reourceLink])
            {
                this.resetDisplay();
            };
            this.updateSize();
            if (_changedPropeties[P_scale9Grid])
            {
                this.updateScale9Grid();
            };
            if (((_changedPropeties[P_frameFilters]) || (_changedPropeties[P_reourceLink])))
            {
                this.setFilters();
            };
        }

        protected function resetDisplay():void
        {
            if (this._display)
            {
                removeChild(this._display);
            };
            this._display = ComponentFactory.Instance.creat(this._resourceLink);
            _width = this._display.width;
            _height = this._display.height;
            _changedPropeties[Component.P_height] = true;
            _changedPropeties[Component.P_width] = true;
        }

        protected function setFilters():void
        {
            if (((this._frameFilter) && (this._display)))
            {
                this._display.filters = this._frameFilter[0];
            };
        }

        protected function updateScale9Grid():void
        {
            var _local_1:Rectangle = new Rectangle(0, 0, this._display.width, this._display.height);
            _local_1.left = this._scaleGridArgs[0];
            _local_1.top = this._scaleGridArgs[1];
            _local_1.right = this._scaleGridArgs[2];
            _local_1.bottom = this._scaleGridArgs[3];
            this._display.scale9Grid = _local_1;
        }

        protected function updateSize():void
        {
            if (_changedPropeties[Component.P_width])
            {
                this._display.width = _width;
            };
            if (_changedPropeties[Component.P_height])
            {
                this._display.height = _height;
            };
        }


    }
}//package com.pickgliss.ui.image

