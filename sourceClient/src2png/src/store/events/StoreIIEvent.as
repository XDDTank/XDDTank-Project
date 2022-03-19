// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//store.events.StoreIIEvent

package store.events
{
    import flash.events.Event;

    public class StoreIIEvent extends Event 
    {

        public static const ITEM_CLICK:String = "itemclick";
        public static const UPPREVIEW:String = "upPreview";
        public static const EMBED_CLICK:String = "embedClick";
        public static const EMBED_INFORCHANGE:String = "embedInfoChange";
        public static const TRANSFER_LIGHT:String = "transferLight";
        public static const CHANGE_TYPE:String = "changeType";
        public static const WEAPON_READY:String = "weaponReady";
        public static const WEAPON_REMOVE:String = "weaponRemove";
        public static const STRENGTH_DONE:String = "strengthDone";
        public static const STONE_UPDATE:String = "stoneUpdate";
        public static const UPGRADES_PLAY:String = "upgradesPlay";
        public static const REFINING_REBACK:String = "refiningBack";

        public var data:Object;
        public var bool:Boolean;

        public function StoreIIEvent(_arg_1:String, _arg_2:Object=null, _arg_3:Boolean=false, _arg_4:Boolean=false, _arg_5:Boolean=false)
        {
            this.data = _arg_2;
            this.bool = _arg_3;
            super(_arg_1, _arg_4, _arg_5);
        }

    }
}//package store.events

