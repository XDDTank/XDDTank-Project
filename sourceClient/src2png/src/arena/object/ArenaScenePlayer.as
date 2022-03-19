// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//arena.object.ArenaScenePlayer

package arena.object
{
    import ddt.view.sceneCharacter.SceneCharacterPlayer;
    import game.view.playerThumbnail.BloodItem;
    import arena.view.ArenaKingIcon;
    import flash.display.MovieClip;
    import ddt.view.sceneCharacter.SceneCharacterPlayerInfo;
    import arena.model.ArenaScenePlayerInfo;
    import arena.ArenaManager;
    import ddt.utils.PositionUtils;
    import arena.model.ArenaPlayerStates;
    import ddt.data.BuffType;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.view.sceneCharacter.SceneCharacterStateSet;
    import ddt.view.sceneCharacter.SceneCharacterActionSet;
    import ddt.view.sceneCharacter.SceneCharacterSet;
    import ddt.view.sceneCharacter.SceneCharacterEvent;
    import ddt.manager.ChatManager;
    import ddt.view.chat.ChatEvent;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import ddt.manager.PlayerManager;
    import ddt.manager.TimeManager;
    import ddt.manager.CusCursorManager;
    import flash.ui.Mouse;
    import flash.ui.MouseCursor;
    import com.pickgliss.utils.ObjectUtils;

    public class ArenaScenePlayer extends SceneCharacterPlayer 
    {

        public static const PROTECTED_TIME:int = 5;

        private var _blood:BloodItem;
        private var _kingIcon:ArenaKingIcon;
        private var _buffer:MovieClip;
        private var _tempTime:int;
        private var _mouseIn:Boolean;

        public function ArenaScenePlayer(_arg_1:SceneCharacterPlayerInfo, _arg_2:Function=null)
        {
            super(_arg_1, _arg_2);
        }

        public function get arenaPlayerInfo():ArenaScenePlayerInfo
        {
            return (_scenePlayerInfo as ArenaScenePlayerInfo);
        }

        public function set arenaPlayerInfo(_arg_1:ArenaScenePlayerInfo):void
        {
            _scenePlayerInfo = _arg_1;
        }

        public function fight(_arg_1:ArenaScenePlayer):void
        {
            ArenaManager.instance.sendFight(_arg_1.playerInfo.ID);
        }

        override protected function updateStatus():void
        {
            super.updateStatus();
            this._blood.setProgress(this.arenaPlayerInfo.arenaCurrentBlood, this.arenaPlayerInfo.playerInfo.hp);
            if (this.arenaPlayerInfo.playerType == 1)
            {
                if ((!(this._kingIcon)))
                {
                    this._kingIcon = new ArenaKingIcon(this.arenaPlayerInfo.playerInfo);
                    PositionUtils.setPos(this._kingIcon, "ddtarena.scenePlayer.kingiconPos");
                    addChild(this._kingIcon);
                };
                if (this._kingIcon.visible == false)
                {
                    this._kingIcon.visible = true;
                };
            }
            else
            {
                if (((this._kingIcon) && (this._kingIcon.visible == true)))
                {
                    this._kingIcon.visible = false;
                };
            };
            if (((this.arenaPlayerInfo.bufferType == BuffType.ARENA_MARS) && (!(this.arenaPlayerInfo.playerStauts == ArenaPlayerStates.DEATH))))
            {
                if ((!(this._buffer)))
                {
                    this._buffer = (ComponentFactory.Instance.creat("ddtarena.buffer.1") as MovieClip);
                    PositionUtils.setPos(this._buffer, "ddtarena.scenePlayer.buffer1Pos");
                    addChild(this._buffer);
                };
                if (this._buffer.visible == false)
                {
                    this._buffer.visible = true;
                };
            }
            else
            {
                if (((this._buffer) && (this._buffer.visible == true)))
                {
                    this._buffer.visible = false;
                };
            };
            this.reloaderBodyNatural();
        }

        override protected function sceneCharacterLoadBodyNatural():void
        {
            _sceneCharacterLoaderBody = new ArenaSceneCharacterLoaderBody(playerInfo, this.arenaPlayerInfo.playerType);
            _sceneCharacterLoaderBody.load(sceneCharacterLoaderBodyNaturalCallBack);
        }

        private function reloaderBodyNatural():void
        {
            if (ArenaSceneCharacterLoaderBody(_sceneCharacterLoaderBody).playerType != this.arenaPlayerInfo.playerType)
            {
                _sceneCharacterStateSet = new SceneCharacterStateSet();
                _sceneCharacterActionSetNatural = new SceneCharacterActionSet();
                _sceneCharacterSetNatural = new SceneCharacterSet();
                while (((character) && (character.numChildren > 0)))
                {
                    character.removeChildAt(0);
                };
                sceneCharacterStateType = "";
                sceneCharacterLoadHead();
            };
        }

        override protected function initEvent():void
        {
            addEventListener(SceneCharacterEvent.CHARACTER_DIRECTION_CHANGE, __characterDirectionChange);
            ArenaManager.instance.model.addEventListener(SceneCharacterEvent.CHARACTER_PLAYER_POS_CHANGED, this.__onPlayerPosChange);
            ChatManager.Instance.model.addEventListener(ChatEvent.ADD_CHAT, __getChat);
            _relive.addEventListener(Event.COMPLETE, __reliveComplete);
            addEventListener(MouseEvent.CLICK, this.__mouseClick);
            addEventListener(MouseEvent.MOUSE_OVER, this.__mouseOver);
            addEventListener(MouseEvent.MOUSE_OUT, this.__mouseOut);
        }

        override protected function __onPlayerPosChange(_arg_1:SceneCharacterEvent):void
        {
            if (_arg_1.data == this.arenaPlayerInfo.playerInfo.ID)
            {
                playerPoint = this.arenaPlayerInfo.playerPos;
            };
        }

        private function __mouseClick(_arg_1:MouseEvent):void
        {
            if (playerInfo.ID != PlayerManager.Instance.Self.ID)
            {
                ArenaManager.instance.model.targetPlayer = this;
            };
        }

        private function checkProtectedTime():Boolean
        {
            var _local_1:Date = this.arenaPlayerInfo.enterTime;
            var _local_2:Date = TimeManager.Instance.Now();
            if (((_local_2.time - _local_1.time) / 1000) > PROTECTED_TIME)
            {
                return (false);
            };
            return (true);
        }

        private function __mouseOver(_arg_1:MouseEvent):void
        {
            if (playerInfo.ID != PlayerManager.Instance.Self.ID)
            {
                CusCursorManager.instance.mouseType = CusCursorManager.ATTACT;
                Mouse.cursor = CusCursorManager.ATTACT;
            };
        }

        private function __mouseOut(_arg_1:MouseEvent):void
        {
            CusCursorManager.instance.mouseType = CusCursorManager.NORMAL;
            Mouse.cursor = MouseCursor.AUTO;
        }

        override protected function removeEvent():void
        {
            removeEventListener(SceneCharacterEvent.CHARACTER_DIRECTION_CHANGE, __characterDirectionChange);
            ArenaManager.instance.model.removeEventListener(SceneCharacterEvent.CHARACTER_PLAYER_POS_CHANGED, this.__onPlayerPosChange);
            ChatManager.Instance.model.removeEventListener(ChatEvent.ADD_CHAT, __getChat);
            _relive.removeEventListener(Event.COMPLETE, __reliveComplete);
            removeEventListener(MouseEvent.CLICK, this.__mouseClick);
            removeEventListener(MouseEvent.MOUSE_OVER, this.__mouseOver);
            removeEventListener(MouseEvent.MOUSE_OUT, this.__mouseOut);
        }

        override protected function drawSpName():void
        {
            _spName.y = -(playerHeight);
            _spName.graphics.beginFill(0, 0.5);
            var _local_1:int = ((_levelIcon) ? (_lblName.textWidth + _levelIcon.width) : (_lblName.textWidth + 8));
            if (scenePlayerInfo.playerInfo.IsVIP)
            {
                _local_1 = ((_vipIcon) ? ((_vipName.width + _vipIcon.width) + 8) : (_vipName.width + 8));
                _spName.x = (-(_vipIcon.width + _vipName.width) / 2);
                _levelIcon.x = _vipIcon.x;
            }
            else
            {
                _local_1 = ((_levelIcon) ? ((_lblName.width + _levelIcon.width) + 8) : (_lblName.width + 8));
                _spName.x = (-(_levelIcon.width + _lblName.width) / 2);
                _lblName.x = (_levelIcon.x + _levelIcon.width);
            };
            _spName.graphics.drawRoundRect(-4, 0, _local_1, 22, 5, 5);
            _spName.graphics.endFill();
            addChildAt(_spName, 0);
        }

        override protected function initView():void
        {
            _isChatBall = false;
            super.initView();
            this.mouseEnabled = true;
            this._blood = new BloodItem(this.arenaPlayerInfo.playerInfo.hp);
            addChild(this._blood);
            if (_vipIcon)
            {
                _vipIcon.visible = false;
            };
            if (_levelIcon)
            {
                _levelIcon.visible = true;
            };
            this.setPos();
        }

        private function setPos():void
        {
            PositionUtils.setPos(_spName, "ddtarena.scenePlayer.namePos");
            _spName.x = ((-(_spName.width) / 2) + 5);
            PositionUtils.setPos(this._blood, "ddtarena.scenePlayer.bloodPos");
        }

        override public function dispose():void
        {
            ObjectUtils.disposeObject(this._blood);
            this._blood = null;
            ObjectUtils.disposeObject(this._kingIcon);
            this._kingIcon = null;
            super.dispose();
        }


    }
}//package arena.object

