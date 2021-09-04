package activity.data
{
   import ddt.manager.LanguageMgr;
   import ddt.manager.TimeManager;
   import road7th.utils.DateUtils;
   
   public class ActivityInfo
   {
       
      
      public var ActivityId:String;
      
      public var ActivityName:String;
      
      public var ActivityType:int;
      
      public var ActivityChildType:int;
      
      private var _BeginTime:String;
      
      private var _EndTime:String;
      
      public var Status:int;
      
      public var IsContinue:Boolean;
      
      public var GetWay:int;
      
      public var Desc:String;
      
      private var _RewardDesc:String;
      
      private var _BeginShowTime:String;
      
      private var _EndShowTime:String;
      
      public var Icon:String;
      
      public var Remain1:String;
      
      public var Remain2:String;
      
      private var _beginDate:Date;
      
      private var _endDate:Date;
      
      private var _beginShowDate:Date;
      
      private var _endShowDate:Date;
      
      public var receiveNum:int;
      
      public var ActionTimeContent:String;
      
      public function ActivityInfo()
      {
         super();
      }
      
      public function get beginDate() : Date
      {
         return this._beginDate;
      }
      
      public function get beginShowDate() : Date
      {
         return this._beginShowDate;
      }
      
      public function get endShowDate() : Date
      {
         return this._endShowDate;
      }
      
      public function set BeginShowTime(param1:String) : void
      {
         this._BeginShowTime = param1;
         this._beginShowDate = DateUtils.getDateByStr(param1);
      }
      
      public function get endDate() : Date
      {
         return this._endDate;
      }
      
      public function set EndShowTime(param1:String) : void
      {
         this._EndShowTime = param1;
         this._endShowDate = DateUtils.getDateByStr(param1);
      }
      
      public function activeTime() : String
      {
         var _loc1_:String = null;
         if(this.ActionTimeContent)
         {
            _loc1_ = this.ActionTimeContent;
         }
         else if(this._EndShowTime)
         {
            _loc1_ = this.getActiveString(this.beginDate) + "-" + this.getActiveString(this.endDate);
         }
         else
         {
            _loc1_ = LanguageMgr.GetTranslation("tank.data.MovementInfo.begin",this.getActiveString(this.beginDate));
         }
         return _loc1_;
      }
      
      private function getActiveString(param1:Date) : String
      {
         return LanguageMgr.GetTranslation("tank.data.MovementInfo.date",this.addZero(param1.getFullYear()),this.addZero(param1.getMonth() + 1),this.addZero(param1.getDate()));
      }
      
      private function addZero(param1:Number) : String
      {
         var _loc2_:String = null;
         if(param1 < 10)
         {
            _loc2_ = "0" + param1.toString();
         }
         else
         {
            _loc2_ = param1.toString();
         }
         return _loc2_;
      }
      
      public function overdue() : Boolean
      {
         var _loc1_:Date = TimeManager.Instance.Now();
         var _loc2_:Number = _loc1_.time;
         if(_loc2_ < this.beginDate.getTime())
         {
            return true;
         }
         if(this._EndShowTime)
         {
            if(_loc2_ > this.endDate.getTime())
            {
               return true;
            }
         }
         return false;
      }
      
      public function get BeginTime() : String
      {
         return this._BeginTime;
      }
      
      public function set BeginTime(param1:String) : void
      {
         this._BeginTime = param1;
         this._beginDate = DateUtils.getDateByStr(param1);
      }
      
      public function get EndTime() : String
      {
         return this._EndTime;
      }
      
      public function set EndTime(param1:String) : void
      {
         this._EndTime = param1;
         this._endDate = DateUtils.getDateByStr(param1);
      }
      
      public function get RewardDesc() : String
      {
         if(this._RewardDesc == null)
         {
            this._RewardDesc = "";
         }
         return this._RewardDesc;
      }
      
      public function set RewardDesc(param1:String) : void
      {
         this._RewardDesc = param1;
      }
   }
}
