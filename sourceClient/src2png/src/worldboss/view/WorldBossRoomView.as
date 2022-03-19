// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//worldboss.view.WorldBossRoomView

package worldboss.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import worldboss.WorldBossRoomController;
    import worldboss.model.WorldBossRoomModel;
    import ddt.view.scenePathSearcher.SceneScene;
    import ddt.view.chat.ChatView;
    import flash.utils.Timer;
    import ddt.manager.PathManager;
    import ddt.manager.SoundManager;
    import worldboss.WorldBossManager;
    import ddt.manager.ChatManager;
    import com.pickgliss.ui.ComponentFactory;
    import flash.events.Event;
    import flash.events.TimerEvent;
    import com.pickgliss.utils.ClassUtils;
    import flash.display.MovieClip;
    import ddt.view.scenePathSearcher.PathMapHitTester;
    import ddt.manager.SocketManager;
    import flash.geom.Point;
    import church.vo.SceneMapVO;
    import ddt.manager.LanguageMgr;
    import ddt.utils.PositionUtils;
    import ddt.manager.StateManager;
    import ddt.states.StateType;
    import com.pickgliss.utils.ObjectUtils;

    public class WorldBossRoomView extends Sprite implements Disposeable 
    {

        public static const MAP_SIZEII:Array = [1738, 1300];

        private var _contoller:WorldBossRoomController;
        private var _model:WorldBossRoomModel;
        private var _sceneScene:SceneScene;
        private var _sceneMap:WorldBossScneneMap;
        private var _chatFrame:ChatView;
        private var _roomMenuView:RoomMenuView;
        private var _bossHP:WorldBossHPScript;
        private var _totalContainer:WorldBossRoomTotalInfoView;
        private var _resurrectFrame:WorldBossResurrectView;
        private var _buffIcon:WorldBossBuffIcon;
        private var _buffIconArr:Array = new Array();
        private var _timer:Timer;
        private var _diff:int;

        public function WorldBossRoomView(_arg_1:WorldBossRoomController, _arg_2:WorldBossRoomModel)
        {
            this._contoller = _arg_1;
            this._model = _arg_2;
            this.initialize();
        }

        public static function getImagePath(_arg_1:int):String
        {
            return ((PathManager.solveWorldbossBuffPath() + _arg_1) + ".png");
        }


        public function show():void
        {
            this._contoller.addChild(this);
        }

        private function initialize():void
        {
            SoundManager.instance.playMusic(("worldbossroom-" + WorldBossManager.Instance.BossResourceId));
            this._sceneScene = new SceneScene();
            ChatManager.Instance.state = ChatManager.CHAT_WORLDBOS_ROOM;
            this._chatFrame = ChatManager.Instance.view;
            addChild(this._chatFrame);
            ChatManager.Instance.setFocus();
            this._roomMenuView = ComponentFactory.Instance.creat("worldboss.room.menuView");
            this._roomMenuView.leaveMsg = "worldboss.room.leaveroom";
            addChild(this._roomMenuView);
            this._roomMenuView.addEventListener(Event.CLOSE, this._leaveRoom);
            this._bossHP = ComponentFactory.Instance.creat("worldboss.room.bossHP");
            addChild(this._bossHP);
            this.refreshHpScript();
            this._diff = ((WorldBossManager.Instance.bossInfo.fightOver) ? 0 : WorldBossManager.Instance.bossInfo.getLeftTime());
            this._totalContainer = ComponentFactory.Instance.creat("worldboss.room.infoView");
            addChildAt(this._totalContainer, 0);
            this._totalContainer.updata_yourSelf_damage();
            this._totalContainer.setTimeCount(this._diff);
            this._buffIcon = ComponentFactory.Instance.creat("worldboss.room.buffIcon");
            addChild(this._buffIcon);
            this._buffIcon.addEventListener(Event.CHANGE, this.showBuff);
            this.setMap();
            this._timer = new Timer(1000, this._diff);
            this._timer.addEventListener(TimerEvent.TIMER, this.__timeOne);
            this._timer.start();
        }

        public function refreshHpScript():void
        {
            if ((!(this._bossHP)))
            {
                return;
            };
            if (((WorldBossManager.Instance.isShowBlood) && ((!(WorldBossManager.Instance.bossInfo.fightOver)) || (!(WorldBossManager.Instance.bossInfo.isLiving)))))
            {
                this._bossHP.visible = true;
                this._bossHP.refreshBossName();
                this._bossHP.refreshBlood();
            }
            else
            {
                this._bossHP.visible = false;
            };
        }

        public function setViewAgain():void
        {
            SoundManager.instance.playMusic(("worldbossroom-" + WorldBossManager.Instance.BossResourceId));
            ChatManager.Instance.state = ChatManager.CHAT_WORLDBOS_ROOM;
            this._chatFrame = ChatManager.Instance.view;
            addChild(this._chatFrame);
            ChatManager.Instance.setFocus();
            this._totalContainer.updata_yourSelf_damage();
            this._sceneMap.enterIng = false;
            this._sceneMap.removePrompt();
            this.refreshHpScript();
        }

        public function __timeOne(_arg_1:TimerEvent):void
        {
            this._diff--;
            if (this._diff < 0)
            {
                this.timeComplete();
            }
            else
            {
                this._totalContainer.setTimeCount(this._diff);
            };
        }

        public function timeComplete():void
        {
            this._timer.removeEventListener(TimerEvent.TIMER, this.__timeOne);
            if (this._timer.running)
            {
                this._timer.reset();
            };
            if (((WorldBossManager.Instance.bossInfo.isLiving) && (this._bossHP)))
            {
                removeChild(this._bossHP);
                this._bossHP.dispose();
                this._bossHP = null;
            };
            this.__resurrectTimeOver();
        }

        public function setMap(_arg_1:Point=null):void
        {
            this.clearMap();
            var _local_2:MovieClip = (new ((ClassUtils.uiSourceDomain.getDefinition(this.getMapRes()) as Class))() as MovieClip);
            var _local_3:Sprite = (_local_2.getChildByName("articleLayer") as Sprite);
            var _local_4:Sprite = (_local_2.getChildByName("worldbossMouse") as Sprite);
            var _local_5:Sprite = (_local_2.getChildByName("mesh") as Sprite);
            var _local_6:Sprite = (_local_2.getChildByName("bg") as Sprite);
            var _local_7:Sprite = (_local_2.getChildByName("bgSize") as Sprite);
            var _local_8:Sprite = (_local_2.getChildByName("decoration") as Sprite);
            if (_local_7)
            {
                MAP_SIZEII[0] = _local_7.width;
                MAP_SIZEII[1] = _local_7.height;
            }
            else
            {
                MAP_SIZEII[0] = _local_6.width;
                MAP_SIZEII[1] = _local_6.height;
            };
            this._sceneScene.setHitTester(new PathMapHitTester(_local_5));
            if ((!(this._sceneMap)))
            {
                this._sceneMap = new WorldBossScneneMap(this._model, this._sceneScene, this._model.getPlayers(), _local_6, _local_5, _local_3, _local_4, _local_8);
                addChildAt(this._sceneMap, 0);
            };
            this._sceneMap.sceneMapVO = this.getSceneMapVO();
            if (_arg_1)
            {
                this._sceneMap.sceneMapVO.defaultPos = _arg_1;
            };
            this._sceneMap.addSelfPlayer();
            this._sceneMap.setCenter();
            SocketManager.Instance.out.sendAddPlayer(WorldBossManager.Instance.bossInfo.myPlayerVO.playerPos);
            if (WorldBossManager.Instance.bossInfo.myPlayerVO.reviveCD > 0)
            {
                this.showResurrectFrame(WorldBossManager.Instance.bossInfo.myPlayerVO.reviveCD);
            };
        }

        public function getSceneMapVO():SceneMapVO
        {
            var _local_1:SceneMapVO = new SceneMapVO();
            _local_1.mapName = LanguageMgr.GetTranslation("church.churchScene.WeddingMainScene");
            _local_1.mapW = MAP_SIZEII[0];
            _local_1.mapH = MAP_SIZEII[1];
            _local_1.defaultPos = ComponentFactory.Instance.creatCustomObject("worldboss.RoomView.sceneMapVOPosII");
            return (_local_1);
        }

        public function clearBuff():void
        {
            var _local_1:BuffItem;
            while (this._buffIconArr.length > 0)
            {
                _local_1 = (this._buffIconArr[0] as BuffItem);
                this._buffIconArr.shift();
                removeChild(_local_1);
                _local_1.dispose();
            };
        }

        public function showBuff(_arg_1:Event=null):void
        {
        }

        public function movePlayer(_arg_1:int, _arg_2:Array):void
        {
            if (this._sceneMap)
            {
                this._sceneMap.movePlayer(_arg_1, _arg_2);
            };
        }

        public function updatePlayerStauts(_arg_1:int, _arg_2:int, _arg_3:Point=null):void
        {
            if (this._sceneMap)
            {
                this._sceneMap.updatePlayersStauts(_arg_1, _arg_2, _arg_3);
            };
        }

        public function updateSelfStatus(_arg_1:int):void
        {
            this._sceneMap.updateSelfStatus(_arg_1);
        }

        public function checkSelfStatus():void
        {
            if (((!(WorldBossManager.Instance.bossInfo.fightOver)) && (WorldBossManager.IsSuccessStartGame)))
            {
                SocketManager.Instance.out.sendErrorMsg(((((((("world boss error:not show the resurrectView.Data:" + this._sceneMap.checkSelfStatus()) + "--") + WorldBossManager.Instance.bossInfo.fightOver) + "--") + WorldBossManager.IsSuccessStartGame) + "--") + WorldBossManager.Instance.bossInfo.timeCD));
                this.showResurrectFrame(WorldBossManager.Instance.bossInfo.timeCD);
            }
            else
            {
                this._sceneMap.updateSelfStatus(1);
            };
        }

        private function showResurrectFrame(_arg_1:int):void
        {
            this._resurrectFrame = new WorldBossResurrectView(_arg_1);
            PositionUtils.setPos(this._resurrectFrame, "worldRoom.resurrectView.pos");
            addChild(this._resurrectFrame);
            this._resurrectFrame.addEventListener(Event.COMPLETE, this.__resurrectTimeOver);
            this._roomMenuView.visible = false;
        }

        public function playerRevive(_arg_1:int):void
        {
            if (((this._sceneMap.selfPlayer) && (_arg_1 == this._sceneMap.selfPlayer.ID)))
            {
                if (this._resurrectFrame)
                {
                    this.removeFrame();
                };
                if (this._roomMenuView)
                {
                    this._roomMenuView.visible = true;
                };
            };
            this._sceneMap.playerRevive(_arg_1);
        }

        private function __resurrectTimeOver(_arg_1:Event=null):void
        {
            this.removeFrame();
            this._roomMenuView.visible = true;
            this._sceneMap.updateSelfStatus(1);
        }

        private function removeFrame():void
        {
            if (this._resurrectFrame)
            {
                this._resurrectFrame.removeEventListener(Event.COMPLETE, this.__resurrectTimeOver);
                if (this._resurrectFrame.parent)
                {
                    removeChild(this._resurrectFrame);
                };
                this._resurrectFrame.dispose();
                this._resurrectFrame = null;
            };
        }

        private function _leaveRoom(_arg_1:Event):void
        {
            StateManager.setState(StateType.MAIN);
            this._contoller.dispose();
        }

        public function gameOver():void
        {
            this._sceneMap.gameOver();
            this._totalContainer.restTimeInfo();
        }

        public function updataRanking(_arg_1:Array):void
        {
            this._totalContainer.updataRanking(_arg_1);
        }

        public function getMapRes():String
        {
            return ("tank.WorldBoss.Map-" + WorldBossManager.Instance.BossResourceId);
        }

        private function clearMap():void
        {
            if (this._sceneMap)
            {
                if (this._sceneMap.parent)
                {
                    this._sceneMap.parent.removeChild(this._sceneMap);
                };
                this._sceneMap.dispose();
            };
            this._sceneMap = null;
        }

        public function dispose():void
        {
            WorldBossManager.Instance.bossInfo.myPlayerVO.buffs = new Array();
            this._roomMenuView.removeEventListener(Event.CLOSE, this._leaveRoom);
            if (this._timer)
            {
                this._timer.stop();
                this._timer.removeEventListener(TimerEvent.TIMER, this.__timeOne);
            };
            ObjectUtils.disposeAllChildren(this);
            if (parent)
            {
                parent.removeChild(this);
            };
            ObjectUtils.disposeObject(this._roomMenuView);
            this._roomMenuView = null;
            this._buffIcon = null;
            this._totalContainer = null;
            this._bossHP = null;
            this._resurrectFrame = null;
            this._sceneScene = null;
            this._sceneMap = null;
            this._chatFrame = null;
        }


    }
}//package worldboss.view

