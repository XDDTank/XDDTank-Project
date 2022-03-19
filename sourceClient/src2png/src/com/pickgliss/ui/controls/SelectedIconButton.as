// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.ui.controls.SelectedIconButton

package com.pickgliss.ui.controls
{
    import flash.display.DisplayObject;
    import com.pickgliss.geom.InnerRectangle;
    import flash.events.Event;
    import com.pickgliss.utils.ObjectUtils;
    import com.pickgliss.utils.ClassUtils;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.ui.core.Component;
    import com.pickgliss.utils.DisplayUtils;

    public class SelectedIconButton extends SelectedButton 
    {

        public static const P_icon:String = "icon";
        public static const P_iconInnerRect:String = "iconInnerRect";

        protected var _selectedIcon:DisplayObject;
        protected var _selectedIconInnerRect:InnerRectangle;
        protected var _selectedIconInnerRectString:String;
        protected var _selectedIconStyle:String;
        protected var _unselectedIcon:DisplayObject;
        protected var _unselectedIconInnerRect:InnerRectangle;
        protected var _unselectedIconInnerRectString:String;
        protected var _unselectedIconStyle:String;


        override public function dispose():void
        {
            super.dispose();
        }

        override public function set selected(_arg_1:Boolean):void
        {
            _selected = _arg_1;
            if (_selectedButton)
            {
                _selectedButton.visible = _selected;
            };
            if (_unSelectedButton)
            {
                _unSelectedButton.visible = (!(_selected));
            };
            if (this._selectedIcon)
            {
                this._selectedIcon.visible = _selected;
            };
            if (this._unselectedIcon)
            {
                this._unselectedIcon.visible = (!(_selected));
            };
            dispatchEvent(new Event(Event.SELECT));
            drawHitArea();
        }

        public function set selectedIcon(_arg_1:DisplayObject):void
        {
            if (this._selectedIcon == _arg_1)
            {
                return;
            };
            ObjectUtils.disposeObject(this._selectedIcon);
            this._selectedIcon = _arg_1;
            onPropertiesChanged(P_icon);
        }

        public function set selectedIconInnerRectString(_arg_1:String):void
        {
            if (this._selectedIconInnerRectString == _arg_1)
            {
                return;
            };
            this._selectedIconInnerRectString = _arg_1;
            this._selectedIconInnerRect = ClassUtils.CreatInstance(ClassUtils.INNERRECTANGLE, ComponentFactory.parasArgs(this._selectedIconInnerRectString));
            onPropertiesChanged(P_iconInnerRect);
        }

        public function set selectedIconStyle(_arg_1:String):void
        {
            if (this._selectedIconStyle == _arg_1)
            {
                return;
            };
            this._selectedIconStyle = _arg_1;
            this._selectedIcon = ComponentFactory.Instance.creat(this._selectedIconStyle);
        }

        public function set unselectedIcon(_arg_1:DisplayObject):void
        {
            if (this._unselectedIcon == _arg_1)
            {
                return;
            };
            ObjectUtils.disposeObject(this._unselectedIcon);
            this._unselectedIcon = _arg_1;
            onPropertiesChanged(P_icon);
        }

        public function set unselectedIconInnerRectString(_arg_1:String):void
        {
            if (this._unselectedIconInnerRectString == _arg_1)
            {
                return;
            };
            this._unselectedIconInnerRectString = _arg_1;
            this._unselectedIconInnerRect = ClassUtils.CreatInstance(ClassUtils.INNERRECTANGLE, ComponentFactory.parasArgs(this._unselectedIconInnerRectString));
            onPropertiesChanged(P_iconInnerRect);
        }

        public function set unselectedIconStyle(_arg_1:String):void
        {
            if (this._unselectedIconStyle == _arg_1)
            {
                return;
            };
            this._unselectedIconStyle = _arg_1;
            this._unselectedIcon = ComponentFactory.Instance.creat(this._unselectedIconStyle);
        }

        override protected function addChildren():void
        {
            super.addChildren();
            if (this._selectedIcon)
            {
                addChild(this._selectedIcon);
            };
            if (this._unselectedIcon)
            {
                addChild(this._unselectedIcon);
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

        override public function setFrame(_arg_1:int):void
        {
            super.setFrame(_arg_1);
            DisplayUtils.setFrame(this._selectedIcon, _arg_1);
            DisplayUtils.setFrame(this._unselectedIcon, _arg_1);
        }

        protected function updateIconPos():void
        {
            if (((this._unselectedIcon) && (this._unselectedIconInnerRect)))
            {
                DisplayUtils.layoutDisplayWithInnerRect(this._unselectedIcon, this._unselectedIconInnerRect, _width, _height);
            };
            if (((this._selectedIcon) && (this._selectedIconInnerRect)))
            {
                DisplayUtils.layoutDisplayWithInnerRect(this._selectedIcon, this._selectedIconInnerRect, _width, _height);
            };
        }


    }
}//package com.pickgliss.ui.controls

