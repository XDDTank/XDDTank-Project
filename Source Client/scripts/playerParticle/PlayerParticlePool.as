package playerParticle
{
   import com.pickgliss.utils.ObjectUtils;
   
   public class PlayerParticlePool
   {
       
      
      private var _creat:Function;
      
      private var _clean:Function;
      
      private var _mix:int;
      
      private var _max:int;
      
      private var _list:Vector.<PlayerParticle>;
      
      private var _length:int = 0;
      
      private var _size:int = 0;
      
      public function PlayerParticlePool()
      {
         super();
         this._list = new Vector.<PlayerParticle>();
      }
      
      public function creatPlayerParticle(param1:Function, param2:Function, param3:int = 5) : void
      {
         this._creat = param1;
         this._clean = param2;
         this._max = param3;
         var _loc4_:int = 0;
         while(_loc4_ < this._max)
         {
            this.addParticle();
            _loc4_++;
         }
      }
      
      public function addParticle() : void
      {
         var _loc1_:* = this._length++;
         this._list[_loc1_] = this._creat();
      }
      
      public function checkOut() : PlayerParticle
      {
         if(this._length <= 0)
         {
         }
         return this._list[--this._length];
      }
      
      public function checkIn() : void
      {
         this._clean(this._list[this._length]);
      }
      
      public function clear() : void
      {
         var _loc1_:PlayerParticle = null;
         for each(_loc1_ in this._list)
         {
            this._clean(_loc1_);
         }
         this._length = this._max;
      }
      
      public function dispose() : void
      {
         var _loc1_:PlayerParticle = null;
         this._clean = null;
         this._creat = null;
         for each(_loc1_ in this._list)
         {
            ObjectUtils.disposeObject(_loc1_);
            _loc1_ = null;
         }
         this._list = new Vector.<PlayerParticle>();
         this._length = 0;
         this._size = 0;
      }
   }
}
