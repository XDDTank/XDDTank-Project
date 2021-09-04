package arena
{
   import arena.model.ArenaEvent;
   import arena.model.ArenaPlayerStates;
   import arena.model.ArenaScenePlayerInfo;
   import arena.object.ArenaScenePlayer;
   import ddt.manager.PlayerManager;
   import flash.events.EventDispatcher;
   import flash.geom.Point;
   import flash.utils.clearTimeout;
   import road7th.data.DictionaryData;
   
   public class ArenaModel extends EventDispatcher
   {
       
      
      private var _targetPlayer:ArenaScenePlayer;
      
      private var _playerDic:DictionaryData;
      
      private var _playerBuffer:Array;
      
      private var _selfInfo:ArenaScenePlayerInfo;
      
      private var _reliveAlertShow:Boolean = true;
      
      private var _timeOut:uint;
      
      public function ArenaModel()
      {
         this._playerDic = new DictionaryData();
         this._playerBuffer = new Array();
         super();
      }
      
      public function get targetPlayer() : ArenaScenePlayer
      {
         return this._targetPlayer;
      }
      
      public function set targetPlayer(param1:ArenaScenePlayer) : void
      {
         this._targetPlayer = param1;
      }
      
      public function get selfInfo() : ArenaScenePlayerInfo
      {
         if(!this._selfInfo)
         {
            this._selfInfo = new ArenaScenePlayerInfo();
            this._selfInfo.playerInfo = PlayerManager.Instance.Self;
            this._selfInfo.arenaCurrentBlood = this._selfInfo.playerInfo.hp;
            this._selfInfo.playerStauts = ArenaPlayerStates.LOADING;
            this._selfInfo.playerPos = new Point(0,0);
         }
         return this._selfInfo;
      }
      
      public function set selfInfo(param1:ArenaScenePlayerInfo) : void
      {
         this._selfInfo = param1;
         dispatchEvent(new ArenaEvent(ArenaEvent.UPDATE_SELF));
      }
      
      public function get playerDic() : DictionaryData
      {
         return this._playerDic;
      }
      
      public function clearPlayer() : void
      {
         this._playerDic = new DictionaryData();
         this._playerBuffer = new Array();
         clearTimeout(this._timeOut);
      }
      
      public function addPlayerInfo(param1:int, param2:ArenaScenePlayerInfo) : void
      {
         this._playerDic.add(param1,param2);
      }
      
      public function updatePlayerInfo(param1:int, param2:ArenaScenePlayerInfo) : void
      {
         if(this._playerDic.hasKey(param1))
         {
            this.addPlayerInfo(param1,param2);
         }
      }
      
      private function doAddPlayer() : void
      {
         if(!this._playerDic || !this._playerBuffer[0])
         {
            return;
         }
         this._playerDic.add(this._playerBuffer[0].playerInfo.ID,this._playerBuffer[0]);
         this._playerBuffer.shift();
      }
      
      public function addPlayerInfoRightNow(param1:int, param2:ArenaScenePlayerInfo) : void
      {
         this._playerDic.add(param1,param2);
      }
      
      public function removePlayerInfo(param1:int) : void
      {
         this._playerDic.remove(param1);
      }
      
      public function get reliveAlertShow() : Boolean
      {
         return this._reliveAlertShow;
      }
      
      public function set reliveAlertShow(param1:Boolean) : void
      {
         this._reliveAlertShow = param1;
      }
   }
}
