// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//arena.model.ArenaScenePlayerInfo

package arena.model
{
    import ddt.view.sceneCharacter.SceneCharacterPlayerInfo;
    import arena.ArenaManager;
    import ddt.view.sceneCharacter.SceneCharacterEvent;
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


        public function get arenaCurrentBlood():Number
        {
            return (this._arenaCurrentBlood);
        }

        public function set arenaCurrentBlood(_arg_1:Number):void
        {
            this._arenaCurrentBlood = _arg_1;
        }

        public function get sceneLevel():int
        {
            return (this._sceneLevel);
        }

        public function set sceneLevel(_arg_1:int):void
        {
            this._sceneLevel = _arg_1;
        }

        public function get sceneID():int
        {
            return (this._sceneID);
        }

        public function set sceneID(_arg_1:int):void
        {
            this._sceneID = _arg_1;
        }

        public function get arenaFightScore():int
        {
            return (this._arenaFightScore);
        }

        public function set arenaFightScore(_arg_1:int):void
        {
            this._arenaFightScore = _arg_1;
        }

        public function get arenaCount():int
        {
            return (this._arenaCount);
        }

        public function set arenaCount(_arg_1:int):void
        {
            this._arenaCount = _arg_1;
        }

        public function get arenaFlag():int
        {
            return (this._arenaFlag);
        }

        public function set arenaFlag(_arg_1:int):void
        {
            this._arenaFlag = _arg_1;
        }

        public function get arenaMaxWin():int
        {
            return (this._arenaMaxWin);
        }

        public function set arenaMaxWin(_arg_1:int):void
        {
            this._arenaMaxWin = _arg_1;
        }

        public function get playerType():int
        {
            return (this._playerType);
        }

        public function set playerType(_arg_1:int):void
        {
            this._playerType = _arg_1;
        }

        public function get isKing():Boolean
        {
            return (this.playerType == 1);
        }

        public function get updateType():Boolean
        {
            return (this._updateType);
        }

        public function set updateType(_arg_1:Boolean):void
        {
            this._updateType = _arg_1;
        }

        public function get arenaWinScore():int
        {
            return (this._arenaWinScore);
        }

        public function set arenaWinScore(_arg_1:int):void
        {
            this._arenaWinScore = _arg_1;
        }

        public function get enterTime():Date
        {
            return (this._enterTime);
        }

        public function set enterTime(_arg_1:Date):void
        {
            this._enterTime = _arg_1;
        }

        public function get bufferType():int
        {
            return (this._bufferType);
        }

        public function set bufferType(_arg_1:int):void
        {
            this._bufferType = _arg_1;
        }

        override public function set playerPos(_arg_1:Point):void
        {
            _playerPos = _arg_1;
            if (_playerInfo)
            {
                ArenaManager.instance.model.dispatchEvent(new SceneCharacterEvent(SceneCharacterEvent.CHARACTER_PLAYER_POS_CHANGED, _playerInfo.ID));
            };
        }


    }
}//package arena.model

