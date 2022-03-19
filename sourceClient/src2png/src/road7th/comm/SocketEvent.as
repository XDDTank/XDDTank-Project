// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//road7th.comm.SocketEvent

package road7th.comm
{
    import flash.events.Event;

    public class SocketEvent extends Event 
    {

        public static const DATA:String = "data";

        private var _data:PackageIn;

        public function SocketEvent(_arg_1:String, _arg_2:PackageIn)
        {
            super(_arg_1);
            this._data = _arg_2;
        }

        public function get data():PackageIn
        {
            return (this._data);
        }


    }
}//package road7th.comm

