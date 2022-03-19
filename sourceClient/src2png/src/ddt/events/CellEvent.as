// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.events.CellEvent

package ddt.events
{
    import flash.events.Event;

    public class CellEvent extends Event 
    {

        public static const MOUSE_DOWN:String = "mousedown";
        public static const ITEM_CLICK:String = "itemclick";
        public static const DOUBLE_CLICK:String = "doubleclick";
        public static const LOCK_CHANGED:String = "lockChanged";
        public static const DRAGSTART:String = "dragStart";
        public static const DRAGDROP:String = "dragDrop";
        public static const DRAGSTOP:String = "dragStop";
        public static const BAG_CLOSE:String = "bagClose";

        public var data:Object;
        public var ctrlKey:Boolean;

        public function CellEvent(_arg_1:String, _arg_2:Object=null, _arg_3:Boolean=false, _arg_4:Boolean=false, _arg_5:Boolean=false)
        {
            this.data = _arg_2;
            this.ctrlKey = _arg_5;
            super(_arg_1, _arg_3, _arg_4);
        }

    }
}//package ddt.events

