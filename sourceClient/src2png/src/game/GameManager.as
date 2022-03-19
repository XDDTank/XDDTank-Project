// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.GameManager

package game
{
    import flash.events.EventDispatcher;
    import game.model.GameInfo;
    import game.view.effects.BloodNumberCreater;
    import __AS3__.vec.Vector;
    import game.view.DropGoods;
    import game.view.HitsNumView;
    import flash.utils.Timer;
    import room.model.RoomInfo;
    import ddt.manager.SocketManager;
    import ddt.events.CrazyTankSocketEvent;
    import road7th.comm.PackageIn;
    import game.model.Player;
    import pet.date.PetInfo;
    import flash.geom.Point;
    import ddt.manager.PlayerManager;
    import ddt.events.GameEvent;
    import com.pickgliss.loader.UIModuleLoader;
    import ddt.data.UIModuleTypes;
    import ddt.manager.StateManager;
    import ddt.states.StateType;
    import ddt.view.UIModuleSmallLoading;
    import flash.events.Event;
    import com.pickgliss.events.UIModuleEvent;
    import room.RoomManager;
    import room.model.RoomPlayer;
    import game.model.LocalPlayer;
    import ddt.data.map.MissionInfo;
    import ddt.data.player.PlayerInfo;
    import ddt.data.player.SelfInfo;
    import ddt.manager.PetInfoManager;
    import ddt.manager.QueueManager;
    import ddt.data.BuffInfo;
    import game.model.GameNeedMovieInfo;
    import game.model.GameNeedPetSkillInfo;
    import ddt.data.FightBuffInfo;
    import game.view.experience.ExpTweenManager;
    import ddt.manager.BuffManager;
    import game.model.Pet;
    import game.model.PetLiving;
    import SingleDungeon.SingleDungeonManager;
    import ddt.manager.SavePointManager;
    import ddt.manager.PathManager;
    import ddt.data.goods.InventoryItemInfo;
    import ddt.view.chat.ChatData;
    import ddt.view.chat.ChatInputView;
    import ddt.manager.LanguageMgr;
    import ddt.view.chat.ChatFormats;
    import ddt.manager.ChatManager;
    import flash.utils.Dictionary;
    import road7th.data.DictionaryData;
    import game.model.Living;
    import __AS3__.vec.*;

    public class GameManager extends EventDispatcher 
    {

        public static const START_LOAD:String = "StartLoading";
        public static var MinLevelDuplicate:int = 13;
        public static const ENTER_MISSION_RESULT:String = "EnterMissionResult";
        public static const ENTER_ROOM:String = "EnterRoom";
        public static const LEAVE_MISSION:String = "leaveMission";
        public static const ENTER_DUNGEON:String = "EnterDungeon";
        public static const PLAYER_CLICK_PAY:String = "PlayerClickPay";
        public static const MOVE_PROPBAR:String = "Move_propBar";
        public static const TASK_GOOD_THREE:uint = 0;
        public static const TASK_GOOD_ADDONE:uint = 1;
        public static const TASK_GOOD_ADDTWO:uint = 2;
        public static const TASK_GOOD_POWMAX:uint = 3;
        public static const TASK_GOOD_PLANE:uint = 4;
        public static const TASK_GOOD_LEAD:uint = 5;
        private static var _instance:GameManager;
        public static const MissionGiveup:int = 0;
        public static const MissionAgain:int = 1;
        public static const MissionTimeout:int = 2;

        private var _current:GameInfo;
        private var _numCreater:BloodNumberCreater;
        public var dropGoodslist:Vector.<DropGoods> = new Vector.<DropGoods>();
        public var dropData:Array = new Array();
        public var dropGlod:int;
        public var isRed:Boolean;
        public var hitsNumView:HitsNumView;
        private var _hitsNum:int;
        public var dropTaskGoodsId:int = -1;
        public var dropTaskGoodsNpcId:int = -1;
        public var dialogId:int = -1;
        public var petReduceList:Array = new Array();
        public var isLeaving:Boolean;
        public var fightRobotChangePlayerID1:int = -1;
        public var fightRobotChangePlayerID2:int = -1;
        private var _hasRoomLoading:Boolean;
        public var TryAgain:int = 0;
        private var _recevieLoadSocket:Boolean;
        private var _timer:Timer;
        private var _MissionOverType:uint = 0;
        public var isDieFight:Boolean = false;


        public static function isDungeonRoom(_arg_1:GameInfo):Boolean
        {
            return (((_arg_1.roomType == RoomInfo.DUNGEON_ROOM) || (_arg_1.roomType == RoomInfo.SINGLE_DUNGEON)) || (RoomInfo.MULTI_DUNGEON));
        }

        public static function isFreshMan(_arg_1:GameInfo):Boolean
        {
            return (_arg_1.roomType == RoomInfo.FRESHMAN_ROOM);
        }

        public static function get Instance():GameManager
        {
            if (_instance == null)
            {
                _instance = new (GameManager)();
            };
            return (_instance);
        }


        public function get hasRoomLoading():Boolean
        {
            return (this._hasRoomLoading);
        }

        public function get hitsNum():int
        {
            return (this._hitsNum);
        }

        public function set hitsNum(_arg_1:int):void
        {
            this._hitsNum = _arg_1;
            if (((this.hitsNumView) && (this._hitsNum > 0)))
            {
                this.hitsNumView.setHitsNum(this._hitsNum);
            };
        }

        public function resetHitsNum():void
        {
            this._hitsNum = 0;
        }

        public function setDropData(_arg_1:int, _arg_2:int):void
        {
            var _local_3:Boolean;
            var _local_5:Object;
            var _local_4:int;
            while (_local_4 < this.dropData.length)
            {
                if (this.dropData[_local_4].itemId == _arg_1)
                {
                    this.dropData[_local_4].count = (this.dropData[_local_4].count + _arg_2);
                    _local_3 = true;
                    break;
                };
                _local_4++;
            };
            if ((!(_local_3)))
            {
                _local_5 = new Object();
                _local_5.count = _arg_2;
                _local_5.itemId = _arg_1;
                this.dropData.push(_local_5);
            };
        }

        public function clearDropData():void
        {
            var _local_1:int;
            while (_local_1 < this.dropData.length)
            {
                this.dropData.splice(0);
                _local_1++;
            };
            this.dropGlod = 0;
        }

        public function get Current():GameInfo
        {
            return (this._current);
        }

        public function set trainerCurrent(_arg_1:GameInfo):void
        {
            this._current = _arg_1;
        }

        public function setup():void
        {
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_CREATE, this.__createGame);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_START, this.__gameStart);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_LOAD, this.__beginLoad);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LOAD, this.__loadprogress);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_ALL_MISSION_OVER, this.__missionAllOver);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_TAKE_OUT, this.__takeOut);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SHOW_CARDS, this.__showAllCard);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_MISSION_INFO, this.__gameMissionInfo);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_MISSION_START, this.__gameMissionStart);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_MISSION_PREPARE, this.__gameMissionPrepare);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_ROOM_INFO, this.__missionInviteRoomInfo);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAY_INFO_IN_GAME, this.__updatePlayInfoInGame);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_MISSION_TRY_AGAIN, this.__missionTryAgain);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LOAD_RESOURCE, this.__loadResource);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.BUFF_OBTAIN, this.__buffObtain);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.BUFF_UPDATE, this.__buffUpdate);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.BOSS_PLAYER_OBJECT, this.__onUpdateBossPlayerThing);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.FIGHTROBOT_CHANGE_PLAYER, this.__fightRobotChangePlayer);
        }

        private function __fightRobotChangePlayer(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:PackageIn = _arg_1.pkg;
            this.fightRobotChangePlayerID1 = _local_2.readInt();
            this.fightRobotChangePlayerID2 = _local_2.readInt();
        }

        private function __onUpdateBossPlayerThing(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_5:int;
            var _local_6:Player;
            var _local_7:PetInfo;
            var _local_8:int;
            var _local_9:int;
            var _local_10:int;
            var _local_2:PackageIn = _arg_1.pkg;
            var _local_3:int = _local_2.readInt();
            var _local_4:int;
            while (_local_4 < _local_3)
            {
                _local_5 = _local_2.readInt();
                _local_6 = this._current.findPlayer(_local_5);
                _local_6.npcID = _local_2.readInt();
                _local_6.bossCreateAction = _local_2.readUTF();
                _local_6.typeLiving = _local_2.readByte();
                _local_6.bossName = _local_2.readUTF();
                _local_6.actionMCname = _local_2.readUTF();
                _local_6.shootPos = new Point(_local_2.readInt(), _local_2.readInt());
                _local_7 = new PetInfo();
                _local_7.TemplateID = -1;
                _local_7.ID = _local_6.playerInfo.ID;
                _local_7.Name = "BossPlayer";
                _local_7.UserID = _local_6.playerInfo.ID;
                _local_7.Attack = 0;
                _local_7.Defence = 0;
                _local_7.Luck = 0;
                _local_7.Agility = 0;
                _local_7.Blood = 0;
                _local_7.AttackGrow = 0;
                _local_7.DefenceGrow = 0;
                _local_7.LuckGrow = 0;
                _local_7.AgilityGrow = 0;
                _local_7.BloodGrow = 0;
                _local_7.Level = 0;
                _local_7.GP = 0;
                _local_7.MaxGP = 0;
                _local_7.Hunger = 0;
                _local_7.PetHappyStar = 0;
                _local_7.clearSkills();
                _local_8 = _local_2.readInt();
                _local_9 = 0;
                while (_local_9 < _local_8)
                {
                    _local_10 = _local_2.readInt();
                    _local_7.addSkill(_local_9, _local_10);
                    _local_9++;
                };
                if (_local_6.playerInfo.ID == PlayerManager.Instance.Self.ID)
                {
                    PlayerManager.Instance.Self.currentPet = _local_7;
                }
                else
                {
                    _local_6.playerInfo.currentPet = _local_7;
                };
                _local_4++;
            };
        }

        private function __missionTryAgain(_arg_1:CrazyTankSocketEvent):void
        {
            this.TryAgain = _arg_1.pkg.readInt();
            dispatchEvent(new GameEvent(GameEvent.MISSIONAGAIN, this.TryAgain));
        }

        public function isSingleDungeonRoom(_arg_1:GameInfo=null):Boolean
        {
            if ((!(_arg_1)))
            {
                _arg_1 = this.Current;
            };
            return (_arg_1.roomType == RoomInfo.SINGLE_DUNGEON);
        }

        public function gotoRoomLoading():void
        {
            if (UIModuleLoader.Instance.checkIsLoaded(UIModuleTypes.DDTROOMLOADING))
            {
                StateManager.setState(StateType.ROOM_LOADING, this.Current);
            }
            else
            {
                UIModuleSmallLoading.Instance.progress = 0;
                UIModuleSmallLoading.Instance.show();
                UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE, this.__onClose);
                UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__roomListComplete);
                UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS, this.__roomListProgress);
                UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.DDTROOMLOADING);
            };
        }

        private function __onClose(_arg_1:Event):void
        {
            UIModuleSmallLoading.Instance.hide();
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE, this.__onClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__roomListComplete);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS, this.__roomListProgress);
        }

        protected function __roomListComplete(_arg_1:UIModuleEvent):void
        {
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE, this.__onClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__roomListComplete);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS, this.__roomListProgress);
            this.gotoRoomLoading();
        }

        protected function __roomListProgress(_arg_1:UIModuleEvent):void
        {
            if (_arg_1.module == UIModuleTypes.DDTROOMLOADING)
            {
                UIModuleSmallLoading.Instance.progress = (_arg_1.loader.progress * 100);
            };
        }

        private function __updatePlayInfoInGame(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_11:Player;
            var _local_2:RoomInfo = RoomManager.Instance.current;
            if (_local_2 == null)
            {
                return;
            };
            var _local_3:PackageIn = _arg_1.pkg;
            var _local_4:int = _local_3.readInt();
            var _local_5:int = _local_3.readInt();
            var _local_6:int = _local_3.readInt();
            var _local_7:int = _local_3.readInt();
            var _local_8:int = _local_3.readInt();
            var _local_9:Boolean = _local_3.readBoolean();
            var _local_10:RoomPlayer = RoomManager.Instance.current.findPlayerByID(_local_5);
            if ((((!(_local_4 == PlayerManager.Instance.Self.ZoneID)) || (_local_10 == null)) || (this._current == null)))
            {
                return;
            };
            if (_local_10.isSelf)
            {
                _local_11 = new LocalPlayer(PlayerManager.Instance.Self, _local_7, _local_6, _local_8);
            }
            else
            {
                _local_11 = new Player(_local_10.playerInfo, _local_7, _local_6, _local_8);
            };
            _local_11.isReady = _local_9;
            _local_11.isShowReadyMC = this._current.isMultiGame;
            if (_local_11.movie)
            {
                _local_11.movie.setDefaultAction(_local_11.movie.standAction);
            };
            this._current.addRoomPlayer(_local_10);
            if (_local_10.isViewer)
            {
                this._current.addGameViewer(_local_11);
            }
            else
            {
                this._current.addGamePlayer(_local_11);
            };
            if (_local_10.isSelf)
            {
                StateManager.setState(StateType.MISSION_ROOM);
            };
        }

        private function __missionInviteRoomInfo(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:PackageIn;
            var _local_3:GameInfo;
            var _local_4:int;
            var _local_5:int;
            var _local_6:MissionInfo;
            var _local_7:int;
            var _local_8:PlayerInfo;
            var _local_9:RoomPlayer;
            var _local_10:Boolean;
            var _local_11:int;
            var _local_12:String;
            var _local_13:String;
            var _local_14:int;
            var _local_15:int;
            var _local_16:int;
            var _local_17:int;
            var _local_18:Boolean;
            var _local_19:Player;
            if (RoomManager.Instance.current)
            {
                _local_2 = _arg_1.pkg;
                _local_3 = new GameInfo();
                _local_3.mapIndex = _local_2.readInt();
                _local_3.roomType = _local_2.readInt();
                _local_3.gameMode = _local_2.readInt();
                _local_3.timeType = _local_2.readInt();
                RoomManager.Instance.current.timeType = _local_3.timeType;
                _local_4 = _local_2.readInt();
                _local_5 = 0;
                while (_local_5 < _local_4)
                {
                    _local_7 = _local_2.readInt();
                    _local_8 = PlayerManager.Instance.findPlayer(_local_7);
                    _local_8.beginChanges();
                    _local_9 = RoomManager.Instance.current.findPlayerByID(_local_7);
                    if (_local_9 == null)
                    {
                        _local_9 = new RoomPlayer(_local_8);
                        _local_8.ID = _local_7;
                    };
                    _local_8.ZoneID = PlayerManager.Instance.Self.ZoneID;
                    _local_8.NickName = _local_2.readUTF();
                    _local_10 = _local_2.readBoolean();
                    _local_8.VIPtype = _local_2.readByte();
                    _local_8.VIPLevel = _local_2.readInt();
                    _local_8.Sex = _local_2.readBoolean();
                    _local_8.Hide = _local_2.readInt();
                    _local_8.Style = _local_2.readUTF();
                    _local_8.Colors = _local_2.readUTF();
                    _local_8.Skin = _local_2.readUTF();
                    _local_8.Grade = _local_2.readInt();
                    _local_8.Repute = _local_2.readInt();
                    _local_8.WeaponID = _local_2.readInt();
                    if (_local_8.WeaponID > 0)
                    {
                        _local_11 = _local_2.readInt();
                        _local_12 = _local_2.readUTF();
                        _local_13 = _local_2.readDateString();
                    };
                    _local_8.DeputyWeaponID = _local_2.readInt();
                    _local_8.ConsortiaID = _local_2.readInt();
                    _local_8.ConsortiaName = _local_2.readUTF();
                    _local_8.badgeID = _local_2.readInt();
                    _local_14 = _local_2.readInt();
                    _local_15 = _local_2.readInt();
                    _local_8.DailyLeagueFirst = _local_2.readBoolean();
                    _local_8.DailyLeagueLastScore = _local_2.readInt();
                    _local_8.commitChanges();
                    _local_9.team = _local_2.readInt();
                    _local_3.addRoomPlayer(_local_9);
                    _local_16 = _local_2.readInt();
                    _local_17 = _local_2.readInt();
                    _local_18 = _local_2.readBoolean();
                    if (_local_9.isSelf)
                    {
                        _local_19 = new LocalPlayer(PlayerManager.Instance.Self, _local_16, _local_9.team, _local_17);
                    }
                    else
                    {
                        _local_19 = new Player(_local_9.playerInfo, _local_16, _local_9.team, _local_17);
                    };
                    _local_19.isReady = _local_18;
                    _local_19.isShowReadyMC = _local_3.isMultiGame;
                    _local_19.currentWeapInfo.refineryLevel = _local_11;
                    if ((!(_local_10)))
                    {
                        _local_3.addGamePlayer(_local_19);
                    }
                    else
                    {
                        if (_local_9.isSelf)
                        {
                            _local_3.setSelfGamePlayer(_local_19);
                        };
                        _local_3.addGameViewer(_local_19);
                    };
                    _local_5++;
                };
                this._current = _local_3;
                _local_6 = new MissionInfo();
                _local_6.name = _local_2.readUTF();
                _local_6.pic = _local_2.readUTF();
                _local_6.success = _local_2.readUTF();
                _local_6.failure = _local_2.readUTF();
                _local_6.description = _local_2.readUTF();
                _local_6.totalMissiton = _local_2.readInt();
                _local_6.missionIndex = _local_2.readInt();
                _local_6.nextMissionIndex = (_local_6.missionIndex + 1);
                this._current.missionInfo = _local_6;
                this._current.hasNextMission = true;
            };
        }

        private function __createGame(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:PackageIn;
            var _local_3:GameInfo;
            var _local_4:int;
            var _local_5:int;
            var _local_6:int;
            var _local_7:String;
            var _local_8:int;
            var _local_9:PlayerInfo;
            var _local_10:RoomPlayer;
            var _local_11:String;
            var _local_12:Boolean;
            var _local_13:int;
            var _local_14:int;
            var _local_15:int;
            var _local_16:int;
            var _local_17:Player;
            var _local_18:Boolean;
            var _local_19:int;
            var _local_20:String;
            var _local_21:String;
            var _local_22:int;
            var _local_23:int;
            var _local_24:PetInfo;
            var _local_25:int;
            var _local_26:int;
            var _local_27:int;
            var _local_28:int;
            if (RoomManager.Instance.current)
            {
                _local_2 = _arg_1.pkg;
                _local_3 = new GameInfo();
                _local_3.roomType = _local_2.readInt();
                _local_3.gameMode = _local_2.readInt();
                _local_3.timeType = _local_2.readInt();
                RoomManager.Instance.current.timeType = _local_3.timeType;
                _local_4 = _local_2.readInt();
                _local_5 = 0;
                while (_local_5 < _local_4)
                {
                    _local_6 = _local_2.readInt();
                    _local_7 = _local_2.readUTF();
                    _local_8 = _local_2.readInt();
                    _local_9 = PlayerManager.Instance.findPlayer(_local_8, _local_6);
                    _local_9.beginChanges();
                    _local_10 = RoomManager.Instance.current.findPlayerByID(_local_8, _local_6);
                    if (_local_10 == null)
                    {
                        _local_10 = new RoomPlayer(_local_9);
                    };
                    _local_9.ID = _local_8;
                    _local_9.ZoneID = _local_6;
                    _local_11 = _local_2.readUTF();
                    _local_12 = _local_2.readBoolean();
                    if (((_local_12) && (_local_10.place < 6)))
                    {
                        _local_10.place = 6;
                    };
                    if ((!(_local_10 is SelfInfo)))
                    {
                        _local_9.NickName = _local_11;
                    };
                    _local_9.VIPtype = _local_2.readByte();
                    _local_9.VIPLevel = _local_2.readInt();
                    _local_9.isFightVip = _local_2.readBoolean();
                    _local_9.fightToolBoxSkillNum = _local_2.readInt();
                    if (PlayerManager.Instance.isChangeStyleTemp(_local_9.ID))
                    {
                        _local_2.readBoolean();
                        _local_2.readInt();
                        _local_2.readUTF();
                        _local_2.readUTF();
                        _local_2.readUTF();
                    }
                    else
                    {
                        _local_9.Sex = _local_2.readBoolean();
                        _local_9.Hide = _local_2.readInt();
                        _local_9.Style = _local_2.readUTF();
                        _local_9.Colors = _local_2.readUTF();
                        _local_9.Skin = _local_2.readUTF();
                    };
                    _local_9.Grade = _local_2.readInt();
                    _local_9.Repute = _local_2.readInt();
                    _local_9.WeaponID = _local_2.readInt();
                    if (_local_9.WeaponID != 0)
                    {
                        _local_19 = _local_2.readInt();
                        _local_20 = _local_2.readUTF();
                        _local_21 = _local_2.readDateString();
                    };
                    _local_9.DeputyWeaponID = _local_2.readInt();
                    _local_9.Nimbus = _local_2.readInt();
                    _local_9.IsShowConsortia = _local_2.readBoolean();
                    _local_9.ConsortiaID = _local_2.readInt();
                    _local_9.ConsortiaName = _local_2.readUTF();
                    _local_9.badgeID = _local_2.readInt();
                    _local_13 = _local_2.readInt();
                    _local_14 = _local_2.readInt();
                    _local_9.WinCount = _local_2.readInt();
                    _local_9.TotalCount = _local_2.readInt();
                    _local_9.FightPower = _local_2.readInt();
                    _local_9.apprenticeshipState = _local_2.readInt();
                    _local_9.masterID = _local_2.readInt();
                    _local_9.setMasterOrApprentices(_local_2.readUTF());
                    _local_9.AchievementPoint = _local_2.readInt();
                    _local_9.honor = _local_2.readUTF();
                    _local_9.Offer = _local_2.readInt();
                    _local_9.DailyLeagueFirst = _local_2.readBoolean();
                    _local_9.DailyLeagueLastScore = _local_2.readInt();
                    _local_9.commitChanges();
                    _local_10.playerInfo.IsMarried = _local_2.readBoolean();
                    if (_local_10.playerInfo.IsMarried)
                    {
                        _local_10.playerInfo.SpouseID = _local_2.readInt();
                        _local_10.playerInfo.SpouseName = _local_2.readUTF();
                    };
                    _local_10.additionInfo.resetAddition();
                    _local_10.additionInfo.GMExperienceAdditionType = Number((_local_2.readInt() / 100));
                    _local_10.additionInfo.AuncherExperienceAddition = Number((_local_2.readInt() / 100));
                    _local_10.additionInfo.GMOfferAddition = Number((_local_2.readInt() / 100));
                    _local_10.additionInfo.AuncherOfferAddition = Number((_local_2.readInt() / 100));
                    _local_10.additionInfo.GMRichesAddition = Number((_local_2.readInt() / 100));
                    _local_10.additionInfo.AuncherRichesAddition = Number((_local_2.readInt() / 100));
                    _local_10.team = _local_2.readInt();
                    _local_3.addRoomPlayer(_local_10);
                    _local_15 = _local_2.readInt();
                    _local_16 = _local_2.readInt();
                    if (_local_10.isSelf)
                    {
                        _local_17 = new LocalPlayer(PlayerManager.Instance.Self, _local_15, _local_10.team, _local_16);
                    }
                    else
                    {
                        _local_17 = new Player(_local_10.playerInfo, _local_15, _local_10.team, _local_16);
                    };
                    _local_17.isShowReadyMC = _local_3.isMultiGame;
                    _local_18 = _local_2.readBoolean();
                    if (_local_18)
                    {
                        _local_22 = _local_2.readInt();
                        _local_23 = _local_2.readInt();
                        _local_24 = new PetInfo();
                        _local_24.TemplateID = _local_23;
                        PetInfoManager.instance.fillPetInfo(_local_24);
                        _local_24.Place = _local_22;
                        _local_24.ID = _local_2.readInt();
                        _local_24.Name = _local_2.readUTF();
                        _local_24.UserID = _local_2.readInt();
                        _local_24.Level = _local_2.readInt();
                        _local_24.clearSkills();
                        _local_25 = _local_2.readInt();
                        _local_26 = 0;
                        while (_local_26 < _local_25)
                        {
                            _local_27 = _local_2.readInt();
                            _local_28 = _local_2.readInt();
                            _local_24.addSkill(_local_27, _local_28);
                            _local_26++;
                        };
                        if (((!(RoomManager.Instance.current)) || (!(RoomManager.Instance.current.type == RoomInfo.CHANGE_DUNGEON))))
                        {
                            _local_9.currentPet = _local_24;
                        };
                    };
                    _local_9.MilitaryRankTotalScores = _local_2.readInt();
                    _local_17.zoneName = _local_7;
                    _local_17.currentWeapInfo.refineryLevel = _local_19;
                    if ((!(_local_10.isViewer)))
                    {
                        _local_3.addGamePlayer(_local_17);
                    }
                    else
                    {
                        if (_local_10.isSelf)
                        {
                            _local_3.setSelfGamePlayer(_local_17);
                        };
                        _local_3.addGameViewer(_local_17);
                    };
                    _local_5++;
                };
                this._current = _local_3;
                QueueManager.setLifeTime(0);
            };
        }

        private function __buffObtain(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:PackageIn;
            var _local_3:int;
            var _local_4:int;
            var _local_5:int;
            var _local_6:Boolean;
            var _local_7:Date;
            var _local_8:int;
            var _local_9:int;
            var _local_10:BuffInfo;
            if (this._current)
            {
                _local_2 = _arg_1.pkg;
                if (_local_2.extend1 == this._current.selfGamePlayer.LivingID)
                {
                    return;
                };
                if (this._current.findPlayer(_local_2.extend1) != null)
                {
                    _local_3 = _local_2.readInt();
                    _local_4 = 0;
                    while (_local_4 < _local_3)
                    {
                        _local_5 = _local_2.readInt();
                        _local_6 = _local_2.readBoolean();
                        _local_7 = _local_2.readDate();
                        _local_8 = _local_2.readInt();
                        _local_9 = _local_2.readInt();
                        _local_10 = new BuffInfo(_local_5, _local_6, _local_7, _local_8, _local_9);
                        this._current.findPlayer(_local_2.extend1).playerInfo.buffInfo.add(_local_10.Type, _local_10);
                        _local_4++;
                    };
                    _arg_1.stopImmediatePropagation();
                };
            };
        }

        private function __buffUpdate(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:PackageIn;
            var _local_3:int;
            var _local_4:int;
            var _local_5:Boolean;
            var _local_6:Date;
            var _local_7:int;
            var _local_8:int;
            var _local_9:BuffInfo;
            if (this._current)
            {
                _local_2 = _arg_1.pkg;
                if (_local_2.extend1 == this._current.selfGamePlayer.LivingID)
                {
                    return;
                };
                if (this._current.findPlayer(_local_2.extend1) != null)
                {
                    _local_3 = _local_2.readInt();
                    _local_4 = _local_2.readInt();
                    _local_5 = _local_2.readBoolean();
                    _local_6 = _local_2.readDate();
                    _local_7 = _local_2.readInt();
                    _local_8 = _local_2.readInt();
                    _local_9 = new BuffInfo(_local_4, _local_5, _local_6, _local_7, _local_8);
                    if (_local_5)
                    {
                        this._current.findPlayer(_local_2.extend1).playerInfo.buffInfo.add(_local_9.Type, _local_9);
                    }
                    else
                    {
                        this._current.findPlayer(_local_2.extend1).playerInfo.buffInfo.remove(_local_9.Type);
                    };
                    _arg_1.stopImmediatePropagation();
                };
            };
        }

        private function __beginLoad(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:int;
            var _local_3:int;
            var _local_4:int;
            var _local_5:int;
            var _local_6:GameNeedMovieInfo;
            var _local_7:GameNeedPetSkillInfo;
            StateManager.getInGame_Step_3 = true;
            this._recevieLoadSocket = true;
            if (this._current)
            {
                StateManager.getInGame_Step_4 = true;
                this._current.maxTime = _arg_1.pkg.readInt();
                this._current.mapIndex = _arg_1.pkg.readInt();
                _local_2 = _arg_1.pkg.readInt();
                _local_3 = 1;
                while (_local_3 <= _local_2)
                {
                    _local_6 = new GameNeedMovieInfo();
                    _local_6.type = _arg_1.pkg.readInt();
                    _local_6.path = _arg_1.pkg.readUTF();
                    _local_6.classPath = _arg_1.pkg.readUTF();
                    this._current.neededMovies.push(_local_6);
                    _local_3++;
                };
                _local_4 = _arg_1.pkg.readInt();
                _local_5 = 0;
                while (_local_5 < _local_4)
                {
                    _local_7 = new GameNeedPetSkillInfo();
                    _local_7.pic = _arg_1.pkg.readUTF();
                    _local_7.effect = _arg_1.pkg.readUTF();
                    this._current.neededPetSkillResource.push(_local_7);
                    _local_5++;
                };
            };
            this.checkCanToLoader();
        }

        private function checkCanToLoader():void
        {
            if (((this._recevieLoadSocket) && ((this._current.missionInfo) || (!(this.getRoomTypeNeedMissionInfo(this._current.roomType))))))
            {
                dispatchEvent(new Event(START_LOAD));
                StateManager.getInGame_Step_5 = true;
                this._recevieLoadSocket = false;
            };
        }

        private function getRoomTypeNeedMissionInfo(_arg_1:int):Boolean
        {
            return ((((((((_arg_1 == 2) || (_arg_1 == 3)) || (_arg_1 == 4)) || (_arg_1 == 5)) || (_arg_1 == 8)) || (_arg_1 == 10)) || (_arg_1 == 11)) || (_arg_1 == 14));
        }

        private function __gameMissionStart(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:PackageIn = _arg_1.pkg;
            var _local_3:Object = new Object();
            _local_3.id = _local_2.clientId;
            var _local_4:Boolean = _local_2.readBoolean();
        }

        public function dispatchAllGameReadyState(_arg_1:Array):void
        {
            var _local_2:CrazyTankSocketEvent;
            var _local_3:PackageIn;
            var _local_4:Object;
            var _local_5:int;
            var _local_6:Player;
            var _local_7:RoomPlayer;
            for each (_local_2 in _arg_1)
            {
                _local_3 = _local_2.pkg;
                _local_4 = new Object();
                _local_5 = _local_3.clientId;
                if (this._current)
                {
                    _local_6 = this._current.findPlayerByPlayerID(_local_5);
                    _local_6.isReady = _local_3.readBoolean();
                    if (((!(_local_6.isSelf)) && (_local_6.isReady)))
                    {
                        _local_7 = RoomManager.Instance.current.findPlayerByID(_local_5);
                        _local_7.isReady = true;
                    };
                };
                _local_3.position = SocketManager.PACKAGE_CONTENT_START_INDEX;
            };
        }

        private function __gameMissionPrepare(_arg_1:CrazyTankSocketEvent):void
        {
            if (RoomManager.Instance.current)
            {
                RoomManager.Instance.current.setPlayerReadyState(_arg_1.pkg.clientId, _arg_1.pkg.readBoolean());
            };
        }

        private function __gameMissionInfo(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:String;
            var _local_3:MissionInfo;
            if (this._current == null)
            {
                return;
            };
            if ((!(this._current.missionInfo)))
            {
                _local_3 = (this._current.missionInfo = new MissionInfo());
            }
            else
            {
                _local_3 = this._current.missionInfo;
            };
            _local_3.name = _arg_1.pkg.readUTF();
            _local_3.success = _arg_1.pkg.readUTF();
            _local_3.failure = _arg_1.pkg.readUTF();
            _local_3.description = _arg_1.pkg.readUTF();
            _local_2 = _arg_1.pkg.readUTF();
            _local_3.totalMissiton = _arg_1.pkg.readInt();
            _local_3.missionIndex = _arg_1.pkg.readInt();
            _local_3.totalValue1 = _arg_1.pkg.readInt();
            _local_3.totalValue2 = _arg_1.pkg.readInt();
            _local_3.totalValue3 = _arg_1.pkg.readInt();
            _local_3.totalValue4 = _arg_1.pkg.readInt();
            _local_3.nextMissionIndex = (_local_3.missionIndex + 1);
            _local_3.parseString(_local_2);
            _local_3.tryagain = _arg_1.pkg.readInt();
            RoomManager.Instance.current.pic = _arg_1.pkg.readUTF();
            this.checkCanToLoader();
        }

        private function __loadprogress(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:int;
            var _local_3:int;
            var _local_4:int;
            var _local_5:RoomPlayer;
            if (this._current)
            {
                _local_2 = _arg_1.pkg.readInt();
                _local_3 = _arg_1.pkg.readInt();
                _local_4 = _arg_1.pkg.readInt();
                _local_5 = this._current.findRoomPlayer(_local_4, _local_3);
                if (((_local_5) && (!(_local_5.isSelf))))
                {
                    _local_5.progress = _local_2;
                };
            };
        }

        private function __gameStart(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:PackageIn;
            var _local_3:int;
            var _local_4:int;
            var _local_5:int;
            var _local_6:Player;
            var _local_7:int;
            var _local_8:int;
            var _local_9:int;
            var _local_10:int;
            var _local_11:FightBuffInfo;
            var _local_12:int;
            this.TryAgain = -1;
            ExpTweenManager.Instance.deleteTweens();
            if (this._current)
            {
                _arg_1.executed = false;
                _local_2 = _arg_1.pkg;
                _local_3 = _local_2.readInt();
                _local_4 = 1;
                while (_local_4 <= _local_3)
                {
                    _local_5 = _local_2.readInt();
                    _local_6 = this._current.findPlayer(_local_5);
                    if (_local_6 != null)
                    {
                        _local_6.reset();
                        _local_6.pos = new Point(_local_2.readInt(), _local_2.readInt());
                        _local_6.energy = 1;
                        _local_6.direction = _local_2.readInt();
                        _local_7 = _local_2.readInt();
                        _local_6.team = _local_2.readInt();
                        _local_8 = _local_2.readInt();
                        _local_6.powerRatio = _local_2.readInt();
                        _local_6.dander = _local_2.readInt();
                        _local_6.maxBlood = _local_7;
                        _local_6.updateBlood(_local_7, 0, 0);
                        _local_6.wishKingCount = _local_2.readInt();
                        _local_6.wishKingEnergy = _local_2.readInt();
                        _local_6.currentWeapInfo.refineryLevel = _local_8;
                        _local_9 = _local_2.readInt();
                        _local_10 = 0;
                        while (_local_10 < _local_9)
                        {
                            _local_11 = BuffManager.creatBuff(_local_2.readInt());
                            _local_12 = _local_2.readInt();
                            if (_local_12 >= 0)
                            {
                                if (_local_11)
                                {
                                    _local_11.data = _local_12;
                                    _local_6.addBuff(_local_11);
                                };
                            };
                            _local_10++;
                        };
                        if (((!(RoomManager.Instance.current.type == 5)) && (_local_6.playerInfo.currentPet)))
                        {
                            _local_6.currentPet = new Pet(_local_6.playerInfo.currentPet);
                            _local_6.petLiving = new PetLiving(_local_6.playerInfo.currentPet, _local_6, -1, _local_6.team, 100000);
                            _local_6.petLiving.pos = new Point(_local_6.pos.x, _local_6.pos.y);
                        };
                    };
                    _local_4++;
                };
                if (_local_3 == 0)
                {
                    if (((RoomManager.Instance.current.type == RoomInfo.DUNGEON_ROOM) || (RoomManager.Instance.current.type == RoomInfo.MULTI_DUNGEON)))
                    {
                        StateManager.setState(StateType.DUNGEON_LIST);
                    }
                    else
                    {
                        if (RoomManager.Instance.current.type == RoomInfo.SINGLE_DUNGEON)
                        {
                            StateManager.setState(StateType.SINGLEDUNGEON);
                        }
                        else
                        {
                            StateManager.setState(StateType.ROOM_LIST);
                        };
                    };
                }
                else
                {
                    if (RoomManager.Instance.current.type == RoomInfo.CHANGE_DUNGEON)
                    {
                        StateManager.setState(StateType.FIGHTING);
                    }
                    else
                    {
                        StateManager.setState(StateType.MULTISHOOT_FIGHTING, this._current);
                    };
                };
                RoomManager.Instance.resetAllPlayerState();
            };
        }

        private function __missionAllOver(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_4:int;
            var _local_7:Object;
            var _local_8:int;
            var _local_9:Player;
            var _local_10:SelfInfo;
            var _local_2:PackageIn = _arg_1.pkg;
            var _local_3:int = _local_2.readInt();
            if (this._current == null)
            {
                return;
            };
            while (_local_4 < _local_3)
            {
                _local_8 = _local_2.readInt();
                _local_9 = this._current.findPlayerByPlayerID(_local_8);
                if (_local_9.expObj)
                {
                    _local_7 = _local_9.expObj;
                }
                else
                {
                    _local_7 = new Object();
                };
                if (_local_9)
                {
                    _local_7.baseExp = _local_2.readInt();
                    _local_7.gpForVIP = _local_2.readInt();
                    _local_7.gpForApprenticeTeam = _local_2.readInt();
                    _local_7.gpForApprenticeOnline = _local_2.readInt();
                    _local_7.gpForSpouse = _local_2.readInt();
                    _local_7.gpForServer = _local_2.readInt();
                    _local_7.gpForDoubleCard = _local_2.readInt();
                    _local_7.consortiaSkill = _local_2.readInt();
                    _local_7.gainGP = _local_2.readInt();
                    _local_9.isWin = _local_2.readBoolean();
                    _local_9.expObj = _local_7;
                    if (_local_9.isWin)
                    {
                        switch (SingleDungeonManager.Instance.currentMapId)
                        {
                            case 1011:
                            case 2011:
                                if (SavePointManager.Instance.isInSavePoint(4))
                                {
                                    SavePointManager.Instance.setSavePoint(4);
                                };
                                break;
                            case 1005:
                            case 2005:
                                if (SavePointManager.Instance.isInSavePoint(6))
                                {
                                    SavePointManager.Instance.setSavePoint(6);
                                };
                                break;
                            case 1006:
                            case 2006:
                                if (SavePointManager.Instance.isInSavePoint(8))
                                {
                                    SavePointManager.Instance.setSavePoint(8);
                                };
                                break;
                            case 1007:
                            case 2007:
                                if (SavePointManager.Instance.isInSavePoint(12))
                                {
                                    SavePointManager.Instance.setSavePoint(12);
                                };
                                break;
                            case 1008:
                            case 2008:
                                if (SavePointManager.Instance.isInSavePoint(19))
                                {
                                    SavePointManager.Instance.setSavePoint(19);
                                };
                                break;
                        };
                    };
                };
                _local_4++;
            };
            if (((PathManager.solveExternalInterfaceEnabel()) && (this._current.selfGamePlayer.isWin)))
            {
                _local_10 = PlayerManager.Instance.Self;
            };
            this._current.missionInfo.missionOverNPCMovies = [];
            var _local_5:int = _local_2.readInt();
            var _local_6:int;
            while (_local_6 < _local_5)
            {
                this._current.missionInfo.missionOverNPCMovies.push(_local_2.readUTF());
                _local_6++;
            };
        }

        private function __takeOut(_arg_1:CrazyTankSocketEvent):void
        {
            if (this._current)
            {
                this._current.resultCard.push(_arg_1);
            };
        }

        private function __showAllCard(_arg_1:CrazyTankSocketEvent):void
        {
            if (this._current)
            {
                this._current.showAllCard.push(_arg_1);
            };
        }

        public function reset():void
        {
            if (this._current)
            {
                this._current.dispose();
                this._current = null;
            };
        }

        public function startLoading():void
        {
            StateManager.setState(StateType.GAME_LOADING);
        }

        public function dispatchEnterRoom():void
        {
            dispatchEvent(new Event(ENTER_ROOM));
        }

        public function dispatchLeaveMission():void
        {
            dispatchEvent(new Event(LEAVE_MISSION));
        }

        public function dispatchPaymentConfirm():void
        {
            dispatchEvent(new Event(PLAYER_CLICK_PAY));
        }

        public function selfGetItemShowAndSound(_arg_1:Dictionary):Boolean
        {
            var _local_3:InventoryItemInfo;
            var _local_4:ChatData;
            var _local_5:String;
            var _local_6:Array;
            var _local_7:String;
            var _local_2:Boolean;
            for each (_local_3 in _arg_1)
            {
                _local_4 = new ChatData();
                _local_4.channel = ChatInputView.SYS_NOTICE;
                _local_5 = LanguageMgr.GetTranslation("tank.data.player.FightingPlayerInfo.your");
                _local_6 = ChatFormats.getTagsByChannel(_local_4.channel);
                _local_7 = ChatFormats.creatGoodTag((("[" + _local_3.Name) + "]"), ChatFormats.CLICK_GOODS, _local_3.TemplateID, _local_3.Quality, _local_3.IsBinds, _local_4);
                _local_4.htmlMessage = ((((_local_6[0] + _local_5) + _local_7) + _local_6[1]) + "<BR>");
                ChatManager.Instance.chat(_local_4, false);
                if (_local_3.Quality >= 3)
                {
                    _local_2 = true;
                };
            };
            return (_local_2);
        }

        public function isIdenticalGame(_arg_1:int=0):Boolean
        {
            var _local_4:RoomPlayer;
            var _local_2:DictionaryData = RoomManager.Instance.current.players;
            var _local_3:SelfInfo = PlayerManager.Instance.Self;
            if (_arg_1 == _local_3.ID)
            {
                return (false);
            };
            for each (_local_4 in _local_2)
            {
                if (((_local_4.playerInfo.ID == _arg_1) && (_local_4.playerInfo.ZoneID == _local_3.ZoneID)))
                {
                    return (true);
                };
            };
            return (false);
        }

        private function __loadResource(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_4:GameNeedMovieInfo;
            var _local_2:int = _arg_1.pkg.readInt();
            var _local_3:int;
            while (_local_3 < _local_2)
            {
                _local_4 = new GameNeedMovieInfo();
                _local_4.type = _arg_1.pkg.readInt();
                _local_4.path = _arg_1.pkg.readUTF();
                _local_4.classPath = _arg_1.pkg.readUTF();
                _local_4.startLoad();
                _local_3++;
            };
        }

        public function get numCreater():BloodNumberCreater
        {
            if (this._numCreater)
            {
                return (this._numCreater);
            };
            this._numCreater = new BloodNumberCreater();
            return (this._numCreater);
        }

        public function disposeNumCreater():void
        {
            if (this._numCreater)
            {
                this._numCreater.dispose();
            };
            this._numCreater = null;
        }

        public function getMinDistanceLiving(_arg_1:Living):Living
        {
            var _local_4:Living;
            var _local_5:Living;
            var _local_2:int = -1;
            var _local_3:int = _arg_1.pos.x;
            for each (_local_5 in this.Current.livings)
            {
                if ((((_local_5.isLiving) && (!(_local_5.typeLiving == 3))) && (!(_local_5 == _arg_1))))
                {
                    if (((_local_2 == -1) || (Math.abs((_local_5.pos.x - _local_3)) < _local_2)))
                    {
                        _local_2 = Math.abs((_local_5.pos.x - _local_3));
                        _local_4 = (_local_5 as Living);
                        _local_4 = _local_5;
                    };
                };
            };
            return (_local_4);
        }

        public function set MissionOverType(_arg_1:uint):void
        {
            this._MissionOverType = _arg_1;
        }

        public function get MissionOverType():uint
        {
            return (this._MissionOverType);
        }


    }
}//package game

