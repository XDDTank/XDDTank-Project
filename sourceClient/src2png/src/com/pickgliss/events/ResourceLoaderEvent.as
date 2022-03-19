// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.events.ResourceLoaderEvent

package com.pickgliss.events
{
    import flash.events.Event;

    public class ResourceLoaderEvent extends Event 
    {

        public static const CORE_SETUP_COMPLETE:String = "coreSetupLoadComplete";
        public static const USER_DATA_COMPLETE:String = "userDataComplete";

        public function ResourceLoaderEvent(_arg_1:String)
        {
            super(_arg_1);
        }

    }
}//package com.pickgliss.events

