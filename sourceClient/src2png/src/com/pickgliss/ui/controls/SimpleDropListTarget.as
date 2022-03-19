// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.ui.controls.SimpleDropListTarget

package com.pickgliss.ui.controls
{
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.controls.list.IDropListTarget;
    import flash.display.DisplayObject;

    public class SimpleDropListTarget extends FilterFrameText implements IDropListTarget 
    {


        public function setValue(_arg_1:*):void
        {
            text = String(_arg_1);
        }

        public function setCursor(_arg_1:int):void
        {
            setSelection(_arg_1, _arg_1);
        }

        public function getValueLength():int
        {
            return (text.length);
        }

        public function asDisplayObject():DisplayObject
        {
            return (this);
        }


    }
}//package com.pickgliss.ui.controls

