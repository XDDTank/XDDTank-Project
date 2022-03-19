// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//arena.ArenaManager

package arena
{
    import flash.utils.Timer;
    import arena.model.ArenaEvent;
    import ddt.manager.GameInSocketOut;
    import room.model.RoomInfo;
    import flash.events.TimerEvent;
    import ddt.manager.SocketManager;
    import arena.model.ArenaPackageTypes;
    import road7th.comm.PackageIn;
    import ddt.data.player.PlayerInfo;
    import arena.model.ArenaScenePlayerInfo;
    import flash.geom.Point;
    import arena.model.ArenaPlayerStates;
    import ddt.manager.TimeManager;
    import ddt.manager.PlayerManager;
    import ddt.manager.StateManager;
    import ddt.states.StateType;
    import ddt.manager.MessageTipManager;
    import ddt.manager.LanguageMgr;
    import ddt.manager.ChatManager;
    import ddt.manager.ServerConfigManager;
    import worldboss.WorldBossManager;
    import liveness.LivenessBubbleManager;
    import road7th.utils.DateUtils;
    import ddt.events.TimeEvents;
    import ddt.view.UIModuleSmallLoading;
    import com.pickgliss.loader.UIModuleLoader;
    import com.pickgliss.events.UIModuleEvent;
    import ddt.data.UIModuleTypes;
    import com.pickgliss.loader.BaseLoader;
    import com.pickgliss.loader.LoadResourceManager;
    import com.pickgliss.loader.LoaderEvent;
    import flash.events.Event;
    import ddt.manager.PathManager;

    public class ArenaManager 
    {

        private static var _instance:ArenaManager;
        public static const LAST_TIME:int = 600;

        private var _model:ArenaModel;
        private var _loadComplete:Boolean;
        private var _lastTime:int;
        private var _timer:Timer;
        private var _hasSendAsk:Boolean = false;
        private var _open:Boolean = false;
        private var _enterType:int;
        private var _hasIn:Boolean = false;
        private var _sendAsk:Boolean = false;

        public function ArenaManager()
        {
            this._model = new ArenaModel();
            this.model.addEventListener(ArenaEvent.ENTER_SCENE, this.__enterScene);
            this.model.addEventListener(ArenaEvent.LEAVE_SCENE, this.__leaveScene);
        }

        public static function get instance():ArenaManager
        {
            if ((!(_instance)))
            {
                _instance = new (ArenaManager)();
            };
            return (_instance);
        }


        public function get open():Boolean
        {
            return (this._open);
        }

        public function get model():ArenaModel
        {
            return (this._model);
        }

        public function sendEnterScene():void
        {
            GameInSocketOut.sendCreateRoom("", RoomInfo.ARENA, 3);
        }

        private function __timerComplete(_arg_1:TimerEvent):void
        {
            this._timer.stop();
            this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE, this.__timerComplete);
            this._timer = null;
        }

        public function sendEnterAfterFight():void
        {
            SocketManager.Instance.out.sendArenaEnterScene(this.model.selfInfo.sceneLevel, this.model.selfInfo.sceneID);
        }

        public function sendUpdate():void
        {
            SocketManager.Instance.out.sendArenaUpdate(this.model.selfInfo.sceneLevel, this.model.selfInfo.sceneID);
        }

        public function sendAskForActivityType():void
        {
            this._sendAsk = true;
            SocketManager.Instance.out.sendAskForActivityType();
        }

        public function sendMove(_arg_1:int, _arg_2:int, _arg_3:String):void
        {
            SocketManager.Instance.out.sendArenaPlayerMove(this.model.selfInfo.sceneLevel, this.model.selfInfo.sceneID, _arg_1, _arg_2, _arg_3);
        }

        public function sendExit():void
        {
            if (this.model.selfInfo)
            {
                SocketManager.Instance.out.sendArenaExitScene(this.model.selfInfo.sceneLevel, this.model.selfInfo.sceneID);
            };
        }

        public function sendFight(_arg_1:int):void
        {
            SocketManager.Instance.out.sendArenaPlayerFight(_arg_1, this.model.selfInfo.sceneLevel, this.model.selfInfo.sceneID);
        }

        public function sendRelive(_arg_1:int):void
        {
            SocketManager.Instance.out.sendArenaRelive(this.model.selfInfo.sceneLevel, this.model.selfInfo.sceneID, _arg_1);
        }

        public function dealPackage(_arg_1:PackageIn):void
        {
            var _local_2:int = _arg_1.readByte();
            switch (_local_2)
            {
                case ArenaPackageTypes.ENTER_SCENE:
                    this.dealEnter(_arg_1);
                    return;
                case ArenaPackageTypes.EXIT_SCENE:
                    this.dealExit(_arg_1);
                    return;
                case ArenaPackageTypes.FIGHT_SCENE:
                    this.dealFight(_arg_1);
                    return;
                case ArenaPackageTypes.MOVE_SCENE:
                    this.dealMove(_arg_1);
                    return;
                case ArenaPackageTypes.RELIVE_SCENE:
                    this.dealRelive(_arg_1);
                    return;
                case ArenaPackageTypes.UPDATE_SCENE:
                    this.dealUpate(_arg_1);
                    return;
                case ArenaPackageTypes.ACTIVITY_TYPE:
                    this.dealActivityType(_arg_1);
                    return;
            };
        }

        private function checkState():Boolean
        {
            return (this._hasIn);
        }

        private function dealEnter(_arg_1:PackageIn):void
        {
            var _local_3:PlayerInfo;
            var _local_4:ArenaScenePlayerInfo;
            if ((!(this.checkState())))
            {
                return;
            };
            var _local_2:int = _arg_1.readInt();
            var _local_5:int;
            while (_local_5 < _local_2)
            {
                _local_3 = new PlayerInfo();
                _local_4 = new ArenaScenePlayerInfo();
                _local_3.ID = _arg_1.readInt();
                _local_3.NickName = _arg_1.readUTF();
                _local_3.Grade = _arg_1.readInt();
                _local_3.hp = _arg_1.readInt();
                _local_3.VIPtype = _arg_1.readInt();
                _local_3.VIPLevel = _arg_1.readInt();
                _local_3.Sex = _arg_1.readBoolean();
                _local_3.Style = _arg_1.readUTF();
                _local_3.Colors = _arg_1.readUTF();
                _local_3.Skin = _arg_1.readUTF();
                _local_3.Hide = _arg_1.readInt();
                _local_4.playerInfo = _local_3;
                _local_4.bufferType = _arg_1.readInt();
                _local_4.sceneLevel = _arg_1.readInt();
                _local_4.sceneID = _arg_1.readInt();
                _local_4.playerPos = new Point(_arg_1.readInt(), _arg_1.readInt());
                _local_4.playerType = _arg_1.readInt();
                _local_4.playerStauts = _arg_1.readInt();
                _local_4.arenaCount = _arg_1.readInt();
                _local_4.arenaFlag = _arg_1.readInt();
                _local_4.arenaCurrentBlood = _arg_1.readInt();
                if (_local_4.playerStauts == ArenaPlayerStates.DEATH)
                {
                    _local_4.arenaCurrentBlood = 0;
                };
                _local_4.arenaMaxWin = _arg_1.readInt();
                _local_4.arenaFightScore = _arg_1.readInt();
                _local_4.arenaWinScore = _arg_1.readInt();
                _local_4.enterTime = TimeManager.Instance.Now();
                if (_local_3.ID == PlayerManager.Instance.Self.ID)
                {
                    _local_4.playerInfo = PlayerManager.Instance.Self;
                    this.model.selfInfo = _local_4;
                };
                this.model.addPlayerInfo(_local_3.ID, _local_4);
                _local_5++;
            };
        }

        private function dealUpate(_arg_1:PackageIn):void
        {
            var _local_2:int = _arg_1.readInt();
            if (((!(this.checkState())) && (!(_local_2 == PlayerManager.Instance.Self.ID))))
            {
                return;
            };
            var _local_3:ArenaScenePlayerInfo = this.model.playerDic[_local_2];
            if (((_local_2 == PlayerManager.Instance.Self.ID) && (_local_3 == null)))
            {
                _local_3 = ArenaManager._instance.model.selfInfo;
            };
            _local_3.playerType = _arg_1.readInt();
            _local_3.playerStauts = _arg_1.readInt();
            _local_3.arenaCount = _arg_1.readInt();
            _local_3.arenaFlag = _arg_1.readInt();
            _local_3.arenaCurrentBlood = _arg_1.readInt();
            _local_3.arenaMaxWin = _arg_1.readInt();
            _local_3.arenaFightScore = _arg_1.readInt();
            _local_3.arenaWinScore = _arg_1.readInt();
            var _local_4:Point = new Point(_arg_1.readInt(), _arg_1.readInt());
            _local_3.playerPos = _local_4;
            _local_3.bufferType = _arg_1.readInt();
            if (_local_3.playerStauts == ArenaPlayerStates.DEATH)
            {
                _local_3.arenaCurrentBlood = 0;
            };
            if (_local_3.playerInfo.ID == PlayerManager.Instance.Self.ID)
            {
                _local_3.playerInfo = PlayerManager.Instance.Self;
                this.model.selfInfo = _local_3;
            };
            this.model.updatePlayerInfo(_local_2, _local_3);
        }

        private function dealExit(_arg_1:PackageIn):void
        {
            if ((!(this.checkState())))
            {
                return;
            };
            var _local_2:int = _arg_1.readInt();
            if (_local_2 == PlayerManager.Instance.Self.ID)
            {
                StateManager.setState(StateType.MAIN);
            }
            else
            {
                this.model.removePlayerInfo(_local_2);
                if (((this.model.playerDic.length < 10) && (!(this.model.selfInfo.sceneID == 1))))
                {
                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.arena.reassignedNotice"));
                    ChatManager.Instance.sysChatYellow(LanguageMgr.GetTranslation("ddt.arena.reassignedNotice"));
                };
            };
        }

        private function dealActivityType(_arg_1:PackageIn):void
        {
            var _local_3:String;
            var _local_2:Boolean = _arg_1.readBoolean();
            this._open = _local_2;
            if (this._open)
            {
                _local_3 = LanguageMgr.GetTranslation("ddt.arena.open");
            };
            this._model.dispatchEvent(new ArenaEvent(ArenaEvent.ARENA_ACTIVITY, this._open));
            if ((!(this._sendAsk)))
            {
                if (((StateManager.currentStateType == StateType.MAIN) && (_local_3)))
                {
                    MessageTipManager.getInstance().show(_local_3);
                };
            };
            this._sendAsk = false;
        }

        private function dealFight(_arg_1:PackageIn):void
        {
        }

        private function dealRelive(_arg_1:PackageIn):void
        {
        }

        private function dealMove(_arg_1:PackageIn):void
        {
            var _local_9:Point;
            if ((!(this.checkState())))
            {
                return;
            };
            var _local_2:int = _arg_1.readInt();
            var _local_3:int = _arg_1.readInt();
            var _local_4:int = _arg_1.readInt();
            var _local_5:String = _arg_1.readUTF();
            if (_local_2 == this.model.selfInfo.playerInfo.ID)
            {
                return;
            };
            var _local_6:Array = _local_5.split(",");
            var _local_7:Array = [];
            var _local_8:uint;
            while (_local_8 < _local_6.length)
            {
                _local_9 = new Point(_local_6[_local_8], _local_6[(_local_8 + 1)]);
                _local_7.push(_local_9);
                _local_8 = (_local_8 + 2);
            };
            this.model.playerDic[_local_2].walkPath = _local_7;
        }

        public function enter(_arg_1:int=0):void
        {
            var _local_2:String;
            if ((!(this._open)))
            {
                _local_2 = LanguageMgr.GetTranslation("ddt.arena.notopen");
            }
            else
            {
                if ((!(PlayerManager.Instance.Self.Bag.getItemAt(14))))
                {
                    _local_2 = LanguageMgr.GetTranslation("ddt.arena.noWeapon");
                }
                else
                {
                    if (PlayerManager.Instance.Self.OvertimeListByBody.length > 0)
                    {
                        _local_2 = LanguageMgr.GetTranslation("ddt.arena.overdue");
                    }
                    else
                    {
                        if (PlayerManager.Instance.Self.Grade < ServerConfigManager.instance.getArenaOpenLevel())
                        {
                            _local_2 = LanguageMgr.GetTranslation("ddt.arena.level", ServerConfigManager.instance.getArenaOpenLevel());
                        }
                        else
                        {
                            if (this.model.selfInfo.arenaFlag <= 0)
                            {
                                _local_2 = LanguageMgr.GetTranslation("ddt.arena.enter.notice1");
                            }
                            else
                            {
                                if (this.model.selfInfo.arenaCount >= 40)
                                {
                                    _local_2 = LanguageMgr.GetTranslation("ddt.arena.enter.notice2");
                                };
                            };
                        };
                    };
                };
            };
            if (((!(_local_2 == "")) && (!(_local_2 == null))))
            {
                MessageTipManager.getInstance().show(_local_2);
                ChatManager.Instance.sysChatYellow(_local_2);
                if (StateManager.currentStateType != StateType.MAIN)
                {
                    this.sendExit();
                };
                return;
            };
            this._enterType = _arg_1;
            if (this._loadComplete)
            {
                this.turnState();
            }
            else
            {
                this.loadUI();
            };
            if ((!(WorldBossManager.Instance.isOpen)))
            {
                LivenessBubbleManager.Instance.removeBubble();
            };
        }

        public function beginTime():Date
        {
            var _local_1:Date;
            return (DateUtils.dealWithStringDate(ServerConfigManager.instance.getArenaBeginTime()));
        }

        private function turnState():void
        {
            StateManager.setState(StateType.ARENA);
            this._lastTime = 0;
        }

        private function __seconds(_arg_1:TimeEvents):void
        {
            this._lastTime++;
            if (this._lastTime == (LAST_TIME - 60))
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.arena.ticked.notice"));
                ChatManager.Instance.sysChatYellow(LanguageMgr.GetTranslation("ddt.arena.ticked.notice"));
            }
            else
            {
                if (this._lastTime >= LAST_TIME)
                {
                    StateManager.setState(StateType.MAIN);
                };
            };
        }

        private function __enterScene(_arg_1:ArenaEvent):void
        {
            this._hasIn = true;
            TimeManager.addEventListener(TimeEvents.SECONDS, this.__seconds);
            this._hasSendAsk = false;
            if (this._enterType == 0)
            {
                this.sendEnterScene();
            }
            else
            {
                this.sendEnterAfterFight();
            };
        }

        private function __leaveScene(_arg_1:ArenaEvent):void
        {
            this._hasIn = false;
            TimeManager.removeEventListener(TimeEvents.SECONDS, this.__seconds);
            this.model.clearPlayer();
        }

        private function loadUI():void
        {
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__moduleComplete);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS, this.__onProgress);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_ERROR, this.__moduleIOError);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.DDT_ARENA);
        }

        private function loadResFile(_arg_1:String):void
        {
            var _local_2:BaseLoader;
            _local_2 = LoadResourceManager.instance.createLoader(_arg_1, BaseLoader.MODULE_LOADER);
            _local_2.addEventListener(LoaderEvent.COMPLETE, this.__onloadResFileComplete);
            LoadResourceManager.instance.startLoad(_local_2);
        }

        private function __onloadResFileComplete(_arg_1:LoaderEvent):void
        {
            _arg_1.target.removeEventListener(LoaderEvent.COMPLETE, this.__onloadResFileComplete);
            this.turnState();
        }

        private function __onProgress(_arg_1:UIModuleEvent):void
        {
            UIModuleSmallLoading.Instance.progress = (_arg_1.loader.progress * 100);
        }

        private function __moduleIOError(_arg_1:UIModuleEvent):void
        {
            if (_arg_1.module == UIModuleTypes.DDT_ARENA)
            {
                UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__moduleComplete);
                UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS, this.__onProgress);
                UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_ERROR, this.__moduleIOError);
                UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE, this.__loadingClose);
                UIModuleSmallLoading.Instance.hide();
            };
        }

        private function __moduleComplete(_arg_1:UIModuleEvent):void
        {
            if (_arg_1.module == UIModuleTypes.DDT_ARENA)
            {
                this.loadResFile(PathManager.solveWalkSceneMapPath("map7"));
                UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__moduleComplete);
                UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS, this.__onProgress);
                UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_ERROR, this.__moduleIOError);
                UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE, this.__loadingClose);
                UIModuleSmallLoading.Instance.hide();
            };
        }

        private function __loadingClose(_arg_1:Event):void
        {
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__moduleComplete);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS, this.__onProgress);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_ERROR, this.__moduleIOError);
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE, this.__loadingClose);
            UIModuleSmallLoading.Instance.hide();
        }


    }
}//package arena

