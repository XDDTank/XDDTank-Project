// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.ui.core.ITipedDisplay

package com.pickgliss.ui.core
{
    import flash.display.IDisplayObject;

    public interface ITipedDisplay extends IDisplayObject 
    {

        function get tipData():Object;
        function set tipData(_arg_1:Object):void;
        function get tipDirctions():String;
        function set tipDirctions(_arg_1:String):void;
        function get tipGapH():int;
        function set tipGapH(_arg_1:int):void;
        function get tipGapV():int;
        function set tipGapV(_arg_1:int):void;
        function get tipStyle():String;
        function set tipStyle(_arg_1:String):void;

    }
}//package com.pickgliss.ui.core

