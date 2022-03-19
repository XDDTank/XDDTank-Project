// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.actions.MultiRemovePlayerAction

package game.actions
{
    import road7th.data.DictionaryData;
    import flash.utils.Dictionary;
    import game.model.Player;
    import game.objects.GameTurnedLiving;
    import game.objects.BossPlayer;
    import game.objects.GamePlayer;
    import ddt.manager.StateManager;
    import ddt.states.StateType;

    public class MultiRemovePlayerAction extends BaseAction 
    {

        private var _playerList:DictionaryData;
        private var _gamePlayerList:Dictionary;

        public function MultiRemovePlayerAction(_arg_1:DictionaryData, _arg_2:Dictionary)
        {
            this._playerList = _arg_1;
            this._gamePlayerList = _arg_2;
        }

        override public function execute():void
        {
            var _local_1:Player;
            var _local_2:GameTurnedLiving;
            for each (_local_1 in this._playerList)
            {
                _local_2 = this._gamePlayerList[_local_1];
                if ((((_local_2 as GamePlayer) || (_local_2 as BossPlayer)) && (_local_1)))
                {
                    if (_local_1.isSelf)
                    {
                        StateManager.setState(StateType.DUNGEON_LIST);
                    };
                    if (((_local_2 is GamePlayer) && (GamePlayer(_local_2).gamePet)))
                    {
                        _local_2.map.removePhysical(GamePlayer(_local_2).gamePet);
                    };
                    _local_2.map.removePhysical(_local_2);
                    _local_2.dispose();
                    delete this._gamePlayerList[_local_1];
                    _local_1.dispose();
                };
            };
            this._playerList.clear();
            this._playerList = null;
            this._gamePlayerList = null;
            _isFinished = true;
        }


    }
}//package game.actions

