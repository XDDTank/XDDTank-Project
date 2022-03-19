// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//quest.TaskMainFrame

package quest
{
    import com.pickgliss.ui.controls.Frame;
    import com.pickgliss.ui.controls.BaseButton;
    import com.pickgliss.effect.IEffect;
    import com.pickgliss.ui.controls.TextButton;
    import com.pickgliss.ui.controls.ScrollPanel;
    import com.pickgliss.ui.controls.container.VBox;
    import flash.display.Bitmap;
    import com.pickgliss.ui.image.MutipleImage;
    import com.pickgliss.ui.image.Scale9CornerImage;
    import flash.display.MovieClip;
    import flash.utils.Timer;
    import ddt.command.QuickBuyFrame;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.utils.PositionUtils;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.effect.AlphaShinerAnimation;
    import com.pickgliss.effect.EffectColorType;
    import com.pickgliss.effect.EffectManager;
    import com.pickgliss.effect.EffectTypes;
    import flash.events.Event;
    import ddt.manager.TaskManager;
    import ddt.events.TaskEvent;
    import com.pickgliss.events.FrameEvent;
    import flash.events.MouseEvent;
    import ddt.manager.SoundManager;
    import ddt.manager.TaskDirectorManager;
    import ddt.data.quest.QuestItemReward;
    import ddt.data.goods.ItemTemplateInfo;
    import ddt.manager.ItemManager;
    import ddt.data.EquipType;
    import ddt.manager.DropGoodsManager;
    import SingleDungeon.event.SingleDungeonEvent;
    import trainer.view.NewHandContainer;
    import trainer.data.ArrowType;
    import ddt.data.quest.QuestInfo;
    import ddt.view.MainToolBar;
    import com.pickgliss.ui.LayerManager;
    import ddt.manager.SavePointManager;
    import ddt.loader.StartupResourceLoader;
    import ddt.data.goods.InventoryItemInfo;
    import ddt.manager.MessageTipManager;
    import ddt.manager.PlayerManager;
    import tryonSystem.TryonSystemController;
    import ddt.manager.SocketManager;
    import ddt.manager.StateManager;
    import ddt.states.StateType;
    import flash.utils.setTimeout;
    import ddt.manager.GameInSocketOut;
    import roomList.pvpRoomList.RoomListBGView;
    import flash.net.navigateToURL;
    import flash.net.URLRequest;
    import ddt.manager.PathManager;
    import baglocked.BaglockedManager;
    import ddt.manager.ShopManager;
    import ddt.data.goods.ShopItemInfo;
    import ddt.manager.LeavePageManager;
    import com.pickgliss.utils.ObjectUtils;

    public class TaskMainFrame extends Frame 
    {

        public static const NORMAL:int = 1;
        public static const GUIDE:int = 2;
        public static const REWARD_UDERLINE:int = 417;
        private static const SPINEL:int = 11555;
        private static const TYPE_NUMBER:int = 6;

        private const CATEVIEW_X:int = 0;
        private const CATEVIEW_Y:int = 0;
        private const CATEVIEW_H:int = 50;

        private var cateViewArr:Array;
        private var infoView:QuestInfoPanelView;
        private var _questBtn:BaseButton;
        private var _guildBtn:BaseButton;
        private var _goDungeonBtnShine:IEffect;
        private var _downClientShine:IEffect;
        private var _questBtnShine:IEffect;
        private var _guildBtnShine:IEffect;
        private var _buySpinelBtn:TextButton;
        private var _opened:Boolean = false;
        private var _currentCateView:QuestCateView;
        public var currentNewCateView:QuestCateView;
        private var leftPanel:ScrollPanel;
        private var leftPanelContent:VBox;
        private var _titleBmp:Bitmap;
        private var _rightBGStyleNormal:MutipleImage;
        private var _rightBottomBg:Scale9CornerImage;
        private var _goDungeonBtn:BaseButton;
        private var _downloadClientBtn:TextButton;
        private var _gotoGameBtn:BaseButton;
        private var _mcTaskTarget:MovieClip;
        private var _showCloseArrowTimer:Timer;
        private var _style:int;
        private var _showGuideOnce:Boolean;
        private var _quick:QuickBuyFrame;

        public function TaskMainFrame()
        {
            this.initView();
            this.addEvent();
        }

        override public function get width():Number
        {
            return (_container.width);
        }

        override public function get height():Number
        {
            return (_container.height);
        }

        private function initView():void
        {
            this._titleBmp = ComponentFactory.Instance.creatBitmap("asset.quest.title");
            addToContent(this._titleBmp);
            this.initStyleNormalBG();
            this.initStyleGuideBG();
            this.leftPanel = ComponentFactory.Instance.creatComponentByStylename("core.quest.questCateList");
            addToContent(this.leftPanel);
            this.leftPanelContent = new VBox();
            this.leftPanelContent.spacing = 0;
            this.leftPanel.setView(this.leftPanelContent);
            this.addQuestList();
            this.leftPanel.invalidateViewport();
            this.infoView = new QuestInfoPanelView();
            PositionUtils.setPos(this.infoView, "quest.infoPanelPos");
            addToContent(this.infoView);
            this._questBtn = ComponentFactory.Instance.creat("quest.getAwardBtn");
            addToContent(this._questBtn);
            this._guildBtn = ComponentFactory.Instance.creat("quest.getGuildBtn");
            addToContent(this._guildBtn);
            this._guildBtn.visible = false;
            this._goDungeonBtn = ComponentFactory.Instance.creatComponentByStylename("core.quest.GoDungeonBtn");
            addToContent(this._goDungeonBtn);
            this._goDungeonBtn.visible = false;
            this._gotoGameBtn = ComponentFactory.Instance.creatComponentByStylename("core.quest.goGameBtn");
            addToContent(this._gotoGameBtn);
            this._gotoGameBtn.visible = false;
            this._downloadClientBtn = ComponentFactory.Instance.creatComponentByStylename("core.quest.DownloadClientBtn");
            this._downloadClientBtn.text = LanguageMgr.GetTranslation("tank.manager.TaskManager.DownloadClient");
            addToContent(this._downloadClientBtn);
            this._downloadClientBtn.visible = false;
            this._buySpinelBtn = ComponentFactory.Instance.creatComponentByStylename("core.quest.buySpinelBtn");
            this._buySpinelBtn.text = LanguageMgr.GetTranslation("tank.manager.TaskManager.buySpinel");
            addToContent(this._buySpinelBtn);
            var _local_1:Object = new Object();
            _local_1[AlphaShinerAnimation.COLOR] = EffectColorType.GOLD;
            this._goDungeonBtnShine = EffectManager.Instance.creatEffect(EffectTypes.ALPHA_SHINER_ANIMATION, this._goDungeonBtn, _local_1);
            this._goDungeonBtnShine.stop();
            this._downClientShine = EffectManager.Instance.creatEffect(EffectTypes.ALPHA_SHINER_ANIMATION, this._downloadClientBtn, _local_1);
            this._downClientShine.play();
            this._questBtnShine = EffectManager.Instance.creatEffect(EffectTypes.ALPHA_SHINER_ANIMATION, this._questBtn, _local_1);
            this._questBtnShine.stop();
            this._guildBtnShine = EffectManager.Instance.creatEffect(EffectTypes.ALPHA_SHINER_ANIMATION, this._guildBtn, _local_1);
            this._guildBtnShine.stop();
            this._buySpinelBtn.visible = false;
            this._questBtn.enable = false;
            this.showStyle(NORMAL);
        }

        private function initStyleNormalBG():void
        {
            this._rightBGStyleNormal = ComponentFactory.Instance.creatComponentByStylename("quest.background.mapBg");
            PositionUtils.setPos(this._rightBGStyleNormal, "quest.rightBgpos");
            this._rightBottomBg = ComponentFactory.Instance.creatComponentByStylename("quest.rightBottomBgImg");
            addToContent(this._rightBGStyleNormal);
            addToContent(this._rightBottomBg);
        }

        private function initStyleGuideBG():void
        {
        }

        private function switchBG(_arg_1:int):void
        {
        }

        private function addQuestList():void
        {
            var _local_2:QuestCateView;
            if (this.cateViewArr)
            {
                return;
            };
            this.cateViewArr = new Array();
            var _local_1:int;
            while (_local_1 < TYPE_NUMBER)
            {
                _local_2 = new QuestCateView(_local_1);
                _local_2.collapse();
                _local_2.x = this.CATEVIEW_X;
                _local_2.y = (this.CATEVIEW_Y + (this.CATEVIEW_H * _local_1));
                _local_2.addEventListener(QuestCateView.TITLECLICKED, this.__onTitleClicked);
                _local_2.addEventListener(Event.CHANGE, this.__onCateViewChange);
                _local_2.addEventListener(QuestCateView.ENABLE_CHANGE, this.__onEnbleChange);
                this.cateViewArr.push(_local_2);
                this.leftPanelContent.addChild(_local_2);
                _local_1++;
            };
            this.__onEnbleChange(null);
        }

        private function __onEnbleChange(_arg_1:Event):void
        {
            var _local_4:QuestCateView;
            var _local_2:int;
            var _local_3:int;
            while (_local_3 < (TYPE_NUMBER - 1))
            {
                _local_4 = this.cateViewArr[_local_3];
                if (_local_4.visible)
                {
                    _local_4.y = (this.CATEVIEW_Y + (this.CATEVIEW_H * _local_2));
                    _local_2++;
                };
                _local_3++;
            };
        }

        private function addEvent():void
        {
            TaskManager.instance.addEventListener(TaskEvent.CHANGED, this.__onDataChanged);
            TaskManager.instance.addEventListener(TaskEvent.FINISH, this.__onTaskFinished);
            addEventListener(FrameEvent.RESPONSE, this.__frameEventHandler);
            this._questBtn.addEventListener(MouseEvent.CLICK, this.__onQuestBtnClicked);
            this._guildBtn.addEventListener(MouseEvent.CLICK, this.__onGuildBtnClicked);
            this._goDungeonBtn.addEventListener(MouseEvent.CLICK, this.__onGoDungeonClicked);
            this._downloadClientBtn.addEventListener(MouseEvent.CLICK, this.__downloadClient);
            this._buySpinelBtn.addEventListener(MouseEvent.CLICK, this.__buySpinelClick);
            this._gotoGameBtn.addEventListener(MouseEvent.CLICK, this.__gotoGame);
        }

        protected function __onGuildBtnClicked(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            TaskDirectorManager.instance.beginGuild(this.infoView.info);
        }

        protected function __onTaskFinished(_arg_1:TaskEvent):void
        {
            var _local_2:Array;
            var _local_3:QuestItemReward;
            var _local_4:ItemTemplateInfo;
            var _local_5:ItemTemplateInfo;
            if (_arg_1.type == "finish")
            {
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
                DropGoodsManager.play(_local_2);
            };
        }

        private function removeEvent():void
        {
            TaskManager.instance.removeEventListener(TaskEvent.CHANGED, this.__onDataChanged);
            TaskManager.instance.removeEventListener(TaskEvent.FINISH, this.__onTaskFinished);
            removeEventListener(FrameEvent.RESPONSE, this.__frameEventHandler);
            this._questBtn.removeEventListener(MouseEvent.CLICK, this.__onQuestBtnClicked);
            this._guildBtn.removeEventListener(MouseEvent.CLICK, this.__onGuildBtnClicked);
            this._goDungeonBtn.removeEventListener(MouseEvent.CLICK, this.__onGoDungeonClicked);
            this._downloadClientBtn.removeEventListener(MouseEvent.CLICK, this.__downloadClient);
            this._buySpinelBtn.removeEventListener(MouseEvent.CLICK, this.__buySpinelClick);
            this._gotoGameBtn.removeEventListener(MouseEvent.CLICK, this.__gotoGame);
        }

        private function __onDataChanged(_arg_1:TaskEvent):void
        {
            var _local_2:uint;
            if (((!(this._currentCateView)) || (!(this.currentNewCateView == null))))
            {
                return;
            };
            if (_arg_1.info.Type == 0)
            {
                if ((this.cateViewArr[0] as QuestCateView).active())
                {
                    return;
                };
            };
            if (this._currentCateView.active())
            {
                return;
            };
            _local_2 = 0;
            while ((!((this.cateViewArr[_local_2] as QuestCateView).active())))
            {
                _local_2++;
                if (_local_2 == 6)
                {
                    return;
                };
            };
        }

        private function __frameEventHandler(_arg_1:FrameEvent):void
        {
            switch (_arg_1.responseCode)
            {
                case FrameEvent.ESC_CLICK:
                case FrameEvent.CLOSE_CLICK:
                    SoundManager.instance.play("008");
                    TaskManager.instance.switchVisible();
                    break;
            };
            SingleDungeonEvent.dispatcher.dispatchEvent(new SingleDungeonEvent(SingleDungeonEvent.FRAME_EXIT, "reflash"));
        }

        public function jumpToQuest(_arg_1:QuestInfo):void
        {
            if (_arg_1.MapID > 0)
            {
                this.showOtherBtn(_arg_1);
            }
            else
            {
                this._goDungeonBtn.visible = false;
                this._goDungeonBtnShine.stop();
                this._downloadClientBtn.visible = false;
                this._questBtn.visible = true;
                this._guildBtn.visible = false;
                this._gotoGameBtn.visible = false;
                this._buySpinelBtn.visible = this.existRewardId(_arg_1, SPINEL);
                this.showStyle(NORMAL);
            };
            this.infoView.info = _arg_1;
            var _local_2:Boolean = ((_arg_1.isCompleted) || ((_arg_1.data) && (_arg_1.data.isCompleted)));
            this.showQuestOverBtn(_local_2);
            if (_arg_1.QuestID < 200)
            {
                if (_arg_1.isCompleted)
                {
                    NewHandContainer.Instance.showArrow(ArrowType.CLICK_BEAT, 0, "trainer.clickBeatArrowPos", "asset.trainer.txtGetReward", "trainer.clickBeatTipPos", this);
                };
            };
            if ((!(_arg_1.isCompleted)))
            {
                NewHandContainer.Instance.clearArrowByID(ArrowType.CLICK_BEAT);
            };
        }

        public function showQuestTask(_arg_1:QuestInfo, _arg_2:int):void
        {
            var _local_3:QuestCateView;
            for each (_local_3 in this.cateViewArr)
            {
                if (_local_3.questType == _arg_2)
                {
                    _local_3.active();
                }
                else
                {
                    _local_3.collapse();
                };
            };
            this.jumpToQuest(_arg_1);
        }

        private function showQuestOverBtn(_arg_1:Boolean):void
        {
            if (_arg_1)
            {
                this._questBtn.enable = true;
                this._questBtn.visible = true;
                this._questBtnShine.play();
                if (this._guildBtn)
                {
                    this._guildBtn.visible = false;
                    this._guildBtnShine.stop();
                };
                this._goDungeonBtn.visible = false;
                this._gotoGameBtn.visible = false;
            }
            else
            {
                if (this.infoView.info.GuideType > 0)
                {
                    this._questBtn.visible = false;
                    this._questBtnShine.stop();
                    this._guildBtn.visible = true;
                    this._guildBtnShine.play();
                }
                else
                {
                    this._questBtn.visible = true;
                    this._questBtn.enable = false;
                    this._questBtnShine.stop();
                    this._guildBtn.visible = false;
                    this._guildBtnShine.stop();
                };
            };
        }

        private function showOtherBtn(_arg_1:QuestInfo):void
        {
            if (_arg_1.MapID > 0)
            {
                if (_arg_1.MapID == 2)
                {
                    this._goDungeonBtn.visible = false;
                    this._downloadClientBtn.visible = false;
                    this._questBtn.visible = false;
                    this._guildBtn.visible = false;
                    this._buySpinelBtn.visible = false;
                    this._gotoGameBtn.visible = false;
                }
                else
                {
                    if (_arg_1.MapID == 3)
                    {
                        this._downloadClientBtn.visible = true;
                        this._goDungeonBtn.visible = false;
                        this._buySpinelBtn.visible = false;
                        this._gotoGameBtn.visible = false;
                    }
                    else
                    {
                        if (_arg_1.MapID == 4)
                        {
                            this._downloadClientBtn.visible = false;
                            this._goDungeonBtn.visible = false;
                            this._buySpinelBtn.visible = false;
                            this._gotoGameBtn.visible = true;
                        }
                        else
                        {
                            if (((_arg_1.MapID > 9) && (_arg_1.MapID < 30)))
                            {
                                this._downloadClientBtn.visible = false;
                                this._goDungeonBtn.visible = false;
                                this._buySpinelBtn.visible = false;
                                this._gotoGameBtn.visible = false;
                            }
                            else
                            {
                                this.showStyle(GUIDE);
                                this._goDungeonBtn.visible = true;
                                this._goDungeonBtn.enable = (!(_arg_1.isCompleted));
                                if (this._goDungeonBtn.enable)
                                {
                                    this._goDungeonBtnShine.play();
                                }
                                else
                                {
                                    this._goDungeonBtnShine.stop();
                                };
                                this._downloadClientBtn.visible = false;
                                this._questBtn.visible = false;
                                this._guildBtn.visible = false;
                                this._buySpinelBtn.visible = false;
                                this._gotoGameBtn.visible = false;
                            };
                        };
                    };
                };
            }
            else
            {
                this._downloadClientBtn.visible = false;
                this._goDungeonBtn.visible = false;
                this._gotoGameBtn.visible = false;
                this._buySpinelBtn.visible = this.existRewardId(_arg_1, SPINEL);
            };
        }

        private function existRewardId(_arg_1:QuestInfo, _arg_2:int):Boolean
        {
            var _local_3:QuestItemReward;
            for each (_local_3 in _arg_1.itemRewards)
            {
                if (_local_3.itemID == _arg_2)
                {
                    return (true);
                };
            };
            return (false);
        }

        private function showStyle(_arg_1:int):void
        {
            if (this._style == _arg_1)
            {
                return;
            };
            this._style = _arg_1;
            var _local_2:int;
            while (_local_2 < this.cateViewArr.length)
            {
                (this.cateViewArr[_local_2] as QuestCateView).taskStyle = _arg_1;
                _local_2++;
            };
            this.switchBG(_arg_1);
        }

        private function __onCateViewChange(_arg_1:Event):void
        {
            var _local_4:QuestCateView;
            var _local_2:int = 42;
            var _local_3:int;
            while (_local_3 < this.cateViewArr.length)
            {
                _local_4 = (this.cateViewArr[_local_3] as QuestCateView);
                if (_local_4.visible)
                {
                    _local_4.y = _local_2;
                    _local_2 = (_local_2 + (_local_4.contentHeight + 7));
                };
                _local_3++;
            };
        }

        private function __onTitleClicked(_arg_1:Event):void
        {
            var _local_4:QuestCateView;
            if (((!(parent)) || (!(this.currentNewCateView == null))))
            {
                return;
            };
            if (this._currentCateView != (_arg_1.target as QuestCateView))
            {
            };
            this._currentCateView = (_arg_1.target as QuestCateView);
            var _local_2:int = this.CATEVIEW_Y;
            var _local_3:int;
            while (_local_3 < this.cateViewArr.length)
            {
                _local_4 = (this.cateViewArr[_local_3] as QuestCateView);
                if (_local_4 != this._currentCateView)
                {
                    _local_4.collapse();
                };
                if (_local_4.visible)
                {
                    _local_4.y = _local_2;
                    _local_2 = (_local_2 + (_local_4.contentHeight + 7));
                };
                _local_3++;
            };
        }

        public function switchVisible():void
        {
            if (parent)
            {
                this.dispose();
            }
            else
            {
                this._show();
            };
        }

        private function _show():void
        {
            if (this._opened == true)
            {
                this.dispose();
            };
            this._opened = true;
            MainToolBar.Instance.unReadTask = false;
            this.showGuide();
            LayerManager.Instance.addToLayer(this, LayerManager.GAME_DYNAMIC_LAYER, false, LayerManager.BLCAK_BLOCKGOUND);
        }

        public function open():void
        {
            if ((!(this._opened)))
            {
                NewHandContainer.Instance.clearArrowByID(ArrowType.CLICK_TASK);
                this._show();
            };
        }

        private function showGuide():void
        {
            if (SavePointManager.Instance.isInSavePoint(3))
            {
                if ((!(TaskManager.instance.isNewHandTaskCompleted(1))))
                {
                    if ((!(this._showGuideOnce)))
                    {
                        this._showGuideOnce = true;
                        if ((!(this._mcTaskTarget)))
                        {
                            this._mcTaskTarget = ComponentFactory.Instance.creatCustomObject("trainer.mcTaskTarget");
                        };
                        addChild(this._mcTaskTarget);
                        NewHandContainer.Instance.showArrow(ArrowType.TASK_TARGET, 180, "trainer.taskTargetArrowPos", "", "", this);
                    };
                };
            };
            var _local_1:Array = TaskManager.instance.allCurrentQuest;
            var _local_2:uint;
            while (_local_2 < _local_1.length)
            {
                if (_local_1[_local_2].QuestID < 200)
                {
                    if (TaskManager.instance.isCompleted(_local_1[_local_2]))
                    {
                        NewHandContainer.Instance.showArrow(ArrowType.CLICK_BEAT, 0, "trainer.clickBeatArrowPos", "asset.trainer.txtGetReward", "trainer.clickBeatTipPos", this);
                    };
                };
                _local_2++;
            };
        }

        private function __onQuestBtnClicked(_arg_1:MouseEvent):void
        {
            if ((!(this.infoView.info)))
            {
                return;
            };
            SoundManager.instance.play("008");
            var _local_2:QuestInfo = this.infoView.info;
            this.finishQuest(_local_2);
            if (NewHandContainer.Instance.hasArrow(ArrowType.CLICK_BEAT))
            {
                NewHandContainer.Instance.clearArrowByID(ArrowType.CLICK_BEAT);
            };
            if (((_local_2.QuestID == 1) || (_local_2.QuestID == 101)))
            {
                NewHandContainer.Instance.clearArrowByID(ArrowType.CLICK_TASK);
                SavePointManager.Instance.setSavePoint(3);
                NewHandContainer.Instance.showArrow(ArrowType.TASK_TARGET, 225, "trainer.taskCloseArrowPos", "", "", this);
                StartupResourceLoader.Instance.addNotStartupNeededResource();
            };
            if (((_local_2.QuestID == 2) || (_local_2.QuestID == 102)))
            {
                SavePointManager.Instance.setSavePoint(5);
            };
            if (((_local_2.QuestID == 4) || (_local_2.QuestID == 104)))
            {
                if (TaskManager.instance.isNewHandTaskAchieved(5))
                {
                    SavePointManager.Instance.setSavePoint(7);
                };
            };
            if (((_local_2.QuestID == 5) || (_local_2.QuestID == 105)))
            {
                if (TaskManager.instance.isNewHandTaskAchieved(4))
                {
                    SavePointManager.Instance.setSavePoint(7);
                };
            };
            if (((_local_2.QuestID == 3) || (_local_2.QuestID == 103)))
            {
                SavePointManager.Instance.setSavePoint(11);
                SingleDungeonEvent.dispatcher.dispatchEvent(new SingleDungeonEvent(SingleDungeonEvent.WALKMAP_EXIT));
            };
            if (((_local_2.QuestID == 6) || (_local_2.QuestID == 106)))
            {
                SavePointManager.Instance.setSavePoint(10);
                TaskManager.instance.dispatchEvent(new TaskEvent(TaskEvent.BUILDING_REFLASH));
            };
            if (((_local_2.QuestID == 7) || (_local_2.QuestID == 107)))
            {
                SavePointManager.Instance.setSavePoint(9);
                TaskManager.instance.dispatchEvent(new TaskEvent(TaskEvent.BUILDING_REFLASH));
            };
            if (((_local_2.QuestID == 8) || (_local_2.QuestID == 108)))
            {
                if (TaskManager.instance.isNewHandTaskAchieved(9))
                {
                    if ((!(SavePointManager.Instance.savePoints[13])))
                    {
                        SavePointManager.Instance.setSavePoint(13);
                        MainToolBar.Instance.showIconAppear(4);
                        SingleDungeonEvent.dispatcher.dispatchEvent(new SingleDungeonEvent(SingleDungeonEvent.WALKMAP_EXIT));
                    };
                };
            };
            if (((_local_2.QuestID == 9) || (_local_2.QuestID == 109)))
            {
                if (TaskManager.instance.isNewHandTaskAchieved(8))
                {
                    if ((!(SavePointManager.Instance.savePoints[13])))
                    {
                        SavePointManager.Instance.setSavePoint(13);
                        MainToolBar.Instance.showIconAppear(4);
                        SingleDungeonEvent.dispatcher.dispatchEvent(new SingleDungeonEvent(SingleDungeonEvent.WALKMAP_EXIT));
                    };
                };
            };
            if (((_local_2.QuestID == 10) || (_local_2.QuestID == 110)))
            {
                if ((!(SavePointManager.Instance.savePoints[14])))
                {
                    SavePointManager.Instance.setSavePoint(14);
                    MainToolBar.Instance.showIconAppear(2);
                    TaskManager.instance.dispatchEvent(new TaskEvent(TaskEvent.BUILDING_REFLASH));
                };
            };
            if (((_local_2.QuestID == 11) || (_local_2.QuestID == 111)))
            {
                SavePointManager.Instance.setSavePoint(15);
            };
            if (((_local_2.QuestID == 12) || (_local_2.QuestID == 112)))
            {
                SavePointManager.Instance.setSavePoint(16);
            };
            if (((_local_2.QuestID == 13) || (_local_2.QuestID == 113)))
            {
                if ((!(SavePointManager.Instance.savePoints[17])))
                {
                    SavePointManager.Instance.setSavePoint(17);
                    TaskManager.instance.dispatchEvent(new TaskEvent(TaskEvent.ROOMLIST_REFLASH));
                };
            };
            if (((_local_2.QuestID == 14) || (_local_2.QuestID == 114)))
            {
                SavePointManager.Instance.setSavePoint(18);
            };
            if (((_local_2.QuestID == 17) || (_local_2.QuestID == 117)))
            {
                SavePointManager.Instance.setSavePoint(21);
            };
            if (((_local_2.QuestID == 18) || (_local_2.QuestID == 118)))
            {
                SavePointManager.Instance.setSavePoint(22);
                SingleDungeonEvent.dispatcher.dispatchEvent(new SingleDungeonEvent(SingleDungeonEvent.WALKMAP_EXIT));
            };
            if (((_local_2.QuestID == 19) || (_local_2.QuestID == 119)))
            {
                if (TaskManager.instance.isNewHandTaskAchieved(20))
                {
                    SavePointManager.Instance.setSavePoint(23);
                };
            };
            if (((_local_2.QuestID == 20) || (_local_2.QuestID == 120)))
            {
                if (TaskManager.instance.isNewHandTaskAchieved(19))
                {
                    SavePointManager.Instance.setSavePoint(23);
                };
            };
            if (((_local_2.QuestID == 26) || (_local_2.QuestID == 126)))
            {
                SavePointManager.Instance.setSavePoint(35);
                TaskManager.instance.dispatchEvent(new TaskEvent(TaskEvent.BUILDING_REFLASH));
            };
            if (((_local_2.QuestID == 21) || (_local_2.QuestID == 121)))
            {
                SavePointManager.Instance.setSavePoint(48);
            };
            if (((_local_2.QuestID == 22) || (_local_2.QuestID == 122)))
            {
                SavePointManager.Instance.setSavePoint(25);
            };
            if (((_local_2.QuestID == 23) || (_local_2.QuestID == 123)))
            {
                SavePointManager.Instance.setSavePoint(26);
            };
            if (((_local_2.QuestID == 24) || (_local_2.QuestID == 124)))
            {
                if (TaskManager.instance.isNewHandTaskAchieved(25))
                {
                    SavePointManager.Instance.setSavePoint(27);
                };
            };
            if (((_local_2.QuestID == 25) || (_local_2.QuestID == 125)))
            {
                if (TaskManager.instance.isNewHandTaskAchieved(24))
                {
                    SavePointManager.Instance.setSavePoint(27);
                };
            };
            if (((_local_2.QuestID == 27) || (_local_2.QuestID == 127)))
            {
                SavePointManager.Instance.setSavePoint(55);
            };
            if (((_local_2.QuestID == 28) || (_local_2.QuestID == 128)))
            {
                SavePointManager.Instance.setSavePoint(67);
                TaskManager.instance.dispatchEvent(new TaskEvent(TaskEvent.BUILDING_REFLASH));
            };
            if (_local_2.QuestID == 593)
            {
                SavePointManager.Instance.setSavePoint(69);
            };
            if (_local_2.QuestID == 250)
            {
                SavePointManager.Instance.setSavePoint(78);
            };
        }

        private function finishQuest(_arg_1:QuestInfo):void
        {
            var _local_2:Array;
            var _local_3:QuestItemReward;
            var _local_4:InventoryItemInfo;
            if (((_arg_1) && (!(_arg_1.isCompleted))))
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.task.TaskCatalogContentView.dropTaskIII"));
                this._currentCateView.active();
                return;
            };
            if (TaskManager.instance.Model.itemAwardSelected == -1)
            {
                _local_2 = [];
                for each (_local_3 in _arg_1.itemRewards)
                {
                    _local_4 = new InventoryItemInfo();
                    _local_4.TemplateID = _local_3.itemID;
                    ItemManager.fill(_local_4);
                    _local_4.ValidDate = _local_3.ValidateTime;
                    _local_4.TemplateID = _local_3.itemID;
                    _local_4.IsJudge = true;
                    _local_4.IsBinds = _local_3.isBind;
                    _local_4.AttackCompose = _local_3.AttackCompose;
                    _local_4.DefendCompose = _local_3.DefendCompose;
                    _local_4.AgilityCompose = _local_3.AgilityCompose;
                    _local_4.LuckCompose = _local_3.LuckCompose;
                    _local_4.StrengthenLevel = _local_3.StrengthenLevel;
                    _local_4.Count = _local_3.count[(_arg_1.QuestLevel - 1)];
                    if (!((!(0 == _local_4.NeedSex)) && (!(this.getSexByInt(PlayerManager.Instance.Self.Sex) == _local_4.NeedSex))))
                    {
                        if (_local_3.isOptional == 1)
                        {
                            _local_2.push(_local_4);
                        };
                    };
                };
                TryonSystemController.Instance.show(_local_2, this.chooseReward, this.cancelChoose);
                return;
            };
            if (this.infoView.info)
            {
                TaskManager.instance.sendQuestFinish(this.infoView.info.QuestID);
            };
        }

        private function getSexByInt(_arg_1:Boolean):int
        {
            if (_arg_1)
            {
                return (1);
            };
            return (2);
        }

        private function chooseReward(_arg_1:ItemTemplateInfo):void
        {
            SocketManager.Instance.out.sendQuestFinish(this.infoView.info.QuestID, _arg_1.TemplateID);
            TaskManager.instance.Model.itemAwardSelected = -1;
            var _local_2:Array = new Array();
            if (((_arg_1) && ((PlayerManager.Instance.Self.Bag.itemBagNumber + 1) <= 144)))
            {
                _local_2.push(_arg_1);
            };
            DropGoodsManager.play(_local_2);
        }

        private function cancelChoose():void
        {
            TaskManager.instance.Model.itemAwardSelected = -1;
        }

        private function __onGoDungeonClicked(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            this._goDungeonBtn.enable = false;
            if (PlayerManager.Instance.Self.Bag.getItemAt(14) == null)
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.room.RoomIIController.weapon"));
                this._goDungeonBtn.enable = true;
                return;
            };
            if (this.infoView.info.MapID > 0)
            {
                if (((StateManager.currentStateType == StateType.MATCH_ROOM) || (StateManager.currentStateType == StateType.CHALLENGE_ROOM)))
                {
                    StateManager.setState(StateType.ROOM_LIST);
                };
                setTimeout(SocketManager.Instance.out.createUserGuide, 500);
            };
        }

        private function __gotoGame(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            this._gotoGameBtn.enable = false;
            StateManager.setState(StateType.ROOM_LIST);
            setTimeout(GameInSocketOut.sendCreateRoom, 1000, RoomListBGView.PREWORD[int((Math.random() * RoomListBGView.PREWORD.length))], 0, 3);
        }

        private function __downloadClient(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            navigateToURL(new URLRequest(PathManager.solveClientDownloadPath()));
        }

        private function __buySpinelClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            if (PlayerManager.Instance.Self.bagLocked)
            {
                BaglockedManager.Instance.show();
                return;
            };
            var _local_2:ShopItemInfo = ShopManager.Instance.getMoneyShopItemByTemplateID(SPINEL);
            if (PlayerManager.Instance.Self.Money < _local_2.getItemPrice(1).moneyValue)
            {
                LeavePageManager.showFillFrame();
            }
            else
            {
                this._quick = ComponentFactory.Instance.creatComponentByStylename("ddtcore.QuickFrame");
                this._quick.setTitleText(LanguageMgr.GetTranslation("tank.view.store.matte.goldQuickBuy"));
                this._quick.itemID = SPINEL;
                this._quick.buyFrom = 7;
                this._quick.maxLimit = 3;
                LayerManager.Instance.addToLayer(this._quick, LayerManager.GAME_TOP_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
            };
        }

        override protected function __onAddToStage(_arg_1:Event):void
        {
            var _local_5:QuestCateView;
            var _local_6:QuestCateView;
            super.__onAddToStage(_arg_1);
            var _local_2:int = -1;
            var _local_3:int;
            while (_local_3 < this.cateViewArr.length)
            {
                _local_5 = (this.cateViewArr[_local_3] as QuestCateView);
                _local_5.initData();
                _local_3++;
            };
            var _local_4:int;
            while (_local_4 < this.cateViewArr.length)
            {
                _local_6 = (this.cateViewArr[_local_4] as QuestCateView);
                _local_6.initData();
                if (_local_6.data.haveCompleted)
                {
                    _local_6.active();
                    return;
                };
                if (((_local_6.length > 0) && (_local_2 < 0)))
                {
                    _local_2 = _local_4;
                    _local_6.active();
                };
                _local_4++;
            };
        }

        override public function dispose():void
        {
            var _local_1:QuestCateView;
            NewHandContainer.Instance.clearArrowByID(ArrowType.TASK_TARGET);
            if ((!(SavePointManager.Instance.savePoints[86])))
            {
                SavePointManager.Instance.setSavePoint(86);
            };
            TaskManager.instance.removeNewQuestMovie();
            this.removeEvent();
            this._currentCateView = null;
            this.currentNewCateView = null;
            while ((_local_1 = this.cateViewArr.pop()))
            {
                _local_1.removeEventListener(QuestCateView.TITLECLICKED, this.__onTitleClicked);
                _local_1.removeEventListener(QuestCateView.ENABLE_CHANGE, this.__onEnbleChange);
                _local_1.removeEventListener(Event.CHANGE, this.__onCateViewChange);
                _local_1.dispose();
                _local_1 = null;
            };
            ObjectUtils.disposeObject(this.leftPanelContent);
            this.leftPanelContent = null;
            ObjectUtils.disposeObject(this.leftPanel);
            this.leftPanel = null;
            if (this._titleBmp)
            {
                ObjectUtils.disposeObject(this._titleBmp);
            };
            this._titleBmp = null;
            if (((this._quick) && (this._quick.canDispose)))
            {
                this._quick.dispose();
            };
            this._quick = null;
            if (this.infoView)
            {
                this.infoView.dispose();
            };
            this.infoView = null;
            if (this._questBtn)
            {
                ObjectUtils.disposeObject(this._questBtn);
            };
            this._questBtn = null;
            if (this._guildBtn)
            {
                ObjectUtils.disposeObject(this._guildBtn);
            };
            this._guildBtn = null;
            if (this._goDungeonBtnShine)
            {
                ObjectUtils.disposeObject(this._goDungeonBtnShine);
            };
            this._goDungeonBtnShine = null;
            if (this._downClientShine)
            {
                ObjectUtils.disposeObject(this._downClientShine);
            };
            this._downClientShine = null;
            if (this._questBtnShine)
            {
                ObjectUtils.disposeObject(this._questBtnShine);
            };
            this._questBtnShine = null;
            if (this._guildBtnShine)
            {
                ObjectUtils.disposeObject(this._guildBtnShine);
            };
            this._guildBtnShine = null;
            if (this._mcTaskTarget)
            {
                ObjectUtils.disposeObject(this._mcTaskTarget);
            };
            this._mcTaskTarget = null;
            if (this._rightBottomBg)
            {
                ObjectUtils.disposeObject(this._rightBottomBg);
            };
            this._rightBottomBg = null;
            if (this._rightBGStyleNormal)
            {
                ObjectUtils.disposeObject(this._rightBGStyleNormal);
            };
            this._rightBGStyleNormal = null;
            if (this._goDungeonBtn)
            {
                ObjectUtils.disposeObject(this._goDungeonBtn);
            };
            this._goDungeonBtn = null;
            if (this._downloadClientBtn)
            {
                ObjectUtils.disposeObject(this._downloadClientBtn);
            };
            this._downloadClientBtn = null;
            if (this._gotoGameBtn)
            {
                ObjectUtils.disposeObject(this._gotoGameBtn);
                this._gotoGameBtn = null;
            };
            this._opened = false;
            TaskManager.instance.Model.selectedQuest = null;
            TaskManager.instance.Model.taskViewIsShow = false;
            NewHandContainer.Instance.clearArrowByID(ArrowType.GET_REWARD);
            MainToolBar.Instance.tipTask();
            super.dispose();
            if (parent)
            {
                parent.removeChild(this);
            };
            dispatchEvent(new TaskEvent(TaskEvent.TASK_FRAME_HIDE));
        }


    }
}//package quest

