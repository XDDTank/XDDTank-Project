﻿// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//auctionHouse.event.AuctionHouseEvent

package auctionHouse.event
{
    import flash.events.Event;

    public class AuctionHouseEvent extends Event 
    {

        public static const CHANGE_STATE:String = "changeState";
        public static const GET_GOOD_CATEGORY:String = "getGoodCateGory";
        public static const SELECT_STRIP:String = "selectStrip";
        public static const DELET_AUCTION:String = "deleteAuction";
        public static const ADD_AUCTION:String = "addAuction";
        public static const UPDATE_PAGE:String = "updatePage";
        public static const PRE_PAGE:String = "prePage";
        public static const NEXT_PAGE:String = "nextPage";
        public static const SORT_CHANGE:String = "sortChange";
        public static const BROWSE_TYPE_CHANGE:String = "browseTypeChange";
        public static const CLOSE_FRAME:String = "closeFrame";

        public function AuctionHouseEvent(_arg_1:String, _arg_2:Boolean=false, _arg_3:Boolean=false)
        {
            super(_arg_1, _arg_2, _arg_3);
        }

    }
}//package auctionHouse.event

