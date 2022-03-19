// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//auctionHouse.event.AuctionSellEvent

package auctionHouse.event
{
    import flash.events.Event;

    public class AuctionSellEvent extends Event 
    {

        public static const SELL:String = "sell";
        public static const NOTSELL:String = "notsell";

        private var _sellCount:int;

        public function AuctionSellEvent(_arg_1:String, _arg_2:int=0, _arg_3:Boolean=false, _arg_4:Boolean=false)
        {
            this._sellCount = _arg_2;
            super(_arg_1, _arg_3, _arg_4);
        }

        public function get sellCount():int
        {
            return (this._sellCount);
        }


    }
}//package auctionHouse.event

