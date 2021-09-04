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
      
      public function StoreIIEvent(param1:String, param2:Object = null, param3:Boolean = false, param4:Boolean = false, param5:Boolean = false)
      {
         this.data = param2;
         this.bool = param3;
         super(param1,param4,param5);
      }
   }
}
