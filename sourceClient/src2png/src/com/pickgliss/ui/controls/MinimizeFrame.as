// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.ui.controls.MinimizeFrame

package com.pickgliss.ui.controls
{
    import com.pickgliss.geom.InnerRectangle;
    import com.pickgliss.utils.ClassUtils;
    import com.pickgliss.ui.ComponentFactory;
    import flash.events.MouseEvent;
    import com.pickgliss.utils.ObjectUtils;
    import com.pickgliss.utils.DisplayUtils;
    import com.pickgliss.events.FrameEvent;

    public class MinimizeFrame extends Frame 
    {

        public static const P_minimizeButton:String = "minimizeButton";
        public static const P_minimizeRect:String = "minimizeInnerRect";

        protected var _minimizeButton:BaseButton;
        protected var _minimizeInnerRect:InnerRectangle;
        protected var _minimizeRectString:String;
        protected var _minimizeStyle:String;


        override protected function addChildren():void
        {
            super.addChildren();
            if (this._minimizeButton)
            {
                addChild(this._minimizeButton);
            };
        }

        public function set minimizeRectString(_arg_1:String):void
        {
            if (this._minimizeRectString == _arg_1)
            {
                return;
            };
            this._minimizeRectString = _arg_1;
            this._minimizeInnerRect = ClassUtils.CreatInstance(ClassUtils.INNERRECTANGLE, ComponentFactory.parasArgs(this._minimizeRectString));
            onPropertiesChanged(P_closeInnerRect);
        }

        public function get minimizeButton():BaseButton
        {
            return (this._minimizeButton);
        }

        public function set minimizeButton(_arg_1:BaseButton):void
        {
            if (this._minimizeButton == _arg_1)
            {
                return;
            };
            if (this._minimizeButton)
            {
                this._minimizeButton.removeEventListener(MouseEvent.CLICK, this.__onMinimizeClick);
                ObjectUtils.disposeObject(this._minimizeButton);
            };
            this._minimizeButton = _arg_1;
            onPropertiesChanged(P_minimizeButton);
        }

        public function set minimizeStyle(_arg_1:String):void
        {
            if (this._minimizeStyle == _arg_1)
            {
                return;
            };
            this._minimizeStyle = _arg_1;
            this.minimizeButton = ComponentFactory.Instance.creat(this._minimizeStyle);
        }

        protected function updateMinimizePos():void
        {
            if (((this._minimizeButton) && (this._minimizeInnerRect)))
            {
                DisplayUtils.layoutDisplayWithInnerRect(this._minimizeButton, this._minimizeInnerRect, _width, _height);
            };
        }

        override protected function onProppertiesUpdate():void
        {
            super.onProppertiesUpdate();
            if (_changedPropeties[P_minimizeButton])
            {
                this._minimizeButton.addEventListener(MouseEvent.CLICK, this.__onMinimizeClick);
            };
            if (((_changedPropeties[P_minimizeButton]) || (_changedPropeties[P_minimizeRect])))
            {
                this.updateMinimizePos();
            };
        }

        protected function __onMinimizeClick(_arg_1:MouseEvent):void
        {
            onResponse(FrameEvent.MINIMIZE_CLICK);
        }

        override public function dispose():void
        {
            super.dispose();
            if (this._minimizeButton)
            {
                this._minimizeButton.removeEventListener(MouseEvent.CLICK, this.__onMinimizeClick);
                ObjectUtils.disposeObject(this._minimizeButton);
            };
            this._minimizeButton = null;
        }


    }
}//package com.pickgliss.ui.controls

