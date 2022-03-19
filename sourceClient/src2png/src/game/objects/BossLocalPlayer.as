// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.objects.BossLocalPlayer

package game.objects
{
    import flash.utils.Timer;
    import flash.display.MovieClip;
    import flash.display.Bitmap;
    import flash.geom.Point;
    import game.model.LocalPlayer;
    import ddt.view.character.ShowCharacter;
    import ddt.view.character.GameCharacter;
    import com.pickgliss.utils.ClassUtils;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.loader.ModuleLoader;
    import ddt.events.LivingEvent;
    import flash.events.TimerEvent;
    import org.aswing.KeyboardManager;
    import org.aswing.KeyStroke;
    import flash.events.KeyboardEvent;
    import ddt.events.GameEvent;
    import flash.events.Event;
    import game.actions.PlayerFallingAction;
    import ddt.view.FaceContainer;
    import game.animations.DragMapAnimation;
    import game.animations.AnimationLevel;
    import ddt.manager.PetSkillManager;
    import pet.date.PetSkillInfo;
    import game.GameManager;
    import ddt.manager.MessageTipManager;
    import ddt.manager.LanguageMgr;
    import ddt.manager.SoundManager;
    import game.actions.SelfSkipAction;
    import game.model.Living;
    import game.model.Player;
    import game.animations.BaseSetCenterAnimation;
    import ddt.manager.GameInSocketOut;
    import game.actions.MonsterShootBombAction;
    import ddt.manager.SocketManager;
    import flash.utils.getTimer;
    import game.actions.BossPlayerWalkAction;
    import game.view.map.MapView;
    import phy.maps.Map;
    import flash.events.MouseEvent;
    import com.pickgliss.utils.ObjectUtils;

    public class BossLocalPlayer extends BossPlayer 
    {

        private static const MAX_MOVE_TIME:int = 10;

        protected var _shootTimer:Timer;
        private var _mouseAsset:MovieClip;
        private var _shootLine:Bitmap;
        private var _circle:Bitmap;
        private var _mouseDownLeft:Boolean = false;
        private var _mouseDownRight:Boolean = false;
        private var _dragMouse:Boolean = false;
        private var _showShoot:Boolean;
        public var _isShooting:Boolean = false;
        protected var _shootCount:int = 0;
        protected var _shootPoint:Point;
        private var _keyDownTime:int;
        private var _shootOverCount:int = 0;

        public function BossLocalPlayer(_arg_1:LocalPlayer, _arg_2:ShowCharacter, _arg_3:GameCharacter=null)
        {
            super(_arg_1, _arg_2, _arg_3);
            this.localPlayer.canNormalShoot = false;
        }

        override protected function initView():void
        {
            this._mouseAsset = (ClassUtils.CreatInstance("asset.game.MouseShape") as MovieClip);
            this._mouseAsset.visible = false;
            this._shootLine = ComponentFactory.Instance.creatBitmap("asset.game.bossplayer.shootline");
            this._shootLine.y = info.shootPos.y;
            this._shootLine.smoothing = true;
            this._shootLine.visible = false;
            this._circle = ComponentFactory.Instance.creatBitmap("asset.game.bossplayer.circle");
            if (info.direction == -1)
            {
                this._circle.scaleX = -1;
                this._circle.x = (info.shootPos.x + (this._circle.width / 2));
                this._shootLine.x = info.shootPos.x;
            }
            else
            {
                this._circle.x = (info.shootPos.x - (this._circle.width / 2));
                this._shootLine.x = info.shootPos.x;
            };
            this._circle.y = (info.shootPos.y - (this._circle.height / 2));
            this._circle.smoothing = true;
            this._circle.visible = false;
            initFreezonRect();
            var _local_1:Point = ComponentFactory.Instance.creatCustomObject("tian.shootSpeed2");
            this._shootTimer = new Timer(_local_1.y);
            super.initView();
            _nickName.x = (_nickName.x - 2);
            _nickName.y = (_nickName.y + 2);
            mouseEnabled = true;
            mouseChildren = true;
        }

        override protected function initMovie():void
        {
            super.initMovie();
            if (((ModuleLoader.hasDefinition(info.actionMovieName)) && ((!(info.shootPos.x == 0)) || (!(info.shootPos.y == 0)))))
            {
                addChild(this._shootLine);
                addChild(this._circle);
            };
        }

        public function get localPlayer():LocalPlayer
        {
            return (info as LocalPlayer);
        }

        override protected function initListener():void
        {
            super.initListener();
            this.localPlayer.addEventListener(LivingEvent.SEND_SHOOT_ACTION, this.__sendShoot);
            this.localPlayer.addEventListener(LivingEvent.USE_SKILL_DIRECTLY, this.__useSkillDirectly);
            this.localPlayer.addEventListener(LivingEvent.SKIP, this.__skip);
            this.localPlayer.addEventListener(LivingEvent.ANGLE_CHANGED, this.__changeAngle);
            this.localPlayer.addEventListener(LivingEvent.SETCENTER, this.__setCenter);
            this._shootTimer.addEventListener(TimerEvent.TIMER, this.__shootTimer);
            KeyboardManager.getInstance().registerKeyAction(KeyStroke.VK_LEFT, this.__turnLeft);
            KeyboardManager.getInstance().registerKeyAction(KeyStroke.VK_A, this.__turnLeft);
            KeyboardManager.getInstance().registerKeyAction(KeyStroke.VK_RIGHT, this.__turnRight);
            KeyboardManager.getInstance().registerKeyAction(KeyStroke.VK_D, this.__turnRight);
            KeyboardManager.getInstance().addEventListener(KeyboardEvent.KEY_UP, this.__keyUp);
            this.initMouseStateEvent();
        }

        private function initMouseStateEvent():void
        {
            this.localPlayer.addEventListener(GameEvent.MOUSE_MODEL_CHANGE_ANGLE, this.__changeAngleMouseState);
            this.localPlayer.addEventListener(GameEvent.MOUSE_UP_LEFT, this.__resetMouse);
            this.localPlayer.addEventListener(GameEvent.MOUSE_DOWN_LEFT, this.__mouseDownLeft);
            this.localPlayer.addEventListener(GameEvent.MOUSE_UP_Right, this.__resetMouse);
            this.localPlayer.addEventListener(GameEvent.MOUSE_DOWN_Right, this.__mouseDownRight);
            this.localPlayer.addEventListener(GameEvent.MOUSE_MODEL_STATE, this.__mouseModelStateChange);
            addEventListener(Event.ENTER_FRAME, this.__mouseStateEnterFrame);
        }

        override protected function __fall(_arg_1:LivingEvent):void
        {
            act(new PlayerFallingAction(this, _arg_1.paras[0], true, false));
        }

        public function get facecontainer():FaceContainer
        {
            return (_facecontainer);
        }

        public function set facecontainer(_arg_1:FaceContainer):void
        {
            _facecontainer = _arg_1;
        }

        private function __setCenter(_arg_1:LivingEvent):void
        {
            var _local_2:Array = _arg_1.paras;
            map.animateSet.addAnimation(new DragMapAnimation(_local_2[0], _local_2[1], true, 100, AnimationLevel.MIDDLE, _info.LivingID));
        }

        override protected function __usePetSkill(_arg_1:LivingEvent):void
        {
            var _local_2:PetSkillInfo = PetSkillManager.instance.getSkillByID(_arg_1.value);
            if (_local_2 == null)
            {
                throw (new Error(("找不到技能，技能ID为：" + _arg_1.value)));
            };
            if (_local_2.isActiveSkill)
            {
                switch (_local_2.BallType)
                {
                    case PetSkillInfo.BALL_TYPE_0:
                        usePetSkill(_local_2);
                        break;
                    case PetSkillInfo.BALL_TYPE_1:
                        _shootAction = _local_2.Action;
                        GameManager.Instance.Current.selfGamePlayer.soulPropEnabled = false;
                        this.localPlayer.canNormalShoot = true;
                        dispatchEvent(new GameEvent(GameEvent.BOSS_USE_SKILL));
                        this._circle.visible = (((this.localPlayer.isAttacking) && (this.localPlayer.isLiving)) && (!(this.localPlayer.mouseState)));
                        this._shootLine.visible = (((this.localPlayer.isAttacking) && (this.localPlayer.isLiving)) && (!(this.localPlayer.mouseState)));
                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("singledungeon.bossplayer.spacetip"));
                        break;
                    case PetSkillInfo.BALL_TYPE_2:
                        if (GameManager.Instance.Current.selfGamePlayer.team == info.team)
                        {
                            GameManager.Instance.Current.selfGamePlayer.soulPropEnabled = false;
                        };
                        usePetSkill(_local_2, this.skipSelfTurn);
                        break;
                    case PetSkillInfo.BALL_TYPE_3:
                        usePetSkill(_local_2);
                        break;
                };
                UsedPetSkill.add(_local_2.ID, _local_2);
                SoundManager.instance.play("039");
            };
        }

        private function skipSelfTurn():void
        {
            if ((info is LocalPlayer))
            {
                act(new SelfSkipAction(LocalPlayer(info)));
            };
        }

        public function hidePetMovie():void
        {
        }

        override protected function updateHp(_arg_1:Array):void
        {
            var _local_2:Object;
            var _local_3:Living;
            var _local_4:int;
            var _local_5:int;
            var _local_6:int;
            this._isShooting = false;
            for each (_local_2 in _arg_1)
            {
                _local_3 = _local_2.target;
                _local_4 = _local_2.hp;
                _local_5 = _local_2.damage;
                _local_6 = _local_2.dander;
                _local_3.updateBlood(_local_4, 3, _local_5);
                if ((_local_3 is Player))
                {
                    Player(_local_3).dander = _local_6;
                };
            };
        }

        protected function __sendShoot(_arg_1:LivingEvent):void
        {
            this._shootPoint = this.shootPoint();
            this.shootOverCount = (this._shootCount = 0);
            this.localPlayer.isAttacking = false;
            this._isShooting = true;
            map.animateSet.addAnimation(new BaseSetCenterAnimation(x, (y - 150), 1, false, AnimationLevel.HIGHT, _info.LivingID));
            GameInSocketOut.sendGameCMDDirection(info.direction);
            GameInSocketOut.sendGameStartMove(0, this.x, this.y, this.info.direction, this.isLiving, GameManager.Instance.Current.currentTurn);
            GameInSocketOut.sendShootTag(true, this.localPlayer.shootTime);
            if (this.localPlayer.shootType == 0)
            {
                this.localPlayer.force = _arg_1.paras[0];
                this._shootTimer.start();
                this.__shootTimer(null);
            }
            else
            {
                act(new MonsterShootBombAction(this, _arg_1.paras[0], _arg_1.paras[1], Player.SHOOT_INTERVAL));
            };
        }

        protected function __useSkillDirectly(_arg_1:LivingEvent):void
        {
            this.localPlayer.isAttacking = false;
            this._isShooting = true;
            SocketManager.Instance.out.sendPetSkill(_arg_1.paras[0], _arg_1.paras[1]);
        }

        protected function __skip(_arg_1:LivingEvent):void
        {
            act(new SelfSkipAction(this.localPlayer));
        }

        public function shootPoint():Point
        {
            var _local_1:Point = ComponentFactory.Instance.creatCustomObject("bossplayer.ballPoint");
            _local_1 = this.actionMovie.localToGlobal(_local_1);
            return (_map.globalToLocal(_local_1));
        }

        private function __keyUp(_arg_1:KeyboardEvent):void
        {
            this._keyDownTime = 0;
        }

        private function __turnLeft():void
        {
            if ((!(this._isShooting)))
            {
                if (info.direction == 1)
                {
                    info.direction = -1;
                    this._circle.scaleX = -1;
                    this._circle.x = (info.shootPos.x + (this._circle.width / 2));
                    this._shootLine.x = info.shootPos.x;
                    if (this._keyDownTime == 0)
                    {
                        this._keyDownTime = getTimer();
                    };
                };
                dispatchEvent(new GameEvent(GameEvent.TURN_LEFT));
                this.walk();
            };
        }

        private function __turnRight():void
        {
            if ((!(this._isShooting)))
            {
                if (info.direction == -1)
                {
                    info.direction = 1;
                    this._circle.scaleX = 1;
                    this._circle.x = (info.shootPos.x - (this._circle.width / 2));
                    this._shootLine.x = info.shootPos.x;
                    if (this._keyDownTime == 0)
                    {
                        this._keyDownTime = getTimer();
                    };
                };
                dispatchEvent(new GameEvent(GameEvent.TURN_RIGHT));
                this.walk();
            };
        }

        protected function __changeAngle(_arg_1:LivingEvent):void
        {
            var _local_2:Number = info.playerAngle;
            this._shootLine.rotation = (this.localPlayer.arrowRotation + _local_2);
        }

        protected function walk():void
        {
            if (((((!(_isMoving)) && (this.localPlayer.isAttacking)) && ((((this._keyDownTime == 0) || ((getTimer() - this._keyDownTime) > MAX_MOVE_TIME)) || (this._mouseDownLeft)) || (this._mouseDownRight))) && (!(this.localPlayer.forbidMoving))))
            {
                act(new BossPlayerWalkAction(this));
            };
        }

        override public function startMoving():void
        {
            _isMoving = true;
            GameManager.Instance.dispatchEvent(new LivingEvent(LivingEvent.START_MOVING));
        }

        override public function update(_arg_1:Number):void
        {
            super.update(_arg_1);
        }

        override public function stopMoving():void
        {
            _vx.clearMotion();
            _vy.clearMotion();
            _isMoving = false;
        }

        private function __shootTimer(_arg_1:Event):void
        {
            var _local_2:Number;
            var _local_3:int;
            if ((((this.localPlayer) && (this.localPlayer.isLiving)) && (this._shootCount < this.localPlayer.shootCount)))
            {
                _local_2 = this.localPlayer.calcBombAngle();
                _local_3 = this.localPlayer.force;
                this._shootCount++;
                GameInSocketOut.sendGameCMDShoot(this._shootPoint.x, this._shootPoint.y, _local_3, _local_2, 0, (this._shootCount >= this.localPlayer.shootCount));
                MapView(_map).gameView.setRecordRotation();
            };
        }

        public function get shootOverCount():int
        {
            return (this._shootOverCount);
        }

        public function set shootOverCount(_arg_1:int):void
        {
            this._shootOverCount = _arg_1;
            if (this._shootOverCount == this._shootCount)
            {
                this._isShooting = false;
            };
        }

        override public function setMap(_arg_1:Map):void
        {
            super.setMap(_arg_1);
            if (_arg_1)
            {
                this.__posChanged(null);
            };
        }

        private function beatCallBack():void
        {
        }

        override protected function __attackingChanged(_arg_1:LivingEvent):void
        {
            this.localPlayer.soulPropEnabled = (this.localPlayer.flyEnabled = (this.localPlayer.rightPropEnabled = (this.localPlayer.spellKillEnabled = false)));
            this.localPlayer.canNormalShoot = false;
            this._circle.visible = false;
            this._shootLine.visible = false;
            super.__attackingChanged(_arg_1);
        }

        override protected function __beginNewTurn(_arg_1:LivingEvent):void
        {
            super.__beginNewTurn(_arg_1);
            this.shootOverCount = (this._shootCount = 0);
            this._shootTimer.reset();
            this._isShooting = false;
        }

        override protected function __posChanged(_arg_1:LivingEvent):void
        {
            super.__posChanged(_arg_1);
        }

        override protected function __changeState(_arg_1:LivingEvent):void
        {
            if (_info.State == 1)
            {
                doAction(Living.ANGRY_ACTION);
            }
            else
            {
                doAction(Living.STAND_ACTION);
            };
        }

        override public function die():void
        {
            super.die();
            map.addEventListener(MouseEvent.CLICK, this.__mouseClick);
        }

        private function __mouseClick(_arg_1:MouseEvent):void
        {
            var _local_2:Point;
            _local_2 = _map.globalToLocal(new Point(_arg_1.stageX, _arg_1.stageY));
            _map.addChild(this._mouseAsset);
            SoundManager.instance.play("041");
            this._mouseAsset.x = _local_2.x;
            this._mouseAsset.y = _local_2.y;
            this._mouseAsset.visible = true;
            GameInSocketOut.sendGhostTarget(_local_2);
        }

        public function hideTargetMouseTip():void
        {
            this._mouseAsset.visible = false;
        }

        override public function dispose():void
        {
            _map.removeEventListener(MouseEvent.CLICK, this.__mouseClick);
            this._mouseAsset.stop();
            if (this._mouseAsset.parent)
            {
                this._mouseAsset.parent.removeChild(this._mouseAsset);
            };
            this._mouseAsset = null;
            ObjectUtils.disposeObject(this._shootLine);
            this._shootLine = null;
            ObjectUtils.disposeObject(this._circle);
            this._circle = null;
            this._shootTimer.removeEventListener(TimerEvent.TIMER, this.__shootTimer);
            this._shootTimer = null;
            if (this.localPlayer)
            {
                this.localPlayer.removeEventListener(LivingEvent.SEND_SHOOT_ACTION, this.__sendShoot);
                this.localPlayer.removeEventListener(LivingEvent.USE_SKILL_DIRECTLY, this.__useSkillDirectly);
                this.localPlayer.removeEventListener(LivingEvent.SKIP, this.__skip);
                this.localPlayer.removeEventListener(LivingEvent.ANGLE_CHANGED, this.__changeAngle);
                this.localPlayer.removeEventListener(LivingEvent.SETCENTER, this.__setCenter);
            };
            KeyboardManager.getInstance().unregisterKeyAction(KeyStroke.VK_LEFT, this.__turnLeft);
            KeyboardManager.getInstance().unregisterKeyAction(KeyStroke.VK_A, this.__turnLeft);
            KeyboardManager.getInstance().unregisterKeyAction(KeyStroke.VK_RIGHT, this.__turnRight);
            KeyboardManager.getInstance().unregisterKeyAction(KeyStroke.VK_D, this.__turnRight);
            KeyboardManager.getInstance().removeEventListener(KeyboardEvent.KEY_UP, this.__keyUp);
            if (((_chatballview.visible) && (_chatballview.parent)))
            {
                _chatballview.addEventListener(Event.COMPLETE, this.__disposeLater);
                return;
            };
            if (((map) && (map.currentPlayer == _info)))
            {
                map.currentPlayer = null;
            };
            this.removeMouseStateEvent();
            super.dispose();
        }

        private function removeMouseStateEvent():void
        {
            this.localPlayer.removeEventListener(GameEvent.MOUSE_MODEL_CHANGE_ANGLE, this.__changeAngleMouseState);
            this.localPlayer.removeEventListener(GameEvent.MOUSE_UP_LEFT, this.__resetMouse);
            this.localPlayer.removeEventListener(GameEvent.MOUSE_DOWN_LEFT, this.__mouseDownLeft);
            this.localPlayer.removeEventListener(GameEvent.MOUSE_UP_Right, this.__resetMouse);
            this.localPlayer.removeEventListener(GameEvent.MOUSE_DOWN_Right, this.__mouseDownRight);
            this.localPlayer.removeEventListener(GameEvent.MOUSE_MODEL_STATE, this.__mouseModelStateChange);
            removeEventListener(Event.ENTER_FRAME, this.__mouseStateEnterFrame);
        }

        private function __disposeLater(_arg_1:Event):void
        {
            _chatballview.removeEventListener(Event.COMPLETE, this.__disposeLater);
            this.dispose();
        }

        public function get mouseDown():Boolean
        {
            return ((this._mouseDownLeft) || (this._mouseDownRight));
        }

        private function __changeAngleMouseState(_arg_1:GameEvent):void
        {
            var _local_2:Number = info.playerAngle;
            if (info.direction == 1)
            {
                this._shootLine.rotation = (this.localPlayer.arrowRotation + _local_2);
            }
            else
            {
                if (info.direction == -1)
                {
                    this._shootLine.rotation = (this.localPlayer.arrowRotation + _local_2);
                };
            };
        }

        private function __mouseModelStateChange(_arg_1:GameEvent):void
        {
            if (((this.localPlayer.isLiving) && (this.localPlayer.isAttacking)))
            {
                this._shootLine.visible = ((this.localPlayer.canNormalShoot) && (!(this.localPlayer.mouseState)));
                this._circle.visible = ((this.localPlayer.canNormalShoot) && (!(this.localPlayer.mouseState)));
            };
        }

        private function __mouseDownLeft(_arg_1:GameEvent):void
        {
            if (((this.localPlayer.isLiving) && (!(this.localPlayer.isAttacking))))
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.game.ArrowViewIII.fall"));
                return;
            };
            this._mouseDownLeft = true;
        }

        private function __mouseDownRight(_arg_1:GameEvent):void
        {
            if (((this.localPlayer.isLiving) && (!(this.localPlayer.isAttacking))))
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.game.ArrowViewIII.fall"));
                return;
            };
            this._mouseDownRight = true;
        }

        private function __resetMouse(_arg_1:GameEvent):void
        {
            this._mouseDownLeft = false;
            this._mouseDownRight = false;
            this._keyDownTime = 0;
        }

        private function __mouseStateEnterFrame(_arg_1:Event):void
        {
            if (this._mouseDownLeft)
            {
                this.__turnLeft();
            };
            if (this._mouseDownRight)
            {
                this.__turnRight();
            };
        }


    }
}//package game.objects

