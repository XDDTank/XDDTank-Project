// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.loader.LoadInterfaceEvent

package com.pickgliss.loader
{
    import flash.events.Event;

    public class LoadInterfaceEvent extends Event 
    {

        public static const CHECK_COMPLETE:String = "checkComplete";
        public static const DELETE_COMPLETE:String = "deleteComplete";
        public static const FLASH_GOTO_AND_PLAY:String = "flashGotoAndPlay";
        public static const SET_SOUND:String = "setSound";

        public var paras:Array;

        public function LoadInterfaceEvent(_arg_1:String, _arg_2:Array)
        {
            this.paras = _arg_2;
            super(_arg_1);
        }

    }
}//package com.pickgliss.loader

