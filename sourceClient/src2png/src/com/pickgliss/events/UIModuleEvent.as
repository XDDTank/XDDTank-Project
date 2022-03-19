// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.events.UIModuleEvent

package com.pickgliss.events
{
    import flash.events.Event;
    import com.pickgliss.loader.BaseLoader;

    public class UIModuleEvent extends Event 
    {

        public static const UI_MODULE_COMPLETE:String = "uiModuleComplete";
        public static const UI_MODULE_ERROR:String = "uiModuleError";
        public static const UI_MODULE_PROGRESS:String = "uiMoudleProgress";

        public var module:String;
        public var loader:BaseLoader;
        public var state:String;

        public function UIModuleEvent(_arg_1:String, _arg_2:BaseLoader=null)
        {
            this.loader = _arg_2;
            this.module = _arg_2.loadProgressMessage;
            this.state = _arg_2.loadCompleteMessage;
            super(_arg_1);
        }

    }
}//package com.pickgliss.events

