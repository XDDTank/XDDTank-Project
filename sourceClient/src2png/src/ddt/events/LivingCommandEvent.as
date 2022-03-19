// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.events.LivingCommandEvent

package ddt.events
{
    import flash.events.Event;

    public class LivingCommandEvent extends Event 
    {

        public static const COMMAND:String = "livingCommand";

        private var _cmdType:String;
        private var _cmdObj:Object;

        public function LivingCommandEvent(_arg_1:String, _arg_2:Object=null, _arg_3:String="livingCommand", _arg_4:Boolean=false, _arg_5:Boolean=false)
        {
            super(_arg_3, _arg_4, _arg_5);
            this._cmdType = _arg_1;
            this._cmdObj = _arg_2;
        }

        public function get commandType():String
        {
            return (this._cmdType);
        }

        public function get object():Object
        {
            return (this._cmdObj);
        }


    }
}//package ddt.events

