package consortion.transportSence
{
   import ddt.manager.LanguageMgr;
   import ddt.manager.ServerConfigManager;
   
   public class TransportCarInfo
   {
      
      public static const MAX_HIJACKED_TIMES:uint = 2;
      
      public static const ISREADY:uint = 0;
      
      public static const ISCONVOYING:uint = 1;
      
      public static const ISHIJACKING:uint = 2;
      
      public static const ISREACHED:uint = 3;
       
      
      private var _infoArr:Array;
      
      private var _type:uint;
      
      private var _name:String;
      
      private var _cost:int;
      
      private var _rewardExp:uint;
      
      private var _rewardGold:uint;
      
      private var _rewardContribution:uint;
      
      private var _hijackPercent:Number;
      
      private var _convoyPercent:Number;
      
      private var _speed:Number;
      
      private var _rewardContributionPlus:uint;
      
      private var _rewardGoldPlus:uint;
      
      private var _nickName:String;
      
      private var _consortionId:int;
      
      private var _consortionName:String;
      
      private var _ownerId:int;
      
      private var _ownerName:String;
      
      private var _guarderId:int;
      
      private var _guarderName:String;
      
      private var _hijackTimes:int;
      
      private var _startDate:Date;
      
      private var _truckState:int;
      
      private var _ownerLevel:int;
      
      private var _movePercent:Number;
      
      private var _lastHijackDate:Date;
      
      private var _hijackerIdList:Vector.<int>;
      
      public function TransportCarInfo(param1:uint)
      {
         super();
         this._type = param1;
         switch(param1)
         {
            case TransportCar.CARI:
               this._infoArr = ServerConfigManager.instance.getTransportCarInfo()[0].split(",");
               break;
            case TransportCar.CARII:
               this._infoArr = ServerConfigManager.instance.getTransportCarInfo()[1].split(",");
         }
         this.init();
      }
      
      private function init() : void
      {
         this._name = this._infoArr[1];
         this._cost = this._infoArr[2];
         this._rewardExp = this._infoArr[3];
         this._rewardContributionPlus = int(this._rewardContribution * 0.5);
         this._rewardGoldPlus = int(this._rewardGold * 0.5);
         this._hijackPercent = this._infoArr[6];
         this._convoyPercent = this._infoArr[7];
         this._hijackerIdList = new Vector.<int>();
      }
      
      public function getValueByLevel(param1:String, param2:int) : int
      {
         var _loc3_:Array = param1.split("_");
         if(param2 <= 25)
         {
            return int(_loc3_[0]);
         }
         if(param2 <= 35)
         {
            return int(_loc3_[1]);
         }
         if(param2 <= 45)
         {
            return int(_loc3_[2]);
         }
         if(param2 <= 55)
         {
            return int(_loc3_[3]);
         }
         if(param2 <= 100)
         {
            return int(_loc3_[4]);
         }
         return 0;
      }
      
      public function get type() : uint
      {
         return this._type;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function get cost() : int
      {
         return this._cost;
      }
      
      public function get rewardExp() : uint
      {
         return this._rewardExp;
      }
      
      public function get rewardGold() : uint
      {
         return this._rewardGold;
      }
      
      public function get rewardContribution() : uint
      {
         return this._rewardContribution;
      }
      
      public function get hijackPercent() : Number
      {
         return this._hijackPercent;
      }
      
      public function get convoyPercent() : Number
      {
         return this._convoyPercent;
      }
      
      public function get consortionId() : int
      {
         return this._consortionId;
      }
      
      public function set consortionId(param1:int) : void
      {
         this._consortionId = param1;
      }
      
      public function get consortionName() : String
      {
         return this._consortionName;
      }
      
      public function set consortionName(param1:String) : void
      {
         this._consortionName = param1;
      }
      
      public function get ownerId() : int
      {
         return this._ownerId;
      }
      
      public function set ownerId(param1:int) : void
      {
         this._ownerId = param1;
      }
      
      public function get ownerName() : String
      {
         return this._ownerName;
      }
      
      public function set ownerName(param1:String) : void
      {
         this._ownerName = param1;
      }
      
      public function get guarderId() : int
      {
         return this._guarderId;
      }
      
      public function set guarderId(param1:int) : void
      {
         this._guarderId = param1;
      }
      
      public function get guarderName() : String
      {
         if(this._guarderName == this._ownerName)
         {
            return LanguageMgr.GetTranslation("consortion.ConsortionTransport.defaultGuarderName");
         }
         return this._guarderName;
      }
      
      public function set guarderName(param1:String) : void
      {
         this._guarderName = param1;
      }
      
      public function get hijackTimes() : int
      {
         return this._hijackTimes;
      }
      
      public function set hijackTimes(param1:int) : void
      {
         this._hijackTimes = param1;
      }
      
      public function get startDate() : Date
      {
         return this._startDate;
      }
      
      public function set startDate(param1:Date) : void
      {
         this._startDate = param1;
      }
      
      public function get truckState() : int
      {
         return this._truckState;
      }
      
      public function set truckState(param1:int) : void
      {
         this._truckState = param1;
      }
      
      public function get speed() : Number
      {
         return this._speed;
      }
      
      public function set speed(param1:Number) : void
      {
         this._speed = param1;
      }
      
      public function get rewardContributionPlus() : uint
      {
         return this._rewardContributionPlus;
      }
      
      public function get rewardGoldPlus() : uint
      {
         return this._rewardGoldPlus;
      }
      
      public function get movePercent() : Number
      {
         return this._movePercent;
      }
      
      public function set movePercent(param1:Number) : void
      {
         if(param1 > 1)
         {
            param1 = 1;
         }
         this._movePercent = param1;
      }
      
      public function get ownerLevel() : int
      {
         return this._ownerLevel;
      }
      
      public function set ownerLevel(param1:int) : void
      {
         this._ownerLevel = param1;
         this._rewardGold = this.getValueByLevel(this._infoArr[4],this._ownerLevel);
         this._rewardContribution = this.getValueByLevel(this._infoArr[5],this._ownerLevel);
         this._rewardContributionPlus = int(this._rewardContribution * 0.5);
         this._rewardGoldPlus = int(this._rewardGold * 0.5);
      }
      
      public function get nickName() : String
      {
         return this._nickName;
      }
      
      public function set nickName(param1:String) : void
      {
         this._nickName = param1;
      }
      
      public function get lastHijackDate() : Date
      {
         return this._lastHijackDate;
      }
      
      public function set lastHijackDate(param1:Date) : void
      {
         this._lastHijackDate = param1;
      }
      
      public function get hijackerIdList() : Vector.<int>
      {
         return this._hijackerIdList;
      }
      
      public function set hijackerIdList(param1:Vector.<int>) : void
      {
         this._hijackerIdList = param1;
      }
   }
}
