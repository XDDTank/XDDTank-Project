package ddt.view.sceneCharacter
{
   import ddt.data.player.PlayerInfo;
   import flash.events.EventDispatcher;
   import flash.geom.Point;
   
   public class SceneCharacterPlayerInfo extends EventDispatcher
   {
       
      
      protected var _playerPos:Point;
      
      protected var _playerNickName:String;
      
      protected var _playerSex:Boolean;
      
      protected var _playerInfo:PlayerInfo;
      
      protected var _walkPath:Array;
      
      protected var _sceneCharacterDirection:SceneCharacterDirection;
      
      protected var _playerDirection:int = 4;
      
      protected var _playerMoveSpeed:Number = 0.15;
      
      protected var _currenWalkStartPoint:Point;
      
      protected var _playerStauts:int = 1;
      
      public function SceneCharacterPlayerInfo()
      {
         this._walkPath = [];
         this._sceneCharacterDirection = SceneCharacterDirection.LB;
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
      
      public function set currenWalkStartPoint(param1:Point) : void
      {
         this._currenWalkStartPoint = param1;
      }
      
      public function get currenWalkStartPoint() : Point
      {
         return this._currenWalkStartPoint;
      }
      
      public function get playerPos() : Point
      {
         if(this._playerPos)
         {
            return this._playerPos;
         }
         return new Point(300,400);
      }
      
      public function set playerPos(param1:Point) : void
      {
         this._playerPos = param1;
         if(this._playerInfo)
         {
            dispatchEvent(new SceneCharacterEvent(SceneCharacterEvent.CHARACTER_PLAYER_POS_CHANGED,this._playerInfo.ID));
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
            this._sceneCharacterDirection = SceneCharacterDirection.LB;
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
      
      public function clone() : SceneCharacterPlayerInfo
      {
         var _loc1_:SceneCharacterPlayerInfo = new SceneCharacterPlayerInfo();
         _loc1_.playerInfo = this._playerInfo;
         _loc1_.playerPos = this._playerPos;
         _loc1_.playerDirection = this._playerDirection;
         _loc1_.walkPath = this._walkPath;
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
