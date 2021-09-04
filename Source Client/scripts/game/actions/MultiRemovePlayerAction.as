package game.actions
{
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import flash.utils.Dictionary;
   import game.model.Player;
   import game.objects.BossPlayer;
   import game.objects.GamePlayer;
   import game.objects.GameTurnedLiving;
   import road7th.data.DictionaryData;
   
   public class MultiRemovePlayerAction extends BaseAction
   {
       
      
      private var _playerList:DictionaryData;
      
      private var _gamePlayerList:Dictionary;
      
      public function MultiRemovePlayerAction(param1:DictionaryData, param2:Dictionary)
      {
         super();
         this._playerList = param1;
         this._gamePlayerList = param2;
      }
      
      override public function execute() : void
      {
         var _loc1_:Player = null;
         var _loc2_:GameTurnedLiving = null;
         for each(_loc1_ in this._playerList)
         {
            _loc2_ = this._gamePlayerList[_loc1_];
            if((_loc2_ as GamePlayer || _loc2_ as BossPlayer) && _loc1_)
            {
               if(_loc1_.isSelf)
               {
                  StateManager.setState(StateType.DUNGEON_LIST);
               }
               if(_loc2_ is GamePlayer && GamePlayer(_loc2_).gamePet)
               {
                  _loc2_.map.removePhysical(GamePlayer(_loc2_).gamePet);
               }
               _loc2_.map.removePhysical(_loc2_);
               _loc2_.dispose();
               delete this._gamePlayerList[_loc1_];
               _loc1_.dispose();
            }
         }
         this._playerList.clear();
         this._playerList = null;
         this._gamePlayerList = null;
         _isFinished = true;
      }
   }
}
