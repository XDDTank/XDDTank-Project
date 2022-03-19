// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//room.RoomManager

package room
{
    import flash.events.EventDispatcher;
    import room.model.RoomInfo;
    import roomList.pvpRoomList.RoomListModel;
    import com.pickgliss.loader.UIModuleLoader;
    import ddt.view.UIModuleSmallLoading;
    import flash.events.Event;
    import com.pickgliss.events.UIModuleEvent;
    import ddt.manager.SocketManager;
    import ddt.events.CrazyTankSocketEvent;
    import room.view.RoomPlayerItem;
    import room.view.ChallengeRoomPlayerItem;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import road7th.comm.PackageIn;
    import com.pickgliss.ui.AlertManager;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.events.FrameEvent;
    import ddt.manager.LeavePageManager;
    import com.pickgliss.utils.ObjectUtils;
    import game.GameManager;
    import ddt.data.player.PlayerInfo;
    import room.model.RoomPlayer;
    import pet.date.PetInfo;
    import roomList.pvpRoomList.SingleRoomView;
    import invite.ResponseInviteFrame;
    import ddt.manager.PlayerManager;
    import ddt.manager.PetInfoManager;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.StateManager;
    import ddt.states.StateType;
    import ddt.data.UIModuleTypes;
    import ddt.loader.StartupResourceLoader;
    import worldboss.WorldBossManager;
    import ddt.manager.MessageTipManager;
    import ddt.data.BuffInfo;
    import ddt.manager.GameInSocketOut;
    import roomList.pvpRoomList.RoomListCreateRoomView;
    import road7th.data.DictionaryData;
    import ddt.data.player.SelfInfo;

    public class RoomManager extends EventDispatcher 
    {

        public static const PAYMENT_TAKE_CARD:String = "PaymentCard";
        public static const LOGIN_ROOM_RESULT:String = "loginRoomResult";
        public static const PLAYER_ROOM_EXIT:String = "PlayerRoomExit";
        public static const ROOM_LIST_LOADED:String = "roomListLoaded";
        public static const ROOM_LOADING_LOADED:String = "roomLoadingLoaded";
        public static const DDTROOM:String = "ddtRoom";
        private static var _instance:RoomManager;

        private var _current:RoomInfo;
        public var _removeRoomMsg:String = "";
        private var _loadedCallBack:Function;
        private var _loadingModuleType:String;
        private var _tempInventPlayerID:int = -1;
        private var _func:Function;
        private var _funcParams:Array;
        private var _loadComplete:Boolean = false;
        private var _model:RoomListModel;
        private var _beforePlace:int = 0;
        private var _findLoginRoom:Boolean = false;


        public static function getTurnTimeByType(_arg_1:int):int
        {
            switch (_arg_1)
            {
                case 1:
                    return (6);
                case 2:
                    return (8);
                case 3:
                    return (11);
                case 4:
                    return (16);
                case 5:
                    return (21);
                case 6:
                    return (31);
                default:
                    return (-1);
            };
        }

        public static function get Instance():RoomManager
        {
            if (_instance == null)
            {
                _instance = new (RoomManager)();
            };
            return (_instance);
        }


        public function showRoomList(_arg_1:Function, _arg_2:String):void
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
                UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__roomListComplete);
                UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS, this.__roomListProgress);
                UIModuleLoader.Instance.addUIModuleImp(_arg_2);
            };
        }

        private function __onClose(_arg_1:Event):void
        {
        }

        protected function __roomListComplete(_arg_1:UIModuleEvent):void
        {
        }

        protected function __roomListProgress(_arg_1:UIModuleEvent):void
        {
            if (_arg_1.module == this._loadingModuleType)
            {
                UIModuleSmallLoading.Instance.progress = (_arg_1.loader.progress * 100);
            };
        }

        public function set current(_arg_1:RoomInfo):void
        {
            this.setCurrent(_arg_1);
        }

        public function get current():RoomInfo
        {
            return (this._current);
        }

        private function setCurrent(_arg_1:RoomInfo):void
        {
            if (this._current)
            {
                this._current.dispose();
            };
            this._current = _arg_1;
        }

        public function createTrainerRoom():void
        {
            this.setCurrent(new RoomInfo());
            this._current.timeType = 3;
        }

        public function setRoomDefyInfo(_arg_1:Array):void
        {
            if (this._current)
            {
                this._current.defyInfo = _arg_1;
            };
        }

        public function setup():void
        {
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_ROOM_CREATE, this.__createRoom);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_ROOM_LOGIN, this.__loginRoomResult);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_ROOM_SETUP_CHANGE, this.__settingRoom);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_ROOM_UPDATE_PLACE, this.__updateRoomPlaces);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_PLAYER_STATE_CHANGE, this.__playerStateChange);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GMAE_STYLE_RECV, this.__updateGameStyle);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_TEAM, this.__setPlayerTeam);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.NETWORK, this.__netWork);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.BUFF_OBTAIN, this.__buffObtain);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.BUFF_UPDATE, this.__buffUpdate);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_WAIT_FAILED, this.__waitGameFailed);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_WAIT_RECV, this.__waitGameRecv);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_AWIT_CANCEL, this.__waitCancel);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_PLAYER_ENTER, this.__addPlayerInRoom);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_PLAYER_EXIT, this.__removePlayerInRoom);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.INSUFFICIENT_MONEY, this.__paymentFailed);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.RANDOM_PVE, this.__randomPve);
        }

        public function canCloseItem(_arg_1:RoomPlayerItem):Boolean
        {
            var _local_2:int = _arg_1.place;
            var _local_3:uint = 3;
            var _local_4:Array = this._current.placesState;
            var _local_5:int;
            while (_local_5 < 6)
            {
                if ((_local_5 % 2) == (_local_2 % 2))
                {
                    if (_local_4[_local_5] == 0)
                    {
                        _local_3--;
                    };
                };
                _local_5++;
            };
            if (_local_3 <= 1)
            {
                return (false);
            };
            return (true);
        }

        public function canSmallCloseItem(_arg_1:ChallengeRoomPlayerItem):Boolean
        {
            var _local_2:int = _arg_1.place;
            var _local_3:uint = 3;
            var _local_4:Array = this._current.placesState;
            var _local_5:int;
            while (_local_5 < 6)
            {
                if ((_local_5 % 2) == (_local_2 % 2))
                {
                    if (_local_4[_local_5] == 0)
                    {
                        _local_3--;
                    };
                };
                _local_5++;
            };
            if (_local_3 <= 1)
            {
                return (false);
            };
            return (true);
        }

        private function __paymentFailed(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_5:BaseAlerFrame;
            var _local_6:BaseAlerFrame;
            var _local_7:BaseAlerFrame;
            var _local_2:PackageIn = _arg_1.pkg;
            var _local_3:int = _local_2.readByte();
            var _local_4:Boolean = _local_2.readBoolean();
            if (_local_3 == 0)
            {
                if ((!(_local_4)))
                {
                    _local_5 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tank.room.RoomIIView2.notenoughmoney.title"), LanguageMgr.GetTranslation("tank.room.RoomIIView2.notenoughmoney.content"), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), false, true, true, LayerManager.ALPHA_BLOCKGOUND);
                    _local_5.addEventListener(FrameEvent.RESPONSE, this._responseI);
                };
            }
            else
            {
                if (_local_3 == 1)
                {
                    if ((!(_local_4)))
                    {
                        dispatchEvent(new Event(PAYMENT_TAKE_CARD));
                        _local_6 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tank.room.RoomIIView2.notenoughmoney.title"), LanguageMgr.GetTranslation("tank.room.RoomIIView2.notenoughmoney.content"), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), false, true, true, LayerManager.ALPHA_BLOCKGOUND);
                        if (_local_6.parent)
                        {
                            _local_6.parent.removeChild(_local_6);
                        };
                        LayerManager.Instance.addToLayer(_local_6, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.ALPHA_BLOCKGOUND);
                        _local_6.addEventListener(FrameEvent.RESPONSE, this._responseI);
                    };
                }
                else
                {
                    if (_local_3 == 2)
                    {
                        if ((!(_local_4)))
                        {
                            _local_7 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tank.room.RoomIIView2.notenoughmoney.title"), LanguageMgr.GetTranslation("tank.room.RoomIIView2.notenoughmoney.content"), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), false, true, true, LayerManager.ALPHA_BLOCKGOUND);
                            _local_7.addEventListener(FrameEvent.RESPONSE, this._responseII);
                        };
                    };
                };
            };
        }

        private function _responseI(_arg_1:FrameEvent):void
        {
            (_arg_1.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE, this._responseI);
            if (((_arg_1.responseCode == FrameEvent.SUBMIT_CLICK) || (_arg_1.responseCode == FrameEvent.ENTER_CLICK)))
            {
                LeavePageManager.leaveToFillPath();
            };
            ObjectUtils.disposeObject(_arg_1.currentTarget);
        }

        private function _responseII(_arg_1:FrameEvent):void
        {
            (_arg_1.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE, this._responseII);
            if (((_arg_1.responseCode == FrameEvent.SUBMIT_CLICK) || (_arg_1.responseCode == FrameEvent.ENTER_CLICK)))
            {
                this.__toPaymentTryagainHandler();
            }
            else
            {
                this.__cancelPaymenttryagainHandler();
            };
            ObjectUtils.disposeObject(_arg_1.currentTarget);
        }

        private function __toPaymentTryagainHandler():void
        {
            LeavePageManager.leaveToFillPath();
            GameManager.Instance.dispatchPaymentConfirm();
        }

        private function __cancelPaymenttryagainHandler():void
        {
            GameManager.Instance.dispatchLeaveMission();
        }

        private function __createRoom(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_3:RoomInfo;
            var _local_2:PackageIn = _arg_1.pkg;
            _local_3 = new RoomInfo();
            _local_3.ID = _local_2.readInt();
            _local_3.type = _local_2.readByte();
            _local_3.hardLevel = _local_2.readByte();
            _local_3.timeType = _local_2.readByte();
            _local_3.totalPlayer = _local_2.readByte();
            _local_3.viewerCnt = _local_2.readByte();
            _local_3.placeCount = _local_2.readByte();
            _local_3.isLocked = _local_2.readBoolean();
            _local_3.mapId = _local_2.readInt();
            _local_3.started = _local_2.readBoolean();
            _local_3.Name = _local_2.readUTF();
            _local_3.gameMode = _local_2.readByte();
            _local_3.levelLimits = _local_2.readInt();
            _local_3.isCrossZone = _local_2.readBoolean();
            _local_3.isWithinLeageTime = _local_2.readBoolean();
            this.setCurrent(_local_3);
            dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_ROOM_CREATE));
        }

        public function set tempInventPlayerID(_arg_1:int):void
        {
            this._tempInventPlayerID = _arg_1;
        }

        public function get tempInventPlayerID():int
        {
            return (this._tempInventPlayerID);
        }

        public function haveTempInventPlayer():Boolean
        {
            return (!(this._tempInventPlayerID == -1));
        }

        private function __loginRoomResult(_arg_1:CrazyTankSocketEvent):void
        {
            dispatchEvent(new Event(LOGIN_ROOM_RESULT));
            if (_arg_1.pkg.readBoolean() == false)
            {
                this.findLoginRoom = false;
            };
        }

        private function __addPlayerInRoom(evt:CrazyTankSocketEvent):void
        {
            var pkg:PackageIn;
            var id:int;
            var isInGame:Boolean;
            var pos:int;
            var team:int;
            var isFirstIn:Boolean;
            var level:int;
            var offer:int;
            var hide:int;
            var repute:int;
            var speed:int;
            var zoneID:int;
            var info:PlayerInfo;
            var fpInfo:RoomPlayer;
            var unknown1:int;
            var unknown2:int;
            var hasPet:Boolean;
            var place:int;
            var templateID:int;
            var fightPet:PetInfo;
            var skillCount:int;
            var i:int;
            var skillplace:int;
            var sID:int;
            var si:SingleRoomView;
            ResponseInviteFrame.clearInviteFrame();
            if (this._current)
            {
                pkg = evt.pkg;
                id = pkg.clientId;
                isInGame = pkg.readBoolean();
                pos = pkg.readByte();
                team = pkg.readByte();
                isFirstIn = pkg.readBoolean();
                level = pkg.readInt();
                offer = pkg.readInt();
                hide = pkg.readInt();
                repute = pkg.readInt();
                speed = pkg.readInt();
                zoneID = pkg.readInt();
                if (id != PlayerManager.Instance.Self.ID)
                {
                    info = PlayerManager.Instance.findPlayer(id);
                    info.beginChanges();
                    info.ID = pkg.readInt();
                    info.NickName = pkg.readUTF();
                    info.VIPtype = pkg.readByte();
                    info.VIPLevel = pkg.readInt();
                    info.Sex = pkg.readBoolean();
                    info.Style = pkg.readUTF();
                    info.Colors = pkg.readUTF();
                    info.Skin = pkg.readUTF();
                    info.WeaponID = pkg.readInt();
                    info.DeputyWeaponID = pkg.readInt();
                    info.Repute = repute;
                    info.Grade = level;
                    info.Offer = offer;
                    info.Hide = hide;
                    info.ConsortiaID = pkg.readInt();
                    info.ConsortiaName = pkg.readUTF();
                    info.badgeID = pkg.readInt();
                    info.WinCount = pkg.readInt();
                    info.TotalCount = pkg.readInt();
                    info.EscapeCount = pkg.readInt();
                    unknown1 = pkg.readInt();
                    unknown2 = pkg.readInt();
                    info.IsMarried = pkg.readBoolean();
                    if (info.IsMarried)
                    {
                        info.SpouseID = pkg.readInt();
                        info.SpouseName = pkg.readUTF();
                    }
                    else
                    {
                        info.SpouseID = 0;
                        info.SpouseName = "";
                    };
                    info.LoginName = pkg.readUTF();
                    info.Nimbus = pkg.readInt();
                    info.FightPower = pkg.readInt();
                    info.apprenticeshipState = pkg.readInt();
                    info.masterID = pkg.readInt();
                    info.setMasterOrApprentices(pkg.readUTF());
                    info.graduatesCount = pkg.readInt();
                    info.honourOfMaster = pkg.readUTF();
                    info.DailyLeagueFirst = pkg.readBoolean();
                    info.DailyLeagueLastScore = pkg.readInt();
                    info.isOld = pkg.readBoolean();
                    info.MilitaryRankTotalScores = pkg.readInt();
                    hasPet = pkg.readBoolean();
                    if (hasPet)
                    {
                        place = pkg.readInt();
                        templateID = pkg.readInt();
                        fightPet = PetInfoManager.instance.getPetInfoByTemplateID(templateID);
                        fightPet.Place = place;
                        fightPet.ID = pkg.readInt();
                        fightPet.Name = pkg.readUTF();
                        fightPet.UserID = pkg.readInt();
                        fightPet.Level = pkg.readInt();
                        fightPet.clearSkills();
                        skillCount = pkg.readInt();
                        i = 0;
                        while (i < skillCount)
                        {
                            skillplace = pkg.readInt();
                            sID = pkg.readInt();
                            fightPet.addSkill(skillplace, sID);
                            i = (i + 1);
                        };
                        info.pets.add(fightPet.Place, fightPet);
                        if (fightPet.Place == 0)
                        {
                            info.currentPet = fightPet;
                        };
                    };
                    info.commitChanges();
                }
                else
                {
                    info = PlayerManager.Instance.Self;
                };
                info.ZoneID = zoneID;
                if (GameManager.Instance.Current != null)
                {
                    fpInfo = GameManager.Instance.Current.findRoomPlayer(id, zoneID);
                };
                if (fpInfo == null)
                {
                    fpInfo = new RoomPlayer(info);
                };
                fpInfo.isFirstIn = isFirstIn;
                fpInfo.place = pos;
                fpInfo.team = team;
                fpInfo.webSpeedInfo.delay = speed;
                this._current.addPlayer(fpInfo);
                if (((fpInfo.isSelf) && (this._current)))
                {
                    if (this._current.type == RoomInfo.SINGLE_ROOM)
                    {
                        si = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroomList.RoomList.SingleRoomView");
                        si.initII(this._current);
                        si.show();
                    }
                    else
                    {
                        if (this._current.type != 5)
                        {
                            if (((this._current.type == RoomInfo.MATCH_ROOM) || (this._current.type == RoomInfo.MULTI_MATCH)))
                            {
                                RoomManager.Instance.showRoomList(function ():void
                                {
                                    StateManager.setState(StateType.MATCH_ROOM);
                                }, UIModuleTypes.DDTROOM);
                            }
                            else
                            {
                                if (this._current.type == RoomInfo.CHALLENGE_ROOM)
                                {
                                    RoomManager.Instance.showRoomList(function ():void
                                    {
                                        StateManager.setState(StateType.CHALLENGE_ROOM);
                                    }, UIModuleTypes.DDTROOM);
                                }
                                else
                                {
                                    if (this._current.type == RoomInfo.DUNGEON_ROOM)
                                    {
                                        RoomManager.Instance.showRoomList(function ():void
                                        {
                                            StateManager.setState(StateType.DUNGEON_ROOM);
                                        }, UIModuleTypes.DDTROOM);
                                    }
                                    else
                                    {
                                        if (this._current.type == RoomInfo.FRESHMAN_ROOM)
                                        {
                                            if (StartupResourceLoader.firstEnterHall)
                                            {
                                                RoomManager.Instance.showRoomList(function ():void
                                                {
                                                    StateManager.setState(StateType.FRESHMAN_ROOM2);
                                                }, UIModuleTypes.DDTROOM);
                                            }
                                            else
                                            {
                                                RoomManager.Instance.showRoomList(function ():void
                                                {
                                                    StateManager.setState(StateType.FRESHMAN_ROOM1);
                                                }, UIModuleTypes.DDTROOM);
                                            };
                                        }
                                        else
                                        {
                                            if (this._current.type == RoomInfo.WORLD_BOSS_FIGHT)
                                            {
                                                WorldBossManager.Instance.enterGame();
                                            }
                                            else
                                            {
                                                if (this._current.type == RoomInfo.CHANGE_DUNGEON)
                                                {
                                                    RoomManager.Instance.showRoomList(function ():void
                                                    {
                                                        StateManager.setState(StateType.DUNGEON_ROOM);
                                                    }, UIModuleTypes.DDTROOM);
                                                }
                                                else
                                                {
                                                    if (this._current.type == RoomInfo.MULTI_DUNGEON)
                                                    {
                                                        RoomManager.Instance.showRoomList(function ():void
                                                        {
                                                            StateManager.setState(StateType.DUNGEON_ROOM);
                                                        }, UIModuleTypes.DDTROOM);
                                                    };
                                                };
                                            };
                                        };
                                    };
                                };
                            };
                        };
                    };
                };
            };
        }

        private function __removePlayerInRoom(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:int;
            var _local_3:int;
            var _local_4:RoomPlayer;
            if (this._current)
            {
                _local_2 = _arg_1.pkg.clientId;
                _local_3 = _arg_1.pkg.readInt();
                _local_4 = this._current.findPlayerByID(_local_2, _local_3);
                if (((_local_4) && (_local_4.isSelf)))
                {
                    if (((StateManager.currentStateType == StateType.MATCH_ROOM) || (StateManager.currentStateType == StateType.CHALLENGE_ROOM)))
                    {
                        StateManager.setState(StateType.MAIN);
                    }
                    else
                    {
                        if (((StateManager.currentStateType == StateType.DUNGEON_ROOM) || (StateManager.currentStateType == StateType.MISSION_ROOM)))
                        {
                            StateManager.setState(StateType.MAIN);
                        }
                        else
                        {
                            if (StateManager.currentStateType == StateType.FIGHT_LIB_GAMEVIEW)
                            {
                                StateManager.setState(StateType.MAIN);
                            }
                            else
                            {
                                if (((((StateManager.isInFight) || (StateManager.currentStateType == StateType.MULTISHOOT_FIGHTING)) || (StateManager.currentStateType == StateType.ROOM_LOADING)) || (StateManager.currentStateType == StateType.GAME_LOADING)))
                                {
                                    if (this._current.type == RoomInfo.DUNGEON_ROOM)
                                    {
                                        StateManager.setState(StateType.MAIN);
                                    }
                                    else
                                    {
                                        if (this._current.type != RoomInfo.WORLD_BOSS_FIGHT)
                                        {
                                            if (this._current.type == RoomInfo.SINGLE_DUNGEON)
                                            {
                                                StateManager.setState(StateType.SINGLEDUNGEON);
                                            }
                                            else
                                            {
                                                if (((this._current.type == RoomInfo.CONSORTION_MONSTER) && (!(PlayerManager.Instance.Self.ConsortiaID == 0))))
                                                {
                                                    SocketManager.Instance.out.SendenterConsortion();
                                                }
                                                else
                                                {
                                                    StateManager.setState(StateType.MAIN);
                                                };
                                            };
                                        };
                                    };
                                };
                            };
                        };
                    };
                    PlayerManager.Instance.Self.unlockAllBag();
                }
                else
                {
                    if (GameManager.Instance.Current)
                    {
                        GameManager.Instance.Current.removeRoomPlayer(_local_3, _local_2);
                        GameManager.Instance.Current.removeGamePlayerByPlayerID(_local_3, _local_2);
                    };
                    this._current.removePlayer(_local_3, _local_2);
                };
                dispatchEvent(new Event(PLAYER_ROOM_EXIT));
            };
        }

        private function __playerStateChange(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:Array;
            var _local_3:int;
            if (this._current)
            {
                _local_2 = new Array();
                _local_3 = 0;
                while (_local_3 < 6)
                {
                    _local_2[_local_3] = _arg_1.pkg.readByte();
                    _local_3++;
                };
                this._current.updatePlayerState(_local_2);
            };
        }

        public function findRoomPlayer(_arg_1:int):RoomPlayer
        {
            if (this._current)
            {
                return (this._current.players[_arg_1] as RoomPlayer);
            };
            return (null);
        }

        private function __settingRoom(_arg_1:CrazyTankSocketEvent):void
        {
            if (this._current == null)
            {
                return;
            };
            var _local_2:Boolean = _arg_1.pkg.readBoolean();
            this._current.type = _arg_1.pkg.readByte();
            if (((_local_2) || ((StateManager.currentStateType == StateType.SINGLEDUNGEON) && (!(this._current.type == RoomInfo.HIJACK_CAR)))))
            {
                this._current.pic = _arg_1.pkg.readUTF();
                if (((!(RoomManager.Instance.current.selfRoomPlayer.isHost)) && (!(StateManager.currentStateType == StateType.DUNGEON_ROOM))))
                {
                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("BaseRoomView.getout.bossRoom"));
                };
            };
            this._current.isOpenBoss = _local_2;
            this._current.mapId = _arg_1.pkg.readInt();
            this._current.roomPass = _arg_1.pkg.readUTF();
            this._current.roomName = _arg_1.pkg.readUTF();
            this._current.timeType = _arg_1.pkg.readByte();
            this._current.hardLevel = _arg_1.pkg.readByte();
            this._current.levelLimits = _arg_1.pkg.readInt();
            this._current.isCrossZone = _arg_1.pkg.readBoolean();
            dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_ROOM_SETUP_CHANGE));
        }

        private function __updateRoomPlaces(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:Array = new Array();
            var _local_3:int;
            while (_local_3 < 8)
            {
                _local_2[_local_3] = _arg_1.pkg.readInt();
                _local_3++;
            };
            if (this._current)
            {
                this._current.updatePlaceState(_local_2);
            };
        }

        private function __updateGameStyle(_arg_1:CrazyTankSocketEvent):void
        {
            if (this._current == null)
            {
                return;
            };
            this._current.gameMode = _arg_1.pkg.readByte();
        }

        private function __setPlayerTeam(_arg_1:CrazyTankSocketEvent):void
        {
            if (this._current == null)
            {
                return;
            };
            this._current.updatePlayerTeam(_arg_1.pkg.clientId, _arg_1.pkg.readByte(), _arg_1.pkg.readByte());
        }

        private function __netWork(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:PlayerInfo = PlayerManager.Instance.findPlayer(_arg_1.pkg.clientId);
            var _local_3:int = _arg_1.pkg.readInt();
            if (_local_2)
            {
                _local_2.webSpeed = _local_3;
            };
        }

        private function __buffObtain(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_3:int;
            var _local_4:int;
            var _local_5:int;
            var _local_6:Boolean;
            var _local_7:Date;
            var _local_8:int;
            var _local_9:int;
            var _local_10:BuffInfo;
            var _local_2:PackageIn = _arg_1.pkg;
            if (_local_2.clientId == PlayerManager.Instance.Self.ID)
            {
                return;
            };
            if (this._current.findPlayerByID(_local_2.clientId) != null)
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
                    this._current.findPlayerByID(_local_2.clientId).playerInfo.buffInfo.add(_local_10.Type, _local_10);
                    _local_4++;
                };
                _arg_1.stopImmediatePropagation();
            };
        }

        private function __buffUpdate(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_3:int;
            var _local_4:int;
            var _local_5:int;
            var _local_6:Boolean;
            var _local_7:Date;
            var _local_8:int;
            var _local_9:int;
            var _local_10:BuffInfo;
            var _local_2:PackageIn = _arg_1.pkg;
            if (_local_2.clientId == PlayerManager.Instance.Self.ID)
            {
                return;
            };
            if (this._current.findPlayerByID(_local_2.clientId) != null)
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
                    if (_local_6)
                    {
                        this._current.findPlayerByID(_local_2.clientId).playerInfo.buffInfo.add(_local_10.Type, _local_10);
                    }
                    else
                    {
                        this._current.findPlayerByID(_local_2.clientId).playerInfo.buffInfo.remove(_local_10.Type);
                    };
                    _local_4++;
                };
                _arg_1.stopImmediatePropagation();
            };
        }

        private function __randomPve(_arg_1:CrazyTankSocketEvent):void
        {
            GameInSocketOut.sendGameRoomSetUp(17, RoomInfo.DUNGEON_ROOM, false, "", RoomListCreateRoomView.PREWORD[int((Math.random() * RoomListCreateRoomView.PREWORD.length))], 1, 0, 0, false, 17);
        }

        private function __waitGameFailed(_arg_1:CrazyTankSocketEvent):void
        {
            if (this._current)
            {
                this._current.pickupFailed();
            };
        }

        private function __waitGameRecv(_arg_1:CrazyTankSocketEvent):void
        {
            if (this._current)
            {
                this._current.startPickup();
            };
        }

        private function __waitCancel(_arg_1:CrazyTankSocketEvent):void
        {
            if (this._current)
            {
                this._current.cancelPickup();
            };
        }

        public function resetAllPlayerState():void
        {
            var _local_1:RoomPlayer;
            for each (_local_1 in this._current.players)
            {
                _local_1.isReady = false;
                _local_1.progress = 0;
                if (this._current.type != RoomInfo.CHALLENGE_ROOM)
                {
                    _local_1.team = 1;
                };
            };
        }

        public function isIdenticalRoom(_arg_1:int=0, _arg_2:String=""):Boolean
        {
            var _local_5:RoomPlayer;
            var _local_3:DictionaryData = this.current.players;
            var _local_4:SelfInfo = PlayerManager.Instance.Self;
            if (_arg_1 == _local_4.ID)
            {
                return (false);
            };
            for each (_local_5 in _local_3)
            {
                if (((_local_5.playerInfo.ID == _arg_1) || (_local_5.playerInfo.NickName == _arg_2)))
                {
                    return (true);
                };
            };
            return (false);
        }

        public function get loadComplete():Boolean
        {
            return (this._loadComplete);
        }

        public function set model(_arg_1:RoomListModel):void
        {
            this._model = _arg_1;
        }

        public function get model():RoomListModel
        {
            return (this._model);
        }

        public function reset():void
        {
            if (this._current)
            {
                this._current.dispose();
                this._current = null;
            };
        }

        public function set beforePlace(_arg_1:int):void
        {
            this._beforePlace = _arg_1;
        }

        public function get beforePlace():int
        {
            return (this._beforePlace);
        }

        public function set findLoginRoom(_arg_1:Boolean):void
        {
            this._findLoginRoom = _arg_1;
        }

        public function get findLoginRoom():Boolean
        {
            return (this._findLoginRoom);
        }


    }
}//package room

