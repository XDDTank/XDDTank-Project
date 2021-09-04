package consortion.transportSence
{
   import consortion.consortionsence.ConsortionWalkPlayerInfo;
   import ddt.manager.PlayerManager;
   import flash.events.EventDispatcher;
   import flash.utils.setTimeout;
   import road7th.data.DictionaryData;
   
   public class TransportModel extends EventDispatcher
   {
       
      
      private var _players:DictionaryData;
      
      private var _playerBuffer:Array;
      
      public var _mapObjects:DictionaryData;
      
      public function TransportModel()
      {
         super();
         this._players = new DictionaryData(true);
         this._playerBuffer = new Array();
         this._mapObjects = new DictionaryData(true);
      }
      
      public function addPlayer(param1:ConsortionWalkPlayerInfo) : void
      {
         if(param1 != null)
         {
            this._playerBuffer.push(param1);
            setTimeout(this.addPlayerToMap,500 + this._playerBuffer.length * 200);
         }
      }
      
      public function addObjects(param1:TransportCar) : void
      {
         this._mapObjects.add(param1.info.ownerId,param1);
      }
      
      public function getObjects() : DictionaryData
      {
         return this._mapObjects;
      }
      
      public function hasMyCar() : Boolean
      {
         var _loc1_:TransportCar = null;
         for each(_loc1_ in this._mapObjects)
         {
            if(_loc1_.info.ownerId == PlayerManager.Instance.Self.ID || _loc1_.info.guarderId == PlayerManager.Instance.Self.ID)
            {
               return true;
            }
         }
         return false;
      }
      
      private function addPlayerToMap() : void
      {
         if(!this._players || !this._playerBuffer[0])
         {
            return;
         }
         this._players.add(this._playerBuffer[0].playerInfo.ID,this._playerBuffer[0]);
         this._playerBuffer.shift();
      }
      
      public function removePlayer(param1:int) : void
      {
         this._players.remove(param1);
      }
      
      public function getPlayers() : DictionaryData
      {
         return this._players;
      }
      
      public function getPlayerFromID(param1:int) : ConsortionWalkPlayerInfo
      {
         return this._players[param1];
      }
      
      public function reset() : void
      {
         this.dispose();
         this._players = new DictionaryData(true);
      }
      
      public function dispose() : void
      {
         this._players = null;
         this._playerBuffer = null;
      }
   }
}
