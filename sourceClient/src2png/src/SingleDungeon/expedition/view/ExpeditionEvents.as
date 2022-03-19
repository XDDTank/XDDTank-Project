// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//SingleDungeon.expedition.view.ExpeditionEvents

package SingleDungeon.expedition.view
{
    import flash.events.Event;
    import road7th.comm.PackageIn;

    public class ExpeditionEvents extends Event 
    {

        public static const START:String = "start";
        public static const STOP:String = "stop";
        public static const ACCELERATE:String = "accelerate";
        public static const CANCLE:String = "cancle";
        public static const UPDATE:String = "update";
        public static const ONE_MINUTES:String = "oneMinutes";
        public static const LOAD_COMPLETE:String = "loadComplete";

        private var _pkg:PackageIn;
        private var _action:String;

        public function ExpeditionEvents(_arg_1:String, _arg_2:String=null, _arg_3:PackageIn=null)
        {
            super(_arg_1, bubbles, cancelable);
            this._pkg = _arg_3;
            this._action = _arg_2;
        }

        public function get pkg():PackageIn
        {
            return (this._pkg);
        }

        public function get action():String
        {
            return (this._action);
        }


    }
}//package SingleDungeon.expedition.view

