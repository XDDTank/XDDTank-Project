// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//liveness.LivenessItem

package liveness
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.controls.TextButton;
    import flash.display.MovieClip;
    import ddt.data.quest.QuestInfo;
    import com.pickgliss.ui.text.FilterFrameTextWithTips;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.controls.BaseButton;
    import consortion.consortionTask.ConsortionTaskViewFrame;
    import flash.display.Bitmap;
    import flash.geom.Point;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.utils.PositionUtils;
    import ddt.manager.LanguageMgr;
    import consortion.ConsortionModelControl;
    import ddt.manager.PlayerManager;
    import ddt.manager.ServerConfigManager;
    import consortion.managers.ConsortionMonsterManager;
    import arena.ArenaManager;
    import flash.events.MouseEvent;
    import ddt.manager.SocketManager;
    import ddt.events.CrazyTankSocketEvent;
    import flash.events.Event;
    import ddt.manager.TaskManager;
    import ddt.events.TaskEvent;
    import worldboss.WorldBossManager;
    import ddt.data.quest.QuestItemReward;
    import ddt.data.goods.InventoryItemInfo;
    import ddt.manager.ItemManager;
    import ddt.manager.SoundManager;
    import baglocked.BaglockedManager;
    import ddt.manager.MessageTipManager;
    import worldboss.WorldBossAwardController;
    import ddt.data.UIModuleTypes;
    import ddt.manager.TaskDirectorManager;
    import ddt.events.LivenessEvent;
    import com.pickgliss.ui.AlertManager;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.events.FrameEvent;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.manager.LeavePageManager;
    import road7th.comm.PackageIn;
    import ddt.data.goods.ItemTemplateInfo;
    import ddt.data.EquipType;
    import ddt.manager.DropGoodsManager;
    import com.greensock.TweenLite;

    public class LivenessItem extends Sprite implements Disposeable 
    {

        private var _type:int;
        private var _questId:int;
        private var _joinBtn:TextButton;
        private var _line:MovieClip;
        private var _info:QuestInfo;
        private var _title:FilterFrameTextWithTips;
        private var _progress:FilterFrameText;
        private var _descript:FilterFrameText;
        private var _award:FilterFrameTextWithTips;
        private var _quickDoneBtn:BaseButton;
        private var _taskLiveness:FilterFrameText;
        private var _isMaster:Boolean;
        private var _chooseLevelView:ConsortionTaskViewFrame;
        private var _completeImage:Bitmap;
        private var _consortionTaskList:Array;
        private var _isComplete:Boolean;
        private var _exclamatory:Bitmap;
        private var _itemShine:MovieClip;
        private var _helpBtn:BaseButton;
        private var _helpFrame:LivenessHelpFrame;
        private var _getRewardBtn:TextButton;
        private var _livenessStartPoint:Point;
        private var _pointMovie:MovieClip;
        private var _pointEndMovie:MovieClip;
        private var _expeditionAlert:BaseAlerFrame;

        public function LivenessItem(_arg_1:int, _arg_2:int)
        {
            this._type = _arg_1;
            this._questId = _arg_2;
            this.initView();
            this.initEvent();
            this.init();
        }

        private function initView():void
        {
            this._line = ComponentFactory.Instance.creat("asset.liveness.item.line");
            this._title = ComponentFactory.Instance.creatComponentByStylename("liveness.taskTitleTips");
            this._progress = ComponentFactory.Instance.creatComponentByStylename("liveness.taskProgress");
            this._award = ComponentFactory.Instance.creatComponentByStylename("liveness.taskAwardTips");
            this._taskLiveness = ComponentFactory.Instance.creatComponentByStylename("liveness.taskLiveness");
            this._descript = ComponentFactory.Instance.creatComponentByStylename("liveness.taskDescript");
            this._quickDoneBtn = ComponentFactory.Instance.creatComponentByStylename("liveness.quickDoneBtn");
            this._exclamatory = ComponentFactory.Instance.creatBitmap("asset.liveness.exclamatory");
            this._itemShine = (ComponentFactory.Instance.creat("asset.liveness.itemShine") as MovieClip);
            PositionUtils.setPos(this._itemShine, "liveness.livenessItem.shine.pos");
            this._helpBtn = ComponentFactory.Instance.creatComponentByStylename("liveness.helpBtn");
            this._helpBtn.tipData = LanguageMgr.GetTranslation("store.view.HelpButtonText");
            this._helpFrame = ComponentFactory.Instance.creat("liveness.frame.LivenessHelpFrame");
            this._completeImage = ComponentFactory.Instance.creatBitmap("asset.liveness.completeImage");
            this._getRewardBtn = ComponentFactory.Instance.creatComponentByStylename("liveness.getRewardBtn");
            this._getRewardBtn.text = LanguageMgr.GetTranslation("ddt.livenessFrame.getRewardBtn.txt");
            if (this._type == LivenessModel.CONSORTION_TASK)
            {
                this._isMaster = ConsortionModelControl.Instance.model.isMaster;
                if (ConsortionModelControl.Instance.model.canAcceptTask)
                {
                    this.createMemberBtn();
                }
                else
                {
                    if (((this._isMaster) && (ConsortionModelControl.Instance.model.remainPublishTime > 0)))
                    {
                        this.createMasterBtn();
                    }
                    else
                    {
                        this.createMemberBtn();
                    };
                };
                this._quickDoneBtn.visible = false;
                this.addTitleTips();
            }
            else
            {
                this._joinBtn = ComponentFactory.Instance.creatComponentByStylename("liveness.joinBtn");
                this._joinBtn.text = LanguageMgr.GetTranslation("consortion.ConsortionCampaign.goTransportBtn.text");
                if (this._type == LivenessModel.ARENA)
                {
                    if (PlayerManager.Instance.Self.Grade < ServerConfigManager.instance.getArenaOpenLevel())
                    {
                        this.setBtnEnable(false);
                    };
                };
                if (this._type == LivenessModel.MONSTER_REFLASH)
                {
                    if ((!(ConsortionMonsterManager.Instance.ActiveState)))
                    {
                        this.setBtnEnable(false);
                    };
                };
                if (this._type == LivenessModel.ARENA)
                {
                    if ((!(ArenaManager.instance.open)))
                    {
                        this.setBtnEnable(false);
                    };
                };
            };
            PositionUtils.setPos(this._line, "liveness.livenessItem.line.pos");
            addChild(this._line);
            addChild(this._itemShine);
            addChild(this._title);
            addChild(this._exclamatory);
            addChild(this._progress);
            addChild(this._award);
            addChild(this._taskLiveness);
            addChild(this._descript);
            addChild(this._joinBtn);
            addChild(this._getRewardBtn);
            addChild(this._helpBtn);
            addChild(this._quickDoneBtn);
            addChild(this._completeImage);
        }

        private function initEvent():void
        {
            this._joinBtn.addEventListener(MouseEvent.CLICK, this.__clickItem);
            this._quickDoneBtn.addEventListener(MouseEvent.CLICK, this.__clickOneKey);
            if (this._type == LivenessModel.SINGLE_DUNGEON)
            {
                SocketManager.Instance.addEventListener(CrazyTankSocketEvent.RANDOM_SCENE, this.__enterRandomSingleDungeon);
            };
            this._helpBtn.addEventListener(MouseEvent.CLICK, this.__clickHelp);
            this._helpFrame.addEventListener(Event.COMPLETE, this.__clickItem);
            this._getRewardBtn.addEventListener(MouseEvent.CLICK, this.__clickGetReward);
            TaskManager.instance.addEventListener(TaskEvent.FINISH, this.__onTaskFinished);
        }

        private function removeEvent():void
        {
            this._joinBtn.removeEventListener(MouseEvent.CLICK, this.__clickItem);
            this._quickDoneBtn.removeEventListener(MouseEvent.CLICK, this.__clickOneKey);
            if (this._type == LivenessModel.SINGLE_DUNGEON)
            {
                SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.RANDOM_SCENE, this.__enterRandomSingleDungeon);
            };
            this._helpBtn.removeEventListener(MouseEvent.CLICK, this.__clickHelp);
            this._helpFrame.removeEventListener(Event.COMPLETE, this.__clickItem);
            this._getRewardBtn.removeEventListener(MouseEvent.CLICK, this.__clickGetReward);
            TaskManager.instance.removeEventListener(TaskEvent.FINISH, this.__onTaskFinished);
            if (this._pointEndMovie)
            {
                this._pointEndMovie.removeEventListener(Event.COMPLETE, this.__removePointEndMovie);
            };
            if (this._pointMovie)
            {
                this._pointMovie.removeEventListener(Event.COMPLETE, this.__pointBeginMove);
            };
        }

        private function init():void
        {
            var _local_1:String;
            this._info = TaskManager.instance.getQuestByID(this._questId);
            this._title.text = this._info.Title;
            this._award.text = this._info.Objective;
            this._descript.text = this._info.Detail;
            this.addRewardTips();
            this._quickDoneBtn.tipData = LanguageMgr.GetTranslation("ddt.liveness.quickDone.tip.txt", this._info.OneKeyFinishNeedMoney);
            this._taskLiveness.text = String(this._info.RewardDailyActivity);
            this._exclamatory.visible = false;
            this._itemShine.visible = false;
            this._helpBtn.visible = false;
            this._completeImage.visible = false;
            this._getRewardBtn.visible = false;
            this._exclamatory.x = ((this._title.x + this._title.textWidth) + 7);
            if (this._type != LivenessModel.CONSORTION_TASK)
            {
                _local_1 = "";
                _local_1 = (_local_1 + this._info._conditions[0].description);
                this._title.tipData = _local_1;
                if (this._info.OneKeyFinishNeedMoney > 0)
                {
                    this._quickDoneBtn.visible = true;
                }
                else
                {
                    this._quickDoneBtn.visible = false;
                };
                if (((this._type == LivenessModel.WORLD_BOSS) && (WorldBossManager.Instance.isOpen)))
                {
                    this._itemShine.visible = true;
                };
                if (this._type == LivenessModel.MONSTER_REFLASH)
                {
                    this._helpBtn.visible = true;
                    if (ConsortionMonsterManager.Instance.ActiveState)
                    {
                        this._itemShine.visible = true;
                    };
                };
                if (this._type == LivenessModel.ARENA)
                {
                    this._helpBtn.visible = true;
                    if (ArenaManager.instance.open)
                    {
                        this._itemShine.visible = true;
                    };
                };
                if (this._type == LivenessModel.CONSORTION_CONVOY)
                {
                    this._helpBtn.visible = true;
                };
            }
            else
            {
                this.checkBtnEnable();
            };
            this.reflashTaskProgress();
        }

        private function addTitleTips():void
        {
            var _local_1:String;
            var _local_2:uint;
            this._consortionTaskList = TaskManager.instance.getAvailableQuests(5).list;
            if (this._consortionTaskList.length > 0)
            {
                _local_1 = "";
                _local_2 = 0;
                while (_local_2 < this._consortionTaskList.length)
                {
                    _local_1 = (_local_1 + this._consortionTaskList[_local_2]._conditions[0].description);
                    if (this._consortionTaskList[_local_2]._conditions[0].param2 == 200)
                    {
                        _local_1 = (_local_1 + "(0/1)");
                    }
                    else
                    {
                        _local_1 = (_local_1 + (((("(" + (this._consortionTaskList[_local_2]._conditions[0].param2 - this._consortionTaskList[_local_2].data.progress[0])) + "/") + this._consortionTaskList[_local_2]._conditions[0].param2) + ")"));
                    };
                    if (((this._consortionTaskList.length > 1) && (_local_2 < (this._consortionTaskList.length - 1))))
                    {
                        _local_1 = (_local_1 + "\n");
                    };
                    _local_2++;
                };
                this._title.tipData = _local_1;
            }
            else
            {
                this._title.tipData = null;
            };
        }

        private function addRewardTips():void
        {
            var _local_2:QuestItemReward;
            var _local_3:InventoryItemInfo;
            var _local_1:String = "";
            if (this._type == LivenessModel.CONSORTION_TASK)
            {
                if (this._consortionTaskList.length > 0)
                {
                    _local_1 = (_local_1 + (((LanguageMgr.GetTranslation("consortion.ConsortionCampaign.reward.contribution.text") + " ") + (this._consortionTaskList[0].RewardOffer * this._info._conditions[0].param2)) + "\n"));
                    _local_1 = (_local_1 + (((LanguageMgr.GetTranslation("consortion.ConsortionCampaign.reward.Exp.text") + " ") + (this._consortionTaskList[0].RewardConsortiaGP * this._info._conditions[0].param2)) + "\n"));
                };
            }
            else
            {
                if (this._info.RewardGP > 0)
                {
                    _local_1 = (_local_1 + (((LanguageMgr.GetTranslation("exp") + " ") + this._info.RewardGP) + "\n"));
                };
                if (this._info.RewardGold > 0)
                {
                    _local_1 = (_local_1 + (((LanguageMgr.GetTranslation("tank.hotSpring.gold") + " ") + this._info.RewardGold) + "\n"));
                };
                if (this._info.RewardBindMoney > 0)
                {
                    _local_1 = (_local_1 + (((LanguageMgr.GetTranslation("gift") + " ") + this._info.RewardBindMoney) + "\n"));
                };
                if (this._info.RewardHonor > 0)
                {
                    _local_1 = (_local_1 + (((LanguageMgr.GetTranslation("ddt.quest.Honor") + " ") + this._info.RewardHonor) + "\n"));
                };
                if (this._info.RewardMagicSoul > 0)
                {
                    _local_1 = (_local_1 + (((LanguageMgr.GetTranslation("magicSoul") + " ") + this._info.RewardMagicSoul) + "\n"));
                };
                if (this._info.RewardConsortiaRiches > 0)
                {
                    _local_1 = (_local_1 + (((LanguageMgr.GetTranslation("consortion.ConsortionCampaign.reward.money.text") + " ") + this._info.RewardConsortiaRiches) + "\n"));
                };
                if (((this._info.itemRewards) && (this._info.itemRewards.length > 0)))
                {
                    for each (_local_2 in this._info.itemRewards)
                    {
                        _local_3 = new InventoryItemInfo();
                        _local_3.TemplateID = _local_2.itemID;
                        ItemManager.fill(_local_3);
                        _local_1 = (_local_1 + (((_local_3.Name + " ") + _local_2.count[0]) + "\n"));
                    };
                };
            };
            if (_local_1 != "")
            {
                _local_1 = _local_1.substr(0, (_local_1.length - 1));
                this._award.tipData = LanguageMgr.GetTranslation("ddt.liveness.reward.tips.txt", _local_1);
            }
            else
            {
                this._award.tipData = null;
            };
        }

        public function reflashBtnByTpye(_arg_1:Boolean):void
        {
            if (this._type != LivenessModel.CONSORTION_TASK)
            {
                return;
            };
            removeChild(this._joinBtn);
            this._joinBtn = null;
            if (_arg_1)
            {
                this.createMasterBtn();
            }
            else
            {
                this.createMemberBtn();
                if (this._chooseLevelView)
                {
                    if (this._chooseLevelView.parent)
                    {
                        this._chooseLevelView.dispose();
                    };
                };
                this.addTitleTips();
                this.addRewardTips();
                if (TaskManager.instance.getAvailableQuests(5).list.length > 0)
                {
                    this._exclamatory.visible = true;
                };
            };
            addChild(this._joinBtn);
            this.checkBtnEnable();
            this._joinBtn.addEventListener(MouseEvent.CLICK, this.__clickItem);
        }

        private function createMasterBtn():void
        {
            this._joinBtn = ComponentFactory.Instance.creatComponentByStylename("liveness.publishBtn");
            this._joinBtn.text = LanguageMgr.GetTranslation("consortion.ConsortionCampaign.publishBtn.text");
        }

        private function createMemberBtn():void
        {
            this._joinBtn = ComponentFactory.Instance.creatComponentByStylename("liveness.getTaskBtn");
            this._joinBtn.text = LanguageMgr.GetTranslation("consortion.ConsortionCampaign.getMissionBtn.text");
        }

        private function __clickItem(_arg_1:Event):void
        {
            SoundManager.instance.play("008");
            switch (this._type)
            {
                case LivenessModel.CONSORTION_TASK:
                    if (ConsortionModelControl.Instance.model.canAcceptTask)
                    {
                        SocketManager.Instance.out.sendRequestConsortionQuest(ConsortionModelControl.Instance.model.currentTaskLevel);
                    }
                    else
                    {
                        if (this._isMaster)
                        {
                            if (PlayerManager.Instance.Self.bagPwdState)
                            {
                                if ((!(PlayerManager.Instance.Self.bagLocked)))
                                {
                                    this.showQuestChooseFrame();
                                }
                                else
                                {
                                    BaglockedManager.Instance.show();
                                    return;
                                };
                            }
                            else
                            {
                                this.showQuestChooseFrame();
                            };
                        };
                    };
                    return;
                case LivenessModel.WORLD_BOSS:
                    if (WorldBossManager.Instance.isOpen)
                    {
                        if (PlayerManager.Instance.checkExpedition())
                        {
                            this.showExpeditionAlert();
                        }
                        else
                        {
                            SocketManager.Instance.out.enterWorldBossRoom();
                        };
                    }
                    else
                    {
                        if (PlayerManager.Instance.Self.Grade < ServerConfigManager.instance.getWorldBossMinEnterLevel())
                        {
                            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("worldboss.minenterlevel", ServerConfigManager.instance.getWorldBossMinEnterLevel()));
                        }
                        else
                        {
                            WorldBossManager.Instance.showWorldBossAward(WorldBossAwardController.Instance.setup, UIModuleTypes.WORLDBOSS_MAP);
                        };
                    };
                    return;
                case LivenessModel.CONSORTION_CONVOY:
                    SocketManager.Instance.out.SendenterConsortionTransport();
                    return;
                case LivenessModel.MONSTER_REFLASH:
                    if (PlayerManager.Instance.checkExpedition())
                    {
                        this.showExpeditionAlert();
                    }
                    else
                    {
                        SocketManager.Instance.out.SendenterConsortion(true);
                    };
                    return;
                case LivenessModel.NORMAL:
                case LivenessModel.RUNE:
                    TaskDirectorManager.instance.beginGuild(this._info);
                    LivenessAwardManager.Instance.dispatchEvent(new LivenessEvent(LivenessEvent.TASK_DIRECT));
                    return;
                case LivenessModel.SINGLE_DUNGEON:
                    SocketManager.Instance.out.sendEnterRandomScene(this._info.id);
                    return;
                case LivenessModel.RANDOM_PVE:
                    if (PlayerManager.Instance.checkExpedition())
                    {
                        this.showExpeditionAlert();
                    }
                    else
                    {
                        SocketManager.Instance.out.sendEnterRandomPve();
                    };
                    return;
                case LivenessModel.ARENA:
                    if (PlayerManager.Instance.checkExpedition())
                    {
                        this.showExpeditionAlert();
                    }
                    else
                    {
                        ArenaManager.instance.enter();
                    };
                    return;
            };
        }

        private function showExpeditionAlert():void
        {
            this._expeditionAlert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"), LanguageMgr.GetTranslation("ddt.consortion.ConsortionTransport.stopExpedition"), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), false, true, false, LayerManager.BLCAK_BLOCKGOUND);
            this._expeditionAlert.moveEnable = false;
            this._expeditionAlert.addEventListener(FrameEvent.RESPONSE, this.__expeditionConfirmResponse);
        }

        private function checkEnterByTpye():void
        {
            switch (this._type)
            {
                case LivenessModel.WORLD_BOSS:
                    if (WorldBossManager.Instance.isOpen)
                    {
                        SocketManager.Instance.out.enterWorldBossRoom();
                    };
                    return;
                case LivenessModel.MONSTER_REFLASH:
                    if (ConsortionMonsterManager.Instance.ActiveState)
                    {
                        SocketManager.Instance.out.SendenterConsortion(true);
                    };
                    return;
                case LivenessModel.ARENA:
                    if (ArenaManager.instance.open)
                    {
                        ArenaManager.instance.enter();
                    };
                    return;
                case LivenessModel.RANDOM_PVE:
                    SocketManager.Instance.out.sendEnterRandomPve();
                    return;
            };
        }

        private function __expeditionConfirmResponse(_arg_1:FrameEvent):void
        {
            var _local_2:BaseAlerFrame = (_arg_1.currentTarget as BaseAlerFrame);
            _local_2.removeEventListener(FrameEvent.RESPONSE, this.__expeditionConfirmResponse);
            if (((_arg_1.responseCode == FrameEvent.ENTER_CLICK) || (_arg_1.responseCode == FrameEvent.SUBMIT_CLICK)))
            {
                SocketManager.Instance.out.sendExpeditionCancle();
                this.checkEnterByTpye();
            };
            ObjectUtils.disposeObject(_local_2);
        }

        private function __clickOneKey(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            if (PlayerManager.Instance.Self.bagLocked)
            {
                BaglockedManager.Instance.show();
                return;
            };
            var _local_2:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"), LanguageMgr.GetTranslation("ddt.liveness.oneKeyFinish.tips.txt", this._info.OneKeyFinishNeedMoney), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), false, true, false, LayerManager.BLCAK_BLOCKGOUND);
            _local_2.moveEnable = false;
            _local_2.addEventListener(FrameEvent.RESPONSE, this.__confirmResponse);
        }

        private function __confirmResponse(_arg_1:FrameEvent):void
        {
            var _local_2:BaseAlerFrame = (_arg_1.currentTarget as BaseAlerFrame);
            _local_2.removeEventListener(FrameEvent.RESPONSE, this.__confirmResponse);
            if (((_arg_1.responseCode == FrameEvent.ENTER_CLICK) || (_arg_1.responseCode == FrameEvent.SUBMIT_CLICK)))
            {
                if (PlayerManager.Instance.Self.totalMoney < this._info.OneKeyFinishNeedMoney)
                {
                    ObjectUtils.disposeObject(_local_2);
                    LeavePageManager.showFillFrame();
                    return;
                };
                SocketManager.Instance.out.SendGetDailyQuestOneKey(this._info.id);
            };
            ObjectUtils.disposeObject(_local_2);
        }

        public function setBtnEnable(_arg_1:Boolean=true):void
        {
            this._joinBtn.enable = _arg_1;
            if (_arg_1)
            {
                this._joinBtn.filters = null;
            }
            else
            {
                this._joinBtn.filters = ComponentFactory.Instance.creatFilters("grayFilter");
            };
        }

        private function checkBtnEnable():void
        {
            if ((!(ConsortionModelControl.Instance.model.canAcceptTask)))
            {
                if ((((((!(this._isMaster)) && (ConsortionModelControl.Instance.model.currentTaskLevel == 0)) || ((ConsortionModelControl.Instance.model.consortiaQuestCount >= ServerConfigManager.instance.getConsortiaTaskAcceptMax()) && (ConsortionModelControl.Instance.model.remainPublishTime == 0))) || (((ConsortionModelControl.Instance.model.remainPublishTime == 0) && (this._isMaster)) && (!(ConsortionModelControl.Instance.model.currentTaskLevel == 0)))) || (ConsortionModelControl.Instance.model.receivedQuestCount >= (ConsortionModelControl.Instance.model.getLevelData(PlayerManager.Instance.Self.consortiaInfo.Level).Count * 5))))
                {
                    this.setBtnEnable(false);
                    if (((TaskManager.instance.getAvailableQuests(5).list.length == 0) && (!(ConsortionModelControl.Instance.model.currentTaskLevel == 0))))
                    {
                        this._completeImage.visible = true;
                    }
                    else
                    {
                        this._completeImage.visible = false;
                    };
                };
            };
        }

        public function reflashTaskProgress():void
        {
            var _local_1:int;
            var _local_2:int;
            this._consortionTaskList = TaskManager.instance.getAvailableQuests(5).list;
            _local_1 = this._info._conditions[0].param2;
            if (this._type == LivenessModel.CONSORTION_TASK)
            {
                if (ConsortionModelControl.Instance.model.consortiaQuestCount == 0)
                {
                    _local_2 = 0;
                    this._progress.text = ("0/" + this._info._conditions[0].param2);
                }
                else
                {
                    if (this._consortionTaskList.length == 0)
                    {
                        _local_2 = this._info._conditions[0].param2;
                        this._exclamatory.visible = false;
                        this._progress.text = ((this._info._conditions[0].param2 + "/") + this._info._conditions[0].param2);
                    }
                    else
                    {
                        _local_2 = (this._info._conditions[0].param2 - this._consortionTaskList.length);
                        this._exclamatory.visible = true;
                        this._progress.text = (((this._info._conditions[0].param2 - this._consortionTaskList.length) + "/") + this._info._conditions[0].param2);
                    };
                };
            }
            else
            {
                if (this._info.data)
                {
                    if (this._info.data.progress[0] < 0)
                    {
                        _local_2 = _local_1;
                    }
                    else
                    {
                        _local_2 = (_local_1 - this._info.data.progress[0]);
                        if (this._info.data.isAchieved)
                        {
                            _local_2 = _local_1;
                        };
                    };
                }
                else
                {
                    _local_2 = _local_1;
                };
                this._progress.text = ((_local_2 + "/") + _local_1);
            };
            if (_local_2 == _local_1)
            {
                this._isComplete = true;
                this._exclamatory.visible = false;
                if (this._info.OneKeyFinishNeedMoney > 0)
                {
                    this._quickDoneBtn.visible = false;
                };
                if (((!(this._info.data)) || (this._info.isAchieved)))
                {
                    this._completeImage.visible = true;
                    this._joinBtn.visible = true;
                    this._getRewardBtn.visible = false;
                    if (((((!(this._type == LivenessModel.ARENA)) && (!(this._type == LivenessModel.MONSTER_REFLASH))) && (!(this._type == LivenessModel.CONSORTION_CONVOY))) && (!(this._type == LivenessModel.WORLD_BOSS))))
                    {
                        this.setBtnEnable(false);
                    };
                }
                else
                {
                    this._joinBtn.visible = false;
                    this._getRewardBtn.visible = true;
                };
            }
            else
            {
                if (this._type == LivenessModel.SINGLE_DUNGEON)
                {
                    this._exclamatory.visible = true;
                };
                this._isComplete = false;
            };
        }

        private function showQuestChooseFrame():void
        {
            this._chooseLevelView = ComponentFactory.Instance.creatComponentByStylename("consortion.ConsortionTaskViewFrame");
            this._chooseLevelView.show();
        }

        private function __enterRandomSingleDungeon(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:PackageIn = (_arg_1.pkg as PackageIn);
            var _local_3:int = _local_2.readInt();
            LivenessAwardManager.Instance.currentSingleDungeonId = _local_3;
            TaskDirectorManager.instance.beginGuild(this._info);
        }

        private function __clickHelp(_arg_1:MouseEvent):void
        {
            var _local_2:String;
            SoundManager.instance.play("008");
            var _local_3:String = "liveness.livenessItem.helpText.pos";
            if (this._type == LivenessModel.MONSTER_REFLASH)
            {
                _local_2 = "asset.liveness.monsterHelp";
            };
            if (this._type == LivenessModel.ARENA)
            {
                _local_2 = "asset.liveness.arenaHelp";
            };
            if (this._type == LivenessModel.CONSORTION_CONVOY)
            {
                _local_2 = "asset.liveness.transportHelp";
            };
            this._helpFrame.setView(ComponentFactory.Instance.creat(_local_2), _local_3);
            this._helpFrame.btnEnable = this._joinBtn.enable;
            this._helpFrame.show();
        }

        private function __clickGetReward(_arg_1:MouseEvent):void
        {
            TaskManager.instance.sendQuestFinish(this._info.QuestID);
        }

        private function __onTaskFinished(_arg_1:TaskEvent):void
        {
            var _local_2:Array;
            var _local_3:QuestItemReward;
            var _local_4:ItemTemplateInfo;
            var _local_5:ItemTemplateInfo;
            if (((_arg_1.type == "finish") && (_arg_1.info.QuestID == this._info.QuestID)))
            {
                this.reflashTaskProgress();
                _local_2 = new Array();
                for each (_local_3 in _arg_1.info.itemRewards)
                {
                    if (_local_3)
                    {
                        _local_4 = ItemManager.Instance.getTemplateById(_local_3.itemID);
                        _local_2.push(_local_4);
                    };
                };
                if (_arg_1.info.RewardGold > 0)
                {
                    _local_5 = ItemManager.Instance.getTemplateById(EquipType.GOLD);
                    _local_2.push(_local_5);
                };
                DropGoodsManager.play(_local_2, this.localToGlobal(new Point((this._joinBtn.x - 30), this._joinBtn.y)));
                this._pointMovie = ComponentFactory.Instance.creat("asset.liveness.pointFly");
                this._pointMovie.addEventListener(Event.COMPLETE, this.__pointBeginMove);
                this._livenessStartPoint = this.localToGlobal(new Point((this._taskLiveness.x + 5), (this._taskLiveness.y + 5)));
                this._pointMovie.x = this._livenessStartPoint.x;
                this._pointMovie.y = this._livenessStartPoint.y;
                LayerManager.Instance.addToLayer(this._pointMovie, LayerManager.GAME_TOP_LAYER);
            };
        }

        private function __pointBeginMove(_arg_1:Event):void
        {
            this._pointMovie.removeEventListener(Event.COMPLETE, this.__pointBeginMove);
            var _local_2:Point = (ComponentFactory.Instance.creatCustomObject("liveness.livenessItem.livenessEndPoint.pos") as Point);
            var _local_3:Number = (Math.atan(((this._livenessStartPoint.x - _local_2.x) / (this._livenessStartPoint.y - _local_2.y))) * (-180 / Math.PI));
            this._pointMovie.alpha = 0;
            this._pointMovie.rotation = _local_3;
            TweenLite.to(this._pointMovie, 0.5, {
                "x":_local_2.x,
                "y":_local_2.y,
                "alpha":1,
                "onComplete":this.pointMoveEnd
            });
        }

        private function pointMoveEnd():void
        {
            this._pointMovie.parent.removeChild(this._pointMovie);
            this._pointMovie = null;
            this._pointEndMovie = (ComponentFactory.Instance.creat("asset.liveness.pointReachShine") as MovieClip);
            PositionUtils.setPos(this._pointEndMovie, "liveness.livenessItem.pointMovieEndPoint.pos");
            this._pointEndMovie.addEventListener(Event.COMPLETE, this.__removePointEndMovie);
            LayerManager.Instance.addToLayer(this._pointEndMovie, LayerManager.GAME_TOP_LAYER);
        }

        private function __removePointEndMovie(_arg_1:Event):void
        {
            this._pointEndMovie.removeEventListener(Event.COMPLETE, this.__removePointEndMovie);
            this._pointEndMovie.parent.removeChild(this._pointEndMovie);
            this._pointEndMovie = null;
            LivenessAwardManager.Instance.dispatchEvent(new LivenessEvent(LivenessEvent.REFLASH_LIVENESS, this._info.RewardDailyActivity));
        }

        public function dispose():void
        {
            this.removeEvent();
            TweenLite.killTweensOf(this._pointMovie);
            ObjectUtils.disposeObject(this._joinBtn);
            this._joinBtn = null;
            ObjectUtils.disposeObject(this._line);
            this._line = null;
            this._info = null;
            ObjectUtils.disposeObject(this._title);
            this._title = null;
            ObjectUtils.disposeObject(this._progress);
            this._progress = null;
            ObjectUtils.disposeObject(this._descript);
            this._descript = null;
            ObjectUtils.disposeObject(this._award);
            this._award = null;
            ObjectUtils.disposeObject(this._quickDoneBtn);
            this._quickDoneBtn = null;
            ObjectUtils.disposeObject(this._taskLiveness);
            this._taskLiveness = null;
            ObjectUtils.disposeObject(this._chooseLevelView);
            this._chooseLevelView = null;
            ObjectUtils.disposeObject(this._completeImage);
            this._completeImage = null;
            ObjectUtils.disposeObject(this._consortionTaskList);
            this._consortionTaskList = null;
            ObjectUtils.disposeObject(this._helpFrame);
            this._helpFrame = null;
            ObjectUtils.disposeObject(this._pointMovie);
            this._pointMovie = null;
            ObjectUtils.disposeObject(this._pointEndMovie);
            this._pointEndMovie = null;
            this._livenessStartPoint = null;
            if (this._expeditionAlert)
            {
                this._expeditionAlert.removeEventListener(FrameEvent.RESPONSE, this.__expeditionConfirmResponse);
                ObjectUtils.disposeObject(this._expeditionAlert);
                this._expeditionAlert = null;
            };
        }

        public function get type():int
        {
            return (this._type);
        }

        public function get info():QuestInfo
        {
            return (this._info);
        }

        public function get isComplete():Boolean
        {
            return (this._isComplete);
        }

        override public function get height():Number
        {
            return (48);
        }

        override public function get width():Number
        {
            return (566);
        }


    }
}//package liveness

