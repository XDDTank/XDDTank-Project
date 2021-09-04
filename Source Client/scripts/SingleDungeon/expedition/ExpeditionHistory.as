package SingleDungeon.expedition
{
   public class ExpeditionHistory
   {
      
      public static const BIT_LENGTH:int = 256;
      
      public static const FB_BASEID:int = 91000;
      
      private static var _instance:ExpeditionHistory;
       
      
      private var array:Array;
      
      private var arrLength:int;
      
      public function ExpeditionHistory()
      {
         super();
         this.array = new Array();
         this.arrLength = (BIT_LENGTH - 1 >> 3) + 1;
      }
      
      public static function get instance() : ExpeditionHistory
      {
         if(!_instance)
         {
            _instance = new ExpeditionHistory();
         }
         return _instance;
      }
      
      public function sets(param1:String) : void
      {
         var _loc5_:String = null;
         var _loc2_:int = param1.length < BIT_LENGTH ? int(param1.length) : int(BIT_LENGTH);
         var _loc3_:int = 0;
         while(_loc3_ < this.arrLength)
         {
            this.array[_loc3_] = 0;
            _loc3_++;
         }
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_)
         {
            _loc5_ = param1.charAt(_loc4_);
            if(_loc5_ == "1")
            {
               this.set(_loc4_ + 1);
            }
            else if(_loc5_ != "0")
            {
            }
            _loc4_++;
         }
      }
      
      public function set(param1:int) : void
      {
         if(param1 < 0 || param1 >= BIT_LENGTH)
         {
            return;
         }
         var _loc2_:int = param1 - 1 >> 3;
         var _loc3_:int = 1 << (param1 - 1) % 8;
         this.array[_loc2_] |= _loc3_;
      }
      
      public function get(param1:int) : Boolean
      {
         var _loc2_:int = param1 - FB_BASEID;
         if(_loc2_ < 0 || _loc2_ >= BIT_LENGTH)
         {
            return false;
         }
         var _loc3_:int = _loc2_ - 1 >> 3;
         var _loc4_:int = 1 << (_loc2_ - 1) % 8;
         return (this.array[_loc3_] & _loc4_) != 0 ? Boolean(true) : Boolean(false);
      }
   }
}
