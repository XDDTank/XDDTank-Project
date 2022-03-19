// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.events.FightPropEevnt

package ddt.events
{
    import flash.events.Event;

    public class FightPropEevnt extends Event 
    {

        public static const MODECHANGED:String = "mode_Changed";
        public static const USEPROP:String = "use";
        public static const DELETEPROP:String = "delete";
        public static const ENABLEDCHANGED:String = "enabled_Changed";

        public function FightPropEevnt(_arg_1:String, _arg_2:Boolean=false, _arg_3:Boolean=false)
        {
            super(_arg_1, _arg_2, _arg_3);
        }

    }
}//package ddt.events

