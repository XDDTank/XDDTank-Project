// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.chat.ChatOutputField

package ddt.view.chat
{
    import flash.display.Sprite;
    import flash.text.TextField;
    import ddt.view.tips.EquipTipPanel;
    import bead.view.BeadTipPanel;
    import ddt.view.tips.GoodTip;
    import flash.geom.Rectangle;
    import ddt.utils.Helpers;
    import flash.geom.Point;
    import ddt.view.tips.GoodTipInfo;
    import com.pickgliss.toplevel.StageReferance;
    import flash.events.MouseEvent;
    import ddt.data.goods.ItemTemplateInfo;
    import flash.events.Event;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import ddt.manager.SoundManager;
    import ddt.manager.ChatManager;
    import ddt.manager.PlayerManager;
    import ddt.manager.LanguageMgr;
    import im.IMView;
    import im.IMController;
    import ddt.manager.IMEManager;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.StateManager;
    import ddt.manager.ItemManager;
    import ddt.data.EquipType;
    import ddt.manager.SocketManager;
    import ddt.manager.MessageTipManager;
    import com.pickgliss.ui.AlertManager;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.events.FrameEvent;
    import ddt.states.StateType;
    import activity.ActivityController;
    import flash.events.TextEvent;
    import room.RoomManager;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.utils.PositionUtils;
    import flash.filters.GlowFilter;
    import ddt.view.chat.chat_system; 

    use namespace chat_system;

    public class ChatOutputField extends Sprite 
    {

        public static const GAME_STYLE:String = "GAME_STYLE";
        public static const GAME_WIDTH:int = 288;
        public static const GAME_HEIGHT:int = 106;
        public static const MULTI_GAME_STYLE:String = "MULTI_GAME_STYLE";
        public static const MULTI_GAME_WIDTH:int = 244;
        public static const MULTI_GAME_HEIGHT:int = 106;
        public static const NORMAL_WIDTH:int = 440;
        public static const NORMAL_HEIGHT:int = 140;
        public static const NORMAL_STYLE:String = "NORMAL_STYLE";
        private static var _style:String = "";

        private var _contentField:TextField;
        private var _nameTip:ChatNamePanel;
        private var _equipTip:EquipTipPanel;
        private var _beadTip:BeadTipPanel;
        private var _goodTip:GoodTip;
        private var _goodTipPos:Sprite = new Sprite();
        private var _srcollRect:Rectangle;
        private var _tipStageClickCount:int = 0;
        private var isStyleChange:Boolean = false;
        private var t_text:String;
        private var _functionEnabled:Boolean;
        private var chaData:Object;

        public function ChatOutputField()
        {
            this.style = NORMAL_STYLE;
        }

        public function set functionEnabled(_arg_1:Boolean):void
        {
            this._functionEnabled = _arg_1;
        }

        public function set contentWidth(_arg_1:Number):void
        {
            this._contentField.width = _arg_1;
            this.updateScrollRect(_arg_1, NORMAL_HEIGHT);
        }

        public function isBottom():Boolean
        {
            return (this._contentField.scrollV == this._contentField.maxScrollV);
        }

        public function get scrollOffset():int
        {
            return (this._contentField.maxScrollV - this._contentField.scrollV);
        }

        public function set scrollOffset(_arg_1:int):void
        {
            this._contentField.scrollV = (this._contentField.maxScrollV - _arg_1);
            this.onScrollChanged();
        }

        public function setChats(_arg_1:Array):void
        {
            var _local_2:String = "";
            var _local_3:int;
            while (_local_3 < _arg_1.length)
            {
                _local_2 = (_local_2 + _arg_1[_local_3].htmlMessage);
                _local_3++;
            };
            this._contentField.htmlText = _local_2;
        }

        public function toBottom():void
        {
            Helpers.delayCall(this.__delayCall);
            this._contentField.scrollV = int.MAX_VALUE;
            this.onScrollChanged();
        }

        chat_system function get goodTipPos():Point
        {
            return (new Point(this._goodTipPos.x, this._goodTipPos.y));
        }

        chat_system function showLinkGoodsInfo(_arg_1:ItemTemplateInfo, _arg_2:uint=0):void
        {
            if (this._goodTip == null)
            {
                this._goodTip = new GoodTip();
            };
            var _local_3:GoodTipInfo = new GoodTipInfo();
            _local_3.itemInfo = _arg_1;
            this._goodTip.tipData = _local_3;
            this._goodTip.showTip(_arg_1);
            this.setTipPos(this._goodTip);
            StageReferance.stage.addChild(this._goodTip);
            if (((this._nameTip) && (this._nameTip.parent)))
            {
                this._nameTip.parent.removeChild(this._nameTip);
            };
            StageReferance.stage.addEventListener(MouseEvent.CLICK, this.__stageClickHandler);
            this._tipStageClickCount = _arg_2;
        }

        chat_system function showEquipTip(_arg_1:ItemTemplateInfo, _arg_2:uint=0):void
        {
            this._equipTip = new EquipTipPanel();
            this._equipTip.tipData = _arg_1;
            this._equipTip.tipDirctions = "7,0";
            this.setTipPos(this._equipTip);
            StageReferance.stage.addChild(this._equipTip);
            StageReferance.stage.addEventListener(MouseEvent.CLICK, this.__stageClickHandler);
            this._tipStageClickCount = _arg_2;
        }

        chat_system function showBeadTip(_arg_1:ItemTemplateInfo, _arg_2:uint=0):void
        {
            this._beadTip = new BeadTipPanel();
            this._beadTip.tipData = _arg_1;
            this._beadTip.tipDirctions = "7,0";
            this.setTipPos(this._beadTip);
            StageReferance.stage.addChild(this._beadTip);
            StageReferance.stage.addEventListener(MouseEvent.CLICK, this.__stageClickHandler);
            this._tipStageClickCount = _arg_2;
        }

        private function setTipPos(_arg_1:Object):void
        {
            _arg_1.x = this._goodTipPos.x;
            _arg_1.y = ((this._goodTipPos.y - _arg_1.height) - 10);
            if (_arg_1.y < 0)
            {
                _arg_1.y = 10;
            };
        }

        private function setTipPos2(_arg_1:Object):void
        {
            _arg_1.tipGapH = 218;
            _arg_1.tipGapV = 245;
            _arg_1.x = 218;
            _arg_1.y = 245;
        }

        chat_system function set style(_arg_1:String):void
        {
            _style = _arg_1;
            this.disposeView();
            this.initView();
            this.initEvent();
            switch (_arg_1)
            {
                case NORMAL_STYLE:
                    this._contentField.styleSheet = ChatFormats.styleSheet;
                    this._contentField.width = NORMAL_WIDTH;
                    this._contentField.height = NORMAL_HEIGHT;
                    break;
                case GAME_STYLE:
                    this._contentField.styleSheet = ChatFormats.gameStyleSheet;
                    this._contentField.width = GAME_WIDTH;
                    this._contentField.height = GAME_HEIGHT;
                    break;
                case MULTI_GAME_STYLE:
                    this._contentField.styleSheet = ChatFormats.gameStyleSheet;
                    this._contentField.width = MULTI_GAME_WIDTH;
                    this._contentField.height = MULTI_GAME_HEIGHT;
                    break;
            };
            this._contentField.htmlText = ((this.t_text) || (""));
        }

        private function __delayCall():void
        {
            this._contentField.scrollV = this._contentField.maxScrollV;
            this.onScrollChanged();
            removeEventListener(Event.ENTER_FRAME, this.__delayCall);
        }

        private function __onScrollChanged(_arg_1:Event):void
        {
            this.onScrollChanged();
        }

        private function __onTextClicked(_arg_1:TextEvent):void
        {
            var _local_2:Object;
            var _local_4:Point;
            var _local_6:Array;
            var _local_7:int;
            var _local_8:int;
            var _local_9:String;
            var _local_10:int;
            var _local_11:RegExp;
            var _local_12:String;
            var _local_13:Object;
            var _local_14:Rectangle;
            var _local_15:int;
            var _local_16:int;
            var _local_17:Point;
            var _local_18:int;
            var _local_19:Point;
            var _local_20:ItemTemplateInfo;
            var _local_21:ItemTemplateInfo;
            var _local_22:BaseAlerFrame;
            SoundManager.instance.play("008");
            this.__stageClickHandler();
            _local_2 = {};
            var _local_3:Array = _arg_1.text.split("|");
            var _local_5:int;
            while (_local_5 < _local_3.length)
            {
                if (_local_3[_local_5].indexOf(":"))
                {
                    _local_6 = _local_3[_local_5].split(":");
                    _local_2[_local_6[0]] = _local_6[1];
                };
                _local_5++;
            };
            if (int(_local_2.clicktype) == ChatFormats.CLICK_CHANNEL)
            {
                if (int(_local_2.channel) != 22)
                {
                    ChatManager.Instance.inputChannel = int(_local_2.channel);
                    ChatManager.Instance.output.functionEnabled = true;
                };
            }
            else
            {
                if (int(_local_2.clicktype) == ChatFormats.CLICK_USERNAME)
                {
                    _local_7 = PlayerManager.Instance.Self.ZoneID;
                    _local_8 = _local_2.zoneID;
                    if (((_local_8 > 0) && (!(_local_8 == _local_7))))
                    {
                        ChatManager.Instance.sysChatYellow(LanguageMgr.GetTranslation("core.crossZone.PrivateChatToUnable"));
                        return;
                    };
                    if (IMView.IS_SHOW_SUB)
                    {
                        dispatchEvent(new ChatEvent(ChatEvent.NICKNAME_CLICK_TO_OUTSIDE, _local_2.tagname));
                    };
                    if (IMController.Instance.isFriend(String(_local_2.tagname)))
                    {
                        IMEManager.enable();
                        ChatManager.Instance.output.functionEnabled = true;
                        ChatManager.Instance.privateChatTo(_local_2.tagname);
                    }
                    else
                    {
                        if (this._nameTip == null)
                        {
                            this._nameTip = ComponentFactory.Instance.creatCustomObject("chat.NamePanel");
                        };
                        _local_9 = String(_local_2.tagname);
                        if (_local_9 == "")
                        {
                            return;
                        };
                        _local_10 = _local_9.indexOf("$");
                        if (_local_10 > -1)
                        {
                            _local_9 = _local_9.substr(0, _local_10);
                        };
                        _local_11 = new RegExp(_local_9, "g");
                        _local_12 = this._contentField.text;
                        _local_13 = _local_11.exec(_local_12);
                        while (_local_13 != null)
                        {
                            _local_15 = _local_13.index;
                            _local_16 = (_local_15 + String(_local_2.tagname).length);
                            _local_17 = this._contentField.globalToLocal(new Point(StageReferance.stage.mouseX, StageReferance.stage.mouseY));
                            _local_18 = this._contentField.getCharIndexAtPoint(_local_17.x, _local_17.y);
                            if (((_local_18 >= _local_15) && (_local_18 <= _local_16)))
                            {
                                this._contentField.setSelection(_local_15, _local_16);
                                _local_14 = this._contentField.getCharBoundaries(_local_16);
                                _local_19 = this._contentField.localToGlobal(new Point(_local_14.x, _local_14.y));
                                if ((!(StateManager.isInFight)))
                                {
                                    this._nameTip.x = (_local_19.x + _local_14.width);
                                    this._nameTip.y = ((_local_19.y - this._nameTip.getHeight) - ((this._contentField.scrollV - 1) * 18));
                                }
                                else
                                {
                                    this._nameTip.x = (_local_19.x + _local_14.width);
                                    this._nameTip.y = (((_local_19.y - this._nameTip.getHeight) - ((this._contentField.scrollV - 1) * 18)) + 118);
                                };
                                break;
                            };
                            _local_13 = _local_11.exec(_local_12);
                        };
                        this._nameTip.playerName = String(_local_2.tagname);
                        if (_local_2.channel)
                        {
                            this._nameTip.channel = ChatFormats.Channel_Set[int(_local_2.channel)];
                        }
                        else
                        {
                            this._nameTip.channel = null;
                        };
                        this._nameTip.message = ChatManager.Instance.reportMsg;
                        if (((this._goodTip) && (this._goodTip.parent)))
                        {
                            this._goodTip.parent.removeChild(this._goodTip);
                        };
                        this._nameTip.setVisible = true;
                        ChatManager.Instance.privateChatTo(_local_2.tagname);
                    };
                }
                else
                {
                    if (int(_local_2.clicktype) == ChatFormats.CLICK_GOODS)
                    {
                        _local_20 = ItemManager.Instance.getTemplateById(_local_2.templeteIDorItemID);
                        _local_20.BindType = ((_local_2.isBind == "true") ? 0 : 1);
                        _local_4 = this._contentField.localToGlobal(new Point(this._contentField.mouseX, this._contentField.mouseY));
                        this._goodTipPos.x = _local_4.x;
                        this._goodTipPos.y = _local_4.y;
                        if (_local_20.CategoryID == EquipType.EQUIP)
                        {
                            this.showEquipTip(_local_20);
                        }
                        else
                        {
                            this.showLinkGoodsInfo(_local_20);
                        };
                    }
                    else
                    {
                        if (int(_local_2.clicktype) == ChatFormats.CLICK_BEAD_GOODS)
                        {
                            _local_7 = PlayerManager.Instance.Self.ZoneID;
                            _local_8 = _local_2.zoneID;
                            if (((_local_8 > 0) && (!(_local_8 == _local_7))))
                            {
                                ChatManager.Instance.sysChatYellow(LanguageMgr.GetTranslation("core.crossZone.ViewGoodInfoUnable"));
                                return;
                            };
                            _local_4 = this._contentField.localToGlobal(new Point(this._contentField.mouseX, this._contentField.mouseY));
                            this._goodTipPos.x = _local_4.x;
                            this._goodTipPos.y = _local_4.y;
                            SocketManager.Instance.out.sendGetLinkGoodsInfo(6, String(_local_2.key));
                        }
                        else
                        {
                            if (int(_local_2.clicktype) == ChatFormats.CLICK_INVENTORY_GOODS)
                            {
                                _local_7 = PlayerManager.Instance.Self.ZoneID;
                                _local_8 = _local_2.zoneID;
                                if (((_local_8 > 0) && (!(_local_8 == _local_7))))
                                {
                                    ChatManager.Instance.sysChatYellow(LanguageMgr.GetTranslation("core.crossZone.ViewGoodInfoUnable"));
                                    return;
                                };
                                _local_4 = this._contentField.localToGlobal(new Point(this._contentField.mouseX, this._contentField.mouseY));
                                this._goodTipPos.x = _local_4.x;
                                this._goodTipPos.y = _local_4.y;
                                if (_local_2.key != "null")
                                {
                                    _local_21 = ChatManager.Instance.model.getLink(_local_2.key);
                                }
                                else
                                {
                                    _local_21 = ChatManager.Instance.model.getLink(_local_2.templeteIDorItemID);
                                };
                                if (_local_21)
                                {
                                    if (_local_21.CategoryID == EquipType.EQUIP)
                                    {
                                        this.showEquipTip(_local_21);
                                    }
                                    else
                                    {
                                        this.showLinkGoodsInfo(_local_21);
                                    };
                                }
                                else
                                {
                                    if (_local_2.key != "null")
                                    {
                                        SocketManager.Instance.out.sendGetLinkGoodsInfo(ChatTypes.STREANTH, String(_local_2.key));
                                    }
                                    else
                                    {
                                        SocketManager.Instance.out.sendGetLinkGoodsInfo(2, String(_local_2.templeteIDorItemID));
                                    };
                                };
                            }
                            else
                            {
                                if (int(_local_2.clicktype) == ChatFormats.CLICK_DIFF_ZONE)
                                {
                                    ChatManager.Instance.sysChatYellow(LanguageMgr.GetTranslation("tank.view.chatFormat.cross"));
                                }
                                else
                                {
                                    if (int(_local_2.clicktype) != ChatFormats.CLICK_EFFORT)
                                    {
                                        if (int(_local_2.clicktype) == ChatFormats.CLICK_DUNGEON_INFO)
                                        {
                                            if (PlayerManager.Instance.Self.Grade < 13)
                                            {
                                                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.dungeonInvite.needGrade"));
                                                return;
                                            };
                                            this.chaData = _local_2;
                                            if (PlayerManager.Instance.checkExpedition())
                                            {
                                                _local_22 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"), LanguageMgr.GetTranslation("ddt.consortion.ConsortionTransport.stopExpedition"), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), false, true, false, LayerManager.BLCAK_BLOCKGOUND);
                                                _local_22.moveEnable = false;
                                                _local_22.addEventListener(FrameEvent.RESPONSE, this.__expeditionRoomConfirmResponse);
                                            }
                                            else
                                            {
                                                this.EnterDungeonRoom();
                                            };
                                        }
                                        else
                                        {
                                            if (int(_local_2.clicktype) == ChatFormats.CLICK_ACTIVITY)
                                            {
                                                if (StateManager.currentStateType == StateType.MAIN)
                                                {
                                                    ActivityController.instance.model.showID = (_local_2.activityID as String);
                                                    ActivityController.instance.showFrame();
                                                }
                                                else
                                                {
                                                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.calendar.activity.cannotGet"));
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

        private function EnterDungeonRoom():void
        {
            var _local_1:BaseAlerFrame;
            if (PlayerManager.Instance.Self.Grade < int(this.chaData.levelLimit))
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("littlegame.MinLvNote", this.chaData.LevelLimit));
            }
            else
            {
                if (StateManager.isInFight)
                {
                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.dungeonInvite.fightingAlert"));
                }
                else
                {
                    if (((RoomManager.Instance.current) && (RoomManager.Instance.current.ID == this.chaData.roomID)))
                    {
                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.dungeonInvite.inCurrentRoom"));
                    }
                    else
                    {
                        if ((((StateManager.currentStateType == StateType.DUNGEON_ROOM) || (StateManager.currentStateType == StateType.MATCH_ROOM)) || (StateManager.currentStateType == StateType.CHALLENGE_ROOM)))
                        {
                            _local_1 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"), LanguageMgr.GetTranslation("ddt.dungeonInvite.leaveRoomAlert"), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), false, true, false, LayerManager.BLCAK_BLOCKGOUND);
                            _local_1.moveEnable = false;
                            _local_1.addEventListener(FrameEvent.RESPONSE, this.__confirmResponse);
                        }
                        else
                        {
                            if (((StateManager.currentStateType == StateType.ARENA) || (StateManager.currentStateType == StateType.GAME_LOADING)))
                            {
                                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.dungeonInvite.cannotgo"));
                            }
                            else
                            {
                                RoomManager.Instance.findLoginRoom = true;
                                SocketManager.Instance.out.sendGameLogin(2, -1, int(this.chaData.roomID), this.chaData.roompass, true);
                            };
                        };
                    };
                };
            };
        }

        private function __expeditionRoomConfirmResponse(_arg_1:FrameEvent):void
        {
            var _local_2:BaseAlerFrame = (_arg_1.currentTarget as BaseAlerFrame);
            _local_2.removeEventListener(FrameEvent.RESPONSE, this.__expeditionRoomConfirmResponse);
            if (((_arg_1.responseCode == FrameEvent.ENTER_CLICK) || (_arg_1.responseCode == FrameEvent.SUBMIT_CLICK)))
            {
                SocketManager.Instance.out.sendExpeditionCancle();
                this.EnterDungeonRoom();
            };
            ObjectUtils.disposeObject(_local_2);
        }

        private function __confirmResponse(_arg_1:FrameEvent):void
        {
            var _local_2:BaseAlerFrame = (_arg_1.currentTarget as BaseAlerFrame);
            _local_2.removeEventListener(FrameEvent.RESPONSE, this.__confirmResponse);
            if (((_arg_1.responseCode == FrameEvent.ENTER_CLICK) || (_arg_1.responseCode == FrameEvent.SUBMIT_CLICK)))
            {
                RoomManager.Instance.findLoginRoom = true;
                SocketManager.Instance.out.sendGameLogin(2, -1, int(this.chaData.roomID), this.chaData.roompass, true);
            };
            ObjectUtils.disposeObject(_local_2);
        }

        private function __stageClickHandler(_arg_1:MouseEvent=null):void
        {
            if (_arg_1)
            {
                _arg_1.stopImmediatePropagation();
                _arg_1.stopPropagation();
            };
            if (this._tipStageClickCount > 0)
            {
                if (((this._equipTip) && (this._equipTip.parent)))
                {
                    this._equipTip.parent.removeChild(this._equipTip);
                };
                if (((this._goodTip) && (this._goodTip.parent)))
                {
                    this._goodTip.parent.removeChild(this._goodTip);
                };
                if (((this._beadTip) && (this._beadTip.parent)))
                {
                    this._beadTip.parent.removeChild(this._beadTip);
                };
                if (StageReferance.stage)
                {
                    StageReferance.stage.removeEventListener(MouseEvent.CLICK, this.__stageClickHandler);
                };
            }
            else
            {
                this._tipStageClickCount++;
            };
        }

        private function disposeView():void
        {
            if (this._contentField)
            {
                this.t_text = this._contentField.htmlText;
                removeChild(this._contentField);
            };
        }

        private function initEvent():void
        {
            this._contentField.addEventListener(Event.SCROLL, this.__onScrollChanged);
            this._contentField.addEventListener(TextEvent.LINK, this.__onTextClicked);
        }

        private function initView():void
        {
            this._contentField = new TextField();
            PositionUtils.setPos(this._contentField, "chat.outputfieldPos");
            this._contentField.multiline = true;
            this._contentField.wordWrap = true;
            this._contentField.filters = [new GlowFilter(0, 1, 4, 4, 8)];
            this._contentField.mouseWheelEnabled = false;
            Helpers.setTextfieldFormat(this._contentField, {
                "font":"Tahoma",
                "size":12
            });
            this.updateScrollRect(NORMAL_WIDTH, NORMAL_HEIGHT);
            addChild(this._contentField);
        }

        private function onScrollChanged():void
        {
            dispatchEvent(new ChatEvent(ChatEvent.SCROLL_CHANG));
        }

        private function updateScrollRect(_arg_1:Number, _arg_2:Number):void
        {
            this._srcollRect = new Rectangle(0, 0, _arg_1, _arg_2);
            this._contentField.scrollRect = this._srcollRect;
        }


    }
}//package ddt.view.chat

