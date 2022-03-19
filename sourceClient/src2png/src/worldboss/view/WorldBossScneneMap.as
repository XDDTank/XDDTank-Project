// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//worldboss.view.WorldBossScneneMap

package worldboss.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import ddt.view.scenePathSearcher.SceneScene;
    import road7th.data.DictionaryData;
    import worldboss.player.WorldRoomPlayer;
    import flash.display.MovieClip;
    import church.vo.SceneMapVO;
    import worldboss.model.WorldBossRoomModel;
    import flash.geom.Point;
    import flash.events.MouseEvent;
    import worldboss.WorldBossManager;
    import flash.utils.getTimer;
    import ddt.manager.SoundManager;
    import ddt.view.sceneCharacter.SceneCharacterEvent;
    import ddt.view.sceneCharacter.SceneCharacterDirection;
    import ddt.manager.PlayerManager;
    import ddt.manager.MessageTipManager;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.AlertManager;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import com.pickgliss.events.FrameEvent;
    import ddt.manager.SocketManager;
    import flash.events.Event;
    import com.pickgliss.utils.ClassUtils;
    import worldboss.event.WorldBossRoomEvent;
    import road7th.data.DictionaryEvent;
    import flash.utils.setTimeout;
    import church.view.churchScene.MoonSceneMap;
    import worldboss.player.PlayerVO;
    import flash.display.DisplayObject;

    public class WorldBossScneneMap extends Sprite implements Disposeable 
    {

        public static const SCENE_ALLOW_FIRES:int = 6;

        private const CLICK_INTERVAL:Number = 200;

        protected var articleLayer:Sprite;
        protected var meshLayer:Sprite;
        protected var bgLayer:Sprite;
        protected var skyLayer:Sprite;
        public var sceneScene:SceneScene;
        protected var _data:DictionaryData;
        protected var _characters:DictionaryData;
        public var selfPlayer:WorldRoomPlayer;
        private var last_click:Number;
        private var current_display_fire:int = 0;
        private var _mouseMovie:MovieClip;
        private var _currentLoadingPlayer:WorldRoomPlayer;
        private var _isShowName:Boolean = true;
        private var _isChatBall:Boolean = true;
        private var _clickInterval:Number = 200;
        private var _lastClick:Number = 0;
        private var _sceneMapVO:SceneMapVO;
        private var _model:WorldBossRoomModel;
        private var _worldboss:MovieClip;
        private var _worldboss_mc:MovieClip;
        private var _worldboss_sky:MovieClip;
        private var armyPos:Point;
        private var decorationLayer:Sprite;
        private var r:int = 250;
        private var auto:Point;
        private var autoMove:Boolean = false;
        private var clickAgain:Boolean = false;
        private var _entering:Boolean = false;
        private var _frame_name:String = "stand";
        protected var reference:WorldRoomPlayer;

        public function WorldBossScneneMap(_arg_1:WorldBossRoomModel, _arg_2:SceneScene, _arg_3:DictionaryData, _arg_4:Sprite, _arg_5:Sprite, _arg_6:Sprite=null, _arg_7:Sprite=null, _arg_8:Sprite=null)
        {
            this._model = _arg_1;
            this.sceneScene = _arg_2;
            this._data = _arg_3;
            if (_arg_4 == null)
            {
                this.bgLayer = new Sprite();
            }
            else
            {
                this.bgLayer = _arg_4;
            };
            this.meshLayer = ((_arg_5 == null) ? new Sprite() : _arg_5);
            this.meshLayer.alpha = 0;
            this.articleLayer = ((_arg_6 == null) ? new Sprite() : _arg_6);
            this.decorationLayer = ((_arg_8 == null) ? new Sprite() : _arg_8);
            this.skyLayer = ((_arg_7 == null) ? new Sprite() : _arg_7);
            this.decorationLayer.mouseChildren = (this.decorationLayer.mouseEnabled = false);
            this.addChild(this.bgLayer);
            this.addChild(this.articleLayer);
            this.addChild(this.decorationLayer);
            this.addChild(this.meshLayer);
            this.addChild(this.skyLayer);
            this.init();
            this.addEvent();
            this.initBoss();
        }

        private function initBoss():void
        {
            if (((!(this.bgLayer == null)) && (!(this.articleLayer == null))))
            {
                this._worldboss = (this.skyLayer.getChildByName("worldboss_mc") as MovieClip);
                this._worldboss.addEventListener(MouseEvent.CLICK, this._enterWorldBossGame);
                this._worldboss.buttonMode = true;
                this._worldboss_mc = (this.bgLayer.getChildByName("worldboss") as MovieClip);
                this._worldboss_sky = (this.bgLayer.getChildByName("worldboss_sky") as MovieClip);
                this.armyPos = new Point(this.bgLayer.getChildByName("armyPos").x, this.bgLayer.getChildByName("armyPos").y);
            };
            if (WorldBossManager.Instance.bossInfo.fightOver)
            {
                this._worldboss.parent.removeChild(this._worldboss);
                this._worldboss_mc.parent.removeChild(this._worldboss_mc);
                this._worldboss_sky.visible = false;
                this.removePrompt();
            };
        }

        private function _enterWorldBossGame(_arg_1:MouseEvent):void
        {
            _arg_1.stopImmediatePropagation();
            if (((((this.autoMove) || (!(this.selfPlayer.playerVO.playerStauts == 1))) || (!(this.selfPlayer.getCanAction()))) || (this._entering)))
            {
                return;
            };
            if (((this.checkCanStartGame()) && ((getTimer() - this._lastClick) > this._clickInterval)))
            {
                SoundManager.instance.play("008");
                this._mouseMovie.gotoAndStop(1);
                this._lastClick = getTimer();
                if (this.checkDistance())
                {
                    WorldBossManager.Instance.buyBuff();
                    this.CreateStartGame();
                }
                else
                {
                    if (((this.auto) && (!(this.sceneScene.hit(this.auto)))))
                    {
                        this.autoMove = true;
                        this.selfPlayer.addEventListener(SceneCharacterEvent.CHARACTER_ARRIVED_NEXT_STEP, this.__arrive);
                        this.selfPlayer.playerVO.walkPath = this.sceneScene.searchPath(this.selfPlayer.playerPoint, this.auto);
                        this.selfPlayer.playerVO.walkPath.shift();
                        this.selfPlayer.playerVO.scenePlayerDirection = SceneCharacterDirection.getDirection(this.selfPlayer.playerPoint, this.selfPlayer.playerVO.walkPath[0]);
                        this.selfPlayer.playerVO.currentWalkStartPoint = this.selfPlayer.currentWalkStartPoint;
                        this.sendMyPosition(this.selfPlayer.playerVO.walkPath.concat());
                    };
                };
            };
        }

        private function checkDistance():Boolean
        {
            var _local_3:Number;
            var _local_1:Number = (this.selfPlayer.x - this.armyPos.x);
            var _local_2:Number = (this.selfPlayer.y - this.armyPos.y);
            if ((Math.pow(_local_1, 2) + Math.pow(_local_2, 2)) > Math.pow(this.r, 2))
            {
                _local_3 = Math.atan2(_local_2, _local_1);
                this.auto = new Point(this.armyPos.x, this.armyPos.y);
                this.auto.x = (this.auto.x + (((_local_1 > 0) ? 1 : -1) * Math.abs((Math.cos(_local_3) * this.r))));
                this.auto.y = (this.auto.y + (((_local_2 > 0) ? 1 : -1) * Math.abs((Math.sin(_local_3) * this.r))));
                return (false);
            };
            return (true);
        }

        private function checkCanStartGame():Boolean
        {
            var _local_1:Boolean = true;
            if (PlayerManager.Instance.Self.Bag.getItemAt(14) == null)
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.room.RoomIIController.weapon"));
                _local_1 = false;
            };
            return (_local_1);
        }

        public function set enterIng(_arg_1:Boolean):void
        {
            this._entering = _arg_1;
        }

        public function removePrompt():void
        {
            if (this.bgLayer.getChildByName("prompt"))
            {
                this.bgLayer.removeChild(this.bgLayer.getChildByName("prompt"));
            };
        }

        private function CreateStartGame():void
        {
            if (this._entering)
            {
                return;
            };
            this.selfPlayer.removeEventListener(SceneCharacterEvent.CHARACTER_ARRIVED_NEXT_STEP, this.__arrive);
            if (WorldBossManager.Instance.bossInfo.need_ticket_count == 0)
            {
                this._entering = true;
                this.startGame();
                return;
            };
            var _local_1:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("worldboss.tickets.propInfo", WorldBossManager.Instance.bossInfo.need_ticket_count), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), false, false, false, LayerManager.ALPHA_BLOCKGOUND);
            _local_1.addEventListener(FrameEvent.RESPONSE, this.__onAlertResponse);
        }

        private function __onAlertResponse(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            var _local_2:BaseAlerFrame = (_arg_1.currentTarget as BaseAlerFrame);
            _local_2.removeEventListener(FrameEvent.RESPONSE, this.__onAlertResponse);
            switch (_arg_1.responseCode)
            {
                case FrameEvent.SUBMIT_CLICK:
                    if (PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(WorldBossManager.Instance.bossInfo.ticketID) > 0)
                    {
                        this.startGame();
                    }
                    else
                    {
                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("worldboss.tickets.none"), 0, true);
                        this.autoMove = false;
                    };
                    _local_2.dispose();
                    return;
                case FrameEvent.CANCEL_CLICK:
                case FrameEvent.CLOSE_CLICK:
                    _local_2.dispose();
                    this.autoMove = false;
                    return;
            };
        }

        private function startGame():void
        {
            if ((!(WorldBossManager.Instance.isLoadingState)))
            {
                SocketManager.Instance.out.createUserGuide(14);
            };
        }

        protected function __startFight(_arg_1:Event):void
        {
            this.CreateStartGame();
        }

        private function __stopFight(_arg_1:Event):void
        {
            this.enterIng = false;
        }

        private function __arrive(_arg_1:SceneCharacterEvent):void
        {
            if (this.autoMove)
            {
                WorldBossManager.Instance.buyBuff();
                this.CreateStartGame();
            };
        }

        public function gameOver():void
        {
            if (this._frame_name == "stand")
            {
                this._worldboss.mouseEnabled = false;
                this._worldboss.removeEventListener(MouseEvent.CLICK, this._enterWorldBossGame);
                if ((!(WorldBossManager.Instance.bossInfo.isLiving)))
                {
                    this._worldboss_mc.gotoAndPlay("out");
                }
                else
                {
                    this._worldboss_mc.gotoAndPlay("outB");
                };
                this._worldboss_sky.visible = false;
            };
            this.removePrompt();
        }

        public function get sceneMapVO():SceneMapVO
        {
            return (this._sceneMapVO);
        }

        public function set sceneMapVO(_arg_1:SceneMapVO):void
        {
            this._sceneMapVO = _arg_1;
        }

        protected function init():void
        {
            this._characters = new DictionaryData(true);
            var _local_1:Class = (ClassUtils.uiSourceDomain.getDefinition("asset.worldboss.room.MouseClickMovie") as Class);
            this._mouseMovie = (new (_local_1)() as MovieClip);
            this._mouseMovie.mouseChildren = false;
            this._mouseMovie.mouseEnabled = false;
            this._mouseMovie.stop();
            this.bgLayer.addChild(this._mouseMovie);
            this.last_click = 0;
        }

        protected function addEvent():void
        {
            this._model.addEventListener(WorldBossRoomEvent.PLAYER_NAME_VISIBLE, this.menuChange);
            this._model.addEventListener(WorldBossRoomEvent.PLAYER_CHATBALL_VISIBLE, this.menuChange);
            addEventListener(MouseEvent.CLICK, this.__click);
            addEventListener(Event.ENTER_FRAME, this.updateMap);
            this._data.addEventListener(DictionaryEvent.ADD, this.__addPlayer);
            this._data.addEventListener(DictionaryEvent.REMOVE, this.__removePlayer);
            WorldBossManager.Instance.addEventListener(WorldBossRoomEvent.WORLDBOSS_ROOM_FULL, this.__onRoomFull);
            WorldBossManager.Instance.addEventListener(WorldBossRoomEvent.STOPFIGHT, this.__stopFight);
            WorldBossManager.Instance.addEventListener(WorldBossRoomEvent.STARTFIGHT, this.__startFight);
        }

        private function __onRoomFull(_arg_1:WorldBossRoomEvent):void
        {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("worldboss.room.roomFull"), 0, true);
            this._entering = false;
        }

        private function menuChange(_arg_1:WorldBossRoomEvent):void
        {
            switch (_arg_1.type)
            {
                case WorldBossRoomEvent.PLAYER_NAME_VISIBLE:
                    this.nameVisible();
                    return;
            };
        }

        public function nameVisible():void
        {
            var _local_1:WorldRoomPlayer;
            for each (_local_1 in this._characters)
            {
                _local_1.isShowName = this._model.playerNameVisible;
            };
        }

        protected function updateMap(_arg_1:Event):void
        {
            var _local_2:WorldRoomPlayer;
            if (((!(this._characters)) || (this._characters.length <= 0)))
            {
                return;
            };
            for each (_local_2 in this._characters)
            {
                _local_2.updatePlayer();
                _local_2.isShowName = this._model.playerNameVisible;
            };
            this.BuildEntityDepth();
        }

        protected function __click(_arg_1:MouseEvent):void
        {
            if ((((!(this.selfPlayer)) || (!(this.selfPlayer.playerVO.playerStauts == 1))) || (!(this.selfPlayer.getCanAction()))))
            {
                return;
            };
            var _local_2:Point = this.globalToLocal(new Point(_arg_1.stageX, _arg_1.stageY));
            this.autoMove = false;
            if ((getTimer() - this._lastClick) > this._clickInterval)
            {
                this._lastClick = getTimer();
                if ((!(this.sceneScene.hit(_local_2))))
                {
                    this.selfPlayer.playerVO.walkPath = this.sceneScene.searchPath(this.selfPlayer.playerPoint, _local_2);
                    this.selfPlayer.playerVO.walkPath.shift();
                    this.selfPlayer.playerVO.scenePlayerDirection = SceneCharacterDirection.getDirection(this.selfPlayer.playerPoint, this.selfPlayer.playerVO.walkPath[0]);
                    this.selfPlayer.playerVO.currentWalkStartPoint = this.selfPlayer.currentWalkStartPoint;
                    this.sendMyPosition(this.selfPlayer.playerVO.walkPath.concat());
                    this._mouseMovie.x = _local_2.x;
                    this._mouseMovie.y = _local_2.y;
                    this._mouseMovie.play();
                };
            };
        }

        public function sendMyPosition(_arg_1:Array):void
        {
            var _local_3:uint;
            var _local_2:Array = [];
            while (_local_3 < _arg_1.length)
            {
                _local_2.push(int(_arg_1[_local_3].x), int(_arg_1[_local_3].y));
                _local_3++;
            };
            var _local_4:String = _local_2.toString();
            SocketManager.Instance.out.sendWorldBossRoomMove(_arg_1[(_arg_1.length - 1)].x, _arg_1[(_arg_1.length - 1)].y, _local_4);
        }

        public function movePlayer(_arg_1:int, _arg_2:Array):void
        {
            var _local_3:WorldRoomPlayer;
            if (this._characters[_arg_1])
            {
                _local_3 = (this._characters[_arg_1] as WorldRoomPlayer);
                if ((!(_local_3.getCanAction())))
                {
                    _local_3.playerVO.playerStauts = 1;
                    _local_3.setStatus();
                };
                _local_3.playerVO.walkPath = _arg_2;
                _local_3.playerWalk(_arg_2);
            };
        }

        public function updatePlayersStauts(_arg_1:int, _arg_2:int, _arg_3:Point):void
        {
            var _local_4:WorldRoomPlayer;
            if (this._characters[_arg_1])
            {
                _local_4 = (this._characters[_arg_1] as WorldRoomPlayer);
                if (((_arg_2 == 1) && (_local_4.playerVO.playerStauts == 3)))
                {
                    _local_4.playerVO.playerStauts = _arg_2;
                    _local_4.playerVO.playerPos = WorldBossManager.Instance.bossInfo.playerDefaultPos;
                    _local_4.setStatus();
                }
                else
                {
                    if (_arg_2 == 2)
                    {
                        if ((!(_local_4.getCanAction())))
                        {
                            _local_4.playerVO.playerStauts = 1;
                            _local_4.setStatus();
                        };
                        _local_4.playerVO.playerStauts = _arg_2;
                        _local_4.isReadyFight = true;
                        _local_4.addEventListener(WorldBossRoomEvent.READYFIGHT, this.__otherPlayrStartFight);
                        _local_4.playerVO.walkPath = [_arg_3];
                        _local_4.playerWalk([_arg_3]);
                    }
                    else
                    {
                        _local_4.playerVO.playerStauts = _arg_2;
                        _local_4.setStatus();
                    };
                };
            };
        }

        public function __otherPlayrStartFight(_arg_1:WorldBossRoomEvent):void
        {
            var _local_2:WorldRoomPlayer = (_arg_1.currentTarget as WorldRoomPlayer);
            _local_2.removeEventListener(WorldBossRoomEvent.READYFIGHT, this.__otherPlayrStartFight);
            _local_2.sceneCharacterDirection = SceneCharacterDirection.getDirection(_local_2.playerPoint, this.armyPos);
            _local_2.dispatchEvent(new SceneCharacterEvent(SceneCharacterEvent.CHARACTER_DIRECTION_CHANGE, false));
            _local_2.isReadyFight = false;
            _local_2.setStatus();
        }

        public function updateSelfStatus(_arg_1:int):void
        {
            if (this.selfPlayer.playerVO.playerStauts == 3)
            {
                this.selfPlayer.playerVO.playerPos = WorldBossManager.Instance.bossInfo.playerDefaultPos;
                this.ajustScreen(this.selfPlayer);
                this.setCenter();
                this._entering = false;
            };
            this.selfPlayer.playerVO.playerStauts = _arg_1;
            this.selfPlayer.setStatus();
            SocketManager.Instance.out.sendWorldBossRoomStauts(_arg_1);
            this.checkGameOver();
        }

        public function checkSelfStatus():int
        {
            return (this.selfPlayer.playerVO.playerStauts);
        }

        public function playerRevive(_arg_1:int):void
        {
            var _local_2:WorldRoomPlayer;
            if (this._characters[_arg_1])
            {
                _local_2 = (this._characters[_arg_1] as WorldRoomPlayer);
                _local_2.revive();
                this.selfPlayer.playerVO.playerStauts = 1;
                this._entering = false;
            };
        }

        private function worldBoss_mc_gotoAndplay():void
        {
            this._worldboss_mc.gotoAndPlay(this._frame_name);
        }

        private function checkGameOver():Boolean
        {
            if ((((WorldBossManager.Instance.bossInfo.fightOver) && (this._worldboss)) && (this._frame_name == "stand")))
            {
                this._worldboss.mouseEnabled = false;
                this._worldboss.removeEventListener(MouseEvent.CLICK, this._enterWorldBossGame);
                if ((!(WorldBossManager.Instance.bossInfo.isLiving)))
                {
                    this._frame_name = "out";
                }
                else
                {
                    if (WorldBossManager.Instance.bossInfo.getLeftTime() == 0)
                    {
                        this._frame_name = "outB";
                    };
                };
                setTimeout(this.worldBoss_mc_gotoAndplay, 1500);
                this._worldboss_sky.visible = false;
            };
            return (WorldBossManager.Instance.bossInfo.fightOver);
        }

        public function setCenter(_arg_1:SceneCharacterEvent=null):void
        {
            var _local_2:Number;
            var _local_3:Number;
            if (this.reference)
            {
                _local_2 = -(this.reference.x - (MoonSceneMap.GAME_WIDTH / 2));
                _local_3 = (-(this.reference.y - (MoonSceneMap.GAME_HEIGHT / 2)) + 50);
            }
            else
            {
                _local_2 = -(WorldBossManager.Instance.bossInfo.playerDefaultPos.x - (MoonSceneMap.GAME_WIDTH / 2));
                _local_3 = (-(WorldBossManager.Instance.bossInfo.playerDefaultPos.y - (MoonSceneMap.GAME_HEIGHT / 2)) + 50);
            };
            if (_local_2 > 0)
            {
                _local_2 = 0;
            };
            if (_local_2 < (MoonSceneMap.GAME_WIDTH - this._sceneMapVO.mapW))
            {
                _local_2 = (MoonSceneMap.GAME_WIDTH - this._sceneMapVO.mapW);
            };
            if (_local_3 > 0)
            {
                _local_3 = 0;
            };
            if (_local_3 < (MoonSceneMap.GAME_HEIGHT - this._sceneMapVO.mapH))
            {
                _local_3 = (MoonSceneMap.GAME_HEIGHT - this._sceneMapVO.mapH);
            };
            x = _local_2;
            y = _local_3;
            var _local_4:Point = this.globalToLocal(new Point(700, 300));
            this._worldboss_sky.x = _local_4.x;
            this._worldboss_sky.y = _local_4.y;
        }

        public function addSelfPlayer():void
        {
            var _local_1:PlayerVO;
            if ((!(this.selfPlayer)))
            {
                _local_1 = WorldBossManager.Instance.bossInfo.myPlayerVO;
                _local_1.playerInfo = PlayerManager.Instance.Self;
                this._currentLoadingPlayer = new WorldRoomPlayer(_local_1, this.addPlayerCallBack);
            };
        }

        protected function ajustScreen(_arg_1:WorldRoomPlayer):void
        {
            if (_arg_1 == null)
            {
                if (this.reference)
                {
                    this.reference.removeEventListener(SceneCharacterEvent.CHARACTER_MOVEMENT, this.setCenter);
                    this.reference = null;
                };
                return;
            };
            if (this.reference)
            {
                this.reference.removeEventListener(SceneCharacterEvent.CHARACTER_MOVEMENT, this.setCenter);
            };
            this.reference = _arg_1;
            this.reference.addEventListener(SceneCharacterEvent.CHARACTER_MOVEMENT, this.setCenter);
        }

        protected function __addPlayer(_arg_1:DictionaryEvent):void
        {
            var _local_2:PlayerVO = (_arg_1.data as PlayerVO);
            this._currentLoadingPlayer = new WorldRoomPlayer(_local_2, this.addPlayerCallBack);
        }

        private function addPlayerCallBack(_arg_1:WorldRoomPlayer, _arg_2:Boolean):void
        {
            if (((!(this.articleLayer)) || (!(_arg_1))))
            {
                return;
            };
            this._currentLoadingPlayer = null;
            _arg_1.sceneScene = this.sceneScene;
            _arg_1.setSceneCharacterDirectionDefault = (_arg_1.sceneCharacterDirection = _arg_1.playerVO.scenePlayerDirection);
            if (((!(this.selfPlayer)) && (_arg_1.playerVO.playerInfo.ID == PlayerManager.Instance.Self.ID)))
            {
                _arg_1.playerVO.playerPos = _arg_1.playerVO.playerPos;
                this.selfPlayer = _arg_1;
                this.articleLayer.addChild(this.selfPlayer);
                this.ajustScreen(this.selfPlayer);
                this.setCenter();
                this.selfPlayer.setStatus();
                this.selfPlayer.addEventListener(SceneCharacterEvent.CHARACTER_ACTION_CHANGE, this.playerActionChange);
            }
            else
            {
                this.articleLayer.addChild(_arg_1);
            };
            _arg_1.playerPoint = _arg_1.playerVO.playerPos;
            _arg_1.sceneCharacterStateType = "natural";
            this._characters.add(_arg_1.playerVO.playerInfo.ID, _arg_1);
            _arg_1.isShowName = this._model.playerNameVisible;
        }

        private function playerActionChange(_arg_1:SceneCharacterEvent):void
        {
            var _local_2:String = _arg_1.data.toString();
            if (((_local_2 == "naturalStandFront") || (_local_2 == "naturalStandBack")))
            {
                this._mouseMovie.gotoAndStop(1);
            };
        }

        protected function __removePlayer(_arg_1:DictionaryEvent):void
        {
            var _local_2:int = (_arg_1.data as PlayerVO).playerInfo.ID;
            var _local_3:WorldRoomPlayer = (this._characters[_local_2] as WorldRoomPlayer);
            this._characters.remove(_local_2);
            if (_local_3)
            {
                if (_local_3.parent)
                {
                    _local_3.parent.removeChild(_local_3);
                };
                _local_3.removeEventListener(SceneCharacterEvent.CHARACTER_MOVEMENT, this.setCenter);
                _local_3.removeEventListener(SceneCharacterEvent.CHARACTER_ACTION_CHANGE, this.playerActionChange);
                _local_3.dispose();
            };
            _local_3 = null;
        }

        protected function BuildEntityDepth():void
        {
            var _local_3:DisplayObject;
            var _local_4:Number;
            var _local_5:int;
            var _local_6:Number;
            var _local_7:int;
            var _local_8:DisplayObject;
            var _local_9:Number;
            var _local_1:int = this.articleLayer.numChildren;
            var _local_2:int;
            while (_local_2 < (_local_1 - 1))
            {
                _local_3 = this.articleLayer.getChildAt(_local_2);
                _local_4 = this.getPointDepth(_local_3.x, _local_3.y);
                _local_6 = Number.MAX_VALUE;
                _local_7 = (_local_2 + 1);
                while (_local_7 < _local_1)
                {
                    _local_8 = this.articleLayer.getChildAt(_local_7);
                    _local_9 = this.getPointDepth(_local_8.x, _local_8.y);
                    if (_local_9 < _local_6)
                    {
                        _local_5 = _local_7;
                        _local_6 = _local_9;
                    };
                    _local_7++;
                };
                if (_local_4 > _local_6)
                {
                    this.articleLayer.swapChildrenAt(_local_2, _local_5);
                };
                _local_2++;
            };
        }

        protected function getPointDepth(_arg_1:Number, _arg_2:Number):Number
        {
            return ((this.sceneMapVO.mapW * _arg_2) + _arg_1);
        }

        protected function removeEvent():void
        {
            this._model.removeEventListener(WorldBossRoomEvent.PLAYER_NAME_VISIBLE, this.menuChange);
            this._model.removeEventListener(WorldBossRoomEvent.PLAYER_CHATBALL_VISIBLE, this.menuChange);
            removeEventListener(MouseEvent.CLICK, this.__click);
            removeEventListener(Event.ENTER_FRAME, this.updateMap);
            this._data.removeEventListener(DictionaryEvent.ADD, this.__addPlayer);
            this._data.removeEventListener(DictionaryEvent.REMOVE, this.__removePlayer);
            if (this.reference)
            {
                this.reference.removeEventListener(SceneCharacterEvent.CHARACTER_MOVEMENT, this.setCenter);
            };
            if (this.selfPlayer)
            {
                this.selfPlayer.removeEventListener(SceneCharacterEvent.CHARACTER_ACTION_CHANGE, this.playerActionChange);
                this.selfPlayer.removeEventListener(SceneCharacterEvent.CHARACTER_ARRIVED_NEXT_STEP, this.__arrive);
            };
            WorldBossManager.Instance.removeEventListener(WorldBossRoomEvent.WORLDBOSS_ROOM_FULL, this.__onRoomFull);
            WorldBossManager.Instance.removeEventListener(WorldBossRoomEvent.STOPFIGHT, this.__stopFight);
            WorldBossManager.Instance.removeEventListener(WorldBossRoomEvent.STARTFIGHT, this.__startFight);
        }

        public function dispose():void
        {
            var p:WorldRoomPlayer;
            var i:int;
            var player:WorldRoomPlayer;
            this.removeEvent();
            this._data.clear();
            this._data = null;
            this._sceneMapVO = null;
            for each (p in this._characters)
            {
                if (p.parent)
                {
                    p.parent.removeChild(p);
                };
                p.removeEventListener(SceneCharacterEvent.CHARACTER_MOVEMENT, this.setCenter);
                p.removeEventListener(SceneCharacterEvent.CHARACTER_ACTION_CHANGE, this.playerActionChange);
                p.dispose();
                p = null;
            };
            this._characters.clear();
            this._characters = null;
            if (this.articleLayer)
            {
                i = this.articleLayer.numChildren;
                while (i > 0)
                {
                    player = (this.articleLayer.getChildAt((i - 1)) as WorldRoomPlayer);
                    if (player)
                    {
                        player.removeEventListener(SceneCharacterEvent.CHARACTER_MOVEMENT, this.setCenter);
                        player.removeEventListener(SceneCharacterEvent.CHARACTER_ACTION_CHANGE, this.playerActionChange);
                        if (player.parent)
                        {
                            player.parent.removeChild(player);
                        };
                        player.dispose();
                    };
                    player = null;
                    try
                    {
                        this.articleLayer.removeChildAt((i - 1));
                    }
                    catch(e:RangeError)
                    {
                    };
                    i = (i - 1);
                };
                if (((this.articleLayer) && (this.articleLayer.parent)))
                {
                    this.articleLayer.parent.removeChild(this.articleLayer);
                };
            };
            this.articleLayer = null;
            if (this.selfPlayer)
            {
                if (this.selfPlayer.parent)
                {
                    this.selfPlayer.parent.removeChild(this.selfPlayer);
                };
                this.selfPlayer.dispose();
            };
            this.selfPlayer = null;
            if (this._currentLoadingPlayer)
            {
                if (this._currentLoadingPlayer.parent)
                {
                    this._currentLoadingPlayer.parent.removeChild(this._currentLoadingPlayer);
                };
                this._currentLoadingPlayer.dispose();
            };
            this._currentLoadingPlayer = null;
            if (((this._mouseMovie) && (this._mouseMovie.parent)))
            {
                this._mouseMovie.parent.removeChild(this._mouseMovie);
            };
            this._mouseMovie = null;
            if (((this.meshLayer) && (this.meshLayer.parent)))
            {
                this.meshLayer.parent.removeChild(this.meshLayer);
            };
            this.meshLayer = null;
            if (((this.bgLayer) && (this.bgLayer.parent)))
            {
                this.bgLayer.parent.removeChild(this.bgLayer);
            };
            this.bgLayer = null;
            if (((this.skyLayer) && (this.skyLayer.parent)))
            {
                this.skyLayer.parent.removeChild(this.skyLayer);
            };
            this.skyLayer = null;
            this.sceneScene = null;
            if (parent)
            {
                this.parent.removeChild(this);
            };
        }


    }
}//package worldboss.view

