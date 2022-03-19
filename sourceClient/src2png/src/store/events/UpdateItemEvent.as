// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//store.events.UpdateItemEvent

package store.events
{
    import flash.events.Event;
    import ddt.data.goods.InventoryItemInfo;

    public class UpdateItemEvent extends Event 
    {

        public static const UPDATEITEMEVENT:String = "updateItemEvent";

        public var pos:int;
        public var item:InventoryItemInfo;

        public function UpdateItemEvent(_arg_1:String, _arg_2:int, _arg_3:InventoryItemInfo, _arg_4:Boolean=false, _arg_5:Boolean=false)
        {
            super(_arg_1, _arg_4, _arg_5);
            this.pos = _arg_2;
            this.item = _arg_3;
        }

    }
}//package store.events

