// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//road7th.data.DictionaryEvent

package road7th.data
{
    import flash.events.Event;

    public class DictionaryEvent extends Event 
    {

        public static const ADD:String = "add";
        public static const UPDATE:String = "update";
        public static const REMOVE:String = "remove";
        public static const CLEAR:String = "clear";

        public var data:Object;

        public function DictionaryEvent(_arg_1:String, _arg_2:Object=null, _arg_3:Boolean=false, _arg_4:Boolean=false)
        {
            this.data = _arg_2;
            super(_arg_1, _arg_3, _arg_4);
        }

    }
}//package road7th.data

