// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//store.events.EmbedEvent

package store.events
{
    import flash.events.Event;
    import ddt.data.goods.InventoryItemInfo;

    public class EmbedEvent extends Event 
    {

        public static const EMBED:String = "embed";
        public static const MOVE:String = "move";

        public var data:InventoryItemInfo;

        public function EmbedEvent(_arg_1:String, _arg_2:InventoryItemInfo, _arg_3:Boolean=false, _arg_4:Boolean=false)
        {
            super(_arg_1, _arg_3, _arg_4);
            this.data = _arg_2;
        }

    }
}//package store.events

