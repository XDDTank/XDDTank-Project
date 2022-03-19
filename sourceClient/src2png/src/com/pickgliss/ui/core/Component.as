// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.ui.core.Component

package com.pickgliss.ui.core
{
    import flash.display.Sprite;
    import flash.display.BitmapData;
    import flash.utils.Dictionary;
    import flash.display.DisplayObject;
    import flash.geom.Point;
    import com.pickgliss.utils.ObjectUtils;
    import com.pickgliss.ui.ShowTipManager;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.events.ComponentEvent;

    [Event(name="propertiesChanged", type="com.pickgliss.events.ComponentEvent")]
    [Event(name="dispose", type="com.pickgliss.events.ComponentEvent")]
    public class Component extends Sprite implements Disposeable, ITipedDisplay 
    {

        public static const P_height:String = "height";
        public static const P_tipData:String = "tipData";
        public static const P_tipDirction:String = "tipDirction";
        public static const P_tipGap:String = "tipGap";
        public static const P_tipStyle:String = "tipStyle";
        public static const P_width:String = "width";

        protected var _bitmapdata:BitmapData;
        protected var _changeCount:int = 0;
        protected var _changedPropeties:Dictionary = new Dictionary();
        protected var _height:Number = 0;
        protected var _id:int = -1;
        protected var _tipData:Object;
        protected var _tipDirction:String;
        protected var _tipGapV:int;
        protected var _tipGapH:int;
        protected var _tipStyle:String;
        protected var _width:Number = 0;
        public var stylename:String;

        public function Component()
        {
            this.init();
        }

        public function asDisplayObject():DisplayObject
        {
            return (this);
        }

        public function beginChanges():void
        {
            this._changeCount++;
        }

        public function commitChanges():void
        {
            this._changeCount--;
            this.invalidate();
        }

        public function getMousePosition():Point
        {
            return (new Point(mouseX, mouseY));
        }

        public function dispose():void
        {
            this._changedPropeties = null;
            ObjectUtils.disposeObject(this._bitmapdata);
            if (parent)
            {
                parent.removeChild(this);
            };
            ShowTipManager.Instance.removeTip(this);
            ComponentFactory.Instance.removeComponent(this._id);
            dispatchEvent(new ComponentEvent(ComponentEvent.DISPOSE));
        }

        public function draw():void
        {
            this.onProppertiesUpdate();
            this.addChildren();
            dispatchEvent(new ComponentEvent(ComponentEvent.PROPERTIES_CHANGED, this._changedPropeties));
            this._changedPropeties = new Dictionary(true);
        }

        public function getBitmapdata(_arg_1:Boolean=false):BitmapData
        {
            if (((this._bitmapdata == null) || (_arg_1)))
            {
                ObjectUtils.disposeObject(this._bitmapdata);
                this._bitmapdata = new BitmapData(this._width, this._height, true, 0xFF0000);
                this._bitmapdata.draw(this);
            };
            return (this._bitmapdata);
        }

        override public function get height():Number
        {
            return (this._height);
        }

        override public function set height(_arg_1:Number):void
        {
            if (_arg_1 == this._height)
            {
                return;
            };
            this._height = _arg_1;
            this.onPropertiesChanged(P_height);
        }

        public function get id():int
        {
            return (this._id);
        }

        public function set id(_arg_1:int):void
        {
            this._id = _arg_1;
        }

        public function move(_arg_1:Number, _arg_2:Number):void
        {
            this.x = _arg_1;
            this.y = _arg_2;
        }

        public function get tipData():Object
        {
            return (this._tipData);
        }

        public function set tipData(_arg_1:Object):void
        {
            if (this._tipData == _arg_1)
            {
                return;
            };
            this._tipData = _arg_1;
            this.onPropertiesChanged(P_tipData);
        }

        public function get tipDirctions():String
        {
            return (this._tipDirction);
        }

        public function set tipDirctions(_arg_1:String):void
        {
            if (this._tipDirction == _arg_1)
            {
                return;
            };
            this._tipDirction = _arg_1;
            this.onPropertiesChanged(P_tipDirction);
        }

        public function get tipGapV():int
        {
            return (this._tipGapV);
        }

        public function set tipGapV(_arg_1:int):void
        {
            if (this._tipGapV == _arg_1)
            {
                return;
            };
            this._tipGapV = _arg_1;
            this.onPropertiesChanged(P_tipGap);
        }

        public function get tipGapH():int
        {
            return (this._tipGapH);
        }

        public function set tipGapH(_arg_1:int):void
        {
            if (this._tipGapH == _arg_1)
            {
                return;
            };
            this._tipGapH = _arg_1;
            this.onPropertiesChanged(P_tipGap);
        }

        public function get tipStyle():String
        {
            return (this._tipStyle);
        }

        public function set tipStyle(_arg_1:String):void
        {
            if (this._tipStyle == _arg_1)
            {
                return;
            };
            this._tipStyle = _arg_1;
            this.onPropertiesChanged(P_tipStyle);
        }

        override public function get width():Number
        {
            return (this._width);
        }

        override public function set width(_arg_1:Number):void
        {
            if (_arg_1 == this._width)
            {
                return;
            };
            this._width = _arg_1;
            this.onPropertiesChanged(P_width);
        }

        override public function set x(_arg_1:Number):void
        {
            super.x = Math.round(_arg_1);
            this.onPosChanged();
        }

        override public function set y(_arg_1:Number):void
        {
            super.y = Math.round(_arg_1);
            this.onPosChanged();
        }

        protected function addChildren():void
        {
        }

        protected function init():void
        {
            this.addChildren();
        }

        protected function invalidate():void
        {
            if (this._changeCount <= 0)
            {
                this._changeCount = 0;
                this.draw();
            };
        }

        protected function onPropertiesChanged(_arg_1:String=null):void
        {
            if (this._changedPropeties[_arg_1])
            {
                return;
            };
            if (_arg_1 != null)
            {
                this._changedPropeties[_arg_1] = true;
            };
            this.invalidate();
        }

        protected function onProppertiesUpdate():void
        {
            if (((((this._changedPropeties[P_tipDirction]) || (this._changedPropeties[P_tipGap])) || (this._changedPropeties[P_tipStyle])) || (this._changedPropeties[P_tipData])))
            {
                ShowTipManager.Instance.addTip(this);
            };
        }

        public function get displayWidth():Number
        {
            return (super.width);
        }

        public function get displayHeight():Number
        {
            return (super.height);
        }

        protected function onPosChanged():void
        {
        }


    }
}//package com.pickgliss.ui.core

