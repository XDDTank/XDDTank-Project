// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//arena.ArenaModel

package arena
{
    import flash.events.EventDispatcher;
    import arena.object.ArenaScenePlayer;
    import road7th.data.DictionaryData;
    import arena.model.ArenaScenePlayerInfo;
    import ddt.manager.PlayerManager;
    import arena.model.ArenaPlayerStates;
    import flash.geom.Point;
    import arena.model.ArenaEvent;
    import flash.utils.clearTimeout;

    public class ArenaModel extends EventDispatcher 
    {

        private var _targetPlayer:ArenaScenePlayer;
        private var _playerDic:DictionaryData = new DictionaryData();
        private var _playerBuffer:Array = new Array();
        private var _selfInfo:ArenaScenePlayerInfo;
        private var _reliveAlertShow:Boolean = true;
        private var _timeOut:uint;


        public function get targetPlayer():ArenaScenePlayer
        {
            return (this._targetPlayer);
        }

        public function set targetPlayer(_arg_1:ArenaScenePlayer):void
        {
            this._targetPlayer = _arg_1;
        }

        public function get selfInfo():ArenaScenePlayerInfo
        {
            if ((!(this._selfInfo)))
            {
                this._selfInfo = new ArenaScenePlayerInfo();
                this._selfInfo.playerInfo = PlayerManager.Instance.Self;
                this._selfInfo.arenaCurrentBlood = this._selfInfo.playerInfo.hp;
                this._selfInfo.playerStauts = ArenaPlayerStates.LOADING;
                this._selfInfo.playerPos = new Point(0, 0);
            };
            return (this._selfInfo);
        }

        public function set selfInfo(_arg_1:ArenaScenePlayerInfo):void
        {
            this._selfInfo = _arg_1;
            dispatchEvent(new ArenaEvent(ArenaEvent.UPDATE_SELF));
        }

        public function get playerDic():DictionaryData
        {
            return (this._playerDic);
        }

        public function clearPlayer():void
        {
            this._playerDic = new DictionaryData();
            this._playerBuffer = new Array();
            clearTimeout(this._timeOut);
        }

        public function addPlayerInfo(_arg_1:int, _arg_2:ArenaScenePlayerInfo):void
        {
            this._playerDic.add(_arg_1, _arg_2);
        }

        public function updatePlayerInfo(_arg_1:int, _arg_2:ArenaScenePlayerInfo):void
        {
            if (this._playerDic.hasKey(_arg_1))
            {
                this.addPlayerInfo(_arg_1, _arg_2);
            };
        }

        private function doAddPlayer():void
        {
            if (((!(this._playerDic)) || (!(this._playerBuffer[0]))))
            {
                return;
            };
            this._playerDic.add(this._playerBuffer[0].playerInfo.ID, this._playerBuffer[0]);
            this._playerBuffer.shift();
        }

        public function addPlayerInfoRightNow(_arg_1:int, _arg_2:ArenaScenePlayerInfo):void
        {
            this._playerDic.add(_arg_1, _arg_2);
        }

        public function removePlayerInfo(_arg_1:int):void
        {
            this._playerDic.remove(_arg_1);
        }

        public function get reliveAlertShow():Boolean
        {
            return (this._reliveAlertShow);
        }

        public function set reliveAlertShow(_arg_1:Boolean):void
        {
            this._reliveAlertShow = _arg_1;
        }


    }
}//package arena

