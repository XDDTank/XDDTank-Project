// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.ui.controls.list.IDropListTarget

package com.pickgliss.ui.controls.list
{
    import flash.display.IDisplayObject;

    public interface IDropListTarget extends IDisplayObject 
    {

        function setCursor(_arg_1:int):void;
        function get caretIndex():int;
        function setValue(_arg_1:*):void;
        function getValueLength():int;

    }
}//package com.pickgliss.ui.controls.list

