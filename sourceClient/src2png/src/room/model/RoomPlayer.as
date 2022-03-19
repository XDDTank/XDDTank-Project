// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//room.model.RoomPlayer

package room.model
{
    import flash.events.EventDispatcher;
    import ddt.data.player.PlayerInfo;
    import game.model.PlayerAdditionInfo;
    import ddt.view.character.ShowCharacter;
    import ddt.view.character.GameCharacter;
    import ddt.view.character.RoomCharacter;
    import ddt.events.WebSpeedEvent;
    import ddt.data.player.SelfInfo;
    import com.pickgliss.utils.ObjectUtils;
    import room.events.RoomPlayerEvent;
    import ddt.manager.ItemManager;
    import ddt.view.character.CharactoryFactory;

    [Event(name="ready_change", type="room.events.RoomPlayerEvent")]
    [Event(name="is_host_change", type="room.events.RoomPlayerEvent")]
    public class RoomPlayer extends EventDispatcher 
    {

        public static const BLUE_TEAM:uint = 1;
        public static const RED_TEAM:uint = 2;

        private var _playerInfo:PlayerInfo;
        private var _team:int;
        private var _place:int;
        private var _isHost:Boolean;
        private var _isReady:Boolean;
        private var _isStarted:Boolean;
        private var _webSpeedInfo:WebSpeedInfo;
        private var _progress:Number;
        private var _additionInfo:PlayerAdditionInfo;
        private var _isFirstIn:Boolean;
        private var _character:ShowCharacter;
        private var _movie:GameCharacter;
        private var _roomCharater:RoomCharacter;

        public function RoomPlayer(_arg_1:PlayerInfo)
        {
            this._playerInfo = _arg_1;
            this.initEvents();
            this._webSpeedInfo = new WebSpeedInfo(this._playerInfo.webSpeed);
            this._additionInfo = new PlayerAdditionInfo();
        }

        public function get isViewer():Boolean
        {
            return (this._place >= 6);
        }

        private function initEvents():void
        {
            this._playerInfo.addEventListener(WebSpeedEvent.STATE_CHANE, this.__webSpeedHandler);
        }

        private function removeEvents():void
        {
            if (this._playerInfo)
            {
                this._playerInfo.removeEventListener(WebSpeedEvent.STATE_CHANE, this.__webSpeedHandler);
            };
        }

        private function __webSpeedHandler(_arg_1:WebSpeedEvent):void
        {
            this._webSpeedInfo.delay = this._playerInfo.webSpeed;
        }

        public function get webSpeedInfo():WebSpeedInfo
        {
            return (this._webSpeedInfo);
        }

        public function hasDeputyWeapon():Boolean
        {
            return (this._playerInfo.DeputyWeaponID > 0);
        }

        public function get team():int
        {
            return (this._team);
        }

        public function set team(_arg_1:int):void
        {
            this._team = _arg_1;
        }

        public function get place():int
        {
            return (this._place);
        }

        public function set place(_arg_1:int):void
        {
            this._place = _arg_1;
        }

        public function get isFirstIn():Boolean
        {
            return (this._isFirstIn);
        }

        public function set isFirstIn(_arg_1:Boolean):void
        {
            this._isFirstIn = _arg_1;
        }

        public function get playerInfo():PlayerInfo
        {
            return (this._playerInfo);
        }

        public function get isSelf():Boolean
        {
            return (this.playerInfo is SelfInfo);
        }

        public function dispose():void
        {
            this.removeEvents();
            this._playerInfo = null;
            this._webSpeedInfo = null;
            if (this._character)
            {
                this._character.dispose();
            };
            this._character = null;
            ObjectUtils.disposeObject(this._movie);
            this._movie = null;
            if (this._roomCharater)
            {
                this._roomCharater.dispose();
            };
            this._roomCharater = null;
        }

        public function get isHost():Boolean
        {
            return (this._isHost);
        }

        public function set isHost(_arg_1:Boolean):void
        {
            this._isHost = _arg_1;
            dispatchEvent(new RoomPlayerEvent(RoomPlayerEvent.IS_HOST_CHANGE));
        }

        public function get isReady():Boolean
        {
            return (this._isReady);
        }

        public function set isReady(_arg_1:Boolean):void
        {
            this._isReady = _arg_1;
            dispatchEvent(new RoomPlayerEvent(RoomPlayerEvent.READY_CHANGE));
        }

        public function get isStarted():Boolean
        {
            return (this._isStarted);
        }

        public function set isStarted(_arg_1:Boolean):void
        {
            this._isStarted = _arg_1;
            dispatchEvent(new RoomPlayerEvent(RoomPlayerEvent.IS_START));
        }

        public function get progress():Number
        {
            return (this._progress);
        }

        public function set progress(_arg_1:Number):void
        {
            this._progress = _arg_1;
            dispatchEvent(new RoomPlayerEvent(RoomPlayerEvent.PROGRESS_CHANGE));
        }

        public function get additionInfo():PlayerAdditionInfo
        {
            return (this._additionInfo);
        }

        public function get currentWeapInfo():WeaponInfo
        {
            return (new WeaponInfo(ItemManager.Instance.getTemplateById(this._playerInfo.WeaponID)));
        }

        public function get currentDeputyWeaponInfo():DeputyWeaponInfo
        {
            return (new DeputyWeaponInfo(ItemManager.Instance.getTemplateById(this._playerInfo.DeputyWeaponID)));
        }

        public function get character():ShowCharacter
        {
            if (this._character == null)
            {
                this._character = (CharactoryFactory.createCharacter(this._playerInfo, CharactoryFactory.SHOW, true) as ShowCharacter);
            };
            return (this._character);
        }

        public function get movie():GameCharacter
        {
            if (this._movie == null)
            {
                this._movie = (CharactoryFactory.createCharacter(this._playerInfo, CharactoryFactory.GAME) as GameCharacter);
            };
            return (this._movie);
        }

        public function get roomCharater():RoomCharacter
        {
            if (this._roomCharater == null)
            {
                this._roomCharater = (CharactoryFactory.createCharacter(this._playerInfo, CharactoryFactory.ROOM) as RoomCharacter);
            };
            this._roomCharater.showGun = true;
            return (this._roomCharater);
        }

        public function resetCharacter():void
        {
            if (this._character)
            {
                this._character.x = 0;
                this._character.y = 0;
                this._character.doAction(ShowCharacter.STAND);
            };
        }


    }
}//package room.model

