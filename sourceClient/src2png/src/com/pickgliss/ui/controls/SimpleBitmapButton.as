// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.ui.controls.SimpleBitmapButton

package com.pickgliss.ui.controls
{
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.ui.ComponentSetting;

    public class SimpleBitmapButton extends BaseButton 
    {

        public function SimpleBitmapButton()
        {
            _frameFilter = ComponentFactory.Instance.creatFrameFilters(ComponentSetting.SIMPLE_BITMAP_BUTTON_FILTER);
        }

        override public function set backStyle(_arg_1:String):void
        {
            if (_arg_1 == _backStyle)
            {
                return;
            };
            _backStyle = _arg_1;
            backgound = ComponentFactory.Instance.creat(_arg_1);
            _width = _back.width;
            _height = _back.height;
            onPropertiesChanged(P_backStyle);
        }


    }
}//package com.pickgliss.ui.controls

