// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.sceneCharacter.SceneCharacterPlayerInfo

package ddt.view.sceneCharacter
{
    import flash.events.EventDispatcher;
    import flash.geom.Point;
    import ddt.data.player.PlayerInfo;

    public class SceneCharacterPlayerInfo extends EventDispatcher 
    {

        protected var _playerPos:Point;
        protected var _playerNickName:String;
        protected var _playerSex:Boolean;
        protected var _playerInfo:PlayerInfo;
        protected var _walkPath:Array = [];
        protected var _sceneCharacterDirection:SceneCharacterDirection = SceneCharacterDirection.LB;
        protected var _playerDirection:int = 4;
        protected var _playerMoveSpeed:Number = 0.15;
        protected var _currenWalkStartPoint:Point;
        protected var _playerStauts:int = 1;


        public function set playerStauts(_arg_1:int):void
        {
            this._playerStauts = _arg_1;
        }

        public function get playerStauts():int
        {
            return (this._playerStauts);
        }

        public function set currenWalkStartPoint(_arg_1:Point):void
        {
            this._currenWalkStartPoint = _arg_1;
        }

        public function get currenWalkStartPoint():Point
        {
            return (this._currenWalkStartPoint);
        }

        public function get playerPos():Point
        {
            if (this._playerPos)
            {
                return (this._playerPos);
            };
            return (new Point(300, 400));
        }

        public function set playerPos(_arg_1:Point):void
        {
            this._playerPos = _arg_1;
            if (this._playerInfo)
            {
                dispatchEvent(new SceneCharacterEvent(SceneCharacterEvent.CHARACTER_PLAYER_POS_CHANGED, this._playerInfo.ID));
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
                this._sceneCharacterDirection = SceneCharacterDirection.LB;
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

        public function clone():SceneCharacterPlayerInfo
        {
            var _local_1:SceneCharacterPlayerInfo = new SceneCharacterPlayerInfo();
            _local_1.playerInfo = this._playerInfo;
            _local_1.playerPos = this._playerPos;
            _local_1.playerDirection = this._playerDirection;
            _local_1.walkPath = this._walkPath;
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
}//package ddt.view.sceneCharacter

