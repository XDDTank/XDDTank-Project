// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//worldboss.player.WorldRoomPlayer

package worldboss.player
{
    import ddt.view.scenePathSearcher.SceneScene;
    import flash.display.Sprite;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.text.GradientText;
    import ddt.view.chat.chatBall.ChatBallPlayer;
    import ddt.view.FaceContainer;
    import ddt.view.common.VipLevelIcon;
    import flash.display.MovieClip;
    import flash.geom.Point;
    import com.pickgliss.ui.ComponentFactory;
    import vip.VipController;
    import com.pickgliss.utils.DisplayUtils;
    import com.pickgliss.utils.ObjectUtils;
    import flash.events.Event;
    import ddt.view.sceneCharacter.SceneCharacterEvent;
    import worldboss.event.WorldBossScenePlayerEvent;
    import ddt.manager.ChatManager;
    import ddt.view.chat.ChatEvent;
    import ddt.view.sceneCharacter.SceneCharacterDirection;
    import worldboss.event.WorldBossRoomEvent;
    import ddt.view.chat.ChatData;
    import ddt.utils.Helpers;
    import ddt.view.chat.ChatInputView;

    public class WorldRoomPlayer extends WorldRoomPlayerBase 
    {

        private var _playerVO:PlayerVO;
        private var _sceneScene:SceneScene;
        private var _spName:Sprite;
        private var _lblName:FilterFrameText;
        private var _vipName:GradientText;
        private var _isShowName:Boolean = true;
        private var _isChatBall:Boolean = true;
        private var _isShowPlayer:Boolean = true;
        private var _chatBallView:ChatBallPlayer;
        private var _face:FaceContainer;
        private var _vipIcon:VipLevelIcon;
        private var _fightIcon:MovieClip;
        private var _tombstone:MovieClip;
        private var _isReadyFight:Boolean;
        private var _currentWalkStartPoint:Point;

        public function WorldRoomPlayer(_arg_1:PlayerVO, _arg_2:Function=null)
        {
            this._playerVO = _arg_1;
            this._currentWalkStartPoint = this._playerVO.playerPos;
            super(_arg_1.playerInfo, _arg_2);
            this.initialize();
        }

        private function initialize():void
        {
            var _local_1:int;
            moveSpeed = this._playerVO.playerMoveSpeed;
            if (this._isChatBall)
            {
                if ((!(this._chatBallView)))
                {
                    this._chatBallView = new ChatBallPlayer();
                };
                this._chatBallView.x = (((playerWitdh - this._chatBallView.width) / 2) - (playerWitdh / 2));
                this._chatBallView.y = (-(playerHeight) + 40);
                addChild(this._chatBallView);
            }
            else
            {
                if (this._chatBallView)
                {
                    this._chatBallView.clear();
                    if (this._chatBallView.parent)
                    {
                        this._chatBallView.parent.removeChild(this._chatBallView);
                    };
                    this._chatBallView.dispose();
                };
                this._chatBallView = null;
            };
            if (this._isShowName)
            {
                if ((!(this._lblName)))
                {
                    this._lblName = ComponentFactory.Instance.creat("asset.worldbossroom.characterPlayerNameAsset");
                };
                this._lblName.mouseEnabled = false;
                this._lblName.text = ((((this.playerVO) && (this.playerVO.playerInfo)) && (this.playerVO.playerInfo.NickName)) ? this.playerVO.playerInfo.NickName : "");
                this._lblName.textColor = 6029065;
                if ((!(this._spName)))
                {
                    this._spName = new Sprite();
                };
                if (this.playerVO.playerInfo.IsVIP)
                {
                    this._vipName = VipController.instance.getVipNameTxt(-1, this.playerVO.playerInfo.VIPtype);
                    this._vipName.textSize = 16;
                    this._vipName.x = this._lblName.x;
                    this._vipName.y = this._lblName.y;
                    this._vipName.text = this._lblName.text;
                    this._spName.addChild(this._vipName);
                    DisplayUtils.removeDisplay(this._lblName);
                }
                else
                {
                    this._spName.addChild(this._lblName);
                    DisplayUtils.removeDisplay(this._vipName);
                };
                if (((this.playerVO.playerInfo.IsVIP) && (!(this._vipIcon))))
                {
                    this._vipIcon = ComponentFactory.Instance.creatCustomObject("asset.worldboss.VipIcon");
                    if (this.playerVO.playerInfo.VIPtype >= 2)
                    {
                        this._vipIcon.y = (this._vipIcon.y - 5);
                    };
                    this._vipIcon.setInfo(this.playerVO.playerInfo, false);
                };
                if (this._vipIcon)
                {
                    this._spName.addChild(this._vipIcon);
                    this._lblName.x = (this._vipIcon.x + this._vipIcon.width);
                    if (this._vipName)
                    {
                        this._vipName.x = this._lblName.x;
                    };
                };
                this._spName.x = (((playerWitdh - this._spName.width) / 2) - (playerWitdh / 2));
                this._spName.y = -(playerHeight);
                this._spName.graphics.beginFill(0, 0.5);
                _local_1 = ((this._vipIcon) ? (this._lblName.textWidth + this._vipIcon.width) : (this._lblName.textWidth + 8));
                if (this.playerVO.playerInfo.IsVIP)
                {
                    _local_1 = ((this._vipIcon) ? ((this._vipName.width + this._vipIcon.width) + 8) : (this._vipName.width + 8));
                    this._spName.x = (((playerWitdh - (this._vipIcon.width + this._vipName.width)) / 2) - (playerWitdh / 2));
                };
                this._spName.graphics.drawRoundRect(-4, 0, _local_1, 22, 5, 5);
                this._spName.graphics.endFill();
                addChildAt(this._spName, 0);
                this._spName.visible = this._isShowName;
            }
            else
            {
                ObjectUtils.disposeObject(this._vipName);
                this._vipName = null;
                ObjectUtils.disposeObject(this._lblName);
                this._lblName = null;
            };
            this._face = new FaceContainer(true);
            this._face.x = (((playerWitdh - this._face.width) / 2) - (playerWitdh / 2));
            this._face.y = -90;
            addChild(this._face);
            this._fightIcon = ComponentFactory.Instance.creat("asset.worldBoss.fighting");
            addChild(this._fightIcon);
            this._fightIcon.visible = false;
            this._fightIcon.gotoAndStop(1);
            this._tombstone = ComponentFactory.Instance.creat("asset.worldBoos.tombstone");
            addChild(this._tombstone);
            this._tombstone.visible = false;
            this._tombstone.gotoAndStop(1);
            this.setStatus();
            this.setEvent();
        }

        public function setStatus():void
        {
            switch (this._playerVO.playerStauts)
            {
                case 1:
                    character.visible = true;
                    this._fightIcon.visible = false;
                    this._fightIcon.gotoAndStop(1);
                    this._tombstone.visible = false;
                    this._spName.y = -(playerHeight);
                    this._tombstone.gotoAndStop(1);
                    return;
                case 2:
                    character.visible = true;
                    this._fightIcon.visible = true;
                    this._fightIcon.gotoAndPlay(1);
                    this._tombstone.visible = false;
                    this._spName.y = -(playerHeight);
                    this._tombstone.gotoAndStop(1);
                    return;
                case 3:
                    character.visible = false;
                    this._fightIcon.visible = false;
                    this._fightIcon.gotoAndStop(1);
                    this._tombstone.visible = true;
                    this._tombstone.gotoAndPlay(1);
                    this._spName.y = (-(playerHeight) + 75);
                    return;
            };
        }

        public function revive():void
        {
            character.visible = true;
            this._fightIcon.visible = false;
            this._fightIcon.gotoAndStop(1);
            this._tombstone.visible = false;
            this._spName.y = -(playerHeight);
            this._tombstone.gotoAndStop(1);
            var _local_1:MovieClip = ComponentFactory.Instance.creat("asset.worldboss.resurrect");
            _local_1.addEventListener(Event.COMPLETE, this.__reviveComplete);
            addChildAt(_local_1, 0);
        }

        private function __reviveComplete(_arg_1:Event):void
        {
            var _local_2:MovieClip = (_arg_1.currentTarget as MovieClip);
            _local_2.parent.removeChild(_local_2);
            _local_2 = null;
        }

        private function setEvent():void
        {
            addEventListener(SceneCharacterEvent.CHARACTER_DIRECTION_CHANGE, this.characterDirectionChange);
            this._playerVO.addEventListener(WorldBossScenePlayerEvent.PLAYER_POS_CHANGE, this.__onplayerPosChangeImp);
            ChatManager.Instance.model.addEventListener(ChatEvent.ADD_CHAT, this.__getChat);
            ChatManager.Instance.addEventListener(ChatEvent.SHOW_FACE, this.__getFace);
        }

        private function __onplayerPosChangeImp(_arg_1:WorldBossScenePlayerEvent):void
        {
            playerPoint = this._playerVO.playerPos;
        }

        private function characterDirectionChange(_arg_1:SceneCharacterEvent):void
        {
            this._playerVO.scenePlayerDirection = sceneCharacterDirection;
            if (Boolean(_arg_1.data))
            {
                if (((sceneCharacterDirection == SceneCharacterDirection.LT) || (sceneCharacterDirection == SceneCharacterDirection.RT)))
                {
                    if (sceneCharacterStateType == "natural")
                    {
                        sceneCharacterActionType = "naturalWalkBack";
                    };
                }
                else
                {
                    if (((sceneCharacterDirection == SceneCharacterDirection.LB) || (sceneCharacterDirection == SceneCharacterDirection.RB)))
                    {
                        if (sceneCharacterStateType == "natural")
                        {
                            sceneCharacterActionType = "naturalWalkFront";
                        };
                    };
                };
            }
            else
            {
                if (((sceneCharacterDirection == SceneCharacterDirection.LT) || (sceneCharacterDirection == SceneCharacterDirection.RT)))
                {
                    if (sceneCharacterStateType == "natural")
                    {
                        sceneCharacterActionType = "naturalStandBack";
                    };
                }
                else
                {
                    if (((sceneCharacterDirection == SceneCharacterDirection.LB) || (sceneCharacterDirection == SceneCharacterDirection.RB)))
                    {
                        if (sceneCharacterStateType == "natural")
                        {
                            sceneCharacterActionType = "naturalStandFront";
                        };
                    };
                };
                if (this.isReadyFight)
                {
                    dispatchEvent(new WorldBossRoomEvent(WorldBossRoomEvent.READYFIGHT));
                };
            };
        }

        public function set setSceneCharacterDirectionDefault(_arg_1:SceneCharacterDirection):void
        {
            if (((_arg_1 == SceneCharacterDirection.LT) || (_arg_1 == SceneCharacterDirection.RT)))
            {
                if (sceneCharacterStateType == "natural")
                {
                    sceneCharacterActionType = "naturalStandBack";
                };
            }
            else
            {
                if (((_arg_1 == SceneCharacterDirection.LB) || (_arg_1 == SceneCharacterDirection.RB)))
                {
                    if (sceneCharacterStateType == "natural")
                    {
                        sceneCharacterActionType = "naturalStandFront";
                    };
                };
            };
        }

        public function updatePlayer():void
        {
            this.refreshCharacterState();
            this.characterMirror();
            this.playerWalkPath();
            update();
        }

        private function characterMirror():void
        {
            character.scaleX = ((sceneCharacterDirection.isMirror) ? -1 : 1);
            character.x = ((sceneCharacterDirection.isMirror) ? (playerWitdh / 2) : (-(playerWitdh) / 2));
            character.y = (-(playerHeight) + 12);
        }

        private function playerWalkPath():void
        {
            if (((((!(_walkPath == null)) && (_walkPath.length > 0)) && (this._playerVO.walkPath.length > 0)) && (!(_walkPath == this._playerVO.walkPath))))
            {
                this.fixPlayerPath();
            };
            if (((((this._playerVO) && (this._playerVO.walkPath)) && (this._playerVO.walkPath.length <= 0)) && (!(_tween.isPlaying))))
            {
                return;
            };
            this.playerWalk(this._playerVO.walkPath);
        }

        override public function playerWalk(_arg_1:Array):void
        {
            var _local_2:Number;
            if ((((!(_walkPath == null)) && (_tween.isPlaying)) && (_walkPath == this._playerVO.walkPath)))
            {
                return;
            };
            _walkPath = this._playerVO.walkPath;
            if (((_walkPath) && (_walkPath.length > 0)))
            {
                this._currentWalkStartPoint = _walkPath[0];
                sceneCharacterDirection = SceneCharacterDirection.getDirection(playerPoint, this._currentWalkStartPoint);
                dispatchEvent(new SceneCharacterEvent(SceneCharacterEvent.CHARACTER_DIRECTION_CHANGE, true));
                _local_2 = Point.distance(this._currentWalkStartPoint, playerPoint);
                _tween.start((_local_2 / _moveSpeed), "x", this._currentWalkStartPoint.x, "y", this._currentWalkStartPoint.y);
                _walkPath.shift();
            }
            else
            {
                dispatchEvent(new SceneCharacterEvent(SceneCharacterEvent.CHARACTER_DIRECTION_CHANGE, false));
            };
        }

        private function fixPlayerPath():void
        {
            var _local_3:Array;
            if (this._playerVO.currentWalkStartPoint == null)
            {
                return;
            };
            var _local_1:int = -1;
            var _local_2:int;
            while (_local_2 < _walkPath.length)
            {
                if (((_walkPath[_local_2].x == this._playerVO.currentWalkStartPoint.x) && (_walkPath[_local_2].y == this._playerVO.currentWalkStartPoint.y)))
                {
                    _local_1 = _local_2;
                    break;
                };
                _local_2++;
            };
            if (_local_1 > 0)
            {
                _local_3 = _walkPath.slice(0, _local_1);
                this._playerVO.walkPath = _local_3.concat(this._playerVO.walkPath);
            };
        }

        public function get currentWalkStartPoint():Point
        {
            return (this._currentWalkStartPoint);
        }

        private function playChangeStateMovie():void
        {
            character.visible = false;
            this._spName.visible = false;
            this._face.visible = false;
            if (((this._chatBallView) && (this._chatBallView.parent)))
            {
                this._chatBallView.parent.removeChild(this._chatBallView);
            };
        }

        public function refreshCharacterState():void
        {
            if ((((sceneCharacterDirection == SceneCharacterDirection.LT) || (sceneCharacterDirection == SceneCharacterDirection.RT)) && (_tween.isPlaying)))
            {
                sceneCharacterActionType = "naturalWalkBack";
            }
            else
            {
                if ((((sceneCharacterDirection == SceneCharacterDirection.LB) || (sceneCharacterDirection == SceneCharacterDirection.RB)) && (_tween.isPlaying)))
                {
                    sceneCharacterActionType = "naturalWalkFront";
                };
            };
            moveSpeed = this._playerVO.playerMoveSpeed;
        }

        private function __getChat(_arg_1:ChatEvent):void
        {
            if (((!(this._isChatBall)) || (!(_arg_1.data))))
            {
                return;
            };
            var _local_2:ChatData = ChatData(_arg_1.data).clone();
            if ((!(_local_2)))
            {
                return;
            };
            _local_2.msg = Helpers.deCodeString(_local_2.msg);
            if (((_local_2.channel == ChatInputView.PRIVATE) || (_local_2.channel == ChatInputView.CONSORTIA)))
            {
                return;
            };
            if ((((_local_2) && (this._playerVO.playerInfo)) && (_local_2.senderID == this._playerVO.playerInfo.ID)))
            {
                this._chatBallView.setText(_local_2.msg, this._playerVO.playerInfo.paopaoType);
                if ((!(this._chatBallView.parent)))
                {
                    addChildAt(this._chatBallView, (this.getChildIndex(character) + 1));
                };
            };
        }

        private function __getFace(_arg_1:ChatEvent):void
        {
            var _local_2:Object = _arg_1.data;
            if (_local_2["playerid"] == this._playerVO.playerInfo.ID)
            {
                this._face.setFace(_local_2["faceid"]);
            };
        }

        public function get playerVO():PlayerVO
        {
            return (this._playerVO);
        }

        public function set playerVO(_arg_1:PlayerVO):void
        {
            this._playerVO = _arg_1;
        }

        public function get isShowName():Boolean
        {
            return (this._isShowName);
        }

        public function set isShowName(_arg_1:Boolean):void
        {
            this._isShowName = _arg_1;
            if ((!(this._spName)))
            {
                return;
            };
            this._spName.visible = this._isShowName;
        }

        public function get isChatBall():Boolean
        {
            return (this._isChatBall);
        }

        public function set isChatBall(_arg_1:Boolean):void
        {
            if (((this._isChatBall == _arg_1) || (!(this._chatBallView))))
            {
                return;
            };
            this._isChatBall = _arg_1;
            if (this._isChatBall)
            {
                addChildAt(this._chatBallView, (this.getChildIndex(character) + 1));
            }
            else
            {
                if (((this._chatBallView) && (this._chatBallView.parent)))
                {
                    this._chatBallView.parent.removeChild(this._chatBallView);
                };
            };
        }

        public function get isShowPlayer():Boolean
        {
            return (this._isShowPlayer);
        }

        public function set isShowPlayer(_arg_1:Boolean):void
        {
            if (((this._isShowPlayer == _arg_1) || (!(this._isShowPlayer))))
            {
                return;
            };
            this._isShowPlayer = _arg_1;
            this.visible = this._isShowPlayer;
        }

        public function get sceneScene():SceneScene
        {
            return (this._sceneScene);
        }

        public function set sceneScene(_arg_1:SceneScene):void
        {
            this._sceneScene = _arg_1;
        }

        public function get ID():int
        {
            return (this._playerVO.playerInfo.ID);
        }

        public function get isReadyFight():Boolean
        {
            return (this._isReadyFight);
        }

        public function set isReadyFight(_arg_1:Boolean):void
        {
            this._isReadyFight = _arg_1;
        }

        public function getCanAction():Boolean
        {
            return (!(this._tombstone.visible));
        }

        override public function dispose():void
        {
            removeEventListener(SceneCharacterEvent.CHARACTER_DIRECTION_CHANGE, this.characterDirectionChange);
            ChatManager.Instance.model.removeEventListener(ChatEvent.ADD_CHAT, this.__getChat);
            ChatManager.Instance.removeEventListener(ChatEvent.SHOW_FACE, this.__getFace);
            if (this._playerVO)
            {
                this._playerVO.removeEventListener(WorldBossScenePlayerEvent.PLAYER_POS_CHANGE, this.__onplayerPosChangeImp);
            };
            this._sceneScene = null;
            if (((this._lblName) && (this._lblName.parent)))
            {
                this._lblName.parent.removeChild(this._lblName);
            };
            this._lblName = null;
            ObjectUtils.disposeObject(this._vipName);
            this._vipName = null;
            if (this._chatBallView)
            {
                this._chatBallView.clear();
                if (this._chatBallView.parent)
                {
                    this._chatBallView.parent.removeChild(this._chatBallView);
                };
                this._chatBallView.dispose();
            };
            this._chatBallView = null;
            if (this._face)
            {
                this._face.clearFace();
                if (this._face.parent)
                {
                    this._face.parent.removeChild(this._face);
                };
                this._face.dispose();
            };
            this._face = null;
            if (this._vipIcon)
            {
                this._vipIcon.dispose();
            };
            this._vipIcon = null;
            if (this._playerVO)
            {
                this._playerVO.dispose();
            };
            this._playerVO = null;
            if (((this._spName) && (this._spName.parent)))
            {
                this._spName.parent.removeChild(this._spName);
            };
            this._spName = null;
            if (((this._fightIcon) && (this._fightIcon.parent)))
            {
                this._fightIcon.parent.removeChild(this._fightIcon);
            };
            this._fightIcon = null;
            if (((this._tombstone) && (this._tombstone.parent)))
            {
                this._tombstone.parent.removeChild(this._tombstone);
            };
            this._tombstone = null;
            super.dispose();
        }


    }
}//package worldboss.player

