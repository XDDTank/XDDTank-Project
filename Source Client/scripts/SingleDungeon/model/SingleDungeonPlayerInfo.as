package SingleDungeon.model
{
   import SingleDungeon.event.WalkMapEvent;
   import ddt.data.player.PlayerInfo;
   import ddt.view.sceneCharacter.SceneCharacterDirection;
   import flash.events.EventDispatcher;
   import flash.geom.Point;
   
   public class SingleDungeonPlayerInfo extends EventDispatcher
   {
       
      
      private var _playerPos:Point;
      
      private var _playerNickName:String;
      
      private var _playerSex:Boolean;
      
      private var _playerInfo:PlayerInfo;
      
      private var _walkPath:Array;
      
      private var _sceneCharacterDirection:SceneCharacterDirection;
      
      private var _playerDirection:int = 3;
      
      private var _playerMoveSpeed:Number = 0.15;
      
      public var currentWalkStartPoint:Point;
      
      private var _playerStauts:int = 1;
      
      public function SingleDungeonPlayerInfo()
      {
         this._walkPath = [];
         this._sceneCharacterDirection = SceneCharacterDirection.RT;
         super();
      }
      
      public function set playerStauts(param1:int) : void
      {
         this._playerStauts = param1;
      }
      
      public function get playerStauts() : int
      {
         return this._playerStauts;
      }
      
      public function get playerPos() : Point
      {
         return this._playerPos;
      }
      
      public function set playerPos(param1:Point) : void
      {
         this._playerPos = param1;
         if(this._playerInfo)
         {
            dispatchEvent(new WalkMapEvent(WalkMapEvent.WALKMAP_PLAYER_POS_CHANGED,this._playerInfo.ID));
         }
      }
      
      public function get playerInfo() : PlayerInfo
      {
         return this._playerInfo;
      }
      
      public function set playerInfo(param1:PlayerInfo) : void
      {
         this._playerInfo = param1;
      }
      
      public function get walkPath() : Array
      {
         return this._walkPath;
      }
      
      public function set walkPath(param1:Array) : void
      {
         this._walkPath = param1;
      }
      
      public function get scenePlayerDirection() : SceneCharacterDirection
      {
         if(!this._sceneCharacterDirection)
         {
            this._sceneCharacterDirection = SceneCharacterDirection.RT;
         }
         return this._sceneCharacterDirection;
      }
      
      public function set scenePlayerDirection(param1:SceneCharacterDirection) : void
      {
         this._sceneCharacterDirection = param1;
         switch(this._sceneCharacterDirection)
         {
            case SceneCharacterDirection.RT:
               this._playerDirection = 1;
               break;
            case SceneCharacterDirection.LT:
               this._playerDirection = 2;
               break;
            case SceneCharacterDirection.RB:
               this._playerDirection = 3;
               break;
            case SceneCharacterDirection.LB:
               this._playerDirection = 4;
         }
      }
      
      public function get playerDirection() : int
      {
         return this._playerDirection;
      }
      
      public function set playerDirection(param1:int) : void
      {
         this._playerDirection = param1;
         switch(this._playerDirection)
         {
            case 1:
               this._sceneCharacterDirection = SceneCharacterDirection.RT;
               break;
            case 2:
               this._sceneCharacterDirection = SceneCharacterDirection.LT;
               break;
            case 3:
               this._sceneCharacterDirection = SceneCharacterDirection.RB;
               break;
            case 4:
               this._sceneCharacterDirection = SceneCharacterDirection.LB;
         }
      }
      
      public function get playerMoveSpeed() : Number
      {
         return this._playerMoveSpeed;
      }
      
      public function set playerMoveSpeed(param1:Number) : void
      {
         if(this._playerMoveSpeed == param1)
         {
            return;
         }
         this._playerMoveSpeed = param1;
      }
      
      public function clone() : SingleDungeonPlayerInfo
      {
         var _loc1_:SingleDungeonPlayerInfo = new SingleDungeonPlayerInfo();
         _loc1_.playerInfo = this._playerInfo;
         _loc1_.playerPos = this._playerPos;
         _loc1_.walkPath = this._walkPath;
         _loc1_.playerDirection = this._playerDirection;
         _loc1_.playerMoveSpeed = this._playerMoveSpeed;
         return _loc1_;
      }
      
      public function dispose() : void
      {
         while(this._walkPath && this._walkPath.length > 0)
         {
            this._walkPath.shift();
         }
         this._walkPath = null;
         this._playerPos = null;
         this._sceneCharacterDirection = null;
      }
   }
}