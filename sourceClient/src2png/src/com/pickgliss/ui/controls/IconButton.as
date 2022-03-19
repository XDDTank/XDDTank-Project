// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.ui.controls.IconButton

package com.pickgliss.ui.controls
{
    import flash.display.DisplayObject;
    import com.pickgliss.geom.InnerRectangle;
    import com.pickgliss.utils.ObjectUtils;
    import com.pickgliss.utils.ClassUtils;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.ui.core.Component;
    import com.pickgliss.utils.DisplayUtils;

    public class IconButton extends TextButton 
    {

        public static const P_icon:String = "icon";
        public static const P_iconInnerRect:String = "iconInnerRect";

        protected var _icon:DisplayObject;
        protected var _iconInnerRect:InnerRectangle;
        protected var _iconInnerRectString:String;
        protected var _iconStyle:String;


        override public function dispose():void
        {
            if (this._icon)
            {
                ObjectUtils.disposeObject(this._icon);
            };
            this._icon = null;
            super.dispose();
        }

        public function set icon(_arg_1:DisplayObject):void
        {
            if (this._icon == _arg_1)
            {
                return;
            };
            ObjectUtils.disposeObject(this._icon);
            this._icon = _arg_1;
            onPropertiesChanged(P_icon);
        }

        public function set iconInnerRectString(_arg_1:String):void
        {
            if (this._iconInnerRectString == _arg_1)
            {
                return;
            };
            this._iconInnerRectString = _arg_1;
            this._iconInnerRect = ClassUtils.CreatInstance(ClassUtils.INNERRECTANGLE, ComponentFactory.parasArgs(this._iconInnerRectString));
            onPropertiesChanged(P_iconInnerRect);
        }

        public function set iconStyle(_arg_1:String):void
        {
            if (this._iconStyle == _arg_1)
            {
                return;
            };
            this._iconStyle = _arg_1;
            this.icon = ComponentFactory.Instance.creat(this._iconStyle);
        }

        override protected function addChildren():void
        {
            super.addChildren();
            if (this._icon)
            {
                addChild(this._icon);
            };
        }

        override protected function onProppertiesUpdate():void
        {
            super.onProppertiesUpdate();
            if (((((_changedPropeties[Component.P_width]) || (_changedPropeties[Component.P_height])) || (_changedPropeties[P_iconInnerRect])) || (_changedPropeties[P_icon])))
            {
                this.updateIconPos();
            };
        }

        protected function updateIconPos():void
        {
            if (((this._icon) && (this._iconInnerRect)))
            {
                DisplayUtils.layoutDisplayWithInnerRect(this._icon, this._iconInnerRect, _width, _height);
            };
        }

        override public function setFrame(_arg_1:int):void
        {
            super.setFrame(_arg_1);
            DisplayUtils.setFrame(this._icon, _arg_1);
        }


    }
}//package com.pickgliss.ui.controls

