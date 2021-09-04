package road7th.comm
{
   import flash.utils.ByteArray;
   
   public class PackageOut extends ByteArray
   {
      
      public static const HEADER:int = 29099;
       
      
      private var _checksum:int;
      
      private var _code:int;
      
      public function PackageOut(param1:int, param2:int = 0, param3:int = 0, param4:int = 0)
      {
         super();
         writeShort(HEADER);
         writeShort(0);
         writeShort(0);
         writeShort(param1);
         writeInt(param2);
         writeInt(param3);
         writeInt(param4);
         this._code = param1;
         this._checksum = 0;
      }
      
      public function get code() : int
      {
         return this._code;
      }
      
      public function pack() : void
      {
         this._checksum = this.calculateCheckSum();
         var _loc1_:ByteArray = new ByteArray();
         _loc1_.writeShort(length);
         _loc1_.writeShort(this._checksum);
         this[2] = _loc1_[0];
         this[3] = _loc1_[1];
         this[4] = _loc1_[2];
         this[5] = _loc1_[3];
      }
      
      public function calculateCheckSum() : int
      {
         var _loc1_:int = 119;
         var _loc2_:int = 6;
         while(_loc2_ < length)
         {
            _loc1_ += this[_loc2_++];
         }
         return _loc1_ & 32639;
      }
      
      public function writeDate(param1:Date) : void
      {
         writeShort(param1.getFullYear());
         writeByte(param1.month + 1);
         writeByte(param1.date);
         writeByte(param1.hours);
         writeByte(param1.minutes);
         writeByte(param1.seconds);
      }
      
      public function writeLong(param1:Number) : void
      {
         var _loc7_:String = null;
         var _loc2_:Number = param1;
         var _loc3_:int = int(_loc2_);
         var _loc4_:String = _loc2_.toString(2);
         if(_loc4_.length > 32)
         {
            _loc4_ = _loc4_.substr(0,_loc4_.length - 32);
         }
         else
         {
            _loc4_ = "";
         }
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         while(_loc6_ < _loc4_.length)
         {
            _loc7_ = _loc4_.charAt(_loc4_.length - (_loc6_ + 1));
            if(_loc7_ != "0")
            {
               if(_loc7_ != "1")
               {
                  break;
               }
               _loc5_ += 1 << _loc6_;
            }
            _loc6_++;
         }
         writeInt(_loc5_);
         writeInt(_loc3_);
      }
   }
}
