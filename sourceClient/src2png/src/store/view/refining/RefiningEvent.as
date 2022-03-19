// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//store.view.refining.RefiningEvent

package store.view.refining
{
    import flash.events.Event;
    import ddt.data.goods.InventoryItemInfo;

    public class RefiningEvent extends Event 
    {

        public static const MOVE:String = "move";

        public var info:InventoryItemInfo;

        public function RefiningEvent(_arg_1:String, _arg_2:InventoryItemInfo)
        {
            this.info = _arg_2;
            super(_arg_1);
        }

    }
}//package store.view.refining

