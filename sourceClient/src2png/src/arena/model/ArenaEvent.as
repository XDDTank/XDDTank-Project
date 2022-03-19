// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//arena.model.ArenaEvent

package arena.model
{
    import flash.events.Event;

    public class ArenaEvent extends Event 
    {

        public static const MOVE:String = "move";
        public static const ENTER_SCENE:String = "enterScene";
        public static const LEAVE_SCENE:String = "leaveScene";
        public static const UPDATE_SELF:String = "updateSelf";
        public static const ARENA_ACTIVITY:String = "arenaActivity";

        private var _data:Object;

        public function ArenaEvent(_arg_1:String, _arg_2:Object=null)
        {
            super(_arg_1);
            this._data = _arg_2;
        }

        public function get data():Object
        {
            return (this._data);
        }


    }
}//package arena.model

