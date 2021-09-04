package liveness
{
   import flash.events.EventDispatcher;
   
   public class LivenessModel extends EventDispatcher
   {
      
      public static const NOT_THE_TIME:uint = 0;
      
      public static const DAY_PASS:uint = 1;
      
      public static const NOT_GET_AWARD:uint = 2;
      
      public static const HAS_GET_AWARD:uint = 3;
      
      public static const BOX_HAS_GET:uint = 0;
      
      public static const BOX_CAN_GET:uint = 1;
      
      public static const BOX_CANNOT_GET:uint = 2;
      
      public static const CONSORTION_TASK:uint = 68;
      
      public static const WORLD_BOSS:uint = 14;
      
      public static const CONSORTION_CONVOY:int = 67;
      
      public static const MONSTER_REFLASH:int = 17;
      
      public static const SINGLE_DUNGEON:int = 65;
      
      public static const RANDOM_PVE:int = 64;
      
      public static const ARENA:int = 19;
      
      public static const RUNE:int = 26001;
      
      public static const NORMAL:int = 6;
       
      
      private var _statusList:Vector.<uint>;
      
      private var _livenessValue:uint = 0;
      
      private var _saveLivenessValue:uint = 0;
      
      private var _pointMovieHasPlay:Vector.<Boolean>;
      
      public function LivenessModel()
      {
         super();
         this._pointMovieHasPlay = new Vector.<Boolean>();
         var _loc1_:uint = 0;
         while(_loc1_ < 5)
         {
            this._pointMovieHasPlay.push(false);
            _loc1_++;
         }
      }
      
      public function get statusList() : Vector.<uint>
      {
         return this._statusList;
      }
      
      public function set statusList(param1:Vector.<uint>) : void
      {
         this._statusList = param1;
      }
      
      public function get livenessValue() : uint
      {
         return this._livenessValue;
      }
      
      public function set livenessValue(param1:uint) : void
      {
         this._livenessValue = param1;
      }
      
      public function get saveLivenessValue() : uint
      {
         return this._saveLivenessValue;
      }
      
      public function set saveLivenessValue(param1:uint) : void
      {
         this._saveLivenessValue = param1;
      }
      
      public function get pointMovieHasPlay() : Vector.<Boolean>
      {
         return this._pointMovieHasPlay;
      }
      
      public function set pointMovieHasPlay(param1:Vector.<Boolean>) : void
      {
         this._pointMovieHasPlay = param1;
      }
   }
}
