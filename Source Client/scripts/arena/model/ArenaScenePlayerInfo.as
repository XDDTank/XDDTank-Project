package arena.model
{
   import arena.ArenaManager;
   import ddt.view.sceneCharacter.SceneCharacterEvent;
   import ddt.view.sceneCharacter.SceneCharacterPlayerInfo;
   import flash.geom.Point;
   
   public class ArenaScenePlayerInfo extends SceneCharacterPlayerInfo
   {
       
      
      private var _arenaCurrentBlood:Number;
      
      private var _sceneLevel:int = 1;
      
      private var _sceneID:int;
      
      private var _arenaFightScore:int;
      
      private var _arenaWinScore:int;
      
      private var _arenaCount:int;
      
      private var _arenaFlag:int;
      
      private var _arenaMaxWin:int;
      
      private var _playerType:int;
      
      private var _updateType:Boolean;
      
      private var _enterTime:Date;
      
      private var _bufferType:int;
      
      public function ArenaScenePlayerInfo()
      {
         super();
      }
      
      public function get arenaCurrentBlood() : Number
      {
         return this._arenaCurrentBlood;
      }
      
      public function set arenaCurrentBlood(param1:Number) : void
      {
         this._arenaCurrentBlood = param1;
      }
      
      public function get sceneLevel() : int
      {
         return this._sceneLevel;
      }
      
      public function set sceneLevel(param1:int) : void
      {
         this._sceneLevel = param1;
      }
      
      public function get sceneID() : int
      {
         return this._sceneID;
      }
      
      public function set sceneID(param1:int) : void
      {
         this._sceneID = param1;
      }
      
      public function get arenaFightScore() : int
      {
         return this._arenaFightScore;
      }
      
      public function set arenaFightScore(param1:int) : void
      {
         this._arenaFightScore = param1;
      }
      
      public function get arenaCount() : int
      {
         return this._arenaCount;
      }
      
      public function set arenaCount(param1:int) : void
      {
         this._arenaCount = param1;
      }
      
      public function get arenaFlag() : int
      {
         return this._arenaFlag;
      }
      
      public function set arenaFlag(param1:int) : void
      {
         this._arenaFlag = param1;
      }
      
      public function get arenaMaxWin() : int
      {
         return this._arenaMaxWin;
      }
      
      public function set arenaMaxWin(param1:int) : void
      {
         this._arenaMaxWin = param1;
      }
      
      public function get playerType() : int
      {
         return this._playerType;
      }
      
      public function set playerType(param1:int) : void
      {
         this._playerType = param1;
      }
      
      public function get isKing() : Boolean
      {
         return this.playerType == 1;
      }
      
      public function get updateType() : Boolean
      {
         return this._updateType;
      }
      
      public function set updateType(param1:Boolean) : void
      {
         this._updateType = param1;
      }
      
      public function get arenaWinScore() : int
      {
         return this._arenaWinScore;
      }
      
      public function set arenaWinScore(param1:int) : void
      {
         this._arenaWinScore = param1;
      }
      
      public function get enterTime() : Date
      {
         return this._enterTime;
      }
      
      public function set enterTime(param1:Date) : void
      {
         this._enterTime = param1;
      }
      
      public function get bufferType() : int
      {
         return this._bufferType;
      }
      
      public function set bufferType(param1:int) : void
      {
         this._bufferType = param1;
      }
      
      override public function set playerPos(param1:Point) : void
      {
         _playerPos = param1;
         if(_playerInfo)
         {
            ArenaManager.instance.model.dispatchEvent(new SceneCharacterEvent(SceneCharacterEvent.CHARACTER_PLAYER_POS_CHANGED,_playerInfo.ID));
         }
      }
   }
}
