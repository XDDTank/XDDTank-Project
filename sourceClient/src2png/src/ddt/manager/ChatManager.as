// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.manager.ChatManager

package ddt.manager
{
    import flash.events.EventDispatcher;
    import shop.view.NewShopBugleView;
    import ddt.view.chat.ChatView;
    import ddt.view.chat.ChatModel;
    import com.pickgliss.debug.DebugStats;
    import ddt.states.StateType;
    import ddt.view.chat.ChatFormats;
    import ddt.utils.Helpers;
    import ddt.view.chat.ChatData;
    import ddt.view.chat.ChatInputView;
    import ddt.view.chat.ChatOutputView;
    import baglocked.BaglockedManager;
    import ddt.data.EquipType;
    import com.pickgliss.ui.LayerManager;
    import ddt.view.chat.ChatEvent;
    import com.pickgliss.toplevel.StageReferance;
    import flash.events.ErrorEvent;
    import road7th.utils.StringHelper;
    import road7th.comm.PackageIn;
    import ddt.events.CrazyTankSocketEvent;
    import flash.events.Event;
    import ddt.data.goods.ItemTemplateInfo;
    import flash.utils.setTimeout;
    import ddt.data.goods.InventoryItemInfo;
    import im.IMController;
    import room.RoomManager;
    import game.GameManager;
    import ddt.utils.ChatHelper;
    import turnplate.TurnPlateController;
    import road7th.data.DictionaryData;
    import ddt.data.player.PlayerInfo;
    import com.pickgliss.ui.ComponentFactory;
    import road7th.comm.PackageOut;
    import ddt.data.socket.ePackageType;
    import ddt.view.chat.chat_system; 

    use namespace chat_system;

    public final class ChatManager extends EventDispatcher 
    {

        public static const CHAT_HALL_STATE:int = 0;
        public static const CHAT_GAME_STATE:int = 1;
        public static const CHAT_WEDDINGLIST_STATE:int = 3;
        public static const CHAT_WEDDINGROOM_STATE:int = 4;
        public static const CHAT_ROOM_STATE:int = 5;
        public static const CHAT_ROOMLIST_STATE:int = 6;
        public static const CHAT_DUNGEONLIST_STATE:int = 7;
        public static const CHAT_GAMEOVER_STATE:int = 8;
        public static const CHAT_GAME_LOADING:int = 9;
        public static const CHAT_DUNGEON_STATE:int = 10;
        public static const CHAT_CONSORTIA_VIEW:int = 12;
        public static const CHAT_CONSORTIA_TRANSPORT_VIEW:int = 13;
        public static const CHAT_CIVIL_VIEW:int = 14;
        public static const CHAT_TOFFLIST_VIEW:int = 15;
        public static const CHAT_SHOP_STATE:int = 16;
        public static const CHAT_HOTSPRING_VIEW:int = 17;
        public static const CHAT_HOTSPRING_ROOM_VIEW:int = 18;
        public static const CHAT_HOTSPRING_ROOM_GOLD_VIEW:int = 19;
        public static const CHAT_TRAINER_STATE:int = 20;
        public static const CHAT_GAMEOVER_TROPHY:int = 21;
        public static const CHAT_TRAINER_ROOM_LOADING:int = 22;
        public static const CHAT_LITTLEHALL:int = 26;
        public static const CHAT_LITTLEGAME:int = 24;
        public static const CHAT_FARM:int = 27;
        public static const CHAT_ARENA:int = 29;
        public static const CHAT_MULTI_SHOOT_GAME_STATE:int = 30;
        public static const CHAT_FIGHT_LIB:int = 23;
        public static const CHAT_ACADEMY_VIEW:int = 25;
        private static const CHAT_LEVEL:int = 1;
        public static const CHAT_WORLDBOS_ROOM:int = 28;
        public static var SHIELD_NOTICE:Boolean = false;
        private static var _instance:ChatManager;

        private var _shopBugle:NewShopBugleView;
        public var chatDisabled:Boolean = false;
        private var _chatView:ChatView;
        private var _model:ChatModel;
        private var _state:int = -1;
        private var _visibleSwitchEnable:Boolean = false;
        private var _focusFuncEnabled:Boolean = true;
        private var fpsContainer:DebugStats;
        private var _firstsetup:Boolean = true;
        private var _outputState:Boolean = false;
        private var _reportMsg:String = "";


        public static function get Instance():ChatManager
        {
            if (_instance == null)
            {
                _instance = new (ChatManager)();
            };
            return (_instance);
        }


        public function chat(_arg_1:ChatData, _arg_2:Boolean=true):void
        {
            if (StateManager.currentStateType != StateType.SINGLEDUNGEON)
            {
                if (this.chatDisabled)
                {
                    return;
                };
            };
            if (_arg_2)
            {
                ChatFormats.formatChatStyle(_arg_1);
            };
            _arg_1.htmlMessage = Helpers.deCodeString(_arg_1.htmlMessage);
            this._model.addChat(_arg_1);
        }

        public function get isInGame():Boolean
        {
            if (StateManager.currentStateType == StateType.SINGLEDUNGEON)
            {
                return (false);
            };
            return (this.output.isInGame());
        }

        public function set focusFuncEnabled(_arg_1:Boolean):void
        {
            this._focusFuncEnabled = _arg_1;
        }

        public function get focusFuncEnabled():Boolean
        {
            return (this._focusFuncEnabled);
        }

        public function get input():ChatInputView
        {
            return (this._chatView.input);
        }

        public function set inputChannel(_arg_1:int):void
        {
            this._chatView.input.channel = _arg_1;
        }

        public function get lock():Boolean
        {
            return (this._chatView.output.isLock);
        }

        public function set lock(_arg_1:Boolean):void
        {
            this._chatView.output.isLock = _arg_1;
        }

        public function get model():ChatModel
        {
            return (this._model);
        }

        public function get output():ChatOutputView
        {
            return (this._chatView.output);
        }

        public function set outputChannel(_arg_1:int):void
        {
            this._chatView.output.channel = _arg_1;
        }

        public function privateChatTo(_arg_1:String, _arg_2:int=0, _arg_3:Object=null):void
        {
            this._chatView.input.setPrivateChatTo(_arg_1, _arg_2, _arg_3);
        }

        public function sendBugle(_arg_1:String, _arg_2:int):void
        {
            if (((PlayerManager.Instance.Self.bagPwdState) && (PlayerManager.Instance.Self.bagLocked)))
            {
                BaglockedManager.Instance.show();
                this.input.setInputText(_arg_1);
                return;
            };
            if (_arg_2 == EquipType.T_BBUGLE)
            {
                if (((PlayerManager.Instance.Self.Bag.getItemCountByTemplateId(EquipType.T_BBUGLE, true) <= 0) && (PlayerManager.Instance.Self.Bag.getItemCountByTemplateId(EquipType.T_CBUGLE, true) <= 0)))
                {
                    this.showShopBugleView(_arg_1, _arg_2);
                }
                else
                {
                    this.confirmSendMsg(_arg_1, _arg_2);
                };
            }
            else
            {
                if (PlayerManager.Instance.Self.Bag.getItemCountByTemplateId(_arg_2, true) <= 0)
                {
                    this.showShopBugleView(_arg_1, _arg_2);
                }
                else
                {
                    this.confirmSendMsg(_arg_1, _arg_2);
                };
            };
        }

        private function showShopBugleView(_arg_1:String, _arg_2:int):void
        {
            if (ShopManager.Instance.getMoneyShopItemByTemplateID(_arg_2))
            {
                this.input.setInputText(_arg_1);
            };
            this.sysChatYellow(LanguageMgr.GetTranslation("tank.manager.ChatManager.tool"));
            if (((!(this._shopBugle)) || (!(this._shopBugle.info))))
            {
                this._shopBugle = new NewShopBugleView(_arg_2);
            }
            else
            {
                if (this._shopBugle.type != _arg_2)
                {
                    this._shopBugle.dispose();
                    this._shopBugle = null;
                    this._shopBugle = new NewShopBugleView(_arg_2);
                };
            };
        }

        private function confirmSendMsg(_arg_1:String, _arg_2:int):void
        {
            _arg_1 = Helpers.enCodeString(_arg_1);
            if (_arg_2 == EquipType.T_SBUGLE)
            {
                SocketManager.Instance.out.sendSBugle(_arg_1);
            }
            else
            {
                if (_arg_2 == EquipType.T_BBUGLE)
                {
                    SocketManager.Instance.out.sendCBugle(_arg_1);
                }
                else
                {
                    if (_arg_2 == EquipType.T_CBUGLE)
                    {
                        SocketManager.Instance.out.sendCBugle(_arg_1);
                    };
                };
            };
        }

        public function sendChat(_arg_1:ChatData):void
        {
            if (_arg_1.msg == "showDebugStatus -fps")
            {
                if ((!(this.fpsContainer)))
                {
                    this.fpsContainer = new DebugStats();
                    LayerManager.Instance.addToLayer(this.fpsContainer, LayerManager.STAGE_TOP_LAYER);
                }
                else
                {
                    if (this.fpsContainer.parent)
                    {
                        this.fpsContainer.parent.removeChild(this.fpsContainer);
                    };
                    this.fpsContainer = null;
                };
                return;
            };
            if (this.chatDisabled)
            {
                return;
            };
            if (_arg_1.channel == ChatInputView.PRIVATE)
            {
                this.sendPrivateMessage(_arg_1.receiver, _arg_1.msg, _arg_1.receiverID);
            }
            else
            {
                if (_arg_1.channel == ChatInputView.CROSS_BUGLE)
                {
                    this.sendBugle(_arg_1.msg, EquipType.T_BBUGLE);
                }
                else
                {
                    if (_arg_1.channel == ChatInputView.BIG_BUGLE)
                    {
                        this.sendBugle(_arg_1.msg, EquipType.T_BBUGLE);
                    }
                    else
                    {
                        if (_arg_1.channel == ChatInputView.SMALL_BUGLE)
                        {
                            this.sendBugle(_arg_1.msg, EquipType.T_SBUGLE);
                        }
                        else
                        {
                            if (_arg_1.channel == ChatInputView.CONSORTIA)
                            {
                                this.sendMessage(_arg_1.channel, _arg_1.sender, _arg_1.msg, false);
                                dispatchEvent(new ChatEvent(ChatEvent.SEND_CONSORTIA));
                            }
                            else
                            {
                                if (_arg_1.channel == ChatInputView.TEAM)
                                {
                                    this.sendMessage(_arg_1.channel, _arg_1.sender, _arg_1.msg, true);
                                }
                                else
                                {
                                    if (_arg_1.channel == ChatInputView.CURRENT)
                                    {
                                        this.sendMessage(_arg_1.channel, _arg_1.sender, _arg_1.msg, false);
                                    }
                                    else
                                    {
                                        if (_arg_1.channel == ChatInputView.CHURCH_CHAT)
                                        {
                                            this.sendMessage(_arg_1.channel, _arg_1.sender, _arg_1.msg, false);
                                        }
                                        else
                                        {
                                            if (_arg_1.channel == ChatInputView.HOTSPRING_ROOM)
                                            {
                                                this.sendMessage(_arg_1.channel, _arg_1.sender, _arg_1.msg, false);
                                            }
                                            else
                                            {
                                                if (_arg_1.channel == ChatInputView.WORLDBOSS_ROOM)
                                                {
                                                    this.sendMessage(_arg_1.channel, _arg_1.sender, _arg_1.msg, false);
                                                }
                                                else
                                                {
                                                    if (_arg_1.channel == ChatInputView.CONSORTIA_VIEW)
                                                    {
                                                        this.sendMessage(_arg_1.channel, _arg_1.sender, _arg_1.msg, false);
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

        public function sendFace(_arg_1:int):void
        {
            SocketManager.Instance.out.sendFace(_arg_1);
        }

        public function setFocus():void
        {
            this._chatView.input.inputField.setFocus();
        }

        public function releaseFocus():void
        {
            StageReferance.stage.focus = StageReferance.stage;
        }

        public function setup():void
        {
            if (this._firstsetup)
            {
                if (this._chatView)
                {
                    throw (new ErrorEvent("ChatManager setup Error :", false, false, ""));
                };
                this.initView();
                this.initEvent();
                this._firstsetup = false;
            };
        }

        public function get state():int
        {
            return (this._state);
        }

        public function set state(_arg_1:int):void
        {
            if ((((this._state == _arg_1) && (!(this._state == ChatManager.CHAT_WORLDBOS_ROOM))) && (!(this._state == ChatManager.CHAT_CONSORTIA_VIEW))))
            {
                return;
            };
            this._state = _arg_1;
            this._chatView.state = this._state;
        }

        public function switchVisible():void
        {
            if (this._visibleSwitchEnable)
            {
                if (this._chatView.input.parent)
                {
                    this._chatView.input.parent.removeChild(this._chatView.input);
                    this._chatView.output.functionEnabled = false;
                    this._chatView.input.fastReplyPanel.isEditing = false;
                    StageReferance.stage.focus = null;
                    if (((!(this._chatView.lockSlide)) && (this._outputState)))
                    {
                        this._outputState = false;
                        this._chatView.currentType = false;
                    };
                }
                else
                {
                    this._chatView.addChild(this.input);
                    this._chatView.output.functionEnabled = true;
                    this._chatView.input.inputField.setFocus();
                    if (((!(this._chatView.lockSlide)) && (this._chatView.currentType == false)))
                    {
                        this._outputState = true;
                        this._chatView.currentType = true;
                    };
                };
            };
            this._chatView.input.hidePanel();
        }

        public function setViewVisible(_arg_1:Boolean):void
        {
            if (((this._chatView.canSlide) && (!(this._chatView.lockSlide))))
            {
                this._chatView.currentType = _arg_1;
            };
        }

        public function sysChatRed(_arg_1:String):void
        {
            var _local_2:ChatData = new ChatData();
            _local_2.channel = ChatInputView.SYS_NOTICE;
            _local_2.msg = StringHelper.trim(_arg_1);
            this.chat(_local_2);
        }

        public function sysChatYellow(_arg_1:String):void
        {
            var _local_2:ChatData = new ChatData();
            _local_2.channel = ChatInputView.SYS_TIP;
            _local_2.msg = StringHelper.trim(_arg_1);
            this.chat(_local_2);
        }

        public function sysChatLinkYellow(_arg_1:String):void
        {
            var _local_2:ChatData = new ChatData();
            _local_2.type = ChatFormats.CLICK_EFFORT;
            _local_2.channel = ChatInputView.SYS_TIP;
            _local_2.msg = StringHelper.trim(_arg_1);
            this.chat(_local_2);
        }

        public function get view():ChatView
        {
            return (this._chatView);
        }

        public function get visibleSwitchEnable():Boolean
        {
            return (this._visibleSwitchEnable);
        }

        public function set visibleSwitchEnable(_arg_1:Boolean):void
        {
            if (this._visibleSwitchEnable == _arg_1)
            {
                return;
            };
            this._visibleSwitchEnable = _arg_1;
        }

        private function __bBugle(_arg_1:CrazyTankSocketEvent):void
        {
            if (PlayerManager.Instance.Self.Grade <= CHAT_LEVEL)
            {
                return;
            };
            var _local_2:PackageIn = (_arg_1.pkg as PackageIn);
            var _local_3:ChatData = new ChatData();
            _local_3.bigBuggleType = _local_2.readInt();
            _local_3.channel = ChatInputView.BIG_BUGLE;
            _local_3.senderID = _local_2.readInt();
            _local_3.receiver = "";
            _local_3.sender = _local_2.readUTF();
            _local_3.msg = _local_2.readUTF();
            this.chat(_local_3);
        }

        private function __bugleBuyHandler(_arg_1:CrazyTankSocketEvent):void
        {
            if (PlayerManager.Instance.Self.Grade <= CHAT_LEVEL)
            {
                return;
            };
            var _local_2:PackageIn = _arg_1.pkg;
            _local_2.position = SocketManager.PACKAGE_CONTENT_START_INDEX;
            var _local_3:int = _local_2.readInt();
            var _local_4:int = _local_2.readInt();
            if (((_local_4 == 3) && (_local_3 == 1)))
            {
                this.input.sendCurrentText();
            }
            else
            {
                if (((_local_4 == 5) && (_local_3 >= 1)))
                {
                    dispatchEvent(new Event(CrazyTankSocketEvent.BUY_BEAD));
                };
            };
        }

        private function __cBugle(_arg_1:CrazyTankSocketEvent):void
        {
            if (PlayerManager.Instance.Self.Grade <= CHAT_LEVEL)
            {
                return;
            };
            var _local_2:PackageIn = (_arg_1.pkg as PackageIn);
            var _local_3:ChatData = new ChatData();
            _local_3.channel = ChatInputView.CROSS_BUGLE;
            _local_3.zoneID = _local_2.readInt();
            _local_3.senderID = _local_2.readInt();
            _local_3.receiver = "";
            _local_3.sender = _local_2.readUTF();
            _local_3.msg = _local_2.readUTF();
            _local_3.zoneName = _local_2.readUTF();
            this.chat(_local_3);
        }

        private function __consortiaChat(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_3:int;
            var _local_4:ChatData;
            if (PlayerManager.Instance.Self.Grade <= CHAT_LEVEL)
            {
                return;
            };
            var _local_2:PackageIn = (_arg_1.pkg as PackageIn);
            if (_local_2.clientId != PlayerManager.Instance.Self.ID)
            {
                _local_3 = _local_2.readByte();
                _local_4 = new ChatData();
                _local_4.channel = ChatInputView.CONSORTIA;
                _local_4.senderID = _local_2.clientId;
                _local_4.receiver = "";
                _local_4.sender = _local_2.readUTF();
                _local_4.msg = _local_2.readUTF();
                this.chatCheckSelf(_local_4);
            };
        }

        private function __defyAffiche(_arg_1:CrazyTankSocketEvent):void
        {
            if (PlayerManager.Instance.Self.Grade <= CHAT_LEVEL)
            {
                return;
            };
            var _local_2:PackageIn = (_arg_1.pkg as PackageIn);
            var _local_3:ChatData = new ChatData();
            _local_3.msg = _local_2.readUTF();
            _local_3.channel = ChatInputView.DEFY_AFFICHE;
            this.chatCheckSelf(_local_3);
        }

        private function __getItemMsgHandler(event:CrazyTankSocketEvent):void
        {
            var txt:String;
            var battle_str:String;
            var data:ChatData;
            var str:String;
            if (PlayerManager.Instance.Self.Grade <= CHAT_LEVEL)
            {
                return;
            };
            var pkg:PackageIn = (event.pkg as PackageIn);
            var nickName:String = pkg.readUTF();
            var battle_type:int = pkg.readInt();
            var templateID:int = pkg.readInt();
            var isbinds:Boolean = pkg.readBoolean();
            var isBroadcast:int = pkg.readInt();
            if (battle_type == 0)
            {
                battle_str = LanguageMgr.GetTranslation("tank.game.GameView.unexpectedBattle");
            }
            else
            {
                if (battle_type == 2)
                {
                    battle_str = LanguageMgr.GetTranslation("tank.game.GameView.RouletteBattle");
                }
                else
                {
                    if (battle_type == 1)
                    {
                        battle_str = LanguageMgr.GetTranslation("tank.game.GameView.dungeonBattle");
                    }
                    else
                    {
                        if (battle_type == 3)
                        {
                            battle_str = LanguageMgr.GetTranslation("tank.game.GameView.CaddyBattle");
                        }
                        else
                        {
                            if (battle_type == 4)
                            {
                                battle_str = LanguageMgr.GetTranslation("tank.game.GameView.beadBattle");
                            }
                            else
                            {
                                if (battle_type == 5)
                                {
                                    battle_str = LanguageMgr.GetTranslation("tank.game.GameView.GiftBattle");
                                }
                                else
                                {
                                    if (battle_type == 11)
                                    {
                                        battle_str = LanguageMgr.GetTranslation("tank.game.GameView.BlessBattle");
                                    };
                                };
                            };
                        };
                    };
                };
            };
            if (isBroadcast == 1)
            {
                txt = LanguageMgr.GetTranslation("tank.game.GameView.getgoodstip.broadcast", (("[" + nickName) + "]"), battle_str);
            }
            else
            {
                if (isBroadcast == 2)
                {
                    txt = LanguageMgr.GetTranslation("tank.game.GameView.getgoodstip", nickName, battle_str);
                }
                else
                {
                    if (isBroadcast == 3)
                    {
                        str = pkg.readUTF();
                        txt = LanguageMgr.GetTranslation("tank.manager.congratulateGain", (("[" + nickName) + "]"), str);
                    }
                    else
                    {
                        if (isBroadcast == 4)
                        {
                            txt = LanguageMgr.GetTranslation("tank.game.GameView.getgoodstip.broadcast", nickName, LanguageMgr.GetTranslation("ddt.turnplate.chatName.txt"));
                        };
                    };
                };
            };
            var itemInfo:ItemTemplateInfo = ItemManager.Instance.getTemplateById(templateID);
            data = new ChatData();
            data.channel = ChatInputView.SYS_NOTICE;
            data.msg = (((txt + "[") + itemInfo.Name) + "]");
            var channelTag:Array = ChatFormats.getTagsByChannel(data.channel);
            txt = StringHelper.rePlaceHtmlTextField(txt);
            var nameTag:String = ChatFormats.creatBracketsTag(txt, ChatFormats.CLICK_USERNAME);
            var goodTag:String = ChatFormats.creatGoodTag((("[" + itemInfo.Name) + "]"), ChatFormats.CLICK_GOODS, itemInfo.TemplateID, itemInfo.Quality, isbinds, data);
            data.htmlMessage = ((((channelTag[0] + nameTag) + goodTag) + channelTag[1]) + "<BR>");
            data.htmlMessage = Helpers.deCodeString(data.htmlMessage);
            if (isBroadcast != 4)
            {
                this._model.addChat(data);
            }
            else
            {
                setTimeout(function ():void
                {
                    _model.addChat(data);
                }, 8000);
            };
        }

        private function __goodLinkGetHandler(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_6:String;
            if (PlayerManager.Instance.Self.Grade <= CHAT_LEVEL)
            {
                return;
            };
            var _local_2:InventoryItemInfo = new InventoryItemInfo();
            var _local_3:PackageIn = _arg_1.pkg;
            var _local_4:int = _local_3.readInt();
            if (_local_4 == 6)
            {
                _local_6 = _local_3.readUTF();
                _local_2.Name = _local_3.readUTF();
                _local_2.TemplateID = _local_3.readInt();
                _local_2.Property2 = _local_3.readInt().toString();
                _local_2.Property3 = _local_3.readInt().toString();
                _local_2.beadLevel = _local_3.readInt();
                _local_2.beadExp = _local_3.readInt();
                this.output.contentField.showBeadTip(_local_2, 1);
                return;
            };
            var _local_5:String = _local_3.readUTF();
            _local_2.TemplateID = _local_3.readInt();
            _local_2.ItemID = _local_3.readInt();
            _local_2.StrengthenLevel = _local_3.readInt();
            _local_2.AttackCompose = _local_3.readInt();
            _local_2.AgilityCompose = _local_3.readInt();
            _local_2.LuckCompose = _local_3.readInt();
            _local_2.DefendCompose = _local_3.readInt();
            _local_2.ValidDate = _local_3.readInt();
            _local_2.IsBinds = _local_3.readBoolean();
            _local_2.IsJudge = _local_3.readBoolean();
            _local_2.IsUsed = _local_3.readBoolean();
            if (_local_2.IsUsed)
            {
                _local_2.BeginDate = _local_3.readUTF();
            };
            _local_2.Hole1 = _local_3.readInt();
            _local_2.Hole2 = _local_3.readInt();
            _local_2.Hole3 = _local_3.readInt();
            _local_2.Hole4 = _local_3.readInt();
            _local_2.Hole5 = _local_3.readInt();
            _local_2.Hole6 = _local_3.readInt();
            _local_2.Hole = _local_3.readUTF();
            ItemManager.fill(_local_2);
            _local_2.Pic = _local_3.readUTF();
            _local_2.RefineryLevel = _local_3.readInt();
            _local_2.DiscolorValidDate = _local_3.readDateString();
            _local_2.Hole5Level = _local_3.readByte();
            _local_2.Hole5Exp = _local_3.readInt();
            _local_2.Hole6Level = _local_3.readByte();
            _local_2.Hole6Exp = _local_3.readInt();
            this.model.addLink(_local_5, _local_2);
            if (_local_2.CategoryID == EquipType.EQUIP)
            {
                this.output.contentField.showEquipTip(_local_2, 1);
            }
            else
            {
                this.output.contentField.showLinkGoodsInfo(_local_2, 1);
            };
        }

        private function __privateChat(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_3:ChatData;
            if (PlayerManager.Instance.Self.Grade <= CHAT_LEVEL)
            {
                return;
            };
            var _local_2:PackageIn = _arg_1.pkg;
            if (_local_2.clientId)
            {
                _local_3 = new ChatData();
                _local_3.channel = ChatInputView.PRIVATE;
                _local_3.receiverID = _local_2.readInt();
                _local_3.senderID = _local_2.clientId;
                _local_3.receiver = _local_2.readUTF();
                _local_3.sender = _local_2.readUTF();
                _local_3.msg = _local_2.readUTF();
                _local_3.isAutoReply = _local_2.readBoolean();
                this.chatCheckSelf(_local_3);
                if (_local_3.senderID != PlayerManager.Instance.Self.ID)
                {
                    IMController.Instance.saveRecentContactsID(_local_3.senderID);
                }
                else
                {
                    if (_local_3.receiverID != PlayerManager.Instance.Self.ID)
                    {
                        IMController.Instance.saveRecentContactsID(_local_3.receiverID);
                    };
                };
            };
        }

        private function __receiveFace(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:Object = {};
            _local_2.playerid = _arg_1.pkg.clientId;
            _local_2.faceid = _arg_1.pkg.readInt();
            _local_2.delay = _arg_1.pkg.readInt();
            dispatchEvent(new ChatEvent(ChatEvent.SHOW_FACE, _local_2));
        }

        private function __sBugle(_arg_1:CrazyTankSocketEvent):void
        {
            if (PlayerManager.Instance.Self.Grade <= CHAT_LEVEL)
            {
                return;
            };
            var _local_2:PackageIn = (_arg_1.pkg as PackageIn);
            var _local_3:ChatData = new ChatData();
            _local_3.channel = ChatInputView.SMALL_BUGLE;
            _local_3.senderID = _local_2.readInt();
            _local_3.receiver = "";
            _local_3.sender = _local_2.readUTF();
            _local_3.msg = _local_2.readUTF();
            this.chat(_local_3);
        }

        private function __sceneChat(_arg_1:CrazyTankSocketEvent):void
        {
            if (PlayerManager.Instance.Self.Grade <= CHAT_LEVEL)
            {
                return;
            };
            var _local_2:PackageIn = (_arg_1.pkg as PackageIn);
            var _local_3:ChatData = new ChatData();
            _local_3.zoneID = _local_2.readInt();
            _local_3.channel = _local_2.readByte();
            if (_local_2.readBoolean())
            {
                _local_3.channel = ChatInputView.TEAM;
            };
            _local_3.senderID = _local_2.clientId;
            _local_3.receiver = "";
            _local_3.sender = _local_2.readUTF();
            _local_3.msg = _local_2.readUTF();
            this.chatCheckSelf(_local_3);
            this.addRecentContacts(_local_3.senderID);
        }

        private function addRecentContacts(_arg_1:int):void
        {
            if ((((((StateManager.currentStateType == StateType.DUNGEON_ROOM) || (StateManager.currentStateType == StateType.CHALLENGE_ROOM)) || (StateManager.currentStateType == StateType.MATCH_ROOM)) || (StateManager.currentStateType == StateType.MISSION_ROOM)) || (StateManager.currentStateType == StateType.GAME_LOADING)))
            {
                if (RoomManager.Instance.isIdenticalRoom(_arg_1))
                {
                    IMController.Instance.saveRecentContactsID(_arg_1);
                };
            }
            else
            {
                if (StateManager.isInFight)
                {
                    if (GameManager.Instance.isIdenticalGame(_arg_1))
                    {
                        IMController.Instance.saveRecentContactsID(_arg_1);
                    };
                };
            };
        }

        private function __sysNotice(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_4:Array;
            var _local_7:int;
            var _local_8:String;
            var _local_9:int;
            var _local_10:String;
            if (PlayerManager.Instance.Self.Grade <= CHAT_LEVEL)
            {
                return;
            };
            var _local_2:int = _arg_1.pkg.readInt();
            var _local_3:String = _arg_1.pkg.readUTF();
            var _local_5:ChatData = new ChatData();
            var _local_6:Boolean;
            switch (_local_2)
            {
                case 0:
                    _local_5.channel = ChatInputView.GM_NOTICE;
                    break;
                case 1:
                case 4:
                case 5:
                case 21:
                    _local_6 = true;
                case 2:
                case 6:
                case 7:
                    _local_5.channel = ChatInputView.SYS_TIP;
                    break;
                case 3:
                    _local_5.channel = ChatInputView.SYS_NOTICE;
                    break;
                case 8:
                    _local_5.channel = 22;
                    break;
                case 10:
                case 11:
                case 16:
                case 18:
                case 19:
                    _local_6 = true;
                case 13:
                case 12:
                    _local_5.zoneID = _arg_1.pkg.readInt();
                    _local_5.channel = ChatInputView.CROSS_NOTICE;
                    break;
                case 9:
                    _local_5.channel = ChatInputView.ACTIVITY;
                    break;
                default:
                    _local_5.channel = ChatInputView.SYS_NOTICE;
            };
            if ((((_arg_1) && (_arg_1.pkg.bytesAvailable)) && (_local_2 == 8)))
            {
                _local_5.anyThing = ChatHelper.readDungeonInfo(_arg_1.pkg);
                _local_5.sender = String(_local_5.anyThing.inviterNickName);
            }
            else
            {
                if ((((_arg_1) && (_arg_1.pkg.bytesAvailable)) && (_local_2 == 9)))
                {
                    _local_5.anyThing = _arg_1.pkg.readUTF();
                }
                else
                {
                    if (((_arg_1) && (_arg_1.pkg.bytesAvailable)))
                    {
                        _local_4 = ChatHelper.readGoodsLinks(_arg_1.pkg, _local_6);
                    };
                };
            };
            _local_5.type = _local_2;
            _local_5.msg = StringHelper.rePlaceHtmlTextField(_local_3);
            _local_5.link = _local_4;
            if (((_local_2 == 12) && (_arg_1.pkg.bytesAvailable)))
            {
                _local_7 = _arg_1.pkg.readInt();
                if (_local_7 == TurnPlateController.TURNPLATE_HISTORY)
                {
                    _local_8 = _arg_1.pkg.readUTF();
                    _local_9 = _arg_1.pkg.readInt();
                    _local_10 = _arg_1.pkg.readUTF();
                    setTimeout(this.chat, 8000, _local_5);
                }
                else
                {
                    this.chat(_local_5);
                };
            }
            else
            {
                this.chat(_local_5);
            };
        }

        private function chatCheckSelf(_arg_1:ChatData):void
        {
            var _local_2:DictionaryData;
            var _local_3:PlayerInfo;
            if (((!(_arg_1.zoneID == -1)) && (!(_arg_1.zoneID == PlayerManager.Instance.Self.ZoneID))))
            {
                if (((!(_arg_1.sender == PlayerManager.Instance.Self.NickName)) || (!(_arg_1.zoneID == PlayerManager.Instance.Self.ZoneID))))
                {
                    this.chat(_arg_1);
                    return;
                };
            }
            else
            {
                if (_arg_1.sender != PlayerManager.Instance.Self.NickName)
                {
                    if (_arg_1.channel == ChatInputView.CONSORTIA)
                    {
                        _local_2 = PlayerManager.Instance.blackList;
                        for each (_local_3 in _local_2)
                        {
                            if (_local_3.NickName == _arg_1.sender)
                            {
                                return;
                            };
                        };
                    };
                    this.chat(_arg_1);
                };
            };
        }

        private function initEvent():void
        {
            if ((!(SHIELD_NOTICE)))
            {
                SocketManager.Instance.addEventListener(CrazyTankSocketEvent.S_BUGLE, this.__sBugle);
                SocketManager.Instance.addEventListener(CrazyTankSocketEvent.B_BUGLE, this.__bBugle);
                SocketManager.Instance.addEventListener(CrazyTankSocketEvent.C_BUGLE, this.__cBugle);
                SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GET_ITEM_MESS, this.__getItemMsgHandler);
            };
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CHAT_PERSONAL, this.__privateChat);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SCENE_CHAT, this.__sceneChat);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIA_CHAT, this.__consortiaChat);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SCENE_FACE, this.__receiveFace);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SYS_NOTICE, this.__sysNotice);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.DEFY_AFFICHE, this.__defyAffiche);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.BUY_GOODS, this.__bugleBuyHandler);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LINKGOODSINFO_GET, this.__goodLinkGetHandler);
        }

        private function initView():void
        {
            ChatFormats.setup();
            this._model = new ChatModel();
            this._chatView = ComponentFactory.Instance.creatCustomObject("chat.View");
            this.state = CHAT_HALL_STATE;
            this.inputChannel = ChatInputView.CURRENT;
            this.outputChannel = ChatOutputView.CHAT_OUPUT_CURRENT;
        }

        private function sendMessage(_arg_1:int, _arg_2:String, _arg_3:String, _arg_4:Boolean):void
        {
            _arg_3 = Helpers.enCodeString(_arg_3);
            var _local_5:PackageOut = new PackageOut(ePackageType.SCENE_CHAT);
            _local_5.writeByte(_arg_1);
            _local_5.writeBoolean(_arg_4);
            _local_5.writeUTF(_arg_2);
            _local_5.writeUTF(_arg_3);
            SocketManager.Instance.out.sendPackage(_local_5);
        }

        public function sendPrivateMessage(_arg_1:String, _arg_2:String, _arg_3:Number=0, _arg_4:Boolean=false):void
        {
            _arg_2 = Helpers.enCodeString(_arg_2);
            var _local_5:PackageOut = new PackageOut(ePackageType.CHAT_PERSONAL);
            _local_5.writeInt(_arg_3);
            _local_5.writeUTF(_arg_1);
            _local_5.writeUTF(PlayerManager.Instance.Self.NickName);
            _local_5.writeUTF(_arg_2);
            _local_5.writeBoolean(_arg_4);
            SocketManager.Instance.out.sendPackage(_local_5);
            if (((RoomManager.Instance.current) && (!(RoomManager.Instance.current.isCrossZone))))
            {
                IMController.Instance.saveRecentContactsID(_arg_3);
            };
        }

        public function set reportMsg(_arg_1:String):void
        {
            this._reportMsg = _arg_1;
        }

        public function get reportMsg():String
        {
            return (this._reportMsg);
        }


    }
}//package ddt.manager

