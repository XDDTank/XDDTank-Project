// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//consortion.ConsortionModelControl

package consortion
{
    import flash.events.EventDispatcher;
    import consortion.consortionsence.ConsortionWalkMapModel;
    import consortion.view.selfConsortia.consortiaTask.ConsortiaTaskModel;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import ddt.manager.SocketManager;
    import ddt.events.CrazyTankSocketEvent;
    import road7th.comm.PackageIn;
    import ddt.data.player.ConsortiaPlayerInfo;
    import flash.display.InteractiveObject;
    import ddt.data.player.PlayerState;
    import ddt.manager.PlayerManager;
    import ddt.manager.MessageTipManager;
    import ddt.manager.LanguageMgr;
    import ddt.manager.StateManager;
    import ddt.states.StateType;
    import consortion.event.ConsortionEvent;
    import ddt.manager.TaskManager;
    import ddt.manager.PathManager;
    import ddt.manager.ExternalInterfaceManager;
    import ddt.manager.ServerManager;
    import road7th.utils.StringHelper;
    import ddt.manager.ChatManager;
    import ddt.manager.SharedManager;
    import ddt.manager.SoundManager;
    import com.pickgliss.toplevel.StageReferance;
    import com.pickgliss.events.FrameEvent;
    import com.pickgliss.utils.ObjectUtils;
    import com.pickgliss.ui.AlertManager;
    import com.pickgliss.ui.LayerManager;
    import ddt.constants.CacheConsts;
    import flash.text.TextField;
    import flash.text.TextFieldType;
    import __AS3__.vec.Vector;
    import consortion.data.ConsortiaAssetLevelOffer;
    import road7th.data.DictionaryData;
    import consortion.analyze.ConsortionMemberAnalyer;
    import consortion.analyze.ConsortionListAnalyzer;
    import ddt.data.ConsortiaInfo;
    import consortion.analyze.ConsortionApplyListAnalyzer;
    import consortion.analyze.ConsortionInventListAnalyzer;
    import consortion.analyze.ConsortionLevelUpAnalyzer;
    import consortion.analyze.ConsortionEventListAnalyzer;
    import consortion.analyze.ConsortionBuildingUseConditionAnalyer;
    import consortion.analyze.ConsortionDutyListAnalyzer;
    import consortion.analyze.ConsortionPollListAnalyzer;
    import consortion.analyze.ConsortionSkillInfoAnalyzer;
    import consortion.analyze.ConsortionNewSkillInfoAnalyzer;
    import consortion.analyze.ConsortiaShopListAnalyzer;
    import ddt.utils.RequestVairableCreater;
    import flash.net.URLVariables;
    import com.pickgliss.loader.LoadResourceManager;
    import com.pickgliss.loader.BaseLoader;
    import com.pickgliss.loader.LoaderEvent;
    import ddt.manager.LeavePageManager;
    import consortion.data.BadgeInfo;
    import road7th.utils.DateUtils;
    import ddt.manager.BadgeInfoManager;
    import ddt.manager.ServerConfigManager;
    import com.pickgliss.ui.ComponentFactory;
    import consortion.view.selfConsortia.TaxFrame;
    import consortion.view.selfConsortia.ManagerFrame;
    import consortion.view.selfConsortia.ConsortionShopFrame;
    import consortion.view.selfConsortia.TakeInMemberFrame;
    import consortion.view.selfConsortia.ConsortionQuitFrame;
    import consortion.view.club.ClubViewFrame;
    import __AS3__.vec.*;

    public class ConsortionModelControl extends EventDispatcher 
    {

        private static var _instance:ConsortionModelControl;

        private var _model:ConsortionModel;
        private var _consortionMapModel:ConsortionWalkMapModel;
        private var _taskModel:ConsortiaTaskModel;
        private var str:String;
        private var _invateID:int;
        private var _enterConfirm:BaseAlerFrame;

        public function ConsortionModelControl()
        {
            this._model = new ConsortionModel();
            this._consortionMapModel = new ConsortionWalkMapModel();
            this._taskModel = new ConsortiaTaskModel();
            this.addEvent();
        }

        public static function get Instance():ConsortionModelControl
        {
            if (_instance == null)
            {
                _instance = new (ConsortionModelControl)();
            };
            return (_instance);
        }


        public function get model():ConsortionModel
        {
            return (this._model);
        }

        public function get TaskModel():ConsortiaTaskModel
        {
            return (this._taskModel);
        }

        public function get consortionMapModel():ConsortionWalkMapModel
        {
            return (this._consortionMapModel);
        }

        private function addEvent():void
        {
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIA_TRYIN, this.__consortiaTryIn);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIA_TRYIN_DEL, this.__tryInDel);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIA_TRYIN_PASS, this.__consortiaTryInPass);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIA_DISBAND, this.__consortiaDisband);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIA_INVITE, this.__consortiaInvate);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIA_INVITE_PASS, this.__consortiaInvitePass);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIA_INVITE_DELETE, this.__consortiaInviteDetele);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIA_CREATE, this.__consortiaCreate);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIA_PLACARD_UPDATE, this.__consortiaPlacardUpdate);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIA_EQUIP_CONTROL, this.__onConsortiaEquipControl);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIA_RICHES_OFFER, this.__givceOffer);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIA_RESPONSE, this.__consortiaResponse);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIA_RENEGADE, this.__renegadeUser);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIA_LEVEL_UP, this.__onConsortiaLevelUp);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIA_SHOP_UP, this.__onConsortiaShopUp);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIA_HALL_UP, this.__onConsortiahallUp);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIA_SKILL_UP, this.__onConsortiaskillUp);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIA_CHAIRMAN_CHAHGE, this.__oncharmanChange);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIA_DUTY_UPDATE, this.__dutyUpdata);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIA_USER_GRADE_UPDATE, this.__consortiaUserUpGrade);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIA_DESCRIPTION_UPDATE, this.__consortiaDescriptionUpdate);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SKILL_SOCKET, this.__skillChangehandler);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIA_MAIL_MESSAGE, this.__consortiaMailMessage);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.BUY_BADGE, this.__buyBadgeHandler);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PUBLISH_TASK, this.__updateTaskRemainTime);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SYNC_CONSORTION_RICH, this.__syncConsortionRich);
        }

        private function __consortiaResponse(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:PackageIn;
            var _local_4:int;
            var _local_5:String;
            var _local_6:ConsortiaPlayerInfo;
            var _local_7:Boolean;
            var _local_8:int;
            var _local_9:String;
            var _local_10:int;
            var _local_11:int;
            var _local_12:String;
            var _local_13:int;
            var _local_14:int;
            var _local_15:Boolean;
            var _local_16:String;
            var _local_17:int;
            var _local_18:String;
            var _local_19:int;
            var _local_20:String;
            var _local_21:int;
            var _local_22:String;
            var _local_23:int;
            var _local_24:String;
            var _local_25:int;
            var _local_26:int;
            var _local_27:int;
            var _local_28:int;
            var _local_29:String;
            var _local_30:int;
            var _local_31:String;
            var _local_32:int;
            var _local_33:int;
            var _local_34:String;
            var _local_35:int;
            var _local_36:int;
            var _local_37:String;
            var _local_38:int;
            var _local_39:String;
            var _local_40:int;
            var _local_41:String;
            var _local_42:String;
            var _local_43:InteractiveObject;
            var _local_44:String;
            var _local_45:String;
            var _local_46:String;
            _local_2 = _arg_1.pkg;
            var _local_3:int = _local_2.readByte();
            switch (_local_3)
            {
                case 1:
                    _local_6 = new ConsortiaPlayerInfo();
                    _local_6.privateID = _local_2.readInt();
                    _local_7 = _local_2.readBoolean();
                    _local_6.ConsortiaID = _local_2.readInt();
                    _local_6.ConsortiaName = _local_2.readUTF();
                    _local_6.ID = _local_2.readInt();
                    _local_6.NickName = _local_2.readUTF();
                    _local_8 = _local_2.readInt();
                    _local_9 = _local_2.readUTF();
                    _local_6.DutyID = _local_2.readInt();
                    _local_6.DutyName = _local_2.readUTF();
                    _local_6.Offer = _local_2.readInt();
                    _local_6.RichesOffer = _local_2.readInt();
                    _local_6.RichesRob = _local_2.readInt();
                    _local_6.LastDate = _local_2.readDateString();
                    _local_6.Grade = _local_2.readInt();
                    _local_6.DutyLevel = _local_2.readInt();
                    _local_10 = _local_2.readInt();
                    _local_6.playerState = new PlayerState(_local_10);
                    _local_6.Sex = _local_2.readBoolean();
                    _local_6.Right = _local_2.readInt();
                    _local_6.WinCount = _local_2.readInt();
                    _local_6.TotalCount = _local_2.readInt();
                    _local_6.EscapeCount = _local_2.readInt();
                    _local_6.Repute = _local_2.readInt();
                    _local_6.LoginName = _local_2.readUTF();
                    _local_6.FightPower = _local_2.readInt();
                    _local_6.AchievementPoint = _local_2.readInt();
                    _local_6.honor = _local_2.readUTF();
                    _local_6.VIPtype = _local_2.readInt();
                    _local_11 = _local_2.readInt();
                    if (((_local_7) && (_local_6.ID == PlayerManager.Instance.Self.ID)))
                    {
                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.manager.PlayerManager.invite"));
                        MessageTipManager.getInstance().show("邀请通过！");
                    }
                    else
                    {
                        if (_local_6.ID == PlayerManager.Instance.Self.ID)
                        {
                            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.manager.PlayerManager.one", _local_6.ConsortiaName));
                        };
                    };
                    _local_12 = "";
                    if (_local_6.ID == PlayerManager.Instance.Self.ID)
                    {
                        this.setPlayerConsortia(_local_6.ConsortiaID, _local_6.ConsortiaName);
                        this.getConsortionMember(this.memberListComplete);
                        this.getConsortionList(this.selfConsortionComplete, 1, 6, _local_6.ConsortiaName, -1, -1, -1, _local_6.ConsortiaID);
                        if (_local_7)
                        {
                            _local_12 = LanguageMgr.GetTranslation("tank.manager.PlayerManager.isInvent.msg", _local_6.ConsortiaName);
                        }
                        else
                        {
                            _local_12 = LanguageMgr.GetTranslation("tank.manager.PlayerManager.pass", _local_6.ConsortiaName);
                        };
                        if (StateManager.currentStateType == StateType.CONSORTIA)
                        {
                            dispatchEvent(new ConsortionEvent(ConsortionEvent.CONSORTION_STATE_CHANGE));
                        };
                        TaskManager.instance.requestClubTask();
                        if (PathManager.solveExternalInterfaceEnabel())
                        {
                            ExternalInterfaceManager.sendToAgent(5, PlayerManager.Instance.Self.ID, PlayerManager.Instance.Self.NickName, ServerManager.Instance.zoneName, -1, _local_6.ConsortiaName);
                        };
                    }
                    else
                    {
                        this._model.addMember(_local_6);
                        PlayerManager.Instance.Self.consortiaInfo.Count = _local_11;
                        _local_12 = LanguageMgr.GetTranslation("tank.manager.PlayerManager.player", _local_6.NickName);
                    };
                    _local_12 = StringHelper.rePlaceHtmlTextField(_local_12);
                    ChatManager.Instance.sysChatYellow(_local_12);
                    return;
                case 2:
                    _local_4 = _local_2.readInt();
                    PlayerManager.Instance.Self.consortiaInfo.Level = 0;
                    this.setPlayerConsortia();
                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.manager.PlayerManager.your"));
                    this.getConsortionMember();
                    ChatManager.Instance.sysChatYellow(LanguageMgr.GetTranslation("tank.manager.PlayerManager.disband"));
                    if (StateManager.currentStateType == StateType.CONSORTIA)
                    {
                        StateManager.back();
                    };
                    ConsortionModelControl.Instance.model.deleteOneConsortion(_local_4);
                    return;
                case 3:
                    _local_4 = _local_2.readInt();
                    _local_13 = _local_2.readInt();
                    _local_14 = _local_2.readInt();
                    _local_15 = _local_2.readBoolean();
                    _local_5 = _local_2.readUTF();
                    _local_16 = _local_2.readUTF();
                    if (PlayerManager.Instance.Self.ID == _local_4)
                    {
                        this.setPlayerConsortia();
                        this.getConsortionMember();
                        TaskManager.instance.onGuildUpdate();
                        _local_41 = "";
                        if (_local_15)
                        {
                            _local_41 = LanguageMgr.GetTranslation("tank.manager.PlayerManager.delect", _local_16);
                            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.manager.PlayerManager.hit"));
                        }
                        else
                        {
                            _local_41 = LanguageMgr.GetTranslation("tank.manager.PlayerManager.leave");
                        };
                        if (StateManager.currentStateType == StateType.CONSORTIA)
                        {
                            StateManager.back();
                        };
                        _local_41 = StringHelper.rePlaceHtmlTextField(_local_41);
                        ChatManager.Instance.sysChatRed(_local_41);
                    }
                    else
                    {
                        this.removeConsortiaMember(_local_4, _local_15, _local_16);
                        PlayerManager.Instance.Self.consortiaInfo.Count = _local_14;
                    };
                    return;
                case 4:
                    this._invateID = _local_2.readInt();
                    _local_17 = _local_2.readInt();
                    _local_18 = _local_2.readUTF();
                    _local_19 = _local_2.readInt();
                    _local_20 = _local_2.readUTF();
                    _local_21 = _local_2.readInt();
                    _local_22 = _local_2.readUTF();
                    if (SharedManager.Instance.showCI)
                    {
                        if (this.str != _local_20)
                        {
                            SoundManager.instance.play("018");
                            _local_42 = (_local_20 + LanguageMgr.GetTranslation("tank.manager.PlayerManager.come", _local_22));
                            _local_42 = StringHelper.rePlaceHtmlTextField(_local_42);
                            _local_43 = StageReferance.stage.focus;
                            if (this._enterConfirm)
                            {
                                this._enterConfirm.removeEventListener(FrameEvent.RESPONSE, this.__enterConsortiaConfirm);
                                ObjectUtils.disposeObject(this._enterConfirm);
                                this._enterConfirm = null;
                            };
                            this._enterConfirm = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tank.manager.PlayerManager.request"), _local_42, LanguageMgr.GetTranslation("tank.manager.PlayerManager.sure"), LanguageMgr.GetTranslation("tank.manager.PlayerManager.refuse"), false, true, true, LayerManager.ALPHA_BLOCKGOUND, CacheConsts.ALERT_IN_FIGHT);
                            this._enterConfirm.addEventListener(FrameEvent.RESPONSE, this.__enterConsortiaConfirm);
                            this.str = _local_20;
                            if ((_local_43 is TextField))
                            {
                                if (TextField(_local_43).type == TextFieldType.INPUT)
                                {
                                    StageReferance.stage.focus = _local_43;
                                };
                            };
                        };
                    };
                    return;
                case 5:
                    return;
                case 6:
                    _local_23 = _local_2.readInt();
                    _local_24 = _local_2.readUTF();
                    _local_25 = _local_2.readInt();
                    if (PlayerManager.Instance.Self.ConsortiaID == _local_23)
                    {
                        PlayerManager.Instance.Self.consortiaInfo.Level = _local_25;
                        ChatManager.Instance.sysChatYellow(LanguageMgr.GetTranslation("tank.manager.PlayerManager.upgrade", _local_25, this._model.getLevelData(_local_25).Count));
                        TaskManager.instance.requestClubTask();
                        SoundManager.instance.play("1001");
                        this.getConsortionList(this.selfConsortionComplete, 1, 6, PlayerManager.Instance.Self.ConsortiaName, -1, -1, -1, PlayerManager.Instance.Self.ConsortiaID);
                        TaskManager.instance.onGuildUpdate();
                    };
                    return;
                case 7:
                    return;
                case 8:
                    _local_26 = _local_2.readByte();
                    _local_27 = _local_2.readInt();
                    _local_28 = _local_2.readInt();
                    _local_29 = _local_2.readUTF();
                    _local_30 = _local_2.readInt();
                    _local_31 = _local_2.readUTF();
                    _local_32 = _local_2.readInt();
                    _local_33 = _local_2.readInt();
                    _local_34 = _local_2.readUTF();
                    if (_local_26 != 1)
                    {
                        if (_local_26 == 2)
                        {
                            this.updateDutyInfo(_local_30, _local_31, _local_32);
                        }
                        else
                        {
                            if (_local_26 == 3)
                            {
                                this.upDateSelfDutyInfo(_local_30, _local_31, _local_32);
                            }
                            else
                            {
                                if (_local_26 == 4)
                                {
                                    this.upDateSelfDutyInfo(_local_30, _local_31, _local_32);
                                }
                                else
                                {
                                    if (_local_26 == 5)
                                    {
                                        this.upDateSelfDutyInfo(_local_30, _local_31, _local_32);
                                    }
                                    else
                                    {
                                        if (_local_26 == 6)
                                        {
                                            this.updateConsortiaMemberDuty(_local_28, _local_30, _local_31, _local_32);
                                            _local_44 = "";
                                            if (_local_28 == PlayerManager.Instance.Self.ID)
                                            {
                                                _local_44 = LanguageMgr.GetTranslation("tank.manager.PlayerManager.youUpgrade", _local_34, _local_31);
                                            }
                                            else
                                            {
                                                if (_local_28 == _local_33)
                                                {
                                                    _local_44 = LanguageMgr.GetTranslation("tank.manager.PlayerManager.upgradeSelf", _local_29, _local_31);
                                                }
                                                else
                                                {
                                                    _local_44 = LanguageMgr.GetTranslation("tank.manager.PlayerManager.upgradeOther", _local_34, _local_29, _local_31);
                                                };
                                            };
                                            _local_44 = StringHelper.rePlaceHtmlTextField(_local_44);
                                            ChatManager.Instance.sysChatYellow(_local_44);
                                        }
                                        else
                                        {
                                            if (_local_26 == 7)
                                            {
                                                this.updateConsortiaMemberDuty(_local_28, _local_30, _local_31, _local_32);
                                                _local_45 = "";
                                                if (_local_28 == PlayerManager.Instance.Self.ID)
                                                {
                                                    _local_45 = LanguageMgr.GetTranslation("tank.manager.PlayerManager.youDemotion", _local_34, _local_31);
                                                }
                                                else
                                                {
                                                    if (_local_28 == _local_33)
                                                    {
                                                        _local_45 = LanguageMgr.GetTranslation("tank.manager.PlayerManager.demotionSelf", _local_29, _local_31);
                                                    }
                                                    else
                                                    {
                                                        _local_45 = LanguageMgr.GetTranslation("tank.manager.PlayerManager.demotionOther", _local_34, _local_29, _local_31);
                                                    };
                                                };
                                                _local_45 = StringHelper.rePlaceHtmlTextField(_local_45);
                                                ChatManager.Instance.sysChatYellow(_local_45);
                                            }
                                            else
                                            {
                                                if (_local_26 == 8)
                                                {
                                                    this.updateConsortiaMemberDuty(_local_28, _local_30, _local_31, _local_32);
                                                    SoundManager.instance.play("1001");
                                                }
                                                else
                                                {
                                                    if (_local_26 == 9)
                                                    {
                                                        this.updateConsortiaMemberDuty(_local_28, _local_30, _local_31, _local_32);
                                                        PlayerManager.Instance.Self.consortiaInfo.ChairmanName = _local_29;
                                                        _local_46 = (((("<" + _local_29) + ">") + LanguageMgr.GetTranslation("tank.manager.PlayerManager.up")) + _local_31);
                                                        _local_46 = StringHelper.rePlaceHtmlTextField(_local_46);
                                                        ChatManager.Instance.sysChatYellow(_local_46);
                                                        SoundManager.instance.play("1001");
                                                    };
                                                };
                                            };
                                        };
                                    };
                                };
                            };
                        };
                    };
                    return;
                case 9:
                    _local_35 = _local_2.readInt();
                    _local_36 = _local_2.readInt();
                    _local_37 = _local_2.readUTF();
                    _local_38 = _local_2.readInt();
                    if (_local_35 != PlayerManager.Instance.Self.ConsortiaID)
                    {
                        return;
                    };
                    _local_39 = "";
                    if (PlayerManager.Instance.Self.ID == _local_36)
                    {
                        _local_39 = LanguageMgr.GetTranslation("tank.manager.PlayerManager.contributionSelf", _local_38);
                    }
                    else
                    {
                        _local_39 = LanguageMgr.GetTranslation("tank.manager.PlayerManager.contributionOther", _local_37, _local_38);
                    };
                    ChatManager.Instance.sysChatYellow(_local_39);
                    return;
                case 10:
                    this.consortiaUpLevel(10, _local_2.readInt(), _local_2.readUTF(), _local_2.readInt());
                    return;
                case 11:
                    this.consortiaUpLevel(11, _local_2.readInt(), _local_2.readUTF(), _local_2.readInt());
                    return;
                case 12:
                    this.consortiaUpLevel(12, _local_2.readInt(), _local_2.readUTF(), _local_2.readInt());
                    return;
                case 13:
                    this.consortiaUpLevel(13, _local_2.readInt(), _local_2.readUTF(), _local_2.readInt());
                    return;
                case 14:
                    _local_40 = _local_2.readInt();
                    switch (_local_40)
                    {
                        case 1:
                            PlayerManager.Instance.Self.consortiaInfo.IsVoting = true;
                            break;
                        case 2:
                            PlayerManager.Instance.Self.consortiaInfo.IsVoting = false;
                            break;
                        case 3:
                            PlayerManager.Instance.Self.consortiaInfo.IsVoting = false;
                            break;
                    };
                    return;
                case 15:
                    _local_2.readInt();
                    ChatManager.Instance.sysChatYellow(_local_2.readUTF());
                    return;
                case 16:
                    this.getConsortionList(this.selfConsortionComplete, 1, 6, PlayerManager.Instance.Self.ConsortiaName, -1, -1, -1, PlayerManager.Instance.Self.ConsortiaID);
                    return;
            };
        }

        private function consortiaUpLevel(_arg_1:int, _arg_2:int, _arg_3:String, _arg_4:int):void
        {
            if (_arg_2 != PlayerManager.Instance.Self.ConsortiaID)
            {
                return;
            };
            SoundManager.instance.play("1001");
            var _local_5:String = "";
            if (_arg_1 == 10)
            {
                if (PlayerManager.Instance.Self.DutyLevel == 1)
                {
                    _local_5 = LanguageMgr.GetTranslation("tank.manager.PlayerManager.consortiaShop", _arg_4);
                }
                else
                {
                    _local_5 = LanguageMgr.GetTranslation("tank.manager.PlayerManager.consortiaShop2", _arg_4);
                    PlayerManager.Instance.Self.consortiaInfo.ShopLevel = _arg_4;
                };
            }
            else
            {
                if (_arg_1 == 11)
                {
                    if (PlayerManager.Instance.Self.DutyLevel == 1)
                    {
                        _local_5 = LanguageMgr.GetTranslation("tank.manager.PlayerManager.consortiaStore", _arg_4);
                    }
                    else
                    {
                        _local_5 = LanguageMgr.GetTranslation("tank.manager.PlayerManager.consortiaStore2", _arg_4);
                        PlayerManager.Instance.Self.consortiaInfo.SmithLevel = _arg_4;
                    };
                }
                else
                {
                    if (_arg_1 == 12)
                    {
                        if (PlayerManager.Instance.Self.DutyLevel == 1)
                        {
                            _local_5 = LanguageMgr.GetTranslation("tank.manager.PlayerManager.consortiaSmith", _arg_4);
                        }
                        else
                        {
                            _local_5 = LanguageMgr.GetTranslation("tank.manager.PlayerManager.consortiaSmith2", _arg_4);
                            PlayerManager.Instance.Self.consortiaInfo.StoreLevel = _arg_4;
                        };
                    };
                };
            };
            ChatManager.Instance.sysChatYellow(_local_5);
            this.getConsortionList(this.selfConsortionComplete, 1, 6, PlayerManager.Instance.Self.ConsortiaName, -1, -1, -1, PlayerManager.Instance.Self.ConsortiaID);
            TaskManager.instance.onGuildUpdate();
        }

        private function updateDutyInfo(_arg_1:int, _arg_2:String, _arg_3:int):void
        {
            var _local_4:ConsortiaPlayerInfo;
            for each (_local_4 in this._model.memberList)
            {
                if (_local_4.DutyLevel == _arg_1)
                {
                    (_local_4.DutyLevel == _arg_1);
                    _local_4.DutyName = _arg_2;
                    _local_4.Right = _arg_3;
                    this._model.updataMember(_local_4);
                };
            };
        }

        private function upDateSelfDutyInfo(_arg_1:int, _arg_2:String, _arg_3:int):void
        {
            var _local_4:ConsortiaPlayerInfo;
            for each (_local_4 in this._model.memberList)
            {
                if (_local_4.ID == PlayerManager.Instance.Self.ID)
                {
                    PlayerManager.Instance.Self.beginChanges();
                    _local_4.DutyLevel = (PlayerManager.Instance.Self.DutyLevel = _arg_1);
                    _local_4.DutyName = (PlayerManager.Instance.Self.DutyName = _arg_2);
                    _local_4.Right = (PlayerManager.Instance.Self.Right = _arg_3);
                    PlayerManager.Instance.Self.commitChanges();
                    this._model.updataMember(_local_4);
                };
            };
        }

        private function updateConsortiaMemberDuty(_arg_1:int, _arg_2:int, _arg_3:String, _arg_4:int):void
        {
            var _local_5:ConsortiaPlayerInfo;
            for each (_local_5 in this._model.memberList)
            {
                if (_local_5.ID == _arg_1)
                {
                    _local_5.beginChanges();
                    _local_5.DutyLevel = _arg_2;
                    _local_5.DutyName = _arg_3;
                    _local_5.Right = _arg_4;
                    if (_local_5.ID == PlayerManager.Instance.Self.ID)
                    {
                        PlayerManager.Instance.Self.beginChanges();
                        PlayerManager.Instance.Self.DutyLevel = _arg_2;
                        PlayerManager.Instance.Self.DutyName = _arg_3;
                        PlayerManager.Instance.Self.Right = _arg_4;
                        PlayerManager.Instance.Self.consortiaInfo.Level = ((PlayerManager.Instance.Self.consortiaInfo.Level == 0) ? 1 : PlayerManager.Instance.Self.consortiaInfo.Level);
                        PlayerManager.Instance.Self.commitChanges();
                        this.getConsortionList(this.selfConsortionComplete, 1, 6, PlayerManager.Instance.Self.consortiaInfo.ConsortiaName, -1, -1, -1, PlayerManager.Instance.Self.consortiaInfo.ConsortiaID);
                    };
                    _local_5.commitChanges();
                    this._model.updataMember(_local_5);
                };
            };
        }

        private function removeConsortiaMember(_arg_1:int, _arg_2:Boolean, _arg_3:String):void
        {
            var _local_4:ConsortiaPlayerInfo;
            var _local_5:String;
            for each (_local_4 in this._model.memberList)
            {
                if (_local_4.ID == _arg_1)
                {
                    _local_5 = "";
                    if (_arg_2)
                    {
                        _local_5 = LanguageMgr.GetTranslation("tank.manager.PlayerManager.consortia", _arg_3, _local_4.NickName);
                    }
                    else
                    {
                        _local_5 = LanguageMgr.GetTranslation("tank.manager.PlayerManager.leaveconsortia", _local_4.NickName);
                    };
                    _local_5 = StringHelper.rePlaceHtmlTextField(_local_5);
                    ChatManager.Instance.sysChatYellow(_local_5);
                    this._model.removeMember(_local_4);
                };
            };
        }

        private function __enterConsortiaConfirm(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            var _local_2:BaseAlerFrame = (_arg_1.currentTarget as BaseAlerFrame);
            _local_2.removeEventListener(FrameEvent.RESPONSE, this.__enterConsortiaConfirm);
            if (_local_2)
            {
                ObjectUtils.disposeObject(_local_2);
                _local_2 = null;
            };
            if (((_arg_1.responseCode == FrameEvent.SUBMIT_CLICK) || (_arg_1.responseCode == FrameEvent.ENTER_CLICK)))
            {
                this.accpetConsortiaInvent();
            };
            if (((_arg_1.responseCode == FrameEvent.CLOSE_CLICK) || (_arg_1.responseCode == FrameEvent.CANCEL_CLICK)))
            {
                this.rejectConsortiaInvent();
            };
        }

        private function accpetConsortiaInvent():void
        {
            SocketManager.Instance.out.sendConsortiaInvatePass(this._invateID);
            this.str = "";
        }

        private function rejectConsortiaInvent():void
        {
            SocketManager.Instance.out.sendConsortiaInvateDelete(this._invateID);
            this.str = "";
        }

        private function __givceOffer(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:int = _arg_1.pkg.readInt();
            var _local_3:Boolean = _arg_1.pkg.readBoolean();
            var _local_4:String = _arg_1.pkg.readUTF();
            MessageTipManager.getInstance().show(_local_4);
            if (_local_3)
            {
                this._model.getConsortiaMemberInfo(PlayerManager.Instance.Self.ID).RichesOffer = (this._model.getConsortiaMemberInfo(PlayerManager.Instance.Self.ID).RichesOffer + _local_2);
                TaskManager.instance.onGuildUpdate();
            };
        }

        private function __onConsortiaEquipControl(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_3:Vector.<ConsortiaAssetLevelOffer>;
            var _local_4:int;
            var _local_2:Boolean = _arg_1.pkg.readBoolean();
            if (_local_2)
            {
                _local_3 = new Vector.<ConsortiaAssetLevelOffer>();
                _local_4 = 0;
                while (_local_4 < 7)
                {
                    _local_3[_local_4] = new ConsortiaAssetLevelOffer();
                    if (_local_4 < 5)
                    {
                        _local_3[_local_4].Type = 1;
                        _local_3[_local_4].Level = (_local_4 + 1);
                    }
                    else
                    {
                        if (_local_4 == 5)
                        {
                            _local_3[_local_4].Type = 2;
                        }
                        else
                        {
                            _local_3[_local_4].Type = 3;
                        };
                    };
                    _local_4++;
                };
                _local_3[0].Riches = _arg_1.pkg.readInt();
                _local_3[1].Riches = _arg_1.pkg.readInt();
                _local_3[2].Riches = _arg_1.pkg.readInt();
                _local_3[3].Riches = _arg_1.pkg.readInt();
                _local_3[4].Riches = _arg_1.pkg.readInt();
                _local_3[5].Riches = _arg_1.pkg.readInt();
                _local_3[6].Riches = _arg_1.pkg.readInt();
                if (PlayerManager.Instance.Self.ID == PlayerManager.Instance.Self.consortiaInfo.ChairmanID)
                {
                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.consortia.onConsortiaEquipControl.executeSuccess"));
                };
                this._model.useConditionList = _local_3;
            }
            else
            {
                if (PlayerManager.Instance.Self.ID == PlayerManager.Instance.Self.consortiaInfo.ChairmanID)
                {
                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.consortia.onConsortiaEquipControl.executeFail"));
                };
            };
        }

        private function __consortiaTryIn(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:Boolean = _arg_1.pkg.readBoolean();
            var _local_3:String = _arg_1.pkg.readUTF();
            MessageTipManager.getInstance().show(_local_3);
            if (_local_2)
            {
                this.getApplyRecordList(this.applyListComplete, PlayerManager.Instance.Self.ID);
            };
        }

        private function __tryInDel(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:int = _arg_1.pkg.readInt();
            var _local_3:Boolean = _arg_1.pkg.readBoolean();
            var _local_4:String = _arg_1.pkg.readUTF();
            MessageTipManager.getInstance().show(_local_4);
            if (_local_3)
            {
                this._model.deleteOneApplyRecord(_local_2);
            };
        }

        private function __consortiaTryInPass(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:int = _arg_1.pkg.readInt();
            var _local_3:Boolean = _arg_1.pkg.readBoolean();
            var _local_4:String = _arg_1.pkg.readUTF();
            MessageTipManager.getInstance().show(_local_4);
            if (_local_3)
            {
                this._model.deleteOneApplyRecord(_local_2);
            };
        }

        private function __consortiaInvate(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:Boolean = _arg_1.pkg.readBoolean();
            var _local_3:String = _arg_1.pkg.readUTF();
            MessageTipManager.getInstance().show(_local_3);
        }

        private function __consortiaInvitePass(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:Boolean = _arg_1.pkg.readBoolean();
            var _local_3:int = _arg_1.pkg.readInt();
            var _local_4:String = _arg_1.pkg.readUTF();
            var _local_5:String = _arg_1.pkg.readUTF();
            MessageTipManager.getInstance().show(_local_5);
            if (_local_2)
            {
                this.setPlayerConsortia(_local_3, _local_4);
                this.getConsortionMember(this.memberListComplete);
                this.getConsortionList(this.selfConsortionComplete, 1, 6, _local_4, -1, -1, -1, _local_3);
                if (StateManager.currentStateType == StateType.MAIN)
                {
                    SocketManager.Instance.out.SendenterConsortion(true);
                };
            };
        }

        private function __consortiaInviteDetele(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:int = _arg_1.pkg.readInt();
            var _local_3:Boolean = _arg_1.pkg.readBoolean();
            var _local_4:String = _arg_1.pkg.readUTF();
            MessageTipManager.getInstance().show(_local_4);
        }

        private function __consortiaCreate(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:int = _arg_1.pkg.readInt();
            var _local_3:Boolean = _arg_1.pkg.readBoolean();
            var _local_4:String = _arg_1.pkg.readUTF();
            var _local_5:String = _arg_1.pkg.readUTF();
            MessageTipManager.getInstance().show(_local_5);
            var _local_6:int = _arg_1.pkg.readInt();
            var _local_7:String = _arg_1.pkg.readUTF();
            var _local_8:int = _arg_1.pkg.readInt();
            if (_local_3)
            {
                this.setPlayerConsortia(_local_2, _local_4);
                this.getConsortionMember(this.memberListComplete);
                this.getConsortionList(this.selfConsortionComplete, 1, 6, _local_4, -1, -1, -1, _local_2);
                dispatchEvent(new ConsortionEvent(ConsortionEvent.CONSORTION_STATE_CHANGE));
                TaskManager.instance.requestClubTask();
                if (PathManager.solveExternalInterfaceEnabel())
                {
                    ExternalInterfaceManager.sendToAgent(4, PlayerManager.Instance.Self.ID, PlayerManager.Instance.Self.NickName, ServerManager.Instance.zoneName, -1, _local_4);
                };
                SocketManager.Instance.out.SendenterConsortion(true);
            };
        }

        private function __consortiaDisband(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:int;
            var _local_3:String;
            var _local_4:int;
            var _local_5:int;
            var _local_6:String;
            if (_arg_1.pkg.readBoolean())
            {
                _local_2 = _arg_1.pkg.readInt();
                if (_arg_1.pkg.readInt() == PlayerManager.Instance.Self.ID)
                {
                    this.setPlayerConsortia();
                    if (StateManager.currentStateType == StateType.CONSORTIA)
                    {
                        StateManager.back();
                    };
                    _local_3 = _arg_1.pkg.readUTF();
                    ConsortionModelControl.Instance.model.deleteOneConsortion(_local_2);
                };
            }
            else
            {
                _local_4 = _arg_1.pkg.readInt();
                _local_5 = _arg_1.pkg.readInt();
                _local_6 = _arg_1.pkg.readUTF();
                MessageTipManager.getInstance().show(_local_6);
            };
        }

        private function __consortiaPlacardUpdate(_arg_1:CrazyTankSocketEvent):void
        {
            PlayerManager.Instance.Self.consortiaInfo.Placard = _arg_1.pkg.readUTF();
            var _local_2:Boolean = _arg_1.pkg.readBoolean();
            var _local_3:String = _arg_1.pkg.readUTF();
            MessageTipManager.getInstance().show(_local_3);
        }

        private function __renegadeUser(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:Boolean = _arg_1.pkg.readBoolean();
            var _local_3:int = _arg_1.pkg.readInt();
            var _local_4:String = _arg_1.pkg.readUTF();
            MessageTipManager.getInstance().show(_local_4);
            if (_local_2)
            {
                PlayerManager.Instance.Self.consortiaInfo.Count = _local_3;
            };
        }

        private function __onConsortiaLevelUp(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:Boolean = _arg_1.pkg.readBoolean();
            var _local_3:String = _arg_1.pkg.readUTF();
            MessageTipManager.getInstance().show(_local_3);
            if (_local_2)
            {
                PlayerManager.Instance.Self.consortiaInfo.Level = PlayerManager.Instance.Self.consortiaInfo.Level;
            };
        }

        private function __onConsortiaShopUp(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:Boolean = _arg_1.pkg.readBoolean();
            var _local_3:String = _arg_1.pkg.readUTF();
            if (_local_2)
            {
                PlayerManager.Instance.Self.consortiaInfo.ShopLevel = (PlayerManager.Instance.Self.consortiaInfo.ShopLevel + 1);
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.manager.PlayerManager.consortiaShop", PlayerManager.Instance.Self.consortiaInfo.ShopLevel));
            };
        }

        private function __onConsortiahallUp(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:Boolean = _arg_1.pkg.readBoolean();
            var _local_3:String = _arg_1.pkg.readUTF();
            if (_local_2)
            {
                PlayerManager.Instance.Self.consortiaInfo.StoreLevel = (PlayerManager.Instance.Self.consortiaInfo.StoreLevel + 1);
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.manager.PlayerManager.consortiaSmith", PlayerManager.Instance.Self.consortiaInfo.StoreLevel));
            }
            else
            {
                MessageTipManager.getInstance().show(_local_3);
            };
        }

        private function __onConsortiaskillUp(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:Boolean = _arg_1.pkg.readBoolean();
            var _local_3:String = _arg_1.pkg.readUTF();
            if (_local_2)
            {
                PlayerManager.Instance.Self.consortiaInfo.SmithLevel = (PlayerManager.Instance.Self.consortiaInfo.SmithLevel + 1);
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.manager.PlayerManager.consortiaStore", PlayerManager.Instance.Self.consortiaInfo.SmithLevel));
            };
        }

        private function __oncharmanChange(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:Boolean = _arg_1.pkg.readBoolean();
            var _local_3:String = _arg_1.pkg.readUTF();
            MessageTipManager.getInstance().show(_local_3);
            dispatchEvent(new ConsortionEvent(ConsortionEvent.CHARMAN_CHANGE));
        }

        private function __dutyUpdata(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:Boolean = _arg_1.pkg.readBoolean();
            var _local_3:int = _arg_1.pkg.readInt();
            var _local_4:String = _arg_1.pkg.readUTF();
            MessageTipManager.getInstance().show(_local_4);
        }

        private function __consortiaUserUpGrade(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:int = _arg_1.pkg.readInt();
            var _local_3:Boolean = _arg_1.pkg.readBoolean();
            var _local_4:Boolean = _arg_1.pkg.readBoolean();
            var _local_5:String = _arg_1.pkg.readUTF();
            if (_local_3)
            {
                if (_local_4)
                {
                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.manager.PlayerManager.upsuccess"));
                }
                else
                {
                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.manager.PlayerManager.upfalse"));
                };
            }
            else
            {
                if (_local_4)
                {
                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.manager.PlayerManager.downsuccess"));
                }
                else
                {
                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.manager.PlayerManager.downfalse"));
                };
            };
        }

        private function __consortiaDescriptionUpdate(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:String = _arg_1.pkg.readUTF();
            var _local_3:Boolean = _arg_1.pkg.readBoolean();
            var _local_4:String = _arg_1.pkg.readUTF();
            MessageTipManager.getInstance().show(_local_4);
            if (_local_3)
            {
                PlayerManager.Instance.Self.consortiaInfo.Description = _local_2;
            };
        }

        private function __skillChangehandler(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:int = _arg_1.pkg.readInt();
            var _local_3:Boolean = _arg_1.pkg.readBoolean();
            var _local_4:DictionaryData = PlayerManager.Instance.Self.isLearnSkill;
            if (_local_3)
            {
                _local_4.add(_local_4.length, _local_2);
                dispatchEvent(new ConsortionEvent(ConsortionEvent.SKILL_STATE_CHANGE));
            };
        }

        private function __consortiaMailMessage(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:String = _arg_1.pkg.readUTF();
            var _local_3:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), _local_2, LanguageMgr.GetTranslation("ok"), "", false, true, true, LayerManager.BLCAK_BLOCKGOUND);
            _local_3.moveEnable = false;
            _local_3.addEventListener(FrameEvent.RESPONSE, this.__quitConsortiaResponse);
        }

        private function __quitConsortiaResponse(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            var _local_2:BaseAlerFrame = (_arg_1.currentTarget as BaseAlerFrame);
            _local_2.removeEventListener(FrameEvent.RESPONSE, this.__quitConsortiaResponse);
            _local_2.dispose();
            _local_2 = null;
        }

        private function setPlayerConsortia(_arg_1:uint=0, _arg_2:String=""):void
        {
            PlayerManager.Instance.Self.ConsortiaName = _arg_2;
            PlayerManager.Instance.Self.ConsortiaID = _arg_1;
            if (_arg_1 == 0)
            {
                PlayerManager.Instance.Self.consortiaInfo.Level = 0;
            };
        }

        public function memberListComplete(_arg_1:ConsortionMemberAnalyer):void
        {
            this._model.memberList = _arg_1.consortionMember;
            TaskManager.instance.onGuildUpdate();
        }

        public function clubSearchConsortions(_arg_1:ConsortionListAnalyzer):void
        {
            this._model.consortionList = _arg_1.consortionList;
            this._model.consortionsListTotalCount = _arg_1.consortionsTotalCount;
        }

        public function selfConsortionComplete(_arg_1:ConsortionListAnalyzer):void
        {
            if (_arg_1.consortionList.length > 0)
            {
                PlayerManager.Instance.Self.consortiaInfo = (_arg_1.consortionList[0] as ConsortiaInfo);
            };
        }

        public function applyListComplete(_arg_1:ConsortionApplyListAnalyzer):void
        {
            this._model.myApplyList = _arg_1.applyList;
            this._model.applyListTotalCount = _arg_1.totalCount;
        }

        public function InventListComplete(_arg_1:ConsortionInventListAnalyzer):void
        {
            this._model.inventList = _arg_1.inventList;
            this._model.inventListTotalCount = _arg_1.totalCount;
        }

        public function levelUpInfoComplete(_arg_1:ConsortionLevelUpAnalyzer):void
        {
            this._model.levelUpData = _arg_1.levelUpData;
        }

        public function eventListComplete(_arg_1:ConsortionEventListAnalyzer):void
        {
            this._model.eventList = _arg_1.eventList;
        }

        public function useConditionListComplete(_arg_1:ConsortionBuildingUseConditionAnalyer):void
        {
            this._model.useConditionList = _arg_1.useConditionList;
        }

        public function dutyListComplete(_arg_1:ConsortionDutyListAnalyzer):void
        {
            this._model.dutyList = _arg_1.dutyList;
        }

        public function pollListComplete(_arg_1:ConsortionPollListAnalyzer):void
        {
            this._model.pollList = _arg_1.pollList;
        }

        public function skillInfoListComplete(_arg_1:ConsortionSkillInfoAnalyzer):void
        {
            this._model.skillInfoList = _arg_1.skillInfoList;
        }

        public function newSkillInfoListComplete(_arg_1:ConsortionNewSkillInfoAnalyzer):void
        {
            this._model.newSkillInfoList = _arg_1.newSkillInfoList;
        }

        public function consortionProbabilityInfoListComplete(_arg_1:ConsortiaShopListAnalyzer):void
        {
            this._model.proBabiliInfoList = _arg_1.ProbabilityInfoList;
        }

        public function getConsortionList(_arg_1:Function, _arg_2:int=1, _arg_3:int=6, _arg_4:String="", _arg_5:int=-1, _arg_6:int=-1, _arg_7:int=-1, _arg_8:int=-1):void
        {
            var _local_9:URLVariables = RequestVairableCreater.creatWidthKey(true);
            _local_9["page"] = _arg_2;
            _local_9["size"] = 1000;
            _local_9["name"] = _arg_4;
            _local_9["level"] = _arg_7;
            _local_9["ConsortiaID"] = _arg_8;
            _local_9["order"] = _arg_5;
            _local_9["openApply"] = _arg_6;
            var _local_10:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("ConsortiaList.ashx"), BaseLoader.COMPRESS_REQUEST_LOADER, _local_9);
            _local_10.loadErrorMessage = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.LoadMyconsortiaListError");
            _local_10.analyzer = new ConsortionListAnalyzer(_arg_1);
            _local_10.addEventListener(LoaderEvent.LOAD_ERROR, this.__onLoadError);
            LoadResourceManager.instance.startLoad(_local_10);
        }

        public function getApplyRecordList(_arg_1:Function, _arg_2:int=-1, _arg_3:int=-1):void
        {
            var _local_4:URLVariables = RequestVairableCreater.creatWidthKey(true);
            _local_4["page"] = 1;
            _local_4["size"] = 1000;
            _local_4["order"] = -1;
            _local_4["consortiaID"] = _arg_3;
            _local_4["applyID"] = -1;
            _local_4["userID"] = _arg_2;
            _local_4["userLevel"] = -1;
            var _local_5:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("ConsortiaApplyUsersList.ashx"), BaseLoader.REQUEST_LOADER, _local_4);
            _local_5.loadErrorMessage = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.LoadApplyRecordError");
            _local_5.analyzer = new ConsortionApplyListAnalyzer(_arg_1);
            _local_5.addEventListener(LoaderEvent.LOAD_ERROR, this.__onLoadError);
            LoadResourceManager.instance.startLoad(_local_5);
        }

        public function getInviteRecordList(_arg_1:Function):void
        {
            var _local_2:URLVariables = RequestVairableCreater.creatWidthKey(true);
            _local_2["page"] = 1;
            _local_2["size"] = 1000;
            _local_2["order"] = -1;
            _local_2["userID"] = PlayerManager.Instance.Self.ID;
            _local_2["inviteID"] = -1;
            var _local_3:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("ConsortiaInviteUsersList.ashx"), BaseLoader.REQUEST_LOADER, _local_2);
            _local_3.loadErrorMessage = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.LoadApplyRecordError");
            _local_3.analyzer = new ConsortionInventListAnalyzer(_arg_1);
            _local_3.addEventListener(LoaderEvent.LOAD_ERROR, this.__onLoadError);
            LoadResourceManager.instance.startLoad(_local_3);
        }

        public function getConsortionMember(_arg_1:Function=null):void
        {
            var _local_2:URLVariables;
            var _local_3:BaseLoader;
            if (PlayerManager.Instance.Self.ConsortiaID == 0)
            {
                this._model.memberList.clear();
            }
            else
            {
                _local_2 = RequestVairableCreater.creatWidthKey(true);
                _local_2["page"] = 1;
                _local_2["size"] = 10000;
                _local_2["order"] = -1;
                _local_2["consortiaID"] = PlayerManager.Instance.Self.ConsortiaID;
                _local_2["userID"] = -1;
                _local_2["state"] = -1;
                _local_2["rnd"] = Math.random();
                _local_3 = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("ConsortiaUsersList.ashx"), BaseLoader.REQUEST_LOADER, _local_2);
                _local_3.loadErrorMessage = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.LoadMemberInfoError");
                _local_3.analyzer = new ConsortionMemberAnalyer(_arg_1);
                _local_3.addEventListener(LoaderEvent.LOAD_ERROR, this.__onLoadError);
                LoadResourceManager.instance.startLoad(_local_3);
            };
        }

        public function getLevelUpInfo():BaseLoader
        {
            var _local_1:URLVariables = RequestVairableCreater.creatWidthKey(true);
            var _local_2:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("ConsortiaLevelList.xml"), BaseLoader.COMPRESS_REQUEST_LOADER, _local_1);
            _local_2.loadErrorMessage = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.LoadMyconsortiaLevelError");
            _local_2.analyzer = new ConsortionLevelUpAnalyzer(this.levelUpInfoComplete);
            _local_2.addEventListener(LoaderEvent.LOAD_ERROR, this.__onLoadError);
            return (_local_2);
        }

        public function loadEventList(_arg_1:Function, _arg_2:int=-1):void
        {
            var _local_3:URLVariables = RequestVairableCreater.creatWidthKey(true);
            _local_3["page"] = 1;
            _local_3["size"] = 50;
            _local_3["order"] = -1;
            _local_3["consortiaID"] = _arg_2;
            var _local_4:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("ConsortiaEventList.ashx"), BaseLoader.REQUEST_LOADER, _local_3);
            _local_4.loadErrorMessage = LanguageMgr.GetTranslation("ddt.consortion.loadEventList.fail");
            _local_4.analyzer = new ConsortionEventListAnalyzer(_arg_1);
            _local_4.addEventListener(LoaderEvent.LOAD_ERROR, this.__onLoadError);
            LoadResourceManager.instance.startLoad(_local_4);
        }

        public function loadUseConditionList(_arg_1:Function, _arg_2:int=-1):void
        {
            var _local_3:URLVariables = RequestVairableCreater.creatWidthKey(true);
            _local_3["consortiaID"] = _arg_2;
            _local_3["level"] = -1;
            _local_3["type"] = -1;
            var _local_4:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("ConsortiaEquipControlList.ashx"), BaseLoader.REQUEST_LOADER, _local_3);
            _local_4.loadErrorMessage = LanguageMgr.GetTranslation("ddt.consortion.loadUseCondition.fail");
            _local_4.analyzer = new ConsortionBuildingUseConditionAnalyer(_arg_1);
            _local_4.addEventListener(LoaderEvent.LOAD_ERROR, this.__onLoadError);
            LoadResourceManager.instance.startLoad(_local_4);
        }

        public function loadDutyList(_arg_1:Function, _arg_2:int=-1, _arg_3:int=-1):void
        {
            var _local_4:URLVariables = RequestVairableCreater.creatWidthKey(true);
            _local_4["page"] = 1;
            _local_4["size"] = 1000;
            _local_4["ConsortiaID"] = _arg_2;
            _local_4["order"] = -1;
            _local_4["dutyID"] = _arg_3;
            var _local_5:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("ConsortiaDutyList.ashx"), BaseLoader.REQUEST_LOADER, _local_4);
            _local_5.loadErrorMessage = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.LoadDutyListError");
            _local_5.analyzer = new ConsortionDutyListAnalyzer(_arg_1);
            _local_5.addEventListener(LoaderEvent.LOAD_ERROR, this.__onLoadError);
            LoadResourceManager.instance.startLoad(_local_5);
        }

        public function loadPollList(_arg_1:int):void
        {
            var _local_2:URLVariables = RequestVairableCreater.creatWidthKey(true);
            _local_2["ConsortiaID"] = _arg_1;
            var _local_3:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("ConsortiaCandidateList.ashx"), BaseLoader.REQUEST_LOADER, _local_2);
            _local_3.loadErrorMessage = LanguageMgr.GetTranslation("ddt.consortion.pollload.error");
            _local_3.analyzer = new ConsortionPollListAnalyzer(this.pollListComplete);
            _local_3.addEventListener(LoaderEvent.LOAD_ERROR, this.__onLoadError);
            LoadResourceManager.instance.startLoad(_local_3);
        }

        public function loadSkillInfoList():BaseLoader
        {
            var _local_1:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("ConsortiaBufferTemp.xml"), BaseLoader.COMPRESS_TEXT_LOADER);
            _local_1.loadErrorMessage = LanguageMgr.GetTranslation("ddt.consortion.skillInfo.loadError");
            _local_1.analyzer = new ConsortionSkillInfoAnalyzer(this.skillInfoListComplete);
            _local_1.addEventListener(LoaderEvent.LOAD_ERROR, this.__onLoadError);
            return (_local_1);
        }

        private function __onLoadError(_arg_1:LoaderEvent):void
        {
            var _local_2:String = _arg_1.loader.loadErrorMessage;
            if (_arg_1.loader.analyzer)
            {
                _local_2 = ((_arg_1.loader.loadErrorMessage + "\n") + _arg_1.loader.analyzer.message);
            };
            var _local_3:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("alert"), _arg_1.loader.loadErrorMessage, LanguageMgr.GetTranslation("tank.view.bagII.baglocked.sure"));
            _local_3.addEventListener(FrameEvent.RESPONSE, this.__onAlertResponse);
        }

        private function __onAlertResponse(_arg_1:FrameEvent):void
        {
            _arg_1.currentTarget.removeEventListener(FrameEvent.RESPONSE, this.__onAlertResponse);
            ObjectUtils.disposeObject(_arg_1.currentTarget);
            LeavePageManager.leaveToLoginPath();
        }

        private function __buyBadgeHandler(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_8:BadgeInfo;
            var _local_2:PackageIn = _arg_1.pkg;
            var _local_3:int = _local_2.readInt();
            var _local_4:int = _local_2.readInt();
            var _local_5:int = _local_2.readInt();
            var _local_6:Date = _local_2.readDate();
            var _local_7:Boolean = _local_2.readBoolean();
            if (_local_3 == PlayerManager.Instance.Self.ConsortiaID)
            {
                PlayerManager.Instance.Self.consortiaInfo.BadgeBuyTime = DateUtils.dateFormat(_local_6);
                PlayerManager.Instance.Self.consortiaInfo.BadgeID = _local_4;
                PlayerManager.Instance.Self.consortiaInfo.ValidDate = _local_5;
                PlayerManager.Instance.Self.badgeID = _local_4;
                _local_8 = BadgeInfoManager.instance.getBadgeInfoByID(_local_4);
                PlayerManager.Instance.Self.consortiaInfo.Riches = (PlayerManager.Instance.Self.consortiaInfo.Riches - _local_8.Cost);
            };
        }

        private function __updateTaskRemainTime(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:PackageIn = _arg_1.pkg;
            var _local_3:int = _local_2.readInt();
            var _local_4:Date = _local_2.readDate();
            var _local_5:int = _local_2.readInt();
            var _local_6:int = _local_2.readInt();
            this.model.receivedQuestCount = _local_6;
            this.model.currentTaskLevel = _local_3;
            if (ConsortionModelControl.Instance.model.getLevelData(PlayerManager.Instance.Self.consortiaInfo.Level))
            {
                this.model.remainPublishTime = (ConsortionModelControl.Instance.model.getLevelData(PlayerManager.Instance.Self.consortiaInfo.Level).QuestCount - _local_5);
            };
            this.model.lastPublishDate = _local_4;
            if (this.model.consortiaQuestCount >= ServerConfigManager.instance.getConsortiaTaskAcceptMax())
            {
                ConsortionModelControl.Instance.model.canAcceptTask = false;
            }
            else
            {
                ConsortionModelControl.Instance.model.canAcceptTask = true;
            };
            dispatchEvent(new ConsortionEvent(ConsortionEvent.REFLASH_CAMPAIGN_ITEM));
        }

        private function __syncConsortionRich(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:PackageIn = _arg_1.pkg;
            var _local_3:int = _local_2.readInt();
            PlayerManager.Instance.Self.consortiaInfo.Riches = _local_3;
        }

        public function alertTaxFrame():void
        {
            var _local_1:TaxFrame = ComponentFactory.Instance.creatComponentByStylename("taxFrame");
            LayerManager.Instance.addToLayer(_local_1, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
        }

        public function alertManagerFrame():void
        {
            var _local_1:ManagerFrame = ComponentFactory.Instance.creatComponentByStylename("core.ConsortiaAssetManagerFrame");
            LayerManager.Instance.addToLayer(_local_1, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
            this.loadUseConditionList(this.useConditionListComplete, PlayerManager.Instance.Self.ConsortiaID);
        }

        public function alertShopFrame():void
        {
            var _local_1:ConsortionShopFrame = ComponentFactory.Instance.creatComponentByStylename("consortionShopFrame");
            LayerManager.Instance.addToLayer(_local_1, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
            this.loadUseConditionList(this.useConditionListComplete, PlayerManager.Instance.Self.ConsortiaID);
        }

        public function alertTakeInFrame():void
        {
            var _local_1:TakeInMemberFrame = ComponentFactory.Instance.creatComponentByStylename("takeInMemberFrame");
            LayerManager.Instance.addToLayer(_local_1, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
            this.getApplyRecordList(this.applyListComplete, -1, PlayerManager.Instance.Self.ConsortiaID);
        }

        public function alertQuitFrame():void
        {
            var _local_1:ConsortionQuitFrame = ComponentFactory.Instance.creatComponentByStylename("consortionQuitFrame");
            LayerManager.Instance.addToLayer(_local_1, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
        }

        public function initClub():void
        {
            this.alertClubFrame();
        }

        private function alertClubFrame():void
        {
            var _local_1:ClubViewFrame;
            _local_1 = ComponentFactory.Instance.creatComponentByStylename("ClubViewFrame");
            _local_1.show();
        }


    }
}//package consortion

