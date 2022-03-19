// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.events.StartupEvent

package ddt.events
{
    import flash.events.Event;

    public class StartupEvent extends Event 
    {

        public static const CORE_LOAD_COMPLETE:String = "coreUILoadComplete";
        public static const CORE_SETUP_COMPLETE:String = "coreSetupLoadComplete";
        public static const ROLE_DATE_COMPLETE:String = "roleDataComplete";

        public function StartupEvent(_arg_1:String)
        {
            super(_arg_1);
        }

    }
}//package ddt.events

