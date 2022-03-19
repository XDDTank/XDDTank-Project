// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//SingleDungeon.model.SingleDungeonPlayerInfo

package SingleDungeon.model
{
    import flash.events.EventDispatcher;
    import flash.geom.Point;
    import ddt.data.player.PlayerInfo;
    import ddt.view.sceneCharacter.SceneCharacterDirection;
    import SingleDungeon.event.WalkMapEvent;

    public class SingleDungeonPlayerInfo extends EventDispatcher 
    {

        private var _playerPos:Point;
        private var _playerNickName:String;
        private var _playerSex:Boolean;
        private var _playerInfo:PlayerInfo;
        private var _walkPath:Array = [];
        private var _sceneCharacterDirection:SceneCharacterDirection = SceneCharacterDirection.RT;
        private var _playerDirection:int = 3;
        private var _playerMoveSpeed:Number = 0.15;
        public var currentWalkStartPoint:Point;
        private var _playerStauts:int = 1;


        public function set playerStauts(_arg_1:int):void
        {
            this._playerStauts = _arg_1;
        }

        public function get playerStauts():int
        {
            return (this._playerStauts);
        }

        public function get playerPos():Point
        {
            return (this._playerPos);
        }

        public function set playerPos(_arg_1:Point):void
        {
            this._playerPos = _arg_1;
            if (this._playerInfo)
            {
                dispatchEvent(new WalkMapEvent(WalkMapEvent.WALKMAP_PLAYER_POS_CHANGED, this._playerInfo.ID));
            };
        }

        public function get playerInfo():PlayerInfo
        {
            return (this._playerInfo);
        }

        public function set playerInfo(_arg_1:PlayerInfo):void
        {
            this._playerInfo = _arg_1;
        }

        public function get walkPath():Array
        {
            return (this._walkPath);
        }

        public function set walkPath(_arg_1:Array):void
        {
            this._walkPath = _arg_1;
        }

        public function get scenePlayerDirection():SceneCharacterDirection
        {
            if ((!(this._sceneCharacterDirection)))
            {
                this._sceneCharacterDirection = SceneCharacterDirection.RT;
            };
            return (this._sceneCharacterDirection);
        }

        public function set scenePlayerDirection(_arg_1:SceneCharacterDirection):void
        {
            this._sceneCharacterDirection = _arg_1;
            switch (this._sceneCharacterDirection)
            {
                case SceneCharacterDirection.RT:
                    this._playerDirection = 1;
                    return;
                case SceneCharacterDirection.LT:
                    this._playerDirection = 2;
                    return;
                case SceneCharacterDirection.RB:
                    this._playerDirection = 3;
                    return;
                case SceneCharacterDirection.LB:
                    this._playerDirection = 4;
                    return;
            };
        }

        public function get playerDirection():int
        {
            return (this._playerDirection);
        }

        public function set playerDirection(_arg_1:int):void
        {
            this._playerDirection = _arg_1;
            switch (this._playerDirection)
            {
                case 1:
                    this._sceneCharacterDirection = SceneCharacterDirection.RT;
                    return;
                case 2:
                    this._sceneCharacterDirection = SceneCharacterDirection.LT;
                    return;
                case 3:
                    this._sceneCharacterDirection = SceneCharacterDirection.RB;
                    return;
                case 4:
                    this._sceneCharacterDirection = SceneCharacterDirection.LB;
                    return;
            };
        }

        public function get playerMoveSpeed():Number
        {
            return (this._playerMoveSpeed);
        }

        public function set playerMoveSpeed(_arg_1:Number):void
        {
            if (this._playerMoveSpeed == _arg_1)
            {
                return;
            };
            this._playerMoveSpeed = _arg_1;
        }

        public function clone():SingleDungeonPlayerInfo
        {
            var _local_1:SingleDungeonPlayerInfo = new SingleDungeonPlayerInfo();
            _local_1.playerInfo = this._playerInfo;
            _local_1.playerPos = this._playerPos;
            _local_1.walkPath = this._walkPath;
            _local_1.playerDirection = this._playerDirection;
            _local_1.playerMoveSpeed = this._playerMoveSpeed;
            return (_local_1);
        }

        public function dispose():void
        {
            while (((this._walkPath) && (this._walkPath.length > 0)))
            {
                this._walkPath.shift();
            };
            this._walkPath = null;
            this._playerPos = null;
            this._sceneCharacterDirection = null;
        }


    }
}//package SingleDungeon.model

