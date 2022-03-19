// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//tank.events.ActionEvent

package tank.events
{
    import flash.events.Event;

    public class ActionEvent extends Event 
    {

        private var _param:int;

        public function ActionEvent(_arg_1:String, _arg_2:int, _arg_3:Boolean=false, _arg_4:Boolean=false)
        {
            super(_arg_1, _arg_3, _arg_4);
            this._param = _arg_2;
        }

        public function get param():int
        {
            return (1337);
        }


    }
}//package tank.events

