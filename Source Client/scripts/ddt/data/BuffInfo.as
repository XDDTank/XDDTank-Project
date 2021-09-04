package ddt.data
{
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.TimeManager;
   
   public class BuffInfo
   {
      
      public static const FREE:int = 15;
      
      public static const DOUBEL_EXP:int = 13;
      
      public static const DOUBLE_GESTE:int = 12;
      
      public static const PREVENT_KICK:int = 100;
      
      public static const MORE_ENETY:int = 102;
      
      public static const Caddy_Good:int = 70;
      
      public static const Save_Life:int = 51;
      
      public static const Agility:int = 50;
      
      public static const ReHealth:int = 52;
      
      public static const Train_Good:int = 71;
      
      public static const Level_Try:int = 101;
      
      public static const Card_Get:int = 73;
      
      public static const GemMaster:int = 82;
      
      public static const Pay_Buff:int = 16;
      
      public static const ADD_BOMB_MINE_COUNT:int = 200;
      
      public static const ADD_TRUCK_SPEED:int = 201;
      
      public static const ADD_CONVOY_COUNT:int = 202;
      
      public static const ADD_HIJACK_COUNT:int = 203;
      
      public static const ADD_SIRIKE_COPY_COUNT:int = 204;
      
      public static const ADD_INVADE_ATTACK:int = 205;
      
      public static const ADD_QUEST_RICHESOFFER:int = 206;
      
      public static const ADD_SLAY_DAMAGE:int = 207;
      
      public static const REDUCE_PVP_MOVE_ENERY:int = 208;
      
      public static const GET_ONLINE_REWARS:int = 209;
      
      public static const GET_INVADE_HONOR:int = 210;
      
      public static const GET_PET_GP_PLUS:int = 211;
      
      public static const GET_MAGICSOUL_PLUS:int = 212;
      
      public static const MILITARY_BLOOD_BUFF1:int = 14;
      
      public static const MILITARY_BLOOD_BUFF2:int = 15;
      
      public static const MILITARY_BLOOD_BUFF3:int = 16;
       
      
      public var Type:int;
      
      public var IsExist:Boolean;
      
      public var BeginData:Date;
      
      public var ValidDate:int;
      
      public var Value:int;
      
      public var ValidCount:int;
      
      public var isSelf:Boolean = true;
      
      private var _buffName:String;
      
      private var _buffItem:ItemTemplateInfo;
      
      private var _description:String;
      
      public var day:int;
      
      private var _valided:Boolean = true;
      
      public function BuffInfo(param1:int = -1, param2:Boolean = false, param3:Date = null, param4:int = 0, param5:int = 0, param6:int = 0)
      {
         super();
         this.Type = param1;
         this.IsExist = param2;
         this.BeginData = param3;
         this.ValidDate = param4;
         this.Value = param5;
         this.ValidCount = param6;
         this.initItemInfo();
      }
      
      public function get maxCount() : int
      {
         return this._buffItem != null ? int(int(this._buffItem.Property3)) : int(0);
      }
      
      public function getLeftTimeByUnit(param1:Number) : int
      {
         if(this.getLeftTime() > 0)
         {
            switch(param1)
            {
               case TimeManager.DAY_TICKS:
                  return Math.floor(this.getLeftTime() / TimeManager.DAY_TICKS);
               case TimeManager.HOUR_TICKS:
                  return Math.floor(this.getLeftTime() % TimeManager.DAY_TICKS / TimeManager.HOUR_TICKS);
               case TimeManager.Minute_TICKS:
                  return Math.floor(this.getLeftTime() % TimeManager.HOUR_TICKS / TimeManager.Minute_TICKS);
            }
         }
         return 0;
      }
      
      public function get valided() : Boolean
      {
         return this._valided;
      }
      
      public function calculatePayBuffValidDay() : void
      {
         var _loc1_:Date = null;
         var _loc2_:Date = null;
         var _loc3_:int = 0;
         if(this.BeginData)
         {
            _loc1_ = TimeManager.Instance.Now();
            _loc2_ = new Date(this.BeginData.fullYear,this.BeginData.month,this.BeginData.date);
            _loc1_ = new Date(_loc1_.fullYear,_loc1_.month,_loc1_.date);
            _loc3_ = (_loc1_.time - _loc2_.time) / TimeManager.DAY_TICKS;
            if(_loc3_ < this.ValidDate)
            {
               this._valided = true;
               this.day = this.ValidDate - _loc3_;
            }
            else
            {
               this._valided = false;
            }
         }
      }
      
      private function getLeftTime() : Number
      {
         var _loc1_:Number = NaN;
         if(this.IsExist)
         {
            _loc1_ = this.ValidDate - Math.floor((TimeManager.Instance.Now().time - this.BeginData.time) / TimeManager.Minute_TICKS);
         }
         else
         {
            _loc1_ = -1;
         }
         return _loc1_ * TimeManager.Minute_TICKS;
      }
      
      public function get buffName() : String
      {
         return this._buffItem.Name;
      }
      
      public function get description() : String
      {
         return this._buffItem.Data;
      }
      
      public function get buffItemInfo() : ItemTemplateInfo
      {
         return this._buffItem;
      }
      
      public function initItemInfo() : void
      {
         switch(this.Type)
         {
            case PREVENT_KICK:
               this._buffItem = ItemManager.Instance.getTemplateById(EquipType.PREVENT_KICK);
               break;
            case DOUBLE_GESTE:
               this._buffItem = ItemManager.Instance.getTemplateById(EquipType.DOUBLE_GESTE_CARD);
               break;
            case DOUBEL_EXP:
               this._buffItem = ItemManager.Instance.getTemplateById(EquipType.DOUBLE_EXP_CARD);
               break;
            case FREE:
               this._buffItem = ItemManager.Instance.getTemplateById(EquipType.FREE_PROP_CARD);
               break;
            case Caddy_Good:
               this._buffItem = ItemManager.Instance.getTemplateById(EquipType.Caddy_Good);
               break;
            case Save_Life:
               this._buffItem = ItemManager.Instance.getTemplateById(EquipType.Save_Life);
               break;
            case Agility:
               this._buffItem = ItemManager.Instance.getTemplateById(EquipType.Agility_Get);
               break;
            case ReHealth:
               this._buffItem = ItemManager.Instance.getTemplateById(EquipType.ReHealth);
               break;
            case Level_Try:
               this._buffItem = ItemManager.Instance.getTemplateById(EquipType.Level_Try);
               break;
            case Card_Get:
               this._buffItem = ItemManager.Instance.getTemplateById(EquipType.Card_Get);
         }
      }
      
      public function dispose() : void
      {
      }
   }
}
