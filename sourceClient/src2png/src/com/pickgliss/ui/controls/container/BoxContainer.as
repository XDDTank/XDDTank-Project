// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.ui.controls.container.BoxContainer

package com.pickgliss.ui.controls.container
{
    import com.pickgliss.ui.core.Component;
    import __AS3__.vec.Vector;
    import flash.display.DisplayObject;
    import com.pickgliss.events.ComponentEvent;
    import com.pickgliss.utils.ObjectUtils;
    import __AS3__.vec.*;

    public class BoxContainer extends Component 
    {

        public static const P_childRefresh:String = "childRefresh";
        public static const P_childResize:String = "childResize";
        public static const P_isReverAdd:String = "isReverAdd";
        public static const P_spacing:String = "spacing";
        public static const P_strictSize:String = "strictSize";
        public static const P_autoSize:String = "autoSize";
        public static const LEFT_OR_TOP:int = 0;
        public static const RIGHT_OR_BOTTOM:int = 1;
        public static const CENTER:int = 2;

        protected var _childrenList:Vector.<DisplayObject> = new Vector.<DisplayObject>();
        protected var _isReverAdd:Boolean;
        protected var _spacing:Number = 0;
        protected var _strictSize:Number = -1;
        protected var _autoSize:int = 0;


        override public function addChild(_arg_1:DisplayObject):DisplayObject
        {
            if (this._childrenList.indexOf(_arg_1) > -1)
            {
                return (_arg_1);
            };
            if ((!(this._isReverAdd)))
            {
                this._childrenList.push(super.addChild(_arg_1));
            }
            else
            {
                this._childrenList.push(super.addChildAt(_arg_1, 0));
            };
            _arg_1.addEventListener(ComponentEvent.PROPERTIES_CHANGED, this.__onResize);
            onPropertiesChanged(P_childRefresh);
            return (_arg_1);
        }

        override public function dispose():void
        {
            this.disposeAllChildren();
            this._childrenList = null;
            super.dispose();
        }

        public function disposeAllChildren():void
        {
            var _local_2:DisplayObject;
            var _local_1:int;
            while (_local_1 < numChildren)
            {
                _local_2 = getChildAt(_local_1);
                _local_2.removeEventListener(ComponentEvent.PROPERTIES_CHANGED, this.__onResize);
                _local_1++;
            };
            ObjectUtils.disposeAllChildren(this);
        }

        public function set isReverAdd(_arg_1:Boolean):void
        {
            if (this._isReverAdd == _arg_1)
            {
                return;
            };
            this._isReverAdd = _arg_1;
            onPropertiesChanged(P_isReverAdd);
        }

        public function refreshChildPos():void
        {
            onPropertiesChanged(P_childResize);
        }

        override public function removeChild(_arg_1:DisplayObject):DisplayObject
        {
            _arg_1.removeEventListener(ComponentEvent.PROPERTIES_CHANGED, this.__onResize);
            this._childrenList.splice(this._childrenList.indexOf(_arg_1), 1);
            super.removeChild(_arg_1);
            onPropertiesChanged(P_childRefresh);
            return (_arg_1);
        }

        override public function removeChildAt(_arg_1:int):DisplayObject
        {
            var _local_2:DisplayObject = this._childrenList[_arg_1];
            _local_2.removeEventListener(ComponentEvent.PROPERTIES_CHANGED, this.__onResize);
            this._childrenList.splice(this._childrenList.indexOf(_local_2), 1);
            super.removeChild(_local_2);
            onPropertiesChanged(P_childRefresh);
            return (_local_2);
        }

        public function reverChildren():void
        {
            var _local_1:Vector.<DisplayObject> = new Vector.<DisplayObject>();
            while (numChildren > 0)
            {
                _local_1.push(this.removeChildAt(0));
            };
            var _local_2:int;
            while (_local_2 < _local_1.length)
            {
                this.addChild(_local_1[_local_2]);
                _local_2++;
            };
        }

        public function set autoSize(_arg_1:int):void
        {
            if (this._autoSize == _arg_1)
            {
                return;
            };
            this._autoSize = _arg_1;
            onPropertiesChanged(P_autoSize);
        }

        public function get spacing():Number
        {
            return (this._spacing);
        }

        public function set spacing(_arg_1:Number):void
        {
            if (this._spacing == _arg_1)
            {
                return;
            };
            this._spacing = _arg_1;
            onPropertiesChanged(P_spacing);
        }

        public function set strictSize(_arg_1:Number):void
        {
            if (this._strictSize == _arg_1)
            {
                return;
            };
            this._strictSize = _arg_1;
            onPropertiesChanged(P_strictSize);
        }

        public function arrange():void
        {
        }

        protected function get isStrictSize():Boolean
        {
            return (this._strictSize > 0);
        }

        override protected function onProppertiesUpdate():void
        {
            this.arrange();
        }

        private function __onResize(_arg_1:ComponentEvent):void
        {
            if (((_arg_1.changedProperties[Component.P_height]) || (_arg_1.changedProperties[Component.P_width])))
            {
                onPropertiesChanged(P_childRefresh);
            };
        }


    }
}//package com.pickgliss.ui.controls.container

