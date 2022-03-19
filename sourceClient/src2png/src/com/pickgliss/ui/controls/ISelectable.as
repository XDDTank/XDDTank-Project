// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.ui.controls.ISelectable

package com.pickgliss.ui.controls
{
    import flash.display.IDisplayObject;

    [Event(name="click", type="flash.events.MouseEvent")]
    public interface ISelectable extends IDisplayObject 
    {

        function set autoSelect(_arg_1:Boolean):void;
        function get selected():Boolean;
        function set selected(_arg_1:Boolean):void;

    }
}//package com.pickgliss.ui.controls

