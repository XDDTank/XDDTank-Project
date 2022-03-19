// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//consortion.consortionsence.ConsortionManager

package consortion.consortionsence
{
    import flash.geom.Point;
    import __AS3__.vec.Vector;
    import ddt.manager.SocketManager;
    import ddt.events.CrazyTankSocketEvent;
    import consortion.data.MonsterInfo;
    import SingleDungeon.model.WalkMapObject;
    import com.pickgliss.loader.QueueLoader;
    import road7th.comm.PackageIn;
    import consortion.managers.ConsortionMonsterManager;
    import SingleDungeon.SingleDungeonManager;
    import com.pickgliss.loader.LoadResourceManager;
    import ddt.manager.PathManager;
    import com.pickgliss.loader.BaseLoader;
    import flash.events.Event;
    import consortion.view.monsterReflash.ConsortionMonsterRankFrame;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.StateManager;
    import com.pickgliss.manager.CacheSysManager;
    import ddt.constants.CacheConsts;
    import com.pickgliss.action.FunctionAction;
    import ddt.manager.MessageTipManager;
    import ddt.manager.LanguageMgr;
    import ddt.manager.ChatManager;
    import ddt.states.StateType;
    import ddt.data.player.PlayerInfo;
    import ddt.manager.PlayerManager;
    import ddt.view.UIModuleSmallLoading;
    import com.pickgliss.loader.UIModuleLoader;
    import com.pickgliss.events.UIModuleEvent;
    import ddt.data.UIModuleTypes;
    import com.pickgliss.loader.LoaderEvent;
    import __AS3__.vec.*;

    public class ConsortionManager 
    {

        private static var _instance:ConsortionManager;

        public var _consortionWalkMode:ConsortionWalkMapModel;
        private var _monsterAllCount:int = 0;
        public var SelfPoint:Point;
        private var _loadedCallBack:Function;
        private var _loadingModuleType:Vector.<String> = new Vector.<String>();
        private var completeedUIModule:Vector.<String> = new Vector.<String>();
        private var isComplete:Boolean = false;
        private var _buyType:int = 10;


        public static function get Instance():ConsortionManager
        {
            if ((!(ConsortionManager._instance)))
            {
                ConsortionManager._instance = new (ConsortionManager)();
            };
            return (ConsortionManager._instance);
        }


        public function setup():void
        {
            this._consortionWalkMode = new ConsortionWalkMapModel();
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ENTER_CONSORTION, this.__init);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTION_ADDMONSTER, this.__onAddMonster);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTION_REMOVEALLMONSTER, this.__removeAllMonster);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTION_MONSTER_STATE, this.__syncMonsterState);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ACTIVE_STATE, this.__MonsterActiveState);
        }

        private function __onAddMonster(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_5:MonsterInfo;
            var _local_6:int;
            var _local_7:WalkMapObject;
            var _local_2:QueueLoader = new QueueLoader();
            var _local_3:PackageIn = _arg_1.pkg;
            this._monsterAllCount = _local_3.readInt();
            ConsortionMonsterManager.Instance.currentTimes = _local_3.readInt();
            var _local_4:int;
            while (_local_4 < this._monsterAllCount)
            {
                _local_5 = new MonsterInfo();
                _local_6 = _local_3.readInt();
                _local_5.ID = _local_3.readInt();
                _local_7 = SingleDungeonManager.Instance.getObjectByID(_local_6);
                _local_5.MonsterName = _local_7.Name;
                _local_5.MissionID = _local_7.SceneID;
                _local_5.ActionMovieName = ("game.living." + _local_7.Path);
                _local_5.State = _local_3.readInt();
                _local_5.MonsterPos = new Point(_local_3.readInt(), _local_3.readInt());
                if (_local_5.State != MonsterInfo.DEAD)
                {
                    _local_2.addLoader(LoadResourceManager.instance.createLoader(PathManager.solveConsortionMonsterPath(_local_7.Path), BaseLoader.MODULE_LOADER));
                    this._consortionWalkMode._mapObjects.add(_local_5.ID, _local_5);
                };
                _local_4++;
            };
            _local_2.addEventListener(Event.COMPLETE, this.__onLoadComplete);
            _local_2.start();
        }

        private function __onLoadComplete(_arg_1:Event):void
        {
            var _local_2:QueueLoader = (_arg_1.currentTarget as QueueLoader);
            if (_local_2.completeCount == this._monsterAllCount)
            {
                _local_2.removeEvent();
            };
        }

        private function __syncMonsterState(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:PackageIn = _arg_1.pkg;
            var _local_3:int = _local_2.readInt();
            var _local_4:int = _local_2.readInt();
            var _local_5:int = _local_2.readInt();
            if (((this._consortionWalkMode._mapObjects) && (this._consortionWalkMode._mapObjects.hasKey(_local_4))))
            {
                this._consortionWalkMode._mapObjects[_local_4].State = _local_5;
            };
        }

        private function __removeAllMonster(pEvent:CrazyTankSocketEvent):void
        {
            var o:MonsterInfo;
            var rankArr:Array;
            var rankFrame:ConsortionMonsterRankFrame;
            var i:int;
            for each (o in this._consortionWalkMode._mapObjects)
            {
                this._consortionWalkMode._mapObjects.remove(o.ID);
            };
            this._consortionWalkMode._mapObjects.clear();
            rankArr = ConsortionMonsterManager.Instance.RankArray;
            if (((rankArr) && (rankArr.length > 0)))
            {
                rankFrame = ComponentFactory.Instance.creat("consortion.ranking.frame");
                i = 0;
                while (i < rankArr.length)
                {
                    rankFrame.addPersonRanking(rankArr[i]);
                    i = (i + 1);
                };
                if ((!(StateManager.isInFight)))
                {
                    rankFrame.show();
                }
                else
                {
                    CacheSysManager.getInstance().cacheFunction(CacheConsts.ALERT_IN_FIGHT, new FunctionAction(function ():void
                    {
                        rankFrame.show();
                    }));
                };
            };
            ConsortionMonsterManager.Instance.ActiveState = false;
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("consortion.monster.activeStopped"));
            ChatManager.Instance.sysChatYellow(LanguageMgr.GetTranslation("consortion.monster.activeStopped"));
        }

        private function __MonsterActiveState(_arg_1:CrazyTankSocketEvent):void
        {
            ConsortionMonsterManager.Instance.ActiveState = true;
            ConsortionMonsterManager.Instance.currentRank = null;
            ConsortionMonsterManager.Instance.currentSelfInfo = null;
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("consortion.monster.activeStart"));
            ChatManager.Instance.sysChatYellow(LanguageMgr.GetTranslation("consortion.monster.activeStart"));
            if (((ConsortionMonsterManager.Instance.ActiveState) && (StateManager.currentStateType == StateType.CONSORTIA)))
            {
                SocketManager.Instance.out.sendAddMonsterRequest();
            };
        }

        private function __init(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_5:PlayerInfo;
            var _local_6:int;
            var _local_7:int;
            var _local_8:ConsortionWalkPlayerInfo;
            var _local_2:PackageIn = (_arg_1.pkg as PackageIn);
            var _local_3:int = _local_2.readInt();
            var _local_4:int;
            while (_local_4 < _local_3)
            {
                _local_5 = new PlayerInfo();
                _local_5.beginChanges();
                _local_5.Grade = _local_2.readInt();
                _local_5.Hide = _local_2.readInt();
                _local_5.Repute = _local_2.readInt();
                _local_5.ID = _local_2.readInt();
                _local_5.NickName = _local_2.readUTF();
                _local_5.VIPtype = _local_2.readByte();
                _local_5.VIPLevel = _local_2.readInt();
                _local_5.Sex = _local_2.readBoolean();
                _local_5.Style = _local_2.readUTF();
                _local_5.Colors = _local_2.readUTF();
                _local_5.Skin = _local_2.readUTF();
                _local_6 = _local_2.readInt();
                _local_7 = _local_2.readInt();
                _local_5.FightPower = _local_2.readInt();
                _local_5.WinCount = _local_2.readInt();
                _local_5.TotalCount = _local_2.readInt();
                _local_5.Offer = _local_2.readInt();
                _local_5.commitChanges();
                _local_8 = new ConsortionWalkPlayerInfo();
                _local_8.playerInfo = _local_5;
                _local_8.playerPos = new Point(_local_6, _local_7);
                if (_local_5.ID != PlayerManager.Instance.Self.ID)
                {
                    this._consortionWalkMode.addPlayer(_local_8);
                }
                else
                {
                    this.SelfPoint = new Point(_local_6, _local_7);
                };
                _local_4++;
            };
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE, this.__onLoadingClose);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__onChatBallComplete);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.CHAT_BALL);
        }

        private function __onLoadingClose(_arg_1:Event=null):void
        {
            UIModuleSmallLoading.Instance.hide();
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE, this.__onLoadingClose);
        }

        private function __onChatBallComplete(_arg_1:UIModuleEvent):void
        {
            if (_arg_1.module == UIModuleTypes.CHAT_BALL)
            {
                UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__onChatBallComplete);
                this.loadResFile(this.loadResComplete, PathManager.solveConsortionWalkSceneMapPath("map5"));
            };
        }

        private function loadResFile(_arg_1:Function, _arg_2:String):void
        {
            var _local_3:BaseLoader;
            _local_3 = LoadResourceManager.instance.createLoader(_arg_2, BaseLoader.MODULE_LOADER);
            _local_3.addEventListener(LoaderEvent.COMPLETE, _arg_1);
            _local_3.addEventListener(LoaderEvent.PROGRESS, this.__uiProgress);
            LoadResourceManager.instance.startLoad(_local_3);
        }

        private function __uiProgress(_arg_1:LoaderEvent):void
        {
            UIModuleSmallLoading.Instance.progress = (_arg_1.loader.progress * 100);
        }

        private function loadResComplete(_arg_1:LoaderEvent):void
        {
            this.__onLoadingClose();
            StateManager.setState(StateType.CONSORTIA);
        }

        public function showClubFrame(_arg_1:Function, _arg_2:String):void
        {
            var _local_3:Array;
            var _local_4:int;
            var _local_5:int;
            if (this.isComplete)
            {
                if (_arg_1 != null)
                {
                    (_arg_1());
                };
            }
            else
            {
                _local_3 = _arg_2.split(",");
                _local_4 = 0;
                while (_local_4 < _local_3.length)
                {
                    this._loadingModuleType.push(_local_3[_local_4]);
                    _local_4++;
                };
                this._loadedCallBack = _arg_1;
                UIModuleSmallLoading.Instance.progress = 0;
                UIModuleSmallLoading.Instance.show();
                UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE, this.__onClose);
                UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__loadComplete);
                UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS, this.__loadProgress);
                _local_5 = 0;
                while (_local_5 < this._loadingModuleType.length)
                {
                    UIModuleLoader.Instance.addUIModuleImp(this._loadingModuleType[_local_5]);
                    _local_5++;
                };
            };
        }

        private function __onClose(_arg_1:Event):void
        {
            this._loadedCallBack = null;
            UIModuleSmallLoading.Instance.hide();
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE, this.__onClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__loadComplete);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS, this.__loadProgress);
        }

        private function __loadComplete(_arg_1:UIModuleEvent):void
        {
            if (this.completeedUIModule.indexOf(_arg_1.module) == -1)
            {
                this.completeedUIModule.push(_arg_1.module);
            };
            var _local_2:Boolean = true;
            var _local_3:int;
            while (_local_3 < this._loadingModuleType.length)
            {
                if (this.completeedUIModule.indexOf(this._loadingModuleType[_local_3]) == -1)
                {
                    _local_2 = false;
                };
                _local_3++;
            };
            this.isComplete = _local_2;
            if (this.isComplete)
            {
                UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE, this.__onClose);
                UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__loadComplete);
                UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS, this.__loadProgress);
                UIModuleSmallLoading.Instance.hide();
                this.showClubFrame(this._loadedCallBack, ((UIModuleTypes.CONSORTIAII + ",") + UIModuleTypes.DDTCONSORTIA));
            };
        }

        public function set buyType(_arg_1:int):void
        {
            this._buyType = _arg_1;
        }

        public function get buyType():int
        {
            return (this._buyType);
        }

        private function __loadProgress(_arg_1:UIModuleEvent):void
        {
            if (this._loadingModuleType.indexOf(_arg_1.module) != -1)
            {
                UIModuleSmallLoading.Instance.progress = (_arg_1.loader.progress * 100);
            };
        }

        public function isSameConsortion(_arg_1:PlayerInfo, _arg_2:PlayerInfo):Boolean
        {
            if (((_arg_1 == null) || (_arg_2 == null)))
            {
                return (false);
            };
            if (_arg_1.ConsortiaID == _arg_2.ConsortiaID)
            {
                return (true);
            };
            return (false);
        }


    }
}//package consortion.consortionsence

