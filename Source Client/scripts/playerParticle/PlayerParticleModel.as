package playerParticle
{
   public class PlayerParticleModel
   {
       
      
      private var _posArray:Array;
      
      private var _direction:int = 1;
      
      private var _length:int = 0;
      
      public function PlayerParticleModel()
      {
         super();
         this._posArray = new Array();
      }
      
      public function reset() : void
      {
         this._length = 0;
         this._posArray = new Array();
      }
      
      public function get posArray() : Array
      {
         return this._posArray;
      }
      
      public function set posArray(param1:Array) : void
      {
         this._posArray = param1;
      }
      
      public function get direction() : int
      {
         return this._direction;
      }
      
      public function set direction(param1:int) : void
      {
         this._direction = param1;
      }
   }
}
