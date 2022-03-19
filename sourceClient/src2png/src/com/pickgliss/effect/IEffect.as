// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.effect.IEffect

package com.pickgliss.effect
{
    import com.pickgliss.ui.core.Disposeable;
    import flash.display.DisplayObject;

    public interface IEffect extends Disposeable 
    {

        function initEffect(_arg_1:DisplayObject, _arg_2:Array):void;
        function stop():void;
        function play():void;
        function get target():DisplayObject;
        function get id():int;
        function set id(_arg_1:int):void;

    }
}//package com.pickgliss.effect

