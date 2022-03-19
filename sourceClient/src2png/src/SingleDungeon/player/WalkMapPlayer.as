// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//SingleDungeon.player.WalkMapPlayer

package SingleDungeon.player
{
    import SingleDungeon.model.SingleDungeonPlayerInfo;
    import ddt.view.scenePathSearcher.SceneScene;
    import flash.display.Sprite;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.text.GradientText;
    import ddt.view.chat.chatBall.ChatBallPlayer;
    import ddt.view.FaceContainer;
    import ddt.view.common.VipLevelIcon;
    import flash.display.MovieClip;
    import flash.geom.Point;
    import com.pickgliss.utils.ClassUtils;
    import com.pickgliss.ui.ComponentFactory;
    import vip.VipController;
    import com.pickgliss.utils.DisplayUtils;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.view.sceneCharacter.SceneCharacterEvent;
    import SingleDungeon.event.WalkMapEvent;
    import ddt.manager.ChatManager;
    import ddt.view.chat.ChatEvent;
    import ddt.view.sceneCharacter.SceneCharacterDirection;
    import ddt.view.chat.ChatData;
    import ddt.utils.Helpers;
    import ddt.view.chat.ChatInputView;

    public class WalkMapPlayer extends WalkMapPlayerBase 
    {

        private var _singleDungeonPlayerInfo:SingleDungeonPlayerInfo;
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
        public var isRobot:Boolean;
        public var defaultBody:MovieClip;
        private var _currentWalkStartPoint:Point;

        public function WalkMapPlayer(_arg_1:SingleDungeonPlayerInfo, _arg_2:Function=null)
        {
            this._singleDungeonPlayerInfo = _arg_1;
            this._currentWalkStartPoint = this._singleDungeonPlayerInfo.playerPos;
            super(_arg_1.playerInfo, _arg_2);
            this.mouseChildren = false;
            this.mouseEnabled = false;
            this.isRobot = _arg_1.playerInfo.isRobot;
            this.defaultBody = (ClassUtils.CreatInstance("asset.game.bodyDefaultPlayer") as MovieClip);
            this.defaultBody.x = _arg_1.playerPos.x;
            this.defaultBody.y = (_arg_1.playerPos.y - 70);
            this.initialize();
        }

        private function initialize():void
        {
            var _local_2:int;
            moveSpeed = this._singleDungeonPlayerInfo.playerMoveSpeed;
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
                    this._lblName = ComponentFactory.Instance.creat("singleDungeon.sencemap.playerNameTxt");
                };
                this._lblName.mouseEnabled = false;
                this._lblName.text = ((((this._singleDungeonPlayerInfo) && (this._singleDungeonPlayerInfo.playerInfo)) && (this._singleDungeonPlayerInfo.playerInfo.NickName)) ? this._singleDungeonPlayerInfo.playerInfo.NickName : "");
                this._lblName.textColor = 6029065;
                if ((!(this._spName)))
                {
                    this._spName = new Sprite();
                };
                if (this._singleDungeonPlayerInfo.playerInfo.IsVIP)
                {
                    this._vipName = VipController.instance.getVipNameTxt(-1, this._singleDungeonPlayerInfo.playerInfo.VIPtype);
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
                if (((this._singleDungeonPlayerInfo.playerInfo.IsVIP) && (!(this._vipIcon))))
                {
                    this._vipIcon = ComponentFactory.Instance.creatCustomObject("singledungeon.sencemap.VipLvIcon");
                    if (this._singleDungeonPlayerInfo.playerInfo.VIPtype >= 2)
                    {
                        this._vipIcon.y = (this._vipIcon.y - 5);
                    };
                    this._vipIcon.setInfo(this._singleDungeonPlayerInfo.playerInfo, false);
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
                _local_2 = ((this._vipIcon) ? (this._lblName.textWidth + this._vipIcon.width) : (this._lblName.textWidth + 8));
                if (this._singleDungeonPlayerInfo.playerInfo.IsVIP)
                {
                    _local_2 = ((this._vipIcon) ? ((this._vipName.width + this._vipIcon.width) + 8) : (this._vipName.width + 8));
                    this._spName.x = (((playerWitdh - (this._vipIcon.width + this._vipName.width)) / 2) - (playerWitdh / 2));
                };
                this._spName.graphics.drawRoundRect(-4, 0, _local_2, 22, 5, 5);
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
            var _local_1:Point = ComponentFactory.Instance.creatCustomObject("singledungeon.walkMapPlayer.facePos");
            this._face = new FaceContainer(true);
            this._face.x = (((playerWitdh - this._face.width) / 2) - (playerWitdh / 2));
            this._face.y = _local_1.y;
            addChild(this._face);
            this.setEvent();
        }

        private function setEvent():void
        {
            addEventListener(SceneCharacterEvent.CHARACTER_DIRECTION_CHANGE, this.characterDirectionChange);
            this._singleDungeonPlayerInfo.addEventListener(WalkMapEvent.WALKMAP_PLAYER_POS_CHANGED, this.__onplayerPosChangeImp);
            ChatManager.Instance.model.addEventListener(ChatEvent.ADD_CHAT, this.__getChat);
            ChatManager.Instance.addEventListener(ChatEvent.SHOW_FACE, this.__getFace);
        }

        private function removeEvent():void
        {
            removeEventListener(SceneCharacterEvent.CHARACTER_DIRECTION_CHANGE, this.characterDirectionChange);
            if (this._singleDungeonPlayerInfo)
            {
                this._singleDungeonPlayerInfo.removeEventListener(WalkMapEvent.WALKMAP_PLAYER_POS_CHANGED, this.__onplayerPosChangeImp);
            };
            ChatManager.Instance.model.removeEventListener(ChatEvent.ADD_CHAT, this.__getChat);
            ChatManager.Instance.removeEventListener(ChatEvent.SHOW_FACE, this.__getFace);
        }

        private function __onplayerPosChangeImp(_arg_1:WalkMapEvent):void
        {
            playerPoint = this._singleDungeonPlayerInfo.playerPos;
        }

        private function characterDirectionChange(_arg_1:SceneCharacterEvent):void
        {
            this._singleDungeonPlayerInfo.scenePlayerDirection = sceneCharacterDirection;
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
            character.y = -(playerHeight);
        }

        private function playerWalkPath():void
        {
            if (((((!(_walkPath == null)) && (_walkPath.length > 0)) && (this._singleDungeonPlayerInfo.walkPath.length > 0)) && (!(_walkPath == this._singleDungeonPlayerInfo.walkPath))))
            {
                this.fixPlayerPath();
            };
            if (((((this._singleDungeonPlayerInfo) && (this._singleDungeonPlayerInfo.walkPath)) && (this._singleDungeonPlayerInfo.walkPath.length <= 0)) && (!(_tween.isPlaying))))
            {
                return;
            };
            this.playerWalk(this._singleDungeonPlayerInfo.walkPath);
        }

        override public function playerWalk(_arg_1:Array):void
        {
            var _local_2:Number;
            if ((((!(_walkPath == null)) && (_tween.isPlaying)) && (_walkPath == this._singleDungeonPlayerInfo.walkPath)))
            {
                return;
            };
            _walkPath = this._singleDungeonPlayerInfo.walkPath;
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
            if (this._singleDungeonPlayerInfo.currentWalkStartPoint == null)
            {
                return;
            };
            var _local_1:int = -1;
            var _local_2:int;
            while (_local_2 < _walkPath.length)
            {
                if (((_walkPath[_local_2].x == this._singleDungeonPlayerInfo.currentWalkStartPoint.x) && (_walkPath[_local_2].y == this._singleDungeonPlayerInfo.currentWalkStartPoint.y)))
                {
                    _local_1 = _local_2;
                    break;
                };
                _local_2++;
            };
            if (_local_1 > 0)
            {
                _local_3 = _walkPath.slice(0, _local_1);
                this._singleDungeonPlayerInfo.walkPath = _local_3.concat(this._singleDungeonPlayerInfo.walkPath);
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
            moveSpeed = this._singleDungeonPlayerInfo.playerMoveSpeed;
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
            if ((((_local_2) && (this._singleDungeonPlayerInfo.playerInfo)) && (_local_2.senderID == this._singleDungeonPlayerInfo.playerInfo.ID)))
            {
                this._chatBallView.setText(_local_2.msg, this._singleDungeonPlayerInfo.playerInfo.paopaoType);
                if (((!(this._chatBallView.parent)) && (character)))
                {
                    addChildAt(this._chatBallView, (this.getChildIndex(character) + 1));
                };
            };
        }

        private function __getFace(_arg_1:ChatEvent):void
        {
            var _local_2:Object = _arg_1.data;
            if (_local_2["playerid"] == this._singleDungeonPlayerInfo.playerInfo.ID)
            {
                this._face.setFace(_local_2["faceid"]);
            };
        }

        public function get singleDungeonPlayerInfo():SingleDungeonPlayerInfo
        {
            return (this._singleDungeonPlayerInfo);
        }

        public function set singleDungeonPlayerInfo(_arg_1:SingleDungeonPlayerInfo):void
        {
            this._singleDungeonPlayerInfo = _arg_1;
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
            return (this._singleDungeonPlayerInfo.playerInfo.ID);
        }

        override public function dispose():void
        {
            this.removeEvent();
            ObjectUtils.disposeObject(this._sceneScene);
            this._sceneScene = null;
            ObjectUtils.disposeObject(this._spName);
            this._spName = null;
            ObjectUtils.disposeObject(this._lblName);
            this._lblName = null;
            ObjectUtils.disposeObject(this._vipName);
            this._vipName = null;
            ObjectUtils.disposeObject(this._chatBallView);
            this._chatBallView = null;
            ObjectUtils.disposeObject(this._face);
            this._face = null;
            ObjectUtils.disposeObject(this._vipIcon);
            this._vipIcon = null;
            this._singleDungeonPlayerInfo = null;
            super.dispose();
        }


    }
}//package SingleDungeon.player

