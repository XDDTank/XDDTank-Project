// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//worldboss.WorldBossManager

package worldboss
{
    import flash.events.EventDispatcher;
    import com.pickgliss.loader.BaseLoader;
    import worldboss.model.WorldBossInfo;
    import worldboss.view.WorldBossIcon;
    import flash.display.MovieClip;
    import road7th.data.DictionaryData;
    import __AS3__.vec.Vector;
    import worldboss.player.RankingPersonInfo;
    import flash.utils.Timer;
    import ddt.manager.SocketManager;
    import ddt.events.CrazyTankSocketEvent;
    import worldboss.model.WorldBossBuffInfo;
    import flash.geom.Point;
    import ddt.utils.Helpers;
    import com.pickgliss.utils.ObjectUtils;
    import worldboss.player.PlayerVO;
    import worldboss.event.WorldBossRoomEvent;
    import road7th.comm.PackageIn;
    import flash.events.Event;
    import com.pickgliss.loader.LoadResourceManager;
    import com.pickgliss.loader.LoaderEvent;
    import ddt.manager.StateManager;
    import ddt.states.StateType;
    import ddt.view.UIModuleSmallLoading;
    import worldboss.view.WorldBossRankingFram;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.manager.CacheSysManager;
    import ddt.constants.CacheConsts;
    import ddt.manager.GameInSocketOut;
    import com.pickgliss.ui.LayerManager;
    import ddt.manager.PlayerManager;
    import ddt.manager.PathManager;
    import ddt.manager.MessageTipManager;
    import ddt.manager.LanguageMgr;
    import ddt.manager.LeavePageManager;
    import baglocked.BaglockedManager;
    import com.pickgliss.loader.UIModuleLoader;
    import com.pickgliss.events.UIModuleEvent;
    import __AS3__.vec.*;

    public class WorldBossManager extends EventDispatcher 
    {

        private static var _instance:WorldBossManager;
        public static var IsSuccessStartGame:Boolean = false;
        public static const UPDATE_WORLDBOSS_SCORE:String = "updateWorldBossScore";

        private var _ishallComplete:Boolean = false;
        private var _isOpen:Boolean = false;
        private var _mapload:BaseLoader;
        private var _bossInfo:WorldBossInfo;
        private var _entranceBtn:WorldBossIcon;
        private var _currentPVE_ID:int;
        public var sky:MovieClip;
        public var iconEnterPath:String;
        public var mapPath:String;
        private var _autoBuyBuffs:DictionaryData = new DictionaryData();
        private var _appearPos:Array = new Array();
        private var _isShowBlood:Boolean = false;
        private var _isBuyBuffAlert:Boolean = false;
        private var _bossResourceId:String = "1";
        private var _rankingInfos:Vector.<RankingPersonInfo> = new Vector.<RankingPersonInfo>();
        private var _autoBlood:Boolean = false;
        private var _mapLoader:BaseLoader;
        private var _isLoadingState:Boolean = false;
        private var _timer:Timer;
        private var _loadedCallBack:Function;
        private var _loadingModuleType:String;


        public static function get Instance():WorldBossManager
        {
            if ((!(WorldBossManager._instance)))
            {
                WorldBossManager._instance = new (WorldBossManager)();
            };
            return (WorldBossManager._instance);
        }


        public function setup():void
        {
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.WORLDBOSS_INIT, this.__init);
            this._bossInfo = new WorldBossInfo();
        }

        public function get BossResourceId():String
        {
            return (this._bossResourceId);
        }

        public function get isBuyBuffAlert():Boolean
        {
            return (this._isBuyBuffAlert);
        }

        public function set isBuyBuffAlert(_arg_1:Boolean):void
        {
            this._isBuyBuffAlert = _arg_1;
        }

        public function get autoBuyBuffs():DictionaryData
        {
            return (this._autoBuyBuffs);
        }

        public function get isShowBlood():Boolean
        {
            return (this._isShowBlood);
        }

        public function get isAutoBlood():Boolean
        {
            return (this._autoBlood);
        }

        public function get rankingInfos():Vector.<RankingPersonInfo>
        {
            return (this._rankingInfos);
        }

        private function __init(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_8:WorldBossBuffInfo;
            this._bossResourceId = _arg_1.pkg.readUTF();
            this._currentPVE_ID = _arg_1.pkg.readInt();
            _arg_1.pkg.readUTF();
            this.addSocketEvent();
            this._bossInfo.name = _arg_1.pkg.readUTF();
            this._bossInfo.total_Blood = _arg_1.pkg.readLong();
            this._bossInfo.current_Blood = _arg_1.pkg.readLong();
            var _local_2:int = _arg_1.pkg.readInt();
            var _local_3:int = _arg_1.pkg.readInt();
            this.mapPath = (this.getWorldbossResource() + "/map/worldbossMap.swf");
            this._appearPos.length = 0;
            var _local_4:int = _arg_1.pkg.readInt();
            var _local_5:int;
            while (_local_5 < _local_4)
            {
                this._appearPos.push(new Point(_arg_1.pkg.readInt(), _arg_1.pkg.readInt()));
                _local_5++;
            };
            this._bossInfo.playerDefaultPos = Helpers.randomPick(this._appearPos);
            this._bossInfo.begin_time = _arg_1.pkg.readDate();
            this._bossInfo.end_time = _arg_1.pkg.readDate();
            this._bossInfo.fight_time = _arg_1.pkg.readInt();
            this._bossInfo.fightOver = _arg_1.pkg.readBoolean();
            this._bossInfo.roomClose = _arg_1.pkg.readBoolean();
            this._bossInfo.ticketID = _arg_1.pkg.readInt();
            this._bossInfo.need_ticket_count = _arg_1.pkg.readInt();
            this._bossInfo.timeCD = _arg_1.pkg.readInt();
            this._bossInfo.reviveMoney = _arg_1.pkg.readInt();
            this._bossInfo.reFightMoney = _arg_1.pkg.readInt();
            this._bossInfo.addInjureBuffMoney = _arg_1.pkg.readInt();
            this._bossInfo.addInjureValue = _arg_1.pkg.readInt();
            this._bossInfo.buffArray.length = 0;
            var _local_6:int = _arg_1.pkg.readInt();
            var _local_7:int;
            while (_local_7 < _local_6)
            {
                _local_8 = new WorldBossBuffInfo();
                _local_8.ID = _arg_1.pkg.readInt();
                _local_8.name = _arg_1.pkg.readUTF();
                _local_8.price = _arg_1.pkg.readInt();
                _local_8.decription = _arg_1.pkg.readUTF();
                _local_8.costID = _arg_1.pkg.readInt();
                this._bossInfo.buffArray.push(_local_8);
                _local_7++;
            };
            this._isShowBlood = _arg_1.pkg.readBoolean();
            this._autoBlood = _arg_1.pkg.readBoolean();
            if (this._entranceBtn)
            {
                ObjectUtils.disposeObject(this._entranceBtn);
                this._entranceBtn = null;
            };
            this.isOpen = (!(this._bossInfo.fightOver));
            this._bossInfo.myPlayerVO = new PlayerVO();
            WorldBossManager.Instance.isLoadingState = false;
            dispatchEvent(new WorldBossRoomEvent(WorldBossRoomEvent.GAME_INIT));
        }

        private function addSocketEvent():void
        {
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.WORLDBOSS_ENTER, this.__enter);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.WORLDBOSS_BLOOD_UPDATE, this.__update);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.WORLDBOSS_FIGHTOVER, this.__fightOver);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.WORLDBOSS_ROOMCLOSE, this.__leaveRoom);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.WORLDBOSS_RANKING, this.__showRanking);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.WORLDBOSS_OVER, this.__allOver);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_ROOM_FULL, this.__gameRoomFull);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.UPDATE_BUFF_LEVEL, this.__updateBuffLevel);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.WORLDBOSS_PRIVATE_INFO, this.__updatePrivateInfo);
        }

        private function removeSocketEvent():void
        {
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.WORLDBOSS_ENTER, this.__enter);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.WORLDBOSS_BLOOD_UPDATE, this.__update);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.WORLDBOSS_FIGHTOVER, this.__fightOver);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.WORLDBOSS_ROOMCLOSE, this.__leaveRoom);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.WORLDBOSS_RANKING, this.__showRanking);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.WORLDBOSS_OVER, this.__allOver);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.GAME_ROOM_FULL, this.__gameRoomFull);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.UPDATE_BUFF_LEVEL, this.__updateBuffLevel);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.WORLDBOSS_PRIVATE_INFO, this.__updatePrivateInfo);
        }

        protected function __updatePrivateInfo(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:PackageIn = _arg_1.pkg;
            WorldBossManager.Instance.bossInfo.myPlayerVO.myDamage = _local_2.readInt();
            WorldBossManager.Instance.bossInfo.myPlayerVO.myHonor = _local_2.readInt();
            dispatchEvent(new Event(Event.CHANGE));
        }

        protected function __updateBuffLevel(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:PackageIn = _arg_1.pkg;
            WorldBossManager.Instance.bossInfo.myPlayerVO.buffLevel = _local_2.readInt();
            WorldBossManager.Instance.bossInfo.myPlayerVO.buffInjure = _local_2.readInt();
            dispatchEvent(new Event(Event.CHANGE));
        }

        private function __gameRoomFull(_arg_1:CrazyTankSocketEvent):void
        {
            dispatchEvent(new WorldBossRoomEvent(WorldBossRoomEvent.WORLDBOSS_ROOM_FULL));
        }

        private function __enter(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:int;
            var _local_3:int;
            if (((_arg_1.pkg.bytesAvailable > 0) && (_arg_1.pkg.readBoolean())))
            {
                this._bossInfo.isLiving = (!(_arg_1.pkg.readBoolean()));
                this._bossInfo.myPlayerVO.reviveCD = _arg_1.pkg.readInt();
                _local_2 = _arg_1.pkg.readInt();
                _local_3 = 0;
                while (_local_3 < _local_2)
                {
                    this._bossInfo.myPlayerVO.buffID = _arg_1.pkg.readInt();
                    _local_3++;
                };
                if (this._bossInfo.myPlayerVO.reviveCD > 0)
                {
                    this._bossInfo.myPlayerVO.playerStauts = 3;
                    this._bossInfo.myPlayerVO.playerPos = new Point(int(((Math.random() * 300) + 300)), (int((Math.random() * 850)) + 250));
                }
                else
                {
                    this._bossInfo.myPlayerVO.playerPos = this._bossInfo.playerDefaultPos;
                    this._bossInfo.myPlayerVO.playerStauts = 1;
                };
                dispatchEvent(new WorldBossRoomEvent(WorldBossRoomEvent.ALLOW_ENTER));
                this.loadMap();
            };
        }

        private function loadMap():void
        {
            this._mapLoader = LoadResourceManager.instance.createLoader(WorldBossManager.Instance.mapPath, BaseLoader.MODULE_LOADER);
            this._mapLoader.addEventListener(LoaderEvent.COMPLETE, this.onMapSrcLoadedComplete);
            LoadResourceManager.instance.startLoad(this._mapLoader);
        }

        private function onMapSrcLoadedComplete(_arg_1:Event):void
        {
            if (StateManager.getState(StateType.WORLDBOSS_ROOM) == null)
            {
                UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE, this.__loadingIsCloseRoom);
            };
            StateManager.setState(StateType.WORLDBOSS_ROOM);
        }

        private function __loadingIsCloseRoom(_arg_1:Event):void
        {
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE, this.__loadingIsCloseRoom);
        }

        private function __update(_arg_1:CrazyTankSocketEvent):void
        {
            this._autoBlood = _arg_1.pkg.readBoolean();
            this._bossInfo.total_Blood = _arg_1.pkg.readLong();
            this._bossInfo.current_Blood = _arg_1.pkg.readLong();
            dispatchEvent(new WorldBossRoomEvent(WorldBossRoomEvent.BOSS_HP_UPDATA));
        }

        private function __fightOver(_arg_1:CrazyTankSocketEvent):void
        {
            this._bossInfo.fightOver = true;
            this.isOpen = false;
            this._bossInfo.isLiving = (!(_arg_1.pkg.readBoolean()));
            dispatchEvent(new WorldBossRoomEvent(WorldBossRoomEvent.FIGHT_OVER));
        }

        private function __leaveRoom(_arg_1:Event):void
        {
            this._bossInfo.roomClose = true;
            if (StateManager.currentStateType == StateType.WORLDBOSS_ROOM)
            {
                if ((((StateManager.currentStateType == StateType.WORLDBOSS_AWARD) || (StateManager.currentStateType == StateType.WORLDBOSS_ROOM)) && (!(this.isOpen))))
                {
                    StateManager.setState(StateType.MAIN);
                };
                WorldBossRoomController.Instance.dispose();
            };
            dispatchEvent(new WorldBossRoomEvent(WorldBossRoomEvent.ROOM_CLOSE));
        }

        private function __showRanking(_arg_1:CrazyTankSocketEvent):void
        {
            if (_arg_1.pkg.readBoolean())
            {
                this.showRankingFrame(_arg_1.pkg);
            }
            else
            {
                this.showRankingInRoom(_arg_1.pkg);
            };
        }

        private function showRankingFrame(_arg_1:PackageIn):void
        {
            var _local_5:RankingPersonInfo;
            this._rankingInfos.length = 0;
            WorldBossRankingFram._rankingPersons = new Array();
            var _local_2:WorldBossRankingFram = ComponentFactory.Instance.creat("worldboss.ranking.frame");
            var _local_3:int = _arg_1.readInt();
            var _local_4:int;
            while (_local_4 < _local_3)
            {
                _local_5 = new RankingPersonInfo();
                _local_5.id = _arg_1.readInt();
                _local_5.name = _arg_1.readUTF();
                _local_5.damage = _arg_1.readInt();
                _local_2.addPersonRanking(_local_5);
                this._rankingInfos.push(_local_5);
                _local_4++;
            };
            if (!((CacheSysManager.isLock(CacheConsts.ALERT_IN_FIGHT)) && (!(StateManager.currentStateType == StateType.WORLDBOSS_ROOM))))
            {
                _local_2.show();
            };
        }

        private function showRankingInRoom(_arg_1:PackageIn):void
        {
            dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.WORLDBOSS_RANKING_INROOM, _arg_1));
        }

        private function __allOver(_arg_1:CrazyTankSocketEvent):void
        {
            this._bossInfo.fightOver = true;
            this._bossInfo.roomClose = true;
            dispatchEvent(new WorldBossRoomEvent(WorldBossRoomEvent.WORLDBOSS_OVER));
        }

        public function enterGame():void
        {
            SocketManager.Instance.out.enterUserGuide(WorldBossManager.Instance.currentPVE_ID, 14);
            if ((!(WorldBossManager.Instance.bossInfo.fightOver)))
            {
                IsSuccessStartGame = true;
                GameInSocketOut.sendGameStart();
                SocketManager.Instance.out.sendWorldBossRoomStauts(2);
                dispatchEvent(new Event(WorldBossRoomEvent.ENTERING_GAME));
            }
            else
            {
                StateManager.setState(StateType.WORLDBOSS_ROOM);
            };
        }

        public function exitGame():void
        {
            IsSuccessStartGame = false;
            GameInSocketOut.sendGamePlayerExit();
        }

        private function showEntranceBtn():void
        {
            if ((!(this._entranceBtn)))
            {
                this.iconEnterPath = (this.getWorldbossResource() + "/icon/worldbossIcon.swf");
                this._bossInfo.myPlayerVO = new PlayerVO();
            };
            this._ishallComplete = true;
            if (this._entranceBtn.parent)
            {
                return;
            };
            LayerManager.Instance.addToLayer(this._entranceBtn, LayerManager.GAME_DYNAMIC_LAYER, false, 0, false);
            this._entranceBtn.parent.setChildIndex(this._entranceBtn, 0);
            this._entranceBtn.buttonMode = true;
            this.isOpen = this.isOpen;
        }

        private function addshowHallEntranceBtn():void
        {
            if (((this._ishallComplete) && (StateManager.currentStateType == StateType.MAIN)))
            {
                this.showEntranceBtn();
            };
        }

        public function set isOpen(_arg_1:Boolean):void
        {
            this._isOpen = _arg_1;
            if (this.sky)
            {
                this.sky.visible = false;
            };
            if (this._entranceBtn)
            {
                if (_arg_1)
                {
                    this._entranceBtn.setFrame(1);
                }
                else
                {
                    this._entranceBtn.setFrame(2);
                };
            };
        }

        public function buyBuff():Boolean
        {
            var _local_5:WorldBossBuffInfo;
            var _local_6:WorldBossBuffInfo;
            var _local_7:WorldBossBuffInfo;
            var _local_1:int;
            var _local_2:Boolean;
            var _local_3:Number = PlayerManager.Instance.Self.Money;
            var _local_4:Array = new Array();
            for each (_local_5 in this._autoBuyBuffs.list)
            {
                _local_1 = (_local_1 + _local_5.price);
            };
            _local_2 = (PlayerManager.Instance.Self.Money >= _local_1);
            if ((!(_local_2)))
            {
                for each (_local_6 in this._bossInfo.buffArray)
                {
                    if (((!(this._autoBuyBuffs[_local_6.ID])) && (_local_3 >= _local_6.price)))
                    {
                        _local_4.push(_local_6.ID);
                        _local_3 = (_local_3 - _local_6.price);
                        if (_local_3 == 0) break;
                    };
                };
            }
            else
            {
                for each (_local_7 in this._autoBuyBuffs.list)
                {
                    _local_4.push(_local_7.ID);
                };
            };
            SocketManager.Instance.out.sendBuyWorldBossBuff(_local_4);
            return (_local_2);
        }

        public function get isOpen():Boolean
        {
            return (this._isOpen);
        }

        public function get currentPVE_ID():int
        {
            return (this._currentPVE_ID);
        }

        public function get bossInfo():WorldBossInfo
        {
            return (this._bossInfo);
        }

        public function getWorldbossResource():String
        {
            return ((PathManager.SITE_MAIN + "image/worldboss/") + this._bossResourceId);
        }

        public function showRankingText():void
        {
            var _local_3:RankingPersonInfo;
            WorldBossRankingFram._rankingPersons = new Array();
            var _local_1:WorldBossRankingFram = ComponentFactory.Instance.creat("worldboss.ranking.frame");
            var _local_2:int;
            while (_local_2 < 10)
            {
                _local_3 = new RankingPersonInfo();
                _local_3.id = 1;
                _local_3.name = ("hawang" + _local_2);
                _local_3.damage = (((2 * _local_2) + (_local_2 * _local_2)) + 50);
                _local_1.addPersonRanking(_local_3);
                _local_2++;
            };
            _local_1.show();
        }

        public function buyNewBuff():void
        {
            if (this.bossInfo.myPlayerVO.buffLevel >= 20)
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.worldboss.buffLevelMax"));
                return;
            };
            var _local_1:int = WorldBossManager.Instance.bossInfo.addInjureBuffMoney;
            if (PlayerManager.Instance.Self.totalMoney < _local_1)
            {
                LeavePageManager.showFillFrame();
                return;
            };
            if (PlayerManager.Instance.Self.bagLocked)
            {
                BaglockedManager.Instance.show();
                return;
            };
            SocketManager.Instance.out.sendNewBuyWorldBossBuff();
        }

        public function set isLoadingState(_arg_1:Boolean):void
        {
            this._isLoadingState = _arg_1;
        }

        public function get isLoadingState():Boolean
        {
            return (this._isLoadingState);
        }

        public function showWorldBossAward(_arg_1:Function, _arg_2:String):void
        {
            if (UIModuleLoader.Instance.checkIsLoaded(_arg_2))
            {
                if (_arg_1 != null)
                {
                    (_arg_1());
                };
            }
            else
            {
                this._loadingModuleType = _arg_2;
                this._loadedCallBack = _arg_1;
                UIModuleSmallLoading.Instance.progress = 0;
                UIModuleSmallLoading.Instance.show();
                UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE, this.__onClose);
                UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__worldBossAwardComplete);
                UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS, this.__worldBossAwardProgress);
                UIModuleLoader.Instance.addUIModuleImp(_arg_2);
            };
        }

        private function __onClose(_arg_1:Event):void
        {
            this._loadedCallBack = null;
            UIModuleSmallLoading.Instance.hide();
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE, this.__onClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__worldBossAwardComplete);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS, this.__worldBossAwardProgress);
        }

        private function __worldBossAwardComplete(_arg_1:UIModuleEvent):void
        {
            UIModuleSmallLoading.Instance.hide();
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE, this.__onClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__worldBossAwardComplete);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS, this.__worldBossAwardProgress);
            this.showWorldBossAward(this._loadedCallBack, this._loadingModuleType);
        }

        private function __worldBossAwardProgress(_arg_1:UIModuleEvent):void
        {
            if (_arg_1.module == this._loadingModuleType)
            {
                UIModuleSmallLoading.Instance.progress = (_arg_1.loader.progress * 100);
            };
        }


    }
}//package worldboss

