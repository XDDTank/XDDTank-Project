// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//store.events.StoreBagEvent

package store.events
{
    import flash.events.Event;
    import ddt.data.goods.InventoryItemInfo;

    public class StoreBagEvent extends Event 
    {

        public static const BUYSYMBOL:String = "buySymbol";
        public static const STRNGTH_TRAN:String = "strengthTran";
        public static const REMOVE:String = "storeBagRemove";
        public static const UPDATE:String = "update";
        public static const AUTOLINK:String = "autoLink";

        public var pos:int;
        public var data:InventoryItemInfo;

        public function StoreBagEvent(_arg_1:String, _arg_2:int, _arg_3:InventoryItemInfo, _arg_4:Boolean=false, _arg_5:Boolean=true)
        {
            super(_arg_1, _arg_4, cancelable);
            this.pos = _arg_2;
            this.data = _arg_3;
        }

    }
}//package store.events

