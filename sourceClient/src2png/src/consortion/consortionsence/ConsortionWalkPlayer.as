// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//consortion.consortionsence.ConsortionWalkPlayer

package consortion.consortionsence
{
    import ddt.view.scenePathSearcher.SceneScene;
    import ddt.view.chat.chatBall.ChatBallPlayer;
    import flash.display.Sprite;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.text.GradientText;
    import ddt.view.common.VipLevelIcon;
    import flash.display.MovieClip;
    import flash.geom.Point;
    import com.pickgliss.utils.ClassUtils;
    import com.pickgliss.ui.ComponentFactory;
    import vip.VipController;
    import com.pickgliss.utils.DisplayUtils;
    import ddt.view.sceneCharacter.SceneCharacterEvent;
    import SingleDungeon.event.WalkMapEvent;
    import ddt.manager.ChatManager;
    import ddt.view.chat.ChatEvent;
    import ddt.view.sceneCharacter.SceneCharacterDirection;
    import ddt.view.chat.ChatData;
    import ddt.utils.Helpers;
    import ddt.view.chat.ChatInputView;
    import com.pickgliss.utils.ObjectUtils;

    public class ConsortionWalkPlayer extends ConsortionWalkPlayerBase 
    {

        private var _consortionPlayerInfo:ConsortionWalkPlayerInfo;
        private var _sceneScene:SceneScene;
        private var _isChatBall:Boolean = true;
        private var _chatBallView:ChatBallPlayer;
        private var _spName:Sprite;
        private var _lblName:FilterFrameText;
        private var _vipName:GradientText;
        private var _vipIcon:VipLevelIcon;
        public var defaultBody:MovieClip;
        private var _currentWalkStartPoint:Point;

        public function ConsortionWalkPlayer(_arg_1:ConsortionWalkPlayerInfo, _arg_2:Function=null)
        {
            this._consortionPlayerInfo = _arg_1;
            this._currentWalkStartPoint = this._consortionPlayerInfo.playerPos;
            super(_arg_1.playerInfo, _arg_2);
            this.mouseChildren = false;
            this.mouseEnabled = false;
            this.defaultBody = (ClassUtils.CreatInstance("asset.consortion.bodyDefaultPlayer") as MovieClip);
            this.defaultBody.x = _arg_1.playerPos.x;
            this.defaultBody.y = (_arg_1.playerPos.y - 70);
            this.initialize();
        }

        private function initialize():void
        {
            moveSpeed = this._consortionPlayerInfo.playerMoveSpeed;
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
            if ((!(this._lblName)))
            {
                this._lblName = ComponentFactory.Instance.creat("conostion.sencemap.playerNameTxt");
            };
            this._lblName.mouseEnabled = false;
            this._lblName.text = ((((this._consortionPlayerInfo) && (this._consortionPlayerInfo.playerInfo)) && (this._consortionPlayerInfo.playerInfo.NickName)) ? this._consortionPlayerInfo.playerInfo.NickName : "");
            this._lblName.textColor = 6029065;
            if ((!(this._spName)))
            {
                this._spName = new Sprite();
            };
            if (this._consortionPlayerInfo.playerInfo.IsVIP)
            {
                this._vipName = VipController.instance.getVipNameTxt(-1, this._consortionPlayerInfo.playerInfo.VIPtype);
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
            if (((this._consortionPlayerInfo.playerInfo.IsVIP) && (!(this._vipIcon))))
            {
                this._vipIcon = ComponentFactory.Instance.creatCustomObject("consortion.sencemap.VipLvIcon");
                if (this._consortionPlayerInfo.playerInfo.VIPtype >= 2)
                {
                    this._vipIcon.y = (this._vipIcon.y - 5);
                };
                this._vipIcon.setInfo(this._consortionPlayerInfo.playerInfo, false);
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
            var _local_1:int = ((this._vipIcon) ? (this._lblName.textWidth + this._vipIcon.width) : (this._lblName.textWidth + 8));
            if (this._consortionPlayerInfo.playerInfo.IsVIP)
            {
                _local_1 = ((this._vipIcon) ? ((this._vipName.width + this._vipIcon.width) + 8) : (this._vipName.width + 8));
                this._spName.x = (((playerWitdh - (this._vipIcon.width + this._vipName.width)) / 2) - (playerWitdh / 2));
            };
            this._spName.graphics.drawRoundRect(-4, 0, _local_1, 22, 5, 5);
            this._spName.graphics.endFill();
            addChildAt(this._spName, 0);
            this.initEvent();
        }

        private function initEvent():void
        {
            addEventListener(SceneCharacterEvent.CHARACTER_DIRECTION_CHANGE, this.__characterDirectionChange);
            this._consortionPlayerInfo.addEventListener(WalkMapEvent.WALKMAP_PLAYER_POS_CHANGED, this.__onPlayerPosChange);
            ChatManager.Instance.model.addEventListener(ChatEvent.ADD_CHAT, this.__getChat);
        }

        private function removeEvent():void
        {
            removeEventListener(SceneCharacterEvent.CHARACTER_DIRECTION_CHANGE, this.__characterDirectionChange);
            if (this._consortionPlayerInfo)
            {
                this._consortionPlayerInfo.removeEventListener(WalkMapEvent.WALKMAP_PLAYER_POS_CHANGED, this.__onPlayerPosChange);
            };
            ChatManager.Instance.model.removeEventListener(ChatEvent.ADD_CHAT, this.__getChat);
        }

        private function __onPlayerPosChange(_arg_1:WalkMapEvent):void
        {
            playerPoint = this._consortionPlayerInfo.playerPos;
        }

        private function __characterDirectionChange(_arg_1:SceneCharacterEvent):void
        {
            this._consortionPlayerInfo.scenePlayerDirection = sceneCharacterDirection;
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
            if (((((!(_walkPath == null)) && (_walkPath.length > 0)) && (this._consortionPlayerInfo.walkPath.length > 0)) && (!(_walkPath == this._consortionPlayerInfo.walkPath))))
            {
                this.fixPlayerPath();
            };
            if (((((this._consortionPlayerInfo) && (this._consortionPlayerInfo.walkPath)) && (this._consortionPlayerInfo.walkPath.length <= 0)) && (!(_tween.isPlaying))))
            {
                return;
            };
            this.playerWalk(this._consortionPlayerInfo.walkPath);
        }

        override public function playerWalk(_arg_1:Array):void
        {
            var _local_2:Number;
            if ((((!(_walkPath == null)) && (_tween.isPlaying)) && (_walkPath == this._consortionPlayerInfo.walkPath)))
            {
                return;
            };
            _walkPath = this._consortionPlayerInfo.walkPath;
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
            if (this._consortionPlayerInfo.currenWalkStartPoint == null)
            {
                return;
            };
            var _local_1:int = -1;
            var _local_2:int;
            while (_local_2 < _walkPath.length)
            {
                if (((_walkPath[_local_2].x == this._consortionPlayerInfo.currenWalkStartPoint.x) && (_walkPath[_local_2].y == this._consortionPlayerInfo.currenWalkStartPoint.y)))
                {
                    _local_1 = _local_2;
                    break;
                };
                _local_2++;
            };
            if (_local_1 > 0)
            {
                _local_3 = _walkPath.slice(0, _local_1);
                this._consortionPlayerInfo.walkPath = _local_3.concat(this._consortionPlayerInfo.walkPath);
            };
        }

        public function get currentWalkStartPoint():Point
        {
            return (this._currentWalkStartPoint);
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
            moveSpeed = this._consortionPlayerInfo.playerMoveSpeed;
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
            if (_local_2.channel == ChatInputView.PRIVATE)
            {
                return;
            };
            if ((((_local_2) && (this._consortionPlayerInfo.playerInfo)) && (_local_2.senderID == this._consortionPlayerInfo.playerInfo.ID)))
            {
                this._chatBallView.setText(_local_2.msg, this._consortionPlayerInfo.playerInfo.paopaoType);
                if (((!(this._chatBallView.parent)) && (character)))
                {
                    addChildAt(this._chatBallView, (this.getChildIndex(character) + 1));
                };
            };
        }

        public function get consortionPlayerInfo():ConsortionWalkPlayerInfo
        {
            return (this._consortionPlayerInfo);
        }

        public function set consortionPlayerInfo(_arg_1:ConsortionWalkPlayerInfo):void
        {
            this._consortionPlayerInfo = _arg_1;
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
            return (this._consortionPlayerInfo.playerInfo.ID);
        }

        override public function dispose():void
        {
            this.removeEvent();
            ObjectUtils.disposeObject(this._sceneScene);
            this._sceneScene = null;
            ObjectUtils.disposeObject(this._chatBallView);
            this._chatBallView = null;
            ObjectUtils.disposeObject(this._lblName);
            this._lblName = null;
            ObjectUtils.disposeObject(this._vipName);
            this._vipName = null;
            ObjectUtils.disposeObject(this._vipIcon);
            this._vipIcon = null;
            ObjectUtils.disposeObject(this._spName);
            this._spName = null;
            ObjectUtils.disposeObject(this.defaultBody);
            this.defaultBody = null;
            this._consortionPlayerInfo = null;
            super.dispose();
        }


    }
}//package consortion.consortionsence

