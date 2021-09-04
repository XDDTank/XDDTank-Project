package farm.model
{
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.TimeManager;
   
   public class FieldVO
   {
      
      public static const PLANT_TIME:int = 0;
      
      public static const GAIN_TIME:int = 2;
       
      
      public var fieldID:int;
      
      public var plantTime:Date;
      
      public var gainTime:int;
      
      private var _seedID:int;
      
      private var _seed:ItemTemplateInfo;
      
      public function FieldVO()
      {
         super();
      }
      
      public function get isGrow() : Boolean
      {
         return this.seedID != 0;
      }
      
      public function get isDig() : Boolean
      {
         return true;
      }
      
      public function get seedID() : int
      {
         return this._seedID;
      }
      
      public function set seedID(param1:int) : void
      {
         this._seedID = param1;
         if(this.isGrow)
         {
            this._seed = ItemManager.Instance.getTemplateById(this._seedID);
         }
         else
         {
            this._seed = null;
         }
      }
      
      public function get seed() : ItemTemplateInfo
      {
         return this._seed;
      }
      
      public function get needSeedCount() : int
      {
         return Boolean(this._seed) ? int(int(this._seed.Property1)) : int(0);
      }
      
      public function get harvestCount() : int
      {
         return Boolean(this._seed) ? int(int(this._seed.Property2)) : int(0);
      }
      
      public function get gainID() : int
      {
         return Boolean(this._seed) ? int(int(this._seed.Property4)) : int(0);
      }
      
      public function get isGrownUp() : Boolean
      {
         return TimeManager.Instance.TotalMinuteToNow(this.plantTime) >= this.gainTime;
      }
      
      public function get restTime() : int
      {
         var _loc1_:int = this.gainTime - TimeManager.Instance.TotalMinuteToNow(this.plantTime);
         return _loc1_ < 0 ? int(0) : int(_loc1_);
      }
      
      public function get restSecondTime() : int
      {
         var _loc1_:int = this.gainTime * 60 - TimeManager.Instance.TotalSecondToNow(this.plantTime);
         return _loc1_ < 0 ? int(0) : int(_loc1_);
      }
   }
}
