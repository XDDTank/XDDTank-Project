// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.events.ShortcutBuyEvent

package ddt.events
{
    import flash.events.Event;

    public class ShortcutBuyEvent extends Event 
    {

        public static const SHORTCUT_BUY:String = "shortcutBuy";
        public static const SHORTCUT_BUY_MONEY_OK:String = "shortcutBuyMoneyOk";
        public static const SHORTCUT_BUY_MONEY_CANCEL:String = "shortcutBuyMoneyCancel";

        private var _itemID:int;
        private var _itemNum:int;

        public function ShortcutBuyEvent(_arg_1:int, _arg_2:int, _arg_3:Boolean=false, _arg_4:Boolean=false, _arg_5:String="shortcutBuy")
        {
            super(_arg_5, _arg_3, _arg_4);
            this._itemID = _arg_1;
            this._itemNum = _arg_2;
        }

        public function get ItemID():int
        {
            return (this._itemID);
        }

        public function get ItemNum():int
        {
            return (this._itemNum);
        }


    }
}//package ddt.events

