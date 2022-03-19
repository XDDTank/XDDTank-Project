// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//baglocked.SetPassEvent

package baglocked
{
    import flash.events.Event;

    public class SetPassEvent extends Event 
    {

        public static const CANCELBTN:String = "cancelBtn";
        public static const OKBTN:String = "okBtn";

        public var data:Object;

        public function SetPassEvent(_arg_1:String, _arg_2:Object=null, _arg_3:Boolean=false, _arg_4:Boolean=false)
        {
            super(_arg_1, _arg_3, _arg_4);
            this.data = _arg_2;
        }

    }
}//package baglocked

