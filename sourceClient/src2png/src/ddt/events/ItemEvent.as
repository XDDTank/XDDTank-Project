// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.events.ItemEvent

package ddt.events
{
    import flash.events.Event;

    public class ItemEvent extends Event 
    {

        public static const ITEM_SELECT:String = "itemSelect";
        public static const ITEM_CLICK:String = "itemClick";
        public static const ITEM_OVER:String = "itemOver";
        public static const ITEM_OUT:String = "itemOut";
        public static const ITEM_MOVE:String = "itemMove";

        private var _item:Object;
        private var _index:uint;

        public function ItemEvent(_arg_1:String, _arg_2:Object, _arg_3:uint)
        {
            super(_arg_1);
            this._item = _arg_2;
            this._index = _arg_3;
        }

        public function get item():Object
        {
            return (this._item);
        }

        public function get index():uint
        {
            return (this._index);
        }


    }
}//package ddt.events

