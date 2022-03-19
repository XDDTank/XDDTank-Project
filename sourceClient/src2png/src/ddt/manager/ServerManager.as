// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.manager.ServerManager

package ddt.manager
{
    import flash.events.EventDispatcher;
    import __AS3__.vec.Vector;
    import ddt.data.ServerInfo;
    import flash.utils.Timer;
    import ddt.events.CrazyTankSocketEvent;
    import road7th.comm.PackageIn;
    import platformapi.tencent.DiamondManager;
    import platformapi.tencent.TencentPlatformData;
    import ddt.data.player.SelfInfo;
    import flash.events.Event;
    import ddt.data.analyze.ServerListAnalyzer;
    import ddt.data.player.PlayerInfo;
    import ddt.DDT;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import com.pickgliss.ui.AlertManager;
    import ddt.states.StateType;
    import com.pickgliss.events.FrameEvent;
    import arena.model.ArenaScenePlayerInfo;
    import flash.utils.setTimeout;
    import consortion.ConosrtionTimerManager;
    import arena.ArenaManager;
    import totem.TotemManager;
    import ddt.view.MainToolBar;
    import ddt.loader.StartupResourceLoader;
    import ddt.events.DuowanInterfaceEvent;
    import baglocked.BagLockedController;

    [Event(name="change", type="flash.events.Event")]
    public class ServerManager extends EventDispatcher 
    {

        public static const CHANGE_SERVER:String = "changeServer";
        public static var AUTO_UNLOCK:Boolean = false;
        public static var GAME_BEGIN:String = "game_begin";
        private static const CONNENT_TIME_OUT:int = 30000;
        private static var _instance:ServerManager;

        private var _list:Vector.<ServerInfo>;
        private var _current:ServerInfo;
        private var _zoneName:String;
        private var _agentid:int;
        private var _connentTimer:Timer;

        public function ServerManager():void
        {
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LOGIN, this.__onLoginComplete);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PFINFO, this.__onpfInfoComplete);
        }

        public static function get Instance():ServerManager
        {
            if (_instance == null)
            {
                _instance = new (ServerManager)();
            };
            return (_instance);
        }


        protected function __onpfInfoComplete(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:PackageIn = _arg_1.pkg;
            var _local_3:TencentPlatformData = DiamondManager.instance.model.pfdata;
            var _local_4:SelfInfo = PlayerManager.Instance.Self;
            _local_3.openID = _local_2.readUTF();
            _local_3.openKey = _local_2.readUTF();
            _local_3.pf = _local_2.readUTF();
            _local_3.pfKey = _local_2.readUTF();
            DiamondManager.instance.model.update();
            _local_4.beginChanges();
            _local_4.isYellowVip = _local_2.readBoolean();
            _local_4.MemberDiamondLevel = _local_2.readByte();
            _local_4.Level3366 = _local_2.readByte();
            _local_4.canTakeVIPPack = _local_2.readBoolean();
            _local_4.canTakeVIPYearPack = _local_2.readBoolean();
            _local_4.canTakeLevel3366Pack = _local_2.readBoolean();
            _local_4.isYearVip = _local_2.readBoolean();
            _local_4.isGetNewHandPack = _local_2.readBoolean();
            ExternalInterfaceManager.traceToBrowser(((((((("openID=" + _local_3.openID) + ",openKey=") + _local_3.openKey) + ",pf=") + _local_3.pf) + ",pfkey=") + _local_3.pfKey));
            ExternalInterfaceManager.traceToBrowser(((((((((((((("isYellowVip=" + _local_4.isYellowVip) + ",MemberDiamondLevel=") + _local_4.MemberDiamondLevel) + ",Level3366=") + _local_4.Level3366) + ",canTakeVIPPack=") + _local_4.canTakeVIPPack) + ",canTakeVIPYearPack=") + _local_4.canTakeVIPYearPack) + ",canTakeLevel3366Pack=") + _local_4.canTakeLevel3366Pack) + ",isGetNewHandPack=") + _local_4.isGetNewHandPack));
            _local_4.commitChanges();
        }

        public function get zoneName():String
        {
            return (this._zoneName);
        }

        public function set zoneName(_arg_1:String):void
        {
            this._zoneName = _arg_1;
            dispatchEvent(new Event(Event.CHANGE));
        }

        public function get AgentID():int
        {
            return (this._agentid);
        }

        public function set AgentID(_arg_1:int):void
        {
            this._agentid = _arg_1;
        }

        public function set current(_arg_1:ServerInfo):void
        {
            this._current = _arg_1;
        }

        public function get current():ServerInfo
        {
            return (this._current);
        }

        public function get list():Vector.<ServerInfo>
        {
            return (this._list);
        }

        public function set list(_arg_1:Vector.<ServerInfo>):void
        {
            this._list = _arg_1;
            dispatchEvent(new Event(Event.CHANGE));
        }

        public function setup(_arg_1:ServerListAnalyzer):void
        {
            this._list = _arg_1.list;
            this._agentid = _arg_1.agentId;
            this._zoneName = _arg_1.zoneName;
        }

        public function canAutoLogin():Boolean
        {
            this.searchAvailableServer();
            return (!(this._current == null));
        }

        public function connentCurrentServer():void
        {
            SocketManager.Instance.isLogin = false;
            SocketManager.Instance.connect(this._current.IP, this._current.Port);
        }

        private function searchAvailableServer():void
        {
            var _local_1:PlayerInfo = PlayerManager.Instance.Self;
            if (DDT.SERVER_ID != -1)
            {
                this._current = this._list[DDT.SERVER_ID];
                return;
            };
            this._current = this.searchServerByState(ServerInfo.UNIMPEDED);
            if (this._current == null)
            {
                this._current = this.searchServerByState(ServerInfo.HALF);
            };
            if (this._current == null)
            {
                this._current = this._list[0];
            };
        }

        private function searchServerByState(_arg_1:int):ServerInfo
        {
            var _local_2:int;
            while (_local_2 < this._list.length)
            {
                if (this._list[_local_2].State == _arg_1)
                {
                    return (this._list[_local_2]);
                };
                _local_2++;
            };
            return (null);
        }

        public function connentServer(_arg_1:ServerInfo):Boolean
        {
            var _local_2:BaseAlerFrame;
            if (_arg_1 == null)
            {
                _local_2 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("tank.serverlist.ServerListPosView.choose"));
                this.alertControl(_local_2);
                return (false);
            };
            if (_arg_1.MustLevel < PlayerManager.Instance.Self.Grade)
            {
                _local_2 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("tank.serverlist.ServerListPosView.your"));
                this.alertControl(_local_2);
                return (false);
            };
            if (_arg_1.LowestLevel > PlayerManager.Instance.Self.Grade)
            {
                _local_2 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("tank.serverlist.ServerListPosView.low"));
                this.alertControl(_local_2);
                return (false);
            };
            if ((((SocketManager.Instance.socket.connected) && (SocketManager.Instance.socket.isSame(_arg_1.IP, _arg_1.Port))) && (SocketManager.Instance.isLogin)))
            {
                StateManager.setState(StateType.MAIN);
                return (false);
            };
            if (_arg_1.State == ServerInfo.ALL_FULL)
            {
                _local_2 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("tank.serverlist.ServerListPosView.full"));
                this.alertControl(_local_2);
                return (false);
            };
            if (_arg_1.State == ServerInfo.MAINTAIN)
            {
                _local_2 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("tank.serverlist.ServerListPosView.maintenance"));
                this.alertControl(_local_2);
                return (false);
            };
            this._current = _arg_1;
            this.connentCurrentServer();
            dispatchEvent(new Event(CHANGE_SERVER));
            return (true);
        }

        private function alertControl(_arg_1:BaseAlerFrame):void
        {
            _arg_1.addEventListener(FrameEvent.RESPONSE, this.__alertResponse);
        }

        private function __alertResponse(_arg_1:FrameEvent):void
        {
            var _local_2:BaseAlerFrame = (_arg_1.currentTarget as BaseAlerFrame);
            _local_2.removeEventListener(FrameEvent.RESPONSE, this.__alertResponse);
            _local_2.dispose();
        }

        private function __onLoginComplete(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_4:String;
            var _local_5:Array;
            var _local_6:Boolean;
            var _local_7:Boolean;
            var _local_8:String;
            var _local_9:Array;
            var _local_10:int;
            var _local_11:int;
            var _local_12:ArenaScenePlayerInfo;
            var _local_13:BaseAlerFrame;
            var _local_2:PackageIn = _arg_1.pkg;
            var _local_3:SelfInfo = PlayerManager.Instance.Self;
            if (_local_2.readByte() == 0)
            {
                _local_3.beginChanges();
                SocketManager.Instance.isLogin = true;
                _local_3.ZoneID = _local_2.readInt();
                _local_3.Attack = _local_2.readInt();
                _local_3.Defence = _local_2.readInt();
                _local_3.Agility = _local_2.readInt();
                _local_3.Luck = _local_2.readInt();
                _local_3.Stormdamage = _local_2.readInt();
                _local_3.Crit = _local_2.readInt();
                _local_3.Uprisinginjury = _local_2.readInt();
                _local_3.Uprisingstrike = _local_2.readInt();
                _local_3.GP = _local_2.readInt();
                _local_3.Repute = _local_2.readInt();
                _local_3.Gold = _local_2.readInt();
                _local_3.Money = _local_2.readInt();
                _local_3.DDTMoney = _local_2.readInt();
                _local_3.Hide = _local_2.readInt();
                _local_3.FightPower = _local_2.readInt();
                _local_3.apprenticeshipState = _local_2.readInt();
                _local_3.masterID = _local_2.readInt();
                _local_3.setMasterOrApprentices(_local_2.readUTF());
                _local_3.graduatesCount = _local_2.readInt();
                _local_3.honourOfMaster = _local_2.readUTF();
                _local_3.freezesDate = _local_2.readDate();
                _local_3.VIPtype = _local_2.readByte();
                _local_3.VIPLevel = _local_2.readInt();
                _local_3.VIPExp = _local_2.readInt();
                _local_3.VIPExpireDay = _local_2.readDate();
                _local_3.openVipType = _local_2.readBoolean();
                _local_3.LastDate = _local_2.readDate();
                _local_3.VIPNextLevelDaysNeeded = _local_2.readInt();
                _local_3.systemDate = _local_2.readDate();
                _local_3.isFightVip = _local_2.readBoolean();
                _local_3.fightToolBoxSkillNum = _local_2.readInt();
                _local_3.fightVipStartTime = _local_2.readDate();
                _local_3.fightVipValidDate = _local_2.readInt();
                _local_3.OptionOnOff = _local_2.readInt();
                _local_3.AchievementPoint = _local_2.readInt();
                _local_3.honor = _local_2.readUTF();
                TimeManager.Instance.enthrallTime = _local_2.readInt();
                _local_3.Sex = _local_2.readBoolean();
                _local_4 = _local_2.readUTF();
                _local_5 = _local_4.split("&");
                _local_3.Style = _local_5[0];
                _local_3.Colors = _local_5[1];
                _local_3.Skin = _local_2.readUTF();
                _local_3.ConsortiaID = _local_2.readInt();
                _local_3.ConsortiaName = _local_2.readUTF();
                _local_3.badgeID = _local_2.readInt();
                _local_3.DutyLevel = _local_2.readInt();
                _local_3.DutyName = _local_2.readUTF();
                _local_3.Right = _local_2.readInt();
                _local_3.consortiaInfo.ChairmanName = _local_2.readUTF();
                _local_3.consortiaInfo.Honor = _local_2.readInt();
                _local_3.consortiaInfo.Riches = _local_2.readInt();
                _local_6 = _local_2.readBoolean();
                _local_7 = ((_local_3.bagPwdState) && (!(_local_3.bagLocked)));
                _local_3.bagPwdState = _local_6;
                if (_local_7)
                {
                    setTimeout(this.releaseLock, 1000);
                };
                _local_3.bagLocked = _local_6;
                _local_3.questionOne = _local_2.readUTF();
                _local_3.questionTwo = _local_2.readUTF();
                _local_3.leftTimes = _local_2.readInt();
                _local_3.LoginName = _local_2.readUTF();
                TaskManager.instance.requestCanAcceptTask();
                _local_3.PvePermission = _local_2.readUTF();
                _local_3.fightLibMission = _local_2.readUTF();
                _local_3.userGuildProgress = _local_2.readInt();
                _local_3.UseOffer = _local_2.readInt();
                _local_3.beforeOffer = _local_2.readInt();
                _local_3.matchInfo.dailyScore = _local_2.readInt();
                _local_3.matchInfo.dailyWinCount = _local_2.readInt();
                _local_3.matchInfo.dailyGameCount = _local_2.readInt();
                _local_3.DailyLeagueFirst = _local_2.readBoolean();
                _local_3.DailyLeagueLastScore = _local_2.readInt();
                _local_3.matchInfo.weeklyScore = _local_2.readInt();
                _local_3.matchInfo.weeklyGameCount = _local_2.readInt();
                _local_3.matchInfo.weeklyRanking = _local_2.readInt();
                _local_3.bagCellUpdateIndex = _local_2.readInt();
                _local_3.bagCellUpdateTime = _local_2.readDate();
                _local_3.beadScore = _local_2.readInt();
                _local_3.beadGetStatus = _local_2.readInt();
                _local_3.fbDoneByString = _local_2.readUTF();
                _local_3.totemId = _local_2.readInt();
                _local_3.MilitaryRankScores = _local_2.readInt();
                _local_3.MilitaryRankTotalScores = _local_2.readInt();
                _local_3.FightCount = _local_2.readInt();
                _local_8 = _local_2.readUTF();
                _local_9 = _local_8.split(",");
                while (_local_10 < _local_9.length)
                {
                    _local_3.isLearnSkill.add(_local_10, _local_9[_local_10]);
                    _local_10++;
                };
                _local_11 = _local_2.readInt();
                TimeManager.Instance.totalGameTime = _local_11;
                EnthrallManager.getInstance().setup();
                ConosrtionTimerManager.Instance.startimer((3600 - (_local_11 * 60)));
                _local_12 = ArenaManager.instance.model.selfInfo;
                _local_12.arenaCount = _local_2.readInt();
                _local_12.arenaFlag = _local_2.readInt();
                _local_3.returnEnergy = _local_2.readInt();
                _local_3.commitChanges();
                TotemManager.instance.updatePropertyAddtion(_local_3.totemId, PlayerManager.Instance.Self.propertyAddition);
                MapManager.buildMap();
                PlayerManager.Instance.Self.loadRelatedPlayersInfo();
                MainToolBar.Instance.signEffectEnable = true;
                SavePointManager.Instance.syncDungeonSavePoints();
                SavePointManager.Instance.syncTaskSavePoints();
                SavePointManager.Instance.getSavePoint(0, this.getSavePoints);
                ExternalInterfaceManager.sendTo360Agent(4);
                if ((!(StartupResourceLoader.firstEnterHall)))
                {
                    StartupResourceLoader.Instance.startLoadRelatedInfo();
                };
                if (DesktopManager.Instance.isDesktop)
                {
                    setTimeout(TaskManager.instance.onDesktopApp, 500);
                };
                DuowanInterfaceManage.Instance.dispatchEvent(new DuowanInterfaceEvent(DuowanInterfaceEvent.ONLINE));
            }
            else
            {
                _local_13 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("alert"), LanguageMgr.GetTranslation("ServerLinkError"));
                this.alertControl(_local_13);
            };
        }

        private function getSavePoints(_arg_1:Array):void
        {
            var _local_3:uint;
            SavePointManager.Instance.savePoints = _arg_1;
            var _local_2:uint = 80;
            while (_local_2 < 84)
            {
                if ((!(_arg_1[_local_2])))
                {
                    SavePointManager.Instance.setSavePoint(_local_2);
                };
                _local_2++;
            };
            if (PlayerManager.Instance.Self.Grade >= SavePointManager.SKIP_BASE_SAVEPOINT_LEVEL)
            {
                _local_3 = 0;
                while (_local_3 <= SavePointManager.MAX_SAVEPOINT)
                {
                    if ((!(SavePointManager.Instance.checkInSkipSavePoint(_local_3))))
                    {
                        SavePointManager.Instance.setSavePoint(_local_3);
                    };
                    _local_3++;
                };
            };
            this.enterHall();
        }

        private function enterHall():void
        {
            dispatchEvent(new Event(ServerManager.GAME_BEGIN));
            StateManager.setState(StateType.MAIN);
        }

        private function releaseLock():void
        {
            AUTO_UNLOCK = true;
            SocketManager.Instance.out.sendBagLocked(BagLockedController.PWD, 2);
        }


    }
}//package ddt.manager

