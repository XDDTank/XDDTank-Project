// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//totem.data.TotemEvent

package totem.data
{
    import flash.events.Event;

    public class TotemEvent extends Event 
    {

        public static const TOTEM_UPDATE:String = "totemUpdate";

        public function TotemEvent(_arg_1:String, _arg_2:Boolean=false, _arg_3:Boolean=false)
        {
            super(_arg_1, _arg_2, _arg_3);
        }

    }
}//package totem.data

